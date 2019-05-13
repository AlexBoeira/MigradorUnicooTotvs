-- listar erros importacao propostas
select p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.num_livre_10 proposta, e.*, p.*
from gp.erro_process_import e, gp.import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.ind_sit_import = 'CONTRAT';

--delete from gp.import_bnfciar ib where ib.nr_contrato_antigo in(2756438,2756439,2756451)
--delete from gp.import_propost ip where ip.nr_contrato_antigo in(2756438,2756439,2756451)
