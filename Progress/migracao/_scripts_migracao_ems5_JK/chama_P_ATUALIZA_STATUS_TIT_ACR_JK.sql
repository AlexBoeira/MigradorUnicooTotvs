-- parametro: numero de filas enviado pelo jenkins
set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_ems506unicoo.p_atualiza_status_tit_acr_JK(&1);
end;
/
