Function Get-CesUrl {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Fqdn,

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
                $CesUrl = "https://$($Fqdn)/$($CommonName.Replace(" ", "%20"))_CES_UsernamePassword/service.svc/CES"
            }
            "Kerberos" {
                $CesUrl = "https://$($Fqdn)/$($CommonName.Replace(" ", "%20"))_CES_Kerberos/service.svc/CES"
            }
            "Certificate" {
                $CesUrl = "https://$($Fqdn)/$($CommonName.Replace(" ", "%20"))_CES_Certificate/service.svc/CES"
            }
            "CertificateKeyBasedRenewal" {
                $CesUrl = "https://$($Fqdn)/$($CommonName.Replace(" ", "%20"))_CES_Certificate/service.svc/CES"
            }
        }
        
        $CesUrl
    }

}