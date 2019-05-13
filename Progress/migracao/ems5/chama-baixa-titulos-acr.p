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


Run fnd\btb\btapi910za.p(Input ENTRY(2, in-param-aux), /*USUARIO*/
                         Input ENTRY(3, in-param-aux), /*SENHA*/
                         Output Table tt_erros). 

For Each tt_erros:
    RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ANTES DO MESSAGE DE ERRO DA BTAPI910ZA").
    RUN escrever-log("@@@@@Erro: " + String(tt_erros.num-cod) + " - ":U + tt_erros.desc-erro).
    RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DEPOIS DO MESSAGE DE ERRO DA BTAPI910ZA").
End.

REPEAT:
    PROCESS EVENTS.
    RUN ems5/cx_bx_acr.p (INPUT ENTRY(1, in-param-aux)).
    PAUSE(1).

  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  THEN LEAVE.
END.
QUIT.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-mensagem-par AS CHAR NO-UNDO.
END.
