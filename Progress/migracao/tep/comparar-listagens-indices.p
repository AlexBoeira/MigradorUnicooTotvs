/**
 * OBJETIVO: comparar 2 arquivos em formato CSV (;) que contenham exatamente as colunas BANCO;TABELA;INDICE;CRC INDICE;UNICO;ATIVO;CAMPO;ASCENDENTE (gerado pelo exportar_indices.p).
 *           ao final listara um CSV com os campos/tabelas que existem em apenas um dos arquivos ou que existem em ambos mas sao diferentes.
 *
 *   STATUS: <<          indice existe apenas no 1o arquivo
 *           >>          indice existe apenas no 2o arquivo
 *           <           campo do indice existe apenas no 1o arquivo
 *           >           campo do indice existe apenas no 2o arquivo
 * 
 *           Trata os nomes dos 2 arquivos a serem comparados de forma fixa: c:\temp\idx1.csv e c:\temp\idx2.csv.
 *           Saida: c:\temp\diferenca-indices.csv
 */
 
DEF TEMP-TABLE tmp1 NO-UNDO
    FIELD nm-banco AS CHAR
    FIELD nm-tabela AS CHAR
    FIELD nm-indice AS CHAR
    FIELD ds-crc-indice AS INTEGER
    FIELD nm-unico AS CHAR
    FIELD nm-ativo AS CHAR
    FIELD nm-campo AS CHAR
    FIELD nm-ascendente AS CHAR
    FIELD in-status AS CHAR
    INDEX pk
          nm-banco
          nm-tabela
          nm-indice
          nm-campo
    INDEX i-status
          in-status.

DEF TEMP-TABLE tmp2 NO-UNDO
    FIELD nm-banco AS CHAR
    FIELD nm-tabela AS CHAR
    FIELD nm-indice AS CHAR
    FIELD ds-crc-indice AS INTEGER
    FIELD nm-unico AS CHAR
    FIELD nm-ativo AS CHAR
    FIELD nm-campo AS CHAR
    FIELD nm-ascendente AS CHAR
    FIELD in-status AS CHAR
    INDEX pk
          nm-banco
          nm-tabela
          nm-indice
          nm-campo
    INDEX i-status
          in-status.

DEF TEMP-TABLE tmp-resultado NO-UNDO
    FIELD in-status AS CHAR
    FIELD nm-banco AS CHAR
    FIELD nm-tabela AS CHAR
    FIELD nm-indice AS CHAR
    FIELD nm-unico AS CHAR
    FIELD nm-ativo AS CHAR
    FIELD nm-campo AS CHAR
    FIELD nm-ascendente AS CHAR
    INDEX i-banco
          nm-banco
    INDEX i2
          in-status
          nm-banco
          nm-tabela
          nm-indice.

DEF VAR nm-arquivo1-aux AS CHAR INIT "c:\temp\idx1.csv" NO-UNDO.
DEF VAR nm-arquivo2-aux AS CHAR INIT "c:\temp\idx2.csv" NO-UNDO.
DEF VAR nm-resultado-aux AS CHAR INIT "c:\temp\diferenca-indices.csv" NO-UNDO.

ETIME(TRUE).

INPUT FROM VALUE(nm-arquivo1-aux).
REPEAT:
    CREATE tmp1.
    IMPORT DELIMITER ";" tmp1 NO-ERROR.
END.
INPUT CLOSE.

INPUT FROM VALUE(nm-arquivo2-aux).
REPEAT:
    CREATE tmp2.
    IMPORT DELIMITER ";" tmp2 NO-ERROR.
END.
INPUT CLOSE.

/* limpeza preliminar pelo CRC
FOR EACH tmp1,
    EACH tmp2 WHERE tmp2.nm-banco  = tmp1.nm-banco
                AND tmp2.nm-tabela = tmp1.nm-tabela
                and tmp2.nm-indice = tmp1.nm-indice:

    IF tmp2.ds-crc-indice    = tmp1.ds-crc-indice
    THEN ASSIGN tmp2.in-status = "="
                tmp1.in-status = "=".
END.
*/

/* checar se o indice/campo existe em tmp1 e nao existe em tmp2*/
FOR EACH tmp1:
    /* nivel indice*/
    IF NOT CAN-FIND(FIRST tmp2
                    WHERE tmp2.nm-banco  = tmp1.nm-banco 
                      AND tmp2.nm-tabela = tmp1.nm-tabela
                      AND tmp2.nm-indice = tmp1.nm-indice)
    THEN do:
           IF NOT CAN-FIND(FIRST tmp-resultado
                           WHERE tmp-resultado.in-status = "<<"
                             AND tmp-resultado.nm-banco  = tmp1.nm-banco 
                             AND tmp-resultado.nm-tabela = tmp1.nm-tabela
                             AND tmp-resultado.nm-indice = tmp1.nm-indice)
           THEN DO:
                  CREATE tmp-resultado.
                  ASSIGN tmp-resultado.in-status = "<<"
                         tmp-resultado.nm-banco  = caps(tmp1.nm-banco )
                         tmp-resultado.nm-tabela = caps(tmp1.nm-tabela)
                         tmp-resultado.nm-indice = caps(tmp1.nm-indice)
                         tmp-resultado.nm-unico = caps(tmp1.nm-unico)
                         tmp-resultado.nm-ativo = caps(tmp1.nm-ativo)
                         tmp1.in-status = "<<".
                END.
         END.
    /* nivel campo*/
    ELSE IF NOT CAN-FIND(FIRST tmp2
                         WHERE tmp2.nm-banco  = tmp1.nm-banco 
                           AND tmp2.nm-tabela = tmp1.nm-tabela
                           AND tmp2.nm-indice = tmp1.nm-indice
                           AND tmp2.nm-campo  = tmp1.nm-campo)
         THEN do:
                CREATE tmp-resultado.
                ASSIGN tmp-resultado.in-status = "<"
                       tmp-resultado.nm-banco  = caps(tmp1.nm-banco )
                       tmp-resultado.nm-tabela = caps(tmp1.nm-tabela)
                       tmp-resultado.nm-indice = caps(tmp1.nm-indice )
                       tmp-resultado.nm-campo  = caps(tmp1.nm-campo )
                       tmp-resultado.nm-unico = caps(tmp1.nm-unico)
                       tmp-resultado.nm-ativo = caps(tmp1.nm-ativo)
                       tmp-resultado.nm-ascendente = caps(tmp1.nm-ascendente)
                       tmp1.in-status = "<".
              END.
END.

/* checar se o indice/campo existe em tmp1 e nao existe em tmp2*/
FOR EACH tmp2:
    /* nivel indice*/
    IF NOT CAN-FIND(FIRST tmp1
                    WHERE tmp1.nm-banco  = tmp2.nm-banco 
                      AND tmp1.nm-tabela = tmp2.nm-tabela
                      AND tmp1.nm-indice = tmp2.nm-indice)
    THEN do:
           IF NOT CAN-FIND(FIRST tmp-resultado
                           WHERE tmp-resultado.in-status = ">>"
                             AND tmp-resultado.nm-banco  = tmp2.nm-banco 
                             AND tmp-resultado.nm-tabela = tmp2.nm-tabela
                             AND tmp-resultado.nm-indice = tmp2.nm-indice)
           THEN DO:
                  CREATE tmp-resultado.
                  ASSIGN tmp-resultado.in-status = ">>"
                         tmp-resultado.nm-banco  = caps(tmp2.nm-banco )
                         tmp-resultado.nm-tabela = caps(tmp2.nm-tabela)
                         tmp-resultado.nm-indice = caps(tmp2.nm-indice)
                         tmp-resultado.nm-unico = caps(tmp2.nm-unico)
                         tmp-resultado.nm-ativo = caps(tmp2.nm-ativo)
                         tmp2.in-status = ">>".
                END.
         END.
    /* nivel campo*/
    ELSE IF NOT CAN-FIND(FIRST tmp1
                         WHERE tmp1.nm-banco  = tmp2.nm-banco 
                           AND tmp1.nm-tabela = tmp2.nm-tabela
                           AND tmp1.nm-indice = tmp2.nm-indice
                           AND tmp1.nm-campo  = tmp2.nm-campo)
         THEN do:
                CREATE tmp-resultado.
                ASSIGN tmp-resultado.in-status = ">"
                       tmp-resultado.nm-banco  = caps(tmp2.nm-banco )
                       tmp-resultado.nm-tabela = caps(tmp2.nm-tabela)
                       tmp-resultado.nm-indice = caps(tmp2.nm-indice )
                       tmp-resultado.nm-campo  = caps(tmp2.nm-campo )
                       tmp-resultado.nm-unico  = caps(tmp2.nm-unico)
                       tmp-resultado.nm-ativo  = caps(tmp2.nm-ativo)
                       tmp-resultado.nm-ascendente = caps(tmp2.nm-ascendente)
                       tmp2.in-status = ">".
              END.
END.

/* checar se campo do indice existe em tmp1 e tmp2 mas com alguma caracteristica diferente*/
FOR EACH tmp1 WHERE tmp1.in-status = "",
    EACH tmp2 WHERE tmp2.nm-banco  = tmp1.nm-banco
                AND tmp2.nm-tabela = tmp1.nm-tabela
                AND tmp2.nm-indice = tmp1.nm-indice
                AND tmp2.nm-campo  = tmp1.nm-campo:

    IF  tmp1.nm-unico      = tmp2.nm-unico
    AND tmp1.nm-ativo      = tmp2.nm-ativo
    AND tmp1.nm-ascendente = tmp2.nm-ascendente
    THEN ASSIGN tmp1.in-status = "="
                tmp2.in-status = "=".
    ELSE DO:
           CREATE tmp-resultado.
           ASSIGN tmp-resultado.nm-banco  = caps(tmp2.nm-banco  )
                  tmp-resultado.nm-tabela = caps(tmp2.nm-tabela)
                  tmp-resultado.nm-indice = caps(tmp2.nm-indice)
                  tmp-resultado.nm-campo  = caps(tmp2.nm-campo).

           IF tmp1.nm-unico <> tmp2.nm-unico
           THEN do:
                  ASSIGN tmp-resultado.in-status = "UNICIDADE"
                         tmp-resultado.nm-unico  = caps(tmp1.nm-unico) + "|" + caps(tmp2.nm-unico).
                END.
           ELSE ASSIGN tmp-resultado.nm-unico = caps(tmp1.nm-unico).

           IF tmp1.nm-ativo <> tmp2.nm-ativo
           THEN DO:
                  IF tmp-resultado.in-status <> ""
                  THEN tmp-resultado.in-status = caps(tmp-resultado.in-status) + "|".

                  ASSIGN tmp-resultado.in-status = caps(tmp-resultado.in-status) + "STATUS"
                         tmp-resultado.nm-ativo = caps(tmp1.nm-ativo) + "|" + caps(tmp2.nm-ativo).
                END.
           ELSE ASSIGN tmp-resultado.nm-ativo = caps(tmp1.nm-ativo).

           IF tmp1.nm-ascendente <> tmp2.nm-ascendente
           THEN DO:
                  IF tmp-resultado.in-status <> ""
                  THEN tmp-resultado.in-status = caps(tmp-resultado.in-status) + "|".

                  ASSIGN tmp-resultado.in-status = caps(tmp-resultado.in-status) + "ORDENACAO"
                         tmp-resultado.nm-ascendente = caps(tmp1.nm-ascendente) + "|" + caps(tmp2.nm-ascendente).
                END.
           ELSE ASSIGN tmp-resultado.nm-ascendente = caps(tmp1.nm-ascendente).

         END.
END.

OUTPUT TO VALUE(nm-resultado-aux).
PUT UNFORMATTED "STATUS;BANCO;TABELA;INDICE;UNICO;ATIVO;CAMPO;ASCENDENTE" SKIP.

FOR EACH tmp-resultado WHERE tmp-resultado.nm-banco <> "":
    EXPORT DELIMITER ";" tmp-resultado.
END.
OUTPUT CLOSE.

MESSAGE "concluido!" SKIP
        ETIME / 1000 "segundos."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

