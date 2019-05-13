set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_unicoogps.p_import_fatura;
  commit;							
end;
/
