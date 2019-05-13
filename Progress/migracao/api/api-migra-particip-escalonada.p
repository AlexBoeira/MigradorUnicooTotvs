/************************************************************************************************
*      Programa .....: api-migra-particip-escalonada.p                                          *
*      Data .........: 06 de Setembro de 2016                                                   *
*      Sistema ......: API - APLICATION PROGRAM INTERFACE                                       *
*      Empresa ......: TOTVS                                                                    *
*      Programador ..: Jaine Marin                                                              *
*      Objetivo .....: API para migracao das tabelas de participacao escalonada                 *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      E.00.000  06/09/2016  Jaine Marin     Desenvolvimento                                    *
************************************************************************************************/

/* ----------------------------------------------------------------------------------------------- */
def var dt-inic-regra-aux                  as date format "99/99/9999" initial 01/01/2013    no-undo.
def var ind-acao-movto-aux                 as char                                           no-undo.
def var ds-erro-aux                        as char format "x(50)"                            no-undo.
def var lg-erro-aux                        as log                                            no-undo.
def var cd-esp-amb-aux                   like moviproc.cd-esp-amb                            no-undo.
def var cd-grupo-proc-amb-aux            like moviproc.cd-grupo-proc-amb                     no-undo.
def var cd-procedimento-aux              like moviproc.cd-procedimento                       no-undo.
def var dv-procedimento-aux              like moviproc.dv-procedimento                       no-undo.
def var cd-grupo-esp-amb-aux             like ambproce.cd-grupo-esp-amb                      no-undo.
def var cd-subgrupo-esp-amb-aux          like ambproce.cd-subgrupo-esp-amb                   no-undo.
def var nr-ter-adesao-aux                like propost.nr-ter-adesao                          no-undo.
def var cd-plano-aux                     like propost.cd-plano                               no-undo.
def var cd-tipo-plano-aux                like propost.cd-tipo-plano                          no-undo.
def var cdd-seq-faixa-aux                  as dec                                            no-undo.
def var cdd-seq-modul-aux                  as dec                                            no-undo.
def var lg-retorna-aux                     as log                                            no-undo.
def var cdd-seq-regra-escalnda-aux       like regra-particip-escalnda.cdd-seq-regra-escalnda no-undo.

/* ----------------------------------------------------------------------------------------------- */
/* Funcao para converter o campo metodo de controle da properus para tabela regra-particip-escalnda */
function metodo-controle returns char (input in-controle-aux as int ):
    case in-controle-aux :
         when 1 then return "I".
         when 2 then return "I".
         when 3 then return "A".
         when 4 then return "C".
    end case.
end function.


/* --- Inicio processo --------------------------------------------------------------------------- */
for each propost fields (cd-modalidade nr-proposta cd-sit-proposta nr-ter-adesao cd-plano cd-tipo-plano) no-lock:

    for each fxparpro fields(cd-modalidade nr-proposta cd-modulo in-tipo-movto cd-gr-proc-tp-insumo cd-proced-insumo
                             qt-faixa-inicial qt-faixa-final dt-limite lg-percentual-cob-ele pc-part-cob-ele cd-moeda-part-cob-ele qt-part-cob-ele
                             lg-percentual-cob-urg pc-part-cob-urg cd-moeda-part-cob-urg qt-part-cob-urg) no-lock
       where fxparpro.cd-modalidade = propost.cd-modalidade
         and fxparpro.nr-proposta   = propost.nr-proposta
         and fxparpro.dt-limite    >= today
          by fxparpro.cd-modalidade
          by fxparpro.nr-proposta
          by fxparpro.cd-modulo
          by fxparpro.in-tipo-movto
          by fxparpro.cd-gr-proc-tp-insumo
          by fxparpro.cd-proced-insumo
          by fxparpro.qt-faixa-inicial
          by fxparpro.qt-faixa-final:

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

/* ----------------------------------------------------------------------------------------------- */
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

    assign cd-grupo-esp-amb-aux    = 0
           cd-subgrupo-esp-amb-aux = 0
           cd-esp-amb-aux          = 0
           cd-grupo-proc-amb-aux   = 0
           cd-procedimento-aux     = 0
           dv-procedimento-aux     = 0
           lg-erro-aux             = no.

    /* ----------------- Quando termo cancelado antes de 2015 regra nao deve ser considerada --------------- */
    /*if can-find(first ter-ade
                where ter-ade.cd-modalidade = cd-modalidade-par
                  and ter-ade.nr-ter-adesao = propost.nr-ter-adesao
                  and ter-ade.dt-cancelamento < 01/01/2015)
    then leave.*/

    if propost.cd-sit-proposta = 90
    then leave.

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
                  run pi-grava-erro (ds-erro-aux + " - Criacao das regras de participacao.").
                  leave.
                end.
           assign ind-acao-movto-aux  = "R".              
         end.

    for first regra-particip-escalnda fields(cdd-seq-regra-escalnda dat-fim-vigenc) no-lock
        where regra-particip-escalnda.cdn-modalid       = cd-modalidade-par
          and regra-particip-escalnda.num-propost       = nr-proposta-par
          and regra-particip-escalnda.dat-inic-vigenc   = dt-inic-regra-aux
          and regra-particip-escalnda.dat-fim-vigenc    = dt-limite-par
          and regra-particip-escalnda.cdn-local-atendim = cd-local-atendimento-par
          and regra-particip-escalnda.ind-modul         = "T" /* pesquisa com modulos informados */
          and regra-particip-escalnda.ind-tip-movto     = in-tipo-movto-par
          and regra-particip-escalnda.ind-acao-movto    = ind-acao-movto-aux
          and can-find (first modul-particip-escalnda
                        where modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                          and modul-particip-escalnda.cdn-modul              = cd-modulo-par)
          and (can-find (first movto-particip-escalnda
                        where movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                          and (movto-particip-escalnda.cdn-modul             = cd-modulo-par or
                               movto-particip-escalnda.cdn-modul             = 0)
                          and movto-particip-escalnda.ind-tip-movto          = in-tipo-movto-par
                          and movto-particip-escalnda.cdn-grp-tip-movto      = cd-grp-tip-movto-par
                          and movto-particip-escalnda.cdn-movto              = cd-movto-par)
               or (not can-find (first movto-particip-escalnda
                                 where movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda)
                                   and cd-grp-tip-movto-par = 0 and cd-movto-par = 0)):
    end.

    if avail regra-particip-escalnda
    then do:
           /* -------- verifica se e outra faixa da mesma regra ------ */
           if can-find (first faixa-particip-escalnda
                        where faixa-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                          and (faixa-particip-escalnda.qti-faixa-inicial   >= qt-faixa-inicial-par or 
                               (faixa-particip-escalnda.qti-faixa-inicial  < qt-faixa-inicial-par  and 
                                faixa-particip-escalnda.qti-faixa-final   >= qt-faixa-inicial-par)))
           then do:
                  run pi-grava-erro ("Intervalo da faixa colide com outra faixa ja cadastrada.").
                  assign lg-erro-aux = yes.
                end.
           else do:
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
                         faixa-particip-escalnda.cod-usuar-ult-atualiz      = "MIGRACAO". 
                end.
           assign lg-retorna-aux = yes.
         end.

    if lg-retorna-aux
    then leave.
    
    /* ---------------------- localiza properus --------------------------- */
    run busca-properus(input cd-modalidade-par,
                       input propost.nr-ter-adesao,
                       input propost.cd-plano,
                       input propost.cd-tipo-plano,
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

    if not avail properus
    then do:
           run pi-grava-erro ("Parametros do quantitativo nao foram localizados.").
           assign lg-erro-aux = yes.
           leave.
         end.

    assign cdd-seq-regra-escalnda-aux = next-value(seq-regra-particip-escalnda).

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
           regra-particip-escalnda.cod-usuar-ult-atualiz  = "MIGRACAO".

    if cd-modulo-par <> 0
    then do:
           /* cria parametro por modulo */
           create modul-particip-escalnda.
           assign modul-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                  modul-particip-escalnda.cdn-modul              = cd-modulo-par
                  modul-particip-escalnda.dat-ult-atualiz        = today
                  modul-particip-escalnda.hra-ult-atualiz        = string(time,"HH:MM:SS")
                  modul-particip-escalnda.cod-usuar-ult-atualiz  = "MIGRACAO"
                  regra-particip-escalnda.ind-modul              = "S".
         end.
    else assign regra-particip-escalnda.ind-modul = "T".
        
    /* -------- cria parametro por grupo/movimento se tabela antiga controla por grupo/tipo procedimento/insumo ------- */
    if ind-acao-movto-aux <> " "         
    then do:
           create movto-particip-escalnda.
           assign movto-particip-escalnda.cdd-seq-regra-escalnda = regra-particip-escalnda.cdd-seq-regra-escalnda
                  movto-particip-escalnda.cdn-modul              = 0 
                  movto-particip-escalnda.ind-tip-movto          = in-tipo-movto-par
                  movto-particip-escalnda.cdn-grp-tip-movto      = cd-grp-tip-movto-par
                  movto-particip-escalnda.cdn-movto              = cd-movto-par
                  movto-particip-escalnda.ind-acao-movto         = ind-acao-movto-aux
                  movto-particip-escalnda.dat-ult-atualiz        = today
                  movto-particip-escalnda.hra-ult-atualiz        = string(time,"HH:MM:SS")
                  movto-particip-escalnda.cod-usuar-ult-atualiz  = "MIGRACAO".
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
           faixa-particip-escalnda.cod-usuar-ult-atualiz      = "MIGRACAO".

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
                then assign ds-erro-par = "Procedimento nao cadastrado"
                            lg-erro-par = yes.
              end.
         else do:
                if not can-find (gru-pro where gru-pro.cd-grupo-proc = cd-grp-tip-movto-par)
                then assign ds-erro-par = "Grupo procedimento nao cadastrado"
                            lg-erro-par = yes.
              end.
       end.
  else do:
         if cd-movto-par <> 0
        and not can-find (insumos where insumos.cd-tipo-insumo = cd-grp-tip-movto-par
                                    and insumos.cd-insumo      = cd-movto-par)
         then assign lg-erro-par = yes
                     ds-erro-par = "Insumo nao cadastrado".
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

/* ------------------------------------------------------------------------------------------- */
procedure pi-grava-erro:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.

    def var nro-seq-aux             as int no-undo.
    def var num-seqcial-control-aux as int no-undo.

    RUN pi-consulta-prox-seq (output nro-seq-aux,
                              output num-seqcial-control-aux).
    
    create erro-process-import.

    repeat while true:

        assign erro-process-import.num-seqcial         = nro-seq-aux
               erro-process-import.num-seqcial-control = num-seqcial-control-aux no-error.
        
        VALIDATE erro-process-import NO-ERROR.
        IF ERROR-STATUS:ERROR
        OR ERROR-STATUS:NUM-MESSAGES > 0
        THEN do:
               ASSIGN nro-seq-aux = nro-seq-aux + 1
                      num-seqcial-control-aux = num-seqcial-control-aux + 1.
               PAUSE(1). /* aguarda 1seg e busca novamente o proximo nr livre.*/
             END.
        else leave.    /* o nr gerado eh valido. continua o processo.*/
    end.

    assign erro-process-import.nom-tab-orig-erro   = " "
           erro-process-import.des-erro            = "api-migra-particip-escalonada - Mod.: " + string(propost.cd-modalidade )
                                                   + "Prop.: " + string(propost.nr-proposta)  + ": " + ds-erro-par
           erro-process-import.dat-erro            = today. 

end procedure.

/* ----------------------------------------------------------------------------------------------- */
procedure pi-consulta-prox-seq:

    def output parameter nro-seq-par              as int initial 0  no-undo.
    def output parameter num-seqcial-control-par  as int initial 0  no-undo.

    select max(erro-process-import.num-seqcial) 
    into nro-seq-par 
    from erro-process-import.

    if nro-seq-par = ?
    then assign nro-seq-par = 1.
    else assign nro-seq-par = nro-seq-par + 1.

    select max(erro-process-import.num-seqcial-control) 
    into num-seqcial-control-par 
    from erro-process-import.

    if num-seqcial-control-par = ?
    then assign num-seqcial-control-par = 1.
    else assign num-seqcial-control-par = num-seqcial-control-par + 1.

end procedure.


