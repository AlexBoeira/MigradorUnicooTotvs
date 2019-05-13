-- Os prestadores que forem listados nao serao migrados para o TOTVS pois nao possuem FORNECEDOR correspondente no EMS5.
-- caso seja necessario carrega-los no TOTVS, devem ser criados os FORNECEDORES e executar esse script novamente.
select pu.* from producao.prestador@unicoo_homologa pu
where not exists(select 1
          FROM TI_PESSOA P, EMS5.FORNECEDOR F, EMS5.FORNEC_FINANC FF
         WHERE P.NRREGISTRO = pu.NRREGISTRO_PREST
           and p.cdn_fornecedor = f.cdn_fornecedor
           and ff.cdn_fornecedor = f.cdn_fornecedor)
           