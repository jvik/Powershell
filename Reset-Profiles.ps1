<#
.SYNOPSIS
  Renews all user profiles in Windows
.DESCRIPTION
  Script helps out with removing corrupt local user profiles with pattern matching.
  The script removes both profile folder in c:\users and registry key associated with the profile.
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
$registryarray = @()

foreach ($user_item in $profile_list) {
     $user_list = Get-ChildItem -Path $user_item
     foreach ($registry_user_path in $user_list) {
        # Path is returned with HKEY_LOCAL_MACHINE prefix, while the powershell registry-cmdlets takes in HKLM:-prefix. 
        # Line below fixes this.
        $registry_user_path = $registry_user_path -replace 'HKEY_LOCAL_MACHINE', 'HKLM:'
        $user_profile_path = Get-ItemPropertyValue -Path $registry_user_path -Name ProfileImagePath
        $registryarray += New-Object psobject -Property @{'RegistryPathName' = $registry_user_path; 'ProfilePath' = $user_profile_path}
     }    
}

foreach ($profile in $registryarray) {
  # Regex demands 3 digits in username to recreate profile. Use pattern of own choice.
  if ($profile.ProfilePath -match "\d{3}") {
      Remove-Item -Path $profile.RegistryPathName -recurse -Force | Out-file c:\temp\deleteprofiles.txt -Append
      Remove-Item -Path $profile.ProfilePath -recurse -Force | Out-file c:\temp\deleteprofiles.txt -Append
      Write-Host Deleting: $profile.ProfilePath 
    }
}