Function Get-RemoteRegistryValue {

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

        Write-Verbose "Connecting to $ComputerName to remote Registry"

        Try {
            $Registry = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $ComputerName)
        }
        Catch {
            return $False
        }

        Write-Verbose "Getting $Value from $Key"

        Try {
            $SubKey = $Registry.OpenSubKey($Key)
            $SubKey.GetValue($Value)
        }
        Catch {
            return $False
        }

    }

}