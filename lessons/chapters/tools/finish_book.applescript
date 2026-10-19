-- Finishes the compiled book in Word for Mac:  page layout, the table of
-- contents, and the PDF.  finish_book.ps1 does the same in Word for Windows.
--
--     pandoc lua lessons/chapters/tools/build_chapter.lua book
--     osascript lessons/chapters/tools/finish_book.applescript
--
-- The steps, and their numbers, are finish_book.ps1's;  its header says what
-- each one does and why.  Three things differ on the Mac.
--
--   * Word is sandboxed.  It asks permission, in a dialog, for any file outside
--     its own folder, and a script waits on that dialog forever.  So the book
--     and the spot pictures are copied into Word's folder
--     (~/Library/Containers/com.microsoft.Word/Data/finish_book), finished
--     there, and the .docx and PDF copied back.
--   * Word's AppleScript reaches a paragraph by counting from the top of the
--     document, half a second a paragraph near the back of this book.  So
--     nothing here walks the paragraphs.  Code blocks, forced page breaks, and
--     headings are found with Word's Find and its go-to, and everything after
--     that is a character position.
--   * Word for Mac exports only the whole document as a PDF.  Each meeting's
--     PDF is cut from the book's with PDFKit.
--
-- Leave Word alone while it runs, about ten minutes.  It types into the
-- document through the selection.

use AppleScript version "2.4"
use framework "Foundation"
use framework "Quartz"
use scripting additions

property GAP_POINTS : 288 -- 4 inches
property PAGE_BOTTOM : 720 -- 11 inches less the 1-inch bottom margin, in points
property HALF_PAGE : 324
property SPREAD : 15
property lastStep : "opening the book"
-- Spot pictures, files in build/book/art.  Each goes in once.
property SPOTS : {"spot_coin.png", "spot_cloud.png", "spot_mouse.png", "spot_keys.png", "spot_notes.png", "spot_blob.png", "spot_tree.png", "spot_flipbook.png"}

on run
	set tools to POSIX path of ((path to me as text) & "::")
	set bookDir to tools & "../build/book/"
	set pdfDir to tools & "../build/pdf/"
	set work to (POSIX path of (path to home folder)) & "Library/Containers/com.microsoft.Word/Data/finish_book/"
	do shell script "rm -rf " & quoted form of work & " && mkdir -p " & quoted form of work
	do shell script "cp " & quoted form of (bookDir & "Book_Draft.docx") & " " & quoted form of work
	repeat with s in SPOTS
		do shell script "cp " & quoted form of (bookDir & "art/" & s) & " " & quoted form of work
	end repeat
	set docx to work & "Book_Draft.docx"
	set pdf to work & "Book_Draft.pdf"

	tell application "Microsoft Word"
		activate
		open (docx as POSIX file)
		set d to active document
	end tell
	try
		finish(d, work)
		tell application "Microsoft Word"
			save d
			save as d file name pdf file format format PDF
		end tell
		set lastStep to "wrote Book_Draft.pdf"
		log lastStep
		set starts to my meetingStarts(d, bookDir & "meetings.tsv")
		set lastPage to my pageCount(d)
		tell application "Microsoft Word" to close d saving no
	on error msg number n
		tell application "Microsoft Word" to close d saving no
		error "after \"" & lastStep & "\":  " & msg number n
	end try

	do shell script "cp " & quoted form of docx & " " & quoted form of pdf & " " & quoted form of bookDir
	my cutMeetings(bookDir & "Book_Draft.pdf", pdfDir, starts, lastPage)
	return "done"
end run

on finish(d, work)
	-- 1.  Margins and page numbers.  The title page has none.
	tell application "Microsoft Word"
		repeat with i from 1 to (count of sections of d)
			set ps to page setup of section i of d
			set mirror margins of ps to true
			set left margin of ps to 108 -- inside, in points:  1.5 inches
			set right margin of ps to 72 -- outside:  1 inch
			set different first page header footer of ps to true
			set ft to get footer section i of d index header footer primary
			create new field text range (text object of ft) field type field page
			set alignment of paragraph format of text object of ft to align paragraph center
		end repeat
		update table of contents 1 of d
		repaginate d
	end tell

	-- 1a.  A code block that just overflows a page shrinks, half a point at a
	--      time down to 8 points, until it fits on one.  Each block is one
	--      paragraph in the Source Code style.
	set shrunk to 0
	repeat with b in my findAll(d, "Source Code")
		set {s, e} to contents of b
		if my span(d, s, e) ≥ 1 then
			tell application "Microsoft Word"
				set r to create range d start s end e
				set original to font size of font object of r
			end tell
			-- A block whose runs differ in size reports a huge number, Word's
			-- "undefined".  Leave those alone.
			if original ≤ 72 then
				set vSize to 9.5
				repeat while my span(d, s, e) ≥ 1 and vSize > 8
					set vSize to vSize - 0.5
					tell application "Microsoft Word"
						set font size of font object of r to vSize
						repaginate d
					end tell
				end repeat
				if my span(d, s, e) ≥ 1 then
					tell application "Microsoft Word"
						try
							set font size of font object of r to original
						on error
							set font size of font object of r to 9.5
						end try
						repaginate d
					end tell
				else
					set shrunk to shrunk + 1
				end if
			end if
		end if
	end repeat
	set lastStep to "code blocks shrunk to fit:  " & shrunk
	log lastStep

	-- 1b.  The page breaks before numbered sections bend when the page is
	--      better for it.  A break is our hairline paragraph, a forced break with
	--      nothing in it, with a level-3 heading right after it.  Part and
	--      chapter breaks stay.
	set heads to my headings(d)
	set breaks to my findBreaks(d)
	set standing to {}
	repeat with b in breaks
		set end of standing to true
	end repeat
	set dropped to 0
	repeat with i from 1 to count of breaks
		set {s, e} to item i of breaks
		if my isHairline(d, s, e) and my levelAt(heads, e) = 3 then
			set room to PAGE_BOTTOM - ((my vpos(d, s - 1)) + 16)
			-- The section runs to the next forced break still standing, or the end.
			set nextBreak to my docEnd(d)
			repeat with j from i + 1 to count of breaks
				if item j of standing then
					set nextBreak to item 1 of item j of breaks
					exit repeat
				end if
			end repeat
			set fits to false
			if my pageAt(d, e) = my pageAt(d, nextBreak - 1) then
				set vHeight to ((my vpos(d, nextBreak - 1)) + 16) - (my vpos(d, e))
				set fits to (vHeight + 12 ≤ room)
			end if
			if fits or room > HALF_PAGE then
				tell application "Microsoft Word"
					set page break before of paragraph format of (create range d start s end e) to false
					repaginate d
				end tell
				set item i of standing to false
				set dropped to dropped + 1
			end if
		end if
	end repeat
	set lastStep to "section page breaks bent:  " & dropped
	log lastStep

	-- 2.  Keep each Step together.  In the book a Step is a level-3 heading.
	set kept to 0
	repeat with i from 1 to count of heads
		set {s, lvl, txt} to item i of heads
		if lvl = 3 and txt starts with "Step " then
			if i < (count of heads) then
				set e to (item 1 of item (i + 1) of heads) - 1
			else
				set e to (my docEnd(d)) - 1
			end if
			set firstPage to my pageAt(d, s)
			if my pageAt(d, e) = firstPage + 1 then
				set vTop to my vpos(d, s)
				set vBottom to (my vpos(d, e)) + 16
				-- Only a Step that would fit on one page is worth moving.
				if (PAGE_BOTTOM - vTop) + (vBottom - 72) ≤ 612 then
					tell application "Microsoft Word"
						set keep with next of paragraph format of (create range d start s end e) to true
						set keep with next of paragraph format of (paragraph 1 of (create range d start e end e)) to false
					end tell
					set kept to kept + 1
				end if
			end if
		end if
	end repeat
	set lastStep to "steps kept together:  " & kept
	log lastStep
	tell application "Microsoft Word" to repaginate d

	-- 3.  Fill large gaps.  A gap is the white below the last line of a page
	--     whose next page starts with a new paragraph, outside a table.  Then
	--     the biggest of them, at least SPREAD pages apart, one per picture.
	set gaps to {}
	tell application "Microsoft Word"
		set r to create range d start 0 end 0
		repeat
			set r2 to go to next r what goto a page item
			if r2 is missing value then exit repeat
			set s to start of content of r2
			if s is missing value or s ≤ (start of content of r) then exit repeat
			set r to r2
			set p to paragraph 1 of r2
			if (start of content of text object of p) = s then
				set inTable to (get range information r2 information type with in table) as text
				if inTable is not "true" then
					set prevPage to my pageAt(d, s - 1)
					if prevPage ≥ 3 then
						set vGap to PAGE_BOTTOM - ((my vpos(d, s - 1)) + 16)
						if vGap ≥ GAP_POINTS then set end of gaps to {s, prevPage, vGap}
					end if
				end if
			end if
		end repeat
	end tell
	set chosen to {}
	repeat with c in my sortBy(gaps, 3, false)
		if (count of chosen) ≥ (count of SPOTS) then exit repeat
		set near to false
		repeat with o in chosen
			if (item 2 of o) - (item 2 of c) < SPREAD and (item 2 of c) - (item 2 of o) < SPREAD then set near to true
		end repeat
		if not near then set end of chosen to contents of c
	end repeat
	set lastStep to "large gaps:  " & (count of gaps) & ", pictures placed in " & (count of chosen) & " of them"
	log lastStep

	-- From the back, so each insertion leaves the earlier positions alone.  The
	-- pictures go in book order:  the first gap gets the first picture.
	set inOrder to my sortBy(chosen, 2, true)
	repeat with n from (count of inOrder) to 1 by -1
		set {s, pgNum, vGap} to item n of inOrder
		set pick to work & (item n of SPOTS)
		tell application "Microsoft Word"
			insert paragraph at (create range d start s end s)
			set p to paragraph 1 of (create range d start s end s)
			set style of p to "Normal"
			set f to paragraph format of p
			set page break before of f to false
			set keep with next of f to false
			set keep together of f to false
			set line spacing rule of f to line space single
			set space before of f to 12
			set space after of f to 0
			set alignment of f to align paragraph center
			make new inline picture at (create range d start s end s) with properties {file name:pick, save with document:true}
			set shp to inline shape 1 of text object of (paragraph 1 of (create range d start s end s))
			set lock aspect ratio of shp to true
			set h to vGap - 60
			if h > 200 then set h to 200
			set height of shp to h
		end tell
	end repeat

	set lastStep to "spot pictures inserted"

	-- 3a.  Chapters open on a right-hand page, and a unit page sits on the
	--      left, facing its first chapter.  Front to back, since each blank
	--      page moves everything after it by one character.
	tell application "Microsoft Word" to repaginate d
	set blanks to 0
	set afterUnit to false
	repeat with h in my headings(d)
		set {s, lvl, txt} to contents of h
		if lvl = 1 then
			set s to s + blanks
			set isUnit to (txt starts with "Unit ") or (txt starts with "Bonus Chapters") or (txt starts with "For Teachers")
			if not isUnit and afterUnit then
				set afterUnit to false
			else
				set wantOdd to not isUnit
				if ((my pageAt(d, s)) mod 2 = 1) is not wantOdd then
					tell application "Microsoft Word"
						insert paragraph at (create range d start s end s)
						set p to paragraph 1 of (create range d start s end s)
						set style of p to "Normal"
						set f to paragraph format of p
						set page break before of f to true
						set keep with next of f to false
						set space before of f to 0
						set space after of f to 0
						set line spacing rule of f to line space exactly
						set line spacing of f to 1 -- exactly 1 point tall
						repaginate d
					end tell
					set blanks to blanks + 1
				end if
				set afterUnit to isUnit
			end if
		end if
	end repeat
	set lastStep to "blank pages added for right-hand chapters:  " & blanks
	log lastStep

	-- 4.  Contents.  The caller saves and exports.
	tell application "Microsoft Word"
		repaginate d
		update table of contents 1 of d
		repaginate d
	end tell
end finish

-- 5.  The page each meeting starts on.  meetings.tsv, from the book build,
--     lists the heading each one starts on, in book order.  A unit page has
--     no file, but it ends the meeting before it.
on meetingStarts(d, tsv)
	set heads to my headings(d)
	set lines_ to paragraphs of (read (tsv as POSIX file) as «class utf8»)
	set starts to {}
	set k to 1
	repeat with ln in lines_
		if (length of ln) > 0 then
			set tid to AppleScript's text item delimiters
			set AppleScript's text item delimiters to tab
			set nm to text item 1 of ln
			set want to my norm(text items 2 thru -1 of ln as text)
			set AppleScript's text item delimiters to tid
			set hit to false
			repeat while k ≤ (count of heads)
				set {s, lvl, txt} to item k of heads
				set k to k + 1
				if lvl ≤ 2 and (my norm(txt)) starts with want then
					set end of starts to {nm, my pageAt(d, s)}
					set hit to true
					exit repeat
				end if
			end repeat
			if not hit then error "no heading found for: " & want
		end if
	end repeat
	return starts
end meetingStarts

on cutMeetings(bookPdf, outDir, starts, lastPage)
	do shell script "mkdir -p " & quoted form of outDir
	set src to current application's PDFDocument's alloc()'s initWithURL:(current application's NSURL's fileURLWithPath:bookPdf)
	set total to src's pageCount() as integer
	if total is not lastPage then log "warning:  Word counts " & lastPage & " pages, the PDF has " & total
	repeat with i from 1 to count of starts
		set {nm, fromPage} to item i of starts
		if nm is not "" then
			if i < (count of starts) then
				set toPage to (item 2 of item (i + 1) of starts) - 1
			else
				set toPage to total
			end if
			set out to current application's PDFDocument's alloc()'s init()
			repeat with k from fromPage to toPage
				(out's insertPage:(src's pageAtIndex:(k - 1)) atIndex:(out's pageCount()))
			end repeat
			(out's writeToFile:(outDir & nm))
			set lastStep to "wrote " & nm & "  pages " & fromPage & "-" & toPage
			log lastStep
		end if
	end repeat
end cutMeetings

-- ---------------------------------------------------------------------------
-- Measuring, by character position.

on pageAt(d, x)
	tell application "Microsoft Word" to return (get range information (create range d start x end x) information type active end page number) as integer
end pageAt

on vpos(d, x)
	tell application "Microsoft Word" to return (get range information (create range d start x end x) information type vertical position relative to page) as real
end vpos

on pageCount(d)
	tell application "Microsoft Word" to return (get range information (text object of d) information type number of pages in document) as integer
end pageCount

on docEnd(d)
	tell application "Microsoft Word" to return end of content of text object of d
end docEnd

-- How many pages past its first a range runs onto.
on span(d, s, e)
	return (my pageAt(d, e - 1)) - (my pageAt(d, s))
end span

-- An empty paragraph:  the hairline the build puts before a numbered section.
on isHairline(d, s, e)
	return (e - s) ≤ 1
end isHairline

-- The outline level of the heading that starts at x, or 0.
on levelAt(heads, x)
	repeat with h in heads
		if item 1 of h = x then return item 2 of h
		if item 1 of h > x then return 0
	end repeat
	return 0
end levelAt

-- Every heading, as {start, level, text}, in order.
on headings(d)
	set out to {}
	tell application "Microsoft Word"
		set r to create range d start 0 end 0
		set p to paragraph 1 of r
		set lvl to my levelNumber(outline level of p)
		if lvl ≤ 9 then set end of out to {0, lvl, content of text object of p}
		repeat
			set r2 to go to next r what goto a heading item
			if r2 is missing value then exit repeat
			set s to start of content of r2
			if s is missing value or s ≤ (start of content of r) then exit repeat
			set r to r2
			set p to paragraph 1 of r2
			set end of out to {s, my levelNumber(outline level of p), content of text object of p}
		end repeat
	end tell
	return out
end headings

on levelNumber(lv)
	tell application "Microsoft Word"
		set names to {outline level1, outline level2, outline level3, outline level4, outline level5, outline level6, outline level7, outline level8, outline level9}
	end tell
	repeat with k from 1 to 9
		if lv = item k of names then return k
	end repeat
	return 10
end levelNumber

-- Every run of text in a paragraph style, as {start, end}, through the selection.
on findAll(d, styleName)
	tell application "Microsoft Word"
		set f to my startFind(d)
		set style of f to styleName
	end tell
	return my runFind(d, f)
end findAll

-- Every paragraph with a forced page break before it, as {start, end}.
on findBreaks(d)
	tell application "Microsoft Word"
		set f to my startFind(d)
		set page break before of paragraph format of f to true
	end tell
	return my runFind(d, f)
end findBreaks

on startFind(d)
	tell application "Microsoft Word"
		set sel to selection
		set selection start of sel to 0
		set selection end of sel to 0
		set f to find object of sel
		clear formatting f
		set content of f to ""
		set format of f to true
		set forward of f to true
		set wrap of f to find stop
		return f
	end tell
end startFind

on runFind(d, f)
	set out to {}
	tell application "Microsoft Word"
		repeat
			if not (execute find f) then exit repeat
			set s to selection start of selection
			set e to selection end of selection
			if (count of out) > 0 and s ≤ item 1 of item -1 of out then exit repeat
			set end of out to {s, e}
			set selection start of selection to e
			set selection end of selection to e
		end repeat
	end tell
	return out
end runFind

-- ---------------------------------------------------------------------------
-- Small things.

on norm(t)
	set t to t as text
	set out to ""
	set wasSpace to true
	repeat with ch in characters of t
		set c to contents of ch
		if c is in {space, tab, return, linefeed, character id 160} then
			if not wasSpace then set out to out & " "
			set wasSpace to true
		else
			set out to out & c
			set wasSpace to false
		end if
	end repeat
	if out ends with " " then set out to text 1 thru -2 of out
	return out
end norm

-- A copy of a list of lists, sorted on one item, by insertion.
on sortBy(xs, k, ascending)
	set out to {}
	repeat with x in xs
		set x to contents of x
		set placed to false
		repeat with i from 1 to count of out
			set y to item k of item i of out
			if (ascending and (item k of x) < y) or ((not ascending) and (item k of x) > y) then
				if i = 1 then
					set beginning of out to x
				else
					set out to (items 1 thru (i - 1) of out) & {x} & (items i thru -1 of out)
				end if
				set placed to true
				exit repeat
			end if
		end repeat
		if not placed then set end of out to x
	end repeat
	return out
end sortBy
