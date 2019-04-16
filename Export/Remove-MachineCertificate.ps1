Function Remove-MachineCertificates {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$False)]
        [String]
        $EnhancedKeyUsage,

        [Parameter(Mandatory=$False)]
        [String]
        $CommonName,
    
        [Parameter(Mandatory=$False)]
        [String]
        $DnsName,

        [Parameter(Mandatory=$False)]
        [Switch]
        $DeleteKey = $False
    )

    process {

        If ((-not $Subject) -and (-not $DnsName) -and (-not $EnhancedKeyUsage)) {
            $False
        }

        $Certlist = Get-ChildItem Cert:\LocalMachine\My

        If ($Subject) {
            Write-Verbose "Match Subject CN=$($Subject)"
            $CertList = $Certlist| Where-Object { $_.Subject -match "CN=$CommonName" }
        }

        If ($DnsName) {
            Write-Verbose "Match DNSName SAN $($DnsName)"
            $CertList = $Certlist | Where-Object { $_.DnsNameList -match $DnsName }
        }

        If ($EnhancedKeyUsage) {
            Write-Verbose "Match EKU $($EnhancedKeyUsage)"
            $CertList = $Certlist | Where-Object { $_.EnhancedKeyUsageList -match $EnhancedKeyUsage }
        }

        $Certlist | ForEach-Object {

            Write-Verbose "Deleting Certificate with Thumbprint $($_.Thumbprint)"

            If ($DeleteKey) {
                Try {
                    del "Cert:\LocalMachine\My\$($_.Thumbprint)" -DeleteKey
                }
                Catch {
                    $False
                }
            }
            Else {
                Try {
                    del "Cert:\LocalMachine\My\$($_.Thumbprint)"
                }
                Catch {
                    $False
                }
            }
        }

        $True

    }
    
}