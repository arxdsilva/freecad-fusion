# Install freecad-fusion for FreeCAD on Windows.
#
#   irm https://raw.githubusercontent.com/arxdsilva/freecad-fusion/main/install.ps1 | iex
#   .\install.ps1              # from a clone: links this checkout into FreeCAD
#   .\install.ps1 -Uninstall   # removes the link(s)
#
# Uses a directory junction (no admin rights needed). Restart FreeCAD afterwards.
param([switch]$Uninstall)
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/arxdsilva/freecad-fusion.git"
$Name = "freecad-fusion"
$Base = Join-Path $env:APPDATA "FreeCAD"

function Get-ModDirs {
    $dirs = @()
    if (Test-Path $Base) {
        $dirs = Get-ChildItem -Path $Base -Directory -Filter "v*" | ForEach-Object { Join-Path $_.FullName "Mod" }
    }
    if ($dirs.Count -eq 0) { $dirs = @(Join-Path $Base "Mod") }
    return $dirs
}

if ($Uninstall) {
    foreach ($m in Get-ModDirs) {
        $target = Join-Path $m $Name
        if (Test-Path $target) { cmd /c rmdir "$target" | Out-Null; Write-Host "removed $target" }
    }
    Write-Host "Uninstalled. Tip: run Tools > 'Restore my previous FreeCAD settings' first if you want your old shortcuts back."
    return
}

$here = if ($PSScriptRoot) { $PSScriptRoot } else { "" }
if ($here -and (Test-Path (Join-Path $here "InitGui.py"))) {
    $Src = $here
} else {
    $Src = if ($env:FREECAD_FUSION_HOME) { $env:FREECAD_FUSION_HOME } else { Join-Path $env:LOCALAPPDATA $Name }
    if (Test-Path (Join-Path $Src ".git")) { git -C $Src pull --ff-only }
    else { git clone --depth 1 $RepoUrl $Src }
}

foreach ($m in Get-ModDirs) {
    New-Item -ItemType Directory -Force -Path $m | Out-Null
    $target = Join-Path $m $Name
    if (Test-Path $target) { cmd /c rmdir "$target" | Out-Null }
    cmd /c mklink /J "$target" "$Src" | Out-Null
    Write-Host "linked $target -> $Src"
}
Write-Host "Done. Restart FreeCAD: Fusion navigation and shortcuts are applied on first start."
