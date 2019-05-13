/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i CG0110L 2.00.00.056M} /*** 010056 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
/*{include/i-license-manager.i cg0110l MCG}*/
&ENDIF

/******************************************************************************
*      Programa .....: cg0110l.p                                              *
*      Data .........: 03 de Novembro de 1997                                 *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Moacir Silveira Junior                                 *
*      Objetivo .....: Importar dados dos Prestadores                         *
******************************************************************************/
hide all no-pause.
/* -------------------- TRIGGER CREATE UPDATE DA TABELA ---------------------- */
{trs/wrpreviesp.i}
{trs/wrpreserv.i}
{trs/wrcontrat.i}
{trs/wrusuario.i}
{trs/wrunimed.i}
{trs/wrendpres.i}
{trs/wrclinicas.i}


{hdp/hdvarregua.i}    
{hdp/hdregpacoimla.i} 
{hdp/hdregpacoimla.f} 
{hdp/hd9000.i "cg0110l"}
{hdp/hdsistem.i}       /*** Verifica se e magnus ou EMS           ***/
{hdp/hdvarrel.i}

{hdp/hdrunpersis.iv "new"}
{rtp/rtrowerror.i}
{bosau/bosaudemographic.i}
{bosau/bosaucontact.i}
{bosau/bosauaddress.i}
{bosau/bosauconfigfileauditory.i}
{bosau/global/bosauattachment.i}
{bosau/bosaucompany.i}
 
nm-cab-usuario = "Importacao de Prestadores".
nm-prog        = "CG/0110L".
c-versao       = "7.26.002".
{hdp/hdlog.i}
 
{hdp/hdvararq.i "spool/" "IMPPREST" "LST"} 
 
/* -------------- CHAMADA DAS TRIGGERS DE WRITE / DELETE PARA INTEGRACAO --- */
{trs/wrpreserv.i}
{trs/depreserv.i}
{trs/wrendpres.i}
{trs/deendpres.i}
{trs/wrpreviesp.i}
{trs/depreviesp.i}
 
def new shared stream s-acertos.

/*------------------ DEFINIR FRAMES, REGISTROS TEMP-TABLES ------------------*/
 
{cgp/cg0110l_mig.i "new"}  /*variaveis auxiliares e temp-tables*/
{cgp/cg0110l_mig.f "new"}  /*frames*/
 
def temp-table tmp-movto-prestador  no-undo  
        field cd-unidade   like preserv.cd-unidade
        field cd-prestador like preserv.cd-prestador
        field in-movto       as int
        index tmp-mov-prest1 is primary
              cd-unidade
              cd-prestador.

define temp-table tmp-preserv-aux like preserv
    field cd-grupo-fornecedor as char
    field nm-mae              as char.
define temp-table tmp-previesp-aux no-undo like previesp.
define temp-table tmp-endpres-aux no-undo like endpres.
define temp-table tmp-prestdor-ender-aux no-undo like prestdor-ender.
define temp-table tmp-prest-inst-aux no-undo like prest-inst.
define temp-table tmp-prestdor-obs-aux no-undo like prestdor-obs.

def var h-apiadministrativeintegration-aux as handle no-undo.
def var h-bosauDemographic-aux             as handle no-undo.  
def var h-bosauCompany-aux                 as handle no-undo.

/*---------------------------- VARIAVEIS DE USO GERAL -----------------------*/
def new shared var c-nr-seq-endereco    as int                         no-undo.
def new shared var lg-aviso             as logical initial no          no-undo.
def new shared var ds-rodape            as char format "x(132)"        no-undo.
def new shared var ep-codigo-aux        like paramecp.ep-codigo        no-undo.
def new shared var cd-retorno           as log                         no-undo.
def new shared var cd-unimed-z          like unimed.cd-unimed          no-undo. 
def new shared var cd-med-prest-z       like preserv.cd-prestador      no-undo.
def new shared var cd-tab-urge-z        like preserv.cd-tab-urge       no-undo.
def new shared var in-entidade-z        like motcange.in-entidade      no-undo.
def new shared var cd-mot-can-z         like motcange.cd-motivo        no-undo.

def var lg-migracao-aux                 as log init no                 no-undo.

def var tt-prest-erros-atual            as int                         no-undo.
def var tt-prest-aviso-atual            as int                         no-undo.
def var tp-registro                     as int                         no-undo.
def var nm-arquivo-erros                as char format "x(30)"
    view-as fill-in size 41 by 1.3      native                         no-undo.
def var lg-arquivo-aux                  as log init no                 no-undo.
def var lg-parametro-aux                as log init no                 no-undo.
def var lg-consiste-aux                 as log init no                 no-undo.
def var ds-cabecalho                    as char format "x(35)"         no-undo.
def var nm-arquivo-quo-aux              as char format "x(30)"         no-undo.
def var nm-unidade-aux                  like unimed.nm-unimed
    view-as fill-in size 41 by 1.3      native                         no-undo.
def var cd-prestador-aux                like preserv.cd-prestador
    view-as fill-in size 9 by 1.3       native                         no-undo.
def var nm-prestador-aux                like preserv.nm-prestador
    view-as fill-in size 71 by 1.3      native                         no-undo.
def var nm-prog-p-aux                   as char format "x(60)"         no-undo.
def var nm-prog-r-aux                   as char format "x(60)"         no-undo.

def var cd-grupo-prestador-aux          as int                         no-undo.
def var cd-cidade-aux                   as int                         no-undo.
def var cd-especialidade1-aux           as int                         no-undo.
def var cd-especialidade2-aux           as int                         no-undo.
def var cd-vinculo-aux                  as int                         no-undo.
def var nr-seq-endereco-aux             as int                         no-undo.
def var cont-migra-aux                  as int init 1                  no-undo.

def var cd-especialid-jur-aux           like  esp-med.cd-especialid    no-undo.
def new shared var cd-especialid-z      like  esp-med.cd-especialid    no-undo.
def var lg-importacao-total             as log                         no-undo.
def var nr-senha-dec-aux                as dec format 99999999999999999999        
                                                                       no-undo.
def var cd-senha-aux                    as int format 999999           no-undo. 
def var lg-erro-rtsenha-aux             as log                         no-undo.
def var ds-erro-aux                     as char                        no-undo.
def var lista-indice-ir                 as char                        no-undo.
def var ds-indice-ir                    as char format "x(28)"         no-undo.
def var lg-erro-aux                     as log                         no-undo.
def var tt-prest-inc-aux                as int                         no-undo.
def var tt-prest-alt-aux                as int                         no-undo.
def var tt-prest-exc-aux                as int                         no-undo.
def var tt-prest-reat-aux               as int                         no-undo.
def var lg-erro-linha                   as log                         no-undo.
def var ds-titulo                       as char format "x(64)"         no-undo.
def var ds-titulo-tela                  as char format "x(40)"         no-undo.
def var lg-alt-prest-aux                as log                         no-undo.
def var ix                              as int                         no-undo.
def var dt-inclusao-aux                 like preserv.dt-inclusao       no-undo.
def var lg-erro-imp-aux                 as log                         no-undo.
def var nm-diretorio-aux                as char                        no-undo.
def var ds-barra                        as char format "x(1)"          no-undo.
def var cd-grupo-fornecedor-aux         as char format "x(4)"          no-undo.
def var dt-inicio-aux                   like previesp.dt-fim-validade  no-undo.
def var dt-fim-aux                      like previesp.dt-fim-validade  no-undo.
/* ------------------------------------------ SELECTION-LIST INDICE IRRF --- */
def var mostra-indice-ir                as char view-as selection-list
                                                inner-chars 32
                                                inner-lines 03 no-undo.

/*------------------------------ DEFINIR BUFFERS ----------------------------*/
def buffer b-preserv  for preserv.
def buffer b-previesp for previesp.
def buffer b-subst-prestdor-excd for subst-prestdor-excd.
 
/*------------------------------ DEFINIR FRAMES -----------------------------*/
def rectangle retangulo edge-pixels 2 graphic-edge no-fill size 70 by 19.3.

def frame f-parametros
    cd-unidade-aux view-as fill-in size 5 by 1.3 native
                   at col 9 row 1.8 space(5)
    nm-unidade-aux no-label
    cd-prestador-aux          at col 7 row 3.2
    nm-prestador-aux no-label 
       view-as fill-in size 41 by 1.3 native
    nm-arquivo-importar label "Arquivo de Importacoes" at col  4 row 4.6
       view-as fill-in size 41 by 1.3      native
    nm-arquivo-erros    label "      Arquivo de Erros" at col  4 row 6
    cd-tab-urge-aux     label "Horario Urgencia"       at col 10 row 7.4
       view-as fill-in size  3 by 1.3      native
    horaurge.ds-tab-urge no-label
       view-as fill-in size 37 by 1.3      native skip(.5)

    cd-especialid-jur-aux   label "Especialidade Generica" at col 4 row 8.8
    view-as fill-in size  4 by 1.3      native
    esp-med.ds-especialid   no-label
       view-as fill-in size 36 by 1.3      native skip(.5)

    space(6)
    lg-codigo-ptu-aux skip 
    space(9)
    lg-calc-irrf-aux label "Calcular Imposto de renda para relatorios do RC?"
       view-as toggle-box
    lg-importacao-total label "Importa somente prestadores sem erro?"
       view-as toggle-box at 10
    lg-cons-vinc-prest-aux label "Considerar parametro vinculo do prestador?"
       view-as toggle-box at 10
    in-indice-ir-aux label "Indice IRRF"
       view-as fill-in native size 3 by 1.3                                          
       tooltip "Quais Movimentos incide o Imposto de Renda" at col 10 row 17.5
    ds-indice-ir                     no-label 
       view-as fill-in native size 31 by 1.3                                                          
       tooltip "Incide o Imposto de Renda" 
    cd-motivo-cancel-aux                label "Mot. Exc. c/ Subs."
       view-as fill-in native size 4 by 1.3
       tooltip "Motivo da Exclusao para prestadores com substituto" at col 3 row 18.9
    motcange.ds-motivo               no-label
       view-as fill-in native size 41 by 1.3
       tooltip "Descricao do motivo de cancelamento"

    retangulo             at row 1.3 col 2   space(1) skip(.5)
    with overlay row 1 centered side-labels three-d title "Parametros".

def rectangle ret-migracao edge-pixels 2 graphic-edge no-fill size 60 by 5.
def frame f-par-migracao
    nm-arquivo-importar label "Arquivo de Importacoes" at col  4 row 2
       view-as fill-in size 31 by 1.3      native
    nm-arquivo-erros    label "      Arquivo de Erros" at col  4 row 3.5
    view-as fill-in size 31 by 1.3      native
          ret-migracao               at row 1.5 col 2   space(1) skip(1)
    with overlay row 12.4 centered side-labels three-d title "Parametros".
 
def frame f-totais-tela
    tt-prest-lidos    label "     Prestadores Lidos" skip
    tt-regs-gravados  label "    Registros Gravados" skip
    tt-prest-erros    label "   Registros com Erros" skip
    tt-prest-aviso    label "  Registros com Avisos" skip
    tt-prest-gravados label "  Prestadores Gravados"
    with overlay row 14 centered side-labels color message title ds-titulo-tela.
    
def frame f-totais-ok
    skip(2)
    tt-prest-lidos    label "   Total de Prestadores Lidos" skip
    tt-regs-gravados  label "  Total de Registros Gravados" skip
    tt-prest-gravados label "Total de Prestadores Gravados"
    with overlay no-box centered side-labels.
 
def frame f-totais-erros
    skip(2)
    tt-prest-lidos    label "   Total de Prestadores Lidos" skip
    tt-prest-erros    label " Total de Registros com Erros" skip
    tt-prest-aviso    label "Total de Registros com Avisos"
    with overlay no-box centered side-labels.
 

/* --------------------------------------------------- FRAME INDICE IRFF --- */
def frame f-indice-ir
    skip(.5)
    mostra-indice-ir      no-label at 2 space(1)
    skip(.5)
    with row 10 column 28 overlay no-labels
         title " INDICE IRRF " three-d.
 

find first paramecp no-lock no-error.
if available paramecp
then do:
         find unimed
              where unimed.cd-unimed = paramecp.cd-unimed
                    no-lock no-error.
         if available unimed
         then assign ds-cabecalho = unimed.nm-unimed-reduz.
         
         assign ep-codigo-aux = paramecp.ep-codigo.
     end.
else do:
       message "Parametros do sistema nao cadastrados."
               view-as alert-box info buttons ok.
       return.
     end.

find first paramepp no-lock no-error.
if   not avail paramepp
then do:
        message "Parametros do pagamento de prestadores nao cadastrados."
                view-as alert-box title " Atencao !!! ".
        return.
     end.

 
form header
     fill("-",132)     format "x(132)"
     ds-cabecalho             at 01
     ds-titulo                at 40
     "Folha:"                 at 122
     page-number(s-erro) format ">>>9"
     fill("-", 112) format "x(112)"
     today "-" string(time, "HH:MM:SS")              skip(1)
     with no-labels width 134 no-box page-top frame f-cabec-erros.

form header
     fill("-",132)     format "x(132)"
     ds-cabecalho             at 01
     "Relatorio de Registros Importados dos Prestadores" at 40
     "Folha:"                 at 122
     page-number(s-acertos) format ">>>9"
     fill("-", 112) format "x(112)"
     today "-" string(time, "HH:MM:SS")              skip(1)
     with no-labels width 134 no-box page-top frame f-cabec-acertos.
 
assign ds-rodape = " - " + replace(nm-prog,"/","") + " - " + c-versao
       ds-rodape = fill("-",132 - length(ds-rodape)) + ds-rodape.
 
form header ds-rodape format "x(132)"
     with no-labels width 134 no-box page-bottom frame f-rodape-acertos.
 
form header ds-rodape format "x(132)"
     with no-labels width 134 no-box page-bottom frame f-rodape-erros.
 
assign cd-unidade-aux      = 0
       nm-unidade-aux      = ""
       cd-prestador-aux    = 0
       nm-prestador-aux    = ""
       nm-arquivo-importar = "c:~\imp~\import.txt"
       lista-indice-ir     = "01 ATOS CREDENCIADOS PRINCIPAIS,"
                           + "02 ATOS CREDENCIADOS AUXILIARES,"
                           + "03 AMBOS".

run rtp/rtspool.p(input-output nm-diretorio-aux).

assign ds-barra = substring(nm-diretorio-aux,(length(nm-diretorio-aux)),1).

if    ds-barra <> "/"
then  assign nm-diretorio-aux = nm-diretorio-aux + "/".

assign nm-arquivo-erros = nm-diretorio-aux + "erros-p.lst".

/* --- declaracao de eventos ------------------------------------------------ */
on return of lg-calc-irrf-aux in frame f-parametros
do:
  apply "go" to lg-calc-irrf-aux.
end.
on return of lg-importacao-total in frame f-parametros
do:
  apply "go" to lg-importacao-total.
end.

on return of lg-cons-vinc-prest-aux in frame f-parametros
do:
  apply "go" to lg-cons-vinc-prest-aux.
end.

/* ---------------------------------- EVENTOS SELECTION-LIST INDICE IRRF --- */
on end-error of mostra-indice-ir in frame f-indice-ir
do:
  hide frame f-indice-ir no-pause.
end.

/* --- funcoes para conversao de dados -------------------------------------- */
function valida-grupo-grc returns log (cd-grupo-par as int):

    def buffer b-assgrpre for assgrpre.

    if paramecp.log-1 = no
    then return yes.

    if can-find(first b-assgrpre where b-assgrpre.cd-tbconvcd                 = "GRC"
                                   and b-assgrpre.cd-grupo-prestador-interno  = cd-grupo-par
                                   and b-assgrpre.cd-grupo-prestador-externo >= 1
                                   and b-assgrpre.cd-grupo-prestador-externo <= 6
                                   and (   b-assgrpre.char-1                  = "E" 
                                        or b-assgrpre.char-1                  = "A"))
    then return yes.
    else do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc = "Grupo de prestador (" + string(cd-grupo-par,"99")
                                                            + ") sem assoc. valida na tabela assgrpre para integracao com GRC.".
           run gera-relat-erro (2,"").

           return no.
         end.

end function.

function cd-grupo-prestador-ass returns log (cd-grupo-par as char):
   def var cd-grupo-n as int.

   assign cd-grupo-prestador-aux = 0.
   assign cd-grupo-n = integer(cd-grupo-par) no-error.
   if error-status:error
   then return no.

   if not pipresta.lg-tab-assgrpre-prest
   then do: 
          cd-grupo-prestador-aux = cd-grupo-n.
          return valida-grupo-grc(cd-grupo-n).
        end.

   find   first assgrpre
   where  assgrpre.cd-tbconvcd = pipresta.cd-tab-assgrpre-prest
     and  assgrpre.cd-grupo-prestador-externo = cd-grupo-n
     and (assgrpre.char-1 = "I"
     or   assgrpre.char-1 = "A") /*in-tipo-assoc*/
          no-lock no-error.

   if avail assgrpre
   then do:
          assign cd-grupo-prestador-aux = assgrpre.cd-grupo-prestador-interno.
          return valida-grupo-grc(assgrpre.cd-grupo-prestador-interno).
        end.
   else do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc = "Grupo de prestador (" + string(cd-grupo-n,"99")
                                               + ") sem assoc. na tabela assgrpre.".
          run gera-relat-erro (2,"").
          return no.
        end.
   
end function.

function cd-cidade-ass returns log (cd-cidade-par as char):
   def var cd-cidade-n as int.

   assign cd-cidade-aux = 0.
   assign cd-cidade-n = integer(cd-cidade-par) no-error.
   if error-status:error
   then return no.

   if not pipresta.lg-tab-asscidad-prest
   then do: 
          cd-cidade-aux = cd-cidade-n.
          return yes.
        end.

   find  asscidad 
   where asscidad.cd-tbconvcd = pipresta.cd-tab-asscidad-prest
     and asscidad.cd-cidade-externa = cd-cidade-n 
         no-lock no-error.
   if avail asscidad
   then assign cd-cidade-aux = asscidad.cd-cidade-interna.
   else do:
          run gera-relat-erro (1, "Codigo de cidade (" + string(cd-cidade-n,"999999")
                            + ") sem assoc. na tabela asscidad.").
          return no.
        end.
   return yes.
end function.

function cd-especialidade-ass returns log (cd-espec-par as char, 
                                           nr-seq       as int, 
                                           in-obrig     as char,
                                           tp-reg-par   as int):
   def var cd-espec-n as int.

   assign cd-espec-n = integer(cd-espec-par) no-error.
   if error-status:error
   then return no.

   if cd-espec-n = 0
   then if in-obrig = "S"
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = tp-reg-par
                      wk-erros.ds-desc = "Codigo de especialidade principal nao pode ser zeros.".
               run gera-relat-erro (2,"").
               return no.
             end.
        else do:
               if nr-seq = 1
               then cd-especialidade1-aux = 0.
               else cd-especialidade2-aux = 0.
               return yes.
             end.

   if not pipresta.lg-tab-assespec-prest
   then do:
          if nr-seq = 1
             then cd-especialidade1-aux = cd-espec-n.
             else cd-especialidade2-aux = cd-espec-n.
          return yes.
        end.

   find   first assespec 
   where  assespec.cd-tbconvcd = pipresta.cd-tab-assespec-prest
     and  assespec.cd-espec-externo = cd-espec-n 
     and (assespec.in-tipo-assoc = "I"
     or   assespec.in-tipo-assoc = "A")
         no-lock no-error.
   if avail assespec
   then if nr-seq = 1
        then assign cd-especialidade1-aux = assespec.cd-espec-interno.
        else assign cd-especialidade2-aux = assespec.cd-espec-interno.
   else do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = tp-reg-par
                 wk-erros.ds-desc = "Codigo de especialidade (" + string(cd-espec-n,"999")
                                                     + ") sem assoc. na tabela assespec.".
          run gera-relat-erro (2,"").
          return no.
        end.
   return yes.
end function.
 
function cd-vinculo-ass returns log (cd-vinculo-par as char):
   def var cd-vinculo-n as int.

   assign cd-vinculo-aux = 0.
   assign cd-vinculo-n = integer(cd-vinculo-par) no-error.
   if error-status:error
   then return no.

   if not pipresta.lg-tab-assvincu-prest
   then do:
          cd-vinculo-aux = cd-vinculo-n.
          return yes.
        end.

   find   first assvincu 
   where  assvincu.cd-tbconvcd = pipresta.cd-tab-assvincu-prest
     and  assvincu.cd-tipo-vinc-externo = cd-vinculo-n
     and (assvincu.in-tipo-assoc = "I"
     or   assvincu.in-tipo-assoc = "A")
          no-lock no-error.
   if avail assvincu
   then assign cd-vinculo-aux = assvincu.cd-tipo-vinc-interno.
   else do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc = "Codigo de vinculo (" + string(cd-vinculo-n,"999")
                                  + ") sem assoc. na tabela assvincu.".
          run gera-relat-erro (2,"").
          return no.
        end.
   return yes.
end function.
 
/*---------------------------- PROGRAMA PRINCIPAL ---------------------------*/

/* ----------------- VERIFICA SE FOI CHAMADO PARA IMPORTACAO OU MIGRACAO --- */

/*
message "1" program-name(1) skip
 "2" program-name(2) skip
 "3" program-name(3) skip
 "4" program-name(4) skip
view-as alert-box.
*/

if substring(program-name (2),length (program-name (2)) - 16, 17) = "cgp/cg0210x_mig.p"
or substring(program-name (2),length (program-name (2)) - 12, 13) = "cgp/cg0210x.p"
or substring(program-name (2),length (program-name (2)) - 16, 17) = "cgp~\cg0210x_mig.p"
or substring(program-name (2),length (program-name (2)) - 12, 13) = "cgp~\cg0210x.p"
then assign lg-migracao-aux = yes
            nm-cab-usuario  = "Migracao de Prestadores".
else assign lg-migracao-aux = no
            nm-cab-usuario  = "Importacao de Prestadores".
/* ------------------------------------------------------------------------- */

{hdp/hdtitrel.i}

repeat on endkey undo,retry with frame mig0001a:

   hide frame mig0001a       no-pause.
   hide frame f-parametros   no-pause.
   hide frame f-par-migracao no-pause.
   hide frame f-opcao        no-pause.
   {hdp/hdbotpacoimla.i}
   
   hide message             no-pause.
   hide frame f-totais-tela no-pause.     
  
   /* quando c-opcao = "Arquivo" */
   {hdp/hdpedarq.i}
 
  /* ------------------------------------------------------------------------ */
   if  c-opcao = "Arquivo"
   and keyfunction(lastkey) <> "end-error"
   then assign lg-arquivo-aux = yes.

   case c-opcao:
      when "Fim"
      then do:
             hide all no-pause.
             leave.
           end.
      /* ------------------------------------------------------------------- */
      when "Parametro"
      then do:
             if   not lg-arquivo-aux
             then do:
                    message "Voce deve passar primeiro na opcao Arquivo."
                    view-as alert-box title " Atencao !!! ".
                    undo,retry.
                  end.
             if lg-migracao-aux
             then run processa-parametros-migracao.
             /*else run processa-parametros.*/
           end.
      /* ------------------------------------------------------------------- */
      when "Importa" or when "Consiste"
      then do:
             empty temp-table tmp-preserv.
             empty temp-table tmp-previesp.
             empty temp-table tmp-endpres.
             empty temp-table tmp-prest-inst.
             empty temp-table tmp-prestdor-obs.
             
             if   c-opcao = "Consiste"
             and  not lg-parametro-aux
             then do:
                    message "Voce deve passar primeiro na opcao Parametros."
                    view-as alert-box title " Atencao !!! ".
                    undo, retry.
                  end.
                                
             if c-opcao = "Consiste"
             and lg-consiste-aux and not lg-importacao-total
             then do:
                    message "A Consistencia deste arquivo " skip
                            "ja foi realizada e esta correta."
                    view-as alert-box title " Atencao !!! ".
                    undo, retry.
                  end.
                               
             if   c-opcao = "Importa"
             and  not lg-consiste-aux
             then do:
                    message "Voce deve passar primeiro na opcao Consiste."
                    view-as alert-box title " Atencao !!! ".
                    undo, retry.
                  end.
     
             /* --- ABRE REL. CD ERROS ------------------------------------------ */
             if c-opcao = "Consiste"
             then do:
                    output stream s-erro to value(nm-arquivo-erros) page-size 64.
                    assign ds-titulo = "Relatorio de Erros na Consistencia da Importacao dos Prestadores".

                  end.
             else do:
                    output stream s-erro to value(nm-arquivo-erros) page-size 64 append.
                    assign ds-titulo = "Relatorio de Erros da Importacao dos Prestadores".
                  end.

             &if "{&window-system}" = "TTY"
             &then put stream s-erro control ds-20cpp-ativa-aux.
             &endif
             
             view stream   s-erro frame f-cabec-erros.
             view stream   s-erro frame f-rodape-erros.

             assign tt-prest-erros       = 0
                    tt-prest-aviso       = 0
                    tt-prest-inc-aux     = 0
                    tt-prest-alt-aux     = 0
                    tt-prest-exc-aux     = 0
                    tt-prest-reat-aux    = 0.
    
             assign lg-erro       = no
                    lg-erro-geral = no.
    
             /* --- converte arquivo de entrada se necessario ------------------- */
             /* ESSA VERSAO DO FONTE Eh EXCLUSIVA PARA MIGRACAO, PORTANTO NUNCA CONSIDERA ESSE TRECHO.
             if   c-opcao = "Consiste"
             and  not  lg-migracao-aux
             then 
                  
                  if   pipresta.lg-layout-serious              
                  then do:
                         run monta-nome-arq-serious.

                         empty temp-table tmp-movto-prestador.

                         /* ---------------------------------------------------
                         ---------- CRIA NOVO ARQUIVO TEXTO BASEADO NO ORIGINAL 
                         - CONSIDERANDO AS TABELAS ASSOCIATIVAS SERIOUS-SERIOUS
                         --------------------------------------------------- */
                         run converte-serious-serious.
                         
                         assign nm-arquivo-importar = nm-arquivo-serious-gerar.
                       end.

                  else do:
                         run monta-nome-arq-serious. 
                         /* -------------------------------------------------------
                         -------------- CRIA NOVO ARQUIVO TEXTO BASEADO NO ORIGINAL
                         --------- CONSIDERANDO AS TABELAS ASSOCIATIVAS PTU-SERIOUS
                         ------------------------------------------------------- */
                         assign c-cd-especialid = cd-especialid-jur-aux.
                         
                         run value(nm-prog-p-aux).
                        
                         if keyfunction(lastkey) = "end-error"
                         then do:
                                output stream s-erro close.
                                next.
                              end.
                         
                         if   not lg-erro-geral
                         then do:
                                assign nm-arquivo-importar = nm-arquivo-serious-gerar.
                                
                                run monta-nome-arq-serious.
                                /* -------------------------------------------------------
                                -------------- CRIA NOVO ARQUIVO TEXTO BASEADO NO ANTERIOR
                                ----- CONSIDERANDO AS TABELAS ASSOCIATIVAS SERIOUS-SERIOUS
                                ------------------------------------------------------- */
                                assign tt-prest-erros-atual = tt-prest-erros
                                       tt-prest-aviso-atual = tt-prest-aviso.

                                empty temp-table tmp-movto-prestador.
                                    
                                run converte-serious-serious. 

                                assign nm-arquivo-importar = nm-arquivo-serious-gerar.   
                              end.
                       end.
                  */

             if   lg-erro-geral
             then do:
                    assign lg-consiste-aux = no.
                    display stream s-erro
                                   tt-prest-lidos
                                   tt-prest-erros
                                   tt-prest-aviso
                            with frame f-totais-erros.
                  end.
             else do:
                    if   tt-prest-erros <> 0 
                    then do:
                           if   not lg-importacao-total /* nao fazer importacao parcial */
                           then do:
                                  assign lg-consiste-aux  = no.

                                  display stream s-erro
                                          tt-prest-lidos
                                          tt-prest-erros
                                          tt-prest-aviso
                                          with frame f-totais-erros.

                                end.
                           else if lg-migracao-aux
                               then run processa-importacao-migracao.
                               /*else run processa-importacao.*/


                           
                         end.
                    else if lg-migracao-aux
                               then run processa-importacao-migracao.
                               /*else run processa-importacao.*/
                  end.

             output stream s-erro    close.
             output stream s-acertos close.

             hide message no-pause.

             /*----- MOSTRAR TOTAIS -----*/
             run imp-totais-tela.

             /*----- MENSAGEM DE ERROS OCORRIDOS -----*/
             if   tt-prest-erros <> 0
             then do:
                    message "Ocorreram Erros na Importacao. " skip
                            "Verifique o Relatorio. "
                            view-as alert-box title " Atencao !!! ".

                    if not lg-importacao-total
                    then assign lg-consiste-aux  = no.
                  end.
             else do:
                    if tt-prest-aviso <> 0
                    then message "Ocorreram Avisos na Importacao. " skip
                                   "Verifique o Relatorio. "
                               view-as alert-box title " Atencao !!! ".
                         
                    else do:
                           if   lg-erro-geral 
                           then message "Ocorreram erros que impedem a importacao. " skip
                                          "Verifique o Relatorio de Erros. "
                                          view-as alert-box title " Atencao !!! ".
                           else if   c-opcao = "Consiste" 
                           then message "Processo de consistencia concluido." view-as alert-box title " Atencao !!! ".
                           else message "Processo de importacao concluido." view-as alert-box title " Atencao !!! ".

                         end.
                  end.             

             /*---- TESTA SISTEMA UNIX PARA POSICIONAR NO BOTAO ARQUIVO ---------*/   
             &if "{&window-system}" = "TTY"                                           
             &then do:                                                                
                     assign c-opcao = "Arquivo".                                      
                     display tb-pacoimla with frame f-pacoimla.                       
                     choose field tb-pacoimla auto-return keys c-opcao                
                            with frame f-pacoimla.                                    
                   end.                                                               
             &endif  
           end.
      /* ------------------------------------------------------------------- */
      when "LayOut"
      then do:
             if   search("cgp/cg0112l.p") = ?
             and  search("cgp/cg0112l.r") = ?
             then do:
                    message "Programa ainda nao disponivel" skip
                            "Faca outra escolha"
                    view-as alert-box title " Atencao !!! ".
                  end.
             else do:
                    hide message no-pause.
                    run cgp/cg0112l.p.
                    hide message no-pause.
                  end.
           end.
   end case.
end.


/* -------------------------------------------------------------------------- */
/* MIGRACAO NAO USA ESSE TRECHO.
procedure processa-parametros:
  do on error undo, retry with frame f-parametros:
     /* --- recebe unidade -------------------------------------------------- */
     do on error undo,retry:
        assign cd-unimed-z = ?.                                                          
        update cd-unidade-aux auto-return                                        
               help "F5 para Zoom"                                                       
               {prp/pr1410b.i}                                                           
                 if   cd-unimed-z <> ?                                                     
                 and  cd-retorno                                                           
                 then display cd-unimed-z @ cd-unidade-aux.
                 cd-retorno = ?.                                                           
               end.                                                                      
                                                                                          
        find unimed
             where unimed.cd-unimed = cd-unidade-aux 
                   no-lock no-error.                      
        if not avail unimed                                    
        then do:                                               
               message "Unidade nao cadastrada!"               
                       view-as alert-box title " Atencao !!! ".
               undo,retry.                                                
             end.                                              
        else disp unimed.nm-unimed @ nm-unidade-aux.
     end.

     /* --- recebe prestador ------------------------------------------------ */
     do on error undo,retry:
        assign cd-med-prest-z = ?
               cd-unimed-z = cd-unidade-aux.
        update cd-prestador-aux auto-return                               
               help "F5 para Zoom"                                                       
               {cgp/cg0110b.i}                                                           
                 if  cd-med-prest-z <> ?                                                   
                 and cd-retorno                                                            
                 then display cd-med-prest-z @ cd-prestador-aux.
                 assign cd-retorno = ?.                                                    
               end.                                                                      
     
        find preserv 
             where preserv.cd-unidade = cd-unidade-aux
               and preserv.cd-prestador = cd-prestador-aux 
                   no-lock no-error.
        if not avail preserv 
        then do:
               message "Prestador nao cadastrado!"               
                       view-as alert-box title " Atencao !!! ".
               undo,retry.
             end.
        else disp preserv.nm-prestador @ nm-prestador-aux.
   
        /* --- procura parametros de importacao do prestador ---------------- */
        find pipresta 
             where pipresta.cd-unidade   = cd-unidade-aux
               and pipresta.cd-prestador = cd-prestador-aux 
                   no-lock no-error.
        if not avail pipresta
        then do:
               message "Parametros de importacao do " +
                       "prestador nao cadastrados!" 
                       view-as alert-box title " Atencao !!! ".
               undo,retry.
             end.

        assign lg-layout-serious-aux = pipresta.lg-layout-serious.
     
        /* --- se o arquivo de entrada nao for layout SERIOUS --------------- */
        if not pipresta.lg-layout-serious
        then do:
               if not preserv.lg-representa-unidade
               then do:
                      message "Para realizar a importacao, o" skip
                              "prestador deve representar a unidade."
                              view-as alert-box title "Atencao!".
                      undo, retry.
                    end.

                    

               find layoutei
                    where layoutei.cd-layoutei = pipresta.cd-layoutei-prest
                          no-lock no-error.
               if not avail layoutei
               then do:
                      message "Layout de importacao do " +
                              "prestador nao cadastrado " 
                               pipresta.cd-layoutei-prest
                              view-as alert-box title " Atencao !!! ".
                      undo, retry.
                    end.

               if   substring(layoutei.nm-prog-conv-imp,1,2) = "la"
               then assign nm-prog-p-aux = "lap/" + layoutei.nm-prog-conv-imp + ".p"
                           nm-prog-r-aux = "lap/" + layoutei.nm-prog-conv-imp + ".r".
               else assign nm-prog-p-aux = "dep/" + layoutei.nm-prog-conv-imp + ".p"
                           nm-prog-r-aux = "dep/" + layoutei.nm-prog-conv-imp + ".r".

               if   search(nm-prog-r-aux) = ?
               and  search(nm-prog-p-aux) = ?
               then do:
                      message "Programa de Conversao do Prestador " +
                              "nao encontrado."
                              view-as alert-box title " Atencao !!! ".
                      undo, retry.
                    end.
             end.
     end.

     /* --- recebe nome do arquivo a ser importado -------------------------- */
     do on error undo, retry:
        update nm-arquivo-importar.
        if nm-arquivo-importar = " "
        then do:
               message "Nome do arquivo deve ser informado."
                       view-as alert-box title "Atencao!".
               undo,retry.
             end.
 
        if   search(nm-arquivo-importar) = ?
        then do:
               message "Arquivo a Importar Inexistente."
                       view-as alert-box title " Atencao!".
               undo,retry.
             end.

        lg-consiste-aux = no.
 
        update nm-arquivo-erros.
        if nm-arquivo-erros = " " or nm-arquivo-erros = ?
        then do:
               message "Nome do arquivo deve ser informado."
                       view-as alert-box title "Atencao!".
               undo,retry.
             end.
     end.

     if   not pipresta.lg-layout-serious
     then do:
            /* --- recebe codigo da tabela de horarios de urgencia ----------------- */
            do on error undo, retry:
               assign cd-tab-urge-z = ?.
               update cd-tab-urge-aux auto-return
                   help "F5 para Zoom"
                   {cgp/cg0110q.i}
                   if   cd-tab-urge-z <> ?
                   and  cd-retorno
                   then display cd-tab-urge-z
                                @ cd-tab-urge-aux
                                with frame f-parametros.
                   assign cd-retorno = ?.
               end.
          
               find first horaurge
                    where horaurge.cd-tab-urge = cd-tab-urge-aux
                          no-lock no-error.
        
               if not available horaurge
               then do:
                      message "Horario de Urgencia nao Cadastrado"
                              view-as alert-box title " Atencao !!! ".
                      undo, retry.
                    end.
               display horaurge.ds-tab-urge.
            end.

            assign cd-especialid-z = ?.                                
            update cd-especialid-jur-aux auto-return               
            help "F5 para Zoom"                                        
            {cgp/cg0110c.i}                                            
              if cd-especialid-z <> ? and  cd-retorno                  
              then display cd-especialid-z @ cd-especialid-jur-aux with frame f-parametros.
              cd-retorno = ?.                                          
            end.

            find esp-med
                   where esp-med.cd-especialid = cd-especialid-jur-aux
                         no-lock no-error.  
            if not available esp-med                                   
            then do:                                                   
                   message "Especialidade medica nao cadastrada"       
                           view-as alert-box title " Atencao !!! ".            
                   undo, retry.                                        
                 end.                                                  
            display esp-med.ds-especialid with frame f-parametros.
            
            update lg-codigo-ptu-aux go-on("return").
            
            update lg-calc-irrf-aux.

            do with frame f-indice-ir:
               assign mostra-indice-ir:list-items = lista-indice-ir.
            
               assign mostra-indice-ir = "01 ATOS CREDENCIADOS PRINCIPAIS".
    
               update mostra-indice-ir go-on("return").
            
               assign in-indice-ir-aux = int(substring(mostra-indice-ir,01,02))
                      ds-indice-ir     = substring(mostra-indice-ir,04,28).
            
               hide frame f-indice-ir no-pause.
    
               display in-indice-ir-aux 
                       ds-indice-ir  
                       with frame f-parametros. 
    
            end.
          end.

     update lg-importacao-total.

     if   not pipresta.lg-layout-serious
     then update lg-cons-vinc-prest-aux.

     /* ---------------------------------------------- MOTIVO DE EXCLUSAO --- */
     do on error undo,retry:
        assign in-entidade-z = "CG"
               cd-mot-can-z  = ?.

        update cd-motivo-cancel-aux
            help "F5 para Zoom"
            {zzp/zzac0002.i}
            if   cd-mot-can-z <> ?
            and  cd-retorno
            then display cd-mot-can-z @ cd-motivo-cancel-aux.
            cd-retorno = ?.
            end.

        find motcange where motcange.in-entidade = "CG"
                        and motcange.cd-motivo   = cd-motivo-cancel-aux
                            no-lock no-error.

        if not avail motcange
        then do:
               message "Motivo de exclusao nao cadastrado"
                   view-as alert-box title "Atencao !!!".
               undo,retry.
             end.
        else disp motcange.ds-motivo.

     end.
     
  end.

  &if "{&window-system}" = "TTY"
  &then do:
          {hdp/hdverimp.i}
        end.
  &endif
  
  hide frame f-parametros no-pause.
  hide frame f-impressora no-pause.
  hide frame f-indice-ir no-pause.
  assign lg-parametro-aux = yes.
end procedure.
*/

/* -------------------------------------------------------------------------- */
procedure processa-parametros-migracao:
  do on error undo, retry with frame f-par-migracao:
     /* --- recebe nome do arquivo a ser importado -------------------------- */
     do on error undo, retry:
        update nm-arquivo-importar.
        if nm-arquivo-importar = " "
        then do:
               message "Nome do arquivo deve ser informado."
                       view-as alert-box title "Atencao!".
               undo,retry.
             end.
 
        if   search(nm-arquivo-importar) = ?
        then do:
               message "Arquivo a Importar Inexistente."
                       view-as alert-box title " Atencao!".
               undo,retry.
             end.

        lg-consiste-aux = no.
 
        update nm-arquivo-erros.
        if nm-arquivo-erros = " "
        then do:
               message "Nome do arquivo deve ser informado."
                       view-as alert-box title "Atencao!".
               undo,retry.
             end.
     end.
  end.

  {hdp/hdverimp.i}
  hide frame f-par-migracao no-pause.
  hide frame f-impressora   no-pause.
  assign lg-parametro-aux      = yes
         lg-layout-serious-aux = yes.
end procedure.

/*---------------------------------------------------------------------------*/
/* procedure processa-importacao:                                                                                                            */
/*   def var lg-erro-processo-prest as log init no no-undo.                                                                                  */
/*                                                                                                                                           */
/*   /*----- ABRE REL. DE ACERTOS -----*/                                                                                                    */
/*   if   c-opcao = "Importa"                                                                                                                */
/*   then do:                                                                                                                                */
/*          {hdp/hdmonarq.i &stream = "stream s-acertos" &page-size = 64}                                                                    */
/*          view stream s-acertos frame f-cabec-acertos.                                                                                     */
/*          view stream s-acertos frame f-rodape-acertos.                                                                                    */
/*        end.                                                                                                                               */
/*                                                                                                                                           */
/*   /*----- ABRE ARQ. DE IMPORTACAO -----*/                                                                                                 */
/*   input stream s-import from value(nm-arquivo-importar).                                                                                  */
/*                                                                                                                                           */
/*   /*----- ZERAR VARIAVEIS INICIAIS -----*/                                                                                                */
/*   if   lg-layout-serious-aux                                                                                                              */
/*   then assign tt-prest-lidos = 0.                                                                                                         */
/*                                                                                                                                           */
/*   assign tt-prest-gravados    = 0                                                                                                         */
/*          tt-regs-gravados     = 0                                                                                                         */
/*          tt-prest-erros-atual = 0                                                                                                         */
/*          tt-prest-aviso-atual = 0                                                                                                         */
/*          tp-anterior          = 0                                                                                                         */
/*          tp-registro          = 0                                                                                                         */
/*          c-cd-unidade         = 0                                                                                                         */
/*          lg-erro              = no                                                                                                        */
/*          lg-aviso             = no                                                                                                        */
/*          lg-erro-geral        = no.                                                                                                       */
/*                                                                                                                                           */
/*   /*----- LIMPAR TEMP-TABLES -----*/                                                                                                      */
/*   empty temp-table wk-erros.                                                                                                              */
/*   empty temp-table wk-reg2.                                                                                                               */
/*   empty temp-table wk-reg3.                                                                                                               */
/*   empty temp-table wk-reg4.                                                                                                               */
/*   empty temp-table wk-reg5.                                                                                                               */
/*   empty temp-table wk-reg6.                                                                                                               */
/*                                                                                                                                           */
/*   /*----- LACO PARA IMPORTACAO -----*/                                                                                                    */
/*   repeat:                                                                                                                                 */
/*      /*----- IMPORTA O REGISTRO -----*/                                                                                                   */
/*      import stream s-import unformatted c-dados.                                                                                          */
/*                                                                                                                                           */
/*      /* --------------------- LINHAS EM BRANCO --- */                                                                                     */
/*      if length(trim(c-dados)) = 0                                                                                                         */
/*      then next.                                                                                                                           */
/*                                                                                                                                           */
/*      /*----- PEGA VALORES ANTERIORES -----*/                                                                                              */
/*      if   tp-registro <> 99                                                                                                               */
/*      then assign tp-anterior     = tp-registro                                                                                            */
/*                  tp-ant-unid     = c-cd-unidade.                                                                                          */
/*                                                                                                                                           */
/*      assign tt-prest-erros-atual = tt-prest-erros                                                                                         */
/*             tt-prest-aviso-atual = tt-prest-aviso.                                                                                        */
/*                                                                                                                                           */
/*      /*----- TESTA O TIPO DO REGISTRO -----*/                                                                                             */
/*      assign tp-registro = int(substring(string(c-dados,"x(1023)"),1,1)).                                                                  */
/*                                                                                                                                           */
/*      if   tp-registro <> 1                                                                                                                */
/*      and  tp-registro <> 2                                                                                                                */
/*      and  tp-registro <> 3                                                                                                                */
/*      and  tp-registro <> 4                                                                                                                */
/*      and  tp-registro <> 5                                                                                                                */
/*      and  tp-registro <> 6                                                                                                                */
/*      then do:                                                                                                                             */
/*             assign lg-erro-geral = yes.                                                                                                   */
/*             run gera-relat-erro (1,"Tipo de Registro Invalido - " +                                                                       */
/*                                    string(tp-registro,"9")).                                                                              */
/*             tp-registro = 99.                                                                                                             */
/*           end.                                                                                                                            */
/*                                                                                                                                           */
/*      if   tp-registro <> 99                                                                                                               */
/*      then do:                                                                                                                             */
/*             /* - CASO TENHA OCORRIDO ERRO NO REGISTRO ANTERIOR, ENTAO NAO SERAO PROCESSADOS OS OUTROS REGISTROS DO MESMO PRESTADOR --- */ */
/*             if lg-erro-processo-prest                                                                                                     */
/*             then do:                                                                                                                      */
/*                    if tp-registro = 1                                                                                                     */
/*                    then assign lg-erro-processo-prest = no.                                                                               */
/*                    else next.                                                                                                             */
/*                  end.                                                                                                                     */
/*                                                                                                                                           */
/*             if   tp-registro = 1                                                                                                          */
/*             then do:                                                                                                                      */
/*                    assign nr-cgc-dzemit-aux = ""                                                                                          */
/*                           c-nr-seq-endereco = 0.                                                                                          */
/*                                                                                                                                           */
/*                    if   lg-layout-serious-aux                                                                                             */
/*                    then tt-prest-lidos = tt-prest-lidos + 1.                                                                              */
/*                                                                                                                                           */
/*                  end.                                                                                                                     */
/*                                                                                                                                           */
/*             /*----- VERIFICA SE PRIMEIRO REGISTRO -----*/                                                                                 */
/*             if   tp-registro = 1                                                                                                          */
/*             and  tp-anterior <> 0                                                                                                         */
/*             then do:                                                                                                                      */
/*                    assign c-nr-seq-endereco = 0.                                                                                          */
/*                                                                                                                                           */
/*                    /*--- IMPORTA DADOS DOS REGISTROS (SE TUDO OK) ----*/                                                                  */
/*                    if   c-opcao = "Importa"                                                                                               */
/*                    and  not lg-erro-geral                                                                                                 */
/*                    then do:                                                                                                               */
/*                           assign lg-erro-imp-aux = no.                                                                                    */
/*                                                                                                                                           */
/*                           run importa-prestador.                                                                                          */
/*                                                                                                                                           */
/*                           if not lg-erro-imp-aux                                                                                          */
/*                           then run gera-relat-acertos.                                                                                    */
/*                         end.                                                                                                              */
/*                                                                                                                                           */
/*                    /*----- APAGA TEMP DE ERROS, REG2, REG3 e REG4 -----*/                                                                 */
/*                    assign lg-erro-geral = no.                                                                                             */
/*                                                                                                                                           */
/*                    empty temp-table wk-erros.                                                                                             */
/*                    empty temp-table wk-reg2.                                                                                              */
/*                    empty temp-table wk-reg3.                                                                                              */
/*                    empty temp-table wk-reg4.                                                                                              */
/*                    empty temp-table wk-reg5.                                                                                              */
/*                    empty temp-table wk-reg6.                                                                                              */
/*                                                                                                                                           */
/*                  end.                                                                                                                     */
/*                                                                                                                                           */
/*             /*----- INICIA VERIFICACAO DE UM NOVO REGISTRO -----*/                                                                        */
/*             assign lg-erro = no.                                                                                                          */
/*                                                                                                                                           */
/*             find first tmp-movto-prestador                                                                                                */
/*                  where tmp-movto-prestador.cd-unidade   = c-cd-unidade                                                                    */
/*                    and tmp-movto-prestador.cd-prestador = c-cd-prestador                                                                  */
/*                        no-lock no-error.                                                                                                  */
/*                                                                                                                                           */
/*             if avail tmp-movto-prestador                                                                                                  */
/*             then assign in-movto-aux = tmp-movto-prestador.in-movto.                                                                      */
/*                                                                                                                                           */
/* /*             if  (tp-registro = 1 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */                           */
/* /*             or  (tp-registro = 3 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */                           */
/* /*             or  (tp-registro = 4 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */                           */
/* /*             or  (tp-registro = 5 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */                           */
/* /*             then assign lg-erro       = yes                                                               */                           */
/* /*                         lg-erro-geral = yes.                                                              */                           */
/* /*                                                                                                           */                           */
/* /*             if   lg-erro                                                                                  */                           */
/* /*             then do:                                                                                      */                           */
/* /*                    create wk-erros.                                                                       */                           */
/* /*                    assign wk-erros.cd-tipo-erro = "E"                                                     */                           */
/* /*                           wk-erros.cd-tipo-regs = 1                                                       */                           */
/* /*                           wk-erros.ds-desc = "Faltando Registro do Prestador X Vinculo X Especialidade.". */                           */
/* /*                    /* "Faltando Registro do "  +                                                          */                           */
/* /*                                              "Prestador X Vinculo X " +                                   */                           */
/* /*                                              "Especialidade.". */                                         */                           */
/* /*                                                                                                           */                           */
/* /*                                                                                                           */                           */
/* /*                                                                                                           */                           */
/* /*                    run gera-relat-erro (2,"").                                                            */                           */
/* /*                    assign lg-erro-aux = yes.                                                              */                           */
/* /*                  end.                                                                                     */                           */
/*             lg-erro = no.                                                                                                                 */
/*                                                                                                                                           */
/*             if  (tp-registro = 2 and tp-anterior = 3)                                                                                     */
/*             or  (tp-registro = 2 and tp-anterior = 0)                                                                                     */
/*             then assign                                                                                                                   */
/*                  lg-erro       = yes                                                                                                      */
/*                  lg-erro-geral = yes.                                                                                                     */
/*                                                                                                                                           */
/*             if   lg-erro                                                                                                                  */
/*             then do:                                                                                                                      */
/*                                                                                                                                           */
/*                    create wk-erros.                                                                                                       */
/*                    assign wk-erros.cd-tipo-erro = "E"                                                                                     */
/*                           wk-erros.cd-tipo-regs = 1                                                                                       */
/*                           wk-erros.ds-desc = "Faltando Registro do Prestador.".                                                           */
/*                    run gera-relat-erro (2,"").                                                                                            */
/*                    assign lg-erro-aux = yes.                                                                                              */
/*                                                                                                                                           */
/*                    assign c-nm-prestador   = "PRESTADOR NAO ENCONTRADO"                                                                   */
/*                           c-cd-unidade     = 0                                                                                            */
/*                           c-cd-prestador   = 0                                                                                            */
/*                           c-nome-abrev     = ""                                                                                           */
/*                           c-cgc-cpf        = ""                                                                                           */
/*                           c-cd-magnus      = 0                                                                                            */
/*                           c-in-tipo-pessoa = "".                                                                                          */
/*                  end.                                                                                                                     */
/*                                                                                                                                           */
/*             /*----- CONSISTE DADOS DO REGISTRO -----*/                                                                                    */
/*             assign lg-erro  = no                                                                                                          */
/*                    lg-aviso = no.                                                                                                         */
/*                                                                                                                                           */
/*             run cgp/cg0111l_mig.p (tp-registro).                                                                                          */
/*                                                                                                                                           */
/*             find first wk-erros no-error.                                                                                                 */
/*                                                                                                                                           */
/*             if   lg-erro                                                                                                                  */
/*             or   lg-aviso                                                                                                                 */
/*             then do:                                                                                                                      */
/*                    if   lg-erro                                                                                                           */
/*                    then assign lg-erro-geral = yes.                                                                                       */
/*                                                                                                                                           */
/*                    if avail wk-erros                                                                                                      */
/*                    then run gera-relat-erro (2,"").                                                                                       */
/*                  end.                                                                                                                     */
/*           end.                                                                                                                            */
/*                                                                                                                                           */
/*                                                                                                                                           */
/*      /*----- MOSTRAR TOTAIS -----*/                                                                                                       */
/*      run imp-totais-tela.                                                                                                                 */
/*                                                                                                                                           */
/*      /* CASO TENHA OCORRIDO ERRO NA LEITURA DE UM TIPO DE REGISTRO, NAO SERAO PROCESSADOS OS PROXIMOS DO MESMO PRESTADOR --- */           */
/*      if lg-erro-geral                                                                                                                     */
/*      then assign lg-erro-processo-prest = yes.                                                                                            */
/*                                                                                                                                           */
/*   end. /* repeat */                                                                                                                       */
/*                                                                                                                                           */
/*   find first tmp-movto-prestador                                                                                                          */
/*        where tmp-movto-prestador.cd-unidade   = c-cd-unidade                                                                              */
/*          and tmp-movto-prestador.cd-prestador = c-cd-prestador                                                                            */
/*              no-lock no-error.                                                                                                            */
/*                                                                                                                                           */
/*   if avail tmp-movto-prestador                                                                                                            */
/*   then assign in-movto-aux = tmp-movto-prestador.in-movto.                                                                                */
/*                                                                                                                                           */
/*   /*----- VERIFICA ULTIMO ERRO DE IMPORTACAO -----*/                                                                                      */
/*   /*if  (tp-registro = 1 and not lg-erro-geral and in-movto-aux = 1 /*INCLUSAO*/ )                                                        */
/*   or  (tp-registro = 3 and tp-anterior = 1   and in-movto-aux = 1 /*INCLUSAO*/ )                                                          */
/*   then do:                                                                                                                                */
/*          create wk-erros.                                                                                                                 */
/*          assign wk-erros.cd-tipo-erro = "E"                                                                                               */
/*                 wk-erros.cd-tipo-regs = 1                                                                                                 */
/*                 wk-erros.ds-desc = "Faltando Registro do "  +                                                                             */
/*                                    "Prestador X Vinculo X " +                                                                             */
/*                                    "Especialidade.".                                                                                      */
/*                                                                                                                                           */
/*          run gera-relat-erro (2,"").                                                                                                      */
/*          assign lg-erro-aux = yes.                                                                                                        */
/*        end.*/                                                                                                                             */
/*                                                                                                                                           */
/*   /*----- IMPORTA DADOS DOS REGISTROS (SE TUDO OK) -----*/                                                                                */
/*   if   c-opcao = "Importa"                                                                                                                */
/*   and  not lg-erro-geral                                                                                                                  */
/*   and  c-cd-unidade <> 0                                                                                                                  */
/*   then do:                                                                                                                                */
/*          assign lg-erro-imp-aux = no.                                                                                                     */
/*                                                                                                                                           */
/*          run importa-prestador.                                                                                                           */
/*                                                                                                                                           */
/*          /*----- IMPRIME RELATORIO DE IMPORTADOS E GRAVADOS -----*/                                                                       */
/*          if not lg-erro-imp-aux                                                                                                           */
/*          then run gera-relat-acertos.                                                                                                     */
/*        end.                                                                                                                               */
/*                                                                                                                                           */
/*   /*/*----- MOSTRAR TOTAIS -----*/                                                                                                        */
/*   if   c-opcao = "Consiste"                                                                                                               */
/*   then assign ds-titulo-tela = "ESTATISTICAS DA CONSISTENCIA".                                                                            */
/*   else assign ds-titulo-tela = "ESTATISTICAS DA IMPORTACAO".                                                                              */
/*                                                                                                                                           */
/*   display tt-prest-lidos                                                                                                                  */
/*           tt-regs-gravados                                                                                                                */
/*           tt-prest-gravados                                                                                                               */
/*           tt-prest-erros                                                                                                                  */
/*           tt-prest-aviso                                                                                                                  */
/*           with frame f-totais-tela.*/                                                                                                     */
/*                                                                                                                                           */
/*   /*----- LIGAR LOG DA CONSISTENCIA -----*/                                                                                               */
/*   if   c-opcao = "Consiste"                                                                                                               */
/*   then assign lg-consiste-aux = yes.                                                                                                      */
/*                                                                                                                                           */
/*   /*----- DESLIGAR LOGS -----*/                                                                                                           */
/*   if   c-opcao = "Importa"                                                                                                                */
/*   then assign lg-arquivo-aux   = no                                                                                                       */
/*               lg-parametro-aux = no                                                                                                       */
/*               lg-consiste-aux  = no.                                                                                                      */
/*                                                                                                                                           */
/*   /*----- IMPRIME TOTAIS DO REL. ERROS. -----*/                                                                                           */
/*   display stream s-erro                                                                                                                   */
/*           tt-prest-lidos                                                                                                                  */
/*           tt-prest-erros                                                                                                                  */
/*           tt-prest-aviso                                                                                                                  */
/*           with frame f-totais-erros.                                                                                                      */
/*                                                                                                                                           */
/*   /*----- IMPRIME TOTAIS DO REL. DE ACERTOS -----*/                                                                                       */
/*   if   c-opcao = "Importa"                                                                                                                */
/*   then do:                                                                                                                                */
/*          run imp-relat-acertos.                                                                                                           */
/*                                                                                                                                           */
/*          display stream s-acertos                                                                                                         */
/*                  tt-prest-lidos                                                                                                           */
/*                  tt-regs-gravados                                                                                                         */
/*                  tt-prest-gravados                                                                                                        */
/*                  with frame f-totais-ok.                                                                                                  */
/*                                                                                                                                           */
/*          empty temp-table tmp-movto-prestador.                                                                                            */
/*        end.                                                                                                                               */
/*                                                                                                                                           */
/*   input  stream s-import close.                                                                                                           */
/*                                                                                                                                           */
/* end procedure.                                                                                                                            */


procedure gera-relat-acertos:

    if   not lg-layout-serious-aux
    and  in-movto-aux = 2
    and  not lg-alt-prest-aux
    then return.

    /* -------------------------------------------------------- PRESTADOR --- */
    create tmp-preserv.
    assign tmp-preserv.in-movto       = in-movto-aux
           tmp-preserv.cd-unidade     = c-cd-unidade
           tmp-preserv.cd-prestador   = c-cd-prestador
           tmp-preserv.nm-prestador   = c-nm-prestador
           tmp-preserv.nome-abrev     = c-nome-abrev
           tmp-preserv.in-tipo-pessoa = c-in-tipo-pessoa
           tmp-preserv.nr-cgc-cpf     = c-cgc-cpf.

    /* ------------------------------ PRESTADOR X VINCULO X ESPECIALIDADE --- */
    for each wk-reg2 no-lock:

        create tmp-previesp.
        assign tmp-previesp.cd-unidade                 = c-cd-unidade
               tmp-previesp.cd-prestador               = c-cd-prestador
               tmp-previesp.cd-vinculo                 = wk-reg2.cd-vinculo
               tmp-previesp.cd-especialid              = wk-reg2.cd-especialid
               tmp-previesp.lg-principal               = wk-reg2.lg-principal
               tmp-previesp.lg-considera-qt-vinculo    = wk-reg2.lg-considera-qt-vinculo
               tmp-previesp.cd-registro-especialidade  = wk-reg2.cd-registro-espec     
               tmp-previesp.dec-1                      = wk-reg2.cd-registro-espec-2
               tmp-previesp.int-2                      = wk-reg2.in-tipo-especialidade
               tmp-previesp.int-3                      = wk-reg2.cd-tit-cert-esp.  
    end.
    
    /* ------------------------------------------- ENDERECOS DO PRESTADOR --- */
    for each wk-reg3 no-lock:

        create tmp-endpres.
        assign tmp-endpres.cd-unidade   = c-cd-unidade
               tmp-endpres.cd-prestador = c-cd-prestador
               tmp-endpres.en-endereco  = wk-reg3.en-endereco
               tmp-endpres.en-complemento = wk-reg3.en-complemento
               tmp-endpres.en-bairro    = wk-reg3.en-bairro
               tmp-endpres.en-cep       = wk-reg3.en-cep
               tmp-endpres.en-uf        = wk-reg3.en-uf.
    end.
    
    /* ------------------------------------------- ENDERECOS DO PRESTADOR --- */
    for each wk-reg4 no-lock:
        
        create tmp-prest-inst.
        assign tmp-prest-inst.cd-unidade         = c-cd-unidade
               tmp-prest-inst.cd-prestador       = c-cd-prestador
               tmp-prest-inst.cod-instit         = wk-reg4.cod-instit
               tmp-prest-inst.cdn-nivel          = wk-reg4.cdn-nivel
               tmp-prest-inst.lg-autoriz-divulga = wk-reg4.lg-autoriz-divulga
               tmp-prest-inst.cd-seq-end         = wk-reg4.cd-seq-end.
    end.
    
    /* ------------------------------------------- PRESTADOR X OBSERVACOES  --- */
    for each wk-reg5 no-lock:

        create tmp-prestdor-obs.
        assign tmp-prestdor-obs.cd-unidade   = c-cd-unidade
               tmp-prestdor-obs.cd-prestador = c-cd-prestador
               tmp-prestdor-obs.des-obs      = wk-reg5.divulga-obs.
    end.

end procedure.
/* ------------------------------------------------------------------------- */
procedure imp-relat-acertos:

    put stream s-acertos
        skip(1)
        "======================================================"
        " PRESTADORES INCLUIDOS "
        "======================================================" 
        skip.

    for each tmp-preserv where tmp-preserv.in-movto = 1 no-lock:

        assign tt-prest-inc-aux = tt-prest-inc-aux + 1.

        run imp-prestador.

    end.

    if   lg-migracao-aux
    then return.

    put stream s-acertos
        skip(1)
        "Total Prestadores Incluidos:" at 22
        tt-prest-inc-aux.

    put stream s-acertos
        skip(1)
        "======================================================"
        " PRESTADORES ALTERADOS "
        "======================================================" 
        skip.

    for each tmp-preserv where tmp-preserv.in-movto = 2 no-lock:

        assign tt-prest-alt-aux = tt-prest-alt-aux + 1.

        run imp-prestador.

    end.

    put stream s-acertos
        skip(1)
        "Total Prestadores Alterados:" at 22
        tt-prest-alt-aux.

    put stream s-acertos
        skip(1)
        "======================================================"
        " PRESTADORES EXCLUIDOS "
        "======================================================"
        skip.

    for each tmp-preserv where tmp-preserv.in-movto = 3 no-lock:

        assign tt-prest-exc-aux = tt-prest-exc-aux + 1.

        run imp-prestador.

    end.

    put stream s-acertos
        skip(1)
        "Total Prestadores Excluidos:" at 22
        tt-prest-exc-aux.

    put stream s-acertos
        skip(1)
        "======================================================"
        " PRESTADORES REATIVADOS "
        "====================================================="
        skip.

    for each tmp-preserv where tmp-preserv.in-movto = 4 no-lock:

        assign tt-prest-reat-aux = tt-prest-reat-aux + 1.

        run imp-prestador.

    end.

    put stream s-acertos
        skip(1)
        "Total Prestadores Reativados:" at 21
        tt-prest-reat-aux.

    
end procedure.

/* ------------------------------------------------------------------------- */
procedure imp-prestador:

    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-20cpp-ativa-aux.
    &endif.

    /* --------------------------------------- REGISTROS PRESERV GRAVADA --- */
    put stream s-acertos skip(1).
    
    /* ativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-ativa-aux.
    &endif.
    
    put stream s-acertos "Registro Nro. 1 - PRESTADORES" skip.
    
    /* desativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-desat-aux.
    &endif.

    display stream s-acertos
            tmp-preserv.cd-unidade     @ c-cd-unidade    
            tmp-preserv.cd-prestador   @ c-cd-prestador  
            tmp-preserv.nm-prestador   @ c-nm-prestador  
            tmp-preserv.nome-abrev     @ c-nome-abrev    
            tmp-preserv.in-tipo-pessoa @ c-in-tipo-pessoa
            tmp-preserv.nr-cgc-cpf     @ c-cgc-cpf       
            with frame f-lista-1.

    down with frame f-lista-1.
    
    /* ------------------------------------- REGISTROS PREVIESP GRAVADOS --- */
    put stream s-acertos skip(1).

    /* ativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-ativa-aux.
    &endif

    put stream s-acertos
               "   Registro Nro. 2 - PRESTADOR X VINCULO X ESPECIALIDADE" skip.

    /* desativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-desat-aux.
    &endif

    for each tmp-previesp where tmp-previesp.cd-unidade   = tmp-preserv.cd-unidade
                            and tmp-previesp.cd-prestador = tmp-preserv.cd-prestador
                                no-lock:

        display stream s-acertos
                tmp-previesp.cd-vinculo              @ wk-reg2.cd-vinculo
                tmp-previesp.cd-especialid           @ wk-reg2.cd-especialid
                tmp-previesp.lg-principal            @ wk-reg2.lg-principal
                tmp-previesp.lg-considera-qt-vinculo @ wk-reg2.lg-considera-qt-vinculo
                with frame f-lista-acertos-2.

        down with frame f-lista-acertos-2.

    end.

    /* --------------------------------------- REGISTRO PRESERV GRAVADOS --- */
    find first tmp-endpres 
         where tmp-endpres.cd-unidade   = tmp-preserv.cd-unidade  
           and tmp-endpres.cd-prestador = tmp-preserv.cd-prestador
               no-lock no-error.
    if avail tmp-endpres
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 3 - ENDERECOS DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
     
    for each tmp-endpres where tmp-endpres.cd-unidade   = tmp-preserv.cd-unidade  
                           and tmp-endpres.cd-prestador = tmp-preserv.cd-prestador
                               no-lock:

        display stream s-acertos
                tmp-endpres.en-endereco @ wk-reg3.en-endereco
                tmp-endpres.en-bairro   @ wk-reg3.en-bairro
                tmp-endpres.en-cep      @ wk-reg3.en-cep
                tmp-endpres.en-uf       @ wk-reg3.en-uf
                with frame f-lista-acertos-3.

        down with frame f-lista-acertos-3.
    end.

    /* --------------------------------------- REGISTRO PREST-INST GRAVADOS --- */
    find first tmp-prest-inst
         where tmp-prest-inst.cd-unidade   = tmp-preserv.cd-unidade  
           and tmp-prest-inst.cd-prestador = tmp-preserv.cd-prestador
               no-lock no-error.
    if avail tmp-prest-inst
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 4 - INSTITUICOES ACREDITADORAS DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
    
    for each tmp-prest-inst
       where tmp-prest-inst.cd-unidade   = tmp-preserv.cd-unidade  
         and tmp-prest-inst.cd-prestador = tmp-preserv.cd-prestador
             no-lock:

        display stream s-acertos
                tmp-prest-inst.cod-instit @ wk-reg4.cod-instit
                tmp-prest-inst.cdn-nivel  @ wk-reg4.cdn-nivel
                tmp-prest-inst.lg-autoriz-divulga @ wk-reg4.lg-autoriz-divulga
                tmp-prest-inst.cd-seq-end @ wk-reg4.cd-seq-end
                with frame f-lista-acertos-4.

        down with frame f-lista-acertos-4.
    end.
    
    /* --------------------------------------- REGISTRO PREST-OBS GRAVADOS --- */
    find first tmp-prestdor-obs
         where tmp-prestdor-obs.cd-unidade   = tmp-preserv.cd-unidade  
           and tmp-prestdor-obs.cd-prestador = tmp-preserv.cd-prestador
               no-lock no-error.
    if avail tmp-prestdor-obs
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 5 - OBSERVACOES DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
    
    for each tmp-prestdor-obs
       where tmp-prestdor-obs.cd-unidade   = tmp-preserv.cd-unidade  
         and tmp-prestdor-obs.cd-prestador = tmp-preserv.cd-prestador
             no-lock:

        display stream s-acertos
                substring(tmp-prestdor-obs.des-obs,1,20) @ wk-reg5.divulga-obs
                with frame f-lista-acertos-5.

        down with frame f-lista-acertos-5.
    end.
    
end procedure.
 
/*---------------------------------------------------------------------------*/
/* procedure importa-prestador:                                                              */
/*                                                                                           */
/*    def buffer b-unimed for unimed.                                                        */
/*                                                                                           */
/*    find b-unimed where b-unimed.cd-unimed = c-cd-unidade exclusive-lock no-error.         */
/*    if avail b-unimed                                                                      */
/*    and b-unimed.cd-operadora-susep = 0                                                    */
/*    then do:                                                                               */
/*           assign b-unimed.cd-operadora-susep = c-cd-registro-ans                          */
/*                  b-unimed.dt-atualizacao     = today                                      */
/*                  b-unimed.cd-userid          = v_cod_usuar_corren.                        */
/*           release b-unimed.                                                               */
/*           validate b-unimed.                                                              */
/*         end.                                                                              */
/*                                                                                           */
/*    if lg-migracao-aux                                                                     */
/*    then do:                                                                               */
/*           if not can-find(first preserv where preserv.cd-unidade   = c-cd-unidade         */
/*                                           and preserv.cd-prestador = c-cd-prestador)      */
/*           then run inclui-prestador.                                                      */
/*           return.                                                                         */
/*         end.                                                                              */
/*                                                                                           */
/*    /* ------------------- VERIFICA SE EH UMA INCLUSAO/ALTERACAO/EXCLUSAO --- */           */
/*    find first tmp-movto-prestador where tmp-movto-prestador.cd-unidade   = c-cd-unidade   */
/*                                     and tmp-movto-prestador.cd-prestador = c-cd-prestador */
/*                                         no-lock no-error.                                 */
/*                                                                                           */
/*    if not avail tmp-movto-prestador                                                       */
/*    then return.                                                                           */
/*                                                                                           */
/*    case tmp-movto-prestador.in-movto:                                                     */
/*        when 1    /* INCLUSAO  */                                                          */
/*        then run inclui-prestador.                                                         */
/*        when 2 or /* ALTERACAO */                                                          */
/*        when 3    /* EXCLUSAO  */                                                          */
/*        then run altera-prestador.                                                         */
/*    end case.                                                                              */
/*                                                                                           */
/* end procedure.                                                                            */

/* ----------------------------------------------------------------------------- */

/* procedure inclui-prestador:                                                                                           */
/*                                                                                                                       */
/*     assign in-movto-aux = 1.                                                                                          */
/*                                                                                                                       */
/*     /*----- GRAVAR PRESERV -----*/                                                                                    */
/*     create preserv.                                                                                                   */
/*                                                                                                                       */
/*     run atualiza-grava-preserv(output lg-erro-aux).                                                                   */
/*                                                                                                                       */
/*     if lg-erro-aux                                                                                                    */
/*     then do:                                                                                                          */
/*            assign lg-erro-imp-aux = yes.                                                                              */
/*            undo,retry.                                                                                                */
/*          end.                                                                                                         */
/*                                                                                                                       */
/*     assign tt-prest-gravados = tt-prest-gravados + 1.                                                                 */
/*                                                                                                                       */
/*     validate preserv.                                                                                                 */
/*     release  preserv.                                                                                                 */
/*                                                                                                                       */
/*     /*----- GRAVAR PREVIESP -----*/                                                                                   */
/*     for each wk-reg2:                                                                                                 */
/*         create previesp.                                                                                              */
/*         assign previesp.cd-unidade                = c-cd-unidade                                                      */
/*                previesp.cd-prestador              = c-cd-prestador                                                    */
/*                previesp.cd-vinculo                = wk-reg2.cd-vinculo                                                */
/*                previesp.cd-especialid             = wk-reg2.cd-especialid                                             */
/*                previesp.dt-inicio-validade        = c-dt-inclusao                                                     */
/*                previesp.dt-fim-validade           = 12/31/9999                                                        */
/*                previesp.lg-principal              = wk-reg2.lg-principal                                              */
/*                previesp.lg-considera-qt-vinculo   = wk-reg2.lg-considera-qt-vinculo                                   */
/*                previesp.cd-registro-especialidade = wk-reg2.cd-registro-espec                                         */
/*                previesp.in-contratualizacao       = wk-reg2.cd-tipo-contratualizacao                                  */
/*                previesp.log-4                     = wk-reg2.lg-rce                                                    */
/*                previesp.dt-atualizacao            = today                                                             */
/*                previesp.cd-userid                 = v_cod_usuar_corren                                                */
/*                previesp.dec-1                     = wk-reg2.cd-registro-espec-2                                       */
/*                previesp.int-2                     = wk-reg2.in-tipo-especialidade                                     */
/*                previesp.int-3                     = wk-reg2.cd-tit-cert-esp.                                          */
/*                                                                                                                       */
/*         if not wk-reg2.lg-principal then                                                                              */
/*         do:                                                                                                           */
/*             find first b-previesp where previesp.cd-unidade = c-cd-unidade                                            */
/*                                   and previesp.cd-prestador = c-cd-prestador                                          */
/*                                   and previesp.cd-vinculo = wk-reg2.cd-vinculo                                        */
/*                                   and previesp.log-5 no-lock no-error.                                                */
/*                                                                                                                       */
/*             if not avail b-previesp then                                                                              */
/*             assign previesp.log-5                 = yes. /*aki*/                                                      */
/*         end.                                                                                                          */
/*         assign tt-regs-gravados                   = tt-regs-gravados + 1.                                             */
/*     end.                                                                                                              */
/*                                                                                                                       */
/*     release b-previesp.                                                                                               */
/*     release previesp.                                                                                                 */
/*                                                                                                                       */
/*     /* --------- Grava Area Atuacao --------- */                                                                      */
/*     for each temp-prestdor-x-area-atuac where temp-prestdor-x-area-atuac.cd-cgc       = c-cgc-cpf                     */
/*                                           and temp-prestdor-x-area-atuac.nm-prestador = c-nm-prestador no-lock:       */
/*         create prest-area-atu.                                                                                        */
/*         assign prest-area-atu.cdn-unid       = c-cd-unidade                                                           */
/*                prest-area-atu.cdn-prestdor   = c-cd-prestador                                                         */
/*                prest-area-atu.cdn-area-atuac = temp-prestdor-x-area-atuac.cdn-area-atuac                              */
/*                prest-area-atu.log-certif     = temp-prestdor-x-area-atuac.log-certif                                  */
/*                prest-area-atu.val-livre-1    = temp-prestdor-x-area-atuac.cd-registro-1                               */
/*                prest-area-atu.val-livre-2    = temp-prestdor-x-area-atuac.cd-registro-2                               */
/*                prest-area-atu.cod-usuario    = v_cod_usuar_corren                                                     */
/*                prest-area-atu.dat-atualiza   = today.                                                                 */
/*                                                                                                                       */
/*         assign tt-regs-gravados              = tt-regs-gravados + 1.                                                  */
/*                                                                                                                       */
/*     end.                                                                                                              */
/*                                                                                                                       */
/*     /*----- GRAVAR ENDPRES -----*/                                                                                    */
/*     for each wk-reg3:                                                                                                 */
/*         create endpres.                                                                                               */
/*         assign endpres.cd-unidade        = c-cd-unidade                                                               */
/*                endpres.cd-prestador      = c-cd-prestador                                                             */
/*                endpres.nr-seq-endereco   = wk-reg3.nr-seq-endereco                                                    */
/*                endpres.en-endereco       = wk-reg3.en-endereco                                                        */
/*                endpres.en-bairro         = wk-reg3.en-bairro                                                          */
/*                endpres.cd-cidade         = wk-reg3.cd-cidade                                                          */
/*                endpres.en-cep            = wk-reg3.en-cep                                                             */
/*                endpres.en-uf             = wk-reg3.en-uf                                                              */
/*                endpres.nr-fone[1]        = wk-reg3.nr-fone[1]                                                         */
/*                endpres.nr-fone[2]        = wk-reg3.nr-fone[2]                                                         */
/*                endpres.nr-ramal[1]       = wk-reg3.nr-ramal[1]                                                        */
/*                endpres.nr-ramal[2]       = wk-reg3.nr-ramal[2]                                                        */
/*                endpres.hr-man-ent        = wk-reg3.hr-man-ent                                                         */
/*                endpres.hr-man-sai        = wk-reg3.hr-man-sai                                                         */
/*                endpres.hr-tar-ent        = wk-reg3.hr-tar-ent                                                         */
/*                endpres.hr-tar-sai        = wk-reg3.hr-tar-sai                                                         */
/*                endpres.lg-dias-trab[1]   = wk-reg3.lg-dias-trab[1]                                                    */
/*                endpres.lg-dias-trab[2]   = wk-reg3.lg-dias-trab[2]                                                    */
/*                endpres.lg-dias-trab[3]   = wk-reg3.lg-dias-trab[3]                                                    */
/*                endpres.lg-dias-trab[4]   = wk-reg3.lg-dias-trab[4]                                                    */
/*                endpres.lg-dias-trab[5]   = wk-reg3.lg-dias-trab[5]                                                    */
/*                endpres.lg-dias-trab[6]   = wk-reg3.lg-dias-trab[6]                                                    */
/*                endpres.lg-dias-trab[7]   = wk-reg3.lg-dias-trab[7]                                                    */
/*                endpres.lg-malote         = wk-reg3.lg-malote                                                          */
/*                endpres.lg-recebe-corresp = wk-reg3.lg-recebe-corresp                                                  */
/*                endpres.dec-2             = wk-reg3.in-tipo-endereco                                                   */
/*                endpres.char-1            = string(wk-reg3.cd-cnes,"9999999")                                          */
/*                endpres.int-1             = int(wk-reg3.nr-leitos-tot)                                                 */
/*                endpres.int-2             = int(wk-reg3.nr-leitos-contrat)                                             */
/*                endpres.int-3             = int(wk-reg3.nr-leitos-psiquiat)                                            */
/*                endpres.int-4             = int(wk-reg3.nr-uti-adulto)                                                 */
/*                endpres.int-5             = int(wk-reg3.nr-uti-neonatal)                                               */
/*                endpres.dec-1             = dec(wk-reg3.nr-uti-pediatria)                                              */
/*                endpres.dec-5             = dec(wk-reg3.nr-uti-neo-interm)                                             */
/*                endpres.char-3            = wk-reg3.ds-complementar                                                    */
/*                endpres.dt-atualizacao    = today                                                                      */
/*                endpres.cd-userid         = v_cod_usuar_corren                                                         */
/*                endpres.nm-end-web        = wk-reg3.nm-end-web.                                                        */
/*                                                                                                                       */
/*         if  wk-reg3.lg-filial                                                                                         */
/*         then assign endpres.log-1 = yes                                                                               */
/*                     endpres.dec-4 = dec(wk-reg3.nr-cgc-cpf).                                                          */
/*         else assign endpres.log-1 = no                                                                                */
/*                     endpres.dec-4 = 0.                                                                                */
/*                                                                                                                       */
/*         assign tt-regs-gravados = tt-regs-gravados + 1.                                                               */
/*                                                                                                                       */
/*                                                                                                                       */
/*                                                                                                                       */
/*         FIND prestdor-ender WHERE prestdor-ender.cdn-unid-prestdor = c-cd-unidade                                     */
/*                               and prestdor-ender.cdn-prestdor      = c-cd-prestador                                   */
/*                               and prestdor-ender.num-seq-ender     = wk-reg3.nr-seq-endereco EXCLUSIVE-LOCK NO-ERROR. */
/*                                                                                                                       */
/*         IF NOT AVAIL prestdor-ender                                                                                   */
/*         THEN DO:                                                                                                      */
/*                 create prestdor-ender.                                                                                */
/*                 ASSIGN prestdor-ender.cdn-unid-prestdor = c-cd-unidade                                                */
/*                        prestdor-ender.cdn-prestdor      = c-cd-prestador                                              */
/*                        prestdor-ender.num-seq-ender     = wk-reg3.nr-seq-endereco.                                    */
/*              END.                                                                                                     */
/*                                                                                                                       */
/*                                                                                                                       */
/*                                                                                                                       */
/*                                                                                                                       */
/*         assign prestdor-ender.num-acomoda-tot-clini         =   wk-reg3.nr-leitos-tot-clin-n-uti                      */
/*                prestdor-ender.num-acomoda-cirurgc           =   wk-reg3.nr-leitos-tot-cirur-n-uti                     */
/*                prestdor-ender.num-acomoda-tot-obstr         =   wk-reg3.nr-leito-tot-obst-n-uti                       */
/*                prestdor-ender.num-acomoda-tot-pediat        =   wk-reg3.nr-leitos-tot-ped-n-uti                       */
/*                prestdor-ender.num-acomoda-tot-psiquiat      =   wk-reg3.nr-leitos-tot-psic-n-uti                      */
/*                prestdor-ender.cod-latitude                  =   wk-reg3.nm-latitue                                    */
/*                prestdor-ender.cod-longitude                 =   wk-reg3.nm-longitude                                  */
/*                prestdor-ender.num-acomoda-tot-clini-2       =   int(wk-reg3.nr-leitos-tot) /*num-acomoda-tot*/        */
/*                prestdor-ender.num-acomoda-psiquiat-uti      =   int(wk-reg3.nr-leitos-psiq)                           */
/*                prestdor-ender.num-acomoda-neonat-uti        =   int(wk-reg3.nr-uti-neonatal)                          */
/*                prestdor-ender.num-acomoda-contrat-uti       =   int(wk-reg3.nr-leitos-contrat)                        */
/*                prestdor-ender.num-acomoda-normal-uti        =   int(wk-reg3.nr-uti-adulto)                            */
/*                prestdor-ender.num-acomoda-pediat-uti        =   int(wk-reg3.nr-uti-pediatria)                         */
/*                prestdor-ender.num-acomoda-interm-neonat-uti =   int(wk-reg3.nr-uti-neo-interm-neo)                    */
/*                prestdor-ender.num-acomoda-hos-dia           =   wk-reg3.nr-leitos-hosp-dia                            */
/*                prestdor-ender.num-livre-1                   =   int(wk-reg3.nr-uti-neo-interm).                       */
/*                                                                                                                       */
/*                                                                                                                       */
/*                                                                                                                       */
/*     end.                                                                                                              */
/*     release endpres.                                                                                                  */
/*                                                                                                                       */
/*     /*----- GRAVAR PREST-INST -----*/                                                                                 */
/*     for each wk-reg4:                                                                                                 */
/*         create prest-inst.                                                                                            */
/*         assign prest-inst.cd-unidade            = c-cd-unidade                                                        */
/*                prest-inst.cd-prestador          = c-cd-prestador                                                      */
/*                prest-inst.cod-instit            = caps(wk-reg4.cod-instit)                                            */
/*                prest-inst.cdn-nivel             = wk-reg4.cdn-nivel                                                   */
/*                prest-inst.num-livre-1           = wk-reg4.cd-seq-end                                                  */
/*                prest-inst.dat-ult-atualiz       = today                                                               */
/*                prest-inst.cod-usuar-ult-atualiz = v_cod_usuar_corren.                                                 */
/*                                                                                                                       */
/*         assign tt-regs-gravados = tt-regs-gravados + 1.                                                               */
/*     end.                                                                                                              */
/*     release prest-inst.                                                                                               */
/*                                                                                                                       */
/*     /*----- GRAVAR PRESTDOR-OBS -----*/                                                                               */
/*     for each wk-reg5:                                                                                                 */
/*         create prestdor-obs.                                                                                          */
/*         assign prestdor-obs.cdn-unid-prestdor = c-cd-unidade                                                          */
/*                prestdor-obs.cdn-prestdor      = c-cd-prestador                                                        */
/*                prestdor-obs.des-obs           = trim(wk-reg5.divulga-obs)                                             */
/*                prestdor-obs.dat-ult-atualiz   = today.                                                                */
/*                                                                                                                       */
/*         assign tt-regs-gravados = tt-regs-gravados + 1.                                                               */
/*     end.                                                                                                              */
/*     release prestdor-obs.                                                                                             */
/*                                                                                                                       */
/*     /*----- GRAVAR PRESTADOR SUBSTITUTO -----*/                                                                       */
/*     for each wk-reg6:                                                                                                 */
/*         create subst-prestdor-excd.                                                                                   */
/*         assign subst-prestdor-excd.cdn-unid              = c-cd-unidade                                               */
/*                subst-prestdor-excd.cdn-prestdor          = c-cd-prestador                                             */
/*                subst-prestdor-excd.cdn-unid-subst        = wk-reg6.c-cd-unidade-subst                                 */
/*                subst-prestdor-excd.cdn-prestdor-subst    = wk-reg6.c-cd-prest-subst                                   */
/*                subst-prestdor-excd.dat-inic-subst        = wk-reg6.c-dt-inicio-subst                                  */
/*                subst-prestdor-excd.dat-ult-atualiz       = today                                                      */
/*                subst-prestdor-excd.cod-usuar-ult-atualiz = v_cod_usuar_corren.                                        */
/*                                                                                                                       */
/*         assign tt-regs-gravados = tt-regs-gravados + 1.                                                               */
/*     end.                                                                                                              */
/*     release subst-prestdor-excd.                                                                                      */
/*                                                                                                                       */
/* end procedure.                                                                                                        */

/* ----------------------------------------------------------------------------- */
/* procedure altera-prestador:                                                                                                  */
/*     find preserv where preserv.cd-unidade   = c-cd-unidade                                                                   */
/*                    and preserv.cd-prestador = c-cd-prestador                                                                 */
/*                        exclusive-lock no-error.                                                                              */
/*                                                                                                                              */
/*     if avail preserv                                                                                                         */
/*     then do:                                                                                                                 */
/*                                                                                                                              */
/*            if  preserv.dt-exclusao = ?                                                                                       */
/*            and c-dt-exclusao <> ?                                                                                            */
/*            then assign in-movto-aux = 3. /* EXCLUSAO */                                                                      */
/*                                                                                                                              */
/*            else                                                                                                              */
/*                                                                                                                              */
/*            if  preserv.dt-exclusao <> ?                                                                                      */
/*            and c-dt-exclusao        = ?                                                                                      */
/*            then assign in-movto-aux = 4. /* REINCLUSAO */                                                                    */
/*                                                                                                                              */
/*            else                                                                                                              */
/*                                                                                                                              */
/*            assign in-movto-aux = 2. /* ALTERACAO */                                                                          */
/*                                                                                                                              */
/*            assign lg-alt-prest-aux = no.                                                                                     */
/*                                                                                                                              */
/*            run atualiza-grava-preserv(output lg-erro-aux).                                                                   */
/*                                                                                                                              */
/*            if lg-erro-aux                                                                                                    */
/*            then do:                                                                                                          */
/*                   assign lg-erro-imp-aux = yes.                                                                              */
/*                   undo,retry.                                                                                                */
/*                 end.                                                                                                         */
/*                                                                                                                              */
/*            /* ------------------- PRESTADOR X VINCULO X ESPECIALIDADE MEDICA --- */                                          */
/*                                                                                                                              */
/*            find first wk-reg2 where wk-reg2.lg-principal = yes no-lock no-error.                                             */
/*                                                                                                                              */
/*            if   avail wk-reg2                                                                                                */
/*            then do:                                                                                                          */
/*                   find first b-previesp                                                                                      */
/*                        where b-previesp.cd-unidade   = c-cd-unidade                                                          */
/*                          and b-previesp.cd-prestador = c-cd-prestador                                                        */
/*                          and b-previesp.cd-vinculo   = wk-reg2.cd-vinculo                                                    */
/*                          and b-previesp.lg-principal = yes                                                                   */
/*                              exclusive-lock no-error.                                                                        */
/*                                                                                                                              */
/*                   if   avail b-previesp                                                                                      */
/*                   and  b-previesp.cd-especialid <> wk-reg2.cd-especialid                                                     */
/*                   then do:                                                                                                   */
/*                          assign b-previesp.lg-principal   = no                                                               */
/*                                 b-previesp.dt-atualizacao = today                                                            */
/*                                 b-previesp.cd-userid      = v_cod_usuar_corren.                                              */
/*                                                                                                                              */
/*                          validate b-previesp.                                                                                */
/*                                                                                                                              */
/*                          create tmp-previesp.                                                                                */
/*                          assign tmp-previesp.cd-unidade                 = c-cd-unidade                                       */
/*                                 tmp-previesp.cd-prestador               = c-cd-prestador                                     */
/*                                 tmp-previesp.cd-vinculo                 = b-previesp.cd-vinculo                              */
/*                                 tmp-previesp.cd-especialid              = b-previesp.cd-especialid                           */
/*                                 tmp-previesp.lg-principal               = b-previesp.lg-principal                            */
/*                                 tmp-previesp.lg-considera-qt-vinculo    = b-previesp.lg-considera-qt-vinculo                 */
/*                                 tmp-previesp.cd-registro-especialidade  = wk-reg2.cd-registro-espec                          */
/*                                 tmp-previesp.dec-1                      = wk-reg2.cd-registro-espec-2                        */
/*                                 tmp-previesp.int-2                      = wk-reg2.in-tipo-especialidade                      */
/*                                 tmp-previesp.int-3                      = wk-reg2.cd-tit-cert-esp                            */
/*                                 lg-alt-prest-aux                        = yes.                                               */
/*                                                                                                                              */
/*                          assign tt-regs-gravados = tt-regs-gravados + 1.                                                     */
/*                        end.                                                                                                  */
/*                 end.                                                                                                         */
/*                                                                                                                              */
/*            for each wk-reg2:                                                                                                 */
/*                                                                                                                              */
/*                find first previesp                                                                                           */
/*                     where previesp.cd-unidade         = c-cd-unidade                                                         */
/*                       and previesp.cd-prestador       = c-cd-prestador                                                       */
/*                       and previesp.cd-vinculo         = wk-reg2.cd-vinculo                                                   */
/*                       and previesp.cd-especialid      = wk-reg2.cd-especialid                                                */
/*                           no-lock no-error.                                                                                  */
/*                                                                                                                              */
/*                if   not avail previesp                                                                                       */
/*                then do:                                                                                                      */
/*                                                                                                                              */
/*                       create previesp.                                                                                       */
/*                       assign previesp.cd-unidade                = c-cd-unidade                                               */
/*                              previesp.cd-prestador              = c-cd-prestador                                             */
/*                              previesp.cd-vinculo                = wk-reg2.cd-vinculo                                         */
/*                              previesp.cd-especialid             = wk-reg2.cd-especialid                                      */
/*                              previesp.dt-inicio-validade        = c-dt-inclusao                                              */
/*                              previesp.dt-fim-validade           = 12/31/9999                                                 */
/*                              previesp.lg-principal              = wk-reg2.lg-principal                                       */
/*                              previesp.lg-considera-qt-vinculo   = wk-reg2.lg-considera-qt-vinculo                            */
/*                              previesp.in-contratualizacao       = wk-reg2.cd-tipo-contratualizacao                           */
/*                              previesp.log-4                     = wk-reg2.lg-rce                                             */
/*                              previesp.dt-atualizacao            = today                                                      */
/*                              previesp.cd-userid                 = v_cod_usuar_corren                                         */
/*                              previesp.cd-registro-especialidade = wk-reg2.cd-registro-espec                                  */
/*                              previesp.dec-1                     = wk-reg2.cd-registro-espec-2                                */
/*                              previesp.int-2                     = wk-reg2.in-tipo-especialidade                              */
/*                              previesp.int-3                     = wk-reg2.cd-tit-cert-esp                                    */
/*                              lg-alt-prest-aux                   = yes.                                                       */
/*                                                                                                                              */
/*                                                                                                                              */
/*                       if not wk-reg2.lg-principal then                                                                       */
/*                       do:                                                                                                    */
/*                           find first b-previesp where previesp.cd-unidade = c-cd-unidade                                     */
/*                                                   and previesp.cd-prestador = c-cd-prestador                                 */
/*                                                   and previesp.cd-vinculo = wk-reg2.cd-vinculo                               */
/*                                                   and previesp.log-5 no-lock no-error.                                       */
/*                                                                                                                              */
/*                           if not avail b-previesp then                                                                       */
/*                           assign previesp.log-5                     = yes. /*aki*/                                           */
/*                       end.                                                                                                   */
/*                                                                                                                              */
/*                      assign tt-regs-gravados = tt-regs-gravados + 1.                                                         */
/*                     end.                                                                                                     */
/*                else do:                                                                                                      */
/*                       if  previesp.in-contratualizacao <> wk-reg2.cd-tipo-contratualizacao                                   */
/*                       or  previesp.log-4               <> wk-reg2.lg-rce                                                     */
/*                       then do:                                                                                               */
/*                              find current previesp exclusive-lock no-error.                                                  */
/*                              if   avail previesp                                                                             */
/*                              then do:                                                                                        */
/*                                     assign tt-regs-gravados = tt-regs-gravados + 1                                           */
/*                                            lg-alt-prest-aux = yes.                                                           */
/*                                                                                                                              */
/*                                     assign previesp.in-contratualizacao = wk-reg2.cd-tipo-contratualizacao                   */
/*                                            previesp.log-4               =  wk-reg2.lg-rce                                    */
/*                                            previesp.dt-atualizacao      = today                                              */
/*                                            previesp.cd-userid           = v_cod_usuar_corren.                                */
/*                                                                                                                              */
/*                                     release previesp.                                                                        */
/*                                   end.                                                                                       */
/*                            end.                                                                                              */
/*                     end.                                                                                                     */
/*            end.                                                                                                              */
/*                                                                                                                              */
/*            /* --------------------------------------- ENDERECOS DO PRESTADOR --- */                                          */
/*            for each wk-reg3:                                                                                                 */
/*                                                                                                                              */
/*                find first endpres                                                                                            */
/*                     where endpres.cd-unidade   = c-cd-unidade                                                                */
/*                       and endpres.cd-prestador = c-cd-prestador                                                              */
/*                       and endpres.en-endereco  = wk-reg3.en-endereco                                                         */
/*                       and endpres.en-bairro    = wk-reg3.en-bairro                                                           */
/*                       and endpres.cd-cidade    = wk-reg3.cd-cidade                                                           */
/*                       and endpres.en-cep       = wk-reg3.en-cep                                                              */
/*                       and endpres.en-uf        = wk-reg3.en-uf                                                               */
/*                           exclusive-lock no-error.                                                                           */
/*                                                                                                                              */
/*                if not avail endpres                                                                                          */
/*                then do:                                                                                                      */
/*                       find first endpres where endpres.cd-unidade      = c-cd-unidade                                        */
/*                                            and endpres.cd-prestador    = c-cd-prestador                                      */
/*                                            and endpres.nr-seq-endereco = wk-reg3.nr-seq-endereco                             */
/*                                                no-lock no-error.                                                             */
/*                       if avail endpres                                                                                       */
/*                       then do:                                                                                               */
/*                              find last endpres where endpres.cd-unidade      = c-cd-unidade                                  */
/*                                                  and endpres.cd-prestador    = c-cd-prestador                                */
/*                                                      no-lock no-error.                                                       */
/*                              if   avail endpres                                                                              */
/*                              then assign wk-reg3.nr-seq-endereco = endpres.nr-seq-endereco + 1.                              */
/*                            end.                                                                                              */
/*                                                                                                                              */
/*                       create endpres.                                                                                        */
/*                       assign endpres.cd-unidade      = c-cd-unidade                                                          */
/*                              endpres.cd-prestador    = c-cd-prestador                                                        */
/*                              endpres.nr-seq-endereco = wk-reg3.nr-seq-endereco                                               */
/*                              endpres.en-endereco     = wk-reg3.en-endereco                                                   */
/*                              endpres.en-bairro       = wk-reg3.en-bairro                                                     */
/*                              endpres.cd-cidade       = wk-reg3.cd-cidade                                                     */
/*                              endpres.en-cep          = wk-reg3.en-cep                                                        */
/*                              endpres.en-uf           = wk-reg3.en-uf                                                         */
/*                              lg-alt-prest-aux        = yes.                                                                  */
/*                     end.                                                                                                     */
/*                if   not lg-layout-serious-aux                                                                                */
/*                then do:                                                                                                      */
/*                       if endpres.nr-fone[1]        <> wk-reg3.nr-fone[1]                                                     */
/*                       or endpres.nr-fone[2]        <> wk-reg3.nr-fone[2]                                                     */
/*                       or endpres.lg-malote         <> wk-reg3.lg-malote                                                      */
/*                       or endpres.lg-recebe-corresp <> wk-reg3.lg-recebe-corresp                                              */
/*                       or endpres.dec-2             <> wk-reg3.in-tipo-endereco                                               */
/*                       or endpres.char-1            <> string(wk-reg3.cd-cnes,"9999999")                                      */
/*                       or endpres.int-1             <> int(wk-reg3.nr-leitos-tot)                                             */
/*                       or endpres.int-2             <> int(wk-reg3.nr-leitos-contrat)                                         */
/*                       or endpres.int-3             <> int(wk-reg3.nr-leitos-psiquiat)                                        */
/*                       or endpres.int-4             <> int(wk-reg3.nr-uti-adulto)                                             */
/*                       or endpres.int-5             <> int(wk-reg3.nr-uti-neonatal)                                           */
/*                       or endpres.dec-1             <> dec(wk-reg3.nr-uti-pediatria)                                          */
/*                       or endpres.dec-5             <> dec(wk-reg3.nr-uti-neo-interm)                                         */
/*                       then assign endpres.nr-fone[1]        = wk-reg3.nr-fone[1]                                             */
/*                                   endpres.nr-fone[2]        = wk-reg3.nr-fone[2]                                             */
/*                                   endpres.lg-malote         = wk-reg3.lg-malote                                              */
/*                                   endpres.lg-recebe-corresp = wk-reg3.lg-recebe-corresp                                      */
/*                                   endpres.dec-2             = wk-reg3.in-tipo-endereco                                       */
/*                                   endpres.char-1            = string(wk-reg3.cd-cnes,"9999999")                              */
/*                                   endpres.int-1             = int(wk-reg3.nr-leitos-tot)                                     */
/*                                   endpres.int-2             = int(wk-reg3.nr-leitos-contrat)                                 */
/*                                   endpres.int-3             = int(wk-reg3.nr-leitos-psiquiat)                                */
/*                                   endpres.int-4             = int(wk-reg3.nr-uti-adulto)                                     */
/*                                   endpres.int-5             = int(wk-reg3.nr-uti-neonatal)                                   */
/*                                   endpres.dec-1             = dec(wk-reg3.nr-uti-pediatria)                                  */
/*                                   endpres.dec-5             = dec(wk-reg3.nr-uti-neo-interm)                                 */
/*                                   endpres.dt-atualizacao    = today                                                          */
/*                                   endpres.cd-userid         = v_cod_usuar_corren                                             */
/*                                   lg-alt-prest-aux          = yes                                                            */
/*                                   tt-regs-gravados          = tt-regs-gravados + 1.                                          */
/*                     end.                                                                                                     */
/*                else assign endpres.nr-fone[1]        = wk-reg3.nr-fone[1]                                                    */
/*                            endpres.nr-fone[2]        = wk-reg3.nr-fone[2]                                                    */
/*                            endpres.lg-malote         = wk-reg3.lg-malote                                                     */
/*                            endpres.lg-recebe-corresp = wk-reg3.lg-recebe-corresp                                             */
/*                            endpres.dec-2             = wk-reg3.in-tipo-endereco                                              */
/*                            endpres.char-1            = string(wk-reg3.cd-cnes,"9999999")                                     */
/*                            endpres.int-1             = int(wk-reg3.nr-leitos-tot)                                            */
/*                            endpres.int-2             = int(wk-reg3.nr-leitos-contrat)                                        */
/*                            endpres.int-3             = int(wk-reg3.nr-leitos-psiquiat)                                       */
/*                            endpres.int-4             = int(wk-reg3.nr-uti-adulto)                                            */
/*                            endpres.int-5             = int(wk-reg3.nr-uti-neonatal)                                          */
/*                            endpres.dec-1             = dec(wk-reg3.nr-uti-pediatria)                                         */
/*                            endpres.dec-5             = dec(wk-reg3.nr-uti-neo-interm)                                        */
/*                            endpres.nr-ramal[1]       = wk-reg3.nr-ramal[1]                                                   */
/*                            endpres.nr-ramal[2]       = wk-reg3.nr-ramal[2]                                                   */
/*                            endpres.hr-man-ent        = wk-reg3.hr-man-ent                                                    */
/*                            endpres.hr-man-sai        = wk-reg3.hr-man-sai                                                    */
/*                            endpres.hr-tar-ent        = wk-reg3.hr-tar-ent                                                    */
/*                            endpres.hr-tar-sai        = wk-reg3.hr-tar-sai                                                    */
/*                            endpres.lg-dias-trab[1]   = wk-reg3.lg-dias-trab[1]                                               */
/*                            endpres.lg-dias-trab[2]   = wk-reg3.lg-dias-trab[2]                                               */
/*                            endpres.lg-dias-trab[3]   = wk-reg3.lg-dias-trab[3]                                               */
/*                            endpres.lg-dias-trab[4]   = wk-reg3.lg-dias-trab[4]                                               */
/*                            endpres.lg-dias-trab[5]   = wk-reg3.lg-dias-trab[5]                                               */
/*                            endpres.lg-dias-trab[6]   = wk-reg3.lg-dias-trab[6]                                               */
/*                            endpres.lg-dias-trab[7]   = wk-reg3.lg-dias-trab[7]                                               */
/*                            endpres.dt-atualizacao    = today                                                                 */
/*                            endpres.cd-userid         = v_cod_usuar_corren                                                    */
/*                            tt-regs-gravados          = tt-regs-gravados + 1.                                                 */
/*                if  wk-reg3.lg-filial                                                                                         */
/*                then assign endpres.log-1 = yes                                                                               */
/*                            endpres.dec-4 = dec(wk-reg3.nr-cgc-cpf).                                                          */
/*                else assign endpres.log-1 = no                                                                                */
/*                            endpres.dec-4 = 0.                                                                                */
/*                                                                                                                              */
/*                assign endpres.nm-end-web = wk-reg3.nm-end-web.                                                               */
/*                                                                                                                              */
/*                                                                                                                              */
/*                                                                                                                              */
/*                FIND prestdor-ender WHERE prestdor-ender.cdn-unid-prestdor = c-cd-unidade                                     */
/*                                      and prestdor-ender.cdn-prestdor      = c-cd-prestador                                   */
/*                                      and prestdor-ender.num-seq-ender     = wk-reg3.nr-seq-endereco EXCLUSIVE-LOCK NO-ERROR. */
/*                                                                                                                              */
/*                IF NOT AVAIL prestdor-ender                                                                                   */
/*                THEN DO:                                                                                                      */
/*                        create prestdor-ender.                                                                                */
/*                        ASSIGN prestdor-ender.cdn-unid-prestdor = c-cd-unidade                                                */
/*                               prestdor-ender.cdn-prestdor      = c-cd-prestador                                              */
/*                               prestdor-ender.num-seq-ender     = wk-reg3.nr-seq-endereco.                                    */
/*                     END.                                                                                                     */
/*                                                                                                                              */
/*                                                                                                                              */
/*                assign prestdor-ender.num-acomoda-tot-clini         =   wk-reg3.nr-leitos-tot-clin-n-uti                      */
/*                       prestdor-ender.num-acomoda-cirurgc           =   wk-reg3.nr-leitos-tot-cirur-n-uti                     */
/*                       prestdor-ender.num-acomoda-tot-obstr         =   wk-reg3.nr-leito-tot-obst-n-uti                       */
/*                       prestdor-ender.num-acomoda-tot-pediat        =   wk-reg3.nr-leitos-tot-ped-n-uti                       */
/*                       prestdor-ender.num-acomoda-tot-psiquiat      =   wk-reg3.nr-leitos-tot-psic-n-uti                      */
/*                       prestdor-ender.cod-latitude                   =   wk-reg3.nm-latitue                                   */
/*                       prestdor-ender.cod-longitude              =   wk-reg3.nm-longitude                                     */
/*                       prestdor-ender.num-acomoda-tot-clini-2       =   int(wk-reg3.nr-leitos-tot) /*num-acomoda-tot*/        */
/*                       prestdor-ender.num-acomoda-psiquiat-uti      =   int(wk-reg3.nr-leitos-psiq)                           */
/*                       prestdor-ender.num-acomoda-neonat-uti        =   int(wk-reg3.nr-uti-neonatal)                          */
/*                       prestdor-ender.num-acomoda-contrat-uti       =   int(wk-reg3.nr-leitos-contrat)                        */
/*                       prestdor-ender.num-acomoda-normal-uti        =   int(wk-reg3.nr-uti-adulto)                            */
/*                       prestdor-ender.num-acomoda-pediat-uti        =   int(wk-reg3.nr-uti-pediatria)                         */
/*                       prestdor-ender.num-acomoda-interm-neonat-uti =   int(wk-reg3.nr-uti-neo-interm-neo)                    */
/*                       prestdor-ender.num-acomoda-hos-dia           =   wk-reg3.nr-leitos-hosp-dia                            */
/*                       prestdor-ender.num-livre-1                   =   int(wk-reg3.nr-uti-neo-interm).                       */
/*                                                                                                                              */
/*                                                                                                                              */
/*                                                                                                                              */
/*                                                                                                                              */
/*            end.                                                                                                              */
/*                                                                                                                              */
/*                                                                                                                              */
/*            /* ---------------------- INSTITUICOES ACREDITADORAS DO PRESTADOR --- */                                          */
/*            for each wk-reg4:                                                                                                 */
/*                                                                                                                              */
/*                find first prest-inst                                                                                         */
/*                     where prest-inst.cd-unidade   = c-cd-unidade                                                             */
/*                       and prest-inst.cd-prestador = c-cd-prestador                                                           */
/*                       and prest-inst.cod-instit   = wk-reg4.cod-instit                                                       */
/*                           exclusive-lock no-error.                                                                           */
/*                                                                                                                              */
/*                if not avail prest-inst                                                                                       */
/*                then do:                                                                                                      */
/*                       create prest-inst.                                                                                     */
/*                       assign prest-inst.cd-unidade   = c-cd-unidade                                                          */
/*                              prest-inst.cd-prestador = c-cd-prestador                                                        */
/*                              prest-inst.cod-instit   = wk-reg4.cod-instit                                                    */
/*                              lg-alt-prest-aux        = yes.                                                                  */
/*                     end.                                                                                                     */
/*                                                                                                                              */
/*                assign prest-inst.cdn-nivel             = wk-reg4.cdn-nivel                                                   */
/*                       prest-inst.num-livre-1           = wk-reg4.cd-seq-end                                                  */
/*                       prest-inst.dat-ult-atualiz       = today                                                               */
/*                       prest-inst.cod-usuar-ult-atualiz = v_cod_usuar_corren                                                  */
/*                       lg-alt-prest-aux                 = yes                                                                 */
/*                       tt-regs-gravados                 = tt-regs-gravados + 1                                                */
/*                       prest-inst.log-livre-1           = wk-reg4.lg-autoriz-divulga.                                         */
/*            end.                                                                                                              */
/*            /* ---------------------------------------- PRESTADOR X OBSERVACOES ---- */                                       */
/*            for each wk-reg5:                                                                                                 */
/*                                                                                                                              */
/*                find first prestdor-obs                                                                                       */
/*                     where prestdor-obs.cdn-unid-prestdor = c-cd-unidade                                                      */
/*                       and prestdor-obs.cdn-prestdor      = c-cd-prestador                                                    */
/*                           exclusive-lock no-error.                                                                           */
/*                                                                                                                              */
/*                if not avail prestdor-obs                                                                                     */
/*                then do:                                                                                                      */
/*                       create prestdor-obs.                                                                                   */
/*                       assign prestdor-obs.cdn-unid-prestdor = c-cd-unidade                                                   */
/*                              prestdor-obs.cdn-prestdor      = c-cd-prestador.                                                */
/*                                                                                                                              */
/*                     end.                                                                                                     */
/*                assign prestdor-obs.des-obs               = trim(wk-reg5.divulga-obs)                                         */
/*                       prestdor-obs.cod-usuar-ult-atualiz = v_cod_usuar_corren                                                */
/*                       prestdor-obs.dat-ult-atualiz       = today.                                                            */
/*            end.                                                                                                              */
/*                                                                                                                              */
/*            /*--------- deleta os prestadores substitutos para ficar de acordo com o arquivo ----------*/                     */
/*            for each subst-prestdor-excd where subst-prestdor-excd.cdn-unid           = c-cd-unidade                          */
/*                                           and subst-prestdor-excd.cdn-prestdor       = c-cd-prestador                        */
/*                                               no-lock:                                                                       */
/*                                                                                                                              */
/*                find b-subst-prestdor-excd where rowid(b-subst-prestdor-excd) = rowid(subst-prestdor-excd)                    */
/*                                                 exclusive-lock no-error.                                                     */
/*                                                                                                                              */
/*                delete b-subst-prestdor-excd.                                                                                 */
/*                release b-subst-prestdor-excd.                                                                                */
/*                validate b-subst-prestdor-excd.                                                                               */
/*            end.                                                                                                              */
/*                                                                                                                              */
/*            /* --------------------------------------- PRESTADOR SUBSTITUTO ------ */                                         */
/*            for each wk-reg6:                                                                                                 */
/*                                                                                                                              */
/*                create subst-prestdor-excd.                                                                                   */
/*                assign subst-prestdor-excd.cdn-unid              = c-cd-unidade                                               */
/*                       subst-prestdor-excd.cdn-prestdor          = c-cd-prestador                                             */
/*                       subst-prestdor-excd.cdn-unid-subst        = wk-reg6.c-cd-unidade-subst                                 */
/*                       subst-prestdor-excd.cdn-prestdor-subst    = wk-reg6.c-cd-prest-subst                                   */
/*                       subst-prestdor-excd.dat-inic-subst        = wk-reg6.c-dt-inicio-subst                                  */
/*                       subst-prestdor-excd.dat-ult-atualiz       = today                                                      */
/*                       subst-prestdor-excd.cod-usuar-ult-atualiz = v_cod_usuar_corren.                                        */
/*            end.                                                                                                              */
/*                                                                                                                              */
/*            /* ------------------------------------------------------------------ */                                          */
/*                                                                                                                              */
/*            if  not lg-layout-serious-aux                                                                                     */
/*            and in-movto-aux = 2                                                                                              */
/*            and not lg-alt-prest-aux                                                                                          */
/*            then.                                                                                                             */
/*            else assign tt-prest-gravados = tt-prest-gravados + 1.                                                            */
/*                                                                                                                              */
/*     end. /*if avail preserv*/                                                                                                */
/* end procedure.                                                                                                               */

/* ----------------------------------------------------------------------------- */
/* procedure atualiza-grava-preserv:                                                                                */
/*                                                                                                                  */
/*     def output parameter lg-erro-par             as log                      no-undo.                            */
/*                                                                                                                  */
/*     if lg-layout-serious-aux                                                                                     */
/*     or in-movto-aux = 1                                                                                          */
/*     then do:                                                                                                     */
/*            assign preserv.cd-unidade                   = c-cd-unidade                                            */
/*                   preserv.cd-prestador                 = c-cd-prestador                                          */
/*                   preserv.nm-prestador                 = c-nm-prestador                                          */
/*                   preserv.char-20                      = c-nm-fantasia                                           */
/*                   preserv.nome-abrev                   = c-nome-abrev                                            */
/*                   preserv.in-tipo-pessoa               = c-in-tipo-pessoa                                        */
/*                   preserv.cd-grupo-prestador           = c-cd-grupo-prestador                                    */
/*                   preserv.lg-medico                    = c-lg-medico                                             */
/*                   preserv.lg-cooperado                 = c-lg-cooperado                                          */
/*                   preserv.cd-unidade-seccional         = c-cd-unidade-seccional                                  */
/*                   preserv.cd-conselho                  = c-cd-conselho                                           */
/*                   preserv.cd-uf-conselho               = c-cd-uf-conselho                                        */
/*                   preserv.nr-registro                  = c-nr-registro                                           */
/*                   preserv.cd-contratante               = c-cd-magnus                                             */
/*                   preserv.en-rua                       = c-en-rua                                                */
/*                   preserv.char-15                      = c-ds-end-complementar                                   */
/*                   preserv.en-bairro                    = c-en-bairro                                             */
/*                   preserv.cd-cidade                    = c-cd-cidade                                             */
/*                   preserv.en-cep                       = c-en-cep                                                */
/*                   preserv.en-uf                        = c-en-uf                                                 */
/*                   preserv.nr-telefone[1]               = c-nr-telefone[1]                                        */
/*                   preserv.nr-telefone[2]               = c-nr-telefone[2]                                        */
/*                   preserv.dt-inclusao                  = c-dt-inclusao                                           */
/*                   preserv.dt-exclusao                  = c-dt-exclusao                                           */
/*                   preserv.cd-motivo-cancel             = if c-dt-exclusao <> ?                                   */
/*                                                          then if c-cd-motivo-exclusao = 0                        */
/*                                                               then cd-motivo-cancel-aux    /*motivo da tela*/    */
/*                                                               else c-cd-motivo-exclusao    /*motivo do arquivo*/ */
/*                                                          else 0                                                  */
/*                   preserv.lg-sexo                      = c-lg-sexo                                               */
/*                   preserv.dt-nascimento                = c-dt-nascimento                                         */
/*                   preserv.cd-insc-unimed               = c-cd-insc-unimed                                        */
/*                   preserv.cd-situac-sindic             = c-cd-situac-sindic                                      */
/*                   preserv.qt-produtividade             = c-qt-produtividade                                      */
/*                   preserv.lg-alvara                    = c-lg-alvara                                             */
/*                   preserv.lg-registro                  = c-lg-registro                                           */
/*                   preserv.lg-diploma                   = c-lg-diploma                                            */
/*                   preserv.cd-esp-resid                 = c-cd-esp-resid                                          */
/*                   preserv.cd-esp-titulo                = c-cd-esp-titulo                                         */
/*                   preserv.lg-malote                    = c-lg-malote                                             */
/*                   preserv.nr-pis-pasep                 = c-nr-pis-pasep                                          */
/*                   preserv.lg-vinc-empreg               = c-lg-vinc-empreg                                        */
/*                   preserv.nr-ult-inss                  = c-nr-ult-inss                                           */
/*                   preserv.nr-ramal[1]                  = c-nr-ramal[1]                                           */
/*                   preserv.nr-ramal[2]                  = c-nr-ramal[2]                                           */
/*                   preserv.nr-cgc-cpf                   = c-cgc-cpf                                               */
/*                   preserv.lg-representa-unidade        = c-lg-representa-unidade                                 */
/*                   preserv.cd-tab-urge                  = c-cd-tab-urge                                           */
/*                   preserv.lg-recolhe-inss              = c-lg-recolhe-inss                                       */
/*                   preserv.lg-recolhe-participacao      = c-lg-recolhe-participa                                  */
/*                   preserv.lg-calcula-ir                = c-calc-irrf                                             */
/*                   preserv.in-ir-atos-cooperados        = c-incidir-irrf                                          */
/*                   preserv.lg-calcula-adto              = c-lg-calcula-adto                                       */
/*                   preserv.dt-calculo-adto              = c-dt-calculo-adto                                       */
/*                   preserv.nr-dependentes               = c-nr-dependentes                                        */
/*                   preserv.lg-pagamento-rh              = c-lg-pagamento-rh                                       */
/*                   preserv.dt-atualizacao               = today                                                   */
/*                   preserv.cd-userid                    = v_cod_usuar_corren                                      */
/*                   preserv.nm-email                     = c-nm-email                                              */
/*                   preserv.dt-senha                     = today                                                   */
/*                   preserv.nr-inscricao-inss            = c-nr-inscricao-inss                                     */
/*                   preserv.lg-divisao-honorario         = c-lg-divisao-honorario                                  */
/*                   preserv.lg-imposto-unico             = c-calc-imposto-unico                                    */
/*                   preserv.lg-cofins                    = c-calc-cofins                                           */
/*                   preserv.lg-pis-pasep                 = c-calc-pispasep                                         */
/*                   preserv.lg-csll                      = c-calc-csll                                             */
/*                   preserv.lg-calcula-iss               = c-calc-iss                                              */
/*                   preserv.lg-deduz-iss                 = c-deduz-iss                                             */
/*                   preserv.nr-dias-validade             = c-nr-dias-validade                                      */
/*                   preserv.lg-retem-proc                = (if c-retem-proc = "S"                                  */
/*                                                           then yes                                               */
/*                                                           else no)                                               */
/*                   preserv.lg-retem-insu                = (if c-retem-insu = "S"                                  */
/*                                                           then yes                                               */
/*                                                           else no)                                               */
/*                   preserv.in-class-estabelec           = c-cd-tipo-classif-estab                                 */
/*                   preserv.lg-cooperativa               = c-lg-cooperativa                                        */
/*                   preserv.dt-ini-contrato              = c-dt-inicio-contratual                                  */
/*                   preserv.cd-cnes                      = string(c-cd-cnes,"9999999")                             */
/*                   preserv.nm-diretor-tecnico           = c-nm-diretor-tecnico                                    */
/*                   preserv.nr-crm-dir-tec               = c-nr-crm-dir-tecnico                                    */
/*                   preserv.int-9                        = c-tp-disponibilidade                                    */
/*                   preserv.log-4                        = c-lg-acid-trab                                          */
/*                   preserv.log-5                        = c-lg-tab-propria                                        */
/*                   preserv.int-11                       = c-in-perfil-assistencial                                */
/*                   preserv.int-12                       = c-in-tipo-prod-atende                                   */
/*                   preserv.log-6                        = c-lg-guia-medico-aux                                    */
/*                   preserv.char-21                      = c-cd-conselho-dir-tec                                   */
/*                   preserv.char-23                      = c-nr-conselho-dir-tec                                   */
/*                   preserv.char-22                      = c-uf-conselho-dir-tec                                   */
/*                   preserv.int-15                       = c-tp-rede                                               */
/*                   preserv.ds-natureza-doc              = c-ds-natureza-doc-ident                                 */
/*                   preserv.nr-identidade                = c-nr-doc-ident                                          */
/*                   preserv.ds-orgao-emissor             = c-ds-orgao-emissor-ident                                */
/*                   preserv.nm-pais                      = c-nm-pais-emissor-ident                                 */
/*                   preserv.uf-emissor-doc               = c-uf-emissor-ident                                      */
/*                   preserv.dt-emissao-doc               = c-dt-emissao-doc-ident                                  */
/*                   preserv.ds-nacionalidade             = c-ds-nacionalidade                                      */
/*                   tt-regs-gravados                     = tt-regs-gravados  + 1                                   */
/*                   preserv.log-11                       = c-lg-notivisa                                           */
/*                   preserv.int-20                       = c-nr-leitos-hosp-dia                                    */
/*                   preserv.log-12                       = c-lg-qualiss                                            */
/*                   preserv.char-29                      = in-pos-graduacao-aux +                                  */
/*                                                          in-particp-prog-cert-aux +                              */
/*                                                          string(tp-pos-graduacao-aux)                            */
/*                   preserv.char-27                      = c-nm-end-web                                            */
/*                                                                                                                  */
/*                   preserv.log-15                       = lg-publica-ans-aux                                      */
/*                   preserv.log-18                       = lg-indic-residencia-aux                                 */
/*                   preserv.log-16                       = lg-login-wsd-tiss-aux                                   */
/*                   preserv.log-17                       = lg-cadu-aux.                                            */
/*                                                                                                                  */
/*               run rtp/rtrandom.p (input 6,                                                                       */
/*                                   output cd-senha-aux,                                                           */
/*                                   output lg-erro-rtsenha-aux,                                                    */
/*                                   output ds-erro-aux).                                                           */
/*                                                                                                                  */
/*               if lg-erro-rtsenha-aux                                                                             */
/*               then do:                                                                                           */
/*                      assign lg-erro-par         = yes                                                            */
/*                             lg-erro-rtsenha-aux = no.                                                            */
/*                      message ds-erro-aux                                                                         */
/*                            view-as alert-box info buttons ok.                                                    */
/*                      undo, retry.                                                                                */
/*                    end.                                                                                          */
/*                                                                                                                  */
/*              assign preserv.cd-senha = cd-senha-aux.                                                             */
/*                                                                                                                  */
/*              &if "{&sistema}" = "ems504"                                                                         */
/*              or  "{&sistema}" = "ems505"                                                                         */
/*              &then do:                                                                                           */
/*                      assign preserv.cd-tipo-fluxo             = c-cd-tipo-fluxo                                  */
/*                             preserv.cd-imposto                = c-cd-imposto                                     */
/*                             preserv.cd-classificacao-imposto  = c-cd-classificacao-imposto                       */
/*                             preserv.lg-imposto-unico          = c-calc-imposto-unico                             */
/*                             preserv.lg-cofins                 = c-calc-cofins                                    */
/*                             preserv.lg-pis-pasep              = c-calc-pispasep                                  */
/*                             preserv.lg-csll                   = c-calc-csll                                      */
/*                             preserv.cd-imposto-unico          = c-cd-imposto-unico                               */
/*                             preserv.cd-clas-imposto-unico     = c-cd-clas-imposto-unico                          */
/*                             preserv.cd-imposto-cofins         = c-cd-cofins                                      */
/*                             preserv.cd-clas-imposto-cofins    = c-cd-classificacao-cofins                        */
/*                             preserv.cd-imposto-pis-pasep      = c-cd-pispasep                                    */
/*                             preserv.cd-clas-imposto-pis-pasep = c-cd-classificacao-pispasep                      */
/*                             preserv.cd-imposto-csll           = c-cd-csll                                        */
/*                             preserv.cd-clas-imposto-csll      = c-cd-classificacao-csll                          */
/*                             preserv.cd-imposto-inss           = c-cd-inss                                        */
/*                             preserv.cd-classificacao-imp-inss = c-cd-classificacao-inss                          */
/*                             preserv.cd-imposto-iss            = c-cd-iss                                         */
/*                             preserv.cd-classificacao-imp-iss  = c-cd-classificacao-iss                           */
/*                             preserv.lg-calcula-iss            = c-calc-iss                                       */
/*                             preserv.lg-deduz-iss              = c-deduz-iss                                      */
/*                             preserv.portador                  = c-portador                                       */
/*                             preserv.modalidade                = c-modalidade                                     */
/*                             preserv.cod-banco                 = c-cd-banco                                       */
/*                             preserv.agencia                   = c-agencia                                        */
/*                             preserv.conta-corren              = c-conta-corren                                   */
/*                             preserv.cod-forma-pagto           = c-forma-pagto                                    */
/*                             preserv.dig-conta-corren          = c-conta-corren-digito                            */
/*                             preserv.dig-agencia               = c-agencia-digito.                                */
/*                    end.                                                                                          */
/*                                                                                                                  */
/*              &endif.                                                                                             */
/*                                                                                                                  */
/*              if in-movto-aux = 1                                                                                 */
/*              then run grava-histprest(input  "INC",                                                              */
/*                                       output lg-erro-par).                                                       */
/*              else run grava-histprest(input  "ALT",                                                              */
/*                                       output lg-erro-par).                                                       */
/*                                                                                                                  */
/*                                                                                                                  */
/*              if lg-erro-par                                                                                      */
/*              then undo,retry.                                                                                    */
/*                                                                                                                  */
/*              /* --- Grava observacoes na tabela descprest --- */                                                 */
/*              for each descprest where descprest.cd-unidade   = preserv.cd-unidade                                */
/*                                   and descprest.cd-prestador = preserv.cd-prestador                              */
/*                                       exclusive-lock:                                                            */
/*                  delete descprest.                                                                               */
/*              end.                                                                                                */
/*                                                                                                                  */
/*              do ix = 0 to 2:                                                                                     */
/*                                                                                                                  */
/*                  if   length(c-ds-observacao) > (ix * 76)                                                        */
/*                  then do:                                                                                        */
/*                         create descprest.                                                                        */
/*                         assign descprest.cd-unidade     = preserv.cd-unidade                                     */
/*                                descprest.cd-prestador   = preserv.cd-prestador                                   */
/*                                descprest.nr-linha       = ix + 1                                                 */
/*                                descprest.ds-linha       = substring(c-ds-observacao, (ix * 76) + 1, 76)          */
/*                                descprest.dt-atualizacao = today                                                  */
/*                                descprest.cd-userid      = v_cod_usuar_corren.                                    */
/*                       end.                                                                                       */
/*              end.                                                                                                */
/*                                                                                                                  */
/*          end.                                                                                                    */
/*     else do:                                                                                                     */
/*            if preserv.nr-cgc-cpf         <> c-cgc-cpf                                                            */
/*            or preserv.nm-prestador       <> c-nm-prestador                                                       */
/*            or preserv.char-20            <> c-nm-fantasia                                                        */
/*            or preserv.cd-uf-conselho     <> c-cd-uf-conselho                                                     */
/*            or preserv.nr-registro        <> c-nr-registro                                                        */
/*            or preserv.dt-inclusao        <> c-dt-inclusao                                                        */
/*            or preserv.dt-exclusao        <> c-dt-exclusao                                                        */
/*            or preserv.in-class-estabelec <> c-cd-tipo-classif-estab                                              */
/*            or preserv.dt-ini-contrato    <> c-dt-inicio-contratual                                               */
/*            or preserv.nm-diretor-tecnico <> c-nm-diretor-tecnico                                                 */
/*            or preserv.nr-crm-dir-tec     <> c-nr-crm-dir-tecnico                                                 */
/*            or preserv.int-9              <> c-tp-disponibilidade                                                 */
/*            or preserv.nm-email           <> c-nm-email                                                           */
/*            or preserv.cd-cnes            <> string(c-cd-cnes,"9999999")                                          */
/*            or preserv.log-4              <> c-lg-acid-trab                                                       */
/*            or preserv.log-5              <> c-lg-tab-propria                                                     */
/*            or preserv.int-11             <> c-in-perfil-assistencial                                             */
/*            or preserv.int-12             <> c-in-tipo-prod-atende                                                */
/*            or preserv.log-6              <> c-lg-guia-medico-aux                                                 */
/*            or preserv.char-21            <> c-cd-conselho-dir-tec                                                */
/*            or preserv.char-23            <> c-nr-conselho-dir-tec                                                */
/*            or preserv.char-22            <> c-uf-conselho-dir-tec                                                */
/*            or preserv.int-15             <> c-tp-rede                                                            */
/*            or preserv.log-11             <> c-lg-notivisa                                                        */
/*            or preserv.int-20             <> c-nr-leitos-hosp-dia                                                 */
/*            or preserv.log-12             <> c-lg-qualiss                                                         */
/*            or preserv.char-27            <> c-nm-end-web                                                         */
/*            or preserv.log-15             <> lg-publica-ans-aux                                                   */
/*            or preserv.log-18             <> lg-indic-residencia-aux                                              */
/*            or preserv.log-16             <> lg-login-wsd-tiss-aux                                                */
/*            or preserv.log-17             <> lg-cadu-aux                                                          */
/*            or preserv.lg-sexo            <> c-lg-sexo-aux                                                        */
/*            or preserv.cd-motivo-cancel   <> c-cd-motivo-exclusao                                                 */
/*            then do:                                                                                              */
/*                   assign dt-inclusao-aux = preserv.dt-inclusao.                                                  */
/*                                                                                                                  */
/*                   assign preserv.nr-cgc-cpf         = c-cgc-cpf                                                  */
/*                          preserv.nm-prestador       = c-nm-prestador                                             */
/*                          preserv.char-20            = c-nm-fantasia                                              */
/*                          preserv.cd-uf-conselho     = c-cd-uf-conselho                                           */
/*                          preserv.nr-registro        = c-nr-registro                                              */
/*                          preserv.dt-inclusao        = c-dt-inclusao                                              */
/*                          preserv.dt-exclusao        = c-dt-exclusao                                              */
/*                          preserv.cd-motivo-cancel   = if c-dt-exclusao <> ?                                      */
/*                                                       then if c-cd-motivo-exclusao = 0                           */
/*                                                            then cd-motivo-cancel-aux    /*motivo da tela*/       */
/*                                                            else c-cd-motivo-exclusao    /*motivo do arquivo*/    */
/*                                                       else 0                                                     */
/*                          preserv.in-class-estabelec = c-cd-tipo-classif-estab                                    */
/*                          preserv.dt-ini-contrato    = c-dt-inicio-contratual                                     */
/*                          preserv.nm-diretor-tecnico = c-nm-diretor-tecnico                                       */
/*                          preserv.nr-crm-dir-tec     = c-nr-crm-dir-tecnico                                       */
/*                          preserv.int-9              = c-tp-disponibilidade                                       */
/*                          preserv.log-4              = c-lg-acid-trab                                             */
/*                          preserv.log-5              = c-lg-tab-propria                                           */
/*                          preserv.int-11             = c-in-perfil-assistencial                                   */
/*                          preserv.int-12             = c-in-tipo-prod-atende                                      */
/*                          preserv.log-6              = c-lg-guia-medico-aux                                       */
/*                          preserv.char-21            = c-cd-conselho-dir-tec                                      */
/*                          preserv.char-23            = c-nr-conselho-dir-tec                                      */
/*                          preserv.char-22            = c-uf-conselho-dir-tec                                      */
/*                          preserv.int-15             = c-tp-rede                                                  */
/*                          preserv.nm-email           = c-nm-email                                                 */
/*                          preserv.cd-cnes            = string(c-cd-cnes,"9999999")                                */
/*                          preserv.dt-atualizacao     = today                                                      */
/*                          preserv.cd-userid          = v_cod_usuar_corren                                         */
/*                          lg-alt-prest-aux           = yes                                                        */
/*                          tt-regs-gravados           = tt-regs-gravados  + 1                                      */
/*                          preserv.log-11             = c-lg-notivisa                                              */
/*                          preserv.int-20             = c-nr-leitos-hosp-dia                                       */
/*                          preserv.log-12             = c-lg-qualiss                                               */
/*                          preserv.char-27            = c-nm-end-web                                               */
/*                          preserv.log-15             = lg-publica-ans-aux                                         */
/*                          preserv.log-18             = lg-indic-residencia-aux                                    */
/*                          preserv.log-16             = lg-login-wsd-tiss-aux                                      */
/*                          preserv.log-17             = lg-cadu-aux                                                */
/*                          preserv.lg-sexo            = c-lg-sexo-aux.                                             */
/*                                                                                                                  */
/*                   run grava-histprest(input  "ALT",                                                              */
/*                                       output lg-erro-par).                                                       */
/*                   if lg-erro-par                                                                                 */
/*                   then undo,retry.                                                                               */
/*                 end.                                                                                             */
/*          end.                                                                                                    */
/*                                                                                                                  */
/* end procedure.                                                                                                   */

/* -------------------------------- GRAVA HISTORICO DO PRESTADOR --------------- */
procedure grava-histprest:

    def input  parameter in-funcao-par         as char format "x(03)"         no-undo.
    def output parameter lg-erro-par           as log                         no-undo.

    if  in-funcao-par = "INC"
    then do:
           create histprest.
           assign histprest.cd-unidade-prestador = preserv.cd-unidade
                  histprest.cd-prestador         = preserv.cd-prestador
                  histprest.dt-inicial           = preserv.dt-inclusao
                  histprest.dt-final             = preserv.dt-exclusao
                  histprest.cd-grupo-prestador   = preserv.cd-grupo-prestador
                  histprest.lg-cooperado         = preserv.lg-cooperado
                  histprest.cd-userid            = v_cod_usuar_corren
                  histprest.dt-atualizacao       = today.
         end.
    else do:
           find first histprest
                where histprest.cd-unidade   = preserv.cd-unidade
                  and histprest.cd-prestador = preserv.cd-prestador
                      exclusive-lock no-error.
           
           if not avail histprest
           then do:
                  run gera-relat-erro(1, "Historico do prestador nao encontrado. "
                                      + "Unid.: " + string(preserv.cd-unidade)
                                      + " Prest.: " + string(preserv.cd-prestador)).

                  assign lg-erro-par = yes.

                  return.
                end.
           
           if preserv.dt-inclusao < histprest.dt-inicial
           then assign histprest.dt-inicial = preserv.dt-inclusao.
         end.

end procedure.

/* ------ gera layout SERIOUS considerando tabelas associativas ---------------- */
/* MIGRACAO NAO USA ESSE TRECHO.
procedure converte-serious-serious:
   def var cont-aux        as int no-undo.
   def var nr-linha-aux    as int no-undo.

   input  stream s-import from value(nm-arquivo-importar).
   output stream s-export to   value(nm-arquivo-serious-gerar).

   assign tp-anterior  = 0
          cont-aux     = 1
          nr-linha-aux = 0.

   repeat:
      /* ----------------------------------- Consiste linha do arquivo texto --- */
      import stream s-import unformatted c-dados.

      assign nr-linha-aux = nr-linha-aux + 1.

      if   substring(c-dados,1,1) <> "1"
      and  substring(c-dados,1,1) <> "2"
      and  substring(c-dados,1,1) <> "3"
      and  substring(c-dados,1,1) <> "4"
      and  substring(c-dados,1,1) <> "5"
      and  substring(c-dados,1,1) <> "6"
      then do:
             assign lg-erro-geral = yes.

             /* ------------ Verifica se ocorreu algum erro na consistencia --- 
             --------------- da linha do registro ---------------------------- */
             run gera-relat-erro (1,"Tipo de registro invalido. Informado: " + substring(c-dados,1,1) + ". Linha GPS: " + string(nr-linha-aux)).

             assign tp-anterior = 0.
             leave.
           end.

      run consiste-linha-registro no-error. 

      if   error-status:error
      or   lg-erro-geral
      then do:
             assign tp-anterior = 0.
             leave.
           end.

      if   lg-erro-linha 
      then assign tp-anterior = 0.

      /* ------ tabelas associativas ------------------------------------------- */ 
      case substring(c-dados,1,1):
        when "1"
        then do:
               assign cd-especialidade1-aux = 0
                      cd-especialidade2-aux = 0.

               if not cd-grupo-prestador-ass(substring(c-dados,067,2)) 
               or not cd-cidade-ass         (substring(c-dados,154,6))  
               or not cd-especialidade-ass  (substring(c-dados,240,3),1,"N",1)
               or not cd-especialidade-ass  (substring(c-dados,243,3),2,"N",1)
               then assign tp-anterior = 0.
             end.
                    
        when "2"
        then if not cd-especialidade-ass  (substring(c-dados,4,3),1,substring(c-dados,7,1),2)
             or not cd-vinculo-ass        (substring(c-dados,2,2))  
             then assign tp-anterior = 0.

        when "3"
        then if not cd-cidade-ass         (substring(c-dados,57,6))  
             then assign tp-anterior = 0.

      end case.
      /* -------------------------------------------------------------------- */
      case substring(c-dados,1,1):
         when "1"
         then do:
                 if   tp-anterior <> 0
                 then run imprime-prestador.

                 empty temp-table wk-reg2.
                 empty temp-table wk-reg3.
                 empty temp-table wk-reg4.
                 empty temp-table wk-reg5.
                 empty temp-table wk-reg6.
                 
                 assign tp-anterior = 1.

                 assign c-cd-unidade = int(substring(c-dados,2,4)).

                 /* -------------- GERACAO AUTOMATICA DO COD.DO PRESTADOR --- */
                 if   not lg-codigo-ptu-aux
                 or   int(substring(c-dados,6,8)) = 0
                 then do:

                        find first preserv
                             where preserv.cd-unidade = c-cd-unidade
                               and preserv.nr-cgc-cpf = substring(c-dados,272,19)
                                   no-lock no-error.

                        if   avail preserv
                        then do:
                               /* Verifica se nao existe mais de um prestador com mesmo cpf/cnpj na mesma unidade */
                               find first b-preserv
                                    where b-preserv.nr-cgc-cpf    = preserv.nr-cgc-cpf
                                      and b-preserv.cd-unidade    = preserv.cd-unidade 
                                      and b-preserv.cd-prestador <> preserv.cd-prestador
                                    no-lock no-error.
                                                 
                               if   avail b-preserv 
                               then do:

                                      assign c-cd-prestador   = 0
                                             c-nm-prestador   = substring(c-dados,1178,70)
                                             c-nome-abrev     = substring(c-dados,54,12)  
                                             c-in-tipo-pessoa = substring(c-dados,66,1)
                                             c-cgc-cpf        = substring(c-dados,272,19)
                                             c-nm-fantasia    = substring(c-dados,1138,40).                                

                                      create wk-erros.
                                      assign wk-erros.cd-tipo-erro = "E"
                                             wk-erros.cd-tipo-regs = 1
                                             wk-erros.ds-desc      = "Existe mais de um prestador cadastrado com CPF/CNPJ do arquivo "
                                                                   + " Unidade: "   + string(preserv.cd-unidade)
                                                                   + " Prestador: " + string(preserv.cd-prestador).
                                      
                                      run gera-relat-erro (2,"").
                                      assign lg-erro-aux = yes.

                                      if   not lg-importacao-total /* NÆo importa parcial */
                                      then return.
                                      else do:
                                             assign tp-anterior = 0.
                                             next.
                                           end.
                                    end.

                               assign c-cd-prestador = preserv.cd-prestador.

                               if  (    substring(c-dados,204,02) = "00"
                                    and substring(c-dados,202,02) = "00"
                                    and substring(c-dados,206,04) = "0000"
                                   )
                               or  (    substring(c-dados,204,02) = "  "
                                    and substring(c-dados,202,02) = "  "
                                    and substring(c-dados,206,04) = "    "
                                   )
                               then assign in-movto-aux = 2. /* ALTERACAO */
                               else assign in-movto-aux = 3. /* EXCLUSAO  */

                               run consiste-dados(input  yes,
                                                  output lg-erro-aux).

                               if   lg-erro-aux 
                               then do:
                                      if   not lg-importacao-total /* NÆo importa parcial */
                                      then return.
                                      else do:
                                             assign tp-anterior = 0.
                                             next.
                                           end.
                                    end.
                             end.
                        else do:
                               assign in-movto-aux = 1. /* INCLUSAO */
                               
                               /*----- CRIAR CODIGO PARA O PRESTADOR -----*/
                               find last preserv
                                   where preserv.cd-unidade = c-cd-unidade
                                         no-lock no-error.
                               
                               if   avail preserv
                               then do:
                                      
                                      if   preserv.cd-prestador >= 99999999 
                                      then do:
                                             assign c-cd-prestador   = 0
                                                    c-nm-prestador   = substring(c-dados,1178,70)
                                                    c-nome-abrev     = substring(c-dados,54,12)  
                                                    c-in-tipo-pessoa = substring(c-dados,66,1)
                                                    c-cgc-cpf        = substring(c-dados,272,19)
                                                    c-nm-fantasia    = substring(c-dados,1138,40).                             

                                             run gera-relat-erro(1, "Codigo prestador nao pode ser maior "
                                                                  + "que 99999999 " 
                                                                  + "na unidade "   + string(c-cd-unidade)).
                                      
                                             assign lg-erro-geral = yes.
                                             return.
                                           end.

                                      assign c-cd-prestador = preserv.cd-prestador + cont-aux.
                                    end.
                               else assign c-cd-prestador = 1.
                               

                               assign cont-aux = cont-aux + 1.
                             end.
                      end.
                 /* ------- ASSUMIR COD.DO PRESTADOR DO ARQ.DE IMPORTACAO --- */
                 else do:
                        assign c-cd-prestador = int(substring(c-dados,6,8)).

                        find first preserv
                             where preserv.cd-unidade   = c-cd-unidade  
                               and preserv.cd-prestador = c-cd-prestador
                                   no-lock no-error.

                        if avail preserv
                        then do:
                               if  (    substring(c-dados,204,02) = "00"
                                    and substring(c-dados,202,02) = "00"
                                    and substring(c-dados,206,04) = "0000"
                                   )
                               or  (    substring(c-dados,204,02) = "  "
                                    and substring(c-dados,202,02) = "  "
                                    and substring(c-dados,206,04) = "    "
                                   )
                               then assign in-movto-aux = 2. /* ALTERACAO */
                               else assign in-movto-aux = 3. /* EXCLUSAO  */
                                      
                               run consiste-dados(input  no,
                                                  output lg-erro-aux).

                               if   lg-erro-aux 
                               then do:
                                      if   not lg-importacao-total /* NÆo importa parcial */
                                      then return.
                                      else do:
                                             assign tp-anterior = 0.
                                             next.
                                           end.
                                    end.
                             end.
                        else assign in-movto-aux = 1. /* INCLUSAO */
                      end.
                 
                 create tmp-movto-prestador.
                 assign tmp-movto-prestador.cd-unidade   = c-cd-unidade  
                        tmp-movto-prestador.cd-prestador = c-cd-prestador
                        tmp-movto-prestador.in-movto     = in-movto-aux.

                 /* --------------------------------------------------------- */
                 assign c-nm-prestador       = substring(c-dados,1178,70)
                        c-nome-abrev         = substring(c-dados,54,12)
                        c-in-tipo-pessoa     = substring(c-dados,66,1)
                        c-cd-grupo-prestador = cd-grupo-prestador-aux
                        c-nm-fantasia        = substring(c-dados,1138,40).                                

                 if substring(c-dados,69,1) = "S"
                 then c-lg-medico = true.
                 else c-lg-medico = false.
               
                 if substring(c-dados,70,1) = "S"
                 then c-lg-cooperado = true.
                 else c-lg-cooperado = false.
               
                 assign c-cd-unidade-seccional = int(substring(c-dados,71,4))
                        c-cd-conselho          =     substring(c-dados,75,5)
                        c-cd-uf-conselho       =     substring(c-dados,80,2)
                        c-nr-registro          = int(substring(c-dados,82,8))
                        c-cd-magnus            = int(substring(c-dados,90,9))
                        c-en-rua               =     substring(c-dados,99,40)
                        c-en-bairro            =     substring(c-dados,139,15)
                        c-cd-cidade            = cd-cidade-aux
                        c-en-cep               =     substring(c-dados,160,8)
                        c-en-uf                =     substring(c-dados,168,2)
                        c-nr-telefone[1]       =     substring(c-dados,982,20)
                        c-nr-telefone[2]       =     substring(c-dados,1002,20)
                        c-dt-inclusao          = date(int(substring(c-dados,196,02)),
                                                      int(substring(c-dados,194,02)),
                                                      int(substring(c-dados,198,04))).

                 if  (substring(c-dados,204,02) = "00"
                 and  substring(c-dados,202,02) = "00"
                 and  substring(c-dados,206,04) = "0000")
                 or  (substring(c-dados,204,02) = "  "
                 and  substring(c-dados,202,02) = "  "
                 and  substring(c-dados,206,04) = "    ")
                 then c-dt-exclusao = ?.
                 else c-dt-exclusao = date(int(substring(c-dados,204,02)),
                                           int(substring(c-dados,202,02)),
                                           int(substring(c-dados,206,04))).

                 if substring(c-dados,210,1)= "M"
                 then c-lg-sexo             = true.
                 else c-lg-sexo             = false.

                 assign c-dt-nascimento    = date(int(substring(c-dados,213,02)),
                                                  int(substring(c-dados,211,02)),
                                                  int(substring(c-dados,215,04)))
                        c-cd-insc-unimed   = int(substring(c-dados,219,4))
                        c-cd-situac-sindic = substring(c-dados,223,2).

                 assign c-qt-produtividade  = dec(substring(c-dados,225,12)) / 100 no-error.
                 
                 if substring(c-dados,237,1)= "S"
                 then c-lg-alvara = true.
                 else c-lg-alvara = false.
                
                 if substring(c-dados,238,1) = "S"
                 then c-lg-registro = true.
                 else c-lg-registro = false.
                
                 if substring(c-dados,239,1) = "S"
                 then c-lg-diploma = true.
                 else c-lg-diploma = false.

                 assign c-cd-esp-resid  = cd-especialidade1-aux
                        c-cd-esp-titulo = cd-especialidade2-aux.

                 if substring(c-dados,246,1) = "S"
                 then c-lg-malote = true.
                 else c-lg-malote = false.
                
                 if substring(c-dados,247,1) = "S"
                 then c-lg-vinc-empreg = true.
                 else c-lg-vinc-empreg = false.
             
                 assign c-nr-ult-inss = int(substring(c-dados,248,6))
                        c-nr-ramal[1] =     substring(c-dados,262,05)
                        c-nr-ramal[2] =     substring(c-dados,267,05)
                        c-cgc-cpf     =     substring(c-dados,272,19).

                 if substring(c-dados,291,1)  = "S"
                 then c-lg-representa-unidade = true.
                 else c-lg-representa-unidade = false.

                 c-cd-tab-urge               = int(substring(c-dados,292,2)).
                 
                 if substring(c-dados,294,1) = "S"
                 then c-lg-recolhe-inss = true.
                 else c-lg-recolhe-inss = false.

                 if substring(c-dados,295,1) = "S"
                 then c-lg-recolhe-participa = true.
                 else c-lg-recolhe-participa = false.

                 c-ds-observacao             = substring(c-dados,296,228).
                 
                 if substring(c-dados,524,1) = "S"
                 then c-calc-irrf = true.
                 else c-calc-irrf = false.

                 c-incidir-irrf              = int(substring(c-dados,525,2)).  
                 
                 if substring(c-dados,533,1) = "S"
                 then c-lg-calcula-adto = true.
                 else c-lg-calcula-adto = false.


                 if  (substring(c-dados,536,02) = "00"
                 and  substring(c-dados,534,02) = "00"
                 and  substring(c-dados,538,04) = "0000")
                 or  (substring(c-dados,536,02) = "  "
                 and  substring(c-dados,534,02) = "  "
                 and  substring(c-dados,538,04) = "    ")
                 then c-dt-calculo-adto = ?.
                 else c-dt-calculo-adto = date(int(substring(c-dados,536,02)),
                                               int(substring(c-dados,534,02)),
                                               int(substring(c-dados,538,04))).

                 c-nr-dependentes           = int(substring(c-dados,542,2)).
                 
                 if substring(c-dados,544,1) = "S"
                 then c-lg-pagamento-rh = true.
                 else c-lg-pagamento-rh = false.
                
                 c-nm-email                 = substring(c-dados,545,50).
                 c-cd-tipo-fluxo            = substring(c-dados,595,12).
                 c-cd-imposto               = substring(c-dados,607,5).
                 c-cd-classificacao-imposto = substring(c-dados,612,5).
                 c-nr-pis-pasep             = dec(substring(c-dados,617,11)).
                 c-nr-inscricao-inss        =     substring(c-dados,628,14).

                 if substring(c-dados,642,1) = "S"
                 then assign c-lg-divisao-honorario = true.
                 else assign c-lg-divisao-honorario = false.

                 if substring(c-dados,643,1) = "S"
                 then c-calc-cofins = true.
                 else c-calc-cofins = false.

                 if substring(c-dados,644,1) = "S"
                 then c-calc-pispasep = true.
                 else c-calc-pispasep = false.

                 if substring(c-dados,645,1) = "S"
                 then c-calc-csll = true.
                 else c-calc-csll = false.
                 
                 if substring(c-dados,686,1) = "S"
                 then c-calc-iss = true.
                 else c-calc-iss = false.

                 if substring(c-dados,697,1) = "S"
                 then c-deduz-iss = true.
                 else c-deduz-iss = false.

                 assign c-cd-cofins                 = substring(c-dados,646,5)
                        c-cd-classificacao-cofins   = substring(c-dados,661,5)
                        c-cd-pispasep               = substring(c-dados,651,5)
                        c-cd-classificacao-pispasep = substring(c-dados,666,5)
                        c-cd-csll                   = substring(c-dados,656,5)
                        c-cd-classificacao-csll     = substring(c-dados,671,5)
                        c-cd-inss                   = substring(c-dados,676,5)
                        c-cd-classificacao-inss     = substring(c-dados,681,5)
                        c-cd-iss                    = substring(c-dados,687,5)
                        c-cd-classificacao-iss      = substring(c-dados,692,5)
                        c-nr-dias-validade          = int(substring(c-dados,698,3))
                        c-portador                  = int(substring(c-dados,701,5))
                        c-modalidade                = int(substring(c-dados,706,1))
                        c-cd-banco                  = int(substring(c-dados,707,3))
                        c-agencia                   = substring(c-dados,710,8)
                        c-conta-corren              = substring(c-dados,718,20)
                        c-agencia-digito            = substring(c-dados,738,2)
                        c-conta-corren-digito       = substring(c-dados,740,2)
                        c-forma-pagto               = substring(c-dados,742,3).

                 assign c-retem-proc = substring(c-dados,745,1).
                 assign c-retem-insu = substring(c-dados,746,1).
                   
                 if substring(c-dados,747,1) = "S"
                 then c-calc-imposto-unico = true.
                 else c-calc-imposto-unico = false.
                 
                 assign c-cd-imposto-unico       = substring(c-dados,748,5)
                        c-cd-clas-imposto-unico  = substring(c-dados,753,5)
                        c-cd-tipo-classif-estab  = substring(c-dados,758,1)
                        c-cd-cnes                = int(substring(c-dados,759,7))
                        c-nm-diretor-tecnico     = substring(c-dados,766,40)
                        c-nr-crm-dir-tecnico     = substring(c-dados,806,8)
                        c-cd-registro-ans        = int(substring(c-dados,814,6)).

                 if   substring(c-dados,820,8) <> "00000000"
                 and  substring(c-dados,820,8) <> "        "
                 then c-dt-inicio-contratual   = date(substring(c-dados,820,8)).
                 else c-dt-inicio-contratual   = ?.

                 if substring(c-dados,1023,1)   = "S"
                 then c-lg-cooperativa         = true.
                 else c-lg-cooperativa         = false. 

                 /* dados ans */
                 if substring(c-dados,66,1)   = "F"
                 then do:
                        assign c-ds-natureza-doc-ident  = substring(c-dados,828,40)
                               c-nr-doc-ident           = substring(c-dados,868,14)
                               c-ds-orgao-emissor-ident = substring(c-dados,882,30)
                               c-nm-pais-emissor-ident  = substring(c-dados,912,20)
                               c-uf-emissor-ident       = substring(c-dados,932,2)
                               c-ds-nacionalidade       = substring(c-dados,942,40).
                        
                        if   substring(c-dados,934,8) <> "00000000"
                        and  substring(c-dados,934,8) <> "        "
                        then c-dt-emissao-doc-ident = date(substring(c-dados,934,8)). 
                        else c-dt-emissao-doc-ident = ?. 
                      end.

                 /* Tipo Disponibilidade do Servico */
                 assign c-tp-disponibilidade = int(substring(c-dados,1022,1)).

                 /* -------------- Rede Acidente Trabalho ---------------------------------- */
                 if substr(c-dados,1024,1) = "S"
                 then assign c-lg-acid-trab = yes. 
                 else assign c-lg-acid-trab = no.
                 
                 /* -------------- Pratica Tabela Propria ---------------------------------- */
                 if substr(c-dados,1025,1) = "S"
                 then assign c-lg-tab-propria = yes. 
                 else assign c-lg-tab-propria = no.
                 
                 /* -------------- Perfil Assistencial ------------------------------------- */
                 assign c-in-perfil-assistencial = int(substr(c-dados,1026,2)).
                 
                 /* -------------- Tipo Produto -------------------------------------------- */
                 assign c-in-tipo-prod-atende = int(substr(c-dados,1028,1)).

                 /* -------------- Guia Medico --------------------------------------------- */
                 if substr(c-dados,1029,1) = "S" 
                 then assign c-lg-guia-medico-aux = yes.
                 else assign c-lg-guia-medico-aux = no.

                 /* --------------------- DADOS DO DIRETOR TECNICO ------------------------- */
                 assign c-cd-conselho-dir-tec = trim(substr(c-dados,1030,12))
                        c-nr-conselho-dir-tec = trim(substr(c-dados,1042,15))
                        c-uf-conselho-dir-tec = trim(substr(c-dados,1057,02))
                        c-tp-rede             = int(trim(substr(c-dados,1059,01))).

                 /* -------------- Sistema NOTIVISA ---------------------------------------- */
                 if substr(c-dados,1060,1) = "S"
                 then assign c-lg-notivisa = yes.
                 else assign c-lg-notivisa = no.
                 
                 /* -------------- Sistema QUALISS ----------------------------------------- */
                 if substr(c-dados,1061,1) = "S"
                 then assign c-lg-qualiss = yes.
                 else assign c-lg-qualiss = no.
                 
                 /* -------------- Nr. Registro Especialista 1 ----------------------------- */
                 /*assign c-nr-registro1 = dec(substr(c-dados,1062,10)).*/

                 /* -------------- Nr. Registro Especialista 2 ----------------------------- */
                 assign c-nr-registro2 = dec(substr(c-dados,1072,10)).

                 /* -------------- Nr. Leitos Hospital-Dia --------------------------------- */
                 assign c-nr-leitos-hosp-dia = int(substr(c-dados,1082,6)).

                 /* -------------- Endereco Web -------------------------------------------- */
                 assign c-nm-end-web = substr(c-dados,1088,50).
                 
                 if substr(c-dados,1248,1) = "S"
                 then assign lg-publica-ans-aux = yes.
                 else assign lg-publica-ans-aux = no.

                 if substr(c-dados,1249,1) = "S"
                 then assign lg-indic-residencia-aux = yes.
                 else assign lg-indic-residencia-aux = no.

                 if substr(c-dados,1250,1) = "S"
                 then assign lg-login-wsd-tiss-aux = yes.
                 else assign lg-login-wsd-tiss-aux = no.

                 if substr(c-dados,1251,1) = "S"
                 then assign lg-cadu-aux = yes.
                 else assign lg-cadu-aux = no.
              end.      
         when "2"
         then do:
                 create wk-reg2.
                 assign wk-reg2.cd-vinculo    = cd-vinculo-aux.
                 assign wk-reg2.cd-especialid = cd-especialidade1-aux.

                 if substring(c-dados,7,1) = "S"
                 then assign wk-reg2.lg-principal = true.
                 else assign wk-reg2.lg-principal = false.
                 
                 if substring(c-dados,8,1) = "S"
                 then assign wk-reg2.lg-considera-qt-vinculo = true.
                 else assign wk-reg2.lg-considera-qt-vinculo = false.

                 assign wk-reg2.cd-registro-espec        = substring(c-dados,9,10)
                        wk-reg2.cd-registro-espec-2      = dec(substring(c-dados,21,10))
                        wk-reg2.cd-tipo-contratualizacao = substring(c-dados,19,1).

                 if substr(c-dados,20,1)  = "S"
                 then assign wk-reg2.lg-rce = yes.
                 else assign wk-reg2.lg-rce = no.

                 assign wk-reg2.in-tipo-especialidade = int(substring(c-dados,31,1))
                        wk-reg2.cd-tit-cert-esp       = int(substring(c-dados,32,3)).
              end.
         when "3"
         then do:
                 find last wk-reg3 no-lock no-error.
                 if   avail wk-reg3
                 then nr-seq-endereco-aux = wk-reg3.nr-seq-endereco + 1.
                 else nr-seq-endereco-aux = 1.

                 create wk-reg3.
                 assign wk-reg3.nr-seq-endereco   = nr-seq-endereco-aux
                        wk-reg3.en-endereco       = substring(c-dados,02,40)
                        wk-reg3.en-bairro         = substring(c-dados,42,15)
                        wk-reg3.cd-cidade         = cd-cidade-aux
                        wk-reg3.en-cep            = substring(c-dados,63,08)
                        wk-reg3.en-uf             = substring(c-dados,71,02)
                        wk-reg3.nr-fone [1]       = substring(c-dados,73,12)
                        wk-reg3.nr-fone [2]       = substring(c-dados,85,12)
                        wk-reg3.nr-ramal[1]       = substring(c-dados,97,05)
                        wk-reg3.nr-ramal[2]       = substring(c-dados,102,5)
                        wk-reg3.hr-man-ent        = substring(c-dados,107,4)
                        wk-reg3.hr-man-sai        = substring(c-dados,111,4)
                        wk-reg3.hr-tar-ent        = substring(c-dados,115,4)
                        wk-reg3.hr-tar-sai        = substring(c-dados,119,4).

                 if substring(c-dados,123,1) = "S"
                 then assign wk-reg3.lg-dias-trab[1] = true.
                 else assign wk-reg3.lg-dias-trab[1] = false.
                 assign wk-reg3.hr-man-ent-segunda = substring(c-dados,124,4)
                        wk-reg3.hr-man-sai-segunda = substring(c-dados,128,4)
                        wk-reg3.hr-tar-ent-segunda = substring(c-dados,132,4)
                        wk-reg3.hr-tar-sai-segunda = substring(c-dados,136,4).
                 if substring(c-dados,140,1) = "S"
                 then assign wk-reg3.lg-dias-trab[2] = true.
                 else assign wk-reg3.lg-dias-trab[2] = false.
                 assign wk-reg3.hr-man-ent-terca   = substring(c-dados,141,4)
                        wk-reg3.hr-man-sai-terca   = substring(c-dados,145,4)
                        wk-reg3.hr-tar-ent-terca   = substring(c-dados,149,4)
                        wk-reg3.hr-tar-sai-terca   = substring(c-dados,153,4).
                 if substring(c-dados,157,1) = "S"
                 then assign wk-reg3.lg-dias-trab[3] = true.
                 else assign wk-reg3.lg-dias-trab[3] = false.
                 assign wk-reg3.hr-man-ent-quarta  = substring(c-dados,158,4)
                        wk-reg3.hr-man-sai-quarta  = substring(c-dados,162,4)
                        wk-reg3.hr-tar-ent-quarta  = substring(c-dados,166,4)
                        wk-reg3.hr-tar-sai-quarta  = substring(c-dados,170,4).
                 if substring(c-dados,174,1) = "S"
                 then assign wk-reg3.lg-dias-trab[4] = true.
                 else assign wk-reg3.lg-dias-trab[4] = false.
                 assign wk-reg3.hr-man-ent-quinta  = substring(c-dados,175,4)
                        wk-reg3.hr-man-sai-quinta  = substring(c-dados,179,4)
                        wk-reg3.hr-tar-ent-quinta  = substring(c-dados,183,4)
                        wk-reg3.hr-tar-sai-quinta  = substring(c-dados,187,4).
                 if substring(c-dados,191,1) = "S"
                 then assign wk-reg3.lg-dias-trab[5] = true.
                 else assign wk-reg3.lg-dias-trab[5] = false.
                 assign wk-reg3.hr-man-ent-sexta   = substring(c-dados,192,4)
                        wk-reg3.hr-man-sai-sexta   = substring(c-dados,196,4)
                        wk-reg3.hr-tar-ent-sexta   = substring(c-dados,200,4)
                        wk-reg3.hr-tar-sai-sexta   = substring(c-dados,204,4).
                 if substring(c-dados,208,1) = "S"
                 then assign wk-reg3.lg-dias-trab[6] = true.
                 else assign wk-reg3.lg-dias-trab[6] = false.
                 assign wk-reg3.hr-man-ent-sabado  = substring(c-dados,209,4)
                        wk-reg3.hr-man-sai-sabado  = substring(c-dados,213,4)
                        wk-reg3.hr-tar-ent-sabado  = substring(c-dados,217,4)
                        wk-reg3.hr-tar-sai-sabado  = substring(c-dados,221,4).
                 if substring(c-dados,225,1) = "S"
                 then assign wk-reg3.lg-dias-trab[7] = true.
                 else assign wk-reg3.lg-dias-trab[7] = false.
                 assign wk-reg3.hr-man-ent-domingo = substring(c-dados,226,4)
                        wk-reg3.hr-man-sai-domingo = substring(c-dados,230,4)
                        wk-reg3.hr-tar-ent-domingo = substring(c-dados,234,4)
                        wk-reg3.hr-tar-sai-domingo = substring(c-dados,238,4).
                 if substring(c-dados,242,1) = "S"
                 then assign wk-reg3.lg-malote = true.
                 else assign wk-reg3.lg-malote = false.
                 if substring(c-dados,243,1) = "S"
                 then assign wk-reg3.lg-recebe-corresp = true.
                 else assign wk-reg3.lg-recebe-corresp = false.
                 assign wk-reg3.in-tipo-endereco    = int(substring(c-dados,244,1))
                        wk-reg3.cd-cnes             = int(substring(c-dados,245,7))
                        wk-reg3.nr-leitos-tot       = substring(c-dados,252,6)
                        wk-reg3.nr-leitos-contrat   = substring(c-dados,258,6)
                        wk-reg3.nr-leitos-psiquiat  = substring(c-dados,264,6)
                        wk-reg3.nr-uti-adulto       = substring(c-dados,270,6)
                        wk-reg3.nr-uti-neonatal     = substring(c-dados,276,6)
                        wk-reg3.nr-uti-pediatria    = substring(c-dados,282,6)
                        wk-reg3.nr-uti-neo-interm-neo  = substring(c-dados,323,6)
                        wk-reg3.nr-cgc-cpf          = substring(c-dados,304,19).
                 if substring(c-dados,303,1) = "S"
                 then assign wk-reg3.lg-filial = yes.
                 else assign wk-reg3.lg-filial = no.
                 
                 assign wk-reg3.nm-end-web                   = substring(c-dados,329,50)
                        wk-reg3.nr-leitos-hosp-dia           = int(substring(c-dados,379,06))              
                        wk-reg3.nr-leitos-tot-psic-n-uti     = int(substring(c-dados,385,06))              
                        wk-reg3.nr-leitos-tot-cirur-n-uti    = int(substring(c-dados,391,06))              
                        wk-reg3.nr-leitos-tot-ped-n-uti      = int(substring(c-dados,397,06))              
                        wk-reg3.nr-leito-tot-obst-n-uti      = int(substring(c-dados,403,06))              
                        wk-reg3.nm-latitue                   = substring(c-dados,409,20)              
                        wk-reg3.nm-longitude                 = substring(c-dados,429,20)
                        wk-reg3.nr-uti-neo-interm            = substring(c-dados,449,06).
              end.
         when "4"
         then do:
                create wk-reg4.
                assign wk-reg4.cod-instit = substring(c-dados,2,5)
                       wk-reg4.cdn-nivel  = int(substr(c-dados,7,1))
                       wk-reg4.cd-seq-end = int(substr(c-dados,9,2)).

                if substring(c-dados,8,1) = "S"
                then assign wk-reg4.lg-autoriz-divulga = yes.
                else assign wk-reg4.lg-autoriz-divulga = no.
              end.
         when "5"
         then do:
                create wk-reg5.
                assign wk-reg5.divulga-obs = trim(substring(c-dados,2,length(trim(c-dados)) - 1)).
              end.
         when "6"
         then do:
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

              end.
     end case.
   end.


   if tp-anterior <> 0
   then run imprime-prestador.
   
   input  stream s-import close.
   output stream s-export close.

   
end procedure.
*/

/* -----------------------------------------------------------------------------
------ monta o nome do arquivo de manobra, considerando o nome do arquivo ------
------ original substituindo sua extensao por uma string sequencial no formato -
------ XXX (a sequencia eh para que nunca seja sobreposto um arquivo ja --------
------ existente, para uma possivel verificacao no caso de inconsistencias) ----
-------------------------------------------------------------------------------- */
/* MIGRACAO NAO USA ESSE TRECHO.
procedure monta-nome-arq-serious:
   def var ix-ponto as int                                              no-undo.
   def var ix-seq   as int                                              no-undo.
   def var ext1     as int format "9" init 48                           no-undo.
   def var ext2     as int format "9" init 48                           no-undo.
   def var ext3     as int format "9" init 48                           no-undo.

   ix-ponto = index(nm-arquivo-importar,".",ix-ponto + 1).
   if ix-ponto = 0
   then do:
           nm-arquivo-importar = nm-arquivo-importar + ".".
           ix-ponto            = index(nm-arquivo-importar,".",ix-ponto + 1).
        end.
   repeat:
      if index(nm-arquivo-importar,".",ix-ponto + 1) = 0
      then leave.
      ix-ponto = index(nm-arquivo-importar,".",ix-ponto + 1).
   end.
   ix-seq = 1.

   nm-arquivo-serious-gerar = substring(nm-arquivo-importar,1,ix-ponto)
                            + string(keylabel(ext1)
                            + keylabel(ext2)
                            + keylabel(ext3)). 

   if search(nm-arquivo-serious-gerar) <> ?
   then do:
           repeat:
              run proxima-extensao(input-output ext1,
                                   input-output ext2,
                                   input-output ext3).
              nm-arquivo-serious-gerar = 
                 substring(nm-arquivo-importar,1,ix-ponto) + 
                                     string(keylabel(ext1) +     
                                            keylabel(ext2) + 
                                            keylabel(ext3)). 
              if search(nm-arquivo-serious-gerar) = ?
              then leave.
           end.
        end.
end procedure.
*/

procedure proxima-extensao:
  def input-output parameter ext1-par as int                            no-undo.
  def input-output parameter ext2-par as int                            no-undo.
  def input-output parameter ext3-par as int                            no-undo.

  ext3-par = ext3-par + 1.

  if ext3-par = 58
  then ext3-par = 97.
  else if ext3-par = 123
       then assign ext3-par = 48
                   ext2-par = ext2-par + 1.

  if ext2-par = 58
  then ext2-par = 97.
  else if ext2-par = 123
       then assign ext2-par = 48
                   ext1-par = ext1-par + 1.

  if ext1-par = 58
  then ext1-par = 97.
  else if ext1-par = 123
       then assign ext1-par = 48.

end procedure.

/* --------------------------- Consiste os Dados do Arquivo de Importacao --- */
/* MIGRACAO NAO USA ESSE TRECHO.
procedure consiste-linha-registro:

    assign lg-erro-linha = no.
         
    /* ------ tabelas associativas ------------------------------------------ */

    case substring(c-dados,1,1):
      when "1"
      then do:
                /* --------------------------- Consiste Codigo da Unidade --- */
                run consiste-numerico(  input substring(c-dados,2,4)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Unidade ("
                                                     + substring(c-dados,002,04)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.
                 
                /* ------------------------- Consiste codigo do prestador --- */
                if length(trim(substring(c-dados,6,8))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,6,8)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Codigo Prestator ("
                                                             + substring(c-dados,6,8)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                            end.
                    end.

                /* --------------------------- Consiste nome do prestador --- */
                if length(trim(substring(c-dados,1178,70))) = 0
                then
                    do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Nome Prestador ("
                                                     + substring(c-dados,1178,70)
                                                     + ") deve ser informado".
                        assign lg-erro-linha = yes.
                    end.

                /* ----------------- Consiste nome abreviado do prestador --- */
                if length(trim(substring(c-dados,54,12))) = 0
                then
                    do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Nome Abreviado Prestador ("
                                                     + substring(c-dados,54,12)
                                                     + ") deve ser informado".
                        assign lg-erro-linha = yes.
                    end.

                /* ----------------- Consiste indicador do tipo de pessoa --- */
                if  caps(substring(c-dados,66,1)) <> "F"
                and caps(substring(c-dados,66,1)) <> "J"
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Tipo Pessoa ("
                                                     + substring(c-dados,66,1)
                                                     + ") nao corresponde a Pessoa"
                                                     + " (F)isica nem (J)uridica".
                        assign lg-erro-linha = yes.
                     end.
                     
                /* ----------------------------- Consiste Grupo Prestador --- */
                run consiste-numerico(  input substring(c-dados,67,2)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Grupo Prestador ("
                                                     + substring(c-dados,67,2)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.


                /* ----------------- Consiste codigo da unidade seccional --- */
                run consiste-numerico(  input substring(c-dados,71,4)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Unidade Seccional ("
                                                     + substring(c-dados,71,4)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.

                /* ----------------------------- Consiste numero Registro --- */
                if length(trim(substring(c-dados,82,8))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,82,8)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Numero Registro ("
                                                             + substring(c-dados,82,8)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                            end.
                    end.

                /* ------------------------ Consiste codigo de Fornecedor --- */
                if length(trim(substring(c-dados,90,9))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,90,9)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Codigo Fornecedor ("
                                                             + substring(c-dados,90,9)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                            end.
                    end.
                 
                /* ---------------------------- Consiste codigo da Cidade --- */
                if length(trim(substring(c-dados,154,6))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,154,6)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Codigo da Cidade ("
                                                             + substring(c-dados,154,6)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                            end.
                    end.

                /* ------------------------------- Consiste codigo do CEP --- */
                if length(trim(substring(c-dados,160,8))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,160,8)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Codigo do CEP ("
                                                             + substring(c-dados,160,8)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                            end.
                    end.

                /* ------------------ Consiste data inclusao do prestador --- */
                run consiste-data(  input substring(c-dados,194,08)
                                 , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data Inclusao ("
                                                     + substring(c-dados,194,08)
                                                     + ") nao e Data valida".
                        assign lg-erro-linha = yes.
                     end.

                /* ------------------ Consiste data exclusao do prestador --- */
                if  SUBSTR(c-dados,202,8) = "00000000"
                OR  SUBSTR(c-dados,202,8) = ""
                THEN.
                ELSE IF length(trim(substring(c-dados,202,08))) <> 0
                     THEN do:
                             run consiste-data(  input substring(c-dados,202,08)
                                              , output lg-erro-linha ) no-error.
                             if  error-status:error
                             or  lg-erro-linha
                             then do:
                                     create wk-erros.
                                     assign wk-erros.cd-tipo-erro = "E"
                                            wk-erros.cd-tipo-regs = 1
                                            wk-erros.ds-desc      
                                              = "Data Exclusao ("
                                              + substring(c-dados,202,08)
                                              + ") nao e Data valida".
                                     assign lg-erro-linha = yes.
                                  end.
                          END.

                /* ---------------- Consiste data nascimento do prestador --- */
                run consiste-data(  input substring(c-dados,211,08)
                                 , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data Nascimento ("
                                                     + substring(c-dados,211,08)
                                                     + ") nao e Data valida".
                        assign lg-erro-linha = yes.
                     end.
                    
                /* ----------------- Consiste Inscricao Prestador Unidade --- */
                if length(trim(substring(c-dados,219,4))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,219,4)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Inscricao Prestador Unidade ("
                                                             + substring(c-dados,219,4)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                            end.
                    end.

                /* ----------- Consiste Fator/Quantidade de Produtividade --- */
                if  length(trim(substring(c-dados,225,12))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,225,12)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Fator Produtividade ("
                                                             + substring(c-dados,225,12)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* -------------------- Consiste Especialidade Residencia --- */
                if  length(trim(substring(c-dados,240,3))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,240,3)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Especialidade Residencia ("
                                                             + substring(c-dados,240,3)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* ------------------------ Consiste Especialidade Titulo --- */
                if  length(trim(substring(c-dados,243,3))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,243,3)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Especialidade Titulo ("
                                                             + substring(c-dados,243,3)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* ----------------------------- Consiste Ultimo mes INSS --- */
                if  length(trim(substring(c-dados,248,6))) <> 0
                then
                    do:
                        run consiste-numerico( input substring(c-dados,248,6)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Ultimo mes INSS ("
                                                             + substring(c-dados,248,6)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.
                
                /* ------------------------- Consiste Horario de Urgencia --- */
                run consiste-numerico(  input substring(c-dados,292,2)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo do Horario de Urgencia ("
                                                     + substring(c-dados,292,2)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.
                
                /* -------------------------------- Consiste Indice IRRF --- */
                run consiste-numerico(  input substring(c-dados,525,2)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Indice IRRF ("
                                                     + substring(c-dados,525,2)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.
                
                /* ------------------ Consiste data calculo adiantamento --- */
                if length(trim(substring(c-dados,534,08))) <> 0
                then
                    do:
                        run consiste-data(  input substring(c-dados,534,08)
                                         , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                            do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Data Calculo Adiantamento ("
                                                             + substring(c-dados,534,08)
                                                             + ") nao e Data valida".
                                assign lg-erro-linha = yes.
                            end.
                    end.

                /* ------------------------- Consiste Numero Dependentes --- */
                if  length(trim(substring(c-dados,542,2))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,542,2)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Numero de Dependentes ("
                                                             + substring(c-dados,542,2)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.
                
                /* ------------------------- Consiste Numero PIS/PASEP --- */
                if  length(trim(substring(c-dados,617,11))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,617,11)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Numero PIS/PASEP ("
                                                             + substring(c-dados,617,11)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* --- TIPO DE CLASSIFICACAO DO ESTABELECIMENTO --- */
                if c-nr-ver-tra >= 8  /* Maior que PTU 2.9 */
                or lg-layout-serious-aux
                then do:
                       if  substring(c-dados,758,1) <> "1"
                       and substring(c-dados,758,1) <> "2"
                       and substring(c-dados,758,1) <> "3"
                       then do:
                              create wk-erros.
                              assign wk-erros.cd-tipo-erro = "E"
                                     wk-erros.cd-tipo-regs = 1
                                     wk-erros.ds-desc      = "Tipo Classif. Estabel. deve ser 1, 2 ou 3. Informado: "
                                                           + substring(c-dados,758,1).
                              assign lg-erro-linha = yes.
                            end.
                     end.



                /* --- DATA DE INICIO DA CONTRATUALIZACAO --- */

                if   substring(c-dados,820,8) <> "00000000"
                and  substring(c-dados,820,8) <> "        "
                then do:
                       run consiste-data(input substring(c-dados,820,8),
                                         output lg-erro-linha) no-error.
                       
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "A data de inicio da contratualizacao (" + substring(c-dados,820,8) + ")"
                                                            + " nao e uma data valida.".
                               assign lg-erro-linha = yes.
                            end.
                       else do:
                               if substring(c-dados,758,1) = "1"
                               or substring(c-dados,758,1) = "2"
                               then do:
                                       if date(substring(c-dados,820,8)) < 07/07/2003
                                       then do:
                                               create wk-erros.
                                               assign wk-erros.cd-tipo-erro = "E"
                                                      wk-erros.cd-tipo-regs = 1
                                                      wk-erros.ds-desc      = "A data de inicio da contratualizacao deve ser maior ou igual"
                                                                            + " a 07/07/2003. Informado: " + substring(c-dados,820,8).
                                               assign lg-erro-linha = yes.
                                            end.
                                    end.
                               else do:
                                       if date(substring(c-dados,820,8)) < 12/01/2003 
                                       then do:
                                               create wk-erros.
                                               assign wk-erros.cd-tipo-erro = "E"
                                                      wk-erros.cd-tipo-regs = 1
                                                      wk-erros.ds-desc      = "A data de inicio da contratualizacao deve ser maior ou igual"
                                                                            + " a 01/12/2003. Informado: " + substring(c-dados,820,8).
                                               assign lg-erro-linha = yes.
                                            end.
                                    end.
                            end.
                     end.

                /* --------------------- CONSISTE CNES --- */
                if   length(trim(substring(c-dados,759,7))) <> 0
                then do:
                       run consiste-numerico(  input trim(substring(c-dados,759,7))
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "CNES ("
                                                            + substring(c-dados,759,7)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.
                     
           
                /* ------------------------- Consiste Registro ANS --- */
                if  length(trim(substring(c-dados,814,6))) <> 0
                then do:
                        run consiste-numerico(  input substring(c-dados,814,6)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Registro ANS ("
                                                             + substring(c-dados,814,6)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                     end.

                /* ---- verifica data de emissao do doc de identificacao ---- */
                if  substring(c-dados,934,08) <> "00000000"
                and substring(c-dados,934,08) <> ""
                and substring(c-dados,66,1)   = "F"
                then do:
                       run consiste-data(input  substring(c-dados,934,08),
                                         output lg-erro-linha )
                                         no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data Emissao Doc.Ident. ("
                                                            + substring(c-dados,934,08)
                                                            + ") nao e Data valida".
                               assign lg-erro-linha = yes.
                            end.
                     end.

                /* ---- verifica tipo disponibilidade ---- */
                if   int(substr(c-dados,1022,1))   <> 0
                and  int(substr(c-dados,1022,1))   <> 1
                and  int(substr(c-dados,1022,1))   <> 2
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Tipo Disponibilidade ("
                                                    + substring(c-dados,1022,1)
                                                    + ") Invalido".
                       assign lg-erro-linha = yes.
                    end.

                /* -------------- Perfil Assistencial ------------------------------------- */

                if int(substr(c-dados,1026,2)) < 0
                or int(substr(c-dados,1026,2)) > 28
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Perfil Assist. do Hospital invalido"
                                                    + "(" + substring(c-dados,1026,2) + ")".
                       assign lg-erro-linha = yes.
                     end.

                /* -------------- Tipo Produto -------------------------------------------- */
                if int(substr(c-dados,1028,1)) < 0
                or int(substr(c-dados,1028,1)) > 3
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Tipo Produto invalido"
                                                    + "(" + substring(c-dados,1028,1) + ")".
                       assign lg-erro-linha = yes.
                     end.

                /* ------ TIPO DE REDE -------- */
                run consiste-numerico(input substring(c-dados,1059,01),
                                      output lg-erro-linha) no-error.

                if  error-status:error
                or  lg-erro-linha
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Tipo de Rede ("
                                                    + substring(c-dados,1059,01)
                                                    + ") nao Numerico".
                       assign lg-erro-linha = yes.
                     end.

                if int(substr(c-dados,1059,1)) < 0
                or int(substr(c-dados,1059,1)) > 3
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Tipo de Rede invalido"
                                                    + "(" + substring(c-dados,1059,1) + ")".
                       assign lg-erro-linha = yes.
                     end.
                
                /* ------------------------- Consiste Numero Reg. Especialista 1 --- */
                if  length(trim(substring(c-dados,1062,10))) <> 0
                then
                    do:
                        run consiste-numerico(input substring(c-dados,1062,10),
                                              output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Numero Registro Especialista 1 ("
                                                             + substring(c-dados,1062,10)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* ------------------------- Consiste Numero Reg. Especialista 2 --- */
                if  length(trim(substring(c-dados,1072,10))) <> 0
                then
                    do:
                        run consiste-numerico(input substring(c-dados,1072,10),
                                              output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Numero Registro Especialista 2 ("
                                                             + substring(c-dados,1072,10)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* ------------------------- Consiste Numero Leitos Hospital-dia --- */
                if  length(trim(substring(c-dados,1082,6))) <> 0
                then
                    do:
                        run consiste-numerico(input substring(c-dados,1082,6),
                                              output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Numero de Leitos Hospital-dia ("
                                                             + substring(c-dados,1082,6)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.
                
                /* ------------ Verifica se ocorreu algum erro na consistencia --- 
                --------------- da linha do registro ---------------------------- */
                find first wk-erros no-error.
                if avail wk-erros
                then do:
                       assign c-cd-unidade     = int(substring(c-dados,2,4))
                              c-cd-prestador   = int(substring(c-dados,6,8))
                              c-nm-prestador   = substring(c-dados,1178,70)
                              c-nome-abrev     = substring(c-dados,54,12)
                              c-in-tipo-pessoa = substring(c-dados,66,1)
                              c-cgc-cpf        = substring(c-dados,272,19)
                              c-nm-fantasia    = substring(c-dados,1138,40).                                

                       run gera-relat-erro (2,"").
                       assign lg-erro-geral = yes.
                     end.
           end.

      when "2"                                                     
      then do:             
                /* ----------------------------- Consiste Codigo Vinculo --- */
                run consiste-numerico(  input substring(c-dados,02,2)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Codigo Vinculo ("
                                                     + substring(c-dados,02,2)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.

                /* ----------------------- Consiste Codigo Especialidade --- */
                run consiste-numerico(  input substring(c-dados,04,3)
                                     , output lg-erro-linha ) no-error.
                if  error-status:error
                or  lg-erro-linha
                then  
                     do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Codigo Especialidade ("
                                                     + substring(c-dados,04,3)
                                                     + ") nao Numerico".
                        assign lg-erro-linha = yes.
                     end.

                /* --- CONSISTE TIPO DE CONTRATUALIZACAO --- */
                if  substring(c-dados,19,1) <> ""
                and substring(c-dados,19,1) <> "0"
                and substring(c-dados,19,1) <> "1"
                and substring(c-dados,19,1) <> "2"
                then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Tipo de contratualizacao deve ser 0, 1 ou 2. Informado:"
                                                     + substring(c-dados,19,1).
                        assign lg-erro-linha = yes.
                     end.

                /* ------------ Verifica se ocorreu algum erro na consistencia --- 
                --------------- da linha do registro ---------------------------- */
                find first wk-erros no-error.
                if avail wk-erros
                then do:
                        run gera-relat-erro (2,"").
                        assign lg-erro-geral = yes.
                     end.
           end.

      when "3"
      then do:
                /* ------------------------------ Consiste Codigo Cidade --- */
                if  length(trim(substring(c-dados,57,6))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,57,6)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then  
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 3
                                       wk-erros.ds-desc      = "Codigo Cidade ("
                                                             + substring(c-dados,57,6)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* --------------------------------- Consiste Codigo CEP --- */
                if  length(trim(substring(c-dados,63,8))) <> 0
                then
                    do:
                        run consiste-numerico(  input substring(c-dados,63,8)
                                             , output lg-erro-linha ) no-error.
                        if  error-status:error
                        or  lg-erro-linha
                        then
                             do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 3
                                       wk-erros.ds-desc      = "Codigo CEP ("
                                                             + substring(c-dados,63,8)
                                                             + ") nao Numerico".
                                assign lg-erro-linha = yes.
                             end.
                    end.

                /* --------------------- CONSISTE CNES --- */
                if   length(trim(substring(c-dados,245,7))) <> 0
                then do:
                       run consiste-numerico(  input trim(substring(c-dados,245,7))
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "CNES ("
                                                            + substring(c-dados,245,7)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.

                /* --------------------- CONSISTE NUMERO DE LEITOS --- */
                if   length(trim(substring(c-dados,252,6))) <> 0
                then do:
                       run consiste-numerico(  input substring(c-dados,252,6)
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Nr.Leitos Totais ("
                                                            + substring(c-dados,252,6)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.

                if   length(trim(substring(c-dados,258,6))) <> 0
                then do:
                       run consiste-numerico(  input substring(c-dados,258,6)
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Nr.Leitos Contratados ("
                                                            + substring(c-dados,258,6)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.

                if   length(trim(substring(c-dados,264,6))) <> 0
                then do:
                       run consiste-numerico(  input substring(c-dados,264,6)
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Nr.Leitos Psiquiatria ("
                                                            + substring(c-dados,264,6)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.


                if   length(trim(substring(c-dados,270,6))) <> 0
                then do:
                       run consiste-numerico(  input substring(c-dados,270,6)
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Nr.Leitos UTI Adulto ("
                                                            + substring(c-dados,270,6)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.
               
                if   length(trim(substring(c-dados,276,6))) <> 0
                then do:
                       run consiste-numerico(  input substring(c-dados,276,6)
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Nr.Leitos UTI Neonatal ("
                                                            + substring(c-dados,276,6)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.

                if   length(trim(substring(c-dados,282,6))) <> 0
                then do:
                       run consiste-numerico(  input substring(c-dados,282,6)
                                             , output lg-erro-linha ) no-error.
                       if  error-status:error
                       or  lg-erro-linha
                       then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Nr.Leitos UTI Pediatria ("
                                                            + substring(c-dados,282,6)
                                                            + ") nao Numerico".
                               assign lg-erro-linha = yes.
                            end.
                     end.

                /* ------------ Verifica se ocorreu algum erro na consistencia --- 
                --------------- da linha do registro ---------------------------- */
                find first wk-erros no-error.
                if avail wk-erros
                then do:
                        run gera-relat-erro (2,"").
                        assign lg-erro-geral = yes.
                     end.
           end.

      when "4"
      then do:
                /* ------------------------- Consiste Nivel de Acreditacao --- */
                if int(substr(c-dados,9,1)) < 0
                or int(substr(c-dados,9,1)) > 4
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Nivel de Acreditacao ("
                                                    + substring(c-dados,6,1)
                                                    + ") invalido.".
                       assign lg-erro-linha = yes.
                     end.
                
                /* ------------ Verifica se ocorreu algum erro na consistencia --- 
                --------------- da linha do registro ---------------------------- */
                find first wk-erros no-error.
                if avail wk-erros
                then do:
                        run gera-relat-erro (2,"").
                        assign lg-erro-geral = yes.
                     end.
           end.
        when "5"
        then do:
                /* --------------------------------- Consiste Prestador x Observacoes --- */
                if trim(substr(c-dados,5,10000)) = ""
                then do:
                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc      = "Observacoes nao Informada".
                       assign lg-erro-linha = yes.
                     end.
                /* ------------ Verifica se ocorreu algum erro na consistencia --- 
                --------------- da linha do registro ---------------------------- */
                find first wk-erros no-error.
                if avail wk-erros
                then do:
                        run gera-relat-erro (2,"").
                        assign lg-erro-geral = yes.
                     end.
             end.
        when "6"
        then do:
               /*------------------- Consiste cd-unidade prestador substituto ----------------------------*/
               run consiste-numerico(input  trim(substring(c-dados,2,4)),
                                     output lg-erro-linha ) no-error.
               if  error-status:error
               or  lg-erro-linha
               then do:
                      create wk-erros.
                      assign wk-erros.cd-tipo-erro = "E"
                             wk-erros.cd-tipo-regs = 1
                             wk-erros.ds-desc      = "Unidade Prestador Substituto ("
                                                   + substring(c-dados,2,4)
                                                   + ") nao Numerico".
                      assign lg-erro-linha = yes.
                    end.

               /*------------------- Consiste cd-prestador substituto ----------------------------*/
               run consiste-numerico(input  trim(substring(c-dados,6,8)),
                                     output lg-erro-linha ) no-error.
               if  error-status:error
               or  lg-erro-linha
               then do:
                      create wk-erros.
                      assign wk-erros.cd-tipo-erro = "E"
                             wk-erros.cd-tipo-regs = 1
                             wk-erros.ds-desc      = "Codigo Prestador Substituto ("
                                                   + substring(c-dados,6,8)
                                                   + ") nao Numerico".
                      assign lg-erro-linha = yes.
                    end.

               /*------------------- Consiste Data Inicio -------------------------*/
               if trim(substring(c-dados,14,08)) <> "00000000"
               then do: 
                      run consiste-data (input  substring(c-dados,14,08),
                                         output lg-erro-linha ) no-error.
                      if  error-status:error
                      or  lg-erro-linha
                      then do:
                              create wk-erros.
                              assign wk-erros.cd-tipo-erro = "E"
                                     wk-erros.cd-tipo-regs = 1
                                     wk-erros.ds-desc      = "Data Inicio Prestador Substituto ("
                                                           + substring(c-dados,14,08)
                                                           + ") nao e Data valida".
                              assign lg-erro-linha = yes.
                           end.
                    end.

               /*------------------- Consiste motivo exclusao ----------------------------*/
               run consiste-numerico(input  trim(substring(c-dados,22,2)),
                                     output lg-erro-linha ) no-error.
               if  error-status:error
               or  lg-erro-linha
               then do:
                      create wk-erros.
                      assign wk-erros.cd-tipo-erro = "E"
                             wk-erros.cd-tipo-regs = 1
                             wk-erros.ds-desc      = "Motivo de exclusao sem substituicao ("
                                                   + substring(c-dados,22,2)
                                                   + ") nao Numerico".
                      assign lg-erro-linha = yes.
                    end.
                    
               /* ------------ Verifica se ocorreu algum erro na consistencia --- 
               --------------- da linha do registro ---------------------------- */
               find first wk-erros no-error.
               if avail wk-erros
               then do:
                       run gera-relat-erro (2,"").
                       assign lg-erro-geral = yes.
                    end.
             end.
    end case.

end procedure.
*/
/* -------------------------------------------------------------------------- */
procedure consiste-dados:

    def input  parameter lg-gera-par        as log                 no-undo.  
    def output parameter lg-erro-par        as log                 no-undo.

    assign lg-erro-par      = no
           c-nm-prestador   = substring(c-dados,1178,70)
           c-nome-abrev     = substring(c-dados,54,12)
           c-in-tipo-pessoa = substring(c-dados,66,1)
           c-cgc-cpf        = substring(c-dados,272,19)
           c-nm-fantasia    = substring(c-dados,1138,40).                              

    if   preserv.in-tipo-pessoa = "F" 
    then do:
           if   preserv.nr-cgc-cpf     <> substring(c-dados,272,11) 
           and  preserv.cd-contratante <> 0 /* Esta integrado */
           and  lg-gera-par             = no /* Assume codigo do prestador do arquivo */
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "CPF/CNPJ prestador diferente no arquivo "
                                               + " Prestador: " + string(c-cd-prestador)
                                               + " Unidade: "   + string(c-cd-unidade).

                  run gera-relat-erro (2,"").
                  assign lg-erro-par = yes.
                end.
         end.
    else do:
           if   preserv.nr-cgc-cpf     <> substring(c-dados,272,14) 
           and  preserv.cd-contratante <> 0 /* Esta integrado */
           and  lg-gera-par             = no /* Assume codigo do prestador do arquivo */
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "CPF/CNPJ prestador diferente no arquivo "
                                               + " Prestador: " + string(c-cd-prestador)
                                               + " Unidade: "   + string(c-cd-unidade).

                  run gera-relat-erro (2,"").
                  assign lg-erro-par = yes.
                end.
         end.

/*    if   preserv.nm-prestador   <> substring(c-dados,1178,70)
    and  preserv.cd-contratante <> 0 /* Esta integrado */
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Nome do Prestador do arquivo esta "
                                        + "diferente do cadastro de prestadores".
          
           run gera-relat-erro (2,"").

           assign lg-erro-par = yes.
         end.
  */
    if   preserv.in-tipo-pessoa <> substring(c-dados,66,1)
    and  preserv.cd-contratante <> 0 /* Esta integrado */
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Tipo de Pessoa do arquivo esta "
                                        + "diferente do cadastro de prestadores".
           
           run gera-relat-erro (2,"").
           
           assign lg-erro-par = yes.
         end.

end procedure.

/* -------------------------------------------------------------------------- */
procedure imp-totais-tela:

    PROCESS EVENTS.

    if   c-opcao = "Consiste" 
    then assign ds-titulo-tela = "ESTATISTICAS DA CONSISTENCIA".
    else assign ds-titulo-tela = "ESTATISTICAS DA IMPORTACAO".

    display tt-prest-lidos
            tt-regs-gravados
            tt-prest-gravados
            tt-prest-erros
            tt-prest-aviso
            with frame f-totais-tela.

end procedure.

/* -------------------------------------------------------------------------- */
/* --- include com o procedimento que faz a geracao do layout serious ------- */
{cgp/cg0110l_mig.i1}
/* ------------------------------------------------------------------ EOF --- */


procedure processa-importacao-migracao:
  def var lg-erro-processo-prest as log init no no-undo.

  /*----- ABRE REL. DE ACERTOS -----*/
  if   c-opcao = "Importa"
  then do:
         {hdp/hdmonarq.i &stream = "stream s-acertos" &page-size = 64}
         view stream s-acertos frame f-cabec-acertos.
         view stream s-acertos frame f-rodape-acertos.
       end.

  empty temp-table wk-erros.
  empty temp-table wk-reg2.
  empty temp-table wk-reg3.
  empty temp-table wk-reg4.
  empty temp-table wk-reg5.

  /*----- ABRE ARQ. DE IMPORTACAO -----*/
  input stream s-import from value(nm-arquivo-importar).
 
  if   c-opcao = "Consiste" then do:
      repeat:
         /*----- IMPORTA O REGISTRO -----*/
         import stream s-import unformatted c-dados.
      
         /* --------------------- LINHAS EM BRANCO --- */
         if length(trim(c-dados)) = 0 
         then next. 
      
         /*----- PEGA VALORES ANTERIORES -----*/
         if   tp-registro <> 99
         then assign tp-anterior     = tp-registro
                     tp-ant-unid     = c-cd-unidade.
      
         assign tt-prest-erros-atual = tt-prest-erros
                tt-prest-aviso-atual = tt-prest-aviso.
      
         /*----- TESTA O TIPO DO REGISTRO -----*/
         assign tp-registro = int(substring(string(c-dados,"x(1023)"),1,1)).

         if   tp-registro <> 1
         and  tp-registro <> 2
         and  tp-registro <> 3
         and  tp-registro <> 4
         and  tp-registro <> 5
         then do:
                assign lg-erro-geral = yes.
                run gera-relat-erro (1,"Tipo de Registro Invalido - " +
                                       string(tp-registro,"9")).
                tp-registro = 99.
              end.

         if   tp-registro <> 99
         then do:
                /* - CASO TENHA OCORRIDO ERRO NO REGISTRO ANTERIOR, ENTAO NAO SERAO PROCESSADOS OS OUTROS REGISTROS DO MESMO PRESTADOR --- */
                if lg-erro-processo-prest
                then do:
                       if tp-registro = 1
                       then assign lg-erro-processo-prest = no.
                       else next.
                     end.

                if   tp-registro = 1
                then do:
                       assign nr-cgc-dzemit-aux = ""
                              c-nr-seq-endereco = 0.

                       if   lg-layout-serious-aux
                       then tt-prest-lidos = tt-prest-lidos + 1.

                     end.


                run consiste-migracao.


    /*             /*----- VERIFICA SE PRIMEIRO REGISTRO -----*/                 */
    /*             if   tp-registro = 1                                          */
    /*             and  tp-anterior <> 0                                         */
    /*             then do:                                                      */
    /*                    assign c-nr-seq-endereco = 0.                          */
    /*                                                                           */
    /*                    /*--- IMPORTA DADOS DOS REGISTROS (SE TUDO OK) ----*/  */
    /*                    if   c-opcao = "Importa"                               */
    /*                    and  not lg-erro-geral                                 */
    /*                    then do:                                               */
    /*                           assign lg-erro-imp-aux = no.                    */
    /*                                                                           */
    /*                           run importa-prestador.                          */
    /*                                                                           */
    /*                           if not lg-erro-imp-aux                          */
    /*                           then run gera-relat-acertos.                    */
    /*                         end.                                              */
    /*                                                                           */
    /*                    /*----- APAGA TEMP DE ERROS, REG2, REG3 e REG4 -----*/ */
    /*                    assign lg-erro-geral = no.                             */
    /*                                                                           */
    /*                    empty temp-table wk-erros.                             */
    /*                    empty temp-table wk-reg2.                              */
    /*                    empty temp-table wk-reg3.                              */
    /*                    empty temp-table wk-reg4.                              */
    /*                    empty temp-table wk-reg5.                              */
    /*                                                                           */
    /*                  end.                                                     */

    /*             /*----- INICIA VERIFICACAO DE UM NOVO REGISTRO -----*/       */
    /*             assign lg-erro = no.                                         */
    /*                                                                          */
    /*             find first tmp-movto-prestador                               */
    /*                  where tmp-movto-prestador.cd-unidade   = c-cd-unidade   */
    /*                    and tmp-movto-prestador.cd-prestador = c-cd-prestador */
    /*                        no-lock no-error.                                 */
    /*                                                                          */
    /*             if avail tmp-movto-prestador                                 */
    /*             then assign in-movto-aux = tmp-movto-prestador.in-movto.     */

    /*             if  (tp-registro = 1 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */
    /*             or  (tp-registro = 3 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */
    /*             or  (tp-registro = 4 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */
    /*             or  (tp-registro = 5 and tp-anterior = 1 and in-movto-aux = 1 /*INCLUSAO*/ )                  */
    /*             then assign lg-erro       = yes                                                               */
    /*                         lg-erro-geral = yes.                                                              */
    /*                                                                                                           */
    /*             if   lg-erro                                                                                  */
    /*             then do:                                                                                      */
    /*                    create wk-erros.                                                                       */
    /*                    assign wk-erros.cd-tipo-erro = "E"                                                     */
    /*                           wk-erros.cd-tipo-regs = 1                                                       */
    /*                           wk-erros.ds-desc = "Faltando Registro do Prestador X Vinculo X Especialidade.". */
    /*                    /* "Faltando Registro do "  +                                                          */
    /*                                              "Prestador X Vinculo X " +                                   */
    /*                                              "Especialidade.". */                                         */
    /*                                                                                                           */
    /*                                                                                                           */
    /*                                                                                                           */
    /*                    run gera-relat-erro (2,"").                                                            */
    /*                    assign lg-erro-aux = yes.                                                              */
    /*                  end.                                                                                     */
                lg-erro = no.

                if  (tp-registro = 2 and tp-anterior = 3)
                or  (tp-registro = 2 and tp-anterior = 0)
                then assign
                     lg-erro       = yes
                     lg-erro-geral = yes.

                if   lg-erro
                then do:

                       create wk-erros.
                       assign wk-erros.cd-tipo-erro = "E"
                              wk-erros.cd-tipo-regs = 1
                              wk-erros.ds-desc = "Faltando Registro do Prestador.".
                       run gera-relat-erro (2,"").
                       assign lg-erro-aux = yes.

                       assign c-nm-prestador   = "PRESTADOR NAO ENCONTRADO"
                              c-cd-unidade     = 0
                              c-cd-prestador   = 0
                              c-nome-abrev     = ""
                              c-cgc-cpf        = ""
                              c-cd-magnus      = 0
                              c-in-tipo-pessoa = "".
                     end.

                /*----- CONSISTE DADOS DO REGISTRO -----*/
                assign lg-erro  = no
                       lg-aviso = no.

                empty temp-table wk-reg2.
                empty temp-table wk-reg3.
                empty temp-table wk-reg4.
                empty temp-table wk-reg5.

                run cgp/cg0111l_mig.p (tp-registro).

                find first wk-erros no-error.

                RUN escrever-log("########VOLTANDO DE CG0111L_MIG###############c-cd-unidade: " + STRING(c-cd-unidade) +
                                 " c-cd-prestador: "      + STRING(c-cd-prestador) +
                                 " c-nm-prestador: "      + STRING(c-nm-prestador) +
                                 " c-nome-abrev: "        + STRING(c-nome-abrev) +
                                 " c-in-tipo-pessoa: "    + STRING(c-in-tipo-pessoa) +
                                 " c-cgc-cpf: "           + STRING(c-cgc-cpf) +
                                 " c-nr-inscricao-inss: " + STRING(c-nr-inscricao-inss) +
                                 " ####AVAIL WK-ERROS?: " + string(AVAIL wk-erros) +
                                 " lg-erro: "             + STRING(lg-erro) +
                                 " lg-aviso: "            + STRING(lg-aviso)).

                if   lg-erro
                or   lg-aviso
                then do:
                       if   lg-erro
                       then assign lg-erro-geral = yes.

                       if avail wk-erros
                       then run gera-relat-erro (2,"").
                     end.
              end.

         /*----- MOSTRAR TOTAIS -----*/
         run imp-totais-tela.

         /* CASO TENHA OCORRIDO ERRO NA LEITURA DE UM TIPO DE REGISTRO, NAO SERAO PROCESSADOS OS PROXIMOS DO MESMO PRESTADOR --- */
         if lg-erro-geral
         then assign lg-erro-processo-prest = yes.
      
      end. /* repeat */
  
  end.

  /*----- LACO PARA CONSISTENCIA -----*/
  

  
/*   find first tmp-movto-prestador                               */
/*        where tmp-movto-prestador.cd-unidade   = c-cd-unidade   */
/*          and tmp-movto-prestador.cd-prestador = c-cd-prestador */
/*              no-lock no-error.                                 */
/*                                                                */
/*   if avail tmp-movto-prestador                                 */
/*   then assign in-movto-aux = tmp-movto-prestador.in-movto.     */

  /*----- VERIFICA ULTIMO ERRO DE IMPORTACAO -----*/
  /*if  (tp-registro = 1 and not lg-erro-geral and in-movto-aux = 1 /*INCLUSAO*/ )
  or  (tp-registro = 3 and tp-anterior = 1   and in-movto-aux = 1 /*INCLUSAO*/ )
  then do:
         create wk-erros.
         assign wk-erros.cd-tipo-erro = "E"
                wk-erros.cd-tipo-regs = 1
                wk-erros.ds-desc = "Faltando Registro do "  +
                                   "Prestador X Vinculo X " +
                                   "Especialidade.".
         
         run gera-relat-erro (2,"").
         assign lg-erro-aux = yes.
       end.*/
 
  /*----- IMPORTA DADOS DOS REGISTROS (SE TUDO OK) -----*/

  if   c-opcao = "Importa"
  and  not lg-erro-geral
  and  c-cd-unidade <> 0
  then do:
         assign lg-erro-imp-aux = no.

         assign tt-prest-gravados    = 0
                tt-regs-gravados     = 0
                tt-prest-erros-atual = 0
                tt-prest-aviso-atual = 0
                tp-anterior          = 0
                tp-registro          = 0
                c-cd-unidade         = 0
                lg-erro              = no
                lg-aviso             = no
                lg-erro-geral        = no.

         run importa-prestador-migracao.

         /*----- IMPRIME RELATORIO DE IMPORTADOS E GRAVADOS -----*/
         if not lg-erro-imp-aux
         then run gera-relat-acertos.

         run imp-relat-acertos-migracao.

         display stream s-acertos
                 tt-prest-lidos
                 tt-regs-gravados
                 tt-prest-gravados
                 with frame f-totais-ok.



         empty temp-table tmp-preserv-aux. 
         empty temp-table tmp-previesp-aux. 
         empty temp-table tmp-endpres-aux. 
         empty temp-table tmp-prestdor-ender-aux.
         empty temp-table tmp-prest-inst-aux. 
         empty temp-table tmp-prestdor-obs-aux.

         /*----- ZERAR VARIAVEIS INICIAIS -----*/
         if   lg-layout-serious-aux
         then assign tt-prest-lidos = 0.
         
         
         
         /*----- LIMPAR TEMP-TABLES -----*/
         empty temp-table wk-erros.
         empty temp-table wk-reg2.
         empty temp-table wk-reg3.
         empty temp-table wk-reg4.
         empty temp-table wk-reg5.
         
         assign cont-migra-aux = 1.

       end.
 
  /*/*----- MOSTRAR TOTAIS -----*/
  if   c-opcao = "Consiste" 
  then assign ds-titulo-tela = "ESTATISTICAS DA CONSISTENCIA".
  else assign ds-titulo-tela = "ESTATISTICAS DA IMPORTACAO".

  display tt-prest-lidos
          tt-regs-gravados
          tt-prest-gravados
          tt-prest-erros
          tt-prest-aviso
          with frame f-totais-tela.*/
 
  /*----- LIGAR LOG DA CONSISTENCIA -----*/
  if   c-opcao = "Consiste"
  then assign lg-consiste-aux = yes.

  /*----- DESLIGAR LOGS -----*/
  if   c-opcao = "Importa"
  then assign lg-arquivo-aux   = no
              lg-parametro-aux = no
              lg-consiste-aux  = no.

  /*----- IMPRIME TOTAIS DO REL. ERROS. -----*/
  display stream s-erro
          tt-prest-lidos
          tt-prest-erros
          tt-prest-aviso
          with frame f-totais-erros.

  /*----- IMPRIME TOTAIS DO REL. DE ACERTOS -----*/
/*   if   c-opcao = "Importa"                     */
/*   then do:                                     */
/*          run imp-relat-acertos-migracao.       */
/*                                                */
/*          display stream s-acertos              */
/*                  tt-prest-lidos                */
/*                  tt-regs-gravados              */
/*                  tt-prest-gravados             */
/*                  with frame f-totais-ok.       */
/*                                                */
/*          empty temp-table tmp-movto-prestador. */
/*        end.                                    */

  input  stream s-import close.
  
end procedure.

procedure consiste-migracao:
    DEFINE VARIABLE lg-ja-tem-previesp-aux AS LOGICAL NO-UNDO.
    case substring(c-dados,1,1):                                                                                                   
       when "1"                                                                                                                    
       then do:                                                                                                                    
/*                if   tp-anterior <> 0       */
/*                then run imprime-prestador. */
                                                                                                                                   
               assign tp-anterior = 1.                                                                                             
                                                                                                                                   
               assign c-cd-unidade = int(substring(c-dados,2,4)).                                                                  
                                                                                                                                   
               /* -------------- GERACAO AUTOMATICA DO COD.DO PRESTADOR --- */                                                     
               if   not lg-codigo-ptu-aux                                                                                          
               or   int(substring(c-dados,6,8)) = 0                                                                                
               then do:                                                                                                            
                                                                                                                                   
                      find first preserv                                                                                           
                           where preserv.cd-unidade = c-cd-unidade                                                                 
                             and preserv.nr-cgc-cpf = substring(c-dados,272,19)                                                    
                                 no-lock no-error.                                                                                 
                                                                                                                                   
                      if   avail preserv                                                                                           
                      then do:                                                                                                     
                             /* Verifica se nao existe mais de um prestador com mesmo cpf/cnpj na mesma unidade */                 
                             find first b-preserv                                                                                  
                                  where b-preserv.nr-cgc-cpf    = preserv.nr-cgc-cpf                                               
                                    and b-preserv.cd-unidade    = preserv.cd-unidade                                               
                                    and b-preserv.cd-prestador <> preserv.cd-prestador                                             
                                  no-lock no-error.                                                                                
                                                                                                                                   
                             if   avail b-preserv                                                                                  
                             then do:                                                                                              
                                                                                                                                   
                                    assign c-cd-prestador   = 0                                                                    
                                           c-nm-prestador   = substring(c-dados,1178,70)                                           
                                           c-nome-abrev     = substring(c-dados,54,12)                                             
                                           c-in-tipo-pessoa = substring(c-dados,66,1)                                              
                                           c-cgc-cpf        = substring(c-dados,272,19)                                            
                                           c-nm-fantasia    = substring(c-dados,1138,40).                                          
                                                                                                                                   
                                    create wk-erros.                                                                               
                                    assign wk-erros.cd-tipo-erro = "E"                                                             
                                           wk-erros.cd-tipo-regs = 1                                                               
                                           wk-erros.ds-desc      = "Existe mais de um prestador cadastrado com CPF/CNPJ do arquivo" 
                                                                 + " Unidade: "   + string(preserv.cd-unidade)                     
                                                                 + " Prestador: " + string(preserv.cd-prestador).                  
                                                                                                                                   
                                    run gera-relat-erro (2,"").                                                                    
                                    assign lg-erro-aux = yes.                                                                      
                                                                                                                                   
                                    if   not lg-importacao-total /* NÆo importa parcial */                                         
                                    then return.                                                                                   
                                    else do:                                                                                       
                                           assign tp-anterior = 0.                                                                 
                                           next.                                                                                   
                                         end.                                                                                      
                                  end.                                                                                             
                                                                                                                                   
                             assign c-cd-prestador = preserv.cd-prestador.                                                         
                                                                                                                                   
                             if  (    substring(c-dados,204,02) = "00"                                                             
                                  and substring(c-dados,202,02) = "00"                                                             
                                  and substring(c-dados,206,04) = "0000"                                                           
                                 )                                                                                                 
                             or  (    substring(c-dados,204,02) = "  "                                                             
                                  and substring(c-dados,202,02) = "  "                                                             
                                  and substring(c-dados,206,04) = "    "                                                           
                                 )                                                                                                 
                             then assign in-movto-aux = 2. /* ALTERACAO */                                                         
                             else assign in-movto-aux = 3. /* EXCLUSAO  */                                                         
                           /* comentado pois durante a migracao a base de prestadores esta vazia
                             run consiste-dados(input  yes,                                                                        
                                                output lg-erro-aux).*/
                                                                                                                                   
                             if   lg-erro-aux                                                                                      
                             then do:                                                                                              
                                    if   not lg-importacao-total /* NÆo importa parcial */                                         
                                    then return.                                                                                   
                                    else do:                                                                                       
                                           assign tp-anterior = 0.                                                                 
                                           next.                                                                                   
                                         end.                                                                                      
                                  end.                                                                                             
                           end.                                                                                                    
                      else do:                                                                                                     
                             assign in-movto-aux = 1. /* INCLUSAO */                                                               
                                                                                                                                   
                             /*----- CRIAR CODIGO PARA O PRESTADOR -----*/                                                         
                             find last preserv                                                                                     
                                 where preserv.cd-unidade = c-cd-unidade                                                           
                                       no-lock no-error.                                                                           
                                                                                                                                   
                             if   avail preserv                                                                                    
                             then do:                                                                                              
                                                                                                                                   
                                    if   preserv.cd-prestador >= 99999999                                                          
                                    then do:                                                                                       
                                           assign c-cd-prestador   = 0                                                             
                                                  c-nm-prestador   = substring(c-dados,1178,70)                                    
                                                  c-nome-abrev     = substring(c-dados,54,12)                                      
                                                  c-in-tipo-pessoa = substring(c-dados,66,1)                                       
                                                  c-cgc-cpf        = substring(c-dados,272,19)                                     
                                                  c-nm-fantasia    = substring(c-dados,1138,40).                                   
                                                                                                                                   
                                           run gera-relat-erro(1, "Codigo prestador nao pode ser maior "                           
                                                                + "que 99999999 "                                                  
                                                                + "na unidade "   + string(c-cd-unidade)).                         
                                                                                                                                   
                                           assign lg-erro-geral = yes.                                                             
                                           return.                                                                                 
                                         end.                                                                                      
                                                                                                                                   
                                    assign c-cd-prestador = preserv.cd-prestador + cont-migra-aux.
                                  end.                                                                                             
                             else assign c-cd-prestador = 1.    

                             assign cont-migra-aux = cont-migra-aux + 1.
                           end.                                                                                                    
                    end.                                                                                                           
               /* ------- ASSUMIR COD.DO PRESTADOR DO ARQ.DE IMPORTACAO --- */                                                     
               else do:                                                                                                            
                      assign c-cd-prestador = int(substring(c-dados,6,8)).                                                         
                                                                                                                                   
                      find first preserv                                                                                           
                           where preserv.cd-unidade   = c-cd-unidade                                                               
                             and preserv.cd-prestador = c-cd-prestador                                                             
                                 no-lock no-error.                                                                                 
                                                                                                                                   
                      if avail preserv                                                                                             
                      then do:                                                                                                     
                             if  (    substring(c-dados,204,02) = "00"                                                             
                                  and substring(c-dados,202,02) = "00"                                                             
                                  and substring(c-dados,206,04) = "0000"                                                           
                                 )                                                                                                 
                             or  (    substring(c-dados,204,02) = "  "                                                             
                                  and substring(c-dados,202,02) = "  "                                                             
                                  and substring(c-dados,206,04) = "    "                                                           
                                 )                                                                                                 
                             then assign in-movto-aux = 2. /* ALTERACAO */                                                         
                             else assign in-movto-aux = 3. /* EXCLUSAO  */                                                         
                              
                             /* comentado pois durante a migracao a base de prestadores esta vazia
                             run consiste-dados(input  no,                                                                         
                                                output lg-erro-aux).*/
                                                                                                                                   
                             if   lg-erro-aux                                                                                      
                             then do:                                                                                              
                                    if   not lg-importacao-total /* NÆo importa parcial */                                         
                                    then return.                                                                                   
                                    else do:                                                                                       
                                           assign tp-anterior = 0.                                                                 
                                           next.                                                                                   
                                         end.                                                                                      
                                  end.                                                                                             
                           end.                                                                                                    
                      else assign in-movto-aux = 1. /* INCLUSAO */                                                                 
                    end.                                                                                                           

               /* validacoes */

               assign cd-grupo-prestador-aux = int(substring(c-dados,067,2))
                      cd-cidade-aux          = int(substring(c-dados,154,6))
                      cd-especialidade1-aux  = int(substring(c-dados,240,3))
                      cd-especialidade2-aux  = int(substring(c-dados,243,3)).
                          
               find gruppres where gruppres.cd-grupo-prestador = cd-grupo-prestador-aux no-lock no-error.
               if not avail gruppres then do:
                   /* erro de grupo */
               
                   run gera-relat-erro(1,   "Grupo prestador nao cadastrado "
                                          + " Unidade: "   + string(c-cd-unidade)
                                          + " Prestador: " + string(c-cd-prestador)
                                          + " Grupo: "     + string(cd-grupo-prestador-aux)).
               
                                      
                   assign lg-erro-geral = yes.
                   return.
               end.

               if  cd-cidade-aux <> 0
               and cd-cidade-aux <> ? 
               THEN DO:
                      find dzcidade where dzcidade.cd-cidade = cd-cidade-aux no-lock no-error.
                      if not avail dzcidade then do:                                         
                      
                              run gera-relat-erro(1, "Cidade nao cadastrada -"
                                                     + " Unidade: "   + string(c-cd-unidade)
                                                     + " Prestador: " + string(c-cd-prestador)
                                                     + " Cidade: "     + string(cd-cidade-aux)).
                                             
                              assign lg-erro-geral = yes.
                              return.
                      end.                                        
                    END.
               
               if  cd-especialidade1-aux <> 0
               and cd-especialidade1-aux <> ? then do:
                  find esp-med where esp-med.cd-especialid = cd-especialidade1-aux no-lock no-error.     
                  if not avail esp-med
                  then do:
                      run gera-relat-erro(1,   "Especialidade do prestador nao cadastrada "
                                               + " Unidade: "   + string(c-cd-unidade)
                                               + " Prestador: " + string(c-cd-prestador)
                                               + " Espec.: "     + string(cd-especialidade1-aux)).

                      assign lg-erro-geral = yes.
                      return.
                  end.
               end.
               
               if  cd-especialidade2-aux <> 0
               and cd-especialidade2-aux <> ? then do:
                  find esp-med where esp-med.cd-especialid = cd-especialidade2-aux no-lock no-error.     
                  if not avail esp-med
                  then do:
                      run gera-relat-erro(1,   "Especialidade do prestador nao cadastrada "
                                               + " Unidade: "   + string(c-cd-unidade)
                                               + " Prestador: " + string(c-cd-prestador)
                                               + " Espec.: "     + string(cd-especialidade2-aux)).

                      assign lg-erro-geral = yes.
                      return.
                  end.

               end.
               
               create tmp-movto-prestador.                                                                                         
               assign tmp-movto-prestador.cd-unidade   = c-cd-unidade                                                              
                      tmp-movto-prestador.cd-prestador = c-cd-prestador                                                            
                      tmp-movto-prestador.in-movto     = in-movto-aux.                                                             
                                                                                                                                   
               /* --------------------------------------------------------- */                                                     
               assign c-nm-prestador       = substring(c-dados,1178,70)                                                            
                      c-nome-abrev         = substring(c-dados,54,12)                                                              
                      c-in-tipo-pessoa     = substring(c-dados,66,1)                                                               
                      c-cd-grupo-prestador = cd-grupo-prestador-aux                                                                
                      c-nm-fantasia        = substring(c-dados,1138,40).                                                           
    
               create tmp-preserv-aux.
               assign tmp-preserv-aux.cd-unidade         = c-cd-unidade
                      tmp-preserv-aux.cd-prestador       = c-cd-prestador
                      tmp-preserv-aux.nm-prestador       = TRIM(c-nm-prestador)
                      tmp-preserv-aux.nome-abrev         = TRIM(c-nome-abrev)
                      tmp-preserv-aux.in-tipo-pessoa     = TRIM(c-in-tipo-pessoa)    
                      tmp-preserv-aux.cd-grupo-prestador = c-cd-grupo-prestador
                      tmp-preserv-aux.char-20            = TRIM(c-nm-fantasia)
                      tmp-preserv-aux.cd-contratante     = int(substring(c-dados,90,9)).

               if trim(substring(c-dados,14,18)) = ""
               then assign tmp-preserv-aux.id-pessoa = 0.
               else assign tmp-preserv-aux.id-pessoa = int(substring(c-dados,14,18)).

                                                                                                                                   
               if substring(c-dados,69,1) = "S"                                                                                    
               then do:
                   assign tmp-preserv-aux.lg-medico = true
                          c-lg-medico = true.                                                                                            
               end.
               else do: 
                   assign tmp-preserv-aux.lg-medico = false
                          c-lg-medico = false.                                                                                           
               end.
                                                                                                                                   
               if substring(c-dados,70,1) = "S"                                                                                    
               then do:
                   assign tmp-preserv-aux.lg-cooperado = true 
                                        c-lg-cooperado = true.                                                                                         
               end.
               else do: 
                   assign tmp-preserv-aux.lg-cooperado = false 
                                        c-lg-cooperado = false.                                                                                        
               end.
    
    
               assign tmp-preserv-aux.cd-unidade-seccional = int(substring(c-dados,71,4))                       
                      tmp-preserv-aux.cd-conselho          =     TRIM(substring(c-dados,75,5))                        
                      tmp-preserv-aux.cd-uf-conselho       =     TRIM(substring(c-dados,80,2))                        
                      tmp-preserv-aux.nr-registro          = int(substring(c-dados,82,8))                       
    /*                   tmp-preserv-aux.cd-magnus            = int(substring(c-dados,90,9)) */                 
                      tmp-preserv-aux.en-rua               =     TRIM(substring(c-dados,99,40))                       
                      tmp-preserv-aux.en-bairro            =     TRIM(substring(c-dados,139,15))                      
                      tmp-preserv-aux.cd-cidade            = INT(substring(c-dados,154,6)) /*cd-cidade-aux*/    
                      tmp-preserv-aux.en-cep               =     TRIM(substring(c-dados,160,8))                       
                      tmp-preserv-aux.en-uf                =     TRIM(substring(c-dados,168,2))                       
                      tmp-preserv-aux.nr-telefone[1]       =     TRIM(substring(c-dados,982,20))                      
                      tmp-preserv-aux.nr-telefone[2]       =     TRIM(substring(c-dados,1002,20))                     
                      tmp-preserv-aux.dt-inclusao          = date(int(substring(c-dados,196,02)),               
                                                              int(substring(c-dados,194,02)),                   
                                                              int(substring(c-dados,198,04))).                                                                          
    
               assign c-cd-unidade-seccional = int(substring(c-dados,71,4))                                                        
                      c-cd-conselho          =     TRIM(substring(c-dados,75,5))                                                         
                      c-cd-uf-conselho       =     TRIM(substring(c-dados,80,2))                                                         
                      c-nr-registro          = int(substring(c-dados,82,8))                                                        
                      c-cd-magnus            = int(substring(c-dados,90,9))                                                        
                      c-en-rua               =     TRIM(substring(c-dados,99,40))                                                        
                      c-en-bairro            =     TRIM(substring(c-dados,139,15))                                                       
                      c-cd-cidade            = INT(substring(c-dados,154,6)) /*cd-cidade-aux*/
                      c-en-cep               =     TRIM(substring(c-dados,160,8))                                                        
                      c-en-uf                =     TRIM(substring(c-dados,168,2))                                                        
                      c-nr-telefone[1]       =     TRIM(substring(c-dados,982,20))                                                       
                      c-nr-telefone[2]       =     TRIM(substring(c-dados,1002,20))                                                      
                      c-dt-inclusao          = date(int(substring(c-dados,196,02)),                                                
                                                    int(substring(c-dados,194,02)),                                                
                                                    int(substring(c-dados,198,04))).                                               
                                                                                                                                   
               if  (substring(c-dados,204,02) = "00"                                                                               
               and  substring(c-dados,202,02) = "00"                                                                               
               and  substring(c-dados,206,04) = "0000")                                                                            
               or  (substring(c-dados,204,02) = "  "                                                                               
               and  substring(c-dados,202,02) = "  "                                                                               
               and  substring(c-dados,206,04) = "    ")                                                                            
               then c-dt-exclusao = ?.                                                                                             
               else c-dt-exclusao = date(int(substring(c-dados,204,02)),                                                           
                                         int(substring(c-dados,202,02)),                                                           
                                         int(substring(c-dados,206,04))).  
    
               assign tmp-preserv-aux.dt-exclusao = c-dt-exclusao.
                                                                                                                                   
               if substring(c-dados,210,1)= "M"                                                                                    
               then c-lg-sexo             = true.                                                                                  
               else c-lg-sexo             = false.                                                                                 
    
               assign tmp-preserv-aux.lg-sexo = c-lg-sexo.
                                                                                                                                   
               assign c-dt-nascimento    = date(int(substring(c-dados,213,02)),                                                    
                                                int(substring(c-dados,211,02)),                                                    
                                                int(substring(c-dados,215,04)))                                                    
                      c-cd-insc-unimed   = int(substring(c-dados,219,4))                                                           
                      c-cd-situac-sindic = TRIM(substring(c-dados,223,2)).       
    
               assign tmp-preserv-aux.dt-nascimento    = c-dt-nascimento
                      tmp-preserv-aux.cd-insc-unimed   = c-cd-insc-unimed
                      tmp-preserv-aux.cd-situac-sindic = c-cd-situac-sindic.
                                                     
               assign c-qt-produtividade  = dec(substring(c-dados,225,12)) / 100 no-error.                                         
    
               assign tmp-preserv-aux.qt-produtividade = c-qt-produtividade.
                                                                                                                                   
               if substring(c-dados,237,1)= "S"                                                                                    
               then c-lg-alvara = true.                                                                                            
               else c-lg-alvara = false.                                                                                           
    
               assign tmp-preserv-aux.lg-alvara = c-lg-alvara.
    
               if substring(c-dados,238,1) = "S"                                                                                   
               then c-lg-registro = true.                                                                                          
               else c-lg-registro = false.                                                                                         
    
                                                                                                                                   
               assign tmp-preserv-aux.lg-registro = c-lg-registro.
    
               if substring(c-dados,239,1) = "S"                                                                                   
               then c-lg-diploma = true.                                                                                           
               else c-lg-diploma = false.                                                                                          
    
               assign tmp-preserv-aux.lg-diploma = c-lg-diploma.
    
               assign c-cd-esp-resid  = cd-especialidade1-aux                                                                      
                      c-cd-esp-titulo = cd-especialidade2-aux.                                                                     
    
               assign tmp-preserv-aux.cd-esp-resid  = c-cd-esp-resid 
                      tmp-preserv-aux.cd-esp-titulo = c-cd-esp-titulo.
                                                                                                                                   
               if substring(c-dados,246,1) = "S"                                                                                   
               then c-lg-malote = true.                                                                                            
               else c-lg-malote = false.
    
               assign tmp-preserv-aux.lg-malote  = c-lg-malote.
                                                                                                                                   
               if substring(c-dados,247,1) = "S"                                                                                   
               then c-lg-vinc-empreg = true.                                                                                       
               else c-lg-vinc-empreg = false.                                                                                      
    
               assign tmp-preserv-aux.lg-vinc-empreg  = c-lg-vinc-empreg.
                                                                                                                                   
               assign c-nr-ult-inss = int(substring(c-dados,248,6))                                                                
                      c-nr-ramal[1] =     TRIM(substring(c-dados,262,05))                                                                
                      c-nr-ramal[2] =     TRIM(substring(c-dados,267,05))                                                                
                      c-cgc-cpf     =     TRIM(substring(c-dados,272,19)).                                                               
    
               assign tmp-preserv-aux.nr-ult-inss = c-nr-ult-inss
                      tmp-preserv-aux.nr-ramal[1] = c-nr-ramal[1]
                      tmp-preserv-aux.nr-ramal[2] = c-nr-ramal[2]
                      tmp-preserv-aux.nr-cgc-cpf     = c-cgc-cpf.
                                                                                                                                   
               if substring(c-dados,291,1)  = "S"                                                                                  
               then c-lg-representa-unidade = true.                                                                                
               else c-lg-representa-unidade = false.                                                                               
    
               assign tmp-preserv-aux.lg-representa-unidade = c-lg-representa-unidade. 
                                                                                                                                   
               c-cd-tab-urge               = int(substring(c-dados,292,2)).                                                        
    
               assign tmp-preserv-aux.cd-tab-urge = c-cd-tab-urge.
                                                                                                                                   
               if substring(c-dados,294,1) = "S"                                                                                   
               then c-lg-recolhe-inss = true.                                                                                      
               else c-lg-recolhe-inss = false.                                                                                     
    
               assign tmp-preserv-aux.lg-recolhe-inss = c-lg-recolhe-inss.
                                                                                                                                   
               if substring(c-dados,295,1) = "S"                                                                                   
               then c-lg-recolhe-participa = true.                                                                                 
               else c-lg-recolhe-participa = false.                                                                                
    
               assign tmp-preserv-aux.lg-recolhe-participa = c-lg-recolhe-participa.
                                                                                                                                   
               c-ds-observacao             = trim(substring(c-dados,296,228)). 
    
               assign tmp-preserv-aux.ds-observacao = c-ds-observacao.
                                                                                                                                   
               if substring(c-dados,524,1) = "S"                                                                                   
               then c-calc-irrf = true.                                                                                            
               else c-calc-irrf = false.     
      
               assign tmp-preserv-aux.lg-calcula-ir = c-calc-irrf.      
    
                                                                                                                                   
               c-incidir-irrf              = int(substring(c-dados,525,2)).                                                        
    
               assign tmp-preserv-aux.in-ir-atos-cooperados = c-incidir-irrf.      
                                                                                                                                   
               if substring(c-dados,533,1) = "S"                                                                                   
               then c-lg-calcula-adto = true.                                                                                      
               else c-lg-calcula-adto = false.                                                                                     
    
               assign tmp-preserv-aux.lg-calcula-adto = c-lg-calcula-adto.
                                                                                                                                   
                                                                                                                                   
               if  (substring(c-dados,536,02) = "00"                                                                               
               and  substring(c-dados,534,02) = "00"                                                                               
               and  substring(c-dados,538,04) = "0000")                                                                            
               or  (substring(c-dados,536,02) = "  "                                                                               
               and  substring(c-dados,534,02) = "  "                                                                               
               and  substring(c-dados,538,04) = "    ")                                                                            
               then c-dt-calculo-adto = ?.                                                                                         
               else c-dt-calculo-adto = date(int(substring(c-dados,536,02)),                                                       
                                             int(substring(c-dados,534,02)),                                                       
                                             int(substring(c-dados,538,04))).                                                      
    
               assign tmp-preserv-aux.dt-calculo-adto = c-dt-calculo-adto.
                                                                                                                                   
               c-nr-dependentes           = int(substring(c-dados,542,2)).
    
               assign tmp-preserv-aux.nr-dependentes = c-nr-dependentes.
                                                                                                                                   
               if substring(c-dados,544,1) = "S"                                                                                   
               then c-lg-pagamento-rh = true.                                                                                      
               else c-lg-pagamento-rh = false.
    
               assign tmp-preserv-aux.lg-pagamento-rh = c-lg-pagamento-rh.
                                                                                                                                   
               c-nm-email                 = substring(c-dados,545,50).                                                             
               c-cd-tipo-fluxo            = substring(c-dados,595,12).                                                             
               c-cd-imposto               = substring(c-dados,607,5).                                                              
               c-cd-classificacao-imposto = substring(c-dados,612,5).                                                              
               c-nr-pis-pasep             = dec(substring(c-dados,617,11)).                                                        
               c-nr-inscricao-inss        =     substring(c-dados,628,14).                                                         
    
               assign tmp-preserv-aux.nm-email                 = TRIM(c-nm-email)
                      tmp-preserv-aux.cd-tipo-fluxo            = TRIM(c-cd-tipo-fluxo)
                      tmp-preserv-aux.cd-imposto               = TRIM(c-cd-imposto)
                      tmp-preserv-aux.cd-classificacao-imposto = TRIM(c-cd-classificacao-imposto)
                      tmp-preserv-aux.nr-pis-pasep             = c-nr-pis-pasep
                      tmp-preserv-aux.nr-inscricao-inss        = TRIM(c-nr-inscricao-inss).
                   
                                                                                                                                   
               if substring(c-dados,642,1) = "S"                                                                                   
               then assign c-lg-divisao-honorario = true.
               else assign c-lg-divisao-honorario = false.                                                                         
    
               assign tmp-preserv-aux.lg-divisao-honorario = c-lg-divisao-honorario.
                                                                                                                                   
               if substring(c-dados,643,1) = "S"                                                                                   
               then c-calc-cofins = true.                                                                                          
               else c-calc-cofins = false.
    
               assign tmp-preserv-aux.lg-cofins = c-calc-cofins.
                                                                                                                                   
               if substring(c-dados,644,1) = "S"                                                                                   
               then c-calc-pispasep = true.                                                                                        
               else c-calc-pispasep = false.                                                                                       
    
               assign tmp-preserv-aux.lg-pis-pasep = c-calc-pispasep.
                                                                                                                                   
               if substring(c-dados,645,1) = "S"                                                                                   
               then c-calc-csll = true.                                                                                            
               else c-calc-csll = false.
    
               assign tmp-preserv-aux.lg-csll = c-calc-csll.
                                                                                                                                   
               if substring(c-dados,686,1) = "S"                                                                                   
               then c-calc-iss = true.                                                                                             
               else c-calc-iss = false.
    
               assign tmp-preserv-aux.lg-csll = c-calc-csll.
                                                                                                                                   
               if substring(c-dados,697,1) = "S"                                                                                   
               then c-deduz-iss = true.                                                                                            
               else c-deduz-iss = false.
    
               assign tmp-preserv-aux.lg-deduz-iss = c-deduz-iss.
                                                                                                                                   
               assign c-cd-cofins                 = TRIM(substring(c-dados,646,5))                                                       
                      c-cd-classificacao-cofins   = TRIM(substring(c-dados,661,5))                                                       
                      c-cd-pispasep               = TRIM(substring(c-dados,651,5))                                                       
                      c-cd-classificacao-pispasep = TRIM(substring(c-dados,666,5))                                                       
                      c-cd-csll                   = TRIM(substring(c-dados,656,5))                                                       
                      c-cd-classificacao-csll     = TRIM(substring(c-dados,671,5))                                                       
                      c-cd-inss                   = TRIM(substring(c-dados,676,5))                                                       
                      c-cd-classificacao-inss     = TRIM(substring(c-dados,681,5))                                                       
                      c-cd-iss                    = TRIM(substring(c-dados,687,5))                                                       
                      c-cd-classificacao-iss      = TRIM(substring(c-dados,692,5))                                                       
                      c-nr-dias-validade          = int(substring(c-dados,698,3))                                                  
                      c-portador                  = int(substring(c-dados,701,5))                                                  
                      c-modalidade                = int(substring(c-dados,706,1))                                                  
                      c-cd-banco                  = int(substring(c-dados,707,3))                                                  
                      c-agencia                   = TRIM(substring(c-dados,710,8)  )                                                     
                      c-conta-corren              = TRIM(substring(c-dados,718,20) )                                                     
                      c-agencia-digito            = TRIM(substring(c-dados,738,2)  )                                                     
                      c-conta-corren-digito       = TRIM(substring(c-dados,740,2)  )                                                     
                      c-forma-pagto               = TRIM(substring(c-dados,742,3)  ).                                                     
    
    
               assign tmp-preserv-aux.cd-imposto-cofins         = c-cd-cofins                
                      tmp-preserv-aux.cd-clas-imposto-cofins    = c-cd-classificacao-cofins  
                      tmp-preserv-aux.cd-imposto-pis-pasep      = c-cd-pispasep              
                      tmp-preserv-aux.cd-clas-imposto-pis-pasep = c-cd-classificacao-pispasep
                      tmp-preserv-aux.cd-imposto-csll           = c-cd-csll                  
                      tmp-preserv-aux.cd-clas-imposto-csll      = c-cd-classificacao-csll    
                      tmp-preserv-aux.cd-imposto-inss           = c-cd-inss                  
                      tmp-preserv-aux.cd-classificacao-imp-inss = c-cd-classificacao-inss    
                      tmp-preserv-aux.cd-imposto-iss            = c-cd-iss                   
                      tmp-preserv-aux.cd-classificacao-imp-iss  = c-cd-classificacao-iss     
                      tmp-preserv-aux.nr-dias-validade          = c-nr-dias-validade         
                      tmp-preserv-aux.portador                  = c-portador                 
                      tmp-preserv-aux.modalidade                = c-modalidade               
                      tmp-preserv-aux.cod-banco                 = c-cd-banco                 
                      tmp-preserv-aux.agencia                   = c-agencia                  
                      tmp-preserv-aux.conta-corren              = c-conta-corren             
                      tmp-preserv-aux.dig-agencia               = c-agencia-digito           
                      tmp-preserv-aux.dig-conta-corren          = c-conta-corren-digito      
                      tmp-preserv-aux.cod-forma-pagto           = c-forma-pagto.
                                                                
               assign c-retem-proc = substring(c-dados,745,1).                                                                     
               assign c-retem-insu = substring(c-dados,746,1).                                                                     
    
              if c-retem-proc = "S" then 
                  assign tmp-preserv-aux.lg-retem-proc = true.
              else
                  assign tmp-preserv-aux.lg-retem-proc = false.
                         
              if c-retem-insu = "S" then 
                  assign tmp-preserv-aux.lg-retem-insu = true.
              else
                  assign tmp-preserv-aux.lg-retem-insu = false.
              
               if substring(c-dados,747,1) = "S"                                                                                   
               then c-calc-imposto-unico = true.                                                                                   
               else c-calc-imposto-unico = false.                                                                                  
    
              assign tmp-preserv-aux.lg-imposto-unico = c-calc-imposto-unico.
                                                                                                                                   
               assign c-cd-imposto-unico       = TRIM(substring(c-dados,748,5))                                                          
                      c-cd-clas-imposto-unico  = TRIM(substring(c-dados,753,5))                                                          
                      c-cd-tipo-classif-estab  = TRIM(substring(c-dados,758,1))                                                          
                      c-cd-cnes                = int(substring(c-dados,759,7))                                                     
                      c-nm-diretor-tecnico     = TRIM(substring(c-dados,766,40))                                                         
                      c-nr-crm-dir-tecnico     = TRIM(substring(c-dados,806,8))                                                          
                      c-cd-registro-ans        = int(substring(c-dados,814,6)).                                                    
    
    
               assign tmp-preserv-aux.cd-imposto-unico      = c-cd-imposto-unico      
                      tmp-preserv-aux.cd-clas-imposto-unico = c-cd-clas-imposto-unico 
                      tmp-preserv-aux.in-class-estabelec    = c-cd-tipo-classif-estab 
                      tmp-preserv-aux.cd-cnes               = string(c-cd-cnes)       
                      tmp-preserv-aux.nm-diretor-tecnico    = c-nm-diretor-tecnico    
                      tmp-preserv-aux.nr-crm-dir-tec        = c-nr-crm-dir-tecnico.   
    /*                   tmp-preserv-aux.cd-registro-ans       = c-cd-registro-ans. */
    
    
               if   substring(c-dados,820,8) <> "00000000"                                                                         
               and  substring(c-dados,820,8) <> "        "                                                                         
               then c-dt-inicio-contratual   = date(substring(c-dados,820,8)).                                                     
               else c-dt-inicio-contratual   = ?.                                                                                  
    
               assign tmp-preserv-aux.dt-ini-contrato = c-dt-inicio-contratual.
                                                                                                                                   
               if substring(c-dados,1023,1)   = "S"                                                                                
               then c-lg-cooperativa         = true.                                                                               
               else c-lg-cooperativa         = false.                                                                              
    
               assign tmp-preserv-aux.lg-cooperativa = c-lg-cooperativa.
                                                                                                                                   
               /* dados ans */                                                                                                     
               if substring(c-dados,66,1)   = "F"                                                                                  
               then do:                                                                                                            
                      assign c-ds-natureza-doc-ident  = TRIM(substring(c-dados,828,40))                                                  
                             c-nr-doc-ident           = TRIM(substring(c-dados,868,14))                                                  
                             c-ds-orgao-emissor-ident = TRIM(substring(c-dados,882,30))                                                  
                             c-nm-pais-emissor-ident  = TRIM(substring(c-dados,912,20))                                                  
                             c-uf-emissor-ident       = TRIM(substring(c-dados,932,2) )                                                  
                             c-ds-nacionalidade       = TRIM(substring(c-dados,942,40)).                                                 
                                                                                                                                   
                      if   substring(c-dados,934,8) <> "00000000"                                                                  
                      and  substring(c-dados,934,8) <> "        "                                                                  
                      then c-dt-emissao-doc-ident = date(substring(c-dados,934,8)).                                                
                      else c-dt-emissao-doc-ident = ?.       
    
                      assign tmp-preserv-aux.ds-natureza-doc        = c-ds-natureza-doc-ident 
                             tmp-preserv-aux.nr-identidade          = c-nr-doc-ident          
                             tmp-preserv-aux.ds-orgao-emissor       = c-ds-orgao-emissor-ident
                             tmp-preserv-aux.nm-pais                = c-nm-pais-emissor-ident 
                             tmp-preserv-aux.uf-emissor-doc         = c-uf-emissor-ident      
                             tmp-preserv-aux.ds-nacionalidade       = c-ds-nacionalidade
                             tmp-preserv-aux.dt-emissao-doc         = c-dt-emissao-doc-ident.      
               
                    end.                                                                                                           
                                                                                                                                   
               /* Tipo Disponibilidade do Servico */                                                                               
               assign c-tp-disponibilidade = int(substring(c-dados,1022,1)).                                                       
    
               assign tmp-preserv-aux.int-9 = c-tp-disponibilidade.
                                                                                                                                   
               /* -------------- Rede Acidente Trabalho ---------------------------------- */                                      
               if substr(c-dados,1024,1) = "S"                                                                                     
               then assign c-lg-acid-trab = yes.                                                                                   
               else assign c-lg-acid-trab = no.    
    
               assign tmp-preserv-aux.log-4 = c-lg-acid-trab.
                                                                                                                                   
               /* -------------- Pratica Tabela Propria ---------------------------------- */                                      
               if substr(c-dados,1025,1) = "S"                                                                                     
               then assign c-lg-tab-propria = yes.                                                                                 
               else assign c-lg-tab-propria = no.                                                                                  
    
               assign tmp-preserv-aux.log-5 = c-lg-tab-propria.
                                                                                                                                   
               /* -------------- Perfil Assistencial ------------------------------------- */                                      
               assign c-in-perfil-assistencial = int(substr(c-dados,1026,2)).                                                      
    
               assign tmp-preserv-aux.int-11 = c-in-perfil-assistencial.
                                                                                                                                   
               /* -------------- Tipo Produto -------------------------------------------- */                                      
               assign c-in-tipo-prod-atende = int(substr(c-dados,1028,1)).                                                         
    
               assign tmp-preserv-aux.int-12 = c-in-tipo-prod-atende.
                                                                                                                                   
               /* -------------- Guia Medico --------------------------------------------- */                                      
               if substr(c-dados,1029,1) = "S"                                                                                     
               then assign c-lg-guia-medico-aux = yes.                                                                             
               else assign c-lg-guia-medico-aux = no.                                                                              
    
               assign tmp-preserv-aux.log-6 = c-lg-guia-medico-aux.
                                                                                                                                   
               /* --------------------- DADOS DO DIRETOR TECNICO ------------------------- */                                      
               assign c-cd-conselho-dir-tec = trim(substr(c-dados,1030,12))                                                        
                      c-nr-conselho-dir-tec = trim(substr(c-dados,1042,15))                                                        
                      c-uf-conselho-dir-tec = trim(substr(c-dados,1057,02))                                                        
                      c-tp-rede             = int(trim(substr(c-dados,1059,01))).                                                  
    
               assign tmp-preserv-aux.char-21  = c-cd-conselho-dir-tec
                      tmp-preserv-aux.char-23  = c-nr-conselho-dir-tec
                      tmp-preserv-aux.char-22  = c-uf-conselho-dir-tec
                      tmp-preserv-aux.int-15   = c-tp-rede.            
    
                                                                                                                                   
               /* -------------- Sistema NOTIVISA ---------------------------------------- */                                      
               if substr(c-dados,1060,1) = "S"                                                                                     
               then assign c-lg-notivisa = yes.                                                                                    
               else assign c-lg-notivisa = no.                                                                                     
    
               assign tmp-preserv-aux.log-11 = c-lg-notivisa.
                                                                                                                                   
               /* -------------- Sistema QUALISS ----------------------------------------- */                                      
               if substr(c-dados,1061,1) = "S"                                                                                     
               then assign c-lg-qualiss = yes.                                                                                     
               else assign c-lg-qualiss = no.                                                                                      
    
               assign tmp-preserv-aux.log-12 = c-lg-qualiss.
                                                                                                                                   
               /* -------------- Nr. Registro Especialista 1 ----------------------------- */                                      
               /*assign c-nr-registro1 = dec(substr(c-dados,1062,10)).*/                                                           
                                                                                                                                   
               /* -------------- Nr. Registro Especialista 2 ----------------------------- */                                      
               assign c-nr-registro2 = dec(substr(c-dados,1072,10)).                                                               
                                                                                                                                   
               /* -------------- Nr. Leitos Hospital-Dia --------------------------------- */                                      
               assign c-nr-leitos-hosp-dia = int(substr(c-dados,1082,6)).                                                          
               tmp-preserv-aux.int-20 = c-nr-leitos-hosp-dia.
                                                                                                                                   
               /* -------------- Endereco Web -------------------------------------------- */                                      
               assign c-nm-end-web = TRIM(substr(c-dados,1088,50)).
               assign tmp-preserv-aux.char-27 = c-nm-end-web.
                                                                                                                                   
               if substr(c-dados,1248,1) = "S"                                                                                     
               then assign lg-publica-ans-aux = yes.                                                                               
               else assign lg-publica-ans-aux = no.                                                                                
               assign tmp-preserv-aux.log-15 = lg-publica-ans-aux.
                                                                                                                                   
               if substr(c-dados,1249,1) = "S"                                                                                     
               then assign lg-indic-residencia-aux = yes.                                                                          
               else assign lg-indic-residencia-aux = no.                                                                           
               assign tmp-preserv-aux.log-18 = lg-indic-residencia-aux.
                                                                                                                                   
               if substr(c-dados,1250,1) = "S"                                                                                     
               then assign lg-login-wsd-tiss-aux = yes.                                                                            
               else assign lg-login-wsd-tiss-aux = no.                                                                             
               assign tmp-preserv-aux.log-16 = lg-login-wsd-tiss-aux.
                                                                                                                                   
               if substr(c-dados,1251,1) = "S"                                                                                     
               then assign lg-cadu-aux = yes.                                                                                      
               else assign lg-cadu-aux = no.              
               assign tmp-preserv-aux.log-17    = lg-cadu-aux.

               assign tmp-preserv-aux.cd-grupo-fornecedor = TRIM(substr(c-dados,1252,4)).

               /* nome da mae */
               assign tmp-preserv-aux.nm-mae = TRIM(substr(c-dados,1256, 70)).

               assign tmp-preserv-aux.dt-atualizacao            = today
                      tmp-preserv-aux.cd-userid                 = TRIM(v_cod_usuar_corren).
            end.                                                                                                                   
       when "2"                                                                                                                    
       then do:       
                dt-inicio-aux = date(int(substring(c-dados,37,2)),
                                     int(substring(c-dados,35,2)),
                                     int(substring(c-dados,39,4))) no-error.
                if error-status:error then do:
                    run gera-relat-erro(1,   "Data inicial para validade da especialidade invalida "
                                           + " Unidade: "   + string(c-cd-unidade)
                                           + " Prestador: " + string(c-cd-prestador)
                                           + " Espec.: "     + substring(c-dados,4,3)).
                    assign lg-erro-geral = yes.
                    return.
                end.
                
                dt-fim-aux = date(int(substring(c-dados,45,2)),
                                  int(substring(c-dados,43,2)),
                                  int(substring(c-dados,47,4))) no-error.
                if error-status:error then do:
                    /* erro data fim validade especialidade */
                    run gera-relat-erro(1,   "Data final para validade da especialidade invalida "
                                           + " Unidade: "   + string(c-cd-unidade)
                                           + " Prestador: " + string(c-cd-prestador)
                                           + " Espec.: "     + substring(c-dados,4,3)).
                    assign lg-erro-geral = yes.
                    return.
                end.
       
                /* previesp */
                /* controle para nao criar mesmo VINCULO/ESPECIALIDADE mais de uma vez. Nesses casos, considerar apenas o mais recente.
                   se o registro ja existe com essa chave e eh o principal, nao alterar.
                   caso contrario, sobrepor com os dados do principal*/
                ASSIGN lg-ja-tem-previesp-aux = yes.
                FIND FIRST tmp-previesp-aux 
                     WHERE tmp-previesp-aux.cd-unidade    = tmp-preserv-aux.cd-unidade
                       AND tmp-previesp-aux.cd-prestador  = tmp-preserv-aux.cd-prestador
                       AND tmp-previesp-aux.cd-vinculo    = int(substring(c-dados,2,2))
                       AND tmp-previesp-aux.cd-especialid = int(substring(c-dados,4,3)) NO-ERROR.

                IF NOT AVAILABLE tmp-previesp-aux
                THEN DO:
                
                       create tmp-previesp-aux.
                       
                       
                       assign tmp-previesp-aux.cd-unidade         = tmp-preserv-aux.cd-unidade  
                       
                              tmp-previesp-aux.cd-prestador       = tmp-preserv-aux.cd-prestador
                              
                              tmp-previesp-aux.cd-vinculo         = int(substring(c-dados,2,2))
                              tmp-previesp-aux.cd-especialid      = int(substring(c-dados,4,3))
                              tmp-previesp-aux.dt-inicio-validade = dt-inicio-aux
                              tmp-previesp-aux.dt-fim-validade    = dt-fim-aux
                              lg-ja-tem-previesp-aux              = NO.
                     END.
                     
                FIND FIRST wk-reg2
                     WHERE wk-reg2.cd-vinculo    = int(substring(c-dados,2,2))
                       AND wk-reg2.cd-especialid = int(substring(c-dados,4,3)) NO-ERROR.
                IF NOT AVAILABLE wk-reg2
                THEN DO:
                       create wk-reg2.
                       assign wk-reg2.cd-vinculo    = int(substring(c-dados,2,2))
                              wk-reg2.cd-especialid = int(substring(c-dados,4,3)).
                     END.

                IF lg-ja-tem-previesp-aux
                THEN DO:
                       IF tmp-previesp-aux.dt-inicio-validade  >= dt-inicio-aux
                       THEN tmp-previesp-aux.dt-inicio-validade = dt-inicio-aux.
                       
                       IF tmp-previesp-aux.dt-fim-validade       <= dt-fim-aux
                       THEN tmp-previesp-aux.dt-fim-validade  = dt-fim-aux.
                     END.
                     
                /* se ja existia registro para essa especialidade como Principal, nao alterar mais nada.
                   caso contrario, prosseguir preenchendo as demais colunas normalmente. */
                IF lg-ja-tem-previesp-aux
                AND tmp-previesp-aux.lg-principal
                THEN DO:
                     END.
                ELSE DO:
                       if substring(c-dados,7,1) = "S"                                                                                     
                       then assign wk-reg2.lg-principal = true.                                                                            
                       else assign wk-reg2.lg-principal = false.                                                                           
                
                       assign tmp-previesp-aux.lg-principal = wk-reg2.lg-principal.
                                                                                                                                           
                       if substring(c-dados,8,1) = "S"                                                                                     
                       then assign wk-reg2.lg-considera-qt-vinculo = true.                                                                 
                       else assign wk-reg2.lg-considera-qt-vinculo = false.                                                                
                
                       assign tmp-previesp-aux.lg-considera-qt-vinculo = wk-reg2.lg-considera-qt-vinculo.
                                                                                                                                           
                       assign wk-reg2.cd-registro-espec        = substring(c-dados,9,10)                                                   
                              wk-reg2.cd-registro-espec-2      = dec(substring(c-dados,21,10))                                             
                              wk-reg2.cd-tipo-contratualizacao = substring(c-dados,19,1).                                                  
                
                       assign tmp-previesp-aux.cd-registro-especialidade = wk-reg2.cd-registro-espec       
                              tmp-previesp-aux.dec-1                     = wk-reg2.cd-registro-espec-2     
                              tmp-previesp-aux.in-contratualizacao       = wk-reg2.cd-tipo-contratualizacao.
                
                       if substr(c-dados,20,1)  = "S"                                                                                      
                       then assign wk-reg2.lg-rce = yes.                                                                                   
                       else assign wk-reg2.lg-rce = no.                                                                                    
                
                       assign tmp-previesp-aux.log-4 = wk-reg2.lg-rce.
                                                                                                                                           
                       assign wk-reg2.in-tipo-especialidade = int(substring(c-dados,31,1))                                                 
                              wk-reg2.cd-tit-cert-esp       = int(substring(c-dados,32,3)).     
                
                       assign tmp-previesp-aux.int-2          = wk-reg2.in-tipo-especialidade
                              tmp-previesp-aux.int-3          = wk-reg2.cd-tit-cert-esp
                              tmp-previesp-aux.dt-atualizacao = today
                              tmp-previesp-aux.cd-userid      = v_cod_usuar_corren.
                     END.
            end.                                                                                                                   
       when "3"                                                                                                                    
       then do:     
               /* endpres? */
               
                                 
    /*            find last wk-reg3 no-lock no-error.                     */
    /*            if   avail wk-reg3                                      */
    /*            then nr-seq-endereco-aux = wk-reg3.nr-seq-endereco + 1. */
    /*            else nr-seq-endereco-aux = 1.                           */

               find last tmp-endpres-aux where tmp-endpres-aux.cd-unidade   = tmp-preserv-aux.cd-unidade
                                           and tmp-endpres-aux.cd-prestador = tmp-preserv-aux.cd-prestador no-lock no-error.
    
               if avail tmp-endpres-aux then nr-seq-endereco-aux = tmp-endpres-aux.nr-seq-endereco + 1.
                                        else nr-seq-endereco-aux = 1.
                                                                                                                                   
               create wk-reg3.                                                                                                     
               assign wk-reg3.nr-seq-endereco   = nr-seq-endereco-aux                                                              
                      wk-reg3.en-endereco       = substring(c-dados,02,40)                                                         
                      wk-reg3.en-bairro         = substring(c-dados,42,15)                                                         
                      wk-reg3.cd-cidade         = int(substring(c-dados,57,6)) /*cd-cidade-aux*/
                      wk-reg3.en-cep            = substring(c-dados,63,08)                                                         
                      wk-reg3.en-uf             = substring(c-dados,71,02)                                                         
                      wk-reg3.nr-fone [1]       = substring(c-dados,73,12)                                                         
                      wk-reg3.nr-fone [2]       = substring(c-dados,85,12)                                                         
                      wk-reg3.nr-ramal[1]       = substring(c-dados,97,05)                                                         
                      wk-reg3.nr-ramal[2]       = substring(c-dados,102,5)                                                         
                      wk-reg3.hr-man-ent        = substring(c-dados,107,4)                                                         
                      wk-reg3.hr-man-sai        = substring(c-dados,111,4)                                                         
                      wk-reg3.hr-tar-ent        = substring(c-dados,115,4)                                                         
                      wk-reg3.hr-tar-sai        = substring(c-dados,119,4)
                      wk-reg3.en-complemento    = trim(substr(c-dados,288,15)).

               create tmp-endpres-aux.                                                                                                     
               assign tmp-endpres-aux.cd-unidade        = tmp-preserv-aux.cd-unidade   /* c-cd-unidade   */
                      tmp-endpres-aux.cd-prestador      = tmp-preserv-aux.cd-prestador /* c-cd-prestador */
                      tmp-endpres-aux.nr-seq-endereco   = nr-seq-endereco-aux
                      tmp-endpres-aux.en-endereco       = trim(substring(c-dados,02,40))
                      tmp-endpres-aux.en-bairro         = trim(substring(c-dados,42,15))                                                         
                      tmp-endpres-aux.cd-cidade         = int(substring(c-dados,57,6)) /*cd-cidade-aux*/
                      tmp-endpres-aux.en-cep            = substring(c-dados,63,08)                                                         
                      tmp-endpres-aux.en-uf             = substring(c-dados,71,02)                                                         
                      tmp-endpres-aux.nr-fone [1]       = substring(c-dados,73,12)                                                         
                      tmp-endpres-aux.nr-fone [2]       = substring(c-dados,85,12)                                                         
                      tmp-endpres-aux.nr-ramal[1]       = substring(c-dados,97,05)                                                         
                      tmp-endpres-aux.nr-ramal[2]       = substring(c-dados,102,5)                                                         
                      tmp-endpres-aux.hr-man-ent        = substring(c-dados,107,4)                                                         
                      tmp-endpres-aux.hr-man-sai        = substring(c-dados,111,4)                                                         
                      tmp-endpres-aux.hr-tar-ent        = substring(c-dados,115,4)                                                         
                      tmp-endpres-aux.hr-tar-sai        = substring(c-dados,119,4)
                      tmp-endpres-aux.char-3 /*en-complemento*/ = trim(substr(c-dados,288,15)).
               
               if substring(c-dados,123,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[1] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[1] = false.                                                                        
               assign wk-reg3.hr-man-ent-segunda = substring(c-dados,124,4)                                                        
                      wk-reg3.hr-man-sai-segunda = substring(c-dados,128,4)                                                        
                      wk-reg3.hr-tar-ent-segunda = substring(c-dados,132,4)                                                        
                      wk-reg3.hr-tar-sai-segunda = substring(c-dados,136,4).                
    
               assign tmp-endpres-aux.lg-dias-trab[1]    = wk-reg3.lg-dias-trab[1]
                      tmp-endpres-aux.hr-man-ent-segunda = wk-reg3.hr-man-ent-segunda 
                      tmp-endpres-aux.hr-man-sai-segunda = wk-reg3.hr-man-sai-segunda 
                      tmp-endpres-aux.hr-tar-ent-segunda = wk-reg3.hr-tar-ent-segunda 
                      tmp-endpres-aux.hr-tar-sai-segunda = wk-reg3.hr-tar-sai-segunda. 
    
    
               if substring(c-dados,140,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[2] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[2] = false. 
               assign wk-reg3.hr-man-ent-terca   = substring(c-dados,141,4)                                                        
                      wk-reg3.hr-man-sai-terca   = substring(c-dados,145,4)                                                        
                      wk-reg3.hr-tar-ent-terca   = substring(c-dados,149,4)                                                        
                      wk-reg3.hr-tar-sai-terca   = substring(c-dados,153,4). 
    
               assign tmp-endpres-aux.lg-dias-trab[2]    = wk-reg3.lg-dias-trab[2]
                      tmp-endpres-aux.hr-man-ent-terca = wk-reg3.hr-man-ent-terca 
                      tmp-endpres-aux.hr-man-sai-terca = wk-reg3.hr-man-sai-terca 
                      tmp-endpres-aux.hr-tar-ent-terca = wk-reg3.hr-tar-ent-terca 
                      tmp-endpres-aux.hr-tar-sai-terca = wk-reg3.hr-tar-sai-terca. 
    
    
    
               if substring(c-dados,157,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[3] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[3] = false. 
               assign wk-reg3.hr-man-ent-quarta  = substring(c-dados,158,4)                                                        
                      wk-reg3.hr-man-sai-quarta  = substring(c-dados,162,4)                                                        
                      wk-reg3.hr-tar-ent-quarta  = substring(c-dados,166,4)                                                        
                      wk-reg3.hr-tar-sai-quarta  = substring(c-dados,170,4).    
    
               assign tmp-endpres-aux.lg-dias-trab[3]    = wk-reg3.lg-dias-trab[3]
                      tmp-endpres-aux.hr-man-ent-quarta = wk-reg3.hr-man-ent-quarta 
                      tmp-endpres-aux.hr-man-sai-quarta = wk-reg3.hr-man-sai-quarta 
                      tmp-endpres-aux.hr-tar-ent-quarta = wk-reg3.hr-tar-ent-quarta 
                      tmp-endpres-aux.hr-tar-sai-quarta = wk-reg3.hr-tar-sai-quarta. 
    
    
               if substring(c-dados,174,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[4] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[4] = false.    
    
               assign wk-reg3.hr-man-ent-quinta  = substring(c-dados,175,4)                                                        
                      wk-reg3.hr-man-sai-quinta  = substring(c-dados,179,4)                                                        
                      wk-reg3.hr-tar-ent-quinta  = substring(c-dados,183,4)                                                        
                      wk-reg3.hr-tar-sai-quinta  = substring(c-dados,187,4).  
    
               assign tmp-endpres-aux.lg-dias-trab[4]    = wk-reg3.lg-dias-trab[4]
                      tmp-endpres-aux.hr-man-ent-quinta = wk-reg3.hr-man-ent-quinta 
                      tmp-endpres-aux.hr-man-sai-quinta = wk-reg3.hr-man-sai-quinta 
                      tmp-endpres-aux.hr-tar-ent-quinta = wk-reg3.hr-tar-ent-quinta 
                      tmp-endpres-aux.hr-tar-sai-quinta = wk-reg3.hr-tar-sai-quinta. 
    
    
               if substring(c-dados,191,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[5] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[5] = false.        
               assign wk-reg3.hr-man-ent-sexta   = substring(c-dados,192,4)                                                        
                      wk-reg3.hr-man-sai-sexta   = substring(c-dados,196,4)                                                        
                      wk-reg3.hr-tar-ent-sexta   = substring(c-dados,200,4)                                                        
                      wk-reg3.hr-tar-sai-sexta   = substring(c-dados,204,4).   
    
               assign tmp-endpres-aux.lg-dias-trab[5]    = wk-reg3.lg-dias-trab[5]
                      tmp-endpres-aux.hr-man-ent-sexta = wk-reg3.hr-man-ent-sexta 
                      tmp-endpres-aux.hr-man-sai-sexta = wk-reg3.hr-man-sai-sexta 
                      tmp-endpres-aux.hr-tar-ent-sexta = wk-reg3.hr-tar-ent-sexta 
                      tmp-endpres-aux.hr-tar-sai-sexta = wk-reg3.hr-tar-sai-sexta. 
    
               if substring(c-dados,208,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[6] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[6] = false.                                                                        
               assign wk-reg3.hr-man-ent-sabado  = substring(c-dados,209,4)                                                        
                      wk-reg3.hr-man-sai-sabado  = substring(c-dados,213,4)                                                        
                      wk-reg3.hr-tar-ent-sabado  = substring(c-dados,217,4)                                                        
                      wk-reg3.hr-tar-sai-sabado  = substring(c-dados,221,4). 
    
               assign tmp-endpres-aux.lg-dias-trab[6]    = wk-reg3.lg-dias-trab[6]
                      tmp-endpres-aux.hr-man-ent-sabado = wk-reg3.hr-man-ent-sabado 
                      tmp-endpres-aux.hr-man-sai-sabado = wk-reg3.hr-man-sai-sabado 
                      tmp-endpres-aux.hr-tar-ent-sabado = wk-reg3.hr-tar-ent-sabado 
                      tmp-endpres-aux.hr-tar-sai-sabado = wk-reg3.hr-tar-sai-sabado. 
    
               if substring(c-dados,225,1) = "S"                                                                                   
               then assign wk-reg3.lg-dias-trab[7] = true.                                                                         
               else assign wk-reg3.lg-dias-trab[7] = false.                                                                        
               assign wk-reg3.hr-man-ent-domingo = substring(c-dados,226,4)                                                        
                      wk-reg3.hr-man-sai-domingo = substring(c-dados,230,4)                                                        
                      wk-reg3.hr-tar-ent-domingo = substring(c-dados,234,4)                                                        
                      wk-reg3.hr-tar-sai-domingo = substring(c-dados,238,4).  
    
               assign tmp-endpres-aux.lg-dias-trab[7]    = wk-reg3.lg-dias-trab[7]
                      tmp-endpres-aux.hr-man-ent-domingo = wk-reg3.hr-man-ent-domingo 
                      tmp-endpres-aux.hr-man-sai-domingo = wk-reg3.hr-man-sai-domingo 
                      tmp-endpres-aux.hr-tar-ent-domingo = wk-reg3.hr-tar-ent-domingo 
                      tmp-endpres-aux.hr-tar-sai-domingo = wk-reg3.hr-tar-sai-domingo. 
    
    
               if substring(c-dados,242,1) = "S"                                                                                   
               then assign wk-reg3.lg-malote = true.                                                                               
               else assign wk-reg3.lg-malote = false.                                                                              
               if substring(c-dados,243,1) = "S"                                                                                   
               then assign wk-reg3.lg-recebe-corresp = true.                                                                       
               else assign wk-reg3.lg-recebe-corresp = false.                                                                      
               assign wk-reg3.in-tipo-endereco    = int(substring(c-dados,244,1))                                                  
                      wk-reg3.cd-cnes             = int(substring(c-dados,245,7))                                                  
                      wk-reg3.nr-leitos-tot       = substring(c-dados,252,6)                                                       
                      wk-reg3.nr-leitos-contrat   = substring(c-dados,258,6)                                                       
                      wk-reg3.nr-leitos-psiquiat  = substring(c-dados,264,6)                                                       
                      wk-reg3.nr-uti-adulto       = substring(c-dados,270,6)                                                       
                      wk-reg3.nr-uti-neonatal     = substring(c-dados,276,6)                                                       
                      wk-reg3.nr-uti-pediatria    = substring(c-dados,282,6)                                                       
                      wk-reg3.nr-uti-neo-interm-neo  = substring(c-dados,323,6)                                                    
                      wk-reg3.nr-cgc-cpf          = substring(c-dados,304,19).                                                     
               if substring(c-dados,303,1) = "S"                                                                                   
               then assign wk-reg3.lg-filial = yes.                                                                                
               else assign wk-reg3.lg-filial = no.                                                                                 
                                                                                                                                   
               assign wk-reg3.nm-end-web                   = substring(c-dados,329,50)                                             
                      wk-reg3.nr-leitos-hosp-dia           = int(substring(c-dados,379,06))                                        
                      wk-reg3.nr-leitos-tot-psic-n-uti     = int(substring(c-dados,385,06))                                        
                      wk-reg3.nr-leitos-tot-cirur-n-uti    = int(substring(c-dados,391,06))                                        
                      wk-reg3.nr-leitos-tot-ped-n-uti      = int(substring(c-dados,397,06))                                        
                      wk-reg3.nr-leito-tot-obst-n-uti      = int(substring(c-dados,403,06))                                        
                      wk-reg3.nm-latitue                   = substring(c-dados,409,20)                                             
                      wk-reg3.nm-longitude                 = substring(c-dados,429,20)                                             
                      wk-reg3.nr-uti-neo-interm            = substring(c-dados,449,06).    
    
    
              assign tmp-endpres-aux.lg-malote                 = wk-reg3.lg-malote
                     tmp-endpres-aux.lg-recebe-corresp         = wk-reg3.lg-recebe-corresp 
                     tmp-endpres-aux.dec-2                     = wk-reg3.in-tipo-endereco    
                     tmp-endpres-aux.char-1                    = string(wk-reg3.cd-cnes,"9999999")             
                     tmp-endpres-aux.int-1                     = int(wk-reg3.nr-leitos-tot     )  
                     tmp-endpres-aux.int-2                     = int(wk-reg3.nr-leitos-contrat )  
                     tmp-endpres-aux.int-3                     = int(wk-reg3.nr-leitos-psiquiat)  
                     tmp-endpres-aux.int-4                     = int(wk-reg3.nr-uti-adulto     )  
                     tmp-endpres-aux.int-5                     = int(wk-reg3.nr-uti-neonatal   )  
                     tmp-endpres-aux.dec-1                     = dec(wk-reg3.nr-uti-pediatria  )  
    /*                   tmp-endpres-aux.nr-uti-neo-interm-neo     = wk-reg3.nr-uti-neo-interm-neo */
                      tmp-endpres-aux.dec-4                     = if wk-reg3.lg-filial then dec(wk-reg3.nr-cgc-cpf)           
                                                                                       else 0                           
                      tmp-endpres-aux.log-1                     = wk-reg3.lg-filial                                     
                      tmp-endpres-aux.nm-end-web                = wk-reg3.nm-end-web                                    
    /*                   tmp-endpres-aux.nr-leitos-hosp-dia        = wk-reg3.nr-leitos-hosp-dia */
    /*                   tmp-endpres-aux.nr-leitos-tot-psic-n-uti  = wk-reg3.nr-leitos-tot-psic-n-uti */
    /*                   tmp-endpres-aux.nr-leitos-tot-cirur-n-uti = wk-reg3.nr-leitos-tot-cirur-n-uti */
    /*                   tmp-endpres-aux.nr-leitos-tot-ped-n-uti   = wk-reg3.nr-leitos-tot-ped-n-uti */
    /*                   tmp-endpres-aux.nr-leito-tot-obst-n-uti   = wk-reg3.nr-leito-tot-obst-n-uti */
    /*                   tmp-endpres-aux.nm-latitue                = wk-reg3.nm-latitue */
    /*                   tmp-endpres-aux.nm-longitude              = wk-reg3.nm-longitude */
                      tmp-endpres-aux.dec-5                     = dec(wk-reg3.nr-uti-neo-interm)
                      tmp-endpres-aux.dt-atualizacao            = today
                      tmp-endpres-aux.cd-userid                 = v_cod_usuar_corren.
    
              create tmp-prestdor-ender-aux.
              assign tmp-prestdor-ender-aux.cdn-unid-prestdor             = tmp-preserv-aux.cd-unidade   /* c-cd-unidade   */
                     tmp-prestdor-ender-aux.cdn-prestdor                  = tmp-preserv-aux.cd-prestador /* c-cd-prestador */
                     tmp-prestdor-ender-aux.num-seq-ender                 = wk-reg3.nr-seq-endereco
                     tmp-prestdor-ender-aux.num-acomoda-tot-clini         = wk-reg3.nr-leitos-tot-clin-n-uti
    	             tmp-prestdor-ender-aux.num-acomoda-cirurgc           = wk-reg3.nr-leitos-tot-cirur-n-uti
                     tmp-prestdor-ender-aux.num-acomoda-tot-obstr         = wk-reg3.nr-leito-tot-obst-n-uti
                     tmp-prestdor-ender-aux.num-acomoda-tot-pediat        = wk-reg3.nr-leitos-tot-ped-n-uti
                     tmp-prestdor-ender-aux.num-acomoda-tot-psiquiat      = wk-reg3.nr-leitos-tot-psic-n-uti
                     tmp-prestdor-ender-aux.cod-latitude 	              = wk-reg3.nm-latitue
                     tmp-prestdor-ender-aux.cod-longitude 	              = wk-reg3.nm-longitude
                     tmp-prestdor-ender-aux.num-acomoda-tot-clini-2       = int(wk-reg3.nr-leitos-tot) /*num-acomoda-tot*/
                     tmp-prestdor-ender-aux.num-acomoda-psiquiat-uti      = int(wk-reg3.nr-leitos-psiq)
                     tmp-prestdor-ender-aux.num-acomoda-neonat-uti        = int(wk-reg3.nr-uti-neonatal)
                     tmp-prestdor-ender-aux.num-acomoda-contrat-uti       = int(wk-reg3.nr-leitos-contrat)
                     tmp-prestdor-ender-aux.num-acomoda-normal-uti        = int(wk-reg3.nr-uti-adulto)
                     tmp-prestdor-ender-aux.num-acomoda-pediat-uti        = int(wk-reg3.nr-uti-pediatria)
                     tmp-prestdor-ender-aux.num-acomoda-interm-neonat-uti = int(wk-reg3.nr-uti-neo-interm-neo)
                     tmp-prestdor-ender-aux.num-acomoda-hos-dia	          = wk-reg3.nr-leitos-hosp-dia
                     tmp-prestdor-ender-aux.num-livre-1                   = int(wk-reg3.nr-uti-neo-interm)
                     tmp-prestdor-ender-aux.dat-ult-atualiz               = today
                     tmp-prestdor-ender-aux.cod-usuar-ult-atualiz         = v_cod_usuar_corren.
            end.                                                                                                                   
       when "4"                                                                                                                    
       then do:                                                                                                                     
              create wk-reg4.
              assign wk-reg4.cod-instit =  substring(c-dados,2,5)                                                                  
                     wk-reg4.cdn-nivel  = int(substr(c-dados,7,1)).                                                                
                                                                                                                                   
              if substring(c-dados,8,1) = "S"                                                                                      
              then assign wk-reg4.lg-autoriz-divulga = yes.                                                                        
              else assign wk-reg4.lg-autoriz-divulga = no.                                                                         
    
              create tmp-prest-inst-aux.
              assign tmp-prest-inst-aux.cd-unidade            = tmp-preserv-aux.cd-unidade   /* c-cd-unidade   */
                     tmp-prest-inst-aux.cd-prestador          = tmp-preserv-aux.cd-prestador /* c-cd-prestador */
                     tmp-prest-inst-aux.cod-instit            = caps(wk-reg4.cod-instit)
                     tmp-prest-inst-aux.cdn-nivel             = wk-reg4.cdn-nivel
                     tmp-prest-inst-aux.log-livre-1           = wk-reg4.lg-autoriz-divulga
                     tmp-prest-inst-aux.dat-ult-atualiz       = today
                     tmp-prest-inst-aux.cod-usuar-ult-atualiz = v_cod_usuar_corren.
    
            end.                                                                                                                   
       when "5"              
       then do:
              
    
              create wk-reg5.                                                                                                      
              assign wk-reg5.divulga-obs = trim(substring(c-dados,2,length(trim(c-dados)) - 1)).                                   
    
              create tmp-prestdor-obs-aux.
              assign tmp-prestdor-obs-aux.cdn-unid-prestdor     = tmp-preserv-aux.cd-unidade   /* c-cd-unidade   */
                     tmp-prestdor-obs-aux.cdn-prestdor          = tmp-preserv-aux.cd-prestador /* c-cd-prestador */
                     tmp-prestdor-obs-aux.des-obs               = wk-reg5.divulga-obs
                     tmp-prestdor-obs-aux.dat-ult-atualiz       = today
                     tmp-prestdor-obs-aux.cod-usuar-ult-atualiz = v_cod_usuar_corren.
            end.                                                                                                                   
    end case.                                                                                                                       



end procedure.

procedure importa-prestador-migracao:
    def var cd-fornecedor-aux like preserv.cd-contratante no-undo.
    def var lg-erro-par       as log                      no-undo.
/*     define temp-table tmp-preserv-aux like preserv.                       */
/*     define temp-table tmp-previesp-aux no-undo like previesp.             */
/*     define temp-table tmp-endpres-aux no-undo like endpres.               */
/*     define temp-table tmp-prestdor-ender-aux no-undo like prestdor-ender. */
/*     define temp-table tmp-prest-inst-aux no-undo like prest-inst.         */
/*     define temp-table tmp-prestdor-obs-aux no-undo like prestdor-obs.     */


    {hdp/hdrunpersis.i "api/api-administrativeintegration.p" "h-apiadministrativeintegration-aux"}

    for each tmp-preserv-aux no-lock:

        IF CAN-FIND(FIRST preserv
                    WHERE preserv.cd-unidade = tmp-preserv-aux.cd-unidade
                      AND preserv.cd-prestador = tmp-preserv-aux.cd-prestador)
        THEN NEXT. /* PRESTADOR JA CADASTRADO */

        create preserv.
        buffer-copy tmp-preserv-aux to preserv.


        for each tmp-previesp-aux where tmp-previesp-aux.cd-unidade   = tmp-preserv-aux.cd-unidade
                                    and tmp-previesp-aux.cd-prestador = tmp-preserv-aux.cd-prestador no-lock:

            create previesp.
            buffer-copy tmp-previesp-aux to previesp.


        end.

        for each tmp-endpres-aux where tmp-endpres-aux.cd-unidade   = tmp-preserv-aux.cd-unidade
                                   and tmp-endpres-aux.cd-prestador = tmp-preserv-aux.cd-prestador no-lock:

            create endpres.
            buffer-copy tmp-endpres-aux to endpres.

        
        end.

        for each tmp-prestdor-ender-aux where tmp-prestdor-ender-aux.cdn-unid-prestdor   = tmp-preserv-aux.cd-unidade
                                          and tmp-prestdor-ender-aux.cdn-prestdor        = tmp-preserv-aux.cd-prestador no-lock:

            create prestdor-ender.
            buffer-copy tmp-prestdor-ender-aux to prestdor-ender.


        end.

        for each tmp-prest-inst-aux where tmp-prest-inst-aux.cd-unidade   = tmp-preserv-aux.cd-unidade
                                      and tmp-prest-inst-aux.cd-prestador = tmp-preserv-aux.cd-prestador no-lock:

            create prest-inst.
            buffer-copy tmp-prest-inst-aux to prest-inst.


        end.

        for each tmp-prestdor-obs-aux where tmp-prestdor-obs-aux.cdn-unid-prestdor = tmp-preserv-aux.cd-unidade
                                        and tmp-prestdor-obs-aux.cdn-prestdor      = tmp-preserv-aux.cd-prestador no-lock:

            create prestdor-obs.
            buffer-copy tmp-prestdor-obs-aux to prestdor-obs.


        end.

/*         create tmpContact.                                              */
/*         if tmp-rtapi044.in-tipo-pessoa = "F"                            */
/*         then assign tmpContact.ds-contato = tmp-rtapi044.nr-telefone[1] */
/*                     tmpContact.tp-contato = 2. /*telefone residencial*/ */
/*         else assign tmpContact.ds-contato = tmp-rtapi044.nr-telefone[1] */
/*                     tmpContact.tp-contato = 1. /*telefone comercial*/   */

        empty temp-table tmpDemographic.
        empty temp-table tmpCompany.
        empty temp-table tmpAddress.
        empty temp-table tmpConfigFileAuditory.

        run cria-endereco(input preserv.en-rua,
                          input preserv.en-bairro,
                          input preserv.cd-cidade,
                          input preserv.en-cep,
                          input preserv.en-uf,
                          input yes,
                          input yes).

        run cria-contato.

        create tmpConfigFileAuditory.
        assign tmpConfigFileAuditory.nm-usuario-sistema = v_cod_usuar_corren.

        
        /* retirada essa chamada pois na migracao as pessoas sao criadas em processo anterior.
        if tmp-preserv-aux.in-tipo-pessoa = "F" 
        then run cria-pessoa-fisica.
        else run cria-pessoa-juridica.
        */
        run grava-histprest(input  "INC",
                            output lg-erro-par).


        /*chama a rotina de integra‡Æo do prestador*/
        run providerAdministrativeIntegrationEMS in h-apiadministrativeintegration-aux(input  preserv.cd-unidade,
                                                                                       input  preserv.cd-prestador,
                                                                                       input  tmp-preserv-aux.cd-grupo-fornecedor,
                                                                                       output cd-fornecedor-aux,
                                                                                       input-output table rowErrors).


        if cd-fornecedor-aux = 0
        then assign preserv.cd-contratante = tmp-preserv-aux.cd-contratante.
        else assign preserv.cd-contratante = cd-fornecedor-aux.

        assign tt-prest-gravados = tt-prest-gravados + 1.
        run imprime-prestador-migracao.
    end.

    {hdp/hddelpersis.i}


end procedure.

procedure cria-endereco:
    def input param en-endereco-par     like tmpAddress.ds-endereco     no-undo.                                                             
    def input param en-bairro-par       like tmpAddress.ds-bairro       no-undo.
    def input param cd-cidade-par       like tmpAddress.cd-cidade       no-undo.
    def input param en-cep-par          like tmpAddress.cd-cep          no-undo.
    def input param en-uf-par           like tmpAddress.cd-uf           no-undo.
    def input param lg-end-cobranca-par like tmpAddress.lg-end-cobranca no-undo.
    def input param lg-principal-par    like tmpAddress.lg-principal    no-undo.
                      
    create tmpAddress. 
    assign tmpAddress.ds-endereco      = en-endereco-par       
           tmpAddress.ds-bairro        = en-bairro-par         
           tmpAddress.cd-cep           = en-cep-par            
           tmpAddress.cd-uf            = en-uf-par             
           tmpAddress.cd-cidade        = cd-cidade-par         
           tmpAddress.lg-end-cobranca  = lg-end-cobranca-par   
           tmpAddress.lg-principal     = lg-principal-par
           tmpAddress.in-tipo-endereco = 1. /* Cria fixo como endereco residencial, utilizando endereco que consta na preserv */


end procedure.                                             

procedure cria-contato:
    def var i as int init 1.


    do while i >= 2:
        create tmpContact.
        assign tmpContact.ds-contato = preserv.nr-telefone[i]
               tmpContact.tp-contato = if preserv.in-tipo-pessoa = "F" then 2
                                                                       else 1.
    end.
    
end procedure.

procedure cria-pessoa-fisica:

    create tmpDemographic.
    assign tmpDemographic.cd-unidade               = tmp-preserv-aux.cd-unidade                              
           tmpDemographic.cd-prestador             = tmp-preserv-aux.cd-prestador                            
           tmpDemographic.cd-userid                = v_cod_usuar_corren                                                  
           tmpDemographic.id-pessoa                = tmp-preserv-aux.id-pessoa
           tmpDemographic.nm-pessoa                = tmp-preserv-aux.nm-prestador                            
           tmpDemographic.cd-cpf                   = tmp-preserv-aux.nr-cgc-cpf
           tmpDemographic.dt-nascimento            = tmp-preserv-aux.dt-nascimento /* input frame cg0110b preserv.dt-nascimento*/
           tmpDemographic.lg-sexo                  = tmp-preserv-aux.lg-sexo
           tmpDemographic.nr-identidade            = tmp-preserv-aux.nr-identidade
           tmpDemographic.uf-emissor-ident         = tmp-preserv-aux.en-uf
           tmpDemographic.nm-cartao                = ""                                                                  
           tmpDemographic.nm-internacional         = ""                                                                  
           tmpDemographic.ds-nacionalidade         = tmp-preserv-aux.ds-nacionalidade           
           tmpDemographic.ds-natureza-doc          = tmp-preserv-aux.ds-natureza-doc            
           tmpDemographic.nr-pis-pasep             = tmp-preserv-aux.nr-pis-pasep
           tmpDemographic.ds-orgao-emissor-ident   = tmp-preserv-aux.ds-orgao-emissor-ident
           tmpDemographic.nm-pais-emissor-ident    = tmp-preserv-aux.nm-pais
           tmpDemographic.dt-emissao-ident         = tmp-preserv-aux.dt-emissao-doc                   
           tmpDemographic.in-estado-civil          = 1
           tmpDemographic.nm-mae                   = tmp-preserv-aux.nm-mae.
    
    {hdp/hdrunpersis.i "bosau/bosaudemographic.p" "h-bosauDemographic-aux"}
    
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
           if error-status:num-messages = 0
           then message "Ocorreram erros na execucao da bosauDemographic"
                    view-as alert-box title " Atencao !!! ".
           else message "Ocorreram erros na execucao da bosauDemographic" skip 
                        substring(error-status:get-message(error-status:num-messages),1,175)
                    view-as alert-box title " Atencao !!! ".
    
/*            assign lg-erro-par = yes. */
           return.
         end.
    find first tmpDemographic exclusive-lock no-error.
    if avail tmpDemographic then preserv.id-pessoa = tmpDemographic.id-pessoa.





end procedure.

procedure cria-pessoa-juridica:

    create tmpCompany.

    assign tmpCompany.id-pessoa             = tmp-preserv-aux.id-pessoa
           tmpCompany.nm-pessoa             = tmp-preserv-aux.nm-prestador
           tmpCompany.cd-cnpj               = trim(tmp-preserv-aux.nr-cgc-cpf)
           tmpCompany.dt-fundacao           = tmp-preserv-aux.dt-nascimento  /* input frame cg0110b preserv.dt-nascimento*/
           tmpCompany.nm-cartao             = ""
           tmpCompany.lg-prestador          = YES.

    /* --------------------------------------------------------------------- */
    {hdp/hdrunpersis.i "bosau/bosaucompany.p" "h-bosauCompany-aux"}
    
    run syncCompany in h-bosauCompany-aux(input        table tmpContact,
                                          input        table tmpAddress,
                                          input        table tmpAttachment,
                                          input-output table tmpCompany,
                                          input yes,
                                          input-output table rowErrors) no-error.
	
    if error-status:error
    then do:
           if error-status:num-messages = 0
           then message "Ocorreram erros na execucao da bosauCompany"
                    view-as alert-box title " Atencao !!! ".
           else message "Ocorreram erros na execucao da bosauCompany" skip 
                        substring(error-status:get-message(error-status:num-messages),1,175)
                    view-as alert-box title " Atencao !!! ".

/*            assign lg-erro-par = yes. */
           return.
         end.

    find first tmpCompany exclusive-lock no-error.
    if avail tmpCompany then preserv.id-pessoa = tmpCompany.id-pessoa.



end procedure.

procedure imp-relat-acertos-migracao:

    put stream s-acertos
        skip(1)
        "======================================================"
        " PRESTADORES INCLUIDOS "
        "======================================================" 
        skip.

    for each tmp-preserv-aux no-lock:

        assign tt-prest-inc-aux = tt-prest-inc-aux + 1.

        run imp-prestador-migracao.

    end.
end procedure.

procedure imp-prestador-migracao:

    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-20cpp-ativa-aux.
    &endif.

    /* --------------------------------------- REGISTROS PRESERV GRAVADA --- */
    put stream s-acertos skip(1).
    
    /* ativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-ativa-aux.
    &endif.
    
    put stream s-acertos "Registro Nro. 1 - PRESTADORES" skip.
    
    /* desativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-desat-aux.
    &endif.

    display stream s-acertos
            tmp-preserv-aux.cd-unidade     @ c-cd-unidade    
            tmp-preserv-aux.cd-prestador   @ c-cd-prestador  
            tmp-preserv-aux.nm-prestador   @ c-nm-prestador  
            tmp-preserv-aux.nome-abrev     @ c-nome-abrev    
            tmp-preserv-aux.in-tipo-pessoa @ c-in-tipo-pessoa
            tmp-preserv-aux.nr-cgc-cpf     @ c-cgc-cpf       
            with frame f-lista-1.

    down with frame f-lista-1.
    
    /* ------------------------------------- REGISTROS PREVIESP GRAVADOS --- */
    put stream s-acertos skip(1).

    /* ativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-ativa-aux.
    &endif

    put stream s-acertos
               "   Registro Nro. 2 - PRESTADOR X VINCULO X ESPECIALIDADE" skip.

    /* desativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-desat-aux.
    &endif

    for each tmp-previesp-aux where tmp-previesp-aux.cd-unidade   = tmp-preserv-aux.cd-unidade
                                and tmp-previesp-aux.cd-prestador = tmp-preserv-aux.cd-prestador
                                no-lock:

        display stream s-acertos
                tmp-previesp-aux.cd-vinculo              @ wk-reg2.cd-vinculo
                tmp-previesp-aux.cd-especialid           @ wk-reg2.cd-especialid
                tmp-previesp-aux.lg-principal            @ wk-reg2.lg-principal
                tmp-previesp-aux.lg-considera-qt-vinculo @ wk-reg2.lg-considera-qt-vinculo
                with frame f-lista-acertos-2.

        down with frame f-lista-acertos-2.

    end.

    /* --------------------------------------- REGISTRO PRESERV GRAVADOS --- */
    find first tmp-endpres-aux 
         where tmp-endpres-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
           and tmp-endpres-aux.cd-prestador = tmp-preserv-aux.cd-prestador
               no-lock no-error.
    if avail tmp-endpres-aux
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 3 - ENDERECOS DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
     
    for each tmp-endpres where tmp-endpres-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
                           and tmp-endpres-aux.cd-prestador = tmp-preserv-aux.cd-prestador
                               no-lock:

        display stream s-acertos
                tmp-endpres-aux.en-endereco @ wk-reg3.en-endereco
                tmp-endpres-aux.en-bairro   @ wk-reg3.en-bairro
                tmp-endpres-aux.en-cep      @ wk-reg3.en-cep
                tmp-endpres-aux.en-uf       @ wk-reg3.en-uf
                with frame f-lista-acertos-3.

        down with frame f-lista-acertos-3.
    end.

    /* --------------------------------------- REGISTRO PREST-INST GRAVADOS --- */
    find first tmp-prest-inst-aux
         where tmp-prest-inst-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
           and tmp-prest-inst-aux.cd-prestador = tmp-preserv-aux.cd-prestador
               no-lock no-error.
    if avail tmp-prest-inst-aux
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 4 - INSTITUICOES ACREDITADORAS DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
    
    for each tmp-prest-inst-aux
       where tmp-prest-inst-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
         and tmp-prest-inst-aux.cd-prestador = tmp-preserv-aux.cd-prestador
             no-lock:

        display stream s-acertos
                tmp-prest-inst-aux.cod-instit @ wk-reg4.cod-instit
                tmp-prest-inst-aux.cdn-nivel  @ wk-reg4.cdn-nivel
                tmp-prest-inst-aux.log-livre-1 @ wk-reg4.lg-autoriz-divulga
                with frame f-lista-acertos-4.

        down with frame f-lista-acertos-4.
    end.
    
    /* --------------------------------------- REGISTRO PREST-OBS GRAVADOS --- */
    find first tmp-prestdor-obs-aux
         where tmp-prestdor-obs-aux.cdn-unid-prestdor   = tmp-preserv-aux.cd-unidade  
           and tmp-prestdor-obs-aux.cdn-prestdor = tmp-preserv-aux.cd-prestador
               no-lock no-error.
    if avail tmp-prestdor-obs-aux
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 5 - OBSERVACOES DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
    
    for each tmp-prestdor-obs-aux
       where tmp-prestdor-obs-aux.cdn-unid-prestdor   = tmp-preserv-aux.cd-unidade  
         and tmp-prestdor-obs-aux.cdn-prestdor = tmp-preserv-aux.cd-prestador
             no-lock:

        display stream s-acertos
                substring(tmp-prestdor-obs-aux.des-obs,1,20) @ wk-reg5.divulga-obs
                with frame f-lista-acertos-5.

        down with frame f-lista-acertos-5.
    end.
    
end procedure.

procedure imprime-prestador-migracao:

    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-20cpp-ativa-aux.
    &endif.

    /* --------------------------------------- REGISTROS PRESERV GRAVADA --- */
    put stream s-acertos skip(1).
    
    /* ativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-ativa-aux.
    &endif.
    
    put stream s-acertos "Registro Nro. 1 - PRESTADORES" skip.
    
    /* desativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-desat-aux.
    &endif.

    display stream s-acertos
            tmp-preserv-aux.cd-unidade     @ c-cd-unidade    
            tmp-preserv-aux.cd-prestador   @ c-cd-prestador  
            tmp-preserv-aux.nm-prestador   @ c-nm-prestador  
            tmp-preserv-aux.nome-abrev     @ c-nome-abrev    
            tmp-preserv-aux.in-tipo-pessoa @ c-in-tipo-pessoa
            tmp-preserv-aux.nr-cgc-cpf     @ c-cgc-cpf       
            with frame f-lista-1.

    down with frame f-lista-1.
    
    /* ------------------------------------- REGISTROS PREVIESP GRAVADOS --- */
    put stream s-acertos skip(1).

    /* ativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-ativa-aux.
    &endif

    put stream s-acertos
               "   Registro Nro. 2 - PRESTADOR X VINCULO X ESPECIALIDADE" skip.

    /* desativa negrito */
    &if "{&window-system}" = "TTY"
    &then put stream s-acertos control ds-negrit-desat-aux.
    &endif

    for each tmp-previesp-aux where tmp-previesp-aux.cd-unidade   = tmp-preserv-aux.cd-unidade
                                and tmp-previesp-aux.cd-prestador = tmp-preserv-aux.cd-prestador
                                no-lock:

        display stream s-acertos
                tmp-previesp-aux.cd-vinculo              @ wk-reg2.cd-vinculo
                tmp-previesp-aux.cd-especialid           @ wk-reg2.cd-especialid
                tmp-previesp-aux.lg-principal            @ wk-reg2.lg-principal
                tmp-previesp-aux.lg-considera-qt-vinculo @ wk-reg2.lg-considera-qt-vinculo
                with frame f-lista-acertos-2.

        down with frame f-lista-acertos-2.

    end.

    /* --------------------------------------- REGISTRO PRESERV GRAVADOS --- */
    find first tmp-endpres-aux 
         where tmp-endpres-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
           and tmp-endpres-aux.cd-prestador = tmp-preserv-aux.cd-prestador
               no-lock no-error.
    if avail tmp-endpres-aux
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 3 - ENDERECOS DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
     
    for each tmp-endpres where tmp-endpres-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
                           and tmp-endpres-aux.cd-prestador = tmp-preserv-aux.cd-prestador
                               no-lock:

        display stream s-acertos
                tmp-endpres-aux.en-endereco @ wk-reg3.en-endereco
                tmp-endpres-aux.en-bairro   @ wk-reg3.en-bairro
                tmp-endpres-aux.en-cep      @ wk-reg3.en-cep
                tmp-endpres-aux.en-uf       @ wk-reg3.en-uf
                with frame f-lista-acertos-3.

        down with frame f-lista-acertos-3.
    end.

    /* --------------------------------------- REGISTRO PREST-INST GRAVADOS --- */
    find first tmp-prest-inst-aux
         where tmp-prest-inst-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
           and tmp-prest-inst-aux.cd-prestador = tmp-preserv-aux.cd-prestador
               no-lock no-error.
    if avail tmp-prest-inst-aux
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 4 - INSTITUICOES ACREDITADORAS DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
    
    for each tmp-prest-inst-aux
       where tmp-prest-inst-aux.cd-unidade   = tmp-preserv-aux.cd-unidade  
         and tmp-prest-inst-aux.cd-prestador = tmp-preserv-aux.cd-prestador
             no-lock:

        display stream s-acertos
                tmp-prest-inst-aux.cod-instit @ wk-reg4.cod-instit
                tmp-prest-inst-aux.cdn-nivel  @ wk-reg4.cdn-nivel
                tmp-prest-inst-aux.log-livre-1 @ wk-reg4.lg-autoriz-divulga
                with frame f-lista-acertos-4.

        down with frame f-lista-acertos-4.
    end.
    
    /* --------------------------------------- REGISTRO PREST-OBS GRAVADOS --- */
    find first tmp-prestdor-obs-aux
         where tmp-prestdor-obs-aux.cdn-unid-prestdor   = tmp-preserv-aux.cd-unidade  
           and tmp-prestdor-obs-aux.cdn-prestdor = tmp-preserv-aux.cd-prestador
               no-lock no-error.
    if avail tmp-prestdor-obs-aux
    then do:
           /* ativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-ativa-aux.
           &endif
           
           put stream s-acertos skip "   Registro Nro. 5 - OBSERVACOES DO PRESTADOR" skip.
           
           /* desativa negrito */
           &if "{&window-system}" = "TTY"
           &then put stream s-acertos control ds-negrit-desat-aux.
           &endif
    
         end.
    
    for each tmp-prestdor-obs-aux
       where tmp-prestdor-obs-aux.cdn-unid-prestdor   = tmp-preserv-aux.cd-unidade  
         and tmp-prestdor-obs-aux.cdn-prestdor = tmp-preserv-aux.cd-prestador
             no-lock:

        display stream s-acertos
                substring(tmp-prestdor-obs-aux.des-obs,1,20) @ wk-reg5.divulga-obs
                with frame f-lista-acertos-5.

        down with frame f-lista-acertos-5.
    end.
    
end procedure.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-par AS CHAR NO-UNDO.
END PROCEDURE.
