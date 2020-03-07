Start-Transcript -path "\\cm01\inventuur$\reha\$env:computername.txt" -Append

$deleted_gb_sum = 0
$free_space_before = (get-WmiObject win32_logicaldisk | where-object {$_.deviceid -Like "C:"}).freespace /1GB
Write-Output "Free space before script $free_space_before GB"
function reha {
    param (
    $path
    )
    if (Test-Path $path) {
        takeown /f $path /r /a /d y
        icacls $path /r /grant administrators:f
        $deleted_gb = (Get-ChildItem -Path $path -recurse | Measure-Object Length -sum).Sum /1GB
        Write-Output "$path $deleted_gb GB"
        $script:deleted_gb_sum += $deleted_gb
        remove-item $path -recurse -force    
    } else {
        write-host "$path path does not exist"
    }  
}

function reha2 {
    param (
    $path, $days
    )
    if (test-path $path) {
        $deleted_gb = (Get-ChildItem -Path $path -recurse | Measure-Object Length -sum).Sum /1GB
        Write-Output "$path $deleted_gb GB"
        $script:deleted_gb_sum += $deleted_gb
        Get-ChildItem $path -Recurse | Where-Object {($_.lastwritetime -lt (Get-Date).AddDays($days))} | Remove-Item -Force -Recurse
    } else {
        write-host "$path path does not exist"
    }
}

reha -path "c:\windows.old"
reha -path "c:\minint"
reha -path "c:\_smstasksequence"
reha -path "c:\windows\minidump\*"
reha -path "c:\windows\memory.dmp"
reha -path "C:\Users\Administrator\Downloads\*"

reha2 -path "C:\windows\temp\*" -days -2
reha2 -path "C:\users\*\appdata\local\temp\*" -days -2
reha2 -path "C:\users\*\appdata\local\microsoft\windows\inetcache\*" -days -2
#reha2 -path "C:\users\*\appdata\local\microsoft\windows\temporary internet files\*" -days -2 

$free_space_after = (get-WmiObject win32_logicaldisk | where-object {$_.deviceid -Like "C:"}).freespace /1GB
$deleted2 = $free_space_after - $free_space_before
Write-Output "Free space before script $free_space_before GB, after script $free_space_after GB, deleted $deleted2 GB"
Stop-Transcript

Start-Process cleanmgr -ArgumentList "VERYLOWDISK"

