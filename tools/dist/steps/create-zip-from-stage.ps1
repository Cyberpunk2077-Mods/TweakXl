param ($StageDir, $ProjectName, $DistDir, $Version, $Suffix = "")

if ([string]::IsNullOrWhiteSpace($Version)) {
    $Version = & (Join-Path $PSScriptRoot "get-version.ps1")
}

New-Item -ItemType directory -Force -Path ${DistDir} | Out-Null
Compress-Archive -Path "${StageDir}/*" -CompressionLevel Optimal -Force -DestinationPath "${DistDir}/${ProjectName}-${Version}${Suffix}.zip"
