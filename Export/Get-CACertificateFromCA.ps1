function Get-CACertificateFromCA {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $ConfigString
    )

    process {

                # https://www.sysadmins.lv/blog-en/introducing-to-certificate-enrollment-apis-part-3-certificate-request-submission-and-response-installation.aspx
        # https://docs.microsoft.com/en-us/windows/desktop/api/certcli/nf-certcli-icertrequest-getcacertificate
        $CertRequest = New-Object -ComObject CertificateAuthority.Request

        $CaCertificate = $CertRequest.GetCACertificate(
            [int]$False,
            $ConfigString,
            1
        )

        # We load the Certificate into an X509Certificate2 Object so that we can call Certificate Properties
        $CertificateObject = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
        $CertificateObject.Import([Convert]::FromBase64String($CaCertificate))
        
        # This returns it directly as an X509Certificate2 Object
        $CertificateObject

    }
    
}