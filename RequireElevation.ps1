#Requires -RunAsAdministrator
if($psISE -and (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator'))){
    Write-Host -ForegroundColor Red "This script must be run in an elevated shell (Run as Admin)"
    return
}
