--LISTAR ERROS MIGRACAO CONTRATANTE
select c.nrregistro NRREGISTRO, c.nr_insc_contrat, e.des_erro, e.des_ajuda, e.dat_ult_atualiz, e.hra_ult_atualiz,
       c.nocontratante, c.tppessoa, c.cgc_cpf, c.noabreviado, c.dtnascimento, c.nrgrupo_cliente, c.cdcontratante
       from erro_process_import e, temp_migracao_contratante c
where e.num_seqcial_control = c.nrseq_controle
and c.cdsituacao = 'ER';
