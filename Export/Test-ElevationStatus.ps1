Function Test-ElevationStatus {

    [cmdletbinding()]
    param()

    process {

        If(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Verbose "User is a local Administrator"
            $True
        }
        Else {
            Write-Verbose "User is NOT a local Administrator"
            $False
        }
    }
}