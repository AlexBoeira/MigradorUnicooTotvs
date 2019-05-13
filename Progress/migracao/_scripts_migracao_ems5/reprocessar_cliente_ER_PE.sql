-- reprocessar clientes com erro
delete from ti_falha_de_processo tf
 where exists (select 1
          from ti_controle_integracao tc
         where tf.nrseq_controle_integracao = tc.nrsequencial
           and tc.tpintegracao = 'CL'
           and tc.cdsituacao in ('PE', 'ER'));

delete from ti_cliente c where c.cdsituacao IN ('PE', 'ER');

update ti_controle_integracao
   set cdsituacao = 'GE'
 where tpintegracao = 'CL'
   and cdsituacao in ('ER', 'PE');

begin
  pck_ems506unicoo.P_JOB;
  commit;
end;
