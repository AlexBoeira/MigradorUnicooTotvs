def input param in-batch-online-par     as char no-undo.
def input param in-status-monitorar-par AS char no-undo.
def input param lg-plano-par            as log  no-undo.
def input param lg-medocup-par          as log  no-undo.
def input param lg-registro-modulos-par as log  no-undo.
def input param lg-registro-repasse-par as log  no-undo.
def input param in-classif-par          as int  no-undo.
def input param qt-sair-par             as int  no-undo.
def input param in-status-benef-par     as char no-undo.
def input param in-carteira-antig-par   as char no-undo.      

/*ATENCAO: essa data eh utilizada em elguns pontos para ignorar a validacao da regra. Utilizada apenas para possibilitar prosseguir com testes
 *         enquanto o cliente saneia a sua base. Para ativar, colocar uma data maior que TODAY. Para nao usar o recurso, manter uma data menor que TODAY
 */
DEF VAR dt-ignorar-validacao-aux AS DATE INIT 12/31/2018 NO-UNDO.

/*variavel para permitir importar beneficiarios fora de faixa de idade*/
DEFINE VARIABLE lg-valida-idade-aux AS log INITIAL NO NO-UNDO.
/**
 * CAMPOS RESERVA EM USO
 *
 * IMPORT-BNFCIAR.NUM-LIVRE-10: codigo de cliente do beneficiario substituto (PEA)
 *               .NUM-LIVRE-9:  regra-menslid-propost.cdd-regra - estara preenchido quando o beneficiario possui uma regra de mensalidade diferente da sua proposta
 *               .NUM-LIVRE-1:  cdn-lotac - codigo da lotacao a qual o beneficiario pertence. Caso a proposta do Unicoo nao tenha lotacao, ficara zerado.
 *                                          quando for DEMITIDO/APOSENTADO, usara a lotacao default 1. Somente sera preenchido em modalidades JURIDICAS.
 *               .NUM-LIVRE-2:  cdn-respons-financ - codigo do responsavel financeiro pelo contrato (relacionamento com CONTRAT.CD-CONTRATANTE).
 *                              somente sera preenchido quando o beneficiario for DEMITIDO/APOSENTADO. Para qualquer outra situacao, ficara zero. 
 *                              Somente sera preenchido em modalidades JURIDICAS.
 *               .NUM-LIVRE-3:  data de vencimento do contrato DEMITIDO/APOSENTADO
 *               .NUM-LIVRE-4:  numero da familia do beneficiario no UNICOO
 *               .NUM-LIVRE-5:  NRSEQUENCIAL_USUARIO (UNICOO) do dependente que originou o registro de responsavel no plano de remidos (PEA)
 *               .DAT-LIVRE-1:  data de validade da carteira no Unicoo
 *               .DAT-LIVRE-2:  data de inicio do beneficiario no plano de DEMITIDO/APOSENTADO
 *               .DAT-LIVRE-3:  data de desligamento do beneficiario no contrato original quando se referir a DEMITIDO/APOSENTADO
 *               .DAT-LIVRE-4:  data de inicio da contribuicao (para Demitido/Aposentado)
 *               .DAT-LIVRE-5:  data final do contrato de Demitido/Aposentado
 *               .COD-LIVRE-1:  codigo do contrato no Unicoo (USUARIO.CDCONTRATO)
 *               .COD-LIVRE-2:  se tiver o valor 'A' indica que eh um registro de DEMITIDO/APOSENTADO e nao esta sendo usado o conceito de LOTACAO
 *               .COD-LIVRE-3:  carteira do responsavel, preenchido apenas quando o dependente eh gravado em plano separado, devido aos DEPARAS de estrutura
 *               .COD-LIVRE-4:  A-aposentado; D-demitido; N-normal. Usado para criar MOTIV_DEMIS (questionario demitido/aposentado)
 *               .COD-LIVRE-8:  hash MD5 das tabelas do UNICOO lidas para migrar o beneficiario para o TOTVS. usado para controlar atualizacoes
 *
 * IMPORT-MODUL-BNFCIAR.NUM-LIVRE-1: join com import-bnfciar.num-seqcial-control, para associar o modulo ao beneficiario correto.

 */

/** transformar em parametro e preparar os chamadores!*/
DEF VAR lg-gerar-termo-par AS LOG INIT NO NO-UNDO.
lg-gerar-termo-par = YES.

/*    OUTPUT TO c:\temp\teste-cg0310v1.txt APPEND.
    PUT UNFORMATTED "entrando no cg0310v1 com status:" in-status-monitorar-par skip.
    OUTPUT CLOSE.*/

/*DEF STREAM s-rel-erro.
DEF VAR nm-rel-erro-aux AS CHAR INIT "c:\temp\erros_cg0310v1.csv" NO-UNDO.
*/
function get-trace returns char:
  DEF VAR ds-ret-aux AS CHAR NO-UNDO.
  DEF VAR level      AS INT INIT 2 NO-UNDO.
  REPEAT WHILE PROGRAM-NAME(level) <> ?:
         ASSIGN ds-ret-aux = ds-ret-aux + "/" +
                PROGRAM-NAME(level)
                level = level + 1.
  END.
end function.

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
assign c_prg_vrs = "2.00.00.021".

/* LS */
/* DEF VAR c_id_modulo_ls   AS CHAR NO-UNDO.  */
/* DEF VAR c_desc_modulo_ls AS CHAR NO-UNDO.  */
/* FIM LS */

if  v_cod_arq <> '' and v_cod_arq <> ?
then do:
    /*Exemplo de chamada do EMS5
    run pi_version_extract ('api_login':U, 'prgtec/btb/btapi910za.py':U, '1.00.00.008':U, 'pro':U).
    */
    run pi_version_extract ('':U, 'CG0310V1':U, '2.00.00.021':U, '':U).
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
  /*** 010021 ***/



/******************************************************************************
*      Programa .....: CG0310V1.p                                              *
*      Data .........: 22 de Janeiro de 2015                                  *
*      Autor ........: TOTVS                                                  *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Ja¡ne Marin                                            *
*      Objetivo .....: Importacao de Dados dos Beneficiarios                  *
******************************************************************************/
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

DEF VAR char-aux1 AS CHAR NO-UNDO.
DEF VAR char-aux2 AS CHAR NO-UNDO.
DEF VAR char-aux3 AS CHAR NO-UNDO.
DEF VAR char-aux4 AS CHAR NO-UNDO.
 
nm-cab-usuario = "Importacao dos Beneficiarios" .
nm-prog        = "CG/0310V".
c-versao       = "7.15.001".
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
    
 
/* rtp/rtparmo1.i */

/* -------------------- Pesquisa os parametros MO --------------------------- */
def new shared var cd-tipo-medi-aux like parammo.cd-tipo-medi-tp       no-undo.
def new shared var cd-mediocupa-aux like modalid.cd-modalidade         no-undo.
def new shared var cd-admis-aux     like parammo.cd-admissional-tr     no-undo.
def new shared var cd-afast-aux     like parammo.cd-afastado-tr        no-undo.
def new shared var cd-ativo-aux     like parammo.cd-ativo-tr           no-undo.
def new shared var cd-demis-aux     like parammo.cd-demissional-tr     no-undo.
def new shared var cd-desli-aux     like parammo.cd-desligado-tr       no-undo.
def new shared var cd-perio-aux     like parammo.cd-periodico-tr       no-undo.
def new shared var cd-rettr-aux     like parammo.cd-retorno-trabalho-tr no-undo.
def new shared var cd-trofu-aux     like parammo.cd-troca-funcao-tr    no-undo.
def new shared var cd-trose-aux     like parammo.cd-troca-setor-tr     no-undo.
def new shared var cd-manut-aux     like parammo.cd-manutencao-pp      no-undo.
def new shared var cd-proge-aux     like parammo.cd-pronto-geracao-pp  no-undo.
def new shared var cd-proco-aux     like parammo.cd-pronto-copia-pp    no-undo.
def new shared var cd-atipp-aux     like parammo.cd-ativo-pp           no-undo.
def new shared var cd-inati-aux     like parammo.cd-inativo-pp         no-undo.
def new shared var cd-norma-aux     like parammo.cd-normal-pc          no-undo.
def new shared var cd-envco-aux     like parammo.cd-enviadoco-pc       no-undo.
def new shared var cd-envfa-aux     like parammo.cd-enviadofa-pc       no-undo.
def new shared var cd-proce-aux     like parammo.cd-processado-pc      no-undo.
def new shared var nr-perio-aux     like parammo.nr-periodo-cb         no-undo.
def new shared var cd-espec-aux     like parammo.cd-especialid-ep      no-undo.
def new shared var cd-parpr-aux     like parammo.cd-parampron-pa       no-undo.
def new shared var cd-parin-aux     like parammo.cd-paraminsp-pa       no-undo.
def new shared var cd-gerad-aux     like parammo.cd-gerado-pc          no-undo.
def new shared var cd-concl-aux     like parammo.cd-concluido-pc       no-undo.
def new shared var cd-cobra-aux     like parammo.cd-cobrado-pc         no-undo.
def new shared var cd-pagos-aux     like parammo.cd-pago-pc            no-undo.
def new shared var cd-execu-aux     like parammo.cd-executado-pc       no-undo.
def new shared var cd-espam-aux     like parammo.cd-esp-amb-pc         no-undo.
def new shared var cd-gruam-aux     like parammo.cd-grupo-proc-amb-pc  no-undo.
def new shared var cd-proam-aux     like parammo.cd-procedimento-pc    no-undo.
def new shared var cd-dvamb-aux     like parammo.dv-procedimento-pc    no-undo.
def new shared var cd-super-aux     like parammo.cd-supervisor-mg      no-undo.
def new shared var cd-conta-aux     like parammo.cd-transacao-contas   no-undo.
def new shared var cd-extra-aux     like parammo.cd-exame-extra-tr     no-undo.
def new shared var cd-naoex-aux     like parammo.cd-naoexecutou-pc     no-undo.
def new shared var lg-ant-exam-aux  like parammo.lg-antecipa-exames    no-undo.
def new shared var lg-recalc-aux    like parammo.lg-recalcula-periodo  no-undo.

find first parammo no-lock no-error.

if available parammo
then do:
        assign cd-tipo-medi-aux = parammo.cd-tipo-medi-tp
               cd-admis-aux     = parammo.cd-admissional-tr
               cd-afast-aux     = parammo.cd-afastado-tr
               cd-ativo-aux     = parammo.cd-ativo-tr
               cd-demis-aux     = parammo.cd-demissional-tr
               cd-desli-aux     = parammo.cd-desligado-tr
               cd-perio-aux     = parammo.cd-periodico-tr
               cd-rettr-aux     = parammo.cd-retorno-trabalho-tr
               cd-trofu-aux     = parammo.cd-troca-funcao-tr
               cd-trose-aux     = parammo.cd-troca-setor-tr
               cd-manut-aux     = parammo.cd-manutencao-pp
               cd-proge-aux     = parammo.cd-pronto-geracao-pp
               cd-proco-aux     = parammo.cd-pronto-copia-pp
               cd-atipp-aux     = parammo.cd-ativo-pp
               cd-inati-aux     = parammo.cd-inativo-pp
               cd-norma-aux     = parammo.cd-normal-pc
               nr-perio-aux     = parammo.nr-periodo-cb
               cd-espec-aux     = parammo.cd-especialid-ep
               cd-parpr-aux     = parammo.cd-parampron-pa
               cd-parin-aux     = parammo.cd-paraminsp-pa
               cd-gerad-aux     = parammo.cd-gerado-pc
               cd-concl-aux     = parammo.cd-concluido-pc
               cd-cobra-aux     = parammo.cd-cobrado-pc
               cd-pagos-aux     = parammo.cd-pago-pc
               cd-execu-aux     = parammo.cd-executado-pc
               cd-espam-aux     = parammo.cd-esp-amb-pc
               cd-gruam-aux     = parammo.cd-grupo-proc-amb-pc
               cd-proam-aux     = parammo.cd-procedimento-pc
               cd-dvamb-aux     = parammo.dv-procedimento-pc
               cd-envco-aux     = parammo.cd-enviadoco-pc
               cd-envfa-aux     = parammo.cd-enviadofa-pc
               cd-proce-aux     = parammo.cd-processado-pc
               cd-super-aux     = parammo.cd-supervisor-mg
               cd-conta-aux     = parammo.cd-transacao-contas
               cd-extra-aux     = parammo.cd-exame-extra-tr
               cd-naoex-aux     = parammo.cd-naoexecutou-pc
               lg-ant-exam-aux  = parammo.lg-antecipa-exames
               lg-recalc-aux    = parammo.lg-recalcula-periodo.
     end.

 

              
/********************* Definicao Variaveis de Importacao *********************/
def new shared stream s-relat-erro.
 
def new shared var lg-plano-aux          as logical                     no-undo.
def new shared var lg-medocup-aux        as logical                     no-undo.
def new shared var cd-empresa            like  contrat.cd-contratante   no-undo.
def new shared var lg-relat-erro         as logi                        no-undo.
def new shared var lg-relat-erro-aux     as logi initial no             no-undo.
def new shared var nr-proposta-imp-aux   like propost.nr-proposta       no-undo.
def new shared var r-propost             as recid                       no-undo.
def new shared var lg-modulo-erro        as log initial no              no-undo.
def new shared var lg-medocup-erro       as log initial no              no-undo.
def            var lg-repasse-erro       as log                         no-undo.

def var nr-proposta-aux        like usuario.nr-proposta      no-undo.
def var cd-titular-aux         like usuario.cd-titular       no-undo.
def var nr-idade-aux           as int                        no-undo.

/* -------------------- variaveis p/ consistencia ----------------------------*/
def var nr-carte-antiga                 as char format "x(13)"          no-undo.
def var nr-cont-antigo                  as char format "x(15)"          no-undo.
def var ix                              as int     format "99"          no-undo.
def var lg-consist                      as logical initial no           no-undo.
def var lg-consist-aux                  as logical initial no           no-undo.
def var lg-formato-livre-aux            as log                          no-undo.
def var ix-cont-aux                     as int                          no-undo.
DEF VAR cont-aux                        AS INT                          NO-UNDO.
/*def var cd-cpf-aux                      like usuario.cd-cpf             no-undo.*/
/*def var nr-cgc-cpf-aux                  like contrat.nr-cgc-cpf         no-undo.*/
def var lg-inf-cpf-pis-cartaonac-aux    like paravpmc.lg-inf-cpf-pis-cartaonac 
                                                                        no-undo.
def var lg-inf-mae-aux                  like paravpmc.lg-inf-mae        no-undo.       
def var cd-mot-incl-aux                 as char                         no-undo. /* Utilizada na procedure consiste-nr-prod-origem */
def var nr-prod-or-aux                  as int                          no-undo. /* Utilizada na procedure consiste-nr-prod-origem */
def var nm-diretorio-aux                as char                         no-undo.
def var ds-barra                        as char format "x(1)"           no-undo.
def var cd-tam-aux                      as int                          no-undo.  
def var ds-cpo-aux                      as char format "x(1226)"        no-undo.  
def var lg-imp-erro                     as log initial no               no-undo.
DEF VAR qtd-reg-rest                    AS INT                          NO-UNDO.
def var nome-abrev-usu                  as char format "x(40)"          no-undo.
def var nome-abrev2-usu                 as char format "x(40)"          no-undo.
def var nome-usuario-aux                like usuario.nm-usuario         no-undo.
def var nome-usuario2-aux               like usuario.nm-usuario         no-undo.
def var cartao-aux                      like usuario.nm-usuario-cartao  no-undo.
def var nome-cartao-usu                 as char format "x(28)"          no-undo.
def var lg-undo-retry                   as log init no                  no-undo.
def var ds-mensagem-aux                 as char format "x(80)"          no-undo.
def var ds-movto-aux                    as char format "x(14)"          no-undo.
def var lg-critica                      as logi                         no-undo.
def var ds-mascara-aux                  like propost.ds-mascara         no-undo.  
def var nr-digito-aux                   as int                          no-undo.
DEF VAR lg-insc-fat-aux                 as log                          no-undo.
def var dt-fim-aux                      as date                         no-undo. 
def var lg-mensagem                     as log initial no               no-undo.
def var cd-tipo-mens                    as char format "x(01)"          no-undo.                     
def var ds-tipo-mens                    as char format "x(90)"          no-undo.
def var lg-retorna                      as log initial no               no-undo.
def var cd-cidade-aux                   like usuario.cd-cidade          no-undo.
def var lg-erro-reajus1-aux             as log                          no-undo.
def var ds-mensagem-reajus1-aux         as char                         no-undo.
def var nr-ident-compl-aux              as int                          no-undo.
def var cd-tab-preco-aux                as char format "x(5)"           no-undo.
def var nro-seq-aux                     as int initial 0                no-undo.

/*----------- VARIAVEIS PARA SELECTIO-LIST DO IN-SEGMENTO-ASSISTENCIAL ------*/
def            var lista-segmento-posicao-aux    as char                no-undo.
                            
assign lista-segmento-posicao-aux = "01,02,03,04,05,06,07,08,10,11,13,14".

/*---------------------------------------------------------------------------*/
def new shared var lg-registro-modulos         as log init no  format "Sim/Nao"
                                                                       no-undo.
def new shared var lg-registro-repasse         as log init no  format "Sim/Nao"
                                                                       no-undo.
def new shared var  lg-gerar-termo-aux         as log                  no-undo.
def new shared var  lg-carteira-antig-aux      as log                  no-undo.


def var lg-registro-repasse-aux      as log                            no-undo.
def var lg-parametro                 as log initial no                 no-undo.
/*---------------------------------------------------------------------------*/
def            var nr-idade-usuario    as int                           no-undo.
def            var lg-erro-aux         as log                           no-undo.
def            var lg-achou            as log                           no-undo.
def            var nr-faixa-etaria-aux as int                           no-undo.
def            var nr-insc-contrat-ant like propost.nr-insc-contratante no-undo.
def            var cd-modalidade-ant   like modalid.cd-modalidade       no-undo.
def            var nr-proposta-ant     like usuario.nr-proposta         no-undo.
def            var nm-usuario-ant      like usuario.nm-usuario          no-undo.
def            var dt-nascimento-ant   like usuario.dt-nascimento       no-undo.
def            var cd-grau-parent-ant  like usuario.cd-grau-parentesco  no-undo.
def            var dt-excl-plano-ant   like usuario.dt-exclusao-plano   no-undo.
def            var dt-incl-plano-ant   like usuario.dt-inclusao-plano   no-undo.
def            var ct-grava            as int                           no-undo.
DEF            VAR lg-validar-cpf-aux  AS LOG                           NO-UNDO.

/*DEF VAR h-handle-aux AS HANDLE NO-UNDO.
RUN cgp/cg0311v.p PERSISTENT SET h-handle-aux.
*/
DEF VAR h-cg0311v-aux AS HANDLE NO-UNDO.

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
{hdp/hdrunpersis.iv "new"}
{hdp/hdrunpersis.i "cgp/cg0311v.p" "h-cg0311v-aux"}

def new shared var lg-erro                  as logi                     no-undo.

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
/*Sim p/ tela || N’o p/ relatorio*/

def new shared var proposta-rowid                   as rowid                   no-undo.

def new shared var in-tp-rtendere-aux               like parapess.in-tipo-pessoa no-undo.

def new shared var cd-cidade-rtendere-aux           like dzcidade.cd-cidade    no-undo.
def new shared var nm-cidade-rtendere-aux           like dzcidade.nm-cidade    no-undo.


def new shared var en-uf-rtendere-aux               like usuario.en-uf         no-undo.
def new shared var en-cep-rtendere-aux              like usuario.en-cep        no-undo. 
def new shared var en-rua-rtendere-aux              like usuario.en-rua        no-undo.
def new shared var en-bairro-retendere-aux          like usuario.en-bairro     no-undo.

/* ------------------------------------------------------------------------- */


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


def new shared var nm-arquivo-importar  as char format "x(35)"
        label   "Nome do Arquivo a Importar "
        initial "imp/BENEFIC.TXT".

DEF NEW SHARED TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-seq            AS INT
    FIELD nr-seq-contr      LIKE erro-process-import.num-seqcial-control 
    FIELD nom-tab-orig-erro AS CHAR
    FIELD des-erro          AS CHAR
	field des-ajuda         as char
    INDEX nr-seq       
          nr-seq-contr.

DEF NEW SHARED TEMP-TABLE tt-import-bnfciar NO-UNDO
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

/*-------------------------------------------------------------------------*/
def var ds-cabecalho                 as char format "x(30)"             no-undo.
def var ds-rodape                    as char format "x(80)"  init ""    no-undo.
 
def var nm-arquivo-mag               as char format "x(30)"             no-undo.

def buffer b-import-bnfciar for import-bnfciar.
DEF BUFFER b-import-modul-bnfciar FOR import-modul-bnfciar.
DEF BUFFER b-usuario        FOR usuario.
DEF BUFFER b-tt-erro        FOR tt-erro.
 
/*----------------------------------------------------------------------------*/

/**
 * Quando qt-sair-aux tiver valor diferente de zero, processara registros ate
 * atingir esse numero e saira do programa.
 * Usar essa opcao quando o chamador for um laco encadeado com os outros processos
 * de migracao, para dividir o processamento.
 */
DEF            VAR qt-sair-aux      AS INT INIT 0 NO-UNDO.
DEF NEW SHARED VAR qt-cont-sair-aux AS INT INIT 0 NO-UNDO.

def new shared var in-classif       as int  init 1                     no-undo.
def var tb-classif                  as char extent 3 initial
   ["1 - Obriga", "2 - Opcional", "3 - Ambos"]                         no-undo.

def var nm-arquivo-erros     as char format "x(35)"
        label   "Nome do Arquivo de Erros   ".
        
def var nm-arquivo-inconsist  as char format "x(35)"
        label   "Nome Arq. de inconsistencia".
 
form tb-classif[1] format "x(12)"
     tb-classif[2] format "x(12)"
     tb-classif[3] format "x(12)"
     with no-labels 1 column column 38 no-attr row 16 overlay frame f-classif      
     title " Opcao ".

form header
     fill("-", 132) format "x(132)"                           skip
     ds-cabecalho
     "Inconsistencias Importacao do Beneficiario"             at 47
     "Folha:"                                                 at 122
     page-number(s-relat-erro)                                at 128
     format ">>>9" skip
     fill("-", 112) format "x(112)"
     today "-" string(time, "HH:MM:SS")
     skip(1)
     with no-labels stream-io no-box page-top width 132 frame f-cabeca-erro.
 
form tt-erro.nr-seq-contr                      column-label "Nro.Seq.Controle"         
     tt-erro.nom-tab-orig-erro  format "x(30)" column-label "Tab.Origem Erro"
     tt-erro.des-erro           format "x(80)" column-label "Descri‡Æo Erro"           
     with width 132 down no-box attr-space frame f-erro stream-io. 

def rectangle f-consis 
    edge-pixels 3 graphic-edge no-fill size 67 by 3.

form skip(1)
     space(02)
     nm-arquivo-inconsist  view-as fill-in size 36 by 1.3 native
     validate(nm-arquivo-inconsist <> "", "Nao pode ser espacos")
     f-consis at row 1.3 col 1.7
     with three-d row 14 column 8 side-labels attr-space overlay frame f-consist size 69 by 4.
        
def rectangle f-arq-mag
    edge-pixels 3 graphic-edge no-fill size 67 by 3.

form skip(1.3)
     nm-arquivo-erros    view-as fill-in size 36 by 1.3 native label   "   Nome do Arquivo de Erros" at 03
        validate(nm-arquivo-erros <> "", "Nao pode ser espacos")
     f-arq-mag at row 1.45 col 2
     with three-d row 14 column 8 side-labels attr-space overlay frame f-arquivo-mag size 69 by 4.

def rectangle f-param
    edge-pixels 3 graphic-edge no-fill size 35 by 4.5.

form skip(1.3)
     lg-registro-modulos view-as fill-in size 5 by 1.3 native label "Modulos do Beneficiario" at 05    
     lg-registro-repasse view-as fill-in size 5 by 1.3 native label "Repasse do Beneficiario" at 04.8     
     f-param at row 1.3 col 1.7
     with three-d row 14 column 8 side-labels overlay frame f-parametro size 37 by 6.5
     title " Parametros da Importacao ".

form header ds-rodape format "x(132)"
     with no-labels stream-io no-box width 132 page-bottom frame f-rodape. 

/*----------------------------------------------------------------------------*/
find first paramecp no-lock no-error.
if   available paramecp
then do:
       find unimed where unimed.cd-unimed = paramecp.cd-unimed
            no-lock no-error.
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

IF can-find(first param-movimen-bnfciar
            WHERE param-movimen-bnfciar.log-cpf-invldo = NO)
THEN ASSIGN lg-validar-cpf-aux = YES.
ELSE ASSIGN lg-validar-cpf-aux = NO.


/* ---------------------------------------------------------------------------------------- */
run rtp/rtspool.p(input-output nm-diretorio-aux).

assign ds-barra = substring(nm-diretorio-aux,(length(nm-diretorio-aux)),1).

if    ds-barra <> "/"
then  nm-diretorio-aux = nm-diretorio-aux + "/".

assign nm-arquivo-erros     = nm-diretorio-aux + "ERROS-B.LST" 
       nm-arquivo-inconsist = nm-diretorio-aux + "inconsist.lst".
 
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
                          label "     Nome arquivo"  initial "BENEFIC"     no-undo.
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

if in-batch-online-par = "online"
then do:
       on help, end-error of browse-disp-tela in frame f-disp-tela
       do:
         return no-apply.
       end.
       
       on go of browse-disp-tela in frame f-disp-tela
       do:
         close query zoom-tela.
         hide frame f-disp-tela.
       end.
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
 
 
assign ds-rodape  = " " + replace(nm-prog,"/","") + " - " + c-versao
       ds-rodape  = FILL("-", 132 - LENGTH(ds-rodape)) + ds-rodape
 
       nm-arquivo-mag = "imp/BENEFIC.TXT".
 
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

IF in-batch-online-par = "BATCH"
THEN DO:
       assign ct-grava            = 0
              lg-erro             = no
              lg-plano-aux        = lg-plano-par
              lg-medocup-aux      = lg-medocup-par
              lg-registro-modulos = lg-registro-modulos-par
              lg-registro-repasse = lg-registro-repasse-par
              in-classif          = in-classif-par
              qt-sair-aux         = qt-sair-par
              lg-gerar-termo-aux  = lg-gerar-termo-par
              lg-carteira-antig-aux = if in-carteira-antig-par = "S" then yes else no.

       run importa-dados.
     END.
ELSE DO:
        repeat on endkey undo,retry on error undo, retry with frame f-arquivo-mag:
         
          hide frame f-saida        no-pause.
          hide frame f-nome         no-pause.
          hide frame f-nome-imp     no-pause.
          hide frame f-layout       no-pause.
          hide frame f-arquivo-mag  no-pause.
          hide frame f-consist      no-pause.
          hide frame f-parametro    no-pause.
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
                     
                     assign c-opcao      = "Parametro"
                            lg-parametro = no.
                                  
                     update lg-registro-modulos with frame f-parametro.   
             
                     if   lg-registro-modulos = yes
                     then do on error undo, retry on endkey undo, leave:
                             
                             display tb-classif with frame f-classif.
                             choose field tb-classif auto-return with frame f-classif.
                             in-classif = frame-index.
                          end.
                     
                     hide frame f-classif no-pause.
               
                     update lg-registro-repasse with frame f-parametro.
               
                     assign lg-parametro = yes.
                     hide frame f-parametro no-pause.
                  end.
        
             when "Importa"
             then do on error undo, retry on endkey undo, leave:
        
                     if   not lg-parametro
                     then do:
                            message "Nenhum Parametro Selecionado."
                            view-as alert-box title " Atencao !!! ".
                            undo, retry.
                          end.
        
                     update nm-arquivo-erros with frame f-arquivo-mag.
                     
                     message " Importando Dados, Aguarde...".
            
                     output stream s-relat-erro to value(nm-arquivo-erros) page-size 64.
        
                     HIDE FRAME f-arquivo-mag.
                   
                     view stream s-relat-erro frame f-cabeca-erro.
                     view stream s-relat-erro frame f-rodape.
            
                     assign ct-grava                = 0
                            lg-erro                 = no
                            lg-plano-aux            = no
                            lg-medocup-aux          = NO
                            lg-gerar-termo-aux      = lg-gerar-termo-par
                            lg-carteira-antig-aux = if in-carteira-antig-par = "S" then yes else no.
        
                     run importa-dados.
        
                     put stream s-relat-erro
                          skip(05)
                          " Nome do Arquivo       : "  at 40  nm-arquivo-importar  skip(01).
        
                     output stream s-relat-erro close.
        
                     HIDE FRAME f-contador.
        
                     if lg-imp-erro
                     then message "Ocorreram Erro(s)." skip
                                  "Verifique Relatorio de Erros "
                                  view-as alert-box title "Atencao !!!".
                     else message "Importacao concluida com sucesso!"
                                  view-as alert-box title "Atencao !!!".
                          
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

/*DELETE PROCEDURE h-handle-aux.*/
/* ------------------------------------------------- RETIRA A API DA PERSISTENCIA --- */
{hdp/hddelpersis.i}


/* ------------------------------------------------------------------------- */
procedure importa-dados:

    ASSIGN qtd-reg-rest = 1000.

    /*REPEAT:*/
        PROCESS EVENTS.

        IF NOT CAN-FIND (FIRST import-bnfciar WHERE import-bnfciar.ind-sit-import = in-status-monitorar-par)
        THEN LEAVE. 

        RUN escrever-log("@@@@@dentro de importa-dados").
    
        ASSIGN cont-aux = 0.

        case in-status-benef-par:

            /* --- ATIVOS E INATIVOS ------------------------------------------------------ */
            when 'A' 
            then do:
                   IF CAN-FIND (FIRST import-bnfciar 
                                WHERE import-bnfciar.ind-sit-import = in-status-monitorar-par
                                  AND import-bnfciar.log-respons)   
                   THEN 
                        FOR EACH import-bnfciar
                           WHERE import-bnfciar.ind-sit-import = in-status-monitorar-par NO-LOCK USE-INDEX imprtbnf_ix2 /*EXCLUSIVE-LOCK*/ /*,*/
                           /*FIRST import-propost NO-LOCK  /*USE-INDEX imprtprp_id3 */
                           WHERE import-propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo */
                                 BREAK BY import-bnfciar.log-respons DESC
                                       BY import-bnfciar.cd-grau-parentesco:

                            message "Imp. Benef.Resp. Sit: " in-status-monitorar-par " " import-bnfciar.num-seqcial-control.
                            pause 0.
                        
                            RUN consiste-dados.
                        
                            IF  cont-aux = qtd-reg-rest
                            THEN LEAVE.
                        END.
                   ELSE 
                        FOR EACH import-bnfciar
                           WHERE import-bnfciar.ind-sit-import = in-status-monitorar-par NO-LOCK USE-INDEX imprtbnf_ix2 /*EXCLUSIVE-LOCK*/ /*,*/
                           /*FIRST import-propost NO-LOCK
                           WHERE import-propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo*/ :
                        
                            message "Imp. Benef.Dep. Sit: " in-status-monitorar-par " " import-bnfciar.num-seqcial-control.
                            pause 0.

                            RUN consiste-dados.
                        
                            IF  cont-aux = qtd-reg-rest
                            THEN LEAVE.
                        END.
                 end.
            /* --- ATIVOS ----------------------------------------------------------------- */
            when 'AT' 
            then do:
                   IF CAN-FIND (FIRST import-bnfciar 
                                WHERE import-bnfciar.ind-sit-import = in-status-monitorar-par
                                  AND import-bnfciar.log-respons
                                  AND import-bnfciar.dt-exclusao-plano = ?)   
                   THEN 
                        FOR EACH import-bnfciar
                           WHERE import-bnfciar.ind-sit-import    = in-status-monitorar-par
                             AND import-bnfciar.dt-exclusao-plano = ? NO-LOCK USE-INDEX imprtbnf_ix2 /*EXCLUSIVE-LOCK*/ /*,*/
                           /*FIRST import-propost NO-LOCK
                           WHERE import-propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo*/
                                 BREAK BY import-bnfciar.log-respons DESC
                                       BY import-bnfciar.cd-grau-parentesco:
                        
                            message "Imp. Benef.Resp.ATIVOS Sit: " in-status-monitorar-par " " import-bnfciar.num-seqcial-control.
                            pause 0.

                            RUN consiste-dados.
                        
                            IF  cont-aux = qtd-reg-rest
                            THEN LEAVE.
                        END.
                   ELSE 
                        FOR EACH import-bnfciar
                           WHERE import-bnfciar.ind-sit-import    = in-status-monitorar-par
                             AND import-bnfciar.dt-exclusao-plano = ? NO-LOCK USE-INDEX imprtbnf_ix2 /*EXCLUSIVE-LOCK*/ /*,*/
                           /*FIRST import-propost NO-LOCK
                           WHERE import-propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo*/ :
                        
                            message "Imp. Benef.Dep.ATIVOS Sit: " in-status-monitorar-par " " import-bnfciar.num-seqcial-control.
                            pause 0.

                            RUN consiste-dados.
                        
                            IF  cont-aux = qtd-reg-rest
                            THEN LEAVE.
                        END.   
                 end.
            /* --- INATIVOS --------------------------------------------------------------- */
            when 'I' 
            then do:
                   IF CAN-FIND (FIRST import-bnfciar 
                                WHERE import-bnfciar.ind-sit-import = in-status-monitorar-par
                                  AND import-bnfciar.log-respons
                                  AND import-bnfciar.dt-exclusao-plano <> ?)   
                   THEN 
                        FOR EACH import-bnfciar
                           WHERE import-bnfciar.ind-sit-import    = in-status-monitorar-par
                             AND import-bnfciar.dt-exclusao-plano <> ? NO-LOCK USE-INDEX imprtbnf_ix2 /*EXCLUSIVE-LOCK*/ /*,*/
                           /*FIRST import-propost NO-LOCK
                           WHERE import-propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo*/
                                 BREAK BY import-bnfciar.log-respons DESC
                                       BY import-bnfciar.cd-grau-parentesco:
                        
                            message "Imp. Benef.Resp.INATIVOS Sit: " in-status-monitorar-par " " import-bnfciar.num-seqcial-control.
                            pause 0.

                            RUN consiste-dados.
                        
                            IF  cont-aux = qtd-reg-rest
                            THEN LEAVE.
                        END.
                   ELSE 
                        FOR EACH import-bnfciar
                           WHERE import-bnfciar.ind-sit-import    = in-status-monitorar-par
                             AND import-bnfciar.dt-exclusao-plano <> ? NO-LOCK USE-INDEX imprtbnf_ix2 /*EXCLUSIVE-LOCK*/ /*,*/
                           /*FIRST import-propost NO-LOCK
                           WHERE import-propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo*/ :
                        
                            message "Imp. Benef.Dep.INATIVOS Sit: " in-status-monitorar-par " " import-bnfciar.num-seqcial-control.
                            pause 0.

                            RUN consiste-dados.
                        
                            IF  cont-aux = qtd-reg-rest
                            THEN LEAVE.
                        END.   
                 end.
        end case.

        /* cria registros */
        run cria-registros IN h-cg0311v-aux ASYNCHRONOUS.

        IF in-batch-online-par = "ONLINE"
        then run mostra-erro.
        run pi-grava-erro.
        
        IF  qt-sair-aux <> 0
        AND qt-cont-sair-aux >= qt-sair-aux
        THEN LEAVE.
    /*END.    */
    
end procedure.

PROCEDURE consiste-dados:

    assign lg-registro-repasse-aux = no
           lg-relat-erro-aux       = no
           lg-formato-livre-aux    = yes.

    assign lg-imp-erro     = no
           lg-plano-aux    = NO
           lg-relat-erro   = no
           lg-repasse-erro = no.
    
    FIND FIRST modalid WHERE modalid.cd-modalidade = int(import-bnfciar.cd-modalidade) NO-LOCK NO-ERROR.
    
    if   avail modalid
    THEN DO:
           IF modalid.cd-tipo-medicina = paramecp.cd-mediocupa
           THEN assign lg-medocup-aux = NO.
           ELSE assign lg-medocup-aux = YES.
         END.
    ELSE DO:
           RUN pi-cria-tt-erros("Modalidade Invalida").
           assign lg-relat-erro = yes.
         END.
    
    FOR FIRST propost USE-INDEX propo24
        WHERE propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo NO-LOCK:
    END.
    
    if   not avail propost
    then do:
           ASSIGN lg-relat-erro = YES.
           run pi-cria-tt-erros("Proposta nao cadastrada. Contr. Antigo: " + 
                                if import-bnfciar.nr-contrato-antigo <> ?
                                then string(import-bnfciar.nr-contrato-antigo)
                                else "0").
         end.
    
    ELSE do:
           IF NOT CAN-FIND (FIRST contrat where contrat.nr-insc-contratante = propost.nr-insc-contratante)
           THEN DO:
                  ASSIGN lg-relat-erro = YES.
                  run pi-cria-tt-erros("Contratante nao cadastrado. Inscricao: " + 
                                       if propost.nr-insc-contratante <> ?
                                       then string(propost.nr-insc-contratante)
                                       else "0").
                end.
    
           find ti-pl-sa where ti-pl-sa.cd-modalidade = propost.cd-modalidade
                           and ti-pl-sa.cd-plano      = propost.cd-plano
                           and ti-pl-sa.cd-tipo-plano = propost.cd-tipo-plano
                               no-lock no-error.
           
           if   not avail ti-pl-sa 
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Tipo de Plano nao cadastrado. Mod. " + string(propost.cd-modalidade) +
                                       " Pl. "    + string(propost.cd-plano)     +
                                       " Tp.Pl. " + string(propost.cd-tipo-plano)).
                end.

           /**
            * Se NUM_LIVRE_6 estiver preenchido e ja existir usuario com esse CD_USUARIO, apresentar erro.
            */
           IF  import-bnfciar.num-livre-6 <> ?
           AND import-bnfciar.num-livre-6 <> 0
           AND CAN-FIND(FIRST usuario
                        WHERE usuario.cd-modalidade = import-bnfciar.cd-modalidade
                          AND usuario.nr-proposta   = import-bnfciar.nr-proposta
                          AND usuario.cd-usuario    = import-bnfciar.num-livre-6)
           then do:
                   assign lg-relat-erro = yes.
                   RUN pi-cria-tt-erros2("Ja existe USUARIO com esse codigo.",
                                         "Modalidade: " + string(import-bnfciar.cd-modalidade) +
                                        " Proposta: "    + string(import-bnfciar.nr-proposta)     +
                                        " cd-usuario: "  + string(import-bnfciar.num-livre-6)).
           end.

           /**
            * Tratamento do REGISTRO PLANO ANS 
            */
           if propost.in-registro-plano = 2 /* registro ANS no beneficiario */
           then do:
                  if  (import-bnfciar.cd-registro-plano  = 0  or import-bnfciar.cd-registro-plano  = ?)
                  and (import-bnfciar.cd-plano-operadora = "" or import-bnfciar.cd-plano-operadora = ?)
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros ("Codigo do Registro de Plano Regulamentado ou Nao Regulamentado\Adaptado deve ser informado"). 
                       end.
                  
                  if  (import-bnfciar.cd-registro-plano  <> 0  and import-bnfciar.cd-registro-plano  <> ?)
                  and (import-bnfciar.cd-plano-operadora <> "" and import-bnfciar.cd-plano-operadora <> ?)
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros ("Codigo do Registro de Plano Regulamentado e Codigo do Registro de Plano Nao Regulamentado\Adaptado informados. Informar apenas um."). 
                       end.
                  else do:
                         /* plano eh regulamentado */
                         if  import-bnfciar.cd-registro-plano <> 0
                         and import-bnfciar.cd-registro-plano <> ?
                         then do:
                                /*for first reg-plano-saude fields(cdn-plano-ans idi-registro)
                                    where reg-plano-saude.cdn-plano-ans = import-bnfciar.cd-registro-plano 
                                          no-lock query-tuning(no-index-hint): 
                                end.
                                if not avail reg-plano-saude */
                                
                                if NOT CAN-FIND(FIRST reg-plano-saude
                                                WHERE reg-plano-saude.cdn-plano-ans = import-bnfciar.cd-registro-plano)
                                then do:
                                       if import-bnfciar.cd-registro-plano <> ?
                                       then char-aux1 = string(import-bnfciar.cd-registro-plano).
                                       else char-aux1 = "nulo".
                         
                                       assign lg-relat-erro = yes.
                                       run pi-cria-tt-erros ("Registro Plano Regulamentado nao encontrado.  Cod. Reg.: " + char-aux1). 
                                     end.
                              end.
                         else do:
                                /* plano eh nao regulamentado ou adaptado */
                                for first import-propost fields (num-livre-8)
                                    where import-propost.nr-contrato-antigo = propost.nr-contrato-antigo USE-INDEX imprtprp_id3
                                          no-lock /*query-tuning (no-index-hint)*/:
                                end.
                         
                                /*for first reg-plano-saude fields(cod-plano-operadora idi-registro)
                                    where reg-plano-saude.cod-plano-operadora    = import-bnfciar.cd-plano-operadora 
                                      and reg-plano-saude.in-tipo-regulamentacao = import-propost.num-livre-8
                                          no-lock query-tuning (no-index-hint): 
                                end.
                                if not avail reg-plano-saude*/
                                
                                IF NOT CAN-FIND(FIRST reg-plano-saude
                                                WHERE reg-plano-saude.cod-plano-operadora    = import-bnfciar.cd-plano-operadora
                                                  AND reg-plano-saude.in-tipo-regulamentacao = import-propost.num-livre-8)
                                then do:
                                       if import-bnfciar.cd-plano-operadora <> ?
                                       then char-aux1 = string(import-bnfciar.cd-plano-operadora).
                                       else char-aux1 = "nulo".
                         
                                       assign lg-relat-erro = yes.
                                       run pi-cria-tt-erros("Registro Plano Nao-Regulamentado nao encontrado. Cod. Reg.: " + char-aux1 + " - Tipo Reg.: " + string(import-propost.num-livre-8)).
                                     end.
                              end.
                       end.
                end.
         end.
           
    IF lg-gerar-termo-aux
    AND AVAIL propost
    THEN DO:
           FOR FIRST ter-ade
               WHERE ter-ade.cd-modalidade = propost.cd-modalidade
                 AND ter-ade.nr-ter-adesao = propost.nr-ter-adesao NO-LOCK:
           END.
           if   not avail ter-ade
           then do:
                  ASSIGN lg-relat-erro = YES.
                  run pi-cria-tt-erros("Termo nao cadastrado. Modalidade: " + STRING(propost.cd-modalidade) + 
                                       " Termo: " + STRING(propost.nr-ter-adesao)).
                end.
         END.

    IF  import-bnfciar.cd-carteira-origem-responsavel <> import-bnfciar.cd-carteira-antiga
    AND import-bnfciar.log-respons = NO
    AND NOT CAN-FIND (first usuario where usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-origem-responsavel)
    THEN do:
           FOR FIRST b-import-bnfciar FIELDS (num-seqcial-control)
               where b-import-bnfciar.cd-carteira-antiga = import-bnfciar.cd-carteira-origem-responsavel NO-LOCK:
           END.
    
           IF AVAIL b-import-bnfciar
           THEN run pi-cria-tt-erros2("Respons. deste beneficiario nao foi importado. Se estiver como IT em IMPORT_BNFCIAR, verifique se realmente existe na tabela USUARIO.",
		                              "Num. seqcial controle do benef. resp.:" + string(b-import-bnfciar.num-seqcial-control)).
           ELSE run pi-cria-tt-erros2("Nao encontrado registro na tabela import-bnfciar correspondente ao benef. responsavel.",
		                              "Carteira do resp. informada: " + string(import-bnfciar.cd-carteira-origem-responsavel)).
    
           ASSIGN lg-relat-erro = YES.
         END.
    
    IF lg-relat-erro 
    THEN DO:
           IF in-batch-online-par = "ONLINE"
           then run mostra-erro.
          
           run pi-grava-erro.
           
           assign lg-imp-erro = yes.
    
           RETURN.
         END.
    
    /* --- CONSISTE DADOS -------------------------------------------------------------------- */
    
    /* --- CONSISTE DADOS USUARIO -------------- */
    ASSIGN lg-relat-erro = NO.
    RUN consiste-dados-benef.
    
    IF lg-relat-erro
    THEN ASSIGN lg-relat-erro-aux = YES.
    
    /* --- CONSISTE MODULOS USUARIO ------------ */
    if lg-registro-modulos
    THEN DO:
           ASSIGN lg-relat-erro = NO.
           RUN consiste-modulos-benef.
           
           IF lg-relat-erro
           THEN ASSIGN lg-relat-erro-aux = YES.
         END.
    
    /* --- CONSISTE REPASSE USUARIO ------------ */
    if lg-registro-repasse
    then do:
           ASSIGN lg-relat-erro = NO.
           RUN consiste-repasse-benef.
          
           IF lg-relat-erro
           THEN ASSIGN lg-relat-erro-aux = YES.
         END.        
    
    /* --- CONSISTE REPASSE ATEND. USUARIO ----- */
    IF  lg-registro-repasse
    AND lg-registro-repasse-aux = YES
    THEN DO:
           ASSIGN lg-relat-erro = NO.
           RUN consiste-repas-atend.
           
           IF lg-relat-erro
           THEN ASSIGN lg-relat-erro-aux = YES.
         END.
    
    /* --- CONSISTE PAD. COB. USUARIO ---------- */
    ASSIGN lg-relat-erro = NO.
    RUN consiste-padrao-benef.
    
    IF lg-relat-erro
    THEN ASSIGN lg-relat-erro-aux = YES.
    
    /*IF lg-plano-aux = NO
    THEN DO:
           RUN pi-cria-tt-erros("Nenhum modulo foi escolhido para o beneficiario").
           ASSIGN lg-relat-erro-aux = YES.     
         END.*/
    
    /* --------------------------------------------------------------------------------------- */
    ASSIGN cont-aux = cont-aux + 1.
    
    if lg-relat-erro-aux
    then DO:
           IF in-batch-online-par = "ONLINE"
           then run mostra-erro.
           run pi-grava-erro.
           
           assign lg-imp-erro = yes. 
         END.
    ELSE DO:
           CREATE tt-import-bnfciar.
           ASSIGN tt-import-bnfciar.rowid-import-bnfciar = rowid(import-bnfciar)
                  tt-import-bnfciar.nome-usuario         = nome-usuario-aux        
                  tt-import-bnfciar.nome-abrev-usu       = nome-abrev-usu     
                  tt-import-bnfciar.nome-usuario-aux     = nome-usuario-aux   
                  tt-import-bnfciar.cartao-aux           = cartao-aux         
                  tt-import-bnfciar.nome-cartao-usu      = nome-cartao-usu
                  tt-import-bnfciar.lg-insc-fat          = lg-insc-fat-aux
                  tt-import-bnfciar.cd-cidade            = cd-cidade-aux
                  tt-import-bnfciar.nr-idade-usuario     = nr-idade-usuario
                  tt-import-bnfciar.nr-faixa-etaria      = nr-faixa-etaria-aux.
         END.

END PROCEDURE.


/* ------------------------------------------------------------------------------------- */     
/* ------------------------------------------------------------------------- */
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

/* ------------------------------------------------------------------------------------------- */
PROCEDURE pi-cria-tt-erros:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.
    
    DEF VAR num-seq-aux AS INT NO-UNDO.

    FOR LAST b-tt-erro FIELDS (nr-seq) 
       WHERE b-tt-erro.nr-seq-contr = import-bnfciar.num-seqcial-control NO-LOCK:
    END.

    CREATE tt-erro.

    IF AVAIL b-tt-erro
    THEN ASSIGN num-seq-aux = b-tt-erro.nr-seq + 1.
    ELSE ASSIGN num-seq-aux = 1.

    ASSIGN tt-erro.nr-seq            = num-seq-aux
           tt-erro.nr-seq-contr      = import-bnfciar.num-seqcial-control
           tt-erro.nom-tab-orig-erro = "BE - import-bnfciar"
           tt-erro.des-erro          = ds-erro-par. 

END PROCEDURE.

PROCEDURE pi-cria-tt-erros2:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.
    DEF INPUT PARAM ds-ajuda-par AS CHAR NO-UNDO.
    
    DEF VAR num-seq-aux AS INT NO-UNDO.

    FOR LAST b-tt-erro FIELDS (nr-seq) 
       WHERE b-tt-erro.nr-seq-contr = import-bnfciar.num-seqcial-control NO-LOCK:
    END.

    CREATE tt-erro.

    IF AVAIL b-tt-erro
    THEN ASSIGN num-seq-aux = b-tt-erro.nr-seq + 1.
    ELSE ASSIGN num-seq-aux = 1.

    ASSIGN tt-erro.nr-seq            = num-seq-aux
           tt-erro.nr-seq-contr      = import-bnfciar.num-seqcial-control
           tt-erro.nom-tab-orig-erro = "BE - import-bnfciar"
           tt-erro.des-erro          = ds-erro-par
		   tt-erro.des-ajuda         = ds-ajuda-par.

END PROCEDURE.

procedure pi-grava-erro:

    ASSIGN nro-seq-aux = 0.

    FOR EACH tt-erro FIELDS(nr-seq-contr nom-tab-orig-erro des-erro des-ajuda) EXCLUSIVE-LOCK
        BREAK BY tt-erro.nr-seq-contr:

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
			   erro-process-import.des-ajuda           = tt-erro.des-ajuda
               erro-process-import.dat-erro            = today. 

        FOR FIRST control-migrac FIELDS (ind-sit-import)
            WHERE control-migrac.num-seqcial = tt-erro.nr-seq-contr EXCLUSIVE-LOCK:
        END.
        if avail control-migrac
        then assign control-migrac.ind-sit-import = "PE".

        FOR FIRST b-import-bnfciar FIELDS (ind-sit-import) 
            WHERE b-import-bnfciar.num-seqcial-control = erro-process-import.num-seqcial-control EXCLUSIVE-LOCK:
        END.
        IF AVAIL b-import-bnfciar
        THEN DO:        
               ASSIGN b-import-bnfciar.ind-sit-import = "PE".

               RELEASE  b-import-bnfciar.
               VALIDATE b-import-bnfciar.
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
    then assign nro-seq-par = 1.
    else assign nro-seq-par = nro-seq-par + 1.

end procedure.

PROCEDURE consiste-dados-benef:
    
    if (import-bnfciar.in-via-transferencia = "B" 
    or  import-bnfciar.in-via-transferencia = "D")
    and import-bnfciar.cdn-produt-orig = 0
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Nr.Produto Operadora Origem nao informado").
         end.

    /* ---------------- Nr INSCRICAO CONTRATANTE ---------------------*/  
    if   int(import-bnfciar.nr-insc-contratante) <> 0
    AND  NOT CAN-FIND (FIRST contrat where contrat.nr-insc-contratante = int(import-bnfciar.nr-insc-contratante))
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Inscricao do Contratante Invalida").
         end.

    /* ------------------ CONTRATO ANTIGO -----------------------*/
    if import-bnfciar.nr-contrato-antigo = ""
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Contrato Antigo Invalido").
         end.
 
    if   propost.cd-modalidade <> import-bnfciar.cd-modalidade     
    then do:
           assign lg-relat-erro = yes.       
           RUN pi-cria-tt-erros("Modalidade Contrato Antigo nao confere. Modalide Proposta: " + STRING(propost.cd-modalidade) +
                                "Modalidade tab. Importacao: " + STRING(import-bnfciar.cd-modalidade)).
         end.
 
    /* --------------------- PROPOSTA  ----------------------------*/
    assign nr-proposta-imp-aux = propost.nr-proposta
           nr-proposta-aux     = propost.nr-proposta
           r-propost           = recid(propost).

    if  int(import-bnfciar.nr-proposta) <> 0
    AND propost.nr-proposta <> import-bnfciar.nr-proposta 
    then do:
           ASSIGN lg-relat-erro = yes.       
           RUN pi-cria-tt-erros("Proposta/Contrato Antigo nao confere. Mod: " + STRING(propost.cd-modalidade) +
                                " Proposta: " + STRING(propost.nr-proposta) +
                                " import-bnfciar.nr-proposta: " + STRING(import-bnfciar.nr-proposta) + 
                                " nr-contrato-antigo: " + STRING(import-bnfciar.nr-contrato-antigo)
                                ).
         end.
    
    if propost.cd-tipo-proposta <> 9
    then do: 
           assign lg-relat-erro = yes.       
           RUN pi-cria-tt-erros("Tipo de Proposta nao e migracao").
         end.
    
    /*assign cd-cpf-aux = import-bnfciar.cd-cpf.*/

    /*------------ NOME DO BENEFICIARIO ---------------*/
    run rtp/rtcarint.p ( input 0,
                         input import-bnfciar.nom-usuar,
                         input no,
                         output nome-usuario-aux,
                         output nome-abrev-usu,
                         output cartao-aux,
                         output lg-undo-retry,
                         output ds-mensagem-aux).
    if   lg-undo-retry
    then do:
           /**
            * Se ocorreu erro de nome cartao maior que 25 posicoes, chamar a rotina novamente com funcao 2,
            * para gerar somente esse campo sem apresentar erro.
            */
           IF ds-mensagem-aux = "Nome apos abreviatura continua com mais de 25 posicoes" 
           THEN DO:
                  run rtp/rtcarint.p ( input 2,
                                       input import-bnfciar.nom-usuar,
                                       input no,
                                       output nome-usuario2-aux,
                                       output nome-abrev2-usu,
                                       output cartao-aux,
                                       output lg-undo-retry,
                                       output ds-mensagem-aux).
                  IF lg-undo-retry
                  THEN DO:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros(ds-mensagem-aux).
                       END.
                END.
           ELSE DO:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros(ds-mensagem-aux).
                END.
         end.

    IF lg-validar-cpf-aux
    THEN DO:
           run rtp/rtcgccpf.p (input  import-bnfciar.in-tipo-pessoa,
                               input  import-bnfciar.cd-cpf,
                               input  no,
                               output ds-mensagem-aux,
                               output lg-erro-aux).
           
           if   lg-erro-aux
           then do:
                  ASSIGN lg-relat-erro = yes.
                  RUN pi-cria-tt-erros(ds-mensagem-aux).
                end.
         END.

    /* ----------------- CAMPOS ESPECIFICOS ---------- */
    run consiste-campos-espec.

   
    /* ----------------------- Carteira Antiga ----------------------*/  
    if import-bnfciar.cd-carteira-antiga = 0
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Codigo da Carteira antiga deve ser informado").
         end.
 
    IF CAN-FIND (FIRST b-usuario USE-INDEX usuari26
                 WHERE b-usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-antiga)
    then do:           
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Beneficiario ja cadastrado com esta carteira antiga").
         end.

    /* ------------------------------------------------------------------- */      
    if  (int(import-bnfciar.in-est-civil) >= 1  
    and  int(import-bnfciar.in-est-civil) <= 5)
     or  int(import-bnfciar.in-est-civil)  = 9
    then.
    else do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Estado Civil Invalido").
         end.

    /* --------------------------- CBO ------------------------------------- */
    if  import-bnfciar.cd-cbo = 0
    and  not lg-medocup-aux 
    then do:
           assign lg-relat-erro = yes.                                  
           RUN pi-cria-tt-erros("CBO deve ser informado para Modalidade de Medicina Ocupacional").
         end.

    if import-bnfciar.cd-cbo <> 0
    AND NOT CAN-FIND (FIRST dz-cbo02 where dz-cbo02.cd-cbo = import-bnfciar.cd-cbo)
    then do:
           assign lg-relat-erro = yes.                                                  
           RUN pi-cria-tt-erros("CBO nao cadastrado").
         end.

    /*------------------------------------------------------------------------*/
    /*----------------- VERIFICA SE CBO POSSUI PROCEDIMENTOS -----------------*/ 
    /*------------------------------------------------------------------------*/
    if modalid.cd-tipo-medicina = cd-tipo-medi-aux
    AND NOT CAN-FIND (first cboproce use-index cboproc2
                      where cboproce.cd-cbo       = import-bnfciar.cd-cbo
                        and cboproce.cd-transacao = cd-perio-aux)
    then do:
           IF NOT CAN-FIND (first fundepri 
                            where fundepri.cd-modalidade   = import-bnfciar.cd-modalidade
                              and fundepri.nr-proposta     = propost.nr-proposta
                              and fundepri.cd-departamento = import-bnfciar.cd-departamento
                              and fundepri.cd-secao        = import-bnfciar.cd-secao
                              and fundepri.cd-setor        = import-bnfciar.cd-setor
                              and fundepri.cd-cbo          = import-bnfciar.cd-cbo)
           THEN 
           IF NOT CAN-FIND (first fundepri 
                            where fundepri.cd-modalidade   = import-bnfciar.cd-modalidade
                              and fundepri.nr-proposta     = propost.nr-proposta
                              and fundepri.cd-departamento = import-bnfciar.cd-departamento
                              and fundepri.cd-secao        = import-bnfciar.cd-secao
                              and fundepri.cd-setor        = import-bnfciar.cd-setor
                              and fundepri.cd-cbo          = 0)
           
           then do:
                  assign lg-relat-erro = yes.                      
                  RUN pi-cria-tt-erros("CBO nao possui exames cadastrados - " +  
                                       if import-bnfciar.cd-cbo <> ?
                                       then string(import-bnfciar.cd-cbo,"99999999")
                                       else "00000000").
                end.                                              
         end.  
    
    /* ------------------------------------------------------------------- */
    if   import-bnfciar.dt-exclusao-plano = ?
    THEN DO:
           IF propost.dt-libera-doc <> ?
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Beneficiario Ativo nao sera incluido em proposta cancelada").
               end.

           /* ------------- TRATAMENTO MOTIVO DO CANCELAMENTO DO BENEFICIARIO --- */
           /* ------- BENEFICIARIO ATIVO COM MOTIVO DE CANCELAMENTO INFORMADO --- */
           if import-bnfciar.cd-motivo-cancel <> 0
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Beneficiario Ativo com motivo de cancelamento").
                end.
         END.
    ELSE /* -------- BENEFICIARIO CANCELADO COM MOTIVO DE CANCELAMENTO ZERO --- */
         if import-bnfciar.cd-motivo-cancel  = 0
         then do:
                assign lg-relat-erro = yes.
                RUN pi-cria-tt-erros("Beneficiario cancelado com motivo de cancelamento zero").
              end.
 
    /* ------------------------------ CONSISTENCIA MOTIVO CANCELAMENTO --- */
    if   import-bnfciar.cd-motivo-cancel <> 0
    AND  import-bnfciar.cd-motivo-cancel <> ?
    AND NOT CAN-FIND (FIRST motcange 
                      where motcange.in-entidade = "MC"
                        and motcange.cd-motivo   = import-bnfciar.cd-motivo-cancel)
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Motivo do cancelamento nao cadastrado: " + STRING(import-bnfciar.cd-motivo-cancel)).
         end.

    /* ------------------------------------------------------------------- */
    run rtp/rtidade.p (input  import-bnfciar.dt-nascimento,
                       input  today,
                       output nr-idade-usuario,
                       output lg-erro-aux ).
    IF lg-valida-idade-aux
    AND NOT propost.lg-pea
    THEN DO:
            IF  modalid.lg-usa-faixa-etaria
            AND propost.lg-faixa-etaria-esp = yes
            then do:
                   if  can-find(first teadgrpa where teadgrpa.cd-modalidade      = import-bnfciar.cd-modalidade            
                                                 and teadgrpa.nr-proposta        = propost.nr-proposta 
                                                 and teadgrpa.cd-grau-parentesco = import-bnfciar.cd-grau-parentesco)          
                   then do:
                          assign lg-achou = no.    
         
                          for each teadgrpa FIELDS (nr-idade-minima nr-idade-maxima nr-faixa-etaria)
                             where teadgrpa.cd-modalidade      = import-bnfciar.cd-modalidade 
                               and teadgrpa.nr-proposta        = propost.nr-proposta
                               and teadgrpa.cd-grau-parentesco = import-bnfciar.cd-grau-parentesco NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
         
                              if   nr-idade-usuario >= teadgrpa.nr-idade-minima
                              and  nr-idade-usuario <= teadgrpa.nr-idade-maxima
                              then do:
                                     assign lg-achou = yes         
                                            nr-faixa-etaria-aux = teadgrpa.nr-faixa-etaria.
                                     leave.
                                   end.
                          end.
         
                          if   not lg-achou
                          then do:
                                 assign lg-relat-erro = yes.
                                 RUN pi-cria-tt-erros("Idade fora de faixa para este grau de parentesco").
                               end.
                        end.
                   else do:
                          assign lg-relat-erro = yes.
                          RUN pi-cria-tt-erros("Grau de Parentesco nao cadastrado p/termo de Adesao").
                        end.
                 end.
            else do:  
                   if  can-find(first pl-gr-pa 
                                where pl-gr-pa.cd-modalidade      = import-bnfciar.cd-modalidade
                                  and pl-gr-pa.cd-plano           = propost.cd-plano
                                  and pl-gr-pa.cd-tipo-plano      = propost.cd-tipo-plano
                                  and pl-gr-pa.cd-grau-parentesco = import-bnfciar.cd-grau-parentesco)
                   then do:
                          assign lg-achou = no.    
                          
                          for each pl-gr-pa FIELDS (nr-idade-minima nr-idade-maxima nr-faixa-etaria)
                             where pl-gr-pa.cd-modalidade      = import-bnfciar.cd-modalidade
                               and pl-gr-pa.cd-plano           = propost.cd-plano
                               and pl-gr-pa.cd-tipo-plano      = propost.cd-tipo-plano
                               and pl-gr-pa.cd-grau-parentesco = import-bnfciar.cd-grau-parentesco NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
         
                              if   nr-idade-usuario >= pl-gr-pa.nr-idade-minima
                              and  nr-idade-usuario <= pl-gr-pa.nr-idade-maxima
                              then do:
                                     assign lg-achou = yes
                                            nr-faixa-etaria-aux = pl-gr-pa.nr-faixa-etaria.
                                     leave.
                                   end.
                          end.
                          if   not lg-achou
                          and (import-bnfciar.dt-exclusao-plano = ? 
                           or  import-bnfciar.dt-exclusao-plano > today)
                          then do:
                                 assign lg-relat-erro = yes.
                                 RUN pi-cria-tt-erros("Idade fora de faixa para este grau de parentesco. Modalidade: " + STRING(import-bnfciar.cd-modalidade) + 
                                                      " Plano: "         + STRING(propost.cd-plano) +
                                                      " Tipo de Plano: " + STRING(propost.cd-tipo-plano) +
                                                      " Grau: "          + STRING(import-bnfciar.cd-grau-parentesco) + 
                                                      " Idade: "         +  string(nr-idade-usuario)).
                               end.
                        end.
                   else do:
                          assign lg-relat-erro = yes.
                          RUN pi-cria-tt-erros("Grau de Parentesco nao cadastrado para Plano").
                        end.
                 end.
         END.

    /* ------------------------------------------------------------------- */
    /* Verifica de tipo de plano recebe repasse */
    if   ti-pl-sa.in-tipo-movto-recebido <> 0
    then do:
           IF CAN-FIND (FIRST import-negociac-bnfciar WHERE import-negociac-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar)
           THEN DO:
                  IF NOT CAN-FIND (FIRST unimed where unimed.cd-unimed = import-bnfciar.cd-unimed-origem)
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Codigo da unidade origem nao cadastrado: " +
                                              if import-bnfciar.cd-unimed-origem <> ?
                                              then string(import-bnfciar.cd-unimed-origem,"9999")
                                              else "0000").
                       end.
                  
                  /*--- Valida o campo de Identificacao Origem do Beneficiario ---*/
                  if  import-bnfciar.cd-unimed-origem        = 0
                  and import-bnfciar.cd-identific-uni-origem = 0
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Codigo Identif na unidade Origem deve ser informado: " +
                                              if import-bnfciar.cd-identific-uni-origem <> ?
                                              then string(import-bnfciar.cd-identific-uni-origem,"9999999999999")
                                              else "0000000000000").
                       end.
                        
                  /*------ Valida o campo de Identificacao Origem -----------------------*/
                  if import-bnfciar.cd-identific-orig-resp  = 0 
                  or import-bnfciar.cd-identific-uni-origem = 0
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Cod Identif Origem deve ser informado. Respons: " +
                                              if import-bnfciar.cd-identific-orig-resp <> ?
                                              then string(import-bnfciar.cd-identific-orig-resp,"9999999999999")
                                              else "9999999999999" + 
                                              " Benef: " +  
                                              if import-bnfciar.cd-identific-uni-origem <> ?
                                              then string(import-bnfciar.cd-identific-uni-origem,"9999999999999")
                                              else "9999999999999").
                       end.
                  
                  /*------------ CONSISTE DATA DE INCLUSAO PLANO ORIGEM -------------*/
                  if import-bnfciar.dt-inclusao-origem <> ?
                  then do:
                         if ti-pl-sa.in-tipo-movto-recebido = 1  /* repasse */
                         then do:
                                if import-bnfciar.dt-inclusao-origem  > import-bnfciar.dt-inclusao-plano 
                                then do:
                                       assign lg-relat-erro = yes.
                                       RUN pi-cria-tt-erros("Dt Incl Plano origem: "   +
                                                            if import-bnfciar.dt-inclusao-origem <> ?
                                                            then string(import-bnfciar.dt-inclusao-origem,"99/99/9999")
                                                            else "00/00/0000" +                                      
                                                            " deve ser menor que incl plano atual: "       +
                                                            if import-bnfciar.dt-inclusao-plano <> ?
                                                            then string(import-bnfciar.dt-inclusao-plano,"99/99/9999")
                                                            else "00/00/0000").
                                     end.
                              end.
                         else do:    
                                if ti-pl-sa.in-tipo-movto-recebido = 0
                                then assign ds-movto-aux = "00 - Contratos".
                                else if ti-pl-sa.in-tipo-movto-recebido = 2
                                     then assign ds-movto-aux = "02 - Produtos".
                  
                                assign lg-relat-erro = yes.
                                RUN pi-cria-tt-erros("Tipo plano nao permite incl benef repassados. Movto permitido p/Tipo Plano: " + ds-movto-aux).
                              end.
                       end.
                END.
         end.
    else do:
           if import-bnfciar.cd-unimed-origem <> 0
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Modalidade nao indica beneficiario de outra unidade").
                end.
               
           if import-bnfciar.cd-identific-uni-origem <> 0
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Unidade origem zerada, identificacao nao pode ser preenchida").
                end.
             
           if import-bnfciar.cd-plano-origem <> ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Unidade origem zerada, plano origem nao pode ser preenchido").
                end.
           
           if import-bnfciar.nom-plano-orig <> ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Plano origem zerado, nome nao pode ser preenchido").
                end.
                
           if import-bnfciar.cd-identific-orig-resp <> 0 
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Unidade origem zerada, identific resp nao pode ser preenchida").
                end.
                 
           if import-bnfciar.dt-inclusao-origem <> ?
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Md nao indica benef de outra unidade, dt incl plano origem nao pode ser preenchida").
                end.
         end.
    
    /* ------------------------------------------------------------------- */
    IF NOT lg-gerar-termo-aux
    THEN if   propost.cd-sit-proposta > modalid.cd-sit-proposta
         then do:
                assign lg-relat-erro = yes.       
                RUN pi-cria-tt-erros("Situacao da Proposta nao permite inclusao do beneficiario").
              end.
     
    /* ------------------------------------------------------------------- */
    if   not propost.lg-mascara
    then do:
           if   import-bnfciar.cd-funcionario <> ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Parametro nao definido para codigo do funcionario").
                end.
         end.   
    else do:
           if   propost.ds-mascara <> ""
           and  import-bnfciar.cd-funcionario = ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Codigo do funcionario deve ser informado").
                end.
           
           if   import-bnfciar.cd-funcionario <> ""
           then do: 
                  run mcp/mc0111a5.p (input  propost.ds-mascara,
                                      input  import-bnfciar.cd-funcionario,
                                      input  "F",
                                      output lg-critica,
                                      output ds-mascara-aux).
                            
                  if   lg-critica
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Codigo do Funcionario esta Fora do Padrao").
                       end.
                
                  if   import-bnfciar.log-respons
                  then do:
                         IF CAN-FIND (first usuario USE-INDEX usuario9 
                                      where usuario.cd-modalidade     = propost.cd-modalidade
                                        and usuario.nr-proposta       = propost.nr-proposta
                                        and usuario.cd-funcionario    =  ds-mascara-aux
                                        and usuario.dt-exclusao-plano = ? )
                         then do:
                                assign lg-relat-erro = yes.
                                RUN pi-cria-tt-erros("Ja existe outro responsavel com este codigo").
                              end.
                       end.
                end.       
         end.
 
    /* ---------------------------- GRAU PARENTESCO -------------------- */
    IF NOT CAN-FIND (FIRST gra-par where gra-par.cd-grau-parent = int(import-bnfciar.cd-grau-parentesco))
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Grau de Parentesco nao Cadastrado").
         end.
 
    if not import-bnfciar.log-respons
    and    import-bnfciar.cd-grau-parentesco = ti-pl-sa.cd-grau-parentesco
    and    ti-pl-sa.lg-obriga-responsavel
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Beneficiario possui grau de parentesco de Responsavel mas LOG-RESPONS está FALSE").
         end.
    /* ------------------ DATA DE INCLUSAO DO PLANO ---------------------*/
    if import-bnfciar.dt-inclusao-plano < propost.dt-proposta
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Data de inclusao do Plano e menor que data da Proposta").
         end.
    
     /* ------------------------- UF ------------------------------- */
     if import-bnfciar.en-uf <> ""
     AND import-bnfciar.en-uf <> ?
     AND NOT CAN-FIND (FIRST dzestado 
                       where dzestado.nm-pais = "BRASIL"
                         and dzestado.en-uf   = import-bnfciar.en-uf)
     then do:
            assign lg-relat-erro = yes.
            RUN pi-cria-tt-erros("Estado nao Cadastrado ").
          end.
 
    /* ------------------------------------------------------------------- */
    FOR FIRST b-usuario FIELDS (cd-funcionario cd-titular cd-modalidade nr-proposta) USE-INDEX usuari26
        where b-usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-origem-responsavel
          and b-usuario.cd-usuario         = b-usuario.cd-titular NO-LOCK:
    END.
    
    /* ------------------------------------------------------------------- */
    ASSIGN cd-titular-aux = 0.

    if   import-bnfciar.log-respons 
    AND  ti-pl-sa.lg-obriga-responsavel
    then do: 
           if   import-bnfciar.cd-carteira-origem-responsavel <> import-bnfciar.cd-carteira-antiga        
           then do: 
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Indicador de Responsavel (log-respons=yes) mas carteira origem diferente (cd-carteira-origem-responsavel <> cd-carteira-antiga)").
                end.
         end.
    else if avail b-usuario                
         then do:
                if   import-bnfciar.cd-funcionario <> b-usuario.cd-funcionario
                then do:
                       assign lg-relat-erro = yes.
                       RUN pi-cria-tt-erros("Codigo do Funcionario informado difere do responsavel").
                     end.

                /**
                 * Verificar se o titular foi criado em outro contrato.
                 */
                IF import-bnfciar.cd-modalidade <> b-usuario.cd-modalidade
                OR nr-proposta-imp-aux          <> b-usuario.nr-proposta
                then do:
                       assign lg-relat-erro = yes.
                       RUN pi-cria-tt-erros("Responsavel foi criado em outra proposta. Verifique os DE/PARAS da Estrutura do Produto. Mod.Resp: " +
                                            STRING(b-usuario.cd-modalidade) + " Prop.Resp: " + 
                                            STRING(b-usuario.nr-proposta)   + " Mod.Dep: " + 
                                            STRING(import-bnfciar.cd-modalidade) + " Prop.Dep: " +
                                            STRING(nr-proposta-imp-aux) + "Cart.Antiga Resp.: " +
                                            STRING(import-bnfciar.cd-carteira-origem-responsavel) + " Carteira Antiga Dep.: " +
                                            STRING(import-bnfciar.cd-carteira-antiga)).
                     end.
 
                assign cd-titular-aux = b-usuario.cd-titular.             
              end. 
      
    if   import-bnfciar.dt-nascimento > today
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Data de Nascimento Invalida.").
         end.
   
     if   import-bnfciar.dt-nascimento > import-bnfciar.dt-inclusao-plano
     then do:
            assign lg-relat-erro = yes.
            RUN pi-cria-tt-erros("Data de Inclusao no Plano (" + 
                                 STRING(import-bnfciar.dt-inclusao-plano) + 
                                 ") inferior ao Nascimento (" 
                                 + STRING(IMPORT-bnfciar.dt-nascimento) + ").").
          end.
     
     if  import-bnfciar.dt-admissao = ?
     THEN DO:
            IF modalid.cd-tipo-medicina = cd-tipo-medi-aux
            then do:
                   assign lg-relat-erro = yes.
                   RUN pi-cria-tt-erros("Para Modalidade de Medicina Ocupacional, Data de admissao Deve ser Informada").
                 end. 
          END.
     ELSE if  import-bnfciar.dt-admissao < import-bnfciar.dt-nascimento
          then do:
                 IF TODAY <= dt-ignorar-validacao-aux /*regra desativada temporariamente para testes, enquanto cliente higieniza sua base*/
                 THEN DO:
                         FOR FIRST b-import-bnfciar
                             WHERE b-import-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar
                               AND b-import-bnfciar.num-seqcial-control = import-bnfciar.num-seqcial-control EXCLUSIVE-LOCK:

                                   ASSIGN b-import-bnfciar.dt-admissao = import-bnfciar.dt-nascimento.
                         END.
                         VALIDATE b-import-bnfciar.
                         RELEASE  b-import-bnfciar.
                 END.
                 ELSE DO:
                        assign lg-relat-erro = yes.
                        RUN pi-cria-tt-erros("Data de admissao nao pode ser menor que de nascimento").
                 END.
               end.
     
     IF NOT lg-relat-erro
     THEN run responsavel.
 
    /*----------------------------- DIGITO VERIFICADOR DO PIS ---------------------*/
    if import-bnfciar.cd-pis-pasep <> 0
    then do:
           assign nr-digito-aux = int(SUBstr(STRING(import-bnfciar.cd-pis-pasep,"99999999999"),11,1)).
           
           run rtp/rtdigver.p("PIS",
                              yes,
                              SUBstr(STRING(import-bnfciar.cd-pis-pasep,"99999999999"),1,10),
                              no,
                              output ds-mensagem-aux,
                              output lg-undo-retry,
                              input-output nr-digito-aux).
           
           if not lg-undo-retry
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Codigo do PIS/PASEP Invalido: " +
                                       if import-bnfciar.cd-pis-pasep <> ?
                                       then string(import-bnfciar.cd-pis-pasep,"99999999999")
                                       else "99999999999" + " " + trim(ds-mensagem-aux)).
                end.
         end.
    
    /*----------------------------- Valida faixa do segmento assistencial ---------------------*/
    if import-bnfciar.in-segmento-assistencial <> 0
    AND lookup(string(import-bnfciar.in-segmento-assistencial,"99"),lista-segmento-posicao-aux) = 0
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Codigo Segmento Assistencial Invalido " +
                                if import-bnfciar.in-segmento-assistencial <> ?
                                then string(import-bnfciar.in-segmento-assistencial,"99")
                                else "00").
         end.

    /* ------- VERIFICA DATA TITULAR SUPERIOR DEPENDENTE ------ */
    if   import-bnfciar.cd-carteira-origem-responsavel <> import-bnfciar.cd-carteira-antiga
    then do:
           /* ----- LOCALIZA BENEFICIARIO RESP BASE ------ */
           FOR first b-usuario FIELDS (dt-inclusao-plano)
               where b-usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-origem-responsavel NO-LOCK:
           END.
           
           IF NOT AVAIL b-usuario
           THEN do:

                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Beneficiario Responsavel nao cadastrado. Carteira Antiga: " +
                                       STRING(import-bnfciar.cd-carteira-antiga) +
                                       " Carteira Responsavel: " +
                                       STRING(import-bnfciar.cd-carteira-origem-responsavel)).

                end.

           ELSE if import-bnfciar.dt-inclusao-plano < b-usuario.dt-inclusao-plano
                then do:
                       /*regra desativada temporariamente para testes*/
                       IF TODAY < dt-ignorar-validacao-aux
                       THEN DO:
                               FOR FIRST b-import-bnfciar
                                   WHERE b-import-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar
                                     AND b-import-bnfciar.num-seqcial-control = import-bnfciar.num-seqcial-control EXCLUSIVE-LOCK:
    
                                         ASSIGN b-import-bnfciar.dt-inclusao-plano = b-usuario.dt-inclusao-plano.
                               END.
                               VALIDATE b-import-bnfciar.
                               RELEASE  b-import-bnfciar.
                       END.
                       ELSE DO:
                               assign lg-relat-erro = yes.
                               RUN pi-cria-tt-erros("Dt.Incl.Dep. e menor que a dt. incl.Resp. Dt.Incl.Dep.:" +
                                                    if import-bnfciar.dt-inclusao-plano <> ?
                                                    then string(import-bnfciar.dt-inclusao-plano,"99/99/9999")
                                                    else "00/00/0000" + 
                                                    " Dt.Incl.Resp.:" + 
                                                    if b-usuario.dt-inclusao-plano <> ?
                                                    then string(b-usuario.dt-inclusao-plano,"99/99/9999")
                                                    else "00/00/0000").
                       END.
                     end.
         end.
 
    /* ---------------------- NOME DO USUARIO ----------------------*/
    if   import-bnfciar.nom-usuar = "" 
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Nome do Beneficiario em Branco.").
         end.
    
    if  propost.lg-altera-taxa-inscricao 
    AND import-bnfciar.log-inscr-fatur = ?
    then do: 
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Indicador Taxa Insc. Fatura deve ser informado").
         end.

    if propost.lg-altera-fator-moderador 
    then do: 
           if import-bnfciar.log-cobr-fator-moder = ?
           then do: 
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Indicador Cobra Fator Partic. deve ser informado").
                 end.

            assign lg-insc-fat-aux = import-bnfciar.log-cobr-fator-moder.
         end.
    else assign lg-insc-fat-aux = yes.
       
    if   import-bnfciar.dt-exclusao-plano < import-bnfciar.dt-inclusao-plano
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Data da exclusao no Plano menor do que data de inclusao ").
         end.

    /* -------------------------------------------------------- */
    if not ti-pl-sa.lg-usa-padrao-cobertura
    then do:
           if import-bnfciar.cd-padrao-cob <> ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Tipo de Plano nao aceita padrao de cobertura ").
                end.          
         end.
    else do:
           if import-bnfciar.cd-padrao-cob = ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Codigo do Padrao de Cobertura nao Informado " +
                                       if import-bnfciar.cd-padrao-cob <> ?
                                       then import-bnfciar.cd-padrao-cob
                                       else "").
                end.
           else do:
                  /*
                  /*------- Rotina Congelamento Padrao Cobertura -------*/  
                  run rtp/rtconpad.p(input   import-bnfciar.cd-modalidade,
                                     input   propost.nr-proposta,
                                     input   import-bnfciar.cd-padrao-cob,
                                     input   lg-mensagem, 
                                     output  cd-tipo-mens,
                                     output  ds-tipo-mens,
                                     output  lg-retorna). 
    
                  if   cd-tipo-mens = "E"
                  then do: 
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros(ds-tipo-mens).
                       end.
                  */
                  /*----------------------------------------------------*/            
                end.       
         end.                                               
     
    if   import-bnfciar.dt-mvto-alteracao <> ?
    AND (import-bnfciar.dt-mvto-alteracao < import-bnfciar.dt-inclusao-plano 
    or   import-bnfciar.dt-mvto-alteracao > import-bnfciar.dt-exclusao-plano)
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Data movto alteracao deve estar em periodo onde beneficiario esteja ativo").
         end.
    
    /*----- PROPOSTA PEA ----------------------------------------------------*/
    if propost.lg-pea
    THEN DO:
           if import-bnfciar.dt-exclusao-plano = ?
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("PEA - Beneficiario ativo nao sera incluido em proposta Cancelada").
                end.
           ELSE IF import-bnfciar.dt-exclusao-plano > propost.dt-libera-doc
                then do:
                       run atual-datas.
                       assign propost.dt-libera-doc = import-bnfciar.dt-exclusao-plano.
                     end.   

           IF import-bnfciar.dt-falecimento-titular = ?  
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("PEA - Data do falecimento do titular deve ser Informada").
                end.
           ELSE IF import-bnfciar.dt-inclusao-plano < import-bnfciar.dt-falecimento-titular
                then do:
                       assign lg-relat-erro = yes.
                       RUN pi-cria-tt-erros("PEA - Data de Inclusao menor que data de Falecimento ").
                     end. 

           if  import-bnfciar.log-respons 
           and import-bnfciar.dt-inclusao-plano <> import-bnfciar.dt-exclusao-plano
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros("PEA - Responsavel Sinistrado deve possuir mesma data de Inclusao/Exclusao").
                end. 

           /* Codigo de cliente do benef. substituto */
           if  import-bnfciar.num-livre-10 <> 0
           and import-bnfciar.num-livre-10 <> ?
           then do:
                  if not can-find(first ems5.cliente 
                                  where ems5.cliente.cod_empresa = string(paramecp.ep-codigo)
                                    and ems5.cliente.cdn_cliente = import-bnfciar.num-livre-10)
                  then do:
                          assign lg-relat-erro = YES.
                          run pi-cria-tt-erros ("PEA - Beneficiario Substituto nao Cadastrado como Cliente no EMS").
                       end.
                end.
         END. 
    ELSE DO:
           if import-bnfciar.dt-falecimento-titular <> ? 
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data do falecimento nao deve ser informada").
                end.  

           if import-bnfciar.dt-exclusao-plano <> ? 
           then do:
                  if import-bnfciar.dt-exclusao-plano > propost.dt-libera-doc
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Data da exclusao no Plano maior que data de cancelamento da proposta").
                       end.

                  /* ----------------------- ULTIMO DIA DO MES DE REALIZACAO --- */
                  run rtp/rtultdia.p (input  year (import-bnfciar.dt-exclusao-plano),
                                      input  month(import-bnfciar.dt-exclusao-plano),
                                      output dt-fim-aux).
                 
                  if  (year (dt-fim-aux)< import-bnfciar.aa-ult-fat-period) or 
                      (month(dt-fim-aux)< import-bnfciar.num-mes-ult-faturam and
                       year(dt-fim-aux) = import-bnfciar.aa-ult-fat-period)
                  then do:
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros("Data da exclusao menor que o ultimo faturamento do beneficiario").
                       end.  
                end.
         END.
    
    if   import-bnfciar.dt-falecimento-titular <> ?  
    THEN DO:
           if   import-bnfciar.dt-falecimento-titular > today
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data de falecimento do titular maior que a atual.").
                end.

           if ti-pl-sa.lg-obriga-responsavel = no
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Tipo de Plano deve obrigar responsavel em prop. seguro assist.").
                end.
         END.
     
    if import-bnfciar.dt-atualizacao-carencia <> ? 
    then do:
           IF import-bnfciar.cd-userid-carencia = ""
           THEN DO:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data da atualiz. Carencia informada Usu atualiz. Carencia nao Informado.").
                END.
           
           if import-bnfciar.dt-atualizacao-carencia < import-bnfciar.dt-inclusao-plano 
           or import-bnfciar.dt-atualizacao-carencia > import-bnfciar.dt-exclusao-plano
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data atual. carencia deve estar em periodo onde o beneficiario esteja ativo").
                end.
         end.
    
    if import-bnfciar.dt-inicio-vinculo-unidade > import-bnfciar.dt-inclusao-plano 
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Data Inicio do vinculo Maior que data de Inclusao").
         end.
       
    /*---- verifica se  mes e ano diferentes ----   */
    if (import-bnfciar.num-mes-ult-faturam <> 0 and
        import-bnfciar.aa-ult-fat-period = 0 ) 
    or (import-bnfciar.num-mes-ult-faturam = 0 and 
        import-bnfciar.aa-ult-fat-period <> 0 ) 
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Mes/Ano  do ultimo faturamento difere da data de Inicio da proposta").
         end.
        
    /*Comentado 30/06/16*/
   /*if import-bnfciar.num-mes-ult-faturam <> 0  and
       import-bnfciar.aa-ult-fat-period   <> 0 
    then do: 
           if import-bnfciar.aa-ult-fat-period < year(import-bnfciar.dt-inclusao-plano)
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data do ultimo faturamento difere da data de Inicio da proposta").
                end.
           
           if  import-bnfciar.aa-ult-fat-period   =  year(import-bnfciar.dt-inclusao-plano)                
           and import-bnfciar.num-mes-ult-faturam < month(import-bnfciar.dt-inclusao-plano)
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data do ultimo faturamento difere da data de Inicio da proposta").
                end.
         end.*/
    
    /* --------------------------------------------------------------------- */
    if   import-bnfciar.num-mes-ult-faturam <> 0
    and  import-bnfciar.num-mes-ult-faturam <> int(substr(propost.mm-aa-ult-fat-mig,1,2))
    then if  year(import-bnfciar.dt-exclusao-plano) <> 0
         then if  int(substr(propost.mm-aa-ult-fat-mig,3,4)) < import-bnfciar.aa-ult-fat-period
              or (int(substr(propost.mm-aa-ult-fat-mig,3,4)) = import-bnfciar.aa-ult-fat-period
              and int(substr(propost.mm-aa-ult-fat-mig,1,2)) < import-bnfciar.num-mes-ult-faturam)
              then do:
                     /* Comentado 30/06 */
                     /*assign lg-relat-erro = yes.
                     RUN pi-cria-tt-erros("Ultimo faturamento do Benf. MAIOR que da proposta").*/
                   end.
              else.
         else do:
                assign lg-relat-erro = yes.
                RUN pi-cria-tt-erros("Mes de referencia da ultima fatura invalida").
              end.
           
    IF lg-gerar-termo-aux
    THEN DO:
           IF AVAIL ter-ade
           THEN DO:
                  /* ignorar essa validacao temporariamente pois somente pode ser feita na carga inicial. 
                  se os beneficiarios estao sendo reprocessados, sobrepor com datas do termo*/
                  
                  IF dt-ignorar-validacao-aux >= TODAY
                  THEN DO:
                          FOR FIRST b-import-bnfciar
                              WHERE b-import-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar
                                AND b-import-bnfciar.num-seqcial-control = import-bnfciar.num-seqcial-control EXCLUSIVE-LOCK:
    
                                    ASSIGN b-import-bnfciar.aa-ult-fat-period = ter-ade.aa-ult-fat.
                          END.
                          VALIDATE b-import-bnfciar.
                          RELEASE  b-import-bnfciar.

                  END.
                  ELSE DO:
                          if  import-bnfciar.aa-ult-fat-period <> 0 
                          and import-bnfciar.aa-ult-fat-period <> ter-ade.aa-ult-fat
                          then if  year(import-bnfciar.dt-exclusao-plano) <>  0
                               then if  ter-ade.aa-ult-fat < import-bnfciar.aa-ult-fat-period
                                    then do:
                                           assign lg-relat-erro = yes.
                                           RUN pi-cria-tt-erros2("Ano ultimo faturamento do Beneficiario (excluido) MAIOR que o do Termo de Adesao",
                                                                 "Ano ult. fat. Benef: " + string(import-bnfciar.aa-ult-fat-period) +
                                                                 ". Ano ult. fat. Termo: " + string(ter-ade.aa-ult-fat) +
                                                                 ". Data Exclusao Benef: " + string(import-bnfciar.dt-exclusao-plano)).
                                         end.
                                    else.
                               else do:
                                      assign lg-relat-erro = yes.
                                      RUN pi-cria-tt-erros2("Ano ultimo faturamento do Beneficiario MAIOR que o do Termo de Adesao",
                                                            "Ano ult. fat. Benef: " + string(import-bnfciar.aa-ult-fat-period) +
                                                            ". Ano ult. fat. Termo: " + string(ter-ade.aa-ult-fat)).
                                    end.                                           
                  END.
                END.

         END.
    ELSE DO:
           if  import-bnfciar.aa-ult-fat-period <> 0 
           and import-bnfciar.aa-ult-fat-period <> int(substr(propost.mm-aa-ult-fat-mig,3,4))
           then if  year(import-bnfciar.dt-exclusao-plano) <>  0
                then if  int(substr(propost.mm-aa-ult-fat-mig,3,4)) < import-bnfciar.aa-ult-fat-period
                     then do:
                            assign lg-relat-erro = yes.
                            RUN pi-cria-tt-erros("Ano ultimo faturamento MAIOR que o da proposta").
                          end.    
                     else.
                else do:
                       assign lg-relat-erro = yes.
                       RUN pi-cria-tt-erros("Ano de referencia da ultima fatura invalida").
                     end.                                           
         END.
    /* ------------------ Padrao de Cob. Anterior ------------------*/
    if not ti-pl-sa.lg-usa-padrao-cobertura
    then do:
           if import-bnfciar.cd-padrao-cob-ant <> ""
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Tipo de Plano nao aceita padrao de cobertura").
                end.          
         end.
    else do:
           if import-bnfciar.cd-padrao-cob-ant <> ""
           then do:
                  /*------- Rotina Congelamento Padrao Cobertura -------*/  
                  run rtp/rtconpad.p(input  import-bnfciar.cd-modalidade,
                                     input  propost.nr-proposta,
                                     input  import-bnfciar.cd-padrao-cob,
                                     input  lg-mensagem, 
                                     output cd-tipo-mens,
                                     output ds-tipo-mens,
                                     output lg-retorna). 
                  
                  if cd-tipo-mens = "E"
                  then do: 
                         assign lg-relat-erro = yes.
                         RUN pi-cria-tt-erros(ds-tipo-mens).
                       end.
                end.
         end.
    
    /*----- MEDICINA OCUPACIONAL --------------------------------------------*/
    if not lg-medocup-aux
    then do:
           /*----- VERIFICA SE CAMPOS ZERADOS -------------------------------*/
           if   import-bnfciar.cd-departamento = 0
           then do:
                  assign lg-relat-erro   = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Departamento nao foi informado").
                end.        
    
           if  import-bnfciar.cd-secao = 0
           then do:
                  assign lg-relat-erro   = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Secao nao foi informado").
                end.        
    
           if  import-bnfciar.cd-setor = 0
           then do:
                  assign lg-relat-erro   = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Setor nao foi informado").
                end.
    
           if  import-bnfciar.cd-carteira-trabalho = ""
           then do:
                  assign lg-relat-erro   = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Carteira Trabalho nao foi informada").
                end.
    
           if import-bnfciar.dt-primeira-consulta = ?
           then do:
                  assign lg-relat-erro   = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Data Primeira Consulta nao informada").
                end. 
     
           /*----- VERIFICA DEPARTAMENTO ------------------------------------*/
           IF NOT CAN-FIND (FIRST departa where departa.cd-departamento = import-bnfciar.cd-departamento)
           then do:
                  assign lg-relat-erro  = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Departamento nao Cadastrado - " + 
                                       if import-bnfciar.cd-departamento <> ?
                                       then string(import-bnfciar.cd-departamento,"999")
                                       else "000").
                end.
    
           /*----- VERIFICA SECAO -------------------------------------------*/
           IF NOT CAN-FIND (FIRST secao where secao.cd-secao = import-bnfciar.cd-secao)
           then do:
                  assign lg-relat-erro   = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Secao nao Cadastrada - " + 
                                       if import-bnfciar.cd-secao <> ?
                                       then string(import-bnfciar.cd-secao,"999")
                                       else "000").
                end.
       
           /*----- VERIFICA SETOR -------------------------------------------*/
           IF NOT CAN-FIND (FIRST setor where setor.cd-setor = import-bnfciar.cd-setor)
           then do:
                  assign lg-relat-erro  = yes
                         lg-medocup-erro = yes.
                  RUN pi-cria-tt-erros("Setor nao Cadastrado - " + 
                                                     if import-bnfciar.cd-setor <> ?
                                                     then string(import-bnfciar.cd-setor,"999") 
                                                     else "000").
                end.
                
           /*----- CRIA DEPSETSE -----------------------------*/
           IF NOT CAN-FIND (first depsetse
                            where depsetse.cd-modalidade   = import-bnfciar.cd-modalidade
                              and depsetse.nr-proposta     = propost.nr-proposta
                              and depsetse.cd-departamento = import-bnfciar.cd-departamento
                              and depsetse.cd-secao        = import-bnfciar.cd-secao
                              and depsetse.cd-setor        = import-bnfciar.cd-setor)
           then do:
                  assign lg-relat-erro  = yes
                         lg-medocup-erro = yes.
                  
                  RUN pi-cria-tt-erros("Tabela de PropostaXDepXSecaoXSetor nao cadastrada" +                 
                                       " -Dep.: "  + if import-bnfciar.cd-departamento <> ?                                     
                                                     then string(import-bnfciar.cd-departamento,"999")                          
                                                     else "000" +                                             
                                       " -Secao: " + if import-bnfciar.cd-secao <> ?                                    
                                                     then string(import-bnfciar.cd-secao,"999")                         
                                                     else "000" +                                            
                                       " -Setor: " + if import-bnfciar.cd-setor <> ?                                    
                                                     then string(import-bnfciar.cd-setor,"999")                         
                                                     else "000").
                end.
           ELSE FOR first depsetse FIELDS (char-1)
                    where depsetse.cd-modalidade   = import-bnfciar.cd-modalidade
                      and depsetse.nr-proposta     = propost.nr-proposta
                      and depsetse.cd-departamento = import-bnfciar.cd-departamento
                      and depsetse.cd-secao        = import-bnfciar.cd-secao
                      and depsetse.cd-setor        = import-bnfciar.cd-setor NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
    
                    if depsetse.char-1 <> "A"
                    then do:
                           assign lg-relat-erro  = yes
                                  lg-medocup-erro = yes.
                           RUN pi-cria-tt-erros("PropostaXDepXSecaoXSetor nao esta ativo" +
                                                " -Dep.: " + if import-bnfciar.cd-departamento <> ?
                                                             then string(import-bnfciar.cd-departamento,"999")
                                                             else "000" +
                                                " -Secao: " + if import-bnfciar.cd-secao <> ?
                                                              then string(import-bnfciar.cd-secao,"999")
                                                              else "000" +
                                                " -Setor: " + if import-bnfciar.cd-setor <> ?
                                                              then string(import-bnfciar.cd-setor,"999")
                                                              else "000").
                         end. 
    
                END.
         end.
         
    if  lg-inf-mae-aux                                 
    then do:
           /* --- O NOME DA MAE NAO PODE CONTER CARACTERES IGUAIS NAS 3 PRIMEIRAS POSICOES --- */
           if import-bnfciar.nom-mae <> ""
           AND (substring(import-bnfciar.nom-mae,1,1) = substring(import-bnfciar.nom-mae,2,1) AND 
                substring(import-bnfciar.nom-mae,1,1) = substring(import-bnfciar.nom-mae,3,1))
                then do:
                       assign lg-relat-erro = yes.
                       RUN pi-cria-tt-erros("Nome da mae nao pode repetir letras iguais nas 3 primeiras posicoes.").
                     end. 
         end.
    
    /* ------------ CONSISTE DADOS PARA ANS CONFORME IN 18 -------------------- */
    /* ------------------------------------------------------------------------ */
    if  (   import-bnfciar.cd-unimed-origem = 0                            
         or import-bnfciar.cd-unimed-origem = paramecp.cd-unimed)
    and  lg-medocup-aux
    and  lg-inf-cpf-pis-cartaonac-aux
    then do:
           assign nr-ident-compl-aux = 0.
    
           if   import-bnfciar.cd-cpf      <> ?
           and  dec(import-bnfciar.cd-cpf) <> 0
           then assign nr-ident-compl-aux = nr-ident-compl-aux + 1.
    
           if   import-bnfciar.cd-pis-pasep <> 0
           then assign nr-ident-compl-aux = nr-ident-compl-aux + 1.
    
           if   import-bnfciar.nom-mae <> ""
           then assign nr-ident-compl-aux = nr-ident-compl-aux + 1.
    
           if   import-bnfciar.cd-cartao-nacional-saude <> 0
           then assign nr-ident-compl-aux = nr-ident-compl-aux + 1.
    
           /* Titular */
           if   import-bnfciar.log-respons            
           and  ti-pl-sa.cd-grau-parentesco = import-bnfciar.cd-grau-parentesco
           AND  nr-ident-compl-aux < 1 
           then do:                                 
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Pelo menos um dos campos de ident.complementar deve ser informado para beneficiarios titulares").
                end.
         end.
    
    /*----- VENDEDOR --------------------------------------------------------*/

    /*--- le a tabela vendedor ---*/
    /************************************************************************************************
*      Include  .....: srrepres.i                                                               *
*      Data .........: 05 de Agosto de 2000                                                     *
*      Empresa ......: DZSET SOLUCOES & SISTEMAS                                                *
*      Programador ..: Jaqueline Formigheri                                                     *
*      Objetivo .....: Leitura da tabela repres                                                 *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      D.00.000  05/09/2000  Jaque           Desenvolvimento                                    *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco                               *
*      E.01.000  07/06/2001  Leonardo        Conversao EMS504                                   *
************************************************************************************************/

 /*do:
        find representante
             where representante.cod_empresa = string(propost.ep-codigo)
               and representante.cdn_repres  = import-bnfciar.cd-vendedor
                   no-lock no-error.
        if   avail representante
        then do:
                assign lg-avail-srrepres      = yes
                       nm-representante-srems = representante.nom_pessoa.

                find emscad.pessoa_fisic where 
                     emscad.pessoa_fisic.num_pessoa_fisic = representante.num_pessoa 
                     no-lock no-error.

                if avail emscad.pessoa_fisic
                then assign ds-natureza-repres-srems = "F"
                            nr-cpf-cgc-repres-srems  = emscad.pessoa_fisic.cod_id_feder.
                else do:
                       find pessoa_jurid where 
                            pessoa_jurid.num_pessoa_jurid = representante.num_pessoa 
                            no-lock no-error.
                       if avail pessoa_jurid 
                       then assign ds-natureza-repres-srems = "J"
                                   nr-cpf-cgc-repres-srems  = pessoa_jurid.cod_id_feder.
                       else assign ds-natureza-repres-srems = " "
                                   nr-cpf-cgc-repres-srems  = "".
                    end.
             end.
        else assign lg-avail-srrepres        = no
                    nm-representante-srems   = "** NAO CADASTRADO **"
                    ds-natureza-repres-srems = " "
                    nr-cpf-cgc-repres-srems  = "".
      end.


/* ------------------------------------------------------------------------------------------- */
 .

    if   not lg-avail-srrepres
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Codigo do vendedor nao cadastrado").
         end.*/
    
    /* --------------------------------------------------------------------- */
    if  (import-bnfciar.des-orgao-emissor-ident <> "" or import-bnfciar.nom-pais <> "" or import-bnfciar.nr-identidade <> "")
    AND (import-bnfciar.des-orgao-emissor-ident = "                              " or import-bnfciar.nom-pais = "" or import-bnfciar.nr-identidade = "")
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Quando um dos campos a seguir for informado, tornam-se obrigatorios: Orgao emissor ident; Pais emissao ident; Nro da C.Ident.").
         end.
    
    /* ------------- CONSISTE O ORGAO EMISSOR DO DOCUMENTO DE IDENTIFICACAO --- */
    if trim(import-bnfciar.des-orgao-emissor-ident) <> ""
    then do:           
           run valida-orgao-emissor(input  trim(import-bnfciar.des-orgao-emissor-ident),
                                    output lg-erro-aux).
           if lg-erro-aux
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Campo Orgao Emissor do Documento de Identificacao com valor incorreto: " + trim(import-bnfciar.des-orgao-emissor-ident)).
                end.
         end.
    
    /* ---------------------------------------------- MOTIVO DE INCLUSAO --- */
    if import-bnfciar.in-via-transferencia = ""
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Motivo da inclusao nao informado").
         end.
    else do:
           if  import-bnfciar.in-via-transferencia <> "N"
           and import-bnfciar.in-via-transferencia <> "C"
           and import-bnfciar.in-via-transferencia <> "V"
           and import-bnfciar.in-via-transferencia <> "S"
           and import-bnfciar.in-via-transferencia <> "B"
           and import-bnfciar.in-via-transferencia <> "D"
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Motivo da inclusao invalido").
                end.
         end.
    
    if import-bnfciar.dt-emissao-ident <> ?
    then do:
           if import-bnfciar.dt-emissao-ident < import-bnfciar.dt-nascimento 
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data emissao documento menor que data nascimento").
                end.
    
           if import-bnfciar.dt-emissao-ident > today 
           then do:
                  assign lg-relat-erro = yes.
                  RUN pi-cria-tt-erros("Data emissao documento maior que data atual").
                end.
         end.
    
    /**
     * 06/12/16 - Alex Boeira - validacao retirada pois Demitidos no Unicoo sao convertidos em 2 registros no TOTVS, com mesmo CCO.
     *                          Um deles vinculado a empresa em que trabalhou, o outro eh o plano DEMAP (ele eh o proprio contratante origem).
    IF import-bnfciar.cd-controle-oper-ans <> 0
    AND CAN-FIND (FIRST b-usuario use-index usuari45 where b-usuario.cd-controle-oper-ans = import-bnfciar.cd-controle-oper-ans)
    then do:
           assign lg-relat-erro = yes.
           RUN pi-cria-tt-erros("Codigo de Controle Operacional ja cadastrado").
         end.
    */
    
    /*------------------------------------------------------------------------*/
    if import-bnfciar.cd-padrao-cob <> ""
    then do: 
           /**
            * Alex Boeira - 25/02/2016
            * Comentei essa logica pois entendo ser redundante.
            * Essa validacao deve ser feita na criacao da proposta, nao aqui no beneficiario.
            * Perda de performance.
            
           for each propcopa FIELDS (cd-modalidade nr-proposta cd-modulo)
              where propcopa.cd-modalidade       = propost.cd-modalidade
                and propcopa.nr-proposta         = propost.nr-proposta  
                and propcopa.cd-padrao-cobertura = import-bnfciar.cd-padrao-cob       
                    NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
               
               FOR first pro-pla FIELDS (lg-cobertura-obrigatoria cd-modulo)  
                   where pro-pla.cd-modalidade = propcopa.cd-modalidade
                     and pro-pla.nr-proposta   = propcopa.nr-proposta
                     and pro-pla.cd-modulo     = propcopa.cd-modulo NO-LOCK QUERY-TUNING (NO-INDEX-HINT):
               END.
    
               if not avail pro-pla 
               then do: 
                      assign lg-relat-erro = yes.
                      RUN pi-cria-tt-erros("Modulo " + 
                                           if propcopa.cd-modulo <> ?
                                           then string(propcopa.cd-modulo)
                                           else "" + 
                                           " nao vinculado a proposta " + 
                                           if propcopa.nr-proposta <> ?
                                           then string(propcopa.nr-proposta)
                                           else "" + 
                                           " da modalidade " + 
                                           if propcopa.cd-modalidade <> ?
                                           then string(propcopa.cd-modalidade)
                                           else "").
                    end.
               ELSE if pro-pla.lg-cobertura-obrigatoria = no /* s½ vai para o usu-mod o que nao for obrigatorio */
                    AND NOT CAN-FIND (FIRST pla-mod
                                      where pla-mod.cd-modalidade = propost.cd-modalidade
                                        and pla-mod.cd-plano      = propost.cd-plano
                                        and pla-mod.cd-tipo-plano = propost.cd-tipo-plano
                                        and pla-mod.cd-modulo     = pro-pla.cd-modulo)
                    then do:
                           assign lg-relat-erro = yes.
                   
                           RUN pi-cria-tt-erros("Modulo " + 
                                                if pro-pla.cd-modulo <> ?
                                                then string(pro-pla.cd-modulo)
                                                else "" + 
                                                " nao associado a modalidade " + 
                                                if propost.cd-modalidade <> ?
                                                then string(propost.cd-modalidade)
                                                else "" + 
                                                ", plano " + 
                                                if propost.cd-plano <> ?
                                                then string(propost.cd-plano)
                                                else "" + 
                                                ", tipo de plano " + 
                                                if propost.cd-tipo-plano <> ?
                                                then string(propost.cd-tipo-plano)
                                                else "").
                         end. 
           end.*/
         end. /* if cd-padrao-cob-imp <> "" */
    else 
         /**
          * Alex Boeira - 25/02/2016
          * Retirei essa logica daqui e coloquei no inicio do cg0310x.p (migracao de propostas).
          * Dessa forma a validacao eh feita apenas uma vez, sem se repetir para cada beneficiario.
          * Perda de performance.

         for each pla-mod FIELDS (cd-modalidade cd-plano cd-tipo-plano cd-modulo)
            where pla-mod.cd-modalidade = propost.cd-modalidade 
              and pla-mod.cd-plano      = propost.cd-plano
              and pla-mod.cd-tipo-plano = propost.cd-tipo-plano
              and pla-mod.lg-grava-automatico 
                  NO-LOCK,

             first pro-pla FIELDS (lg-cobertura-obrigatoria)   
             where pro-pla.cd-modalidade = propost.cd-modalidade
               and pro-pla.nr-proposta   = propost.nr-proposta
               and pro-pla.cd-modulo     = pla-mod.cd-modulo
                   NO-LOCK, 
    
             FIRST mod-cob where mod-cob.cd-modulo = pla-mod.cd-modulo NO-LOCK:

             IF  pro-pla.lg-cobertura-obrigatoria = no
             AND mod-cob.in-identifica-modulo     = "S" 
             AND NOT CAN-FIND (FIRST paramdsg 
                               where paramdsg.cd-chave-primaria = paravpmc.cd-chave-primaria                                             
                                 and paramdsg.cd-modalidade     = pla-mod.cd-modalidade                                                  
                                 and paramdsg.cd-plano          = pla-mod.cd-plano                                                       
                                 and paramdsg.cd-tipo-plano     = pla-mod.cd-tipo-plano                                                  
                                 and paramdsg.cd-modulo         = pla-mod.cd-modulo)                         
             then do:                                                                                   
                    assign lg-relat-erro  = yes.
                    RUN pi-cria-tt-erros("Parametros dos Modulos de Seguro nao Cadastrados").
                  end.   
         end.*/

    /*----- SE MEDICINA OCUPACIONAL -----------------------------------------*/
    if not lg-medocup-aux
    AND import-bnfciar.cd-funcao <> 0 
    AND NOT CAN-FIND (first funcprop 
                      where funcprop.cd-modalidade = import-bnfciar.cd-modalidade
                        and funcprop.nr-proposta   = propost.nr-proposta
                        and (funcprop.cd-setor     = import-bnfciar.cd-setor 
                             or funcprop.cd-setor  = 0)
                        and funcprop.cd-funcao     = import-bnfciar.cd-funcao
                        and funcprop.in-situacao   = "A" )
    then do:        
           assign lg-relat-erro  = yes.
           RUN pi-cria-tt-erros("Funcao empresa nao cadastrada para esta proposta" + ds-mensagem-aux).
         end.

    /* consistir lotacao */
    IF paravpmc.log-livre-26 /* indicador se utiliza lotacao */
    THEN DO:
           IF modalid.in-tipo-pessoa = "J"
           THEN DO:
                  IF import-bnfciar.num-livre-2 <> 0 /* cdn-respons-financ, utilizado somente quando beneficiario APOSENTADO / DEMITIDO */
                  THEN DO:
                         /* validacao retirada pois apos nova definicao, planos ADESAO tambem podem informar responsavel financeiro, mesmo sem lotacao (Alex Boeira 20/04/2017)
                         IF import-bnfciar.num-livre-1 <> 99999
                         THEN DO:
                                assign lg-relat-erro  = yes.
                                RUN pi-cria-tt-erros("Quando IMPORT-BNFCIAR.NUM-LIVRE-2 (CDN-RESPONS-FINANC) esta preenchido a lotacao deve ser 99999 (DEMITIDO/APOSENTADO). Recebida: "
                                                     + STRING(IMPORT-BNFCIAR.NUM-LIVRE-1)).
                              END.
                         */
                         IF NOT CAN-FIND(FIRST contrat WHERE contrat.cd-contratante = import-bnfciar.num-livre-2)
                         THEN DO:
                                assign lg-relat-erro  = yes.
                                RUN pi-cria-tt-erros("Contratante codigo : " + STRING(import-bnfciar.num-livre-2) 
                                                     + " nao cadastrado como Contratante para ser Responsavel Financeiro pela familia.").
                              END.
                       END.
                  ELSE DO:
                         IF import-bnfciar.num-livre-1 = 1 /* codigo fixo para lotacao de DEMITIDO/APOSENTADO */
                         THEN DO:
                                assign lg-relat-erro  = yes.
                                RUN pi-cria-tt-erros("Quando a lotacao for 1 (DEMITIDO/APOSENTADO), IMPORT-BNFCIAR.NUM-LIVRE-2 (CDN-RESPONS-FINANC) deve ser preenchido. "
                                                     + " CDN-RESPONS-FINANC: " + STRING(import-bnfciar.num-livre-2)).
                              END.
                       END.
                END.
           ELSE DO:
                  IF import-bnfciar.num-livre-1 <> 0 /* cdn-lotacao */
                  THEN DO:
                         assign lg-relat-erro  = yes.
                         RUN pi-cria-tt-erros("IMPORT-BNFCIAR.NUM-LIVRE-1 (CDN-LOTACAO) esta preenchido para beneficiario de modalidade FISICA.").
                       END.
                END.
         END.
    ELSE DO:
           IF import-bnfciar.num-livre-1 <> 0 /* cdn-lotacao */
           THEN DO:
                  assign lg-relat-erro  = yes.
                  RUN pi-cria-tt-erros("Sistema parametrizado para nao usar lotacao, mas IMPORT-BNFCIAR.NUM-LIVRE-1 esta informado.").
                END.
         END.

END PROCEDURE.

PROCEDURE consiste-campos-espec:

    def var ix-campo                  as int                             no-undo.
    def var ix-contador               as int                             no-undo.
    def var tt-frame                  as int                             no-undo.
    def var ds-campo-auxil            as char format "x(20)"  extent 4   no-undo.
    def var ds-mascara-aux            as char format "x(20)"  extent 4   no-undo.
    def var nr-esp-aux                as int                  extent 4   no-undo.
    def var lg-critica                as log                             no-undo.
    def var lg-erro-mascara           as log                             no-undo.
    def var lg-erro-masc              as log                             no-undo.
    def var c-dig-mascara             as char format "x".
    def var ct-cont                   as inte.
    def var cd-mascara-aux            as char format "x(20)"             no-undo.
    def var ds-esp-aux                like  usuario.ds-especifico1       no-undo.
    def var ds-mascara-aux-imp        as char format "x(20)"             no-undo.

    FOR FIRST campprop FIELDS (ds-campo ds-mascara cd-modalidade nr-proposta lg-obriga-digitacao lg-consiste-dados)
        where campprop.cd-modalidade = import-bnfciar.cd-modalidade
          and campprop.nr-proposta   = nr-proposta-aux NO-LOCK:
    END.
 
    if avail campprop
    then do:    
           /* --------------------------------------------------------------- */
           assign ix-contador = 0
                  ix-campo    = 0.
        
           do ix-campo = 1 to 4:
        
              if   campprop.ds-campo[ix-campo] <> ""
              then do:
                     ix-contador = ix-campo.
        
                     case ix-contador:
                        when 1
                        then assign ds-campo-auxil[1] = campprop.ds-campo[ix-campo]
                                    ds-mascara-aux[1] = campprop.ds-mascara[ix-campo]
                                    nr-esp-aux[1]     = ix-campo.
                        when 2
                        then assign ds-campo-auxil[2] = campprop.ds-campo[ix-campo]
                                    ds-mascara-aux[2] = campprop.ds-mascara[ix-campo]
                                    nr-esp-aux[2]     = ix-campo.
                        when 3
                        then assign ds-campo-auxil[3] = campprop.ds-campo[ix-campo]
                                    ds-mascara-aux[3] = campprop.ds-mascara[ix-campo]
                                    nr-esp-aux[3]     = ix-campo.
                        when 4
                        then assign ds-campo-auxil[4] = campprop.ds-campo[ix-campo]
                                    ds-mascara-aux[4] = campprop.ds-mascara[ix-campo]
                                    nr-esp-aux[4]     = ix-campo.
                     end case.
        
                     if   ix-contador = 4
                     then leave.
                   end.
           end.
        
           /* --------------------------------------------------------------- */
           if   import-bnfciar.des-espcif-1 <> ""
           and  ds-campo-auxil[1]  <> ""
           then do:
                  run mcp/mc0111a5.p (input  ds-mascara-aux[1],
                                      input  (import-bnfciar.des-espcif-1),
                                      input  "F",
                                      output lg-critica,
                                      output ds-mascara-aux-imp).
        
                  if   lg-critica
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do cpo especifico 1 nao esta do Padrao " + import-bnfciar.des-espcif-1 + " Cadastro: " + ds-mascara-aux[1]). 
                       end.
        
                  if   import-bnfciar.des-espcif-1 <> ds-mascara-aux-imp
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Campo especifico 1 nao esta do Padrao " + import-bnfciar.des-espcif-1 + " Cadastro: " + ds-mascara-aux[1]). 
                       end.
                end.
        
           if   ds-campo-auxil[1] <> ""
           then do:
                  assign lg-erro-mascara = no.
        
                  /* ----------------------------------- CONSISTENCIA PARA CAMPO 1 -------- */
                  if  campprop.lg-obriga-digitacao[1]
                  AND ds-campo-auxil[1] <> ""
                  AND import-bnfciar.des-espcif-1 = ""
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do campo especifico 1 no formato " + campprop.ds-mascara[1] + " deve ser informada").
                         assign lg-erro-mascara = yes.
                       end.
                  
                  /*if  campprop.lg-consiste-dados[1]
                  AND ds-campo-auxil[1] <> ""
                  then do:
                         FOR FIRST b-usuario FIELDS (cd-usuario nm-usuario)
                             where b-usuario.cd-modalidade     = campprop.cd-modalidade
                               and b-usuario.nr-proposta       = campprop.nr-proposta
                               and b-usuario.ds-especifico1    = ds-campo-auxil[1]
                               and b-usuario.cd-usuario       <> usuario.cd-usuario
                               and b-usuario.dt-exclusao-plano = ? NO-LOCK:
                         END.
                         if avail b-usuario
                         then do:
                                assign lg-relat-erro = yes.
                                run pi-cria-tt-erros("Mascara ja cadastrada para beneficiario - Codigo: " + string(b-usuario.cd-usuario,"999999") + b-usuario.nm-usuario).
                                assign lg-erro-mascara = yes.
                              end. 
                       end.*/
                end.
        
           /* --------------------------------------------------------------- */
           if   import-bnfciar.des-espcif-2 <> ""
           and  ds-campo-auxil[2] <> ""
           then do:
                  run mcp/mc0111a5.p  (input  ds-mascara-aux[2],
                                       input (import-bnfciar.des-espcif-2),
                                       input "F",
                                       output lg-critica,
                                       output ds-mascara-aux-imp).
        
                  if   lg-critica
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do cpo especifico 2 nao esta do Padrao " + import-bnfciar.des-espcif-2 + " Cadastro: " + ds-mascara-aux[2]). 
                       end.
        
                  if   import-bnfciar.des-espcif-2 <> ds-mascara-aux-imp
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Campo especifico 2 nao esta do Padrao " + import-bnfciar.des-espcif-2 + " Cadastro: " + ds-mascara-aux[2]). 
                       end.
                end.
        
           if   ds-campo-auxil[2] <> ""
           then do:
                  assign lg-erro-mascara = no.
        
                  /* ----------------------------------- CONSISTENCIA PARA CAMPO ---------- */
                  if  campprop.lg-obriga-digitacao[2]
                  AND ds-campo-auxil[2] <> ""
                  AND import-bnfciar.des-espcif-2 = ""
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do campo especifico 2 no formato " + campprop.ds-mascara[2] + " deve ser informada").
                         assign lg-erro-mascara = yes.
                       end.
                  
                  /*if  campprop.lg-consiste-dados[2]
                  AND ds-campo-auxil[2] <> ""
                  then do:
                         FOR FIRST b-usuario FIELDS (cd-usuario nm-usuario)
                             where b-usuario.cd-modalidade     = campprop.cd-modalidade
                               and b-usuario.nr-proposta       = campprop.nr-proposta
                               and b-usuario.ds-especifico2    = ds-campo-auxil[2]
                               and b-usuario.cd-usuario       <> usuario.cd-usuario
                               and b-usuario.dt-exclusao-plano = ? NO-LOCK:
                         END.
                         if avail b-usuario
                         then do:
                                assign lg-relat-erro = yes.
                                run pi-cria-tt-erros("Mascara ja cadastrada para beneficiario - Codigo: " + string(b-usuario.cd-usuario,"999999") + b-usuario.nm-usuario).
                                assign lg-erro-mascara = yes.
                              end.
                       end.*/

                end.
        
           /* --------------------------------------------------------------- */
           if   import-bnfciar.des-espcif-3 <> ""
           and  ds-campo-auxil[3] <> ""
           then do:
                  run mcp/mc0111a5.p  (input  ds-mascara-aux[3],
                                       input (import-bnfciar.des-espcif-3),
                                       input "F",
                                       output  lg-critica,
                                       output ds-mascara-aux-imp).
        
                  if   lg-critica
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do cpo especifico 3 nao esta do Padrao " + import-bnfciar.des-espcif-3 + " Cadastro: " + ds-mascara-aux[3]). 
                       end.
        
                  if   import-bnfciar.des-espcif-3 <> ds-mascara-aux-imp
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Campo especifico 3 nao esta do Padrao " + import-bnfciar.des-espcif-3 + " Cadastro: " + ds-mascara-aux[3]). 
                       end.
                end.
        
           if   ds-campo-auxil[3] <> ""
           then do:
                  assign lg-erro-mascara = no.
        
                  /* ----------------------------------- CONSISTENCIA PARA CAMPO ---------- */
                  if  campprop.lg-obriga-digitacao[3]
                  AND ds-campo-auxil[3] <> ""
                  and import-bnfciar.des-espcif-3 = ""
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do campo especifico 3 no formato " + campprop.ds-mascara[3] + " deve ser informada").
                         assign lg-erro-mascara = yes.
                       end.
                  
                  /*if  campprop.lg-consiste-dados[3]
                  AND ds-campo-auxil[3] <> ""
                  then do:
                         FOR FIRST b-usuario FIELDS (cd-usuario nm-usuario)
                             where b-usuario.cd-modalidade     = campprop.cd-modalidade
                               and b-usuario.nr-proposta       = campprop.nr-proposta
                               and b-usuario.ds-especifico3    = ds-campo-auxil[3]
                               and b-usuario.cd-usuario       <> usuario.cd-usuario
                               and b-usuario.dt-exclusao-plano = ? NO-LOCK :
                         END.
                         if avail b-usuario
                         then do:
                                assign lg-relat-erro = yes.
                                run pi-cria-tt-erros("Mascara ja cadastrada para beneficiario - Codigo: " + string(b-usuario.cd-usuario,"999999") + b-usuario.nm-usuario).
                                assign lg-erro-mascara = yes.
                              end.
                       end.*/
                end.
        
           /* --------------------------------------------------------------- */
           if   import-bnfciar.des-espcif-4 <> ""
           and  ds-campo-auxil[4] <> ""
           then do:
                  run mcp/mc0111a5.p  (input ds-mascara-aux[4],
                                       input (import-bnfciar.des-espcif-4),
                                       input "F",
                                       output  lg-critica,
                                       output ds-mascara-aux-imp).
        
                  if   lg-critica
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do cpo especifico 4 nao esta no Padrao " + import-bnfciar.des-espcif-4 + " Cadastro: " + ds-mascara-aux[4]). 
                       end.
        
                  if   import-bnfciar.des-espcif-4 <> ds-mascara-aux-imp
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Campo especifico 4 nao esta no Padrao " + import-bnfciar.des-espcif-4 +  " Cadastro: " + ds-mascara-aux[4]).  
                       end.
                end.
        
           if   ds-campo-auxil[4] <> ""
           then do:
                  assign lg-erro-mascara = no.
        
                  /* ----------------------------------- CONSISTENCIA PARA CAMPO ---------- */
                  if  campprop.lg-obriga-digitacao[4]
                  AND ds-campo-auxil[4] <> ""
                  AND import-bnfciar.des-espcif-4 = ""
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros("Mascara do campo especifico 4 no formato " + campprop.ds-mascara[4] + " deve ser informada").
                         assign lg-erro-mascara = yes.
                       end.
                  
                  /*if  campprop.lg-consiste-dados[4]
                  AND ds-campo-auxil[4] <> ""
                  then do:
                         FOR FIRST b-usuario FIELDS (cd-usuario nm-usuario)
                             where b-usuario.cd-modalidade     = campprop.cd-modalidade
                               and b-usuario.nr-proposta       = campprop.nr-proposta
                               and b-usuario.ds-especifico4    = ds-campo-auxil[4]
                               and b-usuario.cd-usuario       <> usuario.cd-usuario
                               and b-usuario.dt-exclusao-plano = ? NO-LOCK:
                         END.
                         if avail b-usuario
                         then do:
                                assign lg-relat-erro = yes.
                                run pi-cria-tt-erros("Mascara ja cadastrada para beneficiario - Codigo: " + string(b-usuario.cd-usuario,"999999") + b-usuario.nm-usuario).
                                assign lg-erro-mascara = yes.
                              end.
                       end.*/
                end.
         END.
    else if   import-bnfciar.des-espcif-1 <> ""
         or   import-bnfciar.des-espcif-2 <> ""
         or   import-bnfciar.des-espcif-3 <> ""
         or   import-bnfciar.des-espcif-4 <> ""
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros("Campos Especificos devem conter brancos"). 
              end.

     if lg-erro-mascara = yes
     THEN lg-relat-erro = YES.

END PROCEDURE.

                      
procedure RESPONSAVEL.
 
   assign lg-retorna = no.
 
   /* ---------------------- CONSISTE GRAU DE PARENTESCO DO BENEFICIARIO --- */
   assign in-funcao-rtapi041-aux           = "CST"
          lg-prim-mens-rtapi041-aux        = no
          lg-erro-rtapi041-aux             = no
          in-funcao-chamadora-rtapi041-aux = "INC"
          lg-simula-chamadora-rtapi041-aux = no
          cd-modalidade-rtapi041-aux       = import-bnfciar.cd-modalidade
          nr-proposta-rtapi041-aux         = nr-proposta-imp-aux
          cd-usuario-rtapi041-aux          = 0
          cd-titular-rtapi041-aux          = cd-titular-aux
          lg-sexo-rtapi041-aux             = import-bnfciar.log-sexo
          cd-grau-parentesco-rtapi041-aux  = import-bnfciar.cd-grau-parentesco
          dt-nascimento-rtapi041-aux       = import-bnfciar.dt-nascimento
          dt-inclusao-plano-rtapi041-aux   = import-bnfciar.dt-inclusao-plano
          lg-importacao-rtapi041-aux       = no
          in-modulo-sistema-rtapi041-aux   = "CG"              
          lg-responsavel-rtapi041-aux      = import-bnfciar.log-respons 
          dt-exclusao-plano-rtapi041-aux   = import-bnfciar.dt-exclusao-plano.

   run rtp/rtapi041.p no-error.
 
   if   error-status:error
   then do: 
          assign lg-relat-erro = yes
                 lg-retorna    = yes.

          if   error-status:num-messages = 0
          then RUN pi-cria-tt-erros("Operador teclou Ctrl-C").
          else RUN pi-cria-tt-erros(substring(error-status:get-message(error-status:num-messages),1,75)).

          return.
        end.
 
   if   lg-erro-rtapi041-aux
   then do:
          assign lg-relat-erro = yes
                 lg-retorna    = yes.
 
          for each tmp-mensa-rtapi041
             where tmp-mensa-rtapi041.in-tipo-mensagem = "E":
 
              RUN pi-cria-tt-erros(if tmp-mensa-rtapi041.ds-mensagem <> ?
                                   then "(rtapi041)" + STRING(tmp-mensa-rtapi041.cd-mensagem-mens) + " " + tmp-mensa-rtapi041.ds-mensagem + " " + tmp-mensa-rtapi041.ds-complemento-mens + " " + tmp-mensa-rtapi041.ds-chave-mens
                                   else "").
          end.
        end.
 
end procedure.


/* -------------- CONSISTE O ORGAO EMISSOR DO DOCUMENTO DE IDENTIFICACAO --- */
procedure valida-orgao-emissor:

    define input parameter  ds-orgao-par as char           no-undo.
    define output parameter lg-erro-par  as log initial no no-undo.

    define variable ds-opcoes-aux as char no-undo.
    
    assign ds-opcoes-aux = "SSP-SECRET.SEGURANCA PUBLICA,"  
                         + "MINISTERIO DA AERONAUTICA,"     
                         + "MINISTERIO DO EXERCITO,"        
                         + "MINISTERIO DA MARINHA,"         
                         + "POLICIA FEDERAL,"               
                         + "CARTEIRA DE IDENTID. CLASSISTA,"
                         + "CONS.REG.DE ADMINISTRACAO,"     
                         + "CONS.REG.DE ASSIST.SOCIAIS,"    
                         + "CONS.REG.DE BIBLIOTECONOMIA,"   
                         + "CONS.REG.DE CONTABILIDADE,"     
                         + "CONS.REG.CORRETORES IMOVEIS,"   
                         + "CONS.REG.ENFERMAGEM,"           
                         + "CONS.REG.ENG.ARQ. E AGRONOMIA," 
                         + "CONS.REG.DE ESTATISTICA,"       
                         + "CONS.REG.DE FARMACIA,"          
                         + "CONS.REG.FISIOT.TERAPIA OCUP.," 
                         + "CONS.REG.DE MEDICINA,"          
                         + "CONS.REG.MEDICINA VETERINARIA," 
                         + "CONS.REG.DE NUTRICAO,"          
                         + "CONS.REG.DE ODONTOLOGIA,"       
                         + "CONS.REG.PROF.RELACOES PUBLIC.,"
                         + "CONS.REG.DE PSICOLOGIA,"        
                         + "CONS.REG.DE QUIMICA,"           
                         + "CONS.REG.REPRES.COMERCIAIS,"    
                         + "ORDEM DOS MUSICOS DO BRASIL,"   
                         + "ORDEM DOS ADVOGADOS DO BRASIL," 
                         + "OUTROS EMISSORES,"              
                         + "DOCUMENTOS ESTRANGEIROS".       

    if lookup(ds-orgao-par,ds-opcoes-aux) = 0
    then assign lg-erro-par = yes.

end procedure.

/* ------------------------------------------------------------------------- */
procedure atual-datas:
 
   for each pro-pla FIELDS (dt-cancelamento dt-fim)  
      where pro-pla.cd-modalidade   = propost.cd-modalidade 
        and pro-pla.nr-proposta     = propost.nr-proposta   
        and pro-pla.dt-cancelamento = propost.dt-libera-doc
            EXCLUSIVE-LOCK QUERY-TUNING (NO-INDEX-HINT):
       assign pro-pla.dt-cancelamento = import-bnfciar.dt-exclusao-plano
              pro-pla.dt-fim          = import-bnfciar.dt-exclusao-plano.
   end.
   
   for each pr-mo-am FIELDS (dt-fim dt-cancelamento) 
      where pr-mo-am.cd-modalidade   = propost.cd-modalidade 
        and pr-mo-am.nr-proposta     = propost.nr-proposta   
        and pr-mo-am.dt-cancelamento = propost.dt-libera-doc
            EXCLUSIVE-LOCK QUERY-TUNING (NO-INDEX-HINT):
       assign pr-mo-am.dt-fim          = import-bnfciar.dt-exclusao-plano
              pr-mo-am.dt-cancelamento = import-bnfciar.dt-exclusao-plano.
   end.                        
 
   for each propunim FIELDS (dt-cancelamento dt-fim) 
      where propunim.cd-modalidade = propost.cd-modalidade 
        and propunim.nr-proposta   = propost.nr-proposta  
            EXCLUSIVE-LOCK QUERY-TUNING (NO-INDEX-HINT):
       if propunim.dt-cancelamento = propunim.dt-fim
       then assign propunim.dt-cancelamento = import-bnfciar.dt-exclusao-plano
                   propunim.dt-fim          = import-bnfciar.dt-exclusao-plano.
   end.
 
end procedure.

/* ------------------------------------------------------------------------- */
PROCEDURE consiste-modulos-benef:
    
    FOR EACH import-modul-bnfciar EXCEPT (cod-livre-1 cod-livre-2 cod-livre-3 cod-livre-4 cod-livre-5 cod-livre-6 cod-livre-7 cod-livre-8 cod-livre-9 
                                          cod-livre-10 num-livre-1 num-livre-2 num-livre-3 num-livre-4 num-livre-5 num-livre-6 num-livre-7 num-livre-8 
                                          num-livre-9 num-livre-10 val-livre-1 val-livre-2 val-livre-3 val-livre-4 val-livre-5 val-livre-6 val-livre-7 
                                          val-livre-8 val-livre-9 val-livre-10 log-livre-1 log-livre-2 log-livre-3 log-livre-4 log-livre-5 log-livre-6 
                                          log-livre-7 log-livre-8 log-livre-9 log-livre-10 dat-livre-1 dat-livre-2 dat-livre-3 dat-livre-4 dat-livre-5 
                                          dat-livre-6 dat-livre-7 dat-livre-8 dat-livre-9 dat-livre-10)
       WHERE import-modul-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar 
         AND import-modul-bnfciar.num-livre-1         = import-bnfciar.num-seqcial-control NO-LOCK:

        FOR FIRST mod-cob FIELDS (in-identifica-modulo)
            WHERE mod-cob.cd-modulo = import-modul-bnfciar.cdn-modul NO-LOCK:
        END.
        if   not avail mod-cob
        then do:
               RUN pi-cria-tt-erros2("Modulo nao Cadastrado", "Modulo: " + string(import-modul-bnfciar.cdn-modul,"999")).
        
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
               NEXT.
             END.

        FOR FIRST pro-pla FIELDS (dt-inicio dt-cancelamento cd-modulo lg-cobertura-obrigatoria)
            where pro-pla.cd-modalidade = import-bnfciar.cd-modalidade
              and pro-pla.nr-proposta   = propost.nr-proposta
              and pro-pla.cd-modulo     = import-modul-bnfciar.cdn-modul NO-LOCK:
        END.
        
        if not avail pro-pla
        then do:
               RUN pi-cria-tt-erros2("Modulo nao cadastrado para a proposta", "Modulo: " + string(import-modul-bnfciar.cdn-modul)).
        
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
               NEXT.
             end.

        FOR first pla-mod FIELDS (lg-modulo-agregado lg-grava-automatico)
            where pla-mod.cd-modalidade = propost.cd-modalidade  
              and pla-mod.cd-plano      = propost.cd-plano       
              and pla-mod.cd-tipo-plano = propost.cd-tipo-plano  
              and pla-mod.cd-modulo     = import-modul-bnfciar.cdn-modul NO-LOCK:
        END.

        IF NOT AVAIL pla-mod
        THEN DO:
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
               RUN pi-cria-tt-erros2("Modulo nao cadastrado para a Estrutura", "Modulo: " + string(import-modul-bnfciar.cdn-modul)). 
               NEXT.
             END.
        
        if   import-modul-bnfciar.dat-inic = ?
        then do:
               RUN pi-cria-tt-erros("Data de inicio do Modulo Invalida (nula)").
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
             end.
        ELSE DO:
               if   import-modul-bnfciar.dat-inic < propost.dt-proposta
               then do:
                      IF import-modul-bnfciar.dat-inic <> ?
                      THEN char-aux1 = STRING(import-modul-bnfciar.dat-inic,"99/99/9999").
                      ELSE char-aux1 = "nulo".
                      
                      IF propost.dt-proposta <> ?
                      THEN char-aux2 = STRING(propost.dt-proposta,"99/99/9999").
                      ELSE char-aux2 = "nulo".
                      
                      RUN pi-cria-tt-erros2("Data de Inicio do Modulo menor que data da Proposta",
                                            "Modulo: " + STRING(import-modul-bnfciar.cdn-modul) +
                                            " Inicio modulo: " + char-aux1 + 
                                            " Inicio proposta: " + char-aux2).
                      
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               if import-modul-bnfciar.dat-inic < import-bnfciar.dt-inclusao-plano
               then do:
                      IF import-modul-bnfciar.dat-inic <> ?
                      THEN char-aux1 = STRING(import-modul-bnfciar.dat-inic,"99/99/9999").
                      ELSE char-aux1 = "nulo".
                      
                      IF import-bnfciar.dt-inclusao-plano <> ?
                      THEN char-aux2 = STRING(import-bnfciar.dt-inclusao-plano,"99/99/9999").
                      ELSE char-aux2 = "nulo".

                       RUN pi-cria-tt-erros2("Data de inicio do modulo nao pode ser inferior a inclusao do beneficiario",
                                             "Modulo: " + STRING(import-modul-bnfciar.cdn-modul) +
                                             " Inicio modulo: " + char-aux1 + 
                                             " Inicio benef: " + char-aux2).

                       assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               if import-modul-bnfciar.dat-inic < pro-pla.dt-inicio
               then do:
                      IF import-modul-bnfciar.dat-inic <> ?
                      THEN char-aux1 = STRING(import-modul-bnfciar.dat-inic,"99/99/9999").
                      ELSE char-aux1 = "nulo".

                      IF pro-pla.dt-inicio <> ?
                      THEN char-aux2 = STRING(pro-pla.dt-inicio,"99/99/9999").
                      ELSE char-aux2 = "nulo".

                      RUN pi-cria-tt-erros2("Data de inicio do modulo opcional do beneficiario nao pode ser inferior a data de inicio do modulo da proposta"),
                                            "Modulo: " + STRING(import-modul-bnfciar.cdn-modul) +
                                            " Inicio modulo benef: " + char-aux1 +
                                            " Inicio modulo proposta: " + char-aux2).
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
            END.
        
        if  import-modul-bnfciar.dat-fim = ?
        THEN DO:
               IF  import-modul-bnfciar.cdn-motiv-cancel <> 0
               AND import-modul-bnfciar.cdn-motiv-cancel <> ?
               then do:
                      RUN pi-cria-tt-erros2("Codigo do motivo de cancelamento do modulo nao deve ser informado", "Motivo recebido: " + STRING(import-modul-bnfciar.cdn-motiv-cancel)).
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end. 

               if  pro-pla.dt-cancelamento <> ? 
               then do:
                      RUN pi-cria-tt-erros2("Proposta com modulo cancelado e beneficiario com modulo ativo.", "Modulo:" + string(pro-pla.cd-modulo)).
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
             END.
        ELSE DO:
               IF import-modul-bnfciar.cdn-motiv-cancel  = ?
               or import-modul-bnfciar.cdn-motiv-cancel  = 0
               then do:
                      RUN pi-cria-tt-erros2("Codigo do motivo de cancelamento do modulo deve ser informado","Modulo: " + STRING(import-modul-bnfciar.cdn-modul)).
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               FOR FIRST motcange FIELDS (in-tipo-obito-ans)
                   where motcange.in-entidade = "MC"
                     and motcange.cd-motivo   = import-modul-bnfciar.cdn-motiv-cancel
                     and motcange.log-4       = no /* Registro nao excluido */ NO-LOCK:
               END.

               IF NOT AVAIL motcange
               then do:
                      RUN pi-cria-tt-erros2("Codigo motivo de cancelamento do modulo nao cadastrado.", 
                                            "Modulo: " + STRING(import-modul-bnfciar.cdn-modul) + " Motivo: " + STRING(import-modul-bnfciar.cdn-motiv-cancel)).
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
               else IF motcange.in-tipo-obito-ans > 0 
                    then do:
                           RUN pi-cria-tt-erros("Codigo motivo de cancelamento do modulo nao pode indicar obito").
                           assign lg-relat-erro  = yes
                                  lg-modulo-erro = yes.
                         end. 

               if import-modul-bnfciar.dat-fim > import-bnfciar.dt-exclusao-plano
               then do:
                      IF import-modul-bnfciar.dat-fim <> ?
                      THEN char-aux1 = STRING(import-modul-bnfciar.dat-fim).
                      ELSE char-aux1 = "nulo".

                      IF import-bnfciar.dt-exclusao-plano <> ?
                      THEN char-aux2 = STRING(import-bnfciar.dt-exclusao-plano).
                      ELSE char-aux2 = "nulo".
                      
                      IF import-modul-bnfciar.cdn-modul <> ?
                      THEN char-aux3 = string(import-modul-bnfciar.cdn-modul).
                      ELSE char-aux3 = "nulo".

                      RUN pi-cria-tt-erros2("Data de cancelamento do Modulo nao pode ser superior ao cancelamento do beneficiario.",
                                            "Canc.Modulo: " + char-aux1 +
                                           ". Canc.Benef: " + char-aux2 + ". Modulo: " + char-aux3).
               
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
               
               if   import-modul-bnfciar.dat-fim < import-modul-bnfciar.dat-inic
               then do:
                      IF import-modul-bnfciar.dat-fim <> ?
                      THEN char-aux1 = string(import-modul-bnfciar.dat-fim,"99/99/9999").
                      ELSE char-aux1 = "nulo".

                      IF import-modul-bnfciar.dat-inic <> ?
                      THEN char-aux2 = string(import-modul-bnfciar.dat-ini,"99/99/9999").
                      ELSE char-aux2 = "nulo".

                      RUN pi-cria-tt-erros2("Data de cancelamento do Modulo do Beneficiario nao pode ser anterior a sua inclusao.",
					          "Cancelamento Modulo: " + char-aux1 + ". Inclusao Modulo: " + char-aux2 + ". Modulo: " + string(import-modul-bnfciar.cdn-modul)).
               
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               if pro-pla.dt-cancelamento < import-modul-bnfciar.dat-fim
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      RUN pi-cria-tt-erros("Cancelamento de modulo da proposta inferior a cancelamento do modulo do beneficiario. Modulo:" + string(pro-pla.cd-modulo)).
                    end.
             END.
                 
        if   import-modul-bnfciar.aa-ult-fat-period <> 0
        then do:
               if   import-modul-bnfciar.aa-ult-fat-period < year(import-modul-bnfciar.dat-inic)
               then do:
                      IF import-modul-bnfciar.aa-ult-fat-period <> ?
                      THEN char-aux1 = string(import-modul-bnfciar.aa-ult-fat-period).
                      ELSE char-aux1 = "nulo".

                      IF import-modul-bnfciar.dat-inic <> ?
                      THEN char-aux2 = STRING(import-modul-bnfciar.dat-inic).
                      ELSE char-aux2 = "nulo".

			 if import-modul-bnfciar.cdn-modul <> ?
 			 then char-aux3 = string(import-modul-bnfciar.cdn-modul).
 			 else char-aux3 = "nulo".
					  
                      RUN pi-cria-tt-erros2("Ano do faturamento do modulo menor que sua data de inclusao.",
					          "Modulo: " + char-aux3 + ". Ano fat. modulo: " + char-aux1 + ". Data inclusao: " + char-aux2).
        
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
                    
               IF dt-ignorar-validacao-aux >= TODAY
               THEN DO:
                       FOR FIRST b-import-modul-bnfciar
                           WHERE b-import-modul-bnfciar.num-seqcial         = import-modul-bnfciar.num-seqcial 
                             AND b-import-modul-bnfciar.num-seqcial-bnfciar = import-modul-bnfciar.num-seqcial-bnfciar EXCLUSIVE-LOCK:
                              
                              ASSIGN b-import-modul-bnfciar.aa-ult-fat-period   = import-bnfciar.aa-ult-fat-period
                                     b-import-modul-bnfciar.num-mes-ult-faturam = import-bnfciar.num-mes-ult-faturam.

                       END.
                       VALIDATE b-import-modul-bnfciar.
                       RELEASE  b-import-modul-bnfciar.
               END.
               ELSE DO:
                       if   import-modul-bnfciar.aa-ult-fat-period   =  year(import-modul-bnfciar.dat-inic)
                       and  import-modul-bnfciar.num-mes-ult-faturam < month(import-modul-bnfciar.dat-inic)
                       then do:
                              IF import-modul-bnfciar.aa-ult-fat-period <> ?
                              THEN char-aux1 = string(import-modul-bnfciar.aa-ult-fat-period).
                              ELSE char-aux1 = "nulo".
                              
                              IF import-modul-bnfciar.num-mes-ult-faturam <> ?
                              THEN char-aux2 = STRING(import-modul-bnfciar.num-mes-ult-faturam).
                              ELSE char-aux2 = "nulo".
        
                              IF month(import-modul-bnfciar.dat-inic) <> ?
                              THEN char-aux3 = STRING(month(import-modul-bnfciar.dat-inic)).
                              ELSE char-aux3 = "nulo".
        
                              RUN pi-cria-tt-erros2("Mes do faturamento do modulo menor que a data de inclusao do modulo.",
                                                    "Modulo: " + string(import-modul-bnfciar.cdn-modul) + 
                                                    ". Faturamento: " + char-aux1 + "/" + char-aux2 + 
                                                    ". Data inicio: " + char-aux1 + "/" + char-aux3).
                
                              assign lg-relat-erro  = yes
                                     lg-modulo-erro = yes.
                            end.
                
                       if   import-modul-bnfciar.dat-fim = ?
                       and (import-modul-bnfciar.aa-ult-fat-period   <> import-bnfciar.aa-ult-fat-period
                        or  import-modul-bnfciar.num-mes-ult-faturam <> import-bnfciar.num-mes-ult-faturam)
                       then do:
                              IF import-modul-bnfciar.aa-ult-fat-period <> ?
                              THEN char-aux1 = string(import-modul-bnfciar.aa-ult-fat-period).
                              ELSE char-aux1 = "nulo".
                              
                              IF import-bnfciar.aa-ult-fat-period <> ?
                              THEN char-aux2 = string(import-bnfciar.aa-ult-fat-period).
                              ELSE char-aux2 = "nulo".
        
                              IF import-modul-bnfciar.num-mes-ult-faturam <> ?
                              THEN char-aux3 = STRING(import-modul-bnfciar.num-mes-ult-faturam).
                              ELSE char-aux3 = "nulo".
                              
                              IF import-bnfciar.num-mes-ult-faturam <> ?
                              THEN char-aux4 = STRING(import-bnfciar.num-mes-ult-faturam).
                              ELSE char-aux4 = "nulo".
                              
                              RUN pi-cria-tt-erros2("Data do faturamento do modulo difere da data do faturamento do beneficiario.", 
                                                    "Modulo: " + string(import-modul-bnfciar.cdn-modul) + 
                                                    ". Faturamento modulo: " + char-aux1 + "/" + char-aux3 +
                                                    ". Faturamento Beneficiario: " + char-aux2 + "/" + char-aux4).
                
                              assign lg-relat-erro  = yes
                                     lg-modulo-erro = yes.
                            end.
        
                       if  import-modul-bnfciar.num-mes-ult-faturam <> 0 
                       then do:
                              /* Comentado 30/06/16 */
                              /*if import-modul-bnfciar.aa-ult-fat-period < year(import-modul-bnfciar.dat-inic)
                              then do:
                                     RUN pi-cria-tt-erros("Data do ultimo faturamento do modulo difere da data de Inicio do modulo").
                                     assign lg-relat-erro  = yes.
                                   end.
                       
                              if  import-modul-bnfciar.aa-ult-fat-period   =  year(import-modul-bnfciar.dat-inic)
                              and import-modul-bnfciar.num-mes-ult-faturam < month(import-modul-bnfciar.dat-inic)
                              then do:
                                     RUN pi-cria-tt-erros("Data do ultimo faturamento do modulo difere da data de Inicio do modulo").
                                     assign lg-relat-erro  = yes.
                                   end.*/
                            end.
               END.
             end.
        
        if  ti-pl-sa.lg-usa-padrao-cobertura
        then do:
               if (mod-cob.in-identifica-modulo = "S" and  pla-mod.lg-grava-automatico)
               or pla-mod.lg-modulo-agregado
               then.
               else do:
                      IF NOT CAN-FIND (FIRST propcopa use-index propcop1
                                       where propcopa.cd-modalidade       = import-bnfciar.cd-modalidade  
                                         and propcopa.nr-proposta         = propost.nr-proposta
                                         and propcopa.cd-padrao-cobertura = import-bnfciar.cd-padrao-cob  
                                         and propcopa.cd-modulo           = import-modul-bnfciar.cdn-modul)
                      THEN DO:
                            /* if (import-bnfciar.dt-exclusao-plano = ?  and
                                 import-modul-bnfciar.dat-fim <> ?)
                             or (import-bnfciar.dt-exclusao-plano <> ? and
                                 import-bnfciar.dt-exclusao-plano <> import-modul-bnfciar.dat-fim and 
                                 import-modul-bnfciar.dat-fim     <  import-bnfciar.dt-exclusao-plano)
                             then.
                             else do:
                                    assign lg-relat-erro  = yes
                                           lg-modulo-erro = yes.
                                    RUN pi-cria-tt-erros("Modulo nao cadastrado para o padrao de cobertura. Modulo: " + string(import-modul-bnfciar.cdn-modul)).
                                  end.*/
                           END.
                      ELSE do:
                             if  import-bnfciar.dt-exclusao-plano = ?
                             and import-modul-bnfciar.dat-fim    <> ?
                             then do:
                                    assign lg-relat-erro  = yes
                                           lg-modulo-erro = yes.
                                    RUN pi-cria-tt-erros("Modulo cancelado para padrao ativo").
                                 end.
                           end.
                    end.               
                
               if pro-pla.lg-cobertura-obrigatoria = no
               and in-classif = 1
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      RUN pi-cria-tt-erros("Indicador Cobertura Obrigatoria invalido para este parametro de importacao").
                    end.

               if pro-pla.lg-cobertura-obrigatoria = yes
               and in-classif = 2
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      RUN pi-cria-tt-erros("Indicador Cobertura Opcional invalido para este parametro de importacao").
                    end.
             end.
    END.

END PROCEDURE.

PROCEDURE consiste-repasse-benef:

    FOR EACH import-negociac-bnfciar FIELDS (cd-unidade-destino dt-intercambio num-mes-ult-repas num-ano-ult-repas dat-saida)
       WHERE import-negociac-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar NO-LOCK:

        /* ----------------------------------------------- LEITURA NEGOCIACAO --- */
        FOR FIRST propunim FIELDS (aa-ult-rep mm-ult-rep)
            where propunim.cd-modalidade = import-bnfciar.cd-modalidade
              and propunim.nr-proposta   = propost.nr-proposta
              and propunim.cd-unimed     = import-negociac-bnfciar.cd-unidade-destino NO-LOCK:
        END.
        if not avail propunim
        then do:
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
               run pi-cria-tt-erros("Unidade de repasse nao cadastrada para Esta Proposta").
               NEXT.
             end.

        /* ------------------------------------------------ CODIGO DA UNIDADE --- */
        if   import-negociac-bnfciar.cd-unidade-destino = 0
        then do:
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
               run pi-cria-tt-erros("Unidade destino do Repasse Zerada").
             end.
        
        /* --------------------------------------------------- LEITURA UNIMED --- */
        IF NOT CAN-FIND (FIRST unimed where unimed.cd-unimed = import-negociac-bnfciar.cd-unidade-destino)
        then do:
               assign lg-relat-erro  = yes
                      lg-modulo-erro = yes.
               run pi-cria-tt-erros("Unidade destino do Repasse Nao Cadastrada").
             end.

        /* ---------------------------------------------------------------------- */
        if  import-bnfciar.dt-exclusao-plano <> ?
        THEN DO:
               IF import-negociac-bnfciar.dt-intercambio > import-bnfciar.dt-exclusao-plano
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      run pi-cria-tt-erros("Data de Intercambio maior que a data de exclusao do Beneficiario").
                    end.

               IF import-negociac-bnfciar.dat-saida > import-bnfciar.dt-exclusao-plano
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      run pi-cria-tt-erros("Data de saida do Repasse maior que a data de exclusao do Beneficiario").
                    end.
             END.

        /* ---------------------------------------------------------------------- */
        IF import-bnfciar.dt-inclusao-plano <> ?
        THEN DO:
               if import-negociac-bnfciar.dt-intercambio < import-bnfciar.dt-inclusao-plano
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      run pi-cria-tt-erros("Data de Intercambio maior que a data de inclusao do Beneficiario").
                    end.
                   
               if   import-negociac-bnfciar.dat-saida < import-bnfciar.dt-inclusao-plano
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      run pi-cria-tt-erros("Data de saida do Repasse menor que a data de inclusao do Beneficiario").
                    end.
             END.
        
        /* ---------------------------------------------------------------------- */
        IF import-negociac-bnfciar.dat-saida = ?
        THEN DO:
               if import-bnfciar.num-mes-ult-faturam <> import-negociac-bnfciar.num-mes-ult-repas
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      run pi-cria-tt-erros("Mes do ultimo repasse calculado Invalido por diferir do Ultimo mes faturado do Benef.").
                    end.

               if import-bnfciar.aa-ult-fat-period <> import-negociac-bnfciar.num-ano-ult-repas
               then do:
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                      run pi-cria-tt-erros("Ano do ultimo repasse calculado invalido por diferir do ultimo ano faturado do Benef.").
                    end.

               if   import-negociac-bnfciar.num-ano-ult-repas <> 0
               and  import-negociac-bnfciar.num-mes-ult-repas <> 0
               then do:
                      if import-negociac-bnfciar.num-ano-ult-repas <> propunim.aa-ult-rep
                      or import-negociac-bnfciar.num-mes-ult-repas <> propunim.mm-ult-rep                
                      then do:
                             assign lg-relat-erro  = yes
                                    lg-modulo-erro = yes.
                             run pi-cria-tt-erros("Ultimo repasse calculado (" + STRING(import-negociac-bnfciar.num-mes-ult-repas) 
                                                  + "/" + STRING(import-negociac-bnfciar.num-ano-ult-repas) 
                                                  + ") invalido por diferir do ultimo repasse calculado para negociacao(" + 
                                                  STRING(propunim.mm-ult-rep) + "/" + STRING(propunim.aa-ult-rep) + ")").
                           end.
                    end.
             END.

        ASSIGN lg-registro-repasse-aux = yes.

    END.

END PROCEDURE.

PROCEDURE consiste-repas-atend:

    FOR EACH import-atendim-bnfciar WHERE import-atendim-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar NO-LOCK:

        /* ------------------------------------------------ CODIGO DA UNIDADE --- */
        if   import-atendim-bnfciar.cd-unidade-destino = 0
        then do:
               RUN pi-cria-tt-erros("Unidade Atendimento do Repasse Zerada").
        
               assign lg-relat-erro = yes
                      lg-modulo-erro    = yes.
             end.
        
        /* --------------------------------------------------- LEITURA UNIMED --- */
        IF NOT CAN-FIND (FIRST unimed where unimed.cd-unimed = import-atendim-bnfciar.cd-unidade-destino )
        then do:
               RUN pi-cria-tt-erros("Unidade Atendimento do Repasse Nao Cadastrada").
        
               assign lg-relat-erro = yes
                      lg-modulo-erro    = yes.
             end.
        
        /* ---------------------------------------------------------------------- */
        find first import-negociac-bnfciar where import-negociac-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar no-lock no-error.
        
        IF import-atendim-bnfciar.dat-intercam-atendim < import-negociac-bnfciar.dt-intercambio
        then do:
               RUN pi-cria-tt-erros("Data de Atendimento maior que a data de intercambio do Beneficiario").
        
               assign lg-relat-erro = yes
                      lg-modulo-erro    = yes.
             end.
        
        /* ---------------------------------------------------------------------- */
        if import-bnfciar.dt-exclusao-plano <> ?
        THEN DO:
               if import-atendim-bnfciar.dat-intercam-atendim  > import-bnfciar.dt-exclusao-plano
               then do:
                      RUN pi-cria-tt-erros("Data de Atendimento maior que a data de exclusao do Beneficiario").
               
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               if import-atendim-bnfciar.dat-saida-atendim > import-bnfciar.dt-exclusao-plano
               then do:
                      RUN pi-cria-tt-erros("Data de saida do atendimento  maior que a data de exclusao do Beneficiario").
               
                      assign lg-relat-erro = yes
                             lg-modulo-erro    = yes.           
                    end.
             END.
        
        /* ---------------------------------------------------------------------- */
        IF import-atendim-bnfciar.dat-saida-atendim = ?
        THEN DO:
               if import-negociac-bnfciar.dat-saida <> ?
               then do:
                      RUN pi-cria-tt-erros("Existe unidade de atendimento ativa para a unidade de negociacao cancelada").
               
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes. 
                    end. 
             END.
        ELSE if   import-atendim-bnfciar.dat-saida-atendim < import-bnfciar.dt-inclusao-plano
             then do:
                    RUN pi-cria-tt-erros("Data de saida do Atendimento menor que a data de inclusao do Beneficiario").
             
                    assign lg-relat-erro  = yes
                           lg-modulo-erro = yes. 
                  end.
                    
    END.

END PROCEDURE.

PROCEDURE consiste-padrao-benef:

    def var lg-procedimento-aux as log no-undo.

    FOR EACH import-cobert-bnfciar WHERE import-cobert-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar NO-LOCK:

        if   import-cobert-bnfciar.cdn-modulo = 0
        then do:
               RUN pi-cria-tt-erros("Modulo de cobertura nao informado").
               assign lg-relat-erro = yes.
             end.
        
        if   import-cobert-bnfciar.in-tipo-movimento <> "P"
        and  import-cobert-bnfciar.in-tipo-movimento <> "I"
        then do:
               RUN pi-cria-tt-erros("Tipo do movimento invalido").
               assign lg-relat-erro = yes.                           
             end.
        else if import-cobert-bnfciar.in-tipo-movimento = "P"
             then assign lg-procedimento-aux = yes.
             else assign lg-procedimento-aux = no.

        IF lg-procedimento-aux
        THEN DO:
               if import-cobert-bnfciar.cd-proc-insu = 0
               then do:
                      RUN pi-cria-tt-erros("Codigo do movimento invalido").
                      assign lg-relat-erro = yes.                    
                    end.
               
               if int(import-cobert-bnfciar.cod-tip-insumo) <> 0 
               then do:
                      RUN pi-cria-tt-erros("Tipo de insumo deve ser zero para procedimento").
                      assign lg-relat-erro = yes.                    
                    end.

                IF NOT CAN-FIND (FIRST ambproce 
                                 where ambproce.cd-esp-amb        = int(substr(string(import-cobert-bnfciar.cd-proc-insu,"99999999"),1,2))
                                   and ambproce.cd-grupo-proc-amb = int(substr(string(import-cobert-bnfciar.cd-proc-insu,"99999999"),3,2))
                                   and ambproce.cd-procedimento   = int(substr(string(import-cobert-bnfciar.cd-proc-insu,"99999999"),5,3))
                                   and ambproce.dv-procedimento   = int(substr(string(import-cobert-bnfciar.cd-proc-insu,"99999999"),8,1)))
                then do:
                       RUN pi-cria-tt-erros("Procedimento nao cadastrado").
                       assign lg-relat-erro = yes.
                     end.
             END.
        else if import-cobert-bnfciar.cd-proc-insu <> 0
             then do:
                    IF NOT CAN-FIND (FIRST tipoinsu where tipoinsu.cd-tipo-insumo = int(import-cobert-bnfciar.cod-tip-insumo))
                    then do:
                           RUN pi-cria-tt-erros("Tipo de insumo nao cadastrado").
                           assign lg-relat-erro = yes.
                         end.
        
                    IF NOT CAN-FIND (FIRST insumos 
                                     where insumos.cd-tipo-insumo = int(import-cobert-bnfciar.cod-tip-insumo)
                                       and insumos.cd-insumo      = import-cobert-bnfciar.cd-proc-insu )
                    then do:
                           RUN pi-cria-tt-erros("Insumo nao cadastrado").
                           assign lg-relat-erro = yes.
                         end.
                  end. 
        
        if   string(import-cobert-bnfciar.cdn-tab-preco) = ""  
        then do:
               RUN pi-cria-tt-erros("Tabela de moedas e carencias invalida").
               assign lg-relat-erro = yes.                              
             end.
        
        if   import-cobert-bnfciar.in-carencia <> 1
        and  import-cobert-bnfciar.in-carencia <> 2
        and  import-cobert-bnfciar.in-carencia <> 5
        then do:
               RUN pi-cria-tt-erros("Indicador de carencia invalido").
               assign lg-relat-erro = yes.                  
             end.
        
        if   import-cobert-bnfciar.dat-inicial = ?      
        then do:
               RUN pi-cria-tt-erros("Data de inicio invalida").
               assign lg-relat-erro = yes.                        
             end.


        if propost.cd-sit-propost > 5 
        then do:
               /* ---------------------------- VERIFICA COBERTURA PARA O MODULO --- */
               FOR first pro-pla FIELDS (lg-cobertura-obrigatoria) use-index pro-pla3 
                   where pro-pla.cd-modalidade   = import-bnfciar.cd-modalidade
                     and pro-pla.nr-proposta     = propost.nr-proposta  
                     and pro-pla.cd-modulo       = import-cobert-bnfciar.cdn-modulo 
                     and pro-pla.dt-cancelamento = ?
                     and pro-pla.dt-inicio      <= today
                         NO-LOCK.
               END.
               if not avail pro-pla
               then FOR first pro-pla FIELDS (lg-cobertura-obrigatoria) use-index pro-pla3
                        where pro-pla.cd-modalidade    = import-bnfciar.cd-modalidade
                          and pro-pla.nr-proposta      = propost.nr-proposta  
                          and pro-pla.cd-modulo        = import-cobert-bnfciar.cdn-modulo 
                          and pro-pla.dt-cancelamento <> ?
                          and pro-pla.dt-cancelamento >= today
                          and pro-pla.dt-inicio       <= today
                              NO-LOCK.
                    END.
             end.
        else do:
               /* ---------------------------- VERIFICA COBERTURA PARA O MODULO --- */                 
               FOR first pro-pla FIELDS (lg-cobertura-obrigatoria) use-index pro-pla3 
                   where pro-pla.cd-modalidade   = import-bnfciar.cd-modalidade            
                     and pro-pla.nr-proposta     = propost.nr-proposta              
                     and pro-pla.cd-modulo       = import-cobert-bnfciar.cdn-modulo                       
                         NO-LOCK.       
               END.
               if not avail pro-pla                                                                    
               then FOR first pro-pla FIELDS (lg-cobertura-obrigatoria) use-index pro-pla3 
                        where pro-pla.cd-modalidade = import-bnfciar.cd-modalidade      
                          and pro-pla.nr-proposta   = propost.nr-proposta        
                          and pro-pla.cd-modulo     = import-cobert-bnfciar.cdn-modulo                 
                              NO-LOCK.
                    END.
             end.
        
        if not avail pro-pla
        then do:
               RUN pi-cria-tt-erros("Proposta sem cobertura para este modulo").
               assign lg-relat-erro = yes.  
             end.

        if import-bnfciar.dt-exclusao-plano <> ?
        then do:
               if import-cobert-bnfciar.dat-cancel = ?
               then do:
                      RUN pi-cria-tt-erros("Beneficiario com data de exclusao. Deve ser informada data de cancelamento").
                      assign lg-relat-erro = yes.
                    end.
        
               if import-cobert-bnfciar.dat-cancel > import-bnfciar.dt-exclusao-plano 
               then do:
                      RUN pi-cria-tt-erros("Data cancelamento nao pode ser maior que data exclusao beneficiaro").
                      assign lg-relat-erro = yes.
                    end.
             end.
        
        if  import-cobert-bnfciar.dat-cancel <> ?
        and import-cobert-bnfciar.dat-cancel <= import-cobert-bnfciar.dat-inicial
        then do: 
               RUN pi-cria-tt-erros("Data de Cancelamento deve ser maior do que a Data Inicial").
               assign lg-relat-erro = yes.
             end.

        if import-cobert-bnfciar.in-carencia = 1
        then do:
               if lg-procedimento-aux
               then do:
                      /* Veririca cobertura no produto */
                      IF CAN-FIND (FIRST pl-mo-am 
                                   where pl-mo-am.cd-modalidade = propost.cd-modalidade     
                                     and pl-mo-am.cd-plano      = propost.cd-plano          
                                     and pl-mo-am.cd-tipo-plano = propost.cd-tipo-plano     
                                     and pl-mo-am.cd-modulo     = import-cobert-bnfciar.cdn-modulo                
                                     and pl-mo-am.cd-amb        = import-cobert-bnfciar.cd-proc-insu)
                      then do:        
                             /* Verifica restricao de cobertura na proposta */
                             for each pr-mo-am FIELDS (dt-inicio dt-cancelamento)
                                where pr-mo-am.cd-modalidade          = propost.cd-modalidade
                                  and pr-mo-am.nr-proposta            = propost.nr-proposta
                                  and pr-mo-am.cd-modulo              = import-cobert-bnfciar.cdn-modulo
                                  and pr-mo-am.cd-amb                 = import-cobert-bnfciar.cd-proc-insu
                                  and pr-mo-am.lg-acrescimo-cobertura = no /* Restricao */
                                      no-lock:
                            
                                 if  (pr-mo-am.dt-inicio <= import-cobert-bnfciar.dat-inicial and pr-mo-am.dt-cancelamento  = ?)
                                 or  (pr-mo-am.dt-inicio <= import-cobert-bnfciar.dat-inicial and pr-mo-am.dt-cancelamento <> ? and  pr-mo-am.dt-cancelamento >= import-cobert-bnfciar.dat-inicial)
                                 then leave.
                             end.
        
                             if not avail pr-mo-am
                             then do:
                                    RUN pi-cria-tt-erros("Beneficiario ja possui cobertura para o procedimento").
                                    assign lg-relat-erro = yes.
                                    NEXT.
                                  end.
                           end.
                      else do:
                             /* Verifica acrescimo de cobertura na proposta */
                             for each pr-mo-am FIELDS (dt-inicio dt-cancelamento)
                                where pr-mo-am.cd-modalidade          = propost.cd-modalidade
                                  and pr-mo-am.nr-proposta            = propost.nr-proposta
                                  and pr-mo-am.cd-modulo              = import-cobert-bnfciar.cdn-modulo
                                  and pr-mo-am.cd-amb                 = import-cobert-bnfciar.cd-proc-insu
                                  and pr-mo-am.lg-acrescimo-cobertura = yes /* Acrescimo */
                                      no-lock:
                             
                                 if  (pr-mo-am.dt-inicio       <= import-cobert-bnfciar.dat-inicial
                                 and  pr-mo-am.dt-cancelamento  = ?)
                                 or  (pr-mo-am.dt-inicio       <= import-cobert-bnfciar.dat-inicial
                                 and  pr-mo-am.dt-cancelamento <> ?
                                 and  pr-mo-am.dt-cancelamento >= import-cobert-bnfciar.dat-inicial)
                                 then leave.
                                     
                             end.
                             
                             if avail pr-mo-am
                             then do:
                                    RUN pi-cria-tt-erros("Beneficiario ja possui cobertura para o procedimento").
                                    assign lg-relat-erro = yes.
                                    NEXT.
                                  end.
                           end.
                    end.
               else do:
                      find partinsu where partinsu.cd-modalidade  = propost.cd-modalidade             
                                      and partinsu.cd-plano       = propost.cd-plano                  
                                      and partinsu.cd-tipo-plano  = propost.cd-tipo-plano             
                                      and partinsu.cd-modulo      = import-cobert-bnfciar.cdn-modulo                        
                                      and partinsu.cd-tipo-insumo = int(import-cobert-bnfciar.cod-tip-insumo)
                                      and partinsu.cd-insumo      = import-cobert-bnfciar.cd-proc-insu              
                                          no-lock no-error.                                           
                      if not available partinsu                                                       
                      then find partinsu where partinsu.cd-modalidade  = propost.cd-modalidade   
                                           and partinsu.cd-plano       = propost.cd-plano        
                                           and partinsu.cd-tipo-plano  = propost.cd-tipo-plano   
                                           and partinsu.cd-modulo      = import-cobert-bnfciar.cdn-modulo              
                                           and partinsu.cd-tipo-insumo = int(import-cobert-bnfciar.cod-tip-insumo)
                                           and partinsu.cd-insumo      = 0    
                                               no-lock no-error.                                 
                           if not available partinsu                                             
                           then find partinsu where partinsu.cd-modalidade  = propost.cd-modalidade
                                                and partinsu.cd-plano       = propost.cd-plano     
                                                and partinsu.cd-tipo-plano  = propost.cd-tipo-plano
                                                and partinsu.cd-modulo      = import-cobert-bnfciar.cdn-modulo           
                                                and partinsu.cd-tipo-insumo = 0
                                                and partinsu.cd-insumo      = 0                    
                                                    no-lock no-error.                              
                      if available partinsu                      
                      then do:
                             RUN pi-cria-tt-erros("Beneficiario ja possui cobertura para o insumo").
                             assign lg-relat-erro = yes.
                             NEXT.
                           end.
                    end.
             end.

       if import-cobert-bnfciar.in-carencia = 2  /* Restricao */                                                                        
       or import-cobert-bnfciar.in-carencia = 5  /* Acrescimo */
       then do:                                                                                        
              if lg-procedimento-aux                                                                   
              then do:               
                     /* Verifica se tem cobertura para restringir ou sobrepor */
                     IF NOT CAN-FIND (FIRST pl-mo-am 
                                      where pl-mo-am.cd-modalidade = propost.cd-modalidade                
                                        and pl-mo-am.cd-plano      = propost.cd-plano                     
                                        and pl-mo-am.cd-tipo-plano = propost.cd-tipo-plano                
                                        and pl-mo-am.cd-modulo     = import-cobert-bnfciar.cdn-modulo                           
                                        and pl-mo-am.cd-amb        = import-cobert-bnfciar.cd-proc-insu)
                     then do:       
                            /* Verifica acrescimo de cobertura na proposta */
                            for each pr-mo-am FIELDS (dt-inicio dt-cancelamento)
                               where pr-mo-am.cd-modalidade          = propost.cd-modalidade
                                 and pr-mo-am.nr-proposta            = propost.nr-proposta
                                 and pr-mo-am.cd-modulo              = import-cobert-bnfciar.cdn-modulo
                                 and pr-mo-am.cd-amb                 = import-cobert-bnfciar.cd-proc-insu
                                 and pr-mo-am.lg-acrescimo-cobertura = yes /* Acrescimo */
                                     no-lock:
                            
                                if  (pr-mo-am.dt-inicio       <= import-cobert-bnfciar.dat-inicial
                                and  pr-mo-am.dt-cancelamento  = ?)
                                or  (pr-mo-am.dt-inicio       <= import-cobert-bnfciar.dat-inicial
                                and  pr-mo-am.dt-cancelamento <> ?
                                and  pr-mo-am.dt-cancelamento >= import-cobert-bnfciar.dat-inicial)
                                then leave.
                            end.
                            
                            if not avail pr-mo-am
                            then do:
                                   RUN pi-cria-tt-erros("Beneficiario nao possui cobertura para o procedimento").
                                   assign lg-relat-erro = yes.
                                   NEXT.
                                 end.
                          end.
                     else do:
                            /* Verifica restricao de cobertura na proposta */
                            for each pr-mo-am FIELDS (dt-inicio dt-cancelamento)
                               where pr-mo-am.cd-modalidade          = propost.cd-modalidade
                                 and pr-mo-am.nr-proposta            = propost.nr-proposta
                                 and pr-mo-am.cd-modulo              = import-cobert-bnfciar.cdn-modulo
                                 and pr-mo-am.cd-amb                 = import-cobert-bnfciar.cd-proc-insu
                                 and pr-mo-am.lg-acrescimo-cobertura = no /* Restricao */
                                     no-lock:
                            
                                if  (pr-mo-am.dt-inicio <= import-cobert-bnfciar.dat-inicial and pr-mo-am.dt-cancelamento  = ?)
                                or  (pr-mo-am.dt-inicio <= import-cobert-bnfciar.dat-inicial and pr-mo-am.dt-cancelamento <> ? and  pr-mo-am.dt-cancelamento >= import-cobert-bnfciar.dat-inicial)
                                then leave.
                            end.
                            
                            if avail pr-mo-am
                            then do:
                                   RUN pi-cria-tt-erros("Beneficiario nao possui cobertura para o procedimento").
                                   assign lg-relat-erro = yes.
                                   NEXT.
                                 end.
                          end.
                   end.                                                                                
              else do:                                                                                 
                     find partinsu where partinsu.cd-modalidade  = propost.cd-modalidade               
                                     and partinsu.cd-plano       = propost.cd-plano                    
                                     and partinsu.cd-tipo-plano  = propost.cd-tipo-plano               
                                     and partinsu.cd-modulo      = import-cobert-bnfciar.cdn-modulo                          
                                     and partinsu.cd-tipo-insumo = int(import-cobert-bnfciar.cod-tip-insumo)
                                     and partinsu.cd-insumo      = import-cobert-bnfciar.cd-proc-insu                
                                         no-lock no-error.                                             
                     if not available partinsu                                                         
                     then find partinsu where partinsu.cd-modalidade  = propost.cd-modalidade          
                                          and partinsu.cd-plano       = propost.cd-plano               
                                          and partinsu.cd-tipo-plano  = propost.cd-tipo-plano          
                                          and partinsu.cd-modulo      = import-cobert-bnfciar.cdn-modulo                     
                                          and partinsu.cd-tipo-insumo = int(import-cobert-bnfciar.cod-tip-insumo)
                                          and partinsu.cd-insumo      = 0                              
                                              no-lock no-error.                                        
                          if not available partinsu                                                    
                          then find partinsu where partinsu.cd-modalidade  = propost.cd-modalidade     
                                               and partinsu.cd-plano       = propost.cd-plano          
                                               and partinsu.cd-tipo-plano  = propost.cd-tipo-plano     
                                               and partinsu.cd-modulo      = import-cobert-bnfciar.cdn-modulo                
                                               and partinsu.cd-tipo-insumo = 0                         
                                               and partinsu.cd-insumo      = 0                         
                                                   no-lock no-error.                                   
                     if not available partinsu                                                             
                     then do: 
                            RUN pi-cria-tt-erros("Beneficiario nao possui cobertura para o insumo").
                            assign lg-relat-erro = yes.
                            NEXT.
                          end.                                                                         
                   end.                                                                                
            end.  

       assign cd-tab-preco-aux = substr(string(import-cobert-bnfciar.cdn-tab-preco),1,03)
                               + substr(string(import-cobert-bnfciar.cdn-tab-preco),5,02).
       
       if import-cobert-bnfciar.in-carencia <> 2 
       then do:
              if   lg-procedimento-aux
              then do:
                     if import-cobert-bnfciar.in-carencia = 5    
                     AND avail pr-mo-am 
                     then do: 
                            if avail promodpr 
                            and (promodpr.in-tipo-regra = 1 or promodpr.in-tipo-regra = 3)
                            then do:
                                   if string(import-cobert-bnfciar.cdn-tab-preco) = pr-mo-am.cd-tab-preco                                                       
                                   and       import-cobert-bnfciar.nr-dias        = promodpr.nr-dias-validade
                                   then do:    
                                          RUN pi-cria-tt-erros("Para sobreposicao a tabela de moedas e carencias ou numero de dias devem ser diferentes da cobertura ja existente").
                                          assign lg-relat-erro = yes.
                                        end.   
                                 end.
                            else do:
                                   if string(import-cobert-bnfciar.cdn-tab-preco) = pr-mo-am.cd-tab-preco                                                       
                                   and       import-cobert-bnfciar.nr-dias        = pr-mo-am.nr-dias                                                            
                                   then do:     
                                          RUN pi-cria-tt-erros("Para sobreposicao a tabela de moedas e carencias ou numero de dias devem ser diferentes da cobertura ja existente ").
                                          assign lg-relat-erro = yes.
                                        end.   
                                 end.                                                                                                                                                                                                                                                                                                                                          
                          end.                                                                                                        
                   end.
              else do:
                     if   avail partinsu
                     AND string(import-cobert-bnfciar.cdn-tab-preco) = partinsu.cd-tab-preco
                     and        import-cobert-bnfciar.in-carencia    = 5
                     then do:
                            RUN pi-cria-tt-erros("Para sobreposicao a tabela de moedas e carencias deve ser diferente da cobertura ja existente ").
                            assign lg-relat-erro = yes.
                          end.
                   end.
       
              IF NOT CAN-FIND (first precproc 
                               where precproc.cd-tab-preco   = cd-tab-preco-aux                     
                                 and precproc.cd-forma-pagto = propost.cd-forma-pagto                  
                                 and precproc.dt-limite     >= TODAY)                                      
              then do:       
                     RUN pi-cria-tt-erros("Tabela de moedas e carencias nao cadastrada ou com data limite vencida").
                     assign lg-relat-erro = yes.
                   end.   
            end.
    END.

END PROCEDURE.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-msg-aux AS CHAR NO-UNDO.
END PROCEDURE.
