--analise do log de migracao - propostas e beneficiarios

-- identificar possiveis tipos de mensagem tratadas
select distinct l.metodo, l.ind_acao from log_migracao l;

-- identificar mensagem mais recente no log
select max(l.num_seqcial) from log_migracao l order by num_seqcial
select * from log_migracao l where l.num_seqcial > 29884755 order by num_seqcial

-- procurar ocorrencia mais recente de uma mensagem (acao)
select max(l.num_seqcial) from log_migracao l where l.ind_acao LIKE '%APAGAR PROPOSTA NO TOTVS%' order by num_seqcial

-- procurar um ID específico
select * from log_migracao l where l.num_seqcial = 16483008 order by num_seqcial

-- procurar log de um beneficiário específico
select * from log_migracao l where l.num_seqcial_orig = 2835 order by num_seqcial

--pesquisar temporaria de importacao do beneficiario
select * from gp.import_bnfciar ib where ib.num_seqcial_bnfciar = 248246;

--pesquisar esse beneficiario no TOTVS
select * from gp.usuario u where u.cd_carteira_antiga = 7302018979003;

--pesquisar temporaria de importacao de proposta do beneficiario
select * from gp.import_propost ip where ip.nr_contrato_antigo = 3338;--   

--pesquisar proposta no TOTVS
select * from gp.propost p where p.u##nr_contrato_antigo = 3338;
select * from gp.usuario u where u.cd_modalidade = 10 and u.nr_proposta = 686;

--reprocessar um beneficiario especifico
begin
  /*pck_unicoogps.P_CARGA_BENEFICIARIOS('N', --SOMENTE_ATIVOS
                                    null, --NRREGISTRO
                                    null, --NRCONTRATO
                                    248246  --NRSEQCIAL_BNFCIAR
                                    );*/
  commit;
  pck_unicoogps.P_GERA_PROPOSTA_R2(248246); --CONTRATO
  commit;
end;
