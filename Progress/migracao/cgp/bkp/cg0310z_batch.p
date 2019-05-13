def var in-status-aux   as char          no-undo.
assign  in-status-aux = session:param.

REPEAT:
  PROCESS EVENTS.
  RUN cgp/cg0310z1.p("BATCH", /* in-batch-online */
                     in-status-aux).
  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  THEN LEAVE.
  ELSE PAUSE(1).
END.
QUIT.

