--ajustar USUMODU.DT_CANCELAMENTO quando o modulo agregado esta cancelado no Unicoo mas migrou ativo no TOTVS (erro ja corrigido na PCK da producao - 12/03/19 Alex Boeira)
begin
  for x in (select m.cd_modalidade,
                   m.nr_proposta,
                   m.cd_usuario,
                   m.cd_modulo,
                   m.dt_inicio,
                   m.dt_cancelamento,
                   c.cdcategserv,
                   c.dtinclusao,
                   c.dtexclusao,
                   m.progress_recid recid_usumodu
              from gp.usumodu                                    m,
                   rem_tab_conversao                             r,
                   rem_tab_conversao_exp                         e,
                   producao.criterios_do_usuario@unicoo_homologa c,
                   gp.import_bnfciar                             ib
             where r.notabela = 'MIGRACAO_MODULO'
               and e.nrseq_tab_conversao = r.nrseq
               and m.cd_modulo = e.cdvalor_externo
               and c.cdcategserv = e.cdvalor_interno
               and ib.num_seqcial_bnfciar = c.nrsequencial_usuario
               and m.cd_modalidade = ib.cd_modalidade
               and m.nr_proposta = ib.nr_proposta
               and m.cd_usuario = ib.num_livre_6
               and m.dt_cancelamento is null
               and c.dtexclusao is not null) loop
               
    update gp.usumodu m set m.dt_cancelamento = x.dtexclusao where m.progress_recid = x.recid_usumodu;               
  
  end loop;
end;
