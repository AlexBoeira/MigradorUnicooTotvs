/*

Table: plamodpr

Flags Index Name                    St Area Cnt Field Name
----- ----------------------------- ------- --- ------------------------------
pu    plamodpr1                     N/A       5 + cd-modalidade
                                                + cd-plano
                                                + cd-tipo-plano
                                                + in-procedimento-insumo
                                                + cd-modulo



Table: plamodpr

Field Name                  Data Type  Flg Format
--------------------------- ---------- --- --------------------------------
cd-modalidade               inte       im  99
cd-plano                    inte       im  99
cd-tipo-plano               inte       im  99
cd-modulo                   inte       i   999
cd-tab-preco                char           999/99
dt-atualizacao              date           99/99/9999
cd-userid                   char           x(12)
nr-limite-fisioterapia      inte           999
int-1                       inte           ->,>>>,>>9
int-2                       inte           ->,>>>,>>9
int-3                       inte           ->,>>>,>>9
date-1                      date           99/99/9999
date-2                      date           99/99/9999
date-3                      date           99/99/9999
log-1                       logi           yes/no
log-2                       logi           yes/no
log-3                       logi           yes/no
char-1                      char           x(100)
char-2                      char           x(100)
char-3                      char[2]        x(100)
u-char-1                    char           x(8)
u-char-2                    char           x(8)
u-char-3                    char           x(8)
u-date-1                    date           99/99/9999
u-date-2                    date           99/99/9999
u-date-3                    date           99/99/9999
u-log-1                     logi           yes/no
u-log-2                     logi           yes/no
u-log-3                     logi           yes/no
u-int-1                     inte           ->,>>>,>>9
u-int-2                     inte           ->,>>>,>>9
u-int-3                     inte           ->,>>>,>>9
nr-dias-validade            inte           999
cd-esp-amb                  inte       m   99
cd-grupo-proc-amb           inte       m   99
cd-procedimento             inte       m   999
dv-procedimento             inte       m   9
in-procedimento-insumo      char       i   !
u-dec-3                     deci-2         ->>,>>9.99
char-4                      char           x(100)
char-5                      char           x(100)
date-4                      date           99/99/9999
date-5                      date           99/99/9999
dec-1                       deci-2         ->>,>>9.99
dec-2                       deci-2         ->>,>>9.99
dec-3                       deci-2         ->>,>>9.99
dec-4                       deci-2         ->>,>>9.99
dec-5                       deci-2         ->>,>>9.99
int-4                       inte           ->,>>>,>>9
int-5                       inte           ->,>>>,>>9
log-4                       logi           yes/no
log-5                       logi           yes/no
u-dec-1                     deci-2         ->>,>>9.99
u-dec-2                     deci-2         ->>,>>9.99
dt-limite                   date           99/99/9999
*/

DEF TEMP-TABLE tmp-tipo NO-UNDO
    FIELD cd-tipo AS CHAR
    INDEX tmp-tipo1 cd-tipo.

CREATE tmp-tipo.
ASSIGN tmp-tipo.cd-tipo = "P".
CREATE tmp-tipo.
ASSIGN tmp-tipo.cd-tipo = "I".

FOR EACH ti-pl-sa NO-LOCK,
    EACH tmp-tipo NO-LOCK,
    EACH mod-cob  NO-LOCK:

    CREATE plamodpr.
    ASSIGN plamodpr.cd-modalidade          = ti-pl-sa.cd-modalidade         
           plamodpr.cd-plano               = ti-pl-sa.cd-plano              
           plamodpr.cd-tipo-plano          = ti-pl-sa.cd-tipo-plano         
           plamodpr.in-procedimento-insumo = tmp-tipo.cd-tipo
           plamodpr.cd-modulo              = mod-cob.cd-modulo             
           plamodpr.cd-tab-preco           = "00101"          
           plamodpr.dt-atualizacao         = today
           plamodpr.cd-userid              = "migracao".

END

