Function Remove-OCSPRevocationConfiguration {
    
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

        # The DeleteCAConfiguration method removes a named certification authority (CA) configuration from the configuration set.
        $NewConfig = $OcspAdmin.OCSPCAConfigurationCollection.DeleteCAConfiguration(
            $Name
        )
        
        # Commit the new configuration to the server
        $OcspAdmin.SetConfiguration(
            $ComputerName,
            $True
        ) 
        
        $True       

    }

}