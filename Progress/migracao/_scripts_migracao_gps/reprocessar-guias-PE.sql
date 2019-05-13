-- setar guias AT com situação PE (pendencia importacao) para serem reprocessadas
update gp.import_guia g set g.ind_sit_import = 'RC', g.u##ind_sit_import = 'RC'
where g.u##ind_sit_import = 'PE'
