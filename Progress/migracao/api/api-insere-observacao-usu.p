def var ds-obs-aux  as char no-undo.
def var ds-obs-aux2 as char no-undo.
def var dif-car-aux as int  no-undo.

def buffer b-usuario for usuario.

for each import-bnfciar fields (cd-carteira-antiga cod-livre-2)
   where import-bnfciar.cod-livre-2 <> ""
     and import-bnfciar.cod-livre-2 <> ? no-lock,
    
    /* --- DEPENDENTE ------------------------------------------------------------------ */
    first usuario fields (cd-modalidade nr-ter-adesao cd-usuario ds-observacao)
    where usuario.cd-carteira-antiga = import-bnfciar.cd-carteira-antiga exclusive-lock, 
        
    /* --- TITULAR --------------------------------------------------------------------- */
    first b-usuario fields (cd-modalidade nr-ter-adesao cd-usuario ds-observacao)
    where b-usuario.cd-carteira-antiga = int(import-bnfciar.cod-livre-2) exclusive-lock:

    /* --------------------------------------------------------------------------------- */
    assign ds-obs-aux = chr(13) + "Titular: Mod.:" + string(b-usuario.cd-modalidade) 
                                + "/Termo:"        + string(b-usuario.nr-ter-adesao) 
                                + "/Usu.:"         + string(b-usuario.cd-usuario)
           usuario.ds-observacao[2] = ds-obs-aux.

    /* ---------------------------------------------------------------------------------- */
    assign ds-obs-aux2 = trim(b-usuario.ds-observacao[1] + b-usuario.ds-observacao[2] + b-usuario.ds-observacao[3])
                       + chr(13) 
                       + "Dep: Mod.:" + string(usuario.cd-modalidade) 
                       + "/Termo:"    + string(usuario.nr-ter-adesao) 
                       + "/Usu.:"     + string(usuario.cd-usuario).

    if length(ds-obs-aux2) < 228
    then assign b-usuario.ds-observacao[1] = substring(ds-obs-aux2,1,76)
                b-usuario.ds-observacao[2] = substring(ds-obs-aux2,77,76)
                b-usuario.ds-observacao[3] = substring(ds-obs-aux2,153,76).
end.
