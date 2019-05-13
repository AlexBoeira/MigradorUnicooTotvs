/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i LAMC007D-SIMUL 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i lamc007d MLA}
&ENDIF


/******************************************************************************
*      Programa ....: lamc007d-simul.p                                        *
*      Data ........: 10 de Maio de 1999                                      *
*      Sistema .....: LA - LAY-OUT PADRAO                                     *
*      Empresa .....: DZSET Solucoes e Sistemas                               *
*      Cliente .....: COOPERATIVAS MEDICAS                                    *
*      Programador .: Leonardo Deimomi                                        *
*      Objetivo ....: Monta o codigo da carteira do beneficiario, o codigo de *
*                     impressao da carteira e o codigo do cartao, conforme a  *
*                     estrutura. SIMULACAO                                    *
*-----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      D.00.000  10/05/1999  Leonardo       Desenvolvimento                   *
*      D.00.001  20/05/1999  Leonardo       Troca variavel usuario.cd-unidade *
*                                                      por cd-unimed-par  *
*      E.00.000  25/10/2000  Nora           Mudanca Versao Banco              *
*-----------------------------------------------------------------------------*
*  PARAMETRO              DESCRICAO                                           *
*                                                                             *
*  cd-tipo-tarefa-par     Codigo do tipo de tarefa a ser executada:           *
*                         1 - Monta o codigo da carteira, calculando o DV     *
*                         2 - Devolve codigo carteira p/ impressao (NORMAL)   *
*                         3 - Devolve codigo carteira p/ impressao (ORIGEM)   *
*                         4 - Devolve codigo cartao   p/ impressao (NORMAL)   *
*                         5 - Devolve codigo cartao   p/ impressao (ORIGEM)   *
*                         6 - Devolve codigo carteira p/ impressao (DESTINO)  *
*                         7 - Devolve codigo cartao   p/ impressao (DESTINO)  *
*  r-usuario-par          Numero do RECID da tabela de beneficiario           *
*  cd-cart-inteira-ant    Codigo da carteira inteira antiga do beneficiario   *
*  nr-via-carteira-par    Numero da via da carteira do beneficiario           *
*  lg-reutiliza-cart-par  Indica se o codigo da carteira sera reutilizado ou  *
*                         sera gerado um novo codigo para carteira            *
*  cd-cart-inteira-par    Codigo montado da carteira do beneficiario          *
*  dv-cart-inteira-par    Digito verificador da carteira montada              *
*  cd-cart-impress-par    Codigo montado para impressao:                      *
*                         Tarefa 1 => ""                                      *
*                         Tarefa 2 => Codigo da carteira do plano NORMAL      *
*                         Tarefa 3 => Codigo da carteira do plano UNIPLAN     *
*                         Tarefa 4 => Codigo do cartao                        *
*  lg-erro-par            Indica se houve algum problema no processo          *
******************************************************************************/
 
/* ----- DEFINICAO DOS PARAMETROS ------------------------------------------ */
def input        parameter cd-tipo-tarefa-par      as int                            no-undo.
def input        parameter cd-unimed-par           like usuario.cd-unimed            no-undo.   
def input        parameter cd-modalidade-par       like usuario.cd-modalidade        no-undo.
def input        parameter nr-ter-adesao-par       like usuario.nr-ter-adesao        no-undo.
def input        parameter nr-via-carteira-par     as int                            no-undo.
def input        parameter nr-proposta-par         like usuario.nr-proposta          no-undo.
def input-output parameter cd-usuario-par          like usuario.cd-usuario           no-undo.  
def output       parameter lg-erro-par             as log                            no-undo.
 
/* ----- DEFINICAO DE VARIAVEIS DA ROTINA RTDIGVER ------------------------- */
def            var nr-var-calcular-aux       as char format "x(20)"           no-undo.
def            var ds-mensrelat-aux          as char format "x(70)"           no-undo.
def            var lg-digito-ok-aux          as log                           no-undo.
def            var nr-digito-aux             as int  format "99"              no-undo.
def            var c-versao                  as char                          no-undo.
def            var cd-cart-inteira-aux       like car-ide.cd-carteira-inteira no-undo.
def            var dv-cart-inteira-aux       like car-ide.dv-carteira         no-undo.
 
c-versao = "7.01.001".
{hdp/hdlog.i}
 
/* ------------------------------------------------------------------------- */
 
assign lg-erro-par = no.

/* ----- VERIFICA O TIPO DE TAREFA A SER EXECUTADA ------------------------- */
case (cd-tipo-tarefa-par):
 
when 1
then do:
       repeat:
             /* ----- LOCALIZA A MODALIDADE ------------------------------- */
             find modalid
                  where modalid.cd-modalidade = cd-modalidade-par
                        no-lock no-error.
             if   not avail modalid
             then do:
                    assign lg-erro-par = yes.
                    return.
                  end.
             
             /* ----- MONTA O CODIGO DA CARTEIRA -------------------------- */
             if   modalid.nr-dig-adesao = 5
             then assign nr-var-calcular-aux = string (cd-unimed-par,     "9999")         +
                                               string (cd-modalidade-par, "99")           +
                                    substring (string (nr-ter-adesao-par, "999999"),2, 5) +
                                               string (cd-usuario-par,    "99999").
             
             else if   modalid.nr-dig-adesao = 6 
                  then assign nr-var-calcular-aux = string (cd-unimed-par,     "9999")   +
                                                    string (cd-modalidade-par, "99")     +
                                                    string (nr-ter-adesao-par, "999999") +
                                         substring (string (cd-usuario-par,    "99999"), 2, 4).
                  else assign nr-var-calcular-aux = string (cd-unimed-par,     "9999")   +
                                                    string (cd-modalidade-par, "99")     +
                                                    string (nr-ter-adesao-par, "9999")   +
                                                    string (cd-usuario-par,    "999999").
             
             assign nr-digito-aux = 0.
             
             run rtp/rtdigver.p (input        "CAR",
                                 input        no,
                                 input        nr-var-calcular-aux,
                                 input        no,
                                 output       ds-mensrelat-aux,
                                 output       lg-digito-ok-aux,
                                 input-output nr-digito-aux).
             
             if   lg-digito-ok-aux
             then assign cd-cart-inteira-aux = dec(substring (nr-var-calcular-aux, 5, 12) +
                                                   substring (string (nr-digito-aux, "99"), 2, 1))
                         dv-cart-inteira-aux = int(substring (string (nr-digito-aux, "99"), 2, 1)).
             else assign lg-erro-par = yes.

             if  not lg-erro-par
             and can-find(first car-ide
                          where car-ide.cd-carteira-antiga = cd-cart-inteira-aux)
             then do:
                    repeat:
                          assign cd-usuario-par = cd-usuario-par + 1.
                          
                          if not can-find(first usuario
                                          where usuario.cd-modalidade = cd-modalidade-par
                                            and usuario.nr-proposta   = nr-proposta-par
                                            and usuario.cd-usuario    = cd-usuario-par)
                          then leave.
                    end.
                  end.
             else leave.
       end.
       
     end.
end case.

/* ------------------------------------------------------------------------- */
/*------------------------------------------------------------------ EOF ---*/
