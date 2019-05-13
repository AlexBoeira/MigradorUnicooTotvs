-- erros P_CARGA_PESSOA_UNIMED
select fa.* from ti_falha_de_processo fa, ti_controle_integracao con
where con.nrsequencial = fa.nrseq_controle_integracao
  and con.cdsituacao = 'ER'
  and con.tpintegracao = 'FN'
