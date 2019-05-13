--inicializar hash nas propostas ja migradas
--obs: vai setar o hash atual do UNICOO em toda a IMPORT_PROPOST
declare
  ix_atualizado number := 0;
  ix_commit number := 0;
begin
  dbms_output.enable(null);
  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
                       'INICIO');
  
  for x in (select cdp.nrregistro, cdp.nrcontrato, ip.progress_recid
              from contrato_da_pessoa cdp,
                   gp.import_propost ip
             where ip.num_livre_2 = cdp.nrregistro
               and ip.num_livre_3 = cdp.nrcontrato) loop
               
    ix_atualizado := ix_atualizado + 1;

--    dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
--                         'ANTES: nrsequencial_usuario: ' || x.nrsequencial_usuario);
    
    update gp.import_propost ip set ip.cod_livre_8 = pck_unicoogps.gerar_hash_contrato_unicoo(x.nrregistro, x.nrcontrato)
     where ip.progress_recid = x.progress_recid;
         
--    dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
--                         'DEPOIS: nrsequencial_usuario: ' || x.nrsequencial_usuario);
         
    ix_commit := ix_commit + 1;
    if ix_commit >= 500 then
      ix_commit := 0;
      commit;
    end if;
  end loop;
  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
                     'FIM. QT ALTERADOS: ' || ix_atualizado);
  commit;
end;

--select * from gp.import_propost ip where ip.cod_livre_8 = ' ' 
--4min
