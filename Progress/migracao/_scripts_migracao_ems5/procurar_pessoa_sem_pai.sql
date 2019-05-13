select * from ti_pessoa p
where p.nrregistro_pai is not null
and p.nrregistro_pai != 0
and not exists(select 1 from ti_pessoa ppai
where ppai.nrregistro = p.nrregistro_pai)
