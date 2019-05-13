-- reprocessar fornecedores com erro
delete from ti_falha_de_processo tf
 where exists (select 1
          from ti_controle_integracao tc
         where tf.nrseq_controle_integracao = tc.nrsequencial
           and tc.tpintegracao = 'FN'
           and tc.cdsituacao in ('PE', 'ER'));

delete from ti_fornecedor c where c.cdsituacao IN ('PE', 'ER');

update ti_controle_integracao
   set cdsituacao = 'GE'
 where tpintegracao = 'FN'
   and cdsituacao in ('ER', 'PE');

begin
  pck_ems506unicoo.P_JOB;
  commit;
end;
/

--delete from ti_controle_integracao c where c.tpintegracao = 'FN' and c.cdsituacao = 'GE'