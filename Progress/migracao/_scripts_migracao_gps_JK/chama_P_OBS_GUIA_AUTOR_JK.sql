set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
-- carregar HISTOR_OBS_GUIA com historico de observacoes das Guias de autorizacao
begin
  pck_unicoogps.p_obs_guia_autor;
  commit;
end;
/

--delete from histor_obs_guia;
--select count(*) from histor_obs_guia
--select nr_guia_atendimento, count(*) from histor_obs_guia group by nr_guia_atendimento order by 2 desc
--select aa_guia_atendimento from guiautor where nr_guia_atendimento = 26955052

--select h.cd_unidade, h.aa_guia_atendimento, h.nr_guia_atendimento, count(*) 
--from histor_obs_guia h group by h.cd_unidade, h.aa_guia_atendimento, h.nr_guia_atendimento order by count(*) desc
--select h.num_seqcial, h.dat_ult_atualiz, h.hra_ult_atualiz, h.des_observacao from histor_obs_guia h 
--where h.cd_unidade = 23 and h.aa_guia_atendimento = 2017 and h.nr_guia_atendimento = 26734501
