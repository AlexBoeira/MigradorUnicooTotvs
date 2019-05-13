set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
--eliminar beneficiarios com falha para reprocessar
/*
  begin
    for x in (select *
                from import_bnfciar ib
               where ib.u##ind_sit_import in ('ER','RC','PE','DEPARA','GE')) loop
               
      delete from erro_process_import e
       where e.num_seqcial_control = x.num_seqcial_control;
    
      delete from control_migrac c
       where c.num_seqcial_orig = x.num_seqcial_bnfciar
         and c.ind_tip_migrac = 'BE';
    
      delete from import_bnfciar ib
       where ib.progress_recid = x.progress_recid;
    end loop;
  end;
  commit;
*/
  begin
    pck_unicoogps.P_GERA_PROPOSTA_R2(null, --NRREGISTRO
                                     null, --NRCONTRATO
                                     null); --NRSEQCIAL_BNFCIAR
	
    commit;
  end;
end;
/
--select count(*) from control_migrac c, import_bnfciar ib 
--where c.u##ind_tip_migrac = 'BE'
--and c.num_seqcial_orig = ib.num_seqcial_bnfciar;
