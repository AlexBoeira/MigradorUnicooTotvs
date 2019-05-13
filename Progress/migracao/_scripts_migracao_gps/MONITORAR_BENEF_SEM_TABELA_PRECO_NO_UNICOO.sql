SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>BENEFICIARIOS NO UNICOO SEM VINCULO COM TABELA DE PRECO</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\REGRA_MENSALIDADE\BENEF_SEM_TABELA_PRECO_NO_UNICOO.html

--ATENCAO: esse script lista beneficiarios que existem no unicoo sem vinculo com regra de mensalidade, logo, ficarão sem regra de mensalidade no TOTVS
Select count(*) ATIVOS
  From usuario us
 Where (us.nrtabela_contrato Is Null And us.nrtabela_padrao Is Null)
   And us.nrfamilia > 0
   And   (us.dtexclusao is Null Or us.dtexclusao > Sysdate)
 Order By us.dtexclusao Desc;
 
Select count(*) TOTAL
  From usuario us
 Where (us.nrtabela_contrato Is Null And us.nrtabela_padrao Is Null)
   And us.nrfamilia > 0
 Order By us.dtexclusao Desc;

Select nrSequencial_usuario NRSEQUENCIAL_ATIVOS,
       ps.nopessoa,
       nrregistro_usuario,
       nrcontrato,
       nrfamilia,
       tpusuario,
       dtinicio,
       dtexclusao,
       nrtabela_padrao
  From USUARIO Us, Pessoa Ps
 Where NRTABELA_PADRAO Is  Null
   And NRTABELA_CONTRATO Is Null
   And (DTEXCLUSAO Is Null Or DTEXCLUSAO > Sysdate)
   And Ps.Nrregistro = us.nrregistro_usuario
       order by 8 desc, 1;

Select nrSequencial_usuario NRSEQUENCIAL_TOTAL,
       ps.nopessoa,
       nrregistro_usuario,
       nrcontrato,
       nrfamilia,
       tpusuario,
       dtinicio,
       dtexclusao,
       nrtabela_padrao
  From USUARIO Us, Pessoa Ps
 Where NRTABELA_PADRAO Is Null
   And NRTABELA_CONTRATO Is Null
   And Ps.Nrregistro = us.nrregistro_usuario
       order by 8 desc, 1;

SPOOL OFF   
exit;
