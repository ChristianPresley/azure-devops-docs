# Starts DocFX outside the repository so generated files do not appear in git status.
param(
    [int]$Port = 8080,
    [string]$OutputRoot = $(if ($env:AZURE_DEVOPS_DOCS_LOCAL_ROOT) { $env:AZURE_DEVOPS_DOCS_LOCAL_ROOT } else { Join-Path $env:LOCALAPPDATA 'azure-devops-docs\docfx' }),
    [switch]$AllowRepoOutput
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot '..\..')
$repoRootPath = [System.IO.Path]::GetFullPath($repoRoot.Path).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
$outputRootPath = [System.IO.Path]::GetFullPath($OutputRoot).TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)

if (-not $AllowRepoOutput -and ($outputRootPath.Equals($repoRootPath, [System.StringComparison]::OrdinalIgnoreCase) -or $outputRootPath.StartsWith($repoRootPath + [System.IO.Path]::DirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase) -or $outputRootPath.StartsWith($repoRootPath + [System.IO.Path]::AltDirectorySeparatorChar, [System.StringComparison]::OrdinalIgnoreCase))) {
    throw "OutputRoot must be outside the repository. Use a path outside '$repoRootPath', or pass -AllowRepoOutput if you intentionally want in-repo output."
}

$docsDir = Join-Path $repoRoot 'docs'
$siteDir = Join-Path $outputRootPath 'site'
$logDir = Join-Path $outputRootPath 'logs'
$pidFile = Join-Path $outputRootPath 'docfx.pid'

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
