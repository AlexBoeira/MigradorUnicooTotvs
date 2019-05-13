/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CG0310Z1 2.00.00.033 } /*** 010031 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i CG0310Z1 MCG}
&ENDIF

/******************************************************************************
*      Programa .....: CG0310Z1.p                                              *
*      Data .........: 02 de abril de 2015                                    *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Ja¡ne Marin                                            *
*      Objetivo .....: Importacao de Documentos                               *
******************************************************************************/

def input param in-batch-online-par          AS CHAR NO-UNDO.
DEF INPUT PARAM in-status-monitorar-par      AS CHAR NO-UNDO.

DEF VAR ix-geral-aux AS INT NO-UNDO.

DEF VAR ds-msg-aux AS CHAR NO-UNDO.

hide all no-pause.
{hdp/hdvarregua.i}
{hdp/hdregarquexe.i} 
{hdp/hdregarquexe.f} 
{hdp/hdvarrel.i}

{hdp/hdsistem.i}

assign nm-cab-usuario = "Importacao dos documentos" 
       nm-prog        = "CG0310Z1"
       c-versao       = "1.02.00.019".
{hdp/hdlog.i}

{rcp/rcapi020.i}
{rtp/rtapi022.i "new shared" } /* ----------------- CARTEIRA DO BENEFICIARIO --- */
{rtp/rtapi023.i "new shared" } /* ------------------ PRESTADOR ESPECIALIDADE --- */
{rtp/rtapi024.i "new shared" } /* ------------------------ PRESTADOR VINCULO --- */


def var lg-prestador-unico-aux       like tranrevi.lg-prestador-unico                  no-undo.
def var cd-modalidade-aux            like modalid.cd-modalidade                        no-undo.
def var nr-ter-adesao-aux            like ter-ade.nr-ter-adesao                        no-undo.
def var cd-usuario-aux               like usuario.cd-usuario                           no-undo.
def var cd-plano-aux                 like propost.cd-plano                             no-undo.
def var cd-tipo-plano-aux            like propost.cd-tipo-plano                        no-undo.
def var in-acao-tran-guia-aux        like tranrevi.in-acao-tran-guia                   no-undo.
def var lg-estorno-aux               like tranrevi.lg-estorno                          no-undo.
def var lg-altera-clahos-aux         like tranrevi.lg-altera-clahos                    no-undo.
def var lg-dados-internacao-aux      like tranrevi.lg-dados-internacao                 no-undo.
def var lg-pede-doc-original-aux     like tranrevi.lg-pede-doc-original                no-undo.
def var in-tipo-sequencia-aux        like tranrevi.in-tipo-sequencia                   no-undo.
def var lg-erro-hora-aux             as log                                            no-undo.
def var nr-hora-aux                  as int                                            no-undo.
def var nr-minutos-aux               as int                                            no-undo.
def var ds-cabecalho                 as char format "x(30)"                            no-undo.
def var ds-rodape                    as char format "x(80)"  init ""                   no-undo.
def var qtd-reg-rest                 as int                                            no-undo.
def var cont-aux                     as int                                            no-undo.
def var lg-relat-erro                as log                                            no-undo.
def var lg-relat-erro-aux            as log                                            no-undo.
def var lg-imp-erro                  as log                                            no-undo.
def var lg-fecha-guia-assoc-aux      like tranrevi.lg-fecha-guias-associadas           no-undo.
def var lg-controle-fatura-aux       like tranrevi.lg-controle-fatura                  no-undo.
def var dt-inicio-per-aux            like perimovi.dt-inicio-per                       no-undo.
def var dt-fim-per-aux               like perimovi.dt-fim-per                          no-undo.   
def var lg-possui-guia-aux           as log                                            no-undo.
def var nr-serie-doc-orig-aux        as char                                           no-undo.
def var nr-doc-orig-aux              like guiautor.nr-guia-atendimento                 no-undo.  
def var cd-cla-hos-aux               like ti-pl-sa.cd-cla-hos                          no-undo.
def var nr-indice-aux                like clashosp.nr-indice-hierarquico               no-undo.
def var cd-unidade-carteira-ant-aux  like import-docto-revis-ctas.cd-unidade-carteira  no-undo.
def var cd-carteira-usuario-ant-aux  like import-docto-revis-ctas.cd-carteira-usuario  no-undo.
def var nr-via-carteira-ant-aux      like import-docto-revis-ctas.nr-via-carteira      no-undo.
def var nr-processo-hdp              like import-movto-proced.nr-processo              no-undo.
def var nr-seq-digitacao-hdp         like import-movto-proced.nr-seq-digitacao         no-undo.
def var ds-compl-aux                 as char                                           no-undo.             
def var ds-chave-aux                 as char                                           no-undo.             
def var lg-calc-tx-int-aux           as log                                            no-undo.
def var lg-urgencia-aux              as log                                            no-undo.
def var lg-urgencia-cob-aux          as log                                            no-undo.
def var nro-seq-aux                  as int                                            no-undo.
def var lg-arquivo-aux               as log                                            no-undo.

DEF NEW SHARED TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-seq            AS INT
    FIELD nr-seq-contr      LIKE erro-process-import.num-seqcial-control 
    FIELD nom-tab-orig-erro AS CHAR
    FIELD des-erro          AS CHAR
    INDEX nr-seq       
          nr-seq-contr.

DEF NEW SHARED TEMP-TABLE tt-import-docto-revis-ctas NO-UNDO
    FIELD rowid-import-docto-revis-ctas AS ROWID
    INDEX id rowid-import-docto-revis-ctas.

def temp-table import-movto-glosa like movrcglo.
     
def buffer b-preserv                 for preserv.    
def buffer c-docrecon                for docrecon.
def buffer b-tt-erro                 for tt-erro.
def buffer b-import-docto-revis-ctas for import-docto-revis-ctas.

disable triggers for load of docrecon.
disable triggers for load of moviproc.
disable triggers for load of mov-insu.

/*DEF VAR h-handle-aux AS HANDLE NO-UNDO.
RUN cgp/cg0311z.p PERSISTENT SET h-handle-aux.
*/

DEF VAR h-cg0311z-aux AS HANDLE NO-UNDO.

{hdp/hdrunpersis.iv "new"}
{hdp/hdrunpersis.i "cgp/cg0311z" "h-cg0311z-aux"}

/*----------------------------------------------------------------------------*/
find first paramecp no-lock no-error.
if   available paramecp
then do:
       find unimed where unimed.cd-unimed = paramecp.cd-unimed
            no-lock no-error.
       if   available unimed
       then assign ds-cabecalho = unimed.nm-unimed-reduz.
     end.
else do:
       message "Parametros gerais do sistema nao cadastrados."
               view-as alert-box title " Atencao !!! ".
       return.
     end.

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
       
       form tt-erro.nr-seq-contr                      column-label "Nro.Seq.Controle"         
            tt-erro.nom-tab-orig-erro  format "x(30)" column-label "Tab.Origem Erro"
            tt-erro.des-erro           format "x(80)" column-label "Descri‡Æo Erro"           
            with width 132 down no-box attr-space frame f-rel stream-io. 
     END.

/* --------------------------------------------------------------------------*/
{hdp/hdvararq.i "c:/temp" "CG0310Z1" "ERR"}
 
assign ds-rodape  = " " + nm-prog + " - " + c-versao
       ds-rodape  = FILL("-", 132 - LENGTH(ds-rodape)) + ds-rodape.       

/* ----------------------- INICIALIZACAO ------------------------------------ */ 
{hdp/hdtitrel.i}

IF in-batch-online-par = "BATCH"
THEN DO:
       run importa-dados.
     END.
ELSE DO:
       repeat on endkey undo,retry on error undo, retry:
       
           {hdp/hdbotarquexe.i}
       
           if c-opcao = "Arquivo"
           then do:
                  assign lg-arquivo-aux  = no.
       
                  {hdp/hdpedarq.i}
       
                  assign lg-arquivo-aux  = yes.
                end.
       
           case c-opcao: 
       
               when "Executa"
               then do on error undo, retry on endkey undo, leave:
       
                       if not lg-arquivo-aux
                       then do:
                              message "Voce deve passar pela opcao arquivo."
                                  view-as alert-box title "Atencao !!!".
                              next.
                            end.
       
                       message " Importando Dados, Aguarde...".
       
                      {hdp/hdmonarq.i &page-size = 64}
       
                       view frame f-cabecalho.
                       view frame f-rodape.
       
                       run importa-dados.
       
                       {hdp/hdclosed.i}
                       hide message no-pause.
                    end.
       
               when "Fim"
               then do:
                      hide all no-pause.
                      leave.
                    end.
           end case.
       
       end.
     END.

/* ------------------------------------------------------------------------------------------ */
procedure importa-dados:

    ASSIGN qtd-reg-rest = 100.

    /*REPEAT:

        IF NOT CAN-FIND (FIRST import-docto-revis-ctas WHERE import-docto-revis-ctas.ind-sit-import = in-status-monitorar-par)
        THEN LEAVE.
    */
        ASSIGN cont-aux = 0.
    
        FOR EACH import-docto-revis-ctas 
           WHERE import-docto-revis-ctas.ind-sit-import = in-status-monitorar-par EXCLUSIVE-LOCK:
            
                PROCESS EVENTS.

                message "Importando Doc.RC: " import-docto-revis-ctas.num-seqcial-control " Sit: " in-status-monitorar-par.

                assign lg-relat-erro     = no
                       lg-relat-erro-aux = no.

                RUN consiste-dados.

                IF  cont-aux >= qtd-reg-rest
                THEN LEAVE.
        END.

        /* cria registros */
        run cria-registros IN h-cg0311z-aux ASYNCHRONOUS.

        IF in-batch-online-par = "ONLINE"
        THEN run mostra-erro.

        run pi-grava-erro.

        /*sai a cada 1000 registros, para evitar o erro "TOO MANY INDEXES AREA 6" */
        /*IF ix-geral-aux > 1000
        THEN LEAVE.*/
    /*END.*/

   {hdp/hddelpersis.i}
end procedure.

/* ------------------------------------------------------------------------------------------ */
procedure consiste-dados:

    /* ------------------------------------------------------------ */
    /* ------------------------------- Consiste dados documento --- */
    assign lg-relat-erro = NO.
    run consiste-dados-documento.

    if lg-relat-erro
    then assign lg-relat-erro-aux = YES.
    else do:
           /* ------------------------------- Consiste dados movimento --- */
           ASSIGN lg-relat-erro = NO.
           run cons-dados-proced.
           
           IF lg-relat-erro
           THEN ASSIGN lg-relat-erro-aux = YES.
           
           ASSIGN lg-relat-erro = NO.
           run cons-dados-insumo.
           
           IF lg-relat-erro
           THEN ASSIGN lg-relat-erro-aux = YES.
         end.
    
    /* ------------------------------------------------------------ */
    assign cont-aux = cont-aux + 1.
    
    if lg-relat-erro-aux
    then do:
           IF in-batch-online-par = "ONLINE"
           THEN run mostra-erro.

           run pi-grava-erro.
           
           assign lg-imp-erro = yes. 
         end.
    else do:
           run atribui-campos-adic.

           ix-geral-aux = ix-geral-aux + 1.

           create tt-import-docto-revis-ctas.
           assign tt-import-docto-revis-ctas.rowid-import-docto-revis-ctas = rowid(import-docto-revis-ctas).
         end.

end procedure.

/* ------------------------------------------------------------------------------------------ */
procedure consiste-dados-documento:

    assign lg-prestador-unico-aux       = no
           in-acao-tran-guia-aux        = 0   
           lg-estorno-aux               = no
           lg-altera-clahos-aux         = no
           lg-dados-internacao-aux      = no
           lg-pede-doc-original-aux     = no
           lg-fecha-guia-assoc-aux      = no
           lg-controle-fatura-aux       = no
           lg-possui-guia-aux           = no
           in-tipo-sequencia-aux        = 0
           cd-modalidade-aux            = 0
           nr-ter-adesao-aux            = 0
           cd-usuario-aux               = 0
           nr-serie-doc-orig-aux        = ""
           nr-doc-orig-aux              = 0
           cd-cla-hos-aux               = 0
           nr-indice-aux                = 0
           cd-unidade-carteira-ant-aux  = 0
           cd-carteira-usuario-ant-aux  = 0
           nr-via-carteira-ant-aux      = 0.

    /* ------------------------------ CONSISTE SE CAMPO UNIDADE E' VALIDO --- */
    if   import-docto-revis-ctas.cd-unidade = ?
    or   import-docto-revis-ctas.cd-unidade = 0
    then run pi-cria-tt-erros ("Campo unidade invalido.").
    else do:
           find unimed where unimed.cd-unimed = import-docto-revis-ctas.cd-unidade no-lock no-error.
           if   not avail unimed
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Unidade nao cadastrada.").
                end.
         end.

    /* ------------------- CONSISTE SE CAMPO UNIDADE PRESTADORA E' VALIDO --- */
    if   import-docto-revis-ctas.cd-unidade-prestadora = ?
    or   import-docto-revis-ctas.cd-unidade-prestadora = 0
    then run pi-cria-tt-erros ("Campo unidade prestadora deve ser informado.").
    else do:
           find unimed where unimed.cd-unimed = import-docto-revis-ctas.cd-unidade-prestadora no-lock no-error.
           if   not avail unimed
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Unidade prestadora nao cadastrada.").
                end.
         end.
    
    /* ---------------------------- CONSISTE SE CAMPO TRANSACAO E' VALIDO --- */
    if   import-docto-revis-ctas.cd-transacao = ?
    or   import-docto-revis-ctas.cd-transacao = 0
    then run pi-cria-tt-erros ("Campo transacao invalido.").
    else do:
           find tranrevi where tranrevi.cd-transacao = import-docto-revis-ctas.cd-transacao no-lock no-error.
           if not avail tranrevi
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Transacao nao cadastrada").
                end.
           ELSE DO:
                  assign in-acao-tran-guia-aux    = tranrevi.in-acao-tran-guia
                         lg-fecha-guia-assoc-aux  = tranrevi.lg-fecha-guias-associadas
                         lg-controle-fatura-aux   = tranrevi.lg-controle-fatura         
                         lg-prestador-unico-aux   = tranrevi.lg-prestador-unico
                         lg-estorno-aux           = tranrevi.lg-estorno
                         lg-altera-clahos-aux     = tranrevi.lg-altera-clahos
                         lg-dados-internacao-aux  = tranrevi.lg-dados-internacao
                         lg-pede-doc-original-aux = tranrevi.lg-pede-doc-original
                         in-tipo-sequencia-aux    = tranrevi.in-tipo-sequencia.
                  
                  IF tranrevi.log-15
                  or import-docto-revis-ctas.cd-cid <> ""
                  then do:
                         /* ---------------- VERIFICA SE O CID E ESTA CADASTRADO --- */
                         find dz-cid10 where dz-cid10.cd-cid = import-docto-revis-ctas.cd-cid no-lock no-error.
                  
                         if   not avail dz-cid10
                         then do:
                                assign lg-relat-erro = yes.
                                run pi-cria-tt-erros ("Doenca nao cadastrada.").
                              end.
                       end.

                  IF  tranrevi.lg-pede-local-atendimento 
                  and import-docto-revis-ctas.cd-local-atendimento = 0 
                  then assign import-docto-revis-ctas.cd-local-atendimento = tranrevi.int-12.
                END.
         end.
    
    /* --------- CONSISTE SE CAMPO NUMERO DO DOCUMENTO ORIGINAL E' VALIDO --- */
    if   import-docto-revis-ctas.nr-doc-original = ?
    or   import-docto-revis-ctas.nr-doc-original = 0
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Campo Nr.doc original deve ser informado.").
         end.
    
    /* ---------- CONSISTE SE CAMPO NUMERO DO DOCUMENTO SISTEMA E' VALIDO --- */
    if   import-docto-revis-ctas.nr-doc-sistema = ?
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Campo Nr.doc.sistema da tabela temporaria invalido.").
         end.
    
    /* -------------------------------- CLINICA ----------------------------- */
    if  import-docto-revis-ctas.cd-clinica <> 0                                        
    then do:                                                               
           find clinicas where clinicas.cd-clinica = import-docto-revis-ctas.cd-clinica no-lock no-error.                             
    
           if not avail clinicas                                           
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Clinica nao cadastrada.").  
                end.
    
           else if AVAIL tranrevi
                AND tranrevi.lg-pede-clinica
                then do:
                       find first clinpres where clinpres.cd-clinica = clinicas.cd-clinica no-lock no-error.
     
                       if avail clinpres
                       then assign import-docto-revis-ctas.cd-local-atendimento = clinpres.cd-local-atendimento.
                     end.
         end.
    
    /* --------------------------------------------- LOCAL DE ATENDIMENTO --- */
    if  import-docto-revis-ctas.cd-local-atendimento <> 0                              
    then do:                                                                
           find locaaten where locaaten.cd-local-atendimento = import-docto-revis-ctas.cd-local-atendimento no-lock no-error.                              
    
           if not avail locaaten                                            
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Local de atendimento nao cadastrado.").
                end.
    
           else IF AVAIL tranrevi
                AND tranrevi.lg-pede-local-atendimento
                then assign import-docto-revis-ctas.cd-local-atendimento = locaaten.cd-local-atendimento.
         end.                                                                                                                                                                                                                    
    
    /* ------- CONSISTE SE CAMPO ANO DO PERIODO DE MOVIMENTACAO E' VALIDO --- */
    if   import-docto-revis-ctas.dt-anoref = ?
    or   import-docto-revis-ctas.dt-anoref = 0
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Campo ano do periodo deve ser informado.").
         end.
    
    /* ---- CONSISTE SE CAMPO NUMERO DO PERIODO DE MOVIMENTACAO E' VALIDO --- */
    if   import-docto-revis-ctas.nr-perref = ?
    or   import-docto-revis-ctas.nr-perref = 0
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Campo numero do periodo deve ser informado.").
         end.
    
    find perimovi where perimovi.dt-anoref = import-docto-revis-ctas.dt-anoref
                    and perimovi.nr-perref = import-docto-revis-ctas.nr-perref
                        no-lock no-error.
    if   avail perimovi
    then assign dt-inicio-per-aux = perimovi.dt-inicio-per
                dt-fim-per-aux    = perimovi.dt-fim-per.
    else do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Periodo de movimentacao nao cadastrado.").
         end.
    
    /* --- VERIFICA SE O DOCUMENTO POSSUIRA UMA GUIA ASSOCIADA -------------- */
    if in-acao-tran-guia-aux <> 0
    /* -------- DOCUMENTO PODERA TER UMA GUIA OU NAO --- */
    then do:
           if   import-docto-revis-ctas.aa-guia-atendimento > 0
           and  import-docto-revis-ctas.nr-guia-atendimento > 0
           /* ---------- DOCUMENTO POSSUIRA UMA GUIA --- */
           then assign lg-possui-guia-aux = yes.
           else if in-acao-tran-guia-aux = 3
                then do:
                       assign lg-relat-erro = yes.
                       run pi-cria-tt-erros ("Guia deve ser informada.").
                     end.
         end.
     
    /* - SETA VARIAVEIS AUXILIARES COM O NUMERO DE SERIE DO --- */
    /* -------------------------- DOCTO E O NUMERO DO DOCTO --- */
    if   lg-possui-guia-aux
    and  (   in-acao-tran-guia-aux = 2
          or in-acao-tran-guia-aux = 3)  
    then do:
           find first import-guia where import-guia.cod-guia-operdra = string(import-docto-revis-ctas.nr-guia-atendimento) no-lock no-error.

           if avail import-guia 
           then do:
                  find guiautor where guiautor.cd-unidade          = import-guia.cd-unimed
                                  and guiautor.aa-guia-atendimento = import-guia.aa-guia-atendimento                  
                                  and guiautor.nr-guia-atendimento = import-guia.nr-guia-atendimento                     
                                      no-lock no-error.   
                                                        
                  if   available guiautor
                  then assign import-docto-revis-ctas.aa-guia-origem = guiautor.aa-guia-atend-origem
                              import-docto-revis-ctas.nr-guia-origem = guiautor.nr-guia-atend-origem
                              nr-serie-doc-orig-aux                  = STRING(guiautor.aa-guia-atendimento)
                              nr-doc-orig-aux                        = guiautor.nr-guia-atendimento.
                end.
         end.
 
    else assign nr-serie-doc-orig-aux = import-docto-revis-ctas.nr-serie-doc-original
                nr-doc-orig-aux       = import-docto-revis-ctas.nr-doc-original.
 
    /* ------ VERIFICA SE O NUMERO DO DOCUMENTO ORIGINAL JA --- */
    /* ----------------------------------------- CADASTRADO --- */
    if can-find (first c-docrecon 
                 where c-docrecon.cd-unidade            = import-docto-revis-ctas.cd-unidade
                   and c-docrecon.cd-unidade-prestadora = import-docto-revis-ctas.cd-unidade-prestadora
                   and c-docrecon.cd-transacao          = import-docto-revis-ctas.cd-transacao
                   and c-docrecon.nr-serie-doc-original = nr-serie-doc-orig-aux
                   and c-docrecon.nr-doc-original       = nr-doc-orig-aux)
    and in-tipo-sequencia-aux <= 0
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Numero do documento original ja cadastrado.").
         end.
 
    /* -------------------------------- PRESTADOR PRINCIPAL --- */
 
    /* -- CONSISTE SE O CAMPO PRESTADOR PRINCIPAL E' VALIDO --- */
    if   import-docto-revis-ctas.cd-prestador-principal = ?
    then run pi-cria-tt-erros ("Campo prestador principal da tabela temporaria invalido.").
    else do:
           find preserv where preserv.cd-unidade   = import-docto-revis-ctas.cd-unidade-prestadora
                          and preserv.cd-prestador = import-docto-revis-ctas.cd-prestador-principal
                              no-lock no-error.
           if   not avail preserv
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Prestador principal nao cadastrado.").
                end.
         end.
 
    /* -------------------------------- CHAMADA DA RTAPI024 --- */
    /* ----------- VERIFICA VINCULOS DO PRESTADOR PRINCIPAL --- */
    assign in-funcao-rtapi024-aux    = "GDT"
           lg-erro-rtapi024-aux      = no
           lg-prim-mens-rtapi024-aux = no
           cd-unidade-rtapi024-aux   = import-docto-revis-ctas.cd-unidade-prestadora
           cd-prestador-rtapi024-aux = import-docto-revis-ctas.cd-prestador-principal
           cd-transacao-rtapi024-aux = import-docto-revis-ctas.cd-transacao
           in-vinculo-rtapi024-aux   = "P"
           dt-realizacao-rtapi024-aux = import-docto-revis-ctas.dt-emissao.
 
    run rtp/rtapi024.p no-error.
 
    if   error-status:error
    then do:
           assign lg-relat-erro = yes.
           if   error-status:num-messages = 0
           then run pi-cria-tt-erros ("Operador teclou Ctrl C.").
           else run pi-cria-tt-erros (substring(error-status:get-message(error-status:num-messages), 1,75)).           
         end.
 
    if   lg-erro-rtapi024-aux
    then do:
           FOR EACH tmp-mensa-rtapi024:
               ASSIGN ds-msg-aux = "".

               IF tmp-mensa-rtapi024.cd-mensagem-mens <> ?
               THEN ds-msg-aux = STRING(tmp-mensa-rtapi024.cd-mensagem-mens) + " ".

               IF tmp-mensa-rtapi024.ds-mensagem-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + tmp-mensa-rtapi024.ds-mensagem-mens + " ".

               IF tmp-mensa-rtapi024.ds-complemento-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + tmp-mensa-rtapi024.ds-complemento-mens + " ".

               IF tmp-mensa-rtapi024.ds-chave-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + tmp-mensa-rtapi024.ds-chave-mens + " ".
                      
               RUN pi-cria-tt-erros(ds-msg-aux).
           END.
           assign lg-relat-erro = yes.
         END.
 
    if   import-docto-revis-ctas.cd-vinculo-principal = 0
    then do:
           /* ----- SETA O PRIMEIRO TIPO DE VINCULO DA TEMP --- */
           find first tmp-rtapi024 no-lock no-error.
           if   avail tmp-rtapi024
           then assign import-docto-revis-ctas.cd-vinculo-principal = tmp-rtapi024.cd-vinculo.
         end.
    else do:
           /*  VERIFICA SE O VINCULO E' IGUAL AO CADASTRADO --- */
           /* -------------------------------- NA TRANSACAO --- */
           find first tmp-rtapi024 where tmp-rtapi024.cd-vinculo = import-docto-revis-ctas.cd-vinculo-principal no-lock no-error.

           if   not avail tmp-rtapi024
           then do:
                  find first tmp-rtapi024 no-lock no-error.

                  if   avail tmp-rtapi024
                  then assign import-docto-revis-ctas.cd-vinculo-principal = tmp-rtapi024.cd-vinculo.
                  else do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros ("Tipo de vinculo do prestador principal difere do cadastrado na transacao.").
                       end.
                end.
         end.

    /* ----------------------- CONSISTE A CARTEIRA DO BENEFICIARIO --- */
    IF import-docto-revis-ctas.cd-unidade-carteira = paramecp.cd-unimed
    THEN DO:
           FIND FIRST usuario  USE-INDEX usuari26
                WHERE usuario.cd-carteira-antiga = import-docto-revis-ctas.cd-carteira-usuario NO-LOCK NO-ERROR.
           
           IF AVAIL usuario
           THEN DO:
                  assign cd-modalidade-aux = usuario.cd-modalidade
                         nr-ter-adesao-aux = usuario.nr-ter-adesao
                         cd-usuario-aux    = usuario.cd-usuario.
           
                  find propost where propost.cd-modalidade = usuario.cd-modalidade
                                 and propost.nr-proposta   = usuario.nr-proposta
                                     no-lock no-error.
                  
                  if   not available propost
                  then do:
                         ASSIGN ds-msg-aux = "Proposta nao encontrada. Modalidade: ".
           
                         IF usuario.cd-modalidade <> ?
                         THEN ds-msg-aux = ds-msg-aux + STRING(usuario.cd-modalidade) + " ".
                         ELSE ds-msg-aux = ds-msg-aux + "nulo".
           
                         ASSIGN ds-msg-aux = ds-msg-aux + " Proposta: ".
           
                         IF usuario.nr-proposta <> ?
                         THEN ds-msg-aux = ds-msg-aux + STRING(usuario.nr-proposta) + " ".
                         ELSE ds-msg-aux = ds-msg-aux + "nulo".
           
                         run pi-cria-tt-erros (ds-msg-aux).
                         assign lg-relat-erro = yes.
                         RETURN.
                       end.
                  ELSE ASSIGN cd-plano-aux      = propost.cd-plano
                              cd-tipo-plano-aux = propost.cd-tipo-plano.
           
                  /**
                   * Buscar a CAR-IDE ativa do beneficiario e atualizar na tabela de importacao.
                   */
                  FIND FIRST car-ide NO-LOCK
                       WHERE car-ide.cd-unimed     = import-docto-revis-ctas.cd-unidade-carteira
                         AND car-ide.cd-modalidade = usuario.cd-modalidade
                         AND car-ide.nr-ter-adesao = usuario.nr-ter-adesao
                         AND car-ide.cd-usuario    = usuario.cd-usuario
                         AND car-ide.cd-sit-carteira = 1 /* ativa */ NO-ERROR.
                  IF NOT AVAIL car-ide
                  then do:
                         FIND FIRST car-ide USE-INDEX car-ide6 NO-LOCK
                              WHERE car-ide.cd-unimed     = import-docto-revis-ctas.cd-unidade-carteira
                                AND car-ide.cd-modalidade = usuario.cd-modalidade
                                AND car-ide.nr-ter-adesao = usuario.nr-ter-adesao
                                AND car-ide.cd-usuario    = usuario.cd-usuario NO-ERROR.
                         IF NOT AVAIL car-ide
                         THEN DO:
                                ds-msg-aux = "Carteira do Beneficiario  da base nao encontrada. Modalidade: ".
                                 
                                IF usuario.cd-modalidade <> ?
                                THEN ds-msg-aux = ds-msg-aux + string(usuario.cd-modalidade,"99") + " ".
                                ELSE ds-msg-aux = ds-msg-aux + "nulo".
           
                                ds-msg-aux = ds-msg-aux + " Proposta: ".
                                 
                                IF usuario.nr-proposta <> ?
                                THEN ds-msg-aux = ds-msg-aux + string(usuario.nr-proposta,"99999999").
                                ELSE ds-msg-aux = ds-msg-aux + "nulo".
           
                                ds-msg-aux = ds-msg-aux + " Benef.: ".
                                   
                                IF usuario.cd-usuario <> ?
                                THEN ds-msg-aux = ds-msg-aux + STRING(usuario.cd-usuario,"99999").
                                ELSE ds-msg-aux = ds-msg-aux + "nulo".
           
                                run pi-cria-tt-erros (ds-msg-aux).
                                assign lg-relat-erro = yes.
                                RETURN.
                              END.
                       END.
                  IF AVAIL car-ide
                  THEN do:
                         ASSIGN /*guardar carteira anterior e nova em cod-livre-1 para validacao da regra*/
                                import-docto-revis-ctas.cod-livre-1 = string(import-docto-revis-ctas.cd-carteira-usuario) + " | " + string(car-ide.cd-carteira-inteira)
                                import-docto-revis-ctas.cd-carteira-usuario = car-ide.cd-carteira-inteira.
                       END.
                END.
           ELSE DO:
                  ASSIGN ds-msg-aux = "Beneficiario da base nao encontrado pela carteira antiga: ".
                  
                  IF import-docto-revis-ctas.cd-carteira-usuario <> ?
                  THEN ds-msg-aux = ds-msg-aux + STRING(import-docto-revis-ctas.cd-carteira-usuario).
                  ELSE ds-msg-aux = ds-msg-aux + "nulo".
                  
                  run pi-cria-tt-erros (ds-msg-aux).
                  assign lg-relat-erro = yes.
                  RETURN.
                END.
         END.
    ELSE DO:
           FIND FIRST out-uni
                WHERE out-uni.cd-carteira-usuario = import-docto-revis-ctas.cd-carteira-usuario NO-LOCK NO-ERROR.

           IF AVAIL out-uni
           THEN DO:
                  /* ------------------ LOCALIZA NEGOCIACAO ENTRE UNIMEDS ------------------------- */
                  find first unicamco where unicamco.cd-unidade = out-uni.cd-unidade
                                        and unicamco.dt-limite >= today 
                                            no-lock no-error.
                  
                  if not available unicamco
                  then do:
                         ds-msg-aux = "Negociacao entre Unidades nao cadastrada. Unidade: ".
                          
                         IF out-uni.cd-unidade <> ?
                         THEN ds-msg-aux = ds-msg-aux + string(out-uni.cd-unidade,"9999").
                         ELSE ds-msg-aux = ds-msg-aux + "nulo".

                         run pi-cria-tt-erros(ds-msg-aux).
                         assign lg-relat-erro = yes.
                         return.
                       end.

                  ELSE ASSIGN cd-plano-aux      = unicamco.cd-plano
                              cd-tipo-plano-aux = unicamco.cd-tipo-plano
                              cd-modalidade-aux = unicamco.cd-modalidade          
                              nr-ter-adesao-aux = 0
                              cd-usuario-aux    = 0.
                END.
           ELSE DO:
                  ds-msg-aux  = "Beneficiario de intercambio nao cadastrado. Carteira: ".
                   
                  IF import-docto-revis-ctas.cd-carteira-usuario <> ?
                  THEN ds-msg-aux = ds-msg-aux + string(import-docto-revis-ctas.cd-carteira-usuario).
                  ELSE ds-msg-aux = ds-msg-aux + "nulo".

                  ds-msg-aux = ds-msg-aux + " Unidade: ".

                  IF import-docto-revis-ctas.cd-unidade-carteira <> ?
                  THEN ASSIGN ds-msg-aux = ds-msg-aux + string(import-docto-revis-ctas.cd-unidade-carteira).
                  ELSE ASSIGN ds-msg-aux = ds-msg-aux + "nulo".
                       
                  run pi-cria-tt-erros(ds-msg-aux).
                  assign lg-relat-erro = yes.  
                  RETURN.
                END.
         END.

    find modalid where modalid.cd-modalidade = cd-modalidade-aux no-lock no-error.
    
    if   not available modalid
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Modalidade nao cadastrada.").
           RETURN.
         end. 

    find ti-pl-sa where ti-pl-sa.cd-modalidade = cd-modalidade-aux
                    and ti-pl-sa.cd-plano      = cd-plano-aux
                    and ti-pl-sa.cd-tipo-plano = cd-tipo-plano-aux no-lock no-error.

    if   not available ti-pl-sa
    then do:
           ds-msg-aux = "Tipo de plano nao cadastrado. Mod: ".
            
           IF cd-modalidade-aux <> ?
           THEN ds-msg-aux = ds-msg-aux + string(cd-modalidade-aux,"99").
           ELSE ds-msg-aux = ds-msg-aux + "nulo".
                 
           ds-msg-aux = ds-msg-aux + " Plano: ".
            
           IF cd-plano-aux <> ?
           THEN ds-msg-aux = ds-msg-aux + string(cd-plano-aux,"99").
           ELSE ds-msg-aux = ds-msg-aux + "nulo".
                 
           ds-msg-aux = ds-msg-aux + " Tp Plano: ".
            
           IF cd-tipo-plano-aux <> ?
           THEN ds-msg-aux = ds-msg-aux + string(cd-tipo-plano-aux,"99").     
           ELSE ds-msg-aux = ds-msg-aux + "nulo".

           run pi-cria-tt-erros (ds-msg-aux).     
           assign lg-relat-erro = yes.
           RETURN.
         end.

    find clashosp where clashosp.cd-cla-hos = ti-pl-sa.cd-cla-hos no-lock no-error.

    if   not available clashosp
    then do:
           run pi-cria-tt-erros ("Classe hosp. nao cadastrada. Classe: " + string(ti-pl-sa.cd-cla-hos)).
           assign lg-relat-erro = yes.
         end.

    /* ------ SETA MODALIDADE/TERMO/BENEF. EM VARIAVEIS AUXILIARES --- */
    assign cd-cla-hos-aux    = ti-pl-sa.cd-cla-hos
           nr-indice-aux     = clashosp.nr-indice-hierarquico.   

    /* --------------------------- SETA A CARTEIRA DO BENEFICIARIO --- */
    /* ---------- POIS A MESMA PODE TER SIDO ENCONTRADA ATRAVES DE --- */
    /* ---------------------------- NUMERO ANTIGO, ORIGEM, DESTINO --- */
    assign  cd-unidade-carteira-ant-aux  = import-docto-revis-ctas.cd-unidade-carteira 
            cd-carteira-usuario-ant-aux  = import-docto-revis-ctas.cd-carteira-usuario 
            nr-via-carteira-ant-aux      = import-docto-revis-ctas.nr-via-carteira.     
    
    /*assign import-docto-revis-ctas.cd-unidade-carteira = tmp-rtapi022.cd-unidade-carteira
           import-docto-revis-ctas.cd-carteira-usuario = tmp-rtapi022.cd-carteira-usuario
           import-docto-revis-ctas.nr-via-carteira     = tmp-rtapi022.nr-via-carteira.*/
    
    
    /* ------------------------------------- PRESTADOR SOLICITANTE --- */
    
    /* --------- CONSISTE SE O CAMPO UNIDADE SOLICITANTE E' VALIDO --- */
    if   import-docto-revis-ctas.cd-unidade-solicitante = ?
    then run pi-cria-tt-erros ("Campo unidade do prestador solicitante invalido.").
                     
    else do:
           find unimed where unimed.cd-unimed = import-docto-revis-ctas.cd-unidade-solicitante no-lock no-error.
           if   not avail unimed
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Unidade do prestador solicitante nao cadastrada.").
                end.
         end.
    
    /* ------- CONSISTE SE O CAMPO PRESTADOR SOLICITANTE E' VALIDO --- */
    if   import-docto-revis-ctas.cd-prestador-solicitante = ?
    then run pi-cria-tt-erros ("Campo prestador solicitante da tabela temporaria invalido.").
    else do:
           find preserv where preserv.cd-unidade   = import-docto-revis-ctas.cd-unidade-solicitante
                          and preserv.cd-prestador = import-docto-revis-ctas.cd-prestador-solicitante
                              no-lock no-error.
           if   not avail preserv
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Prestador solicitante nao cadastrado.").
                end.
         end.
    
    /* --------------------------------------- CHAMADA DA RTAPI023 --- */
    /* ----------- VERIFICA ESPECIALIDADE DO PRESTADOR SOLICITANTE --- */
    assign in-funcao-rtapi023-aux         = "GDT"
           lg-erro-rtapi023-aux           = no
           lg-prim-mens-rtapi023-aux      = no
           cd-unidade-rtapi023-aux        = import-docto-revis-ctas.cd-unidade-solicitante
           cd-prestador-rtapi023-aux      = import-docto-revis-ctas.cd-prestador-solicitante
           cd-tipo-vinc-rtapi023-aux      = import-docto-revis-ctas.cd-vinculo-solicitante
           in-tipo-prestador-rtapi023-aux = "S"
           in-tipo-consist-rtapi023-aux   = "TRANSACAO"
           cd-tipo-guia-rtapi023-aux      = 0
           cd-transacao-rtapi023-aux      = import-docto-revis-ctas.cd-transacao
           dt-realizacao-rtapi023-aux     = import-docto-revis-ctas.dt-emissao.
    
    run rtp/rtapi023.p no-error.
    
    if   error-status:error
    then do:
           if   error-status:num-messages = 0
           then run pi-cria-tt-erros ("Operador teclou Ctrl C.").                
           else run pi-cria-tt-erros (substring(error-status:get-message(error-status:num-messages), 1,75)).
           assign lg-relat-erro = yes.
         end.
    
    if   lg-erro-rtapi023-aux
    then do:
           FOR EACH tmp-mensa-rtapi023:
               ds-msg-aux = "".
               IF tmp-mensa-rtapi023.cd-mensagem-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + string(tmp-mensa-rtapi023.cd-mensagem-mens) + " ".

               IF tmp-mensa-rtapi023.ds-mensagem-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + tmp-mensa-rtapi023.ds-mensagem-mens + " ".

               IF tmp-mensa-rtapi023.ds-complemento-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + tmp-mensa-rtapi023.ds-complemento-mens + " ".

               IF tmp-mensa-rtapi023.ds-chave-mens <> ?
               THEN ds-msg-aux = ds-msg-aux + tmp-mensa-rtapi023.ds-chave-mens + " ".

               RUN pi-cria-tt-erros(ds-msg-aux).
           END.
           assign lg-relat-erro = yes.
         END.
    
    if   import-docto-revis-ctas.cd-especialid = 0
    then do:
           /* -------------- SETA A PRIMEIRA ESPECIALIDADE DA TEMP --- */
           find first tmp-rtapi023 no-error.
           if   avail tmp-rtapi023
           then assign import-docto-revis-ctas.cd-especialid = tmp-rtapi023.cd-especialid.
         end.
    else do:  
           /* ------ VERIFICA SE A ESPECIALIDADE INFORMADA ESTA NA --- */
           /*  TEMP DE ESPECIALIDADES PARA O PRESTADOR SOLICITANTE --- */
           find first tmp-rtapi023 where tmp-rtapi023.cd-especialid = import-docto-revis-ctas.cd-especialid no-error.
           if   not avail tmp-rtapi023
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Nao foi localizada a especialidade para o prestador solicitante.").
                end.
         end.
    
    if   lg-altera-clahos-aux
    then do:
           /* ---- CONSISTE SE O CAMPO CLASSE HOSPITALAR E' VALIDO --- */
           if   import-docto-revis-ctas.cd-cla-hos = ?
           or   import-docto-revis-ctas.cd-cla-hos = 0
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Campo classe hospitalar da tabela temporaria invalido.").
                end.
    
           else do:
                  /* -- VERIFICA CLASSE HOSPITALAR ESTA CADASTRADA --- */
                  find clashosp where clashosp.cd-cla-hos = import-docto-revis-ctas.cd-cla-hos no-lock no-error.
                  if   avail clashosp
                  then do:
                         /* INDICE HIERARQUICO DA CLASSE INFORMADA --- */
                         /* MAIOR QUE INDICE HIERARQUICO DA CLASSE --- */
                         /* --------------------- DO TIPO DE PLANO --- */
                         if   clashosp.nr-indice-hierarquico > nr-indice-aux
                         then run pi-cria-tt-erros ("Classe hospitalar com acomodacoes superiores as cobertas pelo plano.").
                       end.
                  else do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros ("Classe hospitalar nao cadastrada.").
                       end.
                end.
         end.
    
    if   lg-pede-doc-original-aux
    then do:
           /* CONSISTE SE CAMPO NUMERO DOCTO CONTRATANTE E' VALIDO --- */
           if   import-docto-revis-ctas.nr-docto-contratante = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Campo numero do documento do contratante da tabela temporaria invalido.").
                end.
         end.
    
    if   lg-dados-internacao-aux
    then do:
           /* ----- CONSISTE SE CAMPO DATA DA INTERNACAO E' VALIDO --- */
           if   import-docto-revis-ctas.dt-internacao = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Campo data da internacao invalido.").
                end.
    
           /* ----------- CONSISTE SE CAMPO DATA DA ALTA E' VALIDO --- */
           if   import-docto-revis-ctas.dt-alta = ?
           then run pi-cria-tt-erros ("Campo data da alta invalido.").
    
           else do:
                  /* ----- CONSISTE SE CAMPO DATA DA INTERNACAO E' --- */
                  /* -------------- MAIOR QUE O CAMPO DATA DA ALTA --- */
                  if   import-docto-revis-ctas.dt-internacao > import-docto-revis-ctas.dt-alta
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros ("Data da internacao nao pode ser maior que a data da alta.").
                       end.
                end.
    
           /* ------- CONSISTE SE O CAMPO MOTIVO DA ALTA E' VALIDO --- */
           if   import-docto-revis-ctas.cd-motivo-alta = ?
           or   import-docto-revis-ctas.cd-motivo-alta = 0
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Campo motivo da alta da tabela temporaria invalido.").
                end.
           else do:
                  find motialta where motialta.cd-motivo-alta = import-docto-revis-ctas.cd-motivo-alta no-lock no-error.

                  if   not avail motialta
                  then do:
                         assign lg-relat-erro = yes.
                         run pi-cria-tt-erros ("Motivo da alta nao cadastrado.").
                       end.
                end.
         end.
    
    /* --------------- CONSISTE SE CAMPO DATA DE EMISSAO E' VALIDO --- */
    if   import-docto-revis-ctas.dt-emissao = ?
    then do:
           assign lg-relat-erro = yes.
           run pi-cria-tt-erros ("Campo data de emissao invalido.").
         end.                         
    else do:
           /* - VERIFICA SE A DATA DE EMISSAO ESTA FORA DO PERIODO --- */
          /* if   import-docto-revis-ctas.dt-emissao < dt-inicio-per-aux
           or   import-docto-revis-ctas.dt-emissao > dt-fim-per-aux
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Data de emissao fora do periodo.").
                end.*/
         end.

    /* --------------------------------------------- CONSISTE GUIA --- */    
    if import-docto-revis-ctas.log-guia
    then do:
           /* - CONSISTE SE CAMPO ANO GUIA ORIGEM E' VALIDO --- */
           if   import-docto-revis-ctas.aa-guia-origem = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Campo ano da guia origem invalido.").
                end.
         
           /* - CONSISTE SE CAMPO NRO GUIA ORIGEM E' VALIDO --- */
           if   import-docto-revis-ctas.nr-guia-origem = ?
           then do:
                  assign lg-relat-erro = yes.
                  run pi-cria-tt-erros ("Campo numero da guia origem invalido.").
                end.
         end.    

end procedure.

/* ------------------------------------------------------------------------------------------ */
procedure atribui-campos-adic:

    assign import-docto-revis-ctas.log-period-unico      = yes
           import-docto-revis-ctas.log-prestdor-unico    = lg-prestador-unico-aux
           import-docto-revis-ctas.cd-unidade-principal  = import-docto-revis-ctas.cd-unidade-prestadora
           import-docto-revis-ctas.log-estorn            = lg-estorno-aux
           import-docto-revis-ctas.cd-modalidade         = cd-modalidade-aux
           import-docto-revis-ctas.nr-ter-adesao         = nr-ter-adesao-aux
           import-docto-revis-ctas.cd-usuario            = cd-usuario-aux
           import-docto-revis-ctas.log-modul-unico       = yes
           import-docto-revis-ctas.log-guia              = lg-possui-guia-aux.

    IF import-docto-revis-ctas.dt-digitacao = ?
    THEN ASSIGN import-docto-revis-ctas.dt-digitacao     = today.

    IF import-docto-revis-ctas.hr-digitacao = ""
    OR import-docto-revis-ctas.hr-digitacao = ?
    THEN import-docto-revis-ctas.hr-digitacao            = substring (string (time, "HH:MM:SS"), 1, 2) +
                                                           substring (string (time, "HH:MM:SS"), 4, 2) +
                                                           substring (string (time, "HH:MM:SS"), 7, 2).
 
    /* ----- TRANSACAO NAO PERMITE ALTERAR A CLASSE HOSPITALAR --- */
    if   not lg-altera-clahos-aux
    then assign import-docto-revis-ctas.cd-cla-hos = cd-cla-hos-aux.
 
    /* ----------------- CAMPOS ATUALIZADOS POR OUTROS MODULOS --- */
    assign import-docto-revis-ctas.in-local-autorizacao = 0
           import-docto-revis-ctas.cd-unidade-guia      = 0.
 
    /* ----------------------------- DOCUMENTO NAO POSSUI GUIA --- */
    if   not lg-possui-guia-aux
    then assign import-docto-revis-ctas.aa-guia-atendimento = 0
                import-docto-revis-ctas.nr-guia-atendimento = 0.
 
    /* ----------------------- INCLUIDO SEM LOTE DE IMPORTACAO --- */
    if   not lg-por-lote-rcapi020-aux
    then assign import-docto-revis-ctas.cd-unidade-imp   = 0
                import-docto-revis-ctas.cd-prestador-imp = 0
                import-docto-revis-ctas.nr-lote-imp      = 0
                import-docto-revis-ctas.nr-sequencia-imp = 0.
 
    /* -------------------- CAMPOS NAO UTILIZADOS PELO SISTEMA --- */
    assign import-docto-revis-ctas.nr-lote         = 0
           import-docto-revis-ctas.cd-situacao-doc = 0
           import-docto-revis-ctas.cd-sit-cobranca = 0
           import-docto-revis-ctas.cd-sit-pagto    = 0.

    /* Retirar espacos em branco desnecessarios */
    assign import-docto-revis-ctas.des-indcao-clinic = trim(import-docto-revis-ctas.des-indcao-clinic).  

    /* ------------- TRANSACAO NAO PERMITE CONTROLE POR FATURA --- */
    if   not lg-controle-fatura-aux
    then assign import-docto-revis-ctas.aa-fatura    = 0
                import-docto-revis-ctas.cd-serie-nf  = ""
                import-docto-revis-ctas.nr-fatura    = 0
                import-docto-revis-ctas.cod-fatur-ap = "".
 
    /* ---------------- TRANSACAO NAO PEDE DADOS DE INTERNACAO --- */
    if   not lg-dados-internacao-aux
    then assign import-docto-revis-ctas.dt-internacao  = ?
                import-docto-revis-ctas.dt-alta        = ?
                import-docto-revis-ctas.cd-motivo-alta = 0.
 
    /* --------------- ATUALIZA CAMPOS INDEPENDENTE DO TIPO DE FUNCAO --- */
    assign import-docto-revis-ctas.dt-atualizacao = today
           import-docto-revis-ctas.cd-userid      = cd-userid-rcapi020-aux.

   /* --- VALIDAR TP-CONSULTA --- */
   case import-docto-revis-ctas.tp-consulta:
       when "P" then import-docto-revis-ctas.tp-consulta = "1". /*Primeira Consulta"*/
       when "S" then import-docto-revis-ctas.tp-consulta = "2". /*Seguimento"*/
       WHEN "N" THEN import-docto-revis-ctas.tp-consulta = "3".  /*Pre-Natal"*/
   end case.
   IF  import-docto-revis-ctas.tp-consulta <> "1"
   AND import-docto-revis-ctas.tp-consulta <> "2"
   AND import-docto-revis-ctas.tp-consulta <> "3"
   THEN import-docto-revis-ctas.tp-consulta = "0".

end procedure.

/* ------------------------------------------------------------------------------------------ */
procedure cons-dados-proced:

    /* --- Procedimento --------------------------------------------------------------------- */
    for each import-movto-proced 
       where import-movto-proced.val-seqcial-docto = import-docto-revis-ctas.val-seqcial EXCLUSIVE-LOCK:

        assign import-movto-proced.dt-anoref = import-docto-revis-ctas.dt-anoref
               import-movto-proced.nr-perref = import-docto-revis-ctas.nr-perref.

        /* --------------------------------- CONSISTE UNIDADE DO PROCEDIMENTO --- */
        if   import-movto-proced.cd-unidade = 0
        or   import-movto-proced.cd-unidade = ?
        then run pi-cria-tt-erros ("Campo unidade da tabela de procedimento invalido.").
        else do:
               find unimed where unimed.cd-unimed = import-movto-proced.cd-unidade no-lock no-error.
        
               if not avail unimed
               or paramecp.cd-unimed <> import-movto-proced.cd-unidade
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros (if not avail unimed
                                            then "Unidade da tabela de procedimento nao cadastrada."
                                            else "Unidade da tabela de procedimento deve ser igual a dos parametros.").
                    end.
             end.
        
        /* ----------------------------------------------- UNIDADE PRESTADORA --- */
        if (import-movto-proced.cd-unidade-prestadora = ? or import-movto-proced.cd-unidade-prestadora = 0)
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo unidade prestadora da tab. de proced. invalido.").
             end.
        
        /* -------------------------------------------------------- TRANSACAO --- */
        if (import-movto-proced.cd-transacao = ? or import-movto-proced.cd-transacao = 0)
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo transacao da tab. de proced. invalido.").
             end.
        
        /* ---------------------------------------------- NUMERO DO DOCUMENTO --- */
        if (import-movto-proced.nr-doc-original = ? or import-movto-proced.nr-doc-original = 0)
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo Nr.doc original da tab. de proced. invalido.").
             end.
        
        /* ---------------------------------------- NUMERO DO PROCESSO/SISTEMA --- */
        if import-movto-proced.nr-doc-sistema = ?                                
        or (import-movto-proced.nr-processo = ? or import-movto-proced.nr-processo = 0) 
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros (if import-movto-proced.nr-doc-sistema = ?
                                     then "Campo Nr.doc.sistema da tab. de proced. invalido."
                                     else "Campo Nr.processo da tab. de proced. invalido.").
             end.
        
        /* -------------------------- CONSISTE CHAVE DA TEMP DE PROCEDIMENTOS --- */
        /* ---------------------------------------- COM CHAVE DA TEMP DA GUIA --- */
        if   import-movto-proced.cd-unidade            <> import-docto-revis-ctas.cd-unidade
        or   import-movto-proced.cd-unidade-prestadora <> import-docto-revis-ctas.cd-unidade-prestadora
        or   import-movto-proced.cd-transacao          <> import-docto-revis-ctas.cd-transacao
        or   import-movto-proced.nr-serie-doc-original <> import-docto-revis-ctas.nr-serie-doc-original
        or   import-movto-proced.nr-doc-original       <> import-docto-revis-ctas.nr-doc-original
        or   import-movto-proced.nr-doc-sistema        <> import-docto-revis-ctas.nr-doc-sistema
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Chave primaria da tab. de proced. difere com tab. do documento.").
             end.

        if avail tranrevi
        then do:
               /* -------------------------------------------- TESTA PRESTADOR UNICO --- */
               if tranrevi.lg-prestador-unico
               and ((string(import-movto-proced.cd-unidade-prestador,"9999")       + string(import-movto-proced.cd-prestador,"99999999"))
               <>   (string(import-docto-revis-ctas.cd-unidade-principal,"9999")   + string(import-docto-revis-ctas.cd-prestador-principal,"99999999")))
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Transacao do movimento so aceita prestador unico.").
                    end.

               /* ------------------------------------------ VERIFICA UNIDADE PADRAO --- */
               if tranrevi.lg-unidade-padrao
               and (import-movto-proced.cd-unidade-prestador  <> paramecp.cd-unimed or 
                    import-movto-proced.cd-unidade-prestadora <> paramecp.cd-unimed)
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Transacao " + STRING(tranrevi.cd-transacao) + 
                                            " parametrizada (parametro Unidade Padrao) para somente aceitar Unidades Prestador (" + 
                                            STRING(import-movto-proced.cd-unidade-prestador) + 
                                            ") e Prestadora (" + 
                                            STRING(import-movto-proced.cd-unidade-prestadora) + 
                                            ") da base: " +
                                            STRING(paramecp.cd-unimed)).
                    end.

               if import-movto-proced.cd-unidade-prestador = paramecp.cd-unimed
               and tranrevi.in-tipo-pagamento = 1   
               and not import-movto-proced.log-div-honor
               then do:                                                              
                      find clinicas where clinicas.cd-clinica = import-docto-revis-ctas.cd-clinica no-lock no-error.                                         
                      if   available clinicas                                        
                      then do:                                                       
                             if clinica.cd-unidade-prestador = 0                               
                             or clinica.cd-prestador         = 0                               
                             then do:
                                    assign lg-relat-erro = yes.
                                    run pi-cria-tt-erros ("Prestador da tab. de proced. nao cadastrado nesta clinica").  
                                  end.
                           end.                                                      
                    end. 

               /* ------------------------------------- TIPO DE VINCULO DO PRESTADOR --- */
               if  import-movto-proced.cd-tipo-vinculo <> 0
               and tranrevi.lg-vinculo-unico-executante
               and tranrevi.cd-vinculo-executante <> import-movto-proced.cd-tipo-vinculo
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Campo vinculo do executante da tab. de proced. deve ser igual ao da transacao.").
                    end.
             end.

        /* ------------------------------------ PESQUISA PROCEDIMENTO NA BASE --- */
        find ambproce where ambproce.cd-esp-amb        = import-movto-proced.cd-esp-amb
                        and ambproce.cd-grupo-proc-amb = import-movto-proced.cd-grupo-proc-amb
                        and ambproce.cd-procedimento   = import-movto-proced.cd-procedimento
                        and ambproce.dv-procedimento   = import-movto-proced.idi-dv-proced
                            no-lock no-error.
        
        if   not available ambproce
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Procedimento nao cadastrado.").
             end.
        
        /* ----------------------------- CONSISTE QUANTIDADE DO PROCEDIMENTO --- */
        if   import-movto-proced.qt-procedimentos = 0
        or   import-movto-proced.qt-procedimentos = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo quantidade de procedimento/insumo da tabela temporaria invalido.").
             end.
        
        /* --------------------- TESTA DATA E HORA DA REALIZACAO DO MOVIMENTO --- */
        if  import-movto-proced.dt-realizacao = ?
        or (import-movto-proced.hr-realizacao = "" or import-movto-proced.hr-realizacao = ?)
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros (if import-movto-proced.dt-realizacao = ? 
                                     then "Campo data da realizacao da tab. de proced. invalido."
                                     else "Campo hora de realizacao da tab. de proced. invalido.").
             end.
        
        assign lg-erro-hora-aux = no.
        
        assign nr-hora-aux = int(substring(import-movto-proced.hr-realizacao,1,2)) no-error.
        
        if   error-status:error
        then assign lg-erro-hora-aux = yes.
             
        assign nr-minutos-aux = int(substring(import-movto-proced.hr-realizacao,4,2)) no-error.
        
        if   error-status:error
        then assign lg-erro-hora-aux = yes.
        
        if   (nr-hora-aux    < 0 or nr-hora-aux > 23)
        or   (nr-minutos-aux < 0 or nr-minutos-aux > 59)
        then assign lg-erro-hora-aux = yes.
        
        if   lg-erro-hora-aux
        then do:
               assign lg-erro-hora-aux = no.                                                   
                                                                                               
               assign nr-hora-aux = int(substring(import-movto-proced.hr-realizacao,1,2)) no-error.   
                                                                                               
               if   error-status:error                                                         
               then assign lg-erro-hora-aux = yes.                                             
                                                                                               
               assign nr-minutos-aux = int(substring(import-movto-proced.hr-realizacao,3,2)) no-error.
                                                                                               
               if   error-status:error                                                         
               then assign lg-erro-hora-aux = yes.     
             end.
        
         if   lg-erro-hora-aux
         then do:
                assign lg-relat-erro = yes.
                run pi-cria-tt-erros ("Campo hora de realizacao da tab. de proced. invalido.").
              end.
        
        /* --------------------------------------- TESTA PERIODO DO MOVIMENTO --- */
        if (import-movto-proced.dt-anoref = ? or import-movto-proced.dt-anoref = 0)
        or (import-movto-proced.nr-perref = ? or import-movto-proced.nr-perref = 0)
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros (if (import-movto-proced.dt-anoref = ? or import-movto-proced.dt-anoref = 0)
                                     then "Campo ano do periodo da tab. de proced. deve ser informado"
                                     else "Campo numero do periodo da tab. de proced. deve ser informado.").
             end.
        
        if   import-movto-proced.dt-anoref <> import-docto-revis-ctas.dt-anoref
        or   import-movto-proced.nr-perref <> import-docto-revis-ctas.nr-perref
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Chave primaria do periodo da tab.temporaria difere da tabela documento.").
             end.
        
        /* ---------------------------------------------- TESTA VIA DE ACESSO --- */
        if   import-movto-proced.cd-via-acesso = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo via de acesso da tab. de proced. invalido.").
             end.
        
        /* ---------------------------------------- TESTA PORTE ANESTESICO/COB --- */
        if import-movto-proced.cd-porte-anestesico     = ?
        or import-movto-proced.cd-porte-anestesico-cob = ?
        then run pi-cria-tt-erros ("Campo porte anestesico da tab. de proced. invalido.").
        
        if  import-movto-proced.cd-porte-anestesico     <> ?
        and import-movto-proced.cd-porte-anestesico-cob <> ?
        then do:
               find portanes where portanes.cd-porte-anestesico = import-movto-proced.cd-porte-anestesico no-lock no-error.
               if   not available portanes
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Porte anestesico da tab. de proced. nao cadastrado.").
                    end.
        
               find portanes where portanes.cd-porte-anestesico = import-movto-proced.cd-porte-anestesico-cob no-lock no-error.
               if   not available portanes
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Porte anestesico cob. da tab. de proced. nao cadastrado.").
                    end.
             end.
        
        /* ------------------------------------------------ TESTA ANESTESISTA --- */
        if   import-movto-proced.log-ane = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo anestesista da tab. de proced. invalido.").
             end.
        
        /* ----------------------------------------- TESTA NIVEL DO PRESTADOR --- */
        if   import-movto-proced.idi-niv-prestdor = ?
        or   import-movto-proced.idi-niv-prestdor < 1
        or   import-movto-proced.idi-niv-prestdor > 3
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo nivel do prestador da tab. de proced. deve conter 1 , 2 ou 3.").
             end.
        
        /* -------------------------------------- CONSISTE DADOS DO PRESTADOR --- */
        if   import-movto-proced.cd-unidade-prestador = 0
        or   import-movto-proced.cd-unidade-prestador = ?
        or   import-movto-proced.cd-prestador         = 0
        or   import-movto-proced.cd-prestador         = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo unidade e prestador executante da tab. de proced. invalidos.").
             end.
        else do:
               /* -------------------------------- PESQUISA PRESTADOR NA BASE --- */
               find preserv where preserv.cd-unidade   = import-movto-proced.cd-unidade-prestador
                              and preserv.cd-prestador = import-movto-proced.cd-prestador
                                  no-lock no-error.
        
               if   not available preserv
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Codigo do prestador da tab. de proced. nao cadastrado").
                    end.
             end.
        
        /* ----------------------------------------------------- CLINICA --- */
        if  import-movto-proced.cd-clinica <> 0                                       
        then do:                                                               
               find clinicas where clinicas.cd-clinica = import-movto-proced.cd-clinica no-lock no-error.                             
               if not avail clinicas                                           
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Clinica da tab. de proced. nao cadastrada"). 
                    end.
               else do:
                      find clinpres where clinpres.cd-clinica   = import-movto-proced.cd-clinica
                                      and clinpres.cd-unidade   = import-movto-proced.cd-unidade-prestador
                                      and clinpres.cd-prestador = import-movto-proced.cd-prestador
                                      no-lock no-error.
                      if not avail clinpres
                      then do:
                             assign lg-relat-erro = yes.
                             run pi-cria-tt-erros ("Prestador da tab. de proced. nao cadastrado nesta clinica").            
                           end.
                    end.
             end.                                                              
        
        /* ---------------------------- TESTA URGENCIA E ADCIONAL DE URGENCIA --- */
        if import-movto-proced.log-urgen = ?
        or import-movto-proced.log-adc-urgen = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros (if import-movto-proced.log-urgen = ?
                                     then "Campo urgencia da tab. de proced. invalido."
                                     else "Campo adicional de urgencia da tab. de proced. invalido.").
             end.

        /* --------------------------------------------- SETA TRABALHO MEDICO --- */
        find tipovinc where tipovinc.cd-tipo-vinculo = import-movto-proced.cd-tipo-vinculo no-lock no-error.
        if   not available tipovinc
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Tipo de Vinculo da tab. de proced. nao cadastrado").
             end.

        /* ---------------------------------------------- PRESTADOR PAGAMENTO --- */
        if import-movto-proced.cd-unidade-prestador <> paramecp.cd-unimed
        then do:
               find unimed where unimed.cd-unimed = import-movto-proced.cd-unidade-prestador no-lock no-error.
               if   not avail unimed
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Unidade do prestador da tab. de proced. nao cadastrada.").
                    end.
               else do:
                      find tip-uni where tip-uni.cd-tipo-unimed = unimed.cd-tipo-unimed no-lock no-error.
                      if   not avail tip-uni
                      then do:
                             assign lg-relat-erro = yes.
                             run pi-cria-tt-erros ("Tipo de unidade da tab. de proced. nao cadastrada.").
                           end.
                      else do:
                             /* ------------- CONSISTE INDICADOR UNIDADE PADRAO: SIM --- */
                             if   tip-uni.lg-descons-exp-bene
                             then do:
                                    find first b-preserv use-index preserv3 
                                         where b-preserv.cd-unidade = import-movto-proced.cd-unidade-prestador
                                           and b-preserv.lg-representa-unidade = yes
                                               no-lock no-error.
                                    if not available b-preserv
                                    then do:
                                           assign lg-relat-erro = yes.
                                           run pi-cria-tt-erros ("Prestador que representa a unidade da tab. de proced. nao cadastrado.").
                                         end.
                                  end.
                             else do:
                                    /* ----------- LOCALIZA PRESTADOR QUE REPRESENTA UNIDADE --- */
                                    find b-preserv where b-preserv.cd-unidade   = import-movto-proced.cd-unidade-prestador
                                                     and b-preserv.cd-prestador = import-movto-proced.cd-prestador
                                                     and b-preserv.lg-representa-unidade = yes
                                                        no-lock no-error.
                                    if not available b-preserv
                                    then do:
                                           /* --- LOCALIZA PRIMEIRO PREST. QUE REPRES. UNIDADE --- */
                                           find first b-preserv use-index preserv3 
                                                where b-preserv.cd-unidade = import-movto-proced.cd-unidade-prestador
                                                  and b-preserv.lg-representa-unidade = yes
                                                      no-lock no-error.
                                           if not available b-preserv
                                           then do:
                                                  assign lg-relat-erro = yes.
                                                  run pi-cria-tt-erros ("Prestador que representa a unidade da tab. de proced. nao cadastrado.").
                                                end.
                                         end.
                                  end.
                           end.
                    end.
             end.

        /* ------------------------------------ PESQUISA PROCEDIMENTO NA BASE --- */
        find ambproce where ambproce.cd-esp-amb        = import-movto-proced.cd-esp-amb
                        and ambproce.cd-grupo-proc-amb = import-movto-proced.cd-grupo-proc-amb
                        and ambproce.cd-procedimento   = import-movto-proced.cd-procedimento
                        and ambproce.dv-procedimento   = import-movto-proced.idi-dv-proced
                            no-lock no-error.
        
        if   not available ambproce
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Procedimento nao cadastrado." 
                                   + string(import-movto-proced.cd-esp-amb,"99") 
                                   + string(import-movto-proced.cd-grupo-proc-amb,"99")
                                   + string(import-movto-proced.cd-procedimento,"999")
                                   + string(import-movto-proced.idi-dv-proced,"9")).
             end.
        
        if lg-relat-erro = no
        then run grava-cons-dados.

    end.

end procedure.

procedure grava-cons-dados: 

   def var lg-restringe-aux                      as logical                no-undo.
   def var cd-modulo-aut                       like mod-cob.cd-modulo      no-undo.
   def var cd-uni-aux                          like preserv.cd-unidade     no-undo. 
   def var cd-prest-aux                        like preserv.cd-prestador   no-undo.
   def var cd-vinculo-aux                      like previesp.cd-vinculo    no-undo.
   def var cd-especialid-aux                   like previesp.cd-especialid no-undo.
   def var in-tipo-fatura-aux                    as integer                no-undo.

   /* ---------------------- INICIALIZA VARIAVEIS PARA GLOSAR MOVIMENTOS --- */
   assign nr-processo-hdp      = import-movto-proced.nr-processo
          nr-seq-digitacao-hdp = import-movto-proced.nr-seq-digitacao
          ds-compl-aux         = "" 
          ds-chave-aux         = ""
          lg-calc-tx-int-aux   = yes.

   ASSIGN import-movto-proced.cd-modalidade = cd-modalidade-aux
          import-movto-proced.nr-ter-adesao = nr-ter-adesao-aux
          import-movto-proced.cd-usuario    = cd-usuario-aux.
 
   /* ----------------------------------- INDICADORES DE LIBERACAO DO RC --- */
   assign import-movto-proced.ind-liberd-ctas           = "0"
          import-movto-proced.ind-liberd-faturam        = "0"
          import-movto-proced.ind-liberd-pagto          = "0"
          import-movto-proced.in-liberado-refaturamento = "0".
   
   /* ----------------------------------------- SETA PRESTADOR PAGAMENTO --- */
   if   import-movto-proced.cd-unidade-prestador = paramecp.cd-unimed
   then do:
          /* ----------------- LOGICA DO PRESTADOR DE PAGTO ATRAVES DA CLINICA ---*/
          assign import-movto-proced.cd-unidade-pagamento    = import-movto-proced.cd-unidade-prestador
                 import-movto-proced.cd-prestador-pagamento  = import-movto-proced.cd-prestador.
         
          if tranrevi.in-tipo-pagamento = 1   
          and not import-movto-proced.log-div-honor
          then do:                                                              
                 find clinicas where clinicas.cd-clinica = import-docto-revis-ctas.cd-clinica no-lock no-error.                                         
                 if   available clinicas                                        
                 then assign import-movto-proced.cd-unidade-pagamento   = clinica.cd-unidade-prestador  
                             import-movto-proced.cd-prestador-pagamento = clinica.cd-prestador.                                                       
               end.                                                             
        end.
   else do:
          find tip-uni where tip-uni.cd-tipo-unimed = unimed.cd-tipo-unimed no-lock no-error.

          /* ------------- CONSISTE INDICADOR UNIDADE PADRAO: SIM --- */
          if   tip-uni.lg-descons-exp-bene
          then do:
                 find first b-preserv use-index preserv3 
                      where b-preserv.cd-unidade = import-movto-proced.cd-unidade-prestador
                        and b-preserv.lg-representa-unidade = yes
                            no-lock no-error.
                 if   available b-preserv
                 then assign import-movto-proced.cd-unidade-pagamento   = b-preserv.cd-unidade
                             import-movto-proced.cd-prestador-pagamento = b-preserv.cd-prestador.
               end.
          else do:
                 /* ----------- LOCALIZA PRESTADOR QUE REPRESENTA UNIDADE --- */
                 find b-preserv where b-preserv.cd-unidade   = import-movto-proced.cd-unidade-prestador
                                  and b-preserv.cd-prestador = import-movto-proced.cd-prestador
                                  and b-preserv.lg-representa-unidade = yes
                                     no-lock no-error.
                 if   available b-preserv
                 then assign import-movto-proced.cd-unidade-pagamento   = b-preserv.cd-unidade
                             import-movto-proced.cd-prestador-pagamento = b-preserv.cd-prestador.

                 else do:
                        /* --- LOCALIZA PRIMEIRO PREST. QUE REPRES. UNIDADE --- */
                        find first b-preserv use-index preserv3 
                             where b-preserv.cd-unidade = import-movto-proced.cd-unidade-prestador
                               and b-preserv.lg-representa-unidade = yes
                                   no-lock no-error.
                        if   available b-preserv
                        then assign import-movto-proced.cd-unidade-pagamento   = b-preserv.cd-unidade
                                    import-movto-proced.cd-prestador-pagamento = b-preserv.cd-prestador.
                      end.
               end.
        end.

   /* -------------------------- VERIFICA VINCULOS DO PRESTADOR RTAPI024 --- */
   assign in-funcao-rtapi024-aux     = "GDT"
          lg-erro-rtapi024-aux       = no
          lg-prim-mens-rtapi024-aux  = no
          cd-unidade-rtapi024-aux    = import-movto-proced.cd-unidade-prestador
          cd-prestador-rtapi024-aux  = import-movto-proced.cd-prestador
          cd-transacao-rtapi024-aux  = import-movto-proced.cd-transacao
          in-vinculo-rtapi024-aux    = "E"
          dt-realizacao-rtapi024-aux = import-movto-proced.dt-realizacao.
 
   run rtp/rtapi024.p no-error.
 
   if   error-status:error
   then do:
          assign lg-relat-erro = yes.
          run pi-cria-tt-erros(substring(error-status:get-message(error-status:num-messages),1,75)).
        end.
 
   for each tmp-mensa-rtapi024:
       assign lg-relat-erro = yes.
       run pi-cria-tt-erros(tmp-mensa-rtapi024.ds-mensagem-mens).
   end.

   /* ----------- ATRIBUI DADOS INERENTES A TIPO DE VINCULO DO PRESTADOR --- */
   if   import-movto-proced.cd-tipo-vinculo = 0
   then do:
          find first tmp-rtapi024 no-error.
          if   available tmp-rtapi024
          then assign import-movto-proced.cd-tipo-vinculo = tmp-rtapi024.cd-vinculo.
        end.
   else do:
          find first tmp-rtapi024 where tmp-rtapi024.cd-vinculo = import-movto-proced.cd-tipo-vinculo no-error.
          if   not available tmp-rtapi024
          then do:
                 find first tmp-rtapi024 no-error.
                 if   avail tmp-rtapi024
                 then assign import-movto-proced.cd-tipo-vinculo = tmp-rtapi024.cd-vinculo.
                 else do:           
                        assign lg-relat-erro = yes.
                        run pi-cria-tt-erros("Vinculo da tab. de proced. nao cadastrado para prestador. Unid.: " + string(import-movto-proced.cd-unidade-prestador,"9999") +
                                             " Prest.: " + string(import-movto-proced.cd-prestador,"99999999") +
                                             " Vinc.: "  + string(import-movto-proced.cd-tipo-vinculo,"99")).
                      end.
               end.
        end.
 
   assign import-movto-proced.log-trab-cooper = tipovinc.lg-trabalho.
 
   /* --------------------- VERIFICA ESPECIALIDADE DO PRESTADOR RTAPI023 --- */
   assign in-funcao-rtapi023-aux         = "GDT"
          lg-erro-rtapi023-aux           = no
          lg-prim-mens-rtapi023-aux      = no
          cd-unidade-rtapi023-aux        = import-movto-proced.cd-unidade-prestador
          cd-prestador-rtapi023-aux      = import-movto-proced.cd-prestador
          cd-tipo-vinc-rtapi023-aux      = import-movto-proced.cd-tipo-vinculo
          in-tipo-prestador-rtapi023-aux = "E"
          in-tipo-consist-rtapi023-aux   = "TRANSACAO"
          cd-tipo-guia-rtapi023-aux      = 0
          cd-transacao-rtapi023-aux      = import-movto-proced.cd-transacao
          dt-realizacao-rtapi023-aux     = import-movto-proced.dt-realizacao.
 
   run rtp/rtapi023.p no-error.
 
   if   error-status:error
   then do:
          assign lg-relat-erro = yes.
          run pi-cria-tt-erros(substring(error-status:get-message(error-status:num-messages),1,75)).
        end.
 
   for each tmp-mensa-rtapi023:
       assign lg-relat-erro = yes.
       run pi-cria-tt-erros(tmp-mensa-rtapi023.ds-mensagem-mens).
   end.
 
   /* ------------- ATRIBUI DADOS INERENTES A ESPECIALIDADE DO PRESTADOR --- */
   if   import-movto-proced.cd-esp-prest-executante = 0
   OR   import-movto-proced.cd-esp-prest-executante = ?
   then do:
          find first tmp-rtapi023 no-error.
          if   available tmp-rtapi023
          then assign import-movto-proced.cd-esp-prest-executante = tmp-rtapi023.cd-especialid.
          ELSE DO:
                 ds-msg-aux = "Nao foi encontrada especialidade para Unidade: ".

                 IF import-movto-proced.cd-unidade-prestador <> ?
                 THEN ds-msg-aux = ds-msg-aux + string(import-movto-proced.cd-unidade-prestador).
                 ELSE ds-msg-aux = ds-msg-aux + "nulo".

                 ds-msg-aux = ds-msg-aux + ", Prestador: ".

                 IF import-movto-proced.cd-prestador <> ?
                 THEN ds-msg-aux = ds-msg-aux + STRING(import-movto-proced.cd-prestador).
                 ELSE ds-msg-aux = ds-msg-aux + "nulo".

                 ds-msg-aux = ds-msg-aux + ", Vinculo: ".

                 IF import-movto-proced.cd-tipo-vinculo <> ?
                 THEN ds-msg-aux = ds-msg-aux + STRING(import-movto-proced.cd-tipo-vinculo).
                 ELSE ds-msg-aux = ds-msg-aux + "nulo".

                 RUN pi-cria-tt-erros(ds-msg-aux).
                 assign lg-relat-erro = yes.
               END.
        end.
   else do:
          find first tmp-rtapi023 where tmp-rtapi023.cd-especialid = import-movto-proced.cd-esp-prest-executante no-error.
          if   not available tmp-rtapi023
          then do:
                 assign lg-relat-erro = yes.
                 run pi-cria-tt-erros ("Especialidade " + 
                                       STRING(import-movto-proced.cd-esp-prest-executante) + 
                                       " da tab. de proced. nao cadastrada para prestador " + 
                                       string(import-movto-proced.cd-unidade-prestador) + "/" +
                                       string(import-movto-proced.cd-prestador) +
                                       " e vinculo " + STRING(import-movto-proced.cd-tipo-vinculo)).
               end.
        end.
 
   assign import-movto-proced.cd-tipo-medicina = modalid.cd-tipo-medicina.
   
   /* ------------------------------------ VERIFICA HORARIOS DE URGENCIA --- */
   run rtp/rthorurg.p (input  IF AVAIL tranrevi THEN tranrevi.in-trata-urgencia ELSE 0,
                       input  preserv.cd-tab-urge,
                       input  import-movto-proced.dt-realizacao,
                       input  import-movto-proced.hr-realizacao,
                       input  import-movto-proced.cd-tab-preco-proc,
                       input  import-docto-revis-ctas.cd-local-atendimento,
                       input  import-movto-proced.cd-unidade-prestador,
                       input  import-movto-proced.cd-prestador,
                       input  "PAG",
                       input  import-docto-revis-ctas.cd-unidade-carteira,
                       input  import-docto-revis-ctas.cd-carteira-usuario,
                       output lg-urgencia-aux).

   /* ------------------------------------ URGENCIA E ADICIONAL URGENCIA --- */
   run seta-urgencia (input "PAG",
                      input lg-urgencia-aux).
   
   /* ------------------------------ VERIFICA HORARIOS DE URGENCIA PAGTO --- */
   run rtp/rthorurg.p (input  IF AVAIL tranrevi THEN tranrevi.in-trata-urgencia ELSE 0,
                       input  preserv.cd-tab-urge,
                       input  import-movto-proced.dt-realizacao,
                       input  import-movto-proced.hr-realizacao,
                       input  import-movto-proced.cd-tab-preco-proc-cob,
                       input  import-docto-revis-ctas.cd-local-atendimento,
                       input  import-movto-proced.cd-unidade-prestador,
                       input  import-movto-proced.cd-prestador,
                       input  "COB",
                       input  import-docto-revis-ctas.cd-unidade-carteira,
                       input  import-docto-revis-ctas.cd-carteira-usuario,
                       output lg-urgencia-cob-aux).

   /* ------------------------------------ URGENCIA E ADICIONAL URGENCIA --- */
   run seta-urgencia (input "COB",
                      input lg-urgencia-cob-aux).

   if   import-movto-proced.cd-porte-anestesico = 0
   and  import-movto-proced.log-ane
   then assign import-movto-proced.cd-porte-anestesico = taprampr.cd-porte-anestesico.

end procedure.


/* ------------------------------------------------------------------------------------------- */
procedure cons-dados-insumo:   

    /* --- Insumo --------------------------------------------------------------------------- */
    for each import-movto-insumo                                          
       where import-movto-insumo.val-seqcial-docto = import-docto-revis-ctas.val-seqcial EXCLUSIVE-LOCK:

        /* --------------------------------- CONSISTE UNIDADE DO PROCEDIMENTO --- */
        if   import-movto-insumo.cd-unidade = 0
        or   import-movto-insumo.cd-unidade = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo unidade da tab. de insumo invalido.").
             end.
        else do:
               find unimed where unimed.cd-unimed = import-movto-insumo.cd-unidade no-lock no-error.
        
               if   not available unimed
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Unidade da tab. de insumo nao cadastrada.").
                    end.

               /* --------------------------------- CONSISTE UNIDADE PARAMECP --- */
               if   paramecp.cd-unimed <> import-movto-insumo.cd-unidade
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Unidade da tab. de insumo deve ser igual a dos parametros.").
                    end.
             end.
        
        /* ----------------------------------------------- UNIDADE PRESTADORA --- */
        if   import-movto-insumo.cd-unidade-prestadora = ?
        or   import-movto-insumo.cd-unidade-prestadora = 0
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo unidade prestadora da tab. de insumo deve ser informada.").
             end.

        /* -------------------------------------------------------- TRANSACAO --- */
        if   import-movto-insumo.cd-transacao = ?
        or   import-movto-insumo.cd-transacao = 0
        then do: 
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo transacao da tab. de insumo invalido.").
             end.

        /* ---------------------------------------------- NUMERO DO DOCUMENTO --- */
        if   import-movto-insumo.nr-doc-original = ?
        or   import-movto-insumo.nr-doc-original = 0
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo Nr.doc original da tab. de insumo deve ser informado.").
             end.
        
        /* ------------------------------------------------ NUMERO DE SISTEMA --- */
        if   import-movto-insumo.nr-doc-sistema = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo Nr.doc.sistema da tab. de insumo invalido.").
             end.
        
        /* ----------------------------------------------- NUMERO DO PROCESSO --- */
        if   import-movto-insumo.nr-processo = ?
        or   import-movto-insumo.nr-processo = 0
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo numero do processo da tab. de insumo invalido.").
             end.
        
        /* -------------------------- CONSISTE CHAVE DA TEMP DE PROCEDIMENTOS --- */
        /* ---------------------------------------- COM CHAVE DA TEMP DA GUIA --- */
        if   import-movto-insumo.cd-unidade            <> import-docto-revis-ctas.cd-unidade
        or   import-movto-insumo.cd-unidade-prestadora <> import-docto-revis-ctas.cd-unidade-prestadora
        or   import-movto-insumo.cd-transacao          <> import-docto-revis-ctas.cd-transacao
        or   import-movto-insumo.nr-serie-doc-original <> import-docto-revis-ctas.nr-serie-doc-original
        or   import-movto-insumo.nr-doc-original       <> import-docto-revis-ctas.nr-doc-original
        or   import-movto-insumo.nr-doc-sistema        <> import-docto-revis-ctas.nr-doc-sistema
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Chave primaria da tab. de insumo difere com tabela do documento.").
             end.
        
        /* -------------------------------------------- TESTA PRESTADOR UNICO --- */
        if AVAIL tranrevi
        AND  tranrevi.lg-prestador-unico
        and ((string(import-movto-insumo.cd-unidade-prestador,"9999") + string(import-movto-insumo.cd-prestador,"99999999")) <>  
             (string(import-docto-revis-ctas.cd-unidade-principal,"9999") + string(import-docto-revis-ctas.cd-prestador-principal,"99999999")))
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Transacao da tab. de insumo so aceita prestador unico.").
             end.
        
        /* --------------------- TESTA DATA E HORA DA REALIZACAO DO MOVIMENTO --- */
        if   import-movto-insumo.dt-realizacao = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo data da realizacao da tab. de insumo invalido.").
             end.
        
        if   import-movto-insumo.hr-realizacao = ""
        or   import-movto-insumo.hr-realizacao = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo hora de realizacao da tab. de insumo invalido.").
             end.
        
        lg-erro-hora-aux = no.
        
        assign nr-hora-aux = int(substring(import-movto-insumo.hr-realizacao,1,2)) no-error.
        
        if   error-status:error
        then assign lg-erro-hora-aux = yes.
        
        assign nr-minutos-aux = int(substring(import-movto-insumo.hr-realizacao,4,2)) no-error.
        
        if   error-status:error
        then assign lg-erro-hora-aux = yes.
        
        if   (nr-hora-aux    < 0 or nr-hora-aux    > 23)
        or   (nr-minutos-aux < 0 or nr-minutos-aux > 59)
        then assign lg-erro-hora-aux = yes.
        
        if   lg-erro-hora-aux
        then do:
               assign lg-erro-hora-aux = no.                                                   
        
               assign nr-hora-aux = int(substring(import-movto-insumo.hr-realizacao,1,2)) no-error.   
        
               if   error-status:error                                                         
               then assign lg-erro-hora-aux = yes.                                             
        
               assign nr-minutos-aux = int(substring(import-movto-insumo.hr-realizacao,3,2)) no-error.
        
               if   error-status:error                                                         
               then assign lg-erro-hora-aux = yes.     
            
             end.
        
        if   lg-erro-hora-aux
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo hora de realizacao da tab. de insumo invalido.").
             end.
        
        /* --------------------------------------- TESTA PERIODO DO MOVIMENTO --- */
        if   import-movto-insumo.dt-anoref = ?
        or   import-movto-insumo.dt-anoref = 0
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo ano do periodo da tab. de insumo deve ser informado").
             end.
        
        if   import-movto-insumo.nr-perref = ?
        or   import-movto-insumo.nr-perref = 0
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo numero do periodo da tab. de insumo deve ser informado.").
             end.
        
        if   import-movto-insumo.dt-anoref <> import-docto-revis-ctas.dt-anoref
        or   import-movto-insumo.nr-perref <> import-docto-revis-ctas.nr-perref
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Chave primaria do periodo da tab. de insumo difere da tabela documento.").
             end.
        
        /* -------------------------------------- CONSISTE DADOS DO PRESTADOR --- */
        if   import-movto-insumo.cd-unidade-prestador = 0
        or   import-movto-insumo.cd-unidade-prestador = ?
        or   import-movto-insumo.cd-prestador         = 0
        or   import-movto-insumo.cd-prestador         = ?
        then do:
               assign lg-relat-erro = yes.
               run pi-cria-tt-erros ("Campo unidade e prestador executante da tab. de insumo invalidos.").
             end.
        else do:
               /* -------------------------------- PESQUISA PRESTADOR NA BASE --- */
               find preserv where preserv.cd-unidade   = import-movto-insumo.cd-unidade-prestador
                              and preserv.cd-prestador = import-movto-insumo.cd-prestador
                                  no-lock no-error.
        
               if   not available preserv
               then do:
                      assign lg-relat-erro = yes.
                      run pi-cria-tt-erros ("Codigo do prestador da tab. de insumo nao cadastrado").
                    end.
             end.

    end.

end procedure.

/* --------------------------------------- URGENCIA E ADICIONAL URGENCIA --- */
/* --------------------------------------- URGENCIA E ADICIONAL URGENCIA --- */
procedure seta-urgencia:

    define input parameter in-tipo-pagto-par as char format "x(3)" no-undo.
    define input parameter lg-urgencia-par as log                  no-undo.

    IF AVAIL tranrevi
    THEN DO:
           if   in-tipo-pagto-par = "PAG"
           then do:
                  case tranrevi.in-trata-urgencia:
                      when 2 or 
                      when 3
                      then assign import-movto-proced.log-adc-urgen = lg-urgencia-par
                                  import-movto-proced.log-urgen    = lg-urgencia-par.
                      when 5 or 
                      when 6
                      then assign import-movto-proced.log-adc-urgen = import-movto-proced.log-urgen.
                         
                      otherwise assign import-movto-proced.log-adc-urgen = no
                                       import-movto-proced.log-urgen     = no.
                  end case.
                end.
           else do:
                  case tranrevi.in-trata-urgencia:
                      when 1 or 
                      when 3 
                      then assign import-movto-proced.log-livre-1 = lg-urgencia-par.
                      
                      when 4 or 
                      when 6 
                      then assign import-movto-proced.log-livre-1 = import-movto-proced.log-urgen.
                      
                      otherwise assign import-movto-proced.log-livre-1 = no.
                  end case.
                end.
         END.
    
end procedure.


/* ------------------------------------------------------------------------------------- */     
/* ------------------------------------------------------------------------- */
procedure mostra-erro.

    FOR EACH tt-erro NO-LOCK:
        disp tt-erro.nr-seq-contr          
             tt-erro.nom-tab-orig-erro  
             tt-erro.des-erro             
             with frame f-rel.  
        down with frame f-rel.

    END.
 
end procedure.

/* ------------------------------------------------------------------------------------------- */
PROCEDURE pi-cria-tt-erros:

    DEF INPUT PARAM ds-erro-par AS CHAR NO-UNDO.
    
    DEF VAR num-seq-aux AS INT NO-UNDO.

    FOR LAST b-tt-erro FIELDS (nr-seq) 
       WHERE b-tt-erro.nr-seq-contr = import-docto-revis-ctas.num-seqcial-control NO-LOCK:
    END.

    CREATE tt-erro.

    IF AVAIL b-tt-erro
    THEN ASSIGN num-seq-aux = b-tt-erro.nr-seq + 1.
    ELSE ASSIGN num-seq-aux = 1.

    ASSIGN tt-erro.nr-seq            = num-seq-aux
           tt-erro.nr-seq-contr      = import-docto-revis-ctas.num-seqcial-control
           tt-erro.nom-tab-orig-erro = "DC - import-docto-revis-ctas"
           tt-erro.des-erro          = ds-erro-par. 

END PROCEDURE.

procedure pi-grava-erro:

    ASSIGN nro-seq-aux = 0.

    FOR EACH tt-erro FIELDS(nr-seq-contr nom-tab-orig-erro des-erro) EXCLUSIVE-LOCK
        BREAK BY tt-erro.nr-seq-contr:

        RUN p-log("@@@@@ gravando erro (pi-grava-erro cg0310z1").

        IF nro-seq-aux = 0
        THEN do:
               IF CAN-FIND (FIRST erro-process-import WHERE erro-process-import.num-seqcial-control = tt-erro.nr-seq-contr)
               THEN RUN pi-consulta-prox-seq (INPUT tt-erro.nr-seq-contr, OUTPUT nro-seq-aux).
               ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.
             END.
        ELSE ASSIGN nro-seq-aux = nro-seq-aux + 1.

        /**
         * Garantir unicidade da chave.
         */
        create erro-process-import.
        REPEAT:
        assign erro-process-import.num-seqcial         = nro-seq-aux
                 erro-process-import.num-seqcial-control = tt-erro.nr-seq-contr NO-ERROR.
          VALIDATE erro-process-import NO-ERROR.
          IF ERROR-STATUS:ERROR
          OR ERROR-STATUS:NUM-MESSAGES > 0
          THEN do:
                 ASSIGN nro-seq-aux = nro-seq-aux + 1.
                 /*PAUSE(1).*/
               END.
          ELSE LEAVE.
        END.

        ASSIGN erro-process-import.nom-tab-orig-erro   = tt-erro.nom-tab-orig-erro
               erro-process-import.des-erro            = tt-erro.des-erro
               erro-process-import.dat-erro            = today. 

        FOR FIRST control-migrac FIELDS (ind-sit-import)
            WHERE control-migrac.num-seqcial = tt-erro.nr-seq-contr EXCLUSIVE-LOCK:
        END.
        if avail control-migrac
        then assign control-migrac.ind-sit-import = "PE".

        FOR FIRST b-import-docto-revis-ctas FIELDS (ind-sit-import) 
            WHERE b-import-docto-revis-ctas.num-seqcial-control = erro-process-import.num-seqcial-control EXCLUSIVE-LOCK:
        END.
        IF AVAIL b-import-docto-revis-ctas
        THEN DO:        
               ASSIGN b-import-docto-revis-ctas.ind-sit-import = "PE".
               
               RELEASE  b-import-docto-revis-ctas.
               VALIDATE b-import-docto-revis-ctas.
             END.

        DELETE tt-erro.
    END.

end procedure.

procedure pi-consulta-prox-seq:

    def input  parameter nr-seq-contr-p like erro-process-import.num-seqcial-control no-undo.
    def output parameter nro-seq-par    as int initial 0                             no-undo.

    def buffer b-erro-process-import for erro-process-import.

    select max(erro-process-import.num-seqcial) into nro-seq-par 
           from erro-process-import 
           where erro-process-import.num-seqcial-control = nr-seq-contr-p.

    if nro-seq-par = ?
    then assign nro-seq-par = 1.
    else assign nro-seq-par = nro-seq-par + 1.

end procedure.

PROCEDURE p-log:
    DEF INPUT PARAM ds-texto-par AS CHAR NO-UNDO.
END PROCEDURE.
