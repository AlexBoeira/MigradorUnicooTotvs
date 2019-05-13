SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS EXTRATOR FORNECEDORES</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"

SPOOL &1\FORNECEDOR\STATUS_EXTRATOR_FORNECEDORES.html

-- MONITORAR STATUS FORNECEDORES
select tpintegracao, cdsituacao, count(*) QTD, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from ti_controle_integracao           
 where tpintegracao in('FN')
 group by cdsituacao, tpintegracao
 order by 1, 2;
 
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'FN'
           and tc.cdsituacao = 'ER')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;

-- listar erros do extrator de Fornecedores - esses casos não foram criados em TI_FORNECEDOR
select fa.*, fn.*
from ti_falha_de_processo fa, ti_controle_integracao fn
where fn.nrsequencial = fa.nrseq_controle_integracao
and fn.tpintegracao = 'FN'
and fn.cdsituacao =  'ER';

SPOOL OFF   
exit;
