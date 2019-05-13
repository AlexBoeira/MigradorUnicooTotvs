prompt PL/SQL Developer import file
prompt Created on quinta-feira, 12 de maio de 2016 by vinicius.justino
set feedback off
set define off
prompt Disabling triggers for TM_SEQUENCES...
alter table TM_SEQUENCES disable all triggers;
prompt Deleting TM_SEQUENCES...
delete from TM_SEQUENCES;
commit;
prompt Loading TM_SEQUENCES...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESSOA', 'PESSOA_FISICA', 'ID_PESSOA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESSOA', 'PESSOA_JUIRDICA', 'ID_PESSOA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESSOA_SIMUL', 'PESSOA_FISIC_SIMUL', 'ID_PESSOA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESSOA_SIMUL', 'PESSOA_JUIRDIC_SIMUL', 'ID_PESSOA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_CAD', 'AUDIT_CAD', 'ID_AUDIT_CAD');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CONFIG_AUDIT_CAD', 'CONDIG_AUDIT_CAD', 'ID_CONFIG_AUDIT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CONTAT_PESSOA_SIMUL', 'CONTAT_PESSOA_SIMUL', 'ID_CONTATO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CONTATO_PESSOA', 'CONTATO_PESSOA', 'ID_PESSOA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CONTRAT_SIMUL', 'CONTRAT_SIMUL', 'IDI_CONTRAT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_ENDERECO', 'ENDERECO', 'ID_ENDERECO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HIST_ALTER_GP', 'HIST_ALTER_GP', 'ID_HIST_ALTER');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HIST_MOVTO', 'HIST_MOVTO', 'ID_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HIST_VISITA', 'HIST_VISITA', 'ID_HIST_VISITA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HISTOR_RPC_HEADER', 'HISTOR_RPC_HEADER', 'IDI_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HISTOR_RPC_JUSTIF', 'HISTOR_RPC_JUSTIF', 'IDI_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HISTOR_RPC_PLANO', 'HISTOR_RPC_PLANO', 'IDI_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HISTOR_RPC_VAL', 'HISTOR_RPC_VAL', 'IDI_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HISTOR_SIMUL_PROPOST', 'HISTOR_SIMUL_PROPOST', 'ID_HISTOR_SIMUL');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MWCINPUT', 'MWCINPUT', 'MWCINPUTID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_REFERENCIA_CONTRAT', 'REFERENCIA_CONTRAT', 'ID_REFERENCIA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_REG_PLANO_SAUDE', 'REG_PLANO_SAUDE', 'IDI_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_REG_PLANO_SAUDE_VAL', 'REG_PLANO_SAUDE_VAL', 'IDI_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_ANEXO', 'ANEXO', 'CDD_ANEXO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_ASSOCVA_CIDAD_EMPRES_ESTAB', 'ASSOCVA_CIDAD_EMPRES_ESTAB', 'CDN_CIDAD_EMPRES_ESTAB');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_CANCEL_CONTRAT', 'AUDIT_CANCEL_CONTRAT', 'CDD_AUDIT_CANCEL_CONTRAT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_EXC_BNFCIAR', 'AUDIT_EXC_BNFCIAR', 'CDD_AUDIT_EXC_BNFCIAR');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_REATIV', 'AUDIT_REATIV', 'CDD_AUDIT_REATIV');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_SEGNDA_VIA_CONTRAT', 'AUDIT_SEGNDA_VIA_CONTRAT', 'CDD_AUDIT_SEG_VIA_CONTRAT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_SEGURO_ASSISTAL', 'AUDIT_SEGURO_ASSISTAL', 'CDD_AUDIT_SEGURO_ASSISTAL');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_AUDIT_TRANSF_BNFCIAR', 'AUDIT_TRANSF_BNFCIAR', 'CDD_TRANSF_BNFCIAR');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CALEND_ATENDIM', 'HMR_CALEND_ATENDIM', 'CDN_CALEND_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CALEND_ATENDIM_DIA', 'HMR_CALEND_ATENDIM_DIA', 'CDN_CALEND_ATENDIM_DIA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CALEND_TURNO', 'HMR_CALEND_TURNO', 'CDN_CALEND_TURNO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CAMPO_CONTROL_PROCESSO', 'CAMPO_CONTROL_PROCES', 'CDD_CAMPO_CONTROL_PROCES');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CAMPO_REGRA_AUDIT', 'CAMPO_REGRA_AUDIT', 'CDD_CAMPO_REGRA_AUDIT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CANCEL_CONTRAT_BNFCIAR', 'CANCEL_CONTRAT_BNFCIAR', 'CDD_CANCEL_CONTRAT_BNFCIAR');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CATEG_ATENDIM', 'HMR_CATEG_ATENDIM', 'CDN_CATEG_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CATEG_BASE_CONHECTO', 'HMR_CATEG_BASE_CONHECTO', 'CDN_CATEG_BASE_CONHECTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CHAMADO', 'CHAMADO', 'ID_CHAMADO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CHAMADO_ATENDIM', 'HMR_CHAMADO_ATENDIM', 'CDN_CHAMADO_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_CONFIG_OBRIG_ANEXO', 'CONFIG_OBRIG_ANEXO', 'CDD_CONFIG_OBRIG_ANEXO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_DOCTO_BASE_CONHECTO', 'HMR_DOCTO_BASE_CONHECTO', 'CDN_DOCTO_BASE_CONHECTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_EXC_BNFCIAR_SELEC', 'EXC_BNFCIAR_SELEC', 'CDD_EXC_BNFCIAR_SELEC');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GRP_ATENDIM', 'HMR_GRP_ATENDIM', 'CDN_GRP_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GRP_ATENDIM_CALEND', 'HMR_GRP_ATENDIM_CALEND', 'CDN_GRP_ATENDIM_CALEND');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GRP_ATENDIM_CONTRNTE', 'HMR_GRP_ATENDIM_CONTRNTE', 'CDN_GRP_ATENDIM_CONTRNTE');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GRP_ATENDIM_MOTIV', 'HMR_GRP_ATENDIM_MOTIV', 'CDN_GRP_ATENDIM_MOTIV');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GRP_ATENDIM_PERMIS', 'HMR_GRP_ATENDIM_PERMIS', 'CDN_GRP_ATENDIM_PERMIS');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GRUPO_ATENDIMENTO', 'GRUPO_ATENDIMENTO', 'ID_GRUPO_ATENDIMENTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GUIAUTOR', 'GUIAUTOR', 'NR_GUIA_ATENDIMENTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HORARIO_ATENDIMENTO', 'HORARIO_ATENDIMENTO', 'ID_HORARIO_ATENDIMENTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_IMPRES_DIGITAL_PESSOA', 'IMPRES_DIGITAL_PESSOA', 'IDI_SEQ');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MOTIV_ATENDIM', 'HMR_MOTIV_ATENDIM', 'CDN_MOTIV_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MOTIV_CANCEL_ATENDIM', 'HMR_MOTIV_CANCEL_ATENDIM', 'CDN_MOTIV_CANCEL_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MSG_ATENDIM', 'HMR_MSG_ATENDIM', 'CDN_MSG_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MSG_ATENDIM_CONTRNTE', 'HMR_MSG_ATENDIM_CONTRNTE', 'CDN_MSG_ATENDIM_CONTRNTE');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MSG_ATENDIM_GRP_ATENDIM', 'HMR_MSG_ATENDIM_GRP_ATENDIM', 'CDN_MSG_ATENDIM_GRP_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MSG_CADAST', 'MSG_CADAST', 'CDD_MSG_CADAST');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PERC_DEF_AUDIT', 'PERC_DEF_AUDIT', 'CDD_DEF_AUDIT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PERG_PESQ_MOTIV_ATENDIM', 'HMR_PERG_PESQ_MOTIV_ATENDIM', 'CDN_PERG_PESQ_MOTIV_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PERG_PESQ_SATISFAC', 'HMR_PERG_PESQ_SATISFAC', 'CDN_PERG_PESQ_SATISFAC');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PERMIS_INFORM_CONTRNTE', 'HMR_PERMIS_INFORM_CONTRNTE', 'CDN_PERMIS_INFORM_CONTRNTE');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PERMISSAO_INF_AD', 'PERMISSAO_INF_AD', 'ID_PERMISSAO_INF_AD');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESQ_SATISFAC', 'HMR_PESQ_SATISFAC', 'CDN_PESQ_SATISFAC');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESQ_SATISFAC_REALIZ', 'HMR_PESQ_SATISFAC_REALIZ', 'CDN_PESQ_SATISFAC_REALIZ');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESQUISA_PERGUNTA', 'PESQUISA_PERGUNTA', 'ID_PESQUISA_PERGUNTA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_PESQUISA_SATISFACAO', 'PESQUISA_SATISFACAO', 'ID_PESQUISA_SATISFACAO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_REATIV_BNFCIAR_CONTRAT', 'REATIV_BNFCIAR_CONTRAT', 'CDD_REATIV_BNFCIAR_CONTRAT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_REGRA_AUDIT', 'REGRA_AUDIT', 'CDD_REGRA_AUDIT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_REGRA_UNIF', 'REGRA_UNIF', 'IDI_REGRA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SEQ_CHAMADO_ATENDIM', 'HMR_SEQ_CHAMADO_ATENDIM', 'CDN_SEQ_CHAMADO_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SEQUENCIA_CHAMADO', 'SEQUENCIA_CHAMADO', 'ID_SEQUENCIA_CHAMADO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIB_MOVIMENTACAO', 'SIB_MOVIMENTACAO', 'ID_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIB_REMESSA', 'SIB_REMESSA', 'ID_REGISTRO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIMUL_PROPOST', 'SIMULA_PROPOSTA', 'ID_SIMULA_PROPOSTA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIMULA_BENEF', 'SIMULA_BENEF', 'ID_SIMULA_BENEF');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIMULA_OPCIONAIS', 'SIMULA_OPCIONAIS', 'ID_SIMULA_OPCIONAIS');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIMULA_PROPOSTA', 'SIMULA_PROPOSTA', 'ID_SIMULA_PROPOSTA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SKTSAIDA', 'SKTSAIDA', 'NR_SEQUENCIA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TAR_AUDIT', 'TAR_AUDIT', 'CDD_TAR_AUDIT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TAR_AUDIT_MOVTO', 'TAR_AUDIT_MOVTO', 'CDD_TAR_AUDIT_MOVTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TIP_ANEXO', 'TIP_ANEXO', 'CDN_TIP_ANEXO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TOPIC_BASE_CONHECTO', 'HMR_TOPIC_BASE_CONHECTO', 'CDN_TOPIC_BASE_CONHECTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TOPIC_GRP_ATENDIM', 'HMR_TOPIC_GRP_ATENDIM', 'CDN_TOPIC_GRP_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TRANSF_BNFCIAR_SELEC', 'TRANSF_BNFCIAR_SELEC', 'CDD_TRANSF_BNFCIAR_SELEC');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_TURNO_ATENDIM', 'HMR_TURNO_ATENDIM', 'CDN_TURNO_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_USUAR_ATEND', 'HMR_USUAR_ATEND', 'CDN_USUAR_ATEND');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_USUAR_ATENDIM', 'HMR_USUAR_ATENDIM', 'CDN_USUAR_ATENDIM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_USUAR_EXPORT', 'USUAR_EXPORT', 'CDD_USUAR_EXPORT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_USUAR_SIMUL', 'USUAR_SIMUL', 'IDI_USUARIO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_USUARIO_ATENDIMENTO', 'USUARIO_ATENDIMENTO', 'ID_USUARIO_ATENDIMENTO');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_VISITA', 'VISITA', 'ID_VISITA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_DOCTO_GERAL', 'DOCTO_GERAL', 'IDI_DOCTO_GERAL');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_GESTOR_MSG', 'GESTOR_MSG', 'IDI_GESTOR_MSG');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_JUSTIF_ACES_BIOM_CARTAO', 'USTIF_ACES_BIOM_CARTAO', 'IDI_JUSTIF_ACES_BIOM');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MSG_GUIA_AUDIT', 'MSG_GUIA_AUDIT', 'IDI_MSG_GUIA_AUDIT');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_MSG_GUIA_DOCTO_GERAL', 'MSG_GUIA_DOCTO_GERAL', 'IDI_MSG_GUIA_DOCTO_GERAL');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_HIST_APROV_PROPOSTA', 'HIST_APROV_PROPOSTA', 'ID_HIST_APROV_PROPOSTA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQ_SIT_APROV_PROPOSTA', 'SIT_APROV_PROPOSTA', 'ID_SIT_APROV_PROPOSTA');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_MENSLID_PROPOST_SEQ', 'REGRA_MENSLID_PROPOST', 'PROGRESS_RECID');
commit;
prompt 100 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENT_PO_DET_PAGTO_SEQ', 'EVENT_PO_DET_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENT_DET_PAGTO_SEQ', 'EVENT_DET_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_PERC_SEQ', 'REGRA_PERC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_ERRO_IMPORT_MOVTO_SEQ', 'HISTOR_ERRO_IMPORT_MOVTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUBST_PRESTDOR_EXCD_SEQ', 'SUBST_PRESTDOR_EXCD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_MENSLID_REAJ_SEQ', 'REGRA_MENSLID_REAJ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_MENSLID_ESTRUT_SEQ', 'REGRA_MENSLID_ESTRUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_MENSLID_CRITER_SEQ', 'REGRA_MENSLID_CRITER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_MENSLID_SEQ', 'REGRA_MENSLID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSLID_REAJ_HISTOR_SEQ', 'MENSLID_REAJ_HISTOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSLID_ESTRUT_HISTOR_SEQ', 'MENSLID_ESTRUT_HISTOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSLID_CRITER_HISTOR_SEQ', 'MENSLID_CRITER_HISTOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_PRECO_BENEF_MODUL_SEQ', 'HISTOR_PRECO_BENEF_MODUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERC_HISTOR_IMPUG_SEQ', 'PERC_HISTOR_IMPUG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_AREA_ESPECIALID_SEQ', 'PRESTDOR_AREA_ESPECIALID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_AREA_ATUAC_SEQ', 'PRESTDOR_AREA_ATUAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_IMPORT_LOTE_GUIA_SEQ', 'PARAM_IMPORT_LOTE_GUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LAYOUT_RELAT_SEQ', 'LAYOUT_RELAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_OBS_GUIA_SEQ', 'HISTOR_OBS_GUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAMPOS_LAYOUT_RELAT_SEQ', 'CAMPOS_LAYOUT_RELAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQCIAL_NF_SEQ', 'SEQCIAL_NF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_PROCED_MONIT_ANS_SEQ', 'MOVTO_PROCED_MONIT_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_INSUMO_MONIT_ANS_SEQ', 'MOVTO_INSUMO_MONIT_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERRO_MOVTO_MONIT_ANS_SEQ', 'ERRO_MOVTO_MONIT_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_MONIT_ANS_SEQ', 'DOCTO_MONIT_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTROL_REG_MONIT_ANS_SEQ', 'CONTROL_REG_MONIT_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_PERC_ERRO_SEQ', 'REGRA_PERC_ERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_INCL_EXC_SEQ', 'REGRA_INCL_EXC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_REGRA_PERC_ERRO_SEQ', 'ORD_REGRA_PERC_ERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_MOVTO_PROCED_SEQ', 'IMPORT_MOVTO_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_MOVTO_INSUMO_SEQ', 'IMPORT_MOVTO_INSUMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_MOVTO_GLOSA_SEQ', 'IMPORT_MOVTO_GLOSA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_SADT_SEQ', 'IMPORT_GUIA_SADT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_PRORROG_SEQ', 'IMPORT_GUIA_PRORROG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_ODONTO_SEQ', 'IMPORT_GUIA_ODONTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_MOVTO_SEQ', 'IMPORT_GUIA_MOVTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_INTRCAO_SEQ', 'IMPORT_GUIA_INTRCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_HISTOR_SEQ', 'IMPORT_GUIA_HISTOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_SEQ', 'IMPORT_GUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_DOCTO_REVIS_CTAS_SEQ', 'IMPORT_DOCTO_REVIS_CTAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_CONTRNTE_SEQ', 'IMPORT_CONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ANEXO_SOLICIT_SEQ', 'IMPORT_ANEXO_SOLICIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ANEXO_RADIO_SEQ', 'IMPORT_ANEXO_RADIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ANEXO_QUIMIO_SEQ', 'IMPORT_ANEXO_QUIMIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ANEXO_OPME_SEQ', 'IMPORT_ANEXO_OPME', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ANEXO_ODONTO_MOV_SEQ', 'IMPORT_ANEXO_ODONTO_MOV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ANEXO_ODONTO_SEQ', 'IMPORT_ANEXO_ODONTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIT_REEMBOL_SEQ', 'TIT_REEMBOL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOCVACONVERMOVTOSUSS_SEQ', 'ASSOCVACONVERMOVTOSUSS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_ANEXO_MOTIV_SEQ', 'DOCTO_ANEXO_MOTIV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABIPRINCPROCREGISTRO_SEQ', 'ABIPRINCPROCREGISTRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PEND_AUDIT_DECLA_SAUDE_SEQ', 'PEND_AUDIT_DECLA_SAUDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATOR_PADR_COBERT_MODUL_SEQ', 'FATOR_PADR_COBERT_MODUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_MOVIPTMP_SEQ', 'HISTOR_MOVIPTMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_MOV_ITMP_SEQ', 'HISTOR_MOV_ITMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_DOCRETMP_SEQ', 'HISTOR_DOCRETMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABIPRINCPROCMOTIVORADAP_SEQ', 'ABIPRINCPROCMOTIVORADAP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABIPRINCPROCMOTIVOOBS_SEQ', 'ABIPRINCPROCMOTIVOOBS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABIPRINCPROCMOTIVOJUSTIF_SEQ', 'ABIPRINCPROCMOTIVOJUSTIF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_PERC_HISTOR_IMPUG_SEQ', 'ABI_PERC_HISTOR_IMPUG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_MOTIVO_DESCRICAO_SEQ', 'ABI_MOTIVO_DESCRICAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_MOTIVO_SEQ', 'ABI_MOTIVO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_JUSTIF_DESCRICAO_SEQ', 'ABI_JUSTIF_DESCRICAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABIESPECPROCREGISTRO_SEQ', 'ABIESPECPROCREGISTRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_CABECALHO_SEQ', 'ABI_CABECALHO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RET_BNFCIAR_MOVTO_PTU_SEQ', 'RET_BNFCIAR_MOVTO_PTU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTE_MOVTO_IMPORT_PTU_SEQ', 'LOTE_MOVTO_IMPORT_PTU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_MO_PROPOST_SEQ', 'IMPORT_MO_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_IMPTO_CONTRNTE_SEQ', 'IMPORT_IMPTO_CONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_FUNCAO_PROPOST_SEQ', 'IMPORT_FUNCAO_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_FAIXA_PROPOST_SEQ', 'IMPORT_FAIXA_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_COBERT_BNFCIAR_SEQ', 'IMPORT_COBERT_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_CAMPOS_PROPOST_SEQ', 'IMPORT_CAMPOS_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLAS_EVENT_SEQ', 'CLAS_EVENT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_BOLETO_SEQ', 'PARAM_BOLETO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MSG_TIP_BOLETO_SEQ', 'MSG_TIP_BOLETO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MSG_BOLETO_SEQ', 'MSG_BOLETO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATORMENSLIDMODULPRODUT_SEQ', 'FATORMENSLIDMODULPRODUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATOR_MENSLID_CONTRAT_SEQ', 'FATOR_MENSLID_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONFIG_LAYOUT_SEQ', 'CONFIG_LAYOUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONFIG_FINANC_BOLETO_SEQ', 'CONFIG_FINANC_BOLETO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BOLETO_SEQ', 'BOLETO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_CONFIG_LAYOUT_SEQ', 'ANEXO_CONFIG_LAYOUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_BOLETO_SEQ', 'ANEXO_BOLETO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_FORMUL_SEQ', 'PRESTDOR_FORMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FORMUL_PAGTO_PRESTDOR_SEQ', 'FORMUL_PAGTO_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONVER_EVENT_SEQ', 'CONVER_EVENT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTROL_IMPORT_CARG_XML_SEQ', 'CONTROL_IMPORT_CARG_XML', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONFIG_OBRIG_ANEXO_SEQ', 'CONFIG_OBRIG_ANEXO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_PRINC_PROC_MOTIVO_SEQ', 'ABI_PRINC_PROC_MOTIVO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROM_FATURAM_SEQ', 'PROM_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_DESC_MENSLID_SEQ', 'REGRA_DESC_MENSLID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMZCAO_JUROS_MULTA_SEQ', 'PARAMZCAO_JUROS_MULTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ITEM_DESC_MENSLID_SEQ', 'ITEM_DESC_MENSLID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATUR_JUROS_MULTA_SEQ', 'FATUR_JUROS_MULTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EXCEC_JUROS_MULTA_SEQ', 'EXCEC_JUROS_MULTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENT_DESC_MENSLID_SEQ', 'EVENT_DESC_MENSLID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTRUT_DESC_MENSLID_SEQ', 'ESTRUT_DESC_MENSLID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VALORIZ_NIV_PARTICIP_SEQ', 'VALORIZ_NIV_PARTICIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTE_EXPORT_MONIT_ANS_SEQ', 'LOTE_EXPORT_MONIT_ANS', 'PROGRESS_RECID');
commit;
prompt 200 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_INCONSIST_PAGTO_SEQ', 'MOVIMEN_INCONSIST_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_NEGD_RADIO_SEQ', 'GUIA_NEGD_RADIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_NEGD_QUIMIO_SEQ', 'GUIA_NEGD_QUIMIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTAG_BNFCIAR_SEQ', 'CONTAG_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_TAXAS_SEQ', 'PROCED_TAXAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_BASE_CONHECTO_SEQ', 'HMR_BASE_CONHECTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARENC_PRO_SEQ', 'CARENC_PRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCESS_REFER_100_SEQ', 'PROCESS_REFER_100', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SKTSAIDA_SEQ', 'SKTSAIDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_EXC_BNFCIAR_SEQ', 'HISTOR_EXC_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_SEGNDA_VIA_CONTRAT_SEQ', 'AUDIT_SEGNDA_VIA_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MSG_CADAST_SEQ', 'MSG_CADAST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NOTA_FISC_PRESTDOR_SEQ', 'NOTA_FISC_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTE_IMPORT_COMPLTAR_SEQ', 'LOTE_IMPORT_COMPLTAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTE_EXPORT_COMPLTAR_SEQ', 'LOTE_EXPORT_COMPLTAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_SEGURO_ASSISTAL_SEQ', 'AUDIT_SEGURO_ASSISTAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_HORA_SEQ', 'TIP_HORA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_CX_UNICO_SEQ', 'PRESTDOR_CX_UNICO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_ASSOC_CX_UNICO_SEQ', 'PRESTDOR_ASSOC_CX_UNICO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HORA_PLANT_PRESTDOR_SEQ', 'HORA_PLANT_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWSESSAOWEB_SEQ', 'SWSESSAOWEB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWIDESES_SEQ', 'SWIDESES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REG_ANALIS_CUST_ANEXO_SEQ', 'REG_ANALIS_CUST_ANEXO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REG_ANALIS_CUST_SEQ', 'REG_ANALIS_CUST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_GUIA_COMP_SEQ', 'PROCED_GUIA_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_PROCED_COMPL_SEQ', 'MOVIMEN_PROCED_COMPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_PAGTO_SEQ', 'MOVIMEN_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMENINSUMOTMPCOMP_SEQ', 'MOVIMENINSUMOTMPCOMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_INSUMO_COMP_SEQ', 'MOVIMEN_INSUMO_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUMO_UTLZAD_COMP_SEQ', 'INSUMO_UTLZAD_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUMO_GUIA_COMP_SEQ', 'INSUMO_GUIA_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_AUTORIZ_COMP_SEQ', 'GUIA_AUTORIZ_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_UTLZAD_COMP_SEQ', 'DOCTO_UTLZAD_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_REVIS_TMP_COMP_SEQ', 'DOCTO_REVIS_TMP_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_REVIS_CTAS_COMP_SEQ', 'DOCTO_REVIS_CTAS_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMP_REPAS_PFIS_SEQ', 'TMP_REPAS_PFIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMP_PRODUT_PFIS_SEQ', 'TMP_PRODUT_PFIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUAR_SIT_SIMUL_SEQ', 'USUAR_SIT_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_VIA_ADMINIST_SEQ', 'TISS_VIA_ADMINIST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_UNID_MEDID_SEQ', 'TISS_UNID_MEDID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_VIA_SEQ', 'TISS_TIP_VIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_QUI_SEQ', 'TISS_TIP_QUI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_INTRCAO_SEQ', 'TISS_TIP_INTRCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_FATURAM_SEQ', 'TISS_TIP_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_CON_SEQ', 'TISS_TIP_CON', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISSTIPATENDIMODONTO_SEQ', 'TISSTIPATENDIMODONTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_ATENDIM_SEQ', 'TISS_TIP_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TIP_ACOMODA_SEQ', 'TISS_TIP_ACOMODA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_TEC_UTILIZA_SEQ', 'TISS_TEC_UTILIZA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_SIT_INICIAL_SEQ', 'TISS_SIT_INICIAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_REGIM_INTRCAO_SEQ', 'TISS_REGIM_INTRCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_REGIAO_BUCAL_SEQ', 'TISS_REGIAO_BUCAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_INDIC_ACID_SEQ', 'TISS_INDIC_ACID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_FINALID_TRATAM_SEQ', 'TISS_FINALID_TRATAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_FACE_DENTE_SEQ', 'TISS_FACE_DENTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_ESTDIA_SEQ', 'TISS_ESTDIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISSESCALCAPACFUNCNAL_SEQ', 'TISSESCALCAPACFUNCNAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_DIAG_IMG_SEQ', 'TISS_DIAG_IMG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_DENTE_SEQ', 'TISS_DENTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_ASSOC_TIP_DESPES_SEQ', 'TISS_ASSOC_TIP_DESPES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_ASSOC_TERMO_DB_CR_SEQ', 'TISS_ASSOC_TERMO_DB_CR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISSASSOCSTATUSSOLIC_SEQ', 'TISSASSOCSTATUSSOLIC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_ASSOC_STATUS_LOTE_SEQ', 'TISS_ASSOC_STATUS_LOTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_ASSOC_MOTIV_ALTA_SEQ', 'TISS_ASSOC_MOTIV_ALTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISSASSOCINSUMOACOMODA_SEQ', 'TISSASSOCINSUMOACOMODA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISSASSOCFORMAPAGTOAPB_SEQ', 'TISSASSOCFORMAPAGTOAPB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_ASSOC_EVENT_SAUDE_SEQ', 'TISS_ASSOC_EVENT_SAUDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEXT_LAYOUT_MODUL_SEQ', 'TEXT_LAYOUT_MODUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEXT_LAYOUT_SEQ', 'TEXT_LAYOUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TAB_PAI_FILHO_SEQ', 'TAB_PAI_FILHO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_AUDIT_SEQ', 'REGRA_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_PADR_SEQ', 'PROCED_PADR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_OBS_SEQ', 'PRESTDOR_OBS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_LOG_ACES_SEQ', 'PRESTDOR_LOG_ACES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERC_DEF_AUDIT_SEQ', 'PERC_DEF_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NIV_PRESTDOR_TISS_SEQ', 'NIV_PRESTDOR_TISS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAMPO_REGRA_AUDIT_SEQ', 'CAMPO_REGRA_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAMPO_CONTROL_PROCES_SEQ', 'CAMPO_CONTROL_PROCES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CADASTROPROCESWORKFLOW_SEQ', 'CADASTROPROCESWORKFLOW', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BIOM_PRESTDOR_SEQ', 'BIOM_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PADR_COBR_PLANO_ANS_SEQ', 'PADR_COBR_PLANO_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZCIDADE_SEQ', 'DZCIDADE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZ_CADCEP_SEQ', 'DZ_CADCEP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_PROCED_CALC_SEQ', 'MOVIMEN_PROCED_CALC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_GERAL_SEQ', 'DOCTO_GERAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_SEQ', 'ANEXO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAVPMC_SEQ', 'PARAVPMC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_PROCED_GENER_SEQ', 'HISTOR_PROCED_GENER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_OPCNAL_CAMPANHA_SEQ', 'MODUL_OPCNAL_CAMPANHA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARTA_FATUR_BENEF_SEQ', 'CARTA_FATUR_BENEF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARTA_FATUR_SEQ', 'CARTA_FATUR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAMPANHA_VENDAS_SEQ', 'CAMPANHA_VENDAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_INSUMO_CALC_SEQ', 'MOVIMEN_INSUMO_CALC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_PARTICIP_ESCALNDA_SEQ', 'MOVTO_PARTICIP_ESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISREGRAPARTICESCALNDA_SEQ', 'HISREGRAPARTICESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_PARTICIP_ESCALNDA_SEQ', 'REGRA_PARTICIP_ESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISMOVTOPARTICESCALNDA_SEQ', 'HISMOVTOPARTICESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISACUMPARTICIPESCALNDA_SEQ', 'HISACUMPARTICIPESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTOACUMPARTICESCALNDA_SEQ', 'MOVTOACUMPARTICESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_PARTICIP_ESCALNDA_SEQ', 'MODUL_PARTICIP_ESCALNDA', 'PROGRESS_RECID');
commit;
prompt 300 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISMODULPARTICESCALNDA_SEQ', 'HISMODULPARTICESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZIMPOSTO_SEQ', 'DZIMPOSTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_QUANTTIVO_TECN_SEQ', 'REGRA_QUANTTIVO_TECN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMNF_SEQ', 'PARAMNF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RESERVA_GUIA_AUTORIZ_SEQ', 'RESERVA_GUIA_AUTORIZ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SENHA_ATENDIM_SEM_BIOM_SEQ', 'SENHA_ATENDIM_SEM_BIOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_VARIAC_SEQ', 'PROCED_VARIAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMENPROCEDDESPESANS_SEQ', 'MOVIMENPROCEDDESPESANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMENINSUMODESPESANS_SEQ', 'MOVIMENINSUMODESPESANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_EXTRA_DESPES_ANS_SEQ', 'MOVIMEN_EXTRA_DESPES_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GERAC_DADOS_SIP_SEQ', 'GERAC_DADOS_SIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERRO_GERAC_DADOS_SIP_SEQ', 'ERRO_GERAC_DADOS_SIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NOTAPRES_SEQ', 'NOTAPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UTILIZ_QUANTTIVO_TECN_SEQ', 'UTILIZ_QUANTTIVO_TECN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_UTILIZ_MOVTO_SEQ', 'HISTOR_UTILIZ_MOVTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISUTILIZQUANTTIVOTECN_SEQ', 'HISUTILIZQUANTTIVOTECN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISFAIXAPARTICESCALNDA_SEQ', 'HISFAIXAPARTICESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FAIXA_PARTICIP_ESCALNDA_SEQ', 'FAIXA_PARTICIP_ESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ACUMUL_PARTICIP_ESCALNDA_SEQ', 'ACUMUL_PARTICIP_ESCALNDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PIPRESTA_SEQ', 'PIPRESTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VALID_PROCED_SEQ', 'VALID_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANS_AGRUP_SEQ', 'TRANS_AGRUP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TOTALIZ_QUANTTIVO_TECN_SEQ', 'TOTALIZ_QUANTTIVO_TECN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMP_IMPORT_PROCED_SEQ', 'TMP_IMPORT_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRAQUANTTIVOTECNTRANS_SEQ', 'REGRAQUANTTIVOTECNTRANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_ANEST_SEQ', 'PROCED_ANEST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PORTE_ROL_PROCED_SEQ', 'PORTE_ROL_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMRC_SEQ', 'PARAMRC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_SIP_SEQ', 'PARAM_SIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('JUSTIF_AUTORIZ_PROCED_SEQ', 'JUSTIF_AUTORIZ_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_PROPOST_SEQ', 'IMPORT_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORTPADRCOBERTPROPOST_SEQ', 'IMPORTPADRCOBERTPROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_MODUL_PROPOST_SEQ', 'IMPORT_MODUL_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_GUIA_CON_SEQ', 'IMPORT_GUIA_CON', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_BNFCIAR_SEQ', 'IMPORT_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_TOTALIZ_QUANTTIVO_SEQ', 'HISTOR_TOTALIZ_QUANTTIVO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_REGRA_QUANTTIVO_SEQ', 'HISTOR_REGRA_QUANTTIVO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_TRANS_SEQ', 'GRP_TRANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERRO_PROCESS_IMPORT_SEQ', 'ERRO_PROCESS_IMPORT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTROL_MIGRAC_SEQ', 'CONTROL_MIGRAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CADASTRO_DESPES_ANS_SEQ', 'CADASTRO_DESPES_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REAJ_RETROAT_PARC_SEQ', 'REAJ_RETROAT_PARC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPUG_DOCTO_MOTIV_SEQ', 'IMPUG_DOCTO_MOTIV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTRAT_SEQ', 'CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_MOVIMPUG_SEQ', 'ABI_MOVIMPUG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABIATENDIMENTOREGISTRO_SEQ', 'ABIATENDIMENTOREGISTRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_PARAM_FATURAM_SEQ', 'HISTOR_PARAM_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_FATUR_DESMEMBR_SEQ', 'MOVIMEN_FATUR_DESMEMBR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_DESMEMBR_FATUR_SEQ', 'HISTOR_DESMEMBR_FATUR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESMEMBR_FATUR_SEQ', 'DESMEMBR_FATUR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOCPROPOSTGRAUDEPEND_SEQ', 'ASSOCPROPOSTGRAUDEPEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REAJ_CONTRNTE_ORIG_SEQ', 'REAJ_CONTRNTE_ORIG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTORREAJCONTRNTEORIG_SEQ', 'HISTORREAJCONTRNTEORIG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_UPS_TOTAL_SEQ', 'ABI_UPS_TOTAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_UPS_REGISTRO_SEQ', 'ABI_UPS_REGISTRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_SITUACAO_SEQ', 'ABI_SITUACAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_NATURE_SEQ', 'ABI_NATURE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_JUSTIF_SEQ', 'ABI_JUSTIF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_GESTOR_TOTAL_SEQ', 'ABI_GESTOR_TOTAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_GESTOR_REGISTRO_SEQ', 'ABI_GESTOR_REGISTRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMSOLICITDECLASAUDE_SEQ', 'PARAMSOLICITDECLASAUDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_PROCED_PROPOST_SEQ', 'IMPORT_PROCED_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_NEGOCIAC_PROPOST_SEQ', 'IMPORT_NEGOCIAC_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_NEGOCIAC_BNFCIAR_SEQ', 'IMPORT_NEGOCIAC_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_MODUL_BNFCIAR_SEQ', 'IMPORT_MODUL_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPORT_ATENDIM_BNFCIAR_SEQ', 'IMPORT_ATENDIM_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_USUAR_FATURAM_SEQ', 'GRP_USUAR_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATURA_SEQ', 'HISTOR_FATURA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEMONSTCTBLPRESTDORERRO_SEQ', 'DEMONSTCTBLPRESTDORERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPOST_SEQ', 'PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIV_DEMIS_SEQ', 'MOTIV_DEMIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EXC_BNFCIAR_SELEC_SEQ', 'EXC_BNFCIAR_SELEC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_TRANSF_BNFCIAR_SEQ', 'AUDIT_TRANSF_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_SAIDA_SEQ', 'ABI_SAIDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_PARAMETROS_SEQ', 'ABI_PARAMETROS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_IMPUGNADO_SEQ', 'ABI_IMPUGNADO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_IMPUGDOCS_SEQ', 'ABI_IMPUGDOCS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_GUIA_REC_UNIAO_SEQ', 'ABI_GUIA_REC_UNIAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_DOCTO_ANEXO_SEQ', 'ABI_DOCTO_ANEXO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_COMPETENCIAS_SEQ', 'ABI_COMPETENCIAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANREVI_SEQ', 'TRANREVI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_ANEXO_SEQ', 'TIP_ANEXO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUB_CAMCOMP_SEQ', 'SUB_CAMCOMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMPRESTDORAUTORIZWEB_SEQ', 'PARAMPRESTDORAUTORIZWEB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PAPROINS_SEQ', 'PAPROINS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PACPROCE_SEQ', 'PACPROCE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PACINSUM_SEQ', 'PACINSUM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_SUB_CAMCOMP_SEQ', 'MOVTO_SUB_CAMCOMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_PROM_SEQ', 'MODUL_PROM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_CTBZ_PRORATA_SEQ', 'HISTOR_CTBZ_PRORATA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_CARENC_SEQ', 'TIP_CARENC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_TIP_CARENC_SEQ', 'MODUL_TIP_CARENC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_MODUL_SEQ', 'GRP_MODUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTRUT_TIP_CARENC_SEQ', 'ESTRUT_TIP_CARENC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGRPDOR_GRP_MODUL_SEQ', 'AGRPDOR_GRP_MODUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('POLITIC_VENDAS_PERC_SEQ', 'POLITIC_VENDAS_PERC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_TRANSF_ACOMODA_SEQ', 'MODUL_TRANSF_ACOMODA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRSEQCHAMADOATENDIM_SEQ', 'HMRSEQCHAMADOATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_CHAMADO_ATENDIM_SEQ', 'HMR_CHAMADO_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_CALEND_ATENDIM_DIA_SEQ', 'HMR_CALEND_ATENDIM_DIA', 'PROGRESS_RECID');
commit;
prompt 400 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPRPRE_SEQ', 'PROPRPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMETROS_HMR_SEQ', 'PARAMETROS_HMR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_GUIA_NEGADA_SEQ', 'MOVTO_GUIA_NEGADA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATURAM_CONTRAT_SEQ', 'HISTOR_FATURAM_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_NEGADA_SEQ', 'GUIA_NEGADA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_TURNO_ATENDIM_SEQ', 'HMR_TURNO_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODEL_PARAM_PROPOST_SEQ', 'MODEL_PARAM_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESBLOQ_BNFCIAR_SEQ', 'DESBLOQ_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TITUPRES_SEQ', 'TITUPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPINSUMO_SEQ', 'TMPINSUMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUMO_ITEM_MANUF_SEQ', 'INSUMO_ITEM_MANUF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOD_DESC_FAT_SEQ', 'MOD_DESC_FAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('JUSTIF_AUTORIZ_BIOM_SEQ', 'JUSTIF_AUTORIZ_BIOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('JUSTIF_ACES_BIOM_CARTAO_SEQ', 'JUSTIF_ACES_BIOM_CARTAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTORTABREAJUS_SEQ', 'HISTORTABREAJUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GERENCIA_USUAR_SEM_BIOM_SEQ', 'GERENCIA_USUAR_SEM_BIOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOCVAMODULPARPROPOST_SEQ', 'ASSOCVAMODULPARPROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LAUDO_PROCED_ANEXO_SEQ', 'LAUDO_PROCED_ANEXO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LAUDO_PROCED_GUIA_SEQ', 'LAUDO_PROCED_GUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_AGENDA_FUT_SEQ', 'GUIA_AGENDA_FUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOBENE_SEQ', 'TIPOBENE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GESTOR_MSG_SEQ', 'GESTOR_MSG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MSG_GUIA_AUDIT_SEQ', 'MSG_GUIA_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MSG_GUIA_DOCTO_GERAL_SEQ', 'MSG_GUIA_DOCTO_GERAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEXT_PADR_MSG_AUDIT_SEQ', 'TEXT_PADR_MSG_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEMP_CALC_PAGTO_PRESTDOR_SEQ', 'TEMP_CALC_PAGTO_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VLBENREP_SEQ', 'VLBENREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VLBENEF_SEQ', 'VLBENEF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VALPAGOBNFCIARCONTRNTE_SEQ', 'VALPAGOBNFCIARCONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VAL_CUST_SPED_SEQ', 'VAL_CUST_SPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUNOTA_SEQ', 'USUNOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USU_NEGOC_SEQ', 'USU_NEGOC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TPSATPFP_SEQ', 'TPSATPFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('STCARGA_SEQ', 'STCARGA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RESPONS_ARQ_FISC_SEQ', 'RESPONS_ARQ_FISC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REPGRMOD_SEQ', 'REPGRMOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REPEVEN_SEQ', 'REPEVEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_SERV_PAGTO_SEQ', 'REGRA_SERV_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_SERV_FATURAM_SEQ', 'REGRA_SERV_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_PRESTDOR_PAGTO_SEQ', 'REGRA_PRESTDOR_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_PRESTDOR_FATURAM_SEQ', 'REGRA_PRESTDOR_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_PAGTO_SEQ', 'REGRA_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_FATURAM_SEQ', 'REGRA_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_BNFCIAR_PAGTO_SEQ', 'REGRA_BNFCIAR_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_BNFCIAR_FATURAM_SEQ', 'REGRA_BNFCIAR_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REAJ_PARTIC_FP_SEQ', 'REAJ_PARTIC_FP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCESS_REFER_300_SEQ', 'PROCESS_REFER_300', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCESS_REFER_200_SEQ', 'PROCESS_REFER_200', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCES_REFER_SPED_SEQ', 'PROCES_REFER_SPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERCONFT_SEQ', 'PERCONFT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERC_JUROS_SEQ', 'PERC_JUROS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_GERAC_SPED_SEQ', 'PARAM_GERAC_SPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_GERAC_300_SEQ', 'PARAM_GERAC_300', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_GERAC_200_SEQ', 'PARAM_GERAC_200', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_GERAC_100_SEQ', 'PARAM_GERAC_100', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_VALID_PAGTO_SEQ', 'ORD_VALID_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_VALID_FATURAM_SEQ', 'ORD_VALID_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_REGRA_PAGTO_SEQ', 'ORD_REGRA_PAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_REGRA_FATURAM_SEQ', 'ORD_REGRA_FATURAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NOTASERV_SEQ', 'NOTASERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NOTACRED_SEQ', 'NOTACRED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_VLBENEF_SEQ', 'HISTOR_VLBENEF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_NOTASERV_SEQ', 'HISTOR_NOTASERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FTUSUEVE_SEQ', 'HISTOR_FTUSUEVE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FTAVULEV_SEQ', 'HISTOR_FTAVULEV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATUEVEN_SEQ', 'HISTOR_FATUEVEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATSEMREAJ_SEQ', 'HISTOR_FATSEMREAJ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATGRUNP_SEQ', 'HISTOR_FATGRUNP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATGRMOD_SEQ', 'HISTOR_FATGRMOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_FATEVECO_SEQ', 'HISTOR_FATEVECO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_ANTITNS_SEQ', 'HISTOR_ANTITNS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_CTAS_PEONA_SEQ', 'GRP_CTAS_PEONA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FTUSUEVE_SEQ', 'FTUSUEVE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FTAVULEV_SEQ', 'FTAVULEV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATURA_SEQ', 'FATURA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATUEVEN_SEQ', 'FATUEVEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATSEMREAJ_SEQ', 'FATSEMREAJ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATGRUNP_SEQ', 'FATGRUNP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATGRMOD_SEQ', 'FATGRMOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATEVECO_SEQ', 'FATEVECO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZESPTIT_SEQ', 'DZESPTIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DSFINTER_SEQ', 'DSFINTER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESCQTBEN_SEQ', 'DESCQTBEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEMCONRB_SEQ', 'DEMCONRB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEMCONFP_SEQ', 'DEMCONFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTBZ_PRORATA_SEQ', 'CTBZ_PRORATA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTAS_PEONA_SEQ', 'CTAS_PEONA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTAS_CTBL_SPED_SEQ', 'CTAS_CTBL_SPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTA_CUST_SPED_SEQ', 'CTA_CUST_SPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTRNTE_GERAC_SPED_SEQ', 'CONTRNTE_GERAC_SPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTRNTECTASCTBLSPED_SEQ', 'CONTRNTECTASCTBLSPED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AVISCRED_SEQ', 'AVISCRED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANTITNS_SEQ', 'ANTITNS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUPROGPER_SEQ', 'USUPROGPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUPERFIL_SEQ', 'USUPERFIL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUAGENDA_SEQ', 'USUAGENDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TURNOCLIN_SEQ', 'TURNOCLIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TURNOAGD_SEQ', 'TURNOAGD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPAGENDA_SEQ', 'TIPAGENDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWUSUPROGGP_SEQ', 'SWUSUPROGGP', 'PROGRESS_RECID');
commit;
prompt 500 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWUSUARIO_SEQ', 'SWUSUARIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWUSERLOG_SEQ', 'SWUSERLOG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWUSERGP_SEQ', 'SWUSERGP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWSUBROTINA_SEQ', 'SWSUBROTINA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWROTINA_SEQ', 'SWROTINA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPROGRAMAS_SEQ', 'SWPROGRAMAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPROGRAMA_SEQ', 'SWPROGRAMA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPROGGP_SEQ', 'SWPROGGP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPROGFUNCAO_SEQ', 'SWPROGFUNCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPERMUSU_SEQ', 'SWPERMUSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPERMISSOES_SEQ', 'SWPERMISSOES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPERMGRP_SEQ', 'SWPERMGRP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWPARAMETRO_SEQ', 'SWPARAMETRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWMODSIS_SEQ', 'SWMODSIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWLOGACESSO_SEQ', 'SWLOGACESSO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWINFAC_SEQ', 'SWINFAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWGRUUSU_SEQ', 'SWGRUUSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWGRUPO_SEQ', 'SWGRUPO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWFUNCAO_SEQ', 'SWFUNCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWDUVIDAS_SEQ', 'SWDUVIDAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SWACUACE_SEQ', 'SWACUACE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROGPERFIL_SEQ', 'PROGPERFIL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROGFUNC_SEQ', 'PROGFUNC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROGAGEND_SEQ', 'PROGAGEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTIPAGEND_SEQ', 'PRESTIPAGEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERFIL_SEQ', 'PERFIL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMINTAGEND_SEQ', 'PARAMINTAGEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMAGEND_SEQ', 'PARAMAGEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HORATRAB_SEQ', 'HORATRAB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HORABLOQ_SEQ', 'HORABLOQ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNCAGENDA_SEQ', 'FUNCAGENDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FERIADO_SEQ', 'FERIADO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONVENIOAGD_SEQ', 'CONVENIOAGD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLINTIPAGEND_SEQ', 'CLINTIPAGEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLINCENTRAL_SEQ', 'CLINCENTRAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGENDAWEB_SEQ', 'AGENDAWEB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGDSUBROTINA_SEQ', 'AGDSUBROTINA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGDROTINA_SEQ', 'AGDROTINA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGDMODULO_SEQ', 'AGDMODULO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGDCENTRAL_SEQ', 'AGDCENTRAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VLMENPRD_SEQ', 'VLMENPRD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TITUREPR_SEQ', 'TITUREPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TITDEPRE_SEQ', 'TITDEPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPORATE_SEQ', 'TIPORATE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RATLOCPR_SEQ', 'RATLOCPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRSOTEUS_SEQ', 'PRSOTEUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRSOMOTE_SEQ', 'PRSOMOTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRSOMOGR_SEQ', 'PRSOMOGR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRSOMOES_SEQ', 'PRSOMOES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRISOLMO_SEQ', 'PRISOLMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTMOV_SEQ', 'PRESTMOV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESNEGO_SEQ', 'PRESNEGO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESEVEN_SEQ', 'PRESEVEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRENEGIN_SEQ', 'PRENEGIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERIOMOV_SEQ', 'PERIOMOV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARCTITU_SEQ', 'PARCTITU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARCPRES_SEQ', 'PARCPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PAINSSPJ_SEQ', 'PAINSSPJ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PAGAPRES_SEQ', 'PAGAPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NIVELABE_SEQ', 'NIVELABE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTOREP_SEQ', 'MOVTOREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIREPR_SEQ', 'MOVIREPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIPRES_SEQ', 'MOVIPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVICONT_SEQ', 'MOVICONT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVEVPRO_SEQ', 'MOVEVPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_TIT_PRESTDOR_UN_SEQ', 'HISTOR_TIT_PRESTDOR_UN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTORDEMONSTPAGTOPROVIS_SEQ', 'HISTORDEMONSTPAGTOPROVIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTEVPP_SEQ', 'HISTEVPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTDEMCONPP_SEQ', 'HISTDEMCONPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPOPAC_SEQ', 'GRUPOPAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRPROPAC_SEQ', 'GRPROPAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRMODINSU_SEQ', 'GRMODINSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FLUXOFPP_SEQ', 'FLUXOFPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVEPROPP_SEQ', 'EVEPROPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTVENDA_SEQ', 'ESTVENDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTTIPMO_SEQ', 'ESTTIPMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTTERAD_SEQ', 'ESTTERAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTMOVGE_SEQ', 'ESTMOVGE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTGRUCU_SEQ', 'ESTGRUCU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTEADMO_SEQ', 'ESTEADMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTATERM_SEQ', 'ESTATERM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTAPRES_SEQ', 'ESTAPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTAPLAN_SEQ', 'ESTAPLAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTAMODU_SEQ', 'ESTAMODU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZLOGVER_SEQ', 'DZLOGVER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESPTERM_SEQ', 'DESPTERM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEMCONPP_SEQ', 'DEMCONPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEMCONCM_SEQ', 'DEMCONCM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTBZ_UN_SEQ', 'CTBZ_UN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTPREV_SEQ', 'CONTPREV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMVENDAMOT_SEQ', 'COMVENDAMOT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMTPPROP_SEQ', 'COMTPPROP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMREGRAQT_SEQ', 'COMREGRAQT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMREGRA_SEQ', 'COMREGRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMPROMOCAO_SEQ', 'COMPROMOCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMPARCE_SEQ', 'COMPARCE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMPARAM_SEQ', 'COMPARAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMPAGTO_SEQ', 'COMPAGTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMISAUX_SEQ', 'COMISAUX', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMFUNCA_SEQ', 'COMFUNCA', 'PROGRESS_RECID');
commit;
prompt 600 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMESTRUPROP_SEQ', 'COMESTRUPROP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMESTEV_SEQ', 'COMESTEV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMEQUIP_SEQ', 'COMEQUIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMDETAL_SEQ', 'COMDETAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMAGRUPA_SEQ', 'COMAGRUPA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARGA_GRUPO_REG_SEQ', 'CARGA_GRUPO_REG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARGA_GRUPO_SEQ', 'CARGA_GRUPO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANTECTIT_SEQ', 'ANTECTIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VAUTGLOS_SEQ', 'VAUTGLOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USOPARTICIPESCALNDOMOVTO_SEQ', 'USOPARTICIPESCALNDOMOVTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USO_PARTICIP_ESCALNDO_SEQ', 'USO_PARTICIP_ESCALNDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRAENINS_SEQ', 'TRAENINS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRABENGE_SEQ', 'TRABENGE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPCONVE_SEQ', 'TMPCONVE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMP_MOVTO_PROCED_SEQ', 'TMP_MOVTO_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMP_MOVTO_INSUMO_SEQ', 'TMP_MOVTO_INSUMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABRELBA_SEQ', 'TABRELBA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SOLICIT_ORD_SERV_SEQ', 'SOLICIT_ORD_SERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SERVPCTEPRESTDORINTERCAM_SEQ', 'SERVPCTEPRESTDORINTERCAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SERV_PARTICIP_ESCALNDO_SEQ', 'SERV_PARTICIP_ESCALNDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SERV_CONTRATUAL_SEQ', 'SERV_CONTRATUAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RISCPROC_SEQ', 'RISCPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RISCAMBI_SEQ', 'RISCAMBI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RESTRICINSUMOPRESTDOR_SEQ', 'RESTRICINSUMOPRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RESTRIC_INSUMO_SEQ', 'RESTRIC_INSUMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REFMOVIPROC_SEQ', 'REFMOVIPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REFMOV_INSU_SEQ', 'REFMOV_INSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REFDOCRECON_SEQ', 'REFDOCRECON', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REFDOCEXTRA_SEQ', 'REFDOCEXTRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRONCLIN_SEQ', 'PRONCLIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCUSOS_SEQ', 'PROCUSOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCGUIA_PALM_SEQ', 'PROCGUIA_PALM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCGUIA_SEQ', 'PROCGUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_REFATUR_NOTA_SEQ', 'PROCED_REFATUR_NOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_INTERCAM_SEQ', 'PRESTDOR_INTERCAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDORGLOSACONTSTDO_SEQ', 'PRESTDORGLOSACONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_CONTSTDO_SEQ', 'PRESTDOR_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREPCMSO_SEQ', 'PREPCMSO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERIOD_PRESTDOR_SEQ', 'PERIOD_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERIOD_CONTSTDO_SEQ', 'PERIOD_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERILOTE_SEQ', 'PERILOTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PDESGLOS_SEQ', 'PDESGLOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PCTE_PRESTDOR_INTERCAM_SEQ', 'PCTE_PRESTDOR_INTERCAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PCMSOAVA_SEQ', 'PCMSOAVA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PCMSO_SEQ', 'PCMSO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PCMSEXAM_SEQ', 'PCMSEXAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('OUT_UNI_SEQ', 'OUT_UNI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BENEFIC_CONTRAT_SEQ', 'BENEFIC_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BENEFPARTICIPESCALONADA_SEQ', 'BENEFPARTICIPESCALONADA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_LIBER_CARENC_SEQ', 'AUDIT_LIBER_CARENC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSVINCU_SEQ', 'ASSVINCU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSVIAAC_SEQ', 'ASSVIAAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSPROCE_SEQ', 'ASSPROCE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSPREST_SEQ', 'ASSPREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSPORTE_SEQ', 'ASSPORTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOTRCL_SEQ', 'ASSOTRCL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOTGCL_SEQ', 'ASSOTGCL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOCVACIDADEMPRESESTAB_SEQ', 'ASSOCVACIDADEMPRESESTAB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOC_GRUPO_CID_SEQ', 'ASSOC_GRUPO_CID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSMOTAL_SEQ', 'ASSMOTAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSINSUM_SEQ', 'ASSINSUM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSGRPRE_SEQ', 'ASSGRPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSGRPDR_SEQ', 'ASSGRPDR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSGPSIB_SEQ', 'ASSGPSIB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSESPEC_SEQ', 'ASSESPEC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSCIDAD_SEQ', 'ASSCIDAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSABRAN_SEQ', 'ASSABRAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AREA_ATUAC_GPL_SEQ', 'AREA_ATUAC_GPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ARE_ACA_SEQ', 'ARE_ACA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANSMTCAN_SEQ', 'ANSMTCAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AMBPROCE_SEQ', 'AMBPROCE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AMBINDAN_SEQ', 'AMBINDAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AMBESPGR_SEQ', 'AMBESPGR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AMBESPEC_SEQ', 'AMBESPEC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AMBESP_SEQ', 'AMBESP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AMBCBHPM_SEQ', 'AMBCBHPM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGENRISC_SEQ', 'AGENRISC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AGENNOCI_SEQ', 'AGENNOCI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ADUNIPRO_SEQ', 'ADUNIPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ADMMODPL_SEQ', 'ADMMODPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ACRDESPR_SEQ', 'ACRDESPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ACEITE_CONTSTDO_SEQ', 'ACEITE_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABRAUNID_SEQ', 'ABRAUNID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABRAPLAN_SEQ', 'ABRAPLAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORDECONS_SEQ', 'ORDECONS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NEGOCIAC_CONTSTDO_SEQ', 'NEGOCIAC_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_PROCED_CONTSTDO_SEQ', 'MOVTO_PROCED_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVTO_INSUMO_CONTSTDO_SEQ', 'MOVTO_INSUMO_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVRCGLO_SEQ', 'MOVRCGLO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIPTMP_SEQ', 'MOVIPTMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIPROC_SEQ', 'MOVIPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_PROCED_NOTA_SEQ', 'MOVIMEN_PROCED_NOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIMEN_INSUMO_NOTA_SEQ', 'MOVIMEN_INSUMO_NOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVATGLO_SEQ', 'MOVATGLO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVACGLO_SEQ', 'MOVACGLO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOV_ITMP_SEQ', 'MOV_ITMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOV_INSU_SEQ', 'MOV_INSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOV_DIRET_GUIA_SEQ', 'MOV_DIRET_GUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MONIPROC_SEQ', 'MONIPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MONIAMBI_SEQ', 'MONIAMBI', 'PROGRESS_RECID');
commit;
prompt 700 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MAPASUBS_SEQ', 'MAPASUBS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MAPAIP_SEQ', 'MAPAIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTEIMP_SEQ', 'LOTEIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTEGUIA_SEQ', 'LOTEGUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTEEXP_SEQ', 'LOTEEXP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTE_ERRO_SEQ', 'LOTE_ERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOGBIOME_SEQ', 'LOGBIOME', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LIMTRISCO_SEQ', 'LIMTRISCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUUSOS_SEQ', 'INSUUSOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUPROR_SEQ', 'INSUPROR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUMO_REFATUR_NOTA_SEQ', 'INSUMO_REFATUR_NOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUGUIA_SEQ', 'INSUGUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSTBANC_SEQ', 'INSTBANC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSPNOCI_SEQ', 'INSPNOCI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSPECAO_SEQ', 'INSPECAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSPAGEN_SEQ', 'INSPAGEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSGRPER_SEQ', 'INSGRPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IEMOVNEG_SEQ', 'IEMOVNEG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IEMOVEGL_SEQ', 'IEMOVEGL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HONOMEDI_SEQ', 'HONOMEDI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HONOENGE_SEQ', 'HONOENGE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HLOTEIMP_SEQ', 'HLOTEIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTORMOVIMENPROCEDSUSS_SEQ', 'HISTORMOVIMENPROCEDSUSS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_MOVIMEN_PROCED_SEQ', 'HISTOR_MOVIMEN_PROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_MOVIMEN_INSUMO_SEQ', 'HISTOR_MOVIMEN_INSUMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTORDOCTOREVISCTAS_SEQ', 'HISTORDOCTOREVISCTAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIAUTOR_PALM_SEQ', 'GUIAUTOR_PALM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIAUTOR_SEQ', 'GUIAUTOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIAINOD_SEQ', 'GUIAINOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIAADIC_SEQ', 'GUIAADIC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_HIS_SEQ', 'GUIA_HIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_DIRET_SEQ', 'GUIA_DIRET', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATULOTE_SEQ', 'FATULOTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATRISCO_SEQ', 'FATRISCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EXAMPCMS_SEQ', 'EXAMPCMS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERROEXEC_SEQ', 'ERROEXEC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERLOTIMP_SEQ', 'ERLOTIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCUSOS_SEQ', 'DOCUSOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCUSOOD_SEQ', 'DOCUSOOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_REVIS_NOTA_TMP_SEQ', 'DOCTO_REVIS_NOTA_TMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_REVIS_CTAS_NOTA_SEQ', 'DOCTO_REVIS_CTAS_NOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_REFATUR_NOTA_SEQ', 'DOCTO_REFATUR_NOTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTO_CONTSTDO_SEQ', 'DOCTO_CONTSTDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCTMPOD_SEQ', 'DOCTMPOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCRETMP_SEQ', 'DOCRETMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCRECON_SEQ', 'DOCRECON', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DOCCREOD_SEQ', 'DOCCREOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CBPRDESE_SEQ', 'CBPRDESE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CBOPROCE_SEQ', 'CBOPROCE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAPIPPRA_SEQ', 'CAPIPPRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BOLERPRO_SEQ', 'BOLERPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BOLERINS_SEQ', 'BOLERINS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BOLEERRO_SEQ', 'BOLEERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VL_INSU_INTER_SEQ', 'VL_INSU_INTER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VISITA_SEQ', 'VISITA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VALPRODU_SEQ', 'VALPRODU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VALID_PAPEL_AUDIT_SEQ', 'VALID_PAPEL_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUSUBST_SEQ', 'USUSUBST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUREPAS_SEQ', 'USUREPAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUREATE_SEQ', 'USUREATE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUMODU_SEQ', 'USUMODU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUCARPROC_SEQ', 'USUCARPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUCAREN_SEQ', 'USUCAREN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUARIO_ATENDIMENTO_SEQ', 'USUARIO_ATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUARIO_SEQ', 'USUARIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUARSIMULMODULOPCNAL_SEQ', 'USUARSIMULMODULOPCNAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUAR_SIMUL_SEQ', 'USUAR_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUAR_EXPORT_SEQ', 'USUAR_EXPORT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUAR_CARENC_SIMUL_SEQ', 'USUAR_CARENC_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USOPROPR2_SEQ', 'USOPROPR2', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USOPROPR_SEQ', 'USOPROPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USMOVADM_SEQ', 'USMOVADM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNIMED_ARQ_FISC_SEQ', 'UNIMED_ARQ_FISC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNI_DIF_INTER_SEQ', 'UNI_DIF_INTER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANSF_MODUL_OPCNAL_SEQ', 'TRANSF_MODUL_OPCNAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANSF_BNFCIAR_SELEC_SEQ', 'TRANSF_BNFCIAR_SELEC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPRPMSG_SEQ', 'TMPRPMSG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPRPERR_SEQ', 'TMPRPERR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPRPCTR_SEQ', 'TMPRPCTR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPRPCAR_SEQ', 'TMPRPCAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPRPBEN_SEQ', 'TMPRPBEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPROMSG_SEQ', 'TMPROMSG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPROERR_SEQ', 'TMPROERR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPROCTR_SEQ', 'TMPROCTR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPROBEN_SEQ', 'TMPROBEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TMPPRODU_SEQ', 'TMPPRODU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TITUDFAM_SEQ', 'TITUDFAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOATEN_SEQ', 'TIPOATEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TER_ADE_SEQ', 'TER_ADE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEMP_COND_SAUDE_SEQ', 'TEMP_COND_SAUDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEGRPACO_SEQ', 'TEGRPACO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TEADGRPA_SEQ', 'TEADGRPA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TAXTERFP_SEQ', 'TAXTERFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TAR_AUDIT_MOVTO_SEQ', 'TAR_AUDIT_MOVTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TAR_AUDIT_SEQ', 'TAR_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUSPUSUA_SEQ', 'SUSPUSUA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUSPTERM_SEQ', 'SUSPTERM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUBMOTAT_SEQ', 'SUBMOTAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SOLICITSEGNDAVIACARTAO_SEQ', 'SOLICITSEGNDAVIACARTAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SOBTXPRO_SEQ', 'SOBTXPRO', 'PROGRESS_RECID');
commit;
prompt 800 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIT_APROV_PROPOSTA_SEQ', 'SIT_APROV_PROPOSTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIRXSIA_SEQ', 'SIRXSIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIMULA_PROPOSTA_SEQ', 'SIMULA_PROPOSTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIMULA_OPCIONAIS_SEQ', 'SIMULA_OPCIONAIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIMULA_BENEF_SEQ', 'SIMULA_BENEF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIAMED_SEQ', 'SIAMED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQUENCIA_CHAMADO_SEQ', 'SEQUENCIA_CHAMADO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQREGAT_SEQ', 'SEQREGAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SEQATENDIMENTO_SEQ', 'SEQATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SATISCLI_SEQ', 'SATISCLI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RTMSGREP_SEQ', 'RTMSGREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RTMSGPRO_SEQ', 'RTMSGPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RTBENREP_SEQ', 'RTBENREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RTBENPRO_SEQ', 'RTBENPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RETLOTRE_SEQ', 'RETLOTRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RETLOTPR_SEQ', 'RETLOTPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REPCONTRAT_SEQ', 'REPCONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_UNIF_SEQ', 'REGRA_UNIF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_IMPORT_BENEFIC_SEQ', 'REGRA_IMPORT_BENEFIC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGPROUS_SEQ', 'REGPROUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGATECL_SEQ', 'REGATECL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGATABE_SEQ', 'REGATABE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REFERENCIA_CONTRAT_SEQ', 'REFERENCIA_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REATIV_BNFCIAR_CONTRAT_SEQ', 'REATIV_BNFCIAR_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RCNAOAUTACOM_SEQ', 'RCNAOAUTACOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRUNINEG_SEQ', 'PRUNINEG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROUDEMP_SEQ', 'PROUDEMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROSPECT_SEQ', 'PROSPECT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROSP_PROPOST_SEQ', 'PROSP_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROSP_PROP_PC_SEQ', 'PROSP_PROP_PC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROSP_PROP_MODGF_SEQ', 'PROSP_PROP_MODGF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROSP_PROP_MOD_SEQ', 'PROSP_PROP_MOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROSP_PROP_GR_FX_SEQ', 'PROSP_PROP_GR_FX', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRORESPR_SEQ', 'PRORESPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPUNIM_SEQ', 'PROPUNIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPTXTR_SEQ', 'PROPTXTR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPTAXA_SEQ', 'PROPTAXA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPPRE_SEQ', 'PROPPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPCOPA_SEQ', 'PROPCOPA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPCART_SEQ', 'PROPCART', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPABRA_SEQ', 'PROPABRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROP_TAB_SEQ', 'PROP_TAB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROGNEGO_SEQ', 'PROGNEGO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCPRES_SEQ', 'PROCPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_PERMIT_ODONTO_SEQ', 'PROCED_PERMIT_ODONTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRO_PLA_SEQ', 'PRO_PLA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRAZPPRA_SEQ', 'PRAZPPRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PR_MO_AM_SEQ', 'PR_MO_AM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PR_ID_US_SEQ', 'PR_ID_US', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PIMPUNID_SEQ', 'PIMPUNID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PIMPCONT_SEQ', 'PIMPCONT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PFIS_EXPORT_SEQ', 'PFIS_EXPORT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PEXPUNID_SEQ', 'PEXPUNID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PEXPADM_SEQ', 'PEXPADM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PESSOA_FISICA_SEQ', 'PESSOA_FISICA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PESQUISA_SATISFACAO_SEQ', 'PESQUISA_SATISFACAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PESQUISA_PERGUNTA_SEQ', 'PESQUISA_PERGUNTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERMISSAO_INF_AD_SEQ', 'PERMISSAO_INF_AD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERGUNTAS_PESQ_SATISF_SEQ', 'PERGUNTAS_PESQ_SATISF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERFTTER_SEQ', 'PERFTTER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_MOVIMEN_BNFCIAR_SEQ', 'PARAM_MOVIMEN_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARACOM_SEQ', 'PARACOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('OCOSOLPR_SEQ', 'OCOSOLPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NOTINAD_SEQ', 'NOTINAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NATUATEN_SEQ', 'NATUATEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NAOAUTACOM_SEQ', 'NAOAUTACOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVUSUTR_SEQ', 'MOVUSUTR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVIBENE_SEQ', 'MOVIBENE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVCARRC_SEQ', 'MOVCARRC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOV_DIF_INTER_SEQ', 'MOV_DIF_INTER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIVOCANCELAMENTOATENDI_SEQ', 'MOTIVOCANCELAMENTOATENDI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIVO_ATENDIMENTO_SEQ', 'MOTIVO_ATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIATEN_SEQ', 'MOTIATEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_OPCNAL_SIMUL_SEQ', 'MODUL_OPCNAL_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_OBRIG_SIMUL_SEQ', 'MODUL_OBRIG_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTIMPREP_SEQ', 'LTIMPREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTIMPPRO_SEQ', 'LTIMPPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTEXPREP_SEQ', 'LTEXPREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTEXPPRO_SEQ', 'LTEXPPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTEATREP_SEQ', 'LTEATREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTEATPRO_SEQ', 'LTEATPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTBLREP_SEQ', 'LTBLREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LTBLPRO_SEQ', 'LTBLPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTREPBE_SEQ', 'LOTREPBE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTPROBE_SEQ', 'LOTPROBE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTCMREP_SEQ', 'LOTCMREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOTCMPRO_SEQ', 'LOTCMPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HORARIO_ATENDIMENTO_SEQ', 'HORARIO_ATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_USUAR_ATENDIM_SEQ', 'HMR_USUAR_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_TOPIC_GRP_ATENDIM_SEQ', 'HMR_TOPIC_GRP_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_REGRA_ENCAM_SEQ', 'HMR_REGRA_ENCAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRPESQSATISFACREALIZ_SEQ', 'HMRPESQSATISFACREALIZ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_PESQ_SATISFAC_SEQ', 'HMR_PESQ_SATISFAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRPERMISINFORMCONTRNTE_SEQ', 'HMRPERMISINFORMCONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_PERG_PESQ_SATISFAC_SEQ', 'HMR_PERG_PESQ_SATISFAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRPERGPESQMOTIVATENDIM_SEQ', 'HMRPERGPESQMOTIVATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRMSGATENDIMGRPATENDIM_SEQ', 'HMRMSGATENDIMGRPATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRMSGATENDIMCONTRNTE_SEQ', 'HMRMSGATENDIMCONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRMSGATENDIMCONTRAT_SEQ', 'HMRMSGATENDIMCONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_MSG_ATENDIM_SEQ', 'HMR_MSG_ATENDIM', 'PROGRESS_RECID');
commit;
prompt 900 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRMOTIVCANCELATENDIM_SEQ', 'HMRMOTIVCANCELATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_MOTIV_ATENDIM_SEQ', 'HMR_MOTIV_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_GRP_ATENDIM_PERMIS_SEQ', 'HMR_GRP_ATENDIM_PERMIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_GRP_ATENDIM_MOTIV_SEQ', 'HMR_GRP_ATENDIM_MOTIV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRGRPATENDIMCONTRNTE_SEQ', 'HMRGRPATENDIMCONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_GRP_ATENDIM_CALEND_SEQ', 'HMR_GRP_ATENDIM_CALEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_GRP_ATENDIM_SEQ', 'HMR_GRP_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_CATEG_ATENDIM_SEQ', 'HMR_CATEG_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_CALEND_TURNO_SEQ', 'HMR_CALEND_TURNO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMR_CALEND_ATENDIM_SEQ', 'HMR_CALEND_ATENDIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HMRAMARCMOTIVMODALID_SEQ', 'HMRAMARCMOTIVMODALID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTUSOPROPR2_SEQ', 'HISTUSOPROPR2', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_SIMUL_PROPOST_SEQ', 'HISTOR_SIMUL_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTMESES_SEQ', 'HISTMESES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTMESCIVIL_SEQ', 'HISTMESCIVIL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTFXPARPRO_SEQ', 'HISTFXPARPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTCONTRATBENE_SEQ', 'HISTCONTRATBENE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTCONTRAT_SEQ', 'HISTCONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTCIVIL_SEQ', 'HISTCIVIL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTABPRECOGR_SEQ', 'HISTABPRECOGR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTABPRECOBENEF_SEQ', 'HISTABPRECOBENEF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTABPRECO_SEQ', 'HISTABPRECO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HIST_VISITA_SEQ', 'HIST_VISITA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HIST_APROV_PROPOSTA_SEQ', 'HIST_APROV_PROPOSTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HIST_ALTER_GP_SEQ', 'HIST_ALTER_GP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPO_ATENDIMENTO_SEQ', 'GRUPO_ATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRPAR_FE_SIMUL_SEQ', 'GRPAR_FE_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FXPARPRO_SEQ', 'FXPARPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FXPALOVP_SEQ', 'FXPALOVP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNDEPRI_SEQ', 'FUNDEPRI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNC_DEP_SEQ', 'FUNC_DEP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FRANQUIA_SEQ', 'FRANQUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATORUSUAR_SEQ', 'FATORUSUAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVEPRPER_SEQ', 'EVEPRPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVEPEREV_SEQ', 'EVEPEREV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENT_PROGDO_BNFCIAR_SEQ', 'EVENT_PROGDO_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENPROG_SEQ', 'EVENPROG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENGRIMP_SEQ', 'EVENGRIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENCTRIMP_SEQ', 'EVENCTRIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVAPLPER_SEQ', 'EVAPLPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERRO_IMPORT_BNFCIAR_SEQ', 'ERRO_IMPORT_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERLOTREP_SEQ', 'ERLOTREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERLOTPRO_SEQ', 'ERLOTPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ENDERECO_SEQ', 'ENDERECO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZDECCID_SEQ', 'DZDECCID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESPLAUS_SEQ', 'DESPLAUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEPPPRA_SEQ', 'DEPPPRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DECPREST_SEQ', 'DECPREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEC_SAU_SEQ', 'DEC_SAU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONVPROP_SEQ', 'CONVPROP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTROL_LOTE_IMPORT_SEQ', 'CONTROL_LOTE_IMPORT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTRIMP_SEQ', 'CONTRIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTATO_PESSOA_SEQ', 'CONTATO_PESSOA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONFIGLAYOUTIMPORTBNFCIA_SEQ', 'CONFIGLAYOUTIMPORTBNFCIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COCONTRAT_SEQ', 'COCONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CHAMADO_SEQ', 'CHAMADO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CATEGORIA_ATENDIMENTO_SEQ', 'CATEGORIA_ATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARADMIN_SEQ', 'CARADMIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CARADCON_SEQ', 'CARADCON', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAR_IDE_SEQ', 'CAR_IDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CANCEL_CONTRAT_BNFCIAR_SEQ', 'CANCEL_CONTRAT_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAMPPROP_SEQ', 'CAMPPROP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAD_BNFCIAR_TAR_SEQ', 'CAD_BNFCIAR_TAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BLREPTMP_SEQ', 'BLREPTMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BLPROTMP_SEQ', 'BLPROTMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BIOMETRIA_PESSOA_SEQ', 'BIOMETRIA_PESSOA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BASE_CONHECIMENTO_TOP_SEQ', 'BASE_CONHECIMENTO_TOP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BASE_CONHECIMENTO_CAT_SEQ', 'BASE_CONHECIMENTO_CAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUT_REAL_SEQ', 'AUT_REAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_REATIV_SEQ', 'AUDIT_REATIV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_EXC_BNFCIAR_SEQ', 'AUDIT_EXC_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_CANCEL_CONTRAT_SEQ', 'AUDIT_CANCEL_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_CAD_TAR_SEQ', 'AUDIT_CAD_TAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('AUDIT_CAD_SEQ', 'AUDIT_CAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ATENDIMENTO_SEQ', 'ATENDIMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSOCVA_PROPOST_SEQ', 'ASSOCVA_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ASSBENPA_SEQ', 'ASSBENPA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_TAR_AUDIT_SEQ', 'ANEXO_TAR_AUDIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_PROPOST_SEQ', 'ANEXO_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_PESSOA_SEQ', 'ANEXO_PESSOA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_CONTRNTE_SEQ', 'ANEXO_CONTRNTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ANEXO_BNFCIAR_SEQ', 'ANEXO_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ACNAOAUTACOM_SEQ', 'ACNAOAUTACOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_USUAR_ATEND_SEQ', 'ABI_USUAR_ATEND', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ABI_TABLETEST_SEQ', 'ABI_TABLETEST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('WORKFLOW_INTEGR_MSG_SEQ', 'WORKFLOW_INTEGR_MSG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VIA_ACE_SEQ', 'VIA_ACE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('VALORATE_SEQ', 'VALORATE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USUAR_JURISD_SEQ', 'USUAR_JURISD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USU_PRES_SEQ', 'USU_PRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USERLOG_SEQ', 'USERLOG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USERCAD_SEQ', 'USERCAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('USERACES_SEQ', 'USERACES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNITABCO_SEQ', 'UNITABCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNIMED_SEQ', 'UNIMED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNIDNEGOCFP_SEQ', 'UNIDNEGOCFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNICAMCO_SEQ', 'UNICAMCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNIADMIN_SEQ', 'UNIADMIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('UNI_TAXA_SEQ', 'UNI_TAXA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TXREFATUNI_SEQ', 'TXREFATUNI', 'PROGRESS_RECID');
commit;
prompt 1000 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRMODTPI_SEQ', 'TRMODTPI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRMODAMB_SEQ', 'TRMODAMB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRATIPIN_SEQ', 'TRATIPIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANUSUA_SEQ', 'TRANUSUA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANTIPI_SEQ', 'TRANTIPI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANPROC_SEQ', 'TRANPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANINSU_SEQ', 'TRANINSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANFUNC_SEQ', 'TRANFUNC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TRANCONV_SEQ', 'TRANCONV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TPPLABRA_SEQ', 'TPPLABRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TPGITPIN_SEQ', 'TPGITPIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TPCARMOD_SEQ', 'TPCARMOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TOTPROPR_SEQ', 'TOTPROPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TISS_INSUMO_SEQ', 'TISS_INSUMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPTABMO_SEQ', 'TIPTABMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOVINC_SEQ', 'TIPOVINC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOVENC_SEQ', 'TIPOVENC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOSUBS_SEQ', 'TIPOSUBS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOPROD_SEQ', 'TIPOPROD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOPART_SEQ', 'TIPOPART', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOMOVI_SEQ', 'TIPOMOVI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOMENS_SEQ', 'TIPOMENS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOMEDI_SEQ', 'TIPOMEDI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOMAQU_SEQ', 'TIPOMAQU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOINSU_SEQ', 'TIPOINSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOCOB_SEQ', 'TIPOCOB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPOCLIN_SEQ', 'TIPOCLIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPLFATU_SEQ', 'TIPLFATU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPLEVEN_CT_SEQ', 'TIPLEVEN_CT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPLEVEN_SEQ', 'TIPLEVEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPLESP_SEQ', 'TIPLESP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIPACOMD_SEQ', 'TIPACOMD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_UNI_SEQ', 'TIP_UNI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_TAB_SEQ', 'TIP_TAB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_PROCES_PROPOST_SEQ', 'TIP_PROCES_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_PRO_SEQ', 'TIP_PRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_PERC_SEQ', 'TIP_PERC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_IDX_REAJ_SEQ', 'TIP_IDX_REAJ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_IDX_MES_ANO_REFER_SEQ', 'TIP_IDX_MES_ANO_REFER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIP_GUIA_SEQ', 'TIP_GUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TIINGRES_SEQ', 'TIINGRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TI_PL_SA_SEQ', 'TI_PL_SA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TBPREPRO_SEQ', 'TBPREPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TBCONVCD_SEQ', 'TBCONVCD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TAXATRFP_SEQ', 'TAXATRFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TAPRAMPR_SEQ', 'TAPRAMPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABTPLAS_SEQ', 'TABTPLAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABPREPR_SEQ', 'TABPREPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABPREPL_SEQ', 'TABPREPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABPREMO_SEQ', 'TABPREMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABLAS_SEQ', 'TABLAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('TABEVEMOV_SEQ', 'TABEVEMOV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUBSQUIM_SEQ', 'SUBSQUIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUBGRCBO_SEQ', 'SUBGRCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUBAGRIS_SEQ', 'SUBAGRIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SUB_TIP_PROPOST_SEQ', 'SUB_TIP_PROPOST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('STATUS_INTEGR_GEST_SEQ', 'STATUS_INTEGR_GEST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ST_MOVTO_SEQ', 'ST_MOVTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SRVALIDA_SEQ', 'SRVALIDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SRIRINSS_SEQ', 'SRIRINSS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SOOCPRUS_SEQ', 'SOOCPRUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SOCIDIRE_SEQ', 'SOCIDIRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITUREP_SEQ', 'SITUREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITUPRE_SEQ', 'SITUPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITUFATU_SEQ', 'SITUFATU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITUCART_SEQ', 'SITUCART', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITUAMO_SEQ', 'SITUAMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITPROME_SEQ', 'SITPROME', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITPREST_SEQ', 'SITPREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITPCPRO_SEQ', 'SITPCPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITOCOPR_SEQ', 'SITOCOPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITDOCCO_SEQ', 'SITDOCCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SITCOBRA_SEQ', 'SITCOBRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIT_USU_SEQ', 'SIT_USU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIT_PRO_SEQ', 'SIT_PRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIT_PER_SEQ', 'SIT_PER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIT_CRE_SEQ', 'SIT_CRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIT_CAD_SEQ', 'SIT_CAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIMUL_EXPORTA_REG_SEQ', 'SIMUL_EXPORTA_REG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIMUL_EXPORTA_DADOS_SEQ', 'SIMUL_EXPORTA_DADOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIBSITUACAOBENEFICIARIO_SEQ', 'SIBSITUACAOBENEFICIARIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_REMESSA_SEQ', 'SIB_REMESSA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MOVIMENTACAO_SEQ', 'SIB_MOVIMENTACAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MOV_REATIVACAO_SEQ', 'SIB_MOV_REATIVACAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MOV_INC_RET_SEQ', 'SIB_MOV_INC_RET', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MOV_CANCELAMENTO_SEQ', 'SIB_MOV_CANCELAMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MOV_ALT_CONTRATUAL_SEQ', 'SIB_MOV_ALT_CONTRATUAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MOTIVO_REJEICAO_SEQ', 'SIB_MOTIVO_REJEICAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SIB_MENSAGEM_ERRO_SEQ', 'SIB_MENSAGEM_ERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SI_TE_AD_SEQ', 'SI_TE_AD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SETORGEN_SEQ', 'SETORGEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SECRETAR_SEQ', 'SECRETAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SECRCLIN_SEQ', 'SECRCLIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SECAO_SEQ', 'SECAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('SALCONTR_SEQ', 'SALCONTR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ROTICALC_SEQ', 'ROTICALC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REPPRESERV_SEQ', 'REPPRESERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REMEPROD_SEQ', 'REMEPROD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RELACDECLASAUDEPROCED_SEQ', 'RELACDECLASAUDEPROCED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRAUTO_SEQ', 'REGRAUTO', 'PROGRESS_RECID');
commit;
prompt 1100 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRAPARTICIPESCALNDO_SEQ', 'REGRAPARTICIPESCALNDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGRA_GRP_PCTE_SEQ', 'REGRA_GRP_PCTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REGAUBEN_SEQ', 'REGAUBEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REG_PLANO_SAUDE_VAL_SEQ', 'REG_PLANO_SAUDE_VAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('REG_PLANO_SAUDE_SEQ', 'REG_PLANO_SAUDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RAMSUBGR_SEQ', 'RAMSUBGR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RAMOSGRU_SEQ', 'RAMOSGRU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RAMOS_SEQ', 'RAMOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('RAMOATIV_SEQ', 'RAMOATIV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('QTMPGPRE_SEQ', 'QTMPGPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('QTMCOPRE_SEQ', 'QTMCOPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUVINPR_SEQ', 'PTUVINPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUVIAAC_SEQ', 'PTUVIAAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUTTABE_SEQ', 'PTUTTABE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUREDRE_SEQ', 'PTUREDRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUPRODU_SEQ', 'PTUPRODU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUPORTE_SEQ', 'PTUPORTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUMOTQUEST_SEQ', 'PTUMOTQUEST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUMOTAL_SEQ', 'PTUMOTAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUMENSA_SEQ', 'PTUMENSA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUINTAB_SEQ', 'PTUINTAB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUINSUM_SEQ', 'PTUINSUM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUGRSER_SEQ', 'PTUGRSER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUGRPRE_SEQ', 'PTUGRPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUGRPAR_SEQ', 'PTUGRPAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUESPEC_SEQ', 'PTUESPEC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUCLNOT_SEQ', 'PTUCLNOT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUCIDAD_SEQ', 'PTUCIDAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PTUCAREN_SEQ', 'PTUCAREN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROTIPIN_SEQ', 'PROTIPIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPRIET_SEQ', 'PROPRIET', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPERUS_SEQ', 'PROPERUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPERTI_SEQ', 'PROPERTI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROPCLIN_SEQ', 'PROPCLIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROMODPR_SEQ', 'PROMODPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROGRPER_SEQ', 'PROGRPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROESPSE_SEQ', 'PROESPSE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRODUTPARTICIPESCALNDO_SEQ', 'PRODUTPARTICIPESCALNDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCRISC_SEQ', 'PROCRISC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCEXCL_SEQ', 'PROCEXCL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_SUGEST_SEQ', 'PROCED_SUGEST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_COMP_SEQ', 'PROCED_COMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROCED_COMB_SEQ', 'PROCED_COMB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PROC_CID_SEQ', 'PROC_CID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRO_PERC_SEQ', 'PRO_PERC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRO_BENE_SEQ', 'PRO_BENE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRMODIMP_SEQ', 'PRMODIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRMODEXP_SEQ', 'PRMODEXP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRINCP_ATIV_SEQ', 'PRINCP_ATIV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRGRPECI_SEQ', 'PRGRPECI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREVIESP_SEQ', 'PREVIESP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTPRO_SEQ', 'PRESTPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_TAX_SEQ', 'PRESTDOR_TAX', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESTDOR_ENDER_SEQ', 'PRESTDOR_ENDER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREST_INST_SEQ', 'PREST_INST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREST_AREA_ATU_SEQ', 'PREST_AREA_ATU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESRATE_SEQ', 'PRESRATE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESMOVT_SEQ', 'PRESMOVT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESINSU_SEQ', 'PRESINSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRESERV_SEQ', 'PRESERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRES_PRO_SEQ', 'PRES_PRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRES_INS_SEQ', 'PRES_INS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRES_AMB_SEQ', 'PRES_AMB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREPROVA_SEQ', 'PREPROVA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREPROAD_SEQ', 'PREPROAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREPADIN_SEQ', 'PREPADIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREMOAD_SEQ', 'PREMOAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PREINPR_SEQ', 'PREINPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRECPROC_SEQ', 'PRECPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRDADM_SEQ', 'PRDADM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRAUTGER_SEQ', 'PRAUTGER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PRADQUNI_SEQ', 'PRADQUNI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PORTPROC_SEQ', 'PORTPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PORTANES_SEQ', 'PORTANES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('POLITIC_MODUL_SEQ', 'POLITIC_MODUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('POLITIC_FAIXA_SEQ', 'POLITIC_FAIXA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLMODACO_SEQ', 'PLMODACO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLMOCARE_SEQ', 'PLMOCARE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLAMOFOR_SEQ', 'PLAMOFOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLAMODPR_SEQ', 'PLAMODPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLAM_ESP_SEQ', 'PLAM_ESP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLA_SAU_SEQ', 'PLA_SAU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PLA_MOD_SEQ', 'PLA_MOD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PL_MO_AM_SEQ', 'PL_MO_AM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PL_GR_PA_SEQ', 'PL_GR_PA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PFIS_INFORM_COMPLTAR_SEQ', 'PFIS_INFORM_COMPLTAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PESSOA_JURIDICA_SEQ', 'PESSOA_JURIDICA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PESSOA_JURID_SIMUL_SEQ', 'PESSOA_JURID_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PESSOA_FISIC_SIMUL_SEQ', 'PESSOA_FISIC_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERIMOVI_SEQ', 'PERIMOVI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERGGENE_SEQ', 'PERGGENE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERFTPL_SEQ', 'PERFTPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERDIVPR_SEQ', 'PERDIVPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PERCEVENTO_SEQ', 'PERCEVENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PER_USU_SEQ', 'PER_USU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PEDVPROC_SEQ', 'PEDVPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PEDIVREG_SEQ', 'PEDIVREG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PECONTRA_SEQ', 'PECONTRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PCTE_GRP_PCTE_SEQ', 'PCTE_GRP_PCTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTINSU_SEQ', 'PARTINSU', 'PROGRESS_RECID');
commit;
prompt 1200 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTICIP_SERV_SEQ', 'PARTICIP_SERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTICIP_PRESTDOR_SEQ', 'PARTICIP_PRESTDOR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTICIP_PARAM_SEQ', 'PARTICIP_PARAM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTICIP_FAIXA_SEQ', 'PARTICIP_FAIXA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTICIP_ESTRUT_SEQ', 'PARTICIP_ESTRUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTIC_LIMIT_SEQ', 'PARTIC_LIMIT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARTIC_FRANQUIA_SEQ', 'PARTIC_FRANQUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PAREMEDI_SEQ', 'PAREMEDI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARDIRAC_SEQ', 'PARDIRAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAREP_SEQ', 'PARAREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAREFATU_SEQ', 'PARAREFATU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAPESS_SEQ', 'PARAPESS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARANTEX_SEQ', 'PARANTEX', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMWEB_SEQ', 'PARAMWEB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMSKT_SEQ', 'PARAMSKT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMPRO_SEQ', 'PARAMPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMMO_SEQ', 'PARAMMO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMINT_SEQ', 'PARAMINT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMEPP_SEQ', 'PARAMEPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMECP_SEQ', 'PARAMECP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMECM_SEQ', 'PARAMECM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMECG_SEQ', 'PARAMECG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMDSG_SEQ', 'PARAMDSG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMCRB_SEQ', 'PARAMCRB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMACP_SEQ', 'PARAMACP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAM_SIMUL_SEQ', 'PARAM_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAMPARTICIPESCALNDO_SEQ', 'PARAMPARTICIPESCALNDO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAFORM_SEQ', 'PARAFORM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARAFATU_SEQ', 'PARAFATU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARADMIN_SEQ', 'PARADMIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PARACOMI_SEQ', 'PARACOMI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('PAD_COB_SEQ', 'PAD_COB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_VALID_PARTICIP_SEQ', 'ORD_VALID_PARTICIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ORD_PARTICIP_SEQ', 'ORD_PARTICIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('NEGOCIAC_FATOR_MENSLID_SEQ', 'NEGOCIAC_FATOR_MENSLID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MWCOUTPUTGRC_SEQ', 'MWCOUTPUTGRC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MWCOUTPUT_SEQ', 'MWCOUTPUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MWCINPUTPRIORITY_SEQ', 'MWCINPUTPRIORITY', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MWCINPUTGRC_SEQ', 'MWCINPUTGRC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MWCINPUT_SEQ', 'MWCINPUT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOVCONTR_SEQ', 'MOVCONTR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTVALID_SEQ', 'MOTVALID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTPROUS_SEQ', 'MOTPROUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIVO_PROCURA_SEQ', 'MOTIVO_PROCURA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIVO_FECHAMENTO_SEQ', 'MOTIVO_FECHAMENTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIVSOLICITSEGNDAVIA_SEQ', 'MOTIVSOLICITSEGNDAVIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIV_NEGAC_SEQ', 'MOTIV_NEGAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTICANC_SEQ', 'MOTICANC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTIALTA_SEQ', 'MOTIALTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOTCANGE_SEQ', 'MOTCANGE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOGRCUPR_SEQ', 'MOGRCUPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODULPROCEDDESPESANS_SEQ', 'MODULPROCEDDESPESANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODUL_DESPES_ANS_SEQ', 'MODUL_DESPES_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODPRODE_SEQ', 'MODPRODE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODEL_CONTRAT_SEQ', 'MODEL_CONTRAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODALID_SEQ', 'MODALID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MODADMIN_SEQ', 'MODADMIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOD_COB_SEQ', 'MOD_COB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOCPGLAT_SEQ', 'MOCPGLAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MOCCOLAT_SEQ', 'MOCCOLAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSISTE_SEQ', 'MENSISTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSGRUP_SEQ', 'MENSGRUP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSCART_SEQ', 'MENSCART', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MENSAUTO_SEQ', 'MENSAUTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('MAQUCLIN_SEQ', 'MAQUCLIN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOGRAD_SEQ', 'LOGRAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOCAPROD_SEQ', 'LOCAPROD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOCAL_CONTATO_SEQ', 'LOCAL_CONTATO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOCAAUTO_SEQ', 'LOCAAUTO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LOCAATEN_SEQ', 'LOCAATEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LIMITE_PARTIC_SEQ', 'LIMITE_PARTIC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LIMITE_PART_PREST_SEQ', 'LIMITE_PART_PREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LIM_PERIOD_MOVIMEN_SEQ', 'LIM_PERIOD_MOVIMEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LIBER_CARENC_SEQ', 'LIBER_CARENC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LGLPBASE_SEQ', 'LGLPBASE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('LAYOUTEI_SEQ', 'LAYOUTEI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('JUSTIF_BIOM_SEQ', 'JUSTIF_BIOM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('JURISD_FAIXA_ETARIA_SEQ', 'JURISD_FAIXA_ETARIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ITEMPLAN_SEQ', 'ITEMPLAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ISSCIDAD_SEQ', 'ISSCIDAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INTER_FRANQUIA_SEQ', 'INTER_FRANQUIA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUPROC_SEQ', 'INSUPROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUPRES_SEQ', 'INSUPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUMOS_SEQ', 'INSUMOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INSUMO_IMPTDO_NAC_SEQ', 'INSUMO_IMPTDO_NAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INNCOBPR_SEQ', 'INNCOBPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('INDANDOC_SEQ', 'INDANDOC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPRES_DIGITAL_PESSOA_SEQ', 'IMPRES_DIGITAL_PESSOA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('IMPREGPS_SEQ', 'IMPREGPS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HORAURGE_SEQ', 'HORAURGE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HLOTATR_SEQ', 'HLOTATR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTPROPERUS_SEQ', 'HISTPROPERUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTPREST_SEQ', 'HISTPREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOTPROPR_SEQ', 'HISTOTPROPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_RPC_VAL_SEQ', 'HISTOR_RPC_VAL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_RPC_PLANO_SEQ', 'HISTOR_RPC_PLANO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_RPC_JUSTIF_SEQ', 'HISTOR_RPC_JUSTIF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_RPC_HEADER_SEQ', 'HISTOR_RPC_HEADER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_PROPOST_REPAS_SEQ', 'HISTOR_PROPOST_REPAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOR_PRECO_REAJ_SEQ', 'HISTOR_PRECO_REAJ', 'PROGRESS_RECID');
commit;
prompt 1300 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTOPER_SEQ', 'HISTOPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HISTFXPAR_PR_SEQ', 'HISTFXPAR_PR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HIST_MOVTO_USUARIO_SEQ', 'HIST_MOVTO_USUARIO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HEXPFARI_SEQ', 'HEXPFARI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HCATREGI_SEQ', 'HCATREGI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('HCARINSU_SEQ', 'HCARINSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GUIA_INFO_PREST_SEQ', 'GUIA_INFO_PREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPPRES_SEQ', 'GRUPPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPPERG_SEQ', 'GRUPPERG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPOCBO_SEQ', 'GRUPOCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPO_DESC_PROC_SEQ', 'GRUPO_DESC_PROC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPO_DESC_PREST_SEQ', 'GRUPO_DESC_PREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPO_DESC_SEQ', 'GRUPO_DESC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPO_CID_SEQ', 'GRUPO_CID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRUPCONT_SEQ', 'GRUPCONT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRU_PRO_SEQ', 'GRU_PRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRPRESTAB_SEQ', 'GRPRESTAB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_PCTE_SEQ', 'GRP_PCTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_ESTADO_CIDAD_EXP_SEQ', 'GRP_ESTADO_CIDAD_EXP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRP_SEQ', 'GRP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRAURISC_SEQ', 'GRAURISC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRAGRCBO_SEQ', 'GRAGRCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRAPARPARTICIPESCALONADA_SEQ', 'GRAPARPARTICIPESCALONADA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GRA_PAR_SEQ', 'GRA_PAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GERAPROB_SEQ', 'GERAPROB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('GERAC_DESPES_ANS_SEQ', 'GERAC_DESPES_ANS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FXPAR_PR_SEQ', 'FXPAR_PR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FXPALOPR_SEQ', 'FXPALOPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FXETCONV_SEQ', 'FXETCONV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNPROG_SEQ', 'FUNPROG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNCPROP_SEQ', 'FUNCPROP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNCEMPR_SEQ', 'FUNCEMPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNCCBO_SEQ', 'FUNCCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FUNCCARG_SEQ', 'FUNCCARG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FTPADCOB_SEQ', 'FTPADCOB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FRANQ_INTRCAO_SEQ', 'FRANQ_INTRCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FPNOTINA_SEQ', 'FPNOTINA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FORPAGTX_SEQ', 'FORPAGTX', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FORPAGCO_SEQ', 'FORPAGCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FORMPAGA_SEQ', 'FORMPAGA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FORMA_FARMA_SEQ', 'FORMA_FARMA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FOR_PAG_SEQ', 'FOR_PAG', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FLUXOFFP_SEQ', 'FLUXOFFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FATORPRECOMEDDISTRIB_SEQ', 'FATORPRECOMEDDISTRIB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FAIXAPER_SEQ', 'FAIXAPER', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('FABRICAN_SEQ', 'FABRICAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EXTREPRE_SEQ', 'EXTREPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EXPTO_SIP_SEQ', 'EXPTO_SIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EXCEC_PCTE_SEQ', 'EXCEC_PCTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVEPRESFP_SEQ', 'EVEPRESFP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENTORH_SEQ', 'EVENTORH', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENREPR_SEQ', 'EVENREPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENMOV_SEQ', 'EVENMOV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENIMP_SEQ', 'EVENIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENGRUP_SEQ', 'EVENGRUP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENFATU_SEQ', 'EVENFATU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENDESP_SEQ', 'EVENDESP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENCOPP_SEQ', 'EVENCOPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENCONTDE_SEQ', 'EVENCONTDE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENCONT_SEQ', 'EVENCONT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('EVENCOCM_SEQ', 'EVENCOCM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTUNEMP_SEQ', 'ESTUNEMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTSTFAT_SEQ', 'ESTSTFAT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTSITEN_SEQ', 'ESTSITEN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESTRSITU_SEQ', 'ESTRSITU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESPECIALIZ_PARTICIP_SEQ', 'ESPECIALIZ_PARTICIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESPECIALID_SEQ', 'ESPECIALID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESP_MED_SEQ', 'ESP_MED', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ESP_INADIM_SEQ', 'ESP_INADIM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERRO_SIP_SEQ', 'ERRO_SIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ERRO_GUIA_NEGADA_SEQ', 'ERRO_GUIA_NEGADA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ENTID_REGUL_DIRET_SEQ', 'ENTID_REGUL_DIRET', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ENDPRES_SEQ', 'ENDPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('ENDER_SIMUL_SEQ', 'ENDER_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZUSUARI_SEQ', 'DZUSUARI', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZUSEIMP_SEQ', 'DZUSEIMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZTRIGGERS_SEQ', 'DZTRIGGERS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZSUBROT_SEQ', 'DZSUBROT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZSUBCBO_SEQ', 'DZSUBCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZSISTEM_SEQ', 'DZSISTEM', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZSINCBO_SEQ', 'DZSINCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZROTINA_SEQ', 'DZROTINA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZPROGRA_SEQ', 'DZPROGRA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZMOEDA_SEQ', 'DZMOEDA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZLIBPRX_SEQ', 'DZLIBPRX', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZIMPRES_SEQ', 'DZIMPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZGRUUSU_SEQ', 'DZGRUUSU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZGRUPOS_SEQ', 'DZGRUPOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZGRUCBO_SEQ', 'DZGRUCBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZFAMICBO_SEQ', 'DZFAMICBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZESTADO_SEQ', 'DZESTADO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZESTABE_SEQ', 'DZESTABE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZEMPRE_SEQ', 'DZEMPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZDECPRO_SEQ', 'DZDECPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZCOTAC_SEQ', 'DZCOTAC', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZCONCID_SEQ', 'DZCONCID', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZCIDPRO_SEQ', 'DZCIDPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZBANCOS_SEQ', 'DZBANCOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZ9402CBO_SEQ', 'DZ9402CBO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZ_TEXTO_SEQ', 'DZ_TEXTO', 'PROGRESS_RECID');
commit;
prompt 1400 records committed...
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZ_CID10_SEQ', 'DZ_CID10', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DZ_CBO02_SEQ', 'DZ_CBO02', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DIRET_AUTORIZ_SEQ', 'DIRET_AUTORIZ', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESSOLPR_SEQ', 'DESSOLPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESPEPRO_SEQ', 'DESPEPRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESOCOPR_SEQ', 'DESOCOPR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESCPREST_SEQ', 'DESCPREST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DESCPLAN_SEQ', 'DESCPLAN', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEPSETSE_SEQ', 'DEPSETSE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEPARTA_SEQ', 'DEPARTA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DEC_COO_SEQ', 'DEC_COO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('DADOS_SIP_SEQ', 'DADOS_SIP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTBL_PROVIS_SEQ', 'CTBL_PROVIS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CTA_CTBL_REPAS_SEQ', 'CTA_CTBL_REPAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COPRESERV_SEQ', 'COPRESERV', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONVER_SETOR_FUNCAO_SEQ', 'CONVER_SETOR_FUNCAO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONVER_GRAU_PARNTSCO_SEQ', 'CONVER_GRAU_PARNTSCO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTROL_INTEGR_SEQ', 'CONTROL_INTEGR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTRDEF_SEQ', 'CONTRDEF', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTRAT_SIMUL_SEQ', 'CONTRAT_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTIPPL_SEQ', 'CONTIPPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONTAT_PESSOA_SIMUL_SEQ', 'CONTAT_PESSOA_SIMUL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONPRES_SEQ', 'CONPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONFIGUSUARACESSEMPRESAR_SEQ', 'CONFIGUSUARACESSEMPRESAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONFIG_AUDIT_CAD_SEQ', 'CONFIG_AUDIT_CAD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CONDSAUD_SEQ', 'CONDSAUD', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMUNIC_BNFCIAR_SEQ', 'COMUNIC_BNFCIAR', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMREPRE_SEQ', 'COMREPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMPGPRE_SEQ', 'COMPGPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COMCOPRE_SEQ', 'COMCOPRE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CODIGLOS_SEQ', 'CODIGLOS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COBINEST_SEQ', 'COBINEST', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('COBEINTE_SEQ', 'COBEINTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CMOVDATA_SEQ', 'CMOVDATA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLIPROVA_SEQ', 'CLIPROVA', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLIPREES_SEQ', 'CLIPREES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLINPRES_SEQ', 'CLINPRES', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLINICAS_SEQ', 'CLINICAS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLASSIF_CLIENTE_SEQ', 'CLASSIF_CLIENTE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLASSE_SEQ', 'CLASSE', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLASMENS_SEQ', 'CLASMENS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLASHOSP_SEQ', 'CLASHOSP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLASERRO_SEQ', 'CLASERRO', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLANTINT_SEQ', 'CLANTINT', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CLA_CUS_SEQ', 'CLA_CUS', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CHAVE_CONTROL_SEQ', 'CHAVE_CONTROL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CBOPCPL_SEQ', 'CBOPCPL', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CBO_ESP_SEQ', 'CBO_ESP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CBHPMAMB_SEQ', 'CBHPMAMB', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CBESPREP_SEQ', 'CBESPREP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CAMACOMP_SEQ', 'CAMACOMP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CALVENPP_SEQ', 'CALVENPP', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('CADAMAQU_SEQ', 'CADAMAQU', 'PROGRESS_RECID');
insert into TM_SEQUENCES (sequence_name, table_name, column_name)
values ('BONICABE_SEQ', 'BONICABE', 'PROGRESS_RECID');
commit;
prompt 1454 records loaded
prompt Enabling triggers for TM_SEQUENCES...
alter table TM_SEQUENCES enable all triggers;
set feedback on
set define on
prompt Done.
