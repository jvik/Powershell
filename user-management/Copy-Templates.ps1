$templateCentralStore = \\FJORD1PDC01\system$\office-templates\keolis
$profileLoc = c:\Users\$env:UserName\Documents\Office-Templates

$directoryInfo = Get-ChildItem $profileLoc | Measure-Object

if ($directoryInfo.Count -eq 0)
{
  robocopy $templateCentralStore $profileLoc /s /r:1 /w:1
}