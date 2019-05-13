define temp-table tt-pacote no-undo
  field cd-pacote             like paproins.cd-pacote             /* Codigo do Pacote */
  field ds-pacote             like paproins.ds-pacote             /* Descrição do Pacote */
  field ds-auxiliar           like paproins.char-1                /* Descrição Auxiliar do Pacote */
  field lg-agrupa-proc        like paproins.log-3                 /* Agrupa Procedimentos Sim/Nao */
  field cd-modalidade         like paproins.cd-modalidade         /* Modalidade - 0 para todos */
  field cd-plano              like paproins.cd-plano              /* Plano - 0 para todos */
  field cd-tipo-plano         like paproins.cd-tipo-plano         /* Tipo Plano - 0 para todos */
  field cd-unidade-prestadora like paproins.cd-unidade            /* Unidade do prestador - 0 para todos */
  field cd-prestador          like paproins.cd-prestador          /* Codigo do prestador - 0 para todos */
  field dt-inicio-vigencia    like paproins.dt-inicio-vigencia    /* Data de Inicio da Vigencia */
  field dt-limite             like paproins.dt-limite             /* Data de Fimda Vigencia */
  field lg-trata-procedimento like paproins.lg-trata-procedimento /* Pacote possui procedimentos Sim/Nao */
  field nm-tipo-valorizacao   like paproins.nm-tipo-valorizacao   /* Pagamento , Cobranca, Ambos, Por Movimento*/
  field pc-aplicado           like paproins.pc-aplicado           /* PErcentual de Desconto */
  field lg-permite-sem-guia   like paproins.log-1                 /* PErmite sem Guia Sim/Nao */
  field lg-pede-via-acesso    like paproins.log-4                 /* Pede via de acesso Sim/Nao */
  field cd-classe-hospitalar  like paproins.int-1                 /* Classe Hospitalar */
  field cd-tipo-pacote        like paproins.int-2                 /* Tipo de Pacote 00 - Nào informado, 
                                                                                    01 - Cirurgico, 
                                                                                    02 - Ambulatorio, 
                                                                                    03 - SADT
                                                                                    04 - Hospitalar
                                                                                    05 - Consulta */
  field cd-tipo-internacao    like paproins.int-4 /* Tipo de Internacao 00 - Não informado
                                                                        01 - Internacao Clinica
                                                                        02 - Internacao Cirurgica
                                                                        03 - Internacao Obstetrica
                                                                        04 - Internacao Pediatrica
                                                                        05 - Internacao Psiquiatrica */
  field cd-especialidade      like paproins.int-3                 /* Especialidade */
  field dt-negociacao         like paproins.date-1                /* Data da negociacao */
  field ds-observacao         like paproins.ds-observacao         /* Observacoes */
  field cd-tipo-movimento     as char                             /* P - procedimento I - Insumo */
  field cd-grupo-movimento    like pacinsum.cd-tipo-insumo        /* Tipo de insumo, 0 - para procedimento */
  field cd-movimento          like pacinsum.cd-insumo             /* Codigo do serviço  */
  field vl-movimento          like pacproce.vl-procedimento       /* Valor do serviço   */
  field qt-movimento          like pacproce.qt-procedimento       /* Quantidade serviço */
  field cd-ident-servico      like pacproce.int-1                          /* 01 - Principal, 02 - Secundaria */
  field ds-observacao-mov     like pacproce.ds-observacao         /* observacoes movimento */.
  
define variable nm-arquivo-aux as char label "Caminho Arquivo CSV" format "x(70)" INIT "c:\temp\pacotes.csv" no-undo.

update nm-arquivo-aux.

input from value(nm-arquivo-aux).
repeat:
  create tt-pacote.
  import tt-pacote no-error.
end.
input close.


for each tt-pacote no-lock:
  
  find first paproins no-lock
       where paproins.cd-pacote           = tt-pacote.cd-pacote
         and paproins.cd-unidade          = tt-pacote.cd-unidade
         and paproins.cd-prestador        = tt-pacote.cd-prestador
         and paproins.cd-modalidade       = tt-pacote.cd-modalidade
         and paproins.cd-plano            = tt-pacote.cd-plano
         and paproins.cd-tipo-plano       = tt-pacote.cd-tipo-plano
         and paproins.dt-inicio-vigencia  = tt-pacote.dt-inicio-vigencia
         and paproins.dt-limite           = tt-pacote.dt-limite no-error.
   
  if not available paproins
  then do:
      create paproins.
      assign paproins.cd-pacote           = tt-pacote.cd-pacote
             paproins.cd-unidade          = tt-pacote.cd-unidade
             paproins.cd-prestador        = tt-pacote.cd-prestador
             paproins.cd-modalidade       = tt-pacote.cd-modalidade
             paproins.cd-plano            = tt-pacote.cd-plano
             paproins.cd-tipo-plano       = tt-pacote.cd-tipo-plano
             paproins.dt-inicio-vigencia  = tt-pacote.dt-inicio-vigencia
             paproins.dt-limite           = tt-pacote.dt-limite.
             
      assign paproins.ds-pacote             = tt-pacote.ds-pacote
             paproins.char-1                = tt-pacote.ds-auxiliar
             paproins.log-3                 = tt-pacote.lg-agrupa-proc
             paproins.lg-trata-procedimento = tt-pacote.lg-trata-procedimento
             paproins.nm-tipo-valorizacao   = tt-pacote.nm-tipo-valorizacao
             paproins.pc-aplicado           = tt-pacote.pc-aplicado
             paproins.log-1                 = tt-pacote.lg-permite-sem-guia
             paproins.log-4                 = tt-pacote.lg-pede-via-acesso
             /* Campos PTU A1200 */     
             paproins.int-1                 = tt-pacote.cd-classe-hospitalar
             paproins.int-2                 = tt-pacote.cd-tipo-pacote
             paproins.int-3                 = tt-pacote.cd-especialidade
             paproins.int-4                 = tt-pacote.cd-tipo-internacao
             paproins.date-1                = tt-pacote.dt-negociacao
             paproins.ds-observacao         = tt-pacote.ds-observacao.  
      
  end.
  
  if tt-pacote.cd-tipo-movimento = "P" 
  then do:
      find first pacproce no-lock
           where pacproce.cd-pacote           = tt-pacote.cd-pacote
             and pacproce.cd-unidade          = tt-pacote.cd-unidade
             and pacproce.cd-prestador        = tt-pacote.cd-prestador
             and pacproce.cd-modalidade       = tt-pacote.cd-modalidade
             and pacproce.cd-plano            = tt-pacote.cd-plano
             and pacproce.cd-tipo-plano       = tt-pacote.cd-tipo-plano
             and pacproce.dt-inicio-vigencia  = tt-pacote.dt-inicio-vigencia
             and pacproce.dt-limite           = tt-pacote.dt-limite 
             and pacproce.cd-esp-amb          = int(substring(string(tt-pacote.cd-movimento,"99999999"), 1, 2))
             and pacproce.cd-grupo-proc-amb   = int(substring(string(tt-pacote.cd-movimento,"99999999"), 3, 2))
             and pacproce.cd-procedimento     = int(substring(string(tt-pacote.cd-movimento,"99999999"), 5, 3))
             and pacproce.dv-procedimento     = int(substring(string(tt-pacote.cd-movimento,"99999999"), 8, 1))
              no-error.
             
      if not available pacproce 
      then do:
          create pacproce.
          assign  pacproce.cd-pacote           = tt-pacote.cd-pacote
                  pacproce.cd-unidade          = tt-pacote.cd-unidade
                  pacproce.cd-prestador        = tt-pacote.cd-prestador
                  pacproce.cd-modalidade       = tt-pacote.cd-modalidade
                  pacproce.cd-plano            = tt-pacote.cd-plano
                  pacproce.cd-tipo-plano       = tt-pacote.cd-tipo-plano
                  pacproce.dt-inicio-vigencia  = tt-pacote.dt-inicio-vigencia
                  pacproce.dt-limite           = tt-pacote.dt-limite 
                  pacproce.cd-esp-amb          = int(substring(string(tt-pacote.cd-movimento,"99999999"), 1, 2))
                  pacproce.cd-grupo-proc-amb   = int(substring(string(tt-pacote.cd-movimento,"99999999"), 3, 2))
                  pacproce.cd-procedimento     = int(substring(string(tt-pacote.cd-movimento,"99999999"), 5, 3))
                  pacproce.dv-procedimento     = int(substring(string(tt-pacote.cd-movimento,"99999999"), 8, 1)).
          
          assign pacproce.vl-procedimento      = tt-pacote.vl-movimento
                 pacproce.qt-procedimento      = tt-pacote.qt-movimento
                 pacproce.int-1                = tt-pacote.cd-ident-servico
                 pacproce.ds-observacao        = tt-pacote.ds-observacao-mov.
      end.
  end.
  else do:
      find first pacinsum no-lock
           where pacinsum.cd-pacote           = tt-pacote.cd-pacote
             and pacinsum.cd-unidade          = tt-pacote.cd-unidade
             and pacinsum.cd-prestador        = tt-pacote.cd-prestador
             and pacinsum.cd-modalidade       = tt-pacote.cd-modalidade
             and pacinsum.cd-plano            = tt-pacote.cd-plano
             and pacinsum.cd-tipo-plano       = tt-pacote.cd-tipo-plano
             and pacinsum.dt-inicio-vigencia  = tt-pacote.dt-inicio-vigencia
             and pacinsum.dt-limite           = tt-pacote.dt-limite 
             and pacinsum.cd-tipo-insumo      = tt-pacote.cd-grupo-movimento
             and pacinsum.cd-insumo           = tt-pacote.cd-movimento
             no-error.
             
      if not available pacinsum 
      then do:
          create pacinsum.
          assign  pacinsum.cd-pacote           = tt-pacote.cd-pacote
                  pacinsum.cd-unidade          = tt-pacote.cd-unidade
                  pacinsum.cd-prestador        = tt-pacote.cd-prestador
                  pacinsum.cd-modalidade       = tt-pacote.cd-modalidade
                  pacinsum.cd-plano            = tt-pacote.cd-plano
                  pacinsum.cd-tipo-plano       = tt-pacote.cd-tipo-plano
                  pacinsum.dt-inicio-vigencia  = tt-pacote.dt-inicio-vigencia
                  pacinsum.dt-limite           = tt-pacote.dt-limite 
                  pacinsum.cd-tipo-insumo      = tt-pacote.cd-grupo-movimento
                  pacinsum.cd-insumo           = tt-pacote.cd-movimento.
          
          assign pacinsum.vl-insumo            = tt-pacote.vl-movimento
                 pacinsum.qt-insumo            = tt-pacote.qt-movimento
                 pacinsum.int-1                = tt-pacote.cd-ident-servico
                 pacinsum.ds-observacao        = tt-pacote.ds-observacao-mov.
      end.
  end.
end.
