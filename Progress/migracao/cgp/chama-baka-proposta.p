repeat:
    PROCESS events.
    RUN cgp/baka-proposta.p(input 10,
                            input 10,
                            input 9,
                            input 9,
                            input 9,
                            input 9).

    PAUSE(10).

    /*IF NOT can-find(FIRST modalid
                    WHERE can-find(FIRST propost
                                   WHERE propost.cd-modalidade  = modalid.cd-modalidade
                                     AND propost.cd-contratante <> 0
                                     AND propost.nr-ter-adesao  = 0))
    THEN LEAVE.*/

END.

MESSAGE "concluido!"
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

