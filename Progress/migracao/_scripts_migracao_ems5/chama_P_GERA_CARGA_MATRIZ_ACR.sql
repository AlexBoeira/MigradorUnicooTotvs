-- gerar a Matriz de t�tulos ACR, composta pelos t�tulos em aberto a serem migrados.
-- posteriormente a migra��o de Clientes e T�tulos utilizar� essa matriz (TI_MATRIZ_RECEBER) no processo de sele��o dos registros.
-- esse processo limpa a tabela TI_MATRIZ_RECEBER para carrega-la novamente

begin
  PCK_EMS506UNICOO.P_GERA_CARGA_MATRIZ_ACR('00001',       -- vpcdempresa   varchar2
                                           sysdate,       -- vpdtcontabil  date
                                           '01/01/2000',  -- vpdtvenc_ini date
                                           '31/12/9999'); -- vpdtvenc_fin date
end;
--select count(*) from ti_matriz_receber--61253
