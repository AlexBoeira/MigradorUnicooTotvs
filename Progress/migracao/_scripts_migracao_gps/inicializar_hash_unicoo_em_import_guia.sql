--inicializar hash nas guias ja migradas
declare
  ix_atualizado number := 0;
  ix_commit number := 0;
begin
  dbms_output.enable(null);
  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
                       'INICIO');
  
  for x in (select s.nrseq_serv_autorizacao,
                   s.nrautorizacao,
                   s.nrocorrencia,
                   igm.u##ind_tip_guia,
                   igm.val_seq_guia,
                   igm.progress_recid,
                   igm.cod_livre_9 --hash das tabelas originais do unicoo
              from servico_da_autorizacao s,
                   autorizacao            a,
                   gp.import_guia_movto   igm
             where a.nrautorizacao = s.nrautorizacao
               and a.dtdigitacao >= '01/01/2018'
               and igm.num_livre_5 = s.nrseq_serv_autorizacao
               and (igm.cod_livre_9 is null or igm.cod_livre_9 = ' ')) loop
    ix_atualizado := ix_atualizado + 1;

--  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
--                       'ANTES: nrseq_serv_autorizacao: ' || x.nrseq_serv_autorizacao);
    
    update gp.import_guia_movto m set m.cod_livre_9 = 
             pck_unicoogps.gerar_hash_servico_da_autoriz(x.nrseq_serv_autorizacao,
                                               x.nrautorizacao,
                                               x.nrocorrencia)
         where m.progress_recid = x.progress_recid;     
         
--  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
--                       'DEPOIS: nrseq_serv_autorizacao: ' || x.nrseq_serv_autorizacao);
         
    ix_commit := ix_commit + 1;
    if ix_commit >= 500 then
      ix_commit := 0;
      commit;
    end if;
  end loop;
  dbms_output.put_line(to_char(systimestamp, 'HH24:MI:ss.FF') || ' ' ||
                     'FIM. QT ALTERADOS: ' + ix_atualizado);
  commit;
end;
