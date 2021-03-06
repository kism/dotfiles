# Personal Taskbar Settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSmallIcons" 	-Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCortanaButton" 	-Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" 	-Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" 	-Value 0

# Windows Colour Settings
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColor"				-Value 0xff51516b
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AccentColorInactive"		-Value 0xffefeff1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "AlwaysHibernateThumbnails"	-Value 0x0
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationAfterglow"		-Value 0xc46b5151
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationAfterglowBalance"	-Value 0xa
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationBlurBalance"		-Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColor"				-Value 0xc46b5151
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationColorBalance"		-Value 0x59
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorizationGlassAttribute"	-Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "ColorPrevalence"	-Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "Composition"		-Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableAeroPeek"	-Value 0x1
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\DWM" -Name "EnableWindowColorization"	-Value 0x1

# --------------------------------------------------------------------------------------------------------------------- #

# Turn off Stickey Keys shortcuts
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\Keyboard Response"	-Name "Flags"	-Value 122
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\StickyKeys"			-Name "Flags"	-Value 506
Set-ItemProperty -Path "HKCU:\Control Panel\Accessibility\ToggleKeys"			-Name "Flags"	-Value 506

# Disallow shake to minimise all windows
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisallowShaking" -Value 1

# Desktop Settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideIcons" -Value 1

# Explorer Settings
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent"	-Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent"	-Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt"		-Value 0
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden"			-Value 1
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSizeMove"	-Value 1

# Disable Cortana
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0

# Disable OneDrive
if (!(Test-Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows")) {
    New-Item -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows" -Name "OneDrive"
}
Set-ItemProperty -Path "HKLM:\HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Value 1
