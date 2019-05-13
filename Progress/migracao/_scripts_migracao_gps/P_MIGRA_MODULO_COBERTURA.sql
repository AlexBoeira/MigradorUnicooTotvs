/** carrega as seguintes tabelas:
 select * from gp.MOD_COB
*/ 
/** caso seja necessário reprocessar essa etapa, descomentar esse trecho para limpar as tabelas:
truncate table gp.mod_cob;
analyze table GP.mod_cob compute statistics for table for all indexes for all indexed columns;
*/

begin
       pck_unicoogps.p_migra_modulo_cobertura;
end;
