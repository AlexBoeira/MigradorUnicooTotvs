set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_unicoogps.P_ATUALIZA_STATUS_BENEF_JK(&1);
  commit;
end;
/
