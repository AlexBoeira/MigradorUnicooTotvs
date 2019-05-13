select * from ti_cliente cl, ti_pessoa p
where cl.nrpessoa = p.nrregistro
and (p.nrregistro_pai = 0 or p.nrregistro_pai is null)
and (p.cdn_cliente = 0 or p.cdn_cliente is null)
