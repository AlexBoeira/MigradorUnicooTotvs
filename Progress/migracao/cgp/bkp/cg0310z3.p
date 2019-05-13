/**
 * Varrer todos os import-docto-revis-ctas e trocar a situacao RC para R0, R1, R2...
 */
 
DEF VAR in-status-aux  AS CHAR INIT "R0" NO-UNDO.

FUNCTION proximo-status RETURNS CHAR():
  CASE in-status-aux:
      WHEN "R0" THEN ASSIGN in-status-aux = "R1".
      WHEN "R1" THEN ASSIGN in-status-aux = "R2".
      WHEN "R2" THEN ASSIGN in-status-aux = "R3".
      WHEN "R3" THEN ASSIGN in-status-aux = "R4".
      WHEN "R4" THEN ASSIGN in-status-aux = "R5".
      WHEN "R5" THEN ASSIGN in-status-aux = "R6".
      WHEN "R6" THEN ASSIGN in-status-aux = "R7".
      WHEN "R7" THEN ASSIGN in-status-aux = "R8".
      WHEN "R8" THEN ASSIGN in-status-aux = "R9".
      WHEN "R9" THEN ASSIGN in-status-aux = "R0".
  END CASE.
  RETURN in-status-aux.
END FUNCTION.

for each import-docto-revis-ctas where import-docto-revis-ctas.ind-sit-import = "RC" exclusive-lock:
    MESSAGE "Distribuindo Documentos RC " import-docto-revis-ctas.num-seqcial-control.

    assign import-docto-revis-ctas.ind-sit-import = proximo-status().

end.
