-- monitorar status importacao beneficiarios
-- STATUS EV: Beneficiário eventual. Não é migrado nesse processo. É criado em processo posterior.
select u##ind_sit_import, decode(log_respons,1,'T','D') TITULAR_DEPENDENTE, count(*) from import_bnfciar ib
--  where (ib.dt_exclusao_plano is null or ib.dt_exclusao_plano > sysdate)
  group by u##ind_sit_import, log_respons
  order by u##ind_sit_import, log_respons desc;

/*
0 D 369
20  D 356
3 D 367
EV  T 2331
EV  D 1
GE  T 1015
IT  T 330898
IT  D 186211
PE  T 21
PE  D 8
RC  T 188
RC  D 1709
*/

--SELECT u##ind_sit_import, count(*) from gp.import_bnfciar ib where ib.cod_livre_9 is not null group by u##ind_sit_import

--select * from tm_parametro for update
