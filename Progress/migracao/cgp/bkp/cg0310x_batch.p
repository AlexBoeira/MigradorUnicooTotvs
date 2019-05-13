/**
 * in-param-aux: esse parametro eh enviado pelo chamador, que eh um arquivo.bat
 * indica a situacao a ser tratada pela importacao (R0, R1, R2, etc)
 */
def var in-status-aux   as char          no-undo.
assign  in-status-aux = session:param.

REPEAT:
  PROCESS EVENTS.
  RUN cgp/cg0310x1.p("BATCH", /* in-batch-online */
                     in-status-aux,
                     YES,     /* lg-registro-modulos */
                     3,       /* in-classif */
                     YES,     /* lg-registro-faixa */
                     YES,     /* lg-registro-negociacao */
                     yes,     /* lg-registro-cobertura */  
                     yes,     /* lg-registro-especifico */ 
                     yes,     /* lg-registro-procedimento */
                     0        /* qt-sair-aux */).
  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  THEN LEAVE.
  ELSE PAUSE(1).
END.
QUIT.
