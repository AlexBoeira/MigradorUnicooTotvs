-- PERIODO_INICIAL: periodo inicial das faturas a serem importadas - OBRIGATORIO;
-- PERIODO_FINAL:   periodo final das faturas a serem importadas   - OBRIGATORIO;
begin
  pck_unicoogps.p_import_fatura(201701 /*PERIODO_INICIAL (AAAAMM)*/,
                                201812 /*PERIODO_FINAL   (AAAAMM)*/);
end;


--original: 44min
--apos ajustes: 103min
