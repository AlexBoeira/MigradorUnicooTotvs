-- listar erros importação beneficiário de um determinado contrato
select e.*, b.* from gp.erro_process_import e, import_bnfciar b, import_propost ip
where e.num_seqcial_control = b.num_seqcial_control
and b.ind_sit_import = 'PE'
and ip.num_livre_3 = '7017'
and ip.nr_contrato_antigo = b.nr_contrato_antigo;

--update import_bnfciar ib set ib.ind_sit_import = 'RC' where ib.ind_sit_import = 'PE'

--select distinct num_livre_1 from import_bnfciar
--select * from import_bnfciar

--select ib.dt_inclusao_plano, ib.dt_exclusao_plano, ib.aa_ult_fat_period, ib.num_mes_ult_faturam from import_bnfciar ib
--where ib.dt_exclusao_plano is not null

--where ib.ind_sit_import = 'PE'


--select ib.cd_motivo_cancel, ib.dt_exclusao_plano, ib.aa_ult_fat_period, ib.num_mes_ult_faturam from import_bnfciar ib

--select * from mod_cob for update
--update mod_cob mc set mc.lg_produto_externo = 0, mc.u_log_1 = 1 where mc.lg_produto_externo = 1
--select * from producao.pessoa@unicoo_homologa p where p.nrcgc_cpf = '10880456779'
--select * from usuario u where u.nrregistro_pessoa = 387378
