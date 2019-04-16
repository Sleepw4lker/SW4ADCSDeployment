Function Set-IISAppPoolIdentity {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateScript({Test-Path IIS:\AppPools\$($_)})]
        [String]
        $AppPool,
    
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $UserName,

        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $Password
    )

    process {

        # Check if the required Module is installed on the System
        If (Get-Module -ListAvailable -Name WebAdministration) {

            Import-Module WebAdministration

            Write-Verbose "Configuring $AppPool Application Pool Identity to $UserName"
            
            # IdentityType = 3 Specifies that the application pool runs under a custom identity, which is configured by using the userName and password attributes.
            # https://docs.microsoft.com/en-us/iis/configuration/system.applicationhost/applicationpools/add/processmodel

            If ($Password) {

                Try {

                    Set-ItemProperty IIS:\AppPools\$AppPool `
                        -name processModel `
                        -value @{userName="$($UserName)";password="$($Password)";identitytype=3}

                    $True

                } 
                Catch {
                    $False
                }

            }
            Else {

                Try {

                    Set-ItemProperty IIS:\AppPools\$AppPool `
                        -name processModel `
                        -value @{userName="$($UserName)";identitytype=3}

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