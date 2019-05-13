-- listar fornecedor classificados como NAO MIGRAR (NM) com seus títulos em aberto
select fo.*, tp.*,  f.* 
from producao.fornecedor@unicoo_homologa f, producao.titulo_a_pagar@unicoo_homologa tp, ti_fornecedor fo
where fo.cdsituacao = 'NM'
  and f.nrregistro_fornecedor = fo.nrpessoa
  and tp.cdfornecedor = f.cdfornecedor
  and tp.cdsituacao in (0,2);
