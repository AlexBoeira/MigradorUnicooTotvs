SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS MIGRACAO BENEFICIARIOS</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\BENEFICIARIO\STATUS_MIGRACAO_BENEFICIARIO.html

-- monitorar status importacao beneficiarios

select decode(u##ind_sit_import,'GE','GE-GERANDO INCLUSAO','GA','GERANDO ALTERACAO','IT','IT-INTEGRADO','ER','ER-ERRO EXTRATOR','PE','PE-ERRO IMPORTACAO','RC','RC-AGUARDANDO IMPORTACAO',u##ind_sit_import) SITUACAO_GERAL,
       count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_bnfciar ib
 WHERE ib.u##ind_sit_import not in ('EV') --IGNORAR USUARIO EVENTUAL
 group by u##ind_sit_import
 order by u##ind_sit_import;

 select decode(log_respons, 1, 'TITULARES', 'DEPENDENTES') DEPENDENCIA,
       decode(u##ind_sit_import,'GE','GE-GERANDO INCLUSAO','GA','GERANDO ALTERACAO','IT','IT-INTEGRADO','ER','ER-ERRO EXTRATOR','PE','PE-ERRO IMPORTACAO','RC','RC-AGUARDANDO IMPORTACAO',u##ind_sit_import) SITUACAO_POR_DEPENDENCIA,
       count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_bnfciar ib
 WHERE ib.u##ind_sit_import not in ('EV') --IGNORAR USUARIO EVENTUAL
 group by u##ind_sit_import, log_respons
 order by log_respons DESC, u##ind_sit_import;

select decode(u##ind_sit_import,'GE','GE-GERANDO INCLUSAO','GA','GERANDO ALTERACAO','IT','IT-INTEGRADO','ER','ER-ERRO EXTRATOR','PE','PE-ERRO IMPORTACAO','RC','RC-AGUARDANDO IMPORTACAO',u##ind_sit_import) SITUACAO_ATIVOS,
       count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_bnfciar ib
 WHERE ib.u##ind_sit_import not in ('EV') --IGNORAR USUARIO EVENTUAL
   and(ib.dt_exclusao_plano is null or ib.dt_exclusao_plano > sysdate)
 group by u##ind_sit_import
 order by u##ind_sit_import;

 --falta depara ativos
select e.num_seqcial_control, e.dat_erro, e.des_erro FALTA_DEPARA_ATIVOS, e.des_ajuda, 
       b.num_seqcial_bnfciar NRSEQUENCIAL_USUARIO, b.num_seqcial NRREGISTRO,
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, 
     b.nom_usuario, b.dt_nascimento, b.dt_inclusao_plano, b.dt_exclusao_plano, b.cd_motivo_cancel, b.dt_admissao,
     b.u##ind_sit_import SIT
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.ind_sit_import = 'DEPARA'
and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate);
 
-- listar erros extracao beneficiario por quantidades de ocorrencias
select e.des_erro ERROS_EXTRATOR_ATIVOS, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'ER'
and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate)
group by e.des_erro order by 2 desc;

select e.num_seqcial_control, e.dat_erro, e.des_erro ERROS_EXTRATOR_ATIVOS, e.des_ajuda, 
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, b.num_seqcial_bnfciar, b.u##ind_sit_import
  from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate)
and b.u##ind_sit_import = 'ER';

-- listar erros importacao beneficiario por quantidades de ocorrencias
select e.des_erro ERROS_IMPORTACAO_ATIVOS, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate)
group by e.des_erro order by 2 desc;

-- listar erros importacao beneficiário
select e.num_seqcial_control, e.dat_erro, e.des_erro ERROS_IMPORTACAO_ATIVOS, e.des_ajuda, 
       b.num_seqcial_bnfciar NRSEQUENCIAL_USUARIO, b.num_seqcial NRREGISTRO,
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, 
	   b.cd_modalidade, b.nr_proposta, b.num_livre_6 CD_USUARIO,
     b.nom_usuario, b.dt_nascimento, b.dt_inclusao_plano, b.dt_exclusao_plano, b.cd_motivo_cancel, b.dt_admissao,
     b.u##ind_sit_import SIT
  from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate)
    order by b.num_seqcial_bnfciar;
 
--INATIVOS 
 
select decode(u##ind_sit_import,'GE','GE-GERANDO INCLUSAO','GA','GERANDO ALTERACAO','IT','IT-INTEGRADO','ER','ER-ERRO EXTRATOR','PE','PE-ERRO IMPORTACAO','RC','RC-AGUARDANDO IMPORTACAO',u##ind_sit_import) SITUACAO_INATIVOS,
       count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_bnfciar ib
 WHERE ib.u##ind_sit_import not in ('EV') --IGNORAR USUARIO EVENTUAL
   and(ib.dt_exclusao_plano is not null and ib.dt_exclusao_plano <= sysdate)
 group by u##ind_sit_import
 order by u##ind_sit_import;

select e.des_erro ERROS_EXTRATOR_INATIVOS, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'ER'
and (b.dt_exclusao_plano is not null and b.dt_exclusao_plano <= sysdate)
group by e.des_erro order by 2 desc;

select e.num_seqcial_control, e.dat_erro, e.des_erro ERROS_EXTRATOR_INATIVOS, e.des_ajuda, 
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, b.num_seqcial_bnfciar, b.u##ind_sit_import
  from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and (b.dt_exclusao_plano is not null and b.dt_exclusao_plano <= sysdate)
and b.u##ind_sit_import = 'ER';

select e.des_erro ERROS_IMPORTACAO_INATIVOS, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
and (b.dt_exclusao_plano is not null and  b.dt_exclusao_plano <= sysdate)
group by e.des_erro order by 2 desc;

select e.num_seqcial_control, e.dat_erro, e.des_erro ERROS_IMPORTACAO_INATIVOS, e.des_ajuda, 
       b.num_seqcial_bnfciar NRSEQUENCIAL_USUARIO, b.num_seqcial NRREGISTRO,
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, 
     b.nom_usuario, b.dt_nascimento, b.dt_inclusao_plano, b.dt_exclusao_plano, b.cd_motivo_cancel, b.dt_admissao,
     b.u##ind_sit_import SIT
  from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
and (b.dt_exclusao_plano is not null and b.dt_exclusao_plano <= sysdate)
    order by b.num_seqcial_bnfciar;

SPOOL OFF
exit;
