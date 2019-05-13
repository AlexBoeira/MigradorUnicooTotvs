etime(true).
find first guiautor /*use-index guiaut13*/
                             where guiautor.cd-unidade = 23
                               and guiautor.in-liberado-guias <> "6"                                                  
                               and guiautor.in-liberado-guias <> "30"                               
                                   no-lock no-error.      
message "milisegundos: " etime skip
        "segundos: " etime / 1000
        view-as alert-box.                                   
