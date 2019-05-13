-- procurar categorias dos planos 'antigos' que possuem módulo equivalente em DEPARA_MODULO,
-- sendo que esse mesmo módulo deve existir em MIGRACAO_MODULO_PADRAO e a CATEGORIA correspondente
-- deve existir no plano MIG
select cds.cdcontrato, tda.cdcontrato_cobertura,cds.cdcategserv ,c.nocategoria
from categoria_de_servico cds, temp_depara_agrupado tda, categoria c
where tda.cdcontrato = cds.cdcontrato
and c.cdcategoria = cds.cdcategserv
and exists(select 1 from depara_modulo dm, migracao_modulo_padrao mmp 
                    where dm.cdcategserv = cds.cdcategserv
                      and dm.cdmodulo = mmp.cdmodulo
                      and not exists(select 1 from categoria_de_servico cds2
                                 where cds2.cdcategserv = mmp.cdcategserv
                                 and tda.cdcontrato_cobertura = cds2.cdcontrato)
)
