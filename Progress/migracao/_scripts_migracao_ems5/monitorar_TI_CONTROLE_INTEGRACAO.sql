--4  FN  IT  23407  11/01/2019 16:19:55
--5  FN  PE  395  11/01/2019 16:19:55


--, MONITORAR STATUS TI_CONTROLE_INTEGRACAO
select tpintegracao, cdsituacao, count(*), SYSDATE
  from ti_controle_integracao           --where tpintegracao in('CL')   --in('TR' , 'BR')
 group by cdsituacao, tpintegracao
 order by 1, 2;
/*
cdsituacao:
GE - gerando tempor�rias nos processos SQL. Esse status � tempor�rio, muda automaticamente 
     ao final da etapa para ER ou RC.
ER - ocorreu erro na tentativa de gera��o dos registros na �rea tempor�ria (extra��o).
RC - registros gerados na �rea tempor�ria com sucesso. Prontos para serem distribu�dos nas filas de importa��o.
     0...99 - registros que estavam como RC e foram distribu�dos nas filas.
PE - ocorreu erro na tentativa de processamento na camada Progress.
IT - integrado com sucesso.
*/

/*
tpintegracao:
CL - cliente
FN - fornecedor
TR - t�tulo aberto a receber
TP - t�tulo aberto a pagar
BR - baixa de t�tulos a receber
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
