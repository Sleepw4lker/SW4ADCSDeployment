Function New-OCSPResponderDeployment {

    [cmdletbinding()]
    param(
    )

    process {

        Write-Verbose "Installing Online Responder Role with default Settings"

        Import-Module ServerManager

        Try {
            Add-WindowsFeature ADCS-Device-Enrollment -IncludeManagementTools
        }
        Catch {
            return $False
        }
    
        Try {
            Install-AdcsOnlineResponder -Force
        }
        Catch {
            return $False
        }

        $True
        
    }

}