Get-NetTCPConnection -remoteport 1433 | group State, OwningProcess | Select Count,RemotePort,@{L='State';E={$_.Name.Split(",")[0]}}, @{L='Process';E={Get-Process -Id ($_.Nam
e.Split(",")[1].Trim()) | Select -Expand ProcessName}}
