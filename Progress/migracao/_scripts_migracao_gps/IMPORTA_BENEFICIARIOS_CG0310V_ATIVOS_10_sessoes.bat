echo off
rem * ESSE SCRIPT CONSIDERA APENAS BENEFICIARIOS ATIVOS, PARA SEPARAR O MOMENTO DOS PROCESSAMENTOS.
rem * SE JÁ FOI EXECUTADO O SCRIPT COM PARAMETRO 'AMBOS' (-param R0,A), ENTÃO NÃO UTILIZE ESSE SCRIPT.

rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0310v_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_benef_
set CONSIDCARTEIRAANTIGA=S
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R0,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R1,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R2,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R3,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R4,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R5,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R5.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R6,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R6.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R7,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R7.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R8,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R8.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param R9,AT,%CONSIDCARTEIRAANTIGA% %CLIENTLOG_CONF% %CLIENTLOG_NOME%R9.txt.
