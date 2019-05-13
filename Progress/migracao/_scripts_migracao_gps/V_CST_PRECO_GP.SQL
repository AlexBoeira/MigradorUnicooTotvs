create or replace view gp.v_cst_preco_gp as
select v.cd_modalidade,
       p.cd_plano,
       p.cd_tipo_plano,
       v.nr_ter_adesao,
       v.aa_referencia || lpad(v.mm_referencia, 2, 0) NRPERIODO,
       u.dt_inclusao_plano,
       u.dt_nascimento,
       v.cd_usuario,
       v.cd_modulo,
       sum(v.vl_usuario) VALOR_TOTVS,
       lpad(u.cd_carteira_antiga,13,'0') COD_USUARIO
       
  from gp.vlbenef v, gp.usuario u, gp.propost p
 where v.cd_modalidade = u.cd_modalidade
   and v.nr_ter_adesao = u.nr_ter_adesao
   and v.cd_usuario = u.cd_usuario
   and v.aa_referencia = '2019'
   and v.mm_referencia = 01
   --and v.cd_modulo = 999
   and p.cd_modalidade = u.cd_modalidade
   and p.nr_proposta = u.nr_proposta
group by
       v.cd_modalidade,
       p.cd_plano,
       p.cd_tipo_plano,
       v.nr_ter_adesao,
       v.aa_referencia || lpad(v.mm_referencia, 2, 0) ,
       u.dt_inclusao_plano,
       u.dt_nascimento,
       v.cd_usuario,
       v.cd_modulo,
       lpad(u.cd_carteira_antiga,13,'0');
        
