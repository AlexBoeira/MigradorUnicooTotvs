/*
 * OBJETIVO: gerar um CSV (;) com as colunas BANCO, TABELA, CRC, CAMPO, TIPO e FORMAT.
 *           com essas informacoes eh possivel confrontar diferentes ambientes para levantar as diferencas entre os schemas.
 *      OBS: essa versao nao considera INDICES nas comparacoes.
 */
DEFINE VARIABLE fName           AS CHAR     NO-UNDO.
DEFINE VARIABLE i               AS INT      NO-UNDO.
DEFINE VARIABLE valueBanco      AS CHAR     NO-UNDO.
DEFINE VARIABLE valueTabela     AS CHAR     NO-UNDO.
DEFINE VARIABLE valueTabelaAnt  AS CHAR     NO-UNDO.
DEFINE VARIABLE valueCRC        AS CHAR     NO-UNDO.
DEFINE VARIABLE valueField      AS CHAR     NO-UNDO.
DEFINE VARIABLE valueType       AS CHAR     NO-UNDO.
DEFINE VARIABLE valueFormat     AS CHAR     NO-UNDO.
DEFINE VARIABLE ds-linha-aux    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hqDb            AS HANDLE   NO-UNDO.
DEFINE VARIABLE bufT            AS HANDLE   NO-UNDO.
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

    assign ds-par = replace(ds-par, '�', 'A')
           ds-par = replace(ds-par, '�', 'A')
           ds-par = replace(ds-par, '�', 'A')
           ds-par = replace(ds-par, '�', 'A')
           ds-par = replace(ds-par, '�', 'A')
           ds-par = replace(ds-par, '�', 'E')
           ds-par = replace(ds-par, '�', 'E')
           ds-par = replace(ds-par, '�', 'E')
           ds-par = replace(ds-par, '�', 'E')
           ds-par = replace(ds-par, '�', 'I')
           ds-par = replace(ds-par, '�', 'I')
           ds-par = replace(ds-par, '�', 'I')
           ds-par = replace(ds-par, '�', 'I')
           ds-par = replace(ds-par, '�', 'O')
           ds-par = replace(ds-par, '�', 'O')
           ds-par = replace(ds-par, '�', 'O')
           ds-par = replace(ds-par, '�', 'O')
           ds-par = replace(ds-par, '�', 'O')
           ds-par = replace(ds-par, '�', 'U')
           ds-par = replace(ds-par, '�', 'U')
           ds-par = replace(ds-par, '�', 'U')
           ds-par = replace(ds-par, '�', 'U')
           ds-par = replace(ds-par, '�', 'Y')
           ds-par = replace(ds-par, '�', 'Y')
           ds-par = replace(ds-par, '�', 'C')
           ds-par = replace(ds-par, '�', 'N')
           ds-par = replace(ds-par, '�', 'a')
           ds-par = replace(ds-par, '�', 'a')
           ds-par = replace(ds-par, '�', 'a')
           ds-par = replace(ds-par, '�', 'a')
           ds-par = replace(ds-par, '�', 'a')
           ds-par = replace(ds-par, '�', 'e')
           ds-par = replace(ds-par, '�', 'e')
           ds-par = replace(ds-par, '�', 'e')
           ds-par = replace(ds-par, '�', 'e')
           ds-par = replace(ds-par, '�', 'i')
           ds-par = replace(ds-par, '�', 'i')
           ds-par = replace(ds-par, '�', 'i')
           ds-par = replace(ds-par, '�', 'i')
           ds-par = replace(ds-par, '�', 'o')
           ds-par = replace(ds-par, '�', 'o')
           ds-par = replace(ds-par, '�', 'o')
           ds-par = replace(ds-par, '�', 'o')
           ds-par = replace(ds-par, '�', 'o')
           ds-par = replace(ds-par, '�', 'u')
           ds-par = replace(ds-par, '�', 'u')
           ds-par = replace(ds-par, '�', 'u')
           ds-par = replace(ds-par, '�', 'u')
           ds-par = replace(ds-par, '�', 'y')
           ds-par = replace(ds-par, '�', 'y')
           ds-par = replace(ds-par, '�', 'c')
           ds-par = replace(ds-par, '�', 'n')
           ds-par = replace(ds-par, '�', 'a')
           ds-par = replace(ds-par, '�', 'o')
           ds-par = replace(ds-par, '&', 'E').
    
    RETURN caps(ds-par).

end FUNCTION.

ASSIGN fName = "C:\temp\arq.csv".

DEF VAR ix AS INT NO-UNDO.

OUTPUT TO VALUE(fName).

ETIME(TRUE).

PUT UNFORMATTED "BANCO;TABELA;CRC;CAMPO;TIPO;FORMAT" SKIP.

DO i = 1 TO NUM-DBS WITH 10 DOWN:
    IF DBTYPE(LDBNAME(i)) = 'PROGRESS' THEN DO:

        ASSIGN  valueBanco  = STRING(LDBNAME(i)).        

        CREATE QUERY hqDb.
        CREATE BUFFER bufT FOR TABLE (LDBNAME(i) + "._File").
        CREATE BUFFER bufF FOR TABLE (LDBNAME(i) + "._field").
        hqDb:SET-BUFFERS(bufT,bufF).
        hqDb:QUERY-PREPARE("FOR EACH " + LDBNAME(i) + "._File NO-LOCK WHERE NOT _Hidden, EACH _field NO-LOCK WHERE _field._file-recid = RECID(_file)").
        hqDb:QUERY-OPEN.
        REPEAT:  
            hqDb:GET-NEXT().

            IF hqDb:QUERY-OFF-END THEN LEAVE.

            ix = ix + 1.

            ASSIGN  valueTabela = STRING(bufT:BUFFER-FIELD("_file-name"):BUFFER-VALUE)
                    valueCRC    = STRING(bufT:BUFFER-FIELD("_CRC"):BUFFER-VALUE)

                    valueField  = STRING(bufF:BUFFER-FIELD("_field-name"):BUFFER-VALUE)
                    valueType   = STRING(bufF:BUFFER-FIELD("_data-type"):BUFFER-VALUE)
                    valueFormat = STRING(bufF:BUFFER-FIELD("_format"):BUFFER-VALUE).

            PUT UNFORMATTED remove-acentos(string(retorna-alias(valueBanco) + ";" +  valueTabela + ";" + valueCRC + ";" + valueField + ";" + valueType + ";" + valueFormat)) SKIP.

              valueTabelaAnt = valueTabela.
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
