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
end;

--CONFERENCIA
select tpintegracao, cdsituacao, count(*), SYSDATE
  from ti_controle_integracao where tpintegracao = 'TR'
 group by cdsituacao, tpintegracao
 order by 1, 2;

/* APENAS ERROS DE DEPARA
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao = 'ER' and ci.tpintegracao = 'TR') loop
      delete from ti_tit_acr tr where tr.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_acr_ctbl c where c.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_tit_acr_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
end;
 */