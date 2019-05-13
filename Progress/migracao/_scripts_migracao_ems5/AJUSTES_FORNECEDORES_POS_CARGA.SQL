--AJUSTES POS-CARGA RELACIONADOS AOS FORNECEDORES
begin
  delete from CTA_CORREN_FORNEC_FALHA;
  -- informar no parâmetro o código da empresa no EMS5
  pck_ems506unicoo.P_GERAR_DADOS_BANC_FORNEC(1);
  pck_ems506unicoo.P_ATUALIZA_FLUXO_FINANC_FORNEC;
  pck_ems506unicoo.P_VINCULA_IMPOSTO_FORNEC;
end;

--select count(*) from FORNEC_FINANC
--select count(*) from CTA_CORREN_FORNEC
--select * from CTA_CORREN_FORNEC_FALHA
--select * from IMPTO_VINCUL_FORNEC
