--gerar hash para os clientes do unicoo correspondentes aos registros ja existentes em TI_CLIENTE
declare
  hash_atual varchar2(100);
begin
  for x in (select i.cdidentificador,
                   i.nrsequencial_origem,
                   c.nrseq_controle_integracao,
                   c.cod_cliente,
                   c.nrpessoa
              from ti_cliente c, ti_controle_integracao i
             where c.nrseq_controle_integracao = i.nrsequencial) loop
  
    pck_ems506unicoo.insere_hash('CL',
                                 x.NRSEQUENCIAL_ORIGEM,
                                 x.CDIDENTIFICADOR);
  end loop;
end;
--select count(*) from ti_hash;
