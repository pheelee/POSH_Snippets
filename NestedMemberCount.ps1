Param(
    [string]$Username = $env:USERNAME
)

[int]$script:Generation = 32
[int]$script:LDAPQueryCount = 0

function Get-MemberOf
{
    Param([string]$dn)
    $script:LDAPQueryCount += 1
    return (Get-ADObject -LDAPFilter "(DistinguishedName=$dn)" -Properties memberOf | Select-Object -ExpandProperty memberOf)
}

$userdn = Get-ADUser $Username -Property DistinguishedName | Select-Object -ExpandProperty DistinguishedName

$CurrentGenerationMembers = Get-MemberOf -dn $userdn

[PSCustomObject]@{
    Generation = "0 - Direct"
    Members = $CurrentGenerationMembers.Count
    TotalLDAPQueries = $script:LDAPQueryCount

}

while($script:Generation -gt 0) {
    $script:Generation -= 1
    $NextGenMembers = @()
    $CurrentGenerationMembers | ForEach-Object {
        $NextGenMembers += Get-MemberOf -dn $_
    }

    [PSCustomObject]@{
        Generation = 32 - $script:Generation
        Members = $NextGenMembers.Count
        TotalLDAPQueries = $script:LDAPQueryCount
    }
    
    $CurrentGenerationMembers = $NextGenMembers
}
