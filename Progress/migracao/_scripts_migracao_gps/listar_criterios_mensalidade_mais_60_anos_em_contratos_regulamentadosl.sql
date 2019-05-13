select distinct ip.num_livre_2 NRREGISTRO,
                ip.num_livre_3 NRCONTRATO,
                rmp.cd_modalidade,
                rmp.nr_proposta,
                decode(rmp.cd_usuario, 0, 'TODOS', rmp.cd_usuario) CD_USUARIO,
                rmp.cdd_regra,
                rmc.nr_idade_minima,
                rmc.nr_idade_maxima,
                (select count(*)
                   from gp.usuario u
                  where u.cd_modalidade = rmp.cd_modalidade
                    and u.nr_proposta = rmp.nr_proposta
                    and (u.cd_usuario = rmp.cd_usuario or rmp.cd_usuario = 0)
                    and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)) QT_ATIVOS,
                (select count(*)
                   from gp.usuario u
                  where u.cd_modalidade = rmp.cd_modalidade
                    and u.nr_proposta = rmp.nr_proposta
                    and (u.cd_usuario = rmp.cd_usuario or rmp.cd_usuario = 0)
                    and u.dt_nascimento <= '01/01/1959'
                    and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)) QT_ATIVOS_MAIORES_60
                    
  from gp.regra_menslid_propost rmp,
       gp.regra_menslid_criter  rmc,
       gp.import_propost        ip,
       gp.ter_ade t
 where rmp.cd_modalidade in (10, 20) --regulamentadas
   and rmc.cdd_regra = rmp.cdd_regra
   and rmc.nr_idade_minima >= 60
   and ip.cd_modalidade = rmp.cd_modalidade
   and ip.num_livre_10 = rmp.nr_proposta
   and t.cd_modalidade = ip.cd_modalidade
   and t.nr_ter_adesao = ip.num_livre_10
   and (t.dt_cancelamento is null or t.dt_cancelamento > sysdate)
   order by 9 desc;
   