Function Test-ElevationStatus {

    [cmdletbinding()]
    param()

    process {

        If(([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
            Write-Verbose "User is a local Administrator"
            return $True
        }
        Else {
            Write-Verbose "User is NOT a local Administrator"
            return $False
        }
    }
}