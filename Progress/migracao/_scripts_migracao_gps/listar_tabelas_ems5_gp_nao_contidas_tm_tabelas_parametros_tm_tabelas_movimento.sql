-- LISTAR TABELAS DO EMS5 E GP QUE NÃO ESTÃO EM TM_TABELAS_PARAMETROS E NEM EM EM_TABELAS_MOVIMENTOS
select * from all_tables t
where (   t.OWNER like ('EMS5')
       or t.OWNER like ('GP'))
and not exists(select 1 from tm_tabelas_movimentacao tm where tm.table_name = t.TABLE_NAME)
and not exists(select 1 from tm_tabelas_parametros tp where tp.table_name = t.TABLE_NAME)


p_criar_new_tm_tabelas_ems5_gp