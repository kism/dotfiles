# Local version of .github/workflows/check-windows.yml

$ErrorActionPreference = 'Stop'
Set-Location (Join-Path $PSScriptRoot '..')

if (-not (Get-Module -ListAvailable -Name PSScriptAnalyzer)) {
    Write-Output 'Installing PSScriptAnalyzer...'
    Install-Module PSScriptAnalyzer -Force -Scope CurrentUser
}

# Warning severity is noisy on profile scripts, CI gates on Error too
$issues = Invoke-ScriptAnalyzer -Path . -Recurse -Severity Error
if ($issues) {
    $issues | Format-Table -AutoSize
    exit 1
}
Write-Output 'No errors'
