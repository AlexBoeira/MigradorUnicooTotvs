-- REPROCESSAR CLIENTE SEM CLIEN_FINANC
update ti_cliente tic set tic.cdsituacao = 'RC'
where tic.cdsituacao = 'PE'
and exists(select 1 from cliente c
where c.nom_abrev = tic.nom_abrev
and not exists(select 1 from clien_financ cf
where cf.cdn_cliente = c.cdn_cliente))