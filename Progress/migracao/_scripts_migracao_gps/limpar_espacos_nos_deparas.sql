-- eliminar espaços à direita nos campos CHAR
update temp_depara_agrupado tda
   set tda.cdproduto            = trim(tda.cdproduto),
       tda.cdcontrato           = trim(tda.cdcontrato),
       tda.cd_padrao_cobertura  = trim(tda.cd_padrao_cobertura),
       tda.cdcontrato_cobertura = trim(tda.cdcontrato_cobertura);

update temp_depara_detalhado tdd
   set tdd.cdproduto      = trim(tdd.cdproduto),
       tdd.cdcontrato     = trim(tdd.cdcontrato),
       tdd.tpplano        = trim(tdd.tpplano),
       tdd.cdcontrato_agr = trim(tdd.cdcontrato_agr);
    
--select * from temp_depara_detalhado tdd where tdd.cdcontrato_agr like '% %';
--select * from temp_depara_agrupado tda where tda.cdcontrato_cobertura like '% %';

       