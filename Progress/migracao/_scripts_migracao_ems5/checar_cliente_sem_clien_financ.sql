-- checar cliente sem clien_financ
select c.*, tic.cdsituacao 
from cliente c,
ti_cliente tic
where not exists(select 1
from clien_financ cf
where cf.cdn_cliente = c.cdn_cliente)
and tic.nom_abrev = c.nom_abrev
and tic.cdsituacao != 'CA'