# Stand-in art for verifying Bonus A and Bonus C:  the files a student would
# draw or download.  Writes PNGs into the folder given.
#
#     powershell -File lessons/chapters/tools/make_test_art.ps1 <folder>
#
#   hero.png        64 x 64, a round orange critter, transparent background
#   hero_white.png  the same critter on a solid white background, to show the
#                   white box a PNG without transparency draws
#   tree.png        60 x 100, a tree, transparent background
#   bg.png          800 x 600, a gradient sky, for a background ImageSprite
# Kept ASCII, for PowerShell 5.1.
param([string]$Folder)
Add-Type -AssemblyName System.Drawing
New-Item -ItemType Directory -Force $Folder | Out-Null

function New-Canvas($w, $h, $fill) {
  $bmp = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = 'AntiAlias'
  $g.Clear($fill)
  return @($bmp, $g)
}
function Brush($a, $r, $g, $b) { New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb($a, $r, $g, $b)) }

function Draw-Hero($g) {
  $g.FillEllipse((Brush 255 245 140 40), 4, 6, 56, 54)          # body
  $g.FillEllipse((Brush 255 245 140 40), 10, 0, 14, 16)          # ears
  $g.FillEllipse((Brush 255 245 140 40), 40, 0, 14, 16)
  $g.FillEllipse((Brush 255 255 255 255), 16, 20, 12, 14)        # eyes
  $g.FillEllipse((Brush 255 255 255 255), 36, 20, 12, 14)
  $g.FillEllipse((Brush 255 30 30 30), 20, 25, 6, 7)
  $g.FillEllipse((Brush 255 30 30 30), 40, 25, 6, 7)
  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 90, 40, 10)), 3
  $g.DrawArc($pen, 22, 34, 20, 12, 10, 160)                       # smile
}

$c = New-Canvas 64 64 ([System.Drawing.Color]::Transparent); Draw-Hero $c[1]
$c[0].Save((Join-Path $Folder 'hero.png'), [System.Drawing.Imaging.ImageFormat]::Png); $c[1].Dispose(); $c[0].Dispose()

$c = New-Canvas 64 64 ([System.Drawing.Color]::White); Draw-Hero $c[1]
$c[0].Save((Join-Path $Folder 'hero_white.png'), [System.Drawing.Imaging.ImageFormat]::Png); $c[1].Dispose(); $c[0].Dispose()

$c = New-Canvas 60 100 ([System.Drawing.Color]::Transparent); $g = $c[1]
$g.FillRectangle((Brush 255 120 80 40), 24, 60, 12, 40)          # trunk
$g.FillEllipse((Brush 255 50 140 60), 2, 2, 56, 66)              # leaves
$g.FillEllipse((Brush 255 70 165 75), 10, 10, 26, 26)
$c[0].Save((Join-Path $Folder 'tree.png'), [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $c[0].Dispose()

$c = New-Canvas 800 600 ([System.Drawing.Color]::White); $g = $c[1]
$rect = New-Object System.Drawing.Rectangle 0, 0, 800, 600
$grad = New-Object System.Drawing.Drawing2D.LinearGradientBrush $rect, ([System.Drawing.Color]::FromArgb(255, 40, 60, 140)), ([System.Drawing.Color]::FromArgb(255, 250, 170, 110)), 90
$g.FillRectangle($grad, $rect)
$c[0].Save((Join-Path $Folder 'bg.png'), [System.Drawing.Imaging.ImageFormat]::Png); $g.Dispose(); $c[0].Dispose()

Get-ChildItem $Folder -Filter *.png | ForEach-Object { $_.Name }
