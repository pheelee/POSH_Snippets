 while(1){ "{0}:{1} -> {2}" -f "server","0",(Test-NetConnection -Port 7001 -ComputerName server | Select -Expand TcpTestSucceeded);Start-Sleep 1 }
