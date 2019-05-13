-- eliminar mensagens de erro
delete from ti_falha_de_processo fa
where exists(select 1 from ti_fornecedor f
where f.nrseq_controle_integracao = fa.nrseq_controle_integracao
and f.cdsituacao = 'PE');

-- eliminar TI_FORNECEDOR pendentes, para reprocessamento
delete from ti_fornecedor where cdsituacao = 'PE';

-- alterar TI_CONTROLE_INTEGRACAO para GE, para que seja reutilizado no proximo processamento
update ti_controle_integracao
   set cdsituacao = 'GE'
 where cdsituacao = 'PE'
   and tpintegracao = 'FN';
      
commit;
