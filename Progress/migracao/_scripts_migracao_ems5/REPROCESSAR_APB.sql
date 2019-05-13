--LIMPAR TEMPORARIAS DE IMPORTACAO DE TITULOS APB PARA REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'TP') loop
      delete from ti_tit_apb tp where tp.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_apb_ctbl c where c.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_apb_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
  commit;
  pck_ems506unicoo.P_CARGA_TIT_APB;
  commit;
-- informar no parâmetro o número de filas desejado (R0, R1, R2, etc...)
--  pck_ems506unicoo.p_atualiza_status_tit_apb(2);
end;
