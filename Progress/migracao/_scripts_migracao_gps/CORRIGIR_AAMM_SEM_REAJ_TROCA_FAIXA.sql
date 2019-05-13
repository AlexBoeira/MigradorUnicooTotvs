--corrigir aa_mm_sem_reaj_faixa nos beneficiarios (errado pois cliente parameterizou errado paravpmc de inicio da legislacao)
declare
  novo_aamm number;
  aamm_vinculo number;
begin
  dbms_output.enable(null);
  for x in (select * from gp.usuario u) loop
    novo_aamm := to_char(x.dt_nascimento,'yyyy') + 60 || lpad(to_char(x.dt_nascimento,'mm'),2,'0');
    aamm_vinculo := to_char(x.dtiniciovinculounidade,'yyyy') || lpad(to_char(x.dtiniciovinculounidade,'mm'),2,'0'); 
    if aamm_vinculo > novo_aamm then
      novo_aamm := aamm_vinculo;
    end if;
    update gp.usuario u set u.aammsemreajtrocafx = novo_aamm
      where u.progress_recid = x.progress_recid
        and u.aammsemreajtrocafx <> novo_aamm;
  end loop;
end;



/*select u.dtiniciovinculounidade,
       u.aammsemreajtrocafx,
       u.dt_nascimento, -- substr(to_char(u.aammsemreajtrocafx),1,4), to_char(u.dt_nascimento,'yyyy'),
       u.cd_modalidade,
       u.nr_proposta,
       u.cd_usuario,
       u.dt_exclusao_plano,
       substr(to_char(u.aammsemreajtrocafx), 1, 4) -
       to_char(u.dt_nascimento, 'yyyy') idade_sem_reaj
  from gp.usuario u
 where \*substr(to_char(u.aammsemreajtrocafx),1,4) - to_char(u.dt_nascimento,'yyyy') <> 60
and*\
 (u.dt_exclusao_plano is null or u.dt_exclusao_plano > sysdate)
 and u.cd_modalidade in (10, 20)
 */