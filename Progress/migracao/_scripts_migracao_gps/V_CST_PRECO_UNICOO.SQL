create or replace view gp.v_cst_preco_unicoo as
select U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT CDUSUARIO,
       u.nrregistro,
       u.nrcontrato,
       p.cdcategserv,
       P.VLFATURADO VALOR_UNICOO
  from unicoogps.detalhe_faturamento_premio p, unicoogps.faturamento f, unicoogps.USUARIO U
 where p.nrfatura = f.nrfatura
   and f.tpfatura = '7'
--   and p.nrcontrato = '2505'
   and p.nrperiodo = '201901'
--   and p.cdcategserv = ' '
   AND U.NRSEQUENCIAL_USUARIO=P.NRSEQUENCIAL_USUARIO
   --and U.NRCONTRATO||LPAD(U.NRFAMILIA,6,0)||U.TPUSUARIO||U.NRDIGITOCT = '0017000657005'
;
