--TROCAR PLA_MOD DE OPCIONAL PARA OBRIGATORIO E AJUSTAR RELACIONAMENTOS
--1. PLA_MOD.LG_OBRIGATORIO MUDA DE OPCIONAL PARA OBRIGATORIO;
--2. DELETAR FTPADCOB;
--3. DELETAR PROPCOPA;
--4. TROCAR PRO_PLA DE OPCIONAL PARA OBRIGATORIO;
--5. DELETAR USUMODU;
declare
  vaosimula varchar2(1) := 'N';
  vnr_seq number := 0;
  
  procedure trocar_pla_mod_obrig(pcd_modalidade number,
                                 pcd_plano      number,
                                 pcd_tipo_plano number,
                                 pcd_modulo     number) is
  begin
    for pm in (select * from gp.pla_mod pm
                       where pm.cd_modalidade = pcd_modalidade
                         and pm.cd_plano      = pcd_plano
                         and pm.cd_tipo_plano = pcd_tipo_plano
                         and pm.cd_modulo     = pcd_modulo) loop
                         
      vnr_seq := vnr_seq + 1;
      insert into temp_log values('TROCAR_PLA_MOD_OBRIG','ALTERANDO_PLA_MOD',vnr_seq,PM.CD_MODALIDADE || ';' || PM.CD_PLANO || ';' || PM.CD_TIPO_PLANO || ';' || PM.CD_MODULO);
      
      if vaosimula = 'N' then
        update gp.pla_mod p set p.lg_obrigatorio = '1' where p.progress_recid = pm.progress_recid;
      end if;
      
      for pp in (select * from gp.pro_pla p where p.cd_modalidade = pm.cd_modalidade
                                              and p.cd_plano      = pm.cd_plano
                                              and p.cd_tipo_plano = pm.cd_tipo_plano
                                              and p.cd_modulo     = pm.cd_modulo) loop

        vnr_seq := vnr_seq + 1;
        insert into temp_log values('TROCAR_PLA_MOD_OBRIG','ALTERANDO_PRO_PLA',vnr_seq,PP.CD_MODALIDADE || ';' || PP.CD_PLANO || ';' || PP.CD_TIPO_PLANO || ';' || 
                                                      PP.NR_PROPOSTA || ';' || PP.CD_MODULO);
        if vaosimula = 'N' then
          update gp.pro_pla p set p.lgcoberturaobrigatoria = '1' where p.progress_recid = pp.progress_recid;
        end if;
        
        for prc in (select * from gp.propcopa p where p.cd_modalidade = pp.cd_modalidade
                                                  and p.nr_proposta   = pp.nr_proposta
                                                  and p.cd_modulo     = pp.cd_modulo) loop
                                                  
          vnr_seq := vnr_seq + 1;
          insert into temp_log values('TROCAR_PLA_MOD_OBRIG','DELETANDO_PROPCOPA',vnr_seq,PRC.CD_MODALIDADE || ';' || PRC.NR_PROPOSTA || ';' || PRC.CD_PADRAO_COBERTURA || ';' || 
                                                        PRC.CD_MODULO);
          if vaosimula = 'N' then
            delete from gp.propcopa p where p.progress_recid = prc.progress_recid;
          end if;
        end loop;                   
        
        for um in (select * from gp.usumodu um where um.cd_modalidade = pp.cd_modalidade
                                                 and um.nr_proposta   = pp.nr_proposta
                                                 and um.cd_modulo     = pp.cd_modulo) loop
          vnr_seq := vnr_seq + 1;
          insert into temp_log values('TROCAR_PLA_MOD_OBRIG','DELETANDO_USUMODU',vnr_seq,UM.CD_MODALIDADE || ';' || UM.NR_PROPOSTA || ';' || UM.CD_USUARIO || ';' || 
                                                        UM.CD_MODULO);
          if vaosimula = 'N' then
            delete from gp.usumodu u where u.progress_recid = um.progress_recid;
          end if;
        end loop;                   
        
      end loop;
      
      for fp in (select * from gp.ftpadcob fp 
                         where fp.cd_modalidade = pm.cd_modalidade
                           and fp.cd_plano      = pm.cd_plano
                           and fp.cd_tipo_plano = pm.cd_tipo_plano
                           and fp.cd_modulo     = pm.cd_modulo) loop
                           
        vnr_seq := vnr_seq + 1;
        insert into temp_log values('TROCAR_PLA_MOD_OBRIG','DELETANDO_FTPADCOB',vnr_seq,FP.CD_MODALIDADE || ';' || FP.CD_PLANO || ';' || FP.CD_TIPO_PLANO || ';' || 
                                                      FP.CD_PADRAO_COBERTURA || ';' || FP.CD_MODULO);
        if vaosimula = 'N' then
          delete from gp.ftpadcob f where f.progress_recid = fp.progress_recid;
        end if;
      end loop;
    end loop;
  end trocar_pla_mod_obrig;

begin
  delete from temp_log t where t.ds_processo = 'TROCAR_PLA_MOD_OBRIG';

  vnr_seq := vnr_seq + 1;
  insert into temp_log values('TROCAR_PLA_MOD_OBRIG','ALTERANDO_PLA_MOD',vnr_seq,'MODALIDADE;CD_PLANO;TIPO;PM.CD_MODULO');
  vnr_seq := vnr_seq + 1;
  insert into temp_log values('TROCAR_PLA_MOD_OBRIG','DELETANDO_FTPADCOB',vnr_seq,'MODALIDADE;PLANO;TIPO;PAD_COB;MODULO');
  vnr_seq := vnr_seq + 1;
  insert into temp_log values('TROCAR_PLA_MOD_OBRIG','ALTERANDO_PRO_PLA',vnr_seq,'MODALIDADE;PLANO;TIPO;PROPOSTA;MODULO');
  vnr_seq := vnr_seq + 1;
  insert into temp_log values('TROCAR_PLA_MOD_OBRIG','DELETANDO_PROPCOPA',vnr_seq,'MODALIDADE;NR_PROPOSTA;CD_PADRAO_COBERTURA;MODULO');
  vnr_seq := vnr_seq + 1;
  insert into temp_log values('TROCAR_PLA_MOD_OBRIG','DELETANDO_USUMODU',vnr_seq,'MODALIDADE;PROPOSTA;USUARIO;MODULO');

--  trocar_pla_mod_obrig(20, 13, 13, 1);

  trocar_pla_mod_obrig(20, 13, 13, 11);
  trocar_pla_mod_obrig(20, 13, 13, 12);
  trocar_pla_mod_obrig(20, 13, 13, 13);
  trocar_pla_mod_obrig(20, 13, 13, 14);
  trocar_pla_mod_obrig(20, 13, 13, 15);
  trocar_pla_mod_obrig(20, 13, 13, 2);
  trocar_pla_mod_obrig(20, 13, 13, 23);
  trocar_pla_mod_obrig(20, 13, 13, 24);
  trocar_pla_mod_obrig(20, 13, 13, 25);
  trocar_pla_mod_obrig(20, 13, 13, 3);
  trocar_pla_mod_obrig(20, 13, 13, 4);
  trocar_pla_mod_obrig(20, 13, 13, 5);
  trocar_pla_mod_obrig(20, 13, 13, 6);
  
  trocar_pla_mod_obrig(1, 2, 2, 1);
  trocar_pla_mod_obrig(1, 2, 2, 12);
  trocar_pla_mod_obrig(1, 2, 2, 13);
  trocar_pla_mod_obrig(1, 2, 2, 14);
  trocar_pla_mod_obrig(1, 2, 2, 15);
  trocar_pla_mod_obrig(1, 2, 2, 2);
  trocar_pla_mod_obrig(1, 2, 2, 23);
  trocar_pla_mod_obrig(1, 2, 2, 24);
  trocar_pla_mod_obrig(1, 2, 2, 25);
  trocar_pla_mod_obrig(1, 2, 2, 3);
  trocar_pla_mod_obrig(1, 2, 2, 4);
  trocar_pla_mod_obrig(1, 2, 2, 6);
  trocar_pla_mod_obrig(15, 1, 1, 1);
  trocar_pla_mod_obrig(15, 1, 1, 12);
  trocar_pla_mod_obrig(15, 1, 1, 13);
  trocar_pla_mod_obrig(15, 1, 1, 14);
  trocar_pla_mod_obrig(15, 1, 1, 15);
  trocar_pla_mod_obrig(15, 1, 1, 2);
  trocar_pla_mod_obrig(15, 1, 1, 23);
  trocar_pla_mod_obrig(15, 1, 1, 24);
  trocar_pla_mod_obrig(15, 1, 1, 3);
  trocar_pla_mod_obrig(15, 1, 1, 4);
  trocar_pla_mod_obrig(15, 1, 1, 6);
  trocar_pla_mod_obrig(15, 2, 2, 1);
  trocar_pla_mod_obrig(15, 2, 2, 11);
  trocar_pla_mod_obrig(15, 2, 2, 12);
  trocar_pla_mod_obrig(15, 2, 2, 13);
  trocar_pla_mod_obrig(15, 2, 2, 14);
  trocar_pla_mod_obrig(15, 2, 2, 15);
  trocar_pla_mod_obrig(15, 2, 2, 2);
  trocar_pla_mod_obrig(15, 2, 2, 23);
  trocar_pla_mod_obrig(15, 2, 2, 24);
  trocar_pla_mod_obrig(15, 2, 2, 3);
  trocar_pla_mod_obrig(15, 2, 2, 4);
  trocar_pla_mod_obrig(15, 2, 2, 6);
  trocar_pla_mod_obrig(15, 5, 5, 1);
  trocar_pla_mod_obrig(15, 5, 5, 12);
  trocar_pla_mod_obrig(15, 5, 5, 13);
  trocar_pla_mod_obrig(15, 5, 5, 14);
  trocar_pla_mod_obrig(15, 5, 5, 15);
  trocar_pla_mod_obrig(15, 5, 5, 2);
  trocar_pla_mod_obrig(15, 5, 5, 23);
  trocar_pla_mod_obrig(15, 5, 5, 24);
  trocar_pla_mod_obrig(15, 5, 5, 25);
  trocar_pla_mod_obrig(15, 5, 5, 3);
  trocar_pla_mod_obrig(15, 5, 5, 4);
  trocar_pla_mod_obrig(15, 5, 5, 6);
  trocar_pla_mod_obrig(20, 16, 16, 1);
  trocar_pla_mod_obrig(20, 16, 16, 11);
  trocar_pla_mod_obrig(20, 16, 16, 12);
  trocar_pla_mod_obrig(20, 16, 16, 13);
  trocar_pla_mod_obrig(20, 16, 16, 14);
  trocar_pla_mod_obrig(20, 16, 16, 15);
  trocar_pla_mod_obrig(20, 16, 16, 2);
  trocar_pla_mod_obrig(20, 16, 16, 23);
  trocar_pla_mod_obrig(20, 16, 16, 24);
  trocar_pla_mod_obrig(20, 16, 16, 25);
  trocar_pla_mod_obrig(20, 16, 16, 3);
  trocar_pla_mod_obrig(20, 16, 16, 4);
  trocar_pla_mod_obrig(20, 16, 16, 5);
  trocar_pla_mod_obrig(20, 16, 16, 6);
  trocar_pla_mod_obrig(20, 18, 18, 1);
  trocar_pla_mod_obrig(20, 18, 18, 11);
  trocar_pla_mod_obrig(20, 18, 18, 12);
  trocar_pla_mod_obrig(20, 18, 18, 13);
  trocar_pla_mod_obrig(20, 18, 18, 14);
  trocar_pla_mod_obrig(20, 18, 18, 15);
  trocar_pla_mod_obrig(20, 18, 18, 2);
  trocar_pla_mod_obrig(20, 18, 18, 23);
  trocar_pla_mod_obrig(20, 18, 18, 24);
  trocar_pla_mod_obrig(20, 18, 18, 25);
  trocar_pla_mod_obrig(20, 18, 18, 3);
  trocar_pla_mod_obrig(20, 18, 18, 4);
  trocar_pla_mod_obrig(20, 18, 18, 5);
  trocar_pla_mod_obrig(20, 18, 18, 6);
  
end;

--select count(*) from temp_log
/*select * from gp.pla_mod pm where pm.cd_modalidade = 20 and pm.cd_plano = 13 and pm.cd_tipo_plano = 13 and pm.cd_modulo = 1

select * from gp.ftpadcob ft where ft.cd_modalidade = 20 and ft.cd_plano = 13 and ft.cd_tipo_plano = 13 and ft.cd_modulo = 1

select pp.lgcoberturaobrigatoria, pp.* from gp.pro_pla pp where pp.cd_modalidade = 20 and pp.cd_plano = 13 and pp.cd_tipo_plano = 13 
and pp.cd_modulo = 1

select pc.*
  from gp.propcopa pc
 where exists (select 1
          from gp.pro_pla pp
         where pp.cd_modalidade = 20
           and pp.cd_plano = 13
           and pp.cd_tipo_plano = 13
           and pp.cd_modulo = 1
           and pc.cd_modalidade = pp.cd_modalidade
           and pc.nr_proposta = pp.nr_proposta
           and pc.cd_modulo = pp.cd_modulo)

select u.*
  from gp.usumodu u
 where exists (select 1
          from gp.pro_pla pp
         where pp.cd_modalidade = 20
           and pp.cd_plano = 13
           and pp.cd_tipo_plano = 13
           and pp.cd_modulo = 1
           and u.cd_modalidade = pp.cd_modalidade
           and u.nr_proposta = pp.nr_proposta
           and u.cd_modulo = pp.cd_modulo)
*/