set echo off
--recriar todas as tabelas de parametros desse ambiente com base em outro (parametrizado no momento da criacao da procedure)
begin
  p_espelhar_parametros('&1'); --TEXTO DE CONFIRMACAO EM QUE O USUARIO ASSUME OS RISCOS DE EXECUTAR ESSE METODO
  commit;
end;
/
