echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set CLIENTLOG_NOME=c:\temp\integ_titulos_acr_
set PROGRAMA=ems5\chama-integ-titulos-acr.p
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 1,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%1.txt.
