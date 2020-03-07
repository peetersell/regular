

Get-WmiObject WmiMonitorID -Namespace root\wmi |
Select @{n="Connected To";e={($_.__Server)}}, @{n="Make_Model";e={[System.Text.Encoding]::ASCII.GetString($_.UserFriendlyName -ne 00)}},
@{n="Serial Number";e={[System.Text.Encoding]::ASCII.GetString($_.SerialNumberID -ne 00)}},@{n="Inventory_Date"; e = {Get-Date -format "dd.MM.yyyy HH:mm"}}

