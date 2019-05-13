-- listar documentos rc sem movimentos
select count(*) from gp.docrecon d
where not exists(select 1 from gp.moviproc m
where m.cd_unidade = d.cd_unidade
and m.cd_unidade_prestadora = d.cd_unidade_prestadora
and m.cd_transacao = d.cd_transacao
and m.nr_serie_doc_original = d.nr_serie_doc_original
and m.nr_doc_original = d.nr_doc_original
and m.nr_doc_sistema = d.nr_doc_sistema)
and not exists(select 1 from gp.mov_insu i
where i.cd_unidade = d.cd_unidade
and i.cd_unidade_prestadora = d.cd_unidade_prestadora
and i.cd_transacao = d.cd_transacao
and i.nr_serie_doc_original = d.nr_serie_doc_original
and i.nr_doc_original = d.nr_doc_original
and i.nr_doc_sistema = d.nr_doc_sistema)
