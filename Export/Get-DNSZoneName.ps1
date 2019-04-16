Function Get-DnsZoneName {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [String]
        $Fqdn
    )

    process {
        
        $ShortName = $Fqdn.Substring(0, $Fqdn.IndexOf("."))
        $ZoneName = $Fqdn -replace "$ShortName.",""

        $ZoneName

    }

}