--ATENCAO: esse script lista beneficiarios que existem no unicoo sem vinculo com regra de mensalidade, logo, ficarão sem regra de mensalidade no TOTVS
Select count(*)
  From usuario us
 Where (us.nrtabela_contrato Is Null And us.nrtabela_padrao Is Null)
   And us.nrfamilia > 0
--And   (us.dtexclusao is Null Or us.dtexclusao > Sysdate)
 Order By us.dtexclusao Desc

--ATENCAO: esse script lista usuários com preço direto do Contrato Padrão, sem relacionamento com regra do seu contrato, que são desconsiderados pelo migrador
Select nrSequencial_usuario,
       ps.nopessoa,
       nrregistro_usuario,
       nrcontrato,
       nrfamilia,
       tpusuario,
       dtinicio,
       dtexclusao,
       nrtabela_padrao
  From USUARIO Us, Pessoa Ps
 Where NRTABELA_PADRAO Is Not Null
   And NRTABELA_CONTRATO Is Null
--   And (DTEXCLUSAO Is Null Or DTEXCLUSAO > Sysdate)
   And Ps.Nrregistro = us.nrregistro_usuario;

--ATENCAO: esse script lista usuários cuja tabela de preço não corresponde com a tabela do seu próprio contrato, e por isso são desconsiderados pelo migrador
Select us.nrsequencial_usuario,
       nrtabela_contrato,
       nrregistro,
       nrcontrato,
       cdcontrato,
       us.*
  From usuario us
 Where nrtabela_contrato Is Not Null
   And nrfamilia > 0
--      And   (dtexclusao is Null Or dtexclusao > Sysdate)
   And Not Exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);
           
--=============================================================================================================================================
--esse script lista os beneficiarios que foram migrados para o TOTVS e ficaram sem regra de mensalidade mesmo quando não existem os problemas
--na base do UNICOO explicitados nos scripts acima, ou seja, deve ser analisado pois deveriam ter ganhado regra (seja do beneficiário ou contrato)
select --count(*)
 ugp.cd_modalidade,
 ugp.nr_ter_adesao,
 ugp.cd_usuario,
 ip.num_livre_2 NRREGISTRO,
 lpad(ip.num_livre_3, 4, '0') NRCONTRATO,
 ip.num_livre_4 FAMILIA,
 ip.cod_livre_3 CDCONTRATO,
 ib.num_seqcial_bnfciar,
 ib.cd_carteira_antiga,
 ib.log_respons,
 ib.cdcarteiraorigemresponsavel
  from gp.usuario        ugp,
       gp.import_bnfciar ib,
       gp.import_propost ip,
       usuario           us
 where not exists (select 1
          from regra_menslid_propost rmp
         where rmp.cd_modalidade = ugp.cd_modalidade
           and rmp.nr_proposta = ugp.nr_proposta)
   and ib.cd_modalidade = ugp.cd_modalidade
   and ib.nr_proposta   = ugp.nr_proposta
   and ib.num_livre_6   = ugp.cd_usuario
   and ip.nr_contrato_antigo   = ib.nr_contrato_antigo
   and us.nrsequencial_usuario = ib.num_seqcial_bnfciar
   --BENEFICIARIO POSSUI RELACIONAMENTO COM REGRA VALIDA
   and us.nrtabela_contrato Is not Null 
   --and us.nrtabela_padrao   is not null
   And exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);
   
--=============================================================================================================================================
--esse script lista os beneficiarios que foram migrados para o TOTVS e ficaram sem regra de mensalidade, justificando o motivo
select --count(*)
 ugp.cd_modalidade,
 ugp.nr_ter_adesao,
 ugp.cd_usuario,
 ip.num_livre_2 NRREGISTRO,
 lpad(ip.num_livre_3, 4, '0') NRCONTRATO,
 ip.num_livre_4 FAMILIA,
 ip.cod_livre_3 CDCONTRATO,
 ib.num_seqcial_bnfciar,
 ib.cd_carteira_antiga,
 ib.log_respons,
 ib.cdcarteiraorigemresponsavel,

 case
    when us.nrtabela_contrato is null then
         'USUARIO.NRTABELA_CONTRATO ESTA NULO'
    when prc.nrtabela_contrato is null then
         'USUARIO.NRTABELA_CONTRATO ICOMPATIVEL COM SEU CONTRATO_DA_PESSOA'
    else
         'BENEFICIARIO DEVERIA TER REGRA DE MENSALIDADE. VERIFIQUE'
 end MOTIVO
  from gp.usuario        ugp,
       gp.import_bnfciar ib,
       gp.import_propost ip,
       usuario           us,
       (select prc.nrtabela_contrato,
               prc.nrregistro,
               prc.nrcontrato
          from preco_referencia_contrato prc) prc
 where not exists (select 1
          from regra_menslid_propost rmp
         where rmp.cd_modalidade = ugp.cd_modalidade
           and rmp.nr_proposta = ugp.nr_proposta)
   and ib.cd_modalidade = ugp.cd_modalidade
   and ib.nr_proposta   = ugp.nr_proposta
   and ib.num_livre_6   = ugp.cd_usuario
   and ip.nr_contrato_antigo   = ib.nr_contrato_antigo
   and us.nrsequencial_usuario = ib.num_seqcial_bnfciar
   and prc.nrtabela_contrato(+) = us.nrtabela_contrato
   And prc.nrregistro(+) = us.nrregistro
   And prc.nrcontrato(+) = us.nrcontrato
