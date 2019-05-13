-- erros importacao clientes
select cl.cod_cliente, cl.cdsituacao, --cl.nom_endereco, cl.nom_ender_compl, 
e.*
from ti_cliente cl, ti_falha_de_processo e
where cl.nrseq_controle_integracao = e.nrseq_controle_integracao
and cl.cdsituacao = 'ER' -- ER: erro ao montar TI_FORNECEDOR; PE: erro ao processar rotina no Progress; 
--and e.txfalha not like '%Banco%'
--and e.txfalha not lPEike '%CEP%'
