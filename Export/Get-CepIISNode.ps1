Function Get-CepIisNode {

    [cmdletbinding()]
    param (
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
                $IisNode = "ADPolicyProvider_CEP_UsernamePassword"
            }
            "PasswordKeyBasedRenewal" {
                $IisNode = "KeyBasedRenewal_ADPolicyProvider_CEP_UsernamePassword"
            }
            "Kerberos" {
                $IisNode = "ADPolicyProvider_CEP_Kerberos"
            }
            "Certificate" {
                $IisNode = "ADPolicyProvider_CEP_Certificate"
            }
            "CertificateKeyBasedRenewal" {
                $IisNode = "KeyBasedRenewal_ADPolicyProvider_CEP_Certificate"
            }
        }

        $IisNode
    }

}