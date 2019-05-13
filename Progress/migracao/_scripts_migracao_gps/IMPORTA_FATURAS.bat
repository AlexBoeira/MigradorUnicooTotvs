rem echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0410f.p
set CLIENTLOG_NOME=c:\temp\clientlog_faturas
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%.txt.
