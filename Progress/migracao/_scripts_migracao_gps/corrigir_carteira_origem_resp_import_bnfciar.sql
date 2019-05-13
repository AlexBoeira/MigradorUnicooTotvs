--CURSOR PARA CORRIGIR CARTEIRA ORIGEM RESPONSÁVEL QUANDO ESTÁ NULA!!!!! 
declare
  vcarteira_resp number;
begin
--  DBMS_OUTPUT.ENABLE(99999999);
  for x in (select ib.* from import_bnfciar ib 
             where ib.cdcarteiraorigemresponsavel is null) loop
      
     select to_number(u2.nrcontrato ||
                       lpad(u2.nrfamilia, 6, '0') ||
                       u2.tpusuario ||
                       u2.nrdigitoct)
     into vcarteira_resp
        from usuario u2, import_propost ip, import_bnfciar ib
        where ib.progress_recid = x.progress_recid
        and ip.nr_contrato_antigo = ib.nr_contrato_antigo
        and u2.nrregistro = ip.num_livre_2
        and u2.nrcontrato = ip.num_livre_3
        and u2.nrfamilia = ib.num_livre_4
        and u2.tpusuario = 00     ;
       
     update import_bnfciar ib set ib.cdcarteiraorigemresponsavel = vcarteira_resp
     where ib.progress_recid = x.progress_recid;  
--     DBMS_OUTPUT.PUT_LINE( 'carteira/resp: ' || x.cd_carteira_antiga || '/' || vcarteira_resp);
        
  end loop;
end;

select * from import_bnfciar ib where ib.cdcarteiraorigemresponsavel is null
