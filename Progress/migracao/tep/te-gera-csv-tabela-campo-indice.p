/*        hqDb:QUERY-PREPARE("FOR EACH " + LDBNAME(i) + "._File NO-LOCK WHERE NOT _Hidden, EACH _field NO-LOCK WHERE _field._file-recid = RECID(_file)").*/

OUTPUT TO c:\temp\tabela-campo-indice.csv.
FOR EACH _File NO-LOCK 
   WHERE NOT _Hidden, 
    EACH _index NO-LOCK
   WHERE _index._file-recid = RECID(_file),
    EACH _index-field NO-LOCK
   WHERE _index-field._index-recid = RECID(_index),
    EACH _field NO-LOCK 
   WHERE recid(_field) = _index-field._field-recid:

    PUT UNFORMATTED _file._file-name ";" _index._index-name ";" _field._field-name SKIP.

END.
OUTPUT CLOSE.
