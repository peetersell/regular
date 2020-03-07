# Adobe Acrobat protected view
$iprotectedview = (Get-ItemProperty -Path 'hklm:\software\WOW6432Node\policies\adobe\acrobat reader\dc\featurelockdown' -ErrorAction SilentlyContinue).iProtectedView
if ($iprotectedview -ge 1) {
    Write-Output "protected view on"
} else {
    Write-Output "protected view off"
}

Set-ItemProperty -Path 'hklm:\software\WOW6432Node\policies\adobe\acrobat reader\dc\featurelockdown' -Name iProtectedView -Value 0