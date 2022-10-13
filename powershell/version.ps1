[CmdletBinding()]
param (
    $ModuleName,
    $MajorPackageVersion = 1,
    $MinorPackageVersion = 0
)

Write-Verbose -Message  "Obtaining previous package version from PSGallery for module [$ModuleName]"
$PreviousPackageVersion = (Find-Module -Repository PSGallery -Name $ModuleName -AllowPrerelease -ErrorAction SilentlyContinue).Version.Split('.')
[int] $PreviousMajorPackageVersion = $PreviousPackageVersion[0]
[int] $PreviousMinorPackageVersion = $PreviousPackageVersion[1]
[int] $PreviousPatchPackageVersion = $PreviousPackageVersion[2]
Write-Verbose -Message "The previous package version found was [$PreviousMajorPackageVersion.$PreviousMinorPackageVersion.$PreviousPatchPackageVersion]"

if ($MajorPackageVersion -lt $PreviousMajorPackageVersion) {
    Write-Warning -Message "The variable [MajorPackageVersion] with value of [$MajorPackageVersion] is less than the previous major package version [$PreviousMajorPackageVersion]"
}

if ($MinorPackageVersion -lt $PreviousMinorPackageVersion) {
    Write-Warning -Message "The variable [MinorPackageVersion] with value of [$MinorPackageVersion] is less than the previous minor package version [$PreviousMinorPackageVersion]"
}

if ($null -eq $PreviousPackageVersion) {
    $NewMajorPackageVersion = $MajorPackageVersion
    $NewMinorPackageVersion = $MinorPackageVersion
    $NewPatchPackageVersion = 0
} else {
    if ($MajorPackageVersion -gt $PreviousMajorPackageVersion) {
        $NewMajorPackageVersion = $MajorPackageVersion

        # Set NewMinorPackageVersion to 0 since MajorPackageVersion was used to set NewMajorPackageVersion
        $NewMinorPackageVersion = 0
    } else {
        $NewMajorPackageVersion = $PreviousMajorPackageVersion
        # Update MinorPackageVersion if MajorPackageVersion was not updated
        if ($MinorPackageVersion -gt $PreviousMinorPackageVersion) {
            $NewMinorPackageVersion = $MinorPackageVersion
        } else {
            $NewMinorPackageVersion = $PreviousMinorPackageVersion
        }
    }

    if (($NewMajorPackageVersion -eq $PreviousMajorPackageVersion) -and ($NewMinorPackageVersion -eq $PreviousMinorPackageVersion)) {
        $IncrementPatchPackageVersion = $true
    } else {
        $NewPatchPackageVersion = 0
    }
}

if ($IncrementPatchPackageVersion) {
    Write-Verbose -Message  "The variable [IncrementPatchPackageVersion] equals [$IncrementPatchPackageVersion]"
    $NewPatchPackageVersion = $PreviousPatchPackageVersion + 1
}

$NewPackageVersion="$NewMajorPackageVersion.$NewMinorPackageVersion.$NewPatchPackageVersion"
Write-Verbose -Message  "Exporting variable named NewPackageVersion with value [$NewPackageVersion] to [package_version.env]"
$NewPackageVersion | Out-File -Path "package_version.env" -Encoding utf8
Write-Output -InputObject "The new package version is [$NewPackageVersion]"