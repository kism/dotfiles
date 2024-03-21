Set-ExecutionPolicy Unrestricted -Scope CurrentUser

if (Get-Command "chocolatey.exe" -ErrorAction SilentlyContinue) {
    Write-Host "✔️ Chocolatey is installed!"

    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Write-Host "❌ Please run this in an Administrative Shell"
        return
    }
    else {
        Write-Host "✔️ Running in an Administrative Shell!"
    }

    # Allow Autoconfirm
    choco feature enable -n allowGlobalConfirmation

    $Packages = @(
        # VCRedist
        ("vcredist-all"),
        # Programs
        ("7zip.install"),
        ("audacity"),
        ("bitwarden"),
        ("chatterino"),
        ("cpu-z"),
        ("crystaldiskinfo.install"),
        ("crystaldiskmark"),
        ("discord.install"),
        ("dropbox"),
        ("eartrumpet"),
        ("ffmpeg"),
        ("foobar2000"),
        ("furmark"),
        ("gimp"),
        ("git.install"),
        ("goggalaxy"),
        ("gpu-z"),
        ("hashtab"),
        ("hwinfo"),
        ("irfanview"),
        ("irfanviewplugins"),
        ("hwmonitor"),
        ("kdiff3"),
        ("krita"),
        ("libreoffice-fresh"),
        ("mkvtoolnix"),
        ("mpv.install"),
        ("msiafterburner"),
        ("nmap"),
        ("notepadplusplus.install"),
        ("obs-studio.install"),
        ('oh-my-posh'),
        ("powertoys"),
        ("putty.install"),
        ("python3"),
        ("scrcpy"),
        ("signal"),
        ("spacesniffer"),
        ("steam"),
        ("streamlink"),
        ("streamlink-twitch-gui"),
        ("sumatrapdf.install"),
        ("teracopy"),
        ("vivaldi.install"),
        ("vlc"),
        ("vscode.install"),
        ("winscp.install"),
        ("yt-dlp"),
        # Fonts
        ("cascadia-code-nerd-font"),
        ("dejavufonts"),
        ("fira"),
        ("firacode"),
        ("hasklig"),
        ("nerd-fonts-hasklig"),
        ("inconsolata"),
        ("sourcecodepro")
    )

    ForEach ($PackageName in $Packages) {
        choco upgrade $PackageName -y
    }

    $in = Read-Host "Restart computer now [y/n]"
    if (($in | select-string "yes") -or ($in.Substring(0) -eq 'y')) {
        Restart-computer -Force -Confirm:$false
    }
}
else {
    $ChocolateyURL = "https://chocolatey.org/install"
    Write-Host      "❌Install Chocolatey first please!"
    Write-Host      $ChocolateyURL
    Start-Process   $ChocolateyURL
}


# Package Dumping ground
("vcredist140"),
("vcredist2005"),
("vcredist2008"),
("vcredist2010"),
("vcredist2012"),
("vcredist2013"),
("vcredist2015"),
("vcredist2017"),
("alacritty"),
