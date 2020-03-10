Get-NetTCPConnection | Group-Object -Property LocalPort | Sort-Object -Property Count -Descending | Select Name, Count -First 10
