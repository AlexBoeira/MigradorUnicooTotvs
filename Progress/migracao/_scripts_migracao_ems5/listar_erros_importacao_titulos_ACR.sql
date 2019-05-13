-- listar erros importacao de titulos ACR
select fa.*, tr.*, tta.*
  from ti_falha_de_processo fa, ti_controle_integracao tr, ti_tit_acr tta
 where tr.nrsequencial = fa.nrseq_controle_integracao
   and tr.tpintegracao = 'TR'
   and tta.nrseq_controle_integracao = tr.nrsequencial
   and tr.cdsituacao = 'PE';

--select * from ti_tit_acr ta where ta.nrseq_controle_integracao = 12106157
--CLIENTE TOTVS: 75881
--PORTADOR: 1361

/*
1361

update ti_tit_acr a
   set a.cod_portador = 1361, a.cdsituacao = 'RC'
 where a.cod_portador = 3411
   and a.cdsituacao = 'PE'
   and exists
 (select 1
          from ti_falha_de_processo fa, ti_controle_integracao tr
         where tr.nrsequencial = fa.nrseq_controle_integracao
           and tr.nrsequencial = a.nrseq_controle_integracao)

Portador 3411 não cadastrado !

select * from ti_tit_acr c where c.nrseq_controle_integracao = 12501265

select * from ems5.portador

select * from ti_tipo_movimento_tit_acr
select * from ti_parametro_integracao
select * from ti_banco--11,1361,2371,331,3411
*/