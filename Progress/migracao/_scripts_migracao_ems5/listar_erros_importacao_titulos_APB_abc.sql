-- listar erros de importacao de titulos APB por ordem de quantidades de ocorrencia
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'TP'
           and tc.cdsituacao = 'PE')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;
