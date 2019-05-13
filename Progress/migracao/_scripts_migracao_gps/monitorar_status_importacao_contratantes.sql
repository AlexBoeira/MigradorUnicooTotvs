--MONITORAR  CONTRATANTES
select cdsituacao, count(*)
  from temp_migracao_contratante
 group by cdsituacao;

/*
select * --contrato_da_pessoa
  from contrato_da_pessoa cdp,
       (select vlmoradia nrregistro
          from temp_migracao_contratante t
         where t.cdsituacao = 'ER') c
 where cdp.nrregistro = c.nrregistro;
 
select *--pessoa_paga do contrato_da_pessoa
  from contrato_da_pessoa cdp,
       (select vlmoradia nrregistro
          from temp_migracao_contratante t
         where t.cdsituacao = 'ER') c
 where cdp.nrpessoa_paga = c.nrregistro;

select cdp.* --pessoa_paga da familia
  from contrato_da_pessoa cdp, familia f 
       where f.nrregistro = cdp.nrregistro
         and f.nrcontrato = cdp.nrcontrato
         and nvl(f.nrpessoa_paga,nrpessoa_titular) is not null
         and nvl(f.nrpessoa_paga,nrpessoa_titular) <> 0
         and exists(select 1 from temp_migracao_contratante t where t.vlmoradia = nvl(f.nrpessoa_paga,f.nrpessoa_titular) and t.cdsituacao = 'ER');
*/