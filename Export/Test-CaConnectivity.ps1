Function Test-CaConnectivity {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $ComputerName
    )

    process {

        # How to test high Ports...?
        135,445 | ForEach-Object {

            Write-Verbose "Testing Connectivity to $ComputerName on Port $($_)"

            If ((Test-TcpPort -ComputerName $ComputerName -Port $_) -ne $True) {
                return $False
            }
    
        }

        return $True

    }

}