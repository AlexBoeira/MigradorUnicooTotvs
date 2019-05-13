/*
 * Evandro Levi (27/03/2018): Validação de Preços pós migração.
 *
 * Eh necessario que o faturamento ja tenha sido executado na competencia selecionada para usar os scripts abaixo
 */
--UNICOO valor calculado no Unicoo por BENEFICIARIO, MODULO E FAIXA ETARIA
Select ut.cd_modalidade,
       ut.nr_proposta,
       ut.cd_usuario,
       ut.dt_inclusao_plano,
       m.cdmodulo,
       dfp.vlfaturado,
       dfp.nridade_usuario,
       dfp.nridade_inicio,
       dfp.nridade_fim
  From producao.faturamento@unicoo_homologa                ft,
       producao.detalhe_faturamento_premio@unicoo_homologa dfp,
       gp.usuario                    ut,
       producao.usuario@unicoo_homologa                    u,
       migracao_modulo_padrao              m
 Where lpad(ut.cd_carteira_antiga, 13, '0') = u.nrcontrato || Lpad(u.nrfamilia, 6, '0') || u.tpusuario || u.nrdigitoct
   And dfp.nrperiodo = ft.nrperiodo
   And dfp.nrfatura = ft.nrfatura
   And dfp.nrsequencial_usuario = u.nrsequencial_usuario
   And m.cdcategserv = dfp.cdcategserv
   And dfp.nrperiodo = 201812 /*periodo de faturamento para validar o preço migrado com o último faturamento no UNICOO*/
   And ft.tpfatura = '7' --mensalidade
   And ft.aosituacao_fatura <> 'C'
   And ut.cd_modalidade in (15,20)
--and   dfp.nrregistro = 382265
--And   dfp.nrcontrato in ('0541')
  and dfp.nrcontrato not in ('0225','0559','0321','0587')
 Order By ut.cd_modalidade, ut.nr_proposta, ut.cd_usuario, m.cdmodulo;
--24814

--UNICOO - VALOR CALCULADO POR BENEFICIARIO BENEFICIARIO E MODULO
Select Substr(ft.nrperiodo, 1, 4) aa_referencia,
       Substr(ft.nrperiodo, -2) mm_referencia,
       us.nrcontrato || Lpad(us.nrfamilia, 6, '0') || us.tpusuario || us.nrdigitoct cdusuario,
       mmp.cdmodulo,
       Sum(dfp.vlfaturado) vlfaturado
  From producao.faturamento@unicoo_homologa                ft,
       producao.detalhe_faturamento_premio@unicoo_homologa dfp,
       producao.usuario@unicoo_homologa                    us,
       MIGRACAO_MODULO_PADRAO              mmp,
       gp.usuario ut
 Where dfp.nrperiodo = ft.nrperiodo
   And dfp.nrfatura = ft.nrfatura
   and lpad(ut.cd_carteira_antiga, 13, '0') = us.nrcontrato || Lpad(us.nrfamilia, 6, '0') || us.tpusuario || us.nrdigitoct
   And mmp.cdcategserv = dfp.cdcategserv
   And us.nrsequencial_usuario = dfp.nrsequencial_usuario
   And ft.tpfatura = '7' --mensalidade
   And ft.aosituacao_fatura <> 'C' --menos canceladas
   And ft.nrperiodo = 201812 /*periodo de faturamento para validar o preço migrado com o último faturamento no UNICOO*/
   --and dfp.nrregistro = 382265
   --And   dfp.nrcontrato in ('0541')
  and dfp.nrcontrato not in ('0225','0559','0321','0587')
  and ut.cd_modalidade in (15,20)
   
 group By Substr(ft.nrperiodo, 1, 4),
          Substr(ft.nrperiodo, -2),
          us.nrcontrato || Lpad(us.nrfamilia, 6, '0') || us.tpusuario || us.nrdigitoct,
          mmp.cdmodulo
 Order By Substr(ft.nrperiodo, 1, 4),
          Substr(ft.nrperiodo, -2),
          us.nrcontrato || Lpad(us.nrfamilia, 6, '0') || us.tpusuario ||
          us.nrdigitoct,
          mmp.cdmodulo;
--24641

/* Listar o preço faturado pelo TOTVS - VALORES POR MODULO*/
Select ft.aa_referencia,
       ft.mm_referencia,
       lpad(us.cd_carteira_antiga, 13, '0') COD_USUARIO,
       us.cd_modalidade,
       us.nr_proposta,
       us.cd_usuario,
       us.dt_inclusao_plano,
       ft.cd_modulo,
       Sum(ft.vl_usuario) vlfaturado
  From gp.usuario us, gp.vlbenef ft
 Where ft.cd_modalidade = us.cd_modalidade
   and ft.nr_ter_adesao = us.nr_ter_adesao
   and ft.cd_usuario = us.cd_usuario
and    ft.aa_referencia = '2019'
and    ft.mm_referencia = 1
and ft.cd_modalidade = 20
and ft.nr_ter_adesao = 84653
 Group By ft.aa_referencia,
          ft.mm_referencia,
          lpad(us.cd_carteira_antiga, 13, '0'),
       us.cd_modalidade,
       us.nr_proposta,
       us.cd_usuario,
       us.dt_inclusao_plano,
          ft.cd_modulo;
          
--select * from gp.usuario u where u.cd_modalidade = 20 and u.nr_proposta = 84653 and u.dt_exclusao_plano is null
          