-- apagar  guias AT com situação ER (erro extrator) para serem reprocessadas
delete from gp.import_guia g where g.u##ind_sit_import = 'ER'
