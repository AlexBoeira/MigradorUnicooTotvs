/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i RTP/RTCGCCPF.P 1.02.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i rtcgccpf MRT}
&ENDIF


/************************************************************************************************
*      Programa .....: rtcgccpf.p                                                               *
*      Data .........: 30 de Abril de 2002                                                      *
*      Sistema ......: RT - ROTINAS PADRAO                                                      *
*      Empresa ......: DZSET SOLUCOES E SISTEMAS                                                *
*      Cliente ......: COOPERATIVAS MEDICAS                                                     *
*      Programador ..: Leonardo Deimomi                                                         *
*      Objetivo .....: Consistir o numero do CGC/CPF                                            *
*-----------------------------------------------------------------------------------------------*
*      PARAMETRO             DESCRICAO                                                          *
*      in-tipo-pessoa-par    Tipo da pessoa (F-Fisica ou J-Juridica)                            *
*      nr-cgc-cpf-par        Numero do CGC/CPF a ser consistido                                 *
*      lg-msg-tela-par       Indicador para mostrar a(s) mensagem(ns) na tela (S-Sim ou N-Nao)  *
*      ds-mensagem-par       Descricao da mensagem                                              *
*      lg-erro-par           Indicador de erro na rotina (S-Sim ou N-Nao)                       *
*-----------------------------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL     MOTIVO                                             *
*      E.01.000  30/04/2002  Leonardo        Desenvolvimento                                    *
************************************************************************************************/
 
/* -------------------------------------------- DEFINICAO DE PARAMETROS DE ENTRADA E SAIDA --- */
def input  parameter in-tipo-pessoa-par      like contrat.in-tipo-pessoa                 no-undo.
def input  parameter nr-cgc-cpf-par          like contrat.nr-cgc-cpf                     no-undo.
def input  parameter lg-msg-tela-par           as log                                    no-undo.
def output parameter ds-mensagem-par           as char format "x(80)"                    no-undo.
def output parameter lg-erro-par               as log                                    no-undo.
 
/* --------------------------------------------------------- DEFINICAO DE VARIAVEIS LOCAIS --- */
def var c-versao                               as char                                   no-undo.
def var nr-cgc-cpf-aux                       like contrat.nr-cgc-cpf                     no-undo.
def var ds-mensagem-aux                        as char format "x(70)"                    no-undo.
def var lg-digito-correto-aux                  as log                                    no-undo.
def var nr-digito-aux                          as int                                    no-undo.
def var lg-confirma-aux                        as log  format "Sim/Nao" INIT YES         no-undo.

/* ------------------------------------------------------------------------------------------- */
assign c-versao = "7.01.000".

{hdp/hdlog.i}

/* ------------------------------------------------------------------------------------------- */
assign lg-erro-par     = no
       ds-mensagem-par = "".

/* ----------------------------------------------------- LOCALIZA OS PARAMETROS DO SISTEMA --- */
find first paramecp no-lock no-error.
if   not avail paramecp
then do:
       assign lg-erro-par     = yes
              ds-mensagem-par = "Parametros gerais do sistema nao cadastrados.".

       if   lg-msg-tela-par
       then message ds-mensagem-par
                    view-as alert-box title " Atencao !!! ".

       return.
     end.

/* ---------------------------------------------------------- DESEDITA O NUMERO DO CGC/CPF --- */
run desedita-cgc-cpf (input  nr-cgc-cpf-par,
                      output nr-cgc-cpf-aux).

/* --- Contatante sem cpf -------------------------------------------------- */
if   nr-cgc-cpf-aux     = ""
then return.

if   nr-cgc-cpf-aux = ""
then do:
       assign lg-erro-par = yes.

       /*if   in-tipo-pessoa-par = "F"
       then assign ds-mensagem-par = "Numero do CPF deve ser informado.".
       else*/ assign ds-mensagem-par = "Numero do CGC deve ser informado.".

       if   lg-msg-tela-par
       then message ds-mensagem-par
                    view-as alert-box title " Atencao !!! ".

       return.
     end.

if   in-tipo-pessoa-par = "F"
/* ----------------------------------- VERIFICA SE O NUMERO DE DIGITOS DO CPF ESTA CORRETO --- */
then do:
       if   int(length(nr-cgc-cpf-aux)) = 11
       then assign nr-digito-aux = int(substring(nr-cgc-cpf-aux,10,2)).

       else do:
              assign lg-erro-par     = yes
                     ds-mensagem-par = "Numero de digitos do CPF invalido.".

              if   lg-msg-tela-par
              then message ds-mensagem-par
                           view-as alert-box title " Atencao !!! ".

              return.
            end.
     end.

/* ----------------------------------- VERIFICA SE O NUMERO DE DIGITOS DO CGC ESTA CORRETO --- */
else do:
       if   int(length(nr-cgc-cpf-aux)) = 14
       then assign nr-digito-aux = int(substring(nr-cgc-cpf-aux,13,2)).

       else do:
              assign lg-erro-par     = yes
                     ds-mensagem-par = "Numero de digitos do CGC invalido.".

              if   lg-msg-tela-par
              then message ds-mensagem-par
                           view-as alert-box title " Atencao !!! ".

              return.
            end.
     end.

/* ----------------------------------------------- CALCULA O DIGITO VERIFICADOR DO CGC/CPF --- */
run rtp/rtdigver.p (input        if   in-tipo-pessoa-par = "F"
                                 then "CPF"
                                 else "CGC",
                    input        yes,
                    input        nr-cgc-cpf-aux,
                    input        no,
                    output       ds-mensagem-aux,
                    output       lg-digito-correto-aux,
                    input-output nr-digito-aux).
if   in-tipo-pessoa-par = "F"
then do:
		if dec(substr(nr-cgc-cpf-aux,1,11)) = 0 or
     dec(substr(nr-cgc-cpf-aux,1,11)) = 99999999999
then assign lg-digito-correto-aux = no.
	end.
else do:
		if dec(substr(nr-cgc-cpf-aux,1,14)) = 0 or
		   dec(substr(nr-cgc-cpf-aux,1,14)) = 99999999999999
		then assign lg-digito-correto-aux = no.
		
	 end.	

if   not lg-digito-correto-aux
/* ------------------------------------------------- ERRO NO CALCULO DO DIGITO VERIFICADOR --- */
then do:
       if   in-tipo-pessoa-par = "F"
       then assign ds-mensagem-par = "Digito verificador do CPF invalido.".
       else assign ds-mensagem-par = "Digito verificador do CGC invalido.".

       if   paramecp.lg-aceita-cgccpf-erro
       then do:
              if   lg-msg-tela-par
              then do:
                     assign lg-confirma-aux = no.
                     message ds-mensagem-par "Confirma digitacao ?" 
                             view-as alert-box question buttons yes-no title "Atencao!"
                             update lg-confirma-aux.
 
                     hide message no-pause.
                   end.

              if   not lg-confirma-aux
              then assign lg-erro-par = yes.
            end.

       else do:
              assign lg-erro-par = yes.

              if   lg-msg-tela-par
              then message ds-mensagem-par
                           view-as alert-box title " Atencao !!! ".
            end.
     end.

return.

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

/* ------------------------------------------------------------------------------------------- */
