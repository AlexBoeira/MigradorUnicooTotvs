-- monitorar status importação propostas
select ip.u##ind_sit_import, count(*) from import_propost ip
-- where (ip.dat_fim_propost is null or ip.dat_fim_propost > sysdate)
group by ip.u##ind_sit_import
order by ip.u##ind_sit_import
;
/*
ANTES: IT	201124

GE	3
IT	201120
PE	1
*/
/*update gp.import_bnfciar ib set ib.u##ind_sit_import = 'PE', ib.ind_sit_import = 'PE'
where exists(select 1 from gp.import_propost ip where ip.u##ind_sit_import = 'GE' and ip.nr_contrato_antigo = ib.nr_contrato_antigo)

update gp.import_propost ip set ip.u##ind_sit_import = 'PE', ip.ind_sit_import = 'PE' where ip.u##ind_sit_import = 'GE'
*/
