if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# Make PS behave a bit more like zsh
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# Load SSH Key
if (!(Get-Process ssh-agent -ErrorAction SilentlyContinue)) {
    # Start the SSH agent
    Start-Process ssh-agent -WindowStyle Hidden
}
$sshKeyLoaded = ssh-add -l

# If the SSH key is not loaded, add it to the agent
$funkey = " "
if (!$sshKeyLoaded) {
    ssh-add ~/.ssh/id_ed25519
}
else {
    $funkey = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F511", 16))
}

$promptactive = " "
if (Test-Path env:STARSHIP_SHELL) {
    $promptactive = ", starship"
}

# Alias
New-Alias npp notepad++.exe
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    # Check if Neovim is installed and alias vim to nvim
    New-Alias vim nvim
}

# Startup Message
$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime
Write-Output "$((Get-WmiObject Win32_OperatingSystem).Caption), Powershell $($PSVersionTable.PSVersion)$promptactive"
Write-Output "$env:username@$env:USERDNSDOMAIN $env:computername Up: $($uptime.days) Days, $($uptime.Hours)h$($uptime.Minutes)m $funkey"
