-- REPROCESSAR CLIENTE COM ERRO NO PROGRESS
update ti_cliente tic set tic.cdsituacao = 'RC' --1376315 
where exists(select 1 from ti_falha_de_processo e
where e.nrseq_controle_integracao = tic.nrseq_controle_integracao
and e.txfalha like '%Agência%')
