-- validar TEMP_DEPARA_DETALHADO   
select *
  from temp_depara_detalhado tdd
 where not exists (select 1
          from tipo_plano_contrato tpc
         where tpc.cdcontrato = tdd.cdcontrato_agr
           and tpc.tpplano = tdd.tpplano);
