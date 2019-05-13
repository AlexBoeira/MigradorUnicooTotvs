--LISTAR CONTRATANTES QUE NÃO SERÃO MIGRADOS DEVIDO A PARAMETRIZAÇÕES POR ORDEM DE OCORRENCIA
--(EX.: GRUPO DO CLIENTE PARAMETRIZADO PARA NÃO MIGRAR)
select e.des_erro, count(*)
from gp.erro_process_import e, temp_migracao_contratante c
where e.num_seqcial_control = c.nrseq_controle
and c.cdsituacao = 'ER'
group by e.des_erro order by 2 desc;
