SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>BENEFICIARIOS QUE FICARAM INDEVIDAMENTE SEM REGRA DE MENSALIDADE</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\REGRA_MENSALIDADE\ERRO_BENEF_FICOU_SEM_REGRA_MENSALIDADE.html

--=============================================================================================================================================
--esse script lista os beneficiarios que foram migrados para o TOTVS e ficaram sem regra de mensalidade mesmo quando não existem os problemas
--na base do UNICOO explicitados nos scripts acima, ou seja, deve ser analisado pois deveriam ter ganhado regra (seja do beneficiário ou contrato)
select count(*) ATIVOS, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
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
   and (us.dtexclusao is null or us.dtexclusao > sysdate)
   --and us.nrtabela_padrao   is not null
   And exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);

select 
 ugp.cd_modalidade MODALIDADE_ATIVOS,
 ugp.nr_ter_adesao,
 ugp.cd_usuario,
 ip.num_livre_2 NRREGISTRO,
 lpad(ip.num_livre_3, 4, '0') NRCONTRATO,
 ip.num_livre_4 FAMILIA,
 ip.cod_livre_3 CDCONTRATO,
 ib.num_seqcial_bnfciar,
 to_char(ib.cd_carteira_antiga) CARTEIRA,
 ib.log_respons,
 to_char(ib.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL
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
   and (us.dtexclusao is null or us.dtexclusao > sysdate)
   --and us.nrtabela_padrao   is not null
   And exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);

select count(*) TODOS, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
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

select 
 ugp.cd_modalidade MODALIDADE_TODOS,
 ugp.nr_ter_adesao,
 ugp.cd_usuario,
 ip.num_livre_2 NRREGISTRO,
 lpad(ip.num_livre_3, 4, '0') NRCONTRATO,
 ip.num_livre_4 FAMILIA,
 ip.cod_livre_3 CDCONTRATO,
 ib.num_seqcial_bnfciar,
 to_char(ib.cd_carteira_antiga) CARTEIRA,
 ib.log_respons,
 to_char(ib.cdcarteiraorigemresponsavel) CARTEIRA_RESPONSAVEL
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

SPOOL OFF   
exit;
