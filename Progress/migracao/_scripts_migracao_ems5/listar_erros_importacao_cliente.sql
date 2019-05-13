-- listar erros de importacao de clientes
select cl.cod_cliente, fa.*, cl.*
from ti_falha_de_processo fa, ti_cliente cl
where cl.nrseq_controle_integracao = fa.nrseq_controle_integracao
and cl.cdsituacao = 'PE'

and fa.txajuda like '%o Estadual%'

/*
update ti_cliente cl
   set cl.cod_banco = 136, cl.cdsituacao = 'RC'
 where cl.cdsituacao = 'PE'
   and exists
 (select 1
          from ti_falha_de_processo fa
         where cl.nrseq_controle_integracao = fa.nrseq_controle_integracao
           and fa.txfalha like '%Banco%foi encontrado%')
*/
