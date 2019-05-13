-- gerar a Matriz de títulos ACR, composta pelos títulos em aberto a serem migrados.
-- posteriormente a migração de Clientes e Títulos utilizará essa matriz (TI_MATRIZ_RECEBER) no processo de seleção dos registros.
-- esse processo limpa a tabela TI_MATRIZ_RECEBER para carrega-la novamente

begin
  PCK_EMS506UNICOO.P_GERA_CARGA_MATRIZ_ACR('00001',       -- vpcdempresa   varchar2
                                           sysdate,       -- vpdtcontabil  date
                                           '01/01/2000',  -- vpdtvenc_ini date
                                           '31/12/9999'); -- vpdtvenc_fin date
end;
--select count(*) from ti_matriz_receber--61253
