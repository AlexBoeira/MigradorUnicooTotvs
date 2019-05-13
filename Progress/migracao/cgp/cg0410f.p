def var in-status-aux   as char          no-undo.
assign  in-status-aux = "RC".

DISP "IMPORTANDO FATURAS STATUS:" in-status-aux.
PAUSE(0).

RUN cgp/cg0410f1.p("ONLINE", /* in-batch-online */
                   "1",
                   in-status-aux).
