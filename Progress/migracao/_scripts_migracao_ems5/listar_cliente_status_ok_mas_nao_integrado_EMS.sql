-- listar cliente status ok mas nao integrado EMS
select count(*) from ti_cliente tic
where tic.cdsituacao = 'IT'
and not exists(select 1 from
ems5.cliente c
where c.cdn_cliente = tic.cod_cliente);
