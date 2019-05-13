-- setar beneficiarios a serem apagados para situacao 'APAGAR' e chamar o metodo da pck
update gp.import_bnfciar b set b.ind_sit_import = 'APAGAR', b.u##ind_sit_import = 'APAGAR'
--where b.ind_sit_import in ('PE','RC','ER');
where b.ind_sit_import not in ('DEPARA','EV','IT');

begin
  pck_unicoogps.p_apagar_benef_e_temps;
  commit;
end;


--update gp.import_bnfciar b set b.ind_sit_import = 'APAGAR', b.u##ind_sit_import = 'APAGAR'
--where b.ind_sit_import in ('PE','RC','ER');
--where b.num_seqcial = 138661;

