# Note: `canvas-manifest.json` and the Canvas importer

*Left 2026-10-30 by a Claude session working in WinsorForms.Core, for whoever works on this folder
next (likely another Claude instance). Branch: `canvas-manifest`.*

## What changed here

`build_canvas_html.ps1` now also writes **`html/canvas-manifest.json`**. It lists every generated
file and what it becomes in Canvas: Page or Assignment, its title, its module, its audience
(student or teacher), and the `LINK_*` token the front page uses to link to it. The generated HTML
itself didn't change. A rebuild shows every HTML file as modified, but that's only line endings
(the build writes LF, `autocrlf` checks out CRLF), and `git diff --ignore-cr-at-eol` is empty.

The Assignment title now comes from one function, `AssignmentTitle()`. Each Page's "Next: open
⟨Assignment⟩" line and the manifest both use it, so the title students are told to look for is
always the title Canvas has.

## Why

Jason uses the manifest to push this whole folder into Canvas with one command from the
WinsorForms.Core repository, instead of pasting 35 files by hand:

```
canvas-import-html <path-to>/lessons/canvas_import/html <canvasCourseId> [--values flint.json] [--apply]
```

The command is a dry run unless `--apply` is given. It creates everything unpublished and never
publishes. A rerun refreshes every item's body in place, so the loop is: **edit `content/*.json` →
re-run the build → re-run the import.** The schema is specified in WinsorForms.Core at
`docs/canvas-import-manifest.md`, and the design decisions are in
`plans/canvas-import-html/plan.md`.

As of 2026-10-30, this folder has been imported into a Canvas course. The course is
unpublished; this was an experiment.

## Things that now matter when you edit the content or the builder

1. **A title is the item's identity in Canvas.** The importer matches existing Pages,
   Assignments, and modules by title. Renaming a lesson, track, or the course title in the JSON
   creates a *new* item on the next import, and the old one stays in Canvas until someone deletes
   it. Rename deliberately, and tell Jason when a re-import will leave an orphan behind.
2. **Every `LINK_*` href needs an owner.** The importer refuses the whole manifest if any file
   links to a token that no manifest item defines as its `linkToken`. If you add a link token to
   the front page, give the matching item that `linkToken` in the builder (see `LinkToken`
   and `TrackToken`).
3. **Keep the builder ASCII-only.** Windows PowerShell 5.1 misreads a BOM-less `.ps1` that contains
   non-ASCII characters. `Write-Manifest` builds its backslash from `[char]92` on purpose: an editing
   tool decoded a literal backslash-u escape in this file once already.
4. **Flint placeholders have keys.** Each Page and Assignment maps `PASTE_FLINT_URL_HERE` to
   `flint:lesson-NN` or `flint:bonus-x` (`FlintKey()`). When the real Flint URLs exist, put them in
   a JSON file like `{"flint:lesson-01": "https://..."}` and pass it with `--values`. Keep that file
   out of the repo if the URLs are private.
5. **Don't change the manifest's shape without bumping `manifestVersion`.** The importer refuses
   any version it doesn't know. Adding an optional field doesn't need a bump. Renaming or
   repurposing a field does, and needs a matching change in WinsorForms.Core.

## Added 2026-10-30: `planbook-sequence.json` (branch `planbook-sequence`)

The build also writes **`html/planbook-sequence.json`**: the **core** lessons as one plan book
entry per class meeting, in teaching order. The WinsorForms.Core command
`planbook-import-sequence <file> <sectionId> [--start date] [--apply]` lays it onto a section's real
meetings. Its schema is in WinsorForms.Core at `docs/planbook-sequence.md`.

**Where it's used:** on 2026-10-30, the 10 entries were written to a Q2 section behind that Canvas
course. The section's last two meetings were left empty on purpose.

- **An entry is an outline, not the lesson plan.** The plan book app shows plain text and can't
  render links yet, so each entry has the lesson and day, that day's focus, the new idea, and the
  goals (`PlanBookMeetings()`). Keep it short.
- **A lesson's meeting count comes from its JSON.** An explicit `"days"` array is used if present
  (Lesson 7: Build, Build, Play-test and present). Otherwise each `### Day N - focus` step heading
  is one meeting (Lesson 6). Otherwise the lesson takes one meeting. **Changing a lesson's day count
  shifts every later lesson onto different dates.** The importer never overwrites an existing plan
  book entry, so after such a change the existing entries must be moved or deleted in the plan book
  before re-importing. Tell Jason.
- **The text must be ASCII.** The plan book columns are `varchar`. `PlainText()` strips markup,
  decodes entities, and maps the typographic characters it knows. A new character it doesn't know
  fails the build with its code point, and the fix is to add it to `$ASCII_MAP`.

## Added 2026-11-01: help pages from `guides/`

The build now reads **`guides/*.json`** as well as `content/*.json`. Each guide becomes one student
Page, `html/pages/<slug>.html`, listed in the **Start Here** module right after the front page. The
first is **Saving and Handing In Your Work** (`guides/saving-and-handing-in.json`).

- **Its link token is used outside the front page.** `LINK_GUIDE_SAVING_AND_HANDING_IN` appears on
  the front page and in the "What to turn in" box of every Assignment, so the importer has to
  resolve `LINK_*` tokens in Assignment bodies too. Rule 2 above says it already checks every
  file; if it only rewrites the front page's links, the eleven Assignments will keep the raw
  token as an href, and that needs a change in WinsorForms.Core.
- **It has a new Flint key, `flint:files`.** Add its chat URL to the `--values` file once the
  Saving and Handing In Sparky exists in Flint (`lessons/flint/helpers/files_helper.md`).
- **A re-import changes every Assignment body**, only in that one line, and creates the new Page.
  Nothing is renamed, so nothing is orphaned.
