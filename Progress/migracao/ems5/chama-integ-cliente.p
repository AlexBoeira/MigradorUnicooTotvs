/**
 * Chamar integracao de CLIENTES.
 * Esse programa pode ser chamado por chama-integ-cliente.bat ou pelo jenkins.
 */

/**
 * Temporaria para tratar possiveis erros na tentativa de login.
 */
Def Temp-table tt_erros No-undo
    Field num-cod   As Integer
    Field desc-erro As Character Format "x(256)":U
	Field desc-arq  As Character.

/**
 * in-param-aux:
 *   entry 1: satus da fila a monitorar (0,1,2,etc)
 *   entry 2: usuario (login)
 *   entry 3: senha (login)
 *   entry 4: 'S' para executar continuamente; 'N' para processar todos os registros que encontrar na fila e sair (usado pelo Jenkins)
 */
def var in-param-aux as char no-undo.
assign in-param-aux = session:param. 

run fnd\btb\btapi910za.p(input entry(2, in-param-aux), /*USUARIO*/
                         input entry(3, in-param-aux), /*SENHA */
                         output table tt_erros). 

for each tt_erros:
    message "Erro: " 
            String(tt_erros.num-cod) + " - ":U + 
            tt_erros.desc-erro 
            view-as alert-box information.
end.

REPEAT:
  PROCESS EVENTS.
  RUN ems5/ti_cliente.p(INPUT ENTRY(1, in-param-aux)).
  
  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  or entry(4,in-param-aux) = "N"
  THEN LEAVE.
  else pause(1).
END.
QUIT.
