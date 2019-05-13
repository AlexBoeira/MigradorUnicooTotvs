/******************************************************************************
    Programa .....: at0210a.i
    Data .........: 18/05/2015
    Empresa ......: TOTVS
    Cliente ......: Unimed Joao Pessoa
    Programador ..: Jeferson Dal Molin
    Objetivo .....: Migracao das guias de autorizacao do Unicoo para o GPS
*-----------------------------------------------------------------------------*/

procedure grava-erro:

    def input parameter num-seqcial-control-par as integer no-undo.
    def input parameter nom-tab-orig-erro-par   as char    no-undo.
    def input parameter des-erro-par            as char    no-undo.
    def input parameter dat-erro-par            as date    no-undo.
    def input parameter des-ajuda-par           as char    no-undo.

    def var nr-seq-aux                          as int     no-undo.

    /* ------------------------------------------------------------------------- */
/*    select max(erro-process-import.num-seqcial) into nr-seq-aux 
           from erro-process-import 
           where erro-process-import.num-seqcial-control = num-seqcial-control-par.*/
    nr-seq-aux = next-value(erro-process-import-seq).

    if nr-seq-aux = ?
    or nr-seq-aux = 0
    then assign nr-seq-aux = 1.
    else assign nr-seq-aux = nr-seq-aux + 1.

    /**
     * Garantir unicidade da chave.
     */
    create erro-process-import.
    REPEAT:
        assign erro-process-import.num-seqcial         = nr-seq-aux
               erro-process-import.num-seqcial-control = num-seqcial-control-par NO-ERROR.
        VALIDATE erro-process-import NO-ERROR.
        IF ERROR-STATUS:ERROR
        OR ERROR-STATUS:NUM-MESSAGES > 0
        THEN do:
               ASSIGN nr-seq-aux = nr-seq-aux + 1.
               PAUSE(1). /* aguarda 1seg e busca novamente o proximo nr livre.*/
             END.
        else leave.    /* o nr gerado eh valido. continua o processo.*/
    END.
    
/*    validate erro-process-import.
    release erro-process-import.*/
    /* ------------------------------------------------------------------------- */

    ASSIGN lg-erro-guia-aux = true.
/*
    create erro-process-import.
    assign erro-process-import.num-seqcial         = nr-seq-aux
           erro-process-import.num-seqcial-control = num-seqcial-control-par
*/
    assign
           erro-process-import.nom-tab-orig-erro   = nom-tab-orig-erro-par
           erro-process-import.des-erro            = des-erro-par
           erro-process-import.dat-erro            = dat-erro-par
           erro-process-import.des-ajuda           = des-ajuda-par.

    validate erro-process-import.
    release erro-process-import.

    IF in-batch-online-par = "ONLINE"
    THEN DO:
            create tmp-erro.
            assign tmp-erro.num-seqcial         = nr-seq-aux
                   tmp-erro.num-seqcial-control = num-seqcial-control-par
                   tmp-erro.nom-tab-orig-erro   = nom-tab-orig-erro-par
                   tmp-erro.des-erro            = des-erro-par
                   tmp-erro.dat-erro            = dat-erro-par
                   tmp-erro.des-ajuda           = des-ajuda-par.
            validate tmp-erro.
            release tmp-erro.
         END.

end procedure.
