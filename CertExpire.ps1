Get-ChildItem Cert:\LocalMachine\My -Recurse | Where-Object {$_.GetType().Name -eq "X509Certificate2"} | Where-Object {($_.NotAfter - (Get-Date)).Days -lt 10 }  | Select Subject, NotAfter, Thumbprint
