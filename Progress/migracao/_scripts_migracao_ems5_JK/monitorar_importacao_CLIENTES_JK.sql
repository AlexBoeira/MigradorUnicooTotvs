SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS IMPORTACAO CLIENTES</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"

SPOOL &1\CLIENTE\STATUS_IMPORTACAO_CLIENTES.html

select tpintegracao, cdsituacao, count(*) QTD, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from ti_controle_integracao           
 where tpintegracao in('CL')
 group by cdsituacao, tpintegracao
 order by 1, 2;
 
SELECT T.TXFALHA, T.TXAJUDA, COUNT(*)
  FROM TI_FALHA_DE_PROCESSO T
 WHERE EXISTS (SELECT 1
          FROM TI_CONTROLE_INTEGRACAO TC
         WHERE TC.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
           AND TC.TPINTEGRACAO = 'CL'
       and tc.cdsituacao = 'PE')
 GROUP BY T.TXFALHA, T.TXAJUDA
 ORDER BY 3 DESC;

select '------------------DETALHES ERROS IMPORTACAO-------------------' VALIDACAO5 from dual;
-- listar erros importacao cliente
select cl.cod_cliente, cl.cdsituacao, fa.*, cl.*
  from ti_falha_de_processo fa, ti_cliente cl
 where cl.nrseq_controle_integracao = fa.nrseq_controle_integracao
   and cl.cdsituacao = 'PE';

SPOOL OFF   
exit;
