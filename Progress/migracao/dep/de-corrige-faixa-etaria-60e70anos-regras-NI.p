define variable ix as int no-undo.
define buffer b for regra-menslid-criter.
define var cod-seq  as DEC NO-UNDO.

/* logica para executar apos concluir montagem das regras*/
/* DEF VAR ix-count AS INT NO-UNDO.                      */
/* REPEAT :                                              */
/*     SELECT COUNT(*) INTO ix-count FROM regra-menslid. */
/*                                                       */
/*     IF TODAY =  1/2/19                                */
/*     AND STRING(TIME,"HH:MM") >= "22:00"               */
/*     AND ix-count > 100000                             */
/*     THEN LEAVE.                                       */
/*     PAUSE(60).                                        */
/* END.                                                  */

for each regra-menslid no-lock:

    ix = 0.
    
    for each regra-menslid-criter no-lock
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999"):
         ix = ix + 1.         
         
         /*achar dois ja eh suficiente para nao varrer mais*/
         if ix > 1 then leave.
    end.
    
    if ix > 1 then next.
    
    select max(regra-menslid-criter.cdd-id) into cod-seq from regra-menslid-criter.
        if cod-seq = ? then cod-seq = 0.
        cod-seq = cod-seq + 1.
    
    ix = 0.
    /*Para as regras que s¢ tem um criterio, quero ver s¢ as que sÆo de 60 ou 70 anos*/
    for each regra-menslid-criter no-lock
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999")
        and (   regra-menslid-criter.nr-idade-minima = 60 OR regra-menslid-criter.nr-idade-minima = 70 
             OR regra-menslid-criter.nr-idade-minima = 61 OR regra-menslid-criter.nr-idade-minima = 71):
         ix = ix + 1.         
         
    end.
    
    /* se nao achar a regra dos 60 ou 70 anos sai fora */
    if ix = 0 then next.
    
    /*Para as regras que s¢ tem um criterio, quero ver s¢ as que sÆo de 60 ou 70 anos*/
    /*for each regra-menslid-criter NO-LOCK
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999")
         and regra-menslid-criter.nr-idade-minima = 60:
         ix = ix + 1.         
         
         create b.
         buffer-copy regra-menslid-criter
            except cdd-id
                   nr-faixa-etaria
                   nr-idade-minima
                   nr-idade-maxima
         to b.
         assign b.cdd-id = cod-seq
                b.nr-faixa-etaria = regra-menslid-criter.nr-faixa-etaria + 1
                b.nr-idade-minima = 0
                b.nr-idade-maxima = 59
                b.cod-usuar-ult-atualiz = "criadoCargaFaixa".

    end.

    /*Para as regras que s¢ tem um criterio, quero ver s¢ as que sÆo de 70 anos*/
    for each regra-menslid-criter no-lock
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999")
         and regra-menslid-criter.nr-idade-minima = 70:
         ix = ix + 1.         
         
         create b.
         buffer-copy regra-menslid-criter
            except cdd-id
                   nr-faixa-etaria
                   nr-idade-minima
                   nr-idade-maxima
         to b.
         assign b.cdd-id = cod-seq
                b.nr-faixa-etaria = regra-menslid-criter.nr-faixa-etaria + 1
                b.nr-idade-minima = 0
                b.nr-idade-maxima = 69
                b.cod-usuar-ult-atualiz = "criadoCargaFaixa".
         
    end.
    
    /*Para as regras que s¢ tem um criterio, quero ver s¢ as que sÆo de 70 anos*/
    for each regra-menslid-criter no-lock
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999")
         and regra-menslid-criter.nr-idade-minima = 61:
         ix = ix + 1.         
         
         create b.
         buffer-copy regra-menslid-criter
            except cdd-id
                   nr-faixa-etaria
                   nr-idade-minima
                   nr-idade-maxima
         to b.
         assign b.cdd-id = cod-seq
                b.nr-faixa-etaria = regra-menslid-criter.nr-faixa-etaria + 1
                b.nr-idade-minima = 0
                b.nr-idade-maxima = 60
                b.cod-usuar-ult-atualiz = "criadoCargaFaixa".
         
    end.

    
        /*Para as regras que s¢ tem um criterio, quero ver s¢ as que sÆo de 70 anos*/
    for each regra-menslid-criter no-lock
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999")
         and regra-menslid-criter.nr-idade-minima = 71:
         ix = ix + 1.         
         
         create b.
         buffer-copy regra-menslid-criter
            except cdd-id
                   nr-faixa-etaria
                   nr-idade-minima
                   nr-idade-maxima
         to b.
         assign b.cdd-id = cod-seq
                b.nr-faixa-etaria = regra-menslid-criter.nr-faixa-etaria + 1
                b.nr-idade-minima = 0
                b.nr-idade-maxima = 70
                b.cod-usuar-ult-atualiz = "criadoCargaFaixa".
         
    end.
*/
    for each regra-menslid-criter EXCLUSIVE-LOCK
       where regra-menslid-criter.cdd-regra = regra-menslid.cdd-regra
         and regra-menslid-criter.dat-fim = date("31/12/9999")
         and regra-menslid-criter.nr-idade-minima >= 60 
         AND regra-menslid-criter.nr-idade-minima <= 71 :
         ix = ix + 1.         
    
         /*create b.
         buffer-copy regra-menslid-criter
            except cdd-id
                   nr-faixa-etaria
                   nr-idade-minima
                   nr-idade-maxima
         to b.
         assign b.cdd-id = cod-seq
                b.nr-faixa-etaria = regra-menslid-criter.nr-faixa-etaria + 1
                b.nr-idade-minima = 0
                b.nr-idade-maxima = 59
                b.cod-usuar-ult-atualiz = "criadoCargaFaixa".*/
    
         ASSIGN regra-menslid-criter.nr-idade-minima = 0
                regra-menslid-criter.cod-usuar-ult-atualiz = "regra60anos".
    
    end.

    /*display regra-menslid.cdd-regra.*/

end.
quit.


