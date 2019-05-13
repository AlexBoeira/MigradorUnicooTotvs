-- ajuste específico solicitado pela Unimed Nova Iguaçu para as Faixas Etarias:
--   Planos Físicos: filhos com idade até 9999.
--   Jurídicos:
--     Regulamentados: até 24 anos, para ambos os sexos;
--     Não Regulamentados: 17 para Masculino; 20 para Feminino;
update pl_gr_pa p
   set p.nr_idade_maxima = 9999
 where p.cd_modalidade in (1, 10) -- modalidades físicas
   and p.cd_grau_parentesco in (10, 20, 25, 30, 35, 40, 45, 70, 75); -- graus que representam FILHOS;

update pl_gr_pa p
   set p.nr_idade_maxima = 17
 where p.cd_modalidade in (15) -- modalidades jurídica não regulamentada
   and p.cd_grau_parentesco in (10, 20, 70); -- graus que representam FILHO sexo MASCULINO;

update pl_gr_pa p
   set p.nr_idade_maxima = 20
 where p.cd_modalidade in (15) -- modalidades jurídica não regulamentada
   and p.cd_grau_parentesco in (30, 40, 75); -- graus que representam FILHO sexo MASCULINO;

update pl_gr_pa p
   set p.nr_idade_maxima = 23
 where p.cd_modalidade in (15) -- modalidades jurídica não regulamentada
   and p.cd_grau_parentesco in (25, 45); -- graus que representam FILHO sexo MASCULINO;

-- exceção solicitada pela usuária chave
update pl_gr_pa p
   set p.nr_idade_maxima = 29
 where p.cd_modalidade = 20 -- modalidade JURÍDICA REGULAMENTADA
   and p.cd_plano = 14
   and p.cd_tipo_plano = 15
   and p.cd_grau_parentesco in (20, 40); -- equiparados FILHOS e FLHAS;
