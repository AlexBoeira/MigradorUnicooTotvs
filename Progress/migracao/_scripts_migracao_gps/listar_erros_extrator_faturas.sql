-- listar erros importacao faturas FP
select f.cod_livre_2, f.*
from gp.migrac_fatur f
where f.cod_livre_1 = 'ER'

