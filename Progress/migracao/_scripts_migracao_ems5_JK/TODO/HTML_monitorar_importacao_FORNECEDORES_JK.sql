SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS IMPORTACAO FORNECEDORES EMS5</TITLE> -
<STYLE type='text/css'> -
< BODY {background: #FFFFC6} > -
</STYLE>" -
TABLE "WIDTH='50%' BORDER='1'"

SPOOL C:\temp\teste_html_sqlplus\report.html

select 'SITUACAO X QUANTIDADE' VALIDACAO1 from dual;

-- MONITORAR STATUS FORNECEDORES
select decode(cdsituacao,'IT','INTEGRADO','PE','ERRO IMPORTACAO PROGRESS','ER','ERRO EXTRATOR UNICOO','RC','NA FILA PARA IMPORTAR',cdsituacao) SITUACAO, count(*) QUANTIDADE
  from ti_controle_integracao           
 where tpintegracao in('FN')
 group by cdsituacao
 order by 1, 2;

 select 'ERROS EXTRATOR X QUANTIDADE' VALIDACAO2 from dual;

--ERROS EXTRATOR POR QUANTIDADE DE OCORRENCIAS 
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'FN'
           and tc.cdsituacao = 'ER')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;

 select 'ERROS EXTRATOR DETALHADO' VALIDACAO3 from dual;

--ERROS EXTRATOR DETALHADO
select fa.*, fn.*
from ti_falha_de_processo fa, ti_controle_integracao fn
where fn.nrsequencial = fa.nrseq_controle_integracao
and fn.tpintegracao = 'FN'
and fn.cdsituacao =  'ER';

 select 'ERROS IMPORTACAO X QUANTIDADE' VALIDACAO4 from dual;
 
--ERROS IMPORTACAO POR QUANTIDADE DE OCORRENCIAS 
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'FN'
		   and tc.cdsituacao <> 'IT')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;

 select 'ERROS IMPORTACAO DETALHADO' VALIDACAO4 from dual;

--ERROS IMPORTACAO DETALHADO
select fo.cod_fornecedor, fo.cdsituacao, fa.*, fo.*
  from ti_falha_de_processo fa, ti_fornecedor fo
 where fo.nrseq_controle_integracao = fa.nrseq_controle_integracao
   and fo.cdsituacao <> 'IT';
/   
SPOOL OFF   
exit;
