-- erros importacao fornecedores
select fo.cod_fornecedor, fo.cdsituacao, e.*
from ti_fornecedor fo, ti_falha_de_processo e
where fo.nrseq_controle_integracao = e.nrseq_controle_integracao
