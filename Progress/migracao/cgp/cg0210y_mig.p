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

def var rw-log-exec as rowid.


/******************************************************************************
*      Programa .....: cg0210y.p                                              *
*      Data .........: 08 de Mar‡o de 2018                                    *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Guilherme B                                            *
*      Objetivo .....: Migracao dos dados dos Prestadores (BATCH)             *
*---------------------------------------------------------------------------- *
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      6.00.000  08/03/2018  Guilherme      Desenvolvimento                   *
******************************************************************************/
hide all no-pause.

def var c-versao as char init "7.00.000"                                no-undo.

run cgp/cg0110l_mig.p(yes, /*batch*/    
                      Input ENTRY(3, in-param-aux), /*ARQUIVO_IMPORTACAO*/
                      Input ENTRY(4, in-param-aux)) /*ARQUIVO_ERROS*/.


QUIT.
