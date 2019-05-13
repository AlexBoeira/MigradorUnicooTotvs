-- CARREGAR AS TABELAS DE PARAMETROS COM BASE EM OUTRA INSTÂNCIA DO TOTVS, QUE DEVE ESTAR NA MESMA VERSÃO
-- DO DICIONÁRIO DE DADOS.

declare
    cursor c_tables is
      select 'insert into ' || t.owner || '.' || t.table_name || ' * from ' 
             || t.owner || '.' || t.TABLE_NAME || '@TOTVS_HML_PROD;'
             comando
        from tm_tabelas_parametros t;

  begin
    for c in c_tables loop

      execute immediate c.comando;

    end loop;

end;
