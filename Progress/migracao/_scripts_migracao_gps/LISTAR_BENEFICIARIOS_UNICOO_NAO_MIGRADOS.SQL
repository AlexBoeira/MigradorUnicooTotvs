--LISTAR BENEFICIARIOS DO UNICOO QUE NAO FORAM MIGRADOS PARA O TOTVS
select *
  from producao.usuario@unicoo_homologa us
 where not exists (select 1
          from gp.import_bnfciar ib
         where ib.num_seqcial_bnfciar = us.nrsequencial_usuario)
   and us.nrregistro_usuario <> 2000 -- DESCONSIDERAR USUARIO EVENTUAL
      
   --and (us.dtexclusao is null or us.dtexclusao > sysdate) -- HABILITAR ESSA LINHA PARA SOMENTE ATIVOS
   