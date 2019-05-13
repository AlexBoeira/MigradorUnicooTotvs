procedure p_importa_nota_co_evento_progr (pPeriodo number,                            /*Informar o período do UNICOO para buscar os eventos de Coparticipação e Custo Operacional*/
                                          pEVENTO_FM      GP.EVENPROG.CD_EVENTO%Type, /*Informar o Evento de Coparticipação do TOTVS*/
										  pEVENTO_CO      GP.EVENPROG.CD_EVENTO%Type, /*Informar o Evento de Custo Operacional do TOTVS*/
										  pOBS_EVENTO_FM  Varchar2,                   /*Observações para registrar os Eventos de Coparticipação*/
										  pOBS_EVENTO_CO  Varchar2                    /*Observações para registrar os Eventos de Custo Operacional*/
										  ) is
  --
  Cursor cFat (pCdOperacao Varchar2) Is (
    Select US.CD_MODALIDADE, US.NR_TER_ADESAO, P.CD_CONTRATANTE, P.CD_CONTRAT_ORIGEM,
           /******
             >> Regra para preenchimento do Codigo do Responssvel Financeiro. (orientado pelo Alex)
             Ordem de prioridade:
              1. Buscar campo CDN_RESPONS_FINANC do USUARIO, se zero ou nulo - segue regra 2
              2. Buscar campo CDN_RESPONS_FINANC da LOTAC_PROPOST, se zero ou nulo - segue regra 3
              3. Verificar conteúdo do campo TER_ADE.INCONTRATANTEMENSALIDADE:
                   a. se "0" (zero), informar o conteúdo do campo PROPOST.NR_INSC_CONTRATANTE
                   b. se "1", informar o conteúdo do campo PROPOST.NR_INSC_CONTRAT_ORIGEM
            ******/
           Case
             When (Nvl(US.CDN_RESPONS_FINANC,0) = 0) And (Nvl(LP.CDN_RESPONS_FINANC,0) = 0) Then
               Decode(TA.INCONTRATANTEMENSALIDADE, 0, P.NR_INSC_CONTRATANTE, P.NR_INSC_CONTRAT_ORIGEM)
             When (Nvl(US.CDN_RESPONS_FINANC,0) = 0) And (Nvl(LP.CDN_RESPONS_FINANC,0) > 0) Then
               LP.CDN_RESPONS_FINANC
             Else
               US.CDN_RESPONS_FINANC
           End CDN_RESPONS_FINANC,
           TO_NUMBER(Substr(D.NRPERIODO,5)) MM_REF, TO_NUMBER(Substr(D.NRPERIODO,1,4)) AA_REF,
           Count(*) QT_EVENTO, SUM(NVL(D.VLCOBRADO_EM_MOEDA,0) + NVL(D.VLCOBRADO_FILME_EM_MOEDA,0)) VL_EVENTO
    From   DETALHE_FATURAMENTO_CUSTO@UNICOO_HOMOLOGA D, IMPORT_BNFCIAR IB, GP.USUARIO US, GP.PROPOST P,
           GP.LOTAC_PROPOST LP, GP.TER_ADE TA
    Where  IB.NUM_SEQCIAL_BNFCIAR = D.NRSEQUENCIAL_USUARIO
    And    US.CD_CARTEIRA_ANTIGA = IB.CD_CARTEIRA_ANTIGA
    And    P.CD_MODALIDADE = US.CD_MODALIDADE
    And    P.NR_PROPOSTA = US.NR_PROPOSTA
    And    LP.CDN_MODALID(+) = US.CD_MODALIDADE
    And    LP.NUM_PROPOST(+) = US.NR_PROPOSTA
    And    LP.CDN_LOTAC(+) = US.CDN_LOTAC
    And    TA.CD_MODALIDADE = US.CD_MODALIDADE
    And    TA.NR_TER_ADESAO = US.NR_TER_ADESAO
    And    D.CDOPERACAO = pCdOperacao
    And    D.NRPERIODO = pPERIODO
    And    D.NRFATURA Is Not Null
    --And    us.cd_modalidade = 20 And us.nr_ter_adesao = 58
    And    Exists (
                   Select 1 From FATURAMENTO@UNICOO_HOMOLOGA
                   Where NRFATURA = D.NRFATURA
                   And   AOSITUACAO_FATURA = '0' /*ativa*/
                   )
    Group By US.CD_MODALIDADE, US.NR_TER_ADESAO, P.CD_CONTRATANTE, P.CD_CONTRAT_ORIGEM,
             Case
               When (Nvl(US.CDN_RESPONS_FINANC,0) = 0) And (Nvl(LP.CDN_RESPONS_FINANC,0) = 0) Then
                 Decode(TA.INCONTRATANTEMENSALIDADE, 0, P.NR_INSC_CONTRATANTE, P.NR_INSC_CONTRAT_ORIGEM)
               When (Nvl(US.CDN_RESPONS_FINANC,0) = 0) And (Nvl(LP.CDN_RESPONS_FINANC,0) > 0) Then
                 LP.CDN_RESPONS_FINANC
               Else
                 US.CDN_RESPONS_FINANC
             End, Substr(D.NRPERIODO,5), Substr(D.NRPERIODO,1,4)
  );
Begin
  /*Evento de Co-participação*/
  For Rx In cFat('FM') Loop
    Insert Into GP.EVENPROG (CD_MODALIDADE, NR_TER_ADESAO, CD_EVENTO, AA_REFERENCIA, MM_REFERENCIA, CD_MOEDA, 
                             QT_EVENTO, VL_EVENTO, DT_ATUALIZACAO, CD_USERID, CHAR_1, CHAR_2, CHAR_3, CHAR_4, 
                             CHAR_5, INT_1, INT_2, INT_3, INT_4, INT_5, DEC_1, DEC_2, DEC_3, DEC_4, DEC_5, 
                             DATE_1, DATE_2, DATE_3, DATE_4, DATE_5, LOG_1, LOG_2, LOG_3, LOG_4, LOG_5, U_CHAR_1, 
                             U_CHAR_2, U_CHAR_3, U_DATE_1, U_DATE_2, U_DATE_3, U_LOG_1, U_LOG_2, U_LOG_3, U_INT_1, 
                             U_INT_2, U_INT_3, U_DEC_1, U_DEC_2, U_DEC_3, CD_CONTRATANTE, CD_CONTRATANTE_ORIGEM, 
                             NR_SEQUENCIA, CDN_RESPONS_FINANC, PROGRESS_RECID)
           Values (Rx.Cd_Modalidade, Rx.Nr_Ter_Adesao, pEVENTO_FM, Rx.AA_REF, Rx.MM_REF,
                   0 /*cd_moeda*/, Rx.Qt_Evento, Rx.Vl_Evento,
                   Trunc(Sysdate) /*dt_atualizacao*/, 'MIGRACAO' /*cd_userid*/,
                   Nvl(pOBS_EVENTO_FM,' ') /*char_1*/,
                   ' ', ' ', ' ', ' ', /*char_2~5*/
                   0, 0, 0, 0, 0, /*int_1~5*/
                   0, 0, 0, 0, 0, /*dec_1~5*/
                   null, Null, Null, Null, Null, /*date_1~5*/
                   0, 0, 0, 0, 0, /*log_1~5*/
                   ' ', ' ', ' ', /*u_char_1~3*/
                   Null, Null, Null, /*u_date_1~3*/
                   0, 0, 0, /*u_log_1~3*/
                   0, 0, 0, /*u_int_1~3*/
                   0, 0, 0, /*u_dec_1~3*/
                   Rx.CD_CONTRATANTE, Rx.CD_CONTRAT_ORIGEM, 0 /*nr_sequencia*/, Rx.CDN_RESPONS_FINANC,
                   GP.EVENPROG_SEQ.Nextval);
  End Loop;
  --
  /*Evento de Custo Operacional*/
  For Rx In cFat('2') Loop
    Insert Into GP.EVENPROG (CD_MODALIDADE, NR_TER_ADESAO, CD_EVENTO, AA_REFERENCIA, MM_REFERENCIA, CD_MOEDA, 
                             QT_EVENTO, VL_EVENTO, DT_ATUALIZACAO, CD_USERID, CHAR_1, CHAR_2, CHAR_3, CHAR_4, 
                             CHAR_5, INT_1, INT_2, INT_3, INT_4, INT_5, DEC_1, DEC_2, DEC_3, DEC_4, DEC_5, 
                             DATE_1, DATE_2, DATE_3, DATE_4, DATE_5, LOG_1, LOG_2, LOG_3, LOG_4, LOG_5, U_CHAR_1, 
                             U_CHAR_2, U_CHAR_3, U_DATE_1, U_DATE_2, U_DATE_3, U_LOG_1, U_LOG_2, U_LOG_3, U_INT_1, 
                             U_INT_2, U_INT_3, U_DEC_1, U_DEC_2, U_DEC_3, CD_CONTRATANTE, CD_CONTRATANTE_ORIGEM, 
                             NR_SEQUENCIA, CDN_RESPONS_FINANC, PROGRESS_RECID)
           Values (Rx.Cd_Modalidade, Rx.Nr_Ter_Adesao, pEVENTO_CO, Rx.AA_REF, Rx.MM_REF,
                   0 /*cd_moeda*/, Rx.Qt_Evento, Rx.Vl_Evento,
                   Trunc(Sysdate) /*dt_atualizacao*/, 'MIGRACAO' /*cd_userid*/,
                   Nvl(pOBS_EVENTO_CO,' ') /*char_1*/,
                   ' ', ' ', ' ', ' ', /*char_2~5*/
                   0, 0, 0, 0, 0, /*int_1~5*/
                   0, 0, 0, 0, 0, /*dec_1~5*/
                   null, Null, Null, Null, Null, /*date_1~5*/
                   0, 0, 0, 0, 0, /*log_1~5*/
                   ' ', ' ', ' ', /*u_char_1~3*/
                   Null, Null, Null, /*u_date_1~3*/
                   0, 0, 0, /*u_log_1~3*/
                   0, 0, 0, /*u_int_1~3*/
                   0, 0, 0, /*u_dec_1~3*/
                   Rx.CD_CONTRATANTE, Rx.CD_CONTRAT_ORIGEM, 0 /*nr_sequencia*/, Rx.CDN_RESPONS_FINANC,
                   GP.EVENPROG_SEQ.Nextval);
  End Loop;
End p_importa_nota_co_evento_progr;
