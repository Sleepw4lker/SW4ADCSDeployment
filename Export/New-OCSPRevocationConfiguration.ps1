Function New-OCSPRevocationConfiguration {
    
    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Name,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $ComputerName = $env:computername,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $ConfigString,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [System.Security.Cryptography.X509Certificates.X509Certificate]
        $CaCertificate,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String[]]
        $Cdp,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $CertificateTemplate,

        [Parameter(Mandatory=$False)]
        [ValidateSet("MD2","MD4","MD5","SHA1","SHA256","SHA384","SHA512")]
        [String]
        $SignatureHashAlgorithm = "SHA256",

        [Parameter(Mandatory=$False)]
        [ValidateRange(5,1440)]
        [int16]
        $RefreshTimeout, # in Minutes

        [Parameter(Mandatory=$False)]
        [Switch]
        $Force = $False

    )

    process {

        # https://docs.microsoft.com/en-us/windows/desktop/api/certadm/nn-certadm-iocspcaconfiguration
        # https://www.sysadmins.lv/blog-en/managing-online-responders-ocsp-with-powershell-part-3.aspx
        # https://social.technet.microsoft.com/wiki/contents/articles/12167.ocsp-powershell-script.aspx

        <# To Do:
         - Proceed only when there is no Configuration with the same name
         - Add a -Force Parameter to delete any Configuriation with the same Name
         - Get Common Name and probably the CA Version from the given CA Certificate
         - Verify if the %20 Stuff is necessary in the CDP Urls, and add it if so
         - Remove Spaces from the Certificate Template Name
         - Check if the CA is online for enrollment
         - Check if the CA has the specified Template bound
         - Add Support for specifying a Signer Certificate instead of automatically enrolling for it
        #>

        If (Test-OCSPRevocationConfiguration -Name $Name -ComputerName $ComputerName) {

            If ($Force.IsPresent) {
                Write-Verbose "Deleting Configuration with Name $Name"
                [void](Remove-OCSPRevocationConfiguration -Name $Name -ComputerName $ComputerName)
            }
            Else {
                Write-Error "There is already a Configuration defined with the Name $Name. Try using the -Force Argument to overwrite it."
                return
            }

        }

        # Save the desired OcspProperties in a collection object
        $OcspProperties = New-Object -ComObject "CertAdm.OCSPPropertyCollection"

        [void]$OcspProperties.CreateProperty(
            "BaseCrlUrls",
            $Cdp
        )

        [void]$OcspProperties.CreateProperty(
            "RevocationErrorCode",
            0
        )

        # If no Refresh Timeout is specified, the Revocation Configuration will update the CRLs based on their validity periods
        If ($RefreshTimeout) {

            # Sets the refresh interval (time is specified in milliseconds)
            [void]$OcspProperties.CreateProperty(
                "RefreshTimeOut",
                ($RefreshTimeout * 60 * 1000)
            )

        }

        # Save the current configuration in an OcspAdmin object
        $OcspAdmin = New-Object -ComObject "CertAdm.OCSPAdmin"

        $OcspAdmin.GetConfiguration(
            $ComputerName,
            $True
        )

        # The CreateCAConfiguration method creates a new certification authority (CA) configuration and adds it to the configuration set.
        $NewConfig = $OcspAdmin.OCSPCAConfigurationCollection.CreateCAConfiguration(
            $Name,
            $CaCertificate.GetRawCertData()
        )

        $NewConfig.HashAlgorithm = $SignatureHashAlgorithm
        $NewConfig.SigningFlags = 0x294
        $NewConfig.CAConfig = $ConfigString
        $NewConfig.SigningCertificateTemplate = $CertificateTemplate
        $NewConfig.ProviderProperties = $OcspProperties.GetAllProperties()
        $NewConfig.ProviderCLSID = "{4956d17f-88fd-4198-b287-1e6e65883b19}"
        $NewConfig.ReminderDuration = 90

        Try {

            # Commit the new configuration to the server
            $OcspAdmin.SetConfiguration(
                $ComputerName,
                $True
            )

        }
        Catch {
            $False
        }

        $True

    }

}