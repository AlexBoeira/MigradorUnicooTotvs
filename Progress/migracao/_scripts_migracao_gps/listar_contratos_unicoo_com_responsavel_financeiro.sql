--listar contratos com seu responsável financeiro (direita para esquerda, quando preenchido)
select distinct cp.cdcontrato,
                cp.tpcontrato,
                cp.nocontrato,
                cp.tpusu_contrato,
                cp.cdcobertura_ans,
                cp.cdcontratacao_ans,
                cp.cdncontratacao_ptu,
                cdp.nrcontrato,
                cdp.nrregistro,
                p1.nopessoa,
                cdp.nrpessoa_paga,
                p2.nopessoa,
                f.nrpessoa_paga,
                p3.nopessoa
  from contrato_da_pessoa cdp,
       pessoa             p1,
       pessoa             p2,
       pessoa             p3,
       familia            f,
       contrato_padrao    cp
 where p1.nrregistro = cdp.nrregistro
   and p2.nrregistro(+) = cdp.nrpessoa_paga
   and f.nrregistro = cdp.nrregistro
   and f.nrcontrato = cdp.nrcontrato
   and p3.nrregistro(+) = f.nrpessoa_paga
   and cp.cdcontrato = cdp.cdcontrato_padrao
