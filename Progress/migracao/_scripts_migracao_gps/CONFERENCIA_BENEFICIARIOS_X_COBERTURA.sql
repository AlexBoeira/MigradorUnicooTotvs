--LISTAR BENEFICIARIOS QUE POSSUEM AO MENOS UM IMPORT_MODUL_BNFCIAR SEM USUMODU NEM PRO_PLA OBRIGATORIO CORRESPONDENTE. ERRO! (REPROCESSAR)
select count(*) from gp.usuario u, gp.import_bnfciar ib
 where ib.cd_modalidade = u.cd_modalidade
   and ib.nr_proposta = u.nr_proposta
   and ib.num_livre_6 = u.cd_usuario
   and ib.u##ind_sit_import = 'IT'
   --and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
   and exists(select 1 from gp.import_modul_bnfciar imb 
               where imb.num_seqcial_bnfciar = ib.num_seqcial_bnfciar
                 and not exists(select 1 from gp.usumodu um
                                 where um.cd_modalidade = u.cd_modalidade
                                   and um.nr_proposta   = u.nr_proposta
                                   and um.cd_usuario    = u.cd_usuario
                                   and um.cd_modulo     = imb.cdn_modul)
                 and not exists(select 1 from gp.pro_pla pp
                                        where pp.cd_modalidade = u.cd_modalidade
                                          and pp.nr_proposta = u.nr_proposta
                                          and pp.cd_modulo = imb.cdn_modul
                                          and pp.lgcoberturaobrigatoria = 1))
--HML-PROD ativos: 1713 total: 11760

--LISTAR BENEFICIARIOS EM QUE IMPORT_MODUL_BNFCIAR ESTA 100% COMPATIVEL COM USUMODU E/OU PRO_PLA OBRIGATORIO
select count(*)
  from gp.usuario u, gp.import_bnfciar ib
 where ib.cd_modalidade = u.cd_modalidade
   and ib.nr_proposta = u.nr_proposta
   and ib.num_livre_6 = u.cd_usuario
   and ib.u##ind_sit_import = 'IT'
   and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
   and exists
 (select 1
          from gp.import_modul_bnfciar imb
         where imb.num_seqcial_bnfciar = ib.num_seqcial_bnfciar
           and(exists (select 1
                  from gp.usumodu um
                 where um.cd_modalidade = u.cd_modalidade
                   and um.nr_proposta = u.nr_proposta
                   and um.cd_usuario = u.cd_usuario
                   and um.cd_modulo = imb.cdn_modul)
            or exists (select 1
                  from gp.pro_pla pp
                 where pp.cd_modalidade = u.cd_modalidade
                   and pp.nr_proposta = u.nr_proposta
                   and pp.cd_modulo = imb.cdn_modul
                   and pp.lgcoberturaobrigatoria = 1)))
--512526

--LISTAR USUARIO E IMPORT_MODUL_BNFCIAR sem USUMODU e nem PRO_PLA OBRIGATORIO CORRESPONDENTE
select --count(*) 
       u.cd_modalidade, u.nr_proposta, u.cd_usuario, u.dt_exclusao_plano, imb.cdn_modul
  from gp.usuario u, gp.import_bnfciar ib, gp.import_modul_bnfciar imb
 where ib.cd_modalidade = u.cd_modalidade
   and ib.nr_proposta = u.nr_proposta
   and ib.num_livre_6 = u.cd_usuario
   and ib.u##ind_sit_import = 'IT'
   --and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
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
                 and exists(select 1 from gp.pro_pla pp
                                        where pp.cd_modalidade = u.cd_modalidade
                                          and pp.nr_proposta = u.nr_proposta
                                          and pp.cd_modulo = imb.cdn_modul)
--TOTVS-HML-PROD: total: ativos 0; inativos 271

--LISTAR BENEFICIARIOS COM IMPORT_MODUL_BNFCIAR QUE ESTA 100% COMPATIVEL COM USUMODU E/OU PRO_PLA OBRIGATORIO
select count(*)
  from gp.usuario u, gp.import_bnfciar ib, gp.import_modul_bnfciar imb
 where ib.cd_modalidade = u.cd_modalidade
   and ib.nr_proposta = u.nr_proposta
   and ib.num_livre_6 = u.cd_usuario
   and ib.u##ind_sit_import = 'IT'
   and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
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
--5199906

--LISTAR PROPOSTAS EM QUE NAO CRIOU PROPCOPA MAS EXISTE EM FTPADCOB E TEMPORARIA DE IMPORTACAO
select * from gp.propost p, gp.import_propost ip, gp.importpadrcobertpropost ipc
 where ip.cd_modalidade = p.cd_modalidade
   and ip.num_livre_10 = p.nr_proposta
   and ip.u##ind_sit_import = 'IT'
--   and (ip.dat_fim_propost is null or ip.dat_fim_propost > sysdate)
   and ipc.num_seqcial_propost = ip.num_seqcial_propost
                 and not exists(select 1 from gp.propcopa pc
                                 where pc.cd_modalidade = p.cd_modalidade
                                   and pc.nr_proposta   = p.nr_proposta
                                   and pc.cd_modulo     = ipc.cd_modulo)
                 and not exists(select 1 from gp.pro_pla pp
                                        where pp.cd_modalidade = p.cd_modalidade
                                          and pp.nr_proposta = p.nr_proposta
                                          and pp.cd_modulo = ipc.cd_modulo
                                          and pp.lgcoberturaobrigatoria = 1)
                 and exists(select 1 from gp.pro_pla pp
                                        where pp.cd_modalidade = p.cd_modalidade
                                          and pp.nr_proposta = p.nr_proposta
                                          and pp.cd_modulo = ipc.cd_modulo)

--LISTAR BENEFICIARIOS EM QUE O REGISTRO EXISTE NA PROPCOPA MAS FALTA NA USUMODU
select count(*)
  from gp.usuario u, gp.propcopa pc
 where pc.cd_modalidade = u.cd_modalidade
   and pc.nr_proposta = u.nr_proposta
   and pc.cd_padrao_cobertura = u.cd_padrao_cobertura
--   and (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
   and not exists (select 1
          from gp.usumodu um
         where um.cd_modalidade = u.cd_modalidade
           and um.nr_proposta = u.nr_proposta
           and um.cd_usuario = u.cd_usuario
           and um.cd_modulo = pc.cd_modulo)
   and not exists (select 1
          from gp.pro_pla pp
         where pp.cd_modalidade = u.cd_modalidade
           and pp.nr_proposta = u.nr_proposta
           and pp.cd_modulo = pc.cd_modulo
           and pp.lgcoberturaobrigatoria = 1)
--TOTVS-HML-PROD total:            

