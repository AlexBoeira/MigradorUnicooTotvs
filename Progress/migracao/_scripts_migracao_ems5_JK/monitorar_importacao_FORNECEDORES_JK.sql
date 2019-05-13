SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS IMPORTACAO FORNECEDORES</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"

SPOOL &1\FORNECEDOR\STATUS_IMPORTACAO_FORNECEDORES.html

-- MONITORAR STATUS FORNECEDORES
select tpintegracao, cdsituacao, count(*) QTD, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from ti_controle_integracao           
 where tpintegracao in('FN')
 group by cdsituacao, tpintegracao
 order by 1, 2;

-- listar erros importacao fornecedor por ordem de quantidade de ocorrencia
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'FN'
		   and tc.cdsituacao = 'PE')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;

-- listar erros importacao fornecedor
select fo.cod_fornecedor, fo.cdsituacao, fa.*, fo.*
  from ti_falha_de_processo fa, ti_fornecedor fo
 where fo.nrseq_controle_integracao = fa.nrseq_controle_integracao
   and fo.cdsituacao = 'PE';

SPOOL OFF   
exit;
