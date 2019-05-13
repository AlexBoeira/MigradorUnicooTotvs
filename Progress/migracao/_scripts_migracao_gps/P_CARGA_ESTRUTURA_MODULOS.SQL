--CARREGAR TEMPORARIA TEMP_CATEGORIAS_USUARIOS COM BASE EM UNICOO.CRITERIOS_DO_USUARIO
begin
  pck_unicoogps.p_carga_estrutura_modulos;
  commit;

-- RECOMENDADO APLICAR O ANALYSE ABAIXO APOS CARREGAR, PARA OTIMIZAR PERFORMANCE. ATENCAO: PODE LEVAR MAIS DE 30 MINUTOS!!!!!
  
--  analyze table unicoogps.temp_categorias_usuarios compute statistics for table for all indexes for all indexed columns;

  commit;
end;
--select count(*) from TEMP_CATEGORIAS_USUARIOS
