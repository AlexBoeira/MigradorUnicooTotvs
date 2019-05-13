--preencher NR_PROPOSTA e CD_USUARIO (NUM_LIVRE_6) em IMPORT_BNFCIAR
declare
  ct_codigo number := 0;
  ult_contrato number := 0;
begin
  for x in (select ip.num_livre_10, ib.nr_contrato_antigo, ib.progress_recid from import_propost ip, import_bnfciar ib
                   where ib.nr_contrato_antigo = ip.nr_contrato_antigo order by ib.nr_contrato_antigo, ib.cd_grau_parentesco) loop
                   
      if ult_contrato <> x.nr_contrato_antigo then
         ult_contrato := x.nr_contrato_antigo;
         ct_codigo := 0;
      end if;
      ct_codigo := ct_codigo + 1;
      
      update import_bnfciar ib set ib.nr_proposta = x.num_livre_10,
                                   ib.num_livre_6 = ct_codigo
                   where ib.progress_recid = x.progress_recid;
  end loop;
end;

--select distinct num_livre_6 from import_bnfciar
--select ib.cd_modalidade, ib.nr_proposta, ib.num_livre_6 from import_bnfciar ib order by ib.cd_modalidade, ib.nr_proposta, ib.num_livre_6 
--select * from import_bnfciar ib where ib.cd_modalidade = 0
