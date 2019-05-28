Function Test-OperatingSystem {

    [cmdletbinding()]
    param (
        [Parameter(Mandatory=$True)]
        [ValidateSet("2008SP2","2008R2","2012","2012R2","2016","2019")]
        [String]
        $AtLeast
    )

    process {

        Switch ($AtLeast) {

            "2008SP2" {
                [int32]$MinBuild = 6002
            }
            "2008R2" {
                [int32]$MinBuild = 7601
            }
            "2012" {
                [int32]$MinBuild = 9200
            }
            "2012R2" {
                [int32]$MinBuild = 9600
            }
            "2016" {
                [int32]$MinBuild = 14393
            }
            "2019" {
                [int32]$MinBuild = 17763
            }

        }

        $CurrentBuild = [int32](Get-WmiObject Win32_OperatingSystem).BuildNumber

        If ($MinBuild -le $CurrentBuild) {
            Write-Verbose "Operating System Build ($CurrentBuild) is higher or equal than desired Build ($MinBuild)"
            return $True
        }
        Else {
            Write-Verbose "Operating System Build ($CurrentBuild) is lower than desired Build ($MinBuild)"
            return $False
        }

    }

}