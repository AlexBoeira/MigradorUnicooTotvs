/**
 * Temporaria para tratar possiveis erros na tentativa de login.
 */
Def Temp-table tt_erros No-undo
    Field num-cod   As Integer
    Field desc-erro As Character Format "x(256)":U
	Field desc-arq  As Character.

/**
 * in-param-aux:
 *   entry 1: satus da fila a monitorar (0,1,2,etc)
 *   entry 2: usuario (login)
 *   entry 3: senha (login)
 *   entry 4: 'S' para executar continuamente; 'N' para processar todos os registros que encontrar na fila e sair (usado pelo Jenkins)
 */
DEF VAR in-param-aux AS CHAR no-undo.
ASSIGN in-param-aux = SESSION:PARAM.

def var nr-pendentes-na-fila-aux as int no-undo.

Run fnd\btb\btapi910za.p(Input ENTRY(2, in-param-aux), /*USUARIO*/ 
                         Input ENTRY(3, in-param-aux), /*SENHA */  
                         Output Table tt_erros). 

For Each tt_erros:
    Message "Erro: " 
            String(tt_erros.num-cod) + " - ":U + 
            tt_erros.desc-erro 
            View-as Alert-box Information.
End.

REPEAT:
  /** 
   * SE NAO TIVER NADA NA FILA, NAO CHAMAR O PROGRAMA DE IMPORTACAO
   */
  select count(*) into nr-pendentes-na-fila-aux from ti_tit_apb where ti_tit_apb.cdsituacao = ENTRY(1, in-param-aux).
  if nr-pendentes-na-fila-aux = 0
  then leave.
  PROCESS EVENTS.
  RUN ems5/ti_tit_apb.p (INPUT ENTRY(1, in-param-aux)).
    
  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  or entry(4,in-param-aux) = "N"
  THEN LEAVE.
  else pause(1).
END.
QUIT.

