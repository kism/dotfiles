# Personal Taskbar Settings
## Small icons
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons"    -Value 1
# Hide Cortana, task view
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton"    -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"   -Value 0
# Turn off taskbar animations
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations"    -Value 0
## Allow moving the task bar, the position can be set in the registry however its position depends on whether I have an even or odd number of monitors
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSizeMove"       -Value 1

# Windows Colour Settings
## DWM
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColor"                   -Value 0xff51516b
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColorInactive"           -Value 0xffefeff1
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
$UserPreferencesMask = "98,52,03,80,10,00,00,00"
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
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" -Name "ScoobeSystemSettingEnabled" -Value 0

# Disable suggested/recent documents/files in jump lists
Set-ItemProperty -Path "HKCU:HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0

# Disable Cortana
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Force

# Disable OneDrive
if (!(Test-Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows")) {
    New-Item -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" -Name "OneDrive"
}
Set-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1 -Force