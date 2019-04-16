Function Remove-NDESDeployment {

    [cmdletbinding()]
    param()

    process {

        Import-Module ServerManager

        If ($True -eq (Get-WindowsFeature ADCS-Device-Enrollment).Installed) {

            Write-Verbose "Removing previously installed NDES Role"
            Try {
                $Result = Remove-WindowsFeature ADCS-Device-Enrollment
                # Success       : True
                # RestartNeeded : Yes
                # ExitCode      : SuccessRestartRequired
            }
            Catch {
                $False
            }
    
            # Deleting the NDES Registry as it won't install if the Key is present
            Try {
                reg delete HKLM\SOFTWARE\Microsoft\Cryptography\MSCEP /F
            }
            Catch {
                # Nothing
            }

            # We should reboot here, just in case... (or catch the RestartRequired Result)
            If ($Result.ExitCode -eq "SuccessRestartRequired") {
                Write-Host "Restart Required, Rebooting 30 Seconds. Press Ctrl-C to cancel..." -ForegroundColor Red
                Start-Sleep -Seconds 30
                Restart-Computer
            }
            Else {
                $True
            }
    
        }
        Else {
            $True
        }

    }

}