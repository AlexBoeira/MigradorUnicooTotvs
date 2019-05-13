DEF VAR ix-cont AS INT NO-UNDO.
FOR EACH contrat EXCLUSIVE-LOCK
   WHERE contrat.cd-contratante = 0,
   FIRST pessoa_fisic NO-LOCK
   WHERE pessoa_fisic.cod_id_feder = contrat.nr-cgc-cpf,
   FIRST ems5.cliente NO-LOCK
   WHERE cliente.num_pessoa = pessoa_fisic.num_pessoa_fisic:

         ASSIGN contrat.cd-contratante = cliente.cdn_cliente
                ix-cont = ix-cont + 1.

END.

FOR EACH contrat EXCLUSIVE-LOCK
   WHERE contrat.cd-contratante = 0,
   FIRST pessoa_jurid NO-LOCK
   WHERE pessoa_jurid.cod_id_feder = contrat.nr-cgc-cpf,
   FIRST ems5.cliente NO-LOCK
   WHERE cliente.num_pessoa = pessoa_jurid.num_pessoa_jurid:

         ASSIGN contrat.cd-contratante = cliente.cdn_cliente
                ix-cont = ix-cont + 1.
END.

MESSAGE ix-cont
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

