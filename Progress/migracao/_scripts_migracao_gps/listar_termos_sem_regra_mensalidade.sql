--75.267 propostas sem regra. comparar apos reprocessar tudo

-- propostas/termos que ficaram sem regra de mensalidade
select p.cd_modalidade, p.nr_proposta, p.cd_sit_proposta
  from propost p, ter_ade t
 where not exists (select 1
          from regra_menslid_propost r
         where r.cd_modalidade = p.cd_modalidade
           and r.nr_proposta = p.nr_proposta)
   and t.cd_modalidade = p.cd_modalidade
   and t.nr_ter_adesao = p.nr_ter_adesao
