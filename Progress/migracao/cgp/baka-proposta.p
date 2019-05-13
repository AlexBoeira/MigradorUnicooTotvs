def input param cd-modalid-ini-par    as int no-undo.
def input param cd-modalid-fim-par    as int no-undo.
def input param cd-plano-ini-par      as int no-undo.
def input param cd-plano-fim-par      AS int no-undo.
def input param cd-tipo-plano-ini-par as int no-undo.
def input param cd-tipo-plano-fim-par as int no-undo.
 
 DEF VAR nr-via-carteira-aux LIKE car-ide.nr-carteira          NO-UNDO.
 DEF VAR dv-cart-inteira-aux LIKE car-ide.dv-carteira          NO-UNDO. 
 DEF VAR cd-cart-inteira-aux LIKE car-ide.cd-carteira-inteira NO-UNDO. 
 DEF VAR cd-cart-impress-aux LIKE car-ide.cd-carteira-inteira NO-UNDO. 
 DEF VAR lg-undo-retry       AS LOG                           NO-UNDO. 
 DEF VAR dt-validade-valdoc  AS DATE                          NO-UNDO. 
 DEF VAR lg-erro-valdoc AS LOG                                NO-UNDO. 
 def var ds-mensagem-valdoc AS CHAR                           no-undo. 
 def var lg-renova-valdoc   AS LOG                            no-undo. 

 DEF VAR lg-erro-aux AS LOG NO-UNDO.
 DEF VAR ds-mensagem-aux AS CHAR NO-UNDO.

 DEF BUFFER b-propost FOR propost. 

 FIND FIRST paravpmc NO-LOCK NO-ERROR.
    
 FOR EACH modalid NO-LOCK
    WHERE modalid.cd-modalidade  >= cd-modalid-ini-par
      AND modalid.cd-modalidade  <= cd-modalid-fim-par,
     EACH ti-pl-sa NO-LOCK
    WHERE ti-pl-sa.cd-modalidade  = modalid.cd-modalidade
      AND ti-pl-sa.cd-plano      >= cd-plano-ini-par
      AND ti-pl-sa.cd-plano      <= cd-plano-fim-par
      AND ti-pl-sa.cd-tipo-plano >= cd-tipo-plano-ini-par
      AND ti-pl-sa.cd-tipo-plano <= cd-tipo-plano-fim-par,
     EACH propost NO-LOCK
    WHERE propost.cd-modalidade = modalid.cd-modalidade
      AND propost.cd-plano      = ti-pl-sa.cd-plano
      AND propost.cd-tipo-plano = ti-pl-sa.cd-tipo-plano:

          IF  propost.cd-contratante <> 0
          AND propost.nr-ter-adesao   = 0
          AND propost.log-4
          THEN.
          ELSE NEXT.

 /**
  * Somente considerar propostas em que 100% dos beneficiarios ja foram migrados com sucesso.
  */
 /*FOR EACH modalid NO-LOCK,
     EACH propost NO-LOCK
    WHERE propost.cd-modalidade = modalid.cd-modalidade /* indice propo26 */
      and propost.cd-contratante <> 0
      AND propost.nr-ter-adesao  = 0
      AND NOT CAN-FIND(first import-bnfciar
                       WHERE import-bnfciar.nr-contrato-antigo = propost.nr-contrato-antigo
                         AND import-bnfciar.ind-sit-import <> "IT"):
     PROCESS EVENTS.
   */

     PROCESS EVENTS.

    FOR FIRST b-propost WHERE ROWID(b-propost) = ROWID(propost) EXCLUSIVE-LOCK:
    END.
    IF NOT AVAIL b-propost
    THEN NEXT.

    assign b-propost.dt-confirmacao        = today
           b-propost.cd-userid-confirmacao = 'super'
           b-propost.dt-atualizacao        = today
           b-propost.cd-userid             = 'super'
           b-propost.dt-parecer            = propost.dt-proposta
           b-propost.cd-usuario-diretor    = 'super'
           b-propost.dt-aprovacao          = TODAY
           b-propost.cd-userid-libera      = 'super'
           b-propost.nr-ter-adesao         = propost.nr-proposta
           b-propost.dt-comercializacao    = propost.dt-parece.
    
    if  int(substring( propost.mm-aa-ult-fat-mig,03,04)) = 0 and
        int(substring( propost.mm-aa-ult-fat-mig,01,02)) = 0
    then b-propost.cd-sit-proposta = 5.    
    else do:
           if  int(substring( propost.mm-aa-ult-fat-mig,03,04)) = year(propost.dt-parecer) 
           AND int(substring( propost.mm-aa-ult-fat-mig,01,02)) = month(propost.dt-parecer)
           then b-propost.cd-sit-proposta = 6.
           else b-propost.cd-sit-proposta = 7.
         end.

    CREATE ter-ade. 
    assign ter-ade.cd-sit-adesao         = 1
           ter-ade.cd-userid             = 'super'
           ter-ade.dt-aprovacao          = today
           ter-ade.dt-atualizacao        = today
           ter-ade.cd-modalidade         = propost.cd-modalidade
           ter-ade.nr-ter-adesao         = propost.nr-proposta
           ter-ade.dt-mov-inclusao       = today
           ter-ade.cd-userid-inclusao    = 'super'
           ter-ade.aa-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,03,04))
           ter-ade.mm-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,01,02))
           ter-ade.dt-inicio             = propost.dt-parecer.

    FOR FIRST for-pag FIELDS(for-pag.cd-classe-mens)
                      WHERE for-pag.cd-modalidade  = propost.cd-modalidade
                        AND for-pag.cd-plano       = propost.cd-plano
                        AND for-pag.cd-tipo-plano  = propost.cd-tipo-plano
                        AND for-pag.cd-forma-pagto = propost.cd-forma-pagto NO-LOCK:
        ASSIGN ter-ade.cd-classe-mens        = for-pag.cd-classe-mens.
    END.
 
    if   propost.cd-sit-proposta = 5 
    or   ter-ade.dt-inicio       = ter-ade.dt-cancelamento
    then assign ter-ade.aa-pri-fat = 0
                ter-ade.mm-pri-fat = 0.
    else assign ter-ade.aa-pri-fat = year(ter-ade.dt-inicio)
                ter-ade.mm-pri-fat = month(ter-ade.dt-inicio).

     /* ---------------------------------------------------------------------- */
    run rtp/rtclvenc.p (input "termo",
                        input ter-ade.dt-inicio,
                        input b-propost.cd-modalidade,
                        input b-propost.nr-proposta,
                        input no,                       
                        output ter-ade.dt-fim,
                        output lg-erro-aux,
                        output ds-mensagem-aux).

    run rtp/rtclvenc.p (input "cartao",
                        input ter-ade.dt-inicio,
                        input b-propost.cd-modalidade,
                        input b-propost.nr-proposta,
                        input no,                       
                        output ter-ade.dt-validade-cart,
                        output lg-erro-aux,
                        output ds-mensagem-aux).
    
  /* -------------------- NEGOCIACAO ---------------------- */
  for each propunim FIELDS(propunim.dt-fim-re)
      where propunim.cd-modalidade = propost.cd-modalidade
        and propunim.nr-proposta   = propost.nr-proposta
        and propunim.cd-unimed     > 0
            exclusive-lock:
       /* --------- TESTAR PROPOSTA CANCELADA OU PEA --------- */
      assign propunim.dt-fim-rep = ter-ade.dt-fim.
  end.


   /* ------------------------ MODULOS DA PROPOSTA ---------------- */
   for each pro-pla FIELDS ( pro-pla.cd-sit-modulo  
                             pro-pla.dt-fim         
                             pro-pla.cd-userid      
                             pro-pla.dt-atualizacao 
                             pro-pla.dt-inicio     ) 
      WHERE pro-pla.cd-modalidade = propost.cd-modalidade
        and pro-pla.nr-proposta   = propost.nr-proposta
        and pro-pla.cd-modulo     > 0
            exclusive-lock:
       
       assign pro-pla.cd-sit-modulo  = b-propost.cd-sit-proposta
              pro-pla.dt-fim         = ter-ade.dt-fim
              pro-pla.cd-userid      = 'super'
              pro-pla.dt-atualizacao = TODAY
              pro-pla.dt-inicio      = ter-ade.dt-inicio.
   end.

    /* ------------------- PROCEDIMENTOS ESPECIAIS ---------- */
   for each pr-mo-am FIELDS(pr-mo-am.cd-userid     
                            pr-mo-am.dt-atualizacao
                            pr-mo-am.dt-fim)        
       WHERE pr-mo-am.cd-modalidade = propost.cd-modalidade
        and pr-mo-am.nr-proposta   = propost.nr-proposta
            exclusive-lock:
 
       assign pr-mo-am.cd-userid      = 'SUPER'
              pr-mo-am.dt-atualizacao = TODAY
              pr-mo-am.dt-fim         = ter-ade.dt-fim.
   end.


    /* ------------------------ BENEFICIARIOS ---------------------- */
   for each usuario 
      WHERE usuario.cd-modalidade  = propost.cd-modalidade
        and usuario.nr-proposta    = propost.nr-proposta
        and usuario.cd-sit-usuario = 1
            exclusive-lock:
 
       /* ------------------------------------------- BENEFICIARIO ATIVO --- */
       if   usuario.dt-exclusao-plano = ?
       then do:
              if   usuario.aa-ult-fat = 0
              then assign usuario.cd-sit-usuario = 5.
              else do:
                     if   usuario.aa-ult-fat = year (usuario.dt-inclusao-plano)
                     and  usuario.mm-ult-fat = month(usuario.dt-inclusao-plano)
                     then usuario.cd-sit-usuario = 6.
                     else usuario.cd-sit-usuario = 7.
                   end.

            /* ------------------------------- MODULOS DO BENEFICIARIO --- */
              for each usumodu FIELDS(usumodu.cd-sit-modulo                   
                                      usumodu.dt-fim        
                                      usumodu.cd-userid     
                                      usumodu.dt-atualizacao
                                      usumodu.dt-inicio     
                                      usumodu.aa-pri-fat    
                                      usumodu.mm-pri-fat)
                  WHERE usumodu.cd-modalidade = usuario.cd-modalidade
                                 and usumodu.nr-proposta   = usuario.nr-proposta
                                 and usumodu.cd-usuario    = usuario.cd-usuario
                       exclusive-lock:
 
                  ASSIGN usumodu.cd-sit-modulo  = usuario.cd-sit-usuario
                         usumodu.dt-fim         = ter-ade.dt-fim
                         usumodu.cd-userid      = 'super'
                         usumodu.dt-atualizacao = TODAY
                         usumodu.dt-inicio      = ter-ade.dt-inicio
                         usumodu.aa-pri-fat     = YEAR (usumodu.dt-inicio)
                         usumodu.mm-pri-fat     = month(usumodu.dt-inicio).
                  
              end.
         end.
       /* ------------------------------------ BENEFICIARIO COM EXCLUSAO --- */
       else do:
              /* --------------------------------- BENEFICIARIO EXCLUIDO --- */
              if   usuario.dt-exclusao-plano < today
              then assign usuario.cd-sit-usuario = 90.   
              else do:
                     if   usuario.aa-ult-fat = 0
                     then assign usuario.cd-sit-usuario = 5.  
                     else do:
                            if usuario.aa-ult-fat = year (usuario.dt-inclusao-plano) and
                               usuario.mm-ult-fat = month(usuario.dt-inclusao-plano)
                            then usuario.cd-sit-usuario = 6.
                            else usuario.cd-sit-usuario = 7.
                          end.
                   end.
 
              /* ------------------------------- MODULOS DO BENEFICIARIO --- */
              for each usumodu where
                       usumodu.cd-modalidade = usuario.cd-modalidade
                   and usumodu.nr-proposta   = usuario.nr-proposta
                   and usumodu.cd-usuario    = usuario.cd-usuario
                       exclusive-lock:
 
                  /* ---------------------------------- MODULO CANCELADO --- */
                  if   usumodu.dt-cancelamento < today
                  then assign usumodu.cd-sit-modulo = 90.
                  /* -------------------- MODULO COM EXCLUSAO PROGRAMADA --- */
                  else assign usumodu.cd-sit-modulo = usuario.cd-sit-usuario.
 
                  /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                  if   propost.dt-libera-doc <> ?
                  then assign usumodu.dt-fim = propost.dt-libera-doc.
                  else assign usumodu.dt-fim = ter-ade.dt-fim.
 
                  assign usumodu.dt-atualizacao = today
                         usumodu.cd-userid      = 'super'.
 
                  if   usumodu.dt-inicio = ?                        
                  then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                  if   usumodu.dt-inicio = usumodu.dt-cancelamento
                  then assign usumodu.aa-pri-fat = 0
                              usumodu.mm-pri-fat = 0.
                  else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                              usumodu.mm-pri-fat = month(usumodu.dt-inicio).
              end.
            end.
 
       assign usuario.nr-ter-adesao  = ter-ade.nr-ter-adesao
              usuario.dt-aprovacao   = today
              usuario.cd-userid      = 'super'
              usuario.dt-atualizacao = today
              usuario.dt-senha       = today.
              

       if   usuario.dt-inclusao-plano = usuario.dt-exclusao-plano 
       or   usuario.cd-sit-usuario =  5
       then assign usuario.aa-pri-fat = 0
                   usuario.mm-pri-fat = 0.
       else assign usuario.aa-pri-fat = year (usuario.dt-inclusao-plano)
                   usuario.mm-pri-fat = month(usuario.dt-inclusao-plano).
 
 
       /* ----- CARTEIRA --------------------------------------------------- */
       /* ----- MONTA O CODIGO DA CARTEIRA E CALCULA O DIGITO -------------- */
       assign nr-via-carteira-aux = 1.
 
       run value (substring (paravpmc.nm-prog-monta-cart, 1, 2) + "p/" +
                             paravpmc.nm-prog-monta-cart + ".p")
                 (input  1,
                  input  recid (usuario),
                  input  0,
                  input  nr-via-carteira-aux,
                  input  no,
                  output cd-cart-inteira-aux,
                  output dv-cart-inteira-aux,
                  output cd-cart-impress-aux,
                  output lg-undo-retry).
 
 
       /* ----- GRAVA A TABELA DE CARTEIRA DO BENEFICIARIO ----------------- */
       create car-ide.
       assign car-ide.cd-unimed           = usuario.cd-unimed
              car-ide.cd-modalidade       = usuario.cd-modalidade
              car-ide.nr-ter-adesao       = usuario.nr-ter-adesao
              car-ide.cd-usuario          = usuario.cd-usuario
              car-ide.nr-carteira         = nr-via-carteira-aux
              car-ide.dv-carteira         = dv-cart-inteira-aux
              car-ide.lg-devolucao        = no
              car-ide.dt-devolucao        = ?
              car-ide.ds-observacao [1]   = ""
              car-ide.ds-observacao [2]   = ""
              car-ide.ds-observacao [3]   = ""
              car-ide.dt-atualizacao      = today
              car-ide.cd-userid           = 'super'
              car-ide.cd-carteira-antiga  = usuario.cd-carteira-antiga
              car-ide.cd-carteira-inteira = cd-cart-inteira-aux
              car-ide.dt-validade         = ter-ade.dt-validade-cart.
 
       if   usuario.dt-exclusao-plano <> ?
       then do:
              if   usuario.dt-exclusao-plano < today
              then assign car-ide.cd-sit-carteira = 90.
              else assign car-ide.cd-sit-carteira = 1.
 
              assign car-ide.dt-cancelamento = usuario.dt-exclusao-plano.
            end.
       else assign car-ide.cd-sit-carteira = 1.
       
       assign car-ide.nr-impressao = 0
             car-ide.dt-emissao   = ?.
      
       /* --------------------- CHAMADA  DA ROTINA RTVALDOC PARA CALCULAR DATAS- */
       dt-validade-valdoc = ter-ade.dt-validade-cart.
    
       validate car-ide.
       if propost.in-validade-doc-ident = 2
       then do:
              assign lg-erro-valdoc = no.
    
              run rtp/rtvaldoc.p (input  rowid(usuario),
                                  input  rowid(propost),
                                  input  no,
                                  input-output dt-validade-valdoc,
                                  output lg-erro-valdoc,
                                  output ds-mensagem-valdoc,
                                  output lg-renova-valdoc).
    
            end.
    
       /* ----------------------------------------------------------- */
       if   car-ide.dt-validade <> dt-validade-valdoc
       then do:
                assign car-ide.dt-validade = dt-validade-valdoc.

                /* -------------- RETORNA A DATA DE FIM DE VALIDADE DO CARTAO/CARTEIRA ---*/
                if   paravpmc.in-validade-cart = "2" 
                then do:
                       run rtp/rtultdia.p (input  year (car-ide.dt-validade),
                                           input  month(car-ide.dt-validade),
                                           output car-ide.dt-validade ).
                     end.  
            end.
   end.
END.
