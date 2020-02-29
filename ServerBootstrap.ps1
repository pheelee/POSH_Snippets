  $ip = "192.168.3.5"
$gw = "192.168.3.254"
$dns = "192.168.3.254"

$hostname = "D001"

Install-Module NetworkingDSC,ComputerManagementDSC -Confirm:$false

Configuration BaseConfig {
    Import-DscResource -Module NetworkingDSC
    Import-DscResource -Module ComputerManagementDSC
    Node localhost {

        RemoteDesktopAdmin RemoteDesktopSettings
        {
            IsSingleInstance   = 'yes'
            Ensure             = 'Present'
            UserAuthentication = 'Secure'
        }

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

        #Package AdminCenter
        #{
        #    Path = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter1910.msi'
        #    Name = 'Windows Admin Center'
        #    ProductId = '{F153124D-7DCA-4143-BF0B-E37D3B4C3B17}'
        #    Arguments = '/qn SME_PORT=8443 SSL_CERTIFICATE_OPTION=generate'
        #}

        Package Myrtille
        {
            Path = 'https://github.com/cedrozor/myrtille/releases/download/v2.8.0/Myrtille_2.8.0_x86_x64_Setup.msi'
            Name = 'Myrtille'
            ProductId = ''
            Arguments = '/qn'
        }
        
    }
}

. BaseConfig
Start-DscConfiguration .\BaseConfig -Wait -Force
  
