-- precisa estar conectado no owner GP para executar essa procedure
declare 

  PCOMANDO1   VARCHAR2(4000);
  PCOMANDO2   VARCHAR2(4000);
  PCOMANDO3   VARCHAR2(4000);
  PCOMANDO4   VARCHAR2(4000);
  PNEXTVAL    NUMBER;
  PLASTNUMBER NUMBER;

  CURSOR C_SEQUENCES IS
    SELECT * FROM unicoogps.TM_SEQUENCES T;

/* cursor que lista todas as sequences do owner GP. nao esta sendo utilizado
  cursor c_seq_sistema
    select u.name,
           o.name SEQUENCE_NAME,
           s.minvalue MIN_VALUE,
           s.maxvalue MAX_VALUE,
           s.increment$ INCREMENT_BY,
           decode(s.cycle#, 0, 'N', 1, 'Y') CYCLE_FLAG,
           decode(s.order$, 0, 'N', 1, 'Y') ORDER_FLAG,
           s.cache CACHE_SIZE,
           s.highwater LAST_NUMBER
      from sys.seq$ s, sys.obj$ o, sys.user$ u
     where o.owner# = u.user#
       and o.obj# = s.obj#
       and o.type# = 6 --1: INDEX; 2: TABLE; 6: SEQUENCE; 
       and u.name in ('GP');
*/
BEGIN
  dbms_output.enable(9999999999999999);
  
  FOR C IN C_SEQUENCES LOOP
  
    PNEXTVAL := 0;
  
    PLASTNUMBER := 1;
  
    --buscar ultimo ID na tabela
    PCOMANDO1 := 'SELECT NVL(MAX(' || C.COLUMN_NAME || '),0)+1 FROM ' ||
                 c.owner_name || '.' || C.TABLE_NAME;
    BEGIN
      EXECUTE IMMEDIATE PCOMANDO1
        INTO PNEXTVAL;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
    dbms_output.put_line(PCOMANDO1 || ': ' || pnextval);
  
    --buscar maior valor da sequence
    PCOMANDO4 := 'SELECT LAST_NUMBER FROM USER_SEQUENCES WHERE SEQUENCE_NAME = ' || '''' ||
                 C.SEQUENCE_NAME || '''';
--    PCOMANDO4 := 'select ' || c.owner_name || '.' || c.sequence_name || '.nextval from dual;';
  
    BEGIN
      EXECUTE IMMEDIATE PCOMANDO4
        INTO PLASTNUMBER;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    dbms_output.put_line(PCOMANDO4 || ': ' || plastnumber);
    
    IF PNEXTVAL > PLASTNUMBER THEN
       dbms_output.put_line('PRECISA CORRIGIR!!!!!');
    end if;    
  
    --se o valor da tabela for maior que da sequence, recriar a sequence com o valor da tabela + 1
    IF PNEXTVAL > PLASTNUMBER THEN
      PCOMANDO2 := 'DROP SEQUENCE ' || c.owner_name || '.' || C.SEQUENCE_NAME;
    
      IF PNEXTVAL = 0 THEN
        PNEXTVAL := 1;
      END IF;
    
      BEGIN
        EXECUTE IMMEDIATE PCOMANDO2;
      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(PCOMANDO2 || ': ' || sqlerrm);
          NULL;
      END;
    
      PCOMANDO3 := 'CREATE SEQUENCE ' || c.owner_name || '.' || C.SEQUENCE_NAME || ' START WITH ' ||
                   PNEXTVAL || ' MINVALUE ' || PNEXTVAL;
    
      BEGIN
        EXECUTE IMMEDIATE PCOMANDO3;
      EXCEPTION
        WHEN OTHERS THEN
          dbms_output.put_line(PCOMANDO3 || ': ' || sqlerrm);
          NULL;
      END;
    
    END IF;

  END LOOP;

end;
