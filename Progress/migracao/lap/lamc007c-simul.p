/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i LAMC007C-SIMUL 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i lamc007c MLA}
&ENDIF


/******************************************************************************
*      Programa ....: lamc007c-simul.p                                        *
*      Data ........: 10 de Maio de 1999                                      *
*      Sistema .....: LA - LAY-OUT PADRAO                                     *
*      Empresa .....: DZSET Solucoes e Sistemas                               *
*      Cliente .....: COOPERATIVAS MEDICAS                                    *
*      Programador .: Airton Nora                                             *
*      Objetivo ....: Monta o codigo da carteira do beneficiario, o codigo de *
*                     impressao da carteira e o codigo do cartao, conforme a  *
*                     estrutura do numero sequencial por modalidade SIMULACAO *
*-----------------------------------------------------------------------------*
******************************************************************************/
 
/* ----- DEFINICAO DOS PARAMETROS ------------------------------------------ */
def input        parameter cd-tipo-tarefa-par      as int                            no-undo.
def input        parameter cd-unimed-par           like usuario.cd-unimed            no-undo.   
def input        parameter cd-modalidade-par       like usuario.cd-modalidade        no-undo.
def input        parameter nr-ter-adesao-par       like usuario.nr-ter-adesao        no-undo.
def input        parameter nr-via-carteira-par     as int                            no-undo.
def input-output parameter cd-usuario-par          like usuario.cd-usuario           no-undo.  
def output       parameter lg-erro-par             as log                            no-undo.

/* ------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   LAYOUT RETORNARA O MESMO CODIGO PARA BENEFICIARIO POIS A CARTEIRA NAO POSSUI O
   CODIGO DESTE NO LAYOUT. SERA TRATADO NO PROGRAMA LAMC007C PARA NAO UTILIZAR O MESMO
   CODIGO DA CARTEIRA ANTIGA.
   ------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------
   ------------------------------------------------------------------------------------ */
   
   

/* ------------------------------------------------------------------------- */
/*------------------------------------------------------------------ EOF ---*/
