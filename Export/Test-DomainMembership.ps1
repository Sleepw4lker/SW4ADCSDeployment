Function Test-DomainMembership {

    [CmdletBinding()]
    param()

    process {

        ((Get-WmiObject win32_computersystem).partofdomain -eq $True)

    }
}