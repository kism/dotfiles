$funemoji = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F64B",16))
$rawBase = "https://raw.githubusercontent.com/kism/dotfiles/refs/heads/main"

Write-Host "$funemoji Install/Update Starship..."
if (Get-Command starship -ErrorAction SilentlyContinue) {
    winget upgrade Starship.Starship --source winget --accept-source-agreements --accept-package-agreements
} else {
    winget install Starship.Starship --source winget --accept-source-agreements --accept-package-agreements
}

# The profile caches `starship init`, drop the cache so it regenerates for the new version
Remove-Item (Join-Path $env:LOCALAPPDATA "starship-init.ps1") -ErrorAction SilentlyContinue

# Copy from the repo if this script was run from a clone, otherwise (iex from the README one-liner) download it
function Install-DotFile {
    param([string]$RepoPath, [string]$Destination)
    New-Item -ItemType Directory -Force -Path (Split-Path $Destination) | Out-Null
    $local = if ($PSScriptRoot) { Join-Path $PSScriptRoot (Join-Path "..\.." $RepoPath) } else { $null }
    if ($local -and (Test-Path $local)) {
        Copy-Item $local -Destination $Destination -Force
    } else {
        Invoke-WebRequest "$rawBase/$($RepoPath -replace '\\','/')" -OutFile $Destination
    }
}

Write-Host "$funemoji Copy my Powershell profile..."
Install-DotFile "__others\Windows\Microsoft.PowerShell_profile.ps1" $PROFILE

Write-Host "$funemoji Copy my Starship config..."
# Starship reads ~/.config/starship.toml on Windows too
Install-DotFile ".config\starship.toml" (Join-Path $env:USERPROFILE ".config\starship.toml")
