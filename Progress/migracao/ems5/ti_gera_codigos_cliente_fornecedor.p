/**
 * Varrer todos os TI_PESSOA com seus TI_FORNECEDOR e TI_CLIENTE correspondentes.
 * Trocar situacao RC para R0, R1, R2... ate R9.
 * setar CD_CLIENTE e CD_FORNECEDOR com codificacao unica e acima de 1000, 
 * pois valores ate 999 sao reservados para Unimeds.
 * Respeitar codificacoes que ja estejam sendo utilizadas, pois o processo
 * pode nao estar sendo executado pela primeira vez.
 *
 * Atencao: quando nrregistro_pai estiver preenchido, deve herdar o mesmo codigo do pai.
 *
 * Nunca executar esse processo em mais de uma sessao, pois causara sobreposicao de codigos!
 */
DEF BUFFER b-ti_pessoa     FOR ti_pessoa.
DEF BUFFER b-ti_pessoa_pai FOR ti_pessoa.
 
DEF VAR cod-cli-for-aux    AS INT INIT 1000 NO-UNDO.
DEF VAR cod-cli-for-atual-aux AS INT NO-UNDO.
DEF VAR in-status-cli-aux  AS CHAR INIT "R0" NO-UNDO.
DEF VAR in-status-for-aux  AS CHAR INIT "R0" NO-UNDO.

FUNCTION proximo-status-cli RETURNS CHAR():
  CASE in-status-cli-aux:
      WHEN "R0" THEN ASSIGN in-status-cli-aux = "R1".
      WHEN "R1" THEN ASSIGN in-status-cli-aux = "R2".
      WHEN "R2" THEN ASSIGN in-status-cli-aux = "R3".
      WHEN "R3" THEN ASSIGN in-status-cli-aux = "R4".
      WHEN "R4" THEN ASSIGN in-status-cli-aux = "R5".
      WHEN "R5" THEN ASSIGN in-status-cli-aux = "R6".
      WHEN "R6" THEN ASSIGN in-status-cli-aux = "R7".
      WHEN "R7" THEN ASSIGN in-status-cli-aux = "R8".
      WHEN "R8" THEN ASSIGN in-status-cli-aux = "R9".
      WHEN "R9" THEN ASSIGN in-status-cli-aux = "R0".
  END CASE.
  RETURN in-status-cli-aux.
END FUNCTION.

FUNCTION proximo-status-for RETURNS CHAR():
  CASE in-status-for-aux:
      WHEN "R0" THEN ASSIGN in-status-for-aux = "R1".
      WHEN "R1" THEN ASSIGN in-status-for-aux = "R2".
      WHEN "R2" THEN ASSIGN in-status-for-aux = "R3".
      WHEN "R3" THEN ASSIGN in-status-for-aux = "R4".
      WHEN "R4" THEN ASSIGN in-status-for-aux = "R5".
      WHEN "R5" THEN ASSIGN in-status-for-aux = "R6".
      WHEN "R6" THEN ASSIGN in-status-for-aux = "R7".
      WHEN "R7" THEN ASSIGN in-status-for-aux = "R8".
      WHEN "R8" THEN ASSIGN in-status-for-aux = "R9".
      WHEN "R9" THEN ASSIGN in-status-for-aux = "R0".
  END CASE.
  RETURN in-status-for-aux.
END FUNCTION.

ETIME(TRUE).

FOR FIRST paramecp NO-LOCK:
END.
IF NOT AVAIL paramecp
THEN DO:
       MESSAGE "Parametros gerais nao cadastrados."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN.
     END.

/**
 * Buscar maior cdn_cliente / cdn_fornecedor para inicializar cod-cli-for-aux.
 */
FOR LAST ti_pessoa NO-LOCK WHERE ti_pessoa.cdn_cliente <> ? BY ti_pessoa.cdn_cliente:
    IF ti_pessoa.cdn_cliente > cod-cli-for-aux
    THEN ASSIGN cod-cli-for-aux = ti_pessoa.cdn_cliente.
END.

FOR last cliente USE-INDEX cliente_id where cliente.cod_empresa = paramecp.ep-codigo AND cliente.cdn_cliente <> ? NO-LOCK:
    IF cliente.cdn_cliente > cod-cli-for-aux
    THEN cod-cli-for-aux = cliente.cdn_cliente.
END.

FOR last fornecedor USE-INDEX frncdr_id where fornecedor.cod_empresa = paramecp.ep-codigo AND fornecedor.cdn_fornecedor <> ? NO-LOCK:
    IF fornecedor.cdn_fornecedor > cod-cli-for-aux
    THEN cod-cli-for-aux = fornecedor.cdn_fornecedor.
END.

cod-cli-for-aux = cod-cli-for-aux + 1.

FOR EACH ti_cliente EXCLUSIVE-LOCK
   WHERE ti_cliente.cdsituacao = "RC",
   FIRST ti_pessoa NO-LOCK
   where ti_pessoa.nrregistro = ti_cliente.nrpessoa:

         /**
          * Registro filho deve usar mesmo codigo do pai. Caso o pai ainda nao tenha
          * sido processado, manter como RC para ser tratado em execucao futura.
          */
         IF  ti_pessoa.nrregistro_pai <> ?
         and ti_pessoa.nrregistro_pai <> 0
         THEN DO:
                IF ti_pessoa.cdn_cliente = ?
                or ti_pessoa.cdn_cliente = 0
                THEN DO:
                       FOR FIRST b-ti_pessoa_pai NO-LOCK
                           WHERE b-ti_pessoa_pai.noabreviado_cliente = ti_pessoa.noabreviado_cliente
                             AND b-ti_pessoa_pai.cdn_cliente <> ?
                             AND b-ti_pessoa_pai.cdn_cliente > 0,
                           FIRST b-ti_pessoa EXCLUSIVE-LOCK
                           WHERE ROWID(b-ti_pessoa) = ROWID(ti_pessoa):

                                 ASSIGN b-ti_pessoa.cdn_cliente    = b-ti_pessoa_pai.cdn_cliente     
                                        b-ti_pessoa.cdn_fornecedor = b-ti_pessoa_pai.cdn_fornecedor  
                                        ti_cliente.cod_cliente     = b-ti_pessoa_pai.cdn_cliente
                                        cod-cli-for-atual-aux      = b-ti_pessoa.cdn_cliente.    
                       END.
                     END.
              END.
         /** 
          * Registro pai que esta com codigo cliente / fornecedor zerado deve receber novo codigo.
          */
         ELSE DO:
                IF ti_pessoa.cdn_cliente    = 0
                OR ti_pessoa.cdn_cliente    = ?
                THEN DO: 
                       FOR FIRST b-ti_pessoa EXCLUSIVE-LOCK
                           WHERE rowid(b-ti_pessoa) = ROWID(ti_pessoa):
                           ASSIGN cod-cli-for-atual-aux      = cod-cli-for-aux 
                                  b-ti_pessoa.cdn_cliente    = cod-cli-for-atual-aux
                                  b-ti_pessoa.cdn_fornecedor = cod-cli-for-atual-aux
                                  ti_cliente.cod_cliente     = cod-cli-for-atual-aux
                                  cod-cli-for-aux            = cod-cli-for-aux + 1.
                       END.
                     END.
              END.

         IF ti_cliente.cod_cliente = ?
         OR ti_cliente.cod_cliente = 0
         THEN do:
                ASSIGN ti_cliente.cod_cliente = cod-cli-for-atual-aux.
              END.

         IF ti_cliente.cod_cliente = ?
         THEN ti_cliente.cod_cliente = 0.
         ELSE do:
                ASSIGN ti_cliente.cdsituacao  = proximo-status-cli().
              END.
END.

FOR EACH ti_fornecedor EXCLUSIVE-LOCK
   WHERE ti_fornecedor.cdsituacao = "RC",
   FIRST ti_pessoa NO-LOCK
   where ti_pessoa.nrregistro = ti_fornecedor.nrpessoa:

         /**
          * Registro filho deve usar mesmo codigo do pai. Caso o pai ainda nao tenha
          * sido processado, manter como RC para ser tratado em execucao futura.
          */
         IF  ti_pessoa.nrregistro_pai <> ?
         and ti_pessoa.nrregistro_pai <> 0
         THEN DO:
                IF ti_pessoa.cdn_fornecedor = ?
                or ti_pessoa.cdn_fornecedor = 0
                THEN DO:
                       FOR FIRST b-ti_pessoa_pai NO-LOCK
                           WHERE b-ti_pessoa_pai.noabreviado_fornecedor = ti_pessoa.noabreviado_fornecedor
                             AND b-ti_pessoa_pai.cdn_fornecedor <> ?
                             AND b-ti_pessoa_pai.cdn_fornecedor > 0,
                           FIRST b-ti_pessoa EXCLUSIVE-LOCK
                           WHERE ROWID(b-ti_pessoa) = ROWID(ti_pessoa):

                                 ASSIGN b-ti_pessoa.cdn_fornecedor   = b-ti_pessoa_pai.cdn_fornecedor
                                        b-ti_pessoa.cdn_cliente      = b-ti_pessoa_pai.cdn_cliente
                                        ti_fornecedor.cod_fornecedor = b-ti_pessoa_pai.cdn_fornecedor
                                        cod-cli-for-atual-aux        = b-ti_pessoa.cdn_fornecedor.
                       END.
                     END.
              END.
         /** 
          * Registro pai que esta com codigo fornecedor / fornecedor zerado deve receber novo codigo.
          */
         ELSE DO:
                IF ti_pessoa.cdn_fornecedor    = 0
                OR ti_pessoa.cdn_fornecedor    = ?
                THEN DO: 
                       FOR FIRST b-ti_pessoa EXCLUSIVE-LOCK
                           WHERE rowid(b-ti_pessoa) = ROWID(ti_pessoa):
                
                           ASSIGN cod-cli-for-atual-aux        = cod-cli-for-aux
                                  b-ti_pessoa.cdn_fornecedor   = cod-cli-for-atual-aux
                                  b-ti_pessoa.cdn_cliente      = cod-cli-for-atual-aux
                                  ti_fornecedor.cod_fornecedor = cod-cli-for-atual-aux
                                  cod-cli-for-aux              = cod-cli-for-aux + 1.
                       END.
                     END.
              END.

         IF ti_fornecedor.cod_fornecedor = ?
         OR ti_fornecedor.cod_fornecedor = 0
         THEN ASSIGN ti_fornecedor.cod_fornecedor = cod-cli-for-atual-aux.

         IF ti_fornecedor.cod_fornecedor = ?
         THEN ti_fornecedor.cod_fornecedor = 0.
         ELSE ASSIGN ti_fornecedor.cdsituacao  = proximo-status-cli().
END.

/*
MESSAGE "Concluido" SKIP
        "Tempo decorrido (segundos):" ETIME / 1000
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
