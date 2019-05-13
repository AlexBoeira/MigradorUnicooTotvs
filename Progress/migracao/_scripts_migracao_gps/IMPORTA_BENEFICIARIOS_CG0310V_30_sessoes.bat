echo off
rem ***********************************************************************************************************************************************************
rem * CONFIGURACOES-PROGRESS.BAT deve estar previamente configurado e gravado na pasta imediatamente anterior. Ver instruções no cabeçalho do próprio arquivo.
rem ***********************************************************************************************************************************************************
call ..\configuracoes-progress.bat
set PROGRAMA=cgp\cg0310v_batch.p
set CLIENTLOG_NOME=c:\temp\clientlog_beneficiario_
set CONSIDCARTEIRAANTIGA=S
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 0,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_0.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 1,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_1.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 2,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_2.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 3,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_3.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 4,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_4.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 5,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_5.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 6,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_6.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 7,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_7.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 8,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_8.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 9,A,%CONSIDCARTEIRAANTIGA%    %CLIENTLOG_CONF% %CLIENTLOG_NOME%_9.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 10,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_10.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 11,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_11.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 12,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_12.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 13,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_13.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 14,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_14.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 15,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_15.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 16,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_16.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 17,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_17.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 18,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_18.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 19,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_19.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 20,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_20.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 21,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_21.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 22,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_22.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 23,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_23.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 24,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_24.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 25,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_25.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 26,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_26.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 27,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_27.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 28,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_28.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 29,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_29.txt.
start %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param 30,A,%CONSIDCARTEIRAANTIGA%   %CLIENTLOG_CONF% %CLIENTLOG_NOME%_30.txt.
