/*
programa de conferencia do Mauricio Faoro. O fonte foi guardado para referencias futuras.

/* Alias parte PROGRESS EMS5 */
CREATE ALIAS shemsbas FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsedi FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsfin FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsuni FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsven FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsinc FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shmovfin FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemscad FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsmov FOR DATABASE shems5 NO-ERROR.


/* Alias parte Oracle EMS5 */
CREATE ALIAS emsbas FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsedi FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsfin FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsuni FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsven FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsinc FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS movfin FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emscad FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsmov FOR DATABASE ems5 NO-ERROR.

/* Alias dos Schema Holders GP*/
CREATE ALIAS srmovben FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srmovcon FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srmovfi1 FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srweb    FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srmovfin FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srcadger FOR DATABASE shgp NO-ERROR.

CREATE ALIAS shsrmovben    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrmovcon    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrmovfi1    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrweb       FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrmovfin    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrcadger    FOR DATABASE gp NO-ERROR.


DEF VAR cdstatus AS CHAR NO-UNDO. 

UPDATE cdstatus. 


def temp-table tmp-api-mens-pre-pagamento  no-undo
        field lg-geracao                  as log 
        field ep-codigo                   as char
        field cd-modalidade               as int
        field nr-ter-adesao               as int
        field dt-emissao                  as date
        field dt-vencimento               as date
        field lg-desconsidera-imposto     as log
        field qt-usuarios                 as int 
        field rowid-notaserv              as rowid
        field lg-verif-fat-complementar   as log
        field lg-periodico                as log
        field lg-cria-temps               as log
        field cd-especie                  as char
        field aa-referencia               as int 
        field mm-referencia               as int 
        field lg-calc-apos-fim-termo      as log.

def temp-table tmp-notaserv-tot no-undo
        field rw-notaserv    as rowid
        field qt-usuario     as int
        field in-tipo-depend as int. 

def var h-faturamento-aux as handle no-undo. 

/*
Copyright (c) 2007, DATASUL S/A. Todos os direitos reservados.

Os Programas desta Aplica‡Æo (que incluem tanto o software quanto a sua
documenta‡Æo) cont‚m informa‡äes propriet rias da DATASUL S/A; eles sÆo
licenciados de acordo com um contrato de licen‡a contendo restri‡äes de uso e
confidencialidade, e sÆo tamb‚m protegidos pela Lei 9609/98 e 9610/98,
respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
reversa, descompila‡Æo e desmontagem dos programas sÆo proibidos. Nenhuma
parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
por nenhum meio, eletr“nico ou mecƒnico, por motivo algum, sem a permissÆo
escrita da DATASUL S/A.
*/

/******************************************************************************
    Programa .....: rtrowerror.i
    Data .........: 31/05/2010
    Sistema ......:
    Empresa ......: DATASUL Saude
    Cliente ......:
    Programador ..: Alex Boeira
    Objetivo .....: Declaracao da temp-table rowErrors e de todos os metodos
                    para sua manipulacao atraves das BOs do produto.
                    Essa temp-table trafega entre a camada de negocio (Progress)
                    e camada de apresentacao (Flex/Java) atraves do Appserver.
******************************************************************************/

define temp-table rowErrors no-undo
        field errorSequence    as integer              /* --- GERA INTERNAMENTE --- */
        field errorNumber      as integer              /* --- NUMERO DA MENSAGEM DE ERRO, CASO NAO VENHA DA MENSISTE --- */
        field errorDescription as char format "x(500)" /* --- SE PREENCHER, CONSIDERA. SENAO BUSCA --- */
        field errorParameters  as char format "x(500)" /* --- LIVRE. CHAVE DO REGISTRO, ETC... --- */
        field errorType        as char format "x(10)"  /* --- PROGRESS / GP / OUTROS --- */
        field errorHelp        as char format "x(500)" /* --- SE PREENCHER, CONSIDERA. SENAO MENSISTE.DS-MENSAGEM-DETALHADA --- */
        field errorSubType     aS char format "x(12)" /* --- ERROR, WARNING ou INFORMATION --- */
        
        index rowErrors1
          errorSubType

        index rowErrors2
          errorNumber.

/**
 * Verifica se na rowErrors existe uma mensagem qualquer do tipo "ERROR".
 * Returna true se existir e false caso contrÿrio.
 */
function containsAnyError returns logical private (input table rowErrors).

    if can-find(first rowErrors where rowErrors.errorSubType = "ERROR" use-index rowErrors1) 
    then return yes.
    else return no.

end function.

/**
 * Verifica se existe um erro na rowErros com o c½digo informado.
 */
function containsError returns logical private (input table rowErrors,
                                                input pErrorNumber as int).

    if can-find(first rowErrors where rowErrors.errorNumber = pErrorNumber) 
    then return yes.
    else return no.

end function.

/**
 * Remove o error passado por par³metro da rowErros.
 * Retorna true se um erro foi removido e false caso contrÿrio.
 */
function removeError returns logical private (input-output table rowErrors,
                                              input pErrorNumber as int). 

    find first rowErrors where rowErrors.errorNumber = pErrorNumber.

    if avail rowErrors
    then do:
           delete rowErrors.       
           return yes.
         end.
    else 
         do:
           return no.
         end.

end function.

procedure insertErrorProgress private:
    def input parameter pErrorParameters  as character no-undo.
    def input parameter pErrorHelp        as character no-undo.

    def input-output parameter table for rowErrors.

    def var iErrorSequence           as integer   no-undo.
    def var iErrors                  as integer   no-undo.

    if index (pErrorHelp, "/n", 1) <> 0 
    then do:
            assign pErrorHelp = replace (pErrorHelp, "/n", "\n").   
         end.

    if index(pErrorHelp, "/r", 1) <> 0
    then do:
            assign pErrorHelp = replace (pErrorHelp, "/r", "\r").
         end.

    if index(pErrorHelp, "/t", 1) <> 0
    then do:
            assign pErrorHelp = replace (pErrorHelp, "/t", "\t").
         end.

    do iErrors = 1 to error-status:num-messages:
        if can-find(last rowErrors) 
        then do:
               find last rowErrors.
               assign iErrorSequence = rowErrors.errorSequence + 1.
             end.
        else assign iErrorSequence = iErrorSequence + 1.
                
        create rowErrors.
        assign rowErrors.errorSequence    = iErrorSequence
               rowErrors.errorNumber      = ERROR-STATUS:GET-NUMBER(iErrors)
               rowErrors.errorType        = "PROGRESS"
               rowErrors.errorSubType     = "ERROR"
               rowErrors.errorDescription = ERROR-STATUS:GET-MESSAGE(iErrors)
               rowErrors.errorHelp        = pErrorHelp
               rowErrors.errorParameters  = pErrorParameters.

        /**
         * Tratamento para nunca permitir que errorNumber fique com o valor zero, pois o Framework
         * provoca erro e perda de conexao com o appserver.
         */
        if rowErrors.errorNumber = 0
        then assign rowErrors.errorNumber = 1.
    end.
        
end procedure.

procedure insertErrorGP private:
    def input parameter pErrorNumber      as integer   no-undo.
    def input parameter pErrorParameters  as character no-undo.
    def input parameter pErrorHelp        as character no-undo.

    def input-output parameter table for rowErrors.

    def var iErrorSequence           as integer   no-undo.
    def var iErrors                  as integer   no-undo.
    def var errorDescription         as character no-undo.
    def var errorHelp                as character no-undo.
    def var errorSubType             as character no-undo.

    if index (pErrorHelp, "/n", 1) <> 0 
    then do:
            assign pErrorHelp = replace (pErrorHelp, "/n", "\n").   
         end.

    if index(pErrorHelp, "/r", 1) <> 0
    then do:
            assign pErrorHelp = replace (pErrorHelp, "/r", "\r").
         end.

    if index(pErrorHelp, "/t", 1) <> 0
    then do:
            assign pErrorHelp = replace (pErrorHelp, "/t", "\t").
         end.

    if pErrorNumber > 0
    then do:
           find mensiste
                where mensiste.cd-mensagem = pErrorNumber
                      no-lock no-error.
           if   avail mensiste
           then do:
                  assign errorDescription = mensiste.ds-mensagem-sistema
                         errorHelp        = mensiste.ds-mensagem-detalhada
                         errorSubType     = mensiste.in-tipo-mensagem.
                end.
           else do:
                  assign errorDescription   = "Mensagem nao cadastrada."
                         errorSubType       = "E".
                end.
         end.
    else assign errorDescription   = ""
                errorSubType       = "E".

    if can-find(last rowErrors) 
    then do:
           find last rowErrors.
           assign iErrorSequence = rowErrors.ErrorSequence + 1.
         end.
    else assign iErrorSequence = iErrorSequence + 1.
    
    create rowErrors.
    assign rowErrors.errorSequence    = iErrorSequence
           rowErrors.errorNumber      = pErrorNumber
           rowErrors.errorType        = "GP"
           rowErrors.errorSubType     = "ERROR"
           rowErrors.errorDescription = errorDescription
           rowErrors.errorParameters  = pErrorParameters.

    /**
     * Tratamento para nunca permitir que errorNumber fique com o valor zero, pois o Framework
     * provoca erro e perdade conexao com o appserver.
     */
    if rowErrors.errorNumber = 0
    then assign rowErrors.errorNumber = 1.

    if trim(pErrorHelp) <> "" 
    then assign rowErrors.errorHelp = pErrorHelp.
    else assign rowErrors.errorHelp = ErrorHelp.

    if rowErrors.errorHelp <> ""
    then rowErrors.errorHelp = rowErrors.errorHelp + chr(10).

    rowErrors.errorHelp = rowErrors.errorHelp + rowErrors.errorParameters.

end procedure.

procedure insertWarningGP private:
    def input parameter pErrorNumber      as integer   no-undo.
    def input parameter pErrorParameters  as character no-undo.
    def input parameter pErrorHelp        as character no-undo.

    def input-output parameter table for rowErrors.

    def var iErrorSequence           as integer   no-undo.
    def var iErrors                  as integer   no-undo.
    def var errorDescription         as character no-undo.
    def var errorHelp                as character no-undo.
    def var errorSubType             as character no-undo.

    find mensiste
         where mensiste.cd-mensagem = pErrorNumber
               no-lock no-error.
    if   avail mensiste
    then do:
           assign errorDescription = mensiste.ds-mensagem-sistema
                  errorHelp        = mensiste.ds-mensagem-detalhada
                  errorSubType     = mensiste.in-tipo-mensagem.
         end.
    else do:
           assign errorDescription   = "Mensagem nao cadastrada."
                  errorSubType       = "W".
         end.

    if can-find(last rowErrors) 
    then do:
           find last rowErrors.
           assign iErrorSequence = rowErrors.ErrorSequence + 1.
         end.
    else assign iErrorSequence = iErrorSequence + 1.
    
    create rowErrors.
    assign rowErrors.errorSequence    = iErrorSequence
           rowErrors.errorNumber      = pErrorNumber
           rowErrors.errorType        = "GP"
           rowErrors.errorSubType     = "WARNING"
           rowErrors.errorDescription = errorDescription
           rowErrors.errorParameters  = pErrorParameters.

    /**
     * Tratamento para nunca permitir que errorNumber fique com o valor zero, pois o Framework
     * provoca erro e perdade conexao com o appserver.
     */
    if rowErrors.errorNumber = 0
    then assign rowErrors.errorNumber = 1.

    if trim(pErrorHelp) <> "" 
    then assign rowErrors.errorHelp = pErrorHelp.
    else assign rowErrors.errorHelp = ErrorHelp.

    if rowErrors.errorHelp <> ""
    then rowErrors.errorHelp = rowErrors.errorHelp + chr(10).

    rowErrors.errorHelp = rowErrors.errorHelp + rowErrors.errorParameters.

end procedure.

procedure insertInfoGP private:
    def input parameter pErrorNumber      as integer   no-undo.
    def input parameter pErrorParameters  as character no-undo.
    def input parameter pErrorHelp        as character no-undo.

    def input-output parameter table for rowErrors.

    def var iErrorSequence           as integer   no-undo.
    def var iErrors                  as integer   no-undo.
    def var errorDescription         as character no-undo.
    def var errorHelp                as character no-undo.
    def var errorSubType             as character no-undo.

    find mensiste
         where mensiste.cd-mensagem = pErrorNumber
               no-lock no-error.
    if   avail mensiste
    then do:
           assign errorDescription = mensiste.ds-mensagem-sistema
                  errorHelp        = mensiste.ds-mensagem-detalhada
                  errorSubType     = mensiste.in-tipo-mensagem.
         end.
    else do:
           assign errorDescription   = "Mensagem nao cadastrada."
                  errorSubType       = "I".
         end.

    if can-find(last rowErrors) 
    then do:
           find last rowErrors.
           assign iErrorSequence = rowErrors.ErrorSequence + 1.
         end.
    else assign iErrorSequence = iErrorSequence + 1.
    
    create rowErrors.
    assign rowErrors.errorSequence    = iErrorSequence
           rowErrors.errorNumber      = pErrorNumber
           rowErrors.errorType        = "GP"
           rowErrors.errorSubType     = "INFORMATION"
           rowErrors.errorDescription = errorDescription
           rowErrors.errorParameters  = pErrorParameters.

    /**
     * Tratamento para nunca permitir que errorNumber fique com o valor zero, pois o Framework
     * provoca erro e perdade conexao com o appserver.
     */
    if rowErrors.errorNumber = 0
    then assign rowErrors.errorNumber = 1.

    if trim(pErrorHelp) <> "" 
    then assign rowErrors.errorHelp = pErrorHelp.
    else assign rowErrors.errorHelp = ErrorHelp.

    if rowErrors.errorHelp <> ""
    then rowErrors.errorHelp = rowErrors.errorHelp + chr(10).

    rowErrors.errorHelp = rowErrors.errorHelp + rowErrors.errorParameters.

end procedure.

procedure insertOtherError private:

    def input parameter pErrorNumber      as integer   no-undo.
    def input parameter pErrorDescription as character no-undo.
    def input parameter pErrorParameters  as character no-undo.
    def input parameter pErrorType        as character no-undo.
    def input parameter pErrorSubType     as character no-undo.
    def input parameter pErrorHelp        as character no-undo.

    def input-output parameter table for rowErrors.
    
    def var iErrorSequence           as integer   no-undo.

    if can-find(last rowErrors) 
    then do:
           find last rowErrors.
           assign iErrorSequence = rowErrors.ErrorSequence + 1.
         end.
    else do:
           assign iErrorSequence = iErrorSequence + 1.
         end.
    
    create rowErrors.
    assign rowErrors.errorSequence    = iErrorSequence
           rowErrors.errorNumber      = pErrorNumber
           rowErrors.errorType        = pErrorType
           rowErrors.errorSubType     = pErrorSubType
           rowErrors.errorDescription = pErrorDescription
           rowErrors.errorHelp        = pErrorHelp
           rowErrors.errorParameters  = pErrorParameters.

    /**
     * Tratamento para nunca permitir que errorNumber fique com o valor zero, pois o Framework
     * provoca erro e perdade conexao com o appserver.
     */
    if rowErrors.errorNumber = 0
    then assign rowErrors.errorNumber = 1.

    if rowErrors.errorHelp <> ""
    then rowErrors.errorHelp = rowErrors.errorHelp + chr(10).

    rowErrors.errorHelp = rowErrors.errorHelp + rowErrors.errorParameters.

    return "OK".

end procedure.


/**
 * Verifica todas as mensagem inclu­das na rowErros que possuem o c½digo do
 * erro informada e que possuem o subtipo igual a 'ERROR' e troca o mesmo
 * para 'WARNING' evitando dessa forma que o processamento seja interrompido
 * e nenhum informa»’o seja retornada ao usuÿrio.
 */
procedure changeErrorToWarning private:
    def input parameter pErrorNumber      as integer   no-undo.
    def input-output parameter table for rowErrors.

    for each rowErrors where rowErrors.errorNumber = pErrorNumber 
                         and rowErrors.errorSubType = "ERROR" 
                             exclusive-lock:

        assign rowErrors.errorSubType = "WARNING".
    end.
        
end procedure.


/**
 * Transforma todos os erros em warnings
 */
procedure changeAllErrorsToWarnings private:
    def input-output parameter table for rowErrors.

    for each rowErrors where rowErrors.errorSubType = "ERROR" 
                             exclusive-lock:
        assign rowErrors.errorSubType = "WARNING".
    end.
        
end procedure.

/**
 * Verifica todas as mensagem inclu­das na rowErros que possuem o c½digo do
 * erro informada e que possuem o subtipo igual a 'ERROR' e troca o mesmo
 * para 'INFORMATION' evitando dessa forma que o processamento seja 
 * interrompido e nenhum informa»’o seja retornada ao usuÿrio.
 */
procedure changeErrorToInformation private:
    def input parameter pErrorNumber      as integer   no-undo.
    def input-output parameter table for rowErrors.

    for each rowErrors where rowErrors.errorNumber = pErrorNumber 
                         and rowErrors.errorSubType = "ERROR" 
                             exclusive-lock:

        assign rowErrors.errorSubType = "INFORMATION".
    end.
        
        
end procedure.

/**
 * Metodo chamado pelo modulo Auditoria Medica, que foi incorporado ao produto.
 */
procedure insertError private:

    def input parameter pErrorNumber      as integer   no-undo.
    def input parameter pErrorDescription as character no-undo.
    def input parameter pErrorParameters  as character no-undo.
    def input parameter pErrorType        as character no-undo.
    def input parameter pErrorSubType     as character no-undo.
    def input parameter pErrorHelp        as character no-undo.

    def input-output parameter table for rowErrors.
    
    def var iErrorSequence           as integer   no-undo.
    def var iErrors                  as integer   no-undo.
    def var errorDescription         as character no-undo.
    def var errorSubType             as character no-undo.

    case pErrorType:
        
        when "PROGRESS" 
        then run insertErrorProgress(input pErrorParameters,
                                     input pErrorHelp,
                                     input-output table rowErrors).

        when "GP"
        then run insertErrorGP(input pErrorNumber,
                               input pErrorParameters,
                               input pErrorHelp,
                               input-output table rowErrors).

        otherwise run insertOtherError(input pErrorNumber,
                                       input pErrorDescription,
                                       input pErrorParameters,
                                       input pErrorType,
                                       input pErrorSubType,
                                       input pErrorHelp,
                                       input-output table rowErrors).
    end.
    
    return "OK".

end procedure.

/* ------------------------------------------------------------------ EOF ----------------------- */

/* --- Definicao das temp's w-fatsemreaj e w-vlbenef ----------------------- */
def new shared temp-table w-fatsemreaj no-undo
    field cd-modalidade         like ter-ade.cd-modalidade    
    field cd-contratante        like fatsemreaj.cd-contratante
    field cd-contratante-origem like fatsemreaj.cd-contratante-origem 
    field nr-ter-adesao         like ter-ade.nr-ter-adesao
    field aa-referencia         like notaserv.aa-referencia
    field mm-referencia         like notaserv.mm-referencia
    field nr-sequencia          like notaserv.nr-sequencia
    field cd-padrao-cobertura   like usuario.cd-padrao-cobertura
    field qt-fator-mult         like pl-gr-pa.qt-fator-multiplicador
    field qt-fator-tr-faixa     as dec format "999.9999"
    field qt-fator-contippl     like pl-gr-pa.qt-fator-multiplicador
    field qt-fator-forpagtx     like pl-gr-pa.qt-fator-multiplicador
    field vl-evento             like tabpremo.qt-custo-modulo
    field cd-usuario            like usuario.cd-usuario
    field ch-evento-grau-modulo as char format "x(10)"
    field qt-fator-benef        like pl-gr-pa.qt-fator-multiplicador.

def new shared temp-table w-vlbenef no-undo
    field cd-modalidade             like ter-ade.cd-modalidade
    field cd-contratante            like contrat.cd-contratante     
    field cd-contratante-origem     like propost.nr-insc-contratante
    field nr-ter-adesao             like ter-ade.nr-ter-adesao
    field aa-referencia             like notaserv.aa-referencia
    field mm-referencia             like notaserv.mm-referencia
    field nr-sequencia              like notaserv.nr-sequencia
    field cd-padrao-cobertura       like usuario.cd-padrao-cobertura
    field cd-usuario                like usuario.cd-usuario
    field nr-faixa-etaria           like fatgrmod.nr-faixa-etaria
    field cd-grau-parentesco        like fatgrmod.cd-grau-parentesco
    field cd-evento                 like fatgrmod.cd-evento
    field cd-modulo                 like fatgrmod.cd-modulo
    field qt-fator-mult             like pl-gr-pa.qt-fator-multiplicador
    field qt-fator-tr-faixa         as dec format "999.9999"
    field qt-fator-contippl         like pl-gr-pa.qt-fator-multiplicador
    field qt-fator-forpagtx         like pl-gr-pa.qt-fator-multiplicador
    field vl-usuario                as dec format ">,>>>,>>>,>>9.9999"
    field pc-proporcional           as dec format "999.9999"
    field vl-resto-arredondamento   as dec
    field lg-aproximado             like vlbenef.lg-aproximado
    field vl-total                  like vlbenef.vl-total
    field qt-fator-benef            like pl-gr-pa.qt-fator-multiplicador
    field dec-2                     as dec
    field dec-3                     as dec
    index vlbenef1    is primary
                      cd-modalidade
                      cd-contratante
                      cd-contratante-origem
                      nr-ter-adesao
                      aa-referencia
                      mm-referencia
                      nr-sequencia
                      cd-usuario
                      cd-evento
                      cd-modulo
    index w-vlbenef-1 nr-ter-adesao
                      cd-evento
                      cd-grau-parentesco
                      nr-faixa-etaria
                      cd-usuario
                      cd-modulo
    index w-vlbenef-2 nr-ter-adesao
                      cd-evento
                      cd-grau-parentesco
                      nr-faixa-etaria
                      cd-usuario.

def new shared temp-table w-fatmen         no-undo     like notaserv.
def new shared temp-table w-fatgrau        no-undo     like fatgrmod.
def new shared temp-table w-fateve         no-undo     like fatueven.
def new shared temp-table w-fatgrun        no-undo     like fatgrunp. 
def new shared temp-table w-fateve-aux     no-undo     like fatueven.

def var cdd-erro as dec no-undo. 
def var cdd-seq  as dec no-undo.


select max(seq) into cdd-erro from errofatfaoro. 
select max(seq) into cdd-seq from validafatfaoro. 

if cdd-erro = ? then cdd-erro = 0.
if cdd-seq = ? then cdd-seq = 0.

assign cdd-erro = cdd-erro + 1
       cdd-seq  = cdd-seq + 1. 


DEF BUFFER b-propost FOR propost. 
/*ASSIGN PROPATH = 'c:\migracao\' + PROPATH. */

for each propost fields(propost.ep-codigo      
                         propost.cd-modalidade  
                         propost.nr-ter-adesao )
        WHERE  propost.u-log-2
          AND  propost.u-char-3 = cdstatus,
    first ter-ade fields (ter-ade.nr-ter-adesao)
                   where ter-ade.cd-modalidade = propost.cd-modalidade
                     and ter-ade.nr-ter-adesao  = propost.nr-ter-ade
                    NO-LOCK QUERY-TUNING(NO-INDEX-HINT):


    /*FOR FIRST usuario FIELDS(cd-usuario)
                      WHERE usuario.cd-modalidade = propost.cd-modalidade
                        AND usuario.nr-ter-adesao = propost.nr-ter-adesao
                        AND usuario.cd-sit-usuario >= 5
                        AND usuario.cd-sit-usuario <= 7 NO-LOCK QUERY-TUNING(NO-INDEX-HINT): END.

    IF NOT AVAIL usuario 
    THEN NEXT. 

                 
    FOR FIRST validafatfaoro WHERE validafatfaoro.modaliade = propost.cd-modalidade
                               AND validafatfaoro.termo     = propost.nr-ter-adesao NO-LOCK QUERY-TUNING(NO-INDEX-HINT): END.

    IF AVAIL validafatfaoro 
    THEN NEXT. */

    FOR FIRST b-propost WHERE ROWID(b-propost) = ROWID(propost) EXCLUSIVE-LOCK:
        ASSIGN b-propost.u-log-2 = NO. 
    END.


    empty temp-table tmp-api-mens-pre-pagamento.
    empty temp-table rowErrors.
    empty temp-table w-fatmen.     
    empty temp-table w-fateve.     
    empty temp-table w-fatgrau.    
    empty temp-table w-fatgrun.    
    empty temp-table w-vlbenef.    
    empty temp-table w-fatsemreaj. 


    create tmp-api-mens-pre-pagamento.
    assign tmp-api-mens-pre-pagamento.lg-geracao                = no
           tmp-api-mens-pre-pagamento.ep-codigo                 = propost.ep-codigo     
           tmp-api-mens-pre-pagamento.cd-modalidade             = propost.cd-modalidade 
           tmp-api-mens-pre-pagamento.nr-ter-adesao             = propost.nr-ter-adesao
           tmp-api-mens-pre-pagamento.lg-verif-fat-complementar = no
           tmp-api-mens-pre-pagamento.aa-referencia             = 2016
           tmp-api-mens-pre-pagamento.mm-referencia             = 02
           tmp-api-mens-pre-pagamento.dt-emissao                = 02/10/2016
           tmp-api-mens-pre-pagamento.dt-vencimento             = 02/20/2016.
    
    if   not valid-handle(h-faturamento-aux)
    then run api\api-mens-pre-pagamento.p persistent set h-faturamento-aux.  
    
    run api-mens-pre-pagamento in h-faturamento-aux (input-output table tmp-api-mens-pre-pagamento,
                                                     input-output table w-fatmen, 
                                                     input-output table w-fateve,
                                                     input-output table w-fatgrau,
                                                     input-output table w-fatgrun,
                                                     input-output table w-vlbenef,
                                                     input-output table w-fatsemreaj,
                                                          output table rowErrors).

    for first rowErrors no-lock: end.

    if avail rowErrors
    then do:
            create errofatfaoro. 
            assign errofatfaoro.seq       = 0
                   errofatfaoro.modaliade = propost.cd-modalidade 
                   errofatfaoro.termo      = propost.nr-ter-adesao
                   errofatfaoro.codigo     = errorNumber      
                   errofatfaoro.descricao  = errorDescription. 
         end.

    else do:
            for each w-vlbenef no-lock:
                create validafatfaoro. 
                assign validafatfaoro.seq     = 0
                       validafatfaoro.modaliade = w-vlbenef.cd-modalidade
                       validafatfaoro.termo = w-vlbenef.nr-ter-adesao
                       validafatfaoro.usuario = w-vlbenef.cd-usuario 
                       validafatfaoro.modulo = w-vlbenef.cd-modulo
                       validafatfaoro.evento = w-vlbenef.cd-evento
                       validafatfaoro.valor = w-vlbenef.vl-usuario. 
            end.
         end.
end.
*/
