SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS MIGRACAO PROPOSTA</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\PROPOSTA\STATUS_MIGRACAO_PROPOSTA.html

  --MONITORAR  PROPOSTAS
select decode(ip.u##ind_sit_import,'ER','ER-ERRO EXTRATOR','IT','IT-INTEGRADO','RE','RE-REPROCESSANDO','PE','PE-ERRO IMPORTACAO',ip.u##ind_sit_import) SITUACAO, 
       count(*) QTD, 
       sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from import_propost ip
 group by ip.u##ind_sit_import;

-- listar erros extrator proposta por quantidades de ocorrências - não conseguiu gerar import_propost
select e.des_erro, count(*)
from gp.erro_process_import e, import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.u##ind_sit_import = 'ER'
group by e.des_erro order by 2 desc;

-- listar erros extracao propostas - não conseguiu gerar import_propost
select p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.num_livre_10 proposta, e.*, p.*
from gp.erro_process_import e, gp.import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.u##ind_sit_import in('ER','CORIGEM','CONTRAT','GE');

-- listar erros importação proposta por quantidades de ocorrências
select e.des_erro, count(*)
from gp.erro_process_import e, import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.u##ind_sit_import = 'PE'
group by e.des_erro order by 2 desc;

-- listar erros importacao propostas
select p.num_livre_2 NRREGISTRO, lpad(p.num_livre_3,4,'0') NRCONTRATO,  p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.num_livre_10 nr_proposta, e.num_seqcial_control, e.des_erro DESCRICAO_ERRO, e.des_ajuda, e.dat_erro, 
       p.nr_insc_contratante, p.nr_insc_contrat_origem, p.nr_contrato_antigo, p.cd_forma_pagto, p.cdn_tip_vencto, p.num_dia_vencto, p.cd_convenio, p.cd_tipo_participacao, p.cd_vendedor, p.cd_tab_preco,
       p.cd_tab_preco_proc, p.cd_tab_preco_proc_cob, p.num_mes_ult_faturam, p.aa_ult_fat, p.num_mm_ult_reaj, p.aa_ult_reajuste, p.dat_propost, p.dat_fim_propost, p.cd_registro_plano, p.cd_plano_operadora,
       p.num_seqcial_propost, p.u##ind_sit_import
from gp.erro_process_import e, gp.import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.u##ind_sit_import = 'PE';

SPOOL OFF
exit;
