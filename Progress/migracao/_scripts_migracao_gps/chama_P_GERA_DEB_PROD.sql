--associar o Prestador ao seu Termo de Adesao quando h� d�bito da produ��o
begin
  pck_unicoogps.P_GERA_DEB_PROD;
end;

--select distinct t.cd_unidade_prestador, t.cd_prestador from ter_ade t where t.lgdescontaplanoproducao = 1
