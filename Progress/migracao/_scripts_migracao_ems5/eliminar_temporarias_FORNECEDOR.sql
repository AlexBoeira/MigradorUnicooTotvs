--LIMPAR TEMPORARIAS DE IMPORTACAO DE FORNECEDORES PARA REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'FN') loop
      delete from ti_fornecedor f where f.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
end;

--CONFERENCIA
select tpintegracao, cdsituacao, count(*), SYSDATE
  from ti_controle_integracao where tpintegracao = 'FN'
 group by cdsituacao, tpintegracao
 order by 1, 2;
