/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i CG0111L 2.00.00.054} /*** 010054 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i cg0111l MCG}
&ENDIF

/******************************************************************************
*      Programa .....: cg0111l.p                                              *
*      Data .........: 03 de Novembro de 1997                                 *
*      Autor ........: DZSET SOLUCOES E SISTEMAS LTDA.                        *
*      Sistema ......: CG - CADASTROS GERAIS                                  *
*      Programador ..: Moacir Silveira Junior                                 *
*      Objetivo .....: Importar dados dos Prestadores - (Consistencia)        *
*******************************************************************************
*      VERSAO    DATA        RESPONSAVEL    MOTIVO                            *
*      C.00.000  03/11/1997  Moacir Jr.     Desenvolvimento                   *
*      C.01.000  02/01/1998  Moacir Jr.     Colocada consistencia para o tipo *
*                                           do codigo do magnus, deve ser <>  *
*                                           de "C".                           *
*      C.01.001  26/02/1998  Moacir Jr.     Corrigida importacao da data de   *
*                                           nascimento/fundacao e tambem a    *
*                                           data de exclusao                  *
*      C.02.000  03/03/1998  Moacir Jr.     Alterado tamanho dos campos       *
*                                           cd-esp-resid e nr-ult-inss        *
*      D.00.000  28/04/1998  Nora           Mudanca Versao Banco              *
*      D.01.000  08/07/1998  Gisa           Inclusao dos campos: nr-ult-irrf  *
*                                                            lg-calcula-adto  *
*                                                            dt-calculo-adto. *
*      D.01.001  07/04/1999  Leonardo       Substituicao da rotina RTDIGVER   *
*                                           pela rotina RTCGCCPF              *
*      D.02.000  16/07/1999  Leonardo       Troca de labels e mensagens de    *
*                                           "cooperado" p/ "credenciado"      *
*      D.03.000  14/09/1999  Janete         Incluidos os campos:              *
*                                           nr-dependentes                    *
*                                           lg-contr-max-inss                 *
*                                           lg-pagamento                      *
*                                           lg-tipo-endereco                  *
*                                           lg-recebe-corresp                 *
*                                           Revisao do layout                 *
*      D.04.000  21/02/2000  Daniela C.     Acrescimo do campo:               *
*                                           preserv.nm-email                  *
*                                           Consistir campos numericos que    *
*                                           contenham caracteres              *
*      D.05.000  18/09/2000  Andrea         Conversao Magnus - EMS            *
*      E.00.000  25/10/2000  Nora            Mudanca Versao Banco             *
*      E.00.001  24/11/2000  Jaque          Trocar funcao int para dec ao tes-*
*                                           tar nr-cgc-cpf-aux.               *
*      E.00.002  13/12/2000  Monia          Ler dzemit sem mascara no cgc     *
*      E.00.003  15/12/2000  Andrea         nr-cgc-dzemit-aux no include      *
*                                           Msg p. informar se o reg. vinculox*
*                                           especialidade jah existe          *
*                                           Aumentado o tamanho do campo codigo
*                                           do fornecedor de 6 para 9 e da    *
*                                           especialidade do titulo de 2 para *
*                                           3.                                *
*      E.01.000  07/05/2001  Felipe         - Conversao para o EMS 504        *
*      E.01.001  29/06/2001  Felipe         - Inclus∆o dos campos tipo fluxo, *
*                                             imposto e classif. para EMS 504 *
*      E.02.000  16/07/2001  Nora           Acrescimo de parametro rtapi044   *
*      E.02.001  25/10/2001  Nora           Ajustes para aceitar oracle       *
*      E.04.001  14/12/2001  Jaque          Ver descricao no libeprog.p       * 
*      E.04.002  24/12/2001  Jaque          Ver descricao no libeprog.p       *
******************************************************************************/

/* ------------------- CHAMADA DE INCLUDE DA ROTINA CONSISTENCIA ENDERECO --- */
{rtp/rtendere.i "new shared"}
 
/*----------------------- DEFINIR PARAMETRO DE ENTRADA ----------------------*/
def input parameter tp-registro-p as int                               no-undo.
 
{hdp/hdsistem.i}       /*** Verifica se e magnus ou EMS           ***/
{rtp/rtapi044.i}       /*** Procedure rtapi044 e variaveis        ***/
{cgp/cg0110l_mig.i " "}  /*variaveis auxiliares e temp-tables*/
{cgp/cg0110l_mig.f " "}  /*frames*/
 
/* ----------------------------- DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRPORTAD.I --- */
{srincl/srportad.iv}

/* ----------------------------- DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRCARTBC.I --- */
{srincl/srcartbc.iv}

/* ------------------------------ DEFINICAO DE VARIAVEIS UTILIZADAS PELA INCLUDE SRBANCO.I --- */
{srincl/srbanco.iv}

/*---------------------------- VARIAVEIS DE USO GERAL -----------------------*/
def shared var c-nr-seq-endereco  as int                               no-undo.
def shared var lg-aviso           as logical initial no                no-undo.
def shared var tp-registro        as int                               no-undo.
def shared var ep-codigo-aux      like paramecp.ep-codigo              no-undo.

def var lg-erro-cgc               as log                               no-undo.
def var ix                        as int                               no-undo.
def var ix2                       as int                               no-undo.
 
def var nr-cgc-cpf-aux           like preserv.nr-cgc-cpf               no-undo.
def var lg-formato-livre-aux       as log                              no-undo.
def var ix-cont-aux                as int                              no-undo.

def var c-versao                   as char                             no-undo.
def var hr-aux                     as char format "x(04)"              no-undo.
def var nr-digito-aux              as int                              no-undo.
def var lg-ok-aux                  as log                              no-undo.
def var ds-mens-aux                as char format "x(70)"              no-undo.

/* ----- DEFINICAO DE VARIAVEIS DA ROTINA RTCGCCPF ------------------------- */
def            var nr-cgc-cpf          as char format "x(14)"          no-undo.
def            var ds-mensrela-aux     as char format "x(132)"         no-undo.
def            var lg-erro-cgc-cpf-aux as log                          no-undo.
 
c-versao = c_prg_vrs.

{hdp/hdlog.i}

/* ----------------------------------- LOCALIZA OS PARAMETROS DO SISTEMA --- */
find first paramecp no-lock no-error.
find first paramepp no-lock no-error.

/* --- VERIFICA SE O FORMATO DO CGC/CPF POSSUI EDICAO LIVRE --- */
assign lg-formato-livre-aux = yes.

if   c-in-tipo-pessoa = "F"
then do:
       do ix-cont-aux = 1 to length(trim(paramecp.ds-formato-cpf)):

          if   substring(paramecp.ds-formato-cpf,ix-cont-aux,1) <> "X"
          then do:
                 assign lg-formato-livre-aux = no.
                 leave.
               end.
       end.
     end.

else do:
       do ix-cont-aux = 1 to length(trim(paramecp.ds-formato-cgc)):

          if   substring(paramecp.ds-formato-cgc,ix-cont-aux,1) <> "X"
          then do:
                 assign lg-formato-livre-aux = no.
                 leave.
               end.
       end.
     end.

/*---------------------- INICIA PROCESSO DE CONSISTENCIA --------------------*/
 
/*----- VERIFICA TIPO DO REGISTRO DA PRESERV A IMPORTAR -----*/
case tp-registro-p:
   when 1
   then run imp-reg-preserv.
 
   when 2
   then run imp-reg-previesp.
 
   when 3
   then run imp-reg-endpres.

   when 4
   then run imp-reg-prest-inst.

   when 5
   then run imp-reg-prestdor-obs.

   when 6
   then run imp-reg-prest-subst.
end case.

/*---------------------------------------------------------------------------*/
/* IMPORTAR TABELA PRESERV ( DEVE EXISTIR UM UNICO REGISTRO )                */
/*---------------------------------------------------------------------------*/
 
procedure imp-reg-preserv:
   /* ------------------------------------ CONSISTE CAMPO CODIGO UNIDADE --- */
   assign c-cd-unidade = int(substring(c-dados,002,04)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Codigo Unidade ("
                                       + substring(c-dados,002,04)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-unidade = 0
          or   c-cd-unidade = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Codigo Unidade nao Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-unidade < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Unidade ("
                                                     + string(c-cd-unidade)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find unimed where
                             unimed.cd-unimed = c-cd-unidade
                             no-lock no-error.
 
                        if   not avail unimed
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Unidade ("
                                                            + string(c-cd-unidade,"9999")
                                                            + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.

   /* ------------------------------------ CONSISTE CAMPO NOME PRESTADOR --- */
   assign c-nm-prestador = trim(substring(c-dados,1178,70)).

   if   trim(c-nm-prestador) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nome do Prestador nao Informado".
          assign lg-erro = yes.
        end.

   assign c-nm-fantasia = trim(substring(c-dados,1138,40)).
   /* ---------------------------------- CONSISTE CAMPO CODIGO PRESTADOR --- */
   assign c-cd-prestador = int(substring(c-dados,006,08)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Codigo Prestador ("
                                       + substring(c-dados,006,08)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-prestador <> 0
          and  c-cd-prestador <> ?
          then do:
                 if   c-cd-prestador < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Prestador ("
                                                     + string(c-cd-prestador)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
               end.
        end.
        
   /* ---------------------------------- CRIAR CODIGO PARA O PRESTADOR ----- */
   if   c-cd-prestador = 0 
   then do:

          find last preserv
              where preserv.cd-unidade = c-cd-unidade
                    no-lock no-error.
          
          if   avail preserv
          then do:
          
                 if   preserv.cd-prestador >= 99999999 
                 then do:
                        assign c-nome-abrev     = substring(c-dados,54,12)  
                               c-in-tipo-pessoa = substring(c-dados,66,1)
                               c-cgc-cpf        = substring(c-dados,272,19).
          
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo prestador nao pode ser maior "
                                                     + "que 99999999 "
                                                     + "na unidade "  
                                                     + string(c-cd-unidade).
          
                        assign lg-erro = yes.
                      end.
          
                 assign c-cd-prestador = preserv.cd-prestador + 1.
               end.
          else assign c-cd-prestador = 1.      

        end.

   /* ------------------------------------ CONSISTE CAMPO NOME ABREVIADO --- */
   assign c-nome-abrev = trim(substring(c-dados,054,12)).
 
   if   trim(c-nome-abrev) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nome Abreviado do Prestador nao "
                                       + "Informado".
          assign lg-erro = yes.
        end.
 
   /* --------------------------------------- CONSISTE CAMPO TIPO PESSOA --- */
   assign c-in-tipo-pessoa = trim(substring(c-dados,066,01)).
 
   if   trim(c-in-tipo-pessoa) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Tipo de Pessoa nao Informado".
          assign lg-erro = yes.
        end.
   else do:
          if   c-in-tipo-pessoa <> "F"
          and  c-in-tipo-pessoa <> "J"
          and  c-in-tipo-pessoa <> "E"
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Tipo de "
                                              + "Pessoa ("
                                              + c-in-tipo-pessoa
                                              + ") NAO CONFERE com os "
                                              + "Conteudos Definidos no "
                                              + "Layout de Importacao (F/J/E)".
                 assign lg-erro = yes.
               end.
        end.
 
   /* ----------------------------------- CONSISTE CAMPO GRUPO PRESTADOR --- */
   assign c-cd-grupo-prestador = int(substring(c-dados,067,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Grupo Prestador ("
                                       + substring(c-dados,067,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-grupo-prestador = 0
          or   c-cd-grupo-prestador = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Grupo Prestador nao "
                                              + "Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-grupo-prestador < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Grupo Prestador ("
                                                     + string(c-cd-grupo-prestador)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find gruppres where
                             gruppres.cd-grupo-prestador = c-cd-grupo-prestador
                             no-lock no-error.
 
                        if   not avail gruppres
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Grupo Prestador ("
                                                     + string(c-cd-grupo-prestador,"99")
                                                     + ") nao Cadastrado".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.

   /* -------------------------------------------- CONSISTE CAMPO MEDICO --- */
   case trim(substring(c-dados,069,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-medico = yes.
 
      when "N"
      then assign c-lg-medico = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Medico ("
                                          + substring(c-dados,069,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* --------------------------------------- CONSISTE CAMPO CREDENCIADO --- */
   case trim(substring(c-dados,070,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Credenciado (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-cooperado = yes.
 
      when "N"
      then assign c-lg-cooperado = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Credenciado ("
                                          + substring(c-dados,070,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
   
   /* ----------------- Consiste Cooperativa Medica ------------------------  */ 
   case trim(substring(c-dados,1023,1)):
      
      when "S"
      then do: 
             if c-lg-cooperado = yes
             or c-in-tipo-pessoa <> "J"
             then do:
                    create wk-erros.                                                   
                    assign wk-erros.cd-tipo-erro = "E"                                 
                           wk-erros.cd-tipo-regs = 1                                   
                           wk-erros.ds-desc      = "Conteudo do Campo Cooperativa Medica (S) " 
                                                 + "Invalido para prestadores credenciados "
                                                 + "ou tipo de pessoa diferente de juridica".                        
                    assign lg-erro = yes.                                              
                  end.
             else if "{&sistema}" = "ems" 
                  or "{&sistema}" = "magnus"
                  then do:
                         create wk-erros.                                                   
                         assign wk-erros.cd-tipo-erro = "E"                                 
                                wk-erros.cd-tipo-regs = 1                                   
                                wk-erros.ds-desc      = "Conteudo do Campo Cooperativa Medica (S) " 
                                                      + "permitido apenas para sistema EMS5".
                         assign lg-erro = yes.                                              
                       end.
                  else assign c-lg-cooperativa = yes.
           end.

      when "N"
      then assign c-lg-cooperativa = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Cooperativa Medica ("
                                          + substring(c-dados,1023,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

   /* --------------------------------- CONSISTE CAMPO UNIDADE SECCIONAL --- */
   assign c-cd-unidade-seccional = int(substring(c-dados,071,04)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Unidade Seccional ("
                                       + substring(c-dados,071,04)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-unidade-seccional <> 0
          and  c-cd-unidade-seccional <> ?
          then do:
                 if   c-cd-unidade-seccional < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Unidade Seccional ("
                                                     + string(c-cd-unidade-seccional)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find unimed where
                             unimed.cd-unimed = c-cd-unidade-seccional
                             no-lock no-error.
 
                        if   not available unimed
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Unidade Seccional ("
                                                     + string(c-cd-unidade-seccional,"9999")
                                                     + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ------------------------------------------ CONSISTE CAMPO CONSELHO --- */
   assign c-cd-conselho = trim(substring(c-dados,075,05)).
 
   if   trim(c-cd-conselho) <> ""
   then do:
          find conpres where
               conpres.cd-conselho = c-cd-conselho
               no-lock no-error.
 
          if   not avail conpres
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conselho ("
                                              + trim(c-cd-conselho)
                                              + ") nao Cadastrado".
                 assign lg-erro = yes.
               end.
        end.
 
   /* --------------------------------------- CONSISTE CAMPO UF CONSELHO --- */
   assign c-cd-uf-conselho = trim(substring(c-dados,080,02)).
 
   if   trim(c-cd-uf-conselho) <> ""
   then do:
          find dzestado
               where dzestado.nm-pais = "Brasil"
                 and dzestado.en-uf   = c-cd-uf-conselho
                     no-lock no-error.
 
          if   not avail dzestado
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "UF Conselho ("
                                              + trim(c-cd-uf-conselho)
                                              + ") nao Cadastrada para "
                                              + "Pais: Brasil".
                 assign lg-erro = yes.
               end.
        end.
 
   
   /* ---------------------------------------- CONSISTE CAMPO FORNECEDOR --- */
   assign c-cd-magnus = int(substring(c-dados,090,09)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Fornecedor ("
                                       + substring(c-dados,090,09)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-magnus <> 0
          and  c-cd-magnus <> ?
          then do:
                 if   c-cd-magnus < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Fornecedor ("
                                                     + string(c-cd-magnus)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        assign
                        cd-contratante-rtapi044-aux   = c-cd-magnus
                        lg-prim-mens-rtapi044-aux     = no
                        in-funcao-rtapi044-aux        = "GDT"
                        in-tipo-emitente-rtapi044-aux = "PRESTA"
                        in-tipo-pessoa-rtapi044-aux   = c-in-tipo-pessoa.
 
                        run rtapi044.
 
                        find first tmp-rtapi044 no-lock no-error.
 
                        if   not avail tmp-rtapi044
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Prestador/Fornecedor ("
                                                     + string(c-cd-magnus,"999999999")
                                                     + ") nao Cadastrado no "
                                                     + "Magnus/EMS como Emitente "
                                                     + "- Fornecedor ou Ambos".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------------------------------- CONSISTE CAMPO RUA --- */
   assign c-en-rua    = trim(substring(c-dados,099,40)).
 
   /* -------------------------------------------- CONSISTE CAMPO BAIRRO --- */
   assign c-en-bairro = trim(substring(c-dados,139,15)).
 
   /* -------------------------------------------- CONSISTE CAMPO CIDADE --- */
   assign c-cd-cidade = int(substring(c-dados,154,06)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Cidade ("
                                       + substring(c-dados,154,06)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   
   /* ------------------------------------------------------ CONSISTE CAMPO CEP --- */
   assign c-en-cep = trim(string(int(substring(c-dados,160,08)),"99999999")) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "CEP ("
                                       + substring(c-dados,160,08)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------------------ CONSISTE CAMPO UF --- */
   assign c-en-uf = trim(substring(c-dados,168,02)).
 
   run consiste-endereco (input c-cd-cidade,
                          input c-en-uf,
                          input c-en-cep,
                          input c-en-rua,
                          input c-en-bairro,
                          input c-in-tipo-pessoa,
                          input "P",
                          input-output lg-erro, 
                          input 1).

   /* ---------------------------------------- CONSISTE CAMPO TELEFONE 1 --- */
   assign c-nr-telefone[1] = trim(substring(c-dados,982,20)).
 
   /* ---------------------------------------- CONSISTE CAMPO TELEFONE 2 --- */
   assign c-nr-telefone[2] = trim(substring(c-dados,1002,20)).
 
   /* ------------------------ CONSISTE CAMPO DATA INCLUSAO DO PRESTADOR --- */
   assign c-dt-inclusao = ?.

   if   trim(substring(c-dados,194,08)) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Data de Inclusao do Prestador nao Informada".
          assign lg-erro = yes.
        end.
   else do:
          if   length(trim(substring(c-dados,194,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Inclusao do Prestador Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,194,08)) = "00000000"
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data de Inclusao do "
                                                     + "Prestador nao Informada".
                        assign lg-erro = yes.
                      end.
                 else do:
                        assign c-dt-inclusao = date(int(substring(c-dados,196,02)),
                                                    int(substring(c-dados,194,02)),
                                                    int(substring(c-dados,198,04))) no-error.
 
                        if   error-status:error
                        then do:

                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data de Inclusao do Prestador ("
                                                            + substring(c-dados,194,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ------------------------ CONSISTE CAMPO DATA EXCLUSAO DO PRESTADOR --- */
   assign c-dt-exclusao = ?.

   if   trim(substring(c-dados,202,08)) = ""
   then assign c-dt-exclusao = ?.
   else do:
          if   length(trim(substring(c-dados,202,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Exclusao do Prestador Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,202,08)) = "00000000"
                 then assign c-dt-exclusao = ?.
                 else do:
                        assign c-dt-exclusao = date(int(substring(c-dados,204,02)),
                                                    int(substring(c-dados,202,02)),
                                                    int(substring(c-dados,206,04))) no-error.
 
                        if   error-status:error
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data de Exclusao do Prestador ("
                                                            + substring(c-dados,202,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                        else do:
                               if   c-dt-exclusao < c-dt-inclusao
                               then do:
                                      create wk-erros.
                                      assign wk-erros.cd-tipo-erro = "E"
                                             wk-erros.cd-tipo-regs = 1
                                             wk-erros.ds-desc      = "Data de Exclusao do "
                                                                   + "Prestador INFERIOR a "
                                                                   + "Data de Inclusao do "
                                                                   + "Prestador".
                                      assign lg-erro = yes.
                                    end.
                             end.
                      end.
               end.
        end.
 
   /* ---------------------------------------------- CONSISTE CAMPO SEXO --- */
   if   c-in-tipo-pessoa = "F"
   then case substring(c-dados,210,01):
           when ""
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Sexo (Fem/Mas) nao Informado".
                  assign lg-erro = yes.
                end.
 
           when "F"
           then assign c-lg-sexo = yes.
 
           when "M"
           then assign c-lg-sexo = no.
 
           otherwise
                do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Conteudo do Campo Sexo ("
                                               + substring(c-dados,210,01)
                                               + ") NAO CONFERE com os "
                                               + "Conteudos Definidos no "
                                               + "Layout de Importacao (F/M)".
                  assign lg-erro = yes.
                end.
        end case.
   else assign c-lg-sexo = no.
 
   /* ---------- CONSISTE CAMPO DATA NASCIMENTO OU FUNDACAO DO PRESTADOR --- */
   if   trim(substring(c-dados,208,08)) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Data de Nascimento ou Fundacao do "
                                       + "Prestador nao Informada".
          assign lg-erro = yes.
        end.
   else do:
          if   length(trim(substring(c-dados,211,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Nascimento ou "
                                              + "Fundacao do Prestador "
                                              + "Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,211,08)) = "00000000"
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data de Nascimento ou "
                                                     + "Fundacao do Prestador "
                                                     + "nao Informada".
                        assign lg-erro = yes.
                      end.
                 else do:
                        assign c-dt-nascimento = date(int(substring(c-dados,213,02)),
                                                      int(substring(c-dados,211,02)),
                                                      int(substring(c-dados,215,04))) no-error.
 
                        if   error-status:error
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data de Nascimento ou "
                                                            + "Fundacao do Prestador ("
                                                            + substring(c-dados,211,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                        else do:
                               if   c-dt-nascimento > today
                               then do:
                                      create wk-erros.
                                      assign wk-erros.cd-tipo-erro = "E"
                                             wk-erros.cd-tipo-regs = 1
                                             wk-erros.ds-desc      = "Data de Nascimento ou "
                                                                   + "Fundacao do Prestador "
                                                                   + "SUPERIOR a Data da "
                                                                   + "Importacao".
                                      assign lg-erro = yes.
                                    end.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------- CONSISTE CAMPO INSCRICAO PRESTADOR UNIDADE --- */
   assign c-cd-insc-unimed = int(substring(c-dados,219,04)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Inscricao Prestador Unidade ("
                                       + substring(c-dados,219,04)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-insc-unimed <> 0
          and  c-cd-insc-unimed <> ?
          then do:
                 if   c-cd-insc-unimed < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Inscricao Prestador "
                                                     + "Unidade ("
                                                     + string(c-cd-insc-unimed)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
               end.
        end.
 
   /* ------------------------------------- CONSISTE CAMPO SITUACAO SINDICAL --- */
   assign c-cd-situac-sindic = trim(substring(c-dados,223,02)).
 
   /* ------------------- CONSISTE CAMPO FATOR DE PRODUTIVIDADE DO PRESTADOR --- */
   assign c-qt-produtividade = dec(substring(c-dados,225,12)) / 100 no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Fator de Produtividade do Prestador ("
                                       + substring(c-dados,225,12)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------- CONSISTE CAMPO POSSUI ALVARA --- */
   case substring(c-dados,237,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Possui Alvara (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-alvara = yes.
 
      when "N"
      then assign c-lg-alvara = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Possui Alvara ("
                                          + substring(c-dados,234,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ----------------------- CONSISTE CAMPO NUMERO DO PIS/PASEP --- */
   assign c-nr-pis-pasep = dec(substring(c-dados,617,11)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Numero do PIS/PASEP "
                                       + string(substring(c-dados,617,11),"x(11)")
                                       + " nao Numerico"
                 lg-erro               = yes.
        end.
   else if   c-nr-pis-pasep = ?
        then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "Numero do PIS/PASEP = ?, Invalido"
                       lg-erro               = yes.
             end.
 

   /* ----------------------- CONSISTE CAMPO NUMERO DA INSCRICAO INSS --*/
   assign c-nr-inscricao-inss = trim(substring(c-dados,628,14)).

   if   c-nr-inscricao-inss <> ""
   then do:
           assign nr-digito-aux = int(substr(string(c-nr-inscricao-inss,"99999999999"),11,1)).
                    
           run rtp/rtdigver.p("INSS",
                              yes,
                              substr(string(c-nr-inscricao-inss, "99999999999"),1,11),
                              no,
                              output ds-mens-aux,
                              output lg-ok-aux,
                              input-output nr-digito-aux).

           if not lg-ok-aux
           then do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = ds-mens-aux + " para Nr.Inscricao INSS"
                          lg-erro               = yes.
                end.
        end.
    
   /* ------------------------------ CONSISTE CAMPO POSSUI REGISTRO INSS --- */
   case substring(c-dados,238,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Possui Registro INSS (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-registro = yes.
 
      when "N"
      then assign c-lg-registro = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo  ("
                                          + substring(c-dados,235,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------------ CONSISTE CAMPO POSSUI DIPLOMA --- */
   case substring(c-dados,239,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Possui Diploma (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-diploma = yes.
 
      when "N"
      then assign c-lg-diploma = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Possui Diploma ("
                                          + substring(c-dados,239,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* -------------------------- CONSISTE CAMPO ESPECIALIDADE RESIDENCIA --- */
   assign c-cd-esp-resid = int(substring(c-dados,240,03)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Especialidade Residencia ("
                                       + substring(c-dados,240,03)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-esp-resid <> 0
          and  c-cd-esp-resid <> ?
          then do:
                 if   c-cd-esp-resid < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade Residencia ("
                                                     + string(c-cd-esp-resid)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find esp-med where
                             esp-med.cd-especialid = c-cd-esp-resid
                             no-lock no-error.
 
                        if   not avail esp-med
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade Residencia ("
                                                     + string(c-cd-esp-resid,"999")
                                                     + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ------------------------------ CONSISTE CAMPO ESPECIALIDADE TITULO --- */
   assign c-cd-esp-titulo = int(substring(c-dados,243,03)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Especialidade Titulo ("
                                       + substring(c-dados,243,03)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-esp-titulo <> 0
          and  c-cd-esp-titulo <> ?
          then do:
                 if   c-cd-esp-titulo < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade "
                                                     + "Titulo ("
                                                     + string(c-cd-esp-titulo)
                                                     + ") Invalida".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find esp-med where
                             esp-med.cd-especialid = c-cd-esp-titulo
                             no-lock no-error.
 
                        if   not avail esp-med
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Especialidade Titulo ("
                                                     + string(c-cd-esp-titulo,"999")
                                                     + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* -------------------------------------------- CONSISTE CAMPO MALOTE --- */
   case substring(c-dados,246,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Malote (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-malote = yes.
 
      when "N"
      then assign c-lg-malote = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Malote ("
                                          + substring(c-dados,246,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ---------------------------- CONSISTE NR. DIAS VALIDADE -------------- */
   assign c-nr-dias-validade = int(substring(c-dados,698,3)) no-error.

   if error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nr. Dias Validade ("
                                       + substring(c-dados,243,03)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.

   /* ------------------------------ CONSISTE CAMPO VINCULO EMPREGATICIO --- */
   case substring(c-dados,247,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Vinculo Empregaticio (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-vinc-empreg = yes.
 
      when "N"
      then assign c-lg-vinc-empreg = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Vinculo Empregaticio ("
                                          + substring(c-dados,247,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ----------------------------------- CONSISTE CAMPO ULTIMO MES INSS --- */
   assign c-nr-ult-inss = int(substring(c-dados,248,06)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Ultimo Mes INSS ("
                                       + substring(c-dados,248,06)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-nr-ult-inss <> 0
          and  c-nr-ult-inss <> ?
          then do:
                 if   c-nr-ult-inss < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Ultimo Mes INSS ("
                                                     + string(c-nr-ult-inss)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
               end.
        end.
 
   /* -------------------------- CONSISTE CAMPO 37 - DEVE CONTER BRANCOS --- */
   if   trim(substring(c-dados,254,08)) <> ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Campo 38 deve Conter Brancos".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------------- CONSISTE CAMPO RAMAL 1 --- */
   assign c-nr-ramal[1] = trim(substring(c-dados,262,05)).
 
   /* ------------------------------------------- CONSISTE CAMPO RAMAL 2 --- */
   assign c-nr-ramal[2] = trim(substring(c-dados,267,05)).
 
   /* --------------------------------------- CONSISTE CAMPO NRO CGC/CPF --- */
   assign c-cgc-cpf     = trim(substring(c-dados,272,19)).

   if   trim(c-cgc-cpf) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Nro CGC/CPF nao Informado".
          assign lg-erro = yes.
        end.

   else do:
          if   not lg-formato-livre-aux
          then do:
                 run desedita-numero-cgc-cpf (input  c-cgc-cpf,
                                              output nr-cgc-cpf-aux).

                 assign c-cgc-cpf = nr-cgc-cpf-aux.
               end.

          run rtp/rtcgccpf.p (input  c-in-tipo-pessoa,
                              input  c-cgc-cpf,
                              input  no,
                              output ds-mensrela-aux,
                              output lg-erro-cgc-cpf-aux).

          if   lg-erro-cgc-cpf-aux
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = ds-mensrela-aux.
                 assign lg-erro = yes.
               end.
 
          else do:
                 find first preserv
                      where preserv.nr-cgc-cpf    = c-cgc-cpf
                        and preserv.cd-unidade    = c-cd-unidade 
                        and preserv.cd-prestador <> c-cd-prestador
                 no-lock no-error.

                 if   avail preserv
                 then do:
                        if  not paramecp.lg-cgc-duplos-prestador
                        then do:
                               create wk-erros.
                               assign
                               wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Ja Existe Prestador com este CGC/CPF ("
                                                     + c-cgc-cpf
                                                     + ")".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
        /* ------------------------------------------ CONSISTE CAMPO REGISTRO --- */
        assign c-nr-registro = int(substring(c-dados,082,08)) no-error.

        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Registro ("
                                            + substring(c-dados,082,08)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.
        else do:
               if   c-nr-registro <> 0
               and  c-nr-registro <> ?
               then do:
                      if   c-nr-registro < 0
                      then do:
                             create wk-erros.
                             assign wk-erros.cd-tipo-erro = "E"
                                    wk-erros.cd-tipo-regs = 1
                                    wk-erros.ds-desc      = "Registro ("
                                                          + string(c-nr-registro)
                                                          + ") Invalido".
                             assign lg-erro = yes.
                           end.
                      else do:
                             /* Verifica se ja existe um outro prestador na mesma unidade
                                com o mesmo conselho e registro */
                             find first preserv     /* --- mesma logica do cg0111b.p --- */
                                  where preserv.cd-conselho    = c-cd-conselho            
                                    and preserv.nr-registro    = c-nr-registro           
                                    and preserv.cd-unidade     = c-cd-unidade            
                                    and preserv.in-tipo-pessoa = c-in-tipo-pessoa        
                                    and preserv.cd-uf-conselho = c-cd-uf-conselho        
                                    and preserv.cd-prestador  <> c-cd-prestador             
                                        no-lock no-error.                                
                                                                                          
                             if   avail preserv                                           
                             then do:                                                     
                                    create wk-erros.                                      
                                    assign                                                   
                                    wk-erros.cd-tipo-erro = "E"                               
                                    wk-erros.cd-tipo-regs = 1                                 
                                    wk-erros.ds-desc      = "Conselho/Registro (" + trim(c-cd-conselho) + "/"
                                                          + string(c-nr-registro,"99999999") + ") ja Cadastrado para "
                                                          + "outro Prestador na mesma Unidade: Prestador: " 
                                                          + string(preserv.cd-prestador,"99999999") + ")".
                                    assign lg-erro = yes.
                                  end.

                             /* Verifica se ja existe um outro prestador em outra unidade
                                com o mesmo conselho e registro */
                             find first preserv use-index preserv4                                                                      
                                  where preserv.cd-conselho    = c-cd-conselho                                                          
                                    and preserv.nr-registro    = c-nr-registro                                                          
                                    and preserv.cd-uf-conselho = c-cd-uf-conselho                                                       
                                    and preserv.nr-cgc-cpf    <> c-cgc-cpf                                                              
                                        no-lock no-error.                                                                               
                             if   avail preserv                                                                                         
                             then do:
                                    create wk-erros. 
                                    assign wk-erros.cd-tipo-erro = "A"                               
                                           wk-erros.cd-tipo-regs = 1                                 
                                           wk-erros.ds-desc      = "Conselho/Registro (" + trim(c-cd-conselho) + "/"
                                                                   + string(c-nr-registro,"99999999")     
                                                                   + ") ja cadastrado para outro Prestador: Prestador: "
                                                                   + string(preserv.cd-prestador,"99999999")
                                                                   + ", com cnpj/cpf diferente ("
                                                                   + " CGC/CPF: " + string(preserv.nr-cgc-cpf) + ")".                                  
                                    
                                    assign lg-aviso = yes.
                                  end.
                           end.
                    end.
             end.

   /* -------------------------------- CONSISTE CAMPO REPRESENTA UNIDADE --- */
   case substring(c-dados,291,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Represtanta Unidade (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-representa-unidade = yes.
 
      when "N"
      then assign c-lg-representa-unidade = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Representa Unidade ("
                                          + substring(c-dados,291,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------ CONSISTE CAMPO CODIGO HORARIO DE URGENCIA --- */
   assign c-cd-tab-urge = int(substring(c-dados,292,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Codigo Horario de Urgencia ("
                                       + substring(c-dados,292,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-tab-urge = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Codigo Horario de Urgencia nao Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-tab-urge < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Codigo Horario de Urgencia ("
                                                     + string(c-cd-tab-urge)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find first horaurge
                             where horaurge.cd-tab-urge = c-cd-tab-urge
                                   no-lock no-error.
 
                        if   not avail horaurge
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Codigo Horario de Urgencia ("
                                                            + string(c-cd-tab-urge,"99")
                                                            + ") nao Cadastrado".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* -------------------------------------- CONSISTE CAMPO RECOLHE INSS --- */
   case substring(c-dados,294,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Recolhe INSS (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-recolhe-inss = yes.
 
      when "N"
      then assign c-lg-recolhe-inss = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Recolhe INSS ("
                                          + substring(c-dados,294,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------ CONSISTE CAMPO RECOLHE PARTICIPACAO --- */
   case substring(c-dados,295,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Recolhe Participacao (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-recolhe-participa = yes.
 
      when "N"
      then assign c-lg-recolhe-participa = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Recolhe Participacao ("
                                          + substring(c-dados,295,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ---------------------------------------- CONSISTE CAMPO OBSERVACAO --- */
   assign c-ds-observacao = trim(substring(c-dados,296,228)).
 
   /* ------------------------- CONSISTE CAMPO CALCULAR IMPOSTO DE RENDA --- */
   case substring(c-dados,524,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular Imposto de Renda "
                                          + "(Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-calc-irrf = yes.
 
      when "N"
      then assign c-calc-irrf = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular Imposto de Renda ("
                                          + substring(c-dados,524,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------ CONSISTE CAMPO INDICE IRRF NUMERICO --- */
   assign c-incidir-irrf = int(substring(c-dados,525,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Indice IRRF ("
                                       + substring(c-dados,525,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-incidir-irrf <> 01
          and  c-incidir-irrf <> 02
          and  c-incidir-irrf <> 03
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Indice IRRF ("
                                              + string(c-incidir-irrf,"99")
                                              + ") NAO CONFERE com 01, 02 ou 03".
                 assign lg-erro = yes.
               end.
        end.
 
   /* -------------- CONSISTE CAMPO ORDEM 50 - CAMPO DEVE CONTER BRANCOS --- */
   if   trim(substring(c-dados,527,06)) <> ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Campo 52 deve Conter Brancos".
          assign lg-erro = yes.
        end.
 
   /* ---------------------------- CONSISTE CAMPO CALCULAR ADIANTAMENTO ---- */
   case substring(c-dados,533,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular Adiantamento (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-calcula-adto = yes.
 
      when "N"
      then assign c-lg-calcula-adto = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular Adiantamento ("
                                          + substring(c-dados,533,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------- CONSISTE CAMPO DATA CALCULO ADIANTAMENTO --- */
   if   trim(substring(c-dados,534,08)) = ""
   then assign c-dt-calculo-adto = ?.
   else do:
          if   length(trim(substring(c-dados,534,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data Calculo Adiantamento Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 if   trim(substring(c-dados,534,08)) = "00000000"
                 then assign
                      c-dt-calculo-adto = ?.
                 else do:
                        assign c-dt-calculo-adto = date(int(substring(c-dados,536,02)),
                                                        int(substring(c-dados,534,02)),
                                                        int(substring(c-dados,538,04))) no-error.
 
                        if   error-status:error
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 1
                                      wk-erros.ds-desc      = "Data Calculo Adiantamento ("
                                                            + substring(c-dados,534,08)
                                                            + ") Invalida ou nao Numerica".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------------- CONSISTE CAMPO NUMERO DE DEPENDENTES --- */
   assign c-nr-dependentes = int(substring(c-dados,542,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Numero de Dependentes ("
                                       + substring(c-dados,542,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-in-tipo-pessoa <> "F"
          then assign c-nr-dependentes = 0.
        end.

   /* -------------------------------------- CONSISTE CAMPO PAGAMENTO RH --- */
   case substring(c-dados,544,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Pagamento RH (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-pagamento-rh = yes.
 
      when "N"
      then assign c-lg-pagamento-rh = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Pagamento RH ("
                                          + substring(c-dados,544,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------- CONSISTE CAMPO ENDERECO ELETRONICO --- */
   assign c-nm-email = trim(substring(c-dados,545,50)).
 
   &if "{&sistema}" = "ems504"
   or  "{&sistema}" = "ems505"
   &then do:
   /* ------------------------------------------- CONSISTE TIPO DE FLUXO --- */
            assign c-cd-tipo-fluxo = trim(substring(c-dados,595,12)).
            
            find tip_fluxo_financ
                 where tip_fluxo_financ.cod_tip_fluxo_financ = c-cd-tipo-fluxo
                       no-lock no-error.

            if  not avail tip_fluxo_financ 
            and not paramepp.lg-abre-fluxo  /*** Utiliza apenas um fluxo financeiro ***/
            then do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = "Tipo de Fluxo ("
                                                + string(c-cd-tipo-fluxo,"999999999999")
                                                + ") nao Cadastrado".
                   assign lg-erro = yes.
                 end.
               
            /* --------------------------------- ESTOURO DE SEGMENTO ------------------------- */
            run consiste-tributos.                        

         end.
   &endif
   
   /* ---------------------------- CONSISTE CAMPO CALCULAR IMPOSTO UNICO ---------- */
     case substring(c-dados,747,1):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular IMPOSTO UNICO (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-calc-imposto-unico = yes.
 
      when "N"
      then assign c-calc-imposto-unico = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular IMPOSTO UNICO ("
                                          + substring(c-dados,643,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
   /* ---------------------------- CONSISTE CAMPO DIVISAO DE HONORARIOS ------ */
   case substring(c-dados,642,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Divide Honorario (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-lg-divisao-honorario = yes.

    when "N"
    then assign c-lg-divisao-honorario = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Divide Honorario ("
                                        + substring(c-dados,642,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE CAMPO DE COFINS ------ */
   case substring(c-dados,643,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Cofins (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-calc-cofins = yes.

    when "N"
    then assign c-calc-cofins = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Cofins ("
                                        + substring(c-dados,643,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE CAMPO DE PIS/PASEP ------ */
   case substring(c-dados,644,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Pis/Pasep (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-calc-pispasep = yes.

    when "N"
    then assign c-calc-pispasep = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular Pis/Pasep ("
                                        + substring(c-dados,644,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE CAMPO CALCULAR CSLL ------ */
   case substring(c-dados,645,1):
    when ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL (Sim/Nao) nao Informado".
           assign lg-erro = yes.
         end.

    when "S"
    then assign c-calc-csll = yes.

    when "N"
    then assign c-calc-csll = no.

    otherwise
         do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL ("
                                        + substring(c-dados,645,01)
                                        + ") NAO CONFERE com os Conteudos "
                                        + "Definidos no Layout de Importacao (S/N)".
           assign lg-erro = yes.
         end.
   end case.

   /* ---------------------------- CONSISTE OS DEMAIS ATRIBUTOS ------ */
   if not c-calc-imposto-unico 
   then do:  
          if  substring(c-dados,643,01) = "S"
          and substring(c-dados,644,01) = "S"
          and substring(c-dados,645,01) = "S" 
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular IMPOSTO UNICO ("
                                              + substring(c-dados,747,1)
                                              + ") DEVE estar definido como (S)"
                                              + " pois todos os atributos estao definidos com (S)".
                 assign lg-erro = yes.
               end.

          case substring(c-dados,643,01):
             when ""
             then do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Calcular COFINS (Sim/Nao) nao Informado".
                    assign lg-erro = yes.
                  end.
          
             when "S"
             then assign c-calc-cofins = yes.
          
             when "N"
             then assign c-calc-cofins = no.
          
             otherwise
                  do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Conteudo do Campo Calcular COFINS ("
                                          + substring(c-dados,643,01)
                                                 + ") NAO CONFERE com os Conteudos "
                                                 + "Definidos no Layout de Importacao (S/N)".
                    assign lg-erro = yes.
                  end.
          end case.
          /* ---------------------------- CONSISTE CAMPO CALCULAR PIS/PASEP ---------- */
          case substring(c-dados,644,01):
             when ""
             then do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Calcular PIS/PASEP (Sim/Nao) nao Informado".
                    assign lg-erro = yes.
                  end.
          
             when "S"
             then assign c-calc-pispasep = yes.
          
             when "N"
             then assign c-calc-pispasep = no.
          
             otherwise
                  do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Conteudo do Campo Calcular PIS/PASEP ("
                                          + substring(c-dados,644,01)
                                                 + ") NAO CONFERE com os Conteudos "
                                                 + "Definidos no Layout de Importacao (S/N)".
                    assign lg-erro = yes.
                  end.
          end case.
          /* ---------------------------- CONSISTE CAMPO CALCULAR CSLL ---------- */
          
          case substring(c-dados,645,01):
             when ""
             then do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Calcular CSLL (Sim/Nao) nao Informado".
                    assign lg-erro = yes.
                  end.
          
             when "S"
             then assign c-calc-csll = yes.
          
             when "N"
             then assign c-calc-csll = no.
          
             otherwise
                  do:
                    create wk-erros.
                    assign wk-erros.cd-tipo-erro = "E"
                           wk-erros.cd-tipo-regs = 1
                           wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL ("
                                                 + substring(c-dados,645,01)
                                                 + ") NAO CONFERE com os Conteudos "
                                                 + "Definidos no Layout de Importacao (S/N)".
                    assign lg-erro = yes.
                  end.
          end case.
          end.
   else do:
          if substring(c-dados,643,01) = "S"
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular COFINS ("
                                              + substring(c-dados,643,01)
                                              + ") DEVE estar definido com (N)".
                 assign lg-erro = yes.
               end.
          if substring(c-dados,644,01) = "S"
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular PIS/PASEP ("
                                              + substring(c-dados,644,01)
                                              + ") DEVE estar definido com (N)". 
                 assign lg-erro = yes.
               end.

          if substring(c-dados,645,01) = "S" 
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Calcular CSLL ("
                                              + substring(c-dados,645,01)
                                              + ") DEVE estar definido com (N)".
                 assign lg-erro = yes.
               end.
        end.   
   
   /* ---------------------------- CONSISTE CAMPO CALCULAR ISS ---------- */
   case substring(c-dados,686,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Calcular ISS (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-calc-iss = yes.
 
      when "N"
      then assign c-calc-iss = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Calcular ISS ("
                                          + substring(c-dados,686,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
   /*-------------- consiste campo deduz iss ------------------------*/
   case substring(c-dados,697,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Deduzir ISS (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-deduz-iss = yes.
 
      when "N"
      then assign c-deduz-iss = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 1
                    wk-erros.ds-desc      = "Conteudo do Campo Deduzir ISS ("
                                          + substring(c-dados,697,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

    /* --- CONSISTE TIPO DE CLASSIFICACAO DO ESTABELECIMENTO --- */
    if c-nr-ver-tra = 10
    or c-nr-ver-tra = 8
    or lg-layout-serious-aux
    then do:
           if  trim(substring(c-dados,758,1)) <> "1"
           and trim(substring(c-dados,758,1)) <> "2"
           and trim(substring(c-dados,758,1)) <> "3"
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Tipo de classificacao deve ser 1, 2 ou 3. Valor recebido: " + trim(substring(c-dados,758,1)).
                  assign c-cd-tipo-classif-estab = ""
                         lg-erro = yes.
                end.
           else assign c-cd-tipo-classif-estab  = substring(c-dados,758,1).
         end.

    assign c-cd-cnes = int(substring(c-dados,759,7)).

    /* --- RECEBE NOME DO DIRETOR TECNICO DA ENTIDADE DE SAUDE --- */
    assign c-nm-diretor-tecnico = substring(c-dados,766,40).

    /* ------------------------- CONSISTE REGISTRO ANS --- */
    assign c-cd-registro-ans = int(substring(c-dados,814,6)) no-error.

    if   error-status:error
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Registro ANS ("
                                        + substring(c-dados,814,6)
                                        + ") nao Numerico".
            assign lg-erro = yes.
         end.
    
   /* ---------- CONSISTE MODALIDADE --------------------------------------- */
   &if "{&sistema}" = "ems504"
   or  "{&sistema}" = "ems505"
   &then do:
           assign c-modalidade = integer(substring(c-dados,706,1)).
        
           /**
            * Consistencia retirada pois Fornecedor Financeiro do EMS5 nao trata mais a Carteira Bancaria (Modalidade).
            * Alex Boeira - 03/05/2016
           if   c-modalidade <> 0
           then do:
                  {srincl/srcartbc.i "c-modalidade"}
                  
                  if   not lg-avail-srcartbc-srems
                  then do:
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "Modalidade do portador ("
                                                        + string(c-modalidade)
                                                        + ") NAO e' valida".  
                         assign lg-erro = yes.
                       end.
                end.
           */

           /* ---------- CONSISTE O CAMPO PORTADOR --------------------------------- */
           assign c-portador = integer(substring(c-dados,701,5)).
           
           if   c-portador   <> 0
           or   c-modalidade <> 0 
           then do: 
                  {srincl/srportad.i "paramecp.ep-codigo"      
                                     "c-portador"
                                     "c-modalidade"
                                     "paramecp.cod-estabel"}
        
                  if   not lg-avail-portador-srems 
                  then do: 
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "O codigo do portador ("
                                                        + string(c-portador)
                                                        + ") NAO e' valido".  
                         assign lg-erro = yes. 
                       end.

                  /**
                   * Consistencia retirada pois Fornecedor Financeiro do EMS5 nao trata mais a Carteira Bancaria (Modalidade).
                   * Alex Boeira - 03/05/2016
                  if   not lg-avail-carteira-srems
                  then do: 
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "O codigo da modalidade ("
                                                        + string(c-modalidade)
                                                        + ") NAO e' valido".  
                         assign lg-erro = yes. 
                       end.
                  */     
                end.
        
           /* ---------- CONSISTE O CAMPO COD DO BANCO ----------------------------- */
           assign c-cd-banco = integer(substring(c-dados,707,3)).

           if   c-cd-banco <> 0
           then do:
                  /* ----------------------------------------------------- LOCALIZA O BANCO --- */
                  {srincl/srbanco.i "c-cd-banco"}                              
                                                                               
                  if   not lg-avail-srbanco-srems                              
                  then do:                                                     
                         create wk-erros.                                      
                         assign wk-erros.cd-tipo-erro = "E"                    
                                wk-erros.cd-tipo-regs = 1                      
                                wk-erros.ds-desc      = "O codigo do banco ("  
                                                      + string(c-cd-banco)     
                                                      + ") NAO e' valido".     
                                                                               
                         assign lg-erro = yes.                                 
                       end.                                                    
                end.

           /* ---------------------------------------------------------- AGENCIA --- */
           assign c-agencia      = substring(c-dados,710,8).
           /* --------------------------------------------------- CONTA CORRENTE --- */
           assign c-conta-corren = substring(c-dados,718,20).

           /* Consiste tipo de carteira banc†ria se ? DÇbito Auto, obrigatoriamente os campos banco, agencia e 
              conta corrente sao obrigatorios na digitacao */
           
           if   lg-avail-srcartbc-srems
           then do:
                  if   cart_bcia.ind_tip_cart_bcia = "DÈbito Auto"
                  then do:
                         if c-cd-banco     = 0 
                         or c-agencia      = ""
                         or c-agencia      = fill("0",length(trim(banco.cod_format_agenc_bcia)))
                         or c-conta-corren = ""
                         or c-conta-corren = fill("0",length(trim(banco.cod_format_cta_corren)))
                         then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Banco/Agencia/Cta Corrente para este" 
                                                             + " portador/modalidade sao obrigatorios".
                  
                                assign lg-erro = yes.
                              end.
                       end.   
                end.
           /* --------------------------------------------------- DIGITO AGENCIA --- */
           assign c-agencia-digito = trim(substring(c-dados,738,2)).
           /* -------------------------------------------- DIGITO CONTA CORRENTE --- */
           assign c-conta-corren-digito = trim(substring(c-dados,740,2)).
           /* ------------------------------ CONSISTE O CAMPO FORMA DE PAGAMENTO --- */
           assign c-forma-pagto = trim(substring(c-dados,742,3)).
           /* ------------------------------- RETEM ATRIBUTO DO PROCEDIMENTO ------- */
           assign c-retem-proc = trim(substring(c-dados,745,1)).
           /* ------------------------------- RETEM ATRIBUTO DO INSUMO ------------- */
           assign c-retem-insu = trim(substring(c-dados,746,1)).

           if   c-forma-pagto <> ""
           or   c-forma-pagto <> "0"
           then do:
                  find forma_pagto where forma_pagto.cod_forma_pagto = c-forma-pagto no-lock no-error.
                  if   not avail forma_pagto
                  then do:
                         create wk-erros.
                         assign wk-erros.cd-tipo-erro = "E"
                                wk-erros.cd-tipo-regs = 1
                                wk-erros.ds-desc      = "O codigo do tipo de pagto ("
                                                        + c-forma-pagto
                                                        + ") NAO e' valido".   
                         assign lg-erro = yes.
                       end.
                end.
         end.
   &endif.
   
   if   substring(c-dados,820,8) <> "00000000"
   and  substring(c-dados,820,8) <> "        "
   then c-dt-inicio-contratual   = date(substring(c-dados,820,8)).
   else c-dt-inicio-contratual   = ?.
   
   /* Consiste dados ANS */
   assign c-ds-natureza-doc-ident   = trim(substring(c-dados,828,40))
          c-nr-doc-ident            = trim(substring(c-dados,868,14))
          c-ds-orgao-emissor-ident  = trim(substring(c-dados,882,30))
          c-nm-pais-emissor-ident   = trim(substring(c-dados,912,20))
          c-uf-emissor-ident        = trim(substring(c-dados,932,2))
          c-dt-emissao-doc-ident    = ?
          c-ds-nacionalidade        = trim(substring(c-dados,942,40)).

   if   trim(substring(c-dados,934,08)) <> ""
   and  trim(substring(c-dados,934,08)) <> "00000000"
   then do:
          if   length(trim(substring(c-dados,934,08))) <> 08
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Data de Emissao do Documento de Identificacao Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 assign c-dt-emissao-doc-ident = date(int(substring(c-dados,936,02)),
                                                      int(substring(c-dados,934,02)),
                                                      int(substring(c-dados,938,04))) no-error.
                 if   error-status:error
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = "Data de Emissao do Documento de Identificacao ("
                                                     + substring(c-dados,934,08)
                                                     + ") Invalida ou nao Numerica".
                        assign lg-erro = yes.
                      end.
               end.
        end.

   /* -------------- Tipo Disponibilidade ---------------------------------- */
   if   int(substr(c-dados,1022,1))   <> 0
   and  int(substr(c-dados,1022,1))   <> 1
   and  int(substr(c-dados,1022,1))   <> 2
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Tipo Disponibilidade invalido"
                                       + "(" + substring(c-dados,1022,1) + ")".
          assign lg-erro = yes.
        end.

   else assign c-tp-disponibilidade = int(substr(c-dados,1022,1)).

  /* -------------- Rede Acidente Trabalho ---------------------------------- */
  if substr(c-dados,1024,1) = "S"
  then assign c-lg-acid-trab = yes. 
  else assign c-lg-acid-trab = no.

  /* -------------- Pratica Tabela Propria ---------------------------------- */
  if substr(c-dados,1025,1) = "S"
  then assign c-lg-tab-propria = yes. 
  else assign c-lg-tab-propria = no.

  /* -------------- Perfil Assistencial ------------------------------------- */
  if int(substr(c-dados,1026,2)) < 0
  or int(substr(c-dados,1026,2)) > 28
  then do:
         create wk-erros.
         assign wk-erros.cd-tipo-erro = "E"
                wk-erros.cd-tipo-regs = 1
                wk-erros.ds-desc      = "Perfil Assist. do Hospital invalido"
                                      + "(" + substring(c-dados,1026,2) + ")".
         assign lg-erro = yes.
       end.
  else assign c-in-perfil-assistencial = int(substr(c-dados,1026,2)).

  /* -------------- Tipo Produto -------------------------------------------- */
  if int(substr(c-dados,1028,1)) < 0
  or int(substr(c-dados,1028,1)) > 3
  then do:
         create wk-erros.
         assign wk-erros.cd-tipo-erro = "E"
                wk-erros.cd-tipo-regs = 1
                wk-erros.ds-desc      = "Tipo Produto invalido"
                                      + "(" + substring(c-dados,1028,1) + ")".
         assign lg-erro = yes.
       end.
  else assign c-in-tipo-prod-atende = int(substr(c-dados,1028,1)).

  /*-------------- Consiste Indicador de publicaá∆o no Guia Medico ------------------------*/
  if c-nr-ver-tra          >= 12
  or lg-layout-serious-aux
  then do:
         case substring(c-dados,1029,01):
            when ""
            then do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = "Guia Medico (Sim/Nao) nao Informado".
                   assign lg-erro = yes.
                 end.
         
            when "S"
            then assign c-lg-guia-medico-aux = yes.
         
            when "N"
            then assign c-lg-guia-medico-aux = no.
         
            otherwise
                 do:
                   create wk-erros.
                   assign wk-erros.cd-tipo-erro = "E"
                          wk-erros.cd-tipo-regs = 1
                          wk-erros.ds-desc      = "Conteudo do Campo Guia Medico ("
                                                + substring(c-dados,1029,01)
                                                + ") NAO CONFERE com os Conteudos "
                                                + "Definidos no Layout de Importacao (S/N)".
                   assign lg-erro = yes.
                 end.
         end case.
       end.
  else assign c-lg-guia-medico-aux = no.

  if c-nr-ver-tra >= 14
  or lg-layout-serious-aux
  then do:
         if substring(c-dados,1030,12) <> ""
         then do:   
         find conpres where conpres.cd-conselho = substring(c-dados,1030,12)   
                            no-lock no-error.
         if not avail conpres
         then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "Conselho de Prestadores nao Cadastrado "
                                             + "(" + substring(c-dados,1030,12) + ")".
                assign lg-erro = yes.
              end.
              end.

         if substring(c-dados,1057,2) <> ""
         then do:        
         find dzestado where dzestado.nm-pais = "BRASIL"  
                         and dzestado.en-uf   = substring(c-dados,1057,2) 
                             no-lock no-error.
                 
        if not avail dzestado 
        then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "UF invalido"
                                             + "(" + substring(c-dados,1057,2) + ")".
                assign lg-erro = yes.
              end.
              end.

              assign c-cd-conselho-dir-tec = substring(c-dados,1030,12)
                     c-nr-conselho-dir-tec = substring(c-dados,1042,15)
                     c-uf-conselho-dir-tec = substr(c-dados,1057,2).

         if int(substr(c-dados,1059,1)) < 0
         or int(substr(c-dados,1059,1)) > 3
         then do:
                create wk-erros.
                assign wk-erros.cd-tipo-erro = "E"
                       wk-erros.cd-tipo-regs = 1
                       wk-erros.ds-desc      = "Tipo de Rede invalido"
                                             + "(" + substring(c-dados,1059,1) + ")".
                assign lg-erro = yes.
              end.
         else assign c-tp-rede = int(substr(c-dados,1059,1)).

        /* ---------------------------------------------------- Sistema NOTIVISA --- */
        if substr(c-dados,1060,1) = "S"
        then c-lg-notivisa = yes.
        else c-lg-notivisa = no.

        /* ----------------------------------------------------- Sistema QUALISS --- */
        if substr(c-dados,1061,1) = "S"
        then c-lg-qualiss = yes.
        else c-lg-qualiss = no.
        
        /* --------------------------------------------- Registro Especialista 1 --- */
        assign c-nr-registro1 = int(substring(c-dados,1062,10)) no-error.
        
        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Numero Registro Especialista 1 ("
                                            + substring(c-dados,1062,10)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.
        
        /* --------------------------------------------- Registro Especialista 2 --- */
        assign c-nr-registro2 = int(substring(c-dados,1072,10)) no-error.
        
        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Numero Registro Especialista 2 ("
                                            + substring(c-dados,1072,10)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.

        /* --------------------------------------------- Nr. Leitos Hospital-dia --- */
        assign c-nr-leitos-hosp-dia = int(substring(c-dados,1082,6)) no-error.
        
        if   error-status:error
        then do:
               create wk-erros.
               assign wk-erros.cd-tipo-erro = "E"
                      wk-erros.cd-tipo-regs = 1
                      wk-erros.ds-desc      = "Numero de Leitos Hospital-dia ("
                                            + substring(c-dados,1082,6)
                                            + ") nao Numerico".
               assign lg-erro = yes.
             end.
        
        /* --------------------------------------------- Registro Especialista 2 --- */
        assign c-nm-end-web = substring(c-dados,1088,50).
        
       end.

       /* --------------------------- CONSISTE CAMPO DIVULGA ANS --- */
       case trim(substring(c-dados,1248,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-publica-ans-aux = yes.
       
          when "N"
          then assign lg-publica-ans-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Divulga ANS ("
                                              + substring(c-dados,1248,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

       /* --------------------------- CONSISTE CAMPO RESIDENCIA MEC --- */
       case trim(substring(c-dados,1249,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-indic-residencia-aux = yes.
       
          when "N"
          then assign lg-indic-residencia-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Residencia MEC ("
                                              + substring(c-dados,1249,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

       /* --------------------------- CONSISTE CAMPO ENVIA CADU ------------- */
       case trim(substring(c-dados,1250,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-login-wsd-tiss-aux = yes.
       
          when "N"
          then assign lg-login-wsd-tiss-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Manutencao TISS ("
                                              + substring(c-dados,1250,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

              /* --------------------------- CONSISTE CAMPO ENVIA CADU ------------- */
       case trim(substring(c-dados,1251,01)):
          when ""
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                 assign lg-erro = yes.
               end.
       
          when "S"
          then assign lg-cadu-aux = yes.
       
          when "N"
          then assign lg-cadu-aux = no.
       
          otherwise
               do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 1
                        wk-erros.ds-desc      = "Conteudo do Campo Envia CADU ("
                                              + substring(c-dados,1251,01)
                                              + ") NAO CONFERE com os Conteudos "
                                              + "Definidos no Layout de "
                                              + "Importacao (S/N)".
                 assign lg-erro = yes.
               end.
       end case.

end procedure.
 
/*---------------------------------------------------------------------------*/
/* IMPORTAR TABELA PREVIESP ( PELO MENOS 1 REGISTRO )                        */
/*---------------------------------------------------------------------------*/
 
procedure imp-reg-previesp:
   /* --------------------------------- CONSISTE CAMPO CODIGO DO VINCULO --- */
   assign c-cd-vinculo = int(substring(c-dados,002,02)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc      = "Codigo do Vinculo ("
                                       + substring(c-dados,002,02)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-vinculo = 0
          or   c-cd-vinculo = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 2
                        wk-erros.ds-desc      = "Codigo do Vinculo nao "
                                              + "Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-vinculo < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Codigo do Vinculo ("
                                                     + string(c-cd-vinculo)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find tipovinc where
                             tipovinc.cd-tipo-vinculo = c-cd-vinculo
                             no-lock no-error.
 
                        if   not avail tipovinc
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 2
                                      wk-erros.ds-desc      = "Vinculo ("
                                                            + string(c-cd-vinculo,"99")
                                                            + ") nao Cadastrado".
                               assign lg-erro = yes.
                             end.
                        else do:
                               if   tipovinc.lg-cd-magnus
                               then do:
                                   assign nome-abrev-rtapi044-aux       = c-nome-abrev
                                          lg-prim-mens-rtapi044-aux     = no
                                          in-funcao-rtapi044-aux        = "GDT"
                                          in-tipo-emitente-rtapi044-aux = "PRESTA"
                                          in-tipo-pessoa-rtapi044-aux   = c-in-tipo-pessoa.
                                    
                                   run rtapi044.
 
                                   find first tmp-rtapi044 no-lock no-error.

                                   if  not available tmp-rtapi044
                                      then do:
                                             create wk-erros.
                                             assign wk-erros.cd-tipo-erro = "E"
                                                    wk-erros.cd-tipo-regs = 2
                                                    wk-erros.ds-desc      = "Prestador deve estar "
                                                                          + "Cadastrado no Magnus/EMS "
                                                                          + "para ser Associado a "
                                                                          + "este Vinculo ("
                                                                          + string(c-cd-vinculo,"99")
                                                                          + ")".
                                             assign lg-erro = yes.
                                           end.
                                      else assign c-cd-magnus          = tmp-rtapi044.cd-contratante 
                                                  c-nm-prestador       = tmp-rtapi044.nm-contratante
                                                  c-in-tipo-pessoa     = tmp-rtapi044.in-tipo-pessoa
                                                  c-nome-abrev         = tmp-rtapi044.nome-abrev
                                                  c-en-rua             = tmp-rtapi044.en-rua
                                                  c-en-bairro          = tmp-rtapi044.en-bairro
                                                  c-nr-telefone[1]     = tmp-rtapi044.nr-telefone[1]
                                                  c-en-uf              = tmp-rtapi044.en-uf
                                                  c-dt-inclusao        = tmp-rtapi044.dt-implantacao
                                                  c-cd-grupo-prestador = tmp-rtapi044.cod-gr-forn
                                                  c-en-cep             = tmp-rtapi044.en-cep
                                                  c-cd-cidade          = tmp-rtapi044.cd-cidade.
                                    end.
                             end.
                      end.
               end.
        end.
 
   /* --------------------------- CONSISTE CAMPO CODIGO DA ESPECIALIDADE --- */
   assign c-cd-especialid = int(substring(c-dados,004,03)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc      = "Codigo da Especialidade ("
                                       + substring(c-dados,004,03)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
   else do:
          if   c-cd-especialid = 0
          or   c-cd-especialid = ?
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 2
                        wk-erros.ds-desc      = "Codigo da Especialidade nao "
                                              + "Informado".
                 assign lg-erro = yes.
               end.
          else do:
                 if   c-cd-especialid < 0
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 2
                               wk-erros.ds-desc      = "Codigo da "
                                                     + "Especialidade ("
                                                     + string(c-cd-especialid)
                                                     + ") Invalido".
                        assign lg-erro = yes.
                      end.
                 else do:
                        find esp-med where
                             esp-med.cd-especialid = c-cd-especialid
                             no-lock no-error.
 
                        if   not avail esp-med
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 2
                                      wk-erros.ds-desc      = "Especialidade ("
                                                            + string(c-cd-especialid,"999")
                                                            + ") nao Cadastrada".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
 
   /* ----------------------------------------- CONSISTE CAMPO PRINCIPAL --- */
   case trim(substring(c-dados,007,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Principal (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-principal = yes.
 
      when "N"
      then assign c-lg-principal = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Conteudo do Campo Principal ("
                                          + substring(c-dados,007,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ----------------------------- CONSISTE CAMPO CONSIDERA QTD VINCULO --- */
   case trim(substring(c-dados,008,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Considera Qtd Vinculo (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign c-lg-considera-qt-vinculo = yes.
 
      when "N"
      then assign c-lg-considera-qt-vinculo = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 2
                    wk-erros.ds-desc      = "Conteudo do Campo Considera Qtd "
                                          + "Vinculo ("
                                          + substring(c-dados,008,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

   /* --- CONSISTE TIPO DE CONTRATUALIZACAO --- */
   if  substring(c-dados,19,1) <> ""
   and substring(c-dados,19,1) <> "0"
   and substring(c-dados,19,1) <> "1"
   and substring(c-dados,19,1) <> "2"
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 2
                 wk-erros.ds-desc      = "Tipo de contratualizacao(" + substring(c-dados,19,1) + ") invalido".
          assign lg-erro = yes.
        end.
 
   /*--------Verificar se registro jah existe ----*/
   find first wk-reg2 where wk-reg2.cd-vinculo    = c-cd-vinculo 
                        and wk-reg2.cd-especialid = c-cd-especialid  no-lock no-error.
              
   if avail wk-reg2
   then do:
            create wk-erros.
            assign wk-erros.cd-tipo-erro = "E"
                   wk-erros.cd-tipo-regs = 2
                   wk-erros.ds-desc      = "Prestador X Vinculo X Especialidade "
                                         + "duplicado no arquivo texto".
            assign lg-erro = yes.
        end.
   else do: /* ------------------- CRIAR REGISTRO --- */
            create wk-reg2.
            assign wk-reg2.cd-vinculo               = c-cd-vinculo
                   wk-reg2.cd-especialid            = c-cd-especialid
                   wk-reg2.lg-principal             = c-lg-principal
                   wk-reg2.lg-considera-qt-vinculo  = c-lg-considera-qt-vinculo
                   wk-reg2.cd-registro-espec        = substring(c-dados,9,10)
                   wk-reg2.cd-registro-espec-2      = dec(substring(c-dados,21,10))
                   wk-reg2.in-tipo-especialidade    = int(substring(c-dados,31,1))
                   wk-reg2.cd-tit-cert-esp          = int(substring(c-dados,32,3)).

            /*if substring(c-dados,19,1)            = "0"
            then wk-reg2.cd-tipo-contratualizacao = "".
            else*/ wk-reg2.cd-tipo-contratualizacao = substring(c-dados,19,1).

            /* Registro de Certificacao de Especialista */
            if substring(c-dados,20,1)  = "S"
            then assign wk-reg2.lg-rce = yes.
            else assign wk-reg2.lg-rce = no.
        end.
end procedure.
 
/*---------------------------------------------------------------------------*/
/* IMPORTAR DADOS PARA ENDPRES ( OPCIONAL )                                  */
/*---------------------------------------------------------------------------*/

procedure imp-reg-endpres:
   assign c-nr-seq-endereco = c-nr-seq-endereco + 1.
 
   /* --------------------------------------------------- CRIAR REGISTRO --- */
   create wk-reg3.
   assign wk-reg3.nr-seq-endereco = c-nr-seq-endereco.
 
   /* ------------------------------------------ CONSISTE CAMPO ENDERECO --- */
   assign wk-reg3.en-endereco = trim(substring(c-dados,002,40)).
 
   assign wk-reg3.en-complemento = trim(substr(c-dados,228,15)).

   assign wk-reg3.en-bairro = trim(substring(c-dados,042,15)).
 
   /* -------------------------------------------- CONSISTE CAMPO CIDADE --- */
   assign wk-reg3.cd-cidade = int(substring(c-dados,057,06)) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 3
                 wk-erros.ds-desc      = "Cidade ("
                                       + substring(c-dados,057,06)
                                       + ") nao Numerica".
          assign lg-erro = yes.
        end.

   /* ------------------------------------------------------------ CONSISTE CAMPO CEP --- */
   assign wk-reg3.en-cep = trim(string(int(substring(c-dados,063,08)),"99999999")) no-error.
 
   if   error-status:error
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 3
                 wk-erros.ds-desc      = "CEP ("
                                       + substring(c-dados,063,08)
                                       + ") nao Numerico".
          assign lg-erro = yes.
        end.
 
   /* ------------------------------------------------ CONSISTE CAMPO UF --- */
   assign wk-reg3.en-uf = trim(substring(c-dados,071,02)).
 
   run consiste-endereco (input wk-reg3.cd-cidade,
                          input wk-reg3.en-uf,
                          input wk-reg3.en-cep,
                          input wk-reg3.en-endereco,
                          input wk-reg3.en-bairro,
                          input c-in-tipo-pessoa,
                          input "O",
                          input-output lg-erro, 
                          input 3).


   /* --------------------------------------- CONSISTE CAMPO TELEFONE 01 --- */
   assign wk-reg3.nr-fone[01] = trim(substring(c-dados,073,12)).
 
   /* --------------------------------------- CONSISTE CAMPO TELEFONE 02 --- */
   assign wk-reg3.nr-fone[02] = trim(substring(c-dados,085,12)).
 
   /* ------------------------------------------ CONSISTE CAMPO RAMAL 01 --- */
   assign wk-reg3.nr-ramal[01] = trim(substring(c-dados,097,05)).
 
   /* ------------------------------------------ CONSISTE CAMPO RAMAL 02 --- */
   assign wk-reg3.nr-ramal[02] = trim(substring(c-dados,102,05)).
 
   /* -------------------------------- CONSISTE CAMPO HORA ENTRADA MANHA --- */
   assign wk-reg3.hr-man-ent = trim(substring(c-dados,107,04)).
   run consiste-hora(wk-reg3.hr-man-ent, "Entrada Manha").

   /* ---------------------------------- CONSISTE CAMPO HORA SAIDA MANHA --- */
   assign wk-reg3.hr-man-sai = trim(substring(c-dados,111,04)).
   run consiste-hora(wk-reg3.hr-man-sai, "Saida Manha").

   /* -------------------------------- CONSISTE CAMPO HORA ENTRADA TARDE --- */
   assign wk-reg3.hr-tar-ent = trim(substring(c-dados,115,04)).
   run consiste-hora(wk-reg3.hr-tar-ent, "Entrada Tarde").
 
   /* ---------------------------------- CONSISTE CAMPO HORA SAIDA TARDE --- */
   assign wk-reg3.hr-tar-sai = trim(substring(c-dados,119,04)).
   run consiste-hora(wk-reg3.hr-tar-sai, "Saida Tarde").

   /* ---------------------------------- CONSISTE CAMPO TRABALHA SEGUNDA --- */
   run consiste-dias-trabalha(1,123,"Segunda").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA MANHA SEGUNDA --- */
   assign wk-reg3.hr-man-ent-segunda = trim(substring(c-dados,124,04)).
   run consiste-hora(wk-reg3.hr-man-ent-segunda, "Entrada Manha Segunda").

   /* -------------------------- CONSISTE CAMPO HORA SAIDA MANHA SEGUNDA --- */
   assign wk-reg3.hr-man-sai-segunda = trim(substring(c-dados,128,04)).
   run consiste-hora(wk-reg3.hr-man-sai-segunda, "Saida Manha Segunda").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA TARDE SEGUNDA --- */
   assign wk-reg3.hr-tar-ent-segunda = trim(substring(c-dados,132,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-segunda, "Entrada Tarde Segunda").
 
   /* -------------------------- CONSISTE CAMPO HORA SAIDA TARDE SEGUNDA --- */
   assign wk-reg3.hr-tar-sai-segunda = trim(substring(c-dados,136,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-segunda, "Saida Tarde Segunda").

   /* ------------------------------------ CONSISTE CAMPO TRABALHA TERCA --- */
   run consiste-dias-trabalha(1,140,"Terca").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA MANHA TERCA --- */
   assign wk-reg3.hr-man-ent-terca = trim(substring(c-dados,141,04)).
   run consiste-hora(wk-reg3.hr-man-ent-terca, "Entrada Manha Terca").

   /* ---------------------------- CONSISTE CAMPO HORA SAIDA MANHA TERCA --- */
   assign wk-reg3.hr-man-sai-terca = trim(substring(c-dados,145,04)).
   run consiste-hora(wk-reg3.hr-man-sai-terca, "Saida Manha Terca").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA TARDE TERCA --- */
   assign wk-reg3.hr-tar-ent-terca = trim(substring(c-dados,149,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-terca, "Entrada Tarde Terca").
 
   /* ---------------------------- CONSISTE CAMPO HORA SAIDA TARDE TERCA --- */
   assign wk-reg3.hr-tar-sai-terca = trim(substring(c-dados,153,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-terca, "Saida Tarde Terca").

   /* ----------------------------------- CONSISTE CAMPO TRABALHA QUARTA --- */
   run consiste-dias-trabalha(1,157,"Quarta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA MANHA QUARTA --- */
   assign wk-reg3.hr-man-ent-quarta = trim(substring(c-dados,158,04)).
   run consiste-hora(wk-reg3.hr-man-ent-quarta, "Entrada Manha Quarta").

   /* --------------------------- CONSISTE CAMPO HORA SAIDA MANHA QUARTA --- */
   assign wk-reg3.hr-man-sai-quarta = trim(substring(c-dados,162,04)).
   run consiste-hora(wk-reg3.hr-man-sai-quarta, "Saida Manha Quarta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA TARDE QUARTA --- */
   assign wk-reg3.hr-tar-ent-quarta = trim(substring(c-dados,166,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-quarta, "Entrada Tarde Quarta").
 
   /* --------------------------- CONSISTE CAMPO HORA SAIDA TARDE QUARTA --- */
   assign wk-reg3.hr-tar-sai-quarta = trim(substring(c-dados,170,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-quarta, "Saida Tarde Quarta").

   /* ----------------------------------- CONSISTE CAMPO TRABALHA QUINTA --- */
   run consiste-dias-trabalha(1,174,"Quinta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA MANHA QUINTA --- */
   assign wk-reg3.hr-man-ent-quinta = trim(substring(c-dados,175,04)).
   run consiste-hora(wk-reg3.hr-man-ent-quinta, "Entrada Manha Quinta").

   /* --------------------------- CONSISTE CAMPO HORA SAIDA MANHA QUINTA --- */
   assign wk-reg3.hr-man-sai-quinta = trim(substring(c-dados,179,04)).
   run consiste-hora(wk-reg3.hr-man-sai-quinta, "Saida Manha Quinta").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA TARDE QUINTA --- */
   assign wk-reg3.hr-tar-ent-quinta = trim(substring(c-dados,183,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-quinta, "Entrada Tarde Quinta").
 
   /* --------------------------- CONSISTE CAMPO HORA SAIDA TARDE QUINTA --- */
   assign wk-reg3.hr-tar-sai-quinta = trim(substring(c-dados,187,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-quinta, "Saida Tarde Quinta").

   /* ------------------------------------ CONSISTE CAMPO TRABALHA SEXTA --- */
   run consiste-dias-trabalha(1,191,"Sexta").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA MANHA SEXTA --- */
   assign wk-reg3.hr-man-ent-sexta = trim(substring(c-dados,192,04)).
   run consiste-hora(wk-reg3.hr-man-ent-sexta, "Entrada Manha Sexta").

   /* ---------------------------- CONSISTE CAMPO HORA SAIDA MANHA SEXTA --- */
   assign wk-reg3.hr-man-sai-sexta = trim(substring(c-dados,196,04)).
   run consiste-hora(wk-reg3.hr-man-sai-sexta, "Saida Manha Sexta").

   /* -------------------------- CONSISTE CAMPO HORA ENTRADA TARDE SEXTA --- */
   assign wk-reg3.hr-tar-ent-sexta = trim(substring(c-dados,200,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-segunda, "Entrada Tarde Sexta").
 
   /* ---------------------------- CONSISTE CAMPO HORA SAIDA TARDE SEXTA --- */
   assign wk-reg3.hr-tar-sai-sexta = trim(substring(c-dados,204,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-sexta, "Saida Tarde Sexta").

   /* ----------------------------------- CONSISTE CAMPO TRABALHA SABADO --- */
   run consiste-dias-trabalha(1,208,"Sabado").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA MANHA SABADO --- */
   assign wk-reg3.hr-man-ent-sabado = trim(substring(c-dados,209,04)).
   run consiste-hora(wk-reg3.hr-man-ent-sabado, "Entrada Manha Sabado").

   /* --------------------------- CONSISTE CAMPO HORA SAIDA MANHA SABADO --- */
   assign wk-reg3.hr-man-sai-sabado = trim(substring(c-dados,213,04)).
   run consiste-hora(wk-reg3.hr-man-sai-sabado, "Saida Manha Sabado").

   /* ------------------------- CONSISTE CAMPO HORA ENTRADA TARDE SABADO --- */
   assign wk-reg3.hr-tar-ent-sabado = trim(substring(c-dados,217,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-sabado, "Entrada Tarde Sabado").
 
   /* --------------------------- CONSISTE CAMPO HORA SAIDA TARDE SABADO --- */
   assign wk-reg3.hr-tar-sai-sabado = trim(substring(c-dados,221,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-sabado, "Saida Tarde Sabado").

   /* ---------------------------------- CONSISTE CAMPO TRABALHA DOMINGO --- */
   run consiste-dias-trabalha(1,225,"Domingo").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA MANHA DOMINGO --- */
   assign wk-reg3.hr-man-ent-domingo = trim(substring(c-dados,226,04)).
   run consiste-hora(wk-reg3.hr-man-ent-domingo, "Entrada Manha Domingo").

   /* -------------------------- CONSISTE CAMPO HORA SAIDA MANHA DOMINGO --- */
   assign wk-reg3.hr-man-sai-domingo = trim(substring(c-dados,230,04)).
   run consiste-hora(wk-reg3.hr-man-sai-domingo, "Saida Manha Domingo").

   /* ------------------------ CONSISTE CAMPO HORA ENTRADA TARDE DOMINGO --- */
   assign wk-reg3.hr-tar-ent-domingo = trim(substring(c-dados,234,04)).
   run consiste-hora(wk-reg3.hr-tar-ent-domingo, "Entrada Tarde Domingo").
 
   /* -------------------------- CONSISTE CAMPO HORA SAIDA TARDE DOMINGO --- */
   assign wk-reg3.hr-tar-sai-domingo = trim(substring(c-dados,238,04)).
   run consiste-hora(wk-reg3.hr-tar-sai-domingo, "Saida Tarde Domingo").

   /* ------------------------------------ CONSISTE CAMPO UTILIZA MALOTE --- */
   case trim(substring(c-dados,242,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Utiliza Malote (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-malote = yes.
 
      when "N"
      then assign wk-reg3.lg-malote = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo Utiliza Malote ("
                                          + substring(c-dados,242,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ---------------------------- CONSISTE CAMPO RECEBE CORRESPONDENCIA --- */
   case trim(substring(c-dados,243,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Recebe Correspondencia (Sim/Nao) "
                                          + "nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-recebe-corresp = yes.
 
      when "N"
      then assign wk-reg3.lg-recebe-corresp = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo Recebe Correspondencia ("
                                          + substring(c-dados,243,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
 
   /* ------------------------------------- CONSISTE CAMPO TIPO ENDERECO --- */
   if   int(substring(c-dados,244,01)) < 1
   and  int(substring(c-dados,244,01)) > 3
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 3
                 wk-erros.ds-desc      = "Conteudo do Campo Tipo Endereco ("
                                       + substring(c-dados,244,01)
                                       + ") NAO CONFERE com os Conteudos "
                                       + "Definidos no Layout de Importacao".
          assign lg-erro = yes.
        end.
 
   else assign wk-reg3.in-tipo-endereco = int(substring(c-dados,244,01)).

   assign wk-reg3.cd-cnes                      = int(substring(c-dados,245,7))
          wk-reg3.nr-leitos-tot                = substr(c-dados,252,6) 
          wk-reg3.nr-leitos-contrat            = substr(c-dados,258,6) 
          wk-reg3.nr-leitos-psiquiat           = substr(c-dados,264,6) 
          wk-reg3.nr-uti-adulto                = substr(c-dados,270,6) 
          wk-reg3.nr-uti-neonatal              = substr(c-dados,276,6) 
          wk-reg3.nr-uti-pediatria             = substr(c-dados,282,6)
          wk-reg3.nr-uti-neo-interm-neo        = substr(c-dados,323,6)
          wk-reg3.nr-leitos-hosp-dia           = int(substring(c-dados,379,06)) 
          wk-reg3.nr-leitos-tot-psic-n-uti     = int(substring(c-dados,385,06)) 
          wk-reg3.nr-leitos-tot-cirur-n-uti    = int(substring(c-dados,391,06)) 
          wk-reg3.nr-leitos-tot-ped-n-uti      = int(substring(c-dados,397,06)) 
          wk-reg3.nr-leito-tot-obst-n-uti      = int(substring(c-dados,403,06)) 
          wk-reg3.nm-latitue                   = substring(c-dados,409,20)      
          wk-reg3.nm-longitude                 = substring(c-dados,429,20)
          wk-reg3.nr-uti-neo-interm            = substr(c-dados,449,6).    

                                               
   /*-------------- Consiste e Filial  ------------------------*/
   case substring(c-dados,303,01):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Filial (Sim/Nao) nao Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-filial = yes.
 
      when "N"
      then assign wk-reg3.lg-filial = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo E Filial ("
                                          + substring(c-dados,303,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.

   /* --------------------------------------------------------------------------------- */
   assign wk-reg3.nr-cgc-cpf = trim(substring(c-dados,304,19)).

   if   wk-reg3.lg-filial  = yes 
   and trim(wk-reg3.nr-cgc-cpf) = ""
   then do:
          create wk-erros.
          assign wk-erros.cd-tipo-erro = "E"
                 wk-erros.cd-tipo-regs = 1
                 wk-erros.ds-desc      = "Numero do CGC/CPF da filial do prestador nao informado".
          assign lg-erro = yes.
        end.

   else do: 
          if   not lg-formato-livre-aux
          then do:
                 run desedita-numero-cgc-cpf (input  wk-reg3.nr-cgc-cpf,
                                              output nr-cgc-cpf-aux).
          
                 assign wk-reg3.nr-cgc-cpf = nr-cgc-cpf-aux.
               end.
          
          if trim(wk-reg3.nr-cgc-cpf) <> ""
          then do:
                 run rtp/rtcgccpf.p(input  c-in-tipo-pessoa,
                                    input  wk-reg3.nr-cgc-cpf,
                                    input  no,
                                    output ds-mensrela-aux,
                                    output lg-erro-cgc-cpf-aux).
                 
                 if lg-erro-cgc-cpf-aux
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 1
                               wk-erros.ds-desc      = ds-mensrela-aux
                                                     + " Verifique CGC/CPF da filial do prestador.".
                        assign lg-erro = yes.
                      end.
               end.
        end.
   
   /* --------------------------------------------------------------------------------- */
   assign wk-reg3.nm-end-web  = substr(c-dados,329,50).
   
   /*------------------------------------------------------------------------------------------*/

end procedure.
 
/* ------------------------------------------------------------------------------------------- */
procedure imp-reg-prest-inst:
    
    /* --------------------------------------------------- CRIAR REGISTRO --- */
    create wk-reg4.
    
    /* ------------------------------------------ CONSISTE CAMPO ENDERECO --- */
    assign wk-reg4.cod-instit = substring(c-dados,2,5).
    
    /* --------------------------------- CONSISTE CAMPO NIVEL ACREDICATAO --- */
    assign wk-reg4.cdn-nivel = int(substring(c-dados,7,1)) no-error.
    
    if   error-status:error
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 3
                  wk-erros.ds-desc      = "Nivel Acreditacao ("
                                        + substring(c-dados,7,1)
                                        + ") nao Numerico".
           assign lg-erro = yes.
         end.
    else do:
           if   wk-reg4.cdn-nivel < 1
           or   wk-reg4.cdn-nivel > 4
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 3
                         wk-erros.ds-desc      = "Conteudo do Campo Nivel Acreditacao ("
                                               + substring(c-dados,7,1)
                                               + ") NAO CONFERE com os Conteudos "
                                               + "Definidos no Layout de Importacao".
                  assign lg-erro = yes.
                end.
         end.

    /* ---------------------------------- CONSISTE CAMPO AUTORIZA DIVULGA --- */
    case trim(substring(c-dados,8,01)):
           when ""
           then do:
                  create wk-erros.
                  assign wk-erros.cd-tipo-erro = "E"
                         wk-erros.cd-tipo-regs = 1
                         wk-erros.ds-desc      = "Medico (Sim/Nao) nao Informado".
                  assign lg-erro = yes.
                end.
        
       when "S"
       then assign wk-reg4.lg-autoriz-divulga = yes.
       
       when "N"
       then assign wk-reg4.lg-autoriz-divulga = no.
       
       otherwise
            do:
              create wk-erros.
              assign wk-erros.cd-tipo-erro = "E"
                     wk-erros.cd-tipo-regs = 1
                     wk-erros.ds-desc      = "Conteudo do Campo Autoriza Divulgacao ("
                                           + substring(c-dados,8,01)
                                           + ") NAO CONFERE com os Conteudos "
                                           + "Definidos no Layout de "
                                           + "Importacao (S/N)".
              assign lg-erro = yes.
            end.
    end case.

    /* ------------------------ CAMPO SEQUENCIA ENDERECO --------------------- */
    assign wk-reg4.cd-seq-end = int(substr(c-dados,9,2)).

end procedure.

/* --------------------------------------------------------------------------- */
procedure imp-reg-prestdor-obs:
    
    /* --------------------------------------------------- CRIAR REGISTRO --- */
    create wk-reg5.
    /* ---------------------------------- CONSISTE CAMPO AUTORIZA DIVULGA --- */
    assign wk-reg5.divulga-obs = substring(c-dados,2,length(trim(c-dados)) - 1).

    if   trim(wk-reg5.divulga-obs) = ""
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = "Observacoes nao Informadas".
           assign lg-erro = yes.
         end.

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure imp-reg-prest-subst: 

    if substring(c-dados,22,2) = "00"
    then do:
           create wk-reg6.
           assign wk-reg6.c-cd-unidade-subst   = int(substring(c-dados,2,4))
                  wk-reg6.c-cd-prest-subst     = int(substring(c-dados,6,8)).
                  
           if substring(c-dados,14,8) <> "00000000"
           then assign wk-reg6.c-dt-inicio-subst = date(substring(c-dados,14,8)).
           else assign wk-reg6.c-dt-inicio-subst = ?.

         end.
    else assign c-cd-motivo-exclusao = int(substring(c-dados,22,2)).

end procedure.

/* ------------------------------------------------------------------------------------------- */
procedure desedita-numero-cgc-cpf:

   /* ----------------------------------------- DEFINICAO DE PARAMETROS DE ENTRADA E SAIDA --- */
   def input  parameter nr-cgc-cpf-editado-par    like contrat.nr-cgc-cpf                no-undo.
   def output parameter nr-cgc-cpf-deseditado-par like contrat.nr-cgc-cpf                no-undo.

   /* ------------------------------------------------------ DEFINICAO DE VARIAVEIS LOCAIS --- */
   def var ix-cont-aux                              as int                               no-undo.

   /* ---------------------------------------------------------------------------------------- */
   assign nr-cgc-cpf-deseditado-par = "".

   do ix-cont-aux = 1 to length(trim(nr-cgc-cpf-editado-par)):

      if   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "0"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "1"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "2"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "3"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "4"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "5"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "6"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "7"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "8"
      or   substring(nr-cgc-cpf-editado-par,ix-cont-aux,1) = "9"
      then assign nr-cgc-cpf-deseditado-par = nr-cgc-cpf-deseditado-par + substring(nr-cgc-cpf-editado-par,ix-cont-aux,1).
   end.

end procedure.

/* -------------------------------------------------------------------------- */
procedure consiste-hora:
   def input parameter hr-par          as char                          no-undo.
   def input parameter ds-mensagem-par as char                          no-undo.

   if   trim(hr-par) <> ""
   then do:
          if   length(trim(hr-par)) <> 04
          then do:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = 3
                        wk-erros.ds-desc      = "Hora " + ds-mensagem-par
                                                        + " Incompleta".
                 assign lg-erro = yes.
               end.
          else do:
                 assign hr-aux = string(int(hr-par),"9999") no-error.
 
                 if   error-status:error
                 then do:
                        create wk-erros.
                        assign wk-erros.cd-tipo-erro = "E"
                               wk-erros.cd-tipo-regs = 3
                               wk-erros.ds-desc      = "Hora " + ds-mensagem-par + " ("
                                                     + hr-par + ") nao Numerica".
                        assign lg-erro = yes.
                      end.
                 else do:
                        if   int(substring(hr-aux,01,02)) > 23
                        or   int(substring(hr-aux,03,02)) > 59
                        then do:
                               create wk-erros.
                               assign wk-erros.cd-tipo-erro = "E"
                                      wk-erros.cd-tipo-regs = 3
                                      wk-erros.ds-desc      = "Hora " + ds-mensagem-par
                                                                      + " Invalida".
                               assign lg-erro = yes.
                             end.
                      end.
               end.
        end.
end procedure.
/* ------------------------------------------------------------------------------------------- */

procedure consiste-dias-trabalha:
   def input parameter in-dia-par as int                                no-undo.
   def input parameter in-pos-par as int                                no-undo.
   def input parameter ds-dia-par as char                               no-undo.

   case trim(substring(c-dados,in-pos-par,01)):
      when ""
      then do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Tabalha " + ds-dia-par + " (Sim/Nao) nao "
                                          + "Informado".
             assign lg-erro = yes.
           end.
 
      when "S"
      then assign wk-reg3.lg-dias-trab[in-dia-par] = yes.
 
      when "N"
      then assign wk-reg3.lg-dias-trab[in-dia-par] = no.
 
      otherwise
           do:
             create wk-erros.
             assign wk-erros.cd-tipo-erro = "E"
                    wk-erros.cd-tipo-regs = 3
                    wk-erros.ds-desc      = "Conteudo do Campo Trabalha "
                                          + ds-dia-par + " ("
                                          + substring(c-dados,in-pos-par,01)
                                          + ") NAO CONFERE com os Conteudos "
                                          + "Definidos no Layout de "
                                          + "Importacao (S/N)".
             assign lg-erro = yes.
           end.
   end case.
end procedure.


procedure consiste-endereco:
    
    def input        parameter cd-cidade-par     like dzcidade.cd-cidade     no-undo.
    def input        parameter en-uf-par         like usuario.en-uf          no-undo.
    def input        parameter en-cep-par        like usuario.en-cep         no-undo. 
    def input        parameter en-rua-par        like usuario.en-rua         no-undo.
    def input        parameter en-bairro-par     like usuario.en-bairro      no-undo.
    def input        parameter tipo-pessoa-par   like preserv.in-tipo-pessoa no-undo.
    def input        parameter in-tipo-par       as char format "x(1)"       no-undo.
    def input-output parameter lg-erro-par       as log                      no-undo.
    def input        parameter cd-tipo-reg-par   as int format "9"           no-undo.
    
    /* 07/11/2016 - Alex Boeira - retirada validacao de endereco. Devem ser aceitos os enderecos como estao no Unicoo.
     * na digitacao em tela as consistencias continuarao ocorrendo normalmente.
    if   int(en-cep-par) = 0
    then en-cep-par = "".

    assign lg-erro-rtendere-aux            = no
           lg-prim-mens-rtendere-aux       = no
           in-modulo-sistema-rtendere-aux  = "CG"
           in-tipo-rtendere-aux            = in-tipo-par
           in-tipo-tela-rtendere-aux       = no
           in-tp-rtendere-aux              = tipo-pessoa-par
           cd-cidade-rtendere-aux          = cd-cidade-par
           en-uf-rtendere-aux              = en-uf-par       
           en-cep-rtendere-aux             = en-cep-par      
           en-rua-rtendere-aux             = en-rua-par      
           en-bairro-retendere-aux         = en-bairro-par.  
      
    run rtp/rtendere.p.                 
    
    if   lg-erro-rtendere-aux
    then do:
            for each tmp-mensa-rtendere no-lock:
                 create wk-erros.
                 assign wk-erros.cd-tipo-erro = "E"
                        wk-erros.cd-tipo-regs = cd-tipo-reg-par
                        wk-erros.ds-desc      = tmp-mensa-rtendere.ds-mensagem-mens +
                                                " " + 
                                                tmp-mensa-rtendere.ds-chave-mens.
            end.
            assign lg-erro-par = yes.
         end.
    */

end procedure.

procedure consulta-imposto:

    def input  param c-cd-imposto-par as char no-undo.
    def input  param c-des-erro-par   as char no-undo.
    def output param lg-erro-par      as log  no-undo.

     find imposto
    where imposto.cod_pais          = "BRA"
      and imposto.cod_unid_federac  = c-en-uf
      and imposto.cod_imposto       = c-cd-imposto-par 
          no-lock no-error.

    if not avail imposto
    then find imposto
        where imposto.cod_pais          = "BRA"
          and imposto.cod_unid_federac  = "  "
          and imposto.cod_imposto       = c-cd-imposto-par
              no-lock no-error.

    if   not avail imposto and c-cd-magnus <> 0
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
  	 			  wk-erros.ds-desc      = c-des-erro-par
                  lg-erro-par           = yes.
         end.
end.

procedure consulta-class-imposto:

    def input  param c-cd-imposto-par               as char no-undo.
    def input  param c-cd-classificacao-imposto-par as char no-undo.
    def input  param c-des-erro-par                 as char no-undo.
    def output param lg-erro-par                    as log  no-undo.

    find classif_impto
   where classif_impto.cod_pais          = "BRA"                  
     and classif_impto.cod_unid_federac  = c-en-uf                
     and classif_impto.cod_imposto       = c-cd-imposto-par       
     and classif_impto.cod_classif_impto = c-cd-classificacao-imposto-par
         no-lock no-error.

    if   not avail classif_impto
    then find classif_impto
        where classif_impto.cod_pais          = "BRA"            
          and classif_impto.cod_unid_federac  = "  "             
          and classif_impto.cod_imposto       = c-cd-imposto-par
          and classif_impto.cod_classif_impto = c-cd-classificacao-imposto-par
              no-lock no-error.

    if   not avail classif_impto and c-cd-magnus <> 0
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = c-des-erro-par.
           assign lg-erro-par = yes.
         end.

end procedure.

procedure consulta-vinc-imp-for:

    def input  param c-cd-imposto-par               as char no-undo.
    def input  param c-cd-classificacao-imposto-par as char no-undo.
    def input  param c-des-erro-par                 as char no-undo.
    def output param lg-erro-par                    as log  no-undo.

    find impto_vincul_fornec
   where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
     and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
     and impto_vincul_fornec.cod_pais          = "BRA"
     and impto_vincul_fornec.cod_unid_federac  = c-en-uf
     and impto_vincul_fornec.cod_imposto       = c-cd-imposto-par
     and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-imposto-par
         no-lock no-error.
                
    if not avail impto_vincul_fornec
    then find impto_vincul_fornec
        where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
          and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
          and impto_vincul_fornec.cod_pais          = "BRA"
          and impto_vincul_fornec.cod_unid_federac  = "  "
          and impto_vincul_fornec.cod_imposto       = c-cd-imposto-par
          and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-imposto-par 
              no-lock no-error.
    
    if   not avail impto_vincul_fornec
    then do:
           create wk-erros.
           assign wk-erros.cd-tipo-erro = "E"
                  wk-erros.cd-tipo-regs = 1
                  wk-erros.ds-desc      = c-des-erro-par.
           assign lg-erro-par = yes.
         end.

end procedure.


/* -------------------- ESTOURO DE SEGMENTO ---------------------------- */
procedure consiste-tributos:

    def var c-des-erro-aux as char no-undo.
    
    &if "{&sistema}" = "ems504"
    or  "{&sistema}" = "ems505"
    &then do: 
            /* ------------------------------------------------- CONSISTE IMPOSTO --- */
            assign c-cd-imposto = trim(substring(c-dados,607,5)).

            if c-cd-imposto <> ""
            or c-cd-imposto <> "     "
            then do:
                   if  c-cd-magnus <> 0
                   then do:
                          assign c-des-erro-aux = "Imposto de Renda (" + string(c-cd-imposto,"99999") + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-imposto,
                                                input c-des-erro-aux,
                                                output lg-erro).
                        end.
                   else if  c-cd-imposto <> ""
                        or  c-cd-imposto <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto de Renda ("
                                                             + string(c-cd-imposto,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* -------------------------------- CONSISTE CLASSIFICACAO DO IMPOSTO --- */
                   assign c-cd-classificacao-imposto = trim(substring(c-dados,612,5)).

                   if  c-cd-magnus <> 0
                   then DO:
                          assign c-des-erro-aux = "Classif. de Imposto de Renda ("
                                                + string(c-cd-classificacao-imposto,"99999")
                                                + ") nao Cadastrado".

                          run consulta-class-imposto (input c-cd-imposto,
                                                      input c-cd-classificacao-imposto,
                                                      input c-des-erro-aux,
                                                      output lg-erro).                           
                        end.
                   else if  c-cd-classificacao-imposto <> ""
                        or  c-cd-classificacao-imposto <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto de Renda ("
                                                               + string(c-cd-classificacao-imposto,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.

                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if c-cd-magnus <> 0
                   then do:
                          assign c-des-erro-aux = "Imposto de Renda Vinculado ("
                                                + string(c-cd-imposto,"99999") + " - " 
                                                + string(c-cd-classificacao-imposto,"99999")
                                                + ") ao fornecedor nao Cadastrado".

                          run consulta-vinc-imp-for (input c-cd-imposto,
                                                     input c-cd-classificacao-imposto,
                                                     input c-des-erro-aux,
                                                     output lg-erro).  
                        end.
                 end.

            /* ------------------------------------------------- CONSISTE INSS - */
            assign c-cd-inss = trim(substring(c-dados,676,5)).

            if c-cd-inss <> ""
            or c-cd-inss <> "     "
            then do:
                   if  c-cd-magnus <> 0
                   and substring(c-dados,294,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto de INSS ("
                                                + string(c-cd-inss,"99999")
                                                + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-inss,
                                                input c-des-erro-aux,
                                                output lg-erro).
                        end.
                   else if  c-cd-inss <> ""
                        or  c-cd-inss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto de INSS ("
                                                             + string(c-cd-inss,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   
                   /* ----------------------------- CONSISTE CLASSIFICACAO DO INSS - */
                   assign c-cd-classificacao-inss = trim(substring(c-dados,681,5)).
                   
                   if  c-cd-magnus <> 0
                   and substring(c-dados,294,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Classif. de Imposto de INSS ("
                                                + string(c-cd-classificacao-inss,"99999")
                                                + ") nao Cadastrado".

                          run consulta-class-imposto (input c-cd-inss,
                                                      input c-cd-classificacao-inss,
                                                      input c-des-erro-aux,
                                                      output lg-erro). 
                        end.
                   else if  c-cd-classificacao-inss <> ""
                        or  c-cd-classificacao-inss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto de INSS ("
                                                               + string(c-cd-classificacao-inss,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if  c-cd-magnus <> 0
                   and substring(c-dados,294,1) = "S"
                   and c-in-tipo-pessoa = "F"
                   then do:
                           find impto_vincul_fornec
                                where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
                                  and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
                                  and impto_vincul_fornec.cod_pais          = "BRA"
                                  and impto_vincul_fornec.cod_unid_federac  = c-en-uf
                                  and impto_vincul_fornec.cod_imposto       = c-cd-inss
                                  and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-inss 
                                      no-lock no-error.
                         
                           if   not avail impto_vincul_fornec
                           then find impto_vincul_fornec
                                where impto_vincul_fornec.cod_empresa       = string(ep-codigo-aux)
                                  and impto_vincul_fornec.cdn_fornecedor    = c-cd-magnus
                                  and impto_vincul_fornec.cod_pais          = "BRA"
                                  and impto_vincul_fornec.cod_unid_federac  = "  "
                                  and impto_vincul_fornec.cod_imposto       = c-cd-inss
                                  and impto_vincul_fornec.cod_classif_impto = c-cd-classificacao-inss 
                                      no-lock no-error.
                         
                           if  paramepp.lg-deduz-inss
                           and not avail impto_vincul_fornec
                           then do:
                                  create wk-erros.
                                  assign wk-erros.cd-tipo-erro = "E"
                                         wk-erros.cd-tipo-regs = 1
                                         wk-erros.ds-desc      = "Imposto de INSS ("
                                                               + string(c-cd-inss,"99999") + " - " 
                                                               + string(c-cd-classificacao-inss,"99999")
                                                               + ") nao foi vinculado ao fornecedor.".
                                  assign lg-erro = yes.
                                end.
                           else if  not paramepp.lg-deduz-inss
                                and avail impto_vincul_fornec
                                then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto de INSS ("
                                                                    + string(c-cd-inss,"99999") + " - " 
                                                                    + string(c-cd-classificacao-inss,"99999")
                                                                    + ") nao pode ser vinculado ao fornecedor.".
                                       assign lg-erro = yes.
                                     end.
                        end.
                 end.
               
            /* ------------------------------------------------- CONSISTE ISS - */
            assign c-cd-iss = trim(substring(c-dados,687,5)).

            if c-cd-iss <> ""
            or c-cd-iss <> "     "
            then do:
                   if  c-cd-magnus <> 0
                   and substring(c-dados,686,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto de ISS ("
                                                + string(c-cd-iss,"99999")
                                                + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-iss,
                                                input c-des-erro-aux,
                                                output lg-erro).
                        end.
                   else if  c-cd-iss <> ""
                        or  c-cd-iss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto de ISS("
                                                             + string(c-cd-iss,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ----------------------------- CONSISTE CLASSIFICACAO DO ISS - */
                   assign c-cd-classificacao-iss = trim(substring(c-dados,692,5)).
                   
                   if  c-cd-magnus <> 0
                   and substring(c-dados,686,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Classif. de Imposto de ISS ("
                                                + string(c-cd-classificacao-iss,"99999")
                                                + ") nao Cadastrado".

                          run consulta-class-imposto (input c-cd-iss,
                                                      input c-cd-classificacao-iss,
                                                      input c-des-erro-aux,
                                                      output lg-erro). 
                        end.
                   else if  c-cd-classificacao-iss <> ""
                        or  c-cd-classificacao-iss <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto de ISS ("
                                                               + string(c-cd-classificacao-iss,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if  c-cd-magnus <> 0
                   and substring(c-dados,686,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto de ISS Vinculado ("
                                                + string(c-cd-iss,"99999") + " - " 
                                                + string(c-cd-classificacao-iss,"99999")
                                                + ") ao fornecedor nao Cadastrado".

                          run consulta-vinc-imp-for (input c-cd-iss,
                                                     input c-cd-classificacao-iss,
                                                     input c-des-erro-aux,
                                                     output lg-erro). 
                        end.
                 end.

            /* ------------------------------------------------- CONSISTE IMPOSTO UNICO ---- */
            assign c-cd-imposto-unico = trim(substring(c-dados,748,5)).

            if  c-cd-imposto-unico <> ""
            or  c-cd-imposto-unico <> "     "
            then do:
                   if   c-cd-magnus <> 0
                   and  substring(c-dados,747,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto ("
                                                + string(c-cd-imposto-unico,"99999")
                                                + ") nao Cadastrado".
                          run consulta-imposto (input c-cd-imposto-unico,
                                                input c-des-erro-aux,
                                                output lg-erro).
                        end.
                   else if  c-cd-imposto-unico <> ""
                        or  c-cd-imposto-unico <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Imposto ("
                                                             + string(c-cd-imposto-unico,"99999")
                                                             + ") deve ser brancos "
                                                             + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   
                   /* -------------------------------- CONSISTE CLASSIFICACAO DO IMPOSTO UNICO ---- */
                   assign c-cd-clas-imposto-unico = trim(substring(c-dados,753,5)).
                   
                   if  c-cd-magnus <> 0
                   and substring(c-dados,747,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Classif. de Imposto ("
                                                + string(c-cd-clas-imposto-unico,"99999")
                                                + ") nao Cadastrado".
                          run consulta-class-imposto (input c-cd-imposto-unico,
                                                      input c-cd-clas-imposto-unico,
                                                      input c-des-erro-aux,
                                                      output lg-erro).                  
                        end.
                   else if  c-cd-clas-imposto-unico <> ""
                        or  c-cd-clas-imposto-unico <> "     "
                        then do:
                                create wk-erros.
                                assign wk-erros.cd-tipo-erro = "E"
                                       wk-erros.cd-tipo-regs = 1
                                       wk-erros.ds-desc      = "Classif. de Imposto ("
                                                               + string(c-cd-clas-imposto-unico,"99999")
                                                               + ") deve ser brancos "
                                                               + "pois fornecedor nao foi informado"
                                       lg-erro = yes.
                             end.
                   /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                   if  c-cd-magnus <> 0
                   and substring(c-dados,747,1) = "S"
                   then do:
                          assign c-des-erro-aux = "Imposto Vinculado ("
                                                + string(c-cd-imposto-unico,"99999") + " - " 
                                                + string(c-cd-clas-imposto-unico,"99999")
                                                + ") ao fornecedor nao Cadastrado".
                   
                          run consulta-vinc-imp-for (input c-cd-imposto-unico,
                                                     input c-cd-clas-imposto-unico,
                                                     input c-des-erro-aux,
                                                     output lg-erro).
                        end.
                 end.

            if substring(c-dados,747,1) = "N" 
            then do:
                   if trim(substring(c-dados,748,5)) <> ""
                   then do:
                          create wk-erros.
                          assign wk-erros.cd-tipo-erro = "E"
                                 wk-erros.cd-tipo-regs = 1
                                 wk-erros.ds-desc      = "Os campos Cod. Imposto Unico "  + (trim(substring(c-dados,748,5)))
                                                       + " deve ser brancos". 
                          assign lg-erro = yes.
                        end.
            
                   if trim(substring(c-dados,753,5)) <> ""
                   then do:
                          create wk-erros.
                          assign wk-erros.cd-tipo-erro = "E"
                                 wk-erros.cd-tipo-regs = 1
                                 wk-erros.ds-desc      = "Os campos Classif. Imposto Unico " + trim(substring(c-dados,753,5))
                                                       + " deve ser brancos". 
                          assign lg-erro = yes.
                        end.

                   /* ------------------------------------------------- CONSISTE COFINS ---- */
                   assign c-cd-cofins = trim(substring(c-dados,646,5)).

                   if  c-cd-cofins <> ""
                   or  c-cd-cofins <> "     "
                   then do:
                          if  c-cd-magnus <> 0
                          and substring(c-dados,643,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto ("
                                                       + string(c-cd-cofins,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-imposto (input c-cd-cofins,
                                                       input c-des-erro-aux,
                                                       output lg-erro).
                               end.
                          else if  c-cd-cofins <> ""
                               or  c-cd-cofins <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto ("
                                                                    + string(c-cd-cofins,"99999")
                                                                    + ") deve ser brancos "
                                                                    + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* -------------------------------- CONSISTE CLASSIFICACAO DO COFINS ---- */
                          assign c-cd-classificacao-cofins = trim(substring(c-dados,661,5)).
                          
                          if  c-cd-magnus <> 0
                          and substring(c-dados,643,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Classif. de Imposto ("
                                                       + string(c-cd-classificacao-cofins,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-class-imposto (input c-cd-cofins,
                                                             input c-cd-classificacao-cofins,
                                                             input c-des-erro-aux,
                                                             output lg-erro).  
                               end.
                          else if  c-cd-classificacao-cofins <> ""
                               or  c-cd-classificacao-cofins <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Classif. de Imposto ("
                                                                      + string(c-cd-classificacao-cofins,"99999")
                                                                      + ") deve ser brancos "
                                                                      + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                          if  c-cd-magnus <> 0
                          and substring(c-dados,643,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto Vinculado ("
                                                       + string(c-cd-cofins,"99999") + " - " 
                                                       + string(c-cd-classificacao-cofins,"99999")
                                                       + ") ao fornecedor nao Cadastrado".
                                 
                                 run consulta-vinc-imp-for (input c-cd-cofins,
                                                            input c-cd-classificacao-cofins,
                                                            input c-des-erro-aux,
                                                            output lg-erro).
                               end.
                        end.

                    /* ------------------------------------------------- CONSISTE PIS/PASEP - */
                   assign c-cd-pispasep = trim(substring(c-dados,651,5)).

                   if  c-cd-pispasep <> ""
                   or  c-cd-pispasep <> "     "
                   then do:
                          if  c-cd-magnus <> 0
                          and substring(c-dados,644,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto ("
                                                       + string(c-cd-pispasep,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-imposto (input c-cd-pispasep,
                                                       input c-des-erro-aux,
                                                       output lg-erro).
                               end.
                          else if  c-cd-pispasep <> ""
                               or  c-cd-pispasep <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto ("
                                                                    + string(c-cd-pispasep,"99999")
                                                                    + ") deve ser brancos "
                                                                    + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* -------------------------------- CONSISTE CLASSIFICACAO DO PIS PASEP - */
                          assign c-cd-classificacao-pispasep = trim(substring(c-dados,666,5)).
                          
                          if  c-cd-magnus <> 0
                          and substring(c-dados,644,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Classif. de Imposto ("
                                                       + string(c-cd-classificacao-pispasep,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-class-imposto (input c-cd-pispasep,
                                                             input c-cd-classificacao-pispasep,
                                                             input c-des-erro-aux,
                                                             output lg-erro). 
                               end.
                          else if  c-cd-classificacao-pispasep <> ""
                               or  c-cd-classificacao-pispasep <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Classif. de Imposto ("
                                                                      + string(c-cd-classificacao-pispasep,"99999")
                                                                      + ") deve ser brancos "
                                                                      + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                          if c-cd-magnus <> 0
                          and substring(c-dados,644,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto Vinculado ("
                                                       + string(c-cd-pispasep,"99999") + " - " 
                                                       + string(c-cd-classificacao-pispasep,"99999")
                                                       + ") ao fornecedor nao Cadastrado".
                                 
                                 run consulta-vinc-imp-for (input c-cd-pispasep,
                                                            input c-cd-classificacao-pispasep,
                                                            input c-des-erro-aux,
                                                            output lg-erro).
                               end.
                        end.

                   /* ------------------------------------------------- CONSISTE CSLL - */
                   assign c-cd-csll = trim(substring(c-dados,656,5)).

                   if  c-cd-csll <> ""
                   or  c-cd-csll <> "     "
                   then do:
                          if  c-cd-magnus <> 0
                          and substring(c-dados,645,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto ("
                                                       + string(c-cd-csll,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-imposto (input c-cd-csll,
                                                       input c-des-erro-aux,
                                                       output lg-erro).
                               end.
                          else if  c-cd-csll <> ""
                               or  c-cd-csll <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Imposto ("
                                                                    + string(c-cd-csll,"99999")
                                                                    + ") deve ser brancos "
                                                                    + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* -------------------------------- CONSISTE CLASSIFICACAO DO CSLL - */
                          assign c-cd-classificacao-csll = trim(substring(c-dados,671,5)).
                          
                          if  c-cd-magnus <> 0
                          and substring(c-dados,645,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Classif. de Imposto ("
                                                       + string(c-cd-classificacao-csll,"99999")
                                                       + ") nao Cadastrado".
                                 run consulta-class-imposto (input c-cd-csll,
                                                             input c-cd-classificacao-csll,
                                                             input c-des-erro-aux,
                                                             output lg-erro). 
                               end.
                          else if  c-cd-classificacao-csll <> ""
                               or  c-cd-classificacao-csll <> "     "
                               then do:
                                       create wk-erros.
                                       assign wk-erros.cd-tipo-erro = "E"
                                              wk-erros.cd-tipo-regs = 1
                                              wk-erros.ds-desc      = "Classif. de Imposto ("
                                                                      + string(c-cd-classificacao-csll,"99999")
                                                                      + ") deve ser brancos "
                                                                      + "pois fornecedor nao foi informado"
                                              lg-erro = yes.
                                    end.
                          /* ---------------------------------------- CONSISTE IMPOSTO VINCULADO--- */
                          if  c-cd-magnus <> 0
                          and substring(c-dados,645,1) = "S"
                          then do:
                                 assign c-des-erro-aux = "Imposto Vinculado ("
                                                       + string(c-cd-csll,"99999") + " - " 
                                                       + string(c-cd-classificacao-csll,"99999")
                                                       + ") ao fornecedor nao Cadastrado".
                                 
                                 run consulta-vinc-imp-for (input c-cd-csll,
                                                            input c-cd-classificacao-csll,
                                                            input c-des-erro-aux,
                                                            output lg-erro).
                               end. 
                        end.
                 end.
            else do:
                   if trim(substring(c-dados,646,5)) <> ""
                   or trim(substring(c-dados,651,5)) <> ""
                   or trim(substring(c-dados,656,5)) <> ""
                   or trim(substring(c-dados,661,5)) <> ""
                   or trim(substring(c-dados,666,5)) <> ""
                   or trim(substring(c-dados,671,5)) <> ""
                   then do:
                          create wk-erros.
                          assign wk-erros.cd-tipo-erro = "E"
                                 wk-erros.cd-tipo-regs = 1
                                 wk-erros.ds-desc      = "Codigo(s) de Imposto(s) informado(s)"
                                                       + "que DEVERIAM estar em branco "
                                                       + trim(substring(c-dados,646,5)) + " - " 
                                                       + trim(substring(c-dados,651,5)) + " - " 
                                                       + trim(substring(c-dados,656,5)) + " - " 
                                                       + trim(substring(c-dados,661,5)) + " - " 
                                                       + trim(substring(c-dados,666,5)) + " - " 
                                                       + trim(substring(c-dados,671,5)).
                          assign lg-erro = yes.
                        end.
                 end.
            end.
    &endif.
    
end procedure.
/* -------------------------------------------------------------------- EOF - */
