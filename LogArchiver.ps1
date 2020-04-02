<#
.SYNOPSIS
  Moves Logfiles to archive packages for amount of time

.DESCRIPTION
  Moves logfiles older than specified days to monthly archives. Deletes archives older than archive retention days.

.PARAMETER Path
  Path to the folder where the logfiles are

.PARAMETER ArchivesRoot
  Path where the archives shall be stored. Defaults to $Path\Archives

.PARAMETER RetentionDays
  Number of days to skip archiving for. Defaults to 30

.PARAMETER RetentionArchiveDays
  Number of days which trigger an archive to be deleted if older. Defaults to 365

.INPUTS
  Path of the logfile folder

.OUTPUTS
  Reorganized Logfiles folder

.NOTES
  Author: Philipp Ritter
  Version: 1.0
  Last Modify: 01.04.2020

.EXAMPLE
  .\LogArchiver.ps1 -Path C:\my\logs
#>
#Requires -Version 4

Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$Path,
    [string]$ArchivesRoot = "$Path\Archives",
    [int]$RetentionDays = 30,
    [int]$RetentionArchiveDays = 365
)

Begin{
    if(-not(Test-Path $Path)){
        Write-Host -ForegroundColor Red "Path not found, $Path"
        return
    }
}

Process{
    $CompressionCandidates = Get-ChildItem $Path -File | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-$RetentionDays)}
    try{
        $CompressionCandidates | 
        Group-Object -Property {$_.LastWriteTime.Year} | ForEach-Object {
            $Year = $_.Name
            $_.Group | Group-Object -Property {$_.LastWriteTime.Month} | ForEach-Object {
                $TargetArchive = "$ArchivesRoot\$Year\$($_.Name).zip"
                # Create the year folder
                $null = New-Item -ItemType Directory -Path (Split-Path $TargetArchive) -ErrorAction SilentlyContinue
                # if archive exists add it otherwise create new
                $_.Group | Compress-Archive -Update:(Test-Path $TargetArchive) -DestinationPath $TargetArchive
            }
        }
        # Only remove files if we successfully archived them
        $CompressionCandidates | Select-Object -ExpandProperty FullName |  Remove-Item  -Force
    }
    catch {
        Write-Host -ForegroundColor Red "Something strange happened"
        $_.Exception
    }

    # Remove old archives
    $DueDate = (Get-Date).AddDays(-$RetentionArchiveDays)
    Get-ChildItem $ArchivesRoot | Where-Object { [int]($_.Name) -lt [int]($DueDate.Year) } | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force
    Get-ChildItem "$ArchivesRoot\$($DueDate.Year)" | Where-Object { [int]($_.Name.Split(".")[0]) -lt $DueDate.Month } | Select-Object -ExpandProperty FullName | Remove-Item -Recurse -Force
}

End{

}
