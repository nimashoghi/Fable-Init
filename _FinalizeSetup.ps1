Begin {
    Push-Location "$PSScriptRoot"
}
Process {
    # dotnet new sln | Out-Null
    # dotnet sln add <%= $PLASTER_PARAM_Name -replace " ", "_" %>.fsproj | Out-Null
    dotnet restore | Out-Null
    yarn | Out-Null
    yarn add --dev @babel/core fable-splitter | Out-Null
    Remove-Item -Force "$PSScriptRoot/FinalizeSetup.ps1"
}
End {
    Pop-Location
}

