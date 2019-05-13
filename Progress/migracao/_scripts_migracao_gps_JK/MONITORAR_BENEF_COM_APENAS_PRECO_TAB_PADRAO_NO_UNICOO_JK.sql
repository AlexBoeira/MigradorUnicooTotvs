SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>BENEFICIARIOS NO UNICOO COM PRECO APENAS NA TABELA PADRAO</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\REGRA_MENSALIDADE\BENEF_COM_APENAS_PRECO_TAB_PADRAO_NO_UNICOO.html

--ATENCAO: esse script lista usu�rios com pre�o direto do Contrato Padr�o, sem relacionamento com regra do seu contrato, que s�o desconsiderados pelo migrador
Select count(*) ATIVOS
  From USUARIO Us, Pessoa Ps
 Where NRTABELA_PADRAO Is Not Null
   And NRTABELA_CONTRATO Is Null
   And (DTEXCLUSAO Is Null Or DTEXCLUSAO > Sysdate)
   And Ps.Nrregistro = us.nrregistro_usuario
   And us.nrfamilia > 0;
 
Select count(*) TOTAL
  From USUARIO Us, Pessoa Ps
 Where NRTABELA_PADRAO Is Not Null
   And NRTABELA_CONTRATO Is Null
   And Ps.Nrregistro = us.nrregistro_usuario
   And us.nrfamilia > 0;

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
 Where NRTABELA_PADRAO Is Not Null
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
 Where NRTABELA_PADRAO Is Not Null
   And NRTABELA_CONTRATO Is Null
   And Ps.Nrregistro = us.nrregistro_usuario
       order by 8 desc, 1;

SPOOL OFF   
exit;
