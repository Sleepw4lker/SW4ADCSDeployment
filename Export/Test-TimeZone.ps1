Function Test-TimeZone {
    
    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$False)]
        [ValidateNotNullorEmpty()]
        [String]
        $DesiredTimeZone = "W. Europe Standard Time"
    )

    process {

        If ((Get-TimeZone).StandardName -ne $DesiredTimeZone) {
            Write-Verbose "System Time Zone is not $DesiredTimeZone!" -ForegroundColor Red 
            $False
        }

        $True

    }

}