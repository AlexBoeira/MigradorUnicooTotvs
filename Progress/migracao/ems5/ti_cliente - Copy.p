DEF INPUT PARAM in-status-par AS CHAR NO-UNDO.
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */                                                       
/* -------------------------------------------------------------------- */
/*{ems5\deftemps.i}*/
def temp-table tt_cliente_integr_j no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_grp_clien                as character format "x(4)" label "Grupo Cliente" column-label "Grupo Cliente"
    field tta_cod_tip_clien                as character format "x(8)" label "Tipo Cliente" column-label "Tipo Cliente"
    field tta_dat_impl_clien               as date format "99/99/9999" initial ? label "Implanta‡Æo Cliente" column-label "Implanta‡Æo Cliente"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur¡dica" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)" column-label "Tip Pessoa EMS2"
    index tt_cliente_empr_pessoa          
          tta_cod_empresa                  ascending
          tta_num_pessoa                   ascending
    index tt_cliente_grp_clien            
          tta_cod_grp_clien                ascending
    index tt_cliente_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    index tt_cliente_nom_abrev             is unique
          tta_cod_empresa                  ascending
          tta_nom_abrev                    ascending.

def temp-table tt_fornecedor_integr_k no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_nom_abrev                    as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_grp_fornec               as character format "x(4)" label "Grupo Fornecedor" column-label "Grp Fornec"
    field tta_cod_tip_fornec               as character format "x(8)" label "Tipo Fornecedor" column-label "Tipo Fornec"
    field tta_dat_impl_fornec              as date format "99/99/9999" initial today label "Data Implanta‡Æo" column-label "Data Implanta‡Æo"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field ttv_ind_pessoa                   as character format "X(08)" initial "Jur¡dica" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)"
    field tta_log_cr_pis                   as logical format "Sim/NÆo" initial no label "Credita PIS" column-label "Credita PIS"
    field tta_log_control_inss             as logical format "Sim/NÆo" initial no label "Controla Limite INSS" column-label "Contr Lim INSS"
    field tta_log_cr_cofins                as logical format "Sim/NÆo" initial no label "Credita COFINS" column-label "Credita COFINS"
    field tta_log_retenc_impto_pagto       as logical format "Sim/NÆo" initial no label "Ret‚m no Pagto" column-label "Ret‚m no Pagto"
    index tt_frncdr_empr_pessoa           
          tta_cod_empresa                  ascending
          tta_num_pessoa                   ascending
    index tt_frncdr_grp_fornec            
          tta_cod_grp_fornec               ascending
    index tt_frncdr_id                     is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
    index tt_frncdr_nom_abrev              is unique
          tta_cod_empresa                  ascending
          tta_nom_abrev                    ascending.    

def temp-table tt_clien_financ_integr_e no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field ttv_cod_portad_prefer_ext        as character format "x(8)" label "Portad Prefer" column-label "Portad Prefer"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field ttv_cod_portad_prefer            as character format "x(5)" label "Portador Preferenc" column-label "Port Preferenc"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_classif_msg_cobr         as character format "x(8)" label "Classif Msg Cobr" column-label "Classif Msg Cobr"
    field tta_cod_instruc_bcia_1_acr       as character format "x(4)" label "Instru‡Æo Bcia 1" column-label "Instru‡Æo 1"
    field tta_cod_instruc_bcia_2_acr       as character format "x(4)" label "Instru‡Æo Bcia 2" column-label "Instru‡Æo 2"
    field tta_log_habilit_emis_boleto      as logical format "Sim/NÆo" initial no label "Emitir Boleto" column-label "Emitir Boleto"
    field tta_log_habilit_gera_avdeb       as logical format "Sim/NÆo" initial no label "Gerar AD" column-label "Gerar AD"
    field tta_log_retenc_impto             as logical format "Sim/NÆo" initial no label "Ret‚m Imposto" column-label "Ret‚m Imposto"
    field tta_log_habilit_db_autom         as logical format "Sim/NÆo" initial no label "D‚bito Auto" column-label "D‚bito Auto"
    field tta_num_tit_acr_aber             as integer format ">>>>,>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_dat_ult_impl_tit_acr         as date format "99/99/9999" initial ? label "éltima Implanta‡Æo" column-label "éltima Implanta‡Æo"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquida‡Æo" column-label "Ultima Liquida‡Æo"
    field tta_dat_maior_tit_acr            as date format "99/99/9999" initial ? label "Data Maior T¡tulo" column-label "Data Maior T¡tulo"
    field tta_dat_maior_acum_tit_acr       as date format "99/99/9999" initial ? label "Data Maior Acum" column-label "Data Maior Acum"
    field tta_val_ult_impl_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Ultimo Tit" column-label "Valor Ultimo Tit"
    field tta_val_maior_tit_acr            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior T¡tulo" column-label "Vl Maior T¡tulo"
    field tta_val_maior_acum_tit_acr       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Ac£mulo" column-label "Vl Maior Ac£mulo"
    field tta_ind_sit_clien_perda_dedut    as character format "X(21)" initial "Normal" label "Situa‡Æo Cliente" column-label "Sit Cliente"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_log_neces_acompto_spc        as logical format "Sim/NÆo" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_log_utiliz_verba             as logical format "Sim/NÆo" initial no label "Utiliza Verba de Pub" column-label "Utiliza Verba de Pub"
    field tta_val_perc_verba               as decimal format ">>>9.99" decimals 2 initial 0 label "Percentual Verba de" column-label "Percentual Verba de"
    field tta_val_min_avdeb                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor M¡nimo" column-label "Valor M¡nimo"
    field tta_log_calc_multa               as logical format "Sim/NÆo" initial no label "Calcula Multa" column-label "Calcula Multa"
    field tta_num_dias_atraso_avdeb        as integer format "999" initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cart_bcia_prefer         as character format "x(3)" label "Carteira Preferencia" column-label "Carteira Preferencia"
    index tt_clnfnnc_classif_msg          
          tta_cod_classif_msg_cobr         ascending
    index tt_clnfnnc_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
    index tt_clnfnnc_portador             
          tta_cod_portad_ext               ascending
    index tt_clnfnnc_rprsntnt             
          tta_cod_empresa                  ascending
          tta_cdn_repres                   ascending.

def temp-table tt_fornec_financ_integr_e no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_ind_tratam_vencto_sab        as character format "X(08)" initial "Prorroga" label "Vencimento Sabado" column-label "Vencto Sab"
    field tta_ind_tratam_vencto_dom        as character format "X(08)" initial "Prorroga" label "Vencimento Domingo" column-label "Vencto Dom"
    field tta_ind_tratam_vencto_fer        as character format "X(08)" initial "Prorroga" label "Vencimento Feriado" column-label "Vencto Feriado"
    field tta_ind_pagto_juros_fornec_ap    as character format "X(08)" label "Juros" column-label "Juros"
    field tta_ind_tip_fornecto             as character format "X(08)" label "Tipo Fornecimento" column-label "Fornecto"
    field tta_ind_armaz_val_pagto          as character format "X(12)" initial "NÆo Armazena" label "Armazena Valor Pagto" column-label "Armazena Valor Pagto"
    field tta_log_fornec_serv_export       as logical format "Sim/NÆo" initial no label "Fornec Exporta‡Æo" column-label "Fornec Export"
    field tta_log_pagto_bloqdo             as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_log_retenc_impto             as logical format "Sim/NÆo" initial no label "Ret‚m Imposto" column-label "Ret‚m Imposto"
    field tta_dat_ult_impl_tit_ap          as date format "99/99/9999" initial ? label "Data Ultima Impl" column-label "Dt Ult Impl"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
    field tta_dat_impl_maior_tit_ap        as date format "99/99/9999" initial ? label "Dt Impl Maior Tit" column-label "Dt Maior Tit"
    field tta_num_antecip_aber             as integer format ">>>>9" initial 0 label "Quant Antec  Aberto" column-label "Qtd Antec"
    field tta_num_tit_ap_aber              as integer format ">>>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_val_tit_ap_maior_val         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit Impl" column-label "Valor Maior T¡tulo"
    field tta_val_tit_ap_maior_val_aber    as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit  Aberto" column-label "Maior Vl Aberto"
    field tta_val_sdo_antecip_aber         as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Antec Aberto" column-label "Sdo Antecip Aberto"
    field tta_val_sdo_tit_ap_aber          as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Tit   Aberto" column-label "Sdo Tit Aberto"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_num_rendto_tribut            as integer format ">>9" initial 0 label "Rendto Tribut vel" column-label "Rendto Tribut vel"
    field tta_log_vencto_dia_nao_util      as logical format "Sim/NÆo" initial no label "Vencto Igual Dt Flx" column-label "Vencto Igual Dt Flx"
    field tta_val_percent_bonif            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Bonifica‡Æo" column-label "Perc Bonifica‡Æo"
    field tta_log_indic_rendto             as logical format "Sim/NÆo" initial no label "Ind Rendimento" column-label "Ind Rendimento"
    field tta_num_dias_compcao             as integer format ">>9" initial 0 label "Dias Compensa‡Æo" column-label "Dias Compensa‡Æo"
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_frncfnnc_forma_pagto         
          tta_cod_forma_pagto              ascending
    index tt_frncfnnc_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
    index tt_frncfnnc_portador            
          tta_cod_portad_ext               ascending.

def temp-table tt_pessoa_jurid_integr_j no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_jurid           as character format "x(20)" initial ? label "ID Estadual" column-label "ID Estadual"
    field tta_cod_id_munic_jurid           as character format "x(20)" initial ? label "ID Municipal" column-label "ID Municipal"
    field tta_cod_id_previd_social         as character format "x(20)" label "Id Previdˆncia" column-label "Id Previdˆncia"
    field tta_log_fins_lucrat              as logical format "Sim/NÆo" initial yes label "Fins Lucrativos" column-label "Fins Lucrativos"
    field tta_num_pessoa_jurid_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz" column-label "Matriz"
    field tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field tta_ind_tip_pessoa_jurid         as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_ind_tip_capit_pessoa_jurid   as character format "X(13)" label "Tipo Capital" column-label "Tipo Capital"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_num_pessoa_jurid_cobr        as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica Cobr" column-label "Pessoa Jur¡dica Cobr"
    field tta_nom_ender_cobr               as character format "x(40)" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field tta_nom_ender_compl_cobr         as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_cobr              as character format "x(20)" label "Bairro Cobran‡a" column-label "Bairro Cobran‡a"
    field tta_nom_cidad_cobr               as character format "x(32)" label "Cidade Cobran‡a" column-label "Cidade Cobran‡a"
    field tta_nom_condad_cobr              as character format "x(32)" label "Condado Cobran‡a" column-label "Condado Cobran‡a"
    field tta_cod_unid_federac_cobr        as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field ttv_cod_pais_ext_cob             as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field ttv_cod_pais_cobr                as character format "x(3)" label "Pa¡s Cobran‡a" column-label "Pa¡s Cobran‡a"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran‡a" column-label "CEP Cobran‡a"
    field tta_cod_cx_post_cobr             as character format "x(20)" label "Caixa Postal Cobran‡" column-label "Caixa Postal Cobran‡"
    field tta_num_pessoa_jurid_pagto       as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jurid Pagto" column-label "Pessoa Jurid Pagto"
    field tta_nom_ender_pagto              as character format "x(40)" label "Endere‡o Pagamento" column-label "Endere‡o Pagamento"
    field tta_nom_ender_compl_pagto        as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_pagto             as character format "x(20)" label "Bairro Pagamento" column-label "Bairro Pagamento"
    field tta_nom_cidad_pagto              as character format "x(32)" label "Cidade Pagamento" column-label "Cidade Pagamento"
    field tta_nom_condad_pagto             as character format "x(32)" label "Condado Pagamento" column-label "Condado Pagamento"
    field tta_cod_unid_federac_pagto       as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field ttv_cod_pais_ext_pag             as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field ttv_cod_pais_pagto               as character format "x(3)" label "Pa¡s Pagamento" column-label "Pa¡s Pagamento"
    field tta_cod_cep_pagto                as character format "x(20)" label "CEP Pagamento" column-label "CEP Pagamento"
    field tta_cod_cx_post_pagto            as character format "x(20)" label "Caixa Postal Pagamen" column-label "Caixa Postal Pagamen"
    field ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
    field ttv_log_altera_razao_social      as logical format "Sim/NÆo" initial no label "Altera RazÆo Social" column-label "Altera RazÆo Social"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    field tta_nom_ender_cobr_text          as character format "x(2000)" label "End Cobranca Compl" column-label "End Cobranca Compl"
    field tta_nom_ender_pagto_text         as character format "x(2000)" label "End Pagto Compl." column-label "End Pagto Compl."
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_ind_tip_pessoa_ems2          as character format "X(12)" column-label "Tip Pessoa EMS2"
    index tt_pssjrda_cobranca             
          tta_num_pessoa_jurid_cobr        ascending
    index tt_pssjrda_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_id_feder                 ascending
          tta_cod_pais_ext                 ascending
    index tt_pssjrda_id_previd_social     
          tta_cod_pais_ext                 ascending
          tta_cod_id_previd_social         ascending
    index tt_pssjrda_matriz               
          tta_num_pessoa_jurid_matriz      ascending
    index tt_pssjrda_nom_pessoa_word      
          tta_nom_pessoa                   ascending
    index tt_pssjrda_pagto                
          tta_num_pessoa_jurid_pagto       ascending
    index tt_pssjrda_razao_social         
          tta_nom_pessoa                   ascending
    index tt_pssjrda_unid_federac         
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac             ascending.

def temp-table tt_pessoa_fisic_integr_e no-undo
    field tta_num_pessoa_fisic             as integer   format '>>>,>>>,>>9':U
    field tta_nom_pessoa                   as character format 'x(40)':U
    field tta_cod_id_feder                 as character format 'x(20)':U
    field tta_cod_id_estad_fisic           as character format 'x(20)':U
    field tta_cod_orgao_emis_id_estad      as character format 'x(10)':U
    field tta_cod_unid_federac_emis_estad  as character format 'x(3)':U
    field tta_nom_endereco                 as character format 'x(40)':U
    field tta_nom_ender_compl              as character format 'x(10)':U
    field tta_nom_bairro                   as character format 'x(20)':U
    field tta_nom_cidade                   as character format 'x(32)':U
    field tta_nom_condado                  as character format 'x(32)':U
    field tta_cod_pais_ext                 as character format 'x(20)':U
    field tta_cod_pais                     as character format 'x(3)':U
    field tta_cod_unid_federac             as character format 'x(3)':U
    field tta_cod_cep                      as character format 'x(20)':U
    field tta_cod_cx_post                  as character format 'x(20)':U
    field tta_cod_telefone                 as character format 'x(20)':U
    field tta_cod_ramal                    as character format 'x(7)':U
    field tta_cod_fax                      as character format 'x(20)':U
    field tta_cod_ramal_fax                as character format 'x(07)':U
    field tta_cod_telex                    as character format 'x(7)':U
    field tta_cod_modem                    as character format 'x(20)':U
    field tta_cod_ramal_modem              as character format 'x(07)':U
    field tta_cod_e_mail                   as character format 'x(40)':U
    field tta_dat_nasc_pessoa_fisic        as date      format '99/99/9999':U
    field ttv_cod_pais_ext_nasc            as character format 'x(20)':U
    field ttv_cod_pais_nasc                as character format 'x(3)':U
    field tta_cod_unid_federac_nasc        as character format 'x(3)':U
    field tta_des_anot_tab                 as character format 'x(2000)':U
    field tta_nom_mae_pessoa               as character format 'x(40)':U
    field tta_cod_imagem                   as character format 'x(30)':U
    field tta_log_ems_20_atlzdo            as logical   format 'Sim/NÆo':U
    field ttv_num_tip_operac               as integer   format '>9':U
    field ttv_rec_fiador_renegoc           as recid     format '>>>>>>9':U
    field ttv_log_altera_razao_social      as logical   format 'Sim/NÆo':U
    field tta_nom_nacion_pessoa_fisic      as character format 'x(40)':U
    field tta_nom_profis_pessoa_fisic      as character format 'x(40)':U
    field tta_ind_estado_civil_pessoa      as character format 'X(10)':U
    field tta_nom_home_page                as character format 'x(40)':U
    field tta_nom_ender_text               as character format 'x(2000)':U
    field tta_cod_id_munic_fisic           AS CHARACTER FORMAT 'x(20)':U
    field tta_cod_id_previd_social         AS CHARACTER FORMAT 'x(20)':U
    field tta_dat_vencto_id_munic          AS DATE      FORMAT '99/99/9999':U
    field tta_num_pessoa_fisic_cobr as int format ">>>,>>>,>>9" 
    field tta_nom_ender_cobr        as char format "x(40)"
    field tta_nom_ender_compl_cobr  as char format "x(10)"
    field tta_nom_bairro_cobr       as char format "x(20)"
    field tta_nom_cidad_cobr        as char format "x(32)"
    field tta_nom_condad_cobr       as char format "x(32)"
    field tta_cod_unid_federac_cobr as char format "x(3)" 
    field ttv_cod_pais_ext_cob      as char format "x(20)"
    field ttv_cod_pais_cobr         as char format "x(3)" 
    field tta_cod_cep_cobr          as char format "x(20)"
    field tta_cod_cx_post_cobr      as char format "x(20)"
    field tta_nom_ender_pagto       as char format "x(40)"
    field tta_cod_e_mail_cobr       as char format "x(40)"
    index tt_pssfsca_id                    is primary unique
          tta_num_pessoa_fisic             ascending
          tta_cod_id_feder                 ascending
          tta_cod_pais_ext                 ascending
    index tt_pssfsca_identpes             
          tta_nom_pessoa                   ascending
          tta_cod_id_estad_fisic           ascending
          tta_cod_unid_federac_emis_estad  ascending
          tta_dat_nasc_pessoa_fisic        ascending
          tta_nom_mae_pessoa               ascending
    index tt_pssfsca_nom_pessoa_word      
          tta_nom_pessoa                   ascending
    index tt_pssfsca_unid_federac         
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac             ascending.
		  		  
def temp-table tt_contato_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_telef_contat             as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_ramal_contat             as character format "x(07)" label "Ramal" column-label "Ramal"
    field tta_cod_fax_contat               as character format "x(20)" label "Fax" column-label "Fax"
    field tta_cod_ramal_fax_contat         as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_modem_contat             as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem_contat       as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail_contat            as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica"
    field tta_ind_priorid_envio_docto      as character format "x(10)" initial "e-Mail/Fax" label "Prioridade Envio" column-label "Prioridade Envio"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_nom_endereco                 as character format "x(40)" label "Endere‡o" column-label "Endere‡o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran‡a" column-label "CEP Cobran‡a"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    index tt_contato_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cdn_cliente                  ascending
          tta_cdn_fornecedor               ascending
    index tt_contato_pssfsca              
          tta_num_pessoa_fisic             ascending.

def temp-table tt_contat_clas_integr no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_cod_clas_contat              as character format "x(8)" label "Classe Contato" column-label "Classe"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_cnttclsa_clas_contat         
          tta_cod_clas_contat              ascending
    index tt_cnttclsa_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cod_clas_contat              ascending
    index tt_cnttclsa_pessoa_classe       
          tta_num_pessoa_jurid             ascending
          tta_cod_clas_contat              ascending.

def temp-table tt_estrut_clien_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_clien_pai                as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Pai" column-label "Cliente Pai"
    field tta_cdn_clien_filho              as Integer format ">>>,>>>,>>9" initial 0 label "Cliente Filho" column-label "Cliente Filho"
    field tta_log_dados_financ_tip_pai     as logical format "Sim/NÆo" initial no label "Armazena Valor" column-label "Armazena Valor"
    field tta_num_seq_estrut_clien         as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_estrtcln_clien_filho         
          tta_cod_empresa                  ascending
          tta_cdn_clien_filho              ascending
    index tt_estrtcln_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_clien_pai                ascending
          tta_cdn_clien_filho              ascending
          tta_num_seq_estrut_clien         ascending.

def temp-table tt_estrut_fornec_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornec_pai               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Pai" column-label "Fornecedor Pai"
    field tta_cdn_fornec_filho             as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor Filho" column-label "Fornecedor Filho"
    field tta_log_dados_financ_tip_pai     as logical format "Sim/NÆo" initial no label "Armazena Valor" column-label "Armazena Valor"
    field tta_num_seq_estrut_fornec        as integer format ">>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_strtfrn_fornec_filho         
          tta_cod_empresa                  ascending
          tta_cdn_fornec_filho             ascending
    index tt_strtfrn_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornec_pai               ascending
          tta_cdn_fornec_filho             ascending
          tta_num_seq_estrut_fornec        ascending.

def temp-table tt_histor_clien_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_num_seq_histor_clien         as integer format ">>>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field tta_des_abrev_histor_clien       as character format "x(40)" label "Abrev Hist¢rico" column-label "Abrev Hist¢rico"
    field tta_des_histor_clien             as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_hstrcln_id                    is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending
          tta_num_seq_histor_clien         ascending.

def temp-table tt_histor_fornec_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_num_seq_histor_fornec        as integer format ">>>>,>>9" initial 0 label "Sequencia" column-label "Sequencia"
    field tta_des_abrev_histor_fornec      as character format "x(40)" label "Abrev Hist¢rico" column-label "Abrev Hist¢rico"
    field tta_des_histor_fornec            as character format "x(40)" label "Hist¢rico Fornecedor" column-label "Hist¢rico Fornecedor"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_hstrfrna_id                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_num_seq_histor_fornec        ascending.

def temp-table tt_ender_entreg_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_cod_ender_entreg             as character format "x(15)" label "Endere‡o Entrega" column-label "Endere‡o Entrega"
    field tta_nom_ender_entreg             as character format "x(40)" label "Nome Endere‡o Entreg" column-label "Nome Endere‡o Entreg"
    field tta_nom_bairro_entreg            as character format "x(20)" label "Bairro Entrega" column-label "Bairro Entrega"
    field tta_nom_cidad_entreg             as character format "x(32)" label "Cidade Entrega" column-label "Cidade Entrega"
    field tta_nom_condad_entreg            as character format "x(30)" label "Condado Entrega" column-label "Condado Entrega"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa¡s Externo" column-label "Pa¡s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac_entreg      as character format "x(3)" label "Unidade Federa‡Æo" column-label "Unidade Federa‡Æo"
    field tta_cod_cep_entreg               as character format "x(20)" label "CEP Entrega" column-label "CEP Entrega"
    field tta_cod_cx_post_entreg           as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field tta_nom_ender_entreg_text        as character format "x(2000)" label "End Entrega Compl." column-label "End Entrega Compl."
    index tt_ndrntrga_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ender_entreg             ascending
    index tt_ndrntrga_pais                
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac_entreg      ascending.

def temp-table tt_telef_integr no-undo
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_ind_tip_telef_pessoa         as character format "X(08)" label "Tipo Telefone" column-label "Tipo Telefone"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_telef_id                      is primary
          tta_cod_telef_sem_edic           ascending.

def temp-table tt_telef_pessoa_integr no-undo
    field tta_cod_telef_sem_edic           as character format 'x(20)' label "Telefone" /*l_telefone*/  column-label "Telefone" /*l_telefone*/ 
    field tta_num_pessoa                   as integer format '>>>,>>>,>>9' initial ? label "l_pessoa" /*l_pessoa*/  column-label "l_pessoa" /*l_pessoa*/ 
    field tta_des_telefone                 as character format 'x(40)' label 'Descri‡Æo Telefone' column-label 'Descri‡Æo Telefone'
    field tta_cod_telefone                 as character format 'x(20)' label 'Telefone' column-label 'Telefone'
    field ttv_num_tip_operac               as integer format '>9'
    field tta_cdn_cliente                  as Integer format '>>>,>>>,>>9' initial 0 label 'Cliente' column-label 'Cliente'
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label 'Fornecedor' column-label 'Fornecedor'
    index tt_tlfpss_id                     is primary unique
          tta_cod_telef_sem_edic           ascending
          tta_num_pessoa                   ascending
          tta_cdn_cliente                  ascending
          tta_cdn_fornecedor               ascending.

def temp-table tt_pj_ativid_integr_i no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_cod_ativid_pessoa_jurid      as character format "x(8)" label "Atividade" column-label "Atividade"
    field tta_log_ativid_pessoa_princ      as logical format "Sim/NÆo" initial no label "Atividade Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0 column-label "Codigo Cli\Fornc"
    index tt_pssjrdtv_atividade           
          tta_cod_ativid_pessoa_jurid      ascending
    index tt_pssjrdtv_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ativid_pessoa_jurid      ascending
          ttv_cdn_clien_fornec             ascending.

def temp-table tt_pj_ramo_negoc_integr_j no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_cod_ramo_negoc               as character format "x(8)" label "Ramo Neg¢cio" column-label "Ramo Neg¢cio"
    field tta_log_ramo_negoc_princ         as logical format "Sim/NÆo" initial no label "Ramo Negoc Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field ttv_cdn_clien_fornec             as Integer format ">>>,>>9" initial 0 column-label "Codigo Cli\Fornc"
    index tt_pssjrdm_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ramo_negoc               ascending
          ttv_cdn_clien_fornec             ascending
    index tt_pssjrdrm_ramo_negoc          
          tta_cod_ramo_negoc               ascending.

def temp-table tt_porte_pj_integr no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_dat_porte_pessoa_jurid       as date format "99/99/9999" initial ? label "Data Porte" column-label "Data Porte"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_vendas                   as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vendas" column-label "Vendas"
    field tta_val_patrim_liq               as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Patrim“nio L¡quido" column-label "Patrim“nio L¡quido"
    field tta_val_lucro_liq                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Lucro L¡quido" column-label "Lucro L¡quido"
    field tta_val_capit_giro_proprio       as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Capital Giro Pr¢prio" column-label "Capital Giro Pr¢prio"
    field tta_val_endivto_geral            as decimal format ">>9.99" decimals 2 initial 0 label "Endividamento Geral" column-label "Endividamento Geral"
    field tta_val_endivto_longo_praz       as decimal format ">>9.99" decimals 2 initial 0 label "Endividamento Longo" column-label "Endividamento Longo"
    field tta_val_vendas_func              as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Vendas Funcion rio" column-label "Vendas Funcion rio"
    field tta_qtd_funcionario              as decimal format ">>>,>>9" initial 0 label "Qtd Funcion rios" column-label "Qtd Funcion rios"
    field tta_cod_classif_pessoa_jurid     as character format "x(8)" label "Classifica‡Æo" column-label "Classifica‡Æo"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota‡Æo Tabela" column-label "Anota‡Æo Tabela"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_prtpssjr_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_dat_porte_pessoa_jurid       ascending
    index tt_prtpssjr_indic_econ          
          tta_cod_indic_econ               ascending.

def temp-table tt_idiom_pf_integr no-undo
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_idiom_princ              as logical format "Sim/NÆo" initial no label "Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_dmpssfs_id                    is primary unique
          tta_num_pessoa_fisic             ascending
          tta_cod_idioma                   ascending
    index tt_dmpssfs_idioma               
          tta_cod_idioma                   ascending.

def temp-table tt_idiom_contat_integr no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma"
    field tta_log_idiom_princ              as logical format "Sim/NÆo" initial no label "Principal" column-label "Principal"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_dmcntta_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cod_idioma                   ascending
    index tt_dmcntta_idioma               
          tta_cod_idioma                   ascending.

def temp-table tt_retorno_clien_fornec no-undo
    field ttv_cod_parameters               as character format "x(256)"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_parameters_clien         as character format "x(2000)"
    field ttv_cod_parameters_fornec        as character format "x(2000)"
    field ttv_log_envdo                    as logical format "Sim/NÆo" initial no
    field ttv_cod_parameters_clien_financ  as character format "x(2000)"
    field ttv_cod_parameters_fornec_financ as character format "x(2000)"
    field ttv_cod_parameters_pessoa_fisic  as character format "x(2000)"
    field ttv_cod_parameters_pessoa_jurid  as character format "x(2000)"
    field ttv_cod_parameters_estrut_clien  as character format "x(2000)"
    field ttv_cod_parameters_estrut_fornec as character format "x(2000)"
    field ttv_cod_parameters_contat        as character format "x(2000)"
    field ttv_cod_parameters_repres        as character format "x(2000)"
    field ttv_cod_parameters_ender_entreg  as character format "x(2000)"
    field ttv_cod_parameters_pessoa_ativid as character format "x(2000)"
    field ttv_cod_parameters_ramo_negoc    as character format "x(2000)"
    field ttv_cod_parameters_porte_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_idiom_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_clas_contat   as character format "x(2000)"
    field ttv_cod_parameters_idiom_contat  as character format "x(2000)"
    field ttv_cod_parameters_telef         as character format "x(2000)"
    field ttv_cod_parameters_telef_pessoa  as character format "x(2000)"
    field ttv_cod_parameters_histor_clien  as character format "x(4000)"
    field ttv_cod_parameters_histor_fornec as character format "x(4000)".

def temp-table tt_clien_analis_cr_integr no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_tip_clien                as character format "x(8)" label "Tipo Cliente" column-label "Tipo Cliente"
    field tta_cod_clas_risco_clien         as character format "x(8)" label "Classe Risco" column-label "Classe Risco"
    field tta_log_neces_acompto_spc        as logical format "Sim/NÆo" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_ind_sit_cr                   as character format "X(15)" label "Situa‡Æo" column-label "Situa‡Æo"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    index tt_clien_unico                   is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_cliente                  ascending.
	
def temp-table tt_cta_corren_fornec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D¡gito Ag Bcia" column-label "Dig Ag"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field ttv_cod_desc_cta_fornec          as character format "x(30)" label "Descri‡Æo Cta Corren" column-label "Descri‡Æo Cta Corren"
    field ttv_log_cta_prefer               as logical format "Sim/NÆo" initial no label "Preferencial" column-label "Preferencial"
    field ttv_num_tip_operac               as integer format ">9" column-label "Tipo  Opera‡Æo"
    field ttv_rec_cta_fornec               as recid format ">>>>>>9"
    index tt_conta_corrente                is primary unique
          tta_cod_empresa                  ascending
          tta_cdn_fornecedor               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_digito_agenc_bcia        ascending
          tta_cod_cta_corren_bco           ascending
          tta_cod_digito_cta_corren        ascending.		  
    
define variable i-tt-favorecido as handle no-undo.

def var ind_estado_civil_aux         as char                            no-undo.
def var ttv_num_tip_operac-aux       as int                             no-undo.
def var ind_tipo_pessoa_juridica-aux as char initial "PRIVADA"          no-undo.
def var cod_id_feder_aux             like pessoa_jurid.cod_id_feder     no-undo.
def var cod_cliente_aux              like cliente.cdn_cliente           no-undo.
def var cod_fornecedor_aux           like cliente.cdn_cliente           no-undo.
def var num_pessoa_aux               like pessoa_jurid.num_pessoa_jurid no-undo.
def var lg-ocorreu-erro              as log                             no-undo.
DEF VAR lg-criou-ok-aux              AS LOG INIT FALSE                  NO-UNDO.

DEFINE VARIABLE v_hdl_utb765zl AS HANDLE     NO-UNDO.

/* -------------------------------------------------------------------- */
{ems5\defcfg.i}

/* ------------------------------ DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRBANCO.I --- */
{srincl/srbanco.iv}

DEF BUFFER b_ti_controle_integracao FOR ti_controle_integracao.
DEF BUFFER b_ti_cliente FOR ti_cliente.

find last param_geral_ems where param_geral_ems.dat_ult_atualiz <= today no-lock no-error.
if   not avail param_geral_ems then do:
   hide message no-pause.
   message "Parametros gerais do EMS504 nao cadastrados com" skip
           "data igual ou inferior a de hoje."
           view-as alert-box title " Atencao !!! ".
   return.
end.

IF NOT PARAM_geral_ems.LOG_clien_fornec_unico 
THEN DO:
       MESSAGE "Atencao! O parametro 'Codigo unico para cliente e fornecedor' nao esta ativado nos 'Parametros Gerais do EMS'." SKIP
               "O processo de migracao nao pode continuar a partir deste ponto." SKIP
               "Ative o parametro antes de continuar com este processo."
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN.
     END.

DEF VAR ix-cont-aux AS INT INIT 0 NO-UNDO.

/**
 * Inicio do processo
 * Leitura com exclusive-lock pois no final eh atualizado CDSITUACAO
 */
for each ti_cliente EXCLUSIVE-LOCK where ti_cliente.cdsituacao = in-status-par:

    ix-cont-aux = ix-cont-aux + 1.
    
    ASSIGN lg-criou-ok-aux = FALSE.

    /**
     * Sai a cada 500 registros processados. 
     * Essa parada ajuda a evitar estouro de instancias da utb persistidas em memoria.
	 * O chamador controla o laco ate encerrarem as pendencias de importacao.
     */
    IF ix-cont-aux >= 500
    THEN LEAVE.
    
    PROCESS EVENTS.
    
    assign lg-ocorreu-erro = no.
    
    IF ti_cliente.COD_GRP_clien = "NAOM"
    THEN DO:
           run p_grava_falha("TI_CLIENTE " + string(ti_CLIENTE.COD_cliente) + " esta no grupo NAOM (nao migrar) mas possui titulos em aberto. Verifique","",11).
         END.
    ELSE DO:
           FOR first ti_pessoa where ti_pessoa.nrregistro = ti_cliente.nrpessoa NO-LOCK:
           END.
           if not available ti_pessoa 
           then do:                                           
                  run p_grava_falha('Nao existe de-para na tabela TI_PESSOA para a pessoa ' + string(ti_cliente.nrpessoa),"",11).           
                end.  
           else do:
                  /**
                   * Se CDN_CLIENTE estiver zerado, apresentar erro, pois ele ja deveria ter sido preenchido
                   * no processo anterior.
                   */
                  IF ti_cliente.cod_cliente = 0
                  OR ti_cliente.cod_cliente = ?
                  THEN DO:
                         run p_grava_falha('Codigo do cliente nao esta informado. Essa informacao deve ser gerada no processo anterior (extrator SQL). Pessoa: ' + string(ti_cliente.nrpessoa),"",11).
                       END.
                  ELSE DO:
                         if ti_Pessoa.cdn_fornecedor = ?
                         OR ti_pessoa.cdn_fornecedor = 0
                         then do:
                                /**
                                 * Conforme parametro do EMS5, codigo do Cliente e do Fornecedor devem ser sempre iguais para a mesma pessoa.
                                 */
                                assign cod_fornecedor_aux = ti_cliente.cod_cliente.
                              end.
                         else do:
                                IF ti_pessoa.cdn_fornecedor <> ti_pessoa.cdn_cliente
                                THEN DO:
                                       run p_grava_falha('Codigo do fornecedor (' + STRING(ti_pessoa.cdn_fornecedor) + ') esta diferente do codigo do cliente (' + string(ti_pessoa.cdn_cliente) +
                                                         '). Revise a carga desses campos, pois ambos devem ter a mesma codificacao. Pessoa: ' + string(ti_cliente.nrpessoa),"",11).
                                     END.
                              end.
           
                         if  ti_cliente.cod_id_feder         = "0"
                         and ti_cliente.cod_id_previd_social = "0"
                         then run p_grava_falha('Codigo do CNPJ e CEI do cliente (' + STRING(ti_pessoa.cdn_cliente) + ') zerado.',"",11).
           
                         assign cod_fornecedor_aux = ti_pessoa.cdn_fornecedor.
           
                         IF NOT lg-ocorreu-erro
                         THEN DO:
                                assign /*ti_cliente.cod_acao    = 'I' -- tratar isso no busca-cliente*/ 
                                       ti_cliente.nom_abrev   = ti_pessoa.noabreviado_cliente.
           
                                message in-status-par
                                        /*" >>> " + ti_cliente.cod_acao + "<<<" +*/
                                        " Processando Seq - " string(ti_cliente.nrseq_controle_integracao) +
                                        " Cliente " + ti_cliente.nom_cliente
                                        " Pessoa  " + string(ti_cliente.nrpessoa) 
                                        " Empresa " + string(ti_cliente.cod_empresa)   
                                        " Nome Abreviado " + ti_cliente.nom_abrev
                                        " Cod. Fornecedor " + string(cod_fornecedor_aux).
                                    
                                run limpa_temporaria.  
                                
                                case ti_cliente.ind_estado_civil :
                                   when "C" then assign ind_estado_civil_aux = "CASADO".
                                   when "S" then assign ind_estado_civil_aux = "SOLTEIRO".
                                   when "V" then assign ind_estado_civil_aux = "VIUVO".
                                   when "O" then assign ind_estado_civil_aux = "OUTROS".
                                   when "Q" then assign ind_estado_civil_aux = "SEPARADO".
                                   when "D" then assign ind_estado_civil_aux = "DIVORCIADO".
                                   otherwise assign ind_estado_civil_aux = "OUTROS".
                                end.
                                      
                                run cria_temporaria. 
                                
                                if lg-ocorreu-erro = no 
                                then do:
                                       if NOT valid-handle(v_hdl_utb765zl) 
                                       then do:
                                               run prgint/utb/utb765zl.py persistent set v_hdl_utb765zl (Input 1,
                                                                                     Input "EMS2",
                                                                                     Input "1").
                                            END.
                                       
                                       if valid-handle(v_hdl_utb765zl) 
                                       then do:
                                              /*
                                              OUTPUT TO c:\temp\tt_telef_pessoa_integr.csv APPEND.
                                              FOR EACH tt_telef_pessoa_integr:
                                                  EXPORT DELIMITER ";" tt_telef_pessoa_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_fornecedor_integr_k.csv APPEND.
                                              FOR EACH tt_fornecedor_integr_k:
                                                  EXPORT DELIMITER ";" tt_fornecedor_integr_k.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_pessoa_fisic_integr_e.csv APPEND.
                                              FOR EACH tt_pessoa_fisic_integr_e:
                                                  EXPORT DELIMITER ";" tt_pessoa_fisic_integr_e.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_cliente_integr_j.csv APPEND.
                                              FOR EACH tt_cliente_integr_j:
                                                  EXPORT DELIMITER ";" tt_cliente_integr_j.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_contato_integr_e.csv APPEND.
                                              FOR EACH tt_contato_integr_e:
                                                  EXPORT DELIMITER ";" tt_contato_integr_e.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_contat_clas_integr.csv APPEND.
                                              FOR EACH tt_contat_clas_integr:
                                                  EXPORT DELIMITER ";" tt_contat_clas_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_ender_entreg_integr_e.csv APPEND.
                                              FOR EACH tt_ender_entreg_integr_e:
                                                  EXPORT DELIMITER ";" tt_ender_entreg_integr_e.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_estrut_clien_integr.csv APPEND.
                                              FOR EACH tt_estrut_clien_integr:
                                                  EXPORT DELIMITER ";" tt_estrut_clien_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_estrut_fornec_integr.csv APPEND.
                                              FOR EACH tt_estrut_fornec_integr:
                                                  EXPORT DELIMITER ";" tt_estrut_fornec_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_fornec_financ_integr_e.csv APPEND.
                                              FOR EACH tt_fornec_financ_integr_e:
                                                  EXPORT DELIMITER ";" tt_fornec_financ_integr_e.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_histor_clien_integr.csv APPEND.
                                              FOR EACH tt_histor_clien_integr:
                                                  EXPORT DELIMITER ";" tt_histor_clien_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_histor_fornec_integr.csv APPEND.
                                              FOR EACH tt_histor_fornec_integr:
                                                  EXPORT DELIMITER ";" tt_histor_fornec_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_idiom_contat_integr.csv APPEND.
                                              FOR EACH tt_idiom_contat_integr:
                                                  EXPORT DELIMITER ";" tt_idiom_contat_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_idiom_pf_integr.csv APPEND.
                                              FOR EACH tt_idiom_pf_integr:
                                                  EXPORT DELIMITER ";" tt_idiom_pf_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_pessoa_jurid_integr_j.csv APPEND.
                                              FOR EACH tt_pessoa_jurid_integr_j:
                                                  EXPORT DELIMITER ";" tt_pessoa_jurid_integr_j.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_pj_ativid_integr_i.csv APPEND.
                                              FOR EACH tt_pj_ativid_integr_i:
                                                  EXPORT DELIMITER ";" tt_pj_ativid_integr_i.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_pj_ramo_negoc_integr_j.csv APPEND.
                                              FOR EACH tt_pj_ramo_negoc_integr_j:
                                                  EXPORT DELIMITER ";" tt_pj_ramo_negoc_integr_j.
                                              END.
                                              OUTPUT CLOSE.
                                              OUTPUT TO c:\temp\tt_porte_pj_integr.csv APPEND.
                                              FOR EACH tt_porte_pj_integr:
                                                  EXPORT DELIMITER ";" tt_porte_pj_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              
                                              OUTPUT TO c:\temp\tt_retorno_clien_fornec.csv APPEND.
                                              FOR EACH tt_retorno_clien_fornec:
                                                  EXPORT DELIMITER ";" tt_retorno_clien_fornec.
                                              END.
                                              OUTPUT CLOSE.
                                              
                                              OUTPUT TO c:\temp\tt_telef_integr.csv APPEND.
                                              FOR EACH tt_telef_integr:
                                                  EXPORT DELIMITER ";" tt_telef_integr.
                                              END.
                                              OUTPUT CLOSE.
                                              */
                                              
                                              run pi_main_block_utb765zl_8 in v_hdl_utb765zl (Input table tt_cliente_integr_j,
                                                                                              Input table tt_fornecedor_integr_k,
                                                                                              Input table tt_clien_financ_integr_e,
                                                                                              Input table tt_fornec_financ_integr_e,
                                                                                              Input table tt_pessoa_jurid_integr_j,
                                                                                              Input table tt_pessoa_fisic_integr_e,
                                                                                              Input table tt_contato_integr_e,
                                                                                              Input table tt_contat_clas_integr,
                                                                                              Input table tt_estrut_clien_integr,
                                                                                              Input table tt_estrut_fornec_integr,
                                                                                              Input table tt_histor_clien_integr,
                                                                                              Input table tt_histor_fornec_integr,
                                                                                              Input table tt_ender_entreg_integr_e,
                                                                                              Input table tt_telef_integr,
                                                                                              Input table tt_telef_pessoa_integr,
                                                                                              Input table tt_pj_ativid_integr_i,
                                                                                              Input table tt_pj_ramo_negoc_integr_j,
                                                                                              Input table tt_porte_pj_integr,
                                                                                              Input table tt_idiom_pf_integr,
                                                                                              Input table tt_idiom_contat_integr,
                                                                                              input-output table tt_retorno_clien_fornec,
                                                                                              Input table tt_clien_analis_cr_integr,
                                                                                              Input table tt_cta_corren_fornec) no-error.
                                              if error-status:error
                                              then do:
                                                     output to c:\temp\erro-chamada-utb765zl.txt append.
                                                     put unformatted error-status:get-message(1) skip.
                                                     output close.
                                                   end.
                                              
                                              delete procedure v_hdl_utb765zl.
                                                 
                                              /**
                                               * Se conseguiu criar Pessoa, Cliente e Cliente Financeiro no EMS5, entao nao acionar
                                               * o flag de erro. Se retornaram mensagens, serao de aviso, e nao de erro.
                                               */
                                              FOR FIRST tt_cliente_integr_j:
                                                  IF CAN-FIND(FIRST cliente
                                                              WHERE cliente.cdn_cliente = tt_cliente_integr_j.tta_cdn_cliente
                                                                AND CAN-FIND(FIRST clien_financ
                                                                             WHERE clien_financ.cod_empresa = cliente.cod_empresa
                                                                               AND clien_financ.cdn_cliente = cliente.cdn_cliente
                                                                               AND (    (tt_cliente_integr_j.ttv_ind_pessoa = "1" /*juridica*/ AND CAN-FIND(FIRST pessoa_jurid WHERE pessoa_jurid.num_pessoa_jurid = cliente.num_pessoa))
                                                                                     OR (tt_cliente_integr_j.ttv_ind_pessoa = "2" /*fisica*/   AND CAN-FIND(FIRST pessoa_fisic WHERE pessoa_fisic.num_pessoa_fisic = cliente.num_pessoa))
                                                                                   )
                                                                            )
                                                             )
                                                  THEN lg-criou-ok-aux = true.
                                              END.

                                              for each tt_retorno_clien_fornec no-lock:
                                                  run p_grava_falha(tt_retorno_clien_fornec.ttv_des_ajuda,
                                                                    tt_retorno_clien_fornec.ttv_des_mensagem,
                                                                    tt_retorno_clien_fornec.ttv_num_mensagem).
                                              end.

                                            END. /*valid-handle(v_hdl_utb765zl) */
                                     END. /*lg-ocorreu-erro = no */
                              END. /*NOT lg-ocorreu-erro*/
                       END. /*ti_cliente.cod_cliente = 0*/
                END. /* not available ti_pessoa  */
         END. /*ti_cliente.COD_GRP_clien = "NAOM"*/

    if lg-ocorreu-erro 
    then DO:
           assign ti_cliente.cdsituacao = "PE".
         END.
    else DO:
           assign ti_cliente.cdsituacao = "IT".
           /**
            * Ao setar para IT, trocar para CA possiveis registros antigos referentes ao mesmo cliente.
            */
           /* comentado pois estava invalidando registros de Alteracao que precisam ser processados
           FOR EACH ti_controle_integracao NO-LOCK
              WHERE ti_controle_integracao.nrsequencial = ti_cliente.NRSEQ_CONTROLE_INTEGRACAO,
               EACH b_ti_controle_integracao NO-LOCK
              WHERE b_ti_controle_integracao.nrsequencial_origem = ti_controle_integracao.nrsequencial_origem
                AND b_ti_controle_integracao.tpintegracao        = ti_controle_integracao.tpintegracao,
               EACH b_ti_cliente EXCLUSIVE-LOCK
              WHERE b_ti_cliente.nrseq_controle_integracao = b_ti_controle_integracao.nrsequencial
                AND ROWID(b_ti_cliente) <> ROWID(ti_cliente)
                AND b_ti_cliente.cdsituacao <> "IT":

                    ASSIGN b_ti_cliente.cdsituacao = "CA".
           END.*/
         END.

end. /* for each ti_cliente*/

Procedure limpa_temporaria:
    empty temp-table tt_cliente_integr_j.
    empty temp-table tt_fornecedor_integr_k.
    empty temp-table tt_clien_financ_integr_e.
    empty temp-table tt_fornec_financ_integr_e.
    empty temp-table tt_pessoa_jurid_integr_j.
    empty temp-table tt_pessoa_fisic_integr_e.
    empty temp-table tt_contato_integr_e.
    empty temp-table tt_contat_clas_integr.
    empty temp-table tt_estrut_clien_integr.
    empty temp-table tt_estrut_fornec_integr.
    empty temp-table tt_histor_clien_integr.
    empty temp-table tt_histor_fornec_integr.
    empty temp-table tt_ender_entreg_integr_e.
    
    empty temp-table tt_telef_integr.
    empty temp-table tt_telef_pessoa_integr.
    empty temp-table tt_pj_ativid_integr_i.
    empty temp-table tt_pj_ramo_negoc_integr_j.
    empty temp-table tt_porte_pj_integr.
    empty temp-table tt_idiom_pf_integr.
    empty temp-table tt_idiom_contat_integr.
    empty temp-table tt_retorno_clien_fornec.
    empty TEMP-TABLE tt_clien_analis_cr_integr.
    empty TEMP-TABLE tt_cta_corren_fornec.
end procedure.

/*================================*/
/* Gravar as falhas da integra»’o */
/*--------------------------------*/
procedure p_grava_falha:

    def input  parameter ptxajuda           like ti_falha_de_processo.txajuda   no-undo.
    def input  parameter ptxfalha           like ti_falha_de_processo.txfalha   no-undo.
    def input  parameter pnrmensagem        like ti_falha_de_processo.nrmensagem   no-undo. 

    if pnrmensagem <> 6279 then do: /* Tratando o retorno de sucesso de integracao */

      IF NOT lg-criou-ok-aux
      THEN DO:
              assign lg-ocorreu-erro = yes.
            
              create ti_falha_de_processo. 
                       assign
                       ti_falha_de_processo.cdintegracao              = "TI_CLIENTE"
                       ti_falha_de_processo.txajuda                   = "(P)" + ptxajuda
                       ti_falha_de_processo.txfalha                   = "(P)" + ptxfalha 
                       ti_falha_de_processo.nrmensagem                = pnrmensagem
                       ti_falha_de_processo.nrseq_controle_integracao = ti_cliente.nrseq_controle_integracao. 
    end.
      else DO:
             create ti_falha_de_processo. 
                      assign
                      ti_falha_de_processo.cdintegracao              = "TI_CLIENTE"
                      ti_falha_de_processo.txajuda                   = ptxajuda
                      ti_falha_de_processo.txfalha                   = "AVISO!: " + ptxfalha 
                      ti_falha_de_processo.nrmensagem                = pnrmensagem
                      ti_falha_de_processo.nrseq_controle_integracao = ti_cliente.nrseq_controle_integracao. 
           END.
    end.
end procedure.

/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */

procedure cria_temporaria:
/*
   Exceto a tabela tempor˜ria tt_retorno_clien_fornec,  todas as tabelas relacionadas possuem o atributo ttv_num_tip_operac. 
   Este atributo ser˜ utilizado para que a API receba o tipo de opera?Êo a ser efetuado. 
   Quando informado 1, ser˜ efetuada a inclusÊo ou, caso o registro j˜ estiver cadastrado, a modifica?Êo. 
   E, quando for informado 2, ser˜ efetuada a elimina?Êo.
      
   ASSIGN ti_cliente.cod_acao = "I" .
*/
   ASSIGN ttv_num_tip_operac-aux = 1.

   /*
   if ti_cliente.cod_acao = "I"  then do:
        assign ttv_num_tip_operac-aux = 1.
   end.
  
   if ti_cliente.cod_acao = "A"  then do:
      assign ttv_num_tip_operac-aux = 1.
   end. 
   */    
   if ti_cliente.cod_acao = "E" then 
      assign ttv_num_tip_operac-aux = 2.

   if ti_cliente.ind_tipo_pessoa = "J" then 
      run processa_pessoa_juridica.  
   else 
      run processa_pessoa_fisica.
   
end procedure.

/**** Processa Pessoa Juridica ****/ 
procedure processa_pessoa_juridica:  

   run busca_cliente("1", /* juridica */ 
                     output cod_cliente_aux, 
                     output num_pessoa_aux, 
                     output cod_id_feder_aux).
                     
   run grava_tt_cliente_integr(input "1", /* juridica */
                               input cod_cliente_aux,
                               input num_pessoa_aux,
                               
                               input cod_id_feder_aux).
   run grava_tt_cliente_financ_integr_e ( input cod_cliente_aux).

   run grava_tt_pessoa_jurid_integr_j ( input cod_cliente_aux,
                                        input num_pessoa_aux,
                                        input cod_id_feder_aux).
end procedure.

/**** Processa Pessoa Fisica ****/ 

procedure processa_pessoa_fisica:  

   run busca_cliente("2", /* fisica */ 
                     output cod_cliente_aux, 
                     output num_pessoa_aux, 
                     output cod_id_feder_aux).
                     
   run grava_tt_cliente_integr(input "2", /* fisica */
                               input cod_cliente_aux,
                               input num_pessoa_aux,
                               input cod_id_feder_aux).

   run grava_tt_cliente_financ_integr_e ( input cod_cliente_aux).
   run grava_tt_pessoa_fisic_integr_e ( input cod_cliente_aux,
                                        input num_pessoa_aux,
                                        input cod_id_feder_aux).                                      
end procedure.

procedure busca_cliente:

   def input  parameter ind_tipo_pessoa_par as char                            no-undo.
   def output parameter cod_cliente_par    like cliente.cdn_cliente     no-undo.
   def output parameter num_pessoa_par     like pessoa_jurid.num_pessoa_jurid  no-undo.
   def output parameter cod_id_feder_par   like pessoa_jurid.cod_id_feder      no-undo.
   
   assign cod_cliente_par  = 0
          num_pessoa_par   = 0
          cod_id_feder_par = "".

   /**
    * Sempre vai entrar aqui, visto que ti_cliente.cod_cliente preenchido eh premissa do processo.
    */
   if  ti_cliente.cod_cliente <> ?
   AND ti_cliente.cod_cliente > 0 
   then do:
          FOR first cliente where cliente.cod_EMPRESA  = ti_cliente.cod_EMPRESA 
                              and cliente.cdn_cliente  = ti_cliente.cod_cliente no-lock:
          END.
          if available cliente
          then do:
                 assign cod_cliente_par     = cliente.cdn_cliente
                        cod_id_feder_par    = cliente.cod_id_feder
                        num_pessoa_par      = cliente.num_pessoa
                        ti_cliente.cod_acao = "A".
               end.
          ELSE DO:
                 assign cod_cliente_par     = ti_cliente.cod_cliente
                        cod_id_feder_par    = ti_cliente.cod_id_feder
                        num_pessoa_par      = 0
                        ti_cliente.cod_acao = "I".
               END.
        end.  
   else do:
          /**
           * Desabilitado pois cod_cliente ja deve estar preenchido nesse ponto.
           
          assign cod_id_feder_par    = ti_cliente.cod_id_feder.                  
          
          find first cliente where cliente.cod_empresa = ti_cliente.cod_empresa and
                                   cliente.nom_abrev   = ti_cliente.nom_abrev no-lock no-error.
          if available cliente 
          then do:
                 message " Encontrou Cliente no EMS pelo NOME ABREV" .
                 
                 assign cod_cliente_par  = cliente.cdn_cliente
                        cod_id_feder_par = cliente.cod_id_feder
                        num_pessoa_par   = cliente.num_pessoa.                
               end.
          else do:           
                 if ti_cliente.cod_acao = "I" 
                 OR ti_cliente.cod_acao = "A" 
                 then do:  
                        if cod_fornecedor_aux > 0 
                        then do:
                               find first cliente where cliente.cod_empresa = ti_cliente.cod_empresa and
                                                        cliente.cdn_cliente = cod_fornecedor_aux no-error.
                               if not available cliente 
                               then do:
                                      find fornecedor where fornecedor.cod_empresa    = ti_cliente.cod_empresa
                                                        and fornecedor.cdn_fornecedor = cod_fornecedor_aux no-error.
                                      
                                      if  available fornecedor 
                                      then do:
                                             assign cod_cliente_par = cod_fornecedor_aux.
                                                    num_pessoa_par  = fornecedor.num_pessoa.
                                           end.
                                    end.
                             end.
                 
                        if cod_cliente_par = 0 
                        then do:
                               /**
                                * Gerar novo codigo para o cliente.
                                * Garantir que seja iniciado em 1000, para que os valores entre 1 e 999 fiquem reservados para Unimeds.
                                */
                               find last cliente USE-INDEX cliente_id where cliente.cod_empresa = ti_cliente.cod_empresa exclusive-lock no-error.
                               
                               if available cliente 
                               then assign cod_cliente_par = cliente.cdn_cliente + 1. /* gera nr. cliente */
                               else assign cod_cliente_par = 1.
                               
                               IF cod_cliente_par < 1000
                               THEN ASSIGN cod_cliente_par = 1000.
                                    
                               find last fornecedor USE-INDEX frncdr_id where fornecedor.cod_empresa = ti_cliente.cod_empresa exclusive-lock no-error.
                               
                               if available fornecedor 
                               then do:
                                      if fornecedor.cdn_fornecedor >= cod_cliente_par 
                                      then assign cod_cliente_par = fornecedor.cdn_fornecedor + 1.
                                    end.
                               assign num_pessoa_par = 0.     
                             end.
                      END.
                 else do:          
                        if ti_cliente.cod_acao = "E" 
                        then do:
                               run p_grava_falha(
                                               'NÆo ² poss¡vel excluir o cliente, pois, o codigo de cliente informado n’o foi encontratdo',
                                               'Cliente : ' + string(ti_cliente.cod_cliente) + ' n’o localizado',
                                               12
                                               ).
                             end.
                        else do:
                               run p_grava_falha(
                                               'NÆo ² poss¡vel excluir o cliente, pois, o codigo de cliente informado n’o foi encontratdo',
                                               'Cliente : ' + string(ti_cliente.cod_cliente) + ' n’o localizado',
                                               13
                                               ).
                             end.
                      end.
               END.*/
        END.

   message " Processando - "     string(ti_cliente.nrseq_controle_integracao) +
           " Cliente "         + ti_cliente.nom_cliente
           " Pessoa "          + string(ti_cliente.nrpessoa) 
           " Nome Abreviado "  + ti_cliente.nom_abrev
           " N§ Pessoa      "  + string(num_pessoa_par)
           " Cod. Cliente "    + string(cod_cliente_par)    
           " Cod. Empresa "    + string(ti_cliente.cod_empresa) 
           " Tipo de Pessoa"   + STRING(ind_tipo_pessoa_par) 
           " Cod. Fornecedor " + string(cod_fornecedor_aux).
/*            pause 5. */
end procedure.

Procedure grava_tt_cliente_integr:
   def input parameter ind_tipo_pessoa_par as char no-undo.
   def input parameter cod_cliente_par     like cliente.cdn_cliente  no-undo.
   def input parameter num_pessoa_par      like pessoa_jurid.num_pessoa_jurid     no-undo.
   def input parameter cod_id_feder_par    like pessoa_jurid.cod_id_feder   no-undo.

   create tt_cliente_integr_j.
   assign tt_cliente_integr_j.tta_cod_empresa         = ti_cliente.cod_empresa    
          tt_cliente_integr_j.tta_cdn_cliente         = cod_cliente_par 
          tt_cliente_integr_j.tta_num_pessoa          = num_pessoa_par  
          tt_cliente_integr_j.tta_nom_abrev           = ti_cliente.nom_abrev         
          tt_cliente_integr_j.tta_cod_grp_clien       = ti_cliente.cod_grp_clien
          tt_cliente_integr_j.tta_cod_tip_clien       = ti_cliente.cod_tip_clien                                
          tt_cliente_integr_j.tta_dat_impl_clien      = ti_cliente.dat_impl_clien    
          tt_cliente_integr_j.tta_cod_pais_ext        = ti_cliente.cod_pais_nasc     
          tt_cliente_integr_j.tta_cod_pais            = ti_cliente.cod_pais_nasc     
          tt_cliente_integr_j.tta_cod_id_feder        = cod_id_feder_par
          tt_cliente_integr_j.ttv_ind_pessoa          = ind_tipo_pessoa_par
          tt_cliente_integr_j.ttv_num_tip_operac      =  ttv_num_tip_operac-aux                               
          tt_cliente_integr_j.tta_log_ems_20_atlzdo   = no                                
          tt_cliente_integr_j.tta_cod_grp_clien       = ti_cliente.cod_grp_clien.
          /* tt_cliente_integr_j.ttv_ind_tip_pessoa_ems2 = ind_tipo_pessoa-aux         .*/        
          
end procedure.
  
Procedure grava_tt_cliente_financ_integr_e:
   def input parameter cod_cliente_par    like cliente.cdn_cliente  no-undo.

   DEF VAR ds-agencia-aux AS CHAR NO-UNDO.
   DEF VAR ds-conta-aux   AS CHAR NO-UNDO.
   DEF VAR lg-erro-aux    AS LOG NO-UNDO.
   DEF VAR ds-erro-aux    AS CHAR NO-UNDO.

   ASSIGN ds-agencia-aux = ti_cliente.cod_agenc_bcia
          ds-conta-aux   = ti_cliente.cod_cta_corren_bco.

   {srincl/srbanco.i "string(int(ti_cliente.cod_banco),'999')"}

   if   lg-avail-srbanco-srems
   then do:
          run preenche-verifica-mascara(input banco.cod_format_agenc_bcia,
                                        input-output ds-agencia-aux,
                                        output lg-erro-aux,
                                        output ds-erro-aux).

          run preenche-verifica-mascara(input  banco.cod_format_cta_corren,
                                        input-output ds-conta-aux,
                                        output lg-erro-aux,
                                        output ds-erro-aux).
        end.

   create tt_clien_financ_integr_e.
   assign tt_clien_financ_integr_e.tta_cod_empresa               = ti_cliente.cod_empresa 
          tt_clien_financ_integr_e.tta_cdn_cliente               = cod_cliente_par /* ti_cliente.cod_cliente   */
          tt_clien_financ_integr_e.tta_cdn_repres                = 1
          tt_clien_financ_integr_e.ttv_cod_portad_prefer_ext     = "" 
          tt_clien_financ_integr_e.tta_cod_portad_ext            = ti_cliente.cod_portad_prefer
          tt_clien_financ_integr_e.ttv_cod_portad_prefer         = ti_cliente.cod_portad_prefer  
          tt_clien_financ_integr_e.tta_cod_portador              = ti_cliente.cod_portad_prefer  
          tt_clien_financ_integr_e.tta_cod_cta_corren_bco        = ds-conta-aux   
          tt_clien_financ_integr_e.tta_cod_digito_cta_corren     = ""  
          tt_clien_financ_integr_e.tta_cod_agenc_bcia            = ds-agencia-aux
          tt_clien_financ_integr_e.tta_cod_banco                 = ti_cliente.cod_banco   
          tt_clien_financ_integr_e.tta_cod_classif_msg_cobr      = '000' /*'1'*/ /*"Padrao" - existe procedure para ajuste posterior P_ATUALIZA_BLOQUEIO_CLIENTE */
          tt_clien_financ_integr_e.tta_cod_instruc_bcia_1_acr  =   ""
          tt_clien_financ_integr_e.tta_cod_instruc_bcia_2_acr    = ""  
          tt_clien_financ_integr_e.tta_log_habilit_emis_boleto   = YES  
          tt_clien_financ_integr_e.tta_log_habilit_gera_avdeb    = NO  
          tt_clien_financ_integr_e.tta_log_retenc_impto          = NO  
          tt_clien_financ_integr_e.tta_log_habilit_db_autom      = NO  
          tt_clien_financ_integr_e.tta_num_tit_acr_aber          = 0   
          tt_clien_financ_integr_e.tta_dat_ult_impl_tit_acr      = ?  
          tt_clien_financ_integr_e.tta_dat_ult_liquidac_tit_acr  = ?  
          tt_clien_financ_integr_e.tta_dat_maior_tit_acr         = ?  
          tt_clien_financ_integr_e.tta_dat_maior_acum_tit_acr    = ?  
          tt_clien_financ_integr_e.tta_val_ult_impl_tit_acr      = 0   
          tt_clien_financ_integr_e.tta_val_maior_tit_acr         = 0  
          tt_clien_financ_integr_e.tta_val_maior_acum_tit_acr    = 0  
          tt_clien_financ_integr_e.tta_ind_sit_clien_perda_dedut =  "Normal"
          tt_clien_financ_integr_e.ttv_num_tip_operac            =   ttv_num_tip_operac-aux
          tt_clien_financ_integr_e.tta_log_neces_acompto_spc     =   no
          tt_clien_financ_integr_e.tta_cod_tip_fluxo_financ      = ti_cliente.cod_tip_fluxo_financ  
          tt_clien_financ_integr_e.tta_log_utiliz_verba          =  no 
          tt_clien_financ_integr_e.tta_val_perc_verba            = 0  
          tt_clien_financ_integr_e.tta_val_min_avdeb             = 0  
          tt_clien_financ_integr_e.tta_log_calc_multa            = yes 
          tt_clien_financ_integr_e.tta_num_dias_atraso_avdeb     = 0  
          tt_clien_financ_integr_e.tta_cod_digito_agenc_bcia     = ""  
          tt_clien_financ_integr_e.tta_cod_cart_bcia             = ti_cliente.cod_cart_bcia_prefer 
          tt_clien_financ_integr_e.tta_cod_cart_bcia_prefer      = ti_cliente.cod_cart_bcia_prefer.
          
end procedure.
  
procedure grava_tt_pessoa_jurid_integr_j:
   def input parameter cod_cliente_par    like cliente.cdn_cliente  no-undo.
   def input parameter num_pessoa_par     like pessoa_jurid.num_pessoa_jurid     no-undo.
   def input parameter cod_id_feder_par   like pessoa_jurid.cod_id_feder   no-undo.

   create tt_pessoa_jurid_integr_j.
   assign tt_pessoa_jurid_integr_j.tta_num_pessoa_jurid               = num_pessoa_par
             tt_pessoa_jurid_integr_j.tta_nom_pessoa                  = ti_cliente.nom_cliente
             tt_pessoa_jurid_integr_j.tta_cod_id_feder                = cod_id_feder_par
             tt_pessoa_jurid_integr_j.tta_cod_id_estad_jurid          = ti_cliente.cod_id_feder_estad_jurid
             tt_pessoa_jurid_integr_j.tta_cod_id_munic_jurid          = ti_cliente.cod_id_munic_jurid  
             tt_pessoa_jurid_integr_j.tta_cod_id_previd_social        = ti_cliente.cod_id_previd_social
             tt_pessoa_jurid_integr_j.tta_log_fins_lucrat             = if ti_cliente.log_fins_lucrat  = "S" then yes else no   
             tt_pessoa_jurid_integr_j.tta_num_pessoa_jurid_matriz     = 0
             tt_pessoa_jurid_integr_j.tta_nom_endereco                = ti_cliente.nom_endereco   
             tt_pessoa_jurid_integr_j.tta_nom_bairro                  = ti_cliente.nom_bairro     
             tt_pessoa_jurid_integr_j.tta_nom_cidade                  = ti_cliente.nom_cidade     
             tt_pessoa_jurid_integr_j.tta_nom_condado                 = ""
             tt_pessoa_jurid_integr_j.tta_cod_pais_ext                = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_j.tta_cod_pais                    = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_j.tta_cod_unid_federac            = ti_cliente.cod_unid_feder
             tt_pessoa_jurid_integr_j.tta_cod_cep                     = ti_cliente.cod_cep
             tt_pessoa_jurid_integr_j.tta_cod_cx_post                 = ti_cliente.cod_cx_post
             tt_pessoa_jurid_integr_j.tta_cod_telefone                = ti_cliente.cod_telefone_1
             tt_pessoa_jurid_integr_j.tta_cod_fax                     = ti_cliente.cod_fax
             tt_pessoa_jurid_integr_j.tta_cod_ramal_fax               = ti_cliente.cod_ramal_fax
             tt_pessoa_jurid_integr_j.tta_cod_telex                   = ""
             tt_pessoa_jurid_integr_j.tta_cod_modem                   = ""
             tt_pessoa_jurid_integr_j.tta_cod_ramal_modem             = ""
             tt_pessoa_jurid_integr_j.tta_cod_e_mail                  = ti_cliente.cod_e_mail
             tt_pessoa_jurid_integr_j.tta_des_anot_tab                = "" /*ti_cliente.dest_anot_tabela ESSE CAMPO PASSOU A SER USADO PARA TRATAR O ENDERECO COMPLETO */
             tt_pessoa_jurid_integr_j.tta_ind_tip_pessoa_jurid        = ind_tipo_pessoa_JURIDICA-aux
             tt_pessoa_jurid_integr_j.tta_ind_tip_capit_pessoa_jurid  = "Nacional" /* existem dois tipos Nacional e Muntinacional tem que abrir um campo na Tabela*/
             tt_pessoa_jurid_integr_j.tta_cod_imagem                  = ""
             tt_pessoa_jurid_integr_j.tta_log_ems_20_atlzdo           = no
             tt_pessoa_jurid_integr_j.ttv_num_tip_operac              =   ttv_num_tip_operac-aux 
             tt_pessoa_jurid_integr_j.tta_num_pessoa_jurid_cobr       = 0
             
             tt_pessoa_jurid_integr_j.tta_nom_ender_cobr              = ti_cliente.nom_endereco_cobr
             tt_pessoa_jurid_integr_j.tta_nom_bairro_cobr             = ti_cliente.nom_bairro_cobr
             tt_pessoa_jurid_integr_j.tta_nom_cidad_cobr              = ti_cliente.nom_cidade_cobr
             tt_pessoa_jurid_integr_j.tta_nom_condad_cobr             = ""
             tt_pessoa_jurid_integr_j.tta_cod_unid_federac_cobr       = ti_cliente.cod_unid_feder_cobr
             tt_pessoa_jurid_integr_j.ttv_cod_pais_ext_cob            = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_j.ttv_cod_pais_cobr               = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_j.tta_cod_cep_cobr                = ti_cliente.cod_cep_cobr
             tt_pessoa_jurid_integr_j.tta_cod_cx_post_cobr            = ti_cliente.cod_cx_post_cobr
                 
             tt_pessoa_jurid_integr_j.tta_num_pessoa_jurid_pagto      = 0
             tt_pessoa_jurid_integr_j.tta_nom_ender_pagto             = ""
             tt_pessoa_jurid_integr_j.tta_nom_ender_compl_pagto       = ""
             tt_pessoa_jurid_integr_j.tta_nom_bairro_pagto            = ""
             tt_pessoa_jurid_integr_j.tta_nom_cidad_pagto             = ""
             tt_pessoa_jurid_integr_j.tta_nom_condad_pagto            = ""
             tt_pessoa_jurid_integr_j.tta_cod_unid_federac_pagto      = ""
             tt_pessoa_jurid_integr_j.ttv_cod_pais_ext_pag            = ""
             tt_pessoa_jurid_integr_j.ttv_cod_pais_pagto              = ""
             tt_pessoa_jurid_integr_j.tta_cod_cep_pagto               = ""
             tt_pessoa_jurid_integr_j.tta_cod_cx_post_pagto           = ""
             tt_pessoa_jurid_integr_j.ttv_rec_fiador_renegoc          = ?
             tt_pessoa_jurid_integr_j.ttv_log_altera_razao_social     = YES
             tt_pessoa_jurid_integr_j.tta_nom_home_page               = ""
             tt_pessoa_jurid_integr_j.tta_nom_ender_cobr_text         = TI_CLIENTE.DEST_ANOT_TABELA /* endereco completo (logradouro + numero + complemento + bairro) sem abreviacoes */
             tt_pessoa_jurid_integr_j.tta_nom_ender_pagto_text        = ""                  
             /* tt_pessoa_jurid_integr_j.tta_cdn_fornecedor               = 0    
             tt_pessoa_jurid_integr_j.ttv_ind_tip_pessoa_ems2         = "Jurðdica" */ 
             tt_pessoa_jurid_integr_j.tta_nom_ender_text              = TI_CLIENTE.DEST_ANOT_TABELA /* endereco completo (logradouro + numero + complemento + bairro) sem abreviacoes */
             substring(tt_pessoa_jurid_integr_j.tta_nom_ender_text,1991,9) = string(cod_cliente_par,"999999999")
             tt_pessoa_jurid_integr_j.tta_cdn_fornecedor              = cod_cliente_par.

   IF ti_cliente.nom_ender_compl <> ?
   THEN tt_pessoa_jurid_integr_j.tta_nom_ender_compl             = ti_cliente.nom_ender_compl.
   else tt_pessoa_jurid_integr_j.tta_nom_ender_compl             = "".

   IF ti_cliente.nom_ender_compl_cobr <> ?
   THEN tt_pessoa_jurid_integr_j.tta_nom_ender_compl_cobr        = ti_cliente.nom_ender_compl_cobr.
   else tt_pessoa_jurid_integr_j.tta_nom_ender_compl_cobr        = "".

 end procedure.
 
 procedure grava_tt_pessoa_fisic_integr_e:
    def input parameter cod_cliente_par    like cliente.cdn_cliente  no-undo.
    def input parameter num_pessoa_par     like pessoa_fisic.num_pessoa_fisic     no-undo.
    def input parameter cod_id_feder_par   like pessoa_fisic.cod_id_feder   no-undo.

   def var vcount as int                       no-undo.
   
   assign vcount = 2000 - length(string(cod_cliente_par)).   
   
    create tt_pessoa_fisic_integr_e.
    assign tt_pessoa_fisic_integr_e.tta_num_pessoa_fisic                      = num_pessoa_par                                                                        
                  tt_pessoa_fisic_integr_e.tta_nom_pessoa                     = ti_cliente.nom_cliente                                                                    
                  tt_pessoa_fisic_integr_e.tta_cod_id_feder                   = cod_id_feder_par
                  tt_pessoa_fisic_integr_e.tta_cod_id_estad_fisic             = /*"ISENTO"*/ ti_cliente.COD_ID_ESTAD_FISIC
                  tt_pessoa_fisic_integr_e.tta_cod_orgao_emis_id_estad        = ti_cliente.COD_ORG_EMIS_ID_ESTAD
                  tt_pessoa_fisic_integr_e.tta_cod_unid_federac_emis_estad    = ti_cliente.COD_ID_FEDER_EMIS_ESTAD
                  tt_pessoa_fisic_integr_e.tta_nom_endereco                   = ti_cliente.nom_endereco   
                  tt_pessoa_fisic_integr_e.tta_nom_bairro                     = ti_cliente.nom_bairro     
                  tt_pessoa_fisic_integr_e.tta_nom_cidade                     = ti_cliente.nom_cidade     
                  tt_pessoa_fisic_integr_e.tta_nom_condado                    = ""                            
                  tt_pessoa_fisic_integr_e.tta_cod_pais_ext                   = /*ti_cliente.cod_pais_nasc*/ "BRA" 
                  tt_pessoa_fisic_integr_e.tta_cod_pais                       = /*ti_cliente.cod_pais_nasc*/ "BRA"
                  tt_pessoa_fisic_integr_e.tta_cod_unid_federac               = ti_cliente.cod_unid_feder
                  tt_pessoa_fisic_integr_e.tta_cod_cep                        = ti_cliente.cod_cep       
                  tt_pessoa_fisic_integr_e.tta_cod_cx_post                    = ti_cliente.cod_cx_post   
                  
                  tt_pessoa_fisic_integr_e.tta_nom_ender_cobr                 = ti_cliente.nom_endereco_cobr
                  tt_pessoa_fisic_integr_e.tta_nom_bairro_cobr                = ti_cliente.nom_bairro_cobr
                  tt_pessoa_fisic_integr_e.tta_nom_cidad_cobr                 = ti_cliente.nom_cidade_cobr
                  tt_pessoa_fisic_integr_e.tta_nom_condad_cobr                = ""
                  tt_pessoa_fisic_integr_e.tta_cod_unid_federac_cobr          = ti_cliente.cod_unid_feder_cobr
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_ext_cob               = /*ti_cliente.cod_pais_nasc*/ "BRA"
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_cobr                  = /*ti_cliente.cod_pais_nasc*/ "BRA"
                  tt_pessoa_fisic_integr_e.tta_cod_cep_cobr                   = ti_cliente.cod_cep_cobr
                  tt_pessoa_fisic_integr_e.tta_cod_cx_post_cobr               = ti_cliente.cod_cx_post_cobr

                  tt_pessoa_fisic_integr_e.tta_cod_telefone                   = ti_cliente.cod_telefone_1
                  /*tt_pessoa_fisic_integr_e.tta_cod_ramal                      = */
                  tt_pessoa_fisic_integr_e.tta_cod_fax                        = ti_cliente.cod_fax       
                  tt_pessoa_fisic_integr_e.tta_cod_ramal_fax                  = ti_cliente.cod_ramal_fax
                  tt_pessoa_fisic_integr_e.tta_cod_telex                      =  ""
                  tt_pessoa_fisic_integr_e.tta_cod_modem                      =  ""  
                  tt_pessoa_fisic_integr_e.tta_cod_ramal_modem                =  ""
                  tt_pessoa_fisic_integr_e.tta_cod_e_mail                     = COD_E_MAIL
                  tt_pessoa_fisic_integr_e.tta_dat_nasc_pessoa_fisic          = ti_cliente.dat_nascimento
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_ext_nasc              = ti_cliente.cod_pais_nasc
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_nasc                  = ti_cliente.cod_pais_nasc
                  tt_pessoa_fisic_integr_e.tta_des_anot_tab                   = ""
                  tt_pessoa_fisic_integr_e.tta_nom_mae_pessoa                 = ""
                  tt_pessoa_fisic_integr_e.tta_cod_imagem                     = ""
                  tt_pessoa_fisic_integr_e.tta_log_ems_20_atlzdo              = no
                  tt_pessoa_fisic_integr_e.ttv_num_tip_operac                 = ttv_num_tip_operac-aux 
                  tt_pessoa_fisic_integr_e.ttv_rec_fiador_renegoc             = 0
                  tt_pessoa_fisic_integr_e.ttv_log_altera_razao_social        = YES
                  tt_pessoa_fisic_integr_e.tta_nom_nacion_pessoa_fisic        = ""
                  tt_pessoa_fisic_integr_e.tta_nom_profis_pessoa_fisic        = ""
                  tt_pessoa_fisic_integr_e.tta_ind_estado_civil_pessoa        = ind_estado_civil_aux
                  tt_pessoa_fisic_integr_e.tta_nom_home_page                  = ""
                  tt_pessoa_fisic_integr_e.tta_nom_ender_text                 = TI_CLIENTE.DEST_ANOT_TABELA /* endereco completo (logradouro + numero + complemento + bairro) sem abreviacoes */
                  /*tt_pessoa_fisic_integr_e.tta_nom_ender_cobr_text            = TI_CLIENTE.DEST_ANOT_TABELA /* endereco completo (logradouro + numero + complemento + bairro) sem abreviacoes */*/
                  substring(tt_pessoa_fisic_integr_e.tta_nom_ender_text,1991,9) = string(cod_cliente_par,"999999999").

		if tt_pessoa_fisic_integr_e.ttv_cod_pais_nasc                  = "BRA"
		then assign tt_pessoa_fisic_integr_e.tta_cod_unid_federac_nasc          = ti_cliente.COD_ID_FEDER_NASC.
		else assign tt_pessoa_fisic_integr_e.tta_cod_unid_federac_nasc          = tt_pessoa_fisic_integr_e.ttv_cod_pais_nasc.
				  
    IF ti_cliente.nom_ender_compl <> ?
    THEN tt_pessoa_fisic_integr_e.tta_nom_ender_compl                = ti_cliente.nom_ender_compl.
    else tt_pessoa_fisic_integr_e.tta_nom_ender_compl                = "".

    IF ti_cliente.nom_ender_compl_cobr <> ?
    THEN tt_pessoa_fisic_integr_e.tta_nom_ender_compl_cobr                = ti_cliente.nom_ender_compl_cobr.
    else tt_pessoa_fisic_integr_e.tta_nom_ender_compl_cobr                = "".

    /*field tta_cod_e_mail_cobr       as char format "x(40)"*/

end procedure.

procedure preenche-verifica-mascara private:

    def input         parameter ds-mascara-par       as char no-undo.
    def input-output  parameter ds-campo-valida-par  as char no-undo.

    def output        parameter lg-erro              as logical initial no no-undo.
    def output        parameter ds-erro              as char initial "" no-undo.

    def var i               as int initial 0  no-undo.
    def var j               as int initial 0  no-undo.
    def var cont            as int initial 0  no-undo.
    def var ds-mascara-aux         as char no-undo.
    def var ds-campo-valida-aux    as char no-undo.
    def var ds-campo-valida-sub1   as char no-undo.
    def var ds-campo-valida-sub2   as char no-undo.                        
    
    assign ds-mascara-par      = trim(ds-mascara-par)
           ds-campo-valida-par = trim(ds-campo-valida-par).

    /**
     * Retirar o caracter "." do conteudo a ser editado.
     */
    ds-campo-valida-par = replace(ds-campo-valida-par,".","").

    assign i = length(ds-mascara-par).
    assign j = length(ds-campo-valida-par).
    
    repeat:

        assign ds-mascara-aux = substring(ds-mascara-par,i,1).
    
        if (cont + 1) > j
        then do:
               if ds-mascara-aux = "x" 
               then assign ds-campo-valida-par = " " + ds-campo-valida-par.                  
               else if ds-mascara-aux = "9" 
                    then assign ds-campo-valida-par = "0" + ds-campo-valida-par.
                    else if ds-mascara-aux = "."
                         then assign ds-campo-valida-par = "." + ds-campo-valida-par.
                         else if ds-mascara-aux = "!"
                              then assign lg-erro = yes
                                          ds-erro = "Valor do campo fora do Formato".
             end.
        else do:
               assign ds-campo-valida-aux = substring(ds-campo-valida-par,j - cont,1).  
    
               if ds-mascara-aux = "!" 
               then do:
                      if ds-campo-valida-aux = " " or
                         ds-campo-valida-aux = ""
                      then do:
                             assign lg-erro = yes
                                    ds-erro = "Valor do campo fora do Formato".
                           end.
    
                      int(ds-campo-valida-aux) no-error.
                      if not error-status:error
                      then do:
                             assign lg-erro = yes
                                    ds-erro = "Valor do campo fora do Formato".
                           end.
    
                      assign ds-campo-valida-sub1 = substring(ds-campo-valida-par,1,j - (cont + 1))             
                             ds-campo-valida-sub2 = substring(ds-campo-valida-par,j - (cont - 1),cont).
                             ds-campo-valida-par = ds-campo-valida-sub1 + caps(ds-campo-valida-aux) + ds-campo-valida-sub2.         
                      
                    end.
               else if ds-mascara-aux = "9" 
                    then do:
                           if ds-campo-valida-aux = " " or
                              ds-campo-valida-aux = ""
                           then assign ds-campo-valida-aux = "0".
                    
                           int(ds-campo-valida-aux) no-error.
                           if error-status:error
                           then do:
                                  assign lg-erro = yes
                                         ds-erro = "Valor do campo fora do Formato".
                                end.
                    
                           assign ds-campo-valida-sub1 = substring(ds-campo-valida-par,1,j - (cont + 1))             
                                  ds-campo-valida-sub2 = substring(ds-campo-valida-par,j - (cont - 1),cont).
                                  ds-campo-valida-par = ds-campo-valida-sub1 + ds-campo-valida-aux + ds-campo-valida-sub2.         
                           
                         end.
                    else if ds-mascara-aux = "."
                         then do:
                                assign ds-campo-valida-sub1 = substring(ds-campo-valida-par,1,j - cont)             
                                       ds-campo-valida-sub2 = substring(ds-campo-valida-par,j - (cont - 1),cont)
                                       ds-campo-valida-par = ds-campo-valida-sub1 + "." + ds-campo-valida-sub2.
                              end.
                    
             end.
    
        assign i = i - 1
               cont = cont + 1
               j = length(ds-campo-valida-par).
               
        if i = 0
        then leave.
    end.

    /**
     * Retirar o caracter ponto "." do valor a ser retornado.
     */
    ds-campo-valida-par = replace(ds-campo-valida-par,".","").

end procedure.

/* ---------------------------------------------------------- */
/* ---------------------------------------------------- EOF - */
/* ---------------------------------------------------------- */
