-- gerar a Matriz de títulos APB, composta pelos títulos em aberto (status 0) e parcialmente (status 2) pagos a serem migrados.
-- posteriormente a migração de Fornecedores e Títulos utilizará essa matriz (TI_MATRIZ_PAGAR) no processo de seleção dos registros.
-- esse processo limpa a tabela TI_MATRIZ_PAGAR para carrega-la novamente

begin
  PCK_EMS506UNICOO.P_GERA_CARGA_MATRIZ_APB('00001',       -- vpcdempresa   varchar2
                                           sysdate,       -- vpdtcontabil  date
                                           '01/01/2000',  -- vpdtvenc_ini date
                                           '31/12/9999'); -- vpdtvenc_fin date
end;
--select count(*) from ti_matriz_pagar
