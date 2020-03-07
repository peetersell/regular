# ad disabled user password change
$users = Get-Content "C:\Users\peeter.kraas\Desktop\Powershell\pw_known_adfs.txt"

foreach ($user in $users) {
    if ((Get-ADUser -filter 'SamAccountName -like $user').enabled -eq $false) {
        $Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | sort {Get-Random})[0..29] -join ''
        Write-output $user
        Write-output $Password
        Set-ADAccountPassword -Identity $user -NewPassword (ConvertTo-SecureString -AsPlainText $Password -Force)
    } else {
        write-host $user "user is enabled in AD"
    }
}
