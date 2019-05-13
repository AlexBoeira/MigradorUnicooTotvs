prompt Importing table mig_tab_conversao...
set feedback off
set define off
insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (11, 'CONV.DO TIPO ATUAL.CADASTRAL', 'Conversao do Tipo de Atualizacao Cadastral para um Status do Cartao (tab. USUARIO_IDENTIFICACAO)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (37, 'CATEGORIA DE USUARIO - PTU', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (16, 'GRAU DE PARENTESCO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (15, 'CONVERSAO DE SEXO PTU', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (17, 'PTU_GRAU_PARTICIPACAO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (18, 'PTU_TIPO_ACOMODACAO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (19, 'PTU_TIPO_GUIA', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20, 'PTU_CDVIA_ACESSO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (22, 'PRESTADOR PROPRIO PTU', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (23, 'TIPO DE PRESTADOR PTU', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (24, 'PTU_VERSAO_PTU', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (25, 'PTU_TIPO_PLANO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (26, 'PTU_PRODUTO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (27, 'GRUPO DE SERVICO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (14, 'ESTADO CIVIL TITULAR', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (28, 'REDE REFERENCIADA', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (31, 'CONVERSAO PTU CODIGO SERVICO', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (32, 'MOTIVO DE CANCELAMENTO - ANS', 'Tabela utilizada no Layout da
ANS - Instrucao Normativa No.7');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (33, 'CO-PARTICIPACAO - ANS', 'Tabela utilizada no Layout da ANS -
Instrucao Normativa No.7');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (36, 'ESTADO CIVIL - PTU', null);

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (100, 'VINCULO DO BENEFICIARIO', 'Tabela utilizada no Layout da ANS');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20101, 'CONVERSAO_GRUPO_CONTRATO', 'Tabela utilizada para obter o c�digo de grupo de empresa referente ao grupo de contrato na P_INTEGRA_FATURAMENTO');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (1, 'MOTIVO_INCLUSAO_ANS', 'Convers�o utilizada no Layout da ANS');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (2, 'MOTIVO_SAIDA.2.02.01', 'C�digo de Motivos de Sa�da para a vers�o do Schema TISS 2.02.01');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (3, 'MOTIVO_SAIDA.2.01.03', 'C�digo de Motivos de Sa�da para a vers�o do Schema TISS 2.01.03');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (4, 'RELACAO_DEPENDENCIA_DMED', 'Convers�o da rela��o de dep�ndencia para arquivo DMED');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (48, 'REM_CONTROLE_A500', 'Para os clientes que usam s�ries alfanum�ricas, ser� feito um De-Para para as s�ries das guias, do valor alfanum�rico para um num�rico, concatenando-a com o n�mero da guia para identificar a nota.');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (6, 'SEGMENTACAO PRODUTO', 'Tabela de convers�o da Segmenta��o do Produto (ANSxPTU)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (5, 'SEGMENTACAO PRODUTO', 'Tabela de convers�o da Segmenta��o do Produto (ANSxPTU)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (7, 'ESPECIALIDADE_CFM', 'Tabela de Convers�o de Especialidade do arquivo CPM XML');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (8, 'TITULACAO_CFM', 'Tabela de Convers�o de Titula��o do arquivo CPM XML');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (12, 'MIGRACAO_MODULO', 'Tabela de convers�o de Modulos (tabela Categoria no Unicoo)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (13, 'MIGRACAO_MOTIVO_CANCELAMENTO', 'Tabela de convers�o de Motivo de Cancelamentos (tabela Motivo_de_Cancelamento no Unicoo)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (21, 'MIGRACAO_GLOSA', 'Conversao Ocorrencia x Glosa');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20104, 'MIGRACAO_TIPO_VINCULO', 'Tabela de convers�o de Tipo de Vinculo Prestador');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20105, 'MIGRACAO_TIPO_ENDERECO', 'Tabela de Convers�o de Tipo de Endere�o');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20106, 'MIGRACAO_TABELA_PRECO', 'Tabela de Pre�o');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20107, 'MIGRACAO_INDICADOR_PERIODO', 'Tabela de Convers�o de Indicador de Per�odo(tabela Tipo_de_Criterio)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20108, 'MIGRACAO_ID_CONTROLE_QTDE', 'Tabela de Convers�o Do Controle de Qtd. De Servi�o(tabela Tipo_de_Criterio)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20109, 'MIGRACAO_GRUPO_PROCEDIMENTO', 'Tabela de convers�o de Grupo de Procedimento (tabela Classe_de_Servico no Unicoo)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20110, 'MIGRACAO_PROCEDIMENTOS', 'Tabela de convers�o de Procedimentos (tabela Servico no Unicoo)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20111, 'MIGRACAO_RAMO_ATIVIDADE', 'Tabela de convers�o de ramo de atividade(tabela ramo_atividade no Unicoo)');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20112, 'MIGRACAO_FATOR_MODERADOR', 'Tabela de Convers�o Fator Moderador');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (20113, 'MIGRACAO_CIDADE', 'DEPARA para migracao para TOTVS12');

insert into mig_tab_conversao (NRSEQ, NOTABELA, TXOBSERVACAO)
values (10, 'MIGRACAO_ESTADO_CIVIL', 'Tabela de convers�o de Estado Civil (tabela Estado_Civil no Unicoo)');

prompt Done.
