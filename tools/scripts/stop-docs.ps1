# Stops the DocFX process started by start-docs.ps1.
param(
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

$ErrorActionPreference = 'SilentlyContinue'

$pidFile = Join-Path $outputRootPath 'docfx.pid'

if (Test-Path $pidFile) {
    $docfxPid = Get-Content $pidFile
    if ($docfxPid) {
        Stop-Process -Id $docfxPid -Force
        Write-Host "Stopped DocFX PID $docfxPid."
    }
    Remove-Item $pidFile -Force
} else {
    Write-Host "No DocFX PID file found at $pidFile."
}
