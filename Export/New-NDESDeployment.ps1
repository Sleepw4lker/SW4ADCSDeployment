Function New-NDESDeployment {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $ConfigString
    )

    process {

        Write-Verbose "Installing NDES Role with default Settings"

        Import-Module ServerManager

        Try {
            Add-WindowsFeature ADCS-Device-Enrollment -IncludeManagementTools
        }
        Catch {
            return $False
        }
    
        Try {
            Install-AdcsNetworkDeviceEnrollmentService `
                -ApplicationPoolIdentity `
                -CAConfig $ConfigString `
                -RAName "$($env:COMPUTERNAME)-MSCEP-RA" `
                -SigningProviderName "Microsoft Strong Cryptographic Provider" `
                -SigningKeyLength 2048 `
                -EncryptionProviderName "Microsoft Strong Cryptographic Provider" `
                -EncryptionKeyLength 2048 `
                -Force

            
        }
        Catch {
            return $False
        }

        return $True
        
    }

}