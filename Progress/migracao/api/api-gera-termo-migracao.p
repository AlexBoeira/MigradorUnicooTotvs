 def            var v-cod-destino-impres  as char                      no-undo.
 def            var c-prog-gerado         as char initial "DTVW1227"    no-undo.
 def new shared var c-sistema             as char format "x(25)"        no-undo.
 def new shared var c-impressora          as char                       no-undo.
 def new shared var c-layout              as char                       no-undo.
 def new shared var v_num_count           as int                        no-undo.
 def new shared var c-arq-control         as char                       no-undo.
 def new shared var c-rodape              as char                       no-undo.
 
 def new global shared var c-arquivo-log  as char  format "x(60)"       no-undo.
 def new global shared var c-prg-vrs      as char                       no-undo.
 def new global shared var c-prg-obj      as char                       no-undo.
 
 define new shared buffer b_ped_exec_style    for emsfnd.ped_exec.
 define new shared buffer b_servid_exec_style for emsfnd.servid_exec.
 
 DEF VAR nr-via-carteira-aux          LIKE car-ide.nr-carteira          NO-UNDO.
 DEF VAR dv-cart-inteira-aux          LIKE car-ide.dv-carteira          NO-UNDO. 
 DEF VAR cd-cart-inteira-aux          LIKE car-ide.cd-carteira-inteira  NO-UNDO. 
 DEF VAR cd-cart-impress-aux          LIKE car-ide.cd-carteira-inteira  NO-UNDO. 
 DEF VAR lg-undo-retry                AS LOG                            NO-UNDO. 
 DEF VAR dt-validade-valdoc           AS DATE                           NO-UNDO. 
 DEF VAR lg-erro-valdoc               AS LOG                            NO-UNDO. 
 def var ds-mensagem-valdoc           AS CHAR                           no-undo. 
 def var lg-renova-valdoc             AS LOG                            no-undo. 
 def var lg-medocup-aux               as log                            no-undo.
 def var lg-grava-carteira            as log                            no-undo.
 def var ds-chave-gera-aux            as char                           no-undo. 
                                      

 DEF BUFFER b-propost FOR propost. 
 def buffer b-contrat for contrat. 
 def buffer b-usuario for usuario.

 define temp-table tt-raw-digita
        field raw-digita as raw.

 define temp-table tt-param
  field destino                        as int
  field arquivo                        as char
  field usuario                        as char
  field data-exec                      as date
  field hora-exec                      as int
  field parametro                      as log
  field formato                        as int
  field v_num_tip_aces_usuar           as int
  field ep-codigo                      as char
  field cd-modalidade-ini              as int 
  field cd-modalidade-fim              as int
  field nr-proposta-ini                as int 
  field nr-proposta-fim                as int 
  field cd-plano-ini                   as int 
  field cd-plano-fim                   as int 
  field cd-tipo-plano-ini              as int 
  field cd-tipo-plano-fim              as int
  field dt-proposta-ini                as date
  field dt-proposta-fim                as date
  field nr-insc-ini                    as dec
  field nr-insc-fim                    as dec
  field lg-analise                     as log 
  field lg-aprova                      as log
  field cd-sit-cred                    as int
  field lg-mantem-senha-benef          as log
  field in-gera-senha                  as int
  field dt-minima-termo                as date
  field in-geracao-senha               as int
  field lg-imp-carteira                as log.

 /* -------------------------------------- DEFINICAO DE VARIAVEIS GLOBAIS --- */
  def new global shared var i-ep-codigo-usuario     as char                            no-undo.
  def new global shared var l-implanta              as log   init no.
  def new global shared var c-seg-usuario           as char  format "x(12)"            no-undo.
  def new global shared var i-num-ped-exec-rpw      as int                             no-undo.   
  def new global shared var i-pais-impto-usuario    as int   format ">>9"              no-undo.
  def new global shared var l-rpc                   as log                             no-undo.
  def new global shared var r-registro-atual        as rowid                           no-undo.
  def new global shared var c-arquivo-log           as char  format "x(60)"            no-undo.
  def new global shared var i-num-ped               as int                             no-undo.         
  def new global shared var v_cdn_empres_usuar      as char                            no-undo.
  def new global shared var v_cod_usuar_corren    like emsfnd.usuar_mestre.cod_usuario no-undo.
  def new global shared var h_prog_segur_estab      as handle                          no-undo.
  def new global shared var v_cod_grp_usuar_lst     as char                            no-undo.
  def new global shared var v_num_tip_aces_usuar    as int                             no-undo.
  def new global shared var rw-log-exec             as rowid                           no-undo.
  def new global shared var c-dir-spool-servid-exec as char                            no-undo.

  def var cd-classe-mens-aux like for-pag.cd-classe-mens no-undo. 
  def var nr-ter-adesao-aux  like ter-ade.nr-ter-adesao  no-undo.
  def var cd-sit-proposta-aux as int                     no-undo. 
  def var dt-inicio-aux       as date                    no-undo.  
  def var lg-erro-rtsenha-aux as log                     no-undo.
  def var ds-erro-aux         as char                    no-undo. 
  def var qt-executada-aux    as int                     no-undo. 
  def var lg-erro-aux         as log                     no-undo. 
  
  def input param raw-param as raw no-undo.
  def input param table for tt-raw-digita.

  /* ----------------------------------- DEFINICAO DE DESTINO DA IMPRESSAO --- */
  create tt-param.
  raw-transfer raw-param to tt-param.

  /* --------------------- TRIGGER CREATE E UPDATE DA TABELA ----------------- */
  {trs/wrusuario.i}
  {trs/wrter-ade.i}
  {trs/wrpro-pla.i}
  {trs/wrpreserv.i}
  {trs/wrcontrat.i}
  {trs/wrcar-ide.i}
  {trs/wrusumodu.i}
  {trs/wrusucaren.i}
  {trs/wrusucarproc.i}

  /* -------------------------------------------------- DEFINICAO DA INCLUDE DA API USMOVADM --- */
  {api/api-usmovadm.i}.

  /* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
  {hdp/hdrunpersis.iv "new"}


  /*--------------------------------------------------- PERSISTENCIA DA API ---*/ 
  def var h-api-usmovadm-aux               as handle                     no-undo.
 
  def temp-table  wk-erros no-undo
    field cd-modalidade           like  modalid.cd-modalidade
    field nr-proposta             like  propost.nr-proposta
    field cd-sit-proposta         like  propost.cd-sit-proposta
    field nr-insc-contratante     like  propost.nr-insc-contratante
    field cd-contratante          like  propost.cd-contratante
    field cd-tipo-mensagem        as char format "x(01)"
    field ds-mensagem             as char format "x(75)".

  find first paravpmc no-lock no-error.
  find first paramecp no-lock no-error. 
  find first parafatu no-lock no-error. 

  {hdp/hdrunpersis.i "api/api-usmovadm.p" "h-api-usmovadm-aux"}

  FOR EACH propost NO-LOCK
         where propost.ep-codigo              = paramecp.ep-codigo
           and propost.cod-estabel            = paramecp.cod-estabel
           and propost.cd-modalidade         >= tt-param.cd-modalidade-ini  
           and propost.cd-modalidade         <= tt-param.cd-modalidade-fim  
           and propost.nr-proposta           >= tt-param.nr-proposta-ini    
           and propost.nr-proposta           <= tt-param.nr-proposta-fim    
           and propost.cd-plano              >= tt-param.cd-plano-ini       
           and propost.cd-plano              <= tt-param.cd-plano-fim       
           and propost.cd-tipo-plano         >= tt-param.cd-tipo-plano-ini  
           and propost.cd-tipo-plano         <= tt-param.cd-tipo-plano-fim  
           and propost.dt-proposta           >= tt-param.dt-proposta-ini
           and propost.dt-proposta           <= tt-param.dt-proposta-fim
           and propost.nr-insc-contratante   >= tt-param.nr-insc-ini 
           and propost.nr-insc-contratante   <= tt-param.nr-insc-fim 
           and propost.nr-ter-adesao    = 0
           and propost.cd-sit-proposta  = 1
           and propost.cd-tipo-proposta = 9, 
        first modalid where modalid.cd-modalidade = propost.cd-modalidade no-lock,
        first contrat where contrat.nr-insc-contratante = propost.nr-insc-contratante
                        and contrat.cd-contratante      = propost.cd-contratante no-lock:


        for first usuario where usuario.cd-modalidade   = propost.cd-modalidade
                            and usuario.nr-proposta     = propost.nr-proposta
                            and usuario.cd-sit-usuario <= 7 no-lock: end.

        if not avail usuario
        then do:
                run gera-erro(input "Proposta sem beneficiarios cadastrados",
                              input "E"). 
                next.
             end.

        FOR FIRST for-pag FIELDS(for-pag.cd-classe-mens)
                      WHERE for-pag.cd-modalidade  = propost.cd-modalidade
                        AND for-pag.cd-plano       = propost.cd-plano
                        AND for-pag.cd-tipo-plano  = propost.cd-tipo-plano
                        AND for-pag.cd-forma-pagto = propost.cd-forma-pagto NO-LOCK:
            assign cd-classe-mens-aux    = for-pag.cd-classe-mens.
        END.

        if not avail for-pag 
        then do:
                run gera-erro(input "Forma de pagamento nao cadastrada",
                              input "E"). 
                next.
             end.

        if   propost.cd-contratante = 0
        then do:
                run gera-erro(input "Rodar Efetivacao de contratantes",
                              input "E").
                next.
             end.

        find ti-pl-sa where ti-pl-sa.cd-modalidade = propost.cd-modalidade
                        and ti-pl-sa.cd-plano      = propost.cd-plano
                        and ti-pl-sa.cd-tipo-plano = propost.cd-tipo-plano
                     no-lock no-error.
    
        if   not avail ti-pl-sa
        then do:
                run gera-erro(input "Tipo de Plano nao cadastrado",
                              input "E").
                next.
             end.

   
        if modalid.in-geracao-termo = 1 
        then do:
                select max(ter-ade.nr-ter-adesao) into nr-ter-adesao-aux from ter-ade. 

                if nr-ter-adesao-aux = ?
                then assign nr-ter-adesao-aux = 1. 
                else assign nr-ter-adesao-aux = nr-ter-adesao-aux + 1. 
             end.
        else do:
                if propost.nr-proposta > 999999
                then do:
                        run gera-erro (input  "Nao sera possivel gerar numero do termo. " 
                                            + "Proposta com numero maior que 999999."     
                                            + " Mod: " + string(propost.cd-modalidade),
                                       input "E").
                        next.
                     end.
                assign nr-ter-adesao-aux = propost.nr-proposta.
             end.


        /*ATUALIZA PROPOSTA*/
        find b-propost where rowid(b-propost) = rowid(propost) exclusive-lock no-error. 

        IF AVAIL b-propost 
        THEN DO:
                assign b-propost.dt-confirmacao        = today
                       b-propost.cd-userid-confirmacao = v_cod_usuar_corren
                       b-propost.dt-atualizacao        = today
                       b-propost.cd-userid             = v_cod_usuar_corren
                       b-propost.cd-userid-libera      = v_cod_usuar_corren
                       b-propost.nr-ter-adesao         = propost.nr-proposta.

                if tt-param.lg-analise
                then do: 
                        find b-contrat where rowid(b-contrat) = rowid(contrat) 
                                       exclusive-lock no-error. 
                        if avail b-contrat 
                        then assign b-contrat.dt-analise-credito = today                  
                                    b-contrat.cd-userid-analise  = v_cod_usuar_corren     
                                    b-contrat.cd-sit-cred        = tt-param.cd-sit-cred.       
                     end.

                if tt-param.lg-aprova
                then assign b-propost.dt-parecer            = propost.dt-proposta
                            b-propost.cd-usuario-diretor    = v_cod_usuar_corren
                            b-propost.dt-aprovacao          = TODAY.

                if  int(substring( propost.mm-aa-ult-fat-mig,03,04)) = 0 and
                int(substring( propost.mm-aa-ult-fat-mig,01,02)) = 0
                then b-propost.cd-sit-proposta = 5.    
                else do:
                       if  int(substring( propost.mm-aa-ult-fat-mig,03,04)) = year(propost.dt-parecer) 
                       AND int(substring( propost.mm-aa-ult-fat-mig,01,02)) = month(propost.dt-parecer)
                       then b-propost.cd-sit-proposta = 6.
                       else b-propost.cd-sit-proposta = 7.
                     end.

                assign cd-sit-proposta-aux             = b-propost.cd-sit-proposta
                       b-propost.dt-comercializacao    = propost.dt-parece.
              END.

    CREATE ter-ade. 
    assign ter-ade.cd-sit-adesao         = 1
           ter-ade.cd-userid             = v_cod_usuar_corren
           ter-ade.dt-aprovacao          = today
           ter-ade.dt-atualizacao        = today
           ter-ade.cd-modalidade         = propost.cd-modalidade
           ter-ade.nr-ter-adesao         = propost.nr-proposta
           ter-ade.dt-mov-inclusao       = today
           ter-ade.cd-userid-inclusao    = v_cod_usuar_corren
           ter-ade.aa-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,03,04))
           ter-ade.mm-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,01,02))
           ter-ade.dt-inicio             = propost.dt-proposta
           ter-ade.cd-classe-mens        = cd-classe-mens-aux
           ter-ade.lg-mantem-senha-benef = tt-param.lg-mantem-senha-benef  
           ter-ade.in-gera-senha         = tt-param.in-gera-senha
           ter-ade.dt-fim                = ter-ade.dt-inicio
           ter-ade.dt-validade-cart      = ter-ade.dt-inicio.

    
    if   cd-sit-proposta-aux     = 5 
    or   ter-ade.dt-inicio       = ter-ade.dt-cancelamento
    then assign ter-ade.aa-pri-fat = 0
                ter-ade.mm-pri-fat = 0.
    else assign ter-ade.aa-pri-fat = year(ter-ade.dt-inicio)
                ter-ade.mm-pri-fat = month(ter-ade.dt-inicio).


   if   contrat.lg-mantem-senha-termo
   then assign ter-ade.cd-senha = contrat.cd-senha.
   else do:
          run rtp/rtrandom.p (input 6,
                              output ter-ade.cd-senha,
                              output lg-erro-rtsenha-aux,
                              output ds-erro-aux).

          if lg-erro-rtsenha-aux 
          then do:
                 assign lg-erro-rtsenha-aux = no.
                 run gera-erro (input ds-erro-aux,
                                input "E").
                 undo, retry.
               end.
        end.

    assign dt-inicio-aux = ter-ade.dt-inicio. 
    do while ter-ade.dt-fim < tt-param.dt-minima-termo:

      /* ---------------------------------- CALCULA DATA DE FIM DO TERMO --- */
       run rtp/rtclvenc.p (input "termo",
                           input dt-inicio-aux,
                           input propost.cd-modalidade,
                           input propost.nr-proposta,
                           input no,                       
                           output ter-ade.dt-fim,
                           output lg-erro-aux,
                           output ds-erro-aux).
       if   lg-erro-aux
       then do:
               run gera-erro (input ds-erro-aux,
                              input "E").
               undo, retry.
           end.

      assign dt-inicio-aux    = ter-ade.dt-fim
             qt-executada-aux = qt-executada-aux + 1.
   end.

   if   qt-executada-aux <> 0
   then assign ter-ade.dt-fim = ter-ade.dt-fim + qt-executada-aux - 1.

   if propost.dt-libera-doc <> ?
   then assign ter-ade.dt-fim = propost.dt-libera-doc.


   /* ---------------------------------------------------------------------- */
   assign dt-inicio-aux            = ter-ade.dt-inicio
          ter-ade.dt-validade-cart = ter-ade.dt-inicio.
 
   /* ---- Inicializa Quantidade de vezes que o La‡o vai ser Executado. ---- */
   assign qt-executada-aux = 0.


   /* ---------------------------------------------------------------------- */
   do while ter-ade.dt-validade-cart < dt-minima-termo:
 
      /* --------------------------------- CALCULA DATA DE FIM DO CARTAO --- */
      if   propost.lg-cartao
      then do:
              run rtp/rtclvenc.p (input "cartao",
                                  input dt-inicio-aux,
                                  input propost.cd-modalidade,
                                  input propost.nr-proposta,
                                  input no,                       
                                  output ter-ade.dt-validade-cart,
                                  output lg-erro-aux,
                                  output ds-erro-aux).

              if   lg-erro-aux
              then do:
                      run gera-erro (input ds-erro-aux,
                                     input "E").
                      undo, retry.
                  end.

          end.
      /* ------------------------------------------ CALCULA DATA DE FIM DA CARTEIRA --- */
      else do:
              run rtp/rtclvenc.p (input "carteira",
                                  input dt-inicio-aux,
                                  input propost.cd-modalidade,
                                  input propost.nr-proposta,
                                  input no,                       
                                  output ter-ade.dt-validade-cart,
                                  output lg-erro-aux,
                                  output ds-erro-aux).

              if   lg-erro-aux
              then do:
                      run gera-erro (input ds-erro-aux,
                                     input "E").
                      undo, retry.
                  end.
          end.
    
      assign dt-inicio-aux    = ter-ade.dt-validade-cart
             qt-executada-aux = qt-executada-aux + 1.
   end.
 
   /* ---------------------- Atualiza a data fim do termo de adesÆo -------- */
   if   qt-executada-aux <> 0
   then assign ter-ade.dt-validade-cart = ter-ade.dt-validade-cart
                                        + qt-executada-aux - 1.
    
   /* --------------------------------- TESTAR PROPOSTA CANCELADA OU PEA --- */
   if   propost.dt-libera-doc <> ?
   then assign ter-ade.dt-validade-cart = propost.dt-libera-doc.
  

   /* -------------- RETORNA A DATA DE FIM DE VALIDADE DO CARTAO/CARTEIRA ---*/
   if   paravpmc.in-validade-cart = "2"
   then run rtp/rtultdia.p (input  year (ter-ade.dt-validade-cart),
                            input  month(ter-ade.dt-validade-cart),
                            output ter-ade.dt-validade-cart).

    if propost.int-13 = 0
    then do:
            /* Historico de tabelas de preco da proposta */
           create histabpreco.
           assign histabpreco.cd-modalidade        = propost.cd-modalidade 
                  histabpreco.nr-proposta          = propost.nr-proposta 
                  histabpreco.aa-reajuste          = year(ter-ade.dt-inicio)
                  histabpreco.mm-reajuste          = month(ter-ade.dt-inicio)
                  histabpreco.cd-tab-preco         = propost.cd-tab-preco
                  histabpreco.log-1                = parafatu.log-12
                  histabpreco.cd-userid            = v_cod_usuar_corren    
                  histabpreco.dt-atualizacao       = today.
          
           if (    year(ter-ade.dt-inicio)  = propost.aa-ult-reajuste
               and month(ter-ade.dt-inicio) = propost.mm-ult-reajuste)
           or (    propost.aa-ult-reajuste = 0
               and propost.mm-ult-reajuste = 0)
           then assign histabpreco.pc-reajuste        = propost.pc-ult-reajuste        
                       histabpreco.nr-oficio-reajuste = propost.nr-oficio-reajuste
                       histabpreco.int-1              = propost.aa-ult-reajuste
                       histabpreco.int-2              = propost.mm-ult-reajuste.
           else do:
                  create histabpreco.
                  assign histabpreco.cd-modalidade      = propost.cd-modalidade 
                         histabpreco.nr-proposta        = propost.nr-proposta 
                         histabpreco.aa-reajuste        = propost.aa-ult-reajuste
                         histabpreco.mm-reajuste        = propost.mm-ult-reajuste
                         histabpreco.cd-tab-preco       = propost.cd-tab-preco
                         histabpreco.pc-reajuste        = propost.pc-ult-reajuste        
                         histabpreco.nr-oficio-reajuste = propost.nr-oficio-reajuste
                         histabpreco.int-1              = propost.aa-ult-reajuste
                         histabpreco.int-2              = propost.mm-ult-reajuste
                         histabpreco.log-1              = parafatu.log-12
                         histabpreco.cd-userid          = v_cod_usuar_corren
                         histabpreco.dt-atualizacao     = today.
                end.
         end.


  /* -------------------- NEGOCIACAO ---------------------- */
  for each propunim FIELDS(propunim.dt-fim-re
                           propunim.cd-userid     
                           propunim.dt-atualizacao)
      where propunim.cd-modalidade = propost.cd-modalidade
        and propunim.nr-proposta   = propost.nr-proposta
        and propunim.cd-unimed     > 0
            exclusive-lock:
       /* --------- TESTAR PROPOSTA CANCELADA OU PEA --------- */
      if   propost.dt-libera-doc <> ?
      then assign propunim.dt-fim-rep = propost.dt-libera-doc.
      else assign propunim.dt-fim-rep = ter-ade.dt-fim.

      assign propunim.cd-userid      = v_cod_usuar_corren
             propunim.dt-atualizacao = today.
   end.


   /* ------------------------ MODULOS DA PROPOSTA ---------------- */
   for each pro-pla FIELDS ( pro-pla.cd-sit-modulo  
                             pro-pla.dt-fim         
                             pro-pla.cd-userid      
                             pro-pla.dt-atualizacao 
                             pro-pla.dt-inicio     
                             pro-pla.dt-cancelamento) 
      WHERE pro-pla.cd-modalidade = propost.cd-modalidade
        and pro-pla.nr-proposta   = propost.nr-proposta
        and pro-pla.cd-modulo     > 0
            exclusive-lock:

       assign pro-pla.cd-sit-modulo  = 7
              pro-pla.dt-fim         = ter-ade.dt-fim
              pro-pla.cd-userid      = v_cod_usuar_corren
              pro-pla.dt-atualizacao = TODAY
              pro-pla.dt-inicio      = ter-ade.dt-inicio.


       if propost.dt-libera-doc <> ?
       then do:
               if  propost.dt-libera-doc < today
               then assign pro-pla.cd-sit-modulo = 90.
               else assign pro-pla.cd-sit-modulo = 7.
               assign pro-pla.dt-fim = propost.dt-libera-doc.
            end.
       else if  pro-pla.dt-cancelamento <> ? 
            then do:
                    if   pro-pla.dt-cancelamento < today
                    then assign pro-pla.cd-sit-modulo = 90.
                    else assign pro-pla.cd-sit-modulo = 7.
                    assign pro-pla.dt-fim = propost.dt-libera-doc.
                 end.
   end.

    /* ------------------- PROCEDIMENTOS ESPECIAIS ---------- */
   for each pr-mo-am FIELDS(pr-mo-am.cd-userid     
                            pr-mo-am.dt-atualizacao
                            pr-mo-am.dt-fim
                            pr-mo-am.dt-cancelamento)        
       WHERE pr-mo-am.cd-modalidade = propost.cd-modalidade
        and pr-mo-am.nr-proposta   = propost.nr-proposta
            exclusive-lock:
 
       assign pr-mo-am.cd-userid      = v_cod_usuar_corren
              pr-mo-am.dt-atualizacao = TODAY
              pr-mo-am.dt-fim         = ter-ade.dt-fim.

       if propost.dt-libera-doc <> ?
       then assign pr-mo-am.dt-fim    = propost.dt-libera-doc.
       else if pr-mo-am.dt-cancelamento <> ?
            then assign pr-mo-am.dt-fim = propost.dt-libera-doc.
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

                run verif-cob-usu-exc. 

                /* -------------------------------- BENEFICIARIO REPASSADO --- */
                if   usuario.cd-unimed-destino <> 0
                then do:
                       find last usurepas where usurepas.cd-modalidade      = usuario.cd-modalidade
                                            and usurepas.nr-proposta        = usuario.nr-proposta
                                            and usurepas.cd-usuario         = usuario.cd-usuario
                                            and usurepas.cd-unidade-destino = usuario.cd-unimed-destino
                                          exclusive-lock no-error.
                
                       if   avail usurepas
                       then do:
                              find propunim where propunim.cd-modalidade = usurepas.cd-modalidade
                                              and propunim.nr-proposta   = usurepas.nr-proposta
                                              and propunim.cd-unimed     = usurepas.cd-unidade-destino
                                                  no-lock no-error.
                
                              if avail propunim and
                                 propunim.in-exporta-repasse = 0
                              then assign usurepas.in-tipo-impressao-carta = "N"
                                          usurepas.in-tipo-movto-carta     = "I". 
                
                              else do:
                                     if   usurepas.dt-saida = ?
                                     then assign
                                          usurepas.in-tipo-impressao-carta = "R"
                                          usurepas.in-tipo-movto-carta     = "I".    
                                     else assign
                                          usurepas.in-tipo-impressao-carta = "R"
                                          usurepas.in-tipo-movto-carta     = "E".
                                     
                                     assign usurepas.dt-carta-interc         = today
                                            usurepas.cd-userid-carta-interc  = v_cod_usuar_corren
                                            usurepas.dt-atualizacao          = today
                                            usurepas.cd-userid               = v_cod_usuar_corren.
                                   end.
                            end.
                     end.

             /* ------------------------------- MODULOS DO BENEFICIARIO --- */
              for each usumodu FIELDS(usumodu.cd-sit-modulo                   
                                      usumodu.dt-fim        
                                      usumodu.cd-userid     
                                      usumodu.dt-atualizacao
                                      usumodu.dt-inicio     
                                      usumodu.aa-pri-fat    
                                      usumodu.mm-pri-fat
                                      usumodu.dt-cancelamento)
                  WHERE usumodu.cd-modalidade = usuario.cd-modalidade
                    and usumodu.nr-proposta   = usuario.nr-proposta
                    and usumodu.cd-usuario    = usuario.cd-usuario
                       exclusive-lock:
 
                  ASSIGN usumodu.cd-sit-modulo  = 7
                         usumodu.dt-fim         = ter-ade.dt-fim
                         usumodu.cd-userid      = v_cod_usuar_corren
                         usumodu.dt-atualizacao = TODAY
                         usumodu.dt-inicio      = ter-ade.dt-inicio
                         usumodu.aa-pri-fat     = YEAR (usumodu.dt-inicio)
                         usumodu.mm-pri-fat     = month(usumodu.dt-inicio).

                  if  usumodu.dt-cancelamento <> ?
                  and usumodu.dt-cancelamento < today
                  then assign usumodu.cd-sit-modulo = 90.

                  if   usumodu.dt-inicio = usumodu.dt-cancelamento
                  then assign usumodu.aa-pri-fat = 0
                              usumodu.mm-pri-fat = 0.
              end.
         end.
       /* ------------------------------------ BENEFICIARIO COM EXCLUSAO --- */
       else do:
              /* --------------------------------- BENEFICIARIO EXCLUIDO --- */
              if   usuario.dt-exclusao-plano < today
              then do:
                      assign usuario.cd-sit-usuario = 90.   

                      for each usucarproc where usucarproc.cd-modalidade  = usuario.cd-modalidade
                                            and usucarproc.nr-proposta    = usuario.nr-proposta  
                                            and usucarproc.cd-usuario     = usuario.cd-usuario  
                                               exclusive-lock:

                         assign usucarproc.dt-inicio       = if   usuario.dt-inclusao-plano > usucarproc.dt-inicio
                                                             then usuario.dt-inclusao-plano
                                                             else usucarproc.dt-inicio 
                                usucarproc.dt-fim          = if   ter-ade.dt-fim <> ?
                                                             and  ter-ade.dt-fim < usucarproc.dt-fim
                                                             then ter-ade.dt-fim
                                                             else usucarproc.dt-fim
                                usucarproc.dt-cancelamento = if   usuario.dt-exclusao-plano < usucarproc.dt-cancelamento
                                                             then usuario.dt-exclusao-plano
                                                             else usucarproc.dt-cancelamento   
                                usucarproc.dt-atualizacao  = today
                                usucarproc.cd-userid       = v_cod_usuar_corren.
                     
                     end.
                   end.
              else do:
                     if   usuario.aa-ult-fat = 0
                     then assign usuario.cd-sit-usuario = 5.  
                     else do:
                            if usuario.aa-ult-fat = year (usuario.dt-inclusao-plano) and
                               usuario.mm-ult-fat = month(usuario.dt-inclusao-plano)
                            then usuario.cd-sit-usuario = 6.
                            else usuario.cd-sit-usuario = 7.
                          end.
                     run verif-cob-usu-exc.
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
                  else assign usumodu.cd-sit-modulo = 7.
 
                  /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                  if   propost.dt-libera-doc <> ?
                  then assign usumodu.dt-fim = propost.dt-libera-doc.
                  else assign usumodu.dt-fim = ter-ade.dt-fim.
 
                  assign usumodu.dt-atualizacao = today
                         usumodu.cd-userid      =  v_cod_usuar_corren.
 
                  if   usumodu.dt-inicio = ?                        
                  then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                  if   usumodu.dt-inicio = usumodu.dt-cancelamento
                  then assign usumodu.aa-pri-fat = 0
                              usumodu.mm-pri-fat = 0.
                  else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                              usumodu.mm-pri-fat = month(usumodu.dt-inicio).
              end.
            end.

      if   tt-param.lg-mantem-senha-benef 
      then assign usuario.cd-senha  = contrat.cd-senha.
      else do:
              if   tt-param.in-geracao-senha = 1 /* individual */
              then do:
                     run rtp/rtrandom.p (input 6,
                                         output usuario.cd-senha,
                                         output lg-erro-rtsenha-aux,
                                         output ds-erro-aux).
                   
                     if lg-erro-rtsenha-aux 
                     then do:
                             assign lg-erro-rtsenha-aux = no.
                             run gera-erro (input ds-erro-aux,
                                            input "E").
                             undo, retry.
                          end.
                   end.

              else if   usuario.cd-usuario = usuario.cd-titular  /* familia */
                   then do:
                          run rtp/rtrandom.p (input 6,
                                              output usuario.cd-senha,
                                              output lg-erro-rtsenha-aux,
                                              output ds-erro-aux).
                        
                          if lg-erro-rtsenha-aux 
                          then do:
                                  assign lg-erro-rtsenha-aux = no.
                                  run gera-erro (input ds-erro-aux,
                                                 input "E").
                                  undo, retry.
                               end.
     
                          for each b-usuario where b-usuario.cd-modalidade = usuario.cd-modalidade
                                               and b-usuario.nr-proposta   = usuario.nr-proposta
                                               and b-usuario.cd-titular    = usuario.cd-titular
                                               and b-usuario.cd-usuario    <> usuario.cd-usuario  exclusive-lock:
                            assign b-usuario.cd-senha = usuario.cd-senha.
                          end.
                        end.
           end.    

       assign usuario.nr-ter-adesao  = ter-ade.nr-ter-adesao
              usuario.dt-aprovacao   = today
              usuario.cd-userid      = v_cod_usuar_corren
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


       /* ----- VERIFICA SE A MODALIDADE E' MEDICINA OCUPACIONAL ----------- */
       assign lg-medocup-aux    = no
              lg-grava-carteira = yes.
 
       run rtp/rttipmed.p (input        usuario.cd-modalidade,
                           input        no,
                           output       lg-undo-retry,
                           output       ds-erro-aux,
                           input-output lg-medocup-aux).
 
       if   lg-medocup-aux
       then do:
              if   not paravpmc.lg-imp-carteira-mo
              then assign lg-grava-carteira = no.
            end.
 
 
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
              car-ide.cd-userid           = v_cod_usuar_corren
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

       if   lg-grava-carteira
       and  tt-param.lg-imp-carteira
       then assign car-ide.nr-impressao = 0
                   car-ide.dt-emissao   = ?.
       else assign car-ide.nr-impressao = 1
                   car-ide.dt-emissao   = today.
       
    
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

        /* ---------------------------------------------------- ATUALIZACA0 DA USMOVADM --- */
       for each tmp-par-usmovadm:
           delete tmp-par-usmovadm.
       end.
       
       create tmp-par-usmovadm.
       assign tmp-par-usmovadm.in-funcao            = "LIB"
              tmp-par-usmovadm.lg-prim-mens         = yes
              tmp-par-usmovadm.lg-simula            = no
              tmp-par-usmovadm.lg-devolve-dados     = no
              tmp-par-usmovadm.cd-modalidade        = usuario.cd-modalidade
              tmp-par-usmovadm.nr-proposta          = usuario.nr-proposta 
              tmp-par-usmovadm.cd-usuario           = usuario.cd-usuario
              tmp-par-usmovadm.cd-padrao-cobertura  = usuario.cd-padrao-cobertura
              tmp-par-usmovadm.cd-userid            = v_cod_usuar_corren.
       
       run api-usmovadm in h-api-usmovadm-aux (input-output table tmp-usmovadm,
                                               input-output table tmp-par-usmovadm,
                                               output       table tmp-msg-usmovadm,
                                               input        no).
       
       if   return-value = "erro"
       then do:
              for each tmp-msg-usmovadm:
                  ds-erro-aux = tmp-msg-usmovadm.ds-mensagem +
                                        tmp-msg-usmovadm.ds-chave.
                  run gera-erro(input ds-erro-aux, 
                                input "E").
              end.
       
              undo, return.
            end.
   end.

   if   paramecp.cd-mediocupa = modalid.cd-tipo-medicina
   then for each depsetse where depsetse.cd-modalidade = propost.cd-modalidade
                            and depsetse.nr-proposta   = propost.nr-proposta  exclusive-lock:
            assign depsetse.nr-ter-adesao = propost.nr-ter-adesao.
        end.
        
   if   modalid.pc-afericao = 0
   then do:
          if   propost.nr-pessoas-titulares   <> 0 
          or   propost.nr-pessoas-dependentes <> 0
          then do:
                 assign propost.nr-pessoas-titulares   = 0
                        propost.nr-pessoas-dependentes = 0.
                 
                 for each pr-id-us where pr-id-us.cd-modalidade = propost.cd-modalidade
                                     and pr-id-us.nr-proposta   = propost.nr-proposta exclusive-lock:
                     delete pr-id-us.
                 end.                
               end.
        end.
   else do:    
            if   propost.nr-pessoas-titulares   = 0
            and  propost.nr-pessoas-dependentes = 0 
            then do:
                   /* ---------------- GERAR A INFORMACAO --- */
                   run vpp/vp0311k.p (input  propost.cd-modalidade,
                                      input  propost.nr-proposta,
                                      input  propost.cd-plano,
                                      input  propost.cd-tipo-plano,
                                      input  propost.lg-faixa-etaria-esp,
                                      input  no,   
                                      output propost.nr-pessoas-titulares,
                                      output propost.nr-pessoas-dependentes,
                                      output lg-undo-retry,
                                      output ds-erro-aux,
                                      output ds-chave-gera-aux).

                   if   lg-undo-retry
                   then do:
                          run gera-erro(input ds-erro-aux,
                                        input "E").
                          next.   
                        end.
                 end.
          end.
END.


{hdp/hddelpersis.i}

procedure verif-cob-usu-exc:

  /* ------------ ATUALIZA DATAS DA TABELA DE COBERTURA POR BENEFICIARIOS ---- */
  for each usucarproc where usucarproc.cd-modalidade = usuario.cd-modalidade
                        and usucarproc.nr-proposta   = usuario.nr-proposta  
                        and usucarproc.cd-usuario    = usuario.cd-usuario    
                            exclusive-lock:
  
      if   usuario.dt-inclusao-plano > usucarproc.dt-inicio
      then assign usucarproc.dt-inicio       = usuario.dt-inclusao-plano
                  usucarproc.dt-atualizacao  = today
                  usucarproc.cd-userid       = v_cod_usuar_corren.
     
      if   propost.dt-libera-doc = ?
      then do:
             if   usuario.dt-exclusao-plano <> ?
             and  usuario.dt-exclusao-plano <  ter-ade.dt-fim
             then do:
                    if   usucarproc.dt-cancelamento = ?
                    then assign usucarproc.dt-fim          = usuario.dt-exclusao-plano
                                usucarproc.dt-cancelamento = usuario.dt-exclusao-plano.
  
                    else assign usucarproc.dt-cancelamento = if   usucarproc.dt-cancelamento > usuario.dt-exclusao-plano
                                                             then usuario.dt-exclusao-plano
                                                             else usucarproc.dt-cancelamento
                               
                                usucarproc.dt-fim          = if   usucarproc.dt-fim = ?
                                                             then usuario.dt-exclusao-plano
                                                             else usucarproc.dt-fim
                                usucarproc.dt-atualizacao  = today
                                usucarproc.cd-userid       = v_cod_usuar_corren.
                    
                  end.
             
             else do:
                    if usucarproc.dt-cancelamento = ? 
                    then assign usucarproc.dt-fim          = ter-ade.dt-fim. 
                   
                    else assign usucarproc.dt-fim          = if   usucarproc.dt-fim = ?
                                                             then ter-ade.dt-fim
                                                             else usucarproc.dt-fim
                   
                                usucarproc.dt-cancelamento = if   usucarproc.dt-cancelamento > ter-ade.dt-fim
                                                             then ter-ade.dt-fim
                                                             else usucarproc.dt-cancelamento
                                usucarproc.dt-atualizacao  = today
                                usucarproc.cd-userid       = v_cod_usuar_corren.
  
                  end.
     
           end.
      else assign usucarproc.dt-fim = propost.dt-libera-doc.
  end.

end procedure.

procedure gera-erro:
    def input parameter ds-erro-par          as char no-undo. 
    def input parameter cd-tipo-mensagem-par as char no-undo. 

    create wk-erros.
    assign wk-erros.cd-modalidade       = propost.cd-modalidade
           wk-erros.nr-proposta         = propost.nr-proposta
           wk-erros.cd-sit-proposta     = propost.cd-sit-proposta
           wk-erros.nr-insc-contratante = propost.nr-insc-contratante
           wk-erros.cd-contratante      = propost.cd-contratante
           wk-erros.cd-tipo-mensagem    = cd-tipo-mensagem-par
           wk-erros.ds-mensagem         = ds-erro-par.
end procedure. 
