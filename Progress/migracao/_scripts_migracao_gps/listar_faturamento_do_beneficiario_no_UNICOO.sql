--listar todos os eventos de faturamento
select U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT CDUSUARIO,
       u.nrregistro,
       u.nrcontrato,
       f.tpfatura,
       p.cdcategserv,
       P.VLFATURADO VALOR_UNICOO,
       p.nrperiodo
  from unicoogps.detalhe_faturamento_premio p, unicoogps.faturamento f,
       unicoogps.USUARIO U
 where p.nrfatura = f.nrfatura
--   and f.tpfatura = '7' --mensalidade
--   and p.nrcontrato = '2505'
   and f.aosituacao_fatura = '0' --valida

--   and p.nrperiodo = '201901'
--   and p.cdcategserv = ' '
   AND U.NRSEQUENCIAL_USUARIO=P.NRSEQUENCIAL_USUARIO
   --and U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT like '%703000140300%' --7030001403304
   and u.nrregistro = 5217 and u.nrcontrato = '0017' and u.nrfamilia = 002896 and u.tpusuario = 00
   
--   and u.nrcontrato between '0017' and '0017'   --0590000139007
--   and u.nrfamilia = 25
   --and u.nrcontrato between '0590' and '0590'   --0590000139007
   --and u.nrfamilia = 000139
--group by U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT, f.tpfatura, p.cdcategserv
--group by U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT, u.nrregistro, u.nrcontrato, f.tpfatura, p.cdcategserv

order by U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT, p.cdcategserv
   --and U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT = '0017000657005'



--select * from unicoogps.detalhe_faturamento_premio p where p.nrsequencial_usuario = 2371
--select * from faturamento f where f.nrregistro = 5217 and f.nrcontrato = '0017' and f.nrperiodo = '201901'
--select * from usuario where nrcontrato = '0017' and nrfamilia = 25