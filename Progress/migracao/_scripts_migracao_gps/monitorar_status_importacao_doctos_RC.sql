-- monitorar status importacao documentos RC
select d.ind_sit_import, count(*)
from gp.import_docto_revis_ctas d
group by d.ind_sit_import
order by d.ind_sit_import;
