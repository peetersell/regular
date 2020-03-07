

$UserProfiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | 
Where {$_.PSChildName -match "S-1-5-21-(\d+-?){4}$" } | Select-Object @{Name="SID"; Expression={$_.PSChildName}}, @{Name="UserHive";Expression={"$($_.ProfileImagePath)\NTuser.dat"}}

Foreach ($UserProfile in $UserProfiles) {
    # load user registry file, if it's not already loaded
    If (($ProfileWasLoaded = Test-Path Registry::HKEY_USERS\$($UserProfile.SID)) -eq $false) {
        Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE LOAD HKU\$($UserProfile.SID) $($UserProfile.UserHive)" -Wait -WindowStyle Hidden
    }

    $outl_add_in = get-childitem -Path "Registry::hkey_users\*\SOFTWARE\Microsoft\Office\Outlook\Addins\*" | Where-Object {$_.name -like "*teamsaddin*"}
    $teams = (Get-ItemProperty "Registry::hkey_users\*\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\teams")
    if ($null -eq $teams) {
        Write-Output "teams not installed"
        $compliance = "not"
    } elseif ($null -eq $outl_add_in) {
        Write-Output "addin missing"
        $compliance = "not"
    } else {
        $compliance = "both exist"
    } 

    If ($ProfileWasLoaded -eq $false) {
        [gc]::Collect()
        Start-Sleep 3
        Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE UNLOAD HKU\$($UserProfile.SID)" -Wait -WindowStyle Hidden | Out-Null
}
}

$compliance


