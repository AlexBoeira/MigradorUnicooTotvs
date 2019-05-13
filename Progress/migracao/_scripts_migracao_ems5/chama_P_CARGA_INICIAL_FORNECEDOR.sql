-- carregar temporarias de FORNECEDORES com UNIMEDS (AREA_DE_ACAO) e FORNECEDORES do UNICOO, para posterior
-- importação no EMS5
begin
  PCK_EMS506UNICOO.P_CARGA_PESSOA_UNIMED;
  pck_ems506unicoo.P_CARGA_INICIAL_FORNECEDOR;
end;
--select count(*) from ti_fornecedor
