DEF NEW GLOBAL SHARED VAR statusProcess AS CHAR NO-UNDO. 
DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHAR FORMAT "x(11)" NO-UNDO. 

ASSIGN PROPATH = 'C:\migracao,' + PROPATH. 
ASSIGN  v_cod_usuar_corren = 'super'.

UPDATE statusProcess. 

REPEAT:

    run cgp\cg0310x.p. 
    PAUSE (25).

END.
