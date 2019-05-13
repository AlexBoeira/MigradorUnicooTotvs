set echo on
truncate table gp.REGRA_MENSLID;
truncate table  gp.REGRA_MENSLID_CRITER;
truncate table  gp.REGRA_MENSLID_PROPOST;
truncate table  gp.REGRA_MENSLID_ESTRUT;
truncate table  gp.regra_menslid_reaj;
truncate table REGRA_MENSLID_sim;
truncate table  REGRA_MENSLID_CRITER_sim;
truncate table  REGRA_MENSLID_PROPOST_sim;
truncate table  REGRA_MENSLID_ESTRUT_sim;
truncate table  regra_menslid_reaj_sim;
truncate table  falha_processo_regra_menslid;
analyze table gp.REGRA_MENSLID       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_CRITER       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_PROPOST       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_ESTRUT       compute statistics for table for all indexes for all indexed columns;
analyze table gp.regra_menslid_reaj       compute statistics for table for all indexes for all indexed columns;
analyze table REGRA_MENSLID_sim       compute statistics for table for all indexes for all indexed columns;
analyze table REGRA_MENSLID_CRITER_sim       compute statistics for table for all indexes for all indexed columns;
analyze table REGRA_MENSLID_PROPOST_sim       compute statistics for table for all indexes for all indexed columns;
analyze table REGRA_MENSLID_ESTRUT_sim       compute statistics for table for all indexes for all indexed columns;
analyze table regra_menslid_reaj_sim       compute statistics for table for all indexes for all indexed columns;
analyze table falha_processo_regra_menslid compute statistics for table for all indexes for all indexed columns;
/
