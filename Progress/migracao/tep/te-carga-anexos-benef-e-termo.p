/**
 * OBJETIVO: ler ANEXO-BNFCIAR e ANEXO-PROPOSTA (que foram carregados no PL/SQL (P_MIGRA_OCORRENCIAS_TERMO_BENEF) e realizar upload dos
 *           respectivos anexos, atravez da BOSAUATTACHMENT.P
 * ERROS SERAO GRAVADOS EM C:\TEMP\ERROS-TE-CARGA-ANEXOS-BENEFICIARIO.CSV e c:\temp\erros-te-carga-anexos-termo.csv.
 *
 * OBS: VISTO QUE O METODO UPLOADFILE DA BOSAUATTACHMENT CRIA NOVO REGISTRO NA TABELA ANEXO, NO RETORNO DO METODO ESSE PROCESSO
 *      VAI TROCAR O RELACIONAMENTO E ELIMINAR O REGISTRO DA TABELA ANEXO CRIADO VAZIO PREVIAMENTE NO PL/SQL.
 */
 
/**
 * PARAMETRO DE ENTRADA: PASTA ONDE SE ENCONTRAM OS ARQUIVOS PARA UPLOAD.
 */
DEF VAR in-param-aux AS CHAR NO-UNDO.
ASSIGN  in-param-aux = session:param.

DEF VAR lg-erro-aux AS LOG INIT NO NO-UNDO.

DEF VAR h-bosauattachment-aux AS HANDLE NO-UNDO.

DEF VAR ds-dir-anexos-aux AS CHAR NO-UNDO. /*diretorio onde devem estar os arquivos a serem carregados*/
ASSIGN ds-dir-anexos-aux = entry(1, in-param-aux).

file-info:file-name = ds-dir-anexos-aux.

if not file-info:file-type = "DRW"
then do:
        message "Diretorio nao existe." skip
                "Ou nao pode ser utilizado no modo Leitura/Escrita."
                view-as alert-box title " Atencao !!! ".
        RETURN.
     end.

{rtp/rtrowerror.i}
{bosau/global/bosauattachment.i}

DEF VAR id-anexo-aux AS INT  NO-UNDO.
DEF VAR return-aux   AS CHAR NO-UNDO.

{hdp/hdrunpersis.iv "new"}
{hdp/hdrunpersis.i "bosau/global/bosauattachment.p" "h-bosauattachment-aux"}

ETIME(TRUE).

DISP '.'.

OUTPUT TO c:\temp\erros-te-carga-anexos-beneficiario.csv.
FOR EACH anexo-bnfciar EXCLUSIVE-LOCK
    
    /*TESTE!!!!!!!!!!!!!!!!!!*/
/*    WHERE anexo-bnfciar.cdd-anexo = 355488*/
    ,
    FIRST anexo EXCLUSIVE-LOCK WHERE anexo.cdd-anexo = anexo-bnfciar.cdd-anexo:

    IF anexo-bnfciar.log-livre-5 THEN NEXT. /* JA MIGRADOS */

    PROCESS EVENTS.

    MESSAGE "upload anexos " STRING(ds-dir-anexos-aux + '/' + anexo.nom-anexo).
    
    run uploadFile in h-bosauattachment-aux (input STRING(ds-dir-anexos-aux + '/' + anexo.nom-anexo),
                                             input 1, /* 1-BENEFICIARIO; 2-TERMO DE ADESAO */
                                             INPUT anexo.cdn-tip-anexo, /* tipo-anexo */
                                             input 'MIGRACAO',
                                             output id-anexo-aux,
                                             output return-aux,
                                             input-output table rowErrors).

    if containsAnyError(input table rowErrors)
    then do:
           lg-erro-aux = YES.
           for each rowErrors:
               PUT UNFORMATTED "Erro ao incluir anexo BENEFICIARIO(MODALIDADE/TERMO/USUARIO);"
                               anexo-bnfciar.cdn-modalid  "/"
                               anexo-bnfciar.num-propost  "/"
                               anexo-bnfciar.cdn-usuar    ";"
                               rowErrors.errorDescription ";"
                               rowErrors.errorParameters  ";"
                               return-aux SKIP.
           end.
         end.
    else do:
           /**
            * ATUALIZAR RELACIONAMENTO COM TABELA ANEXO E ELIMINAR REGISTRO ANTIGO.
            */
           assign anexo-bnfciar.cdd-anexo = id-anexo-aux
                  anexo-bnfciar.log-livre-5 = TRUE. /* marcar que ja foi migrado */           
           DELETE anexo.
         end.
END.
OUTPUT CLOSE.


OUTPUT TO c:\temp\erros-te-carga-anexos-termo.csv.
FOR EACH anexo-propost EXCLUSIVE-LOCK
    
    /*TESTE!!!!!!!!!!!!!!!!!!!!*/
/*    WHERE anexo-propost.cdd-anexo = 162490*/
    ,

    FIRST anexo EXCLUSIVE-LOCK WHERE anexo.cdd-anexo = anexo-propost.cdd-anexo:

    IF anexo-propost.log-livre-5 THEN NEXT. /* JA MIGRADOS */

    PROCESS EVENTS.

    MESSAGE "upload anexos " STRING(ds-dir-anexos-aux + '/' + anexo.nom-anexo).
    
    run uploadFile in h-bosauattachment-aux (input STRING(ds-dir-anexos-aux + '/' + anexo.nom-anexo),
                                             input 2, /* 1-BENEFICIARIO; 2-TERMO DE ADESAO */
                                             INPUT anexo.cdn-tip-anexo, /* tipo-anexo */
                                             input 'MIGRACAO',
                                             output id-anexo-aux,
                                             output return-aux,
                                             input-output table rowErrors).

    if containsAnyError(input table rowErrors)
    then do:
           lg-erro-aux = YES.
           for each rowErrors:
               PUT UNFORMATTED "Erro ao incluir anexo TERMO(MODALIDADE/TERMO);" 
                               anexo-propost.cdn-modalid  "/"
                               anexo-propost.num-propost  ";"
                               rowErrors.errorDescription ";"
                               rowErrors.errorParameters  ";"
                               return-aux SKIP.
           end.
         end.
    else do:
           /**
            * ATUALIZAR RELACIONAMENTO COM TABELA ANEXO E ELIMINAR REGISTRO ANTIGO.
            */
           assign anexo-propost.cdd-anexo = id-anexo-aux
                  anexo-propost.log-livre-5 = TRUE. /* marcar que ja foi migrado */
           
           DELETE anexo.
         end.
END.
OUTPUT CLOSE.


{hdp/hddelpersis.i}

IF lg-erro-aux
THEN DO:
       MESSAGE "Ocorreram erros. Verifique relatorios." SKIP
           "Tempo decorrido (segundos): " ETIME / 1000
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
     END.
ELSE DO:
       MESSAGE "Encerrado com sucesso." SKIP
           "Tempo decorrido (segundos): " ETIME / 1000
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
     END.
QUIT.
