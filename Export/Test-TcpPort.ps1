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
            return $False
        }

        $TcpClient = New-Object Net.Sockets.TcpClient

        Write-Verbose "Connecting to $IpAddress on TCP Port $Port"
        Try {
            $TcpClient.Connect($IpAddress, $Port)
        }
        Catch {
            return $False
        }

        If ($TcpClient.Connected) {
            Write-Verbose "Connection successful to $ComputerName ($IpAddress) on TCP Port $Port"
            $TcpClient.Close()
            return $True
        }
        Else {
            return $False                                 
        }

    }

}