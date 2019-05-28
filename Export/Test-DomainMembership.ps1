Function Test-DomainMembership {

    [CmdletBinding()]
    param()

    process {

        return ((Get-WmiObject win32_computersystem).partofdomain -eq $True)

    }
}