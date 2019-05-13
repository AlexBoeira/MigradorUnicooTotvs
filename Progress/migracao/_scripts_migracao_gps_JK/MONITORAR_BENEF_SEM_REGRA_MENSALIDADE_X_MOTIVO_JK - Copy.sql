SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>BENEFICIARIOS QUE FICARAM SEM REGRA DE MENSALIDADE COM O MOTIVO</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\REGRA_MENSALIDADE\BENEF_SEM_REGRA_MENSALIDADE_X_MOTIVO.html

--=============================================================================================================================================
--esse script lista os beneficiarios que foram migrados para o TOTVS e ficaram sem regra de mensalidade, justificando o motivo
select --count(*)
 ugp.cd_modalidade MODALIDADE_ATIVOS,
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
   and (us.dtexclusao is null or us.dtexclusao > sysdate)
   order by 9;

select --count(*)
 ugp.cd_modalidade MODALIDADE_TODOS,
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
   order by 9;

SPOOL OFF   
exit;
