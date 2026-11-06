# Starship prompt, init script is cached because generating it on every start is slow.
# Delete the cache to regenerate (Windows_Starship.ps1 does this on upgrade).
$starshipCache = Join-Path $env:LOCALAPPDATA "starship-init.ps1"
if (!(Test-Path $starshipCache) -and (Get-Command starship -ErrorAction SilentlyContinue)) {
    starship init powershell --print-full-init | Out-File $starshipCache -Encoding utf8
}
if (Test-Path $starshipCache) {
    . $starshipCache
}

# Make PS behave a bit more like zsh
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Load SSH Key, the Windows OpenSSH Authentication Agent service is set to start automatically in Windows_Settings.ps1
$funkey = " "
ssh-add -l *> $null
if ($LASTEXITCODE -eq 0) {
    $funkey = [System.Char]::ConvertFromUtf32(0x1F511)
}
elseif ($LASTEXITCODE -eq 1) {
    # Agent is running but has no identities
    ssh-add ~/.ssh/id_ed25519
}

# Alias
New-Alias npp notepad++.exe
function vim { nvim @args }

# Startup Message, avoiding CIM/WMI as they are slow
$uptime = [TimeSpan]::FromMilliseconds([Environment]::TickCount64)
$osInfo = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$osName = $osInfo.ProductName
if ([int]$osInfo.CurrentBuildNumber -ge 22000) { $osName = $osName -replace "Windows 10", "Windows 11" }
Write-Output "Microsoft $osName, Powershell $($PSVersionTable.PSVersion)$promptactive"
