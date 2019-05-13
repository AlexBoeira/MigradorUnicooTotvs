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
    Message "Erro: " 
            String(tt_erros.num-cod) + " - ":U + 
            tt_erros.desc-erro 
            View-as Alert-box Information.
End.

REPEAT:
    PROCESS EVENTS.
    RUN ems5/cx_bx_acr.p (INPUT ENTRY(1, in-param-aux)).
    PAUSE(1).

  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  THEN LEAVE.
END.
QUIT.
