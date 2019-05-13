-- listar contratos e benefici�rios de planos ADES�O (contratante jur�dico mas o respons�vel financeiro � o respons�vel de cada fam�lia)
select c.nrregistro REG_CONTRATO, p2.nopessoa, c.nrcontrato CONTRATO, c.cdcontrato_padrao CONT_PADRAO, c.dtiniciocontrato INI_CONTRATO, c.dtfimcontrato FIM_CONTRATO, 
c.tpfatura TIPO_FATURAMENTO, u.nrfamilia FAMILIA, u.tpusuario TIPO_USUARIO, u.nrregistro_usuario REG_USUARIO, p.nopessoa NOME, p.nrcgc_cpf CPF, 
u.dtinicio INICIO_USUARIO, u.dtexclusao EXCLUSAO_USUARIO, u.cdlotacao LOTACAO
from usuario u, contrato_da_pessoa c, pessoa p, pessoa p2
where c.tpfatura = 'U'
and c.nrregistro = u.nrregistro
and c.nrcontrato = u.nrcontrato
and p.nrregistro = u.nrregistro_usuario
and p2.nrregistro = c.nrregistro

