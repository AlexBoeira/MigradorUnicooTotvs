echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=ems5\chama-integ-fornecedor.p
set CLIENTLOG_NOME=c:\temp\clientlog_fornecedor_
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R0,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R1,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R2,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R3,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R4,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R5,%USUARIO%,%SENHA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%_5.txt.
