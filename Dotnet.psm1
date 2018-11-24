Import-Module "$PSScriptRoot\..\PsTemplate\PsTemplate.psm1"

$FSProj = Import-Template "$PSScriptRoot\_project.fsproj"
$LibraryFS = Import-Template "$PSScriptRoot\_Library.fs"

function New-Fable-Project {
    param (
        [string]
        $Name,

        [string]
        $Path,

        [string]
        $FableToolsVersion = "1.3.3",

        [string]
        $TargetFramework = "netstandard2.0"
    )

    Begin {
        Push-Location -Path $Path
    }
    Process {
        # setup project fsproj (dotnet new classlib...)
        @{TargetFramework = $TargetFramework; FableToolsVersion = $FableToolsVersion} | Invoke-Template-Out $FSProj ".\$Name.fsproj"

        # add Fable.Core
        dotnet add package Fable.Core

        # Library.fs
        @{Name = $Name} | Invoke-Template $LibraryFS ".\Library.fs"

        # restore
        dotnet restore
    }
    End {
        Pop-Location
    }
}

Export-ModuleMember -Function New-Fable-Project
