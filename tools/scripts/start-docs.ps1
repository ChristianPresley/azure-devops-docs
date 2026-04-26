# Starts DocFX outside the repository so generated files do not appear in git status.
param(
    [int]$Port = 8080,
    [string]$OutputRoot = $(if ($env:AZURE_DEVOPS_DOCS_LOCAL_ROOT) { $env:AZURE_DEVOPS_DOCS_LOCAL_ROOT } else { Join-Path $env:LOCALAPPDATA 'azure-devops-docs\docfx' })
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$docsDir = Join-Path $repoRoot 'docs'
$siteDir = Join-Path $OutputRoot 'site'
$logDir = Join-Path $OutputRoot 'logs'
$pidFile = Join-Path $OutputRoot 'docfx.pid'

New-Item -ItemType Directory -Force -Path $siteDir | Out-Null
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

$docfx = Get-Command docfx -ErrorAction Stop

if (Test-Path $pidFile) {
    $existingPid = Get-Content $pidFile -ErrorAction SilentlyContinue
    if ($existingPid) {
        Stop-Process -Id $existingPid -Force -ErrorAction SilentlyContinue
    }
    Remove-Item $pidFile -Force -ErrorAction SilentlyContinue
}

$stdoutLog = Join-Path $logDir 'docfx-stdout.log'
$stderrLog = Join-Path $logDir 'docfx-stderr.log'
$structuredLog = Join-Path $logDir 'docfx.json.log'

$arguments = @(
    'build',
    'docfx.json',
    '--output', $siteDir,
    '--serve',
    '--port', $Port,
    '--log', $structuredLog
)

$process = Start-Process -FilePath $docfx.Source `
    -ArgumentList $arguments `
    -WorkingDirectory $docsDir `
    -RedirectStandardOutput $stdoutLog `
    -RedirectStandardError $stderrLog `
    -WindowStyle Hidden `
    -PassThru

$process.Id | Out-File -FilePath $pidFile -Encoding ascii

Write-Host "DocFX started with PID $($process.Id)."
Write-Host "Site output: $siteDir"
Write-Host "Logs:        $logDir"
Write-Host "URL:         http://localhost:$Port/team-services/"
Write-Host "All group:   http://localhost:$Port/all/"
