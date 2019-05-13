--CONCATENAR DDD ONDE O NUMERO DO TELEFONE TIVER ATE 8 CARACTERES
  declare
    nrfone_aux VARCHAR2(100);
    
    --1-Telefone Comercial
    --2-Telefone Residencial
    --3-Telefone Celular
    --4-Email
    --5-MSN
    --6-Google talk (IMS)
    --7-HomePage

    cursor cur_endereco is
      select distinct p.tppessoa,
                      to_char(decode(nrtelefone, '0', null, nrtelefone)) nrtelefone,
                      e.nrregistro,
                      to_char(decode(nrfax, '0', null, nrfax)) nrfax,
                      to_char(decode(cdemail, '0', null, cdemail)) cdemail,
                      --to_char(decode(nrcelular, '0', null, nrcelular)) nrcelular,
                      e.nocontato,
                      e.nocargocontato,
                      to_char(decode(e.nrddd, '0', null, e.nrddd)) nrddd,
                      to_char(decode(e.cdemail_adicional,
                                     '0',
                                     null,
                                     e.cdemail_adicional)) cdemail_adicional,
                      to_char(decode(e.txobservacoes,
                                     '0',
                                     null,
                                     '/  00000000',
                                     null,
                                     substr(e.txobservacoes, 1, 100))) txobservacoes,
                      cp.progress_recid,
                      trim(replace(replace(replace(e.nrtelefone,' ',''),'.',''),'-','')) fone_ajustado
        from endereco e, pessoa p, tipo_de_endereco t, gp.contato_pessoa cp
       where p.nrregistro = e.nrregistro
         and t.tpendereco = e.tpendereco
         and cp.id_pessoa = e.nrregistro
         and cp.tp_contato in (1,2) --TELEFONE COMERCIAL/RESIDENCIAL
         and cp.ds_contato = e.nrtelefone
         and (t.aopessoafisica = 'S' or t.aopessoajuridica = 'S')
         and (e.nrtelefone is not null and e.nrddd is not null)
         and length(trim(replace(replace(replace(e.nrtelefone,' ',''),'.',''),'-',''))) <= 8;
  begin

dbms_output.enable(null);

    for re in cur_endereco loop

      begin

        if (re.nrtelefone is not null) then
          --se nrtelefone tiver no maximo 8 digitos, concatenar o DDD. caso contrario, considera-se que ja esta com DDD
          if length(trim(replace(replace(replace(re.nrtelefone,' ',''),'.',''),'-',''))) <= 8
          and re.nrddd is not null
          then
            nrfone_aux := re.nrddd || ' ' || re.nrtelefone;
          else
            nrfone_aux := re.nrtelefone;
          end if;  
          
          dbms_output.put_line(re.nrregistro || ';' || re.fone_ajustado || ';' || re.nrddd || ';' || nrfone_aux);
          
          update gp.contato_pessoa cp set cp.ds_contato = nrfone_aux
                 where cp.progress_recid = re.progress_recid;
        
        end if;
      end;
    end loop;
  end;
  
/*
select cp.ds_contato , cp.id_pessoa
from gp.contato_pessoa cp where cp.tp_contato = 3 
and length(trim(cp.tp_contato)) <= 9
and cp.id_pessoa in (228281,440451,261965)         

order by cp.ds_contato

14   9 65543812   228281
15   982346624   440451
16   986442743  261965

*/  
