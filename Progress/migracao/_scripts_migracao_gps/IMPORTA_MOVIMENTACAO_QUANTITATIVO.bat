echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=spp\sppr0025.p
set CLIENTLOG_NOME=c:\temp\sppr0025
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param %USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%.txt.
