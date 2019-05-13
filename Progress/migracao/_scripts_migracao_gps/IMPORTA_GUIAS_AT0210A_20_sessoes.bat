echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=atp\at0210a_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_guia_AT_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 0 %CLIENTLOG_CONF% %CLIENTLOG_NOME%0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 1 %CLIENTLOG_CONF% %CLIENTLOG_NOME%1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 2 %CLIENTLOG_CONF% %CLIENTLOG_NOME%2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 3 %CLIENTLOG_CONF% %CLIENTLOG_NOME%3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 4 %CLIENTLOG_CONF% %CLIENTLOG_NOME%4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 5 %CLIENTLOG_CONF% %CLIENTLOG_NOME%5.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 6 %CLIENTLOG_CONF% %CLIENTLOG_NOME%6.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 7 %CLIENTLOG_CONF% %CLIENTLOG_NOME%7.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 8 %CLIENTLOG_CONF% %CLIENTLOG_NOME%8.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 9 %CLIENTLOG_CONF% %CLIENTLOG_NOME%9.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 10 %CLIENTLOG_CONF% %CLIENTLOG_NOME%10.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 11 %CLIENTLOG_CONF% %CLIENTLOG_NOME%11.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 12 %CLIENTLOG_CONF% %CLIENTLOG_NOME%12.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 13 %CLIENTLOG_CONF% %CLIENTLOG_NOME%13.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 14 %CLIENTLOG_CONF% %CLIENTLOG_NOME%14.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 15 %CLIENTLOG_CONF% %CLIENTLOG_NOME%15.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 16 %CLIENTLOG_CONF% %CLIENTLOG_NOME%16.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 17 %CLIENTLOG_CONF% %CLIENTLOG_NOME%17.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 18 %CLIENTLOG_CONF% %CLIENTLOG_NOME%18.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 19 %CLIENTLOG_CONF% %CLIENTLOG_NOME%19.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 20 %CLIENTLOG_CONF% %CLIENTLOG_NOME%20.txt.
