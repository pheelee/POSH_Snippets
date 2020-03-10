function Enable-NetLogonDebugLog
{
    Param(
        [int]$LogSize
    )
    [int]$CurrentLogSize = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name MaximumLogFileSize -ErrorAction SilentlyContinue | Select-Object -ExpandProperty MaximumLogFileSize
    if($CurrentLogSize -ne 0){
        New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name MaximumLogFileSizeBAK -PropertyType Dword -Value $CurrentLogSize -Force
    }
    if($LogSize -ne 0){
        New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name MaximumLogFileSize -PropertyType Dword -Value $LogSize -Force
    }
    . Nltest /DBFlag:2080FFFF
    Restart-Service Netlogon -Force
}

function Disable-NetLogonDebugLog
{
    [int]$OldLogSize = Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name MaximumLogFileSizeBAK -ErrorAction SilentlyContinue | Select-Object -ExpandProperty MaximumLogFileSizeBAK
    if($OldLogSize -ne 0){
        New-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name MaximumLogFileSize -PropertyType Dword -Value $OldLogSize -Force
    }else{
        Remove-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters -Name MaximumLogFileSize -ErrorAction SilentlyContinue
    }
    . Nltest /DBFlag:0x0
    Restart-Service Netlogon -Force
}
