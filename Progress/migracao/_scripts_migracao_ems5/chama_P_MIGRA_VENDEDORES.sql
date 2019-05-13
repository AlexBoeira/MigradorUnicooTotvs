set echo on
begin
  pck_ems506unicoo.p_migra_vendedores;
  commit;
end;
/
--select * from ems5.repres_financ
