/*
=====================================================
                        ESTRUTURA DE PRODUTO E COBERTURAS
=====================================================
*/

/* 
    MODALIDADES NAO UTILIZADAS
    A priori podem ser apagadas, porem é necessario verificar se nao existem
    parametrizacoes para estas modalidades. 
    VALIDADA
*/ 
select m.cd_modalidade, m.ds_modalidade 
from gp.modalid m 
where 
    not exists (select  1 from gp.pla_sau p where p.cd_modalidade = m.cd_modalidade);
    
/* 
    PLANOS DE SAUDE NAO UTILIZADOS
    A priori podem ser apagados, porem é necessario verificar se nao existem
    parametrizacoes para estes planos de saude.
    VALIDADA
 */
select p.cd_modalidade, m.ds_modalidade, p.cd_plano, p.nm_plano 
from gp.pla_sau p, gp.modalid m
where 
    p.cd_modalidade = m.cd_modalidade and
    not exists (select  *
                   from gp.ti_pl_sa tp
                   where tp.cd_modalidade = m.cd_modalidade and
                             tp.cd_plano = p.cd_plano)
order by 1, 3;

/*
    ESTRUTURAS DE PRODUTO SEM PROPOSTAS
    A priori podem ser apagadas, porém é necessario verificar se nao existem
    parametrizacoes para estas estruturas de produto.
    VALIDADA
*/
select m.cd_modalidade, m.ds_modalidade, p.cd_plano, p.nm_plano, tp.cd_tipo_plano, tp.nm_tipo_plano 
from gp.modalid m, gp.pla_sau p, gp.ti_pl_sa tp
where
    p.cd_modalidade = m.cd_modalidade and
    tp.cd_modalidade = p.cd_modalidade and
    tp.cd_plano = p.cd_plano and
    not exists (select 1 
                    from gp.propost pr
                    where pr.cd_modalidade = tp.cd_modalidade
                        and pr.cd_plano = tp.cd_plano
                        and pr.cd_tipo_plano = tp.cd_tipo_plano)
order by 1, 3, 5;

/*
    MODULOS DE COBERTURA CADASTRADOS PARA ESTRUTURAS INEXISTENTES
    Podem ser apagadas livremente.    
    VALIDADA
*/
select * from gp.pla_mod p
where not exists (select 1 
                         from gp.pla_sau pl
                         where pl.cd_plano = p.cd_plano
                             and pl.cd_modalidade = p.cd_modalidade)
                             
/* 
    TABELAS DE PRECO CADASTRADAS PARA MODULOS INEXISTENTES
    Podem ser apagadas livremente
    VALIDADA 
*/
select * from gp.tabpremo p
where not exists(select 1
                         from gp.mod_cob m
                         where m.cd_modulo = p.cd_modulo);
                             
/* 
    PROPOSTAS CANCELADAS SO PODEM POSSUIR BENEF. EVENTUAIS
    Propostas canceladas que possuem beneficiários que nao sao eventuais
  Basicamente verifica propostas em situação 90 com beneficiarios com
  log-17 <> 1, ou seja, propostas canceladas com beneficiarios ativos.
  VALIDADA
*/
select p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.nr_proposta
  from gp.propost p
 where p.cd_sit_proposta = 90
   and exists (select 1
          from gp.usuario u
         where u.cd_modalidade = p.cd_modalidade
           and u.nr_proposta = p.nr_proposta
           and u.cd_motivo_cancel = 0 ------- fabiano
           and u.log_17 <> 1);
/*
    BENEFICIARIOS EXCLUIDOS COM USU_MODU SEM CANCELAMENTO
    Setar a data de exclusao do modulo 
    VALIDADA
*/
select u.cd_modalidade, u.nr_proposta, u.cd_usuario, u.nm_usuario
  from gp.usuario u
 where u.cd_sit_usuario = 90
   and exists (select *
          from gp.usumodu m
         where m.cd_modalidade = u.cd_modalidade
           and m.nr_proposta = u.nr_proposta
           and m.cd_usuario = u.cd_usuario
           and m.dt_cancelamento is null)
 order by 1, 2
                                                        
/* 
    BENEFICIARIOS COM DATA DE EXCLUSAO SEM MOTIVO DE CANCELAMENTO
    Isso pode impactar no SIB
    VALIDADA
*/                                
select u.cd_modalidade,
       u.nr_proposta,
       u.cd_usuario,
       u.nm_usuario,
       u.dt_exclusao_plano,
       u.cd_motivo_cancel
  from gp.usuario u
 where u.dt_exclusao_plano is not null
   and (u.cd_motivo_cancel = 0 or u.cd_motivo_cancel is null)

/* 
    PROPOSTAS EFETIVADAS SEM TERMO DE ADESAO
    Propostas nas situacoes 5 e 7 devem obrigatoriamente possuir ter-ade.
    VALIDADA
*/
select p.cd_modalidade, p.nr_proposta, p.cd_sit_proposta, p.nr_ter_adesao
from gp.propost p
where p.cd_sit_proposta in (5, 7)
    and not exists (select 1
                          from gp.ter_ade t
                          where t.cd_modalidade = p.cd_modalidade
                            and t.nr_ter_adesao = p.nr_ter_adesao)

/* 
    PROPOSTA CANCELADA COM TERMO DE ADESAO NAO CANCELADO
    Propostas canceladas devem obrigatoriamente ter os termos cancelados.
    VALIDADA
*/                                
select p.cd_modalidade, p.nr_proposta, t.nr_ter_adesao, t.dt_cancelamento
from gp.propost p, gp.ter_ade t
where t.nr_ter_adesao = p.nr_ter_adesao
  and t.cd_modalidade = p.cd_modalidade
  and p.cd_sit_proposta = 90
  and t.dt_cancelamento is null
order by 1, 2

/* 
    PROPOSTA CANCELADA COM BENEFICIARIOS ATIVOS
    Propostas em situacao 90 nao podem possuir beneficiarios em situacao
    menor do que 90.
    VALIDADA
*/
select p.cd_modalidade, p.nr_proposta
from gp.propost p
where p.cd_sit_proposta = 90
    and exists(select *
       from gp.usuario u
       where u.cd_modalidade = p.cd_modalidade
         and u.nr_proposta = p.nr_proposta
         and u.cd_sit_usuario < 90
         and u.log_17 <> 1)

/* 
    USUARIOS SEM CARTEIRA DE IDENTIFICACAO
    Todos os usuarios devem possuir carteira de identificacao.
    VALIDADA
*/
select * 
from gp.usuario u, gp.ter_ade t, gp.propost p
where  t.cd_modalidade = p.cd_modalidade
     and t.nr_ter_adesao = p.nr_ter_adesao
     and u.cd_modalidade = p.cd_modalidade
     and u.nr_proposta = p.nr_proposta
     and not exists (select *
                           from gp.car_ide c
                           where c.cd_modalidade = t.cd_modalidade
                               and c.nr_ter_adesao = t.nr_ter_adesao)
 
 /* 
    PROPOSTAS CANCELADAS SEM MOTIVO DE CANCELAMENTO
    Todas as propostas canceladas devem possuir um motivo de cancelamento valido.
    VALIDADA
*/
select * from gp.propost p, gp.ter_ade t
where t.nr_ter_adesao = p.nr_ter_adesao
    and t.cd_modalidade = p.cd_modalidade
    and p.cd_sit_proposta = 90
    and (t.cd_motivo_cancel is null or t.cd_motivo_cancel = 0)
 
/*
    BENEFICIARIOS DE PROPOSTAS CANCELADAS SEM DATA DE EXCLUSAO
    VALIDADO
*/   
select p.cd_modalidade, p.nr_proposta, u.cd_usuario
  from gp.propost p, gp.usuario u
 where p.cd_sit_proposta = 90
   and u.cd_modalidade = p.cd_modalidade
   and u.nr_proposta = p.nr_proposta
   and u.dt_exclusao_plano is null
   and u.log_17 = 0

/*
    USUARIO EVENTUAIS DE PROPOSTAS CANCELADAS SEM DATA DE EXCLUSAO
    Esta situacao nao pode ocorrer pois a nivel de negocio nao faz sentido.
    VALIDADO - 2921 eventuais sem data de exclusao
*/
select p.cd_modalidade, p.nr_proposta, p.nr_contrato_antigo from gp.propost p, gp.usuario u
    where p.cd_sit_proposta = 90
        and u.cd_modalidade = p.cd_modalidade
        and u.nr_proposta = p.nr_proposta
        and u.dt_exclusao_plano is null        
        and u.log_17 = 1
        

/* 
    CANCELAMENTO DA COBERTURA ANTERIOR A INCLUSAO DO BENEFICIARIO
    Usuários com modulos cujo cancelamento é anterior a data de inclusao no
    plano de saúde. Em produção isso jamais ocorreria pois é impossível cancelar
    um modulo de cobertura antes da propria inclusao do beneficiario.
    VALIDADA - Apenas para proposta 51 - 598, modulos 900, 903, 904
*/
select u.cd_modalidade, u.nr_proposta, u.nm_usuario, c.cd_modulo, u.dt_inclusao_plano, c.dt_cancelamento
from gp.usumodu c, gp.usuario u, gp.propost p
where c.cd_modalidade = u.cd_modalidade
    and c.nr_proposta = u.nr_proposta
    and c.cd_usuario = u.cd_usuario
    and c.dt_cancelamento < u.dt_inclusao_plano 
    and p.cd_modalidade = u.cd_modalidade
    and p.nr_proposta = u.nr_proposta

/*  
    COBERTURAS OBRIGATORIAS AUSENTES DA PROPOSTA
    Caso uma estrutura de produto possua cobertura obrigatoria, obrigatoriamente a
    proposta deve possuir a mesma cobertura.
    VALIDADA - 248 coberturas obrigatorias ausentes na proposta
*/
select p.cd_modalidade, p.cd_plano, p.cd_tipo_plano, p.cd_modulo
  from gp.pla_mod p
 where p.lg_obrigatorio = 1
   and not exists (select *
          from gp.pro_pla pr
         where pr.cd_modalidade = p.cd_modalidade
           and pr.cd_modulo = p.cd_modulo
           and pr.cd_plano = p.cd_plano
           and pr.cd_tipo_plano = p.cd_tipo_plano) 
 order by 1, 2, 3


/* 
    PROCEDIMENTOS QUE POSSUEM COBERTURA EM ALGUM MODULO SEM TRANSACAO
    Se existe cobertura a um procedimento, obrigatoriamente deve existir o mesmo na
    transacao. Caso contrario o beneficiario possui cobertura mas nao pode solicitar.
    VALIDADA - 59 casos encontrados
*/
select c.cd_modalidade,
       c.cd_plano,
       c.cd_tipo_plano,
       c.cd_modulo,
       m.ds_modulo,
       c.cd_amb,
       p.ds_procedimento##1
  from gp.mod_cob m, gp.pl_mo_am c, gp.ambproce p
 where c.cd_modulo = m.cd_modulo
   and p.cdprocedimentocompleto = c.cd_amb
   and not exists
 (select *
          from gp.trmodamb t
         where t.cd_modulo = m.cd_modulo
           and t.cd_esp_amb = p.cd_esp_amb
           and t.cd_grupo_proc_amb = p.cd_grupo_proc_amb
           and t.cd_procedimento = p.cd_procedimento
           and t.dv_procedimento = p.dv_procedimento)
                             
/* 
    INSUMOS QUE POSSUEM COBERTURA EM ALGUM MODULO SEM TRANSACAO
    Se existe cobertura a um insumo, obrigatoriamente deve existir o mesmo na
    transacao. Caso contrario o beneficiario "possui cobertura mas nao pode solicitar".
    VALIDADA - 59 casos encontrados (mesmas estruturas dos procedimentos acima)
*/
select c.cd_modalidade,
       c.cd_plano,
       c.cd_tipo_plano,
       c.cd_modulo,
       m.ds_modulo,
       c.cd_amb,
       p.ds_procedimento##1
  from gp.mod_cob m, gp.pl_mo_am c, gp.ambproce p
 where c.cd_modulo = m.cd_modulo
   and p.cdprocedimentocompleto = c.cd_amb
   and not exists
 (select *
          from gp.trmodamb t
         where t.cd_modulo = m.cd_modulo
           and t.cd_esp_amb = p.cd_esp_amb
           and t.cd_grupo_proc_amb = p.cd_grupo_proc_amb
           and t.cd_procedimento = p.cd_procedimento
           and t.dv_procedimento = p.dv_procedimento)

/*
    VERIFICA PROCEDIMENTOS CADASTRADOS NA TRANSACAO SEM ESPECIALIDADE
    Os procedimentos devem possuir a parametrizacao de especialidade
    VALIDADA - procedimento 60900458 nao cadastrado para trasacoes 1020,2020,3020,4020 modulos 11,41,141
*/
select t.cd_transacao, t.cd_modulo, t.cd_esp_amb, t.num_proced_complet
  from gp.trmodamb t
 where not exists (select *
          from gp.ambesp e
         where e.cd_esp_amb = t.cd_esp_amb
           and e.cd_grupo_proc_amb = t.cd_grupo_proc_amb
           and e.cd_procedimento = t.cd_procedimento
           and e.dv_procedimento = t.dv_procedimento)
 order by 1, 2, 3

/*  
    Consistir se todos os tipos de procedimento da partinsu estao na tratipin
    VALIDADA
*/
select *
  from gp.partinsu i
 where not exists
 (select * from gp.tratipin t where t.cd_tipo_insumo = i.cd_tipo_insumo)

/* 
    CONTRATANTES SEM CLIENTE FINANCEIRO NO EMS
    Todos os contratantes devem ser clientes financeiro no EMS para que possa
    ser emitido titulos contra o mesmo.
    VALIDADO - 5 Contratantes
 */
select c.nr_insc_contratante,
       c.cd_contratante,
       p.nm_pessoa,
       p.dt_nascimento,
       p.cd_cpf
  from gp.contrat c, gp.pessoa_fisica p
 where c.id_pessoa = p.id_pessoa
   and not exists (select *
          from ems5.cliente cli
         where cli.cdn_cliente = c.cd_contratante)

/*
    CONTRATANTE POSSUI REFERENCIA A PESSOA FISICA INEXISTENTE 
    Este relacionamento obrigatoriamente deve estar correto.
    VALIDADA - 40 contratantes
*/
select c.nr_insc_contratante, c.nm_contratante
  from gp.contrat c
 where c.in_tipo_pessoa = 'F'
   and not exists
 (select * from gp.pessoa_fisica p where p.id_pessoa = c.id_pessoa)
                         
/*
    CONTRATANTE POSSUI REFERENCIA A PESSOA JURIDICA INEXISTENTE 
    Este relacionamento obrigatoriamente deve estar correto.
    VALIDADA - 11 contratantes 
*/
select c.nr_insc_contratante, c.nm_contratante
  from gp.contrat c
 where c.in_tipo_pessoa = 'J'
   and not exists
 (select * from gp.pessoa_juridica p where p.id_pessoa = c.id_pessoa)
                                           
                                        
/* 
    PRESTADORES SEM FORNECEDOR FINANCEIRO NO EMS
    Todos os prestadores devem ser clientes fornecedores no EMS para que possa
    ser emitido titulos contra o mesmo.
    VALIDADA - 162 prestadore, 161 estáo com contratante zerado
 */
select pr.cd_unidade, pr.cd_prestador, pr.cd_contratante, pr.nm_prestador
  from gp.preserv pr
 where not exists (select *
          from ems5.fornecedor f
         where f.cdn_fornecedor = pr.cd_contratante)
 order by 1, 2;
 

/* 
  PROPOSTAS COM REGULAMENTACAO INVALIDA
  Verifica as propostas com regulamentação inválida.
  VALIDADA
*/
select * 
from gp.propost p
where not exists (select * from gp.reg_plano_saude r where r.idi_registro = p.idi_plano_ans)


select p.cdn_motiv_cancel, p.nr_contrato_antigo from gp.propost p 
where p.cd_sit_proposta = 90
and p.cdn_motiv_cancel = 0;

select i. from gp.propost p, import_propost i
where i.nr_contrato_antigo = p.nr_contrato_antigo



