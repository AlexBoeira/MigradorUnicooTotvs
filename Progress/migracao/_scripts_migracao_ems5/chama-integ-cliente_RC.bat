echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=ems5\chama-integ-cliente.p
set CLIENTLOG_NOME=c:\temp\clientlog_cliente_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param RC,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%RC.txt.
