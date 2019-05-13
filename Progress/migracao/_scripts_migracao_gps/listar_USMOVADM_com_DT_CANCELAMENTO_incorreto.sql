--listar casos em que usmovadm esta criado com dt_cancelamento errado
--logica comentada para eliminar os registros!
declare
  vdt_menor date;
begin
  dbms_output.enable(null);
  for x in (select u.cd_modalidade,
                   u.nr_proposta,
                   u.cd_usuario,
                   um.cd_modulo,
                   a.cd_produto,
                   pp.dt_cancelamento  CAN_PRO_PLA,
                   u.dt_exclusao_plano EXC_BENEF,
                   a.dt_cancelamento   CAN_USMOVADM,
                   a.progress_recid    recid_usmovadm
              from gp.usuario  u,
                   gp.usumodu  um,
                   gp.prmodexp pr,
                   gp.usmovadm a,
                   gp.propost  p,
                   gp.pro_pla  pp
             where um.cd_modalidade = u.cd_modalidade
               and um.nr_proposta = u.nr_proposta
               and um.cd_usuario = u.cd_usuario
               and pr.cd_modulo = um.cd_modulo
               and a.cd_modalidade = u.cd_modalidade
               and a.nr_proposta = u.nr_proposta
               and a.cd_usuario = u.cd_usuario
               and a.cd_produto = pr.cd_produto
               and a.cd_und_adm_produto = pr.cd_und_adm_produto
               and p.cd_modalidade = u.cd_modalidade
               and p.nr_proposta = u.nr_proposta
               and pr.cd_modalidade = u.cd_modalidade
               and p.cd_plano = pr.cd_plano
               and p.cd_tipo_plano = pr.cd_tipo_plano
               and a.in_acomodacao = pr.in_acomodacao
               and u.dt_exclusao_plano is not null
               and pp.cd_modalidade = u.cd_modalidade
               and pp.nr_proposta = u.nr_proposta
               and pp.cd_modulo = um.cd_modulo
               and (u.dt_exclusao_plano is not null or
                   pp.dt_cancelamento is not null)
            
            ) loop
    vdt_menor := null;
    if x.exc_benef is not null and x.can_pro_pla is not null then
      if x.exc_benef < x.can_pro_pla then
        vdt_menor := x.exc_benef;
      else
        vdt_menor := x.can_pro_pla;
      end if;
    else
      if x.exc_benef is not null then
        vdt_menor := x.exc_benef;
      else
        vdt_menor := x.can_pro_pla;
      end if;
    end if;
  
    if x.can_usmovadm is not null and x.can_usmovadm <> vdt_menor then
      dbms_output.put_line('CASO 1: ' || x.cd_modalidade || ';' ||
                           x.nr_proposta || ';' || x.cd_usuario || ';' ||
                           x.cd_modulo || ';' || x.cd_produto || ';' ||
                           x.can_pro_pla || ';' || x.exc_benef || ';' ||
                           x.can_usmovadm);
      --delete from gp.usmovadm a where a.progress_recid = x.recid_usmovadm;
    end if;
  
    if x.can_usmovadm is null and vdt_menor is not null then
      dbms_output.put_line('CASO 2: ' || x.cd_modalidade || ';' ||
                           x.nr_proposta || ';' || x.cd_usuario || ';' ||
                           x.cd_modulo || ';' || x.cd_produto || ';' ||
                           x.can_pro_pla || ';' || x.exc_benef || ';' ||
                           x.can_usmovadm);
      --delete from gp.usmovadm a where a.progress_recid = x.recid_usmovadm;
    end if;
  
  end loop;
end;

--truncate table gp.usmovadm;
