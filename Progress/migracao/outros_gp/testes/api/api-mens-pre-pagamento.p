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
assign c_prg_vrs = "2.00.00.005".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'API-MENS-PRE-PAGAMENTO':U, '2.00.00.005':U, '':U).
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
  /*** 010005 ***/



/********************************************************************************
*  Programa......: api-mens-pre-pagamento.p                                     *
*  Data .........:                                                              *
*  Sistema ......:                                                              *
*  Empresa ......: TOTVS                                                        *
*  Programador ..:                                                              *
*  Objetivo .....:                                                              *
*********************************************************************************/
/* ----------------------------------- DEFINE O NOME DA PERSISTÒNCIA DA API --- */
this-procedure:private-data = "api-mens-pre-pagamento".

/* -------------------------------------- INCLUDES ---------------------------- */
/*****************************************************************************
*      Programa .....: rtregrasdesc.i                                        *
*      Data .........: 03 de outubro de 2014                                 *
*      Empresa ......: TOTVS                                                 *
*      Cliente ......: Cooperativas Medicas                                  *
*      Sistema ......: FP - Faturamento de Planos                            *
*      Programador ..: Diogo W. Zanin                                        *
*      Objetivo .....: Definicao das tabelas temporarias do rtregrasdesc.p   *
******************************************************************************/

/* -------------------------------------- VARIAVEIS USADAS PARA DESCONTO --- */
def var lg-desconto-aux            as log    initial no                 no-undo.
def var cd-evento-desconto-aux     as integer                           no-undo.
def var vl-desconto-total-aux      as decimal                           no-undo. /* kask retirar */

/* ------------------------------------------ TEMP EVENTOS PARA DESCONTO --- */
define temp-table tmp-event-desc-menslid
   field in-classe-evento       as character.

define temp-table tmp-familia 
   field cd-titular         as int 
   field nr-meses           as int
   field qt-dependentes     as int
   field lg-utilizacao      as log
         index tmpFamili01
               is primary  cd-titular 
         index tmpFamili02
               lg-utilizacao.

define temp-table tmp-usu-desconto
       field cd-familia              as int
       field cd-usuario              as int  
       field pc-desconto as dec
             index tmpUs01
               is primary cd-familia
                          cd-usuario.
                   
define temp-table tmp-grau-faixa-desconto
            field cd-grau-parentesco  as int   
            field nr-faixa-etaria     as int
            field vl-desconto         as dec
                  index tmpGrauFaixa01
                    is primary cd-grau-parentesco
                               nr-faixa-etaria.
            

       
 
/*****************************************************************************
*      Programa .....: fpnomrot.i                                            *
*      Data .........: 12 de junho de 2000                                   *
*      Sistema ......: FP - Faturamento                                      *
*      Empresa ......: DZset Solucoes e Sistemas para Computacao Ltda.       *
*      Cliente ......: COOPERATIVAS MEDICAS                                  *
*      Programador ..: Monia Regina Turella                                  *
*      Objetivo .....: Nome das procedures das rotinas de calculo            *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*      D.00.000  12/06/2000  Monia          Desenvolvimento                  *
*      E.00.000  25/10/2000  Nora           Mudanca Versao Banco             *
*      E.01.000  08/02/2001  Monia          Incluir Primeira mensalidade     *
*      E.02.000  28/03/2001  Rosalva        Incluir Evento Programado        *
*                                           Percentual                       *
*****************************************************************************/

def var nm-rotinas-aux  as char extent 72                            no-undo.

assign nm-rotinas-aux[1]  = "MENSALIDADE-BASICA"
       nm-rotinas-aux[2]  = "MENSALIDADE-PROPORCIONAL"
       nm-rotinas-aux[3]  = "MENSALIDADE-ANTERIOR"
       nm-rotinas-aux[4]  = "INSCRICAO"
       nm-rotinas-aux[5]  = "NOVA-VIA-CARTEIRA"
       nm-rotinas-aux[6]  = "IMPOSTO"
       nm-rotinas-aux[7]  = "BENEFICIARIOS-MES-ATUAL"
       nm-rotinas-aux[8]  = "BENEFICIARIOS-INCLUIDOS-MES-ATUAL"
       nm-rotinas-aux[9]  = "BENEFICIARIOS-MES-ANTERIOR"
       nm-rotinas-aux[10] = "BENEFICIARIOS-INCLUIDOS-MES-ANTERIOR"
       nm-rotinas-aux[11] = "BENEFICIARIOS-EXCLUIDOS-MES-ANTERIOR"
       nm-rotinas-aux[12] = "TAXA-ADMINISTRATIVA"
       nm-rotinas-aux[13] = "FATOR-MODERADOR"
       nm-rotinas-aux[14] = "CUSTO-OPERACIONAL"
       nm-rotinas-aux[15] = "CALCULO-PROGRAMADO-VALOR"
       nm-rotinas-aux[16] = "MENSALIDADE-BASICA-SEM-PLANO"
       nm-rotinas-aux[17] = "MENSALIDADE-BASICA-SEM-GRAU"
       nm-rotinas-aux[18] = "MENSALIDADE-BASICA-SEM-PLANO-GRAU"
       nm-rotinas-aux[19] = "MENSALIDADE-PROPORCIONAL-SEM-PLANO"
       nm-rotinas-aux[20] = "MENSALIDADE-PROPORCIONAL-SEM-GRAU"
       nm-rotinas-aux[21] = "MENSALIDADE-PROPORCIONAL-SEM-PLANO-GRAU"
       nm-rotinas-aux[22] = "MENSALIDADE-ANTERIOR-SEM-PLANO"
       nm-rotinas-aux[23] = "MENSALIDADE-ANTERIOR-SEM-GRAU"
       nm-rotinas-aux[24] = "MENSALIDADE-ANTERIOR-SEM-PLANO-GRAU"
       nm-rotinas-aux[25] = "MENSALIDADE-SEM-TROCA-FAIXA"
       nm-rotinas-aux[26] = "MENSALIDADE-SEM-TROCA-FAIXA-PLANO"
       nm-rotinas-aux[27] = "MENSALIDADE-SEM-TROCA-FAIXA-GRAU"
       nm-rotinas-aux[28] = "MENSALIDADE-SEM-TROCA-FAIXA-PLANO-GRAU"
       nm-rotinas-aux[29] = "MENSALIDADE-PROPORCIONAL-SEM-TROCA"
       nm-rotinas-aux[30] = "MENSALIDADE-PROPORCIONAL-SEM-TROCA-PLANO"
       nm-rotinas-aux[31] = "MENSALIDADE-PROPORCIONAL-SEM-TROCA-GRAU"
       nm-rotinas-aux[32] = "MENSALIDADE-PROPORCIONAL-SEM-TROCA-PLANO-GRAU"
       nm-rotinas-aux[33] = "MENSALIDADE-ANTERIOR-SEM-TROCA"
       nm-rotinas-aux[34] = "MENSALIDADE-ANTERIOR-SEM-TROCA-PLANO"
       nm-rotinas-aux[35] = "MENSALIDADE-ANTERIOR-SEM-TROCA-GRAU"
       nm-rotinas-aux[36] = "MENSALIDADE-ANTERIOR-SEM-TROCA-PLANO-GRAU"
       nm-rotinas-aux[37] = "PRIMEIRA-MENSALIDADE"
       nm-rotinas-aux[38] = "PRIMEIRA-MENSALIDADE-SEM-PLANO"
       nm-rotinas-aux[39] = "PRIMEIRA-MENSALIDADE-SEM-GRAU"
       nm-rotinas-aux[40] = "PRIMEIRA-MENSALIDADE-SEM-PLANO-GRAU"
       nm-rotinas-aux[41] = "CALCULO-PROGRAMADO-PERCENTUAL"
       nm-rotinas-aux[42] = "CALCULO-PROGRAMADO-SOBRE-EVENTO"
       nm-rotinas-aux[43] = "FATURAMENTO-PERIODICO-NORMAL"
       nm-rotinas-aux[44] = "FATURAMENTO-PERIODICO-SEM-PLANO"
       nm-rotinas-aux[45] = "FATURAMENTO-PERIODICO-SEM-GRAU"
       nm-rotinas-aux[46] = "FATURAMENTO-PERIODICO-SEM-PLANO-GRAU"
       nm-rotinas-aux[47] = "FATURAMENTO-PERIODICO-PROPORCIONAL-NORMAL"
       nm-rotinas-aux[48] = "FATURAMENTO-PERIODICO-PROPORCIONAL-SEM-PLANO"
       nm-rotinas-aux[49] = "FATURAMENTO-PERIODICO-PROPORCIONAL-SEM-GRAU"
       nm-rotinas-aux[50] = "FATURAMENTO-PERIODICO-PROPORCIONAL-SEM-PLANO-GRAU"
       nm-rotinas-aux[51] = "TAXA-TRANSFERENCIA"
       nm-rotinas-aux[52] = "DILUICAO-REAJUSTE"
       nm-rotinas-aux[53] = "MENSALIDADE-PROPORC-SAIDA"
       nm-rotinas-aux[54] = "MENSALIDADE-PROPORC-SAIDA-SEM-PLANO"
       nm-rotinas-aux[55] = "MENSALIDADE-PROPORC-SAIDA-SEM-GRAU"
       nm-rotinas-aux[56] = "MENSALIDADE-PROPORC-SAIDA-SEM-PLANO-GRAU"
       nm-rotinas-aux[57] = "MENSALIDADE-PROPORC-SAIDA-SEM-TROCA-FAIXA"
       nm-rotinas-aux[58] = "MENSALIDADE-PROPORC-SAIDA-SEM-TROCA-FAIXA-PLANO"
       nm-rotinas-aux[59] = "MENSALIDADE-PROPORC-SAIDA-SEM-TROCA-FAIXA-GRAU"
       nm-rotinas-aux[60] = "MENSALIDADE-PROPORC-SAIDA-SEM-TROCA-PLANO-GRAU"
       nm-rotinas-aux[61] = "FATURAMENTO-PERIODICO-SEM-TROCA-FAIXA"
       nm-rotinas-aux[62] = "FATURAMENTO-PERIODICO-SEM-TROCA-FAIXA-PLANO"
       nm-rotinas-aux[63] = "FATURAMENTO-PERIODICO-SEM-TROCA-FAIXA-GRAU"
       nm-rotinas-aux[64] = "FATURAMENTO-PERIODICO-SEM-TROCA-FAIXA-PLANO-GRAU"
       nm-rotinas-aux[65] = "PRIMEIRA-MENSALIDADE-SEM-TROCA-FAIXA"
       nm-rotinas-aux[66] = "PRIMEIRA-MENSALIDADE-SEM-TROCA-FAIXA-PLANO"
       nm-rotinas-aux[67] = "PRIMEIRA-MENSALIDADE-SEM-TROCA-FAIXA-GRAU"
       nm-rotinas-aux[68] = "PRIMEIRA-MENSALIDADE-SEM-TROCA-FAIXA-PLANO-GRAU"
       nm-rotinas-aux[69] = "CONTESTACAO"
       nm-rotinas-aux[70] = "TAXA ADMINISTRATIVA CONTESTACAO"
       nm-rotinas-aux[71] = "REEMBOLSO"
           nm-rotinas-aux[72] = "MENSALIDADE-REAJUSTE-RETROATIVO".
 
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
        /* ------------------------ INCLUDE COM DECLARACOES RTROWERROR --- */
/******************************************************************************
*     Programa .....: rtapi044.i                                              *
*     Data .........: 23 de Abril de 2001                                     *
*     Sistema ......: RT - Rotinas Padrao                                     *
*     Empresa ......: DZSET Solucoes e Sistemas                               *
*     Programador ..: Airton Nora                                             *
*     Objetivo .....: Setar:                                                  *
*                     tmp-rtapi044 devolvendo dados inerentes ao emitente     *
*                     nos 3 sistemas da datasul                               *
*-----------------------------------------------------------------------------*
*     VERSAO    DATA        RESPONSAVEL  MOTIVO                               *
*     E.00.000  23/04/2001  Nora         Desenvolvimento                      *
*     E.01.000  19/07/2001  Leonardo     Inclusao do browse para consulta das *
*                                        inconsistencias                      *
*     E.01.001  29/08/2001  Leonardo     Ajustes no tamanho do botao do frame *
*                                        de inconsistencias                   *
*     E.02.000  04/10/2001  Nora         Fazer com que a rotina nao processe  *
*                                        a chamanda do include rtvermen.i.    *
*                                        Processar somente quando necessario  *
*                                        Redefinir o nome da tmp-contrat      *
*     E.02.001  31/10/2001  Rosalva      Correcao para atribuicao do campo    *
*                                        inscricao estadual para pessoa fisica*
*                                        do ems504                            *    
*     E.03.000  21/11/2001  Rosalva      Inclusao do digito da conta corrente *
*                                        Correcao para atribuicao do campo    *
*                                        inscricao estadual para pessoa juri- *
*                                        dica do ems504                       *    
******************************************************************************/

/******************************************************************************
* COMENTARIOS DA API                                                          *
* =========================================================================== *
*                                                                             *
* Parametro in-funcao-rtapi044-aux                                            *
* --------------------------------                                            *
* GDT - Api chamada gerando dados na temp                                     *
* CST - Api chamada consistindo dados da temp com tabelas Datasul             *                                                                            *
* =========================================================================== *
* Parametro in-tipo-emitente-rtapi044-aux                                     *
* ---------------------------------------                                     *
* PRESTA - Api chamada gerando dados para prestador                           *
* CONTRA - Api chamada gerando dados para contratante                         *   
* QUALQU - Api chamada gerando dados tanto prestador quanto contratante       *                                                                         *
* =========================================================================== *
*                                                                             *
* Parametro lg-erro-rtapi044-aux                                              *
* ------------------------------                                              *
* Indicador que retorna se houve erro dentro da API ou nao                    *
*                                                                             *
* =========================================================================== *
*                                                                             *
* Parametro lg-prim-mens-rtapi044-aux                                         *
* -----------------------------------                                         *
* Indicador obrigatorio que determina qual as mensagens que a API deve        *
* pegar primeiro                                                              *
*                                                                             *
* =========================================================================== *
*                                                                             *
* Chamada da include rtvermen.i                                               *
* -----------------------------------                                         *
* Para programas que nao necessitem seja chamada a rotina rtvermen.i entao    *
* criar um &scoped-define no programa que chama a rtapi044.i com o nome de    *
* cominclude conforme exemplo &scopde-define cominclude chama                 *                                                                            *
******************************************************************************/

/* ----------------------------------------- CHAMADA DE INCLUDE DA API rtapi044 --- */
define new shared temp-table tmp-rtapi044          no-undo
           field cd-contratante           like contrat.cd-contratante
           field nome-abrev               like contrat.nome-abrev
           field in-tipo-pessoa           like contrat.in-tipo-pessoa
           field identific                  as char format "x(01)"
           field cod-gr-cli               like contrat.cod-gr-cli
           field cod-gr-forn              like preserv.cd-grupo-prestador
           field cod-banco                  as integer format "999"
           field agencia                    as char format "x(8)"
           field agencia-digito             as char format "x(2)"
           field conta-corren               as char format "x(20)"
           field cod-digito-cta-corren      as char format "x(2)"
           field forma-pagto                as char format "x(3)"
           field en-bairro                like contrat.en-bairro
           field en-bairro-cob            like contrat.en-bairro-cob
           field en-cep                   like contrat.en-cep
           field en-cep-cob               like contrat.en-cep-cob
           field cd-cidade                like contrat.cd-cidade
           field cd-cidade-cob            like contrat.cd-cidade-cob
           field en-rua                   like contrat.en-rua
           field en-rua-cob               like contrat.en-rua-cob
           field en-uf                    like contrat.en-uf
           field en-uf-cob                like contrat.en-uf-cob
           field modalidade                 as integer format "999"
           field nm-contratante           like contrat.nm-contratante
           field nr-caixa-postal          like contrat.nr-caixa-postal
           field nr-caixa-postal-cob      like contrat.nr-caixa-postal-cob
           field nr-cgc-cpf                 as char format "x(20)"
           field nr-insc-estadual         like contrat.nr-insc-estadual
           field nr-telefone              like contrat.nr-telefone
           field portador                   as integer format ">>>>9"
           field cd-pais                    as char format "x(03)"
           field nm-pais                    as char format "x(20)"
           field tp-rec-padrao              as integer
           field tp-desp-padrao             as integer
           field nat-operacao               as char format "x(08)"
           field nr-pessoa                  as integer
           field cd-representante           as integer
           field dt-implantacao             as date
           field lg-gera-avideb           like contrat.lg-gera-avideb
           field lg-emite-boleto          like contrat.lg-emite-boleto
           field lg-retem-imposto         like contrat.lg-retem-imposto
           field lg-neces-acomp-spc       like contrat.lg-neces-acomp-spc
           field cd-moeda-corrente          as char format "x(8)"
           field nr-fax                   as char format "x(20)"
           field nr-ramal-fax             like unimed.nr-ramal-fax
           field nr-telex                 like unimed.nr-telex
           field nm-email                 like unimed.nm-email
           field nr-telefone-atendimento  like unimed.nr-telefone-atendimento.

/* ------------ DEFINICAO DA TABELA TEMPORARIA MENSAGENS rtapi044 COMPARTILHADA --- */
define new shared temp-table tmp-mensa-rtapi044    no-undo
           field cd-mensagem-mens         like mensiste.cd-mensagem
           field ds-mensagem-mens         like mensiste.ds-mensagem-sistema
           field ds-complemento-mens      like mensiste.ds-mensagem-sistema
           field in-tipo-mensagem-mens    like mensiste.in-tipo-mensagem
           field ds-chave-mens            like mensiste.ds-mensagem-sistema.

/* ---------------------------------------- PARAMETROS GENERICOS COMPARTILHADOS --- */
define new shared var lg-prim-mens-rtapi044-aux    as logical                 no-undo.
define new shared var in-funcao-rtapi044-aux       as char    format "x(03)"  no-undo.
define new shared var lg-erro-rtapi044-aux         as logical                 no-undo.
define new shared var in-tipo-emitente-rtapi044-aux as char   format "x(06)"  no-undo.

/* -------------------------------------- PARAMETROS ESPECIFICOS COMPARTILHADOS --- */
define new shared var cd-contratante-rtapi044-aux like contrat.cd-contratante no-undo.
define new shared var nome-abrev-rtapi044-aux     like contrat.nome-abrev     no-undo.
define new shared var nr-cgc-cpf-rtapi044-aux     like contrat.nr-cgc-cpf     no-undo.
define new shared var in-tipo-pessoa-rtapi044-aux like contrat.in-tipo-pessoa no-undo.

/* ------------------------------------ CHAMADA DE INCLUDE DAS MENSAGENS --- */
/************************************************************************************************
*      Programa .....: rtvermen.i                                                               *
*      Data .........: 22 de Junho de 1999                                                      *
*      Sistema ......: API'S Padrao                                                             *
*      Empresa ......: DZSET Solucoes e Sistemas                                                *
*      Programador ..: Airton Nora                                                              *
*      Objetivo .....: Mostrar mensagens padroes                                                *
*-----------------------------------------------------------------------------------------------*
*      EXPLICACOES DA ROTINA                                                                    *
*      - Esta rotina e um include pois dentro dela existe a internal procedure para evitar      *
*        processamento desnecessario                                                            *
*      - cd-mensagen-par indica o codigo da mensagem                                            *
*      - O indicador lg-primeira-mensagem-par serve para indicar se:                            *
*        yes -> deve pegar por primeiro a externa apos a da operadora apos a do sistema         *
*        no  -> deve pegar por primeiro a da operadora apos o do sistema                        *
*      - O indicador lg-mensagem-tela-par serve para indicar se:                                *
*        yes -> joga a mensagem na tela em forma de view-as alert-box e devolve a descricao da  *
*               mensagem                                                                        *
*        no  -> nao joga a mensagem na tela devolvendo somente a descricao da mensagem          *
*      - ds-mensagem-par devolve a descricao da mensagem                                        *
*      - in-tipo-mensagem-par devolve o tipo da mensagem                                        *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      D.00.000  12/06/1999  Nora            Desenvolvimento                                    *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco                               *
*----------------------------------------------------------------------------------------------*/

/* ------------------------------------------------------------------------------------------- */
procedure vermensis:

   /* ----------------------------------------- DEFINICAO DE PARAMETROS DE ENTRADA E SAIDA --- */
   def input  parameter cd-mensagem-par           like mensiste.cd-mensagem              no-undo.
   def input  parameter lg-primeira-mensagem-par    as log                               no-undo.
   def input  parameter lg-mensagem-tela-par        as log                               no-undo.
   def output parameter ds-mensagem-par             as char format "x(75)"               no-undo.
   def output parameter in-tipo-mensagem-par      like mensiste.in-tipo-mensagem         no-undo.

   /* ------------------------------------------------------ DEFINICAO DE VARIAVEIS LOCAIS --- */
   def var ds-mensagem-aux                        like mensiste.ds-mensagem-sistema      no-undo.
   def var in-tipo-mensagem-aux                   like mensiste.in-tipo-mensagem         no-undo.
   def var cd-mensagem-ptu-aux                    like mensiste.cd-mensagem-ptu          no-undo.
   def var lg-utilizada-retorno-aux               like mensiste.lg-utilizada-retorno     no-undo.

   /* ---------------------------------------------------------------------------------------- */
   run localiza-mensiste (input  cd-mensagem-par,
                          input  lg-primeira-mensagem-par,
                          input  lg-mensagem-tela-par,
                          output ds-mensagem-aux,
                          output in-tipo-mensagem-aux,
                          output cd-mensagem-ptu-aux,
                          output lg-utilizada-retorno-aux).

   assign ds-mensagem-par      = ds-mensagem-aux
          in-tipo-mensagem-par = in-tipo-mensagem-aux.

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure vermenret:

   /* ----------------------------------------- DEFINICAO DE PARAMETROS DE ENTRADA E SAIDA --- */
   def input  parameter cd-mensagem-par           like mensiste.cd-mensagem              no-undo.
   def input  parameter lg-primeira-mensagem-par    as log                               no-undo.
   def input  parameter lg-mensagem-tela-par        as log                               no-undo.
   def output parameter ds-mensagem-par             as char format "x(75)"               no-undo.
   def output parameter in-tipo-mensagem-par      like mensiste.in-tipo-mensagem         no-undo.
   def output parameter cd-mensagem-ptu-par       like mensiste.cd-mensagem-ptu          no-undo.
   def output parameter lg-utilizada-retorno-par  like mensiste.lg-utilizada-retorno     no-undo.

   /* ------------------------------------------------------ DEFINICAO DE VARIAVEIS LOCAIS --- */
   def var ds-mensagem-aux                        like mensiste.ds-mensagem-sistema      no-undo.
   def var in-tipo-mensagem-aux                   like mensiste.in-tipo-mensagem         no-undo.
   def var cd-mensagem-ptu-aux                    like mensiste.cd-mensagem-ptu          no-undo.
   def var lg-utilizada-retorno-aux               like mensiste.lg-utilizada-retorno     no-undo.

   /* ---------------------------------------------------------------------------------------- */
   run localiza-mensiste (input  cd-mensagem-par,
                          input  lg-primeira-mensagem-par,
                          input  lg-mensagem-tela-par,
                          output ds-mensagem-aux,
                          output in-tipo-mensagem-aux,
                          output cd-mensagem-ptu-aux,
                          output lg-utilizada-retorno-aux).

   assign ds-mensagem-par          = ds-mensagem-aux
          in-tipo-mensagem-par     = in-tipo-mensagem-aux
          cd-mensagem-ptu-par      = cd-mensagem-ptu-aux
          lg-utilizada-retorno-par = lg-utilizada-retorno-aux.

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure localiza-mensiste:

   /* ----------------------------------------- DEFINICAO DE PARAMETROS DE ENTRADA E SAIDA --- */
   def input  parameter cd-mensagem-par          like mensiste.cd-mensagem               no-undo.
   def input  parameter lg-primeira-mensagem-par   as log                                no-undo.
   def input  parameter lg-mensagem-tela-par       as log                                no-undo.
   def output parameter ds-mensagem-par          like mensiste.ds-mensagem-sistema       no-undo.
   def output parameter in-tipo-mensagem-par     like mensiste.in-tipo-mensagem          no-undo.
   def output parameter cd-mensagem-ptu-par      like mensiste.cd-mensagem-ptu           no-undo.
   def output parameter lg-utilizada-retorno-par like mensiste.lg-utilizada-retorno      no-undo.

   /* ------------------------------------------------------ DEFINICAO DE VARIAVEIS LOCAIS --- */
   def var cd-mensagem-aux                        as char                                no-undo.

   /* ---------------------------------------------- INICIALIZACAO DOS PARAMETROS DE SAIDA --- */
   assign ds-mensagem-par          = ""
          in-tipo-mensagem-par     = ""
          cd-mensagem-ptu-par      = 0
          lg-utilizada-retorno-par = no.

   /* ---------------------------------------------------------------- LOCALIZA A MENSAGEM --- */
   find mensiste
        where mensiste.cd-mensagem = cd-mensagem-par
              no-lock no-error.
   if   avail mensiste
   then do:
          assign cd-mensagem-aux = "(" + string(mensiste.cd-mensagem) + ") ".

          if   lg-primeira-mensagem-par
          then do:
                 if   mensiste.ds-mensagem-externa = ""
                 then do:
                        if   mensiste.ds-mensagem-operadora = ""
                        then assign ds-mensagem-par = mensiste.ds-mensagem-sistema.
                        else assign ds-mensagem-par = mensiste.ds-mensagem-operadora.
                      end.

                 else assign ds-mensagem-par = mensiste.ds-mensagem-externa.
               end.

          else do:
                 if   mensiste.ds-mensagem-operadora = ""
                 then assign ds-mensagem-par = mensiste.ds-mensagem-sistema.
                 else assign ds-mensagem-par = mensiste.ds-mensagem-operadora.
               end.

          assign in-tipo-mensagem-par     = mensiste.in-tipo-mensagem
                 cd-mensagem-ptu-par      = mensiste.cd-mensagem-ptu
                 lg-utilizada-retorno-par = mensiste.lg-utilizada-retorno.

          case (mensiste.in-tipo-mensagem):

          when "I"
          then do:
                 if   lg-mensagem-tela-par
                 then do:
                        message cd-mensagem-aux
                                ds-mensagem-par
                                view-as alert-box information title " Informacao !!! ".
                      end.
                 return.
               end.

          when "E"
          then do:
                 if   lg-mensagem-tela-par
                 then do:
                        message cd-mensagem-aux
                                ds-mensagem-par
                                view-as alert-box error title " Erro Grave !!! ".
                      end.
                 return.
               end.

          when "W"
          then do:
                 if   lg-mensagem-tela-par
                 then do:
                        message cd-mensagem-aux
                                ds-mensagem-par
                                view-as alert-box warning title " Atencao !!! ".
                      end.
                 return.
               end.

          end case.
        end.

   else do:
          assign ds-mensagem-par      = "Mensagem nao cadastrada."
                 in-tipo-mensagem-par = "E".

          if   lg-mensagem-tela-par
          then do:
                 message ds-mensagem-par
                         view-as alert-box warning title " Atencao !!! ".
               end.
        end.

end procedure.

/* ------------------------------------------------------------------------------------------- */
 .



/* ----------------------- CHAMADA DE INCLUDE DAS DEFINICOES GERAIS APIS --- */
/******************************************************************************
*      Programa .....: rtdefapi.i                                             *
*      Data .........: 16 de Novembro de 1999                                 *
*      Sistema ......: API'S Padrao                                           *
*      Empresa ......: DZSET Solucoes e Sistemas                              *
*      Programador ..: Airton Nora/Rosalva Lorandi                            *
*      Objetivo .....: Definicoes gerais das apis                             *
*                      - Consistencias de Variaveis                           *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      D.00.000  16/11/1999  Nora/Rosalva   Desenvolvimento                   *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
******************************************************************************/


/* ------------------------------------------------------------------------- */

def new global shared var v_cod_usuar_corren as character
                          format "x(12)":U label "Usuario Corrente"
                                  column-label "Usuario Corrente"      no-undo.
 

/* ------------ CHAMADA DO HDP PARA DEFINIR O TIPO DO SISTEMA INTEGRACAO --- */

/******************************************************************************
*      Programa .....: hdsistem.i                                             *
*      Data .........: 11 de Agosto de 2000                                   *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: hd - include padrao                                    *
*      Programador ..: Airton Nora                                            *
*      Objetivo .....: Definicao do pre processos                             *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      D.00.000  11/08/2000  Nora           Desenvolvimento                   *
*      E.00.000  16/04/2001  Nora           Conversao Ems504                  *
******************************************************************************/
/* magnus ou ems ou ems505 *//* normal ou oracle *//* sim ou nao *//* ------------------------------------------------------------------------- */


 
/* ------------------------------ CRIACAO DE TEMPORARIAS INTERNAS DA API --- */
define temp-table tmp-contrat-rtapi044 no-undo like tmp-rtapi044.

/* --------------------------------------- DEFINICAO DE VARIAVEIS LOCAIS --- */
define     var lg-erro-api-aux              as logical                 no-undo.
define     var ds-mens-rtapi044-aux         like mensiste.ds-mensagem-sistema
                                                                       no-undo.
define     var in-tp-mens-rtapi044-aux      like mensiste.in-tipo-mensagem
                                                                       no-undo.
define     var cd-empresa-rtapi044-aux      as char    format "x(03)"  no-undo.


define     var cep-cob-rtapi044-aux         as int                     no-undo.
define     var cep-rtapi044-aux             as int                     no-undo.
define     var lg-formato-livre-rtapi044-aux as log                    no-undo.
define     var ix-cont-rtapi044-aux         as int                     no-undo.
define     var nr-cgc-cpf-rtapi044-aux2     like contrat.nr-cgc-cpf    no-undo.
define     var lg-integr-ems-aux            as log initial no          no-undo.

/* ------------------------------------------------- DEFINICAO DE BOTOES --- */
def button b-ok-tmp-mensa-rtapi044 auto-go label "OK" size 09 by 1.5 bgcolor 8.

/* ------------------ DEFINICAO DO BROWSE E DO FRAME DAS INCONSISTENCIAS --- */
def query zoom-tmp-mensa-rtapi044 for tmp-mensa-rtapi044 SCROLLING.
 
def browse browse-tmp-mensa-rtapi044 query zoom-tmp-mensa-rtapi044 no-lock
    display tmp-mensa-rtapi044.cd-mensagem-mens       column-label "Codigo"
            tmp-mensa-rtapi044.in-tipo-mensagem-mens  column-label "Tipo"
            tmp-mensa-rtapi044.ds-mensagem-mens       column-label "Inconsistencia"
            tmp-mensa-rtapi044.ds-chave-mens          column-label "Complemento"
            with size 78 by 09.
 
def frame f-tmp-mensa-rtapi044
    browse-tmp-mensa-rtapi044 skip(0.3)
    space(0.5)
    b-ok-tmp-mensa-rtapi044   skip(0.3)
    with overlay no-labels no-underline three-d row 08 view-as dialog-box
         title " Inconsistencias na Localizacao do Cliente/Fornecedor ".
 
/* ------------------------------------------------ DEFINICAO DE EVENTOS --- */
on window-close of frame f-tmp-mensa-rtapi044
do:
  close query zoom-tmp-mensa-rtapi044.
  apply "end-error":U to self.
end.
 
on end-error of browse-tmp-mensa-rtapi044 in frame f-tmp-mensa-rtapi044
do:
  close query zoom-tmp-mensa-rtapi044.
end.
 
on go   of browse-tmp-mensa-rtapi044 in frame f-tmp-mensa-rtapi044
or help of browse-tmp-mensa-rtapi044 in frame f-tmp-mensa-rtapi044
do:
  return no-apply.
end.
 
on choose of b-ok-tmp-mensa-rtapi044 in frame f-tmp-mensa-rtapi044
do:
  close query zoom-tmp-mensa-rtapi044.
end.

/* ----------------------------- DEFINICAO DE TABELAS TEMPORARIAS LOCAIS --- */

/* ----------------------------------------- DEFINICAO DE BUFFERS LOCAIS --- */

procedure rtapi044:

  do:
          find first param_integr_ems
               where param_integr_ems.ind_param_integr_ems = "Faturamento 2.00" 
                     no-lock no-error.
          
          if avail param_integr_ems
          then assign lg-integr-ems-aux = yes.
          else assign lg-integr-ems-aux = no.
        end.
  .
  
  /* -- INICIALIZACAO DE PARAMETROS (GENERICOS/ESPECIFICOS) COMPARTILHADOS --- */
  assign lg-erro-rtapi044-aux = no.
  
  /* ------------- LIMPEZA TABELA TEMPORARIA tmp-contrat-rtapi044ante COMPARTILHADA --- */
  for each tmp-contrat-rtapi044:
      delete tmp-contrat-rtapi044.
  end.
  
  /* ---------- LIMPEZA TABELA TEMPORARIA MENSAGENS rtapi044 COMPARTILHADA --- */
  for each tmp-mensa-rtapi044:
      delete tmp-mensa-rtapi044.
  end.
  
  /* -------------------------------------------------- INICIO DO PROCESSO --- */
  do on stop undo, return error:
   
     assign lg-erro-api-aux = no.

     /* ------------------------ CONSISTENCIA DE PARAMETROS COMPARTILHADOS --- */
     run consiste-var-api-rtapi044 (input-output lg-erro-api-aux).

     if   lg-erro-api-aux
     then do:
            /* ---------------------------- SETA ERRO OCORRIDO NA rtapi044 --- */
            assign lg-erro-rtapi044-aux = yes.
            return.
          end.
          
     if   in-funcao-rtapi044-aux = "GDT"
     then do:
            for each tmp-rtapi044:
                delete tmp-rtapi044.
            end.
          end.

     /* ------------------------------------ LEITURA PARAMETROS DO SISTEMA --- */
     find first paramecp no-lock no-error.

     if   not available paramecp
     then do:
            /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
            /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
            run chama-mens-rtapi044 (input 006,
                                     input lg-prim-mens-rtapi044-aux,
                                     input no,
                                     input "",
                                     input "").

            /* ---------------------------- SETA ERRO OCORRIDO NA rtapi044 --- */
            assign lg-erro-rtapi044-aux = yes.
            return.
          end.

     /* --------------------------------- DESVIOS DE FUNCIONALIDADE DA API --- */
     /* ---------------------------------------------- FUNCOES DA rtapi044 --- */
     case in-funcao-rtapi044-aux:
        /* -------------------------------------------- GERA DADOS NA TEMP --- */
        when "GDT"
        then do:
               /* ------------------ GERACAO DE DADOS NA TABELA TEMPORARIA --- */
               /* --------------------------------- rtapi044 COMPARTILHADA --- */
               run gera-dados-rtapi044 (input-output lg-erro-api-aux).
        
               if   lg-erro-api-aux
               then do:
                      /* ------------------ SETA ERRO OCORRIDO NA rtapi044 --- */
                      assign lg-erro-rtapi044-aux = yes.
                      return.
                    end.
             end.

        /* ---------------------------------------- CONSISTE DADOS NA TEMP --- */
        when "CST"
        then do:
               /* ------------- CONSISTENCIA DE DADOS NA TABELA TEMPORARIA --- */
               /* --------------------------------- rtapi044 COMPARTILHADA --- */
               run consiste-dados-rtapi044 (input-output lg-erro-api-aux).
      
               if   lg-erro-api-aux
               then do:
                      /* ------------------ SETA ERRO OCORRIDO NA rtapi044 --- */
                      assign lg-erro-rtapi044-aux = yes.
                      return.
                    end.
             end.
     end case.
  end.
end procedure.
/* ----------------------------------------------------- FIM DO PROCESSO --- */

/*****************************************************************************/
/*                            PROCEDURES INTERNAS                            */
/*****************************************************************************/

/* --------------- PROCEDURE P/CONSISTENCIA DE PARAMETROS COMPARTILHADOS --- */
procedure consiste-var-api-rtapi044.
   /* -------------------------------------------------------- PARAMETRO --- */
   define input-output parameter lg-erro-api-par  as logical           no-undo.

   /* --------------------------------------------------- SETA PARAMETRO --- */
   assign lg-erro-api-par = no.

   /* ---- CONSISTE PARAMETRO GENERICO COMPARTILHADO - PRIMEIRA MENSAGEM --- */
   if   lg-prim-mens-rtapi044-aux = ?
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 232,
                                   input no,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   /* -- CONSISTE PARAMETRO GENERICO COMPARTILHADO - INDICADOR DE FUNCAO --- */
   if   in-funcao-rtapi044-aux <> "GDT"
   and  in-funcao-rtapi044-aux <> "CST"
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 007,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input in-funcao-rtapi044-aux).

          /* -------------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
          assign lg-erro-api-par = yes.
        end.

   /* ----- CONSISTE PARAMETRO GENERICO COMPARTILHADO - SIMULAR: SIM/NAO --- */

   /* - CONSISTE PARAMETRO GENERICO COMPARTILHADO - GERAR DADOS: SIM/NAO --- */

   /* ---------------------- CONSISTE PARAMETRO ESPECIFICO COMPARTILHADO --- */
    
   /* ------------------------ CONSISTE PARAMETRO GENERICO COMPARTILHADO --- */
   /* ------------------------------------ INDICADOR DE TIPO DE EMITENTE --- */
   if   cd-contratante-rtapi044-aux = 0
   or   cd-contratante-rtapi044-aux = ?
   then do:
          if    nome-abrev-rtapi044-aux = ""
          and   nr-cgc-cpf-rtapi044-aux = ""
          then  do:
                 /* --------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
                 /* ----------- CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
                 run chama-mens-rtapi044 (input 978,
                                          input lg-prim-mens-rtapi044-aux,
                                          input no,
                                          input "",
                                          input in-funcao-rtapi044-aux).

                 /* ------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
                 assign lg-erro-api-par = yes.
               end.
          
          if    nome-abrev-rtapi044-aux <> ""
          and   nr-cgc-cpf-rtapi044-aux <> ""
          then  do:
                  /* --------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
                  /* ----------- CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
                  run chama-mens-rtapi044 (input 995,
                                           input lg-prim-mens-rtapi044-aux,
                                           input no,
                                           input "",
                                           input in-funcao-rtapi044-aux).

                  /* ------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
                  assign lg-erro-api-par = yes.
                end.
        end.
        
   /* ------------------------------------ INDICADOR DE TIPO DE EMITENTE --- */
   if   (cd-contratante-rtapi044-aux = 0
         or   cd-contratante-rtapi044-aux = ?)
   and  nome-abrev-rtapi044-aux = ""
   and  nr-cgc-cpf-rtapi044-aux = ""
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 996,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input in-funcao-rtapi044-aux).

          /* -------------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
          assign lg-erro-api-par = yes.
        end.
   
   /* ------------------------------------ INDICADOR DE TIPO DE EMITENTE --- */
   if   in-tipo-emitente-rtapi044-aux <> "PRESTA"
   and  in-tipo-emitente-rtapi044-aux <> "CONTRA"
   and  in-tipo-emitente-rtapi044-aux <> "QUALQU"
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 976,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input in-funcao-rtapi044-aux).

          /* -------------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
          assign lg-erro-api-par = yes.
        end.
   
   /* -------------------------------------- INDICADOR DE TIPO DE PESSOA --- */
   if   cd-contratante-rtapi044-aux = 0
   then do:
          if   in-tipo-pessoa-rtapi044-aux <> "F"
          and  in-tipo-pessoa-rtapi044-aux <> "J"
          and  in-tipo-pessoa-rtapi044-aux <> "E"
          then do:
                 /* --------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
                 /* ----------- CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
                 run chama-mens-rtapi044 (input 977,
                                          input lg-prim-mens-rtapi044-aux,
                                          input no,
                                          input "",
                                          input in-funcao-rtapi044-aux).

                 /* ------------- SETA ERRO OCORRIDO NA CONSISTE-VAR-API --- */
                 assign lg-erro-api-par = yes.
               end.
        end.        

end procedure.
/* --------- FINAL PROCEDURE P/CONSISTENCIA DE PARAMETROS COMPARTILHADOS --- */

/*****************************************************************************/

/* ---------------------------- PROCEDURE P/CHAMADA DAS MENSAGEMS PADRAO --- */
procedure chama-mens-rtapi044.
   define input  parameter cd-mensagem-par
                                          like mensiste.cd-mensagem    no-undo.
   define input  parameter lg-primeira-mens-par
                                            as logical                 no-undo.
   define input  parameter lg-mens-tela-par as logical                 no-undo.
   define input  parameter ds-complemento-par
                                          like mensiste.ds-mensagem-sistema
                                                                       no-undo.
   define input  parameter ds-chave-par   like mensiste.ds-mensagem-sistema
                                                                       no-undo.

   /* ----------------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
   run vermensis (input  cd-mensagem-par,
                  input  lg-primeira-mens-par,
                  input  lg-mens-tela-par,
                  output ds-mens-rtapi044-aux,
                  output in-tp-mens-rtapi044-aux).

   /* ------------------------- CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
   run mens-rtapi044 (input cd-mensagem-par,
                      input ds-mens-rtapi044-aux,
                      input ds-complemento-par,
                      input in-tp-mens-rtapi044-aux,
                      input ds-chave-par).
end procedure.
/* ---------------------- FINAL PROCEDURE P/CHAMADA DAS MENSAGENS PADRAO --- */

/*****************************************************************************/

/* -------- PROCEDURE P/GRAVACAO DA TABELA TEMPORARIA MENSAGENS rtapi044 --- */
procedure mens-rtapi044.
   define input  parameter cd-mensagem-par
                                          like mensiste.cd-mensagem    no-undo.
   define input  parameter ds-mensagem-par
                                          like mensiste.ds-mensagem-sistema
                                                                       no-undo.
   define input  parameter ds-complemento-par
                                          like mensiste.ds-mensagem-sistema
                                                                       no-undo.
   define input  parameter in-tipo-mensagem-par
                                          like mensiste.in-tipo-mensagem
                                                                       no-undo.
   define input  parameter ds-chave-par   like mensiste.ds-mensagem-sistema
                                                                       no-undo.

   create tmp-mensa-rtapi044.
   assign tmp-mensa-rtapi044.cd-mensagem-mens      = cd-mensagem-par
          tmp-mensa-rtapi044.ds-mensagem-mens      = ds-mensagem-par
          tmp-mensa-rtapi044.ds-complemento-mens   = ds-complemento-par
          tmp-mensa-rtapi044.in-tipo-mensagem-mens = in-tipo-mensagem-par
          tmp-mensa-rtapi044.ds-chave-mens         = ds-chave-par.
end procedure.
/* -- FINAL PROCEDURE P/GRAVACAO DA TABELA TEMPORARIA MENSAGENS rtapi044 --- */

/*****************************************************************************/

/* ------------------------------------- PROCEDURE P/GERACAO DE DADOS NA --- */
/* ---------------------------- TABELA TEMPORARIA rtapi044 COMPARTILHADA --- */
procedure gera-dados-rtapi044.
   /* -------------------------------------------------------- PARAMETRO --- */
   define input-output parameter lg-erro-api-par  as logical           no-undo.

   assign lg-erro-api-par = no.
   /* --------------------------------------------------- SETA PARAMETRO --- */
   /* ---------- CONSISTE TABELA TEMPORARIA rtapi044 COMPARTILHADA VAZIA --- */
   find first tmp-rtapi044 no-error.

   if   available tmp-rtapi044
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 261,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   run grava-dados-rtapi044 (input-output lg-erro-api-par).   

   if   lg-erro-api-par 
   then do:
          for each tmp-rtapi044:
              delete tmp-rtapi044.
          end.
        end.

end procedure.

/* ------------------------------- FINAL PROCEDURE P/GERACAO DE DADOS NA --- */
procedure consiste-dados-rtapi044.
   /* -------------------------------------------------------- PARAMETRO --- */
   define input-output parameter lg-erro-api-par  as logical           no-undo.

   define var nr-cgc-cpf-rec-aux   like contrat.nr-cgc-cpf             no-undo.
   define var nr-cgc-cpf-enc-aux   like contrat.nr-cgc-cpf             no-undo.

   assign lg-erro-api-par = no.
   /* --------------------------- REPASSA TMP-RTAPI PARA tmp-contrat-rtapi044ANTE --- */
   /* ---------- CONSISTE TABELA TEMPORARIA rtapi044 COMPARTILHADA VAZIA --- */
   find first tmp-rtapi044 no-error.

   if   not available tmp-rtapi044
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 240,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   create tmp-contrat-rtapi044.

   buffer-copy tmp-rtapi044 to tmp-contrat-rtapi044.

   /* --------------------------------------------------- SETA PARAMETRO --- */
   /* ---------- CONSISTE TABELA TEMPORARIA rtapi044 COMPARTILHADA VAZIA --- */
   find first tmp-contrat-rtapi044 no-error.

   if   not available tmp-contrat-rtapi044
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 240,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   for each tmp-rtapi044:
       delete tmp-rtapi044.
   end.

   run grava-dados-rtapi044 (input-output lg-erro-api-par).   

   if   lg-erro-api-par
   then do:
          for each tmp-rtapi044:
              delete tmp-rtapi044. 
          end.
          return.
        end.

   find first tmp-rtapi044 no-error.

   if   not available tmp-rtapi044
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 240,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   /* ---------------------------------------- COMPARA CAMPOS NOME-ABREV --- */
   if   tmp-contrat-rtapi044.nome-abrev 
   <>   tmp-rtapi044.nome-abrev
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 991,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.
        
   /* ------------------------------------ COMPARA CAMPOS TIPO DE PESSOA --- */
   if   tmp-contrat-rtapi044.in-tipo-pessoa 
   <>   tmp-rtapi044.in-tipo-pessoa
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 992,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   /* ---------------------------------------------- COMPARA CAMPOS NOME --- */
   if   tmp-contrat-rtapi044.nm-contratante 
   <>   tmp-rtapi044.nm-contratante
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 993,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

   /* ------------------------------------------- COMPARA CAMPOS CGC-CPF --- */
   if   tmp-contrat-rtapi044.nr-cgc-cpf 
   <>   tmp-rtapi044.nr-cgc-cpf
   then do:
          /* ---------------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
          /* ------------------ CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
          run chama-mens-rtapi044 (input 994,
                                   input lg-prim-mens-rtapi044-aux,
                                   input no,
                                   input "",
                                   input "").

          /* -------------------------- SETA ERRO OCORRIDO NA GERA-DADOS --- */
          assign lg-erro-api-par = yes.
          return.
        end.

end procedure.
/* ------------------------------- FINAL PROCEDURE P/GERACAO DE DADOS NA --- */

/* ------- PROCEDURE P/PROCESSAR DADOS AFIM DE GERAR A TABELA TEMPORARIA --- */
/* ---------------------------------------------- rtapi044 COMPARTILHADA --- */
procedure grava-dados-rtapi044.
   define input-output parameter lg-erro-api-par  as logical           no-undo.

   define var nr-mensagem-aux like mensiste.cd-mensagem                no-undo.
   define var lg-processa-rtapi044-aux as logical                      no-undo.

   assign lg-processa-rtapi044-aux = yes.
   /* ------------------------------------------ PESQUISA ADMINISTRATIVO --- */
   case lg-processa-rtapi044-aux:
       when (if cd-contratante-rtapi044-aux <> 0 then true else false)
       then do:
              /* ------------------------------------- PESQUISA PELO CODIGO --- */
              /* -------------- PESQUISA COM INTEGRACAO PRODUTO MAGNUS I.00 --- */
              
              
              /* ---------------- PESQUISA COM INTEGRACAO PRODUTO EMS 2.02 --- */
              
              
              /* ---------------- PESQUISA COM INTEGRACAO PRODUTO EMS 5.04 ou EMS 5.05 --- */
              do:
                      cd-empresa-rtapi044-aux = trim(string(paramecp.ep-codigo)).
    
                      case in-tipo-emitente-rtapi044-aux: 
                           when "CONTRA"
                           then do:
                                  find first cliente where 
                                             cliente.cod_empresa = trim(cd-empresa-rtapi044-aux)
                                         and cliente.cdn_cliente = cd-contratante-rtapi044-aux
                                             no-lock no-error.

                                  if   not available cliente
                                  then do:
                                         assign nr-mensagem-aux = 973.
                          
                                         run chama-mens-rtapi044
                                                        (input nr-mensagem-aux,
                                                         input lg-prim-mens-rtapi044-aux,
                                                         input no,
                                                         input "",
                                                         input in-funcao-rtapi044-aux).
                                    
                                         assign lg-erro-api-par = yes.
                                         return.
                                       end.
                                end.

                           when "PRESTA"
                           then do:
                                  find first fornecedor where fornecedor.cod_empresa
                                                                   = trim(cd-empresa-rtapi044-aux) 
                                                                 and fornecedor.cdn_fornecedor     
                                                                   = cd-contratante-rtapi044-aux   
                                       no-lock no-error.                                   
                                  
                                  if   not available fornecedor
                                  then do:
                                         assign nr-mensagem-aux = 974.
                                     
                                         run chama-mens-rtapi044
                                                        (input nr-mensagem-aux,
                                                         input lg-prim-mens-rtapi044-aux,
                                                         input no,
                                                         input "",
                                                         input in-funcao-rtapi044-aux).
                                         assign lg-erro-api-par = yes.
                                         return.
                                       end.
                                end.

                          when "QUALQU"
                          then do: 
                                 find first cliente where cliente.cod_empresa          
                                                        = trim(cd-empresa-rtapi044-aux)
                                                      and cliente.cdn_cliente          
                                                        = cd-contratante-rtapi044-aux  
                                      no-lock no-error.                                
                                 
                                 if   not available cliente
                                 then do:
                                        find first fornecedor where fornecedor.cod_empresa 
                                                                         = trim(cd-empresa-rtapi044-aux)
                                                                       and fornecedor.cdn_fornecedor    
                                                                         = cd-contratante-rtapi044-aux  
                                             no-lock no-error.                             
                                       
                                        if   not available fornecedor
                                        then do:
                                               assign nr-mensagem-aux = 990.
                   
                                               run chama-mens-rtapi044
                                                              (input nr-mensagem-aux,
                                                               input lg-prim-mens-rtapi044-aux,
                                                               input no,
                                                               input "",
                                                               input in-funcao-rtapi044-aux).
                                               assign lg-erro-api-par = yes.
                                               return.
                                             end.
                                      end.
                               end.
                      end case.
                    end.
              
            end.

       when (if nr-cgc-cpf-rtapi044-aux <> "" then true else false)
       then do:
              /* ----------------------------- PESQUISA PELO NOME ABREVIADO --- */
              /* -------------- PESQUISA COM INTEGRACAO PRODUTO MAGNUS I.00 --- */
              
              
              /* ---------------- PESQUISA COM INTEGRACAO PRODUTO EMS 2.02 --- */
              
              
              /* ---------------- PESQUISA COM INTEGRACAO PRODUTO EMS 5.04 ou EMS 5.05 --- */
              do:
                      cd-empresa-rtapi044-aux = trim(string(paramecp.ep-codigo)).
    
                      case in-tipo-emitente-rtapi044-aux: 
                           when "CONTRA"
                           then do: 
                                  find first cliente where cliente.cod_empresa          
                                                         = trim(cd-empresa-rtapi044-aux)
                                                       and cliente.cod_id_feder         
                                                         = trim(nr-cgc-cpf-rtapi044-aux)
                                       no-lock no-error.                                
                               
                                  if   not available cliente
                                  then do:
                                         assign nr-mensagem-aux = 973.
                          
                                         run chama-mens-rtapi044
                                                        (input nr-mensagem-aux,
                                                         input lg-prim-mens-rtapi044-aux,
                                                         input no,
                                                         input "",
                                                         input in-funcao-rtapi044-aux).
                                    
                                         assign lg-erro-api-par = yes.
                                         return.
                                       end.
                                end.
                           when "PRESTA"
                           then do:
                                  find first fornecedor where fornecedor.cod_empresa      
                                                                   = trim(cd-empresa-rtapi044-aux)
                                                                 and fornecedor.cod_id_feder      
                                                                   = trim(nr-cgc-cpf-rtapi044-aux)
                                       no-lock no-error.                                  
                                  
                                  if   not available fornecedor
                                  then do:
                                         assign nr-mensagem-aux = 974.
                                     
                                         run chama-mens-rtapi044
                                                        (input nr-mensagem-aux,
                                                         input lg-prim-mens-rtapi044-aux,
                                                         input no,
                                                         input "",
                                                         input in-funcao-rtapi044-aux).
                                         assign lg-erro-api-par = yes.
                                         return.
                                       end.
                                end.
                          when "QUALQU"
                          then do: 
                                 find first cliente where cliente.cod_empresa          
                                                        = trim(cd-empresa-rtapi044-aux)
                                                      and cliente.cod_id_feder         
                                                        = trim(nr-cgc-cpf-rtapi044-aux)
                                      no-lock no-error.                                
    
                                 if   not available cliente
                                 then do:
                                        find first fornecedor where fornecedor.cod_empresa 
                                                                         = trim(cd-empresa-rtapi044-aux)
                                                                       and fornecedor.cod_id_feder      
                                                                         = trim(nr-cgc-cpf-rtapi044-aux)
                                             no-lock no-error.                             
                                        
                                        if   not available fornecedor
                                        then do:
                                               assign nr-mensagem-aux = 990.
                   
                                               run chama-mens-rtapi044
                                                              (input nr-mensagem-aux,
                                                               input lg-prim-mens-rtapi044-aux,
                                                               input no,
                                                               input "",
                                                               input in-funcao-rtapi044-aux).
                                               assign lg-erro-api-par = yes.
                                               return.
                                             end.
                                      end.
                               end.
                      end case.
                    end.
              
            end.
       when (if nome-abrev-rtapi044-aux <> "" then true else false)
       then do:
              /* ----------------------------- PESQUISA PELO NOME ABREVIADO --- */
              /* -------------- PESQUISA COM INTEGRACAO PRODUTO MAGNUS I.00 --- */
              
              
              /* ---------------- PESQUISA COM INTEGRACAO PRODUTO EMS 2.02 --- */
              
              
              /* ---------------- PESQUISA COM INTEGRACAO PRODUTO EMS 5.04 ou EMS 5.05 --- */
              do:
                      cd-empresa-rtapi044-aux = trim(string(paramecp.ep-codigo)).
    
                      case in-tipo-emitente-rtapi044-aux: 
                           when "CONTRA"
                           then do:
                                  find first cliente where cliente.cod_empresa                 
                                                                = trim(cd-empresa-rtapi044-aux)
                                                              and cliente.nom_abrev            
                                                                = trim(nome-abrev-rtapi044-aux)
                                       no-lock no-error.                                

                                  if   not available cliente
                                  then do:
                                         assign nr-mensagem-aux = 973.
                          
                                         run chama-mens-rtapi044
                                                        (input nr-mensagem-aux,
                                                         input lg-prim-mens-rtapi044-aux,
                                                         input no,
                                                         input "",
                                                         input in-funcao-rtapi044-aux).
                                    
                                         assign lg-erro-api-par = yes.
                                         return.
                                       end.
                                end.
                           when "PRESTA"
                           then do:
                                  find first fornecedor where fornecedor.cod_empresa      
                                                                   = trim(cd-empresa-rtapi044-aux)
                                                                 and fornecedor.nom_abrev         
                                                                   = trim(nome-abrev-rtapi044-aux)
                                       no-lock no-error.                                  
                                  
                                  if   not available fornecedor
                                  then do:
                                         assign nr-mensagem-aux = 974.
                                     
                                         run chama-mens-rtapi044
                                                        (input nr-mensagem-aux,
                                                         input lg-prim-mens-rtapi044-aux,
                                                         input no,
                                                         input "",
                                                         input in-funcao-rtapi044-aux).
                                         assign lg-erro-api-par = yes.
                                         return.
                                       end.
                                end.
                          when "QUALQU"
                          then do: 
                                 find first cliente where cliente.cod_empresa          
                                                               = trim(cd-empresa-rtapi044-aux)
                                                             and cliente.nom_abrev            
                                                               = trim(nome-abrev-rtapi044-aux)
                                      no-lock no-error.                                

                                 if   not available cliente
                                 then do:
                                        find first fornecedor where fornecedor.cod_empresa 
                                                                         = trim(cd-empresa-rtapi044-aux)
                                                                       and fornecedor.nom_abrev         
                                                                         = trim(nome-abrev-rtapi044-aux)
                                             no-lock no-error.                             
                                        
                                        if   not available fornecedor
                                        then do:
                                               assign nr-mensagem-aux = 990.
                   
                                               run chama-mens-rtapi044
                                                              (input nr-mensagem-aux,
                                                               input lg-prim-mens-rtapi044-aux,
                                                               input no,
                                                               input "",
                                                               input in-funcao-rtapi044-aux).
                                               assign lg-erro-api-par = yes.
                                               return.
                                             end.
                                      end.
                               end.
                      end case.
                    end.
              
            end.
   end case.
   
   
   
   
                        
   do:
           cd-empresa-rtapi044-aux = trim(string(paramecp.ep-codigo)).
           
           if   available cliente
           AND ( in-tipo-emitente-rtapi044-aux = "CONTRA" OR in-tipo-emitente-rtapi044-aux = "QUALQU")
           then do:
                  /* ------------------------- CAMPOS PARA TABELA CLIENTE ---*/
                  create tmp-rtapi044.
                  assign tmp-rtapi044.cd-contratante   = cliente.cdn_cliente
                         tmp-rtapi044.nome-abrev       = cliente.nom_abrev
                         tmp-rtapi044.nr-cgc-cpf       = cliente.cod_id_feder
                         tmp-rtapi044.cd-pais          = cliente.cod_pais
                         tmp-rtapi044.nm-contratante   = cliente.nom_pessoa
                         tmp-rtapi044.identific        = "C"
                         tmp-rtapi044.cod-gr-forn      = 0
                         tmp-rtapi044.nat-operacao     = ""
                         tmp-rtapi044.nr-pessoa        = cliente.num_pessoa
                         tmp-rtapi044.dt-implantacao   = cliente.dat_impl_clien.

                  assign tmp-rtapi044.cod-gr-cli       
                       = int(substr(cliente.cod_grp_clien,1,2)) no-error.
    
                  if   error-status:error
                  then do:
                         run chama-mens-rtapi044
                                        (input 980,
                                         input lg-prim-mens-rtapi044-aux,
                                         input no,
                                         input "",
                                         input in-funcao-rtapi044-aux).
                         assign lg-erro-api-par = yes.
                         return.
                       end.
               

                  /* ------------------------------------- PESQUISA PAIS --- */
                  find pais where pais.cod_pais                  
                                       = cliente.cod_pais no-lock no-error.
                            
                  if   available pais
                  then assign tmp-rtapi044.nm-pais = trim(substr(pais.nom_pais,1,20)). 
                  else assign tmp-rtapi044.nm-pais = "".
          
                  /* ----------------------- PESQUISA CLIENTE FINANCEIRO --- */
                  find clien_financ where clien_financ.cod_empresa
                                        = trim(cd-empresa-rtapi044-aux)
                                      and clien_financ.cdn_cliente
                                        = cliente.cdn_cliente no-lock no-error.
                
                  if   not available clien_financ
                  then do:
                         run chama-mens-rtapi044
                                        (input 979,
                                         input lg-prim-mens-rtapi044-aux,
                                         input no,
                                         input "",
                                         input in-funcao-rtapi044-aux).
                         assign lg-erro-api-par = yes.
                         return.
                       end.
                  /* ----------------------- PESQUISA MOEDA CORRENTE --- */
                  find LAST histor_finalid_econ where 
                       histor_finalid_econ.cod_finalid_econ = pais.cod_finalid_econ_pais
                   AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
                   no-lock no-error.
                
                  if   not available histor_finalid_econ
                  then do:
                         run chama-mens-rtapi044
                                        (input 1647,
                                         input lg-prim-mens-rtapi044-aux,
                                         input no,
                                         input "",
                                         input in-funcao-rtapi044-aux).
                         assign lg-erro-api-par = yes.
                         return.
                       end.

                  assign tmp-rtapi044.agencia          
                         = trim(substr(clien_financ.cod_agenc_bcia,1,8))
                         tmp-rtapi044.agencia-digito
                         = trim(clien_financ.cod_digito_agenc_bcia)
                         tmp-rtapi044.conta-corren     
                         = trim(clien_financ.cod_cta_corren_bco)
                         tmp-rtapi044.cd-representante 
                         = clien_financ.cdn_repres
                         tmp-rtapi044.cod-digito-cta-corren 
                         = trim(clien_financ.cod_digito_cta_corren)
                         tmp-rtapi044.cd-moeda-corrente 
                         = trim(histor_finalid_econ.cod_indic_econ).
                      
                  assign tmp-rtapi044.portador       
                       = int(clien_financ.cod_portador) no-error.
              
                  if   error-status:error
                  then do:
                         run chama-mens-rtapi044
                                        (input 981,
                                         input lg-prim-mens-rtapi044-aux,
                                         input no,
                                         input "",
                                         input in-funcao-rtapi044-aux).
                         assign lg-erro-api-par = yes.
                         return.
                       end. 
    
                  assign tmp-rtapi044.cod-banco       
                       = int(substr(clien_financ.cod_banco,1,3)) no-error.
       
                  if   error-status:error
                  then do:
                         run chama-mens-rtapi044
                                        (input 982,
                                         input lg-prim-mens-rtapi044-aux,
                                         input no,
                                         input "",
                                         input in-funcao-rtapi044-aux).
                         assign lg-erro-api-par = yes.
                         return.
                       end. 

                  /* marcio Assefaz */
                  if   paramecp.cd-unimed = 2500
                  then assign tmp-rtapi044.modalidade  = 0.
                  else do:
                  assign tmp-rtapi044.modalidade       
                       = int(clien_financ.cod_cart_bcia) no-error.
       
                  if   error-status:error
                  then do:
                         run chama-mens-rtapi044
                                        (input 984,
                                         input lg-prim-mens-rtapi044-aux,
                                         input no,
                                         input "",
                                         input in-funcao-rtapi044-aux).
                         assign lg-erro-api-par = yes.
                         return.
                       end. 
                       end.

                  /*------------- AVISO DEBITO/EMISSAO BOLETO E RETEM IMPOSTO  --------------*/
                  assign tmp-rtapi044.lg-gera-avideb     = clien_financ.log_habilit_gera_avdeb
                         tmp-rtapi044.lg-emite-boleto    = clien_financ.log_habilit_emis_boleto
                         tmp-rtapi044.lg-retem-imposto   = clien_financ.log_retenc_impto.

                  /* ------------------------------ LOCALIZA ANALISE DE CREDITO DO CLIENTE --- */
                  find clien_analis_cr
                       where clien_analis_cr.cod_empresa = cliente.cod_empresa
                         and clien_analis_cr.cdn_cliente = cliente.cdn_cliente
                             no-lock no-error.
                  if   avail clien_analis_cr
                  then assign tmp-rtapi044.lg-neces-acomp-spc = clien_analis_cr.log_neces_acompto_spc.
                  else assign tmp-rtapi044.lg-neces-acomp-spc = no.
                                  

                  if   (cliente.num_pessoa / 2) 
                     = (int(cliente.num_pessoa / 2)) 
                  then assign tmp-rtapi044.in-tipo-pessoa = "F".
                  else assign tmp-rtapi044.in-tipo-pessoa = "J".
                  
                  if   cd-contratante-rtapi044-aux = 0
                  then do:
                         if   in-tipo-pessoa-rtapi044-aux 
                         <>   tmp-rtapi044.in-tipo-pessoa    
                         then do:
                                /* -------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
                                /* ---------- CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
                                run chama-mens-rtapi044
                                               (input 992,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input "").
                                
                                /* ------------------ SETA ERRO OCORRIDO NA GERA-DADOS --- */
                                assign lg-erro-api-par = yes.
                                return.
                              end.
                       end.
                  
                  if   tmp-rtapi044.in-tipo-pessoa = "F"
                  then do:
                         /* -------------------------- PESQUISA PESSOA FISICA --- */
                         find first pessoa_fisic where pessoa_fisic.num_pessoa_fisic
                                                     = cliente.num_pessoa
                                                       no-lock no-error.
                
                         if   not available pessoa_fisic
                         then do:
                                run chama-mens-rtapi044
                                               (input 983,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input in-funcao-rtapi044-aux).
                                assign lg-erro-api-par = yes.
                                return.
                              end.

                         /*---------- TRATA ENDERECO COBRANCA --------------------------------------------*/
                         if cd-contratante-rtapi044-aux > 0
                         then find first contrat where contrat.cd-contratante = cd-contratante-rtapi044-aux
                                                         no-lock no-error.
                         if not avail contrat
                         then find contrat where contrat.nr-cgc-cpf = trim(nr-cgc-cpf-rtapi044-aux)
                                                 no-lock no-error.
                         if avail contrat
                         and contrat.en-rua-cob      <> ""
                         and contrat.en-bairro-cob   <> ""
                         and contrat.en-cep-cob      <> ""
                         and contrat.cd-cidade       <> 0
                         and contrat.en-uf-cob       <> ""   
                         then assign tmp-rtapi044.en-rua-cob          = trim(contrat.en-rua-cob)
                                     tmp-rtapi044.en-bairro-cob       = trim(contrat.en-bairro-cob)
                                     tmp-rtapi044.en-cep-cob          = trim(contrat.en-cep-cob)
                                     tmp-rtapi044.en-uf-cob           = trim(contrat.en-uf-cob)
                                     tmp-rtapi044.nr-caixa-postal-cob = trim(contrat.nr-caixa-postal-cob)
                                     tmp-rtapi044.cd-cidade-cob       = contrat.cd-cidade-cob
                                     tmp-rtapi044.cd-cidade           = contrat.cd-cidade.
                         else do:
                                 assign tmp-rtapi044.en-bairro-cob       = trim(substr(pessoa_fisic.nom_bairro,1,30))
                                        tmp-rtapi044.en-cep-cob          = trim(substr(pessoa_fisic.cod_cep,1,8))
                                        tmp-rtapi044.en-uf-cob           = trim(substr(pessoa_fisic.cod_unid_federac,1,2))
                                        tmp-rtapi044.en-rua-cob          = trim(pessoa_fisic.nom_endereco)
                                        tmp-rtapi044.nr-caixa-postal-cob = trim(substr(pessoa_fisic.cod_cx_post,1,20)).

                                 /* ----------------------------- LOCALIZA A CIDADE DO CONTRATANTE --- */
                                 find first dzcidade
                                      where dzcidade.nm-cidade = pessoa_fisic.nom_cidade
                                        and dzcidade.estado    = pessoa_fisic.cod_unid_federac
                                            no-lock no-error.
                                 if   avail dzcidade
                                 then assign tmp-rtapi044.cd-cidade-cob = dzcidade.cd-cidade
                                             tmp-rtapi044.cd-cidade     = dzcidade.cd-cidade.
                                 else assign tmp-rtapi044.cd-cidade-cob = 0
                                             tmp-rtapi044.cd-cidade     = 0.
                              end.
                         
                         /*--------------------------------------------------------*/                       
                         assign tmp-rtapi044.en-bairro        
                              = trim(substr(pessoa_fisic.nom_bairro,1,30))
                                tmp-rtapi044.en-cep           
                              = trim(substr(pessoa_fisic.cod_cep,1,8))
                                tmp-rtapi044.en-uf            
                              = trim(substr(pessoa_fisic.cod_unid_federac,1,2))
                                tmp-rtapi044.en-rua           
                              = pessoa_fisic.nom_endereco
                                tmp-rtapi044.nr-telefone[1]   
                              = trim(substr(pessoa_fisic.cod_telefone,1,20))
                               /* tmp-rtapi044.nr-telefone[2]   
                              = ""*/
                                tmp-rtapi044.nr-caixa-postal  
                              = trim(substr(pessoa_fisic.cod_cx_post,1,20))
                                tmp-rtapi044.nr-insc-estadual 
                              = trim(substr(pessoa_fisic.cod_id_estad_fisic,1,19))
                                tmp-rtapi044.nr-fax    
                              = trim(substr(pessoa_fisic.cod_fax,1,20))        
                                tmp-rtapi044.nr-ramal-fax 
                              = trim(substr(pessoa_fisic.cod_ramal_fax,1,7))  
                                tmp-rtapi044.nr-telex 
                              = trim(substr(pessoa_fisic.cod_telex,1,7))
                                tmp-rtapi044.nm-email     
                              = trim(substr(pessoa_fisic.cod_e_mail,1,40)).




                       end.
                  else do:
                         /* ------------------------ PESQUISA PESSOA JURIDICA --- */
                         find first pessoa_jurid where pessoa_jurid.num_pessoa_jurid
                                                     = cliente.num_pessoa
                                                       no-lock no-error.
                
                         if   not available pessoa_jurid
                         then do:
                                run chama-mens-rtapi044
                                               (input 985,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input in-funcao-rtapi044-aux).
                                assign lg-erro-api-par = yes.
                                return.
                              end.
                           
                         assign tmp-rtapi044.en-bairro        
                              = trim(substr(pessoa_jurid.nom_bairro,1,30))
                                tmp-rtapi044.en-bairro-cob    
                              = trim(substr(pessoa_jurid.nom_bairro_cobr,1,30))
                                tmp-rtapi044.en-cep           
                              = trim(substr(pessoa_jurid.cod_cep,1,8))
                                tmp-rtapi044.en-cep-cob       
                              = trim(substr(pessoa_jurid.cod_cep_cobr,1,8))
                                tmp-rtapi044.en-uf            
                              = trim(substr(pessoa_jurid.cod_unid_federac,1,2))
                                tmp-rtapi044.en-uf-cob        
                              = trim(substr(pessoa_jurid.cod_unid_federac_cobr,1,2))
                                tmp-rtapi044.en-rua           
                              = trim(pessoa_jurid.nom_endereco)
                                tmp-rtapi044.en-rua-cob       
                              = trim(pessoa_jurid.nom_ender_cobr)
                                tmp-rtapi044.nr-telefone   
                              = trim(substr(pessoa_jurid.cod_telefone,1,20))
                                tmp-rtapi044.nr-caixa-postal  
                              = trim(substr(pessoa_jurid.cod_cx_post,1,20))
                                tmp-rtapi044.nr-caixa-postal-cob 
                              = trim(substr(pessoa_jurid.cod_cx_post_cobr,1,20))
                                tmp-rtapi044.nr-insc-estadual 
                              = trim(substr(pessoa_jurid.cod_id_estad_jurid,1,19))
                                tmp-rtapi044.nr-fax    
                              = trim(substr(pessoa_jurid.cod_fax,1,20))        
                                tmp-rtapi044.nr-ramal-fax 
                              = trim(substr(pessoa_jurid.cod_ramal_fax,1,7))  
                                tmp-rtapi044.nr-telex 
                              = trim(substr(pessoa_jurid.cod_telex,1,7))
                                tmp-rtapi044.nm-email     
                              = trim(substr(pessoa_jurid.cod_e_mail,1,40)).

                        /* ----------------------------- LOCALIZA A CIDADE DO CONTRATANTE --- */
                         find first dzcidade
                              where dzcidade.nm-cidade = pessoa_jurid.nom_cidade
                                and dzcidade.estado    = pessoa_jurid.cod_unid_federac
                                    no-lock no-error.
                         if   avail dzcidade
                         then assign tmp-rtapi044.cd-cidade = dzcidade.cd-cidade.
                         else assign tmp-rtapi044.cd-cidade = 0.

                         /* ----------------- LOCALIZA A CIDADE DE COBRANCA DO CONTRATANTE --- */
                         find first dzcidade
                              where dzcidade.nm-cidade = pessoa_jurid.nom_cidad_cobr
                                and dzcidade.estado    = pessoa_jurid.cod_unid_federac_cobr
                                    no-lock no-error.
                         if   avail dzcidade
                         then assign tmp-rtapi044.cd-cidade-cob = dzcidade.cd-cidade.
                         else assign tmp-rtapi044.cd-cidade-cob = 0.
                       end.
                end.
           else do:
                  if   available fornecedor
                  then do:
                         /* ------------------------ CAMPOS PARA TABELA FORNECEDOR ---*/
                         create tmp-rtapi044.
                         assign tmp-rtapi044.cd-contratante   = fornecedor.cdn_fornecedor
                                tmp-rtapi044.nome-abrev       = fornecedor.nom_abrev
                                tmp-rtapi044.nr-cgc-cpf       = fornecedor.cod_id_feder
                                tmp-rtapi044.cd-pais          = fornecedor.cod_pais
                                tmp-rtapi044.nm-contratante   = fornecedor.nom_pessoa
                                tmp-rtapi044.identific        = "F"
                                tmp-rtapi044.cod-gr-cli       = 0
                                tmp-rtapi044.nat-operacao     = ""
                                tmp-rtapi044.nr-pessoa        = fornecedor.num_pessoa
                                tmp-rtapi044.dt-implantacao   = fornecedor.dat_impl_fornec.

                         assign tmp-rtapi044.cod-gr-forn
                              = int(substr(fornecedor.cod_grp_fornec,1,2)) no-error.
   
                         if   error-status:error
                         then do:
                                run chama-mens-rtapi044
                                               (input 987,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input in-funcao-rtapi044-aux).
                                assign lg-erro-api-par = yes.
                                return.
                              end.
   
                         /* ------------------------------------- PESQUISA PAIS --- */
                          find pais where pais.cod_pais                        
                                        = fornecedor.cod_pais no-lock no-error.
   
                         if   available pais
                         then assign tmp-rtapi044.nm-pais 
                                     = trim(substr(pais.nom_pais,1,20)). 
                         else assign tmp-rtapi044.nm-pais = "".
   
                         /* ------------------- PESQUISA FORNECEDOR FINANCEIRO --- */
                         find fornec_financ where fornec_financ.cod_empresa
                                               = trim(cd-empresa-rtapi044-aux)
                                             and fornec_financ.cdn_fornecedor
                                               = fornecedor.cdn_fornecedor 
                                            no-lock no-error.
   
                         if   not available fornec_financ
                         then do:
                                run chama-mens-rtapi044
                                               (input 987,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input in-funcao-rtapi044-aux).
                                assign lg-erro-api-par = yes.
                                return.
                              end.
                         /* ----------------------- PESQUISA MOEDA CORRENTE --- */
                         find LAST histor_finalid_econ where 
                              histor_finalid_econ.cod_finalid_econ 
                            = pais.cod_finalid_econ_pais
                          AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
                          no-lock no-error.
                       
                         if   not available histor_finalid_econ
                         then do:
                                 run chama-mens-rtapi044
                                                (input 1647,
                                                 input lg-prim-mens-rtapi044-aux,
                                                 input no,
                                                 input "",
                                                 input in-funcao-rtapi044-aux).
                                 assign lg-erro-api-par = yes.
                                 return.
                              end.

                         assign tmp-rtapi044.agencia       
                                = trim(substr(fornec_financ.cod_agenc_bcia,1,8))
                                tmp-rtapi044.agencia-digito
                                = trim(fornec_financ.cod_digito_agenc_bcia)
                                tmp-rtapi044.conta-corren  
                                = trim(fornec_financ.cod_cta_corren_bco)
                                tmp-rtapi044.cod-digito-cta-corren
                                = trim(fornec_financ.cod_digito_cta_corren)
                                tmp-rtapi044.cd-representante 
                                = 0
                                tmp-rtapi044.forma-pagto
                                = trim(fornec_financ.cod_forma_pagto)
                                tmp-rtapi044.cd-moeda-corrente
                                = histor_finalid_econ.cod_indic_econ.
   
                         assign tmp-rtapi044.portador       
                              = int(fornec_financ.cod_portador) no-error.
   
                         if   error-status:error
                         then do:
                                run chama-mens-rtapi044
                                               (input 981,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input in-funcao-rtapi044-aux).
                                assign lg-erro-api-par = yes.
                                return.
                              end. 
   
                         assign tmp-rtapi044.cod-banco       
                              = int(substr(fornec_financ.cod_banco,1,3)) no-error.
   
                         if   error-status:error
                         then do:
                                run chama-mens-rtapi044
                                               (input 982,
                                                input lg-prim-mens-rtapi044-aux,
                                                input no,
                                                input "",
                                                input in-funcao-rtapi044-aux).
                                assign lg-erro-api-par = yes.
                                return.
                              end. 
   
                         assign tmp-rtapi044.modalidade = 0.       
   
                         if   (fornecedor.num_pessoa / 2)
                            = (int(fornecedor.num_pessoa / 2))
                         then assign tmp-rtapi044.in-tipo-pessoa = "F".
                         else assign tmp-rtapi044.in-tipo-pessoa = "J".
   
                         if   cd-contratante-rtapi044-aux = 0
                         then do:
                                if   in-tipo-pessoa-rtapi044-aux 
                                <>   tmp-rtapi044.in-tipo-pessoa    
                                then do:
                                       /* -------- LOCALIZA E SETA MENSAGEM PADRAO DO SISTEMA --- */
                                       /* ---------- CRIA/GRAVA MENSAGEM OCORRIDA NA rtapi044 --- */
                                       run chama-mens-rtapi044
                                                      (input 992,
                                                       input lg-prim-mens-rtapi044-aux,
                                                       input no,
                                                       input "",
                                                       input "").

                                       /* ------------------ SETA ERRO OCORRIDO NA GERA-DADOS --- */
                                       assign lg-erro-api-par = yes.
                                       return.
                                     end.
                              end.
                         
                         if   tmp-rtapi044.in-tipo-pessoa = "F"
                         then do:
                                /* -------------------------- PESQUISA PESSOA FISICA --- */
                                find first pessoa_fisic where pessoa_fisic.num_pessoa_fisic
                                                            = fornecedor.num_pessoa
                                                              no-lock no-error.
   
                                if   not available pessoa_fisic
                                then do:
                                       run chama-mens-rtapi044
                                                      (input 983,
                                                       input lg-prim-mens-rtapi044-aux,
                                                       input no,
                                                       input "",
                                                       input in-funcao-rtapi044-aux).
                                       assign lg-erro-api-par = yes.
                                       return.
                                     end.
   
                                assign tmp-rtapi044.en-bairro        
                                     = trim(substr(pessoa_fisic.nom_bairro,1,30))
                                       tmp-rtapi044.en-bairro-cob    
                                     = trim(substr(pessoa_fisic.nom_bairro,1,30))
                                       tmp-rtapi044.en-cep           
                                     = trim(substr(pessoa_fisic.cod_cep,1,8))
                                       tmp-rtapi044.en-cep-cob       
                                     = trim(substr(pessoa_fisic.cod_cep,1,8))
                                       tmp-rtapi044.en-uf            
                                     = trim(substr(pessoa_fisic.cod_unid_federac,1,2))
                                       tmp-rtapi044.en-uf-cob        
                                     = trim(substr(pessoa_fisic.cod_unid_federac,1,2))
                                       tmp-rtapi044.en-rua           
                                     = trim(pessoa_fisic.nom_endereco)
                                       tmp-rtapi044.en-rua-cob       
                                     = trim(pessoa_fisic.nom_endereco)
                                       tmp-rtapi044.nr-telefone
                                     = trim(substr(pessoa_fisic.cod_telefone,1,20))
                                       tmp-rtapi044.nr-caixa-postal  
                                     = trim(substr(pessoa_fisic.cod_cx_post,1,20))
                                       tmp-rtapi044.nr-caixa-postal-cob 
                                     = trim(substr(pessoa_fisic.cod_cx_post,1,20))
                                       tmp-rtapi044.nr-insc-estadual 
                                     = trim(substr(pessoa_fisic.cod_id_estad_fisic,1,19))
                                       tmp-rtapi044.nr-fax    
                                     = trim(substr(pessoa_fisic.cod_fax,1,20))        
                                       tmp-rtapi044.nr-ramal-fax 
                                     = trim(substr(pessoa_fisic.cod_ramal_fax,1,7))  
                                       tmp-rtapi044.nr-telex 
                                     = trim(substr(pessoa_fisic.cod_telex,1,7))
                                       tmp-rtapi044.nm-email     
                                     = trim(substr(pessoa_fisic.cod_e_mail,1,40)).
                                    
                                /* ---------------------- LOCALIZA A CIDADE DO CONTRATANTE --- */
                                find first dzcidade
                                     where dzcidade.nm-cidade = pessoa_fisic.nom_cidade
                                       and dzcidade.estado    = pessoa_fisic.cod_unid_federac
                                           no-lock no-error.
                                if   avail dzcidade
                                then assign tmp-rtapi044.cd-cidade     = dzcidade.cd-cidade
                                            tmp-rtapi044.cd-cidade-cob = dzcidade.cd-cidade.
                                else assign tmp-rtapi044.cd-cidade     = 0
                                            tmp-rtapi044.cd-cidade-cob = 0.
                              end.

                         else do:
                                /* ------------------------ PESQUISA PESSOA JURIDICA --- */
                                find first pessoa_jurid where pessoa_jurid.num_pessoa_jurid
                                                            = fornecedor.num_pessoa
                                                              no-lock no-error.
   
                                if   not available pessoa_jurid
                                then do:
                                       run chama-mens-rtapi044
                                                      (input 985,
                                                       input lg-prim-mens-rtapi044-aux,
                                                       input no,
                                                       input "",
                                                       input in-funcao-rtapi044-aux).
                                       assign lg-erro-api-par = yes.
                                       return.
                                     end.
   
                                assign tmp-rtapi044.en-bairro        
                                     = trim(substr(pessoa_jurid.nom_bairro,1,30))
                                       tmp-rtapi044.en-bairro-cob    
                                     = trim(substr(pessoa_jurid.nom_bairro_cobr,1,30))
                                       tmp-rtapi044.en-cep           
                                     = trim(substr(pessoa_jurid.cod_cep,1,8))
                                       tmp-rtapi044.en-cep-cob       
                                     = trim(substr(pessoa_jurid.cod_cep_cobr,1,8))
                                       tmp-rtapi044.en-uf            
                                     = trim(substr(pessoa_jurid.cod_unid_federac,1,2))
                                       tmp-rtapi044.en-uf-cob        
                                     = trim(substr(pessoa_jurid.cod_unid_federac_cobr,1,2))
                                       tmp-rtapi044.en-rua           
                                     = trim(pessoa_jurid.nom_endereco)
                                       tmp-rtapi044.en-rua-cob       
                                     = trim(pessoa_jurid.nom_ender_cobr)
                                       tmp-rtapi044.nr-telefone   
                                     = trim(substr(pessoa_jurid.cod_telefone,1,20))
                                       tmp-rtapi044.nr-caixa-postal  
                                     = trim(substr(pessoa_jurid.cod_cx_post,1,20))
                                       tmp-rtapi044.nr-caixa-postal-cob 
                                     = trim(substr(pessoa_jurid.cod_cx_post_cobr,1,20))
                                       tmp-rtapi044.nr-insc-estadual 
                                     = trim(substr(pessoa_jurid.cod_id_estad_jurid,1,19))
                                       tmp-rtapi044.nr-fax    
                                     = trim(substr(pessoa_jurid.cod_fax,1,20))        
                                       tmp-rtapi044.nr-ramal-fax 
                                     = trim(substr(pessoa_jurid.cod_ramal_fax,1,7))  
                                       tmp-rtapi044.nr-telex 
                                     = trim(substr(pessoa_jurid.cod_telex,1,7))
                                       tmp-rtapi044.nm-email     
                                     = trim(substr(pessoa_jurid.cod_e_mail,1,40)).

                                /* ---------------------- LOCALIZA A CIDADE DO CONTRATANTE --- */
                                find first dzcidade
                                     where dzcidade.nm-cidade = pessoa_jurid.nom_cidade
                                       and dzcidade.estado    = pessoa_jurid.cod_unid_federac
                                           no-lock no-error.
                                if   avail dzcidade
                                then assign tmp-rtapi044.cd-cidade = dzcidade.cd-cidade.
                                else assign tmp-rtapi044.cd-cidade = 0.

                                /* ---------- LOCALIZA A CIDADE DE COBRANCA DO CONTRATANTE --- */
                                find first dzcidade
                                     where dzcidade.nm-cidade = pessoa_jurid.nom_cidad_cobr
                                       and dzcidade.estado    = pessoa_jurid.cod_unid_federac_cobr
                                           no-lock no-error.
                                if   avail dzcidade
                                then assign tmp-rtapi044.cd-cidade-cob = dzcidade.cd-cidade.
                                else assign tmp-rtapi044.cd-cidade-cob = 0.
                              end.
                       end.
                end.
         end.
   
end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure desedita-cgc-cpf:

   /* ----------------------------------------- DEFINICAO DE PARAMETROS DE ENTRADA E SAIDA --- */
   def input  parameter nr-cgc-cpf-editado-par    like contrat.nr-cgc-cpf                no-undo.
   def output parameter nr-cgc-cpf-deseditado-par like contrat.nr-cgc-cpf                no-undo.

   /* ------------------------------------------------------ DEFINICAO DE VARIAVEIS LOCAIS --- */
   def var ix-cont-aux                              as int                               no-undo.

   /* ---------------------------------------------------------------------------------------- */
   assign nr-cgc-cpf-deseditado-par = "".

   do ix-cont-aux = 1 to length(trim(nr-cgc-cpf-editado-par)):

      if   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "0"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "1"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "2"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "3"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "4"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "5"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "6"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "7"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "8"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "9"
      then assign nr-cgc-cpf-deseditado-par = nr-cgc-cpf-deseditado-par + substring(nr-cgc-cpf-editado-par,ix-cont-aux,1).
   end.

end procedure.

/* - FINAL PROCEDURE P/PROCESSAR DADOS AFIM DE GERAR A TABELA TEMPORARIA --- */
/* ---------------------------------------------- rtapi044 COMPARTILHADA --- */
procedure mostra-erros-rtapi044:
    
   /* ------------------------------------- HABILITA OS BOTOES DO BROWSE --- */
   enable b-ok-tmp-mensa-rtapi044
          with frame f-tmp-mensa-rtapi044.

   open query zoom-tmp-mensa-rtapi044
        for each tmp-mensa-rtapi044 no-lock.

   update browse-tmp-mensa-rtapi044 go-on(end-error)
          with frame f-tmp-mensa-rtapi044.

   /* ----------------------------------- DESABILITA OS BOTOES DO BROWSE --- */
   disable b-ok-tmp-mensa-rtapi044
           with frame f-tmp-mensa-rtapi044.

end procedure.
/* ---------------------------------------------------------------- EOF --- */
          /* ------------------------ INCLUDE COM DECLARACOES RTAPI044.P --- */

/*-----------------------------API.i--------------------------------------------------------*/
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
 

def temp-table tmp-evento-fat    no-undo
    field cd-modulo             as int 
    field cd-rotina             as int
    field cd-evento             as int  
    field ct-codigo             as char format "x(20)"
    field sc-codigo             as char format "x(20)"
    field cd-especie            as char
    field lg-valor              as log
    field pc-princ-aux          as dec
    field lg-modulo-agregado    as log 
    field lg-prop-evento        as log
    field in-programa           as char format "x(12)"
    field in-classe-rotina      as int
    field lg-modulo             as log
    field lg-cred-deb           as log 
    field lg-destacado          as log
    field in-classe-evento      as char
    field lg-modulo-obrigatorio as log
    field vl-evento             as dec format 999999999999.99
    field vl-evento-cart-nv     as dec format 999999999999.99
    field pc-desconto           as dec format 999.99
    field pc-acrescimo          as dec format 999.99
    field pc-desc-prom-pl       as dec format 999.99
    field lg-cred-deb-mens      as log
    field qt-evento             as int
    field pc-negociacao-mens    as dec format 999.99
    field nr-rowid-evt-prog     as rowid
    index idx1 cd-evento
    index idx2 in-classe-evento
    index idx3 lg-modulo
    index idx4 in-classe-rotina
               in-programa.

def temp-table tmp-evento-benef no-undo
    field cd-usuario            as int 
    field cd-modulo             as int 
    field cd-evento             as int
    field cd-grau-parentesco    as int 
    field nr-faixa-etaria       as int
    field vl-evento             as dec format 999999999999.99
    field vl-fat-repasse        as dec format 9.9999
    field nr-idade-atu          as int
    field nr-idade-ant          as int 
    field nr-idade-exc          as int 
    field nr-idade-inc          as int 
    field nr-idade-sem-reaj     as int
    field cd-padrao-cobertura   as char
    field cd-sit-usuario        as int
    field dt-proporcao          as date
    field dt-inclusao-plano     as date
    field dt-exclusao-plano     as date
    field aa-ult-fat            as int 
    field mm-ult-fat            as int 
    field lg-susp-mes-ant       as log
    field lg-cobra-insc         as log
    field cdd-regra             as dec
    field dt-inicio-regra       as date
    field id-criter             as dec
    field lg-processado         as log
    field lg-mod-agregado       as log
    field nr-rowid-evt-prog     as rowid
    field lg-sem-reajuste       as log
    field ct-nova-via           as int 
    field ct-transf             as int
    field rw-usumodu            as rowid
    index idx1 cd-usuario
               cd-evento
    index idx2 cd-usuario
               cd-modulo
    index idx3 cd-evento
               cd-grau-parentesco
               nr-faixa-etaria.

def temp-table tmp-reajuste     no-undo
    field aa-reajuste           as int 
    field mm-reajuste           as int 
    field pc-reajuste           as dec format 999.99
    field cd-modulo             as int
    field lg-criar              as log
    index idx1 aa-reajuste  
               mm-reajuste  
               cd-modulo.

def temp-table tmp-reajuste-benef no-undo
    field aa-reajuste           as int 
    field mm-reajuste           as int 
    field cd-usuario            as int
    field pc-reajuste           as dec format 999.99
    field cd-modulo             as int
    field lg-criar              as log
    index idx1 aa-reajuste  
               mm-reajuste  
               cd-usuario
               cd-modulo.
                         
def temp-table tmp-impostos no-undo
    field cd-evento           like fatueven.cd-evento
    field cd-imposto          like dzimposto.cd-imposto
    field vl-base             as dec
    field pc-aliquota         like evenimp.pc-aliquota
    field vl-minimo-retencao  like contrimp.vl-minimo-retencao
    index cd-evento
          cd-imposto.

def temp-table tmp-usu-total  no-undo
    field cd-usuario          as int 
    field vl-usuario          as dec format 999999999999.99.  

/* --------------- TEMP PARA AGRUPAR BENEFICIARIOS POR MES A SER FATURADO --- */
def temp-table tmp-usu-refer     no-undo
    field aa-referencia          as int
    field mm-referencia          as int
    field cd-usuario             as int
    field lg-sit-cinco           as log
    field lg-processado          as log 
    index tmp-usu-refer1         as primary
          aa-referencia
          mm-referencia
          cd-usuario.

def temp-table tmp-depen-usuar  no-undo
    field cd-usuario            as int 
    field in-tipo-dependencia   as int
    field lg-calc-imposto       as log
    field pc-valor              as dec format "999.99".

def temp-table tmp-atu-usunegoc no-undo
    field rw-usunegoc           as rowid
    field aa-referencia-fat     as int 
    field mm-referencia-fat     as int. 

def temp-table w-fatmen   no-undo       like notaserv.
def temp-table w-fateve   no-undo       like fatueven.
def temp-table w-fatgrau  no-undo       like fatgrmod.
def temp-table w-fatgrun  no-undo       like fatgrunp.



/* --- Definicao das temp's w-fatsemreaj e w-vlbenef ----------------------- */
def  temp-table w-fatsemreaj no-undo
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

def  temp-table w-vlbenef no-undo
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
 
                  
/*--------------------------------------VARIAVEIS------------------------------------------ */
def var ep-codigo-aux                 like propost.ep-codigo                         no-undo.
def var cod-estabel-aux               like propost.cod-estabel                       no-undo.
def var cd-modalidade-aux             like propost.cd-modalidade                     no-undo.
def var nr-ter-ade-aux                like propost.nr-ter-adesao                     no-undo.
def var cd-tipo-vencimento-aux        like propost.cd-tipo-vencimento                no-undo.
def var dd-vencimento-aux             like propost.dd-vencimento                     no-undo.
def var pc-acrescimo-aux              like propost.pc-acrescimo                      no-undo.
def var pc-desconto-aux               like propost.pc-desconto                       no-undo.
def var pc-acrescimo-insc-aux         like propost.pc-acrescimo-insc                 no-undo.
def var pc-desconto-insc-aux          like propost.pc-desconto-insc                  no-undo.
def var pc-desc-prom-pl-aux           like propost.pc-desc-prom-pl                   no-undo.
def var lg-erro-aux                   as   log                                       no-undo. 
def var cd-contratante-aux            like contrat.cd-contratante                    no-undo. 
def var cd-contratante-origem-aux     like contrat.cd-contratante                    no-undo. 
def var aa-ref-aux                    as int                                         no-undo.  
def var mm-ref-aux                    as int                                         no-undo. 
def var mm-referencia-aux             as int                                         no-undo. 
def var aa-referencia-aux             as int                                         no-undo. 
def var dt-emissao-aux                as date                                        no-undo. 
def var dt-vencimento-aux             as date                                        no-undo. 
def var nr-sequencia-aux              as int                                         no-undo. 
def var aa-prox-fat-aux               as int                                         no-undo. 
def var mm-prox-fat-aux               as int                                         no-undo. 
def var dt-ref-ant-aux                as date                                        no-undo. 
def var dt-ref-exc                    as date                                        no-undo. 
def var dt-ini-ref-aux                as date                                        no-undo. 
def var dt-inc-prog                   as date                                        no-undo. 
def var dt-limite-aux                 as date                                        no-undo. 
def var nr-periodicidade-meses-aux    as int                                         no-undo. 
def var in-faturar-aux                as int                                         no-undo. 
def var aa-ult-fat-period-aux         as int                                         no-undo.
def var mm-ult-fat-period-aux         as int                                         no-undo.
def var lg-tem-percevento             as log                                         no-undo. 
def var pc-prop-evento-aux            as dec                                         no-undo. 
def var lg-ct-contabil-aux            as log                                         no-undo. 
def var ct-codigo-aux                 as char                                        no-undo. 
def var sc-codigo-aux                 as char                                        no-undo. 
def var ct-codigo-dif-aux             as char                                        no-undo. 
def var sc-codigo-dif-aux             as char                                        no-undo. 
def var ct-codigo-dif-neg-aux         as char                                        no-undo. 
def var sc-codigo-dif-neg-aux         as char                                        no-undo. 
def var lg-evencontde-aux             as log                                         no-undo. 
def var lg-modulo-agregado-aux        as log                                         no-undo. 
def var ds-mensagem-aux               as char                                        no-undo. 
def var qt-meses-faturados-aux        as int                                         no-undo. 
def var cdd-regra-proposta-aux        as dec                                         no-undo. 
def var cdd-regra-usuario-aux         as dec                                         no-undo. 
def var dt-inicio-regra-prop-aux      as date                                        no-undo. 
def var dt-inicio-regra-aux           as date                                        no-undo. 
def var dt-exc-usu-aux                as date                                        no-undo. 
def var dt-inc-usu-aux                as date                                        no-undo. 
def var qt-usu-aux                    as int                                         no-undo. 
def var lg-modulo-obrigatorio-aux     as log                                         no-undo. 
def var nr-idade-inc                  as int                                         no-undo.
def var nr-idade-ant                  as int                                         no-undo.
def var nr-idade-atu                  as int                                         no-undo.
def var nr-idade-exc                  as int                                         no-undo.
def var nr-idade-sem-reaj-aux         as int                                         no-undo. 
def var nr-faixa-etaria-atu           as int                                         no-undo. 
def var vl-modulo-aux                 as dec format 999999999999.99                  no-undo. 
def var vl-tx-insc-aux                as dec format 999999999999.99                  no-undo.
def var qt-fat-repasse-aux            as dec format 9.9999                           no-undo. 
def var pc-taxa-insc-aux              as dec format 9.9999                           no-undo.    
def var lg-cred-deb-mens-aux          as log                                         no-undo. 
def var pc-negociacao-mens-aux        as dec format 999.99                           no-undo. 
def var lg-cred-deb-insc-aux          as log                                         no-undo. 
def var pc-negociacao-ins-aux         as dec format 999.99                           no-undo. 
def var pc-imposto-aux                as dec format 999.99                           no-undo. 
def var aa-mm-ult-reaj-aux            as char format "x(06)"                         no-undo. 
def var aa-mm-ref-aux                 as char format "x(06)"                         no-undo. 
def var qt-caren-dias                 as int                                         no-undo.
def var qt-caren-urgencia             as int                                         no-undo.
def var qt-caren-eletiva              as int                                         no-undo.
def var lg-suspensao-reajuste-aux     as log                                         no-undo. 
def var dt-proporcao-modulo-aux       as date                                        no-undo. 
def var dt-proporcao-usu-aux          as date                                        no-undo. 
def var lg-susp-mes-anterior-aux      as log                                         no-undo. 
def var lg-susp-mes-atual-aux         as log                                         no-undo. 
def var dt-ref-aux                    as date                                        no-undo. 
def var lg-fat-proporc-saida          as log                                         no-undo. 
def var dt-ref-pro-aux                as date                                        no-undo. 
def var vl-grau-faixa-aux             as dec format 999999999999.99                  no-undo. 
def var qt-evto-grfaixa-aux           as int                                         no-undo. 
def var nr-benef-ativ-aux             as int                                         no-undo. 
def var vl-nota-aux                   as dec format 999999999999.99                  no-undo. 
def var pc-desconto-promo-aux         as dec format 999999999999.99                  no-undo. 
def var des-excecao-aux               as char                                        no-undo. 
def var lg-retorna                    as log                                         no-undo. 
def var dt-ini-aux                    as date                                        no-undo.
def var dt-fim-aux                    as date                                        no-undo.
def var dt-ult-dia-fat-termo-aux      as date                                        no-undo. 
def var dt-inclusao-programada-aux    as date                                        no-undo.
def var cd-especie-aux                as char                                        no-undo. 
def var lg-gerou-fatura-aux           as log                                         no-undo. 
def var cd-modalidade-cob-aux         like fatura.modalidade                         no-undo.
def var cd-portador-aux               like fatura.portador                           no-undo.
def var dt-referencia-aux             as date                                        no-undo. 


def buffer b-usuario  for usuario. 

procedure api-desmembra-fatura:
    def input-output  parameter table for tmp-api-mens-pre-pagamento.
    def       output  parameter table for tmp-notaserv-tot.
    def       output  parameter table for rowErrors.

    run limpa-variaveis.

    empty temp-table tmp-evento-fat. 
    empty temp-table tmp-evento-benef.
    empty temp-table tmp-reajuste.
    empty temp-table tmp-usu-total. 
    empty temp-table tmp-atu-usunegoc.
    empty temp-table rowErrors.

    run validacoes-iniciais-faturamento-normal (output lg-erro-aux).

    if lg-erro-aux
    then undo, return.

    for first desmembr-fatur where desmembr-fatur.ep-codigo     = propost.ep-codigo
                               and desmembr-fatur.cod-estabel   = propost.cod-estabel
                               and desmembr-fatur.cd-modalidade = propost.cd-modalidade
                               and desmembr-fatur.nr-proposta   = propost.nr-proposta
                               no-lock: end.

    if not avail desmembr-fatur
    then do:
            run insertOtherError(input 72,
                                 input "Proposta nao parametrizada para desmembramento da fatura",
                                 input "",
                                 input "GP",
                                 input "E",
                                 input "",
                                 input-output table rowErrors).
            undo, return.
         end.

    /*
      VERIFICA FATORES DE DESCONTO E ACRESCIMO DA PROPOSTA.
    */
    run ver-perc-prop.

    /* 
      VERIFICA A QUANTIDADE DE MESES FATURADOS
    */
    run calcula-meses-faturados.

    for each usuario fields (usuario.cd-usuario
                             usuario.cd-grau-parentesco
                             usuario.log-17)
                     where usuario.cd-modalidade = propost.cd-modalidade
                       and usuario.nr-proposta   = propost.nr-proposta
                       and usuario.cd-sit-usuario  > 04
                       and usuario.cd-sit-usuario <> 10
                       and usuario.cd-sit-usuario <> 08
                       and usuario.cd-sit-usuario <> 09 no-lock:

        /* --- USUARIO EVENTUAL ---------------------------------- */
        if usuario.log-17
        then next.

        create tmp-depen-usuar.
        assign tmp-depen-usuar.cd-usuario = usuario.cd-usuario.

        for first assoc-propost-grau-depend fields (assoc-propost-grau-depend.cod-tip-depend)
                                            where assoc-propost-grau-depend.ep-codigo          = propost.ep-codigo 
                                                  and assoc-propost-grau-depend.cod-estabel        = propost.cod-estabel
                                              and assoc-propost-grau-depend.cd-modalidade      = propost.cd-modalidade
                                              and assoc-propost-grau-depend.nr-proposta        = propost.nr-proposta
                                              and assoc-propost-grau-depend.cd-grau-parentesco = usuario.cd-grau-parentesco
                                             no-lock: end.
        if avail assoc-propost-grau-depend
        then do:
                if assoc-propost-grau-depend.cod-tip-depend = "2 - Dependente Indireto"
                then assign tmp-depen-usuar.in-tipo-dependencia  = 2
                            tmp-depen-usuar.lg-calc-imposto      = no.  
                else assign tmp-depen-usuar.in-tipo-dependencia  = 1
                            tmp-depen-usuar.lg-calc-imposto      = yes
                            tmp-depen-usuar.pc-valor             = desmembr-fatur.cdd-perc-desmembr.
             end.
        else for first gra-par  fields (gra-par.int-1)
                                where gra-par.cd-grau-parentesco = usuario.cd-grau-parentesco no-lock:
                 if gra-par.int-1 = 2
                 then assign tmp-depen-usuar.in-tipo-dependencia  = 2
                             tmp-depen-usuar.lg-calc-imposto      = no.  
                 else assign tmp-depen-usuar.in-tipo-dependencia  = 1
                             tmp-depen-usuar.lg-calc-imposto      = yes
                             tmp-depen-usuar.pc-valor             = desmembr-fatur.cdd-perc-desmembr.
             end.

        if desmembr-fatur.des-impto-val-base-fatur = "total"
        then tmp-depen-usuar.lg-calc-imposto      = yes.

        if tmp-depen-usuar.in-tipo-dependencia = 1
        then do:
                create tmp-depen-usuar.
                assign tmp-depen-usuar.cd-usuario           = usuario.cd-usuario
                       tmp-depen-usuar.in-tipo-dependencia  = 3
                       tmp-depen-usuar.pc-valor             = 100 - desmembr-fatur.cdd-perc-desmembr.

                if desmembr-fatur.des-impto-val-base-fatur = "total"
                then assign tmp-depen-usuar.lg-calc-imposto      = yes.
                else assign tmp-depen-usuar.lg-calc-imposto      = no.
             end.
    end.

    for each tmp-depen-usuar no-lock
             break by tmp-depen-usuar.in-tipo-dependencia:

        if first-of(tmp-depen-usuar.in-tipo-dependencia)
        then do:
                empty temp-table tmp-evento-fat. 
                empty temp-table tmp-evento-benef. 
                empty temp-table tmp-usu-total. 
                empty temp-table tmp-atu-usunegoc.

                assign qt-usu-aux = 0.

                run cria-tmp-evento-fat(input no, 
                                        input-output lg-erro-aux).
                if lg-erro-aux
                then undo, return.
             
                run rotinas-especificas(output lg-erro-aux).
             
                if lg-erro-aux
                then undo, return.
             end.

        for each usuario where usuario.cd-modalidade = propost.cd-modalidade
                           and usuario.nr-proposta   = propost.nr-proposta
                           and usuario.cd-usuario    = tmp-depen-usuar.cd-usuario no-lock:
            run cria-tmp-evento-benef.
        end.
    
        if last-of (tmp-depen-usuar.in-tipo-dependencia)
        then do:
                run desc-acresc-programado. 
    
                for each tmp-evento-benef exclusive-lock, 
                    first tmp-evento-fat where tmp-evento-fat.cd-evento = tmp-evento-benef.cd-evento 
                                           and tmp-evento-fat.cd-modulo = tmp-evento-benef.cd-modulo exclusive-lock:
                
                    /*---------------------------------------------------------
                     * se o primeiro faturamento
                     * ja foi processado entao nao necessita
                     * calcular os eventos de classe (K, L, C, O, P, Q).
                     * mensalidade proporcional e mensalidade mes anterior e
                     * inscricao
                     *---------------------------------------------------------*/
                    if  tmp-evento-benef.cd-sit-usuario > 5
                    and tmp-evento-benef.dt-proporcao   = ?
                    and (tmp-evento-fat.in-classe-evento = "K" or
                         tmp-evento-fat.in-classe-evento = "L" or
                         tmp-evento-fat.in-classe-evento = "C" or
                         tmp-evento-fat.in-classe-evento = "O" or
                         tmp-evento-fat.in-classe-evento = "P" or
                         tmp-evento-fat.in-classe-evento = "Q")
                    then next.
                
                    run p-valor-modulo.
                
                    /* ------------------------------------------------------
                     * Verifica se deve cobrar mens.integral ou proporcional
                     * caso benef.tenha sido excluido no mes do faturamento.
                     *-----------------------------------------------------*/
                    if parafatu.lg-cob-integral-exc
                    then assign lg-fat-proporc-saida = no.
                    else do:
                           if  month(tmp-evento-benef.dt-exclusao-plano) = mm-ref-aux
                           and  year(tmp-evento-benef.dt-exclusao-plano) = aa-ref-aux
                           and tmp-evento-benef.dt-exclusao-plano <> dt-limite-aux
                           then assign lg-fat-proporc-saida = yes.
                           else assign lg-fat-proporc-saida = no.
                         end. 
                                                                                   
                    if tmp-evento-fat.in-classe-rotina = 0
                    then run value("dep/" + tmp-evento-fat.in-programa).
                    else run executa-rotina (input nm-rotinas-aux[tmp-evento-fat.in-classe-rotina]).
                end.
                
                run processa-eventos-totais(input "H"). /*ACRESCIMOS*/
                run processa-eventos-totais(input "I"). /*DESCONTOS*/
                run processa-eventos-totais(input "J"). /*OUTROS*/
                run processa-eventos-totais(input "R"). /*EVENTO PROGRAMADO - PERCENTUAL*/
                run processa-eventos-totais(input "M"). /*EVENTO PROGRAMADO - VALOR*/
                run processa-eventos-totais(input "S"). /*EVENTO PROGRAMADO - PERCENTUAL SOBRE EVENTO*/
                
                
                for each tmp-evento-benef where tmp-evento-benef.lg-processado = no
                                             or tmp-evento-benef.vl-evento     = 0 exclusive-lock:
                    delete tmp-evento-benef. 
                end.


                if tmp-depen-usuar.in-tipo-dependencia = 1
                or tmp-depen-usuar.in-tipo-dependencia = 3
                then do:
                        for each tmp-evento-fat exclusive-lock:
                            assign tmp-evento-fat.vl-evento = round(tmp-evento-fat.vl-evento * (tmp-depen-usuar.pc-valor / 100), 2).
                        end.

                        for each tmp-evento-benef where tmp-evento-benef.lg-processado exclusive-lock:
                            assign tmp-evento-benef.vl-evento = round(tmp-evento-benef.vl-evento * (tmp-depen-usuar.pc-valor / 100), 2).
                        end.
                     end.

                
                /* --------------------- DESCONTO MENSALIDADE --- */
                run rtp/rtregrasdesc.p(input  propost.cd-modalidade,
                                       input  propost.nr-ter-adesao,
                                       input  dt-emissao-aux,
                                       input  cd-contratante-aux,
                                       input  aa-ref-aux,
                                       input  mm-ref-aux,
                                       output cd-evento-desconto-aux,
                                       output lg-desconto-aux,
                                       output table tmp-usu-desconto, 
                                       output table tmp-event-desc-menslid).
                
                if lg-desconto-aux
                then run aplica-desconto-usuario. 
                                             
                /* ---- CARREGA TEMP DE IMPOSTOS DO CONTRATANTE COM ALIQUOTAS --- */
                /* --------------------------- EVENTOS QUE INCIDEM NO IMPOSTO --- */
                if not tmp-api-mens-pre-pagamento.lg-desconsidera-imposto
                and tmp-depen-usuar.lg-calc-imposto
                then run carrega-evento-imp.

                run criacao-tabelas-faturamento (input no). 


                if tmp-api-mens-pre-pagamento.lg-geracao 
                then do:
                       /*cria fatura*/
                       assign cd-especie-aux = tmp-api-mens-pre-pagamento.cd-especie.
                       run cria-fatura(output lg-erro-aux).
                       if lg-erro-aux
                       then undo, return.

                       create tmp-notaserv-tot.
                       assign tmp-notaserv-tot.qt-usuario     = qt-usu-aux 
                              tmp-notaserv-tot.rw-notaserv    = rowid(notaserv)
                              tmp-notaserv-tot.in-tipo-depend = tmp-depen-usuar.in-tipo-dependencia.

                         create movimen-fatur-desmembr.
                         assign movimen-fatur-desmembr.cd-contratante        = fatura.cd-contratante
                                movimen-fatur-desmembr.nr-fatura             = fatura.nr-fatura
                                movimen-fatur-desmembr.aa-referencia         = fatura.aa-referencia
                                movimen-fatur-desmembr.num-mm-refer          = fatura.mm-referencia
                                movimen-fatur-desmembr.dt-vencimento         = fatura.dt-vencimento
                                movimen-fatur-desmembr.num-livre-1           = notaserv.cd-modalidade
                                movimen-fatur-desmembr.nr-ter-adesao         = notaserv.nr-ter-adesao
                                movimen-fatur-desmembr.in-tipo-nota          = notaserv.in-tipo-nota
                                movimen-fatur-desmembr.dat-ult-atualiz       = today
                                movimen-fatur-desmembr.hra-ult-atualiz       = string(time,"HH:MM:SS")
                                movimen-fatur-desmembr.cod-usuar-ult-atualiz = v_cod_usuar_corren.
                         
                         case tmp-depen-usuar.in-tipo-dependencia:
                             when 1 then assign movimen-fatur-desmembr.cod-tip-depend = "Direto Contratante".
                             when 2 then assign movimen-fatur-desmembr.cod-tip-depend = "Indireto".
                             when 3 then assign movimen-fatur-desmembr.cod-tip-depend = "Direto Funcionario".
                         end case.
                     end.
             end.
    end.
end procedure.

procedure api-mens-complementar:
    def input-output  parameter table for tmp-api-mens-pre-pagamento.
    def input-output  parameter table for w-fatmen.
    def input-output  parameter table for w-fateve.
    def input-output  parameter table for w-fatgrau.
    def input-output  parameter table for w-fatgrun.
    def input-output  parameter table for w-vlbenef.
    def input-output  parameter table for w-fatsemreaj.
    def       output  parameter table for rowErrors.

    def buffer b-tmp-usu-refer for tmp-usu-refer. 

    run limpa-variaveis.
    empty temp-table tmp-evento-fat. 
    empty temp-table tmp-evento-benef.
    empty temp-table tmp-reajuste.
    empty temp-table tmp-usu-total. 
    empty temp-table rowErrors.
    empty temp-table tmp-usu-refer. 
    empty temp-table tmp-atu-usunegoc.

    find first tmp-api-mens-pre-pagamento no-lock no-error.

    if not avail tmp-api-mens-pre-pagamento
    then do:
           run insertErrorGP(input 01015,
                             input "Temp-Table : tmp-api-mens-pre-pagamento",
                             input "",
                             input-output table rowErrors).
            undo, return.
         end.

    find first paramecp no-lock no-error.

    if not avail paramecp
    then do:
           run insertErrorGP(input 0006,
                             input "Empresa: " + tmp-api-mens-pre-pagamento.ep-codigo,
                             input "",
                             input-output table rowErrors).
            undo, return.
         end.

    find parafatu use-index parafat1
         where parafatu.ep-codigo = tmp-api-mens-pre-pagamento.ep-codigo
               no-lock no-error.

    if not avail parafatu
    then do:
            run insertErrorGP(input 01665,
                              input "Empresa: " + tmp-api-mens-pre-pagamento.ep-codigo,
                              input "",
                              input-output table rowErrors).
            undo, return.
         end.


    run valida-contrato(output lg-erro-aux).

    if lg-erro-aux
    then return.

    assign ep-codigo-aux           = propost.ep-codigo
           cod-estabel-aux         = propost.cod-estabel
           cd-modalidade-aux       = propost.cd-modalidade
           nr-ter-ade-aux          = propost.nr-ter-adesao
           cd-tipo-vencimento-aux  = propost.cd-tipo-vencimento
           dd-vencimento-aux       = propost.dd-vencimento
           pc-acrescimo-aux        = propost.pc-acrescimo     
           pc-desconto-aux         = propost.pc-desconto      
           pc-acrescimo-insc-aux   = propost.pc-acrescimo-insc
           pc-desconto-insc-aux    = propost.pc-desconto-insc 
           pc-desc-prom-pl-aux     = propost.pc-desc-prom-pl
           in-faturar-aux          = 1.

    run valida-contratante(output cd-contratante-aux,
                           output cd-contratante-origem-aux,
                           output lg-erro-aux).

    if lg-erro-aux
    then return.

    run valida-estrutura-proposta(output lg-erro-aux).

    if lg-erro-aux
    then return.

    /* CALCULA AUXILIAR COM ULTIMO DIA DO MES E ANO DO ULTIMO FATURAMENTO DO TERMO */
    if  ter-ade.aa-ult-fat > 0
    and ter-ade.mm-ult-fat > 0
    then run rtp/rtultdia.p (input  ter-ade.aa-ult-fat, 
                             input  ter-ade.mm-ult-fat, 
                             output dt-ult-dia-fat-termo-aux).

    for each  usuario 
         where usuario.cd-modalidade  = propost.cd-modalidade
           and usuario.nr-proposta    = propost.nr-proposta
           and usuario.cd-sit-usuario >  04
           and usuario.cd-sit-usuario <> 10 
           and usuario.cd-sit-usuario <> 08
           and usuario.cd-sit-usuario <> 09
               no-lock:
       
          /* --- USUARIO EVENTUAL ---------------------------------- */
          if usuario.log-17
          then next.
       
          if usuario.dt-inclusao-plano =  usuario.dt-exclusao-plano and
             usuario.dt-inclusao-plano <> ?
          then next.
       
          /*------usuario nao faturado e excluido--------------- Nadi*/
          if  usuario.aa-ult-fat         = 0
          and usuario.mm-ult-fat         = 0
          and usuario.dt-exclusao-plano <> ?
          and usuario.dt-exclusao-plano <= dt-ult-dia-fat-termo-aux
          and usuario.cd-sit-usuario = 90 
          then next.
       
         /* ------------------------------------------------------------
          * USUARIO DEVE TER SIDO INCLUIDO ANTES DO ULTIMO FATURAMENTO *
          * DO TERMO E NUNCA TER SIDO FATURADO                         *
          * OU DEVE TER DATA DE ULTIMO FATURAMENTO COMPLEMENTAR MENOR  *
          * QUE A DATA DE FIM DE FATURAMENTO COMPLEMENTAR (ESTORNO)    * 
          * ---------------------------------------------------------- */
         if (    usuario.aa-ult-fat         = 0
             and usuario.mm-ult-fat         = 0
             and usuario.dt-inclusao-plano <= dt-ult-dia-fat-termo-aux)
             or (usuario.aa-ult-comp       <  usuario.aa-fim-comp
              or usuario.mm-ult-comp       <  usuario.mm-fim-comp)
         then do:
       
                 /* ----------------------------------------------------
                   --- USUARIO INCLUIDO ANTES DO ULTIMO FATURAMENTO ---
                   ---------------------------------------------------- */
                if  usuario.aa-ult-fat = 0
                and usuario.mm-ult-fat = 0
                and usuario.dt-inclusao-plano <= dt-ult-dia-fat-termo-aux
                then do:
                       assign dt-ini-aux = date(month(usuario.dt-inclusao-plano),
                                           01, year(usuario.dt-inclusao-plano))
                              dt-fim-aux = date(ter-ade.mm-ult-fat,01,
                                                ter-ade.aa-ult-fat).
                     end.
                /* --------------------------------------------------------
                   --- DATA DE ULT FAT COMP. MENOR QUE FIM DE FAT COMP. ---
                   -------------------------------------------------------- */
                else do:
                       assign dt-ini-aux = date("01/05/2003")
                              dt-fim-aux = date("31/05/2003").
       
                       if usuario.mm-ult-comp = 0
                       or usuario.aa-ult-comp = 0
                       then assign dt-ini-aux = date(month(usuario.dt-inclusao-plano),01,
                                                     year (usuario.dt-inclusao-plano)).
                       else if usuario.mm-ult-comp = 12
                            then assign dt-ini-aux = date(01,01,usuario.aa-ult-comp + 1).
                            else assign dt-ini-aux = date(usuario.mm-ult-comp + 1,01,
                                                          usuario.aa-ult-comp).
                       assign dt-fim-aux = date(usuario.mm-fim-comp ,01,
                                                usuario.aa-fim-comp).
                     end.
       
                repeat while dt-ini-aux <= dt-fim-aux:
                   create tmp-usu-refer.
                   assign tmp-usu-refer.aa-referencia = year (dt-ini-aux)
                          tmp-usu-refer.mm-referencia = month(dt-ini-aux)
                          tmp-usu-refer.cd-usuario    = usuario.cd-usuario
                          tmp-usu-refer.lg-sit-cinco  = if usuario.cd-sit-usuario = 05
                                                        then yes
                                                        else no.
                   if month(dt-ini-aux)   = 12
                   then assign dt-ini-aux = date(1, 01, year(dt-ini-aux) + 1).
                   else assign dt-ini-aux = date(month(dt-ini-aux) + 1, 01, year(dt-ini-aux)).
       
                end. /* repeat... */
              end. /* if... */
  end. /* for each... */

  if not can-find(first tmp-usu-refer)
  then do:
          run insertErrorGP(input 01654,
                            input "Modalidade: "
                                   + string(propost.cd-modalidade)
                                   + " Termo: "
                                   + string(propost.nr-ter-adesao),
                            input "",
                            input-output table rowErrors).
          undo, return.
       end.

 assign aa-mm-ult-reaj-aux = ""
        aa-mm-ref-aux      = string(aa-ref-aux, "9999") + string(mm-ref-aux, "99").


  /*
    VERIFICA FATORES DE DESCONTO E ACRESCIMO DA PROPOSTA.
  */
  run ver-perc-prop.

  for each tmp-usu-refer no-lock,
      each usuario where usuario.cd-modalidade = propost.cd-modalidade
                     and usuario.nr-proposta   = propost.nr-proposta 
                     and usuario.cd-usuario    = tmp-usu-refer.cd-usuario no-lock
                     break by tmp-usu-refer.aa-referencia 
                           by tmp-usu-refer.mm-referencia:

      assign tmp-usu-refer.lg-processado = yes.

      /* ------------------------------- PRIMEIRO BENEFICIARIO DO MES --- */
      if   first-of(tmp-usu-refer.aa-referencia)
      or   first-of(tmp-usu-refer.mm-referencia)
      then do:
              empty temp-table tmp-evento-fat. 
              empty temp-table tmp-evento-benef.
              empty temp-table tmp-reajuste.
              empty temp-table tmp-usu-total. 
              empty temp-table tmp-atu-usunegoc.

              /*  CONTA NUMERO DE USUARIOS ATIVOS NO MES DE REFERENCIA --- */
              run contar-usuario-ativo(input-output lg-erro-aux).
              if lg-erro-aux
              then undo, return.

              /*  -- MONTA DATAS DE REFERENCIA UTILIZADAS NOS CALCULOS --- */
              run calcula-referencias(input-output lg-erro-aux).
              if lg-erro-aux
              then undo, return.

              run cria-tmp-evento-fat(input yes, 
                                      input-output lg-erro-aux).
              if lg-erro-aux
              then undo, return.
           end.

      /* ------------ VERIFICA REGRA DE FATURAMENTO POR USUARIO ------------------*/
        for first regra-menslid-propost fields(regra-menslid-propost.cdd-regra
                                               regra-menslid-propost.dt-ini-validade)
                                        where regra-menslid-propost.cd-modalidade    = usuario.cd-modalidade
                                          and regra-menslid-propost.nr-proposta      = usuario.nr-proposta 
                                          and regra-menslid-propost.cd-usuario       = usuario.cd-usuario
                                          and regra-menslid-propost.dt-ini-validade <= dt-referencia-aux           
                                          and regra-menslid-propost.dt-fim-validade >= dt-referencia-aux no-lock: end.       

        if avail regra-menslid-propost
        then assign cdd-regra-usuario-aux = regra-menslid-propost.cdd-regra
                    dt-inicio-regra-aux   = regra-menslid-propost.dt-ini-validade.
        else assign cdd-regra-usuario-aux = cdd-regra-proposta-aux
                    dt-inicio-regra-aux   = dt-inicio-regra-prop-aux.

        assign dt-proporcao-usu-aux = usuario.dt-inclusao-plano. 
                
        /*VERIFICA RECEM NASCIDO*/
        if  ti-pl-sa.nr-dias-isento-rn <> 0 
        and usuario.dt-nascimento = usuario.dt-inclusao-plano
        then assign dt-proporcao-usu-aux = usuario.dt-inclusao-plano + ti-pl-sa.nr-dias-isento-rn.

        /* se possuir data de inclusao posterior a ao mes e ano de faturamento 
           nao considera */
        if (    month(dt-proporcao-usu-aux) >  mm-referencia-aux
            and year(dt-proporcao-usu-aux)  >= aa-referencia-aux)
        or year(dt-proporcao-usu-aux) > aa-referencia-aux
        then next.

        if  usuario.cd-sit-usuario > 10
        and usuario.dt-exclusao-plano < dt-ini-ref-aux
        then next.

        /*retorna a data de inclusao e exclusao do beneficiario*/
        run retorna-dt-inc-exc-usuario(output dt-exc-usu-aux,
                                       output dt-inc-usu-aux). 

        /*verifica suspensao mes anterior*/
        assign lg-susp-mes-anterior-aux = no. 

        for first suspusua fields (suspusua.cd-modalidade       
                                   suspusua.nr-ter-adesao       
                                   suspusua.cd-usuario          
                                   suspusua.dt-inicio-suspensao 
                                   suspusua.dt-fim-suspensao
                                   suspusua.lg-faturar)    
                           where suspusua.cd-modalidade        = propost.cd-modalidade
                             and suspusua.nr-ter-adesao        = propost.nr-ter-adesao
                             and suspusua.cd-usuario           = usuario.cd-usuario
                             and suspusua.dt-inicio-suspensao  <  date(mm-ref-aux,01,aa-ref-aux)
                             and suspusua.dt-fim-suspensao    >=  dt-ini-ref-aux 
                             and not suspusua.lg-faturar no-lock:
            assign lg-susp-mes-anterior-aux = yes.
        end.

        /*verifica suspensao mes atual*/
        assign lg-susp-mes-atual-aux = no
               dt-ref-aux = dt-inc-prog - 1. 
        for first suspusua fields (suspusua.cd-modalidade       
                                   suspusua.nr-ter-adesao       
                                   suspusua.cd-usuario          
                                   suspusua.dt-inicio-suspensao 
                                   suspusua.dt-fim-suspensao
                                   suspusua.lg-faturar)    
                           where suspusua.cd-modalidade        = propost.cd-modalidade
                             and suspusua.nr-ter-adesao        = propost.nr-ter-adesao
                             and suspusua.cd-usuario           = usuario.cd-usuario
                             and suspusua.dt-inicio-suspensao <= dt-ref-aux
                             and suspusua.dt-fim-suspensao    >= date(mm-ref-aux,01,aa-ref-aux)
                             and not suspusua.lg-faturar no-lock:
            assign lg-susp-mes-atual-aux = yes.
        end.
        
        /*leitura de classe de eventos com modulos - VALORES REFERENTES A MENSALIDADE*/
        for each tmp-evento-fat no-lock where tmp-evento-fat.lg-modulo:

            assign dt-proporcao-modulo-aux = dt-proporcao-usu-aux.

            if not tmp-evento-fat.lg-modulo-obrigatorio /*modulos opicionais*/
            then do:
                    for first usumodu fields (usumodu.cd-modalidade
                                             usumodu.nr-proposta  
                                             usumodu.cd-usuario   
                                             usumodu.cd-modulo    
                                             usumodu.dt-cancelamento
                                             usumodu.dt-inicio)
                                     where usumodu.cd-modalidade       = usuario.cd-modalidade 
                                       and usumodu.nr-proposta         = usuario.nr-proposta   
                                       and usumodu.cd-usuario          = usuario.cd-usuario    
                                       and usumodu.cd-modulo           = tmp-evento-fat.cd-modulo
                                     /*  and (   usumodu.dt-cancelamento = ? 
                                            or usumodu.dt-cancelamento > dt-ini-ref-aux) /*verificar datas*/*/ no-lock:

                        /* se a data de inicio do modulo for diferente da data de inclusao do plano do usuario 
                           e a data de inicio for maior que a data de proporcao (que pode conter dias de isencao do recem nascido)
                           entao devera assumir a data de inicio do modulo como data de proporcao)*/
                        if   usumodu.dt-inicio <> usuario.dt-inclusao-plano 
                        and  usumodu.dt-inicio > dt-proporcao-modulo-aux
                        then assign dt-proporcao-modulo-aux = usumodu.dt-inicio.
                    end.
                    if not avail usumodu
                    then next. 
                  end.

              if day(dt-proporcao-modulo-aux) = 1
              then dt-proporcao-modulo-aux = ?.

              /* 
                 Se possuir data de inclusao posterior a ao mes e ano de faturamento 
                 nao considera
                 Teste repetido pq pode ocorrer diferenca de data no modulo 
               */
              if (    month(dt-proporcao-usu-aux) >  mm-referencia-aux
                  and year(dt-proporcao-usu-aux)  >= aa-referencia-aux)
              or year(dt-proporcao-usu-aux) > aa-referencia-aux
              then next.

             /*   
                 BUSCA FAIXA ETARIA DO BENEFICIARIO
                 BUSCA VALOR DO MODULO 
                 APLICA REAJUSTE DO MODULO 
             */
             run p-faixa-etaria-modulo. 

             find first tmp-evento-benef where tmp-evento-benef.cd-usuario = usuario.cd-usuario 
                                           and tmp-evento-benef.cd-evento  = tmp-evento-fat.cd-evento
                                           and tmp-evento-benef.cd-modulo  = tmp-evento-fat.cd-modulo no-lock no-error. 

             if avail tmp-evento-benef
             then next.

             create tmp-evento-benef.
             assign tmp-evento-benef.cd-usuario          = usuario.cd-usuario
                    tmp-evento-benef.cd-grau-parentesco  = usuario.cd-grau-parentesco 
                    tmp-evento-benef.cd-modulo           = tmp-evento-fat.cd-modulo
                    tmp-evento-benef.cd-evento           = tmp-evento-fat.cd-evento
                    tmp-evento-benef.nr-faixa-etaria     = nr-faixa-etaria-atu
                    tmp-evento-benef.nr-idade-atu        = nr-idade-atu
                    tmp-evento-benef.nr-idade-ant        = nr-idade-ant
                    tmp-evento-benef.nr-idade-exc        = nr-idade-exc
                    tmp-evento-benef.nr-idade-inc        = nr-idade-inc
                    tmp-evento-benef.nr-idade-sem-reaj   = nr-idade-sem-reaj-aux
                    tmp-evento-benef.cd-sit-usuario      = usuario.cd-sit-usuario 
                    tmp-evento-benef.dt-proporcao        = dt-proporcao-modulo-aux
                    tmp-evento-benef.cd-padrao-cobertura = usuario.cd-padrao-cobertura
                    tmp-evento-benef.lg-susp-mes-ant     = lg-susp-mes-anterior-aux
                    tmp-evento-benef.aa-ult-fat          = usuario.aa-ult-fat 
                    tmp-evento-benef.mm-ult-fat          = usuario.mm-ult-fat
                    tmp-evento-benef.lg-cobra-insc       = usuario.lg-insc-fatura
                    tmp-evento-benef.ct-nova-via         = usuario.ct-nova-carteira     
                    tmp-evento-benef.ct-transf           = usuario.qt-taxa-transferencia
                    tmp-evento-benef.dt-inclusao-plano   = usuario.dt-inclusao-plano
                    tmp-evento-benef.cdd-regra           = cdd-regra-usuario-aux
                    tmp-evento-benef.dt-exclusao-plano   = usuario.dt-exclusao-plano
                    tmp-evento-benef.dt-inicio-regra     = dt-inicio-regra-aux  
                    tmp-evento-benef.lg-sem-reajuste     = if  nr-idade-sem-reaj-aux < nr-idade-atu
                                                           and nr-idade-sem-reaj-aux <> 0
                                                           then yes
                                                           else no. 

             if not tmp-api-mens-pre-pagamento.lg-geracao 
             then do:
                     if tmp-usu-refer.lg-sit-cinco = yes
                     then if can-find(first b-tmp-usu-refer where b-tmp-usu-refer.cd-usuario = usuario.cd-usuario 
                                                              and b-tmp-usu-refer.lg-processado 
                                                              and (   b-tmp-usu-refer.aa-referencia <> tmp-usu-refer.aa-referencia
                                                                   or b-tmp-usu-refer.mm-referencia <> tmp-usu-refer.mm-referencia))
                         then tmp-evento-benef.cd-sit-usuario  = 6.
                   end.
                   
             if avail usumodu
             then tmp-evento-benef.rw-usumodu = rowid(usumodu). 

             /*-------------------------------------------------------------
             * caso o usuario for repassado verifica se devera cobrar insc.
             * na tabela USUREPAS.
             *-----------------------------------------------------------*/
             if  usuario.cd-sit-usuario = 5
             and usuario.cd-unimed-destino <> 0
             then for last usurepas of usuario where usurepas.cd-unidade-destino = usuario.cd-unimed-destino no-lock:
                      assign tmp-evento-benef.lg-cobra-insc = usurepas.lg-insc-fatura.
                  end.
        end.

        /*EVENTOS QUE NAO SAO REFERENTES A MENSALIDADE - TAXAS E OUTROS*/
        for each tmp-evento-fat no-lock where not tmp-evento-fat.lg-modulo:

           /*desconsidera classes de evento que nao podem possuir valor por benef*/
           if  tmp-evento-fat.in-classe-evento <> "G"
           and tmp-evento-fat.in-classe-evento <> "Y"
           and tmp-evento-fat.in-classe-evento <> "D"
           and tmp-evento-fat.in-classe-evento <> "M"
           then next. 
           
            find first tmp-evento-benef where tmp-evento-benef.cd-usuario = usuario.cd-usuario 
                                          and tmp-evento-benef.cd-evento  = tmp-evento-fat.cd-evento no-lock no-error. 

            if avail tmp-evento-benef
            then next.

            create tmp-evento-benef.
            assign tmp-evento-benef.cd-usuario          = usuario.cd-usuario
                   tmp-evento-benef.cd-grau-parentesco  = usuario.cd-grau-parentesco 
                   tmp-evento-benef.cd-evento           = tmp-evento-fat.cd-evento
                   tmp-evento-benef.nr-faixa-etaria     = nr-faixa-etaria-atu
                   tmp-evento-benef.nr-idade-atu        = nr-idade-atu
                   tmp-evento-benef.cd-sit-usuario      = usuario.cd-sit-usuario 
                   tmp-evento-benef.cd-padrao-cobertura = usuario.cd-padrao-cobertura
                   tmp-evento-benef.lg-susp-mes-ant     = lg-susp-mes-anterior-aux
                   tmp-evento-benef.aa-ult-fat          = usuario.aa-ult-fat 
                   tmp-evento-benef.mm-ult-fat          = usuario.mm-ult-fat
                   tmp-evento-benef.lg-cobra-insc       = usuario.lg-insc-fatura
                   tmp-evento-benef.ct-nova-via         = usuario.ct-nova-carteira  
                   tmp-evento-benef.dt-inclusao-plano   = usuario.dt-inclusao-plano
                   tmp-evento-benef.dt-exclusao-plano   = usuario.dt-exclusao-plano
                   tmp-evento-benef.ct-transf           = usuario.qt-taxa-transferencia
                   tmp-evento-benef.vl-evento           = tmp-evento-fat.vl-evento.
        end.

        /*realiza calculo complementar do faturamento*/
        if last-of(tmp-usu-refer.aa-referencia)
        or last-of(tmp-usu-refer.mm-referencia)
        then do: 
                run desc-acresc-programado. 
                for each tmp-evento-benef exclusive-lock, 
                   first tmp-evento-fat where tmp-evento-fat.cd-evento = tmp-evento-benef.cd-evento 
                                          and tmp-evento-fat.cd-modulo = tmp-evento-benef.cd-modulo exclusive-lock:
                
                   /*---------------------------------------------------------
                    * se o primeiro faturamento
                    * ja foi processado entao nao necessita
                    * calcular os eventos de classe (K, L, C, O, P, Q).
                    * mensalidade proporcional e mensalidade mes anterior e
                    * inscricao
                    *---------------------------------------------------------*/
                   if  tmp-evento-benef.cd-sit-usuario > 5
                   and tmp-evento-benef.dt-proporcao   = ?
                   and (tmp-evento-fat.in-classe-evento = "K" or
                        tmp-evento-fat.in-classe-evento = "L" or
                        tmp-evento-fat.in-classe-evento = "C" or
                        tmp-evento-fat.in-classe-evento = "O" or
                        tmp-evento-fat.in-classe-evento = "P" or
                        tmp-evento-fat.in-classe-evento = "Q")
                   then next.
                
                   run p-valor-modulo.
                
                   /* ------------------------------------------------------
                    * Verifica se deve cobrar mens.integral ou proporcional
                    * caso benef.tenha sido excluido no mes do faturamento.
                    *-----------------------------------------------------*/
                   if parafatu.lg-cob-integral-exc
                   then assign lg-fat-proporc-saida = no.
                   else do:
                          if  month(tmp-evento-benef.dt-exclusao-plano) = mm-ref-aux
                          and  year(tmp-evento-benef.dt-exclusao-plano) = aa-ref-aux
                          and tmp-evento-benef.dt-exclusao-plano <> dt-limite-aux
                          then assign lg-fat-proporc-saida = yes.
                          else assign lg-fat-proporc-saida = no.
                        end. 

                   if tmp-evento-fat.in-classe-rotina = 0
                   then run value("dep/" + tmp-evento-fat.in-programa).
                   else run executa-rotina (input nm-rotinas-aux[tmp-evento-fat.in-classe-rotina]).
                end.

                for each tmp-evento-benef where tmp-evento-benef.lg-processado = no
                                             or tmp-evento-benef.vl-evento     = 0 exclusive-lock:
                    delete tmp-evento-benef. 
                end.

                /* ---- CARREGA TEMP DE IMPOSTOS DO CONTRATANTE COM ALIQUOTAS --- */
                /* --------------------------- EVENTOS QUE INCIDEM NO IMPOSTO --- */
                if not tmp-api-mens-pre-pagamento.lg-desconsidera-imposto
                then run carrega-evento-imp.
                
                run criacao-tabelas-faturamento (input yes). 
            end.
  end.
end procedure.

procedure api-mens-pre-pagamento:
    def input-output  parameter table for tmp-api-mens-pre-pagamento.
    def input-output  parameter table for w-fatmen.
    def input-output  parameter table for w-fateve.
    def input-output  parameter table for w-fatgrau.
    def input-output  parameter table for w-fatgrun.
    def input-output  parameter table for w-vlbenef.
    def input-output  parameter table for w-fatsemreaj.
    def       output  parameter table for rowErrors.

    run limpa-variaveis.

    empty temp-table tmp-evento-fat. 
    empty temp-table tmp-evento-benef.
    empty temp-table tmp-reajuste.
    empty temp-table tmp-usu-total. 
    empty temp-table tmp-atu-usunegoc.
    empty temp-table rowErrors.

    run validacoes-iniciais-faturamento-normal (output lg-erro-aux).

    if lg-erro-aux
    then undo, return.

    run cria-tmp-evento-fat(input no, 
                            input-output lg-erro-aux).
    if lg-erro-aux
    then undo, return.
          
    run rotinas-especificas(output lg-erro-aux).

    if lg-erro-aux
    then undo, return.
   
    /*
      VERIFICA FATORES DE DESCONTO E ACRESCIMO DA PROPOSTA.
    */
    run ver-perc-prop.

    /* 
      VERIFICA A QUANTIDADE DE MESES FATURADOS
    */
    run calcula-meses-faturados.

    for each usuario 
                     where usuario.cd-modalidade = propost.cd-modalidade
                       and usuario.nr-proposta   = propost.nr-proposta
                       and usuario.cd-sit-usuario  > 04
                       and usuario.cd-sit-usuario <> 10
                       and usuario.cd-sit-usuario <> 08
                       and usuario.cd-sit-usuario <> 09
                  no-lock:
        run cria-tmp-evento-benef.
    end.

    run desc-acresc-programado. 
    
    for each tmp-evento-benef exclusive-lock, 
        first tmp-evento-fat where tmp-evento-fat.cd-evento = tmp-evento-benef.cd-evento 
                               and tmp-evento-fat.cd-modulo = tmp-evento-benef.cd-modulo exclusive-lock:

        /*---------------------------------------------------------
         * se o primeiro faturamento
         * ja foi processado entao nao necessita
         * calcular os eventos de classe (K, L, C, O, P, Q).
         * mensalidade proporcional e mensalidade mes anterior e
         * inscricao
         *---------------------------------------------------------*/
        if  tmp-evento-benef.cd-sit-usuario > 5
        and tmp-evento-benef.dt-proporcao   = ?
        and (tmp-evento-fat.in-classe-evento = "K" or
             tmp-evento-fat.in-classe-evento = "L" or
             tmp-evento-fat.in-classe-evento = "C" or
             tmp-evento-fat.in-classe-evento = "O" or
             tmp-evento-fat.in-classe-evento = "P" or
             tmp-evento-fat.in-classe-evento = "Q")
        then next.

        run p-valor-modulo.

        /* ------------------------------------------------------
         * Verifica se deve cobrar mens.integral ou proporcional
         * caso benef.tenha sido excluido no mes do faturamento.
         *-----------------------------------------------------*/
        if parafatu.lg-cob-integral-exc
        then assign lg-fat-proporc-saida = no.
        else do:
               if  month(tmp-evento-benef.dt-exclusao-plano) = mm-ref-aux
               and  year(tmp-evento-benef.dt-exclusao-plano) = aa-ref-aux
               and tmp-evento-benef.dt-exclusao-plano <> dt-limite-aux
               then assign lg-fat-proporc-saida = yes.
               else assign lg-fat-proporc-saida = no.
             end. 

         put unform nm-rotinas-aux[tmp-evento-fat.in-classe-rotina] format "x(25)" skip.
                                                                       
        if tmp-evento-fat.in-classe-rotina = 0
        then run value("dep/" + tmp-evento-fat.in-programa).
        else run executa-rotina (input nm-rotinas-aux[tmp-evento-fat.in-classe-rotina]).
    end.

    run processa-eventos-totais(input "H"). /*ACRESCIMOS*/
    run processa-eventos-totais(input "I"). /*DESCONTOS*/
    run processa-eventos-totais(input "J"). /*OUTROS*/
    run processa-eventos-totais(input "R"). /*EVENTO PROGRAMADO - PERCENTUAL*/
    run processa-eventos-totais(input "M"). /*EVENTO PROGRAMADO - VALOR*/
    run processa-eventos-totais(input "S"). /*EVENTO PROGRAMADO - PERCENTUAL SOBRE EVENTO*/


    for each tmp-evento-benef where tmp-evento-benef.lg-processado = no
                                 or tmp-evento-benef.vl-evento     = 0 exclusive-lock:
        delete tmp-evento-benef. 
    end.

    /* --------------------- DESCONTO MENSALIDADE --- */
    run rtp/rtregrasdesc.p(input  propost.cd-modalidade,
                           input  propost.nr-ter-adesao,
                           input  dt-emissao-aux,
                           input  cd-contratante-aux,
                           input  aa-ref-aux,
                           input  mm-ref-aux,
                           output cd-evento-desconto-aux,
                           output lg-desconto-aux,
                           output table tmp-usu-desconto, 
                           output table tmp-event-desc-menslid).

    if lg-desconto-aux
    then run aplica-desconto-usuario. 
                                 
    /* ---- CARREGA TEMP DE IMPOSTOS DO CONTRATANTE COM ALIQUOTAS --- */
    /* --------------------------- EVENTOS QUE INCIDEM NO IMPOSTO --- */
    if not tmp-api-mens-pre-pagamento.lg-desconsidera-imposto
    then run carrega-evento-imp.
    
    run criacao-tabelas-faturamento (input no). 
end procedure.

procedure validacoes-iniciais-faturamento-normal:
    def output parameter lg-erro-par as log no-undo. 

    find first tmp-api-mens-pre-pagamento no-lock no-error.

    if not avail tmp-api-mens-pre-pagamento
    then do:
           run insertErrorGP(input 01015,
                             input "Temp-Table : tmp-api-mens-pre-pagamento",
                             input "",
                             input-output table rowErrors).
            assign lg-erro-par = yes.
            return.
         end.

    find first paramecp no-lock no-error.

    if not avail paramecp
    then do:
           run insertErrorGP(input 0006,
                             input "Empresa: " + tmp-api-mens-pre-pagamento.ep-codigo,
                             input "",
                             input-output table rowErrors).
            assign lg-erro-par = yes.
            return.
         end.

    find parafatu use-index parafat1
         where parafatu.ep-codigo = tmp-api-mens-pre-pagamento.ep-codigo
               no-lock no-error.

    if not avail parafatu
    then do:
            run insertErrorGP(input 01665,
                              input "Empresa: " + tmp-api-mens-pre-pagamento.ep-codigo,
                              input "",
                              input-output table rowErrors).
            assign lg-erro-par = yes.
            return.
         end.


    run valida-contrato(output lg-erro-par).

    if lg-erro-par
    then return.

    assign ep-codigo-aux           = propost.ep-codigo
           cod-estabel-aux         = propost.cod-estabel
           cd-modalidade-aux       = propost.cd-modalidade
           nr-ter-ade-aux          = propost.nr-ter-adesao
           cd-tipo-vencimento-aux  = propost.cd-tipo-vencimento
           dd-vencimento-aux       = propost.dd-vencimento
           pc-acrescimo-aux        = propost.pc-acrescimo     
           pc-desconto-aux         = propost.pc-desconto      
           pc-acrescimo-insc-aux   = propost.pc-acrescimo-insc
           pc-desconto-insc-aux    = propost.pc-desconto-insc 
           pc-desc-prom-pl-aux     = propost.pc-desc-prom-pl.
    
    
    run valida-contratante(output cd-contratante-aux,
                           output cd-contratante-origem-aux,
                           output lg-erro-par).
    
    if lg-erro-par
    then return.

    run valida-estrutura-proposta(output lg-erro-par).

    if lg-erro-par
    then return.

    run mes-ano-base(output aa-ref-aux,
                     output mm-ref-aux,
                     output lg-erro-par).
    if lg-erro-par
    then return.

    assign mm-referencia-aux = mm-ref-aux
           aa-referencia-aux = aa-ref-aux
           dt-emissao-aux    = tmp-api-mens-pre-pagamento.dt-emissao
           dt-vencimento-aux = tmp-api-mens-pre-pagamento.dt-vencimento
           dt-referencia-aux = date(mm-ref-aux, 01, aa-ref-aux).

    run valida-emissao-vencimento(input-output dt-emissao-aux,
                                  input-output dt-vencimento-aux,
                                        output lg-erro-par).

    if lg-erro-par
    then return.

    run trata-faturamento-periodico(input aa-ref-aux,
                                    input mm-ref-aux,
                                    output lg-erro-par).

    if lg-erro-par
    then return.

    run encontra-prox-faturamento(output aa-prox-fat-aux,
                                  output mm-prox-fat-aux,
                                  output lg-erro-par).
    if lg-erro-par
    then return.

    assign dt-ref-ant-aux = date(mm-ref-aux,01,aa-ref-aux) - 1
           dt-ref-exc     = date(mm-ref-aux,01,aa-ref-aux) - 1. 

    if mm-ref-aux <> 01
    then assign dt-ini-ref-aux = date(mm-ref-aux - 1 ,01,aa-ref-aux).
    else assign dt-ini-ref-aux = date(12 ,01,aa-ref-aux - 1 ).

    if mm-ref-aux = 12
    then dt-inc-prog = date(01,01,aa-ref-aux + 1).
    else dt-inc-prog = date(mm-ref-aux + 1, 01, aa-ref-aux).

    run rtp/rtultdia.p (aa-ref-aux, mm-ref-aux, output dt-limite-aux).

    if mm-ref-aux <> 01
    then assign dt-ref-pro-aux = date(mm-ref-aux - 1 ,01,aa-ref-aux) - 1.
    else assign dt-ref-pro-aux = date(12 ,01,aa-ref-aux - 1 ) - 1.

    if  ter-ade.aa-ult-fat > aa-ref-aux 
    or (    ter-ade.aa-ult-fat  = aa-ref-aux 
        and ter-ade.mm-ult-fat >= mm-ref-aux)
    then do:
            run insertErrorGP(input 1675,
                              input "Periodo ja faturado",
                              input "",
                              input-output table rowErrors).
            assign lg-erro-par = yes.
            return. 
         end.

    

    if tmp-api-mens-pre-pagamento.lg-verif-fat-complementar
    then do:
            for first usuario fields (usuario.cd-usuario)
                              where usuario.cd-sit-usuario = 5
                                and usuario.cd-modalidade  = ter-ade.cd-modalidade
                                and usuario.nr-ter-adesao  = ter-ade.nr-ter-adesao
                                and (      year (usuario.dt-inclusao-plano) < ter-ade.aa-ult-fat
                                      or  (year (usuario.dt-inclusao-plano)  = ter-ade.aa-ult-fat
                                        and month(usuario.dt-inclusao-plano) <= ter-ade.mm-ult-fat)): end.
            if avail usuario 
            then do:
                    run insertErrorGP(input 35,
                                      input "Termo nao teve nota gerada porque possui mensalidade complementar nao calculada",
                                      input "",
                                      input-output table rowErrors).
                    assign lg-erro-par = yes.
                    return. 
                 end.
         end.

    if not tmp-api-mens-pre-pagamento.lg-calc-apos-fim-termo
    then do:
             if date(month(ter-ade.dt-fim),01,year(ter-ade.dt-fim)) < date(mm-ref-aux,01,aa-ref-aux)
             then do:
                     run insertErrorGP(input 1643,
                                       input "Data final do termo de adesao -" +   string(ter-ade.dt-fim,"99/99/9999"),
                                       input "",
                                       input-output table rowErrors).
                     assign lg-erro-par = yes.
                     return. 
                  end.
         end.

end procedure.
procedure cria-tmp-evento-fat:
  def input        parameter lg-fat-complementar-par  as log              no-undo.
  def input-output parameter lg-erro-par              as log              no-undo.

  /*------------------ BUSCA REGRA DE MENSALIDADE DA PROPOSTA*/
   run busca-regra-mensalidade (output cdd-regra-proposta-aux,
                                output dt-inicio-regra-prop-aux). 
   if cdd-regra-proposta-aux = 0
   then do:
           assign lg-erro-par = yes.
           run insertOtherError(input 0,
                                input "Nao existe regra de mensalidade cadastrada para a proposta: " +
                                      "Modalidade - "  + string(propost.cd-modalidade) +
                                      " Plano - "      + string(propost.cd-plano)      +
                                      " Tipo Plano - " + string(propost.cd-tipo-plano),
                                input "",
                                input "GP",
                                input "E",
                                input "",
                                input-output table rowErrors).
           return.
        end.

  /* CRIA TEMPORARIA COM PERCENTUAIS DE REAJUSTE A NIVEL DE CONTRATO*/
  run verifica-reajuste-contrato.

  /*
    CRIA TABELA TEMPORARIA COM MODULOS E ROTINAS DE CALCULO POR USUARIO.
    ATRIBUI VALOR DE TAXA DE TRANSFERENCIA E NOVA VIA DE CARTEIRA. 
  */
  for each tipleven
      where tipleven.in-entidade    = "FT"
        and tipleven.cd-modalidade  = propost.cd-modalidade
        and tipleven.cd-plano       = propost.cd-plano
        and tipleven.cd-tipo-plano  = propost.cd-tipo-plano
        and tipleven.cd-forma-pagto = propost.cd-forma-pagto             
        and tipleven.lg-ativo,
      first evenfatu where evenfatu.in-entidade      = "FT"
                       and evenfatu.cd-evento        = tipleven.cd-evento no-lock:

      put unform skip. 
      put unform "tipleven" tipleven.cd-evento " stautus". 
                             

      if evenfatu.in-classe-evento = "E"
      or evenfatu.in-classe-evento = "U" 
      or evenfatu.in-classe-evento = "1" 
      or evenfatu.in-classe-evento = "2" 
      or evenfatu.in-classe-evento = "3"
      then next.

      if lg-fat-complementar-par 
      then if not tipleven.lg-automatico
           or not tipleven.lg-ind-usu
           then next.

      assign lg-modulo-agregado-aux    = no
             lg-modulo-obrigatorio-aux = no.

      if tipleven.cd-modulo <> 0
      then do:
             put unform "1".

              for first pla-mod fields (pla-mod.cd-modalidade 
                                        pla-mod.cd-plano      
                                        pla-mod.cd-tipo-plano 
                                        pla-mod.cd-modulo     
                                        pla-mod.lg-modulo-agregado)
                                where pla-mod.cd-modalidade = tipleven.cd-modalidade
                                  and pla-mod.cd-plano      = tipleven.cd-plano      
                                  and pla-mod.cd-tipo-plano = tipleven.cd-tipo-plano 
                                  and pla-mod.cd-modulo     = tipleven.cd-modulo no-lock:
                  assign lg-modulo-agregado-aux = pla-mod.lg-modulo-agregado.
              end.


              if not avail pla-mod 
              then next. 

              put unform "2".

              for first pro-pla  fields ( pro-pla.cd-modalidade  
                                          pro-pla.nr-proposta    
                                          pro-pla.cd-modulo      
                                          pro-pla.dt-cancelament
                                          pro-pla.dt-inicio     
                                          pro-pla.lg-cobertura-obrigatoria)
                  where pro-pla.cd-modalidade    = propost.cd-modalidade
                    and pro-pla.nr-proposta      = propost.nr-proposta
                    and pro-pla.cd-modulo        = tipleven.cd-modulo
                    and (pro-pla.dt-cancelamento = ? or pro-pla.dt-cancelamento >= dt-limite-aux )
                    and (pro-pla.dt-inicio       < dt-inc-prog or pro-pla.dt-inicio  = ?) no-lock:

                  assign lg-modulo-obrigatorio-aux = pro-pla.lg-cobertura-obrigatoria.
              end.


              if not avail pro-pla
              then next.

              put unform "3".
           end.

          
      /*------- VERIFICA PERCENTUAL DO EVENTO SOMENTE SE O EVENTO ABRI POR PROPORCAO ---- */
      assign lg-tem-percevento = no.
      
      if tipleven.lg-prop-pa
      then run rtp/rtpercevento.p(input  tipleven.cd-modalidade,
                                  input  tipleven.cd-plano,
                                  input  tipleven.cd-tipo-plano,
                                  input  tipleven.cd-forma-pagto,
                                  input  tipleven.cd-evento,
                                  input  aa-ref-aux,
                                  input  mm-ref-aux,
                                  input  dt-emissao-aux,
                                  output lg-tem-percevento,
                                  output pc-prop-evento-aux).
                                  
      /* ------------------------------------------ CONTA CONTABIL --- */
      run rtp/rtct-contabeis.p(input  tipleven.cd-modalidade,
                               input  tipleven.cd-plano,
                               input  tipleven.cd-tipo-plano,
                               input  tipleven.cd-forma-pagto,
                               input  tipleven.in-entidade,
                               input  tipleven.cd-evento,
                               input  tipleven.cd-modulo,
                               input  year(dt-emissao-aux),
                               input  month(dt-emissao-aux),
                               input  0,
                               input  "",
                               input  ?,
                               input  propost.in-tipo-contratacao,
                               input  0,
                               output lg-ct-contabil-aux,
                               output ct-codigo-aux,
                               output sc-codigo-aux,
                               output ct-codigo-dif-aux,
                               output sc-codigo-dif-aux,
                               output ct-codigo-dif-neg-aux,
                               output sc-codigo-dif-neg-aux,
                               output lg-evencontde-aux).
                              
      if not lg-ct-contabil-aux
      then do:
             assign lg-erro-par = yes.

             run insertOtherError(input 2318,
                                  input "Conta contabil nao esta ativa no periodo. "
                                        + "Mod.: "     + string(tipleven.cd-modalidade,"99")
                                        + " Pl:  "     + string(tipleven.cd-plano,"99")
                                        + " Tp.Pl: "   + string(tipleven.cd-tipo-plano,"99")
                                        + " F.Pagto: " + string(tipleven.cd-forma-pagto,"99")
                                        + " Eve: "     + string(tipleven.cd-evento,">>9")
                                        + " Modulo: "  + string(tipleven.cd-modulo,"999"),
                                  input "",
                                  input "GP",
                                  input "E",
                                  input "",
                                  input-output table rowErrors).
              return.        
           end. 

      put unform "criou" skip. 
        
      create tmp-evento-fat.
      assign tmp-evento-fat.cd-modulo             = tipleven.cd-modulo
             tmp-evento-fat.cd-rotina             = tipleven.cd-rotina
             tmp-evento-fat.cd-evento             = tipleven.cd-evento
             tmp-evento-fat.ct-codigo             = ct-codigo-aux
             tmp-evento-fat.sc-codigo             = sc-codigo-aux
             tmp-evento-fat.cd-especie            = tiplesp.cd-especie-pre
             tmp-evento-fat.lg-valor              = tipleven.lg-valor  
             tmp-evento-fat.pc-princ-aux          = if lg-tem-percevento 
                                                    then pc-prop-evento-aux
                                                    else tipleven.pc-princ-aux
             tmp-evento-fat.lg-modulo-agregado    = lg-modulo-agregado-aux
             tmp-evento-fat.lg-prop-evento        = lg-tem-percevento
             tmp-evento-fat.lg-modulo             = evenfatu.lg-modulo
             tmp-evento-fat.lg-cred-deb           = evenfatu.lg-cred-deb
             tmp-evento-fat.lg-destacado          = evenfatu.lg-destacado
             tmp-evento-fat.in-classe-evento      = evenfatu.in-classe-evento
             tmp-evento-fat.lg-modulo-obrigatorio = lg-modulo-obrigatorio-aux. 

      for first roticalc fields (roticalc.in-entidade 
                                 roticalc.cd-rotina   
                                 in-programa     
                                 in-classe-rotina)
                         where roticalc.in-entidade = "FT"
                           and roticalc.cd-rotina   = tipleven.cd-rotina no-lock:

          assign tmp-evento-fat.in-programa      = roticalc.in-programa
                 tmp-evento-fat.in-classe-rotina = roticalc.in-classe-rotina.
      end.

      if not available roticalc
      then do:
              assign lg-erro-par = yes.
         
              run insertOtherError(input 0,
                                   input "A Rotina de Calculo foi eliminada: " + string(tipleven.cd-rotina),
                                   input "",
                                   input "GP",
                                   input "E",
                                   input "",
                                   input-output table rowErrors).
              return. 
           end.


      /*---------------------------- evento de taxa de transferencia ---*/
      if evenfatu.in-classe-evento = "Y"
      then do:
             for first proptxtr fields(proptxtr.cd-modalidade 
                                       proptxtr.nr-proposta
                                       proptxtr.dt-limite
                                       proptxtr.vl-taxa-transferencia)
                               where proptxtr.cd-modalidade = propost.cd-modalidade        
                                 and proptxtr.nr-proposta   = propost.nr-proposta          
                                 and proptxtr.dt-limite    >= dt-limite-aux  no-lock:
                 assign tmp-evento-fat.vl-evento-cart-nv = proptxtr.vl-taxa-transferencia.
             end.

             if not avail proptxtr
             then for first taxatrfp fields (taxatrfp.cd-modalidade 
                                             taxatrfp.cd-plano      
                                             taxatrfp.cd-tipo-plano 
                                             taxatrfp.cd-forma-pagto
                                             taxatrfp.dt-limite     
                                             taxatrfp.vl-taxa-transferencia)
                                    where taxatrfp.cd-modalidade  = propost.cd-modalidade               
                                      and taxatrfp.cd-plano       = propost.cd-plano                    
                                      and taxatrfp.cd-tipo-plano  = propost.cd-tipo-plano               
                                      and taxatrfp.cd-forma-pagto = propost.cd-forma-pagto              
                                      and taxatrfp.dt-limite     >= dt-limite-aux  no-lock:
                      assign tmp-evento-fat.vl-evento-cart-nv = taxatrfp.vl-taxa-transferencia.
                  end.
           end.
      /*----------------------------------------------------------------*/
      if  evenfatu.cd-evento = parafatu.cd-evento-via-carteira
      then /* ACESSA PROPCART P/ BUSCAR VALOR NOVA VIA CARTEIRA */
             for first propcart fields (propcart.cd-modalidade
                                        propcart.nr-proposta  
                                        propcart.dt-limite  
                                        propcart.qt-moeda-nova-via)
                               where propcart.cd-modalidade = propost.cd-modalidade
                                 and propcart.nr-proposta   = propost.nr-proposta
                                 and propcart.dt-limite    >= dt-limite-aux no-lock:
                  assign tmp-evento-fat.vl-evento-cart-nv =  propcart.qt-moeda-nova-via.
             end.

      /*CRIA TEMPORARIA COM PERCENTUAIS DE REAJUSTE A NIVEL DE MODULO*/
      if tipleven.cd-modulo <> 0
      then run verifica-reajuste-modulo.
  end.

  if not can-find (first tmp-evento-fat no-lock)
  then do:    
          assign lg-erro-par = yes.
          run insertOtherError(input 0,
                               input "Nao existem eventos para a : "                  +
                                     "Modalidade - "  + string(propost.cd-modalidade) +
                                     " Plano - "      + string(propost.cd-plano)      +
                                     " Tipo Plano - " + string(propost.cd-tipo-plano),
                               input "",
                               input "GP",
                               input "E",
                               input "",
                               input-output table rowErrors).
          return. 
       end.
end procedure.

procedure cria-tmp-evento-benef:

    put unform skip. 

    put unform usuario.cd-usuario.

    /*--------------------------------------
    * desconsidera beneficiarios excluidos
    * a mais de 95 dias
    *--------------------------------------*/
    if  usuario.dt-exclusao-plano <> ?
    and usuario.dt-exclusao-plano < date(mm-ref-aux,01,aa-ref-aux) - 95
    then return.

    
    put unform '-A'.
    /* ------------ VERIFICA REGRA DE FATURAMENTO POR USUARIO ------------------*/
   for first regra-menslid-propost fields(regra-menslid-propost.cdd-regra
                                          regra-menslid-propost.dt-ini-validade)
                                   where regra-menslid-propost.cd-modalidade    = usuario.cd-modalidade
                                     and regra-menslid-propost.nr-proposta      = usuario.nr-proposta 
                                     and regra-menslid-propost.cd-usuario       = usuario.cd-usuario
                                     and regra-menslid-propost.dt-ini-validade <= dt-referencia-aux           
                                     and regra-menslid-propost.dt-fim-validade >= dt-referencia-aux no-lock: end.       

    if avail regra-menslid-propost
    then assign cdd-regra-usuario-aux = regra-menslid-propost.cdd-regra
                dt-inicio-regra-aux   = regra-menslid-propost.dt-ini-validade.
    else assign cdd-regra-usuario-aux = cdd-regra-proposta-aux
                dt-inicio-regra-aux   = dt-inicio-regra-prop-aux.

    assign dt-proporcao-usu-aux = usuario.dt-inclusao-plano. 
            
    put unform dt-proporcao-usu-aux.

    /*VERIFICA RECEM NASCIDO*/
    if  ti-pl-sa.nr-dias-isento-rn <> 0 
    and usuario.dt-nascimento = usuario.dt-inclusao-plano
    then assign dt-proporcao-usu-aux = usuario.dt-inclusao-plano + ti-pl-sa.nr-dias-isento-rn.

     put unform dt-proporcao-usu-aux.

    /* se possuir data de inclusao posterior a ao mes e ano de faturamento 
       nao considera */
    if (    month(dt-proporcao-usu-aux) >  mm-referencia-aux
        and year(dt-proporcao-usu-aux)  >= aa-referencia-aux)
    or year(dt-proporcao-usu-aux) > aa-referencia-aux
    then return.


    put unform '-B'.
    if  usuario.cd-sit-usuario > 10
    and usuario.dt-exclusao-plano < dt-ini-ref-aux
    then return.

    /*retorna a data de inclusao e exclusao do beneficiario*/
    run retorna-dt-inc-exc-usuario(output dt-exc-usu-aux,
                                   output dt-inc-usu-aux). 

    /*verifica suspensao mes anterior*/
    assign lg-susp-mes-anterior-aux = no. 

    for first suspusua fields (suspusua.cd-modalidade       
                               suspusua.nr-ter-adesao       
                               suspusua.cd-usuario          
                               suspusua.dt-inicio-suspensao 
                               suspusua.dt-fim-suspensao
                               suspusua.lg-faturar)    
                       where suspusua.cd-modalidade        = propost.cd-modalidade
                         and suspusua.nr-ter-adesao        = propost.nr-ter-adesao
                         and suspusua.cd-usuario           = usuario.cd-usuario
                         and suspusua.dt-inicio-suspensao  <  date(mm-ref-aux,01,aa-ref-aux)
                         and suspusua.dt-fim-suspensao    >=  dt-ini-ref-aux 
                         and not suspusua.lg-faturar no-lock:
        assign lg-susp-mes-anterior-aux = yes.
    end.

    /*verifica suspensao mes atual*/
    assign lg-susp-mes-atual-aux = no
           dt-ref-aux = dt-inc-prog - 1. 
    for first suspusua fields (suspusua.cd-modalidade       
                               suspusua.nr-ter-adesao       
                               suspusua.cd-usuario          
                               suspusua.dt-inicio-suspensao 
                               suspusua.dt-fim-suspensao
                               suspusua.lg-faturar)    
                       where suspusua.cd-modalidade        = propost.cd-modalidade
                         and suspusua.nr-ter-adesao        = propost.nr-ter-adesao
                         and suspusua.cd-usuario           = usuario.cd-usuario
                         and suspusua.dt-inicio-suspensao <= dt-ref-aux
                         and suspusua.dt-fim-suspensao    >= date(mm-ref-aux,01,aa-ref-aux)
                         and not suspusua.lg-faturar no-lock:
        assign lg-susp-mes-atual-aux = yes.
    end.
    /*todo - contadores na suspensao*/

   put unform '-C'.
    /*leitura de classe de eventos com modulos - VALORES REFERENTES A MENSALIDADE*/
    for each tmp-evento-fat no-lock where tmp-evento-fat.lg-modulo:

        put unform '-D'.
        assign dt-proporcao-modulo-aux = dt-proporcao-usu-aux.

        if not tmp-evento-fat.lg-modulo-obrigatorio /*modulos opicionais*/
        then do:
                for first usumodu fields (usumodu.cd-modalidade
                                         usumodu.nr-proposta  
                                         usumodu.cd-usuario   
                                         usumodu.cd-modulo    
                                         usumodu.dt-cancelamento
                                         usumodu.dt-inicio)
                                 where usumodu.cd-modalidade       = usuario.cd-modalidade 
                                   and usumodu.nr-proposta         = usuario.nr-proposta   
                                   and usumodu.cd-usuario          = usuario.cd-usuario    
                                   and usumodu.cd-modulo           = tmp-evento-fat.cd-modulo
                                 /*  and (   usumodu.dt-cancelamento = ? 
                                        or usumodu.dt-cancelamento > dt-ini-ref-aux) /*verificar datas*/*/ no-lock:

                    /* se a data de inicio do modulo for diferente da data de inclusao do plano do usuario 
                       e a data de inicio for maior que a data de proporcao (que pode conter dias de isencao do recem nascido)
                       entao devera assumir a data de inicio do modulo como data de proporcao)*/
                    if   usumodu.dt-inicio <> usuario.dt-inclusao-plano 
                    and  usumodu.dt-inicio > dt-proporcao-modulo-aux
                    then assign dt-proporcao-modulo-aux = usumodu.dt-inicio.
                end.

                put unform 'a'.
                if not avail usumodu
                then next. 
                put unform 'b'.
              end.

          if day(dt-proporcao-modulo-aux) = 1
          then dt-proporcao-modulo-aux = ?.

          /* 
             Se possuir data de inclusao posterior a ao mes e ano de faturamento 
             nao considera
             Teste repetido pq pode ocorrer diferenca de data no modulo 
           */
          if (    month(dt-proporcao-usu-aux) >  mm-referencia-aux
              and year(dt-proporcao-usu-aux)  >= aa-referencia-aux)
          or year(dt-proporcao-usu-aux) > aa-referencia-aux
          then next.

         /*   
             BUSCA FAIXA ETARIA DO BENEFICIARIO
             BUSCA VALOR DO MODULO 
             APLICA REAJUSTE DO MODULO 
         */
         run p-faixa-etaria-modulo. 

         put unform '-E'.

         find first tmp-evento-benef where tmp-evento-benef.cd-usuario = usuario.cd-usuario 
                                       and tmp-evento-benef.cd-evento  = tmp-evento-fat.cd-evento
                                       and tmp-evento-benef.cd-modulo  = tmp-evento-fat.cd-modulo no-lock no-error. 

         if avail tmp-evento-benef
         then next.

         create tmp-evento-benef.
         assign tmp-evento-benef.cd-usuario          = usuario.cd-usuario
                tmp-evento-benef.cd-grau-parentesco  = usuario.cd-grau-parentesco 
                tmp-evento-benef.cd-modulo           = tmp-evento-fat.cd-modulo
                tmp-evento-benef.cd-evento           = tmp-evento-fat.cd-evento
                tmp-evento-benef.nr-faixa-etaria     = nr-faixa-etaria-atu
                tmp-evento-benef.nr-idade-atu        = nr-idade-atu
                tmp-evento-benef.nr-idade-ant        = nr-idade-ant
                tmp-evento-benef.nr-idade-exc        = nr-idade-exc
                tmp-evento-benef.nr-idade-inc        = nr-idade-inc
                tmp-evento-benef.nr-idade-sem-reaj   = nr-idade-sem-reaj-aux
                tmp-evento-benef.cd-sit-usuario      = usuario.cd-sit-usuario 
                tmp-evento-benef.dt-proporcao        = dt-proporcao-modulo-aux
                tmp-evento-benef.cd-padrao-cobertura = usuario.cd-padrao-cobertura
                tmp-evento-benef.lg-susp-mes-ant     = lg-susp-mes-anterior-aux
                tmp-evento-benef.aa-ult-fat          = usuario.aa-ult-fat 
                tmp-evento-benef.mm-ult-fat          = usuario.mm-ult-fat
                tmp-evento-benef.lg-cobra-insc       = usuario.lg-insc-fatura
                tmp-evento-benef.ct-nova-via         = usuario.ct-nova-carteira     
                tmp-evento-benef.ct-transf           = usuario.qt-taxa-transferencia
                tmp-evento-benef.dt-inclusao-plano   = usuario.dt-inclusao-plano
                tmp-evento-benef.cdd-regra           = cdd-regra-usuario-aux
                tmp-evento-benef.dt-inicio-regra     = dt-inicio-regra-aux  
                tmp-evento-benef.dt-exclusao-plano   = usuario.dt-exclusao-plano
                tmp-evento-benef.lg-sem-reajuste     = if  nr-idade-sem-reaj-aux < nr-idade-atu
                                                       and nr-idade-sem-reaj-aux <> 0
                                                       then yes
                                                       else no. 

         if avail usumodu
         then tmp-evento-benef.rw-usumodu = rowid(usumodu). 

         /*-------------------------------------------------------------
         * caso o usuario for repassado verifica se devera cobrar insc.
         * na tabela USUREPAS.
         *-----------------------------------------------------------*/
         if  usuario.cd-sit-usuario = 5
         and usuario.cd-unimed-destino <> 0
         then for last usurepas of usuario where usurepas.cd-unidade-destino = usuario.cd-unimed-destino no-lock:
                  assign tmp-evento-benef.lg-cobra-insc = usurepas.lg-insc-fatura.
              end.
    end.

    /*EVENTOS QUE NAO SAO REFERENTES A MENSALIDADE - TAXAS E OUTROS*/
    for each tmp-evento-fat no-lock where not tmp-evento-fat.lg-modulo:

       /*desconsidera classes de evento que nao podem possuir valor por benef*/
       if  tmp-evento-fat.in-classe-evento <> "G"
       and tmp-evento-fat.in-classe-evento <> "Y"
       and tmp-evento-fat.in-classe-evento <> "D"
       and tmp-evento-fat.in-classe-evento <> "M"
       then next. 
       
        find first tmp-evento-benef where tmp-evento-benef.cd-usuario = usuario.cd-usuario 
                                      and tmp-evento-benef.cd-evento  = tmp-evento-fat.cd-evento no-lock no-error. 

        if avail tmp-evento-benef
        then next.

        create tmp-evento-benef.
        assign tmp-evento-benef.cd-usuario          = usuario.cd-usuario
               tmp-evento-benef.cd-grau-parentesco  = usuario.cd-grau-parentesco 
               tmp-evento-benef.cd-evento           = tmp-evento-fat.cd-evento
               tmp-evento-benef.nr-faixa-etaria     = nr-faixa-etaria-atu
               tmp-evento-benef.nr-idade-atu        = nr-idade-atu
               tmp-evento-benef.cd-sit-usuario      = usuario.cd-sit-usuario 
               tmp-evento-benef.cd-padrao-cobertura = usuario.cd-padrao-cobertura
               tmp-evento-benef.lg-susp-mes-ant     = lg-susp-mes-anterior-aux
               tmp-evento-benef.aa-ult-fat          = usuario.aa-ult-fat 
               tmp-evento-benef.mm-ult-fat          = usuario.mm-ult-fat
               tmp-evento-benef.lg-cobra-insc       = usuario.lg-insc-fatura
               tmp-evento-benef.ct-nova-via         = usuario.ct-nova-carteira  
               tmp-evento-benef.dt-inclusao-plano   = usuario.dt-inclusao-plano
               tmp-evento-benef.dt-exclusao-plano   = usuario.dt-exclusao-plano
               tmp-evento-benef.ct-transf           = usuario.qt-taxa-transferencia
               tmp-evento-benef.vl-evento           = tmp-evento-fat.vl-evento.

    end.

    /*CONTA USUARIOS ATIVOS*/
    if  (usuario.dt-exclusao-plano  = ?
    or   usuario.dt-exclusao-plano  > dt-ref-ant-aux)
    and  usuario.dt-exclusao-plano <> usuario.dt-inclusao-plano 
    and string(year(usuario.dt-inclusao-plano),"9999") + string(month(usuario.dt-inclusao-plano),"99") <= string(aa-ref-aux,"9999") + string(mm-ref-aux,"99")
    then assign qt-usu-aux = qt-usu-aux + 1.
end procedure.

procedure rotinas-especificas:
    def output parameter lg-erro-par as log           no-undo. 

     /*
      PROCESSA ROTINA DE CALCULO ESPECIFICA
    */ 
    for each tmp-evento-fat where tmp-evento-fat.in-classe-rotina = 0 no-lock
                            break by tmp-evento-fat.in-programa:


        if search("dep/" + tmp-evento-fat.in-programa) = ?
        then do:
                run insertOtherError(input 0,
                                     input "Rotina " + tmp-evento-fat.in-programa + " nao encontrada no Diretorio. "
                                           + "Comunique o Responsavel pelo Sistema",
                                     input "",
                                     input "GP",
                                     input "E",
                                     input "",
                                     input-output table rowErrors).
                assign lg-erro-par = yes.
                return.
             end.

        run value("dep/" + tmp-evento-fat.in-programa) no-error.


        if  error-status:error
        and error-status:num-messages > 0
        then do:
               assign ds-mensagem-aux = substr(error-status:get-message
                                        (error-status:num-messages),1,72).

               run insertOtherError(input 0,
                                    input "Nao foi possivel executar a Rotina " + tmp-evento-fat.in-programa 
                                          + "para o evento" + string(tmp-evento-fat.cd-evento) + "Comunique o Responsavel pelo Sistema." 
                                          + " ERRO: " + ds-mensagem-aux,
                                    input "",
                                    input "GP",
                                    input "E",
                                    input "",
                                    input-output table rowErrors).
                assign lg-erro-par = yes.
                return.
             end.
    end.


end procedure.

procedure criacao-tabelas-faturamento:
    def input parameter lg-faturamento-complementar-par as log no-undo. 
    

    /*RESERVA DA SEQUENCIA DA NOTA DE SERVICO PARA PROCESSO DE GERACAO*/
    if tmp-api-mens-pre-pagamento.lg-geracao 
    then do transaction:
             find last notaserv
                      where notaserv.cd-modalidade           = propost.cd-modalidade         
                        and notaserv.cd-contratante          = cd-contratante-aux            
                        and notaserv.cd-contratante-origem   = cd-contratante-origem-aux     
                        and notaserv.nr-ter-adesao           = propost.nr-ter-adesao         
                        and notaserv.aa-referencia           = aa-ref-aux 
                        and notaserv.mm-referencia           = mm-ref-aux  
                            no-lock no-error.

             if avail notaserv 
             then assign nr-sequencia-aux = notaserv.nr-sequencia + 1.
             else assign nr-sequencia-aux = 1.
         end.
    else nr-sequencia-aux = nr-sequencia-aux + 1.

    /*CRIA TABELAS FATURAMENTO - PRE PAGAMENTO - (SIMULACAO E GERACAO)*/
    do transaction:

       find first tmp-api-mens-pre-pagamento exclusive-lock no-error. 

       assign tmp-api-mens-pre-pagamento.qt-usuarios   = qt-usu-aux. 

       run cria-notaserv(input lg-faturamento-complementar-par).
       run cria-reajuste.

       assign vl-nota-aux = 0.

       for each tmp-evento-fat no-lock where tmp-evento-fat.qt-evento > 0
                                          or tmp-evento-fat.vl-evento > 0 :

           if tmp-evento-fat.lg-cred-deb 
           then vl-nota-aux = vl-nota-aux + tmp-evento-fat.vl-evento. 
           else vl-nota-aux = vl-nota-aux - tmp-evento-fat.vl-evento. 

           run cria-fatueven.

           if tmp-evento-fat.nr-rowid-evt-prog <> ?
           then run atualiza-evento-programado("TERMO").

           assign vl-grau-faixa-aux   = 0
                  qt-evto-grfaixa-aux = 0.
           for each tmp-evento-benef where tmp-evento-benef.cd-evento = tmp-evento-fat.cd-evento
                                       and tmp-evento-benef.cd-modulo = tmp-evento-fat.cd-modulo  no-lock
                                     break by tmp-evento-benef.cd-grau-parentesco 
                                           by tmp-evento-benef.nr-faixa-etaria
                                           by tmp-evento-benef.cd-padrao-cobertura
                                           by tmp-evento-benef.cd-usuario:

               if tmp-evento-fat.lg-cred-deb
               then assign vl-grau-faixa-aux   = vl-grau-faixa-aux   + tmp-evento-benef.vl-evento.
               else assign vl-grau-faixa-aux   = vl-grau-faixa-aux   - tmp-evento-benef.vl-evento.
               
               assign qt-evto-grfaixa-aux = qt-evto-grfaixa-aux + 1.

               if last-of(tmp-evento-benef.cd-grau-parentesco)
               or last-of(tmp-evento-benef.nr-faixa-etaria)
               or last-of(tmp-evento-benef.cd-padrao-cobertura)
               then do:
                       if tmp-evento-benef.cd-padrao-cobertura = ""
                       or tmp-evento-fat.lg-modulo-agregado
                       then run cria-fatgrmod.
                       else run cria-fatgrunp.
                       assign vl-grau-faixa-aux   = 0
                              qt-evto-grfaixa-aux = 0.
                    end.

               run cria-vlbenef.

               if tmp-evento-benef.lg-sem-reajuste 
               then run cria-fatsemreaj.

               /*atualiza usumodu*/
               if  not tmp-evento-fat.lg-modulo-obrigatorio 
               and tmp-api-mens-pre-pagamento.lg-geracao 
               then for first usumodu fields (usumodu.aa-ult-fat usumodu.mm-ult-fat)
                                      where rowid(usumodu) = tmp-evento-benef.rw-usumodu exclusive-lock:
                        assign usumodu.aa-ult-fat =  aa-ref-aux  
                               usumodu.mm-ult-fat =  mm-ref-aux.
                    end.
            end.
       end.
       
       if tmp-api-mens-pre-pagamento.lg-geracao  
       then do:
               assign notaserv.vl-total = vl-nota-aux. 
               run atualiza-usunegoc. 
            end.

       if not tmp-api-mens-pre-pagamento.lg-geracao  
       or tmp-api-mens-pre-pagamento.lg-cria-temps
       then w-fatmen.vl-total = vl-nota-aux. 

       run atualiza-total-usuario(input lg-faturamento-complementar-par). 

       if tmp-api-mens-pre-pagamento.lg-geracao
       then run atualiza-contrato.
    end.
    find current notaserv no-lock no-error.
end procedure.

procedure atualiza-usunegoc:
  for each tmp-atu-usunegoc no-lock,
      first usu-negoc fields(usu-negoc.aa-referencia-fat 
                             usu-negoc.mm-referencia-fat)
                      where rowid(usu-negoc) = tmp-atu-usunegoc.rw-usunegoc exclusive-lock:
      assign usu-negoc.aa-referencia-fat = tmp-atu-usunegoc.aa-referencia-fat 
             usu-negoc.mm-referencia-fat = tmp-atu-usunegoc.mm-referencia-fat. 
  end.
end procedure.

procedure atualiza-contrato:

    if avail tmp-depen-usuar
    and tmp-depen-usuar.in-tipo-dependencia <> 1
    then return. 

    find current propost exclusive-lock no-error. 

    if avail propost
    then do: 
            if propost.cd-sit-proposta = 5
            then run cria-antitns(input propost.cod-esp-antecipacao,   
                                  input propost.nr-serie-antecipacao,  
                                  input propost.nr-docto-antecipacao,  
                                  input propost.nr-parcela-antecipacao).

            if propost.cd-sit-proposta = 6
            then propost.cd-sit-proposta = 7.
            else if propost.cd-sit-proposta = 5
                 then propost.cd-sit-proposta = 6.
         end.

    for first ter-ade where ter-ade.cd-modalidade = propost.cd-modalidade 
                       and ter-ade.nr-ter-adesao = propost.nr-ter-adesao exclusive-lock:
        assign ter-ade.aa-ult-fat = aa-ref-aux
               ter-ade.mm-ult-fat = mm-ref-aux.
    end.

end procedure.

procedure atualiza-fat-usuario:
    def input parameter lg-fat-compl-par as log no-undo. 

    if avail tmp-depen-usuar
    and tmp-depen-usuar.in-tipo-dependencia = 3
    then return. 

    for first usuario fields (usuario.dt-inclusao-plano
                              usuario.aa-ult-fat 
                              usuario.mm-ult-fat 
                              usuario.aa-pri-fat 
                              usuario.mm-pri-fat 
                              usuario.aa-ult-comp
                              usuario.mm-ult-comp
                              usuario.aa-fim-comp
                              usuario.mm-fim-comp
                              usuario.cd-sit-usuario)
                      where usuario.cd-modalidade = propost.cd-modalidade
                        and usuario.nr-proposta   = propost.nr-proposta
                        and usuario.cd-usuario    = tmp-usu-total.cd-usuario exclusive-lock:

        if year(usuario.dt-inclusao-plano) > aa-ref-aux
        then.
        else if  month(usuario.dt-inclusao-plano) > mm-ref-aux
             and  year(usuario.dt-inclusao-plano) = aa-ref-aux
             then .
        else do:
                if usuario.cd-sit-usuario = 05
                then do: 
                        run cria-antitns(input usuario.cod-esp-antecipacao,   
                                         input usuario.nr-serie-antecipacao,  
                                         input usuario.nr-docto-antecipacao,  
                                         input usuario.nr-parcela-antecipacao).

                        assign usuario.cd-sit-usuario = 06
                               usuario.aa-ult-fat     = aa-ref-aux
                               usuario.mm-ult-fat     = mm-ref-aux
                               usuario.aa-pri-fat     = aa-ref-aux
                               usuario.mm-pri-fat     = mm-ref-aux.
                     end.
                else if usuario.cd-sit-usuario = 06
                     then assign usuario.cd-sit-usuario = 07
                                 usuario.aa-ult-fat     = aa-ref-aux
                                 usuario.mm-ult-fat     = mm-ref-aux.
                     else assign usuario.aa-ult-fat     = aa-ref-aux
                                 usuario.mm-ult-fat     = mm-ref-aux.

                if lg-fat-compl-par 
                then assign usuario.aa-ult-comp    = aa-ref-aux
                            usuario.mm-ult-comp    = mm-ref-aux
                            usuario.aa-fim-comp    = ter-ade.aa-ult-fat
                            usuario.mm-fim-comp    = ter-ade.mm-ult-fat.                       
             end.                                      
    end.                                               
end procedure.         

procedure cria-antitns:
  def input parameter cod-esp-antecipacao-par     like antitns.cod-esp-antecipacao     no-undo. 
  def input parameter nr-serie-antecipacao-par    like antitns.nr-serie-antecipacao    no-undo. 
  def input parameter nr-docto-antecipacao-par    like antitns.nr-docto-antecipacao    no-undo. 
  def input parameter nr-parcela-antecipacao-par  like antitns.nr-parcela-antecipacao  no-undo. 

  if nr-docto-antecipacao-par = "" 
  or nr-docto-antecipacao-par = ?
  then return.

  for first antitns  fields(antitns.ep-codigo)
               where antitns.ep-codigo              = propost.ep-codigo
                 and antitns.cod-estabel            = propost.cod-estabel
                 and antitns.cod-esp-antecipacao    = cod-esp-antecipacao-par   
                 and antitns.nr-serie-antecipacao   = nr-serie-antecipacao-par  
                 and antitns.nr-docto-antecipacao   = nr-docto-antecipacao-par  
                 and antitns.nr-parcela-antecipacao = nr-parcela-antecipacao-par no-lock: end.

  if avail antitns
  then return.
  
  create antitns.
  assign antitns.ep-codigo              = propost.ep-codigo
         antitns.cod-estabel            = propost.cod-estabel
         antitns.cod-esp-antecipacao    = cod-esp-antecipacao-par    
         antitns.nr-serie-antecipacao   = nr-serie-antecipacao-par   
         antitns.nr-docto-antecipacao   = nr-docto-antecipacao-par   
         antitns.nr-parcela-antecipacao = nr-parcela-antecipacao-par 
         antitns.cd-modalidade          = propost.cd-modalidade
         antitns.nr-ter-adesao          = propost.nr-ter-adesao
         antitns.aa-referencia          = notaserv.aa-referencia
         antitns.mm-referencia          = notaserv.mm-referencia
         antitns.nr-sequencia           = notaserv.nr-sequencia
         antitns.cd-userid              = v_cod_usuar_corren
         antitns.dt-atualizacao         = today
         antitns.cd-contratante         = notaserv.cd-contratante          
         antitns.cd-contratante-origem  = notaserv.cd-contratante-origem.   
end procedure.

procedure cria-usunota:

   create usunota.
   assign usunota.cd-modalidade          = notaserv.cd-modalidade     
          usunota.nr-ter-adesao          = notaserv.nr-ter-adesao
          usunota.aa-referencia          = notaserv.aa-referencia
          usunota.mm-referencia          = notaserv.mm-referencia                  
          usunota.nr-sequencia           = notaserv.nr-sequencia     
          usunota.cd-contratante         = notaserv.cd-contratante       
          usunota.cd-contratante-origem  = notaserv.cd-contratante-origem
          usunota.cd-usuario             = tmp-usu-total.cd-usuario
          usunota.cd-userid              = v_cod_usuar_corren
          usunota.dt-atualizacao         = today.
end procedure.

procedure atualiza-evento-programado:
    def input parameter in-tipo-evento-par as char no-undo. 

    if not tmp-api-mens-pre-pagamento.lg-geracao
    then return.

    if in-tipo-evento-par = "TERMO"
    then for first evenprog where rowid(evenprog) = tmp-evento-fat.nr-rowid-evt-prog exclusive-lock:
             assign evenprog.cd-contratante         = notaserv.cd-contratante       
                    evenprog.cd-contratante-origem  = notaserv.cd-contratante-origem
                    evenprog.nr-sequencia           = notaserv.nr-sequencia.         
         end.
    else for first event-progdo-bnfciar where rowid(event-progdo-bnfciar) = tmp-evento-benef.nr-rowid-evt-prog exclusive-lock:
             assign event-progdo-bnfciar.cd-contratante         = notaserv.cd-contratante         
                    event-progdo-bnfciar.cd-contratante-origem  = notaserv.cd-contratante-origem  
                    event-progdo-bnfciar.nr-sequencia           = notaserv.nr-sequencia.          
         end.
end procedure.

procedure cria-notaserv:
    def input parameter lg-fat-compl-par as log no-undo. 
    if tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create notaserv.
            assign notaserv.cd-modalidade            = propost.cd-modalidade
                   notaserv.cd-contratante           = cd-contratante-aux
                   notaserv.cd-contratante-origem    = cd-contratante-origem-aux
                   notaserv.nr-ter-adesao            = propost.nr-ter-adesao
                   notaserv.dt-emissao               = dt-emissao-aux   
                   notaserv.dt-vencimento            = dt-vencimento-aux
                   notaserv.aa-referencia            = aa-ref-aux
                   notaserv.mm-referencia            = mm-ref-aux
                   notaserv.nr-sequencia             = nr-sequencia-aux
                   notaserv.cd-especie               = tiplesp.cd-especie-pre
                   notaserv.ep-codigo                = propost.ep-codigo
                   notaserv.cod-estabel              = propost.cod-estabel
                   notaserv.cd-tab-preco             = propost.cd-tab-preco
                   notaserv.cd-tipo-vencimento       = propost.cd-tipo-vencimento
                   notaserv.nr-dias-isento-rn        = ti-pl-sa.nr-dias-isento-rn
                   notaserv.cd-userid                = v_cod_usuar_corren
                   notaserv.dt-atualizacao           = today
                   notaserv.aa-mm-prox-fat-periodico = string(aa-prox-fat-aux,"9999")
                                                     + string(mm-prox-fat-aux,"99")
                   notaserv.nr-periodicidade-calculo = nr-periodicidade-meses-aux
                   notaserv.in-contratante-utilizado = ter-ade.in-contratante-mensalidade
                   notaserv.log-1                    = yes.

            if lg-fat-compl-par
            then notaserv.in-tipo-nota = 5.
            else notaserv.in-tipo-nota = 0.

            assign tmp-api-mens-pre-pagamento.rowid-notaserv = rowid(notaserv). 
         end.

    if tmp-api-mens-pre-pagamento.lg-cria-temps
    or not tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create w-fatmen.
            assign w-fatmen.cd-modalidade            = propost.cd-modalidade                 
                   w-fatmen.cd-contratante           = cd-contratante-aux                    
                   w-fatmen.cd-contratante-origem    = cd-contratante-origem-aux             
                   w-fatmen.nr-ter-adesao            = propost.nr-ter-adesao                 
                   w-fatmen.dt-emissao               = dt-emissao-aux                        
                   w-fatmen.dt-vencimento            = dt-vencimento-aux                     
                   w-fatmen.aa-referencia            = aa-ref-aux                            
                   w-fatmen.mm-referencia            = mm-ref-aux                            
                   w-fatmen.nr-sequencia             = nr-sequencia-aux
                   w-fatmen.cd-especie               = tiplesp.cd-especie-pre                
                   w-fatmen.ep-codigo                = propost.ep-codigo                     
                   w-fatmen.cod-estabel              = propost.cod-estabel                   
                   w-fatmen.cd-tab-preco             = propost.cd-tab-preco                  
                   w-fatmen.cd-tipo-vencimento       = propost.cd-tipo-vencimento            
                   w-fatmen.nr-dias-isento-rn        = ti-pl-sa.nr-dias-isento-rn            
                   w-fatmen.cd-userid                = v_cod_usuar_corren                    
                   w-fatmen.dt-atualizacao           = today                                 
                   w-fatmen.aa-mm-prox-fat-periodico = string(aa-prox-fat-aux,"9999")        
                                                     + string(mm-prox-fat-aux,"99")          
                   w-fatmen.nr-periodicidade-calculo = nr-periodicidade-meses-aux            
                   w-fatmen.in-contratante-utilizado = ter-ade.in-contratante-mensalidade
                   w-fatmen.log-1                    = yes.   

            if lg-fat-compl-par
            then w-fatmen.in-tipo-nota = 5.
            else w-fatmen.in-tipo-nota = 0.
          end.
end procedure.

procedure cria-reajuste:

    if not tmp-api-mens-pre-pagamento.lg-geracao 
    then return. 

    for each tmp-reajuste where tmp-reajuste.lg-criar no-lock:

        if tmp-reajuste.cd-modulo = 0
        then do:
                 create histabpreco.
                 assign histabpreco.cd-modalidade  = propost.cd-modalidade    
                        histabpreco.nr-proposta    = propost.nr-proposta      
                        histabpreco.aa-reajuste    = tmp-reajuste.aa-reajuste 
                        histabpreco.int-4          = 1  
                        histabpreco.mm-reajuste    = tmp-reajuste.mm-reajuste 
                        histabpreco.pc-reajuste    = tmp-reajuste.pc-reajuste.
             end.
         else do:
                 create histor-preco-reaj.
                 assign histor-preco-reaj.cd-modalidade = propost.cd-modalidade    
                        histor-preco-reaj.nr-proposta   = propost.nr-proposta      
                        histor-preco-reaj.aa-reajuste   = tmp-reajuste.aa-reajuste 
                        histor-preco-reaj.mm-reajuste   = tmp-reajuste.mm-reajuste 
                        histor-preco-reaj.pc-reajuste   = tmp-reajuste.pc-reajuste
                        histor-preco-reaj.cd-modulo     = tmp-reajuste.cd-modulo.
              end.
    end.

    for each tmp-reajuste-benef where tmp-reajuste-benef.lg-criar no-lock:

        if tmp-reajuste-benef.cd-modulo = 0
        then do: 
                create histabprecobenef.
                assign histabprecobenef.cd-modalidade = propost.cd-modalidade             
                       histabprecobenef.nr-proposta   = propost.nr-proposta               
                       histabprecobenef.aa-reajuste   = tmp-reajuste-benef.aa-reajuste    
                       histabprecobenef.mm-reajuste   = tmp-reajuste-benef.mm-reajuste    
                       histabprecobenef.cd-usuario    = tmp-reajuste-benef.cd-usuario     
                       histabprecobenef.pc-reajuste   = tmp-reajuste-benef.pc-reajuste    
                       histabprecobenef.num-sit-reaj  = 1.
             end.
        else do:
                create histor-preco-benef-modul.
                assign histor-preco-benef-modul.cd-modalidade = propost.cd-modalidade
                       histor-preco-benef-modul.nr-proposta   = propost.nr-proposta
                       histor-preco-benef-modul.aa-reajuste   = tmp-reajuste-benef.aa-reajuste  
                       histor-preco-benef-modul.num-mes-reaj  = tmp-reajuste-benef.mm-reajuste  
                       histor-preco-benef-modul.cd-usuario    = tmp-reajuste-benef.cd-usuario   
                       histor-preco-benef-modul.pc-reajuste   = tmp-reajuste-benef.pc-reajuste  
                       histor-preco-benef-modul.cd-modulo     = tmp-reajuste-benef.cd-modulo   
                       histor-preco-benef-modul.num-sit-reaj  = 1.
             end.
    end.
end procedure. 

procedure cria-fatueven:

    if tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            for first fatueven where fatueven.cd-modalidade          = notaserv.cd-modalidade
                                 and fatueven.cd-contratante         = notaserv.cd-contratante          
                                 and fatueven.cd-contratante-origem  = notaserv.cd-contratante-origem   
                                 and fatueven.nr-ter-adesao          = notaserv.nr-ter-adesao
                                 and fatueven.aa-referencia          = notaserv.aa-referencia 
                                 and fatueven.mm-referencia          = notaserv.mm-referencia 
                                 and fatueven.nr-sequencia           = notaserv.nr-sequencia   
                                 and fatueven.cd-evento              = tmp-evento-fat.cd-evento
                                 and fatueven.cd-tipo-cob            = 0 exclusive-lock: end. 

           if not avail fatueven
           then do:
                  create fatueven.
                  assign fatueven.cd-modalidade         = notaserv.cd-modalidade   
                         fatueven.nr-sequencia          = notaserv.nr-sequencia    
                         fatueven.nr-ter-adesao         = notaserv.nr-ter-adesao   
                         fatueven.aa-referencia         = notaserv.aa-referencia   
                         fatueven.mm-referencia         = notaserv.mm-referencia   
                         fatueven.cd-evento             = tmp-evento-fat.cd-evento
                         fatueven.qt-evento             = tmp-evento-fat.qt-evento
                         fatueven.vl-evento             = tmp-evento-fat.vl-evento
                         fatueven.lg-cred-deb           = tmp-evento-fat.lg-cred-deb
                         fatueven.lg-destacado          = tmp-evento-fat.lg-destacado
                         fatueven.lg-modulo             = tmp-evento-fat.lg-modulo
                         fatueven.ct-codigo             = tmp-evento-fat.ct-codigo
                         fatueven.sc-codigo             = tmp-evento-fat.sc-codigo
                         fatueven.qt-evento-ref         = 0
                         fatueven.vl-evento-ref         = 0
                         fatueven.cd-tipo-cob           = 0
                         fatueven.cd-contratante        = notaserv.cd-contratante        
                         fatueven.cd-contratante-origem = notaserv.cd-contratante-origem 
                         fatueven.cd-userid             = v_cod_usuar_corren
                         fatueven.dt-atualizacao        = today.
                end.
            else assign fatueven.vl-evento             = fatueven.vl-evento             
                                                       + tmp-evento-fat.vl-evento.
          end.

    if tmp-api-mens-pre-pagamento.lg-cria-temps
    or not tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
             for first w-fateve where w-fateve.cd-modalidade          = w-fatmen.cd-modalidade
                                  and w-fateve.cd-contratante         = w-fatmen.cd-contratante          
                                  and w-fateve.cd-contratante-origem  = w-fatmen.cd-contratante-origem   
                                  and w-fateve.nr-ter-adesao          = w-fatmen.nr-ter-adesao
                                  and w-fateve.aa-referencia          = w-fatmen.aa-referencia 
                                  and w-fateve.mm-referencia          = w-fatmen.mm-referencia 
                                  and w-fateve.nr-sequencia           = w-fatmen.nr-sequencia   
                                  and w-fateve.cd-evento              = tmp-evento-fat.cd-evento
                                  and w-fateve.cd-tipo-cob            = 0 exclusive-lock: end. 

             if not avail w-fateve
             then do:
                    create w-fateve.
                    assign w-fateve.cd-modalidade         = w-fatmen.cd-modalidade   
                           w-fateve.nr-sequencia          = w-fatmen.nr-sequencia    
                           w-fateve.nr-ter-adesao         = w-fatmen.nr-ter-adesao   
                           w-fateve.aa-referencia         = w-fatmen.aa-referencia   
                           w-fateve.mm-referencia         = w-fatmen.mm-referencia   
                           w-fateve.cd-evento             = tmp-evento-fat.cd-evento
                           w-fateve.qt-evento             = tmp-evento-fat.qt-evento
                           w-fateve.vl-evento             = tmp-evento-fat.vl-evento
                           w-fateve.lg-cred-deb           = tmp-evento-fat.lg-cred-deb
                           w-fateve.lg-destacado          = tmp-evento-fat.lg-destacado
                           w-fateve.lg-modulo             = tmp-evento-fat.lg-modulo
                           w-fateve.ct-codigo             = tmp-evento-fat.ct-codigo
                           w-fateve.sc-codigo             = tmp-evento-fat.sc-codigo
                           w-fateve.qt-evento-ref         = 0
                           w-fateve.vl-evento-ref         = 0
                           w-fateve.cd-tipo-cob           = 0
                           w-fateve.cd-contratante        = w-fatmen.cd-contratante        
                           w-fateve.cd-contratante-origem = w-fatmen.cd-contratante-origem 
                           w-fateve.cd-userid             = v_cod_usuar_corren
                           w-fateve.dt-atualizacao        = today.
                  end.
             else assign w-fateve.vl-evento = w-fateve.vl-evento + tmp-evento-fat.vl-evento.
          end.
end procedure.

procedure cria-fatgrmod:

    if tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create fatgrmod.
            assign fatgrmod.cd-modalidade         = notaserv.cd-modalidade        
                   fatgrmod.nr-ter-adesao         = notaserv.nr-ter-adesao        
                   fatgrmod.aa-referencia         = notaserv.aa-referencia        
                   fatgrmod.mm-referencia         = notaserv.mm-referencia        
                   fatgrmod.nr-sequencia          = notaserv.nr-sequencia         
                   fatgrmod.cd-contratante        = notaserv.cd-contratante       
                   fatgrmod.cd-contratante-origem = notaserv.cd-contratante-origem
                   fatgrmod.cd-evento             = tmp-evento-fat.cd-evento
                   fatgrmod.ct-codigo             = tmp-evento-fat.ct-codigo
                   fatgrmod.sc-codigo             = tmp-evento-fat.sc-codigo
                   fatgrmod.cd-grau-parentesco    = tmp-evento-benef.cd-grau-parentesco
                   fatgrmod.nr-faixa-etaria       = tmp-evento-benef.nr-faixa-etaria
                   fatgrmod.cd-modulo             = tmp-evento-benef.cd-modulo
                   fatgrmod.ch-evento-grau-modulo = string(tmp-evento-benef.cd-evento,"999") +
                                                    string(tmp-evento-benef.cd-grau-parentesco,"99") +
                                                    string(tmp-evento-benef.nr-faixa-etaria,"99") +
                                                    string(tmp-evento-benef.cd-modulo,"999")
                   fatgrmod.qt-evento             = qt-evto-grfaixa-aux
                   fatgrmod.vl-evento             = vl-grau-faixa-aux
                   fatgrmod.cd-userid             = v_cod_usuar_corren
                   fatgrmod.dt-atualizacao        = today.
         end.

    if tmp-api-mens-pre-pagamento.lg-cria-temps
    or not tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create w-fatgrau.
            assign w-fatgrau.cd-modalidade         = w-fatmen.cd-modalidade        
                   w-fatgrau.nr-ter-adesao         = w-fatmen.nr-ter-adesao        
                   w-fatgrau.aa-referencia         = w-fatmen.aa-referencia        
                   w-fatgrau.mm-referencia         = w-fatmen.mm-referencia        
                   w-fatgrau.nr-sequencia          = w-fatmen.nr-sequencia         
                   w-fatgrau.cd-contratante        = w-fatmen.cd-contratante       
                   w-fatgrau.cd-contratante-origem = w-fatmen.cd-contratante-origem
                   w-fatgrau.cd-evento             = tmp-evento-fat.cd-evento
                   w-fatgrau.ct-codigo             = tmp-evento-fat.ct-codigo
                   w-fatgrau.sc-codigo             = tmp-evento-fat.sc-codigo
                   w-fatgrau.cd-grau-parentesco    = tmp-evento-benef.cd-grau-parentesco
                   w-fatgrau.nr-faixa-etaria       = tmp-evento-benef.nr-faixa-etaria
                   w-fatgrau.cd-modulo             = tmp-evento-benef.cd-modulo
                   w-fatgrau.ch-evento-grau-modulo = string(tmp-evento-benef.cd-evento,"999") +
                                                    string(tmp-evento-benef.cd-grau-parentesco,"99") +
                                                    string(tmp-evento-benef.nr-faixa-etaria,"99") +
                                                    string(tmp-evento-benef.cd-modulo,"999")
                   w-fatgrau.qt-evento             = qt-evto-grfaixa-aux
                   w-fatgrau.vl-evento             = vl-grau-faixa-aux
                   w-fatgrau.cd-userid             = v_cod_usuar_corren
                   w-fatgrau.dt-atualizacao        = today.
         end.
end procedure.

procedure cria-fatgrunp:

    if tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create fatgrunp.
            assign fatgrunp.cd-modalidade         = notaserv.cd-modalidade        
                   fatgrunp.nr-ter-adesao         = notaserv.nr-ter-adesao        
                   fatgrunp.aa-referencia         = notaserv.aa-referencia        
                   fatgrunp.mm-referencia         = notaserv.mm-referencia        
                   fatgrunp.nr-sequencia          = notaserv.nr-sequencia         
                   fatgrunp.cd-contratante        = notaserv.cd-contratante       
                   fatgrunp.cd-contratante-origem = notaserv.cd-contratante-origem
                   fatgrunp.cd-evento             = tmp-evento-fat.cd-evento   
                   fatgrunp.ct-codigo             = tmp-evento-fat.ct-codigo   
                   fatgrunp.sc-codigo             = tmp-evento-fat.sc-codigo   
                   fatgrunp.cd-grau-parentesco    = tmp-evento-benef.cd-grau-parentesco  
                   fatgrunp.nr-faixa-etaria       = tmp-evento-benef.nr-faixa-etaria     
                   fatgrunp.ch-evento-grau-padcob = string(tmp-evento-benef.cd-evento,"999") +
                                                    string(tmp-evento-benef.cd-padrao-cobertura,"xx") +
                                                    string(tmp-evento-benef.cd-grau-parentesco,"99") +
                                                    string(tmp-evento-benef.nr-faixa-etaria,"99")
                   fatgrunp.cd-padrao-cobertura   = tmp-evento-benef.cd-padrao-cobertura
                   fatgrunp.vl-evento             = vl-grau-faixa-aux    
                   fatgrunp.qt-evento             = qt-evto-grfaixa-aux  
                   fatgrunp.cd-userid             = v_cod_usuar_corren
                   fatgrunp.dt-atualizacao        = today
                   fatgrunp.lg-usa-grau-padrao    = no.
         end.

    if tmp-api-mens-pre-pagamento.lg-cria-temps
    or not tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create w-fatgrun.
            assign w-fatgrun.cd-modalidade         = w-fatmen.cd-modalidade                                
                   w-fatgrun.nr-ter-adesao         = w-fatmen.nr-ter-adesao                                
                   w-fatgrun.aa-referencia         = w-fatmen.aa-referencia                                
                   w-fatgrun.mm-referencia         = w-fatmen.mm-referencia                                
                   w-fatgrun.nr-sequencia          = w-fatmen.nr-sequencia                                 
                   w-fatgrun.cd-contratante        = w-fatmen.cd-contratante                               
                   w-fatgrun.cd-contratante-origem = w-fatmen.cd-contratante-origem                        
                   w-fatgrun.cd-evento             = tmp-evento-fat.cd-evento                              
                   w-fatgrun.ct-codigo             = tmp-evento-fat.ct-codigo                              
                   w-fatgrun.sc-codigo             = tmp-evento-fat.sc-codigo                              
                   w-fatgrun.cd-grau-parentesco    = tmp-evento-benef.cd-grau-parentesco                   
                   w-fatgrun.nr-faixa-etaria       = tmp-evento-benef.nr-faixa-etaria                      
                   w-fatgrun.ch-evento-grau-padcob = string(tmp-evento-benef.cd-evento,"999") +            
                                                    string(tmp-evento-benef.cd-padrao-cobertura,"xx") +   
                                                    string(tmp-evento-benef.cd-grau-parentesco,"99") +    
                                                    string(tmp-evento-benef.nr-faixa-etaria,"99")         
                   w-fatgrun.cd-padrao-cobertura   = tmp-evento-benef.cd-padrao-cobertura                  
                   w-fatgrun.vl-evento             = vl-grau-faixa-aux                                     
                   w-fatgrun.qt-evento             = qt-evto-grfaixa-aux                                   
                   w-fatgrun.cd-userid             = v_cod_usuar_corren                                    
                   w-fatgrun.dt-atualizacao        = today                                                 
                   w-fatgrun.lg-usa-grau-padrao    = no.                                                   
         end.
end procedure.

procedure cria-vlbenef:

    run atualiza-vl-usuario. 
    if tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
            create vlbenef.
            assign vlbenef.cd-modalidade         = notaserv.cd-modalidade         
                   vlbenef.nr-ter-adesao         = notaserv.nr-ter-adesao                
                   vlbenef.aa-referencia         = notaserv.aa-referencia                        
                   vlbenef.mm-referencia         = notaserv.mm-referencia                        
                   vlbenef.nr-sequencia          = notaserv.nr-sequencia          
                   vlbenef.cd-contratante        = notaserv.cd-contratante        
                   vlbenef.cd-contratante-origem = notaserv.cd-contratante-origem 
                   vlbenef.cd-usuario            = tmp-evento-benef.cd-usuario
                   vlbenef.nr-faixa-etaria       = tmp-evento-benef.nr-faixa-etaria
                   vlbenef.cd-grau-parentesco    = tmp-evento-benef.cd-grau-parentesco
                   vlbenef.cd-evento             = tmp-evento-benef.cd-evento
                   vlbenef.cd-modulo             = tmp-evento-benef.cd-modulo
                   vlbenef.vl-usuario            = tmp-evento-benef.vl-evento
                   vlbenef.cd-userid             = v_cod_usuar_corren 
                   vlbenef.dt-atualizacao        = today
                   vlbenef.dec-2                 = tmp-evento-benef.cdd-regra
                   vlbenef.dec-3                 = tmp-evento-benef.id-criter.
         end.

    if tmp-api-mens-pre-pagamento.lg-cria-temps
    or not tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
           create w-vlbenef.
           assign w-vlbenef.cd-modalidade         = w-fatmen.cd-modalidade         
                  w-vlbenef.nr-ter-adesao         = w-fatmen.nr-ter-adesao                
                  w-vlbenef.aa-referencia         = w-fatmen.aa-referencia                        
                  w-vlbenef.mm-referencia         = w-fatmen.mm-referencia                        
                  w-vlbenef.nr-sequencia          = w-fatmen.nr-sequencia          
                  w-vlbenef.cd-contratante        = w-fatmen.cd-contratante        
                  w-vlbenef.cd-contratante-origem = w-fatmen.cd-contratante-origem 
                  w-vlbenef.cd-usuario            = tmp-evento-benef.cd-usuario
                  w-vlbenef.nr-faixa-etaria       = tmp-evento-benef.nr-faixa-etaria
                  w-vlbenef.cd-grau-parentesco    = tmp-evento-benef.cd-grau-parentesco
                  w-vlbenef.cd-evento             = tmp-evento-benef.cd-evento
                  w-vlbenef.cd-modulo             = tmp-evento-benef.cd-modulo
                  w-vlbenef.vl-usuario            = tmp-evento-benef.vl-evento
                  w-vlbenef.dec-2                 = tmp-evento-benef.cdd-regra
                  w-vlbenef.dec-3                 = tmp-evento-benef.id-criter.
        end.
end procedure.

procedure cria-fatsemreaj:
   if tmp-api-mens-pre-pagamento.lg-geracao 
   then do:
           create fatsemreaj.
           assign fatsemreaj.cd-modalidade         = notaserv.cd-modalidade           
                  fatsemreaj.nr-ter-adesao         = notaserv.nr-ter-adesao           
                  fatsemreaj.aa-referencia         = notaserv.aa-referencia           
                  fatsemreaj.mm-referencia         = notaserv.mm-referencia           
                  fatsemreaj.nr-sequencia          = notaserv.nr-sequencia         
                  fatsemreaj.cd-contratante        = notaserv.cd-contratante       
                  fatsemreaj.cd-contratante-origem = notaserv.cd-contratante-origem
                  fatsemreaj.cd-usuario            = tmp-evento-benef.cd-usuario
                  fatsemreaj.cd-padrao-cobertura   = tmp-evento-benef.cd-padrao-cobertura
                  fatsemreaj.qt-fator-mult         = 1
                  fatsemreaj.qt-fator-tr-faixa     = 1
                  fatsemreaj.ch-evento-grau-modulo = string(tmp-evento-benef.cd-evento,"999") +                 
                                                     string(tmp-evento-benef.cd-grau-parentesco,"99") +         
                                                     string(tmp-evento-benef.nr-faixa-etaria,"99") +            
                                                     string(tmp-evento-benef.cd-modulo,"999")                   
                  fatsemreaj.qt-evento             = 1           
                  fatsemreaj.vl-evento             = tmp-evento-benef.vl-evento        
                  fatsemreaj.cd-userid             = v_cod_usuar_corren 
                  fatsemreaj.dt-atualizacao        = today. 
        end.

    if tmp-api-mens-pre-pagamento.lg-cria-temps
    or not tmp-api-mens-pre-pagamento.lg-geracao 
    then do:
           create w-fatsemreaj.
           assign w-fatsemreaj.cd-modalidade         = w-fatmen.cd-modalidade           
                  w-fatsemreaj.nr-ter-adesao         = w-fatmen.nr-ter-adesao           
                  w-fatsemreaj.aa-referencia         = w-fatmen.aa-referencia           
                  w-fatsemreaj.mm-referencia         = w-fatmen.mm-referencia           
                  w-fatsemreaj.nr-sequencia          = w-fatmen.nr-sequencia         
                  w-fatsemreaj.cd-contratante        = w-fatmen.cd-contratante       
                  w-fatsemreaj.cd-contratante-origem = w-fatmen.cd-contratante-origem
                  w-fatsemreaj.cd-usuario            = tmp-evento-benef.cd-usuario
                  w-fatsemreaj.cd-padrao-cobertura   = tmp-evento-benef.cd-padrao-cobertura
                  w-fatsemreaj.qt-fator-mult         = 1
                  w-fatsemreaj.qt-fator-tr-faixa     = 1
                  w-fatsemreaj.ch-evento-grau-modulo = string(tmp-evento-benef.cd-evento,"999") +                 
                                                     string(tmp-evento-benef.cd-grau-parentesco,"99") +         
                                                     string(tmp-evento-benef.nr-faixa-etaria,"99") +            
                                                     string(tmp-evento-benef.cd-modulo,"999")                   
                  /*w-fatsemreaj.qt-evento             = 1           */
                  w-fatsemreaj.vl-evento             = tmp-evento-benef.vl-evento. 
         end.
end procedure.

procedure cria-fatura:
   def output parameter lg-erro-par as log no-undo. 
   def var nr-fatura-aux as int no-undo. 

   find first parafatu.

   /*--------------------------------
    * encontra CT-CODIGO e SC-CODIGO
    *-------------------------------*/
   assign ct-codigo-aux     = parafatu.ct-codigo
          sc-codigo-aux     = parafatu.sc-codigo.

   if  dec(ct-codigo-aux) = 0
   and dec(sc-codigo-aux) = 0
   then do:
            run insertErrorGP(input 69,
                              input "",
                              input "",
                              input-output table rowErrors).
           assign lg-erro-par = yes. 
           undo,retry.
       end.

   assign lg-erro-par = no.

   /*-----------------------------------
    * Busca o numero da Ultima Fatura
    *----------------------------------*/
   run rtp/rtnrfat.p(input  notaserv.cd-modalidade,
                     input  notaserv.cd-contratante,
                     output nr-fatura-aux).

   if lg-erro-par
   then undo, leave.

   do transaction:
   create fatura.
   assign fatura.cd-contratante     = notaserv.cd-contratante
          fatura.nr-fatura          = nr-fatura-aux
          fatura.aa-referencia      = aa-ref-aux
          fatura.mm-referencia      = mm-ref-aux
          fatura.ep-codigo          = notaserv.ep-codigo
          fatura.cod-estabel        = notaserv.cod-estabel
          fatura.cd-modalidade      = cd-modalidade-aux
          fatura.cd-especie         = notaserv.cd-especie
          fatura.ds-mensagem        = ds-mensagem-aux
          fatura.portador           = cd-portador-aux 
          fatura.modalidade         = cd-modalidade-cob-aux
          fatura.ct-codigo          = ct-codigo-aux
          fatura.sc-codigo          = sc-codigo-aux
          fatura.nr-titulo-acr      = ""
          fatura.parcela            = 0
          fatura.dt-emissao         = dt-emissao-aux
          fatura.dt-vencimento      = dt-vencimento-aux
          fatura.cd-tipo-vencimento = 0
          fatura.cd-sit-fatu        = 10
          fatura.mo-codigo          = 0
          fatura.in-tipo-fatura     = 3
          fatura.cd-userid          = v_cod_usuar_corren
          fatura.dt-atualizacao     = today
          
         /* fatura.dec-1              = if lg-gravou-imp-aux
                                      then vl-base-ir-aux
                                      else 0
          fatura.dec-2              = if lg-gravou-imp-aux
                                      then pc-aliquota-ir-aux
                                      else 0*/
          fatura.vl-total           = notaserv.vl-total.

    find current notaserv exclusive-lock no-error. 
    
    if avail notaserv
    then notaserv.nr-fatura = nr-fatura-aux.

    validate fatura.

    /* ----------------------- GRAVA IMPOSTO DAS FATURAS JA GERADAS --- */
    if parafatu.log-14
    then do:
           /*if lg-grava-imposto
           then run rtp/rtcalcimp.p(input  cd-emitente-aux,
                                    input  nr-fatura-aux,
                                    input  aa-ref-aux,
                                    input  mm-ref-aux,
                                    input  dt-vencimento-aux,
                                    input  dt-emissao-aux,
                                    input  "grava-imposto",
                                    input  no,
                                    input  no,
                                    output lg-imposto-auxiliar,
                                    output lg-imp-aux,
                                    input-output table wk-imposto-aux).
           else do:
                  assign fatura.dec-1 = fatura.dec-1 + vl-base-aux.

                  if pc-aliquota-aux <> 0
                  then assign fatura.dec-2 = pc-aliquota-aux.
                end.*/
   
         end.
   end. /* TRANSACTION */

end procedure.

procedure atualiza-vl-usuario:
   find tmp-usu-total where tmp-usu-total.cd-usuario = tmp-evento-benef.cd-usuario 
                      exclusive-lock no-error. 

   if not avail tmp-usu-total
   then do:
           create tmp-usu-total.
           assign tmp-usu-total.cd-usuario = tmp-evento-benef.cd-usuario.
        end.

   if tmp-evento-fat.lg-cred-deb 
   then assign tmp-usu-total.vl-usuario = tmp-usu-total.vl-usuario + tmp-evento-benef.vl-evento.
   else assign tmp-usu-total.vl-usuario = tmp-usu-total.vl-usuario - tmp-evento-benef.vl-evento.
end procedure.

procedure atualiza-total-usuario:
   def input parameter lg-faturamento-complementar-par as log no-undo. 
   for each tmp-usu-total no-lock:
       if tmp-api-mens-pre-pagamento.lg-geracao 
       then do:
                for first vlbenef use-index vlbenef1
                                  where vlbenef.cd-modalidade         = notaserv.cd-modalidade           
                                    and vlbenef.cd-contratante        = notaserv.cd-contratante          
                                    and vlbenef.cd-contratante-origem = notaserv.cd-contratante-origem   
                                    and vlbenef.nr-ter-adesao         = notaserv.nr-ter-adesao             
                                    and vlbenef.aa-referencia         = notaserv.aa-referencia                  
                                    and vlbenef.mm-referencia         = notaserv.mm-referencia                  
                                    and vlbenef.nr-sequencia          = notaserv.nr-sequencia            
                                    and vlbenef.cd-usuario            = tmp-usu-total.cd-usuario  exclusive-lock:
                    assign vlbenef.vl-total = tmp-usu-total.vl-usuario.
                end.
                run atualiza-fat-usuario(input lg-faturamento-complementar-par).
                
                if lg-faturamento-complementar-par
                then run cria-usunota.
             end.

       if tmp-api-mens-pre-pagamento.lg-cria-temps
       or not tmp-api-mens-pre-pagamento.lg-geracao 
       then for first w-vlbenef 
                              where w-vlbenef.cd-modalidade         = w-fatmen.cd-modalidade           
                                and w-vlbenef.cd-contratante        = w-fatmen.cd-contratante          
                                and w-vlbenef.cd-contratante-origem = w-fatmen.cd-contratante-origem   
                                and w-vlbenef.nr-ter-adesao         = w-fatmen.nr-ter-adesao             
                                and w-vlbenef.aa-referencia         = w-fatmen.aa-referencia                  
                                and w-vlbenef.mm-referencia         = w-fatmen.mm-referencia                  
                                and w-vlbenef.nr-sequencia          = w-fatmen.nr-sequencia            
                                and w-vlbenef.cd-usuario            = tmp-usu-total.cd-usuario  exclusive-lock:
                assign w-vlbenef.vl-total = tmp-usu-total.vl-usuario.
            end.
   end.
end procedure.

procedure processa-eventos-totais:
    def input parameter in-classe-evento-par as char no-undo. 

    for each tmp-evento-fat no-lock where tmp-evento-fat.in-classe-evento = in-classe-evento-par:
         /*-----------------------------
         * se for evento programado
         *-----------------------------*/
        if tmp-evento-fat.in-classe-evento = "M"
        then do:
               /*--- verifica se o evento programado estÿ aberto por beneficiario ---------------------*/
               for first event-progdo-bnfciar
                    where event-progdo-bnfciar.cd-modalidade = propost.cd-modalidade
                      and event-progdo-bnfciar.nr-ter-adesao = propost.nr-ter-adesao
                      and event-progdo-bnfciar.cd-evento     = tmp-evento-fat.cd-evento
                      and event-progdo-bnfciar.aa-referencia = aa-ref-aux
                      and event-progdo-bnfciar.mm-referencia = mm-ref-aux   no-lock:

               end.

               if not avail event-progdo-bnfciar
               then for first evenprog  where evenprog.cd-modalidade   = propost.cd-modalidade
                                          and evenprog.nr-ter-adesao   = propost.nr-ter-adesao
                                          and evenprog.aa-referencia   = aa-ref-aux
                                          and evenprog.mm-referencia   = mm-ref-aux
                                          and evenprog.cd-evento       = tmp-evento-fat.cd-evento no-lock:

                         assign tmp-evento-fat.vl-evento          = evenprog.vl-evento * (tmp-evento-fat.pc-princ-aux / 100)
                                tmp-evento-fat.qt-evento          = 1
                                tmp-evento-fat.nr-rowid-evt-prog  = rowid(evenprog).
                    end.
                next.
             end.

        if tmp-evento-fat.in-classe-rotina = 0
        then run value("dep/" + tmp-evento-fat.in-programa).
        else run executa-rotina (input nm-rotinas-aux[tmp-evento-fat.in-classe-rotina]).
    end.
end procedure. 

procedure valida-contrato:

    def output parameter lg-erro-par as logical no-undo.
    
    find ter-ade use-index ter-ade1
         where ter-ade.cd-modalidade = tmp-api-mens-pre-pagamento.cd-modalidade
           and ter-ade.nr-ter-adesao = tmp-api-mens-pre-pagamento.nr-ter-adesao
               no-lock no-error.
 
   if not available ter-ade
   then do:
          assign lg-erro-par = yes.
        
          run insertErrorGP(input 243,
                            input "Modalidade: " + string(tmp-api-mens-pre-pagamento.cd-modalidade) + chr(13)
                                + "Termo: "      + string(tmp-api-mens-pre-pagamento.nr-ter-adesao),
                            input "",
                            input-output table rowErrors).
          
          undo, return.
        end.
 
   find propost
        where propost.cd-modalidade = ter-ade.cd-modalidade
          and propost.nr-ter-adesao = ter-ade.nr-ter-adesao
              no-lock no-error.

   if not available propost 
   then do:
          assign lg-erro-par = yes.

          run insertErrorGP(input 11,
                            input "Modalidade: " + string(ter-ade.cd-modalidade) + chr(13)
                                + "Contrato: "   + string(ter-ade.nr-ter-ade),
                            input "",
                            input-output table rowErrors).
          undo, return.
        end.

   if  propost.cd-sit-propost <> 05
   and propost.cd-sit-propost <> 06
   and propost.cd-sit-propost <> 07
   then do:
          assign lg-erro-par = yes.
        
          run insertErrorGP(input 701,
                            input "Modalidade: " + string(ter-ade.cd-modalidade) + chr(13)
                                + "Contrato: "   + string(ter-ade.nr-ter-ade),
                            input "",
                            input-output table rowErrors).
          undo, return.
        end.

end procedure.

procedure valida-contratante:

    def output parameter cd-contratante-par          as integer      no-undo.
    def output parameter cd-contratante-origem-par   as integer      no-undo.
    def output parameter lg-erro-par                 as logical      no-undo.
                                                            
    case ter-ade.in-contratante-mensalidade:
        
        when 0  /* CONTRATANTE */                                               
        then assign cd-contratante-par        = propost.cd-contratante          
                    cd-contratante-origem-par = propost.nr-insc-contrat-origem. 

        when 1  /* CONTRATANTE ORIGEM */                                        
        then do:
               assign cd-contratante-par        = propost.cd-contratante          
                      cd-contratante-origem-par = propost.nr-insc-contratante.

               find contrat
                    where contrat.nr-insc-contratante = propost.nr-insc-contrat-origem
                          no-lock no-error.
               
               if not avail contrat
               then do:
                      assign lg-erro-par = yes.
        
                      run insertErrorGP(input 064,
                                        input "Contratante: " + string(propost.nr-insc-contrat-origem),
                                        input "",
                                        input-output table rowErrors).
                      undo, return.
                    end.

               assign cd-contratante-par = contrat.cd-contratante.

             end.

    end case.

    /* --------------- CHAMA API DE CONSULTA DE CONTRATANTE --- */
    assign cd-contratante-rtapi044-aux   = cd-contratante-par
           lg-prim-mens-rtapi044-aux     = no
           in-funcao-rtapi044-aux        = "GDT"
           in-tipo-emitente-rtapi044-aux = "CONTRA".

    run rtapi044 no-error.

    if error-status:error
    then do:
           assign lg-erro-par = yes.
            
           if error-status:num-messages = 0                                                   
           then do:
                  run insertErrorGP(input 088,
                                    input "",
                                    input "",
                                    input-output table rowErrors).
                end.                                                                            
           else do:                 
                  run insertOtherError(input 0,
                                       input substring(error-status:get-message(error-status:num-messages),1,175),
                                       input "",  
                                       input "GP",
                                       input "E",
                                       input "",
                                       input-output table rowErrors).
                end.   

           undo, return.
         end.

    if lg-erro-rtapi044-aux                                                                   
    then do:    
           assign lg-erro-par = yes.

           run insertErrorGP(input 064,
                             input "Contratante: " + string(cd-contratante-par),
                             input "",
                             input-output table rowErrors).
           undo, return.                                    
         end.  

    find first tmp-rtapi044 no-lock no-error. 

    if avail tmp-rtapi044
    then  assign cd-portador-aux       = tmp-rtapi044.portador
                 cd-modalidade-aux     = tmp-rtapi044.modalidade
                 cd-modalidade-cob-aux = tmp-rtapi044.modalidade.

    /*----------------------
     * contratante
     *----------------------*/
    if not avail contrat
    then find first contrat 
                    where contrat.cd-contratante = cd-contratante-par
                          no-lock no-error.

    if not avail contrat
    then do:
           assign lg-erro-par = yes.

           run insertErrorGP(input 064,
                             input "Contratante: " + string(cd-contratante-par),
                             input "",
                             input-output table rowErrors).
           undo, return. 
         end.

end procedure.

procedure valida-estrutura-proposta:

    def output parameter lg-erro-par as logical no-undo.

    find pla-sau
         where pla-sau.cd-modalidade = propost.cd-modalidade
           and pla-sau.cd-plano      = propost.cd-plano
               no-lock no-error.


    if not avail pla-sau
    then do:
           assign lg-erro-par = yes.

           run insertErrorGP(input 015,
                             input "Modalidade: " + string(propost.cd-modalidade) + chr(13) 
                                 + "Plano: "      + string(propost.cd-plano),
                             input "",
                             input-output table rowErrors).
           undo, return. 
         end.

    find ti-pl-sa
         where ti-pl-sa.cd-modalidade  = propost.cd-modalidade
           and ti-pl-sa.cd-plano       = propost.cd-plano
           and ti-pl-sa.cd-tipo-plano  = propost.cd-tipo-plano
               no-lock no-error. 

    if not avail ti-pl-sa
    then do:
           assign lg-erro-par = yes.

           run insertErrorGP(input 016,
                             input "Modalidade: " + string(propost.cd-modalidade) + chr(13) 
                                 + "Plano: "      + string(propost.cd-plano)      + chr(13)
                                 + "Tip.Plano: "  + string(propost.cd-tipo-plano),
                             input "",
                             input-output table rowErrors).
           undo, return. 
         end.

    run le-tiplesp(output lg-erro-par).

end procedure.

/* ----------------------------------------------------------------------------------- */
procedure mes-ano-base:

    def output parameter aa-ref-par      as integer      no-undo.                                
    def output parameter mm-ref-par      as integer      no-undo.                                
    def output parameter lg-erro-par            as logical      no-undo.

    if  tmp-api-mens-pre-pagamento.aa-referencia <> 0
    and tmp-api-mens-pre-pagamento.mm-referencia <> 0
    then do:
            assign aa-ref-par = tmp-api-mens-pre-pagamento.aa-referencia
                   mm-ref-par = tmp-api-mens-pre-pagamento.mm-referencia.
            return.
         end.

    if propost.cd-sit-proposta = 5
    then assign aa-ref-par = year(ter-ade.dt-inicio)
                mm-ref-par = month(ter-ade.dt-inicio).
 
    else do:

           assign mm-ref-par = ter-ade.mm-ult-fat + 1.

           if mm-ref-par > 12
           then assign mm-ref-par = 01
                       aa-ref-par = ter-ade.aa-ult-fat + 1.
           else assign aa-ref-par = ter-ade.aa-ult-fat.

         end.

end procedure.

procedure le-tiplesp:
    
    def output parameter lg-erro-par        as logical                          no-undo.
      
    find first tiplesp
         where tiplesp.cd-modalidade  = propost.cd-modalidade
           and tiplesp.cd-plano       = propost.cd-plano
           and tiplesp.cd-tipo-plano  = propost.cd-tipo-plano
           and tiplesp.in-entidade    = "FT"
           and tiplesp.cd-forma-pagto = propost.cd-forma-pagto
               no-lock no-error.
       
    if not avail tiplesp
    then do:
           assign lg-erro-par = yes.
    
           run insertOtherError(input 0672,
                                input "Mod: "  + string(propost.cd-modalidade) + chr(13)
                                    + "Plan: " + string(propost.cd-plano)      + chr(13)
                                    + "Tip: "  + string(propost.cd-tipo-plano),
                                input "",
                                input "GP",
                                input "E",
                                input "",
                                input-output table rowErrors).
           undo,return.
         end.

end procedure.

procedure valida-emissao-vencimento:

    def input-output parameter dt-emissao-par               as date                     no-undo.
    def input-output parameter dt-vencimento-par            as date                     no-undo.
    def       output parameter lg-erro-par                  as logical                  no-undo.
                                                                                  
    define variable lg-ok-aux                         as logical                  no-undo.
    define variable ds-mens-aux                       as character                no-undo.

    if dt-emissao-par = ?
    then assign dt-emissao-par = today.

    /*-----------------------------------------
    * rotina para verificar a data de emissao
    *-----------------------------------------*/
   /* run rtp/rtfpdtmv.p(input dt-emissao-par,
                       input yes,
                       output ds-mens-aux,
                       output lg-ok-aux).

    if not lg-ok-aux
    then do:
           assign lg-erro-par = yes.

           run insertOtherError(input 0,
                                input "Erro rtfpdtmv.p: " + ds-mens-aux ,
                                input "",
                                input "GP",
                                input "E",
                                input "",
                                input-output table rowErrors).
           undo,return.
         end.*/


     find tipovenc
          where tipovenc.cd-tipo-vencimento = cd-tipo-vencimento-aux
                no-lock no-error.

     if not avail tipovenc
     then do:
            run insertErrorGP(input 0530,
                              input "Tipo de Vencimento: " + string(cd-tipo-vencimento-aux),
                              input "",
                              input-output table rowErrors).
            undo, return.
          end.


     if dt-vencimento-par = ?
     then do:
             /* ----------------- RT - DATA DE VENCIMENTO --- */
             run rtp/rtdtvenc.p(input  ep-codigo-aux,
                                input  cod-estabel-aux,
                                input  dd-vencimento-aux,
                                input  dt-emissao-par,
                                input-output dt-vencimento-par,
                                input  mm-ref-aux,
                                input  aa-ref-aux,
                                input  cd-tipo-vencimento-aux,
                                output lg-erro-par,
                                output ds-mens-aux).
             
             if lg-erro-par
             then do:
                    run insertOtherError(input 0,
                                         input ds-mens-aux,
                                         input "",
                                         input "GP",
                                         input "E",
                                         input "",
                                         input-output table rowErrors).
                    undo,return.
                  end.
             
             if dt-vencimento-aux < dt-emissao-aux
             then do:
                    assign lg-erro-par = yes.
             
                    run insertOtherError(input 0,
                                         input "Data de vencimento menor que data de emissao. Data venc.: " + string(dt-vencimento-aux) + "  Data emissao: " + string(dt-emissao-aux),
                                         input "",
                                         input "GP",
                                         input "E",
                                         input "",
                                         input-output table rowErrors).
                    undo,return.
                  end.     
          end.

end procedure.

procedure trata-faturamento-periodico:

  def input  parameter aa-ref-par    as int                                 no-undo.
  def input  parameter mm-ref-par    as int                                 no-undo.
  def output parameter lg-erro-par   as log                                 no-undo.

  def var   aa-mm-aux                as int                                 no-undo. 

  assign nr-periodicidade-meses-aux = 0
         in-faturar-aux             = 1.

  /* ------------------------------------------------------------------------ */
  if avail ter-ade
  then assign aa-ult-fat-period-aux = ter-ade.aa-ult-fat-period
              mm-ult-fat-period-aux = ter-ade.mm-ult-fat-period.
  
  if not avail ter-ade
  or ter-ade.aa-ult-fat-period = 0
  or ter-ade.mm-ult-fat-period = 0
  then assign aa-mm-aux = int(string(aa-ref-par,"9999") +
                              string(mm-ref-par,"99")).
  else assign aa-mm-aux = int(string(ter-ade.aa-ult-fat-period,"9999") +
                              string(ter-ade.mm-ult-fat-period,"99")).
  
  /* --------------------------------------- BUSCA PERIODICIDADE DO TERMO --- */
  if avail ter-ade
  then do:

         find first perftter
               where perftter.cd-modalidade = ter-ade.cd-modalidade
                 and perftter.nr-ter-adesao = ter-ade.nr-ter-adesao
                 and perftter.aa-mm-fim-validade >= aa-mm-aux
                     no-lock no-error.
         
         if not avail perftter
         then find first perftter 
                   where perftter.cd-modalidade      = ter-ade.cd-modalidade
                     and perftter.nr-ter-adesao      = ter-ade.nr-ter-adesao
                     and perftter.aa-mm-fim-validade = 0
                         no-lock no-error.
       end.
       
  if avail perftter
  then assign nr-periodicidade-meses-aux = perftter.nr-periodicidade-meses
              in-faturar-aux             = perftter.in-faturar.  
  else do:
         /* ------------------------ BUSCA PERIODICIDADE DO TIPO DE PLANO --- */
         find first perftpl
              where perftpl.cd-modalidade       = propost.cd-modalidade
                and perftpl.cd-plano            = propost.cd-plano
                and perftpl.cd-tipo-plano       = propost.cd-tipo-plano
                and perftpl.aa-mm-fim-validade >= aa-mm-aux
                    no-lock no-error.

         if not avail perftpl
         then find first perftpl
                   where perftpl.cd-modalidade      = propost.cd-modalidade
                     and perftpl.cd-plano           = propost.cd-plano
                     and perftpl.cd-tipo-plano      = propost.cd-tipo-plano
                     and perftpl.aa-mm-fim-validade = 0
                         no-lock no-error.
         
         if avail perftpl
         then assign nr-periodicidade-meses-aux = perftpl.nr-periodicidade-meses
                     in-faturar-aux             = perftpl.in-faturar.
         else assign nr-periodicidade-meses-aux = 0
                     in-faturar-aux             = 1.
       end.
end procedure.


procedure encontra-prox-faturamento:
    def output parameter aa-prox-fat-par          as integer                  no-undo.
    def output parameter mm-prox-fat-par          as integer                  no-undo.
    def output parameter lg-erro-par              as logical                  no-undo.
                                                                              
    def var ix-aux                                as int init 0               no-undo.

    if propost.cd-sit-proposta = 5
    then return.

    assign aa-prox-fat-par = ter-ade.aa-ult-fat-period
           mm-prox-fat-par = ter-ade.mm-ult-fat-period.

    do ix-aux = 1 to nr-periodicidade-meses-aux:
        if mm-prox-fat-par = 12
        then assign mm-prox-fat-par = 1
                    aa-prox-fat-par = aa-prox-fat-par + 1.
        else assign mm-prox-fat-par = mm-prox-fat-par + 1.
    end.

end procedure.

procedure ver-perc-prop.

    /*----------------------------------------------------------
     * testa se a data de validade dos percentuais
     * e maior ou igual ao ano e mes referencia do faturamento.
     * Se a data de validade ja tiver vencido os percentuais
     * serao considerados como 0 (zeros)
     *----------------------------------------------------------*/
    def var lg-ok-aux                       as log          no-undo.
    
    run testar-data-lim(propost.dt-lim-acres-mens,output lg-ok-aux).
    if lg-ok-aux
    then assign pc-acrescimo-aux     = propost.pc-acrescimo.
    else assign pc-acrescimo-aux     = 0.
    
    run testar-data-lim(propost.dt-lim-desc-mens,output lg-ok-aux).
    if lg-ok-aux
    then assign pc-desconto-aux     = propost.pc-desconto.
    else assign pc-desconto-aux     = 0.
    
    run testar-data-lim(propost.dt-lim-acres-inscr,output lg-ok-aux).
    if lg-ok-aux
    then assign pc-acrescimo-insc-aux     = propost.pc-acrescimo-insc.
    else assign pc-acrescimo-insc-aux     = 0.
    
    run testar-data-lim(propost.dt-lim-desc-inscr,output lg-ok-aux).
    if lg-ok-aux
    then assign pc-desconto-insc-aux     = propost.pc-desconto-insc.
    else assign pc-desconto-insc-aux     = 0.
    
    run testar-data-lim(propost.dt-val-prom-pl,output lg-ok-aux).
    if lg-ok-aux
    then assign pc-desc-prom-pl-aux     = propost.pc-desc-prom-pl.
    else assign pc-desc-prom-pl-aux     = 0.
    
end.

/* ----------------------------------------------------------------------------------- */
procedure testar-data-lim.

    def input   parameter     dt-lim-par                as date     no-undo.
    def output  parameter     lg-ok-par                 as log      no-undo.
    
    if string(year(dt-lim-par),"9999") + string(month(dt-lim-par),"99") >= string(aa-ref-aux,"9999") + string(mm-ref-aux,"99")
    then assign lg-ok-par = yes.
    else assign lg-ok-par = no.

end procedure.

procedure calcula-meses-faturados:

    def var dt-pri-fat as date no-undo.
    def var dt-ref-fat as date no-undo.

    /*notaserv pela modalidade, termo e tipo de nota, onde o tipo de nota tem que ser 0 ou 5.*/
    for first notaserv fields (aa-referencia 
                               mm-referencia)
        where notaserv.cd-modalidade = propost.cd-modalidade
          and notaserv.nr-ter-adesao = propost.nr-ter-adesao   
          and (notaserv.in-tipo-nota = 0
               or notaserv.in-tipo-nota = 5 
              ) no-lock:
                       assign dt-pri-fat = date(notaserv.mm-referencia,1,notaserv.aa-referencia)
                              dt-ref-fat = date(mm-referencia-aux,1,aa-referencia-aux).
                       assign qt-meses-faturados-aux = interval(dt-ref-fat, dt-pri-fat,"months").
         end. /*for first notaserv*/
end.   


procedure busca-regra-mensalidade:
    def output parameter cdd-regra-mens-par  as dec         no-undo. 
    def output parameter dt-inicio-regra-par as date        no-undo. 

    for first regra-menslid-propost fields(regra-menslid-propost.cdd-regra
                                           regra-menslid-propost.dt-ini-validade)
                                     where regra-menslid-propost.cd-modalidade    = propost.cd-modalidade
                                       and regra-menslid-propost.nr-proposta      = propost.nr-proposta 
                                       and regra-menslid-propost.cd-usuario       = 0
                                       and regra-menslid-propost.dt-ini-validade <= dt-referencia-aux           
                                       and regra-menslid-propost.dt-fim-validade >= dt-referencia-aux no-lock: 

       assign cdd-regra-mens-par  = regra-menslid-propost.cdd-regra
              dt-inicio-regra-par = regra-menslid-propost.dt-ini-validade.
    end.       
end procedure.

procedure p-faixa-etaria-modulo:
    def var nr-idade-busca-aux               as int                 no-undo.

    assign nr-faixa-etaria-atu = 0. 

    run verificar-trfaixa.
    assign nr-idade-busca-aux = nr-idade-atu.

    if nr-idade-busca-aux > nr-idade-sem-reaj-aux
    and nr-idade-sem-reaj-aux <> 0
    then assign nr-idade-busca-aux = nr-idade-sem-reaj-aux.

    if usuario.cd-sit-usuario = 5
    then assign nr-idade-busca-aux = nr-idade-inc.

    if  nr-idade-busca-aux > nr-idade-exc 
    and nr-idade-exc       > 0  
    then assign nr-idade-busca-aux = nr-idade-exc.

    put unform skip.
    put unform 'BUSCA REGRA'.

    put unform " idade:" nr-idade-busca-aux . 
    put unform " regra:" cdd-regra-usuario-aux.
    put unform " grau:" usuario.cd-grau-parentesco.
    put unform " dat:" dt-referencia-aux . 

    for first regra-menslid-criter fields (regra-menslid-criter.cdd-regra        
                                           regra-menslid-criter.cd-modulo        
                                           regra-menslid-criter.nr-idade-minima  
                                           regra-menslid-criter.nr-idade-maxima  
                                           regra-menslid-criter.cd-grau-parentesco
                                           regra-menslid-criter.dat-inic
                                           regra-menslid-criter.dat-fim
                                           regra-menslid-criter.cd-padrao-cobertura
                                           regra-menslid-criter.nr-faixa-etaria )         
                                   where regra-menslid-criter.cdd-regra               = cdd-regra-usuario-aux 
                                     and regra-menslid-criter.cd-modulo               = tmp-evento-fat.cd-modulo
                                     and regra-menslid-criter.nr-idade-minima        <= nr-idade-busca-aux
                                     and regra-menslid-criter.nr-idade-maxima        >= nr-idade-busca-aux
                                     and (   regra-menslid-criter.cd-grau-parentesco  = usuario.cd-grau-parentesco
                                          or regra-menslid-criter.cd-grau-parentesco  = 0)
                                     and regra-menslid-criter.dat-inic               <= dt-referencia-aux
                                     and regra-menslid-criter.dat-fim                >= dt-referencia-aux
                                     and (   regra-menslid-criter.cd-padrao-cobertura = usuario.cd-padrao-cobertura
                                          or regra-menslid-criter.cd-padrao-cobertura = "") no-lock
                                    break by regra-menslid-criter.cd-grau-parentesco  desc
                                          by regra-menslid-criter.cd-padrao-cobertura desc: 
        assign nr-faixa-etaria-atu  = regra-menslid-criter.nr-faixa-etaria.
    end.

    put unform " faixa:" nr-faixa-etaria-atu.  
end procedure. 

procedure p-valor-modulo:
    def var lg-aplicou-reajuste-aux          as log                 no-undo. 
    def var aa-mm-ult-reaj-benef-aux         as char                no-undo. 
    def var ft-reajuste-preco-aux            as dec                 no-undo. 
    def var dt-inicio-criterio-aux           as date                no-undo.
    def var dt-calc-reaj-aux                 as date                no-undo. 

    assign vl-modulo-aux  = 0
           vl-tx-insc-aux = 0.

    put unform skip. 
    put unform "DETALHAMENTO PRECO" skip. 

    for first regra-menslid-criter fields (regra-menslid-criter.cdd-regra   
                                           regra-menslid-criter.cdd-id
                                           regra-menslid-criter.cd-modulo 
                                           regra-menslid-criter.nr-faixa-etaria
                                           regra-menslid-criter.num-livre-1
                                           regra-menslid-criter.num-livre-2 
                                           regra-menslid-criter.vl-mensalidade-base 
                                           regra-menslid-criter.vl-taxa-inscricao   
                                           regra-menslid-criter.qt-repasse )
                                   where regra-menslid-criter.cdd-regra        = tmp-evento-benef.cdd-regra  
                                     and regra-menslid-criter.cd-modulo        = tmp-evento-benef.cd-modulo
                                     and regra-menslid-criter.nr-faixa-etaria  = tmp-evento-benef.nr-faixa-etaria
                                     and (   regra-menslid-criter.cd-grau-parentesco  = tmp-evento-benef.cd-grau-parentesco
                                          or regra-menslid-criter.cd-grau-parentesco  = 0)
                                     and regra-menslid-criter.dat-inic               <= dt-referencia-aux
                                     and regra-menslid-criter.dat-fim                >= dt-referencia-aux
                                     and (   regra-menslid-criter.cd-padrao-cobertura = tmp-evento-benef.cd-padrao-cobertura
                                          or regra-menslid-criter.cd-padrao-cobertura = "")
                                     and regra-menslid-criter.num-livre-1     <= qt-usu-aux
                                     and regra-menslid-criter.num-livre-2     >= qt-usu-aux no-lock:

        assign vl-modulo-aux              = regra-menslid-criter.vl-mensalidade-base
               vl-tx-insc-aux             = regra-menslid-criter.vl-taxa-inscricao
               qt-fat-repasse-aux         = regra-menslid-criter.qt-repasse
               tmp-evento-benef.id-criter = regra-menslid-criter.cdd-id
               dt-inicio-criterio-aux     = regra-menslid-criter.dat-inic.
    end.
    put unform " regra:" tmp-evento-benef.cdd-regra.
    put unform " faixa:" tmp-evento-benef.nr-faixa-etaria  .
    put unform " data:" dt-referencia-aux. 

    put unform " usuario:" tmp-evento-benef.cd-usuario.
    put unform " modulo:"  tmp-evento-benef.cd-modulo.
    put unform " valor:"   vl-modulo-aux.
 

    assign ft-reajuste-preco-aux = 1.
    for each regra-menslid-reaj where regra-menslid-reaj.cdd-regra = tmp-evento-benef.cdd-regra 
                                  and regra-menslid-reaj.log-livre-1 = yes 
                                  and (   regra-menslid-reaj.cd-modulo = tmp-evento-benef.cd-modulo 
                                       or regra-menslid-reaj.cd-modulo = 0) no-lock
                                break by regra-menslid-reaj.aa-mm-referencia
                                      by regra-menslid-reaj.cd-modulo   desc:

        assign dt-calc-reaj-aux = date(int(substring(regra-menslid-reaj.aa-mm-referencia, 5, 2)),   
                                  01,                                                               
                                  int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))).


        /*desconsidera ajustes de preco realizados em periodo anterior ao periodo de utilizacao da regra no contrato*/
        if tmp-evento-benef.dt-inicio-regra < dt-calc-reaj-aux
        then next.

        /*desconsidera ajustes de preco realizado com data anterior a data de validade do criterio*/
        if dt-inicio-criterio-aux > dt-calc-reaj-aux
        then next.

        if first-of(regra-menslid-reaj.aa-mm-referencia)
        then assign ft-reajuste-preco-aux = ft-reajuste-preco-aux * (1 + (regra-menslid-reaj.perc-reaj / 100)).
    end.

    assign vl-modulo-aux = vl-modulo-aux * ft-reajuste-preco-aux.

    /*verifica se o reajuste da proposta ‚ definido pela regra 
      e se a regra do usuario eh diferente da proposta para recalcular todo o reajuste.*/
    if   not propost.log-13 
    and  tmp-evento-benef.cdd-regra <> cdd-regra-proposta-aux  
    then do:
            assign aa-mm-ult-reaj-benef-aux = "".

            for each histor-preco-benef-modul fields( histor-preco-benef-modul.cd-modalidad
                                                      histor-preco-benef-modul.nr-proposta 
                                                      histor-preco-benef-modul.cd-usuario  
                                                      histor-preco-benef-modul.cd-modulo   
                                                      histor-preco-benef-modul.aa-reajuste 
                                                      histor-preco-benef-modul.num-sit-reaj
                                                      histor-preco-benef-modul.pc-reajuste)
                                              where histor-preco-benef-modul.cd-modalidade = usuario.cd-modalidade 
                                                and histor-preco-benef-modul.nr-proposta   = usuario.nr-proposta   
                                                and histor-preco-benef-modul.cd-usuario    = usuario.cd-usuario  
                                                and histor-preco-benef-modul.cd-modulo     = tmp-evento-benef.cd-modulo
                                                and histor-preco-benef-modul.aa-reajuste  <= aa-ref-aux
                                                and histor-preco-benef-modul.num-sit-reaj  <> 2 
                                                no-lock break by histor-preco-benef-modul.aa-reajuste desc
                                                              by histor-preco-benef-modul.num-mes-reaj desc:

                if aa-mm-ult-reaj-aux = ""
                then assign aa-mm-ult-reaj-benef-aux = string(histor-preco-benef-modul.aa-reajuste, "9999") + string(histor-preco-benef-modul.num-mes-reaj, "99"). 
                
                if  histor-preco-benef-modul.aa-reajuste = aa-ref-aux
                and histor-preco-benef-modul.num-mes-reaj > mm-ref-aux
                then next. 

                find tmp-reajuste-benef where tmp-reajuste-benef.aa-reajuste = histor-preco-benef-modul.aa-reajuste     
                                          and tmp-reajuste-benef.mm-reajuste = histor-preco-benef-modul.num-mes-reaj    
                                          and tmp-reajuste-benef.cd-usuario  = histor-preco-benef-modul.cd-usuario  
                                          and tmp-reajuste-benef.cd-modulo   = histor-preco-benef-modul.cd-modulo no-lock no-error.
                if not avail tmp-reajuste-benef
                then do:
                        create tmp-reajuste-benef.
                        assign tmp-reajuste-benef.aa-reajuste = histor-preco-benef-modul.aa-reajuste        
                               tmp-reajuste-benef.mm-reajuste = histor-preco-benef-modul.num-mes-reaj        
                               tmp-reajuste-benef.cd-usuario  = histor-preco-benef-modul.cd-usuario         
                               tmp-reajuste-benef.pc-reajuste = histor-preco-benef-modul.pc-reajuste    
                               tmp-reajuste-benef.cd-modulo   = histor-preco-benef-modul.cd-modulo. 
                     end.
            end.

            for each histabprecobenef fields (histabprecobenef.cd-modalidade 
                                              histabprecobenef.nr-proposta   
                                              histabprecobenef.cd-usuario    
                                              histabprecobenef.aa-reajuste 
                                              histabprecobenef.mm-reajuste 
                                              histabprecobenef.num-sit-reaj  
                                              histabprecobenef.pc-reajuste)
                                      where histabprecobenef.cd-modalidade  = usuario.cd-modalidade 
                                        and histabprecobenef.nr-proposta    = usuario.nr-proposta
                                        and histabprecobenef.cd-usuario     = usuario.cd-usuario 
                                        and histabprecobenef.aa-reajuste   <= aa-ref-aux
                                        and histabprecobenef.num-sit-reaj  <> 2 no-lock:

                if aa-mm-ult-reaj-aux = ""
                then assign aa-mm-ult-reaj-benef-aux = string(histabprecobenef.aa-reajuste, "9999") + string(histabprecobenef.mm-reajuste, "99"). 

                if  histabprecobenef.aa-reajuste = aa-ref-aux
                and histabprecobenef.mm-reajuste > mm-ref-aux
                then next.

                find tmp-reajuste-benef where tmp-reajuste-benef.aa-reajuste = histabprecobenef.aa-reajuste     
                                          and tmp-reajuste-benef.mm-reajuste = histabprecobenef.mm-reajuste    
                                          and tmp-reajuste-benef.cd-usuario  = histabprecobenef.cd-usuario  
                                          and tmp-reajuste-benef.cd-modulo   = 0 no-lock no-error.
                if not avail tmp-reajuste-benef
                then do:
                        create tmp-reajuste-benef.
                        assign tmp-reajuste-benef.aa-reajuste = histabprecobenef.aa-reajuste        
                               tmp-reajuste-benef.mm-reajuste = histabprecobenef.mm-reajuste        
                               tmp-reajuste-benef.cd-usuario  = histabprecobenef.cd-usuario         
                               tmp-reajuste-benef.pc-reajuste = histabprecobenef.pc-reajuste    
                               tmp-reajuste-benef.cd-modulo   = 0.
                     end.
            end.

            if aa-mm-ult-reaj-benef-aux < aa-mm-ref-aux /*somente se o ano e mes do ultimo reajuste do contrato for menor que o periodo*/
            then for each regra-menslid-reaj fields (regra-menslid-reaj.cdd-regra       
                                                     regra-menslid-reaj.aa-mm-referencia
                                                     regra-menslid-reaj.cd-modulo       
                                                     regra-menslid-reaj.ind-reaj-contrat
                                                     regra-menslid-reaj.perc-reajuste)
                                             where regra-menslid-reaj.cdd-regra         = tmp-evento-benef.cdd-regra
                                               and regra-menslid-reaj.aa-mm-referencia  > aa-mm-ult-reaj-benef-aux 
                                               and regra-menslid-reaj.log-livre-1       = no no-lock:
            
                     if regra-menslid-reaj.aa-mm-referencia > aa-mm-ref-aux
                     then next. 
            
                     if regra-menslid-reaj.ind-reaj-contrat = "C"
                     then do:
                             /*
                                Se o mes de inicio do plano for menor que o mes de referencia do faturamento 
                                ou o ano do ultimo reajuste for menor que o ano do faturamento 
                             */
                             if  (month(ter-ade.dt-inicio) < mm-ref-aux
                                 or int(substring(aa-mm-ult-reaj-benef-aux,1,4)) < aa-ref-aux)
                             then do:
                                      create tmp-reajuste-benef.
                                      assign tmp-reajuste-benef.aa-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))
                                             tmp-reajuste-benef.mm-reajuste = month(ter-ade.dt-inicio)
                                             tmp-reajuste-benef.pc-reajuste = regra-menslid-reaj.perc-reajuste
                                             tmp-reajuste-benef.cd-usuario  = tmp-evento-benef.cd-usuario
                                             tmp-reajuste-benef.cd-modulo   = regra-menslid-reaj.cd-modulo
                                             tmp-reajuste-benef.lg-criar    = yes.
                                  end.
                          end.
                     else do:
                             create tmp-reajuste-benef.
                             assign tmp-reajuste-benef.aa-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))
                                    tmp-reajuste-benef.mm-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 5, 2))
                                    tmp-reajuste-benef.pc-reajuste = regra-menslid-reaj.perc-reajuste
                                    tmp-reajuste-benef.cd-usuario  = tmp-evento-benef.cd-usuario
                                    tmp-reajuste-benef.cd-modulo   = regra-menslid-reaj.cd-modulo
                                    tmp-reajuste-benef.lg-criar    = yes.
                          end.
                 end.


                 for each tmp-reajuste-benef where  tmp-reajuste-benef.cd-usuario = tmp-evento-benef.cd-usuario
                                               and (tmp-reajuste-benef.cd-modulo  = tmp-evento-benef.cd-modulo or tmp-reajuste-benef.cd-modulo = 0)
                          no-lock break by tmp-reajuste-benef.aa-reajuste
                                        by tmp-reajuste-benef.mm-reajuste
                                        by tmp-reajuste-benef.cd-modulo  desc:

                     if first-of(tmp-reajuste-benef.aa-reajuste)  
                     then assign vl-modulo-aux = vl-modulo-aux + (vl-modulo-aux * (tmp-reajuste-benef.pc-reajuste / 100)). 
                 end.
         end.
    else do:
             /*le todos os registros da temp de reajuste para o modulo ou setado todos os modulos. 
               Ordena de forma decrescente o modulo para pegar o registro mais especifico. */
             for each tmp-reajuste where tmp-reajuste.cd-modulo = tmp-evento-benef.cd-modulo
                                      or tmp-reajuste.cd-modulo = 0
                          no-lock break by tmp-reajuste.aa-reajuste
                                        by tmp-reajuste.mm-reajuste
                                        by tmp-reajuste.cd-modulo  desc:

                 assign dt-calc-reaj-aux = date(tmp-reajuste.mm-reajuste, 01, tmp-reajuste.aa-reajuste).


                 /*
                   se a data de inicio do reajuste for menor que o inicio do criterio ou menor que o inicio da utilizacao 
                   da regra pela proposta - desconsidera o reajuste.
                 */
                 if dt-calc-reaj-aux < dt-inicio-criterio-aux 
                 or dt-calc-reaj-aux < tmp-evento-benef.dt-inicio-regra
                 then next.
                 
                 if first-of(tmp-reajuste.aa-reajuste)  
                 or first-of(tmp-reajuste.mm-reajuste)  
                 then do:
                         assign lg-aplicou-reajuste-aux = no. 

                         /*verifica se existe rejuste por benefici rio, se existir considera este*/
                         for last histabprecobenef fields (histabprecobenef.cd-modalidade 
                                                           histabprecobenef.nr-proposta   
                                                           histabprecobenef.cd-usuario    
                                                           histabprecobenef.aa-reajuste 
                                                           histabprecobenef.mm-reajuste 
                                                           histabprecobenef.num-sit-reaj  
                                                           histabprecobenef.pc-reajuste)
                                                   where histabprecobenef.cd-modalidade  = propost.cd-modalidade 
                                                     and histabprecobenef.nr-proposta    = propost.nr-proposta
                                                     and histabprecobenef.cd-usuario     = tmp-evento-benef.cd-usuario
                                                     and histabprecobenef.aa-reajuste    = tmp-reajuste.aa-reajuste
                                                     and histabprecobenef.num-sit-reaj  <> 2 no-lock:

                              assign lg-aplicou-reajuste-aux = yes. 

                              if  histabprecobenef.aa-reajuste >= aa-ref-aux
                              and histabprecobenef.mm-reajuste >  mm-ref-aux 
                              then leave. 

                              assign vl-modulo-aux = vl-modulo-aux + (vl-modulo-aux * (histabprecobenef.pc-reajuste / 100)).
                         end.

                         if lg-aplicou-reajuste-aux
                         then next. 

                         /*verifica se existe reajuste por grau de parentesco*/
                         for last histabprecogr fields (histabprecogr.cd-modalidade     
                                                        histabprecogr.nr-proposta       
                                                        histabprecogr.cd-grau-parentesco
                                                        histabprecogr.aa-reajuste       
                                                        histabprecogr.num-sit-reaj 
                                                        histabprecogr.mm-reajuste
                                                        histabprecogr.pc-reajuste)
                                               where histabprecogr.cd-modalidade      = usuario.cd-modalidade 
                                                 and histabprecogr.nr-proposta        = usuario.nr-proposta
                                                 and histabprecogr.cd-grau-parentesco = usuario.cd-grau-parentesco
                                                 and histabprecogr.aa-reajuste        = tmp-reajuste.aa-reajuste
                                                 and histabprecogr.num-sit-reaj       <> 2 no-lock:

                             assign lg-aplicou-reajuste-aux = yes. 

                             if  histabprecogr.aa-reajuste >= aa-ref-aux
                             and histabprecogr.mm-reajuste > mm-ref-aux 
                             then leave. 

                             assign vl-modulo-aux = vl-modulo-aux + (vl-modulo-aux * (histabprecogr.pc-reajuste / 100)).
                         end.

                       if lg-aplicou-reajuste-aux
                       then next. 
                       
                       assign vl-modulo-aux = vl-modulo-aux + (vl-modulo-aux * (tmp-reajuste.pc-reajuste / 100)). 
                    end.
             end.
         end.


         

  if tmp-evento-fat.in-classe-evento = "C"
  then assign tmp-evento-benef.vl-evento = round(vl-tx-insc-aux 
                                         * ((100 +  pc-acrescimo-insc-aux) / 100)
                                         * ((100 -  pc-desconto-insc-aux ) / 100), 2).
  else assign tmp-evento-benef.vl-evento = round(vl-modulo-aux 
                                         * ((100 +  pc-acrescimo-aux) / 100)
                                         * ((100 -  pc-desconto-aux ) / 100), 2).

  put unform " VL-EVENTO:" tmp-evento-benef.vl-evento.

end procedure.


procedure verificar-trfaixa:

    def var dt-ref-reajuste-aux     as date                      no-undo.

    /*------------ idade base inclusao -------------*/
    run calc-idade(input  parafatu.in-forma-calc-troca-faixa,
                   input   year(usuario.dt-inclusao-plano),
                   input  month(usuario.dt-inclusao-plano),
                   input   year(usuario.dt-nascimento),
                   input  month(usuario.dt-nascimento),
                   output nr-idade-inc). 
    
    /*------------ idade base mes anterior -------------*/
    run calc-idade(input  parafatu.in-forma-calc-troca-faixa,
                   input   year(dt-ref-ant-aux),
                   input  month(dt-ref-ant-aux),
                   input   year(usuario.dt-nascimento),
                   input  month(usuario.dt-nascimento),
                   output nr-idade-ant). 
     
    /*------------ idade base parametros --------------*/
    run calc-idade(input  parafatu.in-forma-calc-troca-faixa,
                   input  aa-ref-aux,
                   input  mm-ref-aux,
                   input   year(usuario.dt-nascimento),
                   input  month(usuario.dt-nascimento),
                   output nr-idade-atu).
    
    /*------------ idade base exclusao ---------------*/
    run calc-idade(input  parafatu.in-forma-calc-troca-faixa,
                   input   year(usuario.dt-exclusao-plano),
                   input  month(usuario.dt-exclusao-plano),
                   input   year(usuario.dt-nascimento),
                   input  month(usuario.dt-nascimento),
                   output nr-idade-exc).
    
    /* ------------- idade base antes sem-reajuste ------- */
    if int(substr(string(usuario.aa-mm-sem-reaj-troca-fx),5,2)) = 0
    or propost.lg-prop-regulamentada = no
    then return.

    assign dt-ref-reajuste-aux = date(int(substr(string(usuario.aa-mm-sem-reaj-troca-fx),5,2)),
                                   01,int(substr(string(usuario.aa-mm-sem-reaj-troca-fx),1,4))).
    
    if dt-ref-reajuste-aux <= date(mm-ref-aux,01,aa-ref-aux)
    then run calc-idade(input  parafatu.in-forma-calc-troca-faixa,
                        input  year(dt-ref-reajuste-aux - 1),
                        input  month(dt-ref-reajuste-aux - 1),
                        input  year(usuario.dt-nascimento),
                        input  month(usuario.dt-nascimento),
                        output nr-idade-sem-reaj-aux).

end procedure.

/*------------------------------------------------------------
 * PROCEDURE que calcula a idade conforme a data de referencia
 * e o parametro de troca de faixa indicado no parafatu
 *----------------------------------------------------------*/
procedure calc-idade:

    def input parameter  inc-forma-calc-par as char format "x(2)" no-undo.
    def input parameter  ano-par            as int format "9999"  no-undo.
    def input parameter  mes-par            as int format "99"    no-undo.
    def input parameter  ano-nasc-par       as int format "9999"  no-undo.
    def input parameter  mes-nasc-par       as int format "99"    no-undo.
    def output parameter nr-idade-par       as int                no-undo.
    
    nr-idade-par = ano-par - ano-nasc-par.
    
    if nr-idade-par = 0
    then return.
    
    /*--------------------------------------------
     * Verifica se deve trocar de faixa no mes de
     * aniversario ou no mes subsequente
     * conforme parametro no parafatu
     *------------------------------------------*/
    case inc-forma-calc-par:
         when "0" then if mes-nasc-par >= mes-par
                       then assign nr-idade-par = nr-idade-par - 1.
    
         when "1" then if mes-nasc-par > mes-par
                       then assign nr-idade-par = nr-idade-par - 1.
    end case.

end procedure.

procedure  retorna-dt-inc-exc-usuario:
    def output parameter dt-exc-usu-par as date             no-undo. 
    def output parameter dt-inc-usu-par as date             no-undo. 


    /*---------------------------------------------------
     * alteracao para armazenar os usuarios incluidos
     * a mais de 3 meses com uma data unica
     *--------------------------------------------------*/
    assign dt-exc-usu-par = usuario.dt-exclusao-plano.

    if dt-exc-usu-par < date(mm-ref-aux,01,aa-ref-aux) - 95
    and usuario.cd-sit-usuario > 5
    then do:
         assign dt-exc-usu-par = date(mm-ref-aux,01,aa-ref-aux) - 95
                dt-exc-usu-par = date(month(dt-exc-usu-par),01,year(dt-exc-usu-par)) - 1.
    end.

    /*---------------------------------------------------
     * alteracao para armazenar os usuarios incluidos
     * a mais de 3 meses com uma data unica
     *--------------------------------------------------*/
    assign dt-inc-usu-par       = usuario.dt-inclusao-plano.
    
    if dt-inc-usu-par < date(mm-ref-aux,01,aa-ref-aux) - 95
    and usuario.cd-sit-usuario > 5
    then do:
            assign dt-inc-usu-par = date(mm-ref-aux,01,aa-ref-aux) - 95
                   dt-inc-usu-par = date(month(dt-inc-usu-par),01,year(dt-inc-usu-par)).
         end.

end procedure. 

procedure fator-usuario.
                     
end procedure.


procedure desc-acresc-programado:

   assign pc-negociacao-mens-aux   = 0
          pc-negociacao-ins-aux    = 0.

   for first prognego fields (prognego.cd-modalidade
                              prognego.nr-ter-adesao
                              prognego.aa-referencia
                              prognego.mm-referencia
                              prognego.lg-cred-deb-mens  
                              prognego.pc-negociacao-mens
                              prognego.lg-cred-deb-insc  
                              prognego.pc-negociacao-ins)
        where prognego.cd-modalidade = propost.cd-modalidade
          and prognego.nr-ter-adesao = propost.nr-ter-adesao
          and prognego.aa-referencia = aa-ref-aux
          and prognego.mm-referencia = mm-ref-aux no-lock:

        assign lg-cred-deb-mens-aux     = prognego.lg-cred-deb-mens
               pc-negociacao-mens-aux   = prognego.pc-negociacao-mens
               lg-cred-deb-insc-aux     = prognego.lg-cred-deb-insc
               pc-negociacao-ins-aux    = prognego.pc-negociacao-ins.
   end.

end procedure.

procedure verifica-reajuste-contrato:

    /*Verifica reajuste a nivel de contrato*/
    for each histabpreco fields (histabpreco.cd-modalidade
                                 histabpreco.nr-proposta  
                                 histabpreco.aa-reajuste  
                                 histabpreco.int-4 
                                 histabpreco.mm-reajuste
                                 histabpreco.pc-reajuste)
        where histabpreco.cd-modalidade  = propost.cd-modalidade
          and histabpreco.nr-proposta    = propost.nr-proposta
          and histabpreco.aa-reajuste   <= aa-ref-aux
          and histabpreco.int-4         <> 2 no-lock break by histabpreco.aa-reajuste desc
                                                           by histabpreco.mm-reajuste desc:

        if aa-mm-ult-reaj-aux = ""
        then assign aa-mm-ult-reaj-aux = string(histabpreco.aa-reajuste, "9999") + string(histabpreco.mm-reajuste, "99"). 

        if  histabpreco.aa-reajuste = aa-ref-aux
        and histabpreco.mm-reajuste > mm-ref-aux
        then next. 

        create tmp-reajuste.
        assign tmp-reajuste.aa-reajuste = histabpreco.aa-reajuste
               tmp-reajuste.mm-reajuste = histabpreco.mm-reajuste
               tmp-reajuste.pc-reajuste = histabpreco.pc-reajuste.
    end. 


    /* Nao possui reajuste especifico 
       utiliza o definido na regra de mensalidade*/
    if not propost.log-13 
    and aa-mm-ult-reaj-aux < aa-mm-ref-aux /*somente se o ano e mes do ultimo reajuste do contrato for menor que o periodo*/
    then do:
            for each regra-menslid-reaj fields (regra-menslid-reaj.cdd-regra       
                                                regra-menslid-reaj.aa-mm-referencia
                                                regra-menslid-reaj.cd-modulo       
                                                regra-menslid-reaj.ind-reaj-contrat
                                                regra-menslid-reaj.perc-reajuste)
                                        where regra-menslid-reaj.cdd-regra         = cdd-regra-proposta-aux 
                                          and regra-menslid-reaj.aa-mm-referencia  > aa-mm-ult-reaj-aux
                                          and regra-menslid-reaj.cd-modulo         = 0 
                                          and regra-menslid-reaj.log-livre-1       = no no-lock:

                if regra-menslid-reaj.aa-mm-referencia > aa-mm-ref-aux
                then next. 

                if regra-menslid-reaj.ind-reaj-contrat = "C"
                then do:
                        /*
                           Se o mes de inicio do plano for menor que o mes de referencia do faturamento 
                           ou o ano do ultimo reajuste for menor que o ano do faturamento 
                        */
                        if  (month(ter-ade.dt-inicio) < mm-ref-aux
                            or int(substring(aa-mm-ult-reaj-aux,1,4)) < aa-ref-aux)
                        then do:
                                 create tmp-reajuste.
                                 assign tmp-reajuste.aa-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))
                                        tmp-reajuste.mm-reajuste = month(ter-ade.dt-inicio)
                                        tmp-reajuste.pc-reajuste = regra-menslid-reaj.perc-reajuste
                                        tmp-reajuste.lg-criar    = yes.
                             end.

                     end.
                else do:
                        create tmp-reajuste.
                        assign tmp-reajuste.aa-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))
                               tmp-reajuste.mm-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 5, 2))
                               tmp-reajuste.pc-reajuste = regra-menslid-reaj.perc-reajuste
                               tmp-reajuste.lg-criar    = yes.
                     end.
            end.
         end.
end procedure.

procedure verifica-reajuste-modulo:
    aa-mm-ult-reaj-aux = "".
    /* reajuste por modulo */
    for each histor-preco-reaj fields (histor-preco-reaj.cd-modalidade
                                       histor-preco-reaj.nr-proposta  
                                       histor-preco-reaj.aa-reajuste  
                                       histor-preco-reaj.mm-reajuste
                                       histor-preco-reaj.pc-reajuste)
              where histor-preco-reaj.cd-modalidade  = propost.cd-modalidade
                and histor-preco-reaj.nr-proposta    = propost.nr-proposta
                and histor-preco-reaj.aa-reajuste   <= aa-ref-aux
                and histor-preco-reaj.cd-modulo      = tipleven.cd-modulo no-lock
                                                     break by histor-preco-reaj.aa-reajuste  desc
                                                           by histor-preco-reaj.mm-reajuste  desc:
              
        if aa-mm-ult-reaj-aux = ""
        then assign aa-mm-ult-reaj-aux = string(histor-preco-reaj.aa-reajuste, "9999") + string(histor-preco-reaj.mm-reajuste, "99"). 
    
        if  histor-preco-reaj.aa-reajuste = aa-ref-aux
        and histor-preco-reaj.mm-reajuste > mm-ref-aux
        then next. 
    
        create tmp-reajuste.
        assign tmp-reajuste.aa-reajuste = histor-preco-reaj.aa-reajuste
               tmp-reajuste.mm-reajuste = histor-preco-reaj.mm-reajuste
               tmp-reajuste.pc-reajuste = histor-preco-reaj.pc-reajuste
               tmp-reajuste.cd-modulo   = histor-preco-reaj.cd-modulo. 
    end. 


    /* Nao possui reajuste especifico 
       utiliza o definido na regra de mensalidade*/
    if not propost.log-13 
    and aa-mm-ult-reaj-aux < aa-mm-ref-aux /*somente se o ano e mes do ultimo reajuste do contrato for menor que o periodo*/
    then for each regra-menslid-reaj fields (regra-menslid-reaj.cdd-regra       
                                                regra-menslid-reaj.aa-mm-referencia
                                                regra-menslid-reaj.cd-modulo       
                                                regra-menslid-reaj.ind-reaj-contrat
                                                regra-menslid-reaj.perc-reajuste)
                                        where regra-menslid-reaj.cdd-regra         = cdd-regra-proposta-aux 
                                          and regra-menslid-reaj.aa-mm-referencia  > aa-mm-ult-reaj-aux
                                          and regra-menslid-reaj.cd-modulo         = tipleven.cd-modulo
                                          and regra-menslid-reaj.log-livre-1       = no  no-lock:
    
                if regra-menslid-reaj.aa-mm-referencia > aa-mm-ref-aux
                then next. 
    
                if regra-menslid-reaj.ind-reaj-contrat = "C"
                then do:
                        /*
                           Se o mes de inicio do plano for menor que o mes de referencia do faturamento 
                           ou o ano do ultimo reajuste for menor que o ano do faturamento 
                        */
                        if  (month(ter-ade.dt-inicio) < mm-ref-aux
                            or int(substring(aa-mm-ult-reaj-aux,1,4)) < aa-ref-aux)
                        then do:
                                 create tmp-reajuste.
                                 assign tmp-reajuste.aa-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))
                                        tmp-reajuste.mm-reajuste = month(ter-ade.dt-inicio)
                                        tmp-reajuste.pc-reajuste = regra-menslid-reaj.perc-reajuste
                                        tmp-reajuste.cd-modulo   = regra-menslid-reaj.cd-modulo 
                                        tmp-reajuste.lg-criar    = yes.
                             end.
    
                     end.
                else do:
                        create tmp-reajuste.
                        assign tmp-reajuste.aa-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 1, 4))
                               tmp-reajuste.mm-reajuste = int(substring(regra-menslid-reaj.aa-mm-referencia, 5, 2))
                               tmp-reajuste.pc-reajuste = regra-menslid-reaj.perc-reajuste
                               tmp-reajuste.cd-modulo   = regra-menslid-reaj.cd-modulo 
                               tmp-reajuste.lg-criar    = yes.
                     end.
         end.
end procedure.


/* ----------------------------------------------------------------------------------- */
/* ---------------------------------------- CARREGA EVENTO IMPOSTO -- */
procedure carrega-evento-imp:

   empty temp-table tmp-impostos. 
   
   /* -------------------------- VERIFICA IMPOSTOS QUE O CONTRANTE POSSUI --- */
   for each contrimp fields (contrimp.nr-insc-contratante
                             contrimp.dt-vigencia-ini
                             contrimp.dt-vigencia-fim
                             contrimp.cd-imposto
                             contrimp.vl-minimo-retencao)
      where contrimp.nr-insc-contratante = contrat.nr-insc-contratante
        and contrimp.dt-vigencia-ini    <= dt-emissao-aux
        and contrimp.dt-vigencia-fim    >= dt-emissao-aux no-lock:


      /* ----------- VERIFICA EVENTOS POR CONTRATANTE QUE INCIDEM NO IMPOSTO --- */  
      for each evenctrimp fields(evenctrimp.in-entidade        
                               evenctrimp.nr-insc-contratante
                               evenctrimp.cd-imposto  
                               evenctrimp.cd-evento
                               evenctrimp.dt-vigencia-ini    
                               evenctrimp.dt-vigencia-fim
                               evenctrimp.pc-aliquota)    
                        where evenctrimp.in-entidade         = "FT" 
                          and evenctrimp.nr-insc-contratante = contrimp.nr-insc-contratante
                          and evenctrimp.cd-imposto          = contrimp.cd-imposto
                          and evenctrimp.dt-vigencia-ini    <= dt-emissao-aux 
                          and evenctrimp.dt-vigencia-fim    >= dt-emissao-aux no-lock:

          put unform "IMPOSTO"  evenctrimp.cd-evento skip. 



          run grava-tmp-imposto (input evenctrimp.cd-evento,
                                 input evenctrimp.cd-imposto,
                                 input evenctrimp.pc-aliquota). 
      end.

       /* --- VERIFICA EVENTOS POR GRUPO DE CONTRATANTE QUE INCIDEM NO IMPOSTO --- */  
       for each evengrimp fields (evengrimp.in-entidade           
                                  evengrimp.cd-unidade-grupo      
                                  evengrimp.cd-grupo-contratante  
                                  evengrimp.cd-compl-grupo-contrat
                                  evengrimp.cd-imposto            
                                  evengrimp.dt-vigencia-ini       
                                  evengrimp.dt-vigencia-fim       
                                  evengrimp.cd-evento
                                  evengrimp.pc-aliquota)
                          where evengrimp.in-entidade            = "FT" 
                            and evengrimp.cd-unidade-grupo       = contrat.cd-unidade-grupo    
                            and evengrimp.cd-grupo-contratante   = contrat.cd-grupo-contratante   
                            and evengrimp.cd-compl-grupo-contrat = contrat.cd-compl-grupo-contrat 
                            and evengrimp.cd-imposto             = contrimp.cd-imposto
                            and evengrimp.dt-vigencia-ini       <= dt-emissao-aux 
                            and evengrimp.dt-vigencia-fim       >= dt-emissao-aux
                                 no-lock:
           
         run grava-tmp-imposto(input evengrimp.cd-evento,
                               input evengrimp.cd-imposto,
                               input evengrimp.pc-aliquota).
           
       end.

       /* --- VERIFICA EVENTOS QUE INCIDEM NO IMPOSTO --- */  
       for each evenimp fields (evenimp.in-entidade     
                                evenimp.cd-imposto      
                                evenimp.dt-vigencia-ini 
                                evenimp.dt-vigencia-fim 
                                evenimp.cd-evento
                                evenimp.pc-aliquota)
                        where evenimp.in-entidade       = "FT" 
                          and evenimp.cd-imposto        = contrimp.cd-imposto
                          and evenimp.dt-vigencia-ini  <= dt-emissao-aux 
                          and evenimp.dt-vigencia-fim  >= dt-emissao-aux
                               no-lock:
           
                run grava-tmp-imposto(input evenimp.cd-evento,
                                      input evenimp.cd-imposto,
                                      input evenimp.pc-aliquota).
       end.
   end.

   for each tmp-evento-fat no-lock, 
       each tmp-impostos where tmp-impostos.cd-evento = tmp-evento-fat.cd-evento exclusive-lock:

       assign tmp-impostos.vl-base = tmp-impostos.vl-base + tmp-evento-fat.vl-evento.

       put unform tmp-impostos.vl-base skip. 
   end.

   /* EXECUTA CALCULO DO VALOR DOS IMPOSTOS*/
   for each tmp-evento-fat where tmp-evento-fat.in-classe-evento = "F",
       first evenfatu where evenfatu.in-entidade = "FT" 
                        and evenfatu.cd-evento   = tmp-evento-fat.cd-evento no-lock, 
       each tmp-impostos where tmp-impostos.cd-imposto = evenfatu.cd-imposto no-lock:


       if tmp-evento-fat.in-classe-rotina = 0
       then run value("dep/" + tmp-evento-fat.in-programa).
       else run executa-rotina (input nm-rotinas-aux[tmp-evento-fat.in-classe-rotina]).
       put unform tmp-evento-fat.VL-EVENTO skip. 

   end.
end procedure.

procedure grava-tmp-imposto:
   def input parameter cd-evento-par   as int             no-undo.                   
   def input parameter cd-imposto-par  as int             no-undo.                   
   def input parameter pc-aliquota-par as dec             no-undo.  

   find first tmp-impostos
        where tmp-impostos.cd-imposto = cd-imposto-par
          and tmp-impostos.cd-evento  = cd-evento-par 
           no-lock no-error.  

     if not avail tmp-impostos
     then do:
             create tmp-impostos.
             assign tmp-impostos.cd-evento          = cd-evento-par                    
                    tmp-impostos.cd-imposto         = cd-imposto-par                    
                    tmp-impostos.pc-aliquota        = pc-aliquota-par
                    tmp-impostos.vl-minimo-retencao = contrimp.vl-minimo-retencao.
          end.
end procedure.

procedure aplica-desconto-usuario:
   def buffer b-tmp-evento-benef for tmp-evento-benef.
   def buffer b-tmp-evento-fat   for tmp-evento-fat. 
   def var vl-desconto-unit-aux  as dec               no-undo.
   def var vl-descont-tot-aux    as dec               no-undo. 

   assign vl-descont-tot-aux = 0.

   for each tmp-usu-desconto no-lock,
       each tmp-evento-benef where tmp-evento-benef.cd-usuario = tmp-usu-desconto.cd-usuario no-lock,
       first evenfatu where evenfatu.in-entidade = "FT"
                        and evenfatu.cd-evento   = tmp-evento-benef.cd-evento no-lock,
       first tmp-event-desc-menslid where tmp-event-desc-menslid.in-classe-evento = evenfatu.in-classe-evento
                                       or tmp-event-desc-menslid.in-classe-evento = "*" no-lock:

       assign vl-desconto-unit-aux = round(tmp-evento-benef.vl-evento * tmp-usu-desconto.pc-desconto, 2)
              vl-descont-tot-aux   = vl-descont-tot-aux + vl-desconto-unit-aux.

       for first b-tmp-evento-benef where b-tmp-evento-benef.cd-usuario = tmp-usu-desconto.cd-usuario
                                      and b-tmp-evento-benef.cd-evento  = cd-evento-desconto-aux exclusive-lock:
           assign b-tmp-evento-benef.vl-evento     = b-tmp-evento-benef.vl-evento + vl-desconto-unit-aux
                  b-tmp-evento-benef.lg-processado = yes. 
       end.

       if not avail b-tmp-evento-benef
       then do:
               create  b-tmp-evento-benef.
               assign  b-tmp-evento-benef.cd-usuario          = tmp-evento-benef.cd-usuario          
                       b-tmp-evento-benef.cd-grau-parentesco  = tmp-evento-benef.cd-grau-parentesco  
                       b-tmp-evento-benef.cd-evento           = cd-evento-desconto-aux
                       b-tmp-evento-benef.nr-faixa-etaria     = tmp-evento-benef.nr-faixa-etaria     
                       b-tmp-evento-benef.nr-idade-atu        = tmp-evento-benef.nr-idade-atu        
                       b-tmp-evento-benef.cd-sit-usuario      = tmp-evento-benef.cd-sit-usuario      
                       b-tmp-evento-benef.cd-padrao-cobertura = tmp-evento-benef.cd-padrao-cobertura 
                       b-tmp-evento-benef.lg-susp-mes-ant     = tmp-evento-benef.lg-susp-mes-ant     
                       b-tmp-evento-benef.aa-ult-fat          = tmp-evento-benef.aa-ult-fat          
                       b-tmp-evento-benef.mm-ult-fat          = tmp-evento-benef.mm-ult-fat          
                       b-tmp-evento-benef.lg-cobra-insc       = tmp-evento-benef.lg-cobra-insc       
                       b-tmp-evento-benef.ct-nova-via         = tmp-evento-benef.ct-nova-via         
                       b-tmp-evento-benef.ct-transf           = tmp-evento-benef.ct-transf           
                       b-tmp-evento-benef.vl-evento           = vl-desconto-unit-aux
                       b-tmp-evento-benef.lg-processado       = yes.
            end.
   end.

   for first b-tmp-evento-fat where b-tmp-evento-fat.cd-evento = cd-evento-desconto-aux exclusive-lock:
       assign b-tmp-evento-fat.vl-evento = vl-descont-tot-aux
              b-tmp-evento-fat.qt-evento = 1.
   end.
end procedure.

procedure contar-usuario-ativo.
  def input-output parameter lg-erro-par   as log              no-undo.
  assign lg-erro-par = no
         qt-usu-aux  = 0.
 
  for each b-usuario fields(b-usuario.dt-inclusao-plano
                            b-usuario.dt-exclusao-plano)
     where b-usuario.cd-modalidade = propost.cd-modalidade
       and b-usuario.nr-proposta   = propost.nr-proposta 
     no-lock:

        if b-usuario.dt-exclusao-plano = b-usuario.dt-inclusao-plano 
        then next.

        if b-usuario.dt-exclusao-plano = ?
        or b-usuario.dt-exclusao-plano > date(tmp-usu-refer.mm-referencia, 01, 
                                              tmp-usu-refer.aa-referencia) - 1
        then if string(year (b-usuario.dt-inclusao-plano),"9999") +
                string(month(b-usuario.dt-inclusao-plano),"99")  <=
                string(tmp-usu-refer.aa-referencia,"9999")      + 
                string(tmp-usu-refer.mm-referencia,"99")
             then assign qt-usu-aux = qt-usu-aux + 1.
  end.

  if qt-usu-aux = 0
  then do:
           run insertOtherError(input 1654,
                                input "Modalidade: "
                                + string(propost.cd-modalidade)
                                + " Termo: "
                                + string(propost.nr-ter-adesao)
                                + " Referencia: "
                                + string(tmp-usu-refer.mm-referencia)
                                + "/"
                                + string(tmp-usu-refer.aa-referencia),
                               input "",
                               input "GP",
                               input "E",
                               input "",
                               input-output table rowErrors).
         assign lg-erro-par = yes.
         return.
       end.
end procedure.

procedure calcula-referencias:
   def input-output parameter lg-erro-par  as log               no-undo.
   
   /* ------------------------ CARREGA AUXILIARES UTILIZADAS NOS CALCULOS --- */
   assign aa-referencia-aux = tmp-usu-refer.aa-referencia 
          mm-referencia-aux = tmp-usu-refer.mm-referencia
          aa-ref-aux        = tmp-usu-refer.aa-referencia 
          mm-ref-aux        = tmp-usu-refer.mm-referencia
          dt-referencia-aux = date(tmp-usu-refer.mm-referencia, 01, tmp-usu-refer.aa-referencia).

   /* ------------------------------- CALCULA DATA DE REFERENCIA ANTERIOR --- */
   assign dt-ref-ant-aux = date(mm-ref-aux, 01, aa-ref-aux) - 1
          dt-ref-exc     = date(mm-ref-aux, 01, aa-ref-aux) - 1.

   /* --- CALCULA DATA DE INCLUSAO PROGRAMADA COM PRIMEIRO DIA DO MES SEGUINTE -
   ------ A REFERENCIA ------------------------------------------------------ */
   if mm-ref-aux = 12
   then dt-inclusao-programada-aux = date(01,01,aa-ref-aux + 1).
   else dt-inclusao-programada-aux = date(mm-ref-aux + 1, 01, aa-ref-aux).


   assign dt-emissao-aux    = tmp-api-mens-pre-pagamento.dt-emissao
          dt-vencimento-aux = tmp-api-mens-pre-pagamento.dt-vencimento.

   if tmp-api-mens-pre-pagamento.dt-emissao = ?
   then dt-emissao-aux = today. 

   /* --------------------------------------- VERIFICA DATA DE VENCIMENTO --- */
   if dt-vencimento-aux = ?
   then do:
          find  tipovenc 
          where tipovenc.cd-tipo-vencimento = cd-tipo-vencimento-aux
                no-lock no-error.

          if not available tipovenc
          then do:
                  run insertOtherError(input 530,
                                        input "Tipo Vencimento: " 
                                      + string(cd-tipo-vencimento-aux),
                                      input "",
                                      input "GP",
                                      input "E",
                                      input "",
                                      input-output table rowErrors).
                  lg-erro-par = yes.
               end.
 
          run rtp/rtdtvenc.p(input ep-codigo-aux,
                             input cod-estabel-aux,
                             input dd-vencimento-aux,
                             input dt-emissao-aux,
                             input-output dt-vencimento-aux,
                             input mm-ref-aux,
                             input aa-ref-aux,
                             input cd-tipo-vencimento-aux,
                             output lg-erro-aux,
                             output ds-mensagem-aux).
          
          if lg-erro-aux
          then do:
                  run insertOtherError(input 1656,
                                       input "Mensagem: " + ds-mensagem-aux,
                                       input "",
                                       input "GP",
                                       input "E",
                                       input "",
                                       input-output table rowErrors).
                  lg-erro-par = yes.
               end.
 
          if dt-vencimento-aux < dt-emissao-aux
          then do:
                  run insertOtherError(input 1656,
                                        input "Vencimento: " 
                                       + string(dt-vencimento-aux,"99/99/9999")
                                       +       " Emissao: "
                                       + string(dt-emissao-aux,"99/99/9999"),
                                       input "",
                                       input "GP",
                                       input "E",
                                       input "",
                                       input-output table rowErrors).
                 assign lg-erro-par = yes.
               end.
        end.

   /* -------------- CARREGA AUXILIAR COM ULTIMO DIA DO MES DE REFERENCIA --- */
   run rtp/rtultdia.p (aa-ref-aux, 
                       mm-ref-aux,
                       output dt-ref-aux).

 
   /* ----- DATA DE FIM DE CONTRATO DEVE SER MAIOR QUE DATA DE REFERENCIA --- */
   if date(month(ter-ade.dt-fim),01,year(ter-ade.dt-fim)) < 
      date(mm-ref-aux,01,aa-ref-aux)
   then do:
           run insertOtherError(input 1643,
                                input string(ter-ade.dt-fim),
                                input "",
                                input "GP",
                                input "E",
                                input "",
                                input-output table rowErrors).
            assign lg-erro-par = yes.
        end.

   /* ---------- VERIFICA DATA DE INCLUSAO DO TERMO, QUANDO PROPOSTA NOVA --- */
   if propost.cd-sit-proposta = 05
   then do:
          if  (year(ter-ade.dt-inicio) = aa-ref-aux
          and month(ter-ade.dt-inicio) = mm-ref-aux)
          or  (year(ter-ade.dt-inicio) = year (dt-ref-ant-aux)
          and month(ter-ade.dt-inicio) = month(dt-ref-ant-aux))
          then.
          else do:
                  run insertOtherError(input 1646,
                                       input string(ter-ade.dt-inicio),
                                       input "",
                                       input "GP",
                                       input "E",
                                       input "",
                                       input-output table rowErrors).
                 assign lg-erro-par = yes.
               end.
        end.
  

   /* - VERIFICA SE O TERMO FOI FATURADO NO MES ANTERIOR AO DE REFERENCIA --- */ 
   /*if propost.cd-sit-proposta = 06
   or propost.cd-sit-proposta = 07
   then do:
          if ter-ade.aa-ult-fat <> year (dt-ref-ant-aux)
          or ter-ade.mm-ult-fat <> month(dt-ref-ant-aux)
          then do:
                  run insertOtherError(input 1645,
                                       input string(ter-ade.mm-ult-fat,"99")
                                       + "/" + string(ter-ade.aa-ult-fat,"9999"),
                                       input "",
                                       input "GP",
                                       input "E",
                                       input "",
                                       input-output table rowErrors).
                  assign lg-erro-par = yes.
               end.
        end.       */
end procedure.

procedure limpa-variaveis:

   assign ep-codigo-aux                = ""
          cod-estabel-aux              = ""
          cd-modalidade-aux            = 0
          nr-ter-ade-aux               = 0
          cd-tipo-vencimento-aux       = 0
          dd-vencimento-aux            = 0
          pc-acrescimo-aux             = 0
          pc-desconto-aux              = 0
          pc-acrescimo-insc-aux        = 0
          pc-desconto-insc-aux         = 0
          pc-desc-prom-pl-aux          = 0
          lg-erro-aux                  = no
          cd-contratante-aux           = 0
          cd-contratante-origem-aux    = 0
          aa-ref-aux                   = 0
          mm-ref-aux                   = 0
          mm-referencia-aux            = 0
          aa-referencia-aux            = 0
          dt-emissao-aux               = ?
          dt-vencimento-aux            = ?
          nr-sequencia-aux             = 0
          aa-prox-fat-aux              = 0
          mm-prox-fat-aux              = 0
          dt-ref-ant-aux               = ?                       
          dt-ref-exc                   = ?                       
          dt-ini-ref-aux               = ?                       
          dt-inc-prog                  = ?                       
          dt-limite-aux                = ?                       
          nr-periodicidade-meses-aux   = 0
          in-faturar-aux               = 0
          aa-ult-fat-period-aux        = 0
          mm-ult-fat-period-aux        = 0
          lg-tem-percevento            = no
          pc-prop-evento-aux           = 0
          lg-ct-contabil-aux           = no
          ct-codigo-aux                = ""
          sc-codigo-aux                = ""                        
          ct-codigo-dif-aux            = ""                        
          sc-codigo-dif-aux            = ""                        
          ct-codigo-dif-neg-aux        = ""                        
          sc-codigo-dif-neg-aux        = ""                        
          lg-evencontde-aux            = no                         
          lg-modulo-agregado-aux       = no                         
          ds-mensagem-aux              = ""
          qt-meses-faturados-aux       = 0
          cdd-regra-proposta-aux       = 0
          cdd-regra-usuario-aux        = 0
          dt-exc-usu-aux               = ?
          dt-inc-usu-aux               = ?
          qt-usu-aux                   = 0
          lg-modulo-obrigatorio-aux    = no
          nr-idade-inc                 = 0                        
          nr-idade-ant                 = 0                        
          nr-idade-atu                 = 0                        
          nr-idade-exc                 = 0                        
          nr-idade-sem-reaj-aux        = 0                        
          nr-faixa-etaria-atu          = 0                        
          vl-modulo-aux                = 0
          vl-tx-insc-aux               = 0
          qt-fat-repasse-aux           = 0
          pc-taxa-insc-aux             = 0
          lg-cred-deb-mens-aux         = no
          pc-negociacao-mens-aux       = 0
          lg-cred-deb-insc-aux         = no
          pc-negociacao-ins-aux        = 0
          pc-imposto-aux               = 0
          aa-mm-ult-reaj-aux           = ""
          aa-mm-ref-aux                = ""
          qt-caren-dias                = 0
          qt-caren-urgencia            = 0
          qt-caren-eletiva             = 0
          lg-suspensao-reajuste-aux    = no
          dt-proporcao-modulo-aux      = ?
          dt-proporcao-usu-aux         = ?
          lg-susp-mes-anterior-aux     = no
          lg-susp-mes-atual-aux        = no
          dt-ref-aux                   = ?
          lg-fat-proporc-saida         = no
          dt-ref-pro-aux               = ?
          vl-grau-faixa-aux            = 0
          qt-evto-grfaixa-aux          = 0
          nr-benef-ativ-aux            = 0
          vl-nota-aux                  = 0
          pc-desconto-promo-aux        = 0
          des-excecao-aux              = ""
          lg-retorna                   = no
          dt-ini-aux                   = ?
          dt-fim-aux                   = ?
          dt-ult-dia-fat-termo-aux     = ?
          dt-inclusao-programada-aux   = ?.

end procedure.
              
/*-------------------------------------------------------------------------------------     
--------------------------- INICIO - ROTINAS DE CALCULO -------------------------------            
--------------------------------------------------------------------------------------*/           
/* -------------------------------------------------- MENSALIDADE BASICA --- */                    
function f-valida-primeira-mensalidade returns logical:

    /* --------------------- VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
    if in-faturar-aux = 0
    then return no.

    if  tmp-evento-benef.cd-sit-usuario < 5
    or  tmp-evento-benef.cd-sit-usuario > 7
    then return no. 

    if tmp-evento-benef.cd-sit-usuario = 6
    or tmp-evento-benef.cd-sit-usuario = 7
    then if tmp-evento-benef.aa-ult-fat > 0
         or tmp-evento-benef.mm-ult-fat > 0
         then return no. 

    if ( year(tmp-evento-benef.dt-inclusao-plano) = aa-ref-aux            and month(tmp-evento-benef.dt-inclusao-plano) = mm-ref-aux)
    or ( year(tmp-evento-benef.dt-inclusao-plano) = year(dt-ref-ant-aux)  and month(tmp-evento-benef.dt-inclusao-plano) = month(dt-ref-ant-aux))
    or ( year(tmp-evento-benef.dt-inclusao-plano) = year(dt-ref-pro-aux)  and month(tmp-evento-benef.dt-inclusao-plano) = month(dt-ref-pro-aux))
    then. 
    else return no. 

    if  not(   tmp-evento-benef.dt-exclusao-plano = ?
            or tmp-evento-benef.dt-exclusao-plano > tmp-evento-benef.dt-inclusao-plano)
    then return no.

    if tmp-evento-benef.dt-proporcao = ?
    or lg-fat-proporc-saida    
    then return no.

    return yes.

end function.

procedure executa-rotina:
    def input parameter nm-rotina-par             as char                 no-undo. 

   if index(nm-rotina-par, "mensalidade") > 0
   and avail tmp-evento-benef
   then do:
           if index(nm-rotina-par, "sem-troca-faixa") = 0
           and tmp-evento-benef.lg-sem-reaj            
           then return.
           
           if index(nm-rotina-par, "sem-troca-faixa") > 0
           and tmp-evento-benef.lg-sem-reaj = no           
           then return.
        end.

    case nm-rotina-par:
          /* MENSALIDADE BASICA*/
          when "mensalidade-basica-sem-plano"              or  
          when "mensalidade-basica-sem-plano-grau"         or  
          when "mensalidade-basica-sem-grau"               or 
          when "mensalidade-sem-troca-faixa"               or 
          when "mensalidade-sem-troca-faixa-plano"         or 
          when "mensalidade-sem-troca-faixa-grau"          or 
          when "mensalidade-sem-troca-faixa-plano-grau"     
          then assign nm-rotina-par = "mensalidade-basica".
          /* MENSALIDADE PROPORCIONAL*/
          when "mensalidade-proporcional-sem-plano"         or  
          when "mensalidade-proporcional-sem-grau"          or  
          when "mensalidade-proporcional-sem-plano-grau"    or
          when "mensalidade-proporcional-sem-troca"         or
          when "mensalidade-proporcional-sem-troca-plano"   or
          when "mensalidade-proporcional-sem-troca-grau"    or
          when "mensalidade-proporcional-sem-troca-plano-grau"
          then assign nm-rotina-par = "mensalidade-proporcional".
          /* PRIMEIRA MENSALIDADE*/ 
          when "primeira-mensalidade-sem-plano"             or  
          when "primeira-mensalidade-sem-grau"              or  
          when "primeira-mensalidade-sem-plano-grau"        or
          when "primeira-mensalidade-sem-troca-faixa"       or
          when "primeira-mensalidade-sem-troca-faixa-plano" or
          when "primeira-mensalidade-sem-troca-faixa-grau"  or 
          when "primeira-mensalidade-sem-troca-faixa-plano-grau" 
          then assign nm-rotina-par = "primeira-mensalidade".
          /* MENSALIDADE ANTERIOR */
          when "mensalidade-anterior-sem-plano"             or  
          when "mensalidade-anterior-sem-grau"              or  
          when "mensalidade-anterior-sem-plano-grau"        or
          when "mensalidade-anterior-sem-troca"             or
          when "mensalidade-anterior-sem-troca-plano"       or
          when "mensalidade-anterior-sem-troca-grau"        or
          when "mensalidade-anterior-sem-troca-plano-grau"
          then assign nm-rotina-par = "mensalidade-anterior".
          /*FATURAMENTO PERIODICO*/
          when "faturamento-periodico-sem-plano"            or
          when "faturamento-periodico-sem-grau"             or
          when "faturamento-periodico-sem-plano-grau"             or 
          when "faturamento-periodico-sem-troca-faixa"            or 
          when "faturamento-periodico-sem-troca-faixa-plano"      or 
          when "faturamento-periodico-sem-troca-faixa-grau"       or 
          when "faturamento-periodico-sem-troca-faixa-plano-grau"
          then assign nm-rotina-par = "faturamento-periodico-normal".
          /*FATURAMENTO PERIODICO PROPORCIONAL*/
          when "faturamento-periodico-proporcional-sem-plano"      or
          when "faturamento-periodico-proporcional-sem-grau"       or
          when "faturamento-periodico-proporcional-sem-plano-grau" 
          then assign nm-rotina-par = "faturamento-periodico-proporcional-normal".
          /*MENSALIDADE PROPORCIONAL SAIDA*/
          when "mensalidade-proporc-saida-sem-plano"              or
          when "mensalidade-proporc-saida-sem-grau"               or
          when "mensalidade-proporc-saida-sem-plano-grau"         or
          when "mensalidade-proporc-saida-sem-troca-faixa"        or
          when "mensalidade-proporc-saida-sem-troca-faixa-plano"  or
          when "mensalidade-proporc-saida-sem-troca-faixa-grau"   or
          when "mensalidade-proporc-saida-sem-troca-plano-grau"
          then assign nm-rotina-par = "mensalidade-proporc-saida".
    end case.
    
    run value(nm-rotina-par).

end procedure.

procedure cria-temporaria-valor:
   def input parameter qt-fator-proporcional-aux  as dec format "999.9999" no-undo. 

    /* TODO
  leitura rtusunegoc - parte da simulacao da proposta -  deixar por ultimo
  */

  /* if tmp-evento-benef.vl-evento = 0
   then return. */

   assign tmp-evento-benef.vl-evento     = round(tmp-evento-benef.vl-evento 
                                         * qt-fator-proporcional-aux
                                         * (tmp-evento-fat.pc-princ-aux / 100), 2)
          tmp-evento-benef.lg-processado = yes.

  assign tmp-evento-fat.vl-evento            = tmp-evento-fat.vl-evento + tmp-evento-benef.vl-evento
         tmp-evento-fat.qt-evento            = tmp-evento-fat.qt-evento + 1.
end procedure.

procedure mensalidade-basica:
  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  /* ---------------- MENSALIDADE PROPORCIONAL - NAO CONSIDERAR NA MENSALIDADE --- */
  if  ter-ade.aa-ult-fat-period = 0 
  and ter-ade.mm-ult-fat-period = 0 
  and tmp-evento-benef.dt-proporcao <> ? 
  and month(tmp-evento-benef.dt-proporcao) = mm-ref-aux 
  and year(tmp-evento-benef.dt-proporcao)  = aa-ref-aux
  then return.

  if tmp-evento-benef.cd-sit-usuario < 5 
  or tmp-evento-benef.cd-sit-usuario > 7
  or lg-fat-proporc-saida
  then return. 

  if tmp-evento-benef.cd-sit-usuario = 05
  then do:
          if ( year(tmp-evento-benef.dt-inclusao-plano)     = aa-ref-aux
              and month(tmp-evento-benef.dt-inclusao-plano) = mm-ref-aux
              and tmp-evento-benef.dt-proporcao = ? ) 
          or (tmp-evento-benef.dt-proporcao  < date(mm-ref-aux,01,aa-ref-aux))    
          then .
          else return.

          if (tmp-evento-benef.dt-exclusao-plano = ?)
          or (    tmp-evento-benef.dt-exclusao-plano >  tmp-evento-benef.dt-inclusao-plano
              and tmp-evento-benef.dt-exclusao-plano >= date(mm-ref-aux,01,aa-ref-aux))
          then . 
          else return. 
       end.
  else do:
           if tmp-evento-benef.dt-exclusao-plano < dt-ref-exc
           then return.
       end.
                        
   run cria-temporaria-valor (input 1).

end procedure.

/* ------------------------------------------- MENSALIDADE PROPORCIONAL --- */
procedure mensalidade-proporcional:

    def var lg-fator-ant-aux              as log                       no-undo.
    def var nr-dias-mes                   as int                       no-undo.
    def var pc-proporcional-aux           as dec format "999.9999"     no-undo.

    if f-valida-primeira-mensalidade() = no 
    then return. 

    if month(tmp-evento-benef.dt-proporcao) < 12
    then assign nr-dias-mes = day(date(month(tmp-evento-benef.dt-proporcao) + 1 , 01, year(tmp-evento-benef.dt-proporcao)) - 1 ).
    else assign nr-dias-mes = day(date( 01 , 01 ,year(tmp-evento-benef.dt-proporcao) + 1 ) - 1 ).

    assign pc-proporcional-aux = ( nr-dias-mes - day (tmp-evento-benef.dt-proporcao) + 1 ) / nr-dias-mes .

    run cria-temporaria-valor (input pc-proporcional-aux).
end procedure.

/* ------------------------------------- PRIMEIRA MENSALIDADE  --- */
procedure primeira-mensalidade:

  if f-valida-primeira-mensalidade() = no 
  then return. 

  run cria-temporaria-valor (input 1).
end procedure.

/* ----------------------------------------------- MENSALIDADE ANTERIOR --- */
procedure mensalidade-anterior:
                               
  def var lg-fator-ant-aux                as log                         no-undo.
  
  if  tmp-evento-benef.cd-sit-usuario < 5
  or  tmp-evento-benef.cd-sit-usuario > 7
  then return. 

  if tmp-evento-benef.cd-sit-usuario = 6
  or tmp-evento-benef.cd-sit-usuario = 7
  then if tmp-evento-benef.aa-ult-fat > 0
       or tmp-evento-benef.mm-ult-fat > 0
       then return. 

  if (      year(tmp-evento-benef.dt-inclusao-plano) = year(dt-ref-ant-aux) 
       and month(tmp-evento-benef.dt-inclusao-plano) =  month(dt-ref-ant-aux)
       and tmp-evento-benef.dt-proporcao = ?)
  or ( tmp-evento-benef.dt-inclusao-plano < date(month(dt-ref-ant-aux),01,year(dt-ref-ant-aux)))
  then .
  else return. 

  if tmp-evento-benef.dt-exclusao-plano <= tmp-evento-benef.dt-inclusao-plano
  or lg-fat-proporc-saida
  then return. 

  run cria-temporaria-valor (input 1).
end procedure.

/* ---------------------------------------------------------- INSCRICAO --- */
procedure inscricao:

   def var lg-fator-ant-aux                as log                         no-undo.
  
  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if  in-faturar-aux = 0
  and tmp-evento-benef.lg-cobra-insc
  then return.

  if tmp-evento-benef.cd-sit-usuario    <> 5
  or tmp-evento-benef.dt-exclusao-plano <= tmp-evento-benef.dt-inclusao-plano
  then return.

  if (year(tmp-evento-benef.dt-inclusao-plano)  = aa-ref-aux and month(tmp-evento-benef.dt-inclusao-plano) <= mm-ref-aux)
  or (year(tmp-evento-benef.dt-inclusao-plano)   < aa-ref-aux)
  then . 
  else return. 

  run cria-temporaria-valor (input 1).
  
end procedure.

/* ---------------------------------------------------- VIA DE CARTEIRA --- */
procedure nova-via-carteira:
   def var dt-mes-seg-aux                  as date                        no-undo.

  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  if mm-ref-aux = 12
  then dt-mes-seg-aux = date(01,01,aa-ref-aux + 1).
  else dt-mes-seg-aux = date(mm-ref-aux + 1,01,aa-ref-aux).

  if  tmp-evento-benef.cd-sit-usuario = 5
  then do:
          if tmp-evento-benef.dt-inclusao-plano >=  dt-mes-seg-aux
          or tmp-evento-benef.dt-exclusao-plano >= tmp-evento-benef.dt-inclusao-plano
          then return.
       end.
  else do:
          if  tmp-evento-benef.cd-sit-usuario <> 6
          and tmp-evento-benef.cd-sit-usuario <> 7
          then return.

          if tmp-evento-benef.dt-exclusao-plano <= dt-ref-exc
          then return.
       end.                       
         
 assign tmp-evento-benef.vl-evento =  tmp-evento-benef.ct-nova-via * tmp-evento-fat.vl-evento-cart-nv.

 if tmp-evento-benef.vl-evento = 0
 then return.

 run cria-temporaria-valor (input 1).
end procedure.


/* --------------------------------------------------- IMPOSTOS --- */
procedure imposto:
  assign tmp-evento-fat.vl-evento = tmp-evento-fat.vl-evento 
                                  + round(tmp-impostos.vl-base * (tmp-impostos.pc-aliquota / 100),2).
end procedure.

/* --------------------------------------- TAXA TRANSFERENCIA DE BENEFICIARIOS --- */       
procedure taxa-transferencia:                                                         
   def var lg-fator-ant-aux                as log                         no-undo.
   def var dt-mes-seg-aux                  as date                        no-undo.      
                                                                                        
   /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
   if in-faturar-aux = 0                                                              
   then return.                                        
   
   if mm-ref-aux = 12                                                                   
   then dt-mes-seg-aux = date(01,01,aa-ref-aux + 1).                                    
   else dt-mes-seg-aux = date(mm-ref-aux + 1,01,aa-ref-aux).                            

   if tmp-evento-benef.cd-sit-usuario = 5
   then do:
           if tmp-evento-benef.dt-inclusao-plano >= dt-mes-seg-aux
           or tmp-evento-benef.dt-exclusao-plano <= dt-ref-exc
           then return.
        end.
   else if (    tmp-evento-benef.cd-sit-usuario <> 6
            and tmp-evento-benef.cd-sit-usuario <> 7)
        or tmp-evento-benef.dt-exclusao-plano <= tmp-evento-benef.dt-inclusao-plano
        then return.

   run cria-temporaria-valor (input 1).
end procedure.

/* -------------------------------------------- BENEFICIARIOS MES ATUAL --- */
procedure beneficiarios-mes-atual:
  def var dt-mes-seg-aux                  as date                        no-undo.
  def var aa-prox-fat-aux                 as int                         no-undo.
  def var mm-prox-fat-aux                 as int                         no-undo.
  
  /* ------------ calcula qtd. de benef no faturamento periodico --- */
  if in-faturar-aux = 0
  then do: 
         run calcula-prox-faturamento-periodico(output aa-prox-fat-aux,
                                                output mm-prox-fat-aux).
         
         if aa-prox-fat-aux <> aa-ref-aux
         or mm-prox-fat-aux <> mm-ref-aux
         then return.
       end.

  if mm-ref-aux = 12
  then dt-mes-seg-aux = date(01,01,aa-ref-aux + 1).
  else dt-mes-seg-aux = date(mm-ref-aux + 1,01,aa-ref-aux).


  if  tmp-evento-benef.cd-sit-usuario = 05
  then do:
          if tmp-evento-benef.dt-inclusao-plano >=  dt-mes-seg-aux
          or tmp-evento-benef.dt-exclusao-plano <=  tmp-evento-benef.dt-inclusao-plano
          or tmp-evento-benef.dt-exclusao-plano <   date(mm-ref-aux,01,aa-ref-aux)
          then return.
       end.
  else do:
           if  tmp-evento-benef.cd-sit-usuario <> 6
           and tmp-evento-benef.cd-sit-usuario <> 7
           then return. 

           if tmp-evento-benef.dt-exclusao-plano <= dt-ref-exc 
           then return.
       end.

 assign tmp-evento-fat.qt-evento = tmp-evento-fat.qt-evento + 1.
end procedure.

/* ---------------------------------- BENEFICIARIOS INCLUIDOS MES ATUAL --- */
procedure beneficiarios-incluidos-mes-atual:

  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  if tmp-evento-benef.cd-sit-usuario <> 05
  or  year(tmp-evento-benef.dt-inclusao-plano)  <> aa-ref-aux
  or month(tmp-evento-benef.dt-inclusao-plano) <> mm-ref-aux
  or tmp-evento-benef.dt-exclusao-plano <= tmp-evento-benef.dt-inclusao-plano
  then return. 

  assign tmp-evento-fat.qt-evento = tmp-evento-fat.qt-evento + 1.

end procedure.

/* ------------------------------------------ BENEFICIARIOS MES ANTERIOR --- */
procedure beneficiarios-mes-anterior:

  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  if tmp-evento-benef.aa-ult-fat       <> year (dt-ref-ant-aux)
  or tmp-evento-benef.mm-ult-fat       <> month(dt-ref-ant-aux)
  or tmp-evento-benef.dt-exclusao-plano <  date(month(dt-ref-ant-aux),01,year(dt-ref-ant-aux))
  or tmp-evento-benef.lg-susp-mes-ant
  then return.

  assign tmp-evento-fat.qt-evento = tmp-evento-fat.qt-evento + 1.
end procedure.


/* -------------------------------- BENEFICIARIOS INCLUIDOS MES ANTERIOR --- */
procedure beneficiarios-incluidos-mes-anterior:
  
  if in-faturar-aux = 0
  then return.

  if tmp-evento-benef.cd-sit-usuario    <> 05
  or tmp-evento-benef.dt-inclusao-plano >= date(mm-ref-aux,01,aa-ref-aux)
  or tmp-evento-benef.dt-exclusao-plano <= tmp-evento-benef.dt-inclusao-plano
  then return.

  assign tmp-evento-fat.qt-evento = tmp-evento-fat.qt-evento + 1.

end procedure.

/* --------------------------------- BENEFICIARIOS EXCLUIDOS MES ANTERIOR --- */
procedure beneficiarios-excluidos-mes-anterior:

  if in-faturar-aux = 0
  then return.

  if  year(tmp-evento-benef.dt-exclusao-plano) <> year(dt-ref-ant-aux)
  or month(tmp-evento-benef.dt-exclusao-plano) = month(dt-ref-ant-aux) 
  or tmp-evento-benef.dt-inclusao-plano = tmp-evento-benef.dt-exclusao-plano
  then return. 

  assign tmp-evento-fat.qt-evento = tmp-evento-fat.qt-evento + 1.
end procedure.

/* ------------------------------ ROTINA PARA EVENTOS PROGRAMADOS (VALOR) --- */
procedure calculo-programado-valor:
  def var nr-idade-usuario            as int                              no-undo.
  def var lg-erro-aux                 as log                              no-undo.
  def var nr-faixa-usu-prog-aux       like teadgrpa.nr-faixa-etaria       no-undo.
  def var cd-contrat-aux              like vlbenef.cd-contratante         no-undo.    
  def var cd-contrat-origem-aux       like vlbenef.cd-contratante-origem  no-undo.
  def var tot-vl-prog-aux             like fatueven.vl-evento             no-undo.
  def var tot-qt-prog-aux             like fatueven.qt-evento             no-undo.
  def var lg-tem-percevento           as log                              no-undo.
  def var pc-prop-evento-aux          like percevento.pc-prop-evento      no-undo. 
  def var vl-total-benef-aux          like fatueven.vl-evento             no-undo.
  
  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  /* FALTA ATUALIZAR A TABELA DE VALOR EVENT-PROGDO*/
  for each event-progdo-bnfciar fields (event-progdo-bnfciar.cd-modalidade
                                         event-progdo-bnfciar.nr-ter-adesao
                                         event-progdo-bnfciar.cd-evento    
                                         event-progdo-bnfciar.aa-referencia
                                         event-progdo-bnfciar.mm-referencia
                                         event-progdo-bnfciar.vl-evento)
                                 where event-progdo-bnfciar.cd-modalidade = propost.cd-modalidade
                                   and event-progdo-bnfciar.nr-ter-adesao = propost.nr-ter-adesao
                                   and event-progdo-bnfciar.cd-evento     = tmp-evento-fat.cd-evento
                                   and event-progdo-bnfciar.aa-referencia = aa-ref-aux
                                   and event-progdo-bnfciar.mm-referencia = mm-ref-aux no-lock:

      assign tmp-evento-benef.vl-evento         = round(event-progdo-bnfciar.vl-evento
                                                * (tmp-evento-fat.pc-princ-aux / 100), 2)
             tmp-evento-benef.lg-processado     = yes
             tmp-evento-fat.vl-evento           = tmp-evento-fat.vl-evento + tmp-evento-benef.vl-evento
             tmp-evento-benef.nr-rowid-evt-prog = rowid(event-progdo-bnfciar). 
  end.
end procedure.

/* ------------------------ ROTINA PARA EVENTOS PROGRAMADOS (PERCENTUAL) --- */
procedure calculo-programado-percentual:
    def buffer b-tmp-evento-fat for tmp-evento-fat.
    def var vl-evento-aux       as dec                         no-undo.
    def var pc-evento-prog-aux  as dec                         no-undo. 

    assign pc-evento-prog-aux = 0
           vl-evento-aux = 0.

    for first eveprper fields (eveprper.cd-modalidade 
                               eveprper.nr-ter-adesao 
                               eveprper.aa-referencia 
                               eveprper.mm-referencia 
                               eveprper.cd-evento     
                               eveprper.pc-evento)
                       where eveprper.cd-modalidade           = propost.cd-modalidade
                         and eveprper.nr-ter-adesao           = propost.nr-ter-adesao 
                         and eveprper.aa-referencia           = aa-ref-aux
                         and eveprper.mm-referencia           = mm-ref-aux
                         and eveprper.cd-evento               = tmp-evento-fat.cd-evento no-lock:
        assign pc-evento-prog-aux   = eveprper.pc-evento.
    end.

    if pc-evento-prog-aux = 0
    then return.

    for each b-tmp-evento-fat no-lock:
        if b-tmp-evento-fat.lg-cred-deb
        then assign vl-evento-aux = vl-evento-aux + b-tmp-evento-fat.vl-evento.
        else assign vl-evento-aux = vl-evento-aux - b-tmp-evento-fat.vl-evento.
    end.                  

    assign tmp-evento-fat.vl-evento = round(vl-evento-aux * (pc-evento-prog-aux / 100),2).
end procedure.

/* ------------------------ ROTINA PARA EVENTOS PROGRAMADOS SOBRE EVENTOS --- */
procedure calculo-programado-sobre-evento:

    def buffer b-tmp-evento-fat for tmp-evento-fat.
    def var vl-evento-aux       as dec                         no-undo.

    assign vl-evento-aux = 0.

    for each evaplper fields(evaplper.cd-modalidade  
                             evaplper.nr-ter-adesao  
                             evaplper.aa-referencia  
                             evaplper.mm-referencia  
                             evaplper.cd-evento      
                             evaplper.cd-evento-aplicado
                             evaplper.pc-evento)
                      where evaplper.cd-modalidade           = propost.cd-modalidade
                        and evaplper.nr-ter-adesao           = propost.nr-ter-adesao
                        and evaplper.aa-referencia           = aa-ref-aux
                        and evaplper.mm-referencia           = mm-ref-aux
                        and evaplper.cd-evento               = tmp-evento-fat.cd-evento
                        no-lock:
        
        for each b-tmp-evento-fat no-lock
            where b-tmp-evento-fat.cd-evento = evaplper.cd-evento-aplicado:

            if b-tmp-evento-fat.lg-cred-deb
            then assign vl-evento-aux = round(vl-evento-aux + (b-tmp-evento-fat.vl-evento * (evaplper.pc-evento / 100)), 2).
            else assign vl-evento-aux = round(vl-evento-aux - (b-tmp-evento-fat.vl-evento * (evaplper.pc-evento / 100)), 2).
        end.                  
    end.
    assign tmp-evento-fat.vl-evento = vl-evento-aux.
end procedure. 

/* --------------------------------------- FATURAMENTO PERIODICO NORMAL --- */
procedure faturamento-periodico-normal:
    def var lg-fator-ant-aux                as log                    no-undo.
    def var aa-prox-fat-aux                 as int                    no-undo.
    def var mm-prox-fat-aux                 as int                    no-undo.

    /* ----------- VERIFICA SE A PERIODICIDADE DO TERMO/PLANO EH VALIDA --- */
    if nr-periodicidade-meses-aux = 0
    then return.
    
    run calcula-prox-faturamento-periodico(output aa-prox-fat-aux,
                                           output mm-prox-fat-aux).
    
    /* - SO EXECUTA O CALCULO SE FOR PRIMEIRO FATURAMENTO DO TERMO OU A --- */
    /* ----------- REFERENCIA BATER COM O PROXIMO FATURAMENTO PERIODICO --- */
    if propost.cd-sit-propost = 0
    then.
    else if propost.cd-sit-propost <> 5
         and (   aa-ref-aux <> aa-prox-fat-aux 
              or mm-ref-aux <> mm-prox-fat-aux)
         then return.

    if propost.cd-sit-proposta <> 5
    then do:
           /* -------------------------------------------------------------- */
           if (    year(tmp-evento-benef.dt-inclusao-plano) > aa-ult-fat-period-aux        
               and month(tmp-evento-benef.dt-inclusao-plano) <> mm-prox-fat-aux)
           or (    year(tmp-evento-benef.dt-inclusao-plano)  = aa-ult-fat-period-aux
               and month(tmp-evento-benef.dt-inclusao-plano) > mm-ult-fat-period-aux)
           then return.
           
         end.

     if  ter-ade.aa-ult-fat-period = 0 
     and ter-ade.mm-ult-fat-period = 0 
     then return.
     
     if tmp-evento-benef.cd-sit-usuario < 5 
     or tmp-evento-benef.cd-sit-usuario > 7
     or lg-fat-proporc-saida
     then return. 
     
     if tmp-evento-benef.cd-sit-usuario = 05
     then do:
             if ( year(tmp-evento-benef.dt-inclusao-plano)  = aa-ref-aux
                 and month(tmp-evento-benef.dt-inclusao-plano) = mm-ref-aux
                 and tmp-evento-benef.dt-proporcao = ? ) 
             or (tmp-evento-benef.dt-proporcao  < date(mm-ref-aux,01,aa-ref-aux))    
             then .
             else return.
     
             if (tmp-evento-benef.dt-exclusao-plano = ?)
             or (    tmp-evento-benef.dt-exclusao-plano >  tmp-evento-benef.dt-inclusao-plano
                 and tmp-evento-benef.dt-exclusao-plano >= date(mm-ref-aux,01,aa-ref-aux))
             then . 
             else return. 
          end.
     else do:
              if tmp-evento-benef.dt-exclusao-plano < dt-ref-exc
              then return.
          end.

     run cria-temporaria-valor (input 1).
end procedure.

/* -------------------------- FATURAMENTO PERIODICO PROPORCIONAL NORMAL --- */
procedure faturamento-periodico-proporcional-normal:

    def input parameter qt-usu-par          as int                     no-undo.
    def input parameter cd-usu-par          as int                     no-undo.

    def var pc-proporcional-aux             as dec format "999.9999"   no-undo.
    def var lg-fator-ant-aux                as log                     no-undo.
    def var aa-prox-fat-aux                 as int                     no-undo.
    def var mm-prox-fat-aux                 as int                     no-undo.
    def var nr-meses-aux                    as int                     no-undo.

    /* ----------- VERIFICA SE A PERIODICIDADE DO TERMO/PLANO EH VALIDA --- */
    if nr-periodicidade-meses-aux = 0
    or propost.cd-sit-proposta    = 5
    then return.
    
    if   year (tmp-evento-benef.dt-inclusao-plano) > aa-ref-aux
    or  (year (tmp-evento-benef.dt-inclusao-plano) = aa-ref-aux
    and  month(tmp-evento-benef.dt-inclusao-plano) > mm-ref-aux)
    then return.
    
    run calcula-prox-faturamento-periodico(output aa-prox-fat-aux,
                                           output mm-prox-fat-aux).

    /* --------- SE A DATA DE INCLUSAO DO USUARIO FOR MAIOR OU IGUAL AO --- */
    /* ---- PROXIMO FATURAMENTO PERIODICO, NAO DEVE SER FEITO O CALCULO --- */
    if      year (tmp-evento-benef.dt-inclusao-plano)  > aa-prox-fat-aux
    or (    year (tmp-evento-benef.dt-inclusao-plano)  = aa-prox-fat-aux
        and month(tmp-evento-benef.dt-inclusao-plano) >= mm-prox-fat-aux)
    then return.

    /* ---------------------------------------------
     * VERIFICA SE DATA DE INCLUSAO DO BENEF. EH 
     * MAIOR QUE A DATA DO ULT.FAT.PERIODICO 
     * --------------------------------------------- */
    if year(tmp-evento-benef.dt-inclusao-plano)       > aa-ult-fat-period-aux
    or (    year(tmp-evento-benef.dt-inclusao-plano)  = aa-ult-fat-period-aux
        and month(tmp-evento-benef.dt-inclusao-plano) > mm-ult-fat-period-aux)
    then.
    else return.
    run calcula-nr-meses-beneficio(input  aa-prox-fat-aux,
                                   input  mm-prox-fat-aux,
                                   output nr-meses-aux).
    
    assign pc-proporcional-aux = nr-meses-aux / nr-periodicidade-meses-aux .

    if lg-fat-proporc-saida 
    then return.

    if tmp-evento-benef.cd-sit-usuario = 05
    then do:
            if  (     year(tmp-evento-benef.dt-inclusao-plano) <> aa-ref-aux
                  or month(tmp-evento-benef.dt-inclusao-plano) <> mm-ref-aux  
                  or tmp-evento-benef.dt-proporcao <> ?)
            and (tmp-evento-benef.dt-inclusao-plano >=  date(mm-ref-aux,01,aa-ref-aux))
            then return.

            if tmp-evento-benef.dt-exclusao-plano <= tmp-evento-benef.dt-inclusao-plano
            or tmp-evento-benef.dt-exclusao-plano <  date(mm-ref-aux,01,aa-ref-aux)
            then return.
         end.
    else do:
            if  tmp-evento-benef.cd-sit-usuario <> 06
            and tmp-evento-benef.cd-sit-usuario <> 07
            then return.

            if tmp-evento-benef.dt-exclusao-plano <= dt-ref-exc
            then return.
         end.
    run cria-temporaria-valor (input pc-proporcional-aux).
end procedure.

/* ------------------------ EVENTO DE DILUICAO DO REAJUSTE DA MENSALIDADE --- */
procedure diluicao-reajuste:
 
  /* ------------------------------ VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  /* ---------------- MENSALIDADE PROPORCIONAL - NAO CONSIDERAR NA MENSALIDADE --- */
  if  tmp-evento-benef.aa-ult-fat = 0
  and tmp-evento-benef.mm-ult-fat = 0 
  and tmp-evento-benef.dt-proporcao <> ?
  and month(tmp-evento-benef.dt-proporcao) = mm-ref-aux
  and year(tmp-evento-benef.dt-proporcao)  = aa-ref-aux
  then return.
      
  if tmp-evento-benef.cd-sit-usuario < 05
  or tmp-evento-benef.cd-sit-usuario > 07
  then return.

  if tmp-evento-benef.cd-sit-usuario = 05
  then do:
          if (     year(tmp-evento-benef.dt-inclusao-plano) = aa-ref-aux
              and month(tmp-evento-benef.dt-inclusao-plano) = mm-ref-aux
                 and tmp-evento-benef.dt-proporcao          = ?)
          or (tmp-evento-benef.dt-inclusao-plano  < date(mm-ref-aux,01,aa-ref-aux))
          then .
          else return.

          if (tmp-evento-benef.dt-exclusao-plano = ?)
          or (    tmp-evento-benef.dt-exclusao-plano > tmp-evento-benef.dt-inclusao-plano
              and tmp-evento-benef.dt-exclusao-plano >= date(mm-ref-aux,01,aa-ref-aux))
          then .
          else return.
       end.
  else do:
          if  tmp-evento-benef.dt-exclusao-plano  =  ?
          or  tmp-evento-benef.dt-exclusao-plano  > dt-ref-exc
          then .
          else return.
       end.

  for first usu-negoc fields(usu-negoc.vl-diluicao)
                      where usu-negoc.cd-modalidade = propost.cd-modalidade
                        and usu-negoc.nr-ter-adesao = propost.nr-ter-adesao 
                        and usu-negoc.cd-usuario    = tmp-evento-benef.cd-usuario
                        and usu-negoc.aa-referencia = aa-ref-aux
                        and usu-negoc.mm-referencia = mm-ref-aux
                        and usu-negoc.cd-modulo     = tmp-evento-benef.cd-modulo
                        and usu-negoc.lg-diluicao  no-lock:

     assign tmp-evento-benef.vl-evento = usu-negoc.vl-diluicao.
     run cria-temporaria-valor (input 1).

     create tmp-atu-usunegoc.
     assign tmp-atu-usunegoc.rw-usunegoc        = rowid(usu-negoc)
            tmp-atu-usunegoc.aa-referencia-fat  = aa-ref-aux
            tmp-atu-usunegoc.mm-referencia-fat  = mm-ref-aux.
  end.
end procedure.


/* ---------------------------------- MENSALIDADE PROPORCIONAL DE SAIDA --- */
procedure mensalidade-proporc-saida:
  
  def var nr-dias-mes                   as int                         no-undo.
  def var pc-proporcional-aux           as dec format "999.9999"       no-undo.
  def var lg-fator-ant-aux              as log                         no-undo.

  /* ----------------------- VERIFICA SE DEVE OU NAO CONSIDERAR CALCULO --- */
  if in-faturar-aux = 0
  then return.

  if  tmp-evento-benef.dt-exclusao-plano > tmp-evento-benef.dt-inclusao-plano
  and lg-fat-proporc-saida
  then do:
          if   month(tmp-evento-benef.dt-exclusao-plano) < 12
          then assign nr-dias-mes = day(date(month(tmp-evento-benef.dt-exclusao-plano) + 1 ,
                                         01 , year(tmp-evento-benef.dt-exclusao-plano)) - 1 ).
          else assign nr-dias-mes = day(date( 01 , 01 ,
                                         year(tmp-evento-benef.dt-exclusao-plano) + 1 ) - 1 ).
          
          assign pc-proporcional-aux = day(tmp-evento-benef.dt-exclusao-plano) / nr-dias-mes .

          run cria-temporaria-valor (input pc-proporcional-aux).
       end.
end procedure.


/* ------------------------------------ MENSALIDADE REAJUSTE RETROATIVO --- */
procedure mensalidade-reajuste-retroativo:
      /*TO DO*/
end procedure.

/* ----------- PROCEDIMENTOS INTERNOS UTILIZADOS PELAS ROTINAS DE CALCULO --- */
/* ------------------- CALCULA ANO E MES DO PROXIMO FATURAMENTO PERIODICO --- */
procedure calcula-prox-faturamento-periodico:
  def output parameter aa-prox-fat-par as int                           no-undo.
  def output parameter mm-prox-fat-par as int                           no-undo.
  def var ix-aux     as int init 0                                      no-undo.

  if propost.cd-sit-proposta = 5
  then return.

  assign aa-prox-fat-par = aa-ult-fat-period-aux
         mm-prox-fat-par = mm-ult-fat-period-aux.
  do ix-aux = 1 to nr-periodicidade-meses-aux:
     if mm-prox-fat-par = 12
     then assign mm-prox-fat-par = 1
                 aa-prox-fat-par = aa-prox-fat-par + 1.
     else assign mm-prox-fat-par = mm-prox-fat-par + 1.
  end.
end procedure.

/* ---------- CALCULA O NUMERO DE MESES USUFRUIDOS PELO NOVO BENEFICIARIO --- */
procedure calcula-nr-meses-beneficio:
  def input  parameter aa-prox-fat-par as int                           no-undo.
  def input  parameter mm-prox-fat-par as int                           no-undo.
  def output parameter nr-meses-par as int                              no-undo.
  def var aa-prox-fat-aux1 as int init 0                                no-undo.
  def var mm-prox-fat-aux1 as int init 0                                no-undo.

  assign aa-prox-fat-aux1 = year (tmp-evento-benef.dt-inclusao-plano)
         mm-prox-fat-aux1 = month(tmp-evento-benef.dt-inclusao-plano)
         nr-meses-par = 0.
  repeat:
    nr-meses-par = nr-meses-par + 1.
    if mm-prox-fat-aux1 = 12
    then assign mm-prox-fat-aux1 = 1
                aa-prox-fat-aux1 = aa-prox-fat-aux1 + 1.
    else assign mm-prox-fat-aux1 = mm-prox-fat-aux1 + 1.
    if  aa-prox-fat-aux1 = aa-prox-fat-par
    and mm-prox-fat-aux1 = mm-prox-fat-par
    then leave.
  end.
end procedure.
/*-------------------------------------------------------------------------------------
--------------------------- FIM - ROTINAS DE CALCULO ----------------------------------
--------------------------------------------------------------------------------------*/








