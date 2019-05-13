DEF VAR ix-cont-aux AS INT NO-UNDO.

FOR EACH import-bnfciar exclusive-lock
   WHERE import-bnfciar.ind-sit-import = "ER",
    EACH import-modul-bnfciar EXCLUSIVE-LOCK
   WHERE import-modul-bnfciar.num-seqcial-bnfciar = import-bnfciar.num-seqcial-bnfciar
     AND import-modul-bnfciar.dat-inic < import-bnfciar.dt-inclusao-plano:

         ASSIGN ix-cont-aux = ix-cont-aux + 1
                import-modul-bnfciar.dat-inic = import-bnfciar.dt-inclusao-plano
                import-bnfciar.ind-sit-import = "RC".
         PROCESS EVENTS.
END.

MESSAGE ix-cont-aux
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*
                   if   import-modul-bnfciar.dat-inic < propost.dt-proposta
               then do:
                      RUN pi-cria-tt-erros("Data de Inicio do Modulo menor que data da Proposta ").
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               if import-modul-bnfciar.dat-inic < import-bnfciar.dt-inclusao-plano
               then do:
                      RUN pi-cria-tt-erros("Data de inicio do modulo nao pode ser inferior a inclusao do beneficiario").
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.

               if import-modul-bnfciar.dat-inic < pro-pla.dt-inicio
               then do:
                      RUN pi-cria-tt-erros("Data de inicio do modulo opcional do beneficiario nao pode ser inferior a data de inicio do modulo da proposta").
                      assign lg-relat-erro  = yes
                             lg-modulo-erro = yes.
                    end.
*/

