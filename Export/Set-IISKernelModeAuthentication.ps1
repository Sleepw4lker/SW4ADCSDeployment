Function Set-IISKernelModeAuthentication {

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

            Import-ModuleOnDemand WebAdministration

            $Filter = "/system.webServer/security/authentication/windowsAuthentication"
            $Name = "useKernelMode"

            If (-not $Disable) {
                # Enable the Setting if not set
                $DesiredSetting = $True
                $UndesiredSetting = "False"
            } Else {
                # Enable the Setting if set
                $DesiredSetting = "False"
                $UndesiredSetting = $True
            }

            If ($UndesiredSetting -eq (Get-WebConfigurationProperty -Filter $Filter -Name $Name -PSPath IIS: -Location $Location).Value) {

                Write-Verbose "Configuring Kernel Mode Authentication for $Location to $DesiredSetting"

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