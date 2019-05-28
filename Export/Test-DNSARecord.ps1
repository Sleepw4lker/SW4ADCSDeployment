Function Test-DnsARecord {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidatePattern("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$")]
        [String]
        $Record,

        [Parameter(Mandatory=$False)]
        [Switch]
        $CheckLocal
    )

    process {

        $DnsCheck = Resolve-DnsName $Record
        $Result = $False

        If ($DnsCheck) {

            # Filtering out all invalid Records
            $ValidRecords = $DnsCheck | Where-Object { ($_.Type -eq "A") -or ($_.Type -eq "AAAA") }

            # If the Variable Contains Data, we have valid records
            $ValidRecords | ForEach-Object {

                # We may wynt to match this against one of our local IP addresses
                If ($CheckLocal) {

                    $DnsIP = $_.IPAddress

                    # We loop through our local Addresses
                    (Get-NetIPAddress).IPAddress | ForEach-Object {
                        # If we find any match, we're done
                        # We use the match operator in the hope that it will work with IPv6 as well 
                        # (not tested - Ipv6 addresses have an Interface Identifier %something)
                        If ($DnsIP -match $_) {
                            $Result = $True
                        }
                    }

    
                }
                Else {
                    # If we do not verify against the local IPs, we're done
                    $Result = $True
                }

            }

        }

        return $Result

    }

}