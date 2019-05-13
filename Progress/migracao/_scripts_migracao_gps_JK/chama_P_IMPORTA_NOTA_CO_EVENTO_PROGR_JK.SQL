set echo on
WHENEVER SQLERROR EXIT SQL.SQLCODE
begin
	pck_unicoogps.p_importa_nota_co_evento_progr (&1, /*pPeriodo (AAAAMM): Informar o período do UNICOO para buscar os eventos de Coparticipação e Custo Operacional*/
												  &2, /*pEVENTO_FM: Informar o Evento de Coparticipação do TOTVS*/
												  &3, /*pEVENTO-CO: Informar o Evento de Custo Operacional do TOTVS*/
												  '&4', /*pOBS_EVENTO_FM: Observações para registrar os Eventos de Coparticipação*/
												  '&5'  /*pOBS_EVENTO_CO: Observações para registrar os Eventos de Custo Operacional*/
												  );
  commit;							
end;
/
