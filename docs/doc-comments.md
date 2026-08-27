---
title: Writing Doc Comments
pinned: true
featured: true
description: How this site is built, and what to write so a function appears on it.
---

# Writing Doc Comments

This site is built by [`tools/docs/generate.py`](../tools/docs/generate.py) from two independent
sources, so a doc comment lives or dies depending on which one actually reads it:

1. **`lua-language-server`'s `--doc` JSON export.** LuaLS parses `lua/` and exports every doc comment
   it understands — that means real [LuaCATS](https://luals.github.io/wiki/annotations/) annotations
   (`--- @param`, `--- @return`, `--- @class`, ...) attached **immediately above** a declaration,
   with no blank line in between. A blank line between the comment and the code it describes means
   LuaLS never associates the two, and the comment is silently dropped from the JSON entirely.
2. **`generate.py`'s own raw-source scan**, used only for each file's *leading header comment*
   (description, `@namespace`, `@state`). This one tolerates a blank line before the code that
   follows. Write headers as `---` lines.

Photon's comments were written for [LDoc](https://stevedonovan.github.io/ldoc/), which this pipeline
replaced. LDoc's tags (`@module`, `@tparam`, `@treturn`, `@str`, `@int`, `@ent`, ...) mean nothing to
LuaLS, so a file that still uses them lands on the site as a page named after its own path, with no
types on anything. Converting a file means rewriting those tags — see
[Porting from LDoc](#porting-from-ldoc) at the bottom.

## Pipeline

```bash
# 1. LuaLS walks lua/ and exports its own understanding of every doc comment.
lua-language-server --doc=lua --doc_out_path=tools/docs/out \
                    --configpath=tools/docs/luarc-docs.json

# 2. generate.py turns that JSON (plus docs/**/*.md) into this site.
python3 tools/docs/generate.py --json tools/docs/out/doc.json \
                               --output tools/docs/build \
                               --style-dir tools/docs/style \
                               --topics docs
```

Step 1 needs the base-game type definitions, which are a submodule:

```bash
git submodule update --init tools/docs/vendor/glua-api-snippets
```

Everything under `lua/autorun/photon/library/`, `lua/tests/` and `lua/internet_benchmark/` is
excluded from the export. The library tree is content — vehicles, components, sirens and presets
registered as data tables — and listing it would bury the engine's own pages several times over.

### Publishing

`.github/workflows/docs.yml` runs both steps on every push and pull request, and on a push to
`development` it also publishes the result to the `gh-pages` branch, which is what
[photonle.github.io/Photon](https://photonle.github.io/Photon/) serves. A push to `master` builds
but does not publish: Pages serves one branch, and two publishing into it would overwrite each
other.

The deploy replaces `gh-pages` outright rather than committing on top of it. The site is a full
rebuild every run, so anything already on the branch that the build did not just produce is stale by
definition — a page whose module was renamed, a topic that moved into a folder, a previous build's
content-hashed stylesheet. That also keeps the branch at one commit, so the repository isn't carrying
a copy of the whole site for every push it has ever had.

### Definition-only files

Some of Photon's API is generated at load time — `Photon.SNet:Map` hangs a `Set`/`Get` pair off the
`Entity` metatable for every variable it registers, and nothing declares those in source. Neither
LuaLS nor your editor can see an API that only exists once the game is running, so those are declared
by hand in `lua/autorun/photon/meta/`, as `--- @meta` files full of empty declarations.

Nothing on any load path reads that folder; it exists to be read by tooling. It carries its own
`.glualint.json` turning off `lint_unusedVars`, since every parameter in a declaration-only file is
unused by construction — that exception is scoped to the folder, so it can't quietly cover real code.

### Seeing every feature at once

[`tools/docs/fixtures/stubs.lua`](../tools/docs/fixtures/stubs.lua) is a stub file using every tag,
realm, callout, type and section the site renders. It is never loaded by the game, and it sits
outside `lua/` so its fake symbols can never reach the published site. Build just that file when
changing `generate.py` or the stylesheet — it is far quicker than hunting for a real function that
happens to use the feature you touched:

```bash
lua-language-server --doc=tools/docs/fixtures --doc_out_path=tools/docs/stub-out \
                    --configpath=tools/docs/luarc-docs.json
python3 tools/docs/generate.py --json tools/docs/stub-out/doc.json \
                               --output tools/docs/stub-build \
                               --style-dir tools/docs/style --topics docs \
                               --source tools/docs/fixtures
```

`test_generate.py` fails if the stub stops covering a callout kind, a realm, or the
example/section/alias tags, so it cannot quietly fall behind the generator.

## Topic files and folders

Every markdown file under `docs/` is published, and the folder it sits in decides where. Top-level
files are listed directly under the sidebar's **Topics** heading. A subfolder becomes a single
collapsed entry at the bottom of that same list, linking to the folder's index page —
`docs/design/x.md` publishes to `topics/design/x.html`. The folder's pages only unfold in the
sidebar while you're on one of them.

Folders nest to any depth, and each level gets its own index page. There is no per-folder config;
creating the folder is the whole step. Add an `index.md` to give the folder a name and an intro — its
`title` becomes the sidebar label. The list of what's in the folder is always generated.

`topics/` mirrors `docs/`, so a relative link between two topic files stays correct on the site as
well as on GitHub — `generate.py` only swaps the `.md` for `.html`. That mirroring cuts both ways:
**moving a doc into a folder changes its depth, so its own `../` links and everyone else's links to
it need updating in the same change.** A relative link that points *above* `docs/` — `../README.md`,
`../lua/autorun/photon/shared/sh_simplenet.lua` — is rewritten to the repo browser rather than left
to 404.

A page's opening `<h1>` is dropped from the rendered HTML — the title already sits in the header bar
above it. Keep writing the heading; it's what makes the file readable on GitHub, and it's the
fallback when there's no front-matter `title`.

### Front matter

Any topic may open with a `---` block. It's flat `key: value` lines, not real YAML — the docs build
has no YAML dependency, and a block that isn't in that shape is left in the page as ordinary
markdown rather than silently swallowed.

| Key | Effect |
| :--- | :--- |
| `title` | Sidebar label, page header, and index row. Overrides the first heading. |
| `status` | Index column. Free text — `Proposed`, `Landed`, `Implemented`. |
| `date` | Index column. |
| `description` | Index column. One line on what the doc covers. |
| `pinned` | `true`/`yes`/`1` lifts the doc to the top of its list, marked with a pin. |
| `featured` | `true`/`yes`/`1` adds the doc to the **Important Topics** list on the front page. |
| `index` | `true` promotes the doc to be its folder's landing page. |

Precedence for a folder's landing page, most deliberate first: a doc with `index: true`, then
`index.md`, then a doc named after the folder it sits in, then a generated listing.

## Function-level: use real LuaCATS annotations

Write these as `--- @tag ...` directly above the `function`/assignment they describe, no blank line.
`generate.py` reads the native `args`/`returns` LuaLS already resolved from the function signature
itself, so the types are accurate, and only borrows the tag's text for the human-readable
description.

Four rules decide whether an annotation counts at all. Break any one and it still looks fine in the
diff and is silently dropped:

1. **Three dashes, always.** `--- @param` counts, `-- @param` does not.
2. **Directly above the declaration, with no blank line.**
3. **Description first, tags after.**
4. **Names must match the real signature.** `--- @param ent Entity` only binds if the function
   actually has a parameter called `ent`.

| Annotation | Syntax | Notes |
| :--- | :--- | :--- |
| `@param` | `--- @param <name> <type[?]> [description]` | Name first, then type — the reverse of LDoc's `@tparam`. `?` on the type marks it optional. |
| `@return` | `--- @return <type> [<name> [comment]]` | One `@return` line per return value, in order. |
| `@class` | `--- @class [(exact)] <name>[: <parent>...]` | Defines a struct/type, optionally with inheritance. |
| `@field` | `--- @field [scope] <name> <type[?]> [description]` | Documents a field of a `@class`. |
| `@type` | `--- @type <type>` | Declares the type of a variable, e.g. `--- @type string[]`. |
| `@alias` | `--- @alias <name> <type>` | Names a type (or enum) for reuse elsewhere. |
| `@enum` | `--- @enum [(key)] <name>` | Marks a table as an enum, usable at runtime. |
| `@overload` | `--- @overload fun([param: type...]): [return_type]` | An additional call signature. |
| `@generic` | `--- @generic <name> [:parent_type]` | Generic type placeholder. |
| `@deprecated` | `--- @deprecated [reason]` | Also renders as a callout — see below. |
| `@nodiscard` | `--- @nodiscard` | Warns if the return value is ignored at the call site. |
| `@see` | `--- @see <symbol>` | Cross-reference to another documented symbol. |
| `@private` / `@protected` / `@package` | `--- @private` | Restricts where the item is considered accessible. |
| `@diagnostic` | `--- @diagnostic <state>:<diagnostic>` | Suppresses/enables a specific LuaLS diagnostic. |

Two annotations are explicitly **not** used here:

- **`@module`** — LuaLS reserves this for its own `require()`-return-type inference and silently
  drops any doc comment that uses it. Use [`@namespace`](#file-header-tags) instead. Photon's
  LDoc-era headers all use `@module`, which is why so many pages are still named after a file path.
- **`@vararg`** — deprecated by LuaLS itself in favour of `--- @param ... <type> [description]`.

Minimal example:

```lua
--- Get the latest cached value of a networked variable on an entity.
--- @param ent Entity The entity to read the value from.
--- @param name string The registered variable name.
--- @param default any? Value to return when nothing has been networked yet.
--- @return any value The networked value, or `default`.
function NET:Get(ent, name, default)
	...
end
```

## Function-level: this codebase's own tags

These are custom to `generate.py`, not LuaCATS — but like `@param`/`@return`, they're written
**directly above the function or table they describe**, with no blank line.

> [!IMPORTANT]
> Write these with a space after the dashes — `--- @state server`, not `---@state server`.
>
> LuaLS parses `---@tag` as an annotation and drops any tag it doesn't recognise, so the tag never
> reaches `generate.py` and the whole line vanishes with no error. `--- @tag` is description text as
> far as LuaLS is concerned, which is exactly how these survive into the export.

| Tag | Purpose |
| :--- | :--- |
| `@section <title>` | Starts a new named subsection on the module page. Every following item in the file (until the next `@section`) is grouped under it, so it's usually written once per group. The tag's own value is the heading — write it as you want it read. A one-word lowercase slug is title-cased. |
| `@state <word>` | One of `client`, `server`, `menu`, `shared`, `global`, `clmenu` — drives the realm badge shown next to the item. Falls back to whatever `@state` the file header declared. |
| `@example <code>` | Renders an "Example" code block after the parameters and returns. Continuation lines are kept as lines. Not `@usage`, which is an LDoc tag and renders nothing. |

### Callout tags

Seven tags render as callout boxes, in the manner of the GMod wiki's note boxes. They always appear
in this order on an entry — whether you should be using this at all, then what is wrong with it,
then advisories — regardless of the order they were written in:

| Tag | Box | Stock text when no text is given |
| :--- | :--- | :--- |
| `@deprecated [text]` | Deprecated | "This function is deprecated and may be removed in a future version." |
| `@internal [text]` | Internal | "This function is internal. Whilst you can call it, you probably shouldn't." |
| `@bug <text>` | Bug | — |
| `@warning <text>` | Warning | — |
| `@ambig [text]` | Ambiguous | "This entry is unclear or incomplete." |
| `@validate [text]` | Validate | "This entry has not been checked against the code recently." |
| `@note <text>` | Note | — |

`@bugs`, `@warns`, `@notes` and `@ambiguous` are accepted as alternative spellings — `@warns` is the
LDoc spelling Photon's older comments use, and it still works. Several spellings of the same tag on
one function collapse into a single box. The text is rendered as markdown, so links and `code` work
inside a callout.

Topics can use any of these as GFM alerts too — `> [!BUG]`, `> [!DEPRECATED]` — alongside the
standard `[!NOTE]`, `[!TIP]`, `[!IMPORTANT]`, `[!WARNING]` and `[!CAUTION]`.

```lua
--- Send the current value of a networked variable to a recipient.
--- @param ent Entity The entity the value belongs to.
--- @param name string The registered variable name.
--- @internal
--- @warning `name` must already be registered with `Photon.SNet:Map`.
--- @state server
function NET:SendChange(ent, name, val, to)
	...
end
```

## Constant families: `@alias` gathers the constants it names

A page that declares a long run of prefixed constants would otherwise list every one of them as a
top-level entry, interleaved alphabetically with everything else. An `@alias` over those constants
turns them into a section of its own: the alias becomes the heading, its constants sit beneath it,
and it gets its own line in the page's **Contents**.

```lua
--- The wire types a SimpleNet variable can be registered as.
--- @section Network Types
--- @alias PhotonNetType
---| `Photon.SNet.BOOL`
---| `Photon.SNet.INT`
---| `Photon.SNet.UINT`
---| `Photon.SNet.STR`
```

The constants must be documented on the same page as the alias, and two is the minimum — below that
a heading costs more than it saves. An alias whose members are string literals or other types has no
constants to gather, so it stays an ordinary entry, rendered as an **Accepted values** list.

## Class pages: `@namespace <ClassName>` gathers a class's members

Photon hangs methods off `Entity` from several files at once, and none of them owns the metatable.
Each member would otherwise land on the page of whichever file happens to declare it, or on a page
derived from a *different* file's path entirely.

Declaring `@namespace <ClassName>` on one of the class's files makes that the class's page, and every
`<ClassName>.member` follows it there, wherever it was written. A `@class` that exists to describe a
library's own table declares no such namespace, so its fields stay on that library's page next to the
thing they describe.

Classes extended via `FindMetaTable("X")` are detected from the source and claim a page the same way
without needing to declare a namespace; they're listed under **Metatables** in the sidebar rather
than under Modules.

## File-header tags

The very first comment in a file (`---` line comments; a blank line before the code is fine) is
scanned separately for these. They are **not** LuaCATS and LuaLS doesn't know about them:

| Tag | Purpose |
| :--- | :--- |
| `@namespace <name>` | **Not `@module`.** Groups every doc'd item in this file onto one page named `<name>`, merging with any other file that declares the same namespace (e.g. a `cl_*.lua`/`sv_*.lua` pair). Without it, the page falls back to the file's own dotted path (`autorun.photon.shared.sh_simplenet`). Must not contain `..`. |
| `@state <word>` | Same word list as the function-level tag. On a file header this becomes the *default* realm badge for every item in the file that doesn't declare its own. |
| `@copyright`, `@release`, `@author` | Accepted and parsed, but **not currently rendered** on the site — keep them for humans reading the source. |

```lua
--- Regular Simplified Networking.
--- Easily optimise networking for setting local values on entities.
--- @copyright Photon Team
--- @author Photon Team
--- @namespace Photon.SNet
--- @state shared
```

## Porting from LDoc

Photon's comments predate this pipeline. A file is converted by rewriting its tags; the generator
still understands the LDoc-era callout spellings (`@warns`, `@bugs`) and the `@state` tag, so those
can stay as they are.

| LDoc | LuaCATS |
| :--- | :--- |
| `-- @tag` (two dashes) | `--- @tag` (three) |
| `@module Photon.SNet` | `@namespace Photon.SNet` on the file header |
| `@tparam Entity ent Desc.` | `@param ent Entity Desc.` — name first |
| `@str name Desc.` | `@param name string Desc.` |
| `@int n Desc.` | `@param n integer Desc.` |
| `@bool b Desc.` | `@param b boolean Desc.` |
| `@ent e Desc.` / `@ply p Desc.` / `@veh v Desc.` | `@param e Entity Desc.` / `@param p Player Desc.` / `@param v Vehicle Desc.` |
| `@tab t Desc.` | `@param t table Desc.` |
| `@param[opt] x Desc.` | `@param x any? Desc.` — the `?` goes on the type |
| `@treturn int Desc.` | `@return integer Desc.` |
| `@rint Desc.` / `@rbool Desc.` / `@rstring Desc.` | `@return integer Desc.` / `@return boolean Desc.` / `@return string Desc.` |
| `@usage <code>` | `@example <code>` |
| `@alias NET` (LDoc's "this table is the module") | Delete it — LuaCATS `@alias` means something else entirely |

[`lua/autorun/photon/shared/sh_simplenet.lua`](../lua/autorun/photon/shared/sh_simplenet.lua) is the
worked example: it is fully converted, and its page is what a converted file looks like.
