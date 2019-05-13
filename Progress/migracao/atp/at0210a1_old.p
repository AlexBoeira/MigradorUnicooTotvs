/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AT0210A1 2.00.00.000 } /*** 010000 ***/ 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i }
&ENDIF

/******************************************************************************
    Programa .....: AT0210A1.p
    Data .........: 18/05/2015
    Empresa ......: TOTVS
    Programador ..: Jeferson Dal Molin
    Objetivo .....: Migracao das guias de autorizacao do Unicoo para o GPS
*-----------------------------------------------------------------------------*/

def input param in-batch-online-par          AS CHAR NO-UNDO.
DEF INPUT PARAM in-status-monitorar-par      AS CHAR NO-UNDO.
    
hide all no-pause.

{hdp/hdvarregua.i}
{hdp/hdregarquexe.i} 
{hdp/hdregarquexe.f} 
   
{hdp/hdvarrel.i}

{hdp/hdsistem.i}

def var lg-executa-aux              as log   format "Sim/Nao"              no-undo.
def var nr-reg-aux                  as dec                                 no-undo.
def var lg-erro-aux                 as log                                 no-undo.
def var ds-sit-ini-aux              as char                                no-undo.
def var ix                          as int                                 no-undo.
def var cd-esp-amb-aux              as int                                 no-undo.
def var cd-grupo-proc-amb-aux       as int                                 no-undo.
def var cd-procedimento-aux         as int                                 no-undo.
def var dv-procedimento-aux         as int                                 no-undo.
def var cd-modalidade-aux           like modalid.cd-modalidade             no-undo.
def var cd-plano-aux                as int                                 no-undo.
def var cd-tipo-plano-aux           as int                                 no-undo.
def var nr-ter-adesao-aux           like ter-ade.nr-ter-adesao             no-undo.
def var cd-usuario-aux              like usuario.cd-usuario                no-undo.
def var nr-indice-aux               like clashosp.nr-indice-hierarquico    no-undo.
def var cd-cla-hos-aux              like clashosp.cd-cla-hos               no-undo.
def var cd-vinculo-principal-aux    as int                                 no-undo.
def var cd-vinculo-solic-aux        as int                                 no-undo.
def var cd-tipo-insumo-aux          as int                                 no-undo.
def var cd-insumo-aux               as int                                 no-undo.
def var aa-guia-atendimento-aux     as int INIT 0                          no-undo.
def var nr-guia-atendimento-aux     as int                                 no-undo.
def var ds-observacao-aux           as char                                no-undo.
def var nr-guia-atend-ant-aux       as int                                 no-undo.
def var aa-guia-atend-ant-aux       as int                                 no-undo.
def var nr-processo-proc-aux        as int                                 no-undo.
def var nr-seq-digitacao-ins-aux    as int                                 no-undo.
def var id-face-dente-aux           as char                                no-undo.
def var lg-erro-vinculo-aux         as log                                 no-undo.
def var cd-vinculo-aux              as int                                 no-undo.
def var cd-unidade-prestador-aux    as int                                 no-undo.
def var cd-prestador-aux            as int                                 no-undo.
def var cd-esp-prest-executante-aux as int                                 no-undo.
def var in-tipo-guia-aux            as char                                no-undo.
def var nr-seq-guia-aux             as int                                 no-undo.
def var nr-seq-histor-aux           as int                                 no-undo.
def var cod-guia-unimed-intercam-aux as char                               no-undo.
def var lg-erro-guia-aux             as log                                no-undo.
def var lg-arquivo-aux               as log                                no-undo.
def var nr-guias-aux                 as dec format "99999999999"           no-undo.
def var ds-rodape                    as char format "x(132)"  init ""      no-undo.
def var ds-cabecalho                 as char format "x(30)"  initial ""    no-undo.
def var hand1                        as int                                no-undo.
DEF VAR cd-carteira-aux              AS DEC                                NO-UNDO.
DEF VAR cd-unidade-carteira-aux      AS INT                                NO-UNDO.
DEF VAR nr-carteira-aux              AS INT                                NO-UNDO.
def var cd-pacote                    as char format "99999999999"          no-undo. 
def var r-paproins                   as rowid.
def var cd-modalidade-prop-aux       like propost.cd-modalidade            no-undo.
def var cd-plano-prop-aux            like propost.cd-plano                 no-undo.
def var cd-tipo-plano-prop-aux       like propost.cd-tipo-plano            no-undo.
DEFINE VARIABLE char-aux1            AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE char-aux2            AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE char-aux3            AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE char-aux4            AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE char-aux5            AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE char-aux6            AS CHARACTER                          NO-UNDO.


def buffer b-import-guia for import-guia.

/* Temp que guarda o vinculo do prestador executante.
   Utilizada na criacao dos movimentos da guia */
def temp-table tmp-prest-exec no-undo
    field in-tipo-guia        as char /* Chave da guia */
    field val-seqcial         as dec  /* Chave da guia */
    field cd-unidade          as int
    field cd-prestador        as int
    field cd-espec            as int
    field cd-vinculo          as int
    field nm-prest-exec-compl as char
    field nm-conselho         as char
    field nr-registro         as int
    field uf-conselho         as char
    field cd-cbo              as char
    index tmp1
          in-tipo-guia
          val-seqcial.

def temp-table tmp-erro no-undo like erro-process-import.

IF in-batch-online-par = "ONLINE"
THEN DO:
       form header
            fill("-", 132) format "x(132)"                  skip
            ds-cabecalho                                    at 01
            "Relatorio de Erros"                            at 45
            "Folha:" at 123 page-number   format ">>9"            skip
            fill("-",110)                 format "x(110)"
            today format "99/99/9999"                      at 112
            "-"                                            at 123
            string(time,"hh:mm:ss")                        at 125 skip(01)
            with stream-io no-labels no-box page-top frame f-cabecalho width 132.
       
       form
           tmp-erro.num-seqcial-control column-label "Seq.Control."   format "999999999"
           tmp-erro.nom-tab-orig-erro   column-label "Tabela Origem"  format "x(20)" 
           tmp-erro.des-erro            column-label "Erro"           format "x(90)"
           with down stream-io no-box frame f-rel width 132.
       
       form header ds-rodape format "x(131)"
                   with stream-io no-labels no-box page-bottom frame f-rodape width 132.
     END.

nm-cab-usuario = "Migracao Guias de Autorizacao".
nm-prog        = " AT0210A1 ".
c-versao       = c_prg_vrs.
{hdp/hdlog.i}

{hdp/hdvararq.i "c:/temp" "AT0210A1" "ERR"}

/* ------------------- PROCEDURE GRAVA-ERRO --------------------- */
{atp/AT0210A.i}

/* -------------------------------------------------------------- */
{rtp/rtapi022.i "new shared" } /* ----------------- CARTEIRA DO BENEFICIARIO --- */
{rtp/rtapi024.i "new shared" } /* ------------------------ PRESTADOR VINCULO --- */
{rcp/rcapi025.i "new shared" } /* ----------------- ROTINA DA TABELA OUT-UNI --- */

find first paramecp no-lock no-error.

if not avail paramecp
then do:
       message "Parametros do sistema nao cadastrados."
           view-as alert-box title "Atencao!!!".
       return.
     end.

find unimed where unimed.cd-unimed = paramecp.cd-unimed no-lock no-error.

if available unimed
then assign ds-cabecalho   = unimed.nm-unimed.

find first paramrc no-lock no-error.

if not avail paramrc
then do:
       message "Parametros do modulo Revisao de Contas nao cadastrados."
           view-as alert-box title "Atencao!!!".
       return.
     end.

assign ds-rodape = " " + nm-prog + " - " + c-versao
   ds-rodape = fill("-", 132 - length(ds-rodape)) + ds-rodape.

{hdp/hdtitrel.i}

assign lg-arquivo-aux  = no.

/* -------------------------- BLOCO PRINCIPAL ---------------------- */
IF in-batch-online-par = "BATCH"
THEN DO:
       run importa-dados.
     END.
ELSE DO:
       repeat on endkey undo, next with frame f-AT0210A1:
          
          {hdp/hdbotarquexe.i}
       
           if c-opcao = "Arquivo"
           then do:
                  assign lg-arquivo-aux  = no.
       
                  {hdp/hdpedarq.i}
       
                  assign lg-arquivo-aux  = yes.
                end.
       
          if c-opcao = "Executa"
          then do:
                 if not lg-arquivo-aux
                 then do:
                        message "Voce deve passar pela opcao arquivo."
                            view-as alert-box title "Atencao !!!".
                        next.
                      end.
       
                 assign lg-executa-aux = no.
       
                 select count(*) into nr-reg-aux
                        from import-guia
                        where import-guia.ind-sit-import = in-status-monitorar-par. /* Recebido */
                 
                 message "Existem " nr-reg-aux " guias pendentes de migracao." skip
                         "Confirma a execucao?"
                     view-as alert-box question buttons yes-no title "Atencao!!!" update lg-executa-aux.
       
                 if not lg-executa-aux
                 then undo, retry.
       
                 RUN importa-dados.

                 /* ----------------------------------------------------------------------------- */
       
                 hide message no-pause.
       
                 if can-find(first tmp-erro)
                 then run gera-rel-erro.
       
                 if can-find(first tmp-erro)
                 then message "Processo concluido com erros. Verifique o relatorio de erros." skip
                              "Numero de guias criadas: " nr-guias-aux
                         view-as alert-box info buttons ok.
                 else message "Processo concluido." skip
                              "Numero de guias criadas: " nr-guias-aux
                         view-as alert-box info buttons ok.
          end.
       
          if c-opcao = "Fim"
          then do:
                 hide all no-pause.
                 leave.
               end.
       end.
     END.
/* ----------------------------------------------------------------- */

PROCEDURE importa-dados:
    message "Processando! Aguarde...".
    empty temp-table tmp-prest-exec.
    empty temp-table tmp-erro.

    assign nr-guias-aux = 0.

    /* ----------------------------------------------------------------------------- */
    for each import-guia where import-guia.ind-sit-import    = in-status-monitorar-par /* Recebido */
                           and import-guia.num-seqcial-princ = 0 /* Considera primeiro as guias principais */
                               no-lock:

        message "Importando Guia Princ.: " import-guia.num-seqcial-control " Sit: " in-status-monitorar-par.

        run importa-guias.

        if lg-erro-guia-aux
        then do:
               assign lg-erro-aux = yes.

               do transaction:
                   run atualiza-import-guia(input "PE", /* Erro */
                                            input paramecp.cd-unimed,    
                                            input aa-guia-atendimento-aux,
                                            input nr-guia-atendimento-aux).
               end.
             end.
    end.

    for each import-guia where import-guia.ind-sit-import    = in-status-monitorar-par /* Recebido */
                           and import-guia.num-seqcial-princ > 0 /* Considera as guias associadas */
                           AND CAN-FIND(FIRST b-import-guia
                                        WHERE b-import-guia.num-seqcial = import-guia.num-seqcial-princ
                                          AND b-import-guia.aa-guia-atendimento <> 0
                                          AND b-import-guia.nr-guia-atendimento <> 0)
                               no-lock:

        message "Importando Guia Assoc.: " import-guia.num-seqcial-control " Sit: " in-status-monitorar-par.

        run importa-guias.

        if lg-erro-guia-aux
        then do:
               assign lg-erro-aux = yes.

               do transaction:
                   run atualiza-import-guia(input "PE", /* Erro */
                                            input paramecp.cd-unimed,    
                                            input aa-guia-atendimento-aux,
                                            input nr-guia-atendimento-aux).
               end.
             end.
    end.            

END PROCEDURE.

/* ----------------------------------------------------------------- */
procedure importa-guias:

    run zera-vaiaveis-auxiliares.

    run consiste-dados-gerais(output lg-erro-guia-aux).

    if lg-erro-guia-aux
    then return.

    /* ----------------------- VALIDA DADOS TISS ---------------------------- */
    case trim(import-guia.ind-tip-guia):
        when "C" /* Consulta */
        then run valida-consulta(input-output lg-erro-guia-aux).

        when "S" /* SADT */
        then run valida-sp-sadt(input-output lg-erro-guia-aux).

        when "I" /* Internacao */
        then run valida-internacao(input-output lg-erro-guia-aux).

        when "P" /* Prorrogacao */
        then run valida-prorrogacao(input-output lg-erro-guia-aux).

        when "O" /* Odontologia */
        then run valida-odontologia(input-output lg-erro-guia-aux).
    end case.

    if lg-erro-guia-aux
    then return.

    /* --------------------- VALIDA ANEXOS CLINICOS TISS ----------------- */
    for each import-anexo-solicit 
       where import-anexo-solicit.num-seq-import = import-guia.num-seqcial
             no-lock:

        run valida-dados-gerais-anexos(input-output lg-erro-guia-aux).

        case trim(import-anexo-solicit.ind-tip-anexo):
            when "1" /* Quimioterapia */
            then run valida-quimioterapia(input-output lg-erro-guia-aux).

            when "2" /* Radioterapia */
            then run valida-radioterapia(input-output lg-erro-guia-aux).

            when "3" /* OPME */
            then run valida-opme(input-output lg-erro-guia-aux).

            when "4" /* Odontologia */
            then run valida-anexo-odonto(input-output lg-erro-guia-aux).
        end case.

/*TRATAR PARA CHECAR SE AGUIA É COMPLEMENTO. SE FOR, PREENCHER OS CAMPOS AA e NR-GUIA-ATENDIMENTO-ANT QUE SÃO TRATADOS 
NO CRIA-GUIA CHAMADO A SEGUIR
*/
        if lg-erro-guia-aux
        then next.
    end. /* each import-anexo-solicit */

    if lg-erro-guia-aux
    then return.

    do transaction:
        run cria-guia.
    end.

    if lg-erro-guia-aux
    then return.

    do transaction:
        run atualiza-import-guia(input "IT", /* Integrado */
                                 input paramecp.cd-unimed,
                                 input aa-guia-atendimento-aux,
                                 input nr-guia-atendimento-aux).
    end.

    assign nr-guias-aux = nr-guias-aux + 1.

end procedure.

/* ----------------------------------------------------------------- */
procedure zera-vaiaveis-auxiliares:

    assign cd-modalidade-aux        = 0
           nr-ter-adesao-aux        = 0
           cd-usuario-aux           = 0
           nr-indice-aux            = 0
           cd-cla-hos-aux           = 0
           cd-vinculo-principal-aux = 0
           cd-vinculo-solic-aux     = 0
           aa-guia-atend-ant-aux    = 0
           nr-guia-atend-ant-aux    = 0
           cd-plano-aux             = 0
           cd-tipo-plano-aux        = 0
           lg-erro-guia-aux         = no.

end procedure.

/* ----------------------------------------------------------------- */
procedure cria-guia:

    assign nr-guia-atendimento-aux = 0.

    run gera-seq-guia.

    assign cd-unidade-prestador-aux    = 0
           cd-prestador-aux            = 0
           cd-esp-prest-executante-aux = 0
           cd-vinculo-aux              = 0
           nr-processo-proc-aux        = 1
           nr-seq-digitacao-ins-aux    = 1.

    /* ---------------- Preenche prestador executante --------------------- */
    case trim(import-guia.ind-tip-guia):
        when "C" /* Consulta */
        then assign in-tipo-guia-aux = "CONS"
                    nr-seq-guia-aux  = import-guia-con.num-seqcial-guia.

        when "S" /* SADT */
        then assign in-tipo-guia-aux = "SADT"
                    nr-seq-guia-aux  = import-guia-sadt.val-seqcial.

        when "I" /* Internacao */
        then assign in-tipo-guia-aux = "INTE"
                    nr-seq-guia-aux  = import-guia-intrcao.num-seqcial-guia.
        
        when "P" /* Prorrogacao */
        then assign in-tipo-guia-aux = "PROR"
                    nr-seq-guia-aux  = import-guia-prorrog.num-seqcial-guia.
        
        when "O" /* Odontologia */
        then assign in-tipo-guia-aux = "ODON"
                    nr-seq-guia-aux  = import-guia-odonto.num-seqcial-guia.
    end case.

    find tmp-prest-exec where tmp-prest-exec.in-tipo-guia = in-tipo-guia-aux
                          and tmp-prest-exec.val-seqcial  = nr-seq-guia-aux 
                              no-lock no-error.

    if avail tmp-prest-exec
    then assign cd-unidade-prestador-aux    = tmp-prest-exec.cd-unidade
                cd-prestador-aux            = tmp-prest-exec.cd-prestador
                cd-esp-prest-executante-aux = tmp-prest-exec.cd-espec
                cd-vinculo-aux              = tmp-prest-exec.cd-vinculo.
    /* -------------------------------------------------------------------- */

    assign ds-observacao-aux = "Numero autorizacao Unicoo: "
                             + import-guia.cod-guia-operdra
                             + chr(10)
                             + fill("-",68)
                             + chr(10)
                             + import-guia.des-obs.

    RUN escrever-log("@@@@@criando guiautor ano: " + STRING(aa-guia-atendimento-aux) + " guia: " + STRING(nr-guia-atendimento-aux)).
    create guiautor.
    assign guiautor.cd-userid-auditor        = ""                                                     
           guiautor.cd-unidade               = paramecp.cd-unimed                                     
           guiautor.aa-guia-atendimento      = aa-guia-atendimento-aux                                
           guiautor.nr-guia-atendimento      = nr-guia-atendimento-aux                                
           guiautor.lg-guia-principal[1]     = (if import-guia.num-seqcial-princ = 0                  
                                                then yes                                              
                                                else no)                                              
           guiautor.cd-tipo-guia             = import-guia.cd-tipo-guia                               
           guiautor.cd-transacao             = import-guia.cd-transacao                               
           guiautor.dt-emissao-guia          = import-guia.dat-solicit  
           guiautor.dt-emissao               = import-guia.dat-solicit                                
           guiautor.cd-unidade-carteira      = cd-unidade-carteira-aux                        
           guiautor.cd-carteira-usuario      = cd-carteira-aux                         
           guiautor.cd-unidade-solicitante   = import-guia.cd-unidade-solic                           
           guiautor.cd-prestador-solicitante = int(import-guia.cd-prestador-solic)                        
           guiautor.cd-vinculo-solicitante   = cd-vinculo-solic-aux                                   
           guiautor.cd-especialid            = import-guia.cd-especialid                              
           guiautor.cd-cla-hos               = cd-cla-hos-aux                                         
           guiautor.cd-unidade-principal     = import-guia.cd-unidade-principal                       
           guiautor.cd-prestador-principal   = import-guia.cd-prestador-principal                     
           guiautor.cd-vinculo-principal     = cd-vinculo-principal-aux                               
           guiautor.dt-cancel-guia           = ?                                                      
           guiautor.cd-unidade-clinica       = paramecp.cd-unimed                                     
           guiautor.cd-clinica               = import-guia.cd-clinica                                 
           guiautor.dt-atualizacao           = today                                                  
           guiautor.cd-userid                = v_cod_usuar_corren                                     
           guiautor.ds-observacao            = ds-observacao-aux                                      
           guiautor.ds-observacao-interna    = ""                                                     
           guiautor.lg-via-orcamento         = no                                                     
           guiautor.log-12                   = no /* Via Reembolso? */                                
           guiautor.aa-guia-atendimento-ant  = aa-guia-atend-ant-aux                                  
           guiautor.nr-guia-atendimento-ant  = nr-guia-atend-ant-aux                                  
           guiautor.char-21                  = paramrc.char-25 /* Versao TISS */                      
           guiautor.nm-prof-sol              = trim(import-guia.nom-prestdor-solic)                   
           guiautor.char-14                  = trim(import-guia.cod-cons-profis)                      
           guiautor.char-17                  = trim(import-guia.ind-nume-cons)                        
           guiautor.char-18                  = caps(import-guia.uf-conselho)                          
           guiautor.char-19                  = trim(string(import-guia.cdn-cbo))                      
           guiautor.cd-modalidade            = cd-modalidade-aux                                      
           guiautor.nr-ter-adesao            = nr-ter-adesao-aux                                      
           guiautor.cd-usuario               = cd-usuario-aux                                         
           guiautor.in-liberado-guias        = import-guia.ind-sit-guia                               
           guiautor.nm-grupo-usuario         = import-guia.cod-livre-1                                
           guiautor.nm-grupo                 = import-guia.cod-livre-3                                
           guiautor.cd-local-autorizacao     = import-guia.num-livre-1
           guiautor.u-int-1                  = import-guia.num-seqcial
           guiautor.char-15                  = import-guia.cod-livre-1
           guiautor.date-2                   = import-guia.dat-livre-2
           guiautor.nr-via-carteira          = import-guia.nr-via-carteira.


    /* Informacoes Intercambio Eletronico */
    if import-guia.log-intercam-eletron
    then do:
           assign guiautor.ds-mens-intercambio = trim(import-guia.des-intercam)
                  guiautor.int-11              = 5. /* Procedencia SCS */

           /*assign cod-guia-unimed-intercam-aux = string(dec(import-guia.cod-guia-unimed-intercam),"9999999999"). */

           if import-guia.cd-unidade-carteira = paramecp.cd-unimed
           then do:
                  assign guiautor.in-envio-intercambio = "EnvioOrigem".

                  /* --------------------- GUIA SOLIC -------------------------------------- */
                  find first unimed where unimed.cd-unimed = import-guia.cd-unidade-carteira no-lock no-error.

                  if   avail unimed
                  and  unimed.lg-tem-serious 
                  then assign guiautor.aa-guia-atend-solic = int(substring(string(year(today)),1,2)
                                                           + substring(import-guia.cod-guia-unimed-intercam,1,2))
                              guiautor.nr-guia-atend-solic = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).
                  else do:
                         if length(trim(import-guia.cod-guia-unimed-intercam)) > 8
                         then do:
                                if length(trim(import-guia.cod-guia-unimed-intercam)) > 9
                                then assign guiautor.aa-guia-atend-solic = int("00" + substring(import-guia.cod-guia-unimed-intercam,1,2))
                                            guiautor.nr-guia-atend-solic = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).
                                else assign guiautor.aa-guia-atend-solic = int("000" + substring(import-guia.cod-guia-unimed-intercam,1,1))
                                            guiautor.nr-guia-atend-solic = int(substring(import-guia.cod-guia-unimed-intercam,2,8)).
                              end.
                         else assign guiautor.aa-guia-atend-solic = 0
                                     guiautor.nr-guia-atend-solic = int(string(import-guia.cod-guia-unimed-intercam)).
                       end.
                end.
           else do:
                  assign guiautor.in-receb-intercambio = "RecebidoDestino".

                  find first unimed where unimed.cd-unimed = cd-unidade-prestador-aux no-lock no-error.

                  /*if   avail unimed
                  and  unimed.lg-tem-serious
                  then assign guiautor.aa-guia-atend-origem = int(substring(string(year(today)), 1, 2) + substring(import-guia.cod-guia-unimed-intercam,39,02))
                              guiautor.nr-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,41,08)).
                  else assign guiautor.aa-guia-atend-origem = int("00" + substring(import-guia.cod-guia-unimed-intercam,1,2))
                              guiautor.nr-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).*/

                  /* JP */

                  if length(string(import-guia.cod-guia-unimed-intercam)) <= 8
                  then assign guiautor.nr-guia-atend-origem = int(import-guia.cod-guia-unimed-intercam).              

                  if length(string(import-guia.cod-guia-unimed-intercam)) = 9                                            
                  then assign guiautor.aa-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,1,1))    
                              guiautor.nr-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,2,8)).   

                  if length(string(import-guia.cod-guia-unimed-intercam)) = 10                                            
                  then assign guiautor.aa-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,1,2))    
                              guiautor.nr-guia-atend-origem = int(substring(import-guia.cod-guia-unimed-intercam,3,8)).   

                  ASSIGN guiautor.aa-guia-atend-solic = 0
                         guiautor.nr-guia-atend-solic = 0.
                end.
         end.

    RUN escrever-log("@@@@@criando guia-autoriz-comp ano: " + STRING(aa-guia-atendimento-aux) + " guia:" + STRING(nr-guia-atendimento-aux)).

    create guia-autoriz-comp.
    assign guia-autoriz-comp.cdn-unid             = paramecp.cd-unimed
           guia-autoriz-comp.num-ano-guia-atendim = aa-guia-atendimento-aux
           guia-autoriz-comp.num-guia-atendim     = nr-guia-atendimento-aux
           guia-autoriz-comp.log-atendim-rn       = import-guia.log-atendim-rn.

    case trim(import-guia.ind-tip-guia):
        when "C" /* Consulta */
        then do:
               assign guiautor.in-acidente    = 0
                      guiautor.int-30         = int(import-guia-con.ind-tip-con) /* Tipo de Consulta */
                      guiautor.in-classe-nota = 01.

               run cria-movimentos(input "CONS",
                                   input import-guia-con.num-seqcial-guia).
             end.

        when "S" /* SADT */
        then do:
               assign guiautor.in-acidente    = int(import-guia-sadt.ind-tip-acid)
                      guiautor.cr-solicitacao = trim(import-guia-sadt.ind-carac-solicit)
                      guiautor.ds-ind-clinica = trim(import-guia-sadt.des-indic-clinic)
                      guiautor.int-18         = int(import-guia-sadt.ind-tip-atendim)
                      guiautor.int-30         = int(import-guia-sadt.ind-tip-con)
                      guiautor.in-classe-nota = 02.

               run cria-movimentos(input "SADT",
                                   input import-guia-sadt.val-seqcial).
             end.

        when "I" /* Internacao */
        then do:
               assign guiautor.in-acidente                = int(import-guia-intrcao.idi-acid).

               assign guiautor.int-5                      = int(import-guia-intrcao.cod-regim-intrcao)
                      guiautor.cr-internacao              = trim(import-guia-intrcao.cod-caract-atendim)
                      guia-autoriz-comp.dat-suger-intrcao = import-guia-intrcao.dt-internacao
                      guia-autoriz-comp.log-prev-opme     = import-guia-intrcao.log-opme
                      guia-autoriz-comp.log-prev-qui      = import-guia-intrcao.log-quimio
                      guiautor.ds-ind-clinica             = trim(import-guia-intrcao.des-indcao-clinic)
                      guiautor.tp-inter                   = int(import-guia-intrcao.cdn-tip-inter)
                      guiautor.cd-cid                     = (if  import-guia-intrcao.cod-cid-princ <> ?
                                                             and import-guia-intrcao.cod-cid-princ <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-princ))
                                                             else "")
                      guiautor.cd-cid1                    = (if  import-guia-intrcao.cod-cid-2 <> ?
                                                             and import-guia-intrcao.cod-cid-2 <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-2))
                                                             else "")
                      guiautor.cd-cid2                    = (if  import-guia-intrcao.cod-cid-3 <> ?
                                                             and import-guia-intrcao.cod-cid-3 <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-3))
                                                             else "")
                      guiautor.cd-cid3                    = (if import-guia-intrcao.cod-cid-4 <> ?
                                                             and import-guia-intrcao.cod-cid-4 <> ""
                                                             then caps(trim(import-guia-intrcao.cod-cid-4))
                                                             else "").

               case int(import-guia-intrcao.cdn-tip-inter):
                   when 1 then guiautor.in-classe-nota = 4.  /* Clinica */
                   when 2 then guiautor.in-classe-nota = 5.  /* Cirurgica */
                   when 3 then guiautor.in-classe-nota = 6.  /* Obstetrica */
                   when 4 then guiautor.in-classe-nota = 11. /* Pediatrica */
                   when 5 then guiautor.in-classe-nota = 12. /* Psiquiatrica */
               end case.

               run cria-movimentos(input "INTE",
                                   input import-guia-intrcao.num-seqcial-guia).
             end.

        when "P" /* Prorrogacao */
        then do:
               assign guiautor.in-classe-nota               = 26
                      guia-autoriz-comp.cdn-acomoda-solicit = int(trim(import-guia-prorrog.ind-tip-acomoda-solicitad))
                      guiautor.ds-ind-clinica               = trim(import-guia-prorrog.des-indic-clinic).

               run cria-movimentos(input "PROR",
                                   input import-guia-prorrog.num-seqcial-guia).
             end.

        when "O" /* Odontologia */
        then do:
               assign guiautor.in-classe-nota        = 7                                      
                      guiautor.dt-termino-tratamento = import-guia-odonto.dat-term-tratam     
                      guiautor.tp-atend              = int(import-guia-odonto.ind-tip-atendim)
                      guiautor.cd-faturamento        = trim(import-guia-odonto.ind-tip-faturam).

               run cria-movimentos(input "ODON",
                                   input import-guia-odonto.num-seqcial-guia).
             end.
    end case.

    /* ------------------ CRIA ANEXOS CLINICOS TISS ------------- */
    assign guia-autoriz-comp.cod-livre-10     = ""
           guia-autoriz-comp.des-cipa-his     = ""
           guia-autoriz-comp.des-inf-re       = ""
           guia-autoriz-comp.des-cirurgia-ant = "".

    for each import-anexo-solicit
       where import-anexo-solicit.num-seq-import = import-guia.num-seqcial
             no-lock:
        
        assign guia-autoriz-comp.cod-telef-solic = import-anexo-solicit.nr-telefone
               guia-autoriz-comp.nom-email-solic = import-anexo-solicit.nom-email.

        case trim(import-anexo-solicit.ind-tip-anexo):
            when "1" /* Quimioterapia */
            then do:
                   find import-anexo-quimio where import-anexo-quimio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                  no-lock no-error.

                   if avail import-anexo-quimio
                   then assign guia-autoriz-comp.val-peso-bnfciar               = import-anexo-quimio.val-peso-bnfciar
                               guia-autoriz-comp.val-alt-bnfciar                = import-anexo-quimio.val-alt-bnfciar
                               guia-autoriz-comp.val-sup-cor-bnfciar            = import-anexo-quimio.val-sup-cor-bnfciar
                               guia-autoriz-comp.cdn-tip-qui                    = int(import-anexo-quimio.ind-tip-quimio)
                               guia-autoriz-comp.dat-diag                       = import-anexo-quimio.dat-diag
                               guia-autoriz-comp.cdn-estad                      = int(import-anexo-quimio.cod-estag)
                               guia-autoriz-comp.cdn-finalid-tratam             = int(import-anexo-quimio.ind-finalid-tratam)
                               guia-autoriz-comp.cdn-ecf                        = int(import-anexo-quimio.cod-classif-capac-funcnal)
                               guia-autoriz-comp.num-ciclo-previs               = import-anexo-quimio.num-ciclo
                               guia-autoriz-comp.num-ciclo-atual                = import-anexo-quimio.num-ciclo-atual
                               guia-autoriz-comp.num-interv-ciclo               = import-anexo-quimio.num-interv-ciclo
                               guia-autoriz-comp.des-plano-terap                = trim(import-anexo-quimio.des-plano-terap)
		           	           substr(guia-autoriz-comp.cod-livre-10,1001,1000) = string(trim(import-anexo-solicit.cod-livre-10),"x(1000)") /* Observacoes */
		           	           substr(guia-autoriz-comp.des-cipa-his,1,1000)    = string(trim(import-anexo-quimio.des-diag),"x(1000)")
                               substr(guia-autoriz-comp.des-inf-re,1,1000)      = string(trim(import-anexo-quimio.des-inform),"x(1000)")
                               substr(guia-autoriz-comp.des-cirurgia-ant,1,40)  = string(trim(import-anexo-quimio.des-cirurgia-ant),"x(40)")
                               guia-autoriz-comp.dat-realiz-cirurgia            = import-anexo-quimio.dt-realizacao
                               guia-autoriz-comp.des-area                       = trim(import-anexo-quimio.des-area)
                               guia-autoriz-comp.dat-aplic-radio                = import-anexo-quimio.dat-aplic-radio
                               guia-autoriz-comp.cod-livre-1                    = import-anexo-quimio.cod-cid-princ + ";"
                                                                                + import-anexo-quimio.cod-cid-2 + ";"
                                                                                + import-anexo-quimio.cod-cid-3 + ";"
                                                                                + import-anexo-quimio.cod-cid-4  
                               guia-autoriz-comp.cod-livre-6                    = trim(import-anexo-quimio.cod-livre-1) + ";" /* Nome do profissional solicitante */ 
                                                                                + trim(import-anexo-quimio.cod-livre-3) + ";" /* Telefone Profissional Solicitante */
                                                                                + trim(import-anexo-quimio.cod-livre-4).      /* Email profissional solicitante */   

                   run cria-movimentos(input "QUIM",
                                       input import-anexo-quimio.num-seqcial).
                 end.

            when "2" /* Radioterapia */
            then do:
                   find import-anexo-radio where import-anexo-radio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                 no-lock no-error.

                   if avail import-anexo-radio
                   then assign guia-autoriz-comp.num-campo                      = import-anexo-radio.qti-campos
                               guia-autoriz-comp.num-dosag-dia                  = import-anexo-radio.qtd-dosag-diaria
                               guia-autoriz-comp.num-dosag-tot                  = import-anexo-radio.qtd-dosag-tot
                               guia-autoriz-comp.num-dia-previs                 = import-anexo-radio.num-dias
                               guia-autoriz-comp.dat-previs-inic                = import-anexo-radio.dat-inic-adm
                               guia-autoriz-comp.dat-livre-1                    = import-anexo-radio.dat-diag /* Data do diagnostico */
                               guia-autoriz-comp.num-livre-1                    = int(import-anexo-radio.cod-estag)
                               guia-autoriz-comp.num-livre-3                    = int(import-anexo-radio.ind-finalid-tratam)
                               guia-autoriz-comp.cdn-diag-img                   = int(import-anexo-radio.cdn-diag-img)
                               guia-autoriz-comp.num-livre-2                    = int(import-anexo-radio.cod-classif-capac-funcnal)
                               guia-autoriz-comp.cod-livre-2                    = import-anexo-radio.cod-cid-princ + ";"
                                                                                + import-anexo-radio.cod-cid-2 + ";"
                                                                                + import-anexo-radio.cod-cid-3 + ";"
                                                                                + import-anexo-radio.cod-cid-4
		           	           substr(guia-autoriz-comp.cod-livre-10,2001,1000) = string(trim(import-anexo-solicit.cod-livre-10),"x(1000)") /* Observacoes */
		           	           substr(guia-autoriz-comp.des-cipa-his,1001,1000) = string(trim(import-anexo-radio.des-diag),"x(1000)")
                               substr(guia-autoriz-comp.des-inf-re,1001,1000)   = string(trim(import-anexo-radio.des-inform),"x(1000)")
                               substr(guia-autoriz-comp.des-cirurgia-ant,41,40) = string(trim(import-anexo-radio.des-cirurgia-ant),"x(40)")
                               guia-autoriz-comp.dat-livre-2                    = import-anexo-radio.dat-realiz
                               guia-autoriz-comp.des-qui                        = trim(import-anexo-radio.des-quimio)
                               guia-autoriz-comp.dat-aplic-qui                  = import-anexo-radio.dat-aplic
                               guia-autoriz-comp.cod-livre-7                    = trim(import-anexo-radio.cod-livre-1) + ";" /* Nome do profissional solicitante */
                                                                                + trim(import-anexo-radio.cod-livre-3) + ";" /* Telefone Profissional Solicitante */
                                                                                + trim(import-anexo-radio.cod-livre-4).      /* Email profissional solicitante */

                   run cria-movimentos(input "RADI",
                                       input import-anexo-radio.num-seqcial).
                 end.

            when "3" /* OPME */
            then do:
                   find import-anexo-opme where import-anexo-opme.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                no-lock no-error.

                   if avail import-anexo-opme
                   then assign guia-autoriz-comp.des-justif-tec                 = trim(import-anexo-opme.des-justificativa)      /* JUSTFICATIVA TECNICA  */
                               guia-autoriz-comp.des-espcif-mater               = trim(import-anexo-opme.des-especif-mater) /* ESPECIFICACAO MATERIAL */
                               guia-autoriz-comp.cod-livre-8                    = trim(import-anexo-opme.cod-livre-1) + ";" /* Nome do profissional solicitante */
                                                                                + trim(import-anexo-opme.cod-livre-3) + ";" /* Telefone Profissional Solicitante */
                                                                                + trim(import-anexo-opme.cod-livre-4)       /* Email profissional solicitante */
                               substr(guia-autoriz-comp.cod-livre-10,3001,1000) = string(trim(import-anexo-solicit.cod-livre-10),"x(1000)") /* Observacoes */.

                   run cria-movimentos(input "OPME",
                                       input import-anexo-opme.num-seqcial).
                 end.

            when "4" /* Odontologia */
            then do:
                   find import-anexo-odonto where import-anexo-odonto.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                                  no-lock no-error.
                  
                   if avail import-anexo-odonto
                   then do:
                          RUN escrever-log("@@@@@criando guiainod ano: " + STRING(aa-guia-atendimento-aux) + " guia:" + STRING(nr-guia-atendimento-aux)).

                          create guiainod.
                          assign guiainod.cd-unidade                = paramecp.cd-unimed     
                                 guiainod.aa-guia-atendimento       = aa-guia-atendimento-aux
                                 guiainod.nr-guia-atendimento       = nr-guia-atendimento-aux
                                 guiainod.nr-sequencia              = 0
                                 guiainod.lg-doencas-periodontais   = import-anexo-odonto.log-doenc-periodts
                                 guiainod.lg-altera-tecidos-moles   = import-anexo-odonto.log-alter-tecidos-moles
                                 guiainod.dt-registro               = today
                                 guiainod.ds-observacao             = import-anexo-odonto.des-observacao
                                 guiainod.cd-userid                 = v_cod_usuar_corren
                                 guiainod.dt-atualizacao            = today.

                          if  import-anexo-odonto.cod-livre-6 <> ? 
                          and import-anexo-odonto.cod-livre-6 <> ""
                          then assign guiainod.nm-prest-exec-compl       = entry(1, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.char-2                    = entry(2, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.nr-conse-prest-exec-compl = entry(3, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.uf-conse-prest-exec-compl = entry(4, import-anexo-odonto.cod-livre-6, ";")
                                      guiainod.char-1                    = entry(5, import-anexo-odonto.cod-livre-6, ";").
                          
                          for each import-anexo-odonto-mov
                             where import-anexo-odonto-mov.num-seqcial-anexo = import-anexo-odonto.num-seqcial
                                   no-lock:
                              if import-anexo-odonto-mov.tp-dente-regiao <> ""
                              then assign guiainod.ds-situacao-inicial [int(import-anexo-odonto-mov.tp-dente-regiao)] = trim(import-anexo-odonto-mov.ind-sit-inicial).
                          end. /* each import-anexo-odonto-mov */

                          validate guiainod.
                          release guiainod.
                        end.
                 end.
        end case.
    end. /* each import-anexo-solicit */

    /* ----------------- GRAVA HISTORICO DA GUIA ------------------------ */
    assign nr-seq-histor-aux = 1.

    for each import-guia-histor
       where import-guia-histor.val-seq-guia = import-guia.num-seqcial
             no-lock:

        RUN escrever-log("@@@@@criando guia-his ano: " + STRING(aa-guia-atendimento-aux) + " guia:" + STRING(nr-guia-atendimento-aux)).

        create guia-his.
        assign guia-his.cd-unidade          = paramecp.cd-unimed
               guia-his.aa-guia-atendimento = aa-guia-atendimento-aux
               guia-his.nr-guia-atendimento = nr-guia-atendimento-aux
               guia-his.nr-sequencia-alt    = nr-seq-histor-aux
               guia-his.in-lib-guias-alt    = guiautor.in-liberado-guias
               guia-his.cd-userid-alt       = import-guia-histor.cd-userid-alt
               guia-his.dt-alt              = import-guia-histor.dt-alt
               guia-his.cd-userid           = v_cod_usuar_corren
               guia-his.dt-atualizacao      = today
               guia-his.char-4              = "AT0210A1".

        validate guia-his.
        release guia-his.

        assign nr-seq-histor-aux = nr-seq-histor-aux + 1.
    end. /* each import-guia-histor */
    /* ----------------------------------------------------------------- */

    validate guiautor.
    release guiautor.

    validate guia-autoriz-comp.
    release guia-autoriz-comp.

end procedure.

/* ----------------------------------------------------------------- */
procedure cria-movimentos:

    def input parameter in-tipo-guia-par as char format "x(4)" no-undo.
    def input parameter val-seq-guia-par as int                no-undo.

    RUN escrever-log("@@@@@vai ler import-guia-movto. in-tipo-guia-par: " + STRING(in-tipo-guia-par) + " val-seq-guia-par: " + string(val-seq-guia-par)).

    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = in-tipo-guia-par
         and import-guia-movto.val-seq-guia = val-seq-guia-par
             no-lock:

        RUN escrever-log("@@@@@servico: " + STRING(import-guia-movto.cod-movto-guia) + " tipo: " + import-guia-movto.ind-tip-movto-guia
                         + " Pacote?: " + STRING(import-guia-movto.log-livre-1)).

        /* Logica de Pacotes*/
        if import-guia-movto.log-livre-1
        then do:
               assign cd-pacote = substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2) + 
                                  substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2) +
                                  substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3) +
                                  substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1).           
               
               run filtra-paproins (input cd-modalidade-aux,                 
                                    input nr-ter-adesao-aux,                    
                                    input import-guia.cd-unidade-carteira,           
                                    input today,                    
                                    input cd-pacote,                     
                                    input import-guia.cd-unidade-principal,          
                                    input import-guia.cd-prestador-principal).              
                                                                                                
               if r-paproins <> ?                                                     
               then find paproins where rowid(paproins) = r-paproins no-lock no-error.
        
               if not avail paproins
               then do:
                      IF import-guia-movto.ind-tip-guia <> ?
                      THEN char-aux1 = string(import-guia-movto.ind-tip-guia).
                      ELSE char-aux1 = "nulo".
                      IF import-guia-movto.val-seq-guia <> ?
                      THEN char-aux2 = string(import-guia-movto.val-seq-guia).
                      ELSE char-aux2 = "nulo".
                      IF import-guia-movto.cod-movto-guia <> ?
                      THEN char-aux3 = string(import-guia-movto.cod-movto-guia).
                      ELSE char-aux3 = "nulo".
                      
                      run grava-erro(input import-guia.num-seqcial-control,                                        
                                     input "import-guia",                                                          
                                     input "Pacote nao cadastrado. Tp.Guia(import-guia-movto.ind-tip-guia): " + char-aux1 +
                                           " Nro.Seq.Guia(import-guia-movto.val-seq-guia): "                  + char-aux2 + 
                                           " Pacote: " + char-aux3,                      
                                     input today,                                                                  
                                     input "Informe um pacote Valido").                                                                                                                        
                      return.                                                                                      
                   end.
        
               if avail paproins        
               then do:
                       for each pacproce where pacproce.cd-pacote            =  paproins.cd-pacote    
                                           and pacproce.cd-unidade           =  paproins.cd-unidade   
                                           and pacproce.cd-prestador         =  paproins.cd-prestador 
                                           and pacproce.cd-modalidade        =  paproins.cd-modalidade
                                           and pacproce.cd-plano             =  paproins.cd-plano     
                                           and pacproce.cd-tipo-plano        =  paproins.cd-tipo-plano
                                           and pacproce.dt-inicio-vigencia   =  paproins.dt-inicio-vigencia
                                           and pacproce.dt-limite            =  paproins.dt-limite no-lock:
        
                    
                           create procguia.
                           assign procguia.cd-unidade              = paramecp.cd-unimed
                                  procguia.aa-guia-atendimento     = aa-guia-atendimento-aux
                                  procguia.nr-guia-atendimento     = nr-guia-atendimento-aux
                                  procguia.nr-processo             = nr-processo-proc-aux
                                  procguia.nr-seq-digitacao        = 0
                                  procguia.cd-esp-amb              = pacproce.cd-esp-amb        
                                  procguia.cd-grupo-proc-amb       = pacproce.cd-grupo-proc-amb 
                                  procguia.cd-procedimento         = pacproce.cd-procedimento   
                                  procguia.dv-procedimento         = pacproce.dv-procedimento   
                                  procguia.qt-procedimento         = import-guia-movto.qtd-autoriza
                                  procguia.int-11                  = import-guia-movto.qtd-solicitad
                                  procguia.in-nivel-prestador      = 01
                                  procguia.dt-atualizacao          = today
                                  procguia.dt-realizacao           = ?
                                  procguia.hr-realizacao           = substring(string(time,"HH:MM"),1,2) + substring(string(time,"HH:MM"),4,2)
                                  procguia.cd-modalidade           = cd-modalidade-aux 
                                  procguia.cd-usuario              = cd-usuario-aux
                                  procguia.nr-ter-adesao           = nr-ter-adesao-aux
                                  procguia.cd-clinica              = import-guia.cd-clinica
                                  procguia.cd-unidade-clinica      = paramecp.cd-unimed
                                  procguia.cd-unidade-prestador    = cd-unidade-prestador-aux
                                  procguia.cd-prestador            = cd-prestador-aux
                                  procguia.cd-esp-prest-executante = cd-esp-prest-executante-aux
                                  procguia.cd-tipo-vinculo         = cd-vinculo-aux
                                  procguia.cd-validacao            = import-guia-movto.cd-validacao
                                  procguia.cd-tipo-cob             = import-guia-movto.num-livre-3 /* Validacao para cobranca */
                                  procguia.cd-tipo-pagamento       = import-guia-movto.num-livre-4 /* Validacao para pagamento */
                                  procguia.cd-classe-erro          = import-guia-movto.num-livre-2
                                  procguia.cd-cod-glo              = import-guia-movto.num-livre-1
                                  procguia.cd-userid               = v_cod_usuar_corren
                                  procguia.nm-prest-exec-compl     = tmp-prest-exec.nm-prest-exec-compl
                                  procguia.char-3                  = tmp-prest-exec.nm-conselho
                                  procguia.nr-registro             = string(tmp-prest-exec.nr-registro)
                                  procguia.uf-conselho             = tmp-prest-exec.uf-conselho
                                  procguia.char-2                  = tmp-prest-exec.cd-cbo
                                  procguia.vl-principal            = pacproce.vl-procedimento
                                  procguia.vl-taxa-participacao    = IF import-guia-movto.val-co-partic   = ? THEN 0 ELSE import-guia-movto.val-co-partic  
                                  procguia.vl-movimento-total      = (procguia.vl-principal + import-guia-movto.val-taxas-adm)
                                  procguia.cd-pacote               = int(import-guia-movto.cod-movto-guia).
                            
                          
                           /* Busca do m½dulo*/     
                           
                            find first pl-mo-am where pl-mo-am.cd-modalidade = cd-modalidade-aux                                                                          
                                                  and pl-mo-am.cd-plano      = cd-plano-aux                                                                               
                                                  and pl-mo-am.cd-tipo-plano = cd-tipo-plano-aux                                                                          
                                                  and pl-mo-am.cd-amb        = int(string(pacproce.cd-esp-amb)        +  
                                                                                   string(pacproce.cd-grupo-proc-amb) + 
                                                                                   string(pacproce.cd-procedimento)   +
                                                                                   string(pacproce.dv-procedimento))  no-lock no-error.                                    
                            if avail pl-mo-am                                                                                                                             
                            then do:                                                                                                                                      
                                    assign procguia.cd-tab-preco = pl-mo-am.cd-tab-preco                                                                                  
                                           procguia.cd-modulo    = pl-mo-am.cd-modulo.                                                                                    
                                                                                                                                                                          
                                    find first precproc where precproc.cd-tab-preco = pl-mo-am.cd-tab-preco no-lock no-error.                                             
                                                                                                                                                                          
                                    if avail precproc                                                                                                                     
                                    then assign procguia.cd-forma-pagto     = precproc.cd-forma-pagto                                                                     
                                                procguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.                                                                    
                                                                                                                                                                          
                                end.                                                                                                                                      
                            else do:                                                                                                                                      
                                    /* ------------------- TABELA MOEDAS E CARENCIAS COBRANCA ------------------ */                                                       
                                    find first plamodpr                                                                                                                   
                                         where plamodpr.cd-modalidade          = cd-modalidade-aux                                                                        
                                           and plamodpr.cd-plano               = cd-plano-aux                                                                             
                                           and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux                                                                        
                                           and plamodpr.in-procedimento-insumo = "P"                                                                                      
                                               no-lock no-error.                                                                                                          
                                                                                                                                                                          
                                    if avail plamodpr                                                                                                                     
                                    then do:                                                                                                                              
                                           assign procguia.cd-tab-preco = plamodpr.cd-tab-preco
                                                  procguia.cd-modulo    = plamodpr.cd-modulo.  
                                                                                                                                                                          
                                           find first precproc where precproc.cd-tab-preco = plamodpr.cd-tab-preco no-lock no-error.                                      
                                                                                                                                                                          
                                           if avail precproc                                                                                                              
                                           then assign procguia.cd-forma-pagto     = precproc.cd-forma-pagto                                                              
                                                       procguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.                                                             
                                         end.                                                                                                                             
                                                                                                                                                                          
                                end.                                                                                                                                      
        
                           /* -------------- QTD MOEDA PAGTO ------------------------- */
                           if paramecp.cd-unimed = import-guia.cd-unidade-carteira
                           then do:
                                  find propost where propost.cd-modalidade = cd-modalidade-aux 
                                                 and propost.nr-ter-adesao = nr-ter-adesao-aux
                                                     no-lock no-error.
                           
                                  if avail propost
                                  then assign procguia.cd-tab-preco-proc = propost.cd-tab-preco-proc.
                                end.
                           else do:
                                  find unicamco where unicamco.cd-unidade = import-guia.cd-unidade-carteira
                                                  and unicamco.dt-limite >= import-guia.dat-solicit
                                                      no-lock no-error.
                           
                                  if avail unicamco
                                  then assign procguia.cd-tab-preco-proc = unicamco.cd-tab-preco-proc-cob.
                                end.
                           
                       
                           create proced-guia-comp.
                           assign proced-guia-comp.cdn-unid             = paramecp.cd-unimed         
                                  proced-guia-comp.num-ano-guia-atendim = aa-guia-atendimento-aux
                                  proced-guia-comp.num-guia-atendim     = nr-guia-atendimento-aux
                                  proced-guia-comp.num-proces           = nr-processo-proc-aux   
                                  proced-guia-comp.num-seq-digitac      = 0
                                  proced-guia-comp.dat-previs-adm       = import-guia-movto.dat-previs. /* radio e quimio */
        
                           
                           validate procguia.
                           release procguia.
                           
                           validate proced-guia-comp.
                           release proced-guia-comp.
        
                           assign nr-processo-proc-aux = nr-processo-proc-aux + 1.
        
                       end.
                      
                       for each pacinsum where pacinsum.cd-pacote           =  paproins.cd-pacote    
                                           and pacinsum.cd-unidade          =  paproins.cd-unidade   
                                           and pacinsum.cd-prestador        =  paproins.cd-prestador 
                                           and pacinsum.cd-modalidade       =  paproins.cd-modalidade
                                           and pacinsum.cd-plano            =  paproins.cd-plano     
                                           and pacinsum.cd-tipo-plano       =  paproins.cd-tipo-plano
                                           and pacinsum.dt-inicio-vigencia  =  paproins.dt-inicio-vigencia
                                           and pacinsum.dt-limite           =  paproins.dt-limite /* dt-fim-vigencia*/    
                                               no-lock:
        
                           create insuguia.
                           assign insuguia.cd-unidade              = paramecp.cd-unimed
                                  insuguia.aa-guia-atendimento     = aa-guia-atendimento-aux
                                  insuguia.nr-guia-atendimento     = nr-guia-atendimento-aux
                                  insuguia.nr-processo             = 0
                                  insuguia.nr-seq-digitacao        = nr-seq-digitacao-ins-aux
                                  insuguia.cd-tipo-insumo          = pacinsum.cd-tipo-insumo
                                  insuguia.cd-insumo               = pacinsum.cd-insumo
                                  insuguia.cd-modulo               = import-guia-movto.cd-modulo
                                  insuguia.qt-insumo               = import-guia-movto.qtd-autoriza
                                  insuguia.dec-1                   = import-guia-movto.qtd-solicitad
                                  insuguia.dt-atualizacao          = TODAY
                                  insuguia.cd-userid               = v_cod_usuar_corren
                                  insuguia.dt-realizacao           = ?
                                  insuguia.hr-realizacao           = substring(string(time,"HH:MM"),1,2) + substring(string(time,"HH:MM"),4,2)
                                  insuguia.cd-modalidade           = cd-modalidade-aux
                                  insuguia.cd-usuario              = cd-usuario-aux
                                  insuguia.nr-ter-adesao           = nr-ter-adesao-aux
                                  insuguia.cd-unidade-prestador    = cd-unidade-prestador-aux
                                  insuguia.cd-prestador            = cd-prestador-aux
                                  insuguia.cd-esp-prest-executante = cd-esp-prest-executante-aux
                                  insuguia.cd-tipo-vinculo         = cd-vinculo-aux
                                  insuguia.cd-validacao            = import-guia-movto.cd-validacao
                                  insuguia.cd-tipo-cob             = import-guia-movto.num-livre-3 /* Validacao para cobranca */
                                  insuguia.cd-tipo-pagamento       = import-guia-movto.num-livre-4 /* Validacao para pagamento */
                                  insuguia.cd-classe-erro          = import-guia-movto.num-livre-2
                                  insuguia.cd-cod-glo              = import-guia-movto.num-livre-1
                                  insuguia.cd-userid               = v_cod_usuar_corren
                                  insuguia.nm-prest-exec-compl     = tmp-prest-exec.nm-prest-exec-compl
                                  insuguia.char-3                  = tmp-prest-exec.nm-conselho
                                  insuguia.nr-registro             = string(tmp-prest-exec.nr-registro)
                                  insuguia.uf-conselho             = tmp-prest-exec.uf-conselho
                                  insuguia.char-2                  = tmp-prest-exec.cd-cbo
                                  insuguia.vl-insumo-cob           = pacinsum.vl-insumo
                                  insuguia.vl-taxa-participacao    = if import-guia-movto.val-co-partic   = ? then 0 else import-guia-movto.val-co-partic  
                                  insuguia.vl-movimento-total      = (insuguia.vl-insumo-cob + import-guia-movto.val-taxas-adm)
                                  insuguia.cd-pacote               = int(import-guia-movto.cod-movto-guia).  
                              
                           
                       
                                  /* Busca do m½dulo*/                                                                                                                            
                                                                                                                                                                          
                            find first partinsu where partinsu.cd-modalidade  = cd-modalidade-aux                                                                          
                                                  and partinsu.cd-plano       = cd-plano-aux                                                                               
                                                  and partinsu.cd-tipo-plano  = cd-tipo-plano-aux                                                                          
                                                  and partinsu.cd-tipo-insumo = pacinsum.cd-tipo-insumo
                                                  and partinsu.cd-insumo      = pacinsum.cd-insumo no-lock no-error.                                    
                            if not avail partinsu 
                            then do:
                                   find first partinsu where partinsu.cd-modalidade  = cd-modalidade-aux                                                                          
                                                         and partinsu.cd-plano       = cd-plano-aux                                                                               
                                                         and partinsu.cd-tipo-plano  = cd-tipo-plano-aux                                                                          
                                                         and partinsu.cd-tipo-insumo = pacinsum.cd-tipo-insumo
                                                         and partinsu.cd-insumo      = 0 no-lock no-error.    
                                end.
                             if avail partinsu
                             then do:                                                                                                                                      
                                    assign insuguia.cd-tab-preco = partinsu.cd-tab-preco                                                                                  
                                           insuguia.cd-modulo    = partinsu.cd-modulo.                                                                                    
                                                                                                                                                                          
                                    find first precproc where precproc.cd-tab-preco = partinsu.cd-tab-preco no-lock no-error.                                             
                                                                                                                                                                          
                                    if avail precproc                                                                                                                     
                                    then assign insuguia.cd-forma-pagto     = precproc.cd-forma-pagto                                                                     
                                                insuguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.                                                                    
                                                                                                                                                                          
                                end.                                                                                                                                      
                            else do:                                                                                                                                      
                                    /* ------------------- TABELA MOEDAS E CARENCIAS COBRANCA ------------------ */                                                       
                                    find first plamodpr                                                                                                                   
                                         where plamodpr.cd-modalidade          = cd-modalidade-aux                                                                        
                                           and plamodpr.cd-plano               = cd-plano-aux                                                                             
                                           and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux                                                                        
                                           and plamodpr.in-procedimento-insumo = "I"                                                                                      
                                               no-lock no-error.                                                                                                          
                                                                                                                                                                          
                                    if avail plamodpr                                                                                                                     
                                    then do:                                                                                                                              
                                           assign insuguia.cd-tab-preco = plamodpr.cd-tab-preco
                                                  insuguia.cd-modulo    = plamodpr.cd-modulo. 
                                                                                                                                                                          
                                           find first precproc where precproc.cd-tab-preco = plamodpr.cd-tab-preco no-lock no-error.                                      
                                                                                                                                                                          
                                           if avail precproc                                                                                                              
                                           then assign insuguia.cd-forma-pagto     = precproc.cd-forma-pagto                                                              
                                                       insuguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.                                                             
                                         end.                                                                                                                             
                                                                                                                                                                          
                                end.                         
        
                           
                           /* -------------- QTD MOEDA PAGTO ------------------------- */
                           if paramecp.cd-unimed = import-guia.cd-unidade-carteira
                           then do:
                                  find propost where propost.cd-modalidade = cd-modalidade-aux
                                                 and propost.nr-ter-adesao = nr-ter-adesao-aux
                                                     no-lock no-error.
                           
                                  if avail propost
                                  then assign insuguia.cd-tab-preco-proc-cob = propost.cd-tab-preco-proc.
                                end.
                           else do:
                                  find unicamco where unicamco.cd-unidade = import-guia.cd-unidade-carteira
                                                  and unicamco.dt-limite >= import-guia.dat-solicit
                                                      no-lock no-error.
                           
                                  if avail unicamco
                                  then assign insuguia.cd-tab-preco-proc-cob = unicamco.cd-tab-preco-proc-cob.
                                end.
                           
                           /* -------------- DESCRICAO INSUMO GENERICO ------------------------------ */
                           if  import-guia-movto.des-insumo <> ?
                           and import-guia-movto.des-insumo <> ""
                           then assign insuguia.char-4 = import-guia-movto.des-insumo. /* Descricao do insumo generico */
                           
                       
                           
                           create insumo-guia-comp.
                           assign insumo-guia-comp.cdn-unid             = paramecp.cd-unimed                      
                                  insumo-guia-comp.num-ano-guia-atendim = aa-guia-atendimento-aux                 
                                  insumo-guia-comp.num-guia-atendim     = nr-guia-atendimento-aux                 
                                  insumo-guia-comp.num-proces           = 0                                       
                                  insumo-guia-comp.num-seq-digitac      = nr-seq-digitacao-ins-aux                
                                  insumo-guia-comp.cod-opc              = trim(import-guia-movto.des-opc-fabrican)
                                  insumo-guia-comp.cdn-via-adm          = int(import-guia-movto.cdn-via-administ)
                                  insumo-guia-comp.dat-previs-adm       = import-guia-movto.dat-previs
                                  insumo-guia-comp.cdn-freq             = import-guia-movto.cdn-freq.
                           
                           validate insuguia.
                           release insuguia.
                           
                           validate insumo-guia-comp.
                           release insumo-guia-comp.
                       
                           
                           assign nr-seq-digitacao-ins-aux = nr-seq-digitacao-ins-aux + 1.
               
                       end.
                   end.
              end.


        if import-guia-movto.ind-tip-movto-guia = "P" /* Procedimento */
        and not import-guia-movto.log-livre-1 /* true: pacote; false: nao eh pacote */
        then do:

               RUN escrever-log("@@@@@criando procguia ano: " + STRING(aa-guia-atendimento-aux) + " guia:" 
                            + STRING(nr-guia-atendimento-aux) + " movimento: " + STRING(import-guia-movto.cod-movto-guia)).

               create procguia.
               assign procguia.cd-unidade              = paramecp.cd-unimed
                      procguia.aa-guia-atendimento     = aa-guia-atendimento-aux
                      procguia.nr-guia-atendimento     = nr-guia-atendimento-aux
                      procguia.nr-processo             = nr-processo-proc-aux
                      procguia.nr-seq-digitacao        = 0
                      procguia.cd-esp-amb              = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2))
                      procguia.cd-grupo-proc-amb       = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2))
                      procguia.cd-procedimento         = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3))
                      procguia.dv-procedimento         = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1))
                      procguia.cd-modulo               = import-guia-movto.cd-modulo
                      procguia.qt-procedimento         = import-guia-movto.qtd-autoriza
                      procguia.int-11                  = import-guia-movto.qtd-solicitad
                      procguia.in-nivel-prestador      = 01
                      procguia.dt-atualizacao          = today
                      procguia.dt-realizacao           = ?
                      procguia.hr-realizacao           = substring(string(time,"HH:MM"),1,2) + substring(string(time,"HH:MM"),4,2)
                      procguia.cd-modalidade           = cd-modalidade-aux
                      procguia.nr-ter-adesao           = nr-ter-adesao-aux
                      procguia.cd-usuario              = cd-usuario-aux
                      procguia.cd-clinica              = import-guia.cd-clinica
                      procguia.cd-unidade-clinica      = paramecp.cd-unimed
                      procguia.cd-unidade-prestador    = cd-unidade-prestador-aux
                      procguia.cd-prestador            = cd-prestador-aux
                      procguia.cd-esp-prest-executante = cd-esp-prest-executante-aux
                      procguia.cd-tipo-vinculo         = cd-vinculo-aux
                      procguia.cd-validacao            = import-guia-movto.cd-validacao
                      procguia.cd-tipo-cob             = import-guia-movto.num-livre-3 /* Validacao para cobranca */
                      procguia.cd-tipo-pagamento       = import-guia-movto.num-livre-4 /* Validacao para pagamento */
                      procguia.cd-classe-erro          = import-guia-movto.num-livre-2
                      procguia.cd-cod-glo              = import-guia-movto.num-livre-1
                      procguia.cd-userid               = v_cod_usuar_corren
                      procguia.nm-prest-exec-compl     = tmp-prest-exec.nm-prest-exec-compl
                      procguia.char-3                  = tmp-prest-exec.nm-conselho
                      procguia.nr-registro             = string(tmp-prest-exec.nr-registro)
                      procguia.uf-conselho             = tmp-prest-exec.uf-conselho
                      procguia.char-2                  = tmp-prest-exec.cd-cbo
                      procguia.vl-principal            = IF import-guia-movto.val-movto-pagto = ? THEN 0 ELSE import-guia-movto.val-movto-pagto 
                      procguia.vl-taxa-participacao    = IF import-guia-movto.val-co-partic   = ? THEN 0 ELSE import-guia-movto.val-co-partic  
                      procguia.vl-movimento-total      = (procguia.vl-principal + import-guia-movto.val-taxas-adm).

               /* ------------------- TABELA MOEDAS E CARENCIAS COBRANCA ------------------ */
               find first pl-mo-am where pl-mo-am.cd-modalidade = cd-modalidade-aux                                        
                                     and pl-mo-am.cd-plano      = cd-plano-aux                                             
                                     and pl-mo-am.cd-tipo-plano = cd-tipo-plano-aux  
                                     and pl-mo-am.cd-modulo     = import-guia-movto.cd-modulo  
                                     and pl-mo-am.cd-amb        = int(import-guia-movto.cod-movto-guia)  no-lock no-error. 
               if avail pl-mo-am                                                                                           
               then do:                                                                                                    
                       assign procguia.cd-tab-preco = pl-mo-am.cd-tab-preco                                                
                              procguia.cd-modulo    = pl-mo-am.cd-modulo.                                                  
                                                                                                                           
                       find first precproc where precproc.cd-tab-preco = pl-mo-am.cd-tab-preco no-lock no-error.           
                                                                                                                           
                       if avail precproc                                                                                   
                       then assign procguia.cd-forma-pagto     = precproc.cd-forma-pagto                                   
                                   procguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.                                  
                                                                                                                           
                    end.                                                                                                    
               else do: 
                      find first plamodpr 
                           where plamodpr.cd-modalidade          = cd-modalidade-aux
                             and plamodpr.cd-plano               = cd-plano-aux
                             and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                             and plamodpr.in-procedimento-insumo = "P"
                             and plamodpr.cd-modulo              = import-guia-movto.cd-modulo
                                 no-lock no-error.
                      
                      if avail plamodpr
                      then do:
                             assign procguia.cd-tab-preco = plamodpr.cd-tab-preco.
                      
                             find first precproc where precproc.cd-tab-preco = plamodpr.cd-tab-preco no-lock no-error.
                      
                             if avail precproc
                             then assign procguia.cd-forma-pagto     = precproc.cd-forma-pagto
                                         procguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.
                           end.
                    end.

               /* -------------- QTD MOEDA PAGTO ------------------------- */
               if paramecp.cd-unimed = import-guia.cd-unidade-carteira
               then do:
                      find propost where propost.cd-modalidade = cd-modalidade-aux 
                                     and propost.nr-ter-adesao = nr-ter-adesao-aux
                                         no-lock no-error.

                      if avail propost
                      then assign procguia.cd-tab-preco-proc = propost.cd-tab-preco-proc.
                    end.
               else do:
                      find unicamco where unicamco.cd-unidade = import-guia.cd-unidade-carteira
                                      and unicamco.dt-limite >= import-guia.dat-solicit
                                          no-lock no-error.

                      if avail unicamco
                      then assign procguia.cd-tab-preco-proc = unicamco.cd-tab-preco-proc-cob.
                    end.

               /* ------------------- ANEXOS TISS --------------------------- */
               if in-tipo-guia-par = "QUIM"
               then assign procguia.int-2 = 1.
               else do:
                      if in-tipo-guia-par = "RADI"
                      then assign procguia.int-2 = 2.
                      else do:
                             if in-tipo-guia-par = "OPME"
                             then assign procguia.int-2 = 3.
                             else assign procguia.int-2 = 0.
                           end.
                    end.

               create proced-guia-comp.
               assign proced-guia-comp.cdn-unid             = paramecp.cd-unimed         
                      proced-guia-comp.num-ano-guia-atendim = aa-guia-atendimento-aux
                      proced-guia-comp.num-guia-atendim     = nr-guia-atendimento-aux
                      proced-guia-comp.num-proces           = nr-processo-proc-aux   
                      proced-guia-comp.num-seq-digitac      = 0
                      proced-guia-comp.dat-previs-adm       = import-guia-movto.dat-previs. /* radio e quimio */

               case in-tipo-guia-par:
                   when "ODON"
                   then do:
                          assign procguia.tp-dente-regiao  = trim(import-guia-movto.ind-dente-regiao).
                          
                          assign id-face-dente-aux = trim(import-guia-movto.ind-face-dente).

                          do ix = 1 to length(id-face-dente-aux):
                              if substr(id-face-dente-aux,ix,1) <> ""
                              then assign procguia.id-face-dente[ix] = substr(id-face-dente-aux,ix,1).
                          end.
                        end.
               end case.

               validate procguia.
               release procguia.

               validate proced-guia-comp.
               release proced-guia-comp.

               RUN escrever-log("@@@@@vai chamar grava-glosas PROCEDIMENTOS. ano: " + STRING(aa-guia-atendimento-aux) + " guia:" 
                            + STRING(nr-guia-atendimento-aux) 
                            + " in-tipo-guia-par: " + in-tipo-guia-par + " val-seqcial: " + STRING(import-guia-movto.val-seqcial)
                            + " val-seq-guia-par: " + STRING(val-seq-guia-par)).

               run grava-glosas(input in-tipo-guia-par,
                                input import-guia-movto.val-seqcial,
                                input val-seq-guia-par,
                                input aa-guia-atendimento-aux,
                                input nr-guia-atendimento-aux, 
                                input nr-processo-proc-aux,
                                input 0, /* nr-seq-digitacao */
                                input "P"). /* in-origem-glosa */

               assign nr-processo-proc-aux = nr-processo-proc-aux + 1.
             end.
        else do:
               if not import-guia-movto.log-livre-1 /* true: pacote; false: nao eh pacote */
               then do:

                   RUN escrever-log("@@@@@criando insuguia ano: " + STRING(aa-guia-atendimento-aux) + " guia:" 
                                + STRING(nr-guia-atendimento-aux) + " movimento: " + STRING(import-guia-movto.cod-movto-guia)).

                      create insuguia.
                      assign insuguia.cd-unidade              = paramecp.cd-unimed
                             insuguia.aa-guia-atendimento     = aa-guia-atendimento-aux
                             insuguia.nr-guia-atendimento     = nr-guia-atendimento-aux
                             insuguia.nr-processo             = 0
                             insuguia.nr-seq-digitacao        = nr-seq-digitacao-ins-aux
                             insuguia.cd-tipo-insumo          = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),1,2))
                             insuguia.cd-insumo               = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),3,8))
                             insuguia.cd-modulo               = import-guia-movto.cd-modulo
                             insuguia.qt-insumo               = import-guia-movto.qtd-autoriza
                             insuguia.dec-1                   = import-guia-movto.qtd-solicitad
                             insuguia.dt-atualizacao          = today
                             insuguia.cd-userid               = v_cod_usuar_corren
                             insuguia.dt-realizacao           = ?
                             insuguia.hr-realizacao           = substring(string(time,"HH:MM"),1,2) + substring(string(time,"HH:MM"),4,2)
                             insuguia.cd-modalidade           = cd-modalidade-aux
                             insuguia.nr-ter-adesao           = nr-ter-adesao-aux
                             insuguia.cd-usuario              = cd-usuario-aux
                             insuguia.cd-unidade-prestador    = cd-unidade-prestador-aux
                             insuguia.cd-prestador            = cd-prestador-aux
                             insuguia.cd-esp-prest-executante = cd-esp-prest-executante-aux
                             insuguia.cd-tipo-vinculo         = cd-vinculo-aux
                             insuguia.cd-validacao            = import-guia-movto.cd-validacao
                             insuguia.cd-tipo-cob             = import-guia-movto.num-livre-3 /* Validacao para cobranca */
                             insuguia.cd-tipo-pagamento       = import-guia-movto.num-livre-4 /* Validacao para pagamento */
                             insuguia.cd-classe-erro          = import-guia-movto.num-livre-2
                             insuguia.cd-cod-glo              = import-guia-movto.num-livre-1
                             insuguia.cd-userid               = v_cod_usuar_corren
                             insuguia.nm-prest-exec-compl     = tmp-prest-exec.nm-prest-exec-compl
                             insuguia.char-3                  = tmp-prest-exec.nm-conselho
                             insuguia.nr-registro             = string(tmp-prest-exec.nr-registro)
                             insuguia.uf-conselho             = tmp-prest-exec.uf-conselho
                             insuguia.char-2                  = tmp-prest-exec.cd-cbo
                             insuguia.vl-insumo-cob           = if import-guia-movto.val-movto-pagto = ? then 0 else import-guia-movto.val-movto-pagto
                             insuguia.vl-taxa-participacao    = if import-guia-movto.val-co-partic   = ? then 0 else import-guia-movto.val-co-partic  
                             insuguia.vl-movimento-total      = (insuguia.vl-insumo-cob + import-guia-movto.val-taxas-adm).

                      /* ------------------- TABELA MOEDAS E CARENCIAS COBRANCA --------------- */
                       for first insumos where insumos.cd-insumo = int(import-guia-movto.cod-movto-guia) no-lock: 
                          assign insuguia.cd-tipo-insumo = insumos.cd-tipo-insumo  
                                 insuguia.cd-insumo      = insumos.cd-insumo.       
                      end.

                      /* Busca do modulo*/                                                                                                                                                                                                                                 
                      find first partinsu 
                           where partinsu.cd-modalidade  = cd-modalidade-aux                                             
                             and partinsu.cd-plano       = cd-plano-aux                                                  
                             and partinsu.cd-tipo-plano  = cd-tipo-plano-aux  
                             and partinsu.cd-modulo      = import-guia-movto.cd-modulo
                             and partinsu.cd-tipo-insumo = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),1,2))                                        
                             and partinsu.cd-insumo      = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),3,8)) no-lock no-error.                          

                      if not avail partinsu                                                                                             
                      then find first partinsu 
                                where partinsu.cd-modalidade  = cd-modalidade-aux                                      
                                  and partinsu.cd-plano       = cd-plano-aux                                           
                                  and partinsu.cd-tipo-plano  = cd-tipo-plano-aux   
                                  and partinsu.cd-modulo      = import-guia-movto.cd-modulo
                                  and partinsu.cd-tipo-insumo = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),1,2))                                
                                  and partinsu.cd-insumo      = 0 no-lock no-error.                   
                                                                                                                                    
                      if avail partinsu                                                                                                
                      then do:                                                                                                         
                             assign insuguia.cd-tab-preco = partinsu.cd-tab-preco                                                      
                                    insuguia.cd-modulo    = partinsu.cd-modulo.                                                        
                                                                                                                                       
                             find first precproc where precproc.cd-tab-preco = partinsu.cd-tab-preco no-lock no-error.                 
                                                                                                                                       
                             if avail precproc                                                                                         
                             then assign insuguia.cd-forma-pagto     = precproc.cd-forma-pagto                                         
                                         insuguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.                                        
                                                                                                                                       
                           end.      
                      else do:
                             find first plamodpr 
                                  where plamodpr.cd-modalidade          = cd-modalidade-aux
                                    and plamodpr.cd-plano               = cd-plano-aux
                                    and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                                    and plamodpr.in-procedimento-insumo = "I"
                                    and plamodpr.cd-modulo              = import-guia-movto.cd-modulo
                                        no-lock no-error.
                             
                             if avail plamodpr
                             then do:
                                    assign insuguia.cd-tab-preco-cob = plamodpr.cd-tab-preco.
                             
                                    find first precproc where precproc.cd-tab-preco = plamodpr.cd-tab-preco no-lock no-error.
                             
                                    if avail precproc
                                    then assign insuguia.cd-forma-pagto     = precproc.cd-forma-pagto
                                                insuguia.cd-forma-pagto-cob = precproc.cd-forma-pagto.
                                  end.
                           end.
                      
                      /* -------------- QTD MOEDA PAGTO ------------------------- */
                      if paramecp.cd-unimed = import-guia.cd-unidade-carteira
                      then do:
                             find propost where propost.cd-modalidade = cd-modalidade-aux
                                            and propost.nr-ter-adesao = nr-ter-adesao-aux
                                                no-lock no-error.
                      
                             if avail propost
                             then assign insuguia.cd-tab-preco-proc-cob = propost.cd-tab-preco-proc.
                           end.
                      else do:
                             find unicamco where unicamco.cd-unidade = import-guia.cd-unidade-carteira
                                             and unicamco.dt-limite >= import-guia.dat-solicit
                                                 no-lock no-error.
                      
                             if avail unicamco
                             then assign insuguia.cd-tab-preco-proc-cob = unicamco.cd-tab-preco-proc-cob.
                           end.
                      
                      /* -------------- DESCRICAO INSUMO GENERICO ------------------------------ */
                      if  import-guia-movto.des-insumo <> ?
                      and import-guia-movto.des-insumo <> ""
                      then assign insuguia.char-4 = import-guia-movto.des-insumo. /* Descricao do insumo generico */
                      
                      /* --------------------- ANEXOS CLINICOS TISS -------------------------- */
                      if in-tipo-guia-par = "QUIM"
                      then assign insuguia.int-2 = 1.
                      else do:
                             if in-tipo-guia-par = "RADI"
                             then assign insuguia.int-2 = 2.
                             else do:
                                    if in-tipo-guia-par = "OPME"
                                    then assign insuguia.int-2 = 3.
                                    else assign insuguia.int-2 = 0.
                                  end.
                           end.
                      
                      create insumo-guia-comp.
                      assign insumo-guia-comp.cdn-unid             = paramecp.cd-unimed                      
                             insumo-guia-comp.num-ano-guia-atendim = aa-guia-atendimento-aux                 
                             insumo-guia-comp.num-guia-atendim     = nr-guia-atendimento-aux                 
                             insumo-guia-comp.num-proces           = 0                                       
                             insumo-guia-comp.num-seq-digitac      = nr-seq-digitacao-ins-aux                
                             insumo-guia-comp.cod-opc              = trim(import-guia-movto.des-opc-fabrican)
                             insumo-guia-comp.cdn-via-adm          = int(import-guia-movto.cdn-via-administ)
                             insumo-guia-comp.dat-previs-adm       = import-guia-movto.dat-previs
                             insumo-guia-comp.cdn-freq             = import-guia-movto.cdn-freq.
                      
                      validate insuguia.
                      release insuguia.
                      
                      validate insumo-guia-comp.
                      release insumo-guia-comp.
                      
                      run grava-glosas(input in-tipo-guia-par,
                                       input import-guia-movto.val-seqcial,
                                       input val-seq-guia-par,
                                       input aa-guia-atendimento-aux,
                                       input nr-guia-atendimento-aux, 
                                       input 0, /* nr-processo */
                                       input nr-seq-digitacao-ins-aux,
                                       input "I"). /* in-origem-glosa */
                      
                      assign nr-seq-digitacao-ins-aux = nr-seq-digitacao-ins-aux + 1.
               end.
             end.
    end. /* each import-guia-movto */

end procedure.

/* ----------------------------------------------------------------- */
procedure grava-glosas:

    def input parameter ind-tip-guia-par      as char no-undo.
    def input parameter val-seqcial-movto-par as int  no-undo.
    def input parameter val-seq-guia-par      as int  no-undo.
    def input parameter aa-guia-atend-par     as int  no-undo.
    def input parameter nr-guia-atend-par     as int  no-undo.
    def input parameter nr-processo-par       as int  no-undo.
    def input parameter nr-seq-digitacao-par  as int  no-undo.
    def input parameter in-origem-glosa-par   as char no-undo.

    RUN escrever-log("@@@@@vai ler import-movto-glosa. modulo: AT ind-tip-guia-par: " + STRING(ind-tip-guia-par)
                     + " val-seqcial-movto-par: " + STRING(val-seqcial-movto-par)
                     + " val-seq-guia-par: " + STRING(val-seq-guia-par)).


    for each import-movto-glosa
       where import-movto-glosa.in-modulo         = "AT"
         and import-movto-glosa.ind-tip-guia      = ind-tip-guia-par
         and import-movto-glosa.val-seqcial-movto = val-seqcial-movto-par
         and import-movto-glosa.val-seq-guia      = val-seq-guia-par
             no-lock:

        RUN escrever-log("@@@@@criando movatglo ano: " + STRING(aa-guia-atend-par) + " guia:" 
                     + STRING(nr-guia-atend-par) + " glosa: " + STRING(import-movto-glosa.cd-cod-glo)).

/*
pu    movatgl1                      N/A       6 + cd-unidade
                                                + aa-guia-atendimento
                                                + nr-guia-atendimento
                                                + nr-processo
                                                + nr-seq-digitacao
                                                + cd-classe-erro
*/
        IF NOT CAN-FIND(FIRST movatglo
                        WHERE movatglo.cd-unidade          = paramecp.cd-unimed
                          and movatglo.aa-guia-atendimento = aa-guia-atend-par
                          and movatglo.nr-guia-atendimento = nr-guia-atend-par
                          and movatglo.nr-processo         = nr-processo-par
                          and movatglo.nr-seq-digitacao    = nr-seq-digitacao-par
                          and movatglo.cd-classe-erro      = import-movto-glosa.cd-classe-erro)
        THEN DO:
        create movatglo.
        assign movatglo.cd-unidade          = paramecp.cd-unimed
               movatglo.aa-guia-atendimento = aa-guia-atend-par
               movatglo.nr-guia-atendimento = nr-guia-atend-par
               movatglo.nr-processo         = nr-processo-par
               movatglo.nr-seq-digitacao    = nr-seq-digitacao-par
               movatglo.cd-classe-erro      = import-movto-glosa.cd-classe-erro
               
               movatglo.in-origem-glosa     = in-origem-glosa-par
               movatglo.cd-cod-glo          = import-movto-glosa.cd-cod-glo
               movatglo.ds-motivo-glosa     = import-movto-glosa.des-motiv-glosa
               movatglo.cd-userid           = v_cod_usuar_corren
               movatglo.dt-atualizacao      = today
               movatglo.qti-quant-proced-dispon = import-movto-glosa.qti-quant-proced-dispon.

        validate movatglo.
        release movatglo.
             END.
    end. /* each import-movto-glosa */

end procedure.

/* ----------------------------------------------------------------- */
procedure gera-seq-guia:

    /**
     * 12/12/2016 - Alex Boeira
     *              Logica retirada pois as guias devem ser criadas no TOTVS de acordo com a numeracao ja gerada
     *              anteriormente no Unicoo, pois os prestadores enviarao as cobrancas com esses mesmos numeros.
    assign aa-guia-atendimento-aux = year(today).

    IF CAN-FIND(first guiautor 
                where guiautor.cd-unidade          = paramecp.cd-unimed
                  and guiautor.aa-guia-atendimento = year(today))
    then assign nr-guia-atendimento-aux = next-value (seq-guiautor).
    else do:
           assign nr-guia-atendimento-aux = 1.

           &if   "{&tipo-banco}" = "normal"
           &then assign current-value(seq-guiautor) = 1.
           &else do:
                   do transaction:
                      run stored-proc shsrcadger.send-sql-statement hand1 = proc-handle
                      ("drop sequence seq_guiautor").

                      run stored-proc shsrcadger.send-sql-statement hand1 = proc-handle
                      ("create sequence seq_guiautor start with 1 minvalue 0 maxvalue 99999999 nocycle nocache increment by 1").

                      close stored-proc shsrcadger.send-sql-statement where proc-handle = hand1.

                   end.

                   assign nr-guia-atendimento-aux = next-value (seq-guiautor).
                 end.
           &endif
         end.
    */
    ASSIGN aa-guia-atendimento-aux = import-guia.aa-guia-atendimento
           nr-guia-atendimento-aux = import-guia.nr-guia-atendimento.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-odontologia:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-odonto where import-guia-odonto.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-odonto
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Registro import-guia-odonto nao encontrado",
                          input today,
                          input "Registro referente a guia de Odontologia nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  avail tranrevi
    and not tranrevi.lg-transacao-odontologica
    then do:
           IF tranrevi.cd-transacao <> ?
           THEN char-aux1 = string(tranrevi.cd-transacao).
           ELSE char-aux1 = "nulo".
           IF import-guia-odonto.num-seq-import <> ?
           THEN char-aux2 = string(import-guia-odonto.num-seq-import).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Transacao nao e de odontologia. Transacao: " + char-aux1 + 
                                " import-guia-odonto.num-seq-import: " + char-aux2,
                          input today,
                          input "Para guias de odontologia, informe transacao de odontologia").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  avail tip-guia
    and not tip-guia.lg-transacao-odontologica
    then do:         
           IF tip-guia.cd-tipo-guia <> ?
           THEN char-aux1 = string(tip-guia.cd-tipo-guia).
           ELSE char-aux1 = "nulo".
           IF import-guia-odonto.num-seq-import <> ?
           THEN char-aux2 = string(import-guia-odonto.num-seq-import).
           ELSE char-aux2 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo de Guia nao e de odontologia. Tipo de guia: " + char-aux1 + 
                                " import-guia-odonto.num-seq-import: " + char-aux2,
                          input today,
                          input "Para guias de odontologia, informe um tipo de guia de odontologia").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-guia-odonto.ind-tip-atendim) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Atendimento invalido: "       + import-guia-odonto.ind-tip-atendim +
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe um valor conforme a tabela 51 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    if int(import-guia-odonto.ind-tip-atendim) < 1
    or int(import-guia-odonto.ind-tip-atendim) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Atendimento invalido: " + import-guia-odonto.ind-tip-atendim + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe um valor conforme a tabela 51 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-guia-odonto.ind-tip-faturam) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Faturamento invalido: " + import-guia-odonto.ind-tip-faturam + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import), 
                          input today,
                          input "Informe um valor conforme a tabela 55 da TISS.").

           assign lg-erro-par = yes.
         end.

    if int(import-guia-odonto.ind-tip-faturam) < 1
    or int(import-guia-odonto.ind-tip-faturam) > 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Tipo de Atendimento invalido: " + import-guia-odonto.ind-tip-faturam + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe um valor conforme a tabela 55 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    IF NOT CAN-FIND(FIRST preserv
                    WHERE preserv.cd-unidade   = import-guia-odonto.cd-unidade-exec
                      AND preserv.cd-prestador = import-guia-odonto.cd-prestador-exec)
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Prestador executante nao encontrado." +
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Verifique se o prestador informado existe no Cadastro de Prestadores.").
           assign lg-erro-par = yes.
         END.

    run busca-vinculo-prestador(input  import-guia-odonto.cd-unidade-exec,
                                input  import-guia-odonto.cd-prestador-exec,
                                input  import-guia-odonto.cd-especialid-exec,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados." +  
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) + 
                                " Espec.(import-guia-odonto.cd-especialid-exec): " + string(import-guia-odonto.cd-especialid-exec) + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia        = "ODON"
                  tmp-prest-exec.val-seqcial         = import-guia-odonto.num-seqcial-guia
                  tmp-prest-exec.cd-unidade          = import-guia-odonto.cd-unidade-exec
                  tmp-prest-exec.cd-prestador        = import-guia-odonto.cd-prestador-exec
                  tmp-prest-exec.cd-espec            = import-guia-odonto.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo          = cd-vinculo-aux
                  tmp-prest-exec.nm-prest-exec-compl = trim(import-guia-odonto.nom-prestdor-executa)
                  tmp-prest-exec.nm-conselho         = trim(import-guia-odonto.cod-cons-exec)
                  tmp-prest-exec.nr-registro         = import-guia-odonto.num-livre-1
                  tmp-prest-exec.uf-conselho         = trim(import-guia-odonto.cod-uf-cons-medic)
                  tmp-prest-exec.cd-cbo              = trim(import-guia-odonto.cod-cbo-prestdor-exec).
         end.

    /* ------------ PRESTADOR EXECUTANTE --------------------------- */
    find preserv where preserv.cd-unidade   = import-guia-odonto.cd-unidade-exec
                   and preserv.cd-prestador = import-guia-odonto.cd-prestador-exec
                       no-lock no-error.

    if not avail preserv
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Prestador executante nao cadastrado. " + 
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe um codigo de prestador cadastrado no Gestao de Planos.").
           
           assign lg-erro-par = yes.
         end.
    else do:
           if preserv.in-tipo-pessoa = "J"
           then do:
                  if import-guia-odonto.nom-prestdor-executa = ?
                  or import-guia-odonto.nom-prestdor-executa = ""
                  then do:
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia-odonto",
                                        input "Nome do prestador executante complementar deve ser informado. " + 
                                              " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                              " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) + 
                                              " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                                        input today,
                                        input "Quando o prestador executante for pessoa juridica, o nome do prestador executante deve ser informado.").
                         
                         assign lg-erro-par = yes.
                       end.
                end.
         end.

    if import-guia-odonto.cod-cons-exec = ?
    or import-guia-odonto.cod-cons-exec = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Conselho do prestador executante nao informado. " +
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) + 
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe o conselho do prestador executante.").

           assign lg-erro-par = yes.
         end.
    else do:
           if not can-find(conpres where conpres.cd-conselho = trim(import-guia-odonto.cod-cons-exec))
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-odonto",
                                 input "Conselho do prestador executante nao cadastrado. " + 
                                       " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                       " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) +  
                                       " Conselho: " + string(import-guia-odonto.cod-cons-exec) + 
                                       " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                                 input today,
                                 input "Informe um codigo de conselho cadastrado no Gestao de Planos.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    if import-guia-odonto.cod-cbo-prestdor-exec = ?
    or import-guia-odonto.cod-cbo-prestdor-exec = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "CBO do prestador executante nao informado. " + 
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) +  
                                "import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe o CBO do prestador executante").

           assign lg-erro-par = yes.
         end.

    if import-guia-odonto.cod-uf-cons-medic = ?
    or import-guia-odonto.cod-uf-cons-medic = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "UF do conselho do prestador executante nao informado." +
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) +  
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Infome a UF do conselho do prestador executante.").

           assign lg-erro-par = yes.
         end.

    if import-guia-odonto.num-livre-1 = ? /* Numero do registro do prestador no conselho */
    or import-guia-odonto.num-livre-1 = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-odonto",
                          input "Numero do registro no conselho do prestador executante nao informado. " + 
                                " Unidade(import-guia-odonto.cd-unidade-exec): " + string(import-guia-odonto.cd-unidade-exec) + 
                                " Prestador(import-guia-odonto.cd-prestador-exec): " + string(import-guia-odonto.cd-prestador-exec) +      
                                " import-guia-odonto.num-seq-import: " + string(import-guia-odonto.num-seq-import),
                          input today,
                          input "Informe o numero do registro do prestador.").

           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS INTERNACAO -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "ODON" /* Odontologia */
         and import-guia-movto.val-seq-guia = import-guia-odonto.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-odonto",
                              input "Tipo do movimento informado invalido: "          + import-guia-movto.ind-tip-movto-guia   + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                    " import-guia-odonto.num-seq-import: "            + string(import-guia-odonto.num-seq-import),
                              input today,  
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-odonto.num-seqcial-guia,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-anexo-odonto:

    def input-output parameter lg-erro-par as log init no no-undo.
    
    find first import-anexo-odonto where import-anexo-odonto.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-odonto
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-odonto",
                          input "Registro import-anexo-odonto nao encontrado. import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Registro referente ao anexo de Odontologia nao encontrado.").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ------------- VALIDA OS MOVIMENTOS DO ANEXO DE ODONTO ------------- */
    for each import-anexo-odonto-mov
       where import-anexo-odonto-mov.num-seqcial-anexo = import-anexo-odonto.num-seqcial
             no-lock:

        int(import-anexo-odonto-mov.tp-dente-regiao) no-error.

        if error-status:error
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-odonto-mov",
                              input "Dente invalido: " + import-anexo-odonto-mov.tp-dente-regiao +
                                    " import-anexo-odonto-mov.num-seqcial-anexo: " + string(import-anexo-odonto-mov.num-seqcial-anexo) + 
                                    " import-anexo-odonto.num-seqcial: " + string(import-anexo-odonto.num-seqcial),
                              input today,
                              input "Informe um codigo valido para o dente").
               
               assign lg-erro-par = yes.
             end.

        if  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 11
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 18
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 21
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 28
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 51
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 55
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 61
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 65
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 71
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 75
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 81
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 85
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 41
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 48
            )
        or  (    int(import-anexo-odonto-mov.tp-dente-regiao) >= 31
             and int(import-anexo-odonto-mov.tp-dente-regiao) <= 38
            )
        then . /* Perdao! Complicado negar esse if ... */
        else do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-odonto-mov",
                              input "Dente invalido: " + import-anexo-odonto-mov.tp-dente-regiao + 
                                    " import-anexo-odonto-mov.num-seqcial-anexo: " + string(import-anexo-odonto-mov.num-seqcial-anexo) + 
                                    " import-anexo-odonto.num-seqcial: " + string(import-anexo-odonto.num-seqcial),
                              input today,
                              input "Informe um codigo valido para o dente").
               
               assign lg-erro-par = yes.
             end.

        if  import-anexo-odonto-mov.ind-sit-inicial <> ?
        and import-anexo-odonto-mov.ind-sit-inicial <> ""
        then do:
               assign ds-sit-ini-aux = trim(import-anexo-odonto-mov.ind-sit-inicial).

               do ix = 1 to length(ds-sit-ini-aux):
                   if  substr(ds-sit-ini-aux,ix,1) <> "A" /* Ausente */
                   and substr(ds-sit-ini-aux,ix,1) <> "E" /* Extracao Indicada */
                   and substr(ds-sit-ini-aux,ix,1) <> "H" /* Higido */
                   and substr(ds-sit-ini-aux,ix,1) <> "C" /* Cariado */
                   and substr(ds-sit-ini-aux,ix,1) <> "R" /* Restaurado */
                   then do:
                          run grava-erro(input import-guia.num-seqcial-control,
                                         input "import-anexo-odonto-mov",
                                         input "Situacao do dente invalida: " + substr(ds-sit-ini-aux,ix,1) + 
                                               " import-anexo-odonto-mov.num-seqcial-anexo: " + string(import-anexo-odonto-mov.num-seqcial-anexo) + 
                                               " import-anexo-odonto.num-seqcial: " + string(import-anexo-odonto.num-seqcial),
                                         input today,
                                         input "Informe um codigo valido para a situacao do dente").
                          
                          assign lg-erro-par = yes.
                        end.
               end.
             end.
    end. /* each import-anexo-odonto-mov */

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-radioterapia:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-anexo-radio where import-anexo-radio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-radio
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Registro import-anexo-radio nao encontrado. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Registro referente ao anexo de Radioterapia nao encontrado.").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  import-anexo-radio.des-cirurgia-ant <> ?
    and import-anexo-radio.des-cirurgia-ant <> ""
    and import-anexo-radio.dat-realiz = ?
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Data de realizacao da ultima cirurgia nao informada. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Quando informado a descricao da cirurgia anterior, a data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    if  import-anexo-radio.des-quimio <> ?
    and import-anexo-radio.des-quimio <> ""
    and import-anexo-radio.dat-aplic = ?
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Data de realizacao da ultima quimioterapia nao informada. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Quando informado a descricao da qiomioterapia anterior, a data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.qti-campos = ?
    or import-anexo-radio.qti-campos = 0
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo Numero de Campos irradiados nao informado. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 +
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informa a quantidade de campos irradiados.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.qtd-dosag-diaria = ?
    or import-anexo-radio.qtd-dosag-diaria = 0
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo quantidade de doses diarias nao informado. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informa a quantidade de doses diarias.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.qtd-dosag-tot = ?
    or import-anexo-radio.qtd-dosag-tot = 0
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo quantidade de doses total nao informado. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informa a quantidade de doses total.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.num-dias = ?
    or import-anexo-radio.num-dias = 0
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo Numero de Dias nao informado. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 +     
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe Numero de Dias do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-radio.dat-inic-adm = ?
    then do:
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Campo Data de Inicio do Tratamento nao informado. import-anexo-radio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe a data de inicio do tratamento.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-radio.cod-estag) no-error.

    if error-status:error
    then do:
           IF import-anexo-radio.cod-estag <> ?
           THEN char-aux1 = import-anexo-radio.cod-estag.
           ELSE char-aux1 = "nulo".
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo do estadiamento do tumor invalido: " + char-aux1 + 
                                " import-anexo-radio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    if int(import-anexo-radio.cod-estag) < 1
    or int(import-anexo-radio.cod-estag) > 5
    then do:
           IF import-anexo-radio.cod-estag <> ?
           THEN char-aux1 = import-anexo-radio.cod-estag.
           ELSE char-aux1 = "nulo".
           IF import-anexo-radio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-radio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo do estadiamento do tumor invalido: " + char-aux1 + 
                                " import-anexo-radio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-radio.ind-finalid-tratam) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da finalidade do tratamento invalida: " + import-anexo-radio.ind-finalid-tratam + 
                                " import-anexo-radio.num-seqcial-import-anexo " + string(import-anexo-radio.num-seqcial-import-anexo) + 
                                " import-anexo-solicit.num-seqcial: " +  string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    if int(import-anexo-radio.ind-finalid-tratam) < 1
    or int(import-anexo-radio.ind-finalid-tratam) > 5
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da finalidade do tratamento invalida: " + import-anexo-radio.ind-finalid-tratam + 
                                " import-anexo-radio.num-seqcial-import-anexo: "  + string(import-anexo-radio.num-seqcial-import-anexo) +
                                " import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-radio.cod-classif-capac-funcnal) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da escala de capacidade funcional invalido: " + import-anexo-radio.cod-classif-capac-funcnal + 
                                " import-anexo-radio.num-seqcial-import-anexo: " + string(import-anexo-radio.num-seqcial-import-anexo) + 
                                " import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").

           assign lg-erro-par = yes.
         end.

    if int(import-anexo-radio.cod-classif-capac-funcnal) < 0
    or int(import-anexo-radio.cod-classif-capac-funcnal) > 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-radio",
                          input "Codigo da escala de capacidade funcional invalido: " + import-anexo-radio.cod-classif-capac-funcnal + 
                                " import-anexo-radio.num-seqcial-import-anexo: " + string(import-anexo-radio.num-seqcial-import-anexo) + 
                                " import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").

           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS RADIOTERAPIA -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "RADI" /* Radioterapia */
         and import-guia-movto.val-seq-guia = import-anexo-radio.num-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-radio",
                              input "Tipo do movimento informado invalido: "          + import-guia-movto.ind-tip-movto-guia + 
                                    " import-anexo-radio.num-seqcial-import-anexo: "  + string(import-anexo-radio.num-seqcial-import-anexo) + 
                                    " import-anexo-solicit.num-seqcial: "             + string(import-anexo-solicit.num-seqcial) + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                              input today,
                              input "Anexo de quimioterapia somente aceita procedimentos").

               assign lg-erro-par = yes.
             end.

        if import-guia-movto.dat-previs = ?
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-radio",
                              input "Data Prevista para aplicacao do medicamento deve ser informada. " +
                                    " import-anexo-radio.num-seqcial-import-anexo: "  + string(import-anexo-radio.num-seqcial-import-anexo) +
                                    " import-anexo-solicit.num-seqcial: "             + string(import-anexo-solicit.num-seqcial) +  
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                              input today,
                              input "Informe o campo Data Prevista.").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-anexo-radio.num-seqcial,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-opme:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-anexo-opme where import-anexo-opme.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-opme
    then do:
           IF import-anexo-opme.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-opme.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF string(import-anexo-solicit.num-seqcial) <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-opme",
                          input "Registro import-anexo-opme nao encontrado. import-anexo-opme.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Registro referente ao anexo de OPME nao encontrado.").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-opme.des-justificativa = ?
    or import-anexo-opme.des-justificativa = ""
    then do: 
           IF import-anexo-opme.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-opme.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-opme",
                          input "Justificativa Tecnica do material solicitado nao informada. import-anexo-opme.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe a justificativa tecnica").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    /*
    if import-anexo-opme.des-especif-mater = ?
    or import-anexo-opme.des-especif-mater = ""
    then do:
           IF import-anexo-opme.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-opme.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-opme",
                          input "Especificacao do material solicitado nao informada. import-anexo-opme.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe a especificacao do material.").
           
           assign lg-erro-par = yes.
         end.
*/
    /* ------------------- MOVIMENTOS OPME -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "OPME"
         and import-guia-movto.val-seq-guia = import-anexo-opme.num-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               IF import-guia-movto.ind-tip-movto-guia <> ?
               THEN char-aux1 = import-guia-movto.ind-tip-movto-guia.
               ELSE char-aux1 = "nulo".
               IF import-anexo-opme.num-seqcial-import-anexo <> ?
               THEN char-aux2 = string(import-anexo-opme.num-seqcial-import-anexo).
               ELSE char-aux2 = "nulo".
               if import-anexo-solicit.num-seqcial <> ?
               THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
               ELSE char-aux3 = "nulo".
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-opme",
                              input "Tipo do movimento informado invalido: " + char-aux1 + 
                                    " import-anexo-opme.num-seqcial-import-anexo: " + char-aux2 + 
                                    " import-anexo-solicit.num-seqcial: " + char-aux3,
                              input today,
                              input "Anexo de quimioterapia somente aceita insumos OPME").

               assign lg-erro-par = yes.
             end.

        int(import-guia-movto.des-opc-fabrican) no-error.

        if error-status:error
        or int(import-guia-movto.des-opc-fabrican) <= 0
        then do:
               IF import-guia-movto.ind-tip-movto-guia <> ?
               then char-aux1 = import-guia-movto.ind-tip-movto-guia.
               else char-aux1 = "nulo".
               IF import-anexo-opme.num-seqcial-import-anexo <> ?
               THEN char-aux2 = string(import-anexo-opme.num-seqcial-import-anexo).
               else char-aux2 = "nulo".
               IF import-anexo-solicit.num-seqcial <> ?
               THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
               ELSE char-aux3 = "nulo".
               
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-opme",
                              input "Opcao do fabricante invalida: " + char-aux1 + 
                                    " import-anexo-opme.num-seqcial-import-anexo: " + char-aux2 + 
                                    " import-anexo-solicit.num-seqcial: " + char-aux3,
                              input today,
                              input "Informe um valor maior que zero").
               
               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-anexo-opme.num-seqcial,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-quimioterapia:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-anexo-quimio where import-anexo-quimio.num-seqcial-import-anexo = import-anexo-solicit.num-seqcial
                                   no-lock no-error.

    if not avail import-anexo-quimio
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Tabela import-anexo-quimio nao encontrada. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Registro referente ao anexo de quimioterapia nao encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.val-peso-bnfciar = ?
    or import-anexo-quimio.val-peso-bnfciar = 0
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           else char-aux2 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Peso do beneficiario nao informado. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe o peso do beneficiario").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    /*
    if import-anexo-quimio.val-alt-bnfciar = ?
    or import-anexo-quimio.val-alt-bnfciar = 0
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Altura do beneficiario nao informado. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe a altura do beneficiario").
           
           assign lg-erro-par = yes.
         end.
     */
    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.val-sup-cor-bnfciar = ?
    or import-anexo-quimio.val-sup-cor-bnfciar = 0
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           then char-aux2 = string(import-anexo-solicit.num-seqcial).
           else char-aux2 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Superficie corporal do beneficiario nao informada. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe a superficie corporal do beneficiario").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.num-ciclo = ?
    or import-anexo-quimio.num-ciclo = 0
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           then Char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux3 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Campo Numero de Ciclos nao informado. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe o numero de ciclos do tratamento. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux3).
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.num-ciclo-atual = ?
    or import-anexo-quimio.num-ciclo-atual = 0
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           else CHAR-aux2 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux3 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Campo Numero do Ciclo Atual nao informado import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe o numero do ciclo atual do tratamento. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux3).
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.num-interv-ciclo = ?
    or import-anexo-quimio.num-interv-ciclo = 0
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           else char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux3 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Campo Numero de Intervalo entre Ciclos nao informado import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Informe o numero do intervalo entre ciclos do tratamento. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux3).
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  import-anexo-quimio.des-cirurgia-ant <> ?
    and import-anexo-quimio.des-cirurgia-ant <> ""
    and import-anexo-quimio.dt-realizacao     = ?
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux3 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Data de realizacao de cirurgia anterior nao informada. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Quando informada descricao da cirurgia anterior, a sua data deve ser informada. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux3).
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  import-anexo-quimio.des-area <> ?
    and import-anexo-quimio.des-area <> ""
    and import-anexo-quimio.dat-aplic-radio = ?
    then do:
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux1 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux1 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux2 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux2 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Data de aplicacao da radioterapia anterior nao informada. import-anexo-quimio.num-seqcial-import-anexo: " + char-aux1 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux2,
                          input today,
                          input "Quando informada descricao da radioterapia anterior, a sua data deve ser informada.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.cod-estag) no-error.

    if error-status:error
    then do:
           IF import-anexo-quimio.cod-estag <> ?
           THEN char-aux1 = import-anexo-quimio.cod-estag.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           if import-anexo-solicit.num-seqcia <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do estadiamento do tumor invalido: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.cod-estag) < 1
    or int(import-anexo-quimio.cod-estag) > 5
    then do:
           if import-anexo-quimio.cod-estag <> ?
           THEN char-aux1 = import-anexo-quimio.cod-estag.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           else char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do estadiamento do tumor invalido: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.ind-finalid-tratam) no-error.

    if error-status:error
    then do:
           IF import-anexo-quimio.ind-finalid-tratam <> ?
           THEN char-aux1 = import-anexo-quimio.ind-finalid-tratam.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           else char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da finalidade do tratamento invalida: " + char-aux1 +
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.ind-finalid-tratam) < 1
    or int(import-anexo-quimio.ind-finalid-tratam) > 5
    then do:
           IF import-anexo-quimio.ind-finalid-tratam <> ?
           THEN char-aux1 = import-anexo-quimio.ind-finalid-tratam.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           then char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           if import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           else char-aux3 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da finalidade do tratamento invalida: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 31 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.ind-tip-quimio) no-error.

    if error-status:error
    then do:
           IF import-anexo-quimio.ind-tip-quimio <> ?
           THEN char-aux1 = import-anexo-quimio.ind-tip-quimio.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           then char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do tipo de quimioterapia invalido: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 58 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.ind-tip-quimio) < 1
    or int(import-anexo-quimio.ind-tip-quimio) > 4
    then do:
           IF import-anexo-quimio.ind-tip-quimio <> ?
           THEN char-aux1 = import-anexo-quimio.ind-tip-quimio.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo do tipo de quimioterapia invalido: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 58 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    int(import-anexo-quimio.cod-classif-capac-funcnal) no-error.

    if error-status:error
    then do:
           IF import-anexo-quimio.cod-classif-capac-funcnal <> ?
           THEN char-aux1 = import-anexo-quimio.cod-classif-capac-funcnal.
           ELSE char-aux1 = "nulo".
           IF import-anexo-quimio.num-seqcial-import-anexo <> ?
           THEN char-aux2 = string(import-anexo-quimio.num-seqcial-import-anexo).
           ELSE char-aux2 = "nulo".
           IF import-anexo-solicit.num-seqcial <> ?
           THEN char-aux3 = string(import-anexo-solicit.num-seqcial).
           ELSE char-aux3 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da escala de capacidade funcional invalido: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + char-aux2 + 
                                " import-anexo-solicit.num-seqcial: " + char-aux3,
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if int(import-anexo-quimio.cod-classif-capac-funcnal) < 0
    or int(import-anexo-quimio.cod-classif-capac-funcnal) > 4
    then do:
           IF import-anexo-quimio.cod-classif-capac-funcnal <> ?
           THEN char-aux1 = import-anexo-quimio.cod-classif-capac-funcnal.
           else char-aux1 = "nulo".
           
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Codigo da escala de capacidade funcional invalido: " + char-aux1 + 
                                " import-anexo-quimio.num-seqcial-import-anexo: " + string(import-anexo-quimio.num-seqcial-import-anexo) + 
                                " import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informe um codigo conforme a tabela 30 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-anexo-quimio.des-plano-terap = ?
    or import-anexo-quimio.des-plano-terap = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-quimio",
                          input "Descricao do plano terapeutico nao informado. import-anexo-quimio.num-seqcial-import-anexo: " + string(import-anexo-quimio.num-seqcial-import-anexo) + 
                                " import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informe a descricao do plano terapeutico").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------- MOVIMENTOS QUIMIOTERAPIA -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "QUIM" /* Quimioterapia */
         and import-guia-movto.val-seq-guia = import-anexo-quimio.num-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Tipo do movimento informado invalido: " + import-guia-movto.ind-tip-movto-guia + 
                                    " import-anexo-quimio.num-seqcial-import-anexo: " + string(import-anexo-quimio.num-seqcial-import-anexo) +
                                    " import-anexo-solicit.num-seqcial: "             + string(import-anexo-solicit.num-seqcial) + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia)  +
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                              input today,
                              input "Anexo de quimioterapia somente aceita medicamentos (insumos)").

               assign lg-erro-par = yes.
             end.

        if import-guia-movto.dat-previs = ?
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Data Prevista para aplicacao do medicamento deve ser informada. " + 
                                    " import-anexo-quimio.num-seqcial-import-anexo: " + string(import-anexo-quimio.num-seqcial-import-anexo) + 
                                    " import-anexo-solicit.num-seqcial: "             + string(import-anexo-solicit.num-seqcial) + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia)  +
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                              input today,
                              input "Informe o campo Data Prevista.").
               
               assign lg-erro-par = yes.
             end.

        int(import-guia-movto.cdn-via-administ) no-error.

        if error-status:error
        then do:
               IF import-guia-movto.cdn-via-administ <> ?
               THEN char-aux1 = string(import-guia-movto.cdn-via-administ).
               else char-aux1 = "nulo".
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Via de administracao invalida: " + char-aux1 + 
                                    " import-anexo-quimio.num-seqcial-import-anexo: " + string(import-anexo-quimio.num-seqcial-import-anexo) +
                                    " import-anexo-solicit.num-seqcial: "             + string(import-anexo-solicit.num-seqcial) + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia)  +
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                              input today,
                              input "Informe um valor conforme a tabela 62 da TISS").
               
               assign lg-erro-par = yes.
             end.

        if import-guia-movto.cdn-freq = 0
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-anexo-quimio",
                              input "Frequencia de utilizacao deve ser informada (import-guia-movto.cdn-freq)." + 
                                    " import-anexo-quimio.num-seqcial-import-anexo: " + string(import-anexo-quimio.num-seqcial-import-anexo) +
                                    " import-anexo-solicit.num-seqcial: "             + string(import-anexo-solicit.num-seqcial) + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia)  +
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                              input today,
                              input "Informe o campo Frequencia.").
               
               assign lg-erro-par = yes.
             end.
        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-anexo-quimio.num-seqcial,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-dados-gerais-anexos:

    def input-output parameter lg-erro-par as log init no no-undo.

    if  trim(import-anexo-solicit.ind-tip-anexo) <> "1" /* Quimio */
    and trim(import-anexo-solicit.ind-tip-anexo) <> "2" /* Radio */
    and trim(import-anexo-solicit.ind-tip-anexo) <> "3" /* OPME */
    and trim(import-anexo-solicit.ind-tip-anexo) <> "4" /* Odonto */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-anexo-solicit",
                          input "Tipo do anexo informado invalido: "     + trim(import-anexo-solicit.ind-tip-anexo) + 
                                " import-anexo-solicit.num-seq-import: " + string(import-anexo-solicit.num-seq-import) + 
                                " import-anexo-solicit.num-seqcial: "    + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Informa um tipo de anexo valido: 1, 2, 3 ou 4").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  avail tip-guia
    and tip-guia.int-11 <> 1
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo de Guia nao aceita anexos clinicos TISS. import-anexo-solicit.num-seq-import: " + string(import-anexo-solicit.num-seq-import) + 
                                " import-anexo-solicit.num-seqcial: " + string(import-anexo-solicit.num-seqcial),
                          input today,
                          input "Para guias com anexos clinicos, informe um tipo de guia permita anexos clinicos TISS").

           assign lg-erro-par = yes.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-prorrogacao:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-prorrog where import-guia-prorrog.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-prorrog
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-prorrog",
                          input "Registro import-guia-prorrog nao encontrado",
                          input today,
                          input "Registro referente a guia de Prorrogacao nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  avail tip-guia
    and not tip-guia.log-29 /* Tipo de guia de prorrogacao */
    then do:        
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo de Guia nao e de prorrogacao (tip-guia.log-29). Tipo guia: " + string(tip-guia.cd-tipo-guia) +  
                                " import-guia-prorrog.num-seq-import: " + string(import-guia-prorrog.num-seq-import),
                          input today,
                          input "Para guias de prorrogacao, informe um tipo de guia de prorrogacao").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-guia.num-seqcial-princ = ?
    or import-guia.num-seqcial-princ = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-prorrog",
                          input "Codigo da guia principal deve ser informado. import-guia-prorrog.num-seq-import: " + string(import-guia-prorrog.num-seq-import),
                          input today,
                          input "O codigo da guia principal e obrigatorio para guias de prorrogacao.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if import-guia-prorrog.des-indic-clinic = ?
    or import-guia-prorrog.des-indic-clinic = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-prorrog",
                          input "Campo Indicacao clinica nao informado. import-guia-prorrog.num-seq-import: " + string(import-guia-prorrog.num-seq-import),
                          input today,
                          input "Informe a indicacao clinica para guia de prorrogacao.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    find guiautor where guiautor.cd-unidade          = paramecp.cd-unimed
                    and guiautor.aa-guia-atendimento = aa-guia-atend-ant-aux
                    and guiautor.nr-guia-atendimento = nr-guia-atend-ant-aux
                        no-lock no-error.

    if avail guiautor
    then do:
           find first procguia where procguia.cd-unidade          = guiautor.cd-unidade         
                                 and procguia.aa-guia-atendimento = guiautor.aa-guia-atendimento
                                 and procguia.nr-guia-atendimento = guiautor.nr-guia-atendimento
                                     no-lock no-error.

           if avail procguia
           then do:
                  create tmp-prest-exec.
                  assign tmp-prest-exec.in-tipo-guia = "PROR"
                         tmp-prest-exec.val-seqcial  = import-guia-prorrog.num-seqcial-guia
                         tmp-prest-exec.cd-unidade   = procguia.cd-unidade-prestador
                         tmp-prest-exec.cd-prestador = procguia.cd-prestador
                         tmp-prest-exec.cd-espec     = procguia.cd-esp-prest-executante
                         tmp-prest-exec.cd-vinculo   = procguia.cd-tipo-vinculo.
                end.
           else do:
                  find first insuguia where insuguia.cd-unidade          = guiautor.cd-unidade         
                                        and insuguia.aa-guia-atendimento = guiautor.aa-guia-atendimento
                                        and insuguia.nr-guia-atendimento = guiautor.nr-guia-atendimento
                                            no-lock no-error.

                  if avail insuguia
                  then do:
                         create tmp-prest-exec.
                         assign tmp-prest-exec.in-tipo-guia = "PROR"
                                tmp-prest-exec.val-seqcial  = import-guia-prorrog.num-seqcial-guia
                                tmp-prest-exec.cd-unidade   = insuguia.cd-unidade-prestador
                                tmp-prest-exec.cd-prestador = insuguia.cd-prestador
                                tmp-prest-exec.cd-espec     = insuguia.cd-esp-prest-executante
                                tmp-prest-exec.cd-vinculo   = insuguia.cd-tipo-vinculo.
                       end.
                end.
         end.

    /* ------------------- MOVIMENTOS INTERNACAO -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "PROR" /* Prorrogacao */
         and import-guia-movto.val-seq-guia = import-guia-prorrog.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-prorrog",
                              input "Tipo do movimento informado invalido: "     + import-guia-movto.ind-tip-movto-guia +
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): " + string(import-guia-movto.ind-tip-guia)     + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                    " import-guia-prorrog.num-seqcial-guia: "    + string(import-guia-prorrog.num-seqcial-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-prorrog.num-seqcial-guia,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-internacao:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-intrcao where import-guia-intrcao.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-intrcao
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Registro import-guia-intrcao nao encontrado. ",
                          input today,
                          input "Registro referente a guia de Internacao nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if import-guia-intrcao.dt-internacao = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo data sugerida para internacao nao foi informado. import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe o campo data sugerida para internacao").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------------- */
    if  trim(import-guia-intrcao.cod-caract-atendim) <> "E" /* Eletivo */
    and trim(import-guia-intrcao.cod-caract-atendim) <> "U" /* Urgencia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Carater da Solicitacao invalido (import-guia-intrcao.cod-caract-atendim): " + import-guia-intrcao.cod-caract-atendim + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informar um dos valores: E ou U.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.idi-acid <> 0
    and import-guia-intrcao.idi-acid <> 1
    and import-guia-intrcao.idi-acid <> 2
    and import-guia-intrcao.idi-acid <> 9
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Indicador de acidente invalido(import-guia-intrcao.idi-acid): " + string(import-guia-intrcao.idi-acid) + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if import-guia-intrcao.num-livre-1 < 1 /* tipo de atendimento Tiss*/
    or import-guia-intrcao.num-livre-1 < 5
    then do:
           if import-guia-intrcao.des-indcao-clinic = ?
           or import-guia-intrcao.des-indcao-clinic = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-intrcao",
                                 input "Campo Indicacao clinica nao informado. import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                                 input today,
                                 input "Informe a indicacao clinica para guia de internacao.").
                  
                  assign lg-erro-par = yes.
                end.
         end.

    /* ----------------------------------------------------------- */                                           
    if import-guia-intrcao.cdn-tip-inter < 1
    or import-guia-intrcao.cdn-tip-inter > 5
    then do:
           IF import-guia-intrcao.cdn-tip-inter <> ?
           THEN char-aux1 = string(import-guia-intrcao.cdn-tip-inter).
           ELSE char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo Tipo de Internacao invalido (import-guia-intrcao.cdn-tip-inter): " + char-aux1 + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um tipo de internacao conforme a tabela 57 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    int(import-guia-intrcao.cod-regim-intrcao) no-error.

    if error-status:error
    then do:
           IF import-guia-intrcao.cod-regim-intrcao <> ?
           THEN char-aux1 = import-guia-intrcao.cod-regim-intrcao.
           else char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo Regime de internacao invalido: " + char-aux1 + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um regime de internacao conforme a tabela 41 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */                                           
    if int(import-guia-intrcao.cod-regim-intrcao) < 1
    or int(import-guia-intrcao.cod-regim-intrcao) > 3
    then do:
           IF import-guia-intrcao.cod-regim-intrcao <> ?
           THEN char-aux1 = import-guia-intrcao.cod-regim-intrcao.
           else char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Campo Regime de internacao invalido (import-guia-intrcao.cod-regim-intrcao): " + char-aux1 + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um regime de internacao conforme a tabela 41 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-princ <> ?
    and import-guia-intrcao.cod-cid-princ <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-princ)
    then do:
           IF import-guia-intrcao.cod-cid-princ <> ?
           THEN char-aux1 = import-guia-intrcao.cod-cid-princ.
           else char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid principal nao cadastrado (import-guia-intrcao.cod-cid-princ): " + char-aux1 + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-2 <> ?
    and import-guia-intrcao.cod-cid-2 <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-2)
    then do:
           IF import-guia-intrcao.cod-cid-2 <> ?
           THEN char-aux1 = import-guia-intrcao.cod-cid-2.
           ELSE char-aux1 = "nuloi".

           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid nao cadastrado (import-guia-intrcao.cod-cid-2): " + char-aux1 +
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-3 <> ?
    and import-guia-intrcao.cod-cid-3 <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-3)
    then do:
           IF import-guia-intrcao.cod-cid-3 <> ?
           THEN char-aux1 = import-guia-intrcao.cod-cid-3.
           ELSE char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid nao cadastrado (import-guia-intrcao.cod-cid-3): " + char-aux1 +
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-intrcao.cod-cid-4 <> ?
    and import-guia-intrcao.cod-cid-4 <> ""
    and not can-find(dz-cid10 where dz-cid10.cd-cid = import-guia-intrcao.cod-cid-4)
    then do:
           IF import-guia-intrcao.cod-cid-4 <> ?
           THEN char-aux1 = import-guia-intrcao.cod-cid-4.
           ELSE char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Cid nao cadastrado (import-guia-intrcao.cod-cid-4): " + char-aux1 +
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Informe um CID cadastrado no Gestao de Planos").

           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    IF NOT CAN-FIND(FIRST preserv
                    WHERE preserv.cd-unidade   = import-guia-intrcao.cd-unidade-exec
                      AND preserv.cd-prestador = import-guia-intrcao.cd-prestador-exec)
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Prestador executante nao encontrado." +
                                " Unidade(import-guia-intrcao.cd-unidade-exec): " + string(import-guia-intrcao.cd-unidade-exec) + 
                                " Prestador(import-guia-intrcao.cd-prestador-exec): " + string(import-guia-intrcao.cd-prestador-exec) + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Verifique se o prestador informado existe no Cadastro de Prestadores.").
           assign lg-erro-par = yes.
         END.

    run busca-vinculo-prestador(input  import-guia-intrcao.cd-unidade-exec,
                                input  import-guia-intrcao.cd-prestador-exec,
                                input  import-guia-intrcao.cd-especialid-exec,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-intrcao",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados." +
                                " Unid: " + string(import-guia-intrcao.cd-unidade-exec) + 
                                " Prest: " + string(import-guia-intrcao.cd-prestador-exec) + 
                                " Espec: " + string(import-guia-intrcao.cd-especialid-exec) + 
                                " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import),
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia = "INTE"
                  tmp-prest-exec.val-seqcial  = import-guia-intrcao.num-seqcial-guia
                  tmp-prest-exec.cd-unidade   = import-guia-intrcao.cd-unidade-exec
                  tmp-prest-exec.cd-prestador = import-guia-intrcao.cd-prestador-exec
                  tmp-prest-exec.cd-espec     = import-guia-intrcao.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo   = cd-vinculo-aux.
         end.

    /* ------------------- MOVIMENTOS INTERNACAO -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "INTE" /* Consulta */
         and import-guia-movto.val-seq-guia = import-guia-intrcao.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-con",
                              input "Tipo do movimento informado invalido: " + import-guia-movto.ind-tip-movto-guia +
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): " + string(import-guia-movto.ind-tip-guia) + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                    " import-guia-intrcao.num-seq-import: " + string(import-guia-intrcao.num-seq-import) +
                                    " import-guia-intrcao.num-seqcial-guia: " + string(import-guia-intrcao.num-seqcial-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-intrcao.num-seqcial-guia,
                          input-output lg-erro-par).
    end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-sp-sadt:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-sadt where import-guia-sadt.val-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-sadt
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Registro import-guia-sadt nao encontrado",
                          input today,
                          input "Registro referente a guia de SP/SADT nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------------- */
    if  trim(import-guia-sadt.ind-carac-solicit) <> "E" /* Eletivo */
    and trim(import-guia-sadt.ind-carac-solicit) <> "U" /* Urgencia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Carater da Solicitacao invalido (import-guia-sadt.ind-carac-solicit): " + import-guia-sadt.ind-carac-solicit + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Informar um dos valores: E ou U.").
           
           assign lg-erro-par = yes.
         end.
    
    /* ----------------------------------------------------------------- */
    int(import-guia-sadt.ind-tip-atendim) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Tipo de Atendimento invalido (import-guia-sadt.ind-tip-atendim): " + import-guia-sadt.ind-tip-atendim + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Informar um tipo de atendimento conforme a tabela 50 da TISS").
           
           assign lg-erro-par = yes.
         end.

    if (int(import-guia-sadt.ind-tip-atendim) < 1
    or int(import-guia-sadt.ind-tip-atendim) > 21)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Tipo de Atendimento invalido (import-guia-sadt.ind-tip-atendim): " + import-guia-sadt.ind-tip-atendim + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Informar um tipo de atendimento conforme a tabela 50 da TISS").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    int(import-guia-sadt.ind-tip-acid) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Indicador de acidente invalido (import-guia-sadt.ind-tip-acid): " + import-guia-sadt.ind-tip-acid + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  int(import-guia-sadt.ind-tip-acid) <> 0
    and int(import-guia-sadt.ind-tip-acid) <> 1
    and int(import-guia-sadt.ind-tip-acid) <> 2
    and int(import-guia-sadt.ind-tip-acid) <> 9
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Indicador de acidente invalido (import-guia-sadt.ind-tip-acid): " + import-guia-sadt.ind-tip-acid + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if int(import-guia-sadt.ind-tip-atendim) = 4 /* Consulta */
    then do:
           int(import-guia-sadt.ind-tip-con) no-error.
           
           if error-status:error
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-sadt",
                                 input "Tipo de Consulta invalido (import-guia-sadt.ind-tip-atendim): " + import-guia-sadt.ind-tip-con + 
                                       " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                                 input today,
                                 input "Tipo de Atendimento e de consulta. Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
                  assign lg-erro-par = yes.
                end.
           
           /* ----------------------------------------------------------- */
           if  int(import-guia-sadt.ind-tip-con) <> 0
           and int(import-guia-sadt.ind-tip-con) <> 1
           and int(import-guia-sadt.ind-tip-con) <> 2
           and int(import-guia-sadt.ind-tip-con) <> 3
           and int(import-guia-sadt.ind-tip-con) <> 4
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-sadt",
                                 input "Tipo de Consulta invalido (import-guia-sadt.ind-tip-con): " + import-guia-sadt.ind-tip-con + 
                                       " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                                 input today,
                                 input "Tipo de Atendimento e de consulta. Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    /* ------------------------------------------------------------------------------------- */
    IF NOT CAN-FIND(FIRST preserv
                    WHERE preserv.cd-unidade   = import-guia-sadt.cd-unidade-exec
                      AND preserv.cd-prestador = import-guia-sadt.cd-prest-exec)
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Prestador executante nao encontrado." +
                                " Unidade(import-guia-sadt.cd-unidade-exec): " + string(import-guia-sadt.cd-unidade-exec) + 
                                " Prestador(import-guia-sadt.cd-prest-exec): " + string(import-guia-sadt.cd-prest-exec) + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Verifique se o prestador informado existe no Cadastro de Prestadores.").
           assign lg-erro-par = yes.
         END.

    run busca-vinculo-prestador(input  import-guia-sadt.cd-unidade-exec,
                                input  import-guia-sadt.cd-prest-exec,
                                input  import-guia-sadt.cd-especialid-exec,
                                input  import-guia.dat-solicit, 
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-sadt",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados." + 
                                " Unid: "  + string(import-guia-sadt.cd-unidade-exec) + 
                                " Prest: " + string(import-guia-sadt.cd-prest-exec) + 
                                " Espec: " + string(import-guia-sadt.cd-especialid-exec) + 
                                " import-guia-sadt.val-seq-import: " + string(import-guia-sadt.val-seq-import),
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia = "SADT"
                  tmp-prest-exec.val-seqcial  = import-guia-sadt.val-seqcial
                  tmp-prest-exec.cd-unidade   = import-guia-sadt.cd-unidade-exec
                  tmp-prest-exec.cd-prestador = import-guia-sadt.cd-prest-exec
                  tmp-prest-exec.cd-espec     = import-guia-sadt.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo   = cd-vinculo-aux.
         end.

    /* ------------------- MOVIMENTOS SADT -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "SADT" /* SADT */
         and import-guia-movto.val-seq-guia = import-guia-sadt.val-seqcial
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-sadt",
                              input "Tipo do movimento informado invalido (import-guia-movto.ind-tip-movto-guia): " + import-guia-movto.ind-tip-movto-guia + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                    " import-guia-sadt.val-seq-import: "              + string(import-guia-sadt.val-seq-import) +         
                                    " import-guia-sadt.val-seqcial: "                 + string(import-guia-sadt.val-seqcial),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").

               assign lg-erro-par = yes.
             end.

        if import-guia-movto.ind-tip-movto-guia = "P"
        and (   import-guia-sadt.des-indic-clinic = ?
             or import-guia-sadt.des-indic-clinic = ""
            )
        then do:
               assign cd-esp-amb-aux        = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2))
                      cd-grupo-proc-amb-aux = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2))
                      cd-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3))
                      dv-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1)).
               
               find ambproce where ambproce.cd-esp-amb        = cd-esp-amb-aux
                               and ambproce.cd-grupo-proc-amb = cd-grupo-proc-amb-aux
                               and ambproce.cd-procedimento   = cd-procedimento-aux
                               and ambproce.dv-procedimento   = dv-procedimento-aux
                                   no-lock no-error.
               
               if avail ambproce                                                               
               then do:                                                                        
                      find tiss-tip-atendim where tiss-tip-atendim.cdn-tip-atendim = ambproce.num-livre-6  /* Tipo de Atendimento do procedimento */
                                                  no-lock no-error.                                                  
               
                      if avail tiss-tip-atendim                                                
                      and tiss-tip-atendim.log-livre-2 /* Obriga Indicacao Clinica */
                      then do:                                                                                                                       
                             run grava-erro(input import-guia.num-seqcial-control,
                                            input "import-guia-sadt",
                                            input "Indicacao Clinica deve ser informada (import-guia-sadt.des-indic-clinic)." + 
                                                  " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                                  " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                                  " import-guia-sadt.val-seq-import: "              + string(import-guia-sadt.val-seq-import) + 
                                                  " import-guia-sadt.val-seqcial: "                 + string(import-guia-sadt.val-seqcial),
                                            input today,
                                            input "Tipo de Atendimento informado no cadastro de procedimentos obriga indicacao clinica. Campo deve ser informado").
                             
                             assign lg-erro-par = yes.
                           end.                                                                
                    end.   
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-sadt.val-seqcial,
                          input-output lg-erro-par).
    end.


end procedure.

/* ----------------------------------------------------------------- */
procedure valida-consulta:

    def input-output parameter lg-erro-par as log init no no-undo.

    find first import-guia-con where import-guia-con.num-seq-import = import-guia.num-seqcial no-lock no-error.

    if not avail import-guia-con
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Registro import-guia-con nao encontrado",
                          input today,
                          input "Registro referente a guia de consulta nao foi encontrado").
           
           assign lg-erro-par = yes.
           return.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia-con.in-acidente <> 0
    and import-guia-con.in-acidente <> 1
    and import-guia-con.in-acidente <> 2
    and import-guia-con.in-acidente <> 9
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Indicador de acidente invalido (import-guia-con.in-acidente): " + string(import-guia-con.in-acidente) + 
                                " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import),
                          input today,
                          input "Informe um indicador conforme a tabela 36 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    int(import-guia-con.ind-tip-con) no-error.

    if error-status:error
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Tipo de Consulta invalido (import-guia-con.ind-tip-con): " + import-guia-con.ind-tip-con + 
                                " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import),
                          input today,
                          input "Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  int(import-guia-con.ind-tip-con) <> 1
    and int(import-guia-con.ind-tip-con) <> 2
    and int(import-guia-con.ind-tip-con) <> 3
    and int(import-guia-con.ind-tip-con) <> 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Tipo de Consulta invalido (import-guia-con.ind-tip-con): " + import-guia-con.ind-tip-con + 
                                " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import),
                          input today,
                          input "Informe um tipo de consulta conforme a tabela 52 da TISS.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if import-guia-con.dat-atendim = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Data do Atendimento nao informada (import-guia-con.dat-atendim). " + 
                                " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import),
                          input today,
                          input "Informe o campo Data do Atendimento").
           
           assign lg-erro-par = yes.
         end.

    /* -------------- PRESTADOR EXECUTANTE ------------------- */
    if not can-find(preserv where preserv.cd-unidade   = import-guia-con.cd-unidade-exec  
                              and preserv.cd-prestador = import-guia-con.cd-prestador-exec)
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Prestador executante nao cadastrado." + 
                                " Unid: "  + string(import-guia-con.cd-unidade-exec) + 
                                " Prest: " + string(import-guia-con.cd-prestador-exec) + 
                                " import-guia-con.cd-prestador-exec: " + string(import-guia-con.cd-prestador-exec) + 
                                " import-guia-con.num-seq-import: "    + string(import-guia-con.num-seq-import),
                          input today,
                          input "Informe um prestador cadastrado no GPS").
           
           assign lg-erro-par = yes.
         end.

    if import-guia-con.cd-especialid-exec = 0
    or import-guia-con.cd-especialid-exec = ?
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Especialidade do prestador executante deve ser informada (import-guia-con.cd-especialid-exec). " + 
                                " Unid: "  + string(import-guia-con.cd-unidade-exec) + 
                                " Prest: " + string(import-guia-con.cd-prestador-exec) + 
                                " import-guia-con.num-seq-import: "    + string(import-guia-con.num-seq-import),
                          input today,
                          input "Informe uma especialidade medica para o prestador executante.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------------------------------- */
    IF NOT CAN-FIND(FIRST preserv
                    WHERE preserv.cd-unidade   = import-guia-con.cd-unidade-exec
                      AND preserv.cd-prestador = import-guia-con.cd-prestador-exec)
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Prestador executante nao encontrado." +
                                " Unidade(import-guia-con.cd-unidade-exec): " + string(import-guia-con.cd-unidade-exec) + 
                                " Prestador(import-guia-con.cd-prestador-exec): " + string(import-guia-con.cd-prestador-exec) + 
                                " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import),
                          input today,
                          input "Verifique se o prestador informado existe no Cadastro de Prestadores.").
           assign lg-erro-par = yes.
         END.

    run busca-vinculo-prestador(input  import-guia-con.cd-unidade-exec,
                                input  import-guia-con.cd-prestador-exec,
                                input  import-guia-con.cd-especialid-exec,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-aux,
                                output lg-erro-vinculo-aux). 

    if lg-erro-vinculo-aux
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-con",
                          input "Vinculo nao encontrado para o prestador executante e especialidade informados." + 
                                " Unid: "  + string(import-guia-con.cd-unidade-exec) + 
                                " Prest: " + string(import-guia-con.cd-prestador-exec) +  
                                " Espec: " + string(import-guia-con.cd-especialid-exec) + 
                                " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import),
                          input today,
                          input "Verifique se o prestador informado possui vinculo cadastrado na especialidade informada.").

           assign lg-erro-par = yes.
         end.
    else do:
           create tmp-prest-exec.
           assign tmp-prest-exec.in-tipo-guia = "CONS"
                  tmp-prest-exec.val-seqcial  = import-guia-con.num-seqcial-guia
                  tmp-prest-exec.cd-unidade   = import-guia-con.cd-unidade-exec
                  tmp-prest-exec.cd-prestador = import-guia-con.cd-prestador-exec
                  tmp-prest-exec.cd-espec     = import-guia-con.cd-especialid-exec
                  tmp-prest-exec.cd-vinculo   = cd-vinculo-aux.
         end.

    /* ------------------- MOVIMENTOS CONSULTA -------------------- */
    for each import-guia-movto
       where import-guia-movto.ind-tip-guia = "CONS" /* Consulta */
         and import-guia-movto.val-seq-guia = import-guia-con.num-seqcial-guia
             no-lock:

        if  import-guia-movto.ind-tip-movto-guia <> "P"
        and import-guia-movto.ind-tip-movto-guia <> "I"
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-guia-con",
                              input "Tipo do movimento informado invalido (import-guia-movto.ind-tip-movto-guia): " + import-guia-movto.ind-tip-movto-guia + 
                                    " Tp.Guia(import-guia-movto.ind-tip-guia): " + string(import-guia-movto.ind-tip-guia) + 
                                    " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                    " import-guia-con.num-seq-import: " + string(import-guia-con.num-seq-import) +  
                                    " import-guia-con.num-seqcial-guia: " + string(import-guia-con.num-seqcial-guia),
                              input today,
                              input "Informe um valor valido para o campo: P ou I").
               
               assign lg-erro-par = yes.
             end.

        run valida-dados-movimento(input-output lg-erro-par).

        run valida-glosas(input        import-guia-movto.ind-tip-guia,
                          input        import-guia-movto.val-seqcia,
                          input        import-guia-con.num-seqcial-guia,
                          input-output lg-erro-par).
    end.
    
end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-dados-gerais:

    def output parameter lg-erro-par as log init no no-undo.

    IF import-guia.aa-guia-atendimento = ?
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Ano da guia invalido (nulo)",
                          input today,
                          input "Verifique o extrator").
           assign lg-erro-par = yes.
         END.
    IF import-guia.nr-guia-atendimento = ?
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Numero da guia invalido (nulo)",
                          input today,
                          input "Verifique o extrator").
           assign lg-erro-par = yes.
         END.

    IF CAN-FIND(first guiautor 
                where guiautor.cd-unidade          = paramecp.cd-unimed
                  and guiautor.aa-guia-atendimento = import-guia.aa-guia-atendimento
                  AND guiautor.nr-guia-atendimento = import-guia.nr-guia-atendimento)
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Numeracao da guia ja utilizada. Ano: " + STRING(import-guia.aa-guia-atendimento)
                              + "Guia: " + STRING(import-guia.nr-guia-atendimento),
                          input today,
                          input "Verifique a geracao da numeracao no extrator").
           
           assign lg-erro-par = yes.
         END.

    /* ----------------------------------------------------------- */
    if  trim(import-guia.ind-tip-guia) <> "S" /* SADT */
    and trim(import-guia.ind-tip-guia) <> "I" /* Internacao */
    and trim(import-guia.ind-tip-guia) <> "P" /* Prorrogacao */
    and trim(import-guia.ind-tip-guia) <> "C" /* Consulta */
    and trim(import-guia.ind-tip-guia) <> "O" /* Odontologia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Tipo da guia informado invalido (import-guia.ind-tip-guia): " + import-guia.ind-tip-guia,
                          input today,
                          input "Informe um valor valido para o campo: S, I, P, C, O").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if  import-guia.ind-sit-guia <> "1"  /* Digitada */
    and import-guia.ind-sit-guia <> "2"  /* Autorizada */
    and import-guia.ind-sit-guia <> "3"  /* Cancelada */
    and import-guia.ind-sit-guia <> "4"  /* Processada pelo contas */
    and import-guia.ind-sit-guia <> "5"  /* Fechada */
    and import-guia.ind-sit-guia <> "6"  /* Orcamento */
    and import-guia.ind-sit-guia <> "7"  /* Faturada */
    and import-guia.ind-sit-guia <> "8"  /* Negada */
    and import-guia.ind-sit-guia <> "9"  /* Pendente Auditoria */
    and import-guia.ind-sit-guia <> "10" /* Pendente Liberacao */
    and import-guia.ind-sit-guia <> "11" /* Pendente Laudo Medico */
    and import-guia.ind-sit-guia <> "12" /* Pendente Justificativa Medica */
    and import-guia.ind-sit-guia <> "13" /* Pendente Pericia */
    and import-guia.ind-sit-guia <> "19" /* Em auditoria */
    and import-guia.ind-sit-guia <> "20" /* Em atendimento */
    and import-guia.ind-sit-guia <> "23" /* Em pericia */
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Situacao da guia informada invalido (import-guia.ind-sit-guia): " + string(import-guia.ind-sit-guia),
                          input today,
                          input "Informe um valor valido para o campo.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    if import-guia.cod-guia-operdra = ?
    or import-guia.cod-guia-operdra = ""
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Numero da guia no Unicoo nao informado (import-guia.cod-guia-operdra).",
                          input today,
                          input "Informe o campo referente ao numero da guia no Unicoo: import-guia.cod-guia-operdra").

           assign lg-erro-par = yes.
         end.

    /* ----------------------------------------------------------- */
    find tranrevi where tranrevi.cd-transacao = import-guia.cd-transacao no-lock no-error.

    if not avail tranrevi
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Transacao (import-guia.cd-transacao) " 
                              + string(import-guia.cd-transacao) 
                              + " nao cadastrada.",
                          input today,
                          input "Informe um numero de transacao cadastrado no Gestao de Planos").
           
           assign lg-erro-par = yes.
         end.

   /* ------------------------- PRESTADOR SOLICITANTE ---------------------------------------- */
   run consiste-prestador-solicitante(input-output lg-erro-par).

   /* ------------------------- CONSISTE BENEFICIARIO ------------------------------------*/
   run consiste-beneficiario(input-output lg-erro-par).

   /* ------------------- CONSISTE PRESTADOR PRINCIPAL ---------------------------------- */
   run consiste-prestador-principal(input-output lg-erro-par).

  /* ------------------------------------- CLINICA --------------------------------- */
  if import-guia.cd-clinica > 0
  then do:
         if not can-find(clinicas where clinicas.cd-clinica = import-guia.cd-clinica)
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Clinica nao cadastrada (import-guia.cd-clinica): " + string(import-guia.cd-clinica,"99999999"),
                               input today,
                               input "Informe um codigo de clinica valido.").
         
                assign lg-erro-par = yes.
              end.
         
         if not can-find(clinpres where clinpres.cd-clinica   = import-guia.cd-clinica            
                                    and clinpres.cd-unidade   = import-guia.cd-unidade-principal  
                                    and clinpres.cd-prestador = import-guia.cd-prestador-principal)
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Prestador principal nao esta vinculado a clinica informada. " +
                                     " import-guia.cd-clinica: " + string(import-guia.cd-clinica)  +
                                     " import-guia.cd-unidade-principal: " + string(import-guia.cd-unidade-principal) + 
                                     " import-guia.cd-prestador-principal: " + string(import-guia.cd-prestador-principal),
                               input today,
                               input "O prestador principal deve estar vinculado a clinica. Verifique o cadastro ac0210h").
         
                assign lg-erro-par = yes.
              end.
       end.

  /* -------------------------------- TIPO DE GUIA ----------------------------------- */
  find tip-guia where tip-guia.cd-tipo-guia = import-guia.cd-tipo-guia no-lock no-error.
  if not avail tip-guia
  then do:
         run grava-erro(input import-guia.num-seqcial-control,
                        input "import-guia",
                        input "Tipo de Guia nao cadastrado (tip-guia.cd-tipo-guia): " + string(import-guia.cd-tipo-guia),
                        input today,
                        input "Informe um tipo de guia valido.").
         
         assign lg-erro-par = yes.
       end.

  /* --------------------------- LOCAL DE AUTORIZACAO ----------------------------- */
  if import-guia.num-livre-1 > 0
  then do:
         if not can-find(locaauto where locaauto.cd-local-autorizacao = import-guia.num-livre-1)
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Local de autorizacao nao cadastrado (import-guia.num-livre-1): " + string(import-guia.num-livre-1),
                               input today,
                               input "Informe um local de autorizacao cadastrado no Gestao de Planos.").
                
                assign lg-erro-par = yes.
              end.
       end.
  else do:
         if avail tip-guia
         and tip-guia.lg-trata-local-autorizacao
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Local de autorizacao deve ser informado (import-guia.num-livre-1).",
                               input today,
                               input "O tipo de guia informado exige a informacao do local de autorizacao.").
                
                assign lg-erro-par = yes.
              end.
       end.

  /* --------------- VERIFICA SE GUIA PRINCIPAL JA FOI CRIADA --------------------- */
  if import-guia.num-seqcial-princ > 0
  then do:
         find b-import-guia where b-import-guia.num-seqcial = import-guia.num-seqcial-princ
                                  no-lock no-error.

         if not avail b-import-guia
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "Registro da guia principal nao encontrado. import-guia.num-seqcial-princ: " + string(import-guia.num-seqcial-princ),
                               input today,
                               input "A guia informada esta vinculada a uma guia principal. O registro "
                                     + "import-guia da guia principal nao foi encontrado").
                
                assign lg-erro-par = yes.
              end.
         else do:
                if b-import-guia.aa-guia-atendimento = 0
                or b-import-guia.nr-guia-atendimento = 0
                then do:
                       run grava-erro(input import-guia.num-seqcial-control,
                                      input "import-guia",
                                      input "Codigo da guia de autorizacao principal esta zerado.",
                                      input today,
                                      input "O codigo da guia principal esta igual a zero no registro import-guia "
                                            + "da guia principal").
                       
                       assign lg-erro-par = yes.
                     end.

                assign aa-guia-atend-ant-aux = b-import-guia.aa-guia-atendimento
                       nr-guia-atend-ant-aux = b-import-guia.nr-guia-atendimento.
              end.
       end.

  /* ----------------------- VALIDA CBO ----------------------------- */
  if  import-guia.cdn-cbo <> ?
  and import-guia.cdn-cbo <> 0
  then do:
         if not can-find(first dz-cbo02 where dz-cbo02.cd-cbo = import-guia.cdn-cbo) 
         then do:
                run grava-erro(input import-guia.num-seqcial-control,
                               input "import-guia",
                               input "CBO informado nao cadastrado: " + string(import-guia.cdn-cbo),
                               input today,
                               input "Informe um CBO cadastrado no Gestao de Planos.").
                
                assign lg-erro-par = yes.
              end.
       end.

  /* ------------------- DATA DE EMISSAO ----------------------------- */
  if import-guia.dat-solicit = ?
  then do:
         run grava-erro(input import-guia.num-seqcial-control,
                        input "import-guia",
                        input "Data da solicitacao nao informada.",
                        input today,
                        input "Informe a data da solicitacao.").
         
         assign lg-erro-par = yes.
       end.

end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-beneficiario:

    def input-output parameter lg-erro-par as log no-undo.

    assign cd-unidade-carteira-aux = 0
           cd-carteira-aux         = 0
           nr-carteira-aux         = 0.

    if import-guia.cd-unidade-carteira <> paramecp.cd-unimed
    then do:
           find first out-uni 
                where out-uni.cd-unidade          = import-guia.cd-unidade-carteira
                  and out-uni.cd-carteira-usuario = import-guia.cd-carteira-usuario NO-LOCK NO-ERROR.
           if not avail out-uni 
           then do:
                  create out-uni. /* cria-out-uni quando nao existir na base */                   
                  assign out-uni.cd-unidade           = import-guia.cd-unidade-carteira
                         out-uni.cd-carteira-usuario  = import-guia.cd-carteira-usuario
                         out-uni.nm-usuario           = import-guia.nom-benef-intercam
                         out-uni.lg-sexo              = import-guia.log-livre-1 /* sexo*/
                         out-uni.dt-nascimento        = import-guia.dat-livre-1 /* data de nascimento*/
                         out-uni.dt-cadastro          = today
                         out-uni.dt-atualizacao       = today
                         out-uni.cd-userid            = v_cod_usuar_corren. 
                end.

           assign cd-unidade-carteira-aux = out-uni.cd-unidade
                  cd-carteira-aux         = out-uni.cd-carteira-usuario
                  nr-carteira-aux         = 0.

           find first unicamco where unicamco.cd-unidade = out-uni.cd-unidade 
                                 and unicamco.dt-limite >= import-guia.dat-solicit
                                     no-lock no-error.
 
           if   not available unicamco
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Associacao entre as Unidades e a camara de compensacao nao existe (tabela unicamco). " + 
                                       " out-uni.cd-unidade: " + string(out-uni.cd-unidade) + 
                                       " import-guia.dat-solicit: " + string(import-guia.dat-solicit),
                                 input today,
                                 input "Tabela unicamco nao encontrada").
                  
                  assign lg-erro-par = yes.
                  return.
                end.

           find unimed where unimed.cd-unimed = out-uni.cd-unidade no-lock no-error.

           if   not available unimed
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Unidade de intercambio nao encontrada. " + 
                                       " out-uni.cd-unidade: " + string(out-uni.cd-unidade),
                                 input today,
                                 input "Unidade de intercambio nao encontrada").
                  
                  assign lg-erro-par = yes.
                  return.
                end.

           assign cd-modalidade-aux = unicamco.cd-modalidade 
                  nr-ter-adesao-aux = 0
                  cd-usuario-aux    = 0
                  cd-plano-aux      = unicamco.cd-plano
                  cd-tipo-plano-aux = unicamco.cd-tipo-plano.
 
         end.
    else do:          
           find first usuario where usuario.cd-carteira-antiga = import-guia.cd-carteira-usuario no-lock no-error.
       
           if  not avail usuario
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Beneficiario nao encontrado. Carteira informada: " + STRING(import-guia.cd-carteira-usuario),
                                 input today,
                                 input "Beneficiario nao encontrado").
       
                  assign lg-erro-par = yes.
                  return.
               end.
               
           ASSIGN cd-modalidade-aux  = usuario.cd-modalidade 
                  nr-ter-adesao-aux  = usuario.nr-ter-adesao
                  cd-usuario-aux     = usuario.cd-usuario.
           
           FOR FIRST propost FIELDS (cd-plano cd-tipo-plano)
               WHERE propost.cd-modalidade = usuario.cd-modalidade
                 AND propost.nr-ter-adesao = usuario.nr-ter-adesao NO-LOCK:
           
               ASSIGN cd-plano-aux      = propost.cd-plano 
                      cd-tipo-plano-aux = propost.cd-tipo-plano.
           END.
           
           FIND LAST car-ide 
               WHERE car-ide.cd-unimed      = paramecp.cd-unimed 
                 and car-ide.cd-modalidade  = usuario.cd-modalidade
                 and car-ide.nr-ter-adesao  = usuario.nr-ter-adesao
                 and car-ide.cd-usuario     = usuario.cd-usuario NO-LOCK NO-ERROR.
           
           IF AVAIL car-ide
           THEN ASSIGN cd-unidade-carteira-aux = car-ide.cd-unimed
                       cd-carteira-aux         = car-ide.cd-carteira-inteira
                       nr-carteira-aux         = car-ide.nr-carteira.    
         end.

     FIND FIRST ti-pl-sa 
          WHERE ti-pl-sa.cd-modalidade = cd-modalidade-aux
            AND ti-pl-sa.cd-plano      = cd-plano-aux
            AND ti-pl-sa.cd-tipo-plano = cd-tipo-plano-aux NO-LOCK NO-ERROR.
    
     ASSIGN cd-cla-hos-aux = ti-pl-sa.cd-cla-hos WHEN AVAIL ti-pl-sa.
    
     FIND FIRST clashosp WHERE clashosp.cd-cla-hos = cd-cla-hos-aux NO-LOCK NO-ERROR.
    
     ASSIGN nr-indice-aux = clashosp.nr-indice-hierarquico WHEN AVAIL clashosp.
     
     if  cd-unidade-carteira-aux = 0
     and cd-carteira-aux        = 0
     then do:
            run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Beneficiario nao encontrado. Carteira informada: "  + STRING(import-guia.cd-unidade-carteira) + STRING(import-guia.cd-carteira-usuario),
                                 input today,
                                 input "Beneficiario nao encontrado").
         
                  assign lg-erro-par = yes.
                  return.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-prestador-principal:

    def input-output parameter lg-erro-par as log no-undo.

    find preserv where preserv.cd-unidade   = import-guia.cd-unidade-principal  
                   and preserv.cd-prestador = import-guia.cd-prestador-principal
                       no-lock no-error.

    if not avail preserv
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Prestador principal nao encontrado. Unidade: "
                              + string(import-guia.cd-unidade-principal,"9999")
                              + " Prestador: "
                              + string(import-guia.cd-prestador-principal,"99999999"),
                          input today,
                          input "Informe um codigo valido para o prestador principal").

           assign lg-erro-par = yes.
         end.
    else do:
           IF NOT CAN-FIND(FIRST preserv
                           WHERE preserv.cd-unidade   = import-guia.cd-unidade-principal
                             AND preserv.cd-prestador = import-guia.cd-prestador-principal)
           THEN DO:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Prestador principal nao encontrado." +
                                       " Unidade(import-guia.cd-unidade-principal): " + string(import-guia.cd-unidade-principal) + 
                                       " Prestador(import-guia.cd-prestador-principal): " + string(import-guia.cd-prestador-principal) + 
                                       " import-guia.num-seqcial-control: " + string(import-guia.num-seqcial-control),
                                 input today,
                                 input "Verifique se o prestador informado existe no Cadastro de Prestadores.").
                  assign lg-erro-par = yes.
                END.

           run busca-vinculo-prestador(input  import-guia.cd-unidade-principal,
                                       input  import-guia.cd-prestador-principal,
                                       input  0,
                                       input  import-guia.dat-solicit,
                                       output cd-vinculo-principal-aux,
                                       output lg-erro-vinculo-aux). 
           
           if lg-erro-vinculo-aux
           then do:
                  IF cd-vinculo-principal-aux <> ?
                  THEN char-aux1 = string(cd-vinculo-principal-aux).
                  ELSE char-aux1 = "nulo".
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Vinculo nao encontrado para o prestador principal. Unidade: " + string(import-guia.cd-unidade-principal,"9999") + 
                                       " Prestador: " + string(import-guia.cd-prestador-principal,"99999999") +
                                       " Vinculo: " + char-aux1,
                                 input today,
                                 input "Verifique se o prestador informado possui vinculo cadastrado.").
           
                  assign lg-erro-par = yes.
                end.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure consiste-prestador-solicitante:

    def input-output param lg-erro-par as log no-undo.

    if import-guia.cd-especialidade = ?
    or import-guia.cd-especialidade = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Especialidade do prestador solicitante nao informada. " + 
                                " Unidade: " + string(import-guia.cd-unidade-solic) + 
                                " Prestador: " + string(import-guia.cd-prestador-solic) + 
                                " Especialidade: " + string(import-guia.cd-especialidade),
                          input today,
                          input "Informe um codigo para a especialidade do prestador solicitante").

           assign lg-erro-par = yes.
         end.

    find preserv where preserv.cd-unidade   = import-guia.cd-unidade-solic
                   and preserv.cd-prestador = int(import-guia.cd-prestador-solic)
                       no-lock no-error.
    if not avail preserv
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Prestador Solicitante informado nao cadastrado. Unidade: "
                              + string(import-guia.cd-unidade-solic,"9999")
                              + " Prestador: " 
                              + string(import-guia.cd-prestador-solic,"99999999"),
                          input today,
                          input "Informe um codigo de prestador cadastrado no Gestao de Planos.").
           assign lg-erro-par = yes.
           return.
         end.
    
    if preserv.in-tipo-pessoa = "J" /* Pessoa Juridica */
    then do:
           if import-guia.nom-prestdor-solic = ?
           or import-guia.nom-prestdor-solic = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Nome do prestador solicitante pessoa fisica nao informado. Unidade: " + string(import-guia.cd-unidade-solic,"9999") + 
                                       " Prestador: " + string(import-guia.cd-prestador-solic,"99999999"),
                                 input today,
                                 input "O prestador solicitante e pessoa juridica. Informe o nome do prestador solicitante pessoa fisica.").

                  assign lg-erro-par = yes.
                end.

           if import-guia.cod-cons-profis = ?
           or import-guia.cod-cons-profis = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Conselho do prestador solicitante pessoa fisica nao informado. Unidade: " + string(import-guia.cd-unidade-solic,"9999") + 
                                       " Prestador: " + string(import-guia.cd-prestador-solic,"99999999"),
                                 input today,
                                 input "O prestador solicitante e pessoa juridica. Informe o conselho profissional do prestador solicitante pessoa fisica.").

                  assign lg-erro-par = yes.
                end.
           else do:
                  if not can-find(conpres where conpres.cd-conselho = trim(import-guia.cod-cons-profis))
                  then do:
                         IF import-guia.cod-cons-profis <> ?
                         THEN char-aux1 = string(import-guia.cod-cons-profis).
                         ELSE char-aux1 = "nulo".
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia",
                                        input "Conselho do prestador solicitante pessoa fisica nao cadastrado.",
                                        input today,
                                        input "Unidade: " + string(import-guia.cd-unidade-solic,"9999") + 
                                              " Prestador: " + string(import-guia.cd-prestador-solic,"99999999") + 
                                              "  Conselho(import-guia.cod-cons-profis): " + char-aux1).

                         assign lg-erro-par = yes.
                       end.
                end.

           if import-guia.ind-nume-cons = ?
           or import-guia.ind-nume-cons = ""
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia",
                                 input "Numero do registro do prestador solicitante pessoa fisica nao informado. Unidade: " + string(import-guia.cd-unidade-solic,"9999") + 
                                       " Prestador: " + string(import-guia.cd-prestador-solic,"99999999"),
                                 input today,
                                 input "O prestador solicitante e pessoa juridica. Informe o numero do registro doprestador solicitante pessoa fisica.").

                  assign lg-erro-par = yes.
                end.
         end.

    IF NOT CAN-FIND(FIRST preserv
                    WHERE preserv.cd-unidade   = import-guia.cd-unidade-solic
                      AND preserv.cd-prestador = int(import-guia.cd-prestador-solic))
    THEN DO:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Prestador solicitante nao encontrado." +
                                " Unidade(import-guia.cd-unidade-solic): " + string(import-guia.cd-unidade-solic) + 
                                " Prestador(import-guia.cd-prestador-solic): " + string(import-guia.cd-prestador-solic) + 
                                " import-guia.num-seqcial-control: " + string(import-guia.num-seqcial-control),
                          input today,
                          input "Verifique se o prestador informado existe no Cadastro de Prestadores.").
           assign lg-erro-par = yes.
         END.

    run busca-vinculo-prestador(input  import-guia.cd-unidade-solic,
                                input  int(import-guia.cd-prestador-solic),
                                input  import-guia.cd-especialidade,
                                input  import-guia.dat-solicit,
                                output cd-vinculo-solic-aux,
                                output lg-erro-vinculo-aux).

    if lg-erro-vinculo-aux
    then do:
           IF cd-vinculo-solic-aux <> ?
           THEN char-aux1 = string(cd-vinculo-solic-aux).
           ELSE char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia",
                          input "Vinculo nao encontrado para o prestador solicitante e especialidade.",
                          input today,
                          input "Unidade: " + string(import-guia.cd-unidade-solic,"9999") + 
                                " Prestador: " + string(import-guia.cd-prestador-solic,"99999999") + 
                                " Especialid: " + STRING(import-guia.cd-especialidade) +
                                " Dt.Solic: "   + STRING(import-guia.dat-solicit) +
                                " Vinculo: " + char-aux1).
           
           assign lg-erro-par = yes.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure busca-vinculo-prestador:

    def input  param cd-unidade-par   as int  no-undo.
    def input  param cd-prestador-par as int  no-undo.
    def input  param cd-espec-par     as int  no-undo.
    def input  param dt-base-par      as date no-undo.
    def output param cd-vinculo-par   as int  no-undo.
    def output param lg-erro-par      as log  no-undo.

    assign lg-erro-par = no.

    if cd-espec-par > 0
    then do:
           find first previesp where previesp.cd-especialid       = cd-espec-par
                                 and previesp.cd-unidade          = cd-unidade-par
                                 and previesp.cd-prestador        = cd-prestador-par
                                 /*and previesp.dt-inicio-validade <= dt-base-par
                                 and previesp.dt-fim-validade    >= dt-base-par
                                 retirada validacao de data para permitir importação de movimentação gerada no Unicoo após descredenciamento do prestador*/
                                     no-lock no-error.
           
           if avail previesp
           then assign cd-vinculo-par = previesp.cd-vinculo.
           else DO:
                  for each previesp where previesp.cd-unidade   = cd-unidade-par  
                                      and previesp.cd-prestador = cd-prestador-par
                                      and previesp.lg-principal
                                          no-lock:
                  
                      /*if  previesp.dt-inicio-validade <= dt-base-par
                      and previesp.dt-fim-validade    >= dt-base-par 
                      then*/ leave.
                  end.

                  if avail previesp
                  then assign cd-vinculo-par = previesp.cd-vinculo.
                  else DO:
                          for each previesp where previesp.cd-unidade   = cd-unidade-par  
                                              and previesp.cd-prestador = cd-prestador-par
                                                  no-lock:
                          
                              /*if  previesp.dt-inicio-validade <= dt-base-par
                              and previesp.dt-fim-validade    >= dt-base-par 
                              then*/ leave.
                          end.

                          if avail previesp
                          then assign cd-vinculo-par = previesp.cd-vinculo.
                          else assign lg-erro-par = yes.
                       END.
                END.
         end.
    else do:
           for each previesp where previesp.cd-unidade   = cd-unidade-par  
                               and previesp.cd-prestador = cd-prestador-par
                               and previesp.lg-considera-qt-vinculo
                                   no-lock:

               /*if  previesp.dt-inicio-validade <= dt-base-par
               and previesp.dt-fim-validade    >= dt-base-par 
               then*/ leave.
           end.

           if avail previesp
           then assign cd-vinculo-par = previesp.cd-vinculo.
           else do:
                  for each previesp where previesp.cd-unidade   = cd-unidade-par  
                                      and previesp.cd-prestador = cd-prestador-par
                                      and not previesp.lg-considera-qt-vinculo
                                          no-lock:
                  
                      /*if  previesp.dt-inicio-validade <= dt-base-par
                      and previesp.dt-fim-validade    >= dt-base-par 
                      then*/ leave.
                  end.

                  if avail previesp
                  then assign cd-vinculo-par = previesp.cd-vinculo.
                  else assign lg-erro-par = yes.
                end.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-glosas:

    def input        param ind-tip-guia-par  as char format "x(4)" no-undo.
    def input        param val-seqcial-movto as int                no-undo.
    def input        param val-seq-guia      as int                no-undo.
    def input-output param lg-erro-par       as log                no-undo.

    for each import-movto-glosa
       where import-movto-glosa.in-modulo         = "AT"
         and import-movto-glosa.ind-tip-guia      = ind-tip-guia-par 
         and import-movto-glosa.val-seqcial-movto = val-seqcial-movto
         and import-movto-glosa.val-seq-guia      = val-seq-guia     
             no-lock:

        if not can-find(claserro where claserro.cd-classe-erro = import-movto-glosa.cd-classe-erro)
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-movto-glosa",
                              input "Classe de erro nao cadastrada: "                       + string(import-movto-glosa.cd-classe-erro) + 
                                    " Tp.Guia(import-movto-glosa.ind-tip-guia): "           + string(import-movto-glosa.ind-tip-guia) + 
                                    " Nro.Seq.Mvto(import-movto-glosa.val-seqcial-movto): " + string(import-movto-glosa.val-seqcial-movto) +
                                    " Nro.Seq.Guia(import-movto-glosa.val-seq-guia)"        + string(import-movto-glosa.val-seq-guia),     
                              input today,
                              input "Informe um codigo de classe de erro valido.").

               assign lg-erro-par = yes.
             end.

        if not can-find(first codiglos 
                        where codiglos.cd-classe-erro = import-movto-glosa.cd-classe-erro
                          and codiglos.cd-cod-glo     = import-movto-glosa.cd-cod-glo)
        then do:
               run grava-erro(input import-guia.num-seqcial-control,
                              input "import-movto-glosa",
                              input "Glosa nao cadastrada: " + string(import-movto-glosa.cd-cod-glo) + 
                                    " Tp.Guia(import-movto-glosa.ind-tip-guia): "           + string(import-movto-glosa.ind-tip-guia) + 
                                    " Nro.Seq.Mvto(import-movto-glosa.val-seqcial-movto): " + string(import-movto-glosa.val-seqcial-movto) +
                                    " Nro.Seq.Guia(import-movto-glosa.val-seq-guia)"        + string(import-movto-glosa.val-seq-guia),
                              input today,
                              input "Informe um codigo de glosa valido.").
               
               assign lg-erro-par = yes.
             end.
    end. /* each import-movto-glosa */

end procedure.

/* ----------------------------------------------------------------- */
procedure valida-dados-movimento:

    def input-output param lg-erro-par as log no-undo.

    /* ------------------- VALIDA MODULO DE COBERTURA ------------------------- */
    if import-guia-movto.cd-modulo = ?
    or import-guia-movto.cd-modulo = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Modulo de cobertura nao informado. " + 
                                " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                          input today,
                          input "Informe um modulo de cobertura para o movimento.").
           
           assign lg-erro-par = yes.
         end.

    if not can-find(mod-cob where mod-cob.cd-modulo = import-guia-movto.cd-modulo)
    then do:
           IF import-guia-movto.cd-modulo <> ?
           THEN char-aux1 = string(import-guia-movto.cd-modulo).
           ELSE char-aux1 = "nulo".
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Modulo de cobertura nao cadastrado. " + 
                                " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                " Modulo: " + char-aux1,
                          input today,
                          input "Informe um modulo de cobertura cadastrado no Gestao de Planos.").
           
           assign lg-erro-par = yes.
         end.

    /* ----------------------------------- VALIDA MOVIMENTO --------------------------- */
    if import-guia-movto.log-livre-1 = NO /* true: pacote; false: nao eh pacote */
    then do:
           if import-guia-movto.ind-tip-movto-guia = "P"
           then do:
                  assign cd-esp-amb-aux        = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),1,2))
                         cd-grupo-proc-amb-aux = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),3,2))
                         cd-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),5,3))
                         dv-procedimento-aux   = int(substr(string(int(import-guia-movto.cod-movto-guia),"99999999"),8,1)).
           
                  if not can-find(ambproce where ambproce.cd-esp-amb        = cd-esp-amb-aux
                                             and ambproce.cd-grupo-proc-amb = cd-grupo-proc-amb-aux
                                             and ambproce.cd-procedimento   = cd-procedimento-aux
                                             and ambproce.dv-procedimento   = dv-procedimento-aux)
                  then do:
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia-movto",
                                        input "Procedimento nao cadastrado: " + import-guia-movto.cod-movto-guia + 
                                              " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                              " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                                        input today,
                                        input "Informe um codigo de procedimento valido.").
           
                         assign lg-erro-par = yes.
                       end.

                  if not can-find(first pl-mo-am where pl-mo-am.cd-modalidade          = cd-modalidade-aux
                                                   and pl-mo-am.cd-plano               = cd-plano-aux
                                                   and pl-mo-am.cd-tipo-plano          = cd-tipo-plano-aux
                                                   and pl-mo-am.cd-amb                 = int(import-guia-movto.cod-movto-guia)
                                                   and pl-mo-am.cd-modulo              = import-guia-movto.cd-modulo)
                  then do:
                         if not can-find(first plamodpr where plamodpr.cd-modalidade          = cd-modalidade-aux
                                                          and plamodpr.cd-plano               = cd-plano-aux
                                                          and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                                                          and plamodpr.in-procedimento-insumo = "P"
                                                          and plamodpr.cd-modulo              = import-guia-movto.cd-modulo)
                         then do:
                                IF cd-modalidade-aux <> ?
                                THEN char-aux1 = string(cd-modalidade-aux).
                                ELSE char-aux1 = "nulo".
                                IF cd-plano-aux <> ?
                                THEN char-aux2 = string(cd-plano-aux).
                                ELSE char-aux2 = "nulo".
                                IF cd-tipo-plano-aux <> ?
                                THEN char-aux3 = string(cd-tipo-plano-aux).
                                ELSE char-aux3 = "nulo".
                                IF import-guia-movto.cd-modulo <> ?
                                THEN char-aux4 = string(import-guia-movto.cd-modulo).
                                ELSE char-aux4 = "nulo".
                                run grava-erro(input import-guia.num-seqcial-control,
                                               input "import-guia-movto",
                                               input "Tabela padrao de moedas e carencias (pl-mo-am ou plamodpr) nao encontrada para a estrutura neste modulo. " +
                                                     " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                                     " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                                     " Mod.: "     + char-aux1 + 
                                                     " Plano: "    + char-aux2      + 
                                                     " Tp.Plano: " + char-aux3 +
                                                     " Modulo: "   + char-aux4,
                                               input today,
                                               input "Verifique PL-MO-AM e PLAMODPR").
                                
                                assign lg-erro-par = yes.
                              end.
                       end.
                end.
           else do:
                  assign cd-tipo-insumo-aux = 0
                         /*cd-tipo-insumo-aux = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),1,2))*/
                         cd-insumo-aux      = int(substr(string(dec(import-guia-movto.cod-movto-guia),"9999999999"),3,8)).
           
                  find first insumos where insumos.cd-insumo = int(import-guia-movto.cod-movto-guia) no-lock no-error.
                  if not avail insumos
                  then do:
                         run grava-erro(input import-guia.num-seqcial-control,
                                        input "import-guia-movto",
                                        input "Insumo nao cadastrado: " + import-guia-movto.cod-movto-guia + 
                                              " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                              " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                                        input today,
                                        input "Informe um codigo de insumo valido.").
           
                         assign lg-erro-par = yes.
                       end.
                  else do:
                         ASSIGN cd-tipo-insumo-aux = insumos.cd-tipo-insumo.

                         if import-guia-movto.ind-tip-guia = "OPME"
                         and not insumos.lg-opme
                         then do:
                                run grava-erro(input import-guia.num-seqcial-control,
                                               input "import-guia-movto",
                                               input "Insumo nao e do tipo OPME: " + import-guia-movto.cod-movto-guia + 
                                                     " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                                     " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                                               input today,
                                               input "Para anexos OPME, os insumos informados deve ser do tipo OPME.").
           
                                assign lg-erro-par = yes.
                              end.
                       end.

                  if not can-find(partinsu where partinsu.cd-modalidade  = cd-modalidade-aux    
                                             and partinsu.cd-plano       = cd-plano-aux         
                                             and partinsu.cd-tipo-plano  = cd-tipo-plano-aux    
                                             and partinsu.cd-modulo      = import-guia-movto.cd-modulo
                                             AND partinsu.cd-tipo-insumo = cd-tipo-insumo-aux
                                             and partinsu.cd-insumo      = int(import-guia-movto.cod-movto-guia))
                  then do:
                         if not can-find(partinsu where partinsu.cd-modalidade  = cd-modalidade-aux    
                                                    and partinsu.cd-plano       = cd-plano-aux         
                                                    and partinsu.cd-tipo-plano  = cd-tipo-plano-aux   
                                                    and partinsu.cd-modulo      = import-guia-movto.cd-modulo
                                                    AND partinsu.cd-tipo-insumo = cd-tipo-insumo-aux
                                                    and partinsu.cd-insumo      = 0)
                  then do:
                         if not can-find(first plamodpr where plamodpr.cd-modalidade          = cd-modalidade-aux
                                                          and plamodpr.cd-plano               = cd-plano-aux
                                                          and plamodpr.cd-tipo-plano          = cd-tipo-plano-aux
                                                          and plamodpr.in-procedimento-insumo = "I"
                                                          and plamodpr.cd-modulo              = import-guia-movto.cd-modulo)
                         then do:
                                IF cd-modalidade-aux <> ?
                                THEN char-aux1 = string(cd-modalidade-aux).
                                else char-aux1 = "nulo".
                                IF cd-plano-aux <> ?
                                THEN char-aux2 = string(cd-plano-aux).
                                ELSE char-aux2 = "nulo".
                                IF cd-tipo-plano-aux <> ?
                                THEN char-aux3 = string(cd-tipo-plano-aux).
                                ELSE char-aux3 = "nulo".
                                IF import-guia-movto.cd-modulo <> ?
                                THEN char-aux4 = string(import-guia-movto.cd-modulo).
                                ELSE char-aux4 = "nulo".
                                IF cd-tipo-insumo-aux <> ?
                                THEN char-aux5 = STRING(cd-tipo-insumo-aux).
                                ELSE char-aux5 = "nulo".
                                IF import-guia-movto.cod-movto-guia <> ?
                                THEN char-aux6 = STRING(import-guia-movto.cod-movto-guia).
                                ELSE char-aux6 = "nulo".
                                run grava-erro(input import-guia.num-seqcial-control,
                                               input "import-guia-movto",
                                               input "Tabela padrao de moedas e carencias (partinsu ou plamodpr) nao encontrada para a estrutura neste modulo." +
                                                     " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                                     " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) + 
                                                     " Mod.: "     + char-aux1 + 
                                                     " Plano: "    + char-aux2      + 
                                                     " Tp.Plano: " + char-aux3 +
                                                     " Modulo: "   + char-aux4 +
                                                     " Tp.Insu: "  + char-aux5 +
                                                     " Insumo: "   + char-aux6
                                                     ,
                                               input today,
                                               input "Verifique PARTINSU e PLAMODPR").
                       
                                assign lg-erro-par = yes.
                              end.
                       end.
                end.
    end.
         END.

    /* -------------- QUANTIDADE SOLICITADA ---------------------------- */
    if import-guia-movto.qtd-solicitad = ?
    or import-guia-movto.qtd-solicitad = 0
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Quantidade solicitada do movimento nao informada. " +
                                " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                          input today,
                          input "Informe a quantidade solicitada do movimento").
           
           assign lg-erro-par = yes.
         end.

    /* ------------------------------------------------------------- */
    if import-guia-movto.num-livre-2 > 0 /* Classe de erro */
    then do:
           if not can-find(claserro where claserro.cd-classe-erro = import-guia-movto.num-livre-2)
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-movto",
                                 input "Classe de erro nao cadastrada (import-guia-movto.num-livre-2): " + string(import-guia-movto.num-livre-2) +
                                       " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                       " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                                 input today,
                                 input "Informe um codigo de classe de erro valido.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    /* ------------------------------------------------------------- */
    if import-guia-movto.num-livre-1 > 0 /* Codigo da glosa */
    then do:
           if not can-find(first codiglos 
                           where codiglos.cd-classe-erro = import-guia-movto.num-livre-2
                             and codiglos.cd-cod-glo     = import-guia-movto.num-livre-1)
           then do:
                  run grava-erro(input import-guia.num-seqcial-control,
                                 input "import-guia-movto",
                                 input "Glosa nao cadastrada: " + string(import-guia-movto.num-livre-1) +
                                       " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                       " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia) +
                                       " Classe erro(import-guia-movto.num-livre-2): " + string(import-guia-movto.num-livre-2) + 
                                       " Glosa(import-guia-movto.num-livre-1): " + string(import-guia-movto.num-livre-1),
                                 input today,
                                 input "Informe um codigo de glosa vinculado a classe de erro informada.").
           
                  assign lg-erro-par = yes.
                end.
         end.

    /* ------------- VALIDACAO GLOSA COBRANCA ---------------------
         import-guia-movto.num-livre-3:
         0  COBRANCA CONFORME CONTRATO
         1  COBRANCA POR CUSTO OPERACIONAL
         2  COBRANCA POR USO INDEVIDO
         3  DESCONSIDERAR COBRANCA
         4  COBERTURA POR INTERCAMBIO
         5  SUSPENSO POR VALIDACAO POSTERIOR
         6  COBRAR SOMENTE PARTICIPACAO
         7  DESCONSIDERAR COBRANCA PARTICIPACAO
         8  PARTICIPACAO - INTERCAMBIO
         99 COBRANCA CONFORME MOVIMENTO
    */
    if  import-guia-movto.num-livre-3 <> 0
    and import-guia-movto.num-livre-3 <> 1
    and import-guia-movto.num-livre-3 <> 3
    and import-guia-movto.num-livre-3 <> 4
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Validacao da glosa para cobranca invalida(import-guia-movto.num-livre-3 ): " + string(import-guia-movto.num-livre-3) +
                                " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                          input today,
                          input "Informe 0, 1, 3, ou 4.").
           
           assign lg-erro-par = yes.
         end.

    /* ------------- VALIDACAO GLOSA PAGAMENTO ---------------------
         import-guia-movto.num-livre-4
         0  PAGAMENTO CONFORME CONTRATO
         1  DESCONSIDERAR PAGAMENTO
    */
    if  import-guia-movto.num-livre-4 <> 0
    and import-guia-movto.num-livre-4 <> 1
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Validacao da glosa para pagamento invalida (import-guia-movto.num-livre-4): "    + string(import-guia-movto.num-livre-4) +
                                " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                          input today,
                          input "Informe 0 ou 1").

           assign lg-erro-par = yes.
         end.

    /* ------------- VALIDACAO GLOSA ------------------------------- */
    if  import-guia-movto.cd-validacao <> 0 
    and import-guia-movto.cd-validacao <> 1
    and import-guia-movto.cd-validacao <> 3
    then do:
           run grava-erro(input import-guia.num-seqcial-control,
                          input "import-guia-movto",
                          input "Indicador de validacao da glosa invalido(import-guia-movto.cd-validacao): " + string(import-guia-movto.cd-validacao) +
                                " Tp.Guia(import-guia-movto.ind-tip-guia): "      + string(import-guia-movto.ind-tip-guia) + 
                                " Nro.Seq.Guia(import-guia-movto.val-seq-guia): " + string(import-guia-movto.val-seq-guia),
                          input today,
                          input "Informe 0, 1 ou 3").
           
           assign lg-erro-par = yes.
         end.

end procedure.

/* ----------------------------------------------------------------- */
procedure atualiza-import-guia:

    def input parameter ind-status-par          as char no-undo.
    def input parameter cd-unidade-par          as int  no-undo.
    def input parameter aa-guia-atendimento-par as int  no-undo.
    def input parameter nr-guia-atendimento-par as int  no-undo.

    def buffer b-import-guia for import-guia.

    find b-import-guia where recid(b-import-guia) = recid(import-guia)
                             exclusive-lock no-error.

    if avail b-import-guia
    then do:
           assign /*b-import-guia.cd-unimed           = cd-unidade-par         
                  b-import-guia.aa-guia-atendimento = aa-guia-atendimento-par
                  b-import-guia.nr-guia-atendimento = nr-guia-atendimento-par*/
                  b-import-guia.ind-sit-import      = ind-status-par.
         end.

    find control-migrac where control-migrac.num-seqcial = import-guia.num-seqcial-control
                              exclusive-lock no-error.

    if avail control-migrac
    then assign control-migrac.ind-sit-import   = ind-status-par
                control-migrac.dat-integr       = today
                control-migrac.dt-processamento = today.

    validate b-import-guia.
    release b-import-guia.

    validate control-migrac.
    release control-migrac.

end procedure.

/* ----------------------------------------------------------------- */
procedure gera-rel-erro:
    
    {hdp/hdmonarq.i &page-size = 64}

    view frame f-cabecalho.
    view frame f-rodape.

    for each tmp-erro no-lock:
        disp tmp-erro.num-seqcial-control
             tmp-erro.nom-tab-orig-erro  
             tmp-erro.des-erro           
             with frame f-rel.
        down with frame f-rel.
    end.

    {hdp/hdclosed.i}
    hide message no-pause.

end procedure.


procedure filtra-paproins:
    define input  parameter cd-mod-par      like moviproc.cd-modalidade        no-undo.
    define input  parameter nr-ter-par      like moviproc.nr-ter-adesao        no-undo.
    define input  parameter cd-uni-cart-par like moviproc.cd-unidade-carteira  no-undo.
    define input  parameter dt-realiza-par  like moviproc.dt-realiza           no-undo.
    define input  parameter cd-pacote-par   like moviproc.cd-pacote            no-undo.
    define input  parameter cd-uni-pres-par like moviproc.cd-unidade-prestador no-undo.
    define input  parameter cd-prest-par    like moviproc.cd-prestador         no-undo.
    

    if paramecp.cd-unimed = cd-uni-cart-par
    then do:
            find first propost where propost.cd-modalidade = cd-mod-par
                                 and propost.nr-ter-adesao = nr-ter-par
                               no-lock no-error.

            if avail propost
            then do:
                    assign cd-modalidade-prop-aux = propost.cd-modalidade
                           cd-plano-prop-aux      = propost.cd-plano
                           cd-tipo-plano-prop-aux = propost.cd-tipo-plano.
                 end.
         end.
    else do:
           find first unicamco where unicamco.cd-unidade = cd-uni-cart-par
                                 and unicamco.dt-limite >= dt-realiza-par
                                 no-lock no-error.
           if avail unicamco
           then do:
                  assign cd-modalidade-prop-aux = unicamco.cd-modalidade
                         cd-plano-prop-aux      = unicamco.cd-plano
                         cd-tipo-plano-prop-aux = unicamco.cd-tipo-plano.
                end.
         end.

    find first paproins where paproins.cd-pacote = cd-pacote-par
                    and paproins.cd-unidade      = cd-uni-pres-par
                    and paproins.cd-prestador  	 = cd-prest-par
                    and paproins.cd-modalidade 	 = cd-modalidade-prop-aux
                    and paproins.cd-plano      	 = cd-plano-prop-aux
                    and paproins.cd-tipo-plano 	 = cd-tipo-plano-prop-aux
                    and paproins.dt-inicio-vigencia <= dt-realiza-par 
                    and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par  
                                                    no-lock no-error.
    if not avail paproins
    then find first paproins where paproins.cd-pacote     = cd-pacote-par
                               and paproins.cd-unidade    = cd-uni-pres-par
                               and paproins.cd-prestador  = cd-prest-par
                               and paproins.cd-modalidade = cd-modalidade-prop-aux
                               and paproins.cd-plano      = cd-plano-prop-aux
                               and paproins.cd-tipo-plano = 0
                               and paproins.dt-inicio-vigencia <= dt-realiza-par 
                               and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par  
                                                         no-lock no-error.
    if not  avail paproins 
    then find first paproins where paproins.cd-pacote     = cd-pacote-par
                               and paproins.cd-unidade    = cd-uni-pres-par
                               and paproins.cd-prestador  = cd-prest-par
                               and paproins.cd-modalidade = cd-modalidade-prop-aux
                               and paproins.cd-plano      = 0
                               and paproins.cd-tipo-plano = 0
                               and paproins.dt-inicio-vigencia <= dt-realiza-par 
                               and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par  
                                                         no-lock no-error.
    if not avail paproins
    then find first paproins where paproins.cd-pacote     = cd-pacote-par
                               and paproins.cd-unidade    = cd-uni-pres-par
                               and paproins.cd-prestador  = cd-prest-par
                               and paproins.cd-modalidade = 0
                               and paproins.cd-plano      = 0
                               and paproins.cd-tipo-plano = 0
                               and paproins.dt-inicio-vigencia <= dt-realiza-par 
                               and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par 
                                                         no-lock no-error.
    if not  avail paproins 
    then find first paproins where paproins.cd-pacote     = cd-pacote-par
                               and paproins.cd-unidade    = cd-uni-pres-par
                               and paproins.cd-prestador  = cd-prest-par
                               and paproins.cd-modalidade = cd-modalidade-prop-aux
                               and paproins.cd-plano      = 0
                               and paproins.cd-tipo-plano = 0
                               and paproins.dt-inicio-vigencia <= dt-realiza-par 
                               and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par 
                                                         no-lock no-error.

     if not  avail paproins                                                                                     
     then find first paproins where paproins.cd-pacote     = cd-pacote-par                                      
                                and paproins.cd-unidade    = cd-uni-pres-par                                    
                                and paproins.cd-prestador  = 0                                                  
                                and paproins.cd-modalidade = 0                                                  
                                and paproins.cd-plano      = 0                                                  
                                and paproins.cd-tipo-plano = 0                                                  
                                and paproins.dt-inicio-vigencia <= dt-realiza-par                               
                                and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par  /* bueno*/             
                                                         no-lock no-error.    

    if not avail paproins
    then find first paproins where paproins.cd-pacote     = cd-pacote-par
                               and paproins.cd-unidade    = 0
                               and paproins.cd-prestador  = 0
                               and paproins.cd-modalidade = 0
                               and paproins.cd-plano      = 0
                               and paproins.cd-tipo-plano = 0
                               and paproins.dt-inicio-vigencia <= dt-realiza-par 
                               and paproins.dt-limite /* dt-fim-vigencia*/     >= dt-realiza-par 
                                                         no-lock no-error.
    if avail paproins
    then assign r-paproins = rowid(paproins).
    else assign r-paproins = ?.
end procedure.

PROCEDURE escrever-log:
    DEF INPUT PARAM ds-par AS CHAR NO-UNDO.
END PROCEDURE.

