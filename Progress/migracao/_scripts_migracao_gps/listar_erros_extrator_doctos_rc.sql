-- listar erros importacao documentos RC
select e.* from gp.erro_process_import e, gp.import_docto_revis_ctas d
where e.num_seqcial_control = d.num_seqcial_control
and d.ind_sit_import = 'ER';