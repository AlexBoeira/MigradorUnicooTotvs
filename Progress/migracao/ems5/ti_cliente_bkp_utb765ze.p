DEF INPUT PARAM in-status-par AS CHAR NO-UNDO.
/* -------------------------------------------------------------------- */

/* -------------------------------------------------------------------- */                                                       
/* -------------------------------------------------------------------- */
{ems5\deftemps.i}
define variable i-tt-favorecido as handle no-undo.

def var ind_estado_civil_aux         as char                            no-undo.
def var ttv_num_tip_operac-aux       as int                             no-undo.
def var ind_tipo_pessoa_juridica-aux as char initial "PRIVADA"          no-undo.
def var cod_id_feder_aux             like pessoa_jurid.cod_id_feder     no-undo.
def var cod_cliente_aux              like cliente.cdn_cliente           no-undo.
def var cod_fornecedor_aux           like cliente.cdn_cliente           no-undo.
def var num_pessoa_aux               like pessoa_jurid.num_pessoa_jurid no-undo.
def var lg-ocorreu-erro              as log                             no-undo.

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
    
    /**
     * Sai a cada 500 registros processados. 
     * Essa parada ajuda a evitar estouro de instancias da utb em memoria.
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
                                   when "Q" then assign ind_estado_civil_aux = "DESQUITADO".
                                   when "D" then assign ind_estado_civil_aux = "DIVORCIADO".
                                   otherwise assign ind_estado_civil_aux = "OUTROS".
                                end.
                                      
                                run cria_temporaria. 
                                
                                if lg-ocorreu-erro = no 
                                then do:
                                       /*
                                       OUTPUT TO c:\temp\tt_telef_pessoa_integr.csv APPEND.
                                       FOR EACH tt_telef_pessoa_integr:
                                           EXPORT DELIMITER ";" tt_telef_pessoa_integr.
                                       END.
                                       OUTPUT CLOSE.
                                       OUTPUT TO c:\temp\tt_fornecedor_integr.csv APPEND.
                                       FOR EACH tt_fornecedor_integr:
                                           EXPORT DELIMITER ";" tt_fornecedor_integr.
                                       END.
                                       OUTPUT CLOSE.
                                       OUTPUT TO c:\temp\tt_pessoa_fisic_integr_e.csv APPEND.
                                       FOR EACH tt_pessoa_fisic_integr_e:
                                           EXPORT DELIMITER ";" tt_pessoa_fisic_integr_e.
                                       END.
                                       OUTPUT CLOSE.
                                       OUTPUT TO c:\temp\tt_cliente_integr.csv APPEND.
                                       FOR EACH tt_cliente_integr:
                                           EXPORT DELIMITER ";" tt_cliente_integr.
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
                                       OUTPUT TO c:\temp\tt_fornec_financ_integr_d.csv APPEND.
                                       FOR EACH tt_fornec_financ_integr_d:
                                           EXPORT DELIMITER ";" tt_fornec_financ_integr_d.
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
                                       OUTPUT TO c:\temp\tt_pessoa_jurid_integr_e.csv APPEND.
                                       FOR EACH tt_pessoa_jurid_integr_e:
                                           EXPORT DELIMITER ";" tt_pessoa_jurid_integr_e.
                                       END.
                                       OUTPUT CLOSE.
                                       OUTPUT TO c:\temp\tt_pj_ativid_integr.csv APPEND.
                                       FOR EACH tt_pj_ativid_integr:
                                           EXPORT DELIMITER ";" tt_pj_ativid_integr.
                                       END.
                                       OUTPUT CLOSE.
                                       OUTPUT TO c:\temp\tt_pj_ramo_negoc_integr.csv APPEND.
                                       FOR EACH tt_pj_ramo_negoc_integr:
                                           EXPORT DELIMITER ";" tt_pj_ramo_negoc_integr.
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
                                
                                       run prgint\utb\utb765ze.py(input 1,
                                                                  input table tt_cliente_integr,
                                                                  input table tt_fornecedor_integr,
                                                                  input table tt_clien_financ_integr_e,
                                                                  input table tt_fornec_financ_integr_d,
                                                                  input table tt_pessoa_jurid_integr_e,
                                                                  input table tt_pessoa_fisic_integr_e,
                                                                  input table tt_contato_integr_e,
                                                                  input table tt_contat_clas_integr,
                                                                  input table tt_estrut_clien_integr,
                                                                  input table tt_estrut_fornec_integr,
                                                                  input table tt_histor_clien_integr,
                                                                  input table tt_histor_fornec_integr,
                                                                  input table tt_ender_entreg_integr_e,
                                                                  input table tt_telef_integr,
                                                                  input table tt_telef_pessoa_integr,
                                                                  input table tt_pj_ativid_integr,
                                                                  input table tt_pj_ramo_negoc_integr,
                                                                  input table tt_porte_pj_integr,
                                                                  input table tt_idiom_pf_integr,           
                                                                  input table tt_idiom_contat_integr,                                           
                                                                  input "EMS2" /*"SERIOUS"*/ ,
                                                                  input "1",
                                                                  input-output table tt_retorno_clien_fornec).
                                       
                                       for each tt_retorno_clien_fornec no-lock:
                                           run p_grava_falha(tt_retorno_clien_fornec.ttv_des_ajuda,
                                                             tt_retorno_clien_fornec.ttv_des_mensagem,
                                                             tt_retorno_clien_fornec.ttv_num_mensagem).
                                       end.
                                     END.
                              END.
                       END.
                END. /* avail ti_pessoa */
         END.

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
    empty temp-table tt_cliente_integr.
    empty temp-table tt_fornecedor_integr.
    empty temp-table tt_clien_financ_integr_e.
    empty temp-table tt_fornec_financ_integr_d.
    empty temp-table tt_pessoa_jurid_integr_e.
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
    empty temp-table tt_pj_ativid_integr.
    empty temp-table tt_pj_ramo_negoc_integr.
    empty temp-table tt_porte_pj_integr.
    empty temp-table tt_idiom_pf_integr.
    empty temp-table tt_idiom_contat_integr.
    empty temp-table tt_retorno_clien_fornec.
/*    empty TEMP-TABLE tt_clien_analis_cr_integr. */
end procedure.

/*================================*/
/* Gravar as falhas da integra»’o */
/*--------------------------------*/
procedure p_grava_falha:

    def input  parameter ptxajuda           like ti_falha_de_processo.txajuda   no-undo.
    def input  parameter ptxfalha           like ti_falha_de_processo.txfalha   no-undo.
    def input  parameter pnrmensagem        like ti_falha_de_processo.nrmensagem   no-undo. 

    if pnrmensagem <> 6279 then do: /* Tratando o retorno de sucesso de integracao */

      assign lg-ocorreu-erro = yes.
    
      create ti_falha_de_processo. 
               assign
               ti_falha_de_processo.cdintegracao              = "TI_CLIENTE"
               ti_falha_de_processo.txajuda                   = ptxajuda
               ti_falha_de_processo.txfalha                   = ptxfalha 
               ti_falha_de_processo.nrmensagem                = pnrmensagem
               ti_falha_de_processo.nrseq_controle_integracao = ti_cliente.nrseq_controle_integracao. 
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

   run grava_tt_pessoa_jurid_integr_e ( input cod_cliente_aux,
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

   create tt_cliente_integr.
   assign tt_cliente_integr.tta_cod_empresa         = ti_cliente.cod_empresa    
          tt_cliente_integr.tta_cdn_cliente         = cod_cliente_par 
          tt_cliente_integr.tta_num_pessoa          = num_pessoa_par  
          tt_cliente_integr.tta_nom_abrev           = ti_cliente.nom_abrev         
          tt_cliente_integr.tta_cod_grp_clien       = ti_cliente.cod_grp_clien
          tt_cliente_integr.tta_cod_tip_clien       = ti_cliente.cod_tip_clien                                
          tt_cliente_integr.tta_dat_impl_clien      = ti_cliente.dat_impl_clien    
          tt_cliente_integr.tta_cod_pais_ext        = ti_cliente.cod_pais_nasc     
          tt_cliente_integr.tta_cod_pais            = ti_cliente.cod_pais_nasc     
          tt_cliente_integr.tta_cod_id_feder        = cod_id_feder_par
          tt_cliente_integr.ttv_ind_pessoa          = ind_tipo_pessoa_par
          tt_cliente_integr.ttv_num_tip_operac      =  ttv_num_tip_operac-aux                               
          tt_cliente_integr.tta_log_ems_20_atlzdo   = no                                
          tt_cliente_integr.tta_cod_grp_clien       = ti_cliente.cod_grp_clien.
          /* tt_cliente_integr.ttv_ind_tip_pessoa_ems2 = ind_tipo_pessoa-aux         .*/        
          
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
          tt_clien_financ_integr_e.tta_cod_classif_msg_cobr      = '1' /*"Padrao"  */
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
  
procedure grava_tt_pessoa_jurid_integr_e:
   def input parameter cod_cliente_par    like cliente.cdn_cliente  no-undo.
   def input parameter num_pessoa_par     like pessoa_jurid.num_pessoa_jurid     no-undo.
   def input parameter cod_id_feder_par   like pessoa_jurid.cod_id_feder   no-undo.

   create tt_pessoa_jurid_integr_e.
   assign tt_pessoa_jurid_integr_e.tta_num_pessoa_jurid               = num_pessoa_par
             tt_pessoa_jurid_integr_e.tta_nom_pessoa                  = ti_cliente.nom_cliente
             tt_pessoa_jurid_integr_e.tta_cod_id_feder                = cod_id_feder_par
             tt_pessoa_jurid_integr_e.tta_cod_id_estad_jurid          = ti_cliente.cod_id_feder_estad_jurid
             tt_pessoa_jurid_integr_e.tta_cod_id_munic_jurid          = ti_cliente.cod_id_munic_jurid  
             tt_pessoa_jurid_integr_e.tta_cod_id_previd_social        = ti_cliente.cod_id_previd_social
             tt_pessoa_jurid_integr_e.tta_log_fins_lucrat             = if ti_cliente.log_fins_lucrat  = "S" then yes else no   
             tt_pessoa_jurid_integr_e.tta_num_pessoa_jurid_matriz     = 0
             tt_pessoa_jurid_integr_e.tta_nom_endereco                = ti_cliente.nom_endereco   
             tt_pessoa_jurid_integr_e.tta_nom_bairro                  = ti_cliente.nom_bairro     
             tt_pessoa_jurid_integr_e.tta_nom_cidade                  = ti_cliente.nom_cidade     
             tt_pessoa_jurid_integr_e.tta_nom_condado                 = ""
             tt_pessoa_jurid_integr_e.tta_cod_pais_ext                = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_e.tta_cod_pais                    = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_e.tta_cod_unid_federac            = ti_cliente.cod_unid_feder
             tt_pessoa_jurid_integr_e.tta_cod_cep                     = ti_cliente.cod_cep
             tt_pessoa_jurid_integr_e.tta_cod_cx_post                 = ti_cliente.cod_cx_post
             tt_pessoa_jurid_integr_e.tta_cod_telefone                = ti_cliente.cod_telefone_1
             tt_pessoa_jurid_integr_e.tta_cod_fax                     = ti_cliente.cod_fax
             tt_pessoa_jurid_integr_e.tta_cod_ramal_fax               = ti_cliente.cod_ramal_fax
             tt_pessoa_jurid_integr_e.tta_cod_telex                   = ""
             tt_pessoa_jurid_integr_e.tta_cod_modem                   = ""
             tt_pessoa_jurid_integr_e.tta_cod_ramal_modem             = ""
             tt_pessoa_jurid_integr_e.tta_cod_e_mail                  = ti_cliente.cod_e_mail
             tt_pessoa_jurid_integr_e.tta_des_anot_tab                = "" /*ti_cliente.dest_anot_tabela ESSE CAMPO PASSOU A SER USADO PARA TRATAR O ENDERECO COMPLETO */
             tt_pessoa_jurid_integr_e.tta_ind_tip_pessoa_jurid        = ind_tipo_pessoa_JURIDICA-aux
             tt_pessoa_jurid_integr_e.tta_ind_tip_capit_pessoa_jurid  = "Nacional" /* existem dois tipos Nacional e Muntinacional tem que abrir um campo na Tabela*/
             tt_pessoa_jurid_integr_e.tta_cod_imagem                  = ""
             tt_pessoa_jurid_integr_e.tta_log_ems_20_atlzdo           = no
             tt_pessoa_jurid_integr_e.ttv_num_tip_operac              =   ttv_num_tip_operac-aux 
             tt_pessoa_jurid_integr_e.tta_num_pessoa_jurid_cobr       = 0
             
             tt_pessoa_jurid_integr_e.tta_nom_ender_cobr              = ti_cliente.nom_endereco_cobr
             tt_pessoa_jurid_integr_e.tta_nom_bairro_cobr             = ti_cliente.nom_bairro_cobr
             tt_pessoa_jurid_integr_e.tta_nom_cidad_cobr              = ti_cliente.nom_cidade_cobr
             tt_pessoa_jurid_integr_e.tta_nom_condad_cobr             = ""
             tt_pessoa_jurid_integr_e.tta_cod_unid_federac_cobr       = ti_cliente.cod_unid_feder_cobr
             tt_pessoa_jurid_integr_e.ttv_cod_pais_ext_cob            = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_e.ttv_cod_pais_cobr               = ti_cliente.cod_pais_nasc
             tt_pessoa_jurid_integr_e.tta_cod_cep_cobr                = ti_cliente.cod_cep_cobr
             tt_pessoa_jurid_integr_e.tta_cod_cx_post_cobr            = ti_cliente.cod_cx_post_cobr
                 
             tt_pessoa_jurid_integr_e.tta_num_pessoa_jurid_pagto      = 0
             tt_pessoa_jurid_integr_e.tta_nom_ender_pagto             = ""
             tt_pessoa_jurid_integr_e.tta_nom_ender_compl_pagto       = ""
             tt_pessoa_jurid_integr_e.tta_nom_bairro_pagto            = ""
             tt_pessoa_jurid_integr_e.tta_nom_cidad_pagto             = ""
             tt_pessoa_jurid_integr_e.tta_nom_condad_pagto            = ""
             tt_pessoa_jurid_integr_e.tta_cod_unid_federac_pagto      = ""
             tt_pessoa_jurid_integr_e.ttv_cod_pais_ext_pag            = ""
             tt_pessoa_jurid_integr_e.ttv_cod_pais_pagto              = ""
             tt_pessoa_jurid_integr_e.tta_cod_cep_pagto               = ""
             tt_pessoa_jurid_integr_e.tta_cod_cx_post_pagto           = ""
             tt_pessoa_jurid_integr_e.ttv_rec_fiador_renegoc          = ?
             tt_pessoa_jurid_integr_e.ttv_log_altera_razao_social     = YES
             tt_pessoa_jurid_integr_e.tta_nom_home_page               = ""
             tt_pessoa_jurid_integr_e.tta_nom_ender_cobr_text         = TI_CLIENTE.DEST_ANOT_TABELA /* endereco completo (logradouro + numero + complemento + bairro) sem abreviacoes */
             tt_pessoa_jurid_integr_e.tta_nom_ender_pagto_text        = ""                  
             /* tt_pessoa_jurid_integr_e.tta_cdn_fornecedor               = 0    
             tt_pessoa_jurid_integr_e.ttv_ind_tip_pessoa_ems2         = "Jurðdica" */ 
             tt_pessoa_jurid_integr_e.tta_nom_ender_text              = TI_CLIENTE.DEST_ANOT_TABELA /* endereco completo (logradouro + numero + complemento + bairro) sem abreviacoes */
             substring(tt_pessoa_jurid_integr_e.tta_nom_ender_text,1991,9) = string(cod_cliente_par,"999999999").
                          
   IF ti_cliente.nom_ender_compl <> ?
   THEN tt_pessoa_jurid_integr_e.tta_nom_ender_compl             = ti_cliente.nom_ender_compl.
   else tt_pessoa_jurid_integr_e.tta_nom_ender_compl             = "".

   IF ti_cliente.nom_ender_compl_cobr <> ?
   THEN tt_pessoa_jurid_integr_e.tta_nom_ender_compl_cobr        = ti_cliente.nom_ender_compl_cobr.
   else tt_pessoa_jurid_integr_e.tta_nom_ender_compl_cobr        = "".

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
                  tt_pessoa_fisic_integr_e.tta_cod_pais_ext                   = ti_cliente.cod_pais_nasc 
                  tt_pessoa_fisic_integr_e.tta_cod_pais                       = ti_cliente.cod_pais_nasc 
                  tt_pessoa_fisic_integr_e.tta_cod_unid_federac               = ti_cliente.cod_unid_feder
                  tt_pessoa_fisic_integr_e.tta_cod_cep                        = ti_cliente.cod_cep       
                  tt_pessoa_fisic_integr_e.tta_cod_cx_post                    = ti_cliente.cod_cx_post   
                  
                  /*tt_pessoa_fisic_integr_e.tta_nom_ender_cobr                 = ti_cliente.nom_endereco_cobr
                  tt_pessoa_fisic_integr_e.tta_nom_bairro_cobr                = ti_cliente.nom_bairro_cobr
                  tt_pessoa_fisic_integr_e.tta_nom_cidad_cobr                 = ti_cliente.nom_cidade_cobr
                  tt_pessoa_fisic_integr_e.tta_nom_condad_cobr                = ""
                  tt_pessoa_fisic_integr_e.tta_cod_unid_federac_cobr          = ti_cliente.cod_unid_feder_cobr
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_ext_cob               = ti_cliente.cod_pais_nasc
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_cobr                  = ti_cliente.cod_pais_nasc
                  tt_pessoa_fisic_integr_e.tta_cod_cep_cobr                   = ti_cliente.cod_cep_cobr
                  tt_pessoa_fisic_integr_e.tta_cod_cx_post_cobr               = ti_cliente.cod_cx_post_cobr
                  */

                  tt_pessoa_fisic_integr_e.tta_cod_telefone                   = ti_cliente.cod_telefone_1
                  /*tt_pessoa_fisic_integr_e.tta_cod_ramal                      = */
                  tt_pessoa_fisic_integr_e.tta_cod_fax                        = ti_cliente.cod_fax       
                  tt_pessoa_fisic_integr_e.tta_cod_ramal_fax                  = ti_cliente.cod_ramal_fax
                  tt_pessoa_fisic_integr_e.tta_cod_telex                      =  ""
                  tt_pessoa_fisic_integr_e.tta_cod_modem                      =  ""  
                  tt_pessoa_fisic_integr_e.tta_cod_ramal_modem                =  ""
                  tt_pessoa_fisic_integr_e.tta_cod_e_mail                     = ""
                  tt_pessoa_fisic_integr_e.tta_dat_nasc_pessoa_fisic          = ti_cliente.dat_nascimento
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_ext_nasc              = ti_cliente.cod_pais_nasc
                  tt_pessoa_fisic_integr_e.ttv_cod_pais_nasc                  = ti_cliente.cod_pais_nasc
                  tt_pessoa_fisic_integr_e.tta_cod_unid_federac_nasc          = ti_cliente.COD_ID_FEDER_NASC
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

    IF ti_cliente.nom_ender_compl <> ?
    THEN tt_pessoa_fisic_integr_e.tta_nom_ender_compl                = ti_cliente.nom_ender_compl.
    else tt_pessoa_fisic_integr_e.tta_nom_ender_compl                = "".


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
