param (
    [Parameter(Mandatory)]
    [string]
    $Name
)

$Fsproj = @"
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>netcoreapp2.1</TargetFramework>
  </PropertyGroup>

  <ItemGroup>
    <Compile Include="Library.fs" />
  </ItemGroup>

  <ItemGroup>
    <PackageReference Include="Fable.Core" Version="2.0.2" />
    <DotNetCliToolReference Include="dotnet-fable" Version="2.0.11" />
  </ItemGroup>

</Project>
"@

$LibraryFs = @"
module $Name

let hello name =
    printfn "Hello %s" name
"@

$WebpackConfig = @"
// Note this only includes basic configuration for development mode.
// For a more comprehensive configuration check:
// https://github.com/fable-compiler/webpack-config-template

var path = require("path");

module.exports = {
    mode: "development",
    entry: "./src/$Name.fsproj",
    output: {
        path: path.join(__dirname, "./public"),
        filename: "bundle.js",
    },
    devServer: {
        contentBase: "./public",
        port: 61225,
    },
    module: {
        rules: [{
            test: /\.fs(x|proj)?$/,
            use: "fable-loader"
        }]
    }
}
"@

$WebpackScript = @"
param (
    [int]
    `$Port = 8092
)

Push-Location "./src"
dotnet fable webpack-dev-server --port `$Port
Pop-Location
"@

$BuildScript = @"
param (
    [int]
    $Port = 8092
)

npx fable-splitter src/$Name.proj --outDir out --port $Port
"@

$WatchScript = @"
& Start-Process -NoNewWindow pwsh.exe ./webpack.ps1
npx nodemon --exec "pwsh.exe ./build.ps1" ./src/*
"@


# create directory
New-Item -ItemType Directory -Path $Name

Push-Location "$Name"
yarn init --yes

yarn add --dev @babel/core fable-loader fable-splitter nodemon webpack webpack-cli webpack-dev-server

# create src dir
New-Item -ItemType Directory -Path "src"

Push-Location "src"
# create fsproj
New-Item -ItemType File -Path "$Name.fsproj" -Value $Fsproj

# create Library.fs
New-Item -ItemType File -Path "Library.fs" -Value $LibraryFs

# restore
dotnet restore
Pop-Location

# webpack config
New-Item -Type File -Path "webpack.config.js" -Value "$WebpackConfig"

# webpack server script
New-Item -Type File -Path "webpack.ps1" -Value "$WebpackScript"

# build script
New-Item -Type File -Path "build.ps1" -Value "$BuildScript"

# watch script
New-Item -Type File -Path "watch.ps1" -Value "$WatchScript"
