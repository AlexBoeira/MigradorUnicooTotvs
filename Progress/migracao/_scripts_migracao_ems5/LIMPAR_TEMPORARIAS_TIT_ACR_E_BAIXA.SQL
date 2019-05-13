--LIMPAR TEMPORARIAS DE IMPORTACAO DE TITULOS ACR PARA REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'TR') loop
      delete from ti_tit_acr tr where tr.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_acr_ctbl c where c.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_acr_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'BR') loop
      delete from ti_cx_bx_acr br where br.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
end;


/*select tpintegracao, cdsituacao, decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, count(*), SYSDATE
  from ti_controle_integracao           where tpintegracao in('TR')
 group by cdsituacao, tpintegracao, cdacao
 order by 1, 2;
*/
