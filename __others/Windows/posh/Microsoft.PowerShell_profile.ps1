oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/ys2.omp.json" | Invoke-Expression

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
} else {
	$funkey = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("1F511",16))
}

# Startup Message
$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime
$version = [System.Environment]::OSVersion.Version
Write-Output "Windows $version Powershell $env:POSH_SHELL_VERSION"
Write-Output "$env:username@$env:USERDNSDOMAIN $env:computername Up: $($uptime.days) Days, $($uptime.Hours)h$($uptime.Minutes)m $funkey"
