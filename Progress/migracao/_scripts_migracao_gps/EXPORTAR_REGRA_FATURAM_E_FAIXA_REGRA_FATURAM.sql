--REGRA_FATURAM e FAIXA_REGRA_FATURAM
select rf.cdn_regra, 
       rf.nom_regra, 
       rf.dat_inic, 
       rf.dat_fim, 
       rf.cod_tab_medic_pagto,
       rf.cod_livre_1 MOEDA_OPERAC,
       rf.cod_livre_2 MOEDA_FILME,
       rf.val_livre_2 PERC_URGENCIA,
       rf.val_livre_3 VAL_COTACAO,
       rf.val_livre_4 VAL_COTACAO_OPERACIONAL,
       rf.val_livre_5 VAL_COTACAO_FILME,
       rf.log_livre_1 DESCONSIDERA_CONTA_HOSP,
       rf.cdn_tip_regra TIPO_REGRA,
       rf.ind_tip_val,
       rf.cdn_agrup_regra_faturam,
       frf.val_faixa_inic,
       frf.val_faixa_fim, 
       frf.val_ele,
       frf.val_urgen,
       frf.val_limite
 from gp.regra_faturam rf, gp.faixa_regra_faturam frf
where rf.cdn_regra >= 9001000 and rf.cdn_regra <= 9999999
  and frf.cdn_regra(+) = rf.cdn_regra
  order by cdn_regra;

--PRESTADORES DA REGRA
select rf.cdn_regra, 
       rf.nom_regra, 
       rpf.cdn_local_atendim,
       rpf.cdn_clinic, 
       rpf.cdn_unid, 
       rpf.cdn_grp_prestdor, 
       rpf.cdn_prestdor, 
       rpf.cdn_vinculo, 
       rpf.cdn_especialid, 
       rpf.dat_inic, 
       rpf.dat_fim, 
       rpf.num_livre_4 TIPO_ATENDIMENTO, 
       rpf.num_livre_3 TIPO_ACOMODACAO, 
       rpf.num_livre_2 TRANSACAO
from gp.regra_faturam rf, gp.regra_prestdor_faturam rpf 
where rpf.cdn_regra >= 9001000 and rpf.cdn_regra <= 9999999
  and rf.cdn_regra = rpf.cdn_regra
  order by cdn_regra;

--SERVICOS DA REGRA
select rf.cdn_regra, rf.nom_regra, 
       rsf.cdn_modulo,
       rsf.cod_tip_serv,
       rsf.cdn_princp_ativ,
       rsf.cdn_grupo,
       rsf.cdn_servico,
       rsf.num_livre_1 GRUPO_PROC_AMB,
       rsf.num_livre_2 CD_ESP_AMB,
       rsf.log_livre_1 TODOS_GRUPO_PROC_AMB,
       rsf.dat_inic,
       rsf.dat_fim
from  gp.regra_faturam rf, gp.regra_serv_faturam rsf 
where rsf.cdn_regra >= 9001000 and rsf.cdn_regra <= 9999999
  and rf.cdn_regra = rsf.cdn_regra
    order by cdn_regra;


--FAMILIAS DA REGRA
select rf.cdn_regra, rf.nom_regra,
       rff.cdn_familia_inicial,
       rff.cdn_familia_final,
       rff.dat_inic,
       rff.dat_fim
from gp.regra_faturam rf, gp.regra_familia_faturam rff 
where rff.cdn_regra >= 9001000 and rff.cdn_regra <= 9999999
  and rf.cdn_regra = rff.cdn_regra;

--#CDN_AGRUP_REGRA_FATURAM
select * from gp.agrup_regra_faturam

--#ID_REGRA_BENEF, CDN_REGRA
select * from gp.regra_bnfciar_faturam rbf

select * from gp.assoc_propost_agrup
