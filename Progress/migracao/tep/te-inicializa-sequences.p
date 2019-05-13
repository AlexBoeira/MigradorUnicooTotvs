DEF VAR id-sequence-aux                                         AS DEC NO-UNDO.
def new global shared var v_cod_usuar_corren                    as char no-undo.
DEF VAR nm-arq-log-aux                                          AS CHAR NO-UNDO.

ASSIGN nm-arq-log-aux = SESSION:TEMP-DIR + "te-inicializa-sequences.log".

OUTPUT TO VALUE(nm-arq-log-aux) APPEND.

PROCESS EVENTS.
RUN escreve-log("Inicio do processo...").
RUN inicializa-sequences.
RUN escreve-log("Final do processo.").
OUTPUT CLOSE.

MESSAGE "Processo concluido!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE inicializa-sequences:

    /**
     * Inicializacao das sequences. Mesmo que nao existam registros nas tabelas correspondentes,
     * as sequences serao inicializadas com 1.
     */
    
    /**
     * Inicializar a sequence SEQ-PESSOA
     */
    RUN escreve-log("inicializando SEQ-PESSOA...").

    ASSIGN id-sequence-aux = 1.
    FOR LAST pessoa-fisica fields(id-pessoa) USE-INDEX pfis1 NO-LOCK:
        ASSIGN id-sequence-aux = pessoa-fisica.id-pessoa.
    END.

    FOR LAST pessoa-juridica fields(id-pessoa) USE-INDEX pessoa-juridica1 NO-LOCK:
        IF pessoa-juridica.id-pessoa > id-sequence-aux
        THEN ASSIGN id-sequence-aux = pessoa-juridica.id-pessoa.
    END.
    
    RUN escreve-log("id-pessoa a ser inicializado: " + STRING(id-sequence-aux) + ". ").
    
    REPEAT:
      IF NEXT-VALUE(seq-pessoa) >= id-sequence-aux
      THEN LEAVE.
    END.

    RUN escreve-log("fim da inicializacao de SEQ-PESSOA...").
    
    ASSIGN id-sequence-aux = 1.
    FOR LAST pessoa-fisic-simul fields(id-pessoa) NO-LOCK:
        ASSIGN id-sequence-aux = pessoa-fisic-simul.id-pessoa.
    END.

    FOR LAST pessoa-jurid-simul fields(id-pessoa) NO-LOCK:
        IF pessoa-jurid-simul.id-pessoa > id-sequence-aux
        THEN ASSIGN id-sequence-aux = pessoa-jurid-simul.id-pessoa.
    END.
    
    REPEAT:
      IF NEXT-VALUE(seq-pessoa-simul) >= id-sequence-aux
      THEN LEAVE.
    END.

    /**
     * Inicializar a sequence SEQ-AUDIT-CAD
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-cad).
    FOR LAST audit-cad fields(id-audit-cad) 
       WHERE audit-cad.id-audit-cad > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-cad) >= audit-cad.id-audit-cad
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-CONFIG-AUDIT-CAD
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-config-audit-cad).
    FOR LAST config-audit-cad fields(id-config-audit)
       WHERE config-audit-cad.id-config-audit > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-config-audit-cad) >= config-audit-cad.id-config-audit
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-CONTAT-PESSOA-SIMUL
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-contat-pessoa-simul).
    FOR LAST contat-pessoa-simul fields(id-contato)
       WHERE contat-pessoa-simul.id-contato > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-contat-pessoa-simul) >= contat-pessoa-simul.id-contato
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-CONTATO-PESSOA
     */
    RUN escreve-log("inicializando SEQ-CONTATO-PESSOA...").

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-contato-pessoa).
    FOR LAST contato-pessoa fields(id-contato)
       WHERE contato-pessoa.id-contato > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-contato-pessoa) >= contato-pessoa.id-contato
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-CONTRAT-SIMUL
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-contrat-simul).
    FOR LAST contrat-simul fields(idi-contrat)
       WHERE contrat-simul.idi-contrat > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-contrat-simul) >= contrat-simul.idi-contrat
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-ENDERECO
     */
    RUN escreve-log("inicializando SEQ-ENDERECO...").

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-endereco).
    FOR LAST shsrcadger.endereco FIELDS(id-endereco)
       WHERE endereco.id-endereco > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-endereco) >= endereco.id-endereco
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HIST-ALTER-GP
     */
    RUN escreve-log("inicializando SEQ-HIST-ALTER-GP...").

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-hist-alter-gp).
    FOR LAST hist-alter-gp fields(id-hist-alter)
       WHERE hist-alter-gp.id-hist-alter > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-hist-alter-gp) >= hist-alter-gp.id-hist-alter
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HIST-MOVTO
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-hist-movto).
    FOR LAST hist-movto fields(id-registro)
       WHERE hist-movto.id-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-hist-movto) >= hist-movto.id-registro
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HIST-VISITA
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-hist-visita).
    FOR LAST hist-visita fields(id-hist-visita) 
       WHERE hist-visita.id-hist-visita > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-hist-visita) >= hist-visita.id-hist-visita
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HISTOR-RPC-HEADER
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-histor-rpc-header).
    FOR LAST histor-rpc-header fields(idi-registro)
       WHERE histor-rpc-header.idi-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-histor-rpc-header) >= histor-rpc-header.idi-registro
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HISTOR-RPC-JUSTIF
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-histor-rpc-justif).
    FOR LAST histor-rpc-justif fields(idi-registro)
       WHERE histor-rpc-justif.idi-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-histor-rpc-justif) >= histor-rpc-justif.idi-registro
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HISTOR-RPC-PLANO
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-histor-rpc-plano).
    FOR LAST histor-rpc-plano fields(idi-registro)
       WHERE histor-rpc-plano.idi-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-histor-rpc-plano) >= histor-rpc-plano.idi-registro
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HISTOR-RPC-VAL
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-histor-rpc-val).
    FOR LAST histor-rpc-val fields(idi-registro)
       WHERE histor-rpc-val.idi-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-histor-rpc-val) >= histor-rpc-val.idi-registro
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-HISTOR-SIMUL-PROPOST
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-histor-simul-propost).
    FOR LAST histor-simul-propost fields(num-id-histor-simul)
       WHERE histor-simul-propost.num-id-histor-simul > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-histor-simul-propost) >= histor-simul-propost.num-id-histor-simul
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-MWCINPUT
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-mwcinput).
    FOR LAST mwcinput fields(mwcinputuid)
       WHERE mwcinput.mwcinputuid > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-mwcinput) >= mwcinput.mwcinputuid
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-REFERENCIA-CONTRAT
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-referencia-contrat).
    FOR LAST referencia-contrat fields(id-referencia)
       WHERE referencia-contrat.id-referencia > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-referencia-contrat) >= referencia-contrat.id-referencia
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-REG-PLANO-SAUDE
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-reg-plano-saude).
    FOR LAST reg-plano-saude fields(idi-registro)
       WHERE reg-plano-saude.idi-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-reg-plano-saude) >= reg-plano-saude.idi-registro
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-REG-PLANO-SAUDE-VAL
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-reg-plano-saude-val).
    FOR LAST reg-plano-saude-val fields(idi-registro)
       WHERE reg-plano-saude-val.idi-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-reg-plano-saude-val) >= reg-plano-saude-val.idi-registro
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-anexo).
    FOR LAST anexo fields(cdd-anexo)
       WHERE anexo.cdd-anexo > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-anexo) >= anexo.cdd-anexo
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-anexo-benef).

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-assocva-cidad-empres-estab).
    FOR LAST assocva-cidad-empres-estab fields(cdn-cidad-empres-estab)
       WHERE assocva-cidad-empres-estab.cdn-cidad-empres-estab > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-assocva-cidad-empres-estab) >= assocva-cidad-empres-estab.cdn-cidad-empres-estab
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-atendimento).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-cancel-contrat).
    FOR LAST audit-cancel-contrat fields(cdd-audit-cancel-contrat)
       WHERE audit-cancel-contrat.cdd-audit-cancel-contrat > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-cancel-contrat) >= audit-cancel-contrat.cdd-audit-cancel-contrat
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-exc-bnfciar).
    FOR LAST audit-exc-bnfciar fields(cdd-audit-exc-bnfciar)
       WHERE audit-exc-bnfciar.cdd-audit-exc-bnfciar > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-exc-bnfciar) >= audit-exc-bnfciar.cdd-audit-exc-bnfciar
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-reativ).
    FOR LAST audit-reativ fields(cdd-audit-reativ)
       WHERE audit-reativ.cdd-audit-reativ > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-reativ) >= audit-reativ.cdd-audit-reativ
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-segnda-via-contrat).
    FOR LAST audit-segnda-via-contrat fields(cdd-audit-segnda-via-contra)
       WHERE audit-segnda-via-contrat.cdd-audit-segnda-via-contra > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-segnda-via-contrat) >= audit-segnda-via-contrat.cdd-audit-segnda-via-contra
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-seguro-assistal).
    FOR LAST audit-seguro-assistal fields(cdd-audit-seguro-assistal)
       WHERE audit-seguro-assistal.cdd-audit-seguro-assistal > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-seguro-assistal) >= audit-seguro-assistal.cdd-audit-seguro-assistal
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-audit-transf-bnfciar).
    FOR LAST audit-transf-bnfciar fields(cdd-transf-bnfciar)
       WHERE audit-transf-bnfciar.cdd-transf-bnfciar > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-audit-transf-bnfciar) >= audit-transf-bnfciar.cdd-transf-bnfciar
               THEN LEAVE.
             END.
    END.

    NEXT-VALUE(seq-base-conhecimento-cat).
    
    NEXT-VALUE(seq-base-conhecimento-top).
    
    /*
    NEXT-VALUE(seq-base-conhecto).*/

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-calend-atendim).
    FOR LAST hmr-calend-atendim fields(cdn-calend-atendim)
       WHERE hmr-calend-atendim.cdn-calend-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-calend-atendim) >= hmr-calend-atendim.cdn-calend-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-calend-atendim-dia).
    FOR LAST hmr-calend-atendim-dia fields(cdn-calend-atendim-dia)
       WHERE hmr-calend-atendim-dia.cdn-calend-atendim-dia > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-calend-atendim-dia) >= hmr-calend-atendim-dia.cdn-calend-atendim-dia
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-calend-turno).
    FOR LAST hmr-calend-turno fields(cdn-calend-turno)
       WHERE hmr-calend-turno.cdn-calend-turno > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-calend-turno) >= hmr-calend-turno.cdn-calend-turno
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-campo-control-processo).
    FOR LAST campo-control-proces fields(cdd-campo-control-proces)
       WHERE campo-control-proces.cdd-campo-control-proces > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-campo-control-processo) >= campo-control-proces.cdd-campo-control-proces
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-campo-regra-audit).
    FOR LAST campo-regra-audit fields(cdd-campo-regra-audit)
       WHERE campo-regra-audit.cdd-campo-regra-audit > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-campo-regra-audit) >= campo-regra-audit.cdd-campo-regra-audit
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-cancel-contrat-bnfciar).
    FOR LAST cancel-contrat-bnfciar fields(cdd-cancel-contrat-bnfciar)
       WHERE cancel-contrat-bnfciar.cdd-cancel-contrat-bnfciar > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-cancel-contrat-bnfciar) >= cancel-contrat-bnfciar.cdd-cancel-contrat-bnfciar
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-categ-atendim).
    FOR LAST hmr-categ-atendim fields(cdn-categ-atendim)
       WHERE hmr-categ-atendim.cdn-categ-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-categ-atendim) >= hmr-categ-atendim.cdn-categ-atendim
               THEN LEAVE.
             END.
    END.
    /*
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-categ-base-conhecto).
    FOR LAST hmr-categ-base-conhecto fields(cdn-categ-base-conhecto)
       WHERE hmr-categ-base-conhecto.cdn-categ-base-conhecto > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-categ-base-conhecto) >= hmr-categ-base-conhecto.cdn-categ-base-conhecto
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-categoria-atendimento).
    */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-chamado).
    FOR LAST chamado FIELDS (id-chamado)
       WHERE chamado.id-chamado > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-chamado) >= chamado.id-chamado
               THEN LEAVE.
             END.
    END.

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-chamado-atendim).
    FOR LAST hmr-chamado-atendim fields(cdn-chamado-atendim)
       WHERE hmr-chamado-atendim.cdn-chamado-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-chamado-atendim) >= hmr-chamado-atendim.cdn-chamado-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-config-obrig-anexo).
    FOR LAST config-obrig-anexo fields(cdd-config-obrig-anexo)
       WHERE config-obrig-anexo.cdd-config-obrig-anexo > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-config-obrig-anexo) >= config-obrig-anexo.cdd-config-obrig-anexo
               THEN LEAVE.
             END.
    END.
    /*
    NEXT-VALUE(seq-docoriginal).*/
    
    /*ASSIGN id-sequence-aux = NEXT-VALUE(seq-docto-base-conhecto).
    FOR LAST hmr-docto-base-conhecto fields(cdn-docto-base-conhecto)
       WHERE hmr-docto-base-conhecto.cdn-docto-base-conhecto > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-docto-base-conhecto) >= hmr-docto-base-conhecto.cdn-docto-base-conhecto
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-documento-base-com).
    */
    NEXT-VALUE(seq-endereco-pessoa).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-exc-bnfciar-selec).
    FOR LAST exc-bnfciar-selec fields(cdd-exc-bnfciar-selec)
       WHERE exc-bnfciar-selec.cdd-exc-bnfciar-selec > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-exc-bnfciar-selec) >= exc-bnfciar-selec.cdd-exc-bnfciar-selec
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-grc).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-grp-atendim).
    FOR LAST hmr-grp-atendim fields(cdn-grp-atendim)
       WHERE hmr-grp-atendim.cdn-grp-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-grp-atendim) >= hmr-grp-atendim.cdn-grp-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-grp-atendim-calend).
    FOR LAST hmr-grp-atendim-calend FIELDS(cdn-grp-atendim-calend)
       WHERE hmr-grp-atendim-calend.cdn-grp-atendim-calend > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-grp-atendim-calend) >= hmr-grp-atendim-calend.cdn-grp-atendim-calend
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-grp-atendim-contrnte).
    FOR LAST hmr-grp-atendim-contrnte fields(cdn-grp-atendim-contrnte)
       WHERE hmr-grp-atendim-contrnte.cdn-grp-atendim-contrnte > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-grp-atendim-contrnte) >= hmr-grp-atendim-contrnte.cdn-grp-atendim-contrnte
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-grp-atendim-motiv).
    FOR LAST hmr-grp-atendim-motiv fields(cdn-grp-atendim-motiv)
       WHERE hmr-grp-atendim-motiv.cdn-grp-atendim-motiv > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-grp-atendim-motiv) >= hmr-grp-atendim-motiv.cdn-grp-atendim-motiv
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-grp-atendim-permis).
    FOR LAST hmr-grp-atendim-permis fields(cdn-grp-atendim-permis)
       WHERE hmr-grp-atendim-permis.cdn-grp-atendim-permis > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-grp-atendim-permis) >= hmr-grp-atendim-permis.cdn-grp-atendim-permis
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-grp-estado-cidad-exp).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-grupo-atendimento).
    FOR LAST grupo-atendimento fields(id-grupo-atendimento)
       WHERE grupo-atendimento.id-grupo-atendimento > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-grupo-atendimento) >= grupo-atendimento.id-grupo-atendimento
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-guiautor).
    for LAST guiautor fields(nr-guia-atendimento)
       WHERE guiautor.nr-guia-atendimento > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-guiautor) >= guiautor.nr-guia-atendimento
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-histor-docto-revis-ctas-d).
    
    NEXT-VALUE(seq-histor-movimen-insumo-i).
    
    NEXT-VALUE(seq-histor-movimen-proced-p).

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-horario-atendimento).
    FOR LAST horario-atendimento FIELDS(id-horario-atendimento)
       WHERE horario-atendimento.id-horario-atendimento > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-horario-atendimento) >= horario-atendimento.id-horario-atendimento
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-imp-movto).

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-impres-digital-pessoa).
    FOR LAST impres-digital-pessoa fields(idi-seq)
       WHERE impres-digital-pessoa.idi-seq > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-impres-digital-pessoa) >= impres-digital-pessoa.idi-seq
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-impug).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-motiv-atendim).
    FOR LAST hmr-motiv-atendim fields(cdn-motiv-atendim)
       WHERE hmr-motiv-atendim.cdn-motiv-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-motiv-atendim) >= hmr-motiv-atendim.cdn-motiv-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-motiv-cancel-atendim).
    FOR LAST hmr-motiv-cancel-atendim fields(cdn-motiv-cancel-atendim)
       WHERE hmr-motiv-cancel-atendim.cdn-motiv-cancel-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-motiv-cancel-atendim) >= hmr-motiv-cancel-atendim.cdn-motiv-cancel-atendim
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-motivo-atendimento).
    
    NEXT-VALUE(seq-motivo-cancelamento-atend).
    
    NEXT-VALUE(seq-motivo-rejeicao).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-msg-atendim).
    FOR LAST hmr-msg-atendim fields(cdn-msg-atendim)
       WHERE hmr-msg-atendim.cdn-msg-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-msg-atendim) >= hmr-msg-atendim.cdn-msg-atendim
               THEN LEAVE.
             END.
    END.

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-msg-atendim-contrnte).
    FOR LAST hmr-msg-atendim-contrnte fields(cdn-msg-atendim-contrnte)
       WHERE hmr-msg-atendim-contrnte.cdn-msg-atendim-contrnte > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-msg-atendim-contrnte) >= hmr-msg-atendim-contrnte.cdn-msg-atendim-contrnte
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-msg-atendim-grp-atendim).
    FOR LAST hmr-msg-atendim-grp-atendim fields(cdn-msg-atendim-grp-atendim)
       WHERE hmr-msg-atendim-grp-atendim.cdn-msg-atendim-grp-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-msg-atendim-grp-atendim) >= hmr-msg-atendim-grp-atendim.cdn-msg-atendim-grp-atendim
               THEN LEAVE.
             END.
    END.
    
    /*
    if current-value(seq-msg-cadast) < 1
    then NEXT-VALUE(seq-msg-cadast).
    for LAST msg-cadast fields(cdd-msg-cadast)
       where mst-cadast.cdd-msg-cadast > current-value(seq-msg-cadsat) NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-msg-cadast) >= msg-cadast.cdd-msg-cadast
               THEN LEAVE.
             END.
    end.*/
    
    NEXT-VALUE(seq-numero-protocolo).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-perc-def-audit).
    for LAST perc-def-audit fields(cdd-def-audit)
       WHERE perc-def-audit.cdd-def-audit > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-perc-def-audit) >= perc-def-audit.cdd-def-audit
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-perg-pesq-motiv-atendim).
    for LAST hmr-perg-pesq-motiv-atendim fields(cdn-perg-pesq-motiv-atendim)
       WHERE hmr-perg-pesq-motiv-atendim.cdn-perg-pesq-motiv-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-perg-pesq-motiv-atendim) >= hmr-perg-pesq-motiv-atendim.cdn-perg-pesq-motiv-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-perg-pesq-satisfac).
    FOR LAST hmr-perg-pesq-satisfac fields(cdn-perg-pesq-satisfac)
       WHERE hmr-perg-pesq-satisfac.cdn-perg-pesq-satisfac > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-perg-pesq-satisfac) >= hmr-perg-pesq-satisfac.cdn-perg-pesq-satisfac
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-permis-inform-contrnte).
    for LAST hmr-permis-inform-contrnte fields(cdn-permis-inform-contrnte)
       WHERE hmr-permis-inform-contrnte.cdn-permis-inform-contrnte > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-permis-inform-contrnte) >= hmr-permis-inform-contrnte.cdn-permis-inform-contrnte
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-permissao-inf-ad).
    FOR LAST permissao-inf-ad fields(id-permissao-inf-ad)
       WHERE permissao-inf-ad.id-permissao-inf-ad > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-permissao-inf-ad) >= permissao-inf-ad.id-permissao-inf-ad
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-pesq-satisfac).
    FOR LAST hmr-pesq-satisfac fields(cdn-pesq-satisfac)
       WHERE hmr-pesq-satisfac.cdn-pesq-satisfac > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-pesq-satisfac) >= hmr-pesq-satisfac.cdn-pesq-satisfac
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-pesq-satisfac-realiz).
    for LAST hmr-pesq-satisfac-realiz fields(cdn-pesq-satisfac-realiz)
       WHERE hmr-pesq-satisfac-realiz.cdn-pesq-satisfac-realiz > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-pesq-satisfac-realiz) >= hmr-pesq-satisfac-realiz.cdn-pesq-satisfac-realiz
               THEN LEAVE.
             END.
    END.

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-pesquisa-pergunta).
    for LAST pesquisa-pergunta fields(id-pesquisa-pergunta)
       WHERE pesquisa-pergunta.id-pesquisa-pergunta > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-pesquisa-pergunta) >= pesquisa-pergunta.id-pesquisa-pergunta
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-pesquisa-satisfacao).
    for LAST pesquisa-satisfacao fields(id-pesquisa-satisfacao)
       WHERE pesquisa-satisfacao.id-pesquisa-satisfacao > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-pesquisa-satisfacao) >= pesquisa-satisfacao.id-pesquisa-satisfacao
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-reativ-bnfciar-contrat).
    for LAST reativ-bnfciar-contrat fields(cdd-reativ-bnfciar-contrat)
       WHERE reativ-bnfciar-contrat.cdd-reativ-bnfciar-contrat > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-reativ-bnfciar-contrat) >= reativ-bnfciar-contrat.cdd-reativ-bnfciar-contrat
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-regatecl).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-regra-audit).
    for LAST regra-audit fields(cdd-regra-audit)
       WHERE regra-audit.cdd-regra-audit > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-regra-audit) >= regra-audit.cdd-regra-audit
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-regra-unif).
    for LAST regra-unif fields(idi-regra)
       WHERE regra-unif.idi-regra > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-regra-unif) >= regra-unif.idi-regra
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-seq-chamado-atendim).
    for LAST hmr-seq-chamado-atendim fields(cdn-seq-chamado-atendim)
       WHERE hmr-seq-chamado-atendim.cdn-seq-chamado-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-seq-chamado-atendim) >= hmr-seq-chamado-atendim.cdn-seq-chamado-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-sequencia-chamado).
    for LAST sequencia-chamado fields(id-sequencia-chamado)
       WHERE sequencia-chamado.id-sequencia-chamado > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-sequencia-chamado) >= sequencia-chamado.id-sequencia-chamado
               THEN LEAVE.
             END.
    END.
    
    /*
    NEXT-VALUE(seq-sequencia-tar-audit).*/
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-sib-movimentacao).
    for LAST sib-movimentacao fields(id-registro)
       WHERE sib-movimentacao.id-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-sib-movimentacao) >= sib-movimentacao.id-registro
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-sib-remessa).
    FOR LAST sib-remessa fields(id-registro)
       WHERE sib-remessa.id-registro > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-sib-remessa) >= sib-remessa.id-registro
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-simul-propost).
    FOR LAST simula-proposta fields(id-simula-proposta)
       WHERE simula-proposta.id-simula-proposta > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-simul-propost) >= simula-proposta.id-simula-proposta
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-simula-benef).
    for LAST simula-benef fields(id-simula-benef)
       WHERE simula-benef.id-simula-benef > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-simula-benef) >= simula-benef.id-simula-benef
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-simula-opcionais).
    FOR LAST simula-opcionais fields(id-simula-opcionais)
       WHERE simula-opcionais.id-simula-opcionais > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-simula-opcionais) >= simula-opcionais.id-simula-opcionais
               THEN LEAVE.
             END.
    END.

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-simula-proposta).
    for LAST simula-proposta fields(id-simula-proposta)
       WHERE simula-proposta.id-simula-proposta > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-simula-proposta) >= simula-proposta.id-simula-proposta
               THEN LEAVE.
             END.
    END.
    
    NEXT-VALUE(seq-situacao-benef).
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-sktsaida).
    for LAST sktsaida fields(nr-sequencia)
       WHERE sktsaida.nr-sequencia > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-sktsaida) >= sktsaida.nr-sequencia
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-tar-audit).
    for LAST tar-audit fields(cdd-tar-audit)
       WHERE tar-audit.cdd-tar-audit > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-tar-audit) >= tar-audit.cdd-tar-audit
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-tar-audit-movto).
    FOR LAST tar-audit-movto fields(cdd-tar-audit-movto)
       WHERE tar-audit-movto.cdd-tar-audit-movto > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-tar-audit-movto) >= tar-audit-movto.cdd-tar-audit-movto
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-tip-anexo).
    FOR LAST tip-anexo fields(cdn-tip-anexo) 
       WHERE tip-anexo.cdn-tip-anexo > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-tip-anexo) >= tip-anexo.cdn-tip-anexo
               THEN LEAVE.
             END.
    END.
    /*
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-topic-base-conhecto).
    for LAST hmr-topic-base-conhecto FIELDS (cdn-topic-base-conhecto)
       WHERE hmr-topic-base-conhecto.cdn-topic-base-conhecto > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-topic-base-conhecto) >= hmr-topic-base-conhecto.cdn-topic-base-conhecto
               THEN LEAVE.
             END.
    END.
    */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-topic-grp-atendim).
    for LAST hmr-topic-grp-atendim fields(cdn-topic-grp-atendim)
       WHERE hmr-topic-grp-atendim.cdn-topic-grp-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-topic-grp-atendim) >= hmr-topic-grp-atendim.cdn-topic-grp-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-transf-bnfciar-selec).
    FOR LAST transf-bnfciar-selec FIELDS(cdd-transf-bnfciar-selec)
       WHERE transf-bnfciar-selec.cdd-transf-bnfciar-selec > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-transf-bnfciar-selec) >= transf-bnfciar-selec.cdd-transf-bnfciar-selec
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-turno-atendim).
    for LAST hmr-turno-atendim fields(cdn-turno-atendim)
       WHERE hmr-turno-atendim.cdn-turno-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-turno-atendim) >= hmr-turno-atendim.cdn-turno-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-usuar-atend).
    for LAST hmr-usuar-atend fields(cdn-usuar-atend)
       WHERE hmr-usuar-atend.cdn-usuar-atend > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-usuar-atend) >= hmr-usuar-atend.cdn-usuar-atend
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-usuar-atendim).
    for LAST hmr-usuar-atendim fields(cdn-usuar-atendim)
       WHERE hmr-usuar-atendim.cdn-usuar-atendim > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-usuar-atendim) >= hmr-usuar-atendim.cdn-usuar-atendim
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-usuar-export).
    for LAST usuar-export fields(cdd-usuar-export)
       WHERE usuar-export.cdd-usuar-export > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-usuar-export) >= usuar-export.cdd-usuar-export
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-usuar-simul).
    for LAST usuar-simul fields(idi-usuario)
       WHERE usuar-simul.idi-usuario > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-usuar-simul) >= usuar-simul.idi-usuario
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-usuario-atendimento).
    FOR LAST usuario-atendimento fields(id-usuario-atendimento)
       WHERE usuario-atendimento.id-usuario-atendimento > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-usuario-atendimento) >= usuario-atendimento.id-usuario-atendimento
               THEN LEAVE.
             END.
    END.
    
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-visita).
    FOR LAST visita fields(id-visita)
       WHERE visita.id-visita > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-visita) >= visita.id-visita
               THEN LEAVE.
             END.
    END.
    
    /*
    if current-value(seq_docto_geral) < 1
    then NEXT-VALUE(seq_docto_geral).
    for LAST docto_geral fields(idi_docto_geral)
       where docto_geral.idi_docto_geral > current-value(seq_docto_geral) NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq_docto_geral) >= docto_geral.idi_docto_geral
               THEN LEAVE.
             END.
    end.*/
    
    /*
    if current-value(seq_gestor_msg) < 1
    then NEXT-VALUE(seq_gestor_msg).
    for LAST gestor_msg fields(idi_gestor_msg)
       where gestor_msg.idi_gestor_msg > current-value(seq_gestor_msg) NO-LOCK:
             rEPEAT:
               IF NEXT-VALUE(seq_gestor_msg) >= gestor_msg.idi_gestor_msg
               THEN LEAVE.
             END.
    end.*/
    
    /*
    if current-value(seq_justif_aces_biom_cartao) < 1
    then NEXT-VALUE(seq_justif_aces_biom_cartao).
    for LAST justif_aces_biom_cartao fields(idi_justif_aces_biom)
       where justif_aces_biom_cartao.idi_justif_aces_biom > current-value(seq_justif_aces_biom_cartao) NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq_justif_aces_biom_cartao) >= justif_aces_biom_cartao.idi_justif_aces_biom
               THEN LEAVE.
             END.
    end.*/
    
    /*
    if current-value(seq_msg_guia_audit) < 1
    then NEXT-VALUE(seq_msg_guia_audit).
    for LAST msg_guia_audit fields(idi_msg_guia_audit)
       where msg_guia_audit.idi_msg_guia_audit > current-value(seq_msg_guia_audit) NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq_msg_guia_audit) >= msg_guia_audit.idi_msg_guia_audit
               THEN LEAVE.
             END.
    end.*/
    
    /*
    if current-value(seq_msg_guia_docto_geral) < 1
    then NEXT-VALUE(seq_msg_guia_docto_geral).
    for LAST msg_guia_docto_geral fields(idi_msg_guia_docto_geral)
       where msg_guia_docto_geral.idi_msg_guia_docto_geral > current-value(seq_msg_guia_docto_geral) NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq_msg_guia_docto_geral) >= msg_guia_docto_geral.idi_msg_guia_docto_geral
               THEN LEAVE.
             END.
    end.*/
    
    /**
     * Inicializar a sequence SEQ-HIST-APROV-PROPOSTA
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-hist-aprov-proposta).
    for LAST hist-aprov-proposta fields(id-hist-aprov-proposta)
       WHERE hist-aprov-proposta.id-hist-aprov-proposta > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-hist-aprov-proposta) >= hist-aprov-proposta.id-hist-aprov-proposta
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SIT-APROV-PROPOSTA
     */
    ASSIGN id-sequence-aux = NEXT-VALUE(seq-sit-aprov-proposta).
    for LAST sit-aprov-proposta fields(id-sit-aprov-proposta)
       WHERE sit-aprov-proposta.id-sit-aprov-proposta > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-sit-aprov-proposta) >= sit-aprov-proposta.id-sit-aprov-proposta
               THEN LEAVE.
             END.
    END.

END PROCEDURE.

PROCEDURE escreve-log:
    DEF INPUT PARAMETER ds-mensagem-par AS CHAR NO-UNDO.

    PUT UNFORMATTED /*STRING(TODAY,"99/99/9999") + " " +*/ string(NOW) + " - " ds-mensagem-par SKIP.

END PROCEDURE.
