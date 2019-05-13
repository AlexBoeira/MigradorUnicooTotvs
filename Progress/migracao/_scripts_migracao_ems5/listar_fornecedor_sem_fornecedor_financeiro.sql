-- listar fornecedor sem fornecedor financeiro
select 
--count(*) 
*
from ems5.fornecedor f
where not exists(select 1 from ems5.fornec_financ ff
where ff.cdn_fornecedor = f.cdn_fornecedor);
