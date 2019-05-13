--LIMPAR TEMPORARIAS DE IMPORTACAO DE CLIENTES PARA REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'CL') loop
      delete from ti_cliente c where c.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
end;

--CONFERENCIA
select tpintegracao, cdsituacao, count(*), SYSDATE
  from ti_controle_integracao where tpintegracao = 'CL'
 group by cdsituacao, tpintegracao
 order by 1, 2;

/*
 select count(*) from ti_cliente c where c.cdsituacao = 'RC'
 
         select count(*) --/ 1
--          into vqtregistros
          from ti_cliente
         where cdsituacao = 'RC';
*/