--sincronizar TEMP_CATEGORIAS_USUARIOS com CRITERIOS_DO_USUARIO do UNICOO
set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  PCK_UNICOOGPS.p_carga_estrutura_modulos;
  commit;
end;
/
