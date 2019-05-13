/**
 * in-param-aux: esse parametro eh enviado pelo chamador, que eh um arquivo.bat
 *    entry 1: situacao a ser tratada pela importacao (0, 1, 2, etc)
 *    entry 2: se deve processar apenas beneficiarios Ativos (AT); Ambos (A); somente Inativos (I);
 *    entry 3: se deve criar a carteira do usuario com o valor da Carteira Antiga (S) ou montar pelo padrao do GPS (N);
 *    entry 4: 'S' para executar continuamente; 'N' para percorrer os registros da situacao solicitada e sair;
 */
DEF VAR in-param-aux AS CHAR NO-UNDO.
ASSIGN  in-param-aux = session:param.

/*verificar se ha algo na fila para ser processado. Se nao tiver, nao chamar a proxima etapa*/
def var qt-sit-aux as int no-undo.
select count(*) into qt-sit-aux from import-bnfciar where import-bnfciar.ind-sit-import = entry(1, in-param-aux).
if qt-sit-aux > 0
then do:
		REPEAT:
		  PROCESS EVENTS.
		  RUN cgp/cg0310v1.p("BATCH", /* in-batch-online */
							 entry(1, in-param-aux),
							 NO,      /* lg-plano */
							 NO,      /* lg-medocup */
							 YES,     /* lg-registro-modulos */
							 YES,     /* lg-registro-repasse */
							 3,       /* in-classif */  
							 0,       /* qt-sair-aux */
							 entry(2, in-param-aux),   /* lg-ativos */
							 entry(3, in-param-aux)).  /* lg-cateira-antiga */
		  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
		  or entry(4, in-param-aux) = "N"
		  THEN LEAVE.
		  ELSE PAUSE(1).
		END.
end.		
QUIT.
