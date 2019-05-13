-- listar erros de importacao de titulos APB
select fa.*, ci.*, tp.*
from ti_falha_de_processo fa, ti_controle_integracao ci, ti_tit_apb tp
where ci.nrsequencial = fa.nrseq_controle_integracao
and tp.nrseq_controle_integracao = ci.nrsequencial
and ci.tpintegracao = 'TP'
and ci.cdsituacao =  'PE';

--select * from ti_parametro_integracao

/*select * from ti_tit_apb p, ti_falha_de_processo f
where p.cdsituacao <> 'IT'
and f.nrseq_controle_integracao = p.nrseq_controle_integracao

select * from ti_tit_apb p
where p.cdsituacao <> 'IT'
and not exists(select 1 from ti_falha_de_processo f where f.nrseq_controle_integracao = p.nrseq_controle_integracao)
*/
/*
select p.cdsituacao, ci.cdsituacao, p.*, ci.* from ti_tit_apb p, ti_controle_integracao ci
where ci.nrsequencial = p.nrseq_controle_integracao
  and p.nrseq_controle_integracao in (8664332,
8664344,
8666827,
8666828,
8666855,
8666856,
8666859,
8666860,
8666861,
8666862,

8660132,
8662460,
8662938,
8662957,
8662976,

8664320)

select * from ti_falha_de_processo f where f.nrseq_controle_integracao in (8664332,
8664344,
8666827,
8666828,
8666855,
8666856,
8666859,
8666860,
8666861,
8666862,

8660132,
8662460,
8662938,
8662957,
8662976,

8664320)
*/
