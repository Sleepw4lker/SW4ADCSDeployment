Function Get-AdcsAuditPolicySettingDescription {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateRange(1,7)]
        [int]
        $Bit
    )

    process {

        $String = New-Object Object[] 8
        $String[1] = "Start and stop Active Directory Certificate Services"
        $String[2] = "Back up and restore the CA Database"
        $String[3] = "Issue and manage certificate requests"
        $String[4] = "Revoke certificates and publish CRLs"
        $String[5] = "Change CA security settings"
        $String[6] = "Store and retrieve archived keys"
        $String[7] = "Change CA configuration"

        $String[$Bit]

    }

}