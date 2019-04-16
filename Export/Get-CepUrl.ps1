Function Get-CepUrl {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Fqdn,

        [Parameter(Mandatory=$True)]
        [ValidateSet(
            "Password",
            "PasswordKeyBasedRenewal",
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
                $CepUrl = "https://$($Fqdn)/ADPolicyProvider_CEP_UsernamePassword/service.svc/CEP"
            }
            "PasswordKeyBasedRenewal" {
                $CepUrl = "https://$($Fqdn)/KeyBasedRenewal_ADPolicyProvider_CEP_UsernamePassword/service.svc/CEP"
            }
            "Kerberos" {
                $CepUrl = "https://$($Fqdn)/ADPolicyProvider_CEP_Kerberos/service.svc/CEP"
            }
            "Certificate" {
                $CepUrl = "https://$($Fqdn)/ADPolicyProvider_CEP_Certificate/service.svc/CEP"
            }
            "CertificateKeyBasedRenewal" {
                $CepUrl = "https://$($Fqdn)/KeyBasedRenewal_ADPolicyProvider_CEP_Certificate/service.svc/CEP"
            }
        }

        $CepUrl
    }

}