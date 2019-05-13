/* CG0311X - CRIA PROPOSTAS E TABELAS RELACIONADAS */

/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/* Begin_Include: i_version_extract */
def new global shared var v_cod_arq
    as char  
    format 'x(60)'
    no-undo.
def new global shared var v_cod_tip_prog
    as character
    format 'x(8)'
    no-undo.

def stream s-arq.

def var c_prg_vrs as char init "" no-undo.
assign c_prg_vrs = "2.00.00.022".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'CG0311X':U, '2.00.00.022':U, '':U).
end /* if */.
/* End_Include: i_version_extract */

/*****************************************************************************
** Procedure Interna.....: pi_version_extract
** Descricao.............: pi_version_extract
** Criado por............: jaison
** Criado em.............: 31/07/1998 09:33:22
** Alterado por..........: tech14013
** Alterado em...........: 05/01/2005 19:27:44
*****************************************************************************/
PROCEDURE pi_version_extract:

    /************************ Parameter Definition Begin ************************/

    def Input param p_cod_program
        as character
        format "x(08)"
        no-undo.
    def Input param p_cod_program_ext
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_version
        as character
        format "x(8)"
        no-undo.
    def Input param p_cod_program_type
        as character
        format "x(8)"
        no-undo.


    /************************* Parameter Definition End *************************/

    /************************* Variable Definition Begin ************************/

    def var v_cod_event_dic
        as character
        format "x(20)":U
        label "Evento"
        column-label "Evento"
        no-undo.
    def var v_cod_tabela
        as character
        format "x(28)":U
        label "Tabela"
        column-label "Tabela"
        no-undo.


    /************************** Variable Definition End *************************/
    IF p_cod_program_type = "" OR p_cod_program_type = ? THEN DO:
        ASSIGN p_cod_program_type = "pro".
    END.


    if  can-do(v_cod_tip_prog, p_cod_program_type)
    then do:
        if p_cod_program_type = 'dic' then 
           assign p_cod_program_ext = replace(p_cod_program_ext, 'database/', '').

        output stream s-arq to value(v_cod_arq) append.

        

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            
        end.

        if  p_cod_program_type = 'dic' then do:
            
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
  /*** 010022 ***/



/******************************************************************************
*      Programa .....: CG0311X.p                                              *
*      Data .........: 29 de Janeiro de 2015                                  *
*      Autor ........: TOTVS                                                  *
*      Sistema ......: CG - Cadastros Gerais                                  *
*      Programador ..: Ja¡ne Marin                                            *
*      Objetivo .....: Importacao de Propostas                                *
*                                                                             *
*                    - Rotina de Inclusao                                     *
*                                                                             *
*******************************************************************************
*     VERSAO     DATA       RESPONSAVEL    MOTIVO                             *
*     C.00.000  29/01/2015  Ja¡ne Marin    Desenvolvimento                    *
******************************************************************************/
/******************************************************************************
*      Programa .....: hdsistem.i                                             *
*      Data .........: 13 de Janeiro de 2004                                  *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: hd - include padrao                                    *
*      Programador ..: Luis Fernando                                          *
*      Objetivo .....: Definicao do pre processos                             *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      7.00.000  13/01/2004  Luis           Conversao Ems505                  *
******************************************************************************/
/* magnus ou ems ou ems504 ou ems505 *//* normal ou oracle *//* sim ou nao *//* ------------------------------------------------------------------------- */


def shared var lg-registro-modulos      as log  no-undo.
def shared var lg-registro-faixa        as log  no-undo. 
def shared var lg-registro-negociacao   as log  no-undo.
def shared var lg-registro-cobertura    as log  no-undo.
def shared var lg-registro-especifico   as log  no-undo.
def shared var lg-registro-procedimento as log  no-undo.
def shared var lg-ver-imp8              as log  no-undo.
def shared var lg-ver-imp9              as log  no-undo.
def shared var in-classif               as int  no-undo.
DEF SHARED VAR lg-gerar-termo-aux             AS LOG INIT NO                       NO-UNDO.
DEF SHARED VAR dt-minima-termo-aux      AS DATE                               NO-UNDO.

def var lg-relat-erro            as logi                               no-undo.
def var nr-proposta-anterior-aux like propost.nr-proposta-anterior     no-undo.
def var lg-passou                as log initial no                     no-undo.
def var qt-car-ele-aux           like pro-pla.qt-caren-eletiva         no-undo.
def var qt-car-urg-aux           like pro-pla.qt-caren-urgencia        no-undo.
def var c-versao                 as char                               no-undo.
def var c-data                   as char                               no-undo.
def var c-hora                   as char                               no-undo.
def var lg-achou                 as logi                               no-undo.
def var lg-critica               as logi                               no-undo.
def var dt-inclu                 like usuario.dt-inclusao-plano        no-undo.
def var ct-codigo                like usuario.cd-usuario               no-undo.
def var lg-formato-livre-aux     as log                                no-undo.
def var ix-cont-aux              as int                                no-undo.
def var nr-cgc-cpf-aux           like contrat.nr-cgc-cpf               no-undo.
def var nr-proposta-aux          like usuario.nr-proposta              no-undo.
DEF VAR lg-medocup-aux           AS LOG                                NO-UNDO.
def var cd-senha-aux           as int format 999999                     no-undo.
def var lg-erro-rtsenha-aux    as log                                   no-undo.
def var ds-erro-rtsenha-aux            as char                                  no-undo.

def var lg-tem-proposta-aux      as   log       initial no             no-undo.
def var cd-plano-ans-aux         as int                                no-undo.
DEF VAR lg-relat-erro-aux        AS LOG                                NO-UNDO.
def var lg-retorna               as log init no                        no-undo.
DEF VAR lg-modulo-erro           AS LOG                                NO-UNDO.
def var nro-seq-aux              as int initial 0                      no-undo.
def var h-bosaueventualuser-aux  as handle                             no-undo.

DEF SHARED TEMP-TABLE tt-import-propost NO-UNDO
    FIELD rowid-import-prop AS ROWID
    FIELD nr-proposta       AS INT
    FIELD nr-insc-contrat   like contrat.nr-insc-contratante 
    INDEX ID rowid-import-prop.

def buffer b-propost         for propost.
def buffer b-contrat         for contrat.
def buffer b-import-propost  FOR import-propost.
def buffer bb-import-propost FOR import-propost.
def buffer bbb-import-propost FOR import-propost.

FUNCTION proximaseqregra RETURNS DECIMAL (): 

    DEF VAR prox-seq-par AS DEC INITIAL 0 NO-UNDO.

    SELECT MAX(cdd-seq) INTO prox-seq-par FROM regra-menslid-propost.
        
    RETURN (prox-seq-par + 1).

END FUNCTION.

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
/*{hdp/hdrunpersis.iv}*/
def var h-handle-aux              as handle no-undo.
def var h-handle2-aux             as handle no-undo.

def new shared var id-requisicao-handle-aux as char init "" no-undo.

def new global shared var v_cod_usuar_corren as char no-undo.


/*----------------------------------------------------------------------------*/
find first paramecp no-lock no-error.
if   not avail paramecp
then do:
       message "Parametros gerais do sistema nao cadastrados."
               view-as alert-box title " Atencao !!! ".
       return.
     end.

/* --------------------------------------------------------------------------*/
 
c-versao = "7.15.000".
/******************************************************************************
    Programa .....: hdlog.i
    Data .........: 01/11/2005
    Sistema ......:
    Empresa ......: DZSET SOLUCOES E SISTEMAS
    Cliente ......:
    Programador ..: NORA
    Objetivo .....: Rotina que gera o log de versao
*-----------------------------------------------------------------------------*
    Versao     DATA         RESPONSAVEL
    7.00.000   01/11/2005   NORA
******************************************************************************/
/* --- IMPLEMENTADO UMA CHAMADA A PROGRAMA POIS ESTAVA ESTOURANDO 
       O SEGMENTO DOS PROGRAMAS                                          --- */
def new global shared var v_cod_usuar_corren as character
                          format "x(12)":U label "Usu rio Corrente"
                                        column-label "Usu rio Corrente" no-undo.       
def new global shared var in-origem-chamada-menu as character format "x(12)"    
                                                                        no-undo.
/* ----------------------------- testa se Serious 7.0 ou GESTAO DE PLANOS ---*/
/* ------------- CASO FOR GESTÃO DE PLANOS RETORNA A VERSÃO DO ROUNTABLE --- */
if in-origem-chamada-menu <> "TEMENU70"
then assign c-versao      = c_prg_vrs. 

if session:multitasking-interval = 1
then do:
       run rtp/rthdlog.p (input c-versao,
                          input program-name(1)).
     end.
    

/*
Copyright (c) 2007, DATASUL S/A. Todos os direitos reservados.

Os Programas desta Aplicação (que incluem tanto o software quanto a sua
documentação) contém informações proprietárias da DATASUL S/A; eles são
licenciados de acordo com um contrato de licença contendo restrições de uso e
confidencialidade, e são também protegidos pela Lei 9609/98 e 9610/98,
respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
reversa, descompilação e desmontagem dos programas são proibidos. Nenhuma
parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
por nenhum meio, eletrônico ou mecânico, por motivo algum, sem a permissão
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
 * Returna true se existir e false caso contr rio.
 */
function containsAnyError returns logical private (input table rowErrors).

    if can-find(first rowErrors where rowErrors.errorSubType = "ERROR" use-index rowErrors1) 
    then return yes.
    else return no.

end function.

/**
 * Verifica se existe um erro na rowErros com o c¢digo informado.
 */
function containsError returns logical private (input table rowErrors,
                                                input pErrorNumber as int).

    if can-find(first rowErrors where rowErrors.errorNumber = pErrorNumber) 
    then return yes.
    else return no.

end function.

/**
 * Remove o error passado por parƒmetro da rowErros.
 * Retorna true se um erro foi removido e false caso contr rio.
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
 * Verifica todas as mensagem inclu¡das na rowErros que possuem o c¢digo do
 * erro informada e que possuem o subtipo igual a 'ERROR' e troca o mesmo
 * para 'WARNING' evitando dessa forma que o processamento seja interrompido
 * e nenhum informa‡Æo seja retornada ao usu rio.
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
 * Verifica todas as mensagem inclu¡das na rowErros que possuem o c¢digo do
 * erro informada e que possuem o subtipo igual a 'ERROR' e troca o mesmo
 * para 'INFORMATION' evitando dessa forma que o processamento seja 
 * interrompido e nenhum informa‡Æo seja retornada ao usu rio.
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

DEF     SHARED VAR qt-cont-sair-aux AS INT NO-UNDO.

/* ------------------------------------------------------------------------------------------------------ */
PROCEDURE cria-registros:

    FOR FIRST paravpmc NO-LOCK:
    END.
    IF NOT AVAIL paravpmc
    THEN DO:
           run pi-grava-erro ("Parametros VP/MC nao cadastrados").
           lg-relat-erro-aux = YES.
         END.

    l-inclusao:
    do on error undo, retry:
    
       FOR EACH tt-import-propost EXCLUSIVE-LOCK,
          FIRST b-import-propost WHERE ROWID (b-import-propost) = tt-import-propost.rowid-import-prop EXCLUSIVE-LOCK:

           ASSIGN nro-seq-aux       = 0
                  lg-relat-erro-aux = NO.
    
           FOR FIRST bbb-import-propost /*APARENTEMENTE NUNCA SETA "RP" EM IND-SIT-IMPORT. PONTO DE ATENCAO, POIS NAO HA INDICE APROPRIADO NESSA LEITURA*/
                where bbb-import-propost.ind-sit-import     = "RP"
                  and bbb-import-propost.cd-modalidade      = b-import-propost.cd-modalidade
                  and bbb-import-propost.nr-contrato-antigo = b-import-propost.nr-contrato-antigo
                      exclusive-lock: 
           END.
           if avail bbb-import-propost
           then do:
                  assign nr-proposta-aux = int(bbb-import-propost.cod-livre-6).
                  delete bbb-import-propost.
                end.
           else do:
                  /**
                   * 23/03/2016 - Alex Boeira
                   * Se num-livre-10 estiver preenchido, usar para nr-proposta.
                   * Caso contrario, gerar normalmente pela regra antiga.
                   */
                  ASSIGN nr-proposta-aux = 0.

                  IF  b-import-propost.num-livre-10 <> 0
                  AND b-import-propost.num-livre-10 <> ?
                  THEN do:
                         ASSIGN nr-proposta-aux = b-import-propost.num-livre-10.
                         IF CAN-FIND(FIRST b-propost
                                     WHERE b-propost.cd-modalidade = b-import-propost.cd-modalidade
                                       AND b-propost.nr-proposta   = nr-proposta-aux)
                         THEN DO:
                                run pi-grava-erro ("Ja existe proposta com Modalidade " + string(b-import-propost.cd-modalidade) +
                                                   " e Nr.Proposta " + STRING(nr-proposta-aux)).
                                lg-relat-erro-aux = YES.
                                NEXT.
                              END.
                       END.

                  /**
                   * 21/03/2016 - Alex Boeira
                   * Retirei deste ponto a logica de geracao do nr da proposta
                   * e implementei dentro do metodo cria-proposta, pois estava
                   * causando erro de tentativa de duplicar a chave ao executar
                   * esse processo em mais de uma sessao simultanea.
                   
           		  for last b-propost fields (nr-proposta) use-index propos2 
              		 where b-propost.cd-modalidade = b-import-propost.cd-modalidade exclusive-lock:
           		  end.
           		  if   available b-propost
           		  then assign nr-proposta-aux = b-propost.nr-proposta + 1.
           		  else assign nr-proposta-aux = 1.
                  */
                end.
           
           ASSIGN qt-cont-sair-aux = qt-cont-sair-aux + 1.

           IF lg-relat-erro-aux
           THEN do:
                  DELETE tt-import-propost.
                  NEXT.
                END.

           RUN cria-proposta.
    
           IF lg-relat-erro-aux
           THEN do:
                  RUN remover.
                  DELETE tt-import-propost.
                  NEXT.
                END.

           /* --- MODULOS PROPOSTA ---------------------------------- */
           ASSIGN lg-relat-erro-aux = NO.
    
           IF lg-registro-modulos
           THEN RUN cria-modulos.
    
           IF lg-relat-erro-aux
           THEN do:
                  RUN remover.
                  DELETE tt-import-propost.
                  NEXT.
                END.
    
           /* --- FAIXAS PROPOSTA ----------------------------------- */
           ASSIGN lg-relat-erro-aux = NO.
               
           IF  lg-registro-faixa
           AND b-import-propost.ind-faixa-etaria-especial <> "N"
           THEN RUN cria-faixas.

           RUN cria-lotacao.

           IF lg-relat-erro-aux
           THEN do:
                  RUN remover.
                  DELETE tt-import-propost.
                  NEXT.
                END.
    
           /* --- NEGOCIACOES REPASSE ------------------------------- */
           IF lg-registro-negociacao
           THEN RUN cria-negoc-repas.
    
           /* --- COBERTURA PROPOSTA -------------------------------- */
           IF lg-registro-cobertura
           THEN RUN cria-cobertura.
    
           /* --- CAMPOS ESPECIFICOS -------------------------------- */
           IF lg-registro-especifico
           THEN RUN cria-campos-espec.
    
           /* --- PROCEDIMENTOS PROPOSTA ---------------------------- */
           ASSIGN lg-relat-erro-aux = NO.
    
           IF lg-registro-procedimento
           THEN RUN cria-proced-propost.
    
           IF lg-relat-erro-aux
           THEN do:
                  RUN remover.
                  DELETE tt-import-propost.
                  NEXT.
                END.
    
           /* --- MEDICINA OCUPACIONAL ------------------------------ */
           IF lg-ver-imp8
           THEN RUN cria-mo.
    
           /* --- MEDICINA OCUPACIONAL FUNCAO------------------------ */
           IF lg-ver-imp9
           THEN RUN cria-mo-funcao.
    
           ASSIGN b-import-propost.ind-sit-import = "IT".
                  
           VALIDATE b-import-propost.
           RELEASE  b-import-propost.
           
           DELETE tt-import-propost.
    
       END.
    END.


END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
/*
procedure modulo-padrao.

    if   b-import-propost.cd-forma-pagto = 1
    or   b-import-propost.cd-forma-pagto = 2
    then do:
           for each pla-mod where pla-mod.cd-modalidade = b-import-propost.cd-modalidade
                              and pla-mod.cd-plano      = b-import-propost.cd-plano
                              and pla-mod.cd-tipo-plano = b-import-propost.cd-tipo-plano
                                  no-lock:
               if   pla-mod.lg-obrigatorio
               then do:
                      find first pro-pla use-index pro-pla3
                           where pro-pla.cd-modalidade = b-import-propost.cd-modalidade
                             and pro-pla.nr-proposta = nr-proposta-aux
                             and pro-pla.cd-modulo   = pla-mod.cd-modulo
                                 no-lock no-error.
                      if   not avail pro-pla
                      then do:
                             find tabpremo where tabpremo.cd-modalidade = b-import-propost.cd-modalidade
                                             and tabpremo.cd-plano      = b-import-propost.cd-plano
                                             and tabpremo.cd-tipo-plano = b-import-propost.cd-tipo-plano
                                             and tabpremo.cd-modulo     = pla-mod.cd-modulo
                                             and tabpremo.cd-tab-preco  = b-import-propost.cd-tab-preco
                                                 no-lock no-error.
                             if   not avail tabpremo
                             then do:
                                    assign lg-relat-erro = yes
                                           lg-retorna    = yes.
                                    run pi-grava-erro (input b-import-propost.num-seqcial-control,
                                                       input "PR -b-import-propost",
                                                       input "Tabela de Preco dos modulos nao cadastrada " + substring(b-import-propost.cd-tab-preco,1,3) + 
                                                             "/" + substring(b-import-propost.cd-tab-preco,4,2)  + 
                                                             "Mod: "    + string(b-import-propost.cd-modalidade) + 
                                                             "Plano: "  + string(b-import-propost.cd-plano)      + 
                                                             "Tipo: "   + string(b-import-propost.cd-tipo-plano) + 
                                                             "Modulo: " + string(pla-mod.cd-modulo),
                                                       input "ER").
                                    return.
                                  end.
                             find mod-cob where mod-cob.cd-modulo = pla-mod.cd-modulo no-lock no-error.
                             if not avail mod-cob
                             then do:
                                    assign lg-relat-erro = yes
                                           lg-retorna    = yes.
                                    run pi-grava-erro (input b-import-propost.num-seqcial-control,
                                                       input "PR -b-import-propost",
                                                       input "Modulo nao Cadastrado - Modulo: " + string(pro-pla.cd-modulo,"999"),
                                                       input "ER").
                                    return.
                                  end.                                  
           
                             create pro-pla.
                             assign pro-pla.cd-modalidade           = b-import-propost.cd-modalidade
                                    pro-pla.cd-plano                = b-import-propost.cd-plano
                                    pro-pla.cd-tipo-plano           = b-import-propost.cd-tipo-plano
                                    pro-pla.cd-modulo               = pla-mod.cd-modulo
                                    pro-pla.nr-proposta             = nr-proposta-aux
                                    pro-pla.cd-forma-pagto          = b-import-propost.cd-forma-pagto
                                    pro-pla.lg-carencia             = yes
                                    pro-pla.lg-cobertura-obrigato   = yes
                                    pro-pla.in-ctrl-carencia-proced = mod-cob.in-ctrl-carencia-proced
                                    pro-pla.in-ctrl-carencia-insumo = mod-cob.in-ctrl-carencia-insumo
                                    pro-pla.dt-inicio               = b-import-propost.dat-propost
                                    pro-pla.dt-cancelamento         = b-import-propost.dat-fim-propost
                                    pro-pla.dt-fim                  = b-import-propost.dat-fim-propost
                                    pro-pla.in-cobra-participacao   = pla-mod.in-cobra-participacao
                                    pro-pla.in-responsavel-autori   = pla-mod.in-responsavel-autorizacao
                                    pro-pla.dt-atualizacao          = today
                                    pro-pla.cd-userid               = v_cod_usuar_corren
                                    pro-pla.dt-mov-inclusao         = today
                                    pro-pla.cd-userid-inclusao      = v_cod_usuar_corren.

                             if mod-cob.in-ctrl-carencia-proced = 1
                             or mod-cob.in-ctrl-carencia-insumo = 1
                             then assign pro-pla.qt-caren-eletiva  = pla-mod.qt-caren-eletiva
                                         pro-pla.qt-caren-urgencia = pla-mod.qt-caren-urgencia.
                             else assign pro-pla.qt-caren-eletiva  = 0 
                                         pro-pla.qt-caren-urgencia = 0.
           
                             if   b-import-propost.dat-fim-propost = ?
                             then.
                             else assign pro-pla.dt-mov-exclusao = today
                                         pro-pla.cd-userid-exclusao
                                                  = v_cod_usuar_corren.
           
                             assign lg-plano-aux = yes.
                           end.
                     end.
           end.
         end. /*  tipo de pagto = 1 ou 2  */
 
 
    if   b-import-propost.cd-forma-pagto = 3
    then do:
           for each pla-mod 
              where pla-mod.cd-modalidade = b-import-propost.cd-modalidade
                and pla-mod.cd-plano      = b-import-propost.cd-plano
                and pla-mod.cd-tipo-plano = b-import-propost.cd-tipo-plano   
                    no-lock:
     
               if   pla-mod.lg-obrigatorio
               then do:
                      find plamofor where plamofor.cd-modalidade  = b-import-propost.cd-modalidade
                                       and plamofor.cd-plano      = b-import-propost.cd-plano
                                       and plamofor.cd-tipo-plano = b-import-propost.cd-tipo-plano
                                       and plamofor.cd-modulo     = pla-mod.cd-modulo
                                           no-lock no-error.
                      if   avail plamofor
                      then do:
                           find first pro-pla use-index pro-pla3
                                where pro-pla.cd-modalidade = b-import-propost.cd-modalidade
                                  and pro-pla.nr-proposta   = nr-proposta-aux
                                  and pro-pla.cd-modulo     = plamofor.cd-modulo
                                      no-lock no-error.
                           if   not avail pro-pla
                           then do:
                                  find tabpremo where tabpremo.cd-modalidade   = b-import-propost.cd-modalidade
                                                  and tabpremo.cd-plano      = b-import-propost.cd-plano
                                                  and tabpremo.cd-tipo-plano = b-import-propost.cd-tipo-plano
                                                  and tabpremo.cd-modulo     = pla-mod.cd-modulo
                                                  and tabpremo.cd-tab-preco  = b-import-propost.cd-tab-preco
                                                      no-lock no-error.
                                  if   not avail tabpremo
                                  then do:
                                         assign lg-relat-erro = yes
                                                lg-retorna    = yes.
                                         run pi-grava-erro (input b-import-propost.num-seqcial-control,
                                                            input "PR -b-import-propost",
                                                            input "Tabela de Preco dos modulos nao cadastrada " + substring(b-import-propost.cd-tab-preco,1,3) + 
                                                                  "/" + substring(b-import-propost.cd-tab-preco,4,2)   + 
                                                                  "Mod: "    +  string(b-import-propost.cd-modalidade) + 
                                                                  "Plano: "  +  string(b-import-propost.cd-plano)      + 
                                                                  "Tipo: "   +  string(b-import-propost.cd-tipo-plano) + 
                                                                  "modulo: " +  string(pla-mod.cd-modulo),
                                                            input "ER").
                                         return.
                                       end.
                                  find mod-cob where mod-cob.cd-modulo = pla-mod.cd-modulo no-lock no-error.
                                  if not avail mod-cob
                                  then do:
                                         assign lg-relat-erro = yes
                                                lg-retorna    = yes.
                                         run pi-grava-erro (input b-import-propost.num-seqcial-control,
                                                            input "PR -b-import-propost",
                                                            input "Modulo nao Cadastrado - Modulo: " + string(pro-pla.cd-modulo,"999"),
                                                            input "ER").
                                         return.
                                       end.
                                  
                                  create pro-pla.
                                  assign pro-pla.cd-modalidade            = b-import-propost.cd-modalidade
                                         pro-pla.cd-plano                 = b-import-propost.cd-plano
                                         pro-pla.cd-tipo-plano            = b-import-propost.cd-tipo-plano
                                         pro-pla.cd-modulo                = plamofor.cd-modulo
                                         pro-pla.nr-proposta              = nr-proposta-aux
                                         pro-pla.cd-forma-pagto           = plamofor.cd-forma-pagto
                                         pro-pla.lg-carencia              = yes
                                         pro-pla.lg-cobertura-obrigatoria = yes
                                         pro-pla.in-ctrl-carencia-proced  = mod-cob.in-ctrl-carencia-proced
                                         pro-pla.in-ctrl-carencia-insumo  = mod-cob.in-ctrl-carencia-insumo
                                         pro-pla.qt-caren-eletiva         = pla-mod.qt-caren-eletiva
                                         pro-pla.qt-caren-urgencia        = pla-mod.qt-caren-urgencia
                                         pro-pla.in-cobra-participacao    = pla-mod.in-cobra-participacao
                                         pro-pla.in-responsavel-autori    = pla-mod.in-responsavel-autorizacao
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
                                   assign lg-plano-aux = yes.
                                 end.
                            end.
                      end.
           end.   /*  for each   */
       end.  /* forma de pagto = 3 */
 
end.*/

PROCEDURE cria-proposta:
    DEF BUFFER b-ter-ade FOR ter-ade.
    DEF VAR lg-validar-nr-proposta-aux AS LOG INIT NO NO-UNDO.

    ASSIGN lg-relat-erro-aux = NO.

    find modalid where modalid.cd-modalidade = b-import-propost.cd-modalidade no-lock no-error.

    FIND ti-pl-sa NO-LOCK
         WHERE ti-pl-sa.cd-modalidade = b-import-propost.cd-modalidade
           AND ti-pl-sa.cd-plano      = b-import-propost.cd-plano
           AND ti-pl-sa.cd-tipo-plano = b-import-propost.cd-tipo-plano NO-ERROR.

    for last b-propost fields (nr-proposta) use-index propos8 
       where b-propost.cd-modalidade       = b-import-propost.cd-modalidade
         and b-propost.nr-insc-contratante = tt-import-propost.nr-insc-contrat no-lock:
    end.
    if   available b-propost
    then assign nr-proposta-anterior-aux = b-propost.nr-proposta.
    else assign nr-proposta-anterior-aux = 0.

    if b-import-propost.in-registro-plano = 1
    then do:
           if b-import-propost.cd-registro-plano <> 0
           then for first reg-plano-saude fields(idi-registro)
                    where reg-plano-saude.cdn-plano-ans = b-import-propost.cd-registro-plano 
                          no-lock query-tuning(no-index-hint): 
                end.
           else for first reg-plano-saude fields(idi-registro)
                    where reg-plano-saude.cod-plano-operadora    = b-import-propost.cd-plano-operadora 
                      and reg-plano-saude.in-tipo-regulamentacao = b-import-propost.num-livre-8
                          no-lock query-tuning (no-index-hint): 
                end.
         end.
    
    /**
     * Se chegou nesse ponto com nr-proposta-aux <> 0, significa que o numero
     * ja foi definido e nao deve ser alterado.
     */
    if nr-proposta-aux = 0
    then do:
           for last b-propost fields (nr-proposta) use-index propos2 
              where b-propost.cd-modalidade = b-import-propost.cd-modalidade no-lock:
           end.
           if   available b-propost
           then assign nr-proposta-aux = b-propost.nr-proposta + 1.
           else assign nr-proposta-aux = 1.

           assign lg-validar-nr-proposta-aux = yes.
         end.

    /** 
     * Gerar numero da proxima proposta.
     */
    create propost.

    if lg-validar-nr-proposta-aux
    then do:
           repeat:
               assign propost.cd-modalidade = b-import-propost.cd-modalidade
                      propost.nr-proposta   = nr-proposta-aux no-error.
               validate propost no-error.
               if error-status:error 
               or error-status:num-messages > 0
               then do:
                      pause(1). /* aguarda 1seg e busca novamente o proximo nr livre.*/
               
                      for last b-propost fields (nr-proposta) use-index propos2 
                         where b-propost.cd-modalidade = b-import-propost.cd-modalidade no-lock:
                      end.
                      if   available b-propost
                      then assign nr-proposta-aux = b-propost.nr-proposta + 1.
                      else assign nr-proposta-aux = 1.
                    end.
               else leave.    /* o nr gerado eh valido. continua o processo.*/
           end.
         end.
    else assign propost.cd-modalidade        = b-import-propost.cd-modalidade
                propost.nr-proposta          = nr-proposta-aux.

    assign propost.vl-proposta-migracao = b-import-propost.val-propost-migrac
           propost.mm-ult-reajuste      = b-import-propost.num-mm-ult-reaj
           propost.aa-ult-reajuste      = b-import-propost.aa-ult-reajuste
           propost.pc-ult-reajuste      = b-import-propost.pc-ult-reajuste / 100
           propost.idi-plano-ans        = if avail reg-plano-saude then reg-plano-saude.idi-registro else 0.

    for first for-pag fields (tp-vencimento 
                              dd-faturamento 
                              lg-trata-inadimplencia-rc
                              cd-classe-mens)
        where for-pag.cd-modalidade  = b-import-propost.cd-modalidade
          and for-pag.cd-plano       = b-import-propost.cd-plano
          and for-pag.cd-tipo-plano  = b-import-propost.cd-tipo-plano
          and for-pag.cd-forma-pagto = b-import-propost.cd-forma-pagto 
              no-lock query-tuning (no-index-hint):
    end.
    
    /* ----------------------------------------- INDICADOR INADIMPLENCIA --- */
    if avail for-pag
    and      for-pag.lg-trata-inadimplencia-rc
    then assign propost.in-trata-inadimplencia = 00. /* ---------- TRATA --- */
    else assign propost.in-trata-inadimplencia = 01. /* ------ NAO TRATA --- */
    
    if   avail paramecp
    then assign propost.ep-codigo   = paramecp.ep-codigo
                propost.cod-estabel = paramecp.cod-estabel
                propost.cd-unimed   = paramecp.cd-unimed.

    if b-import-propost.ind-faixa-etaria-especial <> "" 
    and not can-find (first import-faixa-propost where import-faixa-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost)
    then DO:
           /* -------------------------------- FAIXA ESPECIAL PELA ESTRUTURA --- */
           if b-import-propost.ind-faixa-etaria-especial = "S"
           then for each pl-gr-pa fields (cd-grau-parentesco nr-faixa-etaria nr-idade-minima nr-idade-maxima qt-fator-multiplicador qt-fat-mult-inscr lg-inclusao)
                   where pl-gr-pa.cd-modalidade = b-import-propost.cd-modalidade
                     and pl-gr-pa.cd-plano      = b-import-propost.cd-plano
                     and pl-gr-pa.cd-tipo-plano = b-import-propost.cd-tipo-plano
                     and pl-gr-pa.lg-inclusao no-lock query-tuning(no-index-hint):
                  
                    if not can-find (first teadgrpa 
                                     where teadgrpa.cd-modalidade      = b-import-propost.cd-modalidade
                                       and teadgrpa.nr-proposta        = nr-proposta-aux
                                       and teadgrpa.cd-grau-parentesco = pl-gr-pa.cd-grau-parentesco
                                       and teadgrpa.nr-faixa-etaria    = pl-gr-pa.nr-faixa-etaria)
                    then do:
                           create teadgrpa.
                           assign teadgrpa.cd-modalidade          = b-import-propost.cd-modalidade
                                  teadgrpa.nr-proposta            = nr-proposta-aux
                                  teadgrpa.cd-grau-parentesco     = pl-gr-pa.cd-grau-parentesco
                                  teadgrpa.nr-faixa-etaria        = pl-gr-pa.nr-faixa-etaria
                                  teadgrpa.nr-idade-minima        = pl-gr-pa.nr-idade-minima
                                  teadgrpa.nr-idade-maxima        = pl-gr-pa.nr-idade-maxima
                                  teadgrpa.qt-fator-multiplicador = pl-gr-pa.qt-fator-multiplicador
                                  teadgrpa.qt-fat-mult-inscr      = pl-gr-pa.qt-fat-mult-inscr
                                  teadgrpa.lg-inclusao            = pl-gr-pa.lg-inclusao
                                  teadgrpa.dt-atualizacao         = today.
                                  teadgrpa.cd-userid              = v_cod_usuar_corren.
                         end.
                end.

           /* ------------------------------- FAIXA ESPECIAL PELO CONVENIO ---
            * O extrator do Unicoo nunca envia esse parametro como "C". A regra foi preservada
            * para migracoes de outros sistemas.
            */
           if b-import-propost.ind-faixa-etaria-especial = "C"
           then for each fxetconv FIELDS (cd-grau-parentesco nr-faixa-etaria nr-idade-minima nr-idade-maxima qt-fator-multiplicador qt-fat-mult-inscr lg-inclusao)
                   where fxetconv.cd-convenio    = b-import-propost.cd-convenio
                     and fxetconv.cd-modalidade  = b-import-propost.cd-modalidade
                     and fxetconv.cd-plano       = b-import-propost.cd-plano
                     and fxetconv.cd-tipo-plano  = b-import-propost.cd-tipo-plano
                     and fxetconv.lg-inclusao NO-LOCK query-tuning(no-index-hint): 
           
                    IF NOT CAN-FIND (first teadgrpa 
                                     where teadgrpa.cd-modalidade      = b-import-propost.cd-modalidade
                                       and teadgrpa.nr-proposta        = nr-proposta-aux
                                       and teadgrpa.cd-grau-parentesco = fxetconv.cd-grau-parentesco
                                       and teadgrpa.nr-faixa-etaria    = fxetconv.nr-faixa-etaria)
                    then do:
                           create teadgrpa.
                           assign teadgrpa.cd-modalidade          = b-import-propost.cd-modalidade
                                  teadgrpa.nr-proposta            = nr-proposta-aux
                                  teadgrpa.cd-grau-parentesco     = fxetconv.cd-grau-parentesco
                                  teadgrpa.nr-faixa-etaria        = fxetconv.nr-faixa-etaria
                                  teadgrpa.nr-idade-minima        = fxetconv.nr-idade-minima
                                  teadgrpa.nr-idade-maxima        = fxetconv.nr-idade-maxima
                                  teadgrpa.qt-fator-multiplicador = fxetconv.qt-fator-multiplicador
                                  teadgrpa.qt-fat-mult-inscr      = fxetconv.qt-fat-mult-inscr
                                  teadgrpa.lg-inclusao            = fxetconv.lg-inclusao
                                  teadgrpa.dt-atualizacao         = today.
                                  teadgrpa.cd-userid              = v_cod_usuar_corren.
                         end.
                end. 
         end.

    release contrat.

    if b-import-propost.nr-insc-contratante <> 0
    then for first contrat fields (cd-contratante nr-insc-contratante lg-tem-proposta) 
             where contrat.nr-insc-contratante = b-import-propost.nr-insc-contratante 
                   exclusive-lock query-tuning (no-index-hint):

             assign contrat.lg-tem-proposta     = yes
                    propost.cd-contratante      = contrat.cd-contratante
                    propost.nr-insc-contratante = contrat.nr-insc-contratante.
         end.
    
    if avail contrat
    then do:
            for first endereco fields (cd-cidade)
                 where endereco.id-pessoa = contrat.id-pessoa
                   and endereco.lg-principal no-lock query-tuning (no-index-hint):
        
                 for first assocva-cidad-empres-estab fields (cod-empres cod-estab) 
                     where assocva-cidad-empres-estab.cdn-cidad = endereco.cd-cidade 
                           no-lock query-tuning (no-index-hint):
    
                     assign propost.ep-codigo   = assocva-cidad-empres-estab.cod-empres
                            propost.cod-estabel = assocva-cidad-empres-estab.cod-estab.
                 end.
            end.
    
             /* NOVO CAMPO - ENDERECO DE COBRANCA DO CONTRATO (BOLETO) */
              for first endereco fields (id-endereco)
                  where endereco.id-pessoa = contrat.id-pessoa
                    and endereco.lg-end-cobranca no-lock query-tuning (no-index-hint):

                        ASSIGN propost.num-livre-17 = endereco.id-endereco.
              end.
              IF propost.num-livre-17 = 0
              THEN    for first endereco fields (id-endereco)
                           where endereco.id-pessoa = contrat.id-pessoa
                             and endereco.lg-principal no-lock query-tuning (no-index-hint):
        
                                 ASSIGN propost.num-livre-17 = endereco.id-endereco.
                      end.
    END.

    assign propost.nr-insc-contrat-origem = 0
           propost.cd-contrat-origem      = 0.

    if  b-import-propost.nr-insc-contrat-origem <> 0
    and b-import-propost.nr-insc-contrat-origem <> ?
    then for first b-contrat fields (cd-contratante nr-insc-contratante lg-tem-proposta) 
             where b-contrat.nr-insc-contratante = b-import-propost.nr-insc-contrat-origem 
                   exclusive-lock query-tuning (no-index-hint):

             assign b-contrat.lg-tem-proposta       = yes
                    propost.cd-contrat-origem       = b-contrat.cd-contratante
                    propost.nr-insc-contrat-origem  = b-contrat.nr-insc-contratante.
         end.

    if b-import-propost.ind-faixa-etaria-especial = "S" 
    or b-import-propost.ind-faixa-etaria-especial = "C"
    then assign propost.lg-faixa-etaria-esp = yes.
    else assign propost.lg-faixa-etaria-esp = no.
           
    assign propost.cd-plano                   = b-import-propost.cd-plano
           propost.cd-tipo-plano              = b-import-propost.cd-tipo-plano
           propost.cd-tipo-proposta           = 09 
           propost.lg-cobertura-esp           = b-import-propost.log-cobert-especial
           propost.cd-forma-pagto             = b-import-propost.cd-forma-pagto
           propost.cd-tipo-vencimento         = b-import-propost.cdn-tip-vencto
           propost.dd-vencimento              = b-import-propost.num-dia-vencto
           propost.lg-inicio-validade         = b-import-propost.log-inic-valid
           propost.lg-medico-empresa          = b-import-propost.log-medic-empres
           propost.cd-vendedor                = b-import-propost.cd-vendedor
           propost.lg-considera-taxa-co       = b-import-propost.log-consid-tax-coper
           propost.pc-acresc-taxa             = if b-import-propost.pc-acresc-taxa = ? then 0 else b-import-propost.pc-acresc-taxa
           propost.lg-mascara                 = b-import-propost.log-mascar
           propost.lg-cartao                  = b-import-propost.log-cartao
           propost.lg-precproc-cob            = b-import-propost.log-cobr-dif-pagto
           propost.lg-pea                     = b-import-propost.log-segassist
           
           propost.lg-altera-validade-usuario = b-import-propost.log-altera-val-usuar
           propost.lg-alt-val-usu-prorroga    = b-import-propost.log-altera-valid-prorrog
           propost.lg-altera-taxa-inscricao   = b-import-propost.log-altera-tax-inscr
           propost.lg-altera-fator-moderador  = b-import-propost.log-altera-fator-moder
           
           propost.lg-prop-regulamentada      = b-import-propost.log-propost-regulam
           propost.log-2                      = YES /* Permite informar data de exclusão */
           propost.log-3                      = IF lg-ver-imp8 THEN YES ELSE NO /* Emite termo de comunicação */
           propost.log-11                     = b-import-propost.log-livre-1 /* usuario eventual */
           propost.log-13                     = FALSE /* inadimplencia a nivel de proposta */
           propost.dec-1                      = 0 /*numero maximo de dias de inadimplencia (relacionado ao log-13)*/
           propost.date-1                     = b-import-propost.dat-livre-1 /*data de validade da carteira (CONTRATO_DA_PESSOA.DTVALIDCAR)*/
           propost.log-4                      = YES /* UTILIZA REAJUSTE DA REGRA DE MENSALIDADE? */
           propost.log-5                      = b-import-propost.log-livre-5 /* COBRA FRANQUIA? */
           .

    IF /*b-import-propost.in-tipo-natureza = 3 /* EMPRESARIAL */
    AND*/ can-find(FIRST import-lotac-propost
                 WHERE import-lotac-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost 
                   AND import-lotac-propost.cdn-lotac <> 0)
    THEN propost.log-utiliz-lotac           = yes.
    ELSE propost.log-utiliz-lotac           = NO.

    IF b-import-propost.in-tipo-natureza = 4 /* ADESAO */
    THEN propost.num-livre-16 = 2. /* indicador se permite informar RESPONSAVEL FINANCEIRO no beneficiario. 0-desabilitado, 1-opcional, 2-obrigatorio*/
    else propost.num-livre-16 = 0. /* ativar como opcional apenas para os planos Adesao*/

    /**
     * Indicador se a geracao do Numero de Familia sera automatico (0) ou manual (1).
     */
    IF b-import-propost.log-livre-2
    THEN assign propost.int-1 = 1.
    ELSE assign propost.int-1 = 0.

    /**
     * Indicador de Empresario Individual (RN432)
     */
    IF b-import-propost.log-livre-3
    THEN ASSIGN propost.char-15 = "yes".
    else ASSIGN propost.char-15 = "no".

    if   b-import-propost.log-fatur-segassist
    and  b-import-propost.log-segassist         
    then assign b-import-propost.pc-desconto-inscr = 100
                b-import-propost.dat-lim-desc-inscr = b-import-propost.dat-fim-segassist.
    
    else if b-import-propost.log-segassist 
         then assign b-import-propost.pc-desconto         = 100
                     b-import-propost.dat-lim-desc-mensal = b-import-propost.dat-fim-segassist
                     b-import-propost.pc-desconto-inscr   = 100
                     b-import-propost.dat-lim-desc-inscr  = b-import-propost.dat-fim-segassist.
    
    if b-import-propost.log-fatur-segassist and
       b-import-propost.log-segassist   
    then do:
           if b-import-propost.ind-cobr = "0"
           then propost.in-mensalidade-migracao = 0.
           else propost.in-mensalidade-migracao = 2.
         end.
    
    if   propost.lg-mascara
    then assign propost.ds-mascara = caps(b-import-propost.des-mascar).
    
    assign propost.dt-proposta           = b-import-propost.dat-propost
           propost.nr-proposta-anterior  = nr-proposta-anterior-aux
           propost.cd-tab-preco          = b-import-propost.cd-tab-preco
           propost.cd-tab-preco-proc     = b-import-propost.cd-tab-preco-proc
           propost.cd-tab-preco-proc-cob = b-import-propost.cd-tab-preco-proc-cob
           propost.cd-convenio           = b-import-propost.cd-convenio
           propost.cd-tipo-participacao  = b-import-propost.cd-tipo-participacao
           propost.pc-desconto           = b-import-propost.pc-desconto
           propost.pc-acrescimo          = b-import-propost.pc-acrescimo
           propost.pc-desconto-inscr     = b-import-propost.pc-desconto-inscr
           propost.pc-acrescimo-inscr    = b-import-propost.pc-acrescimo-inscr
           propost.dt-lim-acres-mens     = b-import-propost.dt-lim-acres-mens
           propost.dt-lim-acres-inscr    = b-import-propost.dat-lim-acresc-inscr
           propost.dt-lim-desc-mens      = b-import-propost.dat-lim-desc-mensal
           propost.dt-lim-desc-inscr     = b-import-propost.dat-lim-desc-inscr
           propost.pc-desc-prom-taxa     = b-import-propost.pc-desc-prom-taxa
           propost.dt-val-prom-tax       = b-import-propost.dat-valid-prom-tax
           propost.pc-desc-prom-pl       = b-import-propost.pc-desc-prom-pl
           propost.dt-val-prom-pl        = b-import-propost.dat-valid-prom-plano
           propost.dt-libera-doc         = b-import-propost.dat-fim-propost
           propost.qt-validade-cartao    = b-import-propost.qt-validade-cartao
           propost.um-validade-cartao    = b-import-propost.um-validade-cartao
           propost.qt-validade-cart      = b-import-propost.qt-validade-cart
           propost.um-validade-cart      = b-import-propost.um-validade-cart
           propost.qt-validade-termo     = b-import-propost.qt-validade-termo
           propost.um-validade-termo     = b-import-propost.um-validade-termo
           propost.in-tipo-contratacao   = b-import-propost.in-tipo-contratacao
           propost.in-tipo-natureza      = b-import-propost.in-tipo-natureza
           propost.in-validade-doc-ident = b-import-propost.in-validade-doc-ident
           propost.in-registro-plano     = b-import-propost.in-registro-plano
           propost.nr-oficio-reajuste    = b-import-propost.nr-oficio-reajuste
           propost.int-12                = b-import-propost.cdn-tip-idx  
           propost.int-13                = b-import-propost.cdn-niv-reaj
           propost.cd-sit-proposta       = 1
           propost.nr-contrato-antigo    = b-import-propost.nr-contrato-antigo
           propost.dt-digitacao          = today
           propost.cd-userid-digitacao   = v_cod_usuar_corren
           propost.dt-atualizacao        = today
           propost.cd-userid             = v_cod_usuar_corren
           propost.mm-aa-ult-fat-mig     = substr(string(b-import-propost.num-mes-ult-faturam,"99"),1,2)
                                         + substr(string(b-import-propost.aa-ult-fat,"9999"),1,4)
           /* inicializa PROXIMO AJUSTE PARTICIPACAO com proximo ano a partir do inicio do termo, mas pode ser 
              sobreposto na procedure unicoogps.p_associa_agrupador_contrato (PL/SQL) caso encontre informacao mais atual no UNICOO*/
           propost.char-11 = string(year(b-import-propost.dat-propost) + 1,"9999") + STRING(MONTH(b-import-propost.dat-propost),"99")
           propost.log-12 = YES. /*novas regras faturamento*/

    /* --- Validade do termo e cartÆo -------------------------------------- */
    /*
    FIND FIRST ti-pl-sa 
         WHERE ti-pl-sa.cd-modalidade = propost.cd-modalidade
           AND ti-pl-sa.cd-plano      = propost.cd-plano
           AND ti-pl-sa.cd-tipo-plano = propost.cd-tipo-plano 
               NO-LOCK NO-ERROR.

    IF AVAIL ti-pl-sa
    THEN DO:
           IF  ti-pl-sa.um-validade-termo = b-import-propost.um-validade-termo
           AND ti-pl-sa.qt-validade-termo = b-import-propost.qt-validade-termo
           THEN ASSIGN propost.qt-validade-termo = 0
                       propost.um-validade-termo = "".
           ELSE ASSIGN propost.qt-validade-termo = b-import-propost.qt-validade-termo
                       propost.um-validade-termo = b-import-propost.um-validade-termo.

           IF  ti-pl-sa.qt-validade-cart = b-import-propost.qt-validade-cart
           AND ti-pl-sa.um-validade-cart = b-import-propost.um-validade-cart
           THEN ASSIGN propost.qt-validade-cart = 0
                       propost.um-validade-cart = "".
           ELSE ASSIGN propost.qt-validade-cart = b-import-propost.qt-validade-cart
                       propost.um-validade-cart = b-import-propost.um-validade-cart.

           IF  ti-pl-sa.qt-validade-cartao = b-import-propost.qt-validade-cartao
           AND ti-pl-sa.um-validade-cartao = b-import-propost.um-validade-cartao
           THEN ASSIGN propost.qt-validade-cartao = 0
                       propost.um-validade-cartao = "".
           ELSE ASSIGN propost.qt-validade-cartao = b-import-propost.qt-validade-cartao
                       propost.um-validade-cartao = b-import-propost.um-validade-cartao.
         END.
    */
    
    /* --------------------------------------------------------------------- */
    IF lg-gerar-termo-aux
    THEN DO:
           if   modalid.in-geracao-termo = 1 /* numero do termo sequencial */
           then do:
                  FOR last b-ter-ade FIELDS (nr-ter-adesao)
                     where b-ter-ade.cd-modalidade = propost.cd-modalidade EXCLUSIVE-LOCK:
                  END.
                  if   not avail b-ter-ade
                  then assign propost.nr-ter-adesao = 1.
                  else assign propost.nr-ter-adesao = b-ter-ade.nr-ter-adesao + 1.
                end.
           else do: /* numero do termo igual ao numero da proposta */
                  if   propost.nr-proposta > 999999
                  then do:
                         run pi-grava-erro ("Nao sera possivel gerar numero do termo. " +  
                                            "Proposta com numero maior que 999999."     + 
                                            " Mod: " + string(propost.cd-modalidade)).
                         lg-relat-erro-aux = YES.
                         assign propost.nr-ter-adesao = 0.
                         next.
                       end.
                  else assign propost.nr-ter-adesao = propost.nr-proposta.
                end.

           /*
           if   today > propost.dt-lim-acres-mens
           or   today > propost.dt-lim-acres-inscr
           then do: 
                  assign ds-mensagem-err-aux = "Proposta com data limite " +
                                               "de acrescimo da mensalidade/" +
                                               "inscricao vencida".
                  run gera-erro(input "A").
                end.
           
           if   today > propost.dt-lim-desc-mens
           or   today > propost.dt-lim-desc-inscr
           then do: 
                   assign ds-mensagem-err-aux = "Proposta com data limite " +
                                                "de desconto da mensalidade/"  +
                                                "inscricao vencida".
                   run gera-erro(input "A").
                 end.
           */

           assign propost.dt-confirmacao        = today
                  propost.cd-userid-confirmacao = v_cod_usuar_corren
                  propost.dt-atualizacao        = today
                  propost.cd-userid             = v_cod_usuar_corren
                  propost.dt-parecer            = propost.dt-proposta
                  propost.cd-usuario-diretor    = v_cod_usuar_corren
                  propost.dt-aprovacao          = today.
           
           FOR FIRST b-contrat EXCLUSIVE-LOCK WHERE rowid(b-contrat) = ROWID(contrat):
                     assign b-contrat.dt-analise-credito = today
                            b-contrat.cd-userid-analise  = v_cod_usuar_corren
                            b-contrat.cd-sit-cred        = 1.
           END.
           
           if   paramecp.cd-mediocupa = modalid.cd-tipo-medicina
           THEN lg-medocup-aux = YES.
           ELSE lg-medocup-aux = NO.

           run liberar-documentos.
           IF lg-relat-erro-aux
           THEN NEXT.
           
         END.
    
    create sit-aprov-proposta.    
    assign sit-aprov-proposta.id-sit-aprov-proposta = next-value(seq-sit-aprov-proposta)
           sit-aprov-proposta.cd-modalidade         = propost.cd-modalidade
           sit-aprov-proposta.nr-proposta           = propost.nr-proposta
           sit-aprov-proposta.cd-userid             = v_cod_usuar_corren
           sit-aprov-proposta.dt-atualizacao        = today.

    CASE propost.cd-sit-proposta:
        WHEN 1 or /* DIGITACAO */
        WHEN 2 or /* CONFIRMADA */
        WHEN 85   /* SUSPENSA */ 
        THEN assign sit-aprov-proposta.in-situacao              = 2 /* EM CADASTRAMENTO */
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.

        WHEN 3 /* PENDENTE ANALISE DE CREDITO */
        then assign sit-aprov-proposta.in-situacao              = 9 /* PENDENTE ANALISE DE CREDITO */
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.

        WHEN 4 /* AGUARDANDO LIBERACAO */
        then assign sit-aprov-proposta.in-situacao              = 4 /* PENDENTE DE APROVACAO */
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.

        WHEN 5 or /* LIBERADA */
        WHEN 6 or /* TAXA INSCRICAO FATURADA  */
        WHEN 7    /* FATURAMENTO NORMAL */
        then assign sit-aprov-proposta.in-situacao              = 5 /* APROVADA */
                    sit-aprov-proposta.nm-aprovador             = propost.cd-userid-libera
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = propost.dt-libera-doc
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.

        WHEN 90   /* EXCLUIDA */ 
        then assign sit-aprov-proposta.in-situacao              = 90 /* Excluida */
                    sit-aprov-proposta.nm-aprovador             = propost.cd-userid-libera   
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = propost.dt-libera-doc      
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao       
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0. 

        WHEN 8 or /* REPROVADA */
        WHEN 95   /* CANCELADA */ 
        then assign sit-aprov-proposta.in-situacao              = 6 /* NEGADA */
                    sit-aprov-proposta.nm-aprovador             = propost.cd-userid-libera
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = propost.dt-libera-doc
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.

        WHEN  0 /* --- SE NAO ENTROU EM NENHUMA DAS SITUACOES ANTERIORES, SETA COMO "EM CADASTRAMENTO" --- */
        then assign sit-aprov-proposta.in-situacao              = 2
                    sit-aprov-proposta.nm-aprovador             = ""
                    sit-aprov-proposta.nm-cadastrador           = propost.cd-userid-digitacao
                    sit-aprov-proposta.dt-movimento-aprovador   = ?
                    sit-aprov-proposta.dt-movimento-cadastrador = propost.dt-digitacao
                    sit-aprov-proposta.cd-motivo-reprovacao     = 0.
    END CASE.

    assign propost.lg-proc-prestador = b-import-propost.log-proced-prestdor.
    
    if b-import-propost.log-segassist 
    then propost.dt-libera-doc = b-import-propost.dat-fim-segassist.
    
    /* REGRAS DE MENSALIDADE 
    
    DESCONTINUADO. SUBSTITUIDO PELO PROCESSO P_MIGRA_REGRA_PROPOSTA, NO PL/SQL
    IF  b-import-propost.num-livre-7 <> ? 
    AND b-import-propost.num-livre-7 <> 0
    THEN DO:
           FIND FIRST regra-menslid-propost
                WHERE regra-menslid-propost.cd-modalidade   = propost.cd-modalidade
                  AND regra-menslid-propost.nr-proposta     = propost.nr-proposta
                  AND regra-menslid-propost.cd-usuario      = 0
                  AND regra-menslid-propost.dt-ini-validade = b-import-propost.dat-propost
                  AND regra-menslid-propost.dt-fim-validade = 12/31/9999
                      NO-LOCK NO-ERROR.
          
           IF NOT AVAIL regra-menslid-propost        
           THEN DO:
                  CREATE regra-menslid-propost.
                  ASSIGN regra-menslid-propost.cdd-seq         = proximaseqregra()
                         regra-menslid-propost.cdd-regra       = b-import-propost.num-livre-7
                         regra-menslid-propost.cd-modalidade   = propost.cd-modalidade   
                         regra-menslid-propost.nr-proposta     = propost.nr-proposta 
                         regra-menslid-propost.cd-usuario      = 0
                         regra-menslid-propost.dt-ini-validade = b-import-propost.dat-propost 
                         regra-menslid-propost.dt-fim-validade = 12/31/9999
                         regra-menslid-propost.cod-usuar-ult-atualiz = v_cod_usuar_corren
                         regra-menslid-propost.dat-ult-atualiz = TODAY. 

                  ASSIGN propost.log-12 = YES. /*novas regras faturamento*/
                END.
         END.
    */

    /* --- USUARIO EVENTUAL ---------------------------------------------------- */
    if propost.log-11 
    AND propost.cd-sit-proposta >= 5
    AND propost.cd-sit-proposta <= 7
    then do:
           /************************************************************************************************
            *      Programa .....: hdrunpersis.i                                                            *
            *      Data .........: 12 de Junho de 2009                                                      *
            *      Sistema ......: HD - INCLUDES PADRAO                                                     *
            *      Empresa ......: Datasul Saude                                                            *  
            *      Programador ..: Alex Boeira                                                              *
            *      Objetivo .....: Persistir um programa, caso ainda nao possua instancia persistida        *
            ************************************************************************************************/
            
            /***
             O PROGRAMA CHAMADOR SEMPRE DEVERA POSSUIR:
               VARIAVEL "H-HANDLE-AUX" DO TIPO HANDLE;
               UMA VARIAVEL "H-" + NOME_PROGRAMA + "-AUX" PARA CADA PROGRAMA A SER PERSISTIDO;
               
             A DECLARACAO DESTE INCLUDE NOS FONTES DEVE SEGUIR O PADRAO:
               {HDP/HDRUNPERSIS.I "PROGRAMA.P" "HANDLE" "PARAMETROS"}
               
               onde:
               
               {1} = NOME DO PROGRAMA A SER PERSISTIDO;
               
               {2} = NOME DO HANDLE PARA CONTROLAR A PERSISTENCIA;
               
               {3} (OPCIONAL) = PARAMETROS A SEREM ENVIADOS PARA O PROGRAMA A SER PERSISTIDO;
               
             EXEMPLOS:
               {HDP/HDRUNPERSIS.I "API/API-USUARIO.P" "H-API-USUARIO-AUX"}
               {HDP/HDRUNPERSIS.I "BOSAU/BOSAUDEMOGRAPHIC.P" "H-BOSAUDEMOGRAPHIC-AUX"}
               {HDP/HDRUNPERSIS.I "PRGINT/UTB/UTB765ZL.PY" "H-UTB765ZL-AUX" "(INPUT 1, INPUT '', INPUT '')"}
            ***/
            
            h-handle-aux = session:last-procedure.
            do while valid-handle(h-handle-aux):
                
               if  h-handle-aux:type = "procedure"
               and h-handle-aux:name = "bosau/bosaueventualuser.p"
               then do:
            
                      if  id-requisicao-handle-aux  <> ""
                      and h-handle-aux:private-data  = id-requisicao-handle-aux
                      then do:
                             assign h-bosaueventualuser-aux = h-handle-aux.
                             leave.
                           end.
                    end.
                       
               assign h-handle-aux = h-handle-aux:prev-sibling.
            end.
            
            if not valid-handle(h-handle-aux) 
            then do:
                   run bosau/bosaueventualuser.p persistent set h-bosaueventualuser-aux .
            
                   /* --- SE ID-REQUISICAO-HANDLE-AUX ESTIVER EM BRANCOS, SIGNIFICA QUE Eh A PRIMEIRA PERSISTENCIA DA REQUISICAO.
                          O ID GERADO NESTE MOMENTO SERA UTILIZADO NAS DEMAIS PERSISTENCIAS, E SERA USADO AO FINAL
                          DO PROCESSO PARA ELIMINACAO DAS PERSISTENCIAS CARREGADAS, ATRAVES DA INCLUDE HDDELPERSIS.I --- */
                   
                       /** 
                              ALTERADO LÓGICA PARA GERAR O NÚMERO ALEATÓRIO QUE IDENTIFICA A SEÇÃO, JÁ QUE PODE GERAR ERRO CASO O 
                          A SEÇÃO DO USUÁRIO ESTEJA ABERTA A MUITO TEMPO 
                              FABRICIO CASALI
                        */
                       
                       if length (string (etime)) > 10
                              then etime (yes).        
                       
                       if id-requisicao-handle-aux = ""
                   then id-requisicao-handle-aux = string (etime) + string (random (1, 9999)).
            
                   h-bosaueventualuser-aux:private-data = id-requisicao-handle-aux.
            
            
            
            
            
                   /* --- LOG DE ACOMPANHAMENTO --- */
                   if search(session:temp-dir + "acompanhar_persistencias.txt") <> ?
                   then do:
                          run hdp/hdlogpersis.p(input "PERSISTINDO",
                                                input if program-name(20) <> ? then program-name(20) else "" + " | " +
                                                      if program-name(19) <> ? then program-name(19) else "" + " | " +
                                                      if program-name(18) <> ? then program-name(18) else "" + " | " +
                                                      if program-name(17) <> ? then program-name(17) else "" + " | " +
                                                      if program-name(16) <> ? then program-name(16) else "" + " | " +
                                                      if program-name(15) <> ? then program-name(15) else "" + " | " +
                                                      if program-name(14) <> ? then program-name(14) else "" + " | " +
                                                      if program-name(13) <> ? then program-name(13) else "" + " | " +
                                                      if program-name(12) <> ? then program-name(12) else "" + " | " +
                                                      if program-name(11) <> ? then program-name(11) else "" + " | " +
                                                      if program-name(10) <> ? then program-name(10) else "" + " | " +
                                                      if program-name(09) <> ? then program-name(09) else "" + " | " +
                                                      if program-name(08) <> ? then program-name(08) else "" + " | " +
                                                      if program-name(07) <> ? then program-name(07) else "" + " | " +
                                                      if program-name(06) <> ? then program-name(06) else "" + " | " +
                                                      if program-name(05) <> ? then program-name(05) else "" + " | " +
                                                      if program-name(04) <> ? then program-name(04) else "" + " | " +
                                                      if program-name(03) <> ? then program-name(03) else "" + " | " +
                                                      if program-name(02) <> ? then program-name(02) else "" + " | " +
                                                      if program-name(01) <> ? then program-name(01) else "" + " | ",
                                                input h-bosaueventualuser-aux:name,
                                                input h-bosaueventualuser-aux:private-data).
                        end.
            
                 end.

           run syncEventualUser in h-bosaueventualuser-aux(input propost.cd-modalidade,   
                                                           input propost.nr-proposta,     
                                                           input-output table rowErrors) no-error.
           
           if error-status:error 
           then run pi-grava-erro ("Nao foi possivel criar o Usuario Eventual").

           /*HDDELPERSIS.I*/
           if id-requisicao-handle-aux <> ""
           then do:
                  h-handle-aux = session:last-procedure.
                  do while valid-handle(h-handle-aux):

                     h-handle2-aux = h-handle-aux:prev-sibling.

                     if h-handle-aux:private-data = id-requisicao-handle-aux
                     then do:
                            /* --- LOG DE ACOMPANHAMENTO --- */
                            if search(session:temp-dir + "acompanhar_persistencias.txt") <> ?
                            then do:
                                   run hdp/hdlogpersis.p(input "DERRUBANDO",
                                                         input if program-name(20) <> ? then program-name(20) else "" + " | " +
                                                               if program-name(19) <> ? then program-name(19) else "" + " | " +
                                                               if program-name(18) <> ? then program-name(18) else "" + " | " +
                                                               if program-name(17) <> ? then program-name(17) else "" + " | " +
                                                               if program-name(16) <> ? then program-name(16) else "" + " | " +
                                                               if program-name(15) <> ? then program-name(15) else "" + " | " +
                                                               if program-name(14) <> ? then program-name(14) else "" + " | " +
                                                               if program-name(13) <> ? then program-name(13) else "" + " | " +
                                                               if program-name(12) <> ? then program-name(12) else "" + " | " +
                                                               if program-name(11) <> ? then program-name(11) else "" + " | " +
                                                               if program-name(10) <> ? then program-name(10) else "" + " | " +
                                                               if program-name(09) <> ? then program-name(09) else "" + " | " +
                                                               if program-name(08) <> ? then program-name(08) else "" + " | " +
                                                               if program-name(07) <> ? then program-name(07) else "" + " | " +
                                                               if program-name(06) <> ? then program-name(06) else "" + " | " +
                                                               if program-name(05) <> ? then program-name(05) else "" + " | " +
                                                               if program-name(04) <> ? then program-name(04) else "" + " | " +
                                                               if program-name(03) <> ? then program-name(03) else "" + " | " +
                                                               if program-name(02) <> ? then program-name(02) else "" + " | " +
                                                               if program-name(01) <> ? then program-name(01) else "" + " | ",
                                                         input h-handle-aux:name,
                                                         input h-handle-aux:private-data).
                                 end.

                            delete procedure h-handle-aux.

                          end.

                     assign h-handle-aux = h-handle2-aux.

                  end.
                end.

           assign id-requisicao-handle-aux = "".

           /*FIM DE HDDELPERSIS.I*/

         end.

    assign b-import-propost.cod-livre-6 = string(propost.nr-proposta).

    VALIDATE propost.
    
END PROCEDURE.

procedure liberar-documentos:
   DEF VAR dt-inicio-aux        AS DATE NO-UNDO.
   DEF VAR lg-erro-rtclvenc-aux AS LOG NO-UNDO.
   DEF VAR ds-erro-rtclvenc-aux AS CHAR NO-UNDO.
   DEF VAR dt-fim-aux           AS DATE NO-UNDO.
   DEF VAR dt-validade-aux      AS DATE NO-UNDO.

   def var lg-erro-gera-aux  AS LOG NO-UNDO.
   def var ds-erro-gera-aux  AS CHAR NO-UNDO.
   def var ds-chave-gera-aux AS CHAR NO-UNDO.
   DEF VAR qt-executada-aux  AS INT NO-UNDO.

   create ter-ade.
   ASSIGN ter-ade.cd-modalidade         = propost.cd-modalidade
          ter-ade.nr-ter-adesao         = propost.nr-ter-adesao.
 
   if   propost.dt-libera-doc <> ?
   then do:
           if   propost.dt-libera-doc < today
           then do:
                  assign propost.cd-sit-proposta  = 90   
                         ter-ade.cd-sit-adesao    = 90
                         ter-ade.cd-motivo-cancel = 90.
                end.
           else do:
                  run verifica-sit-prop.
                  ter-ade.cd-sit-adesao    = 1.
                end.
 
           assign ter-ade.dt-mov-exclusao       =  today
                  ter-ade.cd-userid-exclusao    =  v_cod_usuar_corren
                  ter-ade.dt-cancelamento       =  propost.dt-libera-doc.
        end.
   else do:
          run verifica-sit-prop.
          assign  ter-ade.cd-sit-adesao    = 1.
        end.
 
   assign propost.cd-userid-libera      = v_cod_usuar_corren.
 
   /*&&&& checar unicidade de nr-ter-adesao, se precisar trocar, ajustar tb na proposta!*/
   
   assign ter-ade.cd-userid             = v_cod_usuar_corren
          ter-ade.dt-aprovacao          = today
          ter-ade.dt-atualizacao        = today
          ter-ade.dt-mov-inclusao       = today
          ter-ade.cd-userid-inclusao    = v_cod_usuar_corren
          ter-ade.cd-classe-mens        = for-pag.cd-classe-mens
          ter-ade.aa-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,03,04))
          ter-ade.mm-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,01,02))
          ter-ade.dt-inicio             = propost.dt-parecer
          ter-ade.lg-mantem-senha-benef = YES /*&&&& checar se precisa virar parametro */
          ter-ade.in-gera-senha         = 0   /*&&&& checar se precisa virar parametro */
          ter-ade.log-5                 = NO /*Cobrar reajuste retroativo parcelado*/.

   /* faturamento proporcional */
   IF AVAIL ti-pl-sa
   THEN ASSIGN ter-ade.log-2          = ti-pl-sa.log-2.
   ELSE ASSIGN ter-ade.log-2          = NO /* faturamento proporcional */.
 
   if   propost.cd-sit-proposta = 5 
   or   ter-ade.dt-inicio       = ter-ade.dt-cancelamento
   then assign ter-ade.aa-pri-fat = 0
               ter-ade.mm-pri-fat = 0.
   else assign ter-ade.aa-pri-fat = year(ter-ade.dt-inicio)
               ter-ade.mm-pri-fat = month(ter-ade.dt-inicio).

   if propost.cd-contrat-origem <> 0
   then assign ter-ade.in-contratante-mensalidade  = 1
               ter-ade.in-contratante-participacao = 1
               ter-ade.in-contratante-custo-op     = 1
               ter-ade.in-contratante-inadim       = 1.
   else assign ter-ade.in-contratante-mensalidade  = 0
               ter-ade.in-contratante-participacao = 0
               ter-ade.in-contratante-custo-op     = 0
               ter-ade.in-contratante-inadim       = 0.

   /* se nivel de reajuste da proposta for por contrato, cria historico */

   if propost.int-13 = 0
   then do:
          /* Historico de tabelas de preco da proposta */
          RUN escrever-log("@@@@@VERIFICAR SE HISTABPRECO JA EXISTE - MODALIDADE: " + STRING(propost.cd-modalidade) 
                           + " PROPOSTA: " + string(propost.nr-proposta) + " ANO: " + STRING(year(ter-ade.dt-inicio))
                           + " MES: " + STRING(month(ter-ade.dt-inicio))).
          FIND FIRST histabpreco EXCLUSIVE-LOCK
               WHERE histabpreco.cd-modalidade = propost.cd-modalidade   
                 AND histabpreco.nr-proposta   = propost.nr-proposta     
                 AND histabpreco.aa-reajuste   = year(ter-ade.dt-inicio) 
                 AND histabpreco.mm-reajuste   = month(ter-ade.dt-inicio) NO-ERROR.

          RUN escrever-log("@@@@@ACHOU HISTABPRECO COM A MESMA CHAVE?: " + STRING(AVAIL histabpreco)).

          IF NOT AVAIL histabpreco
          THEN do:
                 create histabpreco.
                 ASSIGN histabpreco.cd-modalidade = propost.cd-modalidade   
                        histabpreco.nr-proposta   = propost.nr-proposta     
                        histabpreco.aa-reajuste   = year(ter-ade.dt-inicio) 
                        histabpreco.mm-reajuste   = month(ter-ade.dt-inicio).
               END.

          assign histabpreco.cd-tab-preco         = propost.cd-tab-preco
                 histabpreco.log-1                = YES /*parafatu.log-12 - Utilizar Historico da Tab.Preco para Reajustar a Mensalidade - forcando sim para habilitar processo reajuste*/ 
                 histabpreco.cd-userid            = v_cod_usuar_corren    
                 histabpreco.dt-atualizacao       = today.
         
          /**
           * 23/11/16 - Alex Boeira - logica comentada, pois o historico completo de reajuste eh 
           * carregado na procedure P_POS_CARGA (PL/SQL), que eh executada apos concluir a criacao de propostas e beneficiarios.
           
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
                        histabpreco.log-1              = YES /*parafatu.log-12*/
                        histabpreco.cd-userid          = v_cod_usuar_corren
                        histabpreco.dt-atualizacao     = today.
               end.*/
        end.
 
   /* ---------------------------------------------------------------------- */
   if   contrat.lg-mantem-senha-termo
   then assign ter-ade.cd-senha = contrat.cd-senha.
   else do:
          run rtp/rtrandom.p (input 6,
                              output cd-senha-aux,
                              output lg-erro-rtsenha-aux,
                              output ds-erro-rtsenha-aux).
          if lg-erro-rtsenha-aux 
          then do:
                 run pi-grava-erro (ds-erro-rtsenha-aux).
                 lg-relat-erro-aux = YES.
               end.
          
          assign ter-ade.cd-senha = cd-senha-aux.    
        end.

   /* ---------------------------------------------------------------------- */
   assign propost.dt-comercializacao = ter-ade.dt-inicio
          ter-ade.dt-fim             = ter-ade.dt-inicio
          dt-inicio-aux              = ter-ade.dt-inicio.
 
   /**
    * Tratamento para gravar o codigo da Empresa na Unimed (padrao do Unicoo)
    */
   FIND FIRST gerac-cod-ident-propost EXCLUSIVE-LOCK
        WHERE gerac-cod-ident-propost.cdn-modalid = propost.cd-modalidade
          AND gerac-cod-ident-propost.num-propost = propost.nr-proposta NO-ERROR.
   IF NOT AVAIL gerac-cod-ident-propost
   THEN DO:
          create gerac-cod-ident-propost.
          assign gerac-cod-ident-propost.cdn-modalid  = propost.cd-modalidade
                 gerac-cod-ident-propost.num-propost  = propost.nr-proposta.
   END.

   ASSIGN gerac-cod-ident-propost.cdn-ident-empres    = b-import-propost.num-livre-3 /*NRCONTRATO DO UNICOO*/
          gerac-cod-ident-propost.cd-contratante      = 0 /* sempre zero */
          gerac-cod-ident-propost.nr-insc-contratante = propost.nr-insc-contratante.

   VALIDATE gerac-cod-ident-propost.
   RELEASE gerac-cod-ident-propost.

   /* ---- Inicializa Quantidade de vezes que o Laco vai ser Executado. ---- */
   assign qt-executada-aux = 0.

   /**
    * Este validate eh necessario para que a proposta esteja visivel dentro de rtclvenc.p qdo
    * executando em ambiente Oracle.
    */
   VALIDATE propost.

   /* ---------------------------------------------------------------------- */
   do while ter-ade.dt-fim < dt-minima-termo-aux:
 
      /* ---------------------------------- CALCULA DATA DE FIM DO TERMO --- */
      run rtp/rtclvenc.p (input "termo",
                          input dt-inicio-aux,
                          input propost.cd-modalidade,
                          input propost.nr-proposta,
                          input no,                       
                          output ter-ade.dt-fim,
                          output lg-erro-rtclvenc-aux,
                          output ds-erro-rtclvenc-aux).
      if   lg-erro-rtclvenc-aux
      then do:
             run pi-grava-erro (ds-erro-rtclvenc-aux).
             lg-relat-erro-aux = YES.
          end.

      assign dt-inicio-aux    = ter-ade.dt-fim
             qt-executada-aux = qt-executada-aux + 1.
   end.
 
   /* ---------------------- Atualiza a data fim do termo de ades’o -------- */
   if   qt-executada-aux <> 0
   then assign ter-ade.dt-fim = ter-ade.dt-fim + qt-executada-aux - 1.

   /* ---------------------------------------------------------------------- */
   assign dt-fim-aux = ter-ade.dt-fim.

   /* --------------------------------- TESTAR PROPOSTA CANCELADA OU PEA --- */
   if   propost.dt-libera-doc <> ?
   then assign ter-ade.dt-fim  = propost.dt-libera-doc.
   else assign ter-ade.dt-fim  = dt-fim-aux.
 
   /* ---------------------------------------------------------------------- */
   assign dt-inicio-aux            = ter-ade.dt-inicio
          ter-ade.dt-validade-cart = ter-ade.dt-inicio.
 
   /* ---- Inicializa Quantidade de vezes que o Laco vai ser Executado. ---- */
   assign qt-executada-aux = 0.

   /* ---------------------------------------------------------------------- */
   do while ter-ade.dt-validade-cart < dt-minima-termo-aux:
 
      /* --------------------------------- CALCULA DATA DE FIM DO CARTAO --- */
      if   propost.lg-cartao
      then do:
              run rtp/rtclvenc.p (input "cartao",
                                  input dt-inicio-aux,
                                  input propost.cd-modalidade,
                                  input propost.nr-proposta,
                                  input no,                       
                                  output ter-ade.dt-validade-cart,
                                  output lg-erro-rtclvenc-aux,
                                  output ds-erro-rtclvenc-aux).
              if   lg-erro-rtclvenc-aux
              then do:
                     run pi-grava-erro (ds-erro-rtclvenc-aux).
                     lg-relat-erro-aux = YES.
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
                                  output lg-erro-rtclvenc-aux,
                                  output ds-erro-rtclvenc-aux).

              if lg-erro-rtclvenc-aux
              then do:
                     run pi-grava-erro (ds-erro-rtclvenc-aux).
                     lg-relat-erro-aux = YES.
                   end.
           end.
    
      assign dt-inicio-aux    = ter-ade.dt-validade-cart
             qt-executada-aux = qt-executada-aux + 1.
   end.
 
   /* ---------------------- Atualiza a data fim do termo de ades’o -------- */
   if   qt-executada-aux <> 0
   then assign ter-ade.dt-validade-cart = ter-ade.dt-validade-cart
                                        + qt-executada-aux - 1.

   assign dt-fim-aux = ter-ade.dt-validade-cart.
 
   /* --------------------------------- TESTAR PROPOSTA CANCELADA OU PEA --- */
   if   propost.dt-libera-doc <> ?
   then assign ter-ade.dt-validade-cart = propost.dt-libera-doc.
   else assign ter-ade.dt-validade-cart = dt-fim-aux.

   /* -------------- RETORNA A DATA DE FIM DE VALIDADE DO CARTAO/CARTEIRA ---*/
   if   paravpmc.in-validade-cart = "2"
   then do:
          run rtp/rtultdia.p (input  year (ter-ade.dt-validade-cart),
                              input  month(ter-ade.dt-validade-cart),
                              output dt-validade-aux).

          assign ter-ade.dt-validade-cart = dt-validade-aux.
        end.      

   assign propost.mm-aa-ult-fat-mig  = "".
          /*propost.dt-libera-doc      = today.*/

   /* Se PROPOST.DATE-1 estiver preenchido, indica que deve utilizar data de validade do CONTRATO_DA_PESSOA*/
   IF propost.date-1 <> ?
   THEN ter-ade.dt-validade-cart = propost.date-1.
   
   /* -------------------------------------------------------- AFERICAO --- */
   if   modalid.pc-afericao = 0
   then do:
          if   propost.nr-pessoas-titulares   <> 0 
          or   propost.nr-pessoas-dependentes <> 0
          then do:
                 assign propost.nr-pessoas-titulares   = 0
                        propost.nr-pessoas-dependentes = 0.
                 
                 for each pr-id-us where 
                          pr-id-us.cd-modalidade = propost.cd-modalidade
                      and pr-id-us.nr-proposta   = propost.nr-proposta
                          exclusive-lock:

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
                                    output lg-erro-gera-aux,
                                    output ds-erro-gera-aux,
                                    output ds-chave-gera-aux).

                 if   lg-erro-gera-aux
                 then do:
                        run pi-grava-erro (ds-erro-gera-aux + " " + ds-chave-gera-aux).
                        lg-relat-erro-aux = YES.
                      end.
               end.
        end.

   return "".
   
end procedure.

procedure verifica-sit-prop:
 
   if  int(substring( propost.mm-aa-ult-fat-mig,03,04)) = 0 and
       int(substring( propost.mm-aa-ult-fat-mig,01,02)) = 0
   then propost.cd-sit-proposta = 5.    
   else do:
          if  int(substring( propost.mm-aa-ult-fat-mig,03,04)) =
              year(propost.dt-parecer) and
              int(substring( propost.mm-aa-ult-fat-mig,01,02)) =
              month(propost.dt-parecer)
          then propost.cd-sit-proposta = 6.
          else propost.cd-sit-proposta = 7.
        end.
 
end procedure.

PROCEDURE cria-modulos:

    def var cd-sit-modulo-aux AS INT NO-UNDO.
    def var dt-fim-aux        as date no-undo.
    def var dt-inicio-aux     as date no-undo.

    RUN escrever-log("@@@@@CRIA-MODULOS P1 - MODALIDADE: " + STRING(b-import-propost.cd-modalidade) + " PROPOSTA: " + string(nr-proposta-aux)).

    FOR EACH pro-pla EXCLUSIVE-LOCK
       WHERE pro-pla.cd-modalidade = b-import-propost.cd-modalidade
         AND pro-pla.nr-proposta   = nr-proposta-aux 
         AND NOT CAN-FIND (FIRST import-modul-propost
                         where import-modul-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost
                             AND import-modul-propost.cd-modulo           = pro-pla.cd-modulo NO-LOCK):

               RUN escrever-log("@@@@@CRIA-MODULOS P2 - APAGANDO PRO-PLA").
               DELETE pro-pla.
    END.

    ASSIGN lg-relat-erro = NO.

    RUN escrever-log("@@@@@CRIA-MODULOS P3 - ANTES DE LER IMPORT-MODUL-PROPOST").

    FOR EACH import-modul-propost FIELDS (cd-modulo 
                                          cd-forma-pagto 
                                          in-cobra-participacao 
                                          ind-respons-autoriz 
                                          nr-dias 
                                          log-bonif-penalid 
                                          in-ctrl-carencia-proced 
                                          qt-caren-eletiva 
                                          qt-caren-urgencia 
                                          log-carenc 
                                          dat-inicial 
                                          dat-cancel 
                                          cd-motivo-cancel 
                                          ind-respons-autoriz 
                                          in-cobra-participacao 
                                          in-ctrl-carencia-insumo)
       WHERE import-modul-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

        /*------------------------------------------------------------------------*/
        for first pla-mod fields (cd-modulo 
                                  lg-obrigatorio 
                                  in-cobra-participacao 
                                  in-responsavel-autorizacao 
                                  qt-caren-eletiva 
                                  qt-caren-urgencia)
            where pla-mod.cd-modalidade = b-import-propost.cd-modalidade
              and pla-mod.cd-plano      = b-import-propost.cd-plano
              and pla-mod.cd-tipo-plano = b-import-propost.cd-tipo-plano
              and pla-mod.cd-modulo     = import-modul-propost.cd-modulo NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
        end.
        IF NOT AVAIL pla-mod
        THEN do:
               RUN escrever-log("@@@@@CRIA-MODULOS - ERRO NAO ACHOU PLA-MOD").
               assign lg-relat-erro = yes.
               run pi-grava-erro ("Modulo " + string(import-modul-propost.cd-modulo,"999") 
                                  + " nao encontrado para Modalidade " + string(b-import-propost.cd-modalidade)
                                  + ", Plano " + STRING(b-import-propost.cd-plano)
                                  + ", Tipo Plano " + STRING(b-import-propost.cd-tipo-plano)).
               NEXT.
             END.
        RUN escrever-log("@@@@@CRIA-MODULOS P4 - ACHOU PLA-MOD " + STRING(import-modul-propost.cd-modulo) + ": " + STRING(AVAIL pla-mod)).

        for each pro-pla FIELDS (dt-cancelamento 
                                 dt-inicio) use-index pro-pla3
           where pro-pla.cd-modalidade = b-import-propost.cd-modalidade
             and pro-pla.nr-proposta   = nr-proposta-aux
             and pro-pla.cd-modulo     = import-modul-propost.cd-modulo
                 no-lock:

            if  pro-pla.dt-cancelamento = ? 
            then do:
                   if import-modul-propost.dat-cancel = ?
                   then do:
                          RUN escrever-log("@@@@@CRIA-MODULOS P5").
                          assign lg-relat-erro = yes.
                          run pi-grava-erro ("Modulo ja cadastrado para a proposta: " + string(import-modul-propost.cd-modulo,"999")).
                        END.
                   ELSE if import-modul-propost.dat-cancel >= pro-pla.dt-inicio
                        then do:
                               RUN escrever-log("@@@@@CRIA-MODULOS P6").
                               assign lg-relat-erro = yes.
                               run pi-grava-erro ("Data de cancel. nao pode ser superior a data de inicio do mod. ja cadast. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                             END.
                            
                   if import-modul-propost.dat-inicial >= pro-pla.dt-inicio
                   then do:
                          RUN escrever-log("@@@@@CRIA-MODULOS P7").
                          assign lg-relat-erro = yes.
                          run pi-grava-erro ("Data de inicio nao pode ser superior a data de inicio do mod. ja cadast. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                        END.
                 end.
            else do:
                   RUN escrever-log("@@@@@CRIA-MODULOS P8").
                   if  import-modul-propost.dat-inicial >= pro-pla.dt-inicio             
                   and import-modul-propost.dat-inicial <= pro-pla.dt-cancelamento
                   then DO:
                          RUN escrever-log("@@@@@CRIA-MODULOS P9").
                          assign lg-relat-erro = yes.
                          run pi-grava-erro ("Data de vigencia do modulo nao pode sobrepor a de um mesmo modulo cadastrado. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                        END.

                   if  import-modul-propost.dat-cancel >= pro-pla.dt-inicio             
                   and import-modul-propost.dat-cancel <= pro-pla.dt-cancelamento
                   then do:
                          RUN escrever-log("@@@@@CRIA-MODULOS P10").
                          assign lg-relat-erro = yes. 
                          run pi-grava-erro ("Data de vigencia do modulo nao pode sobrepor a de um mesmo modulo cadastrado. Mod:" + string(import-modul-propost.cd-modulo,"999")).
                        END.
                 end. 
        end.

        RUN escrever-log("@@@@@CRIA-MODULOS P11").

        IF lg-relat-erro 
        THEN do:
               RUN escrever-log("@@@@@CRIA-MODULOS P12 - SAINDO COM ERRO").
               ASSIGN lg-relat-erro-aux = YES.
               NEXT.
             END.

        find mod-cob where mod-cob.cd-modulo = import-modul-propost.cd-modulo no-lock no-error.
        
        RUN escrever-log("@@@@@CRIA-MODULOS P13 - ACHOU MOD-COB " + STRING(import-modul-propost.cd-modulo) + " " + STRING(AVAIL mod-cob)).

        IF lg-gerar-termo-aux
        AND AVAIL ter-ade
        THEN DO:
               /* -------- TESTAR PROPOSTA CANCELADA OU PEA ---------- */
               if   propost.dt-libera-doc <> ?
               then do:
                       if   propost.dt-libera-doc < today
                       then assign cd-sit-modulo-aux = 90.
                       else assign cd-sit-modulo-aux = 7.
               
                       RUN escrever-log("@@@@@CRIA-MODULOS P14").
                       assign dt-fim-aux = propost.dt-libera-doc.
                    end.
               else do:
                      if   import-modul-propost.dat-cancel = ?
                      then assign cd-sit-modulo-aux = 7
                                  dt-fim-aux        = ter-ade.dt-fim.
                      else do:
                             if   import-modul-propost.dat-cancel < today
                             then assign cd-sit-modulo-aux = 90.
                             else assign cd-sit-modulo-aux = 7.
               
                             RUN escrever-log("@@@@@CRIA-MODULOS P15").
                             assign dt-fim-aux = ter-ade.dt-fim.
                           end.
                    end.
               
               if   import-modul-propost.dat-inicial <> ?
               THEN assign dt-inicio-aux = import-modul-propost.dat-inicial.
               ELSE assign dt-inicio-aux = ter-ade.dt-inicio.
             END.
        ELSE DO:
               ASSIGN cd-sit-modulo-aux = 1
                      dt-fim-aux        = b-import-propost.dat-fim-propost
                      dt-inicio-aux     = import-modul-propost.dat-inicial.
               RUN escrever-log("@@@@@CRIA-MODULOS P16").
             END.

        RUN escrever-log("@@@@@CRIA-MODULOS P17").

        if   not pla-mod.lg-obrigatorio
        THEN DO:
               if in-classif = 2
               OR in-classif = 3
               then do:
                      RUN escrever-log("@@@@@CRIA-MODULOS P18 - CRIANDO PRO-PLA - PLA-MOD OPCIONAL").

                      create pro-pla.
                      assign pro-pla.cd-modalidade              = b-import-propost.cd-modalidade
                             pro-pla.cd-plano                   = b-import-propost.cd-plano
                             pro-pla.cd-tipo-plano              = b-import-propost.cd-tipo-plano
                             pro-pla.cd-modulo                  = import-modul-propost.cd-modulo
                             pro-pla.nr-proposta                = nr-proposta-aux
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
                             pro-pla.dt-inicio                = dt-inicio-aux
                             pro-pla.dt-cancelamento          = import-modul-propost.dat-cancel
                             pro-pla.cd-motivo-cancel         = import-modul-propost.cd-motivo-cancel
                             pro-pla.dt-fim                   = dt-fim-aux
                             pro-pla.cd-sit-modulo            = cd-sit-modulo-aux.
                      
                      if   import-modul-propost.dat-cancel <> ?
                      then assign pro-pla.dt-mov-exclusao    = today
                                  pro-pla.cd-userid-exclusao = v_cod_usuar_corren.

                      RUN escrever-log("@@@@@CRIA-MODULOS P19 - FIM DA CRIACAO PRO-PLA").
                    end. 
             END.
        ELSE IF in-classif = 1
             or in-classif = 3 
             THEN DO:
                    if   b-import-propost.cd-forma-pagto = 1
                    or   b-import-propost.cd-forma-pagto = 2
                    then do: 

                           RUN escrever-log("@@@@@CRIA-MODULOS P20 - CREATE PRO-PLA - PLA-MOD OBRIGATORIO").

                           create pro-pla.
                           assign pro-pla.cd-modalidade           = b-import-propost.cd-modalidade
                                  pro-pla.cd-plano                = b-import-propost.cd-plano
                                  pro-pla.cd-tipo-plano           = b-import-propost.cd-tipo-plano
                                  pro-pla.cd-modulo               = pla-mod.cd-modulo
                                  pro-pla.nr-proposta             = nr-proposta-aux
                                  pro-pla.cd-forma-pagto          = b-import-propost.cd-forma-pagto
                                  pro-pla.lg-carencia             = yes
                                  pro-pla.lg-cobertura-obrigato   = yes
                                  pro-pla.in-ctrl-carencia-proced = import-modul-propost.in-ctrl-carencia-proced
                                  pro-pla.in-ctrl-carencia-insumo = import-modul-propost.in-ctrl-carencia-insumo
                                  pro-pla.dt-inicio               = dt-inicio-aux
                                  pro-pla.dt-cancelamento         = import-modul-propost.dat-cancel
                                  pro-pla.dt-fim                  = dt-fim-aux
                                  pro-pla.in-cobra-participacao   = import-modul-propost.in-cobra-participacao
                                  pro-pla.in-responsavel-autori   = import-modul-propost.ind-respons-autoriz
                                  pro-pla.dt-atualizacao          = today
                                  pro-pla.cd-userid               = v_cod_usuar_corren
                                  pro-pla.dt-mov-inclusao         = today
                                  pro-pla.cd-userid-inclusao      = v_cod_usuar_corren
                                  pro-pla.cd-sit-modulo            = cd-sit-modulo-aux.
                           
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

                           RUN escrever-log("@@@@@CRIA-MODULOS P21 - FIM DE CREATE PRO-PLA").
                         END.

                    if   b-import-propost.cd-forma-pagto = 3
                    then do:
                           RUN escrever-log("@@@@@CRIA-MODULOS P22 - FIND PLAMOFOR").
                           find plamofor where plamofor.cd-modalidade = b-import-propost.cd-modalidade
                                           and plamofor.cd-plano      = b-import-propost.cd-plano
                                           and plamofor.cd-tipo-plano = b-import-propost.cd-tipo-plano
                                           and plamofor.cd-modulo     = pla-mod.cd-modulo
                                               no-lock no-error.
                           if avail plamofor
                           THEN DO:
                                  RUN escrever-log("@@@@@CRIA-MODULOS P23 - PLAMOFOR").
                                  create pro-pla.
                                  assign pro-pla.cd-modalidade            = b-import-propost.cd-modalidade
                                         pro-pla.cd-plano                 = b-import-propost.cd-plano
                                         pro-pla.cd-tipo-plano            = b-import-propost.cd-tipo-plano
                                         pro-pla.cd-modulo                = plamofor.cd-modulo
                                         pro-pla.nr-proposta              = nr-proposta-aux
                                         pro-pla.cd-forma-pagto           = plamofor.cd-forma-pagto
                                         pro-pla.lg-carencia              = yes
                                         pro-pla.lg-cobertura-obrigatoria = yes
                                         pro-pla.in-ctrl-carencia-proced  = import-modul-propost.in-ctrl-carencia-proced
                                         pro-pla.in-ctrl-carencia-insumo  = import-modul-propost.in-ctrl-carencia-insumo
                                         pro-pla.qt-caren-eletiva         = import-modul-propost.qt-caren-eletiva 
                                         pro-pla.qt-caren-urgencia        = import-modul-propost.qt-caren-urgencia
                                         pro-pla.in-cobra-participacao    = import-modul-propost.in-cobra-participacao
                                         pro-pla.in-responsavel-autori    = import-modul-propost.ind-respons-autoriz  
                                         pro-pla.dt-inicio                = dt-inicio-aux
                                         pro-pla.dt-cancelamento          = import-modul-propost.dat-cancel
                                         pro-pla.dt-fim                   = dt-fim-aux
                                         pro-pla.dt-atualizacao           = today
                                         pro-pla.cd-userid                = v_cod_usuar_corren
                                         pro-pla.dt-mov-inclusao          = today
                                         pro-pla.cd-userid-inclusao       = v_cod_usuar_corren
                                         pro-pla.cd-sit-modulo            = cd-sit-modulo-aux.
                                  
                                   if   b-import-propost.dat-fim-propost = ?
                                   then.
                                   else assign pro-pla.dt-mov-exclusao    = today
                                               pro-pla.cd-userid-exclusao = v_cod_usuar_corren. 
                                   RUN escrever-log("@@@@@CRIA-MODULOS P24 - FIM CREATE PRO-PLA DA PLAMOFOR").
                                END.
                         END.
             END.          
    END. /*import-modul-propost*/

    /**
     * GARANTIR QUE CRIOU TODOS OS PRO-PLA NECESSARIOS.
     */
    FOR FIRST import-modul-propost NO-LOCK
        where import-modul-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost
          AND NOT CAN-FIND(FIRST pro-pla
                           WHERE pro-pla.cd-modalidade = b-import-propost.cd-modalidade
                             AND pro-pla.nr-proposta   = nr-proposta-aux 
                             AND pro-pla.cd-modulo     = import-modul-propost.cd-modulo):

              RUN escrever-log("@@@@@CRIA-MODULOS P26 - NAO CRIOU PRO-PLA!!!").
              assign lg-relat-erro = yes. 
              run pi-grava-erro ("Nao conseguiu criar PRO-PLA: " + string(import-modul-propost.cd-modulo,"999") 
                                 + " Modalidade: " + STRING(b-import-propost.cd-modalidade)
                                 + " Proposta: "   + STRING(nr-proposta-aux)).
    END.

    /**
     * GARANTIR QUE A PROPOSTA TEM TODOS OS MODULOS DOS BENEFICIARIOS.
     
    FOR FIRST import-modul-bnfciar
        WHERE import-modul-bnfciar.
        
        
        
        import-modul-propost NO-LOCK
        where import-modul-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost
          AND NOT CAN-FIND(FIRST pro-pla
                           WHERE pro-pla.cd-modalidade = b-import-propost.cd-modalidade
                             AND pro-pla.nr-proposta   = nr-proposta-aux 
                             AND pro-pla.cd-modulo     = import-modul-propost.cd-modulo):

              RUN escrever-log("@@@@@CRIA-MODULOS P26 - NAO CRIOU PRO-PLA!!!").
              assign lg-relat-erro = yes. 
              run pi-grava-erro ("Nao conseguiu criar PRO-PLA: " + string(import-modul-propost.cd-modulo,"999") 
                                 + " Modalidade: " + STRING(b-import-propost.cd-modalidade)
                                 + " Proposta: "   + STRING(nr-proposta-aux)).
    END.
    */

    RUN escrever-log("@@@@@CRIA-MODULOS P25 - SAINDO DE CRIA-MODULOS").

    IF lg-relat-erro 
    THEN do:
           RUN escrever-log("@@@@@CRIA-MODULOS P30 - SAINDO COM ERRO").
           ASSIGN lg-relat-erro-aux = YES.
           NEXT.
         END.

END PROCEDURE.

PROCEDURE cria-lotacao:

    IF b-import-propost.in-tipo-natureza = 3 /* EMPRESARIAL */
    THEN 
            FOR EACH import-lotac-propost FIELDS (cdn-lotac
                                                  cdn-respons-financ
                                                  num-livre-3
                                                  dat-livre-1
                                                  dat-livre-2
                                                  log-livre-1
                                                  log-livre-2)
               WHERE import-lotac-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost 
                 AND import-lotac-propost.cdn-lotac <> 0 NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

                CREATE lotac-propost.
                ASSIGN lotac-propost.cdn-modalid        = b-import-propost.cd-modalidade
                       lotac-propost.num-propost        = nr-proposta-aux
                       lotac-propost.cdn-lotac          = import-lotac-propost.cdn-lotac
                       lotac-propost.cdn-respons-financ = import-lotac-propost.cdn-respons-financ
                       lotac-propost.dat-livre-1        = import-lotac-propost.dat-livre-1 /*INICIO LOTACAO NA PROPOSTA*/
                       lotac-propost.dat-livre-2        = import-lotac-propost.dat-livre-2 /*FIM LOTACAO NA PROPOSTA*/
                       lotac-propost.log-livre-1        = import-lotac-propost.log-livre-1 /*UTILIZA NOME DA LOTACAO NO DOCUMENTO DE IDENTIFICACAO?*/
                       .
                       
                IF  lotac-propost.cdn-respons-financ <> ?
                AND lotac-propost.cdn-respons-financ <> 0
                THEN assign lotac-propost.log-livre-2 = YES /* fatura lotacao?*/
                            lotac-propost.num-livre-1 = import-lotac-propost.num-livre-3. /*NRDIA_DE_VENCIMENTO*/
                ELSE assign lotac-propost.log-livre-2 = NO
                            lotac-propost.num-livre-1 = 0. /*NRDIA_DE_VENCIMENTO*/
            END.

END PROCEDURE.

PROCEDURE cria-faixas:

    ASSIGN lg-relat-erro-aux = NO.

    FOR EACH import-faixa-propost FIELDS (cd-grau-parentesco nr-faixa-etaria num-idade-min num-idade-max qtd-fator-multiplic qtd-fator-multiplic-inscr)
       WHERE import-faixa-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

        IF lg-relat-erro
        THEN LEAVE.

        FOR FIRST teadgrpa FIELDS (nr-faixa-etaria)
            where teadgrpa.cd-modalidade      = b-import-propost.cd-modalidade
              and teadgrpa.nr-proposta        = nr-proposta-aux
              and teadgrpa.cd-grau-parentesco = import-faixa-propost.cd-grau-parentesco
              and teadgrpa.nr-faixa-etaria   <> import-faixa-propost.nr-faixa-etaria 
              AND teadgrpa.nr-idade-minima   <= import-faixa-propost.num-idade-max 
              AND teadgrpa.nr-idade-maxima   >= import-faixa-propost.num-idade-min NO-LOCK:
              
            run pi-grava-erro2 ("Essa proposta ja possui Faixa Etaria Especial (TEADGRPA) conflitante com a que esta sendo importada para esse Grau de Parentesco.",
                                "Grau Parentesco: " + string(import-faixa-propost.cd-grau-parentesco,"99") + 
                                " IMPORTANDO - Faixa: "       + string(import-faixa-propost.nr-faixa-etaria,"99")      + 
                                " Idade min: "   + string(import-faixa-propost.num-idade-min) +
                                " Idade max: "   + string(import-faixa-propost.num-idade-max) +
                                " JA EXISTE - Faixa: "       + string(teadgrpa.nr-faixa-etaria,"99")      + 
                                " Idade min: "   + string(teadgrpa.nr-idade-minima) +
                                " Idade max: "   + string(teadgrpa.nr-idade-maxima)).
                                
            assign lg-relat-erro = yes.
        END.

        IF lg-relat-erro 
        THEN do:
               ASSIGN lg-relat-erro-aux = YES.
               LEAVE.
             END.

        IF NOT CAN-FIND (first teadgrpa 
                         where teadgrpa.cd-modalidade      = b-import-propost.cd-modalidade
                           and teadgrpa.nr-proposta        = nr-proposta-aux
                           and teadgrpa.cd-grau-parentesco = import-faixa-propost.cd-grau-parentesco
                           and teadgrpa.nr-faixa-etaria    = import-faixa-propost.nr-faixa-etaria)
        THEN do:
               create teadgrpa.
               assign teadgrpa.cd-modalidade          = b-import-propost.cd-modalidade
                      teadgrpa.nr-proposta            = nr-proposta-aux
                      teadgrpa.cd-grau-parentesco     = import-faixa-propost.cd-grau-parentesco
                      teadgrpa.nr-faixa-etaria        = import-faixa-propost.nr-faixa-etaria
                      teadgrpa.nr-idade-minima        = import-faixa-propost.num-idade-min
                      teadgrpa.nr-idade-maxima        = import-faixa-propost.num-idade-max
                      teadgrpa.qt-fator-multiplicador = import-faixa-propost.qtd-fator-multiplic
                      teadgrpa.qt-fat-mult-inscr      = import-faixa-propost.qtd-fator-multiplic-inscr
                      teadgrpa.lg-inclusao            = yes
                      teadgrpa.dt-atualizacao         = today
                      teadgrpa.cd-userid              = v_cod_usuar_corren.  
        END.
    END.

END PROCEDURE.

PROCEDURE cria-negoc-repas:

    FOR EACH import-negociac-propost 
       where import-negociac-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost no-lock :

        /* ------------------------------------------------------------------------- */
        FOR FIRST propunim EXCLUSIVE-LOCK
            where propunim.cd-modalidade = b-import-propost.cd-modalidade
              and propunim.nr-proposta   = nr-proposta-aux
              and propunim.cd-unimed     = import-negociac-propost.cd-unimed:
        END.
        IF NOT AVAIL propunim
        then do:
               create propunim.
               assign propunim.cd-modalidade  = b-import-propost.cd-modalidade
                      propunim.nr-proposta    = nr-proposta-aux
                      propunim.cd-unimed      = import-negociac-propost.cd-unimed.
             END.

        ASSIGN propunim.cd-plano              = import-negociac-propost.cd-plano
               propunim.cd-tipo-plano         = import-negociac-propost.cd-tipo-plano
               propunim.cd-forma-pagto        = import-negociac-propost.cd-forma-pagto
               propunim.um-carencia           = import-negociac-propost.um-carencia
               propunim.qt-carencia           = import-negociac-propost.qt-carencia
               propunim.cd-tab-preco          = import-negociac-propost.cd-tab-preco
               propunim.cd-tab-preco-proc     = import-negociac-propost.cd-tab-preco-proc
               propunim.cd-tipo-vencimento    = import-negociac-propost.cdn-tip-vencto
               propunim.dd-vencimento         = import-negociac-propost.num-dia-vencto
               propunim.pc-insc-acrescimo     = import-negociac-propost.pc-acrescimo-inscr
               propunim.pc-insc-desconto      = import-negociac-propost.pc-desconto-inscr
               propunim.pc-desconto           = import-negociac-propost.pc-desconto
               propunim.pc-acrescimo          = import-negociac-propost.pc-acrescimo
               propunim.dt-inicio-rep         = import-negociac-propost.dat-inic-repas
               propunim.dt-cancelamento       = import-negociac-propost.dat-fim-repas
               propunim.mm-ult-rep            = import-negociac-propost.num-mes-ult-repas
               propunim.aa-ult-rep            = import-negociac-propost.aa-ult-repasse
               propunim.dt-atualizacao        = today
               propunim.cd-userid             = v_cod_usuar_corren
               propunim.lg-impressao-carteira = import-negociac-propost.log-impres-cart
               propunim.lg-calc-valor         = import-negociac-propost.log-calc-val             
               propunim.lg-repassar           = import-negociac-propost.log-repas
               propunim.in-exporta-repasse    = 1 /* Exportar A100 */ .  
              
        if import-negociac-propost.in-tipo-valorizacao = 1
        then assign propunim.lg-tipo-valorizacao-co = yes.
        else assign propunim.lg-tipo-valorizacao-co = no.

        IF lg-gerar-termo-aux
        THEN DO:
               FOR FIRST ter-ade FIELDS (dt-fim) NO-LOCK
                   WHERE ter-ade.cd-modalidade = propost.cd-modalidade
                     AND ter-ade.nr-ter-adesao = propost.nr-ter-adesao:

                         /* --------- TESTAR PROPOSTA CANCELADA OU PEA --------- */
                         if   propost.dt-libera-doc <> ?
                         then assign propunim.dt-fim-rep = propost.dt-libera-doc.
                         else assign propunim.dt-fim-rep = ter-ade.dt-fim.
                         
                         assign propunim.cd-userid      = v_cod_usuar_corren
                                propunim.dt-atualizacao = today.
               END.
             END.
    END.

END PROCEDURE.

PROCEDURE cria-cobertura:

    RUN escrever-log("@@@@@@@@@@entrando em CRIA-COBERTURA. b-import-propost.num-seqcial-propost: " + string(b-import-propost.num-seqcial-propost)).

    FOR EACH import-padr-cobert-propost where import-padr-cobert-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost no-lock :

        RUN escrever-log("@@@@@@@@@@import-padr-cobert-propost.num-seqcial-propost: " + string(import-padr-cobert-propost.num-seqcial-propost)).

        IF NOT CAN-FIND (first pro-pla use-index pro-pla3
                         where pro-pla.cd-modalidade   = b-import-propost.cd-modalidade
                           and pro-pla.nr-proposta     = nr-proposta-aux
                           and pro-pla.cd-modulo       = import-padr-cobert-propost.cd-modulo)
        then do:
               RUN escrever-log("@@@@@@@@@@import-padr-cobert-propost.num-seqcial-propost(NAO ACHOU PRO-PLA. NEXT): " + string(import-padr-cobert-propost.num-seqcial-propost)).
               NEXT.
             END.

        RUN escrever-log("@@@@@@@@@@ P2 import-padr-cobert-propost.num-seqcial-propost: " + string(import-padr-cobert-propost.num-seqcial-propost)).

        IF NOT CAN-FIND (FIRST propcopa 
                         where propcopa.cd-modalidade       = b-import-propost.cd-modalidade
                           and propcopa.nr-proposta         = nr-proposta-aux
                           and propcopa.cd-padrao-cobertura = import-padr-cobert-propost.cd-padrao-cobertura
                           and propcopa.cd-modulo           = import-padr-cobert-propost.cd-modulo)
        then DO:

               RUN escrever-log("@@@@@@@@@@ create PROPCOPA. modalidade: " + string(b-import-propost.cd-modalidade) 
                                + " proposta: " + STRING(nr-proposta-aux)  + "padrao: " + STRING(import-padr-cobert-propost.cd-padrao-cobertura)
                                + " modulo: " + STRING(import-padr-cobert-propost.cd-modulo)).

               create propcopa.
               assign propcopa.cd-modalidade        = b-import-propost.cd-modalidade
                      propcopa.nr-proposta          = nr-proposta-aux
                      propcopa.cd-padrao-cobertura  = import-padr-cobert-propost.cd-padrao-cobertura
                      propcopa.cd-modulo            = import-padr-cobert-propost.cd-modulo
                      propcopa.pc-acrescimo-inscr   = import-padr-cobert-propost.pc-acrescimo-inscr
                      propcopa.pc-desconto-inscr    = import-padr-cobert-propost.pc-desconto-inscr
                      propcopa.pc-acresc-taxa       = import-padr-cobert-propost.pc-acresc-taxa
                      propcopa.pc-desconto-taxa     = import-padr-cobert-propost.pc-desconto-taxa
                      propcopa.nr-dias-bonificacao  = import-padr-cobert-propost.num-dias-bonifi
                      propcopa.lg-inclusao          = yes
                      propcopa.dt-atualizacao       = today
                      propcopa.cd-userid            = v_cod_usuar_corren.
             END.

        /*find modalid where modalid.cd-modalidade = b-import-propost.cd-modalidade no-lock no-error.
        
        IF AVAIL modalid
        AND modalid.in-geracao-termo = 2
        AND NOT CAN-FIND (first tegrpaco 
                          where tegrpaco.cd-modalidade       = b-import-propost.cd-modalidade
                            and tegrpaco.nr-ter-adesao       = nr-proposta-aux
                            and tegrpaco.cd-padrao-cobertura = import-padr-cobert-propost.cd-padrao-cobertura
                            and tegrpaco.cd-grau-parentesco  = import-padr-cobert-propost.cd-grau-parentesco
                            and tegrpaco.nr-faixa-etaria     = import-padr-cobert-propost.nr-faixa-etaria)
        then do:
               create tegrpaco.                                                                       
               assign tegrpaco.cd-modalidade       = b-import-propost.cd-modalidade                  
                      tegrpaco.nr-ter-adesao       = nr-proposta-aux                                 
                      tegrpaco.cd-padrao-cobertura = import-padr-cobert-propost.cd-padrao-cobertura
                      tegrpaco.cd-grau-parentesco  = import-padr-cobert-propost.cd-grau-parentesco 
                      tegrpaco.nr-faixa-etaria     = import-padr-cobert-propost.nr-faixa-etaria 
                      tegrpaco.lg-inclusao         = yes
                      tegrpaco.qt-fator-mult-mens  = import-padr-cobert-propost.qt-fator-mensalidade
                      tegrpaco.qt-fator-mult-inscr = import-padr-cobert-propost.qt-fator-inscricao
                      tegrpaco.int-1               = import-padr-cobert-propost.nr-faixa-etaria-ini
                      tegrpaco.int-2               = import-padr-cobert-propost.nr-faixa-etaria-fim
                      tegrpaco.dt-atualizacao      = today              
                      tegrpaco.cd-userid           = v_cod_usuar_corren. 
             END.*/

    END.

    RUN escrever-log("@@@@@@@@@@saindo de CRIA-COBERTURA").
END PROCEDURE.

PROCEDURE cria-campos-espec:

    FOR EACH import-campos-propost where import-campos-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost no-lock :

        IF NOT CAN-FIND (FIRST campprop
                         where campprop.cd-modalidade = b-import-propost.cd-modalidade
                           and campprop.nr-proposta   = nr-proposta-aux)
        then do:
               create campprop.
               assign campprop.nr-insc-contratante     = tt-import-propost.nr-insc-contrat
                      campprop.cd-modalidade           = b-import-propost.cd-modalidade
                      campprop.nr-proposta             = nr-proposta-aux
                      campprop.ds-campo[1]             = import-campos-propost.des-campo-1
                      campprop.ds-mascara[1]           = import-campos-propost.des-mascar-1
                      campprop.ds-campo[2]             = import-campos-propost.des-campo-2
                      campprop.ds-mascara[2]           = import-campos-propost.des-mascar-2
                      campprop.ds-campo[3]             = import-campos-propost.des-campo-3
                      campprop.ds-mascara[3]           = import-campos-propost.des-mascar-3
                      campprop.ds-campo[4]             = import-campos-propost.des-campo-4
                      campprop.ds-mascara[4]           = import-campos-propost.des-mascar-4
                      campprop.cd-userid               = v_cod_usuar_corren
                      campprop.dt-atualizacao          = today
                      campprop.lg-obriga-digitacao[1]  = import-campos-propost.log-obrig-digitac-1
                      campprop.lg-obriga-digitacao[2]  = import-campos-propost.log-obrig-digitac-2
                      campprop.lg-obriga-digitacao[3]  = import-campos-propost.log-obrig-digitac-3
                      campprop.lg-obriga-digitacao[4]  = import-campos-propost.log-obrig-digitac-4
                      campprop.lg-consiste-dados[1]    = import-campos-propost.log-consist-dados-1
                      campprop.lg-consiste-dados[2]    = import-campos-propost.log-consist-dados-2
                      campprop.lg-consiste-dados[3]    = import-campos-propost.log-consist-dados-3
                      campprop.lg-consiste-dados[4]    = import-campos-propost.log-consist-dados-4.

             END.
    END.

END PROCEDURE.

PROCEDURE cria-proced-propost:

    FOR EACH import-proced-propost where import-proced-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost no-lock :

        FOR FIRST pro-pla FIELDS (cd-forma-pagto dt-inicio) use-index pro-pla3
            where pro-pla.cd-modalidade   = b-import-propost.cd-modalidade
              and pro-pla.nr-proposta     = nr-proposta-aux
              and pro-pla.cd-modulo       = import-proced-propost.cd-modulo NO-LOCK:
        END.

        if   not avail pro-pla
        then NEXT.

        IF import-proced-propost.dt-inicial < pro-pla.dt-inicio
        then do:
               ASSIGN lg-relat-erro = YES.
               RUN pi-grava-erro("Data de inicio do procedimento menor que a data de inicio do modulo na proposta").
             END.
        
        /* ---------------------- VERIFICA TABELA DE MOEDAS/CARENCIA ATIVA --- */
        if   import-proced-propost.dt-cancela = ?                              
        then do:
               IF NOT CAN-FIND (first precproc 
                                where precproc.cd-tab-preco   = import-proced-propost.cd-tab-preco
                                  and precproc.cd-forma-pagto = pro-pla.cd-forma-pagto
                                  and precproc.dt-limite     >= import-proced-propost.dt-inicial)
        
               THEN IF NOT CAN-FIND (first precproc 
                                     where precproc.cd-tab-preco   = import-proced-propost.cd-tab-preco
                                       and precproc.cd-forma-pagto = pro-pla.cd-forma-pagto
                                       and precproc.dt-limite     >= import-proced-propost.dt-cancela)
                    then DO:
                           ASSIGN lg-relat-erro = YES.
                           RUN pi-grava-erro("Data de inicio do procedimento menor que a data de inicio do modulo na proposta").  
                         END.
             END.

        IF lg-relat-erro
        THEN DO:
               ASSIGN lg-relat-erro-aux = YES.
               NEXT.
             END.

        FOR FIRST pr-mo-am 
            where pr-mo-am.cd-modalidade    = b-import-propost.cd-modalidade
              and pr-mo-am.nr-proposta      = nr-proposta-aux
              and pr-mo-am.cd-modulo        = import-proced-propost.cd-modulo
              and pr-mo-am.cd-amb           = import-proced-propost.cd-amb
              and (pr-mo-am.dt-cancelamento > today
               or pr-mo-am.dt-cancelamento  = ?) EXCLUSIVE-LOCK:
        END.
        IF NOT AVAIL pr-mo-am
        then do:
               create pr-mo-am.
               assign pr-mo-am.cd-modalidade           = b-import-propost.cd-modalidade
                      pr-mo-am.nr-proposta             = nr-proposta-aux
                      pr-mo-am.cd-modulo               = import-proced-propost.cd-modulo
                      pr-mo-am.cd-amb                  = import-proced-propost.cd-amb
                      pr-mo-am.dt-cancelamento         = import-proced-propost.dt-cancela.
             END.

        ASSIGN pr-mo-am.cd-tab-preco            = import-proced-propost.cd-tab-preco
               pr-mo-am.dt-inicio               = import-proced-propost.dt-inicial
               pr-mo-am.nr-dias-validade        = import-proced-propost.nr-dias-validade
               pr-mo-am.int-2                   = import-proced-propost.qt-procedimento
               pr-mo-am.cd-userid               = v_cod_usuar_corren
               pr-mo-am.dt-atualizacao          = today
               pr-mo-am.lg-acrescimo-cobertura  = import-proced-propost.log-acresc-cobert.

        IF lg-gerar-termo-aux
        AND AVAIL ter-ade
        THEN DO:
              /* ------ TESTAR PROPOSTA CANCELADA OU PEA ---------- */
              if   propost.dt-libera-doc <> ?
              then assign pr-mo-am.dt-fim = propost.dt-libera-doc.
              else do:
                     if   pr-mo-am.dt-cancelamento <> ?
                     then assign pr-mo-am.dt-fim = propost.dt-libera-doc.
                     else assign pr-mo-am.dt-fim = ter-ade.dt-fim.
                   end.
             END.
        ELSE pr-mo-am.dt-fim = ?.
    END.

END PROCEDURE.

PROCEDURE cria-mo:

    FOR EACH import-mo-propost where import-mo-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost no-lock :

        IF NOT CAN-FIND (FIRST depsetse 
                         where depsetse.cd-modalidade   = b-import-propost.cd-modalidade
                           and depsetse.nr-proposta     = nr-proposta-aux
                           and depsetse.cd-departamento = import-mo-propost.cd-departamento
                           and depsetse.cd-secao        = import-mo-propost.cd-secao
                           and depsetse.cd-setor        = import-mo-propost.cd-setor)
        then do:
               /*----- CRIA DEPSETSE ------------------------------------------------*/
               create depsetse.
               assign depsetse.cd-modalidade    = b-import-propost.cd-modalidade
                      depsetse.nr-proposta      = nr-proposta-aux
                      depsetse.nr-ter-adesao    = propost.nr-ter-adesao
                      depsetse.cd-departamento  = import-mo-propost.cd-departamento
                      depsetse.cd-secao         = import-mo-propost.cd-secao
                      depsetse.cd-setor         = import-mo-propost.cd-setor
                      depsetse.char-1           = "A"
                      depsetse.cd-userid        = v_cod_usuar_corren
                      depsetse.dt-atualizacao   = TODAY.
             end.
    END.

END PROCEDURE.

PROCEDURE cria-mo-funcao:

    FOR EACH import-funcao-propost FIELDS (cd-funcao des-funcao)
       where import-funcao-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost NO-LOCK,

       FIRST import-mo-propost where import-mo-propost.num-seqcial-propost = b-import-propost.num-seqcial-propost NO-LOCK:

        IF NOT can-find (first funcprop 
                         where funcprop.cd-modalidade = import-propost.cd-modalidade
                           and funcprop.nr-proposta   = nr-proposta-aux
                           and (funcprop.cd-setor     = import-mo-propost.cd-setor
                             or funcprop.cd-setor     = 0)
                           and funcprop.cd-funcao     = import-funcao-propost.cd-funcao)
        then do:
               /**************** CRIA FUNCPROP *************************************/
               create funcprop.
               assign funcprop.cd-modalidade  = b-import-propost.cd-modalidade 
                      funcprop.nr-proposta    = nr-proposta-aux   
                      funcprop.cd-funcao      = import-funcao-propost.cd-funcao
                      funcprop.ds-detalhada   = import-funcao-propost.des-funcao
                      funcprop.cd-userid      = v_cod_usuar_corren
                      funcprop.dt-atualizacao = today.
               
               if import-mo-propost.cd-setor = ? 
               or import-mo-propost.cd-setor = 0
               then assign funcprop.cd-setor = 0.
               else assign funcprop.cd-setor = import-mo-propost.cd-setor.
             END.
    END.

END PROCEDURE.

/* ------------------------------------------------------------------------- */ 
procedure remover.

    DEF BUFFER b-propost  FOR propost.
    DEF BUFFER bb-propost FOR propost.

    find first paramecp no-lock no-error.
    if   avail paramecp
    then do:
           find b-propost where b-propost.ep-codigo     = paramecp.ep-codigo
                            and b-propost.cod-estabel   = paramecp.cod-estabel
                            and b-propost.cd-modalidade = propost.cd-modalidade
                            and b-propost.nr-proposta   = propost.nr-proposta
                                exclusive-lock no-error.
           if   avail b-propost
           then do:
                  /*-- Include de eliminacao da proposta nas tabelas com referencia. ---*/
                  /* Eliminacao de todas as tabelas de referencia da proposta */

for each comisaux                                 
         where comisaux.cd-modalidade = b-propost.cd-modalidade       
           and comisaux.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete comisaux.
end.                                              

for each valprodu                                 
         where valprodu.cd-modalidade = b-propost.cd-modalidade       
           and valprodu.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete valprodu.                              
end.                                              
                                                  
for each depsetse                                 
         where depsetse.cd-modalidade = b-propost.cd-modalidade       
           and depsetse.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete depsetse.                              
end.                                              
                                                  
for each funcprop
         where funcprop.cd-modalidade = b-propost.cd-modalidade
           and funcprop.nr-proposta   = b-propost.nr-proposta
         exclusive-lock:
    delete funcprop.
end.

for each usumodu                                  
         where usumodu.cd-modalidade = b-propost.cd-modalidade        
           and usumodu.nr-proposta   = b-propost.nr-proposta        
         exclusive-lock:                          
    delete usumodu.                               
end.                                              
                                                  
for each usucaren                                 
         where usucaren.cd-modalidade = b-propost.cd-modalidade       
           and usucaren.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete usucaren.                              
end.                  

for each usucarproc                                 
         where usucarproc.cd-modalidade = b-propost.cd-modalidade       
           and usucarproc.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete usucarproc.                              
end.                  
                                                  
for each qtmcopre                                 
         where qtmcopre.cd-modalidade = b-propost.cd-modalidade       
           and qtmcopre.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete qtmcopre.                              
end.                                              
                                                  
for each qtmpgpre                                 
         where qtmpgpre.cd-modalidade = b-propost.cd-modalidade       
           and qtmpgpre.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete qtmpgpre.                              
end.                                              
                                                  
for each campprop                                 
         where campprop.cd-modalidade = b-propost.cd-modalidade       
           and campprop.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete campprop.                              
end.                                              
                                                  
for each decprest                                 
         where decprest.cd-modalidade = b-propost.cd-modalidade       
           and decprest.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete decprest.                              
end.                                              
                                                  
for each dzdeccid                                 
         where dzdeccid.cd-modalidade = b-propost.cd-modalidade       
           and dzdeccid.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete dzdeccid.                              
end.                                              
                                                  
for each fxpalovp                                 
         where fxpalovp.cd-modalidade = b-propost.cd-modalidade       
           and fxpalovp.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete fxpalovp.                              
end.                                              
                                                  
for each fxparpro                                 
         where fxparpro.cd-modalidade = b-propost.cd-modalidade       
           and fxparpro.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete fxparpro.                              
end.                                              
                                                  
for each movcarrc                                 
         where movcarrc.cd-modalidade = b-propost.cd-modalidade       
           and movcarrc.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete movcarrc.                              
end.                                              
                                                  
for each pr-id-us                                 
         where pr-id-us.cd-modalidade = b-propost.cd-modalidade       
           and pr-id-us.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete pr-id-us.                              
end.                                              
                                                  
for each pr-mo-am                                 
         where pr-mo-am.cd-modalidade = b-propost.cd-modalidade       
           and pr-mo-am.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete pr-mo-am.                              
end.                                              
                                                  
for each pro-pla use-index pro-pla2                      
         where pro-pla.cd-modalidade = b-propost.cd-modalidade
           and pro-pla.nr-proposta   = b-propost.nr-proposta
         exclusive-lock:                                 
    delete pro-pla validate(true,"").
end. 

for each procpres                                 
         where procpres.cd-modalidade = b-propost.cd-modalidade       
           and procpres.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete procpres.                              
end.                                              
                                                  
for each propcart                                 
         where propcart.cd-modalidade = b-propost.cd-modalidade       
           and propcart.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete propcart.                              
end.                                              
                                                  
for each propcopa                                 
         where propcopa.cd-modalidade = b-propost.cd-modalidade       
           and propcopa.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete propcopa.                              
end.                                              
                                                  
for each usureate                                 
         where usureate.cd-modalidade = b-propost.cd-modalidade       
           and usureate.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete usureate.                              
end.                                              
                                                  
for each proptaxa                                 
         where proptaxa.cd-modalidade = b-propost.cd-modalidade       
           and proptaxa.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete proptaxa.                              
end.                                              
                                                  
for each propunim                                 
         where propunim.cd-modalidade = b-propost.cd-modalidade       
           and propunim.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete propunim.                              
end.                                              
                                                  
for each prorespr                                 
         where prorespr.cd-modalidade = b-propost.cd-modalidade       
           and prorespr.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete prorespr.                              
end.                                              
                                                  
for each prunineg                                 
         where prunineg.cd-modalidade = b-propost.cd-modalidade       
           and prunineg.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete prunineg.                              
end.                                              
                                                  
for each sobtxpro                                 
         where sobtxpro.cd-modalidade = b-propost.cd-modalidade       
           and sobtxpro.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete sobtxpro.                              
end.                                              
                                                  
for each teadgrpa                                 
         where teadgrpa.cd-modalidade = b-propost.cd-modalidade       
           and teadgrpa.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete teadgrpa.                              
end.                                              
                                                  
for each tegrpaco                                 
         where tegrpaco.cd-modalidade = b-propost.cd-modalidade       
           and tegrpaco.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete tegrpaco.                              
end.                                              
                                                  
for each dzdecpro 
         where dzdecpro.cd-modalidade = b-propost.cd-modalidade
           and dzdecpro.nr-proposta   = b-propost.nr-proposta
               exclusive-lock. 
    delete dzdecpro.                                                 
end.

for each usuario                                  
         where usuario.cd-modalidade = b-propost.cd-modalidade        
           and usuario.nr-proposta   = b-propost.nr-proposta        
         exclusive-lock:                          
    delete usuario.                               
end.                                              
                                                  
for each usurepas                                 
         where usurepas.cd-modalidade = b-propost.cd-modalidade       
           and usurepas.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete usurepas.                              
end.

for each proptxtr                                 
         where proptxtr.cd-modalidade = b-propost.cd-modalidade       
           and proptxtr.nr-proposta   = b-propost.nr-proposta       
         exclusive-lock:                          
    delete proptxtr.                              
end.
     
 
    
                  /* --- TABELA SIT-APROV-PROPOSTA --- */
                  find sit-aprov-proposta where sit-aprov-proposta.cd-modalidade = b-propost.cd-modalidade
                                            and sit-aprov-proposta.nr-proposta   = b-propost.nr-proposta exclusive-lock no-error.
                  if avail sit-aprov-proposta
                  then delete sit-aprov-proposta.
    
                  find first contrat where contrat.nr-insc-contratante = b-propost.nr-insc-contratante exclusive-lock no-error.
                  if avail contrat
                  THEN DO:
                         find first bb-propost where bb-propost.nr-insc-contratante = contrat.nr-insc-contratante no-lock no-error.
                         if not avail bb-propost
                         then assign contrat.lg-tem-proposta = no.
                              
                         assign lg-tem-proposta-aux = no.
                         for each modalid fields (cd-modalidade) no-lock:
                             if can-find (first propost use-index propo20 
                                          where propost.cd-modalidade          = modalid.cd-modalidade
                                            and propost.nr-insc-contrat-origem = contrat.nr-insc-contratante)
                             then do:
                                    assign lg-tem-proposta-aux = yes.  
                                    leave.
                                  end.
                         end.
                        
                         if lg-tem-proposta-aux = no
                         then assign contrat.lg-tem-proposta-contr-orig = no.
                       END.

                  FOR EACH ter-ade EXCLUSIVE-LOCK
                     WHERE ter-ade.cd-modalidade = b-propost.cd-modalidade
                       AND ter-ade.nr-ter-adesao = b-propost.nr-ter-adesao:
                           DELETE ter-ade.
                  END.

                  delete b-propost.

                  RELEASE b-propost.
                  
                end.
         end.
end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure pi-grava-erro:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.

    IF nro-seq-aux = 0
    THEN do:
           IF CAN-FIND (FIRST erro-process-import WHERE erro-process-import.num-seqcial-control = b-import-propost.num-seqcial-control)
           THEN RUN pi-consulta-prox-seq (INPUT b-import-propost.num-seqcial-control, OUTPUT nro-seq-aux).
           ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
         END.
    ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
    
    /**
     * Garantir unicidade da chave.
     */
    create erro-process-import.
    REPEAT:
        assign erro-process-import.num-seqcial         = nro-seq-aux
               erro-process-import.num-seqcial-control = b-import-propost.num-seqcial-control NO-ERROR.
        VALIDATE erro-process-import NO-ERROR.
        IF ERROR-STATUS:ERROR
        OR ERROR-STATUS:NUM-MESSAGES > 0
        THEN do:
               ASSIGN nro-seq-aux = nro-seq-aux + 1.
               PAUSE(1). /* aguarda 1seg e busca novamente o proximo nr livre.*/
             END.
        else leave.    /* o nr gerado eh valido. continua o processo.*/
    END.

    ASSIGN erro-process-import.nom-tab-orig-erro   = "BE - import-propost"
           erro-process-import.des-erro            = ds-erro-par
           erro-process-import.dat-erro            = today. 

    FOR FIRST control-migrac FIELDS (ind-sit-import)
        WHERE control-migrac.num-seqcial = b-import-propost.num-seqcial-control EXCLUSIVE-LOCK:
    END.
    if avail control-migrac
    then assign control-migrac.ind-sit-import = "PE".

    FOR FIRST bb-import-propost FIELDS (ind-sit-import) 
        WHERE bb-import-propost.num-seqcial-control = erro-process-import.num-seqcial-control EXCLUSIVE-LOCK:
    END.
    IF AVAIL bb-import-propost
    THEN DO:        
           ASSIGN bb-import-propost.ind-sit-import = "PE".

           VALIDATE bb-import-propost.
           RELEASE  bb-import-propost.
         END.

end procedure.

procedure pi-grava-erro2:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.
    DEF INPUT PARAM ds-ajuda-par AS CHAR NO-UNDO.

    IF nro-seq-aux = 0
    THEN do:
           IF CAN-FIND (FIRST erro-process-import WHERE erro-process-import.num-seqcial-control = b-import-propost.num-seqcial-control)
           THEN RUN pi-consulta-prox-seq (INPUT b-import-propost.num-seqcial-control, OUTPUT nro-seq-aux).
           ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
         END.
    ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
    
    /**
     * Garantir unicidade da chave.
     */
    create erro-process-import.
    REPEAT:
        assign erro-process-import.num-seqcial         = nro-seq-aux
               erro-process-import.num-seqcial-control = b-import-propost.num-seqcial-control NO-ERROR.
        VALIDATE erro-process-import NO-ERROR.
        IF ERROR-STATUS:ERROR
        OR ERROR-STATUS:NUM-MESSAGES > 0
        THEN do:
               ASSIGN nro-seq-aux = nro-seq-aux + 1.
               PAUSE(1). /* aguarda 1seg e busca novamente o proximo nr livre.*/
             END.
        else leave.    /* o nr gerado eh valido. continua o processo.*/
    END.

    ASSIGN erro-process-import.nom-tab-orig-erro   = "BE - import-propost"
           erro-process-import.des-erro            = ds-erro-par
           erro-process-import.des-ajuda           = ds-ajuda-par
           erro-process-import.dat-erro            = today. 

    FOR FIRST control-migrac FIELDS (ind-sit-import)
        WHERE control-migrac.num-seqcial = b-import-propost.num-seqcial-control EXCLUSIVE-LOCK:
    END.
    if avail control-migrac
    then assign control-migrac.ind-sit-import = "PE".

    FOR FIRST bb-import-propost FIELDS (ind-sit-import) 
        WHERE bb-import-propost.num-seqcial-control = erro-process-import.num-seqcial-control EXCLUSIVE-LOCK:
    END.
    IF AVAIL bb-import-propost
    THEN DO:        
           ASSIGN bb-import-propost.ind-sit-import = "PE".

           VALIDATE bb-import-propost.
           RELEASE  bb-import-propost.
         END.

end procedure.

procedure pi-consulta-prox-seq:

    def input  parameter nr-seq-contr-p like erro-process-import.num-seqcial-control no-undo.
    def output parameter nro-seq-par    as int initial 0                             no-undo.

    def buffer b-erro-process-import for erro-process-import.

    select max(erro-process-import.num-seqcial) into nro-seq-par 
           from erro-process-import 
           where erro-process-import.num-seqcial-control = nr-seq-contr-p.

    if nro-seq-par = ?
    then assign nro-seq-par = 1.
    else assign nro-seq-par = nro-seq-par + 1.

end procedure.

PROCEDURE escrever-log:
    DEF INPUT PARAMETER ds-mens-aux AS CHAR NO-UNDO.
END.
