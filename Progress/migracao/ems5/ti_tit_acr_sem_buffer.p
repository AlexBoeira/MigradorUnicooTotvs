DEF INPUT PARAM in-status-par AS CHAR NO-UNDO.

/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */                                                       
/* -------------------------------------------------------------------- */
/* {ems5\deftemp-acr.i} */

def new shared temp-table tt_integr_acr_lote_impl no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field ttv_cod_empresa_ext              as character format "x(3)" label "C�digo Empresa Ext" column-label "C�d Emp Ext" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie" 
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa��o" column-label "Dat Transac" 
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp�cie" column-label "Tipo Esp�cie" 
    field tta_ind_orig_tit_acr             as character format "X(8)" initial "ACREMS50" label "Origem Tit Cta Rec" column-label "Origem Tit Cta Rec" 
    field tta_val_tot_lote_impl_tit_acr    as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Total Movimento" 
    field tta_val_tot_lote_infor_tit_acr   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado" 
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran�a" column-label "Tipo Cobran�a" 
    field ttv_log_lote_impl_ok             as logical format "Sim/N�o" initial no 
    field tta_log_liquidac_autom           as logical format "Sim/N�o" initial no label "Liquidac Autom�tica" column-label "Liquidac Autom�tica" 
    index tt_id                            is primary unique 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_refer                    ascending. 


def temp-table tt_integr_acr_item_lote_impl_2 no-undo
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ?
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ�ncia" column-label "Seq"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi��o Cobran�a" column-label "Cond Cobran�a"
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist�rico Padr�o" column-label "Hist�rico Padr�o"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida��o" column-label "Prev Liquida��o"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss�o" column-label "Dt Emiss�o"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis"
    field tta_des_text_histor              as character format "x(2000)" label "Hist�rico" column-label "Hist�rico"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D�gito Cta Corrente" column-label "D�gito Cta Corrente"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc�ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc�ria 2" column-label "Instr Banc 2"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L�quido" column-label "Vl L�quido"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp�cie" column-label "Tipo Esp�cie"
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi��o Pagamento" column-label "Condi��o Pagamento"
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag�ncia"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa��o T�tulo" column-label "Situa��o T�tulo"
    field tta_log_liquidac_autom           as logical format "Sim/N�o" initial no label "Liquidac Autom�tica" column-label "Liquidac Autom�tica"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora"
    field tta_cod_cartcred                 as character format "x(20)" label "C�digo Cart�o" column-label "C�digo Cart�o"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart�o" column-label "Validade Cart�o"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C�d Pr�-Autoriza��o" column-label "C�d Pr�-Autoriza��o"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Efetiv Venda" column-label "Data Efetiv Venda"
    field tta_cod_conces_telef             as character format "x(5)" label "Concession�ria" column-label "Concession�ria"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N�o" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere�o Cobran�a" column-label "Endere�o Cobran�a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_log_db_autom                 as logical format "Sim/N�o" initial no label "D�bito Autom�tico" column-label "D�bito Autom�tico"
    field tta_log_destinac_cobr            as logical format "Sim/N�o" initial no label "Destin Cobran�a" column-label "Destin Cobran�a"
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Banc�ria" column-label "Sit Banc�ria"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T�tulo Banco" column-label "Num T�tulo Banco"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag�ncia Cobran�a" column-label "Ag�ncia Cobr"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran�a" column-label "Obs Cobran�a"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota��o" column-label "Cota��o"
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C�lculo Juros" column-label "Tipo C�lculo Juros"
    index tt_id                            is primary unique
          ttv_rec_lote_impl_tit_acr        ascending
          tta_num_seq_refer                ascending
    .


def new shared temp-table tt_integr_acr_item_lote_impl no-undo 
    field ttv_rec_lote_impl_tit_acr        as recid format ">>>>>>9" initial ? 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ�ncia" column-label "Seq" 
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo" 
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira" 
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa" 
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi��o Cobran�a" column-label "Cond Cobran�a" 
    field tta_cod_motiv_movto_tit_acr      as character format "x(8)" label "Motivo Movimento" column-label "Motivo Movimento" 
    field tta_cod_histor_padr              as character format "x(8)" label "Hist�rico Padr�o" column-label "Hist�rico Padr�o" 
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante" 
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento" 
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida��o" column-label "Prev Liquida��o" 
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto" 
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss�o" column-label "Dt Emiss�o" 
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor" 
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto" 
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto" 
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia" 
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr" 
    field tta_val_base_calc_comis          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Base Calc Comis" column-label "Base Calc Comis" 
    field tta_des_text_histor              as character format "x(2000)" label "Hist�rico" column-label "Hist�rico" 
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa" 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria" 
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco" 
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D�gito Cta Corrente" column-label "D�gito Cta Corrente" 
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc�ria 1" column-label "Instr Banc 1" 
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc�ria 2" column-label "Instr Banc 2" 
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros" 
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L�quido" column-label "Vl L�quido" 
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp�cie" column-label "Tipo Esp�cie" 
    field tta_cod_cond_pagto               as character format "x(8)" label "Condi��o Pagamento" column-label "Condi��o Pagamento" 
    field ttv_cdn_agenc_fp                 as Integer format ">>>9" label "Ag�ncia" 
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa��o T�tulo" column-label "Situa��o T�tulo" 
    field tta_log_liquidac_autom           as logical format "Sim/N�o" initial no label "Liquidac Autom�tica" column-label "Liquidac Autom�tica" 
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber" 
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR" 
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta" 
    field tta_cod_admdra_cartao_cr         as character format "x(5)" label "Administradora" column-label "Administradora" 
    field tta_cod_cartcred                 as character format "x(20)" label "C�digo Cart�o" column-label "C�digo Cart�o" 
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade Cart�o" column-label "Validade Cart�o" 
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C�digo Autoriza��o" column-label "C�digo Autoriza��o" 
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Compra" column-label "Data Compra" 
    field tta_cod_conces_telef             as character format "x(5)" label "Concession�ria" column-label "Concession�ria" 
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD" 
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo" 
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar" 
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/N�o" initial no label "Credito com Garantia" column-label "Cred Garant" 
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia" 
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere�o Cobran�a" column-label "Endere�o Cobran�a" 
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato" 
    field tta_log_db_autom                 as logical format "Sim/N�o" initial no label "D�bito Autom�tico" column-label "D�bito Autom�tico" 
    field tta_log_destinac_cobr            as logical format "Sim/N�o" initial no label "Destin Cobran�a" column-label "Destin Cobran�a" 
    field tta_ind_sit_bcia_tit_acr         as character format "X(12)" initial "Liberado" label "Sit Banc�ria" column-label "Sit Banc�ria" 
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T�tulo Banco" column-label "Num T�tulo Banco" 
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Ag�ncia Cobran�a" column-label "Ag�ncia Cobr" 
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat" 
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento" 
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento" 
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran�a" column-label "Obs Cobran�a" 
    index tt_id                            is primary unique 
          ttv_rec_lote_impl_tit_acr        ascending 
          tta_num_seq_refer                ascending 
    . 


def new shared temp-table tt_integr_acr_aprop_ctbl_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont�bil" column-label "Conta Cont�bil" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg�cio Externa" column-label "Unid Neg�cio Externa" 
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo" 
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo" 
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa��o" column-label "UF" 
    field tta_log_impto_val_agreg          as logical format "Sim/N�o" initial no label "Impto Val Agreg" column-label "Imp Vl Agr" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field tta_cod_pais                     as character format "x(3)" label "Pa�s" column-label "Pa�s" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa�s Externo" column-label "Pa�s Externo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_plano_cta_ctbl           ascending 
          tta_cod_cta_ctbl                 ascending 
          tta_cod_cta_ctbl_ext             ascending 
          tta_cod_sub_cta_ctbl_ext         ascending 
          tta_cod_unid_negoc               ascending 
          tta_cod_unid_negoc_ext           ascending 
          tta_cod_plano_ccusto             ascending 
          tta_cod_ccusto                   ascending 
          tta_cod_ccusto_ext               ascending 
          tta_cod_tip_fluxo_financ         ascending 
          tta_cod_fluxo_financ_ext         ascending 
          tta_log_impto_val_agreg          ascending. 

def new shared temp-table tt_log_erros_atualiz no-undo 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_refer                    as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia" 
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ�ncia" column-label "Seq" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N�mero" column-label "N�mero Mensagem" 
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist�ncia" 
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda" 
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac" 
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento". 
    
/*-------------------------- Temp-tables nao utilizadas neste programa ------------------------*/

def new shared temp-table tt_integr_acr_abat_antecip no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_espec_docto              ascending 
          tta_cod_ser_docto                ascending 
          tta_cod_tit_acr                  ascending 
          tta_cod_parcela                  ascending. 
          

def new shared temp-table tt_integr_acr_abat_prev no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat" 
    field tta_log_zero_sdo_prev            as logical format "Sim/N�o" initial no label "Zera Saldo" column-label "Zera Saldo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_espec_docto              ascending 
          tta_cod_ser_docto                ascending 
          tta_cod_tit_acr                  ascending 
          tta_cod_parcela                  ascending. 


def new shared temp-table tt_integr_acr_aprop_desp_rec no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg�cio Externa" column-label "Unid Neg�cio Externa" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg" 
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria��o" column-label "Tipo Apropria��o" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_cta_ctbl_ext             ascending 
          tta_cod_sub_cta_ctbl_ext         ascending 
          tta_cod_unid_negoc_ext           ascending 
          tta_cod_fluxo_financ_ext         ascending 
          tta_cod_plano_cta_ctbl           ascending 
          tta_cod_cta_ctbl                 ascending 
          tta_cod_unid_negoc               ascending 
          tta_cod_tip_fluxo_financ         ascending 
          tta_ind_tip_aprop_recta_despes   ascending 
          tta_cod_tip_abat                 ascending. 

def new shared temp-table tt_integr_acr_aprop_liq_antec no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T�tulo" column-label "Unid Negoc T�tulo" 
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit" 
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido". 


def new shared temp-table tt_integr_acr_aprop_relacto no-undo 
    field ttv_rec_relacto_pend_tit_acr     as recid format ">>>>>>9" initial ? 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg�cio Externa" column-label "Unid Neg�cio Externa" 
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg�cio" column-label "Un Neg" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl" 
    field tta_ind_tip_aprop_ctbl           as character format "x(30)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl". 


def new shared temp-table tt_integr_acr_cheq no-undo 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc�ria" column-label "Ag�ncia Banc�ria" 
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente" 
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque" 
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss�o" column-label "Dt Emiss" 
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep�sito" column-label "Dep�sito" 
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "Previs�o Dep�sito" column-label "Previs�o Dep�sito" 
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto" 
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc" 
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque" 
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente" 
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal" 
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devolu��o" column-label "Motivo Devolu��o" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu�rio" column-label "Usu�rio" 
    field tta_log_pend_cheq_acr            as logical format "Sim/N�o" initial no label "Cheque Pendente" column-label "Cheque Pendente" 
    field tta_log_cheq_terc                as logical format "Sim/N�o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro" 
    field tta_log_cheq_acr_renegoc         as logical format "Sim/N�o" initial no label "Cheque Reneg" column-label "Cheque Reneg" 
    field tta_log_cheq_acr_devolv          as logical format "Sim/N�o" initial no label "Cheque Devolvido" column-label "Cheque Devolvido" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_cod_pais                     as character format "x(3)" label "Pa�s" column-label "Pa�s" 
    index tt_id                            is primary unique 
          tta_cod_banco                    ascending 
          tta_cod_agenc_bcia               ascending 
          tta_cod_cta_corren               ascending 
          tta_num_cheque                   ascending. 


def new shared temp-table tt_integr_acr_impto_impl_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_pais                     as character format "x(3)" label "Pa�s" column-label "Pa�s" 
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa�s Externo" column-label "Pa�s Externo" 
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa��o" column-label "UF" 
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto" 
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto" 
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequ�ncia" column-label "NumSeq" 
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut" 
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al�quota" column-label "Aliq" 
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto" 
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas" 
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil" 
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern" 
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa" 
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota��o" column-label "Cota��o" 
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota��o" column-label "Data Cota��o" 
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_pais                     ascending 
          tta_cod_pais_ext                 ascending 
          tta_cod_unid_federac             ascending 
          tta_cod_imposto                  ascending 
          tta_cod_classif_impto            ascending 
          tta_num_seq                      ascending. 


def new shared temp-table tt_integr_acr_ped_vda_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda" 
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres" 
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip" 
    field tta_val_origin_ped_vda           as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Original Ped Venda" column-label "Original Ped Venda" 
    field tta_val_sdo_ped_vda              as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Pedido Venda" column-label "Saldo Pedido Venda" 
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_ped_vda                  ascending. 


def new shared temp-table tt_integr_acr_relacto_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_estab_tit_acr_pai        as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai" 
    field ttv_cod_estab_tit_acr_pai_ext    as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai" 
    field tta_num_id_tit_acr_pai           as integer format "9999999999" initial 0 label "Token" column-label "Token" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_relacto_tit_acr          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Relacto" column-label "Vl Relacto" 
    field tta_log_gera_alter_val           as logical format "Sim/N�o" initial no label "Gera Alter Valor" column-label "Gera Alter Valor" 
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera��o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor". 


def new shared temp-table tt_integr_acr_relacto_pend_cheq no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag�ncia Banc ria" column-label "Ag�ncia Banc ria" 
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente" 
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque" 
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado" 
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal rio" column-label "Banco Cheque Sal rio" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_banco                    ascending 
          tta_cod_agenc_bcia               ascending 
          tta_cod_cta_corren               ascending 
          tta_num_cheque                   ascending. 


def new shared temp-table tt_integr_acr_repres_pend no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante" 
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% Comiss�o" column-label "% Comiss�o" 
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Emiss�o" column-label "% Comis Emiss�o" 
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento" 
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto" 
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros" 
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa" 
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA" 
    field tta_log_comis_repres_proporc     as logical format "Sim/N�o" initial no label "Comis Proporcional" column-label "Comis Propor" 
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo Comiss�o" column-label "Tipo Comiss�o" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cdn_repres                   ascending. 


def new shared temp-table tmp-antecip no-undo 
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9" 
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9" 
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_espec_docto              as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie" 
    field tta_cod_ser_docto                as character format "x(3)" label "S�rie Documento" column-label "S�rie" 
    field tta_cod_tit_acr                  as character format "x(10)" label "T�tulo" column-label "T�tulo" 
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc" 
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo" 
    index tt_id                            is primary unique 
          ttv_rec_item_lote_impl_tit_acr   ascending 
          tta_cod_estab                    ascending 
          tta_cod_estab_ext                ascending 
          tta_cod_espec_docto              ascending 
          tta_cod_ser_docto                ascending 
          tta_cod_tit_acr                  ascending 
          tta_cod_parcela                  ascending. 

def temp-table tp_erros no-undo
    field ds_mensagem as char format "x(132)"
    field cd_erro     as int format 999999999999
    field tp_erro     as char format "x(15)".

def buffer b_ti_tit_acr for ti_tit_acr.
def buffer b2_ti_tit_acr for ti_tit_acr.
DEF BUFFER b_ti_controle_integracao FOR ti_controle_integracao.

/*--------------------- Procedure rtapi044 e variaveis ----------------------*/

/*
{rtp/rtapi044.i} 
*/

def var cd-referencia-aux    as char no-undo.
def var cod_cond_cobr_acr_padr_aux like param_estab_acr.cod_cond_cobr_acr_padr no-undo.
def var cod_unid_negoc_aux like estab_unid_negoc.cod_unid_negoc no-undo. 
def var cod_cliente_aux    like emsuni.cliente.cdn_cliente             no-undo.
def var cod_pais_aux       as char initial "BRA" no-undo.
def var cod_moeda_corrente_aux like histor_finalid_econ.cod_indic_econ no-undo.
def var cod_unid_federac_aux   like ems5.pessoa_fisic.cod_unid_federac no-undo.
def var cod_plano_ccusto_aux as char no-undo.
def var ds-observacao-aux as char no-undo. 
def var lg_erro_aux       as log no-undo.
DEF VAR cd-situacao-aux   AS CHAR NO-UNDO.
DEF VAR v_conta           AS INT NO-UNDO.

ASSIGN v_conta = 1.

for EACH ti_tit_acr where ti_tit_acr.CDSITUACAO = in-status-par /* AND TI_TIT_ACR.val_ir = 0*/ /*no-lock*/ EXCLUSIVE-LOCK :

   RUN escrever-log("@@@@@dentro da leitura de ti_tit_acr." + STRING(ti_tit_acr.nrseq_controle_integracao)
                    + ti_tit_acr.cod_espec_docto + " "
                    + ti_tit_acr.cod_ser_docto + " "
                    + ti_tit_acr.cod_tit_acr + " "
                    + ti_tit_acr.cod_parcela).

   PROCESS EVENTS.
   message "Tit.ACR " in-status-par " "
          string(ti_tit_acr.nrseq_controle_integracao) + " Titulo:  "
          + ti_tit_acr.cod_espec_docto + " "
          + ti_tit_acr.cod_ser_docto + " "
          + ti_tit_acr.cod_tit_acr + " "
          + ti_tit_acr.cod_parcela.

   IF v_conta >= 50 THEN DO:
      ASSIGN v_conta = 1.
      RETURN.
   END.
   ELSE DO:
      ASSIGN v_conta = v_conta + 1.
   END.
                                 
   run limpa_temporaria.
   
   run busca-parametros-estab(output cod_cond_cobr_acr_padr_aux,
                              output lg_erro_aux).
  
  /* assign lg_erro_aux = no. */                          
   if not lg_erro_aux then do:  
      run busca-dados-cliente(output cod_cliente_aux,
                              output cod_moeda_corrente_aux,
                              output cod_unid_federac_aux,
                              output lg_erro_aux).

      if not lg_erro_aux then do:
         run busca-unidade-negocio(output cod_unid_negoc_aux,
                                    output lg_erro_aux).   
         if not lg_erro_aux 
         then do:           
             run cria-temporaria. 
            
             /*for each tt_integr_acr_lote_impl no-lock:
               /* message "aui". */ 
             end.*/
             
             run prgfin\acr\acr900zd.py(input 4,
                               input "EMS2",
                               input  yes,
                               input no, /*input yes,*/
                               input-output table tt_integr_acr_item_lote_impl_2).                                    
                             
             run trata-erros(input  "enviado",
                             output lg_erro_aux).

         end.
         else run trata-erros(input  "nao enviado",
                              output lg_erro_aux).
      end.
      else run trata-erros(input  "nao enviado",
                           output lg_erro_aux).                                                                 
   end.
   else do:
          run trata-erros(input  "nao enviado",
                          output lg_erro_aux).
   end.
                               
   RUN escrever-log("@@@@@vai ler b_ti_tit_acr").

   /*find b_ti_tit_acr EXCLUSIVE-LOCK where rowid(b_ti_tit_acr) = rowid(ti_tit_acr) no-error.
   IF NOT AVAIL b_ti_tit_acr
   THEN RUN escrever-log("@@@@@NAO CONSEGUIU ACESSAR B_TI_TIT_ACR PARA ATUALIZAR CDSITUACAO!!!!!").*/

   if lg_erro_aux
   then do:
          RUN escrever-log("@@@@@setando b_ti_tit_acr.CDSITUACAO = PE").
          assign /*b_ti_tit_acr.CDSITUACAO*/ ti_tit_acr.CDSITUACAO = "PE"
                 cd-situacao-aux         = "PE".
          /*RUN escrever-log("@@@@@vai fazer VALIDATE B_TI_TIT_ACR P1").
          VALIDATE b_ti_tit_acr.
          RUN escrever-log("@@@@@vai fazer RELEASE B_TI_TIT_ACR P1").
          RELEASE  b_ti_tit_acr.
          RUN escrever-log("@@@@@TERMINOU RELEASE B_TI_TIT_ACR P1").*/
        END.
   else do:
          RUN escrever-log("@@@@@setando b_ti_tit_acr.CDSITUACAO = IT").
          assign /*b_ti_tit_acr.CDSITUACAO*/ ti_tit_acr.CDSITUACAO = "IT"
                 cd-situacao-aux         = "IT".
          /*RUN escrever-log("@@@@@vai fazer VALIDATE B_TI_TIT_ACR P2").
          VALIDATE b_ti_tit_acr.
          RUN escrever-log("@@@@@vai fazer RELEASE B_TI_TIT_ACR P2").
          RELEASE  b_ti_tit_acr.
          RUN escrever-log("@@@@@TERMINOU RELEASE B_TI_TIT_ACR P2").*/

          /**
           * Ao setar para IT, trocar para CA possiveis registros antigos referentes ao mesmo titulo.
           */
          RUN escrever-log("@@@@@vai setar CA").
          FOR EACH ti_controle_integracao NO-LOCK
             WHERE ti_controle_integracao.nrsequencial = ti_tit_acr.NRSEQ_CONTROLE_INTEGRACAO,
              EACH b_ti_controle_integracao NO-LOCK
             WHERE b_ti_controle_integracao.nrsequencial_origem = ti_controle_integracao.nrsequencial_origem
               AND b_ti_controle_integracao.tpintegracao        = ti_controle_integracao.tpintegracao,
              EACH b2_ti_tit_acr EXCLUSIVE-LOCK
             WHERE b2_ti_tit_acr.nrseq_controle_integracao = b_ti_controle_integracao.nrsequencial
               AND ROWID(b2_ti_tit_acr) <> ROWID(ti_tit_acr):
                   ASSIGN b2_ti_tit_acr.cdsituacao = "CA".
          END.
          VALIDATE b2_ti_tit_acr.
          VALIDATE b2_ti_tit_acr.

          RUN escrever-log("@@@@@terminou de setar CA").
          
          /*retirado pois cod_tit_acr_bco eh enviado na API
          if ti_tit_acr.cod_tit_acr_bco <> "" and
             ti_tit_acr.cod_tit_acr_bco <> ?
          then do:
             for each estabelecimento:
                find tit_acr where tit_acr.cod_estab       = ti_tit_acr.cod_estab          and
                                   tit_acr.cod_espec_docto = ti_tit_acr.cod_espec_docto    and
                                   tit_acr.cod_ser_docto   = ti_tit_acr.cod_ser_docto      and
                                   tit_acr.cod_tit_acr     = ti_tit_acr.cod_titulo_acr     and
                                   tit_acr.cod_parcela     = ti_tit_acr.cod_PARCELA exclusive-lock no-error.
                if available tit_acr then do:
                   assign tit_acr.cod_tit_acr_bco = ti_tit_acr.cod_tit_acr_bco.
                   leave.
                end.                                            
             end.   
          end.*/
        end.
            
   RUN escrever-log("@@@@@vai atualizar TI_TIT_ACR_IMPOSTO").

   for each TI_TIT_ACR_IMPOSTO where   TI_TIT_ACR_IMPOSTO.nrseq_controle_integracao  = ti_tit_acr.nrseq_controle_integracao  and
                                       TI_TIT_ACR_IMPOSTO.CDSITUACAO   <> "CA"
                                   exclusive-lock:
      assign TI_TIT_ACR_IMPOSTO.CDSITUACAO      = cd-situacao-aux.
   end.
   VALIDATE ti_tit_acr_imposto.
   RELEASE ti_tit_acr_imposto.

   RUN escrever-log("@@@@@terminou de atualizar TI_TIT_ACR_IMPOSTO").
   
   RUN escrever-log("@@@@@vai atualizar TI_TIT_ACR_CTBL").
   for each TI_TIT_ACR_CTBL where   TI_TIT_ACR_CTBL.nrseq_controle_integracao  = ti_tit_acr.nrseq_controle_integracao  and
                                      TI_TIT_ACR_CTBL.CDSITUACAO   <> "CA"
                                   exclusive-lock:
       assign TI_TIT_ACR_CTBL.CDSITUACAO      = cd-situacao-aux.
   end.
   VALIDATE ti_tit_acr_ctbl.
   RELEASE ti_tit_acr_ctbl.

   RUN escrever-log("@@@@@terminou de atualizar TI_TIT_ACR_CTBL").

   RUN escrever-log("@@@@@fim das atualizacoes").
end.

RUN escrever-log("@@@@@SAINDO DO TI_TIT_ACR.P").

Procedure limpa_temporaria:                    
   empty temp-table tt_integr_acr_lote_impl.
   empty temp-table tt_integr_acr_item_lote_impl_2.
   empty temp-table tt_integr_acr_aprop_ctbl_pend.
   empty temp-table tt_integr_acr_abat_antecip.
   empty temp-table tt_log_erros_atualiz.
   empty temp-table tp_erros.
end procedure.


procedure busca-parametros-estab:
   def output parameter cod_cond_cobr_acr_padr_par like param_estab_acr.cod_cond_cobr_acr_padr no-undo.
   def output parameter lg_erro_par        as log no-undo.

   find param_estab_acr where param_estab_acr.cod_estab       = ti_tit_acr.cod_estab 
                          and param_estab_acr.dat_inic_valid <= ti_tit_acr.dat_emissao
                          and param_estab_acr.dat_fim_valid  >= ti_tit_acr.dat_emissao no-lock no-error.
   if not available param_estab_acr then do:
      create tp_erros.
      assign tp_erros.cd_erro = 001
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Parametros do estabelecimento nao encontrado " + ti_tit_acr.cod_estab.
      assign lg_erro_par = yes.
      return.
   end.
/*   return "OK".*/
end procedure.


procedure busca-dados-cliente:
   def output parameter cod_cliente_par        like emsuni.cliente.cdn_cliente no-undo.
   def output parameter cod_moeda_corrente_par like histor_finalid_econ.cod_indic_econ no-undo.
   def output parameter cod_unid_federac_par  like ems5.pessoa_jurid.cod_unid_federac no-undo.
   def output parameter lg_erro_par        as log no-undo.

    find ti_pessoa where ti_pessoa.nrregistro=ti_tit_acr.nrpessoa no-lock no-error.

    if not available ti_pessoa then do:
          create tp_erros.
          assign tp_erros.cd_erro     = 010
                 tp_erros.tp_erro     = "*** ERRO"
                 tp_erros.ds_mensagem = "Cliente " + 
                                        trim(ti_tit_acr.cod_id_feder) +  
                                        " Processo: " + string(ti_tit_acr.nrseq_controle_integracao) +
                                        " Pessoa: " + string(ti_tit_acr.nrpessoa)+ " nao encontrada em TI_PESSOA".
          assign lg_erro_par = yes.
          return.
       end.
     else do:
           if ti_pessoa.cdn_cliente=? then do:
             create tp_erros.
             assign tp_erros.cd_erro     = 011
                 tp_erros.tp_erro     = "*** ERRO"
                 tp_erros.ds_mensagem = "Cliente " + 
                                        trim(ti_tit_acr.cod_id_feder) +  
                                        " Processo: " + string(ti_tit_acr.nrseq_controle_integracao) +
                                        " Pessoa: " + string(ti_tit_acr.nrpessoa)+  
                                        " Cliente n�o cadastrado".

             assign lg_erro_par = yes.
           end.
           else do:
               find emsuni.cliente where emsuni.cliente.cod_empresa     = ti_tit_acr.cod_empresa and
                                      emsuni.cliente.cdn_cliente=ti_pessoa.cdn_cliente no-lock no-error.
                                      
              if not available cliente then do:
                 create tp_erros.
                 assign tp_erros.cd_erro     = 002
                        tp_erros.tp_erro     = "*** ERRO"
                        tp_erros.ds_mensagem = "Cliente " + 
                                        trim(ti_tit_acr.cod_id_feder) +  
                                        " Processo: " + string(ti_tit_acr.nrseq_controle_integracao) +
                                        " Pessoa: " + string(ti_tit_acr.nrpessoa)+  
                                        " Cliente n�o cadastrado".

                 assign lg_erro_par = yes.
                 return.
              end.
              else do:
                 assign cod_unid_federac_par = "".
                 if ti_tit_acr.ind_tipo_pessoa = "J"
                 then do:     
                    find ems5.pessoa_jurid where pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa no-lock no-error.
                    if available pessoa_jurid then assign cod_unid_federac_par = pessoa_jurid.cod_unid_federac.
                 end.
                 if ti_tit_acr.ind_tipo_pessoa = "F"
                 then do:     
                    find ems5.pessoa_fisic where pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa no-lock no-error.
                    if available pessoa_fisic then assign cod_unid_federac_par = pessoa_fisic.cod_unid_federac.
                 end.
                 if cod_unid_federac_par = "" then do:       
                    create tp_erros.
                    assign tp_erros.cd_erro     = 003
                           tp_erros.tp_erro     = "*** ERRO"
                           tp_erros.ds_mensagem = "Pessoa nao encontrada " + string(cliente.cdn_cliente,"999999999").
                    assign lg_erro_par = yes.
                    return.
                 end.
              end.
              find emsuni.pais where pais.cod_pais = cliente.cod_pais no-lock no-error.
              if not available pais then do:
                 create tp_erros.
                 assign tp_erros.cd_erro = 004
                        tp_erros.tp_erro = "*** ERRO"
                        tp_erros.ds_mensagem = "Pais do fornecedor " + cliente.cod_pais +
                                               " nao encontrado ".
                 assign lg_erro_par = yes.
                 return.
              end.
              find LAST histor_finalid_econ where histor_finalid_econ.cod_finalid_econ = pais.cod_finalid_econ_pais
                                              AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
                                no-lock no-error.
              if not available histor_finalid_econ then do:
                 create tp_erros.
                 assign tp_erros.cd_erro = 005
                        tp_erros.tp_erro = "*** ERRO"
                        tp_erros.ds_mensagem = "Finalidade Economica do fornec " + string(emsuni.fornecedor.cdn_fornecedor,"999999999") +
                                             " nao encontrado na api044".
                 assign lg_erro_par = yes.
                 return.
              end.
              else assign cod_cliente_par        = cliente.cdn_cliente
                          cod_moeda_corrente_par = histor_finalid_econ.cod_indic_econ.                      
           end.
       end.
end procedure.
     
procedure trata-erros:
   def input  parameter cd-tipo-erro-par    as char no-undo.
   def output parameter lg-ocorreu-erro-par as log  no-undo.

   RUN escrever-log("@@@@@trata-erros. tipo: " + cd-tipo-erro-par).

   case cd-tipo-erro-par:
      when "Enviado" then do:
         assign lg-ocorreu-erro-par = no.

         RUN escrever-log("@@@@@vai ler tt_log_erros_atualiz").
         FOR EACH tt_log_erros_atualiz:

             RUN escrever-log("@@@@@vai criar TI_FALHA_DE_PROCESSO." + tt_log_erros_atualiz.ttv_des_msg_ajuda
                          + " " + tt_log_erros_atualiz.ttv_des_msg_erro
                          + " " + string(tt_log_erros_atualiz.ttv_num_mensagem)
                          + " " + STRING(ti_tit_acr.nrseq_controle_integracao)).
             create TI_FALHA_DE_PROCESSO. 
             assign
             TI_FALHA_DE_PROCESSO.CDintegracao = "TI_TIT_ACR"
             TI_FALHA_DE_PROCESSO.TXAJUDA = tt_log_erros_atualiz.ttv_des_msg_ajuda 
             TI_FALHA_DE_PROCESSO.TXFALHA = tt_log_erros_atualiz.ttv_des_msg_erro
             TI_FALHA_DE_PROCESSO.NRMENSAGEM = tt_log_erros_atualiz.ttv_num_mensagem
             TI_FALHA_DE_PROCESSO.NRSEQ_CONTROLE_INTEGRACAO = ti_tit_acr.nrseq_controle_integracao.                                                                                         
             assign lg-ocorreu-erro-par = yes.        
             RUN escrever-log("@@@@@terminou de criar TI_FALHA_DE_PROCESSO").
         END.          
         RUN escrever-log("@@@@@terminou de ler tt_log_erros_atualiz").
      end.

      when "Nao enviado" then do:
      
         /* assign lg-ocorreu-erro-par = yes. */
           create TI_FALHA_DE_PROCESSO. 
           assign
           TI_FALHA_DE_PROCESSO.CDINTEGRACAO = "TI_TIT_ACR"
           TI_FALHA_DE_PROCESSO.TXFALHA= " *** ERRO ****" 
           TI_FALHA_DE_PROCESSO.NRSEQ_CONTROLE_INTEGRACAO = ti_tit_acr.nrseq_controle_integracao.         
           assign lg-ocorreu-erro-par = yes.

           for each tp_erros:
         
               create TI_FALHA_DE_PROCESSO. 
               assign
               TI_FALHA_DE_PROCESSO.CDINTEGRACAO = "TI_TIT_ACR"
               TI_FALHA_DE_PROCESSO.TXAJUDA = tp_erros.ds_mensagem 
               TI_FALHA_DE_PROCESSO.TXFALHA = tp_erros.ds_mensagem
               TI_FALHA_DE_PROCESSO.NRMENSAGEM = tp_erros.cd_erro 
               TI_FALHA_DE_PROCESSO.NRSEQ_CONTROLE_INTEGRACAO = ti_tit_acr.nrseq_controle_integracao.          
         
           end.                       
      end.   
      otherwise assign lg-ocorreu-erro-par = no.
   end.
   RUN escrever-log("@@@@@fim de trata-erros").

end procedure.
   
def var cod_imposto_aux            like tt_integr_acr_aprop_ctbl_pend.tta_cod_imposto    no-undo.
def var cod_classif_impto_aux      like tt_integr_acr_aprop_ctbl_pend.tta_cod_classif_impto  no-undo.

procedure cria-temporaria:
   assign cd-referencia-aux = "TR" + string(ti_tit_acr.nrseq_controle_integracao,"99999999").

                                    
   /* assign val-total-aux = 0. */

   /* ---------------------------------------------------------------------- LOTE --- */
   create tt_integr_acr_lote_impl.

   assign tt_integr_acr_lote_impl.tta_cod_empresa               = ti_tit_acr.cod_empresa
          tt_integr_acr_lote_impl.tta_cod_estab                 = ti_tit_acr.cod_estab
          tt_integr_acr_lote_impl.tta_cod_estab_ext             = ti_tit_acr.cod_estab
          tt_integr_acr_lote_impl.tta_cod_refer                 = cd-referencia-aux
          tt_integr_acr_lote_impl.tta_cod_indic_econ            = "Real"
          tt_integr_acr_lote_impl.tta_cod_espec_docto           = ti_tit_acr.cod_espec_docto
          tt_integr_acr_lote_impl.tta_dat_transacao             = ti_tit_acr.dat_emissao              
          tt_integr_acr_lote_impl.tta_ind_tip_espec_docto       = "Normal"
          tt_integr_acr_lote_impl.tta_ind_orig_tit_acr          = "ACREMS50"        
          tt_integr_acr_lote_impl.tta_cod_espec_docto           = ti_tit_acr.cod_espec_docto
          tt_integr_acr_lote_impl.tta_val_tot_lote_impl_tit_acr = 0
          tt_integr_acr_lote_impl.tta_ind_tip_cobr_acr          = "NORMAL".
           
           
   /* -------------------------------------------------------------------- TITULO --- */
   create tt_integr_acr_item_lote_impl_2.
           
   assign tt_integr_acr_item_lote_impl_2.ttv_rec_lote_impl_tit_acr      = recid(tt_integr_acr_lote_impl) 
          tt_integr_acr_item_lote_impl_2.tta_num_seq_refer              = 1                              
          tt_integr_acr_item_lote_impl_2.tta_cdn_cliente                = cod_cliente_aux
          tt_integr_acr_item_lote_impl_2.tta_cod_espec_docto            = ti_tit_acr.cod_espec_docto              
          tt_integr_acr_item_lote_impl_2.tta_cod_ser_docto              = ti_tit_acr.cod_ser_docto
          tt_integr_acr_item_lote_impl_2.tta_cod_tit_acr                = substring(ti_tit_acr.cod_titulo_acr,1,10)
          tt_integr_acr_item_lote_impl_2.tta_cod_tit_acr_bco            = ti_tit_acr.cod_tit_acr_bco
          tt_integr_acr_item_lote_impl_2.tta_cod_parcela                = ti_tit_acr.cod_parcela
          tt_integr_acr_item_lote_impl_2.tta_cod_indic_econ             = "Real"
          tt_integr_acr_item_lote_impl_2.tta_cod_portador               = ti_tit_acr.cod_portador
          tt_integr_acr_item_lote_impl_2.tta_cod_cart_bcia              = ti_tit_acr.cod_cart_bcia
          tt_integr_acr_item_lote_impl_2.tta_cod_cond_cobr              = cod_cond_cobr_acr_padr_aux
          tt_integr_acr_item_lote_impl_2.tta_cod_modalid_ext            = " "              
         /* tt_integr_acr_item_lote_impl_2.tta_cdn_repres                 = ti_tit_acr.cod_vendedor */
          tt_integr_acr_item_lote_impl_2.tta_dat_vencto_tit_acr         = ti_tit_acr.dat_vencto
          tt_integr_acr_item_lote_impl_2.tta_dat_prev_liquidac          = ti_tit_acr.dat_previsao_liquidac
          tt_integr_acr_item_lote_impl_2.tta_dat_emis_docto             = ti_tit_acr.dat_emissao
          tt_integr_acr_item_lote_impl_2.tta_ind_tip_espec_docto        = "Normal"       
          tt_integr_acr_item_lote_impl_2.tta_cod_cond_pagto             = ""                 
          tt_integr_acr_item_lote_impl_2.tta_ind_sit_tit_acr            = "Normal" 
          tt_integr_acr_item_lote_impl_2.tta_log_liquidac_autom         = no
          tt_integr_acr_item_lote_impl_2.tta_log_tip_cr_perda_dedut_tit = no      
          tt_integr_acr_item_lote_impl_2.tta_cod_refer                  = cd-referencia-aux
          tt_integr_acr_item_lote_impl_2.tta_log_db_autom               = yes            
          tt_integr_acr_item_lote_impl_2.tta_log_destinac_cobr          = no            
          tt_integr_acr_item_lote_impl_2.tta_ind_sit_bcia_tit_acr       = "Liberado" 
          tt_integr_acr_item_lote_impl_2.tta_val_cotac_indic_econ       = 0
          tt_integr_acr_item_lote_impl_2.tta_des_text_histor            = ti_tit_acr.des_text_histor
          tt_integr_acr_item_lote_impl_2.ttv_rec_item_lote_impl_tit_acr = recid(tt_integr_acr_item_lote_impl_2).

   assign tt_integr_acr_item_lote_impl_2.tta_val_perc_juros_dia_atraso =  param_estab_acr.val_perc_juros_acr / 30 /* regra da Datasul eh dividir fixo  */
          tt_integr_acr_item_lote_impl_2.tta_val_perc_multa_atraso     =  param_estab_acr.val_perc_multa_acr 
          tt_integr_acr_item_lote_impl_2.tta_qtd_dias_carenc_multa_acr = 0 /* param_estab_acr.qtd_dias_carenc_multa_acr */
          tt_integr_acr_item_lote_impl_2.tta_qtd_dias_carenc_juros_acr = 0 /* param_estab_acr.qtd_dias_carenc_juros_acr. */.
             
   assign tt_integr_acr_item_lote_impl_2.tta_val_tit_acr               = ti_tit_acr.val_titulo
          tt_integr_acr_item_lote_impl_2.tta_val_base_calc_comis       = ti_tit_acr.val_titulo                                                                      
          tt_integr_acr_item_lote_impl_2.tta_val_liq_tit_acr           = ti_tit_acr.val_titulo                                                                   
          tt_integr_acr_item_lote_impl_2.tta_val_desconto              = ti_tit_acr.val_desconto
          tt_integr_acr_item_lote_impl_2.tta_dat_desconto              = ti_tit_acr.dat_desconto.
    
   assign cod_imposto_aux       = ""
          cod_classif_impto_aux = "".
          
     
   for each TI_TIT_ACR_CTBL where TI_TIT_ACR_CTBL.nrseq_controle_integracao  = ti_tit_acr.nrseq_controle_integracao  and
                                      TI_TIT_ACR_CTBL.CDSITUACAO   <> "CA" no-lock :
      if TI_TIT_ACR_CTBL.cod_ccusto <> ""
      then assign cod_plano_ccusto_aux = ti_tit_acr.cod_plano_ccusto.
      else assign cod_plano_ccusto_aux = "".

                         
      find tt_integr_acr_aprop_ctbl_pend where  tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = tt_integr_acr_item_lote_impl_2.ttv_rec_item_lote_impl_tit_acr
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = TI_TIT_ACR.COD_PLANO_CTA_CTBL                             
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = ""
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl_ext           = TI_TIT_ACR_CTBL.cod_cta_ctbl
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext       = ""
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = cod_unid_negoc_aux
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc_ext         = ""
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = cod_plano_ccusto_aux
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "" 
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto_ext             = TI_TIT_ACR_CTBL.cod_ccusto
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = ""
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_cod_fluxo_financ_ext       = TI_TIT_ACR_CTBL.cod_tip_fluxo_financ 
                                           and  tt_integr_acr_aprop_ctbl_pend.tta_log_impto_val_agreg        = no
                                                no-error.
                                             
      if not available tt_integr_acr_aprop_ctbl_pend then do:
         create tt_integr_acr_aprop_ctbl_pend.
         assign tt_integr_acr_aprop_ctbl_pend.ttv_rec_item_lote_impl_tit_acr = tt_integr_acr_item_lote_impl_2.ttv_rec_item_lote_impl_tit_acr
                tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = TI_TIT_ACR.COD_PLANO_CTA_CTBL
                tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl               = TI_TIT_ACR_CTBL.cod_cta_ctbl
                tt_integr_acr_aprop_ctbl_pend.tta_cod_cta_ctbl_ext           = ""
                tt_integr_acr_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext       = ""
                tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc             = cod_unid_negoc_aux            
                tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_negoc_ext         = ""
                tt_integr_acr_aprop_ctbl_pend.tta_cod_plano_ccusto           = ""/* cod_plano_ccusto_aux */
                tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto                 = "" 
                tt_integr_acr_aprop_ctbl_pend.tta_cod_ccusto_ext             = TI_TIT_ACR_CTBL.cod_ccusto
                tt_integr_acr_aprop_ctbl_pend.tta_cod_tip_fluxo_financ       = TI_TIT_ACR_CTBL.cod_tip_fluxo_financ
                tt_integr_acr_aprop_ctbl_pend.tta_cod_fluxo_financ_ext       = ""
                tt_integr_acr_aprop_ctbl_pend.tta_log_impto_val_agreg        = no
                tt_integr_acr_aprop_ctbl_pend.tta_cod_pais                   = cod_pais_aux
                tt_integr_acr_aprop_ctbl_pend.tta_cod_unid_federac           = cod_unid_federac_aux
                tt_integr_acr_aprop_ctbl_pend.tta_cod_imposto                = cod_imposto_aux
                tt_integr_acr_aprop_ctbl_pend.tta_cod_classif_impto          = cod_classif_impto_aux
                tt_integr_acr_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext       = ""
                tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl             = TI_TIT_ACR_CTBL.val_aprop_ctbl.
                
      end.
      else assign  tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl         = tt_integr_acr_aprop_ctbl_pend.tta_val_aprop_ctbl  +
                                                                              TI_TIT_ACR_CTBL.val_aprop_ctbl. 
  end.
/*   return "OK". */
end procedure.


procedure busca-unidade-negocio:
   def output parameter cod_unid_negoc_par like estab_unid_negoc.cod_unid_negoc no-undo.
   def output parameter lg_erro_par        as log no-undo.
/*
   find estunemp where estunemp.cod-estabel = ti_tit_acr.cod_estab no-lock no-error.
   if not avail estunemp
   then do: 
      create tp_erros.
      assign tp_erros.cd_erro = 006
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Unidade x Empresa nao cadastrada no estabelecimento " + ti_tit_acr.cod_estab.
      assign lg_erro_par = yes. 
      return.        
   end. 

   find first estab_unid_negoc where estab_unid_negoc.cod_estab       = estunemp.cod-estabel
                                 and estab_unid_negoc.cod_unid_negoc  = estunemp.cd-unidade-negocio
                                 and estab_unid_negoc.dat_inic_valid <= ti_tit_acr.dat_emissao
                                 and estab_unid_negoc.dat_fim_valid  >= ti_tit_acr.dat_emissao no-lock no-error.                     
   if not avail estab_unid_negoc
   then do:
      create tp_erros.
      assign tp_erros.cd_erro = 007
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Estabelecimento x Unidade de Negocio nao cadastrada ou fora de validade " + 
                                    ti_tit_acr.cod_estab + " " + 
                                    estunemp.cd-unidade-negocio + " " +
                                    string(ti_tit_acr.dat_emissao,"99/99/9999").
       assign lg_erro_par = yes.          
       return.
   end.  
   assign cod_unid_negoc_par = estab_unid_negoc.cod_unid_negoc.                     
   
   assign lg_erro_par = no.
   assign cod_unid_negoc_par = "UNI".*/
end procedure.
               
PROCEDURE escrever-log:
    DEF INPUT param ds-mens-par AS CHAR NO-UNDO.
END PROCEDURE.

/* ---------------------------------------------------------- */
/* ---------------------------------------------------- EOF - */
/* ---------------------------------------------------------- */
