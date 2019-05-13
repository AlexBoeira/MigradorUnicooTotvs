/*
 * Evandro Levi (25/10/2017): Após execução deste script, as Regras de Mensalidades Padrão e de contratos devem ser migrados.
 * Objetos: PCK_UNICOOGPS.P_MIGRA_REGRA_ESTRUTURA  --Geração das Regras de Mensalidade Padrão
 *          PCK_UNICOOGPS.P_MIGRA_TABELA_PRECO     --Geração das Regras de Mensalidade dos Contratos
 *          PCK_UNICOOGPS.P_REGRA_DEFAULT_CONTRATO --Geração da Regra Default para contratos sem regra (regra apenas no Beneficiario)
 */
Connect GP; 
 
truncate table gp.REGRA_MENSLID;
truncate table gp.REGRA_MENSLID_CRITER;
truncate table gp.REGRA_MENSLID_PROPOST;
truncate table gp.REGRA_MENSLID_ESTRUT;
truncate table gp.REGRA_MENSLID_REAJ;

Drop Sequence gp.REGRA_MENSLID_SEQ;
Drop Sequence gp.REGRA_MENSLID_CRITER_SEQ;
Drop Sequence gp.REGRA_MENSLID_PROPOST_SEQ;
Drop Sequence gp.REGRA_MENSLID_ESTRUT_SEQ;
Drop Sequence gp.REGRA_MENSLID_REAJ_SEQ;

create sequence gp.REGRA_MENSLID_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence gp.REGRA_MENSLID_CRITER_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence gp.REGRA_MENSLID_PROPOST_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence gp.REGRA_MENSLID_ESTRUT_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

create sequence gp.REGRA_MENSLID_REAJ_SEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 1
increment by 1
cache 20;

Grant All On REGRA_MENSLID_SEQ To UNICOOGPS;
Grant All On REGRA_MENSLID_CRITER_SEQ To UNICOOGPS;
Grant All On REGRA_MENSLID_PROPOST_SEQ To UNICOOGPS;
Grant All On REGRA_MENSLID_ESTRUT_SEQ To UNICOOGPS;
Grant All On REGRA_MENSLID_REAJ_SEQ To UNICOOGPS;

analyze table gp.REGRA_MENSLID       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_CRITER       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_PROPOST       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_ESTRUT       compute statistics for table for all indexes for all indexed columns;
analyze table gp.regra_menslid_reaj       compute statistics for table for all indexes for all indexed columns;
analyze table falha_processo_regra_menslid compute statistics for table for all indexes for all indexed columns;

