-- setar propostas  com situacao ER (erro extrator) para serem reprocessadas
update gp.import_propost p
   set p.ind_sit_import = 'RE', p.u##ind_sit_import = 'RE'
 where p.ind_sit_import in ('ER','CORIGEM','CONTRAT')
/*
   and exists (select 1
          from erro_process_import e
         where e.num_seqcial_control = p.num_seqcial_control
           and e.des_erro like '%(64)%')
--           and rownum = 1
*/
;

begin 
      pck_unicoogps.p_reprocessa_proposta;
      commit;
end;
