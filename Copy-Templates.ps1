$templateCentralStore = \\FJORD1PDC01\system$\office-templates\keolis
$profileLoc = c:\Users\%username%\Documents\Templates

robocopy $templateCentralStore $profileLoc /s /r:1 /w:1

