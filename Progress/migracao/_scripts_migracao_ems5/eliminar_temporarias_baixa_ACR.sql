--LIMPAR TEMPORARIAS DE IMPORTACAO DE BAIXA DE TITULOS ACR PARA REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'BR') loop
      delete from ti_cx_bx_acr br where br.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
end;

--CONFERENCIA
select tpintegracao, cdsituacao, count(*), SYSDATE
  from ti_controle_integracao where tpintegracao = 'BR'
 group by cdsituacao, tpintegracao
 order by 1, 2;