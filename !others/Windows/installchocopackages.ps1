## Before running this...
# Set-ExecutionPolicy Unrestricted -Scope CurrentUser
# https://github.com/W4RH4WK/Debloat-Windows-10/
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

choco feature enable -n allowGlobalConfirmation

# (""),

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
    ("goggalaxy"),
    ("hashtab"),
    ("kdiff3"),
    ("krita"),
    ("libreoffice-fresh"),
    ("microsoft-windows-terminal"),
    ("mpv.install"),
    ("nmap"),
    ("notepadplusplus.install"),
    ("obs-studio.install"),
    ("powertoys"),
    ("putty"),
    ("python3"),
    ("scrcpy"),
    ("spacesniffer"),
    ("speedcrunch.install"),
    ("steam"),
    ("streamlink"),
    ("streamlink-twitch-gui"),
    ("sumatrapdf.install"),
    ("teracopy"),
    ("vlc"),
    ("vscode.install"),
    ("winscp.install"),
    # Fonts
    ("cascadia-code-nerd-font"),
    ("dejavufonts"),
    ("fira"),
    ("firacode"),
    ("hasklig"),
    ("inconsolata"),
    ("sourcecodepro")
)

ForEach ($PackageName in $Packages) {
    choco upgrade $PackageName -y
}
