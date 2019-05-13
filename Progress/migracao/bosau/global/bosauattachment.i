/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/*
    Copyright (c) 2007, DATASUL S/A. Todos os direitos reservados.
    
    Os Programas desta Aplica��o (que incluem tanto o software quanto a sua
    documenta��o) cont�m informa��es propriet�rias da DATASUL S/A; eles s�o
    licenciados de acordo com um contrato de licen�a contendo restri��es de uso e
    confidencialidade, e s�o tamb�m protegidos pela Lei 9609/98 e 9610/98,
    respectivamente Lei do Software e Lei dos Direitos Autorais. Engenharia
    reversa, descompila��o e desmontagem dos programas s�o proibidos. Nenhuma
    parte destes programas pode ser reproduzida ou transmitida de nenhuma forma e
    por nenhum meio, eletr�nico ou mec�nico, por motivo algum, sem a permiss�o
    escrita da DATASUL S/A.

*/

/******************************************************************************
    Programa .....: bosauattachment.i
    Data .........: 12/08/2013
    Sistema ......: Datasul 11
    Empresa ......: TOTVS
    Programador ..: Iago Passos
    Objetivo .....: Include que mantem os conceitos de anexos do GPS.
******************************************************************************/

define temp-table tmpAttachment       no-undo
    field cdd-anexo                   like anexo.cdd-anexo
    field nom-anexo                   like anexo.nom-anexo
    field dir-anexo                   as char 
    field tam-anexo                   as decimal
    field cdn-tip-anexo               like tip-anexo.cdn-tip-anexo
    field des-tip-anexo               as char
    field dat-ult-atualiz             like anexo.dat-ult-atualiz
    field cod-usuar-ult-atualiz       like anexo.cod-usuar-ult-atualiz
    index tmpAttachment1
          cdd-anexo.

define temp-table tmpPersonAttachment no-undo
    field cdd-anexo                   like anexo.cdd-anexo
    field idi-pessoa                  like anexo-pessoa.idi-pessoa.

define temp-table tmpTaskAttachment   no-undo
    field cdd-anexo                   like anexo.cdd-anexo
    field cdd-tar-audit               like anexo-tar-audit.cdd-tar-audit.

define temp-table tmpAttachmentMD     no-undo
    field cdd_anexo                   like anexo.cdd-anexo
    field nom_anexo                   like anexo.nom-anexo
    field dir_anexo                   as char 
    field tam_anexo                   as decimal
    field cdn_tip_anexo               as decimal
    field cdn_tip_anexo_concat        as character 
    field log_gravado_banco           as logical
    field cod_usuar_ult_atualiz       like anexo.cod-usuar-ult-atualiz
    index tmpAttachment1
          cdd_anexo.
		  
define temp-table tmpDeleteAttachment no-undo
    field cdd-anexo                   like anexo.cdd-anexo.
