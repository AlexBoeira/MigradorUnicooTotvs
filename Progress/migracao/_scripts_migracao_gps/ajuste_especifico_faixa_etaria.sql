-- ajuste espec�fico solicitado pela Unimed Nova Igua�u para as Faixas Etarias:
--   Planos F�sicos: filhos com idade at� 9999.
--   Jur�dicos:
--     Regulamentados: at� 24 anos, para ambos os sexos;
--     N�o Regulamentados: 17 para Masculino; 20 para Feminino;
update pl_gr_pa p
   set p.nr_idade_maxima = 9999
 where p.cd_modalidade in (1, 10) -- modalidades f�sicas
   and p.cd_grau_parentesco in (10, 20, 25, 30, 35, 40, 45, 70, 75); -- graus que representam FILHOS;

update pl_gr_pa p
   set p.nr_idade_maxima = 17
 where p.cd_modalidade in (15) -- modalidades jur�dica n�o regulamentada
   and p.cd_grau_parentesco in (10, 20, 70); -- graus que representam FILHO sexo MASCULINO;

update pl_gr_pa p
   set p.nr_idade_maxima = 20
 where p.cd_modalidade in (15) -- modalidades jur�dica n�o regulamentada
   and p.cd_grau_parentesco in (30, 40, 75); -- graus que representam FILHO sexo MASCULINO;

update pl_gr_pa p
   set p.nr_idade_maxima = 23
 where p.cd_modalidade in (15) -- modalidades jur�dica n�o regulamentada
   and p.cd_grau_parentesco in (25, 45); -- graus que representam FILHO sexo MASCULINO;

-- exce��o solicitada pela usu�ria chave
update pl_gr_pa p
   set p.nr_idade_maxima = 29
 where p.cd_modalidade = 20 -- modalidade JUR�DICA REGULAMENTADA
   and p.cd_plano = 14
   and p.cd_tipo_plano = 15
   and p.cd_grau_parentesco in (20, 40); -- equiparados FILHOS e FLHAS;
