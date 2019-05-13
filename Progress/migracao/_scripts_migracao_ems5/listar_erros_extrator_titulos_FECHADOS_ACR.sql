-- listar erros do extrator de titulos FECHADOS ACR - esses casos nao foram criados em TI_TIT_ACR
select fa.*, tr.*
  from ti_falha_de_processo fa, ti_controle_integracao tr
 where tr.nrsequencial = fa.nrseq_controle_integracao
   and tr.tpintegracao = 'TR'
   and tr.cdsituacao = 'ER'
   and not exists
 (select 1
          from ti_matriz_receber b
         where b.nrregistro_titulo = TR.nrsequencial_origem)