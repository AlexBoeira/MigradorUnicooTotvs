-- listar erros do extrator de titulos ACR - esses casos não foram criados em TI_TIT_ACR
select fa.*, tr.*
from ti_falha_de_processo fa, ti_controle_integracao tr
where tr.nrsequencial = fa.nrseq_controle_integracao
and tr.tpintegracao = 'TR'
and tr.cdsituacao =  'ER';

--select * from titulo_a_receber r where r.nrdocumento is null
