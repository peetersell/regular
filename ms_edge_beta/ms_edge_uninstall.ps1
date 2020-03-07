$unins = ((Get-ItemProperty -path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*\") | where-object {$_.displayname -like "*Microsoft Edge Beta*"}).uninstallstring + " /q"
cmd /c "$unins"
