Function Add-IISWebServerRole {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$False)]
        [Switch]
        $Force = $False
    )

    process {

        Import-Module ServerManager

        If ($Force) {
            If ($True -eq (Get-WindowsFeature Web-Server).Installed) {

                Write-Verbose "Removing Web Server Role"

                Try {
                    Remove-WindowsFeature WebServer
                    $True
                }
                Catch {
                    $False
                }
                
            }       
        }

        If ($False -eq (Get-WindowsFeature Web-Server).Installed) {
            Write-Verbose "Installing Web Server Role"

            Try {
                Add-WindowsFeature WebServer -IncludeManagementTools
                $True
            }
            Catch {
                $False
            }
        }

    }

}