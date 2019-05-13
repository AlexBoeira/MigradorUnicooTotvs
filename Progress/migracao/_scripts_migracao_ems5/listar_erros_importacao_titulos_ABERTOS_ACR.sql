-- listar erros importacao de titulos ABERTOS ACR
select fa.*, tr.*
  from ti_falha_de_processo fa, ti_controle_integracao tr
 where tr.nrsequencial = fa.nrseq_controle_integracao
   and tr.tpintegracao = 'TR'
   and tr.cdsituacao = 'PE'
   and exists
 (select 1
          from ti_matriz_receber b
         where b.nrregistro_titulo = TR.nrsequencial_origem)
