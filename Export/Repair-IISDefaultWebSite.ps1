Function Repair-IISDefaultWebSite {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$False)]
        [Switch]
        $Force = $False
    )

    process {

        # Check if the required Module is installed on the System
        If (Get-Module -ListAvailable -Name WebAdministration) {

            Import-Module WebAdministration

            # Check if the Default Web Site is present
            If (Get-Website | Where-Object { $_.Name -eq "Default Web Site"}) {

                Write-Verbose "Default Web Site is present"

                # If the -Force Argument was given, forcefully delete it
                If ($Force) {

                    Write-Verbose "Deleting Default Web Site"

                    Try {
                        Remove-WebSite -Name "Default Web Site"
                    }
                    Catch {
                        return $False
                    }
                }
            }

            # Check again, if the Default Web Site is present
            If (-not (Get-Website | Where-Object { $_.Name -eq "Default Web Site"})) {

                Write-Verbose "Default Web Site is missing"
                Write-Verbose "Recreating Default Web Site"

                # Recreate it if it is missing
                Try {
                    New-WebSite -Name "Default Web Site" -Port 80 -PhysicalPath "%SystemDrive%\inetpub\wwwroot" -Id 1
                }
                Catch {
                    return $False
                }
            }
            Else {
                return $True
            }

        }
        Else {
            Write-Verbose "WebAdministration Module is not installed on this System!"
            return $False
        }

        return $True

    }

}