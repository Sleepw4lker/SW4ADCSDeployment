Function Get-CepCesAuthenticationMethodFriendlyName {

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
                $FriendlyName = "User Name and Password"
            }
            "PasswordKeyBasedRenewal" {
                $FriendlyName = "User Name and Password with Support for Key based Renewal"
            }
            "Kerberos" {
                $FriendlyName = "Kerberos"
            }
            "Certificate" {
                $FriendlyName = "Client Certificate"
            }
            "CertificateKeyBasedRenewal" {
                $FriendlyName = "Client Certificate with Support for Key based Renewal"
            }
        }

        $FriendlyName

    }

}