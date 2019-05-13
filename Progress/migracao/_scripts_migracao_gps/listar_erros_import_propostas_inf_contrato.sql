-- listar erros importacao propostas
select p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.num_livre_10 proposta, e.*, p.*
from gp.erro_process_import e, gp.import_propost p
where e.num_seqcial_control = p.num_seqcial_control
and p.ind_sit_import = 'PE'
and p.num_livre_3 = '0528'
;

--select * from import_propost ip where ip.ind_sit_import = 'RC'

--select * from gp.import_lotac_propost ilp where ilp.num_seqcial_propost = 378642


/*select imp.num_seqcial_propost, imp.cd_modulo, imp.log_cobert_obrig, imp.qt_caren_eletiva,imp.dat_inicial, imp.dat_cancel from import_modul_propost imp
where imp.num_seqcial_propost = 191720
select * from pla_mod pm where pm.cd_modalidade = 15 and pm.cd_plano = 2 and pm.cd_tipo_plano = 2
select ip.num_seqcial_propost, ip.ind_sit_import from import_propost ip
*/
/*select * from depara_modulo dm where dm.cdcategserv = 'SEGV'
select * from migracao_modulo_padrao mmp where mmp.cdcategserv = 'SEGV'
select * from temp_depara_agrupado
select * from pla_mod pm where pm.cd_modalidade = 15 and pm.cd_plano = 2 and pm.cd_tipo_plano = 2
*/