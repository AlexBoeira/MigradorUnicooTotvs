/* CG0311V - CRIA BENEFICIARIO E TABELAS ASSOCIADAS */

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
assign c_prg_vrs = "2.00.00.041".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'CG0311UV':U, '2.00.00.041':U, '':U).
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
  /*** 010041 ***/



/******************************************************************************
*      Programa .....: cg0311v.p                                              *
*      Data .........: 27 de Janeiro de 2015                                  *
*      Autor ........: TOTVS                                                  *
*      Sistema ......: CG - Cadastros Gerais                                  *
*      Programador ..: Ja¡ne Marin                                            *
*      Objetivo .....: Importacao de Beneficiarios                            *
*                                                                             *
*                    - Rotina de Inclusao do usuario                          *
*                                                                             *
*-----------------------------------------------------------------------------*
*     VERSAO      DATA       RESPONSAVEL    MOTIVO                            *
*     C.00.000   27/01/2015  Ja¡ne          Desenvolvimento                   *
******************************************************************************/
/* rtp/rtparmo2.i */

/* -------------------- Pesquisa os parametros MO --------------------------- */

def     shared var cd-tipo-medi-aux like parammo.cd-tipo-medi-tp       no-undo.
def     shared var cd-mediocupa-aux like modalid.cd-modalidade         no-undo.
def     shared var cd-admis-aux     like parammo.cd-admissional-tr     no-undo.
def     shared var cd-afast-aux     like parammo.cd-afastado-tr        no-undo.
def     shared var cd-ativo-aux     like parammo.cd-ativo-tr           no-undo.
def     shared var cd-demis-aux     like parammo.cd-demissional-tr     no-undo.
def     shared var cd-desli-aux     like parammo.cd-desligado-tr       no-undo.
def     shared var cd-perio-aux     like parammo.cd-periodico-tr       no-undo.
def     shared var cd-rettr-aux     like parammo.cd-retorno-trabalho-tr no-undo.
def     shared var cd-trofu-aux     like parammo.cd-troca-funcao-tr    no-undo.
def     shared var cd-trose-aux     like parammo.cd-troca-setor-tr     no-undo.
def     shared var cd-manut-aux     like parammo.cd-manutencao-pp      no-undo.
def     shared var cd-proge-aux     like parammo.cd-pronto-geracao-pp  no-undo.
def     shared var cd-proco-aux     like parammo.cd-pronto-copia-pp    no-undo.
def     shared var cd-atipp-aux     like parammo.cd-ativo-pp           no-undo.
def     shared var cd-inati-aux     like parammo.cd-inativo-pp         no-undo.
def     shared var cd-norma-aux     like parammo.cd-normal-pc          no-undo.
def     shared var cd-envco-aux     like parammo.cd-enviadoco-pc       no-undo.
def     shared var cd-envfa-aux     like parammo.cd-enviadofa-pc       no-undo.
def     shared var cd-proce-aux     like parammo.cd-processado-pc      no-undo.
def     shared var nr-perio-aux     like parammo.nr-periodo-cb         no-undo.
def     shared var cd-espec-aux     like parammo.cd-especialid-ep      no-undo.
def     shared var cd-parpr-aux     like parammo.cd-parampron-pa       no-undo.
def     shared var cd-parin-aux     like parammo.cd-paraminsp-pa       no-undo.
def     shared var cd-gerad-aux     like parammo.cd-gerado-pc          no-undo.
def     shared var cd-concl-aux     like parammo.cd-concluido-pc       no-undo.
def     shared var cd-cobra-aux     like parammo.cd-cobrado-pc         no-undo.
def     shared var cd-pagos-aux     like parammo.cd-pago-pc            no-undo.
def     shared var cd-execu-aux     like parammo.cd-executado-pc       no-undo.
def     shared var cd-espam-aux     like parammo.cd-esp-amb-pc         no-undo.
def     shared var cd-gruam-aux     like parammo.cd-grupo-proc-amb-pc  no-undo.
def     shared var cd-proam-aux     like parammo.cd-procedimento-pc    no-undo.
def     shared var cd-dvamb-aux     like parammo.dv-procedimento-pc    no-undo.
def     shared var cd-super-aux     like parammo.cd-supervisor-mg      no-undo.
def     shared var cd-conta-aux     like parammo.cd-transacao-contas   no-undo.
def     shared var cd-extra-aux     like parammo.cd-exame-extra-tr     no-undo.
def     shared var cd-naoex-aux     like parammo.cd-naoexecutou-pc     no-undo.
def     shared var lg-ant-exam-aux  like parammo.lg-antecipa-exames    no-undo.
def     shared var lg-recalc-aux    like parammo.lg-recalcula-periodo  no-undo.

DEF     SHARED VAR qt-cont-sair-aux AS INT NO-UNDO.
 
def buffer b-usuario for usuario.
DEF BUFFER b-endereco FOR endereco.
def buffer bb-usuario for usuario. 
def var aa-mm-sem-reaj-troca-fx-aux    like usuario.aa-mm-sem-reaj-troca-fx
                                                                        no-undo.

/* -------------------------------------------------- DEFINICAO DA INCLUDE DA API USMOVADM --- */
{api/api-usmovadm.i}.

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
{hdp/hdrunpersis.iv}

/*--------------------------------------------------- PERSISTENCIA DA API ---*/ 
def var h-api-usmovadm-aux               as handle                     no-undo.


/* ------------------------------------- DEFINICAO DE INCLUDES DAS API'S --- */
/******************************************************************************
*      Programa .....: rtapi041.i                                             *
*      Data .........: 12 de Junho de 2000                                    *
*      Sistema ......: RT - ROTINAS PADRAO                                    *
*      Empresa ......: DZSET Solucoes e Sistemas                              *
*      Programador ..: Leonardo Deimomi                                       *
*      Objetivo .....: Definicao de variaveis compartilhadas entre o programa *
*                      chamador e a API rtapi041.p                            *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      D.00.000  12/06/2000  Leonardo       Desenvolvimento                   *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
*      E.00.001  29/01/2001  Jaque          Passar parametros para testar se  *
*                                           o responsavel esta excluido deixar*
*                                           incluir o dependente excluido para*
*                                           beneficiarios incluidos via progra*
*                                           mas de migracao apenas(Modulo CG).*
******************************************************************************/

/* ------------------ DEFINICAO DA TABELA TEMPORARIA DE MENSAGENS PADRAO --- */
def new shared temp-table tmp-mensa-rtapi041                                  no-undo
    field cd-mensagem-mens                   like mensiste.cd-mensagem
    field ds-mensagem-mens                   like mensiste.ds-mensagem-sistema
    field ds-complemento-mens                like mensiste.ds-mensagem-sistema
    field in-tipo-mensagem-mens              like mensiste.in-tipo-mensagem
    field ds-chave-mens                      like mensiste.ds-mensagem-sistema.

/* ------------------------ DEFINICAO DE VARIAVEIS COMPARTILHADAS NA API --- */
def new shared var in-funcao-rtapi041-aux           as char format "x(03)"     no-undo.
def new shared var lg-prim-mens-rtapi041-aux        as log                     no-undo.
def new shared var lg-erro-rtapi041-aux             as log                     no-undo.

/* ------------------------------ DEFINICAO DE VARIAVEIS INTERNAS DA API --- */
def new shared var in-funcao-chamadora-rtapi041-aux as char format "x(03)"     no-undo.
def new shared var lg-simula-chamadora-rtapi041-aux as log                     no-undo.
def new shared var cd-modalidade-rtapi041-aux       like usuario.cd-modalidade no-undo.
def new shared var nr-proposta-rtapi041-aux         like usuario.nr-proposta   no-undo.
def new shared var cd-usuario-rtapi041-aux          like usuario.cd-usuario    no-undo.
def new shared var cd-titular-rtapi041-aux          like usuario.cd-titular    no-undo.
def new shared var lg-sexo-rtapi041-aux             like usuario.lg-sexo       no-undo.
def new shared var cd-grau-parentesco-rtapi041-aux  like usuario.cd-grau-parentesco
                                                                        no-undo.
def new shared var dt-nascimento-rtapi041-aux       like usuario.dt-nascimento no-undo.
def new shared var dt-inclusao-plano-rtapi041-aux   like usuario.dt-inclusao-plano
                                                                        no-undo.
def new shared var lg-importacao-rtapi041-aux       as log                     no-undo.
def new shared var in-modulo-sistema-rtapi041-aux   as char format "x(2)"      no-undo.
def new shared var dt-exclusao-plano-rtapi041-aux   like usuario.dt-exclusao-plano
                                                                        no-undo. 
def new shared var lg-responsavel-rtapi041-aux      as log                     no-undo.
def new shared var lg-altera-sexo-conj-rtapi041-aux as log  initial no         no-undo.

/* ------------------------------------------------------------------------- */

    /* -- GRAU DE PARENTESCO DO BENEFICIARIO --- */
 
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


 

/* ------------------------------------ INCLUDE PARA TRATAMENTO DE ERROS --- */
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
 

/* ------------- INCLUDES COMO DEFINICOES DE TABELAS TEMPORARIAS DAS BOS --- */
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
def temp-table tmpCompany      no-undo
    field id-pessoa             like pessoa-juridica.id-pessoa                 
    field nm-pessoa             like pessoa-juridica.nm-pessoa           
    field cd-cnpj               like pessoa-juridica.cd-cnpj           
    field dt-fundacao           like pessoa-juridica.dt-fundacao          
    field nm-cartao             like pessoa-juridica.nm-cartao            
    field nr-inscricao-estadual like pessoa-juridica.nr-inscricao-estadual
    field nr-cei                like pessoa-juridica.nr-cei          
    field nr-insc-municipal     like pessoa-juridica.nr-inscricao-municipal
    field cd-ramo-atividade     like pessoa-juridica.cd-ramo-atividade
    field ds-ramo-atividade     like ramoativ.ds-atividade-reduz    

    /* --- INDICA QUE A PESSOA ESTA SENDO RELACIONADA A UM CONTRATANTE --- */
    field lg-contratante        as log

    /* --- INDICA QUE A PESSOA ESTA SENDO RELACIONADA A UM PRESTADOR --- */
    field lg-prestador          as log
    field id-pessoa-crm         like pessoa-juridica.id-pessoa-crm
    field id-pessoa-gp          like pessoa-juridica.id-pessoa.

def temp-table tmpCompanyMD     no-undo
    field id_pessoa             like pessoa-juridica.id-pessoa                 
    field nm_pessoa             like pessoa-juridica.nm-pessoa           
    field cd_cnpj               like pessoa-juridica.cd-cnpj           
    field dt_fundacao           like pessoa-juridica.dt-fundacao          
    field nm_cartao             like pessoa-juridica.nm-cartao            
    field nr_inscricao_estadual like pessoa-juridica.nr-inscricao-estadual
    field nr_cei                like pessoa-juridica.nr-cei          
    field nr_insc_municipal     like pessoa-juridica.nr-inscricao-municipal
    field cd_ramo_atividade     like pessoa-juridica.cd-ramo-atividade
    field ds_ramo_atividade     like ramoativ.ds-atividade-reduz    
    field lg_contratante        as log
    field lg_prestador          as log
    field id_pessoa_crm         like pessoa-juridica.id-pessoa-crm
    field id_pessoa_gp          like pessoa-juridica.id-pessoa.
    
def temp-table tmpCompanyAux no-undo like tmpCompany.

def temp-table tmpCompanyLegalRep no-undo like tmpCompany
    field identifier          as int.

def temp-table tmpCompanyController no-undo like tmpCompany
    field identifier          as int.

def temp-table tmpCompanyLegalRepAux no-undo like tmpCompanyLegalRep.
    
def temp-table tmpCompanyControllerAux no-undo like tmpCompanyController.
    
def temp-table tmpCompanyCRUD no-undo
    field id-pessoa             like pessoa-juridica.id-pessoa     
    field nm-pessoa             like pessoa-juridica.nm-pessoa     
    field cd-ramo-atividade     like pessoa-juridica.cd-ramo-atividade
    field ds-atividade-reduz    like ramoativ.ds-atividade-reduz          
    field cd-cnpj               like pessoa-juridica.cd-cnpj
    field ds-email              like contato-pessoa.ds-contato
    field nr-inscricao-estadual like pessoa-juridica.nr-inscricao-estadual
    field nr-telefone           like contato-pessoa.ds-contato
    field tp-telefone           like contato-pessoa.tp-contato
    field in-prestador          as int
    field in-contratante        as int.

/* Temp usada para a passagem de parametros do Metadados */
def temp-table tmpCompanyCRUDMD no-undo
    field cd_cnpj               like pessoa-juridica.cd-cnpj
    field nm_pessoa             like pessoa-juridica.nm-pessoa     
    field tp_relacoes           as  char
    field id_pessoa             like pessoa-juridica.id-pessoa     
    field cd_ramo_atividade     like pessoa-juridica.cd-ramo-atividade
    field ds_atividade_reduz    like ramoativ.ds-atividade-reduz          
    field ds_email              like contato-pessoa.ds-contato
    field nr_inscricao_estadual like pessoa-juridica.nr-inscricao-estadual
    field nr_telefone           like contato-pessoa.ds-contato
    field tp_telefone           like contato-pessoa.tp-contato
    field in_prestador          as int
    field in_contratante        as int.
 
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
def temp-table tmpDemographic                       no-undo
         field nm-tabela                            as char
         field cd-modalidade                        like modalid.cd-modalidade
         field nr-proposta                          like propost.nr-proposta
         field cd-usuario                           like usuario.cd-usuario
         field nr-insc-contratante                  like contrat.nr-insc-contratante
         field cd-unidade                           like unimed.cd-unimed
         field cd-prestador                         like preserv.cd-prestador
         field cd-userid                            as char
         field id-pessoa                            like pessoa-fisica.id-pessoa               
         field nm-pessoa                            like pessoa-fisica.nm-pessoa               
         field cd-cpf                               like pessoa-fisica.cd-cpf                  
         field dt-nascimento                        like pessoa-fisica.dt-nascimento           
         field in-estado-civil                      like pessoa-fisica.in-estado-civil                         
         field lg-sexo                              like pessoa-fisica.lg-sexo                 
         field nr-identidade                        like pessoa-fisica.nr-identidade           
         field uf-emissor-ident                     like pessoa-fisica.uf-emissor-ident        
         field nm-cartao                            like pessoa-fisica.nm-cartao               
         field nm-internacional                     like pessoa-fisica.nm-internacional        
         field ds-nacionalidade                     like pessoa-fisica.ds-nacionalidade        
         field ds-natureza-doc                      like pessoa-fisica.ds-natureza-doc         
         field nr-pis-pasep                         like pessoa-fisica.nr-pis-pasep            
         field nm-mae                               like pessoa-fisica.nm-mae                  
         field nm-pai                               like pessoa-fisica.nm-pai  
         field nm-conjuge                           like pessoa-fisica.nm-conjuge  
         field ds-orgao-emissor-ident               like pessoa-fisica.ds-orgao-emissor-ident 
         field nm-pais-emissor-ident                like pessoa-fisica.nm-pais-emissor-ident  
         field dt-emissao-ident                     like pessoa-fisica.dt-emissao-ident
         field nr-cei                               like pessoa-fisica.nr-cei
         field cd-cartao-nacional-saude             like pessoa-fisica.cd-cartao-nacional-saude
         field in-prestador                         as int
         field in-contratante                       as int
         field in-beneficiario                      as int
         field lg-port-necessid-especiais           as log
         field dns                                  as char
         field id-pessoa-crm                            like pessoa-fisica.id-pessoa-crm
         field nome-abrev                           like pessoa-fisica.nome-abrev
         field lg-exerce-atividade                  as log
         field in-tipo-dependencia                  as int
         field id-pessoa-gp                         like pessoa-fisica.id-pessoa
         
                 field val-peso-pfis                        like pfis-inform-compltar.val-peso-pfis
                 field val-alt-pfis                         like pfis-inform-compltar.val-alt-pfis
                 field des-alerg                            like pfis-inform-compltar.des-alerg
                 field des-medic-atendim                    like pfis-inform-compltar.des-medic-atendim
         field des-cirurgia-realzda                 like pfis-inform-compltar.des-cirurgia-realzda
         field des-medicto-uso                      like pfis-inform-compltar.des-medicto-uso
                 field des-doenca                           like pfis-inform-compltar.des-doenca
         field des-hos-atendim                      like pfis-inform-compltar.des-hos-atendim
         field des-obs                              like pfis-inform-compltar.des-obs
         field lg-parto-coberto                     as log
         field lg-benef-imp                         as log
                 
         index tmp1  
               id-pessoa              
         index tmp2 nm-pessoa
               dt-nascimento
         index tmp3
               nm-internacional
         index tmp4  
               cd-cpf
         index tmp5
               nr-identidade
               dt-nascimento
         index tmp6
               nm-mae.

def temp-table tmpDemographicMD                     no-undo
         field nm_tabela                            as char
         field cd_modalidade                        like modalid.cd-modalidade
         field nr_proposta                          like propost.nr-proposta
         field cd_usuario                           like usuario.cd-usuario
         field nr_insc_contratante                  like contrat.nr-insc-contratante
         field cd_unidade                           like unimed.cd-unimed
         field cd_prestador                         like preserv.cd-prestador
         field cd_userid                            as char
         field id_pessoa                            as char               
         field nm_pessoa                            like pessoa-fisica.nm-pessoa               
         field cd_cpf                               like pessoa-fisica.cd-cpf                  
         field dt_nascimento                        like pessoa-fisica.dt-nascimento           
         field in_estado_civil                      like pessoa-fisica.in-estado-civil                         
         field lg_sexo                              like pessoa-fisica.lg-sexo                 
         field nr_identidade                        like pessoa-fisica.nr-identidade           
         field uf_emissor_ident                     like pessoa-fisica.uf-emissor-ident        
         field nm_cartao                            like pessoa-fisica.nm-cartao               
         field nm_internacional                     like pessoa-fisica.nm-internacional        
         field ds_nacionalidade                     like pessoa-fisica.ds-nacionalidade        
         field ds_natureza_doc                      like pessoa-fisica.ds-natureza-doc         
         field nr_pis_pasep                         like pessoa-fisica.nr-pis-pasep            
         field nm_mae                               like pessoa-fisica.nm-mae                  
         field nm_pai                               like pessoa-fisica.nm-pai  
         field nm_conjuge                           like pessoa-fisica.nm-conjuge  
         field ds_orgao_emissor_ident               like pessoa-fisica.ds-orgao-emissor-ident 
         field nm_pais_emissor_ident                like pessoa-fisica.nm-pais-emissor-ident  
         field dt_emissao_ident                     like pessoa-fisica.dt-emissao-ident
         field nr_cei                               like pessoa-fisica.nr-cei
         field cd_cartao_nacional_saude             like pessoa-fisica.cd-cartao-nacional-saude
         field in_prestador                         as int
         field in_contratante                       as int
         field in_beneficiario                      as int
         field lg_port_necessid_especiais           as log
         field dns                                  as char
         field id_pessoa_crm                            like pessoa-fisica.id-pessoa-crm
         field nome_abrev                           like pessoa-fisica.nome-abrev
         field lg_exerce_atividade                  as log
         field in_tipo_dependencia                  as int.
         
def temp-table tmpUnifyPersonCRUD                   no-undo
         field nm_pessoa                            like pessoa-fisica.nm-pessoa
         field dt_nascimento                        like pessoa-fisica.dt-nascimento
         field id_pessoa                            like pessoa-fisica.id-pessoa
         field tipo_unifica                         as char.

def temp-table tmpDemographicAux no-undo like tmpDemographic.

def temp-table tmpDemographicDomain no-undo
    field nr-ter-adesao     as int
    field nm-tabela                as char                                     
    field cd-modalidade            like modalid.cd-modalidade                  
    field nr-proposta              like propost.nr-proposta                    
    field cd-usuario               like usuario.cd-usuario                     
    field nr-insc-contratante      like contrat.nr-insc-contratante            
    field cd-unidade               like unimed.cd-unimed                       
    field cd-prestador             like preserv.cd-prestador                   
    field cd-userid                as char                                     
    field id-pessoa                like pessoa-fisica.id-pessoa                
    field nm-pessoa                like pessoa-fisica.nm-pessoa                
    field cd-cpf                   like pessoa-fisica.cd-cpf                   
    field dt-nascimento            like pessoa-fisica.dt-nascimento            
    field in-estado-civil          like pessoa-fisica.in-estado-civil                                
    field lg-sexo                  like pessoa-fisica.lg-sexo                  
    field nr-identidade            like pessoa-fisica.nr-identidade            
    field uf-emissor-ident         like pessoa-fisica.uf-emissor-ident         
    field nm-cartao                like pessoa-fisica.nm-cartao                
    field nm-internacional         like pessoa-fisica.nm-internacional         
    field ds-nacionalidade         like pessoa-fisica.ds-nacionalidade         
    field ds-natureza-doc          like pessoa-fisica.ds-natureza-doc          
    field nr-pis-pasep             like pessoa-fisica.nr-pis-pasep             
    field nm-mae                   like pessoa-fisica.nm-mae                   
    field nm-pai                   like pessoa-fisica.nm-pai                   
    field nm-conjuge               like pessoa-fisica.nm-conjuge               
    field ds-orgao-emissor-ident   like pessoa-fisica.ds-orgao-emissor-ident   
    field nm-pais-emissor-ident    like pessoa-fisica.nm-pais-emissor-ident    
    field dt-emissao-ident         like pessoa-fisica.dt-emissao-ident         
    field nr-cei                   like pessoa-fisica.nr-cei                   
    field ds-cbo                   like dz-cbo02.ds-cbo                        
    field cd-cartao-nacional-saude like pessoa-fisica.cd-cartao-nacional-saude 
    field in-prestador             as int                                      
    field in-contratante           as int                                      
    field in-beneficiario          as int                                      
    field lg-port-necessid-especiais   as log                                  
                                                                               
    index tmp1                                                                 
          id-pessoa                                                            
    index tmp2 nm-pessoa                                                       
          dt-nascimento                                                        
    index tmp3                                                                 
          nm-internacional                                                     
    index tmp4                                                                 
          cd-cpf                                                               
    index tmp5                                                                 
          nr-identidade                                                        
          dt-nascimento                                                        
    index tmp6                                                                 
          nm-mae.                                                              


def temp-table tmpDemographicLegalRep no-undo like tmpDemographic
    field identifier          as int.

def temp-table tmpDemographicController no-undo like tmpDemographic
    field identifier          as int.

def temp-table tmpDemographicLegalRepAux no-undo like tmpDemographicLegalRep.

def temp-table tmpDemographicControllerAux no-undo like tmpDemographicController.
    
def temp-table tmpDemographicMainInfo no-undo
    field id-pessoa        like pessoa-fisica.id-pessoa     
    field nm-pessoa        like pessoa-fisica.nm-pessoa     
    field dt-nascimento    like pessoa-fisica.dt-nascimento 
    field nm-mae           like pessoa-fisica.nm-mae        
    field cd-cpf           like pessoa-fisica.cd-cpf        
    index tmp-pessoa1
          id-pessoa.

def temp-table tmpDemographicCRUD no-undo
    field id-pessoa        like pessoa-fisica.id-pessoa     
    field nm-pessoa        like pessoa-fisica.nm-pessoa     
    field dt-nascimento    like pessoa-fisica.dt-nascimento 
    field nm-mae           like pessoa-fisica.nm-mae        
    field cd-cpf           like pessoa-fisica.cd-cpf
    field ds-email         like contato-pessoa.ds-contato
    field nr-identidade    like pessoa-fisica.nr-identidade
    field nr-telefone      like contato-pessoa.ds-contato
    field tp-telefone      like contato-pessoa.tp-contato
    field in-prestador     as int
    field in-contratante   as int
    field in-beneficiario  as int
    field lg-simulacao     as log
    index tmp1
          id-pessoa.

def temp-table tmpDemographicCRUDMD no-undo                     
    field id_pessoa        like pessoa-fisica.id-pessoa 
    field cd_cpf           like pessoa-fisica.cd-cpf
    field nm_pessoa        like pessoa-fisica.nm-pessoa     
    field dt_nascimento    like pessoa-fisica.dt-nascimento 
    field nm_mae           like pessoa-fisica.nm-mae        
    field ds_email         like contato-pessoa.ds-contato
    field nr_identidade    like pessoa-fisica.nr-identidade
    field nr_telefone      like contato-pessoa.ds-contato
    field tp_telefone      like contato-pessoa.tp-contato
    field in_prestador     as int
    field in_contratante   as int
    field in_beneficiario  as int
    field clmRelations     as char
    index tmp1
          id_pessoa.

def temp-table tmpDemographicCRUDAux no-undo like tmpDemographicCRUD.

def temp-table tmpDemographicToUnify no-undo
    field id-pessoa     like pessoa-fisica.id-pessoa     
    field lg-manter     as log.

def temp-table tmpDemographicToUnifyAux no-undo like tmpDemographicToUnify.

def temp-table tmpDemographicToUnifyMD no-undo
    field id_pessoa     like pessoa-fisica.id-pessoa
    field lg_manter     as log.

def temp-table tmpDemographicSimilar    no-undo
         field nm-tabela                as char
         field cd-modalidade            like modalid.cd-modalidade
         field nr-proposta              like propost.nr-proposta
         field cd-usuario               like usuario.cd-usuario
         field nr-insc-contratante      like contrat.nr-insc-contratante
         field cd-unidade               like unimed.cd-unimed
         field cd-prestador             like preserv.cd-prestador
         field cd-userid                as char
         field id-pessoa                like pessoa-fisica.id-pessoa               
         field nm-pessoa                like pessoa-fisica.nm-pessoa               
         field cd-cpf                   like pessoa-fisica.cd-cpf                  
         field dt-nascimento            like pessoa-fisica.dt-nascimento           
         field in-estado-civil          like pessoa-fisica.in-estado-civil         
         field cd-cbo                   like pessoa-fisica.cd-cbo                  
         field lg-sexo                  like pessoa-fisica.lg-sexo                 
         field nr-identidade            like pessoa-fisica.nr-identidade           
         field uf-emissor-ident         like pessoa-fisica.uf-emissor-ident        
         field nm-cartao                like pessoa-fisica.nm-cartao               
         field nm-internacional         like pessoa-fisica.nm-internacional        
         field ds-nacionalidade         like pessoa-fisica.ds-nacionalidade        
         field ds-natureza-doc          like pessoa-fisica.ds-natureza-doc         
         field nr-pis-pasep             like pessoa-fisica.nr-pis-pasep            
         field nm-mae                   like pessoa-fisica.nm-mae                  
         field nm-pai                   like pessoa-fisica.nm-pai  
         field nm-conjuge               like pessoa-fisica.nm-conjuge  
         field ds-orgao-emissor-ident   like pessoa-fisica.ds-orgao-emissor-ident 
         field nm-pais-emissor-ident    like pessoa-fisica.nm-pais-emissor-ident  
         field dt-emissao-ident         like pessoa-fisica.dt-emissao-ident
         field nr-cei                   like pessoa-fisica.nr-cei
         field ds-cbo                   like dz-cbo02.ds-cbo
         field cd-cartao-nacional-saude like pessoa-fisica.cd-cartao-nacional-saude
         field lg-simulacao             as log
         index tmp1
               id-pessoa. 

def temp-table tmpDemographicSimilarAux no-undo like tmpDemographicSimilar.

def temp-table tmpDemographicSimilarMD                     no-undo
    field nm_tabela                                        as character
    field cd_modalidade                                    as integer 
    field nr_proposta                                      as integer 
    field cd_usuario                                       as integer 
    field nr_insc_contratante                              as integer 
    field cd_unidade                                       as integer 
    field cd_prestador                                     as integer 
    field cd_userid                                        as character
    field id_pessoa                                        as decimal 
    field cd_cpf                                           as character 
    field nm_pessoa                                        as character 
    field dt_nascimento                                    as date
    field nr_cei                                           as character
    field nm_mae                                           as character
    field nr_identidade                                    as character 
    field in_estado_civil                                  as integer 
    field cd_cbo                                           as integer 
    field lg_sexo                                          as logical 
    field uf_emissor_ident                                 as character 
    field nm_cartao                                        as character 
    field nm_internacional                                 as character 
    field ds_nacionalidade                                 as character 
    field ds_natureza_doc                                  as character 
    field nr_pis_pasep                                     as decimal 
    field nm_pai                                           as character 
    field nm_conjuge                                       as character 
    field ds_orgao_emissor_ident                           as character 
    field nm_pais_emissor_ident                            as character 
    field dt_emissao_ident                                 as date
    field ds_cbo                                           as character 
    field cd_cartao_nacional_saude                         as decimal. 
 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
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

def temp-table tmpContact           no-undo
         field id-contato     like contato-pessoa.id-contato      
         field id-pessoa      like contato-pessoa.id-pessoa       
         field tp-contato     like contato-pessoa.tp-contato
         field ds-contato     like contato-pessoa.ds-contato
         field ds-ramal       like contato-pessoa.ds-ramal
         field nm-contato     like contato-pessoa.nm-contato
         field id-endereco    like contato-pessoa.id-endereco
         field log-integrado-ems as logical
         field id-contato-crm as integer
         index tmp1
               id-contato
         index tmp2
               ds-contato.

def temp-table tmpContactMD       no-undo
         field tp_contato_grid    as character
         field ds_contato         as character
         field nm_contato         as character
         field ds_ramal           as character 
         field id_contato         as integer 
         field id_pessoa          as decimal 
         field tp_contato         as integer 
         field id_endereco        as integer 
         field log_integrado_ems  as logical
         field id_contato_add     as integer.


def temp-table tmpContactMDAux    no-undo  like tmpContactMD.

def temp-table tmpContactCRUD     no-undo
         field tp_contato         like contato-pessoa.tp-contato 
         field ds_contato         like contato-pessoa.ds-contato
         field nm_contato         like contato-pessoa.nm-contato
         field ds_ramal           like contato-pessoa.ds-ramal.

def temp-table tmpContactAux no-undo like tmpContact.

def temp-table tmpContactLegalRep no-undo like tmpContact
    field identifier          as int.

def temp-table tmpContactController no-undo like tmpContact
    field identifier          as int.

def temp-table tmpContactLegalRepAux no-undo like tmpContactLegalRep.

def temp-table tmpContactControllerAux no-undo like tmpContactController.

def temp-table tmpContactAux2 no-undo like tmpContact
        field lg-sobrescrito as logical. 

def temp-table tmpContactWithPriority no-undo like tmpContact
    field cd-prioridade       as int
    index tp-contato1 cd-prioridade.


 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

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

def temp-table tmpAddress           no-undo
         field id-pessoa            like endereco.id-pessoa
         field id-endereco          like endereco.id-endereco      
         field ds-endereco          like endereco.ds-endereco       
         field ds-complemento       like endereco.ds-complemento    
         field ds-bairro            like endereco.ds-bairro         
         field cd-cep               like endereco.cd-cep            
         field cd-uf                like endereco.cd-uf             
         field cd-cidade            like endereco.cd-cidade         
         field in-tipo-endereco     like endereco.in-tipo-endereco  
         field ds-endereco-grid     as char format "x(400)"
         field nr-caixa-postal      like endereco.nr-caixa-postal   
         field tp-logradouro        like endereco.tp-logradouro   
         field lg-end-cobranca      like endereco.lg-end-cobranca
         field lg-principal         like endereco.lg-principal
         field nm-cidade            like dzcidade.nm-cidade
         field nr-endereco          like endereco.nr-endereco
         field cd-userid            like endereco.cd-userid
         field cd-cidade-origem     as int
         field ds-cidade-origem     as char
         field cd-ibge                          like dzcidade.int-3
         field id-endereco-crm          like endereco.int-4
         field ds-referencia        like endereco.char-1.

def temp-table tmpAddressMD         no-undo
         field lg_principal         like endereco.lg-principal
         field lg_end_cobranca      like endereco.lg-end-cobranca
         field ds_endereco          like endereco.ds-endereco 
         field ds_complemento       like endereco.ds-complemento 
         field cd_cep               like endereco.cd-cep 
         field nm_cidade            like dzcidade.nm-cidade
         field id_pessoa            like endereco.id-pessoa
         field id_endereco          as character      
         field ds_bairro            like endereco.ds-bairro         
         field cd_uf                like endereco.cd-uf             
         field cd_cidade            like endereco.cd-cidade         
         field in_tipo_endereco     like endereco.in-tipo-endereco  
         field ds_endereco_grid     as char format "x(400)"
         field nr_caixa_postal      like endereco.nr-caixa-postal   
         field tp_logradouro        like endereco.tp-logradouro   
         field nr_endereco          like endereco.nr-endereco
         field cd_userid            like endereco.cd-userid
         field cd_cidade_origem     as int
         field ds_cidade_origem     as char
         field cd_ibge                          like dzcidade.int-3
         field id_endereco_crm          like endereco.int-4
         field id_endereco_add      as int.

def temp-table tmpAddressMDAux         no-undo
         field lg_principal         like endereco.lg-principal
         field lg_end_cobranca      like endereco.lg-end-cobranca
         field ds_endereco          like endereco.ds-endereco 
         field ds_complemento       like endereco.ds-complemento 
         field cd_cep               like endereco.cd-cep 
         field nm_cidade            like dzcidade.nm-cidade
         field id_pessoa            like endereco.id-pessoa
         field id_endereco          as character      
         field ds_bairro            like endereco.ds-bairro         
         field cd_uf                like endereco.cd-uf             
         field cd_cidade            like endereco.cd-cidade         
         field in_tipo_endereco     like endereco.in-tipo-endereco  
         field ds_endereco_grid     as char format "x(400)"
         field nr_caixa_postal      like endereco.nr-caixa-postal   
         field tp_logradouro        like endereco.tp-logradouro   
         field nr_endereco          like endereco.nr-endereco
         field cd_userid            like endereco.cd-userid
         field cd_cidade_origem     as int
         field ds_cidade_origem     as char
         field cd_ibge                          like dzcidade.int-3
         field id_endereco_crm          like endereco.int-4
         field id_endereco_add      as int.

define temp-table tmpAddressPar                  no-undo
         field lg_principal                   as logical        LABEL "Principal"       
         field lg_end_cobranca                as logical        LABEL "Cobrança"
         field ds_endereco                    as character      LABEL "Endereço"
         field ds_complemento                 as character      LABEL "Complemento"
         field cd_cep                         as character      LABEL "CEP"
         field nm_cidade                      as character      LABEL "Cidade"
         field id_pessoa                      as decimal 
         field id_endereco                    as character 
         field ds_bairro                      as character 
         field cd_uf                          as character 
         field cd_cidade                      as integer 
         field in_tipo_endereco               as integer 
         field ds_endereco_grid               as character
         field nr_caixa_postal                as character 
         field tp_logradouro                  as character 
         field nr_endereco                    as integer 
         field cd_userid                      as character 
         field cd_cidade_origem               as integer
         field ds_cidade_origem               as character
         field cd_ibge                        as integer 
         field id_endereco_crm                as integer
         field addressMode                                        as character
         field selectedAddress                            as character
         field isFirst                                            as logical
         field isMain                                             as logical   
         field id_endereco_add                as integer.   

def temp-table tmpAddressAux no-undo like tmpAddress.

def temp-table tmpAddressLegalRep no-undo like tmpAddress
    field identifier          as int.

def temp-table tmpAddressController no-undo like tmpAddress
    field identifier          as int.

def temp-table tmpAddressLegalRepAux no-undo like tmpAddressLegalRep.

def temp-table tmpAddressControllerAux no-undo like tmpAddressController.
 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*
    Copyright (c) 2007, DATASUL S/A. Todos os direitos reservados.
    
    Os Programas desta Aplicaï¿½ï¿½o (que incluem tanto o software quanto a sua
    documentaï¿½ï¿½o) contï¿½m informaï¿½ï¿½es proprietï¿½rias da DATASUL S/A; eles sï¿½o
    licenciados de acordo com um contrato de licenï¿½a contendo restriï¿½ï¿½es de uso e
    confidencialidade, e sï¿½o tambï¿½m protegidos pela Lei 9609/98 e 9610/98,
    respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
    reversa, descompilaï¿½ï¿½o e desmontagem dos programas sï¿½o proibidos. Nenhuma
    parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
    por nenhum meio, eletrï¿½nico ou mecï¿½nico, por motivo algum, sem a permissï¿½o
    escrita da DATASUL S/A.

*/

/******************************************************************************
    Programa .....: bosauattachment.i
    Data .........: 12/08/2013
    Sistema ......: Datasul 11
    Empresa ......: TOTVS
    Programador ..: Iago Passos
    Objetivo .....: Include que mantem os conceitos de anexos do GPS.
******************************************************************************/

define temp-table tmpAttachment       no-undo
    field cdd-anexo                   like anexo.cdd-anexo
    field nom-anexo                   like anexo.nom-anexo
    field dir-anexo                   as char 
    field tam-anexo                   as decimal
    field cdn-tip-anexo               like tip-anexo.cdn-tip-anexo
    field des-tip-anexo               as char
    field dat-ult-atualiz             like anexo.dat-ult-atualiz
    field cod-usuar-ult-atualiz       like anexo.cod-usuar-ult-atualiz
    index tmpAttachment1
          cdd-anexo.

define temp-table tmpPersonAttachment no-undo
    field cdd-anexo                   like anexo.cdd-anexo
    field idi-pessoa                  like anexo-pessoa.idi-pessoa.

define temp-table tmpTaskAttachment   no-undo
    field cdd-anexo                   like anexo.cdd-anexo
    field cdd-tar-audit               like anexo-tar-audit.cdd-tar-audit.

define temp-table tmpAttachmentMD     no-undo
    field cdd_anexo                   like anexo.cdd-anexo
    field nom_anexo                   like anexo.nom-anexo
    field dir_anexo                   as char 
    field tam_anexo                   as decimal
    field cdn_tip_anexo               as decimal
    field cdn_tip_anexo_concat        as character 
    field log_gravado_banco           as logical
    field cod_usuar_ult_atualiz       like anexo.cod-usuar-ult-atualiz
    index tmpAttachment1
          cdd_anexo.
 
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
/* --- ESTA TABELA Eh USADA COMO:
       OUTPUT - QUANDO RETORNA AS RESTRICOES DO USUARIO/GRUPO;
       INPUT  - AO CRIAR/ATUALIZAR NOVOS REGISTROS NA BASE  --- */
def temp-table tmpConfigFileAuditory no-undo
    field nm-tabela           like config-audit-cad.nm-tabela
    field nm-campo            like config-audit-cad.nm-campo           
    field lg-obrigatorio      like config-audit-cad.lg-obrigatorio     
    field lg-visivel          like config-audit-cad.lg-visivel         
    field lg-editavel         like config-audit-cad.lg-editavel        
    field lg-auditavel        like config-audit-cad.lg-auditavel

    /* --- ESTE INDICA QUE DEVE SER OBRIGATORIO NA TELA DE CONFIGURACAO E NAO PODE SER ALTERADO PELO USUARIO --- */
    field lg-nao-mudar        like config-audit-cad.lg-obrigatorio

    /* --- SOMENTE Eh UTILIZADO QUANDO A TABELA Eh USADA COMO INPUT --- */
    field nm-grupo            like config-audit-cad.nm-grupo

/* --- Campos da tmpFileAuditoryBySystemUser adicionados --- */

    /* --- USUARIO LOGADO NO SISTEMA NO MOMENTO --- */
    field nm-usuario-sistema  as char

    /* --- CASO ESTEJA ATUALIZANDO UMA PESSOA, DEVE ENVIAR O ID --- */
    field id-pessoa           like pessoa-fisica.id-pessoa

    /* --- INDICA QUE A PESSOA ESTA SENDO RELACIONADA A UM BENEFICIARIO DE MEDICINA OCUPACIONAL --- */
    field lg-benef-med-ocup   as log

    /* --- INDICA QUE A PESSOA ESTA SENDO RELACIONADA A UM CONTRATANTE --- */
    field lg-contratante      as log

    /* --- INDICA QUE A PESSOA ESTA SENDO RELACIONADA A UM PRESTADOR --- */
    field lg-prestador        as log.  

def temp-table tmpConfigFileAuditoryAux no-undo like tmpConfigFileAuditory.

def temp-table tmpConfigFileAuditoryMirror no-undo like tmpConfigFileAuditory.

def temp-table tmpConfigFileAuditoryMD no-undo
    field nm_tabela          like config-audit-cad.nm-tabela
    field nm_campo           like config-audit-cad.nm-campo           
    field lg_obrigatorio     like config-audit-cad.lg-obrigatorio     
    field lg_visivel         like config-audit-cad.lg-visivel         
    field lg_editavel        like config-audit-cad.lg-editavel        
    field lg_auditavel       like config-audit-cad.lg-auditavel
    field lg_nao_mudar       like config-audit-cad.lg-obrigatorio
    field nm_grupo           like config-audit-cad.nm-grupo
    field nm_usuario_sistema as char
    field id_pessoa          like pessoa-fisica.id-pessoa
    field lg_benef_med_ocup  as log
    field lg_contratante     as log
    field lg_prestador       as log.  


 

/*/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
def var h-handle-aux              as handle no-undo.
def var h-handle2-aux             as handle no-undo.

def new shared var id-requisicao-handle-aux as char init "" no-undo.
*/
def new global shared var v_cod_usuar_corren as char no-undo.
 

def var h-bosauDemographic-aux          as handle                       no-undo.
def var h-bosauCompany-aux              as handle                       no-undo.
def var h-bosauAttachment-aux           as handle                       no-undo.
def var h-apiadministrativeintegration-aux   as handle no-undo.
 
/*---------------------- Variaveis Programa mc0910ax.p ------------------*/
def     shared var lg-medocup-aux        as logical                     no-undo.

def new shared var nr-proposta-aux        like usuario.nr-proposta      no-undo.
def     shared var nr-proposta-imp-aux    like propost.nr-proposta      no-undo.
def     shared var r-propost              as recid                      no-undo.
def            var dt-inclu               like usuario.dt-inclusao-plano no-undo.
DEF SHARED VAR lg-gerar-termo-aux AS LOG NO-UNDO.
def     shared var lg-carteira-antig-aux  as log                        no-undo.

def var lg-inclui-automatico-aux          as log                       no-undo.
def var lg-undo-retry                     as log init no                no-undo.
def var ds-mensagem-aux                   as char format "x(80)"        no-undo.
def var r-registro                        as recid                      no-undo.
def var c-ponto                           as char                       no-undo.
def var l-erro-x                          as log                        no-undo.
def var lg-retorna                        as log initial no             no-undo.
def var lg-desfaz-create                  as log initial no             no-undo.
def var lg-mensagem                       as log initial no             no-undo.
def var cd-tipo-mens                      as char format "x(01)"        no-undo.                     
def var ds-tipo-mens                      as char format "x(90)"        no-undo.                     
def var qt-pessoas-aux                    like pr-id-us.qt-pessoas      no-undo.                     
def var c-versao                          as char format "x(08)"        no-undo.                     
def var lg-inf-mae-aux               like paravpmc.lg-inf-mae           no-undo.                     
def var lg-inf-cpf-pis-cartaonac-aux like paravpmc.lg-inf-cpf-pis-cartaonac                          
                                                                        no-undo.

def var char-aux1 as char no-undo.
def var char-aux2 as char no-undo.

assign c-versao = "7.20.003".

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
    
 
 
def new shared var  nr-insc-contrat-aux   like  propost.nr-insc-contratante
                                                                        no-undo.
def new shared var  cd-unimed-origem-aux  like  car-ide.cd-unimed       no-undo.
def new shared var  cd-modalidade-car-aux like  car-ide.cd-modalidade   no-undo.
def new shared var  cd-usuario-aux        like  car-ide.cd-usuario      no-undo.
def            var  ct-codigo             like usuario.cd-usuario       no-undo.
def            var  nr-usuarios           as int format "999999999"     no-undo.
def new shared var  lg-volta              as log                        no-undo.
def var lg-erro-masc                      as log                        no-undo.
def var c-dig-mascara    as char format "x".
def var dt-ini-vinculo-aux                as date format "99/99/9999"   no-undo.
/* -------------------------------------------------------------------------- */
 
def new shared var ix2                   as int  format "99"            no-undo.
def new shared var nr-carteira-aux       as character  format "x(16)"   no-undo.
def new shared var dv-carteira-aux       as integer    format "9"       no-undo.
def new shared var lg-resp               as logical                     no-undo.
def new shared var cd-dv                 as character  format "x(14)"   no-undo.
def new shared var nr-cgc-z              like contrat.nr-cgc-cpf        no-undo.
def new shared var cd-cpf-aux            like contrat.nr-cgc-cpf        no-undo.
 
def            var tt-vezes              as int format "99"             no-undo.
 
def var ct-cont                          as inte.
def var ds-mascara-aux                   like propost.ds-mascara        no-undo.  
 
/*------- Variaveis p/ rotina do nome internacional (rtcarint.p) ------------*/
 
def new shared var ix                     as int  format "99"           no-undo.
def new shared var letra-aux              as char format "x(1)"         no-undo.
def new shared var nome-aux               as char format "x(20)"        no-undo.
def new shared var nome-abrev-usu         as char format "x(40)"        no-undo.
def new shared var nome-abrev-cartao      as char format "x(28)"        no-undo.
def new shared var nome-usuario-aux       like usuario.nm-usuario       no-undo.
def new shared var cartao-aux            like usuario.nm-usuario-cartao no-undo.
def new shared var nome-cartao-usu       as char format "x(28)"         no-undo.
def new shared var lg-branco             as log                         no-undo.
def new shared var nm-usuario-aux        like usuario.nm-usuario        no-undo.
def new shared var ix-vezes              as int  format "99"            no-undo.
def new shared var nome-abrev            as char format "x(40)"         no-undo.
def new shared var nome-abrev1           as char format "x(40)"         no-undo.
def new shared var nome-abrev2           as char format "x(40)"         no-undo.
def new shared var nome-ult              as char format "x(20)"         no-undo.
 
/*---------------------------------------------------------------------------*/
def shared var lg-prim               as logi                            no-undo.
 
def shared var cd-empresa            like  userlog.cd-contratante       no-undo.
def        var lg-sexo-aux           like  usuario.lg-sexo              no-undo.
def        var dt-admissao-aux       like usuario.dt-admissao-empresa   no-undo.
 
def shared var lg-relat-erro         as log                             no-undo.
def        var lg-relat-erro-aux     as log                             no-undo.

/* ----------------------- Variaveis de Trabalho ---------------------------- */
 
def var cd-busc-titular              as char  format "!!"               no-undo.
def var c-data                       as char                            no-undo.
def var c-hora                       as char                            no-undo.
def var lg-achou                     as logi                            no-undo.
def var lg-critica                   as logi                            no-undo.
def var nr-idade-usuario             as inte                            no-undo.
def var cd-unimed-cart               like usuario.cd-unimed             no-undo.
def var cd-modalidade-cart           like usuario.cd-modalidade         no-undo.
def var cd-titular-cart              like usuario.cd-usuario            no-undo.
def var cd-carteira-cart             like car-ide.nr-carteira           no-undo.
def var nr-faixa-etaria              like pl-gr-pa.nr-faixa-etaria      no-undo.
def var lg-erro-aux                  as log format "Sim/Nao"            no-undo.
def var r-proposta                   as recid                           no-undo.
def var r-paravpmc                   as recid                           no-undo.
def var lg-insc-taxa-aux             as log                             no-undo.
def var lg-insc-fat-aux              as log                             no-undo.
def var cd-cidade-aux                like usuario.cd-cidade             no-undo.
def var dt-fim-aux                   as date                            no-undo. 
def var ds-movto-aux                 as char format "x(14)"             no-undo.
def var lg-cpc-aux                   as log                             no-undo.
def var lg-continua-aux              as log                             no-undo.
def var lg-cpc-cobra-partic-aux      as log                             no-undo.
def var lg-atribui-fator-aux         as log                             no-undo.
def var lg-cobra-fator-aux           as log                             no-undo.
def var lg-erro-cpc-aux              as log                             no-undo.
def var cd-plano-ans-aux             as int                             no-undo.

/* ------------------- Variaveis para acesso tabela funccbo ----------------- */
def new shared var  c-descricao-aux  as    char   format "x(50)"        no-undo.
 
/*----------- VARIAVEIS PARA SELECTIO-LIST DO IN-SEGMENTO-ASSISTENCIAL ------*/
def            var lista-segmento-posicao-aux    as char                no-undo.
                            
assign lista-segmento-posicao-aux = "01,02,03,04,05,06,07,08,10,11,13,14".

/*----------------------------------------------------------------------------*/
def var lg-ok-aux                              as log                   no-undo.
def var ds-mens-aux                            as char format "x(70)"   no-undo.
def var nr-digito-aux                          as int                   no-undo.

def var lg-erro-reajus1-aux                    as log                   no-undo.
def var ds-mensagem-reajus1-aux                as char                  no-undo.
def var nr-ident-compl-aux                     as int                   no-undo.
def var cd-modulo-aux        like mod-cob.cd-modulo                     no-undo.
def var nr-dias-bonif-aux    like propcopa.nr-dias-bonificacao          no-undo.
DEF VAR nr-pessoas-total                       AS INT                   NO-UNDO.
def var cd-tab-preco-aux                       as char format "x(5)"    no-undo. 
def var lg-procedimento-aux                    as log                   no-undo.


DEF SHARED TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-seq            AS INT
    FIELD nr-seq-contr      LIKE erro-process-import.num-seqcial-control 
    FIELD nom-tab-orig-erro AS CHAR
    FIELD des-erro          AS CHAR
	field des-ajuda         as char
    INDEX nr-seq       
          nr-seq-contr.

DEF SHARED TEMP-TABLE tt-import-bnfciar NO-UNDO
    FIELD rowid-import-bnfciar AS ROWID
    FIELD nome-usuario         like usuario.nm-usuario 
    field nome-abrev-usu       as char format "x(40)"           
    field nome-usuario-aux     like usuario.nm-usuario          
    field cartao-aux           like usuario.nm-usuario-cartao   
    field nome-cartao-usu      as char format "x(28)"
    FIELD lg-insc-fat          as LOG
    FIELD cd-cidade            like usuario.cd-cidade
    FIELD nr-idade-usuario     AS INT
    FIELD nr-faixa-etaria      AS INT
    INDEX id rowid-import-bnfciar.

DEF BUFFER b-tt-erro        FOR tt-erro.
def buffer b-import-bnfciar for import-bnfciar.
DEF BUFFER b2-usucarproc    FOR usucarproc.
DEF BUFFER b-usucarproc     FOR usucarproc.


FUNCTION proximaseqregra RETURNS DECIMAL (): 

    DEF VAR prox-seq-par AS DEC INITIAL 0 NO-UNDO.

    SELECT MAX(cdd-seq) INTO prox-seq-par FROM regra-menslid-propost.
                                      
    IF prox-seq-par = ?
    THEN prox-seq-par = 0. 

    RETURN (prox-seq-par + 1).

END FUNCTION.


find first paramecp no-lock.

FIND FIRST paravpmc NO-LOCK.

{hdp/hdrunpersis.i "api/api-usmovadm.p" "h-api-usmovadm-aux"}

/* ------------------- CHAMADA DE INCLUDE DA ROTINA CONSISTENCIA ENDERECO --- */
/******************************************************************************
*      Programa .....: rtendere.i                                             *
*      Data .........: 11 de novembro 2003                                    *
*      Sistema ......: RT - ROTINAS PADRAO                                    *
*      Empresa ......: DZSET Solucoes e Sistemas                              *
*      Programador ..: Rafael F. Ceron                                        *
*      Objetivo .....: Definicao de variaveis compartilhadas entre o programa *
*                      chamador e a rotina rtendere.p                         *
******************************************************************************/
def new shared temp-table tmp-mensa-rtendere                                  no-undo
    field cd-mensagem-mens                   like mensiste.cd-mensagem
    field ds-mensagem-mens                   like mensiste.ds-mensagem-sistema
    field ds-complemento-mens                like mensiste.ds-mensagem-sistema
    field in-tipo-mensagem-mens              like mensiste.in-tipo-mensagem
    field ds-chave-mens                      like mensiste.ds-mensagem-sistema.
/* ------------------------------ VARIAVEIS COMPARTILHADAS NA API ----------- */

def new shared var lg-erro-rtendere-aux             as log                     no-undo.
def new shared var lg-prim-mens-rtendere-aux        as log                     no-undo.

/* ------------------------------ VARIAVEIS INTERNAS DA API ----------------- */

def new shared var in-modulo-sistema-rtendere-aux   as char format "x(2)"      no-undo.
def new shared var in-tipo-rtendere-aux             as char format "x(1)"      no-undo.
/* in-tipo-rtendere-aux = B (beneficiario) , C (contratante) , P (prestador)*/
def new shared var in-tipo-tela-rtendere-aux        as log                     no-undo.
/*Sim p/ tela || NÆo p/ relatorio*/

def new shared var proposta-rowid                   as rowid                   no-undo.

def new shared var in-tp-rtendere-aux               like parapess.in-tipo-pessoa no-undo.

def new shared var cd-cidade-rtendere-aux           like dzcidade.cd-cidade    no-undo.
def new shared var nm-cidade-rtendere-aux           like dzcidade.nm-cidade    no-undo.


def new shared var en-uf-rtendere-aux               like usuario.en-uf         no-undo.
def new shared var en-cep-rtendere-aux              like usuario.en-cep        no-undo. 
def new shared var en-rua-rtendere-aux              like usuario.en-rua        no-undo.
def new shared var en-bairro-retendere-aux          like usuario.en-bairro     no-undo.

/* ------------------------------------------------------------------------- */

/* -------------------------------------------------------------------------- */
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


 
/************************************************************************************************
*      Programa .....: srrepres.iv                                                              *
*      Data .........: 08 de Junho de 2001.                                                     *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                                          *
*      Sistema ......: SRINCL - INCLUDES PARA CONVERSAO DE SISTEMAS                             *
*      Cliente ......: COOPERATIVAS MEDICAS                                                     *
*      Programador ..: Leonardo Deimomi                                                         *
*      Objetivo .....: Definicao de variaveis do include srrepres.i                             *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      E.00.000  08/06/2001  Leonardo        Desenvolvimento                                    *
************************************************************************************************/

def var lg-avail-srrepres        as log                      no-undo.
def var nm-representante-srems   like contrat.nm-contratante no-undo.
def var ds-natureza-repres-srems as char format "x(1)"       no-undo.
def var nr-cpf-cgc-repres-srems  like contrat.nr-cgc-cpf     no-undo.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE cria-registros:

    FOR EACH tt-import-bnfciar EXCLUSIVE-LOCK,
        FIRST b-import-bnfciar WHERE ROWID (b-import-bnfciar) = tt-import-bnfciar.rowid-import-bnfciar EXCLUSIVE-LOCK /*,
        FIRST import-propost NO-LOCK
        WHERE import-propost.nr-contrato-antigo = b-import-bnfciar.nr-contrato-antigo*/ :
    
        process events.

        l-inclusao-dados:
        do on error undo, retry:
    
           ASSIGN qt-cont-sair-aux = qt-cont-sair-aux + 1.

           /* --- CRIA BENEF --------------- */
           ASSIGN lg-relat-erro = NO.
           RUN cria-beneficiario.
           
           IF lg-relat-erro
           THEN DO:
                  RUN remover.
                  DELETE tt-import-bnfciar.
                  NEXT.
                END.
           
           /* --- CRIA MODULOS BENEF ------- */
           RUN cria-modulos-benef.
           
           /* --- CRIA REPASSE BENEF ------- */
           ASSIGN lg-relat-erro = NO.
           RUN cria-repasse-benef.
    
           IF lg-relat-erro
           THEN DO:
                  RUN remover.
                  DELETE tt-import-bnfciar.
                  NEXT.
                END.
    
           /* --- CRIA REPASSE ATEND BENEF ------- */
           ASSIGN lg-relat-erro = NO.
           RUN cria-repasse-atend-benef.
    
           IF lg-relat-erro
           THEN DO:
                  RUN remover.
                  DELETE tt-import-bnfciar.
                  NEXT.                    
                END.
    
           /* --- CRIA CARENCIA ESPECIAL BENEF ------- */
           ASSIGN lg-relat-erro = NO.
           RUN cria-pad-cob-benef.
    
           IF lg-relat-erro
           THEN DO:
                  RUN remover.
                  DELETE tt-import-bnfciar.
                  NEXT.
                END.

           /* --- CRIA PRODUTO EXTERNO ------- */
                /* CRIAR USMOVADM NO FINAL COM O SCRIPT DE APOIO!
           IF lg-gerar-termo-aux
           THEN DO:
                  ASSIGN lg-relat-erro = NO.
                  RUN cria-usmovadm.
                  
                  IF lg-relat-erro
                  THEN DO:
                         RUN remover.
                         DELETE tt-import-bnfciar.
                         NEXT.
                       END.
                END.*/

           ASSIGN b-import-bnfciar.ind-sit-import = "IT".
                  
           VALIDATE b-import-bnfciar.
           RELEASE  b-import-bnfciar.
           
           DELETE tt-import-bnfciar.
    
        END.
    END.

END PROCEDURE.

PROCEDURE cria-beneficiario:

    def var cd-senha-aux           as int format 999999                     no-undo.
    def var lg-erro-rtsenha-aux    as log                                   no-undo.
    def var ds-erro-rtsenha-aux    as char                                  no-undo.

    def var cd-cart-inteira-aux like car-ide.cd-carteira-inteira     no-undo.
    def var dv-cart-inteira-aux like car-ide.dv-carteira             no-undo.
    def var cd-cart-impress-aux as char format "x(22)"               no-undo.
    def var lg-grava-carteira      as logical initial yes                   no-undo.
    DEF VAR dt-validade-aux AS DATE NO-UNDO.

    /* -------------------------------------------- VARIAVEIS ROTINA RTVALDOC ---*/
    def var lg-erro-valdoc               as log     init no                no-undo.
    def var ds-mensagem-valdoc           as char format "x(75)"            no-undo.
    def var dt-validade-valdoc           as date                           no-undo.
    def var lg-renova-valdoc             as log                            no-undo.

    DEF VAR cd-empresa-aux     AS INT NO-UNDO.
    DEF VAR cd-familia-aux     AS INT NO-UNDO.
    DEF VAR cd-dependencia-aux AS INT NO-UNDO.
    DEF VAR idi-registro-aux   AS INT NO-UNDO.

    DEF BUFFER b2-import-bnfciar FOR import-bnfciar.

    l-inclusao:
    do on error undo, retry:
    
       /* -------------------------------------------------------- */
       FOR FIRST modalid FIELDS (nr-dig-adesao pc-afericao)
           WHERE modalid.cd-modalidade = b-import-bnfciar.cd-modalidade NO-LOCK:
       END.

       FOR FIRST propost USE-INDEX propo24
           WHERE propost.nr-contrato-antigo = b-import-bnfciar.nr-contrato-antigo NO-LOCK:
       END.

       FOR FIRST contrat
           WHERE contrat.nr-insc-contratante = propost.nr-insc-contratante no-lock:
       END.

       IF lg-gerar-termo-aux
       AND propost.nr-ter-adesao <> 0
       THEN DO:
              FOR FIRST ter-ade
                  WHERE ter-ade.cd-modalidade = propost.cd-modalidade
                    AND ter-ade.nr-ter-adesao = propost.nr-ter-adesao no-LOCK:
              END.
              IF NOT AVAIL ter-ade
              THEN DO:
                     assign lg-relat-erro = yes.
                     IF propost.cd-modalidade <> ?
                     THEN ASSIGN char-aux1 = STRING(propost.cd-modalidade).
                     ELSE ASSIGN char-aux1 = "nulo".
                     IF propost.nr-ter-adesao <> ?
                     THEN char-aux2 = STRING(propost.nr-ter-adesao).
                     ELSE char-aux2 = "nulo".
                     RUN pi-cria-tt-erros("Termo nao encontrado. Modalidade: " + char-aux1
                                          + " Termo: " + char-aux2).
                     LEAVE l-inclusao.
                   END.
            END.
       FOR FIRST b-usuario FIELDS (cd-titular id-pessoa cd-usuario cdn-respons-financ cdn-lotac) USE-INDEX usuari26
           where b-usuario.cd-carteira-antiga = b-import-bnfciar.cd-carteira-origem-responsavel NO-LOCK:
       END.

       /**
        * Tratamento do REGISTRO PLANO ANS
        */
       if propost.in-registro-plano = 2 /* registro ANS no beneficiario */
       then do:
              /* plano eh regulamentado */
              if b-import-bnfciar.cd-registro-plano <> 0 and b-import-bnfciar.cd-registro-plano <> ?
              then for first reg-plano-saude fields(idi-registro)
                       where reg-plano-saude.cdn-plano-ans = b-import-bnfciar.cd-registro-plano 
                             no-lock query-tuning(no-index-hint): 
                             
    RUN escrever-log("@@@@@procurando REG-PLANO-SAUDE(p1). propost.in-registro-plano: " + string(propost.in-registro-plano) + 
                     " b-import-bnfciar.cd-registro-plano: " +  string(b-import-bnfciar.cd-registro-plano) + 
                     " reg-plano-saude.idi-registro: " + string(reg-plano-saude.idi-registro)
                     ).

                             
                   end.
              else /* plano nao regulamentado ou adaptado*/
                   for first import-propost fields (num-livre-8) 
                       where import-propost.nr-contrato-antigo = propost.nr-contrato-antigo no-lock:

                       for first reg-plano-saude fields(idi-registro)
                           where reg-plano-saude.cod-plano-operadora    = b-import-bnfciar.cd-plano-operadora 
                             and reg-plano-saude.in-tipo-regulamentacao = import-propost.num-livre-8
                                 no-lock query-tuning (no-index-hint): 
                                 
    RUN escrever-log("@@@@@procurando REG-PLANO-SAUDE(p2). propost.in-registro-plano: " + string(propost.in-registro-plano) + 
                     " b-import-bnfciar.cd-plano-operadora: " + string(b-import-bnfciar.cd-plano-operadora) +
                     " reg-plano-saude.idi-registro: " + string(reg-plano-saude.idi-registro)
                     ).

                                 
                       end.
                   end.
            end.
       /**/

       /**
        * Gerar proximo cd-usuario e criar o buffer USUARIO
        * SE NUM_LIVRE_6 ESTIVER PREENCHIDO, CONSIDERAR COMO CD-USUARIO. CASO CONTRARIO GERAR SEQUENCIAL CONFORME REGRA ANTIGA
        */
       IF b-import-bnfciar.num-livre-6 <> ?
       AND b-import-bnfciar.num-livre-6 <> 0
       THEN DO:
              ASSIGN ct-codigo = b-import-bnfciar.num-livre-6.
              RUN escrever-log("@@@@@Assumindo codigo do beneficiario conforme num-livre-6 para MODALIDADE: " + STRING(b-import-bnfciar.cd-modalidade) +
                               " PROPOSTA: " + STRING(propost.nr-proposta) + 
                               " USUARIO: " + STRING(ct-codigo)).
       END.
       ELSE DO:
              RUN escrever-log("@@@@@Antes de buscar proximo ct-usuario para MODALIDADE: " + STRING(b-import-bnfciar.cd-modalidade) +
                               " PROPOSTA: " + STRING(propost.nr-proposta)).
       
              FOR last usuario FIELDS (cd-usuario)
                 where usuario.cd-modalidade = b-import-bnfciar.cd-modalidade 
                   and usuario.nr-proposta   = propost.nr-proposta NO-LOCK:
              END.
              if   not available usuario
              then assign ct-codigo = 1.
              else assign ct-codigo = usuario.cd-usuario + 1.
       
              RUN escrever-log("@@@@@Proximo ct-usuario: " + STRING(ct-codigo)).
       END.

       if modalid.nr-dig-adesao = 4
       then do:
              if ct-codigo > 999999
              then do:
                     assign lg-relat-erro = yes.
                     RUN pi-cria-tt-erros("Numero limite de beneficiarios na proposta foi ultrapassado").
                     UNDO l-inclusao, LEAVE l-inclusao.
                   end.
            end.
       else do:
              if ct-codigo > 99999
              then do:
                     assign lg-relat-erro = yes.
                     RUN pi-cria-tt-erros("Numero limite de beneficiarios na proposta foi ultrapassado").
                     UNDO l-inclusao, LEAVE l-inclusao.
                   end.
            end.

       RUN escrever-log("@@@@@Antes de criar USUARIO. MODALIDADE: " + STRING(b-import-bnfciar.cd-modalidade) +
                        " PROPOSTA: " + STRING(propost.nr-proposta) + 
                        " TERMO: " + STRING(propost.nr-ter-adesao) +
                        " UNIMED: " + STRING(paramecp.cd-unimed) +
                        " USUARIO: " + STRING(ct-codigo)).

       create usuario.
       REPEAT:
           if modalid.nr-dig-adesao = 4
           then do:
                  if ct-codigo > 999999
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Numero limite de beneficiarios na proposta foi ultrapassado").
                         UNDO l-inclusao, LEAVE l-inclusao.
                       end.
                end.
           else do:
                  if ct-codigo > 99999
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Numero limite de beneficiarios na proposta foi ultrapassado").
                         UNDO l-inclusao, LEAVE l-inclusao.
                       end.
                end.

           assign usuario.cd-modalidade      = b-import-bnfciar.cd-modalidade
                  usuario.nr-proposta        = propost.nr-proposta           
                  usuario.nr-ter-adesao      = propost.nr-ter-adesao
                  usuario.cd-unimed          = paramecp.cd-unimed
                  usuario.cd-usuario         = ct-codigo NO-ERROR.
           VALIDATE usuario NO-ERROR.
           IF ERROR-STATUS:ERROR
           OR ERROR-STATUS:NUM-MESSAGES > 0
           THEN do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros2("Chave do beneficiario ja esta em uso. Verifique se o processo esta tentando recriar o mesmo registro.",
                                        "Modalidade: " + string(b-import-bnfciar.cd-modalidade) +
                                        ". Proposta: " + string(propost.nr-proposta) + 
                                        ". Beneficiario: " + string(ct-codigo)).
                  RUN escrever-log("@@@@@abandonando pois ct-usuario ja esta em uso. Verifique se esta tentando recriar o mesmo registro " + STRING(ct-codigo)).
                  UNDO l-inclusao, LEAVE l-inclusao.
                END.
           else do:
                  if lg-carteira-antig-aux
                  then do:
                         assign cd-cart-inteira-aux = b-import-bnfciar.cd-carteira-antiga.
                         LEAVE.
                       end.
                  else do:
                         /* ----- MONTA O CODIGO DA CARTEIRA E CALCULA O DIGITO -------------- */
                         /**
                          * Garantir que nao exista carteira antiga com o mesmo codigo da carteira que esta sendo gerada.
                          */
                         run value (substring (paravpmc.nm-prog-monta-cart, 1, 2) + "p/" +
                                               paravpmc.nm-prog-monta-cart + ".p")
                                   (input  1,
                                    input  recid (usuario),
                                    input  0,
                                    input  1 /*nr-via-carteira-aux*/ ,
                                    input  NO /*reutiliza carteira*/ ,
                                    output cd-cart-inteira-aux,
                                    output dv-cart-inteira-aux,
                                    output cd-cart-impress-aux,
                                    output lg-undo-retry).

                         IF CAN-FIND(FIRST b2-import-bnfciar
                                     WHERE b2-import-bnfciar.cd-carteira-antiga = cd-cart-inteira-aux)
                         THEN ASSIGN ct-codigo = ct-codigo + 1.
                         ELSE leave.    /* o nr gerado eh valido. continua o processo.*/
                       END.
                end.
       END. /*repeat*/

       RUN escrever-log("@@@@@Depois de criar USUARIO").

       ASSIGN usuario.id-pessoa                = b-import-bnfciar.num-seqcial
              usuario.nm-usuario               = b-import-bnfciar.nom-usuario  /* alterado em 07/05/18 pois truncava em 40 posicoes    caps(tt-import-bnfciar.nome-usuario)*/
              usuario.cd-cbo                   = b-import-bnfciar.cd-cbo
              usuario.dt-inclusao-plano        = b-import-bnfciar.dt-inclusao-plano
              usuario.dt-exclusao-plano        = b-import-bnfciar.dt-exclusao-plano 
              usuario.cd-motivo-cancel         = b-import-bnfciar.cd-motivo-cancel
              usuario.dt-mov-exclusao          = if b-import-bnfciar.dt-exclusao-plano <> ?
                                                 then today
                                                 else ?
              usuario.cd-userid-exclusao       = if b-import-bnfciar.dt-exclusao-plano <> ?
                                                 then v_cod_usuar_corren
                                                 else ""
              usuario.dt-atualizacao           = today
              usuario.cd-funcionario           = b-import-bnfciar.cd-funcionario
              usuario.cd-carteira-antiga       = b-import-bnfciar.cd-carteira-antiga
              usuario.int-16                   = 1  /** Define o endere‡o como residencial (SIB XML) */
              usuario.int-14                   = 0  /** Limpa o campo da cidade de residˆncia        */

              /*usuario.ds-observacao[1]         = caps("Contrato Antigo: " + b-import-bnfciar.nr-contrato-antigo) 
                                               + caps(". Carteira Antiga: " + substr(string(b-import-bnfciar.cd-carteira-antiga,"9999999999999"),1,13))*/

              usuario.ds-observacao[1]         = CAPS("PLANO NO UNICOO: " + b-import-bnfciar.cod-livre-1)

              usuario.in-segmento-assistencial = b-import-bnfciar.in-segmento-assistencial
              usuario.cd-identific-orig-resp   = b-import-bnfciar.cd-identific-orig-resp
              usuario.cd-userid                = v_cod_usuar_corren
              usuario.cd-padrao-cobertura      = caps(b-import-bnfciar.cd-padrao-cob)
              usuario.cd-userid-inclusao       = v_cod_usuar_corren
              usuario.dt-mov-inclusao          = b-import-bnfciar.dt-inclusao-plano
              usuario.nr-telefone1             = b-import-bnfciar.nr-telefone1
              usuario.nr-telefone2             = b-import-bnfciar.nr-telefone2
              usuario.nm-email                 = b-import-bnfciar.nom-email
              usuario.cd-vendedor              = b-import-bnfciar.cd-vendedor
              usuario.in-via-transferencia     = caps(b-import-bnfciar.in-via-transferencia)
              usuario.ds-nacionalidade         = caps(b-import-bnfciar.des-nacion)
              usuario.ds-natureza-doc          = caps(b-import-bnfciar.des-natur-docto)
              usuario.date-12                  = b-import-bnfciar.dt-inclusao-plano                 
              usuario.char-21                  = STRING(TIME,"hh:mm:ss")
              usuario.char-22                  = "MIGRACAO"
              usuario.cd-userid-carencia       = "MIGRACAO"
              usuario.dt-atualizacao-carencia  = TODAY
              usuario.dt-data-reativa          = b-import-bnfciar.dat-livre-2.  /* data de inicio do beneficiario no plano de DEMITIDO/APOSENTADO */

       /* ALEX 11/07/18 - VERSAO ANTERIOR FORCAVA NOS DEPENDENTES A MESMA LOTACAO E RESPONSAVEL FINANCEIRO DO TITULAR.
        *                 EXTRATOR FOI AJUSTADO PARA PREENCHER NUM-LIVRE-1 E NUM-LIVRE-2 COM A INFORMACAO CORRETA QUE DEVE SER LEVADA PARA O GPS.
       if b-import-bnfciar.log-respons = NO
       AND AVAIL b-usuario 
       THEN ASSIGN usuario.cdn-respons-financ = b-usuario.cdn-respons-financ
                   usuario.cdn-lotac          = b-usuario.cdn-lotac
                   usuario.int-22             = b-usuario.int-22. /* dia de vencimento DO contrato de DEMITIDO/APOSENTADO */
       ELSE ASSIGN usuario.cdn-respons-financ = b-import-bnfciar.num-livre-2  /* cdn-respons-financ */
                   usuario.cdn-lotac          = b-import-bnfciar.num-livre-1  /* cdn-lotac */
                   usuario.int-22             = b-import-bnfciar.num-livre-3. /* dia de vencimento DO contrato de DEMITIDO/APOSENTADO */
       */

       ASSIGN usuario.cdn-respons-financ = b-import-bnfciar.num-livre-2  /* cdn-respons-financ */
              usuario.cdn-lotac          = b-import-bnfciar.num-livre-1.  /* cdn-lotac */

       if   usuario.cd-vendedor = 0
       then usuario.cd-vendedor = propost.cd-vendedor.
       
       if propost.lg-pea = yes
       then assign usuario.in-via-transferencia = "S".

       /**
        * Se dat-livre-2 esta preenchido significa que eh APOSENTADO/DEMITIDO. Nesse caso, criar HISTOR_OCOR_USUAR para guardar DESLIGAMENTO 
        * do plano anterior e INICIO no beneficio.
        * se for titular, gravar tambem a tabela MOTIV-DEMIS, que eh o questionario da entrada no plano de Demitido/Aposentado
        */
       IF b-import-bnfciar.dat-livre-2 <> ?
       THEN DO:
              for LAST histor-ocor-usuar fields(idi-registro) USE-INDEX hstrcrsr_id2 NO-LOCK:
              END.
              IF AVAIL histor-ocor-usuar
              THEN idi-registro-aux = histor-ocor-usuar.idi-registro + 1.
              ELSE idi-registro-aux = 1.
              
              repeat:
                if next-value(seq-histor-ocor-usuar) > idi-registro-aux then leave.
                RUN escrever-log("@@@@@incrementando seq-histor-ocor-usuar ate: " + STRING(idi-registro-aux)).
              end.
              
              create histor-ocor-usuar.
              REPEAT:
                  assign histor-ocor-usuar.idi-registro = next-value(seq-histor-ocor-usuar) NO-ERROR.
                  VALIDATE histor-ocor-usuar NO-ERROR.
                  IF ERROR-STATUS:ERROR
                  OR ERROR-STATUS:NUM-MESSAGES > 0
                  THEN do:
                         RUN escrever-log("@@@@@(p2)idi-registro-aux para histor-ocor-usuar: " + STRING(idi-registro-aux)).
                       END.
                  else LEAVE.
              END. /*repeat*/
              RUN escrever-log("@@@@@HISTOR-OCOR-USUAR(p3) com idi-registro-aux: " + STRING(idi-registro-aux)).

              /* historico do desligamento do plano normal (empresa).*/
              assign histor-ocor-usuar.cd-modalidade         = usuario.cd-modalidade
                     histor-ocor-usuar.nr-proposta           = usuario.nr-proposta
                     histor-ocor-usuar.cd-usuario            = usuario.cd-usuario
                     histor-ocor-usuar.idi-tip-ocor          = 25 /*exclusao*/
                     histor-ocor-usuar.dt-exclusao-plano     = b-import-bnfciar.dat-livre-3
                     histor-ocor-usuar.dat-alter             = b-import-bnfciar.dat-livre-3
                     histor-ocor-usuar.dat-ult-atualiz       = TODAY
                     histor-ocor-usuar.hra-ult-atualiz       = string(time,"HH:MM:SS")
                     histor-ocor-usuar.cod-usuar-ult-atualiz = v_cod_usuar_corren
                     histor-ocor-usuar.cod-usuar-alter       = v_cod_usuar_corren.
                     
              create histor-ocor-usuar.
              REPEAT:
                  assign histor-ocor-usuar.idi-registro = next-value(seq-histor-ocor-usuar) NO-ERROR.
                  VALIDATE histor-ocor-usuar NO-ERROR.
                  IF ERROR-STATUS:ERROR
                  OR ERROR-STATUS:NUM-MESSAGES > 0
                  THEN do:
                         RUN escrever-log("@@@@@idi-registro-aux para histor-ocor-usuar(p5): " + STRING(idi-registro-aux)).
                       END.
                  else LEAVE.
              END. /*repeat*/
              RUN escrever-log("@@@@@HISTOR-OCOR-USUAR(p6) com idi-registro-aux: " + STRING(idi-registro-aux)).

              /* historico da reativacao no beneficio de DEMITIDO/APOSENTADO.*/
              assign histor-ocor-usuar.cd-modalidade         = usuario.cd-modalidade
                     histor-ocor-usuar.nr-proposta           = usuario.nr-proposta
                     histor-ocor-usuar.cd-usuario            = usuario.cd-usuario
                     histor-ocor-usuar.idi-tip-ocor          = 26 /*reativacao*/
                     histor-ocor-usuar.dat-alter             = b-import-bnfciar.dat-livre-2
                     histor-ocor-usuar.dat-ult-atualiz       = TODAY
                     histor-ocor-usuar.hra-ult-atualiz       = string(time,"HH:MM:SS")
                     histor-ocor-usuar.cod-usuar-ult-atualiz = v_cod_usuar_corren
                     histor-ocor-usuar.cod-usuar-alter       = v_cod_usuar_corren.
                     
              /* SE FOR TITULAR, GRAVAR QUESTIONARIO DEMITIDO/APOSENTADO*/
              if b-import-bnfciar.log-respons = YES
              THEN DO:
                     find motiv-demis where motiv-demis.cdn-modalid = usuario.cd-modalidade
                                        and motiv-demis.num-propost = usuario.nr-proposta
                                        and motiv-demis.cdn-usuar   = usuario.cd-usuario
                                            exclusive-lock no-error.
                     if not avail motiv-demis
                     then do:                
                            create motiv-demis.
                            assign motiv-demis.cdn-modalid           = usuario.cd-modalidade
                                   motiv-demis.num-propost           = usuario.nr-proposta  
                                   motiv-demis.cdn-usuar             = usuario.cd-usuario.  
                     end.
                    
                     IF b-import-bnfciar.cod-livre-4 = "A" 
                     THEN ASSIGN motiv-demis.log-exc-demis    = NO.  /* APOSENTADO */
                     ELSE ASSIGN motiv-demis.log-exc-demis    = YES. /* DEMITIDO SEM JUSTA CAUSA */

                     /* data desligamento                     inicio contribuicao*/
                     IF b-import-bnfciar.dat-livre-3 <> ? AND b-import-bnfciar.dat-livre-4 <> ? 
                     THEN motiv-demis.qtd-meses-contrib = INT((b-import-bnfciar.dat-livre-3 - b-import-bnfciar.dat-livre-4) / 30). /*arredonda a diferenca de dias para calcular nr meses*/
                     ELSE motiv-demis.qtd-meses-contrib = 0.

                     assign motiv-demis.log-enquad-artigo-22  = NO /* ciente que nao se enquadra no beneficio?            Homologado com cadastro Unimed NI */
                            motiv-demis.log-contrib-plano     = YES /* contribuia com o plano?                            Homologado com cadastro Unimed NI */
                            motiv-demis.log-mantem-plano      = YES /* optou por manter o plano?                          Homologado com cadastro Unimed NI */
                            motiv-demis.dat-comunic           = ? /*b-import-bnfciar.dat-livre-3*/ /*data de comunicacao do beneficio ao ex-empregado Homologado com cadastro Unimed NI*/
                            motiv-demis.dat-livre-1           = b-import-bnfciar.dat-livre-4 /*inicio da contribuicao */
                            motiv-demis.dat-livre-2           = b-import-bnfciar.dat-livre-3 /*fim da contribuicao        Homologado com cadastro Unimed NI*/
                            motiv-demis.dat-livre-3           = b-import-bnfciar.dat-livre-2 /* inicio do beneficio aposentado / demitido*/
                            motiv-demis.dat-livre-4           = b-import-bnfciar.dat-livre-5 /* fim do beneficio aposentado / demitido*/
                            motiv-demis.nom-arq-comunic       = ""                                                     /* Homologado com cadastro Unimed NI */
                            motiv-demis.nom-usuar-atualiz     = "migracao"
                            motiv-demis.dat-atualiz           = TODAY.
                     release motiv-demis.
              END.
       END.

       /* -------------------------------------------------------------------------------------- */
       FIND FIRST pessoa-fisica WHERE pessoa-fisica.id-pessoa = usuario.id-pessoa NO-LOCK NO-ERROR.

       IF AVAIL pessoa-fisica
       THEN DO:
              ASSIGN usuario.nr-identidade            = IF (pessoa-fisica.nr-identidade <> "" and pessoa-fisica.nr-identidade <> ?)
                                                        THEN pessoa-fisica.nr-identidade
                                                        ELSE b-import-bnfciar.nr-identidade
                     usuario.uf-emissor-doc           = IF (pessoa-fisica.uf-emissor-ident <> "" AND pessoa-fisica.uf-emissor-ident <> ?)
                                                        THEN CAPS(pessoa-fisica.uf-emissor-ident)
                                                        ELSE CAPS(b-import-bnfciar.uf-emissor-ident)
                     usuario.ds-orgao-emissor-ident   = IF (pessoa-fisica.ds-orgao-emissor-ident <> "" AND pessoa-fisica.ds-orgao-emissor-ident <> ?)
                                                        THEN CAPS(pessoa-fisica.ds-orgao-emissor-ident)
                                                        ELSE CAPS(b-import-bnfciar.des-orgao-emissor-ident)
                     usuario.dt-emissao-doc           = IF pessoa-fisica.dt-emissao-ident <> ?
                                                        THEN pessoa-fisica.dt-emissao-ident
                                                        ELSE b-import-bnfciar.dt-emissao-ident
                     usuario.nm-pais                  = IF (pessoa-fisica.nm-pais-emissor-ident <> "" AND pessoa-fisica.nm-pais-emissor-ident <> ?)
                                                        THEN CAPS(pessoa-fisica.nm-pais-emissor-ident)
                                                        ELSE CAPS(b-import-bnfciar.nom-pais)
                     usuario.cd-cpf                   = IF (pessoa-fisica.cd-cpf <> "" AND pessoa-fisica.cd-cpf <> ?)
                                                        THEN pessoa-fisica.cd-cpf
                                                        ELSE b-import-bnfciar.cd-cpf
                     usuario.dt-nascimento            = IF pessoa-fisica.dt-nascimento <> ?
                                                        THEN pessoa-fisica.dt-nascimento
                                                        ELSE b-import-bnfciar.dt-nascimento
                     usuario.in-est-civil             = IF pessoa-fisica.in-estado-civil <> 0
                                                        THEN int(pessoa-fisica.in-estado-civil)
                                                        ELSE int(b-import-bnfciar.in-est-civil)
                     usuario.lg-sexo                  = IF pessoa-fisica.lg-sexo <> ?
                                                        THEN pessoa-fisica.lg-sexo
                                                        ELSE b-import-bnfciar.log-sexo
                     usuario.nm-mae                   = IF (pessoa-fisica.nm-mae <> "" AND pessoa-fisica.nm-mae <> ?)
                                                        THEN CAPS(pessoa-fisica.nm-mae)
                                                        ELSE CAPS(b-import-bnfciar.nom-mae)
                     usuario.nm-pai                   = IF (pessoa-fisica.nm-pai <> "" AND pessoa-fisica.nm-pai <> ?)
                                                        THEN caps(pessoa-fisica.nm-pai)
                                                        ELSE CAPS(b-import-bnfciar.nom-pai)
                     usuario.cd-cartao-nacional-saude = IF pessoa-fisica.cd-cartao-nacional-saude <> 0 
                                                        THEN pessoa-fisica.cd-cartao-nacional-saude
                                                        ELSE b-import-bnfciar.cd-cartao-nacional-saude
                     usuario.cd-pis-pasep             = IF pessoa-fisica.nr-pis-pasep <> 0
                                                        THEN pessoa-fisica.nr-pis-pasep
                                                        ELSE b-import-bnfciar.cd-pis-pasep
                     usuario.char-29                  = pessoa-fisica.char-2. /* declaracao nascido vivo */

              if b-import-bnfciar.log-respons  = NO
              AND AVAIL b-usuario /* titular */
              THEN DO:
                     /* se for dependente e nao possui endereco, carregar com endereco do seu titular. */
                     FIND FIRST endereco WHERE endereco.id-pessoa = usuario.id-pessoa
                                           AND endereco.lg-principal NO-LOCK NO-ERROR.
                     IF NOT AVAIL endereco
                     THEN DO:
                            FIND FIRST endereco WHERE endereco.id-pessoa = usuario.id-pessoa NO-LOCK NO-ERROR.
                            
                            IF NOT AVAIL endereco
                            THEN DO:
                                    /* ler endereco principal do seu responsavel para criar endereco do dependente */
                                    FIND FIRST b-endereco WHERE b-endereco.id-pessoa = b-usuario.id-pessoa
                                                            AND b-endereco.lg-principal NO-LOCK NO-ERROR.
                                    IF AVAIL b-endereco
                                    THEN DO:
                                           CREATE endereco.
                                           BUFFER-COPY b-endereco EXCEPT id-pessoa id-endereco TO endereco.
                                           ASSIGN endereco.id-pessoa = usuario.id-pessoa.
                                           repeat:
                                              assign endereco.id-endereco = next-value(seq-endereco) no-error.
                                			  validate endereco.
                                              if not error-status:error
                                              then leave.
                                              process events.
                                           end.
                                    END.
                            END.
                     END.

                     /* Se encontrou o endereco, atualiza o mesmo na tabela do usuario */
                     if avail endereco 
                     then assign usuario.en-rua    = endereco.ds-endereco
                                 usuario.en-bairro = endereco.ds-bairro
                                 usuario.en-cep    = endereco.cd-cep
                                 usuario.en-uf     = endereco.cd-uf
                                 usuario.cd-cidade = endereco.cd-cidade
                                 usuario.int-14    = endereco.int-3
                                 usuario.int-17    = endereco.in-tipo-endereco.
                   END.
              ELSE DO:
                     /* Pesquisa o endereco principal */
                     find first endereco where endereco.id-pessoa = pessoa-fisica.id-pessoa
                                           and endereco.lg-principal
                                               no-lock no-error.
                     
                     /* Se encontrou o endereco, atualiza o mesmo na tabela do usuario */
                     if avail endereco 
                     then assign usuario.en-rua    = endereco.ds-endereco
                                 usuario.en-bairro = endereco.ds-bairro
                                 usuario.en-cep    = endereco.cd-cep
                                 usuario.en-uf     = endereco.cd-uf
                                 usuario.cd-cidade = endereco.cd-cidade
                                 usuario.int-14    = endereco.int-3
                                 usuario.int-17    = endereco.in-tipo-endereco. 
                   END.
       END.
       ELSE DO:
              assign lg-relat-erro = yes.
              RUN pi-cria-tt-erros("Pessoa Fisica nao encontrada com id-pessoa: " + STRING(usuario.id-pessoa)).
              LEAVE l-inclusao.
            END.

       /* -------------------------------------------------------------------------------------- */

       IF propost.in-registro-plano = 2
       AND AVAIL reg-plano-saude
       THEN ASSIGN usuario.idi-plano-ans          = reg-plano-saude.idi-registro.
       ELSE ASSIGN usuario.idi-plano-ans          = propost.idi-plano-ans.

    RUN escrever-log("@@@@@USUARIO.IDI-PLANO-ANS: " + string(usuario.idi-plano-ans)).

       if b-import-bnfciar.in-via-transferencia = "B"
       or b-import-bnfciar.in-via-transferencia = "D"
       then assign usuario.char-13 = string(b-import-bnfciar.cdn-produt-orig,"x(9)").
       
       if b-import-bnfciar.cd-controle-oper-ans <> 0
       then assign usuario.cd-controle-oper-ans = b-import-bnfciar.cd-controle-oper-ans.
       
       /*-----------------------------------------------------------------------*/
       run trata-afericao.

       RUN escrever-log("@@@@@CRIA-BENEFICIARIO P1. PADRAO COBERTURA: " + b-import-bnfciar.cd-padrao-cob).

       /*------------------------------------------------------------------------*/
       if b-import-bnfciar.cd-padrao-cob <> ""
       then do: 
              FOR EACH usumodu
                 where usumodu.cd-modalidade   = usuario.cd-modalidade
                   and usumodu.nr-proposta     = usuario.nr-proposta 
                   and usumodu.cd-usuario      = usuario.cd-usuario EXCLUSIVE-LOCK:
                       RUN escrever-log("@@@@@CRIA-BENEFICIARIO P2 - DELETE USUMODU. MODALIDADE/PROPOSTA/USUARIO/MODULO: " + STRING(usumodu.cd-modalidade) + "/" +
                                        STRING(usumodu.nr-proposta) + "/" + STRING(usumodu.cd-usuario) + "/" + STRING(usumodu.cd-modulo)).
                       DELETE usumodu.
                       VALIDATE usumodu.
              END.

              for each propcopa FIELDS (cd-modalidade nr-proposta cd-modulo)
                 where propcopa.cd-modalidade       = propost.cd-modalidade
                   and propcopa.nr-proposta         = propost.nr-proposta  
                   and propcopa.cd-padrao-cobertura = b-import-bnfciar.cd-padrao-cob       
                       NO-LOCK,
                  
                  FIRST pro-pla FIELDS (lg-cobertura-obrigatoria cd-modulo cd-modalidade nr-proposta dt-inicio) 
                  where pro-pla.cd-modalidade = propcopa.cd-modalidade
                    and pro-pla.nr-proposta   = propcopa.nr-proposta
                    and pro-pla.cd-modulo     = propcopa.cd-modulo 
                    AND NOT pro-pla.lg-cobertura-obrigatoria
                        NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

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
                                usumodu.cd-userid-exclusao = if b-import-bnfciar.dt-exclusao-plano <> ?         
                                                             then v_cod_usuar_corren           
                                                             else "".

                         RUN escrever-log("@@@@@CRIA-BENEFICIARIO P21 - CREATE USUMODU DO PADRAO DE COBERTURA. MODALIDADE/PROPOSTA/USUARIO/MODULO: " + STRING(usumodu.cd-modalidade) + "/" +
                                       STRING(usumodu.nr-proposta) + "/" + STRING(usumodu.cd-usuario) + "/" + STRING(usumodu.cd-modulo)).

                         
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
              FOR EACH pla-mod FIELDS (cd-modalidade cd-plano cd-tipo-plano cd-modulo)
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

                                      RUN escrever-log("@@@@@CRIA-BENEFICIARIO P22 - CREATE USUMODU AUTOMATICO. MODALIDADE/PROPOSTA/USUARIO/MODULO: " + STRING(usumodu.cd-modalidade) + "/" +
                                             STRING(usumodu.nr-proposta) + "/" + STRING(usumodu.cd-usuario) + "/" + STRING(usumodu.cd-modulo)).

                                      
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
              end. /* for each */
            end. /* if cd-padrao-cob-imp <> "" */
       else 
            /* ------ CRIACAO DO MODULO AUTOMATICO --- */
            for each pla-mod FIELDS (cd-modalidade cd-plano cd-tipo-plano cd-modulo)
               where pla-mod.cd-modalidade = propost.cd-modalidade 
                 and pla-mod.cd-plano      = propost.cd-plano
                 and pla-mod.cd-tipo-plano = propost.cd-tipo-plano
                 and pla-mod.lg-grava-automatico 
                     NO-LOCK,
       
                FIRST pro-pla FIELD (lg-cobertura-obrigatoria cd-modulo cd-modalidade nr-proposta dt-inicio) 
                where pro-pla.cd-modalidade = propost.cd-modalidade
                  and pro-pla.nr-proposta   = propost.nr-proposta
                  and pro-pla.cd-modulo     = pla-mod.cd-modulo 
                  AND NOT pro-pla.lg-cobertura-obrigatoria
                      NO-LOCK,
                
                FIRST mod-cob 
                where mod-cob.cd-modulo = pla-mod.cd-modulo
                  AND mod-cob.in-identifica-modulo = "S" no-lock,
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
                             then ASSIGN lg-inclui-automatico-aux = no.                                                                    
                           end.                                                                           
                      else assign lg-inclui-automatico-aux = yes.
                      
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
                                           usumodu.cd-usuario         = ct-codigo
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
            end.
    
       assign usuario.cd-unimed                 = paramecp.cd-unimed
              usuario.cd-grau-parentesco        = b-import-bnfciar.cd-grau-parentesco
              usuario.cd-sit-usuario            = 01
              usuario.lg-carencia               = b-import-bnfciar.log-carenc
              usuario.dt-admissao-empresa       = b-import-bnfciar.dt-admissao
              usuario.nm-usuario-cartao         = caps(tt-import-bnfciar.cartao-aux)
              usuario.nm-internacional          = caps(tt-import-bnfciar.nome-abrev-usu)
              usuario.ds-especifico1            = caps(b-import-bnfciar.des-espcif-1)
              usuario.ds-especifico2            = caps(b-import-bnfciar.des-espcif-2)
              usuario.ds-especifico3            = caps(b-import-bnfciar.des-espcif-3)
              usuario.ds-especifico4            = caps(b-import-bnfciar.des-espcif-4)
              usuario.cd-unimed-origem          = b-import-bnfciar.cd-unimed-origem
              usuario.cd-identific-uni-origem   = b-import-bnfciar.cd-identific-uni-origem
              usuario.cd-plano-origem           = caps(b-import-bnfciar.cd-plano-origem)
              usuario.nm-plano                  = caps(b-import-bnfciar.nom-plano-orig)
              usuario.dt-inclusao-origem        = b-import-bnfciar.dt-inclusao-origem
              usuario.cd-padrao-cob-ant         = b-import-bnfciar.cd-padrao-cob-ant
              usuario.dt-mvto-alteracao         = b-import-bnfciar.dt-mvto-alteracao
              usuario.dt-falecimento-titular    = b-import-bnfciar.dt-falecimento-titular
              usuario.dt-atualizacao-carencia   = b-import-bnfciar.dt-atualizacao-carencia
              usuario.cd-userid-carencia        = b-import-bnfciar.cd-userid-carencia
              usuario.lg-bonifica-penaliza      = YES
              usuario.nr-dias                   = b-import-bnfciar.nr-dias
              usuario.lg-insc-fatura            = b-import-bnfciar.log-inscr-fatur
              usuario.lg-cobra-fator-moderador  = tt-import-bnfciar.lg-insc-fat
              usuario.dt-inicio-vinculo-unidade = b-import-bnfciar.dt-inicio-vinculo-unidade
              usuario.aa-ult-fat                = b-import-bnfciar.aa-ult-fat-period
              usuario.mm-ult-fat                = b-import-bnfciar.num-mes-ult-faturam.
                                                                          
       /* -------------------------------------------------- CAMPOS REPASSE --- */
       if  usuario.dt-inicio-vinculo-unidade = ?
       then assign usuario.dt-inicio-vinculo-unidade = usuario.dt-inclusao-plano.

       if not b-import-bnfciar.log-respons   
       then assign usuario.cd-titular = IF AVAIL b-usuario THEN b-usuario.cd-titular ELSE ct-codigo.
       else assign usuario.cd-titular = ct-codigo.
       
       /*-----------------------------------------------------------------------*/ 
       run rtp/rtreajus.p (input  usuario.dt-nascimento,
                           input  usuario.dt-inicio-vinculo-unidade,
                           input  paravpmc.qt-idade-sem-reaj-troca-fx,
                           input  paravpmc.um-sem-reaj-troca-fx,
                           input  paravpmc.qt-prazo-permanencia-pl,
                           input  paravpmc.um-prazo-permanencia-pl,
                           input  paravpmc.dt-inicio-lei-planos,
                           input  recid(usuario),
                           output aa-mm-sem-reaj-troca-fx-aux,
                           output ds-mensagem-aux,
                           output lg-erro-aux).
       if lg-erro-aux
       then do:                                
              assign lg-relat-erro  = yes.
              IF ds-mensagem-aux = ?
              THEN ds-mensagem-aux = "nulo".
              RUN pi-cria-tt-erros("Nao foi possivel calcular periodo em que o beneficiario nao tera mais reajuste na mensalidade." + ds-mensagem-aux).
              leave l-inclusao. 
            end.
       
       assign usuario.aa-mm-sem-reaj-troca-fx = aa-mm-sem-reaj-troca-fx-aux.
       
       /**
        * Gravar Empresa, Familia e Dependencia conforme regras do Unicoo, se parametrizado.
        * Obs: PARAVPMC.LOG-LIVRE-24 indica se o sistema usa o conceito de montagem do cartao igual ao Unicoo.
        */
       IF lg-carteira-antig-aux 
       THEN DO:
              ASSIGN cd-empresa-aux     = int(SUBSTRING(string(cd-cart-inteira-aux,"9999999999999"),1,4))
                     cd-familia-aux     = int(SUBSTRING(string(cd-cart-inteira-aux,"9999999999999"),5,6))
                     cd-dependencia-aux = int(SUBSTRING(string(cd-cart-inteira-aux,"9999999999999"),11,2)).
              
              /**
               * Tratamento para gravar o codigo da Familia e Dependencia dos Beneficiarios (padrao do Unicoo)
               */
              FIND FIRST gerac-cod-ident-benef EXCLUSIVE-LOCK
                   WHERE gerac-cod-ident-benef.cdn-modalid = b-import-bnfciar.cd-modalidade
                     AND gerac-cod-ident-benef.num-propost = propost.nr-proposta           
                     AND gerac-cod-ident-benef.cdn-usuar   = usuario.cd-usuario NO-ERROR.
              IF  NOT AVAIL gerac-cod-ident-benef
              THEN DO:
                     create gerac-cod-ident-benef.
                     assign gerac-cod-ident-benef.cdn-modalid = b-import-bnfciar.cd-modalidade
                            gerac-cod-ident-benef.num-propost = propost.nr-proposta           
                            gerac-cod-ident-benef.cdn-usuar   = usuario.cd-usuario.
                   END.
              ASSIGN gerac-cod-ident-benef.cdn-familia = cd-familia-aux
                     gerac-cod-ident-benef.cdn-depen   = cd-dependencia-aux.
              VALIDATE gerac-cod-ident-benef.
            END.

       /**
        * Tratamento para gerar CAR-IDE e demais acoes relacionadas.
        */
       IF lg-gerar-termo-aux
       THEN DO:
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
                   END.
              ELSE DO:
                     if   usuario.dt-exclusao-plano < today
                     then do:
                            assign usuario.cd-sit-usuario = 90.   
                          END.
                     else do:
                            if   usuario.aa-ult-fat = 0
                            then assign usuario.cd-sit-usuario = 5.  
                            else do:
                                   if usuario.aa-ult-fat = year (usuario.dt-inclusao-plano) and
                                      usuario.mm-ult-fat = month(usuario.dt-inclusao-plano)
                                   then usuario.cd-sit-usuario = 6.
                                   else usuario.cd-sit-usuario = 7.
                                 end.
                          END.
                   END.

              assign usuario.nr-ter-adesao  = propost.nr-ter-adesao
                     usuario.dt-aprovacao   = today
                     usuario.cd-userid      = v_cod_usuar_corren
                     usuario.dt-atualizacao = today
                     usuario.dt-senha       = today.

              if   ter-ade.lg-mantem-senha-benef 
              then assign usuario.cd-senha  = contrat.cd-senha.
              else do:
                      if   ter-ade.in-gera-senha = 1 /* individual */
                      then do:
                             run rtp/rtrandom.p (input 6,
                                                 output cd-senha-aux,
                                                 output lg-erro-rtsenha-aux,
                                                 output ds-erro-rtsenha-aux).
                             if lg-erro-rtsenha-aux 
                             then do:
                                    assign lg-relat-erro  = yes.
                                    IF ds-erro-rtsenha-aux = ?
                                    THEN ds-erro-rtsenha-aux = "nulo".
                                    RUN pi-cria-tt-erros(ds-erro-rtsenha-aux).
                                    leave l-inclusao. 
                                  end.
                             assign usuario.cd-senha = cd-senha-aux.
                           end.
              
                      else if   usuario.cd-usuario = usuario.cd-titular  /* familia */
                           then do:
                                  run rtp/rtrandom.p (input 6,
                                                      output cd-senha-aux,
                                                      output lg-erro-rtsenha-aux,
                                                      output ds-erro-rtsenha-aux).
                                  if lg-erro-rtsenha-aux 
                                  then do:
                                         assign lg-relat-erro  = yes.
                                         IF ds-erro-rtsenha-aux = ?
                                         THEN ds-erro-rtsenha-aux = "nulo".
                                         RUN pi-cria-tt-erros(ds-erro-rtsenha-aux).
                                         leave l-inclusao. 
                                       end.
                                  assign usuario.cd-senha = cd-senha-aux.                                                                     

                                  for each bb-usuario FIELDS(cd-senha)
                                     where bb-usuario.cd-modalidade = usuario.cd-modalidade
                                       and bb-usuario.nr-proposta   = usuario.nr-proposta
                                       and bb-usuario.cd-titular    = usuario.cd-titular
                                       and bb-usuario.cd-usuario    <> usuario.cd-usuario
                                        exclusive-lock:
                                    
                                           assign bb-usuario.cd-senha = usuario.cd-senha.
                                  end.
                                end.
                   end.    

              if   usuario.dt-inclusao-plano = usuario.dt-exclusao-plano 
              or   usuario.cd-sit-usuario =  5
              then assign usuario.aa-pri-fat = 0
                          usuario.mm-pri-fat = 0.
              else assign usuario.aa-pri-fat = year (usuario.dt-inclusao-plano)
                          usuario.mm-pri-fat = month(usuario.dt-inclusao-plano).

              /* ----- VERIFICA SE A MODALIDADE E' MEDICINA OCUPACIONAL ----------- */
              if   lg-medocup-aux
              AND  not paravpmc.lg-imp-carteira-mo
              then assign lg-grava-carteira = no.
              ELSE assign lg-grava-carteira = yes.

              /*CD_UNIMED, CD_MODALIDADE, NR_TER_ADESAO, CD_USUARIO, NR_CARTEIRA*/
              RUN escrever-log("@@@@@Vai criar CAR-IDE. cd-unimed: " + STRING(usuario.cd-unimed) +
                               " cd-modalidade: " + STRING(usuario.cd-modalidade) +
                               " nr-ter-adesao: " + STRING(usuario.nr-ter-adesao) +
                               " cd-usuario: " + STRING(usuario.cd-usuario) +
                               " nr-carteira: 1").

              FOR FIRST car-ide EXCLUSIVE-LOCK
                  WHERE car-ide.cd-unimed           = usuario.cd-unimed
                    and car-ide.cd-modalidade       = usuario.cd-modalidade
                    and car-ide.nr-ter-adesao       = usuario.nr-ter-adesao
                    and car-ide.cd-usuario          = usuario.cd-usuario
                    and car-ide.nr-carteira         = 1 /*nr-via-carteira-aux*/:
              END.
              IF NOT AVAIL car-ide
              THEN DO:
                      create car-ide.
                      assign car-ide.cd-unimed           = usuario.cd-unimed
                             car-ide.cd-modalidade       = usuario.cd-modalidade
                             car-ide.nr-ter-adesao       = usuario.nr-ter-adesao
                             car-ide.cd-usuario          = usuario.cd-usuario
                             car-ide.nr-carteira         = 1 /*nr-via-carteira-aux*/
                             .
              END.
              ELSE DO:
                     RUN escrever-log("@@@@@CAR-IDE JA EXISTE!!!. cd-unimed: " + STRING(usuario.cd-unimed) +
                                      " cd-modalidade: " + STRING(usuario.cd-modalidade) +
                                      " nr-ter-adesao: " + STRING(usuario.nr-ter-adesao) +
                                      " cd-usuario: " + STRING(usuario.cd-usuario) +
                                      " nr-carteira: 1").
              END.

              /* ----- GRAVA A TABELA DE CARTEIRA DO BENEFICIARIO ----------------- */
              ASSIGN car-ide.dv-carteira         = dv-cart-inteira-aux
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
                     then assign car-ide.cd-sit-carteira = 90
                                 car-ide.dt-devolucao    = usuario.dt-exclusao-plano
                                 car-ide.lg-devolucao    = YES.

                     else assign car-ide.cd-sit-carteira = 1
                                 car-ide.dt-devolucao    = ?
                                 car-ide.lg-devolucao    = YES.
              
                     assign car-ide.dt-cancelamento = usuario.dt-exclusao-plano.
                   end.
              else assign car-ide.cd-sit-carteira = 1.
              
              if   lg-grava-carteira
              then assign car-ide.nr-impressao = 0
                          car-ide.dt-emissao   = ?.
              else assign car-ide.nr-impressao = 1
                          car-ide.dt-emissao   = today.

              VALIDATE car-ide. /* validade necessario para que o registro seja encontrado na RTVALDOC*/
              /**
               * IMPORT-BNFCIAR.DAT-LIVRE-1: data de validade da carteira no Unicoo*/
              if b-import-bnfciar.dat-livre-1 <> ?
              then assign car-ide.dt-validade = b-import-bnfciar.dat-livre-1.
              else do:
                     /* --------------------- CHAMADA  DA ROTINA RTVALDOC PARA CALCULAR DATAS- */
                     dt-validade-valdoc = ter-ade.dt-validade-cart.
                     
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
                     
                            if   lg-erro-valdoc
                            then do:               
                                   assign lg-relat-erro  = yes.
                                   IF ds-mensagem-valdoc = ?
                                   THEN ds-mensagem-valdoc = "RTVALDOC: nulo".
                                   RUN pi-cria-tt-erros("RTVALDOC: " + ds-mensagem-valdoc).
                                   leave l-inclusao. 
                                 end.
                          end.
                     
                     /* ----------------------------------------------------------- */
                     if   car-ide.dt-validade <> dt-validade-valdoc
                     then do:
                            if   dt-validade-valdoc <= ter-ade.dt-inicio
                            then do:
                                   assign lg-relat-erro  = yes.
                                   IF dt-validade-valdoc <> ?
                                   THEN char-aux1 = STRING(dt-validade-valdoc).
                                   ELSE char-aux1 = "nulo".
                                   IF ter-ade.dt-inicio <> ?
                                   THEN char-aux2 = string(ter-ade.dt-inicio).
                                   ELSE char-aux2 = "nulo".
                                   RUN pi-cria-tt-erros("Validade doc identif inferior" + 
                                                         " ou igual ao inicio do termo." +
                                                         " Validade Calculada: " + char-aux1 +
                                                         " Inicio Termo: "       + char-aux2).
                                   leave l-inclusao. 
                                 end.
                            else do:
                                   assign car-ide.dt-validade = dt-validade-valdoc.
                     
                                   /* -------------- RETORNA A DATA DE FIM DE VALIDADE DO CARTAO/CARTEIRA ---*/
                                   if   paravpmc.in-validade-cart = "2" 
                                   then do:
                                          run rtp/rtultdia.p (input  year (car-ide.dt-validade),
                                                              input  month(car-ide.dt-validade),
                                                              output dt-validade-aux).
                     
                                          assign car-ide.dt-validade = dt-validade-aux.
                                        end.  
                                 end.
                          end.
                   end.
            END.

       /*----- SE MEDICINA OCUPACIONAL -----------------------------------------*/
       if not lg-medocup-aux
       then assign usuario.cd-departamento      = b-import-bnfciar.cd-departamento
                   usuario.cd-secao             = b-import-bnfciar.cd-secao
                   usuario.cd-setor             = b-import-bnfciar.cd-setor
                   usuario.int-12               = b-import-bnfciar.cd-funcao
                   usuario.cd-departamento-ant  = b-import-bnfciar.cd-departamento
                   usuario.cd-secao-ant         = b-import-bnfciar.cd-secao
                   usuario.cd-setor-ant         = b-import-bnfciar.cd-setor
                   usuario.cd-transacao         = cd-ativo-aux
                   usuario.lg-carencia          = no
                   usuario.cd-carteira-trabalho = b-import-bnfciar.cd-carteira-trabalho
                   usuario.dt-primeira-consulta-mig = b-import-bnfciar.dt-primeira-consulta
                   lg-medocup-aux               = YES.

       
       IF  b-import-bnfciar.num-livre-9 <> ?
       AND b-import-bnfciar.num-livre-9 <> 0
       THEN DO:
              /* REGRAS DE MENSALIDADE */
              FIND FIRST regra-menslid-propost
                   WHERE regra-menslid-propost.cd-modalidade   = propost.cd-modalidade
                     AND regra-menslid-propost.nr-proposta     = propost.nr-proposta
                     AND regra-menslid-propost.cd-usuario      = usuario.cd-usuario
                     AND regra-menslid-propost.dt-ini-validade = usuario.dt-inclusao-plano
                     AND regra-menslid-propost.dt-fim-validade = 12/31/9999
                         NO-LOCK NO-ERROR.
              
              IF NOT AVAIL regra-menslid-propost        
              THEN DO:
                     CREATE regra-menslid-propost.
                     ASSIGN regra-menslid-propost.cdd-seq         = proximaseqregra()
                            regra-menslid-propost.cdd-regra       = b-import-bnfciar.num-livre-9
                            regra-menslid-propost.cd-modalidade   = propost.cd-modalidade   
                            regra-menslid-propost.nr-proposta     = propost.nr-proposta 
                            regra-menslid-propost.cd-usuario      = usuario.cd-usuario
                            regra-menslid-propost.dt-ini-validade = usuario.dt-inclusao-plano 
                            regra-menslid-propost.dt-fim-validade = 12/31/9999
                            regra-menslid-propost.cod-usuar-ult-atualiz = v_cod_usuar_corren
                            regra-menslid-propost.dat-ult-atualiz = TODAY. 
                   END.
            END.

       /*----- PROPOSTA PEA ----------------------------------------------------*/
       if propost.lg-pea 
       and b-import-bnfciar.log-respons  = no
       and b-import-bnfciar.num-livre-10 <> 0 /* substituto */
       AND b-import-bnfciar.num-livre-10 <> ?
       then do:
              FIND FIRST ususubst EXCLUSIVE-LOCK
                   WHERE ususubst.cd-modalidade = usuario.cd-modalidade
                     AND ususubst.nr-ter-adesao = usuario.nr-ter-adesao
                     AND ususubst.cd-usuario    = b-usuario.cd-usuario 
                     AND ususubst.dt-limite     = DATE(12/31/9999) NO-ERROR.
              IF NOT AVAIL ususubst
              THEN DO:
                     create ususubst.
                     assign ususubst.cd-modalidade         = usuario.cd-modalidade
                            ususubst.nr-ter-adesao         = usuario.nr-ter-adesao
                            ususubst.cd-usuario            = b-usuario.cd-usuario /* titular falecido */
                            ususubst.dt-limite             = date(12,31,9999).
                   END.

              ASSIGN ususubst.cd-contratante        = b-import-bnfciar.num-livre-10
                     ususubst.cd-titular-substituto = usuario.cd-usuario
                     ususubst.dt-atualizacao        = today
                     ususubst.cd-userid             = v_cod_usuar_corren.
            end.
    
    end.  /* l-inclusao */
end.

procedure trata-afericao:
    DEF BUFFER b-propost FOR propost.
    if   modalid.pc-afericao <> 0
    then do:
           find pr-id-us where pr-id-us.cd-modalidade      = usuario.cd-modalidade
                           and pr-id-us.nr-proposta        = usuario.nr-proposta
                           and pr-id-us.cd-grau-parentesco = usuario.cd-grau-parentesco
                           and pr-id-us.nr-faixa-etaria    = tt-import-bnfciar.nr-faixa-etaria      
                               exclusive-lock no-wait no-error.
           if   avail pr-id-us
           then assign qt-pessoas-aux = pr-id-us.qt-pessoas.
           else do:
                  create pr-id-us.
                  assign qt-pessoas-aux = 0.      
                end.
                
           assign qt-pessoas-aux              = qt-pessoas-aux + 1.
           assign pr-id-us.cd-modalidade      = usuario.cd-modalidade
                  pr-id-us.nr-proposta        = usuario.nr-proposta
                  pr-id-us.cd-grau-parentesco = usuario.cd-grau-parentesco
                  pr-id-us.nr-faixa-etaria    = tt-import-bnfciar.nr-faixa-etaria
                  pr-id-us.qt-pessoas         = qt-pessoas-aux.
           
           FOR FIRST b-propost EXCLUSIVE-LOCK WHERE ROWID(b-propost) = ROWID(propost):
               if b-import-bnfciar.log-respons 
               then  assign b-propost.nr-pessoas-titulares   = b-propost.nr-pessoas-titulares + 1.
               else  assign b-propost.nr-pessoas-dependentes = b-propost.nr-pessoas-dependentes + 1.                                        
           END.
         end.

end procedure.

/**
 * Obs: IMPORT-MODUL-BNFCIAR.DAT-LIVRE-1 contem a data de fim de carencia do modulo no Unicoo.
 *      TODO: Sera utilizado para Bonificar/Penalizar no TOTVS, de modo a garantir o final de carencia correto.
 */
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
    FOR EACH import-modul-bnfciar no-lock
       WHERE import-modul-bnfciar.num-seqcial-bnfciar = b-import-bnfciar.num-seqcial-bnfciar
         AND import-modul-bnfciar.num-livre-1         = b-import-bnfciar.num-seqcial-control,
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
                    
        RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P31. MODULO: " + STRING(import-modul-bnfciar.cdn-modul)).

        ASSIGN nr-dias-aux    = 0
               dt-inicio-aux  = ?
               dt-cancel-aux  = ?.

        if  ti-pl-sa.lg-usa-padrao-cobertura
        then do:

               RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P32").

               /*
               FOR first usumodu  
                   where usumodu.cd-modalidade = pro-pla.cd-modalidade
                     and usumodu.nr-proposta   = pro-pla.nr-proposta
                     and usumodu.cd-usuario    = ct-codigo
                     and usumodu.cd-modulo     = import-modul-bnfciar.cdn-modul exclusive-lock:
               END.
               if avail usumodu
               then do:
                      IF usumodu.dt-inicio >= usuario.dt-inclusao-plano
                      THEN assign usumodu.dt-inicio = import-modul-bnfciar.dat-inic
                                  dt-inicio-aux     = import-modul-bnfciar.dat-inic.
                      ELSE ASSIGN usumodu.dt-inicio = usuario.dt-inclusao-plano
                                  dt-inicio-aux     = usuario.dt-inclusao-plano.

                      if import-modul-bnfciar.dat-fim <> ?
                      then assign usumodu.dt-cancelamento = import-modul-bnfciar.dat-fim
                                  dt-cancel-aux           = import-modul-bnfciar.dat-fim.
                    end.
               ELSE do:*/ 
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
                                    usumodu.cd-usuario         = ct-codigo
                                    usumodu.cd-modulo          = import-modul-bnfciar.cdn-modul
                                    usumodu.cd-userid          = v_cod_usuar_corren
                                    usumodu.dt-atualizacao     = today
                                    usumodu.cd-userid-inclusao = v_cod_usuar_corren
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
                    /*end.*/

               /**
                * Se algum flag indicar para nao calcula carencia ou o modulo ja estiver cancelado para o beneficiario, nao criar USUCAREN.
                */
               /*
               IF  import-modul-bnfciar.nr-dias <> 0
               AND (dt-cancel-aux = ? OR dt-cancel-aux >= TODAY)
               AND usuario.lg-carencia
               AND pro-pla.lg-carencia
               AND import-modul-bnfciar.log-caren
               AND pro-pla.in-ctrl-carencia-proced > 0
               THEN DO:
                      /**
                       * Se a carencia for por modulo e ja esta vencida ha mais de 1 ano, nao criar USUCAREN.
                       */
                      ASSIGN lg-criar-usucaren-aux = yes.
                      
                      IF pro-pla.in-ctrl-carencia-proced = 1
                      THEN DO:
                             ASSIGN nr-dias-aux = 0.
                      
                             IF pro-pla.lg-bonifica-penaliza
                             THEN nr-dias-aux = nr-dias-aux + (pro-pla.nr-dias * -1).
                             ELSE nr-dias-aux = nr-dias-aux + pro-pla.nr-dias.
                      
                             IF usuario.lg-bonifica-penaliza
                             THEN nr-dias-aux = nr-dias-aux + (usuario.nr-dias * -1).
                             ELSE nr-dias-aux = nr-dias-aux + usuario.nr-dias.
                      
                             IF import-modul-bnfciar.log-bonif-penalid
                             THEN nr-dias-aux = nr-dias-aux + (import-modul-bnfciar.nr-dias * -1).
                             ELSE nr-dias-aux = nr-dias-aux + import-modul-bnfciar.nr-dias.
                             
                             IF pro-pla.qt-caren-urgencia + nr-dias-aux + dt-inicio-aux > TODAY - 365
                             OR pro-pla.qt-caren-eletiva  + nr-dias-aux + dt-inicio-aux > TODAY - 365
                             THEN lg-criar-usucaren-aux = yes.
                             ELSE lg-criar-usucaren-aux = NO.
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
                                                    and usucaren.cd-usuario  = ct-codigo
                                                    and usucaren.cd-modulo   = pro-pla.cd-modulo
                                                        exclusive-lock no-error.
                                    if not avail usucaren
                                    then do:        
                                           create usucaren.
                                           assign usucaren.cd-modalidade = pro-pla.cd-modalidade
                                                  usucaren.nr-proposta   = pro-pla.nr-proposta
                                                  usucaren.cd-usuario    = ct-codigo
                                                  usucaren.cd-modulo     = pro-pla.cd-modulo.
                                         end.
                                    assign usucaren.nr-dias     = import-modul-bnfciar.nr-dias
                                           usucaren.lg-carencia = import-modul-bnfciar.log-carenc
                                           usucaren.lg-bonifica-penaliza = import-modul-bnfciar.log-bonif-penalid.
                                  end.
                           END.
                    END.*/
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
                                    usumodu.cd-usuario      = ct-codigo
                                    usumodu.dt-inicio       = import-modul-bnfciar.dat-inic
                                    dt-inicio-aux           = import-modul-bnfciar.dat-inic
                                    usumodu.dt-fim          = import-modul-bnfciar.dat-fim
                                    usumodu.cd-userid       = v_cod_usuar_corren
                                    usumodu.dt-cancelamento = import-modul-bnfciar.dat-fim
                                    dt-cancel-aux           = import-modul-bnfciar.dat-fim
                                    usumodu.cd-motivo-cancel   = import-modul-bnfciar.cdn-motiv-cancel
                                    usumodu.cd-userid-inclusao = v_cod_usuar_corren
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

               /**
                * Se algum flag indicar para nao calcula carencia ou o modulo ja estiver cancelado para o beneficiario, nao criar USUCAREN.
                */
               /*
               IF  import-modul-bnfciar.nr-dias <> 0
               AND (dt-cancel-aux = ? OR dt-cancel-aux >= TODAY)
               AND usuario.lg-carencia
               AND pro-pla.lg-carencia
               AND import-modul-bnfciar.log-caren
               AND pro-pla.in-ctrl-carencia-proced > 0
               THEN DO:
                      /**
                       * Se a carencia for por modulo e ja esta vencida ha mais de 1 ano, nao criar USUCAREN.
                       */
                      ASSIGN lg-criar-usucaren-aux = yes.

                      IF pro-pla.in-ctrl-carencia-proced = 1
                      THEN DO:
                             ASSIGN nr-dias-aux = 0.

                             IF pro-pla.lg-bonifica-penaliza
                             THEN nr-dias-aux = nr-dias-aux + (pro-pla.nr-dias * -1).
                             ELSE nr-dias-aux = nr-dias-aux + pro-pla.nr-dias.

                             IF usuario.lg-bonifica-penaliza
                             THEN nr-dias-aux = nr-dias-aux + (usuario.nr-dias * -1).
                             ELSE nr-dias-aux = nr-dias-aux + usuario.nr-dias.

                             IF import-modul-bnfciar.log-bonif-penalid
                             THEN nr-dias-aux = nr-dias-aux + (import-modul-bnfciar.nr-dias * -1).
                             ELSE nr-dias-aux = nr-dias-aux + import-modul-bnfciar.nr-dias.

                             IF pro-pla.qt-caren-urgencia + nr-dias-aux + dt-inicio-aux > TODAY - 365
                             OR pro-pla.qt-caren-eletiva  + nr-dias-aux + dt-inicio-aux > TODAY - 365
                             THEN lg-criar-usucaren-aux = yes.
                             ELSE lg-criar-usucaren-aux = NO.
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
                                                    and usucaren.cd-usuario  = ct-codigo
                                                    and usucaren.cd-modulo   = pro-pla.cd-modulo
                                                        exclusive-lock no-error.
                                    if not avail usucaren
                                    then do:        
                                           create usucaren.
                                           assign usucaren.cd-modalidade = pro-pla.cd-modalidade
                                                  usucaren.nr-proposta   = pro-pla.nr-proposta
                                                  usucaren.cd-usuario    = ct-codigo
                                                  usucaren.cd-modulo     = pro-pla.cd-modulo.
                                         end.
                                    assign usucaren.nr-dias     = import-modul-bnfciar.nr-dias
                                           usucaren.lg-carencia = import-modul-bnfciar.log-carenc
                                           usucaren.lg-bonifica-penaliza = import-modul-bnfciar.log-bonif-penalid.
                                  end.
                           END.
                    END.*/
                    END.
             END.
    RUN escrever-log("@@@@@CRIA-MODULOS-BENEF P6 - FIM").

END PROCEDURE.

PROCEDURE cria-repasse-benef:

    FOR EACH import-negociac-bnfciar EXCEPT (cod-livre-1 cod-livre-2 cod-livre-3 cod-livre-4 cod-livre-5 cod-livre-6 cod-livre-7 cod-livre-8 cod-livre-9 cod-livre-10 num-livre-1 num-livre-2 num-livre-3 num-livre-4 num-livre-5 num-livre-6 num-livre-7 num-livre-8 num-livre-9 num-livre-10 val-livre-1 val-livre-2 val-livre-3 val-livre-4 val-livre-5 val-livre-6 val-livre-7 val-livre-8 val-livre-9 val-livre-10 log-livre-1 log-livre-2 log-livre-3 log-livre-4 log-livre-5 log-livre-6 log-livre-7 log-livre-8 log-livre-9 log-livre-10 dat-livre-1 dat-livre-2 dat-livre-3 dat-livre-4 dat-livre-5 dat-livre-6 dat-livre-7 dat-livre-8 dat-livre-9 dat-livre-10)
       WHERE import-negociac-bnfciar.num-seqcial-bnfciar = b-import-bnfciar.num-seqcial-bnfciar NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

        /* ---------------------------------------------------------------------- */
        for each usurepas FIELDS (dt-saida dt-intercambio)
           where usurepas.cd-modalidade = b-import-bnfciar.cd-modalidade 
             and usurepas.nr-proposta   = propost.nr-proposta 
             and usurepas.cd-usuario    = ct-codigo
                 NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

            /*if   usurepas.dt-saida = ?
            THEN DO:
                   IF import-negociac-bnfciar.dat-saida = ?
                   then do:
                          assign lg-relat-erro  = yes.
                          run pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                        end.
                   ELSE IF import-negociac-bnfciar.dat-saida >= usurepas.dt-intercambio
                        then do:
                               assign lg-relat-erro  = yes.
                               run pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                             end.

                   IF import-negociac-bnfciar.dt-intercambio >= usurepas.dt-intercambio
                   then do:
                          assign lg-relat-erro  = yes.
                          run pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                        end.
                 END.
            ELSE DO:
                   IF  import-negociac-bnfciar.dt-intercambio >= usurepas.dt-intercambio
                   and import-negociac-bnfciar.dt-intercambio <= usurepas.dt-saida
                   then do:
                          assign lg-relat-erro  = yes.
                          run pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                        end.

                   IF  import-negociac-bnfciar.dat-saida >= usurepas.dt-intercambio
                   and import-negociac-bnfciar.dat-saida <= usurepas.dt-saida
                   then do:
                          assign lg-relat-erro  = yes.
                          run pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                        end.
                 END.*/

            if  usurepas.dt-saida        =  ?
            or  usurepas.dt-saida        > import-negociac-bnfciar.dt-intercambio
            or (usurepas.dt-intercambio <> usurepas.dt-saida and
                usurepas.dt-saida        = import-negociac-bnfciar.dt-intercambio)
            then do:
                   run pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas. Num.Seqcial Controle: " + STRING(b-import-bnfciar.num-seqcial-control) +
                                        " Und.Dest.Ant: "        + string(usurepas.cd-unidade-destino) +
                                        " Dt.Interc.Ant: "       + if usurepas.dt-intercambio = ? then "00/00/0000" else string(usurepas.dt-intercambio,"99/99/9999") +
                                        " Dt.Saida Ant: "        + if usurepas.dt-saida = ? then "00/00/0000" else string(usurepas.dt-saida,"99/99/9999") +
                                        " Dt.Interc.Informada: " + if import-negociac-bnfciar.dt-intercambio = ? then "00/00/0000" else string(import-negociac-bnfciar.dt-intercambio,"99/99/9999")).
                   
                   assign lg-relat-erro = yes.
                   LEAVE.
                 end.
        end.

        IF lg-relat-erro
        THEN RETURN.

        create usurepas.
        assign usurepas.cd-modalidade      = b-import-bnfciar.cd-modalidade
               usurepas.nr-proposta        = propost.nr-proposta           
               usurepas.cd-usuario         = ct-codigo
               usurepas.dt-atualizacao     = today
               usurepas.dt-intercambio     = import-negociac-bnfciar.dt-intercambio
               usurepas.aa-ult-rep         = import-negociac-bnfciar.num-ano-ult-repas
               usurepas.mm-ult-rep         = import-negociac-bnfciar.num-mes-ult-repas
               usurepas.cd-unidade-destino = import-negociac-bnfciar.cd-unidade-destino
               usurepas.cd-userid          = v_cod_usuar_corren
               usurepas.dt-atualizacao     = TODAY
               usurepas.dt-saida           = import-negociac-bnfciar.dat-saida.
        
        if   propost.lg-altera-taxa-inscricao = no
        then assign usurepas.lg-insc-repasse = yes
                    usurepas.lg-insc-fatura  = yes.
        else assign usurepas.lg-insc-repasse = import-negociac-bnfciar.log-inscr-repas
                    usurepas.lg-insc-fatura  = import-negociac-bnfciar.log-inscr-fatur .
        
        if   import-negociac-bnfciar.dat-saida = usuario.dt-exclusao-plano
        then assign usuario.dt-inclusao-intercambio  = import-negociac-bnfciar.dt-intercambio
                    usuario.cd-unimed-destino        = import-negociac-bnfciar.cd-unidade-destino
                    usuario.cd-identific-uni-destino = import-negociac-bnfciar.cd-identific-uni-destino.

        IF lg-gerar-termo-aux
        THEN DO:
               find propunim where propunim.cd-modalidade = usurepas.cd-modalidade
                               and propunim.nr-proposta   = usurepas.nr-proposta
                               and propunim.cd-unimed     = usurepas.cd-unidade-destino no-lock no-error.
               
               if avail propunim
               AND propunim.in-exporta-repasse = 0
               then assign usurepas.in-tipo-impressao-carta = "N"
                           usurepas.in-tipo-movto-carta     = "I". 
               else do:
                      if   usurepas.dt-saida = ?
                      then ASSIGN usurepas.in-tipo-impressao-carta = "R"
                                  usurepas.in-tipo-movto-carta     = "I".    
                      else assign
                                  usurepas.in-tipo-impressao-carta = "R"
                                  usurepas.in-tipo-movto-carta     = "E".
                      
                      assign usurepas.dt-carta-interc         = today
                             usurepas.cd-userid-carta-interc  = v_cod_usuar_corren
                             usurepas.dt-atualizacao          = today
                             usurepas.cd-userid               = v_cod_usuar_corren.
                    end.
             END.
    END.

END PROCEDURE.

PROCEDURE cria-repasse-atend-benef:

    FOR EACH import-atendim-bnfciar WHERE import-atendim-bnfciar.num-seqcial-bnfciar = b-import-bnfciar.num-seqcial-bnfciar NO-LOCK:

        find first import-negociac-bnfciar where import-negociac-bnfciar.num-seqcial-bnfciar = import-atendim-bnfciar.num-seqcial-bnfciar no-lock no-error.

        /* ---------------------------------------------------------------------- */
        IF NOT CAN-FIND (first usurepas 
                         where usurepas.cd-modalidade      = int(b-import-bnfciar.cd-modalidade)
                           and usurepas.nr-proposta        = propost.nr-proposta
                           and usurepas.cd-usuario         = ct-codigo
                           and usurepas.cd-unidade-destino = import-negociac-bnfciar.cd-unidade-destino
                           and usurepas.dt-intercambio     = import-negociac-bnfciar.dt-intercambio)
        then do:
               RUN pi-cria-tt-erros("Repasse nao informado para a Mod/Proposta/Benef/Unidade").
               assign lg-relat-erro = YES. 
             end.
        
        /* ---------------------------------------------------------------------- */
        for each usureate FIELDS (dt-saida-atendimento dt-intercambio-atendimento)
           where usureate.cd-modalidade      = b-import-bnfciar.cd-modalidade 
             and usureate.nr-proposta        = propost.nr-proposta 
             and usureate.cd-usuario         = ct-codigo
             and usureate.dt-intercambio     = import-negociac-bnfciar.dt-intercambio
             and usureate.cd-unidade-destino = import-negociac-bnfciar.cd-unidade-destino
                 no-lock:
        
            if   usureate.dt-saida-atendimento = ?
            and  import-atendim-bnfciar.dat-saida-atendim = ?
            then do:
                   RUN pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                   assign lg-relat-erro = YES. 
                 end.
        
            if   usureate.dt-saida-atendimento = ?
            and  import-atendim-bnfciar.dat-saida-atendim >= usureate.dt-intercambio-atendimento
            then do:
                   RUN pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                   assign lg-relat-erro = yes. 
                 end.
        
            if   usureate.dt-saida-atendimento = ?
            and  import-atendim-bnfciar.dat-intercam-atendim >= usureate.dt-intercambio-atendimento
            then do:
                   RUN pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                   assign lg-relat-erro = yes. 
                 end.
        
            if   usureate.dt-saida-atendimento <> ?
            and  import-atendim-bnfciar.dat-intercam-atendim >= usureate.dt-intercambio-atendimento
            and  import-atendim-bnfciar.dat-intercam-atendim <= usureate.dt-saida-atendimento
            then do:
                   RUN pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                   assign lg-relat-erro = yes.   
                 end.
        
            if   usureate.dt-saida-atendimento <> ?
            and  import-atendim-bnfciar.dat-saida-atendim >= usureate.dt-intercambio-atendimento
            and  import-atendim-bnfciar.dat-saida-atendim <= usureate.dt-saida-atendimento
            then do:
                   RUN pi-cria-tt-erros("Repasse de beneficiarios nao pode sobrepor datas").
                   assign lg-relat-erro = yes.               
                 end.        
        end.
        
        IF lg-relat-erro 
        THEN NEXT.

        /* ---------------------------------------------------------------------- */
        find first import-negociac-bnfciar where import-negociac-bnfciar.num-seqcial-bnfciar = import-atendim-bnfciar.num-seqcial-bnfciar no-lock no-error.

        create usureate.
        assign usureate.cd-modalidade              = propost.cd-modalidade
               usureate.nr-proposta                = propost.nr-proposta
               usureate.cd-usuario                 = ct-codigo

               usureate.dt-intercambio             = import-negociac-bnfciar.dt-intercambio
               usureate.cd-unidade-destino         = import-negociac-bnfciar.cd-unidade-destino
               usureate.dt-intercambio-atendimento = import-atendim-bnfciar.dat-intercam-atendim
               usureate.cd-unidade-atendimento     = import-atendim-bnfciar.cd-unidade-destino
               usureate.dt-saida-atendimento       = import-atendim-bnfciar.dat-saida-atendim
               usureate.cd-userid                  = v_cod_usuar_corren
               usureate.dt-atualizacao             = today.        
    END.

END PROCEDURE.

PROCEDURE cria-pad-cob-benef:

    FOR EACH import-cobert-bnfciar WHERE import-cobert-bnfciar.num-seqcial-bnfciar = b-import-bnfciar.num-seqcial-bnfciar NO-LOCK:

        find last b2-usucarproc use-index usucarproc1
            where b2-usucarproc.cd-modalidade    = usuario.cd-modalidade
              and b2-usucarproc.nr-proposta      = usuario.nr-proposta
              and b2-usucarproc.cd-usuario       = usuario.cd-usuario
              and b2-usucarproc.cd-modulo        = import-cobert-bnfciar.cdn-modulo
              and b2-usucarproc.cd-tipo-insumo   = int(import-cobert-bnfciar.cod-tip-insumo)
              and b2-usucarproc.cd-proced-insumo = import-cobert-bnfciar.cd-proc-insu
              and b2-usucarproc.lg-cobertura     = yes
                  no-lock no-error.

        if avail b2-usucarproc
        then do:
               if b2-usucarproc.dt-cancelamento = ?
               THEN NEXT.
               else if import-cobert-bnfciar.dat-inicial <= b2-usucarproc.dt-cancelamento 
                    then do:
                           RUN pi-cria-tt-erros("Tabela de carencias Beneficiario x Modulo x Procedimento/Insumo deve ter a data inicial maior do que a estrutura anterior").
                           assign lg-relat-erro = yes.
                         end.
             end. 

        IF lg-relat-erro
        THEN NEXT.

        assign cd-tab-preco-aux = substr(string(import-cobert-bnfciar.cdn-tab-preco),1,03)
                                + substr(string(import-cobert-bnfciar.cdn-tab-preco),5,02).
  
        find last b-usucarproc  
            where b-usucarproc.cd-modalidade    = usuario.cd-modalidade 
              and b-usucarproc.nr-proposta      = usuario.nr-proposta   
              and b-usucarproc.cd-usuario       = usuario.cd-usuario    
              and b-usucarproc.cd-modulo        = import-cobert-bnfciar.cdn-modulo              
              and b-usucarproc.cd-tipo-insumo   = int(import-cobert-bnfciar.cod-tip-insumo)
              and b-usucarproc.cd-proced-insumo = import-cobert-bnfciar.cd-proc-insu    
              and b-usucarproc.dt-inicio        = import-cobert-bnfciar.dat-inicial   
              and b-usucarproc.lg-cobertura     = yes
                  exclusive-lock no-error.
        if avail b-usucarproc
        then do:            
               assign b-usucarproc.dt-cancelamento = today.
        
               create usucarproc.
               assign usucarproc.cd-modalidade   = b-usucarproc.cd-modalidade
                      usucarproc.nr-proposta     = b-usucarproc.nr-proposta
                      usucarproc.cd-usuario      = b-usucarproc.cd-usuario
                      usucarproc.dt-inicio       = today + 1
                      usucarproc.dt-fim          = b-usucarproc.dt-fim
                      usucarproc.dt-cancelamento = ?
                      usucarproc.cd-userid       = v_cod_usuar_corren       
                      usucarproc.cd-tab-preco    = cd-tab-preco-aux         
                      usucarproc.dt-atualizacao  = today                    
                      usucarproc.cd-modulo       = import-cobert-bnfciar.cdn-modulo               
                      usucarproc.cd-tipo-insumo  = int(import-cobert-bnfciar.cod-tip-insumo)
                      usucarproc.cd-proced-insumo= import-cobert-bnfciar.cd-proc-insu     
                      usucarproc.lg-procedimento = lg-procedimento-aux      
                      usucarproc.lg-carencia     = yes          
                      usucarproc.in-carencia     = import-cobert-bnfciar.in-carencia          
                      usucarproc.nr-dias         = import-cobert-bnfciar.nr-dias              
                      usucarproc.lg-cobertura    = yes.                     
             end.
        else do:
               create usucarproc.
               assign usucarproc.cd-modalidade   = usuario.cd-modalidade
                      usucarproc.nr-proposta     = usuario.nr-proposta
                      usucarproc.cd-usuario      = usuario.cd-usuario
                      usucarproc.dt-inicio       = import-cobert-bnfciar.dat-inicial
                      usucarproc.dt-fim          = import-cobert-bnfciar.dat-final
                      usucarproc.dt-cancelamento = import-cobert-bnfciar.dat-cancel
                      usucarproc.cd-userid       = v_cod_usuar_corren
                      usucarproc.cd-tab-preco    = cd-tab-preco-aux
                      usucarproc.dt-atualizacao  = today
                      usucarproc.cd-modulo       = import-cobert-bnfciar.cdn-modulo
                      usucarproc.cd-tipo-insumo  = int(import-cobert-bnfciar.cod-tip-insumo)
                      usucarproc.cd-proced-insumo= import-cobert-bnfciar.cd-proc-insu
                      usucarproc.lg-procedimento = lg-procedimento-aux 
                      usucarproc.lg-carencia     = yes     
                      usucarproc.in-carencia     = import-cobert-bnfciar.in-carencia     
                      usucarproc.nr-dias         = import-cobert-bnfciar.nr-dias              
                      usucarproc.lg-cobertura    = yes.
             end.

        IF lg-gerar-termo-aux
        THEN DO:
               if   usuario.dt-inclusao-plano > usucarproc.dt-inicio
               then assign usucarproc.dt-inicio       = usuario.dt-inclusao-plano.
               
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
             END.
        
        find b-usuario where rowid(b-usuario) = rowid(usuario) exclusive-lock no-error.
        if avail b-usuario
        then assign b-usuario.lg-cobertura-esp = yes.
        release b-usuario.
        
        release usucarproc.

    END.

END PROCEDURE.

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
                  tmp-par-usmovadm.cd-userid            = v_cod_usuar_corren.

           run api-usmovadm in h-api-usmovadm-aux (input-output table tmp-usmovadm,
                                                   input-output table tmp-par-usmovadm,
                                                   output       table tmp-msg-usmovadm,
                                                   input        no).
           
           if   return-value = "erro"
           then for each tmp-msg-usmovadm:
                      RUN pi-cria-tt-erros(tmp-msg-usmovadm.ds-mensagem + " " +
                                           tmp-msg-usmovadm.ds-chave).
                      assign lg-relat-erro = yes.
                  end.
         END.

END PROCEDURE.

/* ------------------------------------------------------------------------- */
procedure remover.
   DEF BUFFER b-propost FOR propost.
 
   RUN escrever-log("@@@@@OCORREU ERRO. METODO REMOVER: MODALIDADE/PROPOSTA/USUARIO: " + STRING(b-import-bnfciar.cd-modalidade) + "/" +
                    STRING(propost.nr-proposta) + "/" + STRING(ct-codigo)).

   find usuario where usuario.cd-modalidade = b-import-bnfciar.cd-modalidade
                  and usuario.nr-proposta   = propost.nr-proposta
                  and usuario.cd-usuario    = ct-codigo
                      exclusive-lock no-error.
   if   avail usuario
   then do:
          find propost where propost.cd-modalidade = b-import-bnfciar.cd-modalidade 
                         and propost.nr-proposta   = propost.nr-proposta
                             NO-LOCK no-error.

          /*a logica dessa procedure nao faz sentido nesse ponto.*/
          /*run proc-faixa.*/
              
          FOR FIRST modalid  FIELDS (pc-afericao)
              where modalid.cd-modalidade = b-import-bnfciar.cd-modalidade NO-LOCK:
          END.
          if   avail modalid
          then do:
                 if   modalid.pc-afericao <> 0
                 then do:
                        find pr-id-us where pr-id-us.cd-modalidade      = usuario.cd-modalidade
                                        and pr-id-us.nr-proposta        = usuario.nr-proposta
                                        and pr-id-us.cd-grau-parentesco = usuario.cd-grau-parentesco
                                        and pr-id-us.nr-faixa-etaria    = tt-import-bnfciar.nr-faixa-etaria      
                                            exclusive-lock no-error.
                        if   avail pr-id-us    
                        then do:
                               if   pr-id-us.qt-pessoas = 1
                               then delete pr-id-us.
                               else pr-id-us.qt-pessoas = pr-id-us.qt-pessoas - 1.
                             end.
                  
                        FOR FIRST b-propost EXCLUSIVE-LOCK WHERE ROWID(b-propost) = ROWID(propost):
                            if   usuario.cd-usuario = usuario.cd-titular
                            then assign b-propost.nr-pessoas-titulares   = b-propost.nr-pessoas-titulares   - 1.
                            else assign b-propost.nr-pessoas-dependentes = b-propost.nr-pessoas-dependentes - 1.              
                        END.
                      end.
               end.

          for each usumodu use-index usumod1 
             where usumodu.cd-modalidade = b-import-bnfciar.cd-modalidade
               and usumodu.nr-proposta   = propost.nr-proposta
               and usumodu.cd-usuario    = ct-codigo
                   exclusive-lock:

              delete usumodu.
          end.
          for each usurepas 
             where usurepas.cd-modalidade = b-import-bnfciar.cd-modalidade   
               and usurepas.nr-proposta   = propost.nr-proposta
               and usurepas.cd-usuario    = ct-codigo
                   exclusive-lock:

              delete usurepas.                    
          end.                
                  
          for each usureate 
             where usureate.cd-modalidade = b-import-bnfciar.cd-modalidade
               and usureate.nr-proposta   = propost.nr-proposta
               and usureate.cd-usuario    = ct-codigo
                   exclusive-lock:
                                  
              delete usureate.                    
          end.                        
 
          for each usmovadm
             where usmovadm.cd-modalidade = b-import-bnfciar.cd-modalidade
               and usmovadm.nr-proposta   = propost.nr-proposta
               and usmovadm.cd-usuario    = ct-codigo
                   exclusive-lock:
                                  
              delete usmovadm.                    
          end.                        

          for each usucaren 
             where usucaren.cd-modalidade = b-import-bnfciar.cd-modalidade           
               and usucaren.nr-proposta   = propost.nr-proposta
               and usucaren.cd-usuario    = ct-codigo        
                   exclusive-lock:
              
              delete usucaren.                    
          end.    

          for each usucarproc 
             where usucarproc.cd-modalidade = b-import-bnfciar.cd-modalidade
               and usucarproc.nr-proposta   = propost.nr-proposta
               and usucarproc.cd-usuario    = ct-codigo
                   exclusive-lock:

              delete usucarproc.
          end.
          
          for each relac-decla-saude-proced 
             where relac-decla-saude-proced.cd-modalidade      = b-import-bnfciar.cd-modalidade                           
               and relac-decla-saude-proced.nr-proposta        = propost.nr-proposta                             
               and relac-decla-saude-proced.cd-usuario         = ct-codigo        
                   exclusive-lock.                                  
                                                                                
              delete relac-decla-saude-proced.                                                 
          end.

          for each car-ide
             where car-ide.cd-modalidade = b-import-bnfciar.cd-modalidade
               and car-ide.nr-ter-adesao = propost.nr-ter-adesao
               and car-ide.cd-usuario    = ct-codigo
                   exclusive-lock:

              delete car-ide.
          end.

          for each ususubst
             where ususubst.cd-modalidade = b-import-bnfciar.cd-modalidade
               and ususubst.nr-ter-adesao = propost.nr-proposta           
               and ususubst.cd-usuario    = ct-codigo 
                   exclusive-lock:                     

              delete ususubst.
          end.

          delete usuario.
        end.
 
end procedure.
 
/* ------------------------------------------------------------------------- */

/**
 * Comentado pois somente era chamado dentro do metodo "remover", e nao vejo sentido nessa logica.
 * Alex Boeira - 24/02
 
procedure proc-faixa:

   if   propost.lg-faixa-etaria-esp = yes
   then do:
          if can-find(first teadgrpa 
                      where teadgrpa.cd-modalidade      = propost.cd-modalidade
                        and teadgrpa.nr-proposta        = propost.nr-proposta 
                        and teadgrpa.cd-grau-parentesco = usuario.cd-grau-parentesco)     
          then do:
                 /*----- ROTINA PARA CALCULO DA IDADE -----*/
                 run rtp/rtidade.p ( input usuario.dt-nascimento,
                                     input today,
                                     output nr-idade-usuario,
                                     output lg-erro-aux ).
             
                 assign lg-achou = no.    
 
                 for each teadgrpa FIELDS (nr-idade-minima nr-idade-maxima nr-faixa-etaria)
                    where teadgrpa.cd-modalidade      = propost.cd-modalidade
                      and teadgrpa.nr-proposta        = propost.nr-proposta
                      and teadgrpa.cd-grau-parentesco = usuario.cd-grau-parentesco 
                          no-lock:
                     
                     if   nr-idade-usuario >= teadgrpa.nr-idade-minima
                     and  nr-idade-usuario <= teadgrpa.nr-idade-maxima
                     then do:
                            assign lg-achou  = yes         
                                   tt-import-bnfciar.nr-faixa-etaria = teadgrpa.nr-faixa-etaria.
                            leave.
                          end.
                 end.
               end.
        end.
   else do:  
          if can-find(first pl-gr-pa 
                      where pl-gr-pa.cd-modalidade       = propost.cd-modalidade
                        and pl-gr-pa.cd-plano            = propost.cd-plano
                        and pl-gr-pa.cd-tipo-plano       = propost.cd-tipo-plano
                        and pl-gr-pa.cd-grau-parentesco  = usuario.cd-grau-parentesco)
          then do:
                 /*----- ROTINA PARA CALCULO DA IDADE -----*/
                 run rtp/rtidade.p ( input usuario.dt-nascimento,
                                     input today,
                                     output nr-idade-usuario,
                                     output lg-erro-aux ).
 
                 assign lg-achou = no.    
                      
                 for each pl-gr-pa FIELDS (nr-idade-minima nr-idade-maxima nr-faixa-etaria)
                    where pl-gr-pa.cd-modalidade      = propost.cd-modalidade
                      and pl-gr-pa.cd-plano           = propost.cd-plano
                      and pl-gr-pa.cd-tipo-plano      = propost.cd-tipo-plano
                      and pl-gr-pa.cd-grau-parentesco = usuario.cd-grau-parentesco
                          no-lock:
 
                     if   nr-idade-usuario >= pl-gr-pa.nr-idade-minima
                     and  nr-idade-usuario <= pl-gr-pa.nr-idade-maxima
                     then do:
                            assign lg-achou = yes
                                   tt-import-bnfciar.nr-faixa-etaria = pl-gr-pa.nr-faixa-etaria.
                            leave.
                          end.
                 end.
               end.
        end.
                    
end procedure.
*/

/* -------------------------------------------------- Cria pessoa f¡sica --- */

/* COMENTADO EM 23/03/2018 POIS NUNCA Eh CHAMADO
procedure cria-pessoa-fisica:

    def output parameter lg-erro-par as log no-undo.

    assign lg-erro-par = no.

    empty temp-table rowErrors.
    empty temp-table tmpConfigFileAuditory.
    empty temp-table tmpDemographic.
    empty temp-table tmpContact.
    empty temp-table tmpAddress.
    
    create tmpConfigFileAuditory.
    assign tmpConfigFileAuditory.nm-usuario-sistema = v_cod_usuar_corren.

    create tmpDemographic.
    assign tmpDemographic.id-pessoa                = 0
           tmpDemographic.nm-pessoa                = caps(nome-usuario-aux)
           tmpDemographic.cd-cpf                   = b-import-bnfciar.cd-cpf                 
           tmpDemographic.dt-nascimento            = b-import-bnfciar.dt-nascimento       
           tmpDemographic.in-estado-civil          = int(b-import-bnfciar.in-est-civil)                 
           tmpDemographic.lg-sexo                  = b-import-bnfciar.log-sexo
           tmpDemographic.nr-identidade            = b-import-bnfciar.nr-identidade           
           tmpDemographic.uf-emissor-ident         = caps(b-import-bnfciar.uf-emissor-ident)      
           tmpDemographic.nm-cartao                = b-import-bnfciar.nom-usuario
           tmpDemographic.nm-internacional         = b-import-bnfciar.nom-internac 
           tmpDemographic.ds-nacionalidade         = caps(b-import-bnfciar.des-nacion)       
           tmpDemographic.ds-natureza-doc          = caps(b-import-bnfciar.des-natur-docto)        
           tmpDemographic.nr-pis-pasep             = b-import-bnfciar.cd-pis-pasep         
           tmpDemographic.nm-mae                   = b-import-bnfciar.nom-mae
           tmpDemographic.nm-pai                   = b-import-bnfciar.nom-pai
           tmpDemographic.nm-conjuge               = ""
           tmpDemographic.ds-orgao-emissor-ident   = b-import-bnfciar.des-orgao-emissor-ident 
           tmpDemographic.nm-pais-emissor-ident    = b-import-bnfciar.nom-pais
           tmpDemographic.dt-emissao-ident         = b-import-bnfciar.dt-emissao-ident
           tmpDemographic.nr-cei                   = ""
           tmpDemographic.cd-cartao-nacional-saude = b-import-bnfciar.cd-cartao-nacional-saude
           tmpDemographic.cd-userid                = v_cod_usuar_corren.

    create tmpAddress.
    assign tmpAddress.id-pessoa        = tmpDemographic.id-pessoa
           tmpAddress.id-endereco      = 0     
           tmpAddress.ds-endereco      = caps(b-import-bnfciar.en-rua)     
           tmpAddress.ds-complemento   = ""
           tmpAddress.ds-bairro        = caps(b-import-bnfciar.en-bairro) 
           tmpAddress.cd-cep           = string(b-import-bnfciar.en-cep)
           tmpAddress.cd-uf            = caps(b-import-bnfciar.en-uf)
           tmpAddress.cd-cidade        = cd-cidade-aux
           tmpAddress.in-tipo-endereco = 1 /*Residencial*/
           tmpAddress.ds-endereco-grid = ""
           tmpAddress.nr-caixa-postal  = ""
           tmpAddress.tp-logradouro    = "Rua"
           tmpAddress.lg-end-cobranca  = yes
           tmpAddress.lg-principal     = yes.

    find first dzcidade
         where dzcidade.cd-cidade = cd-cidade-aux no-lock no-error.
    if   avail dzcidade
    then assign tmpAddress.nm-cidade = dzcidade.nm-cidade.
    else assign tmpAddress.nm-cidade = "".   

    if b-import-bnfciar.nr-telefone1 <> ""
    then do:
           create tmpContact.
           assign tmpContact.id-contato  = 0
                  tmpContact.id-pessoa   = 0
                  tmpContact.tp-contato  = 2 /* endereco residencial */
                  tmpContact.ds-contato  = b-import-bnfciar.nr-telefone1
                  tmpContact.ds-ramal    = ""
                  tmpContact.nm-contato  = ""
                  tmpContact.id-endereco = tmpAddress.id-endereco.
         end.

    if b-import-bnfciar.nr-telefone2 <> ""
    then do:
           create tmpContact.
           assign tmpContact.id-contato  = 0
                  tmpContact.id-pessoa   = 0
                  tmpContact.tp-contato  = 2  /* endereco residencial */
                  tmpContact.ds-contato  = b-import-bnfciar.nr-telefone2
                  tmpContact.ds-ramal    = ""
                  tmpContact.nm-contato  = ""
                  tmpContact.id-endereco = tmpAddress.id-endereco.
         end.

    if b-import-bnfciar.nom-email <> ""
    then do:
           create tmpContact.
           assign tmpContact.id-contato  = 0
                  tmpContact.id-pessoa   = 0
                  tmpContact.tp-contato  = 4  /* email */
                  tmpContact.ds-contato  = b-import-bnfciar.nom-email
                  tmpContact.ds-ramal    = ""
                  tmpContact.nm-contato  = ""
                  tmpContact.id-endereco = tmpAddress.id-endereco.
         end.
    
    /* --------------------------------------------------------------------- */
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
   and h-handle-aux:name = "bosau/bosaudemographic.p"
   then do:

          if  id-requisicao-handle-aux  <> ""
          and h-handle-aux:private-data  = id-requisicao-handle-aux
          then do:
                 assign h-bosauDemographic-aux = h-handle-aux.
                 leave.
               end.
        end.
           
   assign h-handle-aux = h-handle-aux:prev-sibling.
end.

if not valid-handle(h-handle-aux) 
then do:
       run bosau/bosaudemographic.p persistent set h-bosauDemographic-aux .

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

       h-bosauDemographic-aux:private-data = id-requisicao-handle-aux.





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
                                    input h-bosauDemographic-aux:name,
                                    input h-bosauDemographic-aux:private-data).
            end.

     end.
 
    
    run syncDemographic in h-bosauDemographic-aux(input        table tmpConfigFileAuditory,
                                                  input        table tmpContact,
                                                  input        table tmpAddress,
                                                  input        table tmpAttachment,
                                                  input no, /* parâmetro para envio ao crm log-enviar-crm-par */
                                                  input no, /* parametro que indica se a solicitacao vem da manut. prestadores */
                                                  input no, /* parametro que indica se devera validar a obrigatoriedade dos anexos */
                                                  input-output table tmpDemographic,
                                                  input-output table rowErrors) no-error.
    if error-status:error
    then do:
           assign lg-erro-par   = yes
                  lg-relat-erro = yes
                  lg-retorna    = yes.

           if error-status:num-messages = 0
           then RUN pi-cria-tt-erros("Ocorreram erros na execucao da bosauDemographic").
           else RUN pi-cria-tt-erros("Ocorreram erros na execucao da bosauDemographic " + substring(error-status:get-message(error-status:num-messages),1,175)).

           return.
         end.

    for each rowErrors no-lock:

        if rowErrors.errorSubType = "ERROR"
        then do:
               assign lg-erro-par   = yes
                      lg-relat-erro = yes
                      lg-retorna    = yes.
               
               RUN pi-cria-tt-erros(string(rowErrors.errorNumber) + " - " + rowErrors.errorDescription).               
             end.
    end.

    if lg-erro-par
    then return.

    find first tmpDemographic no-lock no-error.

    if not avail tmpDemographic
    then do:
           RUN pi-cria-tt-erros("Nao foi possivel criar a pessoa fisica").
           
           assign lg-erro-par   = yes
                  lg-relat-erro = yes
                  lg-retorna    = yes.
           return.
         end.    

end procedure.
*/

/* ---------------- INCLUDE PARE ENTRADA DE DADOS DA ANS --------------- */
/* ------- TABELAS TEMPORARIS UTILIZADADAS SOMENTE PARA OS PROGRAMAS ------------------- */
/* ---- mc0112a.p, vpapi025.p e api-usuario.p (funcoes de modificaoao) ----------------- */
/* ------------------------------------------------------------------------------------- */     
def temp-table tmp-usuario-antes no-undo                                                          
    fields nm-usuario                   like usuario.nm-usuario                                   
    fields dt-nascimento                like usuario.dt-nascimento                                
    fields lg-sexo                      like usuario.lg-sexo                                      
    fields cd-cpf                       like usuario.cd-cpf                                       
    fields cd-pis-pasep                 like usuario.cd-pis-pasep                                 
    fields cd-cartao-nacional-saude     like usuario.cd-cartao-nacional-saude                     
    fields nm-mae                       like usuario.nm-mae                                       
    fields cd-registro-plano            like usuario.cd-registro-plano                            
    fields en-rua                       like usuario.en-rua                                       
    fields en-bairro                    like usuario.en-bairro                                    
    fields cd-cidade                    like usuario.cd-cidade                                    
    fields en-uf                        like usuario.en-uf                                        
    fields en-cep                       like usuario.en-cep                                       
    fields in-segmento-assistencial     like usuario.in-segmento-assistencial                     
    fields cd-titular                   like usuario.cd-titular                                   
    fields cd-usuario                   like usuario.cd-usuario                                   
    fields cd-motivo-cancel             like usuario.cd-motivo-cancel
    fields in-registro-plano            like propost.in-registro-plano
    fields cd-grau-parentesco           like usuario.cd-grau-parentesco
    fields lg-cobra-fator-moderador     like usuario.lg-cobra-fator-moderador
    fields nr-identidade                like usuario.nr-identidade
    fields cd-padrao-cobertura          like usuario.cd-padrao-cobertura
    fields nr-prod-origem               like usuario.char-13
    fields cd-cidade-origem             like usuario.int-14
    fields nr-rowid                     as rowid.                                                 
                                                                                                   
def temp-table tmp-usuario-depois no-undo                                                         
    fields nm-usuario                   like usuario.nm-usuario                                   
    fields dt-nascimento                like usuario.dt-nascimento                                
    fields lg-sexo                      like usuario.lg-sexo                                      
    fields cd-cpf                       like usuario.cd-cpf                                       
    fields cd-pis-pasep                 like usuario.cd-pis-pasep                                 
    fields cd-cartao-nacional-saude     like usuario.cd-cartao-nacional-saude                     
    fields nm-mae                       like usuario.nm-mae                                       
    fields cd-registro-plano            like usuario.cd-registro-plano 
    fields en-rua                       like usuario.en-rua                                       
    fields en-bairro                    like usuario.en-bairro                                    
    fields cd-cidade                    like usuario.cd-cidade                                    
    fields en-uf                        like usuario.en-uf                                        
    fields en-cep                       like usuario.en-cep                                       
    fields in-segmento-assistencial     like usuario.in-segmento-assistencial                     
    fields cd-titular                   like usuario.cd-titular                                   
    fields cd-usuario                   like usuario.cd-usuario                                   
    fields cd-motivo-cancel             like usuario.cd-motivo-cancel
    fields cd-grau-parentesco           like usuario.cd-grau-parentesco
    fields lg-cobra-fator-moderador     like usuario.lg-cobra-fator-moderador
    fields nr-identidade                like usuario.nr-identidade
    fields cd-padrao-cobertura          like usuario.cd-padrao-cobertura
    fields cd-cidade-origem             like usuario.int-14
    fields nr-prod-origem               like usuario.char-13.
    
define variable lg-consiste-parametros-ende-aux as logical               no-undo.
define variable lg-cons-sib-inc-alt-aux         like paravpmc.log-13     no-undo.
define variable lg-cons-sib-exc-aux             like paravpmc.log-12     no-undo.

/* ------------------------------------------------------------------------------------ */                                                                                                          
                                                                                                  
procedure cria-temp-antes:                                                                        
                                                                                                  
   if not avail propost
   then do:
          find propost                                                 
               where propost.cd-modalidade = usuario.cd-modalidade 
                 and propost.nr-proposta   = usuario.nr-proposta   
                     no-lock no-error.                                 

          if not avail propost 
          then return.
        end.

   empty temp-table tmp-usuario-antes.

   create tmp-usuario-antes.                                                                      
   assign tmp-usuario-antes.nm-usuario               = usuario.nm-usuario                         
          tmp-usuario-antes.dt-nascimento            = usuario.dt-nascimento                      
          tmp-usuario-antes.lg-sexo                  = usuario.lg-sexo                            
          tmp-usuario-antes.cd-cpf                   = usuario.cd-cpf                             
          tmp-usuario-antes.cd-pis-pasep             = usuario.cd-pis-pasep                       
          tmp-usuario-antes.cd-cartao-nacional-saude = usuario.cd-cartao-nacional-saude           
          tmp-usuario-antes.nm-mae                   = usuario.nm-mae                             
          tmp-usuario-antes.cd-registro-plano        = usuario.cd-registro-plano                  
          tmp-usuario-antes.en-rua                   = usuario.en-rua                             
          tmp-usuario-antes.en-bairro                = usuario.en-bairro                          
          tmp-usuario-antes.cd-cidade                = usuario.cd-cidade                          
          tmp-usuario-antes.en-uf                    = usuario.en-uf                              
          tmp-usuario-antes.en-cep                   = usuario.en-cep                             
          tmp-usuario-antes.in-segmento-assistencial = usuario.in-segmento-assistencial           
          tmp-usuario-antes.cd-usuario               = usuario.cd-usuario                         
          tmp-usuario-antes.cd-titular               = usuario.cd-titular                         
          tmp-usuario-antes.cd-motivo-cancel         = usuario.cd-motivo-cancel
          tmp-usuario-antes.in-registro-plano        = propost.in-registro-plano
          tmp-usuario-antes.cd-grau-parentesco       = usuario.cd-grau-parentesco
          tmp-usuario-antes.lg-cobra-fator-moderador = usuario.lg-cobra-fator-moderador
          tmp-usuario-antes.nr-identidade            = usuario.nr-identidade
          tmp-usuario-antes.cd-padrao-cobertura      = usuario.cd-padrao-cobertura
          tmp-usuario-antes.nr-prod-origem           = usuario.char-13
          tmp-usuario-antes.cd-cidade-origem         = usuario.int-14
          tmp-usuario-antes.nr-rowid                 = rowid(usuario).                            
                                                                                                  
end procedure.                                                                                    
                                                                                                  
/* ------------------------------------------------------------------------------------ */        
                                                                                                  
procedure cria-temp-depois-e-compara:    
    
   def buffer alt-usuario for usuario.                                                            
                                                                                                  
   def var lg-registros-iguais-aux    as log        no-undo.   
   def var lg-rtparamans-atualiza-aux as log        no-undo. 
   def var ds-mensagem                as char       no-undo.
   def var lg-nao-exporta             as log        no-undo. 
   def var nr-reg-plano-aux           as int init 0 no-undo.
   def var nr-recid-ti-pl-sa          as recid      no-undo.
   
   find first paramecp no-lock no-error.                
   if not avail paramecp
   then do:
          message "Parametros modulos VP/MC nao cadastrados!"
          view-as alert-box title "Atencao!!!".
          return.
        end.

   assign lg-rtparamans-atualiza-aux = no.

   find first tmp-usuario-antes no-lock no-error.                                                         
   if not avail tmp-usuario-antes                                                                 
   then return.                                                                                   

   find alt-usuario where rowid(alt-usuario) = tmp-usuario-antes.nr-rowid exclusive-lock no-error.
   if not avail alt-usuario                                                                       
   then return.

   if  alt-usuario.cd-unimed-origem <> 0
   and alt-usuario.cd-unimed-origem <> paramecp.cd-unimed
   then do:
          if (search("progx/af0500ax.p") <> ?
          or  search("progx/af0500ax.r") <> ?)
          and avail propost
          then do:
                 if   avail ti-pl-sa
                 then assign nr-recid-ti-pl-sa = recid(ti-pl-sa).
                 else do:  
                        find first ti-pl-sa where ti-pl-sa.cd-modalidade = propost.cd-modalidade
                                              and ti-pl-sa.cd-plano      = propost.cd-plano
                                              and ti-pl-sa.cd-tipo-plano = propost.cd-tipo-plano
                                                  no-lock no-error.
                        if avail ti-pl-sa
                        then do:
                               assign nr-recid-ti-pl-sa = recid(ti-pl-sa).
                               release ti-pl-sa.
                             end.
                        else return.
                      end.

                 run progx/af0500ax.p (input "3",
                                       input recid(alt-usuario),
                                       input recid(propost),
                                       input nr-recid-ti-pl-sa,
                                       input  ?,
                                       input-output nr-reg-plano-aux,
                                       output ds-mensagem,
                                       output lg-nao-exporta).
                 if ds-mensagem <> ""
                 then message ds-mensagem skip
                              "Erro no programa af0500ax.p"
                              view-as alert-box title "Atencao!!!".

                 if lg-nao-exporta
                 then return.
               end.
          else return.
        end.

   if  alt-usuario.cd-sit-usuario <> 5
   and alt-usuario.cd-sit-usuario <> 6
   and alt-usuario.cd-sit-usuario <> 7
   and alt-usuario.cd-sit-usuario <> 90
   then return.
           
   empty temp-table tmp-usuario-depois.                                                           
           
   create tmp-usuario-depois.  
   assign tmp-usuario-depois.nm-usuario               = alt-usuario.nm-usuario                    
          tmp-usuario-depois.dt-nascimento            = alt-usuario.dt-nascimento                 
          tmp-usuario-depois.lg-sexo                  = alt-usuario.lg-sexo                       
          tmp-usuario-depois.cd-cpf                   = alt-usuario.cd-cpf                        
          tmp-usuario-depois.cd-pis-pasep             = alt-usuario.cd-pis-pasep                  
          tmp-usuario-depois.cd-cartao-nacional-saude = alt-usuario.cd-cartao-nacional-saude      
          tmp-usuario-depois.nm-mae                   = alt-usuario.nm-mae                        
          tmp-usuario-depois.cd-registro-plano        = alt-usuario.cd-registro-plano  
          tmp-usuario-depois.en-rua                   = alt-usuario.en-rua                        
          tmp-usuario-depois.en-bairro                = alt-usuario.en-bairro                     
          tmp-usuario-depois.cd-cidade                = alt-usuario.cd-cidade                     
          tmp-usuario-depois.en-uf                    = alt-usuario.en-uf                         
          tmp-usuario-depois.en-cep                   = alt-usuario.en-cep                        
          tmp-usuario-depois.in-segmento-assistencial = alt-usuario.in-segmento-assistencial      
          tmp-usuario-depois.cd-usuario               = alt-usuario.cd-usuario                    
          tmp-usuario-depois.cd-titular               = alt-usuario.cd-titular                    
          tmp-usuario-depois.cd-motivo-cancel         = alt-usuario.cd-motivo-cancel
          tmp-usuario-depois.cd-grau-parentesco       = alt-usuario.cd-grau-parentesco
          tmp-usuario-depois.lg-cobra-fator-moderador = alt-usuario.lg-cobra-fator-moderador
          tmp-usuario-depois.nr-identidade            = alt-usuario.nr-identidade
          tmp-usuario-depois.cd-padrao-cobertura      = alt-usuario.cd-padrao-cobertura
          tmp-usuario-depois.nr-prod-origem           = alt-usuario.char-13
          tmp-usuario-depois.cd-cidade-origem         = alt-usuario.int-14.

   buffer-compare tmp-usuario-antes except tmp-usuario-antes.cd-registro-plano
                                           tmp-usuario-antes.cd-titular
                                           tmp-usuario-antes.cd-usuario 
                  to tmp-usuario-depois save result in lg-registros-iguais-aux.

   if lg-registros-iguais-aux = no                                                                  
   then assign lg-rtparamans-atualiza-aux = yes.
   else do:
          if  tmp-usuario-antes.cd-registro-plano <> tmp-usuario-depois.cd-registro-plano 
          and tmp-usuario-antes.in-registro-plano = 2
          then assign lg-rtparamans-atualiza-aux = yes.

          if  tmp-usuario-antes.cd-titular  =  tmp-usuario-antes.cd-usuario                       
          and tmp-usuario-depois.cd-titular <> tmp-usuario-depois.cd-usuario                      
          then assign lg-rtparamans-atualiza-aux = yes.
                
          if  tmp-usuario-antes.cd-titular  <> tmp-usuario-antes.cd-usuario                       
          and tmp-usuario-depois.cd-titular =  tmp-usuario-depois.cd-usuario                      
          then assign lg-rtparamans-atualiza-aux = yes.
        end.

   if lg-rtparamans-atualiza-aux = yes
   then do:
          assign alt-usuario.dt-alt-ans        = today
                 alt-usuario.cd-userid-alt-ans = v_cod_usuar_corren.
  
          validate alt-usuario.
          release  alt-usuario.
       end.

end procedure.                                                                                    


PROCEDURE pi-cria-tt-erros:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.

    FOR LAST b-tt-erro FIELDS (nr-seq) 
       WHERE b-tt-erro.nr-seq-contr = b-import-bnfciar.num-seqcial-control NO-LOCK:
    END.

    CREATE tt-erro.

    IF AVAIL b-tt-erro
    THEN ASSIGN tt-erro.nr-seq = b-tt-erro.nr-seq + 1.
    ELSE ASSIGN tt-erro.nr-seq = 1.      
            
    ASSIGN tt-erro.nr-seq-contr      = b-import-bnfciar.num-seqcial-control
           tt-erro.nom-tab-orig-erro = "BE - import-bnfciar"
           tt-erro.des-erro          = ds-erro-par.

END PROCEDURE.

PROCEDURE pi-cria-tt-erros2:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.
    DEF INPUT PARAM ds-ajuda-par AS CHAR NO-UNDO.

    FOR LAST b-tt-erro FIELDS (nr-seq) 
       WHERE b-tt-erro.nr-seq-contr = b-import-bnfciar.num-seqcial-control NO-LOCK:
    END.

    CREATE tt-erro.

    IF AVAIL b-tt-erro
    THEN ASSIGN tt-erro.nr-seq = b-tt-erro.nr-seq + 1.
    ELSE ASSIGN tt-erro.nr-seq = 1.      
            
    ASSIGN tt-erro.nr-seq-contr      = b-import-bnfciar.num-seqcial-control
           tt-erro.nom-tab-orig-erro = "BE - import-bnfciar"
           tt-erro.des-erro          = ds-erro-par
           tt-erro.des-ajuda         = ds-ajuda-par.

END PROCEDURE.

/**
 * Este metodo nao precisa possuir logica. Seu objetivo eh listar ds-msg-aux no clientlog.
 */
PROCEDURE escrever-log:
    DEF INPUT PARAM ds-msg-aux AS CHAR NO-UNDO.
END PROCEDURE.

/* --------------------------------------------------------------------- */
/* -------------------------------------------------------------- EOF -- */
