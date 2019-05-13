/* 13/12/2018 - Alex Boeira - ha um problema ainda nao identificado no migrador: alguns modulos agregados deixam de serem criados.
 *              esse programa corrige essa situacao (executar ao final do processo caso o problema tenha se manifestado).
 *         OBS: o metodo CRIA-MODULOS-BENEF foi adaptado de cgp/cg0311v.p
 */
DEF TEMP-TABLE tmp-carteiras NO-UNDO
    FIELD cd-carteira-usuario AS DEC
    INDEX i1
          cd-carteira-usuario.

DEF BUFFER b-import-bnfciar FOR import-bnfciar.

DEF VAR lg-gerar-termo-aux AS LOG INIT TRUE NO-UNDO.
DEF VAR ix-aux AS INT INIT 0 NO-UNDO.

RUN popular-temp-usuarios.
RUN cria-modulos-benef.

PROCEDURE cria-modulos-benef:

    /**
     * Variaveis para controle de carencia e checagem se sera necessario criar USUCAREN.
     */
    DEF VAR nr-dias-aux   AS INT  NO-UNDO.
    DEF VAR dt-inicio-aux AS date NO-UNDO.
    DEF VAR dt-cancel-aux AS date NO-UNDO.
    DEF VAR lg-criar-usucaren-aux AS LOG NO-UNDO.

    /**
     * Alex Boeira - 01/12/2016 IMPORT-MODUL-BNFCIAR.NUM-LIVRE-1 foi adicionado na chave, para diferenciar os casos em que existem 2 beneficiarios
     *                          com mesmo NUM-SEQCIAL-BNFCIAR - Demitidos/Aposentados (um registro do plano na empresa, outro do plano DEMAP).
     */
    FOR EACH tmp-carteiras NO-LOCK,
       FIRST b-import-bnfciar NO-LOCK
       WHERE b-import-bnfciar.cd-carteira-antiga = tmp-carteiras.cd-carteira-usuario
         AND b-import-bnfciar.ind-sit-import = "IT",
        EACH import-modul-bnfciar no-lock
       WHERE import-modul-bnfciar.num-seqcial-bnfciar = b-import-bnfciar.num-seqcial-bnfciar
         AND import-modul-bnfciar.num-livre-1         = b-import-bnfciar.num-seqcial-control
         AND NOT CAN-FIND(FIRST usumodu
                                 where usumodu.cd-modalidade = b-import-bnfciar.cd-modalidade
                                   and usumodu.nr-proposta   = b-import-bnfciar.nr-proposta
                                   AND usumodu.cd-usuario    = b-import-bnfciar.num-livre-6
                                   and usumodu.cd-modulo     = import-modul-bnfciar.cdn-modul)
        AND NOT CAN-FIND(FIRST pro-pla
                                        where pro-pla.cd-modalidade = b-import-bnfciar.cd-modalidade
                                          and pro-pla.nr-proposta = b-import-bnfciar.nr-proposta
                                          and pro-pla.cd-modulo = import-modul-bnfciar.cdn-modul
                                          and pro-pla.lg-cobertura-obrigatoria = true),
        FIRST usuario NO-LOCK
        WHERE usuario.cd-modalidade = b-import-bnfciar.cd-modalidade
          AND usuario.nr-proposta   = b-import-bnfciar.nr-proposta
          AND usuario.cd-usuario    = b-import-bnfciar.num-livre-6,
        FIRST propost NO-LOCK
        WHERE propost.cd-modalidade = usuario.cd-modalidade
          AND propost.nr-proposta   = usuario.nr-proposta,
        FIRST ter-ade NO-LOCK
        WHERE ter-ade.cd-modalidade = propost.cd-modalidade
          AND ter-ade.nr-ter-adesao = propost.nr-ter-adesao,
       first pla-mod NO-LOCK
       where pla-mod.cd-modalidade = propost.cd-modalidade  
         and pla-mod.cd-plano      = propost.cd-plano       
         and pla-mod.cd-tipo-plano = propost.cd-tipo-plano  
         and pla-mod.cd-modulo     = import-modul-bnfciar.cdn-modul,
        last pro-pla use-index pro-pla3 NO-LOCK
       where pro-pla.cd-modalidade = b-import-bnfciar.cd-modalidade
         and pro-pla.nr-proposta   = propost.nr-proposta
         and pro-pla.cd-modulo     = import-modul-bnfciar.cdn-modul,
       FIRST ti-pl-sa NO-LOCK
       where ti-pl-sa.cd-modalidade = propost.cd-modalidade
         and ti-pl-sa.cd-plano      = propost.cd-plano
         and ti-pl-sa.cd-tipo-plano = propost.cd-tipo-plano:
                    
        ix-aux = ix-aux + 1.
        RUN escrever-log("@@@@@CONTADOR BENEFICIARIOS PROCESSADOS: " + STRING(ix-aux)).

        RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P31. MODULO: " + STRING(import-modul-bnfciar.cdn-modul)).

        ASSIGN nr-dias-aux    = 0
               dt-inicio-aux  = ?
               dt-cancel-aux  = ?.

        if  ti-pl-sa.lg-usa-padrao-cobertura
        then do:

            RUN escrever-log("@@@@@CRIA-BENEFICIARIO P1. PADRAO COBERTURA: " + b-import-bnfciar.cd-padrao-cob).

            /*------------------------------------------------------------------------*/
            if b-import-bnfciar.cd-padrao-cob <> ""
            then do: 
                   FOR EACH usumodu
                      where usumodu.cd-modalidade   = pro-pla.cd-modalidade  
                        and usumodu.nr-proposta     = pro-pla.nr-proposta 
                        and usumodu.cd-usuario      = usuario.cd-usuario 
                        AND usumodu.cd-modulo       = import-modul-bnfciar.cdn-modul EXCLUSIVE-LOCK:
                            RUN escrever-log("@@@@@CRIA-BENEFICIARIO P2 - DELETE USUMODU").
                            DELETE usumodu.
                   END.

                   for each propcopa FIELDS (cd-modalidade nr-proposta cd-modulo)
                      where propcopa.cd-modalidade       = propost.cd-modalidade
                        and propcopa.nr-proposta         = propost.nr-proposta  
                        and propcopa.cd-padrao-cobertura = b-import-bnfciar.cd-padrao-cob       
                        AND propcopa.cd-modulo           = import-modul-bnfciar.cdn-modul
                            NO-LOCK:

                       find first usumodu
                            where usumodu.cd-modalidade   = pro-pla.cd-modalidade  
                              and usumodu.nr-proposta     = pro-pla.nr-proposta 
                              and usumodu.cd-usuario      = usuario.cd-usuario 
                              and usumodu.cd-modulo       = pro-pla.cd-modulo  
                              and usumodu.dt-cancelamento = b-import-bnfciar.dt-exclusao-plano no-lock no-error.

                       if not avail usumodu
                       then do:
                              create usumodu.                                       
                              assign usumodu.cd-modulo          = pro-pla.cd-modulo          
                                     usumodu.cd-modalidade      = pro-pla.cd-modalidade  
                                     usumodu.nr-proposta        = pro-pla.nr-proposta      
                                     usumodu.cd-usuario         = usuario.cd-usuario        
                                     usumodu.cd-userid          = "migracao*"
                                     usumodu.dt-atualizacao     = today                 
                                     usumodu.cd-userid-inclusao = "migracao*"
                                     usumodu.dt-mov-inclusao    = today                
                                     usumodu.dt-inicio          = if   b-import-bnfciar.dt-inclusao-plano > pro-pla.dt-inicio
                                                                  then b-import-bnfciar.dt-inclusao-plano
                                                                  else pro-pla.dt-inicio      
                                     usumodu.dt-cancelamento    = b-import-bnfciar.dt-exclusao-plano    
                                     usumodu.aa-ult-fat         = b-import-bnfciar.aa-ult-fat-period            
                                     usumodu.mm-ult-fat         = b-import-bnfciar.num-mes-ult-faturam            
                                     usumodu.dt-mov-exclusao    = b-import-bnfciar.dt-exclusao-plano    
                                     usumodu.cd-userid-exclusao = if b-import-bnfciar.dt-exclusao-plano <> ?         
                                                                  then "migracao*"
                                                                  else "".

                              IF lg-gerar-termo-aux
                              THEN DO:
                                     /* --------------------------- MODULO COM CANCELAMENTO --- */
                                     if   usumodu.dt-cancelamento <> ?
                                     then do:
                                            /* --------------------------- MODULO CANCELADO --- */
                                            if   usumodu.dt-cancelamento < today
                                            then assign usumodu.cd-sit-modulo = 90.
                                            /* --------- MODULO COM CANCELAMENTO PROGRAMADO --- */
                                            else assign usumodu.cd-sit-modulo = 7.
                                          end.
                                     /* -------------------------------------- MODULO ATIVO --- */
                                     else ASSIGN usumodu.cd-sit-modulo = 7.

                                     /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                                     if   propost.dt-libera-doc <> ?
                                     then assign usumodu.dt-fim = propost.dt-libera-doc.
                                     else assign usumodu.dt-fim = ter-ade.dt-fim.


                                     if   usumodu.dt-inicio = ?                        
                                     then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                                     if   usumodu.dt-inicio = usumodu.dt-cancelamento
                                     then assign usumodu.aa-pri-fat = 0
                                                 usumodu.mm-pri-fat = 0.
                                     else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                                                 usumodu.mm-pri-fat = month(usumodu.dt-inicio).
                                   END.
                            end.                        
                   end.     

                   /* ------ CRIACAO DO MODULO AUTOMATICO --- */
                   /*FOR EACH pla-mod FIELDS (cd-modalidade cd-plano cd-tipo-plano cd-modulo)
                      where pla-mod.cd-modalidade = propost.cd-modalidade 
                        and pla-mod.cd-plano      = propost.cd-plano
                        and pla-mod.cd-tipo-plano = propost.cd-tipo-plano
                        and pla-mod.lg-grava-automatico 
                            NO-LOCK,

                       first pro-pla FIELDS (lg-cobertura-obrigatoria cd-modulo cd-modalidade nr-proposta dt-inicio) 
                       where pro-pla.cd-modalidade = propost.cd-modalidade
                         and pro-pla.nr-proposta   = propost.nr-proposta
                         and pro-pla.cd-modulo     = pla-mod.cd-modulo 
                         AND NOT pro-pla.lg-cobertura-obrigatoria
                             NO-LOCK, 

                       FIRST mod-cob 
                       where mod-cob.cd-modulo = pla-mod.cd-modulo
                         AND mod-cob.in-identifica-modulo = "S" NO-LOCK,
                       FIRST paramdsg FIELDS (in-grau-considerado nr-idade-maxima)
                       where paramdsg.cd-chave-primaria = paravpmc.cd-chave-primaria                                             
                         and paramdsg.cd-modalidade     = pla-mod.cd-modalidade                                                  
                         and paramdsg.cd-plano          = pla-mod.cd-plano                                                       
                         and paramdsg.cd-tipo-plano     = pla-mod.cd-tipo-plano                                                  
                         and paramdsg.cd-modulo         = pla-mod.cd-modulo NO-LOCK QUERY-TUNING (NO-INDEX-HINT):   

                             assign lg-inclui-automatico-aux = yes.

                             if  (usuario.cd-titular = usuario.cd-usuario  and paramdsg.in-grau-considerado >= 0)                                              
                             or  (usuario.cd-titular <> usuario.cd-usuario and paramdsg.in-grau-considerado = 0)                                               
                             then do:                                                                            
                                    if   paramdsg.nr-idade-maxima <> 0    
                                    AND tt-import-bnfciar.nr-idade-usuario > paramdsg.nr-idade-maxima 
                                    then assign lg-inclui-automatico-aux = no.                                                                    
                                  end.                                                                           
                             else assign lg-inclui-automatico-aux = no.                                                                          

                             if   lg-inclui-automatico-aux
                             then do:
                                    find first usumodu
                                         where usumodu.cd-modalidade   = pro-pla.cd-modalidade  
                                           and usumodu.nr-proposta     = pro-pla.nr-proposta 
                                           and usumodu.cd-usuario      = usuario.cd-usuario 
                                           and usumodu.cd-modulo       = pro-pla.cd-modulo  
                                           and usumodu.dt-cancelamento = b-import-bnfciar.dt-exclusao-plano no-lock no-error.

                                    if not avail usumodu
                                    then do:
                                           create usumodu.                                       
                                           assign usumodu.cd-modulo          = pro-pla.cd-modulo          
                                                  usumodu.cd-modalidade      = pro-pla.cd-modalidade  
                                                  usumodu.nr-proposta        = pro-pla.nr-proposta      
                                                  usumodu.cd-usuario         = usuario.cd-usuario
                                                  usumodu.cd-userid          = v_cod_usuar_corren         
                                                  usumodu.dt-atualizacao     = today                 
                                                  usumodu.cd-userid-inclusao = v_cod_usuar_corren
                                                  usumodu.dt-mov-inclusao    = today                
                                                  usumodu.dt-inicio          = if   b-import-bnfciar.dt-inclusao-plano > pro-pla.dt-inicio
                                                                               then b-import-bnfciar.dt-inclusao-plano
                                                                               else pro-pla.dt-inicio         
                                                  usumodu.dt-cancelamento    = b-import-bnfciar.dt-exclusao-plano    
                                                  usumodu.aa-ult-fat         = b-import-bnfciar.aa-ult-fat-period            
                                                  usumodu.mm-ult-fat         = b-import-bnfciar.num-mes-ult-faturam            
                                                  usumodu.dt-mov-exclusao    = b-import-bnfciar.dt-exclusao-plano    
                                                  usumodu.cd-userid-exclusao = if   b-import-bnfciar.dt-exclusao-plano <> ?         
                                                                               then v_cod_usuar_corren           
                                                                               else "".        

                                           IF lg-gerar-termo-aux
                                           THEN DO:
                                                  /* --------------------------- MODULO COM CANCELAMENTO --- */
                                                  if   usumodu.dt-cancelamento <> ?
                                                  then do:
                                                         /* --------------------------- MODULO CANCELADO --- */
                                                         if   usumodu.dt-cancelamento < today
                                                         then assign usumodu.cd-sit-modulo = 90.
                                                         /* --------- MODULO COM CANCELAMENTO PROGRAMADO --- */
                                                         else assign usumodu.cd-sit-modulo = 7.
                                                       end.
                                                  /* -------------------------------------- MODULO ATIVO --- */
                                                  else ASSIGN usumodu.cd-sit-modulo = 7.

                                                  /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                                                  if   propost.dt-libera-doc <> ?
                                                  then assign usumodu.dt-fim = propost.dt-libera-doc.
                                                  else assign usumodu.dt-fim = ter-ade.dt-fim.


                                                  if   usumodu.dt-inicio = ?                        
                                                  then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                                                  if   usumodu.dt-inicio = usumodu.dt-cancelamento
                                                  then assign usumodu.aa-pri-fat = 0
                                                              usumodu.mm-pri-fat = 0.
                                                  else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                                                              usumodu.mm-pri-fat = month(usumodu.dt-inicio).
                                                END.
                                         end.
                                  end.
                   end. /* for each */*/
                 end. /* if cd-padrao-cob-imp <> "" */




               RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P32").

                      /**
                       * Inclusao dos modulos agregados.
                       * ATENCAO: os modulos opcionais do Padrao de Cobertura ja foram criados
                       * no metodo de criacao do Beneficiario.
                       */
                      if  pro-pla.lg-cobertura-obrigatoria = no
                      AND pla-mod.lg-modulo-agregado
                      then do:
                             RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P4 - CRIANDO AGREGADO").
                             create usumodu.
                             assign usumodu.cd-modalidade      = b-import-bnfciar.cd-modalidade
                                    usumodu.nr-proposta        = pro-pla.nr-proposta
                                    usumodu.cd-usuario         = b-import-bnfciar.num-livre-6
                                    usumodu.cd-modulo          = import-modul-bnfciar.cdn-modul
                                    usumodu.cd-userid          = "migracao*"
                                    usumodu.dt-atualizacao     = today
                                    usumodu.cd-userid-inclusao = "migracao*"
                                    usumodu.dt-mov-inclusao    = today
                                    usumodu.cd-sit-modulo      = 01                                                           
                                    usumodu.dt-inicio          = import-modul-bnfciar.dat-inic
                                    dt-inicio-aux              = import-modul-bnfciar.dat-inic
                                    usumodu.dt-cancelamento    = import-modul-bnfciar.dat-fim
                                    dt-cancel-aux              = import-modul-bnfciar.dat-fim
                                    usumodu.cd-motivo-cancel   = import-modul-bnfciar.cdn-motiv-cancel
                                    usumodu.aa-ult-fat         = b-import-bnfciar.aa-ult-fat-period  
                                    usumodu.mm-ult-fat         = b-import-bnfciar.num-mes-ult-faturam.

                             IF lg-gerar-termo-aux
                             THEN DO:
                                    /* --------------------------- MODULO COM CANCELAMENTO --- */
                                    if   usumodu.dt-cancelamento <> ?
                                    then do:
                                           /* --------------------------- MODULO CANCELADO --- */
                                           if   usumodu.dt-cancelamento < today
                                           then assign usumodu.cd-sit-modulo = 90.
                                           /* --------- MODULO COM CANCELAMENTO PROGRAMADO --- */
                                           else assign usumodu.cd-sit-modulo = 7.
                                         end.
                                    /* -------------------------------------- MODULO ATIVO --- */
                                    else ASSIGN usumodu.cd-sit-modulo = 7.

                                    /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                                    if   propost.dt-libera-doc <> ?
                                    then assign usumodu.dt-fim = propost.dt-libera-doc.
                                    else assign usumodu.dt-fim = ter-ade.dt-fim.

                                    if   usumodu.dt-inicio = ?                        
                                    then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                                    if   usumodu.dt-inicio = usumodu.dt-cancelamento
                                    then assign usumodu.aa-pri-fat = 0
                                                usumodu.mm-pri-fat = 0.
                                    else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                                                usumodu.mm-pri-fat = month(usumodu.dt-inicio).
                                  END.
                            end.
                       ELSE do:
                              IF usuario.dt-inclusao-plano > pro-pla.dt-inicio
                              THEN dt-inicio-aux = usuario.dt-inclusao-plano.
                              ELSE dt-inicio-aux = pro-pla.dt-inicio.
                                  
                              IF usuario.dt-exclusao-plano <> ?
                              THEN dt-cancel-aux = usuario.dt-exclusao-plano.

                              IF pro-pla.dt-cancelamento <> ?
                              AND (pro-pla.dt-cancelamento < dt-cancel-aux OR dt-cancel-aux = ?)
                              THEN ASSIGN dt-cancel-aux = pro-pla.dt-cancelamento.
                            END.
                      /**
                       * Somente criar USUCAREN para beneficiarios ativos e com flag de carencia ligado.
                       */
                      IF lg-criar-usucaren-aux
                      THEN DO:
                             if  avail usumodu OR pro-pla.lg-cobertura-obrigatoria
                             then do:
                                    find usucaren where usucaren.cd-modalidade = pro-pla.cd-modalidade
                                                    and usucaren.nr-proposta = pro-pla.nr-proposta
                                                    and usucaren.cd-usuario  = b-import-bnfciar.num-livre-6
                                                    and usucaren.cd-modulo   = pro-pla.cd-modulo
                                                        exclusive-lock no-error.
                                    if not avail usucaren
                                    then do:        
                                           create usucaren.
                                           assign usucaren.cd-modalidade = pro-pla.cd-modalidade
                                                  usucaren.nr-proposta   = pro-pla.nr-proposta
                                                  usucaren.cd-usuario    = b-import-bnfciar.num-livre-6
                                                  usucaren.cd-modulo     = pro-pla.cd-modulo.
                                         end.
                                    assign usucaren.nr-dias     = import-modul-bnfciar.nr-dias
                                           usucaren.lg-carencia = import-modul-bnfciar.log-carenc
                                           usucaren.lg-bonifica-penaliza = import-modul-bnfciar.log-bonif-penalid.
                                  end.
                           END.
             end.

        else do: /* nao usa padrao */
               
               /*find last usumodu
                   where usumodu.cd-modalidade = pro-pla.cd-modalidade
                     and usumodu.nr-proposta   = pro-pla.nr-proposta
                     and usumodu.cd-usuario    = ct-codigo
                     and usumodu.cd-modulo     = import-modul-bnfciar.cdn-modul
                         no-lock no-error.

               if not avail usumodu
               then do:*/ 
                      if  pro-pla.lg-cobertura-obrigatoria = no
                      and pla-mod.lg-grava-automatico = no
                      then do:
                             RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P5 - SEM PADRAO COBERTURA").
                             create usumodu.
                             assign usumodu.cd-modulo       = pro-pla.cd-modulo
                                    usumodu.cd-modalidade   = pro-pla.cd-modalidade
                                    usumodu.nr-proposta     = pro-pla.nr-proposta
                                    usumodu.cd-usuario      = b-import-bnfciar.num-livre-6
                                    usumodu.dt-inicio       = import-modul-bnfciar.dat-inic
                                    dt-inicio-aux           = import-modul-bnfciar.dat-inic
                                    usumodu.dt-fim          = import-modul-bnfciar.dat-fim
                                    usumodu.cd-userid       = "migracao*"
                                    usumodu.dt-cancelamento = import-modul-bnfciar.dat-fim
                                    dt-cancel-aux           = import-modul-bnfciar.dat-fim
                                    usumodu.cd-motivo-cancel   = import-modul-bnfciar.cdn-motiv-cancel
                                    usumodu.cd-userid-inclusao = "migracao*"
                                    usumodu.dt-mov-inclusao = today
                                    usumodu.cd-sit-modulo   = 01                                                           
                                    usumodu.dt-atualizacao  = if b-import-bnfciar.dt-exclusao-plano = ?
                                                              then b-import-bnfciar.dt-inclusao-plano
                                                              else b-import-bnfciar.dt-exclusao-plano
                                    usumodu.mm-ult-fat      = b-import-bnfciar.num-mes-ult-faturam
                                    usumodu.aa-ult-fat      = b-import-bnfciar.aa-ult-fat-period.

                             IF lg-gerar-termo-aux
                             THEN DO:
                                    /* --------------------------- MODULO COM CANCELAMENTO --- */
                                    if   usumodu.dt-cancelamento <> ?
                                    then do:
                                           /* --------------------------- MODULO CANCELADO --- */
                                           if   usumodu.dt-cancelamento < today
                                           then assign usumodu.cd-sit-modulo = 90.
                                           /* --------- MODULO COM CANCELAMENTO PROGRAMADO --- */
                                           else assign usumodu.cd-sit-modulo = 7.
                                         end.
                                    /* -------------------------------------- MODULO ATIVO --- */
                                    else ASSIGN usumodu.cd-sit-modulo = 7.

                                    /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                                    if   propost.dt-libera-doc <> ?
                                    then assign usumodu.dt-fim = propost.dt-libera-doc.
                                    else assign usumodu.dt-fim = ter-ade.dt-fim.

                                    if   usumodu.dt-inicio = ?                        
                                    then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                                    if   usumodu.dt-inicio = usumodu.dt-cancelamento
                                    then assign usumodu.aa-pri-fat = 0
                                                usumodu.mm-pri-fat = 0.
                                    else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                                                usumodu.mm-pri-fat = month(usumodu.dt-inicio).
                                  END.
                           end.
                    /*END.*/

               IF dt-inicio-aux = ?
               THEN IF usuario.dt-inclusao-plano > pro-pla.dt-inicio
                    THEN dt-inicio-aux = usuario.dt-inclusao-plano.
                    ELSE dt-inicio-aux = pro-pla.dt-inicio.

               IF dt-cancel-aux = ?
               THEN do:
                      IF usuario.dt-exclusao-plano <> ?
                      THEN dt-cancel-aux = usuario.dt-exclusao-plano.

                      IF pro-pla.dt-cancelamento <> ?
                      AND (pro-pla.dt-cancelamento < dt-cancel-aux OR dt-cancel-aux = ?)
                      THEN ASSIGN dt-cancel-aux = pro-pla.dt-cancelamento.
                    END.

                    END.
             END.
    RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P6 - FIM").

END PROCEDURE.

PROCEDURE popular-temp-usuarios:
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062018695301.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7313035151005.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7224028966006.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6004000153008.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7059012470103.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062021002303.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7066027888306.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7218026170005.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6006000027009.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6009000005000.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6005000109007.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000024007.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000135003.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7063014919300.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7063017468008.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7063015322006.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000022004.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7063014720008.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062019834011.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7417057381010.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7069031422108.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000021008.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000139009.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7059010545300.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7068031770310.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7058011316005.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7059009222005.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000149004.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000030007.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062019283023.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062017206102.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062017123002.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7066026635005.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7312035823005.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000118001.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000055000.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7056005614117.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7062021191106.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7068029628510.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7224028633007.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 7218026170013.
  CREATE tmp-carteiras. ASSIGN tmp-carteiras.cd-carteira-usuario = 6002000035009.
END PROCEDURE.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-msg-aux AS CHAR NO-UNDO.
END PROCEDURE.
