SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>STATUS MIGRACAO CONTRATANTES</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\CONTRATANTE\STATUS_MIGRACAO_CONTRATANTES.html

--MONITORAR  CONTRATANTES
select decode(cdsituacao,'ER','ERRO','IT','INTEGRADO','RE','REPROCESSANDO',cdsituacao) SITUACAO, count(*) QTD, sysdate || ' ' || to_char(systimestamp, 'HH24:MI:ss') ULT_ATU
  from temp_migracao_contratante
 group by cdsituacao;

--LISTAR ERROS MIGRACAO CONTRATANTE
select c.nrregistro NRREGISTRO, c.nr_insc_contrat, e.des_erro, e.des_ajuda, e.dat_ult_atualiz, e.hra_ult_atualiz,
       c.nocontratante, c.tppessoa, c.cgc_cpf, c.noabreviado, c.dtnascimento, c.nrgrupo_cliente, c.cdcontratante
       from erro_process_import e, temp_migracao_contratante c
where e.num_seqcial_control = c.nrseq_controle
and c.cdsituacao = 'ER'; 

SPOOL OFF   
exit;
