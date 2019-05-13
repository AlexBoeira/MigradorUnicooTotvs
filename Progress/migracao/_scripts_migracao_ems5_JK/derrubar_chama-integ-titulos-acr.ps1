
 $processo = Get-CimInstance -ClassName Win32_PRocess -Filter "CommandLine LIKE '%chama-integ-titulos-acr.p%'"
 $processo | Invoke-WmiMethod -Name Terminate
