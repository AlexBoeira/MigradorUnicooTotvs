/* Alias parte PROGRESS EMS5 */
CREATE ALIAS shemsbas FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsedi FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsfin FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsuni FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsven FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsinc FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shmovfin FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemscad FOR DATABASE shems5 NO-ERROR.
CREATE ALIAS shemsmov FOR DATABASE shems5 NO-ERROR.


/* Alias parte Oracle EMS5 */
CREATE ALIAS emsbas FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsedi FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsfin FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsuni FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsven FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsinc FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS movfin FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emscad FOR DATABASE ems5 NO-ERROR.
CREATE ALIAS emsmov FOR DATABASE ems5 NO-ERROR.

/* Alias dos Schema Holders GP*/
CREATE ALIAS srmovben FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srmovcon FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srmovfi1 FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srweb    FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srmovfin FOR DATABASE shgp NO-ERROR.
CREATE ALIAS srcadger FOR DATABASE shgp NO-ERROR.

CREATE ALIAS shsrmovben    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrmovcon    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrmovfi1    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrweb       FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrmovfin    FOR DATABASE gp NO-ERROR.
CREATE ALIAS shsrcadger    FOR DATABASE gp NO-ERROR.

DEF VAR in-tipo-geracao-aux AS CHAR NO-UNDO. 

DO ON ERROR UNDO, RETRY:

    UPDATE in-tipo-geracao-aux.

    CASE in-tipo-geracao-aux:

        WHEN "P" THEN RUN C:\migracao\executa-proposta.p.
        WHEN "T" THEN RUN C:\migracao\executa-termo.p.
        WHEN "B" THEN RUN C:\migracao\executa-benef.p.

        /*ajustar
        WHEN "D" THEN RUN C:\migracao\cgp\cg0310z.p.
        WHEN "F" THEN RUN C:\migracao\cgp\cg0410f.p.
        WHEN "A" THEN RUN C:\migracao\atp\at0210a.p. */

        OTHERWISE  DO:

            MESSAGE "Valor invalido." SKIP
                    "P - Proposta" SKIP
                    "T - Termo" SKIP 
                    "B - Beneficiario" SKIP
                    "D - Documentos" SKIP
                    "F - Faturas" SKIP
                    "A - Guias"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.

            UNDO, NEXT. 
        END.
    END CASE.
END.

quit.
