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
assign c_prg_vrs = "2.00.00.006".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'CG0410F':U, '2.00.00.006':U, '':U).
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

        &if '' > '1.00' &then
        IF p_cod_program = "" OR p_cod_program = ? THEN DO:
            find emsbas.prog_dtsul 
                where emsbas.prog_dtsul.nom_prog_ext = p_cod_program_ext 
                no-lock no-error.
            if  avail emsbas.prog_dtsul
            then do:
                ASSIGN p_cod_program = emsbas.prog_dtsul.cod_prog_dtsul.
            end.
            ELSE DO:
                ASSIGN p_cod_program = p_cod_program_ext.
            END.
        END.
        &endif        

        put stream s-arq unformatted
            p_cod_program            at 1 
            p_cod_program_ext        at 43 
            p_cod_version            at 69 
            today                    at 84 
            string(time, 'HH:MM:SS') at 94 skip.

        if  p_cod_program_type = 'pro' then do:
            &if '' > '1.00' &then
            find emsbas.prog_dtsul 
                where emsbas.prog_dtsul.cod_prog_dtsul = p_cod_program 
                no-lock no-error.
            if  avail emsbas.prog_dtsul
            then do:
                &if '' > '5.00' &then
                    if  emsbas.prog_dtsul.nom_prog_dpc <> '' then
                        put stream s-arq 'DPC : ' at 5 emsbas.prog_dtsul.nom_prog_dpc  at 15 skip.
                &endif
                if  emsbas.prog_dtsul.nom_prog_appc <> '' then
                    put stream s-arq 'APPC: ' at 5 emsbas.prog_dtsul.nom_prog_appc at 15 skip.
                if  emsbas.prog_dtsul.nom_prog_upc <> '' then
                    put stream s-arq 'UPC : ' at 5 emsbas.prog_dtsul.nom_prog_upc  at 15 skip.
            end /* if */.
            &endif
        end.

        if  p_cod_program_type = 'dic' then do:
            &if '' > '1.00' &then
            assign v_cod_event_dic = ENTRY(1,p_cod_program ,'/':U)
                   v_cod_tabela    = ENTRY(2,p_cod_program ,'/':U). /* FO 1100.980 */
            find emsbas.tab_dic_dtsul 
                where emsbas.tab_dic_dtsul.cod_tab_dic_dtsul = v_cod_tabela 
                no-lock no-error.
            if  avail emsbas.tab_dic_dtsul
            then do:
                &if '' > '5.00' &then
                    if  emsbas.tab_dic_dtsul.nom_prog_dpc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                        put stream s-arq 'DPC-DELETE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_dpc_gat_delete  at 25 skip.
                &endif
                if  emsbas.tab_dic_dtsul.nom_prog_appc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'APPC-DELETE: ' at 5 emsbas.tab_dic_dtsul.nom_prog_appc_gat_delete at 25 skip.
                if  emsbas.tab_dic_dtsul.nom_prog_upc_gat_delete <> '' and v_cod_event_dic = 'Delete':U then
                    put stream s-arq 'UPC-DELETE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_upc_gat_delete  at 25 skip.
                &if '' > '5.00' &then
                    if  emsbas.tab_dic_dtsul.nom_prog_dpc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                        put stream s-arq 'DPC-WRITE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_dpc_gat_write  at 25 skip.
                &endif
                if  emsbas.tab_dic_dtsul.nom_prog_appc_gat_write <> '' and v_cod_event_dic = 'Write':U then
                    put stream s-arq 'APPC-WRITE: ' at 5 emsbas.tab_dic_dtsul.nom_prog_appc_gat_write at 25 skip.
                if  emsbas.tab_dic_dtsul.nom_prog_upc_gat_write <> '' and v_cod_event_dic = 'Write':U  then
                    put stream s-arq 'UPC-WRITE : ' at 5 emsbas.tab_dic_dtsul.nom_prog_upc_gat_write  at 25 skip.
            end /* if */.
            &endif
        end.

        output stream s-arq close.
    end /* if */.

END PROCEDURE. /* pi_version_extract */
  /*** 010006 ***/

&IF "" >= "1.00" &THEN

&ENDIF

/******************************************************************************
    Programa .....: 
    Data .........: 28/08/2015
    Empresa ......: TOTVS Saude
    Programador ..: Mauricio Faoro 
    Objetivo .....: Migracao de faturas
*******************************************************************************/
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
     
     




 
 

/*****************************************************************************
*      Programa .....: hdregparexec.i                                        *
*      Data .........: 06 de Marco de 2003                                   *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: HDP includes padraes                                  *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Definicao de regua e botao executa com parametro      *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*      7.00.000  06/03/2003  Nora           Desenvolvimento                  *
*****************************************************************************/

/* ---------------------------------------------------- REGUAS PARA UNIX --- */
def var tb-parexec as char extent 4 initial ["Parametro",
                                             "Executa",
                                             "Funcao",
                                             "Fim"]                   no-undo.

 

/*****************************************************************************
*      Programa .....: hdregparexec.f                                        *
*      Data .........: 06 de Marco de 2003                                   *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: HDP includes padraes                                  *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Definicao de frames da regua executa com parametro    *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*****************************************************************************/

/* --------------------------------------------------- FRAMES PARA UNIX --- */
form tb-parexec[1] format "x(9)"
     tb-parexec[2] format "x(7)"
     tb-parexec[3] format "x(6)"
     tb-parexec[4] format "x(3)"
     with no-labels attr row 21 no-box overlay centered frame f-parexec.

/* ----------------------------------------------- FRAMES PARA WINDOWS --- */                
DEFINE FRAME f-regua-parexec
     b-parametro AT ROW 1.48 COL 28
     b-executa AT ROW 1.48 COL 32
     b-funcao AT ROW 1.48 COL 54
     b-fim AT ROW 1.48 COL 58
     b-help AT ROW 1.48 COL 62
     Retangulo-1 AT ROW 1 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY CENTERED
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 3.

 

def var cd-evento-aux                  like evenfatu.cd-evento         no-undo. 
def new shared var cd-evento-z         like evenfatu.cd-evento         no-undo.
def new shared var ds-evento-z         like evenfatu.ds-evento         no-undo.
def new shared var  cd-retorno         as log                          no-undo.
def new shared var  in-entidade-aux    like evenfatu.in-entidade       no-undo.
def            var  lg-parametro-aux   as log                          no-undo. 
def            var  qt-registros       as int                          no-undo. 
def            var  percent-concluido  as dec format ">>9,99"          no-undo.
def            var  percent-erros      as dec format ">>>>>>>9.99"          no-undo.
def buffer b-migrac-fatur for migrac-fatur. 
DEF BUFFER b-fatura       FOR fatura. 

/* -------------------------------FRAMES------------------------------------- */
def frame f-parametros 
    cd-evento-aux   label "Evento para Importacao Faturas"
                    view-as fill-in size 4 by 1.3
    evenfatu.ds-evento no-label
                    view-as fill-in size 41 by 1.3
   with centered side-labels overlay three-d title "Parametros". 

def frame f-acompanhamento 
    qt-registros label "Quantidade de Registros"
                       view-as fill-in size 10 by 1.3
    percent-concluido label "% Importado" 
                      view-as fill-in size 6 by 1.3
    percent-erros     label "% Erros"
                      view-as fill-in size 6 by 1.3
    with centered side-labels overlay three-d title "Acompanhamento". 

/* -------------------------------------------------------------------------- */

/* -------------------- Definicao de PRE-PROCESSOS de Cabecalho ------------- */

/* variavel nm-cab-usuario = deve ser usada quando o programador deseja um
                             cabecalho diferente do padrao.

   variavel nm-cabecalho   = Cabecalho do programa so e necessario preencher
                             no programa principal e seu tamanho maximo e:
                             31 posicoes format "x(31)" .

   variavel nm-tp-prog     = Variavel que indica o tipo do programa:
                             inclusao alteracao etc. Seu tamanho deve ser
                             10 posicoes preenchendo com espacos na frente
                             quando necessario.

   variavel nm-prog        = Variavel que indica o nome do programa:
                             Devera ser preenchido sempre em maiusculas.

----------------------------------------------------------------------------- */

def var nm-cab-usuario          as char format "x(40)"                  no-undo.
def var espacos                 as char format "x(40)"                  no-undo.
def var nr-posicao              as integer                              no-undo.
def new shared var nm-cabecalho as char format "x(40)"                  no-undo.
def var c-versao                as char format "x(08)"                  no-undo.
def var nm-tp-prog              as char format "x(10)"                  no-undo.
def var nm-prog                 as char format "x(09)"                  no-undo.
def new shared var in-implanta  as char format "x(01)" initial "M"      no-undo.
def new shared var lg-tipo-zoom as log                                 no-undo.

def var nm-arquivo-windows-aux   as character                          no-undo.
def var nr-linhas-windows-aux    as int init 64  format "9999"         no-undo.
def var nr-pagina-windows-aux    as integer                            no-undo.
def var nr-fonte-windows-aux     as int init 1                         no-undo.
def var lg-ok-imprime-windows-aux as logical                           no-undo.

on window-close of current-window
do:
  return no-apply.
end.

/* variavel in-implanta criada para o multiplanta */
espacos = fill(" ",40).

 
assign nm-cab-usuario = "Migracao de Faturas".
       nm-prog        = " cg0410f ".
       c-versao       = c_prg_vrs.
       
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
                          format "x(12)":U label "Usu·rio Corrente"
                                        column-label "Usu·rio Corrente" no-undo.       
def new global shared var in-origem-chamada-menu as character format "x(12)"    
                                                                        no-undo.
/* ----------------------------- testa se Serious 7.0 ou GESTAO DE PLANOS ---*/
/* ------------- CASO FOR GESTçO DE PLANOS RETORNA A VERSçO DO ROUNTABLE --- */
if in-origem-chamada-menu <> "TEMENU70"
then assign c-versao      = c_prg_vrs. 

if session:multitasking-interval = 1
then do:
       run rtp/rthdlog.p (input c-versao,
                          input program-name(1)).
     end.
    
 


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

&if "MS-WINXP" = "tty"
&then do:
        define frame hdtitrela
        "                                                                              "
        skip
        "                                                                              "
        skip
        "                                                                              "
        skip
        "                                                                         " 
        skip
        "                                                                         " skip
        "                                                                         " skip
        "                                                                         " skip
        "                                                                         " skip
        "                                                                         " skip
        "                                                                         " skip(2)
        with centered row 1 no-labels no-box.
      end.
&endif.



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
       size 80 by &if "~{&window-system~}" = "TTY" &then 1MS-WINXP &else .1 &endif.

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

 

assign lg-btn-executa   = yes
       in-entidade-aux  = 'FT'
       lg-parametro-aux = no.
/* -------------------------------------------------------------------------- */
repeat on endkey undo, retry:

     hide frame f-parametros.

    hide message no-pause.
    
/*****************************************************************************
*      Programa .....: hdbotparexec.i                                        *
*      Data .........: 06 de Marco de 2003                                   *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                       *
*      Sistema ......: Includes padroes                                      *
*      Programador ..: Airton Nora                                           *
*      Objetivo .....: Ativa regua e botoes executa com parametro            *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                           *
*****************************************************************************/

&if "MS-WINXP" = "TTY"
&then do:
        do with frame f-parexec:
           disp tb-parexec with frame f-parexec.
           choose field tb-parexec auto-return
                  go-on("get" "put" "recall" "clear")
                  with frame f-parexec.
           assign c-opcao = frame-value.
        end.
      end.
&else do:
        /* ----- Botao comum em todos os programas e reguas --- */
        on choose of b-help in frame f-regua-parexec
        do:
          c-opcao = replace(b-help:label in frame f-regua-parexec,"&","").
          run rtp/rtexibehelp.p.
        end.

        on end-error of b-help in frame f-regua-parexec
        do:
          return no-apply.
        end.
        
        on choose of b-fim in frame f-regua-parexec
        do:
          c-opcao = replace(b-fim:label in frame f-regua-parexec,"&","").
        end.
        
        on end-error of b-fim in frame f-regua-parexec
        do:
          return no-apply.
        end.

        on choose of b-parametro in frame f-regua-parexec
        do:
          c-opcao = replace(b-parametro:label in frame f-regua-parexec,"&","").
        end.
        
        on end-error of b-parametro in frame f-regua-parexec
        do:
          return no-apply.
        end.

        on choose of b-executa in frame f-regua-parexec
        do:
          c-opcao = replace(b-executa:label in frame f-regua-parexec,"&","").
        end.
        
        on end-error of b-executa in frame f-regua-parexec
        do:
          return no-apply.
        end.
        
        on end-error of b-funcao in frame f-regua-parexec
        do:
          return no-apply.
        end.

        on choose of b-funcao in frame f-regua-parexec
        do:
          c-opcao = replace(b-funcao:label in frame f-regua-parexec,"&","").
        end.

        enable b-parametro b-executa b-fim b-help b-funcao
               with frame f-regua-parexec.

        if   not lg-btn-executa
        then disable b-executa with frame f-regua-parexec.
        if   not lg-btn-funcao
        then disable b-funcao with frame f-regua-parexec.


        wait-for choose of b-parametro
              or choose of b-executa or choose of b-fim
              or choose of b-help    or choose of b-funcao 
              or put of current-window
              or get of current-window
              or recall of current-window
              or clear of current-window in frame f-regua-parexec.

        disable b-parametro b-executa b-fim b-help b-funcao
                with frame f-regua-parexec.

      end.
&endif
 

    case c-opcao:
        when "Parametro"
        then do on error undo, retry with frame f-parametros:
                
                update cd-evento-aux auto-return
                 HELP "F5 para Zoom"
                 
/* fp0310b.i*/
editing:
  cd-retorno = no.
  readkey.
  if   keyfunction(lastkey) = "get"
  then run fpp/fp0316b.p.
  else apply lastkey.
 
                 if   cd-evento-z <> ?
                 and  cd-retorno
                 then display cd-evento-z @ cd-evento-aux. end. 

                 find evenfatu where evenfatu.in-entidade = "FT"
                                 and evenfatu.cd-evento   = cd-evento-aux no-lock no-error. 

                 if avail evenfatu
                 then disp evenfatu.ds-evento. 
                 else do:
                         message "Evento nao cadastrado!"
                         view-as alert-box title "Atencao !!!".
                      end.
                hide frame f-parametros.
                assign lg-parametro-aux = yes.
             end.

        when "Executa"
        then do:
                if not lg-parametro-aux
                then do:
                         message "Acessar primeiro os parametros"
                         view-as alert-box title "Atencao !!!".
                         
                     end.
                else do:
                        run executa-processo (input cd-evento-aux) .
                        message "Processo concluido."
                                 view-as alert-box title "Atencao !!!".
                     end.
             end.

        when "Fim"
        then do:
                hide all no-pause.
                leave.
             end.
    end case.
end.

procedure executa-processo:
    def input parameter cd-evento-par   as integer            no-undo. 
    def var   nr-fatura-aux             as integer            no-undo. 
    def var   nr-sequencia-aux          as integer            no-undo.
    def var   qt-lidos-aux              as int                no-undo. 
    DEF VAR lg-erro-jm-aux              AS LOG                NO-UNDO. 
    
    
    find first parafatu no-lock no-error. 
    
    find evenfatu where evenfatu.in-entidade = "FT"
                    and evenfatu.cd-evento   = cd-evento-par
                  no-lock no-error.
    
    if not avail evenfatu
    then return. 


    select count(*) into qt-registros from migrac-fatur  where migrac-fatur.cod-livre-1 = "RC".

    assign percent-concluido = 0
           qt-lidos-aux      = 0.

    disp qt-registros                                    
         percent-concluido                               
          with frame f-acompanhamento.      

    for each migrac-fatur where migrac-fatur.cod-livre-1 = "RC" no-lock
                          break by migrac-fatur.aa-referencia
                                by migrac-fatur.num-mm-refer:

        assign qt-lidos-aux = qt-lidos-aux + 1.

        if qt-lidos-aux > 500
        then do:
                 disp qt-registros
                      ((percent-concluido / qt-registros) * 1000) @ percent-concluido
                      ((percent-erros / qt-registros) * 1000) @ percent-erros
                      with frame f-acompanhamento.
                 process events. 
                 assign qt-lidos-aux = 0. 
             end.

        for first propost  fields (propost.ep-codigo
                                   propost.cod-estabel
                                   propost.cd-modalidade
                                   propost.nr-ter-adesao
                                   propost.nr-proposta)
                           where propost.cd-modalidade   = migrac-fatur.cd-modalidade
                            and propost.nr-ter-adesao   = migrac-fatur.nr-ter-adesao no-lock: end.

        if not avail propost 
        then do:
                run grava-erro(input "contrato nao cadastrado").
                next. 
             end.


        for first tit_acr fields (tit_acr.cdn_cliente)
                          where tit_acr.cod_estab       = propost.cod-estabel
                            and tit_acr.cod_espec_docto = migrac-fatur.cd-especie
                            and tit_acr.cod_ser_docto   = migrac-fatur.serie
                            and tit_acr.cod_tit_acr     = migrac-fatur.nr-titulo-acr 
                            and (   tit_acr.cod_parcela = string(migrac-fatur.parcela) 
                                 or tit_acr.cod_parcela = "") no-lock: end.

        if not avail tit_acr
        then do:
                /*if migrac-fatur.parcela = 0
                then for first tit_acr where tit_acr.cod_estab       = propost.cod-estabel
                                         and tit_acr.cod_espec_docto = migrac-fatur.cd-especie
                                         and tit_acr.cod_ser_docto   = migrac-fatur.serie
                                         and tit_acr.cod_tit_acr     = migrac-fatur.nr-titulo-acr no-lock: end.

                if not avail tit_acr
                then do:*/
                        run grava-erro(input "titulo nao cadastrado").
                        next. 
                    /* end.*/
             end.

        /***********************BUSCA NUMERO FATURA **************************************/
        run rtp/rtnrfat.p(input  migrac-fatur.cd-modalidade,
                          input  tit_acr.cdn_cliente,
                          output nr-fatura-aux).
    
        find first fatura where fatura.cd-contratante = tit_acr.cdn_cliente
                            and fatura.nr-fatura      = nr-fatura-aux
                          no-lock no-error. 
    
        do while avail fatura:
           nr-fatura-aux = nr-fatura-aux + 1.
           find first fatura where fatura.cd-contratante = tit_acr.cdn_cliente
                               and fatura.nr-fatura      = nr-fatura-aux no-lock no-error. 
        end.
        /*********************************************************************************/
    
        do transaction:
           create fatura.
           assign fatura.cd-contratante            = tit_acr.cdn_cliente
                  fatura.nr-fatura                 = nr-fatura-aux
                  fatura.aa-referencia             = migrac-fatur.aa-referencia  
                  fatura.mm-referencia             = migrac-fatur.num-mm-refer   
                  fatura.ep-codigo                 = propost.ep-codigo
                  fatura.cod-estabel               = propost.cod-estabel
                  fatura.cd-modalidade             = propost.cd-modalidade
                  fatura.cd-especie                = migrac-fatur.cd-especie
                  fatura.serie                     = migrac-fatur.serie
                  fatura.ds-mensagem               = "FATURA MIGRADA DO UNICOO"
                  fatura.portador                  = migrac-fatur.portador
                  fatura.modalidade                = migrac-fatur.modalidade
                  fatura.ct-codigo                 = ""
                  fatura.sc-codigo                 = ""
                  fatura.nr-titulo-acr             = migrac-fatur.nr-titulo-acr 
                  fatura.parcela                   = migrac-fatur.parcela
                  fatura.dt-emissao                = migrac-fatur.dt-emissao
                  fatura.dt-vencimento             = migrac-fatur.dt-vencimento
                  fatura.cd-tipo-vencimento        = 0
                  fatura.cd-sit-fatu               = 30
                  fatura.mo-codigo                 = 0
                  fatura.vl-total                  = migrac-fatur.vl-total 
                  fatura.in-tipo-fatura            = 3
                  fatura.cd-userid                 = "migracao"
                  fatura.dt-atualizacao            = today
                  fatura.date-3                    = today
                  fatura.lg-contabilizado          = yes.

           ASSIGN lg-erro-jm-aux = NO. 

           FOR EACH migrac-fatur-juros WHERE migrac-fatur-juros.cdd-seq-tab-pai = migrac-fatur.cdd-seq NO-LOCK:

               for first tit_acr where tit_acr.cod_estab       = propost.cod-estabel
                                    and tit_acr.cod_espec_docto = migrac-fatur-juros.cd-especie
                                    and tit_acr.cod_ser_docto   = migrac-fatur-juros.serie
                                    and tit_acr.cod_tit_acr     = migrac-fatur-juros.nr-titulo-acr 
                                   /* and (   tit_acr.cod_parcela = string(migrac-fatur-juros.parcela) 
                                         or tit_acr.cod_parcela = "")*/
                                          no-lock: end.

               IF NOT AVAIL tit_acr
               THEN DO:
                       run grava-erro(input "titulo juros/multa nao cadastrado").
                       ASSIGN lg-erro-jm-aux = YES. 
                       next. 
                    END.

         /*      FOR each b-fatura WHERE b-fatura.aa-referencia  = migrac-fatur-juros.aa-referencia
                                   AND b-fatura.mm-referencia  = migrac-fatur-juros.num-mm-refer
                                   AND b-fatura.cd-contratante = fatura.cd-contratante
                                   AND b-fatura.nr-titulo-acr  = migrac-fatur-juros.nr-titulo-acr NO-LOCK, 
                   first notaserv where notaserv.cd-contratante = b-fatura.cd-contratante
                                    and notaserv.nr-fatura      = b-fatura.nr-fatura
                                    and notaserv.cd-modalidade  = migrac-fatur.cd-modalidade
                                    and notaserv.nr-ter-adesao  = migrac-fatur.nr-ter-adesao no-lock: leave. END.

                IF NOT AVAIL b-fatura
                THEN DO:
                       /*disp 'erro' migrac-fatur-juros.nr-titulo-acr  migrac-fatur-juros.aa-referencia  migrac-fatur-juros.num-mm-refer.*/
                         run grava-erro(input "fatura juros/multa nao cadastrado").
                        ASSIGN lg-erro-jm-aux = YES. 
                        next. 
                     END.*/


               for first fatur-juros-multa where fatur-juros-multa.cd-contratante     = fatura.cd-contratante 
                                             and fatur-juros-multa.num-fatur          = fatura.nr-fatura
                                             and fatur-juros-multa.num-fatur-relacdo  = fatura.nr-fatura no-lock: end.

               if avail fatur-juros-multa
               then do:
                        run grava-erro(input "J/M jah cad." + string(fatura.cd-contratante) + "-" 
                                                            + string(fatura.nr-fatura)    + "-"
                                                            + string(fatura.nr-fatura) ).
                        next.
                    end.

               CREATE fatur-juros-multa.
               assign fatur-juros-multa.cd-contratante    = fatura.cd-contratante
                      fatur-juros-multa.num-fatur         = fatura.nr-fatura
                      fatur-juros-multa.num-fatur-relacdo = fatura.nr-fatura
                      fatur-juros-multa.dat-inic          = migrac-fatur-juros.dat-livre-1
                      fatur-juros-multa.dat-fim           = migrac-fatur-juros.dat-livre-2
                      fatur-juros-multa.val-juros         = migrac-fatur-juros.val-juros 
                      fatur-juros-multa.val-multa         = migrac-fatur-juros.val-multa.

               IF tit_acr.dat_ult_liquidac < fatur-juros-multa.dat-fim
               THEN ASSIGN fatur-juros-multa.dat-livre-1 = tit_acr.dat_ult_liquidac.
               ELSE ASSIGN fatur-juros-multa.dat-livre-1 = fatur-juros-multa.dat-fim.

               if  tit_acr.val_sdo_tit_acr = 0
               and tit_acr.dat_ult_liquidac < fatur-juros-multa.dat-fim
               then do:
                       find current fatura exclusive-lock no-error. 
                       if avail fatura
                       then assign fatura.log-15 = yes. 
                    end.

           END.

           IF lg-erro-jm-aux 
           then undo, NEXT.

           find last notaserv 
               where notaserv.cd-modalidade         = propost.cd-modalidade    
                 and notaserv.cd-contratante        = fatura.cd-contratante    
                 and notaserv.cd-contratante-origem = 0                        
                 and notaserv.nr-ter-adesao         = migrac-fatur.nr-ter-adesao   
                 and notaserv.aa-referencia         = migrac-fatur.aa-referencia       
                 and notaserv.mm-referencia         = migrac-fatur.num-mm-refer        
                 no-lock no-error.
           
           if not available notaserv
           then nr-sequencia-aux = 1.
           else nr-sequencia-aux = notaserv.nr-sequencia + 1.
    
           create notaserv.
           assign notaserv.cd-modalidade         = propost.cd-modalidade
                  notaserv.cd-contratante        = fatura.cd-contratante
                  notaserv.cd-contratante-origem = 0
                  notaserv.nr-ter-adesao         = migrac-fatur.nr-ter-adesao 
                  notaserv.cd-especie            = migrac-fatur.cd-especie
                  notaserv.aa-referencia         = migrac-fatur.aa-referencia
                  notaserv.mm-referencia         = migrac-fatur.num-mm-refer
                  notaserv.nr-sequencia          = nr-sequencia-aux
                  notaserv.ep-codigo             = fatura.ep-codigo
                  notaserv.cod-estabel           = fatura.cod-estabel
                  notaserv.dt-emissao            = fatura.dt-emissao 
                  notaserv.dt-vencimento         = fatura.dt-vencimento
                  notaserv.mo-codigo             = 0
                  notaserv.vl-total              = fatura.vl-total
                  notaserv.nr-fatura             = fatura.nr-fatura
                  notaserv.lg-contabilizada      = yes
                  notaserv.cd-userid             = "migracao"
                  notaserv.dt-atualizacao        = today
                  notaserv.date-1                = today.
    
    
           create fatueven.
           assign fatueven.cd-modalidade         = notaserv.cd-modalidade    
                  fatueven.nr-sequencia          = notaserv.nr-sequencia     
                  fatueven.nr-ter-adesao         = notaserv.nr-ter-adesao    
                  fatueven.aa-referencia         = notaserv.aa-referencia    
                  fatueven.mm-referencia         = notaserv.mm-referencia    
                  fatueven.cd-evento             = cd-evento-par
                  fatueven.qt-evento             = 1
                  fatueven.vl-evento             = fatura.vl-total
                  fatueven.lg-cred-deb           = yes
                  fatueven.lg-destacado          = no
                  fatueven.lg-modulo             = no
                  fatueven.ct-codigo             = ""
                  fatueven.sc-codigo             = ""
                  fatueven.qt-evento-ref         = 0
                  fatueven.vl-evento-ref         = 0
                  fatueven.cd-tipo-cob           = 0
                  fatueven.cd-contratante        = notaserv.cd-contratante       
                  fatueven.cd-contratante-origem = notaserv.cd-contratante-origem
                  fatueven.cd-userid             = "migracao"
                  fatueven.dt-atualizacao        = today.

           release fatura.
           release notaserv.
           release fatueven.
           release fatur-juros-multa. 
                                      
           find b-migrac-fatur where rowid(b-migrac-fatur) = rowid(migrac-fatur)
                                     exclusive-lock no-error. 

           if avail b-migrac-fatur 
           then assign b-migrac-fatur.cod-livre-1 = 'IT'
                       percent-concluido          = percent-concluido + 1. 

        end.
    end.
end procedure. 

procedure grava-erro:
    def input parameter ds-mensagem-par as char no-undo. 

    find b-migrac-fatur where rowid(b-migrac-fatur) = rowid(migrac-fatur)
                                     exclusive-lock no-error. 

    if avail b-migrac-fatur 
    then assign b-migrac-fatur.cod-livre-1 = 'ER'
                b-migrac-fatur.cod-livre-2 = ds-mensagem-par
                percent-erros              = percent-erros + 1. 
end procedure. 

