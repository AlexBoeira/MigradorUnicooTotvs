set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  pck_unicoogps.p_migra_regra_estrutura;
  pck_unicoogps.p_migra_regra_proposta2('N',   --SIMULAR S-criar apenas tabelas simulacao; N-criar apenas tabelas reais; T-criar ambas;
                                       null, --5217,   --NRREGISTRO
                                       null  --'0017'    --NRCONTRATO
                                       );
  commit;                                       

end;
/
