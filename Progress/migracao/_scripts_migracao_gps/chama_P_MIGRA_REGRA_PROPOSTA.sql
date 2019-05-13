/*
begin
  pck_unicoogps.p_migra_regra_estrutura;
end;
*/
begin
  pck_unicoogps.p_migra_regra_proposta2('N',   --SIMULAR S/N
                                       null, --5217,   --NRREGISTRO
                                       null  --'0017'    --NRCONTRATO
                                       );
  pck_unicoogps.P_REGRA_DEFAULT_CONTRATO(null, --pcdmodalidade number, 
                                         null, --pcdplano number, 
                                         null, --pcdtipo_plano number, 
                                         null  --pnrproposta number
                                         );
  commit;                                       

end;

--select * from regra_menslid_propost p where p.cd_modalidade = 10 and p.nr_proposta = 23350
/*
delete from regra_menslid_criter rmc
where exists(select 1 from regra_menslid rm
              where rm.cdd_regra = rmc.cdd_regra
                and rm.log_livre_1 = 0); --nao eh regra modelo
delete from regra_menslid_propost rmp
where exists(select 1 from regra_menslid rm
              where rm.cdd_regra = rmp.cdd_regra
                and rm.log_livre_1 = 0); --nao eh regra modelo
delete from regra_menslid_estrut rme
where exists(select 1 from regra_menslid rm
              where rm.cdd_regra = rme.cdd_regra
                and rm.log_livre_1 = 0); --nao eh regra modelo
delete from regra_menslid rm
where rm.log_livre_1 = 0; --nao eh regra modelo
*/

/*
delete from gp.REGRA_MENSLID rm where rm.cdd_regra in (155147,155148);
delete from gp.REGRA_MENSLID_CRITER rmc where rmc.cdd_regra in (155147,155148);
delete from gp.REGRA_MENSLID_PROPOST rmp where rmp.cdd_regra in (155147,155148);
delete from gp.REGRA_MENSLID_ESTRUT rme where rme.cdd_regra in (155147,155148);
delete from gp.regra_menslid_reaj rmr where rmr.cdd_regra in (155147,155148);
*/
/*
truncate table gp.REGRA_MENSLID;
truncate table  gp.REGRA_MENSLID_CRITER;
truncate table  gp.REGRA_MENSLID_PROPOST;
truncate table  gp.REGRA_MENSLID_ESTRUT;
truncate table  gp.regra_menslid_reaj;
truncate table REGRA_MENSLID_sim;
truncate table  REGRA_MENSLID_CRITER_sim;
truncate table  REGRA_MENSLID_PROPOST_sim;
truncate table  REGRA_MENSLID_ESTRUT_sim;
truncate table  regra_menslid_reaj_sim;
truncate table  falha_processo_regra_menslid;
analyze table gp.REGRA_MENSLID       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_CRITER       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_PROPOST       compute statistics for table for all indexes for all indexed columns;
analyze table gp.REGRA_MENSLID_ESTRUT       compute statistics for table for all indexes for all indexed columns;
analyze table gp.regra_menslid_reaj       compute statistics for table for all indexes for all indexed columns;
analyze table falha_processo_regra_menslid compute statistics for table for all indexes for all indexed columns;


*/
--4 tipos de regra:
/*select count(*) from gp.regra_menslid rm where rm.des_regra like '% CONTRATO: %';             --104598
select count(*) from gp.regra_menslid rm where rm.des_regra like '% FAMILIA - CONTR: %';             --4
select count(*) from gp.regra_menslid rm where rm.des_regra like '% USU - CONTR: %';          --45754
select count(*) from gp.regra_menslid rm where rm.des_regra like '%PRECO LOTACAO - CONTR: %'; --0
*/
/*
select count(*) from REGRA_MENSLID;--155106
select count(*) from REGRA_MENSLID_CRITER;--12591991
select count(*) from REGRA_MENSLID_PROPOST;--171644
select count(*) from REGRA_MENSLID_ESTRUT;--150439
select count(*) from gp.regra_menslid_reaj;--150356
select count(*) from falha_processo_regra_menslid;--0

select * from REGRA_MENSLID_SIM;
select * from REGRA_MENSLID_CRITER_SIM;
select * from REGRA_MENSLID_PROPOST_SIM;
select * from REGRA_MENSLID_ESTRUT_SIM;
select * from regra_menslid_reaj_sim;

delete from REGRA_MENSLID_SIM;
delete from REGRA_MENSLID_CRITER_SIM;
delete from REGRA_MENSLID_PROPOST_SIM;
delete from REGRA_MENSLID_ESTRUT_SIM;
delete from regra_menslid_reaj_sim;
*/
/*
select max(progress_recid) from regra_menslid_sim--304858 ULTIMA 02/01 11h
select max(progress_recid) from regra_menslid_criter_sim--26154810 ULTIMA 02/01 11h
select * from regra_menslid_criter_sim c where c.progress_recid > 26153700 and c.dat_fim = '31/12/9999'

select r.cdd_regra, r.des_regra, c.cd_modulo, c.cd_grau_parentesco, c.dat_inic, c.dat_fim, c.nr_faixa_etaria, c.nr_idade_minima, 
c.nr_idade_maxima, c.vl_mensalidade_base from regra_menslid_criter_sim c, regra_menslid_sim r 
where c.progress_recid > 26153700 and c.cdd_regra = r.cdd_regra
order by r.cdd_regra, c.dat_inic, c.nr_faixa_etaria

select distinct cdd_regra from regra_menslid_criter_sim c where c.progress_recid > 26153700--155143 (T) e 155144 (B)
select cdd_regra, cd_modalidade, nr_proposta, cd_usuario from regra_menslid_propost_sim c where c.cdd_regra in (155143, 155144)
select * from regra_menslid_sim rs where rs.cdd_regra in (155143, 155144)
*/
