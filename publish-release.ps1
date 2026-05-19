param(
    [Parameter(Mandatory = $true)]
    [string]$OS,

    [Parameter(Mandatory = $true)]
    [string]$Arch
)

$ErrorActionPreference = "Stop"

function Get-VersionFromLatestTag {
    $latestTag = & git describe --tags --abbrev=0 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($latestTag)) {
        return "0.0.1-local"
    }

    return $latestTag.Trim() -replace "^[vV]", ""
}

Write-Host "OS: $OS"
Write-Host "Architecture: $Arch"

if ([string]::IsNullOrWhiteSpace($env:NEXT_VERSION)) {
    $env:NEXT_VERSION = Get-VersionFromLatestTag
    Write-Host "Version not set, defaulting to $env:NEXT_VERSION"
}

$releaseDir = ".\release"

if ($OS -eq "osx") {
    $outputTarget = "macos"
} else {
    $outputTarget = $OS
}

if ($Arch -like "arm*") {
    $outputTarget = "$outputTarget-arm"
}

$outputPath = Join-Path $releaseDir $outputTarget
$target = "$OS-$Arch"
$project = ".\DotNetAstGen\DotNetAstGen.csproj"

dotnet publish $project -c Release -r $target -o $outputPath
