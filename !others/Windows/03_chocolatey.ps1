if (Get-Command "chocolatey.exe" -ErrorAction SilentlyContinue) { 
    Write-Host "✔️ Chocolatey is installed!"

    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Write-Host "❌ Please run this in an Administrative Shell"
        return
    } else {
        Write-Host "✔️ Running in an Administrative Shell!"
    }

    # Allow Autoconfirm
    choco feature enable -n allowGlobalConfirmation

    $Packages = @(
        # VCRedist
        ("vcredist2005"),
        ("vcredist2008"),
        ("vcredist2010"),
        ("vcredist2013"),
        ("vcredist2015"),
        ("vcredist140"),
        # Programs
        ("7zip.install"),
        ("audacity"),
        ("bitwarden"),
        ("cpu-z"),
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
        ("gpu-z"),
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
        ("putty.install"),
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
        ("winaero-tweaker"),
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

    $in = Read-Host "Restart computer now [y/n]"
    if (($in | select-string "yes") -or ($in.Substring(0) -eq 'y')) {
        Restart-computer -Force -Confirm:$false
    }
} else {
    $ChocolateyURL = "https://chocolatey.org/install"
    Write-Host      "❌Install Chocolatey first please!"
    Write-Host      $ChocolateyURL
    Start-Process   $ChocolateyURL
}


