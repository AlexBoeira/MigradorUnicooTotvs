/**
 * o objetivo desse programa eh ficar em loop enquanto existirem registros nas filas de processamento, para controlar a tarefa do jenkins.
 * eh chamado pelo .bat que dispara as filas de importacao.
 *
 * in-param-aux: esse parametro eh enviado pelo chamador, que eh um arquivo.bat
 *   entry 1: numero de filas que foram disparadas pelo jenkins
 *
 * obs: se ficar 1 minuto sem mudanca nas filas, significa que os processos relacionados foram derrubados. nesse caso, vai sair do programa.
 */
 
def var in-param-aux   as char          no-undo.
def var qt-filas-aux   as int no-undo.
def var ix-fila-aux    as int no-undo.
def var lg-ficar-no-loop-aux as log no-undo.
def var nr-pendentes-na-fila-aux as int extent 1000 init 0 no-undo.
def var nr-pendentes-na-fila-controle-tempo-aux as int extent 1000 init 0 no-undo.
def var nr-controle-tempo-aux as int no-undo.

assign  in-param-aux = session:param.
assign qt-filas-aux = int(entry(1,in-param-aux)).

/* considera-se que existam filas partindo do numero zero ate o parametro recebido.
 * ex: se o parametro for 5, entao o programa deve monitorar as filas 0, 1, 2, 3, 4 e 5 
 * obs: como array em progress inicia em 1, sera tratado como ix-fila-aux + 1...*/

REPEAT:
  PROCESS EVENTS.
  do ix-fila-aux = 0 to qt-filas-aux:
    select count(*) into nr-pendentes-na-fila-aux[ix-fila-aux + 1] from import-guia where import-guia.ind-sit-import = string(ix-fila-aux).
  end.

  assign lg-ficar-no-loop-aux = false.
  do ix-fila-aux = 0 to qt-filas-aux:
    if nr-pendentes-na-fila-aux[ix-fila-aux + 1] > 0
    then do:
           run escrever-log(string(nr-pendentes-na-fila-aux[ix-fila-aux + 1]) + " registros pendentes na fila " + string(ix-fila-aux)).
           lg-ficar-no-loop-aux = true.
    end.
  end.

  if lg-ficar-no-loop-aux
  and etime > 60000 /* 1 minuto */
  then do:
         run escrever-log("Passou 1 minuto. Checar se houve atividade:").
         lg-ficar-no-loop-aux = false.
         do ix-fila-aux = 1 to qt-filas-aux:
           if nr-pendentes-na-fila-aux[ix-fila-aux] <> nr-pendentes-na-fila-controle-tempo-aux[ix-fila-aux]
           then do:
                  run escrever-log("Fila " + string(ix-fila-aux - 1) + " teve alteracao. Continuando o processo...").
                  assign lg-ficar-no-loop-aux = true.
                  leave.
           end.
         end.
         
         if lg-ficar-no-loop-aux = false
         then do:
                run escrever-log("Filas ficaram 1 minuto sem atividade. Liberando tarefa do Jenkins.").
                leave.
         end.
         else do:
                etime(true).
                nr-pendentes-na-fila-controle-tempo-aux = nr-pendentes-na-fila-aux.
         end.
  end.

  if lg-ficar-no-loop-aux = false
  then do:
         run escrever-log("Nenhum registro pendente em nenhuma fila. Liberando tarefa do Jenkins.").
         leave.
  end.
  else pause(5).  
END.
QUIT.

PROCEDURE escrever-log:
    DEF INPUT PARAMETER ds-par AS CHAR NO-UNDO.
END PROCEDURE.
