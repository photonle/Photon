#!/usr/bin/env python3
#
# Renders HTML documentation from lua-language-server's `--doc` JSON export,
# reusing the site's vendored CSS (tools/docs/style/*.css) and topic markdown
# files (docs/**/*.md). Also writes a machine-readable api.json (and llms.txt)
# into the same output directory for docs consumers; the HTML output does not
# depend on either.
#
# Usage:
#   pip install -r requirements.txt
#   python3 generate.py --json doc.json --output build --style-dir style --topics ../../docs
#
# Ported from limelight-development/cityrp2, where the same generator builds
# docs.limelightgaming.info.
#
# Much of the addon's doc comments predate LuaCATS annotations (they use old
# LDoc-style `@state`/`@warns`/`@bugs`/`@deprecated`/`@internal` tags inside
# plain `--` comments), so LuaLS reports them as unstructured text in
# `desc`/`rawdesc` rather than as native JSON fields. This script re-parses
# those tags itself and reproduces the old config.ld's state-badge/custom-tag
# output, so a file can be converted to LuaCATS without its page regressing.

import argparse
import hashlib
import html
import json
import posixpath
import re
import shutil
import textwrap
from datetime import datetime, timezone
from pathlib import Path

import wenmode.presets
from wenmode import Wenmode

MARKDOWN = Wenmode(rules=wenmode.presets.github)


# Every callout kind the site knows, whether it arrives as `> [!WARNING]` in a
# topic or as `--- @warning` on a function. One set, so both read the same.
ALERT_TITLES = {"note": "Note", "tip": "Tip", "important": "Important",
	"warning": "Warning", "caution": "Caution", "bug": "Bug",
	"deprecated": "Deprecated", "internal": "Internal", "validate": "Validate",
	"ambiguous": "Ambiguous"}
ALERT_RE = re.compile(r"<blockquote>\s*<p>\[!([A-Za-z]+)\]\s*")


def alert_blockquotes(html_text):
	"""Turn GitHub's `> [!WARNING]` alert markers into styled callouts. Wenmode's
	github preset covers GFM tables, strikethrough, footnotes and autolinks but
	not alerts, so without this the marker renders as literal text at the top of
	an ordinary blockquote. An unrecognised `[!SOMETHING]` is left alone."""
	def replace(match):
		kind = match.group(1).lower()
		if kind not in ALERT_TITLES:
			return match.group(0)
		return (f'<blockquote class="ll-alert ll-alert-{kind}">'
			f'<p class="ll-alert-title">{ALERT_TITLES[kind]}</p>\n<p>')

	return ALERT_RE.sub(replace, html_text)


# Overwritten in main() from --repo-url, stripped of any trailing slash. A
# module-level global rather than a threaded parameter because render_markdown
# is the one choke point every description/param/return/topic body already
# passes through — see STYLE_FILENAME above for the same pattern.
REPO_URL = ""


COLOR_CODE_RE = re.compile(
	r"<code>(#(?:[0-9a-fA-F]{3,4}|[0-9a-fA-F]{6}|[0-9a-fA-F]{8})"
	r"|rgba?\([\d.\s%,]+\)"
	r"|hsla?\([\d.\s%,]+\))</code>"
)


def add_color_swatches(html_text):
	"""GitHub swatch-previews a hex/rgb/hsl colour literal written as inline
	code; this site didn't. The regex requires the whole code span to be
	nothing but the literal, so an unrelated snippet that merely contains one
	(`background = "#fff"`) is left alone."""
	def replace(match):
		value = match.group(1)
		return f'{match.group(0)}<span class="ll-swatch" style="background:{html.escape(value, quote=True)}"></span>'
	return COLOR_CODE_RE.sub(replace, html_text)


def render_markdown(text):
	if not text:
		return ""
	rendered = add_color_swatches(alert_blockquotes(MARKDOWN.render(text).strip()))
	return linkify_issue_refs(rendered, REPO_URL)


FOOTNOTES_SECTION_RE = re.compile(r"<section[^>]*\bdata-footnotes\b[^>]*>.*?</section>", re.DOTALL)


def extract_footnotes(html_text):
	"""Split a `[^1]`-style footnotes list (wenmode renders it as a
	`<section data-footnotes>` at the point the last reference happened to
	fall) off the end of `html_text`, returning `(rest, footnotes_html)`.
	`footnotes_html` is `None` if there weren't any."""
	match = FOOTNOTES_SECTION_RE.search(html_text)
	if not match:
		return html_text, None
	return html_text[:match.start()] + html_text[match.end():], match.group(0)


def render_markdown_inline(text):
	"""For text that lands inside an existing inline element (a <li>/<span>
	parameter or return description, a custom-tag body) rather than a block
	context - strips the single wrapping <p> a plain one-paragraph
	description renders as. Multi-block content (rare here) is left as-is."""
	rendered = render_markdown(text)
	if rendered.startswith("<p>") and rendered.endswith("</p>") and rendered.count("<p>") == 1:
		return rendered[len("<p>"):-len("</p>")]
	return rendered

# Content, not engine API: every file under library/ registers a vehicle,
# component, siren or preset as a data table, and none of them declare a
# symbol another addon is meant to call. Left in, they would outnumber the
# engine's own pages several times over (the LDoc site this replaced listed
# `autorun.photon.library.sirens.anemolis_chp_bike` as a module).
#
# Paths are matched against the normalised, `lua/`-relative file path: a
# prefix excludes that file and everything beneath it.
EXCLUDED_PREFIXES = [
	"autorun/photon/library",
	"tests",
	"internet_benchmark",
]

# Mirrors config.ld's tagToState().
STATE_WORDS = {
	"client": {"client"},
	"server": {"server"},
	"menu": {"menu"},
	"shared": {"client", "server"},
	"global": {"client", "server", "menu"},
	"clmenu": {"client", "menu"},
}

# Tags that render as a callout box, in the order they appear on an entry:
# whether you should be using this at all, then what is wrong with it, then
# advisories. `@uniqueid` is not here - it names the thing rather than
# qualifying it, and renders as a chip in the item header.
CALLOUT_TAG_ALIASES = {
	"ambig": "ambiguous", "ambiguous": "ambiguous",
	"bug": "bug", "bugs": "bug",
	"deprecated": "deprecated",
	"internal": "internal",
	"note": "note", "notes": "note",
	"validate": "validate",
	"warning": "warning", "warns": "warning",
}
CALLOUT_ORDER = ("deprecated", "internal", "bug", "warning", "ambiguous", "validate", "note")

DEPRECATED_DEFAULT = "This function is deprecated and may be removed in a future version."
INTERNAL_DEFAULT = "This function is internal. Whilst you can call it, you probably shouldn't."
# A tag whose whole point is the flag needs no body; one that reads as an
# accusation gets a stock sentence so an empty tag still says something useful.
CALLOUT_DEFAULTS = {
	"deprecated": DEPRECATED_DEFAULT,
	"internal": INTERNAL_DEFAULT,
	"validate": "This entry has not been checked against the code recently.",
	"ambiguous": "This entry is unclear or incomplete.",
}

TAG_LINE_RE = re.compile(r"^@(\w+)(?:\s+(.*))?$")

# @namespace is a dotted Lua path. LuaLS rewrites `@see https://...` into
# `See: ~https~ :/host/path` and may append that to the previous tag; taking
# the first identifier drops the junk so it cannot become a nested filename.
NAMESPACE_RE = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)*$")
SINGLE_VALUE_TAGS = {
	"author", "class", "copyright", "module", "namespace", "release", "section", "see", "state",
	"type", "uniqueid",
}

# Tags whose value is code. Continuation lines are kept as lines, and keep their
# indentation, rather than being folded into one paragraph like prose tags are.
BLOCK_VALUE_TAGS = {"example"}

# Display order for the per-module "Contents" jump list and per-kind headers.
KIND_ORDER = ["Functions", "Tables", "Classes", "Fields"]

# The search chip labels one symbol, so each KIND_ORDER heading needs its
# singular. Not derived by trimming a trailing "s": that turns "Classes" into
# "classe".
KIND_SINGULAR = {"Functions": "function", "Tables": "table",
	"Classes": "class", "Fields": "field"}

NATURAL_SORT_RE = re.compile(r"(\d+)")


def natural_sort_key(name):
	"""Case-insensitive natural sort: splits runs of digits out so e.g.
	"item2" sorts before "item10" instead of after it (as plain string
	comparison would order them)."""
	return [int(part) if part.isdigit() else part.lower()
		for part in NATURAL_SORT_RE.split(name or "")]


def section_title(value):
	"""Display title for an `@section` tag. The tag's own value is the title,
	so `@section Rank Colours` reads as written; the older one-word slug form
	(`@section default_sinks`) is title-cased into "Default Sinks" so those
	call sites keep working without being rewritten.

	Previously the title came from the *description* of the first item under
	the tag, which rendered whole sentences as headers ("Creates a logger
	wrapper that merges the given fields..." on Photon.Logging)."""
	text = (value or "").strip()
	if not text:
		return ""
	if text.islower():
		return text.replace("_", " ").replace("-", " ").title()
	return text


def group_by_section(items, sort=True):
	"""Assigns each item to the @section it visually falls under (an item
	without its own @section tag belongs to whichever section the nearest
	preceding item opened, mirroring the old render loop's `current_section`
	carry-forward), then returns those sections sorted alphabetically by
	title, each internally natural-sorted by item name.

	Items preceding any @section tag land in an untitled group, which sorts
	first (empty title sorts before any real one).

	`items` must arrive in source order, since that is what the carry-forward
	reads. `sort=False` keeps that order all the way through to the page, for
	enumerations where the sequence the constants were declared in is the
	meaningful one (COL_WHITE, COL_BLACK, ... not COL_ACCEPT, COL_ADMIN)."""
	current_slug, current_title = None, ""
	sections = {}
	order = []
	for item in items:
		slug = item["tags"].get("section", [None])[0]
		if slug is not None and slug != current_slug:
			current_slug = slug
			current_title = section_title(slug)
		if current_slug not in sections:
			sections[current_slug] = {"title": current_title, "items": []}
			order.append(current_slug)
		sections[current_slug]["items"].append(item)

	if not sort:
		return [sections[slug] for slug in order]

	for slug in order:
		sections[slug]["items"].sort(key=lambda i: natural_sort_key(i["name"]))

	return sorted(sections.values(), key=lambda s: s["title"].lower())


# --- @alias enumeration families ---------------------------------------------
#
# LuaLS does not pass an `@alias` declaration through as an ordinary doc
# comment: it renders the whole thing into a fenced code block, with the
# author's own description reduced to `--` comment lines *inside* the fence,
# followed by a `Name:` line and one `    | `MEMBER`` line per member.
#
# ```lua
# --  Shared colour constants.
# --  @section Colours
# COL:
#     | `COL_WHITE`
#     | `COL_BLACK`
# ```
#
# That fence is the only complete member list in the export - `defines.view`
# truncates at five ("`COL_BLACK`|`COL_WHITE`|...(+21)") - so it gets parsed
# back apart here rather than rendered as the code block it looks like.

ALIAS_FENCE_RE = re.compile(r"\A```lua\n(.*)\n```\Z", re.S)
ALIAS_DECL_RE = re.compile(r"^([A-Za-z_][\w.]*):$")
ALIAS_MEMBER_RE = re.compile(r"^\|\s*(\S.*?)$")
# Dotted as well as bare: a constant here is usually a field on the library's
# own table (`Photon.SNet.BOOL`), not a global the way `COL_WHITE` is.
ALIAS_CONSTANT_RE = re.compile(r"^`([A-Za-z_]\w*(?:\.[A-Za-z_]\w*)*)`$")


def parse_alias_block(rawdesc):
	"""`(desc, tags, members)` for a `doc.alias` export, or None if it isn't
	one. `members` holds each member exactly as written in the union, so a
	constant arrives as "`COL_WHITE`" and a string literal as '"bolo"'."""
	fence = ALIAS_FENCE_RE.match(rawdesc or "")
	if not fence:
		return None

	comment_lines, members, declared = [], [], False
	for line in fence.group(1).splitlines():
		stripped = line.strip()
		if not declared and stripped.startswith("--"):
			comment_lines.append(re.sub(r"^-{2,}\s?", "", stripped))
		elif ALIAS_DECL_RE.match(stripped):
			declared = True
		elif declared:
			member = ALIAS_MEMBER_RE.match(stripped)
			if member:
				members.append(member.group(1))

	if not declared:
		return None
	desc, tags = parse_ldoc_tags("\n".join(comment_lines))
	return desc, tags, members


def collect_enum_families(items):
	"""The `@alias` declarations on a page whose members are constants
	documented on that same page - `COL` over its 87 `COL_*` fields. Those
	become a section of their own rather than 87 entries interleaved
	alphabetically with everything else the page happens to declare.

	Every member and every gathering alias is tagged `family`, which is what
	the callers filter the normal kind-grouped listing on. An alias whose
	union is string literals ("bolo") or other aliases keeps its ordinary
	entry, since it has no constants to gather up."""
	# Nested items are keyed here as well as top-level ones, and by the same
	# full dotted name: a constant that hangs off its library's table is a
	# field of that table, so `Photon.SNet.BOOL` only exists at depth 1.
	# Top-level wins a collision, being the declaration a reader would land on.
	by_name = {item["name"]: item for item in sorted(items, key=lambda i: -i["depth"])}
	families = []

	for item in items:
		alias = item.get("alias")
		if not alias:
			continue
		members = []
		for view in alias["members"]:
			constant = ALIAS_CONSTANT_RE.match(view)
			member = by_name.get(constant.group(1)) if constant else None
			# An alias listing other aliases (`Colour` = `COL`|`Color`) is a
			# type union, not an enumeration of constants. The `family`
			# check skips a constant another alias already gathered, while
			# leaving this one's own members alone so re-running over the
			# same items (the HTML pass, then the api.json pass) is a no-op.
			if member is None or member.get("alias"):
				continue
			if member.get("family") not in (None, item["name"]):
				continue
			members.append(member)
		if len(members) < 2:
			continue
		item["family"] = item["name"]
		for member in members:
			member["family"] = item["name"]
		# Back into source order: the alias lists its members in whatever
		# order it was written, and @section carry-forward only makes sense
		# against the order the constants are actually declared in.
		members.sort(key=lambda i: (i["file"], i["start"]))
		families.append({
			"name": item["name"],
			"title": section_title(item["tags"].get("section", [None])[0]) or item["name"],
			"desc": item["desc"],
			"item": item,
			"members": members,
		})

	return sorted(families, key=lambda f: f["title"].lower())


def collect_class_families(items, module_name, pages=()):
	"""The `@class` declarations on a page whose members are documented on
	that same page - `NetVar` over its 24 builder methods and 40 fields.

	A class that declares a `@namespace` (or is a `FindMetaTable` name) already
	claims a page of its own, where the page *is* the class; this is for the
	rest - the builders and data classes that belong beside the library they
	describe. Without it a class's members are only related to it by their
	dotted name, and sort alphabetically among the module's own functions:
	`NetVar:SetHook` between `Photon.Net.SendUpdate` and
	`Photon.Net.SetGlobal`, its 40 fields likewise scattered through the
	module's constants.

	Marked `class_family` rather than `family`: the enum marker is serialised
	into api.json, where it means "a constant this alias enumerates", which a
	method is not.

	Longest name first so a nested class keeps its own members - `PluginMeta`
	must not claim `PluginMeta.Sub.x` out from under `PluginMeta.Sub`. Members
	stay in source order, which is what `group_by_section`'s `@section`
	carry-forward reads; `render_entries` sorts within each section itself."""
	declarations = sorted((item for item in items
		if item["depth"] == 0 and item.get("is_class")
		and item["name"] != module_name and item["name"] not in pages),
		key=lambda i: len(i["name"]), reverse=True)

	families = []
	for item in declarations:
		prefix = item["name"] + "."
		# An enum family has already gathered its own members; nothing may be
		# rendered under two headings.
		members = [m for m in items if m["name"].startswith(prefix)
			and not m.get("family") and not m.get("class_family")]
		if len(members) < 2:
			continue
		item["class_family"] = item["name"]
		for member in members:
			member["class_family"] = item["name"]
		families.append({"name": item["name"], "item": item, "desc": item["desc"],
			"members": members})

	return sorted(families, key=lambda f: f["name"].lower())


# Where the doc'd files live within the repo, for building source links. LuaLS
# is pointed at `lua/`, so the paths it reports are relative to that and the
# prefix has to be put back to reach a file on GitHub.
SOURCE_REPO_PATH = "lua"


# A `doc.class`/`doc.alias`/`doc.enum` declaration is the type itself, not a
# value of it - checked first because these carry no useful `extends` shape
# of their own (a plain `@class` has no `extends` at all; an `@alias` union's
# `extends` is a list of member types, not a function/table signature either).
TYPE_DECL_DOC_TYPES = {"doc.class", "doc.alias", "doc.enum"}


def classify_kind(extends, define_type=None):
	"""Buckets an item under Functions/Tables/Classes/Fields for the module
	page's kind-grouped sections. `extends.type` is LuaLS's own classification
	of the value a declaration resolves to (function signature, table literal,
	or - the long tail - scalars/expressions like "integer"/"getfield"/
	"select", which aren't meaningfully different from each other here)."""
	if define_type in TYPE_DECL_DOC_TYPES:
		return "Classes"
	if isinstance(extends, dict):
		if extends.get("type") == "function":
			return "Functions"
		if extends.get("type") == "table":
			return "Tables"
	return "Fields"


def extends_class_name(extends):
	"""The `@class X : Y` parent's name, or None. A `doc.class` declaration
	carries its parents as a list of `doc.extends.name` entries; every other
	kind of declaration puts something else in `extends` entirely, hence the
	shape check rather than a straight index."""
	if not isinstance(extends, list):
		return None
	for entry in extends:
		if isinstance(entry, dict) and entry.get("type") == "doc.extends.name":
			name = entry.get("view")
			if name:
				return str(name)
	return None


def source_link(repo_url, repo_ref, file_path, start):
	"""GitHub blob link for an item's declaration, or None without a real
	position. `start`'s line is 0-indexed (LuaLS convention); GitHub's #L
	anchors are 1-indexed."""
	if not repo_url or start[0] == float("inf"):
		return None
	line = int(start[0]) + 1
	prefix = f"{SOURCE_REPO_PATH}/" if SOURCE_REPO_PATH else ""
	return f"{repo_url}/blob/{repo_ref}/{prefix}{file_path}#L{line}"


def is_foreign_file(path):
	"""LuaLS's --doc export includes its own bundled stdlib meta files
	(prefixed "[FOREIGN] " with an absolute path) alongside the workspace's
	own, workspace-relative files. Only the latter are ours to document."""
	if not path or path.startswith("[FOREIGN]"):
		return True
	path = path.replace("\\", "/")
	return path.startswith("/") or re.match(r"^[A-Za-z]:", path) is not None


def normalise_file(path):
	"""Path relative to `lua/`, which is what the exclusion list, module names
	and source links are all written against. LuaLS is pointed at `lua/` and so
	already reports paths relative to it; the prefix is only stripped for a run
	that pointed it at the repo root instead."""
	if is_foreign_file(path):
		return "unknown"
	path = path.replace("\\", "/")
	if path.startswith("lua/"):
		return path[len("lua/"):]
	return path


def is_excluded(file_path):
	return any(file_path == prefix or file_path.startswith(prefix + "/") for prefix in EXCLUDED_PREFIXES)


def derive_module_name(file_path):
	"""Default module identity for a file with no explicit `@namespace` tag:
	its `lua/`-relative path, dotted (e.g. "autorun/photon/shared/
	sh_simplenet.lua" -> "autorun.photon.shared.sh_simplenet")."""
	if file_path.endswith(".lua"):
		file_path = file_path[:-4]
	return file_path.replace("/", ".")


BLOCK_OPEN_ARTIFACT_RE = re.compile(r"^- (?=\S)")


def parse_ldoc_tags(rawdesc):
	"""Split an old-style LDoc comment into (description, {tag: [values]})."""
	if not rawdesc:
		return "", {}

	# `--[[-- text` block-comment openers leave a stray leading "- " on the
	# first captured line (LuaLS strips one dash of the three-dash marker,
	# not both) - safe to drop since it's never real content.
	rawdesc = BLOCK_OPEN_ARTIFACT_RE.sub("", rawdesc, count=1)

	desc_lines = []
	tags = {}
	current_tag = None

	for line in rawdesc.splitlines():
		match = TAG_LINE_RE.match(line.strip())
		if match:
			current_tag = match.group(1).lower()
			tags.setdefault(current_tag, []).append(match.group(2) or "")
		elif current_tag:
			# Continuation of the previous tag's value. A lone "--" (or
			# more dashes) is the trailing artifact of a `--[[-- ... --]]--`
			# block comment's closing delimiter when it lands on its own
			# line right after the last tag, not real continuation text.
			# Single-value tags must not swallow the next line: LuaLS emits
			# `See: ~https~ :/host/path` after `@namespace`, which would
			# otherwise become a module name containing `/`.
			stripped = line.strip()
			if current_tag in BLOCK_VALUE_TAGS:
				# Blank lines end the block rather than being swallowed, so an
				# example can be followed by more description.
				if not stripped:
					current_tag = None
				else:
					tags[current_tag][-1] += "\n" + line.rstrip()
			elif stripped and not re.match(r"^-+$", stripped):
				if current_tag in SINGLE_VALUE_TAGS:
					current_tag = None
					desc_lines.append(line)
				else:
					tags[current_tag][-1] = (tags[current_tag][-1] + " " + stripped).strip()
		else:
			desc_lines.append(line)

	return "\n".join(desc_lines).strip(), tags


def parse_namespace(value):
	"""Return a dotted identifier from an `@namespace` tag, or None if unusable."""
	if not value or not str(value).strip():
		return None
	token = str(value).strip().split()[0]
	if ".." in token or "/" in token or "\\" in token:
		return None
	if not NAMESPACE_RE.fullmatch(token):
		return None
	return token


def resolve_states(own_tags, header_tags, file_path):
	"""Mirrors config.ld's custom_display_name_handler state fallback chain."""
	states = set()
	for source in (own_tags.get("state"), header_tags.get("state") if header_tags else None):
		if source:
			for value in source:
				states |= STATE_WORDS.get(value.strip().lower(), set())
			return states

	basename = file_path.rsplit("/", 1)[-1]
	prefix_match = re.match(r"^(\w+?)_", basename)
	prefix = prefix_match.group(1) if prefix_match else None
	if basename == "init.lua" or prefix == "sv":
		states.add("server")
	elif basename == "shared.lua" or prefix == "sh":
		states |= {"client", "server"}
	elif prefix == "cl":
		states.add("client")

	return states


def state_badge_classes(states):
	if not states:
		return ""
	return " ".join(f"state-{s}" for s in ("client", "server", "menu") if s in states)


REALM_LABELS = (("server", "Server"), ("client", "Client"), ("menu", "Menu"))


def render_realm_badge(states):
	"""Which realms a symbol exists on, as a readable chip.

	This used to be a bare coloured square — blue serverside, orange clientside,
	a diagonal split for both — with nothing on the site saying so, which left
	the single most repeated element on every page unexplained."""
	classes = state_badge_classes(states)
	if not classes:
		return ""
	present = [label for key, label in REALM_LABELS if f"state-{key}" in classes]
	text = "Shared" if len(present) > 1 else (present[0] if present else "")
	if not text:
		return ""
	return f'<span class="ll-realm {classes}" title="{" and ".join(present)}">{text}</span>'


GLUA_LIBRARY = Path(__file__).resolve().parent / "vendor" / "glua-api-snippets" / "library"
GLUA_CLASS_RE = re.compile(r"^---@class\s+([A-Za-z_][A-Za-z0-9_]*)", re.MULTILINE)
GLUA_WIKI_URL = "https://wiki.facepunch.com/gmod/"
TYPE_TOKEN_RE = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


def scan_glua_classes(library_dir=GLUA_LIBRARY):
	"""Base-game class names from the vendored glua-api-snippets library, so a
	parameter typed `IMaterial` can link to the wiki page that documents it.

	Empty when the submodule isn't checked out — the build still works, types
	just don't link out. CI initialises it; a local build may not have."""
	names = set()
	if not library_dir or not Path(library_dir).is_dir():
		return names
	for path in Path(library_dir).glob("*.lua"):
		names.update(GLUA_CLASS_RE.findall(path.read_text(encoding="utf-8", errors="ignore")))
	return names


def build_type_links(by_module, glua_classes):
	"""`name -> href` for every type worth linking from a signature.

	A type documented here wins over the same name on the wiki: `Player`,
	`Entity` and `Vehicle` are base-game classes, but our page is the one that
	says what Photon added to them. Types are only rendered on module pages, so
	a local href is a plain sibling filename."""
	links = {name: page_filename(name) for name in by_module}
	for name in glua_classes:
		links.setdefault(name, f"{GLUA_WIKI_URL}{name}")
	return links


# A reference has to be dotted or colon-qualified to be considered: a bare word
# in prose is a word, but `Photon.SNet:Map` can only be one thing.
SYMBOL_REF_RE = re.compile(r"\b[A-Za-z_][A-Za-z0-9_]*(?:[.:][A-Za-z_][A-Za-z0-9_]*)+\b(?:\(\))?")
TAG_OR_TEXT_RE = re.compile(r"<[^>]*>|[^<]+")


def add_symbol_links(links, by_module):
	"""Add `name -> page#anchor` for every documented symbol, so prose can refer
	to one by name. Shares the dict `linkify_type` reads: the two matchers take
	disjoint shapes — a type is a bare capitalised word, a symbol reference has
	to be qualified — so neither can pick up the other's keys."""
	for module_name, entries in by_module.items():
		page = page_filename(module_name)
		for item in entries:
			if item["name"] != module_name:
				links.setdefault(item["name"], f'{page}#{item["name"]}')
	return links


def linkify_symbols(html_text, links):
	"""Turn `Photon.SNet:Map` in already-rendered prose into a link to it.

	A deprecation that says "use X instead" is only useful if you can get to X,
	and the same holds for any description that names another function.

	No wrapper syntax is needed to make this safe. A reference must be qualified
	and must match a documented symbol exactly, and no qualified name in this
	codebase lives on more than one page — so a match has exactly one possible
	destination. Requiring authors to mark references up would instead mean the
	120-odd that are already written stay unlinked until somebody rewrites them.

	Walks the text between tags rather than the whole string. Skips anything
	inside an anchor, so it cannot nest one link inside another, and anything
	inside a `<pre>`, so a code example does not turn into link soup — an inline
	`<code>` still links, which is how most references are written."""
	if not links or "<a " not in html_text and not SYMBOL_REF_RE.search(html_text):
		return html_text

	def replace(match):
		raw = match.group(0)
		name = raw[:-2] if raw.endswith("()") else raw
		href = links.get(name) or links.get(name.replace(":", ".", 1))
		if not href:
			return raw
		return f'<a href="{html.escape(href, quote=True)}">{raw}</a>'

	out, skip = [], 0
	for piece in TAG_OR_TEXT_RE.findall(html_text):
		if piece.startswith("<"):
			lowered = piece.lower()
			if lowered.startswith(("<a>", "<a ", "<pre>", "<pre ")):
				skip += 1
			elif lowered.startswith(("</a", "</pre")) and skip:
				skip -= 1
			out.append(piece)
		else:
			out.append(piece if skip else SYMBOL_REF_RE.sub(replace, piece))
	return "".join(out)


# `owner/repo#123` first (both groups), falling back to a bare `repo#123`
# (third group only), falling back to a bare `#123` (no groups) - tried in
# that order per match position since regex alternation commits to the first
# branch that can succeed there. The lookbehind stops `foo/bar#1` from also
# matching as a bare `bar#1` starting mid-word.
ISSUE_REF_RE = re.compile(r"(?<![\w/])(?:([\w.-]+)/([\w.-]+)|([\w.-]+))?#(\d+)\b")
REPO_URL_RE = re.compile(r"^(https?://[^/]+)/([^/]+)/([^/]+)/?$")


def linkify_issue_refs(html_text, repo_url):
	"""Turn `#123`, `repo#123`, and `org/repo#123` into links to that
	issue/PR - the same shorthand GitHub autolinks in issue and PR bodies,
	extended here to doc comments and topics. `repo_url` is this repo's own
	URL; a bare `repo#123` is resolved against its org, so a cross-repo
	reference doesn't need spelling out in full.

	Always links to `/issues/N`, never `/pull/N` - GitHub redirects one to
	the other depending on which the number actually is, same as its own
	autolinking does, so there's no need to know which up front.

	Skips anything already inside an `<a>`, `<pre>`, or `<code>` - GitHub
	does not autolink inside code either, and without this a colour-model
	code span like `` `#123456` `` (an all-digit hex) would read as an issue
	reference."""
	match = REPO_URL_RE.match(repo_url or "")
	if not match:
		return html_text
	host, org, repo = match.groups()

	def replace(m):
		owner, name, solo = m.group(1), m.group(2), m.group(3)
		target_org, target_repo = (owner, name) if owner else (org, solo) if solo else (org, repo)
		href = f"{host}/{target_org}/{target_repo}/issues/{m.group(4)}"
		return f'<a href="{html.escape(href, quote=True)}">{m.group(0)}</a>'

	out, skip = [], 0
	for piece in TAG_OR_TEXT_RE.findall(html_text):
		if piece.startswith("<"):
			lowered = piece.lower()
			if lowered.startswith(("<a>", "<a ", "<pre>", "<pre ", "<code>", "<code ")):
				skip += 1
			elif lowered.startswith(("</a", "</pre", "</code")) and skip:
				skip -= 1
			out.append(piece)
		else:
			out.append(piece if skip else ISSUE_REF_RE.sub(replace, piece))
	return "".join(out)


def linkify_type(raw_type, type_links):
	"""Link the identifiers inside a type expression, leaving the punctuation of
	`table<string, Player>` or `fun(a: b): c` alone.

	Only capitalised multi-character names are candidates. Primitives are all
	lowercase (`string`, `any`, `fun`), and a lone capital is a generic (`T`,
	`K`, `V`) rather than a type anyone can look up. Escaping happens per
	fragment here rather than up front, so the escapes themselves can't be
	mistaken for identifiers."""
	out, last = [], 0
	for match in TYPE_TOKEN_RE.finditer(raw_type or ""):
		out.append(html.escape(raw_type[last:match.start()]))
		name = match.group(0)
		href = type_links.get(name) if len(name) > 1 and name[0].isupper() else None
		out.append(f'<a href="{html.escape(href, quote=True)}">{html.escape(name)}</a>'
			if href else html.escape(name))
		last = match.end()
	out.append(html.escape((raw_type or "")[last:]))
	return "".join(out)


def render_signature(display, item, type_links=None):
	"""`Player:Arrested() → boolean|nil` — the whole call shape, not just the name.

	Metatable methods take a `:`; anything else keeps its `.`. Non-functions get
	their name alone, with no parentheses to imply they are callable.

	The return arrow is `→` rather than TypeScript's `:` because `:` already
	means "method call" three characters to its left — `Player:Arrested(): x`
	puts two different meanings of the same character in one line. `->` is also
	what LuaLS itself shows on hover, so it is what a reader sees in the
	editor."""
	name = html.escape(display)
	if item.get("is_method") and "." in name:
		owner, _, method = name.rpartition(".")
		name = f"{owner}<span class=\"ll-sep\">:</span>{method}"
	if (item.get("kind") or "").lower() not in ("functions", "function"):
		return name
	args = ", ".join(html.escape(param.get("name") or "_") for param in item.get("params") or [])
	types = [linkify_type(str(ret.get("view") or ret.get("type") or "").strip(), type_links or {})
		for ret in item.get("returns") or []]
	types = [t for t in types if t]
	returns = f'<span class="ll-returns"> → {", ".join(types)}</span>' if types else ""
	return f'{name}<span class="ll-args">({args})</span>{returns}'


def render_callout(kind, body_html):
	title = ALERT_TITLES.get(kind, kind.replace("-", " ").title())
	return (f'<blockquote class="ll-alert ll-alert-{kind}">'
		f'<p class="ll-alert-title">{title}</p>{body_html}</blockquote>')


def render_callout_tags(tags, links=None):
	"""`@warning`, `@bug`, `@deprecated`, `@internal`, `@note`, `@validate` and
	`@ambig` as callout boxes — the same ones a topic gets from `> [!WARNING]`,
	so the site has one visual language for "read this before you use it"
	rather than two.

	Several spellings of a tag collapse into one box: `@warns` and `@warning`
	are the same thing, and a function carrying both should not get two."""
	collected = {}
	for tag_name, values in (tags or {}).items():
		kind = CALLOUT_TAG_ALIASES.get(tag_name)
		if kind:
			collected.setdefault(kind, []).extend(values)

	out = []
	for kind in CALLOUT_ORDER:
		if kind not in collected:
			continue
		paragraphs = [f"<p>{linkify_symbols(render_markdown_inline(value), links or {})}</p>"
			for value in collected[kind] if value and value.strip()]
		default = CALLOUT_DEFAULTS.get(kind)
		if default:
			paragraphs.insert(0, f"<p>{default}</p>")
		out.append(render_callout(kind, "".join(paragraphs)))
	return "".join(out)


# --- LuaLS JSON flattening --------------------------------------------------

def sort_key(start):
	"""`start` is a LuaLS [line, column] pair, but may be missing; normalise
	to a uniformly comparable tuple so mixed present/missing values can sort."""
	if isinstance(start, list):
		return tuple(start)
	return (float("inf"), float("inf"))


def extract_params_returns(extends):
	"""Native params/returns live under `extends.args`/`extends.returns`
	(not top-level `params`/`returns` keys). Implicit `self` is dropped to
	match the site's existing `:`-method documentation convention.

	`extends` is only a function signature dict for function-typed items;
	for other kinds (e.g. `@type` aliases) it can be a list or absent."""
	if not isinstance(extends, dict) or extends.get("type") != "function":
		return [], [], False
	args = extends.get("args") or []
	params = [a for a in args if a.get("name") != "self" and a.get("type") != "self"]
	returns = extends.get("returns") or []
	# An implicit `self` is what distinguishes `function meta:Name()` from
	# `function tbl.Name()` — and it's the only signal for it, since LuaLS
	# reports both as `Owner.Name`. Every entry on the metatable pages is a
	# colon method, so documenting them with a `.` documents a call that errors.
	return params, returns, len(args) != len(params)


def normalise_whitespace(text):
	return " ".join((text or "").split())


# `@alias` is here as well as `@class` because a param typed as one inherits
# its comment the same way - and an alias's comment arrives pre-rendered as a
# code fence listing every member, so the un-stripped version is worse: a whole
# fenced block, tag lines and all, in the cell meant for one line about the
# argument.
DESCRIBED_TYPE_DECLS = {"doc.class", "doc.alias", "doc.enum"}


def class_descriptions(data):
	"""Normalised description text for every documented type in the export,
	keyed by type name. Both the raw comment and its tag-stripped form are kept,
	since a param inherits whichever of the two LuaLS resolved."""
	descs = {}
	for entry in data if isinstance(data, list) else [data]:
		if not isinstance(entry, dict):
			continue
		for define in entry.get("defines") or []:
			if define.get("type") not in DESCRIBED_TYPE_DECLS:
				continue
			raw = define.get("rawdesc") or define.get("desc") or ""
			if not raw.strip():
				continue
			variants = descs.setdefault(entry.get("name"), set())
			variants.add(normalise_whitespace(raw))
			variants.add(normalise_whitespace(parse_ldoc_tags(raw)[0]))
			alias = parse_alias_block(raw)
			if alias:
				variants.add(normalise_whitespace(alias[0]))
	return descs


def strip_inherited_type_descriptions(params, class_descs):
	"""A `@param` with no description of its own comes back from LuaLS carrying
	the doc comment of the *class* it is typed as - so `@param ent Entity` puts
	the Entity metatable's own blurb ("The entity metatable, with Photon's own
	additions to Garry's Mod's `Entity`") in the column that is supposed to
	describe the argument, on every param typed as a documented class.

	Nothing in the export distinguishes an inherited description from a real
	one, so recognise it by value: drop the description when it is exactly the
	description of the param's own type. Runs before `merge_tag_descriptions`
	so an old-style `@param name desc` comment line can still fill the slot the
	inherited text was occupying."""
	for param in params:
		desc = normalise_whitespace(param.get("desc"))
		if not desc:
			continue
		# `view` carries the resolved type, with a trailing `?` for optionals.
		type_name = str(param.get("view") or "")
		if desc in class_descs.get(type_name, ()) or desc in class_descs.get(type_name.rstrip("?"), ()):
			param["desc"] = None
			param.pop("rawdesc", None)


def merge_tag_descriptions(params, returns, tags):
	"""Old-style `@param name desc` / `@return type desc` comment lines have
	no structural counterpart in LuaLS's JSON, so fold their text back onto
	the native params/returns list by name (params) or position (returns)."""
	for value in tags.get("param", []):
		name, _, desc = value.strip().partition(" ")
		for param in params:
			if param.get("name") == name and not param.get("desc"):
				param["desc"] = desc.strip()
				break

	for ret, value in zip(returns, tags.get("return", [])):
		if not ret.get("desc"):
			# Old-style `@return type desc` bundles a now-redundant type
			# name (the native `view` is more accurate) ahead of the
			# actual description - drop that leading token.
			_, _, desc = value.strip().partition(" ")
			ret["desc"] = desc.strip()


# LuaLS appends the accepted values of an `@alias`-typed parameter onto the
# *function's* description, as a fenced block holding the alias's own comment
# lines (leading `--`, `@section` and all) above a `<param>:` header and one
# `| `MEMBER`` line per value. The parameter row already names the type and
# the alias has its own entry listing the same members, so on a rendered page
# this is a verbatim second copy with the comment markers still in it.
ALIAS_VALUES_BLOCK_RE = re.compile(
	r"\n*```lua\n(?:[^\n]*\n)*?[^\n]*:\n(?:[ \t]*\|[^\n]*\n)+```[ \t]*$")


def strip_alias_value_block(rawdesc):
	return ALIAS_VALUES_BLOCK_RE.sub("", rawdesc)


def field_owners(data):
	"""Which parent actually declares each member, for the members LuaLS lists
	under more than one.

	A class's fields are copied onto every subclass of it in the export, so a
	method written on `Entity` is listed again, at the same file and line, under
	`CSEnt`, `ENT`, `EFFECT`, `NEXTBOT` and the rest. They are one declaration,
	not fourteen, and only the class it was written on has a page for it.

	The one that wrote it is the one whose own declaration is in that same file
	- a subclass inheriting the copy is declared somewhere else entirely (in the
	base-game library, for these). Returns `{(file, start): owner_name}` for
	every location claimed by more than one parent; a location claimed once is
	left out, so the common case costs nothing."""
	claims = {}
	for entry in data if isinstance(data, list) else [data]:
		if not isinstance(entry, dict) or "name" not in entry:
			continue
		own_files = {normalise_file(d["file"]) for d in entry.get("defines") or []
			if d.get("file") and not is_foreign_file(d["file"])}
		for field in entry.get("fields") or []:
			if not field.get("file"):
				continue
			loc = (field["file"], sort_key(field.get("start")))
			claims.setdefault(loc, []).append(
				(entry["name"], normalise_file(field["file"]) in own_files))

	owners = {}
	for loc, claimants in claims.items():
		if len(claimants) < 2:
			continue
		declared = next((name for name, is_own in claimants if is_own), None)
		owners[loc] = declared if declared else claimants[0][0]
	return owners


def flatten_items(data):
	"""Turn LuaLS's nested defines/fields structure into a flat list of doc
	items, each carrying its own resolved file path, description, and tags.

	Most documented members show up as independent top-level entries with
	already-dotted names (e.g. "meska.achievements.add"); a minority are
	also nested under a parent's `fields` array at the *same* source
	location. Nested field entries also lack their own `defines` wrapper -
	their file/start/rawdesc sit directly on the field dict itself."""
	class_descs = class_descriptions(data)
	owners = field_owners(data)
	top_level_locations = set()
	for entry in data if isinstance(data, list) else [data]:
		for define in entry.get("defines") or []:
			if define.get("file") and define.get("start"):
				top_level_locations.add((define["file"], sort_key(define["start"])))

	items = []

	def add(entry, parent_name, inherited_file, inherited_own_tags, inherited_module, depth):
		defines = entry.get("defines") or []
		# Anything the addon shares a name with in the base-game library
		# (every GM.* hook, Entity, Color, TEAM) is exported with both
		# declarations, base-game first. Taking defines[0] there resolves the
		# file to "unknown", which group_by_module then drops - so the
		# addon's own declaration must win.
		define = next((d for d in defines if not is_foreign_file(d.get("file"))),
			defines[0] if defines else {})
		has_own_location = bool(define) or bool(entry.get("file"))

		raw_file = define.get("file") or entry.get("file")
		file_path = normalise_file(raw_file) if raw_file else inherited_file
		start = define.get("start") or entry.get("start")

		rawdesc = define.get("rawdesc") or define.get("desc") or entry.get("rawdesc") or entry.get("desc") or ""
		if define.get("type") != "doc.alias":
			rawdesc = strip_alias_value_block(rawdesc)
		desc, tags = parse_ldoc_tags(rawdesc)
		if define.get("deprecated") and "deprecated" not in tags:
			tags["deprecated"] = [""]

		# An `@alias` arrives pre-rendered as a code fence, description and
		# all - unpack it so the comment reads as a comment and the members
		# are available to group the constants they name.
		alias = parse_alias_block(rawdesc) if define.get("type") == "doc.alias" else None
		if alias:
			desc, tags, members = alias
			alias = {"members": members}

		is_class = define.get("type") == "doc.class"

		extends = define.get("extends") or entry.get("extends")
		params, returns, is_method = extract_params_returns(extends)
		strip_inherited_type_descriptions(params, class_descs)
		merge_tag_descriptions(params, returns, tags)
		kind = classify_kind(extends, define.get("type"))
		parent_class = extends_class_name(extends)

		# `@namespace` only makes sense as a top-level, per-declaration
		# concept: nested fields just belong to whatever module their parent
		# resolved to. Only tags LuaLS actually attached to *this*
		# declaration count - an inherited tag from a parent shouldn't be
		# re-read as this item's own module.
		#
		# Named "@namespace", not "@module": lua-language-server reserves
		# `@module` for its own require()-return-type annotation and
		# silently drops any comment line using it.
		explicit_module = None
		if depth == 0:
			raw_ns = tags.get("namespace", [None])[0] if has_own_location else None
			explicit_module = parse_namespace(raw_ns)
			module = explicit_module or derive_module_name(file_path)
		else:
			module = inherited_module

		name = entry.get("name", "?")
		full_name = f"{parent_name}.{name}" if parent_name and depth > 0 else name

		items.append({
			"name": full_name,
			"type": entry.get("type", "unknown"),
			"kind": kind,
			"file": file_path,
			"module": module,
			"explicit_module": explicit_module if depth == 0 else None,
			"desc": desc,
			"tags": tags,
			"alias": alias,
			"is_class": is_class,
			"own_tags": tags if has_own_location else inherited_own_tags,
			"params": params,
			"returns": returns,
			"is_method": is_method,
			"start": sort_key(start),
			"depth": depth,
			"extends": parent_class,
		})

		next_own_tags = tags if has_own_location else inherited_own_tags
		for field in entry.get("fields") or []:
			field_loc = (field.get("file"), sort_key(field.get("start"))) if field.get("file") else None
			if field_loc and field_loc in top_level_locations:
				# Already present as its own top-level entry; skip to avoid
				# rendering the same function twice.
				continue
			if field_loc and owners.get(field_loc, full_name) != full_name:
				# An inherited copy of someone else's member - see field_owners.
				continue
			add(field, full_name, file_path, next_own_tags, module, depth + 1)

	for module in data if isinstance(data, list) else [data]:
		if isinstance(module, dict) and "name" in module:
			add(module, "", "unknown", {}, None, 0)

	# An explicit `@namespace` tag applies to its whole file, not just the
	# one declaration whose comment happens to carry it - propagate it to
	# every other item in that file (siblings and nested fields alike) that
	# didn't declare a conflicting one of their own.
	file_modules = {}
	for item in items:
		if item["explicit_module"] and item["file"] not in file_modules:
			file_modules[item["file"]] = item["explicit_module"]
	for item in items:
		if not item["explicit_module"] and item["file"] in file_modules:
			item["module"] = file_modules[item["file"]]

	return items


def group_by_module(items):
	"""Groups items by their resolved `@namespace` (or its file-derived
	default), so files that share an explicit `@namespace` tag (e.g.
	cl_temar.lua and sv_temar.lua both tagging `@namespace temar`) merge
	onto one page - mirrors config.ld's `merge = true`. Exclusion still
	applies per source file."""
	by_module = {}
	for item in items:
		# A member re-parented onto a base-game class keeps its own (real)
		# file but inherits its parent's module, which for a base-game
		# parent is "unknown" - LuaLS copies inherited fields onto every
		# subclass, so the five Entity helpers in sh_entity.lua reappear
		# under CSEnt, ENT, EFFECT, NEXTBOT and the rest. They belong to
		# Entity, which is documented; the copies have no page to live on.
		if item["file"] == "unknown" or item["module"] == "unknown" or is_excluded(item["file"]):
			continue
		module = item["module"]
		# LuaLS `@see https://...` can leak `/` into the module name; never
		# let that become a nested path under modules/.
		if module and ("/" in module or "\\" in module):
			module = parse_namespace(module) or derive_module_name(item["file"])
			item["module"] = module
		by_module.setdefault(module, []).append(item)
	for module_items in by_module.values():
		module_items.sort(key=lambda i: (i["file"], i["start"]))
	return by_module


def module_header_tags(module_items):
	"""The earliest top-level (depth 0) item carries the header comment,
	per config.ld's `file.items[1]` fallback. Note: doc comments separated
	from their code by a blank line (the common case for this codebase's
	old `--[[-- ... --]]--` file headers) never reach LuaLS's JSON at all,
	so this fallback rarely has anything to find in practice - only doc
	comments immediately adjacent to code make it through."""
	for item in module_items:
		if item["depth"] == 0 and item["own_tags"]:
			return item["own_tags"]
	return {}


# --- Raw-source file header scan --------------------------------------------
#
# LuaLS only hands us a doc comment when it's immediately adjacent to code
# (see module_header_tags() above), but this codebase's actual file headers
# are almost always separated from the code by a blank line, so LuaLS drops
# them entirely. Rather than wait on that, read the file's own leading
# comment block directly - a quick, independent pass alongside the LuaLS
# JSON, scoped to just this one thing (file-level description/@namespace).
# @section still only works at the per-item level LuaLS gives us.

BLOCK_COMMENT_OPEN_RE = re.compile(r"^--\[\[-*\s?")
BLOCK_COMMENT_CLOSE_RE = re.compile(r"-*\]\]-*")


def read_file_header(path):
	"""Extracts the description/tags from a Lua file's leading comment
	block, whether it's a `--[[-- ... --]]--` block or a run of `---`/`--`
	line comments - regardless of whether a blank line separates it from
	the code that follows (that's exactly the case LuaLS can't handle)."""
	try:
		lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
	except OSError:
		return "", {}

	i = 0
	while i < len(lines) and not lines[i].strip():
		i += 1
	if i >= len(lines):
		return "", {}

	header_lines = []
	first = lines[i].strip()
	if first.startswith("--[["):
		header_lines.append(BLOCK_COMMENT_OPEN_RE.sub("", first))
		i += 1
		while i < len(lines):
			close = BLOCK_COMMENT_CLOSE_RE.search(lines[i])
			if close:
				header_lines.append(lines[i][:close.start()])
				break
			header_lines.append(lines[i])
			i += 1
	elif first.startswith("--"):
		while i < len(lines) and lines[i].strip().startswith("--"):
			header_lines.append(re.sub(r"^-+\s?", "", lines[i].strip()))
			i += 1
	else:
		return "", {}

	return parse_ldoc_tags("\n".join(header_lines))


def scan_file_headers(source_root, files):
	headers = {}
	for file_path in files:
		desc, tags = read_file_header(source_root / file_path)
		if desc or tags:
			headers[file_path] = (desc, tags)
	return headers


def apply_file_headers(items, file_headers):
	"""File-header @namespace takes priority over whatever LuaLS happened
	to capture off an adjacent comment - it's the file's actual canonical
	header, not a coincidence of comment placement."""
	for file_path, (_, tags) in file_headers.items():
		namespace = parse_namespace(tags.get("namespace", [None])[0])
		if not namespace:
			continue
		for item in items:
			if item["file"] == file_path:
				item["module"] = namespace


# --- Item pages -------------------------------------------------------------
#
# Item bases all share `@namespace ITEM`, so without this they pile onto the
# one ITEM page with their members disambiguated only by class prefix
# (ITEM.Accessory.canDrop next to ITEM.Ammo.canDrop). A base is identified by
# its `@uniqueid` - the same tag the docs search keys off - so nothing here
# needs a second list of which classes are items.

ITEM_ROOT_CLASS = "ITEM"


def item_display_name(name, class_name):
	"""`ITEM.Accessory.canDrop` -> `ITEM.canDrop`, because that is what the
	member is called at the call site: an item file writes
	`function ITEM:canDrop(...)`, and the class prefix exists only to keep the
	bases apart in the type system."""
	if name == class_name:
		return ITEM_ROOT_CLASS
	prefix = class_name + "."
	if name.startswith(prefix):
		return ITEM_ROOT_CLASS + "." + name[len(prefix):]
	return name


def inheritance_chain(class_name, class_parents):
	"""Root-first ancestry of a class, e.g. ITEM, ITEM.Clothing, ITEM.Outfit
	for ITEM.Uniform. Stops on a cycle rather than hanging - `@class` parents
	are author-written and nothing upstream checks them."""
	chain = []
	seen = {class_name}
	current = class_parents.get(class_name)
	while current and current not in seen:
		seen.add(current)
		chain.append(current)
		current = class_parents.get(current)
	chain.reverse()
	return chain


def declared_namespaces(items, file_headers):
	"""Every name claimed as a page by an explicit `@namespace`, from either
	source the generator reads them from."""
	namespaces = set()
	for _, tags in (file_headers or {}).values():
		namespace = parse_namespace(tags.get("namespace", [None])[0])
		if namespace:
			namespaces.add(namespace)
	for item in items:
		if item["explicit_module"]:
			namespaces.add(item["explicit_module"])
	return namespaces


PANEL_DIRS = ("core/derma/", "/derma/")
FIND_METATABLE_RE = re.compile(r'FindMetaTable\(\s*"([A-Za-z_]+)"\s*\)')


def _posix_file(item):
	return (item.get("file") or "").replace("\\", "/")


DEPRECATED_REASON_RE = re.compile(r"^\s*--+\s*@deprecated\s+(\S.*?)\s*$")
DOC_COMMENT_RE = re.compile(r"^\s*(--|$)")


def scan_deprecation_reasons(source_root, items):
	"""Recover the text written after `@deprecated`.

	Every other callout tag survives into the export precisely because LuaLS has
	never heard of it and passes it through as description. `@deprecated` is a
	real LuaCATS annotation, so LuaLS consumes the whole line and exposes a bare
	boolean — losing the reason, which is the useful half of a deprecation
	notice. The ones that name a replacement carry the only statement of what
	a caller is supposed to move to, and none of it was reaching the page.

	So read it back off the source: walk up from the declaration through its own
	doc-comment block, which is where the tag has to be anyway."""
	cache = {}
	for item in items:
		if item["tags"].get("deprecated") != [""]:
			continue
		line_no = item["start"][0]
		if line_no == float("inf") or not item.get("file"):
			continue
		if item["file"] not in cache:
			try:
				cache[item["file"]] = (source_root / item["file"]).read_text(
					encoding="utf-8", errors="ignore").splitlines()
			except OSError:
				cache[item["file"]] = []
		lines = cache[item["file"]]
		# `start` is 0-indexed and points at the declaration; the comment block
		# is directly above it, and stops at the first line that isn't one.
		for offset in range(int(line_no) - 1, -1, -1):
			if offset >= len(lines) or not DOC_COMMENT_RE.match(lines[offset]):
				break
			match = DEPRECATED_REASON_RE.match(lines[offset])
			if match:
				item["tags"]["deprecated"] = [match.group(1)]
				break


def scan_metatable_names(source_root, files):
	"""Class names the addon extends via `FindMetaTable("X")` — `Entity`,
	`Vehicle`, `Player`.

	Read out of the source rather than inferred from where a `@class` sits,
	because neither end of that inference holds: LuaLS attributes a re-opened
	`@class Entity` to whichever file re-opens it first, and a plain data class
	that merely lives alongside a metatable gets swept in by the folder alone.
	`FindMetaTable` is what actually makes a class a metatable.

	These then claim a page the way a `@namespace` class does, without every
	file that hangs a method off a metatable having to declare one — which
	matters here, because Photon extends `Entity` from several files at once
	and none of them owns the metatable."""
	names = set()
	for file_path in files:
		try:
			text = (source_root / file_path).read_text(encoding="utf-8", errors="ignore")
		except OSError:
			continue
		names.update(FIND_METATABLE_RE.findall(text))
	return names


def panel_modules(by_module, exclude):
	"""Modules documented entirely out of a `derma/` folder — VGUI panels.

	Only counts a module whose every member comes from one, so a library that
	merely has a panel helper stays under Modules."""
	return {name for name, entries in by_module.items()
		if name not in exclude and entries
		and all(any(part in _posix_file(item) for part in PANEL_DIRS) for item in entries)}


def assign_class_modules(items, file_headers=None, metatable_names=()):
	"""Puts a class's members on the class's own page.

	A member inherits its module from its parent class, whose module comes
	from whichever file LuaLS happened to list first - so a class re-opened
	across several files scatters. `Entity` is the case here: Photon hangs
	`ent:GetPhotonNet_SirenOn` off it from sh_simplenet.lua and its EMV
	methods off it from sh_emv_meta.lua, and without this the two land on
	different pages — neither of which is where a reader looks for an Entity
	method.

	A class opts into this by declaring `@namespace <ClassName>` in one of
	its files. Data classes that exist to describe a library's own table
	declare no such namespace and stay on that library's page, next to what
	they describe.

	Runs before assign_item_modules, so a documented base still claims its
	members back off the class page."""
	namespaces = declared_namespaces(items, file_headers)
	class_names = {item["name"] for item in items
		if item["depth"] == 0 and item.get("is_class") and item["name"] in namespaces}
	class_names |= {item["name"] for item in items
		if item["depth"] == 0 and item.get("is_class") and item["name"] in metatable_names}
	if not class_names:
		return

	for item in items:
		root = item["name"].split(".", 1)[0]
		if root in class_names:
			item["module"] = root


def assign_item_modules(items, file_headers=None):
	"""Moves every `@uniqueid`-tagged class and its members onto a page of
	their own, and returns the per-item metadata the page header needs.

	Runs after apply_file_headers deliberately: the file-header `@namespace`
	would otherwise have pulled all of them back onto ITEM."""
	class_parents = {item["name"]: item["extends"] for item in items
		if item["depth"] == 0 and item.get("extends")}

	item_meta = {}
	for item in items:
		if item["depth"] != 0:
			continue
		uniqueids = item["tags"].get("uniqueid")
		if not uniqueids:
			continue
		item_meta[item["name"]] = {
			"uniqueids": [u.strip() for u in uniqueids if u.strip()],
			"chain": inheritance_chain(item["name"], class_parents),
			"desc": item["desc"],
			"file": item["file"],
		}

	if not item_meta:
		return {}

	# Longest first so ITEM.SuitTie's members are not claimed by ITEM.Suit.
	class_names = sorted(item_meta, key=len, reverse=True)
	for item in items:
		name = item["name"]
		if name in item_meta:
			item["module"] = name
			continue
		for class_name in class_names:
			if name.startswith(class_name + "."):
				item["module"] = class_name
				break

	# The root belongs beside the bases rather than among the libraries: it
	# is what they all inherit from, and every item page's chain ends at it.
	# Added after the loop above so it cannot claim a base's members by
	# prefix. It carries no `@uniqueid` (a metatable is not a registered
	# item) and no `file` - the bases re-open `@class ITEM` to hang their
	# own setters on it, so those genuinely belong here and the
	# own-declaration filter must not drop them. Its description comes from
	# its own file rather than module_descriptions, which picks the first
	# file alphabetically and so described ITEM as "Accessory Base Item".
	root = next((i for i in items if i["depth"] == 0 and i["name"] == ITEM_ROOT_CLASS), None)
	if root is not None:
		header_desc = (file_headers or {}).get(root["file"], ("", {}))[0]
		item_meta.setdefault(ITEM_ROOT_CLASS, {"uniqueids": [], "chain": [],
			"desc": header_desc or root["desc"], "file": None})

	return item_meta


def module_descriptions(by_module, file_headers):
	"""The page-level intro for each module: the first (by file, sorted)
	scanned header description among the files that make it up.

	A file that declares the module's own `@namespace` outranks one that
	merely contributes to it. A class page collects members from files all
	over the tree - sv_access.lua hangs two methods on Player - and those
	files' headers describe themselves, not the class, so without this the
	Player page introduces itself as "Access and flags - server."."""
	descriptions = {}
	for module_name, module_items in by_module.items():
		files = sorted({item["file"] for item in module_items})
		claims_it = [path for path in files
			if parse_namespace(file_headers.get(path, ("", {}))[1].get("namespace", [None])[0])
				== module_name]
		for file_path in claims_it + files:
			desc, _ = file_headers.get(file_path, ("", {}))
			if desc:
				descriptions[module_name] = desc
				break
	return descriptions


# --- Rendering ---------------------------------------------------------------

def page_filename(module_name):
	"""HTML filename for a module page. Must stay a single path segment under
	`modules/` — LuaLS `@see https://...` can otherwise inject `/`."""
	safe = re.sub(r"[^\w.-]+", "_", module_name or "", flags=re.ASCII).strip("._")
	return f"{safe or 'module'}.html"


# Fetched on first use rather than inlined into every page: the index is one
# file for the whole site, and a reader who never searches never pays for it.
SEARCH_SCRIPT = """(function () {
	var input = document.getElementById("ll-search-input");
	var list = document.getElementById("ll-search-results");
	if (!input || !list) { return; }
	var index = null, loading = false;

	function load() {
		if (index || loading) { return; }
		loading = true;
		fetch(ROOT + "search.json").then(function (response) {
			return response.json();
		}).then(function (data) {
			index = data;
			loading = false;
			render();
		}).catch(function () {
			loading = false;
			list.innerHTML = "<li><p>Search index unavailable.</p></li>";
			list.hidden = false;
		});
	}

	// Lower is better: exact name, then prefix, then anywhere in the name, then
	// only in the description.
	function score(entry, query) {
		var name = entry.n.toLowerCase();
		if (name === query) { return 0; }
		if (name.lastIndexOf(query, 0) === 0) { return 1; }
		if (name.indexOf(query) > 0) { return 2; }
		return (entry.d || "").toLowerCase().indexOf(query) >= 0 ? 3 : -1;
	}

	function escape(text) {
		return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
	}

	function render() {
		var query = input.value.trim().toLowerCase();
		if (!query) { list.hidden = true; list.innerHTML = ""; return; }
        if (!index) { return; }
		var hits = [];
		for (var i = 0; i < index.length; i++) {
			var rank = score(index[i], query);
			if (rank >= 0) { hits.push([rank, index[i].n.length, index[i]]); }
		}
		hits.sort(function (a, b) { return a[0] - b[0] || a[1] - b[1]; });
		list.innerHTML = hits.slice(0, 20).map(function (hit) {
			var entry = hit[2];
			return '<li><a href="' + ROOT + entry.u + '">' + escape(entry.n)
				+ '<span class="ll-search-kind">' + escape(entry.k) + "</span></a></li>";
		}).join("") || "<li><p>No matches.</p></li>";
		list.hidden = false;
	}

	input.addEventListener("focus", load);
	input.addEventListener("input", function () { load(); render(); });
	input.addEventListener("keydown", function (event) {
		if (event.key === "Escape") { input.value = ""; render(); input.blur(); }
		if (event.key === "Enter") {
			var first = list.querySelector("a");
			if (first) { window.location.href = first.href; }
		}
	});

	// "/" jumps to the box, unless the reader is already typing somewhere -
	// preventDefault stops the slash itself landing in the field.
	document.addEventListener("keydown", function (event) {
		if (event.key !== "/" || event.ctrlKey || event.metaKey || event.altKey) { return; }
		var active = document.activeElement;
		if (active && (active.isContentEditable
			|| /^(input|textarea|select)$/i.test(active.tagName))) { return; }
		event.preventDefault();
		input.focus();
		input.select();
	});
})();"""

SEARCH_BOX = ('<div class="ll-search">'
	'<input type="search" id="ll-search-input" autocomplete="off" spellcheck="false"'
	' placeholder="Search docs… (/)" aria-label="Search documentation">'
	'<ul id="ll-search-results" class="ll-kind-body" hidden></ul>'
	"</div>")


# Overwritten in main() with the content-hashed filename actually written to
# the output directory, so a changed stylesheet can't be served stale from a
# browser or CDN cache. Left as "style.css" for callers (and tests) that
# render pages without going through main().
STYLE_FILENAME = "style.css"


def render_page_shell(title, nav_html, content_html, to_root=""):
	return f"""<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>{html.escape(title)}</title>
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Quicksand:wght@400;500;600;700&family=Nunito+Sans:opsz,wght@6..12,400;6..12,600;6..12,700&family=IBM+Plex+Mono:wght@400;500&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="{to_root}{STYLE_FILENAME}" type="text/css">
</head>
<body>
<header class="ll-header">
	<div class="ll-header-inner">
		<a class="ll-brand" href="{to_root}index.html">
			<img src="{to_root}assets/logos/photon.svg" alt="" width="26" height="26">
			<span>Photon Documentation</span>
		</a>
		<a class="ll-repo-link" href="https://github.com/photonle/Photon" target="_blank" rel="noreferrer">Repository</a>
	</div>
</header>
<div id="container">
	<div id="main">
		<div id="navigation">
{nav_html}
		</div>
		<div id="content">
{content_html}
		</div>
	</div>
</div>
<script>
var ROOT = "{to_root}";
{SEARCH_SCRIPT}
</script>
</body>
</html>
"""


def classify_modules(by_module, item_meta, module_kinds):
	"""Split `by_module`'s names into the sidebar's curated groups plus the
	Modules catch-all, in display order. Shared between the sidebar and the
	index page's stat row so the two counts can't drift apart."""
	module_kinds = module_kinds or {}
	groups = [
		("Items", sorted(name for name in (item_meta or {}) if name in by_module)),
		("Metatables", sorted(module_kinds.get("metatables", ()))),
		("Panels", sorted(module_kinds.get("panels", ()))),
	]
	grouped = {name for _, names in groups for name in names}
	groups.append(("Modules", [name for name in sorted(by_module) if name not in grouped]))
	return groups


def render_sidebar(by_module, topics, current_module=None, contents=None, to_root="", item_meta=None,
		current_topic=None, module_kinds=None):
	module_kinds = module_kinds or {}
	# The site title now lives in the page header (it's on every page, sidebar
	# included, so it doesn't need repeating here too), leaving the sidebar to
	# start with the thing you actually reach for first.
	out = [SEARCH_BOX]

	if contents:
		# One wrapper, one flex child: #navigation's own `gap` sits *between*
		# direct children, so a bare header + bare list (two children) got the
		# same gap as between whole sections. Every `.ll-nav-group` avoids this
		# by living inside a single <details>; this gets the same treatment
		# without being collapsible.
		out.append('<div class="ll-contents-block">'
			'<div class="ll-kind-header"><h2>Contents</h2></div>'
			'<ul class="ll-kind-body nowrap">')
		for anchor, label in contents:
			out.append(f'<li><a href="#{html.escape(anchor)}">{html.escape(label)}</a></li>')
		out.append("</ul></div>")

	def render_folder(section):
		# A folder only unfolds while you're inside it, so the Topics list stays
		# the same length from everywhere else. Nesting means every ancestor of
		# the current page unfolds, and nothing else does.
		open_here = current_topic is not None and current_topic.startswith(section["folder"] + "/")
		classes = "ll-topic-folder is-open" if open_here else "ll-topic-folder"
		index_id = section["index"]["id"]
		label = html.escape(section["label"])
		entry = (f"<strong>{label}</strong>" if current_topic == index_id
			else f'<a href="{to_root}topics/{index_id}.html">{label}</a>')
		out.append(f'<li class="{classes}">{entry}')
		if open_here:
			out.append('<ul class="ll-topic-children">')
			for topic in section["children"]:
				out.append(topic_nav_item(topic, to_root, current_topic))
			for sub in section["subfolders"]:
				render_folder(sub)
			out.append("</ul>")
		out.append("</li>")

	loose, sections = topic_sections(topics)
	if loose or sections:
		out.append('<details class="ll-nav-group" open><summary>'
			f'<div class="ll-kind-header"><h2>Topics</h2></div>'
			f'<span class="ll-count">{len(topics)}</span></summary>')
		out.append('<ul class="ll-kind-body">')
		for topic in loose:
			out.append(topic_nav_item(topic, to_root, current_topic))
		for section in sections:
			render_folder(section)
		out.append("</ul></details>")

	def render_nav_list(names):
		out.append('<ul class="ll-kind-body nowrap">')
		for module_name in names:
			label = html.escape(module_name)
			if module_name == current_module:
				out.append(f"<li><strong>{label}</strong></li>")
			else:
				href = html.escape(f"{to_root}modules/{page_filename(module_name)}")
				out.append(f'<li><a href="{href}">{label}</a></li>')
		out.append("</ul>")

	# Small curated groups first; Modules is the long tail everything else
	# falls into.
	for heading, names in classify_modules(by_module, item_meta, module_kinds):
		if not names:
			continue
		out.append('<details class="ll-nav-group" open><summary>'
			f'<div class="ll-kind-header"><h2>{heading}</h2></div>'
			f'<span class="ll-count">{len(names)}</span></summary>')
		render_nav_list(names)
		out.append("</details>")

	out.append('<div class="ll-sidebar-footer">'
		'<p>Generated from LuaLS documentation JSON.</p>'
		'<p>Theme by <a href="https://limelightgaming.info">Limelight Gaming</a>.</p>'
		'</div>')
	return "\n".join(out)


def render_start_here_card(topic):
	blurb = topic["meta"].get("description") or first_sentence(topic["html"])
	body = f"<p>{html.escape(blurb)}</p>" if blurb else ""
	return (f'<a class="ll-start-card" href="topics/{topic["id"]}.html">'
		f'<div class="ll-start-card-title">{html.escape(topic["title"])}</div>{body}</a>')


ARROW_ICON = ('<svg class="ll-row-arrow" viewBox="0 0 24 24" role="img" aria-hidden="true">'
	'<path d="M8.59 16.59 13.17 12 8.59 7.41 10 6l6 6-6 6z"/></svg>')


def render_important_topic_row(topic):
	return (f'<a class="ll-important-row" href="topics/{topic["id"]}.html">'
		f'<span class="ll-important-title">{html.escape(topic["title"])}</span>'
		'<span class="ll-important-kind">Topic</span>'
		f'{ARROW_ICON}</a>')


def render_index(by_module, topics, item_meta=None, module_kinds=None):
	groups = classify_modules(by_module, item_meta, module_kinds)
	stats = [("Topics", len(topics))] + [(heading, len(names)) for heading, names in groups]

	content = ['<div class="ll-hero">'
		'<p class="ll-eyebrow">Garry’s Mod</p>'
		"<h1>Photon Lighting Engine</h1>"
		"<p class=\"ll-hero-sub\">Browse the modules in the sidebar to view documented functions and tables.</p>"
		"</div>"]

	content.append('<div class="ll-stat-row">' + "".join(
		f'<div class="ll-stat"><span class="ll-stat-value">{count}</span>'
		f'<span class="ll-stat-label">{html.escape(label)}</span></div>'
		for label, count in stats) + "</div>")

	# Top-level pinned topics only: a pinned folder index (e.g. Design Docs) is
	# a section landing page, not a single-page primer worth a "Start Here" card.
	pinned = [t for t in topics if "/" not in t["id"] and is_pinned(t)]
	if pinned:
		content.append('<div class="ll-index-section"><h2>Start Here</h2>'
			'<div class="ll-start-grid">' + "".join(render_start_here_card(t) for t in pinned) + "</div></div>")

	# `featured: true` in front matter, independent of `pinned` — pinned only
	# controls the sidebar; this is what surfaces a topic here regardless of
	# where it lives in the tree.
	featured = [t for t in topics if is_featured(t)]
	if featured:
		content.append('<div class="ll-index-section"><h2>Important Topics</h2>'
			'<div class="ll-important-list">' + "".join(render_important_topic_row(t) for t in featured) + "</div></div>")

	sidebar = render_sidebar(by_module, topics, item_meta=item_meta, module_kinds=module_kinds)
	return render_page_shell("Photon Documentation", sidebar, "\n".join(content))


# Each row is exactly three cells — label, type, description — so the list can
# lay them out as aligned columns. The description is wrapped rather than left
# as a bare text node so a multi-block description can't split into two cells
# and shear the row.
def render_arg_row(label, type_html, desc_html):
	return (f"<li>{label}"
		+ f'<span class="types">{type_html}</span>'
		+ f'<span class="ll-arg-desc">{desc_html}</span>'
		+ "</li>")


def render_params(params, type_links=None):
	if not params:
		return ""
	out = ['<p class="ll-arg-label">Parameters</p>', '<ul class="ll-args-list">']
	for param in params:
		name = html.escape(param.get("name", ""))
		# `view` holds the resolved type name; `type` is LuaLS's internal
		# declaration kind (e.g. "local"/"self") and isn't useful to show.
		ptype = linkify_type(str(param.get("view") or param.get("type") or ""), type_links or {})
		desc = linkify_symbols(render_markdown_inline(param.get("desc") or ""), type_links or {})
		out.append(render_arg_row(f'<span class="parameter">{name}</span>', ptype, desc))
	out.append("</ul>")
	return "\n".join(out)


def render_example(tags):
	"""`@example` — a labelled code block showing how to call the thing.

	Deliberately not accepting `@usage`, the LDoc spelling: `standards-diff.py`
	rejects it as an LDoc tag, so supporting it here would mean the docs
	rendering something CI refuses to let anyone write. A fenced ```lua block in
	the description still works and stays where the author put it in the prose;
	this is for the canonical one-liner that belongs at the end."""
	blocks = tags.get("example") or []
	out = []
	for block in blocks:
		# Continuation lines carry the comment's own indentation; the first line
		# came off the tag and has none. Dedent against the continuations so
		# indentation inside the example survives but the comment's doesn't.
		lines = block.strip("\n").splitlines()
		body = "\n".join(lines[:1] + [textwrap.dedent("\n".join(lines[1:]))]).strip()
		if body:
			out.append(f'<pre class="ll-example"><code>{html.escape(body)}</code></pre>')
	if not out:
		return ""
	return '<p class="ll-arg-label">Example</p>' + "".join(out)


def render_returns(returns, type_links=None):
	if not returns:
		return ""
	out = ['<p class="ll-arg-label">Returns</p>', '<ol class="ll-args-list">']
	for index, ret in enumerate(returns, start=1):
		rtype = linkify_type(str(ret.get("view") or ret.get("type") or ""), type_links or {})
		desc = linkify_symbols(render_markdown_inline(ret.get("desc") or ""), type_links or {})
		# The ordinal is written out rather than left to the <ol> marker: a grid
		# row needs it as a real cell, and returns past the first are only
		# meaningful in order.
		ordinal = f'<span class="ll-ordinal">{index}</span>' if len(returns) > 1 else '<span></span>'
		out.append(render_arg_row(ordinal, rtype, desc))
	out.append("</ol>")
	return "\n".join(out)


def render_item_meta(meta, module_name, by_module):
	"""The identity block at the top of an item page: what the base is
	registered as, and what it inherits from. The chain is what tells you
	which setters are actually reachable, since a base's own page only lists
	what it declares itself."""
	rows = []

	ids = meta.get("uniqueids") or []
	if ids:
		label = "Registration IDs" if len(ids) > 1 else "Registration ID"
		rendered = ", ".join(f'<code class="tag-uniqueid">{html.escape(i)}</code>' for i in ids)
		rows.append(f"<dt>{label}</dt><dd>{rendered}</dd>")

	chain = list(meta.get("chain") or []) + [module_name]
	links = []
	for name in chain:
		safe = html.escape(name)
		if name == module_name:
			links.append(f"<strong>{safe}</strong>")
		elif name in by_module:
			links.append(f'<a href="{html.escape(page_filename(name))}">{safe}</a>')
		else:
			links.append(safe)
	if len(links) > 1:
		rows.append("<dt>Inherits</dt><dd>" + " &rarr; ".join(links) + "</dd>")

	if not rows:
		return ""
	return '<div class="ll-module-body"><dl class="ll-item-meta">' + "".join(rows) + "</dl></div>"


def render_alias_values(members):
	"""The accepted values of a type-union `@alias` - what LuaLS would
	otherwise leave as a bare ```lua fence on the page."""
	if not members:
		return ""
	out = ["<h3>Accepted values:</h3>", "<ul>"]
	for view in members:
		out.append(f"<li><code>{html.escape(view.strip('`'))}</code></li>")
	out.append("</ul>")
	return "\n".join(out)


def render_entries(items, header_tags, repo_url, repo_ref, module_name, meta, sort=True, type_links=None):
	"""The `<dt>`/`<dd>` pairs for a run of items, grouped under their
	`@section` headers."""
	out = []
	for section in group_by_section(items, sort=sort):
		if section["title"]:
			out.append(f'<h3 class="section-header">{html.escape(section["title"])}</h3>')

		for item in section["items"]:
			states = resolve_states(item["own_tags"], header_tags, item["file"])
			link = source_link(repo_url, repo_ref, item["file"], item["start"])
			source_ref = f'<a style="float:right;" href="{html.escape(link)}">Source ☍</a>' if link else ""
			display = item_display_name(item["name"], module_name) if meta else item["name"]
			out.append("<dt>"
				f'<a name="{html.escape(item["name"])}"></a>'
				f"{render_realm_badge(states)}"
				f'<strong class="ll-symbol">{render_signature(display, item, type_links)}</strong>'
				f"{source_ref}"
				"</dt>")
			out.append("<dd>")
			if item["desc"]:
				out.append(linkify_symbols(render_markdown(item["desc"]), type_links or {}))
			out.append(render_callout_tags(item["tags"], type_links))
			out.append(render_params(item["params"], type_links))
			out.append(render_returns(item["returns"], type_links))
			out.append(render_example(item["own_tags"]))
			if item.get("alias"):
				out.append(render_alias_values(item["alias"]["members"]))
			out.append("</dd>")
	return out


def render_class_family(family, header_tags, repo_url, repo_ref, module_name, meta, type_links=None):
	"""A `@class` and its members, as a section of the page in its own right.

	Members are grouped by kind under the class the same way the page groups
	its own, so a builder's methods read as a chain rather than interleaving
	with its stored fields."""
	item = family["item"]
	link = source_link(repo_url, repo_ref, item["file"], item["start"])
	by_kind = {}
	for member in family["members"]:
		by_kind.setdefault(member["kind"], []).append(member)
	kinds_present = [k for k in KIND_ORDER if k in by_kind]
	chip = " &middot; ".join(f"{len(by_kind[kind])} {kind.lower()}" for kind in kinds_present)
	if link:
		chip += f' <a href="{html.escape(link)}">Source ☍</a>'

	out = ['<div class="ll-module-header">'
		f'<h2 class="section-header"><a name="{html.escape(family["name"])}"></a>'
		f'{html.escape(family["name"])}</h2>'
		f'<span class="ll-family-meta">{chip}</span></div>',
		'<div class="ll-module-body">']
	if family["desc"]:
		out.append(linkify_symbols(render_markdown(family["desc"]), type_links or {}))
	out.append(render_callout_tags(item["tags"], type_links))
	for kind in kinds_present:
		# Only worth naming when there is something to tell apart; a class of
		# nothing but methods reads better without a lone "Functions" above them.
		if len(kinds_present) > 1:
			out.append(f'<h3 class="section-header">{kind}</h3>')
		out.append('<dl class="function">')
		out.extend(render_entries(by_kind[kind], header_tags, repo_url, repo_ref, module_name, meta,
			type_links=type_links))
		out.append("</dl>")
	out.append("</div>")
	return out


def common_symbol_prefix(names):
	"""The `COL_`/`Photon.SNet.` a family's constants all start with, or "" if
	they share no whole name part. Taken from the names themselves rather than
	from the alias's: `COL` does prefix its `COL_*` constants, but an alias
	naming a type (`PhotonNetType` over `Photon.SNet.BOOL`) prefixes nothing,
	and `PhotonNetType_*` would then name a family of constants that don't
	exist."""
	if not names:
		return ""
	shortest = min(names, key=len)
	common = ""
	for index, char in enumerate(shortest):
		if any(name[index] != char for name in names):
			break
		common += char
	boundary = max(common.rfind("_"), common.rfind("."))
	return common[:boundary + 1] if boundary != -1 else ""


def render_enum_family(family, header_tags, repo_url, repo_ref, module_name, meta, type_links=None):
	"""An `@alias` and the constants it names, as a section of the page in
	its own right: the alias is the header the constants sit under rather
	than one more entry alphabetically adjacent to them."""
	link = source_link(repo_url, repo_ref, family["item"]["file"], family["item"]["start"])
	shared = common_symbol_prefix([member["name"] for member in family["members"]])
	prefix = f"{shared}*" if shared and family["title"] != family["name"] else ""
	chip = " &middot; ".join(part for part in (prefix, f'{len(family["members"])} values') if part)
	if link:
		chip += f' <a href="{html.escape(link)}">Source ☍</a>'

	out = ['<div class="ll-module-header">'
		f'<h2 class="section-header"><a name="{html.escape(family["name"])}"></a>'
		f'{html.escape(family["title"])}</h2>'
		f'<span class="ll-family-meta">{chip}</span></div>',
		'<div class="ll-module-body">']
	if family["desc"]:
		out.append(render_markdown(family["desc"]))
	out.append('<dl class="function">')
	out.extend(render_entries(family["members"], header_tags, repo_url, repo_ref, module_name, meta, type_links=type_links,
		sort=False))
	out.append("</dl></div>")
	return out


def render_module_page(module_name, items, by_module, topics, repo_url, repo_ref, description=None,
		item_meta=None, module_kinds=None, type_links=None):
	header_tags = module_header_tags(items)
	meta = (item_meta or {}).get(module_name)
	families = collect_enum_families(items)
	# After the enum families, which have first claim on any member they share.
	classes = collect_class_families(items, module_name, by_module)

	by_kind = {}
	for item in items:
		# The class's own entry becomes the page header, so listing it again
		# under Fields would just repeat the description directly above it.
		if meta and item["name"] == module_name:
			continue
		# LuaLS re-parents every inherited field onto the subclass, so without
		# this each base would list the whole ITEM surface plus its siblings'
		# setters - a uniform advertising SetAmmo and SetVehicle. The declaring
		# file is what separates the two; the Inherits chain covers the rest.
		if meta and meta["file"] and item["file"] != meta["file"]:
			continue
		# Gathered into their own section below, not listed here as well.
		if item.get("family") or item.get("class_family"):
			continue
		by_kind.setdefault(item["kind"], []).append(item)
	kinds_present = [k for k in KIND_ORDER if k in by_kind]

	content = [f'<div class="ll-module-header"><h1>{html.escape(module_name)}</h1></div>']
	if meta and meta["desc"]:
		description = meta["desc"]
	footnotes = None
	if description:
		description_html, footnotes = extract_footnotes(render_markdown(description))
		content.append(f'<div class="ll-module-body">{description_html}</div>')
	if meta:
		content.append(render_item_meta(meta, module_name, by_module))

	for kind in kinds_present:
		content.append(f'<div class="ll-module-header"><h2 class="section-header"><a name="{kind}"></a>{kind}</h2></div>')
		content.append('<div class="ll-module-body"><dl class="function">')
		content.extend(render_entries(by_kind[kind], header_tags, repo_url, repo_ref, module_name, meta, type_links=type_links))
		content.append("</dl></div>")

	for family in classes:
		content.extend(render_class_family(family, header_tags, repo_url, repo_ref, module_name, meta, type_links))

	for family in families:
		content.extend(render_enum_family(family, header_tags, repo_url, repo_ref, module_name, meta, type_links))

	# Pulled out from wherever inside the description it happened to land
	# (wherever the last `[^N]` reference was) and put last: footnotes are
	# reference material, not part of the description you read first.
	if footnotes:
		content.append('<div class="ll-module-header"><h2 class="section-header"><a name="Footnotes"></a>Footnotes</h2></div>')
		content.append(f'<div class="ll-module-body">{footnotes}</div>')

	contents = [(kind, kind) for kind in kinds_present]
	contents += [(family["name"], family["name"]) for family in classes]
	contents += [(family["name"], family["title"]) for family in families]
	if footnotes:
		contents.append(("Footnotes", "Footnotes"))
	sidebar = render_sidebar(by_module, topics, current_module=module_name, contents=contents,
		to_root="../", item_meta=item_meta, module_kinds=module_kinds)
	return render_page_shell(module_name, sidebar, "\n".join(content), to_root="../")


HEADING_RE = re.compile(r"<h([1-6])>(.*?)</h\1>", re.DOTALL)
LEADING_H1_RE = re.compile(r"\A<h1>.*?</h1>\s*", re.DOTALL)
TAG_RE = re.compile(r"<[^>]+>")
HREF_RE = re.compile(r'href="([^"]*)"')
ESCAPES_ROOT_RE = re.compile(r"^(?:\.\./)+")
FRONT_MATTER_RE = re.compile(r"\A---\r?\n(.*?)\r?\n---[ \t]*(?:\r?\n|\Z)", re.DOTALL)
# Columns a folder index lists, in order. Anything else in the front matter is
# carried into api.json but not tabulated - the index is a summary, not a dump.
FRONT_MATTER_COLUMNS = (("status", "Status"), ("date", "Date"), ("description", "Description"))
FRONT_MATTER_TRUE = frozenset(("true", "yes", "y", "1", "on"))
# Inline rather than an emoji: this inherits the row's own colour through
# `fill: currentColor`, where 📌 renders in whatever red the platform's emoji
# font picks and fights the navy links around it.
PIN_ICON = ('<svg class="ll-pin" viewBox="0 0 24 24" role="img"><title>Pinned</title>'
	'<path d="M16 9V4h1c.55 0 1-.45 1-1s-.45-1-1-1H7c-.55 0-1 .45-1 1s.45 1 1 1h1v5c0 1.66-1.34 3-3 3'
	'v2h5.97v7l1 1 1-1v-7H19v-2c-1.66 0-3-1.34-3-3z"/></svg>')


def split_front_matter(text):
	"""Pull a leading `---` front-matter block off a topic file, returning
	(fields, remaining markdown). Deliberately not YAML — these are flat
	`key: value` lines, and parsing them here avoids putting a YAML dependency
	in front of every docs build. A malformed block is left in the markdown
	rather than silently swallowed."""
	match = FRONT_MATTER_RE.match(text)
	if not match:
		return {}, text
	fields = {}
	for line in match.group(1).splitlines():
		line = line.strip()
		if not line or line.startswith("#"):
			continue
		key, separator, value = line.partition(":")
		if not separator:
			return {}, text
		fields[key.strip().lower()] = value.strip().strip("'\"")
	return fields, text[match.end():]


def heading_anchors(html_text):
	"""Give topic headings GitHub-compatible `id`s, so the `page.md#a-heading`
	links written for reading the markdown on GitHub land in the right place on
	the site too. Same slug rules GitHub uses: lowercase, drop everything that
	isn't a word character/space/hyphen, spaces to hyphens, then `-1`, `-2`, …
	for repeats."""
	seen = {}

	def replace(match):
		level, inner = match.group(1), match.group(2)
		text = html.unescape(TAG_RE.sub("", inner)).lower()
		slug = re.sub(r"[^\w\- ]+", "", text).strip().replace(" ", "-")
		if not slug:
			return match.group(0)
		repeats = seen.get(slug, 0)
		seen[slug] = repeats + 1
		anchor = slug if not repeats else f"{slug}-{repeats}"
		return f'<h{level} id="{anchor}">{inner}</h{level}>'

	return HEADING_RE.sub(replace, html_text)


def strip_leading_heading(html_text):
	"""Drop a topic's opening `<h1>`. `render_topic_page` already puts the title
	in the page's header bar, so leaving it in would print the title twice —
	but the markdown still needs it for reading the file on GitHub. Only the
	first, and only when the page opens with it: an `<h1>` further down is a
	real section heading."""
	return LEADING_H1_RE.sub("", html_text, count=1)


def rewrite_topic_links(html_text, folder, topic_ids, repo_blob_url=None):
	"""Repoint a topic's relative links so they work from the published site.

	`topics/` mirrors the source tree, so a link to another topic is already on
	the right relative path and only the extension changes. A link that escapes
	the docs root — `../README.md`, `../../lua/…/sh_simplenet.lua` — has no page to
	point at, because only `docs/` is published; those go to the repo browser
	instead of 404ing. Absolute URLs and bare anchors are left alone."""
	def replace(match):
		href = match.group(1)
		target, separator, anchor = href.partition("#")
		if not target or target.startswith("/") or "://" in target:
			return match.group(0)
		resolved = posixpath.normpath(posixpath.join(folder, target))
		if target.endswith(".md") and resolved[:-len(".md")] in topic_ids:
			return f'href="{target[:-len(".md")]}.html{separator}{anchor}"'
		if repo_blob_url and resolved.startswith("../"):
			# normpath keeps a leading `../` per level above the docs root, and
			# docs/ sits at the repo root — so dropping them gives the repo path.
			# Trimmed by segment, not by character: `../.cursor/…` must keep its dot.
			return f'href="{repo_blob_url}/{ESCAPES_ROOT_RE.sub("", resolved)}{separator}{anchor}"'
		return match.group(0)

	return HREF_RE.sub(replace, html_text)


def load_topics(topics_dir, repo_blob_url=None):
	"""Every markdown file under `topics_dir`, including subfolders. A topic's
	folder becomes its own sidebar section and its own subdirectory under
	`topics/`, so `docs/design/x.md` publishes to `topics/design/x.html`."""
	topics = []
	if not topics_dir or not topics_dir.exists():
		return topics
	for md_file in sorted(topics_dir.rglob("*.md")):
		rel = md_file.relative_to(topics_dir).as_posix()
		meta, content = split_front_matter(md_file.read_text(encoding="utf-8"))
		title = meta.get("title") or md_file.stem.replace("_", " ").title()
		if not meta.get("title"):
			for line in content.splitlines():
				if line.strip().startswith("#"):
					title = line.strip().lstrip("#").strip()
					break
		topics.append({
			"id": rel[:-len(".md")],
			"path": rel,
			"folder": posixpath.dirname(rel),
			"title": title,
			"meta": meta,
			"body": content,
		})
	# Rendered last so cross-topic links can be resolved against the full set.
	topic_ids = {topic["id"] for topic in topics}
	for topic in topics:
		topic["html"] = rewrite_topic_links(
			heading_anchors(strip_leading_heading(render_markdown(topic["body"]))),
			topic["folder"], topic_ids, repo_blob_url)
	return topics


def topic_folder_label(folder):
	"""Fallback sidebar label for a folder with no `index.md` of its own:
	`design/car-boosting` becomes "Car Boosting". Only the leaf — a folder is
	always shown nested under its parent, which supplies the rest."""
	return folder.rsplit("/", 1)[-1].replace("-", " ").replace("_", " ").title()


def is_pinned(topic):
	return topic["meta"].get("pinned", "").strip().lower() in FRONT_MATTER_TRUE


def is_featured(topic):
	"""`featured: true` — pulls a topic into the index page's "Important
	Topics" list. Deliberately separate from `pinned`, which only affects
	sidebar ordering/the pin icon: a topic can want one, the other, or both."""
	return topic["meta"].get("featured", "").strip().lower() in FRONT_MATTER_TRUE


def is_index_page(topic):
	"""`index: true` promotes a page to be its folder's landing page: the folder's
	sidebar entry points at it, it drops out of the folder's own list, and its
	content stands in for the generated listing."""
	return topic["meta"].get("index", "").strip().lower() in FRONT_MATTER_TRUE


def matches_folder_name(topic):
	"""`design/car-boosting/car-boosting.md` — a doc named after the folder it
	sits in is that folder's overview by convention, and gets promoted the same
	way, but only when nothing more explicit has claimed the spot."""
	folder, _, name = topic["id"].rpartition("/")
	return bool(folder) and name == folder.rsplit("/", 1)[-1]


def order_topics(topics):
	"""Pinned topics first, everything else in the order it loaded (by
	filename). `sorted` is stable, so this only lifts the pins out — it doesn't
	reshuffle anything below them."""
	return sorted(topics, key=lambda topic: not is_pinned(topic))


def topic_sections(topics):
	"""Split the topic set into the loose top-level files and a section per
	subfolder, nested to whatever depth the folders go. Each section gets an
	index page — the folder's own `index.md` where it has one, otherwise a
	generated list — which is what its sidebar entry links to."""
	by_folder = {}
	folders = set()
	for topic in topics:
		by_folder.setdefault(topic["folder"], []).append(topic)
		parts = topic["folder"].split("/") if topic["folder"] else []
		# Every ancestor too, so a folder holding nothing but subfolders still
		# gets a node to hang them off.
		folders.update("/".join(parts[:depth]) for depth in range(1, len(parts) + 1))

	def subfolders_of(parent):
		prefix = f"{parent}/" if parent else ""
		return sorted(folder for folder in folders
			if folder.startswith(prefix) and "/" not in folder[len(prefix):])

	def build(folder):
		entries = by_folder.get(folder, [])
		# Precedence for the folder's landing page, most deliberate first: an
		# explicit `index: true`, then an `index.md`, then a doc named after the
		# folder itself.
		explicit = next((t for t in entries if is_index_page(t)), None)
		authored = next((t for t in entries if t["id"] == f"{folder}/index"), None)
		named = next((t for t in entries if matches_folder_name(t)), None)
		promoted = explicit or (None if authored else named)
		chosen = promoted or authored
		children = order_topics([t for t in entries if t is not chosen])
		subfolders = [build(sub) for sub in subfolders_of(folder)]
		return {
			"folder": folder,
			"label": chosen["title"] if chosen else topic_folder_label(folder),
			"children": children,
			"subfolders": subfolders,
			"index": (promoted_index_page(promoted, subfolders) if promoted
				else folder_index_page(folder, authored, children, subfolders)),
		}

	return order_topics(by_folder.get("", [])), [build(f) for f in subfolders_of("")]


def folder_index_listing(entries):
	"""A table of `(topic, href)` pairs for a folder index. Front matter decides
	the shape — one column per field something in the list actually sets, so a
	list that only fills in `status` doesn't get three empty columns, and one
	with no front matter at all stays a plain list of links."""
	def link(topic, href):
		pin = PIN_ICON if is_pinned(topic) else ""
		return f'{pin}<a href="{href}">{html.escape(topic["title"])}</a>'

	columns = [(key, label) for key, label in FRONT_MATTER_COLUMNS
		if any(topic["meta"].get(key) for topic, _ in entries)]
	if not columns:
		return "<ul>" + "".join(f"<li>{link(topic, href)}</li>" for topic, href in entries) + "</ul>"

	head = "".join(f"<th>{label}</th>" for label in ["Doc"] + [label for _, label in columns])
	rows = "".join(
		f"<tr><td>{link(topic, href)}</td>"
		+ "".join(f'<td>{html.escape(topic["meta"].get(key, ""))}</td>' for key, _ in columns)
		+ "</tr>"
		for topic, href in entries)
	return f"<table><thead><tr>{head}</tr></thead><tbody>{rows}</tbody></table>"


def child_entries(children):
	return [(topic, f'{topic["id"].rsplit("/", 1)[-1]}.html') for topic in children]


def folder_index_sections(folder, subfolders):
	"""Links from a folder's index down into its subfolders. Without these a
	nested folder would be reachable only from the sidebar, and only while
	already expanded. Rendered by the same listing as the folder's own docs, so
	a subfolder's description shows up the way a doc's does. Goes via each
	subfolder's own index id rather than assuming `index.html` — a promoted
	index keeps its own filename."""
	entries = [(section["index"], f'{section["index"]["id"][len(folder) + 1:]}.html')
		for section in subfolders]
	return "<h2>Sections</h2>" + folder_index_listing(entries)


def promoted_index_page(promoted, subfolders):
	"""An `index: true` page standing in for the generated index. It keeps its
	own URL — inbound links to it still work — and its content replaces the
	listing rather than being prefixed to it. Subfolder links are still appended,
	so promoting a page can't orphan a folder nested below it."""
	if not subfolders:
		return promoted
	return dict(promoted, html=promoted["html"] + folder_index_sections(promoted["folder"], subfolders))


def folder_index_page(folder, authored, children, subfolders):
	"""A folder's landing page: its own `index.md` if it wrote one, then the
	generated list of everything else in the folder. This is the only place
	those pages are listed when you aren't already inside the folder, so the
	list is never hand-maintained."""
	return {
		"id": f"{folder}/index",
		"folder": folder,
		"meta": authored["meta"] if authored else {},
		"title": authored["title"] if authored else topic_folder_label(folder),
		"html": (authored["html"] if authored else "")
			+ (folder_index_listing(child_entries(children)) if children else "")
			+ (folder_index_sections(folder, subfolders) if subfolders else ""),
	}


def topic_pages(topics):
	"""Every page to write under `topics/`: the loose files, then each folder's
	index page and its children. A folder's own `index.md` is folded into the
	generated index page rather than written twice."""
	loose, sections = topic_sections(topics)
	pages = list(loose)

	def collect(section):
		pages.append(section["index"])
		pages.extend(section["children"])
		for sub in section["subfolders"]:
			collect(sub)

	for section in sections:
		collect(section)
	return pages


def topic_nav_item(topic, to_root, current_topic):
	# Inside the link, and after the title: the row is a flex container, so a
	# sibling would wrap onto its own line, and `#navigation li`'s -1em hanging
	# indent drags the title back over anything sitting in front of it.
	label = html.escape(topic["title"]) + (PIN_ICON if is_pinned(topic) else "")
	if topic["id"] == current_topic:
		return f"<li><strong>{label}</strong></li>"
	return f'<li><a href="{to_root}topics/{topic["id"]}.html">{label}</a></li>'


TOPIC_CONTENTS_RE = re.compile(r'<h2 id="([^"]+)">(.*?)</h2>', re.DOTALL)


def topic_contents(html_text):
	"""The topic's own `##` headings, for the sidebar's Contents block. Only
	`h2` — an `h3` list on a long page is longer than the page's own sidebar
	and stops being navigation. Two entries aren't worth a block."""
	entries = [(anchor, html.unescape(TAG_RE.sub("", inner)).strip())
		for anchor, inner in TOPIC_CONTENTS_RE.findall(html_text)]
	return entries if len(entries) > 2 else []


def render_topic_page(topic, by_module, topics, item_meta=None, module_kinds=None):
	to_root = "../" * (topic["id"].count("/") + 1)
	content = f'<div class="ll-module-header"><h1>{html.escape(topic["title"])}</h1></div><div class="ll-module-body">{topic["html"]}</div>'
	sidebar = render_sidebar(by_module, topics, to_root=to_root, item_meta=item_meta,
		current_topic=topic["id"], contents=topic_contents(topic["html"]), module_kinds=module_kinds)
	return render_page_shell(topic["title"], sidebar, content, to_root=to_root)


# --- Machine-readable index (MCP / llms.txt) ---------------------------------
#
# Written alongside the HTML so the existing docs deploy jobs pick it up
# without a workflow change. The HTML path above is intentionally untouched.


def _type_name(entry):
	view = entry.get("view") or entry.get("type") or ""
	if isinstance(view, dict):
		return str(view.get("view") or view.get("type") or "")
	return str(view)


def serialize_symbol(item, header_tags):
	tags = item["tags"]
	deprecated = None
	if "deprecated" in tags:
		deprecated = tags["deprecated"][0] or DEPRECATED_DEFAULT
	return {
		"name": item["name"],
		"kind": item["kind"],
		"module": item["module"],
		"file": item["file"],
		"states": sorted(resolve_states(item["own_tags"], header_tags, item["file"])),
		"desc": item["desc"] or "",
		"params": [
			{"name": p.get("name") or "", "type": _type_name(p), "desc": p.get("desc") or ""}
			for p in item["params"]
		],
		"returns": [
			{"type": _type_name(r), "desc": r.get("desc") or ""}
			for r in item["returns"]
		],
		"deprecated": deprecated,
		"internal": "internal" in tags,
		"warns": tags.get("warns") or [],
		"bugs": tags.get("bugs") or [],
		"uniqueids": tags.get("uniqueid") or [],
		"section": section_title((tags.get("section") or [None])[0]) or None,
		"family": item.get("family"),
		"members": item["alias"]["members"] if item.get("alias") else [],
	}


def build_api_index(by_module, descriptions, topics):
	modules = []
	for name in sorted(by_module):
		items = by_module[name]
		header_tags = module_header_tags(items)
		collect_enum_families(items)
		symbols = [serialize_symbol(item, header_tags) for item in items]
		symbols.sort(key=lambda s: natural_sort_key(s["name"]))
		modules.append({
			"name": name,
			"description": descriptions.get(name) or "",
			"symbols": symbols,
		})
	return {
		"version": 1,
		"generated": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
		"modules": modules,
		# Deliberately not the rendered `html`, which the consumers don't use
		# and which would roughly double the file. `body` is the markdown with
		# any front matter lifted out of it into `meta`.
		"topics": [{key: topic[key] for key in ("id", "title", "path", "meta", "body")}
			for topic in topics],
	}


def write_llms_txt(output_dir, by_module, topics, site_url=""):
	"""`site_url` is where the built site is published. Left empty, every link
	is written relative to llms.txt's own directory, which still resolves for a
	reader who fetched the whole build - it is only an absolute URL that has to
	be told what the site is called."""
	base = f"{site_url.rstrip('/')}/" if site_url else ""
	lines = [
		"# Photon",
		"",
		"> Public API documentation for the Photon lighting engine, generated from LuaCATS comments. "
		"Treat this as the source of truth for Photon APIs; do not invent functions.",
		"",
		f"Machine-readable index: {base}api.json",
		"",
		"## Modules",
		"",
	]
	for name in sorted(by_module):
		lines.append(f"- [{name}]({base}modules/{page_filename(name)})")
	def entries(topics_):
		return [f"- [{topic['title']}]({base}topics/{topic['id']}.html)"
			for topic in topics_]

	def write_section(section, trail):
		# Nesting is flattened to a heading path — llms.txt has no tree, and the
		# trail is what tells a reader design/clans from a top-level clans.
		heading = " / ".join(trail + [section["label"]])
		lines.extend(["", f"## {heading}", ""])
		lines.extend(entries([section["index"]] + section["children"]))
		for sub in section["subfolders"]:
			write_section(sub, trail + [section["label"]])

	loose, sections = topic_sections(topics)
	if loose:
		lines.extend(["", "## Topics", ""])
		lines.extend(entries(loose))
	for section in sections:
		write_section(section, [])
	(output_dir / "llms.txt").write_text("\n".join(lines) + "\n", encoding="utf-8")


def build_search_index(by_module, topics, item_meta=None, module_kinds=None):
	"""Everything the sidebar search box can jump to, as one flat list of
	`{n: name, u: url, k: kind, d: description}`.

	Names and one-line descriptions only — indexing full topic bodies would
	multiply the file the browser has to pull on first keystroke, and the thing
	you nearly always want is the page a symbol lives on."""
	kinds = module_kinds or {}
	entries = []
	for topic in topics:
		entries.append({"n": topic["title"], "u": f'topics/{topic["id"]}.html', "k": "topic",
			"d": topic["meta"].get("description", "")})
	for name in sorted(by_module):
		if name in (item_meta or {}):
			kind = "item"
		elif name in kinds.get("metatables", ()):
			kind = "metatable"
		elif name in kinds.get("panels", ()):
			kind = "panel"
		else:
			kind = "module"
		page = page_filename(name)
		entries.append({"n": name, "u": f"modules/{page}", "k": kind, "d": ""})
		for item in by_module[name]:
			if item["name"] == name:
				continue
			entries.append({"n": item["name"], "u": f'modules/{page}#{item["name"]}',
				"k": KIND_SINGULAR.get(item.get("kind"), "symbol"),
				"d": first_sentence(item.get("desc") or "")})
	return entries


def first_sentence(text):
	line = TAG_RE.sub("", text).strip().splitlines()[0] if text.strip() else ""
	return line[:140]


def concatenated_style(style_dir):
	"""Concatenate style_dir's *.css files. base.css goes first, since it
	defines the #navigation/#content layout that the theme files only
	override."""
	base_css = style_dir / "base.css"
	css_files = ([base_css] if base_css.exists() else []) + sorted(
		p for p in style_dir.glob("*.css") if p != base_css
	)
	return "\n".join(p.read_text(encoding="utf-8") for p in css_files)


# --- Entry point --------------------------------------------------------------

def main():
	global STYLE_FILENAME, REPO_URL
	parser = argparse.ArgumentParser(description=__doc__)
	parser.add_argument("--json", required=True, help="Path to the lua-language-server --doc JSON output")
	parser.add_argument("--output", required=True, help="Directory to write the generated HTML site to")
	parser.add_argument("--style", help="Path to a prebuilt style.css to copy into the output")
	parser.add_argument("--style-dir", help="Directory of CSS files to concatenate into style.css "
		"(base.css first, then the rest in name order); mutually exclusive with --style")
	parser.add_argument("--topics", default=None, help="Directory of markdown topic files")
	parser.add_argument("--repo-url", default="https://github.com/photonle/Photon",
		help="Repo URL to link function/table declarations back to their source line (empty string to disable)")
	parser.add_argument("--repo-ref", default="development", help="Branch/tag/commit to link source references against")
	parser.add_argument("--site-url", default="",
		help="Public URL the built site is published at, used to write absolute links in llms.txt "
			"(links stay relative when omitted)")
	parser.add_argument("--source", default=SOURCE_REPO_PATH,
		help="Root directory the documented files are relative to, for the raw file-header scan (empty string to skip it)")
	args = parser.parse_args()
	if bool(args.style) == bool(args.style_dir):
		parser.error("pass exactly one of --style or --style-dir")

	data = json.loads(Path(args.json).read_text(encoding="utf-8"))
	items = flatten_items(data)

	file_headers = {}
	metatable_names = set()
	if args.source:
		files = {item["file"] for item in items if item["file"] != "unknown" and not is_excluded(item["file"])}
		file_headers = scan_file_headers(Path(args.source), files)
		apply_file_headers(items, file_headers)
		metatable_names = scan_metatable_names(Path(args.source), files)
		scan_deprecation_reasons(Path(args.source), items)

	assign_class_modules(items, file_headers, metatable_names)
	item_meta = assign_item_modules(items, file_headers)
	by_module = group_by_module(items)
	descriptions = module_descriptions(by_module, file_headers)
	metatables = metatable_names & set(by_module)
	module_kinds = {
		"metatables": metatables,
		"panels": panel_modules(by_module, metatables | set(item_meta)),
	}
	type_links = add_symbol_links(build_type_links(by_module, scan_glua_classes()), by_module)
	repo_blob_url = f"{args.repo_url.rstrip('/')}/blob/{args.repo_ref}" if args.repo_url else None
	# Set before load_topics(): it renders topic bodies through render_markdown,
	# which is where issue-ref linkification (`#123`, `repo#123`, `org/repo#123`)
	# actually happens.
	REPO_URL = args.repo_url.rstrip("/") if args.repo_url else ""
	topics = load_topics(Path(args.topics), repo_blob_url) if args.topics else []

	output_dir = Path(args.output)
	# Rebuild from clean: a page whose topic was renamed or moved into a folder
	# otherwise survives in the output and looks like it is still published.
	for stale in ("topics", "modules"):
		shutil.rmtree(output_dir / stale, ignore_errors=True)
	output_dir.mkdir(parents=True, exist_ok=True)

	if args.style:
		style_content = Path(args.style).read_text(encoding="utf-8") if Path(args.style).exists() else None
	else:
		style_content = concatenated_style(Path(args.style_dir))

	if style_content is not None:
		for stale in output_dir.glob("style.*css"):
			stale.unlink()
		style_hash = hashlib.sha256(style_content.encode("utf-8")).hexdigest()[:10]
		STYLE_FILENAME = f"style.{style_hash}.css"
		(output_dir / STYLE_FILENAME).write_text(style_content, encoding="utf-8")

	# Static site chrome (logo, texture) referenced by the page shell itself,
	# not generated per-build like the style/search/api files above.
	assets_src = (Path(args.style_dir) if args.style_dir else Path(args.style).parent) / "assets"
	if assets_src.is_dir():
		shutil.rmtree(output_dir / "assets", ignore_errors=True)
		shutil.copytree(assets_src, output_dir / "assets")

	(output_dir / "index.html").write_text(render_index(by_module, topics, item_meta=item_meta, module_kinds=module_kinds), encoding="utf-8")

	# Modules and topics get their own directories so names can't collide
	# with each other (e.g. a hypothetical "environment" module vs. the
	# existing environment.md topic) or with index.html/style.css.
	modules_dir = output_dir / "modules"
	modules_dir.mkdir(exist_ok=True)
	for module_name, module_items in by_module.items():
		html_content = render_module_page(module_name, module_items, by_module, topics, args.repo_url, args.repo_ref,
			description=descriptions.get(module_name), item_meta=item_meta, module_kinds=module_kinds,
			type_links=type_links)
		(modules_dir / page_filename(module_name)).write_text(html_content, encoding="utf-8")

	topics_dir = output_dir / "topics"
	pages = topic_pages(topics)
	for topic in pages:
		page_path = topics_dir / f"{topic['id']}.html"
		page_path.parent.mkdir(parents=True, exist_ok=True)
		page_path.write_text(render_topic_page(topic, by_module, topics, item_meta=item_meta, module_kinds=module_kinds), encoding="utf-8")

	search_index = build_search_index(by_module, topics, item_meta, module_kinds)
	(output_dir / "search.json").write_text(
		json.dumps(search_index, separators=(",", ":"), ensure_ascii=False),
		encoding="utf-8",
	)

	api_index = build_api_index(by_module, descriptions, topics)
	(output_dir / "api.json").write_text(
		json.dumps(api_index, indent=2, ensure_ascii=False) + "\n",
		encoding="utf-8",
	)
	write_llms_txt(output_dir, by_module, topics, args.site_url)

	print(
		f"Wrote {len(by_module) - len(item_meta)} module page(s), {len(item_meta)} item page(s), "
		f"{len(topics)} topic page(s), "
		f"and api.json ({sum(len(m['symbols']) for m in api_index['modules'])} symbols) "
		f"to {output_dir}"
	)


if __name__ == "__main__":
	main()
