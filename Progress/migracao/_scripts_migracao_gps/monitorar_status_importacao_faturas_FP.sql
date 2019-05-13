-- monitorar status importacao faturas FP
select f.cod_livre_1, count(*)
from gp.migrac_fatur f
group by f.cod_livre_1
order by f.cod_livre_1;
/*
ER	1332
IT	483291
PE	463
*/
