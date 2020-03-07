# get users contacts files

$ping_response = 0 

while ($ping_response -eq 0) {
    # test cm01 for connection
    if ((Test-Connection cm01.local.domain -quiet) -ne $True) {
    Write-Output "cm01 not respoding"
    Start-Sleep -Seconds 5
    } else {
        # exclude user we don't want
        $users = Get-ChildItem c:\users | Where-Object -FilterScript {$_.Name -notlike "*default*" -And $_.Name -ne "Public" -And $_.Name -notlike "*admin*"}
        $csv = foreach ($user in $users) {
            $user2 = $user -replace '\.',' '
            # check if contacts folder exist to exclude redirect users 
            if ((Test-Path "C:\users\$user\contacts") -And (Get-ChildItem "C:\users\$user\contacts" | Measure-Object).count -gt 0) {
                $contacts = Get-ChildItem c:\users\$user\contacts -Recurse | Where-Object -FilterScript {$_.Name  -notlike "*$user2*" -And $_.name -notlike "*Admin*" -and $_.name -notlike "*$user*" -and $_.name -notlike "*adm*"}
                if (($contacts | Measure-Object).count -gt 0) {
                    "string" | Select-Object @{N='PC';E={$env:computername}}, @{N='User';E={$user}}, @{N='cont count';E={($contacts | measure-object).count}}
                }
                
            } else {
                
            }
        }
        # export csv 
        if ($csv -ne $null) {
            $csv | export-csv "\\cm01\Inventuur$\contacts\$env:computername.csv" -UseCulture -NoTypeInformation
            Write-Output "CSV exported"
        } else {
            Write-Output "no contacts files"
        }
        $ping_response = 1
    }
}