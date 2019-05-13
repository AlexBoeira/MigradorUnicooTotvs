DEF VAR fluxo-juridico AS CHAR INIT "1.1.01.001" NO-UNDO.
DEF VAR fluxo-fisico   AS CHAR INIT "1.1.01.005" NO-UNDO.
    
FOR EACH clien_financ EXCLUSIVE-LOCK,
   FIRST contrat EXCLUSIVE-LOCK
   WHERE contrat.cd-contratante = clien_financ.cdn_cliente:

         IF clien_financ.cod_tip_fluxo_financ <> ""
         THEN ASSIGN contrat.char-16 = clien_financ.cod_tip_fluxo_financ.
         ELSE DO:
                IF contrat.in-tipo-pessoa = "F"
                THEN ASSIGN contrat.char-16                   = fluxo-fisico
                            clien_financ.cod_tip_fluxo_financ = fluxo-fisico.
                ELSE ASSIGN contrat.char-16                   = fluxo-juridico
                            clien_financ.cod_tip_fluxo_financ = fluxo-juridico.
              END.
END.

MESSAGE "concluido"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

