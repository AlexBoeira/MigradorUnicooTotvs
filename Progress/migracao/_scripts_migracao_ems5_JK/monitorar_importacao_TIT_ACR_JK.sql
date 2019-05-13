SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS IMPORTACAO TITULOS A RECEBER</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\TITULO_ACR\STATUS_IMPORTACAO_TITULOS_A_RECEBER.html

--ABERTOS
	--1. QUANTIDADE QUE ESTA OK / EM ANDAMENTO
	select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') OK, 
		   decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
		   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
				  'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
				  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT, SYSDATE DATA, to_char(systimestamp, 'HH24:MI:ss') HORA
	  from ti_controle_integracao           
	 where tpintegracao in('TR')
	   and cdsituacao not in ('PE','ER')
	   and cdacao <> 'F'
	 group by cdsituacao, cdacao, tpintegracao
	 order by 1, 2, 3 desc;

	 
	 
	--2. QUANTIDADE DE ERROS
	select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') ERROS,
		   decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
		   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
				  'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
				  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT, SYSDATE DATA, to_char(systimestamp, 'HH24:MI:ss') HORA
	  from ti_controle_integracao           
	 where tpintegracao in('TR')
	   and cdsituacao in ('PE','ER')
	   and cdacao <> 'F'
	 group by cdsituacao, cdacao, tpintegracao
	 order by 1, 2, 3 desc;
 
	--3. CURVA ABC ERROS
	SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
	  FROM TI_FALHA_DE_PROCESSO T
	 WHERE EXISTS (SELECT 1
			  FROM TI_CONTROLE_INTEGRACAO TC
			 WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
			   AND TC.TPINTEGRACAO = 'TR'
			   and tc.cdsituacao = 'PE'
		   and tc.cdacao <> 'F')
	 GROUP BY T.TXFALHA, T.TXAJUDA
	 ORDER BY 3 DESC;

	--4. LISTAGEM COMPLETA ERROS
	select fa.*, tr.*, tta.*
	  from ti_falha_de_processo fa, ti_controle_integracao tr, ti_tit_acr tta
	 where tr.nrsequencial = fa.nrseq_controle_integracao
	   and tr.tpintegracao = 'TR'
	   and tta.nrseq_controle_integracao = tr.nrsequencial
	   and tr.cdsituacao = 'PE'
	   and cdacao <> 'F';

--FECHADOS
	--1. QUANTIDADE QUE ESTA OK / EM ANDAMENTO
	select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') OK, 
		   decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
		   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
				  'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
				  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT, SYSDATE DATA, to_char(systimestamp, 'HH24:MI:ss.FF') HORA
	  from ti_controle_integracao           
	 where tpintegracao in('TR')
	   and cdsituacao not in ('PE','ER')
	   and cdacao = 'F'
	 group by cdsituacao, cdacao, tpintegracao
	 order by 1, 2, 3 desc;

	 --2. QUANTIDADE DE ERROS
	select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') ERROS,
		   decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
		   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
				  'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
				  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT, SYSDATE DATA, to_char(systimestamp, 'HH24:MI:ss.FF') HORA
	  from ti_controle_integracao           
	 where tpintegracao in('TR')
	   and cdsituacao in ('PE','ER')
	   and cdacao <> 'F'
	 group by cdsituacao, cdacao, tpintegracao
	 order by 1, 2, 3 desc;

	--3. CURVA ABC ERROS
	SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
	  FROM TI_FALHA_DE_PROCESSO T
	 WHERE EXISTS (SELECT 1
			  FROM TI_CONTROLE_INTEGRACAO TC
			 WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
			   AND TC.TPINTEGRACAO = 'TR'
			   and tc.cdsituacao = 'PE'
			   and cdacao = 'F')
	 GROUP BY T.TXFALHA, T.TXAJUDA
	 ORDER BY 3 DESC;

	--4. LISTAGEM COMPLETA ERROS
	select fa.*, tr.*, tta.*
	  from ti_falha_de_processo fa, ti_controle_integracao tr, ti_tit_acr tta
	 where tr.nrsequencial = fa.nrseq_controle_integracao
	   and tr.tpintegracao = 'TR'
	   and tta.nrseq_controle_integracao = tr.nrsequencial
	   and tr.cdsituacao = 'PE'
	   and cdacao = 'F';

--BAIXAS
	--1. QUANTIDADE QUE ESTA OK / EM ANDAMENTO
	select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') OK, 
		   decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
		   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
				  'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
				  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT, SYSDATE DATA, to_char(systimestamp, 'HH24:MI:ss.FF') HORA
	  from ti_controle_integracao           
	 where tpintegracao in('BR')
	   and cdsituacao not in ('PE','ER')
	 group by cdsituacao, cdacao, tpintegracao
	 order by 1, 2, 3 desc;

	 --2. QUANTIDADE DE ERROS
	select decode(tpintegracao,'TR','TITULO A RECEBER','BR','BAIXA DO TITULO') ERROS,
		   decode(cdacao,'F','FECHADO','ABERTO') SIT_TIT, 
		   decode(cdsituacao,'IT','INTEGRADO','RC','NA FILA PARA IMPORTAR',
				  'CA','CANCELADO','PE','ERRO IMPORTACAO NO TOTVS',
				  'ER','ERRO EXTRACAO DO UNICOO',cdsituacao) SIT_MIG, count(*) QT, SYSDATE DATA, to_char(systimestamp, 'HH24:MI:ss.FF') HORA
	  from ti_controle_integracao           
	 where tpintegracao in('BR')
	   and cdsituacao in ('PE','ER')
	 group by cdsituacao, cdacao, tpintegracao
	 order by 1, 2, 3 desc;

	--3. CURVA ABC ERROS
	SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
	  FROM TI_FALHA_DE_PROCESSO T
	 WHERE EXISTS (SELECT 1
			  FROM TI_CONTROLE_INTEGRACAO TC
			 WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
			   AND TC.TPINTEGRACAO = 'BR'
			   and tc.cdsituacao = 'PE')
	 GROUP BY T.TXFALHA, T.TXAJUDA
	 ORDER BY 3 DESC;

	--4. LISTAGEM COMPLETA ERROS
	select fa.*, tr.*, tta.*
	  from ti_falha_de_processo fa, ti_controle_integracao tr, ti_tit_acr tta
	 where tr.nrsequencial = fa.nrseq_controle_integracao
	   and tr.tpintegracao = 'BR'
	   and tta.nrseq_controle_integracao = tr.nrsequencial
	   and tr.cdsituacao = 'PE';
	   
SPOOL OFF   
exit;
