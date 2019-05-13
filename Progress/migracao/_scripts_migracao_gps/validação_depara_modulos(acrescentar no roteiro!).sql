-- todas as categorias do Unicoo (que são usadas) devem estar mapeadas em DEPARA_MODULO
-- as categorias que aparecerem nessa listagem serão ignoradas pela migração!
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

-- todos os módulos de DEPARA_MODULO devem existir em MIGRACAO_MODULO_PADRAO
-- os módulos que aparecerem nessa listagem ficarão sem relacionamento e apresentarão erro na importação da proposta (Progress)!
select * from depara_modulo dm where not exists(select 1 from migracao_modulo_padrao mmp where mmp.cdmodulo = dm.cdmodulo);
