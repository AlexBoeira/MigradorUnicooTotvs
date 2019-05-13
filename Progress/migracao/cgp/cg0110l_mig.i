/*****************************************************************************
*      Programa .....: cg0110l.i                                             *
*      Programador ..: Janete Formigheri                                     *
*      Objetivo .....: Variaveis e Temp-Tables shared utilizadas nos progs:  *
*                      cg0110l.p e cg0111l.p                                 *
*****************************************************************************/

/*------------------------------- CAMPOS GERAIS -----------------------------*/

def var tp-anterior                         as int                      no-undo.
def var tp-ant-unid                         as int                      no-undo.
def {1} shared stream s-import.
def {1} shared stream s-export.
def {1} shared stream s-erro.
def {1} shared var nm-arquivo-importar      as char format "x(30)"      no-undo.
def {1} shared var nm-arquivo-serious-gerar as char format "x(30)"      no-undo.
def {1} shared var cd-unidade-aux           like unimed.cd-unimed       no-undo.
def {1} shared var cd-tab-urge-aux          like preserv.cd-tab-urge    no-undo.
def {1} shared var lg-calc-irrf-aux         as log                      no-undo.
def {1} shared var lg-cons-vinc-prest-aux   as log                      no-undo.
def {1} shared var lg-erro                  as logical initial no       no-undo.
def {1} shared var lg-erro-geral            as logical initial no       no-undo.
def {1} shared var tt-prest-lidos           as int                      no-undo.
def {1} shared var tt-prest-gravados        as int                      no-undo.
def {1} shared var tt-regs-gravados         as int                      no-undo.
def {1} shared var tt-prest-erros           as int                      no-undo.
def {1} shared var tt-prest-aviso           as int                      no-undo.
def {1} shared var in-indice-ir-aux         as int                      no-undo.
def {1} shared var cd-motivo-cancel-aux     like preserv.cd-motivo-cancel no-undo.
def {1} shared var in-movto-aux             as int format "9"             no-undo.
def {1} shared var lg-codigo-ptu-aux        as log label "Codigo do Prestador"
        view-as radio-set radio-buttons "Assumir do arquivo de importacao",yes,
                                        "Geracao automatica",no init yes  no-undo.

/*--------------------- CAMPOS DO REGISTRO 01 - PRESERV ---------------------*/
def {1} shared var c-dados                     as char format "x(1023)"               no-undo.
def {1} shared var c-cd-unidade                like preserv.cd-unidade                no-undo.
def {1} shared var c-nm-prestador              like preserv.nm-prestador              no-undo.
def {1} shared var c-nm-fantasia               like preserv.char-20                   no-undo.
def {1} shared var c-nome-abrev                like preserv.nome-abrev                no-undo.
def {1} shared var c-cd-grupo-prestador        like preserv.cd-grupo-prestador        no-undo.
def {1} shared var c-in-tipo-pessoa            like preserv.in-tipo-pessoa            no-undo.
def {1} shared var c-lg-medico                 like preserv.lg-medico                 no-undo.
def {1} shared var c-lg-cooperado              like preserv.lg-cooperado              no-undo.
def {1} shared var c-cd-unidade-seccional      like preserv.cd-unidade-seccional      no-undo.
def {1} shared var c-cd-conselho               like preserv.cd-conselho               no-undo.
def {1} shared var c-cd-uf-conselho            like preserv.cd-uf-conselho            no-undo.
def {1} shared var c-nr-registro               like preserv.nr-registro               no-undo.
def {1} shared var c-cd-magnus                 like preserv.cd-contratante            no-undo.
def {1} shared var c-en-rua                    like preserv.en-rua                    no-undo.
def {1} shared var c-en-bairro                 like preserv.en-bairro                 no-undo.
def {1} shared var c-cd-cidade                 like preserv.cd-cidade                 no-undo.
def {1} shared var c-en-cep                    like preserv.en-cep                    no-undo.
def {1} shared var c-en-uf                     like preserv.en-uf                     no-undo.
def {1} shared var c-nr-telefone               like preserv.nr-telefone               no-undo.
def {1} shared var c-cd-situacao               like preserv.cd-situacao               no-undo.
def {1} shared var c-dt-inclusao               like preserv.dt-inclusao               no-undo.
def {1} shared var c-dt-exclusao               like preserv.dt-exclusao               no-undo.
def {1} shared var c-nr-pis-pasep              as dec format "zzzzzzzzzz9"            no-undo.
def {1} shared var c-lg-sexo                   like preserv.lg-sexo                   no-undo.
def {1} shared var c-dt-nascimento             like preserv.dt-nascimento             no-undo.
def {1} shared var c-cd-insc-unimed            like preserv.cd-insc-unimed            no-undo.
def {1} shared var c-cd-situac-sindic          like preserv.cd-situac-sindic          no-undo.
def {1} shared var c-qt-produtividade          like preserv.qt-produtividade          no-undo.
def {1} shared var c-lg-alvara                 like preserv.lg-alvara                 no-undo.
def {1} shared var c-lg-registro               like preserv.lg-registro               no-undo.
def {1} shared var c-lg-diploma                like preserv.lg-diploma                no-undo.
def {1} shared var c-cd-esp-resid              like preserv.cd-esp-resid              no-undo.
def {1} shared var c-cd-esp-titulo             like preserv.cd-esp-titulo             no-undo.
def {1} shared var c-lg-malote                 like preserv.lg-malote                 no-undo.
def {1} shared var c-dt-atualizacao            like preserv.dt-atualizacao            no-undo.
def {1} shared var c-cd-userid                 like preserv.cd-userid                 no-undo. 
def {1} shared var c-nr-ramal                  like preserv.nr-ramal                  no-undo.
def {1} shared var c-cd-prestador              like preserv.cd-prestador              no-undo.
def {1} shared var c-cgc-cpf                   as   char format "x(19)"               no-undo.
def {1} shared var nr-cgc-dzemit-aux           like preserv.nr-cgc-cpf                no-undo.
def {1} shared var c-lg-vinc-empreg            like preserv.lg-vinc-empreg            no-undo.
def {1} shared var c-nr-ult-inss               like preserv.nr-ult-inss               no-undo.
def {1} shared var c-vl-base-irrf              like preserv.vl-base-irrf              no-undo.
def {1} shared var c-lg-representa-unidade     like preserv.lg-representa-unidade     no-undo.
def {1} shared var c-cd-tab-urge               like preserv.cd-tab-urge               no-undo.
def {1} shared var c-lg-divisao-honorario      like preserv.lg-divisao-honorario      no-undo.
def {1} shared var c-lg-recolhe-inss           like preserv.lg-recolhe-inss           no-undo.
def {1} shared var c-nr-inscricao-inss         like preserv.nr-inscricao-inss         no-undo.
def {1} shared var c-lg-recolhe-participa      like preserv.lg-recolhe-participacao   no-undo.
def {1} shared var c-ds-observacao               as char                              no-undo.
def {1} shared var c-calc-irrf                 like preserv.lg-calcula-ir             no-undo.
def {1} shared var c-incidir-irrf              like preserv.in-ir-atos-cooperados     no-undo.
def {1} shared var c-nr-ult-irrf               like preserv.nr-ult-irrf               no-undo.
def {1} shared var c-lg-calcula-adto           like preserv.lg-calcula-adto           no-undo.
def {1} shared var c-dt-calculo-adto           like preserv.dt-calculo-adto           no-undo.
def {1} shared var c-nr-dependentes            like preserv.nr-dependentes            no-undo.
def {1} shared var c-lg-pagamento-rh           like preserv.lg-pagamento-rh           no-undo.
def {1} shared var c-nm-email                  like preserv.nm-email                  no-undo.
def {1} shared var c-cd-tipo-fluxo             like preserv.cd-tipo-fluxo             no-undo.
def {1} shared var c-cd-imposto                like preserv.cd-imposto                no-undo.
def {1} shared var c-cd-classificacao-imposto  like preserv.cd-classificacao-imposto  no-undo.
def {1} shared var c-calc-cofins               like preserv.lg-cofins                 no-undo.
def {1} shared var c-calc-pispasep             like preserv.lg-pis-pasep              no-undo.
def {1} shared var c-calc-csll                 like preserv.lg-csll                   no-undo.
def {1} shared var c-cd-cofins                 like preserv.cd-imposto-cofins         no-undo.
def {1} shared var c-cd-classificacao-cofins   like preserv.cd-clas-imposto-cofins    no-undo.
def {1} shared var c-cd-pispasep               like preserv.cd-imposto-cofins         no-undo.
def {1} shared var c-cd-classificacao-pispasep like preserv.cd-clas-imposto-cofins    no-undo.
def {1} shared var c-cd-csll                   like preserv.cd-imposto-cofins         no-undo.
def {1} shared var c-cd-classificacao-csll     like preserv.cd-clas-imposto-cofins    no-undo.
def {1} shared var c-cd-inss                   like preserv.cd-imposto-inss           no-undo.
def {1} shared var c-cd-classificacao-inss     like preserv.cd-classificacao-imp-inss no-undo.
def {1} shared var c-calc-iss                  like preserv.lg-calcula-iss            no-undo.
def {1} shared var c-deduz-iss                 like preserv.lg-deduz-iss              no-undo.
def {1} shared var c-cd-iss                    like preserv.cd-imposto-iss            no-undo.
def {1} shared var c-cd-classificacao-iss      like preserv.cd-classificacao-imp-iss  no-undo.
def {1} shared var c-nr-dias-validade          like preserv.nr-dias-validade          no-undo.
def {1} shared var c-portador                  like preserv.portador                  no-undo.
def {1} shared var c-modalidade                like preserv.modalidade                no-undo.
def {1} shared var c-cd-banco                  like preserv.cod-banco                 no-undo.
def {1} shared var c-agencia                   like preserv.agencia                   no-undo.
def {1} shared var c-conta-corren              like preserv.conta-corren              no-undo.
def {1} shared var c-forma-pagto                 as char format "x(3)"                no-undo.
def {1} shared var c-conta-corren-digito         as char format "x(2)"                no-undo.
def {1} shared var c-agencia-digito              as char format "x(2)"                no-undo.
def {1} shared var c-calc-imposto-unico        like preserv.lg-imposto-unico          no-undo.
def {1} shared var c-cd-imposto-unico          like preserv.cd-imposto-unico          no-undo.
def {1} shared var c-cd-clas-imposto-unico     like preserv.cd-clas-imposto-unico     no-undo.
def {1} shared var c-retem-proc                  as char format "x(1)"                no-undo.
def {1} shared var c-retem-insu                  as char format "x(1)"                no-undo.
def {1} shared var c-cd-tipo-classif-estab       as char                              no-undo.
def {1} shared var c-cd-cnes                     as int  format "9999999"             no-undo.
def {1} shared var c-nm-diretor-tecnico          as char                              no-undo.
def {1} shared var c-nr-crm-dir-tecnico          as char format "x(8)"                no-undo.
def {1} shared var c-tp-disponibilidade          as int format "9"                    no-undo.  
def {1} shared var c-cd-registro-ans             as int                               no-undo.
def {1} shared var c-dt-inicio-contratual        as date format 99/99/9999            no-undo.
def {1} shared var c-lg-cooperativa              like preserv.lg-cooperativa          no-undo.
def {1} shared var c-ds-natureza-doc-ident       as char                              no-undo.
def {1} shared var c-nr-doc-ident                as char                              no-undo.
def {1} shared var c-ds-orgao-emissor-ident      as char                              no-undo.
def {1} shared var c-nm-pais-emissor-ident       as char                              no-undo.
def {1} shared var c-uf-emissor-ident            as char                              no-undo.
def {1} shared var c-dt-emissao-doc-ident        as date format 99/99/9999            no-undo.
def {1} shared var c-ds-nacionalidade            as char                              no-undo.
def {1} shared var c-nr-ver-tra                  as int format "99"                   no-undo.
def {1} shared var lg-layout-serious-aux         like pipresta.lg-layout-serious      no-undo.
def {1} shared var c-lg-acid-trab                like preserv.log-4                   no-undo.
def {1} shared var c-lg-tab-propria              like preserv.log-5                   no-undo.
def {1} shared var c-in-perfil-assistencial      like preserv.int-11                  no-undo.
def {1} shared var c-in-tipo-prod-atende         like preserv.int-12                  no-undo.
def {1} shared var c-lg-guia-medico-aux          like preserv.log-6                   no-undo.
def {1} shared var c-ds-end-complementar         like preserv.char-15                 no-undo.
def {1} shared var c-cd-conselho-dir-tec         like preserv.char-21                 no-undo.
def {1} shared var c-nr-conselho-dir-tec         like preserv.char-23                 no-undo.
def {1} shared var c-uf-conselho-dir-tec         like preserv.char-22                 no-undo.
def {1} shared var c-tp-rede                     like preserv.int-15                  no-undo.

def {1} shared var c-nr-telefone-3               like preserv.char-16                 no-undo.
def {1} shared var c-nr-ramal-3                  like preserv.char-17                 no-undo.
def {1} shared var c-nr-telefone-4               like preserv.char-18                 no-undo.
def {1} shared var c-nr-ramal-4                  like preserv.char-19                 no-undo.
def {1} shared var c-lg-calcula-iss              like preserv.lg-calcula-iss          no-undo.
def {1} shared var c-lg-calcula-ir               like preserv.lg-calcula-ir           no-undo.
def {1} shared var c-lg-pis-pasep                like preserv.lg-pis-pasep            no-undo.
def {1} shared var c-lg-cofins                   like preserv.lg-cofins               no-undo.
def {1} shared var c-lg-csll                     like preserv.lg-csll                 no-undo.
def {1} shared var c-lg-imposto-unico            like preserv.lg-imposto-unico        no-undo.
def {1} shared var c-nr-leitos-hosp-dia          like preserv.int-20                  no-undo.
def {1} shared var c-lg-notivisa                 like preserv.log-11                  no-undo.
def {1} shared var c-lg-qualiss                  like preserv.log-12                  no-undo.
def {1} shared var c-nr-registro1                as dec                               no-undo.
def {1} shared var c-nr-registro2                as dec                               no-undo.
def {1} shared var c-nr2-registro1               as dec                               no-undo.   
def {1} shared var c-nr2-registro2               as dec                               no-undo. 

def {1} shared var c-nm-end-web                like preserv.char-27                   no-undo.

def {1} shared var c-lg-prestador-acreditado   like preserv.log-9                     no-undo.
def {1} shared var c-cd-instituicao-acreditadora like preserv.char-24                 no-undo.
def {1} shared var c-cd-nivel-acreditacao      like preserv.int-17                    no-undo.

def {1} shared var in-pos-graduacao-aux          as char format "x(1)"                no-undo.       
def {1} shared var tp-pos-graduacao-aux          as int  format "9"                   no-undo.       
def {1} shared var in-particp-prog-cert-aux      as char format "x(1)"                no-undo.       
                                                 
def {1} shared var lg-publica-ans-aux          like preserv.log-15                    no-undo.  
def {1} shared var lg-indic-residencia-aux     like preserv.log-18                    no-undo.  
def {1} shared var lg-login-wsd-tiss-aux       like preserv.log-16                    no-undo.
def {1} shared var lg-cadu-aux                 like preserv.log-17                    no-undo.
def {1} shared var c-lg-sexo-aux                 as logical                           no-undo.
def {1} shared var c-in-tipo-especialidade-aux   as integer                           no-undo.

/*--------------------- CAMPOS DO REGISTRO 02 - PREVIESP --------------------*/      
def {1} shared var c-cd-vinculo                like previesp.cd-vinculo               no-undo.
def {1} shared var c-cd-especialid             like previesp.cd-especialid            no-undo.
def {1} shared var c-lg-principal              like previesp.lg-principal             no-undo.
def {1} shared var c-lg-considera-qt-vinculo   like previesp.lg-considera-qt-vinculo  no-undo.

def {1} shared temp-table wk-reg2                                                     no-undo
    field cd-vinculo                    like previesp.cd-vinculo
    field cd-especialid                 like previesp.cd-especialid
    field lg-principal                  like previesp.lg-principal
    field lg-considera-qt-vinculo       like previesp.lg-considera-qt-vinculo
    field cd-registro-espec             like previesp.cd-registro-especialidade
    field cd-tipo-contratualizacao      like previesp.in-contratualizacao
    field lg-rce                        like previesp.log-4
    field cd-registro-espec-2           like previesp.dec-1
    field in-tipo-especialidade         like previesp.int-2
    field cd-tit-cert-esp               like previesp.int-3
    index wk1 is primary
          cd-vinculo   
          cd-especialid.

/*--------------------- CAMPOS DO REGISTRO 03 - ENDPRES ---------------------*/
def {1} shared temp-table wk-reg3                                      no-undo
    field nr-seq-endereco                like endpres.nr-seq-endereco
    field en-endereco                    like endpres.en-endereco
    field en-complemento                   as char format "x(15)"
    field en-bairro                      like endpres.en-bairro
    field cd-cidade                      like endpres.cd-cidade
    field en-cep                         like endpres.en-cep
    field en-uf                          like endpres.en-uf
    field nr-fone                        like endpres.nr-fone
    field nr-ramal                       like endpres.nr-ramal
    field hr-man-ent                     like endpres.hr-man-ent
    field hr-man-sai                     like endpres.hr-man-sai
    field hr-tar-ent                     like endpres.hr-tar-ent
    field hr-tar-sai                     like endpres.hr-tar-sai
    field hr-man-ent-segunda             like endpres.hr-man-ent-segunda 
    field hr-man-sai-segunda             like endpres.hr-man-sai-segunda 
    field hr-tar-ent-segunda             like endpres.hr-tar-ent-segunda 
    field hr-tar-sai-segunda             like endpres.hr-tar-sai-segunda 
    field hr-man-ent-terca               like endpres.hr-man-ent-terca   
    field hr-man-sai-terca               like endpres.hr-man-sai-terca   
    field hr-tar-ent-terca               like endpres.hr-tar-ent-terca   
    field hr-tar-sai-terca               like endpres.hr-tar-sai-terca   
    field hr-man-ent-quarta              like endpres.hr-man-ent-quarta  
    field hr-man-sai-quarta              like endpres.hr-man-sai-quarta  
    field hr-tar-ent-quarta              like endpres.hr-tar-ent-quarta  
    field hr-tar-sai-quarta              like endpres.hr-tar-sai-quarta  
    field hr-man-ent-quinta              like endpres.hr-man-ent-quinta  
    field hr-man-sai-quinta              like endpres.hr-man-sai-quinta  
    field hr-tar-ent-quinta              like endpres.hr-tar-ent-quinta  
    field hr-tar-sai-quinta              like endpres.hr-tar-sai-quinta  
    field hr-man-ent-sexta               like endpres.hr-man-ent-sexta   
    field hr-man-sai-sexta               like endpres.hr-man-sai-sexta   
    field hr-tar-ent-sexta               like endpres.hr-tar-ent-sexta   
    field hr-tar-sai-sexta               like endpres.hr-tar-sai-sexta   
    field hr-man-ent-sabado              like endpres.hr-man-ent-sabado  
    field hr-man-sai-sabado              like endpres.hr-man-sai-sabado  
    field hr-tar-ent-sabado              like endpres.hr-tar-ent-sabado  
    field hr-tar-sai-sabado              like endpres.hr-tar-sai-sabado  
    field hr-man-ent-domingo             like endpres.hr-man-ent-domingo 
    field hr-man-sai-domingo             like endpres.hr-man-sai-domingo 
    field hr-tar-ent-domingo             like endpres.hr-tar-ent-domingo 
    field hr-tar-sai-domingo             like endpres.hr-tar-sai-domingo 
    field lg-dias-trab                   like endpres.lg-dias-trab
    field lg-malote                      like endpres.lg-malote
    field lg-recebe-corresp              like endpres.lg-recebe-corresp
    field lg-tipo-endereco               like endpres.lg-tipo-endereco
    field in-tipo-endereco               as int format "9"
    field cd-cnes                        as int format "9999999"
    field nr-leitos-tot                  as char format "x(06)"
    field nr-leitos-contrat              as char format "x(06)"
    field nr-leitos-psiquiat             as char format "x(06)"
    field nr-uti-adulto                  as char format "x(06)"
    field nr-uti-neonatal                as char format "x(06)"
    field nr-uti-neo-interm-neo          as char format "x(06)"
    field nr-uti-pediatria               as char format "x(06)"
    field ds-complementar                like preserv.char-15
    field nr-cgc-cpf                     like preserv.nr-cgc-cpf
	field lg-filial             	     like endpres.log-1
    field nr-leitos-hosp-dia             as int format "999999"
    field nm-end-web                     like endpres.nm-end-web
    field nr-leitos-tot-clin-n-uti       as int format "999999"
    field nr-leitos-tot-cirur-n-uti      as int format "999999"
    field nr-leito-tot-obst-n-uti        as int format "999999"
    field nr-leitos-tot-ped-n-uti        as int format "999999"
    field nr-leitos-tot-psic-n-uti       as int format "999999"
    field nm-latitue                     as char format "x(20)"
    field nm-longitude                   as char format "x(20)"
    field nr-uti-neo-interm              as char format "x(06)"
    index wk1 is primary
          nr-seq-endereco.

/*--------------------- CAMPOS DO REGISTRO 04 - PREST-INST ------------------*/
def {1} shared temp-table wk-reg4                                                     no-undo
    field cod-instit              like prest-inst.cod-instit
    field cdn-nivel               like prest-inst.cdn-nivel
    field lg-autoriz-divulga      like prest-inst.log-livre-1
    field cd-seq-end              like prest-inst.num-livre-1.

/*--------------------- CAMPOS DO REGISTRO 05 - PREST-OBS  ------------------*/
def {1} shared temp-table wk-reg5                                                     no-undo
    field divulga-obs             like prestdor-obs.des-obs.


/*--------------------- CAMPOS DO REGISTRO 06 - PRESTADOR SUBSTITUTO  ------------------*/
def {1} shared var c-cd-unidade-subst         like preserv.cd-unidade                no-undo. /*manter campos para nao dar erro de compilacao no lacg037.p*/
def {1} shared var c-cd-prest-subst           like preserv.cd-prestador              no-undo.
def {1} shared var c-dt-inicio-subst          like preserv.dt-inclusao               no-undo.

def {1} shared temp-table wk-reg6                                                     no-undo
    field c-cd-unidade-subst      like preserv.cd-unidade                
    field c-cd-prest-subst        like preserv.cd-prestador              
    field c-dt-inicio-subst       like preserv.dt-inclusao.              
     
def {1} shared var c-cd-motivo-exclusao  like preserv.cd-motivo-cancel.

/*----------------------- DEFINIR TEMP-TABLE DE ERROS -----------------------*/
def {1} shared temp-table wk-erros                                     no-undo
    field cd-tipo-erro   as char format "x(01)"
    field cd-tipo-regs   as int
    field ds-desc        as char format "x(120)"
    field cd-unidade     like preserv.cd-unidade
    field cd-prestador   like preserv.cd-prestador
    field nm-prestador   like preserv.nm-prestador
    field nome-abrev     like preserv.nome-abrev
    field in-tipo-pessoa like preserv.in-tipo-pessoa
    field nr-cgc-cpf     like preserv.nr-cgc-cpf
    index wk-erros1 is primary
          cd-unidade
          cd-prestador
    index wk-erros2
          cd-tipo-regs.

/* ----------------------------------- DEFINIR TEMP-TABLE PARA IMPRESSAO --- */
def {1} shared temp-table tmp-preserv no-undo
    field in-movto                    as int
    field cd-unidade                  like preserv.cd-unidade
    field cd-prestador                like preserv.cd-prestador
    field nm-prestador                like preserv.nm-prestador
    field nome-abrev                  like preserv.nome-abrev
    field in-tipo-pessoa              like preserv.in-tipo-pessoa
    field nr-cgc-cpf                  like preserv.nr-cgc-cpf
    index tmp-prest1 is primary
          cd-unidade
          cd-prestador.

def {1} shared temp-table tmp-previesp no-undo
    field cd-unidade                   like previesp.cd-unidade
    field cd-prestador                 like previesp.cd-prestador
    field cd-vinculo                   like previesp.cd-vinculo
    field cd-especialid                like previesp.cd-especialid
    field lg-principal                 like previesp.lg-principal
    field lg-considera-qt-vinculo      like previesp.lg-considera-qt-vinculo
    field cd-registro-especialidade    like previesp.cd-registro-especialidade
    field dec-1                        like previesp.dec-1                    
    field int-2                        like previesp.int-2
    field int-3                        like previesp.int-3
    index tmp-prev1 is primary
          cd-unidade
          cd-prestador
          cd-vinculo    
          cd-especialid.

def {1} shared temp-table tmp-endpres no-undo
    field cd-unidade                  like endpres.cd-unidade
    field cd-prestador                like endpres.cd-prestador
    field en-endereco                 like endpres.en-endereco
    field en-complemento                as char format "x(15)"
    field en-bairro                   like endpres.en-bairro
    field en-cep                      like endpres.en-cep
    field en-uf                       like endpres.en-uf
    index tmp-end1 is primary
          cd-unidade
          cd-prestador.

def {1} shared temp-table tmp-prest-inst no-undo
    field cd-unidade                  like prest-inst.cd-unidade
    field cd-prestador                like prest-inst.cd-prestador
    field cod-instit                  like prest-inst.cod-instit
    field cdn-nivel                   like prest-inst.cdn-nivel
    field lg-autoriz-divulga          like prest-inst.log-livre-1
    field cd-seq-end                  like prest-inst.num-livre-1
    index tmp-inst1 is primary
          cd-unidade
          cd-prestador.

def {1} shared temp-table tmp-prestdor-obs no-undo
    field cd-unidade                  like prestdor-obs.cdn-unid-prestdor
    field cd-prestador                like prestdor-obs.cdn-prestdor
    field des-obs                     like prestdor-obs.des-obs
    index tmp-inst1 is primary
          cd-unidade
          cd-prestador.

/* -----------------------DEFINIR TEMP-TABLE PARA PRESTADOR x AREA ATUACAO --- */

def {1} shared temp-table temp-prestdor-x-area-atuac no-undo
    field cd-cgc                      as char format "x(15)"
    field nm-prestador                as char format "x(40)"
    field cdn-area-atuac              like prest-area-atu.cdn-area-atuac
    field log-certif                  like prest-area-atu.log-certif
    field cd-registro-1               as dec
    field cd-registro-2               as dec
    index temp-prest-area-atuac1 is primary
          cd-cgc
          nm-prestador
          cdn-area-atuac.

/* ----------------------------------------------------------------- EOF --- */
