/* cria as seguintes tabelas:
(p_migra_pl_gr_pa)
select count(*) from PL_GR_PA

(p_migra_qtdmoeda)
select count(*) from TABPREPR 
select count(*) from TAPRAMPR 
select count(*) from PREPADIN

(p_migra_forpagtx)
select count(*) from FOR_PAG
select count(*) from CONTIPPL
select count(*) from FORPAGTX

(p_migra_quantitativo_permitido)
select count(*) from TOTPROPR
select count(*) from PROPERUS

(p_migra_trans_mod_proced)
select count(*) from TRMODAMB
select count(*) from TRMODTPI
*/
/** caso seja necessário reprocessar essa etapa, descomentar esse trecho para limpar as tabelas:
truncate table gp.PL_GR_PA;
truncate table gp.TABPREPR;
truncate table gp.TAPRAMPR;
truncate table gp.PREPADIN;
truncate table gp.FOR_PAG;
truncate table gp.CONTIPPL;
truncate table gp.FORPAGTX;
truncate table gp.TOTPROPR;
truncate table gp.PROPERUS;
truncate table gp.TRMODAMB;
truncate table gp.TRMODTPI;
analyze table GP.PL_GR_PA compute statistics for table for all indexes for all indexed columns;
analyze table GP.TABPREPR compute statistics for table for all indexes for all indexed columns;
analyze table GP.TAPRAMPR compute statistics for table for all indexes for all indexed columns;
analyze table GP.PREPADIN compute statistics for table for all indexes for all indexed columns;
analyze table GP.FOR_PAG compute statistics for table for all indexes for all indexed columns;
analyze table GP.CONTIPPL compute statistics for table for all indexes for all indexed columns;
analyze table GP.FORPAGTX compute statistics for table for all indexes for all indexed columns;
analyze table GP.TOTPROPR compute statistics for table for all indexes for all indexed columns;
analyze table GP.PROPERUS compute statistics for table for all indexes for all indexed columns;
analyze table GP.TRMODAMB compute statistics for table for all indexes for all indexed columns;
analyze table GP.TRMODTPI compute statistics for table for all indexes for all indexed columns;
*/

begin        
    pck_unicoogps.p_migra_estrutura;
end;
