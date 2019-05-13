--delete from gp.pl_gr_pa;
analyze table GP.pl_gr_pa compute statistics for table for all indexes for all indexed columns;
begin
  pck_unicoogps.p_migra_pl_gr_pa;
end;
