set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
/*
select * from gp.ESP_MED;--75
select * from gp.ASSESPEC;--75
select * from gp.CBO_ESP;--74
*/
/*
delete from gp.ESP_MED;
delete from gp.ASSESPEC;
delete from gp.CBO_ESP;
*/
--analyze table GP.ESP_MED  compute statistics for table for all indexes for all indexed columns;
--analyze table GP.ASSESPEC compute statistics for table for all indexes for all indexed columns;
--analyze table GP.CBO_ESP  compute statistics for table for all indexes for all indexed columns;
begin
  pck_unicoogps.p_migra_especialidade;
  commit;
end;
/