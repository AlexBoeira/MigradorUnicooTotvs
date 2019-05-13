/**
 * Esse script depende da previa criacao de duas views no owner GP, usando os scripts: 
 * V_CST_PRECO_GP.SQL
 * V_CST_PRECO_UNICOO.SQL
 */

/**
 * Criterios importantes antes de validar valores:
 * 1. garantir que a quantidade de vidas ativas nos dois lados (Unicoo e TOTVS) está igual (desconsiderar benef. eventual);
 * 2. garantir que ambos estejam faturados no mesmo mês;
 * 3. o mês de faturamento para conferência deve ser ajustado dentro de cada view, recompilando-a;
 */

--1.1 checar se a quantidade de vidas ativas no TOTVS esta igual a do UNICOO
  --ADESAO
  select count(*) from gp.usuario u, propost p 
         where p.cd_modalidade = 20 
         and p.cd_plano in (16,17,18,19,20)
         and u.cd_modalidade = p.cd_modalidade
         and u.nr_proposta = p.nr_proposta
         and u.log_17 = 0 --excluir eventual
         and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
         --252 ativos; 1476 total
  --PF
  select count(*) from gp.usuario u, propost p 
         where p.cd_modalidade in (1,10)
         and u.cd_modalidade = p.cd_modalidade
         and u.nr_proposta = p.nr_proposta
         and u.log_17 = 0 --excluir eventual
         and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
         --ativos 53.359; total 260.792
       
--1.2 checar quantidade de ativos no UNICOO. Primeiramente levantar CDPRODUTO nos DEPARAs, em seguida contar beneficiarios desse produto
  --ADESAO
  select distinct tdd.cdcontrato from temp_depara_agrupado tda, temp_depara_detalhado tdd 
   where tdd.cdcontrato_agr = tda.cdcontrato and tda.cd_modalidade = 20 and tda.cd_plano in (16,17,18,19,20)

  --PF - para PF separei pelo Tipo de Pessoa do NRREGISTRO, pois são mais de 1000 CDCONTRATO

--1.3 com a lista gerada pelo select acima, filtrar beneficiarios ativos no UNICOO
  --ADESAO
  select count(*) from usuario uu where uu.cdcontrato in ('PS600386','PS600189','UADES87','PS600289','PS600586','PS600587','NCUADE87','NCUADE86','PS600486','UFADES89','UFADES86','PS600086','PS600188','NCUADE89','UFADES87','UADES86','PS600087','PS600089','PS600287','PS600387','UVPRAD86','NCUFAD86','PS600190','PS600389','PS600286','NCUFAD87','PS600186','PS600487','UADES89','PS600489','PS600187','PS600191')
                                    and (uu.dtexclusao is null or uu.dtexclusao > sysdate) 
                                    and uu.nrregistro_usuario <> 2000
  --252 ativos; 1488 total
  
  --PF - para PF separei pelo Tipo de Pessoa do NRREGISTRO, pois são mais de 1000 CDCONTRATO
  select count(*) from usuario uu where exists(select 1 from pessoa pu where pu.nrregistro = uu.nrregistro and pu.tppessoa = 'F')
                                    and uu.nrregistro_usuario <> 2000
                                    and (uu.dtexclusao is null or uu.dtexclusao > sysdate) 
  -- ativos 53.359; total 261.008
  
  
--2.1 validar ultimo faturamento dos beneficiarios ativos no TOTVS
  --PF
  select u.aa_ult_fat, u.mm_ult_fat, count(*) from gp.usuario u, propost p 
         where p.cd_modalidade in (1,10)
         and u.cd_modalidade = p.cd_modalidade
         and u.nr_proposta = p.nr_proposta
         and u.log_17 = 0 --excluir eventual
         and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
         group by u.aa_ult_fat, u.mm_ult_fat
         --2019/01: 53.353; outros: 6

--2.2 validar ultimo faturamento dos beneficiarios ativos no UNICOO - contar quantas mensalidades faturadas para o ano/mes desejado
  --PF
  select count(*) from unicoogps.detalhe_faturamento_premio p, unicoogps.faturamento f, unicoogps.USUARIO U
   where p.nrfatura = f.nrfatura
     and f.tpfatura = '7'
     and f.aosituacao_fatura = '0' --valida
     and p.nrperiodo = '201901'
     and p.cdcategserv = ' ' -- mensalidade
     AND U.NRSEQUENCIAL_USUARIO=P.NRSEQUENCIAL_USUARIO
     --74.781
  
--3. comparar beneficiarios que faturaram nos 2 sistemas, listando os resultados diferentes
  --ADESAO
  SELECT gp.cd_modalidade, gp.cd_plano, gp.cd_tipo_plano, gp.nr_ter_adesao, gp.NRPERIODO, gp.dt_inclusao_plano, 
         gp.dt_nascimento, gp.cd_usuario, m.cdmodulo, gp.COD_USUARIO, gp.VALOR_TOTVS, un.VALOR_UNICOO
    FROM gp.V_CST_PRECO_GP      GP,
         gp.V_CST_PRECO_UNICOO  UN,
         migracao_modulo_padrao m
   WHERE
         GP.COD_USUARIO = UN.CDUSUARIO
     and m.cdcategserv = un.cdcategserv(+)
     and m.cdmodulo    = gp.cd_modulo(+) 
     --and gp.VALOR_TOTVS <> un.VALOR_UNICOO
     --and gp.cd_modalidade = 20 and gp.nr_ter_adesao in (28157,28493,48100,54028,54043)
     --and gp.cd_modalidade = 20 and gp.nr_ter_adesao = 1059
     --and gp.cd_modalidade = 20 and gp.nr_ter_adesao = 15
     --and gp.cd_modalidade = 15
     --ADESAO
     and gp.cd_modalidade in (20) and gp.cd_plano in (16,17,18,19,20)

  --PF
  SELECT gp.cd_modalidade, gp.cd_plano, gp.cd_tipo_plano, gp.nr_ter_adesao, gp.NRPERIODO, gp.dt_inclusao_plano, 
         gp.dt_nascimento, gp.cd_usuario, m.cdmodulo, gp.COD_USUARIO, gp.VALOR_TOTVS, un.VALOR_UNICOO
    FROM gp.V_CST_PRECO_GP      GP,
         gp.V_CST_PRECO_UNICOO  UN,
         migracao_modulo_padrao m
   WHERE
         GP.COD_USUARIO = UN.CDUSUARIO
     and m.cdcategserv = un.cdcategserv(+)
     and m.cdmodulo    = gp.cd_modulo(+) 
     and gp.VALOR_TOTVS <> un.VALOR_UNICOO
     and gp.cd_modalidade in (1,10)
  --diferencas: 2.997; total: 61.472 (mensalidade + modulos agregados)

  --PJ (ABEU)
  SELECT gp.cd_modalidade, gp.cd_plano, gp.cd_tipo_plano, gp.nr_ter_adesao, gp.NRPERIODO, gp.dt_inclusao_plano, 
         gp.dt_nascimento, gp.cd_usuario, m.cdmodulo, gp.COD_USUARIO, gp.VALOR_TOTVS, un.VALOR_UNICOO
    FROM gp.V_CST_PRECO_GP      GP,
         gp.V_CST_PRECO_UNICOO  UN,
         migracao_modulo_padrao m
   WHERE
         GP.COD_USUARIO = UN.CDUSUARIO
     and m.cdcategserv = un.cdcategserv(+)
     and m.cdmodulo    = gp.cd_modulo(+) 
     and gp.VALOR_TOTVS <> un.VALOR_UNICOO
     and gp.cd_modalidade = 20
     and gp.nr_ter_adesao = 15
  --diferencas: ; total:  (mensalidade + modulos agregados)

  --PJ (outros)
  SELECT gp.cd_modalidade, gp.cd_plano, gp.cd_tipo_plano, gp.nr_ter_adesao, gp.NRPERIODO, gp.dt_inclusao_plano, 
         gp.dt_nascimento, gp.cd_usuario, m.cdmodulo, gp.COD_USUARIO, gp.VALOR_TOTVS, un.VALOR_UNICOO
    FROM gp.V_CST_PRECO_GP      GP,
         gp.V_CST_PRECO_UNICOO  UN,
         migracao_modulo_padrao m
   WHERE
         GP.COD_USUARIO = UN.CDUSUARIO
     and m.cdcategserv = un.cdcategserv(+)
     and m.cdmodulo    = gp.cd_modulo(+) 
     --and gp.VALOR_TOTVS <> un.VALOR_UNICOO
     and gp.cd_modalidade = 20
     and gp.nr_ter_adesao = 7494
  --diferencas: ; total:  (mensalidade + modulos agregados)
  
  
  
--listar beneficiarios que faturou apenas no UNICOO
SELECT *
  FROM gp.V_CST_PRECO_UNICOO UN
 WHERE /*gp.cd_modalidade in (1, 10)
   and*/ not exists (select 1
          from gp.V_CST_PRECO_GP GP
         where gp.cod_usuario = un.cdusuario)
   and exists(select 1 from gp.import_propost ip where ip.num_livre_2 = un.nrregistro
                                                   and ip.num_livre_3 = un.NRCONTRATO
                                                   and ip.cd_modalidade = 20
                                                   and ip.cd_plano in (16,17,18,19,20));
--5736   
--listar beneficiarios que faturou apenas no TOTVS
SELECT *
  FROM gp.V_CST_PRECO_GP GP
 WHERE gp.cd_modalidade in (1, 10)
   and gp.cd_plano in (16,17,18,19,20)
   and not exists (select 1
          from gp.V_CST_PRECO_UNICOO UN
         where gp.cod_usuario = un.cdusuario);
--31369

