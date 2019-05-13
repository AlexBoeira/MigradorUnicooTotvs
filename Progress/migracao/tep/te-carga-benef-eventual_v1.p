/*
 * Essa vesao chama a BO de produto. Por desatualizacao de base de dados apresentou erro, portanto sera feita uma V2 que cria os registros diretamente*/
{rtp/rtrowerror.i}
def var h-handle-aux              as handle no-undo.
def var h-handle2-aux             as handle no-undo.
def var h-bosaueventualuser-aux            as handle no-undo.
def new shared var id-requisicao-handle-aux as char init "" no-undo.
def new global shared var v_cod_usuar_corren as char no-undo.

FOR EACH propost NO-LOCK:
    if propost.log-11 
    AND propost.cd-sit-proposta >= 5
    AND propost.cd-sit-proposta <= 7
    then do:
            h-handle-aux = session:last-procedure.
            do while valid-handle(h-handle-aux):
                
               if  h-handle-aux:type = "procedure"
               and h-handle-aux:name = "bosau/bosaueventualuser.p"
               then do:
                      if  id-requisicao-handle-aux  <> ""
                      and h-handle-aux:private-data  = id-requisicao-handle-aux
                      then do:
                             assign h-bosaueventualuser-aux = h-handle-aux.
                             leave.
                           end.
                    end.
               assign h-handle-aux = h-handle-aux:prev-sibling.
            end.
            
            if not valid-handle(h-handle-aux) 
            then do:
                   run bosau/bosaueventualuser.p persistent set h-bosaueventualuser-aux .
                       
                       if length (string (etime)) > 10
                              then etime (yes).        
                       
                       if id-requisicao-handle-aux = ""
                   then id-requisicao-handle-aux = string (etime) + string (random (1, 9999)).
            
                   h-bosaueventualuser-aux:private-data = id-requisicao-handle-aux.
                 end.

           run syncEventualUser in h-bosaueventualuser-aux(input propost.cd-modalidade,   
                                                           input propost.nr-proposta,     
                                                           input-output table rowErrors) no-error.
           
           if error-status:error 
           then 
             MESSAGE "Nao foi possivel criar o Usuario Eventual" VIEW-AS ALERT-BOX.

           /*HDDELPERSIS.I*/
           if id-requisicao-handle-aux <> ""
           then do:
                  h-handle-aux = session:last-procedure.
                  do while valid-handle(h-handle-aux):

                     h-handle2-aux = h-handle-aux:prev-sibling.

                     if h-handle-aux:private-data = id-requisicao-handle-aux
                     then do:

                            delete procedure h-handle-aux.

                          end.

                     assign h-handle-aux = h-handle2-aux.

                  end.
                end.

           assign id-requisicao-handle-aux = "".

           /*FIM DE HDDELPERSIS.I*/

         end.
END.
