-- erros P_JOB - ERROS OCORRIDOS DURANTE P_JOB, DURANTE MONTAGEM DAS TEMPORARIAS, ANTES DE PROCESSAS A CAMADA PROGRESS
select * from ti_falha_de_processo f, ti_controle_integracao co
where co.cdsituacao = 'ER'
and co.nrsequencial = f.nrseq_controle_integracao
