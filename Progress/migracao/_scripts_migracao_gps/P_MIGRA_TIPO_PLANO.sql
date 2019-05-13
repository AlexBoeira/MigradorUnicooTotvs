/** carrega as seguintes tabelas:
 select * from gp.TI_PL_SA
 select * from gp.PAD_COB
 select * from gp.PADR_COBERT_PLANO_ANS
 select * from gp.REG_PLANO_SAUDE
 select * from TM_ERROS_ESTRUTURA
*/ 
/** caso seja necessário reprocessar essa etapa, descomentar esse trecho para limpar as tabelas:
truncate table gp.ti_pl_sa;
truncate table gp.pad_cob;
truncate table gp.padr_cobert_plano_ans;
truncate table gp.reg_plano_saude;
truncate table gp.tm_erros_estrutura;
analyze table GP.ti_pl_sa compute statistics for table for all indexes for all indexed columns;
analyze table GP.pad_cob compute statistics for table for all indexes for all indexed columns;
analyze table GP.padr_cobert_plano_ans compute statistics for table for all indexes for all indexed columns;
analyze table GP.reg_plano_saude compute statistics for table for all indexes for all indexed columns;
analyze table GP.tm_erros_estrutura compute statistics for table for all indexes for all indexed columns;
*/

begin
       pck_unicoogps.p_migra_tipo_plano;
end;
