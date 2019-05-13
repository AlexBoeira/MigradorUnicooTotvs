def var cd-cont-com  as int no-undo. 
def var cd-cont-sem  as int no-undo.  
DEF VAR cd-int-aux   AS INT NO-UNDO. 
def var h-bosaueventualuser-aux               as handle no-undo.

DEF VAR cont AS INT NO-UNDO. 
{rtp/rtrowerror.i}
{hdp/hdrunpersis.iv "new"}


{hdp/hdrunpersis.i "bosau/bosaueventualuser.p" "h-bosaueventualuser-aux"}

DEF NEW GLOBAL SHARED  VAR v_cod_usuar_corren AS CHAR NO-UNDO. 

ASSIGN v_cod_usuar_corren = 'super'. 

                               
FOR EACH propost WHERE propost.u-log-3
                NO-LOCK QUERY-TUNING(NO-INDEX-HINT) :

    cd-cont-com = cd-cont-com + 1.
    

    /*FOR FIRST usuario WHERE usuario.cd-modalidade = propost.cd-modalidade
                        AND usuario.nr-proposta   = propost.nr-proposta 
                        AND usuario.LOG-17 = YES NO-LOCK QUERY-TUNING(NO-INDEX-HINT): END.

    IF AVAIL usuario THEN NEXT.*/

    ASSIGN cd-cont-sem = cd-cont-sem + 1
           cd-int-aux  = cd-int-aux + 1. 


    EMPTY TEMP-TABLE rowErrors. 
    run syncEventualUser in h-bosaueventualuser-aux(input propost.cd-modalidade,   
                                                    INPUT propost.nr-proposta,     
                                                    input-output table rowErrors) no-error.
           
    if error-status:error 
    then run pi-grava-erro ("NÆo foi poss¡vel criar o Usu rio Eventual").

    FOR FIRST rowErrors NO-LOCK:
        RUN pi-grava-erro (INPUT rowErrors.errorDescription). 
    END.

    IF cd-int-aux > 10 
    THEN LEAVE. 


END.

MESSAGE cd-cont-com SKIP 
        cd-cont-sem
    VIEW-AS ALERT-BOX INFO BUTTONS OK.


PROCEDURE pi-grava-erro:
 DEF INPUT PARAMETER ds-mensagem-aux AS CHAR NO-UNDO. 

 OUTPUT TO c:\temp\erros-mig-usu-event-1.txt APPEND.
      PUT UNFORM  ds-mensagem-aux SKIP. 
 OUTPUT CLOSE. 
END PROCEDURE. 


