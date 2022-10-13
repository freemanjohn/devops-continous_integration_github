[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [STRING] $ModuleName,

    [Parameter(Mandatory = $true)]
    [STRING] $ModuleDirectory,

    # SemanticVersion https://semver.org/#is-there-a-suggested-regular-expression-regex-to-check-a-semver-string
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$")]
    [STRING] $PackageVersion,

    [Parameter(Mandatory = $true)]
    [STRING] $BuildType
)
begin {
    Set-Location -Path $ModuleDirectory
}
process {
    $Files = @("$ModuleName.nuspec", "$ModuleName.psd1")

    # Replace @version@ from files
    foreach ($File in $Files) {
        (Get-Content "$ModuleDirectory\$File").Replace("@version@","$PackageVersion") | Set-Content -Path "$ModuleDirectory\$File"
    }

    $env:DOTNET_CLI_TELEMETRY_OPTOUT = "true"
    $env:DOTNET_NOLOGO = "true"
    dotnet restore --verbosity quiet
    dotnet pack --no-build --verbosity quiet --nologo --configuration $BuildType
    ls "bin/$BuildType"
    $(Get-Location).Path
}
end {

}
