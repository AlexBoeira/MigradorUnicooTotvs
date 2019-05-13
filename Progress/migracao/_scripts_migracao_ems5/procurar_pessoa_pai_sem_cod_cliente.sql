select * from ti_pessoa p
where (p.nrregistro_pai is null or p.nrregistro_pai = 0)
and (p.cdn_cliente = 0 or p.cdn_cliente is null) -- 4004
and (p.cdn_fornecedor = 0 or p.cdn_fornecedor is null) -- 4001
