REPEAT:
    PROCESS EVENTS.
    RUN ems5/ti_distribui_titulos_APB_fila_importacao.p.
    PAUSE(1).

    IF SEARCH("c:/temp/parar-migracao.txt") <> ?
    THEN LEAVE.
END.
QUIT.
