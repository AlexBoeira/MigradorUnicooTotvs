DEF VAR id-sequence-aux                                         AS DEC NO-UNDO.
def var h-handle-aux                                            as handle no-undo.
def var h-handle2-aux                                           as handle no-undo.
def NEW shared var id-requisicao-handle-aux                     as char init "" no-undo.
def new global shared var v_cod_usuar_corren                    as char no-undo.
def var h-bosaugenericroutines-aux                              as handle no-undo.
def var h-bosaudemographic-aux                                  as handle no-undo.
def var h-bosaucompany-aux                                      as handle no-undo.
DEF VAR nm-cartao-aux        like contrat.nm-contratante-cartao no-undo.
DEF VAR nm-internacional-aux like contrat.nm-internacional      no-undo.
DEF VAR nm-arq-log-aux       AS CHAR                            NO-UNDO.
DEF VAR lg-erro-aux          AS LOG INIT NO                     NO-UNDO.
DEF BUFFER b-propost FOR propost.
DEF BUFFER b-contrat FOR contrat.
DEF BUFFER b-dzestado FOR dzestado.
DEF BUFFER b-preserv FOR preserv.
DEF BUFFER b-pessoa-fisica FOR pessoa-fisica.
DEF BUFFER b-pessoa-juridica FOR pessoa-juridica.
{rtp/rtrowerror.i}

DEF TEMP-TABLE tmp-pessoa-fisica NO-UNDO
    FIELD id-pessoa AS DEC
    INDEX tmp-pessoa-fisica-id
          id-pessoa.

DEF TEMP-TABLE tmp-pessoa-juridica NO-UNDO
    FIELD id-pessoa AS DEC
    INDEX tmp-pessoa-juridica-id
          id-pessoa.

DISABLE TRIGGERS FOR LOAD OF preserv.
DISABLE TRIGGERS FOR dump OF preserv.
DISABLE TRIGGERS FOR LOAD OF contrat.
DISABLE TRIGGERS FOR DUMP OF contrat.
DISABLE TRIGGERS FOR LOAD OF b-contrat.
DISABLE TRIGGERS FOR DUMP OF b-contrat.
DISABLE TRIGGERS FOR LOAD OF b-preserv.
DISABLE TRIGGERS FOR dump OF b-preserv.
DISABLE TRIGGERS FOR LOAD OF dzestado.
DISABLE TRIGGERS FOR dump OF dzestado.
DISABLE TRIGGERS FOR LOAD OF sit-aprov-proposta.
DISABLE TRIGGERS FOR dump OF sit-aprov-proposta.
DISABLE TRIGGERS FOR LOAD OF b-propost.
DISABLE TRIGGERS FOR dump OF b-propost.
DISABLE TRIGGERS FOR LOAD OF pessoa-fisica.
DISABLE TRIGGERS FOR dump OF pessoa-fisica.
DISABLE TRIGGERS FOR LOAD OF pessoa-juridica.
DISABLE TRIGGERS FOR dump OF pessoa-juridica.

ASSIGN nm-arq-log-aux = SESSION:TEMP-DIR + "te-finaliza-migracao-unicoo.log".

FIND FIRST paramecp NO-LOCK NO-ERROR.
IF NOT AVAIL paramecp
THEN do:
       MESSAGE "Parametros globais do sistema nao cadastrados. (PARAMECP)"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN.
     END.
    
{hdp/hdrunpersis.i "bosau/bosaugenericroutines.p" "h-bosaugenericroutines-aux"}
{hdp/hdrunpersis.i "bosau/bosaudemographic.p"     "h-bosaudemographic-aux"}
{hdp/hdrunpersis.i "bosau/bosaucompany.p"         "h-bosaucompany-aux"}

EMPTY TEMP-TABLE tmp-pessoa-fisica.
EMPTY TEMP-TABLE tmp-pessoa-juridica.

OUTPUT TO VALUE(nm-arq-log-aux) APPEND.
RUN escreve-log("(1)Inicio do processo...").
DO TRANSACTION:
   RUN finaliza-migracao-unicoo.
   IF lg-erro-aux
   THEN UNDO.
END.
RUN escreve-log("(2)Final do processo.").
OUTPUT CLOSE.

{hdp/hddelpersis.i}

IF NOT lg-erro-aux
THEN MESSAGE "Processo concluido com sucesso!"
             VIEW-AS ALERT-BOX INFO BUTTONS OK.
ELSE MESSAGE "O relatorio de inconsistencias foi gerado no caminho:" nm-arq-log-aux SKIP(1)
             "Todas as inconsistencias devem ser resolvidas antes de prosseguir para a proxima etapa." SKIP
             VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Atencao!!!".

PROCEDURE finaliza-migracao-unicoo:

    /**
     * Inicializar pessoa-fisica.nm-cartao e pessoa-fisica.nm-internacional.
     * Relacionar a pessoa na temp-table para ser sincronizada em seguida.
     */
    /*
    FOR EACH b-pessoa-fisica FIELDS(nm-pessoa
                                    nm-cartao
                                    nm-internacional
                                    id-pessoa) NO-LOCK
       WHERE b-pessoa-fisica.nm-internacional = "":

        PROCESS EVENTS.

        IF b-pessoa-fisica.nm-pessoa = ""
        OR b-pessoa-fisica.nm-pessoa = "."
        THEN DO:                 
               RUN escreve-log("(35) a pessoa fisica com id " + string(b-pessoa-fisica.id-pessoa) + " possui nome invalido: '" + 
                               b-pessoa-fisica.nm-pessoa + "'").
               NEXT.
             END.
        
        EMPTY TEMP-TABLE rowErrors.
        run getCardName in h-bosaugenericroutines-aux(input  b-pessoa-fisica.nm-pessoa,
                                                      output nm-cartao-aux,          
                                                      output nm-internacional-aux,   
                                                      input-output table rowErrors).
        FOR EACH rowErrors:
            RUN escreve-log("ERRO (3) erro bosauGenericRoutines.getCardName: " + rowErrors.errorDescription + 
                            " - " + rowErrors.errorParameters + " - " + rowErrors.errorSubType + " (" + string(rowErrors.errorNumber) + ").").
            IF rowErrors.errorSubType = "ERROR"
            THEN ASSIGN lg-erro-aux = YES.
        END.
    
        FOR FIRST pessoa-fisica FIELDS(nm-cartao
                                       nm-internacional
                                       id-pessoa)
            WHERE ROWID(pessoa-fisica) = ROWID(b-pessoa-fisica) EXCLUSIVE-LOCK:

            ASSIGN pessoa-fisica.nm-cartao        = nm-cartao-aux
                   pessoa-fisica.nm-internacional = nm-internacional-aux.

            RUN escreve-log("(4) nm-cartao da pessoa fisica id " + string(pessoa-fisica.id-pessoa) +
                            " atualizado com o valor " + 
                            STRING(pessoa-fisica.nm-cartao) + ".").

            RUN escreve-log("(5) nm-internacional da pessoa fisica id " + string(pessoa-fisica.id-pessoa) +
                            " atualizado com o valor " + 
                            STRING(pessoa-fisica.nm-internacional) + ".").

            IF NOT CAN-FIND(FIRST tmp-pessoa-fisica
                            WHERE tmp-pessoa-fisica.id-pessoa = pessoa-fisica.id-pessoa)
            THEN DO:
                   CREATE tmp-pessoa-fisica.
                   ASSIGN tmp-pessoa-fisica.id-pessoa = pessoa-fisica.id-pessoa.
                 END.
        END.
    END.
    */

    /**
     * Inicializar pessoa-juridica.nm-cartao.
     * Relacionar a pessoa na temp-table para ser sincronizada em seguida.
     */
    /*
    FOR EACH b-pessoa-juridica fields(nm-pessoa
                                      nm-cartao
                                      id-pessoa) no-LOCK:
        PROCESS EVENTS.

        IF b-pessoa-juridica.nm-cartao <> ""
        THEN NEXT.
        
        IF b-pessoa-juridica.nm-pessoa = ""
        OR b-pessoa-juridica.nm-pessoa = "."
        THEN DO:                 
               RUN escreve-log("(36) a pessoa juridica com id " + string(b-pessoa-juridica.id-pessoa) + " possui nome invalido: '" + 
                               b-pessoa-juridica.nm-pessoa + "'").
               NEXT.
             END.

        EMPTY TEMP-TABLE rowErrors.
        run getCardName in h-bosaugenericroutines-aux(input  b-pessoa-juridica.nm-pessoa,
                                                      output nm-cartao-aux,          
                                                      output nm-internacional-aux,   
                                                      input-output table rowErrors).
        FOR EACH rowErrors:
            RUN escreve-log("ERRO (6) erro bosauGenericRoutines.getCardName: " + rowErrors.errorDescription + 
                            " - " + rowErrors.errorParameters + " - " + rowErrors.errorSubType + " (" + string(rowErrors.errorNumber) + ").").
            IF rowErrors.errorSubType = "ERROR"
            THEN ASSIGN lg-erro-aux = YES.
        END.
    
        FOR FIRST pessoa-juridica FIELDS(nm-cartao
                                         id-pessoa) EXCLUSIVE-LOCK
            WHERE ROWID(pessoa-juridica) = ROWID(b-pessoa-juridica):

            ASSIGN pessoa-juridica.nm-cartao = nm-cartao-aux.
    
            RUN escreve-log("(7) nm-cartao da pessoa juridica id " + string(pessoa-juridica.id-pessoa) +
                            " atualizado com o valor " + 
                            STRING(pessoa-juridica.nm-cartao) + ".").
            IF NOT CAN-FIND(FIRST tmp-pessoa-juridica
                            WHERE tmp-pessoa-juridica.id-pessoa = pessoa-juridica.id-pessoa)
            THEN DO:
                   CREATE tmp-pessoa-juridica.
                   ASSIGN tmp-pessoa-juridica.id-pessoa = pessoa-juridica.id-pessoa.
                 END.

        END.
    END.
    */

    /**
     * Inicializar ID-PESSOA nas entidades Contratante e Prestador.
     */
    
    /**
     * Contratante - no gerador de .txt o Unicoo enviou o ID-PESSOA no campo contrat.vl-moradia-propria
     *               e o codigo do contratante no campo contrat.vl-terreno
     */
    /*
    for each contrat FIELDS(in-tipo-pessoa
                            vl-moradia-propria
                            nr-insc-contratante) NO-LOCK 
       WHERE contrat.id-pessoa = 0:
             PROCESS EVENTS.

             /**
              * Consistir se o ID recebido em VL-MORADIA-PROPRIA eh valido.
              */
             IF contrat.in-tipo-pessoa = "F"
             THEN do:
                    IF NOT CAN-FIND(FIRST pessoa-fisica
                                    WHERE pessoa-fisica.id-pessoa = contrat.vl-moradia-propria)
                    THEN DO:
                           RUN escreve-log("ERRO (25) nao existe pessoa fisica com o id " + STRING(contrat.vl-moradia-propria) + ".").
                           ASSIGN lg-erro-aux = YES.
                           NEXT.
                         END.
                  END.
             else do:
                    IF NOT CAN-FIND(FIRST pessoa-juridica
                                    WHERE pessoa-juridica.id-pessoa = contrat.vl-moradia-propria)
                    THEN DO:
                           RUN escreve-log("ERRO (26) nao existe pessoa juridica com o id " + STRING(contrat.vl-moradia-propria) + ".").
                           ASSIGN lg-erro-aux = YES.
                           NEXT.
                         END.
                  END.

             /**
              * Consistir se o ID recebido em VL-MORADIA-PROPRIA ja esta em uso por outro contratante.
              */
             IF CAN-FIND(FIRST b-contrat
                         WHERE b-contrat.id-pessoa = contrat.vl-moradia-propria)
             THEN DO:
                    FOR FIRST b-contrat FIELDS(nr-insc-contratante) NO-LOCK
                        WHERE b-contrat.id-pessoa = contrat.vl-moradia-propria:
                              RUN escreve-log("ERRO (27) id-pessoa " + STRING(contrat.vl-moradia-propria) + " ja esta associado ao contratante inscricao " + 
                                              string(b-contrat.nr-insc-contratante) + ". A mesma pessoa nao podera ser associada ao contratante inscricao " + 
                                              STRING(contrat.nr-insc-contratante)).
                              ASSIGN lg-erro-aux = YES.
                    END.
                    NEXT.
                  END.

             FOR FIRST b-contrat fields(id-pessoa
                                        vl-moradia-propria
                                        cd-contratante
                                        vl-terreno
                                        cd-vendedor
                                        nr-insc-contratante
                                        in-tipo-pessoa) EXCLUSIVE-LOCK
                 WHERE rowid(b-contrat) = ROWID(contrat):

                       ASSIGN b-contrat.id-pessoa          = contrat.vl-moradia-propria
                              b-contrat.vl-moradia-propria = 0
                              b-contrat.cd-contratante     = contrat.vl-terreno
                              b-contrat.vl-terreno         = 0.

                       IF b-contrat.in-tipo-pessoa = "F"
                       THEN DO:
                              IF b-contrat.id-pessoa <> 0
                              AND NOT CAN-FIND(FIRST tmp-pessoa-fisica
                                               WHERE tmp-pessoa-fisica.id-pessoa = b-contrat.id-pessoa)
                              THEN DO:
                                     CREATE tmp-pessoa-fisica.
                                     ASSIGN tmp-pessoa-fisica.id-pessoa = b-contrat.id-pessoa.
                                   END.
                            END.
                       ELSE DO:
                              IF b-contrat.id-pessoa <> 0
                              AND NOT CAN-FIND(FIRST tmp-pessoa-juridica
                                               WHERE tmp-pessoa-juridica.id-pessoa = b-contrat.id-pessoa)
                              THEN DO:
                                     CREATE tmp-pessoa-juridica.
                                     ASSIGN tmp-pessoa-juridica.id-pessoa = b-contrat.id-pessoa.
                                   END.
                            END.

                       RUN escreve-log("(8) id-pessoa do Contratante inscricao " + STRING(b-contrat.nr-insc-contratante) + " preenchido com " + STRING(b-contrat.id-pessoa) + ".").
                       RUN escreve-log("(9) cd-contratante do Contratante inscricao " + STRING(b-contrat.nr-insc-contratante) + " preenchido com " + STRING(b-contrat.cd-contratante) + ".").
                       
                       IF b-contrat.cd-vendedor = 0
                       OR NOT can-find(FIRST representante
                                       where representante.cod_empresa = paramecp.ep-codigo
                                         and representante.cdn_repres  = b-contrat.cd-vendedor)
                       THEN DO:
                              ASSIGN b-contrat.cd-vendedor = 1.
                              FOR FIRST propost FIELDS(cd-vendedor) NO-LOCK 
                                  WHERE propost.nr-insc-contratante   = b-contrat.nr-insc-contratante:
                                        ASSIGN b-contrat.cd-vendedor  = propost.cd-vendedor.
                                        RUN escreve-log("(10) cd-vendedor do Contratante inscricao " + STRING(b-contrat.nr-insc-contratante) + " preenchido com " + 
                                            STRING(b-contrat.cd-vendedor) + ".").
                              END.
                            END.
             END.
    end.
    */

    /**
     * Prestador - no gerador de .txt o Unicoo enviou o ID-PESSOA no campo preserv.qt-produtividade.
     */
    for each preserv FIELDS (in-tipo-pessoa
                             qt-produtividade
                             cd-unidade
                             cd-prestador) NO-LOCK
       WHERE preserv.id-pessoa = 0:
             PROCESS EVENTS.

             /**
              * Consistir se o ID recebido em qt-produtividade eh valido.
              */
             IF preserv.in-tipo-pessoa = "F"
             THEN do:
                    IF NOT CAN-FIND(FIRST pessoa-fisica
                                    WHERE pessoa-fisica.id-pessoa = preserv.qt-produtividade)
                    THEN DO:
                           RUN escreve-log("ERRO (28) nao existe pessoa fisica com o id " + STRING(preserv.qt-produtividade) + ".").
                           ASSIGN lg-erro-aux = YES.
                           NEXT.
                         END.
                  END.
             else do:
                    IF NOT CAN-FIND(FIRST pessoa-juridica
                                    WHERE pessoa-juridica.id-pessoa = preserv.qt-produtividade)
                    THEN DO:
                           RUN escreve-log("ERRO (29) nao existe pessoa juridica com o id " + STRING(preserv.qt-produtividade) + ".").
                           ASSIGN lg-erro-aux = YES.
                           NEXT.
                         END.
                  END.

             /**
              * Consistir se o ID recebido em qt-produtividade ja esta em uso por outro preserv.
              */
             IF CAN-FIND(FIRST b-preserv
                         WHERE b-preserv.id-pessoa = preserv.qt-produtividade)
             THEN DO:
                    FOR FIRST b-preserv FIELDS(cd-unidade
                                               cd-prestador) NO-LOCK
                        WHERE b-preserv.id-pessoa = preserv.qt-produtividade:
                              RUN escreve-log("ERRO (30) id-pessoa " + STRING(preserv.qt-produtividade) + " ja esta associado ao prestador unidade " + 
                                              string(b-preserv.cd-unidade) + " e codigo " + STRING(b-preserv.cd-prestador) + 
                                              ". A mesma pessoa nao podera ser associada ao prestador unidade " + STRING(preserv.cd-unidade) + ", prestador " + 
                                              STRING(preserv.cd-prestador)).
                              ASSIGN lg-erro-aux = YES.
                    END.
                    NEXT.
                  END.

             FOR FIRST b-preserv FIELDS(id-pessoa
                                        qt-produtividade
                                        cd-unidade
                                        cd-prestador
                                        in-tipo-pessoa) EXCLUSIVE-LOCK
                 WHERE rowid(b-preserv) = ROWID(preserv):
             
                 ASSIGN b-preserv.id-pessoa        = int(b-preserv.qt-produtividade)
                        b-preserv.qt-produtividade = 0.

                 IF b-preserv.in-tipo-pessoa = "F"
                 THEN DO:
                        IF b-preserv.id-pessoa <> 0
                        AND NOT CAN-FIND(FIRST tmp-pessoa-fisica
                                         WHERE tmp-pessoa-fisica.id-pessoa = b-preserv.id-pessoa)
                        THEN DO:
                               CREATE tmp-pessoa-fisica.
                               ASSIGN tmp-pessoa-fisica.id-pessoa = b-preserv.id-pessoa.
                             END.
                      END.
                 ELSE DO:
                        IF b-preserv.id-pessoa <> 0
                        AND NOT CAN-FIND(FIRST tmp-pessoa-juridica
                                         WHERE tmp-pessoa-juridica.id-pessoa = b-preserv.id-pessoa)
                        THEN DO:
                               CREATE tmp-pessoa-juridica.
                               ASSIGN tmp-pessoa-juridica.id-pessoa = b-preserv.id-pessoa.
                             END.
                      END.
                 
                 RUN escreve-log("(11) id-pessoa do Prestador unidade " + STRING(b-preserv.cd-unidade) + " e codigo " + STRING(b-preserv.cd-prestador) + 
                                 " preenchido com " + STRING(b-preserv.id-pessoa) + ".").
             END.
    end.

    /**
     * Relacionar beneficiarios ainda nao sincronizados. O criterio eh o campo USUARIO.NM-INTERNACIONAL em brancos.
     */
    /*
    FOR EACH usuario FIELDS(id-pessoa
                            cd-modalidade
                            nr-proposta
                            cd-usuario
                            nm-usuario) NO-LOCK
       WHERE usuario.nm-internacional = "":
        PROCESS EVENTS.

        RUN escreve-log("(12) relacionando beneficiario com nome '" + usuario.nm-usuario + "', modalidade " + string(usuario.cd-modalidade) +
                        ", proposta " + STRING(usuario.nr-proposta) + " e codigo " + STRING(usuario.cd-usuario) +
                        " para ser sincronizado com a pessoa id " + STRING(usuario.id-pessoa) + ".").

        IF usuario.id-pessoa <> 0
        AND NOT CAN-FIND(FIRST tmp-pessoa-fisica
                         WHERE tmp-pessoa-fisica.id-pessoa = usuario.id-pessoa)
        THEN DO:
               CREATE tmp-pessoa-fisica.
               ASSIGN tmp-pessoa-fisica.id-pessoa = usuario.id-pessoa.
             END.
    END.
    */

    /**
     * Sincronizar PESSOA-FISICA e PESSOA-JURIDICA com as entidades relacionadas nesse processo.
     */
    FOR EACH tmp-pessoa-fisica:
        PROCESS EVENTS.
        RUN escreve-log("(13) sincronizando relacionamentos da pessoa fisica id " + string(tmp-pessoa-fisica.id-pessoa) + ".").

        EMPTY TEMP-TABLE rowErrors.
        run synchronizeDemographic in h-bosaudemographic-aux(input tmp-pessoa-fisica.id-pessoa,
                                                             input-output table rowErrors).
        FOR EACH rowErrors:
            RUN escreve-log("ERRO (14) erro bosauDemographic.synchronizeDemographic: " + rowErrors.errorDescription + 
                            " - " + rowErrors.errorParameters + " - " + rowErrors.errorSubType + " (" + string(rowErrors.errorNumber) + ").").
            IF rowErrors.errorSubType = "ERROR"
            THEN ASSIGN lg-erro-aux = YES.
        END.
    END.

    FOR EACH tmp-pessoa-juridica:
        PROCESS EVENTS.
        RUN escreve-log("(15) sincronizando relacionamentos da pessoa juridica id " + string(tmp-pessoa-juridica.id-pessoa) + ".").

        EMPTY TEMP-TABLE rowErrors.
        run synchronizeCompany in h-bosaucompany-aux(input tmp-pessoa-juridica.id-pessoa,
                                                          input-output table rowErrors).
        FOR EACH rowErrors:
            RUN escreve-log("ERRO (16) erro bosauCompany.synchronizeCompany: " + rowErrors.errorDescription + 
                            " - " + rowErrors.errorParameters + " - " + rowErrors.errorSubType + " (" + string(rowErrors.errorNumber) + ").").
            IF rowErrors.errorSubType = "ERROR"
            THEN ASSIGN lg-erro-aux = YES.
        END.
    END.

    /**
     * Contratante - caso o mesmo CPF/CNPJ ja exista integrado ao EMS, ajustar CD-CONTRATANTE e NOME-ABREV conforme
     * CLIENTE do EMS.
     */
    FOR EACH contrat fields(nr-insc-contratante
                            nr-cgc-cpf) NO-LOCK
       WHERE contrat.cd-contratante = 0,
       FIRST cliente FIELDS(cdn_cliente
                            nom_abrev
                            cod_id_feder) NO-LOCK
       WHERE cliente.cod_id_feder = contrat.nr-cgc-cpf:
             PROCESS EVENTS.

             /**
              * Validar se CD-CONTRATANTE ja esta em uso por outro contratante.
              */
             IF CAN-FIND(FIRST b-contrat
                         WHERE b-contrat.cd-contratante = cliente.cdn_cliente)
             THEN DO:
                    FOR EACH b-contrat FIELDS(nr-insc-contratante) NO-LOCK
                       WHERE b-contrat.cd-contratante = cliente.cdn_cliente:
                              RUN escreve-log("ERRO (31) cd-contratante " + STRING(cliente.cdn_cliente) + " ja esta associado ao contratante inscricao " + 
                                              string(b-contrat.nr-insc-contratante) + ". O mesmo codigo nao podera ser associado ao contratante inscricao " + 
                                              STRING(contrat.nr-insc-contratante)).
                              ASSIGN lg-erro-aux = YES.
                    END.
                    NEXT.
                  END.

             /**
              * Validar se NOME-ABREV ja esta em uso por outro contratante.
              */
             IF CAN-FIND(FIRST b-contrat
                         WHERE b-contrat.nome-abrev  = cliente.nom_abrev
                           AND b-contrat.nr-cgc-cpf <> contrat.nr-cgc-cpf)
             THEN DO:
                    FOR EACH b-contrat FIELDS(nome-abrev) EXCLUSIVE-LOCK
                       WHERE b-contrat.nome-abrev = cliente.nom_abrev
                         AND b-contrat.nr-cgc-cpf <> contrat.nr-cgc-cpf:

                             RUN gera-nome-abrev-unico(INPUT-OUTPUT b-contrat.nome-abrev).
                    END.
                  END.

             IF CAN-FIND(FIRST b-contrat
                         WHERE b-contrat.nome-abrev  = cliente.nom_abrev
                           AND ROWID(b-contrat)     <> rowid(contrat))
             THEN DO:
                    FOR EACH b-contrat FIELDS(nr-insc-contratante
                                              nr-cgc-cpf) NO-LOCK
                       WHERE b-contrat.nome-abrev = cliente.nom_abrev
                         AND ROWID(b-contrat)    <> ROWID(contrat):
                              RUN escreve-log("ERRO (32) nome-abrev " + STRING(cliente.nom_abrev) + " do cliente cpf/cnpj " + STRING(cliente.cod_id_feder) +
                                              " ja esta associado ao contratante inscricao " + 
                                              string(b-contrat.nr-insc-contratante) + ", cpf/cnpj " + STRING(b-contrat.nr-cgc-cpf) +
                                              ". O mesmo nome-abrev nao podera ser associado ao contratante inscricao " + 
                                              STRING(contrat.nr-insc-contratante) + " e cpf/cnpj " + STRING(contrat.nr-cgc-cpf)).
                              ASSIGN lg-erro-aux = YES.
                    END.
                    NEXT.
                  END.

             FOR FIRST b-contrat fields(cd-contratante
                                        nome-abrev
                                        nr-insc-contratante
                                        nr-cgc-cpf) EXCLUSIVE-LOCK
                 WHERE rowid(b-contrat) = ROWID(contrat):
    
                 ASSIGN b-contrat.cd-contratante = cliente.cdn_cliente
                        b-contrat.nome-abrev     = cliente.nom_abrev.

                 RUN escreve-log("(17) cd-contratante do Contratante inscricao " + STRING(b-contrat.nr-insc-contratante) + " e CPF/CNPJ " + STRING(b-contrat.nr-cgc-cpf) + 
                                 " preenchido com " + STRING(b-contrat.cd-contratante) + ".").
                 RUN escreve-log("(18) nome-abrev do Contratante inscricao " + STRING(b-contrat.nr-insc-contratante) + " e CPF/CNPJ " + STRING(b-contrat.nr-cgc-cpf) + 
                                 " preenchido com " + STRING(b-contrat.nome-abrev) + ".").
             END.
    END.

    /**
     * Prestador - caso o mesmo CPF/CNPJ ja exista integrado ao EMS, ajustar CD-CONTRATANTE e NOME-ABREV conforme
     * FORNECEDOR do EMS.
     */
    FOR EACH preserv fields(cd-unidade
                            cd-prestador) NO-LOCK
       WHERE preserv.cd-contratante = 0,
       FIRST fornecedor FIELDS (cdn_fornecedor
                                nom_abrev) NO-LOCK
       WHERE fornecedor.cod_id_feder = preserv.nr-cgc-cpf:
             PROCESS EVENTS.

             /**
              * Validar se CD-CONTRATANTE ja esta em uso por outro prestador.
              */
             IF CAN-FIND(FIRST b-preserv
                         WHERE b-preserv.cd-contratante = fornecedor.cdn_fornecedor)
             THEN DO:
                    FOR EACH b-preserv FIELDS(cd-unidade
                                              cd-prestador) NO-LOCK
                       WHERE b-preserv.cd-contratante = fornecedor.cdn_fornecedor:
                              RUN escreve-log("ERRO (33) cd-contratante " + STRING(fornecedor.cdn_fornecedor) + " ja esta associado ao prestador unidade " + 
                                              STRING(b-preserv.cd-unidade) + ", prestador " + STRING(b-preserv.cd-prestador) +
                                              ". O mesmo codigo nao podera ser associado ao prestador unidade " + STRING(preserv.cd-unidade) +
                                              ", prestador " + STRING(preserv.cd-prestador)).
                              ASSIGN lg-erro-aux = YES.
                    END.
                    NEXT.
                  END.

             /**
              * Validar se NOME-ABREV ja esta em uso por outro prestador.
              */
             IF CAN-FIND(FIRST b-preserv
                         WHERE b-preserv.nome-abrev           = fornecedor.nom_abrev
                           AND rowid(b-preserv)              <> rowid(preserv))
             THEN DO:
                    FOR EACH b-preserv FIELDS(cd-unidade
                                              cd-prestador) NO-LOCK
                       WHERE b-preserv.nome-abrev = fornecedor.nom_abrev
                         AND ROWID(b-preserv)    <> ROWID(preserv):
                              RUN escreve-log("ERRO (34) nome-abrev " + STRING(fornecedor.nom_abrev) + " ja esta associado ao prestador unidade " + 
                                              STRING(b-preserv.cd-unidade) + ", prestador " + STRING(b-preserv.cd-prestador) +
                                              ". O mesmo nome-abrev nao podera ser associado ao prestador unidade " + STRING(preserv.cd-unidade) +
                                              ", prestador " + STRING(preserv.cd-prestador)).
                              ASSIGN lg-erro-aux = YES.
                    END.
                    NEXT.
                  END.

             FOR FIRST b-preserv fields(cd-contratante
                                        nome-abrev
                                        nr-cgc-cpf
                                        cd-unidade
                                        cd-prestador) EXCLUSIVE-LOCK
                 WHERE rowid(b-preserv) = ROWID(preserv):
    
                 ASSIGN b-preserv.cd-contratante = fornecedor.cdn_fornecedor
                        b-preserv.nome-abrev     = fornecedor.nom_abrev.

                 RUN escreve-log("(19) cd-contratante do Prestador unidade " + STRING(b-preserv.cd-unidade) + ", codigo " + string(b-preserv.cd-prestador) +
                                 " e CPF/CNPJ " + STRING(b-preserv.nr-cgc-cpf) + " preenchido com " + STRING(b-preserv.cd-contratante) + ".").

                 RUN escreve-log("(20) nome-abrev do Prestador unidade " + STRING(b-preserv.cd-unidade) + ", codigo " + string(b-preserv.cd-prestador) +
                                 " e CPF/CNPJ " + STRING(b-preserv.nr-cgc-cpf) + " preenchido com " + STRING(b-preserv.nome-abrev) + ".").
             END.
    END.

    /**
     * Garantir que exista o registro com UF em brancos para cada pais cadastrado.
     */
    FOR EACH b-dzestado fields(nm-pais
                               cd-pais-ans) NO-LOCK
       WHERE NOT CAN-FIND (FIRST dzestado
                           WHERE dzestado.nm-pais = b-dzestado.nm-pais
                             AND dzestado.en-uf   = ""):
        PROCESS EVENTS.

        CREATE dzestado.
        ASSIGN dzestado.nm-pais         = b-dzestado.nm-pais
               dzestado.en-uf           = ""
               dzestado.nm-estado       = ""
               dzestado.cd-userid       = "MIGRACAO"
               dzestado.dt-atualizacao  = TODAY
               dzestado.cd-pais-ans     = b-dzestado.cd-pais-ans
               dzestado.cdn-estado-tiss = 0.
    END.

    /**
     * Inicializar a tabela SIT-APROV-PROPOSTA.
     * Usar essa mesma leitura para ajustar PROPOST.CD-CONTRATANTE
     */
    RUN escreve-log("(21) Inicio da leitura da propost para atualizacao da sit-aprov-proposta...").
    
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
                      RUN escreve-log("ERRO (41) nao foi possivel acessar sit-aprov-proposta Modalidade:" + STRING(propost.cd-modalidade) + ", Proposta: " + 
                                      STRING(propost.nr-proposta) + " para atualizacao").
                      ASSIGN lg-erro-aux = YES.
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
    
        IF CAN-FIND(FIRST contrat
                    WHERE contrat.nr-insc-contratante = propost.nr-insc-contratante
                      AND contrat.cd-contratante     <> propost.cd-contratante)
        THEN DO:
               FOR FIRST b-propost fields(cd-contratante) EXCLUSIVE-LOCK
                   WHERE rowid(b-propost) = ROWID(propost),
                   FIRST contrat fields(cd-contratante) NO-LOCK
                   WHERE contrat.nr-insc-contratante = propost.nr-insc-contratante:
    
                         ASSIGN b-propost.cd-contratante = contrat.cd-contratante.

                         RUN escreve-log("(22) cd-contratante da proposta modalidade " + string(propost.cd-modalidade) +
                                         " proposta " + STRING(propost.nr-proposta) + " setado com o valor " + 
                                         STRING(b-propost.cd-contratante) + ".").
               END.
             END.
    
        IF propost.nr-insc-contrat-origem <> 0
        THEN DO:
               IF CAN-FIND(FIRST contrat
                           WHERE contrat.nr-insc-contratante = propost.nr-insc-contrat-origem
                             AND contrat.cd-contratante     <> propost.cd-contrat-origem)
               THEN DO:
                      FOR FIRST b-propost fields(cd-contrat-origem) EXCLUSIVE-LOCK
                          WHERE rowid(b-propost) = ROWID(propost),
                          FIRST contrat fields(cd-contratante) NO-LOCK
                          WHERE contrat.nr-insc-contratante = propost.nr-insc-contrat-origem:
               
                                ASSIGN b-propost.cd-contrat-origem = contrat.cd-contratante.

                                RUN escreve-log("(23) cd-contrat-origem da proposta modalidade " + string(propost.cd-modalidade) +
                                                " proposta " + STRING(propost.nr-proposta) + " setado com o valor " + 
                                                STRING(b-propost.cd-contrat-origem) + ".").
                      END.
                    END.
             END.
    end.

    RUN escreve-log("(24) Fim da leitura da propost.").
    
    /**
     * Checar se existem novas PESSOA-FISICA/JURIDICA para inicializar a sequence SEQ-PESSOA
     */
    RUN escreve-log("(37) inicializando SEQ-PESSOA...").

    ASSIGN id-sequence-aux = 1.
    FOR LAST pessoa-fisica fields(id-pessoa) USE-INDEX pfis1 NO-LOCK:
        ASSIGN id-sequence-aux = pessoa-fisica.id-pessoa.
    END.

    FOR LAST pessoa-juridica fields(id-pessoa) USE-INDEX pessoa-juridica1 NO-LOCK:
        IF pessoa-juridica.id-pessoa > id-sequence-aux
        THEN ASSIGN id-sequence-aux = pessoa-juridica.id-pessoa.
    END.
    
    RUN escreve-log("(38) id-pessoa a ser inicializado: " + STRING(id-sequence-aux) + ". ").
    
    REPEAT:
      IF NEXT-VALUE(seq-pessoa) >= id-sequence-aux
      THEN LEAVE.
    END.

    /**
     * Inicializar a sequence SEQ-CONTATO-PESSOA
     */
    RUN escreve-log("(39) inicializando SEQ-CONTATO-PESSOA...").

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-contato-pessoa).
    FOR LAST contato-pessoa fields(id-contato)
       WHERE contato-pessoa.id-contato > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-contato-pessoa) >= contato-pessoa.id-contato
               THEN LEAVE.
             END.
    END.
    
    /**
     * Inicializar a sequence SEQ-ENDERECO
     */
    RUN escreve-log("(40) inicializando SEQ-ENDERECO...").

    ASSIGN id-sequence-aux = NEXT-VALUE(seq-endereco).
    FOR LAST shsrcadger.endereco FIELDS(id-endereco)
       WHERE endereco.id-endereco > id-sequence-aux NO-LOCK:
             REPEAT:
               IF NEXT-VALUE(seq-endereco) >= endereco.id-endereco
               THEN LEAVE.
             END.
    END.

END PROCEDURE.

PROCEDURE gera-nome-abrev-unico:
    DEF INPUT-OUTPUT PARAM nome-abrev-par AS CHAR NO-UNDO.

    DEF VAR nome-abreviado-original AS CHAR NO-UNDO.
    DEF VAR nome-abreviado-final    AS CHAR NO-UNDO.
    DEF VAR ix                      AS INT  NO-UNDO.
    
    ASSIGN nome-abreviado-original = nome-abrev-par
           nome-abreviado-final    = trim(substring(nome-abrev-par, 1, 12))
           ix                      = 0.

    repeat: 
            IF  NOT CAN-FIND (FIRST cliente 
                              where cliente.cod_empresa = paramecp.ep-codigo
                                AND cliente.nom_abrev   = nome-abreviado-final)
            AND NOT CAN-FIND (FIRST contrat
                              WHERE contrat.nome-abrev           = nome-abreviado-final)
            THEN LEAVE.

            if length(nome-abreviado-final) + length(string(ix)) <= 12
            then assign nome-abreviado-final = nome-abreviado-final + string(ix).
            else assign nome-abreviado-final = substr(nome-abreviado-final,1,12 - length(string(ix))) + string(ix). 

            assign ix = ix + 1.
    end.

    ASSIGN nome-abrev-par = nome-abreviado-final.
    
END PROCEDURE.

PROCEDURE escreve-log:
    DEF INPUT PARAMETER ds-mensagem-par AS CHAR NO-UNDO.

    PUT UNFORMATTED string(NOW) + " - " ds-mensagem-par SKIP.

END PROCEDURE.
