/*ajustes específicos solicitados pela UNIMED NOVA IGUACU-RJ*/
set echo on
--select count(*) from gp.hist_movto_usuario

declare
  Cursor cUsuario Is
    Select us.cd_modalidade, us.nr_proposta, us.nr_ter_adesao, p.cd_contratante, us.cd_usuario, us.cd_titular,
           us.nm_usuario
    From   GP.USUARIO US, GP.propost p
    Where  Not Exists (Select 1 From GP.HIST_MOVTO_USUARIO
                       Where CD_MODALIDADE = US.CD_MODALIDADE
                       And   NR_PROPOSTA = US.NR_PROPOSTA
                       And   CD_USUARIO = US.CD_USUARIO)
    And    US.LOG_17 = 0 --desconsidera o usuário eventual
    And    p.cd_modalidade = us.cd_modalidade
    And    p.nr_proposta = us.nr_proposta
    and exists(select 1 from gp.import_bnfciar ib -- considerar apenas beneficiarios migrados, sem afetar os que foram digitados pelo cliente no sistema
                       where ib.cd_carteira_antiga = us.cd_carteira_antiga);                       
begin
  --SETAR INDICADOR DE GERACAO DA NUMERACAO DE FAMILIA DE AUTOMATICA PARA MANUAL APENAS PARA OS CONTRATOS ABAIXO
  update gp.propost p
     set p.int_1 = 1 --1: manual; 0-automatico;
   where exists
   (select 1
            from gp.import_propost ip
           where ip.cd_modalidade = p.cd_modalidade
             and ip.num_livre_10 = p.nr_proposta
             and ip.num_livre_3 in
                 (0600, 0601, 0602, 0603, 0604, 0605, 0606, 0607, 0608, 0609, 0610, 0611, 0612, 0613, 0614, 0615));
  --select int_1, count(*) from gp.propost group by int_1;

  --ATIVAR IDICADOR PARA SOLICITAR CPT PARA TODOS OS PLANOS INDIVIDUAL/FAMILIAR E TAMBEM PARA COLETIVO POR ADESaO QUANDO O 
  --CONTRATO DO UNICOO ENTRE 2000 E 3500         
  --INDIVIDUAL / FAMILIAR;
  update gp.propost p
     set p.lg_solicita_cpt = 1
   where p.in_tipo_contratacao = 1;
  --select lg_solicita_cpt, count(*) from gp.propost group by lg_solicita_cpt;

  --COLETIVO POR ADESAO ENTRE 2000 E 3500
  update gp.propost p
     set p.lg_solicita_cpt = 1
   where p.in_tipo_contratacao in (5, 6)
     and exists (select 1
            from gp.import_propost ip
           where ip.cd_modalidade = p.cd_modalidade
             and ip.num_livre_10 = p.nr_proposta
             and ip.num_livre_3 between 2000 and 3500);
  --select lg_solicita_cpt, count(*) from gp.propost group by lg_solicita_cpt;

  --AJUSTAR INDICADOR DE IMPRESSAO DE ETIQUETAS CONFORME RESPONSAVEL TIPO DE FINANCEIRO
  --PROPOSTAS COLETIVO EMPRESARIAL QUE FATURAM POR LOTACAO - ETIQUETA NA LOTACAO - CHAR_12: 00010
  update gp.propost p
     set p.char_12 = '00010'
   where p.in_tipo_contratacao in (5, 6)
     and exists (select 1
            from gp.lotac_propost lp
           where lp.cdn_modalid = p.cd_modalidade
             and lp.num_propost = p.nr_proposta
             and lp.cdn_respons_financ is not null
             and lp.cdn_respons_financ > 0);
  --select char_12, count(*) from gp.propost group by char_12

  --PROPOSTAS COLETIVO EMPRESARIAL SEM FATURAMENTO POR LOTACAO - ETIQUETA NO CONTRATO - CHAR_12: 10000
  update gp.propost p
     set p.char_12 = '10000'
   where p.in_tipo_contratacao in (5, 6)
     and not exists (select 1
            from gp.lotac_propost lp
           where lp.cdn_modalid = p.cd_modalidade
             and lp.num_propost = p.nr_proposta
             and lp.cdn_respons_financ is not null
             and lp.cdn_respons_financ > 0);
  --select char_12, count(*) from gp.propost group by char_12

  --PROPOSTAS ADESAO - ETIQUETA POR TITULAR - CHAR_12: 00001
  update gp.propost p
     set p.char_12 = '00001'
   where p.in_tipo_contratacao in (3, 4);
  --select char_12, count(*) from gp.propost group by char_12

  --3. TRATAMENTO ESPECIAL DA UNIMED NOVA IGUACU PARA INDICAR ENDERECOS COMO PRINCIPAL E COBRANCA

  --REGRA SOLICITADA EM MARCO/2018 PELO CLIENTE (CANCELADA):
  --3.1. cada pessoa nao pode ter 2 enderecos principais nem de cobrança.
  --3.2. toda pessoa tem que ter 1 endereco principal.
  --3.3. COBR -> PRINCIPAL; se nao tiver, setar outro como principal;
  --3.4. COR -> COBRANCA; se nao tiver, COBR; se nao tiver, o 1o que achar;
  --3.5. Associar na proposta (PROPOST.NUM_LIVRE_17) o que tiver AOCORRESPONDENCIA = S (ENDERECO.U_LOG_1 = 1)

  --REGRA SOLICITADA EM MAIO/2018 PELO CLIENTE:         
  --3.1. cada pessoa nao pode ter 2 enderecos principais nem de cobrança.
  --3.2. toda pessoa tem que ter 1 endereco principal.
  --3.3. COBR -> PRINCIPAL; se nao tiver, setar outro como principal;
  --3.4. AOCORRESPONDENCIA = 'S' -> COBRANCA; se não tiver, COR; se nao tiver, COBR; se nao tiver, o 1o que achar;
  --3.5. Associar na proposta (PROPOST.NUM_LIVRE_17) o que tiver AOCORRESPONDENCIA = S (ENDERECO.U_LOG_1 = 1)

  begin
    --destivar LG_PRINCIPAL e LG_COBRANCA de todos os enderecos;
    update gp.endereco en set en.lg_principal = 0, en.lg_end_cobranca = 0;
  
    --setar como COBRANCA quando AOCORRESPONDENCIA = 'S'
    update gp.endereco en set en.lg_end_cobranca = 1 where en.u_log_1 = 1;
  
    --setar como PRINCIPAL quando COBR:
    update gp.endereco en
       set en.lg_principal = 1
     where (en.u_char_1 = 'COBR' or en.u_char_1 = 'COR')
       and en.lg_end_cobranca = 0;
  
    --se ficou sem PRINCIPAL, marcar o 1o que achar:
    for x in (select distinct e.id_pessoa
                from gp.endereco e
               where not exists (select 1
                        from gp.endereco c
                       where c.id_pessoa = e.id_pessoa
                         and c.lg_principal = 1)) loop
      update gp.endereco en
         set en.lg_principal = 1
       where en.id_pessoa = x.id_pessoa
         and rownum = 1;
    end loop;
  
    --se ficou sem COBRANCA, marcar o 1o que achar como COR:
    for x in (select distinct e.id_pessoa
                from gp.endereco e
               where not exists (select 1
                        from gp.endereco c
                       where c.id_pessoa = e.id_pessoa
                         and c.lg_end_cobranca = 1)) loop
      update gp.endereco en
         set en.lg_end_cobranca = 1
       where en.id_pessoa = x.id_pessoa
         and en.u_char_1 = 'COR'
         and rownum = 1;
    end loop;
  
    --se ficou sem COBRANCA, marcar o 1o que achar como COBR:
    for x in (select distinct e.id_pessoa
                from gp.endereco e
               where not exists (select 1
                        from gp.endereco c
                       where c.id_pessoa = e.id_pessoa
                         and c.lg_end_cobranca = 1)) loop
      update gp.endereco en
         set en.lg_end_cobranca = 1
       where en.id_pessoa = x.id_pessoa
         and en.u_char_1 = 'COBR'
         and rownum = 1;
    end loop;
  
    --se ficou sem COBRANCA, marcar o 1o que achar:
    for x in (select distinct e.id_pessoa
                from gp.endereco e
               where not exists (select 1
                        from gp.endereco c
                       where c.id_pessoa = e.id_pessoa
                         and c.lg_end_cobranca = 1)) loop
      update gp.endereco en
         set en.lg_end_cobranca = 1
       where en.id_pessoa = x.id_pessoa
         and rownum = 1;
    end loop;
  
    for x in (select p.progress_recid, e.id_endereco
                from propost p, contrat c, gp.endereco e
               where p.nr_insc_contratante = c.nr_insc_contratante
                 and e.id_pessoa = c.id_pessoa
                 and e.u_log_1 = 1) loop
      update propost p
         set p.num_livre_17 = x.id_endereco
       where p.progress_recid = x.progress_recid;
    end loop;
  end;

  --PREENCHER IDENTIFICACAO EMPRESA PARA OS TERMOS DE MEDICINA OCUPACIONAL
  begin
    for x in (select t.cd_modalidade,
                     t.nr_ter_adesao,
                     lpad(ip.num_livre_3, 4, '0') nrcontrato,
                     p.nr_insc_contratante
                from gp.ter_ade t, gp.import_propost ip, propost p
               where t.cd_modalidade = 70
                 and ip.cd_modalidade = t.cd_modalidade
                 and ip.num_livre_10 = t.nr_ter_adesao
                 and p.cd_modalidade = t.cd_modalidade
                 and p.nr_ter_adesao = t.nr_ter_adesao) loop
    
      begin
        insert into gp.gerac_cod_ident_propost
          (cdn_modalid,
           num_propost,
           cdn_ident_empres,
           cd_contratante,
           nr_insc_contratante)
        values
          (x.cd_modalidade,
           x.nr_ter_adesao,
           x.nrcontrato,
           0,
           x.nr_insc_contratante);
      exception
        when others then
          null;
      end;
    end loop;
  end;

  --ATENCAO: Alex Boeira 13/12/2018 - Esse script foi desenvolvido quando o migrador forcava um parametro para ultimo faturamento.
  --                         Agora o migrador busca a logica abaixo, por isso o script esta comentado.
  --                         Executa-lo apenas se os usuarios apresentarem demanda.
  --PARA CADA CONTRATO MIGRADO, BUSCAR ULTIMA NOTASERV (TOTVS) E ULTIMO FATURAMENTO (UNICOO). AJUSTAR AAAAMM_ULT_FAT CONFORME MAIOR QUE ENCONTRAR.
  /*declare
    vfinal number := 0;
    vaafinal number := 0;
    vmmfinal number := 0;
  begin
    dbms_output.enable(null);
    for x in (select t.cd_modalidade, t.nr_ter_adesao, t.dt_inicio, t.dt_cancelamento, t.mm_ult_fat, t.aa_ult_fat,
              ip.num_livre_2 NRREGISTRO, lpad(ip.num_livre_3,4,'0') NRCONTRATO,
              (select decode(max(n.mm_referencia),null,null,'2018' || lpad(max(n.mm_referencia),2,'0')) 
               from notaserv n where n.cd_modalidade = t.cd_modalidade
                                                             and n.nr_ter_adesao = t.nr_ter_adesao
                                                             and n.aa_referencia = 2018) MM_NOTASERV,
              (select max(f.nrperiodo) from faturamento f
                                       where f.nrregistro = ip.num_livre_2
                                         and f.nrcontrato = lpad(ip.num_livre_3,4,'0')
                                         and f.tpfatura = '7'\*mensalidade*\) AAMM_UNICOO
                from ter_ade t, import_propost ip
               where ip.cd_modalidade = t.cd_modalidade
                 and ip.num_livre_10  = t.nr_ter_adesao) loop
                 
                 vfinal := 0;
                 if x.mm_notaserv > x.aamm_unicoo then
                   vfinal := x.mm_notaserv;
                 else
                   vfinal := x.aamm_unicoo;
                 end if;
                 
                 dbms_output.put_line(x.nrregistro || ';' || x.nrcontrato || ';' || x.cd_modalidade || ';' || x.nr_ter_adesao || ';' || 
                                      x.dt_inicio  || ';' || x.dt_cancelamento  || ';' || x.aa_ult_fat   || ';' || x.mm_ult_fat   || ';' || 
                                      x.mm_notaserv || ';' || x.aamm_unicoo || ';' || vfinal);
  
           if vfinal <> 0 then
             vaafinal := substr(vfinal,1,4);
           vmmfinal := substr(vfinal,5,2);
           
                   update ter_ade t set t.aa_ult_fat = vaafinal, t.mm_ult_fat = vmmfinal where t.cd_modalidade = x.cd_modalidade and t.nr_ter_adesao = x.nr_ter_adesao;
                   update gp.usuario u set u.aa_ult_fat = vaafinal, u.mm_ult_fat = vmmfinal where u.cd_modalidade = x.cd_modalidade and u.nr_ter_adesao = x.nr_ter_adesao;
                   update usumodu m set m.aa_ult_fat = vaafinal, m.mm_ult_fat = vmmfinal where m.cd_modalidade = x.cd_modalidade and m.nr_proposta = x.nr_ter_adesao;
           end if;
    end loop;
  end;
  */

  -- ativar indicador Cobrar Reajuste Retroativo Parcelado atendendo a solicitacao da Stephany (item 146 do Prot󴩰o Integrado)
  begin
    for x in (select p.cd_modalidade,
                     p.cd_plano,
                     p.cd_tipo_plano,
                     p.nr_ter_adesao,
                     t.progress_recid RECID_TERMO
                from ter_ade t, propost p
               where t.cd_modalidade = p.cd_modalidade
                 and t.nr_ter_adesao = p.nr_ter_adesao
                 and (p.cd_modalidade in (1, 10) or
                     (p.cd_modalidade = 20 and
                     p.cd_plano in (16, 17, 18, 19, 20)))) loop
    
      update gp.ter_ade t
         set t.log_5 = 1
       where t.progress_recid = x.recid_termo;
    
    end loop;
  end;
  --select log_5, count(*) from gp.ter_ade group by log_5

  -- desativar indicador de faturamento do termo de adesao quando nao possui nenhum beneficiario ativo
  update gp.ter_ade t
     set t.lg_faturar = 0
   where t.lg_faturar = 1
     and (t.dt_cancelamento is null or t.dt_cancelamento > sysdate) --termo ativo
     and not exists
   (select 1
            from gp.usuario u
           where u.cd_modalidade = t.cd_modalidade
             and u.nr_ter_adesao = t.nr_ter_adesao
             and u.log_17 = 0 --ignorar eventual
             and (u.dt_exclusao_plano is null or
                 u.dt_exclusao_plano > sysdate)); --nao possui beneficiario ativo

  -- ativar indicador de faturamento do termo de adesao quando esta desativado e possui beneficiarios ativos
  update gp.ter_ade t
     set t.lg_faturar = 1
   where t.lg_faturar = 0
     and (t.dt_cancelamento is null or t.dt_cancelamento > sysdate) --termo ativo
     and exists
   (select 1
            from gp.usuario u
           where u.cd_modalidade = t.cd_modalidade
             and u.nr_ter_adesao = t.nr_ter_adesao
             and u.log_17 = 0 --ignorar eventual
             and (u.dt_exclusao_plano is null or
                 u.dt_exclusao_plano > sysdate)); --possui ao menos um beneficiario ativo
  --conferencia: select lg_faturar, count(*) from gp.ter_ade group by lg_faturar

  -- em NOVA IGUACU a modalidade 30 so pode ter lotacao de DEMAP
  update gp.usuario u
     set u.cdn_lotac = 0
   where u.cd_modalidade = 30
     and u.cdn_lotac > 1;
  --select cdn_lotac, count(*) from gp.usuario u where u.cd_modalidade = 30 group by cdn_lotac;

  -- cancelar os termos da modalidade 30 (PLAMEC) que nao possuem nenhum benef ativo, para evitar erros no Faturamento (nao tentar faturar esse contrato)
  begin
    for y in (select p.cd_modalidade,
                     p.nr_ter_adesao,
                     p.nr_proposta,
                     (select max(x.dt_exclusao_plano)
                        from gp.usuario x
                       where x.cd_modalidade = p.cd_modalidade
                         and x.nr_proposta = p.nr_proposta) data_fim
                from gp.propost p
               where p.cd_modalidade = 30
                 and not exists
               (select 1
                        from gp.usuario u
                       where u.cd_modalidade = p.cd_modalidade
                         and u.nr_proposta = p.nr_proposta
                         and u.cd_sit_usuario <> 90)) loop
    
      update gp.ter_ade t
         set t.dt_fim          = y.data_fim,
             t.dt_cancelamento = y.data_fim,
             t.aa_ult_fat      = extract(year from y.data_fim),
             t.mm_ult_fat      = extract(month from y.data_fim),
             t.cd_sit_adesao   = 90,
             t.cd_userid       = '_sit90script'
       where t.cd_modalidade = y.cd_modalidade
         and t.nr_ter_adesao = y.nr_ter_adesao;
    
    end loop;
  end;

  -- PREENCHER PRESTADOR RESPONSAVEL PARA BAIXA AUTOMATICA DA PRODUCAO - MODALIDADE 30 - PLAMEC (UNIMED NOVA IGUACU)
  begin
    for x in (select pr.cd_unidade,
                     pr.cd_prestador,
                     pr.nm_prestador,
                     p.cd_modalidade,
                     p.nr_proposta,
                     p.Cd_Userid,
                     w.cd_contratante,
                     w.nr_insc_contratante
                from gp.propost p
               inner join gp.contrat c on c.cd_contratante =
                                          p.cd_contrat_origem
               inner join gp.preserv pr on pr.nr_cgc_cpf = c.nr_cgc_cpf
                                       and pr.dt_exclusao is null
                                       and pr.cd_contratante <>
                                           c.cd_contratante
               inner join gp.contrat w on w.nr_cgc_cpf = pr.nr_cgc_cpf
                                      and w.cd_contratante =
                                          pr.cd_contratante
               where p.cD_modalidade = 30)
    
     loop
    
      update gp.ter_ade t
         set t.cd_unidade_prestador    = x.cd_unidade,
             t.cd_prestador            = x.cd_prestador,
             t.lgdescontaplanoproducao = 1,
             t.cd_userid               = '_cpf_dup_prest'
       where t.cd_modalidade = x.cd_modalidade
         and t.nr_ter_adesao = x.nr_proposta;
    
      update gp.propost z
         set z.Cd_Contrat_Origem      = x.cd_contratante,
             z.nr_insc_contrat_origem = x.nr_insc_contratante,
             z.cd_userid              = '_cpf_dup_prest' || x.cd_contratante
       where z.cd_modalidade = x.cd_modalidade
         and z.nr_proposta = x.nr_proposta;
    
    end loop;
  end;
  
  -- CARREGAR HISTORICO DO SIB, PARA QUE OS BENEFICIARIOS MIGRADOS NAO SEJAM
  -- ENVIADOS NO PRIMEIRO PROCESSAMENTO APOS VIRADA PARA O TOTVS
  For Rx In cUsuario Loop
    Insert Into GP.HIST_MOVTO_USUARIO (
                id_registro, cd_modalidade, nr_proposta, cd_usuario,
                u##in_tipo_movimento, in_tipo_movimento, dat_movimento,
                u##des_origem_movimento, des_origem_movimento,
                id_sib_remessa, id_histor_substituto,
                cd_modalidate_origem, nr_propost_origem, cd_usuario_origem,
                cod_livre_1, cod_livre_2, cod_livre_3, cod_livre_4, cod_livre_5, 
                dat_livre_1, dat_livre_2, dat_livre_3, dat_livre_4, dat_livre_5,
                val_livre_1, val_livre_2, val_livre_3, val_livre_4, val_livre_5, 
                log_livre_1, log_livre_2, log_livre_3, log_livre_4, log_livre_5, 
                num_livre_1, num_livre_2, num_livre_3, num_livre_4, num_livre_5, 
                progress_recid)
           Values (gp.seq_hist_movto.nextval, /*id_registro*/
                   Rx.Cd_Modalidade,
                   Rx.Nr_Proposta,
                   Rx.Cd_Usuario,
                   'INC', 'INC', /*in_tipo_movimento*/
                   Sysdate, /*dat_movimento*/
                   'NAO_ENVIAR', 'NAO_ENVIAR', /*des_origem_movimento*/
                   0, /*id_sib_remessa*/
                   0, /*id_histor_substituto*/
                   0, /*cd_modalidade_origem*/
                   0, /*nr_propost_origem*/
                   0, /*cd_usuario_origem*/
                   'MIGRACAO', /*cod_livre_1*/
                   ' ', ' ', ' ', ' ', /*cod_livre_2~5*/
                   Sysdate, /*dat_livre_1*/
                   null, null, null, null, /*dat_livre_2~5*/
                   0, 0, 0, 0, 0, /*val_livre_1~5*/
                   0, 0, 0, 0, 0, /*log_livre_1~5*/
                   Rx.cd_titular, /*num_livre_1*/
                   Rx.cd_contratante, /*num_livre_2*/
                   Rx.nr_ter_adesao, /*num_livre_3*/
                   0, 0, /*num_livre_4~5*/
                   gp.hist_movto_usuario_seq.nextval);
  End Loop;
  commit;
end;
/
