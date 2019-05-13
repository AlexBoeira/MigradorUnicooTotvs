def var in-status-aux   as char          no-undo.
assign  in-status-aux = "RC".

DISP "IMPORTANDO PROPOSTAS STATUS:" in-status-aux.
PAUSE(0).

RUN cgp/cg0310x1.p("ONLINE", /* in-batch-online */
                   in-status-aux,
                   YES,      /* lg-registro-modulos */
                   3,        /* in-classif */
                   YES,      /* lg-registro-faixa */
                   YES,      /* lg-registro-negociacao */
                   yes,      /* lg-registro-cobertura */  
                   yes,      /* lg-registro-especifico */ 
                   yes,      /* lg-registro-procedimento */
                   0         /* qt-sair-aux */).
