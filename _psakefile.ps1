Task default -Depends Watch

Task Watch -Depends Restore {
    Begin {
        Push-Location $PSScriptRoot
    }
    Process {
        dotnet fable npm-watch
    }
    End {
        Pop-Location
    }
}

Task Build -Depends Restore {
    Begin {
        Push-Location $PSScriptRoot
    }
    Process {
        dotnet fable npm-build
    }
    End {
        Pop-Location
    }
}

Task Restore {
    Begin {
        Push-Location $PSScriptRoot
    }
    Process {
        dotnet restore
    }
    End {
        Pop-Location
    }
}

Task Clean {
    Begin {
        Push-Location $PSScriptRoot
    }
    Process {
        Remove-Item -Recurse -Path ".\bin" -ErrorAction SilentlyContinue
        Remove-Item -Recurse -Path ".\obj" -ErrorAction SilentlyContinue
    }
    End {
        Pop-Location
    }
}
