--listar propostas com sua lotacao de demitido quando nao possui lotacao "normal" no Unicoo
select ip.cd_modalidade,
       ip.num_livre_10 NR_PROPOSTA,
       lp.cdn_lotac,
       a.nrregistro,
       a.nrcontrato
  from gp.import_propost ip,
       gp.lotac_propost lp,
       (select cdp.nrregistro, cdp.nrcontrato
          from contrato_da_pessoa cdp
         where not exists (select 1
                  from lotacao l
                 where l.nrregistro = cdp.nrregistro
                   and l.nrcontrato = cdp.nrcontrato)
           and exists (select 1
                  from familia f
                 where f.nrregistro = cdp.nrregistro
                   and f.nrcontrato = cdp.nrcontrato
                   and f.dtinicio_contrato is not null)) a
 where ip.num_livre_2 = a.nrregistro
   and lpad(ip.num_livre_3, 4, '0') = a.nrcontrato
   and lp.cdn_modalid = ip.cd_modalidade
   and lp.num_propost = ip.num_livre_10
