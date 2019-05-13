SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS EXTRATOR TITULOS A PAGAR</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"

SPOOL &1\TITULO_APB\STATUS_EXTRATOR_TITULOS_A_PAGAR.html

-- MONITORAR STATUS
select decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
	          'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
			  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QTD, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from ti_controle_integracao           where tpintegracao in('TP')
 group by cdsituacao
 order by 1;

-- listar erros de importacao de titulos por ordem de quantidades de ocorrencia
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*) QT
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'TP'
           and tc.cdsituacao   = 'ER')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;
 
select fa.*, tp.*
from ti_falha_de_processo fa, ti_controle_integracao tp
where tp.nrsequencial = fa.nrseq_controle_integracao
and tp.tpintegracao = 'TP'
and tp.cdsituacao =  'ER';
 
SPOOL OFF   
exit;
