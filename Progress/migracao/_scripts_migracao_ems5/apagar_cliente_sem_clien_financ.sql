--apagar cliente que não tem clien_financ e trocar ti_cliente para RC
delete from cliente c where not exists(select 1 from clien_financ cf
                               where cf.cod_empresa = c.cod_empresa
                                 and cf.cdn_cliente = c.cdn_cliente);
update ti_cliente tc set tc.cdsituacao = 'RC'
where not exists(select 1 from ti_controle_integracao tci
                          where tci.nom_abrev = tc.nom_abrev);
