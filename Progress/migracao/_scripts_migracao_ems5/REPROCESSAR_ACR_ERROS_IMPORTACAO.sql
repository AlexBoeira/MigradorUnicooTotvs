--LIMPAR TEMPORARIAS PARA REPROCESSAR ERROS DE IMPORTACAO - ACR
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao = 'PE' and ci.tpintegracao = 'TR') loop
      delete from ti_tit_acr tr where tr.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_acr_ctbl c where c.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_acr_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
  commit;
  pck_ems506unicoo.p_carga_tit_acr;
  commit;
  pck_ems506unicoo.p_carga_tit_acr_fechado('01/01/2017');
  commit;
end;
