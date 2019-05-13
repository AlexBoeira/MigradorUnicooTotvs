
DEF VAR ix-cont AS INT no-undo.

FOR EACH propost EXCLUSIVE-LOCK
   WHERE propost.cd-contratante = 0,
   FIRST contrat NO-LOCK
   WHERE contrat.nr-insc-contratante = propost.nr-insc-contratante
     AND contrat.cd-contratante <> 0:

    ASSIGN propost.cd-contratante = contrat.cd-contratante
           ix-cont = ix-cont + 1.
END.

MESSAGE ix-cont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

