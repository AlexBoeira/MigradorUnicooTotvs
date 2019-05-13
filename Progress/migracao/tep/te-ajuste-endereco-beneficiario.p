/* OBJETIVO: percorrer todos os beneficiarios do GPS e sincronizar o endereco principal da sua pessoa nos campos da tabela USUARIO.
             se a pessoa nao tiver endereco, carregara com endereco principal do seu titular.
*/
DEF BUFFER b-usuario FOR usuario.
DEF BUFFER b-endereco FOR endereco.
ETIME(TRUE).
DEF VAR ix-alterados-aux AS INT NO-UNDO.

FOR EACH usuario NO-LOCK /*WHERE usuario.cd-modalidade = 20 AND usuario.nr-proposta = 938 AND usuario.cd-usuario = 8*/:
    FIND FIRST endereco WHERE endereco.id-pessoa = usuario.id-pessoa
                          AND endereco.lg-principal NO-LOCK NO-ERROR.
    /* se nao possui endereco principal mas possui outro registro, transforma em principal */
    IF NOT AVAIL endereco
    THEN DO:
           FIND FIRST endereco WHERE endereco.id-pessoa = usuario.id-pessoa exclusive-LOCK NO-ERROR.
           IF AVAIL endereco THEN ASSIGN endereco.lg-principal = YES.
    END.

    /* se for dependente e nao possui endereco, carregar com endereco do seu titular.*/
    IF NOT AVAIL endereco
    AND usuario.cd-usuario <> usuario.cd-titular
    THEN DO:
           FIND FIRST b-usuario NO-LOCK
                WHERE b-usuario.cd-modalidade = usuario.cd-modalidade
                  AND b-usuario.nr-proposta   = usuario.nr-proposta
                  AND b-usuario.cd-usuario    = usuario.cd-titular NO-ERROR.
           IF AVAIL b-usuario
           THEN DO:
                    /* ler endereco principal do seu responsavel para criar endereco do dependente */
                    FIND FIRST b-endereco WHERE b-endereco.id-pessoa = b-usuario.id-pessoa
                                            AND b-endereco.lg-principal NO-LOCK NO-ERROR.
                    IF AVAIL b-endereco
                    THEN DO:
                           CREATE endereco.
                           BUFFER-COPY b-endereco EXCEPT id-pessoa id-endereco TO endereco.
                           ASSIGN endereco.id-pessoa = usuario.id-pessoa.
                           repeat:
                              assign endereco.id-endereco = next-value(seq-endereco) no-error.
                              validate endereco.
                              if not error-status:error
                              then leave.
                              process events.
                           end.
                    END.
           END.
    END.

    IF AVAIL endereco
    THEN FOR FIRST b-usuario EXCLUSIVE-LOCK WHERE ROWID(b-usuario) = ROWID(usuario):
            /* Se encontrou o endereco, atualiza o mesmo na tabela do usuario. passar aqui tanto para dependentes como titulares*/
                 assign usuario.en-rua    = endereco.ds-endereco
                        usuario.en-bairro = endereco.ds-bairro
                        usuario.en-cep    = endereco.cd-cep
                        usuario.en-uf     = endereco.cd-uf
                        usuario.cd-cidade = endereco.cd-cidade
                        usuario.int-14    = endereco.int-3
                        usuario.int-17    = endereco.in-tipo-endereco
                        ix-alterados-aux = ix-alterados-aux + 1.
         END.
END.

MESSAGE "concluido." ix-alterados-aux " registros alterados em " ETIME / 1000 " segundos"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

