-- títulos dos fornecedores no grupo NAOM
select t.nom_fornecedor, 
       t.cod_grp_fornecedor,
       tc.cdidentificador cdfornecedor, 
       tp.nrdocumento, 
       tap.cdhistorico,
       tp.*
  from ti_fornecedor          t, 
       ti_controle_integracao tc, 
       ti_matriz_pagar        tp, 
       titulo_a_pagar         tap 
 where t.cod_grp_fornecedor = 'NAOM' 
   and tc.nrsequencial = t.nrseq_controle_integracao 
   and tp.cdfornecedor = tc.cdidentificador 
   and tap.nrregistro_titulo = tp.nrregistro_titulo
