-- setar propostas  com situacao PE (pendencia importacao) para serem reprocessadas
update gp.import_propost p set p.ind_sit_import = 'RE', p.u##ind_sit_import = 'RE'
where p.ind_sit_import in ('PE','CORIGEM','CONTRAT');
commit;
begin 
      pck_unicoogps.p_reprocessa_proposta;
      commit;
end;
