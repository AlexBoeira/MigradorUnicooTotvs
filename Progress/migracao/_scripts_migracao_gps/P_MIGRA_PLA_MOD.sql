/** carrega as seguintes tabelas:
 select * from gp.PLA_MOD;
 select * from gp.TABPREPL;
 select * from gp.TABPREMO;
 select * from gp.FTPADCOB;
 select * from gp.PARTINSU;
 select * from gp.PL_MO_AM;
*/ 
/** caso seja necessário reprocessar essa etapa, descomentar esse trecho para limpar as tabelas:
truncate table gp.PLA_MOD;
truncate table gp.TABPREPL;
truncate table gp.TABPREMO;
truncate table gp.FTPADCOB;
truncate table gp.PARTINSU;
truncate table gp.PL_MO_AM;
analyze table GP.PLA_MOD  compute statistics for table for all indexes for all indexed columns;
analyze table GP.TABPREPL compute statistics for table for all indexes for all indexed columns;
analyze table GP.TABPREMO compute statistics for table for all indexes for all indexed columns;
analyze table GP.FTPADCOB compute statistics for table for all indexes for all indexed columns;
analyze table GP.PARTINSU compute statistics for table for all indexes for all indexed columns;
analyze table GP.PL_MO_AM compute statistics for table for all indexes for all indexed columns;
*/

begin
     pck_unicoogps.p_migra_pla_mod;
end;
