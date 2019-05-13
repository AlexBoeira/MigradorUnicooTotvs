select * from migracao_modulo_padrao mmp, depara_modulo dm
where mmp.cdcategserv = dm.cdcategserv
  and mmp.cdmodulo <> dm.cdmodulo
