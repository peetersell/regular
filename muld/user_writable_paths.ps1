# get user writable program files paths
function get_user_writable {
    param (
        $path
    )
$exclude = "trustedinstaller", "administrators", "application package authority", "nt authority", "creator owner", "nt service"
$local_admins = (Get-LocalGroupMember administrators).name -replace "DESKTOP-QRH2GOL\\",""
$exclude += $local_admins 
$exclude = $exclude -join "|" 
$folders = Get-ChildItem -Directory -Recurse $path | ForEach-Object { $_.FullName }

$output = ForEach ($folder in $folders) { (get-acl $folder).access |  
    Select-Object @{N='user';E={$_.identityreference}}, @{N='Folder';E={$folder}}, @{N='Filesystemrights';E={$_.filesystemrights}} | 
    Where-Object {($_.filesystemrights -match "FullControl|Write|CreateFiles|modify") -and ($_.user -notmatch $exclude)} } 

    $ping_response = 0 
# test connetion with share for file exporting
    while ($ping_response -eq 0) {
    # if the share doesn't ping, sleep for 5 seconds
    if ((Test-Connection share -quiet) -ne $True) {
    Write-Output "share doesnt respond at the moment"
    Start-Sleep -Seconds 5
    } else {
    $output | out-file "\\share\writeable_paths.txt"
    $ping_response = 1
    }
}
}

get_user_writable "C:\Program Files (x86)"
get_user_writable "C:\Program Files" 
