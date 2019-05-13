--listar os beneficiários que permanecem como RC mesmo após rodar ATUALIZA_SITUACAO.
--motivos prováveis:
--   1. não criou a proposta no TOTVS;
--   2. não importou o seu responsável no TOTVS;

-- dependente que cujo titular ocorreu erro
select ib.log_respons, ibr.cd_carteira_antiga CARTEIRA_RESPONSAVEL,
       ibr.u##ind_sit_import SIT_RESPONSAVEL, ib.* 
  from gp.import_bnfciar ib, gp.import_bnfciar ibr
   where ib.u##ind_sit_import = 'RC'
     and ib.cd_carteira_antiga <> ib.cdcarteiraorigemresponsavel
     and ibr.cd_carteira_antiga = ib.cdcarteiraorigemresponsavel
     and ibr.u##ind_sit_import = 'PE';

-- dependente em que nao encontrou responsável... INCONSISTENCIA!
select ib.log_respons, ib.*
  from gp.import_bnfciar ib
   where ib.u##ind_sit_import = 'RC'
     and ib.cd_carteira_antiga <> ib.cdcarteiraorigemresponsavel
     and not exists(select 1 from gp.import_bnfciar ibr
                            where ibr.cd_carteira_antiga = ib.cdcarteiraorigemresponsavel);
                            
-- titular que permanece como RC e sua proposta
select ip.u##ind_sit_import SIT_PROPOSTA, ip.cd_modalidade, ip.num_livre_10 PROPOSTA, ib.log_respons, ib.cd_carteira_antiga, ib.u##ind_sit_import, ib.* 
  from gp.import_bnfciar ib, gp.import_propost ip
   where ib.u##ind_sit_import = 'RC'
     and ib.cd_carteira_antiga = ib.cdcarteiraorigemresponsavel
     and ip.nr_contrato_antigo = ib.nr_contrato_antigo
;