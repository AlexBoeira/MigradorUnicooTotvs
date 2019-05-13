-- listar cliente sem cliente financeiro
select count(*) from ems5.cliente c
where not exists(select 1 from ems5.clien_financ cf
where cf.cdn_cliente = c.cdn_cliente);

