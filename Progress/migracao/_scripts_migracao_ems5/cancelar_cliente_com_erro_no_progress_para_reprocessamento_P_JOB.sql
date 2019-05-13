-- CANCELANDO CLIENTE COM ERRO PROGRESS PARA REPROCESSAMENTO DE P_JOB
update ti_cliente tic set tic.cdsituacao = 'CA' where tic.cdsituacao = 'PE'
