$ErrorActionPreference = "Stop"
$Match = [regex]::Match((Get-Content -LiteralPath "xmake.lua" -Raw), '(?m)^set_version\("([^"]+)"')
if (-not $Match.Success) { throw "Cannot read package version from xmake.lua" }
$Match.Groups[1].Value
