param(
    [Parameter(Mandatory = $true)]
    [string] $Version,
    
    [Parameter(Mandatory = $true)]
    [string] $Destination
)

$ErrorActionPreference = "Stop"

$releaseUrl = "https://api.github.com/repos/airsdk/apm/releases/tags/$Version"
$release = Invoke-RestMethod -Uri $releaseUrl
$expectedAssetName = "apm_$Version.zip"

$asset = $release.assets | Where-Object { $_.name -eq $expectedAssetName } | Select-Object -First 1
if (-not $asset) {
    throw "Could not fetch APM release!!"
}

Write-Host "Downloading $($asset.name)"
Write-Host "From: $($asset.browser_download_url)"

$archive = Join-Path $env:RUNNER_TEMP "apm-$Version.zip"

Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
New-Item -ItemType Directory -Force -Path $Destination | Out-Null
Expand-Archive -Path $archive -DestinationPath $Destination -Force

$apm = Get-ChildItem -Path $Destination -Filter "apm.bat" -File -Recurse | Select-Object -First 1
if (-not $apm) {
    throw "Could not find apm.bat!!"
}

Add-Content -Path $env:GITHUB_PATH -Value $apm.Directory.FullName -Encoding utf8