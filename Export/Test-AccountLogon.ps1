Function Test-AccountLogon {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $UserName,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Password
    )

    process {

        Write-Verbose "Testing Credentials for $Username for Validity"

        Try {
            net use "$($env:LOGONSERVER)\NETLOGON" $Password /user:$UserName
            $True
        }
        Catch {
            Write-Verbose "Credentials for $Username could not be verified"
            $False
        }
        Finally {
            net use "$($env:LOGONSERVER)\NETLOGON" /DELETE
        }

    }

}