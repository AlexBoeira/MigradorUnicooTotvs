connect gp;

truncate table unicoogps.temp_depara_lotacao;
truncate table IMPORT_PROPOST;
truncate table IMPORT_BNFCIAR;
truncate table IMPORT_MODUL_PROPOST;
truncate table IMPORT_MODUL_BNFCIAR;
truncate table IMPORT_NEGOCIAC_PROPOST;
truncate table IMPORT_ATENDIM_BNFCIAR;
truncate table IMPORT_NEGOCIAC_BNFCIAR;

truncate table import_lotac_propost;
truncate table IMPORTPADRCOBERTPROPOST;
truncate table IMPORT_CAMPOS_PROPOST;
truncate table IMPORT_FAIXA_PROPOST;
truncate table IMPORT_FUNCAO_PROPOST;
truncate table IMPORT_MO_PROPOST;
truncate table IMPORT_PROCED_PROPOST;
truncate table IMPORT_COBERT_BNFCIAR;

DROP SEQUENCE IMPORT_PROPOST_SEQ;
DROP SEQUENCE IMPORT_BNFCIAR_SEQ;
DROP SEQUENCE IMPORT_MODUL_PROPOST_SEQ;
DROP SEQUENCE IMPORT_MODUL_BNFCIAR_SEQ;
DROP SEQUENCE IMPORT_NEGOCIAC_PROPOST_SEQ;
DROP SEQUENCE IMPORT_ATENDIM_BNFCIAR_SEQ;
DROP SEQUENCE IMPORT_NEGOCIAC_BNFCIAR_SEQ;
drop sequence import_lotac_propost_seq;
drop sequence IMPORTPADRCOBERTPROPOST_seq;
drop sequence IMPORT_CAMPOS_PROPOST_seq;
drop sequence IMPORT_FAIXA_PROPOST_seq;
drop sequence IMPORT_FUNCAO_PROPOST_seq;
drop sequence IMPORT_MO_PROPOST_seq;
drop sequence IMPORT_PROCED_PROPOST_seq;
drop sequence IMPORT_COBERT_BNFCIAR_seq;

Create SEQUENCE import_lotac_propost_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORTPADRCOBERTPROPOST_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORT_CAMPOS_PROPOST_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORT_FAIXA_PROPOST_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORT_FUNCAO_PROPOST_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORT_MO_PROPOST_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORT_PROCED_PROPOST_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE IMPORT_COBERT_BNFCIAR_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;

Create SEQUENCE IMPORT_PROPOST_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE IMPORT_BNFCIAR_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE IMPORT_MODUL_PROPOST_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE IMPORT_MODUL_BNFCIAR_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;
  
Create SEQUENCE IMPORT_NEGOCIAC_PROPOST_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;
  
Create SEQUENCE IMPORT_ATENDIM_BNFCIAR_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE IMPORT_NEGOCIAC_BNFCIAR_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;
  
truncate table PROPOST;
truncate table TER_ADE;
truncate table PRO_PLA;
truncate table USUARIO;
truncate table SIT_APROV_PROPOSTA;
truncate table HISTABPRECO;

truncate table PROPUNIM;
truncate table CAR_IDE;
truncate table HIST_MOVTO_USUARIO;
truncate table HISTOR_OCOR_USUAR;
truncate table USUREATE;
truncate table USUREPAS;

truncate table propcopa;
truncate table audit_cad;
truncate table campprop;
truncate table histor_param_faturam;
truncate table hist_alter_gp;
truncate table hist_aprov_proposta;
truncate table hist_movto_usuario;
truncate table partic_limit;
truncate table propcart;
truncate table usumodu;
truncate table lotac_propost;
truncate table lotac;
truncate table teadgrpa;
truncate table usucaren;
truncate table gerac_cod_ident_propost;

DROP SEQUENCE PROPOST_SEQ;
DROP SEQUENCE TER_ADE_SEQ;
DROP SEQUENCE PRO_PLA_SEQ;
DROP SEQUENCE USUARIO_SEQ;
DROP SEQUENCE SIT_APROV_PROPOSTA_SEQ;
DROP SEQUENCE HISTABPRECO_SEQ;
DROP SEQUENCE PROPUNIM_SEQ;
Drop Sequence CAR_IDE_SEQ;
Drop Sequence HIST_MOVTO_USUARIO_SEQ;
Drop Sequence HISTOR_OCOR_USUAR_SEQ;
Drop Sequence USUREATE_SEQ;
Drop Sequence USUREPAS_SEQ;

drop sequence propcopa_seq;
drop sequence audit_cad_seq;
drop sequence campprop_seq;
drop sequence histor_param_faturam_seq;
drop sequence hist_alter_gp_seq;
drop sequence hist_aprov_proposta_seq;
drop sequence partic_limit_seq;
drop sequence propcart_seq;
drop sequence usumodu_seq;
drop sequence lotac_propost_seq;
drop sequence lotac_seq;
drop sequence teadgrpa_seq;
drop sequence usucaren_seq;
drop sequence gerac_cod_ident_propost_seq;


Create SEQUENCE propcopa_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE audit_cad_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE campprop_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE histor_param_faturam_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE hist_alter_gp_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE hist_aprov_proposta_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE hist_movto_usuario_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE partic_limit_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE propcart_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE usumodu_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE lotac_propost_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE lotac_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE teadgrpa_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE usucaren_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;
Create SEQUENCE gerac_cod_ident_propost_seq  minvalue 1  maxvalue 9999999999999999999999999999  start with 1 increment by 1  cache 20;

Create SEQUENCE PROPOST_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE TER_ADE_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE PRO_PLA_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE USUARIO_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE SIT_APROV_PROPOSTA_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE HISTABPRECO_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create SEQUENCE PROPUNIM_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create Sequence CAR_IDE_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create Sequence HISTOR_OCOR_USUAR_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create Sequence USUREATE_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Create Sequence USUREPAS_SEQ
  minvalue 1
  maxvalue 9999999999999999999999999999
  start with 1
  increment by 1
  cache 20;

Grant All on PROPOST_SEQ to UNICOOGPS;
Grant All on TER_ADE_SEQ to UNICOOGPS;
Grant All on PRO_PLA_SEQ to UNICOOGPS;
Grant All on USUARIO_SEQ to UNICOOGPS;
Grant All on SIT_APROV_PROPOSTA_SEQ to UNICOOGPS;
Grant All on HISTABPRECO_SEQ to UNICOOGPS;
Grant All on IMPORT_PROPOST_SEQ to UNICOOGPS;
Grant All on IMPORT_BNFCIAR_SEQ to UNICOOGPS;
Grant All on IMPORT_MODUL_PROPOST_SEQ to UNICOOGPS;
Grant All on IMPORT_MODUL_BNFCIAR_SEQ to UNICOOGPS;
Grant All on IMPORT_NEGOCIAC_PROPOST_SEQ to UNICOOGPS;
Grant All on IMPORT_ATENDIM_BNFCIAR_SEQ to UNICOOGPS;
Grant All on IMPORT_NEGOCIAC_BNFCIAR_SEQ to UNICOOGPS;
Grant All on PROPUNIM_SEQ to UNICOOGPS;
Grant All on CAR_IDE_SEQ to UNICOOGPS;
Grant All on HIST_MOVTO_USUARIO_SEQ to UNICOOGPS;
Grant All on HISTOR_OCOR_USUAR_SEQ to UNICOOGPS;
Grant All on USUREATE_SEQ to UNICOOGPS;
Grant All on USUREPAS_SEQ to UNICOOGPS;

grant all on import_lotac_propost_seq     to unicoogps;
grant all on IMPORTPADRCOBERTPROPOST_seq  to unicoogps;
grant all on IMPORT_CAMPOS_PROPOST_seq    to unicoogps;
grant all on IMPORT_FAIXA_PROPOST_seq     to unicoogps;
grant all on IMPORT_FUNCAO_PROPOST_seq    to unicoogps;
grant all on IMPORT_MO_PROPOST_seq        to unicoogps;
grant all on IMPORT_PROCED_PROPOST_seq    to unicoogps;
grant all on IMPORT_COBERT_BNFCIAR_seq    to unicoogps;

grant all on propcopa_seq                 to unicoogps;
grant all on audit_cad_seq                to unicoogps;
grant all on campprop_seq                 to unicoogps;
grant all on histor_param_faturam_seq     to unicoogps;
grant all on hist_alter_gp_seq            to unicoogps;
grant all on hist_aprov_proposta_seq      to unicoogps;
grant all on hist_movto_usuario_seq       to unicoogps;
grant all on partic_limit_seq             to unicoogps;
grant all on propcart_seq                 to unicoogps;
grant all on usumodu_seq                  to unicoogps;
grant all on lotac_propost_seq            to unicoogps;
grant all on lotac_seq                    to unicoogps;
grant all on teadgrpa_seq                 to unicoogps;
grant all on usucaren_seq                 to unicoogps;
grant all on gerac_cod_ident_propost_seq  to unicoogps;

analyze table unicoogps.TEMP_DEPARA_LOTACAO compute statistics for table for all indexes for all indexed columns;
analyze table GP.LOTAC compute statistics for table for all indexes for all indexed columns;

analyze table IMPORT_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_LOTAC_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_MODUL_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORTPADRCOBERTPROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_CAMPOS_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_FAIXA_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_FUNCAO_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_MO_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_NEGOCIAC_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_PROCED_PROPOST    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_MODUL_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_NEGOCIAC_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_ATENDIM_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table IMPORT_COBERT_BNFCIAR    compute statistics for table for all indexes for all indexed columns;
analyze table ERRO_PROCESS_IMPORT    compute statistics for table for all indexes for all indexed columns;

analyze table gp.PRO_PLA      compute statistics for table for all indexes for all indexed columns;
analyze table gp.TEADGRPA      compute statistics for table for all indexes for all indexed columns;
analyze table gp.PROPOST      compute statistics for table for all indexes for all indexed columns;
analyze table gp.LOTAC_PROPOST         compute statistics for table for all indexes for all indexed columns;
analyze table gp.TER_ADE       compute statistics for table for all indexes for all indexed columns;
analyze table gp.SIT_APROV_PROPOSTA      compute statistics for table for all indexes for all indexed columns;
analyze table gp.PROPCOPA       compute statistics for table for all indexes for all indexed columns;
analyze table gp.AUDIT_CAD       compute statistics for table for all indexes for all indexed columns;
analyze table gp.CAMPPROP    compute statistics for table for all indexes for all indexed columns;
analyze table gp.HISTABPRECO  compute statistics for table for all indexes for all indexed columns;
analyze table gp.HISTOR_PARAM_FATURAM  compute statistics for table for all indexes for all indexed columns;
analyze table gp.HIST_APROV_PROPOSTA compute statistics for table for all indexes for all indexed columns;
analyze table gp.PROPCART    compute statistics for table for all indexes for all indexed columns;
analyze table gp.PROPUNIM   compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_ESTRUT  compute statistics for table for all indexes for all indexed columns;
analyze table gp.GERAC_COD_IDENT_PROPOST      compute statistics for table for all indexes for all indexed columns;
analyze table gp.USUARIO      compute statistics for table for all indexes for all indexed columns;
analyze table gp.USUCAREN      compute statistics for table for all indexes for all indexed columns;
analyze table gp.USUMODU         compute statistics for table for all indexes for all indexed columns;
analyze table gp.CAR_IDE       compute statistics for table for all indexes for all indexed columns;
analyze table gp.USUREATE      compute statistics for table for all indexes for all indexed columns;
analyze table gp.USUREPAS       compute statistics for table for all indexes for all indexed columns;
analyze table gp.HIST_ALTER_GP       compute statistics for table for all indexes for all indexed columns;
analyze table gp.HIST_MOVTO_USUARIO    compute statistics for table for all indexes for all indexed columns;
analyze table gp.GERAC_COD_IDENT_BENEF  compute statistics for table for all indexes for all indexed columns;
