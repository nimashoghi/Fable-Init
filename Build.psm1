Import-Module "$PSScriptRoot\..\PsTemplate\PsTemplate.psm1"

$PsakeFile = Import-Template "$PSScriptRoot\_psakefile.ps1"

function Install-Build-Tools {
    param (
        [string]
        $Name
    )

    @{} | Invoke-Template-Out $PsakeFile ".\psakefile.ps1"
}

Export-ModuleMember -Function Install-Build-Tools
