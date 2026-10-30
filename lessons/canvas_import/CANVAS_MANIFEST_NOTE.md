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
