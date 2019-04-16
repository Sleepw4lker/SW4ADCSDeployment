Function Get-CesIisNode {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $CommonName,

        [Parameter(Mandatory=$True)]
        [ValidateSet(
            "Password",
            "Kerberos",
            "Certificate",
            "CertificateKeyBasedRenewal" 
        )]
        [String]
        $Authentication
    )

    process {

        Switch ($Authentication) {

            "Password" {
                $IisNode = "$($CommonName.Replace(" ", "%20"))_CES_UsernamePassword"
            }
            "Kerberos" {
                $IisNode = "$($CommonName.Replace(" ", "%20"))_CES_Kerberos"
            }
            "Certificate" {
                $IisNode = "$($CommonName.Replace(" ", "%20"))_CES_Certificate"
            }
            "CertificateKeyBasedRenewal" {
                $IisNode = "$($CommonName.Replace(" ", "%20"))_CES_Certificate"
            }
        }

        $IisNode
    }

}