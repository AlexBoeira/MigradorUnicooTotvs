--procurar pessoas no EMS5 sem relacionamentos
select * from ems5.pessoa_fisic pf where 
                                           not exists(select 1 from ems5.representante r where r.num_pessoa = pf.num_pessoa_fisic)
                                       and not exists(select 1 from ems5.cliente c where c.num_pessoa = pf.num_pessoa_fisic)
                                       and not exists(select 1 from ems5.fornecedor f where f.num_pessoa = pf.num_pessoa_fisic);

select * from ems5.pessoa_jurid pj where 
                                           not exists(select 1 from ems5.representante r where r.num_pessoa = pj.num_pessoa_jurid)
                                       and not exists(select 1 from ems5.cliente c where c.num_pessoa = pj.num_pessoa_jurid)
                                       and not exists(select 1 from ems5.fornecedor f where f.num_pessoa = pj.num_pessoa_jurid)
                                       and not exists(select 1 from ems5.estabelecimento e where e.num_pessoa_jurid = pj.num_pessoa_jurid);
