# Builds the Flint helper prompts.
#
# Every Sparky shares one set of rules, in src/sparky_rules.md.  Each file in
# src/ marks where those rules go with the line <!-- SPARKY RULES -->.  This
# script puts the rules in and writes the finished prompt to helpers/, ready to
# paste into Flint.
#
#   powershell -ExecutionPolicy Bypass -File build_helpers.ps1

$ErrorActionPreference = 'Stop'
$here    = Split-Path -Parent $MyInvocation.MyCommand.Path
$src     = Join-Path $here 'src'
$out     = Join-Path $here 'helpers'
$marker  = '<!-- SPARKY RULES -->'
$utf8    = New-Object System.Text.UTF8Encoding($false)

$rules = [IO.File]::ReadAllText((Join-Path $src 'sparky_rules.md'), $utf8).TrimEnd()

if (-not (Test-Path $out)) { New-Item -ItemType Directory -Path $out | Out-Null }

$built = 0
foreach ($f in Get-ChildItem $src -Filter *.md | Where-Object { $_.Name -ne 'sparky_rules.md' } | Sort-Object Name) {
  $text = [IO.File]::ReadAllText($f.FullName, $utf8)
  $count = ([regex]::Matches($text, [regex]::Escape($marker))).Count
  if ($count -ne 1) { throw "$($f.Name):  expected one '$marker' line, found $count." }

  $text = $text.Replace($marker, $rules).Replace("`r`n", "`n")
  [IO.File]::WriteAllText((Join-Path $out $f.Name), $text, $utf8)
  Write-Host "  $($f.Name)"
  $built++
}

Write-Host "Built $built helpers into helpers/."
