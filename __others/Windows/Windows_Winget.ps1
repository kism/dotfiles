if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    Write-Host "[X] Please run this in an Administrative Shell"
    return
}
Write-Host "[OK] Running in an Administrative Shell!"

if (-Not (Get-Command "winget.exe" -ErrorAction SilentlyContinue)) {
    Write-Host "[X] winget not found, install 'App Installer' from the Microsoft Store first please!"
    Start-Process "https://apps.microsoft.com/detail/9nblggh4nns1"
    return
}
Write-Host "[OK] winget is installed!"

$Packages = @(
    # VCRedist
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86",
    # Programs
    "7zip.7zip",
    "Audacity.Audacity",
    "Bitwarden.Bitwarden",
    # "ChatterinoTeam.Chatterino",
    # "CPUID.CPU-Z",
    # "CrystalDewWorld.CrystalDiskInfo",
    # "CrystalDewWorld.CrystalDiskMark",
    # "Discord.Discord",
    # "Dropbox.Dropbox",
    "File-New-Project.EarTrumpet",
    # "Gyan.FFmpeg",
    # "PeterPawlowski.foobar2000",
    # "Geeks3D.FurMark.2",
    # "GIMP.GIMP.3",
    "Git.Git",
    # "GOG.Galaxy",
    # "TechPowerUp.GPU-Z",
    "namazso.OpenHashTab",
    # "REALiX.HWiNFO",
    # "IrfanSkiljan.IrfanView",
    # "IrfanSkiljan.IrfanView.PlugIns",
    # "CPUID.HWMonitor",
    # "KDE.KDiff3",
    # "KDE.Krita",
    # "TheDocumentFoundation.LibreOffice",
    # "MediaArea.MediaInfo",
    # "MoritzBunkus.MKVToolNix",
    "shinchiro.mpv",
    # "Guru3D.Afterburner",
    # "Neovim.Neovim",
    # "Insecure.Nmap",
    "Notepad++.Notepad++",
    # "OBSProject.OBSStudio",
    "JanDeDobbeleer.OhMyPosh", # Only used for its Nerd Font installer below, the prompt is Starship
    "Microsoft.PowerToys",
    # "Genymobile.scrcpy",
    # "OpenWhisperSystems.Signal",
    "UderzoSoftware.SpaceSniffer",
    # "Valve.Steam",
    # "Streamlink.Streamlink",
    # "Streamlink.Streamlink.TwitchGui",
    "SumatraPDF.SumatraPDF",
    "CodeSector.TeraCopy",
    "VideoLAN.VLC",
    "Microsoft.VisualStudioCode",
    "WinSCP.WinSCP"
)

ForEach ($PackageName in $Packages) {
    Write-Host "Installing/Upgrading $PackageName..."
    # winget upgrade only upgrades; install is a no-op/upgrade if already present
    winget install --id $PackageName -e --source winget --silent --accept-source-agreements --accept-package-agreements
}

# Fonts: most are not in winget, so use Oh My Posh's Nerd Font installer
$Fonts = @(
    "CascadiaCode",
    "FiraCode",
    "Hasklig",
    "Inconsolata",
    "SourceCodePro",
    "DejaVuSansMono"
)

if (Get-Command "oh-my-posh.exe" -ErrorAction SilentlyContinue) {
    ForEach ($FontName in $Fonts) {
        Write-Host "Installing font $FontName..."
        oh-my-posh font install $FontName
    }
}
else {
    Write-Host "[X] oh-my-posh not on PATH yet, open a new shell and run 'oh-my-posh font install <name>' for: $($Fonts -join ', ')"
}

$in = Read-Host "Restart computer now [y/n]"
if ($in -match '^y') {
    Restart-Computer -Force -Confirm:$false
}
