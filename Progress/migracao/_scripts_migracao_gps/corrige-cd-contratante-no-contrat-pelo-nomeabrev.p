FOR EACH contrat EXCLUSIVE-LOCK
   WHERE contrat.cd-contratante = 0,
   FIRST cliente NO-LOCK
   WHERE cliente.nom_abrev = contrat.nome-abrev:

    ASSIGN contrat.cd-contratante = cliente.cdn_cliente.
END.

MESSAGE "fim"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
