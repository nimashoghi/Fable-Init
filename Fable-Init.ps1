param (
    [Parameter(Mandatory)]
    [string]
    $Path
)

Invoke-Plaster -TemplatePath "$PSScriptRoot" -DestinationPath "$Path"
