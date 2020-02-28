$ip = "192.168.3.5"
$gw = "192.168.3.254"
$dns = "192.168.3.254"

$hostname = "D001"

#$adapter = (Get-NetAdapter)[0]
#$adapter | New-NetIPAddress -IPAddress $ip -DefaultGateway $gw -PrefixLength 24
#Set-DnsClientServerAddress -InterfaceAlias $adapter.ifAlias -ServerAddresses $dns

# Install-Module NetworkingDSC,ComputerManagementDSC -Force

Configuration BaseConfig {
    Import-DscResource -Module NetworkingDSC
    Import-DscResource -Module ComputerManagementDSC
    Node localhost {
        NetIPInterface DisableDhcp
        {
            InterfaceAlias = 'Ethernet'
            AddressFamily = 'IPv4'
            Dhcp = 'Disabled'
        }

        IPAddress ipv4
        {
            InterfaceAlias = 'Ethernet'
            IPAddress = "$ip"
            AddressFamily = 'IPv4'
        }

        DnsServerAddress dns
        {
            InterfaceAlias = 'Ethernet'
            Address = "$dns"
            AddressFamily = 'IPv4'
        }

        DefaultGatewayAddress gw
        {
            InterfaceAlias = 'Ethernet'
            AddressFamily = 'IPv4'
            Address = "$gw"
        }

        Computer node
        {
            Name = 'D001'
        }

        TimeZone tz
        {
            TimeZone = 'Central Europe Standard Time'
            IsSingleInstance = 'Yes'
        }

        Package AdminCenter
        {
            Path = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter1910.msi'
            Name = 'Windows Admin Center'
            ProductId = '{F153124D-7DCA-4143-BF0B-E37D3B4C3B17}'
            Arguments = '/qn SME_PORT=8443 SSL_CERTIFICATE_OPTION=generate'
        }
        
    }
}

. BaseConfig
Start-DscConfiguration .\BaseConfig -Wait -Force
