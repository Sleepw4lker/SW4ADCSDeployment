Function Test-CertificateTemplateBinding  {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $CA,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Template
    )

    process {

        
        # Check if the PowerShell Module is installed, if not, install it!
        If ((Get-WindowsFeature "RSAT-AD-Powershell").Installed -eq $False) {

            Write-Verbose "Installing Active Directory Powershell Module."

            Try {
                Add-WindowsFeature "RSAT-AD-Powershell"
            }
            Catch {
                return $False
            }
        }

        Import-Module "ActiveDirectory"

        Try {
            Write-Verbose "Trying to get the DN of the Forest Root Domain"
            $DsConfigDN = "CN=Configuration,$($(Get-ADForest | Select-Object -ExpandProperty RootDomain | Get-ADDomain).DistinguishedName)"
        }
        Catch {
            return $False
        }

        Try {
            Write-Verbose "Trying to read the properties of $CA"
            $CaObject = Get-ChildItem "AD:CN=Enrollment Services,CN=Public Key Services,CN=Services,$DsConfigDN" | Where-Object { $_.Name -eq $CA }
        }
        Catch {
            return $False
        }

        Write-Verbose "Checking if $Template is bound to $CA"
        If ((Get-ADObject $CaObject -Properties certificateTemplates).certificateTemplates | Where-Object { $_ -eq $Template }) {
            return $True
        }
        Else {
            return $False
        }
        
    }
    
}