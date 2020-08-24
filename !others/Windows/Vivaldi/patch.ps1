$fileToCheck = "$($env:LOCALAPPDATA)\Vivaldi\Application\vivaldi.exe"
if (Test-Path $fileToCheck -PathType leaf) {
    $vivaldibasepath = "$($env:LOCALAPPDATA)\Vivaldi\Application"
} else {
	# Start as admin in this case
	if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
		$CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
		Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
		Exit
	}
    $vivaldibasepath = "C:\Program Files (x86)\Vivaldi\Application"
}

$FileNames = Get-ChildItem -Path $vivaldibasepath -Directory
$vivaldibasepath = -join($vivaldibasepath, "\", $FileNames[0].Name, "\resources\vivaldi\style")

$vivaldicommoncsspath = -join ($vivaldibasepath, "\common.css")
$vivaldicustomcsspath = -join ($vivaldibasepath, "\custom.css")

$vivaldicommoncss = Get-Content $vivaldicommoncsspath
Set-Content -Path $vivaldicommoncsspath -Value '@import "custom.css";', $vivaldicommoncss
Copy-Item .\custom.css $vivaldicustomcsspath
write-host "Done!"
