--LIMPAR TEMPORARIAS DE IMPORTACAO DAS BAIXAS DE TITULOS ACR PARA REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'BR') loop
      delete from ti_cx_bx_acr br where br.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
  commit;
  pck_ems506unicoo.p_carga_baixa_tit_acr;
  commit;
--  pck_ems506unicoo.p_atualiza_status_baixa_acr(9);
end;


/*
--LIMPAR TEMPORARIAS DE IMPORTACAO DAS BAIXAS DE TITULOS ACR EM SITUACAO 'PE' E 'ER' PARA REPROCESSAR
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao in ('PE','ER') and ci.tpintegracao = 'BR') loop
      delete from ti_cx_bx_acr br where br.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
  commit;
  pck_ems506unicoo.p_carga_baixa_tit_acr;
  commit;
--  pck_ems506unicoo.p_atualiza_status_baixa_acr(9);
end;
*/