DEF NEW GLOBAL SHARED VAR statusProcess AS CHAR NO-UNDO. 

define temp-table tt-raw-digita
    field raw-digita as raw.

define temp-table tt-param
    field destino                        as int
    field arquivo                        as char
    field usuario                        as char
    field data-exec                      as date
    field hora-exec                      as int
    field parametro                      as log
    field formato                        as int
    field v_num_tip_aces_usuar           as int
    field ep-codigo                      as char
    field cd-modalidade-ini              as int 
    field cd-modalidade-fim              as int
    field nr-proposta-ini                as int 
    field nr-proposta-fim                as int 
    field cd-plano-ini                   as int 
    field cd-plano-fim                   as int 
    field cd-tipo-plano-ini              as int 
    field cd-tipo-plano-fim              as int
    field dt-proposta-ini                as date
    field dt-proposta-fim                as date
    field nr-insc-ini                    as dec
    field nr-insc-fim                    as dec
    field lg-analise                     as log 
    field lg-aprova                      as log
    field cd-sit-cred                    as int
    field lg-mantem-senha-benef          as log
    field in-gera-senha                  as int
    field dt-minima-termo                as date
    field in-geracao-senha               as int
    field lg-imp-carteira                as log.



ASSIGN PROPATH = 'C:\migracao,' + PROPATH. 

def var lg-parar-processo as log no-undo. 

assign lg-parar-processo = no.


/*-----------LOGICA DO PROCESSO --------------------------*/


UPDATE statusProcess. 
    
repeat:
   
/*   run cgp\cg0310x.p. 

   pause(5). 

   run cgp\cg0310v.p.   


   pause(5).
*/

   message " Gerando Termo de Adesao...".

   run p-roda-processo-termo (input 0,
                              input 0).

   release paramecp. 

   for first paramecp fields(paramecp.u-log-1) no-lock:
       assign lg-parar-processo = paramecp.u-log-1.
   end.

 
    pause(5).
   
end.

/*-------------- FIM LOGICA DO PROCESSO --------------------*/


procedure p-roda-processo-termo:
def input parameter cd-modalidade-aux as int no-undo. 
def input parameter nr-proposta-aux   as int no-undo.

def var raw-param                              as raw                 no-undo.
find first paramecp no-lock no-error. 

create tt-param.
assign tt-param.usuario                  = 'super'
       tt-param.destino                  = 1
       tt-param.data-exec                = today
       tt-param.hora-exec                = time
       tt-param.parametro                = yes
       tt-param.formato                  = 2
       tt-param.ep-codigo                = paramecp.ep-codigo
       tt-param.cd-modalidade-ini        = 0
       tt-param.cd-modalidade-fim        = 99
       tt-param.nr-proposta-ini          = 0
       tt-param.nr-proposta-fim          = 99999999 
       tt-param.cd-plano-ini             = 0
       tt-param.cd-plano-fim             = 99
       tt-param.cd-tipo-plano-ini        = 0
       tt-param.cd-tipo-plano-fim        = 99
       tt-param.dt-proposta-ini          = 01/01/1900
       tt-param.dt-proposta-fim          = 12/31/9999
       tt-param.nr-insc-ini              = 0
       tt-param.nr-insc-fim              = 99999999
       tt-param.lg-analise               = yes
       tt-param.lg-aprova                = yes
       tt-param.cd-sit-cred              = 1
       tt-param.in-gera-senha            = 1
       tt-param.dt-minima-termo          = 02/29/2016
       tt-param.lg-imp-carteira          = yes.


if cd-modalidade-aux  <> 0
and nr-proposta-aux   <> 0   
then assign tt-param.cd-modalidade-ini        = cd-modalidade-aux
            tt-param.cd-modalidade-fim        = cd-modalidade-aux
            tt-param.nr-proposta-ini          = nr-proposta-aux
            tt-param.nr-proposta-fim          = nr-proposta-aux.


raw-transfer tt-param    to raw-param.
run api/api-gera-carteira.p (input raw-param,
                                   input table tt-raw-digita).

end procedure. 
