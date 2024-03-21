Write-Host "Paste these into admin terminal windows specifically"

# Set powershell script settings
Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Chocolatey https://chocolatey.org/install#individual
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))