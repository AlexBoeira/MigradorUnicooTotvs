-- reprocessar titulos ACR
delete from ti_falha_de_processo tf
where exists (select 1 from ti_controle_integracao tc
where tf.nrseq_controle_integracao = tc.nrsequencial
and tc.tpintegracao = 'TR'
and tc.cdsituacao in ('ER','PE'));

delete from ti_tit_acr t
where t.cdsituacao in ('ER','PE');

update ti_controle_integracao
  set cdsituacao = 'GE'
  where tpintegracao = 'TR'
  and cdsituacao in ('ER','PE');
commit;

begin
  pck_ems506unicoo.P_JOB;
  commit;
end;
/
