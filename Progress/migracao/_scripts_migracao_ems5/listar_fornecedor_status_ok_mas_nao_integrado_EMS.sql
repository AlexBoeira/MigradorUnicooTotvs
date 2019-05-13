-- listar fornecedor status ok mas nao integrado EMS
select count(*) from ti_fornecedor tif
where tif.cdsituacao = 'IT'
and not exists(select 1 from
ems5.fornecedor f
where f.cdn_fornecedor = tif.cod_fornecedor);
