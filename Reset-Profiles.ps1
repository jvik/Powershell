<#
.SYNOPSIS
  Renews all user profiles in Windows
.DESCRIPTION
  <Brief description of script>
.INPUTS
  None
.OUTPUTS
  Log file stored in c:\temp\deleteprofiles.txt
.NOTES
  Version:        1.0
  Author:         Jørgen Vik
  Creation Date:  19.02.2018
  Purpose/Change: Initial script development
  
.EXAMPLE
  ./Reset-Profiles.ps1
#>

$profile_list = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList'

foreach ($user_item in $profile_list) {
     $user_list = Get-ChildItem -Path $user_item
     foreach ($registry_user_path in $user_list) {
        # Path is returned with HKEY_LOCAL_MACHINE prefix, while the powershell registry-cmdlets takes in HKLM:-prefix. 
        # Line below fixes problem.
        $registry_user_path = $registry_user_path -replace 'HKEY_LOCAL_MACHINE', 'HKLM:'
        $user_profile_path = Get-ItemPropertyValue -Path $registry_user_path -Name ProfileImagePath
        Remove-Item -Path $registry_user_path -recurse -Force | Out-file c:\temp\deleteprofiles.txt -Append
        Remove-Item -Path $user_profile_path -recurse -Force | Out-file c:\temp\deleteprofiles.txt -Append
        Write-Host Removed: $registry_user_path
        Write-host Removed: $user_profile_path
     }    
}