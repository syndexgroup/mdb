param(
    [Parameter(Mandatory = $true)]
    [string] $Version,
    
    [Parameter(Mandatory = $true)]
    [string] $Destination
)

$ErrorActionPreference = "Stop"

$release = Invoke-RestMethod "https://api.github.com/repos/airsdk/apm/releases/tags/$Version"
$asset = $release.assets | Where-Object { $_.name -match "(?i)windows" -and $_.name -like "*.zip" } | Select-Object -First 1
if (-not $asset) {
    throw "Could not fetch APM release!!"
}

$archive = Join-Path $env:RUNNER_TEMP "apm.zip"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $archive
New-Item -ItemType Directory -Force -Path $Destination | Out-Null
Expand-Archive -Path $archive -DestinationPath $Destination -Force

$apm = Get-ChildItem -Path $Destination -Filter "apm.bat" -Recurse | Select-Object -First 1
if (-not $apm) {
    throw "Could not find apm.bat!!"
}

$apm.Directory.FullName >> $env:GITHUB_PATH
