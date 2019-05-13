echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=ems5\chama-integ-titulos-acr.p
set CLIENTLOG_NOME=c:\temp\integ_titulos_acr
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 0,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 1,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 2,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 3,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 4,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 5,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%5.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 6,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%6.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 7,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%7.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 8,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%8.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 9,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%9.txt.
