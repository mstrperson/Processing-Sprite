# Finishes the compiled book in Word:  page layout, the table of contents,
# and the PDF.
#
#     pandoc lua lessons/chapters/tools/build_chapter.lua book
#     powershell -ExecutionPolicy Bypass -File lessons/chapters/tools/finish_book.ps1
#
# In order:
#   1. Margins mirror for double-sided printing, with the wide 1.5-inch margin
#      on the inside of every page.  Page numbers go centered in the footer,
#      and the title page has none.
#      a. A code block that just overflows a page shrinks until it fits.
#      b. A page break before a numbered section goes when the next section
#         fits in the space left on the page, or the page is less than half
#         full.  Part and chapter breaks stay.
#   2. A Step that runs onto a second page, and would fit on one, is kept
#      together, so Word moves it whole to the next page.  A longer Step is
#      left to break where it falls.
#   3. A large gap at the foot of a page, 4 inches or more, gets one of the
#      spot pictures in build/book/art, sized to fit the gap.  Sparingly:
#      each picture once, in the largest gaps and at least 15 pages apart.
#      Most gaps stay white.  This book has no spot pictures yet, so the
#      list below is empty and every gap stays white.
#      a. Chapters open on a right-hand page, and a unit page sits on the
#         left, facing its first chapter.  A blank page goes in where needed.
#   4. Word fills in the contents.  The file is saved over itself and exported
#      beside it as a PDF.
#   5. Each meeting's PDF in lessons/chapters/build/pdf is cut from the finished
#      book, so a handout matches the book page for page, page numbers and
#      all.  The book build's meetings.tsv says where each meeting starts.
# Adapted on 2026-10-18 from OODP_Lessons' Course/reference/finish_book.ps1.
# Only the paths and the spot list changed.
# Kept ASCII, for PowerShell 5.1.

$dir = Join-Path $PSScriptRoot '..\build\book'
$docx = (Resolve-Path (Join-Path $dir 'Book_Draft.docx')).Path
$pdf = Join-Path (Split-Path $docx) 'Book_Draft.pdf'
$art = Join-Path $dir 'art'

$GAP_POINTS = 288          # 4 inches
$PAGE_BOTTOM = 720         # 11 inches less the 1-inch bottom margin, in points
# Spot pictures, as @{ file = 'spot_name.png'; left = 1 }, files in build/book/art.
$spots = @()

$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
  $doc = $word.Documents.Open($docx, $false, $false)
  $null = $doc.Paragraphs.Count

  # 1.  Margins and page numbers.
  foreach ($section in $doc.Sections) {
    $section.PageSetup.MirrorMargins = -1
    $section.PageSetup.LeftMargin = 108     # inside, in points:  1.5 inches
    $section.PageSetup.RightMargin = 72     # outside:  1 inch
    $section.PageSetup.DifferentFirstPageHeaderFooter = -1
    $null = $section.Footers.Item(1).PageNumbers.Add(1, $false)
  }
  foreach ($toc in $doc.TablesOfContents) { $toc.Update() }
  $doc.Repaginate()

  # 1a.  A code block that just overflows a page shrinks, half a point at a
  #      time down to 8 points, until it fits on one.  A block that still
  #      won't fit at 8 points breaks as before, at its normal size.
  $shrunk = 0
  foreach ($p in $doc.Paragraphs) {
    if ($p.Style.NameLocal -ne 'Source Code') { continue }
    $r = $p.Range
    $span = { $doc.Range($r.End - 1, $r.End - 1).Information(3) - $doc.Range($r.Start, $r.Start).Information(3) }
    if ((& $span) -lt 1) { continue }
    $original = $r.Font.Size
    # A block whose runs differ in size reports 9999999, Word's "undefined",
    # and can't be set back to that.  Leave those alone.
    if ($original -gt 72) { continue }
    $size = 9.5
    while ((& $span) -ge 1 -and $size -gt 8) { $size -= 0.5; $r.Font.Size = $size; $doc.Repaginate() }
    if ((& $span) -ge 1) {
      # Back to its own size.  Some blocks (in this book, the long listings
      # inside a box) hand back a size Word won't take again, and those go
      # back to the code style's 9.5 points.
      try { $r.Font.Size = [single]$original } catch { $r.Font.Size = 9.5 }
      $doc.Repaginate()
    } else { $shrunk++ }
  }
  "code blocks shrunk to fit:  $shrunk"

  # 1b.  The page breaks before numbered sections bend when the page is better
  #      for it.  A break is our hairline paragraph, with a level-3 heading (a
  #      numbered section) right after it;  Part and chapter breaks stay.  It
  #      goes when the next section fits entirely in the space left on this
  #      page, or when this page is less than half full.  Worked front to back,
  #      measuring the live layout each time.
  $HALF_PAGE = 324
  $dropped = 0
  $all = @($doc.Paragraphs)
  for ($i = 1; $i -lt $all.Count - 1; $i++) {
    $b = $all[$i]
    if (-not $b.Format.PageBreakBefore -or $b.Range.Text.Length -gt 1) { continue }
    if ($all[$i + 1].OutlineLevel -ne 3) { continue }
    $prev = $all[$i - 1]
    $room = $PAGE_BOTTOM - ($doc.Range($prev.Range.End - 1, $prev.Range.End - 1).Information(6) + 16)
    # The section runs to the next forced break, or the end.
    $j = $i + 1
    while ($j -lt $all.Count -and -not $all[$j].Format.PageBreakBefore) { $j++ }
    $first = $all[$i + 1].Range; $last = $all[$j - 1].Range
    $p1 = $doc.Range($first.Start, $first.Start).Information(3)
    $p2 = $doc.Range($last.End - 1, $last.End - 1).Information(3)
    $fits = $false
    if ($p1 -eq $p2) {
      $height = ($doc.Range($last.End - 1, $last.End - 1).Information(6) + 16) - $doc.Range($first.Start, $first.Start).Information(6)
      $fits = $height + 12 -le $room
    }
    if ($fits -or $room -gt $HALF_PAGE) {
      $b.Format.PageBreakBefore = 0
      $dropped++
      $doc.Repaginate()
    }
  }
  "section page breaks bent:  $dropped"

  # 2.  Keep each Step together.  Headings carry an outline level of 1 to 9,
  #     and body text 10.  In the book a Step is a level-3 heading.
  $heads = New-Object System.Collections.ArrayList
  foreach ($p in $doc.Paragraphs) {
    $level = $p.OutlineLevel
    if ($level -le 3) { [void]$heads.Add(@{ start = $p.Range.Start; level = $level; text = $p.Range.Text }) }
  }
  $kept = 0
  for ($i = 0; $i -lt $heads.Count; $i++) {
    $h = $heads[$i]
    if ($h.level -ne 3 -or -not $h.text.StartsWith('Step ')) { continue }
    $end = if ($i + 1 -lt $heads.Count) { $heads[$i + 1].start - 1 } else { $doc.Content.End - 1 }
    $first = $doc.Range($h.start, $h.start).Information(3)
    $last = $doc.Range($end, $end).Information(3)
    # Only a Step that would fit on one page is worth moving.  Word starts a
    # keep-together run on a fresh page even when the run is too long to fit,
    # which would strand a page of white for nothing.
    if ($last -eq $first + 1) {
      $top = $doc.Range($h.start, $h.start).Information(6)
      $bottom = $doc.Range($end, $end).Information(6) + 16
      $height = ($PAGE_BOTTOM - $top) + ($bottom - 72)
      if ($height -gt 612) { continue }      # 8.5 inches
    }
    if ($last -eq $first + 1) {
      $step = $doc.Range($h.start, $end)
      $step.ParagraphFormat.KeepWithNext = -1
      $step.Paragraphs.Last.KeepWithNext = 0
      $kept++
    }
  }
  "steps kept together: $kept"
  $doc.Repaginate()

  # 3.  Fill large gaps, working backward so a picture can't move a page that
  #     hasn't been checked yet.
  $paras = New-Object System.Collections.ArrayList
  foreach ($p in $doc.Paragraphs) {
    [void]$paras.Add(@{ start = $p.Range.Start; end = $p.Range.End;
      page = $p.Range.Information(3); inTable = [bool]$p.Range.Information(12) })
  }
  # Every gap that qualifies, first.  Then the biggest of them, at least
  # $SPREAD pages apart, one per picture, so the pictures spread through the
  # book and land where the white space is worst.
  $SPREAD = 15
  $gaps = New-Object System.Collections.ArrayList
  for ($k = 1; $k -lt $paras.Count; $k++) {
    $here = $paras[$k]; $prev = $paras[$k - 1]
    if ($here.page -le $prev.page -or $here.inTable -or $prev.page -lt 3) { continue }
    $bottom = $doc.Range($prev.end - 1, $prev.end - 1).Information(6) + 16
    $gap = $PAGE_BOTTOM - $bottom
    if ($gap -ge $GAP_POINTS) { [void]$gaps.Add(@{ k = $k; page = $prev.page; gap = $gap }) }
  }
  $budget = $spots.Count   # each picture once
  $chosen = New-Object System.Collections.ArrayList
  foreach ($c in ($gaps | Sort-Object { $_.gap } -Descending)) {
    if ($chosen.Count -ge $budget) { break }
    $near = $chosen | Where-Object { [Math]::Abs($_.page - $c.page) -lt $SPREAD }
    if (-not $near) { [void]$chosen.Add($c) }
  }
  "large gaps:  $($gaps.Count), pictures placed in $($chosen.Count) of them"

  # Insert from the back, so each insertion leaves the earlier positions alone.
  # The pictures go in book order:  the first gap gets the first picture.
  $order = @($chosen | Sort-Object { $_.page })
  for ($n = $order.Count - 1; $n -ge 0; $n--) {
    $c = $order[$n]; $here = $paras[$c.k]; $gap = $c.gap
    $pick = $spots[$n % $spots.Count]

    $at = $doc.Range($here.start, $here.start)
    $at.InsertParagraphBefore()
    $para = $doc.Range($here.start, $here.start).Paragraphs.Item(1)
    $para.Style = $doc.Styles.Item('Normal')
    $f = $para.Format
    $f.PageBreakBefore = 0; $f.KeepWithNext = 0; $f.KeepTogether = 0
    $f.LineSpacingRule = 0; $f.SpaceBefore = 12; $f.SpaceAfter = 0; $f.Alignment = 1
    $shape = $doc.InlineShapes.AddPicture((Join-Path $art $pick.file), $false, $true, $para.Range)
    $shape.LockAspectRatio = -1
    $shape.Height = [Math]::Min($gap - 60, 200)
  }

  # 3a.  Chapters open on a right-hand page, and a unit page sits on the left,
  #      facing its first chapter.  Printed double-sided, a right-hand page is
  #      an odd one.  Where a top-level heading lands on the wrong side, a blank
  #      page goes in ahead of it.  Front to back, since each blank page moves
  #      everything after it.
  $doc.Repaginate()
  $blanks = 0
  $tops = @($doc.Paragraphs | Where-Object { $_.OutlineLevel -eq 1 })
  $afterUnit = $false
  foreach ($h in $tops) {
    # A unit page, or one of the two section pages that work the same way.
    $text = $h.Range.Text
    $isUnit = $text.StartsWith('Unit ') -or $text.StartsWith('Bonus Chapters') -or $text.StartsWith('For Teachers')
    if (-not $isUnit -and $afterUnit) { $afterUnit = $false; continue }   # faces its unit page
    $page = $h.Range.Information(3)
    $wantOdd = -not $isUnit
    if (($page % 2 -eq 1) -ne $wantOdd) {
      $start = $h.Range.Start
      $doc.Range($start, $start).InsertParagraphBefore()
      $blank = $doc.Range($start, $start).Paragraphs.Item(1)
      $blank.Style = $doc.Styles.Item('Normal')
      $f = $blank.Format
      $f.PageBreakBefore = -1; $f.KeepWithNext = 0; $f.SpaceBefore = 0; $f.SpaceAfter = 0
      $f.LineSpacingRule = 4; $f.LineSpacing = 1       # exactly 1 point tall
      $doc.Repaginate()
      $blanks++
    }
    $afterUnit = $isUnit
  }
  "blank pages added for right-hand chapters:  $blanks"

  # 4.  Contents, save, export.
  $doc.Repaginate()
  foreach ($toc in $doc.TablesOfContents) { $toc.Update() }
  $doc.Save()
  $null = $doc.Paragraphs.Count
  $doc.ExportAsFixedFormat([string]$pdf, 17)
  "wrote $pdf"

  # 5.  Each meeting's PDF, cut from the finished book, so a handout and the
  #     book agree page for page.  meetings.tsv, from the book build, lists
  #     the heading each meeting starts on, in book order;  a meeting runs to
  #     the page before the next one starts.  A unit page has no file.
  $list = Join-Path $dir 'meetings.tsv'
  if (Test-Path $list) {
    $out = (New-Item -ItemType Directory -Force (Join-Path $PSScriptRoot '..\build\pdf')).FullName
    $starts = @()
    $norm = { param($t) (($t -replace '[\s ]+', ' ').Trim()) }
    $paras = @($doc.Paragraphs)
    $at = 0
    foreach ($line in (Get-Content $list -Encoding UTF8)) {
      $name, $heading = $line -split "`t", 2
      $want = & $norm $heading
      while ($at -lt $paras.Count) {
        $p = $paras[$at]; $at++
        if ($p.OutlineLevel -le 2 -and (& $norm $p.Range.Text).StartsWith($want)) {
          $starts += @{ name = $name; page = $p.Range.Information(3) }
          break
        }
      }
      if ($starts.Count -eq 0 -or $starts[-1].name -ne $name) { throw "no heading found for: $heading" }
    }
    $last = $doc.ComputeStatistics(2)
    for ($i = 0; $i -lt $starts.Count; $i++) {
      if (-not $starts[$i].name) { continue }
      $from = $starts[$i].page
      $to = if ($i + 1 -lt $starts.Count) { $starts[$i + 1].page - 1 } else { $last }
      $file = Join-Path $out $starts[$i].name
      $doc.ExportAsFixedFormat([string]$file, 17, $false, 0, 3, $from, $to)
      "wrote {0}  pages {1}-{2}" -f $starts[$i].name, $from, $to
    }
  }
  $doc.Close([ref]0)
} finally {
  $word.Quit()
}
