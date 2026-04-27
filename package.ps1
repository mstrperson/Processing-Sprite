# package.ps1 -- bundle SpriteGame into a release zip for the Processing
# Contributed Library Manager.
#
# Prerequisites (run in order before this script):
#   1. bash build.sh      -- compiles library/SpriteGame.jar
#   2. bash javadoc.sh    -- generates reference/ (optional but recommended)
#
# Output (all written to releases\download\latest\):
#   SpriteGame.zip    -- the distributable archive
#   SpriteGame.pdex   -- identical to .zip; enables IDE pde:// installation
#   SpriteGame.txt    -- copy of library.properties for the Contribution Manager
#
# Usage (from the repo root):
#   powershell -ExecutionPolicy Bypass -File package.ps1

$ErrorActionPreference = "Stop"

# $PSScriptRoot is the directory containing this script -- reliable in all
# PowerShell invocation contexts.
$ScriptDir = $PSScriptRoot

# ---------- Preflight checks -------------------------------------------------
if (-not (Test-Path "$ScriptDir\library\SpriteGame.jar")) {
    Write-Error "library\SpriteGame.jar not found -- run build.sh first."
    exit 1
}

# ---------- 1. Assemble the staging tree -------------------------------------
$Stage    = Join-Path ([System.IO.Path]::GetTempPath()) "SpriteGame_stage_$(Get-Random)"
$LibStage = Join-Path $Stage "SpriteGame"

New-Item -ItemType Directory -Path $Stage              -Force | Out-Null
New-Item -ItemType Directory -Path $LibStage           -Force | Out-Null
New-Item -ItemType Directory -Path "$LibStage\library" -Force | Out-Null

Copy-Item "$ScriptDir\library\SpriteGame.jar" "$LibStage\library\SpriteGame.jar"
Copy-Item "$ScriptDir\library.properties"     "$LibStage\library.properties"
Copy-Item "$ScriptDir\LICENSE"                "$LibStage\LICENSE"
Copy-Item "$ScriptDir\examples"               "$LibStage\examples" -Recurse
Copy-Item "$ScriptDir\src"                    "$LibStage\src"      -Recurse

if (Test-Path "$ScriptDir\reference") {
    Copy-Item "$ScriptDir\reference" "$LibStage\reference" -Recurse
} else {
    Write-Warning "reference\ not found -- run javadoc.sh first for complete docs."
}

# ---------- 2. Zip -----------------------------------------------------------
$ReleaseDir = "$ScriptDir\releases\download\latest"
New-Item -ItemType Directory -Path $ReleaseDir -Force | Out-Null

$Zip  = "$ReleaseDir\SpriteGame.zip"
$Pdex = "$ReleaseDir\SpriteGame.pdex"
$Txt  = "$ReleaseDir\SpriteGame.txt"

Remove-Item $Zip, $Pdex, $Txt -ErrorAction SilentlyContinue

Compress-Archive -Path $LibStage -DestinationPath $Zip

# ---------- 3. Create .pdex (identical to .zip) ------------------------------
Copy-Item $Zip $Pdex

# ---------- 4. Create .txt (copy of library.properties) ----------------------
Copy-Item "$ScriptDir\library.properties" $Txt

# ---------- 5. Clean up ------------------------------------------------------
Remove-Item $Stage -Recurse -Force

Write-Host "Packaged:"
Write-Host "  $Zip"
Write-Host "  $Pdex"
Write-Host "  $Txt"
Write-Host ""
Write-Host "Commit and push releases/ to publish the update."
