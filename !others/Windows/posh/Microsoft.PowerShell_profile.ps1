oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/ys2.omp.json" | Invoke-Expression
$bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
$CurrentDate = Get-Date
$uptime = $CurrentDate - $bootuptime
$version = [System.Environment]::OSVersion.Version
Write-Output "Windows $version Powershell $env:POSH_SHELL_VERSION"
Write-Output "$env:username@$env:USERDNSDOMAIN $env:computername Up: $($uptime.days) Days, $($uptime.Hours)h$($uptime.Minutes)m"
