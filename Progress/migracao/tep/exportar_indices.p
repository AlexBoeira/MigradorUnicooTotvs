/*
 * OBJETIVO: gerar um CSV (;) com as colunas BANCO, TABELA, INDICE, CRC-INDICE, UNICO, ATIVO, CAMPO, ASCENDENTE.
 *           com essas informacoes eh possivel confrontar diferentes ambientes para levantar as diferencas entre os schemas.
 */
DEFINE VARIABLE fName           AS CHAR     NO-UNDO.
DEFINE VARIABLE i               AS INT      NO-UNDO.
DEFINE VARIABLE valueBanco      AS CHAR     NO-UNDO.
DEFINE VARIABLE valueTabela     AS CHAR     NO-UNDO.
DEFINE VARIABLE valueIndice     AS CHAR     NO-UNDO.
DEFINE VARIABLE valueUNICO      AS CHAR     NO-UNDO.
DEFINE VARIABLE valueATIVO      AS CHAR     NO-UNDO.
DEFINE VARIABLE valueASCENDENTE AS CHAR     NO-UNDO.
DEFINE VARIABLE valueTabelaAnt  AS CHAR     NO-UNDO.
DEFINE VARIABLE valueCRC        AS CHAR     NO-UNDO.
DEFINE VARIABLE valueField      AS CHAR     NO-UNDO.
DEFINE VARIABLE valueType       AS CHAR     NO-UNDO.
DEFINE VARIABLE valueFormat     AS CHAR     NO-UNDO.
DEFINE VARIABLE ds-linha-aux    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hqDb            AS HANDLE   NO-UNDO.
DEFINE VARIABLE bufT            AS HANDLE   NO-UNDO.
DEFINE VARIABLE bufI            AS HANDLE   NO-UNDO.
DEFINE VARIABLE bufIF           AS HANDLE   NO-UNDO.
DEFINE VARIABLE bufF            AS HANDLE   NO-UNDO.

DEF VAR alias-entrada AS CHAR INIT "SRMOVBEN,SRMOVCON,SRMOVFI1,SRMOVFIN,SRWEB" NO-UNDO.
DEF VAR alias-saida   AS CHAR INIT "SRCADGER,SRCADGER,SRCADGER,SRCADGER,SRCADGER" NO-UNDO.

FUNCTION retorna-alias RETURNS CHAR (INPUT ds-par AS CHAR):
    DEF VAR ix-aux AS INT NO-UNDO.
    ix-aux = lookup(DS-PAR,alias-entrada).
    IF ix-aux > 0
    THEN DO:
           ASSIGN ds-par = ENTRY(ix-aux,alias-saida,",").
         END.
    RETURN ds-par.
END FUNCTION.

FUNCTION remove-acentos RETURNS CHAR (INPUT ds-par AS CHAR):

    assign ds-par = replace(ds-par, '∑', 'A')
           ds-par = replace(ds-par, 'µ', 'A')
           ds-par = replace(ds-par, '∂', 'A')
           ds-par = replace(ds-par, '«', 'A')
           ds-par = replace(ds-par, 'é', 'A')
           ds-par = replace(ds-par, '‘', 'E')
           ds-par = replace(ds-par, 'ê', 'E')
           ds-par = replace(ds-par, '“', 'E')
           ds-par = replace(ds-par, '”', 'E')
           ds-par = replace(ds-par, 'ﬁ', 'I')
           ds-par = replace(ds-par, '÷', 'I')
           ds-par = replace(ds-par, '◊', 'I')
           ds-par = replace(ds-par, 'ÿ', 'I')
           ds-par = replace(ds-par, '„', 'O')
           ds-par = replace(ds-par, '‡', 'O')
           ds-par = replace(ds-par, '‚', 'O')
           ds-par = replace(ds-par, 'Â', 'O')
           ds-par = replace(ds-par, 'ô', 'O')
           ds-par = replace(ds-par, 'Î', 'U')
           ds-par = replace(ds-par, 'È', 'U')
           ds-par = replace(ds-par, 'Í', 'U')
           ds-par = replace(ds-par, 'ö', 'U')
           ds-par = replace(ds-par, 'Ì', 'Y')
           ds-par = replace(ds-par, 'ü', 'Y')
           ds-par = replace(ds-par, 'Ä', 'C')
           ds-par = replace(ds-par, '•', 'N')
           ds-par = replace(ds-par, 'Ö', 'a')
           ds-par = replace(ds-par, '†', 'a')
           ds-par = replace(ds-par, 'É', 'a')
           ds-par = replace(ds-par, '∆', 'a')
           ds-par = replace(ds-par, 'Ñ', 'a')
           ds-par = replace(ds-par, 'ä', 'e')
           ds-par = replace(ds-par, 'Ç', 'e')
           ds-par = replace(ds-par, 'à', 'e')
           ds-par = replace(ds-par, 'â', 'e')
           ds-par = replace(ds-par, 'ç', 'i')
           ds-par = replace(ds-par, '°', 'i')
           ds-par = replace(ds-par, 'å', 'i')
           ds-par = replace(ds-par, 'ã', 'i')
           ds-par = replace(ds-par, 'ï', 'o')
           ds-par = replace(ds-par, '¢', 'o')
           ds-par = replace(ds-par, 'ì', 'o')
           ds-par = replace(ds-par, '‰', 'o')
           ds-par = replace(ds-par, 'î', 'o')
           ds-par = replace(ds-par, 'ó', 'u')
           ds-par = replace(ds-par, '£', 'u')
           ds-par = replace(ds-par, 'ñ', 'u')
           ds-par = replace(ds-par, 'Å', 'u')
           ds-par = replace(ds-par, 'Ï', 'y')
           ds-par = replace(ds-par, 'ò', 'y')
           ds-par = replace(ds-par, 'á', 'c')
           ds-par = replace(ds-par, '§', 'n')
           ds-par = replace(ds-par, '¶', 'a')
           ds-par = replace(ds-par, 'ß', 'o')
           ds-par = replace(ds-par, '&', 'E').
    
    RETURN caps(ds-par).

end FUNCTION.

ASSIGN fName = "C:\temp\indices.csv".

DEF VAR ix AS INT NO-UNDO.

OUTPUT TO VALUE(fName).

ETIME(TRUE).

PUT UNFORMATTED "BANCO;TABELA;INDICE;CRC INDICE;UNICO;ATIVO;CAMPO;ASCENDENTE" SKIP.

DO i = 1 TO NUM-DBS WITH 10 DOWN:
    IF DBTYPE(LDBNAME(i)) = 'PROGRESS' THEN DO:

        ASSIGN  valueBanco  = STRING(LDBNAME(i)).        

        CREATE QUERY hqDb.
        CREATE BUFFER bufT  FOR TABLE (LDBNAME(i) + "._File").
        CREATE BUFFER bufI  FOR TABLE (LDBNAME(i) + "._index").
        CREATE BUFFER bufIF FOR TABLE (LDBNAME(i) + "._index-field").
        CREATE BUFFER bufF  FOR TABLE (LDBNAME(i) + "._field").
        hqDb:SET-BUFFERS(bufT,bufI,bufIF,bufF).
        
        hqDb:QUERY-PREPARE("FOR EACH " + LDBNAME(i) + "._File NO-LOCK WHERE NOT _Hidden, " +
                               "EACH _index NO-LOCK WHERE _index._file-recid = RECID(_file), " +
                               "EACH _index-field NO-LOCK WHERE _index-field._index-recid = RECID(_index), " +
                               "EACH _field NO-LOCK WHERE recid(_field) = _index-field._field-recid").
        hqDb:QUERY-OPEN.
        REPEAT:  
            hqDb:GET-NEXT().

            IF hqDb:QUERY-OFF-END THEN LEAVE.

            ix = ix + 1.

            ASSIGN  valueTabela     = STRING(bufT:BUFFER-FIELD("_file-name"):BUFFER-VALUE)
                    valueIndice     = STRING(bufI:BUFFER-FIELD("_index-name"):BUFFER-VALUE)
                    valueCRC        = STRING(bufI:BUFFER-FIELD("_idx-CRC"):BUFFER-VALUE)
                    valueUNICO      = STRING(bufI:BUFFER-FIELD("_unique"):BUFFER-VALUE)
                    valueATIVO      = STRING(bufI:BUFFER-FIELD("_active"):BUFFER-VALUE)
                    valueField      = STRING(bufF:BUFFER-FIELD("_field-name"):BUFFER-VALUE)
                    valueASCENDENTE = STRING(bufIF:BUFFER-FIELD("_ascending"):BUFFER-VALUE).

            PUT UNFORMATTED remove-acentos(string(retorna-alias(valueBanco) + ";" +  valueTabela + ";" + valueIndice + ";" + valueCRC + ";" + 
                                   valueUNICO + ";" + valueATIVO + ";" + valueField + ";" + valueASCENDENTE)) SKIP.

/*              IF valueTabelaAnt <> valueTabela
              THEN DO:
                     PUT UNFORMATTED ds-linha-aux SKIP.
                     ds-linha-aux = string(valueBanco + ";" +  valueTabela + ";" + valueCRC + ";").
                   END.
              ELSE DO:
                     ds-linha-aux = ds-linha-aux + STRING(valueField + ";" + valueType + ";" + valueFormat + ";").
                   END.*/
                   
              valueTabelaAnt = valueTabela.

              /*IF ix > 1000 THEN LEAVE.*/
        END.

        hqDb:QUERY-CLOSE().
        DELETE OBJECT hqDb.
    END.
END.

OUTPUT CLOSE.

MESSAGE "Feito!" SKIP
    ETIME / 1000 SKIP
    ix
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
