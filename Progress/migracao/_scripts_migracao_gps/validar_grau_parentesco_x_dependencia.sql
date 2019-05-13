-- listar graus de parentesco com DEPARA das dependências do Unicoo
select re.cdvalor_interno,
       tu.notipusu,
       re.cdvalor_externo,
       g.ds_grau_parentesco,
       g.int_2              DEP_INICIAL,
       g.int_3              DEP_FINAL
  from rem_tab_conversao     r,
       rem_tab_conversao_exp re,
       tipo_de_usuario       tu,
       gra_par               g
 where r.nrseq = re.nrseq_tab_conversao
   and r.notabela = 'MIGRACAO_GRAU_PARENTESCO'
   and tu.tpusuario = re.cdvalor_interno
   and g.cd_grau_parentesco = re.cdvalor_externo
   and re.cdvalor_interno not between g.int_2 and g.int_3
