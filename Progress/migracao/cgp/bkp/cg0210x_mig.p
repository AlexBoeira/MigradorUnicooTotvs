/**
 * Temporaria para tratar possiveis erros na tentativa de login.
 */
Def Temp-table tt_erros No-undo
    Field num-cod   As Integer
    Field desc-erro As Character Format "x(256)":U
	Field desc-arq  As Character.

/**
 * Variavel para tratar parametro de entrada.
 */
DEF VAR in-param-aux AS CHAR no-undo.
def var lg-batch-aux as log init no.
ASSIGN in-param-aux = SESSION:PARAM.


Run fnd\btb\btapi910za.p(Input ENTRY(1, in-param-aux), /*USUARIO*/
                         Input ENTRY(2, in-param-aux), /*SENHA*/
                         Output Table tt_erros). 

For Each tt_erros:
    Message "Erro: " 
            String(tt_erros.num-cod) + " - ":U + 
            tt_erros.desc-erro 
            View-as Alert-box Information.
End.


/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/*{include/i-prgvrs.i CG0210X 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i cg0210x MCG}
&ENDIF
*/
def var rw-log-exec as rowid.
/*
run btb/btb918zb.p (input "hcg0210x", /* nome do programa */
                    input-output rw-log-exec, /* rowid */
                    input yes). /* inicia o log */
*/

/******************************************************************************
*      Programa .....: cg0210x.p                                              *
*      Data .........: 18 de Dezembro de 2002                                 *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Alex Boeira                                            *
*      Objetivo .....: Migracao dos dados dos Prestadores                     *
*---------------------------------------------------------------------------- *
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      6.00.000  18/12/2002  Alex           Desenvolvimento                   *
******************************************************************************/
hide all no-pause.

def var c-versao as char init "7.00.000"                                no-undo.

run cgp/cg0110l_mig.p(no, /*on-line*/
                      "",
                      "").

/*run btb/btb918zb.p (input "hcg0210x", /* nome do programa */
                    input-output rw-log-exec, /* rowid */
                    input no). /* finaliza o log */
*/					
QUIT.
