/* replicar transacao 1020 para 1010, com vencimento em 31/08/2017 
 * objetivo: possibilitar carga da migracao de movimentos realizados
 * no Unicoo na transacao incorreta
 */
/*CD_TRANSACAO, CD_MODULO, CD_ESP_AMB, CD_GRUPO_PROC_AMB, CD_PROCEDIMENTO, DV_PROCEDIMENTO, DT_LIMITE*/
DEF BUFFER b-trmodamb FOR trmodamb.
DEF VAR ix AS INT NO-UNDO.

ETIME(TRUE).

FOR EACH trmodamb NO-LOCK
   WHERE trmodamb.cd-transacao = 1020:
    IF NOT CAN-FIND(FIRST b-trmodamb
                    WHERE b-trmodamb.cd-transacao = 1010
                      AND b-trmodamb.cd-modulo    = trmodamb.cd-modulo
                      AND b-trmodamb.cd-esp-amb   = trmodamb.cd-esp-amb
                      AND b-trmodamb.cd-grupo-proc-amb = trmodamb.cd-grupo-proc-amb
                      AND b-trmodamb.cd-procedimento   = trmodamb.cd-procedimento
                      AND b-trmodamb.dv-procedimento   = trmodamb.dv-procedimento
                      AND b-trmodamb.dt-limite        >= TODAY) 
    THEN DO:
           CREATE b-trmodamb.
           BUFFER-COPY trmodamb EXCEPT cd-transacao dt-limite TO b-trmodamb.
           ASSIGN b-trmodamb.cd-transacao = 1010
                  b-trmodamb.dt-limite    = 08/31/2017
                  ix = ix + 1.
         END.
END.

MESSAGE "concluido" SKIP ix "registros" SKIP ETIME / 1000 "segundos"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.


