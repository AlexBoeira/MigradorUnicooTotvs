-- listar titulos que deve baixar e nao estao em TI_CX_BX_ACR
select count(*)
  from ti_tit_acr t, ti_controle_integracao ci
 where ci.nrsequencial = t.nrseq_controle_integracao
   and not exists (select 1
          from ti_matriz_receber b
         where b.nrregistro_titulo = ci.nrsequencial_origem)
   and not exists
 (select 1
          from ti_cx_bx_acr bx, ti_controle_integracao ci2
         where bx.nrseq_controle_integracao = ci2.nrsequencial
           and ci2.nrsequencial_origem = ci.nrsequencial_origem)
		   
		   
		   
--=============================
--CONTADOR DE TITULOS ABERTOS
/*
select count(*) from ti_tit_acr t, ti_controle_integracao ci
       where ci.nrsequencial = t.nrseq_controle_integracao
       and exists (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = ci.nrsequencial_origem)
*/
--CONTADOR DE TITULOS FECHADOS
/*
select count(*) from ti_tit_acr t, ti_controle_integracao ci
       where ci.nrsequencial = t.nrseq_controle_integracao
       and not exists (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = ci.nrsequencial_origem)
*/

--SITUACAO DOS TITULOS ABERTOS
/*
select t.cdsituacao,count(*) from ti_tit_acr t, ti_controle_integracao ci
       where ci.nrsequencial = t.nrseq_controle_integracao
       and exists (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = ci.nrsequencial_origem) group by t.cdsituacao

--SITUACAO DOS TITULOS FECHADOS
select t.cdsituacao,count(*) from ti_tit_acr t, ti_controle_integracao ci
       where ci.nrsequencial = t.nrseq_controle_integracao
       and not exists (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = ci.nrsequencial_origem) group by t.cdsituacao
               */
               
