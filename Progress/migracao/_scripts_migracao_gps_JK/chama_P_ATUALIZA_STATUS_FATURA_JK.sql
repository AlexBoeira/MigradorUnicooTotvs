set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_unicoogps.P_ATUALIZA_STATUS_FATURA_JK(&1);
  commit;
end;
/
-- monitorar status importacao faturas FP
select substr(f.cod_livre_1,1,10) SITUACAO, count(*) QTD
from gp.migrac_fatur f
group by f.cod_livre_1
order by f.cod_livre_1;
