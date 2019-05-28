function New-OCSPRevocationConfigurationFromAD {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $CertificateTemplate
    )
    
    process {

        Import-Module ActiveDirectory
        $DsConfigDN = "CN=Configuration,$($(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).DistinguishedName)"

        # Dumping CA Certificates
        Get-ChildItem "AD:CN=Enrollment Services,CN=Public Key Services,CN=Services,$DsConfigDN" | Foreach-Object {

            $CaName = $_.Name
            $DnsHostName = $(Get-ADObject $_ -Properties dNSHostName).dNSHostName

            $ConfigString = "$DnsHostName\$CaName"
            $CaExchangeCertificateObject = Get-CAExchangeCertificateFromCA -ConfigString $ConfigString

            $CDP = @()

            (($CaExchangeCertificateObject.Extensions | Where-Object { $_.Oid.Value -eq "2.5.29.31" }).Format(1)).split([char]10) | ForEach-Object {
                If ($_ -match "URL=") {
                    $CDP += $_.replace("URL=","").trim()
                }
            }

            $i = 0

            $(Get-ADObject $_ -Properties cACertificate).cACertificate | Foreach-Object {

                # We load the Certificate into an X509Certificate2
                $CaCertificateObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
                $CaCertificateObject.Import($_)
                
                New-OCSPRevocationConfiguration `
                    -Name "$CaName ($i)" `
                    -ConfigString $ConfigString `
                    -CaCertificate $CaCertificateObject `
                    -Cdp $CDP `
                    -CertificateTemplate $CertificateTemplate

                $i++

            }

        }

    }

}