
# picture array
$pictures = @("calendar_1.jpg", "calendar_2.jpg", "calendar_3.jpg", "calendar_4.jpg")

# copy pictures 
$pictures | ForEach-Object {
  Copy-Item "$SCRIPTDIRECTORY\$PSItem" "$env:windir\Web\Wallpaper\Theme1" -Force
}

# get the date and return the right picture name
$quarter = switch(Get-Date -UFormat %m) {

{$PSItem -in 1..3} 
{
    $pictures[0]
}

{$PSItem -in 4..6} 
{
    $pictures[1]
}

{$PSItem -in 7..9} 
{
    $pictures[2]
}

default {$pictures[3]}
}

$UserProfiles = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\*" | 
Where {$_.PSChildName -match "S-1-5-21-(\d+-?){4}$" } | Select-Object @{Name="SID"; Expression={$_.PSChildName}}, @{Name="UserHive";Expression={"$($_.ProfileImagePath)\NTuser.dat"}}

Foreach ($UserProfile in $UserProfiles) {
    # load user registry file, if it's not already loaded
    If (($ProfileWasLoaded = Test-Path Registry::HKEY_USERS\$($UserProfile.SID)) -eq $false) {
        Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE LOAD HKU\$($UserProfile.SID) $($UserProfile.UserHive)" -Wait -WindowStyle Hidden
    }
}

$UserProfiles | ForEach-Object {
$set_picture = Get-ItemPropertyvalue -path "hku:\$($psitem.sid)\control panel\desktop\" -name wallpaper
if (!(($pictures.ForEach({"$env:windir\web\wallpaper\theme1\" + $_})) -contains($set_picture))) {
    Write-Output "User has changed the wallpaper"
} else {
    if ($set_picture -eq "$env:windir\Web\Wallpaper\Theme1\$quarter") {
        "Right picture already set"
    } else {
Set-ItemProperty -Path "HKU:\$($psitem.sid)\Control Panel\Desktop\" -Name Wallpaper -Value "$env:windir\Web\Wallpaper\Theme1\$quarter" -Force | Out-Null
Set-ItemProperty -Path "HKU:\$($psitem.sid)\Control Panel\Desktop\" -Name WallpaperOriginX -Value "0" -Force | Out-Null
Set-ItemProperty -Path "HKU:\$($psitem.sid)\Control Panel\Desktop\" -Name WallpaperOriginY -Value "0" -Force | Out-Null
Set-ItemProperty -Path "HKU:\$($psitem.sid)\Control Panel\Desktop\" -Name TileWallpaper -Value "0" -Force | Out-Null
Set-ItemProperty -Path "HKU:\$($psitem.sid)\Control Panel\Desktop\" -Name WallpaperStyle -Value "2" -Force | Out-Null
write-output "wallpaper changed"
}
}
}

If ($ProfileWasLoaded -eq $false) {
    [gc]::Collect()
    Start-Sleep 3
    Start-Process -FilePath "CMD.EXE" -ArgumentList "/C REG.EXE UNLOAD HKU\$($UserProfile.SID)" -Wait -WindowStyle Hidden | Out-Null
}
