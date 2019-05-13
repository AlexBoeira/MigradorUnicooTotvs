-- listar erros importação beneficiário
select e.*, b.* from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'
  --and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate)
--  and b.num_seqcial_bnfciar = 287526
--  and e.des_erro like '%Ja existe USUARIO com esse codigo.%'
--    and b.num_seqcial_bnfciar = 6482 --414776
    order by b.dat_ult_atualiz desc, b.hra_ult_atualiz desc
/*
select count(*)
  from gp.import_bnfciar ib
 where ib.u##ind_sit_import = 'IT'
   and not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = ib.cd_modalidade
           and u.nr_proposta = ib.nr_proposta
           and u.cd_usuario = ib.num_livre_6);

update gp.import_bnfciar ib
   set ib.u##ind_sit_import = 'GE', ib.ind_sit_import = 'GE'
 where ib.u##ind_sit_import = 'IT'
   and not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = ib.cd_modalidade
           and u.nr_proposta = ib.nr_proposta
           and u.cd_usuario = ib.num_livre_6)
*/

--and exists(select 1 from import_propost ip where ip.u##nr_contrato_antigo = b.nr_contrato_antigo and ip.num_livre_3 = '9972') --apenas erros em remidos
--and e.des_erro like '%PEA - Responsavel Sinistrado deve possuir mesma data de Inclusao/Exclusao%'
--and b.num_seqcial_bnfciar in (413061,413064,357783)

--select * from gp.import_propost ip where ip.nr_contrato_antigo = 2477049--modalidade 50   proposta 61
--select * from gp.propost p where p.nr_contrato_antigo = 2477049

--update import_bnfciar ib set ib.dt_nascimento = ib.dt_inclusao_plano, ib.u##ind_sit_import = 'RC', ib.ind_sit_import = 'RC' where ib.num_seqcial_control = 46347347

/*update import_bnfciar ib
   set ib.dt_inclusao_plano = '20/09/1999',
       ib.u##ind_sit_import = 'RC',
       ib.ind_sit_import    = 'RC'
 where ib.num_seqcial_control in (46347345, 46347346)

  select *
          from import_bnfciar ib
         where ib.cdcarteiraorigemresponsavel = 4009000220007
        
         update import_bnfciar ib set
         ib.dt_exclusao_plano = ib.dt_inclusao_plano,
         ib.u##ind_sit_import = 'RC', ib.ind_sit_import = 'RC'
         where ib.dt_exclusao_plano < ib.dt_inclusao_plano
           and ib.u##ind_sit_import = 'PE'*/
  

/*resp: 28000049302      28000049302   grau 30
6482

select * from gp.import_bnfciar ib where ib.num_seqcial_bnfciar = 6482


select * from t_v_plano_padrao t where t.cdcontrato_usu in ('PS002886','PS0028A')

update gp.ti_pl_sa ti set ti.lg_obriga_responsavel = 0

select distinct u_log_1 from ti_pl_sa

*/
