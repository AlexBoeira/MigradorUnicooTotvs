/** Processo a ser executado continuamente como servico do Windows
  * Executar todos os processos de importacao em Progress do migrador Unicoo x GPS
  * Monitorar a fila "MC" Mirth Connect
  * Executar cada processo enquanto encontrar registros no status "MC" e prosseguir para o proximo
  * O loop eh infinito. Para parar o processo, basta parar o Servico do Windows (services.msc)
  */
 
repeat:
  RUN processo.
  pause(3).
  process events.
end.

procedure processo:
  /* PROPOSTAS */  
  PROCESS EVENTS.
  RUN cgp/cg0310x1.p("BATCH", /* in-batch-online */
                     "MC",
                     YES,     /* lg-registro-modulos */
                     3,       /* in-classif */
                     YES,     /* lg-registro-faixa */
                     YES,     /* lg-registro-negociacao */
                     yes,     /* lg-registro-cobertura */  
                     yes,     /* lg-registro-especifico */ 
                     yes,     /* lg-registro-procedimento */
                     0        /* qt-sair-aux */).
				
  /* BENEFICIARIOS */				
  PROCESS EVENTS.
  RUN cgp/cg0310v1.p("BATCH", /* in-batch-online */
                     "MC",
                     NO,      /* lg-plano */
                     NO,      /* lg-medocup */
                     YES,     /* lg-registro-modulos */
                     YES,     /* lg-registro-repasse */
                     3,       /* in-classif */  
                     0,       /* qt-sair-aux */
                     "A",   /* lg-ativos */
                     entry(3, in-param-aux)).  /* lg-cateira-antiga */
					 
end processo.
