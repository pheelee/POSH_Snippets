Get-NetTCPConnection -LocalPort 8039,8040 -State Established | Select -Unique -Property RemoteAddress, LocalPort | 
Select -Property @{L="Hostname";E={[System.Net.Dns]::GetHostByAddress($_.RemoteAddress).HostName}}, LocalPort
