SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>BENEFICIARIOS UNICOO NAO MIGRADOS</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\BENEFICIARIO\BENEFICIARIOS_PARAMETRIZADO_PARA_NAO_MIGRAR.html

select tp.cdcontrato PLANOS_NAO_MIGRAR from temp_plano_nao_migrar tp;

select tc.nrcontrato CONTRATOS_NAO_MIGRAR from temp_contrato_nao_migrar tc;

--ATIVOS
select count(*) QT_BENEF_ATIVOS_NAO_MIGRAR
  from producao.usuario@unicoo_homologa us
 where not exists
 (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000 -- DESCONSIDERAR USUARIO EVENTUAL
   and (exists (select 1
                  from temp_plano_nao_migrar tp
                 where tp.cdcontrato = us.cdcontrato) or exists
        (select 1
           from temp_contrato_nao_migrar tc
          where tc.nrcontrato = us.nrcontrato))
   and (us.dtexclusao is null or us.dtexclusao > sysdate);

--LISTAR BENEFICIARIOS DO UNICOO QUE NAO FORAM MIGRADOS PARA O TOTVS
select us.nrsequencial_usuario,
       us.nrregistro,
       us.nrcontrato,
       us.nrfamilia,
       us.nrregistro_usuario,
       us.tpusuario,
       us.dtinicio,
       us.dtexclusao
  from producao.usuario@unicoo_homologa us
 where not exists
 (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000 -- DESCONSIDERAR USUARIO EVENTUAL
   and (exists (select 1
                  from temp_plano_nao_migrar tp
                 where tp.cdcontrato = us.cdcontrato) or exists
        (select 1
           from temp_contrato_nao_migrar tc
          where tc.nrcontrato = us.nrcontrato))
   and (us.dtexclusao is null or us.dtexclusao > sysdate);

--INATIVOS
select count(*) QT_BENEF_INATIVOS_NAO_MIGRADOS
  from producao.usuario@unicoo_homologa us
 where not exists
 (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000 -- DESCONSIDERAR USUARIO EVENTUAL
   and (exists (select 1
                  from temp_plano_nao_migrar tp
                 where tp.cdcontrato = us.cdcontrato) or exists
        (select 1
           from temp_contrato_nao_migrar tc
          where tc.nrcontrato = us.nrcontrato))
   and us.dtexclusao < sysdate;

--LISTAR BENEFICIARIOS DO UNICOO QUE NAO FORAM MIGRADOS PARA O TOTVS
select us.nrsequencial_usuario,
       us.nrregistro,
       us.nrcontrato,
       us.nrfamilia,
       us.nrregistro_usuario,
       us.tpusuario,
       us.dtinicio,
       us.dtexclusao
  from producao.usuario@unicoo_homologa us
 where not exists
 (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000 -- DESCONSIDERAR USUARIO EVENTUAL
   and (exists (select 1
                  from temp_plano_nao_migrar tp
                 where tp.cdcontrato = us.cdcontrato) or exists
        (select 1
           from temp_contrato_nao_migrar tc
          where tc.nrcontrato = us.nrcontrato))
   and us.dtexclusao < sysdate;

SPOOL OFF
exit;
