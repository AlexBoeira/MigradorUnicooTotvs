-- distribuir Propostas da situação RC para 0, 1, etc, conforme o parâmetro
begin
  pck_unicoogps.P_ATUALIZA_STATUS_PROPOSTA(9 /*qt sessões*/);
end;
