-- eliminar mensagens de erro
delete from ti_falha_de_processo fa
where exists(select 1 from ti_controle_integracao c
where c.nrsequencial = fa.nrseq_controle_integracao
and c.tpintegracao = 'CL'
and c.cdsituacao = 'ER');

-- eliminar TI_CLIENTE com erro, para reprocessamento
delete from ti_cliente where cdsituacao = 'ER';

-- alterar TI_CONTROLE_INTEGRACAO para GE, para que seja reutilizado no proximo processamento
update ti_controle_integracao
   set cdsituacao = 'GE'
 where cdsituacao = 'ER'
   and tpintegracao = 'CL';
      
commit;
