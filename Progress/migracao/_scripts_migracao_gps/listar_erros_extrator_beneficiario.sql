-- listar erros extrator beneficiário
select e.*, b.* from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.ind_sit_import = 'ER';

