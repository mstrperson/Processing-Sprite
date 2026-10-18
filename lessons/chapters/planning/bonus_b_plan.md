# Bonus B plan - Sounds

The reasoning behind [`bonus_b_sounds.md`](../bonus_b_sounds.md), written while
drafting it on 2026-10-18, during the one-shot run.

---

## 1.  Sources read

`lessons/bonus_lesson_B_sounds/bonus_lesson_B_sounds.md`,
`lessons/canvas_import/content/11-bonus-b.json` (steps, *"Where to put the sound
is the real skill"*, the pitfalls, the machine-gun fix), and
`examples/Lessons/BonusB_Sounds`.

## 2.  Shape

Standalone, one meeting, any time after Chapter 6.  The Canvas page's sample
sketch is a cut-down game of its own, so the chapter quotes it in pieces into
the student's own `playGame()`.  B.3 turns the Canvas page's *"the real skill"*
section into a table, and ties it back to Chapter 4:  an effect is an event,
music is continuous.

**No screenshots.**  Nothing in this chapter changes the window.

## 3.  What the code showed

On the Bonus B Canvas page's main tab and the Lesson 2 `MyCharacter` tab, with
the Sound library installed in the sketchbook, as on a student's machine.
Windows' `ding.wav`, `chord.wav`, and `tada.wav` stood in for the student's
sounds.  **The music is a WAV, not an MP3**, so `"music.mp3"` became
`"music.wav"` in the scratch copy.  Nothing here can listen, so each Check
printed `isPlaying()` right after its event.

| Check | Result |
|---|---|
| the sketch builds and runs | music playing at frame 30 |
| chasing the coin | first collection at frame 172, `collectSound.isPlaying() = true` |
| chasing the hazard | at game over:  `bgMusic.isPlaying() = false`, `gameOverSound.isPlaying() = true` |
| `"colect.wav"` | `Sound library error: unable to find file colect.wav` at the start;  the game runs;  `NullPointerException` on the `play()` line at the first coin |
| `play()` in `draw()` | builds and runs.  The stutter is unverified:  it needs ears. |
| the `isPlaying()` guard | builds |
| a milestone sound | builds |

**Unverified:**  installing the library (the machine already has it), the
"library not installed" error, MP3 playback, and every claim about what
anything sounds like.

## 4.  Against the Canvas page

- *"NullPointerException on a `SoundFile` -- this always means the file was not
  found."*  True, and later than a student would expect:  the sketch starts,
  prints the error, and runs until the first `play()`.  The chapter says so,
  because the crash comes a long way from its cause.
- The sample sketch moves the coin with `random(height)`, where Chapters 6 and
  7 use `random(100, height - 150)`.  The chapter quotes the Canvas page's line
  as it is.

## 5.  Guesses and open questions for Jason

1. **The install step says to quit and restart Processing**, as the Canvas page
   does.  It's the one step this run couldn't check.
2. **B.3's tie back to Chapter 4** (effect as event, music as continuous) is
   mine.  It's the same distinction the Canvas pitfall calls *"a great
   teachable moment about event versus continuous."*
