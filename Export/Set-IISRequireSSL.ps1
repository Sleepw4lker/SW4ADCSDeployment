Function Set-IISRequireSSL {

    [cmdletbinding()]
    param(

        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $Location = "Default Web Site",

        [Parameter(Mandatory=$False)]
        [Switch]
        $Disable = $False
    )

    process {

        # Check if the required Module is installed on the System
        If (Get-Module -ListAvailable -Name WebAdministration) {

            Import-Module WebAdministration

            $Filter = "/system.webServer/security/access"
            $Name = "sslFlags"

            If (-not $Disable) {
                # Enable the Setting if not set
                $DesiredSetting = "Ssl"
                $UndesiredSetting = 0
            } Else {
                # Enable the Setting if set
                $DesiredSetting = 0
                $UndesiredSetting = "Ssl"
            }

            If ($UndesiredSetting -eq (Get-WebConfigurationProperty -Filter $Filter -Name $Name -PSPath IIS: -Location $Location).Value) {

                Write-Verbose "Setting SSL to required for $Location"

                Try {
                    Set-WebConfigurationProperty `
                        -Filter $Filter `
                        -Name $Name `
                        -Value $DesiredSetting `
                        -PSPath IIS: `
                        -Location $Location

                    $True
                }
                Catch {
                    $False
                }
            }
        }
        Else {
            Write-Verbose "WebAdministration Module is not installed on this System!"
            $False
        }

    }

}