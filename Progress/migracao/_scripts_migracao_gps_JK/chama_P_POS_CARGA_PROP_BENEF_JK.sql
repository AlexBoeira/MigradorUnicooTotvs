set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  PCK_UNICOOGPS.p_pos_carga_proposta_e_benef;
  commit;
end;
/
