REPEAT:
    PROCESS EVENTS.
    for each propost fields(cd-modalidade
                            nr-proposta
                            cd-sit-proposta
                            cd-userid-digitacao
                            dt-digitacao
                            cd-userid-libera       
                            dt-libera-doc  
                            nr-insc-contratante
                            cd-contratante
                            nr-insc-contrat-origem 
                            cd-contrat-origem) NO-LOCK:
    
        PROCESS EVENTS.

        IF not can-find(first sit-aprov-proposta where sit-aprov-proposta.cd-modalidade = propost.cd-modalidade
                                                   and sit-aprov-proposta.nr-proposta   = propost.nr-proposta)
        THEN DO:
               create sit-aprov-proposta.
               assign sit-aprov-proposta.id-sit-aprov-proposta    = next-value(seq-sit-aprov-proposta)
                      sit-aprov-proposta.cd-modalidade            = propost.cd-modalidade
                      sit-aprov-proposta.nr-proposta              = propost.nr-proposta
                      sit-aprov-proposta.cd-userid                = "migracao"
                      sit-aprov-proposta.dt-atualizacao           = today
                      sit-aprov-proposta.ds-observacoes           = "Este registro foi criado pelo processo de migracao do Gestao de Planos TOTVS11, para manter a compatibilidade com as propostas ja existentes na versao anterior do sistema".
             END.
        ELSE DO:
               FIND FIRST sit-aprov-proposta EXCLUSIVE-LOCK
                    WHERE sit-aprov-proposta.cd-modalidade = propost.cd-modalidade
                      AND sit-aprov-proposta.nr-proposta   = propost.nr-proposta NO-ERROR.
               IF NOT AVAIL sit-aprov-proposta
               THEN DO:                      
                      NEXT.
                    END.
             END.

        if propost.cd-sit-proposta = 1 or /* DIGITACAO */
           propost.cd-sit-proposta = 2 or /* CONFIRMADA */
           propost.cd-sit-proposta = 85   /* SUSPENSA */
        then assign sit-aprov-proposta.in-situacao              = 2 /* EM CADASTRAMENTO */
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.
        
        if propost.cd-sit-proposta = 3 /* PENDENTE ANALISE DE CREDITO */
        then assign sit-aprov-proposta.in-situacao              = 9 /* PENDENTE ANALISE DE CREDITO */
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.                           
        
        if propost.cd-sit-proposta = 4 /* AGUARDANDO LIBERACAO */
        then assign sit-aprov-proposta.in-situacao              = 4 /* PENDENTE DE APROVACAO */
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.    
        
        if propost.cd-sit-proposta = 5 or /* LIBERADA */
           propost.cd-sit-proposta = 6 or /* TAXA INSCRICAO FATURADA  */
           propost.cd-sit-proposta = 7 or /* FATURAMENTO NORMAL */
           propost.cd-sit-proposta = 90   /* EXCLUIDA */
        then assign sit-aprov-proposta.in-situacao              = 5 /* APROVADA */
                    sit-aprov-proposta.nm-aprovador             = propost.cd-userid-libera
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = propost.dt-libera-doc
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.
        
        if propost.cd-sit-proposta = 8 or /* REPROVADA */
           propost.cd-sit-proposta = 95   /* CANCELADA */ 
        then assign sit-aprov-proposta.in-situacao              = 6 /* NEGADA */
                    sit-aprov-proposta.nm-aprovador             = propost.cd-userid-libera
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = propost.dt-libera-doc
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.
        
        /* --- SE NAO ENTROU EM NENHUMA DAS SITUACOES ANTERIORES, SETA COMO "EM CADASTRAMENTO" --- */
        if sit-aprov-proposta.in-situacao   = 0
        then assign sit-aprov-proposta.in-situacao              = 2
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.
    end.
    PAUSE(10).
END.
