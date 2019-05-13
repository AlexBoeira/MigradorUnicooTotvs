-- listar erros importacao guias AT
select e.*, g.* from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'PE'

--and e.des_erro like '%Tabela padrao de moedas e carencias%'
;

--select * from gp.erro_process_import e where e.num_seqcial_control = 62746892
/*
54539834
u##cod_guia_operdra = 28685833 (nr_guia_atendimento)
num_livre_2 = 28685833
cod_guia_unimed_intercam = 12883163

select * from gp.import_guia ig where ig.u##cod_guia_operdra = 28685833
delete from gp.import_guia ig where ig.u##cod_guia_operdra = 28685833
*/

--select * from import_guia_movto m where m.val_seq_guia = 56696848