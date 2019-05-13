--select * from temp_depara_agrupado tda where tda.cd_modalidade = 1 and tda.cd_plano = 2 and tda.cd_tipo_plano = 2
--select * from temp_depara_detalhado tdd where tdd.cdcontrato_agr = 'PS70280' --PS70306

--PROCURAR CRITERIOS CONFLITANTES NO TOTVS APOS MIGRACAO - RELACIONAR COM TABELAS ORIGINAIS DO UNICOO, E SOLICITAR APOIO
--A FERJ SOBRE COMO DECIDIR QUAL CRITERIO PRIORIZAR NESSAS INCONSISTENCIAS:
--  1. DUAS REGRAS EQUIVALENTES, COM VALORES DIFERENTES OU NAO, E TPDEPENDENCIA D e * (NO TOTVS TUDO VIRA * E CAUSA CONFLITO);
--  2. DUAS REGRAS EQUIVALENTES, COM VALORES DIFERENTES OU NAO, E TPPLANO DIFERENTES (NO TOTVS ESSA COLUNA NAO EXISTE, CRIANDO CRITERIOS DUPLICADOS);
select c1.cdd_regra,
       rmp.cd_modalidade,
       rmp.nr_proposta,
       rmp.cd_usuario,
       c1.cd_grau_parentesco,
       ip.num_livre_2,
       ip.num_livre_3,
       c1.cd_modulo,
       c1.nr_idade_minima IDADE_MIN1,
       c1.nr_idade_maxima IDADE_MAX1,
       c2.nr_idade_minima IDADE_MIN2,
       c2.nr_idade_maxima IDADE_MAX2,
       c1.vl_mensalidade_base VL1,
       c2.vl_mensalidade_base VL2
  from gp.regra_menslid_criter  c1,
       gp.regra_menslid_criter  c2,
       gp.regra_menslid_propost rmp,
       gp.import_propost        ip
 where c1.cdd_regra = c2.cdd_regra
   and c1.u##cd_padrao_cobertura = c2.u##cd_padrao_cobertura
   and c1.cd_modulo = c2.cd_modulo
   and c1.cd_grau_parentesco = c2.cd_grau_parentesco
   and c1.nr_idade_minima <= c2.nr_idade_minima
   and c1.nr_idade_maxima >= c2.nr_idade_maxima
   and c1.dat_inic <= c2.dat_inic
   and c1.dat_fim >= c2.dat_fim
   and c1.dat_fim = '31/12/9999'
   and c1.dat_inic <> c1.dat_fim
   and c1.num_livre_1 = c2.num_livre_1
   and c1.num_livre_2 = c2.num_livre_2
   and c1.vl_mensalidade_base <> c2.vl_mensalidade_base
   and rmp.cdd_regra = c1.cdd_regra
   and ip.cd_modalidade = rmp.cd_modalidade
   and ip.num_livre_10 = rmp.nr_proposta
   and c1.rowid > c2.rowid
      
   and (exists
        (select 1
           from gp.usuario u
          where u.cd_modalidade = rmp.cd_modalidade
            and u.nr_proposta = rmp.nr_proposta
            and u.cd_usuario = rmp.cd_usuario
            and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate))
       
        or
        (rmp.cd_usuario = 0 and exists
         (select 1
            from gp.usuario u
           where u.cd_modalidade = rmp.cd_modalidade
             and u.nr_proposta = rmp.nr_proposta
             and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
             and not exists
           (select 1
                    from gp.regra_menslid_propost rmp2
                   where rmp2.cd_modalidade = u.cd_modalidade
                     and rmp2.nr_proposta = u.nr_proposta
                     and rmp2.cd_usuario = u.cd_usuario))))

 order by c1.cdd_regra,
          rmp.cd_modalidade,
          rmp.nr_proposta,
          c1.cd_modulo,
          c1.nr_idade_minima,
          c1.nr_idade_maxima

--select * from gp.regra_menslid_criter c where c.cdd_regra = 4154 and c.dat_fim = '31/12/9999'