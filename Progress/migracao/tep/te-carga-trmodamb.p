/* criar registros para todos os AMBPROCE que ainda nao existem em TRMODAMB, com vencimento em 31/08/2017 
 * objetivo: possibilitar carga da migracao de movimentos realizados
 * no Unicoo na transacao incorreta
 */
/*CD_TRANSACAO, CD_MODULO, CD_ESP_AMB, CD_GRUPO_PROC_AMB, CD_PROCEDIMENTO, DV_PROCEDIMENTO, DT_LIMITE*/
DEF VAR ix AS INT no-undo.
DEF BUFFER b-trmodamb FOR trmodamb.
ETIME(TRUE).

FIND FIRST trmodamb NO-LOCK
     WHERE trmodamb.cd-transacao = 1020
       AND trmodamb.cd-modulo    = 2.

FOR EACH ambproce NO-LOCK:
    IF NOT CAN-FIND(FIRST b-trmodamb
                    WHERE b-trmodamb.cd-transacao = 1020
                      AND b-trmodamb.cd-modulo    = 2
                      AND b-trmodamb.cd-esp-amb        = ambproce.cd-esp-amb
                      AND b-trmodamb.cd-grupo-proc-amb = ambproce.cd-grupo-proc-amb
                      AND b-trmodamb.cd-procedimento   = ambproce.cd-procedimento
                      AND b-trmodamb.dv-procedimento   = ambproce.dv-procedimento
                      AND b-trmodamb.dt-limite        >= TODAY) 
    THEN DO:
           CREATE b-trmodamb.
           BUFFER-COPY trmodamb EXCEPT cd-esp-amb cd-grupo-proc-amb cd-procedimento dv-procedimento TO b-trmodamb.
           ASSIGN b-trmodamb.cd-esp-amb        = ambproce.cd-esp-amb       
                  b-trmodamb.cd-grupo-proc-amb = ambproce.cd-grupo-proc-amb
                  b-trmodamb.cd-procedimento   = ambproce.cd-procedimento  
                  b-trmodamb.dv-procedimento   = ambproce.dv-procedimento  
                  b-trmodamb.dt-limite         = 8/31/2017
                  ix                           = ix + 1.
         END.
END.

MESSAGE "concluido" SKIP ix "registros criados" SKIP ETIME / 1000 "segundos"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

