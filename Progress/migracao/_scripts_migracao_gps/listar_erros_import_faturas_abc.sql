-- listar erros importacao faturas FP
select f.cod_livre_2, count(*)
from gp.migrac_fatur f
where f.cod_livre_1 = 'PE'
group by f.cod_livre_2
order by 2


