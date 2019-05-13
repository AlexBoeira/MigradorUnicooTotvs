-- listar erros importacao da baixa de titulos ACR
select fa.*, btr.*
from ems506unicoo.ti_falha_de_processo fa, ems506unicoo.ti_cx_bx_acr btr
where btr.nrseq_controle_integracao = fa.nrseq_controle_integracao
and btr.cdsituacao =  'PE';
