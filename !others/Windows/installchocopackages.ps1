
Set-ExecutionPolicy Unrestricted -Scope CurrentUser

# Remember to grab https://github.com/W4RH4WK/Debloat-Windows-10/

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

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
    ("nmap"),
    ("notepadplusplus.install"),
    ("obs-studio.install"),
    ("paint.net"),
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
    ("winscp.install")
)

ForEach ($PackageName in $Packages) {
    choco install $PackageName -y
}
