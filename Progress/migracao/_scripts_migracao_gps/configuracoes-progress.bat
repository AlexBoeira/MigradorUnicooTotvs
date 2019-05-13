rem ***********************************************************************************************************************************************************
rem * ESSAS VARIÁVEIS SERÃO UTILIZADAS POR TODOS OS DEMAIS PROCESSOS BATCH QUE CHAMAM AS APLICAÇÕES PROGRESS PARA IMPORTAÇÃO DE DADOS NO EMS5 E GPS
rem *   PROWIN32       - caminho onde se encontra o prowin32.exe na máquina que executará os processos Progress na migração
rem *   PF             - caminho onde se encontra o arquivo.pf de conexão aos bancos de dados
rem *   INI            - caminho onde se encontra o arquivo.ini. Atenção para adicionar a pasta dos programas de migração ao início do PROPATH
rem *   CLIENTLOG_CONF - parâmetros de configuração para o CLIENTLOG
rem *   USUARIO        - login a ser utilizado nos processos que exigem autenticacao (importação de Clientes, Fornecedores, Títulos, etc)
rem *   SENHA          - senha do USUARIO
rem *
rem * ATENCAO: esses processos não poderão ser executados via caminho de rede. O usuário deverá estar conectado ao servidor para executá-los.
rem *          EX. ERRADO: \\totvs\script\programa.bat - O WINDOWS NÃO CONSEGUIRÁ RESOLVER. VAI DAR ERRO NO CMD.
rem *          EX. CERTO : c:\totvs\script\programa.bat 
rem ***********************************************************************************************************************************************************
rem echo off
SET PROWIN32=C:\DLC116\bin\prowin32.exe
set PF=\\totvs-prod-testes\ERPGP\scripts\dtsgp_migracao\datasul.pf
set INI=\\totvs-prod-testes\ERPGP\scripts\dtsgp_migracao\datasul-progress.ini
set CLIENTLOG_CONF=-clearlog -logginglevel 2 -logentrytypes 4GLMessages,4GLTrace,DB.Connects,FileID -clientlog
set USUARIO=migracao
set SENHA=migracao
