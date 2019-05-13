
--LISTAR USUARIO E IMPORT_MODUL_BNFCIAR sem USUMODU e nem PRO_PLA OBRIGATORIO CORRESPONDENTE
select count(*) from gp.usuario u, gp.import_bnfciar ib, gp.import_modul_bnfciar imb
 where ib.cd_modalidade = u.cd_modalidade
   and ib.nr_proposta = u.nr_proposta
   and ib.num_livre_6 = u.cd_usuario
   and imb.num_seqcial_bnfciar = ib.num_seqcial_bnfciar
                 and not exists(select 1 from gp.usumodu um
                                 where um.cd_modalidade = u.cd_modalidade
                                   and um.nr_proposta   = u.nr_proposta
                                   and um.cd_usuario    = u.cd_usuario
                                   and um.cd_modulo     = imb.cdn_modul)
                 and not exists(select 1 from gp.pro_pla pp
                                        where pp.cd_modalidade = u.cd_modalidade
                                          and pp.nr_proposta = u.nr_proposta
                                          and pp.cd_modulo = imb.cdn_modul
                                          and pp.lgcoberturaobrigatoria = 1)
--110227 -> 110226 = CORRETO

--LISTAR SE TEM 100% DE RELACAO ENTRE IMPORT_MODUL_BNFCIAR E USUMODU
select count(*)
  from gp.usuario u, gp.import_bnfciar ib, gp.import_modul_bnfciar imb
 where ib.cd_modalidade = u.cd_modalidade
   and ib.nr_proposta = u.nr_proposta
   and ib.num_livre_6 = u.cd_usuario
   and imb.num_seqcial_bnfciar = ib.num_seqcial_bnfciar
   and (exists (select 1
                  from gp.usumodu um
                 where um.cd_modalidade = u.cd_modalidade
                   and um.nr_proposta = u.nr_proposta
                   and um.cd_usuario = u.cd_usuario
                   and um.cd_modulo = imb.cdn_modul) or exists
        (select 1
           from gp.pro_pla pp
          where pp.cd_modalidade = u.cd_modalidade
            and pp.nr_proposta = u.nr_proposta
            and pp.cd_modulo = imb.cdn_modul
            and pp.lgcoberturaobrigatoria = 1))
--5147933 -> 5147934 = CORRETO
