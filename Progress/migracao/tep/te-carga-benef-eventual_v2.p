/*
 * Existe a V1 que chama a BO de produto (recomendada). Caso nao seja possivel usar a V1, usar essa, que cria os registros diretamente mas abre risco
 * de ficar desatualizada por ter logica fixa.
 *
 * 28/05/2018 - tratado para forcar codigo 1 para beneficiario eventual.
 */

DEF VAR id-pessoa-aux AS DEC NO-UNDO.
DEF VAR ix-aux AS INT INIT 0 NO-UNDO.
DEF VAR cd-aux AS INT NO-UNDO.
def var nm-arquivo-aux as char no-undo.
ETIME(TRUE).


nm-arquivo-aux = "c:\temp\erros-beneficiario-eventual_" + string(year(today)) + string(month(today)) + string(day(today)) + "_" + replace(string(time,"HH:MM:SS"),":","") + ".csv".

output to value(nm-arquivo-aux).

FIND FIRST paramecp NO-LOCK NO-ERROR.
IF NOT AVAIL paramecp
THEN DO:
       put unformatted "nao encontrou PARAMECP" skip.
	   output close.
       RETURN.
     END.

PUT UNFORMATTED "MODALIDADE;PROPOSTA;USUARIO;MENSAGEM" SKIP.

FOR EACH propost NO-LOCK,
   FIRST import-propost fields(num-livre-3) NO-LOCK 
   WHERE import-propost.num-seqcial-propost = dec(propost.nr-contrato-antigo),
   FIRST ter-ade FIELDS (dt-inicio dt-validade-cart) NO-LOCK
   WHERE ter-ade.cd-modalidade = propost.cd-modalidade
     AND ter-ade.nr-ter-adesao = propost.nr-ter-adesao:

    if propost.log-11 
    AND propost.cd-sit-proposta >= 5
    AND propost.cd-sit-proposta <= 7
    then do:
           /* proposta ja tem beneficiario eventual */
           IF CAN-FIND(first usuario
                       where usuario.cd-modalidade    = propost.cd-modalidade
                         and usuario.nr-proposta      = propost.nr-proposta
                         and usuario.log-17           = yes)
           THEN NEXT.

           IF CAN-FIND(FIRST usuario WHERE usuario.cd-modalidade = propost.cd-modalidade
                                       AND usuario.nr-proposta   = propost.nr-proposta
                                       AND usuario.cd-usuario    = 1)
           THEN DO:
                  PUT UNFORMATTED propost.cd-modalidade ";" propost.nr-proposta ";1;" "PROPOSTA JA POSSUI BENEFICIARIO COM CODIGO 1. BENEFICIARIO EVENTUAL NAO SERA CRIADO" SKIP.
                  NEXT.
                END.

           ix-aux = ix-aux + 1.
           
           CREATE usuario.
           ASSIGN usuario.cd-unimed                = paramecp.cd-unimed                                          
                  usuario.cd-modalidade            = propost.cd-modalidade                                       
                  usuario.nr-proposta              = propost.nr-proposta                                         
                  usuario.nr-ter-adesao            = propost.nr-ter-adesao                                       
                  usuario.cd-usuario               = 1
                  usuario.cd-titular               = 1
                  usuario.nm-usuario               = "Usuario Eventual"                                          
                  usuario.cd-grau-parentesco       = 1 /* titular */                                             
                  usuario.dt-nascimento            = 01/01/1980                                                  
                  usuario.log-17                   = yes                  /* LOG USUARIO EVENTUAL */             
                  usuario.nr-identidade            = "00000000000000"                                            
                  usuario.dt-inclusao-plano        = ter-ade.dt-inicio                                           
                  usuario.cd-transacao             = "AD"                                                        
                  usuario.lg-carencia              = no                                                          
                  usuario.cd-vendedor              = propost.cd-vendedor                                         
                  usuario.ds-orgao-emissor-ident   = ""                                                          
                  usuario.nm-pais                  = ""                                                          
                  usuario.nr-identidade            = ""                                                          
                  usuario.cd-cpf                   = ""                                                          
                  usuario.cd-pis-pasep             = 0                                                           
                  usuario.nm-mae                   = ""                                                          
                  usuario.in-est-civil             = 1                                                           
                  usuario.in-segmento-assistencial = 0                                                           
                  usuario.lg-sexo                  = yes                                                         
                  usuario.in-via-transferencia     = "N"                                                         
                  usuario.cd-modalidade-anterior   = 0                                                           
                  usuario.nr-proposta-anterior     = 0                                                           
                  usuario.cd-usuario-anterior      = 0                                                           
                  usuario.lg-insc-fatura           = no                                                          
                  usuario.cd-userid                = "migracao"                                                  
                  usuario.cd-userid-inclusao       = "migracao"                                                  
                  usuario.cd-userid-carencia       = "migracao"
                  usuario.cd-sit-usuario           = propost.cd-sit-proposta
                  usuario.cd-carteira-antiga       = DEC(string(import-propost.num-livre-3,"9999") + "000000000").

           create car-ide.
           assign car-ide.cd-unimed           = usuario.cd-unimed
                  car-ide.cd-modalidade       = usuario.cd-modalidade
                  car-ide.nr-ter-adesao       = usuario.nr-ter-adesao
                  car-ide.cd-usuario          = usuario.cd-usuario
                  car-ide.nr-carteira         = 1 /*nr-via-carteira-aux*/
                  car-ide.dv-carteira         = 0
                  car-ide.ds-observacao [1]   = ""
                  car-ide.ds-observacao [2]   = ""
                  car-ide.ds-observacao [3]   = ""
                  car-ide.dt-atualizacao      = today
                  car-ide.cd-userid           = "migracao"
                  car-ide.cd-carteira-antiga  = usuario.cd-carteira-antiga
                  car-ide.cd-carteira-inteira = usuario.cd-carteira-antiga
                  car-ide.dt-validade         = ter-ade.dt-validade-cart
                  car-ide.cd-sit-carteira     = 1
                  car-ide.nr-impressao        = 1
                  car-ide.dt-emissao          = TODAY.

           /* Proposta com participacao */
           if propost.cd-tipo-participacao = 2     
           then assign usuario.lg-cobra-fator-moderador = yes.
           else assign usuario.lg-cobra-fator-moderador = no.

           FIND FIRST propcopa NO-LOCK 
                WHERE propcopa.cd-modalidade = propost.cd-modalidade
                  AND propcopa.nr-proposta   = propost.nr-proposta NO-ERROR.
           IF AVAIL propcopa
           THEN ASSIGN usuario.cd-padrao-cobertura = propcopa.cd-padrao-cobertura.

           /* criar a pessoa fisica */
           find first pessoa-fisica use-index pfis3
                where pessoa-fisica.nm-pessoa begins trim(usuario.nm-usuario) no-lock no-error.
           
           if avail pessoa-fisica
           then do:
                   assign usuario.id-pessoa = pessoa-fisica.id-pessoa.
                end.
           ELSE DO:
                  create pessoa-fisica.
                  
                  repeat:
                     assign pessoa-fisica.id-pessoa = next-value(seq-pessoa) no-error.
                     if not error-status:error
                     then leave.
                     process events.
                  end.
                  
                  assign pessoa-fisica.nm-pessoa                = TRIM(usuario.nm-usuario)
                         pessoa-fisica.cd-cpf                   = ""        
                         pessoa-fisica.dt-nascimento            = usuario.dt-nascimento 
                         pessoa-fisica.in-estado-civil          = 1
                         pessoa-fisica.lg-sexo                  = yes          
                         pessoa-fisica.nr-identidade            = ""
                         pessoa-fisica.uf-emissor-ident         = ""           
                         pessoa-fisica.nm-cartao                = ""
                         pessoa-fisica.nm-internacional         = ""
                         pessoa-fisica.ds-nacionalidade         = ""   
                         pessoa-fisica.ds-natureza-doc          = ""
                         pessoa-fisica.nr-pis-pasep             = 0
                         pessoa-fisica.nm-mae                   = ""
                         pessoa-fisica.nm-pai                   = ""
                         pessoa-fisica.nm-conjuge               = ""
                         pessoa-fisica.ds-orgao-emissor-ident   = ""
                         pessoa-fisica.nm-pais-emissor-ident    = ""
                         pessoa-fisica.dt-emissao-ident         = ?
                         pessoa-fisica.nr-cei                   = ""
                         pessoa-fisica.cd-cartao-nacional-saude = 0
                         pessoa-fisica.log-1                    = false
                         pessoa-fisica.cd-userid                = "migracao"
                         pessoa-fisica.dt-atualizacao           = today
                         pessoa-fisica.char-2                   = ""
                         pessoa-fisica.nom-prim                 = usuario.nm-usuario 
                         pessoa-fisica.int-1                    = 0
                         pessoa-fisica.log-2                    = false
                         pessoa-fisica.log-3                    = false
                         pessoa-fisica.log-4                    = false.
                  
                  assign usuario.id-pessoa = pessoa-fisica.id-pessoa.
                END.
         END.
END.

put unformatted "Concluido! " SKIP "tempo decorrido: " ETIME / 1000 "(segundos)" SKIP(1)
    ix-aux " beneficiarios eventuais criados." skip.

OUTPUT CLOSE.

quit.
