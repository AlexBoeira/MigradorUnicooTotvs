/* cgp/cg0110l.f */

/*--------------------- DEFINIR FRAMES DE ERROS E ACERTOS--------------------*/

def {1} shared frame f-lista
    wk-erros.cd-unidade     column-label "Unid"                      
    wk-erros.cd-prestador   column-label "Prestador"                 
    wk-erros.nm-prestador   column-label "Nome Prestador"            
    wk-erros.nome-abrev     column-label "Nome Abreviado"            
    wk-erros.in-tipo-pessoa column-label "Tp.Pes."                   
    wk-erros.nr-cgc-cpf     column-label "CGC/CPF" 
    with down no-box overlay width 282.
    
def {1} shared frame f-lista-1
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    with down no-box overlay width 282.

def {1} shared frame f-lista-2
    space(3)
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    wk-reg2.cd-vinculo     column-label "Cod.Vinc."
    wk-reg2.cd-especialid  column-label "Cod.Esp."
    with down no-box overlay width 282.

def {1} shared frame f-lista-3
    space(3)
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    with down no-box overlay width 282.

def {1} shared frame f-lista-4
    space(3)
    c-cd-unidade      column-label "Unid"
    c-cd-prestador    column-label "Prestador"
    c-nm-prestador    column-label "Nome Prestador"
    c-nome-abrev      column-label "Nome Abreviado"
    c-in-tipo-pessoa  column-label "Tp.Pes."
    c-cgc-cpf         column-label "CGC/CPF"
    with down no-box overlay width 282.

def {1} shared frame f-lista-acertos-2
    space(3)
    wk-reg2.cd-vinculo     column-label "Cod.Vinc."
    wk-reg2.cd-especialid  column-label "Cod.Esp."
    wk-reg2.lg-principal
    wk-reg2.lg-considera-qt-vinculo
    with down no-box overlay width 282.

def {1} shared frame f-lista-acertos-3
    space(3)
    wk-reg3.en-endereco    column-label "Endereco"
    wk-reg3.en-bairro      column-label "Bairro"
    wk-reg3.en-cep         column-label "CEP"
    wk-reg3.en-uf          column-label "UF"
    with down no-box overlay width 282.

def {1} shared frame f-lista-acertos-4
    space(3)
    wk-reg4.cod-instit         column-label "Instituicao"
    wk-reg4.cdn-nivel          column-label "Nivel"
    wk-reg4.lg-autoriz-divulga column-label "Aut. Divulgacao"
    wk-reg4.cd-seq-end         column-label "Seq. Endereco"
    with down no-box overlay width 282.
    
def {1} shared frame f-lista-acertos-5
    space(3)
    wk-reg5.divulga-obs format "x(250)"    column-label "Observacoes" 
    with down no-box overlay width 282.

/* ----------------------------------------------------------------- EOF --- */
