-- ATUALIZAR TM_TABELAS_MOVIMENTACAO e TM_TABELAS_PARAMETROS COM A QUANTIDADE DE REGISTROS
declare 

    vcount number;

  begin

    for x in (

              select ' select count(*) from ' || m.owner || '.' || table_name comando,
                      m.table_name,
                      m.owner
                from tm_tabelas_movimentacao m) loop

      execute immediate x.comando
        into vcount;

      update tm_tabelas_movimentacao tm
         set tm.num_rows = vcount
       where tm.owner = x.owner
         and tm.table_name = x.table_name;

    end loop;

    for x in (

              select ' select count(*) from ' || m.owner || '.' || table_name comando,
                      m.table_name,
                      m.owner
                from tm_tabelas_parametros m) loop

      execute immediate x.comando
        into vcount;

      update tm_tabelas_parametros tm
         set tm.num_rows = vcount
       where tm.owner = x.owner
         and tm.table_name = x.table_name;

    end loop;

    --commit;
  end;
