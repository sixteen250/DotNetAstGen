param(
    [string]$Version
)

$ErrorActionPreference = "Stop"

function Get-VersionFromLatestTag {
    $latestTag = & git describe --tags --abbrev=0 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($latestTag)) {
        return "0.0.1-local"
    }

    return $latestTag.Trim() -replace "^[vV]", ""
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = Get-VersionFromLatestTag
}

Write-Host "Running build with assigned version: $Version"

dotnet build -c Release "/p:Version=$Version" "/p:AssemblyVersion=$Version"
