/**
 * Chamar repetitivamente o programa para distribuir IMPORT_DOCTO_REVIS_CTAS da situacao RC para R0, R1... na medida
 * em que vao sendo criados na tabela (sao criados pelo extrator SQL)
 */
 
REPEAT:
    PROCESS EVENTS.
    RUN cgp/cg0310z3.p.
    PAUSE(1).

    IF SEARCH("c:/temp/parar-migracao.txt") <> ?
    THEN LEAVE.
END.
QUIT.
