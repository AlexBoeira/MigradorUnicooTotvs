-- listar documentos com carteira antiga do beneficiario, quando deveria ser a carteira atual
select
--count(*) 
 d.cd_modalidade, d.nr_ter_adesao, d.cd_usuario, d.cd_carteira_usuario
  from docrecon d, paramecp p
 where d.cd_unidade_carteira = p.cd_unimed
   and exists (select 1
          from gp.usuario u
         where u.cd_carteira_antiga = d.cd_carteira_usuario
           and u.cd_modalidade = d.cd_modalidade
           and u.nr_ter_adesao = d.nr_ter_adesao
           and u.cd_usuario = d.cd_usuario
        --and u.dt_exclusao_plano is null
        );