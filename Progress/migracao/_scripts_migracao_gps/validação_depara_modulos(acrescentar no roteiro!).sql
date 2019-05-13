-- todas as categorias do Unicoo (que s�o usadas) devem estar mapeadas em DEPARA_MODULO
-- as categorias que aparecerem nessa listagem ser�o ignoradas pela migra��o!
select *
  from categoria c
 where (exists (select 1
                  from categoria_de_servico cds
                 where cds.cdcategserv = c.cdcategoria) or exists
        (select 1
           from categoria_de_servico_contr_pes pes
          where pes.cdcategserv = c.cdcategoria))
   and not exists
 (select 1 from depara_modulo dm where dm.cdcategserv = c.cdcategoria);

-- todos os m�dulos de DEPARA_MODULO devem existir em MIGRACAO_MODULO_PADRAO
-- os m�dulos que aparecerem nessa listagem ficar�o sem relacionamento e apresentar�o erro na importa��o da proposta (Progress)!
select * from depara_modulo dm where not exists(select 1 from migracao_modulo_padrao mmp where mmp.cdmodulo = dm.cdmodulo);
