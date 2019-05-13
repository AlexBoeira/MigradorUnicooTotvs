--CORRIGIR DESCRICAO DO ORGAO EMISSOR DA IDENTIDADE NAS ENTIDADES DO GPS CONFORME PESSOA DO UNICOO
declare
begin
  for x in (select pf.id_pessoa,
                   pf.ds_orgao_emissor_ident,
                   p.noorgao_emissor_rg,
                   (select o.cdvalor_externo
                      from temp_depara_orgao_emissor o
                     where o.cdvalor_interno = p.noorgao_emissor_rg) ds_orgao_emissor
              from gp.pessoa_fisica pf, pessoa p
             where p.nrregistro = pf.id_pessoa
               and p.noorgao_emissor_rg is not null
               and p.nrinscest_rg is not null) loop
               
      update pessoa_fisica pf set pf.ds_orgao_emissor_ident = x.ds_orgao_emissor
        where pf.id_pessoa = x.id_pessoa;
        
      update gp.usuario u set u.ds_orgao_emissor_ident = x.ds_orgao_emissor
        where u.id_pessoa = x.id_pessoa;
        
      update gp.contrat c set c.ds_orgao_emissor_ident = x.ds_orgao_emissor
        where c.id_pessoa = x.id_pessoa;
        
      update gp.preserv ps set ps.ds_orgao_emissor_ident = x.ds_orgao_emissor
        where ps.id_pessoa = x.id_pessoa;
        
  end loop;
end;
