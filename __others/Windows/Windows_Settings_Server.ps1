# Windows Colour Settings, "Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\DWM"
## DWM
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColor"        -Value 0xff484a4c
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColor"  -Value 0xff484a4c
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorPrevalence "   -Value 1

# Theme
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme"    -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"       -Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency"      -Value 0x0

# Animations
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "AnimationDuration" -Value 0

## Small icons
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons"    -Value 1
# Hide Cortana, task view
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton"    -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton"   -Value 0

# Keyboard, "Computer\HKEY_CURRENT_USER\Control Panel\Accessibility"
## Turn off Stickey Keys shortcuts
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response"    -Name "Flags"    -Value 122
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys"           -Name "Flags"    -Value 506
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys"           -Name "Flags"    -Value 506

## Shown File Extensions, hidden items
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt"  -Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden"       -Value 1

