<#
  build_canvas_html.ps1
  ---------------------
  Generates Canvas-ready HTML for every lesson in the Processing Sprite series.

  Reads  : content/*.json        (one file per lesson)
           guides/*.json         (help pages for the Start Here module)
  Writes : html/pages/*.html         student-facing Canvas Page (lessons and guides)
           html/assignments/*.html   student-facing Canvas Assignment
           html/teacher/*.html       teacher copy (DO NOT PUBLISH)
           html/README.md            index + paste checklist
           html/canvas-manifest.json what each file becomes in Canvas, for
                                     the WinsorForms.Core canvas-import-html
                                     command (see "canvas manifest" below)

  Canvas rules honoured:
    * no <style> blocks, no <script>, no external assets -- inline styles only
    * output is a BODY FRAGMENT: paste straight into the Canvas HTML editor
    * font stacks use single-word family names so no nested quotes are needed
    * every table is wrapped in an overflow-x container for mobile

  Usage:  powershell -ExecutionPolicy Bypass -File build_canvas_html.ps1
#>

$ErrorActionPreference = 'Stop'
$root    = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDir  = Join-Path $root 'content'
$outDir  = Join-Path $root 'html'

# ---------------------------------------------------------------- palette ---
$INK      = '#22303c'
$BODY     = '#2d3b47'
$MUTED    = '#5b6b7a'
$RULE     = '#dfe6ec'
$FONT     = 'font-family:Lato,Helvetica,Arial,sans-serif;'
$MONO     = 'font-family:Consolas,Menlo,Monaco,monospace;'

$THEME = @{
  core  = @{ accent = '#2b6cb0'; soft = '#eaf2fb'; edge = '#c3d8ef'; label = 'Lesson' }
  bonus = @{ accent = '#7b3fa0'; soft = '#f5eefb'; edge = '#ddc7ee'; label = 'Bonus Lesson' }
}

$STAGE_STYLE = @{
  'Getting Started' = @{ bar = '#c2761c'; bg = '#fffaf0'; edge = '#f0dcbc' }
  'Got It Working'  = @{ bar = '#2b6cb0'; bg = '#f2f7fd'; edge = '#cfe0f3' }
  'Made It Mine'    = @{ bar = '#1d7a44'; bg = '#f1fbf5'; edge = '#c2e6d1' }
  'Went Beyond'     = @{ bar = '#7b3fa0'; bg = '#faf4fe'; edge = '#e0cbf0' }
}

$CODE_INLINE = 'background:#eef2f7;border:1px solid #d8e2ec;border-radius:3px;padding:1px 5px;' + $MONO + 'font-size:0.92em;color:#1a4d80;'

# ------------------------------------------------------------- formatting ---
# Escapes for HTML, but deliberately leaves already-valid character references
# (&rarr;  &#9654;  &#x2b50;) alone so content JSON can use them directly.
# Dashes are written as a plain -- in the JSON, never &mdash;.
function Esc([string]$s) {
  if ([string]::IsNullOrEmpty($s)) { return '' }
  $t = [regex]::Replace($s, '&(?!(#[0-9]+|#x[0-9a-fA-F]+|[a-zA-Z][a-zA-Z0-9]*);)', '&amp;')
  return ($t -replace '<', '&lt;' -replace '>', '&gt;')
}

# Escapes, then applies the tiny inline vocabulary used in the JSON content:
#   `code`  ->  <code>      **bold**  ->  <strong>
# The JSON puts two spaces after . ? ! and : -- HTML collapses them, so the
# second one goes out as &nbsp; (an accessibility requirement, see
# meta/WRITING_COMMON_ERRORS.md entry 2).
function Inline([string]$s) {
  $t = Esc $s
  $t = [regex]::Replace($t, '`([^`]+)`', ('<code style="' + $CODE_INLINE + '">$1</code>'))
  $t = [regex]::Replace($t, '\*\*([^*]+)\*\*', '<strong>$1</strong>')
  $t = [regex]::Replace($t, '([.?!:](?:</strong>|</code>|&rdquo;|"|\)|'')*)  (?=\S)', '$1&nbsp; ')
  return $t
}

# Escapes Java source and tints comments. Line-by-line so /* */ blocks are safe.
function FormatCode([string]$code) {
  $esc   = Esc $code
  $lines = $esc -split "`r?`n"
  $inBlk = $false
  $out   = New-Object System.Collections.Generic.List[string]
  $open  = '<span style="color:#6f8f52;">'
  foreach ($line in $lines) {
    if ($inBlk) {
      if ($line -match '\*/') { $inBlk = $false }
      $out.Add($open + $line + '</span>'); continue
    }
    if ($line -match '/\*') {
      if ($line -notmatch '\*/') { $inBlk = $true }
      $out.Add($open + $line + '</span>'); continue
    }
    $idx = $line.IndexOf('//')
    if ($idx -ge 0) {
      $out.Add($line.Substring(0, $idx) + $open + $line.Substring($idx) + '</span>'); continue
    }
    $out.Add($line)
  }
  return ($out -join "`n")
}

# ------------------------------------------------------------- components ---
function H2([string]$text, [string]$accent) {
  return '<h2 style="' + $FONT + 'color:' + $accent + ';font-size:21px;font-weight:700;margin:34px 0 12px;padding-bottom:7px;border-bottom:2px solid ' + $RULE + ';">' + (Inline $text) + '</h2>'
}

function H3([string]$text) {
  return '<h3 style="' + $FONT + 'color:' + $INK + ';font-size:16px;font-weight:700;margin:20px 0 8px;">' + (Inline $text) + '</h3>'
}

function P([string]$text) {
  return '<p style="margin:0 0 12px;">' + (Inline $text) + '</p>'
}

function Bullets($items) {
  if (-not $items) { return '' }
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<ul style="margin:0 0 14px;padding-left:22px;">')
  foreach ($i in $items) {
    [void]$sb.Append('<li style="margin:0 0 7px;">' + (Inline $i) + '</li>')
  }
  [void]$sb.Append('</ul>')
  return $sb.ToString()
}

# An item that starts with '### ' is a subheading, not a step:  it closes the
# list, prints an H3, and starts a fresh list.  A two-day lesson uses this to
# split its steps into Day 1 and Day 2.
function Numbered($items) {
  if (-not $items) { return '' }
  $open = '<ol style="margin:0 0 14px;padding-left:24px;">'
  $sb = New-Object System.Text.StringBuilder
  $inList = $false
  foreach ($i in $items) {
    if ($i.StartsWith('### ')) {
      if ($inList) { [void]$sb.Append('</ol>'); $inList = $false }
      [void]$sb.Append((H3 $i.Substring(4)))
      continue
    }
    if (-not $inList) { [void]$sb.Append($open); $inList = $true }
    [void]$sb.Append('<li style="margin:0 0 10px;">' + (Inline $i) + '</li>')
  }
  if ($inList) { [void]$sb.Append('</ol>') }
  return $sb.ToString()
}

function Callout([string]$icon, [string]$title, [string]$body, [string]$bar, [string]$bg, [string]$edge) {
  return '<div style="background:' + $bg + ';border:1px solid ' + $edge + ';border-left:5px solid ' + $bar + ';border-radius:6px;padding:14px 18px;margin:16px 0;">' +
  '<p style="margin:0 0 6px;font-weight:700;color:' + $bar + ';">' + $icon + ' ' + (Inline $title) + '</p>' +
  '<p style="margin:0;">' + (Inline $body) + '</p></div>'
}

# A screenshot and its caption, matching the book's Canvas pages
# (lessons/chapters/tools/build_chapter.lua).  The src is just the file name;
# the manifest's imageFolder says where the PNG is, and the Canvas importer
# uploads it to the course's Files and points the src at it.
function Shot($shot) {
  if (-not $shot) { return '' }
  $alt = [regex]::Replace($shot.caption, '\*\*([^*]+)\*\*', '$1')
  $alt = (Esc ([regex]::Replace($alt, '`([^`]+)`', '$1'))) -replace '"', '&quot;'
  return '<!-- SCREENSHOT:  upload ' + $shot.file + ' to Files, then point this src at it -->' +
  '<p style="margin:20px 0 6px;text-align:center;"><img src="' + $shot.file + '" alt="' + $alt +
  '" style="max-width:100%;width:' + $(if ($shot.width) { $shot.width } else { 440 }) + 'px;border:1px solid #c9d8e8;border-radius:6px;" /></p>' +
  '<div style="font-size:14px;color:#5b6b7a;font-style:italic;margin:0 0 18px;text-align:center;">' + (P $shot.caption) + '</div>'
}

function VocabList($vocab, [string]$accent, [string]$soft) {
  if (-not $vocab) { return '' }
  $sb = New-Object System.Text.StringBuilder
  foreach ($v in $vocab) {
    [void]$sb.Append('<div style="background:' + $soft + ';border-left:4px solid ' + $accent + ';border-radius:0 5px 5px 0;padding:10px 14px;margin:0 0 8px;">' +
      '<span style="font-weight:700;color:' + $accent + ';">' + (Inline $v.term) + '</span> -- ' + (Inline $v.def) + '</div>')
  }
  return $sb.ToString()
}

function CodeBlock($block) {
  $label = Esc $block.label
  return '<div style="margin:18px 0;">' +
  '<div style="background:#e5edf5;color:#3d556f;' + $FONT + 'font-size:11px;font-weight:700;letter-spacing:0.07em;text-transform:uppercase;padding:8px 13px;border:1px solid #c9d8e8;border-bottom:none;border-radius:6px 6px 0 0;">' + $label + '</div>' +
  '<pre style="margin:0;background:#f8fafc;border:1px solid #c9d8e8;border-radius:0 0 6px 6px;padding:14px 16px;overflow-x:auto;' + $MONO + 'font-size:13px;line-height:1.55;color:#1f2933;white-space:pre;">' + (FormatCode $block.body) + '</pre></div>'
}

function FlintBox([string]$numLabel, [string]$hint, [string]$footer) {
  if (-not $footer) { $footer = 'Sparky gives you code with blanks to fill in.  Tell it your lesson and paste your code.  Still stuck?  Ask again for the whole thing.' }
  return '<!-- FLINT-LINK: swap the placeholder href below for the Flint AI chat URL for this lesson -->' +
  '<div style="background:#f0fdfa;border:2px solid #14b8a6;border-radius:10px;padding:16px 20px;margin:20px 0;">' +
  '<p style="margin:0 0 4px;font-size:17px;font-weight:700;color:#0f766e;">&#129302; Stuck?&nbsp; Ask the ' + (Esc $numLabel) + ' helper</p>' +
  '<p style="margin:0 0 14px;color:#31625d;">' + (Inline $hint) + '</p>' +
  '<a href="PASTE_FLINT_URL_HERE" target="_blank" rel="noopener" style="display:inline-block;background:#0f766e;color:#ffffff;text-decoration:none;' + $FONT + 'font-size:15px;font-weight:700;padding:11px 22px;border-radius:6px;">Open the AI Helper &rarr;</a>' +
  '<p style="margin:12px 0 0;font-size:13px;color:#4b7c77;">' + (Inline $footer) + '</p></div>'
}

function ChecklistBox($items, [string]$accent) {
  if (-not $items) { return '' }
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<div style="background:#f7fafc;border:1px solid ' + $RULE + ';border-radius:8px;padding:14px 18px;margin:14px 0;">')
  [void]$sb.Append('<p style="margin:0 0 10px;font-weight:700;color:' + $INK + ';">I can&hellip;</p>')
  foreach ($i in $items) {
    [void]$sb.Append('<p style="margin:0 0 8px;padding-left:26px;text-indent:-26px;"><span style="' + $MONO + 'font-size:17px;color:' + $accent + ';">&#9744;</span>&nbsp;&nbsp;' + (Inline $i) + '</p>')
  }
  [void]$sb.Append('</div>')
  return $sb.ToString()
}

function StageTable($standard, $stages) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<div style="background:#f7fafc;border:1px solid ' + $RULE + ';border-radius:6px;padding:11px 15px;margin:0 0 14px;">' +
    '<span style="font-size:12px;font-weight:700;letter-spacing:0.06em;text-transform:uppercase;color:' + $MUTED + ';">Standard</span><br>' +
    '<span style="color:' + $BODY + ';">' + (Inline $standard) + '</span></div>')
  [void]$sb.Append('<div style="overflow-x:auto;"><table style="border-collapse:collapse;width:100%;min-width:520px;' + $FONT + 'font-size:15px;">')
  foreach ($s in $stages) {
    $st = $STAGE_STYLE[$s.name]
    $star = ''
    if ($s.name -eq 'Made It Mine') { $star = ' <span style="font-size:16px;">&#11088;</span>' }
    [void]$sb.Append('<tr>' +
      '<td style="background:' + $st.bg + ';border:1px solid ' + $st.edge + ';border-left:5px solid ' + $st.bar + ';padding:12px 14px;vertical-align:top;width:32%;">' +
      '<strong style="color:' + $st.bar + ';">' + (Esc $s.name) + '</strong>' + $star + '</td>' +
      '<td style="background:' + $st.bg + ';border:1px solid ' + $st.edge + ';border-left:none;padding:12px 14px;vertical-align:top;">' + (Inline $s.text) + '</td></tr>')
  }
  [void]$sb.Append('</table></div>')
  [void]$sb.Append('<p style="margin:12px 0 0;font-size:14px;color:' + $MUTED + ';"><strong style="color:#1d7a44;">&#11088; Made It Mine is the goal for everyone.</strong>&nbsp; &ldquo;Went Beyond&rdquo; means taking the project further in a direction you choose.&nbsp; The examples are starting points.</p>')
  return $sb.ToString()
}

function Banner($lesson, $th, [string]$kicker) {
  $when = ''
  if ($lesson.whenToUse) {
    $when = '<p style="margin:13px 0 0;padding-top:12px;border-top:1px solid #7fa8d4;font-size:14px;color:#eaf2fb;"><strong>When to use this:</strong>&nbsp; ' + (Inline $lesson.whenToUse) + '</p>'
  }
  return '<div style="background:' + $th.accent + ';border-radius:10px;padding:24px 26px;margin:0 0 8px;">' +
  '<p style="margin:0 0 6px;font-size:12px;font-weight:700;letter-spacing:0.14em;text-transform:uppercase;color:#dbe7f5;">' + (Esc $kicker) + '</p>' +
  '<h1 style="margin:0;' + $FONT + 'font-size:31px;line-height:1.2;font-weight:700;color:#ffffff;">' + (Esc $lesson.title) + '</h1>' +
  '<p style="margin:10px 0 0;font-size:16px;color:#eaf2fb;">' + (Inline $lesson.tagline) + '</p>' + $when + '</div>'
}

function Shell([string]$comment, [string]$inner) {
  return $comment + "`n" +
  '<div style="' + $FONT + 'color:' + $BODY + ';font-size:16px;line-height:1.62;">' + "`n" +
  $inner + "`n</div>`n"
}

function FileComment($lesson, [string]$kind) {
  return '<!-- ==========================================================' + "`n" +
  '     ' + $lesson.title + '  |  ' + $kind + "`n" +
  '     Generated by build_canvas_html.ps1 - do not edit by hand.' + "`n" +
  '     Source: lessons/canvas_import/content/' + $lesson.id + '.json' + "`n" +
  '     ========================================================== -->'
}

# ------------------------------------------------------------ page writer ---

# The Canvas title of a lesson's Assignment.  Each Page's "Next:" line names it,
# and canvas-manifest.json creates the Assignment under it, so both read it from
# here -- if they ever differ, students are sent looking for a title that does
# not exist.  A track's Page uses the shared lesson title, not the track's.
function AssignmentTitle($lesson, $th) {
  $t = $lesson.title
  if ($lesson.lessonTitle) { $t = $lesson.lessonTitle }
  return $th.label + ' ' + $lesson.num + ' Assignment - ' + $t
}

function Build-Page($lesson, $th) {
  $a = $th.accent
  $sb = New-Object System.Text.StringBuilder
  $kicker = $th.label + ' ' + $lesson.num
  if ($lesson.group) { $kicker += '  &middot;  ' + $lesson.group }
  [void]$sb.Append((Banner $lesson $th ($kicker + '  &middot;  Processing Sprite')))

  [void]$sb.Append('<div style="background:' + $th.soft + ';border:1px solid ' + $th.edge + ';border-radius:0 0 8px 8px;border-top:none;padding:12px 20px;margin:0 0 8px;font-size:14px;color:' + $MUTED + ';">' +
    '<strong style="color:' + $a + ';">New idea:</strong>&nbsp; ' + (Inline $lesson.newIdea) + ' &nbsp;&nbsp;|&nbsp;&nbsp; ' +
    '<strong style="color:' + $a + ';">Builds on:</strong>&nbsp; ' + (Inline $lesson.builtOn) + '</div>')

  [void]$sb.Append((H2 'What you will be able to do' $a))
  [void]$sb.Append((Bullets $lesson.goals))

  [void]$sb.Append((H2 'New words' $a))
  [void]$sb.Append((VocabList $lesson.vocab $a $th.soft))

  [void]$sb.Append((H2 'Before you code' $a))
  [void]$sb.Append((Callout '&#128173;' 'Think about it' $lesson.warmup '#c2761c' '#fffaf0' '#f0dcbc'))

  [void]$sb.Append((H2 'How it works' $a))
  foreach ($sec in $lesson.howItWorks) {
    [void]$sb.Append((H3 $sec.h))
    foreach ($para in $sec.p) { [void]$sb.Append((P $para)) }
    if ($sec.bullets) { [void]$sb.Append((Bullets $sec.bullets)) }
    if ($sec.code) { [void]$sb.Append((CodeBlock $sec.code)) }
  }

  [void]$sb.Append((H2 'Build it step by step' $a))
  [void]$sb.Append((Numbered $lesson.steps))

  [void]$sb.Append((H2 'Starter code' $a))
  [void]$sb.Append((P 'This code runs exactly as it is.  Get it running first, then start changing it.'))
  foreach ($c in $lesson.code) { [void]$sb.Append((CodeBlock $c)) }

  [void]$sb.Append((H2 'Make it yours' $a))
  [void]$sb.Append('<div style="background:#f1fbf5;border:1px solid #c2e6d1;border-left:5px solid #1d7a44;border-radius:6px;padding:16px 20px;margin:14px 0;">')
  [void]$sb.Append('<p style="margin:0 0 12px;color:#1d7a44;font-weight:700;">&#11088; This is the part that matters most.&nbsp; Pick at least one and make it yours.</p>')
  [void]$sb.Append((Bullets $lesson.makeItYours))
  if ($lesson.challenge) {
    [void]$sb.Append('<p style="margin:10px 0 0;padding-top:11px;border-top:1px solid #c2e6d1;"><strong style="color:#1d7a44;">Finished early?</strong>&nbsp; ' + (Inline $lesson.challenge) + '</p>')
  }
  [void]$sb.Append('</div>')

  [void]$sb.Append((FlintBox ($th.label + ' ' + $lesson.num) $lesson.flintHint))

  [void]$sb.Append((H2 'Wrap-up' $a))
  [void]$sb.Append((Callout '&#128172;' 'Be ready to answer' $lesson.wrapup '#c2761c' '#fffaf0' '#f0dcbc'))

  [void]$sb.Append('<p style="margin:26px 0 0;padding:14px 18px;background:' + $th.soft + ';border:1px dashed ' + $th.edge + ';border-radius:6px;font-size:15px;color:' + $MUTED + ';">' +
    '<strong style="color:' + $a + ';">Next:</strong>&nbsp; open <strong>' + (Esc (AssignmentTitle $lesson $th)) + '</strong> to check yourself and turn in your work.</p>')

  $kind = 'CANVAS PAGE (student-facing)'
  if ($lesson.group) { $kind = 'CANVAS PAGE (student-facing, ' + $lesson.group + ')' }
  return Shell (FileComment $lesson $kind) $sb.ToString()
}

# A lesson with "tracks" splits the class:  each track gets its own Page, and
# the Assignment and teacher copy stay shared.  A track's fields replace the
# lesson's for that Page;  everything it leaves out comes from the lesson.
function Merge-Track($lesson, $track) {
  $m = $lesson.PSObject.Copy()
  $m | Add-Member -Force -NotePropertyName lessonTitle -NotePropertyValue $lesson.title
  foreach ($p in $track.PSObject.Properties) {
    if ($p.Name -eq 'slug') { continue }
    $m | Add-Member -Force -NotePropertyName $p.Name -NotePropertyValue $p.Value
  }
  $m | Add-Member -Force -NotePropertyName slug -NotePropertyValue ($lesson.slug + '-' + $track.slug)
  return $m
}

# ------------------------------------------------------ assignment writer ---
function Build-Assignment($lesson, $th) {
  $a = $th.accent
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append((Banner $lesson $th ($th.label + ' ' + $lesson.num + ' Assignment  &middot;  Processing Sprite')))

  [void]$sb.Append('<div style="background:' + $th.soft + ';border:1px solid ' + $th.edge + ';border-radius:0 0 8px 8px;border-top:none;padding:12px 20px;margin:0 0 8px;font-size:14px;color:' + $MUTED + ';">' +
    'This assignment is <strong>not scored</strong>.&nbsp; The stages below are a map of where you are and what to try next -- you can revise and re-submit any time.</div>')

  [void]$sb.Append((FlintBox ($th.label + ' ' + $lesson.num) $lesson.flintHint))

  [void]$sb.Append((H2 'What to do' $a))
  [void]$sb.Append((P $lesson.assignmentTask))
  [void]$sb.Append((Bullets $lesson.assignmentDo))

  [void]$sb.Append((H2 'What to turn in' $a))
  [void]$sb.Append('<div style="background:#f7fafc;border:1px solid ' + $RULE + ';border-radius:8px;padding:16px 20px 6px;margin:14px 0;">')
  [void]$sb.Append((Numbered $lesson.submit))
  [void]$sb.Append('<p style="margin:0 0 12px;font-size:14px;color:' + $MUTED + ';">' + (HandInHowTo) + '</p></div>')

  [void]$sb.Append((H2 'Check yourself first' $a))
  [void]$sb.Append((ChecklistBox $lesson.checklist $a))

  [void]$sb.Append((H2 'Where am I?' $a))
  [void]$sb.Append((StageTable $lesson.standard $lesson.stages))

  [void]$sb.Append((H2 'Show your thinking' $a))
  [void]$sb.Append((Callout '&#9997;' 'Include this with your submission' $lesson.thinking '#2b6cb0' '#f2f7fd' '#cfe0f3'))

  return Shell (FileComment $lesson 'CANVAS ASSIGNMENT (student-facing)') $sb.ToString()
}

# --------------------------------------------------------- teacher writer ---
function Build-Teacher($lesson, $th) {
  $a = '#334155'
  $sb = New-Object System.Text.StringBuilder

  [void]$sb.Append('<div style="background:#b91c1c;color:#ffffff;border-radius:8px 8px 0 0;padding:10px 20px;font-size:13px;font-weight:700;letter-spacing:0.08em;text-transform:uppercase;">' +
    '&#9888; Teacher copy - keep this page unpublished</div>')
  [void]$sb.Append('<div style="background:#334155;border-radius:0 0 10px 10px;padding:22px 26px;margin:0 0 8px;">' +
    '<p style="margin:0 0 6px;font-size:12px;font-weight:700;letter-spacing:0.14em;text-transform:uppercase;color:#cbd5e1;">' + (Esc ($th.label + ' ' + $lesson.num)) + '</p>' +
    '<h1 style="margin:0;' + $FONT + 'font-size:29px;line-height:1.2;font-weight:700;color:#ffffff;">' + (Esc $lesson.title) + '</h1>' +
    '<p style="margin:10px 0 0;font-size:15px;color:#e2e8f0;">' + (Inline $lesson.tagline) + '</p></div>')

  [void]$sb.Append('<div style="overflow-x:auto;"><table style="border-collapse:collapse;width:100%;' + $FONT + 'font-size:15px;margin:0 0 8px;">')
  foreach ($row in @(
      @('Timing', $lesson.timing),
      @('New idea', $lesson.newIdea),
      @('Builds on', $lesson.builtOn),
      @('Standard', $lesson.standard))) {
    [void]$sb.Append('<tr><td style="background:#f1f5f9;border:1px solid #dbe3ec;padding:9px 13px;font-weight:700;color:#334155;width:22%;vertical-align:top;">' + (Esc $row[0]) + '</td>' +
      '<td style="border:1px solid #dbe3ec;padding:9px 13px;vertical-align:top;">' + (Inline $row[1]) + '</td></tr>')
  }
  [void]$sb.Append('</table></div>')

  [void]$sb.Append((H2 'Warm-up (~5 min)' $a))
  [void]$sb.Append((P $lesson.warmup))

  [void]$sb.Append((H2 'Direct instruction (~10 min)' $a))
  foreach ($sec in $lesson.teacher.di) {
    [void]$sb.Append((H3 $sec.h))
    foreach ($para in $sec.p) { [void]$sb.Append((P $para)) }
    if ($sec.bullets) { [void]$sb.Append((Bullets $sec.bullets)) }
    if ($sec.code) { [void]$sb.Append((CodeBlock $sec.code)) }
  }

  [void]$sb.Append((H2 'Guided activity (~20 min)' $a))
  [void]$sb.Append((Numbered $lesson.teacher.guided))

  [void]$sb.Append((H2 'Common mistakes to watch for' $a))
  [void]$sb.Append('<div style="background:#fffaf0;border:1px solid #f0dcbc;border-left:5px solid #c2761c;border-radius:6px;padding:16px 20px 6px;margin:14px 0;">')
  [void]$sb.Append((Bullets $lesson.teacher.pitfalls))
  [void]$sb.Append('</div>')

  [void]$sb.Append((H2 'Wrap-up (~5 min)' $a))
  [void]$sb.Append((P ('**Ask:**  ' + $lesson.wrapup)))
  [void]$sb.Append((P ('**Looking for:**  ' + $lesson.teacher.wrapupAnswer)))

  [void]$sb.Append((H2 'Teaching notes' $a))
  [void]$sb.Append((Bullets $lesson.teacher.notes))

  [void]$sb.Append((H2 'Rubric reference (no points)' $a))
  [void]$sb.Append((StageTable $lesson.standard $lesson.stages))

  return Shell (FileComment $lesson 'TEACHER COPY - DO NOT PUBLISH') $sb.ToString()
}

# ----------------------------------------------------------- guide writer ---
# A guide is a help page that belongs to no lesson, such as how to save, zip,
# and hand in a sketch.  It sits in the Start Here module, under the front
# page, which links to it.  A guide marked "fromAssignments" is also linked
# from every Assignment's "What to turn in" box;  $HANDIN holds it.
#   guide saving-and-handing-in -> LINK_GUIDE_SAVING_AND_HANDING_IN
function GuideToken($guide) {
  return 'LINK_GUIDE_' + ($guide.slug.ToUpper() -replace '-', '_')
}

function GuideLink($guide) {
  return '<a href="' + (GuideToken $guide) + '" style="color:#2b6cb0;font-weight:700;">' + (Esc $guide.title) + '</a>'
}

# The line under every Assignment's list of things to turn in.
$HANDIN = $null
function HandInHowTo() {
  $t = 'To zip your sketch:&nbsp; <strong>Sketch &rarr; Show Sketch Folder</strong>, then <strong>Go &rarr; Enclosing Folder</strong> in Finder.&nbsp; Right-click your sketch folder, and choose <strong>Compress</strong>.'
  if ($HANDIN) { $t += '&nbsp; Every click, and help when Finder looks strange:&nbsp; ' + (GuideLink $HANDIN) + '.' }
  return $t
}

# A table of things that can go wrong:  a header row from "cols", then one row
# per problem.  The first column is what the student sees, in bold.
function FixTable($fixes) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<div style="overflow-x:auto;"><table style="border-collapse:collapse;width:100%;min-width:520px;' + $FONT + 'font-size:15px;"><tr>')
  foreach ($c in $fixes.cols) {
    [void]$sb.Append('<th style="background:#e5edf5;border:1px solid #c9d8e8;padding:9px 12px;text-align:left;">' + (Inline $c) + '</th>')
  }
  [void]$sb.Append('</tr>')
  foreach ($r in $fixes.rows) {
    [void]$sb.Append('<tr>')
    for ($i = 0; $i -lt $r.Count; $i++) {
      $cell = Inline $r[$i]
      if ($i -eq 0) { $cell = '<span style="font-weight:700;color:' + $INK + ';">' + $cell + '</span>' }
      [void]$sb.Append('<td style="border:1px solid ' + $RULE + ';padding:9px 12px;vertical-align:top;">' + $cell + '</td>')
    }
    [void]$sb.Append('</tr>')
  }
  [void]$sb.Append('</table></div>')
  return $sb.ToString()
}

function Build-Guide($guide) {
  $th = $THEME['core']
  $a = $th.accent
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append((Banner $guide $th ($guide.kicker + '  &middot;  Processing Sprite')))
  foreach ($p in $guide.intro) { [void]$sb.Append((P $p)) }

  [void]$sb.Append((H2 $guide.quick.h $a))
  [void]$sb.Append('<div style="background:#f1fbf5;border:1px solid #c2e6d1;border-left:5px solid #1d7a44;border-radius:6px;padding:16px 20px 6px;margin:14px 0;">')
  [void]$sb.Append((Numbered $guide.quick.steps))
  [void]$sb.Append('</div>')

  [void]$sb.Append((FlintBox $guide.flintLabel $guide.flintHint $guide.flintFooter))

  foreach ($sec in $guide.sections) {
    [void]$sb.Append((H2 $sec.h $a))
    foreach ($p in $sec.p) { [void]$sb.Append((P $p)) }
    if ($sec.steps) { [void]$sb.Append((Numbered $sec.steps)) }
    [void]$sb.Append((Shot $sec.shot))
    if ($sec.bullets) { [void]$sb.Append((Bullets $sec.bullets)) }
    foreach ($p in $sec.after) { [void]$sb.Append((P $p)) }
    if ($sec.check) { [void]$sb.Append((Callout '&#9989;' 'Check' $sec.check '#1d7a44' '#f1fbf5' '#c2e6d1')) }
    if ($sec.watch) { [void]$sb.Append((Callout '&#9888;&#65039;' 'Watch out' $sec.watch '#b4382c' '#fdf2f1' '#f0c9c4')) }
    if ($sec.fixes) { [void]$sb.Append((FixTable $sec.fixes)) }
  }

  $comment = '<!-- ==========================================================' + "`n" +
  '     ' + $guide.title + '  |  CANVAS PAGE (student-facing help page)' + "`n" +
  '     Generated by build_canvas_html.ps1 - do not edit by hand.' + "`n" +
  '     Source: lessons/canvas_import/guides/' + $guide.slug + '.json' + "`n" +
  '     ========================================================== -->'
  return Shell $comment $sb.ToString()
}

# ------------------------------------------------------ front page writer ---

# Placeholder token for a course link the teacher wires up inside Canvas.
#   core  lesson 3 -> LINK_LESSON_03_PAGE / LINK_LESSON_03_ASSIGNMENT
#   bonus lesson A -> LINK_BONUS_A_PAGE   / LINK_BONUS_A_ASSIGNMENT
#   a track's page  -> LINK_LESSON_04_MOUSE_PAGE
function LinkToken($lesson, [string]$kind) {
  if ($lesson.kind -eq 'bonus') { return 'LINK_BONUS_' + $lesson.num + '_' + $kind }
  return 'LINK_LESSON_' + $lesson.num.PadLeft(2, '0') + '_' + $kind
}

function TrackToken($lesson, $track) {
  return LinkToken $lesson ($track.slug.ToUpper() + '_PAGE')
}

# The title cell of an index row.  A split lesson's title isn't a link;  a line
# under its tagline links each group's Page instead.
function IndexTitle($l, [string]$a) {
  if (-not $l.tracks) {
    return '<a href="' + (LinkToken $l 'PAGE') + '" style="color:' + $a + ';font-weight:700;font-size:16px;text-decoration:none;">' + (Esc $l.title) + '</a>' +
      '<div style="margin-top:3px;color:' + $MUTED + ';font-size:14px;">' + (Inline $l.tagline) + '</div>'
  }
  $links = @()
  foreach ($t in $l.tracks) {
    $links += '<a href="' + (TrackToken $l $t) + '" style="color:' + $a + ';font-weight:700;text-decoration:none;white-space:nowrap;">' + (Esc $t.group) + ' &rarr;</a>'
  }
  return '<span style="color:' + $a + ';font-weight:700;font-size:16px;">' + (Esc $l.title) + '</span>' +
    '<div style="margin-top:3px;color:' + $MUTED + ';font-size:14px;">' + (Inline $l.tagline) + '</div>' +
    '<div style="margin-top:6px;font-size:14px;">The class splits in two.&nbsp; Open your group''s page:&nbsp; ' + ($links -join ' &nbsp;&middot;&nbsp; ') + '</div>'
}

function IndexTable($lessons, $th) {
  $a = $th.accent
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append('<div style="overflow-x:auto;"><table style="border-collapse:collapse;width:100%;min-width:520px;' + $FONT + 'font-size:15px;">')
  foreach ($l in $lessons) {
    [void]$sb.Append('<tr>' +
      '<td style="border:1px solid ' + $RULE + ';border-left:5px solid ' + $a + ';background:#ffffff;padding:14px 10px;vertical-align:top;width:44px;text-align:center;">' +
        '<span style="display:inline-block;background:' + $th.soft + ';color:' + $a + ';font-weight:700;font-size:15px;border-radius:50%;width:30px;height:30px;line-height:30px;">' + (Esc $l.num) + '</span></td>' +
      '<td style="border:1px solid ' + $RULE + ';border-left:none;border-right:none;background:#ffffff;padding:14px 12px;vertical-align:top;">' +
        (IndexTitle $l $a) + '</td>' +
      '<td style="border:1px solid ' + $RULE + ';border-left:none;background:#ffffff;padding:14px 14px;vertical-align:top;text-align:right;width:130px;">' +
        '<a href="' + (LinkToken $l 'ASSIGNMENT') + '" style="color:' + $MUTED + ';font-size:14px;font-weight:700;text-decoration:none;white-space:nowrap;">Assignment &rarr;</a></td></tr>')
  }
  [void]$sb.Append('</table></div>')
  return $sb.ToString()
}

function StageLadder($course) {
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.Append((P $course.stagesIntro))
  [void]$sb.Append('<div style="overflow-x:auto;"><table style="border-collapse:collapse;width:100%;min-width:520px;' + $FONT + 'font-size:15px;">')
  foreach ($s in $course.stages) {
    $st = $STAGE_STYLE[$s.name]
    $star = ''
    if ($s.name -eq 'Made It Mine') { $star = ' <span style="font-size:16px;">&#11088;</span>' }
    [void]$sb.Append('<tr>' +
      '<td style="background:' + $st.bg + ';border:1px solid ' + $st.edge + ';border-left:5px solid ' + $st.bar + ';padding:12px 14px;vertical-align:top;width:32%;">' +
      '<strong style="color:' + $st.bar + ';">' + (Esc $s.name) + '</strong>' + $star + '</td>' +
      '<td style="background:' + $st.bg + ';border:1px solid ' + $st.edge + ';border-left:none;padding:12px 14px;vertical-align:top;">' + (Inline $s.text) + '</td></tr>')
  }
  [void]$sb.Append('</table></div>')
  [void]$sb.Append('<p style="margin:12px 0 0;font-size:14px;color:' + $MUTED + ';">' + (Inline $course.stagesOutro) + '</p>')
  return $sb.ToString()
}

function Build-FrontPage($course, $lessons, $guides) {
  $th = $THEME['core']
  $bt = $THEME['bonus']
  $a = $th.accent
  $sb = New-Object System.Text.StringBuilder

  [void]$sb.Append('<div style="background:' + $a + ';border-radius:10px;padding:30px 30px 32px;margin:0 0 8px;">' +
    '<p style="margin:0 0 8px;font-size:12px;font-weight:700;letter-spacing:0.16em;text-transform:uppercase;color:#dbe7f5;">' + (Esc $course.kicker) + '</p>' +
    '<h1 style="margin:0;' + $FONT + 'font-size:38px;line-height:1.15;font-weight:700;color:#ffffff;">' + (Esc $course.title) + '</h1>' +
    '<p style="margin:12px 0 0;font-size:17px;color:#eaf2fb;">' + (Inline $course.subtitle) + '</p></div>')

  [void]$sb.Append('<div style="background:' + $th.soft + ';border:1px solid ' + $th.edge + ';border-radius:0 0 8px 8px;border-top:none;padding:13px 20px;margin:0 0 8px;font-size:14px;color:' + $MUTED + ';text-align:center;">' +
    (Inline $course.factStrip) + '</div>')

  [void]$sb.Append((H2 'What this is' $a))
  foreach ($p in $course.overview) { [void]$sb.Append((P $p)) }

  [void]$sb.Append((H2 'What you will be able to do by the end' $a))
  [void]$sb.Append((Bullets $course.goals))

  [void]$sb.Append((H2 'The lessons' $a))
  [void]$sb.Append((P 'Work through these in order.  Each one builds directly on the one before it.'))
  [void]$sb.Append((IndexTable ($lessons | Where-Object { $_.kind -eq 'core' }) $th))

  $bonus = @($lessons | Where-Object { $_.kind -eq 'bonus' })
  if ($bonus.Count -gt 0) {
    [void]$sb.Append((H2 'Bonus lessons' $bt.accent))
    [void]$sb.Append((P $course.bonusNote))
    [void]$sb.Append((IndexTable $bonus $bt))
  }

  [void]$sb.Append((H2 'How this course works' $a))
  foreach ($sec in $course.howItWorks) {
    [void]$sb.Append((H3 $sec.h))
    foreach ($p in $sec.p) { [void]$sb.Append((P $p)) }
  }
  if ($guides) {
    [void]$sb.Append((H3 'Help pages'))
    foreach ($g in $guides) {
      [void]$sb.Append('<p style="margin:0 0 12px;">' + (GuideLink $g) + ':&nbsp; ' + (Inline $g.frontPageLine) + '</p>')
    }
  }

  [void]$sb.Append((H2 'How your work is looked at' $a))
  [void]$sb.Append((StageLadder $course))

  [void]$sb.Append((H2 'What you need' $a))
  [void]$sb.Append((Bullets $course.needList))

  $comment = '<!-- ==========================================================' + "`n" +
  '     ' + $course.title + '  |  CANVAS FRONT PAGE (student-facing)' + "`n" +
  '     Generated by build_canvas_html.ps1 - do not edit by hand.' + "`n" +
  '     Source: lessons/canvas_import/course.json' + "`n" +
  '     Every LINK_* href is a placeholder - point it at the Canvas item.' + "`n" +
  '     ========================================================== -->'
  return Shell $comment $sb.ToString()
}

# --------------------------------------------------------- canvas manifest ---
# html/canvas-manifest.json tells an importer what every generated file becomes
# in Canvas:  its type, its title, the module it sits in, and the LINK_* token
# other files use to link to it.  The WinsorForms.Core CLI command
# canvas-import-html reads it;  the schema is documented in that repository at
# docs/canvas-import-manifest.md.  Bump manifestVersion only for a change an
# older importer would misread.

# One key per lesson for the AI-helper placeholder, e.g. "flint:lesson-04" or
# "flint:bonus-a".  Both of a split lesson's Pages share the lesson's key.
function FlintKey($lesson) {
  if ($lesson.kind -eq 'bonus') { return 'flint:bonus-' + $lesson.num.ToLower() }
  return 'flint:lesson-' + $lesson.num.PadLeft(2, '0')
}

function ManifestItem([string]$type, [string]$file, [string]$title, [string]$token, [string]$audience, [string]$flint) {
  $item = [ordered]@{ type = $type; file = $file; title = $title; audience = $audience }
  if ($token) { $item.linkToken = $token }
  if ($flint) { $item.placeholders = [ordered]@{ PASTE_FLINT_URL_HERE = $flint } }
  if ($type -eq 'assignment') {
    # Formative, non-scoring course:  see "The rubrics" in ../README.md.
    $item.assignment = [ordered]@{ submissionTypes = @('online_upload'); gradingType = 'not_graded'; pointsPossible = 0 }
  }
  return $item
}

# PowerShell 5.1's ConvertTo-Json escapes ' < > & as backslash-u escapes.
# That is valid JSON, but these files are meant to be read by people too.
function Write-Manifest([string]$path, $manifest) {
  $json = $manifest | ConvertTo-Json -Depth 10
  # The pattern is built from [char]92 (a backslash) so this file never holds a
  # literal backslash-u sequence, which some editors and tools decode on sight.
  $bs = [string][char]92
  $json = [regex]::Replace($json, ($bs + $bs + 'u00(27|3c|3e|26)'), { param($m) [string][char][Convert]::ToInt32($m.Groups[1].Value, 16) })
  Write-Utf8NoBom $path ($json + "`n")
}

# ------------------------------------------------------ plan book sequence ---
# html/planbook-sequence.json is the core lessons as one plan book entry per
# class meeting, in teaching order.  The WinsorForms.Core CLI command
# planbook-import-sequence lays it onto a section's real meetings;  the schema
# is documented in that repository at docs/planbook-sequence.md.
#
# It is an outline, not the lesson plan:  the plan book shows plain text with
# no links, so each entry is the lesson (and day), the day's focus, the new
# idea, and the goals.  The full plan stays in the teacher copy in Canvas.

# The plan book stores varchar and shows text unformatted, so this strips the
# inline markup, decodes entities, and maps typographic characters to ASCII.
# Anything still outside ASCII is an error, not a silent "?" in the database.
$ASCII_MAP = @{
  0x2192 = '->'; 0x2190 = '<-'; 0x2026 = '...'; 0x00B7 = '-'; 0x2014 = '--'; 0x2013 = '-'
  0x2018 = "'";  0x2019 = "'";  0x201C = '"';   0x201D = '"'; 0x00A0 = ' ';  0x00D7 = 'x'
}
function PlainText([string]$s) {
  if ([string]::IsNullOrEmpty($s)) { return '' }
  $t = [regex]::Replace($s, '\*\*([^*]+)\*\*', '$1')
  $t = [regex]::Replace($t, '`([^`]+)`', '$1')
  $t = [System.Net.WebUtility]::HtmlDecode($t)
  foreach ($code in $ASCII_MAP.Keys) { $t = $t.Replace([string][char]$code, $ASCII_MAP[$code]) }
  $bad = [regex]::Match($t, '[^\x00-\x7F]')
  if ($bad.Success) { throw ('Plan book text has a character with no ASCII mapping (U+{0:X4}) in: {1}' -f [int][char]$bad.Value, $t) }
  return $t
}

# The meetings a lesson takes, as one label per meeting ($null = no label).
# An explicit "days" array in the lesson JSON wins;  otherwise a step list split
# by "### Day N - focus" headings gives one meeting per heading;  otherwise one.
function LessonDays($lesson) {
  if ($lesson.days) { return , @($lesson.days) }
  $heads = @($lesson.steps | Where-Object { $_ -like '### Day *' } | ForEach-Object { $_.Substring(4) -replace '^Day \d+\s*-+\s*', '' })
  if ($heads.Count -gt 0) { return , $heads }
  return , @($null)
}

function PlanBookMeetings($lesson, $th) {
  $days = LessonDays $lesson
  $heading = $th.label + ' ' + $lesson.num + ': ' + (PlainText $lesson.title)
  $out = @()
  for ($i = 0; $i -lt $days.Count; $i++) {
    $scope = $heading
    if ($days.Count -gt 1) { $scope += ' (day ' + ($i + 1) + ' of ' + $days.Count + ')' }
    $lines = New-Object System.Collections.Generic.List[string]
    if ($days[$i]) { $lines.Add('Today: ' + (PlainText $days[$i])) }
    if ($i -eq 0) {
      $lines.Add('New idea: ' + (PlainText $lesson.newIdea))
      if ($lesson.tracks) { $lines.Add('The class splits: ' + (@($lesson.tracks | ForEach-Object { $_.group }) -join ' / ')) }
      if ($lesson.goals) {
        $lines.Add('Goals:')
        foreach ($g in $lesson.goals) { $lines.Add('- ' + (PlainText $g)) }
      }
    } else {
      $lines.Add('Continues from day ' + $i + '.')
    }
    $notes = $lines -join "`n"
    if ($scope.Length -gt 2000 -or $notes.Length -gt 2000) { throw "Plan book text over 2000 characters for $scope" }
    $out += [ordered]@{ scopeAndSequence = $scope; planNotes = $notes }
  }
  return , $out
}

# ------------------------------------------------------------------ main ---
function Write-Utf8NoBom([string]$path, [string]$text) {
  $enc = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($path, $text, $enc)
}

foreach ($d in @('pages', 'assignments', 'teacher')) {
  $p = Join-Path $outDir $d
  if (-not (Test-Path $p)) { New-Item -ItemType Directory -Force -Path $p | Out-Null }
}

$files = Get-ChildItem -Path $srcDir -Filter '*.json' | Sort-Object Name
if (-not $files) { throw "No lesson JSON found in $srcDir" }

# Guides first, so every Assignment can link to the hand-in guide.
$guides = @()
$guideDir = Join-Path $root 'guides'
if (Test-Path $guideDir) {
  foreach ($gf in (Get-ChildItem -Path $guideDir -Filter '*.json' | Sort-Object Name)) {
    $guides += (Get-Content -Raw -Encoding UTF8 $gf.FullName | ConvertFrom-Json)
  }
}
$HANDIN = $guides | Where-Object { $_.fromAssignments } | Select-Object -First 1

$index = New-Object System.Collections.Generic.List[string]
$index.Add('# Canvas HTML - generated output')
$index.Add('')
$index.Add('Generated by `build_canvas_html.ps1` from `content/*.json`.')
$index.Add('**Do not edit these HTML files by hand** - edit the JSON and re-run the build.')
$index.Add('')
$index.Add('Each file is a **body fragment**: open it, copy everything, and paste it into the Canvas HTML editor')
$index.Add('(the `</>` button at the bottom-right of the Rich Content Editor). There are no `<style>` or')
$index.Add('`<script>` tags and no external assets, so Canvas will not strip anything.')
$index.Add('')
$index.Add('## Before you publish')
$index.Add('')
$index.Add('Every Page and every Assignment carries one AI-helper button with a placeholder link:')
$index.Add('')
$index.Add('``html')
$index.Add('<a href="PASTE_FLINT_URL_HERE" ...>Open the AI Helper</a>')
$index.Add('``')
$index.Add('')
$index.Add('Search each file for `PASTE_FLINT_URL_HERE` (flagged by a `<!-- FLINT-LINK -->` comment) and swap in')
$index.Add('that lesson''s Flint chat URL. There are **two per lesson** - one on the Page, one on the Assignment.')
$index.Add('A split lesson has one Page per group, so it has one more.')
$index.Add('')
$index.Add('Teacher files open with a red banner. Keep them in an **unpublished** module.')
$index.Add('')
$index.Add('`front-page.html` additionally has `LINK_*` placeholder hrefs - see the table at the bottom.')
$index.Add('')
$index.Add('## Files')
$index.Add('')
$index.Add('| # | Lesson | Page | Assignment | Teacher |')
$index.Add('|---|--------|------|------------|---------|')

$count = 0
$fileCount = 1   # the front page
$all = New-Object System.Collections.Generic.List[object]
$modules = New-Object System.Collections.Generic.List[object]
$teacherItems = New-Object System.Collections.Generic.List[object]
$planMeetings = @()
foreach ($f in $files) {
  $lesson = Get-Content -Raw -Encoding UTF8 $f.FullName | ConvertFrom-Json
  $th = $THEME[$lesson.kind]
  if (-not $th) { throw "Unknown kind '$($lesson.kind)' in $($f.Name)" }

  $name = $lesson.slug + '.html'
  $heading = $th.label + ' ' + $lesson.num + ': '
  $flint = FlintKey $lesson
  $items = New-Object System.Collections.Generic.List[object]
  $pageLinks = @()
  if ($lesson.tracks) {
    foreach ($t in $lesson.tracks) {
      $tl = Merge-Track $lesson $t
      $tname = $tl.slug + '.html'
      Write-Utf8NoBom (Join-Path $outDir "pages\$tname") (Build-Page $tl $th)
      $items.Add((ManifestItem 'page' "pages/$tname" ($heading + $tl.title) (TrackToken $lesson $t) 'student' $flint))
      $pageLinks += '[' + $t.slug + ' page](pages/' + $tname + ')'
      $fileCount++
    }
  } else {
    Write-Utf8NoBom (Join-Path $outDir "pages\$name") (Build-Page $lesson $th)
    $items.Add((ManifestItem 'page' "pages/$name" ($heading + $lesson.title) (LinkToken $lesson 'PAGE') 'student' $flint))
    $pageLinks += '[page](pages/' + $name + ')'
    $fileCount++
  }
  Write-Utf8NoBom (Join-Path $outDir "assignments\$name") (Build-Assignment $lesson $th)
  Write-Utf8NoBom (Join-Path $outDir "teacher\$name")     (Build-Teacher    $lesson $th)
  $fileCount += 2
  $items.Add((ManifestItem 'assignment' "assignments/$name" (AssignmentTitle $lesson $th) (LinkToken $lesson 'ASSIGNMENT') 'student' $flint))
  $modules.Add([ordered]@{ name = ($heading + $lesson.title); audience = 'student'; items = $items.ToArray() })
  $teacherItems.Add((ManifestItem 'page' "teacher/$name" ('Teacher Copy - ' + $heading + $lesson.title) $null 'teacher' $null))
  if ($lesson.kind -eq 'core') { $planMeetings += PlanBookMeetings $lesson $th }

  $all.Add($lesson)
  $index.Add('| ' + $lesson.num + ' | ' + $lesson.title + ' | ' + ($pageLinks -join ', ') + ' | [assignment](assignments/' + $name + ') | [teacher](teacher/' + $name + ') |')
  $count++
  Write-Host ("  built  " + ($lesson.num + '').PadRight(4) + $lesson.title)
}

# --- front page ---
$coursePath = Join-Path $root 'course.json'
if (-not (Test-Path $coursePath)) { throw "Missing course.json at $coursePath" }
$course = Get-Content -Raw -Encoding UTF8 $coursePath | ConvertFrom-Json
Write-Utf8NoBom (Join-Path $outDir 'front-page.html') (Build-FrontPage $course $all $guides)
Write-Host ("  built  home  " + $course.title + '  (front-page.html)')

# --- guides:  help pages in the Start Here module ---
$guideItems = @()
foreach ($g in $guides) {
  Write-Utf8NoBom (Join-Path $outDir ('pages\' + $g.slug + '.html')) (Build-Guide $g)
  $guideItems += (ManifestItem 'page' ('pages/' + $g.slug + '.html') $g.title (GuideToken $g) 'student' $g.flintKey)
  $fileCount++
  Write-Host ("  built  help  " + $g.title)
}

# --- link-token checklist appended to the generated index ---
$index.Add('')
$index.Add('## Front page link tokens')
$index.Add('')
$index.Add('[`front-page.html`](front-page.html) is the course home page: overview, goals, the four')
$index.Add('stages, and an index of every lesson. Its links are placeholders - in the Canvas editor,')
$index.Add('click each link and re-point it at the real Page or Assignment (or find/replace the token).')
$index.Add('')
$index.Add('| Lesson | Page link | Assignment link |')
$index.Add('|--------|-----------|-----------------|')
foreach ($l in $all) {
  $pageTokens = '`' + (LinkToken $l 'PAGE') + '`'
  if ($l.tracks) {
    $pageTokens = (@($l.tracks | ForEach-Object { '`' + (TrackToken $l $_) + '`' }) -join ', ')
  }
  $index.Add('| ' + $l.title + ' | ' + $pageTokens + ' | `' + (LinkToken $l 'ASSIGNMENT') + '` |')
}

if ($guides) {
  $index.Add('')
  $index.Add('## Help pages')
  $index.Add('')
  $index.Add('Built from `guides/*.json`. Each is a Page in the Start Here module, under the front page,')
  $index.Add('with its own AI-helper button. The front page links to each one, and every Assignment''s')
  $index.Add('"What to turn in" box links to the hand-in guide, so its token appears in those files too.')
  $index.Add('')
  $index.Add('| Page | File | Link token | Flint key |')
  $index.Add('|------|------|------------|-----------|')
  foreach ($g in $guides) {
    $index.Add('| ' + $g.title + ' | [page](pages/' + $g.slug + '.html) | `' + (GuideToken $g) + '` | `' + $g.flintKey + '` |')
  }
}

Write-Utf8NoBom (Join-Path $outDir 'README.md') (($index -join "`n") + "`n")

# --- canvas manifest ---
# Module order is the course order:  Start Here (the front page, then the help
# pages), every lesson in file order, then the teacher copies last in a module
# that stays unpublished.
$frontItem = ManifestItem 'page' 'front-page.html' $course.title $null 'student' $null
$frontItem.frontPage = $true
$modules.Insert(0, [ordered]@{ name = 'Start Here'; audience = 'student'; items = @(@($frontItem) + $guideItems) })
$modules.Add([ordered]@{ name = 'Teacher Copies (keep unpublished)'; audience = 'teacher'; items = $teacherItems.ToArray() })
Write-Manifest (Join-Path $outDir 'canvas-manifest.json') ([ordered]@{
  manifestVersion  = 1
  generatedBy      = 'lessons/canvas_import/build_canvas_html.ps1'
  courseTitle      = $course.title
  linkTokenPattern = 'LINK_[A-Z0-9_]+'
  imageFolder      = '../../chapters/screenshots'
  modules          = $modules.ToArray()
})
Write-Host '  built  canvas-manifest.json'

# --- plan book sequence:  core lessons only, one entry per class meeting ---
Write-Manifest (Join-Path $outDir 'planbook-sequence.json') ([ordered]@{
  sequenceVersion = 1
  generatedBy     = 'lessons/canvas_import/build_canvas_html.ps1'
  title           = (PlainText $course.title) + ' -- core lessons'
  meetings        = $planMeetings
})
Write-Host ('  built  planbook-sequence.json  (' + $planMeetings.Count + ' meetings)')
Write-Host ''
Write-Host ("Done. $count lessons -> $fileCount HTML files in html\")
