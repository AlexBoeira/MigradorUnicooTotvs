echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0310v_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_benef_
set CONSIDCARTEIRAANTIGA=S
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 1,A,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_1.txt.
