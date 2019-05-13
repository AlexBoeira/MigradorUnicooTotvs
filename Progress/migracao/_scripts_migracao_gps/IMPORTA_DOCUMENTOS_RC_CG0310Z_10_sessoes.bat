echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0310z_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_documento_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R0 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R1 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R2 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R3 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R4 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R5 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R5.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R6 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R6.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R7 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R7.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R8 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R8.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R9 %CLIENTLOG_CONF% %CLIENTLOG_NOME%R9.txt.
