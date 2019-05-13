-- listar erros importação proposta por quantidades de ocorrências
select e.des_erro, count(*)
from gp.erro_process_import e, import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.ind_sit_import = 'PE'
group by e.des_erro order by 2 desc;
