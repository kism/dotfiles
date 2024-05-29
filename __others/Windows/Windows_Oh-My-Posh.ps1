Write-Host "🙋‍♀️ Install/Update Oh My Posh"
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))

Write-Host "🙋‍♀️ Copy my Powershell profile"
Copy-Item .\posh\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE

Write-Host "🙋‍♀️ Copy my Powershell theme"
Copy-Item .\posh\ys2.omp.json -Destination $env:POSH_THEMES_PATH/ys2.omp.json
