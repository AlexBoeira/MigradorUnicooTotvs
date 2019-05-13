echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=ems5\chama-baixa-titulos-acr.p
set CLIENTLOG_NOME=c:\temp\baixa_titulos_acr_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 2,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%2.txt.
