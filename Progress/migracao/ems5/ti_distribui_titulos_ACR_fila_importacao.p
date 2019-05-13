/**
 * Varrer todos os ti_tit_acr e trocar a situacao RC para R0, R1, R2... ate R9
 */
 
DEF VAR in-status-titulo-aux  AS CHAR INIT "R0" NO-UNDO.

FUNCTION proximo-status-titulo RETURNS CHAR():
  CASE in-status-titulo-aux:
      WHEN "R0" THEN ASSIGN in-status-titulo-aux = "R1".
      WHEN "R1" THEN ASSIGN in-status-titulo-aux = "R2".
      WHEN "R2" THEN ASSIGN in-status-titulo-aux = "R3".
      WHEN "R3" THEN ASSIGN in-status-titulo-aux = "R4".
      WHEN "R4" THEN ASSIGN in-status-titulo-aux = "R5".
      WHEN "R5" THEN ASSIGN in-status-titulo-aux = "R6".
      WHEN "R6" THEN ASSIGN in-status-titulo-aux = "R7".
      WHEN "R7" THEN ASSIGN in-status-titulo-aux = "R8".
      WHEN "R8" THEN ASSIGN in-status-titulo-aux = "R9".
      WHEN "R9" THEN ASSIGN in-status-titulo-aux = "R0".
  END CASE.
  RETURN in-status-titulo-aux.
END FUNCTION.

for each ti_tit_acr where ti_tit_acr.cdsituacao = "RC" exclusive-lock:

    assign ti_tit_acr.cdsituacao = proximo-status-titulo().

end.
