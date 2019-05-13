/** carrega as seguintes tabelas:
 select * from gp.TOTPROPR
 select * from gp.PROPERUS
*/ 
/** caso seja necessário reprocessar essa etapa, descomentar esse trecho para limpar as tabelas:
truncate table gp.TOTPROPR;
truncate table gp.PROPERUS;
analyze table GP.TOTPROPR compute statistics for table for all indexes for all indexed columns;
analyze table GP.PROPERUS compute statistics for table for all indexes for all indexed columns;
*/

begin
       pck_unicoogps.p_migra_quantitativo_permitido;
end;
