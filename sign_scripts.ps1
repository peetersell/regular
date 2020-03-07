$cert = dir Cert:\localmachine\My -CodeSigningCert
Set-AuthenticodeSignature "C:\Users\peeter.kraas\Desktop\Powershell\Toast notifications\test\config-toast.xml" -Certificate $cert 