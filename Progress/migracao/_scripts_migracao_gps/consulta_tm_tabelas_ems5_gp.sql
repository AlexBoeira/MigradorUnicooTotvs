select t.owner,
       t.table_name,
       t.tipo,
       t.num_rows,
       t.num_rows_destino,
       t.validado
  from unicoogps.tm_tabelas_ems5_gp t
 where t.tipo is not null
   and t.tipo <> 'LIXO'
   and validado is not null
   and upper(t.validado) = 'OK'
 order by tipo, owner, table_name, num_rows desc, num_rows_destino desc
 