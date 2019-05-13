set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_unicoogps.P_ATUALIZA_STATUS_GUIA_AUT_JK(&1);
  commit;
end;
/
-- monitorar status importacao guias AT
select g.u##ind_sit_import SITUACAO, count(*) QTD
from gp.import_guia g
group by g.u##ind_sit_import order by g.u##ind_sit_import desc;
