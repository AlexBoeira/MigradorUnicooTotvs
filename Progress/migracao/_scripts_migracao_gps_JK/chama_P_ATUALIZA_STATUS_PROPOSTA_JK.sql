set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_unicoogps.P_ATUALIZA_STATUS_PROPOSTA_JK(&1);
  commit;
end;
/
-- monitorar status importação propostas
select ip.u##ind_sit_import SITUACAO, count(*) QTD from import_propost ip
group by ip.u##ind_sit_import
order by ip.u##ind_sit_import
;
