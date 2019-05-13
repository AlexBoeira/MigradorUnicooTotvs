begin
  pck_unicoogps.p_migra_especialidade;
  --select count(*) from gp.esp_med;
  --select count(*) from gp.assespec;
  --select count(*) from gp.esp_med;

  -- parametro CHAR
  --   0 - apenas gera as temporárias, sem apagar nada;
  --   1 - apaga as temporárias de geração de prestadores (TEMP_MIGRACAO_PRESTADOR, 
  --                                                       TEMP_MIGRACAO_ENDERECO_PREST,
  --                                                       TEMP_MIGRACAO_PREST_VINC_ESPEC);
  --   2 - apaga as tabelas temporárias (acima) e também as tabelas de Prestador do GPS
  --                                                      (PRESERV, ENDPRES, PREVIESP, 
  --                                                       PRESTDOR_ENDER, PTUGRSER, 
  --                                                       HISTPREST, PREST_AREA_ATU,
  --                                                       PRESTDOR_END_INSTIT, PRESTDOR_OBS);
  pck_migracao_txt_gp.P_GERA_PRESTADOR('2');
end;
--select count(*) from TEMP_MIGRACAO_PRESTADOR 
--select count(*) from TEMP_MIGRACAO_ENDERECO_PREST
--select count(*) from TEMP_MIGRACAO_PREST_VINC_ESPEC
--select count(*) from gp.preserv
--select count(*) from previesp
--select count(*) from gp.endpres

--DELETE FROM TEMP_MIGRACAO_PRESTADOR 
--DELETE FROM TEMP_MIGRACAO_ENDERECO_PREST
--DELETE FROM TEMP_MIGRACAO_PREST_VINC_ESPEC
