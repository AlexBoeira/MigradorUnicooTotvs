--associar o Prestador ao seu Termo de Adesao quando há débito da produção
begin
  pck_unicoogps.P_GERA_DEB_PROD;
end;

--select distinct t.cd_unidade_prestador, t.cd_prestador from ter_ade t where t.lgdescontaplanoproducao = 1
