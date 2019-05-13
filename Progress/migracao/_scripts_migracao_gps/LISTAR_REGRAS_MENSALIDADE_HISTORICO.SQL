--REGRAS DE HISTORICO QUE NAO SAO ASSOCIADAS AOS CONTRATOS
select rm.cdd_regra,
       rm.dat_inic,
       rm.dat_fim,
       c.dat_inic,
       c.dat_fim,
       c.cd_padrao_cobertura,
       c.cd_modulo,
       c.cd_grau_parentesco,
       c.nr_faixa_etaria,
       c.nr_idade_minima,
       c.nr_idade_maxima,
       c.vl_mensalidade_base,
       c.vl_taxa_inscricao
  from regra_menslid rm, regra_menslid_criter c
 where rm.des_regra like '%HISTORICO%'
   and c.cdd_regra = rm.cdd_regra;

--LIMPAR AS REGRAS DE HISTORICO
/*
declare
begin
  for x in (select rm.cdd_regra,
                   rm.dat_inic INIC_REGRA,
                   rm.dat_fim FIM_REGRA,
                   c.dat_inic INIC_CRITERIO,
                   c.dat_fim FIM_CRITERIO,
                   c.cd_padrao_cobertura,
                   c.cd_modulo,
                   c.cd_grau_parentesco,
                   c.nr_faixa_etaria,
                   c.nr_idade_minima,
                   c.nr_idade_maxima,
                   c.vl_mensalidade_base,
                   c.vl_taxa_inscricao,
                   rm.progress_recid RECID_REGRA,
                   c.progress_recid RECID_CRITERIO
              from regra_menslid rm, regra_menslid_criter c
             where rm.des_regra like '%HISTORICO%'
               and c.cdd_regra = rm.cdd_regra) loop
               
               delete from regra_menslid r where r.progress_recid = x.recid_regra;
               delete from regra_menslid_criter c where c.progress_recid = x.recid_criterio;
  end loop;
end;
*/