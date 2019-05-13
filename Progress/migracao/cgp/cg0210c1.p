/**
 * ATENCAO: mesma logica de negocio que CG0210C original.
 *
 *          alterado para otimizar a performance.
 *          validacoes foram separadas da logica principal (pergunta em tela).
 *          acrescentado tratamento da SIT-APROV-PROPOSTA
 *         
 *          Alex Boeira - 10/02/2016
 */



/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CG0210C 2.00.00.023 } /*** 010020 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i cg0210c MCG}
&ENDIF

/******************************************************************************
*      Programa .....: cg0210c.p                                              *
*      Data .........: 08 de julho de 1998.                                   *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Cliente ......: COOPERATIVAS MEDICAS                                   *
*      Programador ..: Monia Turella                                          *
*      Objetivo .....: Atualizacao de Propostas de Migracao                   *
******************************************************************************/
hide all no-pause.
/* --------------------- TRIGGER CREATE E UPDATE DA TABELA ----------------- */
{trs/wrusuario.i}
{trs/wrter-ade.i}
{trs/wrpro-pla.i}
{trs/wrpreserv.i}
{trs/wrcontrat.i}
{trs/wrcar-ide.i}
{trs/wrusumodu.i}
{trs/wrusucaren.i}
{trs/wrusucarproc.i}

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
{hdp/hdrunpersis.iv "new"}

{hdp/hdvarregua.i}
{hdp/hdregpaseatu.i}
{hdp/hdregpaseatu.f}

{hdp/hd9000.i "cg0210c"}
 
/*------------------------------Variaveis de Cabecalho---------------*/
{hdp/hdvarrel.i}
 
nm-cab-usuario = "Atualizacao de Propostas de Migracao".
nm-prog        = "CG0210C1".
c-versao       = "1.02.01.000".
{hdp/hdlog.i}

/* ------------------------- Variaveis programa mc0110fx --------------------*/
DEF VAR lg-chama-mc0110fx-aux       AS LOG        INIT NO               NO-UNDO.
def var r-registro                  as recid                            no-undo.
def var r-ter-ade                   as recid                            no-undo.
def var r-proposta                  as recid                            no-undo.
def var r-car-ide                   as recid                            no-undo.
def var c-ponto                     as char                             no-undo.
def var l-erro-x                    as log                              no-undo.
def var p-log-1                     as log                              no-undo.
def var p-log-2                     as log                              no-undo.
 
/*---------------------------- Variaveis auxiliares --------------------------*/
def var ds-cabecalho           as char format "x(30)"  initial ""       no-undo.
def var lg-atualiza            as logical format "Sim/Nao"              no-undo.
def var ds-rodape              as char format "X(132)" init ""          no-undo.
def var ds-rod-erros           as char format "X(80)"  init ""          no-undo.
def var nr-usuarios            as dec format "999999999"                no-undo.
def var qt-usuarios            as int                                   no-undo.
def var lg-erro-aferic         as log                                   no-undo.
def var ct-erros               as int format ">>>,>>9"  init 0          no-undo.
def var nr-usuarios-aux        like modalid.pc-afericao                 no-undo.
def var qt-usuarios-aux        like modalid.pc-afericao                 no-undo.
def var qt-executada-aux       as dec format "999999999"                no-undo.
def var nr-idade-min-aux       like pl-gr-pa.nr-idade-minima            no-undo.
def var nr-idade-max-aux       like pl-gr-pa.nr-idade-maxima            no-undo.
def var ds-mensagem            as char format "x(80)"    init ""        no-undo.
def var ds-mensagem-aux        as char format "x(80)"                   no-undo.
def var cd-tipo-mensagem-aux   as char format "x(01)"                   no-undo.
def var ds-mensagem-err-aux    as char format "x(80)"                   no-undo.
def var lg-undo-retry          as log init no                           no-undo.
def var cd-sit-aux             as int format "99"                       no-undo.
def var dt-fim-aux             like propost.dt-proposta                 no-undo.
def var dt-inicio-aux          like propost.dt-proposta                 no-undo.
def var  lg-first              as logical initial yes                   no-undo.
def var nr-senha-dec-aux       as dec format 99999999999999999999       no-undo.
def var cd-senha-aux           as int format 999999                     no-undo.
def var lg-erro-rtsenha-aux    as log                                   no-undo.
def var ds-erro-aux            as char                                  no-undo.
def var dt-validade-aux        like car-ide.dt-validade                 no-undo.

/*---------------------------- Variaveis da selecao --------------------------*/
def var nr-proposta-inicial    like propost.nr-proposta                 no-undo.
def var nr-proposta-final      like propost.nr-proposta                 no-undo.
def var ep-codigo-inicial      like propost.ep-codigo                   no-undo.
def var ep-codigo-final        like propost.ep-codigo                   no-undo.
def var cod-estabel-inicial    like propost.cod-estabel                 no-undo.
def var cod-estabel-final      like propost.cod-estabel                 no-undo.
def var cd-modalidade-inicial  like propost.cd-modalidade init 0        no-undo.
def var cd-modalidade-final    like propost.cd-modalidade init 99       no-undo.
def var dt-proposta-inicial    like propost.dt-proposta init 01/01/1900 no-undo.
def var dt-proposta-final      like propost.dt-proposta init 12/31/9999 no-undo.
def var cd-plano-inicial       like propost.cd-plano                    no-undo.
def var cd-plano-final         like propost.cd-plano                    no-undo.
def var cd-tipo-plano-inicial  like propost.cd-tipo-plano               no-undo.
def var cd-tipo-plano-final    like propost.cd-tipo-plano               no-undo.
def var nr-inscricao-inicial   like propost.nr-insc-contratante         no-undo.
def var nr-inscricao-final     like propost.nr-insc-contratante         no-undo.
def var ct-propostas-conf      as int format ">>>,>>9"        init 0    no-undo.
def var tt-proposta-erro       as int format "999999"         init 0    no-undo.
def var tt-proposta-ok         as int format "999999"         init 0    no-undo.
def var cd-sit-cred-aux        like contrat.cd-sit-cred                 no-undo.
def var lg-analise-aux         as log format "Sim/Nao"                  no-undo.
def var lg-imp-cart-aux        as log format "Sim/Nao"                  no-undo.
def var lg-param               as log                                   no-undo.
def var lg-ativo               as log     init no                       no-undo.
 
def var dt-valid-carte         like car-ide.dt-validade                 no-undo.
def var lg-grava-carteira      as logical initial yes                   no-undo.
def var nm-arq-erros           as char format "x(20)"                   no-undo.
def var lg-usuario-aux         as log format "Sim/Nao"                  no-undo.
def var lg-analise-credito     as log init no  format "Sim/Nao"         no-undo.
def var lg-imp-carteira        as log init no  format "Sim/Nao"         no-undo.
def var dt-minima-termo        as date format "99/99/9999"              no-undo.

def var lg-mantem-senha-benef-aux   like ter-ade.lg-mantem-senha-benef  no-undo.
def var ds-geracao-senha-aux   as char format "x(10)"                   no-undo.
def var in-geracao-senha-aux   like ter-ade.in-gera-senha format "99"   no-undo.
def var tb-geracao-senha       as char view-as selection-list
                                       inner-chars 16
                                       inner-lines 02                   no-undo.
def var ds-geracao-senha       as char                                  no-undo.
def var lg-cpc-final-lib-doc-aux     
                               as log                                   no-undo.
def var lg-erro-cpc-aux        as log                                   no-undo.
DEF VAR nm-rel-erros-ant-aux   AS CHAR                                  NO-UNDO.
{cpc/cpc-cg0210c.i}


def buffer  b-usuario for usuario.
def buffer  b-ter-ade for ter-ade.
def buffer  b-propost for propost.
 
def new shared var cd-sit-cred-z       like sit-cre.cd-sit-cred         no-undo.
 
/* --------------------------------------------------- variaveis vp0311k --- */
def var lg-erro-gera-aux             as log                            no-undo.
def var ds-erro-gera-aux             as char format "x(20)"            no-undo.
def var ds-chave-gera-aux            as char format "x(20)"            no-undo.

/* -------------------------------------------- VARIAVEIS ROTINA RTVALDOC ---*/
def var lg-erro-valdoc               as log     init no                no-undo.
def var ds-mensagem-valdoc           as char format "x(75)"            no-undo.
def var dt-validade-valdoc           as date                           no-undo.
def var lg-renova-valdoc             as log                            no-undo.

/*********************** Variaveis do Calculo *********************************/
def new shared var r-propost        as recid                            no-undo.
def new shared var lg-erro          as log                              no-undo.
def new shared var vl-plano         as dec format ">>>>,>>>,>>>,>>9.99" no-undo.
def new shared var vl-taxa-inscricao as dec format ">>>>,>>>,>>>,>>9.99"
                                                                        no-undo.
def new shared var vl-plano-sempc   as dec format ">>>>,>>>,>>>,>>9.99" no-undo.
def new shared var vl-taxa-sempc    as dec format ">>>>,>>>,>>>,>>9.99" no-undo.
def new shared var lg-altera-dados  as log init no                      no-undo.
def new shared var lg-media         as log                              no-undo.
def new shared var cd-retorno       as log                              no-undo.
def var lg-erro-aux                 as log                              no-undo.
 
/* ----- DEFINICAO DE VARIAVEIS REFERENTES A MEDICINA OCUPACIONAL ---------- */
def new shared var lg-medocup-aux   as log                             no-undo.
 
/* ----- DEFINICAO DE VARIAVEIS DA ROTINA RTMONCAR ------------------------- */
def            var nr-via-carteira-aux
                                    as int                             no-undo.
def            var cd-cart-inteira-aux
                                  like car-ide.cd-carteira-inteira     no-undo.
def            var dv-cart-inteira-aux
                                  like car-ide.dv-carteira             no-undo.
def            var cd-cart-impress-aux
                                    as char format "x(22)"             no-undo.
 
/*------------------------  Form's do Relatorio e Tela  ----------------------*/
find first paramecp no-lock no-error.
if available paramecp
then do:
        find unimed where unimed.cd-unimed =
        paramecp.cd-unimed no-lock no-error.
 
        if available unimed
        then assign ds-cabecalho = unimed.nm-unimed-reduz.
     end.
ELSE do:
       message "Tabela de Parametros do cadastro de Planos " +
               "nao cadastrada"
       view-as alert-box title " Atencao !!! ".
       RETURN.
     end.

find first parafatu no-lock no-error.
if not avail parafatu
then do:
       message "Parametros do faturamento nao cadastrados."
           view-as alert-box title "Atencao !!!".
       return.
     end.

form header
     fill("-", 132) format "x(132)"                     skip
     ds-cabecalho                                       at  01
     nm-cab-usuario                                     at  40
     "Folha:"                                           at 122
     page-number    format ">>>9"                       at 128 skip
     fill("-", 112) format "x(112)"
     today "-" string(time, "hh:mm:ss")                 skip(1)
     with width 132 no-labels no-box page-top frame f-cabecalho.
 
/* --------------------------------------------------- RELATORIO DE ERROS -- */
def temp-table  wk-erros no-undo
    field cd-modalidade           like  modalid.cd-modalidade
    field nr-proposta             like  propost.nr-proposta
    field cd-sit-proposta         like  propost.cd-sit-proposta
    field nr-insc-contratante     like  propost.nr-insc-contratante
    field cd-contratante          like  propost.cd-contratante
    field cd-tipo-mensagem        as char format "x(01)"
    field ds-mensagem             as char format "x(75)".
 
form wk-erros.cd-modalidade       column-label "Mod"
     wk-erros.nr-proposta         column-label "Proposta"
     wk-erros.cd-sit-proposta     column-label "Cod"
     sit-pro.ds-sit-proposta      column-label "Sit Proposta" format "x(15)"
     wk-erros.nr-insc-contratante column-label "Inscricao"
     wk-erros.cd-contratante      column-label "Codigo"
     contrat.nm-contratante       column-label "Contratante"  format "x(26)"
     wk-erros.cd-tipo-mensagem    column-label "Tipo"
     wk-erros.ds-mensagem         column-label "Descricao da mensagem" format "x(75)"
     with width 80 no-box down frame f-prop-erros.
 
form header
     fill("-", 80) format "x(80)"                        skip
     ds-cabecalho                                        at 01
     "Propostas Rejeitadas"                              at 40
     "Folha:"                                            at 71
     page-number                                         at 77 format ">>>9"
     fill("-", 60) format "x(60)"
     today "-" string(time, "HH:MM:SS") skip(1)
     with no-box overlay width 80 page-top frame f-cab-rej.
 
/* --------------------------------------------------------------------- */
 
form cd-modalidade-inicial             label "     Modalidade"  colon 16
     cd-modalidade-final
        validate(input cd-modalidade-final >= input cd-modalidade-inicial,
                "Modalidade Final Menor que Inicial")
                                       no-label                 colon 30
 
     cd-plano-inicial                  label "          Plano"  colon 16
     cd-plano-final
        validate(input cd-plano-final >= input cd-plano-inicial,
                "Plano Final Menor que Inicial")
                                       no-label                 colon 30
     cd-tipo-plano-inicial             label "     Tipo Plano"  colon 16
     cd-tipo-plano-final
        validate(input cd-tipo-plano-final >= input cd-tipo-plano-inicial,
                "Tipo de Plano Final Menor que Inicial")
                                       no-label                 colon 30
 
     nr-inscricao-inicial              label "Inscr. Contrat."  colon 16
     nr-inscricao-final
        validate(input nr-inscricao-final >= input nr-inscricao-inicial,
                "Inscricao Contratante Final Menor que Inicial")
                                       no-label                 colon 30
 
     nr-proposta-inicial               label "       Proposta"  colon 16
     nr-proposta-final
        validate(input nr-proposta-final >= input nr-proposta-inicial,
                "Proposta Final Menor que Inicial")
                                       no-label                 colon 30
     dt-proposta-inicial
        validate(input dt-proposta-inicial <> ?, "Data Invalida")
                                       label "  Data Proposta"  colon 16
     dt-proposta-final
        validate(input dt-proposta-final >= input dt-proposta-inicial,
                "Data Proposta Final Menor que Inicial")
                                       no-label                 colon 30
     header "                 Inicial       Final  "
     with overlay row 11 centered side-labels frame f-selecao
     title "Selecao".
 
form
     "Data minima para parametro de fim de termo:"            at 15
     dt-minima-termo                                          at 60 skip
     "Efetuar analise de credito dos contratantes:"           at 14
     lg-analise-credito                                       at 60 skip
     "Deseja futura impressao de Carteira/cartoes p/ benef.:" at 4                   
     lg-imp-carteira                                          at 60 skip
     "                       Mantem Senha Benef.:"            at 15
     lg-mantem-senha-benef-aux                                at 60 skip
     "                             Geracao Senha:"            at 15
     in-geracao-senha-aux ds-geracao-senha-aux                at 60 skip
     header
     "*" + fill("-",45) format "x(46)" " Mapa de Parametros "
     fill("-",45) + "*" format "x(46)" skip
     with no-labels column 08 width 118 down no-box attr-space
     frame f-parametros.
 
 
form "Inicial"                                 at 51
     "Final "                                  at 64 skip
     "      Modalidade:"                       colon 31
     cd-modalidade-inicial cd-modalidade-final at 64 skip
     "           Plano:"                       colon 31
     cd-plano-inicial      cd-plano-final      at 64 skip
     "      Tipo Plano:"                       colon 31
     cd-tipo-plano-inicial cd-tipo-plano-final at 64 skip
     " Inscr. Contrat.:"                       colon 31
     nr-inscricao-inicial  nr-inscricao-final  at 64 skip
     "        Proposta:"                       colon 31
     nr-proposta-inicial   nr-proposta-final   at 64 skip
     "   Data Proposta:"                       colon 31
     dt-proposta-inicial   dt-proposta-final   at 64 skip(05)
     header
     "*" + fill("-",48) format "x(49)" " Mapa de Selecao "
     fill("-",48) + "*" format "x(49)" skip
     with no-labels column 08 width 118 down no-box attr-space frame f-mapa-sel.
 
form "Inicial"                                 at 31
     "Final "                                  at 44 skip
     "      Modalidade:"                       colon 11
     cd-modalidade-inicial cd-modalidade-final at 44 skip
     "           Plano:"                       colon 11
     cd-plano-inicial      cd-plano-final      at 44 skip
     "      Tipo Plano:"                       colon 11
     cd-tipo-plano-inicial cd-tipo-plano-final at 44 skip
     " Inscr. Contrat.:"                       colon 11
     nr-inscricao-inicial  nr-inscricao-final  at 44 skip
     "        Proposta:"                       colon 11
     nr-proposta-inicial   nr-proposta-final   at 44 skip
     "   Data Proposta:"                       colon 11
     dt-proposta-inicial   dt-proposta-final   at 44 skip
     header
     "*" + fill("-",19) format "x(20)" " Mapa de Selecao "
     fill("-",19) + "*" format "x(20)" skip
     with no-labels column 08 width 60 down no-box attr-space
        frame f-mapa-sel-err.
 
form propost.nr-contrato-antigo     column-label "Contrato Antigo"
     propost.cd-modalidade          column-label "Mod"
     propost.nr-proposta            column-label "Proposta"
     propost.cd-sit-proposta        column-label "Sit"
     propost.nr-ter-adesao          column-label "Termo"
     propost.nr-insc-contratante    column-label "Inscricao"
     propost.cd-contratante         column-label "Contrat."
     contrat.nm-contratante         column-label "Nome" format "x(38)"
 
     propost.cd-forma-pagto         column-label "FP"
     propost.cd-plano               column-label "PL"
     propost.cd-tipo-plano          column-label "TP"
 
     ter-ade.dt-inicio              column-label "Inicio Termo"
     ter-ade.dt-fim                 column-label "Fim Termo"
     with width 132 down no-box frame f-relat-prop.

form usuario.cd-carteira-antiga     column-label "Cart. Antiga"
     usuario.cd-usuario             column-label "Cod"
     usuario.nm-usuario             column-label "Beneficiario" format "x(40)"
     usuario.cd-grau-parentesco     column-label "Grau"
     usuario.dt-nascimento          column-label "Nasc"
     usuario.dt-inclusao-plano      column-label "Inclusao"
     usuario.dt-exclusao-plano      column-label "Exclusao"
     usuario.cd-sit-usuario         column-label "Sit"
     usuario.cd-padrao-cobertura    column-label "Pad. Cob."
     with width 132 down no-box col 18 frame f-relat-usu.
 
form skip (2)
    "    Total Propostas: "         at 1
     ct-propostas-conf              at 23
     with side-label no-label no-box frame f-total.
 
form header ds-rodape format "X(132)"
            with no-labels width 132 no-box page-bottom frame f-rodape.
 
form header ds-rod-erros format "X(80)"
            with no-labels width 80 no-box page-bottom frame f-rod-erros.

form ct-propostas-conf              label "Propostas Liberadas" skip
     ct-erros                       label "Propostas  com Erro"
     with overlay side-labels row 17 centered
     title "Resultado" frame f-resultado.
 
form cd-sit-cred-aux                label "Situacao Credito Contratantes:"
     sit-cre.ds-sit-cred            no-label
     with overlay side-labels row 18 centered frame f-analise-credito.
 
form
     dt-minima-termo      label "           Data minima para parametro de fim do Termo"
     lg-analise-credito   label "          Efetuar analise de credito dos contratantes"
     lg-imp-carteira      label "Deseja futura impressao de Carteiras/cartoes p/ benef"
     lg-mantem-senha-benef-aux  at 35
     skip
     in-geracao-senha-aux label "                                        Geracao Senha"
     ds-geracao-senha-aux no-label
     with row 14 column 8 side-labels overlay frame f-analise
     title "Parametro de Migracao".
 
form header
     fill("-", 80) format "x(80)"       skip
     ds-cabecalho                       at 01
     "Propostas com Erros"              at 40
     "Folha:"                           at 71
     page-number                        at 77 format ">>>9"
     fill("-", 60) format "x(60)"
     today "-" string(time, "HH:MM:SS") skip(1)
     with no-box overlay width 80 page-top frame f-cab-erros.
 
def  frame f-geracao-senha
     tb-geracao-senha        no-label
     with row 13 column 40 overlay
         title "Geracao Senha".

ds-geracao-senha            = "01 - Individual," +
                              "02 - Familia".
tb-geracao-senha:list-items = ds-geracao-senha.

{hdp/hdvararq.i "spool/" "ATU-MIG" "LST" " " "1"}
 
assign nr-proposta-inicial       = 0
       nr-proposta-final         = 99999999
       cd-plano-inicial          = 0
       cd-plano-final            = 99
       cd-tipo-plano-inicial     = 0
       cd-tipo-plano-final       = 99
       nr-inscricao-inicial      = 0
       nr-inscricao-final        = 99999999
       lg-mantem-senha-benef-aux = yes.
 
assign ds-rodape    = " " + nm-prog + " - " + c-versao
       ds-rodape    = fill("-", 132 - length(ds-rodape)) + ds-rodape.
 
assign ds-rod-erros = " " + nm-prog + " - " + c-versao
       ds-rod-erros = fill("-", 80 - length(ds-rod-erros)) + ds-rod-erros.

/* -------------------------------------------------------------------------- */
if can-find (first dzlibprx where dzlibprx.nm-ponto-chamada-cpc = "FINAL-LIB-DOC"
                              and dzlibprx.nm-programa          = "CG0210C"        
                              and dzlibprx.lg-ativo-cpc no-lock)
then do:
       if   search("cpc/cpc-cg0210c.p") = ?
       and  search("cpc/cpc-cg0210c.r") = ?
       then do:
              message "CPC-CG0210C -> Ponto chamada FINAL-LIB-DOC ativo, mas nao encontrado!" skip
                      "Processo cancelado."
                      view-as alert-box title " Atencao !!! ".
              return.
            end.
       assign lg-cpc-final-lib-doc-aux = yes.
     end.
else assign lg-cpc-final-lib-doc-aux = no.

if   search ("progx/mc0110fx.p") = ?
and  search ("progx/mc0110fx.r") = ?
THEN ASSIGN lg-chama-mc0110fx-aux = NO.
ELSE ASSIGN lg-chama-mc0110fx-aux = YES.


/* ----- LOCALIZA PARAMETROS DO VP E MC ------------------------------------ */
find first paravpmc
     no-lock no-error.
if   avail paravpmc
then do:
       if   search (substring (paravpmc.nm-prog-monta-cart, 1, 2) + "p/" +
                               paravpmc.nm-prog-monta-cart + ".p") = ?
       and  search (substring (paravpmc.nm-prog-monta-cart, 1, 2) + "p/" +
                               paravpmc.nm-prog-monta-cart + ".r") = ?
       then do:
              message "Programa para montagem do documento de identificacao"
                      skip
                      "do beneficiario nao foi encontrado."
                      view-as alert-box title " Atencao !!! ".
              return.
            end.
     end.
else do:
       message "Parametros dos modulos VP e MC nao cadastrado."
               view-as alert-box title " Atencao !!! ".
       return.
     end.
 
/* -------------------------------------------------- DEFINICAO DA INCLUDE DA API USMOVADM --- */
 {api/api-usmovadm.i}.

 /*--------------------------------------------------- PERSISTENCIA DA API ---*/ 
 def var h-api-usmovadm-aux               as handle                     no-undo.

/*-----------------------  INICIALIZACAO -------------------------------------*/
{hdp/hdtitrel.i}
assign lg-param = no.
repeat on endkey undo,retry with frame mc0110b:
  hide frame f-resultado no-pause.
  hide frame f-selecao no-pause.
  hide frame f-analise no-pause.
  hide frame f-analise-credito no-pause.
  hide message          no-pause.
  {hdp/hdbotpaseatu.i}.

  assign ct-propostas-conf = 0
         ct-erros          = 0.
 
  /* Quando c-opcao = "Arquivo" */
  {hdp/hdpedarq.i "ambos"}
 
  case c-opcao:
     when "Selecao"
     then do on error undo, retry with frame f-selecao:
             update cd-modalidade-inicial
                    cd-modalidade-final
                    cd-plano-inicial
                    cd-plano-final
                    cd-tipo-plano-inicial
                    cd-tipo-plano-final
                    nr-inscricao-inicial
                    nr-inscricao-final
                    nr-proposta-inicial
                    nr-proposta-final
                    dt-proposta-inicial
                    dt-proposta-final.
          end.
     when "Parametro"
     then do:
            if   month(today) = 12
            then assign dt-minima-termo = date(month(today),31,year(today)).
            else assign dt-minima-termo
                        = date(month(today) + 1,01,year(today)) - 1.
            if lg-first
            then do:
                   message
                   skip
                   "          Parametro Validade Termo de Adesao             "
                   skip(1)
                   "O calculo para validade do termo de adesao sera executado"
                    skip
                   "tantas vezes quanto necessario, com base no indicador"
                    skip
                   "do tipo de plano, ate chegar-se a uma data maior ou igual"
                    skip
                   "que sera solicitada no parametro a seguir."
                    skip(1)
                    view-as alert-box
                    title " Atencao !!! ".
                    lg-first = no.
                  end.
    
            lg-analise-aux = no.
            update dt-minima-termo
                   lg-analise-credito
                   lg-imp-carteira
                   lg-mantem-senha-benef-aux
                   with frame f-analise.
    
            if not lg-mantem-senha-benef-aux 
            then do:
                   do on error undo, retry on endkey undo, leave
                   with frame f-geracao-senha:
                      tb-geracao-senha = "01 - Individual".
                      update tb-geracao-senha go-on ("return").
                      in-geracao-senha-aux = int(substring(tb-geracao-senha,1,2)).
                      ds-geracao-senha-aux = substring(tb-geracao-senha,6,10).
                      hide frame f-geracao-senha no-pause.
                   end.
                   disp ds-geracao-senha-aux   with frame f-analise.
                   
                   update in-geracao-senha-aux with frame f-analise.
                   if (in-geracao-senha-aux <> 1 and in-geracao-senha-aux <> 2) 
                   then do:
                           message "Codigo deve ser 1 ou 2."
                           view-as alert-box title " Atencao !!! ".
                           undo, retry.
                   end.
                   if in-geracao-senha-aux = 1
                   then disp "Individual" @ ds-geracao-senha-aux with frame f-analise.  
                   else disp "Familia"    @ ds-geracao-senha-aux with frame f-analise.   
                 end.
            else in-geracao-senha-aux = 0.     
            
            hide frame f-analise no-pause.
    
            if lg-analise-aux
            then do on error undo, retry with frame f-analise-credito:
                    prompt-for cd-sit-cred-aux auto-return
                         help "F5 para Zoom"
                         {vpp/vp0210e.i}
                         if   cd-sit-cred-z <> ?
                         and  cd-retorno
                         then display cd-sit-cred-z @ cd-sit-cred-aux
                                                    with frame f-analise-credito.
                         cd-retorno = ?.
                         end.
    
                    cd-sit-cred-aux = input frame f-analise-credito
                                      cd-sit-cred-aux.
                    find sit-cre where sit-cre.cd-sit-cred
                                     = input frame f-analise-credito
                                       cd-sit-cred-aux no-lock no-error.
    
                    if   not available sit-cre
                    then do:
                            message "Codigo da Situacao de Credito Invalido"
                            view-as alert-box title " Atencao !!! ".
                            undo, retry.
                         end.
                    else do:
                            display sit-cre.ds-sit-cred
                                    with frame f-analise-credito.
                            pause.
                         end.
                       hide frame f-analise-credito.
                 end.
    
            hide frame f-analise-credito-aux no-pause.
            assign lg-param = yes.
          end.
     when "Atualiza"
     then do:
            if   lg-param = no
            then do:
                   message "Nenhum Parametro Selecionado"
                   view-as alert-box title " Atencao !!! ".
                   undo, retry.
                 end.
    
            assign  lg-atualiza = no.
            message "Confirma atualizacao? "
                     view-as alert-box question buttons yes-no title "Atencao!"
                     update  lg-atualiza.
    
            if   not lg-atualiza
            then next.
    
            assign  lg-usuario-aux = no.
            message "Deseja imprimir beneficiarios de cada proposta?"
                     view-as alert-box question buttons yes-no title "Atencao!"
                     update lg-usuario-aux.
    
            /**
             * Validacao de erros basicos, que foram retirados da logica principal para otimizar a performance do processo.
             */
            message "Deseja realizar a validacao basica dos registros antes de executar a atualizacao?" SKIP
                    "Esse processo nao altera a base de dados, apenas gera relatorio com os problemas encontrados." SKIP
                    "As propostas listadas nesse relatorio nao serao consideradas pelo processo de atualizacao " 
                    "ate que seus problemas sejam saneados."
                     view-as alert-box question buttons yes-no title "Atencao!"
                     update lg-pre-validacao-aux AS LOG.
            IF lg-pre-validacao-aux
            THEN DO:
                   message "Realizando verificacao previa da base...".
                   FOR EACH propost NO-LOCK use-index propo28
                      where propost.cd-modalidade       >= cd-modalidade-inicial
                        AND propost.cd-modalidade       <= cd-modalidade-final
                        and propost.cd-plano            >= cd-plano-inicial
                        and propost.cd-plano            <= cd-plano-final
                        and propost.cd-tipo-plano       >= cd-tipo-plano-inicial
                        and propost.cd-tipo-plano       <= cd-tipo-plano-final
                        and propost.nr-proposta         >= nr-proposta-inicial
                        and propost.nr-proposta         <= nr-proposta-final
                        and propost.cd-sit-proposta      = 1
                        and propost.nr-ter-adesao        = 0
                        and propost.cd-tipo-proposta     = 9 
                        AND propost.dt-proposta         >= dt-proposta-inicial
                        AND propost.dt-proposta         <= dt-proposta-final
                        AND propost.nr-insc-contratante >= nr-inscricao-inicial
                        AND propost.nr-insc-contratante <= nr-inscricao-final:

                       PROCESS EVENTS.

                       IF NOT CAN-FIND(FIRST modalid
                                       WHERE modalid.cd-modalidade = propost.cd-modalidade)
                       then do:
                              create wk-erros.
                              assign wk-erros.cd-modalidade = propost.cd-modalidade
                                     wk-erros.ds-mensagem   = "Modalidade nao Cadastrada"
                                     ct-erros               = ct-erros + 1.
                            end.

                       IF NOT CAN-FIND(FIRST contrat
                                       WHERE contrat.nr-insc-contratante = propost.nr-insc-contratante)
                       then do:      
                              assign ds-mensagem-err-aux = "Contratante nao Cadastrado".
                              run gera-erro(input "E").
                            end.

                       IF NOT CAN-FIND(FIRST contrat
                                       WHERE contrat.nr-insc-contratante = propost.nr-insc-contratante
                                         AND contrat.cd-contratante      > 0)
                       then do:      
                              assign ds-mensagem-err-aux = "Contratante nao Integrado ao Financeiro." +
                                                           " Execute a efetivacao de contratantes.".
                              run gera-erro(input "E").
                            end.

                       IF NOT CAN-FIND(FIRST for-pag
                                       WHERE for-pag.cd-modalidade  = propost.cd-modalidade
                                         and for-pag.cd-plano       = propost.cd-plano
                                         and for-pag.cd-tipo-plano  = propost.cd-tipo-plano
                                         and for-pag.cd-forma-pagto = propost.cd-forma-pagto)
                       then do:
                              assign ds-mensagem-err-aux = "Forma de Pagamento nao "
                                                           + "Cadastrada "
                                                           + string(propost.cd-forma-pagto,"99").
                              run gera-erro(input "E").
                            end.

                       IF NOT CAN-FIND(FIRST usuario
                                       WHERE usuario.cd-modalidade = propost.cd-modalidade
                                         AND usuario.nr-proposta   = propost.nr-proposta)
                       THEN DO:
                              assign ds-mensagem-err-aux = "Proposta sem Beneficiarios"
                                                           + " Cadastrados".
                              run gera-erro(input "E").
                            END.

                       IF NOT CAN-FIND(FIRST usuario
                                       WHERE usuario.cd-modalidade = propost.cd-modalidade
                                         AND usuario.nr-proposta   = propost.nr-proposta
                                         AND usuario.cd-sit-usuario <= 7)
                       then do:
                               assign ds-mensagem-err-aux = "Nao existem usuarios ativos".
                               run gera-erro(input "E").
                            end.

                       if   propost.cd-contratante = 0
                       then do:
                              assign ds-mensagem-err-aux = "Rodar a efetivacao de "
                                                           + "Contratantes".
                              run gera-erro(input "E").
                            end.

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

                       find tabprepl where
                            tabprepl.cd-tab-preco = propost.cd-tab-preco
                            no-lock no-error.

                       if   not available tabprepl
                       then do:
                              assign ds-mensagem-err-aux = "Tabela de precos nao "
                                                           + "cadastrada "
                                                           + string(propost.cd-tab-preco,"999/99").
                              run gera-erro(input "E").
                            end.

                       if   not tabprepl.lg-situacao
                       then do:
                              assign ds-mensagem-err-aux = "Tabela de precos inativa".
                              run gera-erro(input "E").
                            end.

                       if   today > tabprepl.dt-fim
                       or   today < tabprepl.dt-inicio
                       then do:
                              assign ds-mensagem-err-aux = "Data limite tabela precos "
                                                           + "vencida".
                              run gera-erro(input "E").
                            end.
                   END.

                   if   ct-erros <> 0
                   then do:
                          ASSIGN nm-rel-erros-ant-aux = c-arquivo[2]
                                 c-arquivo[2] = replace(c-arquivo[2],"~\","/")
                                 c-arquivo[2] = SUBSTRING(c-arquivo[2],1,R-INDEX(c-arquivo[2],".") - 1)
                                 c-arquivo[2] = c-arquivo[2] + "_valida.txt".
                          run imp-erros.
                          ASSIGN c-arquivo[2] = nm-rel-erros-ant-aux.
                   
                          EMPTY TEMP-TABLE wk-erros.
                          message "Verificacao previa da base concluida COM ERROS. Verifique o relatorio".
                        END.
                   ELSE message "Verificacao previa da base concluida SEM erros.".
                 END.

            message "Processando...".
    
            {hdp/hdrunpersis.i "api/api-usmovadm.p" "h-api-usmovadm-aux"}
   
            {hdp/hdmonarq.i &page-size = 64 &numarq = 1}
    
            view frame f-cabecalho.
            view frame f-rodape.
    
            display cd-modalidade-inicial
                    cd-modalidade-final
                    cd-plano-inicial
                    cd-plano-final
                    cd-tipo-plano-inicial
                    cd-tipo-plano-final
                    nr-inscricao-inicial
                    nr-inscricao-final
                    nr-proposta-inicial
                    nr-proposta-final
                    dt-proposta-inicial
                    dt-proposta-final
                    with frame f-mapa-sel.
    
            display lg-analise-credito
                    lg-imp-carteira
                    dt-minima-termo
                    lg-mantem-senha-benef-aux
                    in-geracao-senha-aux 
                    ds-geracao-senha-aux 
                    with frame f-parametros.
    
            page.
                     
            FOR EACH modalid no-lock
               WHERE modalid.cd-modalidade >= cd-modalidade-inicial
                 AND modalid.cd-modalidade <= cd-modalidade-final,
                each b-propost NO-LOCK USE-INDEX propo28
               /*
               where b-propost.cd-modalidade    = modalid.cd-modalidade
                 and b-propost.cd-plano        >= cd-plano-inicial
                 and b-propost.cd-plano        <= cd-plano-final
                 and b-propost.cd-tipo-plano   >= cd-tipo-plano-inicial
                 and b-propost.cd-tipo-plano   <= cd-tipo-plano-final
                 AND b-propost.cd-forma-pagto  >= 0  /* para usar indice propo21 */
                 AND b-propost.cd-forma-pagto  <= 99 /* para usar indice propo21 */
                 AND b-propost.cd-contratante  <> 0
                 AND b-propost.nr-ter-adesao    = 0
                 and b-propost.nr-proposta     >= nr-proposta-inicial
                 and b-propost.nr-proposta     <= nr-proposta-final
                 and b-propost.cd-sit-proposta  = 1
                 and b-propost.cd-tipo-proposta = 9 
                 AND b-propost.dt-proposta     >= dt-proposta-inicial
                 AND b-propost.dt-proposta     <= dt-proposta-final
                 AND b-propost.nr-insc-contratante >= nr-inscricao-inicial
                 AND b-propost.nr-insc-contratante <= nr-inscricao-final
                 */
                where b-propost.cd-modalidade    = modalid.cd-modalidade
                  and b-propost.cd-plano        >= cd-plano-inicial
                  and b-propost.cd-plano        <= cd-plano-final
                  and b-propost.cd-tipo-plano   >= cd-tipo-plano-inicial
                  and b-propost.cd-tipo-plano   <= cd-tipo-plano-final
                  and b-propost.nr-proposta     >= nr-proposta-inicial
                  and b-propost.nr-proposta     <= nr-proposta-final
                  and b-propost.cd-sit-proposta  = 1
                  AND b-propost.cd-contratante  <> 0
                  AND b-propost.nr-ter-adesao    = 0
                  and b-propost.cd-tipo-proposta = 9 
                  AND b-propost.dt-proposta     >= dt-proposta-inicial
                  AND b-propost.dt-proposta     <= dt-proposta-final
                  AND b-propost.nr-insc-contratante >= nr-inscricao-inicial
                  AND b-propost.nr-insc-contratante <= nr-inscricao-final

                 AND CAN-FIND(FIRST usuario
                              WHERE usuario.cd-modalidade   = b-propost.cd-modalidade
                                AND usuario.nr-proposta     = b-propost.nr-proposta
                                AND usuario.cd-sit-usuario <= 7)
                 AND CAN-FIND(FIRST tabprepl 
                              WHERE tabprepl.cd-tab-preco = b-propost.cd-tab-preco
                                AND tabprepl.lg-situacao
                                AND tabprepl.dt-inicio <= TODAY
                                AND tabprepl.dt-fim    >= TODAY),
               FIRST contrat NO-LOCK
               WHERE contrat.nr-insc-contratante = b-propost.nr-insc-contratante,
               FIRST for-pag NO-LOCK 
               WHERE for-pag.cd-modalidade  = b-propost.cd-modalidade
                 and for-pag.cd-plano       = b-propost.cd-plano
                 and for-pag.cd-tipo-plano  = b-propost.cd-tipo-plano
                 and for-pag.cd-forma-pagto = b-propost.cd-forma-pagto 
                     with frame f-relat-prop:
                     
                     PROCESS EVENTS.

                     /**
                      * Acessar buffer PROPOST com EXCLUSIVE-LOCK.
                      * Atencao para tratar transacao por cada proposta, e nao por toda a selecao.
                      */
                     DO TRANSACTION:
                        FIND FIRST propost EXCLUSIVE-LOCK
                             WHERE rowid(propost) = ROWID(b-propost) NO-ERROR.
                        IF NOT AVAIL propost
                        then do:
                                assign ds-mensagem-err-aux = "Nao foi possivel acessar a proposta para atualizacao." +
                                                             " Modalid: " + STRING(b-propost.cd-modalidade) +
                                                             " Proposta: " + STRING(b-propost.nr-proposta).
                                run gera-erro(input "E").
                                next.
                             end.
                        
                        /* --------------------------------------------------------------------- */
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
                                      assign ds-mensagem-err-aux = "Nao sera possivel gerar numero do termo. " +  
                                                                   "Proposta com numero maior que 999999."     + 
                                                                   " Mod: " + string(propost.cd-modalidade).
                        
                                      run gera-erro(input "E").
                                      assign propost.nr-ter-adesao = 0.
                                      next.
                                    end.
                               else assign propost.nr-ter-adesao = propost.nr-proposta.
                             end.

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

                        run confirma.
                        
                        if   lg-analise-aux
                        then run analise.
                        
                        run aprova.
                        
                        if   paramecp.cd-mediocupa = modalid.cd-tipo-medicina
                        THEN lg-medocup-aux = YES.
                        ELSE lg-medocup-aux = NO.

                        run liberar-documentos.
                        
                        if   return-value = "erro"
                        then undo, next.
                        
                        if   lg-medocup-aux
                        then for each depsetse where
                                      depsetse.cd-modalidade = propost.cd-modalidade
                                  and depsetse.nr-proposta   = propost.nr-proposta
                                      exclusive-lock:
                        
                                 assign depsetse.nr-ter-adesao = propost.nr-ter-adesao.
                             end.
                        
                        assign ct-propostas-conf = ct-propostas-conf + 1
                               tt-proposta-ok    = tt-proposta-ok    + 1.
                     END. /* DO TRANSACTION */
            end.
    
            display ct-propostas-conf
                    with frame f-total.
    
            assign tt-proposta-erro = 0
                   tt-proposta-ok   = 0.
    
            {hdp/hdclosed.i}
    
            {hdp/hddelpersis.i}
   
            hide message no-pause.
    
            disp ct-propostas-conf
                 ct-erros
                 with frame f-resultado.
   
            if   ct-erros <> 0
            then do:
                   run imp-erros.
                   message "Relatorio de erros impresso"
                           view-as alert-box title " Atencao !!! ".
                 END.

            hide message no-pause.
            /*---- TESTA SISTEMA UNIX PARA POSICIONAR NO BOTAO ARQUIVO --------*/
            &if "{&window-system}" = "TTY"
            &then do:
                    assign c-opcao = "Arquivo".
                    display tb-paseatu with frame f-paseatu.
                    choose field tb-paseatu auto-return keys c-opcao 
                           with frame f-paseatu.
                 end.
            &endif. 
          end.

     when "Fim"
     then do:
            hide all no-pause.
            leave.
          end.
  end case.
end. /* end do repeat */
 
/* ----------------------------------------------- PROCEDIMENTOS INTERNOS -- */
procedure imp-erros:
   assign ct-erros          = 0
          ct-propostas-conf = 0.
   
   {hdp/hdmonarq.i &page-size = 64 &numarq = 2}
 
   view frame f-cab-erros.
   view frame f-rod-erros.
 
   display cd-modalidade-inicial
           cd-modalidade-final
           cd-plano-inicial
           cd-plano-final
           cd-tipo-plano-inicial
           cd-tipo-plano-final
           nr-inscricao-inicial
           nr-inscricao-final
           nr-proposta-inicial
           nr-proposta-final
           dt-proposta-inicial
           dt-proposta-final
           with frame f-mapa-sel-err.
 
   page.
   
   for each wk-erros no-lock:
       display wk-erros.cd-modalidade
               wk-erros.nr-proposta
               wk-erros.cd-sit-proposta
               wk-erros.nr-insc-contratante
               wk-erros.cd-contratante
               wk-erros.cd-tipo-mensagem
               wk-erros.ds-mensagem
               with frame f-prop-erros.

       find contrat use-index contrat1 where
            contrat.nr-insc-contratante = wk-erros.nr-insc-contratante
        and contrat.cd-contratante      = wk-erros.cd-contratante
            no-lock no-error.
 
       if   avail contrat
       then display contrat.nm-contratante
                    with frame f-prop-erros.
       else display ""
                    @ contrat.nm-contratante
                    with frame f-prop-erros.
 
       down with frame f-prop-erros.
   end.
   {hdp/hdclosed.i}
 
end procedure.
 
/* ---------------------------------- PROCESSO DE LIBERACAO DE DOCUMENTOS -- */
procedure liberar-documentos:
   create ter-ade.
 
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
 
   assign ter-ade.cd-userid             = v_cod_usuar_corren
          ter-ade.dt-aprovacao          = today
          ter-ade.dt-atualizacao        = today
          ter-ade.cd-modalidade         = propost.cd-modalidade
          ter-ade.nr-ter-adesao         = propost.nr-ter-adesao
          ter-ade.dt-mov-inclusao       = today
          ter-ade.cd-userid-inclusao    = v_cod_usuar_corren
          ter-ade.cd-classe-mens        = for-pag.cd-classe-mens
          ter-ade.aa-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,03,04))
          ter-ade.mm-ult-fat            = int(substring(propost.mm-aa-ult-fat-mig,01,02))
          ter-ade.dt-inicio             = propost.dt-parecer
          ter-ade.lg-mantem-senha-benef = lg-mantem-senha-benef-aux
          ter-ade.in-gera-senha         = in-geracao-senha-aux.
 
   if   propost.cd-sit-proposta = 5 
   or   ter-ade.dt-inicio       = ter-ade.dt-cancelamento
   then assign ter-ade.aa-pri-fat = 0
               ter-ade.mm-pri-fat = 0.
   else assign ter-ade.aa-pri-fat = year(ter-ade.dt-inicio)
               ter-ade.mm-pri-fat = month(ter-ade.dt-inicio).

   /* se nivel de reajuste da proposta por contrato, cria historico */
   if propost.int-13 = 0
   then do:
          /* Historico de tabelas de preco da proposta */
          create histabpreco.
          assign histabpreco.cd-modalidade        = propost.cd-modalidade 
                 histabpreco.nr-proposta          = propost.nr-proposta 
                 histabpreco.aa-reajuste          = year(ter-ade.dt-inicio)
                 histabpreco.mm-reajuste          = month(ter-ade.dt-inicio)
                 histabpreco.cd-tab-preco         = propost.cd-tab-preco
                 histabpreco.log-1                = parafatu.log-12
                 histabpreco.cd-userid            = v_cod_usuar_corren    
                 histabpreco.dt-atualizacao       = today.
         
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
                        histabpreco.log-1              = parafatu.log-12
                        histabpreco.cd-userid          = v_cod_usuar_corren
                        histabpreco.dt-atualizacao     = today.
               end.
        end.
 
   /* ---------------------------------------------------------------------- */
   if   contrat.lg-mantem-senha-termo
   then assign ter-ade.cd-senha = contrat.cd-senha.
   else do:
          run rtp/rtrandom.p (input 6,
                              output cd-senha-aux,
                              output lg-erro-rtsenha-aux,
                              output ds-erro-aux).

          if lg-erro-rtsenha-aux 
          then do:
                 assign lg-erro-rtsenha-aux = NO
                        ds-mensagem-err-aux = ds-erro-aux.
                 run gera-erro(input "E").
                 undo, RETURN "erro".
               end.
          
          assign ter-ade.cd-senha = cd-senha-aux.    
        end.

   /* ---------------------------------------------------------------------- */
   assign propost.dt-comercializacao = ter-ade.dt-inicio
          ter-ade.dt-fim             = ter-ade.dt-inicio
          dt-inicio-aux              = ter-ade.dt-inicio.
 
   /* ---- Inicializa Quantidade de vezes que o Laco vai ser Executado. ---- */
   assign qt-executada-aux = 0.

   /* ---------------------------------------------------------------------- */
   do while ter-ade.dt-fim < dt-minima-termo:
 
      /* ---------------------------------- CALCULA DATA DE FIM DO TERMO --- */
       run rtp/rtclvenc.p (input "termo",
                           input dt-inicio-aux,
                           input propost.cd-modalidade,
                           input propost.nr-proposta,
                           input no,                       
                           output ter-ade.dt-fim,
                           output lg-erro-aux,
                           output ds-mensagem-aux).
       if   lg-erro-aux
       then do:
               assign ds-mensagem-err-aux = ds-mensagem-aux.
               run gera-erro(input "E").
               undo, return "erro".
           end.

      assign dt-inicio-aux    = ter-ade.dt-fim
             qt-executada-aux = qt-executada-aux + 1.
   end.
 
   /* ---------------------- Atualiza a data fim do termo de adesÆo -------- */
   if   qt-executada-aux <> 0
   then do:
          assign ter-ade.dt-fim = ter-ade.dt-fim + qt-executada-aux - 1.
        end.

   /* ---------------------------------------------------------------------- */
   assign dt-fim-aux = ter-ade.dt-fim.

   /* --------------------------------- TESTAR PROPOSTA CANCELADA OU PEA --- */
   if   propost.dt-libera-doc <> ?
   then assign ter-ade.dt-fim  = propost.dt-libera-doc.
   else assign ter-ade.dt-fim  = dt-fim-aux.
 
   /* ---------------------------------------------------------------------- */
   assign dt-inicio-aux            = ter-ade.dt-inicio
          ter-ade.dt-validade-cart = ter-ade.dt-inicio.
 
   /**
    * Atualizar situacao na SIT-APROV-PROPOSTA.
    * Caso nao exista, criar nesse momento.
    */
   FIND FIRST sit-aprov-proposta EXCLUSIVE-LOCK
        WHERE sit-aprov-proposta.cd-modalidade = propost.cd-modalidade
          AND sit-aprov-proposta.nr-proposta   = propost.nr-proposta NO-ERROR.
   IF NOT AVAIL sit-aprov-proposta
   THEN DO:                      
          create sit-aprov-proposta.
          assign sit-aprov-proposta.id-sit-aprov-proposta    = next-value(seq-sit-aprov-proposta)
                 sit-aprov-proposta.cd-modalidade            = propost.cd-modalidade
                 sit-aprov-proposta.nr-proposta              = propost.nr-proposta
                 sit-aprov-proposta.cd-userid                = v_cod_usuar_corren
                 sit-aprov-proposta.dt-atualizacao           = today
                 sit-aprov-proposta.ds-observacoes           = "".
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
   
   /* ---- Inicializa Quantidade de vezes que o Laco vai ser Executado. ---- */
   assign qt-executada-aux = 0.

   /* ---------------------------------------------------------------------- */
   do while ter-ade.dt-validade-cart < dt-minima-termo:
 
      /* --------------------------------- CALCULA DATA DE FIM DO CARTAO --- */
      if   propost.lg-cartao
      then do:
              run rtp/rtclvenc.p (input "cartao",
                                  input dt-inicio-aux,
                                  input propost.cd-modalidade,
                                  input propost.nr-proposta,
                                  input no,                       
                                  output ter-ade.dt-validade-cart,
                                  output lg-erro-aux,
                                  output ds-mensagem-aux).

              if   lg-erro-aux
              then do:
                     assign ds-mensagem-err-aux = ds-mensagem-aux.
                     run gera-erro(input "E").
                     undo, return "erro".
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
                                  output lg-erro-aux,
                                  output ds-mensagem-aux).

              if lg-erro-aux
              then do:
                     assign ds-mensagem-err-aux = ds-mensagem-aux.
                     run gera-erro(input "E").
                     undo, return "erro".
                   end.
          end.
    
      assign dt-inicio-aux    = ter-ade.dt-validade-cart
             qt-executada-aux = qt-executada-aux + 1.
   end.
 
   /* ---------------------- Atualiza a data fim do termo de adesÆo -------- */
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

   /* -------------------- NEGOCIACAO ---------------------- */
   for each propunim 
      WHERE propunim.cd-modalidade = propost.cd-modalidade
        and propunim.nr-proposta   = propost.nr-proposta
        and propunim.cd-unimed     > 0
            exclusive-lock:
 
       /* --------- TESTAR PROPOSTA CANCELADA OU PEA --------- */
       if   propost.dt-libera-doc <> ?
       then assign propunim.dt-fim-rep = propost.dt-libera-doc.
       else assign propunim.dt-fim-rep = ter-ade.dt-fim.
 
       assign propunim.cd-userid      = v_cod_usuar_corren
              propunim.dt-atualizacao = today.
   end.
 
   /* ------------------------ MODULOS DA PROPOSTA ---------------- */
   for each pro-pla use-index pro-pla3 where
            pro-pla.cd-modalidade = propost.cd-modalidade
        and pro-pla.nr-proposta   = propost.nr-proposta
        and pro-pla.cd-modulo     > 0
            exclusive-lock:
 
       /* -------- TESTAR PROPOSTA CANCELADA OU PEA ---------- */
       if   propost.dt-libera-doc <> ?
       then do:
               if   propost.dt-libera-doc < today
               then assign pro-pla.cd-sit-modulo = 90.
               else assign pro-pla.cd-sit-modulo = 7.
 
               assign pro-pla.dt-fim = propost.dt-libera-doc.
            end.
       else do:
              if   pro-pla.dt-cancelamento = ?
              then assign pro-pla.cd-sit-modulo = 7
                          pro-pla.dt-fim        = ter-ade.dt-fim.
              else do:
                     if   pro-pla.dt-cancelamento < today
                     then assign pro-pla.cd-sit-modulo = 90.
                     else assign pro-pla.cd-sit-modulo = 7.
 
                     assign pro-pla.dt-fim = propost.dt-libera-doc.
                   end.
            end.
 
       assign pro-pla.cd-userid      = v_cod_usuar_corren
              pro-pla.dt-atualizacao = today.
       
       if   pro-pla.dt-inicio = ?                        
       then assign pro-pla.dt-inicio = ter-ade.dt-inicio.
   end.
 
   /* ------------------- PROCEDIMENTOS ESPECIAIS ---------- */
   for each pr-mo-am where
            pr-mo-am.cd-modalidade = propost.cd-modalidade
        and pr-mo-am.nr-proposta   = propost.nr-proposta
            exclusive-lock:
 
       assign pr-mo-am.cd-userid      = v_cod_usuar_corren
              pr-mo-am.dt-atualizacao = today.
 
       /* ------ TESTAR PROPOSTA CANCELADA OU PEA ---------- */
       if   propost.dt-libera-doc <> ?
       then assign pr-mo-am.dt-fim = propost.dt-libera-doc.
       else do:
              if   pr-mo-am.dt-cancelamento <> ?
              then assign pr-mo-am.dt-fim = propost.dt-libera-doc.
              else assign pr-mo-am.dt-fim = ter-ade.dt-fim.
            end.
   end.

   run imp-prop.
 
   if   lg-usuario-aux
   then display skip.
 
   /* ------------------------ BENEFICIARIOS ---------------------- */
   for each usuario use-index usuari30 where
            usuario.cd-modalidade  = propost.cd-modalidade
        and usuario.nr-proposta    = propost.nr-proposta
        and usuario.cd-sit-usuario = 1
            exclusive-lock:
 
       /* ------------------------------------------- BENEFICIARIO ATIVO --- */
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

              run verif-cob-usu-exc.

              /* -------------------------------- BENEFICIARIO REPASSADO --- */
              if   usuario.cd-unimed-destino <> 0
              then do:
                     find last usurepas where
                               usurepas.cd-modalidade
                             = usuario.cd-modalidade
                           and usurepas.nr-proposta
                             = usuario.nr-proposta
                           and usurepas.cd-usuario
                             = usuario.cd-usuario
                           and usurepas.cd-unidade-destino
                             = usuario.cd-unimed-destino
                               exclusive-lock no-error.
 
                     if   avail usurepas
                     then do:
                            find propunim where propunim.cd-modalidade
                                              = usurepas.cd-modalidade
                                            and propunim.nr-proposta
                                              = usurepas.nr-proposta
                                            and propunim.cd-unimed
                                              = usurepas.cd-unidade-destino
                                                no-lock no-error.

                            if avail propunim and
                               propunim.in-exporta-repasse = 0
                            then assign usurepas.in-tipo-impressao-carta = "N"
                                        usurepas.in-tipo-movto-carta     = "I". 

                            else do:
                                   if   usurepas.dt-saida = ?
                                   then assign
                                        usurepas.in-tipo-impressao-carta = "R"
                                        usurepas.in-tipo-movto-carta     = "I".    
                                   else assign
                                        usurepas.in-tipo-impressao-carta = "R"
                                        usurepas.in-tipo-movto-carta     = "E".
                                   
                                   assign usurepas.dt-carta-interc         = today
                                          usurepas.cd-userid-carta-interc  = v_cod_usuar_corren
                                          usurepas.dt-atualizacao          = today
                                          usurepas.cd-userid               = v_cod_usuar_corren.
                                 end.
                          end.
                   end.
 
              /* ------------------------------- MODULOS DO BENEFICIARIO --- */
              for each usumodu where
                       usumodu.cd-modalidade = usuario.cd-modalidade
                   and usumodu.nr-proposta   = usuario.nr-proposta
                   and usumodu.cd-usuario    = usuario.cd-usuario
                       exclusive-lock:
 
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
                  else assign
                       usumodu.cd-sit-modulo = 7.
 
                  assign usumodu.dt-fim         = ter-ade.dt-fim
                         usumodu.cd-userid      = v_cod_usuar_corren
                         usumodu.dt-atualizacao = today.
 
                  if   usumodu.dt-inicio = ?                        
                  then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                  if   usumodu.dt-inicio = usumodu.dt-cancelamento
                  then assign usumodu.aa-pri-fat = 0
                              usumodu.mm-pri-fat = 0.
                  else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                              usumodu.mm-pri-fat = month(usumodu.dt-inicio).
                  
              end.
         end.
       /* ------------------------------------ BENEFICIARIO COM EXCLUSAO --- */
       else do:
              /* --------------------------------- BENEFICIARIO EXCLUIDO --- */
              if   usuario.dt-exclusao-plano < today
              then do:
                     assign usuario.cd-sit-usuario = 90.   

                     for each usucarproc where usucarproc.cd-modalidade  = usuario.cd-modalidade
                                           and usucarproc.nr-proposta    = usuario.nr-proposta  
                                           and usucarproc.cd-usuario     = usuario.cd-usuario  
                                               exclusive-lock:

                         assign usucarproc.dt-inicio       = if   usuario.dt-inclusao-plano > usucarproc.dt-inicio
                                                             then usuario.dt-inclusao-plano
                                                             else usucarproc.dt-inicio 
                                usucarproc.dt-fim          = if   ter-ade.dt-fim <> ?
                                                             and  ter-ade.dt-fim < usucarproc.dt-fim
                                                             then ter-ade.dt-fim
                                                             else usucarproc.dt-fim
                                usucarproc.dt-cancelamento = if   usuario.dt-exclusao-plano < usucarproc.dt-cancelamento
                                                             then usuario.dt-exclusao-plano
                                                             else usucarproc.dt-cancelamento   
                                usucarproc.dt-atualizacao  = today
                                usucarproc.cd-userid       = v_cod_usuar_corren.
                     
                     end.
                   end.
              /* ------------------ BENEFICIARIO COM EXCLUSAO PROGRAMADA --- */
              else do:
                     if   usuario.aa-ult-fat = 0
                     then assign usuario.cd-sit-usuario = 5.  
                     else do:
                            if usuario.aa-ult-fat =
                               year (usuario.dt-inclusao-plano) and
                               usuario.mm-ult-fat = month(usuario.dt-inclusao-plano)
                            then usuario.cd-sit-usuario = 6.
                            else usuario.cd-sit-usuario = 7.
                          end.

                      run verif-cob-usu-exc.
                   end.
 
              /* ------------------------------- MODULOS DO BENEFICIARIO --- */
              for each usumodu where
                       usumodu.cd-modalidade = usuario.cd-modalidade
                   and usumodu.nr-proposta   = usuario.nr-proposta
                   and usumodu.cd-usuario    = usuario.cd-usuario
                       exclusive-lock:
 
                  /* ---------------------------------- MODULO CANCELADO --- */
                  if   usumodu.dt-cancelamento < today
                  then assign usumodu.cd-sit-modulo = 90.
                  /* -------------------- MODULO COM EXCLUSAO PROGRAMADA --- */
                  else assign usumodu.cd-sit-modulo = 7.
 
                  /* ------------------ TESTAR PROPOSTA CANCELADA OU PEA --- */
                  if   propost.dt-libera-doc <> ?
                  then assign usumodu.dt-fim = propost.dt-libera-doc.
                  else assign usumodu.dt-fim = ter-ade.dt-fim.
 
                  assign usumodu.dt-atualizacao = today
                         usumodu.cd-userid      = v_cod_usuar_corren.
 
                  if   usumodu.dt-inicio = ?                        
                  then assign usumodu.dt-inicio = ter-ade.dt-inicio.

                  if   usumodu.dt-inicio = usumodu.dt-cancelamento
                  then assign usumodu.aa-pri-fat = 0
                              usumodu.mm-pri-fat = 0.
                  else assign usumodu.aa-pri-fat = year (usumodu.dt-inicio)
                              usumodu.mm-pri-fat = month(usumodu.dt-inicio).
              end.
            end.
 
       assign usuario.nr-ter-adesao  = propost.nr-ter-adesao
              usuario.dt-aprovacao   = today
              usuario.cd-userid      = v_cod_usuar_corren
              usuario.dt-atualizacao = today
              usuario.dt-senha       = today.
       
       if   lg-mantem-senha-benef-aux 
       then assign usuario.cd-senha  = contrat.cd-senha.
       else do:
               if   in-geracao-senha-aux = 1 /* individual */
               then do:
                      run rtp/rtrandom.p (input 6,
                                          output cd-senha-aux,
                                          output lg-erro-rtsenha-aux,
                                          output ds-erro-aux).
                    
                      if lg-erro-rtsenha-aux 
                      then do:
                             assign lg-erro-rtsenha-aux = NO
                                    ds-mensagem-err-aux = ds-erro-aux.
                             run gera-erro(input "E").
                             undo, RETURN "erro".
                           end.
                      assign usuario.cd-senha = cd-senha-aux.
                    end.

               else if   usuario.cd-usuario = usuario.cd-titular  /* familia */
                    then do:
                           run rtp/rtrandom.p (input 6,
                                               output cd-senha-aux,
                                               output lg-erro-rtsenha-aux,
                                               output ds-erro-aux).
                           if lg-erro-rtsenha-aux 
                           then do:
                                  assign lg-erro-rtsenha-aux = NO
                                         ds-mensagem-err-aux = ds-erro-aux.
                                  run gera-erro(input "E").
                                  undo, RETURN "erro".
                                end.
     
                           assign usuario.cd-senha = cd-senha-aux.                                                                     
            
                           for each b-usuario where 
                                 b-usuario.cd-modalidade 
                               = usuario.cd-modalidade
                             and b-usuario.nr-proposta
                               = usuario.nr-proposta
                             and b-usuario.cd-titular
                               = usuario.cd-titular
                             and b-usuario.cd-usuario
                              <> usuario.cd-usuario
                                 exclusive-lock:
                             
                             assign b-usuario.cd-senha = usuario.cd-senha.
                           end.
                         end.
            end.    
       
       if   usuario.dt-inclusao-plano = usuario.dt-exclusao-plano 
       or   usuario.cd-sit-usuario =  5
       then assign usuario.aa-pri-fat = 0
                   usuario.mm-pri-fat = 0.
       else assign usuario.aa-pri-fat = year (usuario.dt-inclusao-plano)
                   usuario.mm-pri-fat = month(usuario.dt-inclusao-plano).
 
       if   lg-cpc-final-lib-doc-aux
       then do:
              run p-final-lib-doc (input  usuario.cd-modalidade,
                                   input  usuario.nr-proposta,
                                   input  usuario.cd-usuario,
                                   input  usuario.nm-usuario,
                                   output lg-erro-cpc-aux).
              if   lg-erro-cpc-aux
              then undo, return "erro".
            end.
 
       /* ----- CARTEIRA --------------------------------------------------- */
       /* ----- MONTA O CODIGO DA CARTEIRA E CALCULA O DIGITO -------------- */
       assign nr-via-carteira-aux = 1.
 
       run value (substring (paravpmc.nm-prog-monta-cart, 1, 2) + "p/" +
                             paravpmc.nm-prog-monta-cart + ".p")
                 (input  1,
                  input  recid (usuario),
                  input  0,
                  input  nr-via-carteira-aux,
                  input  no,
                  output cd-cart-inteira-aux,
                  output dv-cart-inteira-aux,
                  output cd-cart-impress-aux,
                  output lg-undo-retry).
 
       /* ----- VERIFICA SE A MODALIDADE E' MEDICINA OCUPACIONAL ----------- */
       if   lg-medocup-aux
       AND  not paravpmc.lg-imp-carteira-mo
       then assign lg-grava-carteira = no.
       ELSE assign lg-grava-carteira = yes.
 
       /* ----- GRAVA A TABELA DE CARTEIRA DO BENEFICIARIO ----------------- */
       create car-ide.
       assign car-ide.cd-unimed           = usuario.cd-unimed
              car-ide.cd-modalidade       = usuario.cd-modalidade
              car-ide.nr-ter-adesao       = usuario.nr-ter-adesao
              car-ide.cd-usuario          = usuario.cd-usuario
              car-ide.nr-carteira         = nr-via-carteira-aux
              car-ide.dv-carteira         = dv-cart-inteira-aux
              car-ide.lg-devolucao        = no
              car-ide.dt-devolucao        = ?
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
              then assign car-ide.cd-sit-carteira = 90.
              else assign car-ide.cd-sit-carteira = 1.
 
              assign car-ide.dt-cancelamento = usuario.dt-exclusao-plano.
            end.
       else assign car-ide.cd-sit-carteira = 1.
       
       if   lg-grava-carteira
       and  lg-imp-carteira
       then assign car-ide.nr-impressao = 0
                   car-ide.dt-emissao   = ?.
       else assign car-ide.nr-impressao = 1
                   car-ide.dt-emissao   = today.

       /* --------------------- CHAMADA  DA ROTINA RTVALDOC PARA CALCULAR DATAS- */
       dt-validade-valdoc = ter-ade.dt-validade-cart.
    
       validate car-ide.
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
                      ds-mensagem-err-aux = ds-mensagem-valdoc.
                      run gera-erro(input "E").
                      undo, return "erro".
                   end.
            end.
    
       /* ----------------------------------------------------------- */
       if   car-ide.dt-validade <> dt-validade-valdoc
       then do:
              if   dt-validade-valdoc <= ter-ade.dt-inicio
              then do:
                     ds-mensagem-err-aux = "Validade doc identif inferior" + 
                                           " ou igual ao inicio do termo." +
                                           " Validade Calculada: " + STRING(dt-validade-valdoc) +
                                           " Inicio Termo: "       + string(ter-ade.dt-inicio).
                     run gera-erro(input "E").
                     undo, return "erro".
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

       /* ---------------------------------------------------------------------- */
       if   lg-chama-mc0110fx-aux 
       THEN do:
              if   usuario.dt-exclusao-plano > today
              then.
              else do:
                     assign r-registro = recid(usuario)
                            r-proposta = recid(propost)
                            r-car-ide  = recid(car-ide).

                     run progx/mc0110fx.p (input r-registro,
                                           input "1",
                                           input r-proposta,
                                           input r-car-ide,
                                           input   ?,
                                           output p-log-1,
                                           output p-log-2,
                                           output l-erro-x).
                         
                     run progx/mc0110fx.p (input r-registro,
                                           input "2",
                                           input r-proposta,
                                           input r-car-ide,
                                           input   ?,
                                           output p-log-1,
                                           output p-log-2,
                                           output l-erro-x).
                   end.  
            end.
 
       if   lg-usuario-aux
       then run imp-usu.

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
              then do:
                     for each tmp-msg-usmovadm:
                         ds-mensagem-err-aux = tmp-msg-usmovadm.ds-mensagem +
                                               tmp-msg-usmovadm.ds-chave.
                         run gera-erro(input "E").
                     end.
              
                     undo, return "erro".
                   end.
            END.
   end. /* for each usuario */
 
   if   lg-usuario-aux
   then display skip(01).
 
   assign propost.mm-aa-ult-fat-mig  = "".
          /*propost.dt-libera-doc      = today.*/

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
                        assign ds-mensagem-err-aux = ds-erro-gera-aux.
                        run gera-erro(input "E").
                        next.   
                      end.
               end.
        end.

   return "".
   
end procedure.
 
/* ------------------------ EFETUA ATUALIZACOES PERTINENTES A CONFIRMACAO -- */
procedure confirma:
   assign propost.dt-confirmacao        = today
          propost.cd-userid-confirmacao = v_cod_usuar_corren
          propost.dt-atualizacao        = today
          propost.cd-userid             = v_cod_usuar_corren.
end procedure.
 
/* ---------------------------- EFETUA ATUALIZACOES DA ANALISE DE CREDITO -- */
procedure analise:
    DEF BUFFER b-contrat FOR contrat.

    FIND FIRST b-contrat EXCLUSIVE-LOCK
         WHERE rowid(b-contrat) = ROWID(contrat) NO-ERROR.
    IF NOT AVAIL b-contrat
    then do:
            assign ds-mensagem-err-aux = "Nao foi possivel acessar o contratante para atualizacao." +
                                         " Insc: " + STRING(contrat.nr-insc-contratante).
            run gera-erro(input "E").
            next.
         end.
   assign b-contrat.dt-analise-credito = today
          b-contrat.cd-userid-analise  = v_cod_usuar_corren
          b-contrat.cd-sit-cred        = cd-sit-cred-aux.
end procedure.
 
/* ----------------------------------- ALTERACOES PERTINENTES A APROVACAO -- */
procedure aprova:
   assign propost.dt-parecer         = propost.dt-proposta
          propost.cd-usuario-diretor = v_cod_usuar_corren
          propost.dt-aprovacao       = today.
end procedure.
 
/* ------------------------------------------------------------------------- */
procedure imp-prop:
   disp propost.nr-contrato-antigo
        propost.nr-proposta
        propost.nr-ter-adesao
        propost.nr-insc-contratante
        propost.cd-contratante
        with frame f-relat-prop.
 
   if   available contrat
   then disp contrat.nm-contratante
             with frame f-relat-prop.
 
   disp propost.cd-modalidade
        propost.cd-sit-proposta
        propost.cd-forma-pagto
        propost.cd-plano
        propost.cd-tipo-plano
        with frame f-relat-prop.
 
   find ter-ade where
        ter-ade.cd-modalidade = propost.cd-modalidade
    and ter-ade.nr-ter-adesao = propost.nr-ter-adesao
        no-lock no-error.
 
   if   avail ter-ade
   then disp ter-ade.dt-inicio
             ter-ade.dt-fim
             with frame f-relat-prop.
   else disp "" @ ter-ade.dt-inicio
             ter-ade.dt-fim
             with frame f-relat-prop.
 
   down with frame f-relat-prop.
end procedure.
 
/* ------------------------------------------------------------------------- */
procedure imp-usu:
   disp usuario.cd-carteira-antiga
        usuario.cd-usuario
        usuario.nm-usuario
        usuario.cd-grau-parentesco
        usuario.dt-nascimento
        usuario.dt-inclusao-plano
        usuario.dt-exclusao-plano
        usuario.cd-sit-usuario
        usuario.cd-padrao-cobertura
        with frame f-relat-usu.
   down with frame f-relat-usu.
end procedure.
 
/* ------------------------------------------------------------------------- */
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

/*--------------------------------------------------------------------------*/
procedure gera-erro:

  def input parameter cd-tipo-mensagem-par as char format "x(01)" no-undo.

  if cd-tipo-mensagem-par = "E"
  then assign ct-erros = ct-erros + 1.

  create wk-erros.
  assign wk-erros.cd-modalidade       = propost.cd-modalidade
         wk-erros.nr-proposta         = propost.nr-proposta
         wk-erros.cd-sit-proposta     = propost.cd-sit-proposta
         wk-erros.nr-insc-contratante = propost.nr-insc-contratante
         wk-erros.cd-contratante      = propost.cd-contratante
         wk-erros.cd-tipo-mensagem    = cd-tipo-mensagem-par
         wk-erros.ds-mensagem         = ds-mensagem-err-aux.

  assign ds-mensagem-err-aux = "".
  
end procedure.


procedure verif-cob-usu-exc:

       /* ------------ ATUALIZA DATAS DA TABELA DE COBERTURA POR BENEFICIARIOS ---- */
       for each usucarproc where usucarproc.cd-modalidade = usuario.cd-modalidade
                             and usucarproc.nr-proposta   = usuario.nr-proposta  
                             and usucarproc.cd-usuario    = usuario.cd-usuario    
                                 exclusive-lock:
       
           if   usuario.dt-inclusao-plano > usucarproc.dt-inicio
           then assign usucarproc.dt-inicio       = usuario.dt-inclusao-plano
                       usucarproc.dt-atualizacao  = today
                       usucarproc.cd-userid       = v_cod_usuar_corren.
          
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
       end.

end procedure.
 
/* ------------------------------------------------------------------------- */
procedure p-final-lib-doc:

    def input  parameter cd-modalidade-par as int  format "99"         no-undo.
    def input  parameter nr-proposta-par   as int  format "99999999"   no-undo.
    def input  parameter cd-usuario-par    as int  format "999999"     no-undo.
    def input  parameter nm-usuario-par    as char format "x(70)"      no-undo.
    def output parameter lg-erro-par       as log                      no-undo.
    
    for each tmp-cpc-cg0210c-entrada exclusive-lock:
        delete tmp-cpc-cg0210c-entrada.
    end.

    for each tmp-cpc-cg0210c-saida exclusive-lock:
        delete tmp-cpc-cg0210c-saida.
    end.

    create tmp-cpc-cg0210c-entrada.
    assign tmp-cpc-cg0210c-entrada.nm-ponto-chamada-cpc = "FINAL-LIB-DOC"
           tmp-cpc-cg0210c-entrada.cd-modalidade        = cd-modalidade-par
           tmp-cpc-cg0210c-entrada.nr-proposta          = nr-proposta-par
           tmp-cpc-cg0210c-entrada.cd-usuario           = cd-usuario-par
           tmp-cpc-cg0210c-entrada.nm-usuario           = nm-usuario-par .

    run cpc/cpc-cg0210c.p (input  table tmp-cpc-cg0210c-entrada,
                           output table tmp-cpc-cg0210c-saida) no-error.

    if   error-status:error
    then do:
           message "Erro na Chamada do programa CPC-CG0210C no Ponto FINAL-LIB-DOC: "
                   + substring(error-status:get-message(error-status:num-messages),1,27)
               view-as alert-box title " Atencao !!! ".
           assign lg-erro-par = yes.
           return.
         end.

    find first tmp-cpc-cg0210c-saida no-lock no-error.
    if   avail tmp-cpc-cg0210c-saida
    then do:
           if   tmp-cpc-cg0210c-saida.lg-undo-retry
           then do:
                  if   tmp-cpc-cg0210c-saida.lg-continua
                  then return.
                  message "Erro no Ponto FINAL-LIB-DOC do programa CPC-CG0210C: " 
                          + tmp-cpc-cg0210c-saida.ds-mensagem
                      view-as alert-box title " Atencao !!! ".
                  assign lg-erro-par = yes.
                  return.
                end.
         end.
    else do:
           message "Tabela Temporaria de Saida nao disponivel. Ponto FINAL-LIB-DOC do programa CPC-CG0210C"
               view-as alert-box title " Atencao !!! ".
           assign lg-erro-par = yes.
           return.
         end.

end procedure.

/*------------------------------------------------------------------ EOF ---*/
