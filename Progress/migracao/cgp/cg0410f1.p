/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CG0410F 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i cg0410f MSP}
&ENDIF

/******************************************************************************
    Programa .....: 
    Data .........: 28/08/2015
    Empresa ......: TOTVS Saude
    Programador ..: Mauricio Faoro 
    Objetivo .....: Migracao de faturas
*******************************************************************************/
hide all no-pause.
{hdp/hdvarregua.i}
{hdp/hdregparexec.i}
{hdp/hdregparexec.f}

def input param in-batch-online-par          AS CHAR NO-UNDO.
DEF INPUT PARAM in-status-monitorar-par      AS CHAR NO-UNDO.
DEF INPUT PARAM cd-evento-default-par        AS char NO-UNDO.

def var cd-evento-aux                  like evenfatu.cd-evento         no-undo. 
def new shared var cd-evento-z         like evenfatu.cd-evento         no-undo.
def new shared var ds-evento-z         like evenfatu.ds-evento         no-undo.
def new shared var  cd-retorno         as log                          no-undo.
def new shared var  in-entidade-aux    like evenfatu.in-entidade       no-undo.
def            var  lg-parametro-aux   as log                          no-undo. 
def            var  qt-registros       as int                          no-undo. 
def            var  percent-concluido  as dec format ">>9,99"          no-undo.
def            var  percent-erros      as dec format ">>>>>>>9.99"          no-undo.
def buffer b-migrac-fatur for migrac-fatur. 
DEF BUFFER b-fatura       FOR fatura. 

cd-evento-aux = int(cd-evento-default-par).

if in-batch-online-par = "ONLINE"
THEN DO:
        /* -------------------------------FRAMES------------------------------------- */
        def frame f-parametros 
            cd-evento-aux   label "Evento para Importacao Faturas"
                            view-as fill-in size 4 by 1.3
            evenfatu.ds-evento no-label
                            view-as fill-in size 41 by 1.3
           with centered side-labels overlay three-d title "Parametros". 
        
        def frame f-acompanhamento 
            qt-registros label "Quantidade de Registros"
                               view-as fill-in size 10 by 1.3
            percent-concluido label "% Importado" 
                              view-as fill-in size 6 by 1.3
            percent-erros     label "% Erros"
                              view-as fill-in size 6 by 1.3
            with centered side-labels overlay three-d title "Acompanhamento". 
END.
        
/* -------------------------------------------------------------------------- */
{hdp/hdvrcab0.i}
assign nm-cab-usuario = "Migracao de Faturas".
       nm-prog        = " cg0410f ".
       c-versao       = c_prg_vrs.
       {hdp/hdlog.i}

{hdp/hdtitrel.i}

assign lg-btn-executa   = yes
       in-entidade-aux  = 'FT'
       lg-parametro-aux = no.

IF in-batch-online-par = "BATCH"
then do:
       run executa-processo (input cd-evento-aux).
end.
else do:
        /* -------------------------------------------------------------------------- */
        repeat on endkey undo, retry:
        
             hide frame f-parametros.
        
            hide message no-pause.
            {hdp/hdbotparexec.i}
        
            case c-opcao:
                when "Parametro"
                then do on error undo, retry with frame f-parametros:
                        
                        update cd-evento-aux auto-return
                         HELP "F5 para Zoom"
                         {fpp/fp0310b.i}
                         if   cd-evento-z <> ?
                         and  cd-retorno
                         then display cd-evento-z @ cd-evento-aux. end. 
        
                         find evenfatu where evenfatu.in-entidade = "FT"
                                         and evenfatu.cd-evento   = cd-evento-aux no-lock no-error. 
        
                         if avail evenfatu
                         then disp evenfatu.ds-evento. 
                         else do:
                                 message "Evento nao cadastrado!"
                                 view-as alert-box title "Atencao !!!".
                              end.
                        hide frame f-parametros.
                        assign lg-parametro-aux = yes.
                     end.
        
                when "Executa"
                then do:
                        if not lg-parametro-aux
                        then do:
                                 message "Acessar primeiro os parametros"
                                 view-as alert-box title "Atencao !!!".
                                 
                             end.
                        else do:
                                run executa-processo (input cd-evento-aux) .
                                message "Processo concluido."
                                         view-as alert-box title "Atencao !!!".
                             end.
                     end.
        
                when "Fim"
                then do:
                        hide all no-pause.
                        leave.
                     end.
            end case.
        end.
end.
            
procedure executa-processo:
    def input parameter cd-evento-par   as integer            no-undo. 
    def var   nr-fatura-aux             as integer            no-undo. 
    def var   nr-sequencia-aux          as integer            no-undo.
    def var   qt-lidos-aux              as int                no-undo. 
    DEF VAR lg-erro-jm-aux              AS LOG                NO-UNDO. 
    
    
    find first parafatu no-lock no-error. 
    
    find evenfatu where evenfatu.in-entidade = "FT"
                    and evenfatu.cd-evento   = cd-evento-par
                  no-lock no-error.
    
    select count(*) into qt-registros from migrac-fatur  where migrac-fatur.cod-livre-1 = in-status-monitorar-par.

    assign percent-concluido = 0
           qt-lidos-aux      = 0.

    disp qt-registros                                    
         percent-concluido                               
          with frame f-acompanhamento.      

    for each migrac-fatur where migrac-fatur.cod-livre-1 = in-status-monitorar-par no-lock
                          break by migrac-fatur.aa-referencia
                                by migrac-fatur.num-mm-refer:

        process events. 

        if not avail evenfatu
        then do:
               run grava-erro(input "Evento " + string(cd-evento-par) + " nao cadastrado (EVENFATU).").
               next.
        end.
    
        assign qt-lidos-aux = qt-lidos-aux + 1.

        if qt-lidos-aux > 500
        then do:
                 disp qt-registros
                      ((percent-concluido / qt-registros) * 1000) @ percent-concluido
                      ((percent-erros / qt-registros) * 1000) @ percent-erros
                      with frame f-acompanhamento.
                 process events. 
                 assign qt-lidos-aux = 0. 
             end.

        for first propost  fields (propost.ep-codigo
                                   propost.cod-estabel
                                   propost.cd-modalidade
                                   propost.nr-ter-adesao
                                   propost.nr-proposta)
                           where propost.cd-modalidade   = migrac-fatur.cd-modalidade
                            and propost.nr-ter-adesao   = migrac-fatur.nr-ter-adesao no-lock: end.

        if not avail propost 
        then do:
                run grava-erro(input "contrato nao cadastrado").
                next. 
             end.


        for first tit_acr fields (tit_acr.cdn_cliente)
                          where tit_acr.cod_estab       = propost.cod-estabel
                            and tit_acr.cod_espec_docto = migrac-fatur.cd-especie
                            and tit_acr.cod_ser_docto   = migrac-fatur.serie
                            and tit_acr.cod_tit_acr     = migrac-fatur.nr-titulo-acr 
                            and (   tit_acr.cod_parcela = string(migrac-fatur.parcela) 
                                 or tit_acr.cod_parcela = "") no-lock: end.

        if not avail tit_acr
        then do:
                /*if migrac-fatur.parcela = 0
                then for first tit_acr where tit_acr.cod_estab       = propost.cod-estabel
                                         and tit_acr.cod_espec_docto = migrac-fatur.cd-especie
                                         and tit_acr.cod_ser_docto   = migrac-fatur.serie
                                         and tit_acr.cod_tit_acr     = migrac-fatur.nr-titulo-acr no-lock: end.

                if not avail tit_acr
                then do:*/
                        run grava-erro(input "titulo nao cadastrado").
                        next. 
                    /* end.*/
             end.

        /*se NUM-LIVRE-1 estiver preenchido, a fatura ja foi criada anteriormente pelo migrador e esta sendo reprocessada.
		 *nesse caso, reutilizar o mesmo numero*/
        if  migrac-fatur.num-livre-1 <> ?
		and migrac-fatur.num-livre-1 <> 0
		then do:
		       assign nr-fatura-aux = migrac-fatur.num-livre-1.
		end.
		else do:
				/***********************BUSCA NUMERO FATURA **************************************/
				run rtp/rtnrfat.p(input  migrac-fatur.cd-modalidade,
								  input  tit_acr.cdn_cliente,
								  output nr-fatura-aux).
        end.
			
		find first fatura where fatura.cd-contratante = tit_acr.cdn_cliente
							and fatura.nr-fatura      = nr-fatura-aux
						  no-lock no-error. 
	
		do while avail fatura:
		   nr-fatura-aux = nr-fatura-aux + 1.
		   find first fatura where fatura.cd-contratante = tit_acr.cdn_cliente
							   and fatura.nr-fatura      = nr-fatura-aux no-lock no-error. 
		end.
		
        do transaction:
           create fatura.
           assign fatura.cd-contratante            = tit_acr.cdn_cliente
                  fatura.nr-fatura                 = nr-fatura-aux
                  fatura.aa-referencia             = migrac-fatur.aa-referencia  
                  fatura.mm-referencia             = migrac-fatur.num-mm-refer   
                  fatura.ep-codigo                 = propost.ep-codigo
                  fatura.cod-estabel               = propost.cod-estabel
                  fatura.cd-modalidade             = propost.cd-modalidade
                  fatura.cd-especie                = migrac-fatur.cd-especie
                  fatura.serie                     = migrac-fatur.serie
                  fatura.ds-mensagem               = "FATURA MIGRADA DO UNICOO"
                  fatura.portador                  = migrac-fatur.portador
                  fatura.modalidade                = migrac-fatur.modalidade
                  fatura.ct-codigo                 = ""
                  fatura.sc-codigo                 = ""
                  fatura.nr-titulo-acr             = migrac-fatur.nr-titulo-acr 
                  fatura.parcela                   = migrac-fatur.parcela
                  fatura.dt-emissao                = migrac-fatur.dt-emissao
                  fatura.dt-vencimento             = migrac-fatur.dt-vencimento
                  fatura.cd-tipo-vencimento        = 0
                  fatura.cd-sit-fatu               = 30
                  fatura.mo-codigo                 = 0
                  fatura.vl-total                  = migrac-fatur.vl-total 
                  fatura.in-tipo-fatura            = 3
                  fatura.cd-userid                 = "migracao"
                  fatura.dt-atualizacao            = today
                  fatura.date-3                    = today
                  fatura.lg-contabilizado          = yes.

           ASSIGN lg-erro-jm-aux = NO. 

           FOR EACH migrac-fatur-juros WHERE migrac-fatur-juros.cdd-seq-tab-pai = migrac-fatur.cdd-seq NO-LOCK:

               for first tit_acr where tit_acr.cod_estab       = propost.cod-estabel
                                    and tit_acr.cod_espec_docto = migrac-fatur-juros.cd-especie
                                    and tit_acr.cod_ser_docto   = migrac-fatur-juros.serie
                                    and tit_acr.cod_tit_acr     = migrac-fatur-juros.nr-titulo-acr 
                                   /* and (   tit_acr.cod_parcela = string(migrac-fatur-juros.parcela) 
                                         or tit_acr.cod_parcela = "")*/
                                          no-lock: end.

               IF NOT AVAIL tit_acr
               THEN DO:
                       run grava-erro(input "titulo juros/multa nao cadastrado").
                       ASSIGN lg-erro-jm-aux = YES. 
                       next. 
                    END.

               FOR each b-fatura WHERE b-fatura.aa-referencia  = migrac-fatur-juros.aa-referencia
                                   AND b-fatura.mm-referencia  = migrac-fatur-juros.num-mm-refer
                                   AND b-fatura.cd-contratante = fatura.cd-contratante
                                   AND b-fatura.nr-titulo-acr  = migrac-fatur-juros.nr-titulo-acr NO-LOCK, 
                   first notaserv where notaserv.cd-contratante = b-fatura.cd-contratante
                                    and notaserv.nr-fatura      = b-fatura.nr-fatura
                                    and notaserv.cd-modalidade  = migrac-fatur.cd-modalidade
                                    and notaserv.nr-ter-adesao  = migrac-fatur.nr-ter-adesao no-lock: leave. END.

                IF NOT AVAIL b-fatura
                THEN DO:
                       /*disp 'erro' migrac-fatur-juros.nr-titulo-acr  migrac-fatur-juros.aa-referencia  migrac-fatur-juros.num-mm-refer.*/
                         run grava-erro(input "fatura juros/multa nao cadastrado").
                        ASSIGN lg-erro-jm-aux = YES. 
                        next. 
                     END.

               for first fatur-juros-multa where fatur-juros-multa.cd-contratante     = fatura.cd-contratante 
                                             and fatur-juros-multa.num-fatur          = b-fatura.nr-fatura
                                             and fatur-juros-multa.num-fatur-relacdo  = fatura.nr-fatura no-lock: end.

               if avail fatur-juros-multa
               then do:
                        run grava-erro(input "J/M jah cad." + string(fatura.cd-contratante) + "-" 
                                                            + string(b-fatura.nr-fatura)    + "-"
                                                            + string(fatura.nr-fatura) ).
                        next.
                    end.

               CREATE fatur-juros-multa.
               assign fatur-juros-multa.cd-contratante    = fatura.cd-contratante
                      fatur-juros-multa.num-fatur         = b-fatura.nr-fatura
                      fatur-juros-multa.num-fatur-relacdo = fatura.nr-fatura
                      fatur-juros-multa.dat-inic          = migrac-fatur-juros.dat-livre-1
                      fatur-juros-multa.dat-fim           = migrac-fatur-juros.dat-livre-2
                      fatur-juros-multa.val-juros         = migrac-fatur-juros.val-juros 
                      fatur-juros-multa.val-multa         = migrac-fatur-juros.val-multa.

               IF tit_acr.dat_ult_liquidac < fatur-juros-multa.dat-fim
               THEN ASSIGN fatur-juros-multa.dat-livre-1 = tit_acr.dat_ult_liquidac.
               ELSE ASSIGN fatur-juros-multa.dat-livre-1 = fatur-juros-multa.dat-fim.

               if  tit_acr.val_sdo_tit_acr = 0
               and tit_acr.dat_ult_liquidac < fatur-juros-multa.dat-fim
               then do:
                       find current b-fatura exclusive-lock no-error. 
                       if avail b-fatura
                       then assign b-fatura.log-15 = yes. 
                    end.
           END.

           IF lg-erro-jm-aux 
           then undo, NEXT.

           find last notaserv 
               where notaserv.cd-modalidade         = propost.cd-modalidade    
                 and notaserv.cd-contratante        = fatura.cd-contratante    
                 and notaserv.cd-contratante-origem = 0                        
                 and notaserv.nr-ter-adesao         = migrac-fatur.nr-ter-adesao   
                 and notaserv.aa-referencia         = migrac-fatur.aa-referencia       
                 and notaserv.mm-referencia         = migrac-fatur.num-mm-refer        
                 no-lock no-error.
           
           if not available notaserv
           then nr-sequencia-aux = 1.
           else nr-sequencia-aux = notaserv.nr-sequencia + 1.
    
           create notaserv.
           assign notaserv.cd-modalidade         = propost.cd-modalidade
                  notaserv.cd-contratante        = fatura.cd-contratante
                  notaserv.cd-contratante-origem = 0
                  notaserv.nr-ter-adesao         = migrac-fatur.nr-ter-adesao 
                  notaserv.cd-especie            = migrac-fatur.cd-especie
                  notaserv.aa-referencia         = migrac-fatur.aa-referencia
                  notaserv.mm-referencia         = migrac-fatur.num-mm-refer
                  notaserv.nr-sequencia          = nr-sequencia-aux
                  notaserv.ep-codigo             = fatura.ep-codigo
                  notaserv.cod-estabel           = fatura.cod-estabel
                  notaserv.dt-emissao            = fatura.dt-emissao 
                  notaserv.dt-vencimento         = fatura.dt-vencimento
                  notaserv.mo-codigo             = 0
                  notaserv.vl-total              = fatura.vl-total
                  notaserv.nr-fatura             = fatura.nr-fatura
                  notaserv.lg-contabilizada      = yes
                  notaserv.cd-userid             = "migracao"
                  notaserv.dt-atualizacao        = today
                  notaserv.date-1                = today.

    
           create fatueven.
           assign fatueven.cd-modalidade         = notaserv.cd-modalidade    
                  fatueven.nr-sequencia          = notaserv.nr-sequencia     
                  fatueven.nr-ter-adesao         = notaserv.nr-ter-adesao    
                  fatueven.aa-referencia         = notaserv.aa-referencia    
                  fatueven.mm-referencia         = notaserv.mm-referencia    
                  fatueven.cd-evento             = cd-evento-par
                  fatueven.qt-evento             = 1
                  fatueven.vl-evento             = fatura.vl-total
                  fatueven.lg-cred-deb           = yes
                  fatueven.lg-destacado          = no
                  fatueven.lg-modulo             = no
                  fatueven.ct-codigo             = ""
                  fatueven.sc-codigo             = ""
                  fatueven.qt-evento-ref         = 0
                  fatueven.vl-evento-ref         = 0
                  fatueven.cd-tipo-cob           = 0
                  fatueven.cd-contratante        = notaserv.cd-contratante       
                  fatueven.cd-contratante-origem = notaserv.cd-contratante-origem
                  fatueven.cd-userid             = "migracao"
                  fatueven.dt-atualizacao        = today.

           release fatura.
           release notaserv.
           release fatueven.
           release fatur-juros-multa. 
                                      
           find b-migrac-fatur where rowid(b-migrac-fatur) = rowid(migrac-fatur)
                                     exclusive-lock no-error. 

           if avail b-migrac-fatur 
           then assign b-migrac-fatur.cod-livre-1 = 'IT'
		               b-migrac-fatur.num-livre-1 = nr-fatura-aux
                       percent-concluido          = percent-concluido + 1. 

           /* ATUALIZAR ULTIMO FATURAMENTO NO TERMO, BENEFICIARIO E USUMODU */
           FOR EACH ter-ade EXCLUSIVE-LOCK
                WHERE ter-ade.cd-modalidade = migrac-fatur.cd-modalidade
                  AND ter-ade.nr-ter-adesao = migrac-fatur.nr-ter-adesao:

               IF migrac-fatur.aa-referencia > ter-ade.aa-ult-fat
               OR(migrac-fatur.aa-referencia = ter-ade.aa-ult-fat AND migrac-fatur.num-mm-refer > ter-ade.mm-ult-fat)
               THEN DO:
                       ASSIGN ter-ade.aa-ult-fat = migrac-fatur.aa-referencia
                              ter-ade.mm-ult-fat = migrac-fatur.num-mm-refer.
        
                       FOR EACH usuario EXCLUSIVE-LOCK
                          WHERE usuario.cd-modalidade = ter-ade.cd-modalidade
                            AND usuario.nr-ter-adesao = ter-ade.nr-ter-adesao:
        
                           ASSIGN usuario.aa-ult-fat                = migrac-fatur.aa-referencia 
                                  usuario.mm-ult-fat                = migrac-fatur.num-mm-refer. 
        
                           FOR EACH usumodu EXCLUSIVE-LOCK
                              WHERE usumodu.cd-modalidade = usuario.cd-modalidade
                                AND usumodu.nr-proposta   = usuario.nr-proposta
                                AND usumodu.cd-usuario    = usuario.cd-usuario:
        
                               ASSIGN usumodu.aa-ult-fat         = migrac-fatur.aa-referencia 
                                      usumodu.mm-ult-fat         = migrac-fatur.num-mm-refer.
                           END.
                       END.
               END.
           END.

        end. /* do transaction */
    end.
end procedure. 

procedure grava-erro:
    def input parameter ds-mensagem-par as char no-undo. 


    find b-migrac-fatur where rowid(b-migrac-fatur) = rowid(migrac-fatur)
                                     exclusive-lock no-error. 

    if avail b-migrac-fatur 
    then assign b-migrac-fatur.cod-livre-1 = "PE"
                b-migrac-fatur.cod-livre-2 = ds-mensagem-par
                percent-erros              = percent-erros + 1. 
end procedure. 
