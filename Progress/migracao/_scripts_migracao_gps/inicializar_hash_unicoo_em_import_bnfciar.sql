--inicializar hash nos beneficiarios ja migrados
--obs: vai setar o hash atual do UNICOO em toda a IMPORT_BNFCIAR
declare
  ix_atualizado number := 0;
  ix_commit number := 0;
begin
  dbms_output.enable(null);
  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
                       'INICIO');
  
  for x in (select u.nrsequencial_usuario, ib.progress_recid
              from usuario u,
                   gp.import_bnfciar ib
             where u.nrsequencial_usuario = ib.num_seqcial_bnfciar) loop
               
    ix_atualizado := ix_atualizado + 1;

--    dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
--                         'ANTES: nrsequencial_usuario: ' || x.nrsequencial_usuario);
    
    update gp.import_bnfciar ib set ib.cod_livre_8 = pck_unicoogps.gerar_hash_usuario_unicoo(x.nrsequencial_usuario)
     where ib.progress_recid = x.progress_recid;
         
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
