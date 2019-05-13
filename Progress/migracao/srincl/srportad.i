/*****************************************************************************
*      Include  .....: srportad.i                                            *
*      Data .........: 28 de Agosto de 2000                                  *
*      Empresa ......: DZSET SOLUCOES & SISTEMAS                             *
*      Programador ..: Jaqueline Formigheri                                  *
*      Objetivo .....: Leitura da tabela portador     -sistemas Magnus e EMS *
*----------------------------------------------------------------------------*
*      VERSAO    DATA        RESPONSAVEL      MOTIVO                         *
*      D.00.000  28/08/2000  Jaque            Desenvolvimento                *
*      E.00.000  25/10/2000  Nora             Mudanca Versao Banco           *
*      E.01.000  15/05/2001  Jaque            Converter para ems504.         *
*****************************************************************************/

/* --- TPLE44 - Solucao para contornar o problema na migracao de dados do
              - portador do UNICOO para o GP, onde os dados no EMS sao gravados com 
              - "zeros" na frente  ------------------------------------------------- */
assign cod-portador-srems = string({2}).
if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
then do:
       /* --- Se nao encontrar do modo que ‚ atualmente testa com format para a mascara */
       assign cod-portador-srems = string({2},"99999").
       if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
       then do:
              IF {2} <= 9999
              THEN DO:
                     assign cod-portador-srems = string({2},"9999").
                     if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
                     then do: 
                            IF {2} <= 999
                            THEN DO:
                                   assign cod-portador-srems = string({2},"999").
                                   if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
                                   then do: 
                                          IF {2} <= 99
                                          THEN DO:
                                                 assign cod-portador-srems = string({2},"99").
                                                 if not can-find (first portador where portador.cod_portador = cod-portador-srems no-lock)
                                                 then assign cod-portador-srems = string({2}). /* se nao encontrar mantem logica anterior */
                                               END.
                                        end.
                                 END.
                          end.
                   END.
            end.
     end.

&if  "{&sistema}" = "ems504"
 or  "{&sistema}" = "ems505"
&then do:
        find portador where portador.cod_portador = cod-portador-srems
                       no-lock no-error.
        if avail portador
        then assign lg-avail-portador-srems = yes
                     nm-portador-srems       = portador.nom_pessoa.
        else assign lg-avail-portador-srems = no
                     nm-portador-srems       = "".
        find pais where pais.cod_pais = "BRA" no-lock no-error.
        if avail pais
        then do:
               find portad_finalid_econ where 
                    portad_finalid_econ.cod_estab        = {4}
               and  portad_finalid_econ.cod_portador     = cod-portador-srems /*string({2})*/
               and  portad_finalid_econ.cod_cart_bcia    = string({3}) 
               and  portad_finalid_econ.cod_finalid_econ = pais.cod_finalid_econ_pais
                    no-lock no-error.
                 
                    if avail portad_finalid_econ
                    then lg-avail-carteira-srems = yes.
                    else lg-avail-carteira-srems = no.
             end.
         else lg-avail-carteira-srems = no.
      end.
&else do:                               /*** ems202 e magnus ***/
         find portador where portador.ep-codigo    = {1}
                         and portador.cod-portador = cod-portador-srems /* {2}*/
                         and portador.modalidade   = {3}  no-lock no-error.
         if avail portador
         then assign lg-avail-portador-srems = yes
                     nm-portador-srems       = portador.nome.
         else assign lg-avail-portador-srems = no
                     nm-portador-srems       = "".
      end.
&endif.

/*** Final do include ***/
