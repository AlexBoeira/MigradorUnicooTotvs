-- listar erros importacao documentos RC
select e.num_seqcial,e.num_seqcial_control,e.des_erro,e.dat_erro,
e.des_ajuda, e.nom_tab_orig_erro, d.*
from gp.erro_process_import e, gp.import_docto_revis_ctas d
where e.num_seqcial_control = d.num_seqcial_control
and d.ind_sit_import = 'PE'
--and e.des_erro like '%Periodo de movimentacao nao cadastrado%';