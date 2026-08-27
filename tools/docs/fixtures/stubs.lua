--- Every doc-comment feature the site renders, in one file.
---
--- Nothing here is real code — it is never loaded, and it lives outside
--- `lua/` so it can never reach the published site. Point LuaLS at this
--- folder to see the whole rendering surface on one page, which is the quickest
--- way to check a change to `generate.py` or the stylesheet against every
--- feature at once rather than hunting for a real function that happens to use
--- the one you touched.
---
--- Build it with the two commands in [doc-comments.md](../../../docs/doc-comments.md).
---
--- This header is also where every **GFM** markdown feature gets a workout —
--- not just the doc-comment tags below. *Italics*, ~~strikethrough~~,
--- ***bold italics***, and `inline code` all sit inline. So does a bare
--- autolink: <https://example.invalid>, and an un-bracketed one straight in
--- prose: https://example.invalid/bare.
---
--- Raw inline HTML: H<sub>2</sub>O, E=mc<sup>2</sup>, and <ins>underlined</ins>
--- text. Colour-model code spans, which GitHub swatch-previews and this site
--- does not: `#42A5F5`, `rgb(66, 165, 245)`, `hsl(207, 90%, 61%)`.
---
--- # A heading this deep never appears in real doc comments
--- ## Neither does this one
--- ### Nor a third level
---
--- > A plain blockquote — distinct from the `> [!NOTE]`-style callouts, which
--- > get their own box further down this file via `@note`/`@warning`/etc.
---
--- ![Photon crest](https://example.invalid/crest.png) — an image, alt text
--- "Photon crest". A relative link: [writing doc comments](../doc-comments.md).
--- A custom anchor <a name="gfm-anchor"></a> and a [section link](#gfm-anchor)
--- back to it. A mention that goes nowhere on a site with no accounts:
--- @nobody. Three shapes of issue/PR reference, all built from `--repo-url`
--- rather than left inert like the mention above: a bare #1234 (this repo),
--- a linter-library#1 (same org, another repo), and a fully spelled-out
--- photonle/Photon#1 (any org/repo).
---
--- Escaped so it stays literal: \*not italics\*. A footnote reference[^1]
--- and its definition below. An emoji shortcode: :tada:.
---
--- <!-- An HTML comment. If this sentence is visible, it did not get hidden. -->
---
--- A trailing backslash forces a line break without a blank line between\
--- them, landing right here. A `<br/>` tag does the same on GitHub, but
--- isn't in this renderer's allowed-HTML set, so it prints literally instead
--- of breaking the line — same as the HTML comment above.
---
--- [^1]: The footnote text, kept to one `---` line on purpose — an unindented continuation line breaks out of the footnote as its own paragraph instead of extending it.
---
--- 1. An ordered list
--- 2. With a second item
---    - nesting an unordered one
---    - two levels deep
--- 3. And a third
---
--- - [ ] An unchecked GFM task list item
--- - [x] A checked one
---
--- | Column | Purpose |
--- | :--- | :--- |
--- | `Column` | Left-aligned header cell |
--- | `Purpose` | What the row demonstrates |
---
--- ```lua
--- -- A fenced code block, language-tagged.
--- local n = stubs.Bare()
--- ```
---
--- ---
---
--- The rule above is a thematic break, not a front-matter fence — this file
--- has no front matter to confuse it with.
---
--- @copyright Photon Team
--- @release development
--- @author Photon Team
--- @namespace stubs
--- @state shared

stubs = stubs or {}

--- Takes nothing and returns nothing. The signature still shows its parentheses,
--- so it reads as callable.
--- @state shared
--- @section Parameters and returns
function stubs.Bare()
end

--- Every shape a parameter can take.
---
--- The description is markdown: `inline code`, **bold**, [a link](https://example.invalid),
--- and a list —
---
--- - one
--- - two
---
--- @param required string A plain required parameter.
--- @param optional number? Optional, marked with `?`.
--- @param union string|number Either of two types.
--- @param collection table<number, string> A generic, whose punctuation must survive.
--- @param callback fun(ply: Player, ok: boolean): string A function type; its inner names are not types.
--- @param ent Entity A type this site documents, so it links to our own page.
--- @param mat IMaterial A base-game type, so it links to the wiki.
--- @return boolean ok Whether it worked.
--- @state server
function stubs.EveryParameter(required, optional, union, collection, callback, ent, mat)
end

--- Several returns, which are numbered because their order is the contract.
--- @return boolean ok
--- @return string|nil reason Machine-readable reason when `ok` is false.
--- @return table<string, any> details
--- @state shared
function stubs.MultipleReturns()
end

--- Serverside only.
--- @state server
--- @section Realms
function stubs.ServerOnly() end

--- Clientside only.
--- @state client
function stubs.ClientOnly() end

--- Both realms, which renders as one "Shared" chip rather than two.
--- @state shared
function stubs.Shared() end

--- Menu realm.
--- @state menu
function stubs.MenuOnly() end

--- Superseded, with a reason. The stock sentence comes first, then the reason.
--- @deprecated Use `stubs.EveryParameter` instead.
--- @state shared
--- @section Callouts
function stubs.DeprecatedWithReason() end

--- Superseded, with nothing said about it. The stock sentence stands alone.
--- @deprecated
--- @state shared
function stubs.DeprecatedBare() end

--- Callable, but not part of the public surface.
--- @internal Called by the loader; there is no reason to call it yourself.
--- @state server
function stubs.Internal() end

--- Known to misbehave.
--- @bug Returns `nil` rather than `false` when the vehicle has no components.
--- @state server
function stubs.Buggy() end

--- Easy to get wrong.
--- @warning Rebuilds every light per call; do not put it in a think hook.
--- @state server
function stubs.Warned() end

--- Documented from the call sites rather than the implementation.
--- @ambig
--- @state shared
function stubs.Ambiguous() end

--- Written a long time ago against code that has since moved.
--- @validate
--- @state shared
function stubs.NeedsValidating() end

--- An aside that is neither a problem nor a warning.
--- @note Prefer `stubs.Shared` unless you specifically need the serverside path.
--- @state shared
function stubs.Noted() end

--- Every callout at once, to check they stack in a fixed order no matter how
--- they were written here.
--- @note Ordered last despite being written first.
--- @validate
--- @ambig
--- @warning Second from last.
--- @bug Third from last.
--- @internal
--- @deprecated Ordered first.
--- @state shared
function stubs.EveryCallout() end

--- A one-line example, which is the common case.
--- @param value string
--- @state shared
--- @section Examples
--- @example stubs.OneLineExample("value")
function stubs.OneLineExample(value) end

--- A multi-line example. Line breaks and indentation inside it survive, unlike
--- the prose tags, which fold their continuation lines into one paragraph.
--- @example local ok, reason = stubs.MultipleReturns()
---  if not ok then
---    print(reason)
---  end
--- @state shared
function stubs.MultiLineExample() end

--- A fenced block in the description still works, and stays where it was
--- written rather than moving to the end:
---
--- ```lua
--- stubs.FencedExample()
--- ```
---
--- @state shared
function stubs.FencedExample() end

--- Alerts written as GFM callouts in a description come out as the same boxes
--- the `@warning` family produces.
---
--- > [!NOTE]
--- > A note written as a GFM alert.
---
--- > [!CAUTION]
--- > A caution, which has no tag equivalent.
---
--- @state shared
--- @section Markdown in descriptions
function stubs.Alerts() end

--- A table in a description, to check borders and cell padding.
---
--- | Column | Meaning |
--- | :--- | :--- |
--- | `one` | First. |
--- | `two` | Second. |
---
--- @state shared
function stubs.Tabular() end

--- A documented table rather than a function, so it takes no parentheses.
--- @state shared
--- @section Tables and fields
stubs.Config = {}

--- A documented field.
--- @state shared
stubs.Config.enabled = true

--- Every colour this stub pretends to define.
--- @alias `STUB_RED` `STUB_GREEN`
--- @state shared
--- @section Constant families
STUB_COLOURS = nil

--- Red.
--- @state shared
STUB_RED = 1

--- Green.
--- @state shared
STUB_GREEN = 2

--- A metatable, found by its `FindMetaTable` call, so it claims its own page and
--- its members take a `:` rather than a `.`.
--- @class StubEntity
local stubMeta = FindMetaTable("StubEntity")

--- A method, so its signature reads `StubEntity:Method(...)`.
--- @param other StubEntity The entity to compare against.
--- @return number distance
--- @state shared
function stubMeta:Distance(other) end

--- A field on the class.
--- @state shared
stubMeta.identifier = ""
