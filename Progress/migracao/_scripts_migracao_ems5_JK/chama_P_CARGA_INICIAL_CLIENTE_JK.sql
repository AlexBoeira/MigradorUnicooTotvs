-- carregar temporarias de CLIENTES do UNICOO, para posterior
-- importação no EMS5
set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_ems506unicoo.P_CARGA_INICIAL_CLIENTE;
end;
/
--select count(*) from ti_cliente
