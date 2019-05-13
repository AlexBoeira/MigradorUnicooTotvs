-- listar erros do extrator de Clientes - esses casos não foram criados em TI_CLIENTE
select fa.*, cl.*
from ti_falha_de_processo fa, ti_controle_integracao cl
where cl.nrsequencial = fa.nrseq_controle_integracao
and cl.tpintegracao = 'CL'
and cl.cdsituacao =  'ER';
