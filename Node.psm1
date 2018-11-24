Import-Module ".\..\PsTemplate\PsTemplate.psm1"

$packageJson = Import-Template ".\_package.json"

function New-Node-Project {
    param (
        [string]
        $Name
    )

    @{Name = $Name} | Invoke-Template-Out $packageJson .\package.json
}

function Install-Node-Packages {
    param ([string[]] $Packages, [switch] [switch] $Dev = $false, [switch] $Npm = $false)

    $input = [String]::Join($Packages)

    if ($Npm) {
        if ($Dev) {
            & npm install --save-dev $input
        }
        else {
            & npm install --save $input
        }
    }
    else {
        if ($Dev) {
            & yarn add --dev $input
        }
        else {
            & yarn add $input
        }
    }
}

function Init-Node-Project {
    param ([string] $Path, [string] $Name)

    Begin {
        Push-Location $Path
    }
    Process {
        New-Node-Project -Name $Name
        Install-Node-Packages @("@babel/core"; "fable-splitter")
    }
    End {
        Pop-Location
    }
}

Export-ModuleMember -Function Init-Node-Project
