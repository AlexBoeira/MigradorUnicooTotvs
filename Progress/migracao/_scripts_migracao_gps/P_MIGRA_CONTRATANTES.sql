--delete from temp_migracao_contratante tc where tc.cdsituacao = 'ER';
--commit;

begin
  pck_unicoogps.p_contratante;
end;

--select count(*) from CONTRAT
--select count(*) from CONTRIMP
--select count(*) from CONTROL_MIGRAC cm where cm.ind_tip_migrac = 'CR'
--select count(*) from TEMP_MIGRACAO_CONTRATANTE
--select count(*) from ERRO_PROCESS_IMPORT
