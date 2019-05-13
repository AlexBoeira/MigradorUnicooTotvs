-- listar erros importacao fornecedor
select fo.cod_fornecedor, fo.cdsituacao, fa.*, fo.*
  from ti_falha_de_processo fa, ti_fornecedor fo
 where fo.nrseq_controle_integracao = fa.nrseq_controle_integracao
   and fo.cdsituacao <> 'IT'

   --and fa.txfalha like '%o deve ser informado%' for update
   
--select * from ti_fornecedor tf where tf.cod_fornecedor = 22894 for update
   
   
/*
declare
begin
  for x in (
          select fo.cod_fornecedor, fo.cdsituacao, fo.nrseq_controle_integracao
          from ti_falha_de_processo fa, ti_fornecedor fo
          where fo.nrseq_controle_integracao = fa.nrseq_controle_integracao
          and fo.cdsituacao <> 'IT'
          and fa.txfalha like '%o Estadual.%'
    ) loop
  update ti_fornecedor tf set tf.cod_id_feder_estad_jurid = 'ISENTO' ,
                              tf.cdsituacao = 'R0'
   where tf.nrseq_controle_integracao = x.nrseq_controle_integracao;
end loop;
end;
*/
