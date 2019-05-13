--esse script foi criado para contornar um defeito do migrador. não deve mais ser utilizado. guardado apenas para referencia.
set echo off
select 'PROPOSTAS COMO IT MAS NAO EXISTEM NO TOTVS:' TITULO from dual;
select count(*)
  from gp.import_propost ip
 where ip.u##ind_sit_import = 'IT'
   and not exists (select 1
          from gp.propost p
         where p.nr_contrato_antigo = ip.nr_contrato_antigo);

begin
  for x in (select ip.progress_recid, ip.nr_contrato_antigo from gp.import_propost ip
             where not exists (select 1
                                from gp.propost p
                               where p.nr_contrato_antigo = ip.nr_contrato_antigo)
) loop
    update gp.import_bnfciar ib
       set ib.u##ind_sit_import = 'GE', ib.ind_sit_import = 'GE', ib.cod_livre_9 = null
     where ib.nr_contrato_antigo = x.nr_contrato_antigo;
  
    update gp.import_propost ip
       set ip.u##ind_sit_import = 'GE', ip.ind_sit_import = 'GE', ip.cod_livre_9 = null
     where ip.progress_recid = x.progress_recid;
  end loop;
end;     
/
select 'BENEFICIARIOS COMO IT MAS NAO EXISTEM NO TOTVS:' TITULO from dual;
select count(*)
  from gp.import_bnfciar ib
 where ib.u##ind_sit_import = 'IT'
   and not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = ib.cd_modalidade
           and u.nr_proposta = ib.nr_proposta
           and u.cd_usuario = ib.num_livre_6);

update gp.import_bnfciar ib
   set ib.u##ind_sit_import = 'GE', ib.ind_sit_import = 'GE', ib.cod_livre_9 = null
 where ib.u##ind_sit_import = 'IT'
   and not exists (select 1
          from gp.usuario u
         where u.cd_modalidade = ib.cd_modalidade
           and u.nr_proposta = ib.nr_proposta
           and u.cd_usuario = ib.num_livre_6);
/
