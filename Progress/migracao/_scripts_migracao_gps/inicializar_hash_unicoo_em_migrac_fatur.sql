declare
  hash_atual varchar2(100);
  vcont number := 0;
  
  function gerar_hash_faturamento_unicoo(pnrfatura varchar2) return varchar2 is
    v_linha       varchar2(32000) := ' ';
    v_linha_final varchar2(32000) := ' ';
    v_retorno     varchar2(100);
  begin
    begin
      select f.nrperiodo || f.nrregistro || f.nrcontrato || f.nrfamilia ||
             f.vltotal_faturado || f.dtvencimento || f.nrfatura ||
             f.tpfatura || f.vldesconto || f.vlir_fonte ||
             f.vlato_principal || f.peato_principal || f.nrparcela_contrato ||
             f.aorecebimento || f.aoemitido || f.vlbase_irrf ||
             f.aosituacao_fatura || f.txobservacoes || f.dtemissao ||
             f.vlacrescimo || f.aocontas_pagar || f.aocontabilizado ||
             f.nrpessoa_paga || f.dtdig_inicial || f.dtdig_final ||
             f.nrcontrato_paga || f.aoemite_cobranca || f.dtcalculo ||
             f.cdfuncionario || f.tpcontrato || f.cdvendedor ||
             f.qtparcela_atrasada || f.nopessoa_titular || f.dtcancelamento ||
             f.aoavulsa || f.nrnossonumero || f.vlato_nao_cooperativo ||
             f.vlbase_inss || f.cdfuncionario_cancelou ||
             f.aofatura_agrupamento || f.cdorigem_fatura ||
             f.nrregistro_contrato_original || f.cdoperacao_receber ||
             f.nrmotivo_exclusao || f.dtrecalculo ||
             f.cdfuncionario_recalculo || f.nrgeracao_fatura || f.cdlotacao ||
             f.aoarquivo_ptu_gerado || f.dtgeracao_arquivo_ptu ||
             f.cdfuncionario_geracao_ptu || f.aoaposentado_demitido ||
             f.dtreativacao || f.cdfuncionario_reativou || f.pejuros ||
             f.pemulta || f.aoparcelamento || f.nrcalculo || f.nrrecalculo ||
             f.aofaturado_somente_evento || f.peato_nao_cooperativo ||
             f.vlato_auxiliar || f.ctrl_fat_mensdd_unica ||
             f.cdcarteira_cobranca || f.dtcontabilizado ||
             f.dtcontabilizado_vencto || f.dtcontabilizado_cancel ||
             f.vlbase_iss || f.vliss || f.aoplano_acessorio ||
             f.nrfatura_desmembramento || f.pemulta_fatura ||
             f.pejuros_fatura || f.dtinicio_sem_cobranca_juros ||
             f.dtfim_sem_cobranca_juros || f.nrseq_fatura_intercambio ||
             f.nrnota_fiscal || f.cdserie_nota_fiscal ||
             f.nrperiodocobertura || f.vlantecipadoperiodocobertura ||
             f.nrperiodorateio1 || f.vlantecipadoperiodorateio1 ||
             f.nrperiodorateio2 || f.vlantecipadoperiodorateio2 || f.nrrps ||
             f.aoarquivo_a600_gerado || f.dtgeracao_arquivo_a600 ||
             f.cdfuncionario_geracao_a600 || f.aosituacao_nfse ||
             f.cdserie_rps || f.tpentrada_nfse || f.cdserie_nfse ||
             f.nrprotocolo_nfse || f.aosituacao_cancel_nfse ||
             f.tp_fatura_intercambio || f.nrfat_unica ||
             f.vlbase_iss_nao_retido || f.vliss_nao_retido || f.nrnfse ||
             f.aobaixa_fatura || f.dtbaixa_fatura || f.dtenvio_a500 ||
             f.txurl_nfse
        into v_linha
        from faturamento f
       where f.nrfatura = pnrfatura;
    exception
      when others then
        v_linha := pnrfatura;
    end;
  
    v_linha_final := v_linha;
  
    for x in (select *
                from producao.titulo_a_receber@unicoo_homologa t
               where t.nrdocumento = pnrfatura
               order by t.nrregistro_titulo) loop
    
      v_linha := x.cdempresa || x.nrregistro_cliente || x.nrcontrato ||
                 x.nrregistro_titulo || x.cdsituacao || x.nrdocumento ||
                 x.tpdocumento || x.cdportador || x.cdoperacao ||
                 x.nrnossonumero || x.nrvendedor || x.dttitulo ||
                 x.dtvencimento || x.dtexclusao || x.dtreferencia ||
                 x.vltitulo || x.vlabatimento || x.vlabatimento_2 ||
                 x.dtultimo_recebimento || x.vlrecebido || x.vlmulta ||
                 x.vljuros || x.vldesconto || x.dtenvio_banco ||
                 x.dtconfirma_banco || x.txreferencia_banco ||
                 x.txhistorico || x.dtprotesto || x.nocartorio_protesto ||
                 x.txobservacoes || x.cdcentro_custo ||
                 x.nrregistro_tit_agrup || x.nrregistro_tit_desm ||
                 x.cdhistorico || x.vlfaturado || x.vlir_fonte ||
                 x.vl_ir_fonte_fat || x.dtintegracao || x.nrparcela ||
                 x.cdfuncionario || x.cdvendedor || x.tptitulo ||
                 x.nrultimoenvio || x.dtultimoenvio || x.cdultimoenvio ||
                 x.nrultimoretorno || x.dtultimoretorno ||
                 x.cdultimoretorno || x.cdcomando_envio ||
                 x.cdcomando_retorno || x.cdmovimento_envio ||
                 x.cdmovimento_retorno || x.cdcliente || x.cdcomando_atual ||
                 x.vltaxa_bancaria || x.dtultimo_envio ||
                 x.dtultimo_retorno || x.nrultimo_envio ||
                 x.nrultimo_retorno || x.pejuros || x.pemulta || x.nrbanco ||
                 x.nragencia || x.nrsequencianotafiscalven ||
                 x.tptaxaformamulta || x.tptaxaformajuros || x.vltaxamulta ||
                 x.vltaxajuros || x.nrtaxadiacarencia ||
                 x.aodescontoantecipado || x.nrdiadescontoantecipado ||
                 x.pedescontoantecipado || x.petaxabancaria ||
                 x.nrdiaprotesto || x.nrdiasprotesto ||
                 x.nrdiasdescontoantecipado || x.vldescontoantecipado ||
                 x.nrrepresentante || x.nrnota_fiscal_devolucao ||
                 x.cdportadoragencia || x.cdportadorcontacorrente ||
                 x.nrcontacorrente || x.nrdiacarencia || x.vllucro_vendor ||
                 x.vldespesa_cartorio || x.aoemite_cobranca ||
                 x.nrconta_corrente || x.nrmotivo_exclusao ||
                 x.nrperiodo_compet || x.vlrecebido_servico_oferecido ||
                 x.rregistro_cliente || x.vldespesa_cartoria ||
                 x.vldiferenca_recebimento || x.vldiferenca_juros ||
                 x.aotrata_taxa || x.nrinstrucao ||
                 x.nrcomposicao_credito_ir || x.dtencerramento ||
                 x.cdorigem || x.vlabatimento_imposto ||
                 x.nrlote_faturamento || x.cdidentificador_deposito ||
                 x.cdcomando_debaut || x.cdcarteira_cobranca ||
                 x.nrperiodocobertura || x.vlantecipadoperiodocobertura ||
                 x.nrperiodorateio1 || x.vlantecipadoperiodorateio1 ||
                 x.nrperiodorateio2 || x.vlantecipadoperiodorateio2 ||
                 x.vlutilizadoperiodocobertura ||
                 x.vlutilizadoperiodorateio1 || x.vlutilizadoperiodorateio2 ||
                 x.dtvencimento_original;
    
      v_linha_final := v_linha_final || v_linha;
    end loop;

    dbms_output.put_line(v_linha_final);
  
    v_retorno := md5(v_linha_final);
  
    return v_retorno;
  end gerar_hash_faturamento_unicoo;

begin
  dbms_output.enable(null);
  dbms_output.disable;
  
  for x in (select f.cod_livre_3, f.progress_recid from gp.migrac_fatur f) loop
    hash_atual := gerar_hash_faturamento_unicoo(x.cod_livre_3);
    update gp.migrac_fatur f set f.cod_livre_9 = hash_atual where f.progress_recid = x.progress_recid;
    vcont := vcont + 1;
    if vcont > 500 then
      vcont := 0;
      commit;
    end if;
  end loop;  
  commit;
end;


--select count(*) from migrac_fatur
