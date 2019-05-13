-- listar módulos que estavam em IMPORT_MODUL_PROPOST e não criou em PRO_PLA
select count(*) 
 from import_propost ip, propost p, import_modul_propost im
where ip.nr_contrato_antigo  = p.nr_contrato_antigo
  and im.num_seqcial_propost = ip.num_seqcial_propost
  and not exists (select 1 
                    from pro_pla pp
                   where pp.cd_modalidade = p.cd_modalidade
                     and pp.cd_plano      = p.cd_plano
                     and pp.cd_tipo_plano = p.cd_tipo_plano
                     and pp.nr_proposta   = p.nr_proposta
                     and pp.cd_modulo     = im.cd_modulo)