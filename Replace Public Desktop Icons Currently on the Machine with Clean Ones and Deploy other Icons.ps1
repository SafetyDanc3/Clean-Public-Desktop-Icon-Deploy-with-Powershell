#Make sure you have PSTOOLS properly downloaded and you connected it to Powershell. Once complete, run this to connect to AD
﻿Import-Module ActiveDirectory

# OU containing the computers
$OU = "OU=(OU_HERE),OU=(OU_HERE),OU=(OU_Here),DC=(DC_Here),DC=(DC HERE),DC=(DC HERE)"

# Path to your files
$Source = "C:\Path\to\File"

# Get computers in the OU
$Computers = Get-ADComputer -SearchBase $OU -Filter *

Write-Host "Starting Public Desktop deployment..." -ForegroundColor Cyan
Write-Host ""

foreach ($Computer in $Computers) {
    $ComputerName = $Computer.Name
    $Dest = "\\$ComputerName\C$\Users\Public\Desktop"

    Write-Host "Connecting to $ComputerName..." -ForegroundColor Yellow

    # Test if machine is online
    if (-not (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet)) {
        Write-Host "OFFLINE: $ComputerName" -ForegroundColor Red
        continue
    }

    # Test if C$ is reachable
    if (-not (Test-Path $Dest)) {
        Write-Host "UNREACHABLE: $ComputerName (C$ share not accessible)" -ForegroundColor Red
        continue
    }

    try {
        # Remove existing files that match the source names
        $SourceFiles = Get-ChildItem -Path $Source

        foreach ($File in $SourceFiles) {
            $TargetItem = Join-Path $Dest $File.Name

            if (Test-Path $TargetItem) {
                Remove-Item -Path $TargetItem -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "[$ComputerName] Removed existing: $($File.Name)" -ForegroundColor DarkYellow
            }
        }

        # Copy fresh files
        Copy-Item -Path "$Source\*" -Destination $Dest -Recurse -Force
        Write-Host "SUCCESS: Copied updated files to $ComputerName" -ForegroundColor Green
    }
    catch {
        Write-Host "FAILED: $ComputerName - $($_.Exception.Message)" -ForegroundColor Red
    }

    Write-Host ""
}
