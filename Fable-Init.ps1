param (
    [Parameter(Mandatory)]
    [string]
    $Name,

    [int]
    $DefaultPort = 61225,

    [string]
    $FableToolsVersion = "1.3.3"
)

Import-Module ".\Build.psm1"
Import-Module ".\Dotnet.psm1"
Import-Module ".\Node.psm1"

# create directory
New-Item -ItemType Directory -Path $Name

Push-Location "$Name"

# setup node project
Init-Node-Project -Name $Name -Path ".\"

# setup dotnet project
New-Fable-Project -Name $Name -Path ".\"

Pop-Location
