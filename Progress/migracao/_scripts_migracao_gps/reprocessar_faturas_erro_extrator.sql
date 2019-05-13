--APAGAR TEMPORARIAS DE FATURAS COM ERRO DO EXTRATOR PARA SER REPROCESSADO EM P_IMPORT_FATURA
declare
begin
  for x in (select f.progress_recid RECID_F, j.progress_recid RECID_J
              from gp.migrac_fatur f, gp.migrac_fatur_juros j
             where j.cdd_seq_tab_pai(+) = f.cdd_seq
               and f.cod_livre_1 = 'ER') loop
  
    delete from gp.migrac_fatur_juros j where j.progress_recid = x.recid_j;
    delete from gp.migrac_fatur f where f.progress_recid = x.recid_f;
  end loop;
  commit;
  --pck_unicoogps.p_import_fatura(201701 /*PERIODO_INICIAL (AAAAMM)*/,
  --                              201812 /*PERIODO_FINAL   (AAAAMM)*/);
  commit;
end;
