/** Campos reserva em uso:
 *
 * LOG-LIVRE-1:  
 * LOG-LIVRE-2:  tpnumeracao_familia (se eh normal ou automatico)
 *
 * COD-LIVRE-2: numero da lotacao ou 0
 *
 * NUM-LIVRE-2: contrato_da_pessoa.nrregistro
 * NUM-LIVRE-3: contrato_da_pessoa.nrcontrato
 * NUM-LIVRE-4: numero da familia ou 0
 * NUM-LIVRE-5: id pessoa do contratante origem
 * NUM-LIVRE-8:
 * NUM-LIVRE-10: nr-proposta. eh gerado no PL/SQL
 *
 * OBS: alguns sao utilizados apenas para controles internos nas procedures PL/SQL.
 *      ainda assim nao devem ser alterados, pois afetaria o processo.
 */

/* CG0310X1.P - VALIDA CRIACAO DAS PROPOSTAS */

/* ultimo ID de mensagem de erro: 172 */

def input param in-batch-online-par          AS CHAR NO-UNDO.
DEF INPUT PARAM in-status-monitorar-par      AS CHAR NO-UNDO.
def input param lg-registro-modulos-par      as log no-undo.
def input param in-classif-par               as INT no-undo.
def input param lg-registro-faixa-par        as log no-undo.
def input param lg-registro-negociacao-par   as log no-undo.
def input param lg-registro-cobertura-par    as log no-undo.
def input param lg-registro-especifico-par   as log no-undo.
def input param lg-registro-procedimento-par as log no-undo.
def input param qt-sair-par                  as INT no-undo.

/**
 * TRANSFORMAR ISSO EM PARAMETRO DE ENTRADA. AJUSTAR CHAMADORES!
 */
DEF VAR lg-gerar-termo-par AS LOG INIT NO NO-UNDO.
ASSIGN lg-gerar-termo-par = YES.

/*DEF STREAM s-rel-erro.
DEF VAR nm-rel-erro-aux AS CHAR INIT "c:\temp\erros_cg0310x1.txt" NO-UNDO.
*/

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
assign c_prg_vrs = "2.00.00.025".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'CG0310X1':U, '2.00.00.025':U, '':U).
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
  /*** 010025 ***/



/******************************************************************************
*      Programa .....: CG0310X1.p                                              *
*      Data .........: 29 de Janeiro de 2015                                  *
*      Autor ........: TOTVS                                                  *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Ja¡ne Marin                                            *
*      Objetivo .....: Importacao de Dados da Proposta                        *
******************************************************************************/
/*hide all no-pause.*/
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

/**
 * Auxiliares para montagem das mensagens de erro, para impedir
 * que a mensagem fique "?" quando contiver conteudo nulo.
 */
DEF VAR char-aux1 AS CHAR NO-UNDO.
DEF VAR char-aux2 AS CHAR NO-UNDO.
DEF VAR char-aux3 AS CHAR NO-UNDO.
DEF VAR char-aux4 AS CHAR NO-UNDO.
DEF VAR char-aux5 AS CHAR NO-UNDO.

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
    Programa .....: hdregcpimla.i
    Data .........: 05/01/2004
    Sistema ......:
    Empresa ......: DZSET SOLUCOES E SISTEMAS
    Cliente ......:
    Programador ..: ELIZETE
    Objetivo .....: R‚gua de arquivo, consiste, parametro, importa e layout
*-----------------------------------------------------------------------------*
    Versao     DATA         RESPONSAVEL
               05/01/2004   ELIZETE
******************************************************************************/
/* ---------------------------------------------------- REGUAS PARA UNIX --- */
def var tb-cpimla as char extent 6 initial ["Arquivo",
                                            "Consiste",
                                            "Parametro",
                                            "Importa",
                                            "Layout",      
                                            "Fim"]       no-undo.
 
/******************************************************************************
    Programa .....: hdregcpimla.f
    Data .........: 05/01/2004
    Sistema ......:
    Empresa ......: DZSET SOLUCOES E SISTEMAS
    Cliente ......:
    Programador ..: ELIZETE
    Objetivo .....: R‚gua de arquivo, consiste, parametro, importa e layout
*-----------------------------------------------------------------------------*
    Versao     DATA         RESPONSAVEL
               05/01/2004   ELIZETE
******************************************************************************/
/* --------------------------------------------------- FRAMES PARA UNIX --- */
form tb-cpimla[1] format "x(7)"
     tb-cpimla[2] format "x(8)"
     tb-cpimla[3] format "x(9)"
     tb-cpimla[4] format "x(7)"
     tb-cpimla[5] format "x(6)"
     tb-cpimla[6] format "x(3)"
     with no-labels attr row 21 no-box overlay centered frame f-cpimla.
                
/* ----------------------------------------------- FRAMES PARA WINDOWS --- */                
define frame f-regua-cpimla 
     b-arquivo    at row 1.48 col 24
     b-consiste   at row 1.48 col 28
     b-parametro  at row 1.48 col 32
     b-importa    at row 1.48 col 36
     b-layout     at row 1.48 col 40
     b-fim        at row 1.48 col 58
     b-help       at row 1.48 col 62
     Retangulo-1  at row 1    col 2
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

 
 
assign nm-cab-usuario = "Importacao das Propostas" 
       nm-prog        = "CG0310X1"
       c-versao       = "1.02.00.019".
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
    
 

/********************* Definicao Variaveis de Importacao *********************/
 
def stream s-import.
def stream s-relat-incl.
def stream s-relat-erro.

def new shared var lg-registro-modulos            as log init no  format "Sim/Nao"     no-undo.
def new shared var lg-registro-faixa              as log init no  format "Sim/Nao"     no-undo.
def new shared var lg-registro-negociacao         as log init no  format "Sim/Nao"     no-undo.
def new shared var lg-registro-cobertura          as log init no  format "Sim/Nao"     no-undo.
def new shared var lg-registro-especifico         as log init no  format "Sim/Nao"     no-undo.
def new shared var lg-registro-procedimento       as log init no  format "Sim/Nao"     no-undo.
def new shared var lg-ver-imp8                    as log initial no                    no-undo.
def new shared var lg-ver-imp9                    as log initial no                    no-undo.
DEF NEW SHARED VAR lg-gerar-termo-aux             AS LOG INIT NO                       NO-UNDO.
DEF NEW SHARED VAR dt-minima-termo-aux            AS DATE                              NO-UNDO.

/**
 * Quando qt-sair-aux tiver valor diferente de zero, processara registros ate
 * atingir esse numero e saira do programa.
 * Usar essa opcao quando o chamador for um laco encadeado com os outros processos
 * de migracao, para dividir o processamento.
 */
DEF            VAR qt-sair-aux      AS INT INIT 0 NO-UNDO.
DEF NEW SHARED VAR qt-cont-sair-aux AS INT INIT 0 NO-UNDO.

/*-------------------------------------------------------------------------*/
def var lg-relat-erro-aux                         as logi initial no                   no-undo.
def var ds-cabecalho                              as char format "x(30)"               no-undo.
def var ds-rodape                                 as char format "x(80)"  init ""      no-undo.
def var lg-relat-erro                             as logi                              no-undo.
def var nr-insc-contrat-aux                       like contrat.nr-insc-contratante     no-undo.
def var nm-arquivo-mag                            as char format "x(30)"               no-undo.
def var lg-parametro                              as log initial no                    no-undo.
def var tp-registro-imp-ant                       as int format "9"                    no-undo.
def var lg-imp-erro                               as log initial no                    no-undo.
def var lg-tem-proposta-aux                       as   log       initial no            no-undo.
def var nr-contrat-aux                            like contrat.nr-insc-contratante     no-undo.
def var nm-diretorio-aux                          as char format "x(80)"               no-undo.
def var ds-barra                                  as char format "x(1)"                no-undo.
def var nr-insc-contrat-ant                       like propost.nr-insc-contratante     no-undo.
def var nr-insc-contrat-origem-ant                like propost.nr-insc-contratante     no-undo.
def var cd-modalidade-ant                         like modalid.cd-modalidade           no-undo.
def var cd-plano-ant                              like propost.cd-plano                no-undo.
def var nr-proposta-ant                           like propost.nr-proposta             no-undo.
def var lg-ver-imp4                               as log initial no                    no-undo.
def var lg-ver-imp5                               as log initial no                    no-undo.
DEF VAR lg-aceita-repasse-aux                     AS LOG INITIAL NO                    NO-UNDO.                   
def var ds-mensagem-aux                           as char format "x(100)"              no-undo.
def var lg-erro-aux                               as log                               no-undo.
def var lg-passou                                 as log initial no                    no-undo.
def var ix                                        as int format "99"                   no-undo.
def var dt-inicio-comerc-aux                      like ti-pl-sa.dt-inicio-comerc       no-undo.
def var dt-fim-comerc-aux                         like ti-pl-sa.dt-fim-comerc          no-undo.
def var lg-erro-processo-aux                      as   logical   format "yes/no"       no-undo.
def var cd-tab-preco-proc-aux                     as char                              no-undo.
def var ct-tamanho                                as int   format "999"                no-undo.
def var ct-posicao-ini                            as integer                           no-undo.
DEF VAR lg-modulo-erro                            AS LOG                               NO-UNDO.
DEF VAR qtd-reg-rest                              AS INT                               NO-UNDO.
def var lg-medocup-aux                            as log                               no-undo.
DEF VAR cont-aux                                  AS INT                               NO-UNDO.

DEF VAR h-handle-aux AS HANDLE NO-UNDO.
disable triggers for load of propost.
RUN cgp/cg0311x.p PERSISTENT SET h-handle-aux.

DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-seq            AS INT
    FIELD nr-seq-contr      LIKE erro-process-import.num-seqcial-control 
    FIELD nom-tab-orig-erro AS CHAR
    FIELD des-erro          AS CHAR
    INDEX nr-seq       
          nr-seq-contr.

DEF NEW SHARED TEMP-TABLE tt-import-propost NO-UNDO
    FIELD rowid-import-prop AS ROWID
    FIELD nr-proposta       AS INT
    FIELD nr-insc-contrat   like contrat.nr-insc-contratante 
    INDEX ID rowid-import-prop.

def buffer b-import-propost for import-propost.
DEF BUFFER b-propost        FOR propost.
def buffer b-tt-erro        for tt-erro.

/*----------------------------------------------------------------------------*/
def new shared var in-classif       as int  init 1                     no-undo.
def var tb-classif                  as char extent 3 initial
   ["1 - Obriga", "2 - Opcional", "3 - Ambos"]                          no-undo.
 
form tb-classif[1] format "x(12)"
     tb-classif[2] format "x(12)"
     tb-classif[3] format "x(12)"
     with no-labels 1 column column 46 no-attr row 13 overlay frame f-classif
     title " Opcao ".
 
/*----------------------------------------------------------------------------*/
find first paramecp no-lock no-error.
if   available paramecp
then do:
       find unimed where unimed.cd-unimed = paramecp.cd-unimed no-lock no-error.
       if   available unimed
       then assign ds-cabecalho = unimed.nm-unimed-reduz.
     end.
else do:
       message "Parametros gerais do sistema nao cadastrados."
               view-as alert-box title " Atencao !!! ".
       return.
     end.

find first paravpmc no-lock no-error.
if   not avail paravpmc
then do:
       message "Parametros dos modulos VP e MC nao localizados."
               view-as alert-box title " Atencao !!! ".
       return.
     end.

form header
     fill("-", 132) format "x(132)"                           skip
     ds-cabecalho
     "Inconsistencias Importacao das Propostas"               at 47
     "Folha:"                                                 at 122
     page-number(s-relat-erro)                                at 128
     format ">>>9" skip
     fill("-", 112) format "x(112)"
     today "-" string(time, "HH:MM:SS")
     skip(1)
     with no-labels no-box page-top width 132 frame f-cabeca-erro STREAM-IO.
 
form header
     fill("-", 132) format "x(132)"                         skip
     ds-cabecalho
     "      Relatorio de Importacao da Proposta         "   at 46
     "Folha:"                                               at 122
     page-number(s-relat-incl)                              at 128
     format ">>>9" skip
     fill("-", 112) format "x(112)"
     today "-" string(time, "HH:MM:SS")
     skip(1)
     with no-labels no-box page-top width 132 frame f-cabeca STREAM-IO.
 
def rectangle f-param
    edge-pixels 3 graphic-edge no-fill size 35 by 8.9.

form skip(1)
     lg-registro-modulos      view-as fill-in size 04 by 1.3 native label "Modulos da Proposta"       colon 28
     lg-registro-faixa        view-as fill-in size 04 by 1.3 native label "Faixa Etaria Especial"     colon 28
     lg-registro-negociacao   view-as fill-in size 04 by 1.3 native label "Negociacao entre Unidades" colon 28
     lg-registro-cobertura    view-as fill-in size 04 by 1.3 native label "Padrao de Cobertura"       colon 28
     lg-registro-especifico   view-as fill-in size 04 by 1.3 native label "Campos Especificos"        colon 28
     lg-registro-procedimento view-as fill-in size 04 by 1.3 native label "Procedimentos Especiais"   colon 28
     f-param at row 1.3 col 1.7
     with three-d overlay row 12 column 12 no-labels side-labels frame f-parametro size 37 by 11
     title " Parametros da Importacao ".
 
form header ds-rodape format "x(132)"
     with no-labels no-box width 132 page-bottom frame f-rodape STREAM-IO.
 
def var nm-arquivo-erros     as char format "x(35)"
        initial "spool/ERROS-P.LST".
 
def rectangle f-arq-mag
    edge-pixels 3 graphic-edge no-fill size 67 by 3.

form skip(1.3)
     nm-arquivo-erros    view-as fill-in size 36 by 1.3 native label   "   Nome do Arquivo de Erros" at 03
        validate(nm-arquivo-erros <> "", "Nao pode ser espacos")
     skip
     f-arq-mag at row 1.45 col 2
     with three-d row 14 column 8 side-labels attr-space overlay frame f-arquivo-mag size 69 by 4.
 
def rectangle f-cont
    edge-pixels 3 graphic-edge no-fill size 36 by 5.7.                                                                      

form tt-erro.nr-seq-contr                      column-label "Nro.Seq.Controle"         
     tt-erro.nom-tab-orig-erro  format "x(30)" column-label "Tab.Origem Erro"
     tt-erro.des-erro           format "x(80)" column-label "Descricao Erro"           
     with width 132 down no-box attr-space frame f-erro stream-io.  
 
def new shared temp-table w-grava
        field cd-campo as inte
        field ds-campo as char format "x(355)".
 
/*----------------  Opcao Consistencia ------------------------------------*/
def var ct-linhas                       as int  format "999"           no-undo.
def var ct-grava                        as int                         no-undo.
def new shared var nr-cont-antigo       as char                        no-undo.
def new shared var tam                  as int     format "999"        no-undo.
def new shared var posicao-ini          as integer                     no-undo.
def new shared var cd-dados             as char                        no-undo.
def new shared var ct-tam               as int     format "99"         no-undo.
def new shared var lg-consist           as logical initial no          no-undo.
def new shared var lg-consist-aux       as logical initial no          no-undo.
 
run rtp/rtspool.p(input-output nm-diretorio-aux). 

assign ds-barra = substring(nm-diretorio-aux,(length(nm-diretorio-aux)),1).

if    ds-barra <> "/"
then  assign nm-diretorio-aux = nm-diretorio-aux + "/".

assign nm-arquivo-erros     = nm-diretorio-aux + "ERROS-C.LST" .
 
def new shared temp-table w-inconsistencia
        field cd-campo-consist as int
        field nr-cont-antigo   as char
        field ct-linhas        as int
        field ds-mensagem      as char format "x(92)"
        field tp-registro      as int  format "z9"
        field ds-complemento   as char format "x(56)".
 
form w-inconsistencia.tp-registro        column-label "Tp Registro"
     w-inconsistencia.nr-cont-antigo     column-label "Contrato Antigo"
     w-inconsistencia.ct-linhas          column-label "Linha"
     w-inconsistencia.ds-mensagem        column-label "Mensagem de Erro"
     w-inconsistencia.ds-complemento         no-label at 39
     with width 132 down no-box no-attr-space frame f-consistencia-erro.
 
/* --------------------------------------------------------------------------*/
 
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
                          label "Nome do diretorio"  initial "spool/"     no-undo.
def  var nm-arquivo    as char format "x(20)"
                          label "     Nome arquivo"  initial "PROPOSTA"     no-undo.
def  var nm-extensao   as char format "x(03)"
                          label "         Extensao" initial "LST"      no-undo.
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
 
 
assign ds-rodape  = " " + nm-prog + " - " + c-versao
       ds-rodape  = FILL("-", 132 - LENGTH(ds-rodape)) + ds-rodape
 
       nm-arquivo-mag = "imp/PROPOSTA.TXT".

/* ----------------------- INICIALIZACAO ------------------------------------ */
 
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
if in-batch-online-par = "online"
then do:
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
       
        
       
       assign b-layout:hidden = true.
       assign b-consiste:hidden = true.
     end.
 
IF v_cod_usuar_corren = ""
THEN ASSIGN v_cod_usuar_corren = "migracao".

assign lg-gerar-termo-aux = lg-gerar-termo-par
       qt-sair-aux        = qt-sair-par.

if   month(today) = 12
then assign dt-minima-termo-aux = date(month(today),31,year(today)).
else assign dt-minima-termo-aux = date(month(today) + 1,01,year(today)) - 1.

IF in-batch-online-par = "BATCH"
THEN DO:
       assign lg-registro-modulos      = lg-registro-modulos-par
              in-classif               = in-classif-par
              lg-registro-faixa        = lg-registro-faixa-par
              lg-registro-negociacao   = lg-registro-negociacao-par
              lg-registro-cobertura    = lg-registro-cobertura-par
              lg-registro-especifico   = lg-registro-especifico-par
              lg-registro-procedimento = lg-registro-procedimento-par.              

       run importa-dados(100).
     END.
ELSE do:
       repeat on endkey undo,retry on error undo, retry with frame f-arquivo-mag:
                 
                  hide frame f-saida        no-pause.
                  hide frame f-nome         no-pause.
                  hide frame f-nome-imp     no-pause.
                  hide frame f-layout       no-pause.
                  hide frame f-arquivo-mag  no-pause.
                  hide frame f-classif      no-pause.
                  hide frame f-parametro    no-pause.
                  hide frame f-consist      no-pause.
                  hide frame f-contador     no-pause.
                  hide message              no-pause.
                  /******************************************************************************
                    Programa .....: hdbotcpimla.i
                    Data .........: 05/01/2004
                    Sistema ......:
                    Empresa ......: DZSET SOLUCOES E SISTEMAS
                    Cliente ......:
                    Programador ..: ELIZETE
                    Objetivo .....: R‚gua de arquivo, consiste, parametro, importa e layout
                *-----------------------------------------------------------------------------*
                    Versao     DATA         RESPONSAVEL
                               05/01/2004   ELIZETE
                ******************************************************************************/
                
                 do:
                        on choose of b-help in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-help:label in frame f-regua-cpimla,"&","").
                          run rtp/rtexibehelp.p.
                        end.
                
                        on end-error of b-help in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                        
                        on choose of b-fim in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-fim:label in frame f-regua-cpimla,"&","").
                        end.
                        
                        on end-error of b-fim in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                        
                        on choose of b-arquivo in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-arquivo:label in frame f-regua-cpimla,"&","").
                        end.
                        
                        on end-error of b-arquivo in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                        
                        on choose of b-consiste in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-consiste:label in frame f-regua-cpimla,"&","").
                        end.
                        
                        on end-error of b-consiste in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                
                        on choose of b-parametro in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-parametro:label in frame f-regua-cpimla,"&","").
                        end.
                        
                        on end-error of b-parametro in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                        
                        on choose of b-importa in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-importa:label in frame f-regua-cpimla,"&","").
                        end.
                        
                        on end-error of b-importa in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                
                        on choose of b-layout in frame f-regua-cpimla
                        do:
                          c-opcao = replace(b-layout:label in frame f-regua-cpimla,"&","").
                        end.
                        
                        on end-error of b-layout in frame f-regua-cpimla
                        do:
                          return no-apply.
                        end.
                        update unless-hidden b-arquivo b-consiste b-parametro b-importa b-layout b-fim b-help 
                               go-on("get" "put" "recall" "clear")
                               with frame f-regua-cpimla.
                      end.
                
                 .
                  
                  /* c-opcao = "Arquivo" */
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
                 
                
                  case c-opcao: 
                     when "Parametro"
                     then do on error undo, retry on endkey undo, leave with frame f-parametro:
                
                             assign c-opcao = "Parametro".
                             
                             update lg-registro-modulos.
                             
                             if lg-registro-modulos = yes
                             then do on error undo, retry on endkey undo, leave:
                                     
                                     display tb-classif with frame f-classif.
                                     choose field tb-classif auto-return with frame f-classif.
                                     in-classif = frame-index.
                                  end.
                             
                             hide frame f-classif no-pause.
                             
                             update lg-registro-faixa        with frame f-parametro.
                             update lg-registro-negociacao   with frame f-parametro.
                             update lg-registro-cobertura    with frame f-parametro.
                             update lg-registro-especifico   with frame f-parametro.
                             update lg-registro-procedimento with frame f-parametro.
                             
                             assign lg-parametro = yes.
                             
                             hide frame f-parametro no-pause.
                          end.    
                
                     when "Importa"
                     then do on error undo, retry on endkey undo, leave:
                          
                             if not lg-parametro
                             then do:
                                    message "Nenhum Parametro Selecionado."
                                            view-as alert-box title " Atencao !!! ".
                                    undo, retry.
                                  end.
                             
                             update nm-arquivo-erros with frame f-arquivo-mag.
                             
                             hide frame f-arquivo-mag no-pause.
                             
                             assign lg-imp-erro             = no
                                    ct-grava                = 0 
                                    lg-ver-imp5             = no
                                    lg-ver-imp8             = no
                                    lg-ver-imp9             = no.
                             
                             message " Importando Dados, Aguarde...".
                             
                             output stream s-relat-erro to value(nm-arquivo-erros)    page-size 64.
                             
                             view stream s-relat-erro   frame f-cabeca-erro.
                             view stream s-relat-erro   frame f-rodape.
                
                             run importa-dados(100).
                             
                             /*--------------------------------------------------------------------*/
                             
                             page.
                             
                             if lg-imp-erro
                             then message "Ocorreram Erro(s)." skip
                                          "Verifique Relatorio de Erros "
                                          view-as alert-box title "Atencao !!!".
                             else message "Importacao concluida com sucesso!"
                                          view-as alert-box title "Atencao !!!".
                               
                             output stream s-relat-erro close.
                             
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
                 
                             
                             /*---- TESTA SISTEMA UNIX PARA POSICIONAR NO BOTAO ARQUIVO ---------*/
                             
                             
                             hide message no-pause.
                          
                          end.
                     
                     when "Fim"
                     then do:
                            hide all no-pause.
                            leave.
                          end.
                  end case.
                end.
     END.

     DELETE PROCEDURE h-handle-aux.

/* ------------------------------------------------------------------------------------------- */
procedure importa-dados:

    DEF INPUT PARAM qtd-reg-par AS INT NO-UNDO.

    /**
     * Alex Boeira - 25/02/2016
     * Uma validacao equivalente ocorria no cg0310v.p (migracao de Beneficiarios), durante a validacao
     * de cada beneficiario.
     * Para melhorar a performance, retirei a logica do cg0310v.p e fiz essa adaptacao, executada apenas 
     * uma vez antes de iniciar os demais processos.
     */
    FOR EACH ti-pl-sa FIELDS () NO-LOCK,
        EACH mod-cob  FIELDS () NO-LOCK
       WHERE mod-cob.in-identifica-modulo = "S",
       FIRST pla-mod FIELDS (cd-modalidade cd-plano cd-tipo-plano cd-modulo)
       where pla-mod.cd-modalidade = ti-pl-sa.cd-modalidade 
         and pla-mod.cd-plano      = ti-pl-sa.cd-plano
         and pla-mod.cd-tipo-plano = ti-pl-sa.cd-tipo-plano
         AND pla-mod.cd-modulo     = mod-cob.cd-modulo
         and pla-mod.lg-grava-automatico 
             NO-LOCK,
        first pro-pla FIELDS ()   
        where pro-pla.cd-modalidade = pla-mod.cd-modalidade
          and pro-pla.cd-plano      = pla-mod.cd-plano
          and pro-pla.cd-tipo-plano = pla-mod.cd-tipo-plano
          and pro-pla.cd-modulo     = pla-mod.cd-modulo
          AND NOT pro-pla.lg-cobertura-obrigatoria
              NO-LOCK:

        IF  NOT CAN-FIND (FIRST paramdsg 
                          where paramdsg.cd-chave-primaria = paravpmc.cd-chave-primaria                                             
                            and paramdsg.cd-modalidade     = pla-mod.cd-modalidade                                                  
                            and paramdsg.cd-plano          = pla-mod.cd-plano                                                       
                            and paramdsg.cd-tipo-plano     = pla-mod.cd-tipo-plano                                                  
                            and paramdsg.cd-modulo         = pla-mod.cd-modulo)                         
        then do:                                                                                   
               assign lg-relat-erro  = yes.
               RUN pi-cria-tt-erros(166,"Parametros dos Modulos de Seguro nao Cadastrados").
             end.   
    end.

    ASSIGN cont-aux = 0.   

    REPEAT:
        PROCESS EVENTS.                                             

        IF NOT CAN-FIND (FIRST import-propost where import-propost.ind-sit-import = in-status-monitorar-par) 
        THEN LEAVE.

        /* --- CONSITE PROPOSTA E DEMAIS DADOS ----------------------------------------------------------------------------- */
        for each import-propost fields (cd-modalidade 
                                        num-seqcial-control 
                                        cd-plano 
                                        cd-tipo-plano 
                                        num-seqcial-propost 
                                        cd-tab-preco 
                                        ind-faixa-etaria-especial 
                                        ind-sit-import
                                        nr-contrato-antigo)
           where import-propost.ind-sit-import = in-status-monitorar-par exclusive-lock query-tuning(no-index-hint):

            message in-status-monitorar-par "Imp.Proposta Cont.Antigo:" import-propost.nr-contrato-antigo.

            assign lg-ver-imp4           = no 
                   lg-ver-imp5           = no
                   lg-relat-erro-aux     = NO
                   lg-relat-erro         = NO
                   lg-aceita-repasse-aux = NO.
        
            FIND FIRST modalid WHERE modalid.cd-modalidade = import-propost.cd-modalidade NO-LOCK NO-ERROR.
            if   not avail modalid
            then do:
                   assign lg-relat-erro = YES.
                   run pi-cria-tt-erros (1,"Modalidade Invalida"). 
                 end.
        
            if  avail modalid
            then do:
                   if modalid.lg-aceita-repasse   
                   THEN DO: 
                           IF modalid.lg-repasse-obrig 
                           THEN ASSIGN lg-ver-imp4 = yes. 
                           ELSE assign lg-aceita-repasse-aux = yes.
                        END.

                   if modalid.cd-tipo-medicina = paramecp.cd-mediocupa
                   then assign lg-ver-imp8 = yes
                               lg-ver-imp9 = yes.
                 end.        
        
            for first ti-pl-sa fields (lg-usa-padrao-cobertura)
                where ti-pl-sa.cd-modalidade = import-propost.cd-modalidade
                  and ti-pl-sa.cd-plano      = import-propost.cd-plano
                  and ti-pl-sa.cd-tipo-plano = import-propost.cd-tipo-plano no-lock:
            end.
        
            if  avail ti-pl-sa
            and ti-pl-sa.lg-usa-padrao-cobertura = yes
            then assign lg-ver-imp5 = yes.
        
            if not can-find (first import-negociac-propost where import-negociac-propost.num-seqcial-propost = import-propost.num-seqcial-propost)
            and lg-ver-imp4
            then do:
                   run pi-cria-tt-erros (2,"Negociacao deve ser cadastrada para Proposta").
                   assign lg-imp-erro   = YES
                          lg-relat-erro = YES.
                 end.
        
            if not can-find (first import-padr-cobert-propost where import-padr-cobert-propost.num-seqcial-propost = import-propost.num-seqcial-propost)
            and lg-ver-imp5
            and lg-registro-cobertura
            then do:
                   run pi-cria-tt-erros (3,"Padrao Cobertura nao informado").
                   assign lg-imp-erro   = YES
                          lg-relat-erro = YES.
                 end.
        
            IF lg-relat-erro 
            THEN DO:
                   run pi-grava-erro.
                   assign lg-imp-erro = yes.
                   NEXT.
                 END.

            assign lg-imp-erro = NO.

            /* --- CONSISTE DADOS -------------------------------------------------------------------- */
        
            /* --- CONSISTE DADOS PROPOSTA ----- */
            assign lg-relat-erro = no.
            run consiste-dados-proposta.
        
            IF lg-relat-erro
            THEN ASSIGN lg-relat-erro-aux = YES.
        
            /* --- CONSISTE CONTRATANTE -------- */
            assign lg-relat-erro = no.
            RUN consiste-contrat.
        
            IF lg-relat-erro 
            THEN ASSIGN lg-relat-erro-aux = YES.
        
            /* --- CONSISTE MODULOS PROPOSTA ------ */
            if lg-registro-modulos
            then do:
                   assign lg-relat-erro = no.
                   RUN consiste-dados-modulos.
            
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES.
                 end.
            
            /* --- CONSISTE FAIXAS PROPOSTA ------- */
            if lg-registro-faixa
            AND import-propost.ind-faixa-etaria-especial <> "N"
            then do:
                   assign lg-relat-erro = no.
                   RUN consiste-dados-faixa.
            
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES.
                 end.
        
            /* --- CONSISTE NEGOCIACOES REPASSE --- */
            if  lg-registro-negociacao
            AND lg-aceita-repasse-aux
            then do:
                   assign lg-relat-erro = no.
                   RUN consiste-dados-negociac.
        
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES.
                 END.
        
            /* --- CONSISTE COBERTURA PROPOSTA ---- */
            if  lg-registro-cobertura
            AND lg-ver-imp5
            then do:
                   assign lg-relat-erro = no.
                   RUN consiste-dados-cobertura.
        
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES. 
                 END.
        
            /* --- CONSISTE CAMPOS PROPOSTA ------- */
            IF lg-registro-especifico
            THEN DO:
                   assign lg-relat-erro = no.
                   RUN consiste-campos-proposta.
        
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES.
                 END.
        
            /* --- CONSISTE PROCED. PROPOSTA ------ */
            if lg-registro-procedimento
            then do:
                   assign lg-relat-erro = no.
                   RUN consiste-proced-propost.
        
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES.
                 end.
        
            /* --- MEDICINA OCUPACIONAL ----------- */
            if lg-ver-imp8
            then do:   
                   run consiste-mo.
        
                   IF lg-relat-erro
                   THEN ASSIGN lg-relat-erro-aux = YES.
                 end.
        
            /* --- MEDICINA OCUPACIONAL FUNCAO----- */
            if lg-ver-imp9
            then do:
                   run consiste-mo-funcao.
        
                   if lg-relat-erro
                   then assign lg-relat-erro-aux = YES.
                 end.
            
            /* --------------------------------------------------------------------------------------- */
            ASSIGN cont-aux = cont-aux + 1.
        
            if lg-relat-erro-aux
            then DO:
                   run pi-grava-erro.
                   assign lg-imp-erro = yes. 
                 END.
            ELSE DO:
                   CREATE tt-import-propost.
                   ASSIGN tt-import-propost.rowid-import-prop = rowid(import-propost)
                          tt-import-propost.nr-insc-contrat   = nr-insc-contrat-aux.
                 END.
        
            IF cont-aux = qtd-reg-par
            THEN LEAVE.
        end.

        ASSIGN cont-aux = 0.
        
        /* cria registros */
        run cria-registros IN h-handle-aux ASYNCHRONOUS .

        IF  qt-sair-aux <> 0
        AND qt-cont-sair-aux >= qt-sair-aux
        THEN LEAVE.

    END.

end procedure.

/* ---------------------------------------------------------------------------------------------- */
procedure consiste-dados-proposta:

    if  import-propost.nr-contrato-antigo = ""
    or  import-propost.nr-contrato-antigo = ?
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (4,"Contrato Antigo Invalido"). 
         end.

    /*if can-find (first propost use-index propo24 where propost.nr-contrato-antigo = import-propost.nr-contrato-antigo)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (5,"Contrato Antigo ja informado " + import-propost.nr-contrato-antigo). 
         end.*/

    FIND first propost use-index propo24 where propost.nr-contrato-antigo = import-propost.nr-contrato-antigo NO-LOCK NO-ERROR.
    IF AVAIL propost then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (6,"Contrato Antigo ja informado " + import-propost.nr-contrato-antigo). 
    end.
    
    /**
     * 11/04/2016 - Alex Boeira
     * Se num-livre-10 estiver preenchido, sera nr-proposta. Validar se ja esta sendo usado e apresentar erro.
     */
    IF  import-propost.num-livre-10 <> 0
    AND import-propost.num-livre-10 <> ?
    THEN do:
           IF CAN-FIND(FIRST propost
                       WHERE propost.cd-modalidade = import-propost.cd-modalidade
                         AND propost.nr-proposta   = import-propost.num-livre-10)
           THEN DO:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (168,"Ja existe proposta com Modalidade " + string(import-propost.cd-modalidade) +
                                            " e Nr.Proposta " + STRING(import-propost.num-livre-10)). 
                END.
         END.

    IF NOT CAN-FIND (FIRST pla-sau
                     where pla-sau.cd-modalidade = import-propost.cd-modalidade
                       and pla-sau.cd-plano      = import-propost.cd-plano)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (7,"Plano nao Cadastrado").
         end.

    FOR FIRST ti-pl-sa FIELDS (lg-obriga-responsavel)
        where ti-pl-sa.cd-modalidade = import-propost.cd-modalidade
          and ti-pl-sa.cd-plano      = import-propost.cd-plano
          and ti-pl-sa.cd-tipo-plano = import-propost.cd-tipo-plano NO-LOCK:
    END.
    
    if not avail ti-pl-sa
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (8,"Tipo de Plano nao Cadastrado").
         end.

    if import-propost.log-segassist 
    THEN DO:
           if avail ti-pl-sa 
           and ti-pl-sa.lg-obriga-responsavel = no
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (9,"Tipo de Plano deve obrigar responsavel em prop. de seguro assist.").
                end.

           if  import-propost.ind-cobr <> "1" 
           and import-propost.ind-cobr <> "0" 
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (10,"Indicador de Cobranca para fatura invalido"). 
                end.
           
           if import-propost.dat-fim-segassist = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (11,"Data Final Seguro Assistencial nao Informada"). 
                end.
           ELSE IF import-propost.dat-fim-segassist <> import-propost.dat-fim-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (12,"Data de fim da Proposta diferente da Data fim Seguro Assistencial"). 
                     end.
         END.

    if not can-find (first parapess where parapess.in-tipo-pessoa = import-propost.ind-tip-pessoa)
    then do:
           assign lg-relat-erro = yes. 
           run pi-cria-tt-erros (13,"Tipo de pessoa nao cadastrada").                   
         end.

    if modalid.in-tipo-pessoa <> import-propost.ind-tip-pessoa
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (14,"Tipo de pessoa incompativel com a modalidade. Tab. Importacao: " + import-propost.ind-tip-pessoa + " Modalidade: " + modalid.in-tipo-pessoa).                   
         end.
    
    IF NOT CAN-FIND (FIRST formpaga where formpaga.cd-forma-pagto = import-propost.cd-forma-pagto)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (15,"Forma Pagto nao Cadastrada " + string(import-propost.cd-forma-pagto,"99")). 
         end.
 
    for first for-pag fields (tp-vencimento dd-faturamento lg-trata-inadimplencia-rc)
        where for-pag.cd-modalidade  = import-propost.cd-modalidade
          and for-pag.cd-plano       = import-propost.cd-plano
          and for-pag.cd-tipo-plano  = import-propost.cd-tipo-plano
          and for-pag.cd-forma-pagto = import-propost.cd-forma-pagto 
              no-lock query-tuning (no-index-hint):
    end.
    if not avail for-pag
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (16,"Forma Pagto Invalida para esta Modalidade. " + 
                                 "Modalidade: "     + string(import-propost.cd-modalidade) + 
                                 "Plano: "          + string(import-propost.cd-plano)      +
                                 "Tipo de Plano: "  + string(import-propost.cd-tipo-plano) +
                                 "Forma de Pagto: " + string(import-propost.cd-forma-pagto)).
         end.
    else do:
           assign lg-passou = no.
    
           do ix = 1 to 31:
               if  for-pag.tp-vencimento[ix]  = import-propost.cdn-tip-vencto
               and for-pag.dd-faturamento[ix] = import-propost.num-dia-vencto
               then do:
                      assign lg-passou = yes.
                      leave.
                    end.
           end.
           
           if not lg-passou
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (17,"Tipo/Dia de vencimento invalido p/ Proposta").
                end.
         end.

    FOR FIRST convprop FIELDS (dt-inicio dt-fim cd-convenio) 
        where convprop.cd-convenio = import-propost.cd-convenio NO-LOCK:
    END.
    
    IF NOT AVAIL convprop
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (18,"Convenio nao Cadastrado"). 
         end.
    ELSE DO:
           if  import-propost.dat-propost < convprop.dt-inicio  
           and import-propost.dat-propost > convprop.dt-fim 
           then do:
                  assign lg-relat-erro = yes.
                  IF convprop.dt-inicio <> ?
                  THEN ASSIGN char-aux1 = string(convprop.dt-inicio,"99/99/9999").
                  ELSE ASSIGN char-aux1 = "00/00/0000".
                  IF convprop.dt-fim <> ?
                  THEN ASSIGN char-aux2 = string(convprop.dt-fim,"99/99/9999").
                  ELSE ASSIGN char-aux2 = "00/00/0000".
                  run pi-cria-tt-erros (19,"Convenio fora da validade " + string(convprop.cd-convenio,"999")       +  
                                        " Inic: "                    + char-aux1  + 
                                        " Fim: "                     + char-aux2  + 
                                        " Dt Atual: "                + string(today,"99/99/9999")). 
                end.
         END.
    
    IF NOT CAN-FIND (first contippl 
                     where contippl.cd-convenio    = import-propost.cd-convenio
                       and contippl.cd-modalidade  = import-propost.cd-modalidade
                       and contippl.cd-plano       = import-propost.cd-plano
                       and contippl.cd-tipo-plano  = import-propost.cd-tipo-plano
                       and contippl.cd-forma-pagto = import-propost.cd-forma-pagto)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (20,"Nao Existe Faixa de Beneficiarios para este Convenio" +
                                 "Convenio: "    + string(import-propost.cd-convenio)    +
                                 "Modalidade: "  + string(import-propost.cd-modalidade)  +
                                 "Plano: "       + string(import-propost.cd-plano)       +
                                 "Tipo Plano: "  + string(import-propost.cd-tipo-plano)  +
                                 "Forma Pagto: " + string(import-propost.cd-forma-pagto)). 
         end.
    
    IF NOT CAN-FIND (FIRST tipopart where tipopart.cd-tipo-participacao = import-propost.cd-tipo-participacao)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (21,"Tipo Participacao nao cadastrada"). 
         end.
    
    IF NOT CAN-FIND (FIRST representante 
                     where representante.cod_empresa = string(paramecp.ep-codigo)
                       and representante.cdn_repres  = import-propost.cd-vendedor)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (22,"Vendedor nao Cadastrado"). 
         end.

    find first b-import-propost where rowid(b-import-propost) = rowid(import-propost) exclusive-lock no-error.
    if avail b-import-propost
    then do: 
           assign b-import-propost.cd-tab-preco = REPLACE(b-import-propost.cd-tab-preco, "/", "").
           release b-import-propost.
         END.
    
    FOR FIRST tabprepl FIELDS (lg-situacao dt-inicio dt-fim cd-tab-preco) 
        WHERE tabprepl.cd-tab-preco = import-propost.cd-tab-preco NO-LOCK:
    end.

    IF NOT avail tabprepl
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (23,"Tabela de Preco nao Cadastrada"). 
         end.
    else do:
           if not tabprepl.lg-situacao
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (24,"Tabela de Preco Invalida"). 
                end.
           
           if   import-propost.dat-propost < tabprepl.dt-inicio
           or   import-propost.dat-propost > tabprepl.dt-fim
           then do:
                  assign lg-relat-erro = yes.
                  IF tabprepl.dt-inicio <> ?
                  THEN ASSIGN char-aux1 = string(tabprepl.dt-inicio,"99/99/9999").
                  ELSE ASSIGN char-aux1 = "00/00/0000".
                  IF tabprepl.dt-fim <> ?
                  THEN ASSIGN char-aux2 = string(tabprepl.dt-fim,"99/99/9999").
                  ELSE ASSIGN char-aux2 = "00/00/0000".
                  run pi-cria-tt-erros (25,"Dt limite tab precos fora validade "  + string(tabprepl.cd-tab-preco,"XXX/XX")   +  
                                        " Inic: "                              + char-aux1  + 
                                        " Fim:  "                              + char-aux2). 
                end.
         END.

    /* --- Verifica o periodo de comercializacao do tipo de plano ------
       --- Se a data da proposta estiver fora do periodo o log ---------
       --- voltara verdadeiro indicando erro na consistencia. ---------- */
    assign lg-erro-processo-aux = no.
    run rtp/rtcomerc.p(input import-propost.cd-modalidade,
                       input import-propost.cd-plano,
                       input import-propost.cd-tipo-plano,
                       input import-propost.dat-propost,
                       output dt-inicio-comerc-aux,
                       output dt-fim-comerc-aux,
                       output lg-erro-processo-aux ) no-error.
    
    if error-status:error
    then do:
           run pi-cria-tt-erros (26,"Problema no acesso a rotina rtcomerc.p"). 
           assign lg-erro-processo-aux = no.
        end.
      
    if lg-erro-processo-aux
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (27,"Periodo de Comercializacao do Plano Invalido"). 
         end.
    
    
    
    /* ------------------ Acrescimo Mensalidade -------------------------*/
    if import-propost.dat-propost > import-propost.dat-fim-propost
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (28,"Data de Inicio da Proposta maior que data de cancelamento "). 
         end.

    if   import-propost.pc-acrescimo <> 0
    then do:
           if   import-propost.dt-lim-acres-mens = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (29,"Data Limite Acresc Mens deve ser infomada"). 
                end.
           ELSE IF import-propost.dt-lim-acres-mens < import-propost.dat-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (30,"Data Limite Acrescimo Mensalidade inferior a Data da Proposta"). 
                     end.
         end.
    else if   import-propost.dt-lim-acres-mens <> ?
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros (31,"Data Limite Acresc Mens Invalida"). 
              end.
    
    if   import-propost.pc-acrescimo-inscr <> 0
    then do:
           if   import-propost.dat-lim-acresc-inscr = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (32,"Data Limite Acresc Inscricao Invalido"). 
                end.
           ELSE if   import-propost.dat-lim-acresc-inscr < import-propost.dat-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (33,"Data Limite Acrescimo Inscricao inferior a Data da Proposta"). 
                     end.
         end.
    else if   import-propost.dat-lim-acresc-inscr <> ?
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros (34,"Data Limite Acresc Inscr Invalida"). 
             end.

    /* ------------------  Desconto promocional taxa ---------------- */
    if  import-propost.dat-valid-prom-tax <> ?
    and import-propost.pc-desc-prom-taxa = 0
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (35,"Data Desc Promoc. Inscricao informada, Percentual nao informado"). 
         end.
    
    if import-propost.pc-desc-prom-taxa <> 0
    then do:
           if   import-propost.dat-valid-prom-tax = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (36,"Data Limite Desconto Promoc. Inscricao Invalida"). 
                end.
           ELSE if   import-propost.dat-valid-prom-tax < import-propost.dat-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (37,"Data Limite Desc Promoc. Inscricao inferior a Data da Proposta"). 
                     end.
         end.
    
    /* -------------------- Desconto promoc Plano ---------------------- */
    
    if  import-propost.dat-valid-prom-plano <> ?
    and import-propost.pc-desc-prom-pl = 0
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (38,"Data Desc. Promoc. Plano informada, Percentual nao informado"). 
         end.
    
    if import-propost.pc-desc-prom-pl <> 0
    then do:
           if   import-propost.dat-valid-prom-plano = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (39,"Data Limite Desconto Promoc. Plano Invalida"). 
                end.
           ELSE if   import-propost.dat-valid-prom-plano < import-propost.dat-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (40,"Data Limite Desc Promoc. Plano inferior a Data da Proposta"). 
                     end.
         end.
    
    if   import-propost.pc-desconto <> 0
    then do:
           if   import-propost.dat-lim-desc-mensal = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (41,"Data Limite Desconto Mensalidade Invalida"). 
                end.
           ELSE if   import-propost.dat-lim-desc-mensal < import-propost.dat-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (42,"Data Limite Desc Mensalidade inferior a Data da Proposta"). 
                     end.
         end.
    else if   import-propost.dat-lim-desc-mensal <> ?
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros (43,"Data Limite Desconto Mensalidade Invalida"). 
             end.
    
    if   import-propost.pc-desconto-inscr <> 0
    then do:
           if   import-propost.dat-lim-desc-inscr = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (44,"Data Limite Desc Inscricao Invalida"). 
                end.
           ELSE if   import-propost.dat-lim-desc-inscr < import-propost.dat-propost
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (45,"Data Limite Desc Inscr inferior a Data da Proposta"). 
                     end.
         end.
    else if   import-propost.dat-lim-desc-inscr <> ?
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros (46,"Data Limite Desc Inscricao Invalida"). 
              end.

    find first b-import-propost where rowid(b-import-propost) = rowid(import-propost) exclusive-lock no-error.
    if avail b-import-propost
    then do: 
           assign b-import-propost.cd-tab-preco-proc     = REPLACE(b-import-propost.cd-tab-preco-proc, "/", "")
                  b-import-propost.cd-tab-preco-proc-cob = REPLACE(b-import-propost.cd-tab-preco-proc-cob, "/", "").
           release b-import-propost.
         END.

    IF NOT CAN-FIND (FIRST tabprepr where tabprepr.cd-tab-preco-proc = import-propost.cd-tab-preco-proc)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (47,"Tabelas Preco Procedimento/Preco Procedimento Cobranca nao cadastradas"). 
         end.
    
    /*------------------------------------------------------------------- */
    if   import-propost.log-mascar 
    then do:
           if   import-propost.des-mascar <> ""
           then do:
                  assign ct-tamanho     = length(import-propost.des-mascar)
                         ct-posicao-ini = 0.
           
                  do ix = ct-posicao-ini + 1 to ct-tamanho:
           
                     if   (substring(import-propost.des-mascar,ix,1) <> "X")
                     and ((substring(import-propost.des-mascar,ix,1) <> "9"))
                     and ((substring(import-propost.des-mascar,ix,1) <> "."))
                     and ((substring(import-propost.des-mascar,ix,1) <> "/"))
                     and ((substring(import-propost.des-mascar,ix,1) <> "-"))
                     then do:
                            assign lg-relat-erro = yes.
                            run pi-cria-tt-erros (48,"Caracter " + substring(import-propost.des-mascar,ix,1) + "invalido para formato da mascara"). 
                          end.
                  end.
                end.
         end.
    else if  import-propost.des-mascar <> ""  
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros (49,"Parametro nao recebe Mascara para Codigo Funcionario"). 
              end.
    
    /* ------------- TIPO DE CONTRATACAO -------------------------------- */
    if  import-propost.in-tipo-contratacao <> 1
    and import-propost.in-tipo-contratacao <> 3
    and import-propost.in-tipo-contratacao <> 4
    and import-propost.in-tipo-contratacao <> 5
    and import-propost.in-tipo-contratacao <> 6
    and import-propost.in-tipo-contratacao <> 99
    then do:                                                              
           assign lg-relat-erro = yes.                                  
           run pi-cria-tt-erros (50,"Tipo de Contratacao Invalido. Recebido: " + string(import-propost.in-tipo-contratacao)).                              
         end.                                                         
    
    /* ------------- TIPO DE NATUREZA JURIDICA DE CONTRATACAO - PTU ----- */
    if import-propost.in-tipo-natureza <> 2 and
       import-propost.in-tipo-natureza <> 3 and
       import-propost.in-tipo-natureza <> 4 and
       import-propost.in-tipo-natureza <> 5
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (51,"Tipo de Natureza Invalida. Recebido: " + string(import-propost.in-tipo-natureza)). 
         end.
    
    /* ------------- TIPO DE VALIDADE DO DOC DE IDENTIFICACAO DO BENEF  - */
    if import-propost.in-validade-doc-ident <> 1 and
       import-propost.in-validade-doc-ident <> 2
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (52,"Tipo de Validade Documento do Benef. Invalido." +
                                 " Informado: " + string(import-propost.in-validade-doc-ident)).
         end.
    
    /* ------------- TIPO DO REGISTRO DO PLANO ------------------------ */
    if  import-propost.in-registro-plano = 0 
    or  import-propost.in-registro-plano > 2 
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (53,"Indicador do Registro de Plano Invalido. Informado: " + string(import-propost.in-registro-plano)). 
         end.
    else if import-propost.in-registro-plano = 1 /* Proposta */
         then do:
                if  (import-propost.cd-registro-plano  = 0  or import-propost.cd-registro-plano  = ?)
                and (import-propost.cd-plano-operadora = "" or import-propost.cd-plano-operadora = ?)
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (54,"Codigo do Registro de Plano Regulamentado ou Nao Regulamentado\Adaptado deve ser informado"). 
                     end.

                if  (import-propost.cd-registro-plano  <> 0  and import-propost.cd-registro-plano  <> ?)
                and (import-propost.cd-plano-operadora <> "" and import-propost.cd-plano-operadora <> ?)
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros (172,"Codigo do Registro de Plano Regulamentado e Codigo do Registro de Plano Nao Regulamentado\Adaptado informados. Informar apenas um."). 
                     end.
                else do:
                       /* Regulamentado */
                       if  import-propost.cd-registro-plano <> 0
                       and import-propost.cd-registro-plano <> ?
                       then do:
                              for first reg-plano-saude fields(cdn-plano-ans idi-registro)
                                  where reg-plano-saude.cdn-plano-ans = import-propost.cd-registro-plano 
                                        no-lock query-tuning(no-index-hint): 
                              end.
                              if not avail reg-plano-saude 
                              then do:
                                     assign lg-relat-erro = yes.
                                     run pi-cria-tt-erros (55,"Codigo do Registro de Plano Deve estar previamente cadastrado: " + string(import-propost.cd-registro-plano)). 
                                   end.
                            end.
                       else do:
                              /* Nao regulamentado */
                              assign import-propost.cd-registro-plano = 0.
                       
                              if import-propost.num-livre-8 = 0
                              or import-propost.num-livre-8 > 3
                              then do:
                                     assign lg-relat-erro = yes.
                                     run pi-cria-tt-erros(171, "Tipo de regulamentacao (import-propost.num-livre-8) informado invalido: " + string(import-propost.num-livre-8)).
                                   end.
                              
                              for first reg-plano-saude fields(cod-plano-operadora idi-registro)
                                  where reg-plano-saude.cod-plano-operadora    = import-propost.cd-plano-operadora 
                                    and reg-plano-saude.in-tipo-regulamentacao = import-propost.num-livre-8
                                        no-lock query-tuning (no-index-hint): 
                              end.
                              if not avail reg-plano-saude 
                              then do:
                                     assign lg-relat-erro = yes.
                                     run pi-cria-tt-erros (56,"Codigo do Registro de Plano Deve estar previamente cadastrado: " + string(import-propost.cd-plano-operadora)). 
                                   end.
                            end.
                     end.
              end.  
         else do:
                /* Benefici rio*/
                if import-propost.num-livre-8 = 0
                or import-propost.num-livre-8 > 3
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros(171, "Tipo de regulamenta‡Æo (import-propost.num-livre-8) informado inv lido: " + string(import-propost.num-livre-8)).
                     end.
              end.
         
    /* ------------------------------------------------------------------- */
    if   import-propost.ind-faixa-etaria-especial <> "S" /*lg-faixa-etaria-esp-imp*/
    and  import-propost.ind-faixa-etaria-especial <> "N"
    and  import-propost.ind-faixa-etaria-especial <> "C"
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (57,"Faixa etaria invalida"). 
         end.
    
    /* ------------------------------------------------------------------- */
    if not (    import-propost.num-mes-ult-faturam = 0 
            and import-propost.aa-ult-fat = 0 )
    and    (   import-propost.num-mes-ult-faturam < 1
            or import-propost.num-mes-ult-faturam > 12
            or import-propost.aa-ult-fat = 0 )
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (58,"Ultimo Mes/Ano de Faturamento Invalido"). 
         end.
    
    if   import-propost.num-mes-ult-faturam <> 0
    and  import-propost.aa-ult-fat <> 0
    then do:
           if import-propost.aa-ult-fat < year(import-propost.dat-propost)
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (59,"Data do ultimo faturamento difere da data de Inicio da proposta").
                end.
    
           if  import-propost.aa-ult-fat =  year(import-propost.dat-propost)
           and import-propost.num-mes-ult-faturam < month(import-propost.dat-propost)
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (60,"Data do ultimo faturamento difere da data de Inicio da proposta").
                end.
         end.
    
    if (import-propost.num-mm-ult-reaj > 0 and import-propost.aa-ult-reajuste = 0)
    OR (import-propost.num-mm-ult-reaj = 0 and import-propost.aa-ult-reajuste > 0)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (61,"Mes X Ano do reajuste de Faturamento Invalido").
         end.
    
    if  import-propost.aa-ult-reajuste > 0
    AND import-propost.dat-fim-propost <> ?
    AND import-propost.aa-ult-reajuste > year(import-propost.dat-fim-propost)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (62,"Ultimo Ano reajuste maior que Ano da excl. da Proposta").
         end.
    
    if import-propost.num-mm-ult-reaj > 0
    then do:
           if import-propost.num-mm-ult-reaj < 1
           or import-propost.num-mm-ult-reaj > 12
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (63,"Ultimo Mes de Reajuste Invalido").
                end.

           if  import-propost.aa-ult-reajuste = year(import-propost.dat-propost)
           and import-propost.num-mm-ult-reaj < month(import-propost.dat-propost)
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (64,"Ultimo Mes reajuste menor que Mes Inicio da Proposta").
                end.

           if  import-propost.dat-fim-propost <> ?
           and import-propost.aa-ult-reajuste = year(import-propost.dat-fim-propost)
           and import-propost.num-mm-ult-reaj > month(import-propost.dat-fim-propost)
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros (65,"Ultimo Mes reajuste maior que Mes da excl. da Proposta").
                end.
         end.
    
    /*---------------------------- CONSISTE CAMPOS DE VALIDADE TERMO ------------*/
    if   substr(import-propost.um-validade-termo,1,1)  = "?"
    or   substr(import-propost.um-validade-termo,2,1)  = "?"
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (66,"Unidade da Validade do termo com valor invalido").
         end.
     
    if    import-propost.qt-validade-termo <> 0
    and  (import-propost.um-validade-termo <> "AA"
    and   import-propost.um-validade-termo <> "MM"
    and   import-propost.um-validade-termo <> "DD")
    then do:
           assign lg-relat-erro = yes.
           IF import-propost.um-validade-termo <> ?
           THEN char-aux1 = import-propost.um-validade-termo.
           ELSE char-aux1 = "".
           run pi-cria-tt-erros (67,"Unidade de Validade do termo deve ser AA,MM ou DD: " + char-aux1).
         end.
    
    if   import-propost.qt-validade-termo = 0
    and (import-propost.um-validade-termo <> "" or import-propost.um-validade-termo <> ?)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (68,"Quantidade de Validade do termo deve ser informada").
         end.
    
    /*---------------------------- CONSISTE CAMPOS DE VALIDADE CARTEIRA --------*/
    if   substr(import-propost.um-validade-cart,1,1)  = "?"
    or   substr(import-propost.um-validade-cart,2,1)  = "?"
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (69,"Unidade da Validade da carteira com valor invalido").
         end.
    
    if   import-propost.qt-validade-cart <> 0
    and (import-propost.um-validade-cart <> "AA"
    and  import-propost.um-validade-cart <> "MM"
    and  import-propost.um-validade-cart <> "DD")
    then do:
           assign lg-relat-erro = yes.
           IF import-propost.um-validade-cart <> ?
           THEN char-aux1 = import-propost.um-validade-cart.
           ELSE char-aux1 = "".
           run pi-cria-tt-erros (70,"Unidade de Validade da carteira deve ser AA,MM ou DD: " + char-aux1).
         end.
    
    if   import-propost.qt-validade-cart = 0
    and (import-propost.um-validade-cart <> "" or import-propost.um-validade-termo <> ?)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (71,"Quantidade de Validade da carteira deve ser informada").
         end.
    
    /*---------------------------- CONSISTE CAMPOS DE VALIDADE CARTAO ------------*/
    if substr(import-propost.um-validade-cartao,1,1)  = "?"
    or substr(import-propost.um-validade-cartao,2,1)  = "?"
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (72,"Unidade da Validade do cartao com valor invalido").
         end.
    
    if    import-propost.qt-validade-cartao <> 0
    and  (import-propost.um-validade-cartao <> "AA"
    and   import-propost.um-validade-cartao <> "MM"
    and   import-propost.um-validade-cartao <> "DD")
    then do:
           assign lg-relat-erro = yes.
           IF import-propost.um-validade-cartao <> ?
           THEN char-aux1 = import-propost.um-validade-cartao.
           ELSE char-aux1 = "".
           run pi-cria-tt-erros (73,"Unidade de Validade do cartao deve ser AA,MM ou DD: " + char-aux1).
         end.
    
    if   import-propost.qt-validade-cartao = 0
    and (import-propost.um-validade-cartao <> "" or import-propost.um-validade-termo <> ?)
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros (74,"Quantidade de Validade do cartao deve ser informada ").
         end.
    
    /*-------------- REAJUSTE DA PROPOSTA -------------------------*/                                     
    IF NOT CAN-FIND (first tip-idx-reaj where tip-idx-reaj.cdn-tip-idx = import-propost.cdn-tip-idx)   
    AND import-propost.cdn-tip-idx <> 0
    then do:
           assign lg-relat-erro = yes.                                                                    
           run pi-cria-tt-erros (75,"Tipo de Indice nao Cadastrado").
         end.                                                                                             
    
    if import-propost.cdn-niv-reaj < 0
    or import-propost.cdn-niv-reaj > 2
    then do:                                                                                              
           assign lg-relat-erro = yes.                                                                    
           run pi-cria-tt-erros (76,"Nivel do reajuste invalido").                                                       
         end. 

end procedure.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-dados-modulos:
 
    IF NOT CAN-FIND (FIRST import-modul-propost WHERE import-modul-propost.num-seqcial-propost = import-propost.num-seqcial-propost)
    THEN DO:
           RUN pi-cria-tt-erros (170,"Nenhum modulo (tabela import-modul-propost) encontrado").
           ASSIGN lg-relat-erro = YES.
           RETURN.
         END.

    FOR EACH import-modul-propost FIELDS (cd-modulo cd-forma-pagto 
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
       WHERE import-modul-propost.num-seqcial-propost = import-propost.num-seqcial-propost NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

        for first pla-mod fields (cd-modulo lg-obrigatorio)
            where pla-mod.cd-modalidade = import-propost.cd-modalidade
              and pla-mod.cd-plano      = import-propost.cd-plano
              and pla-mod.cd-tipo-plano = import-propost.cd-tipo-plano
              and pla-mod.cd-modulo     = import-modul-propost.cd-modulo NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
        end.

        if   not avail pla-mod
        then do:
               IF import-modul-propost.cd-modulo <> ?
               THEN ASSIGN char-aux1 = string(import-modul-propost.cd-modulo,"999").
               ELSE ASSIGN char-aux1 = "0".
               run pi-cria-tt-erros (77,"Modulo nao Cadastrado para Mod: " + STRING(import-propost.cd-modalidade) + 
                                        " /Plano: "  + STRING(import-propost.cd-plano) + 
                                        " /Tipo: "   + STRING(import-propost.cd-tipo-plano) + 
                                        " /Modulo: " + char-aux1).
               assign lg-relat-erro = YES.
               NEXT.
             end.

        FOR FIRST mod-cob FIELDS(in-identifica-modulo) 
            where mod-cob.cd-modulo = import-modul-propost.cd-modulo NO-LOCK:
        END.

        if   not avail mod-cob
        then do:
               IF import-modul-propost.cd-modulo <> ?
               THEN ASSIGN char-aux1 = string(import-modul-propost.cd-modulo,"999").
               ELSE ASSIGN char-aux1 = "0".
               run pi-cria-tt-erros (78,"Modulo nao Cadastrado - Modulo: " + char-aux1).
               assign lg-relat-erro  = yes.
             end.

        else if mod-cob.in-identifica-modulo = "A"  
             and import-propost.log-segassist 
             then do:
                    IF import-modul-propost.cd-modulo <> ?
                    THEN ASSIGN char-aux1 = string(import-modul-propost.cd-modulo,"999").
                    ELSE ASSIGN char-aux1 = "0".
                    run pi-cria-tt-erros (79,"Proposta usufrui de seguro assistencial, impossivel incluir modulo: " + char-aux1).
                    assign lg-relat-erro  = yes.
                  end.    

        IF NOT CAN-FIND (FIRST tabpremo 
                         where tabpremo.cd-modalidade = import-propost.cd-modalidade
                           and tabpremo.cd-plano      = import-propost.cd-plano
                           and tabpremo.cd-tipo-plano = import-propost.cd-tipo-plano
                           and tabpremo.cd-modulo     = pla-mod.cd-modulo
                           and tabpremo.cd-tab-preco  = import-propost.cd-tab-preco)
        then do:
               assign lg-relat-erro  = yes.
               IF import-propost.cd-modalidade <> ?
               THEN char-aux1 = STRING(import-propost.cd-modalidade).
               ELSE char-aux1 = "0".
               IF import-propost.cd-plano <> ?
               THEN char-aux2 = STRING(import-propost.cd-plano).
               ELSE char-aux2 = "0".
               IF import-propost.cd-tipo-plano <> ?
               THEN char-aux3 = STRING(import-propost.cd-tipo-plano).
               ELSE char-aux3 = "0".
               IF pla-mod.cd-modulo <> ?
               THEN char-aux4 = STRING(pla-mod.cd-modulo).
               ELSE char-aux4 = "0".
               IF import-propost.cd-tab-preco <> ?
               THEN char-aux5 = substring(import-propost.cd-tab-preco,1,3) + "/" + 
                                substring(import-propost.cd-tab-preco,4,2).
               ELSE char-aux5 = "000/00".

               run pi-cria-tt-erros (80,"Tabela de Preco dos modulos nao cadastrada." +
                                     " Modalidade: " + char-aux1 + 
                                     " Plano: "      + char-aux2 +
                                     " Tipo: "       + char-aux3 +
                                     " Modulo: "     + char-aux4 +
                                     " Tabela: "     + char-aux5).
             end.

        if   import-modul-propost.cd-forma-pagto <> 1
        and  import-modul-propost.cd-forma-pagto <> 2
        then do:
               run pi-cria-tt-erros (81,"Forma de Pagamento Invalida para este Modulo - Forma Pagto: " + string(import-modul-propost.cd-forma-pagto,"99")).
               assign lg-relat-erro  = yes.
             end.

         IF NOT CAN-FIND (FIRST formpaga where formpaga.cd-forma-pagto = import-modul-propost.cd-forma-pagto)
         then do:
                run pi-cria-tt-erros (82,"Forma de Pagamento nao Cadastrada - Forma Pagto: " + string(import-modul-propost.cd-forma-pagto,"99")).   
                assign lg-relat-erro  = yes.
              END.

         if   import-modul-propost.ind-respons-autoriz <> "E"
         and  import-modul-propost.ind-respons-autoriz <> "U"
         and  import-modul-propost.ind-respons-autoriz <> "A"
         and  import-modul-propost.ind-respons-autoriz <> "N"
         then do:
                run pi-cria-tt-erros (83,"Responsavel Autorizacao Invalido "  + import-modul-propost.ind-respons-autoriz).
                assign lg-relat-erro  = yes.
              end.

         if  import-modul-propost.in-cobra-participacao < 1
         OR  import-modul-propost.in-cobra-participacao > 9
         then do:
                run pi-cria-tt-erros (84,"Indicador p/cobrar participacao invalido " + string(import-modul-propost.in-cobra-participacao, "9")).
                assign lg-relat-erro  = yes
                       lg-modulo-erro = yes.
              end.

         if   import-modul-propost.dat-inicial = ?
         then do:
                run pi-cria-tt-erros (85,"Data Inicio do Modulo da Proposta Invalida - Data informada: ?").
                assign lg-relat-erro  = yes
                       lg-modulo-erro = yes.
              end.
         ELSE if   import-modul-propost.dat-inicial < import-propost.dat-propost
              then do:
                     run pi-cria-tt-erros (86,"Data de Inicio do Modulo Menor que Data da Proposta ").
                     assign lg-relat-erro  = yes
                            lg-modulo-erro = yes.
                   end.

         if  import-modul-propost.dat-cancel = ?
         THEN DO:
                IF import-modul-propost.cd-motivo-cancel <> 0
                then do:
                       run pi-cria-tt-erros (87,"Motivo de cancelamento nao deve ser informado").
                       assign lg-relat-erro  = yes
                              lg-modulo-erro = yes.
                     end. 

                if  import-propost.dat-fim-propost <> ?
                then do:
                       run pi-cria-tt-erros (88,"Proposta Cancelada X Modulo Ativo").
                       assign lg-relat-erro  = yes
                              lg-modulo-erro = yes.
                     end.
              END.
         ELSE DO:
                if   pla-mod.lg-obrigatorio
                and  import-propost.dat-fim-propost = ?
                then do:
                       run pi-cria-tt-erros (89,"Modulo obrigatorio para estrutura do produto. Modulo: " + string(import-modul-propost.cd-modulo) + " nao pode estar cancelado").
                       assign lg-relat-erro  = yes
                              lg-modulo-erro = yes.
                     end.

                if import-modul-propost.dat-cancel > import-propost.dat-fim-propost
                then do:
                       run pi-cria-tt-erros (90,"Data de final do modulo nao pode ser maior que data de final da proposta").
                       assign lg-relat-erro  = yes
                              lg-modulo-erro = yes.        
                     end.
                
                IF import-modul-propost.cd-motivo-cancel = 0
                or import-modul-propost.cd-motivo-cancel = ?
                then do:
                       run pi-cria-tt-erros (91,"Motivo do cancelamento obrigatorio").
                       assign lg-relat-erro  = yes
                              lg-modulo-erro = yes.
                     end. 
                ELSE DO:
                       FOR FIRST motcange FIELDS (in-tipo-obito-ans)
                           where motcange.in-entidade = "MC"
                             and motcange.cd-motivo   = import-modul-propost.cd-motivo-cancel no-lock:
                       END.

                       if   not available motcange
                       then do:
                              run pi-cria-tt-erros (92,"Codigo motivo de cancelamento do modulo nao cadastrado"). 
                              assign lg-relat-erro  = yes
                                     lg-modulo-erro = yes.
                            end.
                       else if motcange.in-tipo-obito-ans > 0 
                            then do:
                                   run pi-cria-tt-erros (93,"Codigo motivo de cancelamento do modulo nao pode indicar obito").
                                   assign lg-relat-erro  = yes
                                          lg-modulo-erro = yes.
                                 end.
                     END.
              END.

        /* Indicador de controle de carencia de procedimento */
        if  import-modul-propost.in-ctrl-carencia-proced <> 0
        and import-modul-propost.in-ctrl-carencia-proced <> 1
        and import-modul-propost.in-ctrl-carencia-proced <> 2
        then do:
               run pi-cria-tt-erros (94,"Indicador controle de carencia de procedimento invalido " + string(import-modul-propost.in-ctrl-carencia-proced,"9")).
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
             end.          

        /* Indicador de controle de carencia de insumo */
        if  import-modul-propost.in-ctrl-carencia-insumo <> 0
        and import-modul-propost.in-ctrl-carencia-insumo <> 1
        and import-modul-propost.in-ctrl-carencia-insumo <> 2
        then do:
               run pi-cria-tt-erros (95,"Indicador controle de carencia de insumo invalido " + string(import-modul-propost.in-ctrl-carencia-insumo,"9")).
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
             end.

        if pla-mod.lg-obrigatorio
        THEN DO:
               IF in-classif = 2
               then do:
                      run pi-cria-tt-erros (96,"Param. para modulo opcional Impossivel incluir modulo obrig. " + string(import-modul-propost.cd-modulo,"999")).
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
             END.
        ELSE IF in-classif = 1
             then do:
                    run pi-cria-tt-erros (97,"Param. para modulo obrig. Impossivel incluir modulo opcional "). 
                    assign lg-relat-erro  = yes
                           lg-modulo-erro = yes.
                  end.

        if import-propost.cd-forma-pagto <> 3 and
           import-propost.cd-forma-pagto <>
           import-modul-propost.cd-forma-pagto
        then do:
               run pi-cria-tt-erros (98,"Forma de pagamento dos modulos deve ser igual a da proposta").
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
             end.

    END.

END.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-dados-faixa:

    IF import-propost.ind-faixa-etaria-especial <> "N"
    AND NOT modalid.lg-usa-faixa-etaria
    THEN DO:
           run pi-cria-tt-erros (165,"Modalidade nao permite faixa etaria especial. Modalidade: " + STRING(modalid.cd-modalidade)).
           assign lg-relat-erro = yes.
         END.

    FOR EACH import-faixa-propost FIELDS (cd-grau-parentesco nr-faixa-etaria num-idade-min num-idade-max qtd-fator-multiplic qtd-fator-multiplic-inscr)
       where import-faixa-propost.num-seqcial-propost = import-propost.num-seqcial-propost NO-LOCK QUERY-TUNING (NO-INDEX-HINT):

        if  import-propost.ind-faixa-etaria-especial = "N"
        then do:
               run pi-cria-tt-erros (99,"Proposta nao permite faixa etaria especial").
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST gra-par where gra-par.cd-grau-parentesco = import-faixa-propost.cd-grau-parentesco)
        then do:
               run pi-cria-tt-erros (100,"Grau de Parentesco nao Cadastrado - Grau: " + string(import-faixa-propost.cd-grau-parentesco,"99")).
               assign lg-relat-erro = yes.
             end.
        
        if  import-faixa-propost.nr-faixa-etaria = 0
        then do:
               run pi-cria-tt-erros (101,"Numero da faixa etaria Invalida - Faixa Etaria: " + string(import-faixa-propost.nr-faixa-etaria,"99")).
               assign lg-relat-erro = yes.
             end.
        
        if import-faixa-propost.num-idade-min < 0
        then do:
               run pi-cria-tt-erros (102,"Idade Minima Invalida - Idade Minima: " + string(import-faixa-propost.num-idade-min,"999")).
               assign lg-relat-erro = yes.
              end.
        
        if import-faixa-propost.num-idade-max = 0
        then do:
               run pi-cria-tt-erros (103,"Idade Maxima Invalida - Idade Maxima: " + string(import-faixa-propost.num-idade-max,"999")).
               assign lg-relat-erro = yes.
             end.
        
        if import-faixa-propost.num-idade-min > import-faixa-propost.num-idade-max
        then do:
               run pi-cria-tt-erros (104,"Idade Minima maior que Idade Maxima ").
               assign lg-relat-erro = yes.
             end.
    END.

END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-dados-negociac:

    FOR EACH import-negociac-propost FIELDS (cd-unimed cd-forma-pagto cd-plano cd-tipo-plano cdn-tip-vencto num-dia-vencto um-carencia dat-fim-repas dat-inic-repas cd-tab-preco cd-tab-preco-proc cdn-tip-vencto in-tipo-valorizacao num-mes-ult-repas aa-ult-repasse)
       where import-negociac-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock :

        if  modalid.lg-aceita-repasse = no
        and modalid.lg-repasse-obrig  = no
        then do:
               run pi-cria-tt-erros (105,"Modalidade nao Permite Repasse - Modalidade: " + string(import-propost.cd-modalidade,"99")).
               assign lg-relat-erro = yes.
             end.    
        
        IF NOT CAN-FIND (FIRST unimed where unimed.cd-unimed = import-negociac-propost.cd-unimed)
        then do:
               run pi-cria-tt-erros (106,"Unidade nao Cadastrada - Unidade: " + string(import-negociac-propost.cd-unimed,"9999")).
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST formpaga where formpaga.cd-forma-pagto = import-negociac-propost.cd-forma-pagto)
        then do:
               run pi-cria-tt-erros (107,"Forma de Pagamento nao Cadastrada - Forma Pagto: " + string(import-negociac-propost.cd-forma-pagto,"99")).
               assign lg-relat-erro = yes.
             end.

        FOR FIRST for-pag FIELDS (tp-vencimento dd-faturamento)
            where for-pag.cd-modalidade  = import-propost.cd-modalidade
              and for-pag.cd-plano       = import-negociac-propost.cd-plano
              and for-pag.cd-tipo-plano  = import-negociac-propost.cd-tipo-plano
              and for-pag.cd-forma-pagto = import-negociac-propost.cd-forma-pagto no-lock:
        END.
        
        if not avail for-pag
        then do:
               run pi-cria-tt-erros (108,"Forma de Pagamento dos Tipos de Planos nao Cadastrada para a negociacao - " + string(import-negociac-propost.cd-forma-pagto,"99")).
               assign lg-relat-erro = yes.
             end.
        else do:
               assign lg-passou = no.
               do ix = 1 to 31:
                    if   for-pag.tp-vencimento[ix]  = import-negociac-propost.cdn-tip-vencto
                    and  for-pag.dd-faturamento[ix] = import-negociac-propost.num-dia-vencto
                    then do:
                           assign lg-passou = yes.
                           leave.
                         end.
               end.
               if   not lg-passou
               then do:
                      run pi-cria-tt-erros (109,"Tipo/Dia de vencimento invalido p/ Negociacao").
                      assign lg-relat-erro = yes.
                    end.
             end.
        
        if  import-negociac-propost.um-carencia <> "DD"
        and import-negociac-propost.um-carencia <> "MM"
        and import-negociac-propost.um-carencia <> "AA"
        then do:
               run pi-cria-tt-erros (110,"Unidade de Carencia Invalida" + import-negociac-propost.um-carencia).
               assign lg-relat-erro = yes.
             end.

        if  import-propost.dat-fim-propost = ?
        THEN DO:
               if import-negociac-propost.dat-fim-repas <> ?
               then do:
                      run pi-cria-tt-erros (111,"Proposta Ativa X Repasse Cancelado").
                      assign lg-relat-erro = yes.
                    end.
             END.
        ELSE DO:
                if import-negociac-propost.dat-fim-repas = ?
                then do:
                       run pi-cria-tt-erros (112,"Proposta Cancelada X Repasse Ativo").
                       assign lg-relat-erro = yes.
                     end.
                
                if import-propost.dat-fim-propost <> import-negociac-propost.dat-fim-repas
                then do:
                       run pi-cria-tt-erros (113,"Data de fim da proposta diferente de fim da negociacao").
                       assign lg-relat-erro = yes.
                     end.

                if import-negociac-propost.dat-inic-repas > import-propost.dat-fim-propost
                then do:
                       run pi-cria-tt-erros (114,"Data de inicio negociacao superior a final da proposta").
                       assign lg-relat-erro = yes.
                     end.
             END.
        
        if import-negociac-propost.dat-inic-repas < import-propost.dat-propost
        then do:
               run pi-cria-tt-erros (115,"Data de inicio negociacao inferior a inicio da proposta").
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST tabprepl where tabprepl.cd-tab-preco = import-negociac-propost.cd-tab-preco)
        then do:
               run pi-cria-tt-erros (116,"Tabela de Preco nao Cadastrada" + import-negociac-propost.cd-tab-preco).
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (first tabpremo
                         where tabpremo.cd-modalidade  = import-propost.cd-modalidade
                           and tabpremo.cd-plano       = import-negociac-propost.cd-plano
                           and tabpremo.cd-tipo-plano  = import-negociac-propost.cd-tipo-plano
                           and tabpremo.cd-tab-preco   = import-negociac-propost.cd-tab-preco )
        then do:
               run pi-cria-tt-erros (117,"Tabela de Preco dos Modulos Plano de Saude nao Cadastrada " + import-negociac-propost.cd-tab-preco).
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST tabprepr where tabprepr.cd-tab-preco-proc = import-negociac-propost.cd-tab-preco-proc)
        then do:
               run pi-cria-tt-erros (118,"Tabela de Preco do Procedimento nao Cadastrada " + import-negociac-propost.cd-tab-preco-proc).
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST tipovenc where tipovenc.cd-tipo-vencimento = import-negociac-propost.cdn-tip-vencto)
        then do:
               run pi-cria-tt-erros (119,"Tipo de Vencimento nao Cadastrado" + string(import-negociac-propost.cdn-tip-vencto,"99")).
               assign lg-relat-erro = yes.
             end.
        
        if import-negociac-propost.num-dia-vencto < 01 
        or import-negociac-propost.num-dia-vencto > 31
        then do:
               run pi-cria-tt-erros (120,"Dia para vencimento invalido" + string(import-negociac-propost.cdn-tip-vencto,"99")).
               assign lg-relat-erro = yes.
             end.
        
        if  import-negociac-propost.in-tipo-valorizacao <> 1
        and import-negociac-propost.in-tipo-valorizacao <> 0
        then do:
               run pi-cria-tt-erros (121,"Tipo de Valorizacao de CO invalido" + string(import-negociac-propost.in-tipo-valorizacao)).
               assign lg-relat-erro = yes.
             end.
        
        if import-negociac-propost.num-mes-ult-repas = 0
        then do:
               run pi-cria-tt-erros (122,"Ultimo mes de Repasse deve ser informado").
               assign lg-relat-erro = yes.
             end.
        
        if import-negociac-propost.aa-ult-repasse = 0
        then do:
               run pi-cria-tt-erros (123,"Ultimo ano de Repasse deve ser informado").
               assign lg-relat-erro = yes.
             end.
        
        if import-propost.num-mes-ult-faturam <> import-negociac-propost.num-mes-ult-repas
        then do:
               run pi-cria-tt-erros (124,"Ultimo mes Faturado difere do Ultimo mes do Repasse").
               assign lg-relat-erro = yes.
             end.
        
        if import-propost.aa-ult-fat <> import-negociac-propost.aa-ult-repasse
        then do:
               run pi-cria-tt-erros (125,"Ultimo ano Faturado difere do Ultimo ano do Repasse").
               assign lg-relat-erro = yes.
             end.
        
    END.

END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE pi-cria-tt-erros:

    DEF INPUT PARAM id-erro-par AS INT  NO-UNDO.
    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.
    
    DEF VAR num-seq-aux AS INT NO-UNDO.

    FOR LAST b-tt-erro FIELDS (nr-seq) 
       WHERE b-tt-erro.nr-seq-contr = import-propost.num-seqcial-control NO-LOCK:
    END.

    CREATE tt-erro.

    IF AVAIL b-tt-erro
    THEN ASSIGN num-seq-aux = b-tt-erro.nr-seq + 1.
    ELSE ASSIGN num-seq-aux = 1.

    IF ds-erro-par <> ?
    THEN.
    ELSE ds-erro-par = "ERRO NA MONTAGEM DA MENSAGEM. VERIFIQUE VALORES NULOS.".

    ASSIGN tt-erro.nr-seq            = num-seq-aux
           tt-erro.nr-seq-contr      = import-propost.num-seqcial-control
           tt-erro.nom-tab-orig-erro = "BE" + " - import-propost" 
           tt-erro.des-erro          = "(" + string(id-erro-par) + ") " + ds-erro-par. 

    /*OUTPUT STREAM s-rel-erro TO VALUE(nm-rel-erro-aux) APPEND.
    PUT STREAM s-rel-erro UNFORMATTED tt-erro.nr-seq-contr " "
                                      tt-erro.nom-tab-orig-erro " "
                                      tt-erro.des-erro SKIP.
    OUTPUT STREAM s-rel-erro CLOSE.
    */
END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
procedure pi-grava-erro:

    def var nro-seq-aux as int initial 0 no-undo.

    FOR EACH tt-erro FIELDS(nr-seq-contr nom-tab-orig-erro des-erro) EXCLUSIVE-LOCK:

        IF nro-seq-aux = 0
        THEN do:
               IF CAN-FIND (FIRST erro-process-import WHERE erro-process-import.num-seqcial-control = tt-erro.nr-seq-contr)
               THEN RUN pi-consulta-prox-seq (INPUT tt-erro.nr-seq-contr, OUTPUT nro-seq-aux).
               ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
             END.
        ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.

        /**
         * Garantir unicidade da chave.
         */
        create erro-process-import.
        REPEAT:
            assign erro-process-import.num-seqcial         = nro-seq-aux
                   erro-process-import.num-seqcial-control = tt-erro.nr-seq-contr NO-ERROR.
            VALIDATE erro-process-import NO-ERROR.
            IF ERROR-STATUS:ERROR
            OR ERROR-STATUS:NUM-MESSAGES > 0
            THEN do:
                   ASSIGN nro-seq-aux = nro-seq-aux + 1.
                   PAUSE(1). /* aguarda 1seg e busca novamente o proximo nr livre.*/
                 END.
            else leave.    /* o nr gerado eh valido. continua o processo.*/
        END.

        ASSIGN erro-process-import.nom-tab-orig-erro   = tt-erro.nom-tab-orig-erro
               erro-process-import.des-erro            = tt-erro.des-erro
               erro-process-import.dat-erro            = today. 

        FOR FIRST control-migrac FIELDS (ind-sit-import)
            WHERE control-migrac.num-seqcial = tt-erro.nr-seq-contr EXCLUSIVE-LOCK:
        END.
        if avail control-migrac
        then assign control-migrac.ind-sit-import = "PE".

        FOR FIRST b-import-propost FIELDS (ind-sit-import) 
            WHERE b-import-propost.num-seqcial-control = erro-process-import.num-seqcial-control EXCLUSIVE-LOCK:
        END.
        IF AVAIL b-import-propost
        THEN DO:        
               ASSIGN b-import-propost.ind-sit-import = "PE".

               RELEASE  b-import-propost.
               VALIDATE b-import-propost.
             END.

        DELETE tt-erro.
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
    OR nro-seq-par = 0
    then assign nro-seq-par = 1.
    else assign nro-seq-par = nro-seq-par + 1.

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure mostra-erro.

    FOR EACH tt-erro NO-LOCK:

        display stream s-relat-erro
                tt-erro.nr-seq-contr          
                tt-erro.nom-tab-orig-erro  
                tt-erro.des-erro             
                with frame f-erro.  
        down stream s-relat-erro with frame f-erro.

    END.
 
end procedure.

/* ---------------------------------------------------------------------------------------------- */
procedure consiste-contrat:

  def buffer b-contrat for contrat.
    
  if import-propost.nr-insc-contratante = 0
  or import-propost.nr-insc-contratante = ?
  then do:
         assign lg-relat-erro = yes.
         run pi-cria-tt-erros (167,"Inscricao do Contratante Zero ou nula").
         return.
       end.

  for first contrat fields (nr-cgc-cpf in-fiador)
      where contrat.nr-insc-contratante = import-propost.nr-insc-contratante NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
  end.
   
  if not avail contrat
  then do:
         assign lg-relat-erro = yes.
         if import-propost.nr-cgc-cpf <> ?
         then assign char-aux1 = string(import-propost.nr-cgc-cpf).
         else assign char-aux1 = "0".
         if import-propost.nr-insc-contratante <> ?
         then assign char-aux2 = string(import-propost.nr-insc-contratante).
         else assign char-aux2 = "0".
         if import-propost.nr-insc-contrat-origem <> ?
         then assign char-aux3 = string(import-propost.nr-insc-contrat-origem).
         else assign char-aux3 = "0".
         run pi-cria-tt-erros (138,"Contratante nao encontrado." +
                                   " CGC/CPF: "   + char-aux1    +
                                   " Insc: "      + char-aux2    +
                                   " Insc.Orig: " + char-aux3).
       end.
  else do:
         if   contrat.in-fiador = "F"
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros (131,"Contratante cadastrado como fiador nao pode ter proposta").                                 
              end.
         
         assign nr-insc-contrat-aux = contrat.nr-insc-contratante.
       end.

    if   import-propost.nr-insc-contrat-origem <> 0
    and  import-propost.nr-insc-contrat-origem <> ?
    then do:
           for first b-contrat fields (cd-contratante) 
               where b-contrat.nr-insc-contratante = import-propost.nr-insc-contrat-origem exclusive-lock query-tuning (no-index-hint):
           end.

           if not can-find(first ems5.cliente 
                           where ems5.cliente.cod_empresa = string(paramecp.ep-codigo)
                             and ems5.cliente.cdn_cliente = int(b-contrat.cd-contratante))
           then do:
                   assign lg-relat-erro = YES.
                   run pi-cria-tt-erros (169,"Contratante Origem informado nao possui Cliente no EMS").
                end.
         end.

end procedure.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-dados-cobertura:

    FOR EACH import-padr-cobert-propost where import-padr-cobert-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock :

        IF NOT CAN-FIND (FIRST pad-cob where pad-cob.cd-padrao-cobertura = import-padr-cobert-propost.cd-padrao-cobertura)
        then do:
               run pi-cria-tt-erros (139,"Padrao de Cobertura nao Cadastrado" + import-padr-cobert-propost.cd-padrao-cobertura).
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST ftpadcob 
                         where ftpadcob.cd-modalidade       = import-propost.cd-modalidade
                           and ftpadcob.cd-plano            = import-propost.cd-plano
                           and ftpadcob.cd-tipo-plano       = import-propost.cd-tipo-plano
                           and ftpadcob.cd-padrao-cobertura = import-padr-cobert-propost.cd-padrao-cobertura
                           and ftpadcob.cd-modulo           = import-padr-cobert-propost.cd-modulo)
        then do:
               run pi-cria-tt-erros (140,"Padrao de Cobertura com Percentuais nao Cadastrado" +
                                     " MODALIDADE " + STRING(import-propost.cd-modalidade)    +
                                     " PLANO "      + STRING(import-propost.cd-plano)         +
                                     " TIPO PLANO " + STRING(import-propost.cd-tipo-plano) + 
                                     " PADRAO "     + import-padr-cobert-propost.cd-padrao-cobertura + 
                                     " MODULO "     + STRING(import-padr-cobert-propost.cd-modulo)).
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST mod-cob where mod-cob.cd-modulo = import-padr-cobert-propost.cd-modulo)
        then do:
               run pi-cria-tt-erros (141,"Modulo de Cobertura nao Cadastrado " + string(import-padr-cobert-propost.cd-modulo,"999")).
               assign lg-relat-erro = yes.
             end.        
    END.

END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-campos-proposta:

    FOR EACH import-campos-propost where import-campos-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock :

        if  import-campos-propost.des-campo-1 = ""
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros (142,"Campo 1 - tipo de registro 6 nao foi informado").
             end.
        
        if import-campos-propost.des-mascar-1 = ""
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros (143,"Mascara 1 - tipo de registro 6 nao foi informada").
             end.

    END.

END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-proced-propost:

    FOR EACH import-proced-propost where import-proced-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock :

        IF NOT CAN-FIND (FIRST mod-cob where mod-cob.cd-modulo = import-proced-propost.cd-modulo)
        then do:
               run pi-cria-tt-erros (144,"Modulo nao cadastrado " + string(import-proced-propost.cd-modulo,"999")).
        
               assign lg-relat-erro = yes.
             end.
        
        IF NOT CAN-FIND (FIRST ambproce 
                         where ambproce.cd-esp-amb        = int(substr(string(import-proced-propost.cd-amb,"99999999"),01,02))
                           and ambproce.cd-grupo-proc-amb = int(substr(string(import-proced-propost.cd-amb,"99999999"),03,02))
                           and ambproce.cd-procedimento   = int(substr(string(import-proced-propost.cd-amb,"99999999"),05,03))
                           and ambproce.dv-procedimento   = int(substr(string(import-proced-propost.cd-amb,"99999999"),08,01)))
        then do:
               run pi-cria-tt-erros (145,"Tabela de Procedimento nao Cadastrada " + string(import-proced-propost.cd-amb,"99999999")).
               assign lg-relat-erro = yes.
             end.
        
        if not import-propost.log-cobert-especial 
        then do:
               run pi-cria-tt-erros (146,"Parametro da Proposta nao permite cobertura especial").
               assign lg-relat-erro = yes.
             end.

        if   import-propost.dat-fim-propost = ?
        THEN DO:
               if import-proced-propost.dt-cancela <> ?
               then do:
                      run pi-cria-tt-erros (147,"Proposta Ativa X Procedimento Cancelado").
                      assign lg-relat-erro = yes.
                    end.
             END.
        ELSE DO:
               if import-proced-propost.dt-cancela = ?
               then do:
                      run pi-cria-tt-erros (148,"Proposta Cancelada X Procedimento Ativo").
                      assign lg-relat-erro = yes.
                    end.
               
               if   import-proced-propost.dt-cancela > import-propost.dat-fim-propost
               then do:
                      run pi-cria-tt-erros (149,"Data de cancelamento do procedimento maior que data de cancelamento da proposta").
                      assign lg-relat-erro = yes.
                    end.
             END.
        
        if   import-proced-propost.dt-inicial = ?
        then do:
               run pi-cria-tt-erros (150,"Data Inicio Invalida ").
               assign lg-relat-erro = yes.
             end.
    
    END.

END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-mo:

    FOR EACH import-mo-propost FIELDS (cd-departamento cd-secao cd-setor)
       where import-mo-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock :

        run rtp/rttipmed.p(input        import-propost.cd-modalidade,
                           input        no,
                           output       lg-relat-erro,
                           output       ds-mensagem-aux,
                           input-output lg-medocup-aux) no-error.
        
        if error-status:error
        then do:
               if error-status:num-messages = 0
               then run pi-cria-tt-erros (151,"Ocorreram erros na execucao da RTTIPMED").                          
               else run pi-cria-tt-erros (152,"Ocorreram erros na execucao da RTTIPMED. " + substring(error-status:get-message(error-status:num-messages),1,175)).
               assign lg-relat-erro = yes.
             end.
        
        if not lg-medocup-aux
        then do:
               run pi-cria-tt-erros (153,"Registro do Tipo 8 deve ser informado apenas para mod.de medicina ocupacional").
               assign lg-relat-erro = yes.
             end.
        
        /*----- VERIFICA DEPARTAMENTO ----------------------------------------*/
        if  import-mo-propost.cd-departamento = 0
        then do:
               run pi-cria-tt-erros (154,"Departamento - tipo de registro 8 nao foi informado").
               assign lg-relat-erro = yes.
             end.
        ELSE IF NOT CAN-FIND (FIRST departa where departa.cd-departamento = import-mo-propost.cd-departamento)
             then do:
                    run pi-cria-tt-erros (155,"Departamento nao Cadastrado - " + string(import-mo-propost.cd-departamento,"999")).
                    assign lg-relat-erro = yes.
                  end.
         
         /*----- VERIFICA SECAO -----------------------------------------------*/
        if  import-mo-propost.cd-secao = 0
        then do:
               run pi-cria-tt-erros (156,"Secao - tipo de registro 8 nao foi informado").
               assign lg-relat-erro = yes.
             end.
        ELSE IF NOT CAN-FIND (FIRST secao where secao.cd-secao = import-mo-propost.cd-secao)
             then do:
                    run pi-cria-tt-erros (157,"Secao nao Cadastrada - " + string(import-mo-propost.cd-secao,"999")).
                    assign lg-relat-erro = yes.
                  end.

        /*----- VERIFICA SETOR -----------------------------------------------*/
        if  import-mo-propost.cd-setor = 0
        then do:
               run pi-cria-tt-erros (158,"Setor - tipo de registro 8 nao foi informado").
               assign lg-relat-erro = yes.
             end.
        ELSE IF NOT CAN-FIND (FIRST setor where setor.cd-setor = import-mo-propost.cd-setor)
             then do:
                    run pi-cria-tt-erros (159,"Setor nao Cadastrado - " + string(import-mo-propost.cd-setor,"999")).
                    assign lg-relat-erro = yes.
                  end.
        END.

END PROCEDURE.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE consiste-mo-funcao:

    FOR EACH import-funcao-propost where import-funcao-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock :

        find first import-mo-propost where import-mo-propost.num-seqcial-propost = import-propost.num-seqcial-propost no-lock no-error.

        run rtp/rttipmed.p(input        import-propost.cd-modalidade,
                           input        no,
                           output       lg-relat-erro,
                           output       ds-mensagem-aux,
                           input-output lg-medocup-aux) no-error.
        
        if error-status:error
        then do:
               if error-status:num-messages = 0
               then run pi-cria-tt-erros (160,"Ocorreram erros na execucao da RTTIPMED").                       
               else run pi-cria-tt-erros (161,"Ocorreram erros na execucao da RTTIPMED. " + substring(error-status:get-message(error-status:num-messages),1,175)).
               assign lg-relat-erro = yes.
             end.
        
        if not lg-medocup-aux
        then do:
               run pi-cria-tt-erros (162,"Registro do Tipo 9 deve ser informado apenas para mod.de medicina ocupacaional").
               assign lg-relat-erro = yes.
             end.
        
        /*----- VERIFICA SE EH CAMPO ZERADO -------------------------------------*/                
        if  import-funcao-propost.cd-funcao = 0
        then do:
               run pi-cria-tt-erros (163,"Funcao - tipo de registro 9 nao foi informado").
               assign lg-relat-erro = yes.
             end.
        
        /******************** FUNCAO ***************************************/
        IF NOT CAN-FIND (FIRST funcempr where funcempr.cd-funcao = import-funcao-propost.cd-funcao)
        then do:
               run pi-cria-tt-erros (164,"Funcao Empresa nao cadastrada. (Registro 9)").
               assign lg-relat-erro = yes.
             end.

    END.

END PROCEDURE.

PROCEDURE escrever-log:
    DEF INPUT PARAMETER ds-par AS CHAR NO-UNDO.
END PROCEDURE.

/* ------------------------------------------------------------------------------------------------- */
