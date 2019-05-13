echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0310x_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_proposta_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 11 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_11.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 12 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_12.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 13 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_13.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 14 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_14.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 15 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_15.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 16 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_16.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 17 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_17.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 18 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_18.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 19 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_19.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 20 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_20.txt.
