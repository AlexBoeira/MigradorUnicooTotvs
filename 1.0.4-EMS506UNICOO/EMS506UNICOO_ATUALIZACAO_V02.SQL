CREATE OR REPLACE PACKAGE "PCK_EMS506UNICOO" IS

  /*
  ************************************************************************************************************************************************
  Criac?o          : Alecsandro Ferreira dos Santos
  Data             : 02/07/2009
  Modulo Principal : Integrac?o Unicoo X EMS5
  Modulos          : Integrac?o Unicoo X EMS5
  Objetivo         : Realizar a integrac?o do Unicoo com o EMS5
  Alteracoes
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | DATA       | RESPONSAVEL     | VERSAO          | PENDENCIA | ALTERACAO                                                                       |
  |----------------------------------------------------------------------------------------------------------------------------------------------|
  | 09/03/2012 | Alessandro      |                 |           | - Implementada controle de cancelamento de faturas, para permitir cancelar      |
  |            |                 |                 |           |   faturas no modulo faturamento que est?o contabilizadas no EMS5, foi criado o  |a
  |            |                 |                 |           |   parametro CANCELFTCTBL com o valor "S" utiliza o controle, valor "N" n?o      |
  |            |                 |                 |           |   utiliza o controle.                                                           |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | 21/03/2012 | Alessandro      |                 |           | - Foi realizado correc?o para controla a integrac?o das Faturas Cancelas com o  |
  |            |                 |                 |           |   EMS5, o parametro CANCELFTCTBL foi alterado, com o valor "S" n?o mudou, para  |
  |            |                 |                 |           |   o valor "N" a integrac?o n?o barra o cancelamento no modulo de Faturamento,   |
  |            |                 |                 |           |   mas so envia o estorno para o EMS5 quando o titulo esta contabilizado,        |
  |            |                 |                 |           |   enquanto isso o cancelamento fica pendente na integrac?o com a situac?o ER,   |
  |            |                 |                 |           |   quando o titulo e contabilizado a integrac?o libera o cancelamento            |
  |            |                 |                 |           |   para integrar.                                                                |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | 31/05/2012 | Edmilson Braz Fo|                 |           | - O processo de integracao do ACR estava usando o historico do movimento 1 do   |
  |            |                 |                 |           |   titulo a receber para titulos sem fatura, porem, para o ajius n?o esta sendo  |
  |            |                 |                 |           |   o historico nesse movto, o processo foi alterado para pegar o titulo caso     |
  |            |                 |                 |           |   nulo no movimento.                                                            |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | 26/09/2012 | Josias Rodrigues|                 |           | - Foram impororados os objetos: p_vincula_imposto_fornec,                       |
  |            |                 |                 |           |   p_gerar_dados_banc_fornec, p_contabilizacao                                   |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  ************************************************************************************************************************************************
  */

  -- Public type declarations
  /*  type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  <ConstantName> constant <Datatype> := <Value>;
  
  -- Public variable declarations
  <VariableName> <Datatype>;
  
  
  -- Public function and procedure declarations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;*/

  GCOMMIT           NUMBER := 0;
  GCOUNTOFRECORDS   NUMBER := F_TI_PARAMETRO_INTEGRACAO('COMMIT');
  GSESSAO_MOVIMENTO NUMBER := 500;
  vlmatriz          number := 0;
  TYPE CURSOR_TYPE IS REF CURSOR;

  PROCEDURE P_INS_TI_CONTROLE_INTEGRACAO(PTPINTEGRACAO                  VARCHAR2,
                                         PCDACAO                        VARCHAR2,
                                         PCDIDENTIFICADOR               VARCHAR2,
                                         PNRSEQUENCIAL_ORIGEM           NUMBER,
                                         PCDMODULO                      VARCHAR2,
                                         PCDEMPRESA                     VARCHAR2,
                                         PNRSEQ_CONTROLE_INTEGRACAO_ORG NUMBER);

--  FUNCTION F_MIGRA_VENDEDORES RETURN VARCHAR2;
  procedure P_MIGRA_VENDEDORES;

  PROCEDURE P_DEFINE_TI_PESSOA(PNRCGC_CPF              VARCHAR2,
                               PNOPESSOA               VARCHAR2,
                               PNOABREVIADO            VARCHAR2,
                               PDTNASCIMENTO           DATE,
                               PTPPESSOA               VARCHAR2,
                               PNRREGISTRO             NUMBER,
                               PTPORIGEM               VARCHAR2,
                               PNOABREVIADO_FORNECEDOR IN OUT VARCHAR2,
                               PCDN_FORNECEDOR         IN OUT VARCHAR2,
                               PNOABREVIADO_CLIENTE    IN OUT VARCHAR2,
                               PCDN_CLIENTE            IN OUT VARCHAR2,
                               PAODEFINEPESSOA         VARCHAR2 -- < s/n>
                               );

  /*procedure p_ti_tit_acr_estorno(pnrseq_controle_integracao number,
                              pNRDOCUMENTO                   VARCHAR2,
                              pCDSituacao                in out varchar2);
  */

  PROCEDURE P_TI_TIT_ACR_ESTORNO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                 PNRDOCUMENTO               VARCHAR2,
                                 PCDSITUACAO                IN OUT VARCHAR2,
                                 PNRSESSAO                  NUMBER);

  FUNCTION F_PERMITE_CANCELAR_TI_TIT_ACR(PNRDOCUMENTO        VARCHAR2,
                                         PNRRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2;

  PROCEDURE P_JOB_ERRO;
  PROCEDURE P_JOB_FALHA;

  FUNCTION F_PERMITE_CANC_INT_FI_TIT_APB(PCDUNIMED VARCHAR2,
                                         PNRFATURA VARCHAR2) RETURN VARCHAR2;

  PROCEDURE P_UPDATE_CONTROLE_INTEGRACAO(PNRSEQUENCIAL NUMBER,
                                         PCDSITUACAO   VARCHAR2,
                                         PTXOBSERVACAO VARCHAR2);

  PROCEDURE P_APAGA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO NUMBER);
  PROCEDURE P_JOB;
  FUNCTION F_PERMITE_ALTERAR_TIT_ACR(PNRDOCUMENTO       VARCHAR2,
                                     PNRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2;
  FUNCTION F_PERMITE_ALTERAR_TIT_APB(PNRDOCUMENTO       VARCHAR2,
                                     PNRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2;

  FUNCTION F_PERMITE_CANCELAR_TI_TIT_APB(PNRDOCUMENTO        VARCHAR2,
                                         PNRRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2;
  PROCEDURE P_COMMIT_NEW;
  PROCEDURE P_COMMIT;
  PROCEDURE P_VALIDA_CONTROLE_INTEGRACAO(PTPINTEGRACAO VARCHAR2,
                                         PNRSESSAO     NUMBER);

  PROCEDURE P_MONITOR_INTEGRACAO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                 PTPINTEGRACAO              VARCHAR DEFAULT '*');

  PROCEDURE P_TI_FORNECEDOR(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                            PNRSESSAO                  NUMBER,
                            PCDSITUACAO                IN OUT VARCHAR2);
  PROCEDURE P_REPROCESSA_INTEGRACAO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                    P_TPINTEGRACAO             VARCHAR2);
  /*procedure p_reprocessa_integracao(pNRSeq_Controle_integracao number);*/

  PROCEDURE P_TI_CLIENTE(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                         PNRSESSAO                  NUMBER,
                         PCDSITUACAO                IN OUT VARCHAR2);
  PROCEDURE P_TI_TIT_ACR(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                         PNRSESSAO                  NUMBER,
                         PCDSITUACAO                IN OUT VARCHAR2);
  PROCEDURE P_TI_TIT_APB(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                         PNRSESSAO                  NUMBER,
                         PCDSITUACAO                IN OUT VARCHAR2);

  PROCEDURE P_TI_MOVIMENTO_CTA_CORRENTE(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                        PNRSESSAO                  NUMBER,
                                        PCDSITUACAO                IN OUT VARCHAR2);

  PROCEDURE P_TI_PROCESSA_INTEGRACAO(PTPINTEGRACAO    VARCHAR2,
                                     PNRSEQUENCIAL    NUMBER,
                                     PNRSESSAO        NUMBER,
                                     PCDIDENTIFICADOR VARCHAR2,
                                     PCDSITUACAO      IN OUT VARCHAR2);

  PROCEDURE P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                          PCDINTEGRACAO              VARCHAR2,
                          PTXFALHA                   VARCHAR2,
                          PTXAJUDA                   VARCHAR2,
                          PCDSITUACAO                IN OUT VARCHAR2,
                          PNRMENSAGEM                NUMBER DEFAULT NULL);

  PROCEDURE P_GERAR_DADOS_BANC_FORNEC(VP_COD_EMPRESA IN NUMBER);

  FUNCTION F_RET_MASC_BANCO(VPCOD_BANCO IN VARCHAR2, VPTIPO IN VARCHAR2)
    RETURN NUMBER;

  FUNCTION F_DEFINIR_NUMERICO(VP_CODIGO VARCHAR2) RETURN NUMBER;

  PROCEDURE P_VINCULA_IMPOSTO_FORNEC;
  PROCEDURE P_VINCULA_IMPOSTO_CLIENTE;

  PROCEDURE P_CONTABILIZACAO(PNRSEQ_CONTROLE_INTEGRACAO IN NUMBER,
                             PNRPERIODO                 IN NUMBER,
                             PCDLOTE_INTEGRACAO         IN VARCHAR2,
                             PTXDESCRICAO_LOTE          IN VARCHAR2,
                             PDTLOTE                    IN DATE,
                             PCDEMPRESA                 IN VARCHAR2,
                             PTPPERIODO                 IN VARCHAR2,
                             PI_NRLOTE                  IN NUMBER,
                             PI_CDFUNCIONARIO           IN VARCHAR2);

  PROCEDURE P_INSERE_FORNECEDOR(PNRREGISTRO_TITULO IN NUMBER);
  PROCEDURE P_INSERE_CLIENTE(PNRREGISTRO_TITULO IN NUMBER);
  PROCEDURE VALIDA_TIT_APB(PNRSEQ_CONTROLE_INTEGRACAO IN NUMBER,
                           PCDFORNECEDOR_EMS5         IN NUMBER);

  PROCEDURE P_INS_TI_CONTROLE_INTEGR_CAN(PTPINTEGRACAO                  VARCHAR2,
                                         PCDACAO                        VARCHAR2,
                                         PCDIDENTIFICADOR               VARCHAR2,
                                         PNRSEQUENCIAL_ORIGEM           NUMBER,
                                         PCDMODULO                      VARCHAR2,
                                         PCDEMPRESA                     VARCHAR2,
                                         PNRSEQ_CONTROLE_INTEGRACAO_ORG NUMBER);
  procedure P_CARGA_PESSOA_UNIMED;
  procedure P_COD_UNIMED_FORNECEDOR;

  procedure P_CARGA_INICIAL_FORNECEDOR;

  PROCEDURE P_CARGA_INICIAL_CLIENTE;

  PROCEDURE p_carga_tit_acr;

  PROCEDURE p_carga_tit_apb;

  procedure p_atualiza_status_cliente(p_qtsessoes number);
  procedure p_atualiza_status_cliente_JK(p_qtsessoes number);

  procedure p_atualiza_status_baixa_acr(p_qtsessoes number);
  
  procedure p_atualiza_status_fornecedor(p_qtsessoes number);
  procedure p_atualiza_status_fornec_JK(p_qtsessoes number);

  procedure p_atualiza_status_tit_apb(p_qtsessoes number);
  
  procedure p_atualiza_status_tit_apb_JK(p_qtsessoes number);

--  procedure p_atualiza_status_tit_acr(p_qtsessoes number);

  procedure p_atualiza_status_tit_acr_fech(p_qtsessoes number);
  procedure p_atualiza_status_tit_acr_aber(p_qtsessoes number);

  procedure p_atualiza_status_tit_acr_JK(p_qtsessoes number);
  
  procedure p_gera_carga_matriz_acr;
  procedure p_gera_carga_matriz_apb;
  
  procedure p_apagar_matriz_acr(papagar boolean);
  procedure p_apagar_matriz_apb(papagar boolean);

  procedure p_carga_tit_acr_fechado;

  procedure p_gera_dados_comparativo_acr;

  procedure p_gera_dados_comparativo_apb;

  procedure p_apaga_pessoa_juridica;

  procedure p_reprocessa_status_pe(pnrseq_controle_integracao ti_controle_integracao.nrsequencial%type,
                                   ptpintegracao              ti_controle_integracao.tpintegracao%type);

  procedure p_carga_baixa_tit_acr;
  procedure P_GERA_SERIE_NOTA;  
  procedure p_atualiza_fluxo_financ_fornec;
  procedure P_ATUALIZA_BLOQUEIO_CLIENTE;

procedure insere_hash(ptpintegracao varchar2,
                      pnrsequencial_origem number,
                      pcdidentificador varchar2);

end pck_ems506unicoo;
/
CREATE OR REPLACE PACKAGE BODY "PCK_EMS506UNICOO" IS

  /*  -- Private type declarations
  type <TypeName> is <Datatype>;
  -- Private constant declarations
  <ConstantName> constant <Datatype> := <Value>;
  -- Private variable declarations
  <VariableName> <Datatype>;
  -- Function and procedure implementations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;*/
  /*
  ************************************************************************************************************************************************
  Criac?o          : Alecsandro Ferreira dos Santos
  Data             : 02/07/2009
  Modulo Principal : Integrac?o Unicoo X EMS5
  Modulos          : Integrac?o Unicoo X EMS5
  Objetivo         : Realizar a integrac?o do Unicoo com o EMS5
  Alteracoes
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | DATA       | RESPONSAVEL     | VERSAO          | PENDENCIA | ALTERACAO                                                                       |
  |----------------------------------------------------------------------------------------------------------------------------------------------|
  | 09/03/2012 | Alessandro      |                 |           | - Implementada controle de cancelamento de faturas, para permitir cancelar      |
  |            |                 |                 |           |   faturas no modulo faturamento que est?o contabilizadas no EMS5, foi criado o  |
  |            |                 |                 |           |   parametro CANCELFTCTBL com o valor "S" utiliza o controle, valor "N" n?o      |
  |            |                 |                 |           |   utiliza o controle.                                                           |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | 21/03/2012 | Alessandro      |                 |           | - Foi realizado correc?o para controla a integrac?o das Faturas Cancelas com o  |
  |            |                 |                 |           |   EMS5, o parametro CANCELFTCTBL foi alterado, com o valor "S" n?o mudou, para  |
  |            |                 |                 |           |   o valor "N" a integrac?o n?o barra o cancelamento no modulo de Faturamento,   |
  |            |                 |                 |           |   mas so envia o estorno para o EMS5 quando o titulo esta contabilizado,        |
  |            |                 |                 |           |   enquanto isso o cancelamento fica pendente na integrac?o com a situac?o ER,   |
  |            |                 |                 |           |   quando o titulo e contabilizado a integrac?o libera o cancelamento            |
  |            |                 |                 |           |   para integrar.                                                                |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  | 31/05/2012 | Edmilson Braz Fo|                 |           | - O processo de integracao do ACR estava usando o historico do movimento 1 do   |
  |            |                 |                 |           |   titulo a receber para titulos sem fatura, porem, para o ajius n?o esta sendo  |
  |            |                 |                 |           |   o historico nesse movto, o processo foi alterado para pegar o titulo caso     |
  |            |                 |                 |           |   nulo no movimento.                                                            |
  +----------------------------------------------------------------------------------------------------------------------------------------------+
  ************************************************************************************************************************************************
  */
  -- parametros genericos
  VVERSAOFINANCEIRO VARCHAR2(10);

  PCPF_DTNASCIMENTO  TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  pcdempresa_tit_acr TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  pdtini_tit_acr     TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  pdtfim_tit_acr     TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  pcdempresa_tit_apb TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  pdtini_tit_apb     TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  pdtfim_tit_apb     TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;

  PMIGRAR_TITULOS_ACR_FECHADOS TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  PDT_INI_TITULOS_ACR_FECHADOS TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  PDT_CONTABIL_APB TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;
  PDT_CONTABIL_ACR TI_PARAMETRO_INTEGRACAO.CDPARAMETRO%TYPE;

  TTIT_AP TIT_AP%ROWTYPE;

  FUNCTION md5 (valor VARCHAR) RETURN VARCHAR2 IS
     v_input VARCHAR2(32000) := valor;
     hexkey VARCHAR2(32) := NULL;
  BEGIN
     hexkey := RAWTOHEX(DBMS_OBFUSCATION_TOOLKIT.md5(input => UTL_RAW.cast_to_raw(v_input)));
     RETURN NVL(hexkey,'');
  END;

  function gerar_hash_fornecedor_unicoo(pcdidentificador varchar2, pnrsequencial_origem number)
    return varchar2 is
    v_linha       varchar2(32000) := ' ';
    v_linha_final varchar2(32000) := ' ';
    v_retorno     varchar2(100);
  begin
    begin
      select f.cdfornecedor || f.cdgrupo_fornecedor ||
             f.cdsituacao_fornecedor || f.nrregistro_fornecedor ||
             f.dtexclusao || f.cdconta_contabil || f.cdforma_pagamento ||
             f.nrbanco || f.nragencia || f.nrconta_corrente ||
             f.dtultima_movimentacao || f.nrprevidencia ||
             f.cdcondicaopagamento || f.nrdiaentrega || f.txnegociacao ||
             f.txobservacao || f.vllimitecredito ||
             f.dtalteracaolimitecredito || f.cdusuariolimitecredito ||
             f.vllimitecreditogasto || f.vllimitecreditodisponivel ||
             f.dtinclusao || f.cdusuarioinclusao || f.dtfundacao ||
             f.vltotalcompras || f.nrmediaatraso || f.vlprimeiracompras ||
             f.dtprimeiracompras || f.vlultimacompras || f.dtultimacompras ||
             f.vlmaiorcompras || f.dtmaiorcompras || f.vlultimacotacao ||
             f.dtultimacotacao || f.dtalteracao || f.cdusuarioalteracao ||
             f.cdusuarioexclusao || f.nofantasia || f.aocamara ||
             f.txadmin_camara || f.aoparticipa_encontro || f.cdemail ||
             f.nrlayout || f.aosempre_participa_dirf ||
             f.dtvalidadeconsultanvisa || f.cdtipo_enquadramento_empresa ||
             f.aoopcao_simples_nacional || f.cdcodigofornimp
        into v_linha
        from producao.fornecedor@unicoo_homologa f
       where f.cdfornecedor = pcdidentificador;
    exception
      when others then
        v_linha := pcdidentificador;
    end;
  
    v_linha_final := v_linha;
  
    begin
      select p.nrregistro || p.nopessoa || p.cdsitpessoa || p.tppessoa ||
             p.nrcgc_cpf || p.nrinscest_rg || p.cdramoativ ||
             p.dtnascimento || p.cdsexo || p.cdestadocivil || p.nomae ||
             p.nrreg_nascto || p.nocartorio_reg || p.txobservacoes ||
             p.nooperador || p.nonaturalidade || p.cdnacionalidade ||
             p.noorgao_emissor_rg || p.nrpis || p.cdgrau_de_instrucao ||
             p.cdreligiao || p.nopai || p.noesposo || p.cdetnia ||
             p.nrinscmun || p.nrcei || p.nrcartao_convenio || p.noabreviado ||
             p.cdpais_emissor_id || p.nrcns || p.dtexpedicao_rg ||
             p.cdestado_emissor_rg || p.nrdeclaracao_nasc_vivo ||
             p.cdcidade_naturalidade || p.aoestrangeiro || p.nosocial ||
             p.norazao_social || p.tpgenero_social
        into v_linha
        from pessoa p
       where p.nrregistro = pnrsequencial_origem;
    exception
      when others then
        v_linha := pnrsequencial_origem;
    end;
  
    v_linha_final := v_linha_final || v_linha;
  
    v_retorno := md5(v_linha_final);
  
    return v_retorno;
  
  end gerar_hash_fornecedor_unicoo;
  
  function gerar_hash_cliente_unicoo(pcdidentificador varchar2, pnrsequencial_origem number)
    return varchar2 is
    v_linha       varchar2(32000) := ' ';
    v_linha_final varchar2(32000) := ' ';
    v_retorno     varchar2(100);
  begin
    begin
      select c.nrregistro_cliente || c.nrcontrato || c.cdgrupo_cliente ||
             c.cdsituacao_cliente || c.cdconta_contabil || c.dtexclusao ||
             c.dtultima_movimentacao || c.aoemite_titulo ||
             c.txmensagem_boleto || c.cdcliente || c.cdcategoria ||
             c.cdclassificacao || c.cdbloqueio || c.vllimitecredito ||
             c.nrprazomaximo || c.dtalteracaolimitecredito ||
             c.cdusuariolimitecredito || c.vltotaldebito ||
             c.vllimite_credito || c.nrprazo_maximo ||
             c.dtalteracao_limite_credito || c.cdusuario_limite_credito ||
             c.vltotal_debito || c.vltotal_credito ||
             c.dtinicio_libera_bloqueio || c.dtfim_libera_bloqueio ||
             c.aodebito_automatico || c.nrbanco || c.nragencia ||
             c.nrconta_corrente || c.cdgrupo_economico ||
             c.dtinicio_deb_automatico || c.dtfim_deb_automatico ||
             c.nrretorno || c.cdformapagamentopadrao || c.cdplanopagamento ||
             c.aogera_dmed
        into v_linha
        from producao.cliente@unicoo_homologa c
       where c.cdcliente = pcdidentificador;
    exception
      when others then
        v_linha := pcdidentificador;
    end;
  
    v_linha_final := v_linha;
  
    begin
      select p.nrregistro || p.nopessoa || p.cdsitpessoa || p.tppessoa ||
             p.nrcgc_cpf || p.nrinscest_rg || p.cdramoativ ||
             p.dtnascimento || p.cdsexo || p.cdestadocivil || p.nomae ||
             p.nrreg_nascto || p.nocartorio_reg || p.txobservacoes ||
             p.nooperador || p.nonaturalidade || p.cdnacionalidade ||
             p.noorgao_emissor_rg || p.nrpis || p.cdgrau_de_instrucao ||
             p.cdreligiao || p.nopai || p.noesposo || p.cdetnia ||
             p.nrinscmun || p.nrcei || p.nrcartao_convenio || p.noabreviado ||
             p.cdpais_emissor_id || p.nrcns || p.dtexpedicao_rg ||
             p.cdestado_emissor_rg || p.nrdeclaracao_nasc_vivo ||
             p.cdcidade_naturalidade || p.aoestrangeiro || p.nosocial ||
             p.norazao_social || p.tpgenero_social
        into v_linha
        from pessoa p
       where p.nrregistro = pnrsequencial_origem;
    exception
      when others then
        v_linha := pnrsequencial_origem;
    end;
  
    v_linha_final := v_linha_final || v_linha;
  
    v_retorno := md5(v_linha_final);
  
    return v_retorno;
  
  end gerar_hash_cliente_unicoo;

function get_hash(ptpintegracao varchar2,
                  pcdidentificador varchar2,
                  pnrsequencial_origem number) return varchar2 is
  hash_anterior varchar2(100);                      
begin
  begin
    select h.txhash into hash_anterior
      from ti_hash h
     where h.tpintegracao = ptpintegracao
       and h.nrsequencial_origem = pnrsequencial_origem
       and h.cdidentificador = pcdidentificador;
  exception
    when NO_DATA_FOUND then
      hash_anterior := ' ';
  end;
       
  return hash_anterior;     
end get_hash;                      

  PROCEDURE VALIDA_TIT_APB(PNRSEQ_CONTROLE_INTEGRACAO IN NUMBER,
                           PCDFORNECEDOR_EMS5         IN NUMBER) IS
    TTI_TIT_APB TI_TIT_APB%ROWTYPE;
    JAEXISTE    NUMBER;
  BEGIN
    SELECT *
      INTO TTI_TIT_APB
      FROM TI_TIT_APB A
     WHERE NRSEQ_CONTROLE_INTEGRACAO = PNRSEQ_CONTROLE_INTEGRACAO;
    BEGIN
      SELECT COUNT(1)
        INTO JAEXISTE
        FROM TIT_AP A, TI_EMPRESA EMP
       WHERE 1 = 1
         AND A.CDN_FORNECEDOR = PCDFORNECEDOR_EMS5
         AND A.COD_TIT_AP = TTI_TIT_APB.COD_TITULO_AP
         AND A.COD_ESPEC_DOCTO = TTI_TIT_APB.COD_ESPEC_DOCTO
         AND A.COD_SER_DOCTO = TTI_TIT_APB.COD_SER_DOCTO
         AND A.COD_EMPRESA = EMP.COD_EMPRESA
         AND A.COD_PARCELA = TTI_TIT_APB.COD_PARCELA
         AND EMP.CDEMPRESA =
             F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA_UNICOO');
      -- fabiano, nao foi encontrado necessidade de manter a delecao deste registro.
      --          delete ti_tit_apb where nrseq_controle_integracao = pnrseq_controle_integracao;
      -- fabiano,  caso encontre mais que 1 titulo, entao gera falha
DBMS_OUTPUT.PUT_LINE( 'P54 ACHOU TITULO NO EMS5? ' || JAEXISTE || ' - ' || pnrseq_controle_integracao);
      IF JAEXISTE > 0 THEN
--        DBMS_OUTPUT.PUT_LINE( 'P55 DELETANDO TI_TIT_APB POIS JÁ EXISTE NO EMS5! ' || pnrseq_controle_integracao);
        delete ti_tit_apb where nrseq_controle_integracao = pnrseq_controle_integracao;
-- teste alex 16/05/2017          RAISE_APPLICATION_ERROR(-20010, 'Titulo ja existe no EMS');
      END IF;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END;
  END VALIDA_TIT_APB;

  PROCEDURE CANCELA_CONTROLE_TIT_IMPOSTOS(PNRSESSAO IN NUMBER) IS
    WTPDOC VARCHAR2(40);
  BEGIN
    /*
       Cancela os controles de titulos do contas a pagar unicoo referentes
       a impostos ( TX ), pois esses titulos n?o s?o integrados para o EMS
    */
    WTPDOC := F_PARAMETRO('TPDOCPRE');
    IF WTPDOC IS NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Parametro TPDOCPRE n?o encontrado');
    END IF;
    FOR X IN (SELECT A.ROWID
                FROM TI_CONTROLE_INTEGRACAO A, TITULO_A_PAGAR B
               WHERE A.NRSEQUENCIAL_ORIGEM = B.NRREGISTRO_TITULO
                 AND A.CDSITUACAO IN ('GE', 'ER', 'PE', 'RC') --ADICIONADO OUTRAS SITUACOES ALEM DE GE --BRAZ 11/11/10
                 AND A.TPINTEGRACAO = 'TP'
                 AND A.NRSESSAO = PNRSESSAO
                 AND B.TPDOCUMENTO = WTPDOC
                 AND NOT EXISTS
               (SELECT 1
                        FROM TAXA_TITULO_INTEGRACAO T
                       WHERE T.NRREGISTRO_TITULO_TAXA = B.NRREGISTRO_TITULO)) LOOP
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDSITUACAO   = 'CA',
             CI.TXOBSERVACAO = 'A integracao do unicoo com o ems5 nao integra titulos de previsao'
       WHERE ROWID = X.ROWID;
    END LOOP;
  END CANCELA_CONTROLE_TIT_IMPOSTOS;

  FUNCTION F_PERMITE_CANCELAR_TI_TIT_ACR(PNRDOCUMENTO        VARCHAR2,
                                         PNRRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2 IS
    VRESULT VARCHAR2(1);
    VCTBZDA NUMBER; -- Alessandro 29/09/2011
    QTD_MOV NUMBER;
    CURSOR C_TITULO IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.TPINTEGRACAO = 'TR'
         AND CI.NRSEQUENCIAL_ORIGEM = PNRRREGISTRO_TITULO
         AND CI.CDIDENTIFICADOR = PNRDOCUMENTO
         AND CI.CDIDENTIFICADOR NOT IN ('CA', 'RE');
    VACHOU BOOLEAN;
  BEGIN
    VACHOU := FALSE;
    FOR L_TITULO IN C_TITULO LOOP
      IF L_TITULO.CDSITUACAO = 'IT' THEN
        VACHOU := TRUE;
      ELSIF L_TITULO.CDSITUACAO IN ('GE', 'ER') THEN
        UPDATE TI_CONTROLE_INTEGRACAO TA
           SET TA.CDSITUACAO = 'CA', TA.TXOBSERVACAO = 'LINHA 152'
         WHERE TA.NRSEQUENCIAL = L_TITULO.NRSEQUENCIAL;
      ELSE
        BEGIN
          UPDATE TI_TIT_ACR TA
             SET TA.CDSITUACAO = 'CA'
           WHERE TA.NRSEQ_CONTROLE_INTEGRACAO = L_TITULO.NRSEQUENCIAL;
          -----
          UPDATE TI_CONTROLE_INTEGRACAO TA
             SET TA.CDSITUACAO = 'CA', TA.TXOBSERVACAO = 'LINHA 166'
           WHERE TA.NRSEQUENCIAL = L_TITULO.NRSEQUENCIAL;
        EXCEPTION
          WHEN OTHERS THEN
            VACHOU := TRUE;
            RAISE_APPLICATION_ERROR(-20101,
                                    'Erro ao cancelar a integrao da fatura ' ||
                                    PNRDOCUMENTO || ' ' || SQLERRM);
        END;
      END IF;
    END LOOP;
    IF VACHOU THEN
      SELECT COUNT(*)
        INTO QTD_MOV
        FROM EMS_MOVIMENTO_TITULO_ACR EMS, MOVTO_TIT_ACR MOV --BRAZ 10/12
       WHERE EMS.NUM_ID_MOVTO_TIT_ACR = MOV.NUM_ID_MOVTO_TIT_ACR
         AND MOV.U##COD_ESTAB = EMS.COD_ESTAB
         AND EMS.NRREGISTRO_TITULO = PNRRREGISTRO_TITULO;
      IF QTD_MOV > 1 THEN
        VRESULT := 'N';
      ELSE
        IF F_TI_PARAMETRO_INTEGRACAO('CANCELFTCTBL') = 'S' THEN
          -- ALESSANDRO 09/03/2012
          -- vResult:='S'; -- Alessandro 07/03/2012
          -- Inicio Alessandro 29/09/2011
          VCTBZDA := 0;
          SELECT MOV.LOG_APROP_CTBL_CTBZDA
            INTO VCTBZDA
            FROM EMS_MOVIMENTO_TITULO_ACR EMS, MOVTO_TIT_ACR MOV --BRAZ 10/12
           WHERE EMS.NUM_ID_MOVTO_TIT_ACR = MOV.NUM_ID_MOVTO_TIT_ACR
             AND MOV.U##COD_ESTAB = EMS.COD_ESTAB
             AND EMS.NRREGISTRO_TITULO = PNRRREGISTRO_TITULO;
          IF VCTBZDA = 0 THEN
            VRESULT := 'N';
            RAISE_APPLICATION_ERROR(-20101,
                                    'Titulo no EMS5 n?o esta contabilizado. Contabilize antes de Cancelar.');
          ELSE
            VRESULT := 'S';
          END IF;
          -- Final Alessandro 29/09/2011
        ELSE
          VRESULT := 'S';
        END IF; -- ALESSANDRO 09/03/2012
      END IF;
    ELSE
      VRESULT := 'S';
    END IF;
    RETURN VRESULT;
  END;

  FUNCTION F_PERMITE_CANCELAR_TI_TIT_APB(PNRDOCUMENTO        VARCHAR2,
                                         PNRRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2 IS
    VRESULT VARCHAR2(1);
    CURSOR C_TITULO IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.TPINTEGRACAO = 'TP'
         AND CI.NRSEQUENCIAL_ORIGEM = PNRRREGISTRO_TITULO
         AND CI.CDIDENTIFICADOR = PNRDOCUMENTO
         AND CI.CDIDENTIFICADOR NOT IN ('CA', 'RE');
    VACHOU BOOLEAN;
  BEGIN
    VACHOU := FALSE;
    FOR L_TITULO IN C_TITULO LOOP
      IF L_TITULO.CDSITUACAO = 'IT' THEN
        VACHOU := TRUE;
      ELSIF L_TITULO.CDSITUACAO IN ('GE', 'ER') THEN
        UPDATE TI_CONTROLE_INTEGRACAO TA
           SET TA.CDSITUACAO = 'CA', TA.TXOBSERVACAO = 'LINHA 250'
         WHERE TA.NRSEQUENCIAL = L_TITULO.NRSEQUENCIAL;
      ELSE
        BEGIN
          UPDATE TI_TIT_APB TA
             SET TA.CDSITUACAO = 'CA'
           WHERE TA.NRSEQ_CONTROLE_INTEGRACAO = L_TITULO.NRSEQUENCIAL;
        EXCEPTION
          WHEN OTHERS THEN
            VACHOU := TRUE;
            RAISE_APPLICATION_ERROR(-20101,
                                    'Erro ao cancelar a integrao da fatura ' ||
                                    PNRDOCUMENTO || ' ' || SQLERRM);
        END;
      END IF;
    END LOOP;
    IF VACHOU THEN
      VRESULT := 'N';
    ELSE
      VRESULT := 'S';
    END IF;
    RETURN VRESULT;
  END;

  FUNCTION F_PERMITE_ALTERAR_TIT_ACR(PNRDOCUMENTO       VARCHAR2,
                                     PNRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2 IS
    VRESULT VARCHAR2(1);
  BEGIN
    -- select DECODE(count(*),0,'S','N')
    SELECT CASE
             WHEN COUNT(*) < 1 THEN
              'S'
             ELSE
              'N'
           END
      INTO VRESULT
      FROM EMS_MOVIMENTO_TITULO_ACR EMS, EMS506UNICOO.TIT_ACR TTA --BRAZ 10/12
     WHERE EMS.NRDOCUMENTO = PNRDOCUMENTO
       AND EMS.NRREGISTRO_TITULO = PNRREGISTRO_TITULO
       AND EMS.NUM_ID_TIT_ACR = TTA.NUM_ID_TIT_ACR
       AND EMS.COD_ESTAB = TTA.U##COD_ESTAB
       AND EMS.IND_TRANS_ACR_ABREV = 'IMPL';
    -----------------------------
    RETURN VRESULT;
  END;

  FUNCTION F_PERMITE_ALTERAR_TIT_APB(PNRDOCUMENTO       VARCHAR2,
                                     PNRREGISTRO_TITULO NUMBER)
    RETURN VARCHAR2 IS
    VRESULT VARCHAR2(1);
  BEGIN
    SELECT DECODE(COUNT(*), 0, 'S', 'N')
      INTO VRESULT
      FROM TI_MOVTO_TIT_AP EMS, TIT_AP TTA
     WHERE EMS.NRDOCUMENTO = PNRDOCUMENTO
       AND EMS.NRREGISTRO_TITULO = PNRREGISTRO_TITULO
       AND EMS.NUM_ID_TIT_AP = TTA.NUM_ID_TIT_AP
       AND EMS.COD_ESTAB = TTA.U##COD_ESTAB
       AND EMS.IND_TRANS_AP_ABREV = 'IMPL';
    -----------------------------
    RETURN VRESULT;
  END;

  PROCEDURE P_INS_TI_CONTROLE_INTEGRACAO(PTPINTEGRACAO                  VARCHAR2,
                                         PCDACAO                        VARCHAR2,
                                         PCDIDENTIFICADOR               VARCHAR2,
                                         PNRSEQUENCIAL_ORIGEM           NUMBER,
                                         PCDMODULO                      VARCHAR2,
                                         PCDEMPRESA                     VARCHAR2,
                                         PNRSEQ_CONTROLE_INTEGRACAO_ORG NUMBER) IS
    VSEQUENCIAL TI_CONTROLE_INTEGRACAO.NRSEQUENCIAL%TYPE;
  BEGIN
    IF NOT F_TI_PARAMETRO_INTEGRACAO('TP_INTEGRACAO_ONLINE_UNICOO_EMS5') LIKE
        '%' || PTPINTEGRACAO || '%' THEN
      RETURN;
    END IF;
    SELECT SQ_TI_CONTROLE_INTEGRACAO.NEXTVAL INTO VSEQUENCIAL FROM DUAL;
    INSERT INTO TI_CONTROLE_INTEGRACAO
      (NRSEQUENCIAL,
       TPINTEGRACAO,
       DTGERACAO,
       NRSEQUENCIAL_ORIGEM,
       DTPROCESSAMENTO,
       DTINTEGRACAO,
       CDACAO,
       CDIDENTIFICADOR,
       CDSITUACAO,
       CDEMPRESA,
       CDMODULO,
       NRSEQ_CONTROLE_INTEGRACAO_ORG)
    VALUES
      (VSEQUENCIAL,
       PTPINTEGRACAO,
       SYSDATE,
       PNRSEQUENCIAL_ORIGEM,
       NULL,
       NULL,
       PCDACAO,
       PCDIDENTIFICADOR,
       'GE',
       PCDEMPRESA,
       PCDMODULO,
       PNRSEQ_CONTROLE_INTEGRACAO_ORG);
  END;

  PROCEDURE P_INS_TI_CONTROLE_INTEGR_CAN(PTPINTEGRACAO                  VARCHAR2,
                                         PCDACAO                        VARCHAR2,
                                         PCDIDENTIFICADOR               VARCHAR2,
                                         PNRSEQUENCIAL_ORIGEM           NUMBER,
                                         PCDMODULO                      VARCHAR2,
                                         PCDEMPRESA                     VARCHAR2,
                                         PNRSEQ_CONTROLE_INTEGRACAO_ORG NUMBER) IS
    VSEQUENCIAL TI_CONTROLE_INTEGRACAO.NRSEQUENCIAL%TYPE;
  BEGIN
    IF NOT F_TI_PARAMETRO_INTEGRACAO('TP_INTEGRACAO_ONLINE_UNICOO_EMS5') LIKE
        '%' || PTPINTEGRACAO || '%' THEN
      RETURN;
    END IF;
    SELECT SQ_TI_CONTROLE_INTEGRACAO.NEXTVAL INTO VSEQUENCIAL FROM DUAL;
    INSERT INTO TI_CONTROLE_INTEGRACAO
      (NRSEQUENCIAL,
       TPINTEGRACAO,
       DTGERACAO,
       NRSEQUENCIAL_ORIGEM,
       DTPROCESSAMENTO,
       DTINTEGRACAO,
       CDACAO,
       CDIDENTIFICADOR,
       CDSITUACAO,
       CDEMPRESA,
       CDMODULO,
       NRSEQ_CONTROLE_INTEGRACAO_ORG)
    VALUES
      (VSEQUENCIAL,
       PTPINTEGRACAO,
       SYSDATE,
       PNRSEQUENCIAL_ORIGEM,
       NULL,
       NULL,
       PCDACAO,
       PCDIDENTIFICADOR,
       'CA',
       PCDEMPRESA,
       PCDMODULO,
       PNRSEQ_CONTROLE_INTEGRACAO_ORG);
  END;

  PROCEDURE P_DEFINE_TI_PESSOA(PNRCGC_CPF              VARCHAR2,
                               PNOPESSOA               VARCHAR2,
                               PNOABREVIADO            VARCHAR2,
                               PDTNASCIMENTO           DATE,
                               PTPPESSOA               VARCHAR2,
                               PNRREGISTRO             NUMBER,
                               PTPORIGEM               VARCHAR2,
                               PNOABREVIADO_FORNECEDOR IN OUT VARCHAR2,
                               PCDN_FORNECEDOR         IN OUT VARCHAR2,
                               PNOABREVIADO_CLIENTE    IN OUT VARCHAR2,
                               PCDN_CLIENTE            IN OUT VARCHAR2,
                               PAODEFINEPESSOA         VARCHAR2 -- < S/N>
                               ) IS
    VTI_PESSOA       TI_PESSOA%ROWTYPE;
    VTI_PESSOA_PAI   TI_PESSOA%ROWTYPE;
    VCOUNT           NUMBER;
    VEXISTE_PESSOA   CHAR;
    VEXISTE_REGISTRO CHAR;
    CNOM_ABREVIADO   TI_PESSOA.NOABREVIADO_CLIENTE%TYPE := 'p' ||
                                                           PNRREGISTRO;
    VCOD_EMS         NUMBER := 1000;
    VCOD_EMS_AUX     NUMBER := 0;
    VEXISTE_COD      CHAR;
    vaoexiste_nome   char;
    vnom_abrev       varchar2(12);
    qttamanho        number;
    vnum_aux         number := 0;
    vcount           number;

    FUNCTION F_TESTA_NOME(PNOME_ABREV TI_PESSOA.NOABREVIADO_CLIENTE%TYPE)
      RETURN CHAR IS

      VEXISTE_NOME CHAR;

    BEGIN
      BEGIN
        SELECT 'S'
          INTO VEXISTE_NOME
          FROM TI_PESSOA P
         WHERE P.NOABREVIADO_CLIENTE = PNOME_ABREV
           AND ROWNUM = 1;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VEXISTE_NOME := 'N';
      END;

      RETURN VEXISTE_NOME;

    END;
    --======================--
    -- Definir a Pessoa Pai --
    --------------------------
    PROCEDURE P_DEFINE_PESSOA_PAI IS
    BEGIN
      IF PTPPESSOA = 'F' THEN
        BEGIN
          --============--
          -- CPF / NOME --
          ----------------
          SELECT TI.*
            INTO VTI_PESSOA_PAI
            FROM PESSOA PS, TI_PESSOA TI
           WHERE TI.NRREGISTRO = PS.NRREGISTRO
             AND PS.NRCGC_CPF = PNRCGC_CPF
             AND PS.NOPESSOA = PNOPESSOA --trata tipo de pessoa e cnpj iguais....
             AND PS.TPPESSOA = PTPPESSOA
             AND TI.NRREGISTRO_PAI IS NULL
             AND ROWNUM = 1
           ORDER BY TI.NRREGISTRO DESC;
          VTI_PESSOA_PAI.TXREGRA_AGRUPAMENTO := 'CPF_PESSOA';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN

            IF PCPF_DTNASCIMENTO = 'S' THEN
              BEGIN
                --==========================--
                -- CPF / DATA DE NASCIMENTO --
                ------------------------------
                SELECT TI.*
                  INTO VTI_PESSOA_PAI
                  FROM PESSOA PS, TI_PESSOA TI
                 WHERE TI.NRREGISTRO = PS.NRREGISTRO
                   AND PS.NRCGC_CPF = PNRCGC_CPF
                   AND PS.DTNASCIMENTO = PDTNASCIMENTO
                   AND PS.TPPESSOA = PTPPESSOA
                   AND PS.DTNASCIMENTO IS NOT NULL
                   AND ROWNUM = 1
                 ORDER BY TI.NRREGISTRO DESC;
                VTI_PESSOA_PAI.TXREGRA_AGRUPAMENTO := 'CPF_DTNASCIMENTO';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  VTI_PESSOA_PAI := NULL;
              END;
            ELSE
              VTI_PESSOA_PAI := NULL;
            END IF;
        END;
      ELSE
        BEGIN
          --======--
          -- CNPJ --
          ----------
          SELECT TI.*
            INTO VTI_PESSOA_PAI
            FROM PESSOA PS, TI_PESSOA TI
           WHERE TI.NRREGISTRO = PS.NRREGISTRO
             AND PS.NRCGC_CPF = PNRCGC_CPF
             AND PS.TPPESSOA = PTPPESSOA
             AND PS.NOPESSOA = PNOPESSOA --trata tipo de pessoa e cnpj iguais....
             AND TI.NRREGISTRO_PAI IS NULL
             AND ROWNUM = 1
           ORDER BY TI.NRREGISTRO DESC;
          VTI_PESSOA_PAI.TXREGRA_AGRUPAMENTO := 'CNPJ';
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            VTI_PESSOA_PAI := NULL;
        END;
      END IF;
    END P_DEFINE_PESSOA_PAI; -- p_define_pessoa_pai

  BEGIN

    VTI_PESSOA_PAI := NULL;
    VEXISTE_COD    := 'N';

    BEGIN
      SELECT 'S'
        INTO VEXISTE_REGISTRO
        FROM TI_PESSOA T
       WHERE T.NRREGISTRO = PNRREGISTRO;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        VEXISTE_REGISTRO := 'N';
    END;

    IF VEXISTE_REGISTRO = 'N' THEN

      BEGIN
        SELECT 'S'
          INTO VEXISTE_PESSOA
          FROM TI_PESSOA TP
         WHERE TP.NRCGC_CPF = PNRCGC_CPF
           AND ROWNUM = 1
           and f_ti_parametro_integracao('UNIFICA_PESSOA') = 'S';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VEXISTE_PESSOA := 'N';
      END;

      --SE NAO EXISTE NINGUEM COM ESTE CPF/CNPJ INSERE NA TABELA TI_PESSOA
      IF VEXISTE_PESSOA = 'N' THEN

        VTI_PESSOA.NRREGISTRO          := PNRREGISTRO;
        VTI_PESSOA.NRREGISTRO_PAI      := NULL;
        VTI_PESSOA.TXREGRA_AGRUPAMENTO := NULL;
        VTI_PESSOA.NOPESSOA            := PNOPESSOA;
        VTI_PESSOA.DTNASCIMENTO        := PDTNASCIMENTO;
        VTI_PESSOA.NRCGC_CPF           := PNRCGC_CPF;

        --VINICIUS 30/08 NOVA DEFINICAO PARA NOME ABREVIADO NO EMS5
        --vnom_abrev := trim(F_ABREVIA_NOME(VTI_PESSOA.NOPESSOA, 12, 'PEA'));

        --ALEX 26/04/2018 - USAR NOME ABREVIADO AO INVEZ DO NOME COMPLETO
        vnom_abrev := trim(F_ABREVIA_NOME(replace(nvl(pNOABREVIADO,VTI_PESSOA.NOPESSOA),'UNIMED','U.'), 12, 'PEA'));

        vaoexiste_nome := F_TESTA_NOME(vnom_abrev);

        WHILE vaoexiste_nome = 'S' LOOP

          vnum_aux := vnum_aux + 1;

          qttamanho := length(vnum_aux);

          vnom_abrev := substr(vnom_abrev, 0, (12 - qttamanho)) || vnum_aux;

          vaoexiste_nome := F_TESTA_NOME(vnom_abrev);

        END LOOP;

        VTI_PESSOA.NOABREVIADO_CLIENTE := vnom_abrev;

        VTI_PESSOA.NOABREVIADO_FORNECEDOR := vnom_abrev;

        /* VTI_PESSOA.NOABREVIADO_CLIENTE := CASE
                                              WHEN f_ti_parametro_integracao('INTR_EMS2') = 'S' THEN
                                               SUBSTR(PNRCGC_CPF, 0, 12)
                                              ELSE
                                               PNRCGC_CPF
                                            END;

          VTI_PESSOA.NOABREVIADO_FORNECEDOR := CASE
                                                 WHEN f_ti_parametro_integracao('INTR_EMS2') = 'S' THEN
                                                  SUBSTR(PNRCGC_CPF, 0, 12)
                                                 ELSE
                                                  PNRCGC_CPF
                                               END;
        */

        --SE A ORIGEM FOR "UNIMED" NAO PREENCHE O CODIGO CLIENTE / FORNECEDOR
        IF PTPORIGEM = 'UNIMED' THEN
          VTI_PESSOA.CDN_FORNECEDOR := NULL;
          VTI_PESSOA.CDN_CLIENTE    := NULL;
        ELSE
          --SE A ORIGEM NAO FOR FOR "UNIMED" PREENCHE O CODIGO CLIENTE / FORNECEDOR
        
          --BUSCAR MAIOR CDN_CLIENTE x CDN_FORNECEDOR no EMS5 E GRAVAR EM VCOD_EMS
          BEGIN
            SELECT MAX(CDN_CLIENTE) + 1 INTO VCOD_EMS_AUX FROM ems5.cliente;
          exception
            when others then
              vcod_ems_aux := 0;
          END;
          if vcod_ems_aux > vcod_ems then
            vcod_ems := vcod_ems_aux;
          end if;

          BEGIN
            SELECT MAX(CDN_fornecedor) + 1 INTO VCOD_EMS_AUX FROM ems5.fornecedor;
          exception
            when others then
              vcod_ems_aux := 0;
          END;
          if vcod_ems_aux > vcod_ems then
            vcod_ems := vcod_ems_aux;
          end if;
          
          if VCOD_EMS < 1000 then
            VCOD_EMS := 1000;
          end if;

          BEGIN
            SELECT 'S'
              INTO VEXISTE_COD
              FROM TI_PESSOA TP
             WHERE NVL(TP.CDN_CLIENTE, 0) >= VCOD_EMS
               AND ROWNUM = 1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              VTI_PESSOA.CDN_FORNECEDOR := VCOD_EMS;
              VTI_PESSOA.CDN_CLIENTE    := VCOD_EMS;
          END;

          IF VEXISTE_COD = 'S' THEN
            BEGIN
              SELECT MAX(CDN_CLIENTE) + 1 INTO VCOD_EMS_AUX FROM TI_PESSOA;
            END;
            VTI_PESSOA.CDN_FORNECEDOR := VCOD_EMS_AUX;
            VTI_PESSOA.CDN_CLIENTE    := VCOD_EMS_AUX;

          END IF;

        END IF;

        INSERT INTO TI_PESSOA
          (NRREGISTRO,
           NOABREVIADO_CLIENTE,
           NOABREVIADO_FORNECEDOR,
           CDN_FORNECEDOR,
           CDN_CLIENTE,
           NRREGISTRO_PAI,
           TXREGRA_AGRUPAMENTO,
           NOPESSOA,
           DTNASCIMENTO,
           NRCGC_CPF,
           DTGERACAO,
           DTULTIMA_ATUALIZACAO)
        VALUES
          (VTI_PESSOA.NRREGISTRO,
           VTI_PESSOA.NOABREVIADO_CLIENTE,
           VTI_PESSOA.NOABREVIADO_FORNECEDOR,
           VTI_PESSOA.CDN_FORNECEDOR,
           VTI_PESSOA.CDN_CLIENTE,
           VTI_PESSOA.NRREGISTRO_PAI,
           VTI_PESSOA.TXREGRA_AGRUPAMENTO,
           VTI_PESSOA.NOPESSOA,
           VTI_PESSOA.DTNASCIMENTO,
           VTI_PESSOA.NRCGC_CPF,
           SYSDATE,
           SYSDATE);
        PNOABREVIADO_CLIENTE    := VTI_PESSOA.NOABREVIADO_CLIENTE;
        PNOABREVIADO_FORNECEDOR := VTI_PESSOA.NOABREVIADO_FORNECEDOR;
        PCDN_CLIENTE            := VTI_PESSOA.CDN_CLIENTE;
        PCDN_FORNECEDOR         := VTI_PESSOA.CDN_FORNECEDOR;

      ELSE

        --SE ACHOU UM CPF/CPNJ PROCURA O REGISTRO PAI
        P_DEFINE_PESSOA_PAI;

        --SE ENCONTROU FAZ OS VINCULOS
        IF VTI_PESSOA_PAI.NRREGISTRO IS NOT NULL THEN

          VTI_PESSOA.NRREGISTRO             := PNRREGISTRO;
          VTI_PESSOA.NOABREVIADO_CLIENTE    := VTI_PESSOA_PAI.NOABREVIADO_CLIENTE;
          VTI_PESSOA.NOABREVIADO_FORNECEDOR := VTI_PESSOA_PAI.NOABREVIADO_FORNECEDOR;
          VTI_PESSOA.CDN_FORNECEDOR         := VTI_PESSOA_PAI.CDN_FORNECEDOR;
          VTI_PESSOA.CDN_CLIENTE            := VTI_PESSOA_PAI.CDN_CLIENTE;
          VTI_PESSOA.NRREGISTRO_PAI         := VTI_PESSOA_PAI.NRREGISTRO;
          VTI_PESSOA.TXREGRA_AGRUPAMENTO    := VTI_PESSOA_PAI.TXREGRA_AGRUPAMENTO;
          VTI_PESSOA.NOPESSOA               := PNOPESSOA;
          VTI_PESSOA.DTNASCIMENTO           := PDTNASCIMENTO;
          VTI_PESSOA.NRCGC_CPF              := PNRCGC_CPF;

          INSERT INTO TI_PESSOA
            (NRREGISTRO,
             NOABREVIADO_CLIENTE,
             NOABREVIADO_FORNECEDOR,
             CDN_FORNECEDOR,
             CDN_CLIENTE,
             NRREGISTRO_PAI,
             TXREGRA_AGRUPAMENTO,
             NOPESSOA,
             DTNASCIMENTO,
             NRCGC_CPF,
             DTGERACAO,
             DTULTIMA_ATUALIZACAO)
          VALUES
            (VTI_PESSOA.NRREGISTRO,
             VTI_PESSOA.NOABREVIADO_CLIENTE,
             VTI_PESSOA.NOABREVIADO_FORNECEDOR,
             VTI_PESSOA.CDN_FORNECEDOR,
             VTI_PESSOA.CDN_CLIENTE,
             VTI_PESSOA.NRREGISTRO_PAI,
             VTI_PESSOA.TXREGRA_AGRUPAMENTO,
             VTI_PESSOA.NOPESSOA,
             VTI_PESSOA.DTNASCIMENTO,
             VTI_PESSOA.NRCGC_CPF,
             SYSDATE,
             SYSDATE);
          PNOABREVIADO_CLIENTE    := VTI_PESSOA.NOABREVIADO_CLIENTE;
          PNOABREVIADO_FORNECEDOR := VTI_PESSOA.NOABREVIADO_FORNECEDOR;
          PCDN_CLIENTE            := VTI_PESSOA.CDN_CLIENTE;
          PCDN_FORNECEDOR         := VTI_PESSOA.CDN_FORNECEDOR;

          --SE NAO ENCONTROU INSERE PESSOA COM CPF/CNPJ REPETIDO, MAS ALTERANDO O NOME ABREVIADO
        ELSE

          VTI_PESSOA.NRREGISTRO          := PNRREGISTRO;
          VTI_PESSOA.NRREGISTRO_PAI      := NULL;
          VTI_PESSOA.TXREGRA_AGRUPAMENTO := NULL;
          VTI_PESSOA.NOPESSOA            := PNOPESSOA;
          VTI_PESSOA.DTNASCIMENTO        := PDTNASCIMENTO;
          VTI_PESSOA.NRCGC_CPF           := PNRCGC_CPF;

          --VINICIUS 30/08 NOVA DEFINICAO PARA NOME ABREVIADO NO EMS5
          --vnom_abrev := trim(F_ABREVIA_NOME(VTI_PESSOA.NOPESSOA, 12, 'PEA'));

          --ALEX 26/04/2018 - USAR NOME ABREVIADO AO INVEZ DO NOME COMPLETO
          vnom_abrev := trim(F_ABREVIA_NOME(replace(nvl(pNOABREVIADO,VTI_PESSOA.NOPESSOA),'UNIMED','U.'), 12, 'PEA'));

          vaoexiste_nome := F_TESTA_NOME(vnom_abrev);

          WHILE vaoexiste_nome = 'S' LOOP

            vnum_aux := vnum_aux + 1;

            qttamanho := length(vnum_aux);

            vnom_abrev := substr(vnom_abrev, 0, (12 - qttamanho)) ||
                          vnum_aux;

            vaoexiste_nome := F_TESTA_NOME(vnom_abrev);

          END LOOP;

          VTI_PESSOA.NOABREVIADO_CLIENTE := vnom_abrev;

          VTI_PESSOA.NOABREVIADO_FORNECEDOR := vnom_abrev;

          IF PTPORIGEM = 'UNIMED' THEN
            VTI_PESSOA.CDN_FORNECEDOR := NULL;
            VTI_PESSOA.CDN_CLIENTE    := NULL;
          ELSE

            --BUSCAR MAIOR CDN_CLIENTE x CDN_FORNECEDOR no EMS5 E GRAVAR EM VCOD_EMS
            BEGIN
              SELECT MAX(CDN_CLIENTE) + 1 INTO VCOD_EMS_AUX FROM ems5.cliente;
            exception
              when others then
                vcod_ems_aux := 0;
            END;
            if vcod_ems_aux > vcod_ems then
              vcod_ems := vcod_ems_aux;
            end if;
  
            BEGIN
              SELECT MAX(CDN_fornecedor) + 1 INTO VCOD_EMS_AUX FROM ems5.fornecedor;
            exception
              when others then
                vcod_ems_aux := 0;
            END;
            if vcod_ems_aux > vcod_ems then
              vcod_ems := vcod_ems_aux;
            end if;
            
            if VCOD_EMS < 1000 then
              VCOD_EMS := 1000;
            end if;

            BEGIN
              SELECT 'S'
                INTO VEXISTE_COD
                FROM TI_PESSOA TP
               WHERE NVL(TP.CDN_CLIENTE, 0) >= VCOD_EMS
                 AND ROWNUM = 1;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                VTI_PESSOA.CDN_FORNECEDOR := VCOD_EMS;
                VTI_PESSOA.CDN_CLIENTE    := VCOD_EMS;
            END;

            IF VEXISTE_COD = 'S' THEN
              BEGIN
                SELECT MAX(CDN_CLIENTE) + 1
                  INTO VCOD_EMS_AUX
                  FROM TI_PESSOA;
              END;
              VTI_PESSOA.CDN_FORNECEDOR := VCOD_EMS_AUX;
              VTI_PESSOA.CDN_CLIENTE    := VCOD_EMS_AUX;

            END IF;

          END IF;

          INSERT INTO TI_PESSOA
            (NRREGISTRO,
             NOABREVIADO_CLIENTE,
             NOABREVIADO_FORNECEDOR,
             CDN_FORNECEDOR,
             CDN_CLIENTE,
             NRREGISTRO_PAI,
             TXREGRA_AGRUPAMENTO,
             NOPESSOA,
             DTNASCIMENTO,
             NRCGC_CPF,
             DTGERACAO,
             DTULTIMA_ATUALIZACAO)
          VALUES
            (VTI_PESSOA.NRREGISTRO,
             VTI_PESSOA.NOABREVIADO_CLIENTE,
             VTI_PESSOA.NOABREVIADO_FORNECEDOR,
             VTI_PESSOA.CDN_FORNECEDOR,
             VTI_PESSOA.CDN_CLIENTE,
             VTI_PESSOA.NRREGISTRO_PAI,
             VTI_PESSOA.TXREGRA_AGRUPAMENTO,
             VTI_PESSOA.NOPESSOA,
             VTI_PESSOA.DTNASCIMENTO,
             VTI_PESSOA.NRCGC_CPF,
             SYSDATE,
             SYSDATE);
          PNOABREVIADO_CLIENTE    := VTI_PESSOA.NOABREVIADO_CLIENTE;
          PNOABREVIADO_FORNECEDOR := VTI_PESSOA.NOABREVIADO_FORNECEDOR;
          PCDN_CLIENTE            := VTI_PESSOA.CDN_CLIENTE;
          PCDN_FORNECEDOR         := VTI_PESSOA.CDN_FORNECEDOR;

        END IF;

      END IF;
    ELSE
      --NAO FAZ NADA

      NULL;

    END IF;

  END P_DEFINE_TI_PESSOA;

  PROCEDURE P_JOB_FALHA IS
    CURSOR C_FALHA IS
      SELECT MP.CDACAO, FP.*
        FROM TI_MENSAGEM_PROCESSO MP, TI_FALHA_DE_PROCESSO FP
       WHERE FP.CDINTEGRACAO = MP.CDINTEGRACAO
         AND FP.NRMENSAGEM = MP.NRMENSAGEM;
    VSQL LONG;
  BEGIN
    FOR L_FALHA IN C_FALHA LOOP
      IF L_FALHA.CDACAO = 'CA' THEN
        VSQL := 'update ' || L_FALHA.CDINTEGRACAO || ' set ' ||
                ' cdsituacao=' || '''' || 'CA' || '''' ||
                ' where nrseq_controle_integracao=' ||
                L_FALHA.NRSEQ_CONTROLE_INTEGRACAO;
        EXECUTE IMMEDIATE VSQL;
      ELSIF L_FALHA.CDACAO = 'AT' THEN
        VSQL := 'begin pck_ems506unicoo.p_update_controle_integracao(' ||
                L_FALHA.NRSEQ_CONTROLE_INTEGRACAO ||
                ',f_ti_situacao_integracao(' ||
                L_FALHA.NRSEQ_CONTROLE_INTEGRACAO || ',' || '''' ||
                L_FALHA.CDINTEGRACAO || '''' || '),null ); end;';
        --            dbms_output.put_line(vsql);
        EXECUTE IMMEDIATE VSQL;
        BEGIN
          -- nao apagar falhas
          --pck_ems506unicoo.p_apaga_falha(l_falha.nrseq_controle_integracao);
          NULL;
        END;
      END IF;
      PCK_EMS506UNICOO.P_JOB();
    END LOOP;
  END;

  FUNCTION F_PERMITE_CANC_INT_FI_TIT_APB(PCDUNIMED VARCHAR2,
                                         PNRFATURA VARCHAR2) RETURN VARCHAR2 IS
    VRESULT VARCHAR2(1);
    CURSOR C_TITULO IS
      SELECT *
        FROM AREA_DE_ACAO AA, TITULO_A_PAGAR TP
       WHERE AA.CDPRESTADOR = TP.CDFORNECEDOR
         AND AA.CDAREAACAO = PCDUNIMED
         AND TP.NRDOCUMENTO = PNRFATURA;
    VAOALTERAR VARCHAR2(1);
    VAOCANCELA VARCHAR2(1);
  BEGIN
    VRESULT := 'S';
    FOR L_TITULO IN C_TITULO LOOP
      VAOALTERAR := F_PERMITE_ALTERAR_TIT_APB(L_TITULO.NRDOCUMENTO,
                                              L_TITULO.NRREGISTRO_TITULO);
      IF VAOALTERAR = 'N' THEN
        VRESULT := 'N';
      ELSE
        VAOCANCELA := F_PERMITE_CANCELAR_TI_TIT_APB(L_TITULO.NRDOCUMENTO,
                                                    L_TITULO.NRREGISTRO_TITULO);
        IF VAOCANCELA = 'N' THEN
          VRESULT := 'N';
        END IF;
      END IF;
    END LOOP;
    RETURN VRESULT;
  END;

  PROCEDURE P_UPDATE_CONTROLE_INTEGRACAO(PNRSEQUENCIAL NUMBER,
                                         PCDSITUACAO   VARCHAR2,
                                         PTXOBSERVACAO VARCHAR2) IS
  BEGIN
    UPDATE TI_CONTROLE_INTEGRACAO TI
       SET TI.CDSITUACAO      = PCDSITUACAO,
           TI.TXOBSERVACAO    = PTXOBSERVACAO,
           TI.DTINTEGRACAO    = DECODE(PCDSITUACAO, 'IT', SYSDATE, NULL),
           TI.DTPROCESSAMENTO = SYSDATE
     WHERE TI.NRSEQUENCIAL = PNRSEQUENCIAL;
  END P_UPDATE_CONTROLE_INTEGRACAO;

  PROCEDURE P_AJUSTES IS
    PROCEDURE P_ATUALIZA_NOSSONUMERO IS
      CURSOR C_TITULO IS
        SELECT TI.COD_PARCELA, TA.ROWID, TI.COD_TIT_ACR_BCO
          FROM EMS506UNICOO.TI_TIT_ACR TI, TIT_ACR TA
         WHERE TI.COD_TITULO_ACR = TA.COD_TIT_ACR
           AND TI.COD_SER_DOCTO = TA.COD_SER_DOCTO
           AND TI.COD_ESPEC_DOCTO = TA.COD_ESPEC_DOCTO
           AND TI.COD_PARCELA = TA.COD_PARCELA
           AND TA.COD_TIT_ACR_BCO <> TI.COD_TIT_ACR_BCO
           AND 1 = 2;
    BEGIN
      FOR L_TITULO IN C_TITULO LOOP
        UPDATE TIT_ACR Z
           SET Z.COD_TIT_ACR_BCO    = L_TITULO.COD_TIT_ACR_BCO,
               Z.U##COD_TIT_ACR_BCO = L_TITULO.COD_TIT_ACR_BCO
         WHERE Z.ROWID = L_TITULO.ROWID;
      END LOOP;
    END P_ATUALIZA_NOSSONUMERO;

  BEGIN
    P_ATUALIZA_NOSSONUMERO;
    --          p_atualiza_cliente;
  END P_AJUSTES;

  --=========================--
  -- Grava falha de processo --
  -----------------------------
  PROCEDURE P_APAGA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO NUMBER) IS
  BEGIN
    DELETE FROM TI_FALHA_DE_PROCESSO
     WHERE NRSEQ_CONTROLE_INTEGRACAO = PNRSEQ_CONTROLE_INTEGRACAO;
  END;

  PROCEDURE P_JOB IS
    VTPINTEGRACAO TI_PARAMETRO_INTEGRACAO.VLPARAMETRO%TYPE;
  BEGIN
    VTPINTEGRACAO := F_TI_PARAMETRO_INTEGRACAO('TP_INTEGRACAO_ONLINE_UNICOO_EMS5');
    IF VTPINTEGRACAO LIKE '%' || 'CL' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'CL');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'FN' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'FN');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'TR' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'TR');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'TP' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'TP');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'FT' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'FT');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'CX' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'CX');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'BP' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'BP');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'BR' || '%' THEN
      P_MONITOR_INTEGRACAO(0, 'BR');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'CP' || '%' THEN
      -- cancelamento titulo pagar no ems
      P_MONITOR_INTEGRACAO(0, 'CP');
    END IF;
    IF VTPINTEGRACAO LIKE '%' || 'BC' || '%' THEN
      -- cdhistorico 78
      P_MONITOR_INTEGRACAO(0, 'BC');
    END IF;
    COMMIT;
  END P_JOB;

  PROCEDURE P_JOB_ERRO IS
  BEGIN
    UPDATE TI_CONTROLE_INTEGRACAO CI
       SET CI.CDSITUACAO = 'GE'
     WHERE CI.CDSITUACAO = 'ER';
    P_COMMIT_NEW;
    PCK_EMS506UNICOO.P_JOB();
  END;

  PROCEDURE P_COMMIT IS
  BEGIN
    IF GCOMMIT >= GCOUNTOFRECORDS THEN
      COMMIT;
      GCOMMIT := 0;
    END IF;
    GCOMMIT := GCOMMIT + 1;
  END;

  PROCEDURE P_COMMIT_NEW IS
  BEGIN
    IF GCOMMIT >= GCOUNTOFRECORDS THEN
      --COMMIT;
      GCOMMIT := 0;
    END IF;
    GCOMMIT := GCOMMIT + 1;
  END;

  PROCEDURE P_REENVIA_INTEGRACAO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER) IS
  BEGIN
    UPDATE TI_CLIENTE C
       SET CDSITUACAO = 'RC'
     WHERE C.NRSEQ_CONTROLE_INTEGRACAO = PNRSEQ_CONTROLE_INTEGRACAO;
    --       p_apaga_falha(pNRSeq_Controle_integracao);
  END;

  PROCEDURE P_REPROCESSA_INTEGRACAO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                    P_TPINTEGRACAO             VARCHAR2) IS
    CURSOR C_REPROCESSA IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0)
         AND CI.CDSITUACAO IN ('PE')
         AND ((CI.TPINTEGRACAO = P_TPINTEGRACAO) OR (P_TPINTEGRACAO = '*'))
       ORDER BY CI.NRSEQUENCIAL;
    V_SEQ_CONTROLE_INTEGRACAO NUMBER(10);
  BEGIN
    FOR L_REPROCESSA IN C_REPROCESSA LOOP
      SELECT SQ_TI_CONTROLE_INTEGRACAO.NEXTVAL
        INTO V_SEQ_CONTROLE_INTEGRACAO
        FROM DUAL;
      INSERT INTO TI_CONTROLE_INTEGRACAO
        (NRSEQUENCIAL,
         TPINTEGRACAO,
         DTGERACAO,
         NRSEQUENCIAL_ORIGEM,
         DTPROCESSAMENTO,
         DTINTEGRACAO,
         CDACAO,
         CDIDENTIFICADOR,
         CDSITUACAO,
         NRSEQ_CONTROLE_INTEGRACAO_ORG,
         CDEMPRESA,
         CDMODULO,
         CDMOVIMENTO,
         CDDIVISAO)
        SELECT V_SEQ_CONTROLE_INTEGRACAO,
               TPINTEGRACAO,
               SYSDATE DTGERACAO,
               NRSEQUENCIAL_ORIGEM,
               NULL,
               DTINTEGRACAO,
               L_REPROCESSA.CDACAO,
               CDIDENTIFICADOR,
               'GE',
               L_REPROCESSA.NRSEQUENCIAL,
               L_REPROCESSA.CDEMPRESA,
               L_REPROCESSA.CDMODULO,
               L_REPROCESSA.CDMOVIMENTO,
               L_REPROCESSA.CDDIVISAO
          FROM TI_CONTROLE_INTEGRACAO CI
         WHERE CI.NRSEQUENCIAL = L_REPROCESSA.NRSEQUENCIAL;
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.DTPROCESSAMENTO = SYSDATE, CI.CDSITUACAO = 'RE'
       WHERE CI.NRSEQUENCIAL = L_REPROCESSA.NRSEQUENCIAL;
      IF L_REPROCESSA.TPINTEGRACAO = 'CL' THEN
        UPDATE TI_CLIENTE CL
           SET CL.CDSITUACAO = 'RE' -- REPROCESSA
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'FN' THEN
        UPDATE TI_FORNECEDOR FN
           SET FN.CDSITUACAO = 'RE' -- REPROCESSA
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'TR' THEN
        UPDATE TI_TIT_ACR CL
           SET CL.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'TP' THEN
        UPDATE TI_TIT_APB CL
           SET CL.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'CT' THEN
        UPDATE TI_LOTE_CTBL CL
           SET CL.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'CX' THEN
        UPDATE TI_LOTE_CTBL CL
           SET CL.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO IN ('FT', 'EM') THEN
        UPDATE TI_TIT_ACR_ESTORNO CL
           SET CL.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'BP' THEN
        UPDATE TI_CX_BX_APB BP
           SET BP.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      ELSIF L_REPROCESSA.TPINTEGRACAO = 'BR' THEN
        UPDATE TI_CX_BX_ACR BR
           SET BR.CDSITUACAO = 'RE'
         WHERE NRSEQ_CONTROLE_INTEGRACAO = L_REPROCESSA.NRSEQUENCIAL;
      END IF;
    END LOOP;
    P_COMMIT_NEW;
    PCK_EMS506UNICOO.P_JOB();
  END;

  --======================================================--
  -- Define o mdulo origem dos titulos do contas a pagar --
  ----------------------------------------------------------
  PROCEDURE P_DEFINE_MODULO_TIT_APB(PNRSESSAO TI_CONTROLE_INTEGRACAO.NRSESSAO%TYPE) IS
    CURSOR C_TITULO IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.TPINTEGRACAO = 'TP'
         AND CI.CDMODULO IS NULL
         AND CI.NRSESSAO = PNRSESSAO;
    VCDMOVIMENTO  TI_CONTROLE_INTEGRACAO.CDMOVIMENTO%TYPE;
    VCDDIVISAO    TI_CONTROLE_INTEGRACAO.CDDIVISAO%TYPE;
    VCDMODULO     TI_CONTROLE_INTEGRACAO.CDMODULO%TYPE;
    VCDSITUACAO   TI_CONTROLE_INTEGRACAO.CDSITUACAO%TYPE;
    VTXOBSERVACAO TI_CONTROLE_INTEGRACAO.TXOBSERVACAO%TYPE;
    VQTDESPECIE   NUMBER;
  BEGIN
    FOR L_TITULO IN C_TITULO LOOP
      BEGIN
        --===================================--
        -- Titulos de prestadores e Unimeds --
        ---------------------------------------
        -- Alessandro 18/07/2012
        /*select pr.tpprestador
         into vcdmovimento
         from titulo_a_pagar tp,
              prestador pr
        where
              f_ti_parametro_integracao('CLASSIFICA_INTEGRACAO_PAGPREST') = 'PR'
          and pr.cdprestador                                             = tp.cdfornecedor
          and tp.nrregistro_titulo                                       = l_titulo.nrsequencial_origem
          and tp.cdfuncionario                                          <> 'MVINTEGRA';*/
        SELECT PR.TPPRESTADOR
          INTO VCDMOVIMENTO
          FROM TITULO_A_PAGAR TP, PRESTADOR PR
         WHERE F_TI_PARAMETRO_INTEGRACAO('CLASSIFICA_INTEGRACAO_PAGPREST') = 'PR'
           AND PR.CDPRESTADOR = TP.CDFORNECEDOR
           AND TP.NRREGISTRO_TITULO = L_TITULO.NRSEQUENCIAL_ORIGEM
           AND TP.CDFUNCIONARIO <> 'MVINTEGRA'
              --
              --and tp.tpdocumento <> wtpdoc
           AND TP.NRDOCUMENTO NOT LIKE 'TX%'
              --
           AND NOT EXISTS
         (SELECT 1
                  FROM REM_IMP_CONTROLE_A550 XX
                 WHERE XX.TP_ARQUIVO IN ('4', '6', '8') -- tp_arquivo = 5 -- Receber  -- tp_arquivo = 6 -- Pagar;-- Alessandro 13/05/2014
                   AND XX.NRREGISTRO_TITULO = TP.NRREGISTRO_TITULO);
        -- Alessandro 18/07/2012
        VCDDIVISAO  := NULL;
        VCDMODULO   := 'PR';
        VCDSITUACAO := 'GE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          --=========================--
          -- Titulos de fornecedores --
          -----------------------------

          IF VVERSAOFINANCEIRO = '1' THEN
            BEGIN
              SELECT CDHISTORICO, HT.CDCENTRO_CUSTO
                INTO VCDMOVIMENTO, VCDDIVISAO
                FROM HISTORICO_DO_TITULO_PAGAR HT
               WHERE HT.NRREGISTRO_TITULO = L_TITULO.NRSEQUENCIAL_ORIGEM
                 AND HT.CDMOVIMENTO IN ('1', '3');
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                VCDMOVIMENTO  := NULL;
                VCDMODULO     := NULL;
                VCDDIVISAO    := NULL;
                VCDSITUACAO   := 'CA';
                VTXOBSERVACAO := 'Nao encontrado movimento 1 ou 3 na tabela historico_do_titulo_pagar ';
            END;
          ELSE
            ----------------------------------------------------
            -- Verificar se o titulo tem somente uma especie.
            -- Josias 05-06-2014 - -João Pessoa
            ----------------------------------------------------
            BEGIN
              SELECT COUNT(*)
                INTO VQTDESPECIE
                FROM (SELECT DISTINCT C.COD_ESPEC_DOCTO
                        FROM TITULO_A_PAGAR            TP,
                             DISTRIBUICAO_TITULO_PAGAR DTP,
                             TI_TIPO_MOVIMENTO_TIT_APB C
                       WHERE TP.NRREGISTRO_TITULO = DTP.NRREGISTRO_TITULO
                         AND C.CDEMPRESA = TP.CDEMPRESA
                         AND C.CDMOVIMENTO =
                             TO_CHAR(NVL(DTP.CDHISTORICO, TP.CDHISTORICO))
                         AND TP.NRREGISTRO_TITULO =
                             L_TITULO.NRSEQUENCIAL_ORIGEM);
              --Quando houver mais de uma especie deverá localizar a distribuicao de maior valor,
              --caso o parametro DEFINE_HISTORICO_PADRAO_APB seja igual a GF, o valor do historico sera
              --substituido pelo exitente no cadastro de grupo de fornecedor (ti_grupo_fornecedor)...
              --Inicio trata espécie duplkicada...
              IF VQTDESPECIE > 1 THEN
                BEGIN
                  VTXOBSERVACAO := 'Titulo rateado pelo critério do maior valor';
                  SELECT CDHISTORICO, CDDIVISAO
                    INTO VCDMOVIMENTO, VCDDIVISAO
                    FROM (SELECT NVL(B.CDHISTORICO, HT.CDHISTORICO) CDHISTORICO,
                                 NVL(B.CDDIVISAO, HT.CDDIVISAO) CDDIVISAO,
                                 NVL(SUM(DECODE(B.TIPO_DISTRIB,
                                                'V',
                                                B.VLDISTRIBUICAO,
                                                -1 * B.VLDISTRIBUICAO)),
                                     0) VALOR
                            FROM TITULO_A_PAGAR            HT,
                                 DISTRIBUICAO_TITULO_PAGAR B
                           WHERE HT.NRREGISTRO_TITULO =
                                 B.NRREGISTRO_TITULO(+)
                             AND HT.NRREGISTRO_TITULO =
                                 L_TITULO.NRSEQUENCIAL_ORIGEM
                           GROUP BY NVL(B.CDHISTORICO, HT.CDHISTORICO),
                                    NVL(B.CDDIVISAO, HT.CDDIVISAO)
                           ORDER BY 3 DESC)
                   WHERE ROWNUM = 1;
                  IF F_TI_PARAMETRO_INTEGRACAO('DEFINE_HISTORICO_PADRAO_APB') = 'GF' THEN
                    BEGIN
                      VTXOBSERVACAO := 'Titulo rateado pelo critério do Grupo do Fornecedor';
                      SELECT GF.CD_HISTORICO_PADRAO
                        INTO VCDMOVIMENTO
                        FROM TITULO_A_PAGAR                      TP,
                             PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA FN,
                             TI_GRUPO_DE_FORNECEDOR              GF
                       WHERE GF.CDGRUPO_FORNECEDOR = FN.CDGRUPO_FORNECEDOR
                         AND TP.CDFORNECEDOR = TP.CDFORNECEDOR
                         AND TP.NRREGISTRO_TITULO =
                             L_TITULO.NRSEQUENCIAL_ORIGEM
                         AND GF.CD_HISTORICO_PADRAO IS NOT NULL;
                    EXCEPTION
                      WHEN NO_DATA_FOUND THEN
                        VCDMOVIMENTO  := NULL;
                        VCDMODULO     := NULL;
                        VCDDIVISAO    := NULL;
                        VCDSITUACAO   := 'ER';
                        VTXOBSERVACAO := 'Histórico não cadastrado no Grupo de Fornecedor';
                        P_GRAVA_FALHA(L_TITULO.NRSEQUENCIAL,
                                      'TP',
                                      VTXOBSERVACAO,
                                      NULL,
                                      VCDSITUACAO,
                                      NULL);
                    END;
                  END IF;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    VCDMOVIMENTO  := NULL;
                    VCDMODULO     := NULL;
                    VCDDIVISAO    := NULL;
                    VCDSITUACAO   := 'ER';
                    VTXOBSERVACAO := 'Não encontrado titulo de origem ';
                    P_GRAVA_FALHA(L_TITULO.NRSEQUENCIAL,
                                  'TP',
                                  VTXOBSERVACAO,
                                  NULL,
                                  VCDSITUACAO,
                                  NULL);
                END;
                --Fim trata espécie duplkicada...
              ELSE
                BEGIN
                  SELECT MIN(CDHISTORICO), MIN(CDDIVISAO)
                    INTO VCDMOVIMENTO, VCDDIVISAO
                    FROM (SELECT DISTINCT NVL(B.CDHISTORICO, HT.CDHISTORICO) CDHISTORICO,
                                          NVL(B.CDDIVISAO, HT.CDDIVISAO) CDDIVISAO
                            FROM TITULO_A_PAGAR            HT,
                                 DISTRIBUICAO_TITULO_PAGAR B
                           WHERE HT.NRREGISTRO_TITULO =
                                 B.NRREGISTRO_TITULO(+)
                             AND HT.NRREGISTRO_TITULO =
                                 L_TITULO.NRSEQUENCIAL_ORIGEM);
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    VCDMOVIMENTO  := NULL;
                    VCDMODULO     := NULL;
                    VCDDIVISAO    := NULL;
                    VCDSITUACAO   := 'ER';
                    VTXOBSERVACAO := 'Não encontrado titulo de origem ';
                    P_GRAVA_FALHA(L_TITULO.NRSEQUENCIAL,
                                  'TP',
                                  VTXOBSERVACAO,
                                  NULL,
                                  VCDSITUACAO,
                                  NULL);
                END;
              END IF;
            END;
          END IF;
          IF NVL(VCDSITUACAO, 'x') <> 'ER' THEN
            VCDMODULO   := 'CP';
            VCDSITUACAO := 'GE';
            --====================--
            -- Classifica imposto --
            ------------------------
            BEGIN
              SELECT PR.TPPRESTADOR
                INTO VCDMOVIMENTO
                FROM TAXA_TITULO_INTEGRACAO TTI,
                     TITULO_A_PAGAR         TP,
                     PRESTADOR              PR
               WHERE PR.CDPRESTADOR = TTI.CDFORNECEDOR
                 AND TP.NRREGISTRO_TITULO = TTI.NRREGISTRO_TITULO_TAXA
                 AND TP.NRREGISTRO_TITULO = L_TITULO.NRSEQUENCIAL_ORIGEM
                    --
                 AND NOT EXISTS
               (SELECT 1
                        FROM TAXA_TITULO_INTEGRACAO T
                       WHERE T.NRREGISTRO_TITULO_TAXA = TP.NRREGISTRO_TITULO);
              VCDMODULO  := F_TI_PARAMETRO_INTEGRACAO('CLASSIFICA_IMPOSTO_INTEGRACAO_PAGPREST');
              VCDDIVISAO := NULL;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                NULL;
            END;
          END IF;
      END;
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDMODULO     = VCDMODULO,
             CI.CDMOVIMENTO  = VCDMOVIMENTO,
             CI.CDSITUACAO   = VCDSITUACAO,
             CI.CDDIVISAO    = VCDDIVISAO,
             CI.TXOBSERVACAO = VTXOBSERVACAO
       WHERE CI.NRSEQUENCIAL = L_TITULO.NRSEQUENCIAL;
      P_COMMIT_NEW;
    END LOOP;
  END;

  --========================================================--
  -- Define o mdulo origem dos titulos do contas a receber --
  ------------------------------------------------------------
  PROCEDURE P_DEFINE_MODULO_TIT_ACR(PNRSESSAO TI_CONTROLE_INTEGRACAO.NRSESSAO%TYPE) IS
    CURSOR C_TITULO IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.TPINTEGRACAO = 'TR'
         AND CI.CDMODULO IS NULL
         AND CI.NRSESSAO = PNRSESSAO;
    VCDMOVIMENTO TI_CONTROLE_INTEGRACAO.CDMOVIMENTO%TYPE;
    VCDMODULO    TI_CONTROLE_INTEGRACAO.CDMODULO%TYPE;
    VCDSITUACAO  TI_CONTROLE_INTEGRACAO.CDSITUACAO%TYPE;
  BEGIN
    FOR L_TITULO IN C_TITULO LOOP
      BEGIN
        --====================--
        -- Titulos de faturas --
        ------------------------
        SELECT SUBSTR(FT.NRFATURA, 1, INSTR(FT.NRFATURA, '-') - 1)
          INTO VCDMOVIMENTO
          FROM FATURAMENTO FT
         WHERE FT.NRFATURA = L_TITULO.CDIDENTIFICADOR;
        VCDMODULO   := 'FT';
        VCDSITUACAO := 'GE';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            --===============================--
            -- Titulos de faturas parceladas --
            -----------------------------------
            SELECT SUBSTR(DF.NRFATURA, 1, INSTR(DF.NRFATURA, '-') - 1)
              INTO VCDMOVIMENTO
              FROM DUPLICATA_FATURAMENTO DF
             WHERE DF.NRDUPLICATA = L_TITULO.CDIDENTIFICADOR;
            VCDMODULO   := 'FT';
            VCDSITUACAO := 'GE';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              BEGIN
                --===============================================--
                -- Titulos que no possuem origem no faturamento --
                ---------------------------------------------------
                SELECT NVL(HT.CDHISTORICO, TR.CDHISTORICO)
                  INTO VCDMOVIMENTO
                  FROM HISTORICO_DO_TITULO HT, TITULO_A_RECEBER TR
                 WHERE HT.NRREGISTRO_TITULO = L_TITULO.NRSEQUENCIAL_ORIGEM
                   AND HT.NRREGISTRO_TITULO = TR.NRREGISTRO_TITULO
                   AND
                      --ht.cdmovimento='1';-- Alessandro 21/10/2014
                       HT.CDMOVIMENTO IN ('1', '3'); -- Alessandro 21/10/2014
                VCDMODULO   := 'CR';
                VCDSITUACAO := 'GE';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  VCDMOVIMENTO := NULL;
                  VCDMODULO    := NULL;
                  VCDSITUACAO  := 'CA';
                  -- gravar falha
                WHEN OTHERS THEN
                  VCDMOVIMENTO := NULL;
                  VCDMODULO    := NULL;
                  VCDSITUACAO  := 'CA';
                  -- gravar falha
              END;
          END;
      END;
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDMODULO    = VCDMODULO,
             CI.CDMOVIMENTO = VCDMOVIMENTO,
             CI.CDSITUACAO  = VCDSITUACAO
       WHERE CI.NRSEQUENCIAL = L_TITULO.NRSEQUENCIAL;
    END LOOP;
  END;

  PROCEDURE P_MONITOR_INTEGRACAO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                 PTPINTEGRACAO              VARCHAR DEFAULT '*') IS
    CURSOR C_PROCESSA(PNRSESSAO NUMBER, PTPINTEGRACAO VARCHAR2) IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.NRSESSAO = PNRSESSAO
         AND CI.CDSITUACAO = 'VD'
         AND CI.TPINTEGRACAO NOT IN ('MV', 'FE')
         AND CI.TPINTEGRACAO = PTPINTEGRACAO
       ORDER BY CI.NRSEQUENCIAL;
    VCDSITUACAO VARCHAR2(2);
    /*-------------------------------
    GE --> PI --> PR  // Prepara
    PR --> VI --> VD  // Valida
    VD --> OK         // Processa
    Gerao --> Preparao Inicio --> Preparado
    Preparado --> Validao Inicial --> Validado
    Validado --> OK
    -------------------------------*/
    VNRSESSAO     NUMBER(10);
    VTPINTEGRACAO VARCHAR2(2);
  BEGIN
    WHILE TRUE LOOP
      SELECT SQ_TI_SESSAO.NEXTVAL INTO VNRSESSAO FROM DUAL;
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.NRSESSAO = VNRSESSAO
       WHERE (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0)
         AND (PTPINTEGRACAO = '*' OR PTPINTEGRACAO = CI.TPINTEGRACAO)
         AND CI.CDSITUACAO = 'GE'
         AND ROWNUM <= GSESSAO_MOVIMENTO;
      IF SQL%ROWCOUNT = 0 THEN
        EXIT;
      ELSE
        ----------------------------------------------------------
        P_VALIDA_CONTROLE_INTEGRACAO(PTPINTEGRACAO, VNRSESSAO);
        ----------------------------------------------------------
        IF PTPINTEGRACAO = 'TP' THEN
          P_DEFINE_MODULO_TIT_APB(VNRSESSAO);
        ELSIF PTPINTEGRACAO = 'TR' THEN
          P_DEFINE_MODULO_TIT_ACR(VNRSESSAO);
        END IF;
        --====================--
        -- Prepara Integrao --
        ------------------------
        VCDSITUACAO := 'VD';
        UPDATE TI_CONTROLE_INTEGRACAO CI
           SET CI.CDSITUACAO = VCDSITUACAO
         WHERE CI.NRSESSAO = VNRSESSAO
           AND CI.CDSITUACAO = 'GE'
           AND CI.TPINTEGRACAO NOT IN ('MV', 'FE');
        --=====================--
        -- Processa Integrao --
        -------------------------
        VTPINTEGRACAO := PTPINTEGRACAO;
        FOR L_PROCESSA IN C_PROCESSA(VNRSESSAO, VTPINTEGRACAO) LOOP
          VCDSITUACAO := 'VD';

          P_TI_PROCESSA_INTEGRACAO(L_PROCESSA.TPINTEGRACAO,
                                   L_PROCESSA.NRSEQUENCIAL,
                                   VNRSESSAO,
                                   L_PROCESSA.CDIDENTIFICADOR,
                                   VCDSITUACAO);
        END LOOP;
        P_COMMIT_NEW;
      END IF;
    END LOOP;
    --COMMIT;
  END P_MONITOR_INTEGRACAO;

  PROCEDURE P_VALIDA_CONTROLE_INTEGRACAO(PTPINTEGRACAO VARCHAR2,
                                         PNRSESSAO     NUMBER) IS
  BEGIN
    P_AJUSTES;
    IF (PTPINTEGRACAO = '*' OR PTPINTEGRACAO = 'FT') THEN
      --=============================================--
      -- Cancela integrao de fornecedores diversos --
      -------------------------------------------------
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDSITUACAO   = 'CA',
             CI.TXOBSERVACAO = 'FATURA REATIVADA NO UNICOO'
       WHERE CI.TPINTEGRACAO = 'FT'
         AND CI.CDSITUACAO = 'GE'
         AND CI.NRSESSAO = PNRSESSAO
         AND EXISTS (SELECT 1
                FROM FATURAMENTO FT
               WHERE FT.NRFATURA = CI.CDIDENTIFICADOR
                 AND FT.DTCANCELAMENTO IS NULL);
      --=============================================--
      -- Cancela integrao de fornecedores diversos --
      -------------------------------------------------
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDSITUACAO   = 'CA',
             CI.TXOBSERVACAO = 'FATURA JA CANCELADA NO EMS5'
       WHERE CI.TPINTEGRACAO = 'FT'
         AND CI.CDSITUACAO = 'GE'
         AND CI.NRSESSAO = PNRSESSAO
         AND EXISTS (SELECT 1
                FROM EMS_MOVIMENTO_TITULO_ACR EMS, TIT_ACR TTA
               WHERE TTA.U##COD_ESTAB = EMS.COD_ESTAB
                 AND TTA.NUM_ID_TIT_ACR = EMS.NUM_ID_TIT_ACR
                 AND TTA.LOG_TIT_ACR_ESTORDO = 1
                 AND EMS.NRDOCUMENTO = CI.CDIDENTIFICADOR)
         AND NOT EXISTS
       (SELECT 1
                FROM EMS_MOVIMENTO_TITULO_ACR EMS, TIT_ACR TTA
               WHERE TTA.U##COD_ESTAB = EMS.COD_ESTAB
                 AND TTA.NUM_ID_TIT_ACR = EMS.NUM_ID_TIT_ACR
                 AND TTA.LOG_TIT_ACR_ESTORDO = 0
                 AND EMS.NRDOCUMENTO = CI.CDIDENTIFICADOR);
      --=============================================--
      -- Cancela integrao de fornecedores diversos CASO NAO ENCONTRE TITULO NO EMS--
      -------------------------------------------------
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDSITUACAO   = 'CA',
             CI.TXOBSERVACAO = 'FATURA JA CANCELADA OU NAO INTEGRADA NO EMS5'
       WHERE CI.TPINTEGRACAO = 'FT'
         AND CI.CDSITUACAO = 'GE'
         AND CI.NRSESSAO = PNRSESSAO
         AND NOT EXISTS
       (SELECT 1
                FROM EMS_MOVIMENTO_TITULO_ACR EMS, TIT_ACR TTA
               WHERE TTA.U##COD_ESTAB = EMS.COD_ESTAB
                 AND TTA.NUM_ID_TIT_ACR = EMS.NUM_ID_TIT_ACR
                 AND TTA.LOG_TIT_ACR_ESTORDO = 0
                 AND EMS.NRDOCUMENTO = CI.CDIDENTIFICADOR);
      -- Alessandro 19/03/2012
      --=============================================--
      -- Fatura Integrada com EMS5 e nao Contabilizada
      ------------------------------------------------
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDSITUACAO   = 'ER',
             CI.TXOBSERVACAO = 'FATURA INTEGRADA EMS5 e Nao Contabilizada'
       WHERE CI.TPINTEGRACAO = 'FT'
         AND CI.CDSITUACAO = 'GE'
         AND CI.NRSESSAO = PNRSESSAO --386511633--
         AND EXISTS
       (SELECT 1
                FROM TI_CONTROLE_INTEGRACAO CI1,
                     TI_TIT_ACR_ESTORNO     T,
                     TIT_ACR                TA,
                     MOVTO_TIT_ACR          MT
               WHERE MT.U##COD_ESTAB = TA.U##COD_ESTAB
                 AND MT.NUM_ID_TIT_ACR = TA.NUM_ID_TIT_ACR
                 AND MT.IND_TRANS_ACR_ABREV = 'IMPL'
                 AND TA.NUM_ID_TIT_ACR = T.NUM_ID_TIT_ACR
                 AND CI1.NRSEQUENCIAL = T.NRSEQ_CONTROLE_INTEGRACAO
                 AND MT.LOG_APROP_CTBL_CTBZDA = 0
                 AND CI1.NRSEQUENCIAL = CI.NRSEQUENCIAL);
      -- Alessandro 19/03/2012
    END IF;
    IF (PTPINTEGRACAO = '*' OR PTPINTEGRACAO = 'TP') THEN
      -- cancela os titulos do contas a pagar que sao de impostos, pois nao devem ser integrados
      -----------------------------------------------
      CANCELA_CONTROLE_TIT_IMPOSTOS(PNRSESSAO);
      -----------------------------------------------
      IF F_TI_PARAMETRO_INTEGRACAO('INTEGRA_SOMENTE_TITULOS_PRESTADORES') = 'S' THEN
        --=============================================--
        -- Cancela integrao de fornecedores diversos --
        -------------------------------------------------
        UPDATE TI_CONTROLE_INTEGRACAO CI
           SET CI.CDSITUACAO   = 'CA',
               CI.TXOBSERVACAO = 'A integração do unicoo com o ems5 integra apenas titulos de prestadores'
         WHERE CI.TPINTEGRACAO = 'TP'
           AND CI.CDSITUACAO = 'GE'
           AND CI.NRSESSAO = PNRSESSAO
           AND NOT EXISTS
         (SELECT 1
                  FROM TITULO_A_PAGAR                      TP,
                       PRESTADOR                           PR,
                       PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA FN
                 WHERE FN.CDFORNECEDOR = PR.CDPRESTADOR
                   AND FN.CDFORNECEDOR = TP.CDFORNECEDOR
                   AND CI.NRSEQUENCIAL_ORIGEM = TP.NRREGISTRO_TITULO)
              -- Titulo no  de imposto de prestador com saldo negativo
           AND NOT EXISTS
         (SELECT 1
                  FROM TITULO_A_PAGAR TP --taxa_titulo_integracao tti,
                 WHERE CI.NRSEQUENCIAL_ORIGEM = TP.NRREGISTRO_TITULO);
      END IF;
    END IF;
    IF (PTPINTEGRACAO = '*' OR PTPINTEGRACAO = 'TR') THEN
      IF F_TI_PARAMETRO_INTEGRACAO('INTEGRA_SOMENTE_TITULOS_FATURAMENTO') = 'S' THEN
        --=====================================--
        -- Cancela a integrao de titulos que --
        -- no possuem origem no faturamento   --
        -----------------------------------------
        UPDATE TI_CONTROLE_INTEGRACAO CI
           SET CI.CDSITUACAO   = 'CA',
               CI.TXOBSERVACAO = 'TITULO NO POSSUI ORIGEM NO FATURAMENTO'
         WHERE CI.TPINTEGRACAO = 'TR'
           AND CI.CDSITUACAO = 'GE'
           AND CI.NRSESSAO = PNRSESSAO
           AND NOT EXISTS (SELECT 1
                  FROM FATURAMENTO FT
                 WHERE FT.NRFATURA = CI.CDIDENTIFICADOR)
           AND NOT EXISTS
         (SELECT 1
                  FROM DUPLICATA_FATURAMENTO DF
                 WHERE DF.NRDUPLICATA = CI.CDIDENTIFICADOR);
      END IF;
    END IF;
    IF (PTPINTEGRACAO = '*' OR PTPINTEGRACAO = 'FT') THEN
      UPDATE TI_CONTROLE_INTEGRACAO CI
         SET CI.CDSITUACAO   = 'CA',
             CI.TXOBSERVACAO = 'TITULO CANC NO FATURAMENTO E NAO EXISTE NO EMS/RECEBER UNICOO'
       WHERE CI.CDSITUACAO = 'GE'
         AND CI.NRSESSAO = PNRSESSAO
         AND CI.TPINTEGRACAO = 'FT'
         AND NOT EXISTS
       (SELECT 1
                FROM TI_TIT_ACR_ESTORNO TAC
               WHERE TAC.NRSEQ_CONTROLE_INTEGRACAO = CI.NRSEQUENCIAL)
         AND NOT EXISTS (SELECT 1
                FROM EMS_MOVIMENTO_TITULO_ACR EMS
               WHERE EMS.NRDOCUMENTO = CI.CDIDENTIFICADOR)
         AND NOT EXISTS
       (SELECT 1
                FROM TITULO_A_RECEBER TR
               WHERE TR.NRDOCUMENTO = CI.CDIDENTIFICADOR);
    END IF;
  END P_VALIDA_CONTROLE_INTEGRACAO;

  --=========================--
  -- Grava falha de processo --
  -----------------------------
  PROCEDURE P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                          PCDINTEGRACAO              VARCHAR2,
                          PTXFALHA                   VARCHAR2,
                          PTXAJUDA                   VARCHAR2,
                          PCDSITUACAO                IN OUT VARCHAR2,
                          PNRMENSAGEM                NUMBER DEFAULT NULL) IS
  BEGIN
    PCDSITUACAO := 'ER';
    BEGIN
      INSERT INTO TI_FALHA_DE_PROCESSO
        (NRSEQUENCIAL,
         NRSEQ_CONTROLE_INTEGRACAO,
         CDINTEGRACAO,
         TXFALHA,
         TXAJUDA,
         DTFALHA,
         NRMENSAGEM)
      VALUES
        (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
         PNRSEQ_CONTROLE_INTEGRACAO,
         PCDINTEGRACAO,
         PTXFALHA,
         PTXAJUDA,
         SYSDATE,
         PNRMENSAGEM);
    EXCEPTION
      WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20001,
                                PNRSEQ_CONTROLE_INTEGRACAO || PCDINTEGRACAO ||
                                PTXFALHA || PTXAJUDA);
    END;
    P_UPDATE_CONTROLE_INTEGRACAO(PNRSEQ_CONTROLE_INTEGRACAO,
                                 PCDSITUACAO,
                                 NULL);
  END;

  PROCEDURE P_TIT_PAGAR_CANCELADO_EMS(PNRSEQ_CONTROLE_INTEGRACAO IN NUMBER) IS
    TTI_TIT_APB             TI_TIT_APB%ROWTYPE;
    TTI_CONTROLE_INTEGRACAO TI_CONTROLE_INTEGRACAO%ROWTYPE;
    TTIT_AP                 TIT_AP%ROWTYPE;
    TFORNECEDOR_EMS         FORNECEDOR%ROWTYPE;
    TTIT_CANCDO_APB         TIT_CANCDO_APB%ROWTYPE;
    VSIT                    VARCHAR2(2);
    -- procedure para inserir historico de cancelamento no unicoo
    PROCEDURE INSERE_HISTORICO_80(PNRREGISTRO_TITULO IN NUMBER) IS
      THISTORICO_DO_TITULO_PAGAR HISTORICO_DO_TITULO_PAGAR%ROWTYPE;
    BEGIN
      SELECT *
        INTO THISTORICO_DO_TITULO_PAGAR
        FROM HISTORICO_DO_TITULO_PAGAR
       WHERE NRREGISTRO_TITULO = PNRREGISTRO_TITULO;
      SELECT PRODUCAO.SEQ_NRMOVHIST_PAGAR.NEXTVAL@UNICOO_HOMOLOGA
        INTO THISTORICO_DO_TITULO_PAGAR.NRMOVIMENTO
        FROM DUAL;
      THISTORICO_DO_TITULO_PAGAR.CDMOVIMENTO   := '80';
      THISTORICO_DO_TITULO_PAGAR.CDFUNCIONARIO := 'CANCEMS';
      THISTORICO_DO_TITULO_PAGAR.DTMOVIMENTO   := SYSDATE;
      INSERT INTO HISTORICO_DO_TITULO_PAGAR
      VALUES THISTORICO_DO_TITULO_PAGAR;
    END;

  BEGIN
    -- busca o controle
    SELECT *
      INTO TTI_CONTROLE_INTEGRACAO
      FROM TI_CONTROLE_INTEGRACAO
     WHERE TPINTEGRACAO = 'CP'
       AND NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO;
    -- busca o cancelamento do titulo
    SELECT *
      INTO TTIT_CANCDO_APB
      FROM TIT_CANCDO_APB
     WHERE NUM_ID_TIT_AP = TTI_CONTROLE_INTEGRACAO.NRSEQUENCIAL_ORIGEM;
    -- busca o fornecedor do ems
    SELECT EFN.*
      INTO TFORNECEDOR_EMS
      FROM FORNECEDOR EFN, TI_EMPRESA EMP
     WHERE EFN.CDN_FORNECEDOR = TTIT_CANCDO_APB.CDN_FORNECEDOR
       AND EFN.COD_EMPRESA = EMP.COD_EMPRESA
       AND EMP.CDEMPRESA = F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA_UNICOO');
    SELECT *
      INTO TTI_TIT_APB
      FROM TI_TIT_APB M
     WHERE M.COD_TITULO_AP = TTIT_CANCDO_APB.COD_TIT_AP
       AND M.COD_ID_FEDER = TFORNECEDOR_EMS.COD_ID_FEDER
       AND M.CDSITUACAO = 'IT';
    INSERE_HISTORICO_80(TTI_TIT_APB.NRREGISTRO_TITULO);
    UPDATE TI_CONTROLE_INTEGRACAO
       SET CDSITUACAO = 'IT'
     WHERE NRSEQUENCIAL = TTI_CONTROLE_INTEGRACAO.NRSEQUENCIAL;
  EXCEPTION
    WHEN OTHERS THEN
      P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                    'CP',
                    'Erro ao cancelar o titulo no unicoo',
                    SQLERRM,
                    VSIT);
  END;

  --========================--
  -- Controle de integrao --
  ----------------------------
  PROCEDURE P_TI_PROCESSA_INTEGRACAO(PTPINTEGRACAO    VARCHAR2,
                                     PNRSEQUENCIAL    NUMBER,
                                     PNRSESSAO        NUMBER,
                                     PCDIDENTIFICADOR VARCHAR2,
                                     PCDSITUACAO      IN OUT VARCHAR2) IS
  BEGIN
    IF PTPINTEGRACAO = 'TP' THEN
      --================--
      -- Titulo a pagar --
      --------------------
      P_TI_TIT_APB(PNRSEQUENCIAL, PNRSESSAO, PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'CL' THEN
      --============--
      -- Cliente --
      ----------------
      P_TI_CLIENTE(PNRSEQUENCIAL, PNRSESSAO, PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'FN' THEN
      --============--
      -- Fornecedor --
      ----------------
      P_TI_FORNECEDOR(PNRSEQUENCIAL, PNRSESSAO, PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'TR' THEN
      --==================--
      -- Titulo a receber --
      ----------------------
      P_TI_TIT_ACR(PNRSEQUENCIAL, PNRSESSAO, PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'FT' THEN
      --=============================--
      -- Cancelamento do faturamento --
      ---------------------------------
      P_TI_TIT_ACR_ESTORNO(PNRSEQUENCIAL,
                           PCDIDENTIFICADOR,
                           PCDSITUACAO,
                           PNRSESSAO);
    ELSIF PTPINTEGRACAO = 'CX' THEN
      --=============================--
      -- Caixa e Bancos              --
      ---------------------------------
      P_TI_MOVIMENTO_CTA_CORRENTE(PNRSEQUENCIAL, PNRSESSAO, PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'CP' THEN
      --=============================--
      -- Titulo Cancelado no EMS     --
      ---------------------------------
      P_TIT_PAGAR_CANCELADO_EMS(PNRSEQUENCIAL);
    ELSIF PTPINTEGRACAO = 'BP' THEN
      EMS506UNICOO.PCK_BX_TIT_EMS.P_PROCESSA_APB(PNRSEQUENCIAL,
                                                 PNRSESSAO,
                                                 PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'BR' THEN
      EMS506UNICOO.PCK_BX_TIT_EMS.P_PROCESSA_ACR(PNRSEQUENCIAL,
                                                 PNRSESSAO,
                                                 PCDSITUACAO);
    ELSIF PTPINTEGRACAO = 'BC' THEN
      EMS506UNICOO.PCK_BX78_TIT_EMS.P_PROCESSA_ACR78(PNRSEQUENCIAL,
                                                     PNRSESSAO,
                                                     PCDSITUACAO);
    END IF;
  END P_TI_PROCESSA_INTEGRACAO;

  PROCEDURE P_TI_VALIDA_ENDERECO(PNRREGISTRO                IN NUMBER,
                                 PNRSEQ_CONTROLE_INTEGRACAO IN NUMBER,
                                 PCDINTEGRACAO              IN VARCHAR2,
                                 PCDSITUACAO                IN OUT VARCHAR2) IS
    VCDCIDADE ENDERECO.CDCIDADE%TYPE;
  BEGIN
    BEGIN
      ---------------------
      -- Verifica Endereco --
      ---------------------
      BEGIN
        SELECT CDCIDADE
          INTO VCDCIDADE
          FROM ENDERECO ED
         WHERE ED.NRREGISTRO = PNRREGISTRO
           AND ED.TPENDERECO = F_TI_TIP_ENDERECO(PNRREGISTRO);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- Josias 03-07-2014
          --- pegar como default a cidade do endereço defaul
          SELECT CDCIDADE
            INTO VCDCIDADE
            FROM ENDERECO ED
           WHERE ED.NRREGISTRO = 10405
                --    F_TI_PARAMETRO_INTEGRACAO('NRREGISTRO_ENDERECO_DEFAULT_INCLUSAO') VINICIUS NOVA IGUAÇU
             AND TPENDERECO = 'COBR';
          --  F_TI_TIP_ENDERECO(F_TI_PARAMETRO_INTEGRACAO('NRREGISTRO_ENDERECO_DEFAULT_INCLUSAO'));
      END;
      BEGIN
        ---------------------
        -- Verifica Cidade --
        ---------------------
        SELECT CDCIDADE
          INTO VCDCIDADE
          FROM ENDERECO ED
         WHERE ED.NRREGISTRO = 10405
              -- F_TI_PARAMETRO_INTEGRACAO('NRREGISTRO_ENDERECO_DEFAULT_INCLUSAO') VINICIUS NOVA IGUAÇU
           AND TPENDERECO = 'COBR';
        --  F_TI_TIP_ENDERECO(F_TI_PARAMETRO_INTEGRACAO('NRREGISTRO_ENDERECO_DEFAULT_INCLUSAO'));
        SELECT CDCIDADE
          INTO VCDCIDADE
          FROM PRODUCAO.CIDADE@UNICOO_HOMOLOGA
         WHERE CDCIDADE = VCDCIDADE;
        PCDSITUACAO := 'RC';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                        PCDINTEGRACAO,
                        'Cidade não cadastrada',
                        'Pessoa ==> ' || PNRREGISTRO || ' A Cidade ==> ' ||
                        VCDCIDADE || ' Não existe',
                        PCDSITUACAO,
                        NULL);
        WHEN OTHERS THEN
          P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                        PCDINTEGRACAO,
                        'Cidade no cadastrada',
                        'Pessoa ==> ' || PNRREGISTRO ||
                        ' Erro ao pesquisar cidade ' || SQLERRM,
                        PCDSITUACAO,
                        NULL);
      END;
    EXCEPTION
      /*
      when no_data_found then


                    p_grava_falha(pnrseq_controle_integracao,
                                  pCDIntegracao,
                                  'Endereo no cadastrado',
                                  'Pessoa ==> '||pnrregistro,
                                  pCDSituacao,
                                  null);
       */
      WHEN OTHERS THEN
        P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                      PCDINTEGRACAO,
                      'Erro ao validar o endereo',
                      'Erro ao pesquisar endereco ' || SQLERRM,
                      PCDSITUACAO,
                      NULL);
    END;
  END;

  --==================================--
  -- Grava Fornecedor - TI_FORNECEDOR --
  --------------------------------------
  PROCEDURE P_TI_FORNECEDOR(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                            PNRSESSAO                  NUMBER,
                            PCDSITUACAO                IN OUT VARCHAR2) IS

    --VARIAVEIS PARA TRATAR E REDUZ O ENDERECO
    VQTLOGRA             NUMBER;
    VQTCOMPL             NUMBER;
    VQTLOGRA_REDUZ       NUMBER;
    VQTCOMPL_REDUZ       NUMBER;
    VQTLOGRA_REDUZ_ABREV NUMBER;
    VQTNRIMOVEL          NUMBER;
    VLOGRA               VARCHAR2(50);
    VCOMPL               VARCHAR2(15);
    VLOGRA_REDUZ         VARCHAR2(50);
    VCOMPL_REDUZ         VARCHAR2(15);
    VLOGRA_REDUZ_ABREV   VARCHAR2(50);

    --VLOGRADOURO E VCOMPLEMENTO RECEBERAO OS CONTEUDOS DO ENDERECO E COMPLEMENTO APOS ANALISE DE TAMANHOS
    VLOGRADOURO  VARCHAR2(40);
    VCOMPLEMENTO VARCHAR2(10);
    VBAIRRO      VARCHAR2(25);

    --VARIAVIES QUE CONTROLAM O NUMERO MAXIMO DE REGISTROS NOS CAMPOS DE ENDERECO
    VQTLOGRADOURO  NUMBER := 40;
    VQTCOMPLEMENTO NUMBER := 10;

    CURSOR C_INTEGRA_CLIFOR IS
      SELECT CI.NRSEQUENCIAL NRSEQ_CONTROLE_INTEGRACAO,
             CI.CDSITUACAO,
             CI.CDIDENTIFICADOR,
             CI.CDACAO,
             CI.NRSEQUENCIAL_ORIGEM
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.NRSESSAO = PNRSESSAO
         AND CI.TPINTEGRACAO = 'FN'
         AND CI.CDSITUACAO = PCDSITUACAO
         AND (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0);
    TTI_CONTROLE_INTEGRACAO TI_CONTROLE_INTEGRACAO%ROWTYPE;
    TFORNECEDOR             PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA%ROWTYPE;
    TGRUPO_DE_FORNECEDOR    GRUPO_DE_FORNECEDOR%ROWTYPE;
    TPESSOA                 PESSOA%ROWTYPE;
    TESTADO_CIVIL           ESTADO_CIVIL%ROWTYPE;
    TENDERECO               ENDERECO%ROWTYPE;
    TCIDADE                 PRODUCAO.CIDADE@UNICOO_HOMOLOGA%ROWTYPE;
    TTI_PESSOA              TI_PESSOA%ROWTYPE;
    TTI_GRUPO_DE_FORNECEDOR TI_GRUPO_DE_FORNECEDOR%ROWTYPE;
    TCDN_FORNECEDOR         TI_PESSOA.CDN_FORNECEDOR%TYPE;
    pSEPARADOR_ENDERECO_NUMERO VARCHAR2(5);
  BEGIN
  
    pSEPARADOR_ENDERECO_NUMERO := f_ti_parametro_integracao('SEPARADOR_ENDERECO_NUMERO');
  
    FOR L_INTEGRA_CLIFOR IN C_INTEGRA_CLIFOR LOOP
      BEGIN
        PCDSITUACAO := 'RC';
        BEGIN
          SELECT *
            INTO TFORNECEDOR
            FROM PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA
           WHERE CDFORNECEDOR = L_INTEGRA_CLIFOR.CDIDENTIFICADOR;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20100,
                                    'Forn. no unicoo nao encontrado: ' ||
                                    L_INTEGRA_CLIFOR.CDIDENTIFICADOR);
        END;
        BEGIN
          -----------------------------------------------------------------------
          -- Josias 01-07-2014 - Alteração para pegar o codigo do fornecedor do EMS
          -- que esta gravado na ti_pessoa e nao mais no fornecedor
          -----------------------------------------------------------------------
          SELECT P.CDN_FORNECEDOR
            INTO TCDN_FORNECEDOR
            FROM TI_PESSOA P
           WHERE P.NRREGISTRO = TFORNECEDOR.NRREGISTRO_FORNECEDOR;
        EXCEPTION
          WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20100,
                                    'Erro -> pessoa nao cadastrada para fornecedor na TI_PESSOA ' ||
                                    TFORNECEDOR.CDFORNECEDOR);
        END;
        BEGIN
          SELECT *
            INTO TGRUPO_DE_FORNECEDOR
            FROM GRUPO_DE_FORNECEDOR
           WHERE CDGRUPO_FORNECEDOR = TFORNECEDOR.CDGRUPO_FORNECEDOR;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20101,
                                    'Grupo do Forn. no unicoo nao encontrado: ' ||
                                    TFORNECEDOR.CDGRUPO_FORNECEDOR);
            NULL;
        END;
        BEGIN
          SELECT *
            INTO TPESSOA
            FROM PESSOA
           WHERE NRREGISTRO = TFORNECEDOR.NRREGISTRO_FORNECEDOR;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20102,
                                    'Cadastro de Pessoa do fornecor nao encontrado: ' ||
                                    L_INTEGRA_CLIFOR.CDIDENTIFICADOR);
            NULL;
        END;
        BEGIN
          SELECT *
            INTO TESTADO_CIVIL
            FROM ESTADO_CIVIL
           WHERE CDESTADOCIVIL = TPESSOA.CDESTADOCIVIL;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            NULL;
        END;
        BEGIN
          SELECT *
            INTO TENDERECO
            FROM ENDERECO
           WHERE NRREGISTRO = TPESSOA.NRREGISTRO
             AND TPENDERECO = F_TI_TIP_ENDERECO(TPESSOA.NRREGISTRO);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- josias 29-06-2014
            -- coloquei para pegar o endereço da unimed como default
            --SELECT *
            --  INTO TENDERECO
            --  FROM ENDERECO
            -- WHERE NRREGISTRO = 9999999999
            --      F_TI_PARAMETRO_INTEGRACAO('NRREGISTRO_ENDERECO_DEFAULT_INCLUSAO') VINICIUS NOVA IGUAÇU
            --  AND TPENDERECO = 'COBR';
            --     F_TI_TIP_ENDERECO(F_TI_PARAMETRO_INTEGRACAO('NRREGISTRO_ENDERECO_DEFAULT_INCLUSAO'));
            --          raise_application_error(-20103,'Fornecedor sem endereco: '||l_integra_clifor.cdidentificador);
            NULL;
        END;
        BEGIN
          SELECT *
            INTO TCIDADE
            FROM PRODUCAO.CIDADE@UNICOO_HOMOLOGA
           WHERE CDCIDADE = TENDERECO.CDCIDADE;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- Josias 01-07-2014 - retirado esse erro, pois foi criado parametro para
            -- preenher o nome da cidades.
            --raise_application_error(-20104,'Cidade do fornecedor invalido: '||l_integra_clifor.cdidentificador);
            NULL;
        END;
        BEGIN
          SELECT *
            INTO TTI_GRUPO_DE_FORNECEDOR
            FROM TI_GRUPO_DE_FORNECEDOR
           WHERE CDGRUPO_FORNECEDOR =
                 TGRUPO_DE_FORNECEDOR.CDGRUPO_FORNECEDOR;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20104,
                                    'Grupo de fornecedor invalido: ' ||
                                    TGRUPO_DE_FORNECEDOR.CDGRUPO_FORNECEDOR);
            NULL;
        END;
        BEGIN
          SELECT *
            INTO TTI_PESSOA
            FROM TI_PESSOA
           WHERE NRREGISTRO = TPESSOA.NRREGISTRO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20104,
                                    'Pessoa de integracao nao encontrado: ' ||
                                    TPESSOA.NRREGISTRO);
            NULL;
        END;
        begin
          select distinct 1
            into vlmatriz
            from ti_matriz_pagar v
           where v.nrregistro = tfornecedor.nrregistro_fornecedor;
        exception
          when no_data_found then
            vlmatriz := 0;
        end;

        --QTDE E CONTEUDOS DO ENDERECO
        VQTLOGRA             := LENGTH(TRIM(tendereco.nologradouro));
        VQTCOMPL             := LENGTH(TRIM(tendereco.txcomplemento));
        VQTLOGRA_REDUZ       := LENGTH(TRIM(F_REDUZ_END(tendereco.nologradouro,0)));
        VQTCOMPL_REDUZ       := LENGTH(TRIM(F_REDUZ_COMPL(tendereco.txcomplemento,0)));
        VQTLOGRA_REDUZ_ABREV := LENGTH(TRIM(F_REDUZ_END_ABREV(F_REDUZ_END(tendereco.nologradouro,0),0)));
        VQTNRIMOVEL          := LENGTH(tendereco.nrimovel) + length(nvl(pSEPARADOR_ENDERECO_NUMERO,', ')); /*tamanho do separador, que pode ser (,) (, ) etc*/
        VLOGRA               := TRIM(tendereco.nologradouro);
        VCOMPL               := NVL(TRIM(tendereco.txcomplemento), ' ');
        VLOGRA_REDUZ         := TRIM(F_REDUZ_END(tendereco.nologradouro, 0));
        VCOMPL_REDUZ         := TRIM(F_REDUZ_COMPL(tendereco.txcomplemento,
                                                   0));
        VLOGRA_REDUZ_ABREV   := TRIM(F_REDUZ_END_ABREV(F_REDUZ_END(tendereco.nologradouro,0),0));

        --TRATATIVA DOS ENDEÇOES E LOGRADOUROS (21/10/2016)
        --COMPLEMENTO NULO OU ATÉ 10 E O LOGRADOURO + NRIMOVEL ATÉ 40
        --LINHAS 1 E 2 DA PLANILHA
        IF ((VCOMPL IS NULL OR LENGTH(VCOMPL) <= VQTCOMPLEMENTO) AND
           VQTLOGRA + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA;
          ELSE
            VLOGRADOURO := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL;
          END IF;

          VCOMPLEMENTO := VCOMPL;

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '1', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DAS LINHAS 1 E 2
          --LOGRADOURO+NRIMOVEL ACIMA DE 40, PORÉM LOGRAD+IMOVEL REDUZ ATÉ 40 E O COMPLEMENTO ATÉ 10
          --LINHA 3 DA PLANILHA
        ELSIF (((VQTCOMPL <= VQTCOMPLEMENTO) OR (VQTCOMPL IS NULL)) AND
              VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA_REDUZ;
          ELSE
            VLOGRADOURO := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL;
          END IF;

          VCOMPLEMENTO := VCOMPL;

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '3', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 3
          --COMPLEMENTO ACIMA DE 10, PORÉM COMPL REDUZ ATÉ 10 E O LOGRADOURO + NRIMOVEL ATÉ 40
          --LINHA 4 DA PLANILHA
        ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
              VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
              VQTLOGRA + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA;
          ELSE
            VLOGRADOURO := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL;
          END IF;

          VCOMPLEMENTO := VCOMPL_REDUZ;

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '4', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 4
          --COMPLEMENTO ACIMA DE 10, PORÉM COMPL REDUZ ATÉ 10 E O LOGRADOURO + NRIMOVEL ACIMA DE 40, PORÉM LOGR+IMOVEL REDUZ ATÉ 40
          --LINHA 5 DA PLANILHA
        ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
              VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
              (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO)) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA_REDUZ;
          ELSE
            VLOGRADOURO := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL;
          END IF;

          VCOMPLEMENTO := VCOMPL_REDUZ;

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '5', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 5

          --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO + NRIMOVEL ATE 40
          --LINHA 6 DA PLANILHA
        ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
              VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
              (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ <=
              VQTLOGRADOURO)) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA || '-' || VCOMPL_REDUZ;
          ELSE
            VLOGRADOURO := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL || '-' ||
                           VCOMPL_REDUZ;
          END IF;

          VCOMPLEMENTO := ' ';

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '6', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 6
          --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO REDUZ + NRIMOVEL ATE 40
          --LINHA 7 DA PLANILHA
        ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
              VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
              (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ >
              VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) + 1 +
              VQTCOMPL_REDUZ <= VQTLOGRADOURO)) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA_REDUZ || '-' || VCOMPL_REDUZ;
          ELSE
            VLOGRADOURO := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL || '-' ||
                           VCOMPL_REDUZ;
          END IF;

          VCOMPLEMENTO := ' ';

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '7', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 7
          --COMPLEMENTO NULO OU ATÉ 10, LOGR REDUZ + NR ACIMA DE 40, PORÉM LOGRADOURO REDUZ E ABREV + NRIMOVEL ATE 40
          --LINHA 8 DA PLANILHA
        ELSIF ((VQTCOMPL <= VQTCOMPLEMENTO OR VCOMPL IS NULL) AND
              (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) <=
              VQTLOGRADOURO)) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA_REDUZ_ABREV;
          ELSE
            VLOGRADOURO := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL;
          END IF;

          VCOMPLEMENTO := VCOMPL;

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 8

          --COMPLEMENTO ACIMA DE 10, PORÉM REDUZ ATÉ 10 E LOGR REDUZ + NR ACIMA DE 40, PORÉM LOGRADOURO REDUZ E ABREV + NRIMOVEL ATE 40
          --LINHA 9 DA PLANILHA
        ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
              VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
              (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) <=
              VQTLOGRADOURO)) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA_REDUZ_ABREV;
          ELSE
            VLOGRADOURO := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL;
          END IF;

          VCOMPLEMENTO := VCOMPL_REDUZ;

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 9
          --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO REDUZ E ABREVIADO (ÚLTIMO RECURSO) + NRIMOVEL ATE 40
          --LINHA 10 DA PLANILHA
        ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
              VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
              (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ >
              VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) + 1 +
              VQTCOMPL_REDUZ > VQTLOGRADOURO) AND
              (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) + 1 +
              VQTCOMPL_REDUZ <= VQTLOGRADOURO)) THEN

          IF TENDERECO.NRIMOVEL IS NULL THEN
            VLOGRADOURO := VLOGRA_REDUZ_ABREV || '-' || VCOMPL_REDUZ;
          ELSE
            VLOGRADOURO := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TENDERECO.NRIMOVEL || '-' ||
                           VCOMPL_REDUZ;
          END IF;

          VCOMPLEMENTO := ' ';

          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

          --FIM DA TRATATIVA DA LINHA 10
        else
          --*****ver se ficará
          --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '0', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --SE NAO CONSEGUIU ABREVIAR, TRUNCA 1AS 40 POSICOES DO LOGRADOURO ABREVIADO E 1AS 10 DO COMPLEMENTO
            IF TENDERECO.NRIMOVEL IS NULL THEN
              VLOGRADOURO := SUBSTR(VLOGRA_REDUZ_ABREV,1,40);
            else
              --concatena numero no inicio pois a parte final do logradouro sera truncada
              VLOGRADOURO := substr(TENDERECO.nrimovel || ' ' || VLOGRA_REDUZ_ABREV,1,40);
            end if;
            
            VCOMPLEMENTO := substr(VCOMPL_REDUZ,1,10);

          /*   -- ERRO - NAO ENTROU EM NENHUM DOS IFS ACIMA
              ELSIF ((LENGTH(TENDERECO.TXCOMPLEMENTO) > VQTCOMPLEMENTO AND LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0))> VQTCOMPLEMENTO) AND
                   ((LENGTH(TRIM(TENDERECO.NOLOGRADOURO)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO) AND
                   ((LENGTH(F_REDUZ_END(TRIM(TENDERECO.NOLOGRADOURO),0)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO) AND
                   ((LENGTH(F_REDUZ_END_ABREV(F_REDUZ_END(TRIM(TENDERECO.NOLOGRADOURO),0),0)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO)
                   ) THEN

                -- VER COM O VINI PARA GRAVAR FALHA NO PROCESSO
                VLOGRADOURO  := NULL;
                VCOMPLEMENTO := NULL;

                INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '9', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);
          */
        END IF;

        --VALIDACAO DO TAMANHO DO BAIRRO
        --SE NAO ENVIAR O BAIRRO COMPLETO, TENTA O REDUZIDO E POR ÚLTIMO TRUNCA
        VBAIRRO := '';

        IF LENGTH(TENDERECO.NOBAIRRO) > 20 THEN
          IF LENGTH(f_reduz_bairro(TENDERECO.NOBAIRRO, 0)) > 20 THEN
            VBAIRRO := SUBSTR(F_REDUZ_BAIRRO(TENDERECO.NOBAIRRO, 0), 1, 20); --20 POSICOES DO REDUZIDO
          ELSE
            VBAIRRO := f_reduz_bairro(TENDERECO.NOBAIRRO, 0); -- BAIRRO REDUZIDO
          END IF;
        ELSE
          VBAIRRO := TENDERECO.NOBAIRRO; -- BAIRRO INTEIRO
        END IF;

        --INSERT INTO END_MIGRA VALUES (VBAIRRO,NULL,TENDERECO.NOBAIRRO,NULL,NULL,NULL,TENDERECO.NRREGISTRO);

        --FINAL DA VERIFICACAO E TRATAMENTO DO ENDERECO

        if ((tti_grupo_de_fornecedor.cod_grp_fornecedor = 'NAOM') and
           (vlmatriz = 0)) then

          null;

        else

          INSERT INTO TI_FORNECEDOR
            (NRSEQ_CONTROLE_INTEGRACAO,
             NRSEQ_FAVORECIDO,
             CDSITUACAO,
             COD_ACAO,
             COD_AGENC_BCIA,
             COD_BANCO,
             COD_CEP,
             COD_CEP_PAGTO,
             COD_CTA_CORREN_BCO,
             COD_CX_POST,
             COD_CX_POST_PAGTO,
             COD_DIGITO_AGENC_BCIA,
             COD_DIGITO_CTA_CORREN,
             COD_E_MAIL,
             COD_EMPRESA,
             COD_FAX,
             COD_FORMA_PAGTO,
             COD_FORNECEDOR,
             COD_GRP_FORNECEDOR,
             COD_ID_ESTAD_FISIC,
             COD_ID_FEDER,
             COD_ID_FEDER_ESTAD_JURID,
             COD_ID_FEDER_JURID,
             COD_ID_FEDER_MATRIZ,
             COD_ID_FEDER_NASC,
             COD_ID_MUNIC_JURID,
             COD_ID_PREVID_SOCIAL,
             COD_ORG_EMIS_ID_ESTAD,
             COD_PAIS_NASC,
             COD_PORTAD_PREFER,
             COD_RAMAL_FAX,
             COD_TELEFONE_1,
             COD_TELEFONE_2,
             COD_TELEFONE_3,
             COD_TIP_FLUXO_FINANC,
             COD_TIP_FORNECEDOR,
             COD_UNID_FEDER,
             COD_UNID_FEDER_EMIS_ESTAD,
             COD_UNID_FEDER_PAGTO,
             DAT_ENVIO,
             DAT_IMPL_FORNECEDOR,
             DAT_NASCIMENTO,
             DAT_PROCESSAMENTO,
             DEST_ANOT_TABELA,
             IND_ESTADO_CIVIL,
             IND_OCORRENCIA,
             IND_TIPO_PESSOA,
             LOG_FINS_LUCRAT,
             NOM_ABREV,
             NOM_BAIRRO,
             NOM_BAIRRO_PAGTO,
             NOM_CIDADE,
             NOM_CIDADE_PAGTO,
             NOM_ENDER_COMPL,
             NOM_ENDER_COMPL_PAGTO,
             NOM_ENDERECO,
             NOM_ENDERECO_PAGTO,
             NOM_FORNECEDOR,
             NOM_HOME_PAGE,
             NOM_MAE,
             NOM_NACIONALIDADE,
             NOM_PROFISSAO,
             NRPESSOA)

          VALUES

            (L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO, -- nrseq_controle_integracao,
             0, --nrseq_favorecido,
             'RC', --cdsituacao,
             L_INTEGRA_CLIFOR.CDACAO, --cd cod_acao,
             ' ', --cod_agenc_bcia,
             ' ', --cod_banco,
             -- josias 29-06-2014
             -- coloquei o cep padrão de americana para evitar os erros.
             NVL(TENDERECO.NRCEP,
                 F_TI_PARAMETRO_INTEGRACAO('NRCEP_DEFAULT_INCLUSAO')), --cod_cep,
             NVL(TENDERECO.NRCEP,
                 F_TI_PARAMETRO_INTEGRACAO('NRCEP_DEFAULT_INCLUSAO')), --cod_cep_pagto,
             ' ', --cod_cta_corren_bco,
             ' ', --cod_cx_post,
             ' ', --cod_cx_post_pagto,
             ' ', --cod_digito_agenc_bcia,
             ' ', --cod_digito_cta_corren,
             nvl(substr(tendereco.cdemail, 1, 40), ' '), --cod_e_mail,
             F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA'), --cod_empresa,
             ' ', --cod_fax,
             F_TI_PARAMETRO_INTEGRACAO('COD_FORMA_PAGTO'), --cod_forma_pagto,
             TCDN_FORNECEDOR, --cod_fornecedor,
             TTI_GRUPO_DE_FORNECEDOR.COD_GRP_FORNECEDOR, -- cod_grp_fornecedor,

             --F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER'), --cod_id_estad_fisic,
             NVL(TENDERECO.CDESTADO,
                 F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER')), --cod_id_estad_fisic,

             CASE WHEN TPESSOA.NRCGC_CPF IS NOT NULL THEN TPESSOA.NRCGC_CPF WHEN
             TPESSOA.TPPESSOA = 'F' THEN
             F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER_PESSOA_FISICA') ELSE
             F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER_PESSOA_JURIDICA') END, --cod_id_feder,
             --F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER'), --cod_id_feder_estad_jurid,
             CASE WHEN TPESSOA.TPPESSOA = 'J' THEN
             NVL(TPESSOA.NRINSCEST_RG, 'ISENTO') ELSE ' ' END, --cod_id_feder_estad_jurid
             NVL(TPESSOA.NRCGC_CPF, ' '), --cod_id_feder_jurid,
             ' ', --F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER'), --cod_id_feder_matriz,
             ' ', --F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER'), --cod_id_feder_nasc,
             ' ', --cod_id_munic_jurid,
             ' ', --cod_id_previd_social,
             NVL(TPESSOA.NOORGAO_EMISSOR_RG, ' '), --cod_org_emis_id_estad,
             F_TI_PARAMETRO_INTEGRACAO('COD_PAIS'), --cod_pais_nasc,
             DECODE(TPESSOA.TPPESSOA,
                    'F',
                    F_TI_PARAMETRO_INTEGRACAO('COD_PORTAD_PREFER_PESSOA_FISICA'),
                    F_TI_PARAMETRO_INTEGRACAO('COD_PORTAD_PREFER_PESSOA_JURIDICA')), --cod_portad_prefer,
             ' ', --cod_ramal_fax,
             ' ', --cod_telefone_1,
             ' ', --cod_telefone_2,
             ' ', --cod_telefone_3,

             --           F_TI_PARAMETRO_INTEGRACAO('COD_TIP_FLUXO_FINANC_PREFER_FOR'), --cod_tip_fluxo_financ,
             DECODE(TPESSOA.TPPESSOA,
                    'F',
                    F_TI_PARAMETRO_INTEGRACAO('COD_TIP_FLUXO_FINANC_PREFER_FOR_F'),
                    F_TI_PARAMETRO_INTEGRACAO('COD_TIP_FLUXO_FINANC_PREFER_FOR_J')), --cod_tip_fluxo_financ,

             999, --cod_tip_fornecedor,
             --F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER'), --cod_unid_feder,
             --F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER'), --cod_unid_feder_emis_estad,
             NVL(TENDERECO.CDESTADO,
                 F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER')), --COD_UNID_FEDER
             NVL(TENDERECO.CDESTADO,
                 F_TI_PARAMETRO_INTEGRACAO('COD_ID_FEDER')), --COD_UNID_FEDER_EMIS_ESTAD

             ' ', --cod_unid_feder_pagto,
             SYSDATE, --dat_envio,
             F_TI_PARAMETRO_INTEGRACAO('DAT_IMPL_FORNECEDOR'), --dat_impl_fornecedor,
             TPESSOA.DTNASCIMENTO, --dat_nascimento,
             SYSDATE, --dat_processamento,

             -- O CAMPO DEST_ANOT_TABELA RECEBERÁ O ENDEREÇO COMPLETO (LOGRAD + NR + COMPL + BAIRRO
             -- PARA DEPOIS ENVIÁ-LO PARA O CAMPO NOM_ENDER_TEXT QUE NÃO EXISTE NA TI_FORNECEDOR
             -- O TI_FORNECEDOR.P (PROGRESS) FARÁ ESTA TRANSFERÊNCIA DE CONTEÚDO ENTRE ESTES CAMPOS
             -- NA A CHAMADA DA API
             'ENDERECO ORIGINAL: ' || CHR(13) ||
             TRIM(TENDERECO.NOLOGRADOURO) ||
             DECODE(TENDERECO.NRIMOVEL, NULL, '', ', ') ||
             DECODE(TENDERECO.NRIMOVEL, NULL, '', TENDERECO.NRIMOVEL) ||
             DECODE(TENDERECO.TXCOMPLEMENTO, NULL, '', ' - ') ||
             DECODE(TENDERECO.TXCOMPLEMENTO,
                    NULL,
                    '',
                    TRIM(TENDERECO.TXCOMPLEMENTO)) ||
             DECODE(TENDERECO.NOBAIRRO, NULL, '', ' - ') ||
             TENDERECO.NOBAIRRO ||
             DECODE(TENDERECO.CDEMAIL_ADICIONAL,
                    NULL,
                    '',
                    CHR(10) || CHR(13) || 'E-MAIL ADICIONAL:' || CHR(13) ||
                    TENDERECO.CDEMAIL_ADICIONAL), --dest_anot_tabela,

             ' ', --ind_estado_civil,
             0, --ind_ocorrencia,
             TPESSOA.TPPESSOA, --ind_tipo_pessoa,
             'S', --log_fins_lucrat,
             TTI_PESSOA.NOABREVIADO_FORNECEDOR, --nom_abrev,
             -- josias 29-06-2014

             /*
             SUBSTR(NVL(TENDERECO.NOBAIRRO,
                        ' '),--F_TI_PARAMETRO_INTEGRACAO('NOBAIRRO_DEFAULT_INCLUSAO')),
                    1,
                    20), --nom_bairro,
             SUBSTR(NVL(TENDERECO.NOBAIRRO,
                        ' '),--F_TI_PARAMETRO_INTEGRACAO('NOBAIRRO_DEFAULT_INCLUSAO')),
                    1,
                    20), --nom_bairro_pagto,
             */
             NVL(VBAIRRO,
                 F_TI_PARAMETRO_INTEGRACAO('NOBAIRRO_DEFAULT_INCLUSAO')), --NOM_BAIRRO
             NVL(VBAIRRO,
                 F_TI_PARAMETRO_INTEGRACAO('NOBAIRRO_DEFAULT_INCLUSAO')), --NOM_BAIRRO_PAGTO

             NVL(TRIM(TCIDADE.NOCIDADE),
                 F_TI_PARAMETRO_INTEGRACAO('NOCIDADE_DEFAULT_INCLUSAO')), --nom_cidade,
             NVL(TRIM(TCIDADE.NOCIDADE),
                 F_TI_PARAMETRO_INTEGRACAO('NOCIDADE_DEFAULT_INCLUSAO')), --nom_cidade_pagto,
             --NVL(SUBSTR(TENDERECO.TXCOMPLEMENTO, 1,10), ' '), --nom_ender_compl,
             --NVL(SUBSTR(TENDERECO.TXCOMPLEMENTO, 1,10), ' '), --nom_ender_compl_pagto,
             NVL(VCOMPLEMENTO, ' '), --NOM_ENDER_COMPL
             NVL(VCOMPLEMENTO, ' '), --NOM_ENDER_COMPL_PAGTO
             /*
             nvl2(replace(replace(replace(tendereco.nologradouro, ' ',''),',',''),'.',''),
             f_abrevia_nome(trim(tendereco.nologradouro)||decode(tendereco.nrimovel,null,null,','||
                            tendereco.nrimovel),40,'PEA')
                   ,'Sem Endereco'),                         --nom_endereco,
             NVL(TRIM(F_ABREVIA_NOME(TRANSLATE(TENDERECO.NOLOGRADOURO,
                                               '0123456789,.;:]',
                                               '              ') ||
                                     DECODE(TENDERECO.NRIMOVEL,
                                            NULL,
                                            NULL,
                                            ',' || TENDERECO.NRIMOVEL),
                                     40,
                                     'PEA')),
                 'Sem Endereco'), --nom_endereco,
             */

             /*
             decode(TRIM(TENDERECO.NOLOGRADOURO),NULL,NULL,
                                                 decode(TENDERECO.NRIMOVEL,NULL,TENDERECO.NOLOGRADOURO,
                                                                           TENDERECO.NOLOGRADOURO || ', ' || TENDERECO.NRIMOVEL)), --NOM_ENDERECO


             decode(TRIM(TENDERECO.NOLOGRADOURO),NULL,NULL,
                                                 decode(TENDERECO.NRIMOVEL,NULL,TENDERECO.NOLOGRADOURO,
                                                                           TENDERECO.NOLOGRADOURO || ', ' || TENDERECO.NRIMOVEL)), --NOM_ENDERECO_PAGTO

             */
             NVL(VLOGRADOURO,
                 F_TI_PARAMETRO_INTEGRACAO('NOLOGRADOURO_DEFAULT_INCLUSAO')), --NOM_ENDERECO
             NVL(VLOGRADOURO,
                 F_TI_PARAMETRO_INTEGRACAO('NOLOGRADOURO_DEFAULT_INCLUSAO')), --NOM_ENDERECO_PAGTO

             --             NVL(TRIM(TENDERECO.NOLOGRADOURO), 'Sem endereço'), --nom_endereco_pagto,

             TPESSOA.NOPESSOA, --nom_fornecedor,
             ' ', --nom_home_page,
             -- Josias - 29-06-2014
             -- coloquei o truncamento pois estava estourando mais de 40 posições.
             F_ABREVIA_NOME(TPESSOA.NOMAE, 40, ''), --nom_mae,
             ' ', --F_TI_PARAMETRO_INTEGRACAO('NOM_NACIONALIDADE'), --nom_nacionalidade,
             NULL, --nom_profissao,
             TFORNECEDOR.NRREGISTRO_FORNECEDOR --nrpessoa
             );

          insere_hash('FN',
                      L_INTEGRA_CLIFOR.NRSEQUENCIAL_ORIGEM,
                      L_INTEGRA_CLIFOR.CDIDENTIFICADOR);

          IF SQL%ROWCOUNT = 0 THEN
            P_TI_VALIDA_ENDERECO(L_INTEGRA_CLIFOR.NRSEQUENCIAL_ORIGEM,
                                 L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                                 'TI_FORNECEDOR',
                                 PCDSITUACAO);
            IF PCDSITUACAO = 'RC' THEN
              P_GRAVA_FALHA(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                            'TI_FORNECEDOR',
                            'A VIEW V_TI_FORNECEDOR NO ENCONTROU FORNECEDOR PARA O PROCESSO ==>' ||
                            L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO ||
                            'Pessoa ==>' ||
                            L_INTEGRA_CLIFOR.NRSEQUENCIAL_ORIGEM ||
                            'Fornecedor ==> ' ||
                            L_INTEGRA_CLIFOR.CDIDENTIFICADOR,
                            NULL,
                            PCDSITUACAO,
                            NULL);
            END IF;
          END IF;
        END IF;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          P_GRAVA_FALHA(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                        'TI_FORNECEDOR',
                        'O Fornecedor j foi enviado para a TI_FORNECEDOR',
                        NULL,
                        PCDSITUACAO,
                        -1);
        WHEN OTHERS THEN
          P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                        'TI_FORNECEDOR',
                        'Falha:  ' || SQLERRM,
                        ' Processo ==> ' ||
                        L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO ||
                        '  Pessoa ==> ' ||
                        L_INTEGRA_CLIFOR.NRSEQUENCIAL_ORIGEM ||
                        '  Fornecedor ==> ' ||
                        L_INTEGRA_CLIFOR.CDIDENTIFICADOR,
                        PCDSITUACAO,
                        NULL);

      END;

      --====================================--
      -- Atualizar o situao da integrao --
      ----------------------------------------
      P_UPDATE_CONTROLE_INTEGRACAO(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                                   PCDSITUACAO,
                                   NULL);
    END LOOP;
  END;

  --===============================--
  -- Grava Titulo - TI_TIT_ACR --
  -----------------------------------
  PROCEDURE P_TI_TIT_ACR_ESTORNO(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                 PNRDOCUMENTO               VARCHAR2,
                                 PCDSITUACAO                IN OUT VARCHAR2,
                                 PNRSESSAO                  NUMBER) IS
    CURSOR C_FATURA IS
      SELECT CI.*, FT.DTCANCELAMENTO
        FROM TI_CONTROLE_INTEGRACAO CI, FATURAMENTO FT
       WHERE CI.TPINTEGRACAO = 'FT'
         AND FT.NRFATURA = CI.CDIDENTIFICADOR
         AND (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0)
         AND CDSITUACAO = 'VD'
         AND CI.NRSESSAO = PNRSESSAO;
    CURSOR C_EMS(PNRDOCUMENTO VARCHAR2) IS
      SELECT EMS.NUM_ID_TIT_ACR, EMS.NRDOCUMENTO
        FROM EMS_MOVIMENTO_TITULO_ACR EMS, TITULO_A_RECEBER TR, TIT_ACR TA
       WHERE TA.U##COD_ESTAB = EMS.COD_ESTAB
         AND TA.NUM_ID_TIT_ACR = EMS.NUM_ID_TIT_ACR
         AND TR.NRDOCUMENTO = PNRDOCUMENTO
         AND TR.NRDOCUMENTO = EMS.NRDOCUMENTO
         AND EMS.NRREGISTRO_TITULO = TR.NRREGISTRO_TITULO
         AND EMS.IND_TRANS_ACR_ABREV = 'IMPL'
         AND TA.LOG_TIT_ACR_ESTORDO = 0;
    VCDINTEGRACAO    VARCHAR2(100);
    VCOD_ESPEC_DOCTO TI_TIPO_MOVIMENTO_TIT_ACR.COD_ESPEC_DOCTO%TYPE;
    VAOACHOU         BOOLEAN;
  BEGIN
    VCDINTEGRACAO := 'TI_TIT_ACR_ESTORNO';
    PCDSITUACAO   := 'ER';
    FOR L_FATURA IN C_FATURA LOOP
      VAOACHOU := FALSE;
      FOR L_EMS IN C_EMS(L_FATURA.CDIDENTIFICADOR) LOOP
        PCDSITUACAO := 'RC';
        VAOACHOU    := TRUE;
        BEGIN
          INSERT INTO TI_TIT_ACR_ESTORNO
            (NRSEQ_CONTROLE_INTEGRACAO,
             CDSITUACAO,
             NRDOCUMENTO,
             COD_ESTAB,
             COD_ESPEC_DOCTO,
             COD_SER_DOCTO,
             COD_TIT_ACR,
             COD_PARCELA,
             COD_TIT_ACR_BCO,
             COD_REFER,
             NUM_ID_MOVTO_TIT_ACR,
             NUM_ID_TIT_ACR,
             COD_PORTADOR,
             DAT_TRANSACAO,
             DAT_ENVIO,
             CDN_CLIENTE,
             DAT_PROCESSAMENTO,
             IND_NIV_OPERAC_ACR,
             IND_TIP_OPERAC_ACR)
            SELECT L_FATURA.NRSEQUENCIAL NRSEQ_CONTROLE_INTEGRACAO,
                   CDSITUACAO,
                   L_FATURA.CDIDENTIFICADOR NRDOCUMENTO,
                   COD_ESTAB,
                   COD_ESPEC_DOCTO,
                   COD_SER_DOCTO,
                   COD_TIT_ACR,
                   COD_PARCELA,
                   COD_TIT_ACR_BCO,
                   'E' || LPAD(L_FATURA.NRSEQUENCIAL, 9, '0'),
                   NUM_ID_MOVTO_TIT_ACR,
                   NUM_ID_TIT_ACR,
                   COD_PORTADOR,
                   L_FATURA.DTCANCELAMENTO DAT_TRANSACAO,
                   DAT_ENVIO,
                   CDN_CLIENTE,
                   DAT_PROCESSAMENTO,
                   IND_NIV_OPERAC_ACR,
                   IND_TIP_OPERAC_ACR
              FROM V_TI_TIT_ACR_ESTORNO TA
             WHERE TA.NUM_ID_TIT_ACR = L_EMS.NUM_ID_TIT_ACR;
          IF SQL%ROWCOUNT = 0 THEN
            P_GRAVA_FALHA(L_FATURA.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          'Dados no encontrados na V_ti_tit_acr_estorno PARA O PROCESSO ' ||
                          L_FATURA.NRSEQUENCIAL || ' Especie: ' ||
                          VCOD_ESPEC_DOCTO || ' Srie: ' ||
                          SUBSTR(L_FATURA.CDIDENTIFICADOR, 1, 2) ||
                          'Titulo :' ||
                          SUBSTR(L_FATURA.CDIDENTIFICADOR,
                                 INSTR(L_FATURA.CDIDENTIFICADOR, '-') + 1,
                                 12),
                          NULL,
                          PCDSITUACAO,
                          NULL);
          END IF;
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            P_GRAVA_FALHA(L_FATURA.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          'A fatura j foi enviada para estorno. Processo ==>' ||
                          L_FATURA.NRSEQUENCIAL,
                          NULL,
                          PCDSITUACAO,
                          -1);
          WHEN OTHERS THEN
            P_GRAVA_FALHA(L_FATURA.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          'Erro ao enviar fatura para cancelamento. Processo ==>' ||
                          L_FATURA.NRSEQUENCIAL || ' ' || SQLERRM,
                          NULL,
                          PCDSITUACAO,
                          NULL);
        END;
        --====================================--
        -- Atualizar o situao da integrao --
        ----------------------------------------
        P_UPDATE_CONTROLE_INTEGRACAO(L_FATURA.NRSEQUENCIAL,
                                     PCDSITUACAO,
                                     NULL);
      END LOOP;
      IF NOT VAOACHOU THEN
        P_GRAVA_FALHA(L_FATURA.NRSEQUENCIAL,
                      VCDINTEGRACAO,
                      'O titulo no EMS5==> ' || L_FATURA.CDIDENTIFICADOR || ' ' ||
                      L_FATURA.NRSEQUENCIAL || ' ' || SQLERRM,
                      NULL,
                      PCDSITUACAO,
                      NULL);
      END IF;
      --====================================--
      -- Atualizar o situao da integrao --
      ----------------------------------------
      P_UPDATE_CONTROLE_INTEGRACAO(L_FATURA.NRSEQUENCIAL,
                                   PCDSITUACAO,
                                   NULL);
    END LOOP;
    -- Alessandro 19/03/2012
    FOR XX IN (SELECT T.NRDOCUMENTO,
                      T.NUM_ID_TIT_ACR,
                      MT.LOG_APROP_CTBL_CTBZDA,
                      T.NRSEQ_CONTROLE_INTEGRACAO
                 FROM TI_TIT_ACR_ESTORNO T, TIT_ACR TA, MOVTO_TIT_ACR MT
                WHERE MT.U##COD_ESTAB = TA.U##COD_ESTAB
                  AND MT.NUM_ID_TIT_ACR = TA.NUM_ID_TIT_ACR
                  AND MT.IND_TRANS_ACR_ABREV = 'IMPL'
                  AND TA.NUM_ID_TIT_ACR = T.NUM_ID_TIT_ACR
                  AND T.CDSITUACAO IN ('ER', 'RC')
               --and mt.LOG_APROP_CTBL_CTBZDA = 1
               ) LOOP
      IF XX.LOG_APROP_CTBL_CTBZDA = 1 THEN
        UPDATE TI_TIT_ACR_ESTORNO Q
           SET Q.CDSITUACAO = 'RC'
         WHERE Q.NRSEQ_CONTROLE_INTEGRACAO = XX.NRSEQ_CONTROLE_INTEGRACAO;
        P_UPDATE_CONTROLE_INTEGRACAO(XX.NRSEQ_CONTROLE_INTEGRACAO,
                                     'RC',
                                     '');
      ELSE
        UPDATE TI_TIT_ACR_ESTORNO Q
           SET Q.CDSITUACAO = 'ER'
         WHERE Q.NRSEQ_CONTROLE_INTEGRACAO = XX.NRSEQ_CONTROLE_INTEGRACAO;
        P_UPDATE_CONTROLE_INTEGRACAO(XX.NRSEQ_CONTROLE_INTEGRACAO,
                                     'ER',
                                     'Titulo nao CTBL EMS5');
        P_GRAVA_FALHA(XX.NRSEQ_CONTROLE_INTEGRACAO,
                      'FAT_CANCEL',
                      'Fatura Cancelada no Unicoo, e n?o CTBLZ no EMS5',
                      'Contabilize o ACR no EMS5',
                      PCDSITUACAO,
                      NULL);
      END IF;
    END LOOP;
    -- Alessandro 19/03/2012
  END;

  --===============================--
  -- Grava Titulo - TI_TIT_ACR --
  -----------------------------------
  PROCEDURE P_TI_TIT_ACR(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                         PNRSESSAO                  NUMBER,
                         PCDSITUACAO                IN OUT VARCHAR2) IS
                         
  t1 NUMBER;
  t2 VARCHAR2(100);
  t3 VARCHAR2(100);
  t4 VARCHAR2(100);
  t5 VARCHAR2(100);
                         
                         

    CURSOR C_TRATA_FALHA IS
      SELECT DISTINCT UCL.CDCLIENTE,
                      nvl(ecl.cdn_cliente,0) cdn_cliente, --TIP.CDN_CLIENTE,
                      tip.cdn_cliente tipcdn_cliente,
                      UCL.NRREGISTRO_CLIENTE,
                      CI.CDEMPRESA,
                      CI.CDMODULO,
                      CI.CDMOVIMENTO,
                      ECL.COD_GRP_CLIEN,
                      TR.NRDOCUMENTO,
                      TR.NRREGISTRO_TITULO,
                      (SELECT COUNT(*)
                         FROM ENDERECO ED
                        WHERE ED.NRREGISTRO = UCL.NRREGISTRO_CLIENTE) QTENDERECO,
                      F_TI_TIP_MOVTO_TIT_ACR(CI.CDEMPRESA,
                                             CI.CDMODULO,
                                             CI.CDMOVIMENTO,
                                             ECL.COD_GRP_CLIEN) NUM_TIP_MOVTO_TIT_ACR
        FROM TITULO_A_RECEBER                 TR,
             TI_CONTROLE_INTEGRACAO           CI,
             PRODUCAO.CLIENTE@UNICOO_HOMOLOGA UCL,
             ems5.CLIENTE                     ECL,
             TI_PESSOA                        TIP,
             TI_EMPRESA                       EMP
       WHERE ECL.CDN_CLIENTE(+) = TIP.CDN_CLIENTE
         AND CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO
         AND TR.NRREGISTRO_TITULO = CI.NRSEQUENCIAL_ORIGEM
         AND TIP.NRREGISTRO(+) = UCL.NRREGISTRO_CLIENTE
         AND TR.CDCLIENTE = UCL.CDCLIENTE
         AND CI.CDEMPRESA = EMP.CDEMPRESA
         AND NVL(ECL.COD_EMPRESA, EMP.COD_EMPRESA) = EMP.COD_EMPRESA;
         
    CURSOR C_TITULOS IS
      SELECT *
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.TPINTEGRACAO = 'TR'
         AND (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0)
            --and cdsituacao = 'VD'
         AND CI.NRSESSAO = PNRSESSAO;
    VCDINTEGRACAO  VARCHAR2(100);
    VAO_ACHOU_ERRO BOOLEAN;
  BEGIN
  
    dbms_output.enable(null);
  
    FOR L_TITULOS IN C_TITULOS LOOP
        PCDSITUACAO   := 'RC';
        VCDINTEGRACAO := 'TI_TIT_ACR';
        
        dbms_output.put_line('P1. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
        begin  
          INSERT INTO TI_TIT_ACR
            (COD_ESTAB,
             COD_TITULO_ACR,
             VAL_IR,
             DAT_DESCONTO,
             VAL_LIQ_TITULO,
             DES_TEXT_HISTOR,
             IND_OCORRENCIA,
             NRSEQ_CONTROLE_INTEGRACAO,
             IND_TIPO_PESSOA,
             COD_ID_FEDER_JURID,
             COD_ID_FEDER,
             COD_ESPEC_DOCTO,
             COD_PARCELA,
             DAT_EMISSAO,
             DAT_VENCTO,
             DAT_PREVISAO_LIQUIDAC,
             VAL_TITULO,
             COD_CART_BCIA,
             DAT_PROCESSAMENTO,
             COD_EMPRESA,
             COD_TIP_FLUXO_FINANC,
             COD_PAIS,
             COD_CTA_CTBL,
             COD_CCUSTO,
             VAL_DESCONTO,
             COD_TIT_ACR_BCO,
             COD_PORTADOR,
             COD_SER_DOCTO,
             IND_TIP_ESPEC_DOCTO,
             CDSITUACAO,
             COD_CLIENTE,
             NRPESSOA,
             COD_PLANO_CCUSTO,
             COD_PLANO_CTA_CTBL,
             VAL_PERC_JUROS_DIA_ATRASO,
             VAL_PERC_MULTA_ATRASO)
            SELECT COD_ESTAB,
                   COD_TITULO_ACR,
                   VAL_IR,
                   DAT_DESCONTO,
                   VAL_LIQ_TITULO,
                   DES_TEXT_HISTOR,
                   IND_OCORRENCIA,
                   NRSEQ_CONTROLE_INTEGRACAO,
                   IND_TIPO_PESSOA,
                   COD_ID_FEDER_JURID,
                   COD_ID_FEDER,
                   COD_ESPEC_DOCTO,
                   COD_PARCELA,
                   DAT_EMISSAO,
                   DAT_VENCTO,
                   DAT_PREVISAO_LIQUIDAC,
                   VAL_TITULO,
                   COD_CART_BCIA,
                   DAT_PROCESSAMENTO,
                   COD_EMPRESA,
                   COD_TIP_FLUXO_FINANC,
                   COD_PAIS,
                   COD_CTA_CTBL,
                   COD_CCUSTO,
                   VAL_DESCONTO,
                   COD_TIT_ACR_BCO,
                   COD_PORTADOR,
                   COD_SER_DOCTO,
                   IND_TIP_ESPEC_DOCTO,
                   CDSITUACAO,
                   COD_CLIENTE,
                   NRPESSOA,
                   COD_PLANO_CCUSTO,
                   COD_PLANO_CTA_CTBL,
                   0                         VAL_PERC_JUROS_DIA_ATRASO,
                   0                         VAL_PERC_MULTA_ATRASO
              FROM V_TI_TIT_ACR TIT
             WHERE TIT.NRSEQ_CONTROLE_INTEGRACAO = L_TITULOS.NRSEQUENCIAL;
        EXCEPTION
          WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('P8. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
            P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          'Titulo ja enviado. Processo ==>' ||
                          L_TITULOS.NRSEQUENCIAL,
                          NULL,
                          PCDSITUACAO,
                          -1);
          when others then
            dbms_output.put_line('P9. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
            p_grava_falha(l_titulos.nrsequencial,
                            vCDIntegracao,
                            'Erro ao tentar criar TI_TIT_ACR. Verifique campos nulos(ex. NRDOCUMENTO). ' || sqlerrm,
                            null,
                            pcdsituacao,
                            null);
  
            P_COMMIT;
  
        END;
        IF SQL%ROWCOUNT = 0 THEN
          VAO_ACHOU_ERRO := FALSE;
          
--          dbms_output.put_line('L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
          
          /* p_grava_falha(l_titulos.nrsequencial,
          vCDIntegracao,
          'A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' ||
          l_titulos.nrsequencial,
          'A view V_TI_TIT_ACR nao encontrou registro',
          pCDSituacao,
          null);*/
          FOR L_TRATA_FALHA IN C_TRATA_FALHA LOOP

            dbms_output.put_line('P2. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
          
            dbms_output.put_line('L_TRATA_FALHA.NUM_TIP_MOVTO_TIT_ACR: ' || L_TRATA_FALHA.NUM_TIP_MOVTO_TIT_ACR || 
                                 ' NRDOCUMENTO: ' || L_TRATA_FALHA.NRDOCUMENTO || 
                                 ' NRREGISTRO_TITULO: ' || L_TRATA_FALHA.NRREGISTRO_TITULO ||
                                 ' CDN_CLIENTE: ' || L_TRATA_FALHA.CDN_CLIENTE ||
                                 ' QTENDERECO: ' || L_TRATA_FALHA.QTENDERECO ||
                                 ' NUM_TIP_MOVTO_TIT_ACR: ' || L_TRATA_FALHA.NUM_TIP_MOVTO_TIT_ACR 
                                 
                                 
                                 );
          
            VAO_ACHOU_ERRO := TRUE;
            IF L_TRATA_FALHA.CDN_CLIENTE IS NULL or L_TRATA_FALHA.CDN_CLIENTE = 0 THEN
              -- Fazer a geração do Cliente para poder reprocessar o titulo depois
              ------------------------------------------------------------------------
              --P_INSERE_CLIENTE(L_TITULOS.NRSEQUENCIAL_ORIGEM);
              ------------------------------------------------------------------------
              dbms_output.put_line('P3. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL ||
                                   ' L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL ||
                                   ' VCDINTEGRACAO: ' || VCDINTEGRACAO ||
                                   ' L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL ||
                                   ' L_TRATA_FALHA.CDCLIENTE: ' || L_TRATA_FALHA.CDCLIENTE ||
                                   ' l_trata_falha.tipcdn_cliente: ' || l_trata_falha.tipcdn_cliente ||
                                   ' PCDSITUACAO: ' || PCDSITUACAO
              );
              t1 := L_TITULOS.NRSEQUENCIAL;
              t2 := VCDINTEGRACAO;
              t3 := '(1)A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' || L_TITULOS.NRSEQUENCIAL;
              t4 := 'Falta integrar o cliente ' || nvl(to_char(L_TRATA_FALHA.CDCLIENTE),'nulo') || ' do UNICOO no EMS5(' || 
                            nvl(to_char(l_trata_falha.tipcdn_cliente),'nulo') || ')';
              t5 := PCDSITUACAO;
              
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            '(1)A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' ||
                            L_TITULOS.NRSEQUENCIAL,
                            'Falta integrar o cliente ' ||
                            nvl(to_char(L_TRATA_FALHA.CDCLIENTE),'nulo') || ' do UNICOO no EMS5(' || 
                            nvl(to_char(l_trata_falha.tipcdn_cliente),'nulo') || ')',
                            PCDSITUACAO,
                            NULL);
            ELSIF L_TRATA_FALHA.QTENDERECO IS NULL THEN
              dbms_output.put_line('P4. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            '(2)A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' ||
                            L_TITULOS.NRSEQUENCIAL,
                            'O Cliente ' || L_TRATA_FALHA.CDCLIENTE ||
                            ' nao foi integrado para o EMS5, o cliente no possui endereco no Unicoo.',
                            PCDSITUACAO,
                            NULL);
            ELSIF L_TRATA_FALHA.NUM_TIP_MOVTO_TIT_ACR = '-1' THEN
              dbms_output.put_line('P5. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            '(3)A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' ||
                            L_TITULOS.NRSEQUENCIAL,
                            ' Tipo de movimento no cadastrado em TI_TIPO_MOVIMENTO_TIT_ACR, parametros informados: ' ||
                            ' Cdigo da Empresa: ' ||
                            L_TRATA_FALHA.CDEMPRESA || ' Cdigo do mdulo: ' ||
                            L_TRATA_FALHA.CDMODULO ||
                            ' Cdigo do movimento: ' ||
                            L_TRATA_FALHA.CDMOVIMENTO ||
                            ' Grupo de cliente no EMS5: ' ||
                            L_TRATA_FALHA.COD_GRP_CLIEN ||
                            ' Cdigo de cliente no EMS5: ' ||
                            L_TRATA_FALHA.CDN_CLIENTE,
                            PCDSITUACAO,
                            NULL);
            ELSE
              dbms_output.put_line('P6. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            '(4)A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' ||
                            L_TITULOS.NRSEQUENCIAL,
                            
                            --null,--'Codigo da falha: ' || nvl(L_TRATA_FALHA.NUM_TIP_MOVTO_TIT_ACR,'NULO'),
                            
                            ' HISTORICO: ' || L_TRATA_FALHA.CDMOVIMENTO,
--                      F_TI_TIP_MOVTO_TIT_ACR(CI.CDEMPRESA,
--                                             CI.CDMODULO,
--                                             CI.CDMOVIMENTO,
--                                             ECL.COD_GRP_CLIEN) NUM_TIP_MOVTO_TIT_ACR
                            
                            
                            PCDSITUACAO,
                            NULL);
            END IF;
          END LOOP;
          IF VAO_ACHOU_ERRO = FALSE THEN
            dbms_output.put_line('P7. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
            P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          '(5)A view V_TI_TIT_ACR nao encontrou registro para o processo ==>' ||
                          L_TITULOS.NRSEQUENCIAL ||
                          '. Titulo ou cliente no existe no Unicoo',
                          NULL,
                          PCDSITUACAO,
                          NULL);
          END IF;
        ELSE
          begin
            VCDINTEGRACAO := 'TI_TIT_ACR_CTBL';
            INSERT INTO TI_TIT_ACR_CTBL CTB
              (VAL_APROP_CTBL,
               COD_ESTAB,
               COD_CTA_CTBL,
               COD_UNID_FEDERAC,
               COD_TIP_FLUXO_FINANC,
               NRSEQ_CONTROLE_INTEGRACAO,
               CDSITUACAO,
               COD_CCUSTO,
               DAT_PROCESSAMENTO)
              (SELECT VAL_APROP_CTBL,
                      COD_ESTAB,
                      COD_CTA_CTBL,
                      COD_UNID_FEDERAC,
                      COD_TIP_FLUXO_FINANC,
                      NRSEQ_CONTROLE_INTEGRACAO,
                      CDSITUACAO,
                      COD_CCUSTO,
                      DAT_PROCESSAMENTO
                 FROM V_TI_TIT_ACR_CTBL CTB
                WHERE CTB.NRSEQ_CONTROLE_INTEGRACAO = L_TITULOS.NRSEQUENCIAL);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
              dbms_output.put_line('P18. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            'TI_TIT_ACR_CTBL ja enviado. Processo ==>' ||
                            L_TITULOS.NRSEQUENCIAL,
                            NULL,
                            PCDSITUACAO,
                            -1);
            when others then
              dbms_output.put_line('P19. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
              p_grava_falha(l_titulos.nrsequencial,
                              vCDIntegracao,
                              'Erro ao tentar criar TI_TIT_ACR_CTBL. Verifique campos nulos(ex. NRDOCUMENTO). ' || sqlerrm,
                              null,
                              pcdsituacao,
                              null);
    
              P_COMMIT;
          END;
              
          IF SQL%ROWCOUNT = 0 THEN
            P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          '(6)A view V_ti_TIT_ACR_ctbl no encontrou registro para o processo ==>' ||
                          L_TITULOS.NRSEQUENCIAL,
                          NULL,
                          PCDSITUACAO,
                          NULL);
          ELSE
            BEGIN
              VCDINTEGRACAO := 'TI_TIT_ACR_CTBL_IMPOSTO';
              INSERT INTO TI_TIT_ACR_IMPOSTO
                (COD_SER_DOCTO,
                 IND_CLAS_IMPTO,
                 VAL_RENDTO_TRIBUT,
                 VAL_ALIQ_IMPTO,
                 COD_ESTAB,
                 COD_ESPEC_DOCTO,
                 COD_PARCELA,
                 COD_UNID_FEDERAC,
                 COD_IMPOSTO,
                 COD_CLASSIF_IMPTO,
                 VAL_IMPOSTO,
                 DAT_PROCESSAMENTO,
                 CDSITUACAO,
                 NRSEQ_CONTROLE_INTEGRACAO,
                 IND_OCORRENCIA)
                (SELECT COD_SER_DOCTO,
                        IND_CLAS_IMPTO,
                        VAL_RENDTO_TRIBUT,
                        VAL_ALIQ_IMPTO,
                        COD_ESTAB,
                        COD_ESPEC_DOCTO,
                        COD_PARCELA,
                        COD_UNID_FEDERAC,
                        COD_IMPOSTO,
                        COD_CLASSIF_IMPTO,
                        VAL_IMPOSTO,
                        DAT_PROCESSAMENTO,
                        CDSITUACAO,
                        NRSEQ_CONTROLE_INTEGRACAO,
                        IND_OCORRENCIA
                   FROM V_TI_TIT_ACR_IMPOSTO IP
                  WHERE IP.NRSEQ_CONTROLE_INTEGRACAO =
                        PNRSEQ_CONTROLE_INTEGRACAO);
            EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
                dbms_output.put_line('P28. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
                P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                              VCDINTEGRACAO,
                              'TI_TIT_ACR_IMPOSTO ja enviado. Processo ==>' ||
                              L_TITULOS.NRSEQUENCIAL,
                              NULL,
                              PCDSITUACAO,
                              -1);
              when others then
                dbms_output.put_line('P29. L_TITULOS.NRSEQUENCIAL: ' || L_TITULOS.NRSEQUENCIAL);
                p_grava_falha(l_titulos.nrsequencial,
                                vCDIntegracao,
                                'Erro ao tentar criar TI_TIT_ACR_IMPOSTO. Verifique campos nulos(ex. NRDOCUMENTO). ' || sqlerrm,
                                null,
                                pcdsituacao,
                                null);
      
                P_COMMIT;
            END;
          END IF;
        END IF;
        
      P_COMMIT;

      --====================================--
      -- Atualizar o situao da integrao --
      ----------------------------------------
      P_UPDATE_CONTROLE_INTEGRACAO(L_TITULOS.NRSEQUENCIAL,
                                   PCDSITUACAO,
                                   NULL);
      --=====================================--
      -- Titulo de Cooperados n?o trata falha,
      -- apenas cancela...
      -----------------------------------------
      IF SUBSTR(L_TITULOS.CDIDENTIFICADOR, 1, 3) = '9956-' THEN
        --braz
        P_UPDATE_CONTROLE_INTEGRACAO(L_TITULOS.NRSEQUENCIAL, --comentado emmaio de 2013 para tratar via arquivo gerado para baixa em lote pelo ems5
                                     'CA',
                                     NULL);
      END IF;
    END LOOP;
  END;

  --============================================--
  -- Grava Titulo a pagar - TI_TIT_APB      --
  --                        TI_TIT_APB_CTBL --
  ------------------------------------------------
  PROCEDURE P_TI_TIT_APB(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                         PNRSESSAO                  NUMBER,
                         PCDSITUACAO                IN OUT VARCHAR2) IS
    CURSOR C_TRATA_FALHA IS
      SELECT DISTINCT EFN.CDN_FORNECEDOR CDFORNECEDOR,
                      TIP.CDN_FORNECEDOR CDFORNECEDOR_EMS5,
                      UFN.NRREGISTRO_FORNECEDOR,
                      CI.CDIDENTIFICADOR,
                      CI.CDEMPRESA,
                      CI.CDMODULO,
                      CI.CDMOVIMENTO,
                      EFN.CDN_FORNECEDOR,
                      EFN.COD_GRP_FORNEC,
                      CI.CDDIVISAO,
                      CI.CDCENTRO_CUSTO,
                      (SELECT COUNT(*)
                         FROM ENDERECO ED
                        WHERE ED.NRREGISTRO = UFN.NRREGISTRO_FORNECEDOR) QTENDERECO,
                      F_TI_TIP_MOVTO_TIT_APB(CI.CDEMPRESA,
                                             CI.CDMODULO,
                                             CI.CDMOVIMENTO,
                                             EFN.COD_GRP_FORNEC,
                                             CI.CDDIVISAO,
                                             CI.CDCENTRO_CUSTO) NUM_TIP_MOVTO_TIT_APB,
                      PE.NOPESSOA NOFORNECEDORUNICOO
        FROM TITULO_A_PAGAR                      TP,
             TI_CONTROLE_INTEGRACAO              CI,
             PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA UFN,
             PESSOA                              PE,
             FORNECEDOR                          EFN,
             TI_PESSOA                           TIP,
             TI_EMPRESA                          EMP
       WHERE CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO
         AND TP.NRREGISTRO_TITULO = CI.NRSEQUENCIAL_ORIGEM
         AND TP.CDFORNECEDOR = UFN.CDFORNECEDOR
         AND UFN.NRREGISTRO_FORNECEDOR = PE.NRREGISTRO
         AND TIP.NRREGISTRO = UFN.NRREGISTRO_FORNECEDOR
         AND EFN.CDN_FORNECEDOR = TIP.CDN_FORNECEDOR
         AND EFN.COD_EMPRESA = EMP.COD_EMPRESA
         AND EMP.CDEMPRESA =
             F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA_UNICOO');
             
    CURSOR C_TITULOS IS
      SELECT CI.*
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.TPINTEGRACAO = 'TP'
         AND (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0)
         AND CI.NRSESSAO = PNRSESSAO;
    VCDINTEGRACAO           VARCHAR2(100);
    VAO_ACHOU_ERRO          BOOLEAN;
    RTI_TIT_APB_CTBL        TI_TIT_APB_CTBL%ROWTYPE;
    RTI_CONTROLE_INTEGRACAO TI_CONTROLE_INTEGRACAO%ROWTYPE;
    RFORNECEDOR             EMS506UNICOO.TI_PESSOA%ROWTYPE;
    RFORNECEDOR_EMS         FORNECEDOR%ROWTYPE;
    VCOD_ESTAB              TI_TIPO_MOVIMENTO_TIT_APB.CDDIVISAO%TYPE;
    HAFALHA                 BOOLEAN;
    aonaom                  varchar2(1);
    cd_grupo_aux            number;
  BEGIN
  
    DBMS_OUTPUT.ENABLE(9999999999);
    DBMS_OUTPUT.PUT_LINE( 'P1. SITUACAO: ' || PCDSITUACAO);
  
    FOR L_TITULOS IN C_TITULOS LOOP
      BEGIN
        HAFALHA       := FALSE;
        VCDINTEGRACAO := 'TI_TIT_APB';
        -- tratativas de erro
        BEGIN
          SELECT *
            INTO RTI_CONTROLE_INTEGRACAO
            FROM TI_CONTROLE_INTEGRACAO
           WHERE NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            HAFALHA := TRUE;
            P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          'Controle integracão não encontrado',
                          NULL,
                          PCDSITUACAO,
                          NULL);
        END;
        BEGIN
          SELECT B.*
            INTO RFORNECEDOR
            FROM PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA A,
                 EMS506UNICOO.TI_PESSOA              B
           WHERE A.NRREGISTRO_FORNECEDOR = B.NRREGISTRO
             AND CDFORNECEDOR =
                 (SELECT FO.CDFORNECEDOR
                    FROM TITULO_A_PAGAR                      TP,
                         PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA FO
                   WHERE FO.CDFORNECEDOR = TP.CDFORNECEDOR
                     AND TP.NRREGISTRO_TITULO =
                         RTI_CONTROLE_INTEGRACAO.NRSEQUENCIAL_ORIGEM);
          IF RFORNECEDOR.CDN_FORNECEDOR IS NULL THEN
            -- Fazer a geração do fornecedor para poder reprocessar o titulo depois
            ------------------------------------------------------------------------
            P_INSERE_FORNECEDOR(RTI_CONTROLE_INTEGRACAO.NRSEQUENCIAL_ORIGEM);
            ------------------------------------------------------------------------
          END IF;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- Fazer a geração do fornecedor para poder reprocessar o titulo depois
            ------------------------------------------------------------------------
            P_INSERE_FORNECEDOR(RTI_CONTROLE_INTEGRACAO.NRSEQUENCIAL_ORIGEM);
            ------------------------------------------------------------------------
            HAFALHA := TRUE;
            P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                          VCDINTEGRACAO,
                          'Fornecedor não integrado com TOTVS11, aguardar a integração do fornecedor !! ',
                          NULL,
                          PCDSITUACAO,
                          NULL);
        END;
        IF L_TITULOS.CDDIVISAO IS NOT NULL THEN
          BEGIN
            SELECT ET.COD_ESTAB
              INTO VCOD_ESTAB
              FROM TI_ESTABELECIMENTO ET
             WHERE ET.CDDIVISAO = L_TITULOS.CDDIVISAO;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              HAFALHA := TRUE;
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            'Falta o De-Para do unicoo para a Divisão [' ||
                            L_TITULOS.CDDIVISAO ||
                            ' ] na tabela TI_ESTABELECIMENTO ',
                            'Empresa[' || L_TITULOS.CDEMPRESA || '] ' ||
                            'Modulo[' || L_TITULOS.CDMODULO || '] ' ||
                            'Movimento[' ||
                            RPAD(L_TITULOS.CDMOVIMENTO, 5, ' ') || '] ' ||
                            'Divisão [' || L_TITULOS.CDDIVISAO || '] ' ||
                            'Verifique na tabela de vinculo , qual é o estabelecimento para a divisão ' ||
                            L_TITULOS.CDDIVISAO,
                            PCDSITUACAO,
                            NULL);
          END;
        END IF;
        BEGIN
          SELECT EFN.*
            INTO RFORNECEDOR_EMS
            FROM FORNECEDOR EFN, TI_EMPRESA EMP
           WHERE CDN_FORNECEDOR = RFORNECEDOR.CDN_FORNECEDOR
             AND EFN.COD_EMPRESA = EMP.COD_EMPRESA
             AND EMP.CDEMPRESA =
                 F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA_UNICOO');
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            HAFALHA := TRUE;
            
            --CHECAR SE O MOTIVO DE NAO ENCONTRAR O FORNECEDOR DO EMS5 EH DEVIDO A DEPARA DE GRUPO DE FORNECEDOR NAOM
            aonaom := 'N';
            begin
            
              SELECT a.cdgrupo_fornecedor
                INTO cd_grupo_aux
                FROM PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA A
               WHERE CDFORNECEDOR =
                     (SELECT FO.CDFORNECEDOR
                        FROM TITULO_A_PAGAR                      TP,
                             PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA FO
                       WHERE FO.CDFORNECEDOR = TP.CDFORNECEDOR
                         AND TP.NRREGISTRO_TITULO =
                             RTI_CONTROLE_INTEGRACAO.NRSEQUENCIAL_ORIGEM);
            
              select 'S' into aonaom from ti_grupo_de_fornecedor tgf
                   where tgf.cdgrupo_fornecedor = cd_grupo_aux
                     and tgf.cod_grp_fornecedor = 'NAOM';
            exception
              when others then aonaom := 'N';
            end;
            
            if aonaom = 'S' then
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            'Grupo do Fornecedor parametrizado como NAOM. Verifique TI_GRUPO_FORNECEDOR',
                            'Registro do Fornecedor no unicoo: ' ||
                            RFORNECEDOR.NRREGISTRO,
                            PCDSITUACAO,
                            NULL);
            else            
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            'Fornecedor do EMS5 não encontrado.',
                            'Registro do Fornecedor no unicoo: ' ||
                            RFORNECEDOR.NRREGISTRO,
                            PCDSITUACAO,
                            NULL);
            end if;
        END;
        
        /* se titulo ja existir no EMS5, sair sem apresentar erro */
        /*
                 and not exists(SELECT 1
                                  FROM TIT_AP A, TI_EMPRESA EMP
                                 WHERE A.CDN_FORNECEDOR = RFORNECEDOR.CDN_FORNECEDOR
                                   AND A.COD_TIT_AP = tit.COD_TITULO_AP
                                   AND A.COD_ESPEC_DOCTO = tit.COD_ESPEC_DOCTO
                                   AND A.COD_SER_DOCTO = tit.COD_SER_DOCTO
                                   AND A.COD_EMPRESA = EMP.COD_EMPRESA
                                   AND A.COD_PARCELA = tit.COD_PARCELA
                                   AND EMP.CDEMPRESA =
                                       F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA_UNICOO'))
        */                               
                                               
    DBMS_OUTPUT.PUT_LINE( 'P2. SITUACAO: ' || PCDSITUACAO);
        
        IF NOT HAFALHA THEN
          PCDSITUACAO   := 'RC';
          
    DBMS_OUTPUT.PUT_LINE( 'P21. SITUACAO: ' || PCDSITUACAO);
          
          VCDINTEGRACAO := 'TI_TIT_APB';
          BEGIN
            INSERT INTO TI_TIT_APB
              (COD_TITULO_AP,
               VAL_PER_DESC,
               COD_CART_BCIA,
               DAT_PROCESSAMENTO,
               COD_TIP_FLUXO_FINANC,
               CDN_FORNECEDOR,
               QTD_PARCELA,
               IND_TIPO_PESSOA,
               COD_SER_DOCTO,
               COD_PARCELA,
               VAL_DESCONTO,
               DES_TEXT_HISTOR,
               CDSITUACAO,
               COD_CCUSTO,
               COD_ID_FEDER_JURID,
               COD_ESPEC_DOCTO,
               DAT_EMISSAO,
               DAT_VENCTO,
               DAT_PREVISAO_PAGTO,
               DAT_DESCONTO,
               VAL_TITULO,
               NUM_DIAS_ATRASO,
               VAL_JUROS,
               VAL_PERC_JUROS_DIA_ATRASO,
               VAL_PERC_MULTA_ATRASO,
               COD_PORTADOR,
               COD_FORMA_PAGTO,
               COD_EMPRESA,
               COD_ESTAB,
               NRSEQ_CONTROLE_INTEGRACAO,
               COD_ID_FEDER,
               IND_OCORRENCIA,
               NRREGISTRO_TITULO,
               NRPESSOA,
               COD_PLANO_CCUSTO,
               COD_PLANO_CTA_CTBL)
              SELECT COD_TITULO_AP,
                     VAL_PER_DESC,
                     COD_CART_BCIA,
                     DAT_PROCESSAMENTO,
                     COD_TIP_FLUXO_FINANC,
                     CDFORNECEDOR_EMS5,
                     QTD_PARCELA,
                     IND_TIPO_PESSOA,
                     COD_SER_DOCTO,
                     COD_PARCELA,
                     VAL_DESCONTO,
                     DES_TEXT_HISTOR,
                     CDSITUACAO,
                     COD_CCUSTO,
                     COD_ID_FEDER COD_ID_FEDER_JURID,
                     COD_ESPEC_DOCTO,
                     DAT_EMISSAO,
                     DAT_VENCTO,
                     DAT_PREVISAO_PAGTO,
                     DAT_DESCONTO,
                     VAL_BRUTO,
                     NUM_DIAS_ATRASO,
                     VAL_JUROS,
                     VAL_PERC_JUROS_DIA_ATRASO,
                     VAL_PERC_MULTA_ATRASO,
                     COD_PORTADOR,
                     COD_FORMA_PAGTO,
                     COD_EMPRESA,
                     COD_ESTAB,
                     NRSEQ_CONTROLE_INTEGRACAO,
                     COD_ID_FEDER,
                     IND_OCORRENCIA,
                     NRREGISTRO_TITULO,
                     NRPESSOA,
                     COD_PLANO_CCUSTO,
                     COD_PLANO_CTA_CTBL
                FROM V_TI_TIT_APB TIT
               WHERE TIT.NRSEQ_CONTROLE_INTEGRACAO =
                     PNRSEQ_CONTROLE_INTEGRACAO;
    DBMS_OUTPUT.PUT_LINE( 'P22. SITUACAO: ' || PCDSITUACAO);
          EXCEPTION
--            WHEN DUP_VAL_ON_INDEX THEN
--    DBMS_OUTPUT.PUT_LINE( 'P23. SITUACAO: ' || PCDSITUACAO);
--              null; -- título já tratado
            WHEN OTHERS THEN
              RAISE_APPLICATION_ERROR(-20199, 'Erro -> ' || SQLERRM);
          END;
    DBMS_OUTPUT.PUT_LINE( 'P24. SITUACAO: ' || PCDSITUACAO);
          
          IF SQL%ROWCOUNT = 0 THEN
          
    DBMS_OUTPUT.PUT_LINE( 'P25. SITUACAO: ' || PCDSITUACAO);
          
            VAO_ACHOU_ERRO := FALSE;
            FOR L_TRATA_FALHA IN C_TRATA_FALHA LOOP
              
    DBMS_OUTPUT.PUT_LINE( 'P26. SITUACAO: ' || PCDSITUACAO);
            
              VAO_ACHOU_ERRO := TRUE;
              IF L_TRATA_FALHA.CDFORNECEDOR_EMS5 IS NULL THEN
                P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                              VCDINTEGRACAO,
                              '(1) A view v_TI_TIT_APB no encontrou registro para o processo ==>' ||
                              L_TITULOS.NRSEQUENCIAL,
                              'O Fornecedor [' ||
                              L_TRATA_FALHA.CDFORNECEDOR || '] ' ||
                              L_TRATA_FALHA.NOFORNECEDORUNICOO ||
                              ' no foi integrado para o EMS5',
                              PCDSITUACAO,
                              NULL);
              ELSIF L_TRATA_FALHA.CDEMPRESA IS NULL THEN
                P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                              VCDINTEGRACAO,
                              '(2) A view v_TI_TIT_APB no encontrou registro para o processo ==>' ||
                              L_TITULOS.NRSEQUENCIAL,
                              'A empresa do unicoo no foi informada para o titulo: ' ||
                              L_TRATA_FALHA.CDIDENTIFICADOR,
                              PCDSITUACAO,
                              NULL);
              ELSIF L_TRATA_FALHA.QTENDERECO IS NULL THEN
                P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                              VCDINTEGRACAO,
                              '(3) A view v_TI_TIT_APB no encontrou registro para o processo ==>' ||
                              L_TITULOS.NRSEQUENCIAL,
                              'O Fornecedor [' ||
                              L_TRATA_FALHA.CDFORNECEDOR || '] ' ||
                              L_TRATA_FALHA.NOFORNECEDORUNICOO ||
                              ' no foi integrado para o EMS5, o Fornecedor no possui endereo no Unicoo.',
                              PCDSITUACAO,
                              NULL);
              ELSIF L_TRATA_FALHA.NUM_TIP_MOVTO_TIT_APB = -1 THEN
              
                P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                              VCDINTEGRACAO,
                              'Verifique o De-Para do unicoo para o ems5 para o processo [' ||
                              L_TITULOS.NRSEQUENCIAL || ']',
                              --' Tipo de movimento no cadastrado em TI_TIPO_MOVIMENTO_TIT_ACR, parametros informados: '||
                              'Empresa [' || L_TRATA_FALHA.CDEMPRESA || ']' ||
                              ' Modulo [' || L_TRATA_FALHA.CDMODULO || ']' ||
                              ' Movimento [' ||
                              --RPAD(L_TRATA_FALHA.CDMOVIMENTO, 5, ' ') || ']' ||
                              L_TRATA_FALHA.CDMOVIMENTO || ']' ||
                              ' Grupo de Fornecedor EMS [' ||
                              L_TRATA_FALHA.COD_GRP_FORNEC || ']' ||
                              ' Divisao [' || l_trata_falha.cddivisao || ']' ||
                              ' Centro Custo [' || l_trata_falha.cdcentro_custo || ']' ||
                              ' Codigo do Fornecedor EMS [' ||
                              L_TRATA_FALHA.CDN_FORNECEDOR || ']' ||
                              ' Documento Unicoo [' ||
                              L_TITULOS.CDIDENTIFICADOR || ']' ||
                              ' Fornecedor Unicoo [' ||
                              L_TRATA_FALHA.CDFORNECEDOR || '] ' ||
                              L_TRATA_FALHA.NOFORNECEDORUNICOO,
                              PCDSITUACAO,
                              NULL);
              ELSE
                P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                              VCDINTEGRACAO,
                              '(4) A view v_TI_TIT_APB no encontrou registro para o processo ==>' ||
                              L_TITULOS.NRSEQUENCIAL,
                              NULL,
                              PCDSITUACAO,
                              NULL);
              END IF;
            END LOOP;
            IF VAO_ACHOU_ERRO = FALSE THEN
              P_GRAVA_FALHA(L_TITULOS.NRSEQUENCIAL,
                            VCDINTEGRACAO,
                            '(5) A view v_TI_TIT_APB no encontrou registro para o processo ==>' ||
                            L_TITULOS.NRSEQUENCIAL ||
                            '. Titulo ou Fornecedor no existe no Unicoo',
                            NULL,
                            PCDSITUACAO,
                            NULL);
            END IF;
    DBMS_OUTPUT.PUT_LINE( 'P27. SITUACAO: ' || PCDSITUACAO);
            
          ELSE
    DBMS_OUTPUT.PUT_LINE( 'P3. SITUACAO: ' || PCDSITUACAO);
          
            VALIDA_TIT_APB(PNRSEQ_CONTROLE_INTEGRACAO,
                           RFORNECEDOR.CDN_FORNECEDOR);
            VCDINTEGRACAO := 'TI_TIT_APB_CTBL';
            
    DBMS_OUTPUT.PUT_LINE( 'P4. SITUACAO: ' || PCDSITUACAO);
            
            -------------------------------------------------------------
            --- implementação Josias em 28-05-2014 em João Pessoa
            --- Processo para pegar a distribuição do titulo no unicoo.
            -------------------------------------------------------------
            BEGIN
              INSERT INTO TI_TIT_APB_CTBL CTB
                (COD_CTA_CTBL,
                 DAT_PROCESSAMENTO,
                 COD_ESTAB,
                 COD_TIP_FLUXO_FINANC,
                 COD_UNID_FEDERAC,
                 VAL_APROP_CTBL,
                 NRSEQ_CONTROLE_INTEGRACAO,
                 COD_CCUSTO,
                 CDSITUACAO)
              -- josias 30-06-2014
              -- falta tratar o problema do centro de custo nao esta
              -- cadastrado no plano de contas informado
                (SELECT --distinct 
                        Y.COD_CTA_CTBL,
                        Y.DAT_PROCESSAMENTO,
                        Y.COD_ESTAB,
                        Y.COD_TIP_FLUXO_FINANC,
                        Y.COD_UNID_FEDERAC,
                        SUM(Y.VLDISTRIBUICAO),
                        Y.NRSEQ_CONTROLE_INTEGRACAO,
                        NVL((SELECT TO_CHAR(TCC.CD_CCUSTO_TOTVS)
                              FROM TI_CENTRO_CUSTO_CTBL_DEPARA TCC
                             WHERE TO_CHAR(TCC.CDCONTA) =
                                   (DECODE(Y.CDCENTRO_CUSTO,
                                           NULL,
                                           ' ',
                                           Y.CDCENTRO_CUSTO))),
                            DECODE(Y.CDCENTRO_CUSTO,
                                   NULL,
                                   ' ',
                                   Y.CDCENTRO_CUSTO)) CDCENTRO_CUSTO,
                        Y.CDSITUACAO
                   FROM (SELECT DISTINCT X.COD_CTA_CTBL,
                                         X.DAT_PROCESSAMENTO,
                                         X.COD_ESTAB,
                                         X.COD_TIP_FLUXO_FINANC,
                                         X.COD_UNID_FEDERAC,
                                         X.VLDISTRIBUICAO,
                                         X.NRSEQ_CONTROLE_INTEGRACAO,
                                         CASE
                                           WHEN X.TIPO_CCUSTO = '$T' THEN
                                            CASE
                                              WHEN F_TI_PARAMETRO_INTEGRACAO('AOUTILIZA_CODIGO_REDUZIDO') = 'N' THEN
                                               CC.CDCONTA
                                              ELSE
                                               TO_CHAR(X.CDCENTRO_CUSTO)
                                            END
                                           ELSE
                                            ' '
                                         END CDCENTRO_CUSTO,
                                         X.CDSITUACAO
                           FROM CONTA_CONTABIL CC,
                                (SELECT DISTINCT COD_CTA_CTBL,
                                                 DAT_PROCESSAMENTO,
                                                 COD_ESTAB,
                                                 COD_TIP_FLUXO_FINANC,
                                                 COD_UNID_FEDERAC,
                                                 --sum(nvl(decode(b.tipo_distrib,'V',b.vldistribuicao,(-1 * b.vldistribuicao)),ctb.val_aprop_ctbl)) vldistribuicao,     -- Alessandro 22/10/2014
                                                 --sum(b.vldistribuicao) vldistribuicao,      -- Alessandro 22/10/2014
                                                 -- alterado vinicius 31/12/2014
                                                 case 
                                                   when f_ti_parametro_integracao('INTEGRA_VALOR_LIQUIDO_TIT_APB') = 'S' then
                                                     sum(ctb.val_aprop_ctbl)
                                                   else
                                                     CASE
                                                       WHEN B.CDHISTORICO IN
                                                            (F_TI_PARAMETRO_INTEGRACAO('HISTORICO_COM_VALOR_LIQUIDO_APB')) THEN
                                                        (SELECT SUM(VLDISTRIBUICAO)
                                                           FROM DISTRIBUICAO_TITULO_PAGAR DTP
                                                          WHERE DTP.NRREGISTRO_TITULO =
                                                                B.NRREGISTRO_TITULO
                                                            AND DTP.TIPO_DISTRIB = 'V') -
                                                        NVL((SELECT SUM(VLDISTRIBUICAO)
                                                              FROM DISTRIBUICAO_TITULO_PAGAR DTP
                                                             WHERE DTP.NRREGISTRO_TITULO =
                                                                   B.NRREGISTRO_TITULO
                                                               AND DTP.TIPO_DISTRIB = 'D'),
                                                            0)
                                                       ELSE
                                                        SUM(B.VLDISTRIBUICAO)
                                                    end
                                                 END VLDISTRIBUICAO,
                                                 NRSEQ_CONTROLE_INTEGRACAO,
                                                 CTB.CDSITUACAO,
                                                 CASE
                                                   WHEN B.CDCENTRO_CUSTO IS NULL THEN
                                                    CTB.COD_CCUSTO
                                                   ELSE
                                                    TO_CHAR(B.CDCENTRO_CUSTO)
                                                 END CDCENTRO_CUSTO,
                                                 CTB.COD_CCUSTO,
                                                 CTB.TIPO_CCUSTO
                                   FROM V_TI_TIT_APB_CTBL         CTB,
                                        DISTRIBUICAO_TITULO_PAGAR B
                                  WHERE CTB.NRREGISTRO_TITULO =
                                        B.NRREGISTRO_TITULO(+)
                                    AND NRSEQ_CONTROLE_INTEGRACAO =
                                        PNRSEQ_CONTROLE_INTEGRACAO
                                    AND B.TIPO_DISTRIB = 'V' -- ALessandro 22/10/2014
                                 /*group by cod_cta_ctbl,
                                 dat_processamento,
                                 cod_estab,
                                 cod_tip_fluxo_financ,
                                 cod_unid_federac,
                                 nrseq_controle_integracao,
                                 b.cdcentro_custo,
                                 ctb.cod_ccusto,
                                 ctb.tipo_ccusto,
                                 ctb.cdsituacao*/
                                  GROUP BY COD_CTA_CTBL,
                                           DAT_PROCESSAMENTO,
                                           CDHISTORICO,
                                           B.NRREGISTRO_TITULO,
                                           COD_ESTAB,
                                           COD_TIP_FLUXO_FINANC,
                                           COD_UNID_FEDERAC,
                                           NRSEQ_CONTROLE_INTEGRACAO,
                                           B.CDCENTRO_CUSTO,
                                           CTB.COD_CCUSTO,
                                           CTB.TIPO_CCUSTO,
                                           CTB.CDSITUACAO) X
                          WHERE X.CDCENTRO_CUSTO = CC.NRCONTA_REDUZIDA(+)
                            AND CC.NRPLANO_CONTAS(+) =
                                F_TI_PARAMETRO_INTEGRACAO('NRPLANO_CENTRO_CUSTO_UNICOO')
                            and rownum = 1) Y
                  GROUP BY Y.COD_CTA_CTBL,
                           Y.DAT_PROCESSAMENTO,
                           Y.COD_ESTAB,
                           Y.COD_TIP_FLUXO_FINANC,
                           Y.COD_UNID_FEDERAC,
                           Y.NRSEQ_CONTROLE_INTEGRACAO,
                           Y.CDCENTRO_CUSTO,
                           Y.CDSITUACAO);
            EXCEPTION
              WHEN DUP_VAL_ON_INDEX THEN
                NULL;
              --WHEN OTHERS THEN
                -- Josias 26-06-2014 - colocado essa exceção para acompanhar erro
                --RAISE_APPLICATION_ERROR(-20100, ' Erro -> ' || SQLERRM);
                --NULL;
            END;
            IF SQL%ROWCOUNT = 0 THEN
              P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                            VCDINTEGRACAO,
                            'A view v_TI_TIT_APB_CTBL não encontrou registro para o processo ==>' ||
                            PNRSEQ_CONTROLE_INTEGRACAO,
                            NULL,
                            PCDSITUACAO,
                            NULL);
            ELSE
              vcdintegracao := 'TI_TIT_APB_IMPOSTO';
              insert into ti_tit_apb_imposto
                (cod_ser_docto,
                 ind_clas_impto,
                 val_impto_ja_recolhid,
                 val_outras_deduc_impto,
                 cod_titulo_ap,
                 val_rendto_tribut,
                 val_aliq_impto,
                 val_deduc_faixa_imto,
                 cod_estab,
                 cod_espec_docto,
                 cod_parcela,
                 cod_unid_federac,
                 cod_imposto,
                 cod_classif_impto,
                 val_deduc_inss,
                 val_deduc_depend,
                 val_deduc_pensao,
                 val_deduc_outras_deduc,
                 val_base_liq_impto,
                 val_imposto,
                 dat_vencto,
                 des_text_histor,
                 dat_processamento,
                 cdsituacao,
                 val_deduc_faixa_impto,
                 cod_cta_ctbl,
                 nrseq_controle_integracao,
                 cod_plano_ctb_cbtl,
                 ind_ocorrencia,
                 cod_tip_fluxo_financ)

                select cod_ser_docto,
                       ind_clas_impto,
                       val_impto_ja_recolhid,
                       val_outras_deduc_impto,
                       substr(cod_titulo_ap, 0, 10),
                       val_rendto_tribut,
                       val_aliq_impto,
                       val_deduc_faixa_imto,
                       cod_estab,
                       cod_espec_docto,
                       cod_parcela,
                       cod_unid_federac,
                       cod_imposto,
                       cod_classif_impto,
                       val_deduc_inss,
                       val_deduc_depend,
                       val_deduc_pensao,
                       val_deduc_outras_deduc,
                       val_base_liq_impto,
                       val_imposto,
                       dat_vencto,
                       des_text_histor,
                       dat_processamento,
                       cdsituacao,
                       val_deduc_faixa_impto,
                       cod_cta_ctbl,
                       nrseq_controle_integracao,
                       cod_plano_ctb_cbtl,
                       ind_ocorrencia,
                       cod_tip_fluxo_financ
                  from v_ti_tit_apb_imposto ip
                 where ip.nrseq_controle_integracao =
                       pnrseq_controle_integracao;
            END IF;
          END IF;
        END IF;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
        
    DBMS_OUTPUT.PUT_LINE( 'P5. SITUACAO: ' || PCDSITUACAO);
        
          P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                        VCDINTEGRACAO,
                        SQLERRM,
                        NULL,
                        PCDSITUACAO,
                        NULL);
        WHEN OTHERS THEN
          P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                        VCDINTEGRACAO,
                        SQLERRM,
                        NULL,
                        PCDSITUACAO,
                        NULL);
      END;
      
    DBMS_OUTPUT.PUT_LINE( 'P6. SITUACAO: ' || PCDSITUACAO);
      
      --====================================--
      -- Atualizar o situao da integrao --
      ----------------------------------------
      P_UPDATE_CONTROLE_INTEGRACAO(L_TITULOS.NRSEQUENCIAL,
                                   PCDSITUACAO,
                                   NULL);
      begin
        update ti_tit_apb tp set tp.cdsituacao = PCDSITUACAO
         where tp.nrseq_controle_integracao = l_titulos.nrsequencial;
      exception
        when others then
          null;
      end;
                                   
    DBMS_OUTPUT.PUT_LINE( 'P7. SITUACAO: ' || PCDSITUACAO);
                                   
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE( 'P8. SITUACAO: ' || PCDSITUACAO);
    
  END P_TI_TIT_APB;

  --===================================================================--
  -- P_MIGRA_VENDEDORES -> Migracao dos Vendedores como Representantes --
  -----------------------------------------------------------------------
  /*FUNCTION F_MIGRA_VENDEDORES RETURN VARCHAR2 IS
    vretorno varchar2(10);
  begin
    p_migra_vendedores(vretorno);
    return 'OK';
  END F_MIGRA_VENDEDORES;
  */
  procedure resetar_sequence( p_seq_name in varchar2 )
  is
      l_val number;
  begin
      execute immediate
      'select ' || p_seq_name || '.nextval from dual' INTO l_val;

      execute immediate
      'alter sequence ' || p_seq_name || ' increment by -' || l_val || 
                                                            ' minvalue 0';

      execute immediate
      'select ' || p_seq_name || '.nextval from dual' INTO l_val;

      execute immediate
      'alter sequence ' || p_seq_name || ' increment by 1 minvalue 0';
  end resetar_sequence;
  
  procedure P_MIGRA_VENDEDORES is
    vnum_pessoa number := 0;
  begin
--    pretorno := 'OK';
    /*limpar registros pre-existentes no TOTVS antes do processamento*/
    for x in (select r.u##cod_empresa, r.cdn_repres, r.num_pessoa from ems5.representante r) loop
      /* manter pessoas para nao gerar nova sequencia em NUM_PESSOA
      delete from ems5.pessoa_fisic pf where pf.num_pessoa_fisic = x.num_pessoa
                                         and not exists(select 1 from ems5.cliente c where c.num_pessoa = x.num_pessoa)
                                         and not exists(select 1 from ems5.fornecedor f where f.num_pessoa = x.num_pessoa);
                                         
      delete from ems5.pessoa_jurid pj where pj.num_pessoa_jurid = x.num_pessoa
                                         and not exists(select 1 from ems5.cliente c where c.num_pessoa = x.num_pessoa)
                                         and not exists(select 1 from ems5.fornecedor f where f.num_pessoa = x.num_pessoa)
                                         and not exists(select 1 from ems5.estabelecimento e where e.num_pessoa_jurid = x.num_pessoa);
      */                                   
      delete from ems5.repres_financ rf where rf.u##cod_empresa = x.u##cod_empresa and rf.cdn_repres = x.cdn_repres;

      delete from ems5.representante r where r.u##cod_empresa = x.u##cod_empresa and r.cdn_repres = x.cdn_repres;
                                         
    end loop;
    
    resetar_sequence('ems5.representante_seq');
    resetar_sequence('ems5.repres_financ_seq');
    
    for vend in (select p.NRREGISTRO,
                        p.NOPESSOA,
                        p.TPPESSOA,
                        p.NRCGC_CPF,
                        p.NRINSCEST_RG,
                        p.CDRAMOATIV,
                        p.DTNASCIMENTO,
                        p.CDSEXO,
                        p.CDESTADOCIVIL,
                        p.NOMAE,
                        p.NRREG_NASCTO,
                        p.NOCARTORIO_REG,
                        p.TXOBSERVACOES,
                        p.NOOPERADOR,
                        p.NONATURALIDADE,
                        p.CDNACIONALIDADE,
                        p.NOORGAO_EMISSOR_RG,
                        p.NRINSCMUN,
                        p.NRCEI,
                        p.NRCARTAO_CONVENIO,
                        p.NOABREVIADO,
                        p.CDPAIS_EMISSOR_ID,
                        p.DTEXPEDICAO_RG,
                        p.CDESTADO_EMISSOR_RG,
                        p.CDCIDADE_NATURALIDADE,
                        e.TPENDERECO,
                        e.NOLOGRADOURO,
                        e.NRIMOVEL,
                        e.TXCOMPLEMENTO,
                        e.NOBAIRRO,
                        e.CDCIDADE,
                        e.CDESTADO,
                        e.NRCEP,
                        e.NRTELEFONE,
                        e.NRFAX,
                        e.CDEMAIL,
                        e.NRDDD,
                        e.CDEMAIL_ADICIONAL,
                        c.nocidade,
                        v.*
                   from vendedor                        v,
                        pessoa                          p,
                        endereco                        e,
                        producao.cidade@unicoo_homologa c
                  where p.nrregistro = v.nrregistro_pessoa
                    and e.nrregistro(+) = p.nrregistro
                    and c.cdcidade(+) = e.cdcidade
                  order by 1) loop
      if vend.tppessoa = 'F' then

        /* verificar se a pessoa ja existe */
        vnum_pessoa := 0;
        begin
          select nvl(pf.num_pessoa_fisic,'0') into vnum_pessoa
            from ems5.pessoa_fisic pf
           where pf.u##nom_pessoa = upper(vend.nopessoa)
             and pf.U##COD_ID_ESTAD_FISIC = ' '
             and pf.U##CODUNIDFEDERACEMISESTAD = ' '
             and pf.DAT_NASC_PESSOA_FISIC = vend.dtnascimento
             and pf.U##NOM_MAE_PESSOA = upper(vend.nomae)
             and pf.u##cod_id_feder = vend.nrcgc_cpf
             and rownum = 1;
        exception
          when others then
            vnum_pessoa := 0;
        end;   

        if vnum_pessoa = 0 then        
          select ems5.seq_pessoa_fisica.nextval into vnum_pessoa from dual;

          begin
            insert into pessoa_fisic
              (NUM_PESSOA_FISIC,
               U##NOM_PESSOA,
               NOM_PESSOA,
               U##COD_ID_FEDER,
               COD_ID_FEDER,
               U##COD_ID_ESTAD_FISIC,
               COD_ID_ESTAD_FISIC,
               CODORGAOEMISIDESTAD,
               U##CODUNIDFEDERACEMISESTAD,
               CODUNIDFEDERACEMISESTAD,
               NOM_ENDERECO,
               NOM_ENDER_COMPL,
               NOM_BAIRRO,
               NOM_CIDADE,
               NOM_CONDADO,
               U##COD_PAIS,
               COD_PAIS,
               U##COD_UNID_FEDERAC,
               COD_UNID_FEDERAC,
               COD_CEP,
               COD_CX_POST,
               COD_TELEFONE,
               COD_RAMAL,
               COD_FAX,
               COD_RAMAL_FAX,
               COD_TELEX,
               COD_MODEM,
               COD_RAMAL_MODEM,
               COD_E_MAIL,
               DAT_NASC_PESSOA_FISIC,
               COD_PAIS_NASC,
               COD_UNID_FEDERAC_NASC,
               DES_ANOT_TAB,
               COD_USUAR_ULT_ATUALIZ,
               DAT_ULT_ATUALIZ,
               HRA_ULT_ATUALIZ,
               U##NOM_MAE_PESSOA,
               NOM_MAE_PESSOA,
               COD_IMAGEM,
               LOG_EMS_20_ATLZDO,
               COD_LIVRE_1,
               LOG_LIVRE_1,
               NUM_LIVRE_1,
               VAL_LIVRE_1,
               DAT_LIVRE_1,
               IND_TIP_PESSOA_FISIC,
               NOMNACIONPESSOAFISIC,
               NOMPROFISPESSOAFISIC,
               INDESTADOCIVILPESSOA,
               NOM_HOME_PAGE,
               NOM_ENDER_TEXT,
               LOG_ENVIO_BCO_HISTOR,
               COD_LIVRE_2,
               DAT_LIVRE_2,
               LOG_LIVRE_2,
               NUM_LIVRE_2,
               VAL_LIVRE_2,
               COD_E_MAIL_COBR,
               NUM_PESSOA_FISIC_COBR,
               NOM_ENDER_COBR,
               NOM_ENDER_COMPL_COBR,
               NOM_BAIRRO_COBR,
               COD_UNID_FEDERAC_COBR,
               NOM_CIDAD_COBR,
               NOM_CONDAD_COBR,
               COD_PAIS_COBR,
               COD_CEP_COBR,
               COD_CX_POST_COBR,
               NOM_ENDER_COBR_TEXT,
               COD_SUB_REGIAO_VENDAS,
               CDD_VERSION,
               LOG_REPLIC_PESSOA_HCM,
               LOG_REPLIC_PESSOA_CRM,
               LOG_REPLIC_PESSOA_GPS,
               NUMPESSOAFISICMATRIZ,
               COD_FAX_2,
               COD_RAMAL_FAX_2,
               COD_TELEF_2,
               COD_RAMAL_2,
               IND_TIP_ID_ESTAD,
               IND_TIP_MATRIZ,
               PROGRESS_RECID)
            values
              (vnum_pessoa,
               upper(vend.nopessoa), --U##NOM_PESSOA,
               vend.nopessoa, --NOM_PESSOA,
               vend.nrcgc_cpf, --U##COD_ID_FEDER,
               vend.nrcgc_cpf, --COD_ID_FEDER,
               ' ', --U##COD_ID_ESTAD_FISIC,
               ' ', --COD_ID_ESTAD_FISIC,
               ' ', --CODORGAOEMISIDESTAD,
               ' ', --U##CODUNIDFEDERACEMISESTAD,
               ' ', --CODUNIDFEDERACEMISESTAD,
               nvl(trim(vend.nologradouro) ||
                   decode(vend.nrimovel, null, '', ' ' || vend.nrimovel),
                   'NAO INFORMADO'), --NOM_ENDERECO,
               nvl(case when length(vend.txcomplemento) <= 10 then
                   vend.txcomplemento when
                   length(vend.txcomplemento) > 10 and
                   length(f_reduz_compl(vend.txcomplemento, 0)) <= 10 then
                   f_reduz_compl(vend.txcomplemento, 0) else
                   substr(f_reduz_compl(vend.txcomplemento, 0), 1, 10) end,
                   ' '), --NOM_ENDER_COMPL,
               nvl(case when length(vend.nobairro) <= 20 then vend.nobairro when
                   length(vend.nobairro) > 20 and
                   length(f_reduz_bairro(vend.nobairro, 0)) <= 20 then
                   f_reduz_bairro(vend.nobairro, 0) else
                   substr(f_reduz_bairro(vend.nobairro, 0), 1, 20) end,
                   'NAO INFORMADO'), --NOM_BAIRRO,
               nvl(vend.nocidade, 'NAO INFORMADO'), --NOM_CIDADE,
               ' ', --NOM_CONDADO,
               'BRA', --U##COD_PAIS,
               'BRA', --COD_PAIS,
               nvl(vend.cdestado, 'RJ'), --U##COD_UNID_FEDERAC,
               nvl(vend.cdestado, 'RJ'), --COD_UNID_FEDERAC,
               nvl(vend.nrcep,
                   f_ti_parametro_integracao('NRCEP_DEFAULT_INCLUSAO')), --COD_CEP,
               ' ', --COD_CX_POST,
               nvl(vend.nrtelefone, ' '), --COD_TELEFONE,
               ' ', --COD_RAMAL,
               vend.nrfax, --COD_FAX,
               ' ', --COD_RAMAL_FAX,
               ' ', --COD_TELEX,
               ' ', --COD_MODEM,
               ' ', --COD_RAMAL_MODEM,
               nvl(vend.cdemail, vend.cdemail_adicional), --COD_E_MAIL,
               vend.dtnascimento, --DAT_NASC_PESSOA_FISIC,
               ' ', --COD_PAIS_NASC,
               ' ', --COD_UNID_FEDERAC_NASC,
               ' ', --DES_ANOT_TAB,
               'migracao', --COD_USUAR_ULT_ATUALIZ,
               sysdate, --DAT_ULT_ATUALIZ,
               ' ', --HRA_ULT_ATUALIZ,
               upper(vend.nomae), --U##NOM_MAE_PESSOA,
               vend.nomae, --NOM_MAE_PESSOA,
               ' ', --COD_IMAGEM,
               0, --LOG_EMS_20_ATLZDO,
               ' ', --COD_LIVRE_1,
               0, --LOG_LIVRE_1,
               0, --NUM_LIVRE_1,
               0, --VAL_LIVRE_1,
               sysdate, --DAT_LIVRE_1,
               ' ', --IND_TIP_PESSOA_FISIC,
               ' ', --NOMNACIONPESSOAFISIC,
               ' ', --NOMPROFISPESSOAFISIC,
               decode(vend.cdestadocivil,
                      'C',
                      'CASADO',
                      'S',
                      'SOLTEIRO',
                      'V',
                      'VIUVO',
                      'D',
                      'DIVORCIADO',
                      'Q',
                      'DIVORCIADO',
                      'OUTROS'), --INDESTADOCIVILPESSOA,
               ' ', --NOM_HOME_PAGE,
               ' ', --NOM_ENDER_TEXT,
               0, --LOG_ENVIO_BCO_HISTOR,
               ' ', --COD_LIVRE_2,
               null, --DAT_LIVRE_2,
               0, --LOG_LIVRE_2,
               0, --NUM_LIVRE_2,
               0, --VAL_LIVRE_2,
               ' ', --COD_E_MAIL_COBR,
               0, --NUM_PESSOA_FISIC_COBR,
               trim(vend.nologradouro) ||
               decode(vend.nrimovel, null, '', ' ' || vend.nrimovel), --NOM_ENDER_COBR,
               case when length(vend.txcomplemento) <= 10 then
               vend.txcomplemento when
               length(vend.txcomplemento) > 10 and
               length(f_reduz_compl(vend.txcomplemento, 0)) <= 10 then
               f_reduz_compl(vend.txcomplemento, 0) else
               substr(f_reduz_compl(vend.txcomplemento, 0), 1, 10) end, --NOM_ENDER_COMPL_COBR,
               case when length(vend.nobairro) <= 20 then vend.nobairro when
               length(vend.nobairro) > 20 and
               length(f_reduz_bairro(vend.nobairro, 0)) <= 20 then
               f_reduz_bairro(vend.nobairro, 0) else
               substr(f_reduz_bairro(vend.nobairro, 0), 1, 20) end, --NOM_BAIRRO_COBR,
               nvl(vend.cdestado, 'RJ'), --COD_UNID_FEDERAC_COBR,
               nvl(vend.nocidade, 'NAO INFORMADO'), --NOM_CIDAD_COBR,
               ' ', --NOM_CONDADO_COBR,
               'BRA', --COD_PAIS_COBR,
               nvl(vend.nrcep,
                   f_ti_parametro_integracao('NRCEP_DEFAULT_INCLUSAO')), --COD_CEP_COBR,
               ' ', --COD_CX_POST_COBR,
               ' ', --NOM_ENDER_COBR_TEXT,
               ' ', --COD_SUB_REGIAO_VENDAS,
               0, --CDD_VERSION,
               '1', --LOG_REPLIC_PESSOA_HCM,
               '1', --LOG_REPLIC_PESSOA_CRM,
               '1', --LOG_REPLIC_PESSOA_GPS,
               vnum_pessoa, --NUMPESSOAFISICMATRIZ,
               ' ', --COD_FAX_2,
               ' ', --COD_RAMAL_FAX_2,
               ' ', --COD_TELEF_2,
               ' ', --COD_RAMAL_2,
               'Inscrição Estadual', --IND_TIP_ID_ESTAD,
               'Física', --IND_TIP_MATRIZ,
               ems5.pessoa_fisic_seq.nextval --PROGRESS_RECID
               );
               
          exception
            when DUP_VAL_ON_INDEX then null;
          end;              
        end if;
      else
        /* verificar se a pessoa ja existe */
        vnum_pessoa := 0;
        begin
          select nvl(pj.num_pessoa_jurid,'0') into vnum_pessoa
            from ems5.pessoa_jurid pj
           where pj.u##cod_id_feder = vend.nrcgc_cpf
             and pj.u##nom_pessoa = upper(vend.nopessoa)
             and rownum = 1;
        exception
          when others then
            vnum_pessoa := 0;
        end;   

        if vnum_pessoa = 0 then
          select ems5.seq_pessoa_juridica.nextval into vnum_pessoa from dual;

          begin
              insert into pessoa_jurid
                (NUM_PESSOA_JURID,
                 U##NOM_PESSOA,
                 NOM_PESSOA,
                 U##COD_ID_FEDER,
                 COD_ID_FEDER,
                 COD_ID_ESTAD_JURID,
                 COD_ID_MUNIC_JURID,
                 U##COD_ID_PREVID_SOCIAL,
                 COD_ID_PREVID_SOCIAL,
                 LOG_FINS_LUCRAT,
                 NUMPESSOAJURIDMATRIZ,
                 NOM_ENDERECO,
                 NOM_ENDER_COMPL,
                 NOM_BAIRRO,
                 NOM_CIDADE,
                 NOM_CONDADO,
                 U##COD_PAIS,
                 COD_PAIS,
                 U##COD_UNID_FEDERAC,
                 COD_UNID_FEDERAC,
                 COD_CEP,
                 COD_CX_POST,
                 COD_TELEFONE,
                 COD_FAX,
                 COD_RAMAL_FAX,
                 COD_TELEX,
                 COD_MODEM,
                 COD_RAMAL_MODEM,
                 COD_E_MAIL,
                 COD_E_MAIL_COBR,
                 NUM_PESSOA_JURID_COBR,
                 NOM_ENDER_COBR,
                 NOM_ENDER_COMPL_COBR,
                 NOM_BAIRRO_COBR,
                 NOM_CIDAD_COBR,
                 NOM_CONDAD_COBR,
                 U##COD_UNID_FEDERAC_COBR,
                 COD_UNID_FEDERAC_COBR,
                 U##COD_PAIS_COBR,
                 COD_PAIS_COBR,
                 COD_CEP_COBR,
                 COD_CX_POST_COBR,
                 NUM_PESSOA_JURID_PAGTO,
                 NOM_ENDER_PAGTO,
                 NOM_ENDER_COMPL_PAGTO,
                 NOM_BAIRRO_PAGTO,
                 NOM_CIDAD_PAGTO,
                 NOM_CONDAD_PAGTO,
                 U##COD_PAIS_PAGTO,
                 COD_PAIS_PAGTO,
                 U##COD_UNID_FEDERAC_PAGTO,
                 COD_UNID_FEDERAC_PAGTO,
                 COD_CEP_PAGTO,
                 COD_CX_POST_PAGTO,
                 DES_ANOT_TAB,
                 IND_TIP_PESSOA_JURID,
                 INDTIPCAPITPESSOAJURID,
                 COD_USUAR_ULT_ATUALIZ,
                 DAT_ULT_ATUALIZ,
                 HRA_ULT_ATUALIZ,
                 COD_IMAGEM,
                 LOG_EMS_20_ATLZDO,
                 COD_LIVRE_1,
                 LOG_LIVRE_1,
                 NUM_LIVRE_1,
                 VAL_LIVRE_1,
                 DAT_LIVRE_1,
                 NOM_HOME_PAGE,
                 NOM_ENDER_TEXT,
                 NOM_ENDER_COBR_TEXT,
                 NOM_ENDER_PAGTO_TEXT,
                 LOG_ENVIO_BCO_HISTOR,
                 COD_LIVRE_2,
                 DAT_LIVRE_2,
                 LOG_LIVRE_2,
                 NUM_LIVRE_2,
                 VAL_LIVRE_2,
                 IND_NATUR_PESSOA_JURID,
                 NOM_FANTASIA,
                 COD_SUB_REGIAO_VENDAS,
                 CDD_VERSION,
                 LOG_REPLIC_PESSOA_HCM,
                 LOG_REPLIC_PESSOA_CRM,
                 LOG_REPLIC_PESSOA_GPS,
                 COD_FAX_2,
                 COD_RAMAL_FAX_2,
                 COD_TELEF_2,
                 COD_RAMAL_2,
                 IND_TIP_MATRIZ,
                 PROGRESS_RECID)
              values
                (vnum_pessoa, --NUM_PESSOA_JURID
                 upper(vend.nopessoa), --U##NOM_PESSOA,
                 vend.nopessoa, --NOM_PESSOA,
                 vend.nrcgc_cpf, --U##COD_ID_FEDER,
                 vend.nrcgc_cpf, --COD_ID_FEDER,
                 ' ', --U##COD_ID_ESTAD_FISIC,
                 ' ', --COD_ID_ESTAD_FISIC,
                 ' ', --U##COD_ID_PREVID_SOCIAL,
                 ' ', --COD_ID_PREVID_SOCIAL,
                 0, --LOG_FINS_LUCRAT,
                 0, --NUMPESSOAJURIDMATRIZ
                 nvl(trim(vend.nologradouro) ||
                     decode(vend.nrimovel, null, '', ' ' || vend.nrimovel),
                     'NAO INFORMADO'), --NOM_ENDERECO,
                 nvl(case when length(vend.txcomplemento) <= 10 then
                     vend.txcomplemento when
                     length(vend.txcomplemento) > 10 and
                     length(f_reduz_compl(vend.txcomplemento, 0)) <= 10 then
                     f_reduz_compl(vend.txcomplemento, 0) else
                     substr(f_reduz_compl(vend.txcomplemento, 0), 1, 10) end,
                     ' '), --NOM_ENDER_COMPL,
                 nvl(case when length(vend.nobairro) <= 20 then vend.nobairro when
                     length(vend.nobairro) > 20 and
                     length(f_reduz_bairro(vend.nobairro, 0)) <= 20 then
                     f_reduz_bairro(vend.nobairro, 0) else
                     substr(f_reduz_bairro(vend.nobairro, 0), 1, 20) end,
                     'NAO INFORMADO'), --NOM_BAIRRO,
                 nvl(vend.nocidade, 'NAO INFORMADO'), --NOM_CIDADE,
                 ' ', --NOM_CONDADO,
                 'BRA', --U##COD_PAIS,
                 'BRA', --COD_PAIS,
                 nvl(vend.cdestado, 'RJ'), --U##COD_UNID_FEDERAC,
                 nvl(vend.cdestado, 'RJ'), --COD_UNID_FEDERAC,
                 nvl(vend.nrcep,
                     f_ti_parametro_integracao('NRCEP_DEFAULT_INCLUSAO')), --COD_CEP,
                 ' ', --COD_CX_POST,
                 nvl(vend.nrtelefone, ' '), --COD_TELEFONE,
                 nvl(vend.nrfax, 0), --COD_FAX,
                 ' ', --COD_RAMAL_FAX,
                 ' ', --COD_TELEX,
                 ' ', --COD_MODEM,
                 ' ', --COD_RAMAL_MODEM,
                 nvl(nvl(vend.cdemail, vend.cdemail_adicional), ' '), --COD_E_MAIL,
                 ' ', --COD_E_MAIL_COBR,
                 0, --NUMPESSOA_COBR
                 nvl(trim(vend.nologradouro) ||
                     decode(vend.nrimovel, null, '', ' ' || vend.nrimovel),
                     'NAO INFORMADO'), --NOM_ENDERECO_COBR,
                 nvl(case when length(vend.txcomplemento) <= 10 then
                     vend.txcomplemento when
                     length(vend.txcomplemento) > 10 and
                     length(f_reduz_compl(vend.txcomplemento, 0)) <= 10 then
                     f_reduz_compl(vend.txcomplemento, 0) else
                     substr(f_reduz_compl(vend.txcomplemento, 0), 1, 10) end,
                     ' '), --NOM_ENDER_COMPL_COBR,
                 nvl(case when length(vend.nobairro) <= 20 then vend.nobairro when
                     length(vend.nobairro) > 20 and
                     length(f_reduz_bairro(vend.nobairro, 0)) <= 20 then
                     f_reduz_bairro(vend.nobairro, 0) else
                     substr(f_reduz_bairro(vend.nobairro, 0), 1, 20) end,
                     'NAO INFORMADO'), --NOM_BAIRRO_COBR,
                 nvl(vend.nocidade, 'NAO INFORMADO'), --NOM_CIDADE_COBR,
                 ' ', --NOM_CONDADO_COBR,
                 nvl(vend.cdestado, 'RJ'), --U##COD_UNID_FEDERAC_COBR,
                 nvl(vend.cdestado, 'RJ'), --COD_UNID_FEDERAC_COBR,
                 'BRA', --U##COD_PAIS_COBR,
                 'BRA', --COD_PAIS_COBR,
                 nvl(vend.nrcep,
                     f_ti_parametro_integracao('NRCEP_DEFAULT_INCLUSAO')), --COD_CEP_COBR,
                 ' ', --COD_CX_POST_COBR,
                 0, --NUMPESSOA_PAGTO
                 nvl(trim(vend.nologradouro) ||
                     decode(vend.nrimovel, null, '', ' ' || vend.nrimovel),
                     'NAO INFORMADO'), --NOM_ENDERECO_PAGTO,
                 nvl(case when length(vend.txcomplemento) <= 10 then
                     vend.txcomplemento when
                     length(vend.txcomplemento) > 10 and
                     length(f_reduz_compl(vend.txcomplemento, 0)) <= 10 then
                     f_reduz_compl(vend.txcomplemento, 0) else
                     substr(f_reduz_compl(vend.txcomplemento, 0), 1, 10) end,
                     ' '), --NOM_ENDER_COMPL_PAGTO,
                 nvl(case when length(vend.nobairro) <= 20 then vend.nobairro when
                     length(vend.nobairro) > 20 and
                     length(f_reduz_bairro(vend.nobairro, 0)) <= 20 then
                     f_reduz_bairro(vend.nobairro, 0) else
                     substr(f_reduz_bairro(vend.nobairro, 0), 1, 20) end,
                     'NAO INFORMADO'), --NOM_BAIRRO_PAGTO,
                 nvl(vend.nocidade, 'NAO INFORMADO'), --NOM_CIDADE_PAGTO,
                 ' ', --NOM_CONDADO_PAGTO,
                 'BRA', --U##COD_PAIS_PAGTO,
                 'BRA', --COD_PAIS_PAGTO,
                 nvl(vend.cdestado, 'RJ'), --U##COD_UNID_FEDERAC_PAGTO,
                 nvl(vend.cdestado, 'RJ'), --COD_UNID_FEDERAC_PAGTO,
                 nvl(vend.nrcep,
                     f_ti_parametro_integracao('NRCEP_DEFAULT_INCLUSAO')), --COD_CEP_PAGTO,
                 ' ', --COD_CX_POST_PAGTO,
                 ' ', --DES_ANOT_TAB,
                 ' ', --IND_TIP_PESSOA_FISIC,
                 0, --INDTIPCAPITPESSOAJURID
                 'migracao', --COD_USUAR_ULT_ATUALIZ,
                 sysdate, --DAT_ULT_ATUALIZ,
                 ' ', --HRA_ULT_ATUALIZ,
                 ' ', --COD_IMAGEM
                 0, --LOG_EMS_20_ATLZDO
                 NULL, --COD_LIVRE_1
                 0, --LOG_LIVRE_1
                 0, --NUM_LIVRE_1
                 0, --VAL_LIVRE_1
                 SYSDATE, --DAT_LIVRE_1
                 ' ', --NOM_HOME_PAGE
                 ' ', --NOM_ENDER_TEXT
                 ' ', --NOM_ENDER_COBR_TEXT
                 ' ', --NOM_ENDER_PAGTO_TEXT
                 0, --LOG_ENVIO_BCO_HISTOR
                 ' ', --COD_LIVRE_2
                 NULL, --DAT_LIVRE_2
                 0, --LOG_LIVRE_2
                 0, --NUM_LIVRE_2
                 0, --VAL_LIVRE_2
                 'Nacional', --IND_NATUR_PESSOA_JURID
                 ' ', --NOM_FANTASIA
                 ' ', --COD_SUB_REGIAO_VENDAS
                 0, --CDD_VERSION
                 '1', --LOG_REPLIC_PESSOA_HCM
                 '1', --LOG_REPLIC_PESSOA_CRM
                 '1', --LOG_REPLIC_PESSOA_GPS
                 ' ', --COD_FAX_2
                 ' ', --COD_RAMAL_FAX_2
                 ' ', --COD_TELEF_2
                 ' ', --COD_RAMAL_2
                 'Jurídica', --IND_TIP_MATRIZ
                 ems5.pessoa_jurid_seq.nextval --PROGRESS_RECID
                 );
          exception
            when DUP_VAL_ON_INDEX then null;
          end;              
        end if;
      end if;

      begin
        insert into REPRESENTANTE
        values
          (1,
           1,
           vend.cdvendedor,
           vnum_pessoa,
           vend.nopessoa,
           upper(f_abrevia_nome(vend.nopessoa, 23, 'PEA')) || vend.nrregistro,
           f_abrevia_nome(vend.nopessoa, 23, 'PEA') || vend.nrregistro,
           'BRA',
           vend.nrcgc_cpf,
           999,
           999,
           sysdate,
           ' ',
           ' ',
           ' ',
           0,
           0,
           0,
           null,
           'Ativo',
           null,
           ' ',
           null,
           0,
           0,
           0,
           0,
           ems5.representante_seq.nextval);
      exception
        when DUP_VAL_ON_INDEX then null;
      end;              

      begin
          insert into REPRES_FINANC
          values
            (1,
             1,
             vend.cdvendedor,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             0,
             999,
             999,
             ' ',
             ' ',
             ' ',
             'Pagamento',
             0,
             ' ',
             0,
             0,
             0,
             sysdate,
             'UN',
             0,
             0,
             ' ',
             0,
             'Nenhum',
             ' ',
             null,
             0,
             0,
             0,
             0,
             'PADRAO',
             0,
             ems5.repres_financ_seq.nextval);
        exception
          when DUP_VAL_ON_INDEX then null;
        end;              

    end loop;

--    open pretorno for select count(*) from ems5.representante;    
  end p_migra_vendedores;

  -- Rogério - 07/12/2016

  PROCEDURE P_GERA_SERIE_NOTA AS

    /*
    ***************************************************************************************************************
    Criac?o          : -
    Data             : -
    Modulo Principal : Integrac?o EMS5
    Modulos          : -
    Objetivo         : Migrar série Unicoo x Totvs 12
    Alteracoes
    +------------------------------------------------------------------------------------------------------------------------------------------+
    | DATA       | RESPONSAVEL   | VERSAO        | PENDENCIA | ALTERACAO                                                                       |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    | 17/06/2016 | VINICIUS      |               |           | Criação da procedure   |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    */

    VAOEXISTE CHAR;

    CURSOR C_SERIES IS

      SELECT DISTINCT T.CDMOVIMENTO u##cod_ser_fisc_nota,
                      T.CDMOVIMENTO cod_ser_fisc_nota,
                      T.NOMOVIMENTO des_ser_fisc_nota,
                      ' ' cod_livre_1,
                      0 log_livre_1,
                      0 num_livre_1,
                      0 val_livre_1,
                      TRUNC(SYSDATE) dat_livre_1,
                      0 log_envio_bco_histor,
                      ' ' cod_livre_2,
                      NULL dat_livre_2,
                      0 log_livre_2,
                      0 num_livre_2,
                      0 val_livre_2,
                      0 cdd_version
        FROM TI_TIPO_MOVIMENTO_TIT_ACR T
       WHERE CDMODULO = 'FT';

  BEGIN

    FOR CS IN C_SERIES LOOP

      BEGIN
        SELECT 'S'
          INTO VAOEXISTE
          FROM EMS5.SER_FISC_NOTA S
         WHERE S.U##COD_SER_FISC_NOTA = CS.COD_SER_FISC_NOTA;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          VAOEXISTE := 'N';
      END;

      IF VAOEXISTE = 'N' THEN

        INSERT INTO EMS5.SER_FISC_NOTA
        VALUES
          (CS.u##cod_ser_fisc_nota,
           CS.cod_ser_fisc_nota,
           CS.des_ser_fisc_nota,
           CS.cod_livre_1,
           CS.log_livre_1,
           CS.num_livre_1,
           CS.val_livre_1,
           CS.dat_livre_1,
           CS.log_envio_bco_histor,
           CS.cod_livre_2,
           CS.dat_livre_2,
           CS.log_livre_2,
           CS.num_livre_2,
           CS.val_livre_2,
           CS.cdd_version,
           EMS5.SER_FISC_NOTA_SEQ.NEXTVAL);
      END IF;
    END LOOP;
    COMMIT;
  END;

  -- Rogério - 07/12/2016

  --===============================================--
  -- TI_Cliente --> Enviar Cliente para integracao --
  ---------------------------------------------------
  PROCEDURE P_TI_CLIENTE(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                         PNRSESSAO                  NUMBER,
                         PCDSITUACAO                IN OUT VARCHAR2) IS
    nrregistro_aux number;
    
    CURSOR C_INTEGRA_CLIFOR IS
      SELECT CI.NRSEQUENCIAL        NRSEQ_CONTROLE_INTEGRACAO,
             CI.CDSITUACAO,
             CI.NRSEQUENCIAL_ORIGEM NRPESSOA,
             CI.CDIDENTIFICADOR
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.NRSESSAO = PNRSESSAO
         AND CI.TPINTEGRACAO = 'CL'
         AND CI.CDSITUACAO = PCDSITUACAO
         AND (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0);

    --VARIAVEIS PARA TRATAR E REDUZ O ENDERECO
    VQTLOGRA             NUMBER;
    VQTCOMPL             NUMBER;
    VQTLOGRA_REDUZ       NUMBER;
    VQTCOMPL_REDUZ       NUMBER;
    VQTLOGRA_REDUZ_ABREV NUMBER;
    VQTNRIMOVEL          NUMBER;
    VLOGRA               VARCHAR2(50);
    VCOMPL               VARCHAR2(15);
    VLOGRA_REDUZ         VARCHAR2(50);
    VCOMPL_REDUZ         VARCHAR2(15);
    VLOGRA_REDUZ_ABREV   VARCHAR2(50);

    --VLOGRADOURO E VCOMPLEMENTO RECEBERAO OS CONTEUDOS DO ENDERECO E COMPLEMENTO APOS ANALISE DE TAMANHOS
    VLOGRADOURO       VARCHAR2(40);
    VCOMPLEMENTO      VARCHAR2(10);
    VBAIRRO           VARCHAR2(25);
    VLOGRADOURO_COBR  VARCHAR2(40);
    VCOMPLEMENTO_COBR VARCHAR2(10);
    VBAIRRO_COBR      VARCHAR2(25);

    --VARIAVIES QUE CONTROLAM O NUMERO MAXIMO DE REGISTROS NOS CAMPOS DE ENDERECO
    VQTLOGRADOURO  NUMBER := 40;
    VQTCOMPLEMENTO NUMBER := 10;
    pSEPARADOR_ENDERECO_NUMERO varchar2(5);
  BEGIN
  
--  dbms_output.enable(null);
  dbms_output.disable;
  
    pSEPARADOR_ENDERECO_NUMERO := f_ti_parametro_integracao('SEPARADOR_ENDERECO_NUMERO');

dbms_output.put_line('p1');

    FOR L_INTEGRA_CLIFOR IN C_INTEGRA_CLIFOR LOOP
dbms_output.put_line('p2');
      BEGIN
        PCDSITUACAO := 'RC';

        FOR TC IN (SELECT COD_ORG_EMIS_ID_ESTAD,
                          DAT_NASCIMENTO,
                          COD_ID_FEDER_NASC,
                          NOM_NACIONALIDADE,
                          IND_ESTADO_CIVIL,
                          COD_CX_POST,
                          NOM_HOME_PAGE,
                          DAT_IMPL_CLIEN,
                          COD_DIGITO_CTA_CORREN,
                          COD_TIP_FLUXO_FINANC,
                          NUM_DIAS_ATRASO_AVDEB,
                          DAT_PROCESSAMENTO,
                          CDSITUACAO,
                          --          nm_arq_retorno,
                          COD_EMPRESA,
                          COD_ID_FEDER_JURID,
                          RPAD(NVL(TRIM(COD_CEP_COBR),
                                   F_TI_PARAMETRO_INTEGRACAO('NRCEP_DEFAULT_INCLUSAO')),
                               8,
                               '0') COD_CEP_COBR,
                          DEST_ANOT_TABELA,
                          COD_CART_BCIA_PREFER,
                          IND_TIPO_PESSOA,
                          COD_ID_FEDER_MATRIZ,
                          COD_PAIS_NASC,
                          -- Josias 29-06-2014
                          -- estava estourando o nome da mae com mais de 40 posições
                          NOM_MAE,
                          NOM_PROFISSAO,
                          NOM_CIDADE,
                          -- josias 29-06-2014
                          RPAD(NVL(TRIM(COD_CEP),
                                   F_TI_PARAMETRO_INTEGRACAO('NRCEP_DEFAULT_INCLUSAO')),
                               8,
                               '0') COD_CEP,
                          COD_TELEFONE_1,
                          COD_TELEFONE_3,
                          COD_FAX,
                          NOM_BAIRRO_COBR,
                          COD_UNID_FEDER_COBR,
                          COD_GRP_CLIEN,
                          COD_PORTAD_PREFER,
                          COD_CTA_CORREN_BCO,
                          COD_BANCO,
                          LOG_CALC_MULTA,
                          IND_OCORRENCIA,
                          NRSEQ_CONTROLE_INTEGRACAO,
                          COD_CLIENTE,
                          NOM_CLIENTE,
                          NOM_ABREV,
                          COD_ID_FEDER_ESTAD_JURID,
                          COD_ID_PREVID_SOCIAL,
                          LOG_FINS_LUCRAT,
                          COD_ID_ESTAD_FISIC,
                          COD_ID_FEDER_EMIS_ESTAD,
                          NOM_BAIRRO,
                          COD_UNID_FEDER,
                          COD_TELEFONE_2,
                          COD_RAMAL_FAX,
                          NOM_ENDER_COMPL_COBR,
                          NOM_CIDADE_COBR,
                          COD_CX_POST_COBR,
                          COD_TIP_CLIEN,
                          COD_ID_FEDER,
                          NOM_ENDER_COMPL,
                          COD_DIGITO_AGENC_BCIA,
                          COD_ACAO,
                          NOM_ENDERECO,
                          NRIMOVEL, -- PASSEI A TRAZER O NUMERO DO IMOVEL SEPARADO DO NOM_ENDERECO
                          NOM_ENDERECO_COBR,
                          NRIMOVEL_COBR,
                          COD_AGENC_BCIA,
                          COD_E_MAIL,
                          COD_ID_MUNIC_JURID,
                          NRSEQ_FAVORECIDO,
                          NRPESSOA
                     FROM V_TI_CLIENTE
                    WHERE NRSEQ_CONTROLE_INTEGRACAO =
                          L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO) LOOP

dbms_output.put_line('p3' || ';' || L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO);
dbms_output.put_line(
tc.COD_ORG_EMIS_ID_ESTAD||
tc.DAT_NASCIMENTO||
tc.COD_ID_FEDER_NASC||
tc.NOM_NACIONALIDADE||
tc.IND_ESTADO_CIVIL||
tc.COD_CX_POST||
tc.NOM_HOME_PAGE||
tc.DAT_IMPL_CLIEN||
tc.COD_DIGITO_CTA_CORREN||
tc.COD_TIP_FLUXO_FINANC||
tc.NUM_DIAS_ATRASO_AVDEB||
tc.DAT_PROCESSAMENTO||
tc.CDSITUACAO||
tc.COD_EMPRESA||
tc.COD_ID_FEDER_JURID||
tc.COD_CEP_COBR||
--tc.DEST_ANOT_TABELA||
tc.COD_CART_BCIA_PREFER||
tc.IND_TIPO_PESSOA||
tc.COD_ID_FEDER_MATRIZ||
tc.COD_PAIS_NASC||
tc.NOM_MAE||
tc.NOM_PROFISSAO||
tc.NOM_CIDADE||
tc.COD_CEP||
tc.COD_TELEFONE_1||
tc.COD_TELEFONE_3||
tc.COD_FAX||
tc.NOM_BAIRRO_COBR||
tc.COD_UNID_FEDER_COBR||
tc.COD_GRP_CLIEN||
tc.COD_PORTAD_PREFER||
tc.COD_CTA_CORREN_BCO||
tc.COD_BANCO||
tc.LOG_CALC_MULTA||
tc.IND_OCORRENCIA||
tc.NRSEQ_CONTROLE_INTEGRACAO||
tc.COD_CLIENTE||
tc.NOM_CLIENTE||
tc.NOM_ABREV||
tc.COD_ID_FEDER_ESTAD_JURID||
tc.COD_ID_PREVID_SOCIAL||
tc.LOG_FINS_LUCRAT||
tc.COD_ID_ESTAD_FISIC||
tc.COD_ID_FEDER_EMIS_ESTAD||
tc.NOM_BAIRRO||
tc.COD_UNID_FEDER||
tc.COD_TELEFONE_2||
tc.COD_RAMAL_FAX||
tc.NOM_ENDER_COMPL_COBR||
tc.NOM_CIDADE_COBR||
tc.COD_CX_POST_COBR||
tc.COD_TIP_CLIEN||
tc.COD_ID_FEDER||
tc.NOM_ENDER_COMPL||
tc.COD_DIGITO_AGENC_BCIA||
tc.COD_ACAO||
tc.NOM_ENDERECO||
tc.NOM_ENDERECO_COBR||
tc.NRIMOVEL||
tc.NRIMOVEL_COBR||
tc.COD_AGENC_BCIA||
tc.COD_E_MAIL||
tc.COD_ID_MUNIC_JURID||
tc.NRSEQ_FAVORECIDO||
tc.NRPESSOA
);

          --QTDE E CONTEUDOS DO ENDERECO
          VQTLOGRA             := LENGTH(TRIM(TC.NOM_ENDERECO));
          VQTCOMPL             := LENGTH(TRIM(TC.NOM_ENDER_COMPL));
          VQTLOGRA_REDUZ       := LENGTH(TRIM(F_REDUZ_END(TC.NOM_ENDERECO,
                                                          0)));
          VQTCOMPL_REDUZ       := LENGTH(TRIM(F_REDUZ_COMPL(TC.NOM_ENDER_COMPL,
                                                            0)));
          VQTLOGRA_REDUZ_ABREV := LENGTH(TRIM(F_REDUZ_END_ABREV(F_REDUZ_END(TC.NOM_ENDERECO,
                                                                            0),
                                                                0)));
          VQTNRIMOVEL          := LENGTH(TC.NRIMOVEL) + length(nvl(pSEPARADOR_ENDERECO_NUMERO,', ')); /*tamanho do separador, que pode ser (,) (, ) etc*/
          VLOGRA               := TRIM(TC.NOM_ENDERECO);
          VCOMPL               := NVL(TRIM(TC.NOM_ENDER_COMPL), ' ');
          VLOGRA_REDUZ         := TRIM(F_REDUZ_END(TC.NOM_ENDERECO, 0));
          VCOMPL_REDUZ         := TRIM(F_REDUZ_COMPL(TC.NOM_ENDER_COMPL, 0));
          VLOGRA_REDUZ_ABREV   := TRIM(F_REDUZ_END_ABREV(F_REDUZ_END(TC.NOM_ENDERECO,0),0));

          --TRATATIVA DOS ENDEÇOES E LOGRADOUROS (21/10/2016)
          --COMPLEMENTO NULO OU ATÉ 10 E O LOGRADOURO + NRIMOVEL ATÉ 40
          --LINHAS 1 E 2 DA PLANILHA
          IF ((VCOMPL IS NULL OR LENGTH(VCOMPL) <= VQTCOMPLEMENTO) AND
             VQTLOGRA + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA;
            ELSE
              VLOGRADOURO := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL;
            END IF;

            VCOMPLEMENTO := VCOMPL;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '1', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DAS LINHAS 1 E 2
            --LOGRADOURO+NRIMOVEL ACIMA DE 40, PORÉM LOGRAD+IMOVEL REDUZ ATÉ 40 E O COMPLEMENTO ATÉ 10
            --LINHA 3 DA PLANILHA
          ELSIF (((VQTCOMPL <= VQTCOMPLEMENTO) OR (VQTCOMPL IS NULL)) AND
                VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA_REDUZ;
            ELSE
              VLOGRADOURO := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL;
            END IF;

            VCOMPLEMENTO := VCOMPL;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '3', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 3
            --COMPLEMENTO ACIMA DE 10, PORÉM COMPL REDUZ ATÉ 10 E O LOGRADOURO + NRIMOVEL ATÉ 40
            --LINHA 4 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
                VQTLOGRA + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA;
            ELSE
              VLOGRADOURO := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL;
            END IF;

            VCOMPLEMENTO := VCOMPL_REDUZ;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '4', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 4
            --COMPLEMENTO ACIMA DE 10, PORÉM COMPL REDUZ ATÉ 10 E O LOGRADOURO + NRIMOVEL ACIMA DE 40, PORÉM LOGR+IMOVEL REDUZ ATÉ 40
            --LINHA 5 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA_REDUZ;
            ELSE
              VLOGRADOURO := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL;
            END IF;

            VCOMPLEMENTO := VCOMPL_REDUZ;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '5', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 5

            --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO + NRIMOVEL ATE 40
            --LINHA 6 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA || '-' || VCOMPL_REDUZ;
            ELSE
              VLOGRADOURO := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL || '-' ||
                             VCOMPL_REDUZ;
            END IF;

            VCOMPLEMENTO := ' ';

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '6', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 6
            --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO REDUZ + NRIMOVEL ATE 40
            --LINHA 7 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) + 1 +
                VQTCOMPL_REDUZ <= VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA_REDUZ || '-' || VCOMPL_REDUZ;
            ELSE
              VLOGRADOURO := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL || '-' ||
                             VCOMPL_REDUZ;
            END IF;

            VCOMPLEMENTO := ' ';

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '7', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 7
            --COMPLEMENTO NULO OU ATÉ 10, LOGR REDUZ + NR ACIMA DE 40, PORÉM LOGRADOURO REDUZ E ABREV + NRIMOVEL ATE 40
            --LINHA 8 DA PLANILHA
          ELSIF ((VQTCOMPL <= VQTCOMPLEMENTO OR VCOMPL IS NULL) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA_REDUZ_ABREV;
            ELSE
              VLOGRADOURO := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL;
            END IF;

            VCOMPLEMENTO := VCOMPL;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 8

            --COMPLEMENTO ACIMA DE 10, PORÉM REDUZ ATÉ 10 E LOGR REDUZ + NR ACIMA DE 40, PORÉM LOGRADOURO REDUZ E ABREV + NRIMOVEL ATE 40
            --LINHA 9 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA_REDUZ_ABREV;
            ELSE
              VLOGRADOURO := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL;
            END IF;

            VCOMPLEMENTO := VCOMPL_REDUZ;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 9

            --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO REDUZ E ABREVIADO (ÚLTIMO RECURSO) + NRIMOVEL ATE 40
            --LINHA 10 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) + 1 +
                VQTCOMPL_REDUZ > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) + 1 +
                VQTCOMPL_REDUZ <= VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := VLOGRA_REDUZ_ABREV || '-' || VCOMPL_REDUZ;
            ELSE
              VLOGRADOURO := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL || '-' ||
                             VCOMPL_REDUZ;
            END IF;

            VCOMPLEMENTO := ' ';

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 10
          else
            --*****ver se ficará
            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '0', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --SE NAO CONSEGUIU ABREVIAR, TRUNCA 1AS 40 POSICOES DO LOGRADOURO ABREVIADO E 1AS 10 DO COMPLEMENTO
            
            IF TC.NRIMOVEL IS NULL THEN
              VLOGRADOURO := SUBSTR(VLOGRA_REDUZ_ABREV,1,40);
            else
              --concatena numero no inicio pois a parte final do logradouro sera truncada
              vlogradouro := substr(tc.nrimovel || ' ' || VLOGRA_REDUZ_ABREV,1,40);
            end if;
            
            VCOMPLEMENTO := substr(VCOMPL_REDUZ,1,10);
            

            /*   -- ERRO - NAO ENTROU EM NENHUM DOS IFS ACIMA
                ELSIF ((LENGTH(TENDERECO.TXCOMPLEMENTO) > VQTCOMPLEMENTO AND LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0))> VQTCOMPLEMENTO) AND
                     ((LENGTH(TRIM(TENDERECO.NOLOGRADOURO)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO) AND
                     ((LENGTH(F_REDUZ_END(TRIM(TENDERECO.NOLOGRADOURO),0)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO) AND
                     ((LENGTH(F_REDUZ_END_ABREV(F_REDUZ_END(TRIM(TENDERECO.NOLOGRADOURO),0),0)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO)
                     ) THEN

                  -- VER COM O VINI PARA GRAVAR FALHA NO PROCESSO
                  VLOGRADOURO  := NULL;
                  VCOMPLEMENTO := NULL;

                  INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '9', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);
            */
          END IF;

          --VALIDACAO DO TAMANHO DO BAIRRO
          --SE NAO ENVIAR O BAIRRO COMPLETO, TENTA O REDUZIDO E POR ÚLTIMO TRUNCA
          VBAIRRO := '';

          IF LENGTH(TC.NOM_BAIRRO) > 20 THEN
            IF LENGTH(f_reduz_bairro(TC.NOM_BAIRRO, 0)) > 20 THEN
              VBAIRRO := SUBSTR(F_REDUZ_BAIRRO(TC.NOM_BAIRRO, 0), 1, 20); --20 POSICOES DO REDUZIDO
            ELSE
              VBAIRRO := f_reduz_bairro(TC.NOM_BAIRRO, 0); -- BAIRRO REDUZIDO
            END IF;
          ELSE
            VBAIRRO := TC.NOM_BAIRRO; -- BAIRRO INTEIRO
          END IF;

          --INSERT INTO END_MIGRA VALUES (VBAIRRO,NULL,TENDERECO.NOBAIRRO,NULL,NULL,NULL,TENDERECO.NRREGISTRO);

          --FINAL DA VERIFICACAO E TRATAMENTO DO ENDERECO

          --TRATAMENTO DO ENDERECO DE COBRANÇA
          --QTDE E CONTEUDOS DO ENDERECO
          VQTLOGRA             := LENGTH(TRIM(TC.NOM_ENDERECO_COBR));
          VQTCOMPL             := LENGTH(TRIM(TC.NOM_ENDER_COMPL_COBR));
          VQTLOGRA_REDUZ       := LENGTH(TRIM(F_REDUZ_END(TC.NOM_ENDERECO_COBR,
                                                          0)));
          VQTCOMPL_REDUZ       := LENGTH(TRIM(F_REDUZ_COMPL(TC.NOM_ENDER_COMPL_COBR,
                                                            0)));
          VQTLOGRA_REDUZ_ABREV := LENGTH(TRIM(F_REDUZ_END_ABREV(F_REDUZ_END(TC.NOM_ENDERECO_COBR,
                                                                            0),
                                                                0)));
          VQTNRIMOVEL          := LENGTH(TC.NRIMOVEL_COBR) + length(nvl(pSEPARADOR_ENDERECO_NUMERO,', '));
          VLOGRA               := TRIM(TC.NOM_ENDERECO_COBR);
          VCOMPL               := NVL(TRIM(TC.NOM_ENDER_COMPL_COBR), ' ');
          VLOGRA_REDUZ         := TRIM(F_REDUZ_END(TC.NOM_ENDERECO_COBR, 0));
          VCOMPL_REDUZ         := TRIM(F_REDUZ_COMPL(TC.NOM_ENDER_COMPL_COBR,
                                                     0));
          VLOGRA_REDUZ_ABREV   := TRIM(F_REDUZ_END_ABREV(F_REDUZ_END(TC.NOM_ENDERECO_COBR,
                                                                     0),
                                                         0));

          --TRATATIVA DOS ENDEÇOES E LOGRADOUROS (21/10/2016)
          --COMPLEMENTO NULO OU ATÉ 10 E O LOGRADOURO + NRIMOVEL ATÉ 40
          --LINHAS 1 E 2 DA PLANILHA
          IF ((VCOMPL IS NULL OR LENGTH(VCOMPL) <= VQTCOMPLEMENTO) AND
             VQTLOGRA + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA;
            ELSE
              VLOGRADOURO_COBR := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL_COBR;
            END IF;

            VCOMPLEMENTO_COBR := VCOMPL;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '1', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DAS LINHAS 1 E 2
            --LOGRADOURO+NRIMOVEL ACIMA DE 40, PORÉM LOGRAD+IMOVEL REDUZ ATÉ 40 E O COMPLEMENTO ATÉ 10
            --LINHA 3 DA PLANILHA
          ELSIF (((VQTCOMPL <= VQTCOMPLEMENTO) OR (VQTCOMPL IS NULL)) AND
                VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA_REDUZ;
            ELSE
              VLOGRADOURO_COBR := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL_COBR;
            END IF;

            VCOMPLEMENTO_COBR := VCOMPL;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '3', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 3
            --COMPLEMENTO ACIMA DE 10, PORÉM COMPL REDUZ ATÉ 10 E O LOGRADOURO + NRIMOVEL ATÉ 40
            --LINHA 4 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
                VQTLOGRA + NVL((VQTNRIMOVEL), 0) <= VQTLOGRADOURO) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA;
            ELSE
              VLOGRADOURO_COBR := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL_COBR;
            END IF;

            VCOMPLEMENTO_COBR := VCOMPL_REDUZ;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '4', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 4
            --COMPLEMENTO ACIMA DE 10, PORÉM COMPL REDUZ ATÉ 10 E O LOGRADOURO + NRIMOVEL ACIMA DE 40, PORÉM LOGR+IMOVEL REDUZ ATÉ 40
            --LINHA 5 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA_REDUZ;
            ELSE
              VLOGRADOURO_COBR := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL_COBR;
            END IF;

            VCOMPLEMENTO_COBR := VCOMPL_REDUZ;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '5', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 5

            --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO + NRIMOVEL ATE 40
            --LINHA 6 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA || '-' || VCOMPL_REDUZ;
            ELSE
              VLOGRADOURO_COBR := VLOGRA || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL_COBR || '-' ||
                                  VCOMPL_REDUZ;
            END IF;

            VCOMPLEMENTO_COBR := ' ';

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '6', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 6
            --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO REDUZ + NRIMOVEL ATE 40
            --LINHA 7 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) + 1 +
                VQTCOMPL_REDUZ <= VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA_REDUZ || '-' || VCOMPL_REDUZ;
            ELSE
              VLOGRADOURO_COBR := VLOGRA_REDUZ || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') || TC.NRIMOVEL_COBR || '-' ||
                                  VCOMPL_REDUZ;
            END IF;

            VCOMPLEMENTO_COBR := ' ';

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '7', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 7
            --COMPLEMENTO NULO OU ATÉ 10, LOGR REDUZ + NR ACIMA DE 40, PORÉM LOGRADOURO REDUZ E ABREV + NRIMOVEL ATE 40
            --LINHA 8 DA PLANILHA
          ELSIF ((VQTCOMPL <= VQTCOMPLEMENTO OR VCOMPL IS NULL) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA_REDUZ_ABREV;
            ELSE
              VLOGRADOURO_COBR := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') ||
                                  TC.NRIMOVEL_COBR;
            END IF;

            VCOMPLEMENTO_COBR := VCOMPL;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 8

            --COMPLEMENTO ACIMA DE 10, PORÉM REDUZ ATÉ 10 E LOGR REDUZ + NR ACIMA DE 40, PORÉM LOGRADOURO REDUZ E ABREV + NRIMOVEL ATE 40
            --LINHA 9 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ <= VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) <=
                VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA_REDUZ_ABREV;
            ELSE
              VLOGRADOURO_COBR := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') ||
                                  TC.NRIMOVEL_COBR;
            END IF;

            VCOMPLEMENTO_COBR := VCOMPL_REDUZ;

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 9
            --COMPLEMENTO REDUZ ACIMA DE 10, PORÉM COMPL REDUZ E O LOGRADOURO REDUZ E ABREVIADO (ÚLTIMO RECURSO) + NRIMOVEL ATE 40
            --LINHA 10 DA PLANILHA
          ELSIF ((VQTCOMPL > VQTCOMPLEMENTO AND
                VQTCOMPL_REDUZ > VQTCOMPLEMENTO) AND
                (VQTLOGRA + NVL((VQTNRIMOVEL), 0) + 1 + VQTCOMPL_REDUZ >
                VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ + NVL((VQTNRIMOVEL), 0) + 1 +
                VQTCOMPL_REDUZ > VQTLOGRADOURO) AND
                (VQTLOGRA_REDUZ_ABREV + NVL((VQTNRIMOVEL), 0) + 1 +
                VQTCOMPL_REDUZ <= VQTLOGRADOURO)) THEN

            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := VLOGRA_REDUZ_ABREV || '-' || VCOMPL_REDUZ;
            ELSE
              VLOGRADOURO_COBR := VLOGRA_REDUZ_ABREV || nvl(pSEPARADOR_ENDERECO_NUMERO,', ') ||
                                  TC.NRIMOVEL_COBR || '-' || VCOMPL_REDUZ;
            END IF;

            VCOMPLEMENTO_COBR := ' ';

            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '8', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --FIM DA TRATATIVA DA LINHA 10
          else
            --*****ver se ficará
            --INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '0', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);

            --se nao conseguiu abreviar, vai truncar 1as 40 posicoes do logradouro e 1as 10 do complemento
            IF TC.NRIMOVEL_COBR IS NULL THEN
              VLOGRADOURO_COBR := SUBSTR(VLOGRA_REDUZ_ABREV,1,40);
            else
              --concatena numero no inicio pois a parte final do logradouro sera truncada
              VLOGRADOURO_COBR := substr(tc.nrimovel_COBR || ' ' || VLOGRA_REDUZ_ABREV,1,40);
            end if;
            
            VCOMPLEMENTO_COBR := substr(VCOMPL_REDUZ,1,10);

            /*   -- ERRO - NAO ENTROU EM NENHUM DOS IFS ACIMA
                ELSIF ((LENGTH(TENDERECO.TXCOMPLEMENTO) > VQTCOMPLEMENTO AND LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0))> VQTCOMPLEMENTO) AND
                     ((LENGTH(TRIM(TENDERECO.NOLOGRADOURO)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO) AND
                     ((LENGTH(F_REDUZ_END(TRIM(TENDERECO.NOLOGRADOURO),0)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO) AND
                     ((LENGTH(F_REDUZ_END_ABREV(F_REDUZ_END(TRIM(TENDERECO.NOLOGRADOURO),0),0)))+ NVL((VQTNRIMOVEL + 1),0) +1+ LENGTH(f_reduz_compl(TENDERECO.TXCOMPLEMENTO,0)) > VQTLOGRADOURO)
                     ) THEN

                  -- VER COM O VINI PARA GRAVAR FALHA NO PROCESSO
                  VLOGRADOURO  := NULL;
                  VCOMPLEMENTO := NULL;

                  INSERT INTO END_MIGRA VALUES (TENDERECO.NOLOGRADOURO, TENDERECO.TXCOMPLEMENTO, VLOGRADOURO, VCOMPLEMENTO, '9', TENDERECO.NRIMOVEL, TENDERECO.NRREGISTRO);
            */
          END IF;

          --VALIDACAO DO TAMANHO DO BAIRRO
          --SE NAO ENVIAR O BAIRRO COMPLETO, TENTA O REDUZIDO E POR ÚLTIMO TRUNCA
          VBAIRRO_COBR := '';

          IF LENGTH(TC.NOM_BAIRRO_COBR) > 20 THEN
            IF LENGTH(f_reduz_bairro(TC.NOM_BAIRRO_COBR, 0)) > 20 THEN
              VBAIRRO_COBR := SUBSTR(F_REDUZ_BAIRRO(TC.NOM_BAIRRO_COBR, 0),
                                     1,
                                     20); --20 POSICOES DO REDUZIDO
            ELSE
              VBAIRRO_COBR := f_reduz_bairro(TC.NOM_BAIRRO_COBR, 0); -- BAIRRO REDUZIDO
            END IF;
          ELSE
            VBAIRRO_COBR := TC.NOM_BAIRRO_COBR; -- BAIRRO INTEIRO
          END IF;

          --INSERT INTO END_MIGRA VALUES (VBAIRRO,NULL,TENDERECO.NOBAIRRO,NULL,NULL,NULL,TENDERECO.NRREGISTRO);

          --FINAL DA VERIFICACAO E TRATAMENTO DO ENDERECO

          nrregistro_aux := tc.nrpessoa;

dbms_output.put_line(TC.NRSEQ_CONTROLE_INTEGRACAO || ';' ||
                     TC.COD_CLIENTE || ';' ||
                     TC.NOM_CLIENTE || ';' ||
                     tc.nrpessoa);

          INSERT INTO TI_CLIENTE
            (COD_ORG_EMIS_ID_ESTAD, --1
             DAT_NASCIMENTO, --2
             COD_ID_FEDER_NASC,
             NOM_NACIONALIDADE,
             IND_ESTADO_CIVIL,
             COD_CX_POST,
             NOM_HOME_PAGE,
             DAT_IMPL_CLIEN,
             COD_TIP_FLUXO_FINANC,
             NUM_DIAS_ATRASO_AVDEB,--10
             DAT_PROCESSAMENTO,
             CDSITUACAO,
             COD_EMPRESA,
             COD_ID_FEDER_JURID,
             COD_CEP_COBR, --15
             DEST_ANOT_TABELA,
             COD_CART_BCIA_PREFER,
             IND_TIPO_PESSOA, --18
             COD_ID_FEDER_MATRIZ,
             COD_PAIS_NASC,
             NOM_MAE,
             NOM_PROFISSAO,
             NOM_CIDADE, --23
             COD_CEP, --24
             COD_TELEFONE_1,
             COD_TELEFONE_3,
             COD_FAX,
             NOM_BAIRRO_COBR, --28
             COD_UNID_FEDER_COBR, --29
             COD_GRP_CLIEN,
             COD_PORTAD_PREFER,
             LOG_CALC_MULTA,
             IND_OCORRENCIA,
             NRSEQ_CONTROLE_INTEGRACAO,
             COD_CLIENTE,
             NOM_CLIENTE, --36
             NOM_ABREV,
             COD_ID_FEDER_ESTAD_JURID,
             COD_ID_PREVID_SOCIAL,
             LOG_FINS_LUCRAT,--40
             COD_ID_ESTAD_FISIC,
             COD_ID_FEDER_EMIS_ESTAD,
             NOM_BAIRRO, --43
             COD_UNID_FEDER, --44
             COD_TELEFONE_2,
             COD_RAMAL_FAX, --46
             NOM_ENDER_COMPL_COBR, --47
             NOM_CIDADE_COBR, --48
             COD_CX_POST_COBR,
             COD_TIP_CLIEN,--50
             COD_ID_FEDER,
             NOM_ENDER_COMPL, --52
             COD_ACAO,
             NOM_ENDERECO, --54
             NOM_ENDERECO_COBR, --55
             COD_E_MAIL,
             COD_ID_MUNIC_JURID,
             NRSEQ_FAVORECIDO,
             NRPESSOA,
             COD_BANCO,--60
             COD_AGENC_BCIA,
             COD_DIGITO_AGENC_BCIA,
             COD_CTA_CORREN_BCO,
             COD_DIGITO_CTA_CORREN --64

             )
          VALUES
            (

             TC.COD_ORG_EMIS_ID_ESTAD, --1
             TC.DAT_NASCIMENTO,
             TC.COD_ID_FEDER_NASC,
             TC.NOM_NACIONALIDADE,
             TC.IND_ESTADO_CIVIL,
             TC.COD_CX_POST,
             TC.NOM_HOME_PAGE,
             TC.DAT_IMPL_CLIEN,
             TC.COD_TIP_FLUXO_FINANC, --9
             TC.NUM_DIAS_ATRASO_AVDEB,--10
             TC.DAT_PROCESSAMENTO,
             TC.CDSITUACAO,--12
             --          nm_arq_retorno,
             TC.COD_EMPRESA,
             TC.COD_ID_FEDER_JURID,
             RPAD(NVL(TRIM(TC.COD_CEP_COBR),
                      F_TI_PARAMETRO_INTEGRACAO('NRCEP_DEFAULT_INCLUSAO')),
                  8,
                  '0'),--15
             TC.DEST_ANOT_TABELA,
             TC.COD_CART_BCIA_PREFER,
             TC.IND_TIPO_PESSOA,
             TC.COD_ID_FEDER_MATRIZ,
             TC.COD_PAIS_NASC, --20
             -- Josias 29-06-2014
             -- estava estourando o nome da mae com mais de 40 posições
             TC.NOM_MAE,
             TC.NOM_PROFISSAO,
             NVL(TC.NOM_CIDADE, ' '),
             -- josias 29-06-2014
             RPAD(NVL(TRIM(TC.COD_CEP),
                      F_TI_PARAMETRO_INTEGRACAO('NRCEP_DEFAULT_INCLUSAO')),
                  8,
                  '0'),--24
             TC.COD_TELEFONE_1,
             TC.COD_TELEFONE_3,
             TC.COD_FAX,
             NVL(VBAIRRO_COBR, ' '), --TC.NOM_BAIRRO_COBR,
             TC.COD_UNID_FEDER_COBR,
             TC.COD_GRP_CLIEN,--30
             TC.COD_PORTAD_PREFER,
             TC.LOG_CALC_MULTA,
             TC.IND_OCORRENCIA,
             TC.NRSEQ_CONTROLE_INTEGRACAO,
             TC.COD_CLIENTE,
             TC.NOM_CLIENTE,
             TC.NOM_ABREV,
             TC.COD_ID_FEDER_ESTAD_JURID,
             TC.COD_ID_PREVID_SOCIAL,
             TC.LOG_FINS_LUCRAT,--40
             TC.COD_ID_ESTAD_FISIC,
             TC.COD_ID_FEDER_EMIS_ESTAD,
             NVL(VBAIRRO, ' '), --TC.NOM_BAIRRO,
             TC.COD_UNID_FEDER,
             TC.COD_TELEFONE_2,
             TC.COD_RAMAL_FAX,
             NVL(VCOMPLEMENTO_COBR, ' '), --TC.NOM_ENDER_COMPL_COBR,
             NVL(TC.NOM_CIDADE_COBR, ' '),
             TC.COD_CX_POST_COBR,
             TC.COD_TIP_CLIEN,--50
             TC.COD_ID_FEDER,
             NVL(VCOMPLEMENTO, ' '), --TC.NOM_ENDER_COMPL,
             TC.COD_ACAO,
             NVL(VLOGRADOURO, ' '), --54    TC.NOM_ENDERECO,
             NVL(VLOGRADOURO_COBR, ' '), --TC.NOM_ENDERECO_COBR,
             TC.COD_E_MAIL,
             TC.COD_ID_MUNIC_JURID,
             TC.NRSEQ_FAVORECIDO,
             TC.NRPESSOA,
             TC.COD_BANCO,--60
             CASE WHEN TC.COD_BANCO = ' ' THEN ' ' WHEN
             INSTR(TC.COD_AGENC_BCIA, '-') > 0 THEN
             SUBSTR(LPAD(F_DEFINIR_NUMERICO(SUBSTR(TC.COD_AGENC_BCIA,
                                                   1,
                                                   INSTR(TC.COD_AGENC_BCIA,
                                                         '-') - 1)),
                         F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'A'),
                         '0'),
                    1,
                    F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'A')) ELSE
             SUBSTR(LPAD(F_DEFINIR_NUMERICO(TC.COD_AGENC_BCIA),
                         F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'A'),
                         '0'),
                    1,
                    F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'A')) END, --61    COD_AGENC_BCIA
                    
             CASE WHEN TC.COD_BANCO = ' ' THEN ' ' 
                  WHEN INSTR(TC.COD_AGENC_BCIA, '-') > 0 THEN
                       to_char(F_DEFINIR_NUMERICO(decode(upper(SUBSTR(TC.COD_AGENC_BCIA, INSTR(TC.COD_AGENC_BCIA, '-') + 1, 1)),'X','0',
                       SUBSTR(TC.COD_AGENC_BCIA, INSTR(TC.COD_AGENC_BCIA, '-') + 1, 1))))
                  ELSE ' ' 
             END, --62    COD_DIGITO_AGENC_BCIA
             
             CASE WHEN TC.COD_BANCO = ' ' THEN ' ' WHEN
              INSTR(TC.COD_CTA_CORREN_BCO, '-') > 0 THEN
              SUBSTR(LPAD(F_DEFINIR_NUMERICO(SUBSTR(TC.COD_CTA_CORREN_BCO,
                                                    1,
                                                    INSTR(TC.COD_CTA_CORREN_BCO,
                                                          '-') - 1)),
                          F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'C'),
                          '0'),
                     1,
                     F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'C')) ELSE
             --                                        substr(t.nrconta_bancaria,1, f_ret_masc_banco(lpad(t.nrbanco,3,'0'),'C'))
              SUBSTR(LPAD(F_DEFINIR_NUMERICO(TC.COD_CTA_CORREN_BCO),
                          F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'C'),
                          '0'),
                     1,
                     F_RET_MASC_BANCO(LPAD(TC.COD_BANCO, 3, '0'), 'C')) END, -- 63    COD_CTA_CORREN_BCO
             CASE WHEN TC.COD_BANCO = ' ' THEN ' ' 
                  WHEN INSTR(TC.COD_CTA_CORREN_BCO, '-') > 0 
                       THEN to_char(F_DEFINIR_NUMERICO(decode(upper(SUBSTR(TC.COD_CTA_CORREN_BCO, INSTR(TC.COD_CTA_CORREN_BCO, '-') + 1,1)),'X','0',
                            SUBSTR(TC.COD_CTA_CORREN_BCO, INSTR(TC.COD_CTA_CORREN_BCO, '-') + 1,1))))
                  ELSE ' ' END --64   COD_DIGITO_CTA_CORREN
             );
             
          insere_hash('CL',
                      L_INTEGRA_CLIFOR.NRPESSOA,
                      L_INTEGRA_CLIFOR.CDIDENTIFICADOR);
             
        END LOOP;

        IF SQL%ROWCOUNT = 0 THEN
          P_TI_VALIDA_ENDERECO(L_INTEGRA_CLIFOR.NRPESSOA,
                               L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                               'TI_CLIENTE',
                               PCDSITUACAO);
          IF PCDSITUACAO = 'RC' THEN
            P_GRAVA_FALHA(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                          'TI_CLIENTE',
                          'Dados no encontrados na V_ti_cliente PARA O PROCESSO',
                          NULL,
                          PCDSITUACAO,
                          NULL);
          END IF;
        END IF;

        P_COMMIT;

      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
/*
    14/01/19 - Alex Boeira - comentado pois causava a falha quando um cliente possui mais de um endereco
          P_GRAVA_FALHA(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                        'TI_CLIENTE',
                        'O cliente relacionado à pessoa ' || nrregistro_aux || ' ja foi enviado para a TI_CLIENTE',
                        SQLERRM,
                        PCDSITUACAO,
                        -1);
*/                        NULL;
        WHEN OTHERS THEN
          BEGIN
            P_GRAVA_FALHA(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                          'TI_CLIENTE',
                          SQLERRM,
                          NULL,
                          PCDSITUACAO,
                          NULL);
          END;
      END;
      --====================================--
      -- Atualizar o situao da integrao --
      ----------------------------------------
      P_UPDATE_CONTROLE_INTEGRACAO(L_INTEGRA_CLIFOR.NRSEQ_CONTROLE_INTEGRACAO,
                                   PCDSITUACAO,
                                   NULL);
    END LOOP;
  END;

  PROCEDURE P_GERAR_DADOS_BANC_FORNEC(VP_COD_EMPRESA IN NUMBER) IS
    /*
    ***************************************************************************************************************
    Criacão          : Josias Rodrigues
    Data             : -
    Modulo Principal : Integracão EMS5
    Modulos          : -
    Objetivo         : Gerar os dados bancários do Fornecedor Unicoo para o EMS5
    Alteracoes
    +------------------------------------------------------------------------------------------------------------------------------------------+
    | DATA       | RESPONSAVEL   | VERSAO        | PENDENCIA | ALTERACAO                                                                       |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    | 25/09/2014 | JOSIAS        |               |           | Criação do Objeto                                                                  |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    */
  BEGIN
    DECLARE
      VCDFORNEC_ANTERIOR number := 0;

      CURSOR C_ATU IS
        SELECT VP_COD_EMPRESA COD_EMPRESA,
               P.CDN_FORNECEDOR,
               LPAD(T.NRBANCO, 3, '0') COD_BANCO,
               /*REGRAS PARA MIGRACAO DE AGENCIA E CONTA BANCARIA:
                * SE O FORNECEDOR FOR TAMBEM PRESTADOR, BUSCA OS DADOS DO PRESTADOR,
                  POIS CONTA E DIGITO ESTAO SEPARADOS, ENQUANTO NO FORNECEDOR Eh APENAS 1 CAMPO.
                  CASO CONTRARIO, CONSIDERA OS DADOS DO FORNECEDOR.
                * SE TIVER '-' NO CAMPO DO UNICOO, USA ISSO COMO SEPARADOR DE AGENCIA-DIGITO / CONTA-DIGITO.
                  CASO CONTRARIO PREENCHE NA AGENCIA / CONTA E DEIXA DIGITO ZERADO.
                * SITUACOES DIVERGENTES DISSO DEVEM SER CORRIGIDAS NO UNICOO ANTES DE MIGRAR (COLOCAR O '-'
                  COMO SEPARADOR).
                */
               case--COD_AGENC_BCIA
                 when pr.nragencia is not null then
                   case
                     --SE TIVER '-' (SEPARADOR), utiliza como criterio para separar digito verificador
                     when instr(pr.nragencia,'-') > 0 then
                      SUBSTR(LPAD(F_DEFINIR_NUMERICO(nvl(SUBSTR(pr.NRAGENCIA,
                                                            1,
                                                            INSTR(pr.NRAGENCIA,
                                                                  '-') - 1),0)),
                                  F_RET_MASC_BANCO(LPAD(pr.NRBANCO, 3, '0'), 'A'),
                                  '0'),
                             1,
                             F_RET_MASC_BANCO(LPAD(pr.NRBANCO, 3, '0'), 'A'))
                     else
                      SUBSTR(LPAD(F_DEFINIR_NUMERICO(nvl(pr.NRAGENCIA,0)),
                                       F_RET_MASC_BANCO(LPAD(pr.NRBANCO, 3, '0'), 'A'),
                                       '0'),
                                  1,
                                  F_RET_MASC_BANCO(LPAD(pr.NRBANCO, 3, '0'), 'A'))
                   end                          
                 else    
                   CASE
                     --SE TIVER '-' (SEPARADOR), utiliza como criterio para separar digito verificador
                     WHEN INSTR(T.NRAGENCIA, '-') > 0 THEN
                       SUBSTR(LPAD(F_DEFINIR_NUMERICO(nvl(SUBSTR(T.NRAGENCIA,
                                                        1,
                                                        INSTR(T.NRAGENCIA,
                                                              '-') - 1),0)),
                              F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'A'),
                              '0'),
                         1,
                         F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'A'))
                     ELSE
                       SUBSTR(LPAD(nvl(F_DEFINIR_NUMERICO(nvl(T.NRAGENCIA,0)),0),
                                   F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'A'),
                                   '0'),
                                  1,
                                  F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'A'))
                   end
               END COD_AGENC_BCIA,
               
               CASE--COD_DIGITO_AGENC_BCIA
                 when pr.nragencia is not null then
                   case
                     --SE TIVER '-' (SEPARADOR), utiliza como criterio para separar digito verificador
                     when instr(pr.nragencia,'-') > 0 then
                       to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(SUBSTR(pr.NRAGENCIA, INSTR(pr.NRAGENCIA, '-') + 1, 1)),'X','0',
                       SUBSTR(pr.NRAGENCIA, INSTR(pr.NRAGENCIA, '-') + 1, 1)),0)))
                     else ' '
                   end
                 else
                   case
                     WHEN INSTR(T.NRAGENCIA, '-') > 0 THEN
                       to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(SUBSTR(T.NRAGENCIA, INSTR(T.NRAGENCIA, '-') + 1, 1)),'X','0',
                       SUBSTR(T.NRAGENCIA, INSTR(T.NRAGENCIA, '-') + 1, 1)),0)))
                     ELSE ' '
                   end
               END COD_DIGITO_AGENC_BCIA,
               
               CASE--COD_CTA_CORREN_BCO
                 when pr.nrconta is not null then
                      SUBSTR(LPAD(F_DEFINIR_NUMERICO(nvl(pr.NRCONTA,0)),
                                  F_RET_MASC_BANCO(LPAD(pr.NRBANCO, 3, '0'), 'C'),
                                  '0'),
                             1,
                             F_RET_MASC_BANCO(LPAD(pr.NRBANCO, 3, '0'), 'C'))
                 else
                   case
                     --SE TIVER '-' (SEPARADOR), utiliza como criterio para separar digito verificador
                     WHEN INSTR(T.NRCONTA_BANCARIA, '-') > 0 THEN
                       SUBSTR(LPAD(F_DEFINIR_NUMERICO(nvl(SUBSTR(T.NRCONTA_BANCARIA,
                                                        1,
                                                        INSTR(T.NRCONTA_BANCARIA,
                                                              '-') - 1),0)),
                              F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'C'),
                              '0'),
                         1,
                         F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'C'))
                     ELSE
                        SUBSTR(LPAD(F_DEFINIR_NUMERICO(nvl(T.NRCONTA_BANCARIA,0)),
                                    F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'C'),
                                    '0'),
                               1,
                               F_RET_MASC_BANCO(LPAD(T.NRBANCO, 3, '0'), 'C'))
                   end
               END COD_CTA_CORREN_BCO,
               
               CASE--COD_DIGITO_CTA_CORREN
                 when pr.nrconta is not null then
                   to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(pr.nrdigito),'X','0',pr.nrdigito),0)))
                 else
                   case
                     --SE TIVER '-' (SEPARADOR), utiliza como criterio para separar digito verificador
                     WHEN INSTR(T.NRCONTA_BANCARIA, '-') > 0 THEN
                       to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(SUBSTR(T.NRCONTA_BANCARIA,INSTR(T.NRCONTA_BANCARIA, '-') + 1,1)),'X','0',
                       SUBSTR(T.NRCONTA_BANCARIA,INSTR(T.NRCONTA_BANCARIA, '-') + 1,1)),0)))
                     ELSE ' '
                   end
               END COD_DIGITO_CTA_CORREN,
               
               DECODE(T.TPCONTA,
                      'CC',
                      'CONTA CORRENTE',
                      'CA',
                      'CONTA APLICACAO',
                      'CP',
                      'CONTA POUPANCA',
                      'CX',
                      'CONTA CAIXA',
                      'TIPO DE CONTA NAO IDENTIFICADO') TPCONTA
          FROM FORNECEDOR_AGENCIA_BANCARIA         T,
               PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA F,
               TI_PESSOA                           P,
               FORNEC_FINANC                       FF,
               producao.prestador@unicoo_homologa  PR
         WHERE T.CDFORNECEDOR = F.CDFORNECEDOR
           AND F.NRREGISTRO_FORNECEDOR = P.NRREGISTRO
           AND FF.U##COD_EMPRESA = VP_COD_EMPRESA
           AND P.CDN_FORNECEDOR = FF.CDN_FORNECEDOR
           AND P.CDN_FORNECEDOR IS NOT NULL
           and pr.nrregistro_prest(+) = f.nrregistro_fornecedor
         order by t.CDFORNECEDOR,
                  DECODE(T.AOENVIO_BANCO, 'S', 'A', T.AOENVIO_BANCO), --passar antes pela conta principal
                  DECODE(T.AOCONTA_PRESTADOR, 'S', 'A', T.AOCONTA_PRESTADOR), --passar antes pelas contas de prestador
                  decode(T.tpconta, 'CC', 'AA', T.TPCONTA); --passar antes por conta corrente
    BEGIN
    
--      dbms_output.enable(null);

--      delete from cta_corren_fornec_falha; linha retirada pois estava causando lock

      FOR X IN C_ATU LOOP

--      dbms_output.put_line(x.cod_banco || ';' || x.cod_agenc_bcia || ';' || x.cod_digito_agenc_bcia || ';' || X.COD_CTA_CORREN_BCO || ';' || X.COD_DIGITO_CTA_CORREN);

        IF X.CDN_FORNECEDOR <> VCDFORNEC_ANTERIOR THEN
        
/*          dbms_output.put_line('banco: ' || nvl(X.COD_BANCO, ' '));
          dbms_output.put_line('agencia: ' || nvl(X.COD_AGENC_BCIA, ' '));
          dbms_output.put_line('dig.agencia: ' || to_char(F_DEFINIR_NUMERICO(upper(X.COD_DIGITO_AGENC_BCIA))));
          dbms_output.put_line('conta: ' || nvl(X.COD_CTA_CORREN_BCO, ' '));
          dbms_output.put_line('dig.conta: ' || to_char(F_DEFINIR_NUMERICO(upper(X.COD_DIGITO_CTA_CORREN))));
          dbms_output.put_line('empresa: ' || X.COD_EMPRESA);
          dbms_output.put_line('fornec: ' || X.CDN_FORNECEDOR);
*/

        
          UPDATE FORNEC_FINANC V
             SET V.COD_BANCO             = nvl(X.COD_BANCO, ' '),
                 V.COD_AGENC_BCIA        = nvl(X.COD_AGENC_BCIA, ' '),
                 V.COD_DIGITO_AGENC_BCIA = to_char(F_DEFINIR_NUMERICO(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA))),
                 V.COD_CTA_CORREN_BCO    = nvl(X.COD_CTA_CORREN_BCO, ' '),
                 V.COD_DIGITO_CTA_CORREN = to_char(F_DEFINIR_NUMERICO(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN)))
           WHERE V.U##COD_EMPRESA = X.COD_EMPRESA
             AND V.CDN_FORNECEDOR = X.CDN_FORNECEDOR;

          VCDFORNEC_ANTERIOR := X.CDN_FORNECEDOR;

          BEGIN
            INSERT INTO cta_corren_fornec
              (u##cod_empresa,
               cod_empresa,
               cdn_fornecedor,
               u##cod_banco,
               cod_banco,
               u##cod_agenc_bcia,
               cod_agenc_bcia,
               u##cod_digito_agenc_bcia,
               cod_digito_agenc_bcia,
               U##cod_cta_corren_bco,
               cod_cta_corren_bco,
               u##cod_digito_cta_corren,
               cod_digito_cta_corren,
               des_cta_corren,
               log_cta_corren_prefer,
               progress_recid)
            VALUES
              (x.cod_empresa,
               x.cod_empresa,
               x.cdn_fornecedor,
               nvl(X.COD_BANCO, ' '),
               nvl(X.COD_BANCO, ' '),
               nvl(X.COD_AGENC_BCIA, ' '),
               nvl(X.COD_AGENC_BCIA, ' '),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
               nvl(X.COD_CTA_CORREN_BCO, ' '),
               nvl(X.COD_CTA_CORREN_BCO, ' '),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
               X.TPCONTA,
               '1',
               EMS5.CTA_CORREN_FORNEC_SEQ.NEXTVAL);
          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
              INSERT INTO cta_corren_fornec_falha
                (u##cod_empresa,
                 cod_empresa,
                 cdn_fornecedor,
                 u##cod_banco,
                 cod_banco,
                 u##cod_agenc_bcia,
                 cod_agenc_bcia,
                 u##cod_digito_agenc_bcia,
                 cod_digito_agenc_bcia,
                 U##cod_cta_corren_bco,
                 cod_cta_corren_bco,
                 u##cod_digito_cta_corren,
                 cod_digito_cta_corren,
                 des_cta_corren,
                 log_cta_corren_prefer,
                 progress_recid,
                 txfalha)
              VALUES
                (x.cod_empresa,
                 x.cod_empresa,
                 x.cdn_fornecedor,
                 nvl(X.COD_BANCO, ' '),
                 nvl(X.COD_BANCO, ' '),
                 nvl(X.COD_AGENC_BCIA, ' '),
                 nvl(X.COD_AGENC_BCIA, ' '),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
                 nvl(X.COD_CTA_CORREN_BCO, ' '),
                 nvl(X.COD_CTA_CORREN_BCO, ' '),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
                 X.TPCONTA,
                 '0',
                 EMS5.CTA_CORREN_FORNEC_SEQ.CURRVAL,
                 'PESSOA COM CONTA CORRENTE DUPLICADA. TALVEZ ESTA PESSOA POSSUA DOIS CODIGOS DE FORNECEDOR COM AS MESMAS CONTAS. VERIFICAR TAMBEM SE AS MESMAS NAO ESTAO COM O SINALIZADOR DE ENVIA BANCO DIFERENTES');

          END;
        ELSE
          BEGIN
            INSERT INTO cta_corren_fornec
              (u##cod_empresa,
               cod_empresa,
               cdn_fornecedor,
               u##cod_banco,
               cod_banco,
               u##cod_agenc_bcia,
               cod_agenc_bcia,
               u##cod_digito_agenc_bcia,
               cod_digito_agenc_bcia,
               U##cod_cta_corren_bco,
               cod_cta_corren_bco,
               u##cod_digito_cta_corren,
               cod_digito_cta_corren,
               des_cta_corren,
               log_cta_corren_prefer,
               progress_recid)
            VALUES
              (x.cod_empresa,
               x.cod_empresa,
               x.cdn_fornecedor,
               nvl(X.COD_BANCO, ' '),
               nvl(X.COD_BANCO, ' '),
               nvl(X.COD_AGENC_BCIA, ' '),
               nvl(X.COD_AGENC_BCIA, ' '),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
               nvl(X.COD_CTA_CORREN_BCO, ' '),
               nvl(X.COD_CTA_CORREN_BCO, ' '),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
               to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
               X.TPCONTA,
               '0',
               EMS5.CTA_CORREN_FORNEC_SEQ.NEXTVAL);

          EXCEPTION
            WHEN DUP_VAL_ON_INDEX THEN
              INSERT INTO cta_corren_fornec_falha
                (u##cod_empresa,
                 cod_empresa,
                 cdn_fornecedor,
                 u##cod_banco,
                 cod_banco,
                 u##cod_agenc_bcia,
                 cod_agenc_bcia,
                 u##cod_digito_agenc_bcia,
                 cod_digito_agenc_bcia,
                 U##cod_cta_corren_bco,
                 cod_cta_corren_bco,
                 u##cod_digito_cta_corren,
                 cod_digito_cta_corren,
                 des_cta_corren,
                 log_cta_corren_prefer,
                 progress_recid,
                 txfalha)
              VALUES
                (x.cod_empresa,
                 x.cod_empresa,
                 x.cdn_fornecedor,
                 nvl(X.COD_BANCO, ' '),
                 nvl(X.COD_BANCO, ' '),
                 nvl(X.COD_AGENC_BCIA, ' '),
                 nvl(X.COD_AGENC_BCIA, ' '),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_AGENC_BCIA),'X','0',null,' ',X.COD_DIGITO_AGENC_BCIA),0))),
                 nvl(X.COD_CTA_CORREN_BCO, ' '),
                 nvl(X.COD_CTA_CORREN_BCO, ' '),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
                 to_char(F_DEFINIR_NUMERICO(nvl(decode(upper(X.COD_DIGITO_CTA_CORREN),'X','0',null,' ',X.COD_DIGITO_CTA_CORREN),0))),
                 X.TPCONTA,
                 '0',
                 EMS5.CTA_CORREN_FORNEC_SEQ.CURRVAL,
                 'PESSOA COM CONTA CORRENTE DUPLICADA. TALVEZ ESTA PESSOA POSSUA DOIS CODIGOS DE FORNECEDOR COM AS MESMAS CONTAS. VERIFICAR TAMBEM SE AS MESMAS NAO ESTAO COM O SINALIZADOR DE ENVIA BANCO DIFERENTES');
          END;
        END IF;

      END LOOP;
    END;
    P_COMMIT_NEW;
    --commit;
  END P_GERAR_DADOS_BANC_FORNEC;

  FUNCTION F_RET_MASC_BANCO(VPCOD_BANCO IN VARCHAR2, VPTIPO IN VARCHAR2)
    RETURN NUMBER IS
    -- tipo "A" agencia , "C" conta
    VRESULT NUMBER;
  BEGIN
    -- verificar se o tipo de consulta é da agencia
    IF VPTIPO = 'A' THEN
      BEGIN
        SELECT LENGTH(B.COD_FORMAT_AGENC_BCIA)
          INTO VRESULT
          FROM BANCO B
         WHERE B.COD_BANCO = VPCOD_BANCO;
      EXCEPTION
        WHEN OTHERS THEN
          RETURN 10;
      END;
      RETURN VRESULT;
    ELSIF VPTIPO = 'C' THEN
      BEGIN
        SELECT LENGTH(B.COD_FORMAT_CTA_CORREN)
          INTO VRESULT
          FROM BANCO B
         WHERE B.COD_BANCO = VPCOD_BANCO;
      EXCEPTION
        WHEN OTHERS THEN
          RETURN 10;
      END;
    END IF;
    RETURN VRESULT;
  END;

  FUNCTION F_DEFINIR_NUMERICO(VP_CODIGO VARCHAR2) RETURN NUMBER IS
    VAUX VARCHAR2(20);
  BEGIN
--    dbms_output.enable(null);
    VAUX := '';
       
--    dbms_output.put_line('VP_CODIGO RECEBIDO EM F_DEFINIR_NUMERICO: ' || vp_codigo);
    
    FOR X IN 1 .. LENGTH(VP_CODIGO) LOOP
      IF SUBSTR(VP_CODIGO, X, 1) IN
         ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9') THEN
        VAUX := VAUX || SUBSTR(VP_CODIGO, X, 1);
      END IF;
    END LOOP;
    RETURN TO_NUMBER(NVL(VAUX, 0));
  END;

  procedure p_vincula_imposto_cliente is

    temp_impto_vincul_clien ems5.impto_vincul_clien%rowtype;

    cursor c_impto_clien is
      select distinct ttx.ind_clas_impto_unicoo,
                      ttx.cod_imposto_t11,
                      ttx.cod_classif_impto_t11,
                      tp.cdn_cliente
        from titulo_a_receber                 tr,
             taxa_titulo_a_receber            t,
             ti_taxa_a_receber                ttx,
             producao.cliente@unicoo_homologa cl,
             ti_pessoa                        tp
       where tr.nrregistro_titulo = t.nrregistro_titulo
         and ttx.cod_taxa_unicoo = t.cdtaxa
         and cl.cdcliente = tr.cdcliente
         and cl.nrregistro_cliente = tp.nrregistro;

  begin
    for ci in c_impto_clien loop

      temp_impto_vincul_clien.u##cod_empresa       := F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA');
      temp_impto_vincul_clien.cod_empresa          := F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA');
      temp_impto_vincul_clien.cdn_cliente          := ci.cdn_cliente;
      temp_impto_vincul_clien.u##cod_pais          := F_TI_PARAMETRO_INTEGRACAO('COD_PAIS');
      temp_impto_vincul_clien.cod_pais             := F_TI_PARAMETRO_INTEGRACAO('COD_PAIS');
      temp_impto_vincul_clien.u##cod_unid_federac  := ' '; --indo espaço como está no imposto fornecedor
      temp_impto_vincul_clien.cod_unid_federac     := ' '; --indo espaço como está no imposto fornecedor
      temp_impto_vincul_clien.u##cod_imposto       := ci.cod_imposto_t11;
      temp_impto_vincul_clien.cod_imposto          := ci.cod_imposto_t11;
      temp_impto_vincul_clien.u##cod_classif_impto := ci.cod_classif_impto_t11;
      temp_impto_vincul_clien.cod_classif_impto    := ci.cod_classif_impto_t11;
      temp_impto_vincul_clien.log_impto_opcnal     := 0;
      temp_impto_vincul_clien.cod_livre_1          := ' ';
      temp_impto_vincul_clien.log_livre_1          := 0;
      temp_impto_vincul_clien.num_livre_1          := 0;
      temp_impto_vincul_clien.val_livre_1          := 0;
      temp_impto_vincul_clien.dat_livre_1          := '';
      temp_impto_vincul_clien.cod_livre_2          := ' ';
      temp_impto_vincul_clien.dat_livre_2          := '';
      temp_impto_vincul_clien.log_livre_2          := 0;
      temp_impto_vincul_clien.num_livre_2          := 0;
      temp_impto_vincul_clien.val_livre_2          := 0;
      temp_impto_vincul_clien.cdd_version          := '0';

      select ems5.impto_vincul_clien_seq.nextval
        into temp_impto_vincul_clien.progress_recid
        from dual;

      insert into ems5.impto_vincul_clien values temp_impto_vincul_clien;

      update ems5.clien_financ cf
         set cf.log_retenc_impto = 1
       where cf.cdn_cliente = ci.cdn_cliente;

    end loop;

  end p_vincula_imposto_cliente;

--AJUSTAR CODIGO DE BLOQUEIO CONFORME CAMPO DO UNICOO CLIENTE.CDBLOQUEIO
procedure P_ATUALIZA_BLOQUEIO_CLIENTE IS
begin
  for x in (select substr(lpad(nvl(c.cdbloqueio,'000'),3,'0'),1,3) cdbloqueio, cf.progress_recid
              from producao.cliente@unicoo_homologa c,
                   ems5.clien_financ                cf,
                   ti_pessoa                        tp
             where tp.nrregistro = c.nrregistro_cliente
               and tp.cdn_cliente = cf.cdn_cliente) loop
  
    update ems5.clien_financ cf
       set cf.u##cod_classif_msg_cobr = x.cdbloqueio,
           cf.cod_classif_msg_cobr    = x.cdbloqueio
     where cf.progress_recid = x.progress_recid;
  end loop;
end P_ATUALIZA_BLOQUEIO_CLIENTE;

--select distinct cod_classif_msg_cobr, count(*) from clien_financ group by cod_classif_msg_cobr

  PROCEDURE P_VINCULA_IMPOSTO_FORNEC IS
    /*
    ***************************************************************************************************************
    Criac?o          : -
    Data             : -
    Modulo Principal : Integrac?o EMS5
    Modulos          : -
    Objetivo         : vincular os impostos do fornecedor no EMS5
    Alteracoes
    +------------------------------------------------------------------------------------------------------------------------------------------+
    | DATA       | RESPONSAVEL   | VERSAO        | PENDENCIA | ALTERACAO                                                                       |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    | 01/07/2014 | JOSIAS        |               |           | Atualizações necessárias   |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    */
  BEGIN
    BEGIN
      INSERT INTO IMPTO_VINCUL_FORNEC
        SELECT F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') U##COD_EMPRESA,
               F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') COD_EMPRESA,
               CDN_FORNECEDOR,
               F_TI_PARAMETRO_INTEGRACAO('COD_PAIS') U##COD_PAIS,
               F_TI_PARAMETRO_INTEGRACAO('COD_PAIS') COD_PAIS,
               ' ' /*COD_UNID_FEDERAC*/ U##COD_UNID_FEDERAC,
               ' ' /*COD_UNID_FEDERAC*/ COD_UNID_FEDERAC,
               CDTAXA U##COD_IMPOSTO,
               CDTAXA COD_IMPOSTO,
               CDCLASS U##COD_CLASSIF_IMPTO,
               CDCLASS COD_CLASSIF_IMPTO,
               0 LOG_IMPTO_OPCNAL,
               ' ' COD_LIVRE_1,
               0 LOG_LIVRE_1,
               0 NUM_LIVRE_1,
               0 VAL_LIVRE_1,
               TRUNC(SYSDATE) DAT_LIVRE_1,
               0 NUMREDUZRENDTOTRIBUT,
               ' ' COD_LIVRE_2,
               NULL DAT_LIVRE_2,
               0 LOG_LIVRE_2,
               0 NUM_LIVRE_2,
               0 VAL_LIVRE_2,
               0 CDD_VERSION,
               EMS5.IMPTO_VINCUL_FORNEC_SEQ.NEXTVAL PROGRESS_RECID
          FROM (SELECT DISTINCT F_TI_IMPOSTO_AGRUPADO(XX.COD_IMPOSTO,
                                                      TTP.NRREGISTRO_TITULO) CDTAXA,
                                F_TI_IMPOSTO_AGRUPADO(XX.COD_CLASSIF_IMPTO,
                                                      TTP.NRREGISTRO_TITULO) CDCLASS,
                                TIP.CDN_FORNECEDOR,
                                XX.COD_UNID_FEDERAC
                  FROM TAXA_TITULO_A_PAGAR                 TTP,
                       TITULO_A_PAGAR                      TP,
                       PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA FN,
                       TI_TAXA_A_PAGAR                     XX,
                       TI_PESSOA                           TIP,
                       TI_FORNECEDOR                       TIF
                 WHERE XX.COD_TAXA = TTP.CDTAXA
                   AND TIP.NRREGISTRO = FN.NRREGISTRO_FORNECEDOR
                   AND FN.CDFORNECEDOR = TP.CDFORNECEDOR
                   AND TP.NRREGISTRO_TITULO = TTP.NRREGISTRO_TITULO
                   AND TIF.NRPESSOA = TIP.NRREGISTRO
                   AND TIP.CDN_FORNECEDOR IS NOT NULL
                   AND NOT EXISTS
                 (SELECT 1
                          FROM IMPTO_VINCUL_FORNEC IVF
                         WHERE IVF.CDN_FORNECEDOR    = TIP.CDN_FORNECEDOR
                           AND IVF.COD_CLASSIF_IMPTO =
                               F_TI_IMPOSTO_AGRUPADO(XX.COD_CLASSIF_IMPTO,
                                                     TTP.NRREGISTRO_TITULO)
                           AND IVF.U##COD_EMPRESA     = F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') --'1' --FN.COD_EMPRESA
                           AND IVF.U##COD_PAIS        = F_TI_PARAMETRO_INTEGRACAO('COD_PAIS') --'BRA' --FN.COD_PAIS
                           AND IVF.U##COD_UNID_FEDERAC = ' '
                           AND IVF.U##COD_UNID_FEDERAC = COD_UNID_FEDERAC
                           AND IVF.U##COD_IMPOSTO      = XX.COD_IMPOSTO));
    exception
      when others then
        raise_application_error(-20100,
                                ' erro inserindo impostos ' || sqlerrm);
    end;
    P_COMMIT_NEW;

    /* Alex Boeira - 20/02/2017 - garantir vinculacao de INSSPF e IRPF para Fornecedores PF.
     *               Motivo: conforme Luiz Henrique (Unimed NI), caso o prestador não recolha
     *                       pela Unimed (tem outra fonte), não é gerada movimentação de recolhimento,
     *                       o que faz com que a lógica acima deixe de gerar a vinculação do INSSPF.
     *                       Além disso, há prestadores com produção inferior ao valor mínimo para
     *                       retenção de IR, dessa forma também não cria TAXA_TITULO_A_PAGAR.
     */
/*
    BEGIN
      INSERT INTO IMPTO_VINCUL_FORNEC
        SELECT
               trim(upper(F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA'))) U##COD_EMPRESA,
               trim(F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA')) COD_EMPRESA,
               trim(tip.CDN_FORNECEDOR),
               trim(upper(F_TI_PARAMETRO_INTEGRACAO('COD_PAIS'))) U##COD_PAIS,
               trim(F_TI_PARAMETRO_INTEGRACAO('COD_PAIS')) COD_PAIS,
               upper(t.COD_UNID_FEDERAC) U##COD_UNID_FEDERAC,
               t.COD_UNID_FEDERAC COD_UNID_FEDERAC,
               trim(upper(i.cod_imposto)) U##COD_IMPOSTO,
               trim(i.cod_imposto) COD_IMPOSTO,
               trim(upper(t.cod_classif_impto)) U##COD_CLASSIF_IMPTO,
               trim(t.cod_classif_impto) COD_CLASSIF_IMPTO,
               0 LOG_IMPTO_OPCNAL,
               ' ' COD_LIVRE_1,
               0 LOG_LIVRE_1,
               0 NUM_LIVRE_1,
               0 VAL_LIVRE_1,
               TRUNC(SYSDATE) DAT_LIVRE_1,
               0 NUMREDUZRENDTOTRIBUT,
               ' ' COD_LIVRE_2,
               NULL DAT_LIVRE_2,
               0 LOG_LIVRE_2,
               0 NUM_LIVRE_2,
               0 VAL_LIVRE_2,
               0 CDD_VERSION,
               EMS5.IMPTO_VINCUL_FORNEC_SEQ.NEXTVAL PROGRESS_RECID
          from ems5.imposto i,
               ti_taxa_a_pagar t,
               TI_PESSOA                           TIP,
               TI_FORNECEDOR                       TIF
          where t.cod_imposto = i.cod_imposto
            AND (   (UPPER(I.DES_IMPOSTO) LIKE '%' || 'INSS' || '%' || 'PF'  || '%')
                 OR (UPPER(I.DES_IMPOSTO) LIKE '%' || 'INSS' || '%' || 'FIS' || '%')
                 OR (UPPER(I.DES_IMPOSTO) LIKE '%' || 'IR'   || '%' || 'PF'  || '%')
                 OR (UPPER(I.DES_IMPOSTO) LIKE '%' || 'IR'   || '%' || 'FIS' || '%')
                )
            and tif.cod_fornecedor = tip.cdn_fornecedor
            and tif.ind_tipo_pessoa = 'F'
            and tif.cod_acao = 'I'
            AND NOT EXISTS
           (SELECT 1
              FROM IMPTO_VINCUL_FORNEC IVF
             where IVF.U##COD_EMPRESA       = trim(upper(F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA'))) --'1' --FN.COD_EMPRESA
               and IVF.CDN_FORNECEDOR       = trim(TIP.CDN_FORNECEDOR)
               AND IVF.U##COD_PAIS          = trim(upper(F_TI_PARAMETRO_INTEGRACAO('COD_PAIS'))) --'BRA' --FN.COD_PAIS
               AND IVF.U##COD_UNID_FEDERAC  = upper(t.COD_UNID_FEDERAC) -- ' '
               AND IVF.U##COD_IMPOSTO       = trim(upper(i.cod_imposto))
               AND IVF.U##COD_CLASSIF_IMPTO = trim(upper(t.cod_classif_impto)));
    exception
      when others then
        raise_application_error(-20100,
                                ' erro inserindo impostos ' || sqlerrm);
    end;
    */
    P_COMMIT_NEW;

    -------------------
    UPDATE FORNEC_FINANC F
       SET F.LOG_RETENC_IMPTO = 1
     WHERE EXISTS (SELECT 1
              FROM IMPTO_VINCUL_FORNEC I
             WHERE I.U##COD_EMPRESA = F.U##COD_EMPRESA
               AND I.CDN_FORNECEDOR = F.CDN_FORNECEDOR);
    --COMMIT;
  END P_VINCULA_IMPOSTO_FORNEC;

  PROCEDURE P_CONTABILIZACAO(PNRSEQ_CONTROLE_INTEGRACAO IN NUMBER,
                             PNRPERIODO                 IN NUMBER,
                             PCDLOTE_INTEGRACAO         IN VARCHAR2,
                             PTXDESCRICAO_LOTE          IN VARCHAR2,
                             PDTLOTE                    IN DATE,
                             PCDEMPRESA                 IN VARCHAR2,
                             PTPPERIODO                 IN VARCHAR2,
                             PI_NRLOTE                  IN NUMBER,
                             PI_CDFUNCIONARIO           IN VARCHAR2) IS
    /*
    ***************************************************************************************************************
    Criac?o          : -
    Data             : -
    Modulo Principal : Integrac?o EMS5
    Modulos          : -
    Telas            : CR05FC7
    Objetivo         : Enviar os titulos do Unicoo para o EMS5

    Alteracoes
    +------------------------------------------------------------------------------------------------------------------------------------------+
    | DATA       | RESPONSAVEL   | VERSAO        | PENDENCIA | ALTERACAO                                                                       |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    | 04/11/2009 | ALECSANDRO    |               |           | A tabela TI_LANCAMENTO_CONTABIL foi alterada para TI_ITEM_LANCAMENTO_CONTABIL   |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    | 06/07/2009 | ERIC ARANTES  |               |           | Criado os cursores para trazer o centro custo no lancamento contabil            |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|
    | 01/07/2014 | JOSIAS        |               |           | Atualizações necessárias   |
    |------------|---------------|---------------|---------------------------------------------------------------------------------------------|

    */
    CURSOR C_LANCTO_DEB IS
      SELECT LC.CDEMPRESA,
             LC.NRPERIODO,
             LC.TPPERIODO,
             LC.CDCONTA_MEMO_DEB,
             LC.CDCONTA_MEMO_CRED,
             LC.NRLANCAMENTO,
             LC.NRSEQ_LANCTO,
             LC.DTLANCAMENTO,
             LC.VLLANCAMENTO,
             LC.CDCONTA_DEB CDCONTA_CONTABIL,
             'DB' TPLANCAMENTO,
             LC.CDLANCTO_PADRAO,
             LC.TXHISTORICO,
             LC.NRDOCUMENTO
        FROM LANCAMENTO_CONTABIL LC
       WHERE LC.CDCONTA_DEB IS NOT NULL
         AND LC.NRPERIODO = PNRPERIODO
         AND LC.CDEMPRESA = PCDEMPRESA
         AND LC.TPPERIODO = PTPPERIODO
         AND (LC.CDLANCTO_PADRAO =
             'L' ||
             SUBSTR(TO_NUMBER(SUBSTR(PCDLOTE_INTEGRACAO, 2, 10)), 1, 5) --pcdlote_integracao
             OR PCDLOTE_INTEGRACAO IS NULL);
    CURSOR C_LANCTO_CRED IS
      SELECT LC.CDEMPRESA,
             LC.NRPERIODO,
             LC.TPPERIODO,
             LC.CDCONTA_MEMO_DEB,
             LC.CDCONTA_MEMO_CRED,
             LC.NRLANCAMENTO,
             LC.NRSEQ_LANCTO,
             LC.DTLANCAMENTO,
             LC.VLLANCAMENTO,
             LC.CDCONTA_CRED CDCONTA_CONTABIL,
             'CR' TPLANCAMENTO,
             LC.CDLANCTO_PADRAO,
             LC.TXHISTORICO,
             LC.NRDOCUMENTO
        FROM LANCAMENTO_CONTABIL LC
       WHERE LC.CDCONTA_CRED IS NOT NULL
         AND LC.NRPERIODO = PNRPERIODO
         AND LC.CDEMPRESA = PCDEMPRESA
         AND LC.TPPERIODO = PTPPERIODO
         AND (LC.CDLANCTO_PADRAO =
             'L' ||
             SUBSTR(TO_NUMBER(SUBSTR(PCDLOTE_INTEGRACAO, 2, 10)), 1, 5) --pcdlote_integracao
             OR PCDLOTE_INTEGRACAO IS NULL);
    /*
    TODO: owner="Eric" created="08/07/2010"
    text="Não sei se as outras integrações também recebem obrigatóriamente um numero de lote, por isso fiz esse tratamento em cursor separado para não afetar o que já funciona em "
    */
    ----> cursor para o fechamento de estoque
    CURSOR C_LANCTO_DEB_2 IS
      SELECT LC.CDEMPRESA,
             LC.NRPERIODO,
             LC.TPPERIODO,
             IC.CDCONTA_MEMO_DEB,
             IC.CDCONTA_MEMO_CRED,
             LC.NRLANCAMENTO,
             LC.NRSEQ_LANCTO,
             LC.DTLANCAMENTO,
             LC.VLLANCAMENTO,
             LC.CDCONTA_DEB CDCONTA_CONTABIL,
             'DB' TPLANCAMENTO,
             LC.CDLANCTO_PADRAO,
             LC.TXHISTORICO,
             LC.NRDOCUMENTO,
             IC.CDORIGEM
        FROM LANCAMENTO_CONTABIL LC, INTEGRACAO_CONTABIL IC
       WHERE LC.NRLANCAMENTO = IC.NRLANCAMENTO
         AND LC.NRSEQ_LANCTO = IC.NRSEQ_LANCTO
         AND LC.CDCONTA_DEB IS NOT NULL
         AND LC.NRPERIODO = PNRPERIODO
         AND LC.CDEMPRESA = PCDEMPRESA
         AND LC.TPPERIODO = PTPPERIODO
         AND IC.NRLOTE_INTEGRACAO = PI_NRLOTE
         AND (LC.CDLANCTO_PADRAO = PCDLOTE_INTEGRACAO OR
             PCDLOTE_INTEGRACAO IS NULL);
    CURSOR C_LANCTO_CRED_2 IS
      SELECT LC.CDEMPRESA,
             LC.NRPERIODO,
             LC.TPPERIODO,
             IC.CDCONTA_MEMO_DEB,
             IC.CDCONTA_MEMO_CRED,
             LC.NRLANCAMENTO,
             LC.NRSEQ_LANCTO,
             LC.DTLANCAMENTO,
             LC.VLLANCAMENTO,
             LC.CDCONTA_CRED CDCONTA_CONTABIL,
             'CR' TPLANCAMENTO,
             LC.CDLANCTO_PADRAO,
             LC.TXHISTORICO,
             LC.NRDOCUMENTO,
             IC.CDORIGEM
        FROM LANCAMENTO_CONTABIL LC, INTEGRACAO_CONTABIL IC
       WHERE LC.NRLANCAMENTO = IC.NRLANCAMENTO
         AND LC.NRSEQ_LANCTO = IC.NRSEQ_LANCTO
         AND LC.CDCONTA_CRED IS NOT NULL
         AND LC.NRPERIODO = PNRPERIODO
         AND LC.CDEMPRESA = PCDEMPRESA
         AND LC.TPPERIODO = PTPPERIODO
         AND IC.NRLOTE_INTEGRACAO = PI_NRLOTE
         AND (LC.CDLANCTO_PADRAO = PCDLOTE_INTEGRACAO OR
             PCDLOTE_INTEGRACAO IS NULL);
    VCOD_CCUSTO TI_CENTRO_CUSTO_CTBL.COD_CCUSTO%TYPE;
    VCOD_ESTAB  TI_CENTRO_CUSTO_CTBL.COD_ESTAB%TYPE;
    VA_CODESTAB VARCHAR2(2) := '01';
    VCDSITUACAO VARCHAR2(2);
  BEGIN
    INSERT INTO TI_LOTE_CTBL
      (NRSEQ_CONTROLE_INTEGRACAO,
       CDSITUACAO,
       NRPERIODO,
       COD_PLANO_CTA_CTBL,
       COD_PLANO_CCUSTO,
       DAT_LOTE_CTBL,
       DAT_PROCESSAMENTO,
       DAT_GERACAO,
       DES_LOTE_CTBL,
       AOLOTE_INTEGRACAO)
      SELECT PNRSEQ_CONTROLE_INTEGRACAO,
             'RC' CDSITUACAO,
             PNRPERIODO,
             F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CTA_CTBL') COD_PLANO_CTA_CTBL,
             F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO') COD_PLANO_CCUSTO,
             PDTLOTE,
             SYSDATE DAT_PROCESSAMENTO,
             SYSDATE DAT_GERACAO,
             CASE
               WHEN PTXDESCRICAO_LOTE LIKE 'APROPRIACAO PROD.PREST%' THEN
                SUBSTR(PCDLOTE_INTEGRACAO || '-' || 'APROP. PAGPREST' ||
                       SUBSTR(PTXDESCRICAO_LOTE, 24, 21),
                       1,
                       40)
               WHEN PTXDESCRICAO_LOTE LIKE
                    'APROPRIACAO DAS FATURAS EMITIDAS%' THEN
                SUBSTR(PCDLOTE_INTEGRACAO || '-' || 'APROP. FAT EMITIDAS' ||
                       SUBSTR(PTXDESCRICAO_LOTE, 24, 21),
                       1,
                       40)
               WHEN PTXDESCRICAO_LOTE LIKE
                    'APROPRIACAO DAS FATURAS VENCIDAS%' THEN
                SUBSTR(PCDLOTE_INTEGRACAO || '-' || 'APROP. FAT VENCIDAS' ||
                       SUBSTR(PTXDESCRICAO_LOTE, 24, 21),
                       1,
                       40)
               ELSE
                SUBSTR(PCDLOTE_INTEGRACAO || '-' || PTXDESCRICAO_LOTE, 1, 40)
             END DES_LOTE_CTBL,
             DECODE(PCDLOTE_INTEGRACAO, NULL, 'N', 'S')
        FROM DUAL;
    --=========
    IF PI_CDFUNCIONARIO != 'SISMV' THEN
      FOR L_LANCTO_CRED IN C_LANCTO_CRED LOOP
        BEGIN
          SELECT CCC.COD_CCUSTO, CCC.COD_ESTAB
            INTO VCOD_CCUSTO, VCOD_ESTAB
            FROM TI_CENTRO_CUSTO_CTBL CCC
           WHERE COD_PLANO_CCUSTO =
                 F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO') --'PCCVR'
                --and  cod_estab='01'
             AND COD_CTA_CTBL = L_LANCTO_CRED.CDCONTA_CONTABIL;
        EXCEPTION
          WHEN OTHERS THEN
            VCOD_CCUSTO := ' ';
            VCOD_ESTAB  := '01';
        END;
        IF L_LANCTO_CRED.DTLANCAMENTO <= '31/07/2009' THEN
          VCOD_CCUSTO := ' ';
        END IF;
        INSERT INTO TI_ITEM_LANCAMENTO_CTBL
          (NRSEQ_CONTROLE_INTEGRACAO,
           CDSITUACAO,
           COD_CTA_CTBL,
           IND_NATUR_LANCTO_CTBL,
           COD_HISTOR_PADR,
           DES_HISTOR_LANCTO_CTBL,
           DAT_LANCTO,
           VAL_LANCTO_CTBL,
           COD_CCUSTO,
           COD_PROJ_FINANC,
           IND_OCORRENCIA,
           DAT_PROCESSAMENTO,
           DAT_GERACAO,
           COD_ESTAB,
           DES_DOCTO,
           NRPERIODO,
           COD_EMPRESA,
           COD_UNID_NEGOC,
           NRLANCAMENTO,
           NRSEQ_LANCTO)
        VALUES
          (PNRSEQ_CONTROLE_INTEGRACAO,
           'RC',
           L_LANCTO_CRED.CDCONTA_CONTABIL,
           L_LANCTO_CRED.TPLANCAMENTO,
           ' ',
           SUBSTR(L_LANCTO_CRED.TXHISTORICO, 1, 2000),
           L_LANCTO_CRED.DTLANCAMENTO,
           L_LANCTO_CRED.VLLANCAMENTO,
           VCOD_CCUSTO,
           DECODE(F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO'),
                  'NULO',
                  '',
                  F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO')) --, ' '
          ,
           0,
           NULL,
           SYSDATE,
           VCOD_ESTAB --, '01' --va_codestab
          ,
           L_LANCTO_CRED.NRDOCUMENTO,
           PNRPERIODO,
           F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') --, '1'
          ,
           F_TI_PARAMETRO_INTEGRACAO('COD_UNI_NEG') --, 'UNI'
          ,
           L_LANCTO_CRED.NRLANCAMENTO,
           L_LANCTO_CRED.NRSEQ_LANCTO);
      END LOOP;
      --=========
      FOR L_LANCTO_DEB IN C_LANCTO_DEB LOOP
        BEGIN
          SELECT CCC.COD_CCUSTO, CCC.COD_ESTAB
            INTO VCOD_CCUSTO, VCOD_ESTAB
            FROM TI_CENTRO_CUSTO_CTBL CCC
           WHERE COD_PLANO_CCUSTO =
                 F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO') --'PCCVR'
                --and cod_estab='01'
             AND COD_CTA_CTBL = L_LANCTO_DEB.CDCONTA_CONTABIL;
        EXCEPTION
          WHEN OTHERS THEN
            VCOD_CCUSTO := ' ';
            VCOD_ESTAB  := '01';
        END;
        IF L_LANCTO_DEB.DTLANCAMENTO <= '31/07/2009' THEN
          VCOD_CCUSTO := ' ';
        END IF;
        INSERT INTO TI_ITEM_LANCAMENTO_CTBL
          (NRSEQ_CONTROLE_INTEGRACAO,
           CDSITUACAO,
           COD_CTA_CTBL,
           IND_NATUR_LANCTO_CTBL,
           COD_HISTOR_PADR,
           DES_HISTOR_LANCTO_CTBL,
           DAT_LANCTO,
           VAL_LANCTO_CTBL,
           COD_CCUSTO,
           COD_PROJ_FINANC,
           IND_OCORRENCIA,
           DAT_PROCESSAMENTO,
           DAT_GERACAO,
           COD_ESTAB,
           DES_DOCTO,
           NRPERIODO,
           COD_EMPRESA,
           COD_UNID_NEGOC,
           NRLANCAMENTO,
           NRSEQ_LANCTO)
        VALUES
          (PNRSEQ_CONTROLE_INTEGRACAO,
           'RC',
           L_LANCTO_DEB.CDCONTA_CONTABIL,
           L_LANCTO_DEB.TPLANCAMENTO,
           ' ',
           SUBSTR(L_LANCTO_DEB.TXHISTORICO, 1, 2000),
           L_LANCTO_DEB.DTLANCAMENTO,
           L_LANCTO_DEB.VLLANCAMENTO,
           VCOD_CCUSTO,
           DECODE(F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO'),
                  'NULO',
                  '',
                  F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO')) --, ' '
          ,
           0,
           NULL,
           SYSDATE,
           VCOD_ESTAB --, '01'--va_codestab
          ,
           L_LANCTO_DEB.NRDOCUMENTO,
           PNRPERIODO,
           F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') --'1'
          ,
           F_TI_PARAMETRO_INTEGRACAO('COD_UNI_NEG') --'UNI'
          ,
           L_LANCTO_DEB.NRLANCAMENTO,
           L_LANCTO_DEB.NRSEQ_LANCTO);
      END LOOP;
      ------------------ no caso de fechamento do estoque entra nesse loop ----------------------------------
    ELSE
      FOR L_LANCTO_CRED2 IN C_LANCTO_CRED_2 LOOP
        BEGIN
          SELECT CCC.COD_CCUSTO, CCC.COD_ESTAB
            INTO VCOD_CCUSTO, VCOD_ESTAB
            FROM TI_CENTRO_CUSTO_CTBL CCC
           WHERE COD_PLANO_CCUSTO =
                 F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO') --'PCCVR'
                --and  cod_estab='01'
             AND COD_CTA_CTBL = L_LANCTO_CRED2.CDCONTA_CONTABIL;
        EXCEPTION
          WHEN OTHERS THEN
            IF SUBSTR(L_LANCTO_CRED2.CDCONTA_CONTABIL, 1, 1) IN ('7', '4') THEN
              VCOD_CCUSTO := NVL(L_LANCTO_CRED2.CDCONTA_MEMO_CRED,
                                 L_LANCTO_CRED2.CDCONTA_MEMO_DEB);
            ELSE
              VCOD_CCUSTO := ' ';
              VCOD_ESTAB  := '01';
            END IF;
        END;
        IF L_LANCTO_CRED2.DTLANCAMENTO <= '31/07/2009' THEN
          VCOD_CCUSTO := ' ';
        END IF;
        --vcod_ccusto := null; --l_lancto_cred2.cdconta_memo_cred;
        VA_CODESTAB := L_LANCTO_CRED2.CDORIGEM;
        INSERT INTO TI_ITEM_LANCAMENTO_CTBL
          (NRSEQ_CONTROLE_INTEGRACAO,
           CDSITUACAO,
           COD_CTA_CTBL,
           IND_NATUR_LANCTO_CTBL,
           COD_HISTOR_PADR,
           DES_HISTOR_LANCTO_CTBL,
           DAT_LANCTO,
           VAL_LANCTO_CTBL,
           COD_CCUSTO,
           COD_PROJ_FINANC,
           IND_OCORRENCIA,
           DAT_PROCESSAMENTO,
           DAT_GERACAO,
           COD_ESTAB,
           DES_DOCTO,
           NRPERIODO,
           COD_EMPRESA,
           COD_UNID_NEGOC,
           NRLANCAMENTO,
           NRSEQ_LANCTO)
        VALUES
          (PNRSEQ_CONTROLE_INTEGRACAO,
           'RC',
           L_LANCTO_CRED2.CDCONTA_CONTABIL,
           L_LANCTO_CRED2.TPLANCAMENTO,
           ' ',
           SUBSTR(L_LANCTO_CRED2.TXHISTORICO, 1, 2000),
           L_LANCTO_CRED2.DTLANCAMENTO,
           L_LANCTO_CRED2.VLLANCAMENTO,
           NVL(VCOD_CCUSTO, ' '),
           DECODE(F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO'),
                  'NULO',
                  '',
                  F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO')) --, ' '
          ,
           0,
           NULL,
           SYSDATE,
           VA_CODESTAB,
           L_LANCTO_CRED2.NRDOCUMENTO,
           PNRPERIODO,
           F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') --'1'
          ,
           F_TI_PARAMETRO_INTEGRACAO('COD_UNI_NEG') --'UNI'
          ,
           L_LANCTO_CRED2.NRLANCAMENTO,
           L_LANCTO_CRED2.NRSEQ_LANCTO);
      END LOOP;
      FOR L_LANCTO_DEB2 IN C_LANCTO_DEB_2 LOOP
        BEGIN
          SELECT CCC.COD_CCUSTO
            INTO VCOD_CCUSTO
            FROM TI_CENTRO_CUSTO_CTBL CCC
           WHERE COD_PLANO_CCUSTO =
                 F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO') --'PCCVR'
                --and cod_estab='01'
             AND COD_CTA_CTBL = L_LANCTO_DEB2.CDCONTA_CONTABIL;
        EXCEPTION
          WHEN OTHERS THEN
            IF SUBSTR(L_LANCTO_DEB2.CDCONTA_CONTABIL, 1, 1) IN ('7', '4') THEN
              VCOD_CCUSTO := NVL(L_LANCTO_DEB2.CDCONTA_MEMO_DEB,
                                 L_LANCTO_DEB2.CDCONTA_MEMO_CRED);
            ELSE
              VCOD_CCUSTO := ' ';
              VCOD_ESTAB  := '01';
            END IF;
        END;
        IF L_LANCTO_DEB2.DTLANCAMENTO <= '31/07/2009' THEN
          VCOD_CCUSTO := ' ';
          VCOD_ESTAB  := '01';
        END IF;
        --            vcod_ccusto := l_lancto_deb2.cdconta_memo_deb;
        VA_CODESTAB := L_LANCTO_DEB2.CDORIGEM;
        INSERT INTO TI_ITEM_LANCAMENTO_CTBL
          (NRSEQ_CONTROLE_INTEGRACAO,
           CDSITUACAO,
           COD_CTA_CTBL,
           IND_NATUR_LANCTO_CTBL,
           COD_HISTOR_PADR,
           DES_HISTOR_LANCTO_CTBL,
           DAT_LANCTO,
           VAL_LANCTO_CTBL,
           COD_CCUSTO,
           COD_PROJ_FINANC,
           IND_OCORRENCIA,
           DAT_PROCESSAMENTO,
           DAT_GERACAO,
           COD_ESTAB,
           DES_DOCTO,
           NRPERIODO,
           COD_EMPRESA,
           COD_UNID_NEGOC,
           NRLANCAMENTO,
           NRSEQ_LANCTO)
        VALUES
          (PNRSEQ_CONTROLE_INTEGRACAO,
           'RC',
           L_LANCTO_DEB2.CDCONTA_CONTABIL,
           L_LANCTO_DEB2.TPLANCAMENTO,
           ' ',
           SUBSTR(L_LANCTO_DEB2.TXHISTORICO, 1, 2000),
           L_LANCTO_DEB2.DTLANCAMENTO,
           L_LANCTO_DEB2.VLLANCAMENTO,
           NVL(VCOD_CCUSTO, ' '),
           DECODE(F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO'),
                  'NULO',
                  '',
                  F_TI_PARAMETRO_INTEGRACAO('COD_PROJETO_PADRAO')) --, ' '
          ,
           0,
           NULL,
           SYSDATE,
           VA_CODESTAB,
           L_LANCTO_DEB2.NRDOCUMENTO,
           PNRPERIODO,
           F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA') --'1'
          ,
           F_TI_PARAMETRO_INTEGRACAO('COD_UNI_NEG') --'UNI'
          ,
           L_LANCTO_DEB2.NRLANCAMENTO,
           L_LANCTO_DEB2.NRSEQ_LANCTO);
      END LOOP;
    END IF;
    --=====================================--
    -- Aplica depara da matriz de tradução --
    -----------------------------------------
    FOR L_MT IN (SELECT ILC.ROWID LINHA,
                        MT.DESTINO_COD_CCUSTO,
                        MT.DESTINO_COD_ESTAB
                   FROM TI_LOTE_CTBL_MATRIZ_TRADUCAO MT,
                        TI_ITEM_LANCAMENTO_CTBL      ILC
                  WHERE ILC.NRSEQ_CONTROLE_INTEGRACAO =
                        PNRSEQ_CONTROLE_INTEGRACAO
                    AND ILC.COD_ESTAB = MT.COD_ESTAB
                    AND (ILC.COD_CTA_CTBL = MT.COD_CTA_CTBL OR
                        MT.COD_CTA_CTBL = '*')
                    AND (MT.COD_CCUSTO = ILC.COD_CCUSTO OR
                        MT.COD_CCUSTO = '*')
                    AND MT.COD_PLANO_CCUSTO =
                        F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO') --'PCCVR'
                    AND (MT.DES_HISTOR_LANCTO_CTBL = '*' OR
                        MT.DES_HISTOR_LANCTO_CTBL =
                        ILC.DES_HISTOR_LANCTO_CTBL)) LOOP
      UPDATE TI_ITEM_LANCAMENTO_CTBL I
         SET I.COD_ESTAB  = L_MT.DESTINO_COD_ESTAB,
             I.COD_CCUSTO = L_MT.DESTINO_COD_CCUSTO
       WHERE I.ROWID = L_MT.LINHA;
    END LOOP;
    --============================--
    -- Validação centro de custos --
    --------------------------------
    VCDSITUACAO := 'OK';
    FOR L_CCUSTO_NAO_INFORMADO IN (SELECT COD_CTA_CTBL,
                                          COD_CCUSTO,
                                          I.COD_ESTAB,
                                          I.COD_EMPRESA,
                                          I.IND_NATUR_LANCTO_CTBL
                                     FROM TI_ITEM_LANCAMENTO_CTBL I
                                    WHERE I.NRSEQ_CONTROLE_INTEGRACAO =
                                          PNRSEQ_CONTROLE_INTEGRACAO
                                      AND I.COD_CCUSTO = ' '
                                      AND EXISTS
                                    (SELECT 1
                                             FROM CRITERDISTRIBCTACTBL A,
                                                  MAPA_DISTRIB_CCUSTO  M
                                            WHERE M.CODMAPADISTRIBCCUSTO =
                                                  A.CODMAPADISTRIBCCUSTO
                                              AND A.COD_CTA_CTBL =
                                                  I.COD_CTA_CTBL
                                              AND I.DAT_LANCTO BETWEEN
                                                  A.DAT_INIC_VALID AND
                                                  A.DAT_FIM_VALID)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'TI_LOTE_CTBL',
           'NÃO FOI INFORMADO CENTRO DE CUSTO P/ A CONTA CONTABIL ' ||
           L_CCUSTO_NAO_INFORMADO.COD_CTA_CTBL,
           'Verifique o criterio de distribuição do EMS e os esquemas contábeis do Unicoo',
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    -- Período não habilitado
    FOR L_PERIODO IN (SELECT MAX(P.COD_EXERC_CTBL ||
                                 LPAD(P.NUM_PERIOD_CTBL, 2, '0')) NRPERIODO,
                             COUNT(*) QTPERIODO,
                             MAX(COD_CENAR_CTBL) NOCENARIO
                        FROM SIT_PERIOD_CTBL P, TI_LOTE_CTBL LT
                       WHERE LT.NRSEQ_CONTROLE_INTEGRACAO =
                             PNRSEQ_CONTROLE_INTEGRACAO
                         AND P.COD_EXERC_CTBL ||
                             LPAD(P.NUM_PERIOD_CTBL, 2, '0') =
                             TO_CHAR(LT.DAT_LOTE_CTBL, 'YYYYMM')
                         AND P.IND_SIT_PERIOD_CTBL <> 'Habilitado'
                         AND P.COD_MODUL_DTSUL = 'FGL'
                         AND P.COD_EMPRESA =
                             F_TI_PARAMETRO_INTEGRACAO('COD_EMPRESA')) LOOP
      BEGIN
        IF L_PERIODO.QTPERIODO > 0 THEN
          INSERT INTO TI_FALHA_DE_PROCESSO
            (NRSEQUENCIAL,
             NRSEQ_CONTROLE_INTEGRACAO,
             CDINTEGRACAO,
             TXFALHA,
             TXAJUDA,
             DTFALHA,
             NRMENSAGEM)
          VALUES
            (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
             PNRSEQ_CONTROLE_INTEGRACAO,
             'TI_LOTE_CTBL',
             'O módulo FGL não esta habilitado para o cenário' ||
             L_PERIODO.NOCENARIO || ', período ' || PNRPERIODO,
             'Utilize a manutenção de período contábil, opção ajuste de período para habilitar o período',
             SYSDATE,
             NULL);
          VCDSITUACAO := 'PE';
        ELSE
          VCDSITUACAO := 'OK';
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
    END LOOP;
    FOR L_CE IN (SELECT ILC.*
                   FROM TI_ITEM_LANCAMENTO_CTBL ILC, TI_LOTE_CTBL LC
                  WHERE LC.NRSEQ_CONTROLE_INTEGRACAO =
                        ILC.NRSEQ_CONTROLE_INTEGRACAO
                    AND ILC.NRSEQ_CONTROLE_INTEGRACAO =
                        PNRSEQ_CONTROLE_INTEGRACAO
                    AND ILC.COD_CCUSTO <> ' '
                    AND EXISTS
                  (SELECT 1
                           FROM CCUSTO P
                          WHERE P.COD_CCUSTO = ILC.COD_CCUSTO
                            AND LC.DAT_LOTE_CTBL NOT BETWEEN P.DAT_INIC_VALID AND
                                P.DAT_FIM_VALID)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'TI_LOTE_CTBL',
           'O Lançamento contábil esta com um centro de custo fora da validade. ' ||
           L_CE.COD_CTA_CTBL || ' C/C ' || L_CE.COD_CCUSTO,
           'Verifique o cadastro do plano de centro de custos',
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    --- Cenário exclusivo
    FOR L_CE IN (SELECT ILC.*
                   FROM TI_ITEM_LANCAMENTO_CTBL ILC, TI_LOTE_CTBL LC
                  WHERE LC.NRSEQ_CONTROLE_INTEGRACAO =
                        ILC.NRSEQ_CONTROLE_INTEGRACAO
                    AND ILC.NRSEQ_CONTROLE_INTEGRACAO =
                        PNRSEQ_CONTROLE_INTEGRACAO
                    AND EXISTS
                  (SELECT 1
                           FROM CTA_CTBL CC
                          WHERE CC.COD_CENAR_CTBL_EXCLUS <> ' '
                            AND CC.COD_PLANO_CTA_CTBL = LC.COD_PLANO_CTA_CTBL
                            AND CC.COD_CTA_CTBL = ILC.COD_CTA_CTBL)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'TI_LOTE_CTBL',
           'CENÁRIO EXCLUSIVO INFORMADO PARA A CONTA CONTÁBIL ' ||
           L_CE.COD_CTA_CTBL,
           'No cadastro de manutenção da conta contábil não pode ser informado o cenário',
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    --============================--
    -- Cta necessário cCusto      --
    -- Alessandro 18/08/2014      --
    --------------------------------
    FOR C_CTA IN (SELECT DISTINCT A.COD_CTA_CTBL, A.COD_ESTAB, A.COD_CCUSTO
                    FROM EMS506UNICOO.TI_ITEM_LANCAMENTO_CTBL A
                   WHERE A.NRSEQ_CONTROLE_INTEGRACAO =
                         PNRSEQ_CONTROLE_INTEGRACAO
                     AND SUBSTR(A.COD_CTA_CTBL, 1, 1) NOT IN ('1', '2')
                     AND EXISTS
                   (SELECT 1
                            FROM CRITERDISTRIBCTACTBL CD
                           WHERE CD.U##COD_CTA_CTBL = A.COD_CTA_CTBL
                             AND CD.U##COD_ESTAB = A.COD_ESTAB)
                     AND NOT EXISTS
                   (SELECT 1
                            FROM EMS506UNICOO.TI_CENTRO_CUSTO_CTBL CCC
                           WHERE CCC.COD_CTA_CTBL = A.COD_CTA_CTBL
                             AND CCC.COD_ESTAB = A.COD_ESTAB
                             AND CCC.COD_CCUSTO = A.COD_CCUSTO)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'TI_CENTRO_CUSTO_CTBL',
           'Falta DePara de Conta Para Centro Custo',
           'Consta no TOTVS11 centro de custo para Conta ' ||
           C_CTA.COD_CTA_CTBL || ' Estab. ' || C_CTA.COD_ESTAB ||
           ' na tabela TI_CENTRO_CUSTO_CTBL',
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    --=================================================--
    -- Restrição centro de custo por estabelecimento   --
    -- Alessandro 18/08/2014                           --
    -----------------------------------------------------
    FOR C_CTA IN (SELECT CCC.COD_CCUSTO, CCC.COD_ESTAB
                    FROM EMS506UNICOO.TI_ITEM_LANCAMENTO_CTBL CCC
                   WHERE CCC.NRSEQ_CONTROLE_INTEGRACAO =
                         PNRSEQ_CONTROLE_INTEGRACAO
                     AND EXISTS
                   (SELECT 1
                            FROM RESTRIC_CCUSTO RC
                           WHERE RC.U##COD_CCUSTO = CCC.COD_CCUSTO
                             AND RC.U##COD_ESTAB = CCC.COD_ESTAB)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'Restrição CCusto',
           'Há restrição de Estabelecimento para Centro de Custo',
           'Consta no TOTVS11 restrição do Estabelecimento :' ||
           C_CTA.COD_ESTAB || ' p/ CCusto ' || C_CTA.COD_CCUSTO,
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    --=================================================--
    -- Cta Unicoo x TOTVS11                            --
    -- Alessandro 18/08/2014                           --
    -----------------------------------------------------
    FOR C_CTA IN (SELECT DISTINCT A.COD_CTA_CTBL,
                                  XX.NOCONTA,
                                  EMS506UNICOO.F_TI_PARAMETRO_INTEGRACAO('NRPLANO_CONTA_UNICOO') PL_UNICOO
                    FROM EMS506UNICOO.TI_ITEM_LANCAMENTO_CTBL A,
                         CONTA_CONTABIL                       XX
                   WHERE A.NRSEQ_CONTROLE_INTEGRACAO =
                         PNRSEQ_CONTROLE_INTEGRACAO
                     AND XX.NRPLANO_CONTAS =
                         EMS506UNICOO.F_TI_PARAMETRO_INTEGRACAO('NRPLANO_CONTA_UNICOO')
                     AND XX.CDCONTA = A.COD_CTA_CTBL
                     AND NOT EXISTS
                   (SELECT 1
                            FROM CTA_CTBL CC
                           WHERE CC.U##COD_CTA_CTBL = A.COD_CTA_CTBL
                             AND F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CTA_CTBL') =
                                 CC.U##COD_PLANO_CTA_CTBL)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'Falta Conta',
           'Há Conta Contábil no Unicoo e não cadastrada no TOTVS11',
           'Consta no Unicoo a Conta Contábil :' || C_CTA.COD_CTA_CTBL ||
           ' Desc.:  ' || C_CTA.NOCONTA || ' Plano no Unicoo.:  ' ||
           C_CTA.PL_UNICOO,
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    --=================================================--
    -- CCusto existe TOTVS11                           --
    -- Alessandro 18/08/2014                           --
    -----------------------------------------------------
    FOR C_CTA IN (SELECT CCC.COD_CCUSTO
                    FROM EMS506UNICOO.TI_ITEM_LANCAMENTO_CTBL CCC
                   WHERE CCC.NRSEQ_CONTROLE_INTEGRACAO =
                         PNRSEQ_CONTROLE_INTEGRACAO
                     AND CCC.COD_CCUSTO <> ' '
                     AND NOT EXISTS
                   (SELECT 1
                            FROM CCUSTO CC
                           WHERE CC.U##COD_PLANO_CCUSTO =
                                 EMS506UNICOO.F_TI_PARAMETRO_INTEGRACAO('COD_PLANO_CCUSTO')
                             AND CC.U##COD_CCUSTO = CCC.COD_CCUSTO)) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'Falta CCusto',
           'Há Centro de Custo no Unicoo e não cadastrada no TOTVS11',
           'Consta no Unicoo o Centro de Custo: ' || C_CTA.COD_CCUSTO,
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    --=================================================--
    -- Centro Custo sem Unidade                        --
    -- Alessandro 18/08/2014                           --
    -----------------------------------------------------
    FOR C_CTA IN (SELECT COD_CCUSTO
                    FROM (SELECT A.U##COD_CCUSTO COD_CCUSTO,
                                 (SELECT B.U##COD_UNID_NEGOC
                                    FROM CCUSTO_UNID_NEGOC B
                                   WHERE B.U##COD_CCUSTO = A.U##COD_CCUSTO) CDUNID
                            FROM CCUSTO                               A,
                                 EMS506UNICOO.TI_ITEM_LANCAMENTO_CTBL CCC
                           WHERE A.U##COD_CCUSTO = CCC.COD_CCUSTO
                             AND CCC.NRSEQ_CONTROLE_INTEGRACAO =
                                 PNRSEQ_CONTROLE_INTEGRACAO) XX
                   WHERE XX.CDUNID IS NULL) LOOP
      BEGIN
        INSERT INTO TI_FALHA_DE_PROCESSO
          (NRSEQUENCIAL,
           NRSEQ_CONTROLE_INTEGRACAO,
           CDINTEGRACAO,
           TXFALHA,
           TXAJUDA,
           DTFALHA,
           NRMENSAGEM)
        VALUES
          (SQ_TI_FALHA_DE_PROCESSO.NEXTVAL,
           PNRSEQ_CONTROLE_INTEGRACAO,
           'Falta CCusto sem Unidade',
           'Centro de Custo está sem Unidade de Negocio no TOTVS11',
           'Centro de Custo: ' || C_CTA.COD_CCUSTO ||
           ' está sem Unidade de Negocio.',
           SYSDATE,
           NULL);
      EXCEPTION
        WHEN OTHERS THEN
          RAISE_APPLICATION_ERROR(-20001,
                                  PNRSEQ_CONTROLE_INTEGRACAO ||
                                  'TI_LOTE_CTBL ' || SQLERRM);
      END;
      VCDSITUACAO := 'PE';
    END LOOP;
    IF VCDSITUACAO <> 'OK' THEN
      UPDATE TI_LOTE_CTBL LC
         SET LC.CDSITUACAO = 'PE'
       WHERE LC.NRSEQ_CONTROLE_INTEGRACAO = PNRSEQ_CONTROLE_INTEGRACAO;
    END IF;
    /*select
        cod_cta_ctbl,
        cod_ccusto,
        i.cod_estab,
        i.cod_empresa,
        i.ind_natur_lancto_ctbl
    from
         ti_item_lancamento_ctbl i where i.nrseq_controle_integracao = 7192465
         and
         I.COD_CCUSTO <>' '
         AND
         not exists (
                select 1
                from
                    criterdistribctactbl a,
                    mapa_distrib_ccusto m,
                    item_lista_ccusto ic
                where
                     ic.cod_ccusto=i.cod_ccusto
                     and
                     ic.codmapadistribccusto=m.codmapadistribccusto
                     and
                     m.codmapadistribccusto=a.codmapadistribccusto
                     and
                     a.cod_cta_ctbl=i.cod_cta_ctbl
                     and
                     i.dat_lancto between a.dat_inic_valid and a.dat_fim_valid)
    */
  END;

  PROCEDURE P_TI_MOVIMENTO_CTA_CORRENTE(PNRSEQ_CONTROLE_INTEGRACAO NUMBER,
                                        PNRSESSAO                  NUMBER,
                                        PCDSITUACAO                IN OUT VARCHAR2) IS
    CURSOR C_INTEGRA_CMG IS
      SELECT CI.NRSEQUENCIAL NRSEQ_CONTROLE_INTEGRACAO,
             CI.CDSITUACAO,
             CI.CDIDENTIFICADOR,
             CI.NRSEQUENCIAL_ORIGEM
        FROM TI_CONTROLE_INTEGRACAO CI
       WHERE CI.NRSESSAO = PNRSESSAO
         AND CI.TPINTEGRACAO = 'CX'
         AND CI.CDSITUACAO = PCDSITUACAO
         AND (CI.NRSEQUENCIAL = PNRSEQ_CONTROLE_INTEGRACAO OR
             PNRSEQ_CONTROLE_INTEGRACAO = 0);
    VCDINTEGRACAO VARCHAR2(100);
  BEGIN
    FOR L_INTEGRA_CMG IN C_INTEGRA_CMG LOOP
      BEGIN
        PCDSITUACAO   := 'RC';
        VCDINTEGRACAO := 'TI_MOV_CTA_CORREN';
        INSERT INTO TI_MOVIMENTO_CTA_CORRENTE
          (NRSEQ_CONTROLE_INTEGRACAO,
           CDSITUACAO,
           COD_CTA_CORREN,
           DAT_MOVTO_CTA_CORREN,
           IND_TIP_MOVTO_CTA_CORREN,
           COD_TIP_TRANS_CX,
           IND_FLUXO_MOVTO_CTA_CORREN,
           COD_CENAR_CTBL,
           COD_HISTOR_PADR,
           VAL_MOVTO_CTA_CORREN,
           COD_DOCTO_MOVTO_CTA_BCO,
           COD_MODUL_DTSUL,
           IND_ERRO_VALID,
           DES_HISTOR_PADR,
           NUM_ID_MOVTO_CTA_CORREN)
          SELECT MCT.NRSEQ_CONTROLE_INTEGRACAO,
                 MCT.CDSITUACAO,
                 MCT.COD_CTA_CORREN,
                 MCT.DAT_MOVTO_CTA_CORREN,
                 MCT.IND_TIP_MOVTO_CTA_CORREN,
                 MCT.COD_TIP_TRANS_CX,
                 MCT.IND_FLUXO_MOVTO_CTA_CORREN,
                 MCT.COD_CENAR_CTBL,
                 MCT.COD_HISTOR_PADR,
                 MCT.VAL_MVTO_CTA_CORREN,
                 MCT.COD_DOCTO_MOVTO_CTA_BCO,
                 MCT.COD_MODUL_DTSUL,
                 MCT.IND_ERRO_VALID,
                 MCT.DES_HISTOR_PADR,
                 MCT.NUM_ID_MOVTO_CTA_CORREN
            FROM V_TI_MOVIMENTO_CTA_CORRENTE MCT
           WHERE NRSEQ_CONTROLE_INTEGRACAO =
                 L_INTEGRA_CMG.NRSEQ_CONTROLE_INTEGRACAO;
        IF SQL%ROWCOUNT = 0 THEN
          IF PCDSITUACAO = 'RC' THEN
            P_GRAVA_FALHA(L_INTEGRA_CMG.NRSEQ_CONTROLE_INTEGRACAO,
                          VCDINTEGRACAO,
                          'A VIEW V_TI_MOVIMENTO_CTA_CORRENTE N?O ENCONTROU MOVIMENTO CAIXA PARA O PROCESSO ==> ' ||
                          L_INTEGRA_CMG.NRSEQ_CONTROLE_INTEGRACAO ||
                          'NRMOVIMENTO ==> ' ||
                          L_INTEGRA_CMG.NRSEQUENCIAL_ORIGEM,
                          NULL,
                          PCDSITUACAO,
                          NULL);
          END IF;
        END IF;
      EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
          P_GRAVA_FALHA(L_INTEGRA_CMG.NRSEQ_CONTROLE_INTEGRACAO,
                        VCDINTEGRACAO,
                        'O MOVIMENTO JA FOI ENVIADO PARA A TI_MOVIMENTO_CTA_CORRENTE ',
                        NULL,
                        PCDSITUACAO,
                        -1);
        WHEN OTHERS THEN
          P_GRAVA_FALHA(PNRSEQ_CONTROLE_INTEGRACAO,
                        VCDINTEGRACAO,
                        'ERRO AO INCLUIR MOVIMENTO CAIXA NA TABELA TI_MOVIMENTO_CTA_CORRENTE ==> ' ||
                        SQLERRM || ' PROCESSO ==> ' ||
                        L_INTEGRA_CMG.NRSEQ_CONTROLE_INTEGRACAO ||
                        'NRMOVIMENTO ==> ' ||
                        L_INTEGRA_CMG.NRSEQUENCIAL_ORIGEM,
                        NULL,
                        PCDSITUACAO,
                        NULL);
      END;
      --====================================--
      -- Atualizar o situac?o da integrac?o --
      ----------------------------------------
      P_UPDATE_CONTROLE_INTEGRACAO(L_INTEGRA_CMG.NRSEQ_CONTROLE_INTEGRACAO,
                                   PCDSITUACAO,
                                   NULL);
    END LOOP;
  END;

  PROCEDURE P_INSERE_FORNECEDOR(PNRREGISTRO_TITULO IN NUMBER) IS
    CURSOR C_PES IS
      SELECT 'FN' PTPINTEGRACAO,
             'I' PCDACAO,
             P.NRCGC_CPF PNRCGC_CPF,
             P.NOPESSOA PNOPESSOA,
             P.NOABREVIADO,
             P.DTNASCIMENTO PDTNASCIMENTO,
             P.TPPESSOA PTPPESSOA,
             P.NRREGISTRO PNRREGISTRO,
             'FORNECEDOR' PTPORIGEM,
             F.CDFORNECEDOR PCDIDENTIFICADOR,
             F.NRREGISTRO_FORNECEDOR PNRSEQUENCIAL_ORIGEM,
             '' PCDMODULO,
             TP.CDEMPRESA PCDEMPRESA,
             '' PNRSEQ_CONTROLE_INTEGRACAO_ORG,
             '' PNOABREVIADO_FORNECEDOR,
             '' PCDN_FORNECEDOR,
             '' PNOABREVIADO_CLIENTE,
             '' PCDN_CLIENTE,
             'S' PAODEFINEPESSOA
        FROM PRODUCAO.FORNECEDOR@UNICOO_HOMOLOGA F,
             PESSOA                              P,
             TITULO_A_PAGAR                      TP
       WHERE TP.CDFORNECEDOR = F.CDFORNECEDOR
         AND F.NRREGISTRO_FORNECEDOR = P.NRREGISTRO
         AND TP.NRREGISTRO_TITULO = PNRREGISTRO_TITULO;
  BEGIN
    FOR X IN C_PES LOOP
      PCK_EMS506UNICOO.P_DEFINE_TI_PESSOA(X.PNRCGC_CPF,
                                          X.PNOPESSOA,
                                          X.NOABREVIADO,
                                          X.PDTNASCIMENTO,
                                          X.PTPPESSOA,
                                          X.PNRREGISTRO,
                                          X.PTPORIGEM,
                                          X.PNOABREVIADO_FORNECEDOR,
                                          X.PCDN_FORNECEDOR,
                                          X.PNOABREVIADO_CLIENTE,
                                          X.PCDN_CLIENTE,
                                          X.PAODEFINEPESSOA);
      EMS506UNICOO.PCK_EMS506UNICOO.P_INS_TI_CONTROLE_INTEGRACAO(X.PTPINTEGRACAO,
                                                                 X.PCDACAO,
                                                                 X.PCDIDENTIFICADOR,
                                                                 X.PNRSEQUENCIAL_ORIGEM,
                                                                 X.PCDMODULO,
                                                                 X.PCDEMPRESA,
                                                                 X.PNRSEQ_CONTROLE_INTEGRACAO_ORG);
    END LOOP;
  END;

  PROCEDURE P_INSERE_CLIENTE(PNRREGISTRO_TITULO IN NUMBER) IS
    CURSOR C_CLI IS
      SELECT 'CL' PTPINTEGRACAO,
             'I' PCDACAO,
             P.NRCGC_CPF VNRCGC_CPF,
             P.NOPESSOA VNOPESSOA,
             P.NOABREVIADO,
             P.DTNASCIMENTO VDTNASCIMENTO,
             P.TPPESSOA VTPPESSOA,
             C.NRREGISTRO_CLIENTE PNRSEQUENCIAL_ORIGEM,
             C.CDCLIENTE PCDIDENTIFICADOR,
             'CLIENTE',
             '' VNOM_ABREV_FORNECEDOR,
             '' VCDN_FORNECEDOR,
             '' VNOM_ABREV_CLIENTE,
             '' VCDN_CLIENTE,
             TR.CDEMPRESA PCDEMPRESA,
             '' PNRSEQ_CONTROLE_INTEGRACAO_ORG,
             '' PCDMODULO
        FROM PRODUCAO.CLIENTE@UNICOO_HOMOLOGA C,
             PESSOA                           P,
             TITULO_A_RECEBER                 TR
       WHERE C.NRREGISTRO_CLIENTE = P.NRREGISTRO
         AND TR.CDCLIENTE = C.CDCLIENTE
         AND TR.NRREGISTRO_TITULO = PNRREGISTRO_TITULO;
  BEGIN
    FOR X IN C_CLI LOOP
      P_DEFINE_TI_PESSOA(X.VNRCGC_CPF,
                         X.VNOPESSOA,
                         X.NOABREVIADO,
                         X.VDTNASCIMENTO,
                         X.VTPPESSOA,
                         X.PNRSEQUENCIAL_ORIGEM,
                         'CLIENTE',
                         X.VNOM_ABREV_FORNECEDOR,
                         X.VCDN_FORNECEDOR,
                         X.VNOM_ABREV_CLIENTE,
                         X.VCDN_CLIENTE,
                         'S');
      EMS506UNICOO.PCK_EMS506UNICOO.P_INS_TI_CONTROLE_INTEGRACAO(X.PTPINTEGRACAO,
                                                                 X.PCDACAO,
                                                                 X.PCDIDENTIFICADOR,
                                                                 X.PNRSEQUENCIAL_ORIGEM,
                                                                 X.PCDMODULO,
                                                                 X.PCDEMPRESA,
                                                                 X.PNRSEQ_CONTROLE_INTEGRACAO_ORG);
    END LOOP;
  END;

  procedure P_CARGA_PESSOA_UNIMED IS
    --------------------------------------
    -- gerar carga de pessoa do unimeds
    --------------------------------------
    cursor c_pes is
      select distinct 'FN' ptpintegracao,
                      'I' pcdacao,
                      nvl(p.nrcgc_cpf, '00000000000000') pnrcgc_cpf,
                      p.nopessoa pnopessoa,
                      p.noabreviado,
                      p.dtnascimento pdtnascimento,
                      p.tppessoa ptppessoa,
                      p.nrregistro pnrregistro,
                      'UNIMED' ptporigem,
                      f.cdfornecedor pcdidentificador,
                      p.nrregistro pnrsequencial_origem,
                      '' pcdmodulo,
                      '' pcdempresa,
                      '' pnrseq_controle_integracao_org,
                      '' pnoabreviado_fornecedor,
                      '' pcdn_fornecedor,
                      '' pnoabreviado_cliente,
                      '' pcdn_cliente,
                      'S' paodefinepessoa
        from producao.fornecedor@unicoo_homologa f,
             pessoa                              p,
             area_de_acao                        aa
       where f.nrregistro_fornecedor = p.nrregistro
            --and f.nrregistro_fornecedor not in (1976,1075,1628)
            --and f.cdsituacao_fornecedor = 'A'
            --and aa.nrregistro_pessoa   = f.nrregistro_fornecedor
         and aa.cdprestador = f.cdfornecedor
         and not exists (select 1
                from ti_controle_integracao ci
               where ci.cdidentificador = aa.cdprestador
                 and ci.tpintegracao = 'FN');
    vcommit number;
  begin
    vcommit := 1;

    for x in c_pes loop
      begin
        pck_ems506unicoo.p_define_ti_pessoa(x.pnrcgc_cpf,
                                            x.pnopessoa,
                                            x.noabreviado,
                                            x.pdtnascimento,
                                            x.ptppessoa,
                                            x.pnrregistro,
                                            x.ptporigem,
                                            x.pnoabreviado_fornecedor,
                                            x.pcdn_fornecedor,
                                            x.pnoabreviado_cliente,
                                            x.pcdn_cliente,
                                            x.paodefinepessoa);

      exception
        when others then
          raise_application_error(-20100,
                                  ' Pessoa :' || x.pnrsequencial_origem || ' ' ||
                                  sqlerrm);
          null;
      end;

      ems506unicoo.pck_ems506unicoo.p_ins_ti_controle_integracao(x.ptpintegracao,
                                                                 x.pcdacao,
                                                                 x.pcdidentificador,
                                                                 x.pnrsequencial_origem,
                                                                 x.pcdmodulo,
                                                                 x.pcdempresa,
                                                                 x.pnrseq_controle_integracao_org);

      if vcommit >= 500 then
        --Commit;
        vcommit := 1;
      else
        vcommit := vcommit + 1;
      end if;
    end loop;
    --commit;

    P_JOB;

    --COMMIT;

    P_COD_UNIMED_FORNECEDOR;

    --COMMIT;

  end P_CARGA_PESSOA_UNIMED;

  procedure P_COD_UNIMED_FORNECEDOR is
    cursor c_for is
      select distinct f.nrpessoa, a.cdareaacao
        from ti_fornecedor                       f,
             area_de_acao                        a,
             producao.fornecedor@unicoo_homologa xx
       where f.nrpessoa = xx.nrregistro_fornecedor
         and xx.cdfornecedor = a.cdprestador
         and f.cdsituacao = 'RC';

  begin
    for x in c_for loop

      update ti_pessoa p
         set p.cdn_fornecedor = x.cdareaacao, P.CDN_CLIENTE = X.cdareaacao
       where p.nrregistro = x.nrpessoa;

      update ti_fornecedor f
         set f.cod_fornecedor = x.cdareaacao
       where f.nrpessoa = x.nrpessoa;

    end loop;
    --commit;
  end P_COD_UNIMED_FORNECEDOR;

  PROCEDURE P_CARGA_INICIAL_FORNECEDOR IS
    hash_atual varchar2(100);
    hash_anterior varchar2(100);
    --------------------------------------
    -- gerar carga de pessoa do fornecedor
    --------------------------------------
    
    cursor c_pes is
      --1a parte: relaciona os FORNECEDORES que estao em TI_MATRIZ_PAGAR (possuem titulo)
      select distinct 'FN' ptpintegracao,
                      'I' pcdacao,
                      nvl(trim(replace(replace(replace(p.nrcgc_cpf,
                                                       '-',
                                                       null),
                                               ',',
                                               null),
                                       '.',
                                       null)),
                          '00000000000000') pnrcgc_cpf,
                      p.nopessoa pnopessoa,
                      p.noabreviado,
                      p.dtnascimento pdtnascimento,
                      p.tppessoa ptppessoa,
                      p.nrregistro pnrregistro,
                      'FORNECEDOR' ptporigem,
                      f.cdfornecedor pcdidentificador,
                      f.nrregistro_fornecedor pnrsequencial_origem,
                      '' pcdmodulo,
                      '' pcdempresa,
                      '' pnrseq_controle_integracao_org,
                      '' pnoabreviado_fornecedor,
                      '' pcdn_fornecedor,
                      '' pnoabreviado_cliente,
                      '' pcdn_cliente,
                      'S' paodefinepessoa
        from producao.fornecedor@unicoo_homologa f,
             pessoa                              p,
             ti_matriz_pagar                     tm
       where f.nrregistro_fornecedor = p.nrregistro
         and p.nrregistro = tm.nrregistro
         and tm.cdfornecedor = f.cdfornecedor
         and not exists (select 1
                from ti_controle_integracao ci
               where ci.cdidentificador = f.cdfornecedor
                 and ci.tpintegracao = 'FN')
      union all
      --2a parte: relaciona FORNECEDORES que nao possuem titulos, desde que nao estejam
      --          associados ao grupo NAOM no DEPARA TI_GRUPO_DE_FORNECEDOR
      select distinct 'FN' ptpintegracao,
                      'I' pcdacao,
                      nvl(trim(replace(replace(replace(p.nrcgc_cpf,
                                                       '-',
                                                       null),
                                               ',',
                                               null),
                                       '.',
                                       null)),
                          '00000000000000') pnrcgc_cpf,
                      p.nopessoa pnopessoa,
                      p.noabreviado,
                      p.dtnascimento pdtnascimento,
                      p.tppessoa ptppessoa,
                      p.nrregistro pnrregistro,
                      'FORNECEDOR' ptporigem,
                      f.cdfornecedor pcdidentificador,
                      f.nrregistro_fornecedor pnrsequencial_origem,
                      '' pcdmodulo,
                      '' pcdempresa,
                      '' pnrseq_controle_integracao_org,
                      '' pnoabreviado_fornecedor,
                      '' pcdn_fornecedor,
                      '' pnoabreviado_cliente,
                      '' pcdn_cliente,
                      'S' paodefinepessoa
        from producao.fornecedor@unicoo_homologa f,
             pessoa                              p,
             ti_grupo_de_fornecedor              tif
       where f.nrregistro_fornecedor = p.nrregistro
         and tif.cdgrupo_fornecedor = f.cdgrupo_fornecedor
         and tif.cod_grp_fornecedor <> 'NAOM'
         -- descarta os casos que estao em TI_MATRIZ_PAGAR, pois ja foram relacionados no select anterior
         and not exists
       (select 1
                from ti_matriz_pagar tm
               where tm.nrregistro = f.nrregistro_fornecedor)
               
         and not exists (select 1
                from ti_controle_integracao ci
               where ci.cdidentificador = f.cdfornecedor
                 and ci.tpintegracao = 'FN')
       order by pnrregistro desc;

    vcommit number;
  begin
    --dbms_output.enable(null);
    dbms_output.disable;  
  
    --apagar TI_FORNECEDOR com erro para reprocessamento
    delete from ti_falha_de_processo tf
     where exists (select 1
              from ti_controle_integracao tc
             where tf.nrseq_controle_integracao = tc.nrsequencial
               and tc.tpintegracao = 'FN'
               and tc.cdsituacao in ('PE', 'ER'));
    delete from ti_fornecedor c where c.cdsituacao IN ('PE', 'ER');
  
    --apagar TI_FORNECEDOR caso o hash do registro original do Unicoo tenha mudado.
    --isso fara com que o registro seja atualizado no TOTVS na proxima execucao da api progress.
    for x in (select c.cdidentificador, c.nrsequencial_origem, f.nrseq_controle_integracao,
                     f.cod_fornecedor, f.nrpessoa
                from ti_fornecedor f, ti_controle_integracao c
               where f.nrseq_controle_integracao = c.nrsequencial
                 and f.cdsituacao = 'IT') loop
        hash_atual := gerar_hash_fornecedor_unicoo(x.cdidentificador, x.nrsequencial_origem);
        hash_anterior := get_hash('FN',x.cdidentificador, x.nrsequencial_origem);
        
        if hash_atual <> hash_anterior then
          dbms_output.put_line('DIFERENTE. APAGAR! ' || x.nrseq_controle_integracao || ';' || x.cod_fornecedor || ';' || x.nrpessoa || ';' || hash_atual || ';' || hash_anterior);
          
          delete from ti_fornecedor tf where tf.nrseq_controle_integracao = x.nrseq_controle_integracao;
        else
          dbms_output.put_line('IGUAL. MANTER. ' || x.nrseq_controle_integracao || ';' || x.cod_fornecedor || ';' || x.nrpessoa || ';' || hash_atual || ';' || hash_anterior);
        end if;
    end loop;
    
    --recriar a matriz de titulos, pois a situacao pode ter mudado no Unicoo
    p_gera_carga_matriz_apb;
    
    --atualizar com dados dos fornecedores que sao UNIMED
    P_CARGA_PESSOA_UNIMED;

    vcommit := 1;
    for x in c_pes loop
      begin
        pck_ems506unicoo.p_define_ti_pessoa(x.pnrcgc_cpf,
                                            x.pnopessoa,
                                            x.noabreviado,
                                            x.pdtnascimento,
                                            x.ptppessoa,
                                            x.pnrregistro,
                                            x.ptporigem,
                                            x.pnoabreviado_fornecedor,
                                            x.pcdn_fornecedor,
                                            x.pnoabreviado_cliente,
                                            x.pcdn_cliente,
                                            x.paodefinepessoa);

      exception
        when others then
          --raise_application_error(-20100,' Pessoa :'||x.pnrsequencial_origem||' '||sqlerrm);
          null;
      end;

      ems506unicoo.pck_ems506unicoo.p_ins_ti_controle_integracao(x.ptpintegracao,
                                                                 x.pcdacao,
                                                                 x.pcdidentificador,
                                                                 x.pnrsequencial_origem,
                                                                 x.pcdmodulo,
                                                                 x.pcdempresa,
                                                                 x.pnrseq_controle_integracao_org);

      if vcommit >= 500 then
        --Commit;
        vcommit := 1;
      else
        vcommit := vcommit + 1;
      end if;
    end loop;
    --commit;

    p_job;

    --COMMIT;

  end P_CARGA_INICIAL_FORNECEDOR;

  PROCEDURE P_CARGA_INICIAL_CLIENTE IS
    hash_atual varchar2(100);
    hash_anterior varchar2(100);
    ----------------------------------
    -- Gerar pessoa cliente integração
    ----------------------------------

    cursor c_cli is
      select nvl(trim(replace(replace(replace(p.nrcgc_cpf, '-', null),
                                      ',',
                                      null),
                              '.',
                              null)),
                 '00000000000000') nrcgc_cpf,
             p.nopessoa nopessoa,
             p.noabreviado,
             p.dtnascimento,
             p.tppessoa,
             c.nrregistro_cliente,
             'CLIENTE' tipo,
             '' vnom_abrev_fornecedor,
             '' vcdn_fornecedor,
             '' vnom_abrev_cliente,
             '' vcdn_cliente,
             'S' incluir,
             c.cdcliente
        from producao.cliente@unicoo_homologa c,
             pessoa                           p,
             ti_grupo_de_cliente              t
       where p.nrregistro = c.nrregistro_cliente
         and t.cdgrupo_cliente = c.cdgrupo_cliente
         and t.cdgrupo_cliente_ems_pj <> 'NAOM'
         -- teste Alex 26/02/17
         --and not exists (select 1
         --       from ti_matriz_receber tm
         --      where tm.nrregistro = p.nrregistro) fim teste Alex 26/02/17
         and not exists (select 1
                from ti_controle_integracao ci
               where ci.cdidentificador = c.cdcliente
                 and ci.tpintegracao = 'CL')
      --         and P.NRREGISTRO=2021
      /*teste Alex 27/02/17*/
      union all
      select nvl(trim(replace(replace(replace(p.nrcgc_cpf, '-', null),
                                      ',',
                                      null),
                              '.',
                              null)),
                 '00000000000000') nrcgc_cpf,
             p.nopessoa nopessoa,
             p.noabreviado,
             p.dtnascimento,
             p.tppessoa,
             c.nrregistro_cliente,
             'CLIENTE' tipo,
             '' vnom_abrev_fornecedor,
             '' vcdn_fornecedor,
             '' vnom_abrev_cliente,
             '' vcdn_cliente,
             'S' incluir,
             c.cdcliente
        from producao.cliente@unicoo_homologa c,
             pessoa                           p,
             ti_matriz_receber                tm
       where p.nrregistro = c.nrregistro_cliente
         and p.nrregistro = tm.nrregistro
         
         and tm.cdcliente = c.cdcliente

         and not exists (select 1
                from ti_controle_integracao ci
               where ci.cdidentificador = c.cdcliente
                 and ci.tpintegracao = 'CL') /*fim teste alex 27/02/17*/
    ;
    
    cursor c_carga_clientes is

    --Selecionar a pessoa do contratante que não é cliente
      select nrpessoa_paga, tppessoa
        from (select p.nrregistro nrpessoa_paga
                from contrato_da_pessoa p
               where not exists
               (select 1
                        from producao.cliente@unicoo_homologa c
                       where c.nrregistro_cliente = p.nrregistro)
              union

              --selecionar pessoa que paga da familia (aposentado/demitido) que não é cliente
              select nvl(f.nrpessoa_paga, f.nrpessoa_titular) nrregistro
                from familia f
               where f.dtinicio_contrato is not null
                 and not exists
               (select 1
                        from producao.cliente@unicoo_homologa c
                       where c.nrregistro_cliente =
                             nvl(f.nrpessoa_paga, f.nrpessoa_titular))
              union

              --selecionar pessoa que paga que não é cliente
              select p2.nrpessoa_paga
                from contrato_da_pessoa p2
               where p2.nrpessoa_paga <> p2.nrregistro
                 and not exists
               (select 1
                        from producao.cliente@unicoo_homologa c2
                       where c2.nrregistro_cliente = p2.nrpessoa_paga)
              union

              --selecionar pessoa que paga que não é cliente e faturamento por familia (adesao)
              select nvl(f.nrpessoa_paga, f.nrpessoa_titular) nrregistro
                from contrato_da_pessoa p2, familia f, usuario u
               where p2.nrregistro = u.nrregistro
                 and p2.nrcontrato = u.nrcontrato
                 and f.nrregistro = u.nrregistro
                 and f.nrcontrato = u.nrcontrato
                 and f.nrfamilia = u.nrfamilia
                 and u.nrfamilia <> 0
                 and u.tpusuario = 00
                 and p2.tpfatura = 'U'
                 and not exists
               (select 1
                        from producao.cliente@unicoo_homologa c
                       where c.nrregistro_cliente =
                             nvl(f.nrpessoa_paga, f.nrpessoa_titular))
                             
              union

              --excecao para PLAMEC - eh contrato NORMAL no UNICOO mas tera CONTRATANTE ORIGEM no TOTVS
              select nvl(f.nrpessoa_paga, f.nrpessoa_titular) nrregistro
                from contrato_da_pessoa p2, familia f, usuario u, unicoogps.temp_depara_agrupado tda
               where p2.nrregistro = u.nrregistro
                 and p2.nrcontrato = u.nrcontrato
                 and f.nrregistro = u.nrregistro
                 and f.nrcontrato = u.nrcontrato
                 and f.nrfamilia = u.nrfamilia
                 and u.nrfamilia <> 0
                 and u.tpusuario = 00
                 and tda.cdcontrato = p2.cdcontrato_padrao
                 and tda.ao_contr_orig_resp_financ = 'CONTR_ORIG'
                 and not exists
               (select 1
                        from producao.cliente@unicoo_homologa c
                       where c.nrregistro_cliente =
                             nvl(f.nrpessoa_paga, f.nrpessoa_titular))
                             
              union
              
              --selecionar titulares da empresa do parj para virar clientes
              select nrregistro_usuario nrpessoa_paga
                from usuario us
               where nrfamilia <> 0
                 and tpusuario = 00
                 and unicoogps.f_tm_parametro('CONTRATO_PEA') like
                     '%' || us.nrcontrato || '%'
                 and not exists
               (select 1
                        from producao.cliente@unicoo_homologa cl
                       where cl.nrregistro_cliente = us.nrregistro_usuario)
              union

              --selecionar lotacoes para virarem clientes
              select a.nrpessoa_paga
                from (select nvl(l.nrpessoa_paga, l.nrregistro_lotacao) nrpessoa_paga,
                             l.nrcontrato,
                             p.nopessoa,
                             l.cdlotacao,
                             l.txdescricao,
                             cl.cdcliente cdcliente
                        from pessoa                           p,
                             lotacao                          l,
                             producao.cliente@unicoo_homologa cl,
                             contrato_da_pessoa               cdp
                       where p.nrregistro =
                             nvl(l.nrpessoa_paga, l.nrregistro_lotacao)
                         and cl.nrregistro_cliente(+) =
                             nvl(l.nrpessoa_paga, l.nrregistro_lotacao)
                         and cdp.nrregistro = l.nrregistro
                         and cdp.nrcontrato = l.nrcontrato
                         and cdp.tpfatura in ('L', 'I')) a
               where cdcliente is null) b,
             pessoa p
       where b.nrpessoa_paga = p.nrregistro;
    vcommit number;

  begin
    --dbms_output.enable(null);
    dbms_output.disable;

    --apagar TI_CLIENTE com erro para reprocessamento
    delete from ti_falha_de_processo tf
     where exists (select 1
              from ti_controle_integracao tc
             where tf.nrseq_controle_integracao = tc.nrsequencial
               and tc.tpintegracao = 'CL'
               and tc.cdsituacao in ('PE', 'ER'));
    delete from ti_cliente c where c.cdsituacao IN ('PE', 'ER');
  
    --apagar TI_CLIENTE caso o hash do registro original do Unicoo tenha mudado.
    --isso fara com que o registro seja atualizado no TOTVS na proxima execucao da api progress.
    for x in (select i.cdidentificador, i.nrsequencial_origem, c.nrseq_controle_integracao,
                     c.cod_cliente, c.nrpessoa
                from ti_cliente c, ti_controle_integracao i
               where c.nrseq_controle_integracao = i.nrsequencial
                 and c.cdsituacao = 'IT') loop
        hash_atual := gerar_hash_cliente_unicoo(x.cdidentificador, x.nrsequencial_origem);
        hash_anterior := get_hash('CL',x.cdidentificador, x.nrsequencial_origem);
        
        if hash_atual <> hash_anterior then
          dbms_output.put_line('DIFERENTE. APAGAR!' || x.nrseq_controle_integracao || ';' || x.cod_cliente || ';' || x.nrpessoa || ';' || hash_atual || ';' || hash_anterior);
          
          delete from ti_cliente tc where tc.nrseq_controle_integracao = x.nrseq_controle_integracao;
        else
          dbms_output.put_line('IGUAL. MANTER.' || x.nrseq_controle_integracao || ';' || x.cod_cliente || ';' || x.nrpessoa || ';' || hash_atual || ';' || hash_anterior);
        end if;
    end loop;
    
    --recriar a matriz de titulos, pois a situacao pode ter mudado no Unicoo
    p_gera_carga_matriz_acr;

    vcommit := 1;

    --Gera clientes no UNICOO para as pessoas que não são clientes
    --Ex: Titulares do PARJ, Lotacoes, etc
    FOR Y IN c_carga_clientes LOOP

      BEGIN
        PRODUCAO.p_gera_cliente@UNICOO_HOMOLOGA('M' || Y.NRPESSOA_PAGA,
                                                Y.NRPESSOA_PAGA,
                                                'M' || Y.NRPESSOA_PAGA,
                                                NULL,
                                                CASE
                                                  WHEN Y.TPPESSOA = 'F' THEN
                                                   'P'
                                                  ELSE
                                                   'E'
                                                END,
                                                NULL,
                                                'N');
      END;

    END LOOP;

    for x in c_cli loop
      begin
        ems506unicoo.pck_ems506unicoo.p_define_ti_pessoa(x.nrcgc_cpf,
                                                         x.nopessoa,
                                                         x.noabreviado,
                                                         x.dtnascimento,
                                                         x.tppessoa,
                                                         x.nrregistro_cliente,
                                                         x.tipo,
                                                         x.vnom_abrev_fornecedor,
                                                         x.vcdn_fornecedor,
                                                         x.vnom_abrev_cliente,
                                                         x.vcdn_cliente,
                                                         x.incluir);

      exception
        when others then
          raise_application_error(-20100,
                                  ' Pessoa : ' || x.nrregistro_cliente ||
                                  ' - ' || sqlerrm);
          null;
      end;

      ems506unicoo.PCK_EMS506UNICOO.P_INS_TI_CONTROLE_INTEGRACAO('CL',
                                                                 'I',
                                                                 x.cdcliente,
                                                                 x.NRREGISTRO_cliente,
                                                                 null,
                                                                 NULL,
                                                                 NULL);

      if vcommit >= 500 then
        --Commit;
        vcommit := 1;
      else
        vcommit := vcommit + 1;
      end if;
    end loop;
    --commit;

    P_JOB;

    --COMMIT;

  end P_CARGA_INICIAL_CLIENTE;

  procedure p_carga_tit_acr_fechado IS
    cursor c_tit is
      select 'TR' ptpintegracao,
             'F' pcdacao, --indentificacao que o titulo eh fechado
             t.nrdocumento pcdidentificador,
             t.nrregistro_titulo pnrsequencial_origem,
             '' pcdmodulo,
             t.cdempresa cdempresa,
             '' pnrseq_controle_integracao_org
        from titulo_a_receber t
       where not exists (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = t.nrregistro_titulo)
         and not exists
       (select 1
                from ti_controle_integracao x
               where x.tpintegracao = 'TR'
                 and x.nrsequencial_origem = t.nrregistro_titulo)
        and t.cdsituacao not in (0,6,8) --titulos abertos/desmembrados/cancelados não serão integrados
         --desconsiderar titulos da propria operadora e de 1a mensalidades pois causava duplicidade de codificacao.
         --ver detalhes na descricao dos parametros        
        and (   t.cdcliente <> f_ti_parametro_integracao('CDCLIENTE_1A_MENS')
             or t.cdhistorico <> f_ti_parametro_integracao('CDHISTORICO_1A_MENS'))
        and t.dttitulo >= PDT_INI_TITULOS_ACR_FECHADOS;

    vConta number;
  begin
    vConta := 0;
    for x in c_tit loop
      pck_ems506unicoo.p_ins_ti_controle_integracao(x.ptpintegracao,
                                                    x.pcdacao,
                                                    x.pcdidentificador,
                                                    x.pnrsequencial_origem,
                                                    x.pcdmodulo,
                                                    x.cdempresa,
                                                    x.pnrseq_controle_integracao_org);
      if vConta > 500 then
        commit;
        vConta := 0;
      end if;

      vConta := vConta + 1;

    end loop;
    commit;

    p_job;

    COMMIT;

  END p_carga_tit_acr_fechado;


  procedure p_carga_tit_acr IS
    aojaexiste varchar2(1);
    
    cursor c_tit is
      select 'TR' ptpintegracao,
             'I' pcdacao,
             t.nrdocumento pcdidentificador,
             t.nrregistro_titulo pnrsequencial_origem,
             '' pcdmodulo,
             t.cdempresa cdempresa,
             '' pnrseq_controle_integracao_org
        from producao.cliente@unicoo_homologa c,
             titulo_a_receber                 t,
             pessoa                           p
       where c.cdcliente = t.cdcliente
         and p.nrregistro = c.nrregistro_cliente
         and t.cdsituacao not in (6,8) --Titulos desmembrados/cancelados nao serao migrados
         and exists (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = t.nrregistro_titulo)
         and not exists
       (select 1
                from ti_controle_integracao x
               where x.tpintegracao = 'TR'
                 and x.nrsequencial_origem = t.nrregistro_titulo)
         --desconsiderar titulos da propria operadora e de 1a mensalidades pois causava duplicidade de codificacao.
         --ver detalhes na descricao dos parametros        
         and (   t.cdcliente <> f_ti_parametro_integracao('CDCLIENTE_1A_MENS')
              or t.cdhistorico <> f_ti_parametro_integracao('CDHISTORICO_1A_MENS'));

    vConta number;
  begin
    --apagar TI_TIT_ACR e TI_CX_BX_ACR com erro para reprocessamento
    for x in (select ci.nrsequencial from ti_controle_integracao ci 
               where ci.cdsituacao in ('PE','ER')
                 and ci.tpintegracao = 'TR') loop
        delete from ti_tit_acr tr where tr.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_acr_ctbl c where c.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_acr_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
    end loop;
    for x in (select ci.nrsequencial from ti_controle_integracao ci 
               where ci.cdsituacao in ('PE','ER') 
                 and ci.tpintegracao = 'BR') loop
        delete from ti_cx_bx_acr br where br.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
    end loop;
  
    --apagar TI_TIT_ACR caso seja titulo em aberto e possua historico de alteracao no unicoo mais 
    --recente que a ultima atualizacao no TOTVS
    --isso fara com que o registro seja atualizado no TOTVS na proxima execucao da api progress.
    for x in (select ci.nrsequencial from ti_controle_integracao ci 
               where ci.cdsituacao in ('IT')
                 and ci.tpintegracao = 'TR'
                 and exists (select 1
                        from ti_matriz_receber b
                       where b.nrregistro_titulo = ci.nrsequencial_origem)
                 and exists(select 1 from LG$_TITULO_A_receber l
                                    where l.dtatualizacao$$ > ci.dtintegracao
                                      and l.NRREGISTRO_TITULO = ci.nrsequencial_origem)) loop
        delete from ti_tit_acr tr where tr.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_acr_ctbl c where c.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_acr_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
    end loop;
  
    --na primeira vez que um titulo eh criado no EMS5, o processo cria esse registro.
    --esta sendo antecipado aqui, para evitar falha de chave durante a carga de titulos em varias filas
    --simultaneas pela api progress utb765zl.
    
    --PK: U##COD_MODUL_DTSUL, U##COD_PROG_DTSUL, U##COD_VERS_PROG, DAT_GERAC_MOVTO, U##HRA_GERAC_MOVTO
    begin
      select 'S' into aojaexiste
        from ems5.histor_exec_especial h
       where h.u##cod_modul_dtsul = 'ACR'
         and h.u##cod_prog_dtsul  = 'SPP_ACERTO_TIT_COMIS_REPRES'
         and rownum = 1;
    exception
      when others then
        aojaexiste := 'N';
    end;
      
    if aojaexiste = 'N' then
      begin
        insert into ems5.histor_exec_especial h(U##COD_MODUL_DTSUL,
                                                COD_MODUL_DTSUL,
                                                U##COD_PROG_DTSUL,
                                                COD_PROG_DTSUL,
                                                U##COD_VERS_PROG,
                                                COD_VERS_PROG,
                                                DAT_GERAC_MOVTO,
                                                U##HRA_GERAC_MOVTO,
                                                HRA_GERAC_MOVTO,
                                                COD_USUAR_GERAC_MOVTO,
                                                PROGRESS_RECID)
        values('ACR',
               'ACR',
               'SPP_ACERTO_TIT_COMIS_REPRES',
               'SPP_ACERTO_TIT_COMIS_REPRES',
               ' ',
               ' ',
               SYSDATE,
               ' ',
               ' ',
               'MIGRACAO',
               ems5.histor_exec_especial_seq.nextval);
        
      exception
          when others then
           null;
      end;
    end if;
    
    vConta := 0;
    for x in c_tit loop
      pck_ems506unicoo.p_ins_ti_controle_integracao(x.ptpintegracao,
                                                    x.pcdacao,
                                                    x.pcdidentificador,
                                                    x.pnrsequencial_origem,
                                                    x.pcdmodulo,
                                                    x.cdempresa,
                                                    x.pnrseq_controle_integracao_org);
      if vConta > 500 then
        --commit;
        vConta := 0;
      end if;

      vConta := vConta + 1;

    end loop;
    --commit;

    p_job;

    --COMMIT;
    
    if PMIGRAR_TITULOS_ACR_FECHADOS = 'S' then
      p_carga_tit_acr_fechado;
      P_CARGA_BAIXA_TIT_ACR;
    end if;
    commit;
  END p_carga_tit_acr;


procedure p_carga_baixa_tit_acr is

  temp_ti_cx_bx_acr           ti_cx_bx_acr%rowtype;
  vnrseq_controle             ti_controle_integracao.nrsequencial%type;
  pCD_PORTADOR_MOVIMENTOS     ti_parametro_integracao.cdparametro%type := f_ti_parametro_integracao('CD_PORTADOR_MOVIMENTOS');
  pCD_CTA_CORREN_MOVIMENTOS   ti_parametro_integracao.cdparametro%type := f_ti_parametro_integracao('CD_CTA_CORREN_MOVIMENTOS');
  temp_ti_controle_integracao ti_controle_integracao%rowtype;
  vcdsituacao                 ti_controle_integracao.cdsituacao%type;
  verro                       ti_falha_de_processo.txfalha%type;
  temp_ti_falha_de_processo   ti_falha_de_processo%rowtype;
  vexiste                     char;

  cursor c_titulos is

    select ttr.*, tr.nrregistro_titulo
      from ti_controle_integracao tc, titulo_a_receber tr, ti_tit_acr ttr
     where tc.nrsequencial_origem = tr.nrregistro_titulo
       and tc.cdidentificador = tr.nrdocumento
       and ttr.nrseq_controle_integracao = tc.nrsequencial
       --and ttr.cdsituacao = 'IT'
       and tr.cdsituacao <> 0;

  --Movimento 70 - Baixa normal de títulos
  cursor c_baixa_titulo(cnrregistro_titulo titulo_a_receber.nrregistro_titulo%type) is
    select h.dtmovimento       dt_baixa,
           decode(h.vlrecebido,null,h.vltitulo,0,h.vltitulo,h.vlrecebido) vl_recebido,
           h.vljuros,
           h.vlmulta,
           h.vldesconto,
           h.vlabatimento,
           h.vlir_fonte,
           h.nrregistro_titulo,
           tc.cdidentificador,
           h.nrmovimento
      from historico_do_titulo h, ti_controle_integracao tc
     where h.nrregistro_titulo = tc.nrsequencial_origem
       and h.nrregistro_titulo = cnrregistro_titulo
       and h.cdmovimento in (30, 70, 72, 76)
       and not exists
     (select 1
              from ti_cx_bx_acr tcr
             where tcr.nrmovimento_baixa = h.nrmovimento)
     order by tc.cdidentificador, h.dtmovimento;

begin

  for ct in c_titulos loop

    for cbaixa in c_baixa_titulo(ct.nrregistro_titulo) loop

      begin
        select 'S'
          into vexiste
          from ti_cx_bx_acr tcx
         where tcx.nrmovimento_baixa = cbaixa.nrmovimento;

      exception
        when no_data_found then
          select sq_ti_controle_integracao.nextval
            into vnrseq_controle
            from dual;

          vcdsituacao := 'RC';

          begin

            temp_ti_cx_bx_acr.nrseq_controle_integracao := vnrseq_controle;
            temp_ti_cx_bx_acr.cdsituacao                := vcdsituacao;
            temp_ti_cx_bx_acr.cod_cart_bcia             := ' ';
            temp_ti_cx_bx_acr.cod_cliente               := ct.cod_cliente;
            temp_ti_cx_bx_acr.cod_empresa               := ct.cod_empresa;
            temp_ti_cx_bx_acr.cod_espec_docto           := ct.cod_espec_docto;
            temp_ti_cx_bx_acr.cod_estab                 := ct.cod_estab;
            temp_ti_cx_bx_acr.cod_parcela               := ct.cod_parcela;
            temp_ti_cx_bx_acr.cod_portador              := pCD_PORTADOR_MOVIMENTOS;
            temp_ti_cx_bx_acr.cod_ser_docto             := ct.cod_ser_docto;
            temp_ti_cx_bx_acr.cod_tit_acr_bco           := ct.cod_tit_acr_bco;
            temp_ti_cx_bx_acr.cod_titulo_acr            := ct.cod_titulo_acr;
            temp_ti_cx_bx_acr.dat_baixa                 := cbaixa.dt_baixa;
            temp_ti_cx_bx_acr.dat_envio                 := cbaixa.dt_baixa;
            temp_ti_cx_bx_acr.dat_processamento         := sysdate;
            temp_ti_cx_bx_acr.des_text_histor           := ' ';
            temp_ti_cx_bx_acr.val_desconto              := nvl(cbaixa.vldesconto,0);
            temp_ti_cx_bx_acr.val_abatimento            := nvl(cbaixa.vlabatimento,0);
            temp_ti_cx_bx_acr.val_ir                    := nvl(cbaixa.vlir_fonte,0);
            temp_ti_cx_bx_acr.val_juros                 := nvl(cbaixa.vljuros,0);
            temp_ti_cx_bx_acr.val_multa                 := nvl(cbaixa.vlmulta,0);
            temp_ti_cx_bx_acr.val_liq_titulo            := cbaixa.vl_recebido;
            temp_ti_cx_bx_acr.val_titulo                := 0;
            temp_ti_cx_bx_acr.nrpessoa                  := 0;
            temp_ti_cx_bx_acr.nrregistro_titulo         := null;
            temp_ti_cx_bx_acr.nrmovimento_baixa         := cbaixa.nrmovimento;
            temp_ti_cx_bx_acr.nrdocumento               := cbaixa.cdidentificador;
            temp_ti_cx_bx_acr.nrnossonumero             := ct.cod_tit_acr_bco;
            temp_ti_cx_bx_acr.txhistorico               := null;
            temp_ti_cx_bx_acr.nrbanco                   := 0;
            temp_ti_cx_bx_acr.nragencia                 := 0;
            temp_ti_cx_bx_acr.nrconta_corrente          := pCD_CTA_CORREN_MOVIMENTOS;

            insert into TI_CX_BX_ACR values temp_TI_CX_BX_ACR;

          exception
            when others then
              vcdsituacao := 'ER';
              verro       := sqlerrm;

              select SQ_TI_FALHA_DE_PROCESSO.NEXTVAL
                into temp_ti_falha_de_processo.nrsequencial
                from dual;

              temp_ti_falha_de_processo.nrseq_controle_integracao := vnrseq_controle;
              temp_ti_falha_de_processo.cdintegracao              := 'BR';
              temp_ti_falha_de_processo.txfalha                   := verro;
              temp_ti_falha_de_processo.dtfalha                   := sysdate;
              temp_ti_falha_de_processo.txajuda                   := ' ';
              temp_ti_falha_de_processo.nrmensagem                := null;

              insert into ti_falha_de_processo
              values temp_ti_falha_de_processo;

          end;

          temp_ti_controle_integracao.nrsequencial                  := vnrseq_controle;
          temp_ti_controle_integracao.tpintegracao                  := 'BR';
          temp_ti_controle_integracao.dtgeracao                     := sysdate;
          temp_ti_controle_integracao.nrsequencial_origem           := ct.nrregistro_titulo;
          temp_ti_controle_integracao.dtprocessamento               := sysdate;
          temp_ti_controle_integracao.dtintegracao                  := null;
          temp_ti_controle_integracao.cdacao                        := 'I';
          temp_ti_controle_integracao.cdidentificador               := cbaixa.cdidentificador;
          temp_ti_controle_integracao.txobservacao                  := ' ';
          temp_ti_controle_integracao.cdsituacao                    := vcdsituacao;
          temp_ti_controle_integracao.nrseq_controle_integracao_org := null;
          temp_ti_controle_integracao.cdempresa                     := null;
          temp_ti_controle_integracao.cdmodulo                      := null;
          temp_ti_controle_integracao.cdmovimento                   := null;
          temp_ti_controle_integracao.nrsessao                      := null;
          temp_ti_controle_integracao.cddivisao                     := null;
          temp_ti_controle_integracao.cdcentro_custo                := null;
          temp_ti_controle_integracao.tpdocumento                   := null;

          insert into ti_controle_integracao
          values temp_ti_controle_integracao;

        p_commit;

      end;
    end loop;

  end loop;

  commit;

end p_carga_baixa_tit_acr;


  PROCEDURE p_carga_tit_apb IS
    --===================================================================================================
    ----------------------------------------
    -- gerar carga do titulos a pagar
    ----------------------------------------
    cursor c_tit is
      select 'TP' ptpintegracao,
             'I' pcdacao,
             t.nrdocumento pcdidentificador,
             t.nrregistro_titulo pnrsequencial_origem,
             '' pcdmodulo,
             t.cdempresa cdempresa,
             '' pnrseq_controle_integracao_org
        from producao.fornecedor@unicoo_homologa f,
             titulo_a_pagar                      t,
             pessoa                              p
       where t.cdfornecedor = f.cdfornecedor
         and f.nrregistro_fornecedor = p.nrregistro
         and t.cdsituacao <> 1 -- 10/05/18 - ALEX - TRATADO PARA IGNORAR 'TOTALMENTE PAGO' CONFORME ACORDADO COM UNIMED NI E THEALTH
         and exists (select 1
                from ti_matriz_pagar b
               where b.nrregistro_titulo = t.nrregistro_titulo)
         and not exists
       (select 1
                from ti_controle_integracao u
               where u.tpintegracao = 'TP'
                 and u.nrsequencial_origem = t.nrregistro_titulo)
         --RELACAO DOS HISTORICOS QUE NAO DEVE MIGRAR POIS SAO DE IMPOSTOS,
         --QUE SERAO DIGITADOS MANUALMENTE NO EMS5 PELO USUARIO (TX)        
         and not exists(select 1 from DEPARA_HIST_APB_NAO_MIGRAR d
                               where d.cdhistorico = t.cdhistorico);
  begin
    
    dbms_output.enable(null);
    
    dbms_output.put_line('inicio do carga_ti_tit_apb');
  
    --DESTACAR EM TEMPORARIA OS TITULOS DE IMPOSTOS QUE NAO VAI MIGRAR
    delete from temp_titulos_apb_nao_migrar;
    for x in (select * from titulo_a_pagar t
                   where exists(select 1 from ti_matriz_pagar b
                                  where b.nrregistro_titulo = t.nrregistro_titulo
                                    and exists(select 1 from depara_hist_APB_nao_migrar d
                                                  where d.cdhistorico = t.cdhistorico))) loop
    
                insert into TEMP_TITULOS_APB_NAO_MIGRAR
                  (CDFORNECEDOR,
                   NRREGISTRO_TITULO,
                   CDEMPRESA,
                   NRREGISTRO_FORNECEDOR,
                   CDSITUACAO,
                   IDCONTRATO,
                   CDHISTORICO,
                   NRDOCUMENTO,
                   TPDOCUMENTO,
                   CDPORTADOR,
                   CDOPERACAO,
                   NRNOSSONUMERO,
                   NRVENDEDOR,
                   DTTITULO,
                   DTVENCIMENTO,
                   DTEXCLUSAO,
                   DTREFERENCIA,
                   VLTITULO,
                   VLABATIMENTO,
                   VLABATIMENTO_2,
                   DTULTIMO_RECEBIMENTO,
                   VLPAGO,
                   VLMULTA,
                   VLJUROS,
                   VLDESCONTO,
                   DTENVIO_BANCO,
                   DTCONFIRMA_BANCO,
                   TXREFERENCIA_BANCO,
                   TXHISTORICO,
                   DTPROTESTO,
                   NOCARTORIO_PROTESTO,
                   TXOBSERVACOES,
                   CDCENTRO_CUSTO,
                   NRREGISTRO_TIT_AGRUP,
                   NRREGISTRO_TIT_DESM,
                   NRBANCO,
                   NRAGENCIA,
                   NRCONTA_BANCARIA,
                   DTCONTABILIZADO,
                   AOLIBERADO,
                   CDFUNCIONARIO,
                   DTLIBERACAO,
                   AOENVIA,
                   NRSEQUENCIANOTAFISCALENT,
                   NRNOTA_FISCAL_DEV,
                   VLTITULO_VENDOR,
                   NRREGISTRO_DESPESA,
                   NRMOTIVO_EXCLUSAO,
                   DTDIGITACAO,
                   NRREGISTRO_AGRUP,
                   DTULTIMO_RETORNO,
                   NRULTIMO_RETORNO,
                   CDCOMANDO_ENVIO,
                   CDCOMANDO_RETORNO,
                   CDCOMANDO_ATUAL,
                   CDBARRA,
                   LINHA_DIGITAVEL_CB,
                   VLTAXA_BANCARIA,
                   CDTAXA,
                   NRULTIMO_ENVIO,
                   NRDOCUMENTO_BANCO,
                   VLIR_FONTE,
                   CDORIGEM,
                   NRORIGEM,
                   DTENCERRAMENTO,
                   CDDIVISAO,
                   VLBRUTO,
                   DTEMISSAO_NF,
                   DTREFERENCIA_BAIXA,
                   CDMOVIMENTO_INCLUSAO,
                   TPIMPOSTOS_DESMEMBRAMENTO,
                   TPIMPOSTOS_AGRUPAMENTO,
                   CDCENTRO_RESPONSABILIDADE,
                   NRDOC_INTERCAMBIO)
                values
                  (x.CDFORNECEDOR,
                   x.NRREGISTRO_TITULO,
                   x.CDEMPRESA,
                   x.NRREGISTRO_FORNECEDOR,
                   x.CDSITUACAO,
                   x.IDCONTRATO,
                   x.CDHISTORICO,
                   x.NRDOCUMENTO,
                   x.TPDOCUMENTO,
                   x.CDPORTADOR,
                   x.CDOPERACAO,
                   x.NRNOSSONUMERO,
                   x.NRVENDEDOR,
                   x.DTTITULO,
                   x.DTVENCIMENTO,
                   x.DTEXCLUSAO,
                   x.DTREFERENCIA,
                   x.VLTITULO,
                   x.VLABATIMENTO,
                   x.VLABATIMENTO_2,
                   x.DTULTIMO_RECEBIMENTO,
                   x.VLPAGO,
                   x.VLMULTA,
                   x.VLJUROS,
                   x.VLDESCONTO,
                   x.DTENVIO_BANCO,
                   x.DTCONFIRMA_BANCO,
                   x.TXREFERENCIA_BANCO,
                   x.TXHISTORICO,
                   x.DTPROTESTO,
                   x.NOCARTORIO_PROTESTO,
                   x.TXOBSERVACOES,
                   x.CDCENTRO_CUSTO,
                   x.NRREGISTRO_TIT_AGRUP,
                   x.NRREGISTRO_TIT_DESM,
                   x.NRBANCO,
                   x.NRAGENCIA,
                   x.NRCONTA_BANCARIA,
                   x.DTCONTABILIZADO,
                   x.AOLIBERADO,
                   x.CDFUNCIONARIO,
                   x.DTLIBERACAO,
                   x.AOENVIA,
                   x.NRSEQUENCIANOTAFISCALENT,
                   x.NRNOTA_FISCAL_DEV,
                   x.VLTITULO_VENDOR,
                   x.NRREGISTRO_DESPESA,
                   x.NRMOTIVO_EXCLUSAO,
                   x.DTDIGITACAO,
                   x.NRREGISTRO_AGRUP,
                   x.DTULTIMO_RETORNO,
                   x.NRULTIMO_RETORNO,
                   x.CDCOMANDO_ENVIO,
                   x.CDCOMANDO_RETORNO,
                   x.CDCOMANDO_ATUAL,
                   x.CDBARRA,
                   x.LINHA_DIGITAVEL_CB,
                   x.VLTAXA_BANCARIA,
                   x.CDTAXA,
                   x.NRULTIMO_ENVIO,
                   x.NRDOCUMENTO_BANCO,
                   x.VLIR_FONTE,
                   x.CDORIGEM,
                   x.NRORIGEM,
                   x.DTENCERRAMENTO,
                   x.CDDIVISAO,
                   x.VLBRUTO,
                   x.DTEMISSAO_NF,
                   x.DTREFERENCIA_BAIXA,
                   x.CDMOVIMENTO_INCLUSAO,
                   x.TPIMPOSTOS_DESMEMBRAMENTO,
                   x.TPIMPOSTOS_AGRUPAMENTO,
                   x.CDCENTRO_RESPONSABILIDADE,
                   x.NRDOC_INTERCAMBIO);

    end loop;

    --apagar TI_TIT_APB com erro para reprocessamento
    for x in (select ci.nrsequencial from ti_controle_integracao ci 
               where ci.cdsituacao in ('PE','ER')
                 and ci.tpintegracao = 'TP') loop
                 
    dbms_output.put_line('vai apagar ERROS ti_tit_apb nrsequencial: ' || x.nrsequencial);
                 
        delete from ti_tit_apb tp where tp.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_apb_ctbl p where p.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_apb_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
    end loop;
  
    --apagar TI_TIT_APB caso seja titulo em aberto e possua historico de alteracao no unicoo mais 
    --recente que a ultima atualizacao no TOTVS
    --isso fara com que o registro seja atualizado no TOTVS na proxima execucao da api progress.
    for x in (select ci.nrsequencial from ti_controle_integracao ci 
               where ci.cdsituacao in ('IT')
                 and ci.tpintegracao = 'TP'
                 and exists (select 1
                        from ti_matriz_pagar b
                       where b.nrregistro_titulo = ci.nrsequencial_origem)
                 and exists(select 1 from LG$_TITULO_A_PAGAR l
                                    where l.dtatualizacao$$ > ci.dtintegracao
                                      and l.NRREGISTRO_TITULO = ci.nrsequencial_origem)) loop

    dbms_output.put_line('vai apagar ALTERADOS DO UNICOO ti_tit_apb nrsequencial: ' || x.nrsequencial);

        delete from ti_tit_apb tp where tp.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_apb_ctbl p where p.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_tit_apb_imposto i where i.nrseq_controle_integracao = x.nrsequencial;
        delete from ti_falha_de_processo tf where tf.nrseq_controle_integracao = x.nrsequencial;
    end loop;

    for x in c_tit loop
      
      dbms_output.put_line('entrou no loop nrsequencial: ' || x.pnrsequencial_origem);
    
      pck_ems506unicoo.p_ins_ti_controle_integracao(x.ptpintegracao,
                                                    x.pcdacao,
                                                    x.pcdidentificador,
                                                    x.pnrsequencial_origem,
                                                    x.pcdmodulo,
                                                    x.cdempresa,
                                                    x.pnrseq_controle_integracao_org);
      --commit;
    end loop;

    p_job;

    --commit;

  end p_carga_tit_apb;

  procedure p_atualiza_status_cliente(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin

    loop

        w := 0;
    
        select count(*) / p_qtsessoes
          into vqtregistros
          from ti_cliente
         where cdsituacao = 'RC';
    
        while w <= p_qtsessoes loop
    
          update ti_cliente t
             set cdsituacao = 'R' || w
           where cdsituacao = 'RC'
             and rownum <= vqtregistros;
    
          commit;
          w := w + 1;
    
        end loop;
    end loop;
  end p_atualiza_status_cliente;

  procedure p_atualiza_status_cliente_JK(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin
        w := 0;
    
        select round(count(*) / p_qtsessoes) + 2
          into vqtregistros
          from ti_cliente
         where cdsituacao = 'RC';
    
        while w < p_qtsessoes loop
    
          update ti_cliente t
             set cdsituacao = w
           where cdsituacao = 'RC'
             and rownum <= vqtregistros;
    
          commit;
          w := w + 1;
    
        end loop;
  end p_atualiza_status_cliente_JK;

  -- somente coloca a baixa em fila de processamento caso o titulo baixado ja tenha sido
  -- importado corretamente no EMS5
  procedure p_atualiza_status_baixa_acr(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin

    loop

        w := 0;
    
        select count(*) / p_qtsessoes
          into vqtregistros
          from ti_cx_bx_acr b, ti_controle_integracao ci
         where b.cdsituacao = 'RC'
           and ci.nrsequencial = b.nrseq_controle_integracao
           and exists --garantir que baixa ja foi importada OK
         (select 1
                  from ti_tit_acr t, ti_controle_integracao ci2
                 where t.nrseq_controle_integracao = ci2.nrsequencial
                   and ci2.nrsequencial_origem = ci.nrsequencial_origem
                   and t.cdsituacao = 'IT');
    
        while w <= p_qtsessoes loop
    
          update ti_cx_bx_acr b
             set cdsituacao = w
           where cdsituacao = 'RC'
             and exists
           (select 1
                    from ti_controle_integracao ci
                   where ci.nrsequencial = b.nrseq_controle_integracao
                     and exists
                   (select 1
                            from ti_tit_acr t, ti_controle_integracao ci2
                           where t.nrseq_controle_integracao =
                                 ci2.nrsequencial
                             and ci2.nrsequencial_origem =
                                 ci.nrsequencial_origem
                             and t.cdsituacao = 'IT'))
                
             and rownum <= vqtregistros;
    
          commit;
          w := w + 1;
    
        end loop;

    end loop;
  end p_atualiza_status_baixa_acr;

  procedure p_atualiza_status_fornecedor(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin

    loop

        w := 0;
    
        select count(*) / p_qtsessoes
          into vqtregistros
          from ti_fornecedor
         where cdsituacao = 'RC';
    
        while w <= p_qtsessoes loop
    
          update ti_fornecedor t
             set cdsituacao = 'R' || w
           where cdsituacao = 'RC'
             and rownum <= vqtregistros;
    
          commit;
          w := w + 1;
    
        end loop;

    end loop;
  end p_atualiza_status_fornecedor;

  procedure p_atualiza_status_fornec_JK(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin

        w := 0;
        select round(count(*) / p_qtsessoes) + 2
--        select count(*) / p_qtsessoes
          into vqtregistros
          from ti_fornecedor
         where cdsituacao = 'RC';
    
        while w < p_qtsessoes loop
    
          update ti_fornecedor t
             set cdsituacao = w
           where cdsituacao = 'RC'
             and rownum <= vqtregistros;
    
          commit;
          w := w + 1;
    
        end loop;

  end p_atualiza_status_fornec_JK;

  procedure p_atualiza_status_tit_apb(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin

    loop

      w := 0;

      select round(count(*) / p_qtsessoes, 0)
        into vqtregistros
        from ti_tit_apb
       where cdsituacao = 'RC';

      while w <= p_qtsessoes loop

        update ti_tit_apb t
           set cdsituacao = /*'R' ||*/ w
         where cdsituacao = 'RC'
           and rownum <= vqtregistros;

        commit;
        w := w + 1;

      end loop;

    end loop;
  end p_atualiza_status_tit_apb;
  
  procedure p_atualiza_status_tit_apb_JK(p_qtsessoes number) IS

    vqtregistros number;
    w            number := 0;

  begin

      select round(count(*) / p_qtsessoes, 0) + 2
        into vqtregistros
        from ti_tit_apb
       where cdsituacao = 'RC';

      while w <= p_qtsessoes loop

        update ti_tit_apb t
           set cdsituacao = w
         where cdsituacao = 'RC'
           and rownum < vqtregistros;

        commit;
        w := w + 1;

      end loop;
      
  end p_atualiza_status_tit_apb_JK;

  procedure p_atualiza_status_tit_acr_JK(p_qtsessoes number) IS
    vqtregistros number;
    w            number := 0;
  begin
    w := 0;
    select round(count(*) / p_qtsessoes, 0) + 2
      into vqtregistros
      from ti_tit_acr t, ti_controle_integracao ci
     where t.cdsituacao = 'RC'
       and ci.nrsequencial = t.nrseq_controle_integracao
       and exists --isso indica que eh ABERTO
     (select 1
              from ti_matriz_receber b
             where b.nrregistro_titulo = ci.nrsequencial_origem);
  
    while w < p_qtsessoes loop
    
      update ti_tit_acr t
         set cdsituacao = w
       where t.cdsituacao = 'RC'
         and exists
       (select 1
                from ti_controle_integracao ci
               where ci.nrsequencial = t.nrseq_controle_integracao
                 and exists --isso indica que eh ABERTO
               (select 1
                        from ti_matriz_receber b
                       where b.nrregistro_titulo = ci.nrsequencial_origem))
         and rownum <= vqtregistros;
    
      commit;
      w := w + 1;
    
    end loop;
  
    --distribuir os titulos ACR FECHADOS em filas de processamento
    --importante: os titulos baixados no Unicoo so poderao ser colocados nas filas
    --            caso a sua baixa ja esteja preparada na temporaria TI_CX_BX_ACR.
  
    w := 0;
    select round(count(*) / p_qtsessoes, 0) + 2
      into vqtregistros
      from ti_tit_acr t, ti_controle_integracao ci
     where t.cdsituacao = 'RC'
       and ci.nrsequencial = t.nrseq_controle_integracao
       and not exists --isso indica que eh FECHADO
     (select 1
              from ti_matriz_receber b
             where b.nrregistro_titulo = ci.nrsequencial_origem)
       and exists --isso indica que sua baixa ja esta agendada
     (select 1
              from ti_cx_bx_acr bx, ti_controle_integracao ci2
             where bx.nrseq_controle_integracao = ci2.nrsequencial
               and ci2.nrsequencial_origem = ci.nrsequencial_origem);
  
    while w < p_qtsessoes loop
    
      update ti_tit_acr t
         set cdsituacao = w
       where t.cdsituacao = 'RC'
         and exists
       (select 1
                from ti_controle_integracao ci
               where ci.nrsequencial = t.nrseq_controle_integracao
                 and not exists --isso indica que eh FECHADO
               (select 1
                        from ti_matriz_receber b
                       where b.nrregistro_titulo = ci.nrsequencial_origem)
                 and exists --isso indica que sua baixa ja esta agendada
               (select 1
                        from ti_cx_bx_acr bx, ti_controle_integracao ci2
                       where bx.nrseq_controle_integracao = ci2.nrsequencial
                         and ci2.nrsequencial_origem = ci.nrsequencial_origem))
         and rownum <= vqtregistros;
    
      commit;
      w := w + 1;
    
    end loop;
  
  end p_atualiza_status_tit_acr_JK;

  --distribuir os titulos ACR ABERTOS em filas de processamento
  procedure p_atualiza_status_tit_acr_aber(p_qtsessoes number) IS
  
    vqtregistros number;
    w            number := 0;
  
  begin
  
    loop
    
      w := 0;
    
      select round(count(*) / p_qtsessoes, 0)
        into vqtregistros
        from ti_tit_acr t, ti_controle_integracao ci
       where t.cdsituacao = 'RC'
         and ci.nrsequencial = t.nrseq_controle_integracao
         and exists --isso indica que eh ABERTO
       (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = ci.nrsequencial_origem);
               
      while w <= p_qtsessoes loop
      
        update ti_tit_acr t
           set cdsituacao = w
         where t.cdsituacao = 'RC'
           and exists
         (select 1
                  from ti_controle_integracao ci
                 where ci.nrsequencial = t.nrseq_controle_integracao and
                  exists --isso indica que eh ABERTO
                  (select 1
                           from ti_matriz_receber b
                          where b.nrregistro_titulo = ci.nrsequencial_origem))
           and rownum <= vqtregistros;
      
        commit;
        w := w + 1;
      
      end loop;
    
    end loop;
  end p_atualiza_status_tit_acr_aber;

  --distribuir os titulos ACR FECHADOS em filas de processamento
  --importante: os titulos baixados no Unicoo so poderao ser colocados nas filas
  --            caso a sua baixa ja esteja preparada na temporaria TI_CX_BX_ACR.
  procedure p_atualiza_status_tit_acr_fech(p_qtsessoes number) IS
  
    vqtregistros number;
    w            number := 0;
  
  begin
    loop
      w := 0;
    
      select round(count(*) / p_qtsessoes, 0)
        into vqtregistros
        from ti_tit_acr t, ti_controle_integracao ci
       where t.cdsituacao = 'RC'
         and ci.nrsequencial = t.nrseq_controle_integracao
         and not exists --isso indica que eh FECHADO
       (select 1
                from ti_matriz_receber b
               where b.nrregistro_titulo = ci.nrsequencial_origem)
         and exists --isso indica que sua baixa ja esta agendada
       (select 1
                from ti_cx_bx_acr bx, ti_controle_integracao ci2
               where bx.nrseq_controle_integracao = ci2.nrsequencial
                 and ci2.nrsequencial_origem = ci.nrsequencial_origem);
    
      while w <= p_qtsessoes loop
      
        update ti_tit_acr t
           set cdsituacao = w
         where t.cdsituacao = 'RC'
           and exists
         (select 1
                  from ti_controle_integracao ci
                 where ci.nrsequencial = t.nrseq_controle_integracao
                   and not exists --isso indica que eh FECHADO
                 (select 1
                          from ti_matriz_receber b
                         where b.nrregistro_titulo = ci.nrsequencial_origem)
                   and exists --isso indica que sua baixa ja esta agendada
                 (select 1
                          from ti_cx_bx_acr bx, ti_controle_integracao ci2
                         where bx.nrseq_controle_integracao =
                               ci2.nrsequencial
                           and ci2.nrsequencial_origem =
                               ci.nrsequencial_origem))
           and rownum <= vqtregistros;
      
        commit;
        w := w + 1;
      
      end loop;
    
    end loop;
  end p_atualiza_status_tit_acr_fech;
    
  --carregar matriz com os titulos ACR em aberto
  procedure p_gera_carga_matriz_acr is
    vpcdempresa  varchar2(5);
    vpdtvenc_ini date;
    vpdtvenc_fin date;
    qt_registros number;
    vpdtcontabil date;
  begin
    --inicializar parametros  
    vpcdempresa := pcdempresa_tit_acr;
    vPdtvenc_ini := pdtini_tit_acr;
    vPdtvenc_fin := pdtfim_tit_acr;
    
    begin
      vpdtcontabil := PDT_CONTABIL_ACR;
    exception
      when others then
        vpdtcontabil := sysdate;
    end;
    
    --dbms_output.enable(null);
    --dbms_output.put_line('PARAMETROS: ' || vpcdempresa || ';' || vPdtvenc_ini || ';' || vPdtvenc_fin || ';' || vpdtcontabil);
    
    --somente permitir executar o processo caso a tabela esteja vazia.
    --Motivo: rotina configurada no Jenkins. os demais processos são dependentes desse.
    --        a carga deve ser realizada apenas 1x com base em uma data contabil pre determinada.
    /*begin
      select nvl(count(*),'0') into qt_registros
        from ti_matriz_receber;
    exception
      when others then
        qt_registros := 0;
    end;
    
    if qt_registros is not null and qt_registros > 0 then
      return;
    end if;*/
    
    p_apagar_matriz_acr(true);
    
    --commit;
    -- inserir novamente os titulos em aberto na tabela.
    insert into ti_matriz_receber
      select ttr.cdcliente,
             ttr.nrregistro_titulo,
             pes.nrregistro,
             ttr.nrdocumento,
             ttr.cdsituacao,
             case
               when ttr.cdsituacao = 0 then
                'Aberto'
               when ttr.cdsituacao = 1 then
                'Totalmente Pago'
               when ttr.cdsituacao = 2 then
                'Parcialmente Pago'
               when ttr.cdsituacao = 3 then
                'Encerrado em Prejuizo'
               when ttr.cdsituacao = 4 then
                'Substituído'
               when ttr.cdsituacao = 5 then
                'Substituído Encerrado'
               when ttr.cdsituacao = 6 then
                'Desmembrado'
               when ttr.cdsituacao = 7 then
                'Agrupado'
               when ttr.cdsituacao = 8 then
                'Cancelado'
             end descsituacao,
             ttr.dttitulo,
             max(decode(cdmovimento,
                        1,
                        hst.dtvencimento,
                        2,
                        hst.dtvencimento,
                        3,
                        hst.dtvencimento,
                        10,
                        hst.dtvencimento,
                        to_date('31/12/1889'))) dtvencimento,
             decode(nvl(min(ttr.vlfaturado), 0),
                    0,
                    sum(decode(hst.nrmovimento,
                               h2.nrmovimento,
                               nvl(hst.vltitulo, 0),
                               0)),
                    nvl(min(ttr.vlfaturado), 0)) vlfaturado,
             sum(decode(hst.nrmovimento,
                        h2.nrmovimento,
                        nvl(hst.vltitulo, 0),
                        0)) vltitulo,
             max(hst.dtrecebimento) dtultimo_recebimento,
             sum(nvl(decode(hst.cdmovimento,
                            77,
                            hst.vlmulta,
                            85,
                            -hst.vlmulta,
                            86,
                            -hst.vlmulta,
                            87,
                            -hst.vlmulta,
                            89,
                            -hst.vlmulta,
                            hst.vlmulta),
                     0)) vlmulta,
             sum(nvl(decode(hst.cdmovimento,
                            77,
                            hst.vljuros,
                            85,
                            -hst.vljuros,
                            86,
                            -hst.vljuros,
                            87,
                            -hst.vljuros,
                            89,
                            -hst.vljuros,
                            hst.vljuros),
                     0)) vljuros,
             sum(nvl(decode(hst.cdmovimento,
                            77,
                            hst.vlabatimento,
                            85,
                            -hst.vlabatimento,
                            86,
                            -hst.vlabatimento,
                            87,
                            -hst.vlabatimento,
                            89,
                            -hst.vlabatimento,
                            hst.vlabatimento),
                     0)) vlabatimento,
             sum(nvl(decode(hst.cdmovimento,
                            77,
                            hst.vlabatimento_2,
                            85,
                            -hst.vlabatimento_2,
                            86,
                            -hst.vlabatimento_2,
                            87,
                            -hst.vlabatimento_2,
                            89,
                            -hst.vlabatimento_2,
                            hst.vlabatimento_2),
                     0)) vlabatimento_2,
             sum(nvl(decode(hst.cdmovimento,
                            77,
                            hst.vlrecebido,
                            85,
                            -hst.vlrecebido,
                            86,
                            -hst.vlrecebido,
                            87,
                            -hst.vlrecebido,
                            89,
                            -hst.vlrecebido,
                            hst.vlrecebido),
                     0)) vlrecebido,
             (sum(nvl(decode(hst.cdmovimento,
                             77,
                             hst.vldesconto,
                             85,
                             -hst.vldesconto,
                             86,
                             -hst.vldesconto,
                             87,
                             -hst.vldesconto,
                             89,
                             -hst.vldesconto,
                             hst.vldesconto),
                      0)) + sum(nvl(decode(hst.cdmovimento,
                                            77,
                                            hst.vlabatimento_imposto,
                                            85,
                                            -hst.vlabatimento_imposto,
                                            86,
                                            -hst.vlabatimento_imposto,
                                            87,
                                            -hst.vlabatimento_imposto,
                                            89,
                                            -hst.vlabatimento_imposto,
                                            hst.vlabatimento_imposto),
                                     0))) vldesconto,
             (sum(decode(hst.nrmovimento,
                         h2.nrmovimento,
                         nvl(hst.vltitulo, 0),
                         0)) +
             sum((nvl(decode(hst.cdmovimento,
                              77,
                              hst.vlmulta,
                              85,
                              -hst.vlmulta,
                              86,
                              -hst.vlmulta,
                              87,
                              -hst.vlmulta,
                              89,
                              -hst.vlmulta,
                              hst.vlmulta),
                       0)) + (nvl(decode(hst.cdmovimento,
                                         77,
                                         hst.vljuros,
                                         85,
                                         -hst.vljuros,
                                         86,
                                         -hst.vljuros,
                                         87,
                                         -hst.vljuros,
                                         89,
                                         -hst.vljuros,
                                         hst.vljuros),
                                  0)) + nvl(fn_criteriotaxabancaria(hst.nrregistro_titulo,
                                                                    hst.dtrecebimento,
                                                                    ttr.aotrata_taxa),
                                            0) -
                  (nvl(decode(hst.cdmovimento,
                              77,
                              hst.vldesconto,
                              85,
                              -hst.vldesconto,
                              86,
                              -hst.vldesconto,
                              87,
                              -hst.vldesconto,
                              89,
                              -hst.vldesconto,
                              hst.vldesconto),
                       0)) - (nvl(decode(hst.cdmovimento,
                                         77,
                                         hst.vlabatimento,
                                         85,
                                         -hst.vlabatimento,
                                         86,
                                         -hst.vlabatimento,
                                         87,
                                         -hst.vlabatimento,
                                         89,
                                         -hst.vlabatimento,
                                         hst.vlabatimento),
                                  0)) - (nvl(decode(hst.cdmovimento,
                                                    77,
                                                    hst.vlabatimento_2,
                                                    85,
                                                    -hst.vlabatimento_2,
                                                    86,
                                                    -hst.vlabatimento_2,
                                                    87,
                                                    -hst.vlabatimento_2,
                                                    89,
                                                    -hst.vlabatimento_2,
                                                    hst.vlabatimento_2),
                                             0)) -
                  (nvl(decode(hst.cdmovimento,
                              77,
                              hst.vlir_fonte,
                              85,
                              -hst.vlir_fonte,
                              86,
                              -hst.vlir_fonte,
                              87,
                              -hst.vlir_fonte,
                              89,
                              -hst.vlir_fonte,
                              hst.vlir_fonte),
                       0)) - (nvl(decode(hst.cdmovimento,
                                         77,
                                         hst.vlabatimento_imposto,
                                         85,
                                         -hst.vlabatimento_imposto,
                                         86,
                                         -hst.vlabatimento_imposto,
                                         87,
                                         -hst.vlabatimento_imposto,
                                         89,
                                         -hst.vlabatimento_imposto,
                                         hst.vlabatimento_imposto),
                                  0)) - (nvl(decode(hst.cdmovimento,
                                                    77,
                                                    hst.vlrecebido,
                                                    85,
                                                    -hst.vlrecebido,
                                                    86,
                                                    -hst.vlrecebido,
                                                    87,
                                                    -hst.vlrecebido,
                                                    89,
                                                    -hst.vlrecebido,
                                                    hst.vlrecebido),
                                             0)))) vlaberto
        from producao.titulo_a_receber@unicoo_homologa ttr,
             producao.cliente@unicoo_homologa cli,
             producao.grupo_de_cliente@unicoo_homologa gcl,
             producao.pessoa@unicoo_homologa pes,
             producao.endereco@unicoo_homologa enr,
             producao.historico_do_titulo@unicoo_homologa hst,
             producao.cidade@unicoo_homologa cid,
             (select *
                from producao.v_codigo_de_historico_rec@unicoo_homologa
               where cdempresa = vpcdempresa) cdh,

             -- busca o valor do título na data contabil informada
             (select max(nrmovimento) nrmovimento, nrregistro_titulo
                from producao.historico_do_titulo@unicoo_homologa
               where cdempresa = vpcdempresa
                 and dtmovimento <= vpdtcontabil
                 and cdmovimento in (1, 2, 3, 11)
               group by nrregistro_titulo) h2
       where ttr.cdempresa = vpcdempresa
         and ttr.nrregistro_titulo = hst.nrregistro_titulo
         and ttr.nrregistro_titulo = h2.nrregistro_titulo
         and ttr.cdcliente = cli.cdcliente
         and cli.cdgrupo_cliente = gcl.cdgrupo_cliente
         and ttr.cdhistorico = cdh.cdhistorico
         and cli.nrregistro_cliente = pes.nrregistro
         and pes.nrregistro = enr.nrregistro(+)
         and enr.tpendereco(+) = 'COBR'
         and enr.cdcidade = cid.cdcidade(+)
         and ttr.dttitulo <= vpdtcontabil
         and ttr.dtencerramento > vpdtcontabil
         and ttr.cdsituacao <> 1 --DESCONSIDERAR ABERTOS - ALEX BOEIRA - 28/02/2018
         and hst.cdmovimento in (1,
                                 2,
                                 3,
                                 7,
                                 10,
                                 11,
                                 12,
                                 13,
                                 14,
                                 20,
                                 30,
                                 70,
                                 71,
                                 72,
                                 74,
                                 76,
                                 77,
                                 78,
                                 80,
                                 85,
                                 86,
                                 87,
                                 89)
         and hst.dtmovimento <= vpdtcontabil
         and not exists
       (select *
                from producao.historico_do_titulo@unicoo_homologa ht
               where ht.nrdocumento = ttr.nrdocumento
                 and ht.cdempresa = vpcdempresa
                 and vpdtcontabil >=
                     (select max(h.dtexclusao)
                        from historico_do_titulo h
                       where h.nrdocumento = ttr.nrdocumento
                         and h.cdempresa = vpcdempresa
                         and (vpdtcontabil >= h.dtexclusao)
                         and h.cdmovimento = '80')
                 and vpdtcontabil <
                     (select min(t.dtmovimento)
                        from historico_do_titulo t
                       where t.dtmovimento >=
                             (select max(h.dtexclusao)
                                from historico_do_titulo h
                               where h.nrdocumento = ttr.nrdocumento
                                 and h.cdempresa = vpcdempresa
                                 and (vpdtcontabil >= h.dtexclusao)
                                 and h.cdmovimento = '80')
                         and t.nrdocumento = ttr.nrdocumento
                         and t.cdempresa = vpcdempresa
                         and t.cdmovimento = '99'))
         and not exists
       (select null
                from producao.titulo_gerado_encontro@unicoo_homologa tg
               where tg.nrregistro_titulo_receber = ttr.nrregistro_titulo)
         and not exists
       (select null
                from producao.historico_do_titulo@unicoo_homologa h,
                     producao.historico_do_titulo@unicoo_homologa h3
               where producao.h.nrregistro_titulo = ttr.nrregistro_titulo
                 and h3.nrregistro_titulo = ttr.nrregistro_titulo
                 and h.cdmovimento in ('70', '72', '74', '76', '78')
                 and h3.cdmovimento = 86
                 and h3.dtreferencia <> h3.dtrecebimento
                 and h.dtrecebimento = vpdtcontabil)
         and ttr.dtvencimento between vpdtvenc_ini and vpdtvenc_fin
       group by ttr.cdcliente,
                ttr.nrdocumento,
                ttr.tpdocumento,
                ttr.cdportador,
                ttr.dttitulo,
                ttr.dtultimo_recebimento,
                pes.nopessoa,
                cid.nocidade,
                enr.nrtelefone,
                enr.nrfax,
                cdh.nohistorico,
                cli.cdconta_contabil,
                ttr.nrregistro_titulo,
                pes.nrregistro,
                ttr.cdsituacao;
    --commit;
  end p_gera_carga_matriz_acr;

  procedure p_apagar_matriz_acr(papagar boolean) is
  begin
    --o parametro foi recebido em tela no Jenkins. Somente prosseguir se o usuario informou TRUE.
    if papagar then
      delete from ti_matriz_receber;
    end if;
  end;
  
  procedure p_apagar_matriz_apb(papagar boolean) is
  begin
    --o parametro foi recebido em tela no Jenkins. Somente prosseguir se o usuario informou TRUE.
    if papagar then
      delete from ti_matriz_pagar;
    end if;
  end;
  
  procedure p_gera_carga_matriz_apb is
                                    
    vpcdempresa  varchar2(5);
    vpdtvenc_ini date;
    vpdtvenc_fin date;
    qt_registros number;
    vpdtcontabil date;
                                    
  begin
    --inicializar parametros  
    vpcdempresa := pcdempresa_tit_apb;
    vpdtvenc_ini := pdtini_tit_apb;
    vpdtvenc_fin := pdtfim_tit_apb;
  
    begin
      vpdtcontabil := PDT_CONTABIL_APB;
    exception
      when others then
        vpdtcontabil := sysdate;
    end;
  
    --somente permitir executar o processo caso a tabela esteja vazia.
    --Motivo: rotina configurada no Jenkins. os demais processos são dependentes desse.
    --        a carga deve ser realizada apenas 1x com base em uma data contabil pre determinada.
    /*begin
      select nvl(count(*),'0') into qt_registros
        from ti_matriz_pagar;
    exception
      when others then
        qt_registros := 0;
    end;
    
    if qt_registros is not null and qt_registros > 0 then
      return;
    end if;*/

    p_apagar_matriz_apb(true);

    -- inserir novamente os titulos na tabela.
    insert into ti_matriz_pagar
      select t.nrregistro_titulo,
             p.nrregistro,
             t.cdempresa,
             t.nrdocumento,
             t.cdportador,
             t.tpdocumento,
             t.cdsituacao,
             case
               when t.cdsituacao = 0 then
                'Aberto'
               when t.cdsituacao = 1 then
                'Totalmente pago'
               when t.cdsituacao = 2 then
                'Parcialmente pago'
               when t.cdsituacao = 3 then
                'Encerrado em prejuizo'
               when t.cdsituacao = 4 then
                'Substituido aberto'
               when t.cdsituacao = 5 then
                'Substituido encerrado'
               else
                'Verificar Descrição'
             end descsituacao,
             t.dtvencimento,
             t.dttitulo,
             t.cdfornecedor,
             f.cdgrupo_fornecedor,
             g.nogrupo_fornecedor,
             p.nrcgc_cpf,
             nvl(min(t.vltitulo), 0) vltitulo,
             max(h.dtrecebimento) dtultimo_recebimento,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vlpago, 0))) vlpago,
             nvl(t.vltitulo, 0) +
             sum(-decode(h.cdmovimento, 11, 0, nvl(h.vlabatimento, 0)) -
                 decode(h.cdmovimento, 11, 0, nvl(h.vlabatimento_2, 0)) -
                 decode(h.cdmovimento, 11, 0, nvl(h.vldesconto, 0)) -
                 decode(h.cdmovimento, 11, 0, nvl(h.vlpago, 0)) +
                 decode(h.cdmovimento, 11, 0, nvl(h.vljuros, 0)) +
                 decode(h.cdmovimento, 11, 0, nvl(h.vlmulta, 0)) +
                 decode(h.cdmovimento, 11, 0, nvl(h.vltaxa_bancaria, 0))) vldevido,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vldesconto, 0))) vldesconto,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vlabatimento, 0))) vlabatimento,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vlabatimento_2, 0))) vlabatimento_2,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vljuros, 0))) vljuros,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vlmulta, 0))) vlmulta,
             sum(decode(h.cdmovimento, 11, 0, nvl(h.vltaxa_bancaria, 0))) vltaxa_bancaria
        from producao.pessoa@unicoo_homologa p,
             producao.fornecedor@unicoo_homologa f,
             producao.grupo_de_fornecedor@unicoo_homologa g,
             producao.empresa@unicoo_homologa e,
             producao.titulo_a_pagar@unicoo_homologa t,
             producao.documento_de_cobranca@unicoo_homologa d,
             producao.portador_de_cobranca@unicoo_homologa pc,
             (select nvl(decode(cdmovimento,
                                13,
                                0,
                                11,
                                0,
                                20,
                                0,
                                30,
                                0,
                                85,
                                -vlabatimento,
                                86,
                                -vlabatimento,
                                87,
                                -vlabatimento,
                                vlabatimento),
                         0) vlabatimento,
                     nvl(decode(cdmovimento,
                                13,
                                0,
                                11,
                                0,
                                20,
                                0,
                                30,
                                0,
                                85,
                                -vlabatimento_2,
                                86,
                                -vlabatimento_2,
                                87,
                                -vlabatimento_2,
                                vlabatimento_2),
                         0) vlabatimento_2,

                     nvl(decode(cdmovimento,
                                13,
                                0,
                                11,
                                0,
                                20,
                                0,
                                30,
                                0,
                                85,
                                -vldesconto,
                                86,
                                -vldesconto,
                                87,
                                -vldesconto,
                                vldesconto),
                         0) vldesconto,

                     nvl(decode(cdmovimento,
                                13,
                                vljuros,
                                25,
                                vljuros,
                                70,
                                vljuros,
                                72,
                                vljuros,
                                74,
                                vljuros,
                                76,
                                vljuros,
                                77,
                                vljuros,
                                85,
                                -vljuros,
                                86,
                                -vljuros,
                                87,
                                -vljuros,
                                0),
                         0) vljuros,

                     nvl(decode(cdmovimento,
                                7,
                                0,
                                11,
                                0,
                                12,
                                0,
                                13,
                                0,
                                14,
                                0,
                                20,
                                0,
                                30,
                                0,
                                80,
                                0,
                                85,
                                -vltaxa_bancaria,
                                86,
                                -vltaxa_bancaria,
                                87,
                                -vltaxa_bancaria,
                                vltaxa_bancaria),
                         0) vltaxa_bancaria,

                     nvl(decode(cdmovimento,
                                13,
                                vlmulta,
                                25,
                                vlmulta,
                                70,
                                vlmulta,
                                72,
                                vlmulta,
                                74,
                                vlmulta,
                                76,
                                vlmulta,
                                77,
                                vlmulta,
                                85,
                                -vlmulta,
                                86,
                                -vlmulta,
                                87,
                                -vlmulta,
                                0),
                         0) vlmulta,

                     nvl(decode(cdmovimento,
                                70,
                                vlpago,
                                72,
                                vlpago,
                                74,
                                vlpago,
                                76,
                                vlpago,
                                77,
                                vlpago,
                                85,
                                -vlpago,
                                86,
                                -vlpago,
                                87,
                                -vlpago,
                                0),
                         0) vlpago,
                     dtmovimento,
                     cdmovimento,
                     nrregistro_titulo,
                     dtrecebimento

                from producao.historico_do_titulo_pagar@unicoo_homologa
               where cdempresa = vpcdempresa
                 and cdmovimento in (1,
                                     2,
                                     3,
                                     4,
                                     7,
                                     9,
                                     11,
                                     12,
                                     13,
                                     14,
                                     20,
                                     25,
                                     30,
                                     70,
                                     72,
                                     74,
                                     76,
                                     77,
                                     80,
                                     85,
                                     86,
                                     87)
                 and (decode(cdmovimento,
                             1,
                             to_date(dttitulo), -- incl normal
                             --  2 , to_date(dtmovimento)   ,-- incl agrup
                             --  3 , to_date(dtmovimento)   ,-- incl desmp
                             7,
                             to_date(dtmovimento),
                             9,
                             to_date(dtmovimento),
                             11,
                             to_date(dtmovimento),
                             12,
                             to_date(dtmovimento),
                             13,
                             to_date(dtmovimento),
                             25,
                             to_date(dtmovimento),
                             70,
                             to_date(dtrecebimento), -- baixa normal
                             72,
                             to_date(dtrecebimento), -- baixa arq mag
                             74,
                             to_date(dtrecebimento), -- baixa deb auto
                             75,
                             to_date(dtrecebimento), -- baixa composicao
                             76,
                             to_date(dtrecebimento), -- baixa enc ctas
                             77,
                             to_date(dtrecebimento), -- baixa por adiantamento
                             85,
                             to_date(dtmovimento),
                             86,
                             to_date(dtmovimento),
                             87,
                             to_date(dtmovimento),
                             80,
                             to_date(dttitulo)) <=
                     to_date(vpdtcontabil, 'dd/mm/yyyy') -- titulo cancelado  --
                     or (cdmovimento = 20) or (cdmovimento = 30))
                 and (dtexclusao is null or
                     cdmovimento = 80 and
                     dtexclusao > to_date(vpdtcontabil, 'dd/mm/yyyy'))) h,
             (select d.nrregistro_titulo,
                     --        d.cddivisao,
                     --        d.cdcentro_custo,
                     --        d.cdhistorico,
                     sum(decode(d.tipo_distrib, 'V', d.vldistribuicao, 0)) vltitulo,
                     sum(decode(d.tipo_distrib, 'D', d.vldistribuicao, 0)) vldesconto,
                     sum(decode(d.tipo_distrib, 'A', d.vldistribuicao, 0)) vlabatimento,
                     sum(decode(d.tipo_distrib, 'B', d.vldistribuicao, 0)) vlabatimento_2
                from producao.distribuicao_titulo_pagar@unicoo_homologa d
               where d.nrmovimento in
                     (select max(a.nrmovimento) nrmovimento
                        from producao.historico_do_titulo_pagar@unicoo_homologa a,
                             producao.distribuicao_titulo_pagar@unicoo_homologa b
                       where a.nrregistro_titulo = d.nrregistro_titulo
                         and b.nrregistro_titulo = d.nrregistro_titulo
                         and a.dtmovimento <=
                             to_date(vpdtcontabil, 'dd/mm/yyyy')
                         and a.nrmovimento = b.nrmovimento
                       group by b.tipo_distrib)
               group by d.nrregistro_titulo) k
       where t.cdempresa = e.cdempresa
         and t.nrregistro_titulo = h.nrregistro_titulo(+)
         and t.nrregistro_titulo = k.nrregistro_titulo(+)
         and t.tpdocumento = d.tpdocumento
         and t.cdportador = pc.cdportador
         and t.cdfornecedor = f.cdfornecedor
         and f.nrregistro_fornecedor = p.nrregistro
         and f.cdgrupo_fornecedor = g.cdgrupo_fornecedor
         and t.dttitulo <= to_date(vpdtcontabil, 'dd/mm/yyyy')
         and t.cdempresa = vpcdempresa
         and ((t.cdsituacao in ('0', '2', '4', '6', '7')) or
             (t.cdsituacao in ('1', '5') and t.dtultimo_recebimento > to_date(vpdtcontabil, 'dd/mm/yyyy')) or
             (t.cdsituacao in ('1', '5') and
             fn_saldo_titulo_pag_data(t.nrregistro_titulo,
                                        to_date(to_date(vpdtcontabil,
                                                        'dd/mm/yyyy')) + 1,
                                        0) > 0) or
             (t.cdsituacao = '8' and
             t.dtexclusao > to_date(vpdtcontabil, 'dd/mm/yyyy')))
         and not exists
       (select null
                from titulo_gerado_encontro tg
               where tg.nrregistro_titulo_pagar = t.nrregistro_titulo)
         and not exists
       (select null
                from historico_do_titulo_pagar h
               where h.nrregistro_titulo = t.nrregistro_titulo
                 and h.cdmovimento = 5)
         and t.dtvencimento between vpdtvenc_ini and vpdtvenc_fin
         and t.tpdocumento <> 'ADT'
       group by t.nrregistro_titulo,
                t.cdfornecedor,
                p.nrregistro,
                t.cdempresa,
                t.idcontrato,
                t.cdhistorico,
                t.nrdocumento,
                t.cdportador,
                t.tpdocumento,
                t.cdsituacao,
                t.cdoperacao,
                t.dtvencimento,
                t.dttitulo,
                t.cddivisao,
                t.txhistorico,
                f.cdgrupo_fornecedor,
                g.nogrupo_fornecedor,
                p.nopessoa,
                p.nrcgc_cpf,
                p.tppessoa,
                e.noempresa,
                d.nodocumento,
                pc.noportador,
                f.cdconta_contabil,
                t.vltitulo
      having nvl(decode(t.cdsituacao, '6', max(decode(h.cdmovimento, 20, h.dtmovimento, null)), null), to_date('01/01/3000', 'dd/mm/yyyy')) > to_date(vpdtcontabil, 'dd/mm/yyyy') and nvl(decode(t.cdsituacao, '7', max(decode(h.cdmovimento, 30, h.dtmovimento, null)), null), to_date('01/01/3000', 'dd/mm/yyyy')) > to_date(vpdtcontabil, 'dd/mm/yyyy');

    commit;
  end p_gera_carga_matriz_apb;

  procedure p_gera_dados_comparativo_acr is
  begin
    delete from ti_tit_acr_comparativo;
    --commit;

    insert into ti_tit_acr_comparativo
      select distinct ta.cod_refer,
                      min(a.nrsequencial) nrsequencial,
                      a.nrsequencial_origem,
                      a.tpintegracao,
                      nvl(b.val_titulo, 0) val_titulo,
                      --nvl(imp.val_imposto,0) val_imposto,
                      a.cdsituacao sit_ti_controle,
                      nvl(b.cdsituacao, 'NI') sit_ti_tit_apb,
                      nvl(ta.val_origin_tit_acr, 0) vloriginal,
                      nvl(ta.val_sdo_tit_acr, 0) val_sdo_tit_ap
        from ti_controle_integracao a, ti_tit_acr b, tit_acr ta
       where a.nrsequencial = b.nrseq_controle_integracao(+)
         and nvl(a.tpintegracao, 'TR') = 'TR'
         and nvl(a.cdsituacao, 'RE') <> 'RE'
         and 'TR' || lpad(b.nrseq_controle_integracao, 8, '0') =
             ta.cod_refer(+)
         and nvl(ta.u##ind_tip_espec_docto, 'NORMAL') = 'NORMAL'
       group by ta.cod_refer,
                a.nrsequencial_origem,
                a.tpintegracao,
                b.val_titulo,
                a.cdsituacao,
                b.cdsituacao,
                ta.val_origin_tit_acr,
                ta.val_sdo_tit_acr;
    --commit;

  end p_gera_dados_comparativo_acr;

  procedure p_gera_dados_comparativo_apb is
  begin
    delete from ti_tit_apb_comparativo;
    --commit;

    insert into ti_tit_apb_comparativo
      select distinct tp.cod_refer,
                      min(a.nrsequencial) nrsequencial,
                      a.nrsequencial_origem,
                      a.tpintegracao,
                      nvl(b.val_titulo, 0) val_titulo,
                      nvl(imp.val_imposto, 0) val_imposto,
                      a.cdsituacao sit_ti_controle,
                      nvl(b.cdsituacao, 'NI') sit_ti_tit_apb,
                      nvl(tp.val_origin_tit_ap, 0) vloriginal,
                      nvl(tp.val_sdo_tit_ap, 0) val_sdo_tit_ap
        from ti_controle_integracao a,
             ti_tit_apb b,
             tit_ap tp,
             (select i.nrseq_controle_integracao,
                     sum(i.val_imposto) val_imposto
                from ti_tit_apb_imposto i
               group by i.nrseq_controle_integracao) imp

       where a.nrsequencial = b.nrseq_controle_integracao(+)
         and nvl(a.tpintegracao, 'TP') = 'TP'
         and nvl(a.cdsituacao, 'RE') <> 'RE'
         and imp.nrseq_controle_integracao(+) = a.nrsequencial
         and 'I' || lpad(b.nrseq_controle_integracao, 9, '0') =
             tp.cod_refer(+)
         and nvl(tp.u##ind_tip_espec_docto, 'NORMAL') = 'NORMAL'
       group by tp.cod_refer,
                a.nrsequencial_origem,
                a.tpintegracao,
                b.val_titulo,
                imp.val_imposto,
                a.cdsituacao,
                b.cdsituacao,
                tp.val_origin_tit_ap,
                tp.val_sdo_tit_ap;
    --commit;

  end p_gera_dados_comparativo_apb;

  procedure p_apaga_pessoa_juridica is

    cursor c_pessoa_jurid is
      select progress_recid
        from ems5.pessoa_jurid pj
       where not exists
       (select 1
                from v_pessoa_juridica v
               where pj.num_pessoa_jurid = v.NUM_PESSOA_JURID);

  begin

    for pj in c_pessoa_jurid loop

      delete from ems5.pessoa_jurid p
       where p.progress_recid = pj.progress_recid;

      p_commit;

    end loop;

    --commit;

  end p_apaga_pessoa_juridica;

  procedure p_reprocessa_status_pe(pnrseq_controle_integracao ti_controle_integracao.nrsequencial%type,
                                   ptpintegracao              ti_controle_integracao.tpintegracao%type)

   is

  begin

    if ptpintegracao = 'CL' then

      delete from ti_cliente tc
       where (tc.nrseq_controle_integracao = pnrseq_controle_integracao or
             pnrseq_controle_integracao is null)
         and tc.cdsituacao = 'PE';

      commit;

      pck_ems506unicoo.p_job;

    elsif ptpintegracao = 'FN' then

      delete from ti_fornecedor tc
       where (tc.nrseq_controle_integracao = pnrseq_controle_integracao or
             pnrseq_controle_integracao is null)
         and tc.cdsituacao = 'PE';

      commit;

      pck_ems506unicoo.p_job;

    elsif ptpintegracao = 'TP' then

      delete from ti_tit_apb tc
       where (tc.nrseq_controle_integracao = pnrseq_controle_integracao or
             pnrseq_controle_integracao is null)
         and tc.cdsituacao = 'PE';

      commit;

      pck_ems506unicoo.p_job;

    elsif ptpintegracao = 'TR' then

      delete from ti_tit_acr tc
       where (tc.nrseq_controle_integracao = pnrseq_controle_integracao or
             pnrseq_controle_integracao is null)
         and tc.cdsituacao = 'PE';

      commit;

      pck_ems506unicoo.p_job;

    end if;

  end p_reprocessa_status_pe;

Procedure p_atualiza_fluxo_financ_fornec

is

  v integer;
  w integer;
  registro number;

  Cursor c is
  select
      distinct f.nrregistro_fornecedor
  from
      producao.historico_do_titulo_pagar@unicoo_homologa h,
      producao.fornecedor@unicoo_homologa f,
      ems5.fornecedor ef,
      ti_pessoa p
  where h.cdhistorico          is not null
  and   h.cdfornecedor         is not null
  and   h.cdfornecedor         = f.cdfornecedor
  and   f.nrregistro_fornecedor = p.nrregistro
  and   p.cdn_fornecedor        = ef.cdn_fornecedor
  order by 1;

  Cursor D is
  select
      tip.cdn_fornecedor,
      t.cdhistorico
  from
     (select
         f1.nrregistro_fornecedor,
         h1.cdhistorico,
         tp.dttitulo,
         count(*) maior
      from
         producao.historico_do_titulo_pagar@unicoo_homologa h1,
         producao.fornecedor@unicoo_homologa f1,
         producao.titulo_a_pagar@unicoo_homologa tp
      where h1.cdhistorico          is not null
      and   h1.cdfornecedor         is not null
      and   h1.cdfornecedor         = f1.cdfornecedor
      and   h1.nrregistro_titulo    = tp.nrregistro_titulo
      group by (f1.nrregistro_fornecedor,h1.cdhistorico, tp.dttitulo)
      order by 1,2,4 desc, 3 desc) t,
      ti_pessoa tip,
      ems5.fornecedor ef5
      where t.nrregistro_fornecedor = tip.nrregistro
      and   tip.cdn_fornecedor      = ef5.cdn_fornecedor
      and   tip.nrregistro          = registro
      and   rownum =1;

  begin

    for v in c loop

       registro:=v.nrregistro_fornecedor;

       for w in d loop

           update ems5.fornec_financ ffe
               set ffe.cod_tip_fluxo_financ = decode((select tia.cod_tip_fluxo_financ from ems506unicoo.ti_tipo_movimento_tit_apb tia
                                                      where tia.cdmovimento = w.cdhistorico),null,
                                                     decode((select ps.tppessoa from pessoa ps where ps.nrregistro = v.nrregistro_fornecedor),
                                                             'J',
                                                             (select pi.vlparametro from ti_parametro_integracao pi where pi.cdparametro = 'COD_TIP_FLUXO_FINANC_PREFER_FOR_J'),
                                                             (select pi.vlparametro from ti_parametro_integracao pi where pi.cdparametro = 'COD_TIP_FLUXO_FINANC_PREFER_FOR_F')),
                                                             (select tia.cod_tip_fluxo_financ from ems506unicoo.ti_tipo_movimento_tit_apb tia
                                                              where tia.cdmovimento = w.cdhistorico))
           where ffe.cdn_fornecedor = w.cdn_fornecedor;

       end loop;

    commit;

   end loop;

end p_atualiza_fluxo_financ_fornec;

procedure insere_hash(ptpintegracao varchar2,
                      pnrsequencial_origem number,
                      pcdidentificador varchar2) is
  hash_atual varchar2(100);                      
begin
  case ptpintegracao
    when 'FN' then hash_atual := gerar_hash_fornecedor_unicoo(pcdidentificador,pnrsequencial_origem);
    when 'CL' then hash_atual := gerar_hash_cliente_unicoo(pcdidentificador,pnrsequencial_origem);
    --when 'TP' then hash_atual := gerar_hash_fornecedor_unicoo(pcdidentificador); --LG$_TITULO_A_PAGAR 
    --when 'TR' then hash_atual := gerar_hash_fornecedor_unicoo(pcdidentificador); --LG$_TITULO_A_RECEBER
  end case;  
  
  --apagar hash anterior da mesma chave
  delete from ti_hash h
     where h.tpintegracao = ptpintegracao
       and h.nrsequencial_origem = pnrsequencial_origem
       and h.cdidentificador = pcdidentificador;
  
  insert into ti_hash(nrsequencial        ,
                      tpintegracao        ,
                      dtgeracao           ,
                      nrsequencial_origem ,
                      cdidentificador     ,
                      txhash              )
                values(ti_hash_seq.nextval,
                       ptpintegracao,
                       sysdate,
                       pnrsequencial_origem,
                       pcdidentificador,
                       hash_atual);
end insere_hash;                      
                      
begin
  -- Alessandro 20/03/2012

  Pcpf_dtnascimento  := f_ti_parametro_integracao('CPF_DTNASCIMENTO');
  pcdempresa_tit_acr := f_ti_parametro_integracao('CDEMPRESA_TIT_ACR'); 
  pdtini_tit_acr     := f_ti_parametro_integracao('DTINI_TIT_ACR');
  pdtfim_tit_acr     := f_ti_parametro_integracao('DTFIM_TIT_ACR');
  pcdempresa_tit_apb := f_ti_parametro_integracao('CDEMPRESA_TIT_APB');
  pdtini_tit_apb     := f_ti_parametro_integracao('DTINI_TIT_APB');
  pdtfim_tit_apb     := f_ti_parametro_integracao('DTFIM_TIT_APB');
  
  PMIGRAR_TITULOS_ACR_FECHADOS := f_ti_parametro_integracao('MIGRAR_TITULOS_ACR_FECHADOS');
  PDT_INI_TITULOS_ACR_FECHADOS := f_ti_parametro_integracao('DT_INICIO_TITULOS_ACR_FECHADOS');
  PDT_CONTABIL_APB := f_ti_parametro_integracao('DT_CONTABIL_APB');
  PDT_CONTABIL_ACR := f_ti_parametro_integracao('DT_CONTABIL_ACR');
  NULL;
END PCK_EMS506UNICOO;
/