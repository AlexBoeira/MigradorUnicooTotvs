-- lista as CATEGORIAS dos CRITERIOS_DO_USUARIO que não existem na CATEGORIA_DE_SERVICO. Falha de integridade.
select *
from criterios_do_usuario cu, usuario u
where u.nrsequencial_usuario = cu.nrsequencial_usuario
  and u.nrcontrato='0045'
  and not exists (select * from categoria_de_servico cs
                  where cs.cdcontrato=u.cdcontrato
                    and cs.cdcategserv=cu.cdcategserv);
