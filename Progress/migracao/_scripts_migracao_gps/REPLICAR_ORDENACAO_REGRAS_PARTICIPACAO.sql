--replicar ordenacao das regras de participacao conforme depara
declare
  vid_ordem number;
begin
  dbms_output.enable(null);
  
  for x in (select d.*, o.* from depara_replicar_agrupador d, gp.ord_valid_faturam o
                      where o.cdn_agrup_regra_faturam = d.cd_agrupador_origem) loop
  
    select max(id_ordem) into vid_ordem from gp.ord_valid_faturam;
    
    vid_ordem := vid_ordem + 1;
  
    insert into gp.ord_valid_faturam(cdn_agrup_regra_faturam,
                                     id_ordem,
                                     dat_inic,
                                     dat_fim,
                                     progress_recid)
                                     values(x.cd_agrupador_destino,
                                            vid_ordem,
                                            '01/01/1900',
                                            '31/12/9999',
                                            gp.ord_valid_faturam_seq.nextval);
                                            
    for y in (select r.* from gp.ord_regra_faturam r, gp.regra_faturam regra
                       where r.id_ordem = x.id_ordem
                         and r.cdn_regra = regra.cdn_regra
                         and regra.cdn_agrup_regra_faturam = x.cd_agrupador_origem) loop
                                       
      dbms_output.put_line(y.cdn_regra || ';' || vid_ordem || ';' || substr(y.cdn_regra, 1, 1) || lpad(x.cd_agrupador_destino, 3, '0') || substr(y.cdn_regra, 5, 3));
                                                        
      insert into gp.ord_regra_faturam(cdn_regra,
                                       cdn_ord_exec,
                                       id_ordem,
                                       progress_recid)
                                       values(substr(y.cdn_regra, 1, 1) || lpad(x.cd_agrupador_destino, 3, '0') || substr(y.cdn_regra, 5, 3),
                                              y.cdn_ord_exec,
                                              vid_ordem,
                                              gp.ord_regra_faturam_seq.nextval);
                                            
    end loop;
  end loop;
end;

--select count(*) from ord_valid_faturam--102
--select count(*) from ord_regra_faturam--267

--select * from gp.ord_regra_faturam r where r.cdn_regra = 9052001
