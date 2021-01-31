## Before running this...
# Set-ExecutionPolicy Unrestricted -Scope CurrentUser
# https://github.com/W4RH4WK/Debloat-Windows-10/
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation

$Packages = @(
    ("7zip.install"),
    ("audacity"),
    ("bitwarden"),
    ("crystaldiskinfo.install"),
    ("discord.install"),
    ("dropbox"),
    ("eartrumpet"),
    ("f.lux.install"),
    ("ffmpeg"),
    ("foobar2000"),
    ("gimp"),
    ("git.install"),
    ("gitkraken"),
    ("hashtab"),
    ("hasklig"),
    ("kdiff3"),
    ("krita"),
    ("libreoffice-fresh"),
    ("microsoft-windows-terminal"),
    ("mpv.install"),
    ("nmap.install"),
    ("notepadplusplus.install"),
    ("obs-studio.install"),
    ("powertoys"),
    ("putty"),
    ("python3"),
    ("scrcpy"),
    ("speedcrunch.install"),
    ("steam"),
    ("streamlink"),
    ("streamlink-twitch-gui"),
    ("sumatrapdf.install"),
    ("vlc"),
    ("vscode.install"),
    ("teracopy"),
    ("winscp.install"),
    ("adoptopenjdk11"),
    ("jdownloader"),
    ("signal"),
    ("spacesniffer"),
    ("goggalaxy"),
    ("winscp.install")
)

ForEach ($PackageName in $Packages) {
    choco upgrade $PackageName -y
}

Write-Host "Restarting Computer"

Restart-Computer
