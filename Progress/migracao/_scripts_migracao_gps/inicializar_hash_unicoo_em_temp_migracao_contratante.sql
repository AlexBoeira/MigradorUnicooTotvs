declare
  hash_atual varchar2(100);
  vcont number := 0;
begin
  for x in (select t.nrregistro from temp_migracao_contratante t) loop
    hash_atual := pck_unicoogps.gerar_hash_contratante_unicoo(x.nrregistro);
    update temp_migracao_contratante t
       set t.hash = hash_atual
     where t.nrregistro = x.nrregistro;
     
     vcont := vcont + 1;
     if vcont > 500 then
       commit;
       vcont := 0;
     end if;
  end loop;
  commit;
end;

--select * from temp_migracao_contratante c where c.hash is null;
