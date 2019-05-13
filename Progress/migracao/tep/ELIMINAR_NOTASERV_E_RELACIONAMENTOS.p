DEF BUFFER b-notaserv FOR notaserv.

OUTPUT TO c:\temp\notaserv.csv.

bl-trans:
DO TRANSACTION:
    FOR EACH notaserv
         where notaserv.cd-modalidade         = 20
           and notaserv.nr-ter-adesao         = 625
           and notaserv.aa-referencia         = 2018
           and notaserv.mm-referencia         = 4 
           AND notaserv.nr-fatura             = 0
        exclusive-lock:
    
         /* ------------------------------------------------------------------------ */
    
        for each fatueven where
                 fatueven.cd-modalidade         = notaserv.cd-modalidade
             and fatueven.cd-contratante        = notaserv.cd-contratante
             and fatueven.cd-contratante-origem = notaserv.cd-contratante-origem
             and fatueven.nr-ter-adesao         = notaserv.nr-ter-adesao
             and fatueven.aa-referencia         = notaserv.aa-referencia
             and fatueven.mm-referencia         = notaserv.mm-referencia
             and fatueven.nr-sequencia          = notaserv.nr-sequencia:
     
            for each fatgrmod where
                     fatgrmod.cd-modalidade         = notaserv.cd-modalidade 
                 and fatgrmod.cd-contratante        = notaserv.cd-contratante
                 and fatgrmod.cd-contratante-origem = notaserv.cd-contratante-origem
                 and fatgrmod.nr-ter-adesao         = notaserv.nr-ter-adesao 
                 and fatgrmod.aa-referencia         = notaserv.aa-referencia 
                 and fatgrmod.mm-referencia         = notaserv.mm-referencia 
                 and fatgrmod.nr-sequencia          = notaserv.nr-sequencia:
                     
                for each fatsemreaj
                    where fatsemreaj.cd-modalidade         = fatgrmod.cd-modalidade
                      and fatsemreaj.cd-contratante        = fatgrmod.cd-contratante
                      and fatsemreaj.cd-contratante-origem = fatgrmod.cd-contratante-origem
                      and fatsemreaj.nr-ter-adesao         = fatgrmod.nr-ter-adesao
                      and fatsemreaj.aa-referencia         = fatgrmod.aa-referencia
                      and fatsemreaj.mm-referencia         = fatgrmod.mm-referencia
                      and fatsemreaj.nr-sequencia          = fatgrmod.nr-sequencia
                      and fatsemreaj.ch-evento-grau-modulo = fatgrmod.ch-evento-grau-modulo:
    
                      delete fatsemreaj.
                end.
                
                delete fatgrmod.
            end.
    
            /* --- Leitura dos registros da vlbenef para eliminar
               valores dos beneficiarios ------------------------------------------------- */
            for each vlbenef where vlbenef.cd-modalidade         = notaserv.cd-modalidade         
                               and vlbenef.cd-contratante        = notaserv.cd-contratante        
                               and vlbenef.cd-contratante-origem = notaserv.cd-contratante-origem 
                               and vlbenef.nr-ter-adesao         = notaserv.nr-ter-adesao 
                               and vlbenef.aa-referencia         = notaserv.aa-referencia                 
                               and vlbenef.mm-referencia         = notaserv.mm-referencia
                               and vlbenef.nr-sequencia          = notaserv.nr-sequencia
                               exclusive-lock:
    
    
               delete vlbenef.
    
            end.
     
            for each fatgrunp where
                     fatgrunp.cd-modalidade         = notaserv.cd-modalidade 
                 and fatgrunp.cd-contratante        = notaserv.cd-contratante
                 and fatgrunp.cd-contratante-origem = notaserv.cd-contratante-origem
                 and fatgrunp.nr-ter-adesao         = notaserv.nr-ter-adesao 
                 and fatgrunp.aa-referencia         = notaserv.aa-referencia 
                 and fatgrunp.mm-referencia         = notaserv.mm-referencia 
                 and fatgrunp.nr-sequencia          = notaserv.nr-sequencia:
                     delete fatgrunp.
            end.
            
            delete fatueven.
        end.
     
        for each evenprog where
                 evenprog.cd-modalidade          = notaserv.cd-modalidade 
             and evenprog.cd-contratante         = notaserv.cd-contratante
             and evenprog.cd-contratante-origem  = notaserv.cd-contratante-origem
             and evenprog.nr-ter-adesao          = notaserv.nr-ter-adesao 
             and evenprog.aa-referencia          = notaserv.aa-referencia 
             and evenprog.mm-referencia          = notaserv.mm-referencia 
             and evenprog.nr-sequencia           = notaserv.nr-sequencia:
     
           assign evenprog.cd-contratante        = 0
                  evenprog.cd-contratante-origem = 0
                  evenprog.nr-sequencia          = 0.
        end.
     
        for each event-progdo-bnfciar where
                 event-progdo-bnfciar.cd-modalidade          = notaserv.cd-modalidade 
             and event-progdo-bnfciar.nr-ter-adesao          = notaserv.nr-ter-adesao 
             and event-progdo-bnfciar.aa-referencia          = notaserv.aa-referencia 
             and event-progdo-bnfciar.mm-referencia          = notaserv.mm-referencia 
             and event-progdo-bnfciar.nr-sequencia           = notaserv.nr-sequencia:
     
         assign event-progdo-bnfciar.nr-sequencia          = 0
                event-progdo-bnfciar.cd-contratante        = 0
                event-progdo-bnfciar.cd-contratante-origem = 0.
        end.
     
        /* ------------------------------------ EVENTO PROGRAMADO POR PERCENTUAL --- */
        for each eveprper where
                 eveprper.cd-modalidade          = notaserv.cd-modalidade 
             and eveprper.cd-contratante         = notaserv.cd-contratante
             and eveprper.cd-contratante-origem  = notaserv.cd-contratante-origem
             and eveprper.nr-ter-adesao          = notaserv.nr-ter-adesao 
             and eveprper.aa-referencia          = notaserv.aa-referencia 
             and eveprper.mm-referencia          = notaserv.mm-referencia 
             and eveprper.nr-sequencia           = notaserv.nr-sequencia:
     
           assign eveprper.cd-contratante        = 0
                  eveprper.cd-contratante-origem = 0
                  eveprper.nr-sequencia          = 0.
        end.
        
    
        /* ------------ EVENTO PROGRAMADO POR PERCENTUAL SOBRE EVENTOS DA NOTA --- */
        for each eveperev where
                 eveperev.cd-modalidade          = notaserv.cd-modalidade
             and eveperev.cd-contratante         = notaserv.cd-contratante
             and eveperev.cd-contratante-origem  = notaserv.cd-contratante-origem
             and eveperev.nr-ter-adesao          = notaserv.nr-ter-adesao
             and eveperev.aa-referencia          = notaserv.aa-referencia  
             and eveperev.mm-referencia          = notaserv.mm-referencia 
             and eveperev.nr-sequencia           = notaserv.nr-sequencia:
     
           assign eveperev.cd-contratante        = 0
                  eveperev.cd-contratante-origem = 0
                  eveperev.nr-sequencia          = 0.
        end.
        
        for each  antitns
            where antitns.cd-modalidade         = notaserv.cd-modalidade
              and antitns.cd-contratante        = notaserv.cd-contratante
              and antitns.cd-contratante-origem = notaserv.cd-contratante-origem
              and antitns.nr-ter-adesao         = notaserv.nr-ter-adesao
              and antitns.aa-referencia         = notaserv.aa-referencia
              and antitns.mm-referencia         = notaserv.mm-referencia
              and antitns.nr-sequencia          = notaserv.nr-sequencia
                  exclusive-lock:
                   /*------------------------------------ DELETA ANTITNS --- */
                   delete antitns.
        end.
    
        for each usu-negoc 
           where usu-negoc.cd-modalidade = notaserv.cd-modalidade
             and usu-negoc.nr-ter-adesao = notaserv.nr-ter-adesao
             and usu-negoc.aa-referencia = notaserv.aa-referencia
             and usu-negoc.mm-referencia = notaserv.mm-referencia
             and usu-negoc.lg-diluicao   = yes
                 exclusive-lock:
    
            assign usu-negoc.aa-referencia-fat = 0
                   usu-negoc.mm-referencia-fat = 0.
    
        end.
        
        export DELIMITER ";" notaserv.
        delete notaserv.
    END. /* for */
    
/*    UNDO bl-trans, RETURN.*/
END.

OUTPUT CLOSE.
