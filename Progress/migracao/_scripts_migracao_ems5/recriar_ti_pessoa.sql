/*select count(*) from pessoa p --478507  pessoa que é cliente e/ou fornecedor: 209633
where exists(select 1 from producao.cliente@unicoo_homologa c where c.nrregistro_cliente = p.nrregistro)--196856
   or exists(select 1 from producao.fornecedor@unicoo_homologa f where f.nrregistro_fornecedor = p.nrregistro)--25605
select * from producao.cliente@unicoo_homologa
*/
declare
  vnoabrev_fornecedor varchar2(12);
  vcdfornecedor       varchar2(10);
  vnoabrev_cliente    varchar2(12);
  vcdcliente          varchar2(10);
begin
  for x in (select p.nrcgc_cpf,
                   p.nopessoa,
                   p.dtnascimento,
                   p.tppessoa,
                   p.nrregistro,
                   vnoabrev_fornecedor,
                   vcdfornecedor,
                   vnoabrev_cliente,
                   vcdcliente
              from pessoa p
             where exists (select 1
                      from producao.cliente@unicoo_homologa c
                     where c.nrregistro_cliente = p.nrregistro)
                or exists
             (select 1
                      from producao.fornecedor@unicoo_homologa f
                     where f.nrregistro_fornecedor = p.nrregistro)) loop
  
    pck_ems506unicoo.P_DEFINE_TI_PESSOA(x.nrcgc_cpf,
                                         x.nopessoa,
                                         x.dtnascimento,
                                         x.tppessoa,
                                         x.nrregistro,
                                         'UNIMED',
                                         vnoabrev_fornecedor,
                                         vcdfornecedor,
                                         vnoabrev_cliente,
                                         vcdcliente,
                                         'S');
  end loop;
end;
--select count(*) from ti_pessoa p
--APOS A CARGA, REVISAR NOME ABREV E CODIGOS DE CLIENTE E FORNECEDOR CONFORME OS QUE JA EXISTEM NO EMS5
