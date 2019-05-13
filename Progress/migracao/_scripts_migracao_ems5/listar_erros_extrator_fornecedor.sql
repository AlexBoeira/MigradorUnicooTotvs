-- listar erros do extrator de Fornecedores - esses casos não foram criados em TI_FORNECEDOR
select fa.*, fn.*
from ti_falha_de_processo fa, ti_controle_integracao fn
where fn.nrsequencial = fa.nrseq_controle_integracao
and fn.tpintegracao = 'FN'
and fn.cdsituacao =  'ER';
