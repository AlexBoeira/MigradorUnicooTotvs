--relacao ano/mes ultimo faturamento por modalidade
select t.cd_modalidade, t.aa_ult_fat, t.mm_ult_fat, count(*)
  from gp.ter_ade t
 where t.dt_cancelamento is null
    or t.dt_cancelamento > sysdate
   and exists
 (select 1
          from gp.usuario u
         where u.cd_modalidade = t.cd_modalidade
           and u.nr_ter_adesao = t.nr_ter_adesao
           and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
           and u.log_17 = 0) --desconsiderar eventual
 group by t.cd_modalidade, t.aa_ult_fat, t.mm_ult_fat
 order by 4 desc;

--listagem detalhada
select t.cd_modalidade,
       t.nr_ter_adesao,
       t.aa_ult_fat,
       t.mm_ult_fat,
       t.dt_inicio,
       t.dt_cancelamento,
       (select count(*)
          from gp.usuario u
         where u.cd_modalidade = t.cd_modalidade
           and u.nr_ter_adesao = t.nr_ter_adesao
           and u.log_17 = 0
           and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)) QT_BENEF_ATIVOS
  from gp.ter_ade t
 where t.dt_cancelamento is null
    or t.dt_cancelamento > sysdate
   and exists
 (select 1
          from gp.usuario u
         where u.cd_modalidade = t.cd_modalidade
           and u.nr_ter_adesao = t.nr_ter_adesao
           and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
           and u.log_17 = 0) --desconsiderar eventual
