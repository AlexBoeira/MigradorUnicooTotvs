set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
--TITULOS ACR
begin
  pck_ems506unicoo.P_CARGA_TIT_APB;
end;
/
--select count(*) from ti_tit_acr
