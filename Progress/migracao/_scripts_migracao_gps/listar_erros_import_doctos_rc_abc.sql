-- erros importacao documentos RC por quantidade de ocorrencias
select e.des_erro, count(*) 
from gp.erro_process_import e, gp.import_docto_revis_ctas d
where e.num_seqcial_control = d.num_seqcial_control
and d.ind_sit_import = 'PE'
group by e.des_erro order by 2 desc;
