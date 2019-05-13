-- listar erros importacao propostas - não conseguiu gerar import_propost
select p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.num_livre_10 proposta, e.*, p.*
from gp.erro_process_import e, gp.import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.ind_sit_import in('ER','CORIGEM','CONTRAT','GE');
