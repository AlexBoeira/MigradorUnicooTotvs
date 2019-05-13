set echo off
rem ***********************************************************************************************************************************************************
rem * ATENCAO: AS VARIAVEIS DE AMBIENTE DEVEM ESTAR PREVIMENTE CONFIGURADAS NO JENKINS
rem ***********************************************************************************************************************************************************
set PROGRAMA=ems5\chama-integ-cliente.p
set CLIENTLOG_NOME=c:\temp\clientlog_cliente_
set EXECUTAR_CONTINUAMENTE=N

Set hora=%time:~0,2%
if %hora%== 0 set hora=00
if %hora%== 1 set hora=01
if %hora%== 2 set hora=02
if %hora%== 3 set hora=03
if %hora%== 4 set hora=04
if %hora%== 5 set hora=05
if %hora%== 6 set hora=06
if %hora%== 7 set hora=07
if %hora%== 8 set hora=08
if %hora%== 9 set hora=09
Set data=%date:~0,2%
if %data%== 0 set data=00
if %data%== 1 set data=01
if %data%== 2 set data=02
if %data%== 3 set data=03
if %data%== 4 set data=04
if %data%== 5 set data=05
if %data%== 6 set data=06
if %data%== 7 set data=07
if %data%== 8 set data=08
if %data%== 9 set data=09
set DATA_HORA=%date:~6,4%_%date:~3,2%_%data:~0,2%_%hora:~0,2%%time:~3,2%%time:~6,2%.txt

if %FILA% leq %QT_FILAS_IMPORTACAO_CLIENTES%  (
  call %PROWIN32% -basekey "ini" -ininame %INI% -pf %PF% -p %PROGRAMA% -param %FILA%,%USUARIO%,%SENHA%,%EXECUTAR_CONTINUAMENTE% %CLIENTLOG_CONF% %CLIENTLOG_NOME%%FILA%_%DATA_HORA%
)
exit 0