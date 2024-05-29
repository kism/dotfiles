$funemoji = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F64B",16))

Write-Host "$funemoji Install/Update Oh My Posh"
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://ohmyposh.dev/install.ps1'))

Write-Host "$funemoji Copy my Powershell profile"
Copy-Item .\posh\Microsoft.PowerShell_profile.ps1 -Destination $PROFILE

Write-Host "$funemoji Copy my Powershell theme"
Copy-Item .\posh\ys2.omp.json -Destination $env:POSH_THEMES_PATH/ys2.omp.json
