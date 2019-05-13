select a.cdagrupamento, a.cdservico, 'tem nos 2'
from agrupamento_servico_detalhe a, agrupamento_servico_detalhe b  
where a.cdagrupamento = &Agrup_A and b.cdagrupamento = &Agrup_B
  and a.cdservico = b.cdservico
union all
select a.cdagrupamento, a.cdservico, 'so tem no 1'
from agrupamento_servico_detalhe a  
where a.cdagrupamento = &Agrup_A 
  and not exists (select 1 from agrupamento_servico_detalhe b where b.cdagrupamento = &Agrup_B and b.cdservico = a.cdservico)
union all
select a.cdagrupamento, a.cdservico, 'so tem no 2'
from agrupamento_servico_detalhe a  
where a.cdagrupamento = &Agrup_B 
  and not exists (select 1 from agrupamento_servico_detalhe b where b.cdagrupamento = &Agrup_A and b.cdservico = a.cdservico)
order by 3,1,2
--select count(*) from agrupamento_servico_detalhe ax where ax.cdagrupamento=10002 7114 = 289 nos 2=35 669
