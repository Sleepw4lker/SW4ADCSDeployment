Function Test-EnterpriseAdministratorPermissions {

    [cmdletbinding()]
    param()

    process {

        # Check if the PowerShell Module is installed, if not, install it!
        If ((Get-WindowsFeature "RSAT-AD-Powershell").Installed -eq $False) {

            Write-Verbose "Installing Active Directory Powershell Module."

            Try {
                Add-WindowsFeature "RSAT-AD-Powershell"
            }
            Catch {
                $False
            }
        }

        Import-Module "ActiveDirectory"

        Try {
            # Get Forest Root Domain
            # we need this for the next queries
            $ForestRootDomain = $(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain)
        }
        Catch {
            $False
        }

        $DomainSid = $ForestRootDomain.DomainSID
        $EnterpriseAdminsGroup = "$($DomainSid)-519"

        # Check Permissions of Current User
        $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
        $GroupMemberships = $CurrentUser.Groups.Value

        If ($GroupMemberships -contains $EnterpriseAdminsGroup) {
            Write-Verbose "User is Member of Enterprise Administrators!"
            $True
        } Else {
            Write-Verbose "User is not Member of Enterprise Administrators!"
            $False
        }

    }
}