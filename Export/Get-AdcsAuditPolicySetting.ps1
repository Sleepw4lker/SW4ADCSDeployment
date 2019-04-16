Function Get-AdcsAuditPolicySetting {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [int]
        $AuditFilter,

        [Parameter(Mandatory=$True)]
        [int]
        $Bit
    )

    process {

        # When we use -bAnd and the bit is set we will get the decimal value for this bit returned.
        # If the bit is not set we will get 0 returned
        If (([convert]::ToString($AuditFilter,2) -band $Bit) -ne 0) {

            $True

        }
        Else {

            $False

        }

    }

}