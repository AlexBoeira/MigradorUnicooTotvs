ASSIGN PROPATH = 'C:\migracao,' + PROPATH. 

def var lg-parar-processo as log no-undo. 

assign lg-parar-processo = no.
    
repeat:
    
      run cgp\cg0310x.p. 

   pause(10). 
/*
      run cgp\cg0310v.p.   
*/
   release paramecp. 

   for first paramecp fields(paramecp.u-log-1) no-lock:
       assign lg-parar-processo = paramecp.u-log-1.
   end.

   if  lg-parar-processo
   then leave. 

end.
