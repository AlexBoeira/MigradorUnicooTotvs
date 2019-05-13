--ANALYSE DAS TABELAS DO UNICOO CONSUMIDAS PELA MIGRACAO DE GUIAS.
--OBJETIVO: OTIMIZAR PERFORMANCE CASO O PLANO DE EXEUÇÃO NÃO ESTEJA CORRETO NO AMBIENTE.
--EXECUTAR ANTES DE INICIAR A MIGRAÇÃO DAS GUIAS PARA O TOTVS.

analyze table area_de_acao        compute statistics for table for all indexes for all indexed columns;
analyze table autorizacao                 compute statistics for table for all indexes for all indexed columns;
analyze table cbo                        compute statistics for table for all indexes for all indexed columns;
analyze table emissao_servico_guia        compute statistics for table for all indexes for all indexed columns;
analyze table emissao_guia        compute statistics for table for all indexes for all indexed columns;
analyze table especialidade       compute statistics for table for all indexes for all indexed columns;
analyze table especialista               compute statistics for table for all indexes for all indexed columns;
analyze table ocorrencia      compute statistics for table for all indexes for all indexed columns;
analyze table ocorrencia_autorizacao      compute statistics for table for all indexes for all indexed columns;
analyze table parametro           compute statistics for table for all indexes for all indexed columns;
analyze table pessoa              compute statistics for table for all indexes for all indexed columns;
analyze table prestador           compute statistics for table for all indexes for all indexed columns;
analyze table servico             compute statistics for table for all indexes for all indexed columns;
analyze table servico_da_autorizacao      compute statistics for table for all indexes for all indexed columns;
analyze table usuario      compute statistics for table for all indexes for all indexed columns;
