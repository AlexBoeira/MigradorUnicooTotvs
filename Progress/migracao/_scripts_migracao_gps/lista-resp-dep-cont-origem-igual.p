DEF BUFFER b-usuario FOR usuario.
DEF BUFFER b-import-bnfciar FOR import-bnfciar.

OUTPUT TO c:\temp\cont-antigo-igual.csv.
/**
 * Varrer todos os responsaveis com seus dependentes e listar quando o contrato antigo for igual.
 */
FOR EACH b-import-bnfciar WHERE b-import-bnfciar.cd-carteira-origem-responsavel = b-import-bnfciar.cd-carteira-antiga NO-LOCK,
    EACH import-bnfciar NO-LOCK
   WHERE import-bnfciar.cd-carteira-origem-responsavel = b-import-bnfciar.cd-carteira-origem-responsavel
     AND import-bnfciar.nr-contrato-antigo = b-import-bnfciar.nr-contrato-antigo:

         PUT UNFORMATTED b-import-bnfciar.cd-carteira-origem-responsavel ";"
                         b-import-bnfciar.nr-contrato-antigo ";"
                         b-import-bnfciar.nom-usuar ";"
                         import-bnfciar.cd-carteira-antiga ";"
                         import-bnfciar.nr-contrato-antigo ";"
                         import-bnfciar.nom-usuar SKIP.
                         
    /*

        MESSAGE "seq:"          b-import-bnfciar.num-seqcial-control SKIP
                "contr.antigo:" b-import-bnfciar.nr-contrato-antigo skip
                "nome:"         b-import-bnfciar.nom-usuar skip
                "carteira:"     b-import-bnfciar.cd-carteira-antiga SKIP(1)
                "seq:"          import-bnfciar.num-seqcial-control SKIP
                "contr.antigo:" import-bnfciar.nr-contrato-antigo SKIP
                "nome:"         import-bnfciar.nom-usuar SKIP
                "carteira:"     import-bnfciar.cd-carteira-antiga 
            VIEW-AS ALERT-BOX INFO BUTTONS OK.*/



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

OUTPUT CLOSE.

