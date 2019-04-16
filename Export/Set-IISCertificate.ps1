Function Set-IISCertificate {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $Site = "Default Web Site",

        [Parameter(Mandatory=$True)]
        [ValidateScript({Test-Path Cert:\LocalMachine\My\$($_)})]
        [String]
        $Thumbprint,

        [Parameter(Mandatory=$False)]
        [Switch]
        $Force = $False

    )

    process {


        # Check if the required Module is installed on the System
        If (Get-Module -ListAvailable -Name WebAdministration) {

            Import-Module WebAdministration

            If ($Force) {

                If (Get-WebBinding -Name $Site -Protocol https)  {

                    Write-Verbose "Deleting previous SSL Binding on $Site"

                    Try {
                        Remove-WebBinding -Name $Site -Protocol https
                    }
                    Catch {
                        $False
                    }

                }

            }

            If (-not (Get-WebBinding -Name $Site -Protocol https))  {

                Write-Verbose "Creating new SSL Binding for $Site"

                Try {
                    # SslFlags = 0 means no SNI... as this is the Default Web Site we won't need it
                    New-WebBinding -Name $Site -Protocol https -Port 443 -SslFlags 0
                }
                Catch {
                    $False
                }
            }

            Try {
                $IisSslBinding = Get-WebBinding -Name $Site -Protocol https
            }
            Catch {
                $False
            }

            Write-Verbose "Adding Certificate with $Thumbprint to https Binding on $Site"

            Try {
                $IisSslBinding.AddSslCertificate($Thumbprint, "my")
                $True
            }
            Catch {
                $False
            }
        }
        Else {
            Write-Verbose "WebAdministration Module is not installed on this System!"
            $False
        }
    }
}