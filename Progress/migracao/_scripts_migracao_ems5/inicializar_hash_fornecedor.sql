--gerar hash para os fornecedores do unicoo correspondentes aos registros ja existentes em TI_FORNECEDOR
declare
  hash_atual varchar2(100);
begin
  for x in (select c.cdidentificador,
                   c.nrsequencial_origem,
                   f.nrseq_controle_integracao,
                   f.cod_fornecedor,
                   f.nrpessoa
              from ti_fornecedor f, ti_controle_integracao c
             where f.nrseq_controle_integracao = c.nrsequencial) loop
  
    pck_ems506unicoo.insere_hash('FN',
                                 x.NRSEQUENCIAL_ORIGEM,
                                 x.CDIDENTIFICADOR);
  end loop;
end;
--select count(*) from ti_hash;
--select * from ti_hash
