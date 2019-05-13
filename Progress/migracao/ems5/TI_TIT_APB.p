DEF INPUT PARAM in-status-par AS CHAR NO-UNDO.

/* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- */                                                       
/* -------------------------------------------------------------------- */
{ems5\deftemp-app.i}
def temp-table tp_erros no-undo
    field ds_mensagem as char format "x(132)"
    field cd_erro     as int format 999999999999
    field tp_erro     as char format "x(15)".

def temp-table tt_cancelamento_estorno_apb no-undo
    field ttv_ind_niv_operac_apb    	as character format "X(10)"
    field ttv_ind_tip_operac_apb     	as character format "X(12)"
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_num_id_tit_ap              	as integer format "9999999999" initial 0 label "Token Tit AP" column-label "Token Tit AP"
    field tta_num_id_movto_tit_ap 	as integer format "9999999999" initial 0 label "Token Movto Tit AP" column-label "Id Tit AP"
    field tta_cod_refer                    	as character format "x(10)" label "Refer?ncia" column-label "Refer?ncia"
    field tta_dat_transacao               	as date format "99/99/9999" initial today label "Data Transa?�o" column-label "Dat Transac"
    field tta_cod_histor_padr           	as character format "x(8)" label "Hist�rico Padr�o" column-label "Hist�rico Padr�o"
    field ttv_des_histor                   	as character format "x(40)" label "Cont?m" column-label "Hist�rico"
    field ttv_ind_tip_estorn              	as character format "X(10)"
    field tta_cod_portador                	as character format "x(5)" label "Portador" column-label "Portador"
    field ttv_cod_estab_reembol      	as character format "x(8)"
    field ttv_log_reaber_item           	as logical format "Sim/N�o" initial yes
    field ttv_log_reembol                	as logical format "Sim/N�o" initial yes
    field ttv_log_estorn_impto_retid as logical format "Sim/N�o" initial yes.
    
def temp-table tt_log_erros_estorn_cancel_apb no-undo
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_refer                    	as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field tta_num_mensagem           	as integer format ">>,>>>,>>9" initial 0 label "Mensagem" column-label "Mensagem"
    field ttv_des_msg_erro              	as character format "x(60)" label "Mensagem Erro" column-label "Inconsist�ncia"
    field ttv_des_msg_ajuda            	as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda".
    
def temp-table tt_estornar_agrupados no-undo
    field ttv_num_seq                    	as integer format ">>>,>>9" label "Seq��ncia" column-label "Seq"
    field tta_nom_abrev                 	as character format "x(15)" label "Nome Abreviado" column-label "Nome Abreviado"
    field tta_cod_estab_pagto        	as character format "x(3)" label "Estab Pagto" column-label "Estab Pagto"
    field tta_cod_refer                    	as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field tta_dat_pagto                  	as date format "99/99/9999" initial today label "Data Pagamento" column-label "Data Pagto"
    field tta_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field tta_cod_espec_docto         	as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field tta_cod_ser_docto            	as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field tta_cod_tit_ap                   	as character format "x(10)" label "T�tulo" column-label "T�tulo"
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
          
def temp-table tt_estorna_tit_imptos no-undo
    field ttv_cod_refer_imp            	as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field ttv_cod_refer                    	as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
    field ttv_cod_estab_imp             	as character format "x(3)" label "Estabelec. Impto." column-label "Estab. Imp."
    field ttv_cdn_fornecedor_imp    	as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto_imp  	as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field ttv_cod_ser_docto_imp      	as character format "x(3)" label "S�rie Documento" column-label "S�rie"
    field ttv_cod_tit_ap_imp             	as character format "x(10)" label "T�tulo" column-label "T�tulo"
    field ttv_cod_parcela_imp          	as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap_imp             	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor T�tulo" column-label "Valor T�tulo"
    field ttv_val_sdo_tit_ap_imp     	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap_imp     	as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_num_mensagem           	as integer format ">>>>,>>9" label "N�mero" column-label "N�mero Mensagem"
    field ttv_des_mensagem            	as character format "x(50)" label "Mensagem" column-label "Mensagem"
    field ttv_des_ajuda                    	as character format "x(50)" label "Ajuda" column-label "Ajuda"
    field ttv_cod_estab_2                 	as character format "x(3)" label "Estabelecimento" column-label "Estab"
    field ttv_cod_estab                    	as character format "x(3)" label "Estabelecimento" column-label "Estabelecimento"
    field ttv_cdn_fornecedor            	as Integer format ">>>,>>>,>>9" label "Fornecedor" column-label "Fornecedor"
    field ttv_cod_espec_docto         	as character format "x(3)" label "Esp�cie Documento" column-label "Esp�cie"
    field ttv_cod_ser_docto            	as character format "x(3)" label "S�rie Docto" column-label "S�rie"
    field ttv_cod_tit_ap                   	as character format "x(10)" label "T�tulo Ap" column-label "T�tulo Ap"
    field ttv_cod_parcela                  	as character format "x(02)" label "Parcela" column-label "Parc"
    field ttv_val_tit_ap                   	as decimal format "->>,>>>,>>>,>>9.99" decimals 2 label "Valor T�tulo" column-label "Valor T�tulo"
    field ttv_val_sdo_tit_ap             	as decimal format "->>>,>>>,>>9.99" decimals 2 label "Valor Saldo" column-label "Valor Saldo"
    field ttv_num_id_tit_ap            	as integer format "9999999999" label "Token Tit AP" column-label "Token Tit AP"
    field ttv_ind_trans_ap_abrev     	as character format "X(04)" label "Transa��o" column-label "Transa��o"
    field ttv_cod_refer_2                  	as character format "x(10)" label "Refer�ncia" column-label "Refer�ncia"
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
          

    
def buffer b_TI_TIT_APB for TI_TIT_APB.
def buffer b2_TI_TIT_APB for TI_TIT_APB.
DEF BUFFER b_ti_controle_integracao FOR ti_controle_integracao.
   

/*--------------------- Procedure rtapi044 e variaveis ----------------------*/

/*
{rtp/rtapi044.i} 
*/
def var cd-referencia-aux    as char no-undo.
def var lg-ocorreu-erro-aux  as log                                no-undo.
def var cod_unid_negoc_aux like estab_unid_negoc.cod_unid_negoc no-undo.
def var cod_fornecedor_aux like emsuni.fornecedor.cdn_fornecedor no-undo.
def var cod_pais_aux       as char initial "BRA" no-undo.
def var cod_moeda_corrente_aux like histor_finalid_econ.cod_indic_econ no-undo.
def var cod_unid_federac_aux   like ems5.pessoa_fisic.cod_unid_federac no-undo.

def var cod_favorecido_imposto_aux like emsuni.fornecedor.cdn_fornecedor no-undo.
def var cod_uf_imposto_aux         as char no-undo.
def var val-total-aux              as dec no-undo.
def var cod_imposto_aux            like tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto    no-undo.
def var cod_classif_impto_aux      like tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto  no-undo.
def var cod_plano_ccusto_aux       as char no-undo.
def var cod_tip_fluxo_financ_aux      as char no-undo.
def var lg_erro_aux                as log no-undo.
DEF VAR v_log_livre_1 AS LOGICAL.

for each TI_TIT_APB where TI_TIT_APB.CDSITUACAO = in-status-par. 
/*for each TI_TIT_APB where nrseq_controle_integracao = 6776690. */

   if TI_TIT_APB.val_desconto = 0 
   then assign TI_TIT_APB.dat_desconto = ?.
   else assign TI_TIT_APB.dat_desconto = 12/31/2050.
  
   /*Alex Boeira 19/01/2016 - comentado pois nao fazia nada dentro da leitura
   for each TI_TIT_APB_CTBL where  TI_TIT_APB_CTBL.nrseq_controle_integracao  = TI_TIT_APB.nrseq_controle_integracao and
                                      TI_TIT_APB_CTBL.CDSITUACAO   <> "CA":
             
   end.*/

   /* Comentado por Ja�ne em 21/09/2016 */
   /*for each TI_TIT_APB_IMPOSTO where TI_TIT_APB_IMPOSTO.nrseq_controle_integracao  = TI_TIT_APB.nrseq_controle_integracao  and
                                     TI_TIT_APB_IMPOSTO.CDSITUACAO   <> "CA" exclusive-lock:
       assign TI_TIT_APB_IMPOSTO.cod_classif_impto = TI_TIT_APB_IMPOSTO.cod_imposto.
   end.   */                                
end.

/* SE O TITULO JA EXISTE, REMOVER DO EMS5 PARA PROCESSAR NOVAMENTE - PODE TER SIDO ALTERADO NO UNICOO */
    EMPTY temp-table tt_cancelamento_estorno_Apb.
    EMPTY temp-table tt_estornar_agrupados.
    EMPTY temp-table tt_log_erros_estorn_cancel_apb.
    EMPTY temp-table tt_estorna_tit_imptos.

for each TI_TIT_APB where TI_TIT_APB.CDSITUACAO = in-status-par no-lock:
/*for each TI_TIT_APB where nrseq_controle_integracao = 6776690 no-lock: */

    for each tit_ap
       where tit_ap.cod_estab       = ti_tit_apb.cod_estab      
         and tit_ap.cdn_fornecedor  = ti_tit_apb.cdn_fornecedor 
         and tit_ap.cod_espec_docto = ti_tit_apb.cod_espec_docto
         and tit_ap.cod_ser_docto   = ti_tit_apb.cod_ser_docto  
         and tit_ap.cod_tit_ap      = ti_tit_apb.cod_titulo_ap
         and tit_ap.cod_parcela     = ti_tit_apb.cod_parcela
        no-lock:

            FOR EACH movto_tit_ap USE-INDEX MVTTTP_ID
    		   WHERE movto_tit_ap.cod_estab = tit_ap.cod_estab
    		     and movto_tit_ap.num_id_tit_ap = TIT_AP.NUM_ID_TIT_AP NO-LOCK:

                CREATE tt_cancelamento_estorno_Apb.
				ASSIGN tt_cancelamento_estorno_Apb.ttv_ind_niv_operac_apb     = "TITULO"
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
            end.
    end.

    assign lg_erro_aux = no.

    if can-find(first tt_cancelamento_estorno_Apb)
    then do:
            run prgfin/apb/apb768za.py (Input 1,
                                        Input table tt_cancelamento_estorno_apb,
                                        Input table tt_estornar_agrupados,
                                        output table tt_log_erros_estorn_cancel_apb,
                                        output table tt_estorna_tit_imptos,
                                        output v_log_livre_1).

            for each tt_log_erros_estorn_cancel_apb:
                create TI_FALHA_DE_PROCESSO. 
                ASSIGN TI_FALHA_DE_PROCESSO.CDINTEGRACAO = "TI_TIT_APB"
                       TI_FALHA_DE_PROCESSO.TXAJUDA = tt_log_erros_estorn_cancel_apb.ttv_des_msg_ajuda
                       TI_FALHA_DE_PROCESSO.TXFALHA = tt_log_erros_estorn_cancel_apb.ttv_des_msg_erro
                       TI_FALHA_DE_PROCESSO.NRMENSAGEM = tt_log_erros_estorn_cancel_apb.tta_num_mensagem
                       TI_FALHA_DE_PROCESSO.NRSEQ_CONTROLE_INTEGRACAO = ti_tit_apb.nrseq_controle_integracao /*ti_cx_bx_acr.nrseq_controle_integracao*/ .

                ASSIGN lg_erro_aux = YES
                       lg-ocorreu-erro-aux = YES.
            end.
    end.


/*    PAUSE 0.                                                       */

if not lg_erro_aux
then do:
   
        ASSIGN lg-ocorreu-erro-aux = NO.
        run limpa_temporaria.
        run busca-dados-fornecedor(output cod_fornecedor_aux,
                                   output cod_moeda_corrente_aux,
                                   output cod_unid_federac_aux
                                    ).
        if not lg-ocorreu-erro-aux 
        then do:
               run busca-unidade-negocio(output cod_unid_negoc_aux,
                                         output lg-ocorreu-erro-aux).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P1: " + STRING(lg-ocorreu-erro-aux))  .
                                         
               if not lg-ocorreu-erro-aux
               then do:           
                      run cria-temporaria(output lg-ocorreu-erro-aux).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P2: " + STRING(lg-ocorreu-erro-aux))  .
                      
                      if not lg-ocorreu-erro-aux 
                      then do: 
                             run prgfin\apb\apb900zf.py (input 4,
                                                         input "EMS2",
                                                         input-output table tt_integr_apb_item_lote_impl_3).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P3.0: " + STRING(lg-ocorreu-erro-aux))  .
                             run trata-erros(input  "enviado",
                                             output lg-ocorreu-erro-aux).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P3.1: " + STRING(lg-ocorreu-erro-aux))  .
                                             
                                         
                           end.
                      else run trata-erros(input  "nao enviado",
                                           output lg-ocorreu-erro-aux).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P4: " + STRING(lg-ocorreu-erro-aux))  .
                                           
                    end.
               else run trata-erros(input  "nao enviado",
                                    output lg-ocorreu-erro-aux).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P5: " + STRING(lg-ocorreu-erro-aux))  .
     
             end.
        else do:
               run trata-erros(input  "nao enviado",
                               output lg-ocorreu-erro-aux).
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P6: " + STRING(lg-ocorreu-erro-aux))  .
                               
             end.
                              
     RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P7: " + STRING(lg-ocorreu-erro-aux))  .

end.
                         
   find b_TI_TIT_APB where rowid(b_TI_TIT_APB) = rowid(TI_TIT_APB) EXCLUSIVE-LOCK no-error.
   IF AVAIL b_ti_tit_apb
   THEN if lg-ocorreu-erro-aux
        then assign b_TI_TIT_APB.CDSITUACAO = "PE".
        else do:
               assign b_TI_TIT_APB.CDSITUACAO = "IT".

               /**
                * Ao setar para IT, trocar para CA possiveis registros antigos referentes ao mesmo titulo.
                */
               FOR EACH ti_controle_integracao NO-LOCK
                  WHERE ti_controle_integracao.nrsequencial = ti_tit_apb.NRSEQ_CONTROLE_INTEGRACAO,
                   EACH b_ti_controle_integracao NO-LOCK
                  WHERE b_ti_controle_integracao.nrsequencial_origem = ti_controle_integracao.nrsequencial_origem
                    AND b_ti_controle_integracao.tpintegracao        = ti_controle_integracao.tpintegracao,
                   EACH b2_ti_tit_apb EXCLUSIVE-LOCK
                  WHERE b2_ti_tit_apb.nrseq_controle_integracao = b_ti_controle_integracao.nrsequencial
                    AND ROWID(b2_ti_tit_apb) <> ROWID(ti_tit_apb):

                        ASSIGN b2_ti_tit_apb.cdsituacao = "CA".
               END.

             END.
   ELSE DO:
          run escrever-log("@@@@@@@@@@@@@@@@@@@Nao foi possivel acessar b_TI_TIT_APB para atualizacao do status!").
          LEAVE.
        END.

   for each TI_TIT_APB_IMPOSTO where   TI_TIT_APB_IMPOSTO.nrseq_controle_integracao  = b_TI_TIT_APB.nrseq_controle_integracao  and
                                       TI_TIT_APB_IMPOSTO.CDSITUACAO   <> "CA"                            exclusive-lock:
       assign TI_TIT_APB_IMPOSTO.CDSITUACAO      = b_TI_TIT_APB.CDSITUACAO.

   end.
   for each TI_TIT_APB_CTBL where  TI_TIT_APB_CTBL.nrseq_controle_integracao  = b_TI_TIT_APB.nrseq_controle_integracao  and
                                      TI_TIT_APB_CTBL.CDSITUACAO   <> "CA"                                 exclusive-lock:
       assign TI_TIT_APB_CTBL.CDSITUACAO      = b_TI_TIT_APB.CDSITUACAO.
   end.
end.

/*================================*/
/* Gravar as falhas da integra��o */
/*--------------------------------*/
procedure p_grava_falha:

    def input  parameter pTXAjuda           like ti_falha_de_processo.txajuda   no-undo.
    def input  parameter pTXFALHA           like ti_falha_de_processo.TXFALHA   no-undo.
    def input  parameter pNRMENSAGEM        like ti_falha_de_processo.NRMENSAGEM   no-undo. 

    assign lg-ocorreu-erro-aux = yes.
    
    create TI_FALHA_DE_PROCESSO. 
             assign
             TI_FALHA_DE_PROCESSO.CDINTEGRACAO              = "TI_TIT_APB"
             TI_FALHA_DE_PROCESSO.TXAJUDA                   = pTXAjuda
             TI_FALHA_DE_PROCESSO.TXFALHA                   = pTXFALHA 
             TI_FALHA_DE_PROCESSO.NRMENSAGEM                = pNRMENSAGEM
             TI_FALHA_DE_PROCESSO.nrseq_controle_integracao = TI_TIT_APB.nrseq_controle_integracao. 
             
RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P8(P_GRAVA_FALHA): " + STRING(lg-ocorreu-erro-aux))  .
             
end procedure.


Procedure limpa_temporaria:
   empty temp-table tt_integr_apb_lote_impl.
   empty temp-table tt_integr_apb_item_lote_impl.
   empty temp-table tt_integr_apb_item_lote_impl_3.
   empty temp-table tt_integr_apb_aprop_ctbl_pend.
   empty temp-table tt_integr_apb_impto_impl_pend.
   empty temp-table tt_log_erros_atualiz.
   empty temp-table tp_erros.
end procedure.

procedure busca-dados-fornecedor:
   def output parameter cod_fornecedor_par        like emsuni.fornecedor.cdn_fornecedor no-undo.
   def output parameter cod_moeda_corrente_par like histor_finalid_econ.cod_indic_econ no-undo.
   def output parameter cod_unid_federac_par  like ems5.pessoa_jurid.cod_unid_federac no-undo.

    find ti_pessoa where ti_pessoa.nrregistro=TI_TIT_APB.nrpessoa no-lock no-error.

    if not available ti_pessoa then do:
            run p_grava_falha(
                             "*** ERRO", 
                             "fornecedor " + 
                                        trim(TI_TIT_APB.cod_id_feder) +  
                                        " Processo: " + string(TI_TIT_APB.nrseq_controle_integracao) +
                                        " Pessoa: " + string(TI_TIT_APB.nrpessoa)+ " nao encontrada em TI_PESSOA",
                             010
                             ).         
          return.
       end.
     else do:
           
           if ti_pessoa.cdn_fornecedor=? then do:
            run p_grava_falha(
                             "fornecedor n�o cadastrado", 
                             "fornecedor " + 
                                        trim(TI_TIT_APB.cod_id_feder) +  
                                        " Processo: " + string(TI_TIT_APB.nrseq_controle_integracao) +
                                        " Pessoa: " + string(TI_TIT_APB.nrpessoa)+  
                                        " fornecedor n�o cadastrado",
                             011
                             ).         
           end.
           else do:
           
               find emsuni.fornecedor where emsuni.fornecedor.cod_empresa     = TI_TIT_APB.cod_empresa and
                                      emsuni.fornecedor.cdn_fornecedor=ti_pessoa.cdn_fornecedor no-lock no-error.
                                      
              if not available fornecedor then do:
                run p_grava_falha(
                                 "fornecedor n�o cadastrado", 
                                 "fornecedor " + 
                                        trim(TI_TIT_APB.cod_id_feder) +  
                                        " Processo: " + string(TI_TIT_APB.nrseq_controle_integracao) +
                                        " Pessoa: " + string(TI_TIT_APB.nrpessoa)+  
                                        " fornecedor n�o cadastrado",
                                 002
                                 ).         
                 return.
              end.
              else do:
                 assign cod_unid_federac_par = "".
                 if TI_TIT_APB.ind_tipo_pessoa = "J"
                 then do:     
                    find ems5.pessoa_jurid where pessoa_jurid.num_pessoa_jurid = fornecedor.num_pessoa no-lock no-error.
                    if available pessoa_jurid then assign cod_unid_federac_par = pessoa_jurid.cod_unid_federac.
                 end.
                 if TI_TIT_APB.ind_tipo_pessoa = "F"
                 then do:     
                    find ems5.pessoa_fisic where pessoa_fisic.num_pessoa_fisic = fornecedor.num_pessoa no-lock no-error.
                    if available pessoa_fisic then assign cod_unid_federac_par = pessoa_fisic.cod_unid_federac.
                 end.
                 if cod_unid_federac_par = "" then do:       
                    run p_grava_falha(
                                     "Pessoa n�o cadastrada", 
                                     "Fornecedor " + string(fornecedor.cdn_fornecedor,"999999999"),
                                     003
                                     ).         
                    return.
                 end.
              end.
              find emsuni.pais where pais.cod_pais = fornecedor.cod_pais no-lock no-error.
              if not available pais then do:
                    run p_grava_falha(
                                     "Pais n�o cadastrada", 
                                     "Pais do fornecedor " + fornecedor.cod_pais +  " nao encontrado ",
                                     004
                                     ).         
                 return.
              end.
              find LAST histor_finalid_econ where histor_finalid_econ.cod_finalid_econ = pais.cod_finalid_econ_pais
                                              AND histor_finalid_econ.dat_inic_valid_finalid <= TODAY
                                no-lock no-error.
              if not available histor_finalid_econ then do:
                    run p_grava_falha(
                                     "Finalidade n�o cadastrada", 
                                     "Finalidade Economica do fornec " + string(emsuni.fornecedor.cdn_fornecedor,"999999999") +
                                             " nao encontrado na api044",
                                     005
                                     ).         
                   return.
              end.
              else assign cod_fornecedor_par        = fornecedor.cdn_fornecedor
                          cod_moeda_corrente_par = histor_finalid_econ.cod_indic_econ.                      
           end.
       end.
end procedure.
     
procedure trata-erros:
   def input  parameter cd-tipo-erro-par    as char no-undo.
   def output parameter lg-ocorreu-erro-par as log  no-undo.

RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@enviado P500(TRATA-ERROS)")  .

   case cd-tipo-erro-par:
      when "Enviado" then do:
         assign lg-ocorreu-erro-par = no.
RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@enviado P501")  .
           FOR EACH tt_log_erros_atualiz:                                                                                  
            assign lg-ocorreu-erro-par = yes.                                                                             

  RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@enviado P502 - DENTRO DO FOR EACH TT_LOG_ERROS_ATUALIZ")  .

            create TI_FALHA_DE_PROCESSO.
              assign
              TI_FALHA_DE_PROCESSO.CDIntegracao = "TI_TIT_APB"
              TI_FALHA_DE_PROCESSO.TXAJUDA = tt_log_erros_atualiz.ttv_des_msg_ajuda
              TI_FALHA_DE_PROCESSO.TXFALHA= tt_log_erros_atualiz.ttv_des_msg_erro
              TI_FALHA_DE_PROCESSO.NRMENSAGEM = tt_log_erros_atualiz.ttv_num_mensagem
              TI_FALHA_DE_PROCESSO.nrseq_controle_integracao = TI_TIT_APB.nrseq_controle_integracao.
                  assign lg-ocorreu-erro-par = yes.
RUN escrever-log(STRING(TI_FALHA_DE_PROCESSO.nrseq_controle_integracao) +  " @@@@@enviado P503: " + TI_FALHA_DE_PROCESSO.TXFALHA).
VALIDATE TI_FALHA_DE_PROCESSO.
RUN escrever-log(STRING(TI_FALHA_DE_PROCESSO.nrseq_controle_integracao) +  " @@@@@enviado P504 - APOS VALIDATE!: " + TI_FALHA_DE_PROCESSO.TXFALHA).

/*PAUSE.*/

         END.
      end.
      when "Nao enviado" then do:
RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@Nao enviado P100")  .
         assign lg-ocorreu-erro-par = yes.
         for each tp_erros:  
RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@Nao enviado P200" + tp_erros.ds_mensagem + " SEQ: " + STRING(TI_TIT_APB.nrseq_controle_integracao))  .
            create TI_FALHA_DE_PROCESSO.
            assign
               TI_FALHA_DE_PROCESSO.CDINTEGRACAO = "TI_TIT_APB".
               TI_FALHA_DE_PROCESSO.TXFALHA = tp_erros.ds_mensagem.
               TI_FALHA_DE_PROCESSO.NRMENSAGEM = tp_erros.cd_erro.
               TI_FALHA_DE_PROCESSO.nrseq_controle_integracao = TI_TIT_APB.nrseq_controle_integracao.
            assign lg-ocorreu-erro-par = yes.
         end.
      end.
      otherwise assign lg-ocorreu-erro-par = no.
   END case.
end procedure.
   
procedure cria-temporaria:
   def output parameter lg-ocorreu-erro-par as log no-undo.
  
   assign cd-referencia-aux = "I" +  string(TI_TIT_APB.nrseq_controle_integracao,"999999999").
   assign val-total-aux = 0.
   create tt_integr_apb_lote_impl.
   assign tt_integr_apb_lote_impl.tta_cod_estab                 = ""
          tt_integr_apb_lote_impl.tta_cod_estab_ext             = TI_TIT_APB.cod_estab
          tt_integr_apb_lote_impl.tta_cod_refer                 = cd-referencia-aux
          tt_integr_apb_lote_impl.tta_dat_transacao             = TI_TIT_APB.dat_emissao
          tt_integr_apb_lote_impl.tta_ind_origin_tit_ap         = "APB"
          tt_integr_apb_lote_impl.tta_cod_empresa               = TI_TIT_APB.cod_empresa
          tt_integr_apb_lote_impl.ttv_cod_empresa_ext           = ""
          tt_integr_apb_lote_impl.tta_cod_finalid_econ_ext      = ""
          tt_integr_apb_lote_impl.tta_cod_indic_econ            = ""
          tt_Integr_apb_lote_impl.tta_cod_espec_docto           = "". 
          
   release tt_integr_apb_lote_impl.
   find last tt_integr_apb_lote_impl where tt_integr_apb_lote_impl.tta_cod_estab = ""
                                       and tt_integr_apb_lote_impl.tta_cod_refer = cd-referencia-aux no-error.
   create tt_integr_apb_item_lote_impl_3.
   assign tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_lote_impl = recid(tt_integr_apb_lote_impl)
          tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = recid(tt_integr_apb_item_lote_impl_3)
          tt_integr_apb_item_lote_impl_3.tta_num_seq_refer            = 10
          tt_integr_apb_item_lote_impl_3.tta_cdn_fornecedor           = cod_fornecedor_aux
          tt_integr_apb_item_lote_impl_3.tta_cod_espec_docto          = TI_TIT_APB.cod_espec_docto
          tt_integr_apb_item_lote_impl_3.tta_cod_ser_docto            = TI_TIT_APB.cod_ser_docto
          tt_integr_apb_item_lote_impl_3.tta_cod_tit_ap               = substring(TI_TIT_APB.cod_titulo_ap,1,10)
          tt_integr_apb_item_lote_impl_3.tta_cod_parcela              = TI_TIT_APB.cod_parcela
          tt_integr_apb_item_lote_impl_3.tta_dat_emis_docto           = TI_TIT_APB.dat_emissao
          tt_integr_apb_item_lote_impl_3.tta_dat_vencto_tit_ap        = TI_TIT_APB.dat_vencto
          tt_integr_apb_item_lote_impl_3.tta_dat_prev_pagto           = TI_TIT_APB.dat_previsao_pagto 
          tt_integr_apb_item_lote_impl_3.tta_dat_desconto             = TI_TIT_APB.dat_desconto
          tt_integr_apb_item_lote_impl_3.tta_cod_indic_econ           = cod_moeda_corrente_aux
          tt_integr_apb_item_lote_impl_3.tta_val_tit_ap               = TI_TIT_APB.val_titulo
          tt_integr_apb_item_lote_impl_3.tta_val_desconto             = TI_TIT_APB.val_desconto
          tt_integr_apb_item_lote_impl_3.tta_val_perc_desc            = TI_TIT_APB.val_per_desc
          tt_integr_apb_item_lote_impl_3.tta_num_dias_atraso          = TI_TIT_APB.num_dias_atraso
          tt_integr_apb_item_lote_impl_3.tta_val_juros_dia_atraso       = TI_TIT_APB.val_juros
          tt_integr_apb_item_lote_impl_3.tta_val_perc_juros_dia_atraso  = TI_TIT_APB.val_perc_juros_dia_atraso
          tt_integr_apb_item_lote_impl_3.tta_val_perc_multa_atraso      = TI_TIT_APB.val_perc_multa_atraso
          tt_integr_apb_item_lote_impl_3.tta_cod_portador             = TI_TIT_APB.cod_portador
          tt_integr_apb_item_lote_impl_3.tta_cod_apol_seguro          = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_seguradora           = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_arrendador           = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_contrat_leas         = ""
          tt_integr_apb_item_lote_impl_3.tta_num_id_tit_ap            = 0
          tt_integr_apb_item_lote_impl_3.tta_num_id_movto_tit_ap      = 0
          tt_integr_apb_item_lote_impl_3.tta_num_id_movto_cta_corren  = 0
          tt_integr_apb_item_lote_impl_3.tta_num_dias                 = 0 
          tt_integr_apb_item_lote_impl_3.ttv_ind_vencto_previs        = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_finalid_econ_ext     = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_portad_ext           = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_modalid_ext          = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_forma_pagto          = TI_TIT_APB.cod_forma_pagto
          tt_integr_apb_item_lote_impl_3.tta_val_cotac_indic_econ     = 0
          tt_integr_apb_item_lote_impl_3.ttv_num_ord_invest           = 0
          tt_integr_apb_item_lote_impl_3.tta_cod_livre_1              = ""
          tt_integr_apb_item_lote_impl_3.tta_cod_livre_2              = ""
          tt_integr_apb_item_lote_impl_3.tta_dat_livre_1              = ?
          tt_integr_apb_item_lote_impl_3.tta_dat_livre_2              = ?
          tt_integr_apb_item_lote_impl_3.tta_log_livre_1              = no
          tt_integr_apb_item_lote_impl_3.tta_log_livre_2              = no
          tt_integr_apb_item_lote_impl_3.tta_num_livre_1              = 0
          tt_integr_apb_item_lote_impl_3.tta_num_livre_2              = 0
          tt_integr_apb_item_lote_impl_3.tta_val_livre_1              = 0
          tt_integr_apb_item_lote_impl_3.tta_val_livre_2              = 0
          tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote = ?
          tt_integr_apb_item_lote_impl_3.ttv_val_1099                 = 0 
          tt_integr_apb_item_lote_impl_3.tta_cod_tax_ident_number     = ""
          tt_integr_apb_item_lote_impl_3.tta_ind_tip_trans_1099       = ""
          tt_integr_apb_item_lote_impl_3.tta_des_text_histor          =  TI_TIT_APB.des_text_histor
          tt_integr_apb_item_lote_impl_3.ttv_qtd_parc_tit_ap          = 1
          tt_integr_apb_item_lote_impl_3.ttv_ind_vencto_previs        = ""
          tt_integr_apb_item_lote_impl_3.ttv_log_gerad                = no
          tt_integr_apb_item_lote_impl_3.tta_cod_cart_bcia            = TI_TIT_APB.cod_cart_bcia.   
                 
   assign tt_integr_apb_lote_impl.tta_val_tot_lote_impl_tit_ap  = 0 /* TI_TIT_APB.val_titulo */.

   assign cod_imposto_aux       = ""
          cod_classif_impto_aux = "".
    

   for each TI_TIT_APB_IMPOSTO where   TI_TIT_APB_IMPOSTO.nrseq_controle_integracao  = TI_TIT_APB.nrseq_controle_integracao  and
                                       TI_TIT_APB_IMPOSTO.CDSITUACAO   <> "CA":
      find first TI_TIT_APB_CTBL where TI_TIT_APB_CTBL.nrseq_controle_integracao  = TI_TIT_APB.nrseq_controle_integracao and
                                           TI_TIT_APB_CTBL.CDSITUACAO   <> "CA" no-lock no-error.
                                           
      if available TI_TIT_APB_CTBL 
      then assign cod_tip_fluxo_financ_aux = TI_TIT_APB_CTBL.cod_tip_fluxo_financ.
      else assign cod_tip_fluxo_financ_aux = "".
  
          
      if TI_TIT_APB_IMPOSTO.cod_imposto = "0588" or
         TI_TIT_APB_IMPOSTO.cod_imposto = "1708"
      then assign cod_imposto_aux       = TI_TIT_APB_IMPOSTO.cod_imposto
                  cod_classif_impto_aux = TI_TIT_APB_IMPOSTO.cod_classif_impto.

      run busca-favorecido(output cod_favorecido_imposto_aux,
                           output cod_uf_imposto_aux,
                           output lg-ocorreu-erro-AUX).
RUN escrever-log(STRING(TI_TIT_APB.NRSEQ_CONTROLE_INTEGRACAO) +  " @@@@@P9: " + STRING(lg-ocorreu-erro-aux))  .
                           

      if not lg-ocorreu-erro-aux then do:
         find tt_integr_apb_impto_impl_pend where
                  tt_integr_apb_impto_impl_pend.ttv_rec_integr_apb_item_lote   = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote and
                  tt_integr_apb_impto_impl_pend.tta_cod_pais                   = cod_pais_aux                          and
                  tt_integr_apb_impto_impl_pend.tta_cod_unid_federac           = "" /* cod_uf_imposto_aux */                    and
                  tt_integr_apb_impto_impl_pend.tta_cod_imposto                = TI_TIT_APB_IMPOSTO.cod_imposto      and
                  tt_integr_apb_impto_impl_pend.tta_cod_classif_impto          = TI_TIT_APB_IMPOSTO.cod_classif_impto  no-error.
         if not available tt_integr_apb_impto_impl_pend then do:        
            create tt_integr_apb_impto_impl_pend.
            assign tt_integr_apb_impto_impl_pend.ttv_rec_integr_apb_item_lote  = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote
                   tt_integr_apb_impto_impl_pend.tta_cod_pais                  = "" /* cod_uf_imposto_aux */
                   tt_integr_apb_impto_impl_pend.tta_cod_imposto               = TI_TIT_APB_IMPOSTO.cod_imposto
                   tt_integr_apb_impto_impl_pend.tta_cod_classif_impto         = TI_TIT_APB_IMPOSTO.cod_classif_impto 
                   tt_integr_apb_impto_impl_pend.tta_cdn_fornec_favorec        = cod_favorecido_imposto_aux
                   tt_integr_apb_impto_impl_pend.tta_cod_plano_cta_ctbl        = TI_TIT_APB.COD_PLANO_CTA_CTBL
                   tt_integr_apb_impto_impl_pend.tta_cod_cta_ctbl              = ""
                   tt_integr_apb_impto_impl_pend.tta_dat_vencto_tit_ap         = TI_TIT_APB_IMPOSTO.dat_vencto
                   tt_integr_apb_impto_impl_pend.tta_cod_indic_econ            = cod_moeda_corrente_aux
                   tt_integr_apb_impto_impl_pend.tta_cod_ser_docto             = TI_TIT_APB.cod_ser_docto
                   tt_integr_apb_impto_impl_pend.tta_cod_tit_ap                = substring(TI_TIT_APB.cod_titulo_ap,1,10)
                   tt_integr_apb_impto_impl_pend.tta_cod_parcela              = TI_TIT_APB.cod_parcela
                   tt_Integr_apb_impto_impl_pend.tta_num_id_tit_ap             = 0
                   tt_Integr_apb_impto_impl_pend.tta_num_id_movto_tit_ap       = 0
                   tt_Integr_apb_impto_impl_pend.tta_num_id_movto_cta_corren   = 0
                   tt_Integr_apb_impto_impl_pend.tta_cod_pais_ext              = ""
                   tt_Integr_apb_impto_impl_pend.tta_cod_cta_ctbl_ext          = ""
                   tt_Integr_apb_impto_impl_pend.tta_cod_sub_cta_ctbl_ext      = ""
                   tt_Integr_apb_impto_impl_pend.ttv_cod_tip_fluxo_financ_ext  = cod_tip_fluxo_financ_aux
                   tt_integr_apb_impto_impl_pend.tta_cod_pais                  = COD_PAIS_AUX.
                   
         end.
                           
           
         assign tt_integr_apb_impto_impl_pend.tta_val_base_liq_impto         = tt_integr_apb_impto_impl_pend.tta_val_base_liq_impto +
                                                                               TI_TIT_APB_IMPOSTO.val_base_liq_impto
                tt_integr_apb_impto_impl_pend.tta_val_aliq_impto             = tt_integr_apb_impto_impl_pend.tta_val_aliq_impto     +
                                                                               TI_TIT_APB_IMPOSTO.val_aliq_impto
                tt_integr_apb_impto_impl_pend.tta_val_rendto_tribut          = tt_integr_apb_impto_impl_pend.tta_val_rendto_tribut  +
                                                                               TI_TIT_APB_IMPOSTO.val_rendto_tribut
                tt_integr_apb_impto_impl_pend.tta_val_imposto                = tt_integr_apb_impto_impl_pend.tta_val_imposto       +
                                                                               TI_TIT_APB_IMPOSTO.val_imposto
                tt_integr_apb_impto_impl_pend.tta_val_impto_indic_econ_impto = tt_integr_apb_impto_impl_pend.tta_val_impto_indic_econ_impto +
                                                                               TI_TIT_APB_IMPOSTO.val_imposto
                tt_Integr_apb_impto_impl_pend.tta_val_deduc_inss             = tt_Integr_apb_impto_impl_pend.tta_val_deduc_inss +
                                                                               TI_TIT_APB_IMPOSTO.val_deduc_inss  
                tt_Integr_apb_impto_impl_pend.tta_val_deduc_depend           = tt_Integr_apb_impto_impl_pend.tta_val_deduc_depend +
                                                                               TI_TIT_APB_IMPOSTO.val_deduc_depend
                tt_Integr_apb_impto_impl_pend.tta_val_deduc_pensao           = tt_Integr_apb_impto_impl_pend.tta_val_deduc_pensao  +
                                                                               TI_TIT_APB_IMPOSTO.val_deduc_pensao
                tt_Integr_apb_impto_impl_pend.tta_val_outras_deduc_impto     = TI_TIT_APB_IMPOSTO.val_outras_deduc_impto  +
                                                                               tt_Integr_apb_impto_impl_pend.tta_val_outras_deduc_impto 
                tt_Integr_apb_impto_impl_pend.tta_val_impto_ja_recolhid      = tt_Integr_apb_impto_impl_pend.tta_val_impto_ja_recolhid +
                                                                               TI_TIT_APB_IMPOSTO.val_impto_ja_recolhid                
                tt_Integr_apb_impto_impl_pend.tta_val_deduc_faixa_impto      = tt_Integr_apb_impto_impl_pend.tta_val_deduc_faixa_impto +
                                                                               TI_TIT_APB_IMPOSTO.val_deduc_faixa_impto.                                                                          	       
      end.
      else do:
         assign lg-ocorreu-erro-par = yes.
         return.
      end.
   end.    
             
   for each TI_TIT_APB_CTBL where  TI_TIT_APB_CTBL.nrseq_controle_integracao  = TI_TIT_APB.nrseq_controle_integracao and
                                      TI_TIT_APB_CTBL.CDSITUACAO   <> "CA" no-lock :
       if TI_TIT_APB_CTBL.cod_ccusto <> ""
       then assign cod_plano_ccusto_aux = TI_TIT_APB.Cod_plano_ccusto.
       else assign cod_plano_ccusto_aux = "".
       
       

       find tt_integr_apb_aprop_ctbl_pend where tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote   = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote
                                       and tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend  = ?
                                       and tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = TI_TIT_APB.COD_PLANO_CTA_CTBL
                                       and tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl_ext           = TI_TIT_APB_CTBL.cod_cta_ctbl
                                       and tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc             = cod_unid_negoc_aux            
                                       and tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto           = cod_plano_ccusto_aux
                                       and tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto_ext             = TI_TIT_APB_CTBL.cod_ccusto
                                       and tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ   = TI_TIT_APB_CTBL.cod_tip_fluxo_financ
                                         no-error.                        
      if not available tt_integr_apb_aprop_ctbl_pend then do:
         create tt_integr_apb_aprop_ctbl_pend.
         assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_item_lote   = tt_integr_apb_item_lote_impl_3.ttv_rec_integr_apb_item_lote
                tt_integr_apb_aprop_ctbl_pend.ttv_rec_integr_apb_impto_pend  = ?
                tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_cta_ctbl         = TI_TIT_APB.COD_PLANO_CTA_CTBL
                tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl_ext           = TI_TIT_APB_CTBL.cod_cta_ctbl
                tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc             = cod_unid_negoc_aux            
                tt_integr_apb_aprop_ctbl_pend.tta_cod_plano_ccusto           = cod_plano_ccusto_aux
                tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto_ext             = TI_TIT_APB_CTBL.cod_ccusto
                tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ       = TI_TIT_APB_CTBL.cod_tip_fluxo_financ.
      end.
          
      assign tt_integr_apb_aprop_ctbl_pend.ttv_rec_antecip_pef_pend       = ?   
             tt_integr_apb_aprop_ctbl_pend.tta_cod_pais                   = cod_pais_aux
             tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_federac           = cod_unid_federac_aux
             tt_integr_apb_aprop_ctbl_pend.tta_cod_imposto                = cod_imposto_aux
             tt_integr_apb_aprop_ctbl_pend.tta_cod_classif_impto          = cod_classif_impto_aux
             tt_integr_apb_aprop_ctbl_pend.ttv_cod_tip_fluxo_financ_ext   = TI_TIT_APB_CTBL.cod_tip_fluxo_financ
             tt_integr_apb_aprop_ctbl_pend.tta_cod_cta_ctbl               = TI_TIT_APB_CTBL.cod_cta_ctbl /*DIOGO*/
             tt_integr_apb_aprop_ctbl_pend.tta_cod_sub_cta_ctbl_ext       = ""
             tt_integr_apb_aprop_ctbl_pend.tta_cod_ccusto                 = TI_TIT_APB_CTBL.cod_ccusto /*Mango "" */             
             tt_integr_apb_aprop_ctbl_pend.tta_cod_unid_negoc_ext         = ""
             tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl             =  tt_integr_apb_aprop_ctbl_pend.tta_val_aprop_ctbl  +
                                                                             TI_TIT_APB_CTBL.val_aprop_ctbl.                                                                                                        
                                                                             
   end.

   assign lg-ocorreu-erro-par = no.
end procedure.

procedure busca-favorecido:
   def output parameter cod_favorecido_par            like emsuni.fornecedor.cdn_fornecedor no-undo.
   def output parameter cod_uf_favorecido_par         like impto_vincul_fornec.cod_unid_federac no-undo.
   def output parameter lg_ocorreu_erro_par as log no-undo.     

   find impto_vincul_fornec WHERE impto_vincul_fornec.cod_empresa       = TI_TIT_APB.cod_empresa    
                              AND impto_vincul_fornec.cdn_fornecedor    = cod_fornecedor_aux
                              AND impto_vincul_fornec.cod_pais          = cod_pais_aux
                              AND impto_vincul_fornec.cod_unid_federac  = cod_unid_federac_aux            
                              AND impto_vincul_fornec.cod_imposto       = TI_TIT_APB_IMPOSTO.cod_imposto                
                              AND impto_vincul_fornec.cod_classif_impto = TI_TIT_APB_IMPOSTO.cod_classif_impto 
                              no-lock no-error.                                         
             
                    
   IF NOT AVAIL impto_vincul_fornec                                           
   THEN FIND impto_vincul_fornec WHERE impto_vincul_fornec.cod_empresa       = TI_TIT_APB.cod_empresa    
                                   AND impto_vincul_fornec.cdn_fornecedor    = cod_fornecedor_aux
                                   AND impto_vincul_fornec.cod_pais          = cod_pais_aux
                                   AND impto_vincul_fornec.cod_unid_federac  = "  "                          
                                   AND impto_vincul_fornec.cod_imposto       = TI_TIT_APB_IMPOSTO.cod_imposto                
                                   AND impto_vincul_fornec.cod_classif_impto = TI_TIT_APB_IMPOSTO.cod_classif_impto          
                                               NO-LOCK NO-ERROR.                                                       
                                                                                                                                              
   IF NOT AVAIL impto_vincul_fornec
   THEN DO:
      create tp_erros.
      assign tp_erros.cd_erro = 005
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Imposto " + TI_TIT_APB_IMPOSTO.cod_imposto       + " " +
                                                 TI_TIT_APB_IMPOSTO.cod_classif_impto + " " +    
                                    " nao foi vinculado ao fornecedor " + STRING(COD_FORNECEDOR_AUX) .
      assign lg_ocorreu_erro_par = yes. 
      return.
   END.
                      
   FIND FIRST histor_impto_empres WHERE
               histor_impto_empres.cod_pais         = cod_pais_aux
           AND histor_impto_empres.cod_unid_federac = cod_unid_federac_aux
           AND histor_impto_empres.cod_imposto      = TI_TIT_APB_IMPOSTO.cod_imposto
           AND histor_impto_empres.cod_empresa      = TI_TIT_APB.cod_empresa
           AND histor_impto_empres.dat_inic_valid  <= TI_TIT_APB.dat_processamento
           AND histor_impto_empres.dat_fim_valid   >= TI_TIT_APB.dat_processamento
           NO-LOCK NO-ERROR.

   IF NOT AVAIL histor_impto_empres
   THEN FIND FIRST histor_impto_empres WHERE
               histor_impto_empres.cod_pais         = cod_pais_aux
           AND histor_impto_empres.cod_unid_federac = "  "
           AND histor_impto_empres.cod_imposto      = TI_TIT_APB_IMPOSTO.cod_imposto
           AND histor_impto_empres.cod_empresa      = TI_TIT_APB.cod_empresa
           AND histor_impto_empres.dat_inic_valid  <= TI_TIT_APB.dat_processamento
           AND histor_impto_empres.dat_fim_valid   >= TI_TIT_APB.dat_processamento
           NO-LOCK NO-ERROR.

   IF NOT AVAIL histor_impto_empres
   THEN DO:
      create tp_erros.
      assign tp_erros.cd_erro = 005
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Favorecido nao cadastrado para o Imposto " + TI_TIT_APB_IMPOSTO.cod_imposto + " " +
                                                                                  TI_TIT_APB_IMPOSTO.cod_classif_impto + " " +    
                                    " fornecedor " + string(cod_fornecedor_aux,"999999999").
      assign lg_ocorreu_erro_par = yes. 
      return.
   END.

   assign cod_favorecido_par     = histor_impto_empres.cdn_fornec_favorec
          cod_uf_favorecido_par  = impto_vincul_fornec.cod_unid_federac.
   ASSIGN lg_ocorreu_erro_par = no.
end.

procedure busca-unidade-negocio:
   def output parameter cod_unid_negoc_par like estab_unid_negoc.cod_unid_negoc.
   def output parameter lg_ocorreu_erro_par as log no-undo.
/*
   find estunemp where estunemp.cod-estabel = TI_TIT_APB.cod_estab no-lock no-error.
   if not avail estunemp
   then do: 
      create tp_erros.
      assign tp_erros.cd_erro = 006
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Unidade x Empresa nao cadastrada no estabelecimento " + TI_TIT_APB.cod_estab.
      assign lg_ocorreu_erro_par = yes. 
      return.
   end.

   find first estab_unid_negoc where estab_unid_negoc.cod_estab       = estunemp.cod-estabel
                                 and estab_unid_negoc.cod_unid_negoc  = estunemp.cd-unidade-negocio
                                 and estab_unid_negoc.dat_inic_valid <= TI_TIT_APB.dat_processamento
                                 and estab_unid_negoc.dat_fim_valid  >= TI_TIT_APB.dat_processamento no-lock no-error.                     
   if not avail estab_unid_negoc
   then do:
      create tp_erros.
      assign tp_erros.cd_erro = 007
             tp_erros.tp_erro = "*** ERRO"
             tp_erros.ds_mensagem = "Estabelecimento x Unidade de Negocio nao cadastrada ou fora de validade " + 
                                    TI_TIT_APB.cod_estab + " " + 
                                    estunemp.cd-unidade-negocio + " " +
                                    string(TI_TIT_APB.dat_processamento,"99/99/9999").
      assign lg_ocorreu_erro_par = yes. return 
   end.
   assign cod_unid_negoc_par = estab_unid_negoc.cod_unid_negoc.                    
 */
   assign cod_unid_negoc_par = "UN".
   assign lg_ocorreu_erro_par = no.
end procedure.

PROCEDURE escrever-log:
  DEFINE input PARAMETER ds-msg-par AS char NO-UNDO.
END PROCEDURE.
               

/* ---------------------------------------------------------- */
/* ---------------------------------------------------- EOF - */
/* ---------------------------------------------------------- */
