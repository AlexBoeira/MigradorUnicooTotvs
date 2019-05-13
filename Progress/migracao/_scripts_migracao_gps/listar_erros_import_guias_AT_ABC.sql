-- erros importacao guias AT por quantidade de ocorrencias
select e.des_erro, count(*) 
from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'PE'

--and e.des_erro like '%Prestador Solicitante informado nao cadastrado. Unidade: 0023 Prestador:%'

group by e.des_erro order by 2 desc;

--Prestador Solicitante informado nao cadastrado. Unidade: 0023 Prestador: 000001  
--select * from gp.preserv p where p.cd_unidade = 23

