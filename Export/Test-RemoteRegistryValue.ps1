Function Test-RemoteRegistryValue {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $ComputerName,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Key,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Value
    )

    process {

        Try {

            $Data = Get-RemoteRegistryValue `
                -ComputerName $ComputerName `
                -Key $Key `
                -Value $Value

        }
        Catch {
            return $False
        }

        If ($Data) {
            return $True
        }
        Else {
            return $False
        }

    }

}