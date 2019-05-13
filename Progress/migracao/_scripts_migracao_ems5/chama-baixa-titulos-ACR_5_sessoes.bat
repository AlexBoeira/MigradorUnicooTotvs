echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=ems5\chama-baixa-titulos-acr.p
set CLIENTLOG_NOME=c:\temp\baixa_titulos_acr
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R0,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R1,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R2,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R3,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R4,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R5,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R5.txt.
