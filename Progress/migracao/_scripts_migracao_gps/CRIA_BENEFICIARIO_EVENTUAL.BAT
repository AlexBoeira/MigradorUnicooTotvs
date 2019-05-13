echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=tep\te-carga-benef-eventual_v2.p
set CLIENTLOG_NOME=c:\temp\clientlog_benef_eventual_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_MC.txt.
