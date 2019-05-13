/**
 * Alex Boeira - 10/10/2018
 * Percorrer toda a tabela temporaria e criar/atualizar a tabela MOTIV-DEMIS (questionario de Demitido/Aposentado) 
 *
 * OBS: o processo de migracao ja faz essa acao. Esse script eh apenas para ajuste de base ja carregada antes da implementacao correspondente no cg0311v.p
 */

DEF BUFFER b-import-bnfciar FOR import-bnfciar.

FOR EACH b-import-bnfciar NO-LOCK:
    
   /* considerar apenas responsaveis */
   IF b-import-bnfciar.log-respons = FALSE THEN NEXT.

   /* quando preenchido indica que eh Aposentado/Demitido */
   IF b-import-bnfciar.dat-livre-2 <> ?
   THEN DO:
             find motiv-demis where motiv-demis.cdn-modalid = b-import-bnfciar.cd-modalidade
                                and motiv-demis.num-propost = b-import-bnfciar.nr-proposta
                                and motiv-demis.cdn-usuar   = b-import-bnfciar.num-livre-6
                                    exclusive-lock no-error.
             if not avail motiv-demis
             then do:                
                    create motiv-demis.
                    assign motiv-demis.cdn-modalid           = b-import-bnfciar.cd-modalidade
                           motiv-demis.num-propost           = b-import-bnfciar.nr-proposta  
                           motiv-demis.cdn-usuar             = b-import-bnfciar.num-livre-6.
             end.
            
             IF b-import-bnfciar.cod-livre-4 = "A" 
             THEN ASSIGN motiv-demis.log-exc-demis    = NO.  /* APOSENTADO */
             ELSE ASSIGN motiv-demis.log-exc-demis    = YES. /* DEMITIDO SEM JUSTA CAUSA */
    
             /* data desligamento                     inicio contribuicao*/
             IF b-import-bnfciar.dat-livre-3 <> ? AND b-import-bnfciar.dat-livre-4 <> ? 
             THEN motiv-demis.qtd-meses-contrib = INT((b-import-bnfciar.dat-livre-3 - b-import-bnfciar.dat-livre-4) / 30). /*arredonda a diferenca de dias para calcular nr meses*/
             ELSE motiv-demis.qtd-meses-contrib = 0.
    
             assign motiv-demis.log-enquad-artigo-22  = NO /* ciente que nao se enquadra no beneficio?            Homologado com cadastro Unimed NI */
                    motiv-demis.log-contrib-plano     = YES /* contribuia com o plano?                            Homologado com cadastro Unimed NI */
                    motiv-demis.log-mantem-plano      = YES /* optou por manter o plano?                          Homologado com cadastro Unimed NI */
                    motiv-demis.dat-comunic           = ? /*b-import-bnfciar.dat-livre-3*/ /*data de comunicacao do beneficio ao ex-empregado Homologado com cadastro Unimed NI*/
                    motiv-demis.dat-livre-1           = b-import-bnfciar.dat-livre-4 /*inicio da contribuicao */
                    motiv-demis.dat-livre-2           = b-import-bnfciar.dat-livre-3 /*fim da contribuicao        Homologado com cadastro Unimed NI*/
                    motiv-demis.dat-livre-3           = b-import-bnfciar.dat-livre-2 /* inicio do beneficio aposentado / demitido*/
                    motiv-demis.dat-livre-4           = b-import-bnfciar.dat-livre-5 /* fim do beneficio aposentado / demitido*/
                    motiv-demis.nom-arq-comunic       = ""                                                     /* Homologado com cadastro Unimed NI */
                    motiv-demis.nom-usuar-atualiz     = "migracao"
                    motiv-demis.dat-atualiz           = TODAY.
             release motiv-demis.
   END.
END.
