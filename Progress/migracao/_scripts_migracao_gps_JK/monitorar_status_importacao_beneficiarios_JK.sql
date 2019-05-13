SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS MIGRACAO BENEFICIARIOS</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\BENEFICIARIO\STATUS_MIGRACAO_BENEFICIARIO.html

-- monitorar status importacao beneficiarios

select decode(u##ind_sit_import,'GE','GE-GERANDO INCLUSAO','GA','GERANDO ALTERACAO','IT','IT-INTEGRADO','ER','ER-ERRO EXTRATOR','PE','PE-ERRO IMPORTACAO','RC','RC-AGUARDANDO IMPORTACAO',u##ind_sit_import) SITUACAO,
       count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_bnfciar ib
 WHERE ib.u##ind_sit_import not in ('EV') --IGNORAR USUARIO EVENTUAL
 group by u##ind_sit_import
 order by u##ind_sit_import;

select decode(log_respons, 1, 'TITULARES', 'DEPENDENTES') DEPENDENCIA,
       decode(u##ind_sit_import,'GE','GE-GERANDO INCLUSAO','GA','GERANDO ALTERACAO','IT','IT-INTEGRADO','ER','ER-ERRO EXTRATOR','PE','PE-ERRO IMPORTACAO','RC','RC-AGUARDANDO IMPORTACAO',u##ind_sit_import) SITUACAO,
       count(*) QTD,
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_bnfciar ib
 WHERE ib.u##ind_sit_import not in ('EV') --IGNORAR USUARIO EVENTUAL
 group by u##ind_sit_import, log_respons
 order by log_respons DESC, u##ind_sit_import;

-- listar erros extracao beneficiario por quantidades de ocorrencias
select e.des_erro, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'ER'
group by e.des_erro order by 2 desc;

-- listar erros extrator beneficiário
select e.num_seqcial_control, e.dat_erro, e.des_erro, e.des_ajuda, 
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, b.num_seqcial_control, b.u##ind_sit_import
  from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'ER';

-- listar erros importacao beneficiario por quantidades de ocorrencias
select e.des_erro, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
group by e.des_erro order by 2 desc;

-- listar erros importacao beneficiário
select e.num_seqcial_control, e.dat_erro, e.des_erro DESCRICAO_ERRO, e.des_ajuda, 
       b.num_seqcial_bnfciar NRSEQUENCIAL_USUARIO, b.num_seqcial NRREGISTRO,
       to_char(b.cd_carteira_antiga) CARTEIRA, to_char(b.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL, 
     b.nom_usuario, b.dt_nascimento, b.dt_admissao,
     b.u##ind_sit_import SIT
  from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
    order by b.num_seqcial_bnfciar;

--LISTAR BENEFICIARIOS DO UNICOO QUE NAO FORAM MIGRADOS PARA O TOTVS
select count(*)
  from producao.usuario@unicoo_homologa us
 where not exists (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000; -- DESCONSIDERAR USUARIO EVENTUAL
--and (us.dtexclusao is null or us.dtexclusao > sysdate) -- HABILITAR ESSA LINHA PARA SOMENTE ATIVOS

--LISTAR BENEFICIARIOS DO UNICOO QUE NAO FORAM MIGRADOS PARA O TOTVS
select us.nrsequencial_usuario
  from producao.usuario@unicoo_homologa us
 where not exists (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000; -- DESCONSIDERAR USUARIO EVENTUAL
--and (us.dtexclusao is null or us.dtexclusao > sysdate) -- HABILITAR ESSA LINHA PARA SOMENTE ATIVOS

SPOOL OFF
exit;
