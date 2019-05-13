-- eliminar os registros de ERRO_PROCESS_IMPORT sem relacionamento com CONTRATANTE, PROPOSTA e BENEFICIÁRIO
delete from gp.erro_process_import e 
 where exists(select 1 from temp_migracao_contratante c
                      where c.nrseq_controle = e.num_seqcial_control
                        and c.cdsituacao not in ('ER','PE'));
                        
delete from gp.erro_process_import e 
 where exists(select 1 from gp.import_propost ip
                      where ip.num_seqcial_control = e.num_seqcial_control
                        and ip.u##ind_sit_import not in ('ER','PE'));
                        
delete from gp.erro_process_import e 
 where exists(select 1 from gp.import_bnfciar ib
                      where ib.num_seqcial_control = e.num_seqcial_control
                        and ib.u##ind_sit_import not in ('ER','PE'));

