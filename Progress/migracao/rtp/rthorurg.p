/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i RTHORURG 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i rthorurg MRT}
&ENDIF

/******************************************************************************
*  Programa ....: rthorurg.p                                                  *
*  Data ........: 02 de Dezembro de 1998                                      *
*  Sistema .....: RT - Rotinas Padrao                                         *
*  Empresa .....: DZSET Solucoes e Sistemas                                   *
*  Cliente .....: Cooperativas Medicas                                        *
*  Programador .: Leonardo Deimomi                                            *
*  Objetivo ....: Verifica se a data de realizacao e o horario de realizacao  *
*                 do movimento fazem parte dos horarios de urgencia cadastra- *
*                 dos no sistema.                                             *
*-----------------------------------------------------------------------------*
*  VERSAO    DATA        RESPONSAVEL  MOTIVO                                  *
*  D.00.000  02/12/1998  Leonardo     Desenvolvimento                         *
*  D.01.000  11/09/2000  Rojas        Converter para Magnus-EMS.              *
*  E.00.000  25/10/2000  Nora         Mudanca Versao Banco                    *
*  E.01.000  22/05/2001  Nora         Conversao Ems504                        *
*-----------------------------------------------------------------------------*
*  PARAMETRO              DESCRICAO                                           *
*                                                                             *
*  in-trata-urgencia-par  Indica se sera tratado os horarios de urgencia      *
*  cd-tab-urge-par        Codigo da tabela dos horarios de urgencia           *
*  dt-realizacao-par      Data da realizacao do movimento                     *
*  hr-realizacao-par      Hora da realizacao do movimento                     *
*  lg-urgencia-par        Indica se naquela data e naquele horario, sera con- *
*                         siderado urgencia                                   *
******************************************************************************/
/*--------------------------------- Variavel que identifica magnus ou EMS ---*/
{hdp/hdsistem.i}
 
/* ----- DEFINICAO DOS PARAMETROS ------------------------------------------ */
def input  parameter in-trata-urgencia-par    like tranrevi.in-trata-urgencia no-undo.
def input  parameter cd-tab-urge-par          like preserv.cd-tab-urge no-undo.
def input  parameter dt-realizacao-par        like moviproc.dt-realizacao no-undo.
def input  parameter hr-realizacao-par        like moviproc.hr-realizacao no-undo.
def input  parameter cd-tab-preco-proc-par    like moviproc.cd-tab-preco-proc no-undo.
def input  parameter cd-local-atendimento-par like locaaten.cd-local-atendimento no-undo.
def input  parameter cd-unimed-par            like unimed.cd-unimed no-undo.
def input  parameter cd-prestador-par         like preserv.cd-prestador no-undo.
def input  parameter in-tipo-consulta         as char format "x(03)" no-undo.
def input  parameter cd-unidade-carteira-par  like car-ide.cd-unimed             no-undo.
def input  parameter cd-carteira-usuario-par  like car-ide.cd-carteira-inteira   no-undo. 
def output parameter lg-urgencia-par         as logical no-undo.
 
/* ----- DEFINICAO DAS VARIAVEIS LOCAIS ------------------------------------ */
def var cont                                 as int                    no-undo.
def var c-versao                             as char                   no-undo.
def var cd-classif-dia-aux                   as char format "x(08)"    no-undo.
def var lg-cpc-hora-espec                    as logical                no-undo.
/* ------------------------------------------------------------------------- */
assign
lg-urgencia-par = no
c-versao        = "7.04.000".
{hdp/hdlog.i}

/* ----- NAO TRATA URGENCIA ------------------------------------------------ */
if   in-trata-urgencia-par = 7
or   cd-tab-urge-par       = 0
then return.

/* ----------------------------- DEFINICAO DA TEMP PARA CPC DESTA ROTINA --- */
{cpc/cpc-rthorurg.i}

/* ----------------------------- VERIFICA SE A CPC HORA-ESPEC ESTA ATIVA --- */
if can-find (first dzlibprx where dzlibprx.nm-ponto-chamada-cpc = "HORA-ESPEC"
                              and dzlibprx.nm-programa          = "RTHORURG"
                              and dzlibprx.lg-ativo-cpc)
then assign lg-cpc-hora-espec = yes.
else assign lg-cpc-hora-espec = no.

/* ----- PROCURA HORARIOS DE URGENCIA -------------------------------------- */
if lg-cpc-hora-espec 
then run p-cpc-hora-espec in this-procedure.

find first horaurge
     where horaurge.cd-tab-urge       = cd-tab-urge-par
       and horaurge.cd-tab-preco-proc = cd-tab-preco-proc-par
           no-lock no-error.

if not available horaurge
then do:
       find first horaurge                                          
            where horaurge.cd-tab-urge       = cd-tab-urge-par      
              and horaurge.cd-tab-preco-proc = ""
                  no-lock no-error.                                 
     end.
 
if   available horaurge
then case weekday (dt-realizacao-par):
 
     when 01    /* ------ DOMINGO ------------------------------------------ */
     then do:
            assign cont = 1.
            do while cont <= 3:
               if   hr-realizacao-par >= horaurge.hr-inicio-dom-feriado [cont]
               and  hr-realizacao-par <= horaurge.hr-fim-dom-feriado    [cont]
               then do: 
                       assign lg-urgencia-par = yes.
                       return.
                    end.
               assign cont = cont + 1.
            end.
          end.
 
     when 07    /* ------ SABADO ------------------------------------------- */
     then do:
            assign cont = 1.
            do while cont <= 3:
               if   hr-realizacao-par >= horaurge.hr-inicio-sabado [cont]
               and  hr-realizacao-par <= horaurge.hr-fim-sabado    [cont]
               then do: 
                       assign lg-urgencia-par = yes.
                       return.
                    end.
               assign cont = cont + 1.
            end.
          end.
 
     otherwise  /* ----- DEMAIS DIAS DA SEMENA ----------------------------- */
          do:
            assign cont = 1.
            do while cont <= 3:
               if   hr-realizacao-par >= horaurge.hr-inicio-normal [cont]
               and  hr-realizacao-par <= horaurge.hr-fim-normal    [cont]
               then do: 
                       assign lg-urgencia-par = yes.
                       return.
                    end.
               assign cont = cont + 1.
            end.
          end.
 
     end case.
 
if   lg-urgencia-par
then return.

&if   "{&sistema}" <> "ems504"
 and  "{&sistema}" <> "ems505"
&then do:
        /* ----- PROCURA O CODIGO DA EMPRESA E DO ESTABELECIMENTO ------------------ */
        find first paramecp no-lock no-error.
        if   not available paramecp
        then return.

        /* - VERIFICA SE A DATA DO MOVIMENTO E' UM DIA DE FERIADO -------------- */
        find calen-coml
             where calen-coml.ep-codigo   = paramecp.ep-codigo
               and calen-coml.cod-estabel = paramecp.cod-estabel
               and calen-coml.data        = dt-realizacao-par
                   no-lock no-error.
        if   available calen-coml
        then do:
               &if  "{&sistema}" = "magnus"
               &then do:
                       if   calen-coml.tipo-dia = "3"
                       then lg-urgencia-par = yes.
                     end.
               &else do:
                       if   calen-coml.tipo-dia = 3
                       then lg-urgencia-par = yes.
                     end.
               &endif.
             end.
        else return.    
      end.
&else do:
        /* ---------- PROCURA PARAMETROS GERAIS DO REVISAO DE CONTAS ------- */
        find first paramrc no-lock no-error.
        if   not available paramrc
        then return.
 
        /* ------------*****----- VERIFICA SE O DIA DA SEMANA E' FERIADO --- */
        find first dia_calend_glob
             where dia_calend_glob.cod_calend = paramrc.nm-calendario
               and dia_calend_glob.dat_calend = dt-realizacao-par
                   no-lock no-error.
        
        if   avail dia_calend_glob
        then do:
               if   dia_calend_glob.log_dia_util
               then assign lg-urgencia-par = no.
               else assign lg-urgencia-par = yes.
             end.
        else return.    
      end.
&endif

/* ------------- CPC PARA TRATAMENTO DE LOCAL DE ATENDIMENTO E PRESTADOR --- */
procedure p-cpc-hora-espec:
    if  search("cpc/cpc-rthorurg.p") = ? 
    and search("cpc/cpc-rthorurg.r") = ? 
    then return.

    empty temp-table tt-cpc-rthorurg-entrada.

    create tt-cpc-rthorurg-entrada.
    assign tt-cpc-rthorurg-entrada.in-evento-programa   = "VERIFICA-URG"        
           tt-cpc-rthorurg-entrada.nm-ponto-chamada-cpc = "HORA-ESPEC"      
           tt-cpc-rthorurg-entrada.cd-local-atendimento = cd-local-atendimento-par
           tt-cpc-rthorurg-entrada.cd-unimed            = cd-unimed-par
           tt-cpc-rthorurg-entrada.cd-prestador         = cd-prestador-par
           tt-cpc-rthorurg-entrada.in-tipo-consulta     = in-tipo-consulta
           tt-cpc-rthorurg-entrada.cd-unidade-carteira  = cd-unidade-carteira-par
           tt-cpc-rthorurg-entrada.cd-carteira-usuario  = cd-carteira-usuario-par
           tt-cpc-rthorurg-entrada.cd-tab-preco-proc    = cd-tab-preco-proc-par.

    run cpc/cpc-rthorurg.p (input table tt-cpc-rthorurg-entrada,
                            output table tt-cpc-rthorurg-saida) no-error.

    if error-status:error 
    then return.

    find first tt-cpc-rthorurg-saida no-lock no-error.
    
    if avail(tt-cpc-rthorurg-saida) 
    then assign cd-tab-urge-par       = tt-cpc-rthorurg-saida.cd-tab-urge
                cd-tab-preco-proc-par = tt-cpc-rthorurg-saida.cd-tab-preco-proc.
end procedure.
/* ----------------------------------------------------------------- EOF --- */
