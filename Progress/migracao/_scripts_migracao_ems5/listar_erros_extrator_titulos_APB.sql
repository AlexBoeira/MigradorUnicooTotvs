-- listar erros do extrator de titulos APB - esses casos não foram criados em TI_TIT_APB
select fa.*, tp.*
from ti_falha_de_processo fa, ti_controle_integracao tp
where tp.nrsequencial = fa.nrseq_controle_integracao
and tp.tpintegracao = 'TP'
--and fa.txfalha like 'Verifique o De%'
and tp.cdsituacao =  'ER' order by dtfalha desc


--select * from ems5.pessoa_jurid j where j.nom_pessoa = 'F W OLIVEIRA TERRAPLENAGEM LTDA'
