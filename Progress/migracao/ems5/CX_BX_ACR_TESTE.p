def temp-table tt_integr_acr_liquidac_lote no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_usuario                  as character format "x(12)" label "Usu†rio" column-label "Usu†rio"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transaá∆o" column-label "Dat Transac"
    field tta_dat_gerac_lote_liquidac      as date format "99/99/9999" initial ? label "Data Geraá∆o" column-label "Data Geraá∆o"
    field tta_val_tot_lote_liquidac_infor  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_val_tot_lote_liquidac_efetd  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Vl Tot Movto"
    field tta_val_tot_despes_bcia          as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Desp Bcia" column-label "Desp Bcia"
    field tta_ind_tip_liquidac_acr         as character format "X(15)" initial "Lote" label "Tipo Liquidacao" column-label "Tipo Liquidacao"
    field tta_ind_sit_lote_liquidac_acr    as character format "X(15)" initial "Em Digitaá∆o" label "Situaá∆o" column-label "Situaá∆o"
    field tta_nom_arq_movimen_bcia         as character format "x(30)" label "Nom Arq Bancaria" column-label "Nom Arq Bancaria"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_log_enctro_cta               as logical format "Sim/N∆o" initial no label "Encontro de Contas" column-label "Encontro de Contas"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_atualiz_refer            as logical format "Sim/N∆o" initial no
    field ttv_log_gera_lote_parcial        as logical format "Sim/N∆o" initial no
    field ttv_log_verific_reg_perda_dedut  as logical format "Sim/N∆o" initial no
    index tt_itlqdccr_id                   is primary unique
          tta_cod_estab_refer              ascending
          tta_cod_refer                    ascending
    .

def temp-table tt_integr_acr_abat_antecip no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
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

def temp-table tt_integr_acr_abat_prev no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat"
    field tta_log_zero_sdo_prev            as logical format "Sim/N∆o" initial no label "Zera Saldo" column-label "Zera Saldo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending.

def temp-table tt_integr_acr_cheq no-undo 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria" 
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente" 
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque" 
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data Emiss∆o" column-label "Dt Emiss" 
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep¢sito" column-label "Dep¢sito" 
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "Previs∆o Dep¢sito" column-label "Previs∆o Dep¢sito" 
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto" 
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc" 
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque" 
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente" 
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente" 
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab" 
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext" 
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal" 
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devoluá∆o" column-label "Motivo Devoluá∆o" 
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda" 
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa" 
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu†rio" column-label "Usu†rio" 
    field tta_log_pend_cheq_acr            as logical format "Sim/N∆o" initial no label "Cheque Pendente" column-label "Cheque Pendente" 
    field tta_log_cheq_terc                as logical format "Sim/N∆o" initial no label "Cheque Terceiro" column-label "Cheque Terceiro" 
    field tta_log_cheq_acr_renegoc         as logical format "Sim/N∆o" initial no label "Cheque Reneg" column-label "Cheque Reneg" 
    field tta_log_cheq_acr_devolv          as logical format "Sim/N∆o" initial no label "Cheque Devolvido" column-label "Cheque Devolvido" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_cod_pais                     as character format "x(3)" label "Pa°s" column-label "Pa°s" 
    index tt_id                            is primary unique 
          tta_cod_banco                    ascending 
          tta_cod_agenc_bcia               ascending 
          tta_cod_cta_corren               ascending 
          tta_num_cheque                   ascending.

def temp-table tt_integr_acr_liquidac_impto_2 no-undo
    field tta_cod_estab_refer              as character format "x(5)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referºncia" column-label "Referºncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequºncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa≠s" column-label "Pa≠s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federaªío" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_val_retid_indic_impto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE Imposto" column-label "Vl Retido IE Imposto"
    field tta_val_retid_indic_tit_acr      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE T≠tulo" column-label "Vl Retido IE T≠tulo"
    field tta_val_retid_indic_pagto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Retido Indicador Pag" column-label "Retido Indicador Pag"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cotaªío" column-label "Data Cotaªío"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaªío" column-label "Cotaªío"
    field tta_dat_cotac_indic_econ_pagto   as date format "99/99/9999" initial ? label "Dat Cotac IE Pagto" column-label "Dat Cotac IE Pagto"
    field tta_val_cotac_indic_econ_pagto   as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Val Cotac IE Pagto" column-label "Val Cotac IE Pagto"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/Nío" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/Nío" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut".

def temp-table tt_integr_acr_liq_item_lote_3 no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp≤cie Documento" column-label "Esp≤cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S≤rie Documento" column-label "S≤rie"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequºncia" column-label "Seq"
    field tta_cod_tit_acr                  as character format "x(10)" label "T≠tulo" column-label "T≠tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data Cr≤dito" column-label "Data Cr≤dito"
    field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquidaªío" column-label "Liquidaªío"
    field tta_cod_autoriz_bco              as character format "x(8)" label "Autorizaªío Bco" column-label "Autorizacao Bco"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquidaªío" column-label "Vl Liquidaªío"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_cm_tit_acr               as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field tta_val_liquidac_orig            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquid Orig" column-label "Vl Liquid Orig"
    field tta_val_desc_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc Orig" column-label "Vl Desc Orig"
    field tta_val_abat_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat Orig" column-label "Vl Abat Orig"
    field tta_val_despes_bcia_orig         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Bcia Orig" column-label "Vl Desp Bcia Orig"
    field tta_val_multa_tit_acr_origin     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa Orig" column-label "Vl Multa Orig"
    field tta_val_juros_tit_acr_orig       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Juros Orig" column-label "Vl Juros Orig"
    field tta_val_cm_tit_acr_orig          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM Orig" column-label "Vl CM Orig"
    field tta_val_nota_db_orig             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Nota DB" column-label "Valor Nota DB"
    field tta_log_gera_antecip             as logical format "Sim/Nío" initial no label "Gera Antecipacao" column-label "Gera Antecipacao"
    field tta_des_text_histor              as character format "x(2000)" label "HistΩrico" column-label "HistΩrico"
    field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situaªío Item Lote" column-label "Situaªío Item Lote"
    field tta_log_gera_avdeb               as logical format "Sim/Nío" initial no label "Gera Aviso D≤bito" column-label "Gera Aviso D≤bito"
    field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso D≤bito" column-label "Moeda Aviso D≤bito"
    field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD"
    field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD"
    field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD"
    field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito"
    field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso D≤bito" column-label "Aviso D≤bito"
    field tta_log_movto_comis_estordo      as logical format "Sim/Nío" initial no label "Estorna Comissío" column-label "Estorna Comissío"
    field tta_ind_tip_item_liquidac_acr    as character format "X(09)" label "Tipo Item" column-label "Tipo Item"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/Nío" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/Nío" initial no label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaªío" column-label "Cotaªío"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
    field tta_log_retenc_impto_liq         as logical format "Sim/Nío" initial no label "Ret≤m na Liquidaªío" column-label "Ret na Liq"
    field tta_val_retenc_pis               as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor PIS" column-label "PIS"
    field tta_val_retenc_cofins            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor COFINS" column-label "COFINS"
    field tta_val_retenc_csll              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor CSLL" column-label "CSLL"
    field ttv_log_verific_reg_perda_dedut  as logical format "Sim/Nío" initial no
    index tt_rec_index                    
          ttv_rec_lote_liquidac_acr        ascending.

def temp-table tt_integr_acr_liq_item_lote no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequància" column-label "Seq"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data CrÇdito" column-label "Data CrÇdito"
    field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquidaá∆o" column-label "Liquidaá∆o"
    field tta_cod_autoriz_bco              as character format "x(8)" label "Autorizaá∆o Bco" column-label "Autorizacao Bco"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquidaá∆o" column-label "Vl Liquidaá∆o"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_val_multa_tit_acr            as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa" column-label "Vl Multa"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_cm_tit_acr               as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM" column-label "Vl CM"
    field tta_val_liquidac_orig            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquid Orig" column-label "Vl Liquid Orig"
    field tta_val_desc_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc Orig" column-label "Vl Desc Orig"
    field tta_val_abat_tit_acr_orig        as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat Orig" column-label "Vl Abat Orig"
    field tta_val_despes_bcia_orig         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Bcia Orig" column-label "Vl Desp Bcia Orig"
    field tta_val_multa_tit_acr_origin     as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Multa Orig" column-label "Vl Multa Orig"
    field tta_val_juros_tit_acr_orig       as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Juros Orig" column-label "Vl Juros Orig"
    field tta_val_cm_tit_acr_orig          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl CM Orig" column-label "Vl CM Orig"
    field tta_val_nota_db_orig             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Nota DB" column-label "Valor Nota DB"
    field tta_log_gera_antecip             as logical format "Sim/N∆o" initial no label "Gera Antecipacao" column-label "Gera Antecipacao"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situaá∆o Item Lote" column-label "Situaá∆o Item Lote"
    field tta_log_gera_avdeb               as logical format "Sim/N∆o" initial no label "Gera Aviso DÇbito" column-label "Gera Aviso DÇbito"
    field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso DÇbito" column-label "Moeda Aviso DÇbito"
    field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD"
    field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD"
    field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD"
    field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito"
    field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso DÇbito" column-label "Aviso DÇbito"
    field tta_log_movto_comis_estordo      as logical format "Sim/N∆o" initial no label "Estorna Comiss∆o" column-label "Estorna Comiss∆o"
    field tta_ind_tip_item_liquidac_acr    as character format "X(09)" label "Tipo Item" column-label "Tipo Item"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/N∆o" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/N∆o" initial no label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cotaá∆o" column-label "Cotaá∆o"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C†lculo Juros" column-label "Tipo C†lculo Juros"
    index tt_rec_index                    
          ttv_rec_lote_liquidac_acr        ascending.

def temp-table tt_integr_acr_rel_pend_cheq no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agància Banc†ria" column-label "Agància Banc†ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal†rio" column-label "Banco Cheque Sal†rio".

def temp-table tt_integr_acr_liq_aprop_ctbl no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    index tt_integr_acr_liq_aprop_ctbl_id  is primary unique
          ttv_rec_item_lote_liquidac_acr   ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_cod_unid_negoc               ascending.

def temp-table tt_integr_acr_liq_desp_rec no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont†bil" column-label "Conta Cont†bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropriaá∆o" column-label "Tipo Apropriaá∆o"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    index tt_integr_acr_liq_des_rec_id     is primary unique
          ttv_rec_item_lote_liquidac_acr   ascending
          tta_cod_cta_ctbl_ext             ascending
          tta_cod_sub_cta_ctbl_ext         ascending
          tta_cod_fluxo_financ_ext         ascending
          tta_cod_unid_negoc_ext           ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_ind_tip_aprop_recta_despes   ascending.

def temp-table tt_integr_acr_aprop_liq_antec no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T°tulo" column-label "Unid Negoc T°tulo"
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido".

def temp-table tt_log_erros_import_liquidac no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequància" column-label "NumSeq"
    field tta_cod_estab                    as character format "x(5)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referància" column-label "Referància"
    field tta_cod_espec_docto              as character format "x(3)" label "EspÇcie Documento" column-label "EspÇcie"
    field tta_cod_ser_docto                as character format "x(3)" label "SÇrie Documento" column-label "SÇrie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T°tulo" column-label "T°tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_nom_abrev_clien              as character format "x(12)" label "Cliente" column-label "Cliente"
    field ttv_num_erro_log                 as integer format ">>>>,>>9" label "N£mero Erro" column-label "N£mero Erro"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistància"
    index tt_sequencia                    
          tta_num_seq                      ascending.

def temp-table tt_integr_cambio_ems5 no-undo
    field ttv_rec_table_child              as recid format ">>>>>>9"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_cod_contrat_cambio           as character format "x(15)"
    field ttv_dat_contrat_cambio_import    as date format "99/99/9999"
    field ttv_num_contrat_id_cambio        as integer format "999999999"
    field ttv_cod_estab_contrat_cambio     as character format "x(5)"
    field ttv_cod_refer_contrat_cambio     as character format "x(10)"
    field ttv_dat_refer_contrat_cambio     as date format "99/99/9999"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
          ttv_rec_table_child              ascending.

def temp-table tt_params_generic_api no-undo
    field ttv_rec_id                       as recid format ">>>>>>9"
    field ttv_cod_tabela                   as character format "x(28)" label "Tabela" column-label "Tabela"
    field ttv_cod_campo                    as character format "x(25)" label "Campo" column-label "Campo"
    field ttv_cod_valor                    as character format "x(8)" label "Valor" column-label "Valor"
    index tt_idx_param_generic             is primary unique
          ttv_cod_tabela                   ascending
          ttv_rec_id                       ascending
          ttv_cod_campo                    ascending.

def var v_hdl_aux as Handle no-undo.

/*DEF SHARED VAR c-arquivo    AS CHAR                 NO-UNDO.*/
/*DEF SHARED VAR i-banco      AS CHAR INIT "1"        NO-UNDO.*/
/*DEF SHARED VAR i-registro   AS CHAR INIT "1"        NO-UNDO.*/
/*DEF SHARED VAR cod-refer    AS CHAR FORMAT "x(12)"  NO-UNDO.*/
/*DEF SHARED VAR c-empresa    AS CHAR INIT "1"      NO-UNDO.*/
/*DEF SHARED VAR c-estab      AS CHAR INIT "01"       NO-UNDO.*/
/*DEF SHARED VAR l-atu-ref    AS LOG INIT YES          NO-UNDO.*/
/*DEF SHARED VAR l-atu-parc   AS LOG INIT YES         NO-UNDO.*/
def var lg_erro_aux       as log no-undo.

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren  AS CHAR FORMAT "x(12)" NO-UNDO.
DEF NEW GLOBAL SHARED VAR v_cod_grp_usuar_lst AS CHAR FORMAT "x(12)" NO-UNDO.

/*DEF BUFFER b_ti_cx_bx_acr FOR ti_cx_bx_acr.
*/
/* Inicio do processamento */
/*FOR EACH ti_cx_bx_acr where ti_cx_bx_acr.cdsituacao = "RC":
*/
    ASSIGN lg_erro_aux=NO.

    /* Limpa Temporaria */
    empty temp-table tt_integr_acr_liquidac_lote.
    empty temp-table tt_integr_acr_liq_item_lote_3.
    empty temp-table tt_integr_acr_abat_antecip.
    empty temp-table tt_integr_acr_abat_prev.
    empty temp-table tt_integr_acr_cheq.
    empty temp-table tt_integr_acr_liquidac_impto_2.
    empty temp-table tt_integr_acr_rel_pend_cheq.
    empty temp-table tt_integr_acr_liq_aprop_ctbl.
    empty temp-table tt_integr_acr_liq_desp_rec.
    empty temp-table tt_integr_acr_aprop_liq_antec.
    empty temp-table tt_log_erros_import_liquidac.
    empty temp-table tt_integr_cambio_ems5.
    empty temp-table tt_params_generic_api.     
    /* Limpa Temporaria */

    FIND FIRST tit_acr WHERE tit_acr.cdn_cliente     = 17671 /*ti_cx_bx_acr.cod_cliente */
                         AND tit_acr.cod_tit_acr     = "000864/08" /*ti_cx_bx_acr.cod_titulo_acr */
                         and tit_acr.cod_estab       = "01" /*ti_cx_bx_acr.cod_estab*/
                         and tit_acr.cod_espec_docto = "RC" /*ti_cx_bx_acr.cod_espec_docto*/
                         and tit_acr.cod_parcela     = "P" /*ti_cx_bx_acr.cod_parcela*/
                         NO-LOCK NO-ERROR.

/*     message tit_acr.cdn_cliente         skip */
/*             ti_cx_bx_acr.cod_cliente    skip */
/*             tit_acr.cod_tit_acr         skip */
/*             ti_cx_bx_acr.cod_titulo_acr skip */
/*             tit_acr.cod_estab           skip */
/*             ti_cx_bx_acr.cod_estab      skip */
/*             tit_acr.cod_espec_docto     skip */
/*             ti_cx_bx_acr.cod_espec_docto skip */
/*             tit_acr.cod_parcela         skip */
/*             ti_cx_bx_acr.cod_parcela    skip */
/*             TI_CX_BX_ACR.NRSEQ_CONTROLE_INTEGRACAO. */
/*    */
/*     pause . */
 

      IF AVAIL tit_acr THEN DO:

        CREATE tt_integr_acr_liquidac_lote.
        ASSIGN
            tt_integr_acr_liquidac_lote.tta_cod_empresa                 = tit_acr.cod_empresa /*ti_cx_bx_acr.cod_empresa*/
            tt_integr_acr_liquidac_lote.tta_cod_estab_refer             = tit_acr.cod_estab   /*ti_cx_bx_acr.cod_estab*/
            tt_integr_acr_liquidac_lote.tta_cod_refer                   = "H" + string(5683986 /*ti_cx_bx_acr.nrseq_controle_integracao*/ )
            tt_integr_acr_liquidac_lote.tta_cod_usuario                 = v_cod_usuar_corren 
            tt_integr_acr_liquidac_lote.tta_dat_transacao               = TODAY
            tt_integr_acr_liquidac_lote.tta_dat_gerac_lote_liquidac     = TODAY
            tt_integr_acr_liquidac_lote.ttv_rec_lote_liquidac_acr       = 1
            tt_integr_acr_liquidac_lote.tta_ind_tip_liquidac_acr        = "Lote"
            tt_integr_acr_liquidac_lote.ttv_log_atualiz_refer           = YES /*l-atu-ref*/
            tt_integr_acr_liquidac_lote.ttv_log_gera_lote_parcial       = YES /*l-atu-parc*/.

        CREATE tt_integr_acr_liq_item_lote_3.
        ASSIGN
            tt_integr_acr_liq_item_lote_3.tta_cod_empresa                 = tit_acr.cod_empresa
            tt_integr_acr_liq_item_lote_3.tta_cod_estab                   = tit_acr.cod_estab  
            tt_integr_acr_liq_item_lote_3.tta_cod_espec_docto             = tit_acr.cod_espec_docto 
            tt_integr_acr_liq_item_lote_3.tta_cod_ser_docto               = tit_acr.cod_ser_docto 
            tt_integr_acr_liq_item_lote_3.tta_cod_tit_acr                 = tit_acr.cod_tit_acr
            tt_integr_acr_liq_item_lote_3.tta_cod_parcela                 = tit_acr.cod_parcela 
            tt_integr_acr_liq_item_lote_3.tta_cdn_cliente                 = tit_acr.cdn_cliente
            tt_integr_acr_liq_item_lote_3.tta_cod_portador                = "777" /*ti_cx_bx_acr.cod_portador  */
            tt_integr_acr_liq_item_lote_3.tta_cod_cart_bcia               = "2" /*tit_acr.cod_cart_bcia */
            tt_integr_acr_liq_item_lote_3.tta_cod_indic_econ              = tit_acr.cod_indic_econ
            tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_tit_acr     = 3/31/14 /*ti_cx_bx_acr.dat_baixa*/
            tt_integr_acr_liq_item_lote_3.tta_dat_cr_liquidac_calc        = 3/31/14 /*ti_cx_bx_acr.dat_baixa*/
            tt_integr_acr_liq_item_lote_3.tta_dat_liquidac_tit_acr        = 3/31/14 /*ti_cx_bx_acr.dat_baixa*/
            tt_integr_acr_liq_item_lote_3.tta_val_liquidac_tit_acr        = 177.66 /*ti_cx_bx_acr.val_liq_titulo*/
                                                                            + 0 /*ti_cx_bx_acr.val_desconto*/
                                                                            + 0 /*ti_cx_bx_acr.val_abatimento*/
                                                                            - 0 /*ti_cx_bx_acr.val_juros*/
                                                                            - 0 /*ti_cx_bx_acr.val_multa*/
            tt_integr_acr_liq_item_lote_3.tta_val_desc_tit_acr            = 0 /*ti_cx_bx_acr.val_desconto*/
            tt_integr_acr_liq_item_lote_3.tta_val_abat_tit_acr            = 0 /*ti_cx_bx_acr.val_abatimento*/
            tt_integr_acr_liq_item_lote_3.tta_val_despes_bcia             = 0
            tt_integr_acr_liq_item_lote_3.tta_val_juros                   = 0 /*ti_cx_bx_acr.val_juros*/
            tt_integr_acr_liq_item_lote_3.tta_val_multa_tit_acr           = 0 /*ti_cx_bx_acr.val_multa*/
            tt_integr_acr_liq_item_lote_3.tta_log_gera_antecip            = NO 
            tt_integr_acr_liq_item_lote_3.tta_log_gera_avdeb              = NO
            tt_integr_acr_liq_item_lote_3.tta_ind_tip_item_liquidac_acr   = "Pagamento" 
            tt_integr_acr_liq_item_lote_3.ttv_rec_lote_liquidac_acr       = 1 
            tt_integr_acr_liq_item_lote_3.ttv_rec_item_lote_liquidac_acr  = RECID(tt_integr_acr_liq_item_lote).

        run prgfin/acr/acr901zf.py persistent set v_hdl_aux.

        run pi_main_code_api_integr_acr_liquidac_6 in v_hdl_aux (Input 1,
                                                                 input table tt_integr_acr_liquidac_lote,
                                                                 input table tt_integr_acr_liq_item_lote_3,
                                                                 input table tt_integr_acr_abat_antecip,
                                                                 input table tt_integr_acr_abat_prev,
                                                                 input table tt_integr_acr_cheq,
                                                                 input table tt_integr_acr_liquidac_impto_2,
                                                                 input table tt_integr_acr_rel_pend_cheq,
                                                                 input table tt_integr_acr_liq_aprop_ctbl,
                                                                 input table tt_integr_acr_liq_desp_rec,
                                                                 input table tt_integr_acr_aprop_liq_antec,
                                                                 INPUT '', /*Matriz de traduá∆o*/
                                                                 output table tt_log_erros_import_liquidac,
                                                                 input table tt_integr_cambio_ems5,
                                                                 input table tt_params_generic_api).
        
        Delete procedure v_hdl_aux.

        FOR EACH tt_log_erros_import_liquidac:

            /*create TI_FALHA_DE_PROCESSO. 
              assign
              TI_FALHA_DE_PROCESSO.CDINTEGRACAO              = "Baixa Receber"                              
              TI_FALHA_DE_PROCESSO.TXAJUDA                   = tt_log_erros_import_liquidac.ttv_des_msg_erro
              TI_FALHA_DE_PROCESSO.TXFALHA                   = "Erro na Atualizaá∆o do Lote de Liquidaá∆o"  
              TI_FALHA_DE_PROCESSO.NRMENSAGEM                = tt_log_erros_import_liquidac.ttv_num_erro_log 
              TI_FALHA_DE_PROCESSO.NRSEQ_CONTROLE_INTEGRACAO = ti_cx_bx_acr.nrseq_controle_integracao.*/    

            MESSAGE "Baixa Receber"                                    "Baixa Receber"                                    skip
                    "tt_log_erros_import_liquidac.ttv_des_msg_erro"     tt_log_erros_import_liquidac.ttv_des_msg_erro     skip
                    "Erro na Atualizaá∆o do Lote de Liquidaá∆o    "    "Erro na Atualizaá∆o do Lote de Liquidaá∆o"        skip
                    "tt_log_erros_import_liquidac.ttv_num_erro_log"     tt_log_erros_import_liquidac.ttv_num_erro_log     skip
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
 
            ASSIGN lg_erro_aux=YES.
        END.

        MESSAGE "erro?" lg_erro_aux
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        /*IF lg_erro_aux THEN DO:

          find b_ti_cx_bx_acr where rowid(b_ti_cx_bx_acr) = rowid(ti_cx_bx_acr) no-error.

          ASSIGN ti_cx_bx_acr.cdsituacao="PE".

        END.
        ELSE DO:
        
          find b_ti_cx_bx_acr where rowid(b_ti_cx_bx_acr) = rowid(ti_cx_bx_acr) no-error.

          ASSIGN ti_cx_bx_acr.cdsituacao="IT".

        END.*/

    END.
    ELSE DO: 

       /*create TI_FALHA_DE_PROCESSO. 
       assign
             TI_FALHA_DE_PROCESSO.CDINTEGRACAO = "Baixa Receber"
             TI_FALHA_DE_PROCESSO.TXAJUDA = "N∆o Encontrou Titulo no ACR"
             TI_FALHA_DE_PROCESSO.TXFALHA = "T°tulo n∆o existe no ACR"
             TI_FALHA_DE_PROCESSO.NRMENSAGEM = 0 
             TI_FALHA_DE_PROCESSO.NRSEQ_CONTROLE_INTEGRACAO = ti_cx_bx_acr.nrseq_controle_integracao.*/

        MESSAGE "nao encontrou titulo"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.

        /* Josias - 30-06-2015 - Comentei a linha para que o sistema reprecesso a baixo novamente, e verifique se o titulo j· foi inserido. */       
		/* find b_ti_cx_bx_acr where rowid(b_ti_cx_bx_acr) = rowid(ti_cx_bx_acr) no-error.*/
        /* ASSIGN ti_cx_bx_acr.cdsituacao="RC".*/ /* vinicius 34-07-2015 alterado para continuar RC* - Alessandro 03/08/2014 */

		/*ASSIGN ti_cx_bx_acr.cdsituacao="PE".*/

    END.

/*END.
*/
