--select * from temp_pl_mo_am
--select * from pla_mod pm where pm.cd_modulo in (28,29)

--USAR TEMP_PL_MO_AM COMO MODELO (MOD 20, PL 1, TP 1). 
--PARA TODOS OS TIPOS DE PLANOS:
--  SE TEM O MESMO MODULO, ENTAO ELIMINAR TODOS OS PL_MO_AM CORRESPONDENTES E RECRIAR COM BASE NO MODELO;
--  EXCECAO: NAO ALTERAR NADA NA MODALIDADE 90
--select * from temp_pl_mo_am pl where pl.cd_modulo in (28,29)

declare
  vqt       number;
  vqtold    number;
  aosimular varchar2(1) := 'N';
begin
  dbms_output.enable(null);
  dbms_output.put_line('ELIMINAR E RECRIAR;MODALIDADE;PLANO;TIPO;MODULO;QT_SERV_ANTES;QT_SERV_DEPOIS');
  dbms_output.put_line('CRIANDO;MODALIDADE;PLANO;TIPO;MODULO;PROCEDIMENTO');
  for x in (select pm.cd_modalidade,
                   pm.cd_plano,
                   pm.cd_tipo_plano,
                   pm.cd_modulo
              from gp.pla_mod pm
             where pm.cd_modalidade <> 90) loop
  
    select count(*)
      into vqtold
      from pl_mo_am p
     where p.cd_modalidade = x.cd_modalidade
       and p.cd_plano = x.cd_plano
       and p.cd_tipo_plano = x.cd_tipo_plano
       and p.cd_modulo = x.cd_modulo;
  
    select count(*)
      into vqt
      from temp_pl_mo_am t
     where t.cd_modulo = x.cd_modulo;
  
    if vqt > 0 then
      dbms_output.put_line('ELIMINAR E RECRIAR;' || x.cd_modalidade || ';' ||
                           x.cd_plano || ';' || x.cd_tipo_plano || ';' ||
                           x.cd_modulo || ';' || vqtold || ';' || vqt);
    
      --ELIMINAR TODOS OS PL_MO_AM DESSA ESTRUTURA
      if aosimular = 'N' then
        delete from gp.pl_mo_am p
         where p.cd_modalidade = x.cd_modalidade
           and p.cd_plano = x.cd_plano
           and p.cd_tipo_plano = x.cd_tipo_plano
           and p.cd_modulo = x.cd_modulo;
      end if;
    
      --CRIAR PL_MO_AM COM BASE NO MODELO (muda modalidade, plano, tipo, progress_recid)
      for y in (select *
                  from temp_pl_mo_am t
                 where t.cd_modulo = x.cd_modulo) loop
      
        select count(*)
          into vqt
          from gp.ambproce a
         where a.cdprocedimentocompleto = y.cd_amb;
         
        if vqt = 0 then
          dbms_output.put_line('@@@@@@@@@@@@@@@@@@ERRO: AMBPROCE NAO EXISTE;' ||
                               y.cd_amb);
        end if;
        
        dbms_output.put_line('CRIANDO;' || x.cd_modalidade || ';' ||
                             x.cd_plano || ';' || x.cd_tipo_plano || ';' ||
                             x.cd_modulo || ';' || y.cd_amb);
      
        if aosimular = 'N' then
          insert into GP.PL_MO_AM
            (CD_MODALIDADE,
             CD_PLANO,
             CD_TIPO_PLANO,
             CD_MODULO,
             CD_AMB,
             U##CD_TAB_PRECO,
             CD_TAB_PRECO,
             CD_IND_OBSERVACAO,
             LG_AUT_EMPRESA,
             LOG_1,
             QT_PROCEDIMENTO,
             DEC_1,
             DT_ATUALIZACAO,
             CD_USERID,
             CD_TIPO_PRESTADOR,
             CD_TIPO_COBERTURA,
             LG_AUT_UNIMED,
             CHAR_1,
             CHAR_2,
             CHAR_3##1,
             CHAR_3##2,
             DATE_1,
             DATE_2,
             DATE_3,
             INT_2,
             INT_3,
             LOG_2,
             LOG_3,
             DEC_2,
             DEC_3,
             U_CHAR_1,
             U_CHAR_2,
             U_CHAR_3,
             U_DATE_1,
             U_DATE_2,
             U_DATE_3,
             U_INT_1,
             U_INT_2,
             U_INT_3,
             U_DEC_1,
             U_DEC_2,
             U_DEC_3,
             U_LOG_1,
             U_LOG_2,
             U_LOG_3,
             NR_DIAS_VALIDADE,
             CHAR_4,
             CHAR_5,
             DATE_4,
             DATE_5,
             DEC_4,
             DEC_5,
             INT_4,
             INT_5,
             LOG_4,
             LOG_5,
             DT_LIMITE,
             PROGRESS_RECID)
          VALUES
            (x.CD_MODALIDADE,
             x.CD_PLANO,
             x.CD_TIPO_PLANO,
             x.CD_MODULO,
             y.CD_AMB,
             y.U##CD_TAB_PRECO,
             y.CD_TAB_PRECO,
             y.CD_IND_OBSERVACAO,
             y.LG_AUT_EMPRESA,
             y.LOG_1,
             y.QT_PROCEDIMENTO,
             y.DEC_1,
             y.DT_ATUALIZACAO,
             y.CD_USERID,
             y.CD_TIPO_PRESTADOR,
             y.CD_TIPO_COBERTURA,
             y.LG_AUT_UNIMED,
             y.CHAR_1,
             y.CHAR_2,
             y.CHAR_3##1,
             y.CHAR_3##2,
             y.DATE_1,
             y.DATE_2,
             y.DATE_3,
             y.INT_2,
             y.INT_3,
             y.LOG_2,
             y.LOG_3,
             y.DEC_2,
             y.DEC_3,
             y.U_CHAR_1,
             y.U_CHAR_2,
             y.U_CHAR_3,
             y.U_DATE_1,
             y.U_DATE_2,
             y.U_DATE_3,
             y.U_INT_1,
             y.U_INT_2,
             y.U_INT_3,
             y.U_DEC_1,
             y.U_DEC_2,
             y.U_DEC_3,
             y.U_LOG_1,
             y.U_LOG_2,
             y.U_LOG_3,
             y.NR_DIAS_VALIDADE,
             y.CHAR_4,
             y.CHAR_5,
             y.DATE_4,
             y.DATE_5,
             y.DEC_4,
             y.DEC_5,
             y.INT_4,
             y.INT_5,
             y.LOG_4,
             y.LOG_5,
             y.DT_LIMITE,
             gp.pl_mo_am_seq.nextval);
        end if;
      end loop;
    end if;
  end loop;
end;

