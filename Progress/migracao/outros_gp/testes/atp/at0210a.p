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
assign c_prg_vrs = "2.00.00.001".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'AT0210A':U, '2.00.00.001':U, '':U).
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
  /*** 010001 ***/ 



/******************************************************************************
    Programa .....: at0210a.p
    Data .........: 18/05/2015
    Empresa ......: TOTVS
    Programador ..: Jeferson Dal Molin
    Objetivo .....: Migracao das guias de autorizacao do Unicoo para o GPS
*-----------------------------------------------------------------------------*/
hide all no-pause.

/*****************************************************************************
*      Programa .....: hdvarregua.i                                          *
*      Data .........: 20 de Janeiro de 1998                                 *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: HD - Includes Padroes                                 *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Variaveis para montagem das reguas                    *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*      7.00.000  06/03/2003  Nora           Desenvolvimento                  *
*****************************************************************************/

def var lg-permitido        as log                                      no-undo.
def var lg-btn-principal    as log                                      no-undo.
def var lg-btn-inclui       as log                                      no-undo.
def var lg-btn-modifica     as log                                      no-undo.
def var lg-btn-elimina      as log                                      no-undo.
def var lg-btn-funcao       as log                                      no-undo.
def var lg-btn-relatorio    as log                                      no-undo.
def var lg-btn-copiar       as log                                      no-undo.
def var lg-btn-congela      as log                                      no-undo.
def var lg-btn-descongela   as log                                      no-undo.
def var lg-btn-parametro    as log                                      no-undo.
def var lg-btn-atualiza     as log                                      no-undo.
def var lg-btn-selecao      as log                                      no-undo.
def var lg-btn-executa      as log                                      no-undo.
def var lg-btn-geracao      as log                                      no-undo.
def var lg-btn-transfere    as log                                      no-undo.
def var lg-btn-reativa      as log                                      no-undo.
def var lg-btn-habilita     as log                                      no-undo.
def var lg-btn-desabilita   as log                                      no-undo.
def var lg-btn-beneficiario as log                                      no-undo.
def var lg-btn-contratante  as log                                      no-undo.
def var lg-btn-simulacao    as log                                      no-undo.
def var lg-btn-suspende     as log                                      no-undo.
def var lg-btn-arquivo      as log                                      no-undo.
def var lg-btn-cancela      as log                                      no-undo.
def var lg-btn-duplicar     as log                                      no-undo.
def var lg-btn-reajustar    as log                                      no-undo.
def var lg-btn-revalorizar  as log                                      no-undo.
def var lg-btn-estornar     as log                                      no-undo.
def var lg-btn-exames       as log                                      no-undo.
def var lg-btn-fechar       as log                                      no-undo.
def var lg-btn-prorrogar    as log                                      no-undo.
def var lg-btn-antecipacao  as log                                      no-undo.
def var lg-btn-confirma     as log                                      no-undo.
def var nr-tam-permis       as int                                      no-undo.
def var nm-prg-novo         as char format "x(100)"                     no-undo.
def var c-opcao             as char                                     no-undo.
/* --------------------------------------------------- BOTOES PARA WINDOWS --- */
/*****************************************************************************
*      Programa .....: hddefbotao.i                                          *
*      Data .........: 06 de Marco de 2003                                   *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: Includes padraes                                      *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Definicao dos botoes para windows                     *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*****************************************************************************/

/* --------------------------------------------------- BOTOES PARA WINDOWS --- */
define button b-primeiro 
     image-up file "igp/primeiro-up.gif" image-size 4 by 4
     label "P&rimeiro" 
     size 4 BY 2.0 tooltip "Primeiro"
     auto-go.

define button b-ultimo 
     image-up file "igp/ultimo-up.gif" image-size 4 by 4
     label "&Ultimo" 
     size 4 BY 2.0 tooltip "Ultimo"
     auto-go.

define button b-proximo 
     image-up file "igp/proximo-up.gif" image-size 4 by 4
     label "&Proximo" 
     size 4 BY 2.0 tooltip "Proximo"
     auto-go.

define button b-anterior 
     image-up file "igp/anterior-up.gif" image-size 4 by 4
     label "&Anterior" 
     size 4 BY 2.0 tooltip "Anterior"
     auto-go.

define button b-codigo 
     image-up file "igp/pesquisa-up.gif" image-size 4 by 4
     label "&Codigo" 
     size 4 BY 2.0 tooltip "Codigo"
     auto-go.

define button b-inclui 
     image-up file "igp/inclui-up.gif" image-size 4 by 4
     label "&Inclui" 
     size 4 BY 2.0 tooltip "Inclui"
     auto-go.

define button b-modifica 
     image-up file "igp/modifica-up.gif" image-size 4 by 4
     label "&Modifica" 
     size 4 BY 2.0 tooltip "Modifica"
     auto-go.

define button b-elimina 
     image-up file "igp/elimina-up.gif" image-size 4 by 4
     label "&Elimina" 
     size 4 BY 2.0 tooltip "Elimina"
     auto-go.

define button b-funcao  
     image-up file "igp/funcoes-up.gif" image-size 4 by 4
     label "&Funcao" 
     size 4 BY 2.0 tooltip "Funcao"
     auto-go.

define button b-lista 
     image-up file "igp/lista-up.gif" image-size 4 by 4
     label "&Lista" 
     size 4 BY 2.0 tooltip "Lista"
     auto-go.

define button b-relatorio 
     image-up file "igp/relatorio-up.gif" image-size 4 by 4
     label "Rela&torio" 
     size 4 BY 2.0 tooltip "Relatorio"
     auto-go.

define button b-imprime
     image-up file "igp/imprime-up.gif" image-size 4 by 4
     label "Imprime" 
     size 4 BY 2.0 tooltip "Imprime"
     auto-go.

define button b-fim DEFAULT 
     image-up file "igp/saida-up.gif" image-size 4 by 4
     label "&Fim" 
     size 4 BY 2.0 tooltip "Saida"
     auto-go.

define button b-help DEFAULT 
     image-up file "igp/help-up.gif" image-size 4 by 4
     label "&Help" 
     size 4 BY 2.0 tooltip "Ajuda"
     .

define button b-copia
     image-up file "igp/copia-up.gif" image-size 4 by 4
     label "&Copia" 
     size 4 BY 2.0 tooltip "Copia"
     auto-go.

define button b-congela
     image-up file "igp/congela-up.gif" image-size 4 by 4
     label "Con&gela" 
     size 4 BY 2.0 tooltip "Congela"
     auto-go.

define button b-descongela
     image-up file "igp/descongela-up.gif" image-size 4 by 4
     label "&Descongela" 
     size 4 BY 2.0 tooltip "Descongela"
     auto-go.

define button b-parametro
     image-up file "igp/parametro-up.gif" image-size 4 by 4
     label "&Parametro" 
     size 4 BY 2.0 tooltip "Parametro"
     auto-go.

define button b-atualiza
     image-up file "igp/atualiza-up.gif" image-size 4 by 4
     label "&Atualiza" 
     size 4 BY 2.0 tooltip "Atualiza"
     auto-go.

define button b-selecao
     image-up file "igp/selecao-up.gif" image-size 4 by 4
     label "&Selecao" 
     size 4 BY 2.0 tooltip "Selecao"
     auto-go.

define button b-executa
     image-up file "igp/executa-up.gif" image-size 4 by 4
     label "&Executa" 
     size 4 BY 2.0 tooltip "Executa"
     auto-go.

define button b-geracao
     image-up file "igp/geracao-up.gif" image-size 4 by 4
     label "&Geracao" 
     size 4 BY 2.0 tooltip "Geracao"
     auto-go.

define button b-transferencia
     image-up file "igp/transferencia-up.gif" image-size 4 by 4
     label "&Transferencia" 
     size 4 BY 2.0 tooltip "Transferencia"
     auto-go.

define button b-reativa
     image-up file "igp/reativa-up.gif" image-size 4 by 4
     label "&Reativa" 
     size 4 BY 2.0 tooltip "Reativa"
     auto-go.

define button b-habilita
     image-up file "igp/habilita-up.gif" image-size 4 by 4
     label "&Habilita" 
     size 4 BY 2.0 tooltip "Habilita"
     auto-go.

define button b-desabilita
     image-up file "igp/desabilita-up.gif" image-size 4 by 4
     label "&Desabilita" 
     size 4 BY 2.0 tooltip "Desabilita"
     auto-go.

define button b-beneficiario
     image-up file "igp/beneficiario-up.gif" image-size 4 by 4
     label "&Beneficiario" 
     size 4 BY 2.0 tooltip "Beneficiario"
     auto-go.

define button b-contratante
     image-up file "igp/contratante-up.gif" image-size 4 by 4
     label "&Contratante" 
     size 4 BY 2.0 tooltip "Contratante"
     auto-go.

define button b-simulacao
     image-up file "igp/simulacao-up.gif" image-size 4 by 4
     label "&Simulacao" 
     size 4 BY 2.0 tooltip "Simulacao"
     auto-go.

define button b-suspende
     image-up file "igp/suspende-up.gif" image-size 4 by 4
     label "&Suspende" 
     size 4 BY 2.0 tooltip "Suspende"
     auto-go.

define button b-arquivo
     image-up file "igp/arquivo-up.gif" image-size 4 by 4
     label "&Arquivo" 
     size 4 BY 2.0 tooltip "Arquivo"
     auto-go.

define button b-cancela
     image-up file "igp/cancela-up.gif" image-size 4 by 4
     label "&Cancela" 
     size 4 BY 2.0 tooltip "Cancela"
     auto-go.

define button b-classificacao
     image-up file "igp/classificacao-up.gif" image-size 4 by 4
     label "&Classificacao" 
     size 4 BY 2.0 tooltip "Classificacao"
     auto-go.

define button b-duplicar 
     image-up file "igp/duplicar-up.gif" image-size 4 by 4
     label "&Duplicar" 
     size 4 BY 2.0 tooltip "Duplicar"
     auto-go.

define button b-reajustar
     image-up file "igp/reajustar-up.gif" image-size 4 by 4
     label "&Reajustar" 
     size 4 BY 2.0 tooltip "Reajustar"
     auto-go.

define button b-revalorizar
     image-up file "igp/revalorizar-up.gif" image-size 4 by 4
     label "&Revalorizar" 
     size 4 BY 2.0 tooltip "Revalorizar"
     auto-go.

define button b-consiste
     image-up file "igp/consiste-up.gif" image-size 4 by 4
     label "&Consiste" 
     size 4 BY 2.0 tooltip "Consiste"
     auto-go.

define button b-importa
     image-up file "igp/importa-up.gif" image-size 4 by 4
     label "&Importa" 
     size 4 BY 2.0 tooltip "Importa"
     auto-go.

define button b-carrega
     image-up file "igp/carrega-up.gif" image-size 4 by 4
     label "&Carrega" 
     size 4 BY 2.0 tooltip "Carrega"
     auto-go.

define button b-layout
     image-up file "igp/layout-up.gif" image-size 4 by 4
     label "&Layout" 
     size 4 BY 2.0 tooltip "Layout"
     auto-go.

define button b-exporta
     image-up file "igp/exporta-up.gif" image-size 4 by 4
     label "&Exporta" 
     size 4 BY 2.0 tooltip "Exporta"
     auto-go.

define button b-reexporta
     image-up file "igp/reexporta-up.gif" image-size 4 by 4
     label "&Reexporta" 
     size 4 BY 2.0 tooltip "Reexporta"
     auto-go.

define button b-estornar
     image-up file "igp/estornar-up.gif" image-size 4 by 4
     label "&Estornar" 
     size 4 BY 2.0 tooltip "Estornar"
     auto-go.

define button b-exames
     image-up file "igp/exames-up.gif" image-size 4 by 4
     label "&Exames" 
     size 4 BY 2.0 tooltip "Exames"
     auto-go.

define button b-parecer
     image-up file "igp/parecer-up.gif" image-size 4 by 4
     label "&Parecer" 
     size 4 BY 2.0 tooltip "Parecer"
     auto-go.

define button b-antecipacao
     image-up file "igp/antecipacao-up.gif" image-size 4 by 4
     label "&Antecipacao" 
     size 4 BY 2.0 tooltip "Gera Antecipacao de guias"
     auto-go.

define button b-confirma
     image-up file "igp/confirma-up.gif" image-size 4 by 4
     label "&Confirma"  
     size 4 BY 2.0 tooltip "Confirma orcamento"
     auto-go.

define button b-orcamento
     image-up file "igp/orcamento-up.gif" image-size 4 by 4
     label "&Orcamento" 
     size 4 BY 2.0 tooltip "Orcamento"
     auto-go.

define button b-autorizacao
     image-up file "igp/autorizacao-up.gif" image-size 4 by 4
     label "&Autorizacao" 
     size 4 BY 2.0 tooltip "Autorizacao"
     auto-go.

define button b-fechar
     image-up file "igp/fechar-up.gif" image-size 4 by 4
     label "&Fechar"   
     size 4 BY 2.0 tooltip "Fechar"
     auto-go.

define button b-prorrogar
     image-up file "igp/prorrogar-up.gif" image-size 4 by 4
     label "&Prorrogar" 
     size 4 BY 2.0 tooltip "Prorrogar"
     auto-go.

define button b-prestador
     image-up file "igp/prestador-up.gif" image-size 4 by 4
     label "&Prestador" 
     size 4 BY 2.0 tooltip "Prestador"
     auto-go.

define button b-ocorrencia
     image-up file "igp/ocorrencia-up.gif" image-size 4 by 4
     label "&Ocorrencia" 
     size 4 BY 2.0 tooltip "Ocorrencia"
     auto-go.

define button b-solucao
     image-up file "igp/solucao-up.gif" image-size 4 by 4
     label "&Solucao" 
     size 4 BY 2.0 tooltip "Solucao"
     auto-go.

define button b-reimprime
     image-up file "igp/reimprime-up.gif" image-size 4 by 4
     label "&Reimprime" 
     size 4 BY 2.0 tooltip "Reimprime"
     auto-go.

define button b-contabiliza
     image-up file "igp/contabiliza-up.gif" image-size 4 by 4
     label "&Contabiliza" 
     size 4 BY 2.0 tooltip "Contabiliza"
     auto-go.

define button b-descontabiliza
     image-up file "igp/descontabiliza-up.gif" image-size 4 by 4
     label "&Descontabiliza" 
     size 4 BY 2.0 tooltip "Descontabiliza"
     auto-go.

define button b-emissao 
     image-up file "igp/relatorio-up.gif" image-size 4 by 4
     label "Emissao" 
     size 4 BY 2.0 tooltip "Emissao"
     auto-go.

define button b-reemissao
     image-up file "igp/reimprime-up.gif" image-size 4 by 4
     label "Reemissao" 
     size 4 BY 2.0 tooltip "Reemissao"
     auto-go.

define button b-renovacao
     image-up file "igp/atualiza-up.gif" image-size 4 by 4
     label "Renovacao" 
     size 4 BY 2.0 tooltip "Renovacao"
     auto-go.

define button b-novavia
     image-up file "igp/inclui-up.gif" image-size 4 by 4
     label "Nova Via" 
     size 4 BY 2.0 tooltip "Nova Via"
     auto-go.
define button b-reembolso
     image-up file "igp/reajustar-up.gif" image-size 4 by 4
     label "&Reembolso" 
     size 4 BY 2.0 tooltip "Reembolso"
     auto-go.
     
define button b-gera-reembolso
     image-up file "igp/reajustar-up.gif" image-size 4 by 4
     label "&Gera Reembolso" 
     size 4 BY 2.0 tooltip "Gera Reembolso"
     auto-go.
     
define rectangle Retangulo-1
     edge-pixels 2 graphic-edge  
     size 78 BY 3
     no-fill.
     
     




 
 
/******************************************************************************
    Programa .....: hdregarquexe.i
    Data .........: 17/02/2004
    Sistema ......:
    Empresa ......: DZSET SOLUCOES E SISTEMAS
    Cliente ......:
    Programador ..: ANDREIA
    Objetivo .....:
*-----------------------------------------------------------------------------*
    Versao     DATA         RESPONSAVEL
               17/02/2004   ANDREIA
******************************************************************************/
/* ---------------------------------------------------- REGUAS PARA UNIX --- */
  def var tb-arquexe as char extent 3 initial ["Arquivo",
                                               "Executa",
                                               "Fim"]       no-undo.
  
/*****************************************************************************
*      Programa .....: hdregarquexe.f                                        *
*      Data .........: 17 de Fevereiro de 2004                               *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: HDP includes padraes                                  *
*      Programador ..: Andreia                                               *
*      Objetivo .....: Definicao de frames da regua executa                  *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*****************************************************************************/

/* --------------------------------------------------- FRAMES PARA UNIX --- */
form tb-arquexe[1] format "x(7)"
     tb-arquexe[2] format "x(7)"
     tb-arquexe[3] format "x(3)"
     with no-labels attr row 21 no-box overlay centered frame f-arquexe.
                
/* ----------------------------------------------- FRAMES PARA WINDOWS --- */                
DEFINE FRAME f-regua-arquexe
     b-arquivo   at row 1.48 col 32
     b-executa   at row 1.48 col 36
     b-fim       at row 1.48 col 58
     b-help      at row 1.48 col 62
     Retangulo-1 at row 1    col 2
     with 1 down no-box keep-tab-order overlay centered
         side-labels no-underline three-d 
         at col 1 row 1
         size 80 by 3.
  
   
/* include de variaveis dos display de tela dos relatorios */
/* hdp/hdvarrel.i */


def  var nm-cab-usuario           as char format "x(70)"                no-undo.
def  var nm-prog                  as char format "x(08)"                no-undo.
def  var nr-posicao               as integer                            no-undo.
def  var espacos                  as char format "x(80)"                no-undo.
def  var c-versao                 as char format "x(08)"                no-undo.
def  var ds-inicializa-aux        as char format "x(40)"                no-undo.
def  var ds-normal-ativa-aux      as char format "x(40)"                no-undo.
def  var ds-normal-desat-aux      as char format "x(40)"                no-undo.
def  var ds-negrit-ativa-aux      as char format "x(40)"                no-undo.
def  var ds-negrit-desat-aux      as char format "x(40)"                no-undo.
def  var ds-italic-ativa-aux      as char format "x(40)"                no-undo.
def  var ds-italic-desat-aux      as char format "x(40)"                no-undo.
def  var ds-expand-ativa-aux      as char format "x(40)"                no-undo.
def  var ds-expand-desli-aux      as char format "x(40)"                no-undo.
def  var ds-10cpp-ativa-aux       as char format "x(40)"                no-undo.
def  var ds-10cpp-desat-aux       as char format "x(40)"                no-undo.
def  var ds-15cpp-ativa-aux       as char format "x(40)"                no-undo.
def  var ds-15cpp-desat-aux       as char format "x(40)"                no-undo.
def  var ds-20cpp-ativa-aux       as char format "x(40)"                no-undo.
def  var ds-20cpp-desat-aux       as char format "x(40)"                no-undo.
def  var ds-format-folha-aux      as char format "x(40)"                no-undo.
def  var ds-linha-folha-aux       as char format "x(40)"                no-undo.
def  var ds-margem-aux            as char format "x(40)"                no-undo.
def  var ds-primei-linha-aux      as char format "x(40)"                no-undo.
def  var ds-mc-linha-ativa-aux    as char format "x(40)"                no-undo.
def  var ds-mc-linha-desat-aux    as char format "x(40)"                no-undo.
def  var ds-eq-margem-ativa-aux   as char format "x(40)"                no-undo.
def  var ds-eq-margem-desat-aux   as char format "x(40)"                no-undo.
def  var lg-ver-tela-aux          as logical initial no
                                     Format "Video/Arquivo"                no-undo.
def  var nm-arq-tela-quo          as char format "x(24)"                no-undo.
def  var ds-campo-imp-quo         as char format "x(132)"               no-undo.

def  var nm-arquivo-windows-aux   as character                          no-undo.
def  var nr-linhas-windows-aux    as int init 64  format "9999"         no-undo.
def  var nr-pagina-windows-aux    as integer                            no-undo.
def  var nr-fonte-windows-aux     as int init 1                         no-undo.
def  var lg-ok-imprime-windows-aux as logical                           no-undo.
def new global shared var v_cod_usuar_corren as character
        format "x(12)":U label "Usu rio Corrente"
        column-label "Usu rio Corrente"                                    no-undo.       
assign espacos = fill(" ",80).

 

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


 


def var lg-executa-aux              as log   format "Sim/Nao"              no-undo.
def var nr-reg-aux                  as dec                                 no-undo.
def var lg-erro-aux                 as log                                 no-undo.
def var ds-sit-ini-aux              as char                                no-undo.
def var ix                          as int                                 no-undo.
def var cd-esp-amb-aux              as int                                 no-undo.
def var cd-grupo-proc-amb-aux       as int                                 no-undo.
def var cd-procedimento-aux         as int                                 no-undo.
def var dv-procedimento-aux         as int                                 no-undo.
def var cd-modalidade-aux           like modalid.cd-modalidade             no-undo.
def var cd-plano-aux                as int                                 no-undo.
def var cd-tipo-plano-aux           as int                                 no-undo.
def var nr-ter-adesao-aux           like ter-ade.nr-ter-adesao             no-undo.
def var cd-usuario-aux              like usuario.cd-usuario                no-undo.
def var nr-indice-aux               like clashosp.nr-indice-hierarquico    no-undo.
def var cd-cla-hos-aux              like clashosp.cd-cla-hos               no-undo.
def var cd-vinculo-principal-aux    as int                                 no-undo.
def var cd-vinculo-solic-aux        as int                                 no-undo.
def var cd-tipo-insumo-aux          as int                                 no-undo.
def var cd-insumo-aux               as int                                 no-undo.
def var aa-guia-atendimento-aux     as int                                 no-undo.
def var nr-guia-atendimento-aux     as int                                 no-undo.
def var ds-observacao-aux           as char                                no-undo.
def var nr-guia-atend-ant-aux       as int                                 no-undo.
def var aa-guia-atend-ant-aux       as int                                 no-undo.
def var nr-processo-proc-aux        as int                                 no-undo.
def var nr-seq-digitacao-ins-aux    as int                                 no-undo.
def var id-face-dente-aux           as char                                no-undo.
def var lg-erro-vinculo-aux         as log                                 no-undo.
def var cd-vinculo-aux              as int                                 no-undo.
def var cd-unidade-prestador-aux    as int                                 no-undo.
def var cd-prestador-aux            as int                                 no-undo.
def var cd-esp-prest-executante-aux as int                                 no-undo.
def var in-tipo-guia-aux            as char                                no-undo.
def var nr-seq-guia-aux             as int                                 no-undo.
def var nr-seq-histor-aux           as int                                 no-undo.
def var cod-guia-unimed-intercam-aux as char                               no-undo.
def var lg-erro-guia-aux             as log                                no-undo.
def var lg-arquivo-aux               as log                                no-undo.
def var nr-guias-aux                 as dec format "99999999999"           no-undo.
def var ds-rodape                    as char format "x(132)"  init ""      no-undo.
def var ds-cabecalho                 as char format "x(30)"  initial ""    no-undo.
def var hand1                        as int                                no-undo.
DEF VAR cd-carteira-aux              AS DEC                                NO-UNDO.
DEF VAR cd-unidade-carteira-aux      AS INT                                NO-UNDO.
DEF VAR nr-carteira-aux              AS INT                                NO-UNDO.

def buffer b-import-guia for import-guia.

/* Temp que guarda o vinculo do prestador executante.
   Utilizada na criacao dos movimentos da guia */
def temp-table tmp-prest-exec no-undo
    field in-tipo-guia        as char /* Chave da guia */
    field val-seqcial         as dec  /* Chave da guia */
    field cd-unidade          as int
    field cd-prestador        as int
    field cd-espec            as int
    field cd-vinculo          as int
    field nm-prest-exec-compl as char
    field nm-conselho         as char
    field nr-registro         as int
    field uf-conselho         as char
    field cd-cbo              as char
    index tmp1
          in-tipo-guia
          val-seqcial.

def temp-table tmp-erro no-undo like erro-process-import.

form header
     fill("-", 132) format "x(132)"                  skip
     ds-cabecalho                                    at 01
     "Relatorio de Erros"                            at 45
     "Folha:" at 123 page-number   format ">>9"            skip
     fill("-",110)                 format "x(110)"
     today format "99/99/9999"                      at 112
     "-"                                            at 123
     string(time,"hh:mm:ss")                        at 125 skip(01)
     with stream-io no-labels no-box page-top frame f-cabecalho width 132.

form
    tmp-erro.num-seqcial-control column-label "Seq.Control."   format "999999999"
    tmp-erro.nom-tab-orig-erro   column-label "Tabela Origem"  format "x(20)" 
    tmp-erro.des-erro            column-label "Erro"           format "x(90)"
    with down stream-io no-box frame f-rel width 132.

form header ds-rodape format "x(131)"
            with stream-io no-labels no-box page-bottom frame f-rodape width 132.

nm-cab-usuario = "Migracao Guias de Autorizacao".
nm-prog        = " at0210a ".
c-versao       = c_prg_vrs.
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


 

/*******************************************************************************
** hdvararq.i - definicao de variaveis e form para abrir a saida
** {1}      - diretorio do arquivo
** {2}      - Nome do arquivo
** {3}      - extensao do arquivo
** {4}      - tipo da variavel
** {5}      - possui relatorio de erro? "1" = possui.
*******************************************************************************/

def  var l-saida       as logical format "Impressora/Arquivo" init yes.
def  var nm-diretorio  as char format "x(30)"
                          label "Nome do diretorio"  initial "c:/temp"     no-undo.
def  var nm-arquivo    as char format "x(20)"
                          label "     Nome arquivo"  initial "at0210a"     no-undo.
def  var nm-extensao   as char format "x(03)"
                          label "         Extensao" initial "ERR"      no-undo.
def  var nm-diretorio-old   as char  format "x(30)"                 no-undo.
def  var nm-arquivo-old     as char  format "x(20)"                 no-undo.
def  var nm-extensao-old    as char  format "x(03)"                 no-undo.
def  var c-saida       as character format "x(30)"                  no-undo.
def  var c-arquivo1    as character                                 no-undo.
def  var c-arquivo2    as character                                 no-undo.
def  var c-arquivo     as character extent 2 initial
                  [ "", "" ]                                           no-undo.
def  var nr-contador-aux   as int format  "9" initial 1             no-undo.
def  var nr-contador-fim   as int format "9" initial 1              no-undo.
def  var ds-titulo-imp     as char format "x(20)" initial "Saida"   no-undo.
def  var c-nome-imp    as character format "x(12)"
                          label "Nome da Impressora" init "default".
def  var l-xxxtmp      as logical                                   no-undo.
def  var c-yyytmp      as character                                 no-undo.
def  var l-resp        as log   no-undo format "S/N".
def  var l-letra       as char  format "x(01)"                      no-undo.
def var nm-programa-hdvararq-aux as char no-undo.
def var ds-param-hdpedarq-aux as char no-undo.
/*---------------------------------------------------------------------------*/

define temp-table disp-tela
       field ds-linha1 as char format "x(77)"
       field ds-linha2 as char format "x(77)".


define query zoom-tela for disp-tela scrolling.
define browse browse-disp-tela query zoom-tela no-lock
display disp-tela.ds-linha1 no-label
        disp-tela.ds-linha2 no-label
        with 2 down size 77 by 17.

define frame f-disp-tela
       browse-disp-tela at row 01 col 02
       "F1-Sair"        at row 18 col 02
       "-> p/Direita"   at row 18 col 16
       "<- p/Esquerda"  at row 18 col 35
       with row 03 column 01 size 80 by 21 overlay view-as dialog-box three-d
            title " RELATORIO EM VIDEO ".

on help, end-error of browse-disp-tela in frame f-disp-tela
do:
  return no-apply.
end.

on go of browse-disp-tela in frame f-disp-tela
do:
  close query zoom-tela.
  hide frame f-disp-tela.
end.

    
def  var in-saida-pdf as int init 2  view-as radio-set vertical
              radio-buttons "PDF", 1,
                            "Arquivo Texto", 2
                            size 22.5 by 3.67  no-undo.

 def  var in-saida as int init 1 view-as radio-set vertical
              radio-buttons "Impressora Windows", 1,
                            "Impressora Sistema", 2,
                            "Arquivo", 3
                            size 22.5 by 3.67 no-undo.

.

define  variable in-tela as integer 
     view-as radio-set vertical
     radio-buttons 
     "Arquivo", 1,
     "Video", 2 
     size 12.5 by 2.67 no-undo.


assign nm-programa-hdvararq-aux = program-name(1).


/* define impressora de acordo com o usuario ativo e o nome do programa */

assign c-yyytmp = substr(program-name(1), r-index(program-name(1), "/") + 1)
       c-yyytmp = substr(c-yyytmp, 1, length(c-yyytmp) - 2).

find dzuseimp where dzuseimp.nm-usuario-sistema = v_cod_usuar_corren
                and dzuseimp.nm-programa = c-yyytmp
                    no-lock no-error.

if not available dzuseimp
then find dzuseimp where dzuseimp.nm-usuario-sistema = v_cod_usuar_corren
                     and dzuseimp.nm-programa = "*"
                         no-lock no-error.

if available dzuseimp
then assign c-nome-imp = dzuseimp.nm-impressora.

if "" = "1"
then nr-contador-fim = 2.
else nr-contador-fim = 1.

assign nm-diretorio-old = nm-diretorio
       nm-arquivo-old   = nm-arquivo
       nm-extensao-old  = nm-extensao.
 

/* ------------------- PROCEDURE GRAVA-ERRO --------------------- */
/******************************************************************************
    Programa .....: at0210a.i
    Data .........: 18/05/2015
    Empresa ......: TOTVS
    Cliente ......: Unimed Joao Pessoa
    Programador ..: Jeferson Dal Molin
    Objetivo .....: Migracao das guias de autorizacao do Unicoo para o GPS
*-----------------------------------------------------------------------------*/

procedure grava-erro:

    def input parameter num-seqcial-control-par as integer no-undo.
    def input parameter nom-tab-orig-erro-par   as char    no-undo.
    def input parameter des-erro-par            as char    no-undo.
    def input parameter dat-erro-par            as date    no-undo.
    def input parameter des-ajuda-par           as char    no-undo.

    def var nr-seq-aux                          as int     no-undo.

    /* ------------------------------------------------------------------------- */
    select max(erro-process-import.num-seqcial) into nr-seq-aux 
           from erro-process-import 
           where erro-process-import.num-seqcial-control = num-seqcial-control-par.

    if nr-seq-aux = ?
    or nr-seq-aux = 0
    then assign nr-seq-aux = 1.
    else assign nr-seq-aux = nr-seq-aux + 1.

    validate erro-process-import.
    release erro-process-import.
    /* ------------------------------------------------------------------------- */

    create erro-process-import.
    assign erro-process-import.num-seqcial         = nr-seq-aux
           erro-process-import.num-seqcial-control = num-seqcial-control-par
           erro-process-import.nom-tab-orig-erro   = nom-tab-orig-erro-par
           erro-process-import.des-erro            = des-erro-par
           erro-process-import.dat-erro            = dat-erro-par
           erro-process-import.des-ajuda           = des-ajuda-par.

    create tmp-erro.
    assign tmp-erro.num-seqcial         = nr-seq-aux
           tmp-erro.num-seqcial-control = num-seqcial-control-par
           tmp-erro.nom-tab-orig-erro   = nom-tab-orig-erro-par
           tmp-erro.des-erro            = des-erro-par
           tmp-erro.dat-erro            = dat-erro-par
           tmp-erro.des-ajuda           = des-ajuda-par.

    validate erro-process-import.
    release erro-process-import.

    validate tmp-erro.
    release tmp-erro.

end procedure.
 

/* -------------------------------------------------------------- */
/******************************************************************************
*      Programa .....: rtapi022.i                                             *
*      Data .........: 03 de 12 de 1999                                       *
*      Sistema ......: Includes Padrao                                        *
*      Empresa ......: DZSET Solucoes e Sistemas                              *
*      Programador ..: Airton Nora                                            *
*      Objetivo .....: Include para a rotina rtapi022.p                       *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      D.00.000  03/12/1999  Nora           Desenvolvimento                   *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
******************************************************************************/

/* -------------------------------------- DEFINICAO DA TABELA TEMPORARIA --- */
define new shared temp-table tmp-rtapi022        no-undo
           fields cd-modalidade       like modalid.cd-modalidade
           fields nr-proposta         like propost.nr-proposta
           fields nr-ter-adesao       like ter-ade.nr-ter-adesao
           fields cd-usuario          like usuario.cd-usuario
           fields nm-usuario          like usuario.nm-usuario
           fields cd-plano            like pla-sau.cd-plano
           fields cd-tipo-plano       like ti-pl-sa.cd-tipo-plano
           fields cd-cla-hos          like ti-pl-sa.cd-cla-hos
           fields nr-indice-hierarq   like clashosp.nr-indice-hierarquico
           fields cd-unidade-carteira like moviproc.cd-unidade-carteira
           fields nm-unidade-carteira like unimed.nm-unimed-reduz
           fields cd-carteira-usuario like moviproc.cd-carteira-usuario
           fields nr-via-carteira     like docrecon.nr-via-carteira
           fields nr-digito-carteira  like car-ide.dv-carteira
           fields dt-val-carteira     like car-ide.dt-validade
           fields dt-can-carteira     like car-ide.dt-cancelamento
           fields cd-sit-carteira     like car-ide.cd-sit-carteira
           fields cd-carteira-antiga  like car-ide.cd-carteira-antiga
           fields in-tipo-localizacao as char format "x(06)".

/* ----------------------------------------------------- DEFINICAO ERROS --- */
define new shared temp-table tmp-mensa-rtapi022 no-undo
           field cd-mensagem-mens       like mensiste.cd-mensagem
           field ds-mensagem-mens       like mensiste.ds-mensagem-sistema
           field ds-complemento-mens    like mensiste.ds-mensagem-sistema
           field in-tipo-mensagem-mens  like mensiste.in-tipo-mensagem
           field ds-chave-mens          like mensiste.ds-mensagem-sistema.

/* ------------------------- PARAMETROS AUXILIARES COMPARTILHADOS NA API --- */
define new shared var in-funcao-rtapi022-aux    as char format "x(03)"        no-undo.
define new shared var lg-erro-rtapi022-aux      as log                        no-undo.
define new shared var lg-prim-mens-rtapi022-aux as log                        no-undo.

/* --------------------------- PARAMETROS COMPARTILHADOS INTERNAS DA API --- */
define new shared var cd-unid-pres-rtapi022-aux like preserv.cd-unidade       no-undo.
define new shared var lg-via-gp-rtapi022-aux    as log                        no-undo.
define new shared var cd-modal-gp-rtapi022-aux  like modalid.cd-modalidade    no-undo.
define new shared var nr-terad-gp-rtapi022-aux  like ter-ade.nr-ter-adesao    no-undo.
define new shared var cd-unid-cart-rtapi022-aux like moviproc.cd-unidade-carteira
                                                                       no-undo.
define new shared var cd-carteira-rtapi022-aux  like moviproc.cd-carteira-usuario
                                                                       no-undo.
define new shared var nr-via-cart-rtapi022-aux  like docrecon.nr-via-carteira no-undo.
define new shared var lg-benef-unid-rtapi022-aux as logical                   no-undo.
define new shared var dt-controle-rtapi022-aux  like guiautor.dt-emissao-guia no-undo.
define new shared var cod-prestador-principal-aux as Integer                  no-undo.
define new shared var lg-reembolso-rtapi022-aux  as logical                   no-undo.
/* ------------------------------------------------------------------------- */
  /* ----------------- CARTEIRA DO BENEFICIARIO --- */
/******************************************************************************
*      Programa .....: rtapi024.i                                             *
*      Data .........: 06 de dezembro de 1999                                 *
*      Sistema ......: Includes Padrao                                        *
*      Empresa ......: DZSET Solucoes e Sistemas                              *
*      Programador ..: Monia Regina Turella                                   *
*      Objetivo .....: Include para a rotina rtapi024.p                       *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      D.00.000  08/12/1999  Monia          Desenvolvimento                   *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
******************************************************************************/

/* -------------------------------------- DEFINICAO DA TABELA TEMPORARIA --- */
define new shared temp-table tmp-rtapi024         no-undo
           field cd-vinculo                like previesp.cd-vinculo
           field lg-ato-medico             like tipovinc.lg-trabalho
           index tmp-rtapi024
              is primary
                 cd-vinculo.

/* ----------------------------------------------------- DEFINICAO ERROS --- */
define new shared temp-table tmp-mensa-rtapi024    no-undo
           field cd-mensagem-mens       like mensiste.cd-mensagem
           field ds-mensagem-mens       like mensiste.ds-mensagem-sistema
           field ds-complemento-mens    like mensiste.ds-mensagem-sistema
           field in-tipo-mensagem-mens  like mensiste.in-tipo-mensagem
           field ds-chave-mens          like mensiste.ds-mensagem-sistema.

/* ------------------------- PARAMETROS AUXILIARES COMPARTILHADOS NA API --- */
define new shared var in-funcao-rtapi024-aux    as char format "x(03)"        no-undo.
define new shared var lg-erro-rtapi024-aux      as log                        no-undo.
define new shared var lg-prim-mens-rtapi024-aux as log                        no-undo.

/* --------------------------- PARAMETROS COMPARTILHADOS INTERNAS DA API --- */
define new shared var cd-unidade-rtapi024-aux   like unimed.cd-unimed        no-undo.
define new shared var cd-prestador-rtapi024-aux like preserv.cd-prestador    no-undo.
define new shared var cd-transacao-rtapi024-aux like tranrevi.cd-transacao   no-undo.
define new shared var in-vinculo-rtapi024-aux   as char                      no-undo.
define new shared var dt-realizacao-rtapi024-aux like moviproc.dt-realizacao no-undo.



  /* ------------------------ PRESTADOR VINCULO --- */
/******************************************************************************
*      Programa .....: rcapi023.i                                             *
*      Data .........: 13 de 03 de 2000                                       *
*      Sistema ......: Includes Padrao                                        *
*      Empresa ......: DZSET Solucoes e Sistemas                              *
*      Programador ..: Rodrigo Rodrigues                                      *
*      Objetivo .....: Include padrao com definicoes de tabelas para docretmp *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL         MOTIVO                       *
*      6.00.000  11/11/2002  Rodrigo Rodrigues   Desenvolvimento              *
*******************************************************************************/

/* -------------------------------------- DEFINICAO DA TABELA TEMPORARIA --- **/
define new shared temp-table tmp-out-uni   no-undo like out-uni.

/* ------------------------------------ DEFINICAO DA TABELA DE MENSAGENS --- **/
define new shared temp-table tmp-mensa-out-uni no-undo
           field cd-mensagem-mens       like mensiste.cd-mensagem
           field ds-mensagem-mens       like mensiste.ds-mensagem-sistema
           field ds-complemento-mens    like mensiste.ds-mensagem-sistema
           field in-tipo-mensagem-mens  like mensiste.in-tipo-mensagem
           field ds-chave-mens          like mensiste.ds-mensagem-sistema.

/* ------------------------- PARAMETROS AUXILIARES COMPARTILHADOS NA API --- */
define new shared var cd-unidade-rcapi025-aux       like out-uni.cd-unidade          no-undo.
define new shared var cd-carteira-rcapi025-aux      like out-uni.cd-carteira-usuario no-undo.
define new shared var in-funcao-rcapi025-aux        as char format "x(03)"            no-undo.
define new shared var lg-erro-rcapi025-aux          as log                            no-undo.
define new shared var lg-prim-mens-rcapi025-aux     as log                            no-undo.
  /* ----------------- ROTINA DA TABELA OUT-UNI --- */

find first paramecp no-lock no-error.

if not avail paramecp
then do:
       message "Parametros do sistema nao cadastrados."
           view-as alert-box title "Atencao!!!".
       return.
     end.

find unimed where unimed.cd-unimed = paramecp.cd-unimed no-lock no-error.

if available unimed
then assign ds-cabecalho   = unimed.nm-unimed.

find first paramrc no-lock no-error.

if not avail paramrc
then do:
       message "Parametros do modulo Revisao de Contas nao cadastrados."
           view-as alert-box title "Atencao!!!".
       return.
     end.

assign ds-rodape = " " + nm-prog + " - " + c-versao
       ds-rodape = fill("-", 132 - length(ds-rodape)) + ds-rodape.

/*****************************************************************************
*      Programa .....: hdtitrel.i                                            *
*      Data .........: 20 de Janeiro de 1997                                 *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: RT - Rotinas do Sistema                               *
*      Programador ..: Nora                                                  *
*      Objetivo .....: Titulos dos Relatorio dos programas DZSET             *
******************************************************************************
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*****************************************************************************/
def var nm-time  as char no-undo.
def var dt-today as date no-undo.
def var nm-traco as char initial "-" no-undo.
def var ds-linha2 as char format "x(75)" no-undo.
def var ds-linha2-aux as char format "x(75)" no-undo.
def var nm-cab-usu-rela as char format "x(75)" no-undo.
def image in-fundo file "igp/logodzre".
def rectangle r-relatorio-padrao 
      edge-pixels 3 graphic-edge no-fill size 78 by 17.
def rectangle r-retangulo-imagem 
      edge-pixels 5 graphic-edge no-fill size 55.1 by 9.2.

if "" <> ""
then do:
     find first cmovdata where
                cmovdata.in-entidade = ""
            and cmovdata.dt-inicio-excessao <= today
            and cmovdata.dt-fim-excessao    >= today
                no-lock no-error.
     if avail cmovdata
     then do:
          message "Movimentacao nao pode ser executada entre as datas de"
                  skip
                  string(cmovdata.dt-inicio-excessao,"99/99/9999")
                  " ate " string(cmovdata.dt-fim-excessao,"99/99/9999")
          view-as alert-box title " Atencao !!! ".
          return.
          end.
     end.

.



define frame windows-rela
  r-relatorio-padrao at row 1 col 1
  r-retangulo-imagem at row 2.5 col 12
  nm-cab-usu-rela view-as fill-in size 70 by 1.3 native at row 14 column 5 
  ds-linha2 view-as fill-in size 76 by 1.3 native at row 16 column 2 
  in-fundo at row 3 col 13
  with centered row 4 no-labels no-box three-d.

dt-today = today.
nm-time  = string(time,"HH:MM").

define rectangle rodhlire
       edge-pixels 1 graphic-edge no-fill
       size 80 by  .1 .

define frame
       rodapere rodhlire at row 1 col 1 with 1 down no-box
       keep-tab-order overlay no-hide no-labels no-underline three-d
       at col 1 row 20 size 80 by 1.

define frame linhare1
             nm-cab-usu-rela at row 1 col 1
             with 1 down overlay no-labels no-hide
             no-underline at col 1 row 15 centered bgcolor 15.

define frame linhare2
             ds-linha2
             with 1 down overlay no-labels no-hide no-underline no-box
             at col 1 row 18 centered bgcolor 15.

nr-posicao     = (70 - (length(nm-cab-usuario))) / 2.

assign nm-cab-usu-rela = substring(espacos,1,nr-posicao) + nm-cab-usuario.
       ds-linha2-aux   = string(dt-today,"99/99/9999") + " - " + nm-time 
                                + "  " + nm-prog + " - " + c-versao.

nr-posicao     = (75 - (length(ds-linha2-aux))) / 2.

assign ds-linha2 = substring(espacos,1,nr-posicao) + ds-linha2-aux.

if "MS-WINXP" = "TTY"
then view frame hdtitrela.
else do:
       pause 0.
       view frame windows-rela.
       display nm-cab-usu-rela
               ds-linha2 with frame windows-rela.
     end.

if "MS-WINXP" = "TTY"
then display substring(espacos,1,nr-posicao) + nm-cab-usuario +
             substring(espacos,1,nr-posicao) @ nm-cab-usuario
             with frame linhare1.

nr-posicao     = 19.
if "MS-WINXP" = "TTY"
then do:
       pause 0.
       display substring(espacos,1,nr-posicao) + string(dt-today,"99/99/9999") +
               " - " + nm-time + "  " + nm-prog + " - " + c-versao @ ds-linha2
               with frame linhare2.
       view frame rodapere.
     end.
pause 0.

status input "Entre dados ou pressione F4 para sair".
status default "Datasul Medical                F2 para ajuda".

 

assign lg-arquivo-aux  = no.
/* -------------------------- BLOCO PRINCIPAL ---------------------- */
repeat on endkey undo, next with frame f-at0210a:

    /*****************************************************************************
*      Programa .....: hdbotarquexe.i                                        *
*      Data .........: 17 de Fevereiro de 2004                               *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: Includes padroes                                      *
*      Programador ..: Andreia                                               *
*      Objetivo .....: Regua arquivo e executa                               *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*****************************************************************************/

 do:
        on choose of b-help in frame f-regua-arquexe
        do:
          c-opcao = replace(b-help:label in frame f-regua-arquexe,"&","").
          run rtp/rtexibehelp.p.
        end.

        on end-error of b-help in frame f-regua-arquexe
        do:
          return no-apply.
        end.
        
        on choose of b-fim in frame f-regua-arquexe
        do:
          c-opcao = replace(b-fim:label in frame f-regua-arquexe,"&","").
        end.
        
        on end-error of b-fim in frame f-regua-arquexe
        do:
          return no-apply.
        end.

        on choose of b-arquivo in frame f-regua-arquexe
        do:
          c-opcao = replace(b-arquivo:label in frame f-regua-arquexe,"&","").
        end.
        
        on end-error of b-arquivo in frame f-regua-arquexe
        do:
          return no-apply.
        end.

        on choose of b-executa in frame f-regua-arquexe
        do:
          c-opcao = replace(b-executa:label in frame f-regua-arquexe,"&","").
        end.
        
        on end-error of b-executa in frame f-regua-arquexe
        do:
          return no-apply.
        end.
        
        update b-arquivo b-executa b-fim b-help
               go-on("get" "put" "recall" "clear" "insert-mode")
               with frame f-regua-arquexe.
      end.

 

    if c-opcao = "Arquivo"
    then do:
           assign lg-arquivo-aux  = no.

           /**  parametro de entrada:                                                     **
**      &permissao - nome do campo que contem a lista de permissoes           **
**      &usuario   - nome do usuario que se deseja testar a permissao         **
**  parametro de saida:                                                       **
**      &tem-permissao - nome do campo que diz se tem ou permissao            **
**                                                                            **
** Acrescimo de teste na impressora escrava quando TTY colocado nome do userid**
*******************************************************************************/
/*define variable nome as character format  "x(50)"      no-undo.*/

assign ds-param-hdpedarq-aux = "".
                                
run rtp/rthdpedarq.p( input        c-opcao                    ,
                      input        ds-param-hdpedarq-aux      ,
                      input        nm-programa-hdvararq-aux   ,
                      input-output nm-cab-usuario             ,
                      input-output nm-prog                    ,
                      input-output nr-posicao                 ,
                      input-output espacos                    ,
                      input-output c-versao                   ,
                      input-output ds-inicializa-aux          ,
                      input-output ds-normal-ativa-aux        ,
                      input-output ds-normal-desat-aux        ,
                      input-output ds-negrit-ativa-aux        ,
                      input-output ds-negrit-desat-aux        ,
                      input-output ds-italic-ativa-aux        ,
                      input-output ds-italic-desat-aux        ,
                      input-output ds-expand-ativa-aux        ,
                      input-output ds-expand-desli-aux        ,
                      input-output ds-10cpp-ativa-aux         ,
                      input-output ds-10cpp-desat-aux         ,
                      input-output ds-15cpp-ativa-aux         ,
                      input-output ds-15cpp-desat-aux         ,
                      input-output ds-20cpp-ativa-aux         ,
                      input-output ds-20cpp-desat-aux         ,
                      input-output ds-format-folha-aux        ,
                      input-output ds-linha-folha-aux         ,
                      input-output ds-margem-aux              ,
                      input-output ds-primei-linha-aux        ,
                      input-output ds-mc-linha-ativa-aux      ,
                      input-output ds-mc-linha-desat-aux      ,
                      input-output ds-eq-margem-ativa-aux     ,
                      input-output ds-eq-margem-desat-aux     ,
                      input-output lg-ver-tela-aux            ,
                      input-output nm-arq-tela-quo            ,
                      input-output ds-campo-imp-quo           ,
                      input-output nm-arquivo-windows-aux     ,
                      input-output nr-linhas-windows-aux      ,
                      input-output nr-pagina-windows-aux      ,
                      input-output nr-fonte-windows-aux       ,
                      input-output lg-ok-imprime-windows-aux  ,
                      input-output l-saida                    ,
                      input-output nm-diretorio               ,
                      input-output nm-arquivo                 ,
                      input-output nm-extensao                ,
                      input-output nm-diretorio-old           ,
                      input-output nm-arquivo-old             ,
                      input-output nm-extensao-old            ,
                      input-output c-saida                    ,
                      input-output c-arquivo1                 ,
                      input-output c-arquivo2                 ,
                      input-output nr-contador-aux            ,
                      input-output nr-contador-fim            ,
                      input-output ds-titulo-imp              ,
                      input-output c-nome-imp                 ,
                      input-output l-xxxtmp                   ,
                      input-output c-yyytmp                   ,
                      input-output l-resp                     ,
                      input-output l-letra                    ,
                      input-output in-saida                   ,
                      input-output in-tela).            

assign c-arquivo[1] = c-arquivo1
       c-arquivo[2] = c-arquivo2.
    
/*------------------------- EOF ---------------------------------------------*/
 

           assign lg-arquivo-aux  = yes.
         end.

   if c-opcao = "Executa"
   then do:
          if not lg-arquivo-aux
          then do:
                 message "Voce deve passar pela opcao arquivo."
                     view-as alert-box title "Atencao !!!".
                 next.
               end.

          assign lg-executa-aux = no.

          select count(*) into nr-reg-aux
                 from import-guia
                 where import-guia.ind-sit-import = "RC". /* Recebido */
          
          message "Existem " nr-reg-aux " guias pendentes de migracao." skip
                  "Confirma a execucao?"
              view-as alert-box question buttons yes-no title "Atencao!!!" update lg-executa-aux.

          if not lg-executa-aux
          then undo, retry.

          message "Processando! Aguarde...".
          empty temp-table tmp-prest-exec.
          empty temp-table tmp-erro.

          assign nr-guias-aux = 0.

          /* ----------------------------------------------------------------------------- */
          for each import-guia where import-guia.ind-sit-import    = "RC" /* Recebido */
                                 and import-guia.num-seqcial-princ = 0 /* Considera primeiro as guias principais */
                                     no-lock:
              run importa-guias.

              if lg-erro-guia-aux
              then do:
                     assign lg-erro-aux = yes.

                     do transaction:
                         run atualiza-import-guia(input "ER", /* Erro */
                                                  input 0,
                                                  input 0,
                                                  input 0).
                     end.
                   end.
          end.

          for each import-guia where import-guia.ind-sit-import    = "RC" /* Recebido */
                                 and import-guia.num-seqcial-princ > 0 /* Considera as guias associadas */
                                     no-lock:
              run importa-guias.

              if lg-erro-guia-aux
              then do:
                     assign lg-erro-aux = yes.

                     do transaction:
                         run atualiza-import-guia(input "ER", /* Erro */
                                                  input 0,
                                                  input 0,
                                                  input 0).
                     end.
                   end.
          end.
          /* ----------------------------------------------------------------------------- */

          hide message no-pause.

          if can-find(first tmp-erro)
          then run gera-rel-erro.

          if can-find(first tmp-erro)
          then message "Processo concluido com erros. Verifique o relatorio de erros." skip
                       "Numero de guias criadas: " nr-guias-aux
                  view-as alert-box info buttons ok.
          else message "Processo concluido." skip
                       "Numero de guias criadas: " nr-guias-aux
                  view-as alert-box info buttons ok.
   end.

   if c-opcao = "Fim"
   then do:
          hide all no-pause.
          leave.
        end.
end.
/* ----------------------------------------------------------------- */

/* ----------------------------------------------------------------- */
procedure importa-guias:

    run zera-vaiaveis-auxiliares.

    run consiste-dados-gerais(output lg-erro-guia-aux).

    if lg-erro-guia-aux
    then return.

    /* ----------------------- VALIDA DADOS TISS ---------------------------- */
    case trim(import-guia.ind-tip-guia):
        when "C" /* Consulta */
        then run valida-consulta(input-output lg-erro-guia-aux).

        when "S" /* SADT */
        then run valida-sp-sadt(input-output lg-erro-guia-aux).

        when "I" /* Internacao */
        then run valida-internacao(input-output lg-erro-guia-aux).

        when "P" /* Prorrogacao */
        then run valida-prorrogacao(input-output lg-erro-guia-aux).

        when "O" /* Odontologia */
        then run valida-odontologia(input-output lg-erro-guia-aux).
    end case.

    if lg-erro-guia-aux
    then return.

    /* --------------------- VALIDA ANEXOS CLINICOS TISS ----------------- */
    for each import-anexo-solicit 
       where import-anexo-solicit.num-seq-import = import-guia.num-seqcial
             no-lock:

        run valida-dados-gerais-anexos(input-output lg-erro-guia-aux).

        case trim(import-anexo-solicit.ind-tip-anexo):
            when "1" /* Quimioterapia */
            then run valida-quimioterapia(input-output lg-erro-guia-aux).

            when "2" /* Radioterapia */
            then run valida-radioterapia(input-output lg-erro-guia-aux).

            when "3" /* OPME */
            then run valida-opme(input-output lg-erro-guia-aux).

            when "4" /* Odontologia */
            then run valida-anexo-odonto(input-output lg-erro-guia-aux).
        end case.

        if lg-erro-guia-aux
        then next.
    end. /* each import-anexo-solicit */

    if lg-erro-guia-aux
    then return.

    do transaction:
        run cria-guia.
    end.

    do transaction:
        run atualiza-import-guia(input "IT", /* Integrado */
                                 input paramecp.cd-unimed,
                                 input aa-guia-atendimento-aux,
                                 input nr-guia-atendimento-aux).
    end.

    assign nr-guias-aux = nr-guias-aux + 1.

end procedure.


/* ----------------------------------------------------------------- */
procedure zera-vaiaveis-auxiliares:

    assign cd-modalidade-aux        = 0
           nr-ter-adesao-aux        = 0
           cd-usuario-aux           = 0
           nr-indice-aux            = 0
           cd-cla-hos-aux           = 0
           cd-vinculo-principal-aux = 0
           cd-vinculo-solic-aux     = 0
           aa-guia-atend-ant-aux    = 0
           nr-guia-atend-ant-aux    = 0
           cd-plano-aux             = 0
           cd-tipo-plano-aux        = 0
           lg-erro-guia-aux         = no.

end procedure.

/* ----------------------------------------------------------------- */
procedure cria-guia:

    run gera-seq-guia.

    assign cd-unidade-prestador-aux    = 0
           cd-prestador-aux            = 0
           cd-esp-prest-executante-aux = 0
           cd-vinculo-aux              = 0
           nr-processo-proc-aux        = 1
           nr-seq-digitacao-ins-aux    = 1.

    /* ---------------- Preenche prestador executante --------------------- */
    case trim(import-guia.ind-tip-guia):
        when "C" /* Consulta */
        then assign in-tipo-guia-aux = "CONS"
                    nr-seq-guia-aux  = import-guia-con.num-seqcial-guia.

        when "S" /* SADT */
        then assign in-tipo-guia-aux = "SADT"
                    nr-seq-guia-aux  = import-guia-sadt.val-seqcial.

        when "I" /* Internacao */
        then assign in-tipo-guia-aux = "INTE"
                    nr-seq-guia-aux  = import-guia-intrcao.num-seqcial-guia.
        
        when "P" /* Prorrogacao */
        then assign in-tipo-guia-aux = "PROR"
                    nr-seq-guia-aux  = import-guia-prorrog.num-seqcial-guia.
        
        when "O" /* Odontologia */
        then assign in-tipo-guia-aux = "ODON"
                    nr-seq-guia-aux  = import-guia-odonto.num-seqcial-guia.
    end case.

    find tmp-prest-exec where tmp-prest-exec.in-tipo-guia = in-tipo-guia-aux
                          and tmp-prest-exec.val-seqcial  = nr-seq-guia-aux 
                              no-lock no-error.

    if avail tmp-prest-exec
    then assign cd-unidade-prestador-aux    = tmp-prest-exec.cd-unidade
                cd-prestador-aux            = tmp-prest-exec.cd-prestador
                cd-esp-prest-executante-aux = tmp-prest-exec.cd-espec
                cd-vinculo-aux              = tmp-prest-exec.cd-vinculo.
    /* -------------------------------------------------------------------- */

    assign ds-observacao-aux = "Numero autorizacao Unicoo: "
                             + import-guia.cod-guia-operdra
                             + chr(10)
                             + fill("-",68)
                             + chr(10)
                             + import-guia.des-obs.

    create guiautor.
    assign guiautor.cd-userid-auditor        = ""                                                     
           guiautor.cd-unidade               = paramecp.cd-unimed                                     
           guiautor.aa-guia-atendimento      = aa-guia-atendimento-aux                                
           guiautor.nr-guia-atendimento      = nr-guia-atendimento-aux                                
           guiautor.lg-guia-principal[1]     = (if import-guia.num-seqcial-princ = 0                  
                                                then yes                                              
                                                else no)                                              
           guiautor.cd-tipo-guia             = import-guia.cd-tipo-guia                               
           guiautor.cd-transacao             = import-guia.cd-transacao                               
           guiautor.dt-emissao-guia          = import-guia.dat-solicit                                
           guiautor.dt-emissao               = import-guia.dat-solicit                                
           guiautor.cd-unidade-carteira      = cd-unidade-carteira-aux                        
           guiautor.cd-carteira-usuario      = cd-carteira-aux                        
           guiautor.nr-via-carteira          = nr-carteira-aux
           guiautor.cd-unidade-solicitante   = import-guia.cd-unidade-solic                           
           guiautor.cd-prestador-solicitante = int(import-guia.cd-prestador-solic)                        
           guiautor.cd-vinculo-solicitante   = cd-vinculo-solic-aux                                   
           guiautor.cd-especialid            = import-guia.cd-especialid                              
           guiautor.cd-cla-hos               = cd-cla-hos-aux                                         
           guiautor.cd-unidade-principal     = import-guia.cd-unidade-principal                       
           guiautor.cd-prestador-principal   = import-guia.cd-prestador-principal                     
           guiautor.cd-vinculo-principal     = cd-vinculo-principal-aux                               
           guiautor.dt-cancel-guia           = ?                                                      
           guiautor.cd-unidade-clinica       = paramecp.cd-unimed                                     
           guiautor.cd-clinica               = import-guia.cd-clinica                                 
           guiautor.dt-atualizacao           = today                                                  
           guiautor.cd-userid                = v_cod_usuar_corren                                     
           guiautor.ds-observacao            = ds-observacao-aux                                      
           guiautor.ds-observacao-interna    = ""                                                     
           guiautor.lg-via-orcamento         = no                                                     
           guiautor.log-12                   = no /* Via Reembolso? */                                
           guiautor.aa-guia-atendimento-ant  = aa-guia-atend-ant-aux                                  
           guiautor.nr-guia-atendimento-ant  = nr-guia-atend-ant-aux                                  
           guiautor.char-21                  = paramrc.char-25 /* Versao TISS */                      
           guiautor.nm-prof-sol              = trim(import-guia.nom-prestdor-solic)                   
           guiautor.char-14                  = trim(import-guia.cod-cons-profis)                      
           guiautor.char-17                  = trim(import-guia.ind-nume-cons)                        
           guiautor.char-18                  = caps(import-guia.uf-conselho)                          
           guiautor.char-19                  = trim(string(import-guia.cdn-cbo))                      
           guiautor.cd-modalidade            = cd-modalidade-aux                                      
           guiautor.nr-ter-adesao            = nr-ter-adesao-aux                                      
           guiautor.cd-usuario               = cd-usuario-aux                                         
           guiautor.in-liberado-guias        = import-guia.ind-sit-guia                               
           guiautor.nm-grupo-usuario         = import-guia.cod-livre-1                                
           guiautor.nm-grupo                 = import-guia.cod-livre-3                                
           guiautor.cd-local-autorizacao     = import-guia.num-livre-1
           guiautor.u-int-1                  = import-guia.num-seqcial.

    /* Informacoes Intercambio Eletronico */
    if import-guia.log-intercam-eletron
    then do:
           assign guiautor.ds-mens-intercambio = trim(import-guia.des-intercam)
                  guiautor.int-11              = 5. /* Procedencia SCS */

           if import-guia.cd-unidade-carteira = paramecp.cd-unimed
           then do:
                  assign guiautor.in-envio-intercambio = "EnvioOrigem".

                  /* --------------------- GUIA SOLIC -------------------------------------- */
                  find first unimed where unimed.cd-unimed = import-guia.cd-unidade-carteira no-lock no-error.

                  IF import-guia.cod-guia-unimed-intercam = ""
                  THEN assign guiautor.aa-guia-atend-solic = 0
                              guiautor.nr-guia-atend-solic = 0.
                  ELSE DO:
                         if   avail unimed
                         and  unimed.lg-tem-serious 
                         then assign guiautor.aa-guia-atend-solic = int(substring(string(year(today)),1,2)
                                                                  + substring(import-guia.cod-guia-unimed-intercam,1,2))
                                     guiautor.nr-guia-atend-solic = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).
                         else do:
                                if length(trim(import-guia.cod-guia-unimed-intercam)) > 8
                                then do:
                                       if length(trim(import-guia.cod-guia-unimed-intercam)) > 9
                                       then assign guiautor.aa-guia-atend-solic = int("00" + substring(import-guia.cod-guia-unimed-intercam,1,2))
                                                   guiautor.nr-guia-atend-solic = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).
                                       else assign guiautor.aa-guia-atend-solic = int("000" + substring(import-guia.cod-guia-unimed-intercam,1,1))
                                                   guiautor.nr-guia-atend-solic = int(substring(import-guia.cod-guia-unimed-intercam,2,8)).
                                     end.
                                else assign guiautor.aa-guia-atend-solic = 0
                                            guiautor.nr-guia-atend-solic = int(string(import-guia.cod-guia-unimed-intercam)).
                              end.
                       END.
                end.
           else do:
                  assign guiautor.in-receb-intercambio = "RecebidoDestino".

                  find first unimed where unimed.cd-unimed = cd-unidade-prestador-aux no-lock no-error.

                  if   avail unimed
                  and  unimed.lg-tem-serious
                  then assign guiautor.aa-guia-atend-origem = int(substring(string(year(today)), 1, 2) + substring(import-guia.cod-guia-unimed-intercam,39,02))
                              guiautor.nr-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,41,08)).
                  else assign guiautor.aa-guia-atend-origem = int("00" + substring(import-guia.cod-guia-unimed-intercam,1,2))
                              guiautor.nr-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).

                  ASSIGN guiautor.aa-guia-atend-solic = 0
                         guiautor.nr-guia-atend-solic = 0.
                end.
         end.

    create guia-autoriz-comp.
    assign guia-autoriz-comp.cdn-unid             = paramecp.cd-unimed
           guia-autoriz-comp.num-ano-guia-atendim = aa-guia-atendimento-aux
           guia-autoriz-comp.num-guia-atendim     = nr-guia-atendimento-aux
           guia-autoriz-comp.log-atendim-rn       = import-guia.log-atendim-rn.

    case trim(import-guia.ind-tip-guia):
        when "C" /* Consulta */
        then do:
               assign guiautor.in-acidente    = int(import-guia-con.in-acidente)
                      guiautor.int-30         = int(import-guia-con.ind-tip-con) /* Tipo de Consulta */
                      guiautor.in-classe-nota = 01.

               run cria-movimentos(input "CONS",
                                   input import-guia-con.num-seqcial-guia).
             end.

        when "S" /* SADT */
        then do:
               assign guiautor.cr-solicitacao = trim(import-guia-sadt.ind-carac-solicit)
                      guiautor.ds-ind-clinica = trim(import-guia-sadt.des-indic-clinic)
                      guiautor.int-18         = int(import-guia-sadt.ind-tip-atendim)
                      guiautor.int-30         = int(import-guia-sadt.ind-tip-con)
                      guiautor.in-acidente    = int(import-guia-sadt.ind-tip-acid)
                      guiautor.in-classe-nota = 02.

               run cria-movimentos(input "SADT",
                                   input import-guia-sadt.val-seqcial).
             end.

        when "I" /* Internacao */
        then do:
               assign guiautor.int-5                      = int(import-guia-intrcao.cod-regim-intrcao)
                      guiautor.in-acidente                = int(import-guia-intrcao.idi-acid)
                      guiautor.cr-internacao              = trim(import-guia-intrcao.cod-caract-atendim)
                      guia-autoriz-comp.dat-suger-intrcao = import-guia-intrcao.dt-internacao
                      guia-autoriz-comp.log-prev-opme     = import-guia-intrcao.log-opme
                      guia-autoriz-comp.log-prev-qui      = import-guia-intrcao.log-quimio
                      guiautor.ds-ind-clinica             = trim(import-guia-intrcao.des-indcao-clinic)
                      guiautor.tp-inter                   = int(import-guia-intrcao.cdn-tip-inter)
                      guiautor.cd-cid                     = (if  import-guia-intrcao.cod-cid-princ <> ?
                                                             and import-guia-intrcao.cod-cid-princ <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-princ))
                                                             else "")
                      guiautor.cd-cid1                    = (if  import-guia-intrcao.cod-cid-2 <> ?
                                                             and import-guia-intrcao.cod-cid-2 <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-2))
                                                             else "")
                      guiautor.cd-cid2                    = (if  import-guia-intrcao.cod-cid-3 <> ?
                                                             and import-guia-intrcao.cod-cid-3 <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-3))
                                                             else "")
                      guiautor.cd-cid3                    = (if import-guia-intrcao.cod-cid-4 <> ?
                                                             and import-guia-intrcao.cod-cid-4 <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-4))
                                                             else "").

               case int(import-guia-intrcao.cdn-tip-inter):
                   when 1 then guiautor.in-classe-nota = 4.  /* Clinica */
                   when 2 then guiautor.in-classe-nota = 5.  /* Cirurgica */
                   when 3 then guiautor.in-classe-nota = 6.  /* Obstetrica */
                   when 4 then guiautor.in-classe-nota = 11. /* Pediatrica */
                   when 5 then guiautor.in-classe-nota = 12. /* Psiquiatrica */
               end case.

               run cria-movimentos(input "INTE",
                                   input import-guia-intrcao.num-seqcial-guia).
             end.

        when "P" /* Prorrogacao */
        then do:
               assign guiautor.in-classe-nota               = 26
                      guia-autoriz-comp.cdn-acomoda-solicit = int(trim(import-guia-prorrog.ind-tip-acomoda-solicitad))
                      guiautor.ds-ind-clinica               = trim(import-guia-prorrog.des-indic-clinic).

               run cria-movimentos(input "PROR",
                                   input import-guia-prorrog.num-seqcial-guia).
             end.

        when "O" /* Odontologia */
        then do:
               assign guiautor.in-classe-nota        = 7                                      
                      guiautor.dt-termino-tratamento = import-guia-odonto.dat-term-tratam     
                      guiautor.tp-atend              = int(import-guia-odonto.ind-tip-atendim)
                      guiautor.cd-faturamento        = trim(import-guia-odonto.ind-tip-faturam).

               run cria-movimentos(input "ODON",
                                   input import-guia-odonto.num-seqcial-guia).
             end.
    end case.

    /* ------------------ CRIA ANEXOS CLINICOS TISS ------------- */
    assign guia-autoriz-comp.cod-livre-10     = ""
           guia-autoriz-comp.des-cipa-his     = ""
           guia-autoriz-comp.des-inf-re       = ""
           guia-autoriz-comp.des-cirurgia-ant = "".

    for each import-anexo-solicit
       where import-anexo-solicit.num-seq-import = import-guia.num-seqcial
             no-lock:
        
        assign guia-autoriz-comp.cod-telef-solic = import-anexo-solicit.nr-telefone
               guia-autoriz-comp.nom-email-solic = import-anexo-solicit.nom-email.

        case trim(import-anexo-solicit.ind-tip-anexo):
            when "1" /* Quimioterapia */
            then do:
                   find import-anexo-quimio where import-anexo-quimio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                  no-lock no-error.

                   if avail import-anexo-quimio
                   then assign guia-autoriz-comp.val-peso-bnfciar               = import-anexo-quimio.val-peso-bnfciar
                               guia-autoriz-comp.val-alt-bnfciar                = import-anexo-quimio.val-alt-bnfciar
                               guia-autoriz-comp.val-sup-cor-bnfciar            = import-anexo-quimio.val-sup-cor-bnfciar
                               guia-autoriz-comp.cdn-tip-qui                    = int(import-anexo-quimio.ind-tip-quimio)
                               guia-autoriz-comp.dat-diag                       = import-anexo-quimio.dat-diag
                               guia-autoriz-comp.cdn-estad                      = int(import-anexo-quimio.cod-estag)
                               guia-autoriz-comp.cdn-finalid-tratam             = int(import-anexo-quimio.ind-finalid-tratam)
                               guia-autoriz-comp.cdn-ecf                        = int(import-anexo-quimio.cod-classif-capac-funcnal)
                               guia-autoriz-comp.num-ciclo-previs               = import-anexo-quimio.num-ciclo
                               guia-autoriz-comp.num-ciclo-atual                = import-anexo-quimio.num-ciclo-atual
                               guia-autoriz-comp.num-interv-ciclo               = import-anexo-quimio.num-interv-ciclo
                               guia-autoriz-comp.des-plano-terap                = trim(import-anexo-quimio.des-plano-terap)
                                           substr(guia-autoriz-comp.cod-livre-10,1001,1000) = string(trim(import-anexo-solicit.cod-livre-10),"x(1000)") /* Observacoes */
                                           substr(guia-autoriz-comp.des-cipa-his,1,1000)    = string(trim(import-anexo-quimio.des-diag),"x(1000)")
                               substr(guia-autoriz-comp.des-inf-re,1,1000)      = string(trim(import-anexo-quimio.des-inform),"x(1000)")
                               substr(guia-autoriz-comp.des-cirurgia-ant,1,40)  = string(trim(import-anexo-quimio.des-cirurgia-ant),"x(40)")
                               guia-autoriz-comp.dat-realiz-cirurgia            = import-anexo-quimio.dt-realizacao
                               guia-autoriz-comp.des-area                       = trim(import-anexo-quimio.des-area)
                               guia-autoriz-comp.dat-aplic-radio                = import-anexo-quimio.dat-aplic-radio
                               guia-autoriz-comp.cod-livre-1                    = import-anexo-quimio.cod-cid-princ + ";"
                                                                                + import-anexo-quimio.cod-cid-2 + ";"
                                                                                + import-anexo-quimio.cod-cid-3 + ";"
                                                                                + import-anexo-quimio.cod-cid-4  
                               guia-autoriz-comp.cod-livre-6                    = trim(import-anexo-quimio.cod-livre-1) + ";" /* Nome do profissional solicitante */ 
                                                                                + trim(import-anexo-quimio.cod-livre-3) + ";" /* Telefone Profissional Solicitante */
                                                                                + trim(import-anexo-quimio.cod-livre-4).      /* Email profissional solicitante */   

                   run cria-movimentos(input "QUIM",
                                       input import-anexo-quimio.num-seqcial).
                 end.

            when "2" /* Radioterapia */
            then do:
                   find import-anexo-radio where import-anexo-radio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                 no-lock no-error.

                   if avail import-anexo-radio
                   then assign guia-autoriz-comp.num-campo                      = import-anexo-radio.qti-campos
                               guia-autoriz-comp.num-dosag-dia                  = import-anexo-radio.qtd-dosag-diaria
                               guia-autoriz-comp.num-dosag-tot                  = import-anexo-radio.qtd-dosag-tot
                               guia-autoriz-comp.num-dia-previs                 = import-anexo-radio.num-dias
                               guia-autoriz-comp.dat-previs-inic                = import-anexo-radio.dat-inic-adm
                               guia-autoriz-comp.dat-livre-1                    = import-anexo-radio.dat-diag /* Data do diagnostico */
                               guia-autoriz-comp.num-livre-1                    = int(import-anexo-radio.cod-estag)
                               guia-autoriz-comp.num-livre-3                    = int(import-anexo-radio.ind-finalid-tratam)
                               guia-autoriz-comp.cdn-diag-img                   = int(import-anexo-radio.cdn-diag-img)
                               guia-autoriz-comp.num-livre-2                    = int(import-anexo-radio.cod-classif-capac-funcnal)
                               guia-autoriz-comp.cod-livre-2                    = import-anexo-radio.cod-cid-princ + ";"
                                                                                + import-anexo-radio.cod-cid-2 + ";"
                                                                                + import-anexo-radio.cod-cid-3 + ";"
                                                                                + import-anexo-radio.cod-cid-4
                                           substr(guia-autoriz-comp.cod-livre-10,2001,1000) = string(trim(import-anexo-solicit.cod-livre-10),"x(1000)") /* Observacoes */
                                           substr(guia-autoriz-comp.des-cipa-his,1001,1000) = string(trim(import-anexo-radio.des-diag),"x(1000)")
                               substr(guia-autoriz-comp.des-inf-re,1001,1000)   = string(trim(import-anexo-radio.des-inform),"x(1000)")
                               substr(guia-autoriz-comp.des-cirurgia-ant,41,40) = string(trim(import-anexo-radio.des-cirurgia-ant),"x(40)")
                               guia-autoriz-comp.dat-livre-2                    = import-anexo-radio.dat-realiz
                               guia-autoriz-comp.des-qui                        = trim(import-anexo-radio.des-quimio)
                               guia-autoriz-comp.dat-aplic-qui                  = import-anexo-radio.dat-aplic
                               guia-autoriz-comp.cod-livre-7                    = trim(import-anexo-radio.cod-livre-1) + ";" /* Nome do profissional solicitante */
                                                                                + trim(import-anexo-radio.cod-livre-3) + ";" /* Telefone Profissional Solicitante */
                                                                                + trim(import-anexo-radio.cod-livre-4).      /* Email profissional solicitante */

                   run cria-movimentos(input "RADI",
                                       input import-anexo-radio.num-seqcial).
                 end.

            when "3" /* OPME */
            then do:
                   find import-anexo-opme where import-anexo-opme.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                no-lock no-error.

                   if avail import-anexo-opme
                   then assign guia-autoriz-comp.des-justif-tec                 = trim(import-anexo-opme.des-justificativa)      /* JUSTFICATIVA TECNICA  */
                               guia-autoriz-comp.des-espcif-mater               = trim(import-anexo-opme.des-especif-mater) /* ESPECIFICACAO MATERIAL */
                               guia-autoriz-comp.cod-livre-8                    = trim(import-anexo-opme.cod-livre-1) + ";" /* Nome do profissional solicitante */
                                                                                + trim(import-anexo-opme.cod-livre-3) + ";" /* Telefone Profissional Solicitante */
                                                                                + trim(import-anexo-opme.cod-livre-4)       /* Email profissional solicitante */
                               substr(guia-autoriz-comp.cod-livre-10,3001,1000) = string(trim(import-anexo-solicit.cod-livre-10),"x(1000)") /* Observacoes */.

                   run cria-movimentos(input "OPME",
                                       input import-anexo-opme.num-seqcial).
                 end.

            when "4" /* Odontologia */
            then do:
                   find import-anexo-odonto where import-anexo-odonto.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                  no-lock no-error.
                  
                   if avail import-anexo-odonto
                   then do:
                          create guiainod.
                          assign guiainod.cd-unidade                = paramecp.cd-unimed     
                                 guiainod.aa-guia-atendimento       = aa-guia-atendimento-aux
                                 guiainod.nr-guia-atendimento       = nr-guia-atendimento-aux
                                 guiainod.nr-sequencia              = 0
                                 guiainod.lg-doencas-periodontais   = import-anexo-odonto.log-doenc-periodts
                                 guiainod.lg-altera-tecidos-moles   = import-anexo-odonto.log-alter-tecidos-moles
                                 guiainod.dt-registro               = today
                                 guiainod.ds-observacao             = import-anexo-odonto.des-observacao
                                 guiainod.cd-userid                 = v_cod_usuar_corren
                                 guiainod.dt-atualizacao            = today.

                          if  import-anexo-odonto.cod-livre-6 <> ? 
                          and import-anexo-odonto.cod-livre-6 <> ""
                          then assign guiainod.nm-prest-exec-compl       = entry(1, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.char-2                    = entry(2, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.nr-conse-prest-exec-compl = entry(3, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.uf-conse-prest-exec-compl = entry(4, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.char-1                    = entry(5, import-anexo-odonto.cod-livre-6, ";").
                          
                          for each import-anexo-odonto-mov
                             where import-anexo-odonto-mov.num-seqcial-anexo = import-anexo-odonto.num-seqcial
                                   no-lock:
                              if import-anexo-odonto-mov.tp-dente-regiao <> ""
                              then assign guiainod.ds-situacao-inicial [int(import-anexo-odonto-mov.tp-dente-regiao)] = trim(import-anexo-odonto-mov.ind-sit-inicial).
                          end. /* each import-anexo-odonto-mov */

                          validate guiainod.
                          release guiainod.
                        end.
                 end.
        end case.
    end. /* each import-anexo-solicit */

 

    /* ----------------- GRAVA HISTORICO DA GUIA ------------------------ */
    assign nr-seq-histor-aux = 1.

    for each import-guia-histor
       where import-guia-histor.val-seq-guia = import-guia.num-seqcial
             no-lock:

        create guia-his.
        assign guia-his.cd-unidade          = paramecp.cd-unimed
               guia-his.aa-guia-atendimento = aa-guia-atendimento-aux
               guia-his.nr-guia-atendimento = nr-guia-atendimento-aux
               guia-his.nr-sequencia-alt    = nr-seq-histor-aux
               guia-his.in-lib-guias-alt    = guiautor.in-liberado-guias
               guia-his.cd-userid-alt       = import-guia-histor.cd-userid-alt
               guia-his.dt-alt              = import-guia-histor.dt-alt
               guia-his.cd-userid           = v_cod_usuar_corren
               guia-his.dt-atualizacao      = today
               guia-his.char-4              = "at0210a".

        validate guia-his.
        release guia-his.

        assign nr-seq-histor-aux = nr-seq-histor-aux + 1.
    end. /* each import-guia-histor */

    validate guiautor.
    release guiautor.

    validate guia-autoriz-comp.
    release guia-autoriz-comp.



    /* ----------------------------------------------------------------- */

end procedure.

/* ----------------------------------------------------------------- */
procedure cria-movimentos:

    def input parameter in-tipo-guia-par as char format "x(4)" no-undo.
    def input parameter val-seq-guia-par as int                no-undo.

    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = in-tipo-guia-par
         and import-guia-movto.val-seq-guia = val-seq-guia-par
             no-lock:

        if import-guia-movto.ind-tip-movto-guia = "P" /* Procedimento */
        then do:
               create procguia.
               assign procguia.cd-unidade              = paramecp.cd-unimed
                      procguia.aa-guia-atendimento     = aa-guia-atendimento-aux
                      procguia.nr-guia-atendimento     = nr-guia-atendimento-aux
                      procguia.nr-processo             = nr-processo-proc-aux
                      procguia.nr-seq-digitacao        = 0
                      procguia.cd-esp-amb              = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2))
                      procguia.cd-grupo-proc-amb       = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2))
                      procguia.cd-procedimento         = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3))
                      procguia.dv-procedimento         = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1))
                      procguia.cd-modulo               = import-guia-movto.cd-modulo
                      procguia.qt-procedimento         = import-guia-movto.qtd-autoriza
                      procguia.int-11                  = import-guia-movto.qtd-solicitad
                      procguia.in-nivel-prestador      = 01
                      procguia.dt-atualizacao          = today
                      procguia.dt-realizacao           = today
                      procguia.hr-realizacao           = substring(string(time,"HH:MM"),1,2) + substring(string(time,"HH:MM"),4,2)
                      procguia.cd-modalidade           = cd-modalidade-aux 
                      procguia.cd-usuario              = nr-ter-adesao-aux
                      procguia.nr-ter-adesao           = cd-usuario-aux
                      procguia.cd-clinica              = import-guia.cd-clinica
                      procguia.cd-unidade-clinica      = paramecp.cd-unimed
                      procguia.cd-unidade-prestador    = cd-unidade-prestador-aux
                      procguia.cd-prestador            = cd-prestador-aux
                      procguia.cd-esp-prest-executante = cd-esp-prest-executante-aux
                      procguia.cd-tipo-vinculo         = cd-vinculo-aux
                      procguia.cd-validacao            = import-guia-movto.cd-validacao
                      procguia.cd-tipo-cob             = import-guia-movto.num-livre-3 /* Validacao para cobranca */
                      procguia.cd-tipo-pagamento       = import-guia-movto.num-livre-4 /* Validacao para pagamento */
                      procguia.cd-classe-erro          = import-guia-movto.num-livre-2
                      procguia.cd-cod-glo              = import-guia-movto.num-livre-1
                      procguia.cd-userid               = v_cod_usuar_corren
                      procguia.nm-prest-exec-compl     = tmp-prest-exec.nm-prest-exec-compl
                      procguia.char-3                  = tmp-prest-exec.nm-conselho
                      procguia.nr-registro             = string(tmp-prest-exec.nr-registro)
                      procguia.uf-conselho             = tmp-prest-exec.uf-conselho
                      procguia.char-2                  = tmp-prest-exec.cd-cbo
                      procguia.vl-principal            = IF import-guia-movto.val-movto-pagto = ? THEN 0 ELSE import-guia-movto.val-movto-pagto 
                      procguia.vl-taxa-participacao    = IF import-guia-movto.val-co-partic   = ? THEN 0 ELSE import-guia-movto.val-co-partic  
                      procguia.vl-movimento-total      = (procguia.vl-principal + import-guia-movto.val-taxas-adm).

               /* ------------------- TABELA MOEDAS E CARENCIAS COBRANCA ------------------ */
               find first plamodpr 
                    where plamodpr.cd-modalidade          = cd-modalidade-aux
                      and plamodpr.cd-plano               = cd-plano-aux
                      and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                      and plamodpr.in-procedimento-insumo = "P"
                      and plamodpr.cd-modulo              = import-guia-movto.cd-modulo
                          no-lock no-error.

               if avail plamodpr
               then do:
                      assign procguia.cd-tab-preco = plamodpr.cd-tab-preco.

                      find first precproc where precproc.cd-tab-preco = plamodpr.cd-tab-preco no-lock no-error.

                      if avail precproc
                      then assign procguia.cd-forma-pagto     = precproc.cd-forma-pagto
                                  procguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.
                    end.

               /* -------------- QTD MOEDA PAGTO ------------------------- */
               if paramecp.cd-unimed = import-guia.cd-unidade-carteira
               then do:
                      find propost where propost.cd-modalidade = cd-modalidade-aux 
                                     and propost.nr-ter-adesao = nr-ter-adesao-aux
                                         no-lock no-error.

                      if avail propost
                      then assign procguia.cd-tab-preco-proc = propost.cd-tab-preco-proc.
                    end.
               else do:
                      find unicamco where unicamco.cd-unidade = import-guia.cd-unidade-carteira
                                      and unicamco.dt-limite >= import-guia.dat-solicit
                                          no-lock no-error.

                      if avail unicamco
                      then assign procguia.cd-tab-preco-proc = unicamco.cd-tab-preco-proc-cob.
                    end.

               /* ------------------- ANEXOS TISS --------------------------- */
               if in-tipo-guia-par = "QUIM"
               then assign procguia.int-2 = 1.
               else do:
                      if in-tipo-guia-par = "RADI"
                      then assign procguia.int-2 = 2.
                      else do:
                             if in-tipo-guia-par = "OPME"
                             then assign procguia.int-2 = 3.
                             else assign procguia.int-2 = 0.
                           end.
                    end.

               create proced-guia-comp.
               assign proced-guia-comp.cdn-unid             = paramecp.cd-unimed         
                      proced-guia-comp.num-ano-guia-atendim = aa-guia-atendimento-aux
                      proced-guia-comp.num-guia-atendim     = nr-guia-atendimento-aux
                      proced-guia-comp.num-proces           = nr-processo-proc-aux   
                      proced-guia-comp.num-seq-digitac      = 0
                      proced-guia-comp.dat-previs-adm       = import-guia-movto.dat-previs. /* radio e quimio */

               case in-tipo-guia-par:
                   when "ODON"
                   then do:
                          assign procguia.tp-dente-regiao  = trim(import-guia-movto.ind-dente-regiao).
                          
                          assign id-face-dente-aux = trim(import-guia-movto.ind-face-dente).

                          do ix = 1 to length(id-face-dente-aux):
                              if substr(id-face-dente-aux,ix,1) <> ""
                              then assign procguia.id-face-dente[ix] = substr(id-face-dente-aux,ix,1).
                          end.
                        end.
               end case.

               validate procguia.
               release procguia.

               validate proced-guia-comp.
               release proced-guia-comp.

               run grava-glosas(input in-tipo-guia-par,
                                input import-guia-movto.val-seqcial,
                                input val-seq-guia-par,
                                input aa-guia-atendimento-aux,
                                input nr-guia-atendimento-aux, 
                                input nr-processo-proc-aux,
                                input 0, /* nr-seq-digitacao */
                                input "P"). /* in-origem-glosa */

               assign nr-processo-proc-aux = nr-processo-proc-aux + 1.
             end.
        else do:
                
                
               create insuguia.
               assign insuguia.cd-unidade              = paramecp.cd-unimed
                      insuguia.aa-guia-atendimento     = aa-guia-atendimento-aux
                      insuguia.nr-guia-atendimento     = nr-guia-atendimento-aux
                      insuguia.nr-processo             = 0
                      insuguia.nr-seq-digitacao        = nr-seq-digitacao-ins-aux
                      insuguia.cd-tipo-insumo          = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),1,2))
                      insuguia.cd-insumo               = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),3,8))
                      insuguia.cd-modulo               = import-guia-movto.cd-modulo
                      insuguia.qt-insumo               = import-guia-movto.qtd-autoriza
                      insuguia.dec-1                   = import-guia-movto.qtd-solicitad
                      insuguia.dt-atualizacao          = today
                      insuguia.cd-userid               = v_cod_usuar_corren
                      insuguia.dt-realizacao           = today
                      insuguia.hr-realizacao           = substring(string(time,"HH:MM"),1,2) + substring(string(time,"HH:MM"),4,2)
                      insuguia.cd-modalidade           = cd-modalidade-aux
                      insuguia.cd-usuario              = nr-ter-adesao-aux
                      insuguia.nr-ter-adesao           = cd-usuario-aux
                      insuguia.cd-unidade-prestador    = cd-unidade-prestador-aux
                      insuguia.cd-prestador            = cd-prestador-aux
                      insuguia.cd-esp-prest-executante = cd-esp-prest-executante-aux
                      insuguia.cd-tipo-vinculo         = cd-vinculo-aux
                      insuguia.cd-validacao            = import-guia-movto.cd-validacao
                      insuguia.cd-tipo-cob             = import-guia-movto.num-livre-3 /* Validacao para cobranca */
                      insuguia.cd-tipo-pagamento       = import-guia-movto.num-livre-4 /* Validacao para pagamento */
                      insuguia.cd-classe-erro          = import-guia-movto.num-livre-2
                      insuguia.cd-cod-glo              = import-guia-movto.num-livre-1
                      insuguia.cd-userid               = v_cod_usuar_corren
                      insuguia.nm-prest-exec-compl     = tmp-prest-exec.nm-prest-exec-compl
                      insuguia.char-3                  = tmp-prest-exec.nm-conselho
                      insuguia.nr-registro             = string(tmp-prest-exec.nr-registro)
                      insuguia.uf-conselho             = tmp-prest-exec.uf-conselho
                      insuguia.char-2                  = tmp-prest-exec.cd-cbo
                      insuguia.vl-insumo-cob           = if import-guia-movto.val-movto-pagto = ? then 0 else import-guia-movto.val-movto-pagto
                      insuguia.vl-taxa-participacao    = if import-guia-movto.val-co-partic   = ? then 0 else import-guia-movto.val-co-partic  
                      insuguia.vl-movimento-total      = (insuguia.vl-insumo-cob + import-guia-movto.val-taxas-adm).

               for first insumos where insumos.cd-insumo = int(import-guia-movto.cod-movto-guia) no-lock: 
                   assign insuguia.cd-tipo-insumo     = insumos.cd-tipo-insumo  
                          insuguia.cd-insumo          = insumos.cd-insumo.       
               end.

               /* ------------------- TABELA MOEDAS E CARENCIAS COBRANCA --------------- */
               find first plamodpr 
                    where plamodpr.cd-modalidade          = cd-modalidade-aux
                      and plamodpr.cd-plano               = cd-plano-aux
                      and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                      and plamodpr.in-procedimento-insumo = "I"
                      and plamodpr.cd-modulo              = import-guia-movto.cd-modulo
                          no-lock no-error.

               if avail plamodpr
               then do:
                      assign insuguia.cd-tab-preco-cob = plamodpr.cd-tab-preco.

                      find first precproc where precproc.cd-tab-preco = plamodpr.cd-tab-preco no-lock no-error.

                      if avail precproc
                      then assign insuguia.cd-forma-pagto     = precproc.cd-forma-pagto
                                  insuguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.
                    end.

               /* -------------- QTD MOEDA PAGTO ------------------------- */
               if paramecp.cd-unimed = import-guia.cd-unidade-carteira
               then do:
                      find propost where propost.cd-modalidade = cd-modalidade-aux
                                     and propost.nr-ter-adesao = nr-ter-adesao-aux
                                         no-lock no-error.

                      if avail propost
                      then assign insuguia.cd-tab-preco-proc-cob = propost.cd-tab-preco-proc.
                    end.
               else do:
                      find unicamco where unicamco.cd-unidade = import-guia.cd-unidade-carteira
                                      and unicamco.dt-limite >= import-guia.dat-solicit
                                          no-lock no-error.

                      if avail unicamco
                      then assign insuguia.cd-tab-preco-proc-cob = unicamco.cd-tab-preco-proc-cob.
                    end.

               /* -------------- DESCRICAO INSUMO GENERICO ------------------------------ */
               if  import-guia-movto.des-insumo <> ?
               and import-guia-movto.des-insumo <> ""
               then assign insuguia.char-4 = import-guia-movto.des-insumo. /* Descricao do insumo generico */

               /* --------------------- ANEXOS CLINICOS TISS -------------------------- */
               if in-tipo-guia-par = "QUIM"
               then assign insuguia.int-2 = 1.
               else do:
                      if in-tipo-guia-par = "RADI"
                      then assign insuguia.int-2 = 2.
                      else do:
                             if in-tipo-guia-par = "OPME"
                             then assign insuguia.int-2 = 3.
                             else assign insuguia.int-2 = 0.
                           end.
                    end.

               create insumo-guia-comp.
               assign insumo-guia-comp.cdn-unid             = paramecp.cd-unimed                      
                      insumo-guia-comp.num-ano-guia-atendim = aa-guia-atendimento-aux                 
                      insumo-guia-comp.num-guia-atendim     = nr-guia-atendimento-aux                 
                      insumo-guia-comp.num-proces           = 0                                       
                      insumo-guia-comp.num-seq-digitac      = nr-seq-digitacao-ins-aux                
                      insumo-guia-comp.cod-opc              = trim(import-guia-movto.des-opc-fabrican)
                      insumo-guia-comp.cdn-via-adm          = int(import-guia-movto.cdn-via-administ)
                      insumo-guia-comp.dat-previs-adm       = import-guia-movto.dat-previs
                      insumo-guia-comp.cdn-freq             = import-guia-movto.cdn-freq.

               validate insuguia.
               release insuguia.

               validate insumo-guia-comp.
               release insumo-guia-comp.

               run grava-glosas(input in-tipo-guia-par,
                                input import-guia-movto.val-seqcial,
                                input val-seq-guia-par,
                                input aa-guia-atendimento-aux,
                                input nr-guia-atendimento-aux, 
                                input 0, /* nr-processo */
                                input nr-seq-digitacao-ins-aux,
                                input "I"). /* in-origem-glosa */

               assign nr-seq-digitacao-ins-aux = nr-seq-digitacao-ins-aux + 1.
             end.
    end. /* each import-guia-movto */

end procedure.

/* ----------------------------------------------------------------- */
procedure grava-glosas:

    def input parameter ind-tip-guia-par      as char no-undo.
    def input parameter val-seqcial-movto-par as int  no-undo.
    def input parameter val-seq-guia-par      as int  no-undo.
    def input parameter aa-guia-atend-par     as int  no-undo.
    def input parameter nr-guia-atend-par     as int  no-undo.
    def input parameter nr-processo-par       as int  no-undo.
    def input parameter nr-seq-digitacao-par  as int  no-undo.
    def input parameter in-origem-glosa-par   as char no-undo.

    for each import-movto-glosa
       where import-movto-glosa.in-modulo         = "AT"
         and import-movto-glosa.ind-tip-guia      = ind-tip-guia-par
         and import-movto-glosa.val-seqcial-movto = val-seqcial-movto-par
         and import-movto-glosa.val-seq-guia      = val-seq-guia-par
             no-lock:

        create movatglo.
        assign movatglo.cd-unidade          = paramecp.cd-unimed
               movatglo.aa-guia-atendimento = aa-guia-atend-par
               movatglo.nr-guia-atendimento = nr-guia-atend-par
               movatglo.nr-processo         = nr-processo-par
               movatglo.nr-seq-digitacao    = nr-seq-digitacao-par
               movatglo.cd-classe-erro      = import-movto-glosa.cd-classe-erro
               movatglo.in-origem-glosa     = in-origem-glosa-par
               movatglo.cd-cod-glo          = import-movto-glosa.cd-cod-glo
               movatglo.ds-motivo-glosa     = import-movto-glosa.des-motiv-glosa
               movatglo.cd-userid           = v_cod_usuar_corren
               movatglo.dt-atualizacao      = today
               movatglo.qti-quant-proced-dispon = import-movto-glosa.qti-quant-proced-dispon.

        validate movatglo.
        release movatglo.

    end. /* each import-movto-glosa */

end procedure.

/* ----------------------------------------------------------------- */
procedure gera-seq-guia:

    assign aa-guia-atendimento-aux = year(import-guia.dat-solicit)
           nr-guia-atendimento-aux = dec(import-guia.cod-guia-operdra).
    

   /* find first guiautor where guiautor.cd-unidade          = paramecp.cd-unimed
                          and guiautor.aa-guia-atendimento = year(today)
                              no-lock no-error.

    if avail guiautor 
    then assign nr-guia-atendimento-aux = next-value (seq-guiautor).
    else do:
           assign nr-guia-atendimento-aux = 1.

            do:
                   do transaction:
                      run stored-proc shsrcadger.send-sql-statement hand1 = proc-handle
                      ("drop sequence seq_guiautor").

                      run stored-proc shsrcadger.send-sql-statement hand1 = proc-handle
                      ("create sequence seq_guiautor start with 1 minvalue 0 maxvalue 99999999 nocycle nocache increment by 1").

                      close stored-proc shsrcadger.send-sql-statement where proc-handle = hand1.

                   end.

                   assign nr-guia-atendimento-aux = next-value (seq-guiautor).
                 end.
           

         end.*/

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-odontologia:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-odonto where import-guia-odonto.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-odonto
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Registro import-guia-odonto nao encontrado",
                          input today,
                          input "Registro referente a guia de Odontologia nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    /*if  AVAIL
    and not tranrevi.lg-transacao-odontologica
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Transacao nao e de odontologia",
                          input today,
                          input "Para guias de odontologia, informe transacao de odontologia").

           assign lg-erro-par = yes.
         end.*/

    /* ----------------------------------------------------------------- */
    if  avail tip-guia
    and not tip-guia.lg-transacao-odontologica
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo de Guia nao e de odontologia",
                          input today,
                          input "Para guias de odontologia, informe um tipo de guia de odontologia").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-guia-odonto.ind-tip-atendim) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Atendimento invalido: " + string(import-guia-odonto.ind-tip-atendim),
                          input today,
                          input "Informe um valor conforme a tabela 51 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    if int(import-guia-odonto.ind-tip-atendim) < 1
    or int(import-guia-odonto.ind-tip-atendim) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Atendimento invalido: " + string(import-guia-odonto.ind-tip-atendim),
                          input today,
                          input "Informe um valor conforme a tabela 51 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-guia-odonto.ind-tip-faturam) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Faturamento invalido: " + string(import-guia-odonto.ind-tip-faturam),
                          input today,
                          input "Informe um valor conforme a tabela 55 da TISS.").

           assign lg-erro-par = yes.
         end.

    if int(import-guia-odonto.ind-tip-faturam) < 1
    or int(import-guia-odonto.ind-tip-faturam) > 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Atendimento invalido: " + string(import-guia-odonto.ind-tip-faturam),
                          input today,
                          input "Informe um valor conforme a tabela 55 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    run busca-vinculo-prestador(input  import-guia-odonto.cd-unidade-exec,
                                input  import-guia-odonto.cd-prestador-exec,
                                input  import-guia-odonto.cd-especialid-exec,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados.",
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia        = "ODON"
                  tmp-prest-exec.val-seqcial         = import-guia-odonto.num-seqcial-guia
                  tmp-prest-exec.cd-unidade          = import-guia-odonto.cd-unidade-exec
                  tmp-prest-exec.cd-prestador        = import-guia-odonto.cd-prestador-exec
                  tmp-prest-exec.cd-espec            = import-guia-odonto.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo          = cd-vinculo-aux
                  tmp-prest-exec.nm-prest-exec-compl = trim(import-guia-odonto.nom-prestdor-executa)
                  tmp-prest-exec.nm-conselho         = trim(import-guia-odonto.cod-cons-exec)
                  tmp-prest-exec.nr-registro         = import-guia-odonto.num-livre-1
                  tmp-prest-exec.uf-conselho         = trim(import-guia-odonto.cod-uf-cons-medic)
                  tmp-prest-exec.cd-cbo              = trim(import-guia-odonto.cod-cbo-prestdor-exec).
         end.

    /* ------------ PRESTADOR EXECUTANTE --------------------------- */
    find preserv where preserv.cd-unidade   = import-guia-odonto.cd-unidade-exec
                   and preserv.cd-prestador = import-guia-odonto.cd-prestador-exec
                       no-lock no-error.

    if not avail preserv
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Prestador executante nao cadastrado.",
                          input today,
                          input "Informe um codigo de prestador cadastrado no Gestao de Planos.").
           
           assign lg-erro-par = yes.
         end.
    else do:
           if preserv.in-tipo-pessoa = "J"
           then do:
                  if import-guia-odonto.nom-prestdor-executa = ?
                  or import-guia-odonto.nom-prestdor-executa = ""
                  then do:
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia-odonto",
                                        input "Nome do prestador executante complementar deve ser informado.",
                                        input today,
                                        input "Quando o prestador executante for pessoa juridica, o nome do prestador executante deve ser informado.").
                         
                         assign lg-erro-par = yes.
                       end.
                end.
         end.

    if import-guia-odonto.cod-cons-exec = ?
    or import-guia-odonto.cod-cons-exec = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Conselho do prestador executante nao informado.",
                          input today,
                          input "Informe o conselho do prestador executante.").

           assign lg-erro-par = yes.
         end.
    else do:
           if not can-find(conpres where conpres.cd-conselho = trim(import-guia-odonto.cod-cons-exec))
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-odonto",
                                 input "Conselho do prestador executante nao cadastrado.",
                                 input today,
                                 input "Informe um codigo de conselho cadastrado no Gestao de Planos.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    if import-guia-odonto.cod-cbo-prestdor-exec = ?
    or import-guia-odonto.cod-cbo-prestdor-exec = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "CBO do prestador executante nao informado.",
                          input today,
                          input "Informe o CBO do prestador executante").

           assign lg-erro-par = yes.
         end.

    if import-guia-odonto.cod-uf-cons-medic = ?
    or import-guia-odonto.cod-uf-cons-medic = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "UF do conselho do prestador executante nao informado.",
                          input today,
                          input "Infome a UF do conselho do prestador executante.").

           assign lg-erro-par = yes.
         end.

    if import-guia-odonto.num-livre-1 = ? /* Numero do registro do prestador no conselho */
    or import-guia-odonto.num-livre-1 = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Numero do registro no conselho do prestador executante nao informado.",
                          input today,
                          input "Informe o numero do registro do prestador.").

           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS INTERNACAO -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "ODON" /* Odontologia */
         and import-guia-movto.val-seq-guia = import-guia-odonto.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-odonto",
                              input "Tipo do movimento informado invalido: " + STRING(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-odonto.num-seqcial-guia,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-anexo-odonto:

    def input-output parameter lg-erro-par as log init no no-undo.
    
    find first import-anexo-odonto where import-anexo-odonto.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-odonto
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-odonto",
                          input "Registro import-anexo-odonto nao encontrado",
                          input today,
                          input "Registro referente ao anexo de Odontologia nao encontrado.").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ------------- VALIDA OS MOVIMENTOS DO ANEXO DE ODONTO ------------- */
    for each import-anexo-odonto-mov
       where import-anexo-odonto-mov.num-seqcial-anexo = import-anexo-odonto.num-seqcial
             no-lock:

        int(import-anexo-odonto-mov.tp-dente-regiao) no-error.

        if error-status:error
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-odonto-mov",
                              input "Dente invalido: " + string(import-anexo-odonto-mov.tp-dente-regiao),
                              input today,
                              input "Informe um codigo valido para o dente").
               
               assign lg-erro-par = yes.
             end.

        if  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 11
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 18
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 21
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 28
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 51
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 55
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 61
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 65
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 71
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 75
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 81
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 85
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 41
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 48
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 31
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 38
            )
        then . /* Perdao! Complicado negar esse if ... */
        else do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-odonto-mov",
                              input "Dente invalido: " + string(import-anexo-odonto-mov.tp-dente-regiao),
                              input today,
                              input "Informe um codigo valido para o dente").
               
               assign lg-erro-par = yes.
             end.

        if  import-anexo-odonto-mov.ind-sit-inicial <> ?
        and import-anexo-odonto-mov.ind-sit-inicial <> ""
        then do:
               assign ds-sit-ini-aux = trim(import-anexo-odonto-mov.ind-sit-inicial).

               do ix = 1 to length(ds-sit-ini-aux):
                   if  substr(ds-sit-ini-aux,ix,1) <> "A" /* Ausente */
                   and substr(ds-sit-ini-aux,ix,1) <> "E" /* Extracao Indicada */
                   and substr(ds-sit-ini-aux,ix,1) <> "H" /* Higido */
                   and substr(ds-sit-ini-aux,ix,1) <> "C" /* Cariado */
                   and substr(ds-sit-ini-aux,ix,1) <> "R" /* Restaurado */
                   then do:
                          run grava-erro(input import-guia.num-seqcial-control,
                                         input "import-anexo-odonto-mov",
                                         input "Situacao do dente invalida: " + string(substr(ds-sit-ini-aux,ix,1)),
                                         input today,
                                         input "Informe um codigo valido para a situacao do dente").
                          
                          assign lg-erro-par = yes.
                        end.
               end.
             end.
    end. /* each import-anexo-odonto-mov */

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-radioterapia:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-anexo-radio where import-anexo-radio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-radio
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Registro import-anexo-radio nao encontrado",
                          input today,
                          input "Registro referente ao anexo de Radioterapia nao encontrado.").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  import-anexo-radio.des-cirurgia-ant <> ?
    and import-anexo-radio.des-cirurgia-ant <> ""
    and import-anexo-radio.dat-realiz = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Data de realizacao da ultima cirurgia nao informada",
                          input today,
                          input "Quando informado a descricao da cirurgia anterior, a data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    if  import-anexo-radio.des-quimio <> ?
    and import-anexo-radio.des-quimio <> ""
    and import-anexo-radio.dat-aplic = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Data de realizacao da ultima quimioterapia nao informada",
                          input today,
                          input "Quando informado a descricao da qiomioterapia anterior, a data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.qti-campos = ?
    or import-anexo-radio.qti-campos = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo Numero de Campos irradiados nao informado.",
                          input today,
                          input "Informa a quantidade de campos irradiados.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.qtd-dosag-diaria = ?
    or import-anexo-radio.qtd-dosag-diaria = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo quantidade de doses diarias nao informado.",
                          input today,
                          input "Informa a quantidade de doses diarias.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.qtd-dosag-tot = ?
    or import-anexo-radio.qtd-dosag-tot = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo quantidade de doses total nao informado.",
                          input today,
                          input "Informa a quantidade de doses total.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.num-dias = ?
    or import-anexo-radio.num-dias = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo Numero de Dias nao informado.",
                          input today,
                          input "Informe Numero de Dias do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.dat-inic-adm = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo Data de Inicio do Tratamento nao informado.",
                          input today,
                          input "Informe a data de inicio do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-radio.cod-estag) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo do estadiamento do tumor invalido: " + string(import-anexo-radio.cod-estag),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    if int(import-anexo-radio.cod-estag) < 1
    or int(import-anexo-radio.cod-estag) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo do estadiamento do tumor invalido: " + string(import-anexo-radio.cod-estag),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-radio.ind-finalid-tratam) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da finalidade do tratamento invalida: " + string(import-anexo-radio.ind-finalid-tratam),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    if int(import-anexo-radio.ind-finalid-tratam) < 1
    or int(import-anexo-radio.ind-finalid-tratam) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da finalidade do tratamento invalida: " + string(import-anexo-radio.ind-finalid-tratam),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-radio.cod-classif-capac-funcnal) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da escala de capacidade funcional invalido: " + string(import-anexo-radio.cod-classif-capac-funcnal),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").

           assign lg-erro-par = yes.
         end.

    if int(import-anexo-radio.cod-classif-capac-funcnal) < 0
    or int(import-anexo-radio.cod-classif-capac-funcnal) > 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da escala de capacidade funcional invalido: " + string(import-anexo-radio.cod-classif-capac-funcnal),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").

           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS RADIOTERAPIA -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "RADI" /* Radioterapia */
         and import-guia-movto.val-seq-guia = import-anexo-radio.num-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-radio",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Anexo de quimioterapia somente aceita procedimentos").

               assign lg-erro-par = yes.
             end.

        if import-guia-movto.dat-previs = ?
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-radio",
                              input "Data Prevista para aplicacao do medicamento deve ser informada",
                              input today,
                              input "Informe o campo Data Prevista.").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-anexo-radio.num-seqcial,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-opme:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-anexo-opme where import-anexo-opme.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-opme
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-opme",
                          input "Registro import-anexo-opme nao encontrado",
                          input today,
                          input "Registro referente ao anexo de OPME nao encontrado.").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-opme.des-justificativa = ?
    or import-anexo-opme.des-justificativa = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-opme",
                          input "Justificativa Tecnica do material solicitado nao informada.",
                          input today,
                          input "Informe a justificativa tecnica").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-opme.des-especif-mater = ?
    or import-anexo-opme.des-especif-mater = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-opme",
                          input "Especificacao do material solicitado nao informada.",
                          input today,
                          input "Informe a especificacao do material.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS OPME -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "OPME"
         and import-guia-movto.val-seq-guia = import-anexo-opme.num-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-opme",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Anexo de quimioterapia somente aceita insumos OPME").

               assign lg-erro-par = yes.
             end.

        int(import-guia-movto.des-opc-fabrican) no-error.

        if error-status:error
        or int(import-guia-movto.des-opc-fabrican) <= 0
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-opme",
                              input "Opcao do fabricante invalida: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Informe um valor maior que zero").
               
               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-anexo-opme.num-seqcial,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-quimioterapia:

    def input-output parameter lg-erro-par as log init no no-undo.

    find import-anexo-quimio where import-anexo-quimio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-quimio
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Tabela import-anexo-quimio nao encontrada ",
                          input today,
                          input "Registro referente ao anexo de quimioterapia nao encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.val-peso-bnfciar = ?
    or import-anexo-quimio.val-peso-bnfciar = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Peso do beneficiario nao informado",
                          input today,
                          input "Informe o peso do beneficiario").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.val-alt-bnfciar = ?
    or import-anexo-quimio.val-alt-bnfciar = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Altura do beneficiario nao informado",
                          input today,
                          input "Informe a altura do beneficiario").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.val-sup-cor-bnfciar = ?
    or import-anexo-quimio.val-sup-cor-bnfciar = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Superficie corporal do beneficiario nao informada",
                          input today,
                          input "Informe a superficie corporal do beneficiario").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.num-ciclo = ?
    or import-anexo-quimio.num-ciclo = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Campo Numero de Ciclos nao informado",
                          input today,
                          input "Informe o numero de ciclos do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.num-ciclo-atual = ?
    or import-anexo-quimio.num-ciclo-atual = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Campo Numero do Ciclo Atual nao informado",
                          input today,
                          input "Informe o numero do ciclo atual do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.num-interv-ciclo = ?
    or import-anexo-quimio.num-interv-ciclo = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Campo Numero de Intervalo entre Ciclos nao informado",
                          input today,
                          input "Informe o numero do intervalo entre ciclos do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  import-anexo-quimio.des-cirurgia-ant <> ?
    and import-anexo-quimio.des-cirurgia-ant <> ""
    and import-anexo-quimio.dt-realizacao     = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Data de realizacao de cirurgia anterior nao informada",
                          input today,
                          input "Quando informada descricao da cirurgia anterior, a sua data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  import-anexo-quimio.des-area <> ?
    and import-anexo-quimio.des-area <> ""
    and import-anexo-quimio.dat-aplic-radio = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Data de aplicacao da radioterapia anterior nao informada",
                          input today,
                          input "Quando informada descricao da radioterapia anterior, a sua data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.cod-estag) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do estadiamento do tumor invalido: " + string(import-anexo-quimio.cod-estag),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.cod-estag) < 1
    or int(import-anexo-quimio.cod-estag) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do estadiamento do tumor invalido: " + string(import-anexo-quimio.cod-estag),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.ind-finalid-tratam) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da finalidade do tratamento invalida: " + string(import-anexo-quimio.ind-finalid-tratam),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.ind-finalid-tratam) < 1
    or int(import-anexo-quimio.ind-finalid-tratam) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da finalidade do tratamento invalida: " + string(import-anexo-quimio.ind-finalid-tratam),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.ind-tip-quimio) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do tipo de quimioterapia invalido: " + string(import-anexo-quimio.ind-tip-quimio),
                          input today,
                          input "Informe um codigo conforme a tabela 58 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.ind-tip-quimio) < 1
    or int(import-anexo-quimio.ind-tip-quimio) > 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do tipo de quimioterapia invalido: " + string(import-anexo-quimio.ind-tip-quimio),
                          input today,
                          input "Informe um codigo conforme a tabela 58 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.cod-classif-capac-funcnal) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da escala de capacidade funcional invalido: " + string(import-anexo-quimio.cod-classif-capac-funcnal),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.cod-classif-capac-funcnal) < 0
    or int(import-anexo-quimio.cod-classif-capac-funcnal) > 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da escala de capacidade funcional invalido: " + string(import-anexo-quimio.cod-classif-capac-funcnal),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.des-plano-terap = ?
    or import-anexo-quimio.des-plano-terap = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Descricao do plano terapeutico nao informado",
                          input today,
                          input "Informe a descricao do plano terapeutico").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS QUIMIOTERAPIA -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "QUIM" /* Quimioterapia */
         and import-guia-movto.val-seq-guia = import-anexo-quimio.num-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Anexo de quimioterapia somente aceita medicamentos (insumos)").

               assign lg-erro-par = yes.
             end.

        if import-guia-movto.dat-previs = ?
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Data Prevista para aplicacao do medicamento deve ser informada",
                              input today,
                              input "Informe o campo Data Prevista.").
               
               assign lg-erro-par = yes.
             end.

        int(import-guia-movto.cdn-via-administ) no-error.

        if error-status:error
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Via de administracao invalida: " + string(import-guia-movto.cdn-via-administ),
                              input today,
                              input "Informe um valor conforme a tabela 62 da TISS").
               
               assign lg-erro-par = yes.
             end.

        if import-guia-movto.cdn-freq = 0
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Frequencia de utilizacao deve ser informada",
                              input today,
                              input "Informe o campo Frequencia.").
               
               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-anexo-quimio.num-seqcial,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-dados-gerais-anexos:

    def input-output parameter lg-erro-par as log init no no-undo.

    if  trim(import-anexo-solicit.ind-tip-anexo) <> "1" /* Quimio */
    and trim(import-anexo-solicit.ind-tip-anexo) <> "2" /* Radio */
    and trim(import-anexo-solicit.ind-tip-anexo) <> "3" /* OPME */
    and trim(import-anexo-solicit.ind-tip-anexo) <> "4" /* Odonto */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-solicit",
                          input "Tipo do anexo informado invalido: " + string(trim(import-anexo-solicit.ind-tip-anexo)),
                          input today,
                          input "Informa um tipo de anexo valido: 1, 2, 3 ou 4").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  avail tip-guia
    and tip-guia.int-11 <> 1
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo de Guia nao aceita anexos clinicos TISS",
                          input today,
                          input "Para guias com anexos clinicos, informe um tipo de guia permita anexos clinicos TISS").

           assign lg-erro-par = yes.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-prorrogacao:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-prorrog where import-guia-prorrog.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-prorrog
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-prorrog",
                          input "Registro import-guia-prorrog nao encontrado",
                          input today,
                          input "Registro referente a guia de Prorrogacao nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  avail tip-guia
    and not tip-guia.log-29 /* Tipo de guia de prorrogacao */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo de Guia nao e de prorrogacao",
                          input today,
                          input "Para guias de prorrogacao, informe um tipo de guia de prorrogacao").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-guia.num-seqcial-princ = ?
    or import-guia.num-seqcial-princ = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-prorrog",
                          input "Codigo da guia principal deve ser informado.",
                          input today,
                          input "O codigo da guia principal e obrigatorio para guias de prorrogacao.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-guia-prorrog.des-indic-clinic = ?
    or import-guia-prorrog.des-indic-clinic = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-prorrog",
                          input "Campo Indicacao clinica nao informado.",
                          input today,
                          input "Informe a indicacao clinica para guia de prorrogacao.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    find guiautor where guiautor.cd-unidade          = paramecp.cd-unimed
                    and guiautor.aa-guia-atendimento = aa-guia-atend-ant-aux
                    and guiautor.nr-guia-atendimento = nr-guia-atend-ant-aux
                        no-lock no-error.

    if avail guiautor
    then do:
           find first procguia where procguia.cd-unidade          = guiautor.cd-unidade         
                                 and procguia.aa-guia-atendimento = guiautor.aa-guia-atendimento
                                 and procguia.nr-guia-atendimento = guiautor.nr-guia-atendimento
                                     no-lock no-error.

           if avail procguia
           then do:
                  create tmp-prest-exec.
                  assign tmp-prest-exec.in-tipo-guia = "PROR"
                         tmp-prest-exec.val-seqcial  = import-guia-prorrog.num-seqcial-guia
                         tmp-prest-exec.cd-unidade   = procguia.cd-unidade-prestador
                         tmp-prest-exec.cd-prestador = procguia.cd-prestador
                         tmp-prest-exec.cd-espec     = procguia.cd-esp-prest-executante
                         tmp-prest-exec.cd-vinculo   = procguia.cd-tipo-vinculo.
                end.
           else do:
                  find first insuguia where insuguia.cd-unidade          = guiautor.cd-unidade         
                                        and insuguia.aa-guia-atendimento = guiautor.aa-guia-atendimento
                                        and insuguia.nr-guia-atendimento = guiautor.nr-guia-atendimento
                                            no-lock no-error.

                  if avail insuguia
                  then do:
                         create tmp-prest-exec.
                         assign tmp-prest-exec.in-tipo-guia = "PROR"
                                tmp-prest-exec.val-seqcial  = import-guia-prorrog.num-seqcial-guia
                                tmp-prest-exec.cd-unidade   = insuguia.cd-unidade-prestador
                                tmp-prest-exec.cd-prestador = insuguia.cd-prestador
                                tmp-prest-exec.cd-espec     = insuguia.cd-esp-prest-executante
                                tmp-prest-exec.cd-vinculo   = insuguia.cd-tipo-vinculo.
                       end.
                end.
         end.

    /* ------------------- MOVIMENTOS INTERNACAO -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "PROR" /* Prorrogacao */
         and import-guia-movto.val-seq-guia = import-guia-prorrog.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-prorrog",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-prorrog.num-seqcial-guia,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-internacao:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-intrcao where import-guia-intrcao.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-intrcao
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Registro import-guia-intrcao nao encontrado",
                          input today,
                          input "Registro referente a guia de Internacao nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if import-guia-intrcao.dt-internacao = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo data sugerida para internacao nao foi informado",
                          input today,
                          input "Informe o campo data sugerida para internacao").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  trim(import-guia-intrcao.cod-caract-atendim) <> "E" /* Eletivo */
    and trim(import-guia-intrcao.cod-caract-atendim) <> "U" /* Urgencia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Carater da Solicitacao invalido: " + string(import-guia-intrcao.cod-caract-atendim),
                          input today,
                          input "Informar um dos valores: E ou U.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.idi-acid <> 0
    and import-guia-intrcao.idi-acid <> 1
    and import-guia-intrcao.idi-acid <> 2
    and import-guia-intrcao.idi-acid <> 9
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Indicador de acidente invalido: " + string(import-guia-intrcao.idi-acid),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").

           assign lg-erro-par = yes.
         end.
    

    if import-guia-intrcao.num-livre-1 < 1 /* tipo de atendimento Tiss*/
    or import-guia-intrcao.num-livre-1 < 5
    then do:
            /* ----------------------------------------------------------- */
            if import-guia-intrcao.des-indcao-clinic = ?
            or import-guia-intrcao.des-indcao-clinic = ""
            then do:
                   run grava-erro(input import-guia.num-seqcial-control,
                                  input "import-guia-intrcao",
                                  input "Campo Indicacao clinica nao informado.",
                                  input today,
                                  input "Informe a indicacao clinica para guia de internacao.").
                   
                   assign lg-erro-par = yes.
                 end.
         end.
          
    /* ----------------------------------------------------------- */                                           
    if import-guia-intrcao.cdn-tip-inter < 1  /*Tipo de atendimento Tiss*/
    or import-guia-intrcao.cdn-tip-inter > 5 /*Tipo de atendimento Tiss*/
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo Tipo de Internacao invalido: " + string(import-guia-intrcao.cdn-tip-inter),
                          input today,
                          input "Informe um tipo de internacao conforme a tabela 57 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    int(import-guia-intrcao.cod-regim-intrcao) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo Regime de internacao invalido: " + string(import-guia-intrcao.cod-regim-intrcao),
                          input today,
                          input "Informe um regime de internacao conforme a tabela 41 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */                                           
    if int(import-guia-intrcao.cod-regim-intrcao) < 1
    or int(import-guia-intrcao.cod-regim-intrcao) > 3
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo Regime de internacao invalido: " + string(import-guia-intrcao.cod-regim-intrcao),
                          input today,
                          input "Informe um regime de internacao conforme a tabela 41 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-princ <> ?
    and import-guia-intrcao.cod-cid-princ <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-princ)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid principal nao cadastrado: " + string(import-guia-intrcao.cod-cid-princ),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-2 <> ?
    and import-guia-intrcao.cod-cid-2 <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-2)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid nao cadastrado: " + string(import-guia-intrcao.cod-cid-2),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-3 <> ?
    and import-guia-intrcao.cod-cid-3 <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-3)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid nao cadastrado: " + string(import-guia-intrcao.cod-cid-3),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-4 <> ?
    and import-guia-intrcao.cod-cid-4 <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-4)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid nao cadastrado: " + string(import-guia-intrcao.cod-cid-4),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").

           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    run busca-vinculo-prestador(input  import-guia-intrcao.cd-unidade-exec,
                                input  import-guia-intrcao.cd-prestador-exec,
                                input  import-guia-intrcao.cd-especialid-exec,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados.",
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia = "INTE"
                  tmp-prest-exec.val-seqcial  = import-guia-intrcao.num-seqcial-guia
                  tmp-prest-exec.cd-unidade   = import-guia-intrcao.cd-unidade-exec
                  tmp-prest-exec.cd-prestador = import-guia-intrcao.cd-prestador-exec
                  tmp-prest-exec.cd-espec     = import-guia-intrcao.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo   = cd-vinculo-aux.
         end.

    /* ------------------- MOVIMENTOS INTERNACAO -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "INTE" /* Consulta */
         and import-guia-movto.val-seq-guia = import-guia-intrcao.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-con",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-intrcao.num-seqcial-guia,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-sp-sadt:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-sadt where import-guia-sadt.val-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-sadt
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Registro import-guia-sadt nao encontrado",
                          input today,
                          input "Registro referente a guia de SP/SADT nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  trim(import-guia-sadt.ind-carac-solicit) <> "E" /* Eletivo */
    and trim(import-guia-sadt.ind-carac-solicit) <> "U" /* Urgencia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Carater da Solicitacao invalido: " + string(import-guia-sadt.ind-carac-solicit),
                          input today,
                          input "Informar um dos valores: E ou U.").
           
           assign lg-erro-par = yes.
         end.         

    /* ----------------------------------------------------------------- */
    int(import-guia-sadt.ind-tip-atendim) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Tipo de Atendimento invalido: " + string(import-guia-sadt.ind-tip-atendim),
                          input today,
                          input "Informar um tipo de atendimento conforme a tabela 50 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if (int(import-guia-sadt.ind-tip-atendim) < 1
    or int(import-guia-sadt.ind-tip-atendim) > 11)
    and int(import-guia-sadt.ind-tip-atendim) <> 13
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Tipo de Atendimento invalido: " + string(import-guia-sadt.ind-tip-atendim),
                          input today,
                          input "Informar um tipo de atendimento conforme a tabela 50 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    int(import-guia-sadt.ind-tip-acid) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Indicador de acidente invalido: " + string(import-guia-sadt.ind-tip-acid),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  int(import-guia-sadt.ind-tip-acid) <> 0
    and int(import-guia-sadt.ind-tip-acid) <> 1
    and int(import-guia-sadt.ind-tip-acid) <> 2
    and int(import-guia-sadt.ind-tip-acid) <> 9
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Indicador de acidente invalido: " + string(import-guia-sadt.ind-tip-acid),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if int(import-guia-sadt.ind-tip-atendim) = 4 /* Consulta */
    then do:
           int(import-guia-sadt.ind-tip-con) no-error.
           
           if error-status:error
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-sadt",
                                 input "Tipo de Consulta invalido: " + string(import-guia-sadt.ind-tip-con),
                                 input today,
                                 input "Tipo de Atendimento e de consulta. Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
                  assign lg-erro-par = yes.
                end.
           
           /* ----------------------------------------------------------- */
           if  int(import-guia-sadt.ind-tip-con) <> 1
           and int(import-guia-sadt.ind-tip-con) <> 2
           and int(import-guia-sadt.ind-tip-con) <> 3
           and int(import-guia-sadt.ind-tip-con) <> 4
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-sadt",
                                 input "Tipo de Consulta invalido: " + string(import-guia-sadt.ind-tip-con),
                                 input today,
                                 input "Tipo de Atendimento e de consulta. Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    /* ------------------------------------------------------------------------------------- */
    run busca-vinculo-prestador(input  import-guia-sadt.cd-unidade-exec,
                                input  import-guia-sadt.cd-prest-exec,
                                input  import-guia-sadt.cd-especialid-exec,
                                input  import-guia.dat-solicit, 
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados.",
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia = "SADT"
                  tmp-prest-exec.val-seqcial  = import-guia-sadt.val-seqcial
                  tmp-prest-exec.cd-unidade   = import-guia-sadt.cd-unidade-exec
                  tmp-prest-exec.cd-prestador = import-guia-sadt.cd-prest-exec
                  tmp-prest-exec.cd-espec     = import-guia-sadt.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo   = cd-vinculo-aux.
         end.

    /* ------------------- MOVIMENTOS SADT -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "SADT" /* SADT */
         and import-guia-movto.val-seq-guia = import-guia-sadt.val-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-sadt",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        if import-guia-movto.ind-tip-movto-guia = "P"
        and (   import-guia-sadt.des-indic-clinic = ?
             or import-guia-sadt.des-indic-clinic = ""
            )
        then do:
               assign cd-esp-amb-aux        = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2))
                      cd-grupo-proc-amb-aux = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2))
                      cd-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3))
                      dv-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1)).
               
               find ambproce where ambproce.cd-esp-amb        = cd-esp-amb-aux
                               and ambproce.cd-grupo-proc-amb = cd-grupo-proc-amb-aux
                               and ambproce.cd-procedimento   = cd-procedimento-aux
                               and ambproce.dv-procedimento   = dv-procedimento-aux
                                   no-lock no-error.
               
               if avail ambproce                                                               
               then do:                                                                        
                      find tiss-tip-atendim where tiss-tip-atendim.cdn-tip-atendim = ambproce.num-livre-6  /* Tipo de Atendimento do procedimento */
                                                  no-lock no-error.                                                  
               
                      if avail tiss-tip-atendim                                                
                      and tiss-tip-atendim.log-livre-2 /* Obriga Indicacao Clinica */
                      then do:                                                                                                                       
                             run grava-erro(input import-guia.num-seqcial-control,
                                            input "import-guia-sadt",
                                            input "Indicacao Clinica deve ser informada.",
                                            input today,
                                            input "Tipo de Atendimento informado no cadastro de procedimentos obriga indicacao clinica. Campo deve ser informado").
                             
                             assign lg-erro-par = yes.
                           end.                                                                
                    end.   
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-sadt.val-seqcial,
                          input-output lg-erro-par).
    end.


end procedure.

/* ----------------------------------------------------------------- */
procedure valida-consulta:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-con where import-guia-con.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-con
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Registro import-guia-con nao encontrado",
                          input today,
                          input "Registro referente a guia de consulta nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-con.in-acidente <> 0
    and import-guia-con.in-acidente <> 1
    and import-guia-con.in-acidente <> 2
    and import-guia-con.in-acidente <> 9
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Indicador de acidente invalido: " + string(import-guia-con.in-acidente),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    int(import-guia-con.ind-tip-con) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Tipo de Consulta invalido: " + string(import-guia-con.ind-tip-con),
                          input today,
                          input "Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  int(import-guia-con.ind-tip-con) <> 1
    and int(import-guia-con.ind-tip-con) <> 2
    and int(import-guia-con.ind-tip-con) <> 3
    and int(import-guia-con.ind-tip-con) <> 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Tipo de Consulta invalido: " + string(import-guia-con.ind-tip-con),
                          input today,
                          input "Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if import-guia-con.dat-atendim = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Data do Atendimento nao informada",
                          input today,
                          input "Informe o campo Data do Atendimento").
           
           assign lg-erro-par = yes.
         end.

    /* -------------- PRESTADOR EXECUTANTE ------------------- */
    if not can-find(preserv where preserv.cd-unidade   = import-guia-con.cd-unidade-exec  
                              and preserv.cd-prestador = import-guia-con.cd-prestador-exec)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Prestador executante nao cadastrado.",
                          input today,
                          input "Informe um prestador cadastrado no GPS").
           
           assign lg-erro-par = yes.
         end.

    if import-guia-con.cd-especialid-exec = 0
    or import-guia-con.cd-especialid-exec = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Especialidade do prestador executante deve ser informada.",
                          input today,
                          input "Informe uma especialidade medica para o prestador executante.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    run busca-vinculo-prestador(input  import-guia-con.cd-unidade-exec,
                                input  import-guia-con.cd-prestador-exec,
                                input  import-guia-con.cd-especialid-exec,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados.",
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia = "CONS"
                  tmp-prest-exec.val-seqcial  = import-guia-con.num-seqcial-guia
                  tmp-prest-exec.cd-unidade   = import-guia-con.cd-unidade-exec
                  tmp-prest-exec.cd-prestador = import-guia-con.cd-prestador-exec
                  tmp-prest-exec.cd-espec     = import-guia-con.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo   = cd-vinculo-aux.
         end.

    /* ------------------- MOVIMENTOS CONSULTA -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "CONS" /* Consulta */
         and import-guia-movto.val-seq-guia = import-guia-con.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-con",
                              input "Tipo do movimento informado invalido: " + string(import-guia-movto.ind-tip-movto-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").
               
               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-con.num-seqcial-guia,
                          input-output lg-erro-par).
    end.
    
end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-dados-gerais:

    def output parameter lg-erro-par as log init no no-undo.

    /* ----------------------------------------------------------- */
    if  trim(import-guia.ind-tip-guia) <> "S" /* SADT */
    and trim(import-guia.ind-tip-guia) <> "I" /* Internacao */
    and trim(import-guia.ind-tip-guia) <> "P" /* Prorrogacao */
    and trim(import-guia.ind-tip-guia) <> "C" /* Consulta */
    and trim(import-guia.ind-tip-guia) <> "O" /* Odontologia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo da guia informado invalido: " + string(import-guia.ind-tip-guia),
                          input today,
                          input "Informe um valor valido para o campo: S, I, P, C, O").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia.ind-sit-guia <> "1"  /* Digitada */
    and import-guia.ind-sit-guia <> "2"  /* Autorizada */
    and import-guia.ind-sit-guia <> "3"  /* Cancelada */
    and import-guia.ind-sit-guia <> "4"  /* Processada pelo contas */
    and import-guia.ind-sit-guia <> "5"  /* Fechada */
    and import-guia.ind-sit-guia <> "6"  /* Orcamento */
    and import-guia.ind-sit-guia <> "7"  /* Faturada */
    and import-guia.ind-sit-guia <> "8"  /* Negada */
    and import-guia.ind-sit-guia <> "9"  /* Pendente Auditoria */
    and import-guia.ind-sit-guia <> "10" /* Pendente Liberacao */
    and import-guia.ind-sit-guia <> "11" /* Pendente Laudo Medico */
    and import-guia.ind-sit-guia <> "12" /* Pendente Justificativa Medica */
    and import-guia.ind-sit-guia <> "13" /* Pendente Pericia */
    and import-guia.ind-sit-guia <> "19" /* Em auditoria */
    and import-guia.ind-sit-guia <> "20" /* Em atendimento */
    and import-guia.ind-sit-guia <> "23" /* Em pericia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Situacao da guia informada invalido",
                          input today,
                          input "Informe um valor valido para o campo.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if import-guia.cod-guia-operdra = ?
    or import-guia.cod-guia-operdra = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Numero da guia no Unicoo nao informado.",
                          input today,
                          input "Informe o campo referente ao numero da guia no Unicoo: import-guia.cod-guia-operdra").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    find tranrevi where tranrevi.cd-transacao = import-guia.cd-transacao no-lock no-error.

    if not avail tranrevi
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Transacao " 
                              + string(import-guia.cd-transacao) 
                              + " nao cadastrada.",
                          input today,
                          input "Informe um numero de transacao cadastrado no Gestao de Planos").
           
           assign lg-erro-par = yes.
         end.

   /* ------------------------- PRESTADOR SOLICITANTE ---------------------------------------- */
   run consiste-prestador-solicitante(input-output lg-erro-par).

   /* ------------------------- CONSISTE BENEFICIARIO ------------------------------------*/
   run consiste-beneficiario(input-output lg-erro-par).

   /* ------------------- CONSISTE PRESTADOR PRINCIPAL ---------------------------------- */
   run consiste-prestador-principal(input-output lg-erro-par).

  /* ------------------------------------- CLINICA --------------------------------- */
  if import-guia.cd-clinica > 0
  then do:
         if not can-find(clinicas where clinicas.cd-clinica = import-guia.cd-clinica)
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Clinica nao cadastrada: "
                                   + string(import-guia.cd-clinica,"99999999"),
                               input today,
                               input "Informe um codigo de clinica valido.").
         
                assign lg-erro-par = yes.
              end.
         
         if not can-find(clinpres where clinpres.cd-clinica   = import-guia.cd-clinica            
                                    and clinpres.cd-unidade   = import-guia.cd-unidade-principal  
                                    and clinpres.cd-prestador = import-guia.cd-prestador-principal)
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Prestador principal nao esta vinculado a clinica informada.",
                               input today,
                               input "O prestador principal deve estar vinculado a clinica. Verifique o cadastro ac0210h").
         
                assign lg-erro-par = yes.
              end.
       end.

  /* -------------------------------- TIPO DE GUIA ----------------------------------- */
  find tip-guia where tip-guia.cd-tipo-guia = import-guia.cd-tipo-guia no-lock no-error.
  if not avail tip-guia
  then do:
         run grava-erro(input import-guia.num-seqcial-control,
                        input "import-guia",
                        input "Tipo de Guia nao cadastrado: " + string(import-guia.cd-tipo-guia),
                        input today,
                        input "Informe um tipo de guia valido.").
         
         assign lg-erro-par = yes.
       end.

  /* --------------------------- LOCAL DE AUTORIZACAO ----------------------------- */
  if import-guia.num-livre-1 > 0
  then do:
         if not can-find(locaauto where locaauto.cd-local-autorizacao = import-guia.num-livre-1)
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Local de autorizacao nao cadastrado: " + string(import-guia.num-livre-1),
                               input today,
                               input "Informe um local de autorizacao cadastrado no Gestao de Planos.").
                
                assign lg-erro-par = yes.
              end.
       end.
  else do:
         if avail tip-guia
         and tip-guia.lg-trata-local-autorizacao
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Local de autorizacao deve ser informado.",
                               input today,
                               input "O tipo de guia informado exige a informacao do local de autorizacao.").
                
                assign lg-erro-par = yes.
              end.
       end.

  /* --------------- VERIFICA SE GUIA PRINCIPAL JA FOI CRIADA --------------------- */
  if import-guia.num-seqcial-princ > 0
  then do:
         find b-import-guia where b-import-guia.num-seqcial = import-guia.num-seqcial-princ
                                  no-lock no-error.

         if not avail b-import-guia
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Registro da guia principal nao encontrado",
                               input today,
                               input "A guia informada esta vinculada a uma guia principal. O registro "
                                     + "import-guia da guia principal nao foi encontrado").
                
                assign lg-erro-par = yes.
              end.
         else do:
                if b-import-guia.aa-guia-atendimento = 0
                or b-import-guia.nr-guia-atendimento = 0
                then do:
                       run grava-erro(input import-guia.num-seqcial-control,
                                      input "import-guia",
                                      input "Codigo da guia de autorizacao principal esta zerado.",
                                      input today,
                                      input "O codigo da guia principal esta igual a zero no registro import-guia "
                                            + "da guia principal").
                       
                       assign lg-erro-par = yes.
                     end.

                assign aa-guia-atend-ant-aux = b-import-guia.aa-guia-atendimento
                       nr-guia-atend-ant-aux = b-import-guia.nr-guia-atendimento.
              end.
       end.

  /* ----------------------- VALIDA CBO ----------------------------- */
  if  import-guia.cdn-cbo <> ?
  and import-guia.cdn-cbo <> 0
  then do:
         if not can-find(first dz-cbo02 where dz-cbo02.cd-cbo = import-guia.cdn-cbo) 
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "CBO informado nao cadastrado: " + string(import-guia.cdn-cbo),
                               input today,
                               input "Informe um CBO cadastrado no Gestao de Planos.").
                
                assign lg-erro-par = yes.
              end.
       end.

  /* ------------------- DATA DE EMISSAO ----------------------------- */
  if import-guia.dat-solicit = ?
  then do:
         run grava-erro(input import-guia.num-seqcial-control,
                        input "import-guia",
                        input "Data da solicitacao nao informada.",
                        input today,
                        input "Informe a data da solicitacao.").
         
         assign lg-erro-par = yes.
       end.

end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-beneficiario:

    def input-output parameter lg-erro-par as log no-undo.

    FIND FIRST usuario WHERE usuario.cd-carteira-antiga = import-guia.cd-carteira-usuario NO-LOCK NO-ERROR.

    if import-guia.cd-unidade-carteira <> paramecp.cd-unimed
    then do:
            FIND FIRST out-uni WHERE out-uni.cd-unidade          = import-guia.cd-unidade-carteira
                                 and out-uni.cd-carteira-usuario = import-guia.cd-carteira-usuario NO-LOCK NO-ERROR.
            if not avail out-uni 
            then do:
                   create out-uni. /* cria-out-uni quando nao existir na base */                   
                   assign out-uni.cd-unidade           = import-guia.cd-unidade-carteira
                          out-uni.cd-carteira-usuario  = import-guia.cd-carteira-usuario
                          out-uni.nm-usuario           = import-guia.nom-benef-intercam
                          out-uni.lg-sexo              = import-guia.log-livre-1 /* sexo*/
                          out-uni.dt-nascimento        = import-guia.dat-livre-1 /* data de nascimento*/
                          out-uni.dt-cadastro          = today
                          out-uni.dt-atualizacao       = today
                          out-uni.cd-userid            = v_cod_usuar_corren. 
                end.
         end.
          
    IF  NOT AVAIL usuario
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Benefici rio nÆo encontrado. Carteira informada: " + STRING(import-guia.cd-carteira-usuario),
                          input today,
                          input "Benefici rio nÆo encontrado").

           assign lg-erro-par = yes.
           return.
         END.

     IF AVAIL usuario
     THEN DO:
          
             
            ASSIGN cd-modalidade-aux = usuario.cd-modalidade 
                   nr-ter-adesao-aux = usuario.nr-ter-adesao
                   cd-usuario-aux    = usuario.cd-usuario.
            
            FOR FIRST propost FIELDS (cd-plano cd-tipo-plano)
                WHERE propost.cd-modalidade = usuario.cd-modalidade
                  AND propost.nr-ter-adesao = usuario.nr-ter-adesao NO-LOCK:
            
                ASSIGN cd-plano-aux      = propost.cd-plano 
                       cd-tipo-plano-aux = propost.cd-tipo-plano.
            END.

            FIND LAST car-ide 
                WHERE car-ide.cd-unimed      = paramecp.cd-unimed 
                  and car-ide.cd-modalidade  = usuario.cd-modalidade
                  and car-ide.nr-ter-adesao  = usuario.nr-ter-adesao
                  and car-ide.cd-usuario     = usuario.cd-usuario NO-LOCK NO-ERROR.
            
            IF AVAIL car-ide
            THEN ASSIGN cd-unidade-carteira-aux = car-ide.cd-unimed
                        cd-carteira-aux         = car-ide.cd-carteira-inteira
                        nr-carteira-aux         = car-ide.nr-carteira.                     

          END. 

     IF AVAIL out-uni
     THEN DO:
            ASSIGN cd-unidade-carteira-aux = out-uni.cd-unidade
                   cd-carteira-aux         = out-uni.cd-carteira-usuario
                   nr-carteira-aux         = 0.

            find first unicamco where unicamco.cd-unidade = out-uni.cd-unidade 
                                  and unicamco.dt-limite >= import-guia.dat-solicit
                                      no-lock no-error.
 
            if   not available unicamco
            then do:
                   run grava-erro(input import-guia.num-seqcial-control,
                                  input "import-guia",
                                  input "Associacao entre as Unidades e a camara de compensacao nÆo existe",
                                  input today,
                                  input "Tabela unicamco nÆo encontrada").
                   
                   assign lg-erro-par = yes.
                   return.
                 END.

            find unimed where unimed.cd-unimed = out-uni.cd-unidade no-lock no-error.

            if   not available unimed
            then do:
                   run grava-erro(input import-guia.num-seqcial-control,
                                  input "import-guia",
                                  input "Unidade de intercambio nÆo encontrada",
                                  input today,
                                  input "Unidade de intercambio nÆo encontrada").
                   
                   assign lg-erro-par = yes.
                   return.
                 END.

            ASSIGN cd-modalidade-aux = unicamco.cd-modalidade 
                   nr-ter-adesao-aux = 0
                   cd-usuario-aux    = 0
                   cd-plano-aux      = unicamco.cd-plano
                   cd-tipo-plano-aux = unicamco.cd-tipo-plano.
          END.

     FIND FIRST ti-pl-sa 
          WHERE ti-pl-sa.cd-modalidade = cd-modalidade-aux
            AND ti-pl-sa.cd-plano      = cd-plano-aux
            AND ti-pl-sa.cd-tipo-plano = cd-tipo-plano-aux NO-LOCK NO-ERROR.
    
     ASSIGN cd-cla-hos-aux = ti-pl-sa.cd-cla-hos WHEN AVAIL ti-pl-sa.
    
     FIND FIRST clashosp WHERE clashosp.cd-cla-hos = cd-cla-hos-aux NO-LOCK NO-ERROR.
    
     ASSIGN nr-indice-aux = clashosp.nr-indice-hierarquico WHEN AVAIL clashosp.

end procedure.


/* ----------------------------------------------------------------- */
procedure consiste-prestador-principal:

    def input-output parameter lg-erro-par as log no-undo.

    find preserv where preserv.cd-unidade   = import-guia.cd-unidade-principal  
                   and preserv.cd-prestador = import-guia.cd-prestador-principal
                       no-lock no-error.

    if not avail preserv
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Prestador principal nao encontrado. Unidade: "
                              + string(import-guia.cd-unidade-principal,"9999")
                              + " Prestador: "
                              + string(import-guia.cd-prestador-principal,"99999999"),
                          input today,
                          input "Informe um codigo valido para o prestador principal").

           assign lg-erro-par = yes.
         end.
    else do:
           run busca-vinculo-prestador(input  import-guia.cd-unidade-principal,
                                       input  import-guia.cd-prestador-principal,
                                       input  0,
                                       input  import-guia.dat-solicit,
                                       output cd-vinculo-principal-aux,
                                       output lg-erro-vinculo-aux). 
           
           if lg-erro-vinculo-aux
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Vinculo nao encontrado para o prestador principal",
                                 input today,
                                 input "Verifique se o prestador informado possui vinculo cadastrado.").
           
                  assign lg-erro-par = yes.
                end.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-prestador-solicitante:

    def input-output param lg-erro-par as log no-undo.

    if import-guia.cd-especialidade = ?
    or import-guia.cd-especialidade = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Especialidade do prestador solicitante nao informada.",
                          input today,
                          input "Informe um codigo para a especialidade do prestador solicitante").

           assign lg-erro-par = yes.
         end.

    find preserv where preserv.cd-unidade   = import-guia.cd-unidade-solic
                   and preserv.cd-prestador = int(import-guia.cd-prestador-solic)
                       no-lock no-error.

    if not avail preserv
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Prestador Solicitante informado nao cadastrado. Unidade: "
                              + string(import-guia.cd-unidade-solic,"9999")
                              + " Prestador: " 
                              + string(import-guia.cd-prestador-solic,"99999999"),
                          input today,
                          input "Informe um codigo de prestador cadastrado no Gestao de Planos.").

           assign lg-erro-par = yes.
           return.
         end.
    
    if preserv.in-tipo-pessoa = "J" /* Pessoa Juridica */
    then do:
           if import-guia.nom-prestdor-solic = ?
           or import-guia.nom-prestdor-solic = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Nome do prestador solicitante pessoa fisica nao informado.",
                                 input today,
                                 input "O prestador solicitante e pessoa juridica. Informe o nome do prestador solicitante pessoa fisica.").

                  assign lg-erro-par = yes.
                end.

           if import-guia.cod-cons-profis = ?
           or import-guia.cod-cons-profis = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Conselho do prestador solicitante pessoa fisica nao informado.",
                                 input today,
                                 input "O prestador solicitante e pessoa juridica. Informe o conselho profissional do prestador solicitante pessoa fisica.").

                  assign lg-erro-par = yes.
                end.
           else do:
                  if not can-find(conpres where conpres.cd-conselho = trim(import-guia.cod-cons-profis))
                  then do:
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia",
                                        input "Conselho do prestador solicitante pessoa fisica nao cadastrado.",
                                        input today,
                                        input "Informe um codigo de conselho cadastrado no Gestao de Planos.").

                         assign lg-erro-par = yes.
                       end.
                end.

           if import-guia.ind-nume-cons = ?
           or import-guia.ind-nume-cons = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Numero do registro do prestador solicitante pessoa fisica nao informado.",
                                 input today,
                                 input "O prestador solicitante e pessoa juridica. Informe o numero do registro doprestador solicitante pessoa fisica.").

                  assign lg-erro-par = yes.
                end.
         end.

    run busca-vinculo-prestador(input  import-guia.cd-unidade-solic,
                                input  int(import-guia.cd-prestador-solic),
                                input  import-guia.cd-especialid,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-solic-aux,
                                output lg-erro-vinculo-aux).

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Vinculo nao encontrado para o prestador solicitante e especialidade",
                          input today,
                          input "Verifique se o prestador informado possui vinculo associado a especialidade informada.").
           
           assign lg-erro-par = yes.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure busca-vinculo-prestador:

    def input  param cd-unidade-par   as int  no-undo.
    def input  param cd-prestador-par as int  no-undo.
    def input  param cd-espec-par     as int  no-undo.
    def input  param dt-base-par      as date no-undo.
    def output param cd-vinculo-par   as int  no-undo.
    def output param lg-erro-par      as log  no-undo.

    assign lg-erro-par = no.

    if cd-espec-par > 0
    then do:
           find first previesp where previesp.cd-especialid       = cd-espec-par
                                 and previesp.cd-unidade          = cd-unidade-par
                                 and previesp.cd-prestador        = cd-prestador-par
                                 and previesp.dt-inicio-validade <= dt-base-par
                                 and previesp.dt-fim-validade    >= dt-base-par
                                     no-lock no-error.
           
           if avail previesp
           then assign cd-vinculo-par = previesp.cd-vinculo.
           else assign lg-erro-par = yes.
         end.
    else do:
           for each previesp where previesp.cd-unidade   = cd-unidade-par  
                               and previesp.cd-prestador = cd-prestador-par
                               and previesp.lg-considera-qt-vinculo
                                   no-lock:

               if  previesp.dt-inicio-validade <= dt-base-par
               and previesp.dt-fim-validade    >= dt-base-par 
               then leave.
           end.

           if avail previesp
           then assign cd-vinculo-par = previesp.cd-vinculo.
           else do:
                  for each previesp where previesp.cd-unidade   = cd-unidade-par  
                                      and previesp.cd-prestador = cd-prestador-par
                                      and not previesp.lg-considera-qt-vinculo
                                          no-lock:
                  
                      if  previesp.dt-inicio-validade <= dt-base-par
                      and previesp.dt-fim-validade    >= dt-base-par 
                      then leave.
                  end.

                  if avail previesp
                  then assign cd-vinculo-par = previesp.cd-vinculo.
                  else assign lg-erro-par = yes.
                end.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-glosas:

    def input        param ind-tip-guia-par  as char format "x(4)" no-undo.
    def input        param val-seqcial-movto as int                no-undo.
    def input        param val-seq-guia      as int                no-undo.
    def input-output param lg-erro-par       as log                no-undo.

    for each import-movto-glosa
       where import-movto-glosa.in-modulo         = "AT"
         and import-movto-glosa.ind-tip-guia      = ind-tip-guia-par 
         and import-movto-glosa.val-seqcial-movto = val-seqcial-movto
         and import-movto-glosa.val-seq-guia      = val-seq-guia     
             no-lock:

        if not can-find(claserro where claserro.cd-classe-erro = import-movto-glosa.cd-classe-erro)
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-movto-glosa",
                              input "Classe de erro nao cadastrada: " + string(import-movto-glosa.cd-classe-erro),
                              input today,
                              input "Informe um codigo de classe de erro valido.").

               assign lg-erro-par = yes.
             end.

        if not can-find(first codiglos 
                        where codiglos.cd-classe-erro = import-movto-glosa.cd-classe-erro
                          and codiglos.cd-cod-glo     = import-movto-glosa.cd-cod-glo)
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-movto-glosa",
                              input "Glosa nao cadastrada: " + string(import-movto-glosa.cd-cod-glo),
                              input today,
                              input "Informe um codigo de glosa valido.").
               
               assign lg-erro-par = yes.
             end.
    end. /* each import-movto-glosa */

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-dados-movimento:

    def input-output param lg-erro-par as log no-undo.

    /* ------------------- VALIDA MODULO DE COBERTURA ------------------------- */
    if import-guia-movto.cd-modulo = ?
    or import-guia-movto.cd-modulo = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Modulo de cobertura nao informado.",
                          input today,
                          input "Informe um modulo de cobertura para o procedimento.").
           
           assign lg-erro-par = yes.
         end.

    if not can-find(mod-cob where mod-cob.cd-modulo = import-guia-movto.cd-modulo)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Modulo de cobertura nao cadastrado.",
                          input today,
                          input "Informe um modulo de cobertura cadastrado no Gestao de Planos.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------- VALIDA MOVIMENTO --------------------------- */
    if import-guia-movto.ind-tip-movto-guia = "P"
    then do:
           assign cd-esp-amb-aux        = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2))
                  cd-grupo-proc-amb-aux = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2))
                  cd-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3))
                  dv-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1)).

           if not can-find(ambproce where ambproce.cd-esp-amb        = cd-esp-amb-aux
                                      and ambproce.cd-grupo-proc-amb = cd-grupo-proc-amb-aux
                                      and ambproce.cd-procedimento   = cd-procedimento-aux
                                      and ambproce.dv-procedimento   = dv-procedimento-aux)
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-movto",
                                 input "Procedimento nao cadastrado: " + string(import-guia-movto.cod-movto-guia),
                                 input today,
                                 input "Informe um codigo de procedimento valido.").

                  assign lg-erro-par = yes.
                end.

           if not can-find(first pl-mo-am where pl-mo-am.cd-modalidade          = cd-modalidade-aux
                                            and pl-mo-am.cd-plano               = cd-plano-aux
                                            and pl-mo-am.cd-tipo-plano          = cd-tipo-plano-aux
                                            and pl-mo-am.cd-amb                 = int(import-guia-movto.cod-movto-guia)
                                            and pl-mo-am.cd-modulo              = import-guia-movto.cd-modulo)
           then do:
                  if not can-find(first plamodpr where plamodpr.cd-modalidade          = cd-modalidade-aux                           
                                                   and plamodpr.cd-plano               = cd-plano-aux                                
                                                   and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux                           
                                                   and plamodpr.in-procedimento-insumo = "P"                                         
                                                   and plamodpr.cd-modulo              = import-guia-movto.cd-modulo)                
                  then do:                                                                                                           
                         run grava-erro(input import-guia.num-seqcial-control,                                                       
                                        input "import-guia-movto",                                                                   
                                        input "Tabela padrao de moedas e carencias nao encontrada para a estrutura neste modulo." ,  
                                        input today,                                                                                 
                                        input "").                                                                                   
                                                                                                                                     
                         assign lg-erro-par = yes.                                                                                   
                       end.                                                                                                          
                end.

         end.
    else do:
           assign cd-tipo-insumo-aux = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),1,2))
                  cd-insumo-aux      = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),3,8)).

           find first insumos where insumos.cd-insumo      = int(import-guia-movto.cod-movto-guia)
                              no-lock no-error.

           if not avail insumos
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-movto",
                                 input "Insumo nao cadastrado: " + string(import-guia-movto.cod-movto-guia),
                                 input today,
                                 input "Informe um codigo de insumo valido.").

                  assign lg-erro-par = yes.
                end.
           else do:
                  if import-guia-movto.ind-tip-guia = "OPME"
                  and not insumos.lg-opme
                  then do:
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia-movto",
                                        input "Insumo nao e do tipo OPME: "
                                              + import-guia-movto.cod-movto-guia,
                                        input today,
                                        input "Para anexos OPME, os insumos informados deve ser do tipo OPME.").

                         assign lg-erro-par = yes.
                       end.
                end.

            if not can-find(partinsu where partinsu.cd-modalidade  = cd-modalidade-aux    
                                       and partinsu.cd-plano       = cd-plano-aux         
                                       and partinsu.cd-tipo-plano  = cd-tipo-plano-aux    
                                       and partinsu.cd-insumo      = int(import-guia-movto.cod-movto-guia)  
                                       and partinsu.cd-modulo      = import-guia-movto.cd-modulo )
            then do:                                                                                                        
                   if not can-find(first plamodpr where plamodpr.cd-modalidade          = cd-modalidade-aux
                                                    and plamodpr.cd-plano               = cd-plano-aux
                                                    and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                                                    and plamodpr.in-procedimento-insumo = "I"
                                                    and plamodpr.cd-modulo              = import-guia-movto.cd-modulo)
                   then do:
                          run grava-erro(input import-guia.num-seqcial-control,
                                         input "import-guia-movto",
                                         input "Tabela padrao de moedas e carencias nao encontrada para a estrutura neste modulo." ,
                                         input today,
                                         input "").
               
                          assign lg-erro-par = yes.
                      end.
                end.
         end.

    /* -------------- QUANTIDADE SOLICITADA ---------------------------- */
    if import-guia-movto.qtd-solicitad = ?
    or import-guia-movto.qtd-solicitad = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Quantidade solicitada do movimento nao informada.",
                          input today,
                          input "Informe a quantidade solicitada do movimento").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------- */
    if import-guia-movto.num-livre-2 > 0 /* Classe de erro */
    then do:
           if not can-find(claserro where claserro.cd-classe-erro = import-guia-movto.num-livre-2)
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-movto",
                                 input "Classe de erro nao cadastrada: " + string(import-guia-movto.num-livre-2),
                                 input today,
                                 input "Informe um codigo de classe de erro valido.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    /* ------------------------------------------------------------- */
    if import-guia-movto.num-livre-1 > 0 /* Codigo da glosa */
    then do:
           if not can-find(first codiglos 
                           where codiglos.cd-classe-erro = import-guia-movto.num-livre-2
                             and codiglos.cd-cod-glo     = import-guia-movto.num-livre-1)
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-movto",
                                 input "Glosa nao cadastrada: " + string(import-guia-movto.num-livre-1),
                                 input today,
                                 input "Informe um codigo de glosa vinculado a classe de erro informada.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    /* ------------- VALIDACAO GLOSA COBRANCA --------------------- */
    if  import-guia-movto.num-livre-3 <> 0
    and import-guia-movto.num-livre-3 <> 1
    and import-guia-movto.num-livre-3 <> 3
    and import-guia-movto.num-livre-3 <> 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Validacao da glosa para cobranca invalida: " + string(import-guia-movto.num-livre-3),
                          input today,
                          input "Informe 0, 1, 3, ou 4.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------- VALIDACAO GLOSA PAGAMENTO --------------------- */
    if  import-guia-movto.num-livre-4 <> 0
    and import-guia-movto.num-livre-4 <> 1
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Validacao da glosa para pagamento invalida: " + string(import-guia-movto.num-livre-4),
                          input today,
                          input "Informe 0 ou 1").

           assign lg-erro-par = yes.
         end.

    /* ------------- VALIDACAO GLOSA ------------------------------- */
    if  import-guia-movto.cd-validacao <> 0 
    and import-guia-movto.cd-validacao <> 1
    and import-guia-movto.cd-validacao <> 3
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Indicador de validacao da glosa invalido: " + string(import-guia-movto.cd-validacao),
                          input today,
                          input "Informe 0, 1 ou 3").
           
           assign lg-erro-par = yes.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure atualiza-import-guia:

    def input parameter ind-status-par          as char no-undo.
    def input parameter cd-unidade-par          as int  no-undo.
    def input parameter aa-guia-atendimento-par as int  no-undo.
    def input parameter nr-guia-atendimento-par as int  no-undo.

    def buffer b-import-guia for import-guia.

    find b-import-guia where recid(b-import-guia) = recid(import-guia)
                             exclusive-lock no-error.

    if avail b-import-guia
    then do:
           assign b-import-guia.cd-unimed           = cd-unidade-par         
                  b-import-guia.aa-guia-atendimento = aa-guia-atendimento-par
                  b-import-guia.nr-guia-atendimento = nr-guia-atendimento-par
                  b-import-guia.ind-sit-import      = ind-status-par.
         end.

    find control-migrac where control-migrac.num-seqcial = import-guia.num-seqcial-control
                              exclusive-lock no-error.

    if avail control-migrac
    then assign control-migrac.ind-sit-import   = ind-status-par
                control-migrac.dat-integr       = today
                control-migrac.dt-processamento = today.

    validate b-import-guia.
    release b-import-guia.

    validate control-migrac.
    release control-migrac.

end procedure.

/* ----------------------------------------------------------------- */
procedure gera-rel-erro:
    
    /*****************************************************************************
*      Programa .....: hdmonarq.i                                            *
*      Data .........: 21 de Agosto de 2000                                  *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: RT - Rotinas do Sistema                               *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Abertura do arquivo de saida com opcao de informar    *
*                      page-size.                                            *
******************************************************************************
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*      D.00.000  20/01/1998  Nora           Desenvolvimento                  *
*      D.01.000  04/09/2000  Nora           Desvincular do magnus            *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
*****************************************************************************/
/*****************************************************************************
* hdmonarq.i - Abertura do arquivo de saida com opcao de informar page-size. *
* parametros: {&stream}    = nome do stream de saida no formato "stream nome"*
*             {&append}    = append                                          *
*             {&page-size} = numero de linhas do arquivo de saida            *
*             {&numarq}    = numero do arquivo de saida como string          *
*****************************************************************************/
if   l-saida
then do:

       if   in-saida = 2
       then do:
              find dzimpres where dzimpres.nm-impressora = c-nome-imp
                   no-lock no-error.
              if   not avail dzimpres
              then output  to printer paged page-size 64 convert target session:cpinternal.      
              else do:
                  
                     if   dzimpres.lg-escrava
                     then output  to value(c-saida)
                          paged page-size 64  convert target session:cpinternal.
                     else if   opsys = "unix"
                          then output  through value(dzimpres.ds-dispositivo)
                               paged page-size 64 unbuffered convert target session:cpinternal.
                          else do:
                                 if "MS-WINXP" = "TTY"
                                 then output  to value(dzimpres.ds-dispositivo) paged page-size 64  convert target session:cpinternal.
                                 else do:
                                        if os-getenv("OS") <>  "Windows_NT"  
                                        then output  to value(dzimpres.ds-dispositivo) paged page-size 64  convert target session:cpinternal.
                                        else do:
                                               assign session:printer-name = trim(dzimpres.ds-dispositivo) no-error.
                                               if   error-status:num-messages <> 0
                                               then output  to value(dzimpres.ds-dispositivo) paged page-size 64  convert target session:cpinternal.
                                               else output  to printer paged page-size 64  convert target session:cpinternal.
                                             end.
                                      end.
                               end.


                     run "tep/teoctdec.p" (dzimpres.ds-controle-inicial,
                                           output c-yyytmp).
              
                     put  control c-yyytmp.
                   end.
              
              release dzimpres.
            end.
       else do:           
              output  to value(nm-arquivo-windows-aux) paged page-size value(nr-linhas-windows-aux)  convert target session:cpinternal.              
            end.
     end.
else do:
         
       if "" = ""
       then output  to value(c-arquivo[ 1 ])
                   paged page-size 64  convert target session:cpinternal.
       else do:
              output  to value(c-arquivo[ int("") ])
                     paged page-size 64  convert target session:cpinternal.
            end.
     end.

 

    view frame f-cabecalho.
    view frame f-rodape.

    for each tmp-erro no-lock:
        disp tmp-erro.num-seqcial-control
             tmp-erro.nom-tab-orig-erro  
             tmp-erro.des-erro           
             with frame f-rel.
        down with frame f-rel.
    end.

    /*****************************************************************************
*      Programa .....: hdclosed.i                                            *
*      Data .........: 21 de Agosto de 2000                                  *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: RT - Rotinas do Sistema                               *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Fechamento de arquivos de saida                       *
******************************************************************************
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*      D.00.000  20/01/1998  Nora           Desenvolvimento                  *
*      D.01.000  04/09/2000  Nora           Desvincular do magnus            *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco            *
****l**************************************************************************
* Parametros : &stream = nome do stream a ser fechado                        *
*****************************************************************************/

case in-saida:
    when 1
        then do:
               output  close.
               
               case nr-fonte-windows-aux:
                   when 1
                   then assign nr-fonte-windows-aux  = 15. 
                   when 2
                   then assign nr-fonte-windows-aux  = 16. 
                   when 3
                   then assign nr-fonte-windows-aux  = 17. 
               end case.
               
               run hdp/hdprintwindow.p (current-window,
                                        nm-arquivo-windows-aux,
                                        nr-fonte-windows-aux,
                                        0,
                                        nr-linhas-windows-aux,
                                        nr-pagina-windows-aux,
                                        output lg-ok-imprime-windows-aux).
              
               os-delete value(nm-arquivo-windows-aux).
             end.
    when 2
        then do:
               find dzimpres where dzimpres.nm-impressora
                            = c-nome-imp no-lock no-error.
               if  l-saida
               and avail dzimpres
               then do:
                      page.
                      run "tep/teoctdec.p" (dzimpres.ds-controle-final, output c-yyytmp).
                      put  control c-yyytmp.
                      output  close.
                      pause 0.
                      if  dzimpres.lg-escrava
                      then do:
                             if  opsys = "unix"
                             then unix echo value(dzimpres.ds-ini-escrava);
                             cat value(c-saida);
                             echo value(dzimpres.ds-fim-escrava);
                             sleep 20;
                             rm -f value(c-saida).
                             if  opsys = "vms"
                             then vms type value(c-saida).
                           end.
                    end.
               else output  close.
             end.
    when 3
        then do:
               output  close.
             end.
end case.

/* ----------------------------------------------------------------------------------------------------
       SE A EXTENSAO DO ARQUIVO FOR HTM OU HTML, ABRE NO INTERNET EXPLORER. CASO CONTRARIO ABRE
       CONFORME PARAMETRIZADO EM PARAMECP. SE AMBIENTE FOR TTY, NAO ABRE HTM E HTML
   ------------------------------------------------------------------------------------------------- */
if lg-ver-tela-aux
then do:
       assign nm-arq-tela-quo = c-arquivo[1].

       if   "MS-WINXP" <> "TTY"
       then do:
              find first paramecp no-lock no-error.
              if   available paramecp
              then do:
                     /* --- VERIFICA SE EXTENSAO DO ARQUIVO DE RELATORIO Eh HTM OU HTML --- */
                     if r-index(nm-arq-tela-quo,".") > 0
                     and  index(substr(nm-arq-tela-quo,r-index(nm-arq-tela-quo,".") + 1, 4),"htm") > 0
                     then do:
                            assign file-info:file-name = nm-arq-tela-quo.
                            if file-info:full-pathname <> ?
                            then do:
                                   os-command no-wait Value(trim("start iexplore ")) value(file-info:full-pathname).
                                   assign lg-ver-tela-aux = no.
                                 end.
                          end.
                     else do:
                            if   paramecp.nm-editor-windows <> ""
                            then do:
                                   os-command no-wait Value(trim("start " + paramecp.nm-editor-windows)) value(nm-arq-tela-quo).
                                   assign lg-ver-tela-aux = no.
                                 end.
                          end.

                     /* --- VERIFICA SE EXTENSAO DO ARQUIVO DE ERROS Eh HTM OU HTML --- */
                     if c-arquivo[2] <> ""
                     then if r-index(c-arquivo[2],".") > 0
                          and  index(substr(c-arquivo[2],r-index(c-arquivo[2],".") + 1, 4),"htm") > 0
                          then do:
                                 assign file-info:file-name = c-arquivo[2].
                                 if file-info:full-pathname <> ?
                                 then os-command no-wait Value(trim("start iexplore ")) value(file-info:full-pathname).
                               end.
                          else os-command no-wait Value(trim("start " + paramecp.nm-editor-windows)) value(c-arquivo[2]).

                   end. /* available paramecp */
            end. /* <> "TTY" */

       if  lg-ver-tela-aux
       and index(substr(nm-arq-tela-quo,r-index(nm-arq-tela-quo,".") + 1, 4),"htm") = 0
       then do:
              message " Gerando dados para tela, Aguarde...".
             
              for each disp-tela:
                  delete disp-tela.
              end.
             
              input from value(nm-arq-tela-quo).
             
              repeat:
                    assign ds-campo-imp-quo = "".

                    import unformatted ds-campo-imp-quo.
                                       ds-campo-imp-quo = replace(ds-campo-imp-quo,chr(12),"").
                                       ds-campo-imp-quo = replace(ds-campo-imp-quo,chr(15),"").
                                       ds-campo-imp-quo = replace(ds-campo-imp-quo,chr(18),"").
                                       ds-campo-imp-quo = replace(ds-campo-imp-quo,chr(27),"").
                                       
                    if ds-campo-imp-quo <> ""
                    then do:
                           create disp-tela.
                           assign disp-tela.ds-linha1 = substr(ds-campo-imp-quo,1,77)
                                  disp-tela.ds-linha2 = substr(ds-campo-imp-quo,77,154).
                         end.
              end.
             
              hide message no-pause.
             
              find first disp-tela no-lock no-error.
              if available disp-tela
              then do:
                     open query zoom-tela for each disp-tela no-lock.
                     update browse-disp-tela with frame f-disp-tela.
                   end.
            end.
     end.

/* fim */
 
    hide message no-pause.

end procedure.




