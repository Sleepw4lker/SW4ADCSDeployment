Function Test-TcpPort {
    
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $ComputerName,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Port
    )

    process {
        
        Write-Verbose "Resolving $ComputerName"
        Try {
            $IpAddress = (Resolve-DnsName $ComputerName | Where-Object { $_.Type -eq "A" } | Select-Object -First 1).IPAddress
        } 
        Catch {
            $False
        }

        $TcpClient = New-Object Net.Sockets.TcpClient

        Write-Verbose "Connecting to $IpAddress on TCP Port $Port"
        Try {
            $TcpClient.Connect($IpAddress, $Port)
        }
        Catch {
            $False
        }

        If ($TcpClient.Connected) {
            Write-Verbose "Connection successful to $ComputerName ($IpAddress) on TCP Port $Port"
            $TcpClient.Close()
            $True
        }
        Else {
            $False                                 
        }

    }

}