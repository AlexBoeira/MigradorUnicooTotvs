DEF NEW GLOBAL SHARED VAR statusProcess AS CHAR NO-UNDO. 

ASSIGN PROPATH = 'C:\migracao,' + PROPATH. 
UPDATE statusProcess. 

REPEAT:


    message " Importando Dados, Beneficiario..." + statusProcess.
    run cgp\cg0310vr1.p. 
    PAUSE (5).

END.
