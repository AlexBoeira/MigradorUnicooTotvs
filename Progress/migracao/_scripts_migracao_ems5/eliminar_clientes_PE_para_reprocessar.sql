-- eliminar mensagens de erro
delete from ti_falha_de_processo fa
where exists(select 1 from ti_cliente c
where c.nrseq_controle_integracao = fa.nrseq_controle_integracao
and c.cdsituacao = 'PE');

-- eliminar TI_CLIENTE pendentes, para reprocessamento
delete from ti_cliente where cdsituacao = 'PE';

-- alterar TI_CONTROLE_INTEGRACAO para GE, para que seja reutilizado no proximo processamento
update ti_controle_integracao
   set cdsituacao = 'GE'
 where cdsituacao = 'PE'
   and tpintegracao = 'CL';
      
commit;
