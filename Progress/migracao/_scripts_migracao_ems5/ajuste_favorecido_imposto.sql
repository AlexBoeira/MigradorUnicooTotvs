--CORRIGIR CDN_FORNEC_FAVOREC DE ACORDO COM COD_LIVRE_1 (CNPJ) E COD_LIVRE_2 (NOME). 
--UTILIZADO QUANDO OS FORNECEDORES SAO RECARREGADOS, GANHANDO NOVA CODIFICACAO.
--ANTES DE EXECUTAR ESSE SCRIPT, GARANTIR QUE COD_LIVRE_1 E COD_LIVRE_2 (EMS5.HISTOR_IMPTO_EMPRES) ESTAO 
--GRAVADOS COM O CNPJ E NOME CORRETOS DO FAVORECIDO.
declare
begin
  for x in (select h.cod_imposto,
                   h.cdn_fornec_favorec,
                   h.cod_livre_1,
                   h.cod_livre_2,
                   f.cdn_fornecedor,
                   f.cod_id_feder,
                   f.nom_pessoa,
                   h.progress_recid
              from ems5.HISTOR_IMPTO_EMPRES@db_ems5_treina h,
                   ems5.fornecedor f
             where f.cod_id_feder = h.cod_livre_1
               and f.nom_pessoa   = h.cod_livre_2) loop
  
    update ems5.histor_impto_empres h
       set h.cdn_fornec_favorec = x.cdn_fornecedor
     where h.progress_recid = x.progress_recid;
  end loop;
end;
/*
--CONFERENCIA:
select h.cod_imposto,
       h.dat_inic_valid,
       h.dat_fim_valid,
       h.cod_livre_1,
       h.cod_livre_2,
       h.cdn_fornec_favorec,
       f.nom_pessoa,
       f.cod_id_feder
  from histor_impto_empres h, fornecedor f
 where f.cdn_fornecedor = h.cdn_fornec_favorec
*/
--select * from ems5.histor_impto_empres
