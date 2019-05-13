begin
  pck_unicoogps.P_MIGRA_OCORR_TERMO_BENEF;
end;
/*
select count(*) from ITEMPLAN;--1984 -> 7030
select count(*) from DESPLAUS;--248978 -> 353550
select count(*) from gp.anexo_propost;--88038 -> 90728
select count(*) from ANEXO_BNFCIAR;--12 -> 101898
*/

--  select a.nom_anexo, a.cod_livre_2, a.* from anexo_bnfciar ab, anexo a where a.cdd_anexo = ab.cdd_anexo and a.cod_livre_2 is not null

/*
select ab.cdn_modalid, ab.num_propost, ab.cdn_usuar, ab.num_livre_1 -->101887
              from gp.anexo_bnfciar ab, gp.anexo a, gp.desplaus d
             where a.cdd_anexo = ab.cdd_anexo
               and d.cd_modalidade = ab.cdn_modalid
               and d.nr_ter_adesao = ab.num_propost
               and d.cd_usuario = ab.cdn_usuar
               and d.cdd_seq = ab.num_livre_1;

select ap.cdn_modalid, ap.num_propost, ap.num_livre_1 -->2690
              from gp.anexo_propost ap, gp.anexo a, gp.itemplan i
             where a.cdd_anexo = ap.cdd_anexo
               and i.cd_modalidade = ap.cdn_modalid
               and i.nr_ter_adesao = ap.num_propost
               and i.cdd_seq = ap.num_livre_1;

select * from gp.anexo a where a.cod_livre_2 is not null and a.cod_livre_2 <> ' '
               */