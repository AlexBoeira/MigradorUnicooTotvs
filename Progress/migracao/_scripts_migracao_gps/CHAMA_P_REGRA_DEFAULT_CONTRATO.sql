--GERAR E ATRIBUIR REGRA DEFAULT NAS PROPOSTAS EM QUE EXISTE REGRA NO BENEFICIARIO MAS NAO A NIVEL DE PROPOSTA
--SE JA EXISTIR REGRA COM A DESCRICAO 'REGRA GENERICA PADRAO', ENTAO SERA ATRIBUIDA NAS PROPOSTAS
begin
  pck_unicoogps.P_REGRA_DEFAULT_CONTRATO(null, --pcdmodalidade number, 
                                         null, --pcdplano number, 
                                         null, --pcdtipo_plano number, 
                                         null  --pnrproposta number
                                         );
end;
--select count(*) from gp.REGRA_MENSLID--155142
--select count(*) from gp.REGRA_MENSLID_CRITER--13039835
--select count(*) from gp.REGRA_MENSLID_ESTRUT--150458
--select count(*) from gp.regra_menslid_propost--171678
