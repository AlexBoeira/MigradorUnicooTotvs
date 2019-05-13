SET MARKUP HTML ON SPOOL ON PREFORMAT OFF ENTMAP ON -
HEAD "<TITLE>BENEFICIARIOS NO UNICOO COM TABELA PRECO INVALIDA</TITLE> -
<link rel='stylesheet' type='text/css' href='&2'> -
" -
TABLE "WIDTH='90%' BORDER='1'"
SPOOL &1\REGRA_MENSALIDADE\BENEF_COM_TAB_PRECO_INVALIDA_UNICOO(OUTRO_CONTRATO).html

--ATENCAO: esse script lista usu�rios com pre�o direto do Contrato Padr�o, sem relacionamento com regra do seu contrato, que s�o desconsiderados pelo migrador
Select count(*) ATIVOS
  From usuario us
 Where nrtabela_contrato Is Not Null
   And nrfamilia > 0
      And   (dtexclusao is Null Or dtexclusao > Sysdate)
   And Not Exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);
 
Select count(*) TOTAL
  From usuario us
 Where nrtabela_contrato Is Not Null
   And nrfamilia > 0
   And Not Exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);

--ATENCAO: esse script lista usu�rios cuja tabela de pre�o n�o corresponde com a tabela do seu pr�prio contrato, e por isso s�o desconsiderados pelo migrador
Select us.nrsequencial_usuario NRSEQUENCIAL_ATIVOS,
       nrtabela_contrato,
       nrregistro,
       nrcontrato,
       cdcontrato,
       us.*
  From usuario us
 Where nrtabela_contrato Is Not Null
   And nrfamilia > 0
      And   (dtexclusao is Null Or dtexclusao > Sysdate)
   And Not Exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);

Select us.nrsequencial_usuario NRSEQUENCIAL_TODOS,
       nrtabela_contrato,
       nrregistro,
       nrcontrato,
       cdcontrato,
       us.*
  From usuario us
 Where nrtabela_contrato Is Not Null
   And nrfamilia > 0
   And Not Exists (Select 1
          From preco_referencia_contrato prc
         Where prc.nrtabela_contrato = us.nrtabela_contrato
           And prc.nrregistro = us.nrregistro
           And prc.nrcontrato = us.nrcontrato);

SPOOL OFF   
exit;
