Function Test-DomainConnectivity {

    # Test Connectivity to my own Domain and to Forest Root Domain

    [CmdletBinding()]
    param ()

    process {

        Try {
            $MyDomainName = (Get-WmiObject Win32_ComputerSystem).Domain
        }
        Catch {
            $False
        }

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

        $ForestRootDomainName = $ForestRootDomain.DNSroot

        Get-ADDomainController | Where-Object { ($_.Domain -eq $ForestRootDomainName) -or ($_.Domain -eq $MyDomainName) } | ForEach-Object  {

            $ComputerName = $_.HostName

            Write-Verbose "Testing Connectivity to $ComputerName on Port $($_)"

            # How to test high Ports...?
            88,135,389,445 | ForEach-Object {

                If ((Test-TcpPort -ComputerName $ComputerName -Port $_) -ne $True) {
                    $False
                }

            }

        }

        $True

    }

}