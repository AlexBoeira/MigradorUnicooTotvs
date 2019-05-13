select count(*) from control_migrac--18365172
select count(*) from erro_process_import--4645023

-- eliminar os registros de CONTROL_MIGRAC sem relacionamento com CONTRATANTE, PROPOSTA, BENEFICIÁRIO e IMPORT_GUIA

-- contar registros a serem eliminados
select count(*) from control_migrac cm --15.952.673
where not exists(select 1 from gp.import_propost ip where ip.num_seqcial_control = cm.num_seqcial_orig)
  and not exists(select 1 from gp.import_bnfciar ib where ib.num_seqcial_control = cm.num_seqcial_orig)
  and not exists(select 1 from temp_migracao_contratante c where c.nrsequencial = cm.num_seqcial_orig)
  and not exists(select 1 from gp.import_guia ig where ig.num_seqcial_control = cm.num_seqcial_orig)
  ;
  
-- contar registros que possuem relacionamentos
select count(*) from control_migrac cm --4564525
where exists(select 1 from gp.import_propost ip where ip.num_seqcial_control = cm.num_seqcial_orig)
   or exists(select 1 from gp.import_bnfciar ib where ib.num_seqcial_control = cm.num_seqcial_orig)
   or exists(select 1 from temp_migracao_contratante c where c.nrsequencial = cm.num_seqcial_orig)
   or exists(select 1 from gp.import_guia ig where ig.num_seqcial_control = cm.num_seqcial_orig);
   

-- eliminar os registros sem relacionamento
delete from control_migrac cm
where not exists(select 1 from gp.import_propost ip where ip.num_seqcial_control = cm.num_seqcial_orig)
  and not exists(select 1 from gp.import_bnfciar ib where ib.num_seqcial_control = cm.num_seqcial_orig)
  and not exists(select 1 from temp_migracao_contratante c where c.nrsequencial = cm.num_seqcial_orig)
  and not exists(select 1 from gp.import_guia ig where ig.num_seqcial_control = cm.num_seqcial_orig);
commit;
analyze table gp.control_migrac compute statistics for table for all indexes for all indexed columns;
analyze table gp.erro_process_import compute statistics for table for all indexes for all indexed columns;
