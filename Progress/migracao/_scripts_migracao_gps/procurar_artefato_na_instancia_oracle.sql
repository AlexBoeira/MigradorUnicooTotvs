-- VAI PROCURAR O ARTEFATO EM TODA A INSTANCIA CONECTADA
select *
from /*User_Source*/ all_source t
where upper(t.Text) like upper('%p_regras_mensalidade%') order by name, line


