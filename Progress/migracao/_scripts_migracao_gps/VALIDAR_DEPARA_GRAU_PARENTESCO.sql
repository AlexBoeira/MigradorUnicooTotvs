select tu.* from tipo_de_usuario tu where not exists
              (select 1
                 from rem_tab_conversao r, rem_tab_conversao_exp re
                where r.nrseq = re.nrseq_tab_conversao
                  and r.notabela = 'MIGRACAO_GRAU_PARENTESCO'
                  and re.cdvalor_interno = tu.tpusuario)
