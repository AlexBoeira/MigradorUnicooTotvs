/**
 * in-param-aux:
 *   entry 1: satus da fila a monitorar (0,1,2,etc)
 *   entry 2: 'S' para executar continuamente; 'N' para processar todos os registros que encontrar na fila e sair (usado pelo Jenkins)
 */
def var in-param-aux   as char          no-undo.
assign  in-param-aux = session:param.

/*verificar se ha algo na fila para ser processado. Se nao tiver, nao chamar a proxima etapa*/
def var qt-sit-aux as int no-undo.
select count(*) into qt-sit-aux from import-guia where import-guia.ind-sit-import = entry(1, in-param-aux).
if qt-sit-aux > 0
then do:

		REPEAT:
		  PROCESS EVENTS.
		  RUN atp/at0210a1.p("BATCH", /* in-batch-online */
							 entry(1,in-param-aux)).
		  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
		  or entry(2,in-param-aux) = "N"
		  THEN LEAVE.
		  ELSE PAUSE(1).
		END.
end.		
QUIT.
