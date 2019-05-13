DEF VAR ix AS INT INIT 0 no-undo.
DEF VAR int-aux AS INT NO-UNDO.
DEF VAR lg-erro-aux AS LOG INIT NO NO-UNDO.

/*cada campo representa uma coluna da planilha Excel de entrada*/
DEF TEMP-TABLE tmp-evencopp NO-UNDO
    FIELD cd-evento          AS INT  /*A*/
    field cd-grupo-prestador as INT  /*B*/ 
    field in-movto	         as char /*C*/
    field cd-modalidade      as INT  /*D*/
    field cd-plano           as INT  /*E*/
    field cd-tipo-plano      as INT  /*F*/
    field cd-modulo          as INT  /*G*/
    field in-tipo-ato	     as INT  /*H*/
    field mm-aa-validade     as char /*I 12/9999*/
    field ct-codigo          as char /*J*/
    FIELD ds-msg-validacao   AS CHAR /*K - sera preenchida caso a linha possua falha*/
    .

/*MESSAGE "Escolha 'Sim' para importar a tabela EVENCOPP ou 'Nao' para apenas validar a planilha sem alterar a base de dados." SKIP(1)
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE lg-atualiza-aux AS LOG.*/

MESSAGE "Atencao: caso o processo apresente o erro 'Valor alfanumerico em entrada numerica', verifique se o arquivo.csv possui linha de cabecalho."
        "Em caso positivo, elimine essa linha e inicie o processo novamente."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

INPUT FROM c:\temp\evencopp.csv.
REPEAT:
    ix = ix + 1.
    CREATE tmp-evencopp.
    IMPORT DELIMITER ";" tmp-evencopp.

    IF tmp-evencopp.cd-evento <> 0
    AND NOT can-find(FIRST evenfatu where evenfatu.in-entidade = "PP"               
                                      and evenfatu.cd-evento   = tmp-evencopp.cd-evento)
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Evento nao cadastrado em EVENFATU com IN-ENTIDADE = 'PP'|".
         END.

    IF tmp-evencopp.cd-grupo-prestador <> 0
    AND NOT can-find(FIRST gruppres where gruppres.cd-grupo-prestador = tmp-evencopp.cd-grupo-prestador)
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Grupo de Prestador nao cadastrado em GRUPPRES|".
         END.

    IF  tmp-evencopp.in-movto <> "0"
    AND tmp-evencopp.in-movto <> "P"
    AND tmp-evencopp.in-movto <> "I"
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "IN-MOVTO deve ser '0', 'P' ou 'I'|".
         END.

    IF tmp-evencopp.cd-modalidade <> 0
    AND NOT can-find(FIRST modalid where modalid.cd-modalidade = tmp-evencopp.cd-modalidade)
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Modalidade nao cadastrada em MODALID|".
         END.

    IF tmp-evencopp.cd-plano <> 0
    AND NOT can-find(FIRST pla-sau where pla-sau.cd-modalidade = tmp-evencopp.cd-modalidade
                                     AND pla-sau.cd-plano      = tmp-evencopp.cd-plano)
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Plano nao cadastrado em PLA-SAU|".
         END.

    IF tmp-evencopp.cd-tipo-plano <> 0
    AND NOT can-find(FIRST ti-pl-sa where ti-pl-sa.cd-modalidade = tmp-evencopp.cd-modalidade
                                      AND ti-pl-sa.cd-plano      = tmp-evencopp.cd-plano
                                      AND ti-pl-sa.cd-tipo-plano = tmp-evencopp.cd-tipo-plano)
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Tipo de Plano nao cadastrado em TI-PL-SA|".
         END.

    IF tmp-evencopp.cd-modulo <> 0
    AND NOT can-find(FIRST mod-cob where mod-cob.cd-modulo = tmp-evencopp.cd-modulo)
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Modulo nao cadastrado em MOD-COB|".
         END.

    IF  tmp-evencopp.in-tipo-ato <> 0
    AND tmp-evencopp.in-tipo-ato <> 1
    AND tmp-evencopp.in-tipo-ato <> 2
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "IN-TIPO-ATO deve ser 0 (ambos), 1 (Auxiliar) ou 2 (Principal)|".
         END.

    ASSIGN int-aux = int(substring(tmp-evencopp.mm-aa-validade,1,2)) NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Mes de validade invalido. Formato correto: MM/AAAA|".
         END.
    ELSE DO:
           IF int-aux < 1 OR int-aux > 12
           THEN DO:
                  ASSIGN lg-erro-aux = YES
                         tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Mes de validade deve ser entre 1 e 12|".
                END.
         END.

    ASSIGN int-aux = int(substring(tmp-evencopp.mm-aa-validade,4,4)) NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
           ASSIGN lg-erro-aux = YES
                  tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Ano de validade invalido. Formato correto: MM/AAAA|".
         END.
    ELSE DO:
           IF int-aux < 1900
           THEN DO:
                  ASSIGN lg-erro-aux = YES
                         tmp-evencopp.ds-msg-validacao = tmp-evencopp.ds-msg-validacao + "Ano de validade deve ser maior ou igual a 1900|".
                END.
         END.
END.
INPUT CLOSE.

OUTPUT TO c:\temp\acomp-evencopp.csv.
FOR EACH tmp-evencopp WHERE tmp-evencopp.cd-evento <> 0:
    EXPORT DELIMITER ";" tmp-evencopp.
END.
OUTPUT CLOSE.

IF lg-erro-aux
THEN DO:
       MESSAGE "Verifique as falhas no arquivo 'c:/temp/acomp-evencopp.csv'"
           VIEW-AS ALERT-BOX INFO BUTTONS OK.
       RETURN.
     END.

FOR EACH tmp-evencopp WHERE tmp-evencopp.cd-evento <> 0:
    create evencopp.
    assign evencopp.cd-grupo-prestador   = tmp-evencopp.cd-grupo-prestador                            
           evencopp.in-movto             = tmp-evencopp.in-movto                                      
           evencopp.cd-mod-plano-tipo-modulo = string(tmp-evencopp.cd-modalidade,"99") +
                                               string(tmp-evencopp.cd-plano,"99")      +
                                               string(tmp-evencopp.cd-tipo-plano,"99") +
                                               string(tmp-evencopp.cd-modulo,"999")                   
           evencopp.cd-forma-pagto       = 0                                                          
           evencopp.in-tipo-ato          = tmp-evencopp.in-tipo-ato                                   
           evencopp.mm-validade          = int(substring(tmp-evencopp.mm-aa-validade,1,2)) /*12/9999*/
           evencopp.aa-validade          = int(substring(tmp-evencopp.mm-aa-validade,4,4)) /*12/9999*/
           evencopp.ct-codigo            = tmp-evencopp.ct-codigo                                     
           evencopp.sc-codigo            = ""                                                         
           evencopp.cd-evento            = tmp-evencopp.cd-evento
           evencopp.dt-atualizacao       = today                                                      
           evencopp.cd-userid            = "migracao".                                                
END.

MESSAGE "Processo concluido com sucesso."
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
