def temp-table tt_integr_acr_estorn_cancel no-undo
    field ttv_ind_niv_operac_acr           as character format "X(12)" label 
"N¡vel Opera‡Æo" column-label "N¡vel Opera‡Æo"
    field ttv_ind_tip_operac_acr           as character format "X(15)" label 
"Tipo Opera‡Æo" column-label "Tipo Opera‡Æo"
    field tta_cod_estab                    as character format "x(3)" label 
"Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" 
initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" 
initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field tta_cod_refer                    as character format "x(10)" label 
"Referˆncia" column-label "Referˆncia"
    field tta_dat_transacao                as date format "99/99/9999" 
initial today label "Data Transa‡Æo" column-label "Dat Transac"
    field tta_des_text_histor              as character format "x(2000)" 
label "Hist¢rico" column-label "Hist¢rico"
    index tt_id                            is primary unique
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_id_movto_tit_acr         ascending.

def temp-table tt_log_erros_estorn_cancel no-undo
    field tta_cod_estab                    as character format "x(3)" label 
"Estabelecimento" column-label "Estab"
    field tta_num_id_tit_acr               as integer format "9999999999" 
initial 0 label "Token Cta Receber" column-label "Token Cta Receber"
    field tta_num_id_movto_tit_acr         as integer format "9999999999" 
initial 0 label "Token Movto Tit  ACR" column-label "Token Movto Tit  ACR"
    field ttv_num_mensagem                 as integer format ">>>>,>>9" 
label "N£mero" column-label "N£mero Mensagem"
    field ttv_des_msg_erro                 as character format "x(60)" label 
"Mensagem Erro" column-label "Inconsistˆncia"
    field ttv_des_msg_ajuda                as character format "x(40)" label 
"Mensagem Ajuda" column-label "Mensagem Ajuda"
    index tt_relac_tit_acr
          tta_cod_estab                    ascending
          tta_num_id_tit_acr               ascending
          tta_num_id_movto_tit_acr         ascending
          ttv_num_mensagem                 ascending.


/****** LOGIN */
/**
 * Temporaria para tratar possiveis erros na tentativa de login.
 */
Def Temp-table tt_erros No-undo
    Field num-cod   As Integer
    Field desc-erro As Character Format "x(256)":U
	Field desc-arq  As Character.

/**
 * Variavel para tratar parametro de entrada.
 */

run fnd\btb\btapi910za.p(input "migracao", /*USUARIO*/
                         input "migracao", /*SENHA */
                         output table tt_erros). 

For Each tt_erros:
    RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ANTES DO MESSAGE DE ERRO DA BTAPI910ZA").
    RUN escrever-log("@@@@@Erro: " + String(tt_erros.num-cod) + " - ":U + tt_erros.desc-erro).
    RUN escrever-log ("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@DEPOIS DO MESSAGE DE ERRO DA BTAPI910ZA").
End.
/**/



FOR EACH tit_acr WHERE TIT_ACR.num_livre_1= 9 NO-LOCK:
                  
  FOR EACH movto_tit_acr USE-INDEX mvtttcr_id 
       WHERE movto_tit_acr.cod_estab = tit_acr.cod_estab AND
             movto_tit_acr.num_id_tit_acr = tit_acr.num_id_tit_acr NO-LOCK:
             
     CREATE tt_integr_acr_estorn_cancel.
     ASSIGN tt_integr_acr_estorn_cancel.ttv_ind_niv_operac_acr  = 'T¡tulo'
          tt_integr_acr_estorn_cancel.ttv_ind_tip_operac_acr    = 'Cancelamento'
          tt_integr_acr_estorn_cancel.tta_cod_estab             =  tit_acr.cod_estab
          tt_integr_acr_estorn_cancel.tta_num_id_tit_acr        =  tit_acr.num_id_tit_acr
          tt_integr_acr_estorn_cancel.tta_num_id_movto_tit_acr  =  movto_tit_acr.num_id_movto_tit_acr
          tt_integr_acr_estorn_cancel.tta_cod_refer             = '0'
          tt_integr_acr_estorn_cancel.tta_dat_transacao         =  tit_acr.dat_transacao
          tt_integr_acr_estorn_cancel.tta_des_text_histor       = 'Exclusao de titulos'.
  
   END.
  
END.
  
run prgfin/acr/acr715za.py (Input 1, Input table
tt_integr_acr_estorn_cancel, output table tt_log_erros_estorn_cancel).
  
OUTPUT TO c:\temp\elim_tiT-ACR.txt.
FOR EACH tt_log_erros_estorn_cancel NO-LOCK:
    PUT tt_log_erros_estorn_cancel.tta_cod_estab
        " "
        tt_log_erros_estorn_cancel.tta_num_id_tit_acr
        " "
        tt_log_erros_estorn_cancel.tta_num_id_movto_tit_acr
        " "
        tt_log_erros_estorn_cancel.ttv_num_mensagem
        " "
        tt_log_erros_estorn_cancel.ttv_des_msg_erro
        " "
        tt_log_erros_estorn_cancel.ttv_des_msg_ajuda
        SKIP.
END.
OUTPUT CLOSE.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-mensagem-par AS CHAR NO-UNDO.
END.
