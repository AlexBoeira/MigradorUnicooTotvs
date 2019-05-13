
DEF BUFFER b-usuario FOR usuario.
DEF BUFFER b-import-bnfciar FOR import-bnfciar.

FOR EACH import-bnfciar WHERE NUM-SEQCIAL-CONTROL = 8248806:

    FOR EACH b-import-bnfciar
        WHERE b-import-bnfciar.cd-carteira-origem-responsavel = import-bnfciar.cd-carteira-origem-responsavel
          AND b-import-bnfciar.cd-carteira-origem-responsavel = b-import-bnfciar.cd-carteira-antiga:

        MESSAGE b-import-bnfciar.num-seqcial-control SKIP
                b-import-bnfciar.nr-contrato-antigo skip
                b-import-bnfciar.nom-usuar skip
                b-import-bnfciar.cd-carteira-antiga SKIP(1)
                import-bnfciar.num-seqcial-control SKIP
                import-bnfciar.nr-contrato-antigo SKIP
                import-bnfciar.nom-usuar SKIP
                import-bnfciar.cd-carteira-antiga 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.


    END.

    /*FIND first usuario 
         where usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-origem-responsavel NO-LOCK.

    MESSAGE 
            
    import-bnfciar.cd-carteira-origem-responsavel SKIP
    import-bnfciar.cd-carteira-antiga SKIP
        import-bnfciar.log-respons SKIP
        CAN-FIND (first usuario where usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-origem-responsavel) SKIP
        usuario.cd-modalidade SKIP
        usuario.nr-proposta SKIP
        usuario.cd-usuario
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

    FOR each propost USE-INDEX propo24
        WHERE propost.nr-contrato-antigo = import-bnfciar.nr-contrato-antigo NO-LOCK:

        MESSAGE "proposta:" skip
                propost.cd-modalidade SKIP
                propost.nr-proposta
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    END.
    */

    /*ASSIGN import-bnfciar.ind-sit-import = 'RC'.*/
END.


