-- MUITA ATEN��O COM ESSE SCRIPT: TRUNCA TODAS AS TABELAS DE EMS5 E GPS.
-- UTILIZAR APENAS QUANDO ESTIVER INICIANDO UMA NOVA MIGRA��O DO ZERO!
-- O C�DIGO EST� COMENTADO POR SEGURAN�A. DESCOMENTAR QUANDO FOR UTILIZAR.

/*
declare
    cursor c_tables is
      select 'TRUNCATE TABLE ' || t.owner || '.' || t.table_name comando
        from all_tables t
where (   t.OWNER like ('EMS5')
       or t.OWNER like ('GP'));

  begin
    for c in c_tables loop

      execute immediate c.comando;

    end loop;

end;
*/