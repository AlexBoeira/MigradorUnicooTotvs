-- erros importacao guias AT por quantidade de ocorrencias
select e.des_erro, count(*) 
from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'ER'
group by e.des_erro order by 2 desc;
-- reprocessar status ER:
-- delete from gp.import_guia ig where ig.ind_sit_import = 'ER'

/*select * from gp.trmodamb;
select distinct dt_limite from gp.trmodamb;
update gp.trmodamb t set t.dt_limite = '31/03/2019' where t.dt_limite <> '31/12/9999';

select * from gp.trmodtpi

select distinct char_1, char_2, char_3, char_4, char_5, u_char_1, u_char_2, u_char_3 from gp.trmodtpi;
select */
