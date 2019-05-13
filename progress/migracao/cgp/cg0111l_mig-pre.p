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
assign c_prg_vrs = "2.00.00.054".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'CG0111L':U, '2.00.00.054':U, '':U).
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
  /*** 010054 ***/



/******************************************************************************
*      Programa .....: cg0111l.p                                              *
*      Data .........: 03 de Novembro de 1997                                 *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Moacir Silveira Junior                                 *
*      Objetivo .....: Importar dados dos Prestadores - (Consistencia)        *
*******************************************************************************
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      C.00.000  03/11/1997  Moacir Jr.     Desenvolvimento                   *
*      C.01.000  02/01/1998  Moacir Jr.     Colocada consistencia para o tipo *
*                                           do codigo do magnus, deve ser <>  *
*                                           de "C".                           *
*      C.01.001  26/02/1998  Moacir Jr.     Corrigida importacao da data de   *
*                                           nascimento/fundacao e tambem a    *
*                                           data de exclusao                  *
*      C.02.000  03/03/1998  Moacir Jr.     Alterado tamanho dos campos       *
*                                           cd-esp-resid e nr-ult-inss        *
*      D.00.000  28/04/1998  Nora           Mudanca Versao Banco              *
*      D.01.000  08/07/1998  Gisa           Inclusao dos campos: nr-ult-irrf  *
*                                                            lg-calcula-adto  *
*                                                            dt-calculo-adto. *
*      D.01.001  07/04/1999  Leonardo       Substituicao da rotina RTDIGVER   *
*                                           pela rotina RTCGCCPF              *
*      D.02.000  16/07/1999  Leonardo       Troca de labels e mensagens de    *
*                                           "cooperado" p/ "credenciado"      *
*      D.03.000  14/09/1999  Janete         Incluidos os campos:              *
*                                           nr-dependentes                    *
*                                           lg-contr-max-inss                 *
*                                           lg-pagamento                      *
*                                           lg-tipo-endereco                  *
*                                           lg-recebe-corresp                 *
*                                           Revisao do layout                 *
*      D.04.000  21/02/2000  Daniela C.     Acrescimo do campo:               *
*                                           preserv.nm-email                  *
*                                           Consistir campos numericos que    *
*                                           contenham caracteres              *
*      D.05.000  18/09/2000  Andrea         Conversao Magnus - EMS            *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
*      E.00.001  24/11/2000  Jaque          Trocar funcao int para dec ao tes-*
*                                           tar nr-cgc-cpf-aux.               *
*      E.00.002  13/12/2000  Monia          Ler dzemit sem mascara no cgc     *
*      E.00.003  15/12/2000  Andrea         nr-cgc-dzemit-aux no include      *
*                                           Msg p. informar se o reg. vinculox*
*                                           especialidade jah existe          *
*                                           Aumentado o tamanho do campo codigo
*                                           do fornecedor de 6 para 9 e da    *
*                                           especialidade do titulo de 2 para *
*                                           3.                                *
*      E.01.000  07/05/2001  Felipe         - Conversao para o EMS 504        *
*      E.01.001  29/06/2001  Felipe         - InclusÆo dos campos tipo fluxo, *
*                                             imposto e classif. para EMS 504 *
*      E.02.000  16/07/2001  Nora           Acrescimo de parametro rtapi044   *
*      E.02.001  25/10/2001  Nora           Ajustes para aceitar oracle       *
*      E.04.001  14/12/2001  Jaque          Ver descricao no libeprog.p       * 
*      E.04.002  24/12/2001  Jaque          Ver descricao no libeprog.p       *
******************************************************************************/

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
 
 
/*----------------------- DEFINIR PARAMETRO DE ENTRADA ----------------------*/
def input parameter tp-registro-p as int                               no-undo.
 
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


        /*** Verifica se e magnus ou EMS           ***/
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
        /*** Procedure rtapi044 e variaveis        ***/
/*****************************************************************************
*      Programa .....: cg0110l.i                                             *
*      Programador ..: Janete Formigheri                                     *
*      Objetivo .....: Variaveis e Temp-Tables shared utilizadas nos progs:  *
*                      cg0110l.p e cg0111l.p                                 *
*****************************************************************************/

/*------------------------------- CAMPOS GERAIS -----------------------------*/

def var tp-anterior                         as int                      no-undo.
def var tp-ant-unid                         as int                      no-undo.
def   shared stream s-import.
def   shared stream s-export.
def   shared stream s-erro.
def   shared var nm-arquivo-importar      as char format "x(30)"      no-undo.
def   shared var nm-arquivo-serious-gerar as char format "x(30)"      no-undo.
def   shared var cd-unidade-aux           like unimed.cd-unimed       no-undo.
def   shared var cd-tab-urge-aux          like preserv.cd-tab-urge    no-undo.
def   shared var lg-calc-irrf-aux         as log                      no-undo.
def   shared var lg-cons-vinc-prest-aux   as log                      no-undo.
def   shared var lg-erro                  as logical initial no       no-undo.
def   shared var lg-erro-geral            as logical initial no       no-undo.
def   shared var tt-prest-lidos           as int                      no-undo.
def   shared var tt-prest-gravados        as int                      no-undo.
def   shared var tt-regs-gravados         as int                      no-undo.
def   shared var tt-prest-erros           as int                      no-undo.
def   shared var tt-prest-aviso           as int                      no-undo.
def   shared var in-indice-ir-aux         as int                      no-undo.
def   shared var cd-motivo-cancel-aux     like preserv.cd-motivo-cancel no-undo.
def   shared var in-movto-aux             as int format "9"             no-undo.
def   shared var lg-codigo-ptu-aux        as log label "Codigo do Prestador"
        view-as radio-set radio-buttons "Assumir do arquivo de importacao",yes,
                                        "Geracao automatica",no init yes  no-undo.

/*--------------------- CAMPOS DO REGISTRO 01 - PRESERV ---------------------*/
def   shared var c-dados                     as char format "x(1023)"               no-undo.
def   shared var c-cd-unidade                like preserv.cd-unidade                no-undo.
def   shared var c-nm-prestador              like preserv.nm-prestador              no-undo.
def   shared var c-nm-fantasia               like preserv.char-20                   no-undo.
def   shared var c-nome-abrev                like preserv.nome-abrev                no-undo.
def   shared var c-cd-grupo-prestador        like preserv.cd-grupo-prestador        no-undo.
def   shared var c-in-tipo-pessoa            like preserv.in-tipo-pessoa            no-undo.
def   shared var c-lg-medico                 like preserv.lg-medico                 no-undo.
def   shared var c-lg-cooperado              like preserv.lg-cooperado              no-undo.
def   shared var c-cd-unidade-seccional      like preserv.cd-unidade-seccional      no-undo.
def   shared var c-cd-conselho               like preserv.cd-conselho               no-undo.
def   shared var c-cd-uf-conselho            like preserv.cd-uf-conselho            no-undo.
def   shared var c-nr-registro               like preserv.nr-registro               no-undo.
def   shared var c-cd-magnus                 like preserv.cd-contratante            no-undo.
def   shared var c-en-rua                    like preserv.en-rua                    no-undo.
def   shared var c-en-bairro                 like preserv.en-bairro                 no-undo.
def   shared var c-cd-cidade                 like preserv.cd-cidade                 no-undo.
def   shared var c-en-cep                    like preserv.en-cep                    no-undo.
def   shared var c-en-uf                     like preserv.en-uf                     no-undo.
def   shared var c-nr-telefone               like preserv.nr-telefone               no-undo.
def   shared var c-cd-situacao               like preserv.cd-situacao               no-undo.
def   shared var c-dt-inclusao               like preserv.dt-inclusao               no-undo.
def   shared var c-dt-exclusao               like preserv.dt-exclusao               no-undo.
def   shared var c-nr-pis-pasep              as dec format "zzzzzzzzzz9"            no-undo.
def   shared var c-lg-sexo                   like preserv.lg-sexo                   no-undo.
def   shared var c-dt-nascimento             like preserv.dt-nascimento             no-undo.
def   shared var c-cd-insc-unimed            like preserv.cd-insc-unimed            no-undo.
def   shared var c-cd-situac-sindic          like preserv.cd-situac-sindic          no-undo.
def   shared var c-qt-produtividade          like preserv.qt-produtividade          no-undo.
def   shared var c-lg-alvara                 like preserv.lg-alvara                 no-undo.
def   shared var c-lg-registro               like preserv.lg-registro               no-undo.
def   shared var c-lg-diploma                like preserv.lg-diploma                no-undo.
def   shared var c-cd-esp-resid              like preserv.cd-esp-resid              no-undo.
def   shared var c-cd-esp-titulo             like preserv.cd-esp-titulo             no-undo.
def   shared var c-lg-malote                 like preserv.lg-malote                 no-undo.
def   shared var c-dt-atualizacao            like preserv.dt-atualizacao            no-undo.
def   shared var c-cd-userid                 like preserv.cd-userid                 no-undo. 
def   shared var c-nr-ramal                  like preserv.nr-ramal                  no-undo.
def   shared var c-cd-prestador              like preserv.cd-prestador              no-undo.
def   shared var c-cgc-cpf                   as   char format "x(19)"               no-undo.
def   shared var nr-cgc-dzemit-aux           like preserv.nr-cgc-cpf                no-undo.
def   shared var c-lg-vinc-empreg            like preserv.lg-vinc-empreg            no-undo.
def   shared var c-nr-ult-inss               like preserv.nr-ult-inss               no-undo.
def   shared var c-vl-base-irrf              like preserv.vl-base-irrf              no-undo.
def   shared var c-lg-representa-unidade     like preserv.lg-representa-unidade     no-undo.
def   shared var c-cd-tab-urge               like preserv.cd-tab-urge               no-undo.
def   shared var c-lg-divisao-honorario      like preserv.lg-divisao-honorario      no-undo.
def   shared var c-lg-recolhe-inss           like preserv.lg-recolhe-inss           no-undo.
def   shared var c-nr-inscricao-inss         like preserv.nr-inscricao-inss         no-undo.
def   shared var c-lg-recolhe-participa      like preserv.lg-recolhe-participacao   no-undo.
def   shared var c-ds-observacao               as char                              no-undo.
def   shared var c-calc-irrf                 like preserv.lg-calcula-ir             no-undo.
def   shared var c-incidir-irrf              like preserv.in-ir-atos-cooperados     no-undo.
def   shared var c-nr-ult-irrf               like preserv.nr-ult-irrf               no-undo.
def   shared var c-lg-calcula-adto           like preserv.lg-calcula-adto           no-undo.
def   shared var c-dt-calculo-adto           like preserv.dt-calculo-adto           no-undo.
def   shared var c-nr-dependentes            like preserv.nr-dependentes            no-undo.
def   shared var c-lg-pagamento-rh           like preserv.lg-pagamento-rh           no-undo.
def   shared var c-nm-email                  like preserv.nm-email                  no-undo.
def   shared var c-cd-tipo-fluxo             like preserv.cd-tipo-fluxo             no-undo.
def   shared var c-cd-imposto                like preserv.cd-imposto                no-undo.
def   shared var c-cd-classificacao-imposto  like preserv.cd-classificacao-imposto  no-undo.
def   shared var c-calc-cofins               like preserv.lg-cofins                 no-undo.
def   shared var c-calc-pispasep             like preserv.lg-pis-pasep              no-undo.
def   shared var c-calc-csll                 like preserv.lg-csll                   no-undo.
def   shared var c-cd-cofins                 like preserv.cd-imposto-cofins         no-undo.
def   shared var c-cd-classificacao-cofins   like preserv.cd-clas-imposto-cofins    no-undo.
def   shared var c-cd-pispasep               like preserv.cd-imposto-cofins         no-undo.
def   shared var c-cd-classificacao-pispasep like preserv.cd-clas-imposto-cofins    no-undo.
def   shared var c-cd-csll                   like preserv.cd-imposto-cofins         no-undo.
def   shared var c-cd-classificacao-csll     like preserv.cd-clas-imposto-cofins    no-undo.
def   shared var c-cd-inss                   like preserv.cd-imposto-inss           no-undo.
def   shared var c-cd-classificacao-inss     like preserv.cd-classificacao-imp-inss no-undo.
def   shared var c-calc-iss                  like preserv.lg-calcula-iss            no-undo.
def   shared var c-deduz-iss                 like preserv.lg-deduz-iss              no-undo.
def   shared var c-cd-iss                    like preserv.cd-imposto-iss            no-undo.
def   shared var c-cd-classificacao-iss      like preserv.cd-classificacao-imp-iss  no-undo.
def   shared var c-nr-dias-validade          like preserv.nr-dias-validade          no-undo.
def   shared var c-portador                  like preserv.portador                  no-undo.
def   shared var c-modalidade                like preserv.modalidade                no-undo.
def   shared var c-cd-banco                  like preserv.cod-banco                 no-undo.
def   shared var c-agencia                   like preserv.agencia                   no-undo.
def   shared var c-conta-corren              like preserv.conta-corren              no-undo.
def   shared var c-forma-pagto                 as char format "x(3)"                no-undo.
def   shared var c-conta-corren-digito         as char format "x(2)"                no-undo.
def   shared var c-agencia-digito              as char format "x(2)"                no-undo.
def   shared var c-calc-imposto-unico        like preserv.lg-imposto-unico          no-undo.
def   shared var c-cd-imposto-unico          like preserv.cd-imposto-unico          no-undo.
def   shared var c-cd-clas-imposto-unico     like preserv.cd-clas-imposto-unico     no-undo.
def   shared var c-retem-proc                  as char format "x(1)"                no-undo.
def   shared var c-retem-insu                  as char format "x(1)"                no-undo.
def   shared var c-cd-tipo-classif-estab       as char                              no-undo.
def   shared var c-cd-cnes                     as int  format "9999999"             no-undo.
def   shared var c-nm-diretor-tecnico          as char                              no-undo.
def   shared var c-nr-crm-dir-tecnico          as char format "x(8)"                no-undo.
def   shared var c-tp-disponibilidade          as int format "9"                    no-undo.  
def   shared var c-cd-registro-ans             as int                               no-undo.
def   shared var c-dt-inicio-contratual        as date format 99/99/9999            no-undo.
def   shared var c-lg-cooperativa              like preserv.lg-cooperativa          no-undo.
def   shared var c-ds-natureza-doc-ident       as char                              no-undo.
def   shared var c-nr-doc-ident                as char                              no-undo.
def   shared var c-ds-orgao-emissor-ident      as char                              no-undo.
def   shared var c-nm-pais-emissor-ident       as char                              no-undo.
def   shared var c-uf-emissor-ident            as char                              no-undo.
def   shared var c-dt-emissao-doc-ident        as date format 99/99/9999            no-undo.
def   shared var c-ds-nacionalidade            as char                              no-undo.
def   shared var c-nr-ver-tra                  as int format "99"                   no-undo.
def   shared var lg-layout-serious-aux         like pipresta.lg-layout-serious      no-undo.
def   shared var c-lg-acid-trab                like preserv.log-4                   no-undo.
def   shared var c-lg-tab-propria              like preserv.log-5                   no-undo.
def   shared var c-in-perfil-assistencial      like preserv.int-11                  no-undo.
def   shared var c-in-tipo-prod-atende         like preserv.int-12                  no-undo.
def   shared var c-lg-guia-medico-aux          like preserv.log-6                   no-undo.
def   shared var c-ds-end-complementar         like preserv.char-15                 no-undo.
def   shared var c-cd-conselho-dir-tec         like preserv.char-21                 no-undo.
def   shared var c-nr-conselho-dir-tec         like preserv.char-23                 no-undo.
def   shared var c-uf-conselho-dir-tec         like preserv.char-22                 no-undo.
def   shared var c-tp-rede                     like preserv.int-15                  no-undo.

def   shared var c-nr-telefone-3               like preserv.char-16                 no-undo.
def   shared var c-nr-ramal-3                  like preserv.char-17                 no-undo.
def   shared var c-nr-telefone-4               like preserv.char-18                 no-undo.
def   shared var c-nr-ramal-4                  like preserv.char-19                 no-undo.
def   shared var c-lg-calcula-iss              like preserv.lg-calcula-iss          no-undo.
def   shared var c-lg-calcula-ir               like preserv.lg-calcula-ir           no-undo.
def   shared var c-lg-pis-pasep                like preserv.lg-pis-pasep            no-undo.
def   shared var c-lg-cofins                   like preserv.lg-cofins               no-undo.
def   shared var c-lg-csll                     like preserv.lg-csll                 no-undo.
def   shared var c-lg-imposto-unico            like preserv.lg-imposto-unico        no-undo.
def   shared var c-nr-leitos-hosp-dia          like preserv.int-20                  no-undo.
def   shared var c-lg-notivisa                 like preserv.log-11                  no-undo.
def   shared var c-lg-qualiss                  like preserv.log-12                  no-undo.
def   shared var c-nr-registro1                as dec                               no-undo.
def   shared var c-nr-registro2                as dec                               no-undo.
def   shared var c-nr2-registro1               as dec                               no-undo.   
def   shared var c-nr2-registro2               as dec                               no-undo. 

def   shared var c-nm-end-web                like preserv.char-27                   no-undo.

def   shared var c-lg-prestador-acreditado   like preserv.log-9                     no-undo.
def   shared var c-cd-instituicao-acreditadora like preserv.char-24                 no-undo.
def   shared var c-cd-nivel-acreditacao      like preserv.int-17                    no-undo.

def   shared var in-pos-graduacao-aux          as char format "x(1)"                no-undo.       
def   shared var tp-pos-graduacao-aux          as int  format "9"                   no-undo.       
def   shared var in-particp-prog-cert-aux      as char format "x(1)"                no-undo.       
                                                 
def   shared var lg-publica-ans-aux          like preserv.log-15                    no-undo.  
def   shared var lg-indic-residencia-aux     like preserv.log-18                    no-undo.  
def   shared var lg-login-wsd-tiss-aux       like preserv.log-16                    no-undo.
def   shared var lg-cadu-aux                 like preserv.log-17                    no-undo.
def   shared var c-lg-sexo-aux                 as logical                           no-undo.
def   shared var c-in-tipo-especialidade-aux   as integer                           no-undo.

/*--------------------- CAMPOS DO REGISTRO 02 - PREVIESP --------------------*/      
def   shared var c-cd-vinculo                like previesp.cd-vinculo               no-undo.
def   shared var c-cd-especialid             like previesp.cd-especialid            no-undo.
def   shared var c-lg-principal              like previesp.lg-principal             no-undo.
def   shared var c-lg-considera-qt-vinculo   like previesp.lg-considera-qt-vinculo  no-undo.

def   shared temp-table wk-reg2                                                     no-undo
    field cd-vinculo                    like previesp.cd-vinculo
    field cd-especialid                 like previesp.cd-especialid
    field lg-principal                  like previesp.lg-principal
    field lg-considera-qt-vinculo       like previesp.lg-considera-qt-vinculo
    field cd-registro-espec             like previesp.cd-registro-especialidade
    field cd-tipo-contratualizacao      like previesp.in-contratualizacao
    field lg-rce                        like previesp.log-4
    field cd-registro-espec-2           like previesp.dec-1
    field in-tipo-especialidade         like previesp.int-2
    field cd-tit-cert-esp               like previesp.int-3
    index wk1 is primary
          cd-vinculo   
          cd-especialid.

/*--------------------- CAMPOS DO REGISTRO 03 - ENDPRES ---------------------*/
def   shared temp-table wk-reg3                                      no-undo
    field nr-seq-endereco                like endpres.nr-seq-endereco
    field en-endereco                    like endpres.en-endereco
    field en-complemento                   as char format "x(15)"
    field en-bairro                      like endpres.en-bairro
    field cd-cidade                      like endpres.cd-cidade
    field en-cep                         like endpres.en-cep
    field en-uf                          like endpres.en-uf
    field nr-fone                        like endpres.nr-fone
    field nr-ramal                       like endpres.nr-ramal
    field hr-man-ent                     like endpres.hr-man-ent
    field hr-man-sai                     like endpres.hr-man-sai
    field hr-tar-ent                     like endpres.hr-tar-ent
    field hr-tar-sai                     like endpres.hr-tar-sai
    field hr-man-ent-segunda             like endpres.hr-man-ent-segunda 
    field hr-man-sai-segunda             like endpres.hr-man-sai-segunda 
    field hr-tar-ent-segunda             like endpres.hr-tar-ent-segunda 
    field hr-tar-sai-segunda             like endpres.hr-tar-sai-segunda 
    field hr-man-ent-terca               like endpres.hr-man-ent-terca   
    field hr-man-sai-terca               like endpres.hr-man-sai-terca   
    field hr-tar-ent-terca               like endpres.hr-tar-ent-terca   
    field hr-tar-sai-terca               like endpres.hr-tar-sai-terca   
    field hr-man-ent-quarta              like endpres.hr-man-ent-quarta  
    field hr-man-sai-quarta              like endpres.hr-man-sai-quarta  
    field hr-tar-ent-quarta              like endpres.hr-tar-ent-quarta  
    field hr-tar-sai-quarta              like endpres.hr-tar-sai-quarta  
    field hr-man-ent-quinta              like endpres.hr-man-ent-quinta  
    field hr-man-sai-quinta              like endpres.hr-man-sai-quinta  
    field hr-tar-ent-quinta              like endpres.hr-tar-ent-quinta  
    field hr-tar-sai-quinta              like endpres.hr-tar-sai-quinta  
    field hr-man-ent-sexta               like endpres.hr-man-ent-sexta   
    field hr-man-sai-sexta               like endpres.hr-man-sai-sexta   
    field hr-tar-ent-sexta               like endpres.hr-tar-ent-sexta   
    field hr-tar-sai-sexta               like endpres.hr-tar-sai-sexta   
    field hr-man-ent-sabado              like endpres.hr-man-ent-sabado  
    field hr-man-sai-sabado              like endpres.hr-man-sai-sabado  
    field hr-tar-ent-sabado              like endpres.hr-tar-ent-sabado  
    field hr-tar-sai-sabado              like endpres.hr-tar-sai-sabado  
    field hr-man-ent-domingo             like endpres.hr-man-ent-domingo 
    field hr-man-sai-domingo             like endpres.hr-man-sai-domingo 
    field hr-tar-ent-domingo             like endpres.hr-tar-ent-domingo 
    field hr-tar-sai-domingo             like endpres.hr-tar-sai-domingo 
    field lg-dias-trab                   like endpres.lg-dias-trab
    field lg-malote                      like endpres.lg-malote
    field lg-recebe-corresp              like endpres.lg-recebe-corresp
    field lg-tipo-endereco               like endpres.lg-tipo-endereco
    field in-tipo-endereco               as int format "9"
    field cd-cnes                        as int format "9999999"
    field nr-leitos-tot                  as char format "x(06)"
    field nr-leitos-contrat              as char format "x(06)"
    field nr-leitos-psiquiat             as char format "x(06)"
    field nr-uti-adulto                  as char format "x(06)"
    field nr-uti-neonatal                as char format "x(06)"
    field nr-uti-neo-interm-neo          as char format "x(06)"
    field nr-uti-pediatria               as char format "x(06)"
    field ds-complementar                like preserv.char-15
    field nr-cgc-cpf                     like preserv.nr-cgc-cpf
        field lg-filial                      like endpres.log-1
    field nr-leitos-hosp-dia             as int format "999999"
    field nm-end-web                     like endpres.nm-end-web
    field nr-leitos-tot-clin-n-uti       as int format "999999"
    field nr-leitos-tot-cirur-n-uti      as int format "999999"
    field nr-leito-tot-obst-n-uti        as int format "999999"
    field nr-leitos-tot-ped-n-uti        as int format "999999"
    field nr-leitos-tot-psic-n-uti       as int format "999999"
    field nm-latitue                     as char format "x(20)"
    field nm-longitude                   as char format "x(20)"
    field nr-uti-neo-interm              as char format "x(06)"
    index wk1 is primary
          nr-seq-endereco.

/*--------------------- CAMPOS DO REGISTRO 04 - PREST-INST ------------------*/
def   shared temp-table wk-reg4                                                     no-undo
    field cod-instit              like prest-inst.cod-instit
    field cdn-nivel               like prest-inst.cdn-nivel
    field lg-autoriz-divulga      like prest-inst.log-livre-1
    field cd-seq-end              like prest-inst.num-livre-1.

/*--------------------- CAMPOS DO REGISTRO 05 - PREST-OBS  ------------------*/
def   shared temp-table wk-reg5                                                     no-undo
    field divulga-obs             like prestdor-obs.des-obs.


/*--------------------- CAMPOS DO REGISTRO 06 - PRESTADOR SUBSTITUTO  ------------------*/
def   shared var c-cd-unidade-subst         like preserv.cd-unidade                no-undo. /*manter campos para nao dar erro de compilacao no lacg037.p*/
def   shared var c-cd-prest-subst           like preserv.cd-prestador              no-undo.
def   shared var c-dt-inicio-subst          like preserv.dt-inclusao               no-undo.

def   shared temp-table wk-reg6                                                     no-undo
    field c-cd-unidade-subst      like preserv.cd-unidade                
    field c-cd-prest-subst        like preserv.cd-prestador              
    field c-dt-inicio-subst       like preserv.dt-inclusao.              
     
def   shared var c-cd-motivo-exclusao  like preserv.cd-motivo-cancel.

/*----------------------- DEFINIR TEMP-TABLE DE ERROS -----------------------*/
def   shared temp-table wk-erros                                     no-undo
    field cd-tipo-erro   as char format "x(01)"
    field cd-tipo-regs   as int
    field ds-desc        as char format "x(120)"
    field cd-unidade     like preserv.cd-unidade
    field cd-prestador   like preserv.cd-prestador
    field nm-prestador   like preserv.nm-prestador
    field nome-abrev     like preserv.nome-abrev
    field in-tipo-pessoa like preserv.in-tipo-pessoa
    field nr-cgc-cpf     like preserv.nr-cgc-cpf
    index wk-erros1 is primary
          cd-unidade
          cd-prestador
    index wk-erros2
          cd-tipo-regs.

/* ----------------------------------- DEFINIR TEMP-TABLE PARA IMPRESSAO --- */
def   shared temp-table tmp-preserv no-undo
    field in-movto                    as int
    field cd-unidade                  like preserv.cd-unidade
    field cd-prestador                like preserv.cd-prestador
    field nm-prestador                like preserv.nm-prestador
    field nome-abrev                  like preserv.nome-abrev
    field in-tipo-pessoa              like preserv.in-tipo-pessoa
    field nr-cgc-cpf                  like preserv.nr-cgc-cpf
    index tmp-prest1 is primary
          cd-unidade
          cd-prestador.

def   shared temp-table tmp-previesp no-undo
    field cd-unidade                   like previesp.cd-unidade
    field cd-prestador                 like previesp.cd-prestador
    field cd-vinculo                   like previesp.cd-vinculo
    field cd-especialid                like previesp.cd-especialid
    field lg-principal                 like previesp.lg-principal
    field lg-considera-qt-vinculo      like previesp.lg-considera-qt-vinculo
    field cd-registro-especialidade    like previesp.cd-registro-especialidade
    field dec-1                        like previesp.dec-1                    
    field int-2                        like previesp.int-2
    field int-3                        like previesp.int-3
    index tmp-prev1 is primary
          cd-unidade
          cd-prestador
          cd-vinculo    
          cd-especialid.

def   shared temp-table tmp-endpres no-undo
    field cd-unidade                  like endpres.cd-unidade
    field cd-prestador                like endpres.cd-prestador
    field en-endereco                 like endpres.en-endereco
    field en-complemento                as char format "x(15)"
    field en-bairro                   like endpres.en-bairro
    field en-cep                      like endpres.en-cep
    field en-uf                       like endpres.en-uf
    index tmp-end1 is primary
          cd-unidade
          cd-prestador.

def   shared temp-table tmp-prest-inst no-undo
    field cd-unidade                  like prest-inst.cd-unidade
    field cd-prestador                like prest-inst.cd-prestador
    field cod-instit                  like prest-inst.cod-instit
    field cdn-nivel                   like prest-inst.cdn-nivel
    field lg-autoriz-divulga          like prest-inst.log-livre-1
    field cd-seq-end                  like prest-inst.num-livre-1
    index tmp-inst1 is primary
          cd-unidade
          cd-prestador.

def   shared temp-table tmp-prestdor-obs no-undo
    field cd-unidade                  like prestdor-obs.cdn-unid-prestdor
    field cd-prestador                like prestdor-obs.cdn-prestdor
    field des-obs                     like prestdor-obs.des-obs
    index tmp-inst1 is primary
          cd-unidade
          cd-prestador.

/* -----------------------DEFINIR TEMP-TABLE PARA PRESTADOR x AREA ATUACAO --- */

def   shared temp-table temp-prestdor-x-area-atuac no-undo
    field cd-cgc                      as char format "x(15)"
    field nm-prestador                as char format "x(40)"
    field cdn-area-atuac              like prest-area-atu.cdn-area-atuac
    field log-certif                  like prest-area-atu.log-certif
    field cd-registro-1               as dec
    field cd-registro-2               as dec
    index temp-prest-area-atuac1 is primary
          cd-cgc
          nm-prestador
          cdn-area-atuac.

/* ----------------------------------------------------------------- EOF --- */
   /*variaveis auxiliares e temp-tables*/
/* cgp/cg0110l.f */

/*--------------------- DEFINIR FRAMES DE ERROS E ACERTOS--------------------*/

def   shared frame f-lista
    wk-erros.cd-unidade     column-label "Unid"                      
    wk-erros.cd-prestador   column-label "Prestador"                 
    wk-erros.nm-prestador   column-label "Nome Prestador"            
    wk-erros.nome-abrev     column-label "Nome Abreviado"            
    wk-erros.in-tipo-pessoa column-label "Tp.Pes."                   
    wk-erros.nr-cgc-cpf     column-label "CGC/CPF" 
    with down no-box overlay width 282.
    
def   shared frame f-lista-1
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    with down no-box overlay width 282.

def   shared frame f-lista-2
    space(3)
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    wk-reg2.cd-vinculo     column-label "Cod.Vinc."
    wk-reg2.cd-especialid  column-label "Cod.Esp."
    with down no-box overlay width 282.

def   shared frame f-lista-3
    space(3)
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    with down no-box overlay width 282.

def   shared frame f-lista-4
    space(3)
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    with down no-box overlay width 282.

def   shared frame f-lista-acertos-2
    space(3)
    wk-reg2.cd-vinculo     column-label "Cod.Vinc."
    wk-reg2.cd-especialid  column-label "Cod.Esp."
    wk-reg2.lg-principal
    wk-reg2.lg-considera-qt-vinculo
    with down no-box overlay width 282.

def   shared frame f-lista-acertos-3
    space(3)
    wk-reg3.en-endereco    column-label "Endereco"
    wk-reg3.en-bairro      column-label "Bairro"
    wk-reg3.en-cep         column-label "CEP"
    wk-reg3.en-uf          column-label "UF"
    with down no-box overlay width 282.

def   shared frame f-lista-acertos-4
    space(3)
    wk-reg4.cod-instit         column-label "Instituicao"
    wk-reg4.cdn-nivel          column-label "Nivel"
    wk-reg4.lg-autoriz-divulga column-label "Aut. Divulgacao"
    wk-reg4.cd-seq-end         column-label "Seq. Endereco"
    with down no-box overlay width 282.
    
def   shared frame f-lista-acertos-5
    space(3)
    wk-reg5.divulga-obs format "x(250)"    column-label "Observacoes" 
    with down no-box overlay width 282.

/* ----------------------------------------------------------------- EOF --- */
   /*frames*/
 
/* ----------------------------- DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRPORTAD.I --- */
/*****************************************************************************
*      Include  .....: srportad.iv                                           *
*      Data .........: 15 de Maio de 2001                                    *
*      Empresa ......: DZSET SOLUCOES & SISTEMAS                             *
*      Programador ..: Jaqueline Formigheri                                  *
*      Objetivo .....: Variaveis do include srportad.i - Portador            *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL      MOTIVO                         *
*      E.00.000  15/05/2001  Jaque            Desenvolvimento - EMS504.      *
*****************************************************************************/

def var lg-avail-portador-srems  as log                 no-undo.
def var nm-portador-srems        as char format "x(40)" no-undo.
def var lg-avail-carteira-srems  as log                 no-undo.
def var cod-portador-srems       as char                no-undo.

/*** Final do include ***/
 

/* ----------------------------- DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRCARTBC.I --- */
/************************************************************************************************
*      Programa .....: srcartbc.iv                                                              *
*      Data .........: 24 de Agosto de 2001                                                     *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                                          *
*      Sistema ......: SRINCL - INCLUDES PARA CONVERSAO DE SISTEMAS                             *
*      Cliente ......: COOPERATIVAS MEDICAS                                                     *
*      Programador ..: Leonardo Deimomi                                                         *
*      Objetivo .....: Definicao de variaveis do include srcartbc.i                             *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      E.00.000  24/08/2001  Leonardo        Desenvolvimento                                    *
************************************************************************************************/

def var lg-avail-srcartbc-srems                as log                                    no-undo.
def var ds-cart-bcia-srems                     as char format "x(40)"                    no-undo.

/* ------------------------------------------------------------------------------------------- */
 

/* ------------------------------ DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRBANCO.I --- */
/************************************************************************************************
*      Programa .....: srbanco.iv                                                               *
*      Data .........: 23 de Agosto de 2001                                                     *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                                          *
*      Sistema ......: SRINCL - INCLUDES PARA CONVERSAO DE SISTEMAS                             *
*      Cliente ......: COOPERATIVAS MEDICAS                                                     *
*      Programador ..: Leonardo Deimomi                                                         *
*      Objetivo .....: Definicao de variaveis do include srbanco.i                              *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      E.00.000  23/08/2001  Leonardo        Desenvolvimento                                    *
************************************************************************************************/

def var lg-avail-srbanco-srems                 as log                                    no-undo.
def var nm-banco-srems                         as char format "x(30)"                    no-undo.

/* ------------------------------------------------------------------------------------------- */
 

/*---------------------------- VARIAVEIS DE USO GERAL -----------------------*/
def shared var c-nr-seq-endereco  as int                               no-undo.
def shared var lg-aviso           as logical initial no                no-undo.
def shared var tp-registro        as int                               no-undo.
def shared var ep-codigo-aux      like paramecp.ep-codigo              no-undo.

def var lg-erro-cgc               as log                               no-undo.
def var ix                        as int                               no-undo.
def var ix2                       as int                               no-undo.
 
def var nr-cgc-cpf-aux           like preserv.nr-cgc-cpf               no-undo.
def var lg-formato-livre-aux       as log                              no-undo.
def var ix-cont-aux                as int                              no-undo.

def var c-versao                   as char                             no-undo.
def var hr-aux                     as char format "x(04)"              no-undo.
def var nr-digito-aux              as int                              no-undo.
def var lg-ok-aux                  as log                              no-undo.
def var ds-mens-aux                as char format "x(70)"              no-undo.

/* algumas validacoes podem ser ignoradas temporariamente preenchendo uma data maior que TODAY nessa variavel*/
DEF VAR dt-ignorar-validacao-aux   AS DATE INIT 7/1/18                 NO-UNDO.

/* ----- DEFINICAO DE VARIAVEIS DA ROTINA RTCGCCPF ------------------------- */
def            var nr-cgc-cpf          as char format "x(14)"          no-undo.
def            var ds-mensrela-aux     as char format "x(132)"         no-undo.
def            var lg-erro-cgc-cpf-aux as log                          no-undo.
 
c-versao = c_prg_vrs.

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
    
 

/* ----------------------------------- LOCALIZA OS PARAMETROS DO SISTEMA --- */
find first paramecp no-lock no-error.
find first paramepp no-lock no-error.

/* --- VERIFICA SE O FORMATO DO CGC/CPF POSSUI EDICAO LIVRE --- */
assign lg-formato-livre-aux = yes.

if   c-in-tipo-pessoa = "F"
then do:
       do ix-cont-aux = 1 to length(trim(paramecp.ds-formato-cpf)):

          if   substring(paramecp.ds-formato-cpf,ix-cont-aux,1) <> "X"
          then do:
                 assign lg-formato-livre-aux = no.
                 leave.
               end.
       end.
     end.

else do:
       do ix-cont-aux = 1 to length(trim(paramecp.ds-formato-cgc)):

          if   substring(paramecp.ds-formato-cgc,ix-cont-aux,1) <> "X"
          then do:
                 assign lg-formato-livre-aux = no.
                 leave.
               end.
       end.
     end.

/*---------------------- INICIA PROCESSO DE CONSISTENCIA --------------------*/
 
/*----- VERIFICA TIPO DO REGISTRO DA PRESERV A IMPORTAR -----*/
case tp-registro-p:
   when 1
   then run imp-reg-preserv.
 
   when 2
   then run imp-reg-previesp.
 
   when 3
   then run imp-reg-endpres.

   when 4
   then run imp-reg-prest-inst.

   when 5
   then run imp-reg-prestdor-obs.

   when 6
   then run imp-reg-prest-subst.
end case.

/*---------------------------------------------------------------------------*/
/* IMPORTAR TABELA PRESERV ( DEVE EXISTIR UM UNICO REGISTRO )                */
/*---------------------------------------------------------------------------*/
 
procedure imp-reg-preserv:
   DEF VAR lg-erro-endereco AS LOG INIT NO NO-UNDO.

   /* ------------------------------------ CONSISTE CAMPO CODIGO UNIDADE --- */
   assign c-cd-unidade = int(substring(c-dados,002,04)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Codigo Unidade ("
                                       + substring(c-dados,002,04)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-unidade = 0
          or   c-cd-unidade = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Codigo Unidade nao Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-unidade < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Unidade ("
                                                     + string(c-cd-unidade)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find unimed where
                             unimed.cd-unimed = c-cd-unidade
                             no-lock no-error.
 
                        if   not avail unimed
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Unidade ("
                                                            + string(c-cd-unidade,"9999")
                                                            + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.

   /* ------------------------------------ CONSISTE CAMPO NOME PRESTADOR --- */
   assign c-nm-prestador = trim(substring(c-dados,1178,70)).

   if   trim(c-nm-prestador) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nome do Prestador nao Informado".
          assign lg-erro = yes.
        end.

   assign c-nm-fantasia = trim(substring(c-dados,1138,40)).
   /* ---------------------------------- CONSISTE CAMPO CODIGO PRESTADOR --- */
   assign c-cd-prestador = int(substring(c-dados,006,08)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Codigo Prestador ("
                                       + substring(c-dados,006,08)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-prestador <> 0
          and  c-cd-prestador <> ?
          then do:
                 if   c-cd-prestador < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Prestador ("
                                                     + string(c-cd-prestador)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
               end.
        end.
        
   /* ---------------------------------- CRIAR CODIGO PARA O PRESTADOR ----- */
   if   c-cd-prestador = 0 
   then do:

          find last preserv
              where preserv.cd-unidade = c-cd-unidade
                    no-lock no-error.
          
          if   avail preserv
          then do:
          
                 if   preserv.cd-prestador >= 99999999 
                 then do:
                        assign c-nome-abrev     = substring(c-dados,54,12)  
                               c-in-tipo-pessoa = substring(c-dados,66,1)
                               c-cgc-cpf        = substring(c-dados,272,19).
          
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo prestador nao pode ser maior "
                                                     + "que 99999999 "
                                                     + "na unidade "  
                                                     + string(c-cd-unidade).
          
                        assign lg-erro = yes.
                      end.
          
                 assign c-cd-prestador = preserv.cd-prestador + 1.
               end.
          else assign c-cd-prestador = 1.      

        end.

   /* ------------------------------------ CONSISTE CAMPO NOME ABREVIADO --- */
   assign c-nome-abrev = trim(substring(c-dados,054,12)).
 
   if   trim(c-nome-abrev) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nome Abreviado do Prestador nao "
                                       + "Informado".
          assign lg-erro = yes.
        end.
 
   /* --------------------------------------- CONSISTE CAMPO TIPO PESSOA --- */
   assign c-in-tipo-pessoa = trim(substring(c-dados,066,01)).
 
   if   trim(c-in-tipo-pessoa) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Tipo de Pessoa nao Informado".
          assign lg-erro = yes.
        end.
   else do:
          if   c-in-tipo-pessoa <> "F"
          and  c-in-tipo-pessoa <> "J"
          and  c-in-tipo-pessoa <> "E"
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Tipo de "
                                              + "Pessoa ("
                                              + c-in-tipo-pessoa
                                              + ") NAO CONFERE com os "
                                              + "Conteudos Definidos no "
                                              + "Layout de Importacao (F/J/E)".
                 assign lg-erro = yes.
               end.
        end.
 
   /* ----------------------------------- CONSISTE CAMPO GRUPO PRESTADOR --- */
   assign c-cd-grupo-prestador = int(substring(c-dados,067,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Grupo Prestador ("
                                       + substring(c-dados,067,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-grupo-prestador = 0
          or   c-cd-grupo-prestador = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Grupo Prestador nao "
                                              + "Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-grupo-prestador < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Grupo Prestador ("
                                                     + string(c-cd-grupo-prestador)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find gruppres where
                             gruppres.cd-grupo-prestador = c-cd-grupo-prestador
                             no-lock no-error.
 
                        if   not avail gruppres
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Grupo Prestador ("
                                                     + string(c-cd-grupo-prestador,"99")
                                                     + ") nao Cadastrado".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.

   /* -------------------------------------------- CONSISTE CAMPO MEDICO --- */
   case trim(substring(c-dados,069,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-medico = yes.
 
      when "N"
      then assign c-lg-medico = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Medico ("
                                          + substring(c-dados,069,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* --------------------------------------- CONSISTE CAMPO CREDENCIADO --- */
   case trim(substring(c-dados,070,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Credenciado (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-cooperado = yes.
 
      when "N"
      then assign c-lg-cooperado = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Credenciado ("
                                          + substring(c-dados,070,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
   
   /* ----------------- Consiste Cooperativa Medica ------------------------  */ 
   case trim(substring(c-dados,1023,1)):
      
      when "S"
      then do: 
             if c-lg-cooperado = yes
             or c-in-tipo-pessoa <> "J"
             then do:
                    create wk-erros.                                                   
                    assign wk-erros.cd-tipo-erro = "E"                                 
                           wk-erros.cd-tipo-regs = 1                                   
                           wk-erros.ds-desc      = "Conteudo do Campo Cooperativa Medica (S) " 
                                                 + "Invalido para prestadores credenciados "
                                                 + "ou tipo de pessoa diferente de juridica".                        
                    assign lg-erro = yes.                                              
                  end.
             else if "ems505" = "ems" 
                  or "ems505" = "magnus"
                  then do:
                         create wk-erros.                                                   
                         assign wk-erros.cd-tipo-erro = "E"                                 
                                wk-erros.cd-tipo-regs = 1                                   
                                wk-erros.ds-desc      = "Conteudo do Campo Cooperativa Medica (S) " 
                                                      + "permitido apenas para sistema EMS5".
                         assign lg-erro = yes.                                              
                       end.
                  else assign c-lg-cooperativa = yes.
           end.

      when "N"
      then assign c-lg-cooperativa = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Cooperativa Medica ("
                                          + substring(c-dados,1023,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

   /* --------------------------------- CONSISTE CAMPO UNIDADE SECCIONAL --- */
   assign c-cd-unidade-seccional = int(substring(c-dados,071,04)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Unidade Seccional ("
                                       + substring(c-dados,071,04)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-unidade-seccional <> 0
          and  c-cd-unidade-seccional <> ?
          then do:
                 if   c-cd-unidade-seccional < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Unidade Seccional ("
                                                     + string(c-cd-unidade-seccional)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find unimed where
                             unimed.cd-unimed = c-cd-unidade-seccional
                             no-lock no-error.
 
                        if   not available unimed
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Unidade Seccional ("
                                                     + string(c-cd-unidade-seccional,"9999")
                                                     + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ------------------------------------------ CONSISTE CAMPO CONSELHO --- */
   assign c-cd-conselho = trim(substring(c-dados,075,05)).
 
   if   trim(c-cd-conselho) <> ""
   then do:
          find conpres where
               conpres.cd-conselho = c-cd-conselho
               no-lock no-error.
 
          if   not avail conpres
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conselho ("
                                              + trim(c-cd-conselho)
                                              + ") nao Cadastrado".
                 assign lg-erro = yes.
               end.
        end.
 
   /* --------------------------------------- CONSISTE CAMPO UF CONSELHO --- */
   assign c-cd-uf-conselho = trim(substring(c-dados,080,02)).
 
   if   trim(c-cd-uf-conselho) <> ""
   then do:
          find dzestado
               where dzestado.nm-pais = "Brasil"
                 and dzestado.en-uf   = c-cd-uf-conselho
                     no-lock no-error.
 
          if   not avail dzestado
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "UF Conselho ("
                                              + trim(c-cd-uf-conselho)
                                              + ") nao Cadastrada para "
                                              + "Pais: Brasil".
                 assign lg-erro = yes.
               end.
        end.
 
   
   /* ---------------------------------------- CONSISTE CAMPO FORNECEDOR --- */
   assign c-cd-magnus = int(substring(c-dados,090,09)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Fornecedor ("
                                       + substring(c-dados,090,09)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-magnus <> 0
          and  c-cd-magnus <> ?
          then do:
                 if   c-cd-magnus < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Fornecedor ("
                                                     + string(c-cd-magnus)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        assign
                        cd-contratante-rtapi044-aux   = c-cd-magnus
                        lg-prim-mens-rtapi044-aux     = no
                        in-funcao-rtapi044-aux        = "GDT"
                        in-tipo-emitente-rtapi044-aux = "PRESTA"
                        in-tipo-pessoa-rtapi044-aux   = c-in-tipo-pessoa.
 
                        run rtapi044.
 
                        find first tmp-rtapi044 no-lock no-error.
 
                        if   not avail tmp-rtapi044
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Prestador/Fornecedor ("
                                                     + string(c-cd-magnus,"999999999")
                                                     + ") nao Cadastrado no "
                                                     + "Magnus/EMS como Emitente "
                                                     + "- Fornecedor ou Ambos".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------------------------------- CONSISTE CAMPO RUA --- */
   assign c-en-rua    = trim(substring(c-dados,099,40)).
 
   /* -------------------------------------------- CONSISTE CAMPO BAIRRO --- */
   assign c-en-bairro = trim(substring(c-dados,139,15)).
 
   /* -------------------------------------------- CONSISTE CAMPO CIDADE --- */
   assign c-cd-cidade = int(substring(c-dados,154,06)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Cidade ("
                                       + substring(c-dados,154,06)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   
   /* ------------------------------------------------------ CONSISTE CAMPO CEP --- */
   assign c-en-cep = trim(string(int(substring(c-dados,160,08)),"99999999")) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "CEP ("
                                       + substring(c-dados,160,08)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------------------ CONSISTE CAMPO UF --- */
   assign c-en-uf = trim(substring(c-dados,168,02)).
 
   run consiste-endereco (input c-cd-cidade,
                          input c-en-uf,
                          input c-en-cep,
                          input c-en-rua,
                          input c-en-bairro,
                          input c-in-tipo-pessoa,
                          input "P",
                          input-output lg-erro-endereco, 
                          input 1).

   IF lg-erro-endereco 
   THEN lg-erro = YES.

   /* ---------------------------------------- CONSISTE CAMPO TELEFONE 1 --- */
   assign c-nr-telefone[1] = trim(substring(c-dados,982,20)).
 
   /* ---------------------------------------- CONSISTE CAMPO TELEFONE 2 --- */
   assign c-nr-telefone[2] = trim(substring(c-dados,1002,20)).
 
   /* ------------------------ CONSISTE CAMPO DATA INCLUSAO DO PRESTADOR --- */
   assign c-dt-inclusao = ?.

   if   trim(substring(c-dados,194,08)) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Data de Inclusao do Prestador nao Informada".
          assign lg-erro = yes.
        end.
   else do:
          if   length(trim(substring(c-dados,194,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Inclusao do Prestador Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,194,08)) = "00000000"
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data de Inclusao do "
                                                     + "Prestador nao Informada".
                        assign lg-erro = yes.
                      end.
                 else do:
                        assign c-dt-inclusao = date(int(substring(c-dados,196,02)),
                                                    int(substring(c-dados,194,02)),
                                                    int(substring(c-dados,198,04))) no-error.
 
                        if   error-status:error
                        then do:

                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data de Inclusao do Prestador ("
                                                            + substring(c-dados,194,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ------------------------ CONSISTE CAMPO DATA EXCLUSAO DO PRESTADOR --- */
   assign c-dt-exclusao = ?.

   if   trim(substring(c-dados,202,08)) = ""
   then assign c-dt-exclusao = ?.
   else do:
          if   length(trim(substring(c-dados,202,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Exclusao do Prestador Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,202,08)) = "00000000"
                 then assign c-dt-exclusao = ?.
                 else do:
                        assign c-dt-exclusao = date(int(substring(c-dados,204,02)),
                                                    int(substring(c-dados,202,02)),
                                                    int(substring(c-dados,206,04))) no-error.
 
                        if   error-status:error
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data de Exclusao do Prestador ("
                                                            + substring(c-dados,202,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                        else do:
                               if   c-dt-exclusao < c-dt-inclusao
                               then do:
                                      create wk-erros.
                                      assign wk-erros.cd-tipo-erro = "E"
                                             wk-erros.cd-tipo-regs = 1
                                             wk-erros.ds-desc      = "Data de Exclusao do "
                                                                   + "Prestador INFERIOR a "
                                                                   + "Data de Inclusao do "
                                                                   + "Prestador".
                                      assign lg-erro = yes.
                                    end.
                             end.
                      end.
               end.
        end.
 
   /* ---------------------------------------------- CONSISTE CAMPO SEXO --- */
   if   c-in-tipo-pessoa = "F"
   then case substring(c-dados,210,01):
           when ""
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Sexo (Fem/Mas) nao Informado".
                  assign lg-erro = yes.
                end.
 
           when "F"
           then assign c-lg-sexo = yes.
 
           when "M"
           then assign c-lg-sexo = no.
 
           otherwise
                do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Conteudo do Campo Sexo ("
                                               + substring(c-dados,210,01)
                                               + ") NAO CONFERE com os "
                                               + "Conteudos Definidos no "
                                               + "Layout de Importacao (F/M)".
                  assign lg-erro = yes.
                end.
        end case.
   else assign c-lg-sexo = no.
 
   /* ---------- CONSISTE CAMPO DATA NASCIMENTO OU FUNDACAO DO PRESTADOR --- */
   if   trim(substring(c-dados,208,08)) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Data de Nascimento ou Fundacao do "
                                       + "Prestador nao Informada".
          assign lg-erro = yes.
        end.
   else do:
          if   length(trim(substring(c-dados,211,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Nascimento ou "
                                              + "Fundacao do Prestador "
                                              + "Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,211,08)) = "00000000"
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data de Nascimento ou "
                                                     + "Fundacao do Prestador "
                                                     + "nao Informada".
                        assign lg-erro = yes.
                      end.
                 else do:
                        assign c-dt-nascimento = date(int(substring(c-dados,213,02)),
                                                      int(substring(c-dados,211,02)),
                                                      int(substring(c-dados,215,04))) no-error.
 
                        if   error-status:error
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data de Nascimento ou "
                                                            + "Fundacao do Prestador ("
                                                            + substring(c-dados,211,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                        else do:
                               if   c-dt-nascimento > today
                               then do:
                                      create wk-erros.
                                      assign wk-erros.cd-tipo-erro = "E"
                                             wk-erros.cd-tipo-regs = 1
                                             wk-erros.ds-desc      = "Data de Nascimento ou "
                                                                   + "Fundacao do Prestador "
                                                                   + "SUPERIOR a Data da "
                                                                   + "Importacao".
                                      assign lg-erro = yes.
                                    end.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------- CONSISTE CAMPO INSCRICAO PRESTADOR UNIDADE --- */
   assign c-cd-insc-unimed = int(substring(c-dados,219,04)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Inscricao Prestador Unidade ("
                                       + substring(c-dados,219,04)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-insc-unimed <> 0
          and  c-cd-insc-unimed <> ?
          then do:
                 if   c-cd-insc-unimed < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Inscricao Prestador "
                                                     + "Unidade ("
                                                     + string(c-cd-insc-unimed)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
               end.
        end.
 
   /* ------------------------------------- CONSISTE CAMPO SITUACAO SINDICAL --- */
   assign c-cd-situac-sindic = trim(substring(c-dados,223,02)).
 
   /* ------------------- CONSISTE CAMPO FATOR DE PRODUTIVIDADE DO PRESTADOR --- */
   assign c-qt-produtividade = dec(substring(c-dados,225,12)) / 100 no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Fator de Produtividade do Prestador ("
                                       + substring(c-dados,225,12)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------- CONSISTE CAMPO POSSUI ALVARA --- */
   case substring(c-dados,237,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Possui Alvara (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-alvara = yes.
 
      when "N"
      then assign c-lg-alvara = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Possui Alvara ("
                                          + substring(c-dados,234,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ----------------------- CONSISTE CAMPO NUMERO DO PIS/PASEP --- */
   assign c-nr-pis-pasep = dec(substring(c-dados,617,11)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Numero do PIS/PASEP "
                                       + string(substring(c-dados,617,11),"x(11)")
                                       + " nao Numerico"
                 lg-erro               = yes.
        end.
   else if   c-nr-pis-pasep = ?
        then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "Numero do PIS/PASEP = ?, Invalido"
                       lg-erro               = yes.
             end.
 

   /* ----------------------- CONSISTE CAMPO NUMERO DA INSCRICAO INSS --*/
   assign c-nr-inscricao-inss = trim(substring(c-dados,628,14)).

   if   c-nr-inscricao-inss <> ""
   then do:
           assign nr-digito-aux = int(substr(string(c-nr-inscricao-inss,"99999999999"),11,1)).
                    
           run rtp/rtdigver.p("INSS",
                              yes,
                              substr(string(c-nr-inscricao-inss, "99999999999"),1,11),
                              no,
                              output ds-mens-aux,
                              output lg-ok-aux,
                              input-output nr-digito-aux).

           RUN escrever-log("########VALIDAR DIGITO INSS###############c-cd-unidade: " + STRING(c-cd-unidade) +
                            " c-cd-prestador: "      + STRING(c-cd-prestador) +
                            " c-nm-prestador: "      + STRING(c-nm-prestador) +
                            " c-nome-abrev: "        + STRING(c-nome-abrev) +
                            " c-in-tipo-pessoa: "    + STRING(c-in-tipo-pessoa) +
                            " c-cgc-cpf: "           + STRING(c-cgc-cpf) +
                            " c-nr-inscricao-inss: " + STRING(c-nr-inscricao-inss) +
                            " OK?: "                 + STRING(lg-ok-aux)).

           if not lg-ok-aux

           AND dt-ignorar-validacao-aux < TODAY

           then do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = ds-mens-aux + " para Nr.Inscricao INSS (" + c-nr-inscricao-inss + ")"
                          lg-erro               = yes.
                end.
        end.
    
   /* ------------------------------ CONSISTE CAMPO POSSUI REGISTRO INSS --- */
   case substring(c-dados,238,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Possui Registro INSS (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-registro = yes.
 
      when "N"
      then assign c-lg-registro = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo  ("
                                          + substring(c-dados,235,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------------ CONSISTE CAMPO POSSUI DIPLOMA --- */
   case substring(c-dados,239,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Possui Diploma (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-diploma = yes.
 
      when "N"
      then assign c-lg-diploma = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Possui Diploma ("
                                          + substring(c-dados,239,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* -------------------------- CONSISTE CAMPO ESPECIALIDADE RESIDENCIA --- */
   assign c-cd-esp-resid = int(substring(c-dados,240,03)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Especialidade Residencia ("
                                       + substring(c-dados,240,03)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-esp-resid <> 0
          and  c-cd-esp-resid <> ?
          then do:
                 if   c-cd-esp-resid < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade Residencia ("
                                                     + string(c-cd-esp-resid)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find esp-med where
                             esp-med.cd-especialid = c-cd-esp-resid
                             no-lock no-error.
 
                        if   not avail esp-med
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade Residencia ("
                                                     + string(c-cd-esp-resid,"999")
                                                     + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ------------------------------ CONSISTE CAMPO ESPECIALIDADE TITULO --- */
   assign c-cd-esp-titulo = int(substring(c-dados,243,03)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Especialidade Titulo ("
                                       + substring(c-dados,243,03)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-esp-titulo <> 0
          and  c-cd-esp-titulo <> ?
          then do:
                 if   c-cd-esp-titulo < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade "
                                                     + "Titulo ("
                                                     + string(c-cd-esp-titulo)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find esp-med where
                             esp-med.cd-especialid = c-cd-esp-titulo
                             no-lock no-error.
 
                        if   not avail esp-med
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade Titulo ("
                                                     + string(c-cd-esp-titulo,"999")
                                                     + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* -------------------------------------------- CONSISTE CAMPO MALOTE --- */
   case substring(c-dados,246,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Malote (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-malote = yes.
 
      when "N"
      then assign c-lg-malote = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Malote ("
                                          + substring(c-dados,246,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ---------------------------- CONSISTE NR. DIAS VALIDADE -------------- */
   assign c-nr-dias-validade = int(substring(c-dados,698,3)) no-error.

   if error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nr. Dias Validade ("
                                       + substring(c-dados,243,03)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.

   /* ------------------------------ CONSISTE CAMPO VINCULO EMPREGATICIO --- */
   case substring(c-dados,247,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Vinculo Empregaticio (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-vinc-empreg = yes.
 
      when "N"
      then assign c-lg-vinc-empreg = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Vinculo Empregaticio ("
                                          + substring(c-dados,247,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ----------------------------------- CONSISTE CAMPO ULTIMO MES INSS --- */
   assign c-nr-ult-inss = int(substring(c-dados,248,06)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Ultimo Mes INSS ("
                                       + substring(c-dados,248,06)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-nr-ult-inss <> 0
          and  c-nr-ult-inss <> ?
          then do:
                 if   c-nr-ult-inss < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Ultimo Mes INSS ("
                                                     + string(c-nr-ult-inss)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
               end.
        end.
 
   /* -------------------------- CONSISTE CAMPO 37 - DEVE CONTER BRANCOS --- */
   if   trim(substring(c-dados,254,08)) <> ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Campo 38 deve Conter Brancos".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------------- CONSISTE CAMPO RAMAL 1 --- */
   assign c-nr-ramal[1] = trim(substring(c-dados,262,05)).
 
   /* ------------------------------------------- CONSISTE CAMPO RAMAL 2 --- */
   assign c-nr-ramal[2] = trim(substring(c-dados,267,05)).
 
   /* --------------------------------------- CONSISTE CAMPO NRO CGC/CPF --- */
   assign c-cgc-cpf     = trim(substring(c-dados,272,19)).

   if   trim(c-cgc-cpf) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nro CGC/CPF nao Informado".
          assign lg-erro = yes.
        end.

   else do:
          if   not lg-formato-livre-aux
          then do:
                 run desedita-numero-cgc-cpf (input  c-cgc-cpf,
                                              output nr-cgc-cpf-aux).

                 assign c-cgc-cpf = nr-cgc-cpf-aux.
               end.

          run rtp/rtcgccpf.p (input  c-in-tipo-pessoa,
                              input  c-cgc-cpf,
                              input  no,
                              output ds-mensrela-aux,
                              output lg-erro-cgc-cpf-aux).

          if   lg-erro-cgc-cpf-aux
          then do:
                 IF dt-ignorar-validacao-aux < TODAY
                 THEN DO:
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = ds-mensrela-aux.
                         assign lg-erro = yes.
                 END.
               end.
 
          else do:
                 find first preserv
                      where preserv.nr-cgc-cpf    = c-cgc-cpf
                        and preserv.cd-unidade    = c-cd-unidade 
                        and preserv.cd-prestador <> c-cd-prestador
                 no-lock no-error.

                 if   avail preserv
                 then do:
                        if  not paramecp.lg-cgc-duplos-prestador
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Ja Existe Prestador com este CGC/CPF ("
                                                     + c-cgc-cpf
                                                     + ")".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
        /* ------------------------------------------ CONSISTE CAMPO REGISTRO --- */
        assign c-nr-registro = int(substring(c-dados,082,08)) no-error.

        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Registro ("
                                            + substring(c-dados,082,08)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.
        else do:
               if   c-nr-registro <> 0
               and  c-nr-registro <> ?
               then do:
                      if   c-nr-registro < 0
                      then do:
                             create wk-erros.
                             assign wk-erros.cd-tipo-erro = "E"
                                    wk-erros.cd-tipo-regs = 1
                                    wk-erros.ds-desc      = "Registro ("
                                                          + string(c-nr-registro)
                                                          + ") Invalido".
                             assign lg-erro = yes.
                           end.
                      else do:
                             /* Verifica se ja existe um outro prestador na mesma unidade
                                com o mesmo conselho e registro */
                             find first preserv     /* --- mesma logica do cg0111b.p --- */
                                  where preserv.cd-conselho    = c-cd-conselho            
                                    and preserv.nr-registro    = c-nr-registro           
                                    and preserv.cd-unidade     = c-cd-unidade            
                                    and preserv.in-tipo-pessoa = c-in-tipo-pessoa        
                                    and preserv.cd-uf-conselho = c-cd-uf-conselho        
                                    and preserv.cd-prestador  <> c-cd-prestador             
                                        no-lock no-error.                                
                                                                                          
                             if   avail preserv                                           
                             then do:                                                     
                                    create wk-erros.                                      
                                    assign                                                   
                                    wk-erros.cd-tipo-erro = "E"                               
                                    wk-erros.cd-tipo-regs = 1                                 
                                    wk-erros.ds-desc      = "Conselho/Registro (" + trim(c-cd-conselho) + "/"
                                                          + string(c-nr-registro,"99999999") + ") ja Cadastrado para "
                                                          + "outro Prestador na mesma Unidade: Prestador: " 
                                                          + string(preserv.cd-prestador,"99999999") + ")".
                                    assign lg-erro = yes.
                                  end.

                             /* Verifica se ja existe um outro prestador em outra unidade
                                com o mesmo conselho e registro */
                             find first preserv use-index preserv4                                                                      
                                  where preserv.cd-conselho    = c-cd-conselho                                                          
                                    and preserv.nr-registro    = c-nr-registro                                                          
                                    and preserv.cd-uf-conselho = c-cd-uf-conselho                                                       
                                    and preserv.nr-cgc-cpf    <> c-cgc-cpf                                                              
                                        no-lock no-error.                                                                               
                             if   avail preserv                                                                                         
                             then do:
                                    create wk-erros. 
                                    assign wk-erros.cd-tipo-erro = "A"                               
                                           wk-erros.cd-tipo-regs = 1                                 
                                           wk-erros.ds-desc      = "Conselho/Registro (" + trim(c-cd-conselho) + "/"
                                                                   + string(c-nr-registro,"99999999")     
                                                                   + ") ja cadastrado para outro Prestador: Prestador: "
                                                                   + string(preserv.cd-prestador,"99999999")
                                                                   + ", com cnpj/cpf diferente ("
                                                                   + " CGC/CPF: " + string(preserv.nr-cgc-cpf) + ")".                                  
                                    
                                    assign lg-aviso = yes.
                                  end.
                           end.
                    end.
             end.

   /* -------------------------------- CONSISTE CAMPO REPRESENTA UNIDADE --- */
   case substring(c-dados,291,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Represtanta Unidade (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-representa-unidade = yes.
 
      when "N"
      then assign c-lg-representa-unidade = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Representa Unidade ("
                                          + substring(c-dados,291,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------ CONSISTE CAMPO CODIGO HORARIO DE URGENCIA --- */
   assign c-cd-tab-urge = int(substring(c-dados,292,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Codigo Horario de Urgencia ("
                                       + substring(c-dados,292,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-tab-urge = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Codigo Horario de Urgencia nao Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-tab-urge < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Horario de Urgencia ("
                                                     + string(c-cd-tab-urge)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find first horaurge
                             where horaurge.cd-tab-urge = c-cd-tab-urge
                                   no-lock no-error.
 
                        if   not avail horaurge
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Codigo Horario de Urgencia ("
                                                            + string(c-cd-tab-urge,"99")
                                                            + ") nao Cadastrado".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* -------------------------------------- CONSISTE CAMPO RECOLHE INSS --- */
   case substring(c-dados,294,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Recolhe INSS (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-recolhe-inss = yes.
 
      when "N"
      then assign c-lg-recolhe-inss = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Recolhe INSS ("
                                          + substring(c-dados,294,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------ CONSISTE CAMPO RECOLHE PARTICIPACAO --- */
   case substring(c-dados,295,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Recolhe Participacao (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-recolhe-participa = yes.
 
      when "N"
      then assign c-lg-recolhe-participa = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Recolhe Participacao ("
                                          + substring(c-dados,295,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ---------------------------------------- CONSISTE CAMPO OBSERVACAO --- */
   assign c-ds-observacao = trim(substring(c-dados,296,228)).
 
   /* ------------------------- CONSISTE CAMPO CALCULAR IMPOSTO DE RENDA --- */
   case substring(c-dados,524,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular Imposto de Renda "
                                          + "(Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-calc-irrf = yes.
 
      when "N"
      then assign c-calc-irrf = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular Imposto de Renda ("
                                          + substring(c-dados,524,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------ CONSISTE CAMPO INDICE IRRF NUMERICO --- */
   assign c-incidir-irrf = int(substring(c-dados,525,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Indice IRRF ("
                                       + substring(c-dados,525,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-incidir-irrf <> 01
          and  c-incidir-irrf <> 02
          and  c-incidir-irrf <> 03
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Indice IRRF ("
                                              + string(c-incidir-irrf,"99")
                                              + ") NAO CONFERE com 01, 02 ou 03".
                 assign lg-erro = yes.
               end.
        end.
 
   /* -------------- CONSISTE CAMPO ORDEM 50 - CAMPO DEVE CONTER BRANCOS --- */
   if   trim(substring(c-dados,527,06)) <> ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Campo 52 deve Conter Brancos".
          assign lg-erro = yes.
        end.
 
   /* ---------------------------- CONSISTE CAMPO CALCULAR ADIANTAMENTO ---- */
   case substring(c-dados,533,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular Adiantamento (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-calcula-adto = yes.
 
      when "N"
      then assign c-lg-calcula-adto = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular Adiantamento ("
                                          + substring(c-dados,533,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------- CONSISTE CAMPO DATA CALCULO ADIANTAMENTO --- */
   if   trim(substring(c-dados,534,08)) = ""
   then assign c-dt-calculo-adto = ?.
   else do:
          if   length(trim(substring(c-dados,534,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data Calculo Adiantamento Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,534,08)) = "00000000"
                 then assign
                      c-dt-calculo-adto = ?.
                 else do:
                        assign c-dt-calculo-adto = date(int(substring(c-dados,536,02)),
                                                        int(substring(c-dados,534,02)),
                                                        int(substring(c-dados,538,04))) no-error.
 
                        if   error-status:error
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data Calculo Adiantamento ("
                                                            + substring(c-dados,534,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------------- CONSISTE CAMPO NUMERO DE DEPENDENTES --- */
   assign c-nr-dependentes = int(substring(c-dados,542,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Numero de Dependentes ("
                                       + substring(c-dados,542,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-in-tipo-pessoa <> "F"
          then assign c-nr-dependentes = 0.
        end.

   /* -------------------------------------- CONSISTE CAMPO PAGAMENTO RH --- */
   case substring(c-dados,544,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Pagamento RH (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-pagamento-rh = yes.
 
      when "N"
      then assign c-lg-pagamento-rh = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Pagamento RH ("
                                          + substring(c-dados,544,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------- CONSISTE CAMPO ENDERECO ELETRONICO --- */
   assign c-nm-email = trim(substring(c-dados,545,50)).
 
   do:
   /* ------------------------------------------- CONSISTE TIPO DE FLUXO --- */
            assign c-cd-tipo-fluxo = trim(substring(c-dados,595,12)).
            
            find tip_fluxo_financ
                 where tip_fluxo_financ.cod_tip_fluxo_financ = c-cd-tipo-fluxo
                       no-lock no-error.

            if  not avail tip_fluxo_financ 
            and not paramepp.lg-abre-fluxo  /*** Utiliza apenas um fluxo financeiro ***/
            then do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = "Tipo de Fluxo ("
                                                + string(c-cd-tipo-fluxo,"999999999999")
                                                + ") nao Cadastrado".
                   assign lg-erro = yes.
                 end.
               
            /* --------------------------------- ESTOURO DE SEGMENTO ------------------------- */
            run consiste-tributos.                        

         end.
   
   
   /* ---------------------------- CONSISTE CAMPO CALCULAR IMPOSTO UNICO ---------- */
     case substring(c-dados,747,1):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular IMPOSTO UNICO (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-calc-imposto-unico = yes.
 
      when "N"
      then assign c-calc-imposto-unico = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular IMPOSTO UNICO ("
                                          + substring(c-dados,643,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
   /* ---------------------------- CONSISTE CAMPO DIVISAO DE HONORARIOS ------ */
   case substring(c-dados,642,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Divide Honorario (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-lg-divisao-honorario = yes.

    when "N"
    then assign c-lg-divisao-honorario = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Divide Honorario ("
                                        + substring(c-dados,642,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE CAMPO DE COFINS ------ */
   case substring(c-dados,643,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Cofins (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-calc-cofins = yes.

    when "N"
    then assign c-calc-cofins = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Cofins ("
                                        + substring(c-dados,643,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE CAMPO DE PIS/PASEP ------ */
   case substring(c-dados,644,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Pis/Pasep (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-calc-pispasep = yes.

    when "N"
    then assign c-calc-pispasep = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Pis/Pasep ("
                                        + substring(c-dados,644,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE CAMPO CALCULAR CSLL ------ */
   case substring(c-dados,645,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-calc-csll = yes.

    when "N"
    then assign c-calc-csll = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL ("
                                        + substring(c-dados,645,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE OS DEMAIS ATRIBUTOS ------ */
   if not c-calc-imposto-unico 
   then do:  
          if  substring(c-dados,643,01) = "S"
          and substring(c-dados,644,01) = "S"
          and substring(c-dados,645,01) = "S" 
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular IMPOSTO UNICO ("
                                              + substring(c-dados,747,1)
                                              + ") DEVE estar definido como (S)"
                                              + " pois todos os atributos estao definidos com (S)".
                 assign lg-erro = yes.
               end.

          case substring(c-dados,643,01):
             when ""
             then do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Calcular COFINS (Sim/Nao) nao Informado".
                    assign lg-erro = yes.
                  end.
          
             when "S"
             then assign c-calc-cofins = yes.
          
             when "N"
             then assign c-calc-cofins = no.
          
             otherwise
                  do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Conteudo do Campo Calcular COFINS ("
                                          + substring(c-dados,643,01)
                                                 + ") NAO CONFERE com os Conteudos "
                                                 + "Definidos no Layout de Importacao (S/N)".
                    assign lg-erro = yes.
                  end.
          end case.
          /* ---------------------------- CONSISTE CAMPO CALCULAR PIS/PASEP ---------- */
          case substring(c-dados,644,01):
             when ""
             then do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Calcular PIS/PASEP (Sim/Nao) nao Informado".
                    assign lg-erro = yes.
                  end.
          
             when "S"
             then assign c-calc-pispasep = yes.
          
             when "N"
             then assign c-calc-pispasep = no.
          
             otherwise
                  do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Conteudo do Campo Calcular PIS/PASEP ("
                                          + substring(c-dados,644,01)
                                                 + ") NAO CONFERE com os Conteudos "
                                                 + "Definidos no Layout de Importacao (S/N)".
                    assign lg-erro = yes.
                  end.
          end case.
          /* ---------------------------- CONSISTE CAMPO CALCULAR CSLL ---------- */
          
          case substring(c-dados,645,01):
             when ""
             then do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Calcular CSLL (Sim/Nao) nao Informado".
                    assign lg-erro = yes.
                  end.
          
             when "S"
             then assign c-calc-csll = yes.
          
             when "N"
             then assign c-calc-csll = no.
          
             otherwise
                  do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL ("
                                                 + substring(c-dados,645,01)
                                                 + ") NAO CONFERE com os Conteudos "
                                                 + "Definidos no Layout de Importacao (S/N)".
                    assign lg-erro = yes.
                  end.
          end case.
          end.
   else do:
          if substring(c-dados,643,01) = "S"
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular COFINS ("
                                              + substring(c-dados,643,01)
                                              + ") DEVE estar definido com (N)".
                 assign lg-erro = yes.
               end.
          if substring(c-dados,644,01) = "S"
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular PIS/PASEP ("
                                              + substring(c-dados,644,01)
                                              + ") DEVE estar definido com (N)". 
                 assign lg-erro = yes.
               end.

          if substring(c-dados,645,01) = "S" 
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL ("
                                              + substring(c-dados,645,01)
                                              + ") DEVE estar definido com (N)".
                 assign lg-erro = yes.
               end.
        end.   
   
   /* ---------------------------- CONSISTE CAMPO CALCULAR ISS ---------- */
   case substring(c-dados,686,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular ISS (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-calc-iss = yes.
 
      when "N"
      then assign c-calc-iss = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular ISS ("
                                          + substring(c-dados,686,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
   /*-------------- consiste campo deduz iss ------------------------*/
   case substring(c-dados,697,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Deduzir ISS (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-deduz-iss = yes.
 
      when "N"
      then assign c-deduz-iss = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Deduzir ISS ("
                                          + substring(c-dados,697,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

    /* --- CONSISTE TIPO DE CLASSIFICACAO DO ESTABELECIMENTO --- */
    if c-nr-ver-tra = 10
    or c-nr-ver-tra = 8
    or lg-layout-serious-aux
    then do:
           if  trim(substring(c-dados,758,1)) <> "1"
           and trim(substring(c-dados,758,1)) <> "2"
           and trim(substring(c-dados,758,1)) <> "3"
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Tipo de classificacao deve ser 1, 2 ou 3. Valor recebido: " + trim(substring(c-dados,758,1)).
                  assign c-cd-tipo-classif-estab = ""
                         lg-erro = yes.
                end.
           else assign c-cd-tipo-classif-estab  = substring(c-dados,758,1).
         end.

    assign c-cd-cnes = int(substring(c-dados,759,7)).

    /* --- RECEBE NOME DO DIRETOR TECNICO DA ENTIDADE DE SAUDE --- */
    assign c-nm-diretor-tecnico = substring(c-dados,766,40).

    /* ------------------------- CONSISTE REGISTRO ANS --- */
    assign c-cd-registro-ans = int(substring(c-dados,814,6)) no-error.

    if   error-status:error
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Registro ANS ("
                                        + substring(c-dados,814,6)
                                        + ") nao Numerico".
            assign lg-erro = yes.
         end.
    
   /* ---------- CONSISTE MODALIDADE --------------------------------------- */
   do:
           assign c-modalidade = integer(substring(c-dados,706,1)).
        
           /**
            * Consistencia retirada pois Fornecedor Financeiro do EMS5 nao trata mais a Carteira Bancaria (Modalidade).
            * Alex Boeira - 03/05/2016
           if   c-modalidade <> 0
           then do:
                  {srincl/srcartbc.i "c-modalidade"}
                  
                  if   not lg-avail-srcartbc-srems
                  then do:
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "Modalidade do portador ("
                                                        + string(c-modalidade)
                                                        + ") NAO e' valida".  
                         assign lg-erro = yes.
                       end.
                end.
           */

           /* ---------- CONSISTE O CAMPO PORTADOR --------------------------------- */
           assign c-portador = integer(substring(c-dados,701,5)).
           
           if   c-portador   <> 0
           or   c-modalidade <> 0 
           then do: 
                  /*****************************************************************************
*      Include  .....: srportad.i                                            *
*      Data .........: 28 de Agosto de 2000                                  *
*      Empresa ......: DZSET SOLUCOES & SISTEMAS                             *
*      Programador ..: Jaqueline Formigheri                                  *
*      Objetivo .....: Leitura da tabela portador     -sistemas Magnus e EMS *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL      MOTIVO                         *
*      D.00.000  28/08/2000  Jaque            Desenvolvimento                *
*      E.00.000  25/10/2000  Nora             Mudanca Versao Banco           *
*      E.01.000  15/05/2001  Jaque            Converter para ems504.         *
*****************************************************************************/

/* --- TPLE44 - Solucao para contornar o problema na migracao de dados do
              - portador do UNICOO para o GP, onde os dados no EMS sao gravados com 
              - "zeros" na frente  ------------------------------------------------- */
assign cod-portador-srems = string(c-portador).
if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
then do:
       /* --- Se nao encontrar do modo que ‚ atualmente testa com format para a mascara */
       assign cod-portador-srems = string(c-portador,"99999").
       if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
       then do:
              IF c-portador <= 9999
              THEN DO:
                     assign cod-portador-srems = string(c-portador,"9999").
                     if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
                     then do: 
                            IF c-portador <= 999
                            THEN DO:
                                   assign cod-portador-srems = string(c-portador,"999").
                                   if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
                                   then do: 
                                          IF c-portador <= 99
                                          THEN DO:
                                                 assign cod-portador-srems = string(c-portador,"99").
                                                 if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
                                                 then assign cod-portador-srems = string(c-portador). /* se nao encontrar mantem logica anterior */
                                               END.
                                        end.
                                 END.
                          end.
                   END.
            end.
     end.

do:
        find portador where portador.cod_portador = cod-portador-srems
                       no-lock no-error.
        if avail portador
        then assign lg-avail-portador-srems = yes
                     nm-portador-srems       = portador.nom_pessoa.
        else assign lg-avail-portador-srems = no
                     nm-portador-srems       = "".
        find pais where pais.cod_pais = "BRA" no-lock no-error.
        if avail pais
        then do:
               find portad_finalid_econ where 
                    portad_finalid_econ.cod_estab        = paramecp.cod-estabel
               and  portad_finalid_econ.cod_portador     = cod-portador-srems /*string({2})*/
               and  portad_finalid_econ.cod_cart_bcia    = string(c-modalidade) 
               and  portad_finalid_econ.cod_finalid_econ = pais.cod_finalid_econ_pais
                    no-lock no-error.
                 
                    if avail portad_finalid_econ
                    then lg-avail-carteira-srems = yes.
                    else lg-avail-carteira-srems = no.
             end.
         else lg-avail-carteira-srems = no.
      end.
.

/*** Final do include ***/
 
        
                  if   not lg-avail-portador-srems 
                  then do: 
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "O codigo do portador ("
                                                        + string(c-portador)
                                                        + ") NAO e' valido".  
                         assign lg-erro = yes. 
                       end.

                  /**
                   * Consistencia retirada pois Fornecedor Financeiro do EMS5 nao trata mais a Carteira Bancaria (Modalidade).
                   * Alex Boeira - 03/05/2016
                  if   not lg-avail-carteira-srems
                  then do: 
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "O codigo da modalidade ("
                                                        + string(c-modalidade)
                                                        + ") NAO e' valido".  
                         assign lg-erro = yes. 
                       end.
                  */     
                end.
        
           /* ---------- CONSISTE O CAMPO COD DO BANCO ----------------------------- */
           assign c-cd-banco = integer(substring(c-dados,707,3)).

           if   c-cd-banco <> 0
           then do:
                  /* ----------------------------------------------------- LOCALIZA O BANCO --- */
                  /************************************************************************************************
*      Include  .....: srbanco.i                                                                *
*      Data .........: 06 de Agosto de 2000                                                     *
*      Empresa ......: DZSET SOLUCOES & SISTEMAS                                                *
*      Programador ..: Jaqueline Formigheri                                                     *
*      Objetivo .....: Leitura da tabela banco                                                  *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      D.00.000  06/09/2000  Jaque           Desenvolvimento                                    *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco                               *
*      E.01.000  23/08/2001  Leonardo        Conversao EMS504                                   *
************************************************************************************************/

 do:
      find banco where banco.cod_banco = string(c-cd-banco)
                   no-lock no-error.
        IF NOT AVAIL banco
        THEN
            find banco where banco.cod_banco = STRING(c-cd-banco,"999")
            no-lock no-error.
        
        if   avail banco
        then assign lg-avail-srbanco-srems = yes
                    nm-banco-srems         = banco.nom_banco.
        ELSE  
             assign lg-avail-srbanco-srems = no
                    nm-banco-srems         = "** NAO CADASTRADO **".
      end.

/* ------------------------------------------------------------------------------------------- */
                               
                                                                               
                  if   not lg-avail-srbanco-srems                              
                  then do:      

                         IF dt-ignorar-validacao-aux < TODAY 
                         THEN DO:
                                create wk-erros.                                      
                                assign wk-erros.cd-tipo-erro = "E"                    
                                       wk-erros.cd-tipo-regs = 1                      
                                       wk-erros.ds-desc      = "O codigo do banco ("  
                                                             + string(c-cd-banco)     
                                                             + ") NAO e' valido".     
                                                                                      
                                assign lg-erro = yes.                                 
                         END.
                       end.                                                    
                end.

           /* ---------------------------------------------------------- AGENCIA --- */
           assign c-agencia      = substring(c-dados,710,8).
           /* --------------------------------------------------- CONTA CORRENTE --- */
           assign c-conta-corren = substring(c-dados,718,20).

           /* Consiste tipo de carteira banc ria se ? D‚bito Auto, obrigatoriamente os campos banco, agencia e 
              conta corrente sao obrigatorios na digitacao */
           
           if   lg-avail-srcartbc-srems
           then do:
                  if   cart_bcia.ind_tip_cart_bcia = "Débito Auto"
                  then do:
                         if c-cd-banco     = 0 
                         or c-agencia      = ""
                         or c-agencia      = fill("0",length(trim(banco.cod_format_agenc_bcia)))
                         or c-conta-corren = ""
                         or c-conta-corren = fill("0",length(trim(banco.cod_format_cta_corren)))
                         then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Banco/Agencia/Cta Corrente para este" 
                                                             + " portador/modalidade sao obrigatorios".
                  
                                assign lg-erro = yes.
                              end.
                       end.   
                end.
           /* --------------------------------------------------- DIGITO AGENCIA --- */
           assign c-agencia-digito = trim(substring(c-dados,738,2)).
           /* -------------------------------------------- DIGITO CONTA CORRENTE --- */
           assign c-conta-corren-digito = trim(substring(c-dados,740,2)).
           /* ------------------------------ CONSISTE O CAMPO FORMA DE PAGAMENTO --- */
           assign c-forma-pagto = trim(substring(c-dados,742,3)).
           /* ------------------------------- RETEM ATRIBUTO DO PROCEDIMENTO ------- */
           assign c-retem-proc = trim(substring(c-dados,745,1)).
           /* ------------------------------- RETEM ATRIBUTO DO INSUMO ------------- */
           assign c-retem-insu = trim(substring(c-dados,746,1)).

           if   c-forma-pagto <> ""
           or   c-forma-pagto <> "0"
           then do:
                  find forma_pagto where forma_pagto.cod_forma_pagto = c-forma-pagto no-lock no-error.
                  if   not avail forma_pagto
                  then do:
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "O codigo do tipo de pagto ("
                                                        + c-forma-pagto
                                                        + ") NAO e' valido".   
                         assign lg-erro = yes.
                       end.
                end.
         end.
   .
   
   if   substring(c-dados,820,8) <> "00000000"
   and  substring(c-dados,820,8) <> "        "
   then c-dt-inicio-contratual   = date(substring(c-dados,820,8)).
   else c-dt-inicio-contratual   = ?.
   
   /* Consiste dados ANS */
   assign c-ds-natureza-doc-ident   = trim(substring(c-dados,828,40))
          c-nr-doc-ident            = trim(substring(c-dados,868,14))
          c-ds-orgao-emissor-ident  = trim(substring(c-dados,882,30))
          c-nm-pais-emissor-ident   = trim(substring(c-dados,912,20))
          c-uf-emissor-ident        = trim(substring(c-dados,932,2))
          c-dt-emissao-doc-ident    = ?
          c-ds-nacionalidade        = trim(substring(c-dados,942,40)).

   if   trim(substring(c-dados,934,08)) <> ""
   and  trim(substring(c-dados,934,08)) <> "00000000"
   then do:
          if   length(trim(substring(c-dados,934,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Emissao do Documento de Identificacao Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 assign c-dt-emissao-doc-ident = date(int(substring(c-dados,936,02)),
                                                      int(substring(c-dados,934,02)),
                                                      int(substring(c-dados,938,04))) no-error.
                 if   error-status:error
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data de Emissao do Documento de Identificacao ("
                                                     + substring(c-dados,934,08)
                                                     + ") Invalida ou nao Numerica".
                        assign lg-erro = yes.
                      end.
               end.
        end.

   /* -------------- Tipo Disponibilidade ---------------------------------- */
   if   int(substr(c-dados,1022,1))   <> 0
   and  int(substr(c-dados,1022,1))   <> 1
   and  int(substr(c-dados,1022,1))   <> 2
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Tipo Disponibilidade invalido"
                                       + "(" + substring(c-dados,1022,1) + ")".
          assign lg-erro = yes.
        end.

   else assign c-tp-disponibilidade = int(substr(c-dados,1022,1)).

  /* -------------- Rede Acidente Trabalho ---------------------------------- */
  if substr(c-dados,1024,1) = "S"
  then assign c-lg-acid-trab = yes. 
  else assign c-lg-acid-trab = no.

  /* -------------- Pratica Tabela Propria ---------------------------------- */
  if substr(c-dados,1025,1) = "S"
  then assign c-lg-tab-propria = yes. 
  else assign c-lg-tab-propria = no.

  /* -------------- Perfil Assistencial ------------------------------------- */
  if int(substr(c-dados,1026,2)) < 0
  or int(substr(c-dados,1026,2)) > 28
  then do:
         create wk-erros.
         assign wk-erros.cd-tipo-erro = "E"
                wk-erros.cd-tipo-regs = 1
                wk-erros.ds-desc      = "Perfil Assist. do Hospital invalido"
                                      + "(" + substring(c-dados,1026,2) + ")".
         assign lg-erro = yes.
       end.
  else assign c-in-perfil-assistencial = int(substr(c-dados,1026,2)).

  /* -------------- Tipo Produto -------------------------------------------- */
  if int(substr(c-dados,1028,1)) < 0
  or int(substr(c-dados,1028,1)) > 3
  then do:
         create wk-erros.
         assign wk-erros.cd-tipo-erro = "E"
                wk-erros.cd-tipo-regs = 1
                wk-erros.ds-desc      = "Tipo Produto invalido"
                                      + "(" + substring(c-dados,1028,1) + ")".
         assign lg-erro = yes.
       end.
  else assign c-in-tipo-prod-atende = int(substr(c-dados,1028,1)).

  /*-------------- Consiste Indicador de publica‡Æo no Guia Medico ------------------------*/
  if c-nr-ver-tra          >= 12
  or lg-layout-serious-aux
  then do:
         case substring(c-dados,1029,01):
            when ""
            then do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = "Guia Medico (Sim/Nao) nao Informado".
                   assign lg-erro = yes.
                 end.
         
            when "S"
            then assign c-lg-guia-medico-aux = yes.
         
            when "N"
            then assign c-lg-guia-medico-aux = no.
         
            otherwise
                 do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = "Conteudo do Campo Guia Medico ("
                                                + substring(c-dados,1029,01)
                                                + ") NAO CONFERE com os Conteudos "
                                                + "Definidos no Layout de Importacao (S/N)".
                   assign lg-erro = yes.
                 end.
         end case.
       end.
  else assign c-lg-guia-medico-aux = no.

  if c-nr-ver-tra >= 14
  or lg-layout-serious-aux
  then do:
         if substring(c-dados,1030,12) <> ""
         then do:   
         find conpres where conpres.cd-conselho = substring(c-dados,1030,12)   
                            no-lock no-error.
         if not avail conpres
         then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "Conselho de Prestadores nao Cadastrado "
                                             + "(" + substring(c-dados,1030,12) + ")".
                assign lg-erro = yes.
              end.
              end.

         if substring(c-dados,1057,2) <> ""
         then do:        
         find dzestado where dzestado.nm-pais = "BRASIL"  
                         and dzestado.en-uf   = substring(c-dados,1057,2) 
                             no-lock no-error.
                 
        if not avail dzestado 
        then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "UF invalido"
                                             + "(" + substring(c-dados,1057,2) + ")".
                assign lg-erro = yes.
              end.
              end.

              assign c-cd-conselho-dir-tec = substring(c-dados,1030,12)
                     c-nr-conselho-dir-tec = substring(c-dados,1042,15)
                     c-uf-conselho-dir-tec = substr(c-dados,1057,2).

         if int(substr(c-dados,1059,1)) < 0
         or int(substr(c-dados,1059,1)) > 3
         then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "Tipo de Rede invalido"
                                             + "(" + substring(c-dados,1059,1) + ")".
                assign lg-erro = yes.
              end.
         else assign c-tp-rede = int(substr(c-dados,1059,1)).

        /* ---------------------------------------------------- Sistema NOTIVISA --- */
        if substr(c-dados,1060,1) = "S"
        then c-lg-notivisa = yes.
        else c-lg-notivisa = no.

        /* ----------------------------------------------------- Sistema QUALISS --- */
        if substr(c-dados,1061,1) = "S"
        then c-lg-qualiss = yes.
        else c-lg-qualiss = no.
        
        /* --------------------------------------------- Registro Especialista 1 --- */
        assign c-nr-registro1 = int(substring(c-dados,1062,10)) no-error.
        
        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Numero Registro Especialista 1 ("
                                            + substring(c-dados,1062,10)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.
        
        /* --------------------------------------------- Registro Especialista 2 --- */
        assign c-nr-registro2 = int(substring(c-dados,1072,10)) no-error.
        
        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Numero Registro Especialista 2 ("
                                            + substring(c-dados,1072,10)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.

        /* --------------------------------------------- Nr. Leitos Hospital-dia --- */
        assign c-nr-leitos-hosp-dia = int(substring(c-dados,1082,6)) no-error.
        
        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Numero de Leitos Hospital-dia ("
                                            + substring(c-dados,1082,6)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.
        
        /* --------------------------------------------- Registro Especialista 2 --- */
        assign c-nm-end-web = substring(c-dados,1088,50).
        
       end.

       /* --------------------------- CONSISTE CAMPO DIVULGA ANS --- */
       case trim(substring(c-dados,1248,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-publica-ans-aux = yes.
       
          when "N"
          then assign lg-publica-ans-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Divulga ANS ("
                                              + substring(c-dados,1248,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

       /* --------------------------- CONSISTE CAMPO RESIDENCIA MEC --- */
       case trim(substring(c-dados,1249,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-indic-residencia-aux = yes.
       
          when "N"
          then assign lg-indic-residencia-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Residencia MEC ("
                                              + substring(c-dados,1249,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

       /* --------------------------- CONSISTE CAMPO ENVIA CADU ------------- */
       case trim(substring(c-dados,1250,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-login-wsd-tiss-aux = yes.
       
          when "N"
          then assign lg-login-wsd-tiss-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Manutencao TISS ("
                                              + substring(c-dados,1250,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

              /* --------------------------- CONSISTE CAMPO ENVIA CADU ------------- */
       case trim(substring(c-dados,1251,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-cadu-aux = yes.
       
          when "N"
          then assign lg-cadu-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Envia CADU ("
                                              + substring(c-dados,1251,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

end procedure.
 
/*---------------------------------------------------------------------------*/
/* IMPORTAR TABELA PREVIESP ( PELO MENOS 1 REGISTRO )                        */
/*---------------------------------------------------------------------------*/
 
procedure imp-reg-previesp:
   /* --------------------------------- CONSISTE CAMPO CODIGO DO VINCULO --- */
   assign c-cd-vinculo = int(substring(c-dados,002,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc      = "Codigo do Vinculo ("
                                       + substring(c-dados,002,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-vinculo = 0
          or   c-cd-vinculo = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 2
                        wk-erros.ds-desc      = "Codigo do Vinculo nao "
                                              + "Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-vinculo < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Codigo do Vinculo ("
                                                     + string(c-cd-vinculo)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find tipovinc where
                             tipovinc.cd-tipo-vinculo = c-cd-vinculo
                             no-lock no-error.
 
                        if   not avail tipovinc
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 2
                                      wk-erros.ds-desc      = "Vinculo ("
                                                            + string(c-cd-vinculo,"99")
                                                            + ") nao Cadastrado".
                               assign lg-erro = yes.
                             end.
                        else do:
                               if   tipovinc.lg-cd-magnus
                               then do:
                                   assign nome-abrev-rtapi044-aux       = c-nome-abrev
                                          lg-prim-mens-rtapi044-aux     = no
                                          in-funcao-rtapi044-aux        = "GDT"
                                          in-tipo-emitente-rtapi044-aux = "PRESTA"
                                          in-tipo-pessoa-rtapi044-aux   = c-in-tipo-pessoa.
                                    
                                   run rtapi044.
 
                                   find first tmp-rtapi044 no-lock no-error.

                                   if  not available tmp-rtapi044
                                      then do:
                                             create wk-erros.
                                             assign wk-erros.cd-tipo-erro = "E"
                                                    wk-erros.cd-tipo-regs = 2
                                                    wk-erros.ds-desc      = "Prestador deve estar "
                                                                          + "Cadastrado no Magnus/EMS "
                                                                          + "para ser Associado a "
                                                                          + "este Vinculo ("
                                                                          + string(c-cd-vinculo,"99")
                                                                          + ")".
                                             assign lg-erro = yes.
                                           end.
                                      else assign c-cd-magnus          = tmp-rtapi044.cd-contratante 
                                                  c-nm-prestador       = tmp-rtapi044.nm-contratante
                                                  c-in-tipo-pessoa     = tmp-rtapi044.in-tipo-pessoa
                                                  c-nome-abrev         = tmp-rtapi044.nome-abrev
                                                  c-en-rua             = tmp-rtapi044.en-rua
                                                  c-en-bairro          = tmp-rtapi044.en-bairro
                                                  c-nr-telefone[1]     = tmp-rtapi044.nr-telefone[1]
                                                  c-en-uf              = tmp-rtapi044.en-uf
                                                  c-dt-inclusao        = tmp-rtapi044.dt-implantacao
                                                  c-cd-grupo-prestador = tmp-rtapi044.cod-gr-forn
                                                  c-en-cep             = tmp-rtapi044.en-cep
                                                  c-cd-cidade          = tmp-rtapi044.cd-cidade.
                                    end.
                             end.
                      end.
               end.
        end.
 
   /* --------------------------- CONSISTE CAMPO CODIGO DA ESPECIALIDADE --- */
   assign c-cd-especialid = int(substring(c-dados,004,03)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc      = "Codigo da Especialidade ("
                                       + substring(c-dados,004,03)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-especialid = 0
          or   c-cd-especialid = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 2
                        wk-erros.ds-desc      = "Codigo da Especialidade nao "
                                              + "Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-especialid < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Codigo da "
                                                     + "Especialidade ("
                                                     + string(c-cd-especialid)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find esp-med where
                             esp-med.cd-especialid = c-cd-especialid
                             no-lock no-error.
 
                        if   not avail esp-med
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 2
                                      wk-erros.ds-desc      = "Especialidade ("
                                                            + string(c-cd-especialid,"999")
                                                            + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------------------------- CONSISTE CAMPO PRINCIPAL --- */
   case trim(substring(c-dados,007,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Principal (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-principal = yes.
 
      when "N"
      then assign c-lg-principal = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Conteudo do Campo Principal ("
                                          + substring(c-dados,007,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ----------------------------- CONSISTE CAMPO CONSIDERA QTD VINCULO --- */
   case trim(substring(c-dados,008,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Considera Qtd Vinculo (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-considera-qt-vinculo = yes.
 
      when "N"
      then assign c-lg-considera-qt-vinculo = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Conteudo do Campo Considera Qtd "
                                          + "Vinculo ("
                                          + substring(c-dados,008,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

   /* --- CONSISTE TIPO DE CONTRATUALIZACAO --- */
   if  substring(c-dados,19,1) <> ""
   and substring(c-dados,19,1) <> "0"
   and substring(c-dados,19,1) <> "1"
   and substring(c-dados,19,1) <> "2"
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc      = "Tipo de contratualizacao(" + substring(c-dados,19,1) + ") invalido".
          assign lg-erro = yes.
        end.
 
   /*--------Verificar se registro jah existe ----*/
   find first wk-reg2 where wk-reg2.cd-vinculo    = c-cd-vinculo 
                        and wk-reg2.cd-especialid = c-cd-especialid  no-lock no-error.
              
   if avail wk-reg2
   then do:
            create wk-erros.
            assign wk-erros.cd-tipo-erro = "E"
                   wk-erros.cd-tipo-regs = 2
                   wk-erros.ds-desc      = "Prestador X Vinculo X Especialidade "
                                         + "duplicado no arquivo texto".
            assign lg-erro = yes.
        end.
   else do: /* ------------------- CRIAR REGISTRO --- */
            create wk-reg2.
            assign wk-reg2.cd-vinculo               = c-cd-vinculo
                   wk-reg2.cd-especialid            = c-cd-especialid
                   wk-reg2.lg-principal             = c-lg-principal
                   wk-reg2.lg-considera-qt-vinculo  = c-lg-considera-qt-vinculo
                   wk-reg2.cd-registro-espec        = substring(c-dados,9,10)
                   wk-reg2.cd-registro-espec-2      = dec(substring(c-dados,21,10))
                   wk-reg2.in-tipo-especialidade    = int(substring(c-dados,31,1))
                   wk-reg2.cd-tit-cert-esp          = int(substring(c-dados,32,3)).

            /*if substring(c-dados,19,1)            = "0"
            then wk-reg2.cd-tipo-contratualizacao = "".
            else*/ wk-reg2.cd-tipo-contratualizacao = substring(c-dados,19,1).

            /* Registro de Certificacao de Especialista */
            if substring(c-dados,20,1)  = "S"
            then assign wk-reg2.lg-rce = yes.
            else assign wk-reg2.lg-rce = no.
        end.
end procedure.
 
/*---------------------------------------------------------------------------*/
/* IMPORTAR DADOS PARA ENDPRES ( OPCIONAL )                                  */
/*---------------------------------------------------------------------------*/

procedure imp-reg-endpres:
   DEF VAR lg-erro-endereco AS LOG NO-UNDO.
   assign c-nr-seq-endereco = c-nr-seq-endereco + 1.
 
   /* --------------------------------------------------- CRIAR REGISTRO --- */
   create wk-reg3.
   assign wk-reg3.nr-seq-endereco = c-nr-seq-endereco.
 
   /* ------------------------------------------ CONSISTE CAMPO ENDERECO --- */
   assign wk-reg3.en-endereco = trim(substring(c-dados,002,40)).
 
   assign wk-reg3.en-complemento = trim(substr(c-dados,228,15)).

   assign wk-reg3.en-bairro = trim(substring(c-dados,042,15)).
 
   /* -------------------------------------------- CONSISTE CAMPO CIDADE --- */
   assign wk-reg3.cd-cidade = int(substring(c-dados,057,06)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 3
                 wk-erros.ds-desc      = "Cidade ("
                                       + substring(c-dados,057,06)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.

   /* ------------------------------------------------------------ CONSISTE CAMPO CEP --- */
   assign wk-reg3.en-cep = trim(string(int(substring(c-dados,063,08)),"99999999")) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 3
                 wk-erros.ds-desc      = "CEP ("
                                       + substring(c-dados,063,08)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------------------ CONSISTE CAMPO UF --- */
   assign wk-reg3.en-uf = trim(substring(c-dados,071,02)).
 
   run consiste-endereco (input wk-reg3.cd-cidade,
                          input wk-reg3.en-uf,
                          input wk-reg3.en-cep,
                          input wk-reg3.en-endereco,
                          input wk-reg3.en-bairro,
                          input c-in-tipo-pessoa,
                          input "O",
                          input-output lg-erro-endereco, 
                          input 3).

   IF lg-erro-endereco
   THEN lg-erro = YES.


   /* --------------------------------------- CONSISTE CAMPO TELEFONE 01 --- */
   assign wk-reg3.nr-fone[01] = trim(substring(c-dados,073,12)).
 
   /* --------------------------------------- CONSISTE CAMPO TELEFONE 02 --- */
   assign wk-reg3.nr-fone[02] = trim(substring(c-dados,085,12)).
 
   /* ------------------------------------------ CONSISTE CAMPO RAMAL 01 --- */
   assign wk-reg3.nr-ramal[01] = trim(substring(c-dados,097,05)).
 
   /* ------------------------------------------ CONSISTE CAMPO RAMAL 02 --- */
   assign wk-reg3.nr-ramal[02] = trim(substring(c-dados,102,05)).
 
   /* -------------------------------- CONSISTE CAMPO HORA ENTRADA MANHA --- */
   assign wk-reg3.hr-man-ent = trim(substring(c-dados,107,04)).
   run consiste-hora(wk-reg3.hr-man-ent, "Entrada Manha").

   /* ---------------------------------- CONSISTE CAMPO HORA SAIDA MANHA --- */
   assign wk-reg3.hr-man-sai = trim(substring(c-dados,111,04)).
   run consiste-hora(wk-reg3.hr-man-sai, "Saida Manha").

   /* -------------------------------- CONSISTE CAMPO HORA ENTRADA TARDE --- */
   assign wk-reg3.hr-tar-ent = trim(substring(c-dados,115,04)).
   run consiste-hora(wk-reg3.hr-tar-ent, "Entrada Tarde").
 
   /* ---------------------------------- CONSISTE CAMPO HORA SAIDA TARDE --- */
   assign wk-reg3.hr-tar-sai = trim(substring(c-dados,119,04)).
   run consiste-hora(wk-reg3.hr-tar-sai, "Saida Tarde").

   /* ---------------------------------- CONSISTE CAMPO TRABALHA SEGUNDA --- */
   run consiste-dias-trabalha(1,123,"Segunda").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA MANHA SEGUNDA --- */
   assign wk-reg3.hr-man-ent-segunda = trim(substring(c-dados,124,04)).
   run consiste-hora(wk-reg3.hr-man-ent-segunda, "Entrada Manha Segunda").

   /* -------------------------- CONSISTE CAMPO HORA SAIDA MANHA SEGUNDA --- */
   assign wk-reg3.hr-man-sai-segunda = trim(substring(c-dados,128,04)).
   run consiste-hora(wk-reg3.hr-man-sai-segunda, "Saida Manha Segunda").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA TARDE SEGUNDA --- */
   assign wk-reg3.hr-tar-ent-segunda = trim(substring(c-dados,132,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-segunda, "Entrada Tarde Segunda").
 
   /* -------------------------- CONSISTE CAMPO HORA SAIDA TARDE SEGUNDA --- */
   assign wk-reg3.hr-tar-sai-segunda = trim(substring(c-dados,136,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-segunda, "Saida Tarde Segunda").

   /* ------------------------------------ CONSISTE CAMPO TRABALHA TERCA --- */
   run consiste-dias-trabalha(1,140,"Terca").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA MANHA TERCA --- */
   assign wk-reg3.hr-man-ent-terca = trim(substring(c-dados,141,04)).
   run consiste-hora(wk-reg3.hr-man-ent-terca, "Entrada Manha Terca").

   /* ---------------------------- CONSISTE CAMPO HORA SAIDA MANHA TERCA --- */
   assign wk-reg3.hr-man-sai-terca = trim(substring(c-dados,145,04)).
   run consiste-hora(wk-reg3.hr-man-sai-terca, "Saida Manha Terca").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA TARDE TERCA --- */
   assign wk-reg3.hr-tar-ent-terca = trim(substring(c-dados,149,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-terca, "Entrada Tarde Terca").
 
   /* ---------------------------- CONSISTE CAMPO HORA SAIDA TARDE TERCA --- */
   assign wk-reg3.hr-tar-sai-terca = trim(substring(c-dados,153,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-terca, "Saida Tarde Terca").

   /* ----------------------------------- CONSISTE CAMPO TRABALHA QUARTA --- */
   run consiste-dias-trabalha(1,157,"Quarta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA MANHA QUARTA --- */
   assign wk-reg3.hr-man-ent-quarta = trim(substring(c-dados,158,04)).
   run consiste-hora(wk-reg3.hr-man-ent-quarta, "Entrada Manha Quarta").

   /* --------------------------- CONSISTE CAMPO HORA SAIDA MANHA QUARTA --- */
   assign wk-reg3.hr-man-sai-quarta = trim(substring(c-dados,162,04)).
   run consiste-hora(wk-reg3.hr-man-sai-quarta, "Saida Manha Quarta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA TARDE QUARTA --- */
   assign wk-reg3.hr-tar-ent-quarta = trim(substring(c-dados,166,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-quarta, "Entrada Tarde Quarta").
 
   /* --------------------------- CONSISTE CAMPO HORA SAIDA TARDE QUARTA --- */
   assign wk-reg3.hr-tar-sai-quarta = trim(substring(c-dados,170,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-quarta, "Saida Tarde Quarta").

   /* ----------------------------------- CONSISTE CAMPO TRABALHA QUINTA --- */
   run consiste-dias-trabalha(1,174,"Quinta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA MANHA QUINTA --- */
   assign wk-reg3.hr-man-ent-quinta = trim(substring(c-dados,175,04)).
   run consiste-hora(wk-reg3.hr-man-ent-quinta, "Entrada Manha Quinta").

   /* --------------------------- CONSISTE CAMPO HORA SAIDA MANHA QUINTA --- */
   assign wk-reg3.hr-man-sai-quinta = trim(substring(c-dados,179,04)).
   run consiste-hora(wk-reg3.hr-man-sai-quinta, "Saida Manha Quinta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA TARDE QUINTA --- */
   assign wk-reg3.hr-tar-ent-quinta = trim(substring(c-dados,183,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-quinta, "Entrada Tarde Quinta").
 
   /* --------------------------- CONSISTE CAMPO HORA SAIDA TARDE QUINTA --- */
   assign wk-reg3.hr-tar-sai-quinta = trim(substring(c-dados,187,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-quinta, "Saida Tarde Quinta").

   /* ------------------------------------ CONSISTE CAMPO TRABALHA SEXTA --- */
   run consiste-dias-trabalha(1,191,"Sexta").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA MANHA SEXTA --- */
   assign wk-reg3.hr-man-ent-sexta = trim(substring(c-dados,192,04)).
   run consiste-hora(wk-reg3.hr-man-ent-sexta, "Entrada Manha Sexta").

   /* ---------------------------- CONSISTE CAMPO HORA SAIDA MANHA SEXTA --- */
   assign wk-reg3.hr-man-sai-sexta = trim(substring(c-dados,196,04)).
   run consiste-hora(wk-reg3.hr-man-sai-sexta, "Saida Manha Sexta").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA TARDE SEXTA --- */
   assign wk-reg3.hr-tar-ent-sexta = trim(substring(c-dados,200,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-segunda, "Entrada Tarde Sexta").
 
   /* ---------------------------- CONSISTE CAMPO HORA SAIDA TARDE SEXTA --- */
   assign wk-reg3.hr-tar-sai-sexta = trim(substring(c-dados,204,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-sexta, "Saida Tarde Sexta").

   /* ----------------------------------- CONSISTE CAMPO TRABALHA SABADO --- */
   run consiste-dias-trabalha(1,208,"Sabado").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA MANHA SABADO --- */
   assign wk-reg3.hr-man-ent-sabado = trim(substring(c-dados,209,04)).
   run consiste-hora(wk-reg3.hr-man-ent-sabado, "Entrada Manha Sabado").

   /* --------------------------- CONSISTE CAMPO HORA SAIDA MANHA SABADO --- */
   assign wk-reg3.hr-man-sai-sabado = trim(substring(c-dados,213,04)).
   run consiste-hora(wk-reg3.hr-man-sai-sabado, "Saida Manha Sabado").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA TARDE SABADO --- */
   assign wk-reg3.hr-tar-ent-sabado = trim(substring(c-dados,217,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-sabado, "Entrada Tarde Sabado").
 
   /* --------------------------- CONSISTE CAMPO HORA SAIDA TARDE SABADO --- */
   assign wk-reg3.hr-tar-sai-sabado = trim(substring(c-dados,221,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-sabado, "Saida Tarde Sabado").

   /* ---------------------------------- CONSISTE CAMPO TRABALHA DOMINGO --- */
   run consiste-dias-trabalha(1,225,"Domingo").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA MANHA DOMINGO --- */
   assign wk-reg3.hr-man-ent-domingo = trim(substring(c-dados,226,04)).
   run consiste-hora(wk-reg3.hr-man-ent-domingo, "Entrada Manha Domingo").

   /* -------------------------- CONSISTE CAMPO HORA SAIDA MANHA DOMINGO --- */
   assign wk-reg3.hr-man-sai-domingo = trim(substring(c-dados,230,04)).
   run consiste-hora(wk-reg3.hr-man-sai-domingo, "Saida Manha Domingo").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA TARDE DOMINGO --- */
   assign wk-reg3.hr-tar-ent-domingo = trim(substring(c-dados,234,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-domingo, "Entrada Tarde Domingo").
 
   /* -------------------------- CONSISTE CAMPO HORA SAIDA TARDE DOMINGO --- */
   assign wk-reg3.hr-tar-sai-domingo = trim(substring(c-dados,238,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-domingo, "Saida Tarde Domingo").

   /* ------------------------------------ CONSISTE CAMPO UTILIZA MALOTE --- */
   case trim(substring(c-dados,242,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Utiliza Malote (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-malote = yes.
 
      when "N"
      then assign wk-reg3.lg-malote = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo Utiliza Malote ("
                                          + substring(c-dados,242,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ---------------------------- CONSISTE CAMPO RECEBE CORRESPONDENCIA --- */
   case trim(substring(c-dados,243,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Recebe Correspondencia (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-recebe-corresp = yes.
 
      when "N"
      then assign wk-reg3.lg-recebe-corresp = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo Recebe Correspondencia ("
                                          + substring(c-dados,243,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------------- CONSISTE CAMPO TIPO ENDERECO --- */
   if   int(substring(c-dados,244,01)) < 1
   and  int(substring(c-dados,244,01)) > 3
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 3
                 wk-erros.ds-desc      = "Conteudo do Campo Tipo Endereco ("
                                       + substring(c-dados,244,01)
                                       + ") NAO CONFERE com os Conteudos "
                                       + "Definidos no Layout de Importacao".
          assign lg-erro = yes.
        end.
 
   else assign wk-reg3.in-tipo-endereco = int(substring(c-dados,244,01)).

   assign wk-reg3.cd-cnes                      = int(substring(c-dados,245,7))
          wk-reg3.nr-leitos-tot                = substr(c-dados,252,6) 
          wk-reg3.nr-leitos-contrat            = substr(c-dados,258,6) 
          wk-reg3.nr-leitos-psiquiat           = substr(c-dados,264,6) 
          wk-reg3.nr-uti-adulto                = substr(c-dados,270,6) 
          wk-reg3.nr-uti-neonatal              = substr(c-dados,276,6) 
          wk-reg3.nr-uti-pediatria             = substr(c-dados,282,6)
          wk-reg3.nr-uti-neo-interm-neo        = substr(c-dados,323,6)
          wk-reg3.nr-leitos-hosp-dia           = int(substring(c-dados,379,06)) 
          wk-reg3.nr-leitos-tot-psic-n-uti     = int(substring(c-dados,385,06)) 
          wk-reg3.nr-leitos-tot-cirur-n-uti    = int(substring(c-dados,391,06)) 
          wk-reg3.nr-leitos-tot-ped-n-uti      = int(substring(c-dados,397,06)) 
          wk-reg3.nr-leito-tot-obst-n-uti      = int(substring(c-dados,403,06)) 
          wk-reg3.nm-latitue                   = substring(c-dados,409,20)      
          wk-reg3.nm-longitude                 = substring(c-dados,429,20)
          wk-reg3.nr-uti-neo-interm            = substr(c-dados,449,6).    

                                               
   /*-------------- Consiste e Filial  ------------------------*/
   case substring(c-dados,303,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Filial (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-filial = yes.
 
      when "N"
      then assign wk-reg3.lg-filial = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo E Filial ("
                                          + substring(c-dados,303,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

   /* --------------------------------------------------------------------------------- */
   assign wk-reg3.nr-cgc-cpf = trim(substring(c-dados,304,19)).

   if   wk-reg3.lg-filial  = yes 
   and trim(wk-reg3.nr-cgc-cpf) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Numero do CGC/CPF da filial do prestador nao informado".
          assign lg-erro = yes.
        end.

   else do: 
          if   not lg-formato-livre-aux
          then do:
                 run desedita-numero-cgc-cpf (input  wk-reg3.nr-cgc-cpf,
                                              output nr-cgc-cpf-aux).
          
                 assign wk-reg3.nr-cgc-cpf = nr-cgc-cpf-aux.
               end.
          
          if trim(wk-reg3.nr-cgc-cpf) <> ""
          then do:
                 run rtp/rtcgccpf.p(input  c-in-tipo-pessoa,
                                    input  wk-reg3.nr-cgc-cpf,
                                    input  no,
                                    output ds-mensrela-aux,
                                    output lg-erro-cgc-cpf-aux).
                 
                 if lg-erro-cgc-cpf-aux
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = ds-mensrela-aux
                                                     + " Verifique CGC/CPF da filial do prestador.".
                        assign lg-erro = yes.
                      end.
               end.
        end.
   
   /* --------------------------------------------------------------------------------- */
   assign wk-reg3.nm-end-web  = substr(c-dados,329,50).
   
   /*------------------------------------------------------------------------------------------*/

end procedure.
 
/* ------------------------------------------------------------------------------------------- */
procedure imp-reg-prest-inst:
    
    /* --------------------------------------------------- CRIAR REGISTRO --- */
    create wk-reg4.
    
    /* ------------------------------------------ CONSISTE CAMPO ENDERECO --- */
    assign wk-reg4.cod-instit = substring(c-dados,2,5).
    
    /* --------------------------------- CONSISTE CAMPO NIVEL ACREDICATAO --- */
    assign wk-reg4.cdn-nivel = int(substring(c-dados,7,1)) no-error.
    
    if   error-status:error
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 3
                  wk-erros.ds-desc      = "Nivel Acreditacao ("
                                        + substring(c-dados,7,1)
                                        + ") nao Numerico".
           assign lg-erro = yes.
         end.
    else do:
           if   wk-reg4.cdn-nivel < 1
           or   wk-reg4.cdn-nivel > 4
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 3
                         wk-erros.ds-desc      = "Conteudo do Campo Nivel Acreditacao ("
                                               + substring(c-dados,7,1)
                                               + ") NAO CONFERE com os Conteudos "
                                               + "Definidos no Layout de Importacao".
                  assign lg-erro = yes.
                end.
         end.

    /* ---------------------------------- CONSISTE CAMPO AUTORIZA DIVULGA --- */
    case trim(substring(c-dados,8,01)):
           when ""
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                  assign lg-erro = yes.
                end.
        
       when "S"
       then assign wk-reg4.lg-autoriz-divulga = yes.
       
       when "N"
       then assign wk-reg4.lg-autoriz-divulga = no.
       
       otherwise
            do:
              create wk-erros.
              assign wk-erros.cd-tipo-erro = "E"
                     wk-erros.cd-tipo-regs = 1
                     wk-erros.ds-desc      = "Conteudo do Campo Autoriza Divulgacao ("
                                           + substring(c-dados,8,01)
                                           + ") NAO CONFERE com os Conteudos "
                                           + "Definidos no Layout de "
                                           + "Importacao (S/N)".
              assign lg-erro = yes.
            end.
    end case.

    /* ------------------------ CAMPO SEQUENCIA ENDERECO --------------------- */
    assign wk-reg4.cd-seq-end = int(substr(c-dados,9,2)).

end procedure.

/* --------------------------------------------------------------------------- */
procedure imp-reg-prestdor-obs:
    
    /* --------------------------------------------------- CRIAR REGISTRO --- */
    create wk-reg5.
    /* ---------------------------------- CONSISTE CAMPO AUTORIZA DIVULGA --- */
    assign wk-reg5.divulga-obs = substring(c-dados,2,length(trim(c-dados)) - 1).

    if   trim(wk-reg5.divulga-obs) = ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Observacoes nao Informadas".
           assign lg-erro = yes.
         end.

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure imp-reg-prest-subst: 

    if substring(c-dados,22,2) = "00"
    then do:
           create wk-reg6.
           assign wk-reg6.c-cd-unidade-subst   = int(substring(c-dados,2,4))
                  wk-reg6.c-cd-prest-subst     = int(substring(c-dados,6,8)).
                  
           if substring(c-dados,14,8) <> "00000000"
           then assign wk-reg6.c-dt-inicio-subst = date(substring(c-dados,14,8)).
           else assign wk-reg6.c-dt-inicio-subst = ?.

         end.
    else assign c-cd-motivo-exclusao = int(substring(c-dados,22,2)).

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure desedita-numero-cgc-cpf:

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

/* -------------------------------------------------------------------------- */
procedure consiste-hora:
   def input parameter hr-par          as char                          no-undo.
   def input parameter ds-mensagem-par as char                          no-undo.

   if   trim(hr-par) <> ""
   then do:
          if   length(trim(hr-par)) <> 04
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 3
                        wk-erros.ds-desc      = "Hora " + ds-mensagem-par
                                                        + " Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 assign hr-aux = string(int(hr-par),"9999") no-error.
 
                 if   error-status:error
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 3
                               wk-erros.ds-desc      = "Hora " + ds-mensagem-par + " ("
                                                     + hr-par + ") nao Numerica".
                        assign lg-erro = yes.
                      end.
                 else do:
                        if   int(substring(hr-aux,01,02)) > 23
                        or   int(substring(hr-aux,03,02)) > 59
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 3
                                      wk-erros.ds-desc      = "Hora " + ds-mensagem-par
                                                                      + " Invalida".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
end procedure.
/* ------------------------------------------------------------------------------------------- */

procedure consiste-dias-trabalha:
   def input parameter in-dia-par as int                                no-undo.
   def input parameter in-pos-par as int                                no-undo.
   def input parameter ds-dia-par as char                               no-undo.

   case trim(substring(c-dados,in-pos-par,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Tabalha " + ds-dia-par + " (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-dias-trab[in-dia-par] = yes.
 
      when "N"
      then assign wk-reg3.lg-dias-trab[in-dia-par] = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo Trabalha "
                                          + ds-dia-par + " ("
                                          + substring(c-dados,in-pos-par,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
end procedure.


procedure consiste-endereco:
    
    def input        parameter cd-cidade-par     like dzcidade.cd-cidade     no-undo.
    def input        parameter en-uf-par         like usuario.en-uf          no-undo.
    def input        parameter en-cep-par        like usuario.en-cep         no-undo. 
    def input        parameter en-rua-par        like usuario.en-rua         no-undo.
    def input        parameter en-bairro-par     like usuario.en-bairro      no-undo.
    def input        parameter tipo-pessoa-par   like preserv.in-tipo-pessoa no-undo.
    def input        parameter in-tipo-par       as char format "x(1)"       no-undo.
    def input-output parameter lg-erro-par       as log                      no-undo.
    def input        parameter cd-tipo-reg-par   as int format "9"           no-undo.
    
    /* 07/11/2016 - Alex Boeira - retirada validacao de endereco. Devem ser aceitos os enderecos como estao no Unicoo.
     * na digitacao em tela as consistencias continuarao ocorrendo normalmente.
    if   int(en-cep-par) = 0
    then en-cep-par = "".

    assign lg-erro-rtendere-aux            = no
           lg-prim-mens-rtendere-aux       = no
           in-modulo-sistema-rtendere-aux  = "CG"
           in-tipo-rtendere-aux            = in-tipo-par
           in-tipo-tela-rtendere-aux       = no
           in-tp-rtendere-aux              = tipo-pessoa-par
           cd-cidade-rtendere-aux          = cd-cidade-par
           en-uf-rtendere-aux              = en-uf-par       
           en-cep-rtendere-aux             = en-cep-par      
           en-rua-rtendere-aux             = en-rua-par      
           en-bairro-retendere-aux         = en-bairro-par.  
      
    run rtp/rtendere.p.                 
    
    if   lg-erro-rtendere-aux
    then do:
            for each tmp-mensa-rtendere no-lock:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = cd-tipo-reg-par
                        wk-erros.ds-desc      = tmp-mensa-rtendere.ds-mensagem-mens +
                                                " " + 
                                                tmp-mensa-rtendere.ds-chave-mens.
            end.
            assign lg-erro-par = yes.
         end.
    */

end procedure.

procedure consulta-imposto:

    def input  param c-cd-imposto-par as char no-undo.
    def input  param c-des-erro-par   as char no-undo.
    def output param lg-erro-par      as log  no-undo.

     find imposto
    where imposto.cod_pais          = "BRA"
      and imposto.cod_unid_federac  = c-en-uf
      and imposto.cod_imposto       = c-cd-imposto-par 
          no-lock no-error.

    if not avail imposto
    then find imposto
        where imposto.cod_pais          = "BRA"
          and imposto.cod_unid_federac  = "  "
          and imposto.cod_imposto       = c-cd-imposto-par
              no-lock no-error.

    if   not avail imposto and c-cd-magnus <> 0
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                                  wk-erros.ds-desc      = c-des-erro-par
                  lg-erro-par           = yes.
         end.
end.

procedure consulta-class-imposto:

    def input  param c-cd-imposto-par               as char no-undo.
    def input  param c-cd-classificacao-imposto-par as char no-undo.
    def input  param c-des-erro-par                 as char no-undo.
    def output param lg-erro-par                    as log  no-undo.

    find classif_impto
   where classif_impto.cod_pais          = "BRA"                  
     and classif_impto.cod_unid_federac  = c-en-uf                
     and classif_impto.cod_imposto       = c-cd-imposto-par       
     and classif_impto.cod_classif_impto = c-cd-classificacao-imposto-par
         no-lock no-error.

    if   not avail classif_impto
    then find classif_impto
        where classif_impto.cod_pais          = "BRA"            
          and classif_impto.cod_unid_federac  = "  "             
          and classif_impto.cod_imposto       = c-cd-imposto-par
          and classif_impto.cod_classif_impto = c-cd-classificacao-imposto-par
              no-lock no-error.

    if   not avail classif_impto and c-cd-magnus <> 0
    then do:

           IF dt-ignorar-validacao-aux < TODAY
           THEN DO:

                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = c-des-erro-par.
                   assign lg-erro-par = yes.
           END.
         end.

end procedure.

procedure consulta-vinc-imp-for:

    def input  param c-cd-imposto-par               as char no-undo.
    def input  param c-cd-classificacao-imposto-par as char no-undo.
    def input  param c-des-erro-par                 as char no-undo.
    def output param lg-erro-par                    as log  no-undo.

    find impto_vincul_fornec
   where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
     and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
     and impto_vincul_fornec.cod_pais          = "BRA"
     and impto_vincul_fornec.cod_unid_federac  = c-en-uf
     and impto_vincul_fornec.cod_imposto       = c-cd-imposto-par
     and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-imposto-par
         no-lock no-error.
                
    if not avail impto_vincul_fornec
    then find impto_vincul_fornec
        where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
          and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
          and impto_vincul_fornec.cod_pais          = "BRA"
          and impto_vincul_fornec.cod_unid_federac  = "  "
          and impto_vincul_fornec.cod_imposto       = c-cd-imposto-par
          and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-imposto-par 
              no-lock no-error.
    
    if   not avail impto_vincul_fornec
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = c-des-erro-par.
           assign lg-erro-par = yes.
         end.

end procedure.


/* -------------------- ESTOURO DE SEGMENTO ---------------------------- */
procedure consiste-tributos:

    def var c-des-erro-aux as char no-undo.
    DEF VAR lg-erro-imposto AS LOG INIT NO NO-UNDO.
    
    do: 
            /* ------------------------------------------------- CONSISTE IMPOSTO --- */
            assign c-cd-imposto = trim(substring(c-dados,607,5)).

            if c-cd-imposto <> ""
            or c-cd-imposto <> "     "
            then do:
                   if  c-cd-magnus <> 0
                   then do:
                          assign c-des-erro-aux = "Imposto de Renda (" + string(c-cd-imposto,"99999") + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-imposto,
                                                input c-des-erro-aux,
                                                output lg-erro-imposto).
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-imposto <> ""
                        or  c-cd-imposto <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto de Renda ("
                                                             + string(c-cd-imposto,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* -------------------------------- CONSISTE CLASSIFICACAO DO IMPOSTO --- */
                   assign c-cd-classificacao-imposto = trim(substring(c-dados,612,5)).

                   if  c-cd-magnus <> 0
                   then DO:
                          assign c-des-erro-aux = "Classif. de Imposto de Renda ("
                                                + string(c-cd-classificacao-imposto,"99999")
                                                + ") nao Cadastrado".

                          run consulta-class-imposto (input c-cd-imposto,
                                                      input c-cd-classificacao-imposto,
                                                      input c-des-erro-aux,
                                                      output lg-erro-imposto).                           
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-classificacao-imposto <> ""
                        or  c-cd-classificacao-imposto <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto de Renda ("
                                                               + string(c-cd-classificacao-imposto,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.

                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if c-cd-magnus <> 0
                   then do:
                          assign c-des-erro-aux = "Imposto de Renda Vinculado ("
                                                + string(c-cd-imposto,"99999") + " - " 
                                                + string(c-cd-classificacao-imposto,"99999")
                                                + ") ao fornecedor nao Cadastrado".

                          run consulta-vinc-imp-for (input c-cd-imposto,
                                                     input c-cd-classificacao-imposto,
                                                     input c-des-erro-aux,
                                                     output lg-erro-imposto).
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                 end.

            /* ------------------------------------------------- CONSISTE INSS - */
            assign c-cd-inss = trim(substring(c-dados,676,5)).

            if c-cd-inss <> ""
            or c-cd-inss <> "     "
            then do:
                   if  c-cd-magnus <> 0
                   and substring(c-dados,294,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto de INSS ("
                                                + string(c-cd-inss,"99999")
                                                + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-inss,
                                                input c-des-erro-aux,
                                                output lg-erro-imposto).
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-inss <> ""
                        or  c-cd-inss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto de INSS ("
                                                             + string(c-cd-inss,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   
                   /* ----------------------------- CONSISTE CLASSIFICACAO DO INSS - */
                   assign c-cd-classificacao-inss = trim(substring(c-dados,681,5)).
                   
                   if  c-cd-magnus <> 0
                   and substring(c-dados,294,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Classif. de Imposto de INSS ("
                                                + string(c-cd-classificacao-inss,"99999")
                                                + ") nao Cadastrado".

                          run consulta-class-imposto (input c-cd-inss,
                                                      input c-cd-classificacao-inss,
                                                      input c-des-erro-aux,
                                                      output lg-erro-imposto). 
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-classificacao-inss <> ""
                        or  c-cd-classificacao-inss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto de INSS ("
                                                               + string(c-cd-classificacao-inss,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if  c-cd-magnus <> 0
                   and substring(c-dados,294,1) = "S"
                   and c-in-tipo-pessoa = "F"
                   then do:
                           find impto_vincul_fornec
                                where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
                                  and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
                                  and impto_vincul_fornec.cod_pais          = "BRA"
                                  and impto_vincul_fornec.cod_unid_federac  = c-en-uf
                                  and impto_vincul_fornec.cod_imposto       = c-cd-inss
                                  and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-inss 
                                      no-lock no-error.
                         
                           if   not avail impto_vincul_fornec
                           then find impto_vincul_fornec
                                where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
                                  and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
                                  and impto_vincul_fornec.cod_pais          = "BRA"
                                  and impto_vincul_fornec.cod_unid_federac  = "  "
                                  and impto_vincul_fornec.cod_imposto       = c-cd-inss
                                  and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-inss 
                                      no-lock no-error.
                         
                           if  paramepp.lg-deduz-inss
                           and not avail impto_vincul_fornec
                           then do:
                                  create wk-erros.
                                  assign wk-erros.cd-tipo-erro = "E"
                                         wk-erros.cd-tipo-regs = 1
                                         wk-erros.ds-desc      = "Imposto de INSS ("
                                                               + string(c-cd-inss,"99999") + " - " 
                                                               + string(c-cd-classificacao-inss,"99999")
                                                               + ") nao foi vinculado ao fornecedor.".
                                  assign lg-erro = yes.
                                end.
                           else if  not paramepp.lg-deduz-inss
                                and avail impto_vincul_fornec
                                then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto de INSS ("
                                                                    + string(c-cd-inss,"99999") + " - " 
                                                                    + string(c-cd-classificacao-inss,"99999")
                                                                    + ") nao pode ser vinculado ao fornecedor.".
                                       assign lg-erro = yes.
                                     end.
                        end.
                 end.
               
            /* ------------------------------------------------- CONSISTE ISS - */
            assign c-cd-iss = trim(substring(c-dados,687,5)).

            if c-cd-iss <> ""
            or c-cd-iss <> "     "
            then do:
                   if  c-cd-magnus <> 0
                   and substring(c-dados,686,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto de ISS ("
                                                + string(c-cd-iss,"99999")
                                                + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-iss,
                                                input c-des-erro-aux,
                                                output lg-erro-imposto).
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-iss <> ""
                        or  c-cd-iss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto de ISS("
                                                             + string(c-cd-iss,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ----------------------------- CONSISTE CLASSIFICACAO DO ISS - */
                   assign c-cd-classificacao-iss = trim(substring(c-dados,692,5)).
                   
                   IF dt-ignorar-validacao-aux <= TODAY
                   THEN DO:
                           if  c-cd-magnus <> 0
                           and substring(c-dados,686,1) = "S"
                           then do:
                                  assign c-des-erro-aux = "Classif. de Imposto de ISS ("
                                                        + string(c-cd-classificacao-iss,"99999")
                                                        + ") nao Cadastrado para o imposto (" + STRING(c-cd-iss) + ")".
        
                                  run consulta-class-imposto (input c-cd-iss,
                                                              input c-cd-classificacao-iss,
                                                              input c-des-erro-aux,
                                                              output lg-erro-imposto). 
                                  IF lg-erro-imposto THEN lg-erro = YES.
                                end.
                           else if  c-cd-classificacao-iss <> ""
                                or  c-cd-classificacao-iss <> "     "
                                then do:
                                        create wk-erros.
                                        assign wk-erros.cd-tipo-erro = "E"
                                               wk-erros.cd-tipo-regs = 1
                                               wk-erros.ds-desc      = "Classif. de Imposto de ISS ("
                                                                       + string(c-cd-classificacao-iss,"99999")
                                                                       + ") deve ser brancos "
                                                                       + "pois fornecedor nao foi informado"
                                               lg-erro = yes.
                                     end.
                   END.

                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if  c-cd-magnus <> 0
                   and substring(c-dados,686,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto de ISS Vinculado ("
                                                + string(c-cd-iss,"99999") + " - " 
                                                + string(c-cd-classificacao-iss,"99999")
                                                + ") ao fornecedor nao Cadastrado".

                          run consulta-vinc-imp-for (input c-cd-iss,
                                                     input c-cd-classificacao-iss,
                                                     input c-des-erro-aux,
                                                     output lg-erro-imposto). 
                          IF lg-erro-imposto
                          THEN lg-erro = YES.
                        end.
                 end.

            /* ------------------------------------------------- CONSISTE IMPOSTO UNICO ---- */
            assign c-cd-imposto-unico = trim(substring(c-dados,748,5)).

            if  c-cd-imposto-unico <> ""
            or  c-cd-imposto-unico <> "     "
            then do:
                   if   c-cd-magnus <> 0
                   and  substring(c-dados,747,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto ("
                                                + string(c-cd-imposto-unico,"99999")
                                                + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-imposto-unico,
                                                input c-des-erro-aux,
                                                output lg-erro-imposto).
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-imposto-unico <> ""
                        or  c-cd-imposto-unico <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto ("
                                                             + string(c-cd-imposto-unico,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   
                   /* -------------------------------- CONSISTE CLASSIFICACAO DO IMPOSTO UNICO ---- */
                   assign c-cd-clas-imposto-unico = trim(substring(c-dados,753,5)).
                   
                   if  c-cd-magnus <> 0
                   and substring(c-dados,747,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Classif. de Imposto ("
                                                + string(c-cd-clas-imposto-unico,"99999")
                                                + ") nao Cadastrado".
                          run consulta-class-imposto (input c-cd-imposto-unico,
                                                      input c-cd-clas-imposto-unico,
                                                      input c-des-erro-aux,
                                                      output lg-erro-imposto).                  
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                   else if  c-cd-clas-imposto-unico <> ""
                        or  c-cd-clas-imposto-unico <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto ("
                                                               + string(c-cd-clas-imposto-unico,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if  c-cd-magnus <> 0
                   and substring(c-dados,747,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto Vinculado ("
                                                + string(c-cd-imposto-unico,"99999") + " - " 
                                                + string(c-cd-clas-imposto-unico,"99999")
                                                + ") ao fornecedor nao Cadastrado".
                   
                          run consulta-vinc-imp-for (input c-cd-imposto-unico,
                                                     input c-cd-clas-imposto-unico,
                                                     input c-des-erro-aux,
                                                     output lg-erro-imposto).
                          IF lg-erro-imposto THEN lg-erro = YES.
                        end.
                 end.

            if substring(c-dados,747,1) = "N" 
            then do:
                   if trim(substring(c-dados,748,5)) <> ""
                   then do:
                          create wk-erros.
                          assign wk-erros.cd-tipo-erro = "E"
                                 wk-erros.cd-tipo-regs = 1
                                 wk-erros.ds-desc      = "Os campos Cod. Imposto Unico "  + (trim(substring(c-dados,748,5)))
                                                       + " deve ser brancos". 
                          assign lg-erro = yes.
                        end.
            
                   if trim(substring(c-dados,753,5)) <> ""
                   then do:
                          create wk-erros.
                          assign wk-erros.cd-tipo-erro = "E"
                                 wk-erros.cd-tipo-regs = 1
                                 wk-erros.ds-desc      = "Os campos Classif. Imposto Unico " + trim(substring(c-dados,753,5))
                                                       + " deve ser brancos". 
                          assign lg-erro = yes.
                        end.

                   /* ------------------------------------------------- CONSISTE COFINS ---- */
                   assign c-cd-cofins = trim(substring(c-dados,646,5)).

                   if  c-cd-cofins <> ""
                   or  c-cd-cofins <> "     "
                   then do:
                          if  c-cd-magnus <> 0
                          and substring(c-dados,643,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto ("
                                                       + string(c-cd-cofins,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-imposto (input c-cd-cofins,
                                                       input c-des-erro-aux,
                                                       output lg-erro-imposto).
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                          else if  c-cd-cofins <> ""
                               or  c-cd-cofins <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto ("
                                                                    + string(c-cd-cofins,"99999")
                                                                    + ") deve ser brancos "
                                                                    + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* -------------------------------- CONSISTE CLASSIFICACAO DO COFINS ---- */
                          assign c-cd-classificacao-cofins = trim(substring(c-dados,661,5)).
                          
                          if  c-cd-magnus <> 0
                          and substring(c-dados,643,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Classif. de Imposto ("
                                                       + string(c-cd-classificacao-cofins,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-class-imposto (input c-cd-cofins,
                                                             input c-cd-classificacao-cofins,
                                                             input c-des-erro-aux,
                                                             output lg-erro-imposto).  
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                          else if  c-cd-classificacao-cofins <> ""
                               or  c-cd-classificacao-cofins <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Classif. de Imposto ("
                                                                      + string(c-cd-classificacao-cofins,"99999")
                                                                      + ") deve ser brancos "
                                                                      + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                          if  c-cd-magnus <> 0
                          and substring(c-dados,643,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto Vinculado ("
                                                       + string(c-cd-cofins,"99999") + " - " 
                                                       + string(c-cd-classificacao-cofins,"99999")
                                                       + ") ao fornecedor nao Cadastrado".
                                 
                                 run consulta-vinc-imp-for (input c-cd-cofins,
                                                            input c-cd-classificacao-cofins,
                                                            input c-des-erro-aux,
                                                            output lg-erro-imposto).
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                        end.

                    /* ------------------------------------------------- CONSISTE PIS/PASEP - */
                   assign c-cd-pispasep = trim(substring(c-dados,651,5)).

                   if  c-cd-pispasep <> ""
                   or  c-cd-pispasep <> "     "
                   then do:
                          if  c-cd-magnus <> 0
                          and substring(c-dados,644,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto ("
                                                       + string(c-cd-pispasep,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-imposto (input c-cd-pispasep,
                                                       input c-des-erro-aux,
                                                       output lg-erro-imposto).
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                          else if  c-cd-pispasep <> ""
                               or  c-cd-pispasep <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto ("
                                                                    + string(c-cd-pispasep,"99999")
                                                                    + ") deve ser brancos "
                                                                    + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* -------------------------------- CONSISTE CLASSIFICACAO DO PIS PASEP - */
                          assign c-cd-classificacao-pispasep = trim(substring(c-dados,666,5)).
                          
                          if  c-cd-magnus <> 0
                          and substring(c-dados,644,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Classif. de Imposto ("
                                                       + string(c-cd-classificacao-pispasep,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-class-imposto (input c-cd-pispasep,
                                                             input c-cd-classificacao-pispasep,
                                                             input c-des-erro-aux,
                                                             output lg-erro-imposto). 
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                          else if  c-cd-classificacao-pispasep <> ""
                               or  c-cd-classificacao-pispasep <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Classif. de Imposto ("
                                                                      + string(c-cd-classificacao-pispasep,"99999")
                                                                      + ") deve ser brancos "
                                                                      + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                          if c-cd-magnus <> 0
                          and substring(c-dados,644,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto Vinculado ("
                                                       + string(c-cd-pispasep,"99999") + " - " 
                                                       + string(c-cd-classificacao-pispasep,"99999")
                                                       + ") ao fornecedor nao Cadastrado".
                                 
                                 run consulta-vinc-imp-for (input c-cd-pispasep,
                                                            input c-cd-classificacao-pispasep,
                                                            input c-des-erro-aux,
                                                            output lg-erro-imposto).
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                        end.

                   /* ------------------------------------------------- CONSISTE CSLL - */
                   assign c-cd-csll = trim(substring(c-dados,656,5)).

                   if  c-cd-csll <> ""
                   or  c-cd-csll <> "     "
                   then do:
                          if  c-cd-magnus <> 0
                          and substring(c-dados,645,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto ("
                                                       + string(c-cd-csll,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-imposto (input c-cd-csll,
                                                       input c-des-erro-aux,
                                                       output lg-erro-imposto).
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end.
                          else if  c-cd-csll <> ""
                               or  c-cd-csll <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto ("
                                                                    + string(c-cd-csll,"99999")
                                                                    + ") deve ser brancos "
                                                                    + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* -------------------------------- CONSISTE CLASSIFICACAO DO CSLL - */
                          assign c-cd-classificacao-csll = trim(substring(c-dados,671,5)).
                          
                          if  c-cd-magnus <> 0
                          and substring(c-dados,645,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Classif. de Imposto ("
                                                       + string(c-cd-classificacao-csll,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-class-imposto (input c-cd-csll,
                                                             input c-cd-classificacao-csll,
                                                             input c-des-erro-aux,
                                                             output lg-erro-imposto). 
                                 IF lg-erro-imposto THEN lg-erro = yes.
                               end.
                          else if  c-cd-classificacao-csll <> ""
                               or  c-cd-classificacao-csll <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Classif. de Imposto ("
                                                                      + string(c-cd-classificacao-csll,"99999")
                                                                      + ") deve ser brancos "
                                                                      + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                          if  c-cd-magnus <> 0
                          and substring(c-dados,645,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto Vinculado ("
                                                       + string(c-cd-csll,"99999") + " - " 
                                                       + string(c-cd-classificacao-csll,"99999")
                                                       + ") ao fornecedor nao Cadastrado".
                                 
                                 run consulta-vinc-imp-for (input c-cd-csll,
                                                            input c-cd-classificacao-csll,
                                                            input c-des-erro-aux,
                                                            output lg-erro-imposto).
                                 IF lg-erro-imposto THEN lg-erro = YES.
                               end. 
                        end.
                 end.
            else do:
                   if trim(substring(c-dados,646,5)) <> ""
                   or trim(substring(c-dados,651,5)) <> ""
                   or trim(substring(c-dados,656,5)) <> ""
                   or trim(substring(c-dados,661,5)) <> ""
                   or trim(substring(c-dados,666,5)) <> ""
                   or trim(substring(c-dados,671,5)) <> ""
                   then do:
                          create wk-erros.
                          assign wk-erros.cd-tipo-erro = "E"
                                 wk-erros.cd-tipo-regs = 1
                                 wk-erros.ds-desc      = "Codigo(s) de Imposto(s) informado(s)"
                                                       + "que DEVERIAM estar em branco "
                                                       + trim(substring(c-dados,646,5)) + " - " 
                                                       + trim(substring(c-dados,651,5)) + " - " 
                                                       + trim(substring(c-dados,656,5)) + " - " 
                                                       + trim(substring(c-dados,661,5)) + " - " 
                                                       + trim(substring(c-dados,666,5)) + " - " 
                                                       + trim(substring(c-dados,671,5)).
                          assign lg-erro = yes.
                        end.
                 end.
            end.
    .
    
end procedure.

/* procedure usada apenas para gravar mensagens no clientlog */
PROCEDURE escrever-log:
    DEF INPUT PARAM ds-par AS CHAR NO-UNDO.
END PROCEDURE.

/* -------------------------------------------------------------------- EOF - */
