# Scripts to setup windows

Execution Policy

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

Windows Settings

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kism/dotfiles/refs/heads/main/__others/Windows/Windows_Settings.ps1'))
```

Install Winget Packages (run in an Administrative Shell)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kism/dotfiles/refs/heads/main/__others/Windows/Windows_Winget.ps1'))
```

Install Starship (prompt, profile and starship.toml)

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/kism/dotfiles/refs/heads/main/__others/Windows/Windows_Starship.ps1'))
```
