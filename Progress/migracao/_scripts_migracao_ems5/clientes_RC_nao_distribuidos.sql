-- clientes em RC não distribuídos para as filas (R0, R1... até R9)
select cl.nrpessoa, cl.nrseq_controle_integracao, cl.cdsituacao, cl.cod_acao, 
cl.cod_cliente, cl.cod_id_feder, cl.ind_tipo_pessoa, cl.nom_abrev, 
cl.nom_cliente, p.noabreviado_cliente, p.noabreviado_fornecedor, p.cdn_cliente, p.cdn_fornecedor, p.nrregistro_pai, p.nopessoa
from ti_cliente cl, ti_pessoa p
where cl.cdsituacao = 'RC' --748
and p.nrregistro = cl.nrpessoa


