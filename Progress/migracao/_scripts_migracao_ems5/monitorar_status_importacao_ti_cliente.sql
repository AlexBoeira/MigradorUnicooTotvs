-- status ti_cliente
select cdsituacao, count(*) 
from ti_cliente 
group by cdsituacao
order by 1
