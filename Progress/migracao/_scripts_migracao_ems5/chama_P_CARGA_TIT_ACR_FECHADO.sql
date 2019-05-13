-- carregar os titulos A Receber que estao fechados.
-- os mesmos serao criados como EM ABERTO nesse processo, e sua baixa sera processada automaticamente
-- na etapa Progress (ti_tit_acr.p)
-- como diferenciar titulos abertos e fechados na TI_CONTROLE_INTEGRACAO:
--   TPINTEGRACAO: TR (igual para abertos e fechados)
--   CDACAO: I - abertos; F - fechados;
begin
  PCK_EMS506UNICOO.p_carga_tit_acr_fechado('01/01/2018'); -- informar data inicial para buscar titulos fechados no UNICOO
  pck_ems506unicoo.P_CARGA_BAIXA_TIT_ACR;
end;
--select count(*) from ti_tit_acr--
