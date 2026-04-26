# Stops the DocFX process started by start-docs.ps1.
param(
    [string]$OutputRoot = $(if ($env:AZURE_DEVOPS_DOCS_LOCAL_ROOT) { $env:AZURE_DEVOPS_DOCS_LOCAL_ROOT } else { Join-Path $env:LOCALAPPDATA 'azure-devops-docs\docfx' })
)

$ErrorActionPreference = 'SilentlyContinue'

$pidFile = Join-Path $OutputRoot 'docfx.pid'

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
