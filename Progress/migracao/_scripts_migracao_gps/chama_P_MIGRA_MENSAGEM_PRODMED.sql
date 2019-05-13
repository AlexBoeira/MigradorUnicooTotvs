begin
  pck_unicoogps.p_migra_mensagem_prodmed;
end;

--select count(*) from ITEMPLAN;--96
--select count(*) from DESPLAUS;--1765
--select * from itemplan i where exists(select 1 from gp.usuario u 
--where u.cd_modalidade = i.cd_modalidade and u.nr_ter_adesao = i.nr_ter_adesao and u.dt_exclusao_plano is null)
