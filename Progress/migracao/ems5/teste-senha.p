/* script para testar se usuario e senha sao validos*/

def new global shared var v_cod_usuar_corren
    as character
    format "x(12)"
    label "Usuario Corrente"
    column-label "Usuario Corrente"
    no-undo.

DEF VAR usuar_antes AS CHAR NO-UNDO.

DEF VAR valor-retorno AS CHAR NO-UNDO.

/**
 * Temporaria para tratar possiveis erros na tentativa de login.
 */
Def Temp-table tt_erros No-undo
    Field num-cod   As Integer
    Field desc-erro As Character Format "x(256)":U
	Field desc-arq  As Character.

/**
 * Variavel para tratar parametro de entrada.
 */
def var in-param-aux as char no-undo.
assign in-param-aux = session:param. 

usuar_antes = v_cod_usuar_corren.

run fnd\btb\btapi910za.p(input "migracao", /*USUARIO*/
                         input "migracao", /*SENHA */
                         output table tt_erros). 

for each tt_erros:
    message "Erro: " 
            String(tt_erros.num-cod) + " - ":U + 
            tt_erros.desc-erro 
            view-as alert-box information.
end.

MESSAGE "antes do login: " usuar_antes SKIP
        "depois do login: " v_cod_usuar_corren
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

MESSAGE SESSION:PARAMETER
    VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN men/men906zb.p(ENTRY(10,SESSION:PARAMETER),ENTRY(9,SESSION:PARAMETER),ENTRY(11,SESSION:PARAMETER),ENTRY(12,SESSION:PARAMETER),"","getProperty","","","access.security.active","",FALSE).
ASSIGN valor-retorno = RETURN-VALUE.

MESSAGE valor-retorno
   VIEW-AS ALERT-BOX INFO BUTTONS OK.
