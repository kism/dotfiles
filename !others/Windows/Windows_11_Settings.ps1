# Personal Taskbar Settings
# TODO, Windows 11 Ruined Everything

# Windows Colour Settings
## DWM
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColor"                   -Value 0xff51516b
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AlwaysHibernateThumbnails"     -Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationAfterglow"         -Value 0xc46b5151
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationAfterglowBalance"  -Value 0xa
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationBlurBalance"       -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColor"             -Value 0xc46b5151
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColorBalance"      -Value 0x59
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationGlassAttribute"    -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorPrevalence"               -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "Composition"                   -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableAeroPeek"                -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableWindowColorization"      -Value 0x1
# Theme
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme"    -Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"       -Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence"         -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency"      -Value 0x1

# Windows Performance Settings
$UserPreferencesMask = "98,1E,03,80,12,00,00,00"
$UserPreferencesMaskHex = $UserPreferencesMask.Split(',') | ForEach-Object { "0x$_"}
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name "UserPreferencesMask" -Value ([byte[]]$UserPreferencesMaskHex)

# International Settings
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

# Windows Time Settings
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Value 1 -Force

# Keyboard
## Turn off Stickey Keys shortcuts
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response"    -Name "Flags"    -Value 122
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys"           -Name "Flags"    -Value 506
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys"           -Name "Flags"    -Value 506

# Desktop Settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1

# Explorer
## Disallow shake to minimise all windows
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisallowShaking" -Value 1
## Turn off 'Recent Files'
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent"  -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent"    -Value 0
## Shown File Extensions, hidden items
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt"  -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden"       -Value 1

# Disable Get "Even More Out Of Windows"
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "Browser"           -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "CheckMSAAccount"   -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "LandingPage"       -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "OneDriveStartScan" -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "overallContext"    -Value '{"version":0,"trigger":"","lastUpdated":"132851413906829880","overallProgress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "RecommendedApps"   -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "StartSelector"     -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "TipsFiles"         -Value '{"progress":100}'
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserOnboarding" -Name "Welcome"           -Value '{"progress":100}'

if (!(Test-Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement")) {
    New-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion" -Name "UserProfileEngagement"
}
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Value 0

# Disable suggested/recent documents/files in jump lists
Set-ItemProperty -Path "HKCU:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0

# Disable Cortana
if (!(Test-Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search")) {
    New-Item -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" -Name "Windows Search"
}
Set-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force
if (!(Test-Path "HKCU:\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Windows Search")) {
    New-Item -Path "HKCU:\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows" -Name "Windows Search"
}
Set-ItemProperty -Path "HKCU:\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force

# Disable OneDrive
if (!(Test-Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\OneDrive")) {
    New-Item -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" -Name "OneDrive"
}
Set-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Force

# Disable Some Bing Garbage in edge
if (!(Test-Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Edge")) {
    New-Item -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" -Name "Edge"
}
Set-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\Edge" -Name "HubsSidebarEnabled" -Value 0 -Force
if (!(Test-Path "HKCU:\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Edge")) {
    New-Item -Path "HKCU:\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows" -Name "Edge"
}
Set-ItemProperty -Path "HKCU:\HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Edge" -Name "HubsSidebarEnabled" -Value 0 -Force
