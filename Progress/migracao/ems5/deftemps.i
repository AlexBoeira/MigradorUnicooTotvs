/* ------------------------------------------------------------------------ */
/* -------- DEFINICAO DE TABELAS TEMPORARIAS PARA INTEGRACAO -------------- */
/* ------------------------------------------------------------------------ */
def temp-table tt_cliente_integr no-undo 
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
    field ttv_num_tip_operac               as integer format ">9" 
    field tta_log_ems_20_atlzdo            as logical format "Sim/NÆo" initial no label "2.0 Atualizado" column-label "2.0 Atualizado" 
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

def temp-table tt_fornecedor_integr no-undo 
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
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Banc ria" column-label "Ag¼ncia Banc ria"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_classif_msg_cobr         as character format "x(8)" label "Classif Msg Cobr" column-label "Classif Msg Cobr"
    field tta_cod_instruc_bcia_1_acr       as character format "x(4)" label "Instru»’o Bcia 1" column-label "Instru»’o 1"
    field tta_cod_instruc_bcia_2_acr       as character format "x(4)" label "Instru»’o Bcia 2" column-label "Instru»’o 2"
    field tta_log_habilit_emis_boleto      as logical format "Sim/N’o" initial no label "Emitir Boleto" column-label "Emitir Boleto"
    field tta_log_habilit_gera_avdeb       as logical format "Sim/N’o" initial no label "Gerar AD" column-label "Gerar AD"
    field tta_log_retenc_impto             as logical format "Sim/N’o" initial no label "Ret²m Imposto" column-label "Ret²m Imposto"
    field tta_log_habilit_db_autom         as logical format "Sim/N’o" initial no label "D²bito Auto" column-label "D²bito Auto"
    field tta_num_tit_acr_aber             as integer format ">>>>,>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert"
    field tta_dat_ult_impl_tit_acr         as date format "99/99/9999" initial ? label "‚ltima Implanta»’o" column-label "‚ltima Implanta»’o"
    field tta_dat_ult_liquidac_tit_acr     as date format "99/99/9999" initial ? label "Ultima Liquida»’o" column-label "Ultima Liquida»’o"
    field tta_dat_maior_tit_acr            as date format "99/99/9999" initial ? label "Data Maior T­tulo" column-label "Data Maior T­tulo"
    field tta_dat_maior_acum_tit_acr       as date format "99/99/9999" initial ? label "Data Maior Acum" column-label "Data Maior Acum"
    field tta_val_ult_impl_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Ultimo Tit" column-label "Valor Ultimo Tit"
    field tta_val_maior_tit_acr            as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior T­tulo" column-label "Vl Maior T­tulo"
    field tta_val_maior_acum_tit_acr       as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Acœmulo" column-label "Vl Maior Acœmulo"
    field tta_ind_sit_clien_perda_dedut    as character format "X(21)" initial "Normal" label "Situa»’o Cliente" column-label "Sit Cliente"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_log_neces_acompto_spc        as logical format "Sim/N’o" initial no label "Neces Acomp SPC" column-label "Neces Acomp SPC"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_log_utiliz_verba             as logical format "Sim/N’o" initial no label "Utiliza Verba de Pub" column-label "Utiliza Verba de Pub"
    field tta_val_perc_verba               as decimal format ">>>9.99" decimals 2 initial 0 label "Percentual Verba de" column-label "Percentual Verba de"
    field tta_val_min_avdeb                as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor M­nimo" column-label "Valor M­nimo"
    field tta_log_calc_multa               as logical format "Sim/N’o" initial no label "Calcula Multa" column-label "Calcula Multa"
    field tta_num_dias_atraso_avdeb        as integer format "999" initial 0 label "Dias Atraso" column-label "Dias Atraso"
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D­gito Ag Bcia" column-label "Dig Ag"
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

def temp-table tt_fornec_financ_integr_d no-undo 
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo" 
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador" 
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco" 
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D­gito Cta Corrente" column-label "D­gito Cta Corrente" 
    field tta_cod_agenc_bcia               as character format "x(10)" label "Ag¼ncia Banc ria" column-label "Ag¼ncia Banc ria" 
    field tta_cod_digito_agenc_bcia        as character format "x(2)" label "D­gito Ag Bcia" column-label "Dig Ag" 
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco" 
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto" 
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ" 
    field tta_ind_tratam_vencto_sab        as character format "X(08)" initial "Prorroga" label "Vencimento Sabado" column-label "Vencto Sab" 
    field tta_ind_tratam_vencto_dom        as character format "X(08)" initial "Prorroga" label "Vencimento Domingo" column-label "Vencto Dom" 
    field tta_ind_tratam_vencto_fer        as character format "X(08)" initial "Prorroga" label "Vencimento Feriado" column-label "Vencto Feriado" 
    field tta_ind_pagto_juros_fornec_ap    as character format "X(08)" label "Juros" column-label "Juros" 
    field tta_ind_tip_fornecto             as character format "X(08)" label "Tipo Fornecimento" column-label "Fornecto" 
    field tta_ind_armaz_val_pagto          as character format "X(12)" initial "N’o Armazena" label "Armazena Valor Pagto" column-label "Armazena Valor Pagto" 
    field tta_log_fornec_serv_export       as logical format "Sim/N’o" initial no label "Fornec Exporta»’o" column-label "Fornec Export" 
    field tta_log_pagto_bloqdo             as logical format "Sim/N’o" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo" 
    field tta_log_retenc_impto             as logical format "Sim/N’o" initial no label "Ret²m Imposto" column-label "Ret²m Imposto" 
    field tta_dat_ult_impl_tit_ap          as date format "99/99/9999" initial ? label "Data Ultima Impl" column-label "Dt Ult Impl" 
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data ‚ltimo Pagto" column-label "Data ‚ltimo Pagto" 
    field tta_dat_impl_maior_tit_ap        as date format "99/99/9999" initial ? label "Dt Impl Maior Tit" column-label "Dt Maior Tit" 
    field tta_num_antecip_aber             as integer format ">>>>9" initial 0 label "Quant Antec  Aberto" column-label "Qtd Antec" 
    field tta_num_tit_ap_aber              as integer format ">>>>9" initial 0 label "Quant Tit  Aberto" column-label "Qtd Tit Abert" 
    field tta_val_tit_ap_maior_val         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit Impl" column-label "Valor Maior T­tulo" 
    field tta_val_tit_ap_maior_val_aber    as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Maior Tit  Aberto" column-label "Maior Vl Aberto" 
    field tta_val_sdo_antecip_aber         as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Antec Aberto" column-label "Sdo Antecip Aberto" 
    field tta_val_sdo_tit_ap_aber          as decimal format "->>>>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo Tit   Aberto" column-label "Sdo Tit Aberto" 
    field ttv_num_tip_operac               as integer format ">9" 
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1" 
    field tta_num_rendto_tribut            as integer format ">>9" initial 0 label "Rendto Tribut vel" column-label "Rendto Tribut vel" 
    field tta_log_vencto_dia_nao_util      as logical format "Sim/N’o" initial no label "Vencto Igual Dt Flx" column-label "Vencto Igual Dt Flx" 
    field tta_val_percent_bonif            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Bonifica»’o" column-label "Perc Bonifica»’o" 
    field tta_log_indic_rendto             as logical format "Sim/N’o" initial no label "Ind Rendimento" column-label "Ind Rendimento" 
    field tta_num_dias_compcao             as integer format ">>9" initial 0 label "Dias Compensa»’o" column-label "Dias Compensa»’o" 
    index tt_frncfnnc_forma_pagto          
          tta_cod_forma_pagto              ascending 
    index tt_frncfnnc_id                   is primary unique 
          tta_cod_empresa                  ascending 
          tta_cdn_fornecedor               ascending 
    index tt_frncfnnc_portador             
          tta_cod_portad_ext               ascending 
    .

def temp-table tt_pessoa_jurid_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur­dica" column-label "Pessoa Jur­dica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_jurid           as character format "x(20)" initial ? label "ID Estadual" column-label "ID Estadual"
    field tta_cod_id_munic_jurid           as character format "x(20)" initial ? label "ID Municipal" column-label "ID Municipal"
    field tta_cod_id_previd_social         as character format "x(20)" label "Id Previd¼ncia" column-label "Id Previd¼ncia"
    field tta_log_fins_lucrat              as logical format "Sim/N’o" initial yes label "Fins Lucrativos" column-label "Fins Lucrativos"
    field tta_num_pessoa_jurid_matriz      as integer format ">>>,>>>,>>9" initial 0 label "Matriz" column-label "Matriz"
    field tta_nom_endereco                 as character format "x(40)" label "Endere»o" column-label "Endere»o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota»’o Tabela" column-label "Anota»’o Tabela"
    field tta_ind_tip_pessoa_jurid         as character format "X(08)" label "Tipo Pessoa" column-label "Tipo Pessoa"
    field tta_ind_tip_capit_pessoa_jurid   as character format "X(13)" label "Tipo Capital" column-label "Tipo Capital"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N’o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_num_pessoa_jurid_cobr        as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur­dica Cobr" column-label "Pessoa Jur­dica Cobr"
    field tta_nom_ender_cobr               as character format "x(40)" label "Endere»o Cobran»a" column-label "Endere»o Cobran»a"
    field tta_nom_ender_compl_cobr         as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_cobr              as character format "x(20)" label "Bairro Cobran»a" column-label "Bairro Cobran»a"
    field tta_nom_cidad_cobr               as character format "x(32)" label "Cidade Cobran»a" column-label "Cidade Cobran»a"
    field tta_nom_condad_cobr              as character format "x(32)" label "Condado Cobran»a" column-label "Condado Cobran»a"
    field tta_cod_unid_federac_cobr        as character format "x(3)" label "Unidade Federa»’o" column-label "Unidade Federa»’o"
    field ttv_cod_pais_ext_cob             as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field ttv_cod_pais_cobr                as character format "x(3)" label "Pa­s Cobran»a" column-label "Pa­s Cobran»a"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran»a" column-label "CEP Cobran»a"
    field tta_cod_cx_post_cobr             as character format "x(20)" label "Caixa Postal Cobran»" column-label "Caixa Postal Cobran»"
    field tta_num_pessoa_jurid_pagto       as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jurid Pagto" column-label "Pessoa Jurid Pagto"
    field tta_nom_ender_pagto              as character format "x(40)" label "Endere»o Pagamento" column-label "Endere»o Pagamento"
    field tta_nom_ender_compl_pagto        as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro_pagto             as character format "x(20)" label "Bairro Pagamento" column-label "Bairro Pagamento"
    field tta_nom_cidad_pagto              as character format "x(32)" label "Cidade Pagamento" column-label "Cidade Pagamento"
    field tta_nom_condad_pagto             as character format "x(32)" label "Condado Pagamento" column-label "Condado Pagamento"
    field tta_cod_unid_federac_pagto       as character format "x(3)" label "Unidade Federa»’o" column-label "Unidade Federa»’o"
    field ttv_cod_pais_ext_pag             as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field ttv_cod_pais_pagto               as character format "x(3)" label "Pa­s Pagamento" column-label "Pa­s Pagamento"
    field tta_cod_cep_pagto                as character format "x(20)" label "CEP Pagamento" column-label "CEP Pagamento"
    field tta_cod_cx_post_pagto            as character format "x(20)" label "Caixa Postal Pagamen" column-label "Caixa Postal Pagamen"
    field ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
    field ttv_log_altera_razao_social      as logical format "Sim/N’o" initial no label "Altera Raz’o Social" column-label "Altera Raz’o Social"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    field tta_nom_ender_cobr_text          as character format "x(2000)" label "End Cobranca Compl" column-label "End Cobranca Compl"
    field tta_nom_ender_pagto_text         as character format "x(2000)" label "End Pagto Compl." column-label "End Pagto Compl."
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
          tta_cod_unid_federac             ascending
    .

def temp-table tt_pessoa_fisic_integr_e no-undo
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F­sica" column-label "Pessoa F­sica"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_id_estad_fisic           as character format "x(20)" initial ? label "ID Estadual F­sica" column-label "ID Estadual F­sica"
    field tta_cod_orgao_emis_id_estad      as character format "x(10)" label "…rg’o Emissor" column-label "…rg’o Emissor"
    field tta_cod_unid_federac_emis_estad  as character format "x(3)" label "Estado Emiss’o" column-label "UF Emis"
    field tta_nom_endereco                 as character format "x(40)" label "Endere»o" column-label "Endere»o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_cep                      as character format "x(20)" label "CEP" column-label "CEP"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_ramal                    as character format "x(7)" label "Ramal" column-label "Ramal"
    field tta_cod_fax                      as character format "x(20)" label "FAX" column-label "FAX"
    field tta_cod_ramal_fax                as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_telex                    as character format "x(7)" label "TELEX" column-label "TELEX"
    field tta_cod_modem                    as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem              as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail                   as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_dat_nasc_pessoa_fisic        as date format "99/99/9999" initial ? label "Nascimento" column-label "Data Nasc"
    field ttv_cod_pais_ext_nasc            as character format "x(20)" label "Pa­s Ext Nascimento" column-label "Pa­s Ext Nascimento"
    field ttv_cod_pais_nasc                as character format "x(3)" label "Pa­s Nascimento" column-label "Pa­s Nasc"
    field tta_cod_unid_federac_nasc        as character format "x(3)" label "Estado Nascimento" column-label "UF Nasc"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota»’o Tabela" column-label "Anota»’o Tabela"
    field tta_nom_mae_pessoa               as character format "x(40)" label "M’e Pessoa" column-label "M’e Pes"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N’o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field ttv_rec_fiador_renegoc           as recid format ">>>>>>9" initial ?
    field ttv_log_altera_razao_social      as logical format "Sim/N’o" initial no label "Altera Raz’o Social" column-label "Altera Raz’o Social"
    field tta_nom_nacion_pessoa_fisic      as character format "x(40)" label "Nacionalidade" column-label "Nacionalidade"
    field tta_nom_profis_pessoa_fisic      as character format "x(40)" label "Profiss’o" column-label "Profiss’o"
    field tta_ind_estado_civil_pessoa      as character format "X(10)" initial "Solteiro" label "Estado Civil" column-label "Estad Civ Pes"
    field tta_nom_home_page                as character format "x(40)" label "Home Page" column-label "Home Page"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
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
          tta_cod_unid_federac             ascending
    .

def temp-table tt_contato_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur­dica" column-label "Pessoa Jur­dica"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_nom_pessoa                   as character format "x(40)" label "Nome" column-label "Nome"
    field tta_cod_telef_contat             as character format "x(20)" label "Telefone" column-label "Telefone"
    field tta_cod_ramal_contat             as character format "x(07)" label "Ramal" column-label "Ramal"
    field tta_cod_fax_contat               as character format "x(20)" label "Fax" column-label "Fax"
    field tta_cod_ramal_fax_contat         as character format "x(07)" label "Ramal Fax" column-label "Ramal Fax"
    field tta_cod_modem_contat             as character format "x(20)" label "Modem" column-label "Modem"
    field tta_cod_ramal_modem_contat       as character format "x(07)" label "Ramal Modem" column-label "Ramal Modem"
    field tta_cod_e_mail_contat            as character format "x(40)" label "Internet E-Mail" column-label "Internet E-Mail"
    field tta_des_anot_tab                 as character format "x(2000)" label "Anota»’o Tabela" column-label "Anota»’o Tabela"
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F­sica" column-label "Pessoa F­sica"
    field tta_ind_priorid_envio_docto      as character format "x(10)" initial "e-Mail/Fax" label "Prioridade Envio" column-label "Prioridade Envio"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_log_ems_20_atlzdo            as logical format "Sim/N’o" initial no label "2.0 Atualizado" column-label "2.0 Atualizado"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_nom_endereco                 as character format "x(40)" label "Endere»o" column-label "Endere»o"
    field tta_nom_ender_compl              as character format "x(10)" label "Complemento" column-label "Complemento"
    field tta_nom_bairro                   as character format "x(20)" label "Bairro" column-label "Bairro"
    field tta_nom_cidade                   as character format "x(32)" label "Cidade" column-label "Cidade"
    field tta_nom_condado                  as character format "x(32)" label "Condado" column-label "Condado"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_cx_post                  as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_cep_cobr                 as character format "x(20)" label "CEP Cobran»a" column-label "CEP Cobran»a"
    field tta_nom_ender_text               as character format "x(2000)" label "Endereco Compl." column-label "Endereco Compl."
    index tt_contato_id                    is primary unique
          tta_num_pessoa_jurid             ascending
          tta_nom_abrev_contat             ascending
          tta_cdn_cliente                  ascending
          tta_cdn_fornecedor               ascending
    index tt_contato_pssfsca              
          tta_num_pessoa_fisic             ascending
    .

def temp-table tt_contat_clas_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato" 
    field tta_cod_clas_contat              as character format "x(8)" label "Classe Contato" column-label "Classe" 
    field ttv_num_tip_operac               as integer format ">9" 
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
    field ttv_num_tip_operac               as integer format ">9" 
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
    field ttv_num_tip_operac               as integer format ">9" 
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
    field ttv_num_tip_operac               as integer format ">9" 
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
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_hstrfrna_id                   is primary unique 
          tta_cod_empresa                  ascending 
          tta_cdn_fornecedor               ascending 
          tta_num_seq_histor_fornec        ascending. 

def temp-table tt_ender_entreg_integr_e no-undo
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur­dica" column-label "Pessoa Jur­dica"
    field tta_cod_ender_entreg             as character format "x(15)" label "Endere»o Entrega" column-label "Endere»o Entrega"
    field tta_nom_ender_entreg             as character format "x(40)" label "Nome Endere»o Entreg" column-label "Nome Endere»o Entreg"
    field tta_nom_bairro_entreg            as character format "x(20)" label "Bairro Entrega" column-label "Bairro Entrega"
    field tta_nom_cidad_entreg             as character format "x(32)" label "Cidade Entrega" column-label "Cidade Entrega"
    field tta_nom_condad_entreg            as character format "x(30)" label "Condado Entrega" column-label "Condado Entrega"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac_entreg      as character format "x(3)" label "Unidade Federa»’o" column-label "Unidade Federa»’o"
    field tta_cod_cep_entreg               as character format "x(20)" label "CEP Entrega" column-label "CEP Entrega"
    field tta_cod_cx_post_entreg           as character format "x(20)" label "Caixa Postal" column-label "Caixa Postal"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_nom_ender_entreg_text        as character format "x(2000)" label "End Entrega Compl." column-label "End Entrega Compl."
    index tt_ndrntrga_id                   is primary unique
          tta_num_pessoa_jurid             ascending
          tta_cod_ender_entreg             ascending
    index tt_ndrntrga_pais                
          tta_cod_pais_ext                 ascending
          tta_cod_unid_federac_entreg      ascending
    .

def temp-table tt_telef_integr no-undo 
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone" 
    field tta_ind_tip_telef_pessoa         as character format "X(08)" label "Tipo Telefone" column-label "Tipo Telefone" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_telef_id                      is primary 
          tta_cod_telef_sem_edic           ascending. 


def temp-table tt_telef_pessoa_integr no-undo 
    field tta_cod_telef_sem_edic           as character format "x(20)" label "Telefone" column-label "Telefone" 
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa" 
    field tta_des_telefone                 as character format "x(40)" label "Descri‡Æo Telefone" column-label "Descri‡Æo Telefone" 
    field tta_cod_telefone                 as character format "x(20)" label "Telefone" column-label "Telefone" 
    field ttv_num_tip_operac               as integer format ">9" 
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente" 
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor" 
    index tt_tlfpss_id                     is primary unique 
          tta_cod_telef_sem_edic           ascending 
          tta_num_pessoa                   ascending 
          tta_cdn_cliente                  ascending 
          tta_cdn_fornecedor               ascending 
    index tt_tlfpss_pessoa                 is unique 
          tta_num_pessoa                   ascending 
          tta_cod_telef_sem_edic           ascending. 

def temp-table tt_pj_ativid_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_cod_ativid_pessoa_jurid      as character format "x(8)" label "Atividade" column-label "Atividade" 
    field tta_log_ativid_pessoa_princ      as logical format "Sim/NÆo" initial no label "Atividade Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_pssjrdtv_atividade            
          tta_cod_ativid_pessoa_jurid      ascending 
    index tt_pssjrdtv_id                   is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_cod_ativid_pessoa_jurid      ascending. 

def temp-table tt_pj_ramo_negoc_integr no-undo 
    field tta_num_pessoa_jurid             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa Jur¡dica" column-label "Pessoa Jur¡dica" 
    field tta_cod_ramo_negoc               as character format "x(8)" label "Ramo Neg¢cio" column-label "Ramo Neg¢cio" 
    field tta_log_ramo_negoc_princ         as logical format "Sim/NÆo" initial no label "Ramo Negoc Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_pssjrdm_id                    is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_cod_ramo_negoc               ascending 
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
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_prtpssjr_id                   is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_dat_porte_pessoa_jurid       ascending 
    index tt_prtpssjr_indic_econ           
          tta_cod_indic_econ               ascending. 

def temp-table tt_idiom_pf_integr no-undo 
    field tta_num_pessoa_fisic             as integer format ">>>,>>>,>>9" initial 0 label "Pessoa F¡sica" column-label "Pessoa F¡sica" 
    field tta_cod_idioma                   as character format "x(8)" label "Idioma" column-label "Idioma" 
    field tta_log_idiom_princ              as logical format "Sim/NÆo" initial no label "Principal" column-label "Principal" 
    field ttv_num_tip_operac               as integer format ">9" 
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
    field ttv_num_tip_operac               as integer format ">9" 
    index tt_dmcntta_id                    is primary unique 
          tta_num_pessoa_jurid             ascending 
          tta_nom_abrev_contat             ascending 
          tta_cod_idioma                   ascending 
    index tt_dmcntta_idioma                
          tta_cod_idioma                   ascending. 

def temp-table tt_retorno_clien_fornec no-undo 
    field ttv_cod_parameters               as character format "x(256)" 
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero"   column-label "N£mero Mensagem" 
    field ttv_des_mensagem                 as character format "x(132)"  label "Mensagem" column-label "Mensagem" 
    field ttv_des_ajuda                    as character format "x(132)"  label "Ajuda"    column-label "Ajuda" 
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

/* ---------------------------------------------------------------------------------------------------------------------------- */ 
/* ---------------------------------------------------------------------------------------------------------------------------- */

def temp-table tt_tit_ap_alteracao_base_aux_3 no-undo
    field ttv_cod_usuar_corren             as character format "x(12)" label "Usu rio Corrente" column-label "Usu rio Corrente"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Data Transa‡Æo"
    field ttv_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_ult_pagto                as date format "99/99/9999" initial ? label "Data éltimo Pagto" column-label "Data éltimo Pagto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_log_pagto_bloqdo             as logical format "Sim/NÆo" initial no label "Bloqueia Pagamento" column-label "Pagto Bloqdo"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap¢lice Seguro" column-label "Apolice Seguro"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_ind_tip_espec_docto          as character format "X(17)" initial "Normal" label "Tipo Esp‚cie" column-label "Tipo Esp‚cie"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field ttv_ind_motiv_alter_val_tit_ap   as character format "X(09)" initial "Altera‡Æo" label "Motivo Altera‡Æo" column-label "Motivo Altera‡Æo"
    field ttv_wgh_lista                    as widget-handle extent 15 format ">>>>>>9"
    field ttv_log_gera_ocor_alter_valores  as logical format "Sim/NÆo" initial no
    field tta_cb4_tit_ap_bco_cobdor        as Character format "x(50)" label "Titulo Bco Cobrador" column-label "Titulo Bco Cobrador"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_histor_padr              as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo Hist¢rico PadrÆo"
    field tta_ind_sit_tit_ap               as character format "X(13)" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_tit_ap_bco_cobdor        as character format "x(20)" label "T¡tulo Banco Cobdor" column-label "T¡tulo Banco Cobdor"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_num_ord_invest               as integer format ">>>>,>>9" initial 0 label "Ordem Investimento" column-label "Ordem Investimento"
    field ttv_num_ped_compra               as integer format ">>>>>,>>9" initial 0 label "Ped Compra" column-label "Ped Compra"
    field tta_num_ord_compra               as integer format ">>>>>9,99" initial 0 label "Ordem Compra" column-label "Ordem Compra"
    field ttv_num_event_invest             as integer format ">,>>9" label "Evento Investimento" column-label "Evento Investimento"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/NÆo" initial no
    index tt_titap_id                     
          tta_cod_estab                    ascending
          tta_cdn_fornecedor               ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

def temp-table tt_tit_ap_alteracao_rateio no-undo
    field ttv_rec_tit_ap                   as recid format ">>>>>>9" initial ?
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field ttv_ind_tip_rat                  as character format "X(08)"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_aprop_ctbl_ap         as integer format "9999999999" initial 0 label "Id Aprop Ctbl AP" column-label "Id Aprop Ctbl AP"
    index tt_aprpctba_id                   is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_num_seq_refer                ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
          ttv_rec_tit_ap                   ascending.

def temp-table tt_log_erros_tit_ap_alteracao no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda_1              as character format "x(360)"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9".


/* -------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------- */

def temp-table tt_cancelamento_estorno_apb no-undo
    field ttv_ind_niv_operac_apb           as character format "X(10)"
    field ttv_ind_tip_operac_apb           as character format "X(12)"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Refer¼ncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico Padr’o" column-label "Hist½rico Padr’o"
    field ttv_des_histor                   as character format "x(40)" label "Cont²m" column-label "Hist½rico"
    field ttv_ind_tip_estorn               as character format "X(10)"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_estab_reembol            as character format "x(8)"
    field ttv_log_reaber_item              as logical format "Sim/N’o" initial yes
    field ttv_log_reembol                  as logical format "Sim/N’o" initial yes
    field ttv_log_estorn_impto_retid       as logical format "Sim/N’o" initial yes.

def temp-table tt_log_erros_estorn_cancel_apb no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Refer¼ncia"
    field tta_num_mensagem                 as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".

def temp-table tt_estorna_tit_imptos no-undo
    field ttv_cod_refer_imp                as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_estab_imp                as character format "x(3)" label "Estabelec. Impto." column-label "Estab. Imp."
    field ttv_cdn_fornecedor_imp           as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto_imp          as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field ttv_cod_ser_docto_imp            as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field ttv_cod_tit_ap_imp               as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field ttv_cod_parcela_imp              as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap_imp               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T­tulo" column-label "Valor T­tulo"
    field ttv_val_sdo_tit_ap_imp           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap_imp            as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_mensagem                 as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_estab_2                  as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field ttv_cod_ser_docto                as character format "x(3)" label "S²rie Docto" column-label "S²rie"
    field ttv_cod_tit_ap                   as character format "x(10)" label "T­tulo Ap" column-label "T­tulo Ap"
    field ttv_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap                   as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor T­tulo" column-label "Valor T­tulo"
    field ttv_val_sdo_tit_ap               as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field ttv_ind_trans_ap_abrev           as character format "X(04)" label "Transa»’o" column-label "Transa»’o"
    field ttv_cod_refer_2                  as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_num_order                    as integer format ">>>>,>>9" label "Ordem" column-label "Ordem"
    field ttv_val_tot_comprtdo             as decimal format "->>>,>>>,>>9.99" decimals 2
    index tt_idimpto                      
          ttv_cod_estab_imp                ascending
          ttv_cdn_fornecedor_imp           ascending
          ttv_cod_espec_docto_imp          ascending
          ttv_cod_ser_docto_imp            ascending
          ttv_cod_tit_ap_imp               ascending
          ttv_cod_parcela_imp              ascending
    index tt_idimpto_pgef                 
          ttv_cod_estab                    ascending
          ttv_cod_refer                    ascending
    index tt_idtit_refer                  
          ttv_cod_estab_2                  ascending
          ttv_cdn_fornecedor               ascending
          ttv_cod_espec_docto              ascending
          ttv_cod_ser_docto                ascending
          ttv_cod_tit_ap                   ascending
          ttv_cod_parcela                  ascending
          ttv_cod_refer_2                  ascending
    index tt_numsg                        
          ttv_num_mensagem                 ascending
    index tt_order                        
          ttv_num_order                    ascending.

/* ---------------------------------------------------------------------------------------------------------------------------- */
/* ---------------------------------------------------------------------------------------------------------------------------- */
def new shared temp-table tt_integr_apb_abat_antecip_vouc no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    index tt_integr_apb_abat_antecip_vouc  is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

def new shared temp-table tt_integr_apb_abat_prev_provis no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    index tt_integr_apb_abat_prev          is unique
          ttv_rec_antecip_pef_pend         ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending
    index tt_integr_apb_abat_prev_provis   is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab                    ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cdn_fornecedor               ascending
          tta_cod_tit_ap                   ascending
          tta_cod_parcela                  ascending.

def new shared temp-table tt_integr_apb_aprop_ctbl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field ttv_rec_integr_apb_impto_pend    as recid format ">>>>>>9"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg½cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_ccusto_ext               as character format "x(8)" label "Centro Custo Externo" column-label "CCusto Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg½cio Externa" column-label "Unid Neg½cio Externa"
    index tt_aprop_ctbl_pend_ap_integr_ant
          ttv_rec_antecip_pef_pend         ascending
          ttv_rec_integr_apb_impto_pend    ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending
    index tt_aprop_ctbl_pend_ap_integr_id 
          ttv_rec_integr_apb_item_lote     ascending
          ttv_rec_integr_apb_impto_pend    ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
          tta_cod_tip_fluxo_financ         ascending.

def new shared temp-table tt_integr_apb_aprop_relacto no-undo
    field ttv_rec_integr_apb_relacto_pend  as recid format ">>>>>>9"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_ind_tip_aprop_ctbl           as character format "x(30)" initial "Saldo" label "Tipo Aprop Ctbl" column-label "Tipo Aprop Ctbl"
    index tt_integr_apb_aprop_relacto      is primary unique
          ttv_rec_integr_apb_relacto_pend  ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending.

def new shared temp-table tt_integr_apb_impto_impl_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field ttv_rec_antecip_pef_pend         as recid format ">>>>>>9"
    field tta_cod_pais                     as character format "x(3)" label "Pa­s" column-label "Pa­s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa»’o" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_ind_clas_impto               as character format "X(14)" initial "Retido" label "Classe Imposto" column-label "Classe Imposto"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_deduc_inss               as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu»’o Inss" column-label "Dedu»’o Inss"
    field tta_val_deduc_depend             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Dedu»’o Dependentes" column-label "Dedu»’o Dependentes"
    field tta_val_deduc_pensao             as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Deducao Pens’o" column-label "Deducao Pens’o"
    field tta_val_outras_deduc_impto       as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Outras Dedu»„es" column-label "Outras Dedu»„es"
    field tta_val_base_liq_impto           as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Base L­quida Imposto" column-label "Base L­quida Imposto"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al­quota" column-label "Aliq"
    field tta_val_impto_ja_recolhid        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Imposto J  Recolhido" column-label "Imposto J  Recolhido"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_impto_indic_econ_impto   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Finalid Impto" column-label "Val Finalid Impto"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_cdn_fornec_favorec           as Integer format ">>>,>>>,>>9" initial 0 label "Fornec Favorecido" column-label "Fornec Favorecido"
    field tta_val_deduc_faixa_impto        as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Deducao" column-label "Valor Dedu»’o"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field tta_cod_pais_ext                 as character format "x(20)" label "Pa­s Externo" column-label "Pa­s Externo"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field ttv_cod_tip_fluxo_financ_ext     as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    index tt_impto_impl_pend_ap_integr     is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
    index tt_impto_impl_pend_ap_integr_ant is unique
          ttv_rec_antecip_pef_pend         ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending.

def new shared temp-table tt_integr_apb_item_lote_impl no-undo
    field ttv_rec_integr_apb_lote_impl     as recid format ">>>>>>9"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  Emiss’o" column-label "Dt Emiss’o"
    field tta_dat_vencto_tit_ap            as date format "99/99/9999" initial today label "Data Vencimento" column-label "Dt Vencto"
    field tta_dat_prev_pagto               as date format "99/99/9999" initial today label "Data Prevista Pgto" column-label "Dt Prev Pagto"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_tit_ap                   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor T­tulo" column-label "Valor T­tulo"
    field tta_val_desconto                 as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Valor Desconto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_num_dias_atraso              as integer format ">9" initial 0 label "Dias Atraso" column-label "Dias Atr"
    field tta_val_juros_dia_atraso         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juro" column-label "Vl Juro"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_apol_seguro              as character format "x(12)" label "Ap½lice Seguro" column-label "Apolice Seguro"
    field tta_cod_seguradora               as character format "x(8)" label "Seguradora" column-label "Seguradora"
    field tta_cod_arrendador               as character format "x(6)" label "Arrendador" column-label "Arrendador"
    field tta_cod_contrat_leas             as character format "x(12)" label "Contrato Leasing" column-label "Contr Leas"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_num_id_tit_ap                as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap          as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_num_id_movto_cta_corren      as integer format "9999999999" initial 0 label "ID Movto Conta" column-label "ID Movto Conta"
    field ttv_qtd_parc_tit_ap              as decimal format ">>9" initial 1 label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_num_dias                     as integer format ">>>>,>>9" label "Nœmero de Dias" column-label "Nœmero de Dias"
    field ttv_ind_vencto_previs            as character format "X(4)" initial "M¼s" label "C lculo Vencimento" column-label "C lculo Vencimento"
    field ttv_log_gerad                    as logical format "Sim/N’o" initial no
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    index tt_item_lote_impl_ap_integr_id   is primary unique
          ttv_rec_integr_apb_lote_impl     ascending
          tta_num_seq_refer                ascending.

def new shared temp-table tt_integr_apb_lote_impl no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_ind_origin_tit_ap            as character format "X(03)" initial "APB" label "Origem" column-label "Origem"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_val_tot_lote_impl_tit_ap     as decimal format ">>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total  Movimento" column-label "Total Movto"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_empresa_ext              as character format "x(3)" label "C½digo Empresa Ext" column-label "C½d Emp Ext"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    index tt_lote_impl_tit_ap_integr_id    is primary unique
          tta_cod_estab                    ascending
          tta_cod_refer                    ascending
          tta_cod_estab_ext                ascending.

def new shared temp-table tt_integr_apb_relacto_pend no-undo
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    field tta_cod_estab_tit_ap_pai         as character format "x(3)" label "Estab Tit Pai" column-label "Estab Tit Pai"
    field tta_num_id_tit_ap_pai            as integer format "9999999999" initial 0 label "Token" column-label "Token"
    field tta_val_relacto_tit_ap           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_ind_motiv_acerto_val         as character format "X(12)" initial "Altera»’o" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    index tt_integr_apb_relacto_pend       is primary unique
          ttv_rec_integr_apb_item_lote     ascending
          tta_cod_estab_tit_ap_pai         ascending
          tta_num_id_tit_ap_pai            ascending.

def new shared temp-table tt_log_erros_atualiz no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Seq"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_ind_tip_relacto              as character format "X(15)" label "Tipo Relacionamento" column-label "Tipo Relac"
    field ttv_num_relacto                  as integer format ">>>>,>>9" label "Relacionamento" column-label "Relacionamento".

/* ------------------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------------------- */
def temp-table tt_integr_apb_pagto no-undo
    field tta_cod_empresa                  as character
    field tta_cod_estab_refer              as character
    field tta_cod_refer                    as character
    field tta_cod_estab_bord               as character
    field tta_dat_transacao                as date initial today
    field tta_cod_indic_econ               as character
    field tta_val_tot_lote_pagto_efetd     as decimal initial 0
    field tta_val_tot_lote_pagto_infor     as decimal initial 0
    field tta_cdn_fornecedor               as Integer initial 0
    field tta_cdn_cliente                  as Integer initial 0
    field tta_cod_usuar_pagto              as character
    field tta_log_enctro_cta               as logical initial no
    field tta_val_tot_liquidac_tit_acr     as decimal initial 0
    field tta_num_bord_ap                  as integer initial 0
    field tta_cod_msg_inic                 as character
    field tta_cod_msg_fim                  as character
    field tta_log_bord_ap_escrit           as logical initial no
    field tta_log_bord_ap_escrit_envdo     as logical initial no
    field tta_ind_tip_bord_ap              as character
    field tta_cod_finalid_econ             as character
    field tta_cod_cart_bcia                as character
    field tta_cod_livre_1                  as character
    field tta_cod_livre_2                  as character
    field tta_dat_livre_1                  as date initial ?
    field tta_dat_livre_2                  as date initial ?
    field tta_log_livre_1                  as logical initial no
    field tta_log_livre_2                  as logical initial no
    field tta_num_livre_1                  as integer initial 0
    field tta_num_livre_2                  as integer initial 0
    field tta_val_livre_1                  as decimal initial 0
    field tta_val_livre_2                  as decimal initial 0
    field ttv_log_atualiz_refer            as logical initial no
    field ttv_log_gera_lote_parcial        as logical initial no
    field ttv_ind_tip_atualiz              as character
    field tta_cod_portador                 as character
    field ttv_rec_table_parent             as recid
    field tta_cod_estab_ext                as character
    field tta_cod_portad_ext               as character
    field tta_cod_modalid_ext              as character
    field tta_cod_finalid_econ_ext         as character
    field ttv_log_vinc_impto_auto          as logical initial no
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

def temp-table tt_integr_apb_bord_lote_pagto no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_cod_estab_bord_refer         as character format "x(8)"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_refer_antecip_pef        as character format "x(10)" label "Ref Antec PEF Pend" column-label "Ref Antec PEF Pend"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota»’o" column-label "Data Cota»’o"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota»’o" column-label "Cota»’o"
    field tta_val_pagto                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Pagamento" column-label "Valor Pagto"
    field tta_val_multa_tit_ap             as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Multa" column-label "Valor Multa"
    field tta_val_juros                    as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Juros" column-label "Valor Juros"
    field tta_val_cm_tit_ap                as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Val Corre»’o Monet" column-label "Val Corr Monet"
    field tta_val_desc_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Desconto" column-label "Vl Desconto"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_forma_pagto              as character format "x(3)" label "Forma Pagamento" column-label "F Pagto"
    field tta_cod_forma_pagto_altern       as character format "x(3)" label "Forma Pagamento" column-label "F Pagto Alt"
    field tta_val_pagto_inic               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagto Inic" column-label "Vl Pagto Inic"
    field tta_val_desc_tit_ap_inic         as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc Inic" column-label "Vl Desc Inic"
    field tta_val_pagto_orig_inic          as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Pagto Orig Inic" column-label "Vl Pagto Orig Inic"
    field tta_val_desc_tit_ap_orig_inic    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Orig Descto" column-label "Vl orig Descto"
    field tta_cod_docto_bco_pagto          as character format "x(20)" label "Tit Bco Pagto" column-label "Tit Bco Pagto"
    field tta_ind_sit_item_bord_ap         as character format "X(9)" label "Situa»’o" column-label "Situa»’o"
    field tta_log_critic_atualiz_ok        as logical format "Sim/N’o" initial no label "Cr­tica OK" column-label "Cr­tica OK"
    field tta_cod_estab_cheq               as character format "x(3)" label "Estabelec Cheque" column-label "Estabelec Cheque"
    field tta_num_seq_item_cheq            as integer format ">>>9" initial 0 label "Sequ¼ncia Item Cheq" column-label "Seq"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_num_talon_cheq               as integer format ">>>,>>>,>>9" initial 0 label "Talon rio Cheques" column-label "Talon rio Cheques"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_ind_favorec_cheq             as character format "X(15)" initial "Portador" label "Favorecido" column-label "Favorecido"
    field tta_nom_favorec_cheq             as character format "x(40)" label "Nome Favorecido" column-label "Nome Favorecido"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_val_variac_cambial           as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Varic Cambial" column-label "Variac Cambial"
    field tta_ind_sit_item_lote_bxa_ap     as character format "X(9)" initial "Gerado" label "Situa»’o" column-label "Situa»’o"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/N’o" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/N’o" initial no label "Livre 2" column-label "Livre 2"
    field ttv_ind_forma_pagto              as character format "X(18)" initial "Assume do T­tulo"
    field ttv_rec_table_child              as recid format ">>>>>>9"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
          ttv_rec_table_child              ascending
    .
def temp-table tt_integr_apb_abat_antecip no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    .


def temp-table tt_integr_apb_abat_prev no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cdn_fornecedor               as Integer format ">>>,>>>,>>9" initial 0 label "Fornecedor" column-label "Fornecedor"
    field tta_cod_tit_ap                   as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abat_tit_ap              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatimento" column-label "Vl Abatimento"
    field ttv_rec_integr_apb_item_lote     as recid format ">>>>>>9"
    .

def temp-table tt_integr_cambio_ems5 no-undo
    field ttv_rec_table_child              as recid format ">>>>>>9"
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_cod_contrat_cambio           as character format "x(15)"
    field ttv_dat_contrat_cambio_import    as date format "99/99/9999"
    field ttv_num_contrat_id_cambio        as integer format "999999999"
    field ttv_cod_estab_contrat_cambio     as character format "x(3)"
    field ttv_cod_refer_contrat_cambio     as character format "x(10)"
    field ttv_dat_refer_contrat_cambio     as date format "99/99/9999"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending
          ttv_rec_table_child              ascending.

def temp-table tt_1099 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_val_1099                     as decimal format "->>,>>>,>>>,>>9.99" decimals 2
    field tta_cod_tax_ident_number         as character format "x(15)" label "Tax Id Number" column-label "Tax Id Number"
    field tta_ind_tip_trans_1099           as character format "X(50)" initial "Rents" label "Tipo Transacao 1099" column-label "Tipo Transacao 1099"
    index tt_rec_index                     is primary unique
          ttv_rec_table_parent             ascending.

def temp-table tt_integr_apb_pagto_aux_1 no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field tta_log_bxa_estab_tit_ap         as logical format "Sim/N’o" initial no label "Baixa Estabelec" column-label "Baixa Estabelec"
    field tta_log_bord_darf                as logical format "Sim/N’o" initial no label "Border  DARF" column-label "Border  DARF"
    field tta_log_bord_gps                 as logical format "Sim/N’o" initial no label "Bordero GPS" column-label "Bordero GPS".

def temp-table tt_integr_apb_bord_lote_pg_a no-undo
    field ttv_rec_table_parent             as recid format ">>>>>>9"
    field ttv_log_atualiz_tit_impto_vinc   as logical format "Sim/N’o" initial no.

/* --------------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------------- */
def temp-table tt_alter_tit_acr_base_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field ttv_cod_motiv_movto_tit_acr_imp  as character format "x(8)" label "Motivo Impl" column-label "Motivo Movimento"
    field tta_val_sdo_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Saldo T¡tulo" column-label "Saldo T¡tulo"
    field ttv_cod_motiv_movto_tit_acr_alt  as character format "x(8)" label "Motivo Alter" column-label "Motivo Movimento"
    field ttv_ind_motiv_acerto_val         as character format "X(12)" label "Motivo Acerto Valor" column-label "Motivo Acerto Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_val_despes_bcia              as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desp Banc" column-label "Vl Desp Banc"
    field tta_cod_agenc_cobr_bcia          as character format "x(10)" label "Agˆncia Cobran‡a" column-label "Agˆncia Cobr"
    field tta_cod_tit_acr_bco              as character format "x(20)" label "Num T¡tulo Banco" column-label "Num T¡tulo Banco"
    field tta_dat_emis_docto               as date format "99/99/9999" initial today label "Data  EmissÆo" column-label "Dt EmissÆo"
    field tta_dat_vencto_tit_acr           as date format "99/99/9999" initial ? label "Vencimento" column-label "Vencimento"
    field tta_dat_prev_liquidac            as date format "99/99/9999" initial ? label "Prev Liquida‡Æo" column-label "Prev Liquida‡Æo"
    field tta_dat_fluxo_tit_acr            as date format "99/99/9999" initial ? label "Fluxo" column-label "Fluxo"
    field tta_ind_sit_tit_acr              as character format "X(13)" initial "Normal" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field tta_cod_cond_cobr                as character format "x(8)" label "Condi‡Æo Cobran‡a" column-label "Cond Cobran‡a"
    field tta_log_tip_cr_perda_dedut_tit   as logical format "Sim/NÆo" initial no label "Credito com Garantia" column-label "Cred Garant"
    field tta_dat_abat_tit_acr             as date format "99/99/9999" initial ? label "Abat" column-label "Abat"
    field tta_val_perc_abat_acr            as decimal format ">>9.9999" decimals 4 initial 0 label "Perc Abatimento" column-label "Abatimento"
    field tta_val_abat_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abatimento" column-label "Vl Abatimento"
    field tta_dat_desconto                 as date format "99/99/9999" initial ? label "Data Desconto" column-label "Dt Descto"
    field tta_val_perc_desc                as decimal format ">9.9999" decimals 4 initial 0 label "Percentual Desconto" column-label "Perc Descto"
    field tta_val_desc_tit_acr             as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Desc" column-label "Vl Desc"
    field tta_qtd_dias_carenc_juros_acr    as decimal format ">>9" initial 0 label "Dias Carenc Juros" column-label "Dias Juros"
    field tta_val_perc_juros_dia_atraso    as decimal format ">9.999999" decimals 6 initial 00.00 label "Perc Jur Dia Atraso" column-label "Perc Dia"
    field tta_qtd_dias_carenc_multa_acr    as decimal format ">>9" initial 0 label "Dias Carenc Multa" column-label "Dias Carenc Multa"
    field tta_val_perc_multa_atraso        as decimal format ">9.99" decimals 2 initial 00.00 label "Perc Multa Atraso" column-label "Multa Atr"
    field ttv_cod_portador_mov             as character format "x(5)" label "Portador Movto" column-label "Portador Movto"
    field tta_ind_tip_cobr_acr             as character format "X(10)" initial "Normal" label "Tipo Cobran‡a" column-label "Tipo Cobran‡a"
    field tta_ind_ender_cobr               as character format "X(15)" initial "Cliente" label "Endere‡o Cobran‡a" column-label "Endere‡o Cobran‡a"
    field tta_nom_abrev_contat             as character format "x(15)" label "Abreviado Contato" column-label "Abreviado Contato"
    field tta_val_liq_tit_acr              as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl L¡quido" column-label "Vl L¡quido"
    field tta_cod_instruc_bcia_1_movto     as character format "x(4)" label "Instr Banc ria 1" column-label "Instr Banc 1"
    field tta_cod_instruc_bcia_2_movto     as character format "x(4)" label "Instr Banc ria 2" column-label "Instr Banc 2"
    field tta_log_tit_acr_destndo          as logical format "Sim/NÆo" initial no label "Destinado" column-label "Destinado"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field ttv_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_des_obs_cobr                 as character format "x(40)" label "Obs Cobran‡a" column-label "Obs Cobran‡a"
    field ttv_wgh_lista                    as widget-handle extent 26 format ">>>>>>9"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequ¼ncia" column-label "Sequ¼ncia"
    field ttv_cod_estab_planilha           as character format "x(3)"
    field ttv_num_planilha_vendor          as integer format ">>>>,>>>,>>9" label "Planilha Vendor" column-label "Planilha Vendor"
    field ttv_cod_cond_pagto_vendor        as character format "x(3)" label "Condi»’o Pagto" column-label "Condi»’o Pagto"
    field ttv_val_cotac_tax_vendor_clien   as decimal format ">>9.9999999999" decimals 10 label "Taxa Vendor Cliente" column-label "Taxa Vendor Cliente"
    field ttv_dat_base_fechto_vendor       as date format "99/99/9999" label "Data Base" column-label "Data Base"
    field ttv_qti_dias_carenc_fechto       as Integer format "->>9" label "Dias Car¼ncia" column-label "Dias Car¼ncia"
    field ttv_log_assume_tax_bco           as logical format "Sim/N’o" initial no label "Assume Taxa Banco" column-label "Assume Taxa Banco"
    field ttv_log_vendor                   as logical format "Sim/N’o" initial no
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_dat_transacao                ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_rateio no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_ind_tip_rat_tit_acr          as character format "X(12)" label "Tipo Rateio" column-label "Tipo Rateio"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_num_seq_aprop_ctbl_pend_acr  as integer format ">>>9" initial 0 label "Seq Aprop Pend" column-label "Seq Apro"
    field tta_val_aprop_ctbl               as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Aprop Ctbl" column-label "Vl Aprop Ctbl"
    field tta_log_impto_val_agreg          as logical format "Sim/NÆo" initial no label "Impto Val Agreg" column-label "Imp Vl Agr"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.

def temp-table tt_alter_tit_acr_ped_vda no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cod_ped_vda                  as character format "x(12)" label "Pedido Venda" column-label "Pedido Venda"
    field tta_cod_ped_vda_repres           as character format "x(12)" label "Pedido Repres" column-label "Pedido Repres"
    field tta_val_perc_particip_ped_vda    as decimal format ">>9.99" decimals 2 initial 0 label "Particip Ped Vda" column-label "Particip"
    field tta_des_ped_vda                  as character format "x(40)" label "Pedido Venda" column-label "Pedido Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_ped_vda                  ascending.

def temp-table tt_alter_tit_acr_comis no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_cdn_repres                   as Integer format ">>>,>>9" initial 0 label "Representante" column-label "Representante"
    field tta_val_perc_comis_repres        as decimal format ">>9.99" decimals 2 initial 0 label "% ComissÆo" column-label "% ComissÆo"
    field tta_val_perc_comis_repres_emis   as decimal format ">>9.99" decimals 2 initial 0 label "% Comis EmissÆo" column-label "% Comis EmissÆo"
    field tta_val_perc_comis_abat          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Abatimento" column-label "% Comis Abatimento"
    field tta_val_perc_comis_desc          as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Desconto" column-label "% Comis Desconto"
    field tta_val_perc_comis_juros         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Juros" column-label "% Comis Juros"
    field tta_val_perc_comis_multa         as decimal format ">>9.99" decimals 2 initial 0 label "% Comis Multa" column-label "% Comis Multa"
    field tta_val_perc_comis_acerto_val    as decimal format ">>9.99" decimals 2 initial 0 label "% Comis AVA" column-label "% Comis AVA"
    field tta_log_comis_repres_proporc     as logical format "Sim/NÆo" initial no label "Comis Proporcional" column-label "Comis Propor"
    field tta_ind_tip_comis                as character format "X(15)" initial "Valor Bruto" label "Tipo ComissÆo" column-label "Tipo ComissÆo"
    index tt_id                            is primary unique
          tta_cod_empresa                  ascending
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cdn_repres                   ascending
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending.

def temp-table tt_alter_tit_acr_cheq no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data EmissÆo" column-label "Dt Emiss"
    field tta_dat_prev_apres_cheq_acr      as date format "99/99/9999" initial ? label "PrevisÆo Apresent" column-label "PrevisÆo Apresent"
    field tta_dat_prev_cr_cheq_acr         as date format "99/99/9999" initial ? label "PrevisÆo Cr‚dito" column-label "PrevisÆo Cr‚dito"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_log_cheq_terc                as logical format "Sim/NÆo" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field tta_ind_dest_cheq_acr            as character format "X(15)" initial "Dep¢sito" label "Destino Cheque" column-label "Destino Cheque"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren_bco           ascending
          tta_num_cheque                   ascending.

def temp-table tt_alter_tit_acr_iva no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_imposto                  as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Imposto" column-label "Vl Imposto"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_seq                      ascending.

def temp-table tt_alter_tit_acr_impto_retid_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_num_impto_refer_tit_acr      as integer format ">>>>>9" initial 0 label "Impto Refer" column-label "Impto Refer"
    field ttv_num_tip_operac               as integer format ">9"
    field tta_val_aliq_impto               as decimal format ">9.99" decimals 2 initial 0.00 label "Al¡quota" column-label "Aliq"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_pais                     ascending
          tta_cod_unid_federac             ascending
          tta_cod_imposto                  ascending
          tta_cod_classif_impto            ascending
          tta_num_impto_refer_tit_acr      ascending    .

def temp-table tt_alter_tit_acr_cobr_espec_2 no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_seq_tit_acr              as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Sequˆncia"
    field tta_num_id_cobr_especial_acr     as integer format "99999999" initial 0 label "Token Cobr Especial" column-label "Token Cobr Especial"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_cartcred                 as character format "x(20)" label "C¢digo CartÆo" column-label "C¢digo CartÆo"
    field tta_cod_autoriz_cartao_cr        as character format "x(6)" label "C¢d Pr‚-Autoriza‡Æo" column-label "C¢d Pr‚-Autoriza‡Æo"
    field tta_cod_mes_ano_valid_cartao     as character format "XX/XXXX" label "Validade CartÆo" column-label "Validade CartÆo"
    field tta_dat_compra_cartao_cr         as date format "99/99/9999" initial ? label "Data Compra" column-label "Data Compra"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren_bco           as character format "x(20)" label "Conta Corrente Banco" column-label "Conta Corrente Banco"
    field tta_cod_digito_cta_corren        as character format "x(2)" label "D¡gito Cta Corrente" column-label "D¡gito Cta Corrente"
    field tta_num_ddd_localid_conces       as integer format "999" initial 0 label "DDD" column-label "DDD"
    field tta_num_prefix_localid_conces    as integer format ">>>9" initial 0 label "Prefixo" column-label "Prefixo"
    field tta_num_milhar_localid_conces    as integer format "9999" initial 0 label "Milhar" column-label "Milhar"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field ttv_log_alter_tip_cobr_acr       as logical format "Sim/NÆo" initial no label "Alter Tip Cobr" column-label "Alter Tip Cobr"
    field tta_ind_sit_tit_cobr_especial    as character format "X(15)" label "Situa‡Æo T¡tulo" column-label "Situa‡Æo T¡tulo"
    field ttv_cod_comprov_vda              as character format "x(12)" label "Comprovante Venda" column-label "Comprovante Venda"
    field ttv_num_parc_cartcred            as integer format ">9" label "Quantidade Parcelas" column-label "Quantidade Parcelas"
    field ttv_val_tot_sdo_tit_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Val Total Parcelas" column-label "Val Total Parcelas"
    field tta_cod_autoriz_bco_emissor      as character format "x(6)" label "Autorizacao Venda" column-label "Autorizacao Venda"
    field tta_cod_lote_origin              as character format "x(7)" label "Lote Orig Venda" column-label "Lote Orig Venda"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_seq_tit_acr              ascending.

def temp-table tt_alter_tit_acr_rat_desp_rec no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_val_perc_rat_ctbz            as decimal format ">>9.99" decimals 2 initial 0 label "Perc Rateio" column-label "% Rat"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria‡Æo" column-label "Tipo Apropria‡Æo"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_aprop_despes_recta    as integer format "9999999999" initial 0 label "Id Apropria‡Æo" column-label "Id Apropria‡Æo"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    index tt_aprpdspa_id                   is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_cod_plano_cta_ctbl           ascending
          tta_cod_cta_ctbl                 ascending
          tta_cod_unid_negoc               ascending
          tta_cod_tip_fluxo_financ         ascending
          tta_num_id_aprop_despes_recta    ascending
    index tt_aprpdspa_token                is unique
          tta_cod_estab                    ascending
          tta_num_id_aprop_despes_recta    ascending.

def temp-table tt_log_erros_alter_tit_acr no-undo
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_cod_tip_msg_dwb              as character format "x(12)" label "Tipo Mensagem" column-label "Tipo Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_wgh_focus                    as widget-handle format ">>>>>>9"
    index tt_relac_tit_acr                
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          ttv_num_mensagem                 ascending.

/* --------------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------------- */
def temp-table tt_input_estorno no-undo
    field ttv_cod_label                    as character format "x(8)" label "Label" column-label "Label"
    field ttv_des_conteudo                 as character format "x(40)" label "Texto" column-label "Texto"
    field ttv_num_seq                      as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    index tt_primario                      is primary
          ttv_num_seq                      ascending.

def temp-table tt_integr_acr_estorn_cancel no-undo
    field ttv_ind_niv_operac_acr           as character format "X(12)" label "N­vel Opera»’o" column-label "N­vel Opera»’o"
    field ttv_ind_tip_operac_acr           as character format "X(15)" label "Tipo Opera»’o" column-label "Tipo Opera»’o"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_cod_refer                    as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_des_text_histor              as character format "x(2000)" label "Hist½rico" column-label "Hist½rico"
    field ttv_cod_estab_reembol            as character format "x(8)"
    field ttv_cod_portad_reembol           as character format "x(5)"
    field ttv_cod_cart_bcia_reembol        as character format "x(3)"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_id_movto_tit_acr         ascending.

/* --------------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------------- */
def temp-table tt_integr_acr_liquidac_lote no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_usuario                  as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field ttv_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_dat_transacao                as date format "99/99/9999" initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_dat_gerac_lote_liquidac      as date format "99/99/9999" initial ? label "Data Gera‡Æo" column-label "Data Gera‡Æo"
    field tta_val_tot_lote_liquidac_infor  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Informado" column-label "Total Informado"
    field tta_val_tot_lote_liquidac_efetd  as decimal format "->>,>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Movimento" column-label "Vl Tot Movto"
    field tta_val_tot_despes_bcia          as decimal format ">>>>,>>>,>>9.99" decimals 2 initial 0 label "Total Desp Bcia" column-label "Desp Bcia"
    field tta_ind_tip_liquidac_acr         as character format "X(15)" initial "Lote" label "Tipo Liquidacao" column-label "Tipo Liquidacao"
    field tta_ind_sit_lote_liquidac_acr    as character format "X(15)" initial "Em Digita‡Æo" label "Situa‡Æo" column-label "Situa‡Æo"
    field tta_nom_arq_movimen_bcia         as character format "x(30)" label "Nom Arq Bancaria" column-label "Nom Arq Bancaria"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_log_enctro_cta               as logical format "Sim/NÆo" initial no label "Encontro de Contas" column-label "Encontro de Contas"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_log_atualiz_refer            as logical format "Sim/NÆo" initial no
    field ttv_log_gera_lote_parcial        as logical format "Sim/NÆo" initial no
    index tt_itlqdccr_id                   is primary unique
          tta_cod_estab_refer              ascending
          tta_cod_refer                    ascending
    .

def temp-table tt_integr_acr_liq_item_lote no-undo
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_cdn_cliente                  as Integer format ">>>,>>>,>>9" initial 0 label "Cliente" column-label "Cliente"
    field tta_cod_portador                 as character format "x(5)" label "Portador" column-label "Portador"
    field tta_cod_portad_ext               as character format "x(8)" label "Portador Externo" column-label "Portador Externo"
    field tta_cod_cart_bcia                as character format "x(3)" label "Carteira" column-label "Carteira"
    field tta_cod_modalid_ext              as character format "x(8)" label "Modalidade Externa" column-label "Modalidade Externa"
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_cr_liquidac_tit_acr      as date format "99/99/9999" initial ? label "Data Cr‚dito" column-label "Data Cr‚dito"
    field tta_dat_cr_liquidac_calc         as date format "99/99/9999" initial ? label "Cred Calculada" column-label "Cred Calculada"
    field tta_dat_liquidac_tit_acr         as date format "99/99/9999" initial ? label "Liquida‡Æo" column-label "Liquida‡Æo"
    field tta_cod_autoriz_bco              as character format "x(8)" label "Autoriza‡Æo Bco" column-label "Autorizacao Bco"
    field tta_val_tit_acr                  as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor" column-label "Valor"
    field tta_val_liquidac_tit_acr         as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Liquida‡Æo" column-label "Vl Liquida‡Æo"
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
    field tta_log_gera_antecip             as logical format "Sim/NÆo" initial no label "Gera Antecipacao" column-label "Gera Antecipacao"
    field tta_des_text_histor              as character format "x(2000)" label "Hist¢rico" column-label "Hist¢rico"
    field tta_ind_sit_item_lote_liquidac   as character format "X(09)" initial "Gerado" label "Situa‡Æo Item Lote" column-label "Situa‡Æo Item Lote"
    field tta_log_gera_avdeb               as logical format "Sim/NÆo" initial no label "Gera Aviso D‚bito" column-label "Gera Aviso D‚bito"
    field tta_cod_indic_econ_avdeb         as character format "x(8)" label "Moeda Aviso D‚bito" column-label "Moeda Aviso D‚bito"
    field tta_cod_portad_avdeb             as character format "x(5)" label "Portador AD" column-label "Portador AD"
    field tta_cod_cart_bcia_avdeb          as character format "x(3)" label "Carteira AD" column-label "Carteira AD"
    field tta_dat_vencto_avdeb             as date format "99/99/9999" initial ? label "Vencto AD" column-label "Vencto AD"
    field tta_val_perc_juros_avdeb         as decimal format ">>9.99" decimals 2 initial 0 label "Juros Aviso Debito" column-label "Juros ADebito"
    field tta_val_avdeb                    as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Aviso D‚bito" column-label "Aviso D‚bito"
    field tta_log_movto_comis_estordo      as logical format "Sim/NÆo" initial no label "Estorna ComissÆo" column-label "Estorna ComissÆo"
    field tta_ind_tip_item_liquidac_acr    as character format "X(09)" label "Tipo Item" column-label "Tipo Item"
    field ttv_rec_lote_liquidac_acr        as recid format ">>>>>>9" initial ?
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_ind_tip_calc_juros           as character format "x(10)" initial "Simples" label "Tipo C lculo Juros" column-label "Tipo C lculo Juros"
    index tt_rec_index                    
          ttv_rec_lote_liquidac_acr        ascending
    .

def temp-table tt_integr_acr_abat_antecip no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_antecip_tit_abat   as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abtdo" column-label "Vl Abtdo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_acr_abat_prev no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_abtdo_prev_tit_abat      as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Abat" column-label "Vl Abat"
    field tta_log_zero_sdo_prev            as logical format "Sim/NÆo" initial no label "Zera Saldo" column-label "Zera Saldo"
    index tt_id                            is primary unique
          ttv_rec_item_lote_impl_tit_acr   ascending
          tta_cod_estab                    ascending
          tta_cod_estab_ext                ascending
          tta_cod_espec_docto              ascending
          tta_cod_ser_docto                ascending
          tta_cod_tit_acr                  ascending
          tta_cod_parcela                  ascending
    .

def temp-table tt_integr_acr_cheq no-undo
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_dat_emis_cheq                as date format "99/99/9999" initial ? label "Data EmissÆo" column-label "Dt Emiss"
    field tta_dat_depos_cheq_acr           as date format "99/99/9999" initial ? label "Dep¢sito" column-label "Dep¢sito"
    field tta_dat_prev_depos_cheq_acr      as date format "99/99/9999" initial ? label "PrevisÆo Dep¢sito" column-label "PrevisÆo Dep¢sito"
    field tta_dat_desc_cheq_acr            as date format "99/99/9999" initial ? label "Data Desconto" column-label "Data Desconto"
    field tta_dat_prev_desc_cheq_acr       as date format "99/99/9999" initial ? label "Data Prev Desc" column-label "Data Prev Desc"
    field tta_val_cheque                   as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Cheque" column-label "Valor Cheque"
    field tta_nom_emit                     as character format "x(40)" label "Nome Emitente" column-label "Nome Emitente"
    field tta_nom_cidad_emit               as character format "x(30)" label "Cidade Emitente" column-label "Cidade Emitente"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_estab_ext                as character format "x(8)" label "Estabelecimento Exte" column-label "Estabelecimento Ext"
    field tta_cod_id_feder                 as character format "x(20)" initial ? label "ID Federal" column-label "ID Federal"
    field tta_cod_motiv_devol_cheq         as character format "x(5)" label "Motivo Devolu‡Æo" column-label "Motivo Devolu‡Æo"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_cod_finalid_econ_ext         as character format "x(8)" label "Finalid Econ Externa" column-label "Finalidade Externa"
    field tta_cod_usuar_cheq_acr_terc      as character format "x(12)" label "Usu rio" column-label "Usu rio"
    field tta_log_pend_cheq_acr            as logical format "Sim/NÆo" initial no label "Cheque Pendente" column-label "Cheque Pendente"
    field tta_log_cheq_terc                as logical format "Sim/NÆo" initial no label "Cheque Terceiro" column-label "Cheque Terceiro"
    field tta_log_cheq_acr_renegoc         as logical format "Sim/NÆo" initial no label "Cheque Reneg" column-label "Cheque Reneg"
    field tta_log_cheq_acr_devolv          as logical format "Sim/NÆo" initial no label "Cheque Devolvido" column-label "Cheque Devolvido"
    field tta_num_pessoa                   as integer format ">>>,>>>,>>9" initial ? label "Pessoa" column-label "Pessoa"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    index tt_id                            is primary unique
          tta_cod_banco                    ascending
          tta_cod_agenc_bcia               ascending
          tta_cod_cta_corren               ascending
          tta_num_cheque                   ascending
    .

def temp-table tt_integr_acr_liquidac_impto_2 no-undo
    field tta_cod_estab_refer              as character format "x(3)" initial ? label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_num_seq_refer                as integer format ">>>9" initial 0 label "Sequˆncia" column-label "Seq"
    field tta_cod_pais                     as character format "x(3)" label "Pa¡s" column-label "Pa¡s"
    field tta_cod_unid_federac             as character format "x(3)" label "Unidade Federa‡Æo" column-label "UF"
    field tta_cod_imposto                  as character format "x(5)" label "Imposto" column-label "Imposto"
    field tta_cod_classif_impto            as character format "x(05)" initial "00000" label "Class Imposto" column-label "Class Imposto"
    field tta_val_retid_indic_impto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE Imposto" column-label "Vl Retido IE Imposto"
    field tta_val_retid_indic_tit_acr      as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Vl Retido IE T¡tulo" column-label "Vl Retido IE T¡tulo"
    field tta_val_retid_indic_pagto        as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Retido Indicador Pag" column-label "Retido Indicador Pag"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field tta_dat_cotac_indic_econ_pagto   as date format "99/99/9999" initial ? label "Dat Cotac IE Pagto" column-label "Dat Cotac IE Pagto"
    field tta_val_cotac_indic_econ_pagto   as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Val Cotac IE Pagto" column-label "Val Cotac IE Pagto"
    field tta_cod_livre_1                  as character format "x(100)" label "Livre 1" column-label "Livre 1"
    field tta_cod_livre_2                  as character format "x(100)" label "Livre 2" column-label "Livre 2"
    field tta_dat_livre_1                  as date format "99/99/9999" initial ? label "Livre 1" column-label "Livre 1"
    field tta_dat_livre_2                  as date format "99/99/9999" initial ? label "Livre 2" column-label "Livre 2"
    field tta_log_livre_1                  as logical format "Sim/NÆo" initial no label "Livre 1" column-label "Livre 1"
    field tta_log_livre_2                  as logical format "Sim/NÆo" initial no label "Livre 2" column-label "Livre 2"
    field tta_num_livre_1                  as integer format ">>>>>9" initial 0 label "Livre 1" column-label "Livre 1"
    field tta_num_livre_2                  as integer format ">>>>>9" initial 0 label "Livre 2" column-label "Livre 2"
    field tta_val_livre_1                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 1" column-label "Livre 1"
    field tta_val_livre_2                  as decimal format ">>>,>>>,>>9.9999" decimals 4 initial 0 label "Livre 2" column-label "Livre 2"
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_val_rendto_tribut            as decimal format ">,>>>,>>>,>>9.99" decimals 2 initial 0 label "Rendto Tribut vel" column-label "Vl Rendto Tribut"
    .

def temp-table tt_integr_acr_rel_pend_cheq no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_banco                    as character format "x(8)" label "Banco" column-label "Banco"
    field tta_cod_agenc_bcia               as character format "x(10)" label "Agˆncia Banc ria" column-label "Agˆncia Banc ria"
    field tta_cod_cta_corren               as character format "x(10)" label "Conta Corrente" column-label "Cta Corrente"
    field tta_num_cheque                   as integer format ">>>>,>>>,>>9" initial ? label "Num Cheque" column-label "Num Cheque"
    field tta_val_vincul_cheq_acr          as decimal format ">>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Vinculado" column-label "Valor Vinculado"
    field tta_cdn_bco_cheq_salario         as Integer format ">>9" initial 0 label "Banco Cheque Sal rio" column-label "Banco Cheque Sal rio"
    .

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
          tta_cod_unid_negoc               ascending
    .

def temp-table tt_integr_acr_liq_desp_rec no-undo
    field ttv_rec_item_lote_liquidac_acr   as recid format ">>>>>>9"
    field tta_cod_cta_ctbl_ext             as character format "x(20)" label "Conta Contab Extern" column-label "Conta Contab Extern"
    field tta_cod_sub_cta_ctbl_ext         as character format "x(15)" label "Sub Conta Externa" column-label "Sub Conta Externa"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field tta_cod_unid_negoc_ext           as character format "x(8)" label "Unid Neg¢cio Externa" column-label "Unid Neg¢cio Externa"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_tip_abat                 as character format "x(8)" label "Tipo de Abatimento" column-label "Tipo de Abatimento"
    field tta_ind_tip_aprop_recta_despes   as character format "x(20)" label "Tipo Apropria‡Æo" column-label "Tipo Apropria‡Æo"
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
          tta_ind_tip_aprop_recta_despes   ascending
    .

def temp-table tt_integr_acr_aprop_liq_antec no-undo
    field ttv_rec_item_lote_impl_tit_acr   as recid format ">>>>>>9"
    field ttv_rec_abat_antecip_acr         as recid format ">>>>>>9"
    field tta_cod_fluxo_financ_ext         as character format "x(20)" label "Tipo Fluxo Externo" column-label "Tipo Fluxo Externo"
    field ttv_cod_fluxo_financ_tit_ext     as character format "x(20)"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_tip_fluxo_financ         as character format "x(12)" label "Tipo Fluxo Financ" column-label "Tipo Fluxo Financ"
    field tta_cod_unid_negoc_tit           as character format "x(3)" label "Unid Negoc T¡tulo" column-label "Unid Negoc T¡tulo"
    field tta_cod_tip_fluxo_financ_tit     as character format "x(12)" label "Tp Fluxo Financ Tit" column-label "Tp Fluxo Financ Tit"
    field tta_val_abtdo_antecip            as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Abatido" column-label "Vl Abatido"
    .

def temp-table tt_log_erros_import_liquidac no-undo
    field tta_num_seq                      as integer format ">>>,>>9" initial 0 label "Sequˆncia" column-label "NumSeq"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    as character format "x(10)" label "Referˆncia" column-label "Referˆncia"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_cod_ser_docto                as character format "x(3)" label "S‚rie Documento" column-label "S‚rie"
    field tta_cod_tit_acr                  as character format "x(10)" label "T¡tulo" column-label "T¡tulo"
    field tta_cod_parcela                  as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_nom_abrev_clien              as character format "x(12)" label "Cliente" column-label "Cliente"
    field ttv_num_erro_log                 as integer format ">>>>,>>9" label "N£mero Erro" column-label "N£mero Erro"
    field ttv_des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia"
    index tt_sequencia                    
          tta_num_seq                      ascending.

/* --------------------------------------------------------------------------------------------- */
/* --------------------------------------------------------------------------------------------- */
def temp-table tt_integr_lote_ctbl_1 no-undo
    field tta_cod_modul_dtsul              as character format "x(3)" label "M¢dulo" column-label "M¢dulo"
    field tta_num_lote_ctbl                as integer format ">>>,>>>,>>9" initial 1 label "Lote Cont bil" column-label "Lote Cont bil"
    field tta_des_lote_ctbl                as character format "x(40)" label "Descri‡Æo Lote" column-label "Descri‡Æo Lote"
    field tta_cod_empresa                  as character format "x(3)" label "Empresa" column-label "Empresa"
    field tta_dat_lote_ctbl                as date format "99/99/9999" initial today label "Data Lote Cont bil" column-label "Data Lote Cont bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_log_integr_ctbl_online       as logical format "Sim/NÆo" initial no label "Integra‡Æo Online" column-label "Integr Online"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    index tt_recid                        
          ttv_rec_integr_lote_ctbl         ascending.

def temp-table tt_integr_lancto_ctbl_1 no-undo
    field tta_cod_cenar_ctbl               as character format "x(8)" label "Cen rio Cont bil" column-label "Cen rio Cont bil"
    field tta_log_lancto_conver            as logical format "Sim/NÆo" initial no label "Lan‡amento ConversÆo" column-label "Lan‡to Conv"
    field tta_log_lancto_apurac_restdo     as logical format "Sim/NÆo" initial no label "Lan‡amento Apura‡Æo" column-label "Lancto Apura‡Æo"
    field tta_cod_rat_ctbl                 as character format "x(8)" label "Rateio Cont bil" column-label "Rateio"
    field ttv_rec_integr_lote_ctbl         as recid format ">>>>>>9"
    field tta_num_lancto_ctbl              as integer format ">>,>>>,>>9" initial 10 label "Lan‡amento Cont bil" column-label "Lan‡amento Cont bil"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lan‡amento" column-label "Data Lan‡to"
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lote_ctbl         ascending
          tta_num_lancto_ctbl              ascending
    index tt_recid                        
          ttv_rec_integr_lancto_ctbl       ascending.

def temp-table tt_integr_item_lancto_ctbl_1 no-undo
    field ttv_rec_integr_lancto_ctbl       as recid format ">>>>>>9"
    field tta_num_seq_lancto_ctbl          as integer format ">>>>9" initial 0 label "Sequˆncia Lan‡to" column-label "Sequˆncia Lan‡to"
    field tta_ind_natur_lancto_ctbl        as character format "X(02)" initial "DB" label "Natureza" column-label "Natureza"
    field tta_cod_plano_cta_ctbl           as character format "x(8)" label "Plano Contas" column-label "Plano Contas"
    field tta_cod_cta_ctbl                 as character format "x(20)" label "Conta Cont bil" column-label "Conta Cont bil"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_cod_estab                    as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_histor_padr              as character format "x(8)" label "Hist¢rico PadrÆo" column-label "Hist¢rico PadrÆo"
    field tta_des_histor_lancto_ctbl       as character format "x(2000)" label "Hist¢rico Cont bil" column-label "Hist¢rico Cont bil"
    field tta_cod_espec_docto              as character format "x(3)" label "Esp‚cie Documento" column-label "Esp‚cie"
    field tta_dat_docto                    as date format "99/99/9999" initial ? label "Data Documento" column-label "Data Documento"
    field tta_des_docto                    as character format "x(25)" label "N£mero Documento" column-label "N£mero Documento"
    field tta_cod_imagem                   as character format "x(30)" label "Imagem" column-label "Imagem"
    field tta_cod_indic_econ               as character format "x(8)" label "Moeda" column-label "Moeda"
    field tta_dat_lancto_ctbl              as date format "99/99/9999" initial ? label "Data Lan‡amento" column-label "Data Lan‡to"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lan‡amento" column-label "Valor Lan‡amento"
    field tta_num_seq_lancto_ctbl_cpart    as integer format ">>>9" initial 0 label "Sequˆncia CPartida" column-label "Sequˆncia CP"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field tta_cod_proj_financ              as character format "x(20)" label "Projeto" column-label "Projeto"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_lancto_ctbl       ascending
          tta_num_seq_lancto_ctbl          ascending
    index tt_recid                        
          ttv_rec_integr_item_lancto_ctbl  ascending.

def temp-table tt_integr_aprop_lancto_ctbl_1 no-undo
    field tta_cod_finalid_econ             as character format "x(10)" label "Finalidade" column-label "Finalidade"
    field tta_cod_unid_negoc               as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg"
    field tta_cod_plano_ccusto             as character format "x(8)" label "Plano Centros Custo" column-label "Plano Centros Custo"
    field tta_qtd_unid_lancto_ctbl         as decimal format ">>,>>>,>>9.99" decimals 2 initial 0 label "Quantidade" column-label "Quantidade"
    field tta_val_lancto_ctbl              as decimal format ">>>>>,>>>,>>9.99" decimals 2 initial 0 label "Valor Lan‡amento" column-label "Valor Lan‡amento"
    field tta_num_id_aprop_lancto_ctbl     as integer format "9999999999" initial 0 label "Apropriacao Lan‡to" column-label "Apropriacao Lan‡to"
    field ttv_rec_integr_item_lancto_ctbl  as recid format ">>>>>>9"
    field tta_dat_cotac_indic_econ         as date format "99/99/9999" initial ? label "Data Cota‡Æo" column-label "Data Cota‡Æo"
    field tta_val_cotac_indic_econ         as decimal format ">>>>,>>9.9999999999" decimals 10 initial 0 label "Cota‡Æo" column-label "Cota‡Æo"
    field ttv_ind_erro_valid               as character format "X(08)" initial "NÆo"
    field tta_ind_orig_val_lancto_ctbl     as character format "X(10)" initial "Informado" label "Origem Valor" column-label "Origem Valor"
    field tta_cod_ccusto                   as Character format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_rec_integr_aprop_lancto_ctbl as recid format ">>>>>>9"
    index tt_id                            is primary unique
          ttv_rec_integr_item_lancto_ctbl  ascending
          tta_cod_finalid_econ             ascending
          tta_cod_unid_negoc               ascending
          tta_cod_plano_ccusto             ascending
          tta_cod_ccusto                   ascending
    index tt_recid                        
          ttv_rec_integr_aprop_lancto_ctbl ascending.

def new shared temp-table tt_integr_ctbl_valid_1 no-undo
    field ttv_rec_integr_ctbl              as recid format ">>>>>>9"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" label "N£mero" column-label "N£mero Mensagem"
    field ttv_ind_pos_erro                 as character format "X(08)" label "Posi‡Æo"
    index tt_id                            is primary unique
          ttv_rec_integr_ctbl              ascending
          ttv_num_mensagem                 ascending.

/* --------------------------------------------------------------------------------------------- */
/* -------------------------------------------------------------------------------------- EOF -- */
/* --------------------------------------------------------------------------------------------- */







