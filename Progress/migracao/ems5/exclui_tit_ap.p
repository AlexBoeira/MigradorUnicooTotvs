/*DEFINE SHARED TEMP-TABLE tt_tit_ap NO-UNDO LIKE tit_ap
       field nome_fornecedor label "Nome Forn." like fornecedor.nom_pessoa
       field Situacao as char label "Situa»’o" format "x(13)"
       field des_msg_erro                 as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia" 
       field des_msg_ajuda                as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".
*/
DEF VAR sit_period AS CHAR FORMAT "x(30)".
DEF VAR referencia AS CHAR FORMAT "x(10)".
DEF VAR v_log_livre_1 AS LOGICAL.
DEF VAR I AS INT.
DEFINE VARIABLE saldo AS DECIMAL    NO-UNDO.
DEFINE VARIABLE linha AS CHARACTER  NO-UNDO.
/*Temp-table 1:  conterÿ as informa»„es do t­tulo e informa»„es gerais.*/

def temp-table tt_cancelamento_estorno_apb no-undo
    field ttv_ind_niv_operac_apb    	as character format "X(10)"
    field ttv_ind_tip_operac_apb     	as character format "X(12)"
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap              	as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap 	as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_cod_refer                    	as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_dat_transacao               	as date format "99/99/9999" initial today label "Data Transa»’o" column-label "Dat Transac"
    field tta_cod_histor_padr           	as character format "x(8)" label "Hist½rico Padr’o" column-label "Hist½rico Padr’o"
    field ttv_des_histor                   	as character format "x(40)" label "Cont²m" column-label "Hist½rico"
    field ttv_ind_tip_estorn              	as character format "X(10)"
    field tta_cod_portador                	as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_estab_reembol      	as character format "x(8)"
    field ttv_log_reaber_item           	as logical format "Sim/N’o" initial yes
    field ttv_log_reembol                	as logical format "Sim/N’o" initial yes
    field ttv_log_estorn_impto_retid as logical format "Sim/N’o" initial yes.

/*Temp-table 2: Esta temp-table apenas deverÿ ser definida, n’o poderÿ receber valor, ² de uso interno.*/

def temp-table tt_estornar_agrupados no-undo
    field ttv_num_seq                    	as integer format ">>>,>>9" label "Seq±¼ncia" column-label "Seq"
    field tta_nom_abrev                 	as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_estab_pagto        	as character format "x(3)" label "Estab Pagto" column-label "Estab Pagto"
    field tta_cod_refer                    	as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_dat_pagto                  	as date format "99/99/9999" initial today label "Data Pagamento" column-label "Data Pagto"
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto         	as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field tta_cod_ser_docto            	as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field tta_cod_tit_ap                   	as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field tta_cod_parcela                  	as character format "x(02)" label "Parcela" column-label "Parc"
    field tta_val_movto_ap              	as decimal format "->>>,>>>,>>9.99" decimals 2 initial 0 label "Valor  Movimento" column-label "Valor Movto"
    field tta_ind_modo_pagto          	as character format "X(10)" label "Modo  Pagamento" column-label "Modo Pagto"
    field tta_cod_empresa              	as character format "x(3)" label "Empresa" column-label "Empresa"
    field ttv_rec_tit_ap                   	as recid format ">>>>>>9" initial ?
    field ttv_num_seq_abrev           	as integer format ">>9" label "Sq" column-label "Sq"
    field tta_ind_trans_ap_abrev     	as character format "X(04)" label "Trans Abrev" column-label "Trans Abrev"
    field ttv_rec_compl_movto_pagto  as recid format ">>>>>>9"
    field ttv_rec_movto_tit_ap         	as recid format ">>>>>>9"
    field ttv_rec_item_cheq_ap       	as recid format ">>>>>>9"
    field ttv_rec_item_bord_ap        	as recid format ">>>>>>9"
    field ttv_rec_item_lote_pagto    	as recid format ">>>>>>9"
    index tt_ind_modo                     
          tta_ind_modo_pagto            	ascending.   

/*Temp-table 3: conterÿ as informa»„es de erro que poder’o ocorrer na execu»’o do programa.*/

def temp-table tt_log_erros_estorn_cancel_apb no-undo
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    	as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field tta_num_mensagem           	as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro              	as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¼ncia"
    field ttv_des_msg_ajuda            	as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".

/*Temp-table 4: conterÿ as informa»„es dos t­tulos que poder’o Ter impostos vinculados ao fornecedor, resaltando que a mesma ² de uso interno, e n’o poderÿ conter valor, na passagem de parametro.*/

def temp-table tt_estorna_tit_imptos no-undo
    field ttv_cod_refer_imp            	as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_refer                    	as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_cod_estab_imp             	as character format "x(3)" label "Estabelec. Impto." column-label "Estab. Imp."
    field ttv_cdn_fornecedor_imp    	as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto_imp  	as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field ttv_cod_ser_docto_imp      	as character format "x(3)" label "S²rie Documento" column-label "S²rie"
    field ttv_cod_tit_ap_imp             	as character format "x(10)" label "T­tulo" column-label "T­tulo"
    field ttv_cod_parcela_imp          	as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap_imp             	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor T­tulo" column-label "Valor T­tulo"
    field ttv_val_sdo_tit_ap_imp     	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap_imp     	as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem           	as integer format ">>>>,>>9" label "Nœmero" column-label "Nœmero Mensagem"
    field ttv_des_mensagem            	as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    	as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_estab_2                 	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cdn_fornecedor            	as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto         	as character format "x(3)" label "Esp²cie Documento" column-label "Esp²cie"
    field ttv_cod_ser_docto            	as character format "x(3)" label "S²rie Docto" column-label "S²rie"
    field ttv_cod_tit_ap                   	as character format "x(10)" label "T­tulo Ap" column-label "T­tulo Ap"
    field ttv_cod_parcela                  	as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap                   	as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor T­tulo" column-label "Valor T­tulo"
    field ttv_val_sdo_tit_ap             	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap            	as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_ind_trans_ap_abrev     	as character format "X(04)" label "Transa»’o" column-label "Transa»’o"
    field ttv_cod_refer_2                  	as character format "x(10)" label "Refer¼ncia" column-label "Refer¼ncia"
    field ttv_num_order                   	as integer format ">>>>,>>9" label "Ordem" column-label "Ordem"
    field ttv_val_tot_comprtdo        	as decimal format "->>>,>>>,>>9.99" decimals 2
    index tt_idimpto                      
          ttv_cod_estab_imp               	ascending
          ttv_cdn_fornecedor_imp      	ascending
          ttv_cod_espec_docto_imp   	ascending
          ttv_cod_ser_docto_imp        	ascending
          ttv_cod_tit_ap_imp              	ascending
          ttv_cod_parcela_imp            	ascending
    index tt_idimpto_pgef                 
          ttv_cod_estab                    	ascending
          ttv_cod_refer                    	ascending
    index tt_idtit_refer                  
          ttv_cod_estab_2                  	ascending
          ttv_cdn_fornecedor             	ascending
          ttv_cod_espec_docto           	ascending
          ttv_cod_ser_docto                	ascending
          ttv_cod_tit_ap                   	ascending
          ttv_cod_parcela                  	ascending
          ttv_cod_refer_2                  	ascending
    index tt_numsg                        
          ttv_num_mensagem              	ascending
    index tt_order                        
          ttv_num_order                    	ascending.

DEF VAR v-num_id_tit_ap        LIKE movto_tit_ap.num_id_movto_tit_ap             NO-UNDO.

    ASSIGN i = 0.
    ASSIGN saldo = 0.
 
           FOR EACH TIT_AP WHERE TIT_AP.NUM_LIVRE_1 = 9 NO-LOCK:
                
               FOR EACH movto_tit_ap USE-INDEX MVTTTP_ID
			         WHERE movto_tit_ap.cod_estab = tit_ap.cod_estab
					   and movto_tit_ap.num_id_tit_ap = TIT_AP.NUM_ID_TIT_AP NO-LOCK:

/*                 IF tit_ap.NUM_LIVRE_1 = 1 THEN */
					CREATE tt_cancelamento_estorno_Apb.
					ASSIGN tt_cancelamento_estorno_Apb.ttv_ind_niv_operac_apb  = "TÖTULO"
						   tt_cancelamento_estorno_Apb.ttv_ind_tip_Operac_Apb  = "Cancelamento" 
						   tt_cancelamento_estorno_Apb.tta_num_id_tit_ap       = tit_ap.num_id_tit_ap
						   tt_cancelamento_estorno_Apb.tta_num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap
						   tt_cancelamento_estorno_Apb.tta_cod_refer           = '0'
						   tt_cancelamento_estorno_Apb.tta_dat_transacao       = movto_tit_ap.dat_transacao
						   tt_cancelamento_estorno_Apb.ttv_ind_tip_estorn      = "Total"
						   tt_cancelamento_estorno_Apb.tta_cod_portador        = movto_tit_ap.cod_portador
						   tt_cancelamento_estorno_Apb.ttv_log_reaber_item     = no
						   tt_cancelamento_estorno_Apb.ttv_log_reembol         = no
						   tt_cancelamento_estorno_Apb.tta_cod_estab           = movto_tit_ap.cod_estab
						   tt_cancelamento_estorno_Apb.ttv_cod_estab_reembol   = movto_tit_ap.cod_estab.
					END.
/*                 ELSE                                                                                                         */
/*                     CREATE tt_cancelamento_estorno_Apb.                                                                      */
/*                     ASSIGN tt_cancelamento_estorno_Apb.ttv_ind_niv_operac_apb  = "MOVIMENTOS A ESTORNAR"                     */
/*                            tt_cancelamento_estorno_Apb.ttv_ind_tip_Operac_Apb  = "Estorno" /* ou "Estorno"/"Cancelamento" */ */
/*                            tt_cancelamento_estorno_Apb.tta_num_id_tit_ap       = tit_ap.num_id_tit_ap                        */
/*                            tt_cancelamento_estorno_Apb.tta_num_id_movto_tit_ap = movto_tit_ap.num_id_movto_tit_ap            */
/*                            tt_cancelamento_estorno_Apb.tta_cod_refer           = '0'                                         */
/*                            tt_cancelamento_estorno_Apb.tta_dat_transacao       = movto_tit_ap.dat_transacao                  */
/*                            tt_cancelamento_estorno_Apb.ttv_ind_tip_estorn      = "Total"                                     */
/*                            tt_cancelamento_estorno_Apb.tta_cod_portador        = movto_tit_ap.cod_portador                   */
/*                            tt_cancelamento_estorno_Apb.ttv_log_reaber_item     = no                                          */
/*                            tt_cancelamento_estorno_Apb.ttv_log_reembol         = yes                                         */
/*                            tt_cancelamento_estorno_Apb.tta_cod_estab           = movto_tit_ap.cod_estab                      */
/*                            tt_cancelamento_estorno_Apb.ttv_cod_estab_reembol   = movto_tit_ap.cod_estab.                     */
/*                     END.                                                                                                     */
/*                 END.                                                                                                         */
				
			   i = i + 1.
            END.
/*                                                              */
/*     FIND FIRST tt_cancelamento_estorno_apb NO-LOCK NO-ERROR. */
/*     IF AVAIL tt_cancelamento_estorno_apb THEN DO:            */
               run prgfin/apb/apb768za.py (Input 1,
                                             Input table tt_cancelamento_estorno_apb,
                                             Input table tt_estornar_agrupados,
                                             output table tt_log_erros_estorn_cancel_apb,
                                             output table tt_estorna_tit_imptos,
                                             output v_log_livre_1).
/*     END.  */
    
OUTPUT TO C:\Limpa\erros_2.txt.
FOR EACH tt_log_erros_estorn_cancel_apb NO-LOCK:
    PUT 
    tt_log_erros_estorn_cancel_apb.ttv_des_msg_erro
    " "
    tt_log_erros_estorn_cancel_apb.ttv_des_msg_ajuda
    " "
    tt_log_erros_estorn_cancel_apb.tta_num_mensagem
    SKIP.
END.
OUTPUT CLOSE.
