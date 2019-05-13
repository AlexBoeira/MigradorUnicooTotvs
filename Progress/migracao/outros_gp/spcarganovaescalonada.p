/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i spcarganovaescalonada 2.00.00.011 } /*** 010011 ***/
/******************************************************************************
    Programa .....: spcarganovaescalonada.p
    Data .........: 26/06/2015
    Sistema ......: Gestao de Planos
    Empresa ......: DATASUL Medical
    Programador ..: Tiago Drehmer
    Objetivo .....: Carga das tabelas fxparpro, fxpalovp, fxpar-pr e fxpalopr
                    para as novas tabelas de participacao escalonada
******************************************************************************/
hide all no-pause.

{hdp/hdvarregua.i}
{hdp/hdregexecpar.i}
{hdp/hdregexecpar.f}
{hdp/hdvarrel.i}

{hdp/hd9011.i "principal-vp0410b;executa-vp0410b;" }

nm-cab-usuario = "Carga parametrizacoes nova participacao escalonada".
nm-prog        = " SPCARGANOVAESCALONADA ".
c-versao       = c_prg_vrs.
{hdp/hdlog.i}

{hdp/hdtitrel.i}

/* ------------------------------------------------------------------ VARIAVEIS AUXILIARES --- */
def var in-tabela-aux                      as int format "9"                           no-undo.
def var cd-modalidade-ini    init 01     like modalid.cd-modalidade                    no-undo.
def var cd-modalidade-fim    init 99     like modalid.cd-modalidade                    no-undo.
def var cd-modalidade-z                  like modalid.cd-modalidade                    no-undo.
def var lg-simula-aux                      as log  format "Sim/Nao"  initial yes       no-undo.
def var lg-consid-canc                     as log  format "Sim/Nao"  initial no        no-undo.
def var dt-inic-regra-aux                  as date format "99/99/9999" initial 01/01/2013   no-undo.

def var lg-selecao-aux                     as log  format "Sim/Nao"                    no-undo.
def var lg-parametro-aux                   as log  format "Sim/Nao"                    no-undo.
def var lg-executa-aux                     as log  format "Sim/Nao"                    no-undo.
def var lg-arquivo-aux                     as log  format "Sim/Nao"                    no-undo.

def var ds-cabecalho                       as char format "x(60)"                      no-undo.
def var ds-rodape                          as char format "x(132)"                     no-undo.

def var ds-tabelas-aux                       as char format "X(38)"                    no-undo
    initial "Todas; Escalonada Proposta (fxparpro);Escalonada Proposta\Local Atendimento (fxpalovp);Escalonada Estrutura (fxpar_pr;Escalonada Estrutura\Local Atendimento (fxpalopr)".
def var lg-erro-aux                        as log                                      no-undo.
def var ds-erro-aux                        as char format "x(50)"                      no-undo.
def var lg-retorna-aux                     as log                                      no-undo.
def var lg-modulo-agrupado                 as log                                      no-undo.

def var ind-acao-movto-aux                 as char                                     no-undo.
def var cdd-seq-faixa-aux                  as dec                                      no-undo.
def var cdd-seq-modul-aux                  as dec                                      no-undo.
def var cd-esp-amb-aux                   like moviproc.cd-esp-amb                      no-undo.
def var cd-grupo-proc-amb-aux            like moviproc.cd-grupo-proc-amb               no-undo.
def var cd-procedimento-aux              like moviproc.cd-procedimento                 no-undo.
def var dv-procedimento-aux              like moviproc.dv-procedimento                 no-undo.
def var cd-grupo-esp-amb-aux             like ambproce.cd-grupo-esp-amb                no-undo.
def var cd-subgrupo-esp-amb-aux          like ambproce.cd-subgrupo-esp-amb             no-undo.
def var nr-ter-adesao-aux                like propost.nr-ter-adesao                    no-undo.
def var cd-plano-aux                     like propost.cd-plano                         no-undo.
def var cd-tipo-plano-aux                like propost.cd-tipo-plano                    no-undo.

def var qtd-atu-aux                        as int extent 4                             no-undo.
def var qtd-erro-aux                       as int extent 4                             no-undo.
def var qtd-tot-atu-aux                    as int                                      no-undo.
def var qtd-tot-erro-aux                   as int                                      no-undo.

def var cdd-seq-regra-escalnda-aux       like regra-particip-escalnda.cdd-seq-regra-escalnda no-undo.
/* ------------------------------------------------------------- DEFINICAO DE TEMP-TABLE'S --- */
def temp-table tmpRelatorioAcomp no-undo
    field in-tabela               as int
    field cd-modalidade         like propost.cd-modalidade
    field nr-proposta           like propost.nr-proposta
    field cd-plano              like propost.cd-plano
    field cd-tipo-plano         like propost.cd-tipo-plano
    field cd-local-atendimento  like fxpalovp.cd-local-atendimento
    field dt-limite             like fxparpro.dt-limite
    field cd-modulo             like fxparpro.cd-modulo
    field in-tipo-movto         like fxparpro.in-tipo-movto
    field cd-grp-tip-movto      like fxparpro.cd-gr-proc-tp-insumo
    field cd-movto              like fxparpro.cd-proced-insumo
    field qt-faixa-inicial      like fxparpro.qt-faixa-inicial
    field qt-faixa-final        like fxparpro.qt-faixa-final
    field ds-particip-ele         as char
    field ds-particip-urg         as char    
    field ind-atualizado          as int /* 1 - regra, 2-modulo, 3-faixa e 4-modulo e movto*/
    field lg-proposta-cancelada   as log format "Sim/Nao"         
    index relat1
          in-tabela
          cd-modalidade
          nr-proposta
          cd-plano
          cd-tipo-plano
          cd-local-atendimento
          cd-modulo
          in-tipo-movto
          cd-grp-tip-movto
          cd-movto
          qt-faixa-inicial.

def temp-table tmpRelatorioErro no-undo
    field in-tabela               as int
    field cd-modalidade         like propost.cd-modalidade
    field nr-proposta           like propost.nr-proposta
    field cd-plano              like propost.cd-plano
    field cd-tipo-plano         like propost.cd-tipo-plano
    field cd-local-atendimento  like fxpalovp.cd-local-atendimento
    field dt-limite             like fxparpro.dt-limite
    field cd-modulo             like fxparpro.cd-modulo
    field in-tipo-movto         like fxparpro.in-tipo-movto
    field cd-grp-tip-movto      like fxparpro.cd-gr-proc-tp-insumo
    field cd-movto              like fxparpro.cd-proced-insumo
    field qt-faixa-inicial      like fxparpro.qt-faixa-inicial
    field qt-faixa-final        like fxparpro.qt-faixa-final
    field ds-erro                 as char format "x(50)"
    index relat1
          in-tabela
          cd-modalidade.

/* ------------------------------------------------------------ FRAME'S RELATORIO DE ERROS --- */
form header
     fill("-", 132) format "x(132)"         skip
            ds-cabecalho                    format "x(60)"  at 01
            "Folha:"                                        at 123
            page-number                          at 129 format ">>>9" skip
            fill("-", 112) format "x(112)"
            today "-" string(time, "HH:MM:SS")              skip(1)
            with stream-io no-labels width 132 no-box page-top frame f-cabecalho.

form "Tabela       :"                   at 5
     ds-tabelas-aux                     at 20 skip
     "Inicio Regras:"                   at 5
     dt-inic-regra-aux                  at 20 skip
     "Simulacao    :"                   at 5
     lg-simula-aux                      at 20 skip
     "Considera Propostas Canceladas:"  at 5
     lg-consid-canc                     at 36
     header
     "*" + fill("-",18) format "x(19)" " Parametros "
     fill("-",18) + "*" format "x(19)" skip
     with no-labels column 30 width 58 down no-box attr-space frame f-mapa-par.

form "Inicial      Final"    at 17
     "Modalidade:"           at 5
     cd-modalidade-ini       at 22
     cd-modalidade-fim       at 33 skip
     header
     "*" + fill("-",18) format "x(19)" " Mapa de Selecao "
     fill("-",18) + "*" format "x(19)" skip
     with no-labels column 30 width 58 down no-box attr-space frame f-mapa.

form header ds-rodape format "x(132)"
            with stream-io no-labels width 132 no-box page-bottom frame f-rodape.

def frame f-relatorio-erro-fxparpro
    tmpRelatorioErro.cd-modalidade           column-label "Mod."
    tmpRelatorioErro.nr-proposta             column-label "Proposta"
    tmpRelatorioErro.cd-modulo               column-label "Modulo"
    tmpRelatorioErro.in-tipo-movto           column-label "Tp!Mov"
    tmpRelatorioErro.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioErro.cd-movto                column-label "Movto"
    tmpRelatorioErro.dt-limite               column-label "Data!Limite"
    tmpRelatorioErro.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioErro.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioErro.ds-erro                 column-label "Erro"          skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-erro-fxpalovp
    tmpRelatorioErro.cd-modalidade           column-label "Mod."
    tmpRelatorioErro.nr-proposta             column-label "Proposta"
    tmpRelatorioErro.cd-local-atendimento    column-label "Local!Atend."
    tmpRelatorioErro.cd-modulo               column-label "Modulo"
    tmpRelatorioErro.in-tipo-movto           column-label "Tp!Mov"
    tmpRelatorioErro.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioErro.cd-movto                column-label "Movto"
    tmpRelatorioErro.dt-limite               column-label "Data!Limite"
    tmpRelatorioErro.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioErro.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioErro.ds-erro                 column-label "Erro"          skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-erro-fxpar-pr
    tmpRelatorioErro.cd-modalidade           column-label "Mod."
    tmpRelatorioErro.cd-plano                column-label "Plano"
    tmpRelatorioErro.cd-tipo-plano           column-label "Tp!Plano"
    tmpRelatorioErro.cd-modulo               column-label "Modulo"
    tmpRelatorioErro.in-tipo-movto           column-label "Tp!Mov"
    tmpRelatorioErro.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioErro.cd-movto                column-label "Movto"
    tmpRelatorioErro.dt-limite               column-label "Data!Limite"
    tmpRelatorioErro.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioErro.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioErro.ds-erro                 column-label "Erro"          skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-erro-fxparlopr
    tmpRelatorioErro.cd-modalidade           column-label "Mod."
    tmpRelatorioErro.cd-plano                column-label "Plano"
    tmpRelatorioErro.cd-tipo-plano           column-label "Tp!Plano"
    tmpRelatorioErro.cd-local-atendimento    column-label "Local!Atend."
    tmpRelatorioErro.cd-modulo               column-label "Modulo"
    tmpRelatorioErro.in-tipo-movto           column-label "Tp!Mov"
    tmpRelatorioErro.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioErro.cd-movto                column-label "Movto"
    tmpRelatorioErro.dt-limite               column-label "Data!Limite"
    tmpRelatorioErro.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioErro.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioErro.ds-erro                 column-label "Erro"          skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-fxparpro
    tmpRelatorioAcomp.cd-modalidade           column-label "Mod."
    tmpRelatorioAcomp.nr-proposta             column-label "Proposta"
    tmpRelatorioAcomp.cd-modulo               column-label "Modulo"
    tmpRelatorioAcomp.in-tipo-movto           column-label "Tp!Mov."
    tmpRelatorioAcomp.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioAcomp.cd-movto                column-label "Movto"
    tmpRelatorioAcomp.dt-limite               column-label "Data!Limite"
    tmpRelatorioAcomp.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioAcomp.qt-faixa-final          column-label "Faixa!Final"     
    tmpRelatorioAcomp.ds-particip-ele         column-label "Eletiva"
    tmpRelatorioAcomp.ds-particip-urg         column-label "Urgencia"
    tmpRelatorioAcomp.lg-proposta-cancelada   column-label "Proposta!Cancelada" skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-fxpalovp
    tmpRelatorioAcomp.cd-modalidade           column-label "Mod."
    tmpRelatorioAcomp.nr-proposta             column-label "Proposta"
    tmpRelatorioAcomp.cd-local-atendimento    column-label "Local!Atend."
    tmpRelatorioAcomp.cd-modulo               column-label "Modulo"
    tmpRelatorioAcomp.in-tipo-movto           column-label "Tp!Mov."
    tmpRelatorioAcomp.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioAcomp.cd-movto                column-label "Movto"
    tmpRelatorioAcomp.dt-limite               column-label "Data!Limite"
    tmpRelatorioAcomp.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioAcomp.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioAcomp.ds-particip-ele         column-label "Eletiva"
    tmpRelatorioAcomp.ds-particip-urg         column-label "Urgencia"
    tmpRelatorioAcomp.lg-proposta-cancelada   column-label "Proposta!Cancelada" skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-fxpar-pr
    tmpRelatorioAcomp.cd-modalidade           column-label "Mod."
    tmpRelatorioAcomp.cd-plano                column-label "Plano"
    tmpRelatorioAcomp.cd-tipo-plano           column-label "Tp!Plano"
    tmpRelatorioAcomp.cd-modulo               column-label "Modulo"
    tmpRelatorioAcomp.in-tipo-movto           column-label "Tp!Mov."
    tmpRelatorioAcomp.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioAcomp.cd-movto                column-label "Movto"
    tmpRelatorioAcomp.dt-limite               column-label "Data!Limite"
    tmpRelatorioAcomp.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioAcomp.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioAcomp.ds-particip-ele         column-label "Eletiva"
    tmpRelatorioAcomp.ds-particip-urg         column-label "Urgencia"
    tmpRelatorioAcomp.lg-proposta-cancelada   column-label "Proposta!Cancelada" skip
    with no-box stream-io overlay down width 132.

def frame f-relatorio-fxpalopr
    tmpRelatorioAcomp.cd-modalidade           column-label "Mod."
    tmpRelatorioAcomp.cd-plano                column-label "Plano"
    tmpRelatorioAcomp.cd-tipo-plano           column-label "Tp!Plano"
    tmpRelatorioAcomp.cd-local-atendimento    column-label "Local!Atend."
    tmpRelatorioAcomp.cd-modulo               column-label "Modulo"
    tmpRelatorioAcomp.in-tipo-movto           column-label "Tp!Mov."
    tmpRelatorioAcomp.cd-grp-tip-movto        column-label "Grp/Tip!Movto"
    tmpRelatorioAcomp.cd-movto                column-label "Movto"
    tmpRelatorioAcomp.dt-limite               column-label "Data!Limite"
    tmpRelatorioAcomp.qt-faixa-inicial        column-label "Faixa!Inicial"
    tmpRelatorioAcomp.qt-faixa-final          column-label "Faixa!Final"
    tmpRelatorioAcomp.ds-particip-ele         column-label "Eletiva"
    tmpRelatorioAcomp.ds-particip-urg         column-label "Urgencia"
    tmpRelatorioAcomp.lg-proposta-cancelada   column-label "Proposta!Cancelada" skip
    with no-box stream-io overlay down width 132.

/* --------------------------------------------------------------------------------- FRAME --- */
def rectangle r-f-selecao
      edge-pixels 3 graphic-edge no-fill size 40 by 5.

def frame f-selecao
    "Inicial   Final"                                at row 1.9    col 14
    cd-modalidade-ini                                label "Modalidade"
       view-as fill-in size 3 by 1.3   native
       tooltip "Modalidade"                          at row 3.5 column 3

    cd-modalidade-fim                                no-label
       view-as fill-in size 3 by 1.3 native
       tooltip "Modalidade final"                    at row 3.5 column 25

    r-f-selecao at row 1.3 col 1.3
       with  three-d overlay row 8 side-labels 1 down centered title "Selecao carga nova participacao escalonada".


def rectangle r-f-parametro
      edge-pixels 3 graphic-edge no-fill size 76 by 7.

def frame f-parametro
    in-tabela-aux               label "Tabelas"
    view-as combo-box list-item-pairs "Todas",0,
                                      "Escalonada Proposta (fxparpro)",1,
                                      "Escalonada Proposta/Local Atendimento (fxpalovp)",2,
                                      "Escalonada Estrutura (fxpar_pr)",3,
                                      "Escalonada Estrutura/Local Atendimento (fxpalopr)",4
                                       at row 1.9    col 8
    dt-inic-regra-aux                                Label "Inicio Regras"
                                       view-as fill-in size 12 by 1.3 native    
                                       at row 3.6    col 2
    lg-simula-aux                                    label "Simulacao"
       view-as fill-in size 4 by 1.3 native
       tooltip "Simulacao"                           at row 5.2 column 6

    lg-consid-canc                                  label "Considera Propostas Canceladas"
       view-as fill-in size 4 by 1.3 native
       tooltip "Desconsidera parametrizacao propostas canceladas"
                                                     at row 5.2 column 22
    r-f-parametro at row 1.3 col 1.3
    with  three-d overlay row 10 side-labels 1 down centered title "Parametros carga nova participacao escalonada".

def buffer b-regra-particip-escalnda for regra-particip-escalnda.

/* ----------------------- FUNCOES -------------------- */
/* Funcao para converter o campo metodo de controle da properus para a tabela regra-particip-escalnda */
function metodo-controle returns char (input in-controle-aux as int ):
  case in-controle-aux :
  when 1 then return "I".
  when 2 then return "I".
  when 3 then return "A".
  when 4 then return "C".
  end case.
end function.

/* ----------------------- FUNCAO PARA BUSCAR COTACAO DA MOEDA --------------------------*/
function ds-moeda returns char (input cd-moeda-par as int):
  
  for first dzmoeda fields (descricao) no-lock
      where dzmoeda.mo-codigo   = cd-moeda-par:
      return dzmoeda.descricao.
  end.
  return "".
end.

/* ------------------- PROGRAMA PRINCIPAL ------------ */
{hdp/hdvararq.i "spool/" "SPCARGANOVAESCALONADA" "LST" " " "1"}

repeat on endkey undo, next :

   {hdp/hdbotexecpar.i}

   case c-opcao:

        when "Arquivo"
        then do:
               assign lg-arquivo-aux = no.

               {hdp/hdpedarq.i}

               if keyfunction(lastkey) = "end-error"
               then assign lg-arquivo-aux = no.
               else assign lg-arquivo-aux = yes.
             end.

        when "Parametro"
        then do:
               if not lg-arquivo-aux
               then do:
                      message "Voce deve passar primeiro pela opcao Arquivo." view-as alert-box title " Atencao !!! ".
                      undo,retry.
                    end.

               view frame f-parametro.
               assign lg-parametro-aux = no.

               do on error undo, retry with frame f-parametro:
                  update in-tabela-aux go-on ("return").
                  if in-tabela-aux >= 3
                  then hide lg-consid-canc.
                  else view lg-consid-canc.
                  do on error undo, retry:
                     update dt-inic-regra-aux.
                     do on error undo, retry:
                        update lg-simula-aux.
                        do on error undo, retry:
                           if in-tabela-aux < 3
                           then update lg-consid-canc.
                        end.
                     end.
                  end.
               end.
               assign lg-parametro-aux = yes.
             end. /* when "Parametro" */

        when "Selecao"
        then do:
               if not lg-arquivo-aux
               then do:
                      message "Voce deve passar primeiro pela opcao Arquivo." view-as alert-box title " Atencao !!! ".
                      undo,retry.
                    end.

               if not lg-parametro-aux
               then do:
                      message "Voce deve passar primeiro pelos Parametro." view-as alert-box title " Atencao !!! ".
                      undo,retry.
                    end.

               view frame f-selecao.
               assign lg-selecao-aux = no.

               do on error undo, retry with frame f-selecao:
                  update cd-modalidade-ini.
                  if cd-modalidade-ini = 0
                  or cd-modalidade-ini = ?
                  then do:
                         message "Campo Obrigatorio."  view-as alert-box title " Atencao !!! ".
                         undo,retry.
                       end.

                  update cd-modalidade-fim.
                  if cd-modalidade-fim = 0
                  or cd-modalidade-fim = ?
                  then do:
                         message "Campo Obrigatorio."  view-as alert-box title " Atencao !!! ".
                         undo,retry.
                       end.

                  if cd-modalidade-fim < cd-modalidade-ini
                  then do:
                         message "Campo Final deve ser maior que Inicial."  view-as alert-box title " Atencao !!! ".
                         undo,retry.
                       end.
               end.
               assign lg-selecao-aux = yes.
             end. /* when "Selecao" */


        when "Executa"
        then do:
               if not lg-arquivo-aux
               then do:
                      message "Voce deve passar primeiro pela opcao Arquivo." view-as alert-box title " Atencao !!! ".
                      undo,retry.
                    end.

               if not lg-parametro-aux
               then do:
                      message "Voce deve passar primeiro pelos Parametros." view-as alert-box title " Atencao !!! ".
                      undo,retry.
                    end.

               if not lg-selecao-aux
               then do:
                      message "Voce deve passar primeiro pela Selecao." view-as alert-box title " Atencao !!! ".
                      undo,retry.
                    end.

               empty temp-table tmpRelatorioErro.
               empty temp-table tmpRelatorioAcomp.

               assign lg-executa-aux = no.
               if not lg-simula-aux
               then message "Confirma a execucao do processo de carga das tabelas de parametrizacao de participacao escalonada para as novas tabelas?"
                            view-as alert-box question buttons yes-no title "Atencao!!!" update lg-executa-aux.
               else message "Confirma a simulacao do processo de carga das tabelas de parametrizacao de participacao escalonada para as novas tabelas?"
                            view-as alert-box question buttons yes-no title "Atencao!!!" update lg-executa-aux.
               if not lg-executa-aux
               then undo, retry.

               message "Aguarde. Executando carga parametros participacao escalonada...".

               hide message no-pause.

               if lg-simula-aux
               then do transaction: /* ---- simulacao faz rollback da transacao apos a inclusao ---- */
                       run carga-tabelas.
                       run imprime-relatorios.
                       undo, leave.                   
                    end.
               else do:
                      run carga-tabelas.
                      run imprime-relatorios.
                    end.
               message "Processo concluido." view-as alert-box info buttons ok.
        end.
        when "Fim"
        then do:
               hide all no-pause.
               leave.
             end.
   end case.
end.

procedure carga-tabelas:
   def var ix as int no-undo.
   do ix = 1 to 4:
     assign qtd-atu-aux[ix]  = 0
            qtd-erro-aux[ix] = 0.
   end.

  for each modalid fields(cd-modalidade) no-lock
     where modalid.cd-modalidade >= cd-modalidade-ini
       and modalid.cd-modalidade <= cd-modalidade-fim:
     /* ------------------------------------------ INICIO FXPARPRO ----------------------------------------- */
     if in-tabela-aux = 0 or in-tabela-aux = 1
     then do:
            for each fxparpro fields(cd-modalidade nr-proposta cd-modulo in-tipo-movto cd-gr-proc-tp-insumo cd-proced-insumo
                                     qt-faixa-inicial qt-faixa-final dt-limite lg-percentual-cob-ele pc-part-cob-ele cd-moeda-part-cob-ele qt-part-cob-ele
                                     lg-percentual-cob-urg pc-part-cob-urg cd-moeda-part-cob-urg qt-part-cob-urg) no-lock
               where fxparpro.cd-modalidade = modalid.cd-modalidade
                 and fxparpro.dt-limite >= today
                  by fxparpro.cd-modalidade
                  by fxparpro.nr-proposta
                  by fxparpro.cd-modulo
                  by fxparpro.in-tipo-movto
                  by fxparpro.cd-gr-proc-tp-insumo
                  by fxparpro.cd-proced-insumo
                  by fxparpro.qt-faixa-inicial
                  by fxparpro.qt-faixa-final:

               if can-do("202,211,212",string(fxparpro.cd-modulo))
               or fxparpro.cd-modalidade = 30               
               then next.

               if fxparpro.cd-gr-proc-tp-insumo = 1
              and fxparpro.cd-proced-insumo = 10014
               then next.
                 
               run processa-registro (input 1,                                /* fxparpro              */
                                      input fxparpro.cd-modalidade,           /* cd-modalidade         */
                                      input fxparpro.nr-proposta,             /* nr-proposta           */
                                      input 0,                                /* cd-plano              */
                                      input 0,                                /* cd-tipo-plano         */
                                      input 0,                                /* cd-local-atendimento  */
                                      input fxparpro.dt-limite,               /* dt-limite             */
                                      input fxparpro.cd-modulo,               /* cd-modulo             */
                                      input fxparpro.in-tipo-movto,           /* in-tipo-movto         */
                                      input fxparpro.cd-gr-proc-tp-insumo,    /* cd-gr-proc-tp-insumo  */
                                      input fxparpro.cd-proced-insumo,        /* cd-proced-insumo      */
                                      input fxparpro.qt-faixa-inicial,        /* qt-faixa-inicial      */
                                      input fxparpro.qt-faixa-final,          /* qt-faixa-final        */
                                      input fxparpro.lg-percentual-cob-ele,   /* lg-percentual-cob-ele */
                                      input fxparpro.pc-part-cob-ele,         /* pc-part-cob-ele       */
                                      input fxparpro.cd-moeda-part-cob-ele,   /* cd-moeda-part-cob-ele */
                                      input fxparpro.qt-part-cob-ele,         /* qt-part-cob-ele       */
                                      input fxparpro.lg-percentual-cob-urg,   /* lg-percentual-cob-urg */
                                      input fxparpro.pc-part-cob-urg,         /* pc-part-cob-urg       */
                                      input fxparpro.cd-moeda-part-cob-urg,   /* cd-moeda-part-cob-urg */
                                      input fxparpro.qt-part-cob-urg).        /* qt-part-cob-urg       */
            end.
          end.
     /* ------------------------------------------ FIM FXPARPRO ----------------------------------------- */

     /* ------------------------------------------ INICIO FXPALOVP ----------------------------------------- */
     if in-tabela-aux = 0 or in-tabela-aux = 2
     then do:
            for each fxpalovp fields(cd-modalidade nr-proposta cd-local-atendimento cd-modulo in-tipo-movto cd-gr-proc-tp-insumo cd-proced-insumo
                                     qt-faixa-inicial qt-faixa-final dt-limite lg-percentual-cob-ele pc-part-cob-ele cd-moeda-part-cob-ele qt-part-cob-ele
                                     lg-percentual-cob-urg pc-part-cob-urg cd-moeda-part-cob-urg qt-part-cob-urg) no-lock
               where fxpalovp.cd-modalidade = modalid.cd-modalidade
                 and fxpalovp.dt-limite >= today
                  by fxpalovp.cd-modalidade
                  by fxpalovp.nr-proposta
                  by fxpalovp.cd-local-atendimento
                  by fxpalovp.cd-modulo
                  by fxpalovp.in-tipo-movto
                  by fxpalovp.cd-gr-proc-tp-insumo
                  by fxpalovp.cd-proced-insumo
                  by fxpalovp.qt-faixa-inicial
                  by fxpalovp.qt-faixa-final:

               if can-do("202,211,212",string(fxpalovp.cd-modulo))
               or fxpalovp.cd-modalidade = 30
               then next.                    

               if fxpalovp.cd-gr-proc-tp-insumo = 1
              and fxpalovp.cd-proced-insumo = 10014
               then next.
                 
               run processa-registro (input 2,                                /* fxpalovp              */
                                      input fxpalovp.cd-modalidade,           /* cd-modalidade         */
                                      input fxpalovp.nr-proposta,             /* nr-proposta           */
                                      input 0,                                /* cd-plano              */
                                      input 0,                                /* cd-tipo-plano         */
                                      input fxpalovp.cd-local-atendimento,    /* cd-local-atendimento  */
                                      input fxpalovp.dt-limite,               /* dt-limite             */
                                      input fxpalovp.cd-modulo,               /* cd-modulo             */
                                      input fxpalovp.in-tipo-movto,           /* in-tipo-movto         */
                                      input fxpalovp.cd-gr-proc-tp-insumo,    /* cd-gr-proc-tp-insumo  */
                                      input fxpalovp.cd-proced-insumo,        /* cd-proced-insumo      */
                                      input fxpalovp.qt-faixa-inicial,        /* qt-faixa-inicial      */
                                      input fxpalovp.qt-faixa-final,          /* qt-faixa-final        */
                                      input fxpalovp.lg-percentual-cob-ele,   /* lg-percentual-cob-ele */
                                      input fxpalovp.pc-part-cob-ele,         /* pc-part-cob-ele       */
                                      input fxpalovp.cd-moeda-part-cob-ele,   /* cd-moeda-part-cob-ele */
                                      input fxpalovp.qt-part-cob-ele,         /* qt-part-cob-ele       */
                                      input fxpalovp.lg-percentual-cob-urg,   /* lg-percentual-cob-urg */
                                      input fxpalovp.pc-part-cob-urg,         /* pc-part-cob-urg       */
                                      input fxpalovp.cd-moeda-part-cob-urg,   /* cd-moeda-part-cob-urg */
                                      input fxpalovp.qt-part-cob-urg).        /* qt-part-cob-urg       */
            end.
          end.
         /* ------------------------------------------ FIM FXPALOVP ----------------------------------------- */

         /* ---------------------------------------- INICIO FXPAR-PR ---------------------------------------- */
     if in-tabela-aux = 0 or in-tabela-aux = 3
     then do:
            for each fxpar-pr fields(cd-modalidade cd-plano cd-tipo-plano cd-modulo in-tipo-movto cd-gr-proc-tp-insumo cd-proced-insumo
                                     qt-faixa-inicial qt-faixa-final dt-limite lg-percentual-cob-ele pc-part-cob-ele cd-moeda-part-cob-ele qt-part-cob-ele
                                     lg-percentual-cob-urg pc-part-cob-urg cd-moeda-part-cob-urg qt-part-cob-urg) no-lock
               where fxpar-pr.cd-modalidade = modalid.cd-modalidade
                 and fxpar-pr.dt-limite >= today
                  by fxpar-pr.cd-modalidade
                  by fxpar-pr.cd-plano
                  by fxpar-pr.cd-tipo-plano
                  by fxpar-pr.cd-modulo
                  by fxpar-pr.in-tipo-movto
                  by fxpar-pr.cd-gr-proc-tp-insumo
                  by fxpar-pr.cd-proced-insumo
                  by fxpar-pr.qt-faixa-inicial
                  by fxpar-pr.qt-faixa-final:

               if can-do("202,211,212",string(fxpar-pr.cd-modulo))
               or fxpar-pr.cd-modalidade = 30               
               then next.
               
               if fxpar-pr.cd-gr-proc-tp-insumo = 1
              and fxpar-pr.cd-proced-insumo = 10014
               then next.
                                                           
               run processa-registro (input 3,                                /* fxpar-pr              */
                                      input fxpar-pr.cd-modalidade,           /* cd-modalidade         */
                                      input 0,                                /* nr-proposta           */
                                      input fxpar-pr.cd-plano,                /* cd-plano              */
                                      input fxpar-pr.cd-tipo-plano,           /* cd-tipo-plano         */
                                      input 0,                                /* cd-local-atendimento  */
                                      input fxpar-pr.dt-limite,               /* dt-limite             */
                                      input fxpar-pr.cd-modulo,               /* cd-modulo             */
                                      input fxpar-pr.in-tipo-movto,           /* in-tipo-movto         */
                                      input fxpar-pr.cd-gr-proc-tp-insumo,    /* cd-gr-proc-tp-insumo  */
                                      input fxpar-pr.cd-proced-insumo,        /* cd-proced-insumo      */
                                      input fxpar-pr.qt-faixa-inicial,        /* qt-faixa-inicial      */
                                      input fxpar-pr.qt-faixa-final,          /* qt-faixa-final        */
                                      input fxpar-pr.lg-percentual-cob-ele,   /* lg-percentual-cob-ele */
                                      input fxpar-pr.pc-part-cob-ele,         /* pc-part-cob-ele       */
                                      input fxpar-pr.cd-moeda-part-cob-ele,   /* cd-moeda-part-cob-ele */
                                      input fxpar-pr.qt-part-cob-ele,         /* qt-part-cob-ele       */
                                      input fxpar-pr.lg-percentual-cob-urg,   /* lg-percentual-cob-urg */
                                      input fxpar-pr.pc-part-cob-urg,         /* pc-part-cob-urg       */
                                      input fxpar-pr.cd-moeda-part-cob-urg,   /* cd-moeda-part-cob-urg */
                                      input fxpar-pr.qt-part-cob-urg).        /* qt-part-cob-urg       */
            end.
          end.
     /* ------------------------------------------ FIM FXPAR-PR ----------------------------------------- */

     /* ---------------------------------------- INICIO FXPALOPR ---------------------------------------- */
     if in-tabela-aux = 0 or in-tabela-aux = 4
     then do:
            for each fxpalopr fields(cd-modalidade cd-plano cd-tipo-plano cd-local-atendimento cd-modulo in-tipo-movto cd-gr-proc-tp-insumo cd-proced-insumo
                                     qt-faixa-inicial qt-faixa-final dt-limite lg-percentual-cob-ele pc-part-cob-ele cd-moeda-part-cob-ele qt-part-cob-ele
                                     lg-percentual-cob-urg pc-part-cob-urg cd-moeda-part-cob-urg qt-part-cob-urg) no-lock
               where fxpalopr.cd-modalidade = modalid.cd-modalidade
                 and fxpalopr.dt-limite >= today
                  by fxpalopr.cd-modalidade
                  by fxpalopr.cd-plano
                  by fxpalopr.cd-tipo-plano
                  by fxpalopr.cd-local-atendimento
                  by fxpalopr.cd-modulo
                  by fxpalopr.in-tipo-movto
                  by fxpalopr.cd-gr-proc-tp-insumo
                  by fxpalopr.cd-proced-insumo
                  by fxpalopr.qt-faixa-inicial
                  by fxpalopr.qt-faixa-final:
                      
               if can-do("202,211,212",string(fxpalopr.cd-modulo))
               or fxpalopr.cd-modalidade = 30               
               then next.
               
               if fxpalopr.cd-gr-proc-tp-insumo = 1
              and fxpalopr.cd-proced-insumo = 10014
               then next.
                                     
               run processa-registro (input 4,                                /* fxpalopr              */
                                      input fxpalopr.cd-modalidade,           /* cd-modalidade         */
                                      input 0,                                /* nr-proposta           */
                                      input fxpalopr.cd-plano,                /* cd-plano              */
                                      input fxpalopr.cd-tipo-plano,           /* cd-tipo-plano         */
                                      input fxpalopr.cd-local-atendimento,    /* cd-local-atendimento  */
                                      input fxpalopr.dt-limite,               /* dt-limite             */
                                      input fxpalopr.cd-modulo,               /* cd-modulo             */
                                      input fxpalopr.in-tipo-movto,           /* in-tipo-movto         */
                                      input fxpalopr.cd-gr-proc-tp-insumo,    /* cd-gr-proc-tp-insumo  */
                                      input fxpalopr.cd-proced-insumo,        /* cd-proced-insumo      */
                                      input fxpalopr.qt-faixa-inicial,        /* qt-faixa-inicial      */
                                      input fxpalopr.qt-faixa-final,          /* qt-faixa-final        */
                                      input fxpalopr.lg-percentual-cob-ele,   /* lg-percentual-cob-ele */
                                      input fxpalopr.pc-part-cob-ele,         /* pc-part-cob-ele       */
                                      input fxpalopr.cd-moeda-part-cob-ele,   /* cd-moeda-part-cob-ele */
                                      input fxpalopr.qt-part-cob-ele,         /* qt-part-cob-ele       */
                                      input fxpalopr.lg-percentual-cob-urg,   /* lg-percentual-cob-urg */
                                      input fxpalopr.pc-part-cob-urg,         /* pc-part-cob-urg       */
                                      input fxpalopr.cd-moeda-part-cob-urg,   /* cd-moeda-part-cob-urg */
                                      input fxpalopr.qt-part-cob-urg).        /* qt-part-cob-urg       */
            end.
          end.
         /* ------------------------------------------ FIM FXPALOPR ----------------------------------------- */

  end.
end.

procedure imprime-relatorios:
   {hdp/hdmonarq.i &page-size = 64 &numarq = "1"}

   assign ds-rodape = " - " + c_prg_vrs
          ds-rodape = fill("-", 132 - length(ds-rodape)) + ds-rodape
          ds-cabecalho = "Relatorio Carga Parametros Participacao Escalonada".

   view frame f-cabecalho.
   view frame f-rodape.

   display entry(in-tabela-aux + 1,ds-tabelas-aux,";") @ ds-tabelas-aux
           dt-inic-regra-aux
           lg-simula-aux
           lg-consid-canc
           skip (2)
           with frame f-mapa-par.

   display cd-modalidade-ini
           cd-modalidade-fim
           with frame f-mapa.
   page.

   for each tmpRelatorioAcomp break by tmpRelatorioAcomp.in-tabela:
       if first-of(tmpRelatorioAcomp.in-tabela)
       then do:
              page.
              display "Tabela: " entry(tmpRelatorioAcomp.in-tabela + 1,ds-tabelas-aux,";") format "X(20)" no-label skip (2).
            end.
       case tmpRelatorioAcomp.in-tabela:
       when 1
       then do:
              case tmpRelatorioAcomp.ind-atualizado:
              when 1
              then display tmpRelatorioAcomp.cd-modalidade
                           tmpRelatorioAcomp.nr-proposta
                           tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           tmpRelatorioAcomp.dt-limite
                           tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                 
                           tmpRelatorioAcomp.lg-proposta-cancelada                           
                           with frame f-relatorio-fxparpro.
              when 2
              then display tmpRelatorioAcomp.cd-modulo
                           with frame f-relatorio-fxparpro.
              when 3
              then display tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                   
                           with frame f-relatorio-fxparpro.
              when 4
              then display tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           with frame f-relatorio-fxparpro.

              end case.
              down with frame f-relatorio-fxparpro.
            end.
       when 2
       then do:
              case tmpRelatorioAcomp.ind-atualizado:
              when 1
              then display tmpRelatorioAcomp.cd-modalidade
                           tmpRelatorioAcomp.nr-proposta
                           tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.cd-local-atendimento
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           tmpRelatorioAcomp.dt-limite
                           tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                 
                           tmpRelatorioAcomp.lg-proposta-cancelada                           
                           with frame f-relatorio-fxpalovp.
              when 2
              then display tmpRelatorioAcomp.cd-modulo
                           with frame f-relatorio-fxpalovp.
              when 3
              then display tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                 
                           with frame f-relatorio-fxpalovp.
              when 4
              then display tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           with frame f-relatorio-fxpalovp.
              end case.
              down with frame f-relatorio-fxpalovp.
            end.
       when 3
       then do:
              case tmpRelatorioAcomp.ind-atualizado:
              when 1
              then display tmpRelatorioAcomp.cd-modalidade
                           tmpRelatorioAcomp.cd-plano
                           tmpRelatorioAcomp.cd-tipo-plano
                           tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           tmpRelatorioAcomp.dt-limite
                           tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                 
                           tmpRelatorioAcomp.lg-proposta-cancelada
                           with frame f-relatorio-fxpar-pr.
              when 2
              then display tmpRelatorioAcomp.cd-modulo
                           with frame f-relatorio-fxpar-pr.
              when 3
              then display tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                   
                           with frame f-relatorio-fxpar-pr.
              when 4
              then display tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           with frame f-relatorio-fxpar-pr.
              end case.
              down with frame f-relatorio-fxpar-pr.
            end.
       when 4
       then do:
              case tmpRelatorioAcomp.ind-atualizado:
              when 1
              then display tmpRelatorioAcomp.cd-modalidade
                           tmpRelatorioAcomp.cd-plano
                           tmpRelatorioAcomp.cd-tipo-plano
                           tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.cd-local-atendimento
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           tmpRelatorioAcomp.dt-limite
                           tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                 
                           tmpRelatorioAcomp.lg-proposta-cancelada                           
                           with frame f-relatorio-fxpalopr.
              when 2
              then display tmpRelatorioAcomp.cd-modulo
                           with frame f-relatorio-fxpalopr.
              when 3
              then display tmpRelatorioAcomp.qt-faixa-inicial
                           tmpRelatorioAcomp.qt-faixa-final
                           tmpRelatorioAcomp.ds-particip-ele                                 
                           tmpRelatorioAcomp.ds-particip-urg                                   
                           with frame f-relatorio-fxpalopr.
              when 4
              then display tmpRelatorioAcomp.cd-modulo
                           tmpRelatorioAcomp.in-tipo-movto
                           tmpRelatorioAcomp.cd-grp-tip-movto
                           tmpRelatorioAcomp.cd-movto
                           with frame f-relatorio-fxpalopr.
              end case.
              down with frame f-relatorio-fxpalopr.
            end.
       end case.
       put skip(1).

       if last-of(tmpRelatorioAcomp.in-tabela)
       then display "Registros carregados: " qtd-atu-aux[tmpRelatorioAcomp.in-tabela] no-label skip.
   end.

  if temp-table tmpRelatorioAcomp:has-records
  then display "Total geral registros carregados: " qtd-atu-aux[1] + qtd-atu-aux[2] + qtd-atu-aux[3] + qtd-atu-aux[4] no-label skip.

   {hdp/hdclosed.i}

   if can-find (first tmpRelatorioErro)
   then do:
          {hdp/hdmonarq.i &page-size = 64 &numarq = "2"}

          assign ds-rodape = " - " + c_prg_vrs
                 ds-rodape = fill("-", 132 - length(ds-rodape)) + ds-rodape
                 ds-cabecalho = "Relatorio Erros Carga Parametros Participacao Escalonada".

          view frame f-cabecalho.
          view frame f-rodape.

          display entry(in-tabela-aux + 1,ds-tabelas-aux,";") @ ds-tabelas-aux
                  lg-simula-aux
                  lg-consid-canc
                  with frame f-mapa-par.

          display cd-modalidade-ini
                  cd-modalidade-fim
                  with frame f-mapa.

          for each tmpRelatorioErro break by tmpRelatorioErro.in-tabela:
              if first-of(tmpRelatorioErro.in-tabela)
              then do:
                     page.
                     display "Tabela: " entry(tmpRelatorioErro.in-tabela + 1,ds-tabelas-aux,";") format "X(20)" no-label skip (2).
                   end.
              case tmpRelatorioErro.in-tabela:
              when 1
              then do:
                     display tmpRelatorioErro.cd-modalidade
                             tmpRelatorioErro.nr-proposta
                             tmpRelatorioErro.cd-modulo
                             tmpRelatorioErro.in-tipo-movto
                             tmpRelatorioErro.cd-grp-tip-movto
                             tmpRelatorioErro.cd-movto
                             tmpRelatorioErro.dt-limite
                             tmpRelatorioErro.qt-faixa-inicial
                             tmpRelatorioErro.qt-faixa-final
                             tmpRelatorioErro.ds-erro
                             with frame f-relatorio-erro-fxparpro.
                     down with frame f-relatorio-erro-fxparpro.
                   end.
              when 2
              then do:
                     display tmpRelatorioErro.cd-modalidade
                             tmpRelatorioErro.nr-proposta
                             tmpRelatorioErro.cd-modulo
                             tmpRelatorioErro.cd-local-atendimento
                             tmpRelatorioErro.in-tipo-movto
                             tmpRelatorioErro.cd-grp-tip-movto
                             tmpRelatorioErro.cd-movto
                             tmpRelatorioErro.dt-limite
                             tmpRelatorioErro.qt-faixa-inicial
                             tmpRelatorioErro.qt-faixa-final
                             tmpRelatorioErro.ds-erro
                             with frame f-relatorio-erro-fxpalovp.
                     down with frame f-relatorio-erro-fxpalovp.
                   end.
              when 3
              then do:
                     display tmpRelatorioErro.cd-modalidade
                             tmpRelatorioErro.cd-plano
                             tmpRelatorioErro.cd-tipo-plano
                             tmpRelatorioErro.cd-modulo
                             tmpRelatorioErro.in-tipo-movto
                             tmpRelatorioErro.cd-grp-tip-movto
                             tmpRelatorioErro.cd-movto
                             tmpRelatorioErro.dt-limite
                             tmpRelatorioErro.qt-faixa-inicial
                             tmpRelatorioErro.qt-faixa-final
                             tmpRelatorioErro.ds-erro
                             with frame f-relatorio-erro-fxpar-pr.
                     down with frame f-relatorio-erro-fxpar-pr.
                   end.
              when 4
              then do:
                     display tmpRelatorioErro.cd-modalidade
                             tmpRelatorioErro.cd-plano
                             tmpRelatorioErro.cd-tipo-plano
                             tmpRelatorioErro.cd-modulo
                             tmpRelatorioErro.cd-local-atendimento
                             tmpRelatorioErro.in-tipo-movto
                             tmpRelatorioErro.cd-grp-tip-movto
                             tmpRelatorioErro.cd-movto
                             tmpRelatorioErro.dt-limite
                             tmpRelatorioErro.qt-faixa-inicial
                             tmpRelatorioErro.qt-faixa-final
                             tmpRelatorioErro.ds-erro
                             with frame f-relatorio-erro-fxpalopr.
                     down with frame f-relatorio-erro-fxpalopr.
                   end.
              end case.
              put skip(1).

              if last-of(tmpRelatorioErro.in-tabela)
              then display "Registros com erro: " qtd-erro-aux[tmpRelatorioErro.in-tabela] no-label skip.
          end.
          if temp-table tmpRelatorioErro:has-records
          then display "Total geral registros com erro: " qtd-erro-aux[1] + qtd-erro-aux[2] + qtd-erro-aux[3] + qtd-erro-aux[4] no-label skip.
          {hdp/hdclosed.i}


          message "Ocorreram erros durante o processo." skip
                  "Verifique o relatorio de erros."
                  view-as alert-box info buttons ok.
        end.
end procedure.

/* ---------------------------------------------------------------------------------- */
procedure cria-tmp-relat-erro:
  def input param in-tabela-par              as int                           no-undo.
  def input param cd-modalidade-par        like propost.cd-modalidade         no-undo.
  def input param nr-proposta-par          like propost.nr-proposta           no-undo.
  def input param cd-plano-par             like propost.cd-plano              no-undo.
  def input param cd-tipo-plano-par        like propost.cd-tipo-plano         no-undo.
  def input param cd-local-atendimento-par like fxpalovp.cd-local-atendimento no-undo.
  def input param dt-limite-par            like fxparpro.dt-limite            no-undo.
  def input param cd-modulo-par            like fxparpro.cd-modulo            no-undo.
  def input param in-tipo-movto-par        like fxparpro.in-tipo-movto        no-undo.
  def input param cd-grp-tip-movto-par     like fxparpro.cd-gr-proc-tp-insumo no-undo.
  def input param cd-movto-par             like fxparpro.cd-proced-insumo     no-undo.
  def input param qt-faixa-inicial-par     like fxparpro.qt-faixa-inicial     no-undo.
  def input param qt-faixa-final-par       like fxparpro.qt-faixa-final       no-undo.
  def input param ds-erro-par                as char                          no-undo.

  create tmpRelatorioErro.
  assign tmpRelatorioErro.in-tabela            = in-tabela-par
         tmpRelatorioErro.cd-modalidade        = cd-modalidade-par
         tmpRelatorioErro.nr-proposta          = nr-proposta-par
         tmpRelatorioErro.cd-plano             = cd-plano-par
         tmpRelatorioErro.cd-tipo-plano        = cd-tipo-plano-par
         tmpRelatorioErro.cd-local-atendimento = cd-local-atendimento-par
         tmpRelatorioErro.dt-limite            = dt-limite-par
         tmpRelatorioErro.cd-modulo            = cd-modulo-par
         tmpRelatorioErro.in-tipo-movto        = in-tipo-movto-par
         tmpRelatorioErro.cd-grp-tip-movto     = cd-grp-tip-movto-par
         tmpRelatorioErro.cd-movto             = cd-movto-par
         tmpRelatorioErro.qt-faixa-inicial     = qt-faixa-inicial-par
         tmpRelatorioErro.qt-faixa-final       = qt-faixa-final-par
         tmpRelatorioErro.ds-erro              = ds-erro-par.
         qtd-erro-aux[in-tabela-par]           = qtd-erro-aux[in-tabela-par] + 1.

end procedure.

/* ---------------------------------------------------------------------------------- */
procedure cria-tmp-relat-acomp:
  def input param in-tabela-par              as int                           no-undo.
  def input param cd-modalidade-par        like propost.cd-modalidade         no-undo.
  def input param nr-proposta-par          like propost.nr-proposta           no-undo.
  def input param cd-plano-par             like propost.cd-plano              no-undo.
  def input param cd-tipo-plano-par        like propost.cd-tipo-plano         no-undo.
  def input param cd-local-atendimento-par like fxpalovp.cd-local-atendimento no-undo.
  def input param dt-limite-par            like fxparpro.dt-limite            no-undo.
  def input param cd-modulo-par            like fxparpro.cd-modulo            no-undo.
  def input param in-tipo-movto-par        like fxparpro.in-tipo-movto        no-undo.
  def input param cd-grp-tip-movto-par     like fxparpro.cd-gr-proc-tp-insumo no-undo.
  def input param cd-movto-par             like fxparpro.cd-proced-insumo     no-undo.
  def input param qt-faixa-inicial-par     like fxparpro.qt-faixa-inicial     no-undo.
  def input param qt-faixa-final-par       like fxparpro.qt-faixa-final       no-undo.
  def input param ind-atualizado-par         as int                           no-undo.
  
  def input param lg-percentual-cob-ele-par like fxparpro.lg-percentual-cob-ele no-undo. 
  def input param pc-part-cob-ele-par       like fxparpro.pc-part-cob-ele       no-undo.
  def input param cd-moeda-part-cob-ele-par like fxparpro.cd-moeda-part-cob-ele no-undo.
  def input param qt-part-cob-ele-par       like fxparpro.qt-part-cob-ele       no-undo.
  def input param lg-percentual-cob-urg-par like fxparpro.lg-percentual-cob-urg no-undo.
  def input param pc-part-cob-urg-par       like fxparpro.pc-part-cob-urg       no-undo.
  def input param cd-moeda-part-cob-urg-par like fxparpro.cd-moeda-part-cob-urg no-undo.
  def input param qt-part-cob-urg-par       like fxparpro.qt-part-cob-urg       no-undo.

  create tmpRelatorioAcomp.
  assign tmpRelatorioAcomp.in-tabela             = in-tabela-par
         tmpRelatorioAcomp.cd-modalidade         = cd-modalidade-par
         tmpRelatorioAcomp.nr-proposta           = nr-proposta-par
         tmpRelatorioAcomp.cd-plano              = cd-plano-par
         tmpRelatorioAcomp.cd-tipo-plano         = cd-tipo-plano-par
         tmpRelatorioAcomp.cd-local-atendimento  = cd-local-atendimento-par
         tmpRelatorioAcomp.dt-limite             = dt-limite-par
         tmpRelatorioAcomp.cd-modulo             = cd-modulo-par
         tmpRelatorioAcomp.in-tipo-movto         = in-tipo-movto-par
         tmpRelatorioAcomp.cd-grp-tip-movto      = cd-grp-tip-movto-par
         tmpRelatorioAcomp.cd-movto              = cd-movto-par
         tmpRelatorioAcomp.qt-faixa-inicial      = qt-faixa-inicial-par
         tmpRelatorioAcomp.qt-faixa-final        = qt-faixa-final-par
         tmpRelatorioAcomp.ds-particip-ele       = if lg-percentual-cob-ele-par
                                                  then string(pc-part-cob-ele-par) + "%"
                                                  else string(qt-part-cob-ele-par) + ds-moeda(cd-moeda-part-cob-ele-par)
         tmpRelatorioAcomp.ds-particip-urg       = if lg-percentual-cob-urg-par
                                                  then string(pc-part-cob-urg-par) + "%"
                                                  else string(qt-part-cob-urg-par) + ds-moeda(cd-moeda-part-cob-urg-par)
         tmpRelatorioAcomp.ind-atualizado        = ind-atualizado-par
         qtd-atu-aux[in-tabela-par]              = qtd-atu-aux[in-tabela-par] + 1
         tmpRelatorioAcomp.lg-proposta-cancelada = if avail propost and propost.cd-sit-proposta = 90
                                                   then yes
                                                   else no. 

end procedure.

/* ---------------------------------------------------------------------------------- */
procedure verifica-movimento:
  def input  parameter id-tabela-par           as int                           no-undo.
  def input  parameter in-tip-movto-par      like fxparpro.in-tipo-movto        no-undo.
  def input  parameter cd-grp-tip-movto-par  like fxparpro.cd-gr-proc-tp-insumo no-undo.
  def input  parameter cd-movto-par          like fxparpro.cd-proced-insumo     no-undo.
  def output parameter lg-erro-par             as log                           no-undo.
  def output parameter ds-erro-par             as char                          no-undo.

  assign lg-erro-par = no.
  if in-tip-movto-par = "P"
  then do:
         if cd-movto-par <> 0
         then do:
                assign cd-esp-amb-aux          = int(substring(string(cd-movto-par,"99999999"),1,2))
                       cd-grupo-proc-amb-aux   = int(substring(string(cd-movto-par,"99999999"),3,2))
                       cd-procedimento-aux     = int(substring(string(cd-movto-par,"99999999"),5,3))
                       dv-procedimento-aux     = int(substring(string(cd-movto-par,"99999999"),8,1)).

                for first ambproce fields(cd-grupo-esp-amb cd-subgrupo-esp-amb) no-lock
                    where ambproce.cd-esp-amb        = cd-esp-amb-aux
                      and ambproce.cd-grupo-proc-amb = cd-grupo-proc-amb-aux
                      and ambproce.cd-procedimento   = cd-procedimento-aux
                      and ambproce.dv-procedimento   = dv-procedimento-aux:
                   assign cd-grupo-esp-amb-aux    = ambproce.cd-grupo-esp-amb
                          cd-subgrupo-esp-amb-aux = ambproce.cd-subgrupo-esp-amb.
                end.
                if not avail ambproce
                then do:
                       assign ds-erro-par = "Procedimento nao cadastrado"
                              lg-erro-par = yes.
                     end.
              end.
         else do:
                if not can-find (gru-pro where gru-pro.cd-grupo-proc = cd-grp-tip-movto-par)
                then do:
                       assign ds-erro-par = "Grupo procedimento nao cadastrado"
                              lg-erro-par = yes.
                     end.
              end.
       end.
  else do:
         if cd-movto-par <> 0
        and not can-find (insumos where insumos.cd-tipo-insumo = cd-grp-tip-movto-par
                                    and insumos.cd-insumo      = cd-movto-par)
         then do:
                assign lg-erro-par = yes
                       ds-erro-par = "Insumo nao cadastrado".
              end.
         else do:
                if not can-find (tipoinsu where tipoinsu.cd-tipo-insumo = cd-grp-tip-movto-par)
                then assign lg-erro-par = yes
                            ds-erro-par = "Tipo insumo nao cadastrado".
              end.
       end.
end procedure.

/* ---------------------------------------------------------------------------------- */
procedure busca-properus:
   def input parameter cd-modalidade-par       like properus.cd-modalidade       no-undo.
   def input parameter nr-ter-adesao-par       like properus.nr-ter-adesao       no-undo.
   def input parameter cd-plano-par            like properus.nr-ter-adesao       no-undo.
   def input parameter cd-tipo-plano-par       like properus.nr-ter-adesao       no-undo.
   def input parameter cd-modulo-par           like properus.cd-modulo           no-undo.
   def input parameter in-tipo-movto-par         as char                         no-undo.
   def input parameter cd-esp-amb-par          like properus.cd-esp-amb          no-undo.
   def input parameter cd-grupo-proc-amb-par   like properus.cd-grupo-proc-amb   no-undo.
   def input parameter cd-procedimento-par     like properus.cd-procedimento     no-undo.
   def input parameter dv-procedimento-par     like properus.dv-procedimento     no-undo.
   def input parameter cd-grupo-esp-amb-par    like ambproce.cd-grupo-esp-am     no-undo.
   def input parameter cd-subgrupo-esp-amb-par like ambproce.cd-subgrupo-esp-amb no-undo.
   def input parameter cd-tipo-insumo-par      like properus.cd-tipo-insumo      no-undo.
   def input parameter cd-insumo-par           like properus.cd-insumo           no-undo.

   if in-tipo-movto-par = "P"
   then do: /* ------------------------- Proposta/Procedimento --------------------------- */
          if nr-ter-adesao-par <> 0
          then do:
                 for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                     where properus.cd-modalidade       = cd-modalidade-par
                       and properus.nr-ter-adesao       = nr-ter-adesao-par
                       and properus.cd-esp-amb          = cd-esp-amb-par
                       and properus.cd-grupo-proc-amb   = cd-grupo-proc-amb-par
                       and properus.cd-procedimento     = cd-procedimento-par
                       and properus.dv-procedimento     = dv-procedimento-par
                       and properus.dt-inicio-vigencia <= today
                       and properus.dt-fim-vigencia    >= today
                       and (properus.cd-modulo           = cd-modulo-par
                           or properus.cd-modulo         = 0)
                           by properus.cd-modulo desc:
                 end.
                 /* -------------------- Proposta/grupo/subgrupo especie ------------------------- */
                 if not avail properus
                 then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                            where properus.cd-modalidade       = cd-modalidade-par
                              and properus.nr-ter-adesao       = nr-ter-adesao-par
                              and properus.cd-esp-amb          = cd-grupo-esp-amb-par    /*cd-esp-amb-par       */
                              and properus.cd-grupo-proc-amb   = cd-subgrupo-esp-amb-par /*cd-grupo-proc-amb-par*/
                              and properus.cd-procedimento     = 0
                              and properus.dv-procedimento     = 0
                              and properus.dt-inicio-vigencia <= today
                              and properus.dt-fim-vigencia    >= today
                              and (properus.cd-modulo           = cd-modulo-par
                                 or properus.cd-modulo         = 0)
                               by properus.cd-modulo desc:
                      end.
                 /* ---------------------------- Proposta/grupo especie ------------------------- */
                 if not avail properus
                 then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                            where properus.cd-modalidade       = cd-modalidade-par
                              and properus.nr-ter-adesao       = nr-ter-adesao-par
                              and properus.cd-esp-amb          = cd-grupo-esp-amb-par    /*cd-esp-amb-par       */
                              and properus.cd-grupo-proc-amb   = 0                       /*cd-grupo-proc-amb-par*/
                              and properus.cd-procedimento     = 0
                              and properus.dv-procedimento     = 0
                              and properus.dt-inicio-vigencia <= today
                              and properus.dt-fim-vigencia    >= today
                              and (properus.cd-modulo           = cd-modulo-par
                                 or properus.cd-modulo         = 0)
                               by properus.cd-modulo desc:
                      end.
               end.
          /* --------------------------- Estrutura/procedimento ------------------------- */
          if not avail properus
          then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                   where properus.cd-modalidade       = cd-modalidade-par
                     and properus.cd-plano            = cd-plano-par
                     and properus.cd-tipo-plano       = cd-tipo-plano-par
                     and properus.cd-esp-amb          = cd-esp-amb-par
                     and properus.cd-grupo-proc-amb   = cd-grupo-proc-amb-par
                     and properus.cd-procedimento     = cd-procedimento-par
                     and properus.dv-procedimento     = dv-procedimento-par
                     and properus.dt-inicio-vigencia <= today
                     and properus.dt-fim-vigencia    >= today
                     and (properus.cd-modulo           = cd-modulo-par
                        or properus.cd-modulo         = 0)
                      by properus.cd-modulo desc:
               end.
          /* -------------------- Estrutura/grupo/subgrupo especie ------------------------- */
          if not avail properus
          then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                   where properus.cd-modalidade       = cd-modalidade-par
                     and properus.cd-plano            = cd-plano-par
                     and properus.cd-tipo-plano       = cd-tipo-plano-par
                     and properus.cd-esp-amb          = cd-grupo-esp-amb-par    /*cd-esp-amb-par       */
                     and properus.cd-grupo-proc-amb   = cd-subgrupo-esp-amb-par /*cd-grupo-proc-amb-par*/
                     and properus.cd-procedimento     = 0
                     and properus.dv-procedimento     = 0
                     and properus.dt-inicio-vigencia <= today
                     and properus.dt-fim-vigencia    >= today
                     and (properus.cd-modulo           = cd-modulo-par
                        or properus.cd-modulo         = 0)
                      by properus.cd-modulo desc:
               end.
          /* -------------------------- Estrutura/grupo especie ------------------------- */
          if not avail properus
          then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                   where properus.cd-modalidade       = cd-modalidade-par
                     and properus.cd-plano            = cd-plano-par
                     and properus.cd-tipo-plano       = cd-tipo-plano-par
                     and properus.cd-esp-amb          = cd-grupo-esp-amb-par    /*cd-esp-amb-par       */
                     and properus.cd-grupo-proc-amb   = 0                       /*cd-grupo-proc-amb-par*/
                     and properus.cd-procedimento     = 0
                     and properus.dv-procedimento     = 0
                     and properus.dt-inicio-vigencia <= today
                     and properus.dt-fim-vigencia    >= today
                     and (properus.cd-modulo           = cd-modulo-par
                        or properus.cd-modulo         = 0)
                      by properus.cd-modulo desc:
               end.
        end.
   else do: /* ------------------------- Proposta/Insumo --------------------------- */
          for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
              where properus.cd-modalidade       = cd-modalidade-par
                and properus.nr-ter-adesao       = nr-ter-adesao-par
                and properus.cd-tipo-insumo      = cd-tipo-insumo-par
                and properus.cd-insumo           = cd-insumo-par
                and properus.dt-inicio-vigencia <= today
                and properus.dt-fim-vigencia    >= today
                and (properus.cd-modulo          = cd-modulo-par
                  or properus.cd-modulo         = 0)
                and properus.cd-esp-amb          = 0
                and properus.cd-grupo-proc-amb   = 0 
                 by properus.cd-modulo desc:
          end.
           /* ------------------------- Proposta/Tipo insumo --------------------------- */
          if not avail properus
          then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                   where properus.cd-modalidade       = cd-modalidade-par
                     and properus.nr-ter-adesao       = nr-ter-adesao-par
                     and properus.cd-tipo-insumo      = cd-tipo-insumo-par
                     and properus.cd-insumo           = 0
                     and properus.dt-inicio-vigencia <= today
                     and properus.dt-fim-vigencia    >= today
                     and (properus.cd-modulo          = cd-modulo-par
                       or properus.cd-modulo         = 0)
                     and properus.cd-esp-amb          = 0
                     and properus.cd-grupo-proc-amb   = 0
                      by properus.cd-modulo desc:
          end.
          /* --------------------------- Estrutura/insumo ------------------------- */
          if not avail properus
          then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                   where properus.cd-modalidade       = cd-modalidade-par
                     and properus.cd-plano            = cd-plano-par
                     and properus.cd-tipo-plano       = cd-tipo-plano-par
                     and properus.cd-tipo-insumo      = cd-tipo-insumo-par
                     and properus.cd-insumo           = cd-insumo-par
                     and properus.dt-inicio-vigencia <= today
                     and properus.dt-fim-vigencia    >= today
                     and (properus.cd-modulo           = cd-modulo-par
                       or properus.cd-modulo         = 0)
                     and properus.cd-esp-amb          = 0
                     and properus.cd-grupo-proc-amb   = 0                        
                      by properus.cd-modulo desc:
               end.
          /* --------------------------- Estrutura/Tipo insumo ------------------------- */
          if not avail properus
          then for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
                   where properus.cd-modalidade       = cd-modalidade-par
                     and properus.cd-plano            = cd-plano-par
                     and properus.cd-tipo-plano       = cd-tipo-plano-par
                     and properus.cd-tipo-insumo      = cd-tipo-insumo-par
                     and properus.cd-insumo           = 0
                     and properus.dt-inicio-vigencia <= today
                     and properus.dt-fim-vigencia    >= today
                     and (properus.cd-modulo          = cd-modulo-par
                       or properus.cd-modulo         = 0)
                     and properus.cd-esp-amb          = 0
                     and properus.cd-grupo-proc-amb   = 0                        
                      by properus.cd-modulo desc:
               end.
        end.

end procedure.

/* ------------------------------------------------------------------------------------- */
procedure processa-registro:
  def input param in-tabela-par               as int                            no-undo.
  def input param cd-modalidade-par         like propost.cd-modalidade          no-undo.
  def input param nr-proposta-par           like propost.nr-proposta            no-undo.
  def input param cd-plano-par              like propost.cd-plano               no-undo.
  def input param cd-tipo-plano-par         like propost.cd-tipo-plano          no-undo.
  def input param cd-local-atendimento-par  like fxpalovp.cd-local-atendimento  no-undo.
  def input param dt-limite-par             like fxparpro.dt-limite             no-undo.
  def input param cd-modulo-par             like fxparpro.cd-modulo             no-undo.
  def input param in-tipo-movto-par         like fxparpro.in-tipo-movto         no-undo.
  def input param cd-grp-tip-movto-par      like fxparpro.cd-gr-proc-tp-insumo  no-undo.
  def input param cd-movto-par              like fxparpro.cd-proced-insumo      no-undo.
  def input param qt-faixa-inicial-par      like fxparpro.qt-faixa-inicial      no-undo.
  def input param qt-faixa-final-par        like fxparpro.qt-faixa-final        no-undo.
  def input param lg-percentual-cob-ele-par like fxparpro.lg-percentual-cob-ele no-undo.
  def input param pc-part-cob-ele-par       like fxparpro.pc-part-cob-ele       no-undo.
  def input param cd-moeda-part-cob-ele-par like fxparpro.cd-moeda-part-cob-ele no-undo.
  def input param qt-part-cob-ele-par       like fxparpro.qt-part-cob-ele       no-undo.
  def input param lg-percentual-cob-urg-par like fxparpro.lg-percentual-cob-urg no-undo.
  def input param pc-part-cob-urg-par       like fxparpro.pc-part-cob-urg       no-undo.
  def input param cd-moeda-part-cob-urg-par like fxparpro.cd-moeda-part-cob-urg no-undo.
  def input param qt-part-cob-urg-par       like fxparpro.qt-part-cob-urg       no-undo.

  assign lg-modulo-agrupado = if can-do("149,150,249,250",string(cd-modulo-par))
                              then yes
                              else no. 

  if nr-proposta-par <> 0
  then do:
         for first propost fields(nr-ter-adesao cd-sit-proposta cd-plano cd-tipo-plano) no-lock
             where propost.cd-modalidade = cd-modalidade-par
               and propost.nr-proposta   = nr-proposta-par :
         end.
         if not avail propost
         then do:
                assign ds-erro-aux = "Proposta nao cadastrada".
                run cria-tmp-relat-erro(input in-tabela-par,
                                        input cd-modalidade-par,        /* cd-modalidade        */
                                        input nr-proposta-par,          /* nr-proposta          */
                                        input 0,                        /* cd-plano             */
                                        input 0,                        /* cd-tipo-plano        */
                                        input 0,                        /* cd-local-atendimento */
                                        input dt-limite-par,            /* dt-limite            */
                                        input cd-modulo-par,            /* cd-modulo            */
                                        input in-tipo-movto-par,        /* in-tipo-movto        */
                                        input cd-grp-tip-movto-par,     /* cd-grp-tip-movto     */
                                        input cd-movto-par,             /* cd-movto             */
                                        input qt-faixa-inicial-par,     /* qt-faixa-inicial     */
                                        input qt-faixa-final-par,       /* qt-faixa-final       */
                                        input ds-erro-aux).             /* descricao do erro    */
                leave. /* sai da procedure */
              end.
         /* ----------------- Quando termo cancelado antes de 2015 regra nao deve ser considerada --------------- */
         if can-find(first ter-ade
                     where ter-ade.cd-modalidade = cd-modalidade-par
                       and ter-ade.nr-ter-adesao = propost.nr-ter-adesao
                       and ter-ade.dt-cancelamento < 01/01/2015)
         then leave.

         if propost.cd-sit-proposta = 90
        and not lg-consid-canc
         then do:
                leave.
              end.

         assign nr-ter-adesao-aux = propost.nr-ter-adesao
                cd-plano-aux      = propost.cd-plano
                cd-tipo-plano-aux = propost.cd-tipo-plano.
       end.
  else assign nr-ter-adesao-aux = 0
              cd-plano-aux      = cd-plano-par
              cd-tipo-plano-aux = cd-tipo-plano-par.

  assign cd-grupo-esp-amb-aux    = 0
         cd-subgrupo-esp-amb-aux = 0
         cd-esp-amb-aux          = 0
         cd-grupo-proc-amb-aux   = 0
         cd-procedimento-aux     = 0
         dv-procedimento-aux     = 0
         ind-acao-movto-aux      = " "
         lg-retorna-aux          = no.

  if  cd-grp-tip-movto-par <> 0
  then do:
         run verifica-movimento ( input  in-tabela-par,
                                  input  in-tipo-movto-par,
                                  input  cd-grp-tip-movto-par,
                                  input  cd-movto-par,
                                  output lg-erro-aux,
                                  output ds-erro-aux).
         if lg-erro-aux
         then do:
                run cria-tmp-relat-erro(input in-tabela-par,
                                        input cd-modalidade-par,        /* cd-modalidade        */
                                        input nr-proposta-par,          /* nr-proposta          */
                                        input cd-plano-par,             /* cd-plano             */
                                        input cd-tipo-plano-par,        /* cd-tipo-plano        */
                                        input cd-local-atendimento-par, /* cd-local-atendimento */
                                        input dt-limite-par,            /* dt-limite            */
                                        input cd-modulo-par,            /* cd-modulo            */
                                        input in-tipo-movto-par,        /* in-tipo-movto        */
                                        input cd-grp-tip-movto-par,     /* cd-grp-tip-movto     */
                                        input cd-movto-par,             /* cd-movto             */
                                        input qt-faixa-inicial-par,     /* qt-faixa-inicial     */
                                        input qt-faixa-final-par,       /* qt-faixa-final       */
                                        input ds-erro-aux).             /* descricao do erro    */
                leave.
              end.
         assign ind-acao-movto-aux  = "R".              
       end.

  /* --------- verifica se ja existe regra cadastrada com mesmos parametros ------------*/
   if lg-modulo-agrupado
   then do:
  /* -------- tratativa para porto alegre - quando regra dos modulos 149, 150, 249 e 250 ------ nao 202, 211, 212, */
          if nr-proposta-par <> 0
          then for first regra-particip-escalnda fields(cdd-seq-regra-escalnda) no-lock
                   where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
                     and regra-particip-escalnda.num-propost       = nr-proposta-par
                     and regra-particip-escalnda.cdn-plano         = 0
                     and regra-particip-escalnda.cdn-tip-plano     = 0
                     and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
                     and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
                     and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
                     and regra-particip-escalnda.ind-modul         = "S" /* pesquisa com módulos informados */
                     and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
                     and can-find (first modul-particip-escalnda
                                   where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                     and modul-particip-escalnda.cdn-modul              = cd-modulo-par):
/* pode validar se tem movimento - se criar regras por modulo considerando os grupos    */

               end.
          else for first regra-particip-escalnda fields(cdd-seq-regra-escalnda) no-lock
                   where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
                     and regra-particip-escalnda.num-propost       = 0
                     and regra-particip-escalnda.cdn-plano         = cd-plano-par
                     and regra-particip-escalnda.cdn-tip-plano     = cd-tipo-plano-par
                     and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
                     and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
                     and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
                     and regra-particip-escalnda.ind-modul         = "S" /* pesquisa com módulos informados */
                     and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
                     and can-find (first modul-particip-escalnda
                                   where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                     and modul-particip-escalnda.cdn-modul              = cd-modulo-par):
/* testa se tem movimento */
               end.
          if avail regra-particip-escalnda
          then do:
                 if can-find (first faixa-particip-escalnda
                              where faixa-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                and (faixa-particip-escalnda.qti-faixa-inicial   >= qt-faixa-inicial-par
                                  or (faixa-particip-escalnda.qti-faixa-inicial  < qt-faixa-inicial-par
                                  and faixa-particip-escalnda.qti-faixa-final   >= qt-faixa-inicial-par)))
                 then do:
                        if faixa-particip-escalnda.qti-faixa-inicial          = qt-faixa-inicial-par     
                       and faixa-particip-escalnda.qti-faixa-final            = qt-faixa-final-par       
                       and faixa-particip-escalnda.log-perc-cobr-ele          = lg-percentual-cob-ele-par
                       and faixa-particip-escalnda.val-perc-particip-cobr-ele = pc-part-cob-ele-par      
                       and faixa-particip-escalnda.cdn-moed-particip-cobr-ele = cd-moeda-part-cob-ele-par
                       and faixa-particip-escalnda.qti-moed-particip-cobr-ele = qt-part-cob-ele-par      
                       and faixa-particip-escalnda.log-perc-cobr-urgen        = lg-percentual-cob-urg-par
                       and faixa-particip-escalnda.val-perc-particip-cobr-urg = pc-part-cob-urg-par      
                       and faixa-particip-escalnda.cdn-moed-particip-cobr-urg = cd-moeda-part-cob-urg-par
                       and faixa-particip-escalnda.qti-moed-particip-cobr-urg = qt-part-cob-urg-par                                  
                       then do: /* se for tudo igual - significa que a faixa ja existe e nao deve apresentar erro */
                               assign lg-retorna-aux = yes.
                             end.
                       else do:
                              assign lg-retorna-aux = yes. /* tratativa de erro retirada 05/04/2016 - TGO 
                              assign ds-erro-aux = "Regra modulos agrupados ja cadastrada - faixa colidente.".
                              run cria-tmp-relat-erro(input in-tabela-par,
                                                      input cd-modalidade-par,        /* cd-modalidade        */
                                                      input nr-proposta-par,          /* nr-proposta          */
                                                      input cd-plano-par,             /* cd-plano             */
                                                      input cd-tipo-plano-par,        /* cd-tipo-plano        */
                                                      input cd-local-atendimento-par, /* cd-local-atendimento */
                                                      input dt-limite-par,            /* dt-limite            */
                                                      input cd-modulo-par,            /* cd-modulo            */
                                                      input in-tipo-movto-par,        /* in-tipo-movto        */
                                                      input cd-grp-tip-movto-par,     /* cd-grp-tip-movto     */
                                                      input cd-movto-par,             /* cd-movto             */
                                                      input qt-faixa-inicial-par,     /* qt-faixa-inicial     */
                                                      input qt-faixa-final-par,       /* qt-faixa-final       */
                                                      input ds-erro-aux).             /* descricao do erro    */
                               */
                            end.
                      end.
                 else do:
                        run cria-tmp-relat-acomp(input in-tabela-par,
                                                 input cd-modalidade-par,             /* cd-modalidade        */
                                                 input nr-proposta-par,               /* nr-proposta          */
                                                 input cd-plano-par,                  /* cd-plano             */
                                                 input cd-tipo-plano-par,             /* cd-tipo-plano        */
                                                 input cd-local-atendimento-par,      /* cd-local-atendimento */
                                                 input dt-limite-par,                 /* dt-limite            */
                                                 input cd-modulo-par,                 /* cd-modulo            */
                                                 input in-tipo-movto-par,             /* in-tipo-movto        */
                                                 input cd-grp-tip-movto-par,          /* cd-grp-tip-movto     */
                                                 input cd-movto-par,                  /* cd-movto             */
                                                 input qt-faixa-inicial-par,          /* qt-faixa-inicial     */
                                                 input qt-faixa-final-par,            /* qt-faixa-final       */
                                                 input 3,                             /* ind-atualizado-faixa */
                                                 input lg-percentual-cob-ele-par,
                                                 input pc-part-cob-ele-par,      
                                                 input cd-moeda-part-cob-ele-par,
                                                 input qt-part-cob-ele-par,      
                                                 input lg-percentual-cob-urg-par,
                                                 input pc-part-cob-urg-par,      
                                                 input cd-moeda-part-cob-urg-par,
                                                 input qt-part-cob-urg-par).
                        /*if not lg-simula-aux
                        then */ do transaction:
                               assign cdd-seq-faixa-aux = 1.
                               for last faixa-particip-escalnda fields (cdd-seq-faixa) no-lock
                                  where faixa-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda :
                                  assign cdd-seq-faixa-aux = faixa-particip-escalnda.cdd-seq-faixa + 1.
                               end.

                               create faixa-particip-escalnda.
                               assign faixa-particip-escalnda.cdd-seq-regra-escalnda     = regra-particip-escalnda.cdd-seq-regra-escalnda
                                      faixa-particip-escalnda.cdd-seq-faixa              = cdd-seq-faixa-aux
                                      faixa-particip-escalnda.qti-faixa-inicial          = qt-faixa-inicial-par
                                      faixa-particip-escalnda.qti-faixa-final            = qt-faixa-final-par
                                      faixa-particip-escalnda.log-perc-cobr-ele          = lg-percentual-cob-ele-par
                                      faixa-particip-escalnda.val-perc-particip-cobr-ele = pc-part-cob-ele-par
                                      faixa-particip-escalnda.cdn-moed-particip-cobr-ele = cd-moeda-part-cob-ele-par
                                      faixa-particip-escalnda.qti-moed-particip-cobr-ele = qt-part-cob-ele-par
                                      faixa-particip-escalnda.log-perc-cobr-urgen        = lg-percentual-cob-urg-par
                                      faixa-particip-escalnda.val-perc-particip-cobr-urg = pc-part-cob-urg-par
                                      faixa-particip-escalnda.cdn-moed-particip-cobr-urg = cd-moeda-part-cob-urg-par
                                      faixa-particip-escalnda.qti-moed-particip-cobr-urg = qt-part-cob-urg-par
                                      faixa-particip-escalnda.dat-ult-atualiz            = today
                                      faixa-particip-escalnda.hra-ult-atualiz            = string(time,"HH:MM:SS")
                                      faixa-particip-escalnda.cod-usuar-ult-atualiz      = v_cod_usuar_corren.
                             /* pendente - registro nao está disponivel */
/*                               if regra-particip-escalnda.dat-fim-vigenc < dt-limite-par
                               then assign regra-particip-escalnda.dat-fim-vigenc = dt-limite-par.*/
                             end.
                      end.
                      assign lg-retorna-aux = yes.
               end.
          else do: /* nao esta repetido, verifica se ja existe regra de outro modulo agrupado */
                 if nr-proposta-par <> 0
                 then for first regra-particip-escalnda fields(cdd-seq-regra-escalnda) no-lock
                          where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
                            and regra-particip-escalnda.num-propost       = nr-proposta-par
                            and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
                            and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
                            and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
                            and regra-particip-escalnda.ind-modul         = "S" /* pesquisa com módulos informados */
                            and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
                         /* and regra-particip-escalnda.ind-acao-movto    = ind-acao-movto-aux */
                            and can-find (first modul-particip-escalnda
                                          where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                            and (modul-particip-escalnda.cdn-modul = 149
                                              or modul-particip-escalnda.cdn-modul = 150
                                              or modul-particip-escalnda.cdn-modul = 249
                                              or modul-particip-escalnda.cdn-modul = 250)):
                      end.
                 else for first regra-particip-escalnda fields(cdd-seq-regra-escalnda) no-lock
                          where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
                            and regra-particip-escalnda.cdn-plano         = cd-plano-par
                            and regra-particip-escalnda.cdn-tip-plano     = cd-tipo-plano-par
                            and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
                            and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
                            and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
                            and regra-particip-escalnda.ind-modul         = "S" /* pesquisa com módulos informados */
                            and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
                         /* and regra-particip-escalnda.ind-acao-movto    = ind-acao-movto-aux */
                            and can-find (first modul-particip-escalnda
                                          where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                            and (modul-particip-escalnda.cdn-modul = 149
                                              or modul-particip-escalnda.cdn-modul = 150
                                              or modul-particip-escalnda.cdn-modul = 249
                                              or modul-particip-escalnda.cdn-modul = 250)):

                      end.
                 if avail regra-particip-escalnda
                 then do:
                        run cria-tmp-relat-acomp(input in-tabela-par,
                                                 input cd-modalidade-par,             /* cd-modalidade        */
                                                 input nr-proposta-par,               /* nr-proposta          */
                                                 input cd-plano-par,                  /* cd-plano             */
                                                 input cd-tipo-plano-par,             /* cd-tipo-plano        */
                                                 input cd-local-atendimento-par,      /* cd-local-atendimento */
                                                 input dt-limite-par,                 /* dt-limite            */
                                                 input cd-modulo-par,                 /* cd-modulo            */
                                                 input in-tipo-movto-par,             /* in-tipo-movto        */
                                                 input cd-grp-tip-movto-par,          /* cd-grp-tip-movto     */
                                                 input cd-movto-par,                  /* cd-movto             */
                                                 input qt-faixa-inicial-par,          /* qt-faixa-inicial     */
                                                 input qt-faixa-final-par,            /* qt-faixa-final       */
                                                 input 2,
                                                 input lg-percentual-cob-ele-par,
                                                 input pc-part-cob-ele-par,      
                                                 input cd-moeda-part-cob-ele-par,
                                                 input qt-part-cob-ele-par,      
                                                 input lg-percentual-cob-urg-par,
                                                 input pc-part-cob-urg-par,      
                                                 input cd-moeda-part-cob-urg-par,
                                                 input qt-part-cob-urg-par).
                        /*if not lg-simula-aux
                        then*/ do transaction:
                               create modul-particip-escalnda.
                               assign modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                      modul-particip-escalnda.cdn-modul              = cd-modulo-par
                                      modul-particip-escalnda.dat-ult-atualiz        = today
                                      modul-particip-escalnda.hra-ult-atualiz        = string(time,"HH:MM:SS")
                                      modul-particip-escalnda.cod-usuar-ult-atualiz  = v_cod_usuar_corren.
                               assign lg-retorna-aux = yes.
                             end.
                      end.
               end.
        end.
   else do: /* ------------------------- tratativa para modulos nao agrupados -------------- */
          if nr-proposta-par <> 0
          then for first regra-particip-escalnda fields(cdd-seq-regra-escalnda dat-fim-vigenc) no-lock
                   where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
                     and regra-particip-escalnda.num-propost       = nr-proposta-par
                     and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
                     and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
                     and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
                     and regra-particip-escalnda.ind-modul         = "S" /* pesquisa com módulos informados */
                     and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
                     and regra-particip-escalnda.ind-acao-movto    = ind-acao-movto-aux
                     and can-find (first modul-particip-escalnda
                                   where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                     and modul-particip-escalnda.cdn-modul              = cd-modulo-par)
                     and (can-find (first movto-particip-escalnda
                                   where movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                     and (movto-particip-escalnda.cdn-modul             = cd-modulo-par
                                       or movto-particip-escalnda.cdn-modul             = 0)
                                     and movto-particip-escalnda.ind-tip-movto          = in-tipo-movto-par
                                     and movto-particip-escalnda.cdn-grp-tip-movto      = cd-grp-tip-movto-par
                                     and movto-particip-escalnda.cdn-movto              = cd-movto-par)
                          or (not can-find (first movto-particip-escalnda
                                            where movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda)
                              and cd-grp-tip-movto-par = 0 and cd-movto-par = 0)):
               end.
          else for first regra-particip-escalnda fields(cdd-seq-regra-escalnda dat-fim-vigenc) no-lock
                   where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
                     and regra-particip-escalnda.cdn-plano         = cd-plano-par
                     and regra-particip-escalnda.cdn-tip-plano     = cd-tipo-plano-par
                     and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
                     and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
                     and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
                     and regra-particip-escalnda.ind-modul         = "S" /* pesquisa com módulos informados */
                     and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
                     and regra-particip-escalnda.ind-acao-movto    = ind-acao-movto-aux
                     and can-find (first modul-particip-escalnda
                                   where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                     and modul-particip-escalnda.cdn-modul              = cd-modulo-par)
                     and (can-find (first movto-particip-escalnda
                                   where movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                     and (movto-particip-escalnda.cdn-modul             = cd-modulo-par
                                       or movto-particip-escalnda.cdn-modul             = 0)
                                     and movto-particip-escalnda.ind-tip-movto          = in-tipo-movto-par
                                     and movto-particip-escalnda.cdn-grp-tip-movto      = cd-grp-tip-movto-par
                                     and movto-particip-escalnda.cdn-movto              = cd-movto-par)
                          or (not can-find (first movto-particip-escalnda
                                            where movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda)
                              and cd-grp-tip-movto-par = 0 and cd-movto-par = 0)):
               end.
          if avail regra-particip-escalnda
          then do:
                 /* -------- verifica se é outra faixa da mesma regra ------ */
                 if can-find (first faixa-particip-escalnda
                              where faixa-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                                and (faixa-particip-escalnda.qti-faixa-inicial   >= qt-faixa-inicial-par
                                  or (faixa-particip-escalnda.qti-faixa-inicial  < qt-faixa-inicial-par
                                  and faixa-particip-escalnda.qti-faixa-final   >= qt-faixa-inicial-par)))
                 then do:
                        assign ds-erro-aux = "Intervalo da faixa colide com outra faixa ja cadastrada.".
                        run cria-tmp-relat-erro(input in-tabela-par,
                                                input cd-modalidade-par,        /* cd-modalidade        */
                                                input nr-proposta-par,          /* nr-proposta          */
                                                input cd-plano-par,             /* cd-plano             */
                                                input cd-tipo-plano-par,        /* cd-tipo-plano        */
                                                input cd-local-atendimento-par, /* cd-local-atendimento */
                                                input dt-limite-par,            /* dt-limite            */
                                                input cd-modulo-par,            /* cd-modulo            */
                                                input in-tipo-movto-par,        /* in-tipo-movto        */
                                                input cd-grp-tip-movto-par,     /* cd-grp-tip-movto     */
                                                input cd-movto-par,             /* cd-movto             */
                                                input qt-faixa-inicial-par,     /* qt-faixa-inicial     */
                                                input qt-faixa-final-par,       /* qt-faixa-final       */
                                                input ds-erro-aux).             /* descricao do erro    */
                      end.
                 else do:
                        run cria-tmp-relat-acomp(input in-tabela-par,
                                                 input cd-modalidade-par,             /* cd-modalidade        */
                                                 input nr-proposta-par,               /* nr-proposta          */
                                                 input cd-plano-par,                  /* cd-plano             */
                                                 input cd-tipo-plano-par,             /* cd-tipo-plano        */
                                                 input cd-local-atendimento-par,      /* cd-local-atendimento */
                                                 input dt-limite-par,                 /* dt-limite            */
                                                 input cd-modulo-par,                 /* cd-modulo            */
                                                 input in-tipo-movto-par,             /* in-tipo-movto        */
                                                 input cd-grp-tip-movto-par,          /* cd-grp-tip-movto     */
                                                 input cd-movto-par,                  /* cd-movto             */
                                                 input qt-faixa-inicial-par,          /* qt-faixa-inicial     */
                                                 input qt-faixa-final-par,            /* qt-faixa-final       */
                                                 input 3,                             /* ind-atualizado-faixa */
                                                 input lg-percentual-cob-ele-par,
                                                 input pc-part-cob-ele-par,      
                                                 input cd-moeda-part-cob-ele-par,
                                                 input qt-part-cob-ele-par,      
                                                 input lg-percentual-cob-urg-par,
                                                 input pc-part-cob-urg-par,      
                                                 input cd-moeda-part-cob-urg-par,
                                                 input qt-part-cob-urg-par).

                        /*if not lg-simula-aux
                        then*/ do transaction:
                               assign cdd-seq-faixa-aux = 1.
                               for last faixa-particip-escalnda fields (cdd-seq-faixa) no-lock
                                  where faixa-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda :
                                  assign cdd-seq-faixa-aux = faixa-particip-escalnda.cdd-seq-faixa + 1.
                               end.

                               create faixa-particip-escalnda.
                               assign faixa-particip-escalnda.cdd-seq-regra-escalnda     = regra-particip-escalnda.cdd-seq-regra-escalnda
                                      faixa-particip-escalnda.cdd-seq-faixa              = cdd-seq-faixa-aux
                                      faixa-particip-escalnda.qti-faixa-inicial          = qt-faixa-inicial-par
                                      faixa-particip-escalnda.qti-faixa-final            = qt-faixa-final-par
                                      faixa-particip-escalnda.log-perc-cobr-ele          = lg-percentual-cob-ele-par
                                      faixa-particip-escalnda.val-perc-particip-cobr-ele = pc-part-cob-ele-par
                                      faixa-particip-escalnda.cdn-moed-particip-cobr-ele = cd-moeda-part-cob-ele-par
                                      faixa-particip-escalnda.qti-moed-particip-cobr-ele = qt-part-cob-ele-par
                                      faixa-particip-escalnda.log-perc-cobr-urgen        = lg-percentual-cob-urg-par
                                      faixa-particip-escalnda.val-perc-particip-cobr-urg = pc-part-cob-urg-par
                                      faixa-particip-escalnda.cdn-moed-particip-cobr-urg = cd-moeda-part-cob-urg-par
                                      faixa-particip-escalnda.qti-moed-particip-cobr-urg = qt-part-cob-urg-par
                                      faixa-particip-escalnda.dat-ult-atualiz            = today
                                      faixa-particip-escalnda.hra-ult-atualiz            = string(time,"HH:MM:SS")
                                      faixa-particip-escalnda.cod-usuar-ult-atualiz      = v_cod_usuar_corren.
                             /* pendente - registro nao está disponivel */
/*                               if regra-particip-escalnda.dat-fim-vigenc < dt-limite-par
                               then assign regra-particip-escalnda.dat-fim-vigenc = dt-limite-par. */
                             end.
                      end.
                 assign lg-retorna-aux = yes.
               end.
        end.

  if lg-retorna-aux
  then leave.

  /* ---------------------- localiza properus --------------------------- */
  run busca-properus(input cd-modalidade-par,
                     input nr-ter-adesao-aux,
                     input cd-plano-aux,
                     input cd-tipo-plano-aux,
                     input cd-modulo-par,
                     input in-tipo-movto-par,
                     input cd-esp-amb-aux,
                     input cd-grupo-proc-amb-aux,
                     input cd-procedimento-aux,
                     input dv-procedimento-aux,
                     input cd-grupo-esp-amb-aux,
                     input cd-subgrupo-esp-amb-aux,
                     input cd-grp-tip-movto-par,
                     input cd-movto-par).
/* regra removida 05/04/2016 - TGO
  if not avail properus
 and lg-modulo-agrupado
 then do:
        for first properus fields ( in-periodo in-controle-responsavel nr-meses ) no-lock
            where properus.cd-modalidade       = 1
              and properus.cd-plano            = 3
              and properus.cd-tipo-plano       = 5
              and properus.nr-ter-adesao       = 0
              and properus.cd-esp-amb          = 65
              and properus.cd-grupo-proc-amb   = 19
              and properus.cd-procedimento     = 22
              and properus.dv-procedimento     = 0
              and properus.cd-modulo           = 106:
        end.
      end.
*/
  if not avail properus
  then do:
         assign ds-erro-aux = "Parametro do quantitativo nao foi localizado.".
         run cria-tmp-relat-erro(input in-tabela-par,
                                 input cd-modalidade-par,             /* cd-modalidade        */
                                 input nr-proposta-par,               /* nr-proposta          */
                                 input cd-plano-par,                  /* cd-plano             */
                                 input cd-tipo-plano-par,             /* cd-tipo-plano        */
                                 input cd-local-atendimento-par,      /* cd-local-atendimento */
                                 input dt-limite-par,                 /* dt-limite            */
                                 input cd-modulo-par,                 /* cd-modulo            */
                                 input in-tipo-movto-par,             /* in-tipo-movto        */
                                 input cd-grp-tip-movto-par,          /* cd-grp-tip-movto     */
                                 input cd-movto-par,                  /* cd-movto             */
                                 input qt-faixa-inicial-par,          /* qt-faixa-inicial     */
                                 input qt-faixa-final-par,            /* qt-faixa-final       */
                                 input ds-erro-aux).                  /* descricao do erro    */
         leave.
       end.
  /*if not lg-simula-aux
then*/ do transaction:
         
         if lg-simula-aux
         then do:
                find last regra-particip-escalnda no-lock no-error.
                if avail regra-particip-escalnda
                then assign cdd-seq-regra-escalnda-aux = regra-particip-escalnda.cdd-seq-regra-escalnda + 1.
                else assign cdd-seq-regra-escalnda-aux = 1. 
              end.
         else do:
                assign cdd-seq-regra-escalnda-aux = next-value(seq-regra-particip-escalnda).
              end.

         create regra-particip-escalnda.
         assign regra-particip-escalnda.cdd-seq-regra-escalnda = cdd-seq-regra-escalnda-aux 
                regra-particip-escalnda.cdn-modalid            = cd-modalidade-par
                regra-particip-escalnda.num-proposta           = nr-proposta-par
                regra-particip-escalnda.cdn-plano              = cd-plano-par
                regra-particip-escalnda.cdn-tip-plano          = cd-tipo-plano-par
                regra-particip-escalnda.cdn-local-atendim      = cd-local-atendimento-par
                regra-particip-escalnda.ind-tip-movto          = in-tipo-movto-par
                regra-particip-escalnda.ind-acao-movto         = ind-acao-movto-aux
                regra-particip-escalnda.dat-inic-vigenc        = dt-inic-regra-aux
                regra-particip-escalnda.dat-fim-vigenc         = dt-limite-par
                regra-particip-escalnda.ind-period-control     = properus.in-periodo
                regra-particip-escalnda.qti-period-control     = if can-do("R,I,M",properus.in-period) then properus.nr-meses else 0
                regra-particip-escalnda.ind-metod-control      = metodo-controle(properus.in-controle-responsavel)
                regra-particip-escalnda.log-recalc-pend        = yes
                regra-particip-escalnda.dat-ult-atualiz        = today
                regra-particip-escalnda.hra-ult-atualiz        = string(time,"HH:MM:SS")
                regra-particip-escalnda.cod-usuar-ult-atualiz  = v_cod_usuar_corren.

         if cd-modulo-par <> 0
         then do:
                /* cria parametro por modulo */
                create modul-particip-escalnda.
                assign modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                       modul-particip-escalnda.cdn-modul              = cd-modulo-par
                       modul-particip-escalnda.dat-ult-atualiz        = today
                       modul-particip-escalnda.hra-ult-atualiz        = string(time,"HH:MM:SS")
                       modul-particip-escalnda.cod-usuar-ult-atualiz  = v_cod_usuar_corren
                       regra-particip-escalnda.ind-modul              = "S".
              end.
         else do:
                assign regra-particip-escalnda.ind-modul = "T".
              end.
         /* -------- cria parametro por grupo/movimento se tabela antiga controla por grupo/tipo procedimento/insumo ------- */
         if ind-acao-movto-aux <> " "         /* nao cria movto para os modulos agrupados - excecao 211 e 212*/
         then do:
                create movto-particip-escalnda.
                assign movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                       movto-particip-escalnda.cdn-modul              = 0 /*if cd-modulo-par = 211 or cd-modulo-par = 212
                                                                        then cd-modulo-par
                                                                        else 0*/
                       movto-particip-escalnda.ind-tip-movto          = in-tipo-movto-par
                       movto-particip-escalnda.cdn-grp-tip-movto      = cd-grp-tip-movto-par
                       movto-particip-escalnda.cdn-movto              = cd-movto-par
                       movto-particip-escalnda.ind-acao-movto         = ind-acao-movto-aux
                       movto-particip-escalnda.dat-ult-atualiz        = today
                       movto-particip-escalnda.hra-ult-atualiz        = string(time,"HH:MM:SS")
                       movto-particip-escalnda.cod-usuar-ult-atualiz  = v_cod_usuar_corren.
              end.

         /* ---------------------------- cria primeira faixa de participacao ------------------------------- */
         create faixa-particip-escalnda.
         assign faixa-particip-escalnda.cdd-seq-regra-escalnda     = regra-particip-escalnda.cdd-seq-regra-escalnda
                faixa-particip-escalnda.cdd-seq-faixa              = 1
                faixa-particip-escalnda.qti-faixa-inicial          = qt-faixa-inicial-par
                faixa-particip-escalnda.qti-faixa-final            = qt-faixa-final-par
                faixa-particip-escalnda.log-perc-cobr-ele          = lg-percentual-cob-ele-par
                faixa-particip-escalnda.val-perc-particip-cobr-ele = pc-part-cob-ele-par
                faixa-particip-escalnda.cdn-moed-particip-cobr-ele = cd-moeda-part-cob-ele-par
                faixa-particip-escalnda.qti-moed-particip-cobr-ele = qt-part-cob-ele-par
                faixa-particip-escalnda.log-perc-cobr-urgen        = lg-percentual-cob-urg-par
                faixa-particip-escalnda.val-perc-particip-cobr-urg = pc-part-cob-urg-par
                faixa-particip-escalnda.cdn-moed-particip-cobr-urg = cd-moeda-part-cob-urg-par
                faixa-particip-escalnda.qti-moed-particip-cobr-urg = qt-part-cob-urg-par
                faixa-particip-escalnda.dat-ult-atualiz            = today
                faixa-particip-escalnda.hra-ult-atualiz            = string(time,"HH:MM:SS")
                faixa-particip-escalnda.cod-usuar-ult-atualiz      = v_cod_usuar_corren.
       end.
  run cria-tmp-relat-acomp(input in-tabela-par,
                           input cd-modalidade-par,             /* cd-modalidade        */
                           input nr-proposta-par,               /* nr-proposta          */
                           input cd-plano-par,                  /* cd-plano             */
                           input cd-tipo-plano-par,             /* cd-tipo-plano        */
                           input cd-local-atendimento-par,      /* cd-local-atendimento */
                           input dt-limite-par,                 /* dt-limite            */
                           input cd-modulo-par,                 /* cd-modulo            */
                           input in-tipo-movto-par,             /* in-tipo-movto        */
                           input cd-grp-tip-movto-par,          /* cd-grp-tip-movto     */
                           input cd-movto-par,                  /* cd-movto             */
                           input qt-faixa-inicial-par,          /* qt-faixa-inicial     */
                           input qt-faixa-final-par,            /* qt-faixa-final       */
                           input 1,                             /* ind-atualizado-regra */
                           input lg-percentual-cob-ele-par,
                           input pc-part-cob-ele-par,      
                           input cd-moeda-part-cob-ele-par,
                           input qt-part-cob-ele-par,      
                           input lg-percentual-cob-urg-par,
                           input pc-part-cob-urg-par,      
                           input cd-moeda-part-cob-urg-par,
                           input qt-part-cob-urg-par).




end procedure.
/* ----------------------------------------- EOF --------------------------------------- */