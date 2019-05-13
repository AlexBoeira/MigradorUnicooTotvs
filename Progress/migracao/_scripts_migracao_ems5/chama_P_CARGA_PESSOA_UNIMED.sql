-- carregar os cadastros de Unimeds do Unicoo para a área temporária de migração
begin
  PCK_EMS506UNICOO.P_CARGA_PESSOA_UNIMED;
end;
--select count(*) from ti_fornecedor t where t.cod_fornecedor between 0 and 999;
