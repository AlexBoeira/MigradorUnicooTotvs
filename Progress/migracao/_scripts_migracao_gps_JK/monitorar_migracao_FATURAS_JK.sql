SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS MIGRACAO FATURA</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\FATURA\STATUS_MIGRACAO_FATURAS.html

select decode(F.COD_LIVRE_1,'ER','ERRO','IT','INTEGRADO','RE','REPROCESSANDO') SITUACAO, count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU

from gp.migrac_fatur f
group by f.cod_livre_1
order by f.cod_livre_1;

-- listar erros do extrator de faturas FP
select f.cod_livre_2, count(*)
from gp.migrac_fatur f
where f.cod_livre_1 = 'ER'
group by f.cod_livre_2
order by 2;

-- listar erros importacao faturas FP
select f.cod_livre_2, f.*
from gp.migrac_fatur f
where f.cod_livre_1 = 'ER';

-- listar erros importacao faturas FP
select f.cod_livre_2, count(*)
from gp.migrac_fatur f
where f.cod_livre_1 = 'PE'
group by f.cod_livre_2
order by 2;

-- listar erros importacao faturas FP
select f.cod_livre_2, f.*
from gp.migrac_fatur f
where f.cod_livre_1 = 'PE';

SPOOL OFF   
exit;
