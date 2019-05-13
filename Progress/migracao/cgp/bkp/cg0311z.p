
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CG0311Z 2.00.00.027 } /*** 010027 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i cg0311z MCG}
&ENDIF

/****************************-**************************************************
*      Programa .....: cg0311z.p                                              *
*      Data .........: 22 de Janeiro de 2015                                  *
*      Autor ........: TOTVS                                                  *
*      Sistema ......: CG - Manutencao de cadastro                            *
*      Programador ..: Jaine Marin                                            *
*      Objetivo .....: Importacao de Dados - Movimentos                       *
*******************************************************************************
*      VERSAO    DATA        RESPONSAVEL       MOTIVO                         *
*      C.00.000  22/010/15   Jaine Marin       Desenvolvimento                *
******************************************************************************/ 
{hdp/hdsistem.i}

{srincl/srespecr.iv}

def var c-versao as char no-undo.
c-versao = "7.13.000".
{hdp/hdlog.i}

/* --- DECLARACAO DE VARIAVEIS UTILIZADAS POR HDRUNPERSIS E HDDELPERSIS --- */
{hdp/hdrunpersis.iv "new"}
 
def var lg-relat-erro             as logical                     no-undo.
def var lg-retorno                as logical                     no-undo.
def var lg-erro-aux               as log                         no-undo.

def buffer b-import-docto-revis-ctas for import-docto-revis-ctas.

DEF SHARED TEMP-TABLE tt-erro NO-UNDO
    FIELD nr-seq            AS INT
    FIELD nr-seq-contr      LIKE erro-process-import.num-seqcial-control 
    FIELD nom-tab-orig-erro AS CHAR
    FIELD des-erro          AS CHAR
    INDEX nr-seq       
          nr-seq-contr.

DEF SHARED TEMP-TABLE tt-import-docto-revis-ctas NO-UNDO
    FIELD rowid-import-docto-revis-ctas AS ROWID
    INDEX id rowid-import-docto-revis-ctas.

/* ------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------- */
procedure cria-registros:

    RUN p-log("@@@@@entrando em cria-registros(cg0311z)").

    for each tt-import-docto-revis-ctas exclusive-lock,

        first b-import-docto-revis-ctas where rowid (b-import-docto-revis-ctas) = tt-import-docto-revis-ctas.rowid-import-docto-revis-ctas exclusive-lock:
    
        l-inclusao-dados:
        do on error undo, retry:

            RUN p-log("@@@@@antes de cria-documentos(cria-registros cg0311z)").

            run cria-documentos.
            run cria-movimentos.

            assign b-import-docto-revis-ctas.ind-sit-import = "IT".
                   
            release  b-import-docto-revis-ctas.
            validate b-import-docto-revis-ctas.
            
            delete tt-import-docto-revis-ctas.
    
        end.
    end.

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure cria-documentos:

    l-inclusao:
    do on error undo, retry:
    
       /* ------------------------------------------------------------ */
       /* ----------------------------------------- Cria registros --- */
       create docrecon.
       buffer-copy b-import-docto-revis-ctas to docrecon.
    
       assign docrecon.lg-periodo-unico      = b-import-docto-revis-ctas.log-period-unico
              docrecon.lg-estorno            = b-import-docto-revis-ctas.log-estorn
              docrecon.lg-prestador-unico    = b-import-docto-revis-ctas.log-prestdor-unico
              docrecon.lg-modulo-unico       = b-import-docto-revis-ctas.log-modul-unico
              docrecon.ds-observacao         = b-import-docto-revis-ctas.des-observacao
              docrecon.lg-guia               = b-import-docto-revis-ctas.log-guia
              docrecon.ds-motivo-cancel      = b-import-docto-revis-ctas.des-motiv-cancel
              docrecon.lg-libera-faturamento = b-import-docto-revis-ctas.log-libera-faturam
              docrecon.nm-prof-sol           = b-import-docto-revis-ctas.nom-profis-solic
              docrecon.ds-ind-clinica        = b-import-docto-revis-ctas.des-indcao-clinic
              docrecon.tp-doenca             = b-import-docto-revis-ctas.ind-tempo-doenc
              docrecon.cr-solicitacao        = b-import-docto-revis-ctas.ind-carac-solicit
              docrecon.cr-internacao         = b-import-docto-revis-ctas.ind-carac-intrcao
              docrecon.lg-gestacao           = b-import-docto-revis-ctas.log-gestac
              docrecon.lg-aborto             = b-import-docto-revis-ctas.log-aborto
              docrecon.lg-tran-mat-rel-grav  = b-import-docto-revis-ctas.log-transt-materno-gestac
              docrecon.lg-comp-per-puer      = b-import-docto-revis-ctas.log-complic-period-puerp   
              docrecon.lg-aten-rn-sala-prt   = b-import-docto-revis-ctas.log-atendim-rn-sala-parto
              docrecon.lg-comp-neonatal      = b-import-docto-revis-ctas.log-complic-neonat
              docrecon.lg-baixo-peso         = b-import-docto-revis-ctas.log-bxo-peso
              docrecon.lg-parto-cesario      = b-import-docto-revis-ctas.log-parto-cesar
              docrecon.nm-decl-nasc-viv      = b-import-docto-revis-ctas.nom-decla-nasc-vivo             
              docrecon.qt-nasc-vivos-termo   = b-import-docto-revis-ctas.qti-nasc-vivo-termo         
              docrecon.qt-nasc-mortos        = b-import-docto-revis-ctas.qti-nasc-morto         
              docrecon.qt-nasc-vivos-prem    = b-import-docto-revis-ctas.qti-nasc-vivo-premat
              docrecon.nm-decl-obt           = b-import-docto-revis-ctas.num-decla-obit
              docrecon.nm-decl-nasc-viv2     = b-import-docto-revis-ctas.cod-decla-nasc-vivo-2               
              docrecon.nm-decl-nasc-viv3     = b-import-docto-revis-ctas.cod-decla-nasc-vivo-3           
              docrecon.nm-decl-nasc-viv4     = b-import-docto-revis-ctas.cod-decla-nasc-vivo-4           
              docrecon.nm-decl-nasc-viv5     = b-import-docto-revis-ctas.cod-decla-nasc-vivo-5
              docrecon.cd-userid             = "MIGRACAO".
     
    end.  /* l-inclusao */ 

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure cria-movimentos:

    for each import-movto-proced 
       where import-movto-proced.val-seqcial-docto = b-import-docto-revis-ctas.val-seqcial no-lock:
    
        create moviproc.
        buffer-copy import-movto-proced except qt-cobrado to moviproc.
        
        assign moviproc.cd-userid                 = "MIGRACAO"
               moviproc.dv-procedimento           = import-movto-proced.idi-dv-proced
               moviproc.lg-anestesista            = import-movto-proced.log-ane
               moviproc.lg-trab-cooperado         = import-movto-proced.log-trab-cooper
               moviproc.in-nivel-prestador        = import-movto-proced.idi-niv-prestdor  
               moviproc.lg-urgencia               = import-movto-proced.log-urgen
               moviproc.lg-adicional-urgencia     = import-movto-proced.log-adc-urgen
               moviproc.ds-observacao             = import-movto-proced.des-observacao
               moviproc.in-liberado-contas        = import-movto-proced.ind-liberd-ctas     
               moviproc.in-liberado-faturamento   = import-movto-proced.ind-liberd-faturam     
               moviproc.in-liberado-pagto         = import-movto-proced.ind-liberd-pagto
               moviproc.parcela-pp                = import-movto-proced.num-parcela
               moviproc.nm-montagem-valores       = import-movto-proced.des-mont-valores
               moviproc.in-tipo-reconsulta        = import-movto-proced.idi-tip-recons
               moviproc.lg-rotina-externa         = import-movto-proced.log-rot-ext
               moviproc.lg-cobrado-participacao   = import-movto-proced.log-cobrad-particip
               moviproc.lg-recalcula-fat          = import-movto-proced.log-recalc-faturam
               moviproc.ds-justificativa          = import-movto-proced.des-justificativa
               moviproc.in-entidade               = import-movto-proced.ind-entidade
               moviproc.lg-sem-cobertura          = import-movto-proced.log-sem-cobert
               moviproc.in-cobra-participacao     = import-movto-proced.idi-cobr-particip
               moviproc.in-tipo-nascimento        = import-movto-proced.idi-tip-nasc
               moviproc.lg-divisao-honorario      = import-movto-proced.log-div-honor
               moviproc.in-resultado-divisao      = import-movto-proced.ind-restdo-div
               moviproc.hh-liberacao              = import-movto-proced.hra-liber
               moviproc.nm-prestador-valid        = import-movto-proced.nom-prestdor-valid 
               moviproc.in-proc-princ             = import-movto-proced.log-proced-princ
               moviproc.id-face-dente             = import-movto-proced.ind-face-dente
               moviproc.in-liberado-contas        = "1"
               moviproc.in-liberado-faturamento   = "1"
               moviproc.in-liberado-pagto         = "1"
               moviproc.in-liberado-refaturamento = "1"
               moviproc.log-11                    = import-movto-proced.log-livre-1
               moviproc.qt-cobrado                = int(import-movto-proced.qt-cobrado).

        for each import-movto-glosa 
           where import-movto-glosa.val-seq-guia      = import-movto-proced.val-seqcial-docto
             and import-movto-glosa.val-seqcial-movto = import-movto-proced.val-seqcial
             and import-movto-glosa.in-modulo         = "RC" no-lock:

            create movrcglo.
            assign movrcglo.cd-unidade              = moviproc.cd-unidade            
                   movrcglo.cd-unidade-prestadora   = moviproc.cd-unidade-prestadora 
                   movrcglo.cd-transacao            = moviproc.cd-transacao          
                   movrcglo.nr-serie-doc-original   = moviproc.nr-serie-doc-original 
                   movrcglo.nr-doc-original         = moviproc.nr-doc-original       
                   movrcglo.nr-doc-sistema          = moviproc.nr-doc-sistema        
                   movrcglo.nr-processo             = moviproc.nr-processo           
                   movrcglo.nr-seq-digitacao        = moviproc.nr-seq-digitacao
                   movrcglo.in-origem-glosa         = import-movto-glosa.in-origem-glosa
                   movrcglo.cd-cod-glo              = import-movto-glosa.cd-cod-glo             
                   movrcglo.cd-classe-erro          = import-movto-glosa.cd-classe-erro         
                   movrcglo.ds-motivo-glosa         = import-movto-glosa.des-motiv-glosa        
                   movrcglo.qti-quant-proced-dispon = import-movto-glosa.qti-quant-proced-dispon.
        end.
    end.
    
    for each import-movto-insumo                                          
       where import-movto-insumo.val-seqcial-docto = b-import-docto-revis-ctas.val-seqcial no-lock:
    
        create mov-insu.
        buffer-copy import-movto-insumo to mov-insu.
    
        assign mov-insu.cd-userid                 = "MIGRACAO"
               mov-insu.lg-preco-padrao           = import-movto-insumo.log-preco-padr
               mov-insu.ds-observacao             = import-movto-insumo.des-observacao
               mov-insu.in-liberado-contas        = import-movto-insumo.ind-liberd-ctas        
               mov-insu.in-liberado-faturamento   = import-movto-insumo.ind-liberd-faturam          
               mov-insu.in-liberado-pagto         = import-movto-insumo.ind-liberd-pagto
               mov-insu.in-liberado-refaturamento = import-movto-insumo.ind-liberd-refatur
               mov-insu.parcela-pp                = import-movto-insumo.num-parc-ppp
               mov-insu.nm-montagem-valores       = import-movto-insumo.des-mont-valores
               mov-insu.lg-glosa-individual       = import-movto-insumo.log-glosa-indual
               mov-insu.lg-cobrado-participacao   = import-movto-insumo.log-cobr-particip
               mov-insu.lg-recalcula-fat          = import-movto-insumo.log-recalc-faturam
               mov-insu.ds-justificativa          = import-movto-insumo.des-justif
               mov-insu.in-entidade               = import-movto-insumo.ind-entidade
               mov-insu.lg-rotina-externa         = import-movto-insumo.log-rot-ext
               mov-insu.lg-sem-cobertura          = import-movto-insumo.log-sem-cobert
               mov-insu.in-cobra-participacao     = import-movto-insumo.idi-cobr-particip
               mov-insu.hh-liberacao              = import-movto-insumo.hra-liber
               mov-insu.tp-dente-regiao           = import-movto-insumo.ind-dente-regiao
               mov-insu.id-face-dente             = import-movto-insumo.ind-face-dente
               mov-insu.in-liberado-contas        = "1"
               mov-insu.in-liberado-faturamento   = "1"
               mov-insu.in-liberado-pagto         = "1"
               mov-insu.in-liberado-refaturamento = "1".

        for each import-movto-glosa 
           where import-movto-glosa.val-seq-guia      = import-movto-insumo.val-seqcial-docto
             and import-movto-glosa.val-seqcial-movto = import-movto-insumo.val-seqcial
             and import-movto-glosa.in-modulo         = "RC" no-lock:

            create movrcglo.
            assign movrcglo.cd-unidade              = mov-insu.cd-unidade            
                   movrcglo.cd-unidade-prestadora   = mov-insu.cd-unidade-prestadora 
                   movrcglo.cd-transacao            = mov-insu.cd-transacao          
                   movrcglo.nr-serie-doc-original   = mov-insu.nr-serie-doc-original 
                   movrcglo.nr-doc-original         = mov-insu.nr-doc-original       
                   movrcglo.nr-doc-sistema          = mov-insu.nr-doc-sistema        
                   movrcglo.nr-processo             = mov-insu.nr-processo           
                   movrcglo.nr-seq-digitacao        = mov-insu.nr-seq-digitacao
                   movrcglo.in-origem-glosa         = import-movto-glosa.in-origem-glosa
                   movrcglo.cd-cod-glo              = import-movto-glosa.cd-cod-glo             
                   movrcglo.cd-classe-erro          = import-movto-glosa.cd-classe-erro         
                   movrcglo.ds-motivo-glosa         = import-movto-glosa.des-motiv-glosa        
                   movrcglo.qti-quant-proced-dispon = import-movto-glosa.qti-quant-proced-dispon.
        end.

    end.

end procedure.

PROCEDURE p-log:
    DEF INPUT PARAM ds-mensagem-par AS CHAR NO-UNDO.
END PROCEDURE.

return.
/* ------------------------------------------------------------------------- */
/* ----------------------------------------------- FIM DOS PROCEDIMENTOS --- */
/* ------------------------------------------------------------------------- */
