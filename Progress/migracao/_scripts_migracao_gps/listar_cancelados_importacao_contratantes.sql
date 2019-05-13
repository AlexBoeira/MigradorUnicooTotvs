--LISTAR CONTRATANTES QUE NÃO SERÃO MIGRADOS DEVIDO A PARAMETRIZAÇÕES 
--(EX.: GRUPO DO CLIENTE PARAMETRIZADO PARA NÃO MIGRAR)
select * from erro_process_import e
where exists (select 1 from temp_migracao_contratante c
where e.num_seqcial_control = c.nrseq_controle
and c.cdsituacao = 'CA');
