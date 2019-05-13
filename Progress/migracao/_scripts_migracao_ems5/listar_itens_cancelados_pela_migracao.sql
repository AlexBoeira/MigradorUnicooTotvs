-- listar mensagens do tipo 'CA', que sao ignorados pela migracao
select ci.*
from ti_controle_integracao ci
where ci.cdsituacao =  'CA';
