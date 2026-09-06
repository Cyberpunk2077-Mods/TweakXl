param ($ReleaseBin, $ProjectName = "TweakXL")

$ErrorActionPreference = "Stop"
if (-not $ReleaseBin -or -not (Test-Path -LiteralPath $ReleaseBin -PathType Leaf)) {
    throw "Release DLL not found: $ReleaseBin"
}

$DistDir = "build/dist"
$Version = & $($PSScriptRoot + "\steps\get-version.ps1")
if ([string]::IsNullOrWhiteSpace($Version)) { throw "Package version is empty" }
$StageDir = Join-Path (Get-Location).Path "build/package"
if (Test-Path -LiteralPath $StageDir) {
    Remove-Item -LiteralPath $StageDir -Recurse -Force
}

& $($PSScriptRoot + "\steps\compose-red4ext.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName} -ReleaseBin ${ReleaseBin}
& $($PSScriptRoot + "\steps\compose-redscripts.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName} -Version ${Version}
& $($PSScriptRoot + "\steps\compose-data.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName}
& $($PSScriptRoot + "\steps\compose-licenses.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName}
& $($PSScriptRoot + "\steps\make-tweaks-dir.ps1") -StageDir ${StageDir}
& $($PSScriptRoot + "\steps\create-zip-from-stage.ps1") -StageDir ${StageDir} -ProjectName ${ProjectName} -DistDir ${DistDir} -Version ${Version}

# The ZIP is complete; a scanner holding the stage open must not invalidate it.
try {
    Remove-Item -LiteralPath $StageDir -Recurse -Force
} catch {
    Write-Warning "Package created, but staging cleanup failed: $_"
}
