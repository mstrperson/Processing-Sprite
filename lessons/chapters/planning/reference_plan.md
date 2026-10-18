# Teacher reference plan - The SpriteGame Library

The reasoning behind [`reference_api.md`](../reference_api.md), written on
2026-10-18, during the one-shot run.

---

## 1.  The ask

Jason, 2026-10-18:  *"We should also add a full API documentation for the teacher
to reference at the end of the book as well.  Expose the guts of the Sprite base,
and why this course builds off Blob specifically (for the teacher, name the
tradeoffs that that implies)"*

So three things, and the reference is built around them:  every class and public
member (Parts Two and Four), the inside of `Sprite` (Part Two), and why `Blob`,
with its trade-offs (Part Three).  Part Five collects the rough edges, because the
run kept finding them and a teacher needs them in one place.

## 2.  Register

For teachers, so the words the student chapters avoid are used plainly:
*inheritance*, *abstract*, *protected*, *static*, *reflection*, *nested class*.
The voice rules are the same.  Each trade-off is written cost first, then *"What it
buys"*, per the C# book's trade-offs thread, and called a trade-off once, at the
top of R.9.

**Nothing in it states Jason's reasons.**  The one reason given for building on
`Blob` is quoted from `meta/GUIDING_PRINCIPLES.md`.  The six trade-offs are
analysis of what the choice implies, said as consequences, not as intentions.  One
sentence in the first draft (*"The course never uses `@Override`, because..."*)
gave a reason that would have been his, and came out.

## 3.  Sources

All of `src/coxprogramming/processing/sprites/`, every public and protected
member, and the Javadoc comments.  `meta/GUIDING_PRINCIPLES.md`.  The findings
from every chapter's verification.

## 4.  What the code showed

[`verify_api.sh`](verify_api.sh) is a set of small sketches, none of them lesson
code, each printing what it found.

| Claim | Result |
|---|---|
| `followMouse()` exactly onto the mouse | `(600.0, 300.0)` at frame 50, `(NaN, NaN)` at frame 51 |
| `collidesWith()` counts touching | 20 apart with radii 10 and 10:  `true`;  21 apart:  `false` |
| a `Block`'s collision | a Blob in its middle:  `false`;  near its corner:  `true` |
| style leaks | frame 1:  the Blob after the Block has no outline;  frame 3:  neither does.  `api_Leak1.png`, `api_Leak.png` |
| `ScreenBehavior` | `HardWalls` stops at 800 with `vx = 0`;  `BouncyWalls` gives `vx = -5`;  `NoWalls` reaches 830 |
| aliasing | `getPosition()`, a shared `setVelocity(v)`, and a shared `moveTo(v)` all change the other sprite;  `move()` ends the sharing |
| `angleTo()` | right to left gives `-0.0`;  right to up-left gives `0.785` where the true angle is `-2.356` |
| `perpendicular()`, `rotate(HALF_PI)` of `(1, 0)` | `(0, -1)`, and `(0, 1)` |
| `extends Sprite`, misspelled | `The type ... must implement the inherited abstract method Sprite.drawSprite()` |
| `extends Sprite`, and `collidesWith()` | doesn't exist on it;  a Blob can't take it either |
| `distanceTo()` to a `Block` | to the corner:  50, from `(10, 10)` to a corner at `(40, 50)` |
| a `CompoundSprite` at the edge | the right part wraps to `x = 2` while the left is at `752` |
| `Event` | bare, `The type Event is ambiguous`.  Full name:  a sketch function works;  a method in a tab's class, `public` or not, throws `IllegalAccessException` |
| `@Override` on `drawsprite()` | `must override or implement a supertype method` |
| the suggested `followMouse()` fix, as an override | lands on `(600.0, 300.0)` at frame 51 and stays through 60 |

**Mistakes, mine, caught.**  The harness put `__shot();` outside a `draw()` written
on one line, which broke six of the sketches with `Missing '{'`.  `verify.sh` now
handles that.  And a pixel probe for the outline read the background twice,
because `get()` works in the screen's pixels, so the leak is shown with frames.

## 5.  Open questions for Jason

1. **Fix the library?**  Part Five lists eight issues and a fix for each.  The
   `followMouse()` NaN is the one a student can hit.  The book documents and
   changes nothing.
2. **Where it goes.**  It's at the very end of the book, after the bonus chapters,
   with no Canvas page, since it's for teachers.  Its Word file goes to Flint like
   the rest, which means Sparky can answer a teacher's question from it, and a
   student's.  Is that what you want?
