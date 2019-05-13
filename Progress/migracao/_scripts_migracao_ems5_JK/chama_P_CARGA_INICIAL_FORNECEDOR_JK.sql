-- carregar temporarias de FORNECEDORES com UNIMEDS (AREA_DE_ACAO) e FORNECEDORES do UNICOO, para posterior
-- importação no EMS5
set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_ems506unicoo.P_CARGA_INICIAL_FORNECEDOR;
end;
/
--select count(*) from ti_fornecedor
