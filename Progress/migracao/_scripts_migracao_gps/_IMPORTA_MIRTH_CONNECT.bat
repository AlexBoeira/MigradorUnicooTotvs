echo off
rem ***********************************************************************************************************************************************************
rem * Abrir todos os processos Progress do Mirth Connect (temporario ate resolver chamada direta pelo Mirth)
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat

set PROGRAMA=cgp\cg0310x_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_proposta_
set EXECUTAR_CONTINUAMENTE=N
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param MC,%EXECUTAR_CONTINUAMENTE% %CLIENTLOG_CONF% %CLIENTLOG_NOME%MC.txt.

set PROGRAMA=cgp\cg0310v_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_benef_
set CONSIDCARTEIRAANTIGA=S
set EXECUTAR_CONTINUAMENTE=N
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param MC,A,%CONSIDCARTEIRAANTIGA%,%EXECUTAR_CONTINUAMENTE% %CLIENTLOG_CONF% %CLIENTLOG_NOME%MC.txt.

set PROGRAMA=atp\at0210a_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_guia_AT_
set EXECUTAR_CONTINUAMENTE=N
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param MC,%EXECUTAR_CONTINUAMENTE% %CLIENTLOG_CONF% %CLIENTLOG_NOME%MC.txt.
