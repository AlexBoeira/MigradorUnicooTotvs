--LIMPAR BENEFICIARIOS NO GP E SETAR IMPORT_BNFCIAR PARA RC
declare
begin
  for x in (select ib.progress_recid recid_ib,
                   cm.progress_recid recid_cm,
                   cm.num_seqcial,
                   ib.num_seqcial_bnfciar
              from gp.import_bnfciar ib, control_migrac cm
             where cm.num_seqcial = ib.num_seqcial_control) loop
  
    pck_unicoogps.apaga_beneficiario_totvs(x.num_seqcial_bnfciar);
  
    update gp.import_bnfciar ib
       set ib.u##ind_sit_import = 'RC', ib.ind_sit_import = 'RC'
     where ib.progress_recid = x.recid_ib;
  
    update gp.control_migrac cm
       set cm.u##ind_sit_import = 'RC', cm.ind_sit_import = 'RC'
     where cm.progress_recid = x.recid_cm;
  
    delete from gp.erro_process_import e
     where e.num_seqcial_control = x.num_seqcial;
  end loop;
  commit;
end;

/*select * from pr_id_us
select count(*) from car_ide    --259.815 como pode ter mais que usuario nesse ponto???
select count(*) from gp.usuario u--241.015
where u.log_17 = 0


--CAR_IDE SEM USUARIO!
delete
  from car_ide ci
 where not exists (select 1
          from gp.usuario u
         where u.cd_unimed = ci.cd_unimed
           and u.cd_modalidade = ci.cd_modalidade
           and u.nr_ter_adesao = ci.nr_ter_adesao
           and u.cd_usuario = ci.cd_usuario)

delete--select *
  from usumodu um
 where not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = um.cd_modalidade
           and u.nr_proposta = um.nr_proposta
           and u.cd_usuario = um.cd_usuario)

delete--select *
  from usmovadm ua
 where not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = ua.cd_modalidade
           and u.nr_proposta = ua.nr_proposta
           and u.cd_usuario = ua.cd_usuario)

delete--select *
  from gp.gerac_cod_ident_benef g
 where not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = g.cdn_modalid
           and u.nr_proposta = g.num_propost
           and u.cd_usuario = g.cdn_usuar)
           
15 - Proposta: 697 - Benef: 6
select * from gp.usuario u where u.cd_modalidade = 15 and u.nr_proposta = 697 and u.cd_usuario = 6
           
           
select count(*) from gp.USUARIO
select count(*) from gp.USUCAREN
select count(*) from gp.USUMODU--
select count(*) from gp.CAR_IDE
select count(*) from gp.USUREATE
select count(*) from gp.USUREPAS
select count(*) from gp.USMOVADM
select count(*) from gp.HIST_ALTER_GP
select count(*) from gp.HIST_MOVTO_USUARIO
select count(*) from gp.GERAC_COD_IDENT_BENEF
           
select count(*) from unicoogps.control_migrac--967688

select count(*) from gp.control_migrac cm--967688
where cm.u##ind_tip_migrac = 'BE'--513389
select count(*) from import_bnfciar

select count(*) from erro_process_import --ANTES: 432739; DEPOIS: 
           
select * from gp.control_migrac--967688
select u##ind_tip_migrac,count(*) from control_migrac group by u##ind_tip_migrac
select * from erro_process_import e  --ANTES: 432739; DEPOIS: 
where e.dat_erro >= '12/05/2018'
           
select count(*) from gp.control_migrac cm --967688
           where cm.u##ind_tip_migrac = 'BE'
             and not exists(select 1 from gp.import_bnfciar ib where ib.num_seqcial_control = cm.num_seqcial)

select count(*) from erro_process_import e
           where exists(select 1 from gp.control_migrac cm where e.num_seqcial_control = cm.num_seqcial
                                   and cm.u##ind_tip_migrac = 'BE'
                                   \*and cm.u##ind_sit_import not in ('PE','ER')*\)

select count(*) from erro_process_import e where not exists(select 1 from control_migrac cm where cm.num_seqcial = e.num_seqcial_control)
             */