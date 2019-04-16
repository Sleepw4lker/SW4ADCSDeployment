Function Test-OCSPRevocationConfiguration {
    
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $ComputerName = $env:computername
    )

    process {

        $OcspAdmin = New-Object -ComObject "CertAdm.OCSPAdmin"

        $OcspAdmin.GetConfiguration(
            $ComputerName,
            $True
        )

        Try {

            # The ItemByName property gets a certification authority (CA) configuration identified by name in the configuration set.
            [void]$OcspAdmin.OCSPCAConfigurationCollection.ItemByName(
                $Name
            )

        }
        Catch {
            $False
        }

        $True

    }

}