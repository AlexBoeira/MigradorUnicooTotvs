-- listar erros importacao beneficiario por quantidades de ocorrencias
select e.des_erro, count(*)
from gp.erro_process_import e, import_bnfciar b
where e.num_seqcial_control = b.num_seqcial_control
and b.u##ind_sit_import = 'PE'

--  and (b.dt_exclusao_plano is null or b.dt_exclusao_plano > sysdate)

--and exists(select 1 from import_propost ip where ip.u##nr_contrato_antigo = b.nr_contrato_antigo and ip.num_livre_3 = '9972') --apenas erros em remidos

group by e.des_erro order by 2 desc;

--update gp.import_bnfciar ib set ib.u##ind_sit_import = 'RC', ib.ind_sit_import = 'RC' where ib.u##ind_sit_import = 'PE'

--select cd_modalidade, nr_proposta, num_livre_6, count(*) from gp.import_bnfciar group by cd_modalidade, nr_proposta, num_livre_6  having count(*) > 1
/*
begin
  for x in (
select ib.cd_modalidade, ib.nr_proposta, ib.num_livre_6, ib.nom_usuar, ib.cd_carteira_antiga c1, u.cd_carteira_antiga c2, u.nm_usuario from gp.import_bnfciar ib, gp.usuario u
        where ib.cd_modalidade = u.cd_modalidade
          and ib.nr_proposta = u.nr_proposta
          and ib.num_livre_6 = u.cd_usuario
          and ib.cd_carteira_antiga <> u.cd_carteira_antiga
) loop
  update gp.import_bnfciar ib set ib.u##ind_sit_import = 'RE', ib.ind_sit_import = 'RE' where ib.cd_carteira_antiga in (x.c1, x.c2);
end loop;
end;
select count(*) from gp.import_bnfciar ib where ib.u##ind_sit_import = 'RE'
*/
