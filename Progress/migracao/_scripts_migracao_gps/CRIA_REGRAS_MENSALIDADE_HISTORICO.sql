declare
    vnr_regra       number := 0;
    vcd_chave_preco varchar2(50);
    vnr_faixa       number := 0;
    vaomigrar       varchar2(1) := 'S';
    vnr_modulo_mens number;
begin
    --Migracao dos historicos de precos dos planos de saude do Unicoo que nao viraram modelo
    --As regras criadas nesta fase nao terão estruturas associadas a ela.
    begin
      select nvl(max(r.cdd_regra),0) into vnr_regra from gp.regra_menslid r;
    exception
      when no_data_found then
        vnr_regra := 0;
    end;
    
    for hregras in (select 'HISTORICO PRECO - PLANO DE SAUDE: ' || pr.cdcontrato || ' - DESCRICAO: ' || cp.nocontrato des_regra,

                            --pr.dtinicio_vigencia dat_inic,
                            --nvl(pr.dtfinal_vigencia,'31/12/9999') dat_fim,
							              
                            cp.dtinivigen dat_inic,
                            nvl(cp.dtfimvigen,'31/12/9999') dat_fim,
                            
                            pr.nrtabela_padrao nrtabela_padrao, pr.nrcontrato nrcontrato
                     from preco_referencia_padrao pr, contrato_padrao cp
                     where pr.cdcontrato = cp.cdcontrato
                    order by 1)
    loop

      vnr_regra := vnr_regra + 1;

      --insere a tabela do plano de saude
      insert into gp.regra_menslid
        (cdd_regra,
         des_regra,
         dat_inic,
         dat_fim,
         des_obs,
         cdn_tip_idx,
         in_tipo_regra,
         log_livre_1, --indicador se é regra modelo
         progress_recid)
      values
        (vnr_regra,
         hregras.des_regra,
         trunc(hregras.dat_inic, 'mm'), --primeiro dia do mês
         last_day(hregras.dat_fim), --ultimo dia do mês
         ' ',
         1,
         1,
         0, -- 1: é regra modelo; 0: é regra de um contrato/beneficiário
         gp.regra_menslid_seq.nextval);

        --insere os criterios da estrutura
        for hcriterio in (select case
                                  when p.cdusucateg <> '*' then
                                   nvl((select distinct cdvalor_externo
                                         from rem_tab_conversao     r,
                                              rem_tab_conversao_exp re,
                                              tipo_de_usuario       tu
                                        where r.nrseq =
                                              re.nrseq_tab_conversao
                                          and r.notabela =
                                              'MIGRACAO_GRAU_PARENTESCO'
                                          and re.cdvalor_interno =
                                              tu.tpusuario
                                          and tu.cdusucateg = p.cdusucateg),
                                       '0')
                                  else
                                   case
                                     when p.tpdependente = 'T' then
                                      '01'
                                     when p.tpdependente = 'A' then
                                      f_tm_parametro('CDGRAU_AGREGADO')
                                     else
                                      '00'
                                   end
                                end cd_grau_parentesco,
                                cp.cdcontrato pl_saude,
                                cp.dtinivigen ini_vigencia_pl,
                                cp.dtfimvigen fim_vigencia_pl,
                                --pr.dtinicio_vigencia ini_vigencia_preco,
                                --Nvl(pr.dtfinal_vigencia,to_date('31/12/9999','DD/MM/YYYY')) fim_vigencia_preco,
                                
                                decode(p.nrperiodo_ult_reajuste,0,cp.dtinivigen,'01/'||substr(p.nrperiodo_ult_reajuste,5,2) || '/' ||
                                                                                       substr(p.nrperiodo_ult_reajuste,1,4)) ini_vigencia_preco,
                                nvl(
                                   nvl(
                                    (select to_date(min('01/' || substr(pcp.nrperiodo_ult_reajuste,5,2) || '/' || substr(pcp.nrperiodo_ult_reajuste,1,4)),'DD/MM/YYYY') - 1
                                       from preco_contrato_padrao pcp
                                      where pcp.nrtabela_padrao        = p.nrtabela_padrao
                                        and pcp.nrperiodo_ult_reajuste > p.nrperiodo_ult_reajuste),
                                    cp.dtfimvigen), '31/12/9999') fim_vigencia_preco,
                                p.*
                           from preco_contrato_padrao p, preco_referencia_padrao pr, contrato_padrao cp
                          where pr.nrtabela_padrao = p.nrtabela_padrao
                            and cp.cdcontrato      = pr.cdcontrato
                            and p.nrtabela_padrao  = hregras.nrtabela_padrao
                          order by p.nrperiodo_ult_reajuste,
                                   p.cdcategserv,
                                   p.tpplano,
                                   p.cdusucateg,
                                   p.tpdependente,
                                   nrqtusuario_inicio,
                                   nridade_inicio) loop

          --Verifica se é a primeira faixa do preço para iniciar o número da faixa ou somar mais um
          if (hcriterio.nrperiodo_ult_reajuste || '-' || hcriterio.cdcategserv || '-' || hcriterio.tpplano || '-' ||
             hcriterio.cdusucateg || '-' || hcriterio.tpdependente || '-' ||
             hcriterio.nrqtusuario_inicio) <> vcd_chave_preco then
            vcd_chave_preco := hcriterio.nrperiodo_ult_reajuste || '-' ||
                               hcriterio.cdcategserv || '-' ||
                               hcriterio.tpplano || '-' ||
                               hcriterio.cdusucateg || '-' ||
                               hcriterio.tpdependente || '-' ||
                               hcriterio.nrqtusuario_inicio;
            vnr_faixa       := 1;

          else
            vnr_faixa := vnr_faixa + 1;
          end if;

          vaomigrar := 'S';

          begin
            select re.cdvalor_externo
              into vnr_modulo_mens
              from rem_tab_conversao r, rem_tab_conversao_exp re
             where r.nrseq = re.nrseq_tab_conversao
               and r.notabela = 'MIGRACAO_MODULO'
               and re.cdvalor_interno = hcriterio.cdcategserv;
          exception
            when no_data_found then
              vaomigrar := 'N';
          end;

          insert into gp.regra_menslid_criter
            (cdd_id,
             cdd_regra,
             u##cd_padrao_cobertura,
             cd_padrao_cobertura,
             cd_modulo,
             cd_grau_parentesco,
             nr_faixa_etaria,
             nr_idade_minima,
             nr_idade_maxima,
             vl_mensalidade_base,
             vl_taxa_inscricao,
             dat_inic,
             dat_fim,
             qt_repasse,
             num_livre_1,
             num_livre_2,
             progress_recid)
          values
            (seq_cdd_id.nextval,
             vnr_regra,
             null,--estrut.cd_padrao_cobertura,
             null,--estrut.cd_padrao_cobertura,
             vnr_modulo_mens, -- modulo da mensalidade
             hcriterio.cd_grau_parentesco,
             vnr_faixa,
             hcriterio.nridade_inicio,
             hcriterio.nridade_fim,
             hcriterio.vlpreco_mensal, -- vl_mensalidade_base,
             hcriterio.vlpreco_inscricao, -- vl_taxa_inscricao,
             hcriterio.ini_vigencia_preco, -- dat_inic,
             hcriterio.fim_vigencia_preco, -- dat_fim,
             1, -- qt_repasse,
             decode(hcriterio.nrqtusuario_inicio,
                    0,
                    1,
                    hcriterio.nrqtusuario_inicio), -- qtusu_inicial
             decode(hcriterio.nrqtusuario_fim,
                    0,
                    999999,
                    hcriterio.nrqtusuario_fim), -- qtusu_final
             gp.regra_menslid_criter_seq.nextval);

        end loop; -- loop hcriterio

    end loop; --loop hregras
end;

-- LISTAR REGRAS DE HISTORICO QUE NAO SAO ASSOCIADAS AOS CONTRATOS
/*
select rm.cdd_regra,
       rm.des_regra,
       rm.dat_inic,
       rm.dat_fim,
       c.dat_inic,
       c.dat_fim,
       c.cd_modulo,
       c.cd_grau_parentesco,
       c.nr_faixa_etaria,
       c.nr_idade_minima,
       c.nr_idade_maxima,
       c.vl_mensalidade_base,
       c.vl_taxa_inscricao
  from regra_menslid rm, regra_menslid_criter c
 where rm.des_regra like '%HISTORICO%'
   and c.cdd_regra = rm.cdd_regra
       order by
                 rm.cdd_regra,
                 rm.dat_inic,
                 rm.dat_fim,
                 c.dat_inic,
                 c.dat_fim,
                 c.cd_modulo,
                 c.cd_grau_parentesco,
                 c.nr_faixa_etaria,
                 c.nr_idade_minima,
                 c.nr_idade_maxima
       ;
*/
