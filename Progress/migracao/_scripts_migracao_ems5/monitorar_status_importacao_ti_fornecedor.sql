-- status ti_fornecedor
select cdsituacao, count(*) 
from ti_fornecedor 
group by cdsituacao
order by 1
