-- status ti_cliente
select cdsituacao, count(*) 
from ems506unicoo.ti_cx_bx_acr
group by cdsituacao
order by 1
