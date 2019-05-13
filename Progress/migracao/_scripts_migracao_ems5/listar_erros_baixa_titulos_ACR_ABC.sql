-- listar erros importacao da baixa de titulos ACR por quantidade de ocorrencias
select fa.txfalha, fa.txajuda, count(*)
  from ems506unicoo.ti_falha_de_processo fa
 where exists
 (select 1
          from ems506unicoo.ti_cx_bx_acr btr
         where btr.nrseq_controle_integracao = fa.nrseq_controle_integracao
           and btr.cdsituacao = 'PE')
 group by fa.txfalha, fa.txajuda
 order by 3 desc;
