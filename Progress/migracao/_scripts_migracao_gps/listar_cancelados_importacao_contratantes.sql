--LISTAR CONTRATANTES QUE N�O SER�O MIGRADOS DEVIDO A PARAMETRIZA��ES 
--(EX.: GRUPO DO CLIENTE PARAMETRIZADO PARA N�O MIGRAR)
select * from erro_process_import e
where exists (select 1 from temp_migracao_contratante c
where e.num_seqcial_control = c.nrseq_controle
and c.cdsituacao = 'CA');
