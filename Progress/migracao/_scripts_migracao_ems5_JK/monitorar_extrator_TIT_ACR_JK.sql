SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS EXTRATOR TITULOS A RECEBER</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"

SPOOL &1\TITULO_ACR\STATUS_EXTRATOR_TITULOS_A_RECEBER.html

-- MONITORAR STATUS OK
select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') OK, 
       decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
	   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
	          'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
			  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QTD, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from ti_controle_integracao           
 where tpintegracao in('TR','BR')
   and cdsituacao not in ('PE','ER')
 group by cdsituacao, cdacao, tpintegracao
 order by 1, 2;

-- MONITORAR STATUS ERRO
select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') ERRO,
       decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
	   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
	          'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
			  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT
  from ti_controle_integracao           
 where tpintegracao in('TR','BR')
   and cdsituacao in ('ER')
 group by cdsituacao, cdacao, tpintegracao
 order by 1, 2;

-- listar erros de importacao de titulos ACR por ordem de quantidades de ocorrencia
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*) QT
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'TR'
           and tc.cdsituacao   = 'ER')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;
 
select fa.*, tr.*
from ti_falha_de_processo fa, ti_controle_integracao tr
where tr.nrsequencial = fa.nrseq_controle_integracao
and tr.tpintegracao = 'TR'
and tr.cdsituacao =  'ER';
 
SPOOL OFF   
exit;
