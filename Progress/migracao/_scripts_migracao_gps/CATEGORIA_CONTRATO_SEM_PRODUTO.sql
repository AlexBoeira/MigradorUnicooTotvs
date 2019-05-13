-- lista as CATEGORIAS dos CONTRATOS que não existem na CATEGORIA_DE_SERVICO. Falha de integridade.
select *
from categoria_de_servico_contr_pes cp
where not exists (select 1 from categoria_de_servico cs
                  where cs.cdcontrato=cp.cdcontrato
                    and cs.cdcategserv=cp.cdcategserv)
