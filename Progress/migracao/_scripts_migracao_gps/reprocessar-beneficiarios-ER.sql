-- setar beneficiarios com situacao ER (erro extrator) para serem reprocessados
update gp.import_bnfciar b set b.ind_sit_import = 'RE', b.u##ind_sit_import = 'RE'
where b.ind_sit_import = 'ER'
/*
   and exists (select 1
          from erro_process_import e
         where e.num_seqcial_control = p.num_seqcial_control
           and e.des_erro like '%(64)%')
--           and rownum = 1
*/
;

begin 
      pck_unicoogps.p_reprocessa_beneficiario;
      commit;
end;
