rem echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=tep\te-carga-anexos-benef-e-termo.p
set CLIENTLOG_NOME=c:\temp\clientlog_anexos
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param c:\temp\upload %CLIENTLOG_CONF% %CLIENTLOG_NOME%.txt.
