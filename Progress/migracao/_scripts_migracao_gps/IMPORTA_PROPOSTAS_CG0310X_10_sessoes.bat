echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0310x_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_proposta_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 0 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 1 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 2 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 3 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 4 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 5 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_5.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 6 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_6.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 7 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_7.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 8 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_8.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 9 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_9.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 10 %CLIENTLOG_CONF% %CLIENTLOG_NOME%_10.txt.
