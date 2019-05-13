/**
 * in-param-aux: esse parametro eh enviado pelo chamador, que eh um arquivo.bat
 *   entry 1: indica a situacao a ser tratada pela importacao (0, 1, 2, etc)
 *   entry 2: 'S' para executar continuamente; 'N' para percorrer os registros da situacao solicitada e sair;
 */
def var in-param-aux   as char          no-undo.
assign  in-param-aux = session:param.

/*verificar se ha algo na fila para ser processado. Se nao tiver, nao chamar a proxima etapa*/
def var qt-sit-aux as int no-undo.
select count(*) into qt-sit-aux from import-propost where import-propost.ind-sit-import = entry(1, in-param-aux).
if qt-sit-aux > 0
then do:
		REPEAT:
		  PROCESS EVENTS.
		  RUN cgp/cg0310x1.p("BATCH", /* in-batch-online */
							 entry(1, in-param-aux),
							 YES,     /* lg-registro-modulos */
							 3,       /* in-classif */
							 YES,     /* lg-registro-faixa */
							 YES,     /* lg-registro-negociacao */
							 yes,     /* lg-registro-cobertura */  
							 yes,     /* lg-registro-especifico */ 
							 yes,     /* lg-registro-procedimento */
							 0        /* qt-sair-aux */).
		  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
		  or entry(2, in-param-aux) = "N"
		  THEN LEAVE.
		  ELSE PAUSE(1).
		END.
end.		
QUIT.
