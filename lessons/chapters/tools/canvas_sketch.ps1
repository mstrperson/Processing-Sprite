# Write a lesson's Canvas code into a real sketch folder, so the code students
# type can be verified exactly as the page gives it.
#
#     powershell -File lessons/chapters/tools/canvas_sketch.ps1 -Lesson 03 -Folder <folder> [-MainBlock 1] [-CarryFrom <folder>]
#
# Use the parameter names:  passed bare, -1 reads as a switch and the rest
# shift.
# <lesson> is a content file's name in lessons/canvas_import/content, like 03.
# The main tab is the block whose label says "main sketch tab";  pass
# [main-block] (0, 1, ...) when a lesson has two, like Lesson 6's Day 1 and
# Day 2.  Every "New tab - Name.pde" block becomes a tab named Name.pde.  The
# sketch is named after <folder>.
# [carry-from] is another sketch folder whose tabs come along first:  the
# Canvas pages say "keep your MyCharacter and Cloud tabs", so a lesson's sketch
# starts with the last lesson's tabs, and the main tab is replaced.
# Kept ASCII, for PowerShell 5.1.
param([string]$Lesson, [string]$Folder, [int]$MainBlock = -1, [string]$CarryFrom = '')

$utf8 = New-Object System.Text.UTF8Encoding $false
$json = Join-Path $PSScriptRoot "..\..\canvas_import\content\$Lesson.json"
$page = [IO.File]::ReadAllText((Resolve-Path $json).Path, $utf8) | ConvertFrom-Json
$name = Split-Path $Folder -Leaf

if (Test-Path $Folder) { Remove-Item -Recurse -Force $Folder }
New-Item -ItemType Directory -Force $Folder | Out-Null
if ($CarryFrom) {
  Get-ChildItem $CarryFrom -Filter *.pde | Where-Object {
    $_.BaseName -ne (Split-Path $CarryFrom -Leaf) -and $_.BaseName -notlike 'ZZ*'
  } | Copy-Item -Destination $Folder
}

$i = 0
foreach ($block in $page.code) {
  $body = ($block.body -replace "`r?`n", "`n") + "`n"
  if ($block.label -match 'New tab - (\w+)\.pde') {
    [IO.File]::WriteAllText((Join-Path $Folder "$($Matches[1]).pde"), $body, $utf8)
    "$($block.label)  ->  $($Matches[1]).pde"
  } elseif ($block.label -match '(?i)main sketch tab' -and ($MainBlock -lt 0 -or $MainBlock -eq $i)) {
    [IO.File]::WriteAllText((Join-Path $Folder "$name.pde"), $body, $utf8)
    "$($block.label)  ->  $name.pde"
  }
  $i++
}
