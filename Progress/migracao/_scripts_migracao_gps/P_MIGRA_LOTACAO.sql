/*
select * from gp.lotac;
select * from temp_depara_lotacao;
*/
/*
delete from TEMP_DEPARA_LOTACAO;
delete from gp.lotac;
analyze table temp_depara_lotacao compute statistics for table for all indexes for all indexed columns;
analyze table GP.lotac compute statistics for table for all indexes for all indexed columns;
*/

begin
  pck_unicoogps.p_migra_lotacao;
end;
