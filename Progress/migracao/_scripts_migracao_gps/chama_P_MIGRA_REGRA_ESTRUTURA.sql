/*
select count(*) from REGRA_MENSLID;
select count(*) from REGRA_MENSLID_CRITER;
select count(*) from REGRA_MENSLID_ESTRUT;
*/
begin
  pck_unicoogps.p_migra_regra_estrutura;
end;
/*
delete from regra_menslid_criter rmc
where exists(select 1 from regra_menslid rm
              where rm.cdd_regra = rmc.cdd_regra
                and rm.log_livre_1 = 1); --eh regra modelo
delete from regra_menslid_estrut rme
where exists(select 1 from regra_menslid rm
              where rm.cdd_regra = rme.cdd_regra
                and rm.log_livre_1 = 1); --eh regra modelo
delete from regra_menslid rm
where rm.log_livre_1 = 1; --eh regra modelo
*/

/*
truncate table gp.REGRA_MENSLID;
truncate table  gp.REGRA_MENSLID_CRITER;
truncate table  gp.REGRA_MENSLID_ESTRUT;
truncate table  falha_processo_regra_menslid;
analyze table gp.REGRA_MENSLID       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_CRITER       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_ESTRUT       compute statistics for table for all indexes for all indexed columns;
analyze table falha_processo_regra_menslid compute statistics for table for all indexes for all indexed columns;
*/
