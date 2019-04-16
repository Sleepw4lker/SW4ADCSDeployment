Function Test-AdcsServiceAvailability {

    # Checks the availability of the ICertAdmin2 interface on the local System
    # Returns $True if the Interface is available and $False if not
    # shamelessly taken from https://gallery.technet.microsoft.com/scriptcenter/Certificate-Authority-0c39cb4a

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $ConfigString
    )

    process {

        # Not specifying the ConfigString means we try to query the local CA
        If (-not $ConfigString) {

            # First we try to get the ICertAdmin2 Interface
            Try {

                <#
                    https://docs.microsoft.com/en-us/windows/desktop/api/certcli/nf-certcli-icertconfig-getconfig

                    The GetConfig method retrieves the configuration string for a Certificate Services server. 
                    This method was first defined in the ICertConfig interface.

                    CC_DEFAULTCONFIG / 0x00000000: Retrieves the default certification authority.
                    CC_FIRSTCONFIG / 0x00000002: Returns the first certification authority.
                    CC_LOCALACTIVECONFIG / 0x00000004: Retrieves the local certification authority if it is running.
                    CC_LOCALCONFIG / 0x00000003: Retrieves the local certification authority.
                    CC_UIPICKCONFIG / 0x00000001: Displays a user interface that allows the user to select a 
                        certification authority.
                    CC_UIPICKCONFIGSKIPLOCALCA / 0x00000005: Displays a user interface that allows the user to select 
                        a certification authority. The UI excludes any local certification authority. This exclusion 
                        is useful during subordinate certification authority certificate renewal when the subordinate 
                        certification authority certificate request is submitted to a certification authority other 
                        than the current certification authority. 
                #>

                Write-Verbose "Trying to get Configuration String of local Certification Authority"

                $CertConfig = New-Object -ComObject CertificateAuthority.Config
                $ConfigString = $CertConfig.GetConfig(3)

            }
            Catch  {
                $False
            }

        }

        # Try to build the ICertAdmin Interface
        Try {
            Write-Verbose "Trying to build the ICertAdmin Interface"
            $CertAdmin = New-Object -ComObject CertificateAuthority.Admin.1
        }
        Catch {
            $False
        }

        # Try to do a Query over the Interface
        Try {
            Write-Verbose "Trying to do a Query against $ConfigString"
            [void]$CertAdmin.GetCAProperty(
                $ConfigString,
                0x6,
                0,
                4,
                0
            )
            $True
        }
        Catch {
            $False
        }

    }

}