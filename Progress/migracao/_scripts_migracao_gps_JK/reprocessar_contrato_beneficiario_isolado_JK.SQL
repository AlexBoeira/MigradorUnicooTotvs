set echo off
--reprocessar um beneficiario especifico
begin
  pck_unicoogps.P_CARGA_BENEFICIARIOS('&1', --SOMENTE_ATIVOS
                                      &2, --NRREGISTRO
                                      &3, --NRCONTRATO
                                      &4  --NRSEQCIAL_BNFCIAR
                                      );
  pck_unicoogps.P_GERA_PROPOSTA_R2(&2, --NRREGISTRO
                                   &3, --NRCONTRATO
                                   &4); --NRSEQCIAL_BNFCIAR
  commit;
end;
/
