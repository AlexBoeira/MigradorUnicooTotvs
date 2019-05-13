-- Regra específica da Unimed Nova Iguaçu!!!

-- O objetivo deste codigo é excluir da temporária todos os prestadores NÃO COOPERADOS que possuirem data de exclusão 
-- e os banco: '99', '2', '399', '356', '275', '409', '230', '748', '212'. (Estes bancos nos foram listados pela propria Unimed)
set echo on

DELETE FROM TEMP_MIGRACAO_PREST_VINC_ESPEC TESP
 WHERE TESP.NRSEQUENCIAL IN
       (SELECT TP.NRSEQUENCIAL
          FROM TEMP_MIGRACAO_PRESTADOR TP
         WHERE TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
           and TP.Dtexclu_Prestador is not null
           and TP.NRGRUPO_PRESTADOR <> '1'); -- não considerar cooperados nesta exclusão das temporárias

DELETE FROM TEMP_MIGRACAO_ENDERECO_PREST TEND
 WHERE TEND.NRSEQUENCIAL IN
       (SELECT TP.NRSEQUENCIAL
          FROM TEMP_MIGRACAO_PRESTADOR TP
         WHERE TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
           and TP.Dtexclu_Prestador is not null
           and TP.NRGRUPO_PRESTADOR <> '1'); -- não considerar cooperados nesta exclusão das temporárias

DELETE FROM TEMP_MIGRACAO_PRESTADOR TP
 WHERE TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
   and TP.Dtexclu_Prestador is not null
   and TP.NRGRUPO_PRESTADOR <> '1'; -- não considerar cooperados nesta exclusão das temporárias
      
   
-- Manter historico dos cooperados apenas a partir de 2018. Desta forma todos os prestadores cooperados com data de
-- exclusão menor que 01/01/2018 devem ser excluídos para não serem importados posteriormente.

DELETE FROM TEMP_MIGRACAO_PREST_VINC_ESPEC TESP
 WHERE TESP.NRSEQUENCIAL IN
       (SELECT TP.NRSEQUENCIAL
          FROM TEMP_MIGRACAO_PRESTADOR TP
         WHERE TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
           and TP.NRGRUPO_PRESTADOR = '1'); -- CONSIDERAR SOMENTE COOPERADOS
           and to_date(tp.dtexclu_prestador, 'DD/MM/YYYY') < '01/01/2008'
           

DELETE FROM TEMP_MIGRACAO_ENDERECO_PREST TEND
 WHERE TEND.NRSEQUENCIAL IN
       (SELECT TP.NRSEQUENCIAL
          FROM TEMP_MIGRACAO_PRESTADOR TP
         WHERE TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
           and TP.NRGRUPO_PRESTADOR = '1'); -- CONSIDERAR SOMENTE COOPERADOS
           and to_date(tp.dtexclu_prestador, 'DD/MM/YYYY') < '01/01/2008'

DELETE FROM TEMP_MIGRACAO_PRESTADOR TP
 WHERE TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
   and TP.NRGRUPO_PRESTADOR = '1'; -- CONSIDERAR SOMENTE COOPERADOS
   and to_date(tp.dtexclu_prestador, 'DD/MM/YYYY') < '01/01/2008'
 
 
-- Quando Cooperado E possui bancos listados E possui data de exclusão superior à 2018 (ou está ativo) 
-- então alterar banco e agencia para 0

update TEMP_MIGRACAO_PRESTADOR TP set tp.Nrbanco = '0', tp.cdagencia = '0'
 WHERE  TP.NRBANCO IN ('99', '2', '399', '356', '275', '409', '230', '748', '212')
    and TP.NRGRUPO_PRESTADOR = '1' -- SOMENTE COOPERADOS
   and (to_date(tp.dtexclu_prestador, 'DD/MM/YYYY') > '01/01/2018'
       or tp.dtexclu_prestador is null)
   
end;
/