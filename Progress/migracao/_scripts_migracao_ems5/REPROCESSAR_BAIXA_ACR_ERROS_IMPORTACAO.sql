--LIMPAR TEMPORARIAS DE IMPORTACAO DAS BAIXAS DE TITULOS ACR PARA REPROCESSAR ERROS DE IMPORTACAO
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
end;
