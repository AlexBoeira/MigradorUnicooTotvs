/**
 * Chamar integracao de FORNECEDORES.
 * Esse programa pode ser chamado por chama-integ-fornecedor.bat ou Jenkins
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

DEFINE NEW GLOBAL SHARED VARIABLE lAccessSecurityActive              AS CHARACTER NO-UNDO.
DEFINE VARIABLE lAccessSecurityActiveAux AS CHARACTER NO-UNDO.

RUN desativaSegurancaAvancada.

run fnd\btb\btapi910za.p(input entry(2, in-param-aux), /*USUARIO*/
                         input entry(3, in-param-aux), /*SENHA */
                         output table tt_erros). 

For Each tt_erros:
    RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ANTES DO MESSAGE DE ERRO DA BTAPI910ZA").
    RUN escrever-log("@@@@@Erro: " + String(tt_erros.num-cod) + " - ":U + tt_erros.desc-erro).
    RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DEPOIS DO MESSAGE DE ERRO DA BTAPI910ZA").
End.

REPEAT:
  PROCESS EVENTS.
  RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ANTES DE CHAMAR TI_FORNECEDOR.P").
  RUN ems5/ti_fornecedor.p(INPUT ENTRY(1, in-param-aux)) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
     RUN escrever-log ("@@@@@@ERRO PROGRESS: " + ERROR-STATUS:GET-MESSAGE(1)).
  END.
  RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DEPOIS DE VOLTAR DE TI_FORNECEDOR.P").

  IF SEARCH("c:/temp/parar-migracao.txt") <> ?
  or entry(4,in-param-aux) = "N"
  THEN LEAVE.
  else pause(1).
  RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@FORCANDO LOOP...").
END.
RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ANTES DO QUIT").

RUN restauraSegurancaAvancada.

QUIT.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-mensagem-par AS CHAR NO-UNDO.
END.

PROCEDURE desativaSegurancaAvancada PRIVATE:
    lAccessSecurityActiveAux=lAccessSecurityActive.
    lAccessSecurityActive="FALSE".
END PROCEDURE.

PROCEDURE restauraSegurancaAvancada PRIVATE:
    lAccessSecurityActive=lAccessSecurityActiveAux.
END PROCEDURE.
