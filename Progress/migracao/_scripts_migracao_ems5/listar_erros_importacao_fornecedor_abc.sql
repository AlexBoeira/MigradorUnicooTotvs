-- listar erros importacao fornecedor por ordem de quantidade de ocorrencia
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'FN'
		   and tc.cdsituacao <> 'IT')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;
