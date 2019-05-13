select count(*) from ti_pessoa p
where not exists(select 1 from ti_cliente c where c.nrpessoa = p.nrregistro) -- 11563
  and not exists(select 1 from ti_fornecedor f where f.nrpessoa = p.nrregistro) -- 177053
