$ModuleRoot = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

# http://iextendable.com/2018/07/04/powershell-how-to-structure-a-module/

# The first gci block loads all of the functions in the Export and Private directories. 
# The -Recurse argument allows me to group functions into subdirectories as appropriate in larger modules.
Get-ChildItem -Path $ModuleRoot\Export,$ModuleRoot\Private -Filter *.ps1  -Recurse | ForEach-Object {

    . $_.FullName

}

# The second gci block exports only the functions in the Export directory. 
# Notice the use of the -Recurse argument again.
Get-ChildItem -Path $ModuleRoot\Export -Filter *.ps1 -Recurse | ForEach-Object {

    Export-ModuleMember $_.BaseName

}