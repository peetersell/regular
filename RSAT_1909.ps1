# install RSAT from an ISO 


$iso = Mount-DiskImage "\\cm01\sources$\Application Catalog\Software\Microsoft\RSAT\1903_1909 W10_isos\x64\SW_DVD9_NTRL_Win_10_1903_64Bit_MultiLang_FOD_1_X22-01658.ISO" -PassThru
$mount_letter = ($iso | Get-Volume).DriveLetter

$rsat_components = (
"Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0",
"Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0",
"Rsat.CertificateServices.Tools~~~~0.0.1.0",
"Rsat.DHCP.Tools~~~~0.0.1.0",
"Rsat.Dns.Tools~~~~0.0.1.0",
"Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0",
"Rsat.FileServices.Tools~~~~0.0.1.0",
"Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0",
"Rsat.IPAM.Client.Tools~~~~0.0.1.0",
"Rsat.LLDP.Tools~~~~0.0.1.0",
"Rsat.NetworkController.Tools~~~~0.0.1.0",
"Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0",
"Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0",
"Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0",
"Rsat.ServerManager.Tools~~~~0.0.1.0",
"Rsat.Shielded.VM.Tools~~~~0.0.1.0",
"Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0",
"Rsat.StorageReplica.Tools~~~~0.0.1.0",
"Rsat.SystemInsights.Management.Tools~~~~0.0.1.0",
"Rsat.VolumeActivation.Tools~~~~0.0.1.0",
"Rsat.WSUS.Tools~~~~0.0.1.0"
)

$rsat_components | ForEach-Object {
    Add-WindowsCapability -Online -Name $psitem -Source ($mount_letter+":") -LimitAccess
}

dismount-diskimage -imagepath "\\cm01\sources$\Application Catalog\Software\Microsoft\RSAT\1903_1909 W10_isos\x64\SW_DVD9_NTRL_Win_10_1903_64Bit_MultiLang_FOD_1_X22-01658.ISO"