CREATE OR REPLACE PACKAGE "PCK_MIGRACAO_TXT_GP" IS

  --================--
  --GERA ARQUIVO TXT--
  --===============--
  PROCEDURE P_GERA_PRESTADOR(PZERA_BASE CHAR);

  --=======================================--
  --RODAR APÓS CARGA ARQUIVO DE PRESTADORES--
  --=======================================--
  PROCEDURE POS_CARGA_TXT;
  
  PROCEDURE P_MAQUINA_PRESTADOR;
  
  PROCEDURE P_MIGRA_SERV_ESPEC;
  
  FUNCTION FN_BUSCA_IMPOSTO(PTPIMPOSTO    IN VARCHAR2,
                            PTIPPESSOA    IN CHAR,
                            PCDFORNECEDOR IN EMS5.IMPTO_VINCUL_FORNEC.CDN_FORNECEDOR%TYPE)
    RETURN VARCHAR2;

END;

/
CREATE OR REPLACE PACKAGE BODY "PCK_MIGRACAO_TXT_GP" Is
  --versão 17
  
  --Alex Boeira  (06/03/2019): renomeado mig_CONVERSAO* para MIG_TAB_CONVERSAO* (criadas em UNICOOGPS identico ao original do Unicoo)
  
  PCLSMATER                PARAMETRO.VLPARAMETRO%TYPE;
  PCLSMEDIC                PARAMETRO.VLPARAMETRO%TYPE;
  PCLTAXA                  PARAMETRO.VLPARAMETRO%TYPE;
  PCLASDIA                 PARAMETRO.VLPARAMETRO%TYPE;
  PNRUNIMED                PARAMETRO.VLPARAMETRO%TYPE;
  PCDESPECIALIDADE         PARAMETRO.VLPARAMETRO%TYPE;
  PCATEGSUS                PARAMETRO.VLPARAMETRO%TYPE;
  PPORTADOR                PARAMETRO.VLPARAMETRO%TYPE;
  PBANCO                   PARAMETRO.VLPARAMETRO%TYPE;
  PCDESTADODEFAULT         PARAMETRO.VLPARAMETRO%TYPE;
  PFLUXO_PJ                PARAMETRO.VLPARAMETRO%TYPE;
  PFLUXO_PF                PARAMETRO.VLPARAMETRO%TYPE;
  PCIDADE                  CIDADE.NOCIDADE%TYPE;
  PNOESTADO                CIDADE.CDESTADO%TYPE;
  PNRCEP                   ENDERECO.NRCEP%TYPE;
  PNRENDERECO              PARAMETRO.VLPARAMETRO%TYPE;
  PCDIMPOSTO_UNICOO        PARAMETRO.VLPARAMETRO%TYPE;
  PCDCLAS_IMPTO_UNICOO     PARAMETRO.VLPARAMETRO%TYPE;
  PCDMODALIDADE            PARAMETRO.VLPARAMETRO%TYPE;
  PDESPESA                 PARAMETRO.VLPARAMETRO%TYPE;
  PCDMOTIVO_EXCLUSAO_PREST PARAMETRO.VLPARAMETRO%TYPE;
  pCDMOTIVO_AFASTAMENTO    PARAMETRO.VLPARAMETRO%TYPE;
  pSEPARADOR_ENDERECO_NUMERO PARAMETRO.VLPARAMETRO%TYPE;
  
  vSEP_END_NUMERO_DEFAULT varchar2(2) := ', ';

  vHouveFalha    Varchar2(1);
  VCONT          NUMBER := 0;
  COUNTOFRECORDS NUMBER := 0;
  VAOEXISTECEP   CHAR;
  VAOERRO        CHAR;

  VQTREGISTRO1 NUMBER := 0;
  VQTREGISTRO2 NUMBER := 0;
  VQTREGISTRO3 NUMBER := 0;

  FUNCTION PESQUISANOMEABREV(PNOMEABREV IN VARCHAR2) RETURN NUMBER IS
    VTOTALABREV NUMBER;
  BEGIN
    BEGIN
      SELECT COUNT(*)
        INTO VTOTALABREV
        FROM GP.CONTRAT C
       WHERE C.U##NOME_ABREV = PNOMEABREV;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;
  
    IF VTOTALABREV = 0 THEN
      BEGIN
        SELECT COUNT(*)
          INTO VTOTALABREV
          FROM TEMP_MIGRACAO_CONTRATANTE C
         WHERE C.NOABREVIADO = PNOMEABREV;
      EXCEPTION
        WHEN OTHERS THEN
          NULL;
      END;
    END IF;
  
    RETURN VTOTALABREV;
  END PESQUISANOMEABREV;

  FUNCTION RETORNAENDERECONUMERO(PNOLOGRADOURO IN VARCHAR2,
                                 PNRIMOVEL     IN VARCHAR2) RETURN VARCHAR2 IS
    VTAMANHOLOGRADOURO NUMBER;
  BEGIN
    IF INSTR(PNOLOGRADOURO, PNRIMOVEL) = 0 THEN
      IF (LENGTH(PNOLOGRADOURO) + LENGTH(PNRIMOVEL) + 
      length(nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT))) < 41 THEN
        RETURN PNOLOGRADOURO || nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || PNRIMOVEL;
      ELSE
        -- Busca qual ser¿¿ o tamnho do endereco para que nao ultrapasse
        --o limite de 40 caracteres ao concatenar o numero do imovel
        VTAMANHOLOGRADOURO := LENGTH(PNOLOGRADOURO) -
                              ((LENGTH(PNRIMOVEL) + length(nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT))) -
                               (40 - LENGTH(PNOLOGRADOURO)));
        RETURN SUBSTR(PNOLOGRADOURO, 1, VTAMANHOLOGRADOURO) || nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
         || PNRIMOVEL;
      END IF;
    ELSE
      RETURN PNOLOGRADOURO;
    END IF;
  END RETORNAENDERECONUMERO;

  FUNCTION FN_BUSCA_IMPOSTO(PTPIMPOSTO    IN VARCHAR2,
                            PTIPPESSOA    IN CHAR,
                            PCDFORNECEDOR IN EMS5.IMPTO_VINCUL_FORNEC.CDN_FORNECEDOR%TYPE)
    RETURN VARCHAR2 IS
  
    VCDIMPOSTO EMS5.IMPTO_VINCUL_FORNEC.U##COD_IMPOSTO%TYPE;
    VTPPESSOA  VARCHAR2(2);
  BEGIN
  
    VTPPESSOA := 'P' || PTIPPESSOA;
  
    BEGIN
      SELECT I.U##COD_IMPOSTO
        INTO VCDIMPOSTO
        FROM EMS5.IMPOSTO I, EMS5.IMPTO_VINCUL_FORNEC IVF
       WHERE I.U##COD_UNID_FEDERAC = IVF.U##COD_UNID_FEDERAC
         AND I.U##COD_PAIS = IVF.U##COD_PAIS
         AND I.U##COD_IMPOSTO = IVF.U##COD_IMPOSTO
         AND IVF.CDN_FORNECEDOR = PCDFORNECEDOR
         AND (UPPER(I.DES_IMPOSTO) LIKE '%' || PTPIMPOSTO || '%' OR
             UPPER(I.DES_IMPOSTO) LIKE
             '%' || PTPIMPOSTO || '%' || VTPPESSOA || '%')
         AND ROWNUM = 1
       ORDER BY IVF.PROGRESS_RECID;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VCDIMPOSTO := NULL;
    END;
  
    RETURN VCDIMPOSTO;
  
  END FN_BUSCA_IMPOSTO;

  FUNCTION FN_BUSCA_CLASS_IMPOSTO(PTPIMPOSTO    IN VARCHAR2,
                                  PTIPPESSOA    IN CHAR,
                                  PCDFORNECEDOR IN EMS5.IMPTO_VINCUL_FORNEC.CDN_FORNECEDOR%TYPE)
    RETURN VARCHAR2 IS
  
    VCDCLASS_IMPOSTO EMS5.IMPTO_VINCUL_FORNEC.U##COD_CLASSIF_IMPTO%TYPE;
    VTPPESSOA        VARCHAR2(2);
  BEGIN
  
    VTPPESSOA := 'P' || PTIPPESSOA;
  
    BEGIN
      SELECT IVF.COD_CLASSIF_IMPTO
        INTO VCDCLASS_IMPOSTO
        FROM EMS5.IMPOSTO I, EMS5.IMPTO_VINCUL_FORNEC IVF
       WHERE I.U##COD_UNID_FEDERAC = IVF.U##COD_UNID_FEDERAC
         AND I.U##COD_PAIS = IVF.U##COD_PAIS
         AND I.U##COD_IMPOSTO = IVF.U##COD_IMPOSTO
         AND IVF.CDN_FORNECEDOR = PCDFORNECEDOR
         AND (UPPER(I.DES_IMPOSTO) LIKE '%' || PTPIMPOSTO || '%' OR
             UPPER(I.DES_IMPOSTO) LIKE
             '%' || PTPIMPOSTO || '%' || VTPPESSOA || '%')
         AND ROWNUM = 1
       ORDER BY IVF.PROGRESS_RECID;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VCDCLASS_IMPOSTO := NULL;
    END;
  
    RETURN VCDCLASS_IMPOSTO;
  
  END FN_BUSCA_CLASS_IMPOSTO;

Procedure P_INSERE_EMAIL_OBS (punimed in number,
                              pcdprestador in number,
                              Pnrlinha in number,
                              ptexto in varchar2) as         
  Begin

            insert into gp.descprest values (             
  
                   PUNIMED,
                   PCDPRESTADOR,
                   Pnrlinha,
                   ' ', --  c.txemail,
                   ' ',
                   ptexto,
                   ' ',
                   ' ',
                   ' ',
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   '',
                   '',
                   '',
                   '',
                   '',
                   0,
                   0,
                   0,
                   0,
                   0,
                   ' ',
                   ' ',
                   ' ',
                   '',
                   '',
                   '',
                   '',
                   '',
                   '',
                   0,
                   0,
                   0,
                   0,
                   0,
                   0,
                   'migracao',
                   trunc(sysdate),
                   gp.descprest_seq.nextval);

                   commit;
                   
End P_INSERE_EMAIL_OBS;

  PROCEDURE P_GERA_PRESTADOR(PZERA_BASE CHAR) IS
    -- PZERA_BASE:
    --   '0' - NÃO APAGA NADA;
    --   '1' - APAGA APENAS TEMPORÁRIAS;
    --   '2' - APAGA TEMPORÁRIAS E TABELAS DE PRESTADORES DO GPS;
  
    VEXISTE_BANCO    CHAR;
    VIMPTO_VINCULADO CHAR;

    pNRPORTADOR_aux number;
    pNRBANCO_aux number;
    pCDAGENCIA_aux number;
    pCDCONTA_CORRENTE_aux number;
    pCDDIGITO_AGENCIA_aux number;
    pCDDIGITO_CONTA_CORRENTE_aux number;
    pCDFORMA_PAGTO_aux number;
    pTPFLUXO_aux varchar2(20);
  
    -- CURSORES DE PRESTADOR
    CURSOR CUR_PRESTADOR IS
      SELECT
      
       '1' TPREGISTRO,
       /*     
       DECODE(AA.CDAREAACAO,
               NULL,
               NVL(AA.CDAREAACAO, F_PARAMETRO('NRUNIMED')),--PNRUNIMED),
               AA.CDAREAACAO) UNIDADE,
        */ --MC
       NVL(AA.CDAREAACAO, PNRUNIMED) UNIDADE,
       --DECODE(AA.CDAREAACAO, NULL, PR.CDPRESTADOR, AA.CDAREAACAO) CODIGO_PRESTADOR, -- MC
       NVL(AA.CDAREAACAO, PR.CDPRESTADOR) CODIGO_PRESTADOR,
       P.NOPESSOA,
       NULL NM_ABREV, -- será preenchido posteriormente no loop
       --DECODE(P.TPPESSOA, 'F', 'F', 'J', 'J', NULL, NULL, 'E') TPPESSOA, --MC
       DECODE(P.TPPESSOA, NULL, 'E', P.TPPESSOA) TPPESSOA,
       NVL((SELECT MGP.CDGRUPO_GP
             FROM MIGRACAO_GRUPO_PRESTADOR MGP
           
            WHERE MGP.TPPRESTADOR = PR.TPPRESTADOR
              AND ROWNUM = 1),
           9) CDGRUPO_PREST,
       
       /*           
       CASE
         WHEN TP.NOTIPO_PRESTADOR LIKE '%COOPERADO%' THEN
          'S'
         ELSE
          'N'
       END AOMEDICO,
       CASE
         WHEN TP.NOTIPO_PRESTADOR LIKE '%COOPERADO%' THEN
          'S'
         ELSE
          'N'
       END AOCREDENCIADO,
       */ --MC
       
       NVL(TP.AOCOOPERADO, 'N') AOMEDICO,
       NVL(TP.AOCOOPERADO, 'N') AOCREDENCIADO,
       
       PNRUNIMED UNIDADE_SECCIONAL,
       
       NVL((SELECT T.U##CD_CONSELHO
             FROM GP.CONPRES T
            WHERE T.U##CD_CONSELHO = PR.CDCONSELHO_PROF),
           'OUT') CDCONSELHO_PROF,
       
       PR.CDESTADO_CRM CDESTADO_CONSELHO,
       
       --PR.CDPRESTADOR NRCRM, --MC
       
       replace(PR.NRCONSELHO_PROF,'/','') NRCRM,
       
       NULL CDFORNECEDOR, -- será preenchido posteriormente no loop
       
       /*
        Evandro Levi (23/05/2018): Adicionado novo tratamento no endereço, se mesmo com as composições abaixo
           não atender ao tamanho total de caracteres permitidos no TOTVS, como alternativa, o complemento
           ficará separado, com limite de 10 caracteres (aceitos pelo EMS), se ainda existir inconsistência,
           a migração do prestador será interrompida e as informações serão apresentadas no DBMS_OUTPUT.
        */
       case --ENDERECO
       --logradouro + nrimovel + txcomplemento <= 40
         when length(e.nologradouro ||
                     decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                      || e.nrimovel) ||
                     decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
           e.nologradouro ||
           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
           decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
       --logradouro reduz + nrimovel + txcomplemento <= 40
         when length(ems506unicoo.f_reduz_end(nologradouro, 0) ||
                     decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel)
                      || decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
           ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
           decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
       --logradouro reduz + nrimovel + txcomplemento reduz <= 40
         when length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                     decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel)
                      || decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                         ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
           ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
           decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                          ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
       -- logradouro reduz abrev + nrimovel + complemento reduz <= 40
         when length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                     decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                      || e.nrimovel) ||
                     decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                         ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
           ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
           decode(ems506unicoo.f_reduz_compl(txcomplemento, 0), null, null,
                                          ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
       end ENDERECO,
       -- logradouro + nrimovel
       Case
         --logradouro + nrimovel <= 40
         When length(e.nologradouro || decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
          || e.nrimovel)) <= 40 Then
           e.nologradouro || decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
            || e.nrimovel)
         --logradouro reduz + nrimovel <= 40
         When length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                     decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                      || e.nrimovel)) <= 40 Then
           ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel)
         --logradouro reduz abrev + nrimovel <= 40
         When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                     decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                      || e.nrimovel)) <= 40 Then
           ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel)
       End ENDERECO_SEM_COMPLEMENTO,
       -- complemento: max de 10 caracteres devido ao limite do cadastro de endereço do EMS
       Case
         --complemento
         When length(E.TXCOMPLEMENTO) <= 10 Then
           E.TXCOMPLEMENTO
         --complemento reduz
         When length(ems506unicoo.f_reduz_compl(e.txcomplemento, 0)) <= 10 Then
           ems506unicoo.f_reduz_compl(e.txcomplemento, 0)
         --complemento reduz abrev
         When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)) <= 10 Then
           ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)
       End COMPLEMENTO_ENDERECO,
       --E.NRIMOVEL,
       NVL(E.NOBAIRRO, 'NAO INFORMADO') BAIRRO,
       NVL(RCI.CDVALOR_EXTERNO, CID.CDCIDADE) NRCIDADE,
       FN_TIRARMASCARA(E.NRCEP, 8) CEP,
       CID.CDESTADO,
       
       CASE
         WHEN PR.DTEXCLUSAO < PR.DTADMISSAO THEN
          TO_CHAR(PR.DTEXCLUSAO, 'DDMMYYYY')
         ELSE
          NVL(TO_CHAR(PR.DTADMISSAO, 'DDMMYYYY'), '01011990')
       END DTADMISSAO,
       
       TO_CHAR(PR.DTEXCLUSAO, 'DDMMYYYY') DTEXCLUSAO,
       
       -- OK. !!! Conceito de Inversao no TOTVS (True e Falso) -- MC
       DECODE(P.TPPESSOA, 'F', DECODE(P.CDSEXO, 'F', 'M', 'F'), 'M') CDSEXO,
       
       NVL(NVL(TO_CHAR(P.DTNASCIMENTO, 'DDMMYYYY'), TO_CHAR(PR.DTADMISSAO, 'DDMMYYYY')),'01011990') DTNASCIMENTO,
       
       --NULL INSC_PREST_UNIDADE, -- MC
       PR.NRMATRICULA INSC_PREST_UNIDADE,
       
       NULL CDSITUACAO_SINDICAL,
       
       0 VLFATOR_UTIVIDADE,
       
       --'S' AOALVARA, -- MC
       decode(P.TPPESSOA, 'F', 'N', 'S') AOALVARA,
       
       DECODE(PR.NRREGISTROINSS, NULL, 'N', 'S') AOPOSSUI_REG_INSS,
       
       -- ESTE CAMPO EXISTE NA TABELA MAS NAO EXISTE NA TELA. (VERIFICAR O QUE USAR) -- MC
       --DECODE(PR.NRANOFORMACAO, NULL, 'N', 'S') AOPOSSUI_DIPLOMA,
       NVL((SELECT ESP.AOPOSSUICERTIFICACAO
             FROM ESPECIALISTA ESP
            WHERE ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
              AND ROWNUM = 1),
           'N') AOPOSSUI_DIPLOMA,

       nvl((SELECT TO_CHAR(CD_ESPECIALIDADE_TOTVS)
                       FROM DEPARA_ESPECIALIDADE T, especialista esp
                      WHERE T.CDESPECIALIDADE_UNICOO = ESP.CDESPECIALIDADE
                        and ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                        AND ESP.CDESPECIALIDADE = PR.CDESPECIAL_PREDOM
                        AND ESP.CDSITUACAO = 0
                        AND ROWNUM = 1),
             nvl((SELECT ESP.CDESPECIALIDADE
                FROM ESPECIALISTA ESP
               WHERE ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                 AND ESP.CDESPECIALIDADE = PR.CDESPECIAL_PREDOM
                 AND ESP.CDSITUACAO = 0
                 AND ROWNUM = 1),PCDESPECIALIDADE)) NRESPEC_RESID,

       nvl((SELECT TO_CHAR(CD_ESPECIALIDADE_TOTVS)
                       FROM DEPARA_ESPECIALIDADE T, especialista esp
                      WHERE T.CDESPECIALIDADE_UNICOO = ESP.CDESPECIALIDADE
                        and ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                        AND ESP.CDESPECIALIDADE = PR.CDESPECIAL_PREDOM
                        AND ESP.CDSITUACAO = 0
                        AND ROWNUM = 1),
             nvl((SELECT ESP.CDESPECIALIDADE
                FROM ESPECIALISTA ESP
               WHERE ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                 AND ESP.CDESPECIALIDADE = PR.CDESPECIAL_PREDOM
                 AND ESP.CDSITUACAO = 0
                 AND ROWNUM = 1),PCDESPECIALIDADE)) NRESPEC_TIT,

--       NULL NRESPEC_TIT, --MC O NUMERO NO UNICOO É MAIOR QUE 4 POSICOES. CONTEUDO ESTA SENDO LEVADO PARA OBS2
       
       --NVL(E.AOCORRESPONDENCIA, 'N') AOMALOTE, -- MC
       'N' AOMALOTE,
       
       -- 'S' AOVINCULO_EMPREGATICIO,
       -- MCarvalho - 23/11/2016
       -- Para que um Prestador tenha vínculo empregatício no totvs12, para o calculo
       -- do teto do INSS no pagamento, devemos considerar se o prestador existe em outras 
       -- fontes de recolhimento no Unicoo.
       
       DECODE ((SELECT count(*) 
                FROM OUTRO_RECOLHIMENTO_INSS OI
                WHERE  OI.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                AND    OI.NRPERIODO_FIN   IS NULL
                AND    ROWNUM = 1),
                0,
                'N',
                'S') AOVINCULO_EMPREGATICIO,

       NULL NRULT_MES_INSS,
       
       NULL NRRAMAL1,
       
       NULL NRRAMAL2,
       
       NVL(P.NRCGC_CPF, 0) NRCPF_CNPJ,
       
       --'S' AOREPRES_UNIDADE,
       DECODE(AA.CDPRESTADOR,PR.CDPRESTADOR,'S','N') AOREPRES_UNIDADE,
       
       
       '01' CDHOR_URGENCIA,
       
       --DECODE(P.TPPESSOA, 'F', 'S', 'N') AORECOLHE_INSS, -- MC
       TP.AOINCIDE_INSS AORECOLHE_INSS,
       
       'N' AORECOLHE_PARTICIPACAO,
       
       'CODIGO DO PRESTADOR NO SISTEMA UNICOO: ' || PR.CDPRESTADOR TXOBSERVACAO1,
       
       DECODE((SELECT ESP.NRREG_QUALIFICACAO_ESPEC
                FROM ESPECIALISTA ESP
               WHERE ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                 AND ROWNUM = 1),
              NULL,
              '',
              'NR TITULO DA ESPECIALIDADE: ' ||
              (SELECT ESP.NRREG_QUALIFICACAO_ESPEC
                 FROM ESPECIALISTA ESP
                WHERE ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                  AND ROWNUM = 1)) TXOBSERVACAO2,
       
       NULL TXOBSERVACAO3,
       
       --DECODE(PR.TPPRESTADOR, '9', 'N', 'S') AOCALCULA_IR, --MC
       --TP.AOINCIDE_IR AOCALCULA_IR, -- MC
       DECODE(PR.CDCLASSEIR,'00','N','S') AOCALCULA_IR,
       -- o que é o 03 ????!!!!
       '03' NRIND_IRRF, --01 sobre valor princ do proced - 02 sobre valor aux - 03 - ambos
       
       NULL DTCALCULA_ADIANTAMENTO,
       'N' AOCALCULA_ADIANTAMENTO,
       PD.NRDEPENDENTE,
       'N' AOPAGTORH,
       nvl(E.CDEMAIL,e.cdemail_adicional) EMAIL,
       
       '           1' TPFLUXO, -- será corrigido posteriormente no loop
       
       NULL CDIMPOSTO,
       NULL CDCLASSIF_IMPOSTO,
       P.NRPIS,
       TO_CHAR(PR.NRREGISTROINSS) NRREGISTROINSS,
       'N' AODIVIDE_HONOR,
       
       NULL AOCALCULA_COFINS,
       NULL AOCALCULA_PIS,
       NULL AOCALCULA_CSLL,
       NULL CDIMPOSTO_COFINS,
       NULL CDIMPOSTO_PISPASEP,
       NULL CDIMPOSTO_CSLL,
       NULL CDCLASSIF_COFINS,
       NULL CDCLASSIF_PISPASEP,
       NULL CDCLASSIF_CSLL,
       NULL CDIMPOSTO_INSS,
       NULL CDCLASSIF_INSS,
       NULL AOCALCULA_ISS,
       NULL CDIMPOSTO_ISS,
       NULL CDCLASSIF_ISS,
       
       'N' AODEDUZ_ISS_UC,
       
       '30' PRZ_RETORNO,
       
       null NRPORTADOR,
       
       PCDMODALIDADE NRMODALIDADE,
       
       /*0*/ pr.nrbanco    NRBANCO,
       /*NULL*/ pr.nragencia CDAGENCIA,
       /*NULL*/ lpad(pr.nrconta,'0',10) CDCONTA_CORRENTE,
       NULL CDDIGITO_AGENCIA,
       /*NULL*/ pr.nrdigito CDDIGITO_CONTA_CORRENTE,
       
       '01' CDFORMA_PAGTO,
       
       -- QUEM DEFINIU O '9' ????!!!! SERVICOS CREDENCIADOS
       DECODE(P.TPPESSOA,
              'J',
              --DECODE(PR.TPPRESTADOR, '9', 'N', 'S'), -- MC
              'S',
              'N') AOCALCULA_PIS_COFINS_CSLL_PROC,
       DECODE(P.TPPESSOA,
              'J',
              --DECODE(PR.TPPRESTADOR, '9', 'N', 'S'), -- MC
              'S',
              'N') AOCALCULA_PIS_COFINS_CSLL_INSU,
       
       'N' AOCALCULA_IMPOSTO_UNICO,
       NULL CDIMPOSTO_UNICO,
       NULL CDCLASSIF_UNICO,
       NVL(PR.TPCLASSIF_ESTABELEC, 3) TPCLASSIF_ESTABELEC,
       PR.NRCNES,
       PROP.NOPROPRIETARIO, --NOME DO DIRETOR TECNICO
       PR.NRREG_ANS_PREST,
       TO_CHAR(PR.DTINICIO_CONTRATUALIZACAO, 'DDMMYYYY') DTINICIO_CONTRATUALIZACAO,
       CASE
         WHEN TRIM(P.NRINSCEST_RG) IS NOT NULL AND P.TPPESSOA = 'F' THEN
          'IDENTIDADE'
         ELSE
          NULL
       END CDNATUREZA_DOC,
       TRIM(P.NRINSCEST_RG) NRINSCEST_RG,
       CASE
         WHEN TRIM(P.nrinscest_rg) IS NOT NULL THEN
         
          -- temp_depara_orgao_emissor foi criada no owner UNICOOGPS para contornar limitacao de 25 caracteres da tabela original do Unicoo mig_tab_conversao_exp
          nvl((select cdvalor_externo
                from temp_depara_orgao_emissor o 
               where o.cdvalor_interno = P.NOORGAO_EMISSOR_RG),
              'OUTROS EMISSORES')
         ELSE
          NULL
       END NOORGAO_EMISSOR_RG,
       CASE
         WHEN TRIM(P.NRINSCEST_RG) IS NOT NULL THEN
--          NVL(P.CDPAIS_EMISSOR_ID, 32)

            nvl((select ci.nopais_emissor_id
            from pais_emissor_cart_identidade ci
            where ci.cdpais_emissor_id = p.cdpais_emissor_id),
            null)
            
         ELSE
          NULL
       END CDPAIS_EMISSOR_ID,
       
       CASE
         WHEN TRIM(P.NRINSCEST_RG) IS NOT NULL THEN
          NVL(P.CDESTADO_EMISSOR_RG, PCDESTADODEFAULT)
         ELSE
          NULL
       END CDESTADO_EMISSOR_RG,
       
       CASE
         WHEN TRIM(P.NRINSCEST_RG) IS NOT NULL THEN
          TO_CHAR(NVL(P.DTEXPEDICAO_RG, TRUNC(SYSDATE)), 'DDMMYYYY')
         ELSE
          NULL
       END DTEXPEDICAO_RG,
       
       -- P.CDNACIONALIDADE,
       CASE
         WHEN TRIM(P.NRINSCEST_RG) IS NOT NULL THEN
            nvl((select ci.NONACIONALIDADE
            from pais_emissor_cart_identidade ci
            where ci.cdpais_emissor_id = p.cdpais_emissor_id),
            P.CDNACIONALIDADE)
         ELSE
          NULL
          
       END CDNACIONALIDADE,
       
       E.NRTELEFONE TELEFONE1,
       E.NRCELULAR  TELEFONE2,
       
       DECODE(NVL(PR.TPDISPONIBILIDADE, '0'),
              '0',
              '0',
              '1',
              '1',
              '2',
              '2',
              '2') TPDISPONIBILIDADE,
       CASE
         WHEN DECODE(AA.CDAREAACAO,
                     NULL,
                     NVL(AA.CDAREAACAO, PNRUNIMED),
                     AA.CDAREAACAO) <> PNRUNIMED THEN
          'S'
         ELSE
          'N'
       END AOCOOP_MEDICA,
       PR.AOACIDENTE_TRABALHO,
       PR.AOTABELA_PROPRIA,
       PR.CDPERFIL_ASSISTENCIAL,
       
       3 TPRODUTO, -- Tipo de produto atendido pelo prestador:
       --0 - Nao informado
       --1 - Regulamentado
       --2 - Nao Regulamentado
       --3 - Ambos
       
       DECODE((SELECT COUNT(*)
                FROM ESPECIALISTA ESP
               WHERE ESP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                 AND ESP.AOGUIA_MEDICO = 'S'),
              0,
              'N',
              'S') AOGUIA_MEDICO,
              
       DECODE((SELECT COUNT(*)
                FROM ESPECIALISTA ESP1
               WHERE ESP1.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                 AND ESP1.AOPUBLICA_ANS = 'S'),
               0,
               'N',
               'S') AOPUBLICA_ANS,
               
       DECODE((SELECT COUNT(*)
                FROM ESPECIALISTA ESP1
               WHERE ESP1.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                 AND ESP1.CDRESIDENCIA = 'S'),
               0,
               'N',
               'S') RESID_MEDICA,
       
       --Evandro Levi (15/05/2018): Alterado o alias do De/Para da Sigla do Conselho do Diretor Tecnico
       SUBSTR(RCF_DT.CDVALOR_EXTERNO, 1, 5) CDCONSELHO, --SIGLA DO CONSELHO DO DIRETOR TECNICO
       
       PROP.CDREGISTRO_CONSELHO CDREGISTRO_CONSELHO, --NR.CONSELHO DO DIRETOR TECNICO
       
       PROP.CDESTADO_CONSELHO       CDESTADO_CONSELHO_DIR, --UF DO CONSELHO DO DIRETOR TECNICO
       
       NULL TIPOREDE, -- Tipo de Rede conforme Manual do Intercambio Nacional.
       
       DECODE(AA.CDAREAACAO, NULL, PR.CDPRESTADOR, AA.CDAREAACAO) CDPRESTADOR,
       PR.NRREGISTRO_PREST,
       E.NRREGISTRO NRREGISTRO_ENDERECO,
       PR.TPPRESTADOR,
       PR.AOPARTICIP_NOTIVISA,
       PR.AOPARTICIP_QUALIS,
       PR.AOENVIA_CADU,
       PR.NOFANTASIA
      
        FROM PRESTADOR               PR,
             PESSOA                  P,
             ENDERECO                E,
             CIDADE                  CID,
             AREA_DE_ACAO            AA,
             PRAZO_RETORNO_PRESTADOR PRP,
             TIPO_DE_PRESTADOR       TP,

             --A QUERY ANTERIOR TOTALIZAVA A QUANTIDADE DE DEPENDENTES SEM LEVAR EM CONSIDERACAO OS
             --2 PARAMETROS DE MAIORIDADE. INCLUIMOS A TABELA PESSOA PARA VERIFICAR SE A IDADE
             --É INFERIOR A PARÂMETRO DEPIRID1 OU DEPIRID2 OU 999 PARA DEPENDENTES PERMANENTES
             (SELECT PD.NRREGISTRO_PREST, COUNT(*) NRDEPENDENTE
                FROM PRESTADOR_DEPENDENTE PD,
                     PESSOA               P,
                     PARAMETRO            P1,
                     PARAMETRO            P2
               --WHERE P.NRREGISTRO(+) = PD.NRREGISTRO_DEPENDENTE -- MC/ TIREI O ALTER JOIN
               WHERE P.NRREGISTRO = PD.NRREGISTRO_DEPENDENTE 
                 AND P1.CDPARAMETRO = 'DEPIRID1'
                 AND P2.CDPARAMETRO = 'DEPIRID2'
                 AND IDADE(P.DTNASCIMENTO, SYSDATE) <=
                     DECODE(PD.CDTIPO_DEPENDENTE,
                            '1',
                            P1.VLPARAMETRO,
                            '2',
                            P2.VLPARAMETRO,
                            999)
               GROUP BY PD.NRREGISTRO_PREST) PD,
             (SELECT PP.NRREGISTRO_PRESTADOR,
                     PE2.NOPESSOA NOPROPRIETARIO,
                     PP.CDREGISTRO_CONSELHO,
                     PP.CDESTADO_CONSELHO,
                     PP.NRREGISTRO_PROPRIETARIO,
                     TC.TXDESCRICAO CDCONSELHO
                FROM PRESTADOR_PROPRIETARIO PP, PESSOA PE2,
                     TABELA_DE_CODIGO TC  --Evandro Levi (15/05/2018): Buscar a sigla do conselho do Diretor Tecnico
               WHERE PP.NRREGISTRO_PROPRIETARIO = PE2.NRREGISTRO
                 And pp.cdconselho = tc.cdvalor(+)  --Evandro Levi (14/06/2018): Faltava relacionamento do conselho do diretor tecnico com a tabela de código
                 And Tc.cdidentificador = 'PRESTADOR_PROPRIETARIO.CDCONS'
                 AND PP.AORESPONSAVEL_TECNICO = 'S') PROP,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_PREST_CREDENCIADO'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RMPC,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_PREST_MEDICO'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RMPM,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_CIDADE'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCI,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_CONSELHO_PROFISSIONAL'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCF,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_CONSELHO_PROFISSIONAL'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCF_DT,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_TIPO_VINCULO'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) MTV
       WHERE PR.NRREGISTRO_PREST = PD.NRREGISTRO_PREST(+)
         AND (P.NRREGISTRO = E.NRREGISTRO(+) AND
             -- com essa logica podia colocar endereco Residencial como Principal na PRESERV E.AOCORRESPONDENCIA(+) = 'S')
             E.TPENDERECO(+) = 'CON1')
         AND PR.NRREGISTRO_PREST = PRP.NRREGISTRO_PREST(+)
         AND PR.NRREGISTRO_PREST = PROP.NRREGISTRO_PRESTADOR(+)
         AND PR.TPPRESTADOR = TP.TPPRESTADOR
         AND TP.TPPRESTADOR = MTV.CDVALOR_INTERNO(+)
         AND TP.TPPRESTADOR = RMPM.CDVALOR_INTERNO(+)
         AND TP.TPPRESTADOR = RMPC.CDVALOR_INTERNO(+)
         AND E.CDCIDADE = CID.CDCIDADE(+)
         AND CID.CDCIDADE = RCI.CDVALOR_INTERNO(+)
         AND PR.CDCONSELHO_PROF = RCF.CDVALOR_INTERNO(+)
         And PROP.CDCONSELHO = RCF_DT.CDVALOR_INTERNO(+)
         AND P.NRREGISTRO = PR.NRREGISTRO_PREST
         AND PR.CDPRESTADOR = AA.CDPRESTADOR(+)
         --GARANTIR QUE NAO ESTEJA ASSOCIADO AO GRUPO DE FORNECEDOR 'NAOM' (NAO MIGRAR)
         and exists (SELECT 1
             from fornecedor fu
             where fu.nrregistro_fornecedor = pr.nrregistro_prest
               and not exists
             (select 1
                      from ti_grupo_de_fornecedor gf
                     where fu.cdgrupo_fornecedor = gf.cdgrupo_fornecedor
                       and gf.cod_grp_fornecedor = 'NAOM'))         
             
         AND NOT EXISTS
       (SELECT 1
                FROM TM_PRESTADORES_EXC TPE
               WHERE TPE.NRREGISTRO_PREST = PR.NRREGISTRO_PREST)
               ;
  
    -- CURSOR PRESTADOR x VINCULO x ESPECIALIDADE
    CURSOR CUR_PREST_VINC_ESPEC(PNRREGISTRO_PREST PRESTADOR.NRREGISTRO_PREST%TYPE) IS
    
      SELECT '2' TPREGISTRO,
             NVL(MTV.CDVALOR_EXTERNO, 2) NRVINCULO,
             
             NVL(NVL((SELECT TO_CHAR(CD_ESPECIALIDADE_TOTVS)
                       FROM DEPARA_ESPECIALIDADE T
                      WHERE T.CDESPECIALIDADE_UNICOO = ESP.CDESPECIALIDADE),
                     TO_NUMBER(ESP.CDESPECIALIDADE)),
                 PCDESPECIALIDADE) CDESPECIALIDADE,
             
             NVL(NVL((SELECT TO_CHAR(CD_ESPECIALIDADE_TOTVS)
                       FROM DEPARA_ESPECIALIDADE T
                      WHERE T.CDESPECIALIDADE_UNICOO = ESP.CDESPECIALIDADE),
                     TO_NUMBER(ESP.CDESPECIALIDADE)),
                 PCDESPECIALIDADE) CDESPECIALIDADE_AUTORIZADOR,
             
             DECODE(ES.CDESPECIALIDADE, PR.CDESPECIAL_PREDOM, 'S', 'N') AOESPEC_PRINCIPAL,
             'S' AOCONSID_QTD_VINCULO,
             ESP.CDAMB,
             DECODE(PR.TPCONTRATUALIZACAO, '1', '1', '2', '2', '0') TPCONTRATUALIZACAO,
             --Evandro Levi (17/05/2018): Alterado tratamento que define se o especialista possui ou não certificação (tratamento igual ao A400 do Unicoo)
             Decode(Nvl(ES.NRREG_QUALIFICACAO_ESPEC_2, ES.NRREG_QUALIFICACAO_ESPEC), Null, 'N', 'S') AOPOSSUICERTIFICACAO,
             --ES.AOPOSSUICERTIFICACAO,
             ES.CDSITUACAO,
             ES.NRREG_QUALIFICACAO_ESPEC, 
             ES.NRREG_QUALIFICACAO_ESPEC_2,
             --Evandro Levi (22/05/2018): Adicionado campo para informar a Especialidade do Profissional - Quando especialidade for Ginecologia (PTU - 60)
             Decode(Esp.cdptu,'60' /*Ginecologia - regra do Unicoo*/,Nvl(Es.cdginec_obstr,0),0) cdginec_obstr, --previesp.int_2 - Esp.Profissional
             --Evandro Levi (24/08/2018): Adicionado campo para informar se o Prestador fez residência aprovada pelo MEC
             Nvl(Trim(ES.CDRESIDENCIA),'N') CDRESIDENCIA
        FROM PRESTADOR PR,
             ESPECIALISTA ES,
             ESPECIALIDADE ESP,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_TIPO_VINCULO'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) MTV
       WHERE PR.NRREGISTRO_PREST = ES.NRREGISTRO_PREST(+)
         AND ES.CDESPECIALIDADE = ESP.CDESPECIALIDADE(+)
         AND PR.TPPRESTADOR = MTV.CDVALOR_INTERNO(+)
         AND PR.NRREGISTRO_PREST = PNRREGISTRO_PREST

--alex         
      --   and pr.cdprestador = 941071
         
         ;
  
    -- CURSOR PRESTADOR x ENDERECO
    CURSOR CUR_PREST_ENDERECO(PNRREGISTRO_PREST PRESTADOR.NRREGISTRO_PREST%TYPE) IS
    
      SELECT '3' TPREGISTRO,
             
             /*
              Evandro Levi (23/05/2018): Adicionado novo tratamento no endereço, se mesmo com as composições abaixo
                 não atender ao tamanho total de caracteres permitidos no TOTVS, como alternativa, o complemento
                 ficará separado, com limite de 10 caracteres (aceitos pelo EMS), se ainda existir inconsistência,
                 a migração do prestador será interrompida e as informações serão apresentadas no DBMS_OUTPUT.
              */
             case
               --logradouro + nrimovel + txcomplemento <= 40
               when length(e.nologradouro ||
                           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                            || e.nrimovel) ||
                           decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
                 e.nologradouro ||
                 decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
                 decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
               --logradouro reduz + nrimovel + txcomplemento <= 40
               when length(ems506unicoo.f_reduz_end(nologradouro, 0) ||
                           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                            || e.nrimovel) ||
                           decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
                 ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                 decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
                 decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
               --logradouro reduz + nrimovel + txcomplemento reduz <= 40
               when length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                            || e.nrimovel) ||
                           decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                               ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
                 ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                 decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
                 decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                               ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
               -- logradouro reduz abrev + nrimovel + complemento reduz <= 40
               when length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                            || e.nrimovel) ||
                           decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                               ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
                 ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                 decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel) ||
                 decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                               ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
             End NOLOGRADOURO,
             -- logradouro + nrimovel
             Case
               --logradouro + nrimovel <= 40
               When length(e.nologradouro || decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                || e.nrimovel)) <= 40 Then
                 e.nologradouro || decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                  || e.nrimovel)
               --logradouro reduz + nrimovel <= 40
               When length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                            || e.nrimovel)) <= 40 Then
                 ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                 decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel)
               --logradouro reduz abrev + nrimovel <= 40
               When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                           decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT)
                            || e.nrimovel)) <= 40 Then
                 ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                 decode(e.nrimovel, null, null, nvl(pSEPARADOR_ENDERECO_NUMERO,vSEP_END_NUMERO_DEFAULT) || e.nrimovel)
             End ENDERECO_SEM_COMPLEMENTO,
             -- complemento: max de 10 caracteres devido ao limite do cadastro de endereço do EMS
             Case
               --complemento
               When length(E.TXCOMPLEMENTO) <= 10 Then
                 E.TXCOMPLEMENTO
               --complemento reduz
               When length(ems506unicoo.f_reduz_compl(e.txcomplemento, 0)) <= 10 Then
                 ems506unicoo.f_reduz_compl(e.txcomplemento, 0)
               --complemento reduz abrev
               When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)) <= 10 Then
                 ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)
             End COMPLEMENTO_ENDERECO,
             
             NVL(E.NOBAIRRO, 'NAO INFORMADO') NOBAIRRO,
             NVL(RCI.CDVALOR_EXTERNO, E.CDCIDADE) CDCIDADE,
             FN_TIRARMASCARA(E.NRCEP, 8) NRCEP,
             CID.CDESTADO,
             (E.NRDDD || E.NRTELEFONE) NRTELEFONE1,
             E.NRCELULAR NRTELEFONE2,
             
             NULL RAMAL1,
             NULL RAMAL2,
             NULL HRENTRADA_MANHA,
             NULL HRSAIDA_MANHA,
             NULL HRENTRADA_TARDE,
             NULL HRSAIDA_TARDE,
             'N' AOTRABALHA_SEG,
             NULL HRENTRADA_MANHA_SEG,
             NULL HRSAIDA_MANHA_SEG,
             NULL HRENTRADA_TARDE_SEG,
             NULL HRSAIDA_TARDE_SEG,
             'N' AOTRABALHA_TER,
             NULL HRENTRADA_MANHA_TER,
             NULL HRSAIDA_MANHA_TER,
             NULL HRENTRADA_TARDE_TER,
             NULL HRSAIDA_TARDE_TER,
             'N' AOTRABALHA_QUA,
             NULL HRENTRADA_MANHA_QUA,
             NULL HRSAIDA_MANHA_QUA,
             NULL HRENTRADA_TARDE_QUA,
             NULL HRSAIDA_TARDE_QUA,
             'N' AOTRABALHA_QUI,
             NULL HRENTRADA_MANHA_QUI,
             NULL HRSAIDA_MANHA_QUI,
             NULL HRENTRADA_TARDE_QUI,
             NULL HRSAIDA_TARDE_QUI,
             'N' AOTRABALHA_SEX,
             NULL HRENTRADA_MANHA_SEX,
             NULL HRSAIDA_MANHA_SEX,
             NULL HRENTRADA_TARDE_SEX,
             NULL HRSAIDA_TARDE_SEX,
             'N' AOTRABALHA_SAB,
             NULL HRENTRADA_MANHA_SAB,
             NULL HRSAIDA_MANHA_SAB,
             NULL HRENTRADA_TARDE_SAB,
             NULL HRSAIDA_TARDE_SAB,
             'N' AOTRABALHA_DOM,
             NULL HRENTRADA_MANHA_DOM,
             NULL HRSAIDA_MANHA_DOM,
             NULL HRENTRADA_TARDE_DOM,
             NULL HRSAIDA_TARDE_DOM,
             
             --           DECODE(NVL(E.AOCORRESPONDENCIA, 'N'), 'S', 'S', 'N') AOMALOTE, --MC
             'N' AOMALOTE,
             
             DECODE(NVL(E.AOCORRESPONDENCIA, 'N'), 'S', 'S', 'N') AOCORRESPONDENCIA,
             DECODE(ENDER.CDVALOR_EXTERNO,1,0,2,2,3,1,4,3) TPENDERECO,
             NULL NRCNES,
             
             PE.NRLEITOS_TOTAIS,
             PE.NRLEITOS_CONTRATADOS,
             PE.NRLEITOS_PSIQUIATRIA,
             PE.NRLEITOS_UTI_ADULTO,
             PE.NRLEITOS_UTI_NEONATAL,
             PE.NRLEITOS_UTI_PEDIATR,
             --E.TXCOMPLEMENTO,
             'N' AOFILIAL,
             NULL NRCGC_CPFFILIAL,
             DECODE(ENDER.CDVALOR_EXTERNO,1,0,2,2,3,1,4,3) TPENDERECO_END,
             E.TPENDERECO TPENDERECO_UNICOO,
             --CAMPOS DA NOVA VERSÃO - ULTIMOS CAMPOS DO LAYOUT
             PE.NRLEITOS_INTERMED_NEONATAL,
             PE.NRLEITOS_HOSPITAL_DIA,
             PE.NRLEITOS_TOT_PSIQU,
             PE.NRLEITOS_TOT_CIRUR,
             PE.NRLEITOS_TOT_PEDIAT,
             PE.NRLEITOS_TOT_OBSTR,
             PE.NRLATITUDE,
             PE.NRLONGITUDE,
             PE.NRLEITOS_INTERMED,
             PR.TXSITIOELETRONICO
        FROM PRESTADOR PR,
             PESSOA P,
             ENDERECO E,
             CIDADE CID,
             PRESTADOR_ESTABELECIMENTO PE,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_TIPO_ENDERECO'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) ENDER,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao_exp CE, mig_tab_conversao TC
               WHERE NOTABELA = 'MIGRACAO_CIDADE'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCI,
             TIPO_DE_ENDERECO TP
       WHERE PR.NRREGISTRO_PREST = P.NRREGISTRO
            --AND PR.NRREGISTRO_PREST = PE.NRREGISTRO_PREST(+)
         AND P.NRREGISTRO = E.NRREGISTRO
         AND E.NRREGISTRO = PE.NRREGISTRO_PREST(+)
         AND E.TPENDERECO = PE.CDTIPO_ENDERECO(+)
         AND ENDER.CDVALOR_INTERNO(+) = E.TPENDERECO
         AND E.CDCIDADE = CID.CDCIDADE(+)
         AND CID.CDCIDADE = RCI.CDVALOR_INTERNO(+)
         AND TP.TPENDERECO = E.TPENDERECO
         AND TP.AOPRESTADOR = 'S'
            --       ANTES SÓ TRAZÍAMOS OS ENDERECOS DE PRESTADORES CON1, CON2, CON...
            --         AND TP.AOPESSOAFISICA = 'N'
            --         AND TP.AOPESSOAJURIDICA = 'N'
         AND PR.nrregistro_prest = PNRREGISTRO_PREST
      UNION
      SELECT '3' TPREGISTRO,
             --NVL(ENDPRES.NOLOGRADOURO, 'NAO INFORMADO'),
             ENDPRES.NOLOGRADOURO,
             ENDPRES.ENDERECO_SEM_COMPLEMENTO,
             ENDPRES.COMPLEMENTO_ENDERECO,
             --             ENDPRES.NRIMOVEL,
             NVL(ENDPRES.NOBAIRRO, 'NAO INFORMADO') NOBAIRRO,
             NVL(RCI.CDVALOR_EXTERNO, ENDPRES.CDCIDADE) CDCIDADE,
             FN_TIRARMASCARA(ENDPRES.NRCEP, 8) NRCEP,
             CID.CDESTADO,
             (ENDPRES.NRDDD || ENDPRES.NRTELEFONE) NRTELEFONE1,
             ENDPRES.NRCELULAR NRTELEFONE2,
             NULL RAMAL1,
             NULL RAMAL2,
             NULL HRENTRADA_MANHA,
             NULL HRSAIDA_MANHA,
             NULL HRENTRADA_TARDE,
             NULL HRSAIDA_TARDE,
             'N' AOTRABALHA_SEG,
             NULL HRENTRADA_MANHA_SEG,
             NULL HRSAIDA_MANHA_SEG,
             NULL HRENTRADA_TARDE_SEG,
             NULL HRSAIDA_TARDE_SEG,
             'N' AOTRABALHA_TER,
             NULL HRENTRADA_MANHA_TER,
             NULL HRSAIDA_MANHA_TER,
             NULL HRENTRADA_TARDE_TER,
             
             NULL HRSAIDA_TARDE_TER,
             'N' AOTRABALHA_QUA,
             NULL HRENTRADA_MANHA_QUA,
             NULL HRSAIDA_MANHA_QUA,
             NULL HRENTRADA_TARDE_QUA,
             NULL HRSAIDA_TARDE_QUA,
             'N' AOTRABALHA_QUI,
             NULL HRENTRADA_MANHA_QUI,
             NULL HRSAIDA_MANHA_QUI,
             NULL HRENTRADA_TARDE_QUI,
             NULL HRSAIDA_TARDE_QUI,
             'N' AOTRABALHA_SEX,
             NULL HRENTRADA_MANHA_SEX,
             NULL HRSAIDA_MANHA_SEX,
             NULL HRENTRADA_TARDE_SEX,
             NULL HRSAIDA_TARDE_SEX,
             'N' AOTRABALHA_SAB,
             NULL HRENTRADA_MANHA_SAB,
             NULL HRSAIDA_MANHA_SAB,
             NULL HRENTRADA_TARDE_SAB,
             NULL HRSAIDA_TARDE_SAB,
             'N' AOTRABALHA_DOM,
             NULL HRENTRADA_MANHA_DOM,
             NULL HRSAIDA_MANHA_DOM,
             NULL HRENTRADA_TARDE_DOM,
             NULL HRSAIDA_TARDE_DOM,
             
             --NVL(ENDPRES.AOCORRESPONDENCIA, 'N') AOMALOTE, -- MC
             'N' AOMALOTE,
             
             NVL(ENDPRES.AOCORRESPONDENCIA, 'N') AOCORRESPONDENCIA,
             DECODE(ENDER.CDVALOR_EXTERNO,1,0,2,2,3,1,4,3) TPENDERECO,
             NULL NRCNES,
             PE.NRLEITOS_TOTAIS,
             PE.NRLEITOS_CONTRATADOS,
             PE.NRLEITOS_PSIQUIATRIA,
             PE.NRLEITOS_UTI_ADULTO,
             PE.NRLEITOS_UTI_NEONATAL,
             PE.NRLEITOS_UTI_PEDIATR,
             --ENDPRES.TXCOMPLEMENTO,
             'N' AOFILIAL,
             NULL NRCGC_CPFFILIAL,
             DECODE(ENDER.CDVALOR_EXTERNO,1,0,2,2,3,1,4,3) TPENDERECO_END,
             ENDPRES.TPENDERECO TPENDERECO_UNICOO,
             --CAMPOS DA NOVA VERSÃO - ULTIMOS CAMPOS DO LAYOUT
             0 NRLEITOS_INTERMED_NEONATAL,
             0 NRLEITOS_HOSPITAL_DIA,
             0 NRLEITOS_TOT_PSIQU,
             0 NRLEITOS_TOT_CIRUR,
             0 NRLEITOS_TOT_PEDIAT,
             0 NRLEITOS_TOT_OBSTR,
             '0' NRLATITUDE,
             '0' NRLONGITUDE,
             0 NRLEITOS_INTERMED,
             ' ' TXSITIOELETRONICO
        FROM (SELECT P.NRREGISTRO_PREST NRREGISTRO,
                     E.TPENDERECO,
                     --E.NOLOGRADOURO,
                     /*
                      Evandro Levi (23/05/2018): Adicionado novo tratamento no endereço, se mesmo com as composições abaixo
                         não atender ao tamanho total de caracteres permitidos no TOTVS, como alternativa, o complemento
                         ficará separado, com limite de 10 caracteres (aceitos pelo EMS), se ainda existir inconsistência,
                         a migração do prestador será interrompida e as informações serão apresentadas no DBMS_OUTPUT.
                      */
                     case --ENDERECO
                     --logradouro + nrimovel + txcomplemento <= 40
                       when length(e.nologradouro ||
                                   decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                   decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
                         e.nologradouro ||
                         decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                         decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
                     --logradouro reduz + nrimovel + txcomplemento <= 40
                       when length(ems506unicoo.f_reduz_end(nologradouro, 0) ||
                                   decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                   decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
                         ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                         decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                         decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
                     --logradouro reduz + nrimovel + txcomplemento reduz <= 40
                       when length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                                   decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                   decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                       ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
                         ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                         decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                         decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                        ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
                     -- logradouro reduz abrev + nrimovel + complemento reduz <= 40
                       when length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                                   decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                   decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                       ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
                         ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                         decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                         decode(ems506unicoo.f_reduz_compl(txcomplemento, 0), null, null,
                                                        ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
                     end NOLOGRADOURO,
                     -- logradouro + nrimovel
                     Case
                       --logradouro + nrimovel <= 40
                       When length(e.nologradouro || decode(e.nrimovel, null, null, ' ' || e.nrimovel)) <= 40 Then
                         e.nologradouro || decode(e.nrimovel, null, null, ' ' || e.nrimovel)
                       --logradouro reduz + nrimovel <= 40
                       When length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                                   decode(e.nrimovel, null, null, ' ' || e.nrimovel)) <= 40 Then
                         ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                         decode(e.nrimovel, null, null, ' ' || e.nrimovel)
                       --logradouro reduz abrev + nrimovel <= 40
                       When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                                   decode(e.nrimovel, null, null, ' ' || e.nrimovel)) <= 40 Then
                         ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                         decode(e.nrimovel, null, null, ' ' || e.nrimovel)
                     End ENDERECO_SEM_COMPLEMENTO,
                     -- complemento: max de 10 caracteres devido ao limite do cadastro de endereço do EMS
                     Case
                       --complemento
                       When length(E.TXCOMPLEMENTO) <= 10 Then
                         E.TXCOMPLEMENTO
                       --complemento reduz
                       When length(ems506unicoo.f_reduz_compl(e.txcomplemento, 0)) <= 10 Then
                         ems506unicoo.f_reduz_compl(e.txcomplemento, 0)
                       --complemento reduz abrev
                       When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)) <= 10 Then
                         ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)
                     End COMPLEMENTO_ENDERECO,
                     --
                     --E.NRIMOVEL,
                     --E.TXCOMPLEMENTO,
                     E.NOBAIRRO,
                     E.CDCIDADE,
                     E.CDESTADO,
                     E.NRCEP,
                     E.NRTELEFONE,
                     E.NRFAX,
                     E.NOCONTATO,
                     E.NOCARGOCONTATO,
                     nvl(E.CDEMAIL,E.CDEMAIL_ADICIONAL), -- MCarvalho.
                     E.TXOBSERVACOES,
                     E.AOCORRESPONDENCIA,
                     E.NOOPERADOR,
                     E.NRCELULAR,
                     E.AOSITUACAO,
                     E.NRDDD,
                     E.TXREFERENCIA_ENDERECO,
                     E.AORESIDE_EXTERIOR,
                     E.TPLOGRADOURO_PTU,
                     P.CDPRESTADOR
                FROM PRESTADOR P, ENDERECO E
               WHERE NOT EXISTS (SELECT 1
                      --Antonio 07/11/16
                      --Inclui a tabela tipo de endereco e estou filtrando enderecos de Prestadores e com N e N no PF e PJ
                      --Inclui estas condicoes no "not exists" porque na query de cima está assim (somente consultório)
                        FROM ENDERECO E, TIPO_DE_ENDERECO TP
                       WHERE P.NRREGISTRO_PREST = E.NRREGISTRO
                         AND TP.TPENDERECO = E.TPENDERECO
                         AND TP.AOPRESTADOR = 'S')
                    --                       AND TP.AOPESSOAFISICA = 'N'
                    --                       AND TP.AOPESSOAJURIDICA = 'N'
                    --   AND P.TPPRESTADOR NOT IN ('B', 'N', 'R')
                 AND E.NRREGISTRO = PNRENDERECO
                 AND E.TPENDERECO = 'COBR') ENDPRES,
             CIDADE CID,
             PRESTADOR_ESTABELECIMENTO PE,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_TIPO_ENDERECO'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) ENDER,
             (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                FROM mig_tab_conversao TC, mig_tab_conversao_exp CE
               WHERE NOTABELA = 'MIGRACAO_CIDADE'
                 AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCI
       WHERE ENDPRES.NRREGISTRO = PE.NRREGISTRO_PREST(+)
         AND ENDPRES.TPENDERECO = PE.CDTIPO_ENDERECO(+)
         AND ENDER.CDVALOR_INTERNO(+) = ENDPRES.TPENDERECO
         AND ENDPRES.CDCIDADE = CID.CDCIDADE(+)
         AND CID.CDCIDADE = RCI.CDVALOR_INTERNO(+)
         AND ENDPRES.NRREGISTRO = PNRREGISTRO_PREST;
  
    VAOCATEGORIA_DIFERENCIADA VARCHAR2(1);
    VPOSSUIESPEC              VARCHAR2(1);
    --VTOTALIMPORTADO           NUMBER;
    VAOIMPORTADO     VARCHAR2(1);
    VCDESPECIALIDADE NUMBER;
    lg_erro_aux varchar2(1) := 'N';
    ix_prestador number := 0;
    ix_insert_prestador number := 0;
    qt_erros_aux number := 0;
    
    vEndereco                Varchar2(40);
    vEndereco_semComplemento Varchar2(40);
    vComplemento_Endereco    Varchar2(10);
  
  BEGIN

    IF PZERA_BASE = '1' THEN
    
      DELETE FROM TEMP_MIGRACAO_PRESTADOR;
      DELETE FROM TEMP_MIGRACAO_ENDERECO_PREST;
      DELETE FROM TEMP_MIGRACAO_PREST_VINC_ESPEC;
      COMMIT;
    
    END IF;
  
    IF PZERA_BASE = '2' THEN
    
      DELETE FROM TEMP_MIGRACAO_PRESTADOR;
      DELETE FROM TEMP_MIGRACAO_ENDERECO_PREST;
      DELETE FROM TEMP_MIGRACAO_PREST_VINC_ESPEC;
      DELETE FROM GP.PRESERV;
      DELETE FROM GP.PREVIESP;
      DELETE FROM GP.ENDPRES;
      DELETE FROM GP.HISTPREST;
      DELETE FROM GP.PTUGRSER;
      DELETE FROM GP.PREST_AREA_ATU;
      DELETE FROM GP.PRESTDOR_ENDER;
      DELETE FROM GP.PRESTDOR_END_INSTIT;
      delete from gp.prestdor_obs;
      COMMIT;
    
    END IF;
  
 DBMS_OUTPUT.ENABLE(null);
  
    FOR RPRESTADOR IN CUR_PRESTADOR Loop
      vEndereco                := RPRESTADOR.ENDERECO;
      vEndereco_semComplemento := RPRESTADOR.ENDERECO_SEM_COMPLEMENTO;
      vComplemento_Endereco    := RPRESTADOR.COMPLEMENTO_ENDERECO;
    
      ix_prestador := ix_prestador + 1;
      begin
        select 'S' into VAOIMPORTADO
          from temp_migracao_prestador tmp
          where tmp.nrunidade = rprestador.unidade
            and tmp.cdprestador = rprestador.codigo_prestador;
      exception
        when others then
          VAOIMPORTADO := 'N';
      end;
          
      VAOERRO      := 'N';

--DBMS_OUTPUT.PUT_LINE( 'ponto 1' || RPRESTADOR.CDFORNECEDOR);
--DBMS_OUTPUT.PUT_LINE( 'ponto 2' || RPRESTADOR.NM_ABREV);
--DBMS_OUTPUT.PUT_LINE( 'ponto 3' || RPRESTADOR.TPFLUXO);

      BEGIN
        SELECT F.CDN_FORNECEDOR, F.U##NOM_ABREV, FF.COD_TIP_FLUXO_FINANC
          INTO RPRESTADOR.CDFORNECEDOR, RPRESTADOR.NM_ABREV, RPRESTADOR.TPFLUXO
          FROM TI_PESSOA P, EMS5.FORNECEDOR F, EMS5.FORNEC_FINANC FF
         WHERE --P.NOABREVIADO_FORNECEDOR = F.NOM_ABREV
           --AND P.NRCGC_CPF = F.U##COD_ID_FEDER
               P.NRREGISTRO = RPRESTADOR.NRREGISTRO_PREST
           and p.cdn_fornecedor = f.cdn_fornecedor
           and ff.cdn_fornecedor = f.cdn_fornecedor;

--DBMS_OUTPUT.PUT_LINE( 'ponto 4' || RPRESTADOR.CDFORNECEDOR);
--DBMS_OUTPUT.PUT_LINE( 'ponto 5' || RPRESTADOR.NM_ABREV);
--DBMS_OUTPUT.PUT_LINE( 'ponto 6' || RPRESTADOR.TPFLUXO);
           
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RPRESTADOR.CDFORNECEDOR := NULL;
          RPRESTADOR.NM_ABREV := NULL;
          /*Alex 19/01/2017 - teste deixando nome abreviado nulo, visto que nao achou FORNEC_FINANC*/
          BEGIN
            SELECT P.NOABREVIADO_FORNECEDOR
              INTO RPRESTADOR.NM_ABREV
              FROM TI_PESSOA P
             WHERE P.NRREGISTRO = RPRESTADOR.NRREGISTRO_PREST;
--DBMS_OUTPUT.PUT_LINE( 'buscando nome-abrev de ti_pessoa: ' || rprestador.nm_abrev);
          EXCEPTION
            WHEN OTHERS THEN
              --RPRESTADOR.NM_ABREV := 'p' || rprestador.nrregistro_prest;
              --Passamos a enviar as 12 primeiras posicoes do nome abreviado mesmo
              --que gere duplicidade. Isto porque o prestador não é cliente e nem
              --fornecedor. Neste caso, se já existir um fornecedor com este nome
              --abreviado e o usuário quiser integrar este, ele terá que alterá-lo
              --para um que não exista no cadastro de fornecedores.
              RPRESTADOR.NM_ABREV := f_abrevia_nome(rprestador.nopessoa,
                                                    12,
                                                    'PEA');
--DBMS_OUTPUT.PUT_LINE( 'criando nome-abrev: ' || rprestador.nm_abrev);
              
          end;
      END;
      
--DBMS_OUTPUT.PUT_LINE( 'ponto 7' || RPRESTADOR.CDFORNECEDOR);
--DBMS_OUTPUT.PUT_LINE( 'ponto 8' || RPRESTADOR.NM_ABREV);
--DBMS_OUTPUT.PUT_LINE( 'ponto 9' || RPRESTADOR.TPFLUXO);
      
      IF VAOIMPORTADO = 'N' THEN
        VCONT := VCONT + 1;
      
        BEGIN
          SELECT DECODE(COUNT(1), 0, 'N', 'S')
            INTO VAOCATEGORIA_DIFERENCIADA
            FROM REDE_REFERENCIA_PREST RRP1, REDE_REFERENCIA RRF
           WHERE RRP1.NRREGISTRO_PREST = RPRESTADOR.NRREGISTRO_PREST
             AND RRF.CDREDE_REFERENCIA = RRP1.CDREDE_REFERENCIA
             AND (RRP1.DTEXCLUSAO > TRUNC(SYSDATE) OR
                 RRP1.DTEXCLUSAO IS NULL)
             AND RRF.AOREDE_MASTER = 'S';
        
          IF NVL(RPRESTADOR.AOTABELA_PROPRIA, 'N') = 'N' THEN
            RPRESTADOR.TIPOREDE := '1';
          ELSE
            IF VAOCATEGORIA_DIFERENCIADA = 'N' THEN
              RPRESTADOR.TIPOREDE := '2';
            ELSIF VAOCATEGORIA_DIFERENCIADA = 'S' THEN
              RPRESTADOR.TIPOREDE := '3';
            ELSE
              RPRESTADOR.TIPOREDE := '1';
            END IF;
          END IF;
        
        EXCEPTION
          WHEN OTHERS THEN
            NULL;
        END;
      
        BEGIN
          RPRESTADOR.TXOBSERVACAO1 := RPRESTADOR.TXOBSERVACAO1 / 1;
        EXCEPTION
          WHEN OTHERS THEN
            RPRESTADOR.TXOBSERVACAO1 := '';
        END;
      
       /*
        Evandro Levi (23/05/2018): Adicionado novo tratamento no endereço, se mesmo com as composições abaixo
           não atender ao tamanho total de caracteres permitidos no TOTVS, como alternativa, o complemento
           ficará separado, com limite de 10 caracteres (aceitos pelo EMS), se ainda existir inconsistência,
           a migração do prestador será interrompida e as informações serão apresentadas no DBMS_OUTPUT.
        */
        -- Buscar outro endereco se nao existir de cobranca
        IF RPRESTADOR.NRREGISTRO_ENDERECO IS NULL THEN
          BEGIN
            SELECT --logradouro + nrimovel + complemento
                   case
                     --logradouro + nrimovel + txcomplemento <= 40
                     when length(e.nologradouro ||
                                 decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                 decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
                       e.nologradouro ||
                       decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                       decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
                     --logradouro reduz + nrimovel + txcomplemento <= 40
                     when length(ems506unicoo.f_reduz_end(nologradouro, 0) ||
                                 decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                 decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)) <= 40 then
                       ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                       decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                       decode(e.txcomplemento, null, null, ' ' || e.txcomplemento)
                     --logradouro reduz + nrimovel + txcomplemento reduz <= 40
                     when length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                                 decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                 decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                     ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
                       ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                       decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                       decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                     ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
                     -- logradouro reduz abrev + nrimovel + complemento reduz <= 40
                     when length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                                 decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                                 decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                     ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))) <= 40 then
                       ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                       decode(e.nrimovel, null, null, ' ' || e.nrimovel) ||
                       decode(ems506unicoo.f_reduz_compl(e.txcomplemento, 0), null, null,
                                                     ' ' || ems506unicoo.f_reduz_compl(e.txcomplemento, 0))
                   End ENDERECO,
                   -- logradouro + nrimovel
                   Case
                     --logradouro + nrimovel <= 40
                     When length(e.nologradouro || decode(e.nrimovel, null, null, ' ' || e.nrimovel)) <= 40 Then
                       e.nologradouro || decode(e.nrimovel, null, null, ' ' || e.nrimovel)
                     --logradouro reduz + nrimovel <= 40
                     When length(ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                                 decode(e.nrimovel, null, null, ' ' || e.nrimovel)) <= 40 Then
                       ems506unicoo.f_reduz_end(e.nologradouro, 0) ||
                       decode(e.nrimovel, null, null, ' ' || e.nrimovel)
                     --logradouro reduz abrev + nrimovel <= 40
                     When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                                 decode(e.nrimovel, null, null, ' ' || e.nrimovel)) <= 40 Then
                       ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.nologradouro, 0), 0) ||
                       decode(e.nrimovel, null, null, ' ' || e.nrimovel)
                   End ENDERECO_SEM_COMPLEMENTO,
                   -- complemento: max de 10 caracteres devido ao limite do cadastro de endereço do EMS
                   Case
                     --complemento
                     When length(E.TXCOMPLEMENTO) <= 10 Then
                       E.TXCOMPLEMENTO
                     --complemento reduz
                     When length(ems506unicoo.f_reduz_compl(e.txcomplemento, 0)) <= 10 Then
                       ems506unicoo.f_reduz_compl(e.txcomplemento, 0)
                     --complemento reduz abrev
                     When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)) <= 10 Then
                       ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(e.txcomplemento, 0),0)
                   End COMPLEMENTO_ENDERECO,
                   NVL(E.NOBAIRRO, 'NAO INFORMADO') NOBAIRRO,
                   NVL(RCI.CDVALOR_EXTERNO, E.CDCIDADE) CDCIDADE,
                   FN_TIRARMASCARA(E.NRCEP, 8) NRCEP,
                   CID.CDESTADO
              INTO --RPRESTADOR.ENDERECO,
                   vEndereco,
                   vEndereco_semComplemento,
                   vComplemento_Endereco,              
                   RPRESTADOR.BAIRRO,
                   RPRESTADOR.NRCIDADE,
                   RPRESTADOR.CEP,
                   RPRESTADOR.CDESTADO
              FROM ENDERECO E,
                   CIDADE CID,
                   (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                      FROM mig_tab_conversao_exp CE, mig_tab_conversao TC
                     WHERE NOTABELA = 'MIGRACAO_CIDADE'
                       AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCI
             WHERE E.NRREGISTRO = RPRESTADOR.NRREGISTRO_PREST
               AND E.CDCIDADE = CID.CDCIDADE(+)
               AND CID.CDCIDADE = RCI.CDVALOR_INTERNO(+)
               AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              SELECT case
                       --logradouro + nrimovel + txcomplemento <= 40
                       when length(ENDPRES.nologradouro ||
                                   decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                                   decode(ENDPRES.txcomplemento, null, null, ' ' || ENDPRES.txcomplemento)) <= 40 then
                         ENDPRES.nologradouro ||
                         decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                         decode(ENDPRES.txcomplemento, null, null, ' ' || ENDPRES.txcomplemento)
                       --logradouro reduz + nrimovel + txcomplemento <= 40
                       when length(ems506unicoo.f_reduz_end(ENDPRES.nologradouro, 0) ||
                                   decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                                   decode(ENDPRES.txcomplemento, null, null, ' ' || ENDPRES.txcomplemento)) <= 40 then
                         ems506unicoo.f_reduz_end(ENDPRES.nologradouro, 0) ||
                         decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                         decode(ENDPRES.txcomplemento, null, null, ' ' || ENDPRES.txcomplemento)
                       --logradouro reduz + nrimovel + txcomplemento reduz <= 40
                       when length(ems506unicoo.f_reduz_end(ENDPRES.nologradouro, 0) ||
                                   decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                                   decode(ems506unicoo.f_reduz_compl(ENDPRES.txcomplemento, 0), null, null,
                                                       ' ' || ems506unicoo.f_reduz_compl(ENDPRES.txcomplemento, 0))) <= 40 then
                         ems506unicoo.f_reduz_end(ENDPRES.nologradouro, 0) ||
                         decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                         decode(ems506unicoo.f_reduz_compl(ENDPRES.txcomplemento, 0), null, null,
                                                       ' ' || ems506unicoo.f_reduz_compl(ENDPRES.txcomplemento, 0))
                       -- logradouro reduz abrev + nrimovel + complemento reduz <= 40
                       when length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(ENDPRES.nologradouro, 0), 0) ||
                                   decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                                   decode(ems506unicoo.f_reduz_compl(ENDPRES.txcomplemento, 0), null, null,
                                                       ' ' || ems506unicoo.f_reduz_compl(ENDPRES.txcomplemento, 0))) <= 40 then
                         ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(ENDPRES.nologradouro, 0), 0) ||
                         decode(ENDPRES.nrimovel, null, null, ' ' || ENDPRES.nrimovel) ||
                         decode(ems506unicoo.f_reduz_compl(txcomplemento, 0), null, null,
                                                       ' ' || ems506unicoo.f_reduz_compl(txcomplemento, 0))
                     End ENDERECO,
                     -- logradouro + nrimovel
                     Case
                       --logradouro + nrimovel <= 40
                       When length(endpres.nologradouro || decode(endpres.nrimovel, null, null, ' ' || endpres.nrimovel)) <= 40 Then
                         endpres.nologradouro || decode(endpres.nrimovel, null, null, ' ' || endpres.nrimovel)
                       --logradouro reduz + nrimovel <= 40
                       When length(ems506unicoo.f_reduz_end(endpres.nologradouro, 0) ||
                                   decode(endpres.nrimovel, null, null, ' ' || endpres.nrimovel)) <= 40 Then
                         ems506unicoo.f_reduz_end(endpres.nologradouro, 0) ||
                         decode(endpres.nrimovel, null, null, ' ' || endpres.nrimovel)
                       --logradouro reduz abrev + nrimovel <= 40
                       When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(endpres.nologradouro, 0), 0) ||
                                   decode(endpres.nrimovel, null, null, ' ' || endpres.nrimovel)) <= 40 Then
                         ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(endpres.nologradouro, 0), 0) ||
                         decode(endpres.nrimovel, null, null, ' ' || endpres.nrimovel)
                     End ENDERECO_SEM_COMPLEMENTO,
                     -- complemento: max de 10 caracteres devido ao limite do cadastro de endereço do EMS
                     Case
                       --complemento
                       When length(endpres.TXCOMPLEMENTO) <= 10 Then
                         endpres.TXCOMPLEMENTO
                       --complemento reduz
                       When length(ems506unicoo.f_reduz_compl(endpres.txcomplemento, 0)) <= 10 Then
                         ems506unicoo.f_reduz_compl(endpres.txcomplemento, 0)
                       --complemento reduz abrev
                       When length(ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(endpres.txcomplemento, 0),0)) <= 10 Then
                         ems506unicoo.f_reduz_end_abrev(ems506unicoo.f_reduz_end(endpres.txcomplemento, 0),0)
                     End COMPLEMENTO_ENDERECO,
                     NVL(ENDPRES.NOBAIRRO, 'NAO INFORMADO') NOBAIRRO,
                     NVL(RCI.CDVALOR_EXTERNO, ENDPRES.CDCIDADE) CDCIDADE,
                     FN_TIRARMASCARA(ENDPRES.NRCEP, 8) NRCEP,
                     CID.CDESTADO
                INTO --RPRESTADOR.ENDERECO,
                     vEndereco,
                     vEndereco_semComplemento,
                     vComplemento_Endereco,
                     RPRESTADOR.BAIRRO,
                     RPRESTADOR.NRCIDADE,
                     RPRESTADOR.CEP,
                     RPRESTADOR.CDESTADO
                FROM (SELECT P.NRREGISTRO_PREST NRREGISTRO,
                             E.TPENDERECO,
                             E.NOLOGRADOURO,
                             E.NRIMOVEL,
                             E.TXCOMPLEMENTO,
                             E.NOBAIRRO,
                             E.CDCIDADE,
                             E.CDESTADO,
                             E.NRCEP,
                             E.NRTELEFONE,
                             E.NRFAX,
                             E.NOCONTATO,
                             E.NOCARGOCONTATO,
                             nvl(E.CDEMAIL,E.CDEMAIL_ADICIONAL),
                             E.TXOBSERVACOES,
                             E.AOCORRESPONDENCIA,
                             E.NOOPERADOR,
                             E.NRCELULAR,
                             E.AOSITUACAO,
                             E.NRDDD,
                             E.TXREFERENCIA_ENDERECO,
                             E.AORESIDE_EXTERIOR,
                             E.TPLOGRADOURO_PTU,
                             P.CDPRESTADOR
                        FROM PRESTADOR P, ENDERECO E
                       WHERE NOT Exists (SELECT 1 FROM ENDERECO E
                                         WHERE P.NRREGISTRO_PREST = E.NRREGISTRO)
                         --AND P.TPPRESTADOR NOT IN ('B', 'N', 'R')
                         AND E.NRREGISTRO = PNRENDERECO
                         AND E.TPENDERECO = 'COBR') ENDPRES,
                     CIDADE CID,
                     (SELECT CDVALOR_EXTERNO, CDVALOR_INTERNO
                        FROM mig_tab_conversao_exp CE, mig_tab_conversao TC
                       WHERE NOTABELA = 'MIGRACAO_CIDADE'
                         AND TC.NRSEQ = CE.NRSEQ_TAB_CONVERSAO) RCI
               WHERE ENDPRES.NRREGISTRO = RPRESTADOR.NRREGISTRO_PREST
                 AND ENDPRES.CDCIDADE = CID.CDCIDADE(+)
                 AND CID.CDCIDADE = RCI.CDVALOR_INTERNO(+)
                 AND ROWNUM = 1;
          END;
        END IF;
        
        /* Evandro Levi (23/05/2018): Validar endereço antes de gravar na temp,
              se o endereço estiver nulo, o prestador não será gravado e será
              reportado no DBMS_OUTPUT.
         */
        If (Trim(vEndereco) Is Null And Trim(vEndereco_semComplemento) Is Null) Then
          VAOERRO := 'S'; --bloquear inclusão do prestador
          qt_erros_aux := qt_erros_aux + 1;
          lg_erro_aux := 'S';
          dbms_output.put_line('Erro ao buscar dados do ENDERECO PRINCIPAL para o prestador: ' ||
                               rprestador.unidade || '-' || rprestador.codigo_prestador ||
                               '. Possivel falha LOGRADOURO + NR.IMOVEL + COMPLEMENTO maior que 40 caracteres. NRREGISTRO_PRESTADOR_UNICOO: ' || 
                               rprestador.nrregistro_prest);
        Else
          If (Trim(vEndereco) is Null And Trim(vEndereco_semComplemento) Is not Null) Then
            RPRESTADOR.ENDERECO := Trim(vEndereco_semComplemento);
            RPRESTADOR.COMPLEMENTO_ENDERECO := Trim(vComplemento_Endereco);
          Else
            RPRESTADOR.ENDERECO := Trim(vEndereco);
            RPRESTADOR.COMPLEMENTO_ENDERECO := Null;
          End If;
        End If;
        
        --BUSCAR DADOS BANCARIOS DO FORNECEDOR NO EMS5
        BEGIN
          SELECT nvl(trim(FF.COD_PORTADOR), PPORTADOR),
                 nvl(trim(FF.COD_BANCO), PBANCO),
                 substr(TRIM(FF.COD_AGENC_BCIA), 0, 8),
                 TRIM(FF.COD_CTA_CORREN_BCO),
                 TRIM(FF.COD_DIGITO_AGENC_BCIA),
                 TRIM(decode(upper(FF.COD_DIGITO_CTA_CORREN),'X',0,' ',0,null,0,FF.COD_DIGITO_CTA_CORREN)),
                 TRIM(FF.COD_FORMA_PAGTO),
                 FF.COD_TIP_FLUXO_FINANC
            INTO pNRPORTADOR_aux,
                 pNRBANCO_aux,
                 pCDAGENCIA_aux,
                 pCDCONTA_CORRENTE_aux,
                 pCDDIGITO_AGENCIA_aux,
                 pCDDIGITO_CONTA_CORRENTE_aux,
                 pCDFORMA_PAGTO_aux,
                 pTPFLUXO_aux
            FROM EMS5.FORNEC_FINANC FF
           WHERE FF.CDN_FORNECEDOR = RPRESTADOR.CDFORNECEDOR;
        EXCEPTION
          WHEN no_data_found THEN
            pCDAGENCIA_aux               := NULL;
            pCDCONTA_CORRENTE_aux        := NULL;
            pCDDIGITO_AGENCIA_aux        := NULL;
            pCDDIGITO_CONTA_CORRENTE_aux := NULL;
            pNRPORTADOR_aux              := PPORTADOR;
            pNRBANCO_aux                 := PBANCO;
            pCDFORMA_PAGTO_aux           := '01';
            pTPFLUXO_aux                 := PDESPESA;
          when others then
              qt_erros_aux := qt_erros_aux + 1;
              lg_erro_aux := 'S';
--              RAISE_APPLICATION_ERROR(-20102,
--                                      'Erro ao buscar dados do FORNEC_FINANC. ' ||
--                                      SQLERRM);
              dbms_output.put_line('Erro ao buscar dados do FORNEC_FINANC para o prestador: ' ||
                                   rprestador.unidade || '-' || rprestador.codigo_prestador || ' - ' ||
                                   'Fornecedor EMS5: ' || RPRESTADOR.CDFORNECEDOR || ' - ' ||
                                   SQLERRM);
          
        END;
        BEGIN
          SELECT 'S'
            INTO VEXISTE_BANCO
            FROM EMS5.BANCO B
           WHERE B.U##COD_BANCO = RPRESTADOR.NRBANCO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            pCDAGENCIA_aux               := NULL;
            pCDCONTA_CORRENTE_aux        := NULL;
            pCDDIGITO_AGENCIA_aux        := NULL;
            pCDDIGITO_CONTA_CORRENTE_aux := NULL;
            pNRPORTADOR_aux              := PPORTADOR;
            pNRBANCO_aux                 := PBANCO;
          
        END;
        begin
          RPRESTADOR.NRPORTADOR := nvl(RPRESTADOR.NRPORTADOR,pnrportador_aux);
          RPRESTADOR.NRBANCO := nvl(RPRESTADOR.NRBANCO,pnrbanco_aux);
          RPRESTADOR.CDAGENCIA := nvl(RPRESTADOR.CDAGENCIA,pcdagencia_aux);
          RPRESTADOR.CDCONTA_CORRENTE := nvl(RPRESTADOR.CDCONTA_CORRENTE,pcdconta_corrente_aux);
          RPRESTADOR.CDDIGITO_AGENCIA := nvl(RPRESTADOR.CDDIGITO_AGENCIA,pcddigito_agencia_aux);
          RPRESTADOR.CDDIGITO_CONTA_CORRENTE := nvl(RPRESTADOR.CDDIGITO_CONTA_CORRENTE,pcddigito_conta_corrente_aux);
          RPRESTADOR.CDFORMA_PAGTO := nvl(RPRESTADOR.CDFORMA_PAGTO,pcdforma_pagto_aux);
          RPRESTADOR.TPFLUXO := nvl(RPRESTADOR.TPFLUXO,ptpfluxo_aux);
        exception
          when others then
              qt_erros_aux := qt_erros_aux + 1;
              lg_erro_aux := 'S';
--              RAISE_APPLICATION_ERROR(-20102,
--                                      'Erro ao buscar dados do FORNEC_FINANC. ' ||
--                                      SQLERRM);
              dbms_output.put_line('Erro ao carregar dados do FORNEC_FINANC para o prestador: ' || 
                                   rprestador.unidade || '-' || rprestador.codigo_prestador || ' - ' ||
                                   'Fornecedor: ' || rprestador.cdfornecedor || ' - ' ||
                                   SQLERRM);
              dbms_output.put_line('   nvl(RPRESTADOR.NRPORTADOR,pnrportador_aux): ' || nvl(RPRESTADOR.NRPORTADOR,pnrportador_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.NRBANCO,pnrbanco_aux): ' || nvl(RPRESTADOR.NRBANCO,pnrbanco_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.CDAGENCIA,pcdagencia_aux): ' || nvl(RPRESTADOR.CDAGENCIA,pcdagencia_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.CDCONTA_CORRENTE,pcdconta_corrente_aux): ' || nvl(RPRESTADOR.CDCONTA_CORRENTE,pcdconta_corrente_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.CDDIGITO_AGENCIA,pcddigito_agencia_aux): ' || nvl(RPRESTADOR.CDDIGITO_AGENCIA,pcddigito_agencia_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.CDDIGITO_CONTA_CORRENTE,pcddigito_conta_corrente_aux): ' || nvl(RPRESTADOR.CDDIGITO_CONTA_CORRENTE,pcddigito_conta_corrente_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.CDFORMA_PAGTO,pcdforma_pagto_aux): ' || nvl(RPRESTADOR.CDFORMA_PAGTO,pcdforma_pagto_aux));
              dbms_output.put_line('   nvl(RPRESTADOR.TPFLUXO,ptpfluxo_aux): ' || nvl(RPRESTADOR.TPFLUXO,ptpfluxo_aux));
        END;

      
        --IR
        RPRESTADOR.CDIMPOSTO         := FN_BUSCA_IMPOSTO('IR',
                                                         RPRESTADOR.TPPESSOA,
                                                         RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.CDCLASSIF_IMPOSTO := FN_BUSCA_CLASS_IMPOSTO('IR',
                                                               RPRESTADOR.TPPESSOA,
                                                               RPRESTADOR.CDFORNECEDOR);
      
        --COFINS       
        RPRESTADOR.CDIMPOSTO_COFINS := FN_BUSCA_IMPOSTO('COFINS',
                                                        RPRESTADOR.TPPESSOA,
                                                        RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.CDCLASSIF_COFINS := FN_BUSCA_CLASS_IMPOSTO('COFINS',
                                                              RPRESTADOR.TPPESSOA,
                                                              RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.AOCALCULA_COFINS := CASE
                                         WHEN RPRESTADOR.CDIMPOSTO_COFINS IS NULL THEN
                                          'N'
                                         ELSE
                                          'S'
                                       END;
      
        --PISPASE
        RPRESTADOR.CDIMPOSTO_PISPASEP := FN_BUSCA_IMPOSTO('PIS',
                                                          RPRESTADOR.TPPESSOA,
                                                          RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.CDCLASSIF_PISPASEP := FN_BUSCA_CLASS_IMPOSTO('PIS',
                                                                RPRESTADOR.TPPESSOA,
                                                                RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.AOCALCULA_PIS := CASE
                                      WHEN RPRESTADOR.CDIMPOSTO_PISPASEP IS NULL THEN
                                       'N'
                                      ELSE
                                       'S'
                                    END;
      
        --CSLL
        RPRESTADOR.CDIMPOSTO_CSLL := FN_BUSCA_IMPOSTO('CSLL',
                                                      RPRESTADOR.TPPESSOA,
                                                      RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.CDCLASSIF_CSLL := FN_BUSCA_CLASS_IMPOSTO('CSLL',
                                                            RPRESTADOR.TPPESSOA,
                                                            RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.AOCALCULA_CSLL := CASE
                                       WHEN RPRESTADOR.CDIMPOSTO_CSLL IS NULL THEN
                                        'N'
                                       ELSE
                                        'S'
                                     END;
      
        --INSS
        RPRESTADOR.CDIMPOSTO_INSS := FN_BUSCA_IMPOSTO('INSS',
                                                      RPRESTADOR.TPPESSOA,
                                                      RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.CDCLASSIF_INSS := FN_BUSCA_CLASS_IMPOSTO('INSS',
                                                            RPRESTADOR.TPPESSOA,
                                                            RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.AORECOLHE_INSS := CASE
                                       WHEN RPRESTADOR.CDIMPOSTO_INSS IS NULL THEN
                                        'N'
                                       ELSE
                                        'S'
                                     END;

        --ISS
        RPRESTADOR.CDIMPOSTO_ISS := FN_BUSCA_IMPOSTO('ISS',
                                                     RPRESTADOR.TPPESSOA,
                                                     RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.CDCLASSIF_ISS := FN_BUSCA_CLASS_IMPOSTO('ISS',
                                                           RPRESTADOR.TPPESSOA,
                                                           RPRESTADOR.CDFORNECEDOR);
        RPRESTADOR.AOCALCULA_ISS := CASE
                                      WHEN RPRESTADOR.CDIMPOSTO_ISS IS NULL THEN
                                       'N'
                                      ELSE
                                       'S'
                                    END;
      
        --VERIFICA SE OS IMPOSTOS CSLL PIS E COFINS ESTAO COMO "S"
        IF RPRESTADOR.AOCALCULA_CSLL = 'S' AND
           RPRESTADOR.AOCALCULA_PIS = 'S' AND
           RPRESTADOR.AOCALCULA_COFINS = 'S' THEN
        
          --COFINS       
          RPRESTADOR.CDIMPOSTO_COFINS := NULL;
          RPRESTADOR.CDCLASSIF_COFINS := NULL;
          RPRESTADOR.AOCALCULA_COFINS := 'N';
        
          --PISPASE
          RPRESTADOR.CDIMPOSTO_PISPASEP := NULL;
          RPRESTADOR.CDCLASSIF_PISPASEP := NULL;
          RPRESTADOR.AOCALCULA_PIS      := 'N';
        
          --CSLL
          RPRESTADOR.CDIMPOSTO_CSLL := NULL;
          RPRESTADOR.CDCLASSIF_CSLL := NULL;
          RPRESTADOR.AOCALCULA_CSLL := 'N';
        
          --SE ESTIVEREM É INFORMADO IMPOSTO UNICOO
          RPRESTADOR.CDIMPOSTO_UNICO         := PCDIMPOSTO_UNICOO;
          RPRESTADOR.CDCLASSIF_UNICO         := PCDCLAS_IMPTO_UNICOO;
          RPRESTADOR.AOCALCULA_IMPOSTO_UNICO := 'S';
          
        END IF;
      
        BEGIN
          SELECT 1
            INTO VAOEXISTECEP
            FROM GP.DZ_CADCEP D
           WHERE D.CD_UF = RPRESTADOR.CDESTADO
             AND D.CD_CIDADE = RPRESTADOR.NRCIDADE
             AND D.CD_CEP = RPRESTADOR.CEP
             AND ROWNUM = 1;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          
            --ANTONIO 07/11/2016
            --COMENTAMOS PARA DEIXAR ENTRAR O ENDERECO MESMO QUE NÃO EXISTA NA TABELA DE CEPS
          
            VAOEXISTECEP := 1;
          
        END;
      
        IF VAOERRO = 'N' THEN
          BEGIN
            ix_insert_prestador := ix_insert_prestador + 1;
            
            INSERT INTO TEMP_MIGRACAO_PRESTADOR
              (NRSEQUENCIAL,
               NRUNIDADE,
               CDPRESTADOR,
               NOPRESTADOR,
               NOABREVIADO,
               TPPESSOA,
               NRGRUPO_PRESTADOR,
               AOMEDICO,
               AOCREDENCIADO,
               NRUNIDADE_SECCIONAL,
               CDCONSELHO,
               CDESTADO_CONSELHO,
               NRCRM,
               CDFORNECEDOR,
               ENDERECO,
               BAIRRO,
               CDCIDADE,
               CEP,
               CDESTADO,
               DTINCLU_PRESTADOR,
               DTEXCLU_PRESTADOR,
               CDSEXO,
               DTNASCIMENTO,
               NRINSCRI_PRESTADOR,
               CDSITUACAO_SINDICAL,
               VLFATOR_PRODUTIVIDADE, --
               AOPOSSUI_ALVARA,
               AOREGISTRO_INSS,
               AOPOSSUI_DIPLOMA,
               NRESPEC_RESIDENCIA,
               NRESPEC_TITULO,
               AORECEBE_MALOTE,
               AOPOSSUI_VINC_EMPREGATICIO,
               NRULTIMO_MES_INSS,
               NRRAMAL1,
               NRRAMAL2,
               CGC_CPF,
               AOREPRESENTA_UNIDADE,
               NRHORARIO_URGENCIA,
               AORECOLHE_INSS,
               AORECOLHE_PARTICIPACAO,
               TXOBSERVACAO1,
               TXOBSERVACAO2,
               TXOBSERVACAO3,
               AOCALC_IMPOSTO_RENDA,
               NRINDICE_IRRF,
               AOCALC_ADIANTAMENTO,
               DTCALC_ADIANTAMENTO,
               NRDEPENDENTES,
               AOPAGTO_RH,
               EMAIL,
               TPFLUXO,
               CDIMPOSTO,
               CDCLASSIFIC_IMPOSTO,
               NRPIS_PASEP,
               NRINSS,
               AODIVIDE_HONORARIO,
               AOCALC_COFINS,
               AOCALC_PIS_PASEP,
               AOCALC_CSLL,
               CDCOFINS,
               CDPIS_PASEP,
               CDCSLL,
               CDCLASSIFIC_COFINS,
               CDCLASSIFIC_PIS_PASEP,
               CDCLASSIFIC_CSLL,
               CDINSS,
               CDCLASSIFIC_INSS,
               AOCALC_ISS,
               CDISS,
               CDCLASSIFIC_ISS,
               AODEDUZ_ISS_PRODUCAO,
               NRDIAS_VALID_RECONS,
               NRPORTADOR,
               NRMODALIDADE,
               NRBANCO,
               CDAGENCIA,
               CDCONTA_CORRENTE,
               CDDIGITO_AGENCIA,
               CDDIGITO_CONTA,
               CDFORMA_PAGTO,
               AOCALC_PIS_COFINS_CSLL_PROCED,
               AOCALC_PIS_COFINS_CSLL_INSU,
               AOCALC_IMPOSTO_UNICO,
               CDIMPOSTO_UNICO,
               CDCLASSIFIC_IMPOSTO_UNICO,
               TPCLASSIFIC_ESTABELECIMENTO,
               CDCNES,
               NODIRETOR_TEC,
               NRREGISTRO_ANS,
               DTINI_CONTRATUALIZACAO,
               NATUREZA_DOC_IDENT,
               CDIDENTIDADE,
               ORGAO_EMISSOR_IDENT,
               PAIS_EMISSOR_IDENT,
               CDESTADO_EMISSOR_IDENT,
               DTEMISSAO_DOC_IDENT,
               NACIONALIDADE,
               NRTELEFONE1,
               NRTELEFONE2,
               TPDISPONIBILIDADE,
               AOCOOP_MEDICA,
               AOREDE_ACIDENTE_TRABALHO,
               AOPRATICA_TAB_PROPRIA,
               NRPERFIL_ASSIT_HOSPITAL,
               TPPRODUTO,
               AOIND_PUBLIC_GUIA_MEDICO,
               SGCONSELHO_DIRETOR_TEC,
               CDCONSELHO_DIRETOR_TEC,
               CDESTADO_CONSELHO_DIRETOR_TEC,
               TPREDE,
               AOPARTICIP_NOTIVISA,
               AOPARTICIP_QUALIS,
               AOENVIA_CADU,
               NRREGISTRO_PREST,
               AOPUBLICA_ANS,
               RESID_MEDICA,
               NOFANTASIA,
               TXCOMPLEMENTO_ENDERECO )
            VALUES
              (VCONT,
               RPRESTADOR.UNIDADE,
               DECODE(PNRUNIMED,
                      023,
                      DECODE(RPRESTADOR.CODIGO_PRESTADOR,
                             '28001',
                             '28002',
                             '24000',
                             '24002',
                             RPRESTADOR.CODIGO_PRESTADOR),
                      RPRESTADOR.CODIGO_PRESTADOR),
               RPRESTADOR.NOPESSOA,
               RPRESTADOR.NM_ABREV,
               RPRESTADOR.TPPESSOA,
               RPRESTADOR.CDGRUPO_PREST,
               RPRESTADOR.AOMEDICO,
               RPRESTADOR.AOCREDENCIADO,
               RPRESTADOR.UNIDADE_SECCIONAL,
               RPRESTADOR.CDCONSELHO_PROF,
               RPRESTADOR.CDESTADO_CONSELHO,
               RPRESTADOR.NRCRM,
               RPRESTADOR.CDFORNECEDOR,
               RPRESTADOR.ENDERECO,
               RPRESTADOR.BAIRRO,
               RPRESTADOR.NRCIDADE,
               RPRESTADOR.CEP,
               RPRESTADOR.CDESTADO,
               RPRESTADOR.DTADMISSAO,
               RPRESTADOR.DTEXCLUSAO,
               RPRESTADOR.CDSEXO,
               RPRESTADOR.DTNASCIMENTO,
               RPRESTADOR.INSC_PREST_UNIDADE,
               RPRESTADOR.CDSITUACAO_SINDICAL,
               RPRESTADOR.VLFATOR_UTIVIDADE,
               RPRESTADOR.AOALVARA,
               RPRESTADOR.AOPOSSUI_REG_INSS,
               RPRESTADOR.AOPOSSUI_DIPLOMA,
               RPRESTADOR.NRESPEC_RESID,
               RPRESTADOR.NRESPEC_TIT,
               RPRESTADOR.AOMALOTE,
               RPRESTADOR.AOVINCULO_EMPREGATICIO,
               RPRESTADOR.NRULT_MES_INSS,
               RPRESTADOR.NRRAMAL1,
               RPRESTADOR.NRRAMAL2,
               RPRESTADOR.NRCPF_CNPJ,
               RPRESTADOR.AOREPRES_UNIDADE,
               RPRESTADOR.CDHOR_URGENCIA,
               RPRESTADOR.AORECOLHE_INSS,
               RPRESTADOR.AORECOLHE_PARTICIPACAO,
               RPRESTADOR.TXOBSERVACAO1,
               RPRESTADOR.TXOBSERVACAO2,
               RPRESTADOR.TXOBSERVACAO3,
               RPRESTADOR.AOCALCULA_IR,
               RPRESTADOR.NRIND_IRRF,
               RPRESTADOR.AOCALCULA_ADIANTAMENTO,
               RPRESTADOR.DTCALCULA_ADIANTAMENTO,
               RPRESTADOR.NRDEPENDENTE,
               RPRESTADOR.AOPAGTORH,
               RPRESTADOR.EMAIL,
               RPRESTADOR.TPFLUXO,
               RPRESTADOR.CDIMPOSTO,
               RPRESTADOR.CDCLASSIF_IMPOSTO,
               RPRESTADOR.NRPIS,
               RPRESTADOR.NRREGISTROINSS,
               RPRESTADOR.AODIVIDE_HONOR,
               RPRESTADOR.AOCALCULA_COFINS,
               RPRESTADOR.AOCALCULA_PIS,
               RPRESTADOR.AOCALCULA_CSLL,
               RPRESTADOR.CDIMPOSTO_COFINS,
               RPRESTADOR.CDIMPOSTO_PISPASEP,
               RPRESTADOR.CDIMPOSTO_CSLL,
               RPRESTADOR.CDCLASSIF_COFINS,
               RPRESTADOR.CDCLASSIF_PISPASEP,
               RPRESTADOR.CDCLASSIF_CSLL,
               RPRESTADOR.CDIMPOSTO_INSS,
               RPRESTADOR.CDCLASSIF_INSS,
               RPRESTADOR.AOCALCULA_ISS,
               RPRESTADOR.CDIMPOSTO_ISS,
               RPRESTADOR.CDCLASSIF_ISS,
               RPRESTADOR.AODEDUZ_ISS_UC,
               RPRESTADOR.PRZ_RETORNO,
               RPRESTADOR.NRPORTADOR,
               RPRESTADOR.NRMODALIDADE,
               RPRESTADOR.NRBANCO,
               RPRESTADOR.CDAGENCIA,
               RPRESTADOR.CDCONTA_CORRENTE,
               RPRESTADOR.CDDIGITO_AGENCIA,
               RPRESTADOR.CDDIGITO_CONTA_CORRENTE,
               RPRESTADOR.CDFORMA_PAGTO,
               RPRESTADOR.AOCALCULA_PIS_COFINS_CSLL_PROC,
               RPRESTADOR.AOCALCULA_PIS_COFINS_CSLL_INSU,
               RPRESTADOR.AOCALCULA_IMPOSTO_UNICO,
               RPRESTADOR.CDIMPOSTO_UNICO,
               RPRESTADOR.CDCLASSIF_UNICO,
               RPRESTADOR.TPCLASSIF_ESTABELEC,
               RPRESTADOR.NRCNES,
               RPRESTADOR.NOPROPRIETARIO,
               RPRESTADOR.NRREG_ANS_PREST,
               RPRESTADOR.DTINICIO_CONTRATUALIZACAO,
               RPRESTADOR.CDNATUREZA_DOC,
               RPRESTADOR.NRINSCEST_RG,
               RPRESTADOR.NOORGAO_EMISSOR_RG,
               RPRESTADOR.CDPAIS_EMISSOR_ID,
               RPRESTADOR.CDESTADO_EMISSOR_RG,
               RPRESTADOR.DTEXPEDICAO_RG,
               RPRESTADOR.CDNACIONALIDADE,
               RPRESTADOR.TELEFONE1,
               RPRESTADOR.TELEFONE2,
               RPRESTADOR.TPDISPONIBILIDADE,
               RPRESTADOR.AOCOOP_MEDICA,
               RPRESTADOR.AOACIDENTE_TRABALHO,
               RPRESTADOR.AOTABELA_PROPRIA,
               RPRESTADOR.CDPERFIL_ASSISTENCIAL,
               RPRESTADOR.TPRODUTO,
               RPRESTADOR.AOGUIA_MEDICO,
               RPRESTADOR.CDCONSELHO,
               RPRESTADOR.CDREGISTRO_CONSELHO,
               RPRESTADOR.CDESTADO_CONSELHO_DIR,
               RPRESTADOR.TIPOREDE,
               RPRESTADOR.AOPARTICIP_NOTIVISA,
               RPRESTADOR.AOPARTICIP_QUALIS,
               RPRESTADOR.AOENVIA_CADU,
               RPRESTADOR.NRREGISTRO_PREST,
               RPRESTADOR.AOPUBLICA_ANS,
               RPRESTADOR.RESID_MEDICA,
               RPRESTADOR.NOFANTASIA,
               RPRESTADOR.COMPLEMENTO_ENDERECO);
               
            VQTREGISTRO1 := VQTREGISTRO1 + 1;
          
            COUNTOFRECORDS := COUNTOFRECORDS + 1;
          
            IF (COUNTOFRECORDS >= 1000) THEN
              --COMMIT;
              COUNTOFRECORDS := 0;
            END IF;
          
          EXCEPTION
            WHEN OTHERS THEN
              lg_erro_aux := 'S';
              qt_erros_aux := qt_erros_aux + 1;
--              RAISE_APPLICATION_ERROR(-20102,
--                                      'Erro na inclus¿¿o do prestador. ' ||
--                                      SQLERRM);
              dbms_output.put_line('Erro na inclusao do prestador: ' || 
                                   rprestador.unidade || '-' || rprestador.codigo_prestador || ' - ' ||
                                   SQLERRM);
          END;
        
          VPOSSUIESPEC := 'N';
        
          FOR RPRESTVINCESPEC IN CUR_PREST_VINC_ESPEC(RPRESTADOR.NRREGISTRO_PREST) LOOP
            BEGIN
            
              VPOSSUIESPEC     := 'S';
              VCDESPECIALIDADE := 0;
            
              BEGIN
                VCDESPECIALIDADE := TO_NUMBER(TRUNC(RPRESTVINCESPEC.CDESPECIALIDADE));
              EXCEPTION
                WHEN OTHERS THEN
                  VCDESPECIALIDADE := TO_NUMBER(TRUNC(RPRESTVINCESPEC.CDESPECIALIDADE_AUTORIZADOR));
              END;
            
              INSERT INTO TEMP_MIGRACAO_PREST_VINC_ESPEC
                (NRSEQUENCIAL,
                 NRVINCULO,
                 NRESPECIALIDADE,
                 AOESPEC_PRINCIPAL,
                 AOCONSID_QTD_VINCULO,
                 CDREG_ESPECIALIDADE,
                 TPCONTRATUALIZACAO,
                 AOPOSSUI_REG_CERTIFIC_ESPEC,
                 DTINIC_VINC,
                 DTFIN_VINC,
                 CDSITUACAO,
                 NRREG_QUALIFICACAO_ESPEC, 
                 NRREG_QUALIFICACAO_ESPEC_2,
                 CDGINEC_OBSTR,
                 CDRESIDENCIA
                 )
              VALUES
                (VCONT,
                 RPRESTVINCESPEC.NRVINCULO,
                 TO_CHAR(VCDESPECIALIDADE),
                 RPRESTVINCESPEC.AOESPEC_PRINCIPAL,
                 RPRESTVINCESPEC.AOCONSID_QTD_VINCULO,
                 RPRESTVINCESPEC.CDAMB,
                 RPRESTVINCESPEC.TPCONTRATUALIZACAO,
                 RPRESTVINCESPEC.AOPOSSUICERTIFICACAO,
                 NVL(RPRESTADOR.DTADMISSAO, '01011900'),
                 decode(rprestador.dtexclusao,
                        null,
                        decode(rprestvincespec.cdsituacao,
                               '0', -- ativo
                               '31129999', -- se ativo, maior data possivel
                               replace(f_tm_parametro('DTFIM_ESPECIALIDADES_INATIVAS'),'/','')),
                        rprestador.dtexclusao),
                 RPRESTVINCESPEC.CDSITUACAO,
                 --Evandro Levi (17/05/2018): Implementado para carregar os registros de qualificação da especialidade
                 RPRESTVINCESPEC.NRREG_QUALIFICACAO_ESPEC,
                 RPRESTVINCESPEC.NRREG_QUALIFICACAO_ESPEC_2,
                 RPRESTVINCESPEC.CDGINEC_OBSTR,
                 RPRESTVINCESPEC.CDRESIDENCIA);
                           
              VQTREGISTRO2 := VQTREGISTRO2 + 1;
            
              COUNTOFRECORDS := COUNTOFRECORDS + 1;
            
              IF (COUNTOFRECORDS >= 1000) THEN
                --COMMIT;
                COUNTOFRECORDS := 0;
              END IF;
            
            EXCEPTION
              WHEN OTHERS THEN
                qt_erros_aux := qt_erros_aux + 1;
                lg_erro_aux := 'S';
--                RAISE_APPLICATION_ERROR(-20102,
--                                        'Erro na inclusao da(s) especialidade(s) do Prestador : ' ||
--                                        SQLERRM);
                dbms_output.put_line('Erro na inclusao da(s) especialidade(s) do Prestador : ' || 
                                   rprestador.unidade || '-' || rprestador.codigo_prestador || ' - ' ||
                SQLERRM);
            END;
          END LOOP;
        
          IF VPOSSUIESPEC = 'N' AND RPRESTADOR.TPPRESTADOR = '9' THEN
            INSERT INTO TEMP_MIGRACAO_PREST_VINC_ESPEC
              (NRSEQUENCIAL,
               NRVINCULO,
               NRESPECIALIDADE,
               AOESPEC_PRINCIPAL,
               AOCONSID_QTD_VINCULO,
               CDREG_ESPECIALIDADE,
               TPCONTRATUALIZACAO,
               AOPOSSUI_REG_CERTIFIC_ESPEC)
            VALUES
              (VCONT, '03', '01', 'S', 'N', '1000', NULL, 'N');
          
            VQTREGISTRO2 := VQTREGISTRO2 + 1;
          END IF;
        
          FOR RPRESTENDERECO IN CUR_PREST_ENDERECO(RPRESTADOR.Nrregistro_Prest) LOOP
            Begin
              VAOERRO := 'N';
              vEndereco                := RPRESTENDERECO.NOLOGRADOURO;
              vEndereco_semComplemento := RPRESTENDERECO.ENDERECO_SEM_COMPLEMENTO;
              vComplemento_Endereco    := RPRESTENDERECO.COMPLEMENTO_ENDERECO;
            
              BEGIN
                SELECT 'S'
                  INTO VAOEXISTECEP
                  FROM GP.DZ_CADCEP D
                 WHERE D.U##CD_UF = RPRESTENDERECO.CDESTADO
                   AND D.CD_CIDADE = RPRESTENDERECO.CDCIDADE
                   AND D.CD_CEP = RPRESTENDERECO.NRCEP
                   AND ROWNUM = 1;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  --ANTONIO 07/11/2016
                  --COMENTAMOS PARA DEIXAR ENTRAR O ENDERECO MESMO QUE NÃO EXISTA NA TABELA DE CEPS
                  VAOEXISTECEP := 'S';
                  --RPRESTENDERECO.CDESTADO     := PCDESTADODEFAULT;
              END;

              /* Evandro Levi (23/05/2018): Validar endereço antes de gravar na temp,
                    se o endereço estiver nulo, o prestador não será gravado e será
                    reportado no DBMS_OUTPUT.
               */
              If (Trim(vEndereco) Is Null And Trim(vEndereco_semComplemento) Is Null) Then
                VAOERRO := 'S'; --bloquear inclusão do endereço do prestador
                qt_erros_aux := qt_erros_aux + 1;
                lg_erro_aux := 'S';
                dbms_output.put_line('Erro ao buscar dados do ENDERECO para o prestador: ' ||
                                     rprestador.unidade || '-' || rprestador.codigo_prestador ||
                                     ' Tipo End.: ' || RPRESTENDERECO.TPENDERECO_UNICOO ||
                                     '. Possivel falha LOGRADOURO + NR.IMOVEL + COMPLEMENTO maior que 40 caracteres. NRREGISTRO_PRESTADOR_UNICOO: ' || 
                                     rprestador.nrregistro_prest);
              Else
                If (Trim(vEndereco) is Null And Trim(vEndereco_semComplemento) Is not Null) Then
                  RPRESTENDERECO.NOLOGRADOURO := Trim(vEndereco_semComplemento);
                  RPRESTENDERECO.COMPLEMENTO_ENDERECO := Trim(vComplemento_Endereco);
                Else
                  RPRESTENDERECO.NOLOGRADOURO := Trim(vEndereco);
                  RPRESTENDERECO.COMPLEMENTO_ENDERECO := Null;
                End If;
              End If;
            
              If (VAOERRO = 'N') Then
                INSERT INTO TEMP_MIGRACAO_ENDERECO_PREST
                  (NRSEQUENCIAL,
                   ENDERECO_PREST,
                   BAIRRO_PREST,
                   CDCIDADE_PREST,
                   CEP_PREST,
                   CDESTADO_PREST,
                   NRTELEFONE1_PREST,
                   NRTELEFONE2_PREST,
                   NRRAMAL1_PREST,
                   NRRAMAL2_PREST,
                   HRENTRADA_MANHA,
                   HRSAIDA_MANHA,
                   HRENTRADA_TARDE,
                   HRSAIDA_TARDE,
                   AOTRABALHA_SEGUNDA,
                   HRENTRADA_MANHA_SEG,
                   HRSAIDA_MANHA_SEG,
                   HRENTRADA_TARDE_SEG,
                   HRSAIDA_TARDE_SEG,
                   AOTRABALHA_TERCA,
                   HRENTRADA_MANHA_TER,
                   HRSAIDA_MANHA_TER,
                   HRENTRADA_TARDE_TER,
                   HRSAIDA_TARDE_TER,
                   AOTRABALHA_QUARTA,
                   HRENTRADA_MANHA_QUA,
                   HRSAIDA_MANHA_QUA,
                   HRENTRADA_TARDE_QUA,
                   HRSAIDA_TARDE_QUA,
                   AOTRABALHA_QUINTA,
                   HRENTRADA_MANHA_QUI,
                   HRSAIDA_MANHA_QUI,
                   HRENTRADA_TARDE_QUI,
                   HRSAIDA_TARDE_QUI,
                   AOTRABALHA_SEXTA,
                   HRENTRADA_MANHA_SEX,
                   HRSAIDA_MANHA_SEX,
                   HRENTRADA_TARDE_SEX,
                   HRSAIDA_TARDE_SEX,
                   AOTRABALHA_SABADO,
                   HRENTRADA_MANHA_SAB,
                   HRSAIDA_MANHA_SAB,
                   HRENTRADA_TARDE_SAB,
                   HRSAIDA_TARDE_SAB,
                   AOTRABALHA_DOMINGO,
                   HRENTRADA_MANHA_DOM,
                   HRSAIDA_MANHA_DOM,
                   HRENTRADA_TARDE_DOM,
                   HRSAIDA_TARDE_DOM,
                   AORECEBE_MALOTE_PREST,
                   AORECEBE_CORRESPONDENCIA,
                   TPENDERECO,
                   CDCNES_PREST,
                   NRLEITOS_TOTAIS,
                   NRLEITOS_CONTRATADOS,
                   NRLEITOS_PSIQUIATRIA,
                   NRLEITOS_UTI_ADULTO,
                   NRLEITOS_UTI_NEONATAL,
                   NRLEITOS_UTI_PEDIATRIA,
                   COMPLEMENTO_ENDERECO,
                   AOENDERECO_FILIAL,
                   CGC_CPF_FILIAL,
                   TPENDERECO_END,
                   TPENDERECO_UNICOO,
                   NRLEITOS_INTERMED_NEONATAL,
                   NRLEITOS_HOSPITAL_DIA,
                   NRLEITOS_TOT_PSIQU,
                   NRLEITOS_TOT_CIRUR,
                   NRLEITOS_TOT_PEDIAT,
                   NRLEITOS_TOT_OBSTR,
                   NRLATITUDE,
                   NRLONGITUDE,
                   NRLEITOS_INTERMED,
                   TXSITIOELETRONICO)
                VALUES
                  (VCONT,
                   RPRESTENDERECO.NOLOGRADOURO,
                   RPRESTENDERECO.NOBAIRRO,
                   RPRESTENDERECO.CDCIDADE,
                   RPRESTENDERECO.NRCEP,
                   RPRESTENDERECO.CDESTADO,
                   RPRESTENDERECO.NRTELEFONE1,
                   RPRESTENDERECO.NRTELEFONE2,
                   RPRESTENDERECO.RAMAL1,
                   RPRESTENDERECO.RAMAL2,
                   RPRESTENDERECO.HRENTRADA_MANHA,
                   RPRESTENDERECO.HRSAIDA_MANHA,
                   RPRESTENDERECO.HRENTRADA_TARDE,
                   RPRESTENDERECO.HRSAIDA_TARDE,
                   RPRESTENDERECO.AOTRABALHA_SEG,
                   RPRESTENDERECO.HRENTRADA_MANHA_SEG,
                   RPRESTENDERECO.HRSAIDA_MANHA_SEG,
                   RPRESTENDERECO.HRENTRADA_TARDE_SEG,
                   RPRESTENDERECO.HRSAIDA_TARDE_SEG,
                   RPRESTENDERECO.AOTRABALHA_TER,
                   RPRESTENDERECO.HRENTRADA_MANHA_TER,
                   RPRESTENDERECO.HRSAIDA_MANHA_TER,
                   RPRESTENDERECO.HRENTRADA_TARDE_TER,
                   RPRESTENDERECO.HRSAIDA_TARDE_TER,
                   RPRESTENDERECO.AOTRABALHA_QUA,
                   RPRESTENDERECO.HRENTRADA_MANHA_QUA,
                   RPRESTENDERECO.HRSAIDA_MANHA_QUA,
                   RPRESTENDERECO.HRENTRADA_TARDE_QUA,
                   RPRESTENDERECO.HRSAIDA_TARDE_QUA,
                   RPRESTENDERECO.AOTRABALHA_QUI,
                   RPRESTENDERECO.HRENTRADA_MANHA_QUI,
                   RPRESTENDERECO.HRSAIDA_MANHA_QUI,
                   RPRESTENDERECO.HRENTRADA_TARDE_QUI,
                   RPRESTENDERECO.HRSAIDA_TARDE_QUI,
                   RPRESTENDERECO.AOTRABALHA_SEX,
                   RPRESTENDERECO.HRENTRADA_MANHA_SEX,
                   RPRESTENDERECO.HRSAIDA_MANHA_SEX,
                   RPRESTENDERECO.HRENTRADA_TARDE_SEX,
                   RPRESTENDERECO.HRSAIDA_TARDE_SEX,
                   RPRESTENDERECO.AOTRABALHA_SAB,
                   RPRESTENDERECO.HRENTRADA_MANHA_SAB,
                   RPRESTENDERECO.HRSAIDA_MANHA_SAB,
                   RPRESTENDERECO.HRENTRADA_TARDE_SAB,
                   RPRESTENDERECO.HRSAIDA_TARDE_SAB,
                   RPRESTENDERECO.AOTRABALHA_DOM,
                   RPRESTENDERECO.HRENTRADA_MANHA_DOM,
                   RPRESTENDERECO.HRSAIDA_MANHA_DOM,
                   RPRESTENDERECO.HRENTRADA_TARDE_DOM,
                   RPRESTENDERECO.HRSAIDA_TARDE_DOM,
                   RPRESTENDERECO.AOMALOTE,
                   RPRESTENDERECO.AOCORRESPONDENCIA,
                   RPRESTENDERECO.TPENDERECO,
                   RPRESTENDERECO.NRCNES,
                   RPRESTENDERECO.NRLEITOS_TOTAIS,
                   RPRESTENDERECO.NRLEITOS_CONTRATADOS,
                   RPRESTENDERECO.NRLEITOS_PSIQUIATRIA,
                   RPRESTENDERECO.NRLEITOS_UTI_ADULTO,
                   RPRESTENDERECO.NRLEITOS_UTI_NEONATAL,
                   RPRESTENDERECO.NRLEITOS_UTI_PEDIATR,
                   --RPRESTENDERECO.TXCOMPLEMENTO,
                   --Evandro Levi (23/05/2018): Adicionado tratamento de até 10 caracteres no complemento
                   RPRESTENDERECO.COMPLEMENTO_ENDERECO, 
                   RPRESTENDERECO.AOFILIAL,
                   RPRESTENDERECO.NRCGC_CPFFILIAL,
                   RPRESTENDERECO.TPENDERECO_END,
                   RPRESTENDERECO.TPENDERECO_UNICOO,
                   RPRESTENDERECO.NRLEITOS_INTERMED_NEONATAL,
                   RPRESTENDERECO.NRLEITOS_HOSPITAL_DIA,
                   RPRESTENDERECO.NRLEITOS_TOT_PSIQU,
                   RPRESTENDERECO.NRLEITOS_TOT_CIRUR,
                   RPRESTENDERECO.NRLEITOS_TOT_PEDIAT,
                   RPRESTENDERECO.NRLEITOS_TOT_OBSTR,
                   RPRESTENDERECO.NRLATITUDE,
                   RPRESTENDERECO.NRLONGITUDE,
                   RPRESTENDERECO.NRLEITOS_INTERMED,
                   RPRESTENDERECO.TXSITIOELETRONICO);
              
                VQTREGISTRO3 := VQTREGISTRO3 + 1;
              
                COUNTOFRECORDS := COUNTOFRECORDS + 1;
              
                IF (COUNTOFRECORDS >= 1000) THEN
                 --COMMIT;
                  COUNTOFRECORDS := 0;
                END IF;

              End If; --VAOERRO
            
            EXCEPTION
              WHEN OTHERS THEN
--                RAISE_APPLICATION_ERROR(-20102,
--                                        'Erro na inclus¿¿o dos endere¿¿os do prestador : ' ||
--                                        SQLERRM);
                qt_erros_aux := qt_erros_aux + 1;
                lg_erro_aux := 'S';
                dbms_output.put_line('Erro na inclusao dos enderecos do prestador : ' || 
                                     rprestador.unidade || '-' || rprestador.codigo_prestador || ' - ' ||
                                     SQLERRM);
            END;
          END LOOP;
        END IF;
      else
        dbms_output.put_line('AVISO!!! PRESTADOR JA ESTA NA TEMPORARIA: ' || 
                             rprestador.unidade || '-' || rprestador.codigo_prestador);
      END IF;
      
    END LOOP;

    dbms_output.put_line('CONCLUIDO. QUANTIDADE DE PRESTADORES PROCESSADOS: ' || ix_prestador);
    dbms_output.put_line('           INSERTS: ' || ix_insert_prestador);
    dbms_output.put_line('           ERROS: ' || qt_erros_aux);

    COMMIT;
    
    if lg_erro_aux = 'S' then
       RAISE_APPLICATION_ERROR(-20102,
                              'Verifique os erros na aba OUTPUT (DBMS_OUTPUT)');
    end if;
    commit;  
  END P_GERA_PRESTADOR;

  --===============================================================================--
  -- Procedure será chamada no POS_CARGA_TXT e irá popular as seguintes tabelas:   --
  -- preserv    - ajustar id_pessoa
  -- tipoclin   - Tipos de Clinicas - De/para Tipos de Prestadores do Unicoo
  -- clinicas   - Cadstro de Clinicas
  -- clinpres   - Associativa Clinicas x Prestadores
  -- tipomaqu   - Tipos de Máquinas - Default 1-POS
  -- cadamaqu   - Cadastro de Máquinas - POS´s
  -- maquclin   - Associativia Máquinas x Clínicas
  --===============================================================================--

  PROCEDURE P_MAQUINA_PRESTADOR is
  
  begin
  
     --Criação dos tipos de clínicas
     --cada tipo de prestador virará um tipo de clinica
     for tpcl in (select rtce.cdvalor_externo, tp.notipo_prestador
                  from mig_tab_conversao rtc,
                       mig_tab_conversao_exp rtce,
                       tipo_de_prestador tp
                  where rtce.nrseq_tab_conversao = rtc.nrseq
                    and rtc.notabela='MIGRACAO_TP_PREST_TP_CLIN'
                    and tp.tpprestador  = rtce.cdvalor_interno)
     loop
     
        insert into tipoclin (cd_tipo_clinica,
                              ds_tipo_clinica,
                              cd_userid,
                              dt_atualizacao,
                              progress_recid)
                      values (tpcl.cdvalor_externo,      --tipo_clinica
                              tpcl.notipo_prestador,     --ds_tipo_clinica
                              'migracao',                --cd_useris
                              sysdate,                   --dt_atualizacao
                              gp.tipoclin_seq.nextval);
     
     end loop;

     --Criação das Clinicas e do Relacionamento Prestador Clinica
     for clin in (select p.cd_unidade, p.cd_prestador, p.nm_prestador, p.dt_inclusao, p.dt_exclusao, p.cd_grupo_prestador,
                         p.en_rua, p.en_bairro, p.cd_cidade, p.en_cep, p.en_uf, p.nm_email, p.nr_telefone##1, p.nr_telefone##2,
                         c.nm_cidade, re.cdvalor_externo, decode(p.lg_cooperado,1,'E','A') in_tipo_atendimento
                  from preserv p,
                       dzcidade c,
                       prestador pr,
                       (select cdvalor_externo, cdvalor_interno
                        from mig_tab_conversao_exp ce, mig_tab_conversao tc
                       where notabela = 'MIGRACAO_TP_PREST_TP_CLIN'
                         and tc.nrseq = ce.nrseq_tab_conversao) re
                  where pr.nrregistro_prest   = p.id_pessoa
                    and pr.cdprestador        = p.cd_prestador
                    and re.cdvalor_interno    = pr.tpprestador
                    and c.cd_cidade           = p.cd_cidade)
     loop
     
        --Criação das Clinicas
        insert into clinicas (cd_clinica,
                              u##ds_clinica,
                              ds_clinica,
                              cd_tipo_clinica,
                              u##en_rua,
                              en_rua,
                              en_cidade,
                              u##en_bairro,
                              en_bairro,
                              en_cep,
                              en_uf,
                              cd_userid,
                              dt_atualizacao,
                              nr_telefone##1,
                              nr_telefone##2,
                              nm_email,
                              in_tipo_atendimento,
                              char_3,
                              dec_1,
                              char_5,
                              dec_3,
                              dec_4,
                              dec_5,
                              dt_atualizacao_senha,
                              date_2,
                              date_3,
                              date_4,
                              date_5,
                              cd_senha,
                              dec_2,
                              int_3,
                              int_4,
                              int_5,
                              u_char_1,
                              int_2,
                              u_char_3,
                              u_date_1,
                              u_date_2,
                              lg_senha_clin_prest,
                              lg_agenda,
                              log_3,
                              log_4,
                              log_5,
                              u_int_2,
                              u_char_2,
                              u_log_1,
                              u_log_2,
                              u_log_3,
                              u_date_3,
                              u_dec_1,
                              u_dec_2,
                              u_dec_3,
                              u_int_1,
                              u_int_3,
                              char_4,
                              ds_observacao,
                              char_2,
                              int_1,
                              lg_doctor,
                              date_1,
                              cd_unidade_prestador,
                              cd_prestador,
                              cd_senha_integracao,
                              cod_senha,
                              dat_alter_senha,
                              progress_recid)
                      values (clin.cd_prestador,                       --cd_clinica
                              clin.nm_prestador,                       --u##ds_clinica
                              clin.nm_prestador,                       --ds_clinica
                              clin.cdvalor_externo,                    --cd_tipo_clinica
                              clin.en_rua,                             --u##en_rua
                              clin.en_rua,                             --en_rua
                              clin.nm_cidade,                          --en_cidade
                              clin.en_bairro,                          --u##en_bairro
                              clin.en_bairro,                          --en_bairro,
                              clin.en_cep,                             --en_cep
                              clin.en_uf,                              --en_uf
                              'migracao',                              --cd_userid
                              sysdate,                                 --dt_atualizacao
                              clin.nr_telefone##1,                     --nr_telefone##1
                              clin.nr_telefone##2,                     --nr_telefone
                              clin.nm_email,                           --en_email
                              clin.in_tipo_atendimento,                --in_tipo_atendimento
                              ' ',                                     --char3
                              15,                                      --dec_1 -- Minutos Inativ Encerrar Sessao
                              ' ',                                     --char5
                              0,                                       --dec_3
                              0,                                       --dec_4
                              0,                                       --dec_5
                              null,                                    --dt_atualizacao_senha
                              null,                                    --date_2
                              null,                                    --date_3
                              null,                                    --date_4
                              null,                                    --date_5
                              0,                                       --cod_senha
                              0,                                       --dec_2
                              360,                                     --int_3 -- Dias validade senha
                              7,                                       --int_4 -- Dias antes aviso senha
                              5,                                       --int_5 -- Nr max login invalido
                              ' ',                                     --u_char_1
                              null,                                    --int_2 --cd_contratante
                              ' ',                                     --u_char_3
                              null,                                    --u_date_1
                              null,                                    --u_date_2
                              1,                                       --lg_senha_clin_prest
                              0,                                       --lg_agenda
                              0,                                       --log_3
                              0,                                       --log_4
                              0,                                       --log_5
                              0,                                       --u_int_2
                              ' ',                                     --u_char_2
                              0,                                       --u_log_1
                              0,                                       --u_log_2
                              0,                                       --u_log_3
                              null,                                    --u_date_3
                              0,                                       --u_dec_1
                              0,                                       --u_dec_2
                              0,                                       --u_dec_3
                              0,                                       --u_int_1
                              0,                                       --u_int_3
                              ' ',                                     --char_4
                              ' ',                                     --ds_observacao
                              ' ',                                     --char_2
                              clin.cd_cidade,                          --int_1 -- Cidade
                              0,                                       --lg_doctor --integracao doctor
                              '01/01/2015',                            --date_1 --dt inic segur tiss 3.00.01
                              clin.cd_unidade,                         --cd_unidade_prestador
                              clin.cd_prestador,                       --cd_prestador
                              ' ',                                     --cd_senha_integracao
                              ' ',                                     --cod_senha
                              null,                                    --dat_alter_senha
                              gp.clinicas_seq.nextval);                --progress_recid

        --Associação Clinica x Prestador
        insert into clinpres (cd_clinica,
                              cd_unidade,
                              cd_prestador,
                              lg_tipo_prestador,
                              cd_sit_cadastro,
                              dt_inclusao,
                              dt_exclusao,
                              cd_userid,
                              dt_atualizacao,
                              cd_trans_consulta,
                              cd_trans_proc_prest,
                              cd_trans_proc_cons,
                              char_1,
                              char_2,
                              char_3,
                              char_4,
                              char_5,
                              dec_3,
                              dec_4,
                              dec_5,
                              date_1,
                              date_2,
                              date_3,
                              date_4,
                              date_5,
                              dec_1,
                              dec_2,
                              cd_tipo_guia_consulta,
                              cd_tipo_guia_exec_lab,
                              cd_tipo_guia_exec_cons,
                              cd_trans_internacao,
                              cdtipoguiainternacao,
                              u_char_3,
                              u_date_1,
                              u_date_2,
                              lgobrigausorequisicao,
                              lgobrigareqprestador,
                              lg_qt_serv_dif_req,
                              lgpossuileitoracartao,
                              lg_maquina_web,
                              u_char_1,
                              u_char_2,
                              u_log_1,
                              u_log_2,
                              u_log_3,
                              u_date_3,
                              u_dec_1,
                              u_dec_2,
                              u_dec_3,
                              u_int_1,
                              u_int_2,
                              u_int_3,
                              cdtransacaorequisicao,
                              int_6,
                              int_7,
                              int_8,
                              int_9,
                              cd_local_autorizacao,
                              lg_pede_doc_operadora,
                              cd_local_atendimento,
                              lg_capturar_biometria,
                              lg_guia_autom,
                              char_11,
                              char_12,
                              char_13,
                              char_14,
                              char_15,
                              char_16,
                              char_17,
                              char_18,
                              char_19,
                              char_20,
                              dec_11,
                              dec_12,
                              dec_13,
                              dec_14,
                              dec_15,
                              dec_16,
                              dec_17,
                              dec_18,
                              dec_19,
                              dec_20,
                              date_11,
                              date_12,
                              date_13,
                              date_14,
                              date_15,
                              date_16,
                              date_17,
                              date_18,
                              date_19,
                              date_20,
                              int_11,
                              int_12,
                              int_13,
                              int_14,
                              int_15,
                              int_16,
                              int_17,
                              int_18,
                              int_19,
                              int_20,
                              log_11,
                              lg_rel_batch,
                              lg_clinica_fisio,
                              log_14,
                              log_15,
                              log_16,
                              log_17,
                              log_18,
                              log_19,
                              log_20,
                              log_22,
                              log_23,
                              cd_transacao_odonto,
                              cd_tipo_guia_odonto,
                              cdn_tip_guia_qui,
                              cdn_tip_guia_radio,
                              progress_recid)
                      values (clin.cd_prestador,                       --cd_clinica
                              clin.cd_unidade,                         --cd_unidade
                              clin.cd_prestador,                       --cd_prestador
                              0,                                       --lg_tipo_prestador
                              1,                                       --cd_sit_cadastro
                              clin.dt_inclusao,                        --dt_inclusao
                              clin.dt_exclusao,                        --dt_exclusao
                              'migracao',                              --cd_userid
                              sysdate,                                 --dt_atualizacao
                              1010,                                    --cod_transacao_consulta
                              1020,                                    --cod_transacao_proced
                              1010,                                    --cod_transacao_proced_consulta
                              'NAO',                                   --char_1 --nao encontrei na tela
                              ' ',                                     --char_2 --nao encontrei na tela
                              ' ',                                     --char_3 --nao encontrei na tela
                              ' ',                                     --char_4 --nao encontrei na tela
                              ' ',                                     --char_5 --nao encontrei na tela
                              0,                                       --dec_3
                              0,                                       --dec_4
                              0,                                       --dec_5
                              null,                                    --date_1
                              null,                                    --date_2
                              null,                                    --date_3
                              null,                                    --date_4
                              null,                                    --date_5
                              0,                                       --dec_1
                              0,                                       --dec_2
                              10,                                      --cod_tipo_guia_consulta
                              20,                                      --cod_tipo_guia_exex_lab
                              10,                                      --cod_tipo_guia_exec_cons
                              1030,                                    --cod_transacao_internacao
                              30,                                      --cod_tipo_guia_internacao
                              ' ',                                     --u_char_3
                              null,                                    --u_date_1
                              null,                                    --u_date_2
                              0,                                       --lgobrigausorequisicao,
                              0,                                       --lgobrigareqprestador,
                              0,                                       --lg_qt_serv_dif_req,
                              0,                                       --lgpossuileitoracartao,
                              0,                                       --lg_maquina_web,
                              ' ',                                     --u_char_1
                              ' ',                                     --u_char_2
                              0,                                       --u_log_1
                              0,                                       --u_log_2
                              0,                                       --u_log_3
                              null,                                    --u_date_3
                              0,                                       --u_dec_1
                              0,                                       --u_dec_2
                              0,                                       --u_dec_3
                              0,                                       --u_int_1
                              0,                                       --u_int_2
                              0,                                       --u_int_3
                              1020,                                    --cod_transacao_requisicao
                              0,                                       --int_6
                              1,                                       --int_7 --libra qte proc na guia
                              0,                                       --int_8
                              1,                                       --int_9 --autoriz com anexo tiss
                              1,                                       --cod_local_autorizacao
                              0,                                       --lg_pede_doc_operadora
                              0,                                       --cd_local_atendimento
                              0,                                       --lg_captura_biometrica
                              0,                                       --lg_guia_automatica
                              ' ',                                     --char_11
                              ' ',                                     --char_12
                              ' ',                                     --char_13
                              ' ',                                     --char_14
                              ' ',                                     --char_15
                              ' ',                                     --char_16
                              ' ',                                     --char_17
                              ' ',                                     --char_18
                              ' ',                                     --char_19
                              ' ',                                     --char_20
                              0,                                       --dec_11
                              0,                                       --dec_12
                              0,                                       --dec_13
                              0,                                       --dec_14
                              0,                                       --dec_15
                              0,                                       --dec_16
                              0,                                       --dec_17
                              0,                                       --dec_18
                              0,                                       --dec_19
                              0,                                       --dec_20
                              null,                                    --date_11
                              null,                                    --date_12
                              null,                                    --date_13
                              null,                                    --date_14
                              null,                                    --date_15
                              null,                                    --date_16
                              null,                                    --date_17
                              null,                                    --date_18
                              null,                                    --date_19
                              null,                                    --date_20
                              0,                                       --int_11
                              0,                                       --int_12
                              0,                                       --int_13
                              0,                                       --int_14
                              0,                                       --int_15
                              0,                                       --int_16
                              0,                                       --int_17
                              0,                                       --int_18
                              0,                                       --int_19
                              0,                                       --int_20
                              0,                                       --log_11
                              0,                                       --lg_rel_batch
                              0,                                       --lg_clinica_fisio
                              0,                                       --log_14
                              0,                                       --log_15
                              0,                                       --log_16
                              0,                                       --log_17
                              0,                                       --log_18
                              0,                                       --log_19
                              0,                                       --log_20
                              0,                                       --log_22
                              0,                                       --log_23
                              0,                                       --cd_transacao_odonto
                              0,                                       --cd_tipo_guia_odonto
                              0,                                       --cdn_tip_gui_qui
                              0,                                       --cdn_tip_gui_radio
                              gp.clinpres_seq.nextval);                --progress_recid
     end loop;

     --Criação do tipo de máquina POS
     insert into tipomaqu (cd_tipomaqu,
                           u##ds_tipomaqu,
                           ds_tipomaqu,
                           cd_userid,
                           dt_atualizacao,
                           progress_recid)
                   values (1,
                           'POS',
                           'POS',
                           'migracao',
                           sysdate,
                           gp.tipomaqu_seq.nextval);
                           
     --Criação máquina POS
     for pos in (select p.nrpos, p.txdescricao_pos, g.txdescricao_grupo
                 from pos p, grupo_pos g
                 where g.cdgrupo_pos(+) = p.cdgrupo_pos)
     loop

     insert into cadamaqu (nr_maquina,
                           cd_tipomaqu,
                           u##ds_maquina,
                           ds_maquina,
                           cd_userid,
                           dt_atualizacao,
                           nr_serie,
                           nr_patrimonio,
                           progress_recid)
                   values (pos.nrpos,                             --nr maquina
                           1,                                     --tipo maquina -- POS
                           substr(pos.txdescricao_pos,1,30),      --u##ds_maquina
                           substr(pos.txdescricao_pos,1,30),      --ds_maquina
                           'migracao',                            --cd_userid
                           sysdate,                               --dt_atualizacao
                           substr(pos.txdescricao_grupo,1,20),    --nr_serie
                           ' ',                                   --nr_patrimonio
                           gp.cadamaqu_seq.nextval);
     end loop;

     --Associação Máquinas x Clínicas
     for mc in (select pp.nrpos, pr.cdprestador, decode(pp.aosituacao_pos_prestador,'A',1,0) lg_status
                  from pos_prestador pp, prestador pr
                 where pr.nrregistro_prest = pp.nrregistro_prest)
     loop 
        insert into maquclin(nr_maquina,
                             cd_clinica,
                             lg_status,
                             dt_atualizacao,
                             cd_userid,
                             progress_recid)
                     values (mc.nrpos,
                             mc.cdprestador,
                             mc.lg_status,
                             sysdate,
                             'migracao',
                             gp.maquclin_seq.nextval);
     end loop;
  end P_MAQUINA_PRESTADOR;

  --===============================================================================--
  -- Procedure será chamada no POS_CARGA_TXT e irá popular as seguintes tabelas:   --
  --
  -- ambesp     - 
  -- proespse   - 
  -- pres_pro   - 
  --===============================================================================--

  procedure P_MIGRA_SERV_ESPEC is
     v      number;
     y      integer;
     tem    number;
     i      integer;

     Cursor C is
     select distinct
         to_number(substr(asd.cdservico,1,2)) cd_esp_amb,
         to_number(substr(asd.cdservico,3,2)) cd_grupo_proc_amb,
         to_number(substr(asd.cdservico,5,3)) cd_procedimento,
         to_number(substr(asd.cdservico,8,1)) dv_procedimento,
         se.CDESPECIALIDADE cd_especialid
     from
         producao.SERVICO_ESPECIALIDADE@unicoo_homologa se,
         producao.agrupamento_servico_detalhe@unicoo_homologa asd
     where se.cdagrupamento is not null
       and   se.cdagrupamento = asd.cdagrupamento
       and   asd.AOEXCETO = 'N'
       and   se.aoexclusao = 'N'
       and   length(asd.cdservico) = 8;

     Cursor C1 is
     select distinct
            se.cdespecialidade cd_especialid
       from
            producao.SERVICO_ESPECIALIDADE@unicoo_homologa se,
            producao.agrupamento_servico_detalhe@unicoo_homologa asd
      where se.cdagrupamento = asd.cdagrupamento
        and   asd.AOEXCETO = 'N'
        and   se.aoexclusao = 'N'
        and   length(asd.cdservico) < 8;


     Cursor w1 is
     select
        to_number(substr(s.cdservico,1,2)) cd_esp_amb,
        to_number(substr(s.cdservico,3,2)) cd_grupo_proc_amb,
        to_number(substr(s.cdservico,5,3)) cd_procedimento,
        to_number(substr(s.cdservico,8,1)) dv_procedimento
     from
        producao.servico@unicoo_homologa s
     where length(s.cdservico)=8 and s.cdservico like 
         (select distinct
                 asd.cdservico||'%'
            from
                 producao.SERVICO_ESPECIALIDADE@unicoo_homologa se,
                 producao.agrupamento_servico_detalhe@unicoo_homologa asd
           where se.cdagrupamento = asd.cdagrupamento
             and   asd.AOEXCETO = 'N'
             and   se.aoexclusao = 'N'
             and   length(asd.cdservico) < 8);

     Cursor C2 is
     select
           se.cdespecialidade,
           se.cdservico,
           se.cdsexo,
           se.nridade_minima,
           se.nridade_maxima
     from producao.SERVICO_ESPECIALIDADE@unicoo_homologa se
     where se.aoexclusao='N'
     and   se.cdsexo in ('M','F');

     Cursor C3 is
        select
           to_number(substr(se.cdservico,1,2)) cd_esp_amb,
           to_number(substr(se.cdservico,3,2)) cd_grupo_proc_amb,
           to_number(substr(se.cdservico,5,3)) cd_procedimento,
           to_number(substr(se.cdservico,8,1)) dv_procedimento,
           se.CDESPECIALIDADE cd_especialid
        from producao.SERVICO_ESPECIALIDADE@unicoo_homologa se
        where se.aoexclusao='N'
          and   se.cdagrupamento is null
          and   length(se.cdservico) = 8;

     Cursor c4 is
     select 
           substr(s.cdservico,1,2) cd_esp_amb,
           substr(s.cdservico,3,2) cd_grupo_proc_amb,
           substr(s.cdservico,5,3) cd_procedimento,
           substr(s.cdservico,8,1) dv_procedimento
     from
     producao.servico@unicoo_homologa s
     where length(s.cdservico) =8
       and   substr(s.cdservico,5,3) not like 'D%';

     Cursor D4 is
     select
           se.cdespecialidade
     from producao.SERVICO_ESPECIALIDADE@unicoo_homologa se
     where se.aoexclusao='N'
       and   se.cdagrupamento is null
       and   se.cdservico = '*';

     Cursor C5 is
       select 
           distinct
           to_number(pr.cdprestador) prestador,
           ce.cdvalor_externo vinculo,
           se.CDESPECIALIDADE cd_especialid,
           ac.cdprocedimentocompleto
       from
           producao.SERVICO_ESPECIALISTA@unicoo_homologa se,
           producao.agrupamento_servico_detalhe@unicoo_homologa asd,
           gp.ambproce ac,
           producao.prestador@unicoo_homologa pr,
           mig_tab_conversao tc,
           mig_tab_conversao_exp ce
       where se.cdagrupamento is not null
       and   se.cdagrupamento = asd.cdagrupamento
       and   asd.AOEXCETO = 'N'
       and   se.aoexclusao = 'N'
       and   length(asd.cdservico) = 8
       and   asd.cdservico = ac.cdprocedimentocompleto
       and   pr.nrregistro_prest = se.nrregistro_prest
       and   tc.notabela='MIGRACAO_TIPO_VINCULO'
       and   tc.nrseq = ce.nrseq_tab_conversao
       and   pr.tpprestador = ce.cdvalor_interno;

     Cursor C6 is
     select 
           to_number(pr.cdprestador) prestador,
           ce.cdvalor_externo vinculo,
           se.CDESPECIALIDADE cd_especialid,
           ac.cdprocedimentocompleto
       from
           producao.SERVICO_ESPECIALISTA@unicoo_homologa se,
           gp.ambproce ac,
           producao.prestador@unicoo_homologa pr,
           mig_tab_conversao tc,
           mig_tab_conversao_exp ce
       where se.cdagrupamento is null
       and   se.aoexclusao = 'N'
       and   length(se.cdservico) = 8
       and   pr.nrregistro_prest = se.nrregistro_prest
       and   tc.notabela='MIGRACAO_TIPO_VINCULO'
       and   tc.nrseq = ce.nrseq_tab_conversao
       and   pr.tpprestador = ce.cdvalor_interno
       and   se.cdservico = ac.CDPROCEDIMENTOCOMPLETO;

     Cursor c7 is
     select
        s.cdservico
     from
     producao.servico@unicoo_homologa s
     where length(s.cdservico) =8
     and   substr(s.cdservico,5,3) not like 'D%';
     
     Cursor D7 is
     select 
           to_number(pr.cdprestador) prestador,
           ce.cdvalor_externo vinculo,
           se.CDESPECIALIDADE cd_especialid
       from
           producao.SERVICO_ESPECIALISTA@unicoo_homologa se,
           producao.prestador@unicoo_homologa pr,
           mig_tab_conversao tc,
           mig_tab_conversao_exp ce
       where se.cdagrupamento is null
       and   se.aoexclusao = 'N'
       and   se.cdservico = '*'
       and   pr.nrregistro_prest = se.nrregistro_prest
       and   tc.notabela='MIGRACAO_TIPO_VINCULO'
       and   tc.nrseq = ce.nrseq_tab_conversao
       and   pr.tpprestador = ce.cdvalor_interno;

  begin
     delete from gp.ambesp;
     delete from gp.proespse;
     delete from gp.pres_pro;
     
     for v in c loop
  
        insert into gp.ambesp
             values (v.cd_esp_amb, --CD_ESP_AMB  NUMBER
                     v.cd_grupo_proc_amb, --CD_GRUPO_PROC_AMB  NUMBER
                     v.cd_procedimento,--CD_PROCEDIMENTO  NUMBER
                     v.dv_procedimento,--DV_PROCEDIMENTO  NUMBER
                     v.cd_especialid,--CD_ESPECIALID  NUMBER
                     0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     ' ',--DS_OBSERVACAO##1  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##2  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##3  VARCHAR2(152 BYTE)
                     sysdate,--DT_ATUALIZACAO  DATE
                     'MIGRACAO',--CD_USERID  VARCHAR2(24 BYTE)
                     0,--LG_PRINCIPAL  NUMBER
                     ' ',--CHAR_1  VARCHAR2(500 BYTE)
                     ' ',--CHAR_2  VARCHAR2(500 BYTE)
                     ' ',--CHAR_3  VARCHAR2(500 BYTE)
                     ' ',--CHAR_4  VARCHAR2(500 BYTE)
                     ' ',--CHAR_5  VARCHAR2(500 BYTE)
                     0,--LOG_5  NUMBER
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     0,--INT_1  NUMBER
                     0,--INT_2  NUMBER
                     0,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     ' ',--U_CHAR_1  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_2  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_3  VARCHAR2(40 BYTE)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     0,--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--U_INT_1  NUMBER
                     0,--U_INT_2  NUMBER
                     0,--U_INT_3  NUMBER
                     0,--U_LOG_1  NUMBER
                     0,--U_LOG_2  NUMBER
                     0,--U_LOG_3  NUMBER
                     NULL,--U_DATE_3  DATE
                     0,--U_DEC_1  NUMBER
                     0,--U_DEC_2  NUMBER
                     0,--U_DEC_3  NUMBER
                     ' ',--DES_OBSERVACAO  VARCHAR2(600 BYTE)
                     GP.AMBESP_SEQ.NEXTVAL --PROGRESS_RECID  NUMBER
                     );
                     
     END LOOP; --v

     tem := 0;

     for v1 in c1 loop
  
      for y1 in w1 loop
      
        begin

             select y1.cd_esp_amb||y1.cd_grupo_proc_amb||y1.cd_procedimento||y1.dv_procedimento into tem
                    from gp.ambesp
                    where cd_esp_amb        = y1.cd_esp_amb
                    and   cd_grupo_proc_amb = y1.cd_grupo_proc_amb
                    and   cd_procedimento   = y1.cd_procedimento
                    and   dv_procedimento   = y1.dv_procedimento
                    and   cd_especialid     = v1.cd_especialid;
          
        exception 
              when no_data_found then 
        insert into gp.ambesp
             values (y1.cd_esp_amb, --CD_ESP_AMB  NUMBER
                     y1.cd_grupo_proc_amb, --CD_GRUPO_PROC_AMB  NUMBER
                     y1.cd_procedimento,--CD_PROCEDIMENTO  NUMBER
                     y1.dv_procedimento,--DV_PROCEDIMENTO  NUMBER
                     v1.cd_especialid,--CD_ESPECIALID  NUMBER
                     0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     ' ',--DS_OBSERVACAO##1  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##2  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##3  VARCHAR2(152 BYTE)
                     sysdate,--DT_ATUALIZACAO  DATE
                     'MIGRACAO',--CD_USERID  VARCHAR2(24 BYTE)
                     0,--LG_PRINCIPAL  NUMBER
                     ' ',--CHAR_1  VARCHAR2(500 BYTE)
                     ' ',--CHAR_2  VARCHAR2(500 BYTE)
                     ' ',--CHAR_3  VARCHAR2(500 BYTE)
                     ' ',--CHAR_4  VARCHAR2(500 BYTE)
                     ' ',--CHAR_5  VARCHAR2(500 BYTE)
                     0,--LOG_5  NUMBER
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     0,--INT_1  NUMBER
                     0,--INT_2  NUMBER
                     0,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     ' ',--U_CHAR_1  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_2  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_3  VARCHAR2(40 BYTE)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     0,--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--U_INT_1  NUMBER
                     0,--U_INT_2  NUMBER
                     0,--U_INT_3  NUMBER
                     0,--U_LOG_1  NUMBER
                     0,--U_LOG_2  NUMBER
                     0,--U_LOG_3  NUMBER
                     NULL,--U_DATE_3  DATE
                     0,--U_DEC_1  NUMBER
                     0,--U_DEC_2  NUMBER
                     0,--U_DEC_3  NUMBER
                     ' ',--DES_OBSERVACAO  VARCHAR2(600 BYTE)
                     GP.AMBESP_SEQ.NEXTVAL --PROGRESS_RECID  NUMBER
                     );
          end;
      end loop; --y1
     end loop; --v1

     for v2 in c2 loop
      i:=1;
  
        for i in 1..2 loop
  
         insert into gp.proespse
             values (to_number(v2.cdservico),--CD_AMB  NUMBER
                     v2.cdespecialidade,--CD_ESPECIALID  NUMBER
                     i,--IN_TIPO_MOVIMENTO  NUMBER
                     UPPER(V2.cdsexo),--U##IN_SEXO  VARCHAR2(12)
                     v2.cdsexo,--IN_SEXO  VARCHAR2(12)
                     v2.nridade_minima,--NR_IDADE_MINIMA  NUMBER
                     decode(v2.nridade_maxima,999,0,v2.nridade_maxima),--NR_IDADE_MAXIMA  NUMBER
                     'MIGRACAO',--CD_USERID  VARCHAR2(24)
                     sysdate,--DT_ATUALIZACAO  DATE
                     ' ',--CHAR_1  VARCHAR2(500)
                     ' ',--CHAR_2  VARCHAR2(500)
                     ' ',--CHAR_3  VARCHAR2(500)
                     ' ',--CHAR_4  VARCHAR2(500)
                     ' ',--CHAR_5  VARCHAR2(500)
                     0,--INT_1  NUMBER
                     0,--INT_2  NUMBER
                     0,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     Decode(v2.nridade_minima,0,1,0),--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--LOG_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     ' ',--U_CHAR_1  VARCHAR2(40)
                     ' ',--U_CHAR_2  VARCHAR2(40)
                     ' ',--U_CHAR_3  VARCHAR2(40)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     NULL,--U_DATE_3  DATE
                     0,--U_DEC_1  NUMBER
                     0,--U_DEC_2  NUMBER
                     0,--U_DEC_3  NUMBER
                     0,--U_INT_1  NUMBER
                     0,--U_INT_2  NUMBER
                     0,--U_INT_3  NUMBER
                     0,--U_LOG_1  NUMBER
                     0,--U_LOG_2  NUMBER
                     0,--U_LOG_3	NUMBER
                     GP.PROESPSE_SEQ.NEXTVAL--PROGRESS_RECID	NUMBER
                     );
        end loop; --i
     end loop; --v2

     for v3 in c3 loop
  
        begin
       
             select v3.cd_esp_amb||v3.cd_grupo_proc_amb||v3.cd_procedimento||v3.dv_procedimento into tem
                    from gp.ambesp
                    where cd_esp_amb        = v3.cd_esp_amb
                    and   cd_grupo_proc_amb = v3.cd_grupo_proc_amb
                    and   cd_procedimento   = v3.cd_procedimento
                    and   dv_procedimento   = v3.dv_procedimento
                    and   cd_especialid     = v3.cd_especialid;
        exception 
              when no_data_found then 
        insert into gp.ambesp
             values (v3.cd_esp_amb, --CD_ESP_AMB  NUMBER
                     v3.cd_grupo_proc_amb, --CD_GRUPO_PROC_AMB  NUMBER
                     v3.cd_procedimento,--CD_PROCEDIMENTO  NUMBER
                     v3.dv_procedimento,--DV_PROCEDIMENTO  NUMBER
                     v3.cd_especialid,--CD_ESPECIALID  NUMBER
                     0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     ' ',--DS_OBSERVACAO##1  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##2  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##3  VARCHAR2(152 BYTE)
                     sysdate,--DT_ATUALIZACAO  DATE
                     'MIGRACAO',--CD_USERID  VARCHAR2(24 BYTE)
                     0,--LG_PRINCIPAL  NUMBER
                     ' ',--CHAR_1  VARCHAR2(500 BYTE)
                     ' ',--CHAR_2  VARCHAR2(500 BYTE)
                     ' ',--CHAR_3  VARCHAR2(500 BYTE)
                     ' ',--CHAR_4  VARCHAR2(500 BYTE)
                     ' ',--CHAR_5  VARCHAR2(500 BYTE)
                     0,--LOG_5  NUMBER
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     0,--INT_1  NUMBER
                     0,--INT_2  NUMBER
                     0,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     ' ',--U_CHAR_1  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_2  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_3  VARCHAR2(40 BYTE)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     0,--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--U_INT_1  NUMBER
                     0,--U_INT_2  NUMBER
                     0,--U_INT_3  NUMBER
                     0,--U_LOG_1  NUMBER
                     0,--U_LOG_2  NUMBER
                     0,--U_LOG_3  NUMBER
                     NULL,--U_DATE_3  DATE
                     0,--U_DEC_1  NUMBER
                     0,--U_DEC_2  NUMBER
                     0,--U_DEC_3  NUMBER
                     ' ',--DES_OBSERVACAO  VARCHAR2(600 BYTE)
                     GP.AMBESP_SEQ.NEXTVAL --PROGRESS_RECID  NUMBER
                     );
          end;
                     --commit;      
     END LOOP; --v3

     For Y4 in D4 loop
 
      For v4 in c4 loop
     
         begin
       
             select v4.cd_esp_amb||v4.cd_grupo_proc_amb||v4.cd_procedimento||v4.dv_procedimento into tem
                    from gp.ambesp
                    where cd_esp_amb        = v4.cd_esp_amb
                    and   cd_grupo_proc_amb = v4.cd_grupo_proc_amb
                    and   cd_procedimento   = v4.cd_procedimento
                    and   dv_procedimento   = v4.dv_procedimento
                    and   cd_especialid     = y4.cdespecialidade;
        exception 
              when no_data_found then 
        insert into gp.ambesp
             values (v4.cd_esp_amb, --CD_ESP_AMB  NUMBER
                     v4.cd_grupo_proc_amb, --CD_GRUPO_PROC_AMB  NUMBER
                     v4.cd_procedimento,--CD_PROCEDIMENTO  NUMBER
                     v4.dv_procedimento,--DV_PROCEDIMENTO  NUMBER
                     y4.cdespecialidade,--CD_ESPECIALID  NUMBER
                     0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     ' ',--DS_OBSERVACAO##1  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##2  VARCHAR2(152 BYTE)
                     ' ',--DS_OBSERVACAO##3  VARCHAR2(152 BYTE)
                     sysdate,--DT_ATUALIZACAO  DATE
                     'MIGRACAO',--CD_USERID  VARCHAR2(24 BYTE)
                     0,--LG_PRINCIPAL  NUMBER
                     ' ',--CHAR_1  VARCHAR2(500 BYTE)
                     ' ',--CHAR_2  VARCHAR2(500 BYTE)
                     ' ',--CHAR_3  VARCHAR2(500 BYTE)
                     ' ',--CHAR_4  VARCHAR2(500 BYTE)
                     ' ',--CHAR_5  VARCHAR2(500 BYTE)
                     0,--LOG_5  NUMBER
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     0,--INT_1  NUMBER
                     0,--INT_2  NUMBER
                     0,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     ' ',--U_CHAR_1  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_2  VARCHAR2(40 BYTE)
                     ' ',--U_CHAR_3  VARCHAR2(40 BYTE)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     0,--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--U_INT_1  NUMBER
                     0,--U_INT_2  NUMBER
                     0,--U_INT_3  NUMBER
                     0,--U_LOG_1  NUMBER
                     0,--U_LOG_2  NUMBER
                     0,--U_LOG_3  NUMBER
                     NULL,--U_DATE_3  DATE
                     0,--U_DEC_1  NUMBER
                     0,--U_DEC_2  NUMBER
                     0,--U_DEC_3  NUMBER
                     ' ',--DES_OBSERVACAO  VARCHAR2(600 BYTE)
                     GP.AMBESP_SEQ.NEXTVAL --PROGRESS_RECID  NUMBER
                     );
          end;
      end loop; --v4
     end loop; --y4

     for v5 in c5 loop
  
      insert into gp.pres_pro
             values (0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     PNRUNIMED,--CD_UNIDADE  NUMBER
                     v5.prestador,--CD_PRESTADOR  NUMBER
                     v5.vinculo,--CD_VINCULO  NUMBER
                     v5.cd_especialid,--CD_ESPECIALID  NUMBER
                     v5.cdprocedimentocompleto,--CD_PROCEDIMENTO  NUMBER
                     0,--LG_ACRESCIMO_PROCED  NUMBER
                     v5.vinculo,--IN_TIPO_PRESTADOR  NUMBER
                     'MIGRACAO',--CD_USERID  VARCHAR2(24)
                     sysdate,--DT_ATUALIZACAO	DATE
                     ' ',--CHAR_1	VARCHAR2(500)
                     ' ',--CHAR_2	VARCHAR2(500)
                     ' ',--CHAR_3	VARCHAR2(500)
                     ' ',--CHAR_4	VARCHAR2(500)
                     ' ',--CHAR_5	VARCHAR2(500)
                     0,--DEC_1	NUMBER
                     0,--DEC_2	NUMBER
                     0,--DEC_3	NUMBER
                     0,--DEC_4	NUMBER
                     0,--DEC_5	NUMBER
                     NULL,--DATE_1	DATE
                     NULL,--DATE_2	DATE
                     NULL,--DATE_3	DATE
                     NULL,--DATE_4	DATE
                     NULL,--DATE_5	DATE
                     0,--INT_1	NUMBER
                     3,--INT_2	NUMBER
                     1,--INT_3	NUMBER
                     0,--INT_4	NUMBER
                     0,--INT_5	NUMBER
                     0,--LOG_1	NUMBER
                     0,--LOG_2	NUMBER
                     0,--LOG_3	NUMBER
                     0,--LOG_4	NUMBER
                     0,--LOG_5	NUMBER
                     ' ',--U_CHAR_1	VARCHAR2(40)
                     ' ',--U_CHAR_2	VARCHAR2(40)
                     ' ',--U_CHAR_3	VARCHAR2(40)
                     NULL,--U_DATE_1	DATE
                     NULL,--U_DATE_2	DATE
                     NULL,--U_DATE_3	DATE
                     0,--U_INT_1	NUMBER
                     0,--U_INT_2	NUMBER
                     0,--U_INT_3	NUMBER
                     0,--U_LOG_1	NUMBER
                     0,--U_LOG_2	NUMBER
                     0,--U_LOG_3	NUMBER
                     0,--U_DEC_1	NUMBER
                     0,--U_DEC_2	NUMBER
                     0,--U_DEC_3	NUMBER
                     '31/12/9999',--DT_LIMITE	DATE
                     0,--CD_MODALIDADE	NUMBER
                     0,--NR_TER_ADESAO	NUMBER
                     0,--CD_PLANO	NUMBER
                     0,--CD_TIPO_PLANO	NUMBER
                     0,--CD_GRUPO_PROC	NUMBER
                     GP.PRES_PRO_SEQ.NEXTVAL --PROGRESS_RECID	NUMBER
                     );
                     
     END LOOP; --v5

     for v6 in c6 loop
  
      begin
      
       select CD_PROCEDIMENTO into tem
             from gp.pres_pro
             where CD_LOCAL_ATENDIMENTO = 0
             and   CD_UNIDADE=PNRUNIMED
             and   CD_PRESTADOR=v6.prestador
             and   CD_VINCULO=v6.vinculo
             and   CD_ESPECIALID=v6.cd_especialid
             and   CD_PROCEDIMENTO=v6.cdprocedimentocompleto
             and   CD_GRUPO_PROC=0
             and   CD_MODALIDADE=0
             and   CD_PLANO=0
             and   CD_TIPO_PLANO=0
             and   NR_TER_ADESAO=0
             and   DT_LIMITE='31/12/9999';
        exception 
              when no_data_found then 
  
        insert into gp.pres_pro
             values (0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     PNRUNIMED,--CD_UNIDADE  NUMBER
                     v6.prestador,--CD_PRESTADOR  NUMBER
                     v6.vinculo,--CD_VINCULO  NUMBER
                     v6.cd_especialid,--CD_ESPECIALID  NUMBER
                     v6.cdprocedimentocompleto,--CD_PROCEDIMENTO  NUMBER
                     0,--LG_ACRESCIMO_PROCED  NUMBER
                     v6.vinculo,--IN_TIPO_PRESTADOR  NUMBER
                     'MIGRACAO',--CD_USERID  VARCHAR2(24)
                     sysdate,--DT_ATUALIZACAO  DATE
                     ' ',--CHAR_1  VARCHAR2(500)
                     ' ',--CHAR_2  VARCHAR2(500)
                     ' ',--CHAR_3  VARCHAR2(500)
                     ' ',--CHAR_4  VARCHAR2(500)
                     ' ',--CHAR_5  VARCHAR2(500)
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     0,--INT_1  NUMBER
                     3,--INT_2  NUMBER
                     1,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     0,--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--LOG_5  NUMBER
                     ' ',--U_CHAR_1  VARCHAR2(40)
                     ' ',--U_CHAR_2  VARCHAR2(40)
                     ' ',--U_CHAR_3  VARCHAR2(40)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     NULL,--U_DATE_3  DATE
                     0,--U_INT_1	NUMBER
                     0,--U_INT_2	NUMBER
                     0,--U_INT_3	NUMBER
                     0,--U_LOG_1	NUMBER
                     0,--U_LOG_2	NUMBER
                     0,--U_LOG_3	NUMBER
                     0,--U_DEC_1	NUMBER
                     0,--U_DEC_2	NUMBER
                     0,--U_DEC_3	NUMBER
                     '31/12/9999',--DT_LIMITE	DATE
                     0,--CD_MODALIDADE	NUMBER
                     0,--NR_TER_ADESAO	NUMBER
                     0,--CD_PLANO	NUMBER
                     0,--CD_TIPO_PLANO	NUMBER
                     0,--CD_GRUPO_PROC	NUMBER
                     GP.PRES_PRO_SEQ.NEXTVAL --PROGRESS_RECID	NUMBER
                     );
       end;  --begin               
     END LOOP; --v6

     For Y7 in D7 loop
 
       For v7 in c7 loop
     
         begin
       
             select CD_PROCEDIMENTO into tem
             from gp.pres_pro
             where CD_LOCAL_ATENDIMENTO = 0
             and   CD_UNIDADE=PNRUNIMED
             and   CD_PRESTADOR=y7.prestador
             and   CD_VINCULO=y7.vinculo
             and   CD_ESPECIALID=y7.cd_especialid
             and   CD_PROCEDIMENTO=v7.cdservico
             and   CD_GRUPO_PROC=0
             and   CD_MODALIDADE=0
             and   CD_PLANO=0
             and   CD_TIPO_PLANO=0
             and   NR_TER_ADESAO=0
             and   DT_LIMITE='31/12/9999';
        exception 
              when no_data_found then 
  
        insert into gp.pres_pro
             values (0,--CD_LOCAL_ATENDIMENTO  NUMBER
                     PNRUNIMED,--CD_UNIDADE  NUMBER
                     y7.prestador,--CD_PRESTADOR  NUMBER
                     y7.vinculo,--CD_VINCULO  NUMBER
                     y7.cd_especialid,--CD_ESPECIALID  NUMBER
                     v7.cdservico,--CD_PROCEDIMENTO  NUMBER
                     0,--LG_ACRESCIMO_PROCED  NUMBER
                     y7.vinculo,--IN_TIPO_PRESTADOR  NUMBER
                     'MIGRACAO',--CD_USERID  VARCHAR2(24)
                     sysdate,--DT_ATUALIZACAO  DATE
                     ' ',--CHAR_1  VARCHAR2(500)
                     ' ',--CHAR_2  VARCHAR2(500)
                     ' ',--CHAR_3  VARCHAR2(500)
                     ' ',--CHAR_4  VARCHAR2(500)
                     ' ',--CHAR_5  VARCHAR2(500)
                     0,--DEC_1  NUMBER
                     0,--DEC_2  NUMBER
                     0,--DEC_3  NUMBER
                     0,--DEC_4  NUMBER
                     0,--DEC_5  NUMBER
                     NULL,--DATE_1  DATE
                     NULL,--DATE_2  DATE
                     NULL,--DATE_3  DATE
                     NULL,--DATE_4  DATE
                     NULL,--DATE_5  DATE
                     0,--INT_1  NUMBER
                     3,--INT_2  NUMBER
                     1,--INT_3  NUMBER
                     0,--INT_4  NUMBER
                     0,--INT_5  NUMBER
                     0,--LOG_1  NUMBER
                     0,--LOG_2  NUMBER
                     0,--LOG_3  NUMBER
                     0,--LOG_4  NUMBER
                     0,--LOG_5  NUMBER
                     ' ',--U_CHAR_1  VARCHAR2(40)
                     ' ',--U_CHAR_2  VARCHAR2(40)
                     ' ',--U_CHAR_3  VARCHAR2(40)
                     NULL,--U_DATE_1  DATE
                     NULL,--U_DATE_2  DATE
                     NULL,--U_DATE_3  DATE
                     0,--U_INT_1	NUMBER
                     0,--U_INT_2	NUMBER
                     0,--U_INT_3	NUMBER
                     0,--U_LOG_1	NUMBER
                     0,--U_LOG_2	NUMBER
                     0,--U_LOG_3	NUMBER
                     0,--U_DEC_1	NUMBER
                     0,--U_DEC_2	NUMBER
                     0,--U_DEC_3	NUMBER
                     '31/12/9999',--DT_LIMITE	DATE
                     0,--CD_MODALIDADE	NUMBER
                     0,--NR_TER_ADESAO	NUMBER
                     0,--CD_PLANO	NUMBER
                     0,--CD_TIPO_PLANO	NUMBER
                     0,--CD_GRUPO_PROC	NUMBER
                     GP.PRES_PRO_SEQ.NEXTVAL --PROGRESS_RECID	NUMBER
                     );
         end;  --begin               
       END LOOP;  --v7
     end loop; --y7
   
  end P_MIGRA_SERV_ESPEC;


  --=======================================--
  --RODAR APÓS CARGA ARQUIVO DE PRESTADORES--
  --=======================================--

  PROCEDURE POS_CARGA_TXT IS

    procedure p_afastamento_prestador is
    
      t_sitprest      gp.sitprest%rowtype;
      t_descprest     gp.descprest%rowtype;

      vcheck_obs      char;
      vtpafastamento  number;
      vnprestador_ant number;
      vnrlinha        number;
      txtexto_ap1     varchar2(60);
      txtexto_ap2     varchar2(76);
      txtexto_ap3     varchar2(76);    
      aojaexiste      varchar2(1) := 'N';
      cursor c_afastamento is
      
        select pr.cdprestador,
               a.dtafastamento,
               a.dtretorno,
               nvl((select d.cdmotivo_totvs
                     from depara_fastamento d
                    where d.afastamento_unicoo = a.tpafastamento),
                   PCDMOTIVO_AFASTAMENTO) tpafastamento,
               ' Afastamento do Prestador. Inicio: ' || dtafastamento ||
               decode(a.dtretorno, null, null, ' Fim ' || a.dtretorno) ||
               decode(txafastamento, null, null, ' ' || txafastamento || chr(10)) txafastamento
         from afastamento_prestador a, prestador pr
         where a.nrregistro_prest = pr.nrregistro_prest
               order by pr.cdprestador, a.nrregistro_prest, a.dtafastamento;    

    begin
    
      delete from motcange m where m.u##in_entidade = 'CG';
    
      for v in (select * from v_motcange_cg) loop
        begin
          insert into motcange values v;
        exception
          when dup_val_on_index then
            null;
        end;
      end loop;
    
      for c in c_afastamento loop
      
        begin
          vtpafastamento := to_number(c.tpafastamento);
        exception
          when others then
            RAISE_APPLICATION_ERROR(-20102,
                                    ' Erro tpafastamento ' ||
                                    c.tpafastamento);
        end;
        
        begin
          select 'S' into aojaexiste
            from gp.sitprest s
           where s.CD_UNIDADE = PNRUNIMED
             and s.CD_PRESTADOR = c.cdprestador
             and s.DT_INICIO_SUSPENSAO = c.dtafastamento
             and s.DT_FIM_SUSPENSAO = nvl(c.dtretorno, '31/12/9999');
        exception
          when others then
            aojaexiste := 'N';
        end;
        
        if aojaexiste = 'N' then
          t_sitprest.cd_unidade          := PNRUNIMED;
          t_sitprest.cd_prestador        := c.cdprestador;
          t_sitprest.dt_inicio_suspensao := c.dtafastamento;
          t_sitprest.dt_fim_suspensao    := nvl(c.dtretorno, '31/12/9999');
          t_sitprest.char_1              := ' ';
          t_sitprest.char_2              := ' ';
          t_sitprest.char_3              := ' ';
          t_sitprest.char_4              := ' ';
          t_sitprest.char_5              := ' ';
          t_sitprest.log_1               := 0;
          t_sitprest.log_2               := 0;
          t_sitprest.log_3               := 0;
          t_sitprest.log_4               := 0;
          t_sitprest.log_5               := 0;
          t_sitprest.dec_1               := 0;
          t_sitprest.dec_2               := 0;
          t_sitprest.dec_3               := 0;
          t_sitprest.dec_4               := 0;
          t_sitprest.dec_5               := 0;
          t_sitprest.date_1              := '';
          t_sitprest.date_2              := '';
          t_sitprest.date_3              := '';
          t_sitprest.date_4              := '';
          t_sitprest.date_5              := '';
          t_sitprest.int_1               := 0;
          t_sitprest.int_2               := 0;
          t_sitprest.int_3               := 0;
          t_sitprest.int_4               := 0;
          t_sitprest.int_5               := 0;
          t_sitprest.u_char_1            := ' ';
          t_sitprest.u_char_2            := ' ';
          t_sitprest.u_char_3            := ' ';
          t_sitprest.u_date_1            := '';
          t_sitprest.u_date_2            := '';
          t_sitprest.u_date_3            := '';
          t_sitprest.u_dec_1             := 0;
          t_sitprest.u_dec_2             := 0;
          t_sitprest.u_dec_3             := 0;
          t_sitprest.u_int_1             := 0;
          t_sitprest.u_int_2             := 0;
          t_sitprest.u_int_3             := 0;
          t_sitprest.u_log_1             := 0;
          t_sitprest.u_log_2             := 0;
          t_sitprest.u_log_3             := 0;
          t_sitprest.cd_userid           := 'migracao';
          t_sitprest.dt_atualizacao      := trunc(sysdate);
          t_sitprest.cd_motivo           := vtpafastamento;

          select gp.sitprest_seq.nextval
            into t_sitprest.progress_recid
            from dual;
        
          begin
            insert into gp.sitprest values t_sitprest;
          exception
            when dup_val_on_index then
              null;
          end;
        end if;

        begin
          select nvl(max(p.nr_linha),0)
            into vnrlinha
            from gp.descprest p
           where p.cd_unidade   = PNRUNIMED
             and p.cd_prestador = c.cdprestador;
        exception
          when no_data_found then
            vcheck_obs := 'N';
        end;
      
        if vnprestador_ant <> c.cdprestador then
           vnrlinha :=0;
        end if;
 
        vnrlinha := vnrlinha + 1;

        txtexto_ap1 := substr(c.txafastamento,1,60);
        txtexto_ap2 := substr(c.txafastamento,61,76);
        txtexto_ap3 := substr(c.txafastamento,136,76);

        if txtexto_ap1 is not null then
           
           t_descprest.DS_LINHA         := trim(txtexto_ap1);           

           t_descprest.CD_UNIDADE       := PNRUNIMED;
           t_descprest.CD_PRESTADOR     := c.cdprestador;
           t_descprest.NR_LINHA         := vnrlinha;
           t_descprest.CHAR_1           := ' ';
           t_descprest.CHAR_2           := '';
           t_descprest.CHAR_3           := '';
           t_descprest.CHAR_4           := '';
           t_descprest.CHAR_5           := '';
           t_descprest.LOG_1            := 0;
           t_descprest.LOG_2            := 0;
           t_descprest.LOG_3            := 0;
           t_descprest.LOG_4            := 0;
           t_descprest.LOG_5            := 0;
           t_descprest.DEC_1            := '';
           t_descprest.DEC_2            := '';
           t_descprest.DEC_3            := '';
           t_descprest.DEC_4            := '';
           t_descprest.DEC_5            := ''; 
           t_descprest.DATE_1           := null;
           t_descprest.DATE_2           := null;
           t_descprest.DATE_3           := null;
           t_descprest.DATE_4           := null;
           t_descprest.DATE_5           := null;
           t_descprest.INT_1            := 0;
           t_descprest.INT_2            := 0;
           t_descprest.INT_3            := 0;
           t_descprest.INT_4            := 0;
           t_descprest.INT_5            := 0;
           t_descprest.U_CHAR_1         := ' ';
           t_descprest.U_CHAR_2         := ' ';
           t_descprest.U_CHAR_3         := ' ';
           t_descprest.U_DATE_1         := null;
           t_descprest.U_DATE_2         := null;
           t_descprest.U_DATE_3         := null;
           t_descprest.U_DEC_1          := 0;
           t_descprest.U_DEC_2          := 0;
           t_descprest.U_DEC_3          := 0;
           t_descprest.U_INT_1          := 0;
           t_descprest.U_INT_2          := 0;
           t_descprest.U_INT_3          := 0;
           t_descprest.U_LOG_1          := 0;
           t_descprest.U_LOG_2          := 0;
           t_descprest.U_LOG_3          := 0;
           t_descprest.CD_USERID        := 'migracao';
           t_descprest.DT_ATUALIZACAO   := trunc(sysdate);
              
        select gp.descprest_seq.nextval
            into t_descprest.progress_recid
            from dual;
        
        insert into gp.descprest values t_descprest;

         vnrlinha := vnrlinha + 1;
         vnprestador_ant := c.cdprestador;
         
             if txtexto_ap2 is not null then
             
                t_descprest.DS_LINHA         := trim(txtexto_ap2);           

                t_descprest.CD_UNIDADE       := PNRUNIMED;
                t_descprest.CD_PRESTADOR     := c.cdprestador;
                t_descprest.NR_LINHA         := vnrlinha;
                t_descprest.CHAR_1           := ' ';
                t_descprest.CHAR_2           := '';
                t_descprest.CHAR_3           := '';
                t_descprest.CHAR_4           := '';
                t_descprest.CHAR_5           := '';
                t_descprest.LOG_1            := 0;
                t_descprest.LOG_2            := 0;
                t_descprest.LOG_3            := 0;
                t_descprest.LOG_4            := 0;
                t_descprest.LOG_5            := 0;
                t_descprest.DEC_1            := '';
                t_descprest.DEC_2            := '';
                t_descprest.DEC_3            := '';
                t_descprest.DEC_4            := '';
                t_descprest.DEC_5            := ''; 
                t_descprest.DATE_1           := null;
                t_descprest.DATE_2           := null;
                t_descprest.DATE_3           := null;
                t_descprest.DATE_4           := null;
                t_descprest.DATE_5           := null;
                t_descprest.INT_1            := 0;
                t_descprest.INT_2            := 0;
                t_descprest.INT_3            := 0;
                t_descprest.INT_4            := 0;
                t_descprest.INT_5            := 0;
                t_descprest.U_CHAR_1         := ' ';
                t_descprest.U_CHAR_2         := ' ';
                t_descprest.U_CHAR_3         := ' ';
                t_descprest.U_DATE_1         := null;
                t_descprest.U_DATE_2         := null;
                t_descprest.U_DATE_3         := null;
                t_descprest.U_DEC_1          := 0;
                t_descprest.U_DEC_2          := 0;
                t_descprest.U_DEC_3          := 0;
                t_descprest.U_INT_1          := 0;
                t_descprest.U_INT_2          := 0;
                t_descprest.U_INT_3          := 0;
                t_descprest.U_LOG_1          := 0;
                t_descprest.U_LOG_2          := 0;
                t_descprest.U_LOG_3          := 0;
                t_descprest.CD_USERID        := 'migracao';
                t_descprest.DT_ATUALIZACAO   := trunc(sysdate);
                     
                select gp.descprest_seq.nextval
                into t_descprest.progress_recid
                from dual;
        
                insert into gp.descprest values t_descprest;

                vnrlinha := vnrlinha + 1;

                    if txtexto_ap3 is not null then
             
                t_descprest.DS_LINHA         := trim(txtexto_ap3);           

                t_descprest.CD_UNIDADE       := PNRUNIMED;
                t_descprest.CD_PRESTADOR     := c.cdprestador;
                t_descprest.NR_LINHA         := vnrlinha;
                t_descprest.CHAR_1           := ' ';
                t_descprest.CHAR_2           := '';
                t_descprest.CHAR_3           := '';
                t_descprest.CHAR_4           := '';
                t_descprest.CHAR_5           := '';
                t_descprest.LOG_1            := 0;
                t_descprest.LOG_2            := 0;
                t_descprest.LOG_3            := 0;
                t_descprest.LOG_4            := 0;
                t_descprest.LOG_5            := 0;
                t_descprest.DEC_1            := '';
                t_descprest.DEC_2            := '';
                t_descprest.DEC_3            := '';
                t_descprest.DEC_4            := '';
                t_descprest.DEC_5            := ''; 
                t_descprest.DATE_1           := null;
                t_descprest.DATE_2           := null;
                t_descprest.DATE_3           := null;
                t_descprest.DATE_4           := null;
                t_descprest.DATE_5           := null;
                t_descprest.INT_1            := 0;
                t_descprest.INT_2            := 0;
                t_descprest.INT_3            := 0;
                t_descprest.INT_4            := 0;
                t_descprest.INT_5            := 0;
                t_descprest.U_CHAR_1         := ' ';
                t_descprest.U_CHAR_2         := ' ';
                t_descprest.U_CHAR_3         := ' ';
                t_descprest.U_DATE_1         := null;
                t_descprest.U_DATE_2         := null;
                t_descprest.U_DATE_3         := null;
                t_descprest.U_DEC_1          := 0;
                t_descprest.U_DEC_2          := 0;
                t_descprest.U_DEC_3          := 0;
                t_descprest.U_INT_1          := 0;
                t_descprest.U_INT_2          := 0;
                t_descprest.U_INT_3          := 0;
                t_descprest.U_LOG_1          := 0;
                t_descprest.U_LOG_2          := 0;
                t_descprest.U_LOG_3          := 0;
                t_descprest.CD_USERID        := 'migracao';
                t_descprest.DT_ATUALIZACAO   := trunc(sysdate);
                     
                select gp.descprest_seq.nextval
                into t_descprest.progress_recid
                from dual;
        
                insert into gp.descprest values t_descprest;

                vnrlinha := vnrlinha + 1;

                end if;     
              end if;
        end if; 

        vnprestador_ant := c.cdprestador;

      end loop;
    
    end p_afastamento_prestador;
  
    PROCEDURE P_CARREGA_AREA_ATUACAO IS
    
      VAOEXISTE CHAR;
    
      CURSOR C_AREA IS
        SELECT PNRUNIMED CDN_UNID,
               CDPRESTADOR CDN_PRESTDOR,
               CDN_AREA_ATUAC CDN_AREA_ATUAC,
               0 LOG_CERTIF,
               'MIGRACAO' COD_USUARIO,
               TRUNC(SYSDATE) DAT_ATUALIZA,
               ' ' COD_LIVRE_1,
               ' ' COD_LIVRE_2,
               ' ' COD_LIVRE_3,
               ' ' COD_LIVRE_4,
               ' ' COD_LIVRE_5,
               NULL DAT_LIVRE_1,
               NULL DAT_LIVRE_2,
               NULL DAT_LIVRE_3,
               NULL DAT_LIVRE_4,
               NULL DAT_LIVRE_5,
               0 VAL_LIVRE_1,
               0 VAL_LIVRE_2,
               0 VAL_LIVRE_3,
               0 VAL_LIVRE_4,
               0 VAL_LIVRE_5,
               0 LOG_LIVRE_1,
               0 LOG_LIVRE_2,
               0 LOG_LIVRE_3,
               0 LOG_LIVRE_4,
               0 LOG_LIVRE_5,
               0 NUM_LIVRE_1,
               0 NUM_LIVRE_2,
               0 NUM_LIVRE_3,
               0 NUM_LIVRE_4,
               0 NUM_LIVRE_5,
               GP.PREST_AREA_ATU_SEQ.NEXTVAL PROGRESS_RECID
          FROM (SELECT DISTINCT AREA.CDPRESTADOR,
                                AREA.CDESPECIALIDADE,
                                AREA.NOPESSOA,
                                AREA.NOESPECIALIDADE,
                                AREA.AREA_DE_ATUACAO_UNICOO,
                                (SELECT AA.CDAREA_ATUACAO_PTU
                                   FROM ATUACAO_ESPECIALISTA  A,
                                        ATUACAO_ESPECIALIDADE E,
                                        AREA_ATUACAO          AA,
                                        PRESTADOR             PR
                                  WHERE A.NRREGISTRO_PREST =
                                        PR.NRREGISTRO_PREST
                                    AND E.NRSEQUENCIAL =
                                        A.NRSEQ_ATUACAO_ESPECIALIDADE
                                    AND E.NRSEQ_AREA_ATUACAO =
                                        AA.NRSEQUENCIAL
                                    AND A.CDESPECIALIDADE =
                                        AREA.CDESPECIALIDADE
                                    AND PR.CDPRESTADOR = AREA.CDPRESTADOR
                                    and rownum = 1) CDN_AREA_ATUAC,
                                AAG.DES_AREA_ATUAC AREA_ATUACAO_TOTVS
                  FROM (SELECT PRA.*, PAT.CDN_AREA_ATUAC
                          FROM (SELECT P.CDPRESTADOR,
                                       P.CDESPECIALIDADE,
                                       P.NOPESSOA,
                                       P.NOESPECIALIDADE,
                                       P.CD_ESPECILIADE_TOTVS,
                                       (SELECT AU.NOAREA_ATUACAO
                                          FROM ATUACAO_ESPECIALIDADE AE,
                                               AREA_ATUACAO          AU
                                         WHERE AE.NRSEQ_AREA_ATUACAO =
                                               AU.NRSEQUENCIAL
                                           AND A.CDESPECIALIDADE =
                                               AE.CDESPECIALIDADE
                                           AND A.NRSEQ_ATUACAO_ESPECIALIDADE =
                                               AE.NRSEQUENCIAL) AREA_DE_ATUACAO_UNICOO
                                  FROM (SELECT PR.CDPRESTADOR,
                                               PR.NRREGISTRO_PREST,
                                               PE.NOPESSOA,
                                               EP.CDESPECIALIDADE,
                                               NVL((SELECT TO_CHAR(CD_ESPECIALIDADE_TOTVS)
                                                     FROM DEPARA_ESPECIALIDADE T
                                                    WHERE T.CDESPECIALIDADE_UNICOO =
                                                          E.CDESPECIALIDADE),
                                                   TO_NUMBER(E.CDESPECIALIDADE)) CD_ESPECILIADE_TOTVS,
                                               E.NOESPECIALIDADE
                                          FROM PRESTADOR     PR,
                                               ESPECIALISTA  EP,
                                               PESSOA        PE,
                                               ESPECIALIDADE E
                                         WHERE PR.NRREGISTRO_PREST =
                                               EP.NRREGISTRO_PREST
                                           AND PR.NRREGISTRO_PREST =
                                               PE.NRREGISTRO
                                           AND EP.CDESPECIALIDADE =
                                               E.CDESPECIALIDADE
                                           AND PR.TPPRESTADOR NOT IN ('N')) P,
                                       ATUACAO_ESPECIALISTA A
                                 WHERE A.NRREGISTRO_PREST(+) =
                                       P.NRREGISTRO_PREST
                                   AND A.CDESPECIALIDADE(+) =
                                       P.CDESPECIALIDADE) PRA,
                               GP.PREST_AREA_ATU PAT
                         WHERE PAT.CDN_PRESTDOR(+) = PRA.CDPRESTADOR
                           AND PAT.CDN_UNID(+) = PNRUNIMED
                           AND PAT.CDN_AREA_ATUAC(+) =
                               PRA.CD_ESPECILIADE_TOTVS) AREA,
                       GP.AREA_ATUAC_GPL AAG
                 WHERE AAG.CDN_AREA_ATUAC(+) = AREA.CDN_AREA_ATUAC)
         WHERE AREA_DE_ATUACAO_UNICOO is not null;
    
    BEGIN
      -- carregar AREA_ATUAC_GPL com base em AREA_ATUACAO do UNICOO
      for x in (select * from area_atuacao) loop
        vaoexiste := 'N';
        begin
          select 'S' into vaoexiste
            from gp.area_atuac_gpl a where a.cdn_area_atuac = x.nrsequencial;
        exception
          when others then vaoexiste := 'N';
        end;
            
        if vaoexiste = 'N' then
          insert into gp.area_atuac_gpl(cod_usuario,
                                        dt_atualizacao,
                                        cdn_area_atuac,
                                        des_area_atuac,
                                        dat_livre_1, --validade
                                        log_livre_1,
                                        progress_recid) --bloqueia envio A400
                values('migracao',
                       sysdate,
                       x.nrsequencial,
                       x.noarea_atuacao,
                       '31/12/9999',
                       0,
                       gp.area_atuac_gpl_seq.nextval);
        end if;
      end loop;

      FOR CA IN C_AREA LOOP
      
        BEGIN
          SELECT 'S'
            INTO VAOEXISTE
            FROM GP.PREST_AREA_ATU P
           WHERE P.CDN_UNID = CA.CDN_UNID
             AND P.CDN_PRESTDOR = CA.CDN_PRESTDOR
             AND P.CDN_AREA_ATUAC = CA.CDN_AREA_ATUAC;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            VAOEXISTE := 'N';
        END;
      
        IF VAOEXISTE = 'N' THEN
          INSERT INTO GP.PREST_AREA_ATU VALUES CA;
        
        END IF;
      
      END LOOP;
    
    END P_CARREGA_AREA_ATUACAO;
  
    PROCEDURE P_GRUPO_SERVICO_PREST IS
      VAOEXISTE CHAR;
    
      /*PROCEDURE P_ATUALIZA_END_PREST AS
      
        --VAOMIGRA CHAR;
      
      BEGIN
      
        DELETE FROM GP.PRESTDOR_ENDER;
      
        INSERT INTO GP.PRESTDOR_ENDER P
          SELECT E.CD_UNIDADE cdn_unid_prestdor,
                 E.CD_PRESTADOR cdn_prestdor,
                 E.NR_SEQ_ENDERECO num_seq_ender,
                 0 num_acomoda_hos_dia,
                 0 num_acomoda_tot_clini,
                 0 num_acomoda_tot_obstr,
                 0 num_acomoda_tot_pediat,
                 ' ' cod_longitude,
                 ' ' cod_latitude,
                 ' ' cod_livre_1,
                 ' ' cod_livre_2,
                 ' ' cod_livre_3,
                 ' ' cod_livre_4,
                 ' ' cod_livre_5,
                 NULL dat_livre_1,
                 NULL dat_livre_2,
                 NULL dat_livre_3,
                 NULL dat_livre_4,
                 NULL dat_livre_5,
                 0 val_livre_1,
                 0 val_livre_2,
                 0 val_livre_3,
                 0 val_livre_4,
                 0 val_livre_5,
                 0 log_livre_1,
                 0 log_livre_2,
                 0 log_livre_3,
                 0 log_livre_4,
                 0 log_livre_5,
                 0 num_livre_1,
                 0 num_livre_2,
                 0 num_livre_3,
                 0 num_livre_4,
                 0 num_livre_5,
                 TRUNC(SYSDATE) dat_ult_atualiz,
                 ' ' hra_ult_atualiz,
                 'migracao' cod_usuar_ult_atualiz,
                 0 numacomodatotpsiquiat,
                 0 num_acomoda_neonat_uti,
                 0 numacomodacontratuti,
                 0 num_acomoda_normal_uti,
                 0 num_acomoda_pediat_uti,
                 0 numacomodaintermneonatuti,
                 0 num_acomoda_cirurgc,
                 0 numacomodatotclini2,
                 0 numacomodapsiquiatuti,
                 gp.prestdor_ender_seq.nextval progress_recid
          --            FROM GP.ENDPRES E
          --           WHERE E.CD_UNIDADE = PNRUNIMED;
            FROM GP.ENDPRES                E,
                 pessoa                    p,
                 prestador                 pr,
                 prestador_estabelecimento pe
           WHERE E.CD_UNIDADE = 023
             and p.nrregistro = pr.nrregistro_prest
             and pr.cdprestador = e.cd_prestador
             and pe.nrregistro_prest = pr.nrregistro_prest;
      
      END P_ATUALIZA_END_PREST;*/
      
      Procedure p_cadastro_grp_servico Is
        Cursor cGrpServico Is
          Select cdgrupo_servico, nogrupo_servico
          From   grupo_servico gs
          Where  Not Exists (select 1 From gp.grp_serv_ptu gsp
                             Where gsp.cdn_grp_serv_ptu = gs.cdgrupo_servico);
      Begin
        For Rx In cGrpServico Loop
          Insert Into gp.grp_serv_ptu (cdn_grp_serv_ptu, des_grp_serv_ptu, dt_inicio_vigencia, dt_fim_vigencia, 
                                       cod_livre_1, cod_livre_2, cod_livre_3, cod_livre_4, cod_livre_5, dat_livre_1, 
                                       dat_livre_2, dat_livre_3, dat_livre_4, dat_livre_5, val_livre_1, val_livre_2, 
                                       val_livre_3, val_livre_4, val_livre_5, log_livre_1, log_livre_2, log_livre_3, 
                                       log_livre_4, log_livre_5, num_livre_1, num_livre_2, num_livre_3, num_livre_4, 
                                       num_livre_5, cod_livre_usuar_1, cod_livre_usuar_2, cod_livre_usuar_3, dat_livre_usuar_1, 
                                       dat_livre_usuar_2, dat_livre_usuar_3, val_livre_usuar_1, val_livre_usuar_2, val_livre_usuar_3, 
                                       num_livre_usuar_1, num_livre_usuar_2, num_livre_usuar_3, log_livre_usuar_1, log_livre_usuar_2, 
                                       log_livre_usuar_3, dat_ult_atualiz, hra_ult_atualiz, cod_usuar_ult_atualiz, progress_recid)
                 Values (Rx.cdgrupo_servico, Substr(Rx.nogrupo_servico,1,40), Trunc(Sysdate), to_date('31/12/9999'),
                         ' ', ' ', ' ', ' ', ' ', /*cod_livre_1~5*/
                         Null, Null, Null, Null, Null, /*dat_livre_1~5*/
                         0, 0, 0, 0, 0, /*val_livre_1~5*/
                         0, 0, 0, 0, 0, /*log_livre_1~5*/
                         0, 0, 0, 0, 0, /*num_livre_1~5*/
                         ' ', ' ', ' ', /*cod_livre_usuar_1~3*/
                         Null, Null, Null, /*dat_livre_usuar_1~3*/ 
                         0, 0, 0, /*val_livre_usuar_1~3*/
                         0, 0, 0, /*num_livre_usuar_1~3*/
                         0, 0, 0, /*log_livre_usuar_1~3*/
                         Trunc(Sysdate), /*dat_ult_atualiz*/
                         ' ', /*hra_ult_atualiz*/
                         'MIGRACAO', /*cod_usuar_ult_atualiz*/
                         gp.grp_serv_ptu_seq.nextval);
        End Loop;
      End p_cadastro_grp_servico;
    
    BEGIN
      --P_ATUALIZA_END_PREST;
    
      --Evandro Levi (03/09/2018): Atualiza o cadastro de Grupo de Serviços
      p_cadastro_grp_servico;
    
      FOR Y IN (SELECT CD_UNIDADE, CD_PRESTADOR
                  FROM GP.PRESERV
                 WHERE CD_UNIDADE = PNRUNIMED) LOOP
        FOR X IN (SELECT ED.CD_UNIDADE CD_UNIDADE,
                         ED.CD_PRESTADOR CD_PRESTADOR,
                         ED.NR_SEQ_ENDERECO NR_SEQUENCIA,
                         PUNICOO.CDGRUPO_SERVICO CD_GRUPO_SERVICO_PTU,
                         'MIGRACAO' CD_USERID,
                         TRUNC(SYSDATE) DT_ATUALIZACAO,
                         DECODE(PUNICOO.TPDISPONIBILIDADE, '2', '2', '1') IN_DISPONIBILIDADE,
                         ' ' CHAR_2,
                         ' ' CHAR_3,
                         ' ' CHAR_4,
                         ' ' CHAR_5,
                         NULL DATE_1,
                         NULL DATE_2,
                         NULL DATE_3,
                         NULL DATE_4,
                         NULL DATE_5,
                         0 DEC_1,
                         0 DEC_2,
                         0 DEC_3,
                         0 DEC_4,
                         0 DEC_5,
                         0 INT_1,
                         0 INT_2,
                         0 INT_3,
                         0 INT_4,
                         0 INT_5,
                         0 LOG_1,
                         0 LOG_2,
                         0 LOG_3,
                         0 LOG_4,
                         0 LOG_5,
                         ' ' U_CHAR_1,
                         ' ' U_CHAR_2,
                         ' ' U_CHAR_3,
                         NULL U_DATE_1,
                         NULL U_DATE_2,
                         NULL U_DATE_3,
                         0 U_DEC_1,
                         0 U_DEC_2,
                         0 U_DEC_3,
                         0 U_INT_1,
                         0 U_INT_2,
                         0 U_INT_3,
                         0 U_LOG_1,
                         0 U_LOG_2,
                         0 U_LOG_3,
                         GP.PTUGRSER_SEQ.NEXTVAL PROGRESS_RECID
                    FROM ( /*SELECT PR.CDPRESTADOR,
                                                                                     PE.NOPESSOA,
                                                                                     E.NOLOGRADOURO || ', ' || E.NRIMOVEL DS_LOGRADOURO,
                                                                                     GP.CDGRUPO_SERVICO,
                                                                                     GP.NOGRUPO_SERVICO,
                                                                                     PR.TPDISPONIBILIDADE
                                                                                FROM GRUPO_SERV_ESPECIALISTA GSP,
                                                                                     PRESTADOR               PR,
                                                                                     ENDERECO                E,
                                                                                     GRUPO_SERVICO           GP,
                                                                                     PESSOA                  PE
                                                                               WHERE GSP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                                                                                 AND E.NRREGISTRO = PR.NRREGISTRO_PREST
                                                                                    --  AND (PR.NRREGISTRO_PREST = '1412')
                                                                                 AND GSP.CDTIPO_ENDERECO = E.TPENDERECO
                                                                                 AND GP.CDGRUPO_SERVICO = GSP.CDGRUPO_SERVICO
                                                                                 AND PE.NRREGISTRO = PR.NRREGISTRO_PREST*/
                          SELECT PR.CDPRESTADOR,
                                  PE.NOPESSOA,
                                  e.endereco_prest,
                                  GP.CDGRUPO_SERVICO,
                                  GP.NOGRUPO_SERVICO,
                                  PR.TPDISPONIBILIDADE
                            FROM GRUPO_SERV_ESPECIALISTA      GSP,
                                  PRESTADOR                    PR,
                                  temp_migracao_endereco_prest E,
                                  temp_migracao_prestador      tp,
                                  GRUPO_SERVICO                GP,
                                  PESSOA                       PE
                           WHERE GSP.NRREGISTRO_PREST = PR.NRREGISTRO_PREST
                             AND tp.cdprestador = pr.cdprestador
                             and tp.nrsequencial = e.nrsequencial
                                --  AND (PR.NRREGISTRO_PREST = '1412')
                             AND GSP.CDTIPO_ENDERECO = E.Tpendereco_Unicoo
                             AND GP.CDGRUPO_SERVICO = GSP.CDGRUPO_SERVICO
                             AND PE.NRREGISTRO = PR.NRREGISTRO_PREST) PUNICOO,
                         GP.ENDPRES ED
                   WHERE ED.CD_PRESTADOR = PUNICOO.CDPRESTADOR
                     AND Trim(ED.U##EN_ENDERECO) = replace(replace(Trim(PUNICOO.ENDERECO_PREST),',',' '),'  ',' ')
                     AND ED.CD_UNIDADE = PNRUNIMED
                     AND ED.CD_PRESTADOR = Y.CD_PRESTADOR) LOOP
        
          BEGIN
            SELECT 'S'
              INTO VAOEXISTE
              FROM GP.PTUGRSER P
             WHERE P.CD_UNIDADE = X.CD_UNIDADE
               AND P.CD_PRESTADOR = X.CD_PRESTADOR
               AND P.NR_SEQUENCIA = X.NR_SEQUENCIA
               AND P.CD_GRUPO_SERVICO_PTU = X.CD_GRUPO_SERVICO_PTU;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              VAOEXISTE := 'N';
            
          END;
        
          IF VAOEXISTE = 'N' THEN
            INSERT INTO GP.PTUGRSER VALUES X;
          END IF;
        
        END LOOP;
      END LOOP;
    
    END P_GRUPO_SERVICO_PREST;
  
    PROCEDURE P_CARREGA_ACREDITACAO AS
    
      VAOEXISTE CHAR;
    
    BEGIN
    
/*      INSERT INTO GP.PREST_INST
        SELECT PNRUNIMED, -- CD_UNIDADE
               PR.CDPRESTADOR, --CD_PRESTADOR
               UPPER(EDA.CDINST_ACRED), --U##COD_INSTIT
               EDA.CDINST_ACRED, --COD_INSTIT
               EDA.NRNIVEL_ACRED, -- CDN_NIVEL (1-Acreditado; 2-Pleno; 3-Acreditado com Excelência)
               ' ', --COD_LIVRE_1
               ' ', --COD_LIVRE_2
               ' ', --COD_LIVRE_3
               ' ', --COD_LIVRE_4
               ' ', --COD_LIVRE_5
               NULL, --DAT_LIVRE_1
               NULL, --DAT_LIVRE_2
               NULL, --DAT_LIVRE_3
               NULL, --DAT_LIVRE_4
               NULL, --DAT_LIVRE_5
               0, --VAL_LIVRE_1
               0, --VAL_LIVRE_2
               0, --VAL_LIVRE_3
               0, --VAL_LIVRE_4
               0, --VAL_LIVRE_5
               decode(EDA.AOAUTORIZA_DIVULGA,'S',1,0), --LOG_LIVRE_1 (Identifica se o prestador autoriza a divulgação dos atributos de qualificação)
               0, --LOG_LIVRE_2
               0, --LOG_LIVRE_3
               0, --LOG_LIVRE_4
               0, --LOG_LIVRE_5
               ED.NR_SEQ_ENDERECO, --NUM_LIVRE_1
               0, --NUM_LIVRE_2
               0, --NUM_LIVRE_3
               0, --NUM_LIVRE_4
               0, --NUM_LIVRE_5
               TRUNC(SYSDATE), --DAT_ULT_ATUALIZ
               TO_CHAR(SYSDATE, 'hh24:mi:ss'), --HRA_ULT_ATUALIZ
               'MIGRACAO', --COD_USUAR_ULT_ATUALIZ,
               ED.NR_SEQ_ENDERECO, --CDN_SEQ_ENDER,
               GP.PREST_INST_SEQ.NEXTVAL --PROGRESS_RECID
          FROM PRESTADOR                    PR,
               ENDERECO_ACREDITACAO         EDA,
               TEMP_MIGRACAO_PRESTADOR      TMP,
               TEMP_MIGRACAO_ENDERECO_PREST TMPE,
               GP.ENDPRES                   ED
         WHERE PR.AOACREDITADO = 'S'
           AND PR.NRREGISTRO_PREST = EDA.NRREGISTRO_ENDERECO
           AND PR.CDPRESTADOR = TMP.CDPRESTADOR
           AND TMP.NRSEQUENCIAL = TMPE.NRSEQUENCIAL
           AND PR.CDPRESTADOR = ED.CD_PRESTADOR
           AND EDA.TPENDERECO = TMPE.TPENDERECO_UNICOO
           AND TRIM(TMPE.ENDERECO_PREST) = TRIM(ED.EN_ENDERECO);
    
    END;
*/    
    
      -- Tabela nova para endereço instituição acreditadora
      INSERT INTO GP.PRESTDOR_END_INSTIT
          SELECT PNRUNIMED, -- CD_UNIDADE
                 PR.CDPRESTADOR, --CD_PRESTADOR
                 UPPER(EDA.CDINST_ACRED), --U##COD_INSTIT
                 EDA.CDINST_ACRED, --COD_INSTIT
                 ED.NR_SEQ_ENDERECO, --CDN_SEQ_ENDER,
                 EDA.NRNIVEL_ACRED, -- CDN_NIVEL (1-Acreditado; 2-Pleno; 3-Acreditado com Excelência)
                 ' ', --COD_LIVRE_1
                 ' ', --COD_LIVRE_2
                 ' ', --COD_LIVRE_3
                 ' ', --COD_LIVRE_4
                 ' ', --COD_LIVRE_5
                 ' ', --COD_LIVRE_6
                 ' ', --COD_LIVRE_7
                 ' ', --COD_LIVRE_8
                 ' ', --COD_LIVRE_9
                 ' ', --COD_LIVRE_10
                 ED.NR_SEQ_ENDERECO, --NUM_LIVRE_1
                 0, --NUM_LIVRE_2
                 0, --NUM_LIVRE_3
                 0, --NUM_LIVRE_4
                 0, --NUM_LIVRE_5
                 0, --NUM_LIVRE_6
                 0, --NUM_LIVRE_7
                 0, --NUM_LIVRE_8
                 0, --NUM_LIVRE_9
                 0, --NUM_LIVRE_10
                 0, --VAL_LIVRE_1
                 0, --VAL_LIVRE_2
                 0, --VAL_LIVRE_3
                 0, --VAL_LIVRE_4
                 0, --VAL_LIVRE_5
                 0, --VAL_LIVRE_6
                 0, --VAL_LIVRE_7
                 0, --VAL_LIVRE_8
                 0, --VAL_LIVRE_9
                 0, --VAL_LIVRE_10
                 decode(EDA.AOAUTORIZA_DIVULGA,'S',1,0), --LOG_LIVRE_1 (Identifica se o prestador autoriza a divulgação dos atributos de qualificação)
                 0, --LOG_LIVRE_2
                 0, --LOG_LIVRE_3
                 0, --LOG_LIVRE_4
                 0, --LOG_LIVRE_5
                 0, --LOG_LIVRE_6
                 0, --LOG_LIVRE_7
                 0, --LOG_LIVRE_8
                 0, --LOG_LIVRE_9
                 0, --LOG_LIVRE_10
                 NULL, --DAT_LIVRE_1
                 NULL, --DAT_LIVRE_2
                 NULL, --DAT_LIVRE_3
                 NULL, --DAT_LIVRE_4
                 NULL, --DAT_LIVRE_5
                 NULL, --DAT_LIVRE_6
                 NULL, --DAT_LIVRE_7
                 NULL, --DAT_LIVRE_8
                 NULL, --DAT_LIVRE_9
                 NULL, --DAT_LIVRE_10
                 TRUNC(SYSDATE), --DAT_ULT_ATUALIZ
                 TO_CHAR(SYSDATE, 'hh24:mi:ss'), --HRA_ULT_ATUALIZ
                 'MIGRACAO', --COD_USUAR_ULT_ATUALIZ,
                 GP.PRESTDOR_END_INSTIT_SEQ.NEXTVAL --PROGRESS_RECID
            FROM PRESTADOR                    PR,
                 ENDERECO_ACREDITACAO         EDA,
                 TEMP_MIGRACAO_PRESTADOR      TMP,
                 TEMP_MIGRACAO_ENDERECO_PREST TMPE,
                 GP.ENDPRES                   ED
           WHERE PR.AOACREDITADO = 'S'
             AND PR.NRREGISTRO_PREST = EDA.NRREGISTRO_ENDERECO
             AND PR.CDPRESTADOR = TMP.CDPRESTADOR
             AND TMP.NRSEQUENCIAL = TMPE.NRSEQUENCIAL
             AND PR.CDPRESTADOR = ED.CD_PRESTADOR
             AND EDA.TPENDERECO = TMPE.TPENDERECO_UNICOO
             AND TRIM(TMPE.ENDERECO_PREST) = TRIM(ED.EN_ENDERECO);
    
    END P_CARREGA_ACREDITACAO;

      -- Mcarvalho
    PROCEDURE p_atualiza_email_observacoes is
    
          t_descprest gp.descprest%rowtype;
          t_descprest    gp.descprest%rowtype;
          
          vcheck_obs     varchar2(1);
          vcheck_email   varchar2(1);
          x              VARCHAR(76);
          txtitulo       VARCHAR2(76);
          txemail        VARCHAR2(76);
          txemail_adic   VARCHAR2(76);
          vn_cont        number;
          vnrlinha       number;      
          vprestador_ant number;
          
          cursor c_email is
    
            select a.cdprestador,
                   e.nrregistro,
                   e.tpendereco,
                   e.cdemail,
                   e.cdemail_adicional,
                   decode(e.cdemail,null,' ',
                   'Email ' || decode(e.tpendereco, 'COBR','Comercial :',
                                                     'RES' ,'Residencial :',
                                                     'CON1','Atendimento1 :',
                                                     'CON2','Atendimento2 :',
                                                     'CON3','Atendimento3 :',
                                                     'CON4','Atendimento4 :',
                                                     'COM' ,'Comercial :')) txtitulo1,
                   decode(e.cdemail_adicional, null, ' ',
                   'Email Adicional ' || decode(e.tpendereco, 'COBR','Comercial :',
                                                     'RES' ,'Residencial :',
                                                     'CON1','Atendimento1 :',
                                                     'CON2','Atendimento2 :',
                                                     'CON3','Atendimento3 :',
                                                     'CON4','Atendimento4 :',
                                                     'COM' ,'Comercial :')) txtitulo2,
                   decode(e.cdemail, null, ' ', e.cdemail) txemail,
                          decode(e.cdemail_adicional, null, ' ', e.cdemail_adicional)
                          txemail_adic
             from temp_migracao_prestador a, endereco e
             where a.nrregistro_prest = e.nrregistro
             and   (e.cdemail is not null or e.cdemail_adicional is not null)
             order by a.cdprestador;
    
        begin
    
          vnrlinha := 0;
        
        for c in c_email loop
    
            begin
              select nvl(max(p.nr_linha),0)
                into vnrlinha                    
                from gp.descprest p
               where p.cd_unidade   = PNRUNIMED
                 and p.cd_prestador = c.cdprestador;
            exception
              when no_data_found then
                vnrlinha   := 0;
            end;
        
    --
    --        if vprestador_ant <> c.cdprestador then
    --           vnrlinha :=0;
    --        end if;
    
            vnrlinha := vnrlinha + 1;
                                 
            begin
    
            
            if c.cdemail is not null then
               
                p_insere_email_obs(PNRUNIMED,c.cdprestador,vnrlinha,c.txtitulo1);
                  vnrlinha  := vnrlinha + 1;
                p_insere_email_obs(PNRUNIMED,c.cdprestador,vnrlinha,c.txemail);
                  vnrlinha  := vnrlinha + 1;
            end if;
                  
            if c.cdemail_adicional is not null then   
                    p_insere_email_obs(PNRUNIMED,c.cdprestador,vnrlinha,c.txtitulo2);
                      vnrlinha  := vnrlinha + 1;
                    p_insere_email_obs(PNRUNIMED,c.cdprestador,vnrlinha,c.txemail_adic);
                      vnrlinha  := vnrlinha + 1;
            end if;
    
            end;
    
             vprestador_ant := c.cdprestador;
    
          end loop;
    
    end p_atualiza_email_observacoes;

    --Mcarvalho
    PROCEDURE p_atualiza_email_endereco is

      txemail        char;

      cursor c_email is

        select a.cdprestador,
               e.nrregistro,
               e.tpendereco,
               e.cdemail,
               e.cdemail_adicional
         from  temp_migracao_prestador a, endereco e
         where a.nrregistro_prest = e.nrregistro
         and   e.cdemail is not null;

    begin
    
      for c in c_email loop
  
          begin
  
            update gp.ENDPRES p
               set p.char_2 = c.cdemail
             where p.cd_unidade = PNRUNIMED
               and p.cd_prestador = c.cdprestador
               and p.dec_2 = decode(c.tpendereco,'RES', '0',
                                                 'COBR','2',
                                                 'COM', '2',
                                                 'CON1','1',
                                                 'CON2','1',
                                                 'CON3','1',
                                                 'CON4','1');
           end;  
  
      end loop;

    end p_atualiza_email_endereco;

    Procedure p_dados_graduacao Is
      vTpPrest_Formacao_Medica  TM_PARAMETRO.VLPARAMETRO%Type;
      
      Cursor cDadosGraduacao Is
        SELECT p.nrregistro_prest, p.cdprestador,
               Nvl(p.aopos_graduacao,'N') aopos_graduacao,
               Nvl(p.aoparticipa_prog_cert,'N') aopart_prog_certif,
               Case
                 When p.tpgraduacao = '1' Then 1 /*mestrado*/
                 When p.tpgraduacao In ('2','3') Then 2 /*doutorado*/
                 When p.tpgraduacao = '4' Then 3 /*livre docencia*/
                 When p.tpgraduacao = '5' Then 4 /*outros - não se aplica*/
                 Else 0 /*nao informado*/
               End tpgraduacao,
               Decode(nvl(trim(e.cdresidencia),'N'), 'S', 1, 0) aoresidencia,
               Decode(p.tpgraduacao,'1',1,0) aomestrado,
               Decode(p.tpgraduacao,'2',1,'3',1,0) aodoutorado,
               Case
                 When vTpPrest_Formacao_Medica Like '%'||p.tpprestador||'%' Then 1
                 Else 0
               End aomedico,
               Decode(e.aopossuicodtitulacao,'S',1,0) aodiploma
        FROM   prestador p, especialista e
        WHERE  e.nrregistro_prest = p.nrregistro_prest
        And    e.cdespecialidade = p.cdespecial_predom
        AND    e.cdsituacao = 0 /*ativo*/
        And    Exists (Select 1 From temp_migracao_prestador tm
                       Where tm.nrregistro_prest = p.nrregistro_prest)
        ORDER BY p.cdprestador;
    Begin
      Begin
        Select f_tm_parametro('TPPRESTADOR_FORMACAO_MEDICA')
        Into   vTpPrest_Formacao_Medica
        From   Dual;
      Exception
        When Others Then
          vTpPrest_Formacao_Medica := Null;
      End;
      --
      For Rx In cDadosGraduacao Loop
        For Ry In (Select ps.progress_recid
                   from   temp_migracao_prestador tmp, preserv ps
                   where  ps.cd_unidade   = tmp.nrunidade
                   And    ps.cd_prestador = tmp.cdprestador
                   And    tmp.nrregistro_prest = Rx.nrregistro_prest) Loop
          --
          Update PRESERV Set char_29 = Rx.aopos_graduacao||Rx.aopart_prog_certif||Rx.TpGraduacao,
                             log_18 = Rx.aoresidencia,
                             log_29 = Rx.aomestrado,
                             log_22 = Rx.aodoutorado,
                             lg_medico = Rx.aomedico,
                             lg_diploma = Rx.aodiploma
                         Where progress_recid = Ry.progress_recid;
          --
        End Loop;
      End Loop;
    End p_dados_graduacao;
    
    Procedure p_prestador_dependente Is
      Cursor cDep Is
          Select pd.nrregistro_prest, pd.nrregistro_dependente,
                 de.cdn_domin cdn_tipo_dep,
                 Decode(nvl(pd.aodepirrf_esocial,'N'), 'N', 0, 1) log_irrf, --pessoa_dep
                 Decode(nvl(pd.aodepsf_esocial,'N'), 'N', 0, 1) log_salario_familia, --pessoa_dep
                 Decode(nvl(pd.aoinctrab_esocial,'N'), 'N', 0, 1) log_incap --pessoa_fisica
          From temp_migracao_prestador tm, prestador_dependente pd, gp.domin_esocial de
          Where pd.nrregistro_prest = tm.nrregistro_prest
          And   Exists (select 1 From pessoa
                        Where nrregistro = pd.nrregistro_dependente)
          And   Exists (select 1 From pessoa
                        Where nrregistro = pd.nrregistro_prest)
          and de.idi_tip_domin = 7 -- DEPENDENCIA ESOCIAL
          and de.cod_domin_esocial = pd.tpdep_esocial
          Order By tm.cdprestador;
      
      vExistePessoaDep    Number;
      vExistePessoaPrest  Number;
      vNome               PESSOA.NOPESSOA%Type;
    Begin
      For Rx In cDep Loop
        Select Count(*)
        Into   vExistePessoaDep
        From   gp.pessoa_fisica pf
        Where  pf.id_pessoa = Rx.nrregistro_dependente;
        --
        Select Count(*)
        Into   vExistePessoaPrest
        From   gp.preserv ps
        Where  ps.id_pessoa = Rx.nrregistro_prest;
        --
        If (vExistePessoaDep > 0 And vExistePessoaPrest > 0) Then
          Update gp.pessoa_fisica pf Set pf.log_incap = Rx.log_incap
                                     Where pf.id_pessoa = Rx.nrregistro_dependente;
          --
          begin
            Insert Into gp.pessoa_dep (idi_pessoa, cdd_pessoa_dep, log_irrf, log_salario_familia, cod_livre_1, 
                                       cod_livre_2, cod_livre_3, cod_livre_4, cod_livre_5, cod_livre_6, 
                                       cod_livre_7, cod_livre_8, cod_livre_9, cod_livre_10, num_livre_1, 
                                       num_livre_2, num_livre_3, num_livre_4, num_livre_5, num_livre_6, 
                                       num_livre_7, num_livre_8, num_livre_9, num_livre_10, val_livre_1, 
                                       val_livre_2, val_livre_3, val_livre_4, val_livre_5, val_livre_6, 
                                       val_livre_7, val_livre_8, val_livre_9, val_livre_10, log_livre_1, 
                                       log_livre_2, log_livre_3, log_livre_4, log_livre_5, log_livre_6, 
                                       log_livre_7, log_livre_8, log_livre_9, log_livre_10, dat_livre_1, 
                                       dat_livre_2, dat_livre_3, dat_livre_4, dat_livre_5, dat_livre_6, 
                                       dat_livre_7, dat_livre_8, dat_livre_9, dat_livre_10, cdn_tipo_dep, 
                                       progress_recid)
                   Values (Rx.nrregistro_prest /*idi_pessoa*/, Rx.nrregistro_dependente /*cdd_pessoa_dep*/,
                           Rx.log_irrf, Rx.log_salario_familia,
                           ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', Null, /*cod_livre_1~10*/
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*num_livre_1~10*/
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*val_livre_1~10*/
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*log_livre_1~10*/
                           Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, /*dat_livre_1~10*/
                           Rx.cdn_tipo_dep, gp.pessoa_dep_seq.nextval);
           exception
             when dup_val_on_index then null;
           end;
        Else
          vHouveFalha := 'S';
          --
          If (vExistePessoaPrest = 0) Then
            Begin
              Select NOPESSOA
              Into   vNome
              From   PESSOA
              Where  NRREGISTRO = Rx.nrregistro_prest;
            Exception
              When Others Then Null;
            End;
            --
            dbms_output.put_line('Erro. Prestador não localizado no cadastro de Pessoa Física do TOTVS. Nome: ' ||
                                 vNome || ' - Reg. '|| Rx.nrregistro_prest || ' - ' || SQLERRM);
          End If;
          --
          If (vExistePessoaDep = 0) Then
            Begin
              Select NOPESSOA
              Into   vNome
              From   PESSOA
              Where  NRREGISTRO = Rx.nrregistro_dependente;
            Exception
              When Others Then Null;
            End;
            --
            dbms_output.put_line('Erro. Dependente não localizado no cadastro de Pessoa Física do TOTVS. Nome: ' ||
                                 vNome || ' - Reg. '|| Rx.nrregistro_dependente || ' - ' || SQLERRM);
          End If;          
        End If;
      End Loop;
    End p_prestador_dependente;   

    Procedure p_prestador_subst Is
      Cursor cPrestSubst Is
         Select tm.cdprestador                    cdn_prestdor, 
                ps.cdprestador_subst              cdn_prestdor_subst,
                to_date(tm.dtexclu_prestador) +1  dat_inic_subst
         From   temp_migracao_prestador tm, prestador pr,
                producao.prestador_substituto@unicoo_homologa ps
         Where  ps.nrregistro_prest = tm.nrregistro_prest
         And    pr.nrregistro_prest = tm.nrregistro_prest
         And    pr.aoprest_subst = 'S';
      
      vExistePrestSubst  Number;
      vUnidade           AREA_DE_ACAO.CDAREAACAO%Type;
    Begin
      Select f_parametro('NRUNIMED')
      Into   vUnidade
      From   Dual;
      --
      For Rx In cPrestSubst Loop
        Select Count(*)
        Into   vExistePrestSubst
        From   gp.preserv p
        Where  p.cd_unidade = vUnidade
        And    p.cd_prestador = Rx.cdn_prestdor_subst;
        --
        If (vExistePrestSubst > 0) Then
          begin
            Insert Into SUBST_PRESTDOR_EXCD (cdn_unid, cdn_prestdor, cdn_unid_subst, cdn_prestdor_subst, dat_inic_subst, cod_livre_1, 
                                       cod_livre_2, cod_livre_3, cod_livre_4, cod_livre_5, cod_livre_6, cod_livre_7, 
                                       cod_livre_8, cod_livre_9, cod_livre_10, num_livre_1, num_livre_2, num_livre_3, 
                                       num_livre_4, num_livre_5, num_livre_6, num_livre_7, num_livre_8, num_livre_9, 
                                       num_livre_10, val_livre_1, val_livre_2, val_livre_3, val_livre_4, val_livre_5, 
                                       val_livre_6, val_livre_7, val_livre_8, val_livre_9, val_livre_10, log_livre_1, 
                                       log_livre_2, log_livre_3, log_livre_4, log_livre_5, log_livre_6, log_livre_7, 
                                       log_livre_8, log_livre_9, log_livre_10, dat_livre_1, dat_livre_2, dat_livre_3, 
                                       dat_livre_4, dat_livre_5, dat_livre_6, dat_livre_7, dat_livre_8,  dat_livre_9, 
                                       dat_livre_10, cod_usuar_ult_atualiz, dat_ult_atualiz, progress_recid)
                   Values (to_number(vUnidade) /*cdn_unid*/, Rx.cdn_prestdor, 
                           to_number(vUnidade) /*cdn_unid_subst*/, Rx.cdn_prestdor_subst,
                           Rx.dat_inic_subst,
                           ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', Null, /*cod_livre_1~10*/
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*num_livre_1~10*/
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*val_livre_1~10*/
                           0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*log_livre_1~10*/
                           null, null, null, null, null, null, null, null, null, null, /*dat_livre_1~10*/
                           'MIGRACAO' /*cod_usuar_ult_atualiz*/, Trunc(Sysdate) /*dat_ult_atualiz*/,
                           gp.subst_prestdor_excd_seq.nextval);
           exception
             when dup_val_on_index then null;
           end;
        Else
          vHouveFalha := 'S';
          dbms_output.put_line('Erro. Prestador substituto não localizado no cadastro de Prestadores. CRM: ' ||
                               Rx.cdn_prestdor_subst || ' - ' || SQLERRM);
        End If;
      End Loop;

    End p_prestador_subst;
    
    Procedure p_ajusta_certif_prest Is
      Cursor cPrest Is
        Select pe.progress_recid, x.aopossui_reg_certific_espec,
               nvl(x.nrreg_qualificacao_espec,0) nrreg_qualificacao_espec, nvl(x.nrreg_qualificacao_espec_2,0) nrreg_qualificacao_espec_2,
               x.cd_prestador, x.cd_especialid, x.cdginec_obstr, x.cdresidencia
        From   (
                Select to_number(f_parametro('NRUNIMED')) cd_unidade, p.cdprestador cd_prestador,
                       e.nrvinculo cd_vinculo, e.nrespecialidade cd_especialid,
                       to_date(e.dtinic_vinc,'ddmmyyyy') dtinic_vinc, to_date(e.dtfin_vinc,'ddmmyyyy') dtfin_vinc,
                       e.nrreg_qualificacao_espec, e.nrreg_qualificacao_espec_2,
                       e.aopossui_reg_certific_espec, e.cdginec_obstr,
                       decode(e.cdresidencia,'S',1,0) cdresidencia
                From temp_migracao_prest_vinc_espec e, temp_migracao_prestador p
                Where p.nrsequencial = e.nrsequencial
                And   (e.nrreg_qualificacao_espec Is not Null Or e.nrreg_qualificacao_espec_2 Is Not Null)
               ) x, previesp pe
        Where  pe.cd_unidade = x.cd_unidade
        And    pe.cd_prestador = x.cd_prestador
        And    pe.cd_vinculo = x.cd_vinculo
        And    pe.cd_especialid = x.cd_especialid
        And    pe.dt_inicio_validade = x.dtinic_vinc
        And    pe.dt_fim_validade = x.dtfin_vinc;
        
      vRegEspec2 Number;
    Begin
      For Rx In cPrest Loop
        Begin
          vRegEspec2 := to_number(Rx.nrreg_qualificacao_espec_2);
        Exception
          When Others Then
            vHouveFalha := 'S';
            vRegEspec2 := 0;
            dbms_output.put_line('Erro. 2º registro de certificação de especialidade preenchido com valor não numérico. CRM: ' ||
                               Rx.cd_prestador || ' Esp: ' || Rx.cd_especialid || ' - ' || SQLERRM);
        End;
        --
        Update previesp p Set p.log_4 = Decode(Rx.aopossui_reg_certific_espec,'N',0,1),
                              p.cdregistroespecialidade = nvl(Rx.nrreg_qualificacao_espec,'          '),
                              p.dec_1 = vRegEspec2,
                              p.int_2 = Nvl(Rx.cdginec_obstr,0),
                              p.log_2 = Nvl(Rx.cdresidencia,0)  /*Residência Reconhecida pelo MEC*/
                          Where Progress_recid = Rx.progress_recid;
      End Loop;
      --
      Update previesp p Set p.log_4 = 0
                        Where (Trim(p.cdregistroespecialidade) Is Null Or Trim(p.cdregistroespecialidade) = '0')
                        And   (p.dec_1 = 0 Or p.dec_1 Is Null);
    End p_ajusta_certif_prest;
    
    Procedure p_ajusta_endereco_prest Is
      Cursor cEnderPrest Is
        Select p.cd_unidade, p.cd_prestador, p.progress_recid,
               tmp.endereco, tmp.bairro, tmp.cdcidade, tmp.cep, tmp.cdestado, tmp.txcomplemento_endereco
        From   preserv p, temp_migracao_prestador tmp
        Where  tmp.nrunidade = p.cd_unidade
        And    tmp.cdprestador = p.cd_prestador
        And    trim(upper(p.en_rua))||trim(upper(p.en_bairro))||p.cd_cidade||trim(upper(p.en_cep))||trim(upper(p.en_uf))||trim(upper(char_15))
                <>
               trim(upper(tmp.endereco))||trim(upper(tmp.bairro))||tmp.cdcidade||trim(upper(tmp.cep))||trim(upper(tmp.cdestado))||trim(upper(tmp.txcomplemento_endereco));
    Begin
      For Rx In cEnderPrest Loop
        Update preserv p Set p.u##en_rua    = upper(Rx.Endereco),
                             p.en_rua       = upper(Rx.Endereco),
                             p.u##en_bairro = upper(Rx.Bairro),
                             p.en_bairro    = upper(Rx.Bairro),
                             p.cd_cidade    = Rx.cdcidade,
                             p.en_cep       = upper(Rx.Cep),
                             p.en_uf        = upper(Rx.cdestado),
                             p.char_15      = upper(Rx.TxComplemento_Endereco)
                         Where p.progress_recid = Rx.progress_recid;
      End Loop;
    End p_ajusta_endereco_prest;

    -- AJUSTAR FLUXO FINANCEIRO DO PRESTADOR E SEU FORNECEDOR FINANCEIRO CONFORME GRUPO DE FORNECEDOR DO GPS
    procedure p_ajust_fluxo_financ_grp_prest is
    begin
      for x in (select p.progress_recid        RECID_PRESERV,
                       ff.progress_recid       RECID_FF,
                       p.cd_tipo_fluxo         FLUXO_ANTIGO_P,
                       ff.cod_tip_fluxo_financ FLUXO_EMS5,
                       d.cd_tipo_fluxo
                  from gp.preserv                    p,
                       depara_tipo_fluxo_grupo_prest d,
                       ems5.fornec_financ            ff
                 where p.cd_grupo_prestador = d.cd_grupo_prestador_gp
                   and ff.cdn_fornecedor = p.cd_contratante) loop
                   
                   update gp.preserv p set p.cd_tipo_fluxo = x.cd_tipo_fluxo where p.progress_recid = x.recid_preserv;
                   update ems5.fornec_financ ff set ff.cod_tip_fluxo_financ = x.cd_tipo_fluxo where ff.progress_recid = x.recid_ff;
      end loop;
    end p_ajust_fluxo_financ_grp_prest;

    /*Evandro Levi (23/08/2018): Migração dos dados do e-Social*/
    procedure p_migra_esocial is
      cursor cPrestESocial is
          Select tm.nrregistro_prest,
                 tm.nrunidade,
                 tm.cdprestador,
                 ps.nosocial,                                              /*Nome Social*/
                 nvl(de97.cdn_domin, 25) idi_raca,                         /*Raça*/
                 de96.cdn_domin cdn_grau_instrucao,                        /*Grau de Instrução*/
                 nvl(es.cdpais_nasct,'105') cod_pais_nasc,                   /*País de Nascimento*/
                 nvl(es.cdpais_nacio,'105') cod_pais_nacio,                  /*Nacionalidade*/
                 es.dtchegada,                                             /*Data de Chegada no Brasil*/
                 de95.cdn_domin cdn_classif_ingresso,                      /*Classificação do Estrangeiro*/
                 decode(es.aofilhos_bra,'S',1,0) log_possui_filho_bras,    /*Filho Brasileiro?*/
                 decode(es.aocasado_bra,'S',1,0) log_casad_bras,           /*Casado com Brasileiro?*/
                 /*necessidades especiais*/
                 decode(es.aodef_fisica,'S',1,0) log_def_fisica,           /*Deficiência Física*/
                 decode(es.aodef_visual,'S',1,0) log_def_visual,           /*Deficiência Visual*/
                 decode(es.aodef_auditiva,'S',1,0) log_def_auditiva,       /*Deficiência Auditiva*/
                 decode(es.aodef_mental,'S',1,0) log_def_mental,           /*Deficiência Mental*/
                 decode(es.aodef_intelectual,'S',1,0) log_def_intelectual, /*Deficiência Intelectual*/
                 decode(es.aodef_reab,'S',1,0) log_reabil,                 /*Reabilitado / Readaptado*/
                 substr(es.txobs_deficiencia,1,250) txobs_deficiencia,     /*Observações da Definiciência*/
                 es.nrmatr_ctps,        /*Número CTPS*/
                 es.nrserie_ctps,       /*Série CTPS*/
                 es.cduf_ctps,          /*UF CTPS*/
                 es.nrric,              /*Número DNI / RIC*/
                 es.dtric,              /*Data de Expedição DNI / RIC*/
                 es.cdorgaoem_ric,      /*Órgão Emissor DNI / RIC*/
                 /*estado ric*/
                 es.nrrne,              /*Número RNE*/
                 es.dtrne,              /*Data de Expedição RNE*/
                 es.cdorgaoem_rne,      /*Órgão Emissor RNE*/
                 /*estado rne*/
                 es.nrregcnh,           /*Número Registro da CNH*/
                 es.cdcateg_cnh,        /*Categoria CNH*/
                 es.dtvalid_cnh,        /*Data de Validade da CNH*/
                 es.dtcnh,              /*Data de Expedição da CNH*/
                 es.dthabilitacao,      /*Data da Primeira Habilitação*/
                 es.cduf_cnh            /*Estado / UF da CNH*/
          From   temp_migracao_prestador tm,
                 esocial_prestador@unicoo_homologa es,  --Cadastro e-Social do UNICOO
                 pessoa ps,
                 (Select * From gp.domin_esocial Where idi_tip_domin = 97) de97, /*Tabela 97 - Raca e Cor*/
                 (Select * From gp.domin_esocial Where idi_tip_domin = 96) de96, /*Tabela 96 - Grau de Instrução*/
                 (Select * From gp.domin_esocial Where idi_tip_domin = 95) de95  /*Tabela 95 - Classificação de Estrangeiro*/
          where  es.nrregistro = tm.nrregistro_prest
          And    ps.nrregistro = tm.nrregistro_prest
          And    de97.cod_domin_esocial(+) = es.nrracacor
          And    de96.cod_domin_esocial(+) = es.cdgrauinstr
          And    de95.cod_domin_esocial(+) = es.cdclasstrabestrang
          Order By tm.nrunidade, tm.cdprestador;
      --
      vExisteESocial  Number;
      vNecesEspeciais Number;
    begin
      For Rx in cPrestESocial Loop
        --Atualiza no cadastro do Prestador que deve ser informado para o e-Social
        Update PRESERV Set Int_16 = 1 /*marca o prestador pra envio do e-Social*/
                       Where cd_unidade = Rx.nrunidade
                       and   cd_prestador = Rx.cdprestador;
          --Validando se o pretador tem necessidades especiais
        begin
          vNecesEspeciais := 0;
          if ((Rx.log_def_fisica + Rx.log_def_visual + Rx.log_def_auditiva +
               Rx.log_def_mental + Rx.log_def_intelectual + Rx.log_reabil) > 0) then
            vNecesEspeciais := 1;
          End If;
        exception
          when others then
            vNecesEspeciais := 0;
        end;
        --Atualiza o Nome Social do Prestador no cadastro de Pessoa Física
        Update PESSOA_FISICA Set char_3 = nvl(Rx.nosocial,' '),
                                 log_1 = vNecesEspeciais
                             Where id_pessoa = Rx.NrRegistro_Prest;
        --
        Select count(*)
        into   vExisteESocial
        From   gp.pessoa_esocial
        Where  IDI_PESSOA = Rx.NrRegistro_Prest;
        --
        if (vExisteESocial > 0) then
          --update
          Update gp.PESSOA_ESOCIAL Set IDI_RACA              = Rx.idi_raca,
                                       CDN_GRAU_INSTRUCAO    = Rx.cdn_grau_instrucao,
                                       COD_PAIS_NASC         = Rx.cod_pais_nasc,
                                       COD_PAIS_NACION       = Rx.cod_pais_nacio,
                                       DAT_CHEGAD_BRA        = Rx.dtchegada,
                                       CDN_CLASSIF_INGRESSO  = Rx.cdn_classif_ingresso,
                                       LOG_POSSUI_FILHO_BRAS = Rx.log_possui_filho_bras,
                                       LOG_CASAD_BRAS        = Rx.log_casad_bras,
                                       LOG_DEF_FISICA        = Rx.log_def_fisica,
                                       LOG_DEF_VISUAL        = Rx.log_def_visual,
                                       LOG_DEF_AUDITIVA      = Rx.log_def_auditiva,                     
                                       LOG_DEF_MENTAL        = Rx.log_def_mental,                     
                                       LOG_DEF_INTELECTUAL   = Rx.log_def_intelectual,
                                       LOG_REABIL            = Rx.log_reabil,
                                       COD_LIVRE_1           = nvl(Rx.txobs_deficiencia,' '),
                                       COD_CTPS              = nvl(Rx.nrmatr_ctps,' '),
                                       COD_SERIE_CTPS        = nvl(Rx.nrserie_ctps,' '),
                                       COD_UF_CTPS           = nvl(Rx.cduf_ctps,' '),
                                       COD_RIC               = nvl(Rx.nrric,' '),
                                       DAT_EXPEDICAO_RIC     = Rx.dtric,
                                       NOM_ORGAO_EMISSOR_RIC = nvl(Rx.cdorgaoem_ric,' '),
                                       /*COD_LIVRE_3 = --Estado RIC - Esta informação não existe no UNICOO*/
                                       COD_RNE               = Rx.nrrne,
                                       DAT_EXPEDICAO_RNE     = Rx.dtrne,
                                       NOM_ORGAO_EMISSOR_RNE = nvl(Rx.cdorgaoem_rne,' '),
                                       /*COD_LIVRE_4 = --Estado RNE - Esta informação não existe no UNICOO*/
                                       COD_CNH               = nvl(Rx.nrregcnh,' '),
                                       COD_CATEG_CNH         = nvl(Rx.cdcateg_cnh,' '),
                                       DAT_VALID_CNH         = Rx.dtvalid_cnh,
                                       DAT_EXPEDICAO_CNH     = Rx.dtcnh,
                                       DAT_PRIMEIRA_CNH      = Rx.dthabilitacao,
                                       COD_UF_CNH            = nvl(Rx.cduf_cnh,' ')
                                 where IDI_PESSOA = Rx.NrRegistro_Prest;
        else
          --insert
          Insert Into gp.PESSOA_ESOCIAL (IDI_PESSOA, COD_NIT, IDI_RACA, CDN_GRAU_INSTRUCAO, COD_PAIS_NASC, COD_PAIS_NACION, 
                                         COD_CTPS, COD_SERIE_CTPS, COD_UF_CTPS, COD_RIC, NOM_ORGAO_EMISSOR_RIC, DAT_EXPEDICAO_RIC, 
                                         COD_RNE, NOM_ORGAO_EMISSOR_RNE, DAT_EXPEDICAO_RNE, COD_CNH, DAT_EXPEDICAO_CNH, COD_UF_CNH, 
                                         DAT_VALID_CNH, DAT_PRIMEIRA_CNH, DAT_CHEGAD_BRA, CDN_CLASSIF_INGRESSO, LOG_CASAD_BRAS, 
                                         LOG_POSSUI_FILHO_BRAS, LOG_DEF_FISICA, LOG_DEF_VISUAL, LOG_DEF_AUDITIVA, LOG_DEF_MENTAL, 
                                         LOG_DEF_INTELECTUAL, LOG_REABIL, LOG_INCAP, COD_LIVRE_1, COD_LIVRE_2, COD_LIVRE_3, COD_LIVRE_4, 
                                         COD_LIVRE_5, COD_LIVRE_6, COD_LIVRE_7, COD_LIVRE_8, COD_LIVRE_9, COD_LIVRE_10, NUM_LIVRE_1, 
                                         NUM_LIVRE_2, NUM_LIVRE_3, NUM_LIVRE_4, NUM_LIVRE_5, NUM_LIVRE_6, NUM_LIVRE_7, NUM_LIVRE_8, 
                                         NUM_LIVRE_9, NUM_LIVRE_10, VAL_LIVRE_1, VAL_LIVRE_2, VAL_LIVRE_3, VAL_LIVRE_4, VAL_LIVRE_5, 
                                         VAL_LIVRE_6, VAL_LIVRE_7, VAL_LIVRE_8, VAL_LIVRE_9, VAL_LIVRE_10, LOG_LIVRE_1, LOG_LIVRE_2, 
                                         LOG_LIVRE_3, LOG_LIVRE_4, LOG_LIVRE_5, LOG_LIVRE_6, LOG_LIVRE_7, LOG_LIVRE_8, LOG_LIVRE_9, 
                                         LOG_LIVRE_10, DAT_LIVRE_1, DAT_LIVRE_2, DAT_LIVRE_3, DAT_LIVRE_4, DAT_LIVRE_5, DAT_LIVRE_6, 
                                         DAT_LIVRE_7, DAT_LIVRE_8, DAT_LIVRE_9, DAT_LIVRE_10, COD_CATEG_CNH, PROGRESS_RECID)
                 Values (Rx.NrRegistro_Prest, /*idi_pessoa*/
                         ' ', /*cod_nit*/
                         Rx.idi_raca, /*idi_raca*/
                         Rx.cdn_grau_instrucao, /*cdn_grau_instrucao*/
                         Rx.cod_pais_nasc, /*cod_pais_nasc*/
                         Rx.cod_pais_nacio, /*cod_pais_nacio*/
                         nvl(Rx.nrmatr_ctps,' '), /*cod_ctps*/
                         nvl(Rx.nrserie_ctps,' '), /*cod_serie_ctps*/
                         nvl(Rx.cduf_ctps,' '), /*cod_uf_ctps*/
                         nvl(Rx.nrric,' '), /*cod_ric*/
                         nvl(Rx.cdorgaoem_ric,' '), /*nom_orgao_emissor_ric*/
                         Rx.dtric, /*dat_expedicao_ric*/
                         nvl(Rx.nrrne,' '), /*cod_rne*/
                         nvl(Rx.cdorgaoem_rne,' '), /*nom_orgao_emissor_rne*/
                         Rx.dtrne, /*dat_expedicao_rne*/
                         nvl(Rx.nrregcnh,' '), /*cod_cnh*/
                         Rx.dtcnh, /*dat_expedicao_cnh*/
                         nvl(Rx.cduf_cnh,' '), /*cod_uf_cnh*/
                         Rx.dtvalid_cnh, /*dat_valid_cnh*/
                         Rx.dthabilitacao, /*dat_primeira_cnh*/
                         Rx.dtchegada, /*dat_chegad_bra*/
                         Rx.cdn_classif_ingresso, /*cdn_classif_ingresso*/
                         Rx.log_casad_bras, /*log_casad_bras*/
                         Rx.log_possui_filho_bras, /*log_possui_filho_bras*/
                         Rx.log_def_fisica, /*log_def_fisica*/
                         Rx.log_def_visual, /*log_def_visual*/
                         Rx.log_def_auditiva, /*log_def_auditiva*/
                         Rx.log_def_mental, /*log_def_mental*/
                         Rx.log_def_intelectual, /*log_def_intelectual*/
                         Rx.log_reabil, /*log_reabil*/
                         0, /*log_incap*/
                         nvl(Rx.txobs_deficiencia,' '), /*cod_livre_1 = observações da deficiência*/
                         ' ', /*cod_livre_2*/
                         ' ', /*cod_livre_3 = estado ric*/
                         ' ', /*cod_livre_4 = estado rne*/
                         ' ', ' ', ' ', ' ', ' ', /*cod_livre_5 ~ 9*/
                         Null, /*cod_livre_10 - long*/
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*num_livre_1 ~ 10*/
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*val_livre_1 ~ 10*/
                         0, 0, 0, 0, 0, 0, 0, 0, 0, 0, /*log_livre_1 ~ 10*/
                         Null, Null, Null, Null, Null, Null, Null, Null, Null, Null, /*dat_livre_1 ~ 10*/
                         nvl(Rx.cdcateg_cnh,' '), /*cod_categ_cnh*/
                         gp.pessoa_esocial_seq.nextval);
        end if;
      end loop;
    end p_migra_esocial;

  -- início da execução do método POS_CARGA_TXT
  BEGIN
    delete GP.PREST_AREA_ATU;
    delete GP.PTUGRSER;
    --delete GP.PREST_INST; comentado aqui pois seu insert também está comentado na sequência desse método. revisar.
    delete gp.sitprest;
    delete gp.descprest;  
    delete gp.PRESTDOR_END_INSTIT;  
    --delete gp.prestdor_obs; comentado pois não há carga dessa tabela na sequência desse método. revisar.
    
    --Evandro Levi (17/05/2018): Tratamento para exibir as falhas na aba OUTPUT, após processamento dos scripts de Pós Carga.
    vHouveFalha := 'N';
    DBMS_OUTPUT.ENABLE(null);
  
    P_CARREGA_AREA_ATUACAO;
  
    P_GRUPO_SERVICO_PREST;
  
    p_afastamento_prestador;
  
    P_CARREGA_ACREDITACAO;
    
    p_atualiza_email_observacoes;

    p_atualiza_email_endereco;

    --Evandro Levi (14/05/2018): Atualizar tela DADOS GRADUAÇÃO
    p_dados_graduacao;
    
    --Evandro Levi (17/05/2018): Carregar os dependentes dos prestadores (eSocial)
    p_prestador_dependente;
    
    --Evandro Levi (17/05/2018): Carregar o cadastro de prestadores substitutos
    p_prestador_subst;
    
    --Evandro Levi (23/05/2018): Ajustar todos os endereços migrados do prestador (Endereço e Complemento)
    p_ajusta_endereco_prest;
    
    p_ajusta_certif_prest;
    
    --Alex Boeira (26/07/2018): Ajustar o fluxo financeiro no Prestador (GP) e seu Fornecedor Financeiro (EMS5)
    --                          pois nos processos anteriores (EMS5) eh setado o fluxo de acordo com o maior volume de titulos correspondentes.
    p_ajust_fluxo_financ_grp_prest;
    
    --Evandro Levi (24/08/2018): Carregar dados do Prestador para e-Social
    p_migra_esocial;
    
    UPDATE PRESERV P
       SET P.CD_MOTIVO_CANCEL = PCDMOTIVO_EXCLUSAO_PREST
     WHERE P.DT_EXCLUSAO IS NOT NULL;

    for x in (select ps.progress_recid, tmp.nrregistro_prest, tmp.nrcrm,  tmp.aopublica_ans,
                     tmp.resid_medica
                from temp_migracao_prestador tmp, preserv ps
               where ps.cd_unidade   = tmp.nrunidade
                 and ps.cd_prestador = tmp.cdprestador) loop  
                 
        --corrigir ID_PESSOA quando estiver nulo
        update gp.preserv ps set ps.id_pessoa = x.nrregistro_prest
         where ps.progress_recid = x.progress_recid
           and(ps.id_pessoa      = 0 or ps.id_pessoa is null);
           
        --preencher CRM quando estiver nulo
        update gp.preserv ps set ps.cod_registro = x.nrcrm,
                                 ps.u##cod_registro = x.nrcrm
         where ps.progress_recid = x.progress_recid
           and(ps.cod_registro   = '0' or ps.cod_registro = ' ' or ps.cod_registro is null);

        --ajustar log_15 (ENVIA ANS)
        update gp.preserv ps set ps.log_15 = decode(nvl(x.aopublica_ans,'N'),'S',1,0)
         where ps.progress_recid = x.progress_recid;

        --ajustar log_18 (RESIDENCIA MEDICA)
        /* Evandro Levi (16/05/2018): trecho comentado, pois foi contemplado na "p_dados_graduacao"
        update gp.preserv ps set ps.log_18 = decode(nvl(x.resid_medica,'N'),'S',1,0)
         where ps.progress_recid = x.progress_recid;
        */
           
    end loop;
    
    --ATUALIZAR CODIGO DE HORARIO DE URGENCIA CONFORME DEPARA POR GRUPO
    for x in (select g.cd_grupo_prestador, t.cdhora_urge from gp.gruppres g, TEMP_DEPARA_GRUP_PRES_HORA_URG t
                     where t.cdgruppres = g.cd_grupo_prestador) loop
        update gp.preserv ps set ps.cd_tab_urge = x.cdhora_urge where ps.cd_grupo_prestador = x.cd_grupo_prestador;
        
    end loop;
    
    /*CORRECAO PONTUAL DE CONTA CORRENTE E DIGITO. DESCOMENTAR CASO NECESSARIO
    declare
begin
  for x in (select ps.progress_recid, p.nrconta, p.nrdigito from preserv ps, prestador p 
                 where ps.cd_prestador = p.cdprestador
                   and p.nrconta is not null
                   and p.nrdigito is not null) loop
                   
                   update preserv ps set ps.conta_corren = x.nrconta, ps.dig_conta_corren = x.nrdigito
                          where ps.progress_recid = x.progress_recid;
      
  end loop;
end;
*/

    If (vHouveFalha <> 'S') Then
      RAISE_APPLICATION_ERROR(-20102, 'Verifique os erros na aba OUTPUT (DBMS_OUTPUT)');
    End If;
    commit;
  END POS_CARGA_TXT;

BEGIN

  PCLSMATER := F_PARAMETRO('CLSMATER');
  PCLSMEDIC := F_PARAMETRO('CLSMEDIC');
  PCLTAXA   := F_PARAMETRO('CLTAXA');
  PCLASDIA  := F_PARAMETRO('CLASDIA');
  PCIDADE   := F_PARAMETRO('NOCIDADE');
  PNOESTADO := F_PARAMETRO('NOESTADO');
  PNRUNIMED := F_PARAMETRO('NRUNIMED');
  PCATEGSUS := F_PARAMETRO('CATEGSUS');
  PNRCEP    := FN_TIRARMASCARA(F_PARAMETRO('NRCEP'), 8);
  PFLUXO_PJ := EMS506UNICOO.F_TI_PARAMETRO_INTEGRACAO('COD_TIP_FLUXO_FINANC_PREFER_FOR_J');
  PFLUXO_PF := EMS506UNICOO.F_TI_PARAMETRO_INTEGRACAO('COD_TIP_FLUXO_FINANC_PREFER_FOR_F');

  PCDESPECIALIDADE         := F_TM_PARAMETRO('CDESPECIALIDADE_DEFAULT');
  PNRENDERECO              := F_TM_PARAMETRO('NRENDERECO_DEFAULT');
  PPORTADOR                := F_TM_PARAMETRO('CDPORTADOR');
  PBANCO                   := F_TM_PARAMETRO('CDBANCO');
  PCDESTADODEFAULT         := F_TM_PARAMETRO('CDESTADODEFAULT');

  PCDIMPOSTO_UNICOO        := F_TM_PARAMETRO('CDIMPOSTO_UNICOO');
  PCDCLAS_IMPTO_UNICOO     := F_TM_PARAMETRO('CDCLAS_IMPTO_UNICOO');
  PCDMODALIDADE            := F_TM_PARAMETRO('CDMODALIDADE_PORT_PAG');
  PDESPESA                 := F_TM_PARAMETRO('CDTIPO_DESPESA_PREST');
  PCDMOTIVO_EXCLUSAO_PREST := F_TM_PARAMETRO('CDMOTIVO_EXCLUSAO_PREST');
  PCDMOTIVO_AFASTAMENTO    := F_TM_PARAMETRO('CDMOTIVO_AFASTAMENTO');
  pSEPARADOR_ENDERECO_NUMERO := f_tm_parametro('SEPARADOR_ENDERECO_NUMERO');

END PCK_MIGRACAO_TXT_GP;
/