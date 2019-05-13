--4  FN  IT  23407  11/01/2019 16:19:55
--5  FN  PE  395  11/01/2019 16:19:55


--, MONITORAR STATUS TI_CONTROLE_INTEGRACAO
select tpintegracao, cdsituacao, count(*), SYSDATE
  from ti_controle_integracao           --where tpintegracao in('CL')   --in('TR' , 'BR')
 group by cdsituacao, tpintegracao
 order by 1, 2;
/*
cdsituacao:
GE - gerando temporárias nos processos SQL. Esse status é temporário, muda automaticamente 
     ao final da etapa para ER ou RC.
ER - ocorreu erro na tentativa de geração dos registros na área temporária (extração).
RC - registros gerados na área temporária com sucesso. Prontos para serem distribuídos nas filas de importação.
     0...99 - registros que estavam como RC e foram distribuídos nas filas.
PE - ocorreu erro na tentativa de processamento na camada Progress.
IT - integrado com sucesso.
*/

/*
tpintegracao:
CL - cliente
FN - fornecedor
TR - título aberto a receber
TP - título aberto a pagar
BR - baixa de títulos a receber
*/

/*caso existam registros em situacao GE, executar p_job (abaixo):
begin
  pck_ems506unicoo.p_job;
end;
*/

/*
-- LIMPAR TI_CONTROLE_INTEGRACAO SEM RELACIONAMENTOS - esses registros distorcem os resultados dessa pesquisa.
select count(*) from ti_controle_integracao tci
where tci.tpintegracao = 'TP'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_tit_apb tp where tp.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'TP'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_tit_apb tp where tp.nrseq_controle_integracao = tci.nrsequencial);

select * from ti_controle_integracao tci
where tci.tpintegracao = 'TR'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_tit_acr tr where tr.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'TR'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_tit_acr tr where tr.nrseq_controle_integracao = tci.nrsequencial);

select * from ti_controle_integracao tci
where tci.tpintegracao = 'FN'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_fornecedor f where f.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'FN'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_fornecedor f where f.nrseq_controle_integracao = tci.nrsequencial);

select * from ti_controle_integracao tci
where tci.tpintegracao = 'CL'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_cliente c where c.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'CL'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_cliente c where c.nrseq_controle_integracao = tci.nrsequencial);

select * from ti_controle_integracao tci
where tci.tpintegracao = 'BR'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_cx_bx_acr br where br.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'BR'
  and tci.cdsituacao not in ('ER','CA')
  and not exists(select 1 from ti_cx_bx_acr br where br.nrseq_controle_integracao = tci.nrsequencial);
*/

/*
-- LIMPAR TI_CONTROLE_INTEGRACAO SEM RELACIONAMENTOS - esses registros distorcem os resultados dessa pesquisa.
delete from ti_controle_integracao tci
where tci.tpintegracao = 'TP'
and not exists(select 1 from ti_tit_apb tp where tp.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'TR'
and not exists(select 1 from ti_tit_acr tr where tr.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'FN'
and not exists(select 1 from ti_fornecedor f where f.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'CL'
and not exists(select 1 from ti_cliente c where c.nrseq_controle_integracao = tci.nrsequencial);

delete from ti_controle_integracao tci
where tci.tpintegracao = 'BR'
and not exists(select 1 from ti_cx_bx_acr br where br.nrseq_controle_integracao = tci.nrsequencial);
*/

-- delete from ti_controle_integracao i where i.cdsituacao = 'GE' and i.tpintegracao = 'CL'
