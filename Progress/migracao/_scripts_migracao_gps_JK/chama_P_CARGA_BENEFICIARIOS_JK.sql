set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
  begin
    -- parametros
    --   SOMENTE_ATIVOS       : 'S', 'N'. Quando 'S', considera apenas planos ativos. Quando 'N', considera todos;
    --   INICIALIZAR_SEQUENCES: 'S', 'N'. Usar 'S' somente na primeira vez, para recome�ar a numera��o das propostas a partir de 1 para cada modalidade.
    --                                     Nas demais utiliza��es enviar 'N', para que respeite a numera��o j� gerada nas execu��es anteriores.
    --   CONTRATO             : se NULL, considera todos. Se preenchido, considera apenas esse contrato.
    pck_unicoogps.P_CARGA_BENEFICIARIOS('N', --SOMENTE_ATIVOS
                                        null, --NRREGISTRO
										null, --NRCONTRATO
										null  --NRSEQCIAL_BNFCIAR
										);
    commit;
  end;
end;
/
