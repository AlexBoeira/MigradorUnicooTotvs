-- listar erros importacao beneficiario por quantidades de ocorrencias
select e.des_erro, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.ind_sit_import = 'ER'
group by e.des_erro order by 2 desc;
