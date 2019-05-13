-- CÓDIGO COMENTADO PARA EVITAR QUE SEJA EXECUTADO POR ACIDENTE.
-- EM CASO DE NECESSIDADE, DESCOMENTAR.

/*
truncate table TEMP_DEPARA_LOTACAO;
analyze table TEMP_DEPARA_LOTACAO compute statistics for table for all indexes for all indexed columns;
truncate table gp.LOTAC;
analyze table GP.LOTAC compute statistics for table for all indexes for all indexed columns;

truncate table gp.IMPORT_PROPOST;
truncate table gp.IMPORT_LOTAC_PROPOST;
truncate table gp.IMPORT_MODUL_PROPOST;
truncate table gp.IMPORTPADRCOBERTPROPOST;
truncate table gp.IMPORT_CAMPOS_PROPOST;
truncate table gp.IMPORT_FAIXA_PROPOST;
truncate table gp.IMPORT_FUNCAO_PROPOST;
truncate table gp.IMPORT_MO_PROPOST;
truncate table gp.IMPORT_NEGOCIAC_PROPOST;
truncate table gp.IMPORT_PROCED_PROPOST;
truncate table gp.IMPORT_BNFCIAR;
truncate table gp.IMPORT_MODUL_BNFCIAR;
truncate table gp.IMPORT_NEGOCIAC_BNFCIAR;
truncate table gp.IMPORT_ATENDIM_BNFCIAR;
truncate table gp.IMPORT_COBERT_BNFCIAR;
--truncate table ERRO_PROCESS_IMPORT;

analyze table gp.IMPORT_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_LOTAC_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_MODUL_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORTPADRCOBERTPROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_CAMPOS_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_FAIXA_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_FUNCAO_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_MO_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_NEGOCIAC_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_PROCED_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_MODUL_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_NEGOCIAC_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_ATENDIM_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_COBERT_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
--analyze table gp.ERRO_PROCESS_IMPORT    compute statistics for table for all indexes for all indexed columns;


--select count(*) from erro_process_import --80930
*/