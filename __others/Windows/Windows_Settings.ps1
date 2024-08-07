
# Get the operating system version
$windowsMajorVersion = (Get-WmiObject Win32_OperatingSystem).Caption
if ($windowsMajorVersion -contains "Windows 10") {
    $windowsMajorVersion = "Windows 10"
}
elseif ($windowsMajorVersion -contains "Windows 11") {
    $windowsMajorVersion = "Windows 11"
}


# Taskbar, "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if ($windowsMajorVersion -eq "Windows 10") { # On Windows 11, Install startallback lmao, or maybe that stardock one
    ## Small icons
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons"    -Value 1
    # Hide Cortana, task view
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton"    -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"   -Value 0
    # Turn off taskbar animations
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations"    -Value 0
    ## Allow moving the task bar, the position can be set in the registry however its position depends on whether I have an even or odd number of monitors
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSizeMove"       -Value 1
}

# Sound Settings, "HKEY_CURRENT_USER\AppEvents\Schemes\Apps\.Default\.Default\.Current"
Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\.Default\.Current" -Name "(Default)"                   -Value "%SystemRoot%\media\Windows Ding.wav"

# Windows Colour Settings, "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM"
## DWM
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColor"                   -Value 0xff484a4c
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AlwaysHibernateThumbnails"     -Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationAfterglow"         -Value 0xc46b5151
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationAfterglowBalance"  -Value 0xa
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationBlurBalance"       -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColor"             -Value 0xff484a4c
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColorBalance"      -Value 0x59
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationGlassAttribute"    -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorPrevalence"               -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "Composition"                   -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableAeroPeek"                -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableWindowColorization"      -Value 0x1
## Theme
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme"    -Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"       -Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence"         -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency"      -Value 0x1

## Windows Performance Settings, "HKEY_CURRENT_USER\Control Panel\Desktop"
$UserPreferencesMask = "98,1E,03,80,12,00,00,00"
if ($windowsMajorVersion -eq "Windows 10") {
    $UserPreferencesMask = "98,52,03,80,10,00,00,00"
}
$UserPreferencesMaskHex = $UserPreferencesMask.Split(',') | ForEach-Object { "0x$_" }
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "UserPreferencesMask" -Value ([byte[]]$UserPreferencesMaskHex)

if ($windowsMajorVersion -eq "Windows 11") {
    # On Windows 11, Install startallback lmao, or maybe that stardock one
    # Windows 11 SnapBar (thing at top to snap windows when draging a window), Computer\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" -Name "EnableSnapBar" -Value 0
}

# International Settings, "HKEY_CURRENT_USER\Control Panel\International"
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iCalendarType"   -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iCountry"        -Value 61
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iCurrDigits"     -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iCurrency"       -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iDate"           -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iDigits"         -Value 2
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iFirstDayOfWeek" -Value 0
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "iLZero"          -Value 1
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "LocaleName"      -Value "en-AU"
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "sLongDate"       -Value "dddd, d MMMM yyyy"
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "sShortDate"      -Value "yyyy-MM-dd"
Set-ItemProperty -Path "HKCU:\Control Panel\International\" -Name "sShortTime"      -Value "HH:mm"

# Windows Time Settings, "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation"
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Value 1 -Force

# Keyboard, "HKEY_CURRENT_USER\Control Panel\Accessibility"
## Turn off Stickey Keys shortcuts
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response"    -Name "Flags"    -Value 122
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys"           -Name "Flags"    -Value 506
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys"           -Name "Flags"    -Value 506

# Explorer, "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
## Disallow shake to minimise all windows
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisallowShaking" -Value 1
## Turn off 'Recent Files'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent"  -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent"    -Value 0
## Shown File Extensions, hidden items
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt"  -Value 0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden"       -Value 1
## Desktop Settings
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1
## Disable suggested/recent documents/files in jump lists
Set-ItemProperty -Path "HKCU:HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0

# Disable Get "Even More Out Of Windows"
if ($windowsMajorVersion -eq "Windows 10") {
    # "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Value 0
}
if ($windowsMajorVersion -eq "Windows 11") {
    # "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "Browser"           -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "CheckMSAAccount"   -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "LandingPage"       -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "OneDriveStartScan" -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "overallContext"    -Value '{"version":0,"trigger":"","lastUpdated":"132851413906829880","overallProgress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "RecommendedApps"   -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "StartSelector"     -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "TipsFiles"         -Value '{"progress":100}'
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "Welcome"           -Value '{"progress":100}'

    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0

    if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement")) {
        New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "UserProfileEngagement"
    }
}

# Start menu search
## Disable web search in start menu
if ($windowsMajorVersion -eq "Windows 10") {
    ## Up to Windows 10 version 1909, "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0
}

# For Windows 10 version 2004 or later, "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\Explorer"
if (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer")) {
    New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows" -Name "Explorer"
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "DisableSearchBoxSuggestions" -Value 1


# Edge, I give up on this tbh
if (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Edge")) {
    New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows" -Name "Edge"
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Edge" -Name "HubsSidebarEnabled" -Value 0 -Force

################################################################################################################################################################
#### ELEVATED SECTION
################################################################################################################################################################

# Check if the current session is elevated
$isElevated = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If not elevated, exit with an error message
if (-not $isElevated) {
    Write-Host "The rest of this script requires elevated privileges. Please run it as an administrator."
    exit 1
}

# Firewall
New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -IcmpType 8 -Enabled True -Direction Inbound -Action Allow
New-NetFirewallRule -DisplayName "Allow ICMPv6-In" -Protocol ICMPv6 -IcmpType 128 -Enabled True -Direction Inbound -Action Allow


# Edge, I give up on this tbh, "Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Edge"
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Edge")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Edge"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Edge" -Name "HubsSidebarEnabled" -Value 0 -Force


# Disable Cortana
# "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force

# Disable OneDrive, "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\OneDrive"
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "OneDrive"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Force


# Edge, I give up on this tbh, "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Edge"
if (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Edge")) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Edge"
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Edge" -Name "HubsSidebarEnabled" -Value 0 -Force

if (!(Test-Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Edge")) {
    New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows" -Name "Edge"
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Edge" -Name "HubsSidebarEnabled" -Value 0 -Force


## Context Menu
$ConfirmPreference = 'High'
New-PSDrive -Name "HKCR" -PSProvider Registry -Root "HKEY_CLASSES_ROOT"

$ContextMenuRegPaths = @(
    # Git Bash
    ('HKCR:\Directory\shell\git_gui'),
    ('HKCR:\Directory\shell\git_shell'),
    ('HKCR:\LibraryFolder\background\shell\git_gui'),
    ('HKCR:\LibraryFolder\background\shell\git_shell'),
    ('HKLM:\SOFTWARE\Classes\Directory\background\shell\git_gui'),
    ('HKLM:\SOFTWARE\Classes\Directory\background\shell\git_shell'),
    # VLC
    ('HKCR:\Directory\shell\AddToPlaylistVLC'),
    ('HKCR:\Directory\shell\PlayWithVLC')
    # kdiff3
    ('HKCR:\*\shellex\ContextMenuHandlers\diff-ext-for-kdiff3')
    ('HKCR:\*\shellex\ContextMenuHandlers\diff-ext-for-kdiff3-64')
    # Dropbox
    ('HKCR:\*\shellex\ContextMenuHandlers\DropboxExt')
    # Teracopy
    ('HKCR:\*\shellex\ContextMenuHandlers\TeraCopy')
    # VSCode
    ('HKCR:\*\shell\VSCode')
    ('HKCR:\Directory\shell\VSCode')

)

ForEach ($RegPath in $ContextMenuRegPaths) {
    Remove-Item -Path $RegPath -Recurse -Confirm -ErrorAction SilentlyContinue
}

