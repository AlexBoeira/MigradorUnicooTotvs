-- ESSE SCRIPT NÃO FAZ PARTE DA MIGRAÇÃO PADRÃO. FOI CRIADO PARA AJUSTES PONTUAIS DURANTE O PROCESSO.
-- ATENÇÃO PARA PREENCHER NR_SEQ_PROPOST_AUX com a proposta desejada!

Declare

v integer;
nr_seq_propost_aux integer;

Cursor c is
select distinct a.CD_MODALIDADE,
                      a.CD_PLANO,
                      a.CD_TIPO_PLANO,
                      a.NR_PROPOSTA,
                      a.CD_FORMA_PAGTO,
                      a.LG_CARENCIA,
                      a.DT_ATUALIZACAO,
                      a.CD_USERID,
                      a.LG_AUTORIZACAO_GP,
                      a.LGBLOQUEIAATENDIMENTO,
                      a.INRESPONSAVELAUTORIZACAO,
                      a.DT_INICIO,
                      a.LG_BONIFICA_PENALIZA,
                      a.nr_dias,
                      a.TPPLANO,
                      a.NRCONTRATO,
                      a.DAT_PROPOST,
                      a.PARTICIP,
                      a.IN_COBRA_PARTICIPACAO,
                      a.CDCONTRATO,
                      a.REGULACAO,
                      a.VCDMODULO,
                      a.QT_CAREN_ELETIVA,
                      a.LG_OBRIGATORIO,
                      a.DAT_FIM_PROPOST,
                      a.CD_MOTIVO_CANCEL,
                      f.cd_padrao_cobertura
        from (select distinct p.cd_modalidade,
                              p.cd_plano,
                              p.cd_tipo_plano,
                              p.num_seqcial_propost nr_proposta,
                              p.cd_forma_pagto cd_forma_pagto,
                              1 lg_carencia,
                              trunc(sysdate) dt_atualizacao,
                              'MIGRACAO' cd_userid,
                              0 lg_autorizacao_gp,
                              0 lgbloqueiaatendimento,
                              'N' inresponsavelautorizacao,
                              p.dat_propost dt_inicio,
                              0 lg_bonifica_penaliza,
                              0 nr_dias,
                              p.cod_livre_5 tpplano,
                              p.num_livre_3 nrcontrato,
                              p.dat_propost,
                              decode(p.cod_livre_4, 'SEMFAT', 0, 1) particip,
                              decode(p.cod_livre_4, 'SEMFAT', 9, 1) in_cobra_participacao,
                              p.cod_livre_3 cdcontrato,
                              null regulacao,
                              dm.cdmodulo vcdmodulo,
                              (select pm.qt_caren_eletiva
                                 from gp.pla_mod pm
                                where pm.cd_modalidade = p.cd_modalidade
                                  and pm.cd_plano = p.cd_plano
                                  and pm.cd_tipo_plano = p.cd_tipo_plano
                                  and pm.cd_modulo = dm.cdmodulo) qt_caren_eletiva,
                              (select pm.lg_obrigatorio
                                 from gp.pla_mod pm
                                where pm.cd_modalidade = p.cd_modalidade
                                  and pm.cd_plano = p.cd_plano
                                  and pm.cd_tipo_plano = p.cd_tipo_plano
                                  and pm.cd_modulo = dm.cdmodulo) lg_obrigatorio,
                              p.dat_fim_propost,
                              case
                                when p.dat_fim_propost is not null then
                                 '2'--pcdmotivocancel
                                else
                                 '0'
                              end cd_motivo_cancel,
                              pd.cd_padrao_cobertura u##cd_padrao_cobertura
                from import_propost       p,
                     contrato_plano       cpl,
                     t_v_plano_padrao     pd,
                     categoria_de_servico c,
                     DEPARA_MODULO        dm
               where p.cd_modalidade = pd.cd_modalidade
                 and p.cd_plano = pd.cd_plano
                 and p.cd_tipo_plano = pd.cd_tipo_plano
                 and p.num_livre_2 = cpl.nrregistro
                 and p.num_livre_3 = cpl.nrcontrato
                 and pd.cdcontrato_usu = cpl.cdcontrato
                 and cpl.cdcontrato = c.cdcontrato
                 and dm.cdcategserv = c.cdcategserv
                 and p.num_seqcial_propost = nr_seq_propost_aux) a,
             gp.ftpadcob f
       where a.cd_modalidade = f.cd_modalidade(+)
         and a.cd_plano = f.cd_plano(+)
         and a.cd_tipo_plano = f.cd_tipo_plano(+)
         and a.u##cd_padrao_cobertura = f.u##cd_padrao_cobertura(+)
         and a.vcdmodulo = f.cd_modulo(+)
      union
      --union para levar na proposta o modulo de mensalidade
      select distinct p.cd_modalidade,
                      p.cd_plano,
                      p.cd_tipo_plano,
                      p.num_seqcial_propost nr_proposta,
                      p.cd_forma_pagto cd_forma_pagto,
                      1 lg_carencia,
                      trunc(sysdate) dt_atualizacao,
                      'MIGRACAO' cd_userid,
                      0 lg_autorizacao_gp,
                      0 lgbloqueiaatendimento,
                      'N' inresponsavelautorizacao,
                      p.dat_propost dt_inicio,
                      0 lg_bonifica_penaliza,
                      0 nr_dias,
                      p.cod_livre_5 tpplano,
                      p.num_livre_3 nrcontrato,
                      p.dat_propost,
                      decode(p.cod_livre_4, 'SEMFAT', 0, 1) particip,
                      decode(p.cod_livre_4, 'SEMFAT', 9, 1) in_cobra_participacao,
                      p.cod_livre_3 cdcontrato,
                      null regulacao,
                      TO_NUMBER('9999') vcdmodulo,
                      0 qt_caren_eletiva,
                      1 lg_obrigatorio,
                      p.dat_fim_propost,
                      case
                        when p.dat_fim_propost is not null then
                         '2'--pcdmotivocancel
                        else
                         '0'
                      end cd_motivo_cancel,
                      -- null u##cd_padrao_cobertura,
                      ta.cd_padrao_cobertura cd_padrao_cobertura
        from import_propost        p,
             temp_depara_detalhado td,
             temp_depara_agrupado  ta
       where p.num_seqcial_propost = nr_seq_propost_aux
         and p.cod_livre_3 = td.cdcontrato
         and td.cdcontrato_agr = ta.cdcontrato;
         
begin

   nr_seq_propost_aux := 1486; -- INICIALIZAR ESSA VARIÁVEL COM A PROPOSTA DESEJADA

   for v in c loop
   
    
 --     if pAOCONSID_PRIMEIRO_DIA_CARENC = 'N' then
   --     x.nr_dias := 1;
 --     end if;
    
      --     vnrseqmodpropost := import_modul_propost_seq.nextval;
    
--      select import_modul_propost_seq.nextval
--        into vnrseqmodpropost
--        from dual;
--      begin
        insert into import_modul_propost
          (num_seqcial,
           num_seqcial_propost,
           dat_ult_atualiz,
           hra_ult_atualiz,
           cod_usuar_ult_atualiz,
           cd_modulo,
           cd_forma_pagto,
           log_carenc,
           ind_respons_autoriz,
           log_cobert_obrig,
           log_cobr_particip,
           dat_inicial,
           dat_cancel,
           log_bonif_penalid,
           nr_dias,
           qt_caren_eletiva,
           qt_caren_urgencia,
           cd_motivo_cancel,
           in_ctrl_carencia_proced,
           in_ctrl_carencia_insumo,
           in_cobra_participacao,
           progress_recid)
        values
          (gp.import_modul_propost_seq.nextval, --num_seqcial,
           v.nr_proposta, --num_seqcial_propost,
           trunc(sysdate), --dat_ult_atualiz
           to_char(sysdate, 'HH:MM:SS'), --hra_ult_atualiz
           'MIGRACAO', --cod_usuar_ult_atualiz
           v.vcdmodulo, --cd_modulo,
           v.cd_forma_pagto, --cd_forma_pagto,
           1, --log_carenc,
           'N', --ind_respons_autoriz,
           v.lg_obrigatorio, --log_cobert_obrig,
           v.particip, --log_cobr_particip,
           v.dat_propost, --dat_inicial,
           v.dat_fim_propost, --dat_cancel,
           v.lg_bonifica_penaliza, --log_bonif_penalid,
           v.nr_dias, --nr_dias,
           v.qt_caren_eletiva, --qt_caren_eletiva,
           0, --qt_caren_urgencia,
           v.cd_motivo_cancel, --cd_motivo_cancel,
           1, --in_ctrl_carencia_proced,
           0, --in_ctrl_carencia_insumo,
           v.in_cobra_participacao,
           gp.import_modul_propost_seq.nextval --progress_recid
           );


   end loop;
   
end;
