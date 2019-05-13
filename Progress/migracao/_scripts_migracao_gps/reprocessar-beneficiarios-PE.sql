-- setar beneficiarios com situacao PE (pendencia importacao) para serem reprocessados
update gp.import_bnfciar b set b.ind_sit_import = 'RE', b.u##ind_sit_import = 'RE'
where b.ind_sit_import in ('PE')
  and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate);
--where b.ind_sit_import in ('PE','ER','RC');
--where b.ind_sit_import not in ('DEPARA','EV','IT');

begin
  pck_unicoogps.p_reprocessa_beneficiario;
  commit;
end;
