--SETAR RESPONSAVEL FINANCEIRO E LOTACAO DO DEPENDENTE IGUAL AO SEU TITULAR
declare
begin
  for x in (select ud.progress_recid RECID_DEPENDENTE,
                   ut.cdn_respons_financ,
                   ut.cdn_lotac,
                   ud.cdn_respons_financ RESP_ERRADO,
                   ud.cdn_lotac LOTAC_ERRADO
              from gp.usuario ud, gp.usuario ut
             where ud.cd_modalidade = ut.cd_modalidade
               and ud.nr_proposta = ut.nr_proposta
               and ud.cd_titular = ut.cd_usuario
               and (ud.cdn_respons_financ <> ut.cdn_respons_financ or
                   ud.cdn_lotac <> ut.cdn_lotac)) loop
  
    update gp.usuario u
       set u.cdn_respons_financ = x.cdn_respons_financ,
           u.cdn_lotac          = x.cdn_lotac
     where u.progress_recid = x.recid_dependente;
  end loop;
end;