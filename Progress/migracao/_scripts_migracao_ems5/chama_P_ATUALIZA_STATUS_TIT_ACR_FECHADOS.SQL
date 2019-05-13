-- informar no parâmetro o número de filas desejado (0, 1, 2, etc...) valor máximo: número de licensas Progress
-- TRATA APENAS TITULOS FECHADOS.

-- ATENCAO: SE A BAIXA DO TITULO NAO EXISTIR EM TI_CX_BX_ACR, O STATUS PERMANECE COMO 'RC'.
--          ISSO EH UMA MEDIDA DE SEGURANCA PARA NAO CRIAR TITULOS COM SALDO EM ABERTO INDEVIDAMENTE.
begin
  pck_ems506unicoo.p_atualiza_status_tit_acr_fech(19);
end;
