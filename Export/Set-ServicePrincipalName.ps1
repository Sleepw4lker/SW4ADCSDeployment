Function Set-ServicePrincipalName {

    [cmdletbinding()]
    param(
        [Parameter(Mandatory=$True)]
        [ValidateNotNullorEmpty()]
        [String]
        $Principal,

        [Parameter(Mandatory=$True)]
        [ValidatePattern("^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$")]
        [String]
        $FQDN
    )

    process {


        Write-Verbose "Setting Service Principal Name $FQDN on $Principal"

        $ARecord = $FQDN.Substring(0, $FQDN.IndexOf("."))


        # It will just do nothing if the SPN is already present
        Try {
            setspn -s HTTP/$FQDN "$Principal"
            setspn -s HTTP/$ARecord "$Principal"
        }
        Catch {
            return $False
        }

        return $True

    }

}