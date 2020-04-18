Add-Type -AssemblyName PresentationCore,PresentationFramework
$ErrorActionPreference = "Stop"

# because PowerShell by default uses TLS 1.0 for web requests, we force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# invoke webrequest is dependent on internet explorers first run configuration. to get the cmdlet working, we need to bypass it by setting a registry key.
# more info: https://stackoverflow.com/questions/38005341/the-response-content-cannot-be-parsed-because-the-internet-explorer-engine-is-no
$current_value = Get-ItemPropertyvalue -path "hklm:\software\microsoft\internet explorer\main" -name "disablefirstruncustomize"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "disablefirstruncustomize" -value 2

# error handling function
function handle_error($cmdlet, $returned_error) {      
    $errormsg = "$cmdlet `n Returned an error:  `n `n $returned_error"
    [System.Windows.MessageBox]::Show($errormsg)
    break
}

try {
    $webresponse = invoke-webrequest "https://www.microsoftedgeinsider.com/en-us/enterprise" -ErrorAction Stop
    $button = $webresponse.parsedhtml.getelementsbytagname('button') | Where-Object {$_.classname -like "dl-download-button*"} | Where-Object textContent -like "*64-bit MSI for Windows*"
    $downl_url = $button.getAttribute('data-download-url')
    
    # download the msi 
    Invoke-WebRequest -Uri $downl_url -OutFile c:\windows\temp\ms_edge_beta.msi
}
catch {
    handle_error ($error.InvocationInfo.line | select-object -first 1) ($error.exception.message | select-object -first 1)
}

# get the download url for edge msi

#install it and delete the shortcut from public desktop
cmd.exe /c 'start /wait msiexec /i "C:\windows\temp\ms_edge_beta.msi" /q && del "c:\users\public\desktop\microsoft edge beta.lnk"'
del C:\windows\temp\ms_edge_beta.msi

# if the IE reg key already existed, change it back to its previous value. if not, delete it.
if ($current_value) {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "disablefirstruncustomize" -value $current_value
} else {
    Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Internet Explorer\Main" -Name "disablefirstruncustomize"
}
