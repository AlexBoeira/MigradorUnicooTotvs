-- listar erros de importacao de titulos ACR por ordem de quantidades de ocorrencia
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'TR'
           and tc.cdsituacao   = 'ER')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;
