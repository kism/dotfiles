$fileToCheck = "$($env:LOCALAPPDATA)\Vivaldi\Application\vivaldi.exe"
if (Test-Path $fileToCheck -PathType leaf) {
    $vivaldibasepath = "$($env:LOCALAPPDATA)\Vivaldi\Application"
} else {
    $vivaldibasepath = "C:\Program Files (x86)\Vivaldi\Application"
}

$FileNames = Get-ChildItem -Path $vivaldibasepath -Directory
$vivaldibasepath = -join($vivaldibasepath, "\", $FileNames[0].Name, "\resources\vivaldi\style")

$vivaldicommoncsspath = -join ($vivaldibasepath, "\common.css")
$vivaldicustomcsspath = -join ($vivaldibasepath, "\custom.css")

$vivaldicommoncss = Get-Content $vivaldicommoncsspath
Set-Content -Path $vivaldicommoncsspath -Value '@import "custom.css";', $vivaldicommoncss
Copy-Item .\custom.css $vivaldicustomcsspath