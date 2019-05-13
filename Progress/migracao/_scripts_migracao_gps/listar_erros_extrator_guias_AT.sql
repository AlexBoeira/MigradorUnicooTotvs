-- listar erros importacao guias AT
select e.*, g.* from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'ER';
