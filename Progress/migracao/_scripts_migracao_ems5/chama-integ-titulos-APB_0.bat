echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=ems5\chama-integ-titulos-apb.p
set CLIENTLOG_NOME=c:\temp\integ_titulos_apb_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 0,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%0.txt.
