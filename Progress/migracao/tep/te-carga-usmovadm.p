/* -------------------------------------------------- DEFINICAO DA INCLUDE DA API USMOVADM --- */
{api/api-usmovadm.i}.

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
{hdp/hdrunpersis.iv "new"}

def var h-api-usmovadm-aux               as handle                     no-undo.
DEF VAR lg-erro-aux AS LOG INIT NO NO-UNDO.
{hdp/hdrunpersis.i "api/api-usmovadm.p" "h-api-usmovadm-aux"}

ETIME(TRUE).

OUTPUT TO c:\temp\erros-te-carga-usmovadm.csv.
PUT UNFORMATTED "MODALIDADE;"
                "TERMO;"
                "USUARIO;"
                "COD.MENSAGEM;"
                "MENSAGEM;"
                "COMPLEMENTO;"
                "TIPO;"
                "CHAVE" SKIP.

FOR EACH import-bnfciar fields(cd-carteira-antiga) NO-LOCK,
   FIRST usuario FIELDS (cd-sit-usuario
                         cd-usuario
                         cd-modalidade
                         nr-proposta
                         cd-padrao-cobertura
                         nr-ter-adesao) WHERE usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-antiga
                                          AND cd-sit-usuario >= 5 NO-LOCK:

    IF usuario.cd-usuario = 0 THEN NEXT.
    RUN cria-usmovadm.
END.
OUTPUT CLOSE.

IF lg-erro-aux
THEN run escrever-log("Ocorreram erros. Verifique arquivo c:\temp\erros-te-carga-usmovadm.csv. " + string(ETIME / 1000) + " segundos.").
ELSE run escrever-log("Processo concluido com sucesso. " + string(ETIME / 1000) + " segundos.").

quit.
    
PROCEDURE cria-usmovadm:

    /* ---------------------------------------------------- ATUALIZACA0 DA USMOVADM --- */
    IF CAN-FIND(FIRST pro-pla
                WHERE pro-pla.cd-modalidade = usuario.cd-modalidade
                  and pro-pla.nr-proposta   = usuario.nr-proposta
                  AND CAN-FIND(FIRST mod-cob
                               WHERE mod-cob.cd-modulo = pro-pla.cd-modulo
                                 AND mod-cob.lg-produto-externo))
    THEN DO:
           EMPTY TEMP-TABLE tmp-par-usmovadm.

           create tmp-par-usmovadm.
           assign tmp-par-usmovadm.in-funcao            = "LIB"
                  tmp-par-usmovadm.lg-prim-mens         = yes
                  tmp-par-usmovadm.lg-simula            = no
                  tmp-par-usmovadm.lg-devolve-dados     = no
                  tmp-par-usmovadm.cd-modalidade        = usuario.cd-modalidade
                  tmp-par-usmovadm.nr-proposta          = usuario.nr-proposta 
                  tmp-par-usmovadm.cd-usuario           = usuario.cd-usuario
                  tmp-par-usmovadm.cd-padrao-cobertura  = usuario.cd-padrao-cobertura
                  tmp-par-usmovadm.cd-userid            = "migracao" /*v_cod_usuar_corren*/.

           run api-usmovadm in h-api-usmovadm-aux (input-output table tmp-usmovadm,
                                                   input-output table tmp-par-usmovadm,
                                                   output       table tmp-msg-usmovadm,
                                                   input        no).

           if   return-value = "erro"
           then for each tmp-msg-usmovadm:
                    
                    /*IGNORAR SE FOR O ERRO 1220-Beneficiario ja possui movimentacao na tabela de modulos externos*/
                    IF tmp-msg-usmovadm.cd-mensagem = 1220 THEN NEXT.
                  
                    PUT UNFORMATTED usuario.cd-modalidade ";"
                                    usuario.nr-ter-adesao ";"
                                    usuario.cd-usuario ";"
                                    tmp-msg-usmovadm.cd-mensagem ";"
                                    tmp-msg-usmovadm.ds-mensagem ";"
                                    tmp-msg-usmovadm.ds-complemento ";"
                                    tmp-msg-usmovadm.in-tipo-mensagem ";"
                                    tmp-msg-usmovadm.ds-chave SKIP.
                    ASSIGN lg-erro-aux = YES.
                end.
           ELSE DO:
                  
           END.

         END.

END PROCEDURE.

PROCEDURE escrever-log:
    DEF INPUT PARAMETER ds-mens-aux AS CHAR NO-UNDO.
END.
