-- carregar tempor�rias com guias de autoriza��o do Unicoo
-- Par�metro:
--   Data gera��o inicial - DD/MM/AAAA: se informado, considera apenas autoriza��es emitidas a partir dessa data; se nulo, considera todas;

--
/* OBSERVA��ES:
     cursores:
	   c_autorizacao: l� SERVICO_DA_AUTORIZACAO, EMISSAO_SERVICO_GUIA(outer join) e AUTORIZACAO, validando o par�metro da procedure.
               obs: caso seja necess�rio processar apenas uma autoriza��o isoladamente, para monitoramento, existe uma l�gica
                    comentada nesse cursor: "and (a.nrautorizacao = <NRAUTORIZACAO>)". Basta descomentar e compilar a PCK
     
	   c_ocorrencia_autorizacao: ocorr�ncia no Unicoo � equivalente � Glosa do GPS. Busca pelo c�digo;
	   c_servico_autorizacao: Busca pelo c�digo; busca SERVICO_DA_AUTORIZACAO mediante NRAUTORIZACAO recebida por par�metro;

   Numero autoriza��o - NUMBER: se informado, considera apenas essa autoriza��o (para testes isolados); se nulo, considera todas.
	 
	 neg�cio:
	   identificado que existem mais de 13 milh�es de AUTORIZACAO com CDSITUACAO 'AB' e que possuem relacionamento com EMISSAO_GUIA e
	   cerca de 1 milh�o de AUTORIZACAO.CDSITUACAO = 'AB' mas sem EMISSAO_GUIA. Aparentemente, o fato de gerar a emiss�o n�o muda a situa��o na AUTORIZACAO.
*/
begin


--  delete from gp.import_guia ig where ig.u##ind_sit_import in ('ER');


  pck_unicoogps.P_IMPORT_GUIA_AUTORIZACAO('01/01/2018');
end;

/* as instru��es abaixo somente devem ser utilizadas caso seja necess�rio eliminar os registros para novo processamento:
truncate table gp.IMPORT_GUIA; 
truncate table gp.IMPORT_GUIA_HISTOR;
truncate table gp.IMPORT_GUIA_SADT;
truncate table gp.IMPORT_GUIA_CON;
truncate table gp.IMPORT_GUIA_INTRCAO;
truncate table gp.IMPORT_ANEXO_SOLICIT;
truncate table gp.IMPORT_ANEXO_OPME;
truncate table gp.IMPORT_ANEXO_QUIMIO;
truncate table gp.IMPORT_ANEXO_RADIO;
truncate table gp.IMPORT_GUIA_MOVTO;
truncate table gp.IMPORT_MOVTO_GLOSA;

--sequences envolvidas (caso seja necess�rio recri�-las)
--sq_import_guia
--sq_import_guia_histor
--sq_import_guia_sadt
--sq_import_guia_con
--sq_import_guia_intrcao
--sq_import_anexo_solicit
--sq_import_anexo_opme
--sq_import_anexo_quimio
--sq_import_anexo_radio
--import_guia_movto_seq
--import_movto_glosa_seq

analyze table gp.IMPORT_GUIA       compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_GUIA_HISTOR      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_GUIA_SADT      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_GUIA_CON      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_GUIA_INTRCAO      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_ANEXO_SOLICIT      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_ANEXO_OPME      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_ANEXO_QUIMIO      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_ANEXO_RADIO      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_GUIA_MOVTO      compute statistics for table for all indexes for all indexed columns;
analyze table gp.IMPORT_MOVTO_GLOSA      compute statistics for table for all indexes for all indexed columns;

analyze table gp.erro_process_import      compute statistics for table for all indexes for all indexed columns;
analyze table gp.control_migrac      compute statistics for table for all indexes for all indexed columns;

truncate table gp.GUIAUTOR          ;
truncate table gp.GUIA_AUTORIZ_COMP ;
truncate table gp.GUIAINOD          ;
truncate table gp.GUIA_HIS          ;
truncate table gp.PROCGUIA          ;
truncate table gp.PROCED_GUIA_COMP  ;
truncate table gp.INSUGUIA          ;
truncate table gp.INSUMO_GUIA_COMP  ;
truncate table gp.MOVATGLO          ;
truncate table gp.OUT_UNI           ;
analyze table gp.GUIAUTOR               compute statistics for table for all indexes for all indexed columns;
analyze table gp.GUIA_AUTORIZ_COMP      compute statistics for table for all indexes for all indexed columns;
analyze table gp.GUIAINOD               compute statistics for table for all indexes for all indexed columns;
analyze table gp.GUIA_HIS               compute statistics for table for all indexes for all indexed columns;
analyze table gp.PROCGUIA               compute statistics for table for all indexes for all indexed columns;
analyze table gp.PROCED_GUIA_COMP       compute statistics for table for all indexes for all indexed columns;
analyze table gp.INSUGUIA               compute statistics for table for all indexes for all indexed columns;
analyze table gp.INSUMO_GUIA_COMP       compute statistics for table for all indexes for all indexed columns;
analyze table gp.MOVATGLO               compute statistics for table for all indexes for all indexed columns;
analyze table gp.OUT_UNI                compute statistics for table for all indexes for all indexed columns;
*/
--select * from guiautor
--select * from import_guia
