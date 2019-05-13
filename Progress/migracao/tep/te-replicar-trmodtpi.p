/* replicar transacao 1030 para 1020, com vencimento em 31/08/2017 
 * objetivo: possibilitar carga da migracao de movimentos realizados
 * no Unicoo na transacao incorreta
 */
 /*CD_TRANSACAO, CD_MODULO, CD_TIPO_INSUMO, CD_INSUMO*/
DEF BUFFER b-trmodtpi FOR trmodtpi.
DEF VAR ix AS INT NO-UNDO.

ETIME(TRUE).

FOR EACH trmodtpi NO-LOCK
   WHERE trmodtpi.cd-transacao = 1030:
    IF NOT CAN-FIND(FIRST b-trmodtpi
                    WHERE b-trmodtpi.cd-transacao = 1020
                      AND b-trmodtpi.cd-modulo    = trmodtpi.cd-modulo
                      AND b-trmodtpi.cd-tipo-insumo    = trmodtpi.cd-tipo-insumo) 
    THEN DO:
           CREATE b-trmodtpi.
           BUFFER-COPY trmodtpi EXCEPT cd-transacao TO b-trmodtpi.
           ASSIGN b-trmodtpi.cd-transacao = 1020
                  b-trmodtpi.date-1    = 08/31/2017
                  ix = ix + 1.
         END.
END.

MESSAGE "concluido" SKIP ix "registros" SKIP ETIME / 1000 "segundos"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.


