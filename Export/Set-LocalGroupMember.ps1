Function Set-LocalGroupMember {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Principal,

        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Group
    )

    process {

        Write-Verbose "Adding $Principal to the $Group Group"

        Try {
            net localgroup "$Group" "$Principal" /add
        }
        Catch {
            # Nothing
        }

        # Sucks, check if already present
        $True

    }
    
}