--[[
Build a chapter's Markdown into one Word file and one Canvas module page per meeting.

    pandoc lua lessons/chapters/tools/build_chapter.lua 00 01 02
    pandoc lua lessons/chapters/tools/build_chapter.lua book

Needs nothing but pandoc 3.  Adapted on 2026-10-18 from OODP_Lessons'
Course/reference/build_chapter.lua, which builds the C# course's book.  The
Word files go in lessons/chapters/build/word, for Flint, which takes
curriculum documents best as .docx.  The Canvas pages go in
lessons/chapters/build/canvas, with every style inline, because Canvas strips
<style> blocks.  lessons/canvas_import is left alone.

The chapter is split at the headings named in CHAPTERS.  Each piece keeps its
Asides, Checks, and the rest as shaded boxes.  A Screenshot box with an image
in it prints the image with its caption underneath.  In Word the picture is
embedded.  On Canvas it's an <img> waiting for the file:  upload the PNG to
the course's Files and point the src at it (each one is flagged with a
SCREENSHOT comment).  A Screenshot box with no image prints an empty frame, as
it does in the C# book.

Edit the Markdown and re-run.  Leave the generated files alone -- the next run
overwrites them, chapter-reference.docx included.
]]

local HERE = pandoc.path.directory(arg[0])
local DRAFTS = pandoc.path.directory(HERE)
local SERIES = "Make Your Own Game"

-- One entry per chapter.  Each meeting starts at a line of the Markdown;  the
-- first starts at the top.  `note` is the subtitle for a meeting whose piece
-- opens with a Part heading in place of the chapter's own title and tagline.
local function draft(number, file, meetings)
  return {
    source = pandoc.path.join { DRAFTS, file },
    number = number,
    meetings = meetings,
    word_dir = pandoc.path.join { DRAFTS, "build", "word" },
    canvas_dir = pandoc.path.join { DRAFTS, "build", "canvas" },
  }
end

local CHAPTERS = {
  -- The prologue is one piece, with its own banner label and file name.
  ["00"] = (function()
    local cfg = draft(0, "chapter_00_prologue.md", { { starts = nil } })
    cfg.label = "Prologue"
    cfg.word_name = "Prologue.docx"
    cfg.canvas_name = "prologue.html"
    return cfg
  end)(),
  -- Lessons 1 to 5 take one meeting each, so each chapter is one piece.
  ["01"] = draft(1, "chapter_01_hello_blob.md", { { starts = nil } }),
  ["02"] = draft(2, "chapter_02_draw_your_character.md", { { starts = nil } }),
  ["03"] = draft(3, "chapter_03_bring_it_to_life.md", { { starts = nil } }),
  ["04"] = draft(4, "chapter_04_youre_in_control.md", { { starts = nil } }),
  ["05"] = draft(5, "chapter_05_build_your_world.md", { { starts = nil } }),
  -- Lesson 6 is two periods:  Day 1 is Parts One and Two, Day 2 the rest.
  ["06"] = draft(6, "chapter_06_collisions.md", {
    { starts = nil },
    { starts = "# Part Three", note = "Steps 7 to 10, and your own game:  the second meeting." },
  }),
  -- Lesson 7 is three periods:  one full loop, make it yours, play-test.
  ["07"] = draft(7, "chapter_07_build_your_game.md", {
    { starts = nil },
    { starts = "# Part Three", note = "Your character, your world, your rules:  the second meeting." },
    { starts = "# Part Four", note = "Somebody else plays your game:  the third meeting." },
  }),
}

-- The bonus chapters, one meeting each, lettered.
for letter, file in pairs { A = "bonus_a_images.md", B = "bonus_b_sounds.md",
                            C = "bonus_c_animation.md", D = "bonus_d_lists.md" } do
  local cfg = draft(0, file, { { starts = nil } })
  cfg.label = "Bonus " .. letter
  cfg.word_name = "Bonus" .. letter .. ".docx"
  cfg.canvas_name = "bonus-" .. letter:lower() .. ".html"
  CHAPTERS[letter] = cfg
end

-- The teacher reference.  A Word file for Flint, and no Canvas page:  it's for
-- teachers.
CHAPTERS["R"] = (function()
  local cfg = draft(0, "reference_api.md", { { starts = nil } })
  cfg.label = "Teacher Reference"
  cfg.word_name = "Teacher_Reference.docx"
  cfg.canvas_dir = {}
  return cfg
end)()

local NBSP = "\u{A0}"

-- Smart typography stays off.  It would turn `--` into an en dash and straight
-- quotes into curly ones, and meta/WRITING_COMMON_ERRORS.md entry 1 bans the
-- typographic dash.  The chapter's own characters go through unchanged.
local READER = "markdown-smart"

---------------------------------------------------------------------------
-- The double space
---------------------------------------------------------------------------

-- Markdown collapses two spaces after a sentence into one.  Jason reads by
-- those spaces, so this pass keeps them:  each becomes a no-break space plus a
-- space, which survives pandoc into Word and HTML.  A sentence that ends a
-- wrapped line gets the no-break space at the end of the line.  Code fences and
-- code spans are left alone.

local function strip_prefix(line)
  return (line:gsub("^[>%s]*", ""))
end

-- A line of prose can run on into the next line.  These can't.
local function not_prose(body)
  return body == "" or body:match("^```") or body:match("^#") or body:match("^|")
      or body:match("^%-%-%-")
end

-- A line that opens a new block, so the line above it ends a paragraph.
local function starts_block(body)
  return not_prose(body) or body:match("^%- ") or body:match("^%d+%. ")
end

local function protect_spaces(md)
  local lines = {}
  for line in (md:gsub("\r\n", "\n") .. "\n"):gmatch("(.-)\n") do
    lines[#lines + 1] = line
  end

  local fenced = false
  for i, line in ipairs(lines) do
    local body = strip_prefix(line)
    if body:match("^```") then
      fenced = not fenced
    elseif not fenced then
      local spans = {}
      line = line:gsub("`[^`]*`", function(span)
        spans[#spans + 1] = span
        return "\0" .. #spans .. "\0"
      end)
      line = line:gsub("(%S)  %f[%S]", "%1" .. NBSP .. " ")

      local next_body = lines[i + 1] and strip_prefix(lines[i + 1]) or ""
      if not not_prose(body) and not starts_block(next_body)
          and line:match("[.?!:;][%*_%)\"']*$") then
        line = line .. NBSP
      end
      lines[i] = line:gsub("%z(%d+)%z", function(n) return spans[tonumber(n)] end)
    end
  end
  return table.concat(lines, "\n")
end

---------------------------------------------------------------------------
-- Splitting into meetings
---------------------------------------------------------------------------

local function trim_rules(text)
  text = text:gsub("^%s*%-%-%-%s*\n", ""):gsub("\n%s*%-%-%-%s*$", "")
  return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function split_meetings(md, meetings)
  local pieces, rest = {}, md
  for k = #meetings, 2, -1 do
    local at = rest:find("\n" .. meetings[k].starts, 1, true)
    pieces[k] = rest:sub(at + 1)
    rest = rest:sub(1, at)
  end
  pieces[1] = rest
  return pieces
end

-- Pulls the opening "# Title" off a piece, and the italic line under it if
-- there is one, for the banner and the Word title.
local function take_title(piece)
  local title, after = piece:match("^#%s+([^\n]+)\n(.*)$")
  local subtitle, rest = after:match("^%s*%*([^%*\n][^\n]*)%*%s*\n(.*)$")
  if subtitle then return title, subtitle, trim_rules(rest) end
  return title, nil, trim_rules(after)
end

---------------------------------------------------------------------------
-- The boxes
---------------------------------------------------------------------------

-- Blockquotes that open with one of these bold labels become boxes.
local BOXES = {
  ["Aside"] = { fill = "F2F7FD", edge = "CFE0F3", accent = "2B6CB0" },
  ["Check"] = { fill = "F1FBF5", edge = "C2E6D1", accent = "1D7A44" },
  ["Tonight"] = { fill = "FFFAF0", edge = "F0DCBC", accent = "C2761C" },
  ["Watch out"] = { fill = "FDF2F1", edge = "F0C9C4", accent = "B4382C" },
  ["Answer in your notes"] = { fill = "FAF4FE", edge = "E0CBF0", accent = "7B3FA0" },
  ["Argue it"] = { fill = "FAF4FE", edge = "E0CBF0", accent = "7B3FA0" },
}

local function label_of(block)
  if block.t ~= "Para" or not block.content[1] or block.content[1].t ~= "Strong" then
    return nil
  end
  return pandoc.utils.stringify(block.content[1]):match("^(.-)[%.:]")
end

-- The caption is whatever follows the bold "Screenshot:" label.
local function caption_of(para)
  local inlines = pandoc.Inlines {}
  for k = 2, #para.content do inlines:insert(para.content[k]) end
  while inlines[1] and (inlines[1].t == "Space"
      or (inlines[1].t == "Str" and inlines[1].text:gsub(NBSP, ""):match("^%s*$"))) do
    inlines:remove(1)
  end
  return inlines
end

local TEXT_WIDTH = 9360   -- US Letter, one-inch margins, in twentieths of a point

local function no_look()
  return '<w:tblLook w:val="0000" w:firstRow="0" w:lastRow="0" w:firstColumn="0" '
      .. 'w:lastColumn="0" w:noHBand="1" w:noVBand="1"/>'
end

-- Roughly how many lines a box will take on the page, counting a wrapped line
-- of prose at about 85 characters, plus a line of spacing per paragraph.
local function box_lines(content)
  local lines = 0
  for _, block in ipairs(content) do
    if block.t == "CodeBlock" then
      for line in (block.text .. "\n"):gmatch("(.-)\n") do
        lines = lines + math.max(1, math.ceil(#line / 90))
      end
      lines = lines + 1
    elseif block.t == "Table" then
      lines = lines + 2 * (#block.bodies[1].body + 1)
    else
      lines = lines + math.ceil(#pandoc.utils.stringify(block) / 85) + 1
    end
  end
  return lines
end

-- A box is a table.  A box that fits on a page is one row that can't split,
-- so it moves to the next page whole and never breaks across two, even with a
-- table inside it.  A longer box breaks between its parts:  each code block, and
-- each table, gets a row of its own that can't split (Word ignores "keep lines
-- together" inside a table cell), and the prose between them shares a row.
-- Borders are drawn per cell, top on the first row and bottom on the last, so
-- the rows read as one box.
local SHORT_BOX = 44   -- lines;  about a page
local function word_box(c, content)
  local rows = {}
  if box_lines(content) <= SHORT_BOX then
    rows[1] = { code = true, blocks = pandoc.List(content) }
  else
    for _, block in ipairs(content) do
      local last = rows[#rows]
      local whole = block.t == "CodeBlock" or block.t == "Table"   -- kept on one page
      if whole or not last or last.code then
        rows[#rows + 1] = { code = whole, blocks = pandoc.List { block } }
      else
        last.blocks:insert(block)
      end
    end
  end

  local edge = ('w:val="single" w:sz="4" w:space="0" w:color="%s"'):format(c.edge)
  local out = pandoc.List { pandoc.RawBlock("openxml", table.concat {
    '<w:tbl><w:tblPr><w:tblW w:w="', TEXT_WIDTH, '" w:type="dxa"/>',
    '<w:tblInd w:w="92" w:type="dxa"/><w:tblLayout w:type="fixed"/>',
    '<w:tblBorders><w:top w:val="nil"/><w:left w:val="nil"/><w:bottom w:val="nil"/>',
    '<w:right w:val="nil"/><w:insideH w:val="nil"/><w:insideV w:val="nil"/></w:tblBorders>',
    '<w:tblCellMar><w:top w:w="0" w:type="dxa"/><w:left w:w="200" w:type="dxa"/>',
    '<w:bottom w:w="0" w:type="dxa"/><w:right w:w="200" w:type="dxa"/></w:tblCellMar>',
    no_look(), '</w:tblPr><w:tblGrid><w:gridCol w:w="', TEXT_WIDTH, '"/></w:tblGrid>',
  }) }
  for k, row in ipairs(rows) do
    local first, last = k == 1, k == #rows
    out:insert(pandoc.RawBlock("openxml", table.concat {
      '<w:tr>', row.code and '<w:trPr><w:cantSplit/></w:trPr>' or '',
      '<w:tc><w:tcPr><w:tcW w:w="', TEXT_WIDTH, '" w:type="dxa"/><w:tcBorders>',
      first and ('<w:top ' .. edge .. '/>') or '<w:top w:val="nil"/>',
      '<w:left w:val="single" w:sz="36" w:space="0" w:color="', c.accent, '"/>',
      last and ('<w:bottom ' .. edge .. '/>') or '<w:bottom w:val="nil"/>',
      '<w:right ', edge, '/></w:tcBorders>',
      '<w:shd w:val="clear" w:color="auto" w:fill="', c.fill, '"/>',
      '<w:tcMar><w:top w:w="', first and 60 or 0, '" w:type="dxa"/>',
      '<w:bottom w:w="', last and 60 or 0, '" w:type="dxa"/></w:tcMar></w:tcPr>',
    }))
    out:extend(row.blocks)
    -- A cell has to end on a paragraph, and a table is no paragraph.
    local tail = row.blocks[#row.blocks].t == "Table"
      and '<w:p><w:pPr><w:spacing w:before="0" w:after="0" w:line="120" w:lineRule="exact"/></w:pPr></w:p>'
      or ""
    out:insert(pandoc.RawBlock("openxml", tail .. "</w:tc></w:tr>"))
  end
  -- Two tables in a row would run together in Word, so a thin paragraph
  -- follows each box.
  out:insert(pandoc.RawBlock("openxml", '</w:tbl><w:p><w:pPr><w:spacing w:before="0" '
    .. 'w:after="0" w:line="120" w:lineRule="exact"/></w:pPr></w:p>'))
  return out
end

local function word_screenshot()
  local dash = 'w:val="dashed" w:sz="8" w:space="0" w:color="94A3B8"'
  return pandoc.RawBlock("openxml", table.concat {
    '<w:tbl><w:tblPr><w:tblW w:w="', TEXT_WIDTH, '" w:type="dxa"/>',
    '<w:tblLayout w:type="fixed"/><w:tblBorders>',
    '<w:top ', dash, '/><w:left ', dash, '/><w:bottom ', dash, '/><w:right ', dash, '/>',
    '</w:tblBorders>', no_look(), '</w:tblPr>',
    '<w:tblGrid><w:gridCol w:w="', TEXT_WIDTH, '"/></w:tblGrid>',
    '<w:tr><w:trPr><w:cantSplit/><w:trHeight w:val="3600" w:hRule="atLeast"/></w:trPr><w:tc><w:tcPr>',
    '<w:tcW w:w="', TEXT_WIDTH, '" w:type="dxa"/>',
    '<w:shd w:val="clear" w:color="auto" w:fill="F8FAFC"/><w:vAlign w:val="center"/></w:tcPr>',
    '<w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:color w:val="94A3B8"/></w:rPr>',
    '<w:t>Screenshot</w:t></w:r></w:p></w:tc></w:tr></w:tbl>',
  })
end

local function html_box(c, blocks)
  return pandoc.Div(blocks, { style = ("background:#%s;border:1px solid #%s;border-left:5px solid #%s;"
      .. "border-radius:6px;padding:12px 20px 2px;margin:20px 0;"):format(c.fill, c.edge, c.accent) })
end

-- The first image inside a Screenshot box, if it has one.  Its path is taken
-- relative to lessons/chapters, the folder the chapters live in.
local function image_of(blocks)
  local found
  pandoc.Blocks(blocks):walk { Image = function(img) found = found or img end }
  return found
end

local function local_path(src)
  if src:match("^%a:[/\\]") or src:match("^/") then return src end
  return pandoc.path.join { DRAFTS, src }
end

-- In Word, the picture goes in at a printable width, small enough that a
-- picture and the text around it can share a page.  The PNGs are frames saved
-- at pixelDensity(2), so they're twice the window's size, or a crop of one.
local function word_image(img, caption)
  local src = local_path(img.src)
  local width = img.attributes.width or "3.4in"
  local pic = pandoc.Image({}, src, "", { width = width })
  return {
    pandoc.Div({ pandoc.Para { pic } }, { ["custom-style"] = "Screenshot" }),
    pandoc.Div({ pandoc.Para(caption) }, { ["custom-style"] = "Screenshot Caption" }),
  }
end

-- On Canvas the src is just the file name, for the course's Files.
local function html_image(img, caption)
  local name = pandoc.path.filename(img.src)
  return {
    pandoc.RawBlock("html", "<!-- SCREENSHOT:  upload " .. name .. " to Files, then point this src at it -->"),
    pandoc.RawBlock("html", '<p style="margin:20px 0 6px;text-align:center;"><img src="' .. name
      .. '" alt="' .. pandoc.utils.stringify(caption):gsub('"', "&quot;")
      .. '" style="max-width:100%;width:440px;border:1px solid #c9d8e8;border-radius:6px;" /></p>'),
    pandoc.Div({ pandoc.Para(caption) },
      { style = "font-size:14px;color:#5b6b7a;font-style:italic;margin:0 0 18px;text-align:center;" }),
  }
end

local function html_screenshot(caption)
  return {
    pandoc.RawBlock("html", '<div style="border:2px dashed #b8c4d0;border-radius:8px;'
      .. 'background:#f8fafc;min-height:180px;margin:20px 0 6px;display:flex;'
      .. 'align-items:center;justify-content:center;color:#94a3b8;font-size:15px;">Screenshot</div>'),
    pandoc.Div({ pandoc.Para(caption) },
      { style = "font-size:14px;color:#5b6b7a;font-style:italic;margin:0 0 18px;" }),
  }
end

-- An empty paragraph, a hair tall, that starts a new page.  The heading after
-- it lands at the top.
local PAGE_BREAK = pandoc.RawBlock("openxml", '<w:p><w:pPr><w:pageBreakBefore/>'
  .. '<w:spacing w:before="0" w:after="0" w:line="20" w:lineRule="exact"/></w:pPr></w:p>')

-- In Word, a code block is one paragraph that keeps its lines together.  One
-- taller than a page jumps to the next page and then breaks anyway, leaving
-- the sentence that introduced it alone on a page.  So a long block is cut into
-- pieces of about 40 lines, at a blank line where there is one.  Adjacent code
-- paragraphs share their border, so the pieces still read as one listing, and
-- Word can turn the page between them.  This book's 149-line Chapter 7 starter
-- is why.
local LONG_CODE = 50
local function split_long_code(block)
  local lines = {}
  for line in (block.text .. "\n"):gmatch("(.-)\n") do lines[#lines + 1] = line end
  if #lines <= LONG_CODE then return nil end
  local pieces, start = pandoc.Blocks {}, 1
  while start <= #lines do
    local stop = math.min(start + 39, #lines)
    if stop < #lines then
      -- Back up to a blank line, if one is near.
      for k = stop, start + 25, -1 do
        if lines[k]:match("^%s*$") then stop = k; break end
      end
    end
    pieces:insert(pandoc.CodeBlock(table.concat(lines, "\n", start, stop), block.attr))
    start = stop + 1
  end
  return pieces
end

local function box_filter(format)
  return {
    -- In Word, a Part heading starts a new page (its style says so), and so
    -- does a numbered section, ## 1.1 and on.  A numbered section right under
    -- a Part heading shares its page.  The rule above a Part heading would be
    -- left alone at the foot of the page before, so it goes.
    Blocks = function(blocks)
      if format ~= "docx" then return nil end
      local out = pandoc.Blocks {}
      -- What has come since the last Part heading:  a few plain paragraphs
      -- are a short introduction, and the section after them shares its page.
      local since_part = nil
      for k, block in ipairs(blocks) do
        local before, after = blocks[k - 1], blocks[k + 1]
        if block.t == "HorizontalRule" and after and after.t == "Header" and after.level == 1 then
          -- dropped
        else
          local short_intro = since_part and since_part.paras <= 3 and not since_part.other
          if block.t == "Header" and block.level == 2
              and pandoc.utils.stringify(block):match("^%d+%.%d+")
              and not short_intro then
            out:insert(PAGE_BREAK)
          end
          if block.t == "Header" and block.level == 1 then
            since_part = { paras = 0, other = false }
          elseif block.t == "Header" then
            since_part = nil
          elseif since_part then
            if block.t == "Para" then since_part.paras = since_part.paras + 1
            else since_part.other = true end
          end
          -- A paragraph that leads into a box, a code block, or a table stays
          -- on the same page as it.  The boxes are raw tables by now.
          local leads_in = after and (after.t == "CodeBlock" or after.t == "Table"
            or (after.t == "RawBlock" and after.text:sub(1, 7) == "<w:tbl>"))
          if block.t == "Para" and leads_in then
            out:insert(pandoc.Div({ block }, { ["custom-style"] = "Keep With Next" }))
          else
            out:insert(block)
          end
        end
      end
      return out
    end,
    -- [*]{.iceberg}:  one big asterisk, right after a claim the chapter has
    -- simplified on purpose.  Left unexplained.
    Span = function(span)
      if not span.classes:includes("iceberg") then return nil end
      if format == "docx" then
        return pandoc.RawInline("openxml", '<w:r><w:rPr><w:b/><w:color w:val="1F4E79"/>'
          .. '<w:position w:val="-2"/><w:sz w:val="40"/><w:szCs w:val="40"/></w:rPr><w:t>*</w:t></w:r>')
      end
      return pandoc.RawInline("html", '<span style="font-size:1.7em;font-weight:bold;'
        .. 'color:#1F4E79;line-height:0;vertical-align:-0.15em;">*</span>')
    end,
    Header = function(header)
      if format ~= "docx" then return nil end
      return header:walk {
        Code = function(code)
          return pandoc.Span(code.text, { ["custom-style"] = "Heading Code" })
        end,
      }
    end,
    BlockQuote = function(quote)
      local label = label_of(quote.content[1])
      if label == "Screenshot" then
        local caption = caption_of(quote.content[1])
        local img = image_of(quote.content)
        if img then
          if format == "docx" then return word_image(img, caption) end
          return html_image(img, caption)
        end
        if format == "docx" then
          return { word_screenshot(),
                   pandoc.Div({ pandoc.Para(caption) }, { ["custom-style"] = "Caption" }) }
        end
        return html_screenshot(caption)
      end
      local colours = BOXES[label]
      if not colours then return nil end
      if format == "docx" then return word_box(colours, quote.content) end
      return html_box(colours, quote.content)
    end,
  }
end

---------------------------------------------------------------------------
-- Word
---------------------------------------------------------------------------

-- Pandoc's default reference.docx, restyled:  Calibri, Consolas, accent
-- 1F4E79, US Letter, code in shaded blocks, and tables with borders.
local STYLES = {
  Title = [[<w:style w:type="paragraph" w:styleId="Title"><w:name w:val="Title"/>
<w:basedOn w:val="Normal"/><w:next w:val="BodyText"/><w:qFormat/>
<w:pPr><w:spacing w:before="0" w:after="60"/></w:pPr>
<w:rPr><w:b/><w:color w:val="1F4E79"/><w:sz w:val="48"/><w:szCs w:val="48"/></w:rPr></w:style>]],
  Subtitle = [[<w:style w:type="paragraph" w:styleId="Subtitle"><w:name w:val="Subtitle"/>
<w:basedOn w:val="Normal"/><w:next w:val="BodyText"/><w:qFormat/>
<w:pPr><w:spacing w:before="0" w:after="60"/></w:pPr>
<w:rPr><w:i/><w:color w:val="2D3B47"/><w:sz w:val="28"/><w:szCs w:val="28"/></w:rPr></w:style>]],
  Date = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="Date"><w:name w:val="Date"/>
<w:basedOn w:val="Normal"/><w:next w:val="BodyText"/><w:qFormat/>
<w:pPr><w:pBdr><w:bottom w:val="single" w:sz="8" w:space="6" w:color="1F4E79"/></w:pBdr>
<w:spacing w:before="0" w:after="240"/></w:pPr>
<w:rPr><w:b/><w:caps/><w:color w:val="5B6B7A"/><w:spacing w:val="10"/><w:sz w:val="18"/><w:szCs w:val="18"/></w:rPr></w:style>]],
  SourceCode = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="SourceCode"><w:name w:val="Source Code"/>
<w:basedOn w:val="Normal"/><w:link w:val="VerbatimChar"/>
<w:pPr><w:keepLines/><w:pBdr><w:top w:val="single" w:sz="4" w:space="4" w:color="C9D8E8"/>
<w:left w:val="single" w:sz="4" w:space="4" w:color="C9D8E8"/>
<w:bottom w:val="single" w:sz="4" w:space="4" w:color="C9D8E8"/>
<w:right w:val="single" w:sz="4" w:space="4" w:color="C9D8E8"/></w:pBdr>
<w:shd w:val="clear" w:color="auto" w:fill="F8FAFC"/>
<w:spacing w:before="0" w:after="0" w:line="240" w:lineRule="auto"/>
<w:ind w:left="100" w:right="100"/></w:pPr></w:style>]],
  VerbatimChar = [[<w:style w:type="character" w:customStyle="1" w:styleId="VerbatimChar">
<w:name w:val="Verbatim Char"/><w:basedOn w:val="BodyTextChar"/>
<w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" w:cs="Consolas"/><w:color w:val="1A4D80"/>
<w:sz w:val="19"/><w:szCs w:val="19"/></w:rPr></w:style>]],
  -- Code in a heading takes the heading's size, where Verbatim Char would shrink it.
  HeadingCode = [[<w:style w:type="character" w:customStyle="1" w:styleId="HeadingCode">
<w:name w:val="Heading Code"/><w:basedOn w:val="DefaultParagraphFont"/>
<w:rPr><w:rFonts w:ascii="Consolas" w:hAnsi="Consolas" w:cs="Consolas"/></w:rPr></w:style>]],
  -- A paragraph that introduces what comes next, kept on its page.
  KeepWithNext = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="KeepWithNext">
<w:name w:val="Keep With Next"/><w:basedOn w:val="BodyText"/>
<w:pPr><w:keepNext/></w:pPr></w:style>]],
  -- The compiled book's title page.
  BookTitle = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="BookTitle">
<w:name w:val="Book Title"/><w:basedOn w:val="Normal"/>
<w:pPr><w:jc w:val="center"/><w:spacing w:before="240" w:after="120"/></w:pPr>
<w:rPr><w:b/><w:color w:val="1F4E79"/><w:sz w:val="64"/><w:szCs w:val="64"/></w:rPr></w:style>]],
  BookSubtitle = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="BookSubtitle">
<w:name w:val="Book Subtitle"/><w:basedOn w:val="Normal"/>
<w:pPr><w:jc w:val="center"/><w:spacing w:before="0" w:after="480"/></w:pPr>
<w:rPr><w:i/><w:color w:val="2D3B47"/><w:sz w:val="30"/><w:szCs w:val="30"/></w:rPr></w:style>]],
  BookByline = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="BookByline">
<w:name w:val="Book Byline"/><w:basedOn w:val="Normal"/>
<w:pPr><w:jc w:val="center"/><w:spacing w:before="0" w:after="60"/></w:pPr>
<w:rPr><w:color w:val="5B6B7A"/><w:sz w:val="24"/><w:szCs w:val="24"/></w:rPr></w:style>]],
  -- A screenshot, and the caption under it.  The picture keeps with its
  -- caption, so the two always share a page.
  Screenshot = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="Screenshot">
<w:name w:val="Screenshot"/><w:basedOn w:val="Normal"/><w:next w:val="ScreenshotCaption"/>
<w:pPr><w:keepNext/><w:jc w:val="center"/><w:spacing w:before="160" w:after="40"/></w:pPr></w:style>]],
  ScreenshotCaption = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="ScreenshotCaption">
<w:name w:val="Screenshot Caption"/><w:basedOn w:val="Normal"/><w:next w:val="BodyText"/>
<w:pPr><w:jc w:val="center"/><w:spacing w:before="0" w:after="240"/></w:pPr>
<w:rPr><w:i/><w:color w:val="5B6B7A"/><w:sz w:val="19"/><w:szCs w:val="19"/></w:rPr></w:style>]],
  BookCover = [[<w:style w:type="paragraph" w:customStyle="1" w:styleId="BookCover">
<w:name w:val="Book Cover"/><w:basedOn w:val="Normal"/>
<w:pPr><w:jc w:val="center"/><w:spacing w:before="720" w:after="360"/></w:pPr></w:style>]],
  Table = [[<w:style w:type="table" w:default="1" w:styleId="Table"><w:name w:val="Table"/>
<w:basedOn w:val="TableNormal"/><w:qFormat/>
<w:pPr><w:spacing w:before="40" w:after="40"/></w:pPr>
<w:tblPr><w:tblInd w:w="0" w:type="dxa"/><w:tblBorders>
<w:top w:val="single" w:sz="4" w:space="0" w:color="C9D8E8"/>
<w:left w:val="single" w:sz="4" w:space="0" w:color="C9D8E8"/>
<w:bottom w:val="single" w:sz="4" w:space="0" w:color="C9D8E8"/>
<w:right w:val="single" w:sz="4" w:space="0" w:color="C9D8E8"/>
<w:insideH w:val="single" w:sz="4" w:space="0" w:color="C9D8E8"/>
<w:insideV w:val="single" w:sz="4" w:space="0" w:color="C9D8E8"/></w:tblBorders>
<w:tblCellMar><w:top w:w="60" w:type="dxa"/><w:left w:w="108" w:type="dxa"/>
<w:bottom w:w="60" w:type="dxa"/><w:right w:w="108" w:type="dxa"/></w:tblCellMar></w:tblPr>
<w:tblStylePr w:type="firstRow"><w:rPr><w:b/><w:color w:val="3D556F"/></w:rPr>
<w:tcPr><w:shd w:val="clear" w:color="auto" w:fill="E5EDF5"/></w:tcPr></w:tblStylePr></w:style>]],
}

local function restyle(styles)
  styles = styles:gsub("<w:rFonts[^>]-Theme[^>]*/>",
    '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" w:eastAsia="Calibri" w:cs="Calibri" />')
  styles = styles:gsub('<w:color w:val="0F4761"[^>]*/>', '<w:color w:val="1F4E79" />')
  -- Each Part starts a new page.
  styles = styles:gsub('(w:styleId="Heading1">.-<w:pPr>)', '%1<w:pageBreakBefore/>', 1)
  styles = styles:gsub('<w:sz w:val="24" />', '<w:sz w:val="22" />', 1)
  styles = styles:gsub('<w:szCs w:val="24" />', '<w:szCs w:val="22" />', 1)
  for id, xml in pairs(STYLES) do
    local pattern = '<w:style [^>]-w:styleId="' .. id .. '".-</w:style>'
    styles = styles:gsub(pattern, "", 1)
    styles = styles:gsub("</w:styles>", function() return xml .. "\n</w:styles>" end)
  end
  return styles
end

local function make_reference_doc(path, left_margin)
  local left = left_margin or 1440
  local bytes = pandoc.pipe("pandoc", { "--print-default-data-file", "reference.docx" }, "")
  local archive = pandoc.zip.Archive(bytes)
  local entries = pandoc.List()
  for _, entry in ipairs(archive.entries) do
    local contents = entry:contents()
    if entry.path == "word/styles.xml" then
      contents = restyle(contents)
    elseif entry.path == "word/document.xml" then
      contents = contents:gsub("<w:sectPr>", '<w:sectPr><w:pgSz w:w="12240" w:h="15840"/>'
        .. '<w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="' .. left .. '" '
        .. 'w:header="720" w:footer="720" w:gutter="0"/>', 1)
    end
    entries:insert(pandoc.zip.Entry(entry.path, contents))
  end
  local f = assert(io.open(path, "wb"))
  f:write(pandoc.zip.Archive(entries):bytestring())
  f:close()
end

-- Every paragraph in a table row keeps with the next row.  The paragraph's
-- style has to come first inside its properties, so keepNext goes after it.
local function keep_with_next(row)
  row = row:gsub('<w:p><w:pPr><w:pStyle ([^>]-)/>', '<w:p><w:pPr><w:pStyle %1/><w:keepNext />')
  row = row:gsub('<w:p><w:pPr>(<w:%a+)', function(tag)
    if tag == "<w:pStyle" or tag == "<w:keepNext" then return nil end
    return '<w:p><w:pPr><w:keepNext />' .. tag
  end)
  return (row:gsub('<w:p>(<w:[rh])', '<w:p><w:pPr><w:keepNext /></w:pPr>%1'))
end

-- pandoc's tables, the ones styled "Table", stay on one page:  no row splits,
-- and every row but the last keeps with the next.  The boxes are tables too,
-- and they stay free to break between their rows.  pandoc's tables hold no
-- tables of their own, so the first </w:tbl> after one starts is its end.
local function keep_tables_whole(xml)
  return (xml:gsub('<w:tbl><w:tblPr><w:tblStyle w:val="Table" />.-</w:tbl>', function(tbl)
    local count = select(2, tbl:gsub("<w:tr>", ""))
    local k = 0
    return (tbl:gsub("<w:tr>(.-)</w:tr>", function(row)
      k = k + 1
      if row:sub(1, 8) == "<w:trPr>" then
        row = "<w:trPr><w:cantSplit />" .. row:sub(9)
      else
        row = "<w:trPr><w:cantSplit /></w:trPr>" .. row
      end
      if k < count then row = keep_with_next(row) end
      return "<w:tr>" .. row .. "</w:tr>"
    end))
  end))
end

-- Every picture gets a thin border, in the tables' edge color.  A sketch with
-- a white background is a white rectangle, and on a white page it vanishes.
-- pandoc already writes each picture an outline with no fill, so this fills it.
local function frame_pictures(xml)
  return (xml:gsub('<a:ln w="9525">%s*<a:noFill%s*/>',
    '<a:ln w="9525"><a:solidFill><a:srgbClr val="C9D8E8" /></a:solidFill>'))
end

local function finish_docx(bytes)
  local archive = pandoc.zip.Archive(bytes)
  local entries = pandoc.List()
  for _, entry in ipairs(archive.entries) do
    local contents = entry:contents()
    if entry.path == "word/document.xml" then contents = frame_pictures(keep_tables_whole(contents)) end
    entries:insert(pandoc.zip.Entry(entry.path, contents))
  end
  return pandoc.zip.Archive(entries):bytestring()
end

local function write_docx(md, info, reference, path)
  local doc = pandoc.read(md, READER):walk { CodeBlock = split_long_code }:walk(box_filter("docx"))
  doc.meta.title = pandoc.Inlines(pandoc.read(info.title, READER).blocks[1].content)
  if info.subtitle then
    doc.meta.subtitle = pandoc.Inlines(pandoc.read(info.subtitle, READER).blocks[1].content)
  end
  doc.meta.date = info.label
  local f = assert(io.open(path, "wb"))
  f:write(finish_docx(pandoc.write(doc, "docx", { reference_doc = reference })))
  f:close()
end

---------------------------------------------------------------------------
-- Canvas
---------------------------------------------------------------------------

local FONT = "font-family:Lato,Helvetica,Arial,sans-serif;"
local MONO = "font-family:Consolas,Menlo,Monaco,monospace;"
local CODE = "background:#eef2f7;border:1px solid #d8e2ec;border-radius:3px;padding:1px 5px;"
    .. MONO .. "font-size:0.92em;color:#1a4d80;"
local PRE = "margin:18px 0;background:#f8fafc;border:1px solid #c9d8e8;border-radius:6px;"
    .. "padding:14px 16px;overflow-x:auto;" .. MONO .. "font-size:13px;line-height:1.55;"
    .. "color:#1f2933;white-space:pre;"
local H1 = FONT .. "color:#1f4e79;font-size:27px;font-weight:700;margin:44px 0 14px;"
local H2 = FONT .. "color:#2b6cb0;font-size:21px;font-weight:700;margin:34px 0 12px;"
    .. "padding-bottom:7px;border-bottom:2px solid #dfe6ec;"
local H3 = FONT .. "color:#22303c;font-size:18px;font-weight:700;margin:24px 0 10px;"
local P = "margin:0 0 12px;"
local LIST = "margin:0 0 14px;padding-left:24px;"
local LI = "margin:0 0 7px;"
local TABLE = "border-collapse:collapse;width:100%;min-width:520px;" .. FONT .. "font-size:15px;"
    .. "margin:0 0 14px;"
local TH = "background:#e5edf5;border:1px solid #c9d8e8;padding:9px 12px;text-align:left;"
    .. "vertical-align:top;color:#3d556f;font-size:13px;font-weight:700;"
    .. "letter-spacing:0.04em;text-transform:uppercase;"
local TD = "border:1px solid #dfe6ec;padding:9px 12px;vertical-align:top;"
local HR = "border:none;border-top:2px solid #dfe6ec;margin:36px 0;"

-- Pandoc marks highlighted code with classes, which Canvas strips, so each
-- token class becomes an inline colour.  Unlisted classes print plain.
local TOKENS = {
  kw = "color:#0033b3;", cf = "color:#0033b3;", dt = "color:#0f6b7a;",
  dv = "color:#1750eb;", bn = "color:#1750eb;", fl = "color:#1750eb;",
  st = "color:#067d17;", ch = "color:#067d17;", sc = "color:#067d17;",
  co = "color:#8c8c8c;font-style:italic;", ["do"] = "color:#8c8c8c;font-style:italic;",
  fu = "color:#00627a;", at = "color:#9e880d;",
}

local function code_block(inner)
  local lines = {}
  for line in (inner .. "\n"):gmatch("(.-)\n") do
    local stripped, n = line:gsub('^<span id="cb[%d%-]+"><a [^>]*></a>', "")
    if n > 0 then stripped = stripped:gsub("</span>$", "") end
    lines[#lines + 1] = stripped
  end
  local body = table.concat(lines, "\n"):gsub('<span class="(%a+)">', function(class)
    return TOKENS[class] and ('<span style="' .. TOKENS[class] .. '">') or "<span>"
  end)
  return '<pre style="' .. PRE .. '">' .. body .. "</pre>"
end

local function inline_styles(html)
  html = html:gsub('<div class="sourceCode"[^>]*><pre%s+class="[^"]*"><code[^>]*>(.-)</code></pre></div>',
    code_block)
  html = html:gsub("<pre><code>(.-)</code></pre>", code_block)
  local rules = {
    { "<h1([^>]*)>", '<h1%1 style="' .. H1 .. '">' },
    { "<h2([^>]*)>", '<h2%1 style="' .. H2 .. '">' },
    { "<h3([^>]*)>", '<h3%1 style="' .. H3 .. '">' },
    { "<p>", '<p style="' .. P .. '">' },
    { "<ul>", '<ul style="' .. LIST .. '">' },
    { "<ol[^>]*>", '<ol style="' .. LIST .. '">' },
    { "<li>", '<li style="' .. LI .. '">' },
    { "<table>", '<div style="overflow-x:auto;"><table style="' .. TABLE .. '">' },
    { "</table>", "</table></div>" },
    { "<th>", '<th style="' .. TH .. '">' },
    { "<th [^>]*>", '<th style="' .. TH .. '">' },
    { "<td[^>]*>", '<td style="' .. TD .. '">' },
    { "<code>", '<code style="' .. CODE .. '">' },
    { '<a href="', '<a style="color:#2b6cb0;" href="' },
    { "<hr />", '<hr style="' .. HR .. '" />' },
  }
  for _, rule in ipairs(rules) do
    html = html:gsub(rule[1], function(attrs)
      return (rule[2]:gsub("%%1", function() return attrs end))
    end)
  end
  return html
end

-- The no-break space becomes &nbsp;, and anything else outside ASCII a numeric
-- entity, so the page survives any encoding Canvas throws at it.
local function ascii_safe(s)
  local out = {}
  for _, c in utf8.codes(s) do
    if c == 160 then out[#out + 1] = "&nbsp;"
    elseif c < 128 then out[#out + 1] = utf8.char(c)
    else out[#out + 1] = "&#" .. c .. ";" end
  end
  return table.concat(out)
end

local function inline_html(text)
  local html = pandoc.write(pandoc.read(text, READER), "html")
  return inline_styles(html:gsub("^<p>", ""):gsub("</p>%s*$", ""))
end

local function banner(info)
  return table.concat {
    '<div style="background:#2b6cb0;border-radius:10px;padding:24px 26px;margin:0 0 22px;">',
    '<p style="margin:0 0 6px;font-size:12px;font-weight:700;letter-spacing:0.14em;',
    'text-transform:uppercase;color:#dbe7f5;">', info.label, '  &middot;  ', SERIES, '</p>',
    '<h1 style="margin:0;', FONT, 'font-size:31px;line-height:1.2;font-weight:700;color:#ffffff;">',
    inline_html(info.title), '</h1>',
    info.subtitle and ('<p style="margin:10px 0 0;font-size:16px;color:#eaf2fb;">'
      .. inline_html(info.subtitle) .. '</p>') or "",
    '</div>',
  }
end

local function write_canvas(md, info, path, source_name)
  local doc = pandoc.read(md, READER):walk(box_filter("html"))
  local body = inline_styles(pandoc.write(doc, "html", { wrap_text = "none" }))
  local page = table.concat {
    "<!-- ==========================================================\n",
    "     ", info.title, "  |  CANVAS MODULE PAGE (student-facing)\n",
    "     Generated by lessons/chapters/tools/build_chapter.lua from\n",
    "     lessons/chapters/", source_name, ".\n",
    "     Edit the Markdown and re-run;  this file gets overwritten.\n",
    "     ========================================================== -->\n",
    '<div style="', FONT, 'color:#2d3b47;font-size:16px;line-height:1.62;">\n',
    banner(info), "\n", body, "\n</div>\n",
  }
  local f = assert(io.open(path, "wb"))
  f:write(ascii_safe(page))
  f:close()
end

---------------------------------------------------------------------------

local function build(key)
  local cfg = assert(CHAPTERS[key], "no chapter " .. key .. " in CHAPTERS")
  local f = assert(io.open(cfg.source, "rb"))
  local md = protect_spaces(f:read("a"))
  f:close()

  local reference = pandoc.path.join { HERE, "chapter-reference.docx" }
  make_reference_doc(reference)

  local source_name = pandoc.path.make_relative(cfg.source, DRAFTS):gsub("\\", "/")
  -- Either setting may be one folder or a list of them;  every file gets
  -- written to each.
  local function folders(setting, default)
    local list = type(setting) == "table" and setting or { setting or default }
    for _, dir in ipairs(list) do pandoc.system.make_directory(dir, true) end
    return list
  end
  local word_dirs = folders(cfg.word_dir, pandoc.path.join { DRAFTS, "build", "word" })
  local canvas_dirs = folders(cfg.canvas_dir, pandoc.path.join { DRAFTS, "build", "canvas" })
  local count = #cfg.meetings
  for k, piece in ipairs(split_meetings(md, cfg.meetings)) do
    local title, subtitle, body = take_title(trim_rules(piece))
    -- A one-meeting chapter is the whole chapter, so its label says so.
    local label = count == 1 and ("Chapter %d"):format(cfg.number)
      or ("Chapter %d  ·  Meeting %d of %d"):format(cfg.number, k, count)
    local info = {
      title = title,
      subtitle = subtitle or cfg.meetings[k].note,
      label = cfg.label or label,
    }
    for _, dir in ipairs(word_dirs) do
      local docx = pandoc.path.join { dir, cfg.word_name or (count == 1
        and ("Chapter%02d.docx"):format(cfg.number)
        or ("Chapter%02d_Meeting%d.docx"):format(cfg.number, k)) }
      write_docx(body, info, reference, docx)
      print("wrote " .. docx)
    end
    for _, dir in ipairs(canvas_dirs) do
      local html = pandoc.path.join { dir, cfg.canvas_name or (count == 1
        and ("chapter-%02d.html"):format(cfg.number)
        or ("chapter-%02d-meeting-%d.html"):format(cfg.number, k)) }
      write_canvas(body, info, html, source_name)
      print("wrote " .. html)
    end
  end
end

---------------------------------------------------------------------------
-- The whole book, in one Word file, for printing
---------------------------------------------------------------------------

-- `pandoc lua build_chapter.lua book` puts every chapter, whole, into one Word
-- file:  a title page, a table of contents, then each piece in BOOK order.
-- Every page gets a 1.5-inch left margin, so a three-hole punch clears the
-- text when it's printed one-sided.  Word fills in the contents and the page
-- numbers afterward;  lessons/chapters/tools/finish_book.ps1 does that and
-- makes the PDF.
-- A table in the list starts a unit, on a page of its own ahead of its first
-- chapter.  Unit 2, Your Game (Chapters 5 to 7), and the bonus chapters at the
-- back go in as their chapters get written.
local BOOK = {
  "00",
  { unit = "Unit 1", name = "Your Character", about = "Chapters 1 to 4" },
  "01", "02", "03", "04",
  { unit = "Unit 2", name = "Your Game", about = "Chapters 5 to 7" },
  "05", "06", "07",
  { unit = "Bonus Chapters", about = "Images, sounds, animation, and lists.  Each one says when it's best taken." },
  "A", "B", "C", "D",
  { unit = "For Teachers", about = "What's inside the toolbox." },
  "R",
}
local BOOK_TITLE = "Make Your Own Game"      -- the course's title, from canvas_import/course.json
local BOOK_TAGLINE = "Your character, your world, your rules."

local function styled(style, inlines)
  return pandoc.Div({ pandoc.Para(inlines) }, { ["custom-style"] = style })
end

local function compile_book()
  TEXT_WIDTH = 8640   -- 8.5 inches, less 1.5 and 1 for the margins
  local out_dir = pandoc.path.join { DRAFTS, "build", "book" }
  pandoc.system.make_directory(out_dir, true)
  local reference = pandoc.path.join { HERE, "book-reference.docx" }
  make_reference_doc(reference, 2160)

  local blocks = pandoc.Blocks {}
  local cover = pandoc.path.join { out_dir, "cover.png" }
  local have_cover = io.open(cover, "rb")
  if have_cover then
    have_cover:close()
    blocks:insert(styled("Book Cover",
      { pandoc.Image({}, cover, "", { width = "3.4in" }) }))
  end
  blocks:insert(styled("Book Title", pandoc.read(BOOK_TITLE, READER).blocks[1].content))
  blocks:insert(styled("Book Subtitle", { pandoc.Str((BOOK_TAGLINE:gsub("  ", NBSP .. " "))) }))
  blocks:insert(styled("Book Byline", { pandoc.Str("Jason Cox") }))
  blocks:insert(styled("Book Byline", { pandoc.Str("written with Claude, an AI writing assistant") }))
  blocks:insert(styled("Book Byline", { pandoc.Str("Draft, " .. os.date("%B %Y")) }))
  blocks:insert(PAGE_BREAK)
  blocks:insert(styled("Book Title", { pandoc.Str("Contents") }))
  blocks:insert(pandoc.RawBlock("openxml", '<w:p><w:r><w:fldChar w:fldCharType="begin"/></w:r>'
    .. '<w:r><w:instrText xml:space="preserve"> TOC \\o "1-2" \\h \\z \\u </w:instrText></w:r>'
    .. '<w:r><w:fldChar w:fldCharType="separate"/></w:r>'
    .. '<w:r><w:t>Word fills in the contents.</w:t></w:r>'
    .. '<w:r><w:fldChar w:fldCharType="end"/></w:r></w:p>'))

  -- Where each meeting starts, in book order, for finish_book.ps1:  it cuts
  -- each meeting's PDF out of the finished book, so the two agree page for
  -- page.  A unit page is a boundary with no file of its own.
  local meetings = {}
  for _, key in ipairs(BOOK) do
    if type(key) == "table" then
      -- "Unit 1 - Your Character", or a page with a name of its own, like
      -- "Bonus Chapters".  finish_book.ps1 knows both kinds by these names.
      local heading = key.name and (key.unit .. " - " .. key.name) or key.unit
      table.insert(meetings, { "", heading })
      blocks:insert(pandoc.Header(1, { pandoc.Str(heading) }))
      blocks:insert(styled("Book Byline", { pandoc.Str((key.about:gsub("  ", NBSP .. " "))) }))
      goto continue      -- the chapter's own heading starts the next page
    end
    local cfg = assert(CHAPTERS[key], "no chapter " .. key)
    local f = assert(io.open(cfg.source, "rb"))
    local md = protect_spaces(f:read("a"))
    f:close()
    local title, subtitle, body = take_title(trim_rules(md))
    for k, meeting in ipairs(cfg.meetings) do
      local name = (cfg.word_name or (#cfg.meetings == 1 and ("Chapter%02d.docx"):format(cfg.number)
        or ("Chapter%02d_Meeting%d.docx"):format(cfg.number, k))):gsub("%.docx$", ".pdf")
      local heading = meeting.starts and meeting.starts:gsub("^#+%s*", "")
        or pandoc.utils.stringify(pandoc.read(title, READER).blocks[1].content)
      table.insert(meetings, { name, heading })
    end
    local doc = pandoc.read(body, READER):walk { CodeBlock = split_long_code }:walk(box_filter("docx"))
    -- Every heading moves down one level, so the chapter's own title can be
    -- the top level.  A Part, now level 2, starts a page of its own.
    doc = doc:walk { Header = function(h) h.level = h.level + 1; return h end }
    blocks:insert(pandoc.Header(1, pandoc.read(title, READER).blocks[1].content))
    if subtitle then
      blocks:insert(styled("Subtitle", pandoc.read(subtitle, READER).blocks[1].content))
    end

    -- The chapter's title page:  its picture, if build/book/art has one, and
    -- its opening from lessons/chapters/book/:  a line of prose, then a moment
    -- quoted from the chapter.  The opening goes in unlabeled.  The chapter
    -- starts on the page after.  An opening may quote a screenshot, so its
    -- image paths are taken relative to lessons/chapters too.
    local art = pandoc.path.join { out_dir, "art", "ch" .. key .. ".png" }
    local art_file = io.open(art, "rb")
    if art_file then
      art_file:close()
      blocks:insert(styled("Book Cover", { pandoc.Image({}, art, "", { width = "5.6in" }) }))
    end
    local cold = io.open(pandoc.path.join { DRAFTS, "book", "opening_" .. key .. ".md" }, "rb")
    if cold then
      local cold_md = protect_spaces(cold:read("a"))
      cold:close()
      -- Two code blocks in a row would merge into one box in Word, so a thin
      -- paragraph goes between them:  the code, then what it printed.
      local previous
      local cold_doc = pandoc.read(cold_md, READER):walk {
        Image = function(img)
          img.src = local_path(img.src)
          img.attributes.width = img.attributes.width or "4in"
          return img
        end,
      }
      for _, block in ipairs(cold_doc.blocks) do
        if previous == "CodeBlock" and block.t == "CodeBlock" then
          blocks:insert(pandoc.RawBlock("openxml", '<w:p><w:pPr><w:spacing w:before="0" w:after="0" '
            .. 'w:line="160" w:lineRule="exact"/></w:pPr></w:p>'))
        end
        if block.t == "Para" then
          blocks:insert(pandoc.Div({ block }, { ["custom-style"] = "Book Byline" }))
        else
          blocks:insert(block)
        end
        previous = block.t
      end
    end
    if art_file or cold then blocks:insert(PAGE_BREAK) end

    for k, block in ipairs(doc.blocks) do
      if block.t == "Header" and block.level == 2 and k > 1 then blocks:insert(PAGE_BREAK) end
      blocks:insert(block)
    end
    ::continue::
  end

  local book = pandoc.Pandoc(blocks)
  local path = pandoc.path.join { out_dir, "Book_Draft.docx" }
  local f = assert(io.open(path, "wb"))
  f:write(finish_docx(pandoc.write(book, "docx", { reference_doc = reference })))
  f:close()
  local list = assert(io.open(pandoc.path.join { out_dir, "meetings.tsv" }, "wb"))
  for _, m in ipairs(meetings) do list:write(m[1], "\t", m[2], "\n") end
  list:close()
  TEXT_WIDTH = 9360
  print("wrote " .. path)
end

for _, key in ipairs(#arg > 0 and arg or { "00", "01", "02" }) do
  if key == "book" then compile_book() else build(key) end
end
