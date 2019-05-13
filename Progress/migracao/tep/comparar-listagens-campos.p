/**
 * OBJETIVO: comparar 2 arquivos em formato CSV (;) que contenham exatamente as colunas BANCO;TABELA;CRC;CAMPO;TIPO;FORMAT (gerado pelo exportar_campos.p).
 *           ao final listara um CSV com os campos/tabelas que existem em apenas um dos arquivos ou que existem em ambos mas sao diferentes.
 *
 *   STATUS: <<          tabela existe apenas no 1o arquivo
 *           >>          tabela existe apenas no 2o arquivo
 *           <           campo existe apenas no 1o arquivo
 *           >           campo existe apenas no 2o arquivo
 *           TIPO        campo existe em ambos com tipo diferente (lista ambos, separado por |)
 *           FORMAT      campo existe em ambos com format diferente (lista ambos, separado por |)
 *           TIPO|FORMAT campo existe em ambos com tipo e format diferentes (lista ambos, separado por |)
 * 
 *           Trata os nomes dos 2 arquivos a serem comparados de forma fixa: c:\temp\arq1.csv e c:\temp\arq2.csv.
 *           Saida: c:\temp\diferenca-schemas.csv
 */
 
DEF TEMP-TABLE tmp1 NO-UNDO
    FIELD nm-banco AS CHAR
    FIELD nm-tabela AS CHAR
    FIELD ds-crc AS INTEGER
    FIELD nm-campo AS CHAR
    FIELD nm-tipo AS CHAR
    FIELD nm-format AS CHAR
    FIELD in-status AS CHAR
    INDEX pk
          nm-banco
          nm-tabela
          nm-campo
          nm-tipo
          nm-format
    INDEX i-status
          in-status.

DEF TEMP-TABLE tmp2 NO-UNDO
    FIELD nm-banco AS CHAR
    FIELD nm-tabela AS CHAR
    FIELD ds-crc AS INTEGER
    FIELD nm-campo AS CHAR
    FIELD nm-tipo AS CHAR
    FIELD nm-format AS CHAR
    FIELD in-status AS CHAR
    INDEX pk
          nm-banco
          nm-tabela
          nm-campo
          nm-tipo
          nm-format
    INDEX i-status
          in-status.

DEF TEMP-TABLE tmp-resultado NO-UNDO
    FIELD in-status AS CHAR
    FIELD nm-banco AS CHAR
    FIELD nm-tabela AS CHAR
    FIELD nm-campo AS CHAR
    FIELD nm-tipo AS CHAR
    FIELD nm-format AS CHAR
    INDEX i-banco
          nm-banco
    INDEX i2
          in-status
          nm-banco
          nm-tabela.

DEF VAR nm-arquivo1-aux AS CHAR INIT "c:\temp\arq1.csv" NO-UNDO.
DEF VAR nm-arquivo2-aux AS CHAR INIT "c:\temp\arq2.csv" NO-UNDO.
DEF VAR nm-resultado-aux AS CHAR INIT "c:\temp\diferenca-schemas.csv" NO-UNDO.

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
                AND tmp2.nm-tabela = tmp1.nm-tabela:

    IF tmp2.ds-crc    = tmp1.ds-crc
    THEN ASSIGN tmp2.in-status = "="
                tmp1.in-status = "=".
END.
*/

/* checar se a tabela/campo existe em tmp1 e nao existe em tmp2*/
FOR EACH tmp1:
    /* nivel tabela*/
    IF NOT CAN-FIND(FIRST tmp2
                    WHERE tmp2.nm-banco  = tmp1.nm-banco 
                      AND tmp2.nm-tabela = tmp1.nm-tabela)
    THEN do:
           IF NOT CAN-FIND(FIRST tmp-resultado
                           WHERE tmp-resultado.in-status = "<<"
                             AND tmp-resultado.nm-banco  = tmp1.nm-banco 
                             AND tmp-resultado.nm-tabela = tmp1.nm-tabela)
           THEN DO:
                  CREATE tmp-resultado.
                  ASSIGN tmp-resultado.in-status = "<<"
                         tmp-resultado.nm-banco  = caps(tmp1.nm-banco )
                         tmp-resultado.nm-tabela = caps(tmp1.nm-tabela)
                         tmp1.in-status = "<<".
                END.
         END.
    /* nivel campo*/
    ELSE IF NOT CAN-FIND(FIRST tmp2
                         WHERE tmp2.nm-banco  = tmp1.nm-banco 
                           AND tmp2.nm-tabela = tmp1.nm-tabela
                           AND tmp2.nm-campo  = tmp1.nm-campo)
         THEN do:
                CREATE tmp-resultado.
                ASSIGN tmp-resultado.in-status = "<"
                       tmp-resultado.nm-banco  = caps(tmp1.nm-banco )
                       tmp-resultado.nm-tabela = caps(tmp1.nm-tabela)
                       tmp-resultado.nm-campo  = caps(tmp1.nm-campo )
                       tmp-resultado.nm-tipo   = caps(tmp1.nm-tipo  )
                       tmp-resultado.nm-format = caps(tmp1.nm-format)
                       tmp1.in-status = "<".
              END.
END.

/* checar se a tabela/campo existe em tmp2 e nao existe em tmp1*/
FOR EACH tmp2:
    /* nivel tabela*/
    IF NOT CAN-FIND(FIRST tmp1
                    WHERE tmp1.nm-banco  = tmp2.nm-banco 
                      AND tmp1.nm-tabela = tmp2.nm-tabela)
    THEN do:
           IF NOT CAN-FIND(FIRST tmp-resultado
                           WHERE tmp-resultado.in-status = ">>"
                             AND tmp-resultado.nm-banco  = tmp2.nm-banco 
                             AND tmp-resultado.nm-tabela = tmp2.nm-tabela)
           THEN DO:
                  CREATE tmp-resultado.
                  ASSIGN tmp-resultado.in-status = ">>"
                         tmp-resultado.nm-banco  = caps(tmp2.nm-banco )
                         tmp-resultado.nm-tabela = caps(tmp2.nm-tabela)
                         tmp2.in-status = ">>".
                END.
         END.
    /* nivel campo*/
    ELSE IF NOT CAN-FIND(FIRST tmp1
                         WHERE tmp1.nm-banco  = tmp2.nm-banco 
                           AND tmp1.nm-tabela = tmp2.nm-tabela
                           AND tmp1.nm-campo  = tmp2.nm-campo)
         THEN do:
                CREATE tmp-resultado.
                ASSIGN tmp-resultado.in-status = ">"
                       tmp-resultado.nm-banco  = caps(tmp2.nm-banco )
                       tmp-resultado.nm-tabela = caps(tmp2.nm-tabela)
                       tmp-resultado.nm-campo  = caps(tmp2.nm-campo )
                       tmp-resultado.nm-tipo   = caps(tmp2.nm-tipo  )
                       tmp-resultado.nm-format = caps(tmp2.nm-format)
                       tmp2.in-status = ">".
              END.
END.

/* checar se campo existe em tmp1 e tmp2 mas com tipo ou format diferentes*/
FOR EACH tmp1 WHERE tmp1.in-status = "",
    EACH tmp2 WHERE tmp2.nm-banco  = tmp1.nm-banco
                AND tmp2.nm-tabela = tmp1.nm-tabela
                AND tmp2.nm-campo  = tmp1.nm-campo:

    IF  tmp1.nm-tipo   = tmp2.nm-tipo
    AND tmp1.nm-format = tmp2.nm-format
    THEN ASSIGN tmp1.in-status = "="
                tmp2.in-status = "=".
    ELSE DO:
           CREATE tmp-resultado.
           ASSIGN tmp-resultado.nm-banco  = caps(tmp2.nm-banco  )
                  tmp-resultado.nm-tabela = caps(tmp2.nm-tabela)
                  tmp-resultado.nm-campo  = caps(tmp2.nm-campo).

           IF tmp1.nm-tipo <> tmp2.nm-tipo
           THEN do:
                  ASSIGN tmp-resultado.in-status = "TIPO"
                         tmp-resultado.nm-tipo   = caps(tmp1.nm-tipo) + "|" + caps(tmp2.nm-tipo).
                END.
           ELSE ASSIGN tmp-resultado.nm-tipo = caps(tmp1.nm-tipo).

           IF tmp1.nm-format <> tmp2.nm-format
           THEN DO:
                  IF tmp-resultado.in-status <> ""
                  THEN tmp-resultado.in-status = caps(tmp-resultado.in-status) + "|".

                  ASSIGN tmp-resultado.in-status = caps(tmp-resultado.in-status) + "FORMAT"
                         tmp-resultado.nm-format = caps(tmp1.nm-format) + "|" + caps(tmp2.nm-format).
                END.
           ELSE ASSIGN tmp-resultado.nm-format = caps(tmp1.nm-format).
         END.
END.

OUTPUT TO VALUE(nm-resultado-aux).
PUT UNFORMATTED "STATUS;BANCO;TABELA;CAMPO;TIPO;FORMAT" SKIP.

FOR EACH tmp-resultado WHERE tmp-resultado.nm-banco <> "":
    EXPORT DELIMITER ";" tmp-resultado.
END.
OUTPUT CLOSE.

MESSAGE "concluido!" SKIP
        ETIME / 1000 "segundos."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

