--CORRIGIR CODIGO DA UNIDADE DO PRESTADOR SOLICITANTE QUANDO EXTRATOR FORÇOU INDEVIDAMENTE 23
declare
  ix number := 0;
begin
  dbms_output.enable(null);
  for x in (select distinct p.cd_unidade, p.cd_prestador
              from preserv p,
                   (select distinct to_number(substr(e.des_erro, 74, 10)) cd_prestador_solic
                      from gp.erro_process_import e, gp.import_guia g
                     where e.num_seqcial_control = g.num_seqcial_control
                       and g.u##ind_sit_import = 'PE'
                       and e.des_erro like
                           '%Prestador Solicitante informado nao cadastrado. Unidade: 0023 Prestador:%') a
             where p.cd_prestador = a.cd_prestador_solic) loop
  
    update import_guia ig
       set ig.cd_unidade_solic  = x.cd_unidade,
           ig.u##ind_sit_import = 'RC',
           ig.ind_sit_import    = 'RC'
     where ig.cd_prestador_solic = x.cd_prestador
       and ig.u##ind_sit_import = 'PE';
  
    ix := ix + 1;
  
  end loop;
  dbms_output.put_line('Registros alterados: ' || ix);
end;
