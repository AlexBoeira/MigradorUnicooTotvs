SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS MIGRACAO GUIAS AUTORIZACAO</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\GUIAS_AUTORIZACAO\STATUS_MIGRACAO_GUIAS_AUTORIZACAO.html

-- monitorar status importacao guias AT
select g.u##ind_sit_import, count(*) QTD,        sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU

from gp.import_guia g
group by g.u##ind_sit_import order by g.u##ind_sit_import desc

-- erros importacao guias AT por quantidade de ocorrencias
select e.des_erro, count(*) 
from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'PE'

-- erros importacao guias AT por quantidade de ocorrencias
select e.des_erro, count(*) 
from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'ER'
group by e.des_erro order by 2 desc;

-- listar erros importacao guias AT
select e.*, g.* from gp.erro_process_import e, gp.import_guia g
where e.num_seqcial_control = g.num_seqcial_control
and g.u##ind_sit_import = 'PE'






--
--update import_guia ig set ig.u##ind_sit_import = 'RC', ig.ind_sit_import = 'RC' where ig.u##ind_sit_import in ('0','1');
--commit;
--select distinct u##ind_sit_import from import_guia
--ER antes: 1391
/*
RC	22557	  18/02/2019 09:00:32
IT	1552335	18/02/2019 09:00:32
ER	614	    18/02/2019 09:00:32
1	1	        18/02/2019 09:00:32
0	1	        18/02/2019 09:00:32
*/

/*begin
  pck_unicoogps.p_remover_guias_para_atualizar;
end;
*/  

--select * from gp.guiautor g where g.cd_unidade = 23 and g.aa_guia_atendimento = 2001 and g.nr_guia_atendimento = 28948833
--select * from gp.import_guia ig where ig.cd_unimed = 23 and ig.aa_guia_atendimento = 2001 and ig.nr_guia_atendimento = 28948833
--select * from gp.import_guia_movto m where m.num_livre_5 = 38229067

--select * from tm_parametro for update


SPOOL OFF
exit;