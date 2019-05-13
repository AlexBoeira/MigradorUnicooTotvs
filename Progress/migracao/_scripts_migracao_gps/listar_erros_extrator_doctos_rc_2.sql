-- listar erros importacao documentos RC
select d.ind_sit_import, e.num_seqcial_control, e.des_erro, e.dat_erro, e.des_ajuda, 
d.cd_unidade, d.cd_unidade_prestadora, d.cd_transacao, d.nr_serie_doc_original, 
d.nr_doc_original, d.nr_doc_sistema, d.dt_anoref, d.nr_perref, d.log_period_unico, d.log_estorn,
d.aa_fatura, d.cd_serie_nf, d.nr_fatura, d.nr_lote, d.nr_serie_contratante, d.nr_docto_contratante,
d.cd_unidade_carteira, d.cd_carteira_usuario, d.cd_modalidade, d.nr_ter_adesao, d.cd_usuario,
d.cd_unidade_solicitante, d.cd_vinculo_solicitante, d.cd_especialid, d.cd_prestador_solicitante,
d.dt_emissao, d.cd_unidade_clinica, d.cd_clinica, d.in_local_autorizacao, d.cd_unidade_guia, d.cd_cla_hos,
d.cd_unidade_principal, d.cd_vinculo_principal, d.cd_prestador_principal, d.log_prestdor_unico, d.cd_modulo,
d.Log_Modul_Unico, d.cd_situacao_doc, d.dt_cancel_doc, d.cd_sit_cobranca, d.cd_sit_pagto, d.nr_ult_processo,
d.nr_ult_seq_digitacao, d.dt_digitacao, d.hr_digitacao, d.log_guia, d.cd_motivo_cancelamento, d.cd_motivo_alta, 
d.cd_cid, d.dt_internacao, d.dt_alta, d.aa_guia_atendimento, d.nr_guia_atendimento, d.nr_via_carteira, 
d.cd_unidade_imp, d.cd_prestador_imp, d.nr_lote_imp, d.nr_sequencia_imp, d.aa_guia_origem, d.nr_guia_origem,
d.cd_local_atendimento, d.hr_internacao, d.hr_alta, d.nr_lote_notas, d.cd_cid1, d.cd_cid2, d.cd_cid3,
d.log_libera_faturam, d.tp_consulta, d.nom_profis_solic, d.cd_cons_prof_sol, d.nr_cons_prof_sol, d.nr_cons_prof_sol,
d.uf_conselho, d.cd_esp_prof_sol, d.des_indcao_clinic, d.tp_doenca, d.ind_tempo_doenc, d.in_acidente,
d.tp_saida, d.ind_carac_solicit, d.tp_saida_sadt, d.tp_atend, d.ind_carac_intrcao, d.tp_inter, d.tp_acomod,
d.log_gestac, d.log_aborto, d.log_transt_materno_gestac, d.log_complic_period_puerp, d.log_atendim_rn_sala_parto,
d.log_complic_neonat, d.log_bxo_peso, d.log_parto_cesar, d.nom_decla_nasc_vivo, d.qti_nasc_vivo_termo,
d.qti_nasc_vivo_premat, d.qti_nasc_morto, d.cd_obt_mul, d.qt_obt_neo_prec, d.qt_obt_neo_tar, d.cd_cid_obito,
d.num_decla_obit, d.cd_faturamento, d.cod_decla_nasc_vivo_2, d.cod_decla_nasc_vivo_3, d.dt_termino_tratamento,
d.cod_fatur_ap, d.nr_guia_prestador
  from gp.erro_process_import e, gp.import_docto_revis_ctas d
 where e.num_seqcial_control = d.num_seqcial_control
   and d.ind_sit_import = 'ER';
