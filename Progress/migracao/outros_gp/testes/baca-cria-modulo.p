DEF BUFFER b-import-propost FOR import-propost. 
DEF VAR lg-relat-erro AS LOG NO-UNDO. 
DEF VAR v_cod_usuar_corren AS CHAR NO-UNDO. 
DEF VAR nro-seq-aux AS INT NO-UNDO. 
v_cod_usuar_corren = 'faoro'.


OUTPUT TO c:\temp\valida.txt.



DEF VAR ix AS INT NO-UNDO. 

ix = 0. 

FOR EACH b-import-propost NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

    FOR FIRST pro-pla WHERE pro-pla.cd-modalidade = b-import-propost.cd-modalidade 
                        AND pro-pla.nr-proposta   = b-import-propost.num-livre-10 NO-LOCK QUERY-TUNING (NO-INDEX-HINT): END.

    IF AVAIL pro-pla
    THEN NEXT. 

 

    RUN cria-modulos.

    PUT UNFORM "Mod:" b-import-propost.cd-modalidade  " -Prop:" b-import-propost.num-livre-10 SKIP. 

 
     ix = ix + 1. 
    IF ix >= 1000
        THEN LEAVE. 
END.


OUTPUT CLOSE.




PROCEDURE cria-modulos:


    FOR EACH import-modul-propost FIELDS (cd-modulo cd-forma-pagto in-cobra-participacao ind-respons-autoriz nr-dias log-bonif-penalid in-ctrl-carencia-proced qt-caren-eletiva qt-caren-urgencia log-carenc dat-inicial dat-cancel cd-motivo-cancel ind-respons-autoriz in-cobra-participacao in-ctrl-carencia-insumo)
       WHERE import-modul-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost NO-LOCK QUERY-TUNING (NO-INDEX-HINT):


        /*------------------------------------------------------------------------*/
        for first pla-mod fields (cd-modulo lg-obrigatorio in-cobra-participacao in-responsavel-autorizacao qt-caren-eletiva qt-caren-urgencia)
            where pla-mod.cd-modalidade = b-import-propost.cd-modalidade
              and pla-mod.cd-plano      = b-import-propost.cd-plano
              and pla-mod.cd-tipo-plano = b-import-propost.cd-tipo-plano
              and pla-mod.cd-modulo     = import-modul-propost.cd-modulo NO-LOCK QUERY-TUNING (NO-INDEX-HINT): end.

             for each pro-pla FIELDS (dt-cancelamento dt-inicio) use-index pro-pla3
                where pro-pla.cd-modalidade = b-import-propost.cd-modalidade
                  and pro-pla.nr-proposta   = b-import-propost.num-livre-10
                  and pro-pla.cd-modulo     = import-modul-propost.cd-modulo
                      no-lock:

                 if  pro-pla.dt-cancelamento = ? 
                 then do:
                        if import-modul-propost.dat-cancel = ?
                        then do:
                               assign lg-relat-erro = yes.
                               run pi-grava-erro ("Modulo ja cadastrado para a proposta: " + string(import-modul-propost.cd-modulo,"999")).
                             END.
                        ELSE if import-modul-propost.dat-cancel >= pro-pla.dt-inicio
                             then do:
                                    assign lg-relat-erro = yes.
                                    run pi-grava-erro ("Data de cancel. nao pode ser superior a data de inicio do mod. ja cadast. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                                  END.
                                 
                        if import-modul-propost.dat-inicial >= pro-pla.dt-inicio
                        then do:
                               assign lg-relat-erro = yes.
                               run pi-grava-erro ("Data de inicio nao pode ser superior a data de inicio do mod. ja cadast. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                             END.
                      end.
                 else do:
                        if  import-modul-propost.dat-inicial >= pro-pla.dt-inicio             
                        and import-modul-propost.dat-inicial <= pro-pla.dt-cancelamento
                        then DO:
                               assign lg-relat-erro = yes.
                               run pi-grava-erro ("Data de vigencia do modulo nao pode sobrepor a de um mesmo modulo cadastrado. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                             END.

                        if  import-modul-propost.dat-cancel >= pro-pla.dt-inicio             
                        and import-modul-propost.dat-cancel <= pro-pla.dt-cancelamento
                        then do:
                               assign lg-relat-erro = yes. 
                               run pi-grava-erro ("Data de vigencia do modulo nao pode sobrepor a de um mesmo modulo cadastrado. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                             END.
                      end. 
             end.

        IF lg-relat-erro 
        THEN NEXT.

        FOR FIRST  mod-cob where mod-cob.cd-modulo = import-modul-propost.cd-modulo no-lock QUERY-TUNING (NO-INDEX-HINT): end.


        if   not pla-mod.lg-obrigatorio
        THEN DO:
                 create pro-pla.
                 assign pro-pla.cd-modalidade              = b-import-propost.cd-modalidade
                        pro-pla.cd-plano                   = b-import-propost.cd-plano
                        pro-pla.cd-tipo-plano              = b-import-propost.cd-tipo-plano
                        pro-pla.cd-modulo                  = import-modul-propost.cd-modulo
                        pro-pla.nr-proposta                = b-import-propost.num-livre-10
                        pro-pla.cd-forma-pagto             = import-modul-propost.cd-forma-pagto                         
                        pro-pla.in-cobra-participacao      = import-modul-propost.in-cobra-participacao 
                        pro-pla.in-responsavel-autorizacao = import-modul-propost.ind-respons-autoriz 
                        pro-pla.dt-atualizacao             = today
                        pro-pla.cd-userid                  = v_cod_usuar_corren
                        pro-pla.dt-mov-inclusao            = today
                        pro-pla.cd-userid-inclusao         = v_cod_usuar_corren
                        pro-pla.nr-dias                    = import-modul-propost.nr-dias
                        pro-pla.lg-bonifica-penaliza       = import-modul-propost.log-bonif-penalid.
                 
                 case import-modul-propost.in-ctrl-carencia-proced:
                      when 0 /* Sem carencia por procedimento */
                      then assign pro-pla.in-ctrl-carencia-proced = import-modul-propost.in-ctrl-carencia-proced.
        
                      when 1 /* Carencia de procedimento por modulo */
                      then assign pro-pla.in-ctrl-carencia-proced = import-modul-propost.in-ctrl-carencia-proced
                                  pro-pla.qt-caren-eletiva        = import-modul-propost.qt-caren-eletiva       
                                  pro-pla.qt-caren-urgencia       = import-modul-propost.qt-caren-urgencia.
        
                      when 2 /* Carencia de procedimento por procedimento */
                      then assign pro-pla.in-ctrl-carencia-proced = import-modul-propost.in-ctrl-carencia-proced.
                 end case.
        
                 assign pro-pla.lg-carencia              = import-modul-propost.log-carenc
                        pro-pla.lg-cobertura-obrigatoria = /*import-modul-propost.log-cobert-obrig*/ pla-mod.lg-obrigatorio
                        pro-pla.dt-inicio                = import-modul-propost.dat-inicial
                        pro-pla.dt-cancelamento          = import-modul-propost.dat-cancel
                        pro-pla.cd-motivo-cancel         = import-modul-propost.cd-motivo-cancel
                        pro-pla.dt-fim                   = b-import-propost.dat-fim-propost.
                 
                 if   import-modul-propost.dat-cancel <> ?
                 then assign pro-pla.dt-mov-exclusao    = today
                             pro-pla.cd-userid-exclusao = v_cod_usuar_corren.
             END.
        ELSE  DO:
                    if   b-import-propost.cd-forma-pagto = 1
                    or   b-import-propost.cd-forma-pagto = 2
                    then do: 
                           create pro-pla.
                           assign pro-pla.cd-modalidade           = b-import-propost.cd-modalidade
                                  pro-pla.cd-plano                = b-import-propost.cd-plano
                                  pro-pla.cd-tipo-plano           = b-import-propost.cd-tipo-plano
                                  pro-pla.cd-modulo               = pla-mod.cd-modulo
                                  pro-pla.nr-proposta             = b-import-propost.num-livre-10
                                  pro-pla.cd-forma-pagto          = b-import-propost.cd-forma-pagto
                                  pro-pla.lg-carencia             = yes
                                  pro-pla.lg-cobertura-obrigato   = yes
                                  pro-pla.in-ctrl-carencia-proced = import-modul-propost.in-ctrl-carencia-proced
                                  pro-pla.in-ctrl-carencia-insumo = import-modul-propost.in-ctrl-carencia-insumo
                                  pro-pla.dt-inicio               = b-import-propost.dat-propost
                                  pro-pla.dt-cancelamento         = b-import-propost.dat-fim-propost
                                  pro-pla.dt-fim                  = b-import-propost.dat-fim-propost
                                  pro-pla.in-cobra-participacao   = import-modul-propost.in-cobra-participacao
                                  pro-pla.in-responsavel-autori   = import-modul-propost.ind-respons-autoriz
                                  pro-pla.dt-atualizacao          = today
                                  pro-pla.cd-userid               = v_cod_usuar_corren
                                  pro-pla.dt-mov-inclusao         = today
                                  pro-pla.cd-userid-inclusao      = v_cod_usuar_corren.
                           
                           if mod-cob.in-ctrl-carencia-proced = 1
                           or mod-cob.in-ctrl-carencia-insumo = 1
                           then assign pro-pla.qt-caren-eletiva  = import-modul-propost.qt-caren-eletiva 
                                       pro-pla.qt-caren-urgencia = import-modul-propost.qt-caren-urgencia.
                           else assign pro-pla.qt-caren-eletiva  = 0 
                                       pro-pla.qt-caren-urgencia = 0.
                           
                           if   b-import-propost.dat-fim-propost = ?
                           then.
                           else assign pro-pla.dt-mov-exclusao    = today
                                       pro-pla.cd-userid-exclusao = v_cod_usuar_corren.
                         END.

                    if   b-import-propost.cd-forma-pagto = 3
                    then do:
                           find plamofor where plamofor.cd-modalidade = b-import-propost.cd-modalidade
                                           and plamofor.cd-plano      = b-import-propost.cd-plano
                                           and plamofor.cd-tipo-plano = b-import-propost.cd-tipo-plano
                                           and plamofor.cd-modulo     = pla-mod.cd-modulo
                                               no-lock no-error.
                           if avail plamofor
                           THEN DO:
                                  create pro-pla.
                                  assign pro-pla.cd-modalidade            = b-import-propost.cd-modalidade
                                         pro-pla.cd-plano                 = b-import-propost.cd-plano
                                         pro-pla.cd-tipo-plano            = b-import-propost.cd-tipo-plano
                                         pro-pla.cd-modulo                = plamofor.cd-modulo
                                         pro-pla.nr-proposta              = b-import-propost.num-livre-10
                                         pro-pla.cd-forma-pagto           = plamofor.cd-forma-pagto
                                         pro-pla.lg-carencia              = yes
                                         pro-pla.lg-cobertura-obrigatoria = yes
                                         pro-pla.in-ctrl-carencia-proced  = import-modul-propost.in-ctrl-carencia-proced
                                         pro-pla.in-ctrl-carencia-insumo  = import-modul-propost.in-ctrl-carencia-insumo
                                         pro-pla.qt-caren-eletiva         = import-modul-propost.qt-caren-eletiva 
                                         pro-pla.qt-caren-urgencia        = import-modul-propost.qt-caren-urgencia
                                         pro-pla.in-cobra-participacao    = import-modul-propost.in-cobra-participacao
                                         pro-pla.in-responsavel-autori    = import-modul-propost.ind-respons-autoriz  
                                         pro-pla.dt-inicio                = b-import-propost.dat-propost
                                         pro-pla.dt-cancelamento          = b-import-propost.dat-fim-propost
                                         pro-pla.dt-fim                   = b-import-propost.dat-fim-propost
                                         pro-pla.dt-atualizacao           = today
                                         pro-pla.cd-userid                = v_cod_usuar_corren
                                         pro-pla.dt-mov-inclusao          = today
                                         pro-pla.cd-userid-inclusao       = v_cod_usuar_corren.
                                  
                                   if   b-import-propost.dat-fim-propost = ?
                                   then.
                                   else assign pro-pla.dt-mov-exclusao    = today
                                               pro-pla.cd-userid-exclusao = v_cod_usuar_corren. 
                                END.
                         END.
        END.
    END.

END PROCEDURE.


procedure pi-grava-erro:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.

    IF nro-seq-aux = 0
    THEN do:
           IF CAN-FIND (FIRST erro-process-import WHERE erro-process-import.num-seqcial-control = b-import-propost.num-seqcial-control)
           THEN RUN pi-consulta-prox-seq (INPUT b-import-propost.num-seqcial-control, OUTPUT nro-seq-aux).
           ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
         END.
    ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
    
    create erro-process-import.
    assign erro-process-import.num-seqcial         = nro-seq-aux
           erro-process-import.num-seqcial-control = b-import-propost.num-seqcial-control
           erro-process-import.nom-tab-orig-erro   = "MODULO"
           erro-process-import.des-erro            = ds-erro-par
           erro-process-import.dat-erro            = today. 


end procedure.
