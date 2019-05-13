-- títulos ACR em que falta preencher DE/PARA 
select TC.CDIDENTIFICADOR nrdocumento, 
       tc.cdempresa, 
       tc.cdmodulo, 
       tc.cdmovimento 
  from ti_controle_integracao tc 
 where tc.tpintegracao = 'TR' 
   and exists (select 1 
          from ti_falha_de_processo tf 
         where tc.nrsequencial = tf.nrseq_controle_integracao 
           and tf.txfalha like '%A view V_TI_TIT_ACR%') 
 order by cdmodulo, cdmovimento

--select * from ti_tipo_movimento_tit_acr
