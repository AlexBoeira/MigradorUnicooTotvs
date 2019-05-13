--LIMPAR TEMPORARIAS DE IMPORTACAO DE CLIENTES REPROCESSAR - PRESERVA APENAS OS 'IT' (INTEGRADOS COM SUCESSO)
declare
begin
  for x in (select ci.nrsequencial from ti_controle_integracao ci where ci.cdsituacao <> 'IT' and ci.tpintegracao = 'CL') loop
      delete from ti_cliente tc where tc.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
      delete from ti_controle_integracao ci where ci.nrsequencial = x.nrsequencial;
  end loop;
  commit;
  pck_ems506unicoo.P_CARGA_INICIAL_CLIENTE;
  commit;
end;
