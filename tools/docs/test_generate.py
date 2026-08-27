#!/usr/bin/env python3
"""Offline tests for docs generate.py module-name sanitising and item pages."""

from __future__ import annotations

import posixpath
import re
import unittest
from pathlib import Path
from tempfile import TemporaryDirectory

import generate

DOCS_DIR = Path(__file__).resolve().parents[2] / "docs"
HEADING_ID_RE = re.compile(r'<h[1-6] id="([^"]+)"')

LUALS_SEE_MODULE = "CPPI See: ~https~ :/ulyssesmod.net/archive/CPPI_v1-3.pdf"
LUALS_SEE_RAWDESC = "@namespace CPPI\nSee: ~https~ :/ulyssesmod.net/archive/CPPI_v1-3.pdf"


class ParseNamespaceTests(unittest.TestCase):
	def test_plain(self):
		self.assertEqual(generate.parse_namespace("CPPI"), "CPPI")

	def test_dotted(self):
		self.assertEqual(generate.parse_namespace("cityrp.imageHosts"), "cityrp.imageHosts")

	def test_luals_see_suffix(self):
		self.assertEqual(generate.parse_namespace(LUALS_SEE_MODULE), "CPPI")

	def test_path_rejected(self):
		self.assertIsNone(generate.parse_namespace("../etc"))
		self.assertIsNone(generate.parse_namespace("foo/bar"))


class ParseLdocTagsTests(unittest.TestCase):
	def test_namespace_not_continued_with_see(self):
		desc, tags = generate.parse_ldoc_tags(LUALS_SEE_RAWDESC)
		self.assertEqual(tags["namespace"], ["CPPI"])
		self.assertIn("See:", desc)


class PageFilenameTests(unittest.TestCase):
	def test_slash_does_not_nest(self):
		name = generate.page_filename(LUALS_SEE_MODULE)
		self.assertNotIn("/", name)
		self.assertNotIn("\\", name)
		self.assertTrue(name.endswith(".html"))
		self.assertEqual(Path(name).name, name)

	def test_normal_module(self):
		self.assertEqual(generate.page_filename("Photon.SNet"), "Photon.SNet.html")


ALIAS_VALUES_TAIL = """\
```lua
--  The wire types a variable can be registered as.
--  @section Network Types
netType:
    | `Photon.SNet.BOOL`
    | `Photon.SNet.UINT`
```"""

SIMPLENET = "autorun/photon/shared/sh_simplenet.lua"
SIMPLENET_STUBS = "autorun/photon/meta/sh_simplenet.stubs.lua"


class StripAliasValueBlockTests(unittest.TestCase):
	"""LuaLS appends an `@alias`-typed parameter's accepted values onto the
	function's own description, comment markers and all. The parameter row and
	the alias's own entry already carry both halves of that between them."""

	def test_trailing_block_is_removed(self):
		desc = "Register a variable.\n@state shared\n\n" + ALIAS_VALUES_TAIL
		self.assertEqual(generate.strip_alias_value_block(desc),
			"Register a variable.\n@state shared")

	def test_a_real_code_example_is_kept(self):
		desc = 'Register a variable.\n\n```lua\nPhoton.SNet:Map("SirenOn")\n```'
		self.assertEqual(generate.strip_alias_value_block(desc), desc)

	def test_a_block_that_is_not_at_the_end_is_kept(self):
		desc = ALIAS_VALUES_TAIL + "\nStill describing the function."
		self.assertEqual(generate.strip_alias_value_block(desc), desc)

	def test_plain_description_is_untouched(self):
		self.assertEqual(generate.strip_alias_value_block("Just a sentence."), "Just a sentence.")

	def test_flatten_strips_it_from_a_function(self):
		items = generate.flatten_items([{
			"name": "Photon.SNet",
			"type": "type",
			"defines": [{"file": SIMPLENET, "start": [0, 0], "type": "doc.class", "rawdesc": ""}],
			"fields": [{
				"name": "Map",
				"file": SIMPLENET,
				"start": [10, 0],
				"rawdesc": "Register a variable.\n\n" + ALIAS_VALUES_TAIL,
				"extends": {"type": "function", "args": [], "returns": []},
			}],
		}])
		mapped = next(i for i in items if i["name"] == "Photon.SNet.Map")
		self.assertEqual(mapped["desc"].strip(), "Register a variable.")

	def test_flatten_keeps_the_alias_declarations_own_block(self):
		"""The alias entry *is* one of these blocks - parse_alias_block unpacks
		it into the members list, so stripping it there would empty the entry."""
		items = generate.flatten_items([{
			"name": "PhotonNetType",
			"type": "type",
			"defines": [{"file": SIMPLENET, "start": [0, 0], "type": "doc.alias",
				"rawdesc": "```lua\n--  The wire types.\nPhotonNetType:\n"
					"    | `Photon.SNet.BOOL`\n    | `Photon.SNet.UINT`\n```"}],
		}])
		self.assertEqual(items[0]["alias"]["members"], ["`Photon.SNet.BOOL`", "`Photon.SNet.UINT`"])


class FieldOwnerTests(unittest.TestCase):
	"""A class's fields are copied onto every subclass of it in the export, at
	the same file and line. Only the class the member was written on has a page
	for it - the copies under CSEnt/ENT/EFFECT are the same declaration."""

	def _export(self):
		field = {"name": "GetPhotonNet_SirenOn", "file": SIMPLENET_STUBS, "start": [20, 0],
			"rawdesc": "Whether the siren is on.",
			"extends": {"type": "function", "args": [], "returns": []}}
		return [
			{"name": "Entity", "type": "type", "fields": [dict(field)],
				"defines": [
					{"file": "[FOREIGN] /luals/library/entity.lua", "start": [0, 0], "type": "doc.class"},
					{"file": SIMPLENET_STUBS, "start": [5, 0], "type": "doc.class"},
				]},
			{"name": "CSEnt", "type": "type", "fields": [dict(field)],
				"defines": [{"file": "[FOREIGN] /luals/library/csent.lua", "start": [0, 0],
					"type": "doc.class"}]},
		]

	def test_the_declaring_class_keeps_the_member(self):
		names = {i["name"] for i in generate.flatten_items(self._export())}
		self.assertIn("Entity.GetPhotonNet_SirenOn", names)

	def test_the_inheriting_subclass_does_not(self):
		names = {i["name"] for i in generate.flatten_items(self._export())}
		self.assertNotIn("CSEnt.GetPhotonNet_SirenOn", names)

	def test_owners_only_covers_contested_locations(self):
		self.assertEqual(list(generate.field_owners(self._export()).values()), ["Entity"])

	def test_an_uncontested_member_is_left_alone(self):
		export = self._export()[:1]
		self.assertEqual(generate.field_owners(export), {})
		names = {i["name"] for i in generate.flatten_items(export)}
		self.assertIn("Entity.GetPhotonNet_SirenOn", names)


class FlattenSeeNamespaceTests(unittest.TestCase):
	def test_luals_see_does_not_become_module_path(self):
		items = generate.flatten_items([{
			"name": LUALS_SEE_MODULE,
			"type": "type",
			"defines": [{
				"file": "gamemodes/cityrp_2_by_limelightgaming/gamemode/core/libraries/sh_cppi.lua",
				"start": [4, 0],
				"rawdesc": LUALS_SEE_RAWDESC,
			}],
		}])
		self.assertTrue(items)
		self.assertEqual(items[0]["module"], "CPPI")
		self.assertNotIn("/", items[0]["module"])

	def test_module_page_write_stays_in_modules_dir(self):
		with TemporaryDirectory() as tmp:
			modules_dir = Path(tmp) / "modules"
			modules_dir.mkdir()
			path = modules_dir / generate.page_filename(LUALS_SEE_MODULE)
			path.write_text("ok", encoding="utf-8")
			self.assertTrue(path.is_file())
			self.assertEqual(path.parent, modules_dir)


PLAYER_CLASS_DESC = " The player metatable, with CityRP's own additions to Garry's Mod's `Player`."


def player_typed_export(param):
	"""A `@class Player` plus one function taking a `Player`, shaped the way
	LuaLS exports it."""
	return [
		{
			"name": "Player",
			"type": "type",
			"defines": [{
				"file": "gamemodes/cityrp_2_by_limelightgaming/gamemode/core/metatables/sh_player.lua",
				"start": [6, 0],
				"type": "doc.class",
				"rawdesc": PLAYER_CLASS_DESC,
			}],
		},
		{
			"name": "cityrp.network.SendManifest",
			"type": "variable",
			"defines": [{
				"file": "gamemodes/cityrp_2_by_limelightgaming/gamemode/core/libraries/network/sv_send.lua",
				"start": [507, 0],
				"rawdesc": " Sends the manifest.",
				"extends": {"type": "function", "args": [param], "returns": []},
			}],
		},
	]


class InheritedTypeDescriptionTests(unittest.TestCase):
	"""LuaLS fills an undescribed `@param` with the doc comment of the class it
	is typed as, which renders as if it described the argument."""

	def params_for(self, param):
		items = generate.flatten_items(player_typed_export(param))
		return next(i["params"] for i in items if i["name"].endswith("SendManifest"))

	def test_class_description_is_not_shown_as_the_params_own(self):
		params = self.params_for({"name": "ply", "view": "Player", "desc": PLAYER_CLASS_DESC})
		self.assertFalse(params[0].get("desc"))

	def test_optional_param_inherits_the_same_description(self):
		params = self.params_for({"name": "ply", "view": "Player?", "desc": PLAYER_CLASS_DESC})
		self.assertFalse(params[0].get("desc"))

	def test_the_params_own_description_survives(self):
		params = self.params_for({"name": "ply", "view": "Player", "desc": "The player to send to."})
		self.assertEqual(params[0]["desc"], "The player to send to.")

	def test_old_style_param_tag_fills_the_slot_the_class_text_held(self):
		export = player_typed_export({"name": "ply", "view": "Player", "desc": PLAYER_CLASS_DESC})
		export[1]["defines"][0]["rawdesc"] = "\n".join([
			" Sends the manifest.",
			"@param ply The player to send to.",
		])
		items = generate.flatten_items(export)
		params = next(i["params"] for i in items if i["name"].endswith("SendManifest"))
		self.assertEqual(params[0]["desc"], "The player to send to.")


class TopicFolderTests(unittest.TestCase):
	"""Subfolders under docs/ become their own sidebar section and their own
	directory under topics/."""

	def _topics(self, files):
		with TemporaryDirectory() as tmp:
			root = Path(tmp)
			for rel, body in files.items():
				path = root / rel
				path.parent.mkdir(parents=True, exist_ok=True)
				path.write_text(body, encoding="utf-8")
			return generate.load_topics(root)

	def test_nested_topic_keeps_its_folder(self):
		topics = self._topics({
			"logging.md": "# Logging\n",
			"design/items-registration.md": "# Item Registration\n",
		})
		by_id = {topic["id"]: topic for topic in topics}
		self.assertEqual(by_id["logging"]["folder"], "")
		self.assertEqual(by_id["design/items-registration"]["folder"], "design")
		self.assertEqual(by_id["design/items-registration"]["title"], "Item Registration")

	def test_folders_become_sections_beside_the_loose_files(self):
		topics = self._topics({
			"logging.md": "# Logging\n",
			"design/a.md": "# A\n",
			"clans/b.md": "# B\n",
		})
		loose, sections = generate.topic_sections(topics)
		self.assertEqual([topic["id"] for topic in loose], ["logging"])
		self.assertEqual([section["label"] for section in sections], ["Clans", "Design"])

	def test_folder_index_is_generated_and_lists_its_children(self):
		topics = self._topics({"design/a.md": "# A\n", "design/b.md": "# B\n"})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["index"]["id"], "design/index")
		self.assertEqual(section["index"]["html"], '<ul><li><a href="a.html">A</a></li>'
			'<li><a href="b.html">B</a></li></ul>')

	def test_front_matter_titles_the_page_and_leaves_the_body(self):
		topics = self._topics({
			"design/a.md": "---\ntitle: Real Title\nstatus: Landed\n---\n\n# Ignored\n\nBody.\n",
		})
		self.assertEqual(topics[0]["title"], "Real Title")
		self.assertEqual(topics[0]["meta"], {"title": "Real Title", "status": "Landed"})
		self.assertNotIn("---", topics[0]["body"])
		self.assertIn("Body.", topics[0]["body"])

	def test_front_matter_value_may_contain_a_colon(self):
		fields, body = generate.split_front_matter("---\ntitle: Items: the sequel\n---\nx\n")
		self.assertEqual(fields["title"], "Items: the sequel")
		self.assertEqual(body, "x\n")

	def test_malformed_front_matter_is_left_alone(self):
		text = "---\nnot a key value line\n---\n# A\n"
		self.assertEqual(generate.split_front_matter(text), ({}, text))

	def test_index_tabulates_only_the_fields_in_use(self):
		topics = self._topics({
			"design/a.md": "---\ntitle: A\nstatus: Landed\n---\n",
			"design/b.md": "---\ntitle: B\nstatus: Proposed\n---\n",
		})
		_, (section,) = generate.topic_sections(topics)
		listing = section["index"]["html"]
		self.assertIn("<th>Status</th>", listing)
		self.assertNotIn("<th>Date</th>", listing)
		self.assertNotIn("<th>Description</th>", listing)
		self.assertIn('<tr><td><a href="a.html">A</a></td><td>Landed</td></tr>', listing)

	def test_subfolder_nests_under_its_parent(self):
		topics = self._topics({
			"design/a.md": "# A\n",
			"design/car-boosting/b.md": "# B\n",
		})
		loose, sections = generate.topic_sections(topics)
		self.assertEqual(loose, [])
		self.assertEqual([section["label"] for section in sections], ["Design"])
		(nested,) = sections[0]["subfolders"]
		self.assertEqual(nested["label"], "Car Boosting")
		self.assertEqual([topic["id"] for topic in nested["children"]], ["design/car-boosting/b"])
		# Labelled by its leaf, not its whole path — the parent supplies the rest.
		self.assertNotIn("/", nested["label"])

	def test_parent_index_links_down_to_its_subfolders(self):
		topics = self._topics({"design/a.md": "# A\n", "design/car-boosting/b.md": "# B\n"})
		_, (section,) = generate.topic_sections(topics)
		self.assertIn('<a href="car-boosting/index.html">Car Boosting</a>', section["index"]["html"])

	def test_folder_with_only_subfolders_still_gets_a_node(self):
		topics = self._topics({"design/car-boosting/b.md": "# B\n"})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["folder"], "design")
		self.assertEqual(section["children"], [])
		self.assertEqual([sub["folder"] for sub in section["subfolders"]], ["design/car-boosting"])

	def test_every_ancestor_of_the_current_page_unfolds(self):
		topics = self._topics({
			"design/a.md": "# A\n",
			"design/car-boosting/b.md": "# B\n",
			"clans/c.md": "# C\n",
		})
		deep = next(t for t in topics if t["id"] == "design/car-boosting/b")
		page = generate.render_topic_page(deep, {}, topics)
		self.assertEqual(page.count("ll-topic-folder is-open"), 2)
		self.assertIn("<strong>B</strong>", page)
		self.assertIn('href="../../../topics/design/a.html"', page)
		# The sibling branch stays shut.
		self.assertNotIn("topics/clans/c.html", page)

	def test_every_nested_page_is_written(self):
		topics = self._topics({"design/a.md": "# A\n", "design/car-boosting/b.md": "# B\n"})
		self.assertEqual(sorted(topic["id"] for topic in generate.topic_pages(topics)),
			["design/a", "design/car-boosting/b", "design/car-boosting/index", "design/index"])

	def test_promoted_page_becomes_the_folder_index(self):
		topics = self._topics({
			"clans/overview.md": "---\ntitle: Clans\nindex: true\n---\n\nWhat clans are.\n",
			"clans/bank.md": "# Bank\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["label"], "Clans")
		# Keeps its own URL, so inbound links to it still resolve.
		self.assertEqual(section["index"]["id"], "clans/overview")
		# Stands in for the listing rather than being prefixed to it.
		self.assertIn("What clans are.", section["index"]["html"])
		self.assertNotIn("bank.html", section["index"]["html"])
		# And drops out of the folder's own list.
		self.assertEqual([topic["id"] for topic in section["children"]], ["clans/bank"])

	def test_promoted_page_is_written_once(self):
		topics = self._topics({
			"clans/overview.md": "---\nindex: true\n---\n\nBody.\n",
			"clans/bank.md": "# Bank\n",
		})
		ids = [topic["id"] for topic in generate.topic_pages(topics)]
		self.assertEqual(sorted(ids), ["clans/bank", "clans/overview"])
		self.assertNotIn("clans/index", ids)

	def test_promoted_page_is_the_current_entry_when_you_are_on_it(self):
		topics = self._topics({
			"clans/overview.md": "---\ntitle: Clans\nindex: true\n---\n\nBody.\n",
			"clans/bank.md": "# Bank\n",
		})
		_, (section,) = generate.topic_sections(topics)
		page = generate.render_topic_page(section["index"], {}, topics)
		self.assertIn('<li class="ll-topic-folder is-open"><strong>Clans</strong>', page)
		self.assertIn("topics/clans/bank.html", page)

	def test_promoted_index_still_links_down_to_subfolders(self):
		topics = self._topics({
			"design/overview.md": "---\ntitle: Design\nindex: true\n---\n\nBody.\n",
			"design/clans/a.md": "# A\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertIn('<a href="clans/index.html">Clans</a>', section["index"]["html"])

	def test_sections_carry_the_subfolders_description(self):
		"""A subfolder is listed by the same table as the folder's own docs, so
		its description shows the way a doc's does."""
		topics = self._topics({
			"design/a.md": "---\ntitle: A\ndescription: A doc.\n---\n",
			"design/clans/clans.md": "---\ntitle: Clans\ndescription: Player-formed groups.\n---\n",
		})
		_, (section,) = generate.topic_sections(topics)
		listing = section["index"]["html"].split("Sections")[1]
		self.assertIn("<th>Description</th>", listing)
		self.assertIn("Player-formed groups.", listing)

	def test_sections_stay_a_plain_list_without_front_matter(self):
		topics = self._topics({"design/a.md": "# A\n", "design/clans/b.md": "# B\n"})
		_, (section,) = generate.topic_sections(topics)
		self.assertNotIn("<table>", section["index"]["html"].split("Sections")[1])

	def test_parent_links_to_a_subfolders_promoted_index_by_its_real_name(self):
		topics = self._topics({
			"design/a.md": "# A\n",
			"design/clans/overview.md": "---\ntitle: Clans\nindex: true\n---\n\nBody.\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertIn('<a href="clans/overview.html">Clans</a>', section["index"]["html"])

	def test_doc_named_after_its_folder_is_promoted(self):
		topics = self._topics({
			"car-boosting/car-boosting.md": "# Car Boosting and Ringing\n\nHow it works.\n",
			"car-boosting/hotwiring.md": "# Vehicle hotwiring\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["index"]["id"], "car-boosting/car-boosting")
		self.assertEqual(section["label"], "Car Boosting and Ringing")
		self.assertEqual([topic["id"] for topic in section["children"]],
			["car-boosting/hotwiring"])

	def test_name_match_needs_the_whole_name(self):
		topics = self._topics({
			"car-boosting/car-boosting-live-test-plan.md": "# Plan\n",
			"car-boosting/hotwiring.md": "# Hotwiring\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["index"]["id"], "car-boosting/index")
		self.assertEqual(len(section["children"]), 2)

	def test_index_md_beats_a_folder_name_match(self):
		topics = self._topics({
			"car-boosting/index.md": "# Overview\n",
			"car-boosting/car-boosting.md": "# Car Boosting\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["index"]["id"], "car-boosting/index")
		self.assertIn("car-boosting/car-boosting", [t["id"] for t in section["children"]])

	def test_explicit_index_beats_a_folder_name_match(self):
		topics = self._topics({
			"car-boosting/car-boosting.md": "# Car Boosting\n",
			"car-boosting/hotwiring.md": "---\ntitle: Hotwiring\nindex: true\n---\n\nBody.\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["index"]["id"], "car-boosting/hotwiring")
		self.assertIn("car-boosting/car-boosting", [t["id"] for t in section["children"]])

	def test_top_level_doc_is_never_a_name_match(self):
		topics = self._topics({"docs.md": "# Docs\n"})
		loose, sections = generate.topic_sections(topics)
		self.assertEqual([topic["id"] for topic in loose], ["docs"])
		self.assertEqual(sections, [])

	def test_explicit_index_beats_the_index_md_convention(self):
		topics = self._topics({
			"clans/index.md": "# Generated Landing\n",
			"clans/overview.md": "---\ntitle: Clans\nindex: true\n---\n\nBody.\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["index"]["id"], "clans/overview")
		self.assertIn("clans/index", [topic["id"] for topic in section["children"]])

	def test_pinned_topics_rise_to_the_top_of_their_category(self):
		topics = self._topics({
			"a.md": "# A\n",
			"z.md": "---\npinned: true\n---\n\n# Z\n",
			"design/a.md": "# DA\n",
			"design/z.md": "---\npinned: yes\n---\n\n# DZ\n",
		})
		loose, (section,) = generate.topic_sections(topics)
		self.assertEqual([topic["title"] for topic in loose], ["Z", "A"])
		self.assertEqual([topic["title"] for topic in section["children"]], ["DZ", "DA"])

	def test_unpinned_order_is_untouched(self):
		topics = self._topics({"a.md": "# A\n", "b.md": "# B\n", "c.md": "# C\n"})
		loose, _ = generate.topic_sections(topics)
		self.assertEqual([topic["title"] for topic in loose], ["A", "B", "C"])

	def test_pin_shows_in_the_sidebar_and_the_folder_index(self):
		topics = self._topics({
			"design/a.md": "---\npinned: true\n---\n\n# A\n",
			"design/b.md": "# B\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertIn(generate.PIN_ICON + '<a href="a.html">A</a>', section["index"]["html"])
		self.assertIn('<li><a href="b.html">B</a></li>', section["index"]["html"])

		# Trails the title, so the sidebar's hanging indent can't drag the title
		# back over it.
		page = generate.render_topic_page(section["children"][1], {}, topics)
		self.assertIn(">A" + generate.PIN_ICON + "</a>", page)

	def test_pinned_needs_a_truthy_value(self):
		topics = self._topics({"a.md": "---\npinned: false\n---\n\n# A\n"})
		self.assertFalse(generate.is_pinned(topics[0]))

	def test_index_stays_a_plain_list_without_front_matter(self):
		topics = self._topics({"clans/a.md": "# A\n"})
		_, (section,) = generate.topic_sections(topics)
		self.assertNotIn("<table>", section["index"]["html"])

	def test_authored_index_titles_the_section_and_keeps_its_body(self):
		topics = self._topics({
			"design/index.md": "# Design Docs\n\nPlans, not behaviour.\n",
			"design/a.md": "# A\n",
		})
		_, (section,) = generate.topic_sections(topics)
		self.assertEqual(section["label"], "Design Docs")
		self.assertIn("Plans, not behaviour.", section["index"]["html"])
		self.assertIn('<a href="a.html">A</a>', section["index"]["html"])
		# Folded into the index page rather than written out a second time.
		self.assertNotIn("design/index", [topic["id"] for topic in section["children"]])
		self.assertEqual([topic["id"] for topic in generate.topic_pages(topics)],
			["design/index", "design/a"])

	def test_folder_pages_are_hidden_until_you_are_in_the_folder(self):
		topics = self._topics({"logging.md": "# Logging\n", "design/a.md": "# A\n"})
		elsewhere = generate.render_topic_page(
			next(t for t in topics if t["id"] == "logging"), {}, topics)
		self.assertIn("ll-topic-folder", elsewhere)
		self.assertNotIn("is-open", elsewhere)
		self.assertNotIn("topics/design/a.html", elsewhere)

		inside = generate.render_topic_page(
			next(t for t in topics if t["id"] == "design/a"), {}, topics)
		self.assertIn("ll-topic-folder is-open", inside)
		self.assertIn("ll-topic-children", inside)
		# The page you're on is the current entry, so it isn't also a link.
		self.assertIn("<strong>A</strong>", inside)

	def test_folder_entry_is_not_a_link_to_the_page_you_are_on(self):
		topics = self._topics({"design/index.md": "# Design Docs\n", "design/a.md": "# A\n"})
		index = next(t for t in generate.topic_pages(topics) if t["id"] == "design/index")
		page = generate.render_topic_page(index, {}, topics)
		self.assertIn('<li class="ll-topic-folder is-open"><strong>Design Docs</strong>', page)
		self.assertNotIn('topics/design/index.html"', page)

	def test_nested_page_climbs_back_to_the_root(self):
		topics = self._topics({"design/a.md": "# A\n"})
		page = generate.render_topic_page(topics[0], {}, topics)
		self.assertIn('href="../../style.css"', page)
		self.assertIn('href="../../topics/design/index.html"', page)

	def test_cross_topic_link_becomes_a_page_link(self):
		topics = self._topics({
			"logging.md": "# Logging\n",
			"design/a.md": "# A\n\n[up](../logging.md) [out](../../AGENTS.md)\n",
		})
		body = next(topic["html"] for topic in topics if topic["id"] == "design/a")
		self.assertIn('href="../logging.html"', body)
		self.assertIn('href="../../AGENTS.md"', body)

	def test_opening_h1_is_dropped_from_the_rendered_page(self):
		topics = self._topics({"a.md": "# A\n\nBody.\n\n## Section\n\n# Later\n"})
		self.assertNotIn("<h1>A</h1>", topics[0]["html"])
		self.assertTrue(topics[0]["html"].startswith("<p>Body.</p>"))
		# Only the opening one - an h1 further down is a real section heading.
		self.assertIn("Later</h1>", topics[0]["html"])
		# The markdown itself keeps it, for reading the file on GitHub.
		self.assertTrue(topics[0]["body"].startswith("# A"))

	def test_page_without_an_opening_h1_is_untouched(self):
		topics = self._topics({"a.md": "Intro paragraph.\n\n## Section\n"})
		self.assertTrue(topics[0]["html"].startswith("<p>Intro paragraph.</p>"))

	def test_gfm_alerts_become_callouts(self):
		topics = self._topics({"a.md": "# A\n\n> [!WARNING]\n> Do not do this.\n"})
		body = topics[0]["html"]
		self.assertIn('<blockquote class="ll-alert ll-alert-warning">', body)
		self.assertIn('<p class="ll-alert-title">Warning</p>', body)
		self.assertIn("Do not do this.", body)
		# The marker itself is consumed, not left as text.
		self.assertNotIn("[!WARNING]", body)

	def test_every_github_alert_kind_is_recognised(self):
		for marker, title in [("NOTE", "Note"), ("TIP", "Tip"), ("IMPORTANT", "Important"),
				("WARNING", "Warning"), ("CAUTION", "Caution")]:
			rendered = generate.render_markdown(f"> [!{marker}]\n> Body.\n")
			self.assertIn(f'll-alert-{marker.lower()}"', rendered)
			self.assertIn(f'<p class="ll-alert-title">{title}</p>', rendered)

	def test_plain_blockquote_is_left_alone(self):
		rendered = generate.render_markdown("> Just a quote.\n")
		self.assertIn("<blockquote>", rendered)
		self.assertNotIn("ll-alert", rendered)

	def test_unknown_alert_marker_is_left_alone(self):
		rendered = generate.render_markdown("> [!SPOILER]\n> Body.\n")
		self.assertNotIn("ll-alert", rendered)
		self.assertIn("[!SPOILER]", rendered)

	def test_headings_get_github_style_anchors(self):
		topics = self._topics({"a.md": "# A\n\n## The ledger — event sourcing\n\n## Keys\n"})
		self.assertIn('<h2 id="the-ledger--event-sourcing">', topics[0]["html"])
		self.assertIn('<h2 id="keys">', topics[0]["html"])


COL_ALIAS_RAWDESC = (
	"```lua\n"
	"--  Every colour the gamemode ships as a constant.\n"
	"--  @section Colours\n"
	"COL:\n"
	"    | `COL_WHITE`\n"
	"    | `COL_BLACK`\n"
	"```"
)
WARRANT_ALIAS_RAWDESC = '```lua\nWARRANT:\n    | "bolo"\n    | "search"\n```'


class SectionTitleTests(unittest.TestCase):
	def test_tag_value_is_the_title(self):
		self.assertEqual(generate.section_title("Rank Colours"), "Rank Colours")

	def test_lowercase_slug_is_title_cased(self):
		self.assertEqual(generate.section_title("functions"), "Functions")
		self.assertEqual(generate.section_title("default_sinks"), "Default Sinks")
		self.assertEqual(generate.section_title("data-abstracted"), "Data Abstracted")

	def test_missing_tag_has_no_title(self):
		self.assertEqual(generate.section_title(None), "")

	def test_description_no_longer_leaks_into_the_header(self):
		"""@section used to take its title from the first item's description,
		so cityrp.logging rendered whole sentences as headers."""
		items = [{"name": "log", "desc": "Logs a message at DEBUG level.", "tags": {"section": ["levels"]}}]
		self.assertEqual(generate.group_by_section(items)[0]["title"], "Levels")


class ParseAliasBlockTests(unittest.TestCase):
	def test_unpacks_description_tags_and_members(self):
		desc, tags, members = generate.parse_alias_block(COL_ALIAS_RAWDESC)
		self.assertEqual(desc.strip(), "Every colour the gamemode ships as a constant.")
		self.assertEqual(tags["section"], ["Colours"])
		self.assertEqual(members, ["`COL_WHITE`", "`COL_BLACK`"])

	def test_string_literal_union(self):
		desc, _, members = generate.parse_alias_block(WARRANT_ALIAS_RAWDESC)
		self.assertEqual(desc, "")
		self.assertEqual(members, ['"bolo"', '"search"'])

	def test_a_plain_comment_is_not_an_alias(self):
		self.assertIsNone(generate.parse_alias_block("Logs a message."))
		self.assertIsNone(generate.parse_alias_block("```lua\nlocal x = 1\n```"))


class CollectEnumFamiliesTests(unittest.TestCase):
	def _item(self, name, start=(0, 0), **kw):
		base = {"name": name, "depth": 0, "tags": {}, "desc": "", "file": "core/sh_enumerations.lua",
			"start": start, "alias": None}
		base.update(kw)
		return base

	def _col_family(self):
		return [
			self._item("COL_WHITE", start=(20, 0), tags={"section": ["Generic"]}),
			self._item("COL_BLACK", start=(21, 0)),
			self._item("COL", start=(90, 0), desc="Every colour.", tags={"section": ["Colours"]},
				alias={"members": ["`COL_BLACK`", "`COL_WHITE`"]}),
		]

	def test_constants_are_gathered_under_their_alias(self):
		items = self._col_family()
		families = generate.collect_enum_families(items)
		self.assertEqual([f["title"] for f in families], ["Colours"])
		self.assertEqual([m["name"] for m in families[0]["members"]], ["COL_WHITE", "COL_BLACK"],
			"members render in declaration order, not the order the alias lists them")
		self.assertTrue(all(item["family"] == "COL" for item in items))

	def test_title_falls_back_to_the_alias_name(self):
		items = self._col_family()
		items[2]["tags"] = {}
		self.assertEqual(generate.collect_enum_families(items)[0]["title"], "COL")

	def test_a_union_of_types_is_not_a_family(self):
		"""`@alias Colour `COL` | `Color`` names types, not constants."""
		items = self._col_family() + [
			self._item("Colour", start=(95, 0), alias={"members": ["`COL`", "`Color`"]}),
		]
		families = generate.collect_enum_families(items)
		self.assertEqual([f["name"] for f in families], ["COL"])
		self.assertIsNone(items[3].get("family"), "Colour keeps its own entry")

	def test_one_constant_is_not_worth_a_heading(self):
		items = [
			self._item("MDL_NONE", start=(10, 0)),
			self._item("MDL", start=(20, 0), alias={"members": ["`MDL_NONE`"]}),
		]
		self.assertEqual(generate.collect_enum_families(items), [])
		self.assertIsNone(items[0].get("family"))

	def test_undocumented_members_are_skipped(self):
		items = self._col_family()
		items[2]["alias"]["members"].append("`COL_MISSING`")
		self.assertEqual(len(generate.collect_enum_families(items)[0]["members"]), 2)

	def test_constants_on_a_library_table_are_gathered_too(self):
		"""Not every enumeration is a run of globals - a library's own wire
		types hang off its table, so the members are dotted paths."""
		items = [
			self._item("Photon.SNet.BOOL", start=(20, 0), file=SIMPLENET),
			self._item("Photon.SNet.UINT", start=(21, 0), file=SIMPLENET),
			self._item("PhotonNetType", start=(10, 0), file=SIMPLENET, desc="The wire types.",
				tags={"section": ["Network Types"]},
				alias={"members": ["`Photon.SNet.BOOL`", "`Photon.SNet.UINT`"]}),
		]
		families = generate.collect_enum_families(items)
		self.assertEqual([f["title"] for f in families], ["Network Types"])
		self.assertEqual([m["name"] for m in families[0]["members"]],
			["Photon.SNet.BOOL", "Photon.SNet.UINT"])

	def test_rerunning_over_the_same_items_is_a_no_op(self):
		"""The HTML pass and the api.json pass both call this."""
		items = self._col_family()
		first = generate.collect_enum_families(items)
		second = generate.collect_enum_families(items)
		self.assertEqual([f["name"] for f in first], [f["name"] for f in second])
		self.assertEqual(len(second[0]["members"]), 2)


class CommonSymbolPrefixTests(unittest.TestCase):
	"""The chip beside a family heading names the prefix its constants share.
	It has to come from the constants, not the alias: an alias naming a type
	rather than a prefix would otherwise advertise names nothing declares."""

	def test_underscore_prefixed_globals(self):
		self.assertEqual(generate.common_symbol_prefix(["COL_WHITE", "COL_BLACK"]), "COL_")

	def test_fields_on_a_library_table(self):
		self.assertEqual(
			generate.common_symbol_prefix(["Photon.SNet.BOOL", "Photon.SNet.UINT"]),
			"Photon.SNet.")

	def test_a_partial_word_is_not_a_prefix(self):
		"""`COL_BLACK`/`COL_BLUE` share "COL_BL", which names nothing."""
		self.assertEqual(generate.common_symbol_prefix(["COL_BLACK", "COL_BLUE"]), "COL_")

	def test_nothing_in_common(self):
		self.assertEqual(generate.common_symbol_prefix(["ALPHA", "BETA"]), "")

	def test_no_members(self):
		self.assertEqual(generate.common_symbol_prefix([]), "")


class CollectClassFamiliesTests(unittest.TestCase):
	def _item(self, name, kind="Functions", start=(0, 0), **kw):
		base = {"name": name, "depth": 0, "kind": kind, "tags": {}, "desc": "",
			"file": "core/libraries/network/sh_registry.lua", "start": start,
			"alias": None, "is_class": False}
		base.update(kw)
		return base

	def _netvar(self):
		return [
			self._item("cityrp.network.Register", start=(10, 0)),
			self._item("NetVar", kind="Classes", is_class=True, start=(60, 0),
				desc="A registered network variable."),
			self._item("NetVar.SetEntity", start=(70, 0)),
			self._item("NetVar.name", kind="Fields", start=(80, 0)),
		]

	def test_members_are_gathered_under_their_class(self):
		items = self._netvar()
		families = generate.collect_class_families(items, "cityrp.network")
		self.assertEqual([f["name"] for f in families], ["NetVar"])
		self.assertEqual([m["name"] for m in families[0]["members"]],
			["NetVar.SetEntity", "NetVar.name"],
			"members stay in source order for @section carry-forward")
		self.assertTrue(all(item["class_family"] == "NetVar" for item in items[1:]))
		self.assertIsNone(items[0].get("class_family"), "the module's own function is untouched")

	def test_the_page_that_is_the_class_gathers_nothing(self):
		"""`Player` claims a page of its own via `@namespace`, where the page
		is the class - a Player section on the Player page is the whole page."""
		items = [
			self._item("Player", kind="Classes", is_class=True),
			self._item("Player.CanStaffChat"),
			self._item("Player.SetPermission"),
		]
		self.assertEqual(generate.collect_class_families(items, "Player"), [])
		self.assertEqual(generate.collect_class_families(items, "cityrp.access", {"Player": []}), [])

	def test_a_nested_class_keeps_its_own_members(self):
		items = [
			self._item("PluginMeta", kind="Classes", is_class=True, start=(10, 0)),
			self._item("PluginMeta.name", kind="Fields", start=(11, 0)),
			self._item("PluginMeta.after", kind="Fields", start=(12, 0)),
			self._item("PluginMeta.Sub", kind="Classes", is_class=True, start=(20, 0)),
			self._item("PluginMeta.Sub.x", kind="Fields", start=(21, 0)),
			self._item("PluginMeta.Sub.y", kind="Fields", start=(22, 0)),
		]
		families = {f["name"]: [m["name"] for m in f["members"]]
			for f in generate.collect_class_families(items, "cityrp.plugin")}
		self.assertEqual(families["PluginMeta.Sub"], ["PluginMeta.Sub.x", "PluginMeta.Sub.y"])
		self.assertEqual(families["PluginMeta"], ["PluginMeta.name", "PluginMeta.after"])

	def test_one_member_is_not_worth_a_heading(self):
		items = [
			self._item("Sink", kind="Classes", is_class=True),
			self._item("Sink.write"),
		]
		self.assertEqual(generate.collect_class_families(items, "cityrp.logging"), [])
		self.assertIsNone(items[1].get("class_family"))

	def test_an_enum_family_member_is_not_claimed_twice(self):
		items = [
			self._item("NetScope", kind="Classes", is_class=True),
			self._item("NetScope.ENTITY", kind="Fields", family="NetScope"),
			self._item("NetScope.GLOBAL", kind="Fields", family="NetScope"),
		]
		self.assertEqual(generate.collect_class_families(items, "cityrp.network"), [])


class AssignClassModulesTests(unittest.TestCase):
	PLAYER_HEADERS = {
		"core/metatables/sh_player.lua": ("Shared Player Metafunctions.", {"namespace": ["Player"]}),
		"core/libraries/sv_access.lua": ("Access and flags - server.", {"namespace": ["cityrp.access"]}),
		"core/metatables/sh_permissions.lua": ("Shared Player Metafunctions.", {}),
	}

	def _item(self, name, module, file, depth=0, **kw):
		base = {"name": name, "module": module, "file": file, "depth": depth,
			"explicit_module": None, "is_class": False, "tags": {}, "desc": "", "extends": None}
		base.update(kw)
		return base

	def _player_items(self):
		return [
			self._item("Player", "cityrp.access", "core/libraries/sv_access.lua", is_class=True),
			self._item("Player.CanStaffChat", "cityrp.access", "core/libraries/sv_access.lua", depth=1),
			self._item("Player.SetPermission", "core.libraries.sv_access",
				"core/metatables/sh_permissions.lua", depth=1),
			self._item("cityrp.access.hasAccess", "cityrp.access", "core/libraries/sv_access.lua",
				explicit_module="cityrp.access"),
		]

	def test_members_follow_their_class(self):
		items = self._player_items()
		generate.assign_class_modules(items, self.PLAYER_HEADERS)
		self.assertEqual([i["module"] for i in items[:3]], ["Player"] * 3)

	def test_a_library_function_in_the_same_file_stays_put(self):
		items = self._player_items()
		generate.assign_class_modules(items, self.PLAYER_HEADERS)
		self.assertEqual(items[3]["module"], "cityrp.access")

	def test_a_class_without_a_page_of_its_own_name_is_left_alone(self):
		"""`@class Pass` describes a table on cityrp.configuration's page; it
		declares no `@namespace Pass`, so its fields belong there."""
		items = [
			self._item("Pass", "cityrp.configuration", "core/sh_configuration.lua", is_class=True),
			self._item("Pass.icon", "cityrp.configuration", "core/sh_configuration.lua", depth=1),
		]
		generate.assign_class_modules(items, self.PLAYER_HEADERS)
		self.assertEqual([i["module"] for i in items], ["cityrp.configuration"] * 2)

	def test_a_namespace_that_is_not_a_class_claims_nothing(self):
		items = [self._item("cityrp.access", "cityrp.access", "core/libraries/sv_access.lua"),
			self._item("cityrp.access.hasAccess", "cityrp.access", "core/libraries/sv_access.lua", depth=1)]
		generate.assign_class_modules(items, self.PLAYER_HEADERS)
		self.assertEqual([i["module"] for i in items], ["cityrp.access"] * 2)

	def test_an_item_base_still_claims_its_members_back(self):
		"""assign_item_modules runs second and must win over the ITEM page."""
		headers = {"core/libraries/sh_itemcore.lua": ("Item core.", {"namespace": ["ITEM"]})}
		items = [
			self._item("ITEM", "ITEM", "core/libraries/sh_itemcore.lua", is_class=True),
			self._item("ITEM.Accessory", "core.items.sh_accessory", "core/items/sh_accessory.lua",
				is_class=True, tags={"uniqueid": ["base_accessory"]}),
			self._item("ITEM.Accessory.canDrop", "core.items.sh_accessory",
				"core/items/sh_accessory.lua", depth=1),
		]
		generate.assign_class_modules(items, headers)
		self.assertEqual(items[1]["module"], "ITEM", "gathered onto the ITEM page first")
		generate.assign_item_modules(items, headers)
		self.assertEqual(items[1]["module"], "ITEM.Accessory")
		self.assertEqual(items[2]["module"], "ITEM.Accessory")


class ModuleDescriptionsTests(unittest.TestCase):
	def test_the_file_that_claims_the_namespace_wins(self):
		"""sv_access.lua sorts first among Player's files but only hangs two
		methods on it - its header describes itself, not the class."""
		by_module = {"Player": [
			{"file": "core/libraries/sv_access.lua"},
			{"file": "core/metatables/sh_player.lua"},
		]}
		headers = {
			"core/libraries/sv_access.lua": ("Access and flags - server.", {"namespace": ["cityrp.access"]}),
			"core/metatables/sh_player.lua": ("Shared Player Metafunctions.", {"namespace": ["Player"]}),
		}
		self.assertEqual(generate.module_descriptions(by_module, headers)["Player"],
			"Shared Player Metafunctions.")

	def test_falls_back_to_the_first_file_with_a_description(self):
		by_module = {"core.thing": [{"file": "b.lua"}, {"file": "a.lua"}]}
		headers = {"a.lua": ("First alphabetically.", {}), "b.lua": ("Second.", {})}
		self.assertEqual(generate.module_descriptions(by_module, headers)["core.thing"],
			"First alphabetically.")


class ItemDisplayNameTests(unittest.TestCase):
	def test_member_is_rewritten_to_the_root_class(self):
		self.assertEqual(
			generate.item_display_name("ITEM.Accessory.canDrop", "ITEM.Accessory"), "ITEM.canDrop")

	def test_class_itself_becomes_the_root_class(self):
		self.assertEqual(generate.item_display_name("ITEM.Accessory", "ITEM.Accessory"), "ITEM")

	def test_sibling_class_is_left_alone(self):
		"""ITEM.Suit must not claim ITEM.SuitTie's members."""
		self.assertEqual(
			generate.item_display_name("ITEM.SuitTie.New", "ITEM.Suit"), "ITEM.SuitTie.New")


class InheritanceChainTests(unittest.TestCase):
	PARENTS = {"ITEM.Uniform": "ITEM.Outfit", "ITEM.Outfit": "ITEM.Clothing", "ITEM.Clothing": "ITEM"}

	def test_chain_is_root_first(self):
		self.assertEqual(
			generate.inheritance_chain("ITEM.Uniform", self.PARENTS),
			["ITEM", "ITEM.Clothing", "ITEM.Outfit"])

	def test_unparented_class_has_no_chain(self):
		self.assertEqual(generate.inheritance_chain("ITEM", self.PARENTS), [])

	def test_cycle_terminates(self):
		self.assertEqual(generate.inheritance_chain("A", {"A": "B", "B": "A"}), ["B"])


class ExtendsClassNameTests(unittest.TestCase):
	def test_reads_doc_extends_name(self):
		self.assertEqual(
			generate.extends_class_name([{"type": "doc.extends.name", "view": "ITEM"}]), "ITEM")

	def test_ignores_non_class_extends(self):
		self.assertIsNone(generate.extends_class_name({"type": "function", "view": "fun()"}))
		self.assertIsNone(generate.extends_class_name(None))


class ClassifyKindTests(unittest.TestCase):
	def test_type_declarations_are_classes(self):
		"""A `@class`/`@alias`/`@enum` carries no useful `extends` shape, so
		without the declaration type they all land in the Fields catch-all."""
		for doc_type in ("doc.class", "doc.alias", "doc.enum"):
			self.assertEqual(generate.classify_kind(None, doc_type), "Classes")

	def test_values_are_classified_by_their_shape(self):
		self.assertEqual(generate.classify_kind({"type": "function"}), "Functions")
		self.assertEqual(generate.classify_kind({"type": "table"}), "Tables")
		self.assertEqual(generate.classify_kind({"type": "integer"}), "Fields")


class SearchIndexKindTests(unittest.TestCase):
	def _item(self, name, kind):
		return {"name": name, "kind": kind, "desc": "", "file": "f.lua", "depth": 0}

	def test_every_kind_has_a_singular_search_label(self):
		"""The chip labels one symbol. Trimming a trailing "s" spelt Classes
		"classe"; every KIND_ORDER heading needs a real singular."""
		self.assertEqual(set(generate.KIND_SINGULAR), set(generate.KIND_ORDER))
		by_module = {"cityrp.network": [
			self._item("NetVar", "Classes"),
			self._item("cityrp.network.Register", "Functions"),
		]}
		entries = generate.build_search_index(by_module, [])
		kinds = {entry["n"]: entry["k"] for entry in entries}
		self.assertEqual(kinds["NetVar"], "class")
		self.assertEqual(kinds["cityrp.network.Register"], "function")
		self.assertEqual(kinds["cityrp.network"], "module")


class AssignItemModulesTests(unittest.TestCase):
	def _item(self, name, **kw):
		base = {"name": name, "depth": 0, "tags": {}, "desc": "", "file": "f.lua",
			"extends": None, "module": "ITEM"}
		base.update(kw)
		return base

	def test_tagged_class_and_members_move_to_their_own_page(self):
		items = [
			self._item("ITEM.Accessory", tags={"uniqueid": ["base_accessory"]}, extends="ITEM"),
			self._item("ITEM.Accessory.canDrop", depth=1),
			self._item("cityrp.item.get"),
		]
		meta = generate.assign_item_modules(items)
		self.assertEqual(list(meta), ["ITEM.Accessory"])
		self.assertEqual(meta["ITEM.Accessory"]["uniqueids"], ["base_accessory"])
		self.assertEqual(items[0]["module"], "ITEM.Accessory")
		self.assertEqual(items[1]["module"], "ITEM.Accessory")
		self.assertEqual(items[2]["module"], "ITEM", "untagged items stay put")

	def test_untagged_classes_are_not_items(self):
		items = [self._item("ITEM.SuitTie", extends="ITEM.ModelBodygroup")]
		self.assertEqual(generate.assign_item_modules(items), {})

	def test_root_item_class_joins_the_items_category(self):
		items = [
			self._item("ITEM", file="core/libraries/sh_itemcore.lua"),
			self._item("ITEM.Accessory", tags={"uniqueid": ["base_accessory"]}, extends="ITEM"),
		]
		meta = generate.assign_item_modules(items, {})
		self.assertIn("ITEM", meta)
		self.assertEqual(meta["ITEM"]["uniqueids"], [], "the metatable is not a registered item")
		self.assertIsNone(meta["ITEM"]["file"], "no own-declaration filter on the root")

	def test_root_takes_its_description_from_its_own_file(self):
		items = [
			self._item("ITEM", desc="fallback", file="core/libraries/sh_itemcore.lua"),
			self._item("ITEM.Accessory", tags={"uniqueid": ["base_accessory"]}),
		]
		headers = {"core/libraries/sh_itemcore.lua": ("Item metatable.", {})}
		self.assertEqual(generate.assign_item_modules(items, headers)["ITEM"]["desc"], "Item metatable.")

	def test_no_items_means_no_items_category_at_all(self):
		"""The root only moves when there are bases to sit beside."""
		self.assertEqual(generate.assign_item_modules([self._item("ITEM")], {}), {})

	def test_root_does_not_claim_a_base_member(self):
		items = [
			self._item("ITEM"),
			self._item("ITEM.Accessory", tags={"uniqueid": ["base_accessory"]}),
			self._item("ITEM.Accessory.canDrop", depth=1),
			self._item("ITEM.SetCost", depth=1),
		]
		generate.assign_item_modules(items, {})
		self.assertEqual(items[2]["module"], "ITEM.Accessory")
		self.assertEqual(items[3]["module"], "ITEM")

	def test_longer_class_wins_the_prefix_match(self):
		items = [
			self._item("ITEM.Suit", tags={"uniqueid": ["base_suit"]}),
			self._item("ITEM.SuitTie", tags={"uniqueid": ["suit_tie"]}),
			self._item("ITEM.SuitTie.New", depth=1),
		]
		generate.assign_item_modules(items)
		self.assertEqual(items[2]["module"], "ITEM.SuitTie")

class SymbolLinkTests(unittest.TestCase):
	LINKS = {
		"cityrp.help.addNew": "cityrp.help.html#cityrp.help.addNew",
		"cityrp.ui": "cityrp.ui.html",
		"Player.Arrest": "Player.html#Player.Arrest",
	}

	def test_colon_reference_resolves_to_the_dotted_symbol(self):
		out = generate.linkify_symbols("Use cityrp.help:addNew instead.", self.LINKS)
		self.assertEqual(out,
			'Use <a href="cityrp.help.html#cityrp.help.addNew">cityrp.help:addNew</a> instead.')

	def test_call_parentheses_are_kept_in_the_link_text(self):
		out = generate.linkify_symbols("Use Player.Arrest() instead.", self.LINKS)
		self.assertIn(">Player.Arrest()</a>", out)

	def test_a_module_name_resolves_too(self):
		self.assertIn('href="cityrp.ui.html"', generate.linkify_symbols("See cityrp.ui.", self.LINKS))

	def test_bare_words_are_never_linked(self):
		"""A reference has to be qualified; prose must not become a minefield."""
		for text in ("Use the helper instead.", "Deprecated. Call Arrest now.", "See Player."):
			self.assertNotIn("<a ", generate.linkify_symbols(text, self.LINKS), text)

	def test_undocumented_reference_is_left_as_text(self):
		out = generate.linkify_symbols("Use cityrp.nope.gone instead.", self.LINKS)
		self.assertNotIn("<a ", out)

	def test_it_does_not_nest_inside_an_existing_link(self):
		text = '<a href="x.html">cityrp.help:addNew</a> and cityrp.ui'
		out = generate.linkify_symbols(text, self.LINKS)
		self.assertEqual(out.count("<a "), 2)
		self.assertIn('<a href="x.html">cityrp.help:addNew</a>', out)

	def test_it_works_inside_code_spans(self):
		out = generate.linkify_symbols("<code>cityrp.help:addNew</code>", self.LINKS)
		self.assertIn("<a href=", out)

	def test_it_leaves_code_blocks_alone(self):
		"""An inline mention should link; a worked example should not become
		link soup."""
		out = generate.linkify_symbols(
			"<p>See cityrp.ui</p><pre><code>local x = cityrp.ui\n</code></pre>", self.LINKS)
		self.assertEqual(out.count("<a "), 1)
		self.assertIn("<pre><code>local x = cityrp.ui\n</code></pre>", out)

	def test_a_reference_after_a_code_block_still_links(self):
		out = generate.linkify_symbols("<pre>cityrp.ui</pre><p>then cityrp.ui</p>", self.LINKS)
		self.assertEqual(out.count("<a "), 1)
		self.assertIn("<pre>cityrp.ui</pre>", out)

	def test_tags_are_not_rewritten(self):
		out = generate.linkify_symbols('<img src="a.b.c" alt="x">text', self.LINKS)
		self.assertIn('<img src="a.b.c" alt="x">', out)

	def test_symbol_map_skips_the_module_row_itself(self):
		links = generate.add_symbol_links({}, {"cityrp.ui": [
			{"name": "cityrp.ui"}, {"name": "cityrp.ui.Scale"}]})
		self.assertNotIn("cityrp.ui", links)  # the module page is a type link, not a symbol anchor
		self.assertEqual(links["cityrp.ui.Scale"], "cityrp.ui.html#cityrp.ui.Scale")

	def test_deprecation_reason_gets_the_link(self):
		out = generate.render_callout_tags(
			{"deprecated": ["Use cityrp.help:addNew instead."]}, self.LINKS)
		self.assertIn('href="cityrp.help.html#cityrp.help.addNew"', out)


class DeprecationReasonTests(unittest.TestCase):
	"""LuaLS eats `@deprecated`'s text and exposes only a boolean, so the reason
	is read back off the source."""

	def _items(self, source, line_no):
		with TemporaryDirectory() as tmp:
			root = Path(tmp)
			(root / "x.lua").write_text(source, encoding="utf-8")
			items = [{"name": "f", "file": "x.lua", "start": (line_no, 0),
				"tags": {"deprecated": [""]}}]
			generate.scan_deprecation_reasons(root, items)
			return items[0]["tags"]["deprecated"]

	def test_reason_is_recovered_from_the_comment_block(self):
		source = "--- Does a thing.\n--- @deprecated Use cityrp.x instead.\n--- @state server\nfunction f() end\n"
		self.assertEqual(self._items(source, 3), ["Use cityrp.x instead."])

	def test_bare_deprecated_stays_empty(self):
		source = "--- Does a thing.\n--- @deprecated\nfunction f() end\n"
		self.assertEqual(self._items(source, 2), [""])

	def test_it_does_not_reach_past_the_comment_block(self):
		"""A deprecation on an earlier function must not be picked up by a later
		one that happens to sit below it."""
		source = ("--- @deprecated Belongs to the one above.\nfunction earlier() end\n"
			"\n--- Unrelated.\nfunction f() end\n")
		self.assertEqual(self._items(source, 4), [""])

	def test_missing_file_is_survivable(self):
		items = [{"name": "f", "file": "nope.lua", "start": (3, 0), "tags": {"deprecated": [""]}}]
		generate.scan_deprecation_reasons(Path("does-not-exist"), items)
		self.assertEqual(items[0]["tags"]["deprecated"], [""])

	def test_a_reason_that_already_survived_is_left_alone(self):
		items = [{"name": "f", "file": "x.lua", "start": (3, 0), "tags": {"deprecated": ["Kept."]}}]
		generate.scan_deprecation_reasons(Path("does-not-exist"), items)
		self.assertEqual(items[0]["tags"]["deprecated"], ["Kept."])


class StubFixtureTests(unittest.TestCase):
	"""`fixtures/stubs.lua` is the one place every rendering feature is visible
	at once, which is only useful while it stays complete. These fail when the
	generator grows a feature the stub does not demonstrate."""

	STUBS = Path(__file__).resolve().parent / "fixtures" / "stubs.lua"

	@classmethod
	def setUpClass(cls):
		cls.text = cls.STUBS.read_text(encoding="utf-8")
		cls.tags = set(re.findall(r"---\s*@([a-z]+)", cls.text))

	def test_every_callout_kind_is_demonstrated(self):
		shown = {generate.CALLOUT_TAG_ALIASES[tag] for tag in self.tags
			if tag in generate.CALLOUT_TAG_ALIASES}
		self.assertEqual(set(generate.CALLOUT_ORDER) - shown, set())

	def test_example_and_section_are_demonstrated(self):
		self.assertIn("example", self.tags)
		self.assertIn("section", self.tags)
		self.assertIn("alias", self.tags)

	def test_every_realm_is_demonstrated(self):
		states = set(re.findall(r"---\s*@state\s+(\w+)", self.text))
		self.assertLessEqual({"client", "server", "shared", "menu"}, states)

	def test_it_shows_both_kinds_of_type_link(self):
		self.assertIn("IMaterial", self.text)  # links to the wiki
		self.assertIn("table<", self.text)  # punctuation that must survive

	def test_it_avoids_tags_ci_rejects(self):
		"""standards-diff.py bans these repo-wide, so the showcase must not use
		them even though it is never loaded."""
		self.assertNotIn("usage", self.tags)
		self.assertNotIn("module", self.tags)
		self.assertNotIn("tparam", self.tags)

	def test_it_lives_outside_the_gamemode(self):
		"""Anything under the gamemode is exported to the published site, and
		these symbols are not real."""
		self.assertNotIn("gamemodes", self.STUBS.parts)


class CalloutTagTests(unittest.TestCase):
	def test_tag_renders_the_same_box_as_a_topic_alert(self):
		out = generate.render_callout_tags({"warning": ["Do not call this on a dead player."]})
		self.assertIn('<blockquote class="ll-alert ll-alert-warning">', out)
		self.assertIn('<p class="ll-alert-title">Warning</p>', out)
		self.assertIn("dead player", out)
		# Same markup a topic's `> [!WARNING]` produces, so one stylesheet covers both.
		topic = generate.render_markdown("> [!WARNING]\n> Body.\n")
		self.assertIn('<blockquote class="ll-alert ll-alert-warning">', topic)

	def test_every_wiki_style_tag_is_supported(self):
		for tag, title in [("ambig", "Ambiguous"), ("bug", "Bug"), ("deprecated", "Deprecated"),
				("internal", "Internal"), ("note", "Note"), ("validate", "Validate"),
				("warning", "Warning")]:
			out = generate.render_callout_tags({tag: ["Text."]})
			self.assertIn(f'<p class="ll-alert-title">{title}</p>', out, tag)

	def test_spellings_collapse_into_one_box(self):
		out = generate.render_callout_tags({"warns": ["One."], "warning": ["Two."]})
		self.assertEqual(out.count("ll-alert-warning"), 1)
		self.assertIn("One.", out)
		self.assertIn("Two.", out)

	def test_order_is_fixed_regardless_of_tag_order(self):
		out = generate.render_callout_tags({"note": ["n"], "bug": ["b"], "deprecated": ["d"]})
		self.assertLess(out.index("ll-alert-deprecated"), out.index("ll-alert-bug"))
		self.assertLess(out.index("ll-alert-bug"), out.index("ll-alert-note"))

	def test_valueless_tag_still_says_something(self):
		self.assertIn(generate.DEPRECATED_DEFAULT, generate.render_callout_tags({"deprecated": [""]}))
		self.assertIn("not been checked", generate.render_callout_tags({"validate": [""]}))

	def test_default_precedes_the_authors_text(self):
		out = generate.render_callout_tags({"deprecated": ["Use cityrp.x instead."]})
		self.assertLess(out.index(generate.DEPRECATED_DEFAULT), out.index("Use cityrp.x instead."))

	def test_note_has_no_stock_sentence(self):
		out = generate.render_callout_tags({"note": ["Just this."]})
		self.assertEqual(out.count("<p>"), 1)  # the body only; the title carries a class
		self.assertIn("<p>Just this.</p>", out)

	def test_unrelated_tags_are_ignored(self):
		self.assertEqual(generate.render_callout_tags({"state": ["server"], "uniqueid": ["x"]}), "")

	def test_tag_body_renders_markdown(self):
		out = generate.render_callout_tags({"bug": ["Breaks on `nil` input."]})
		self.assertIn("<code>nil</code>", out)


class ExampleTagTests(unittest.TestCase):
	def test_single_line_example(self):
		_, tags = generate.parse_ldoc_tags("Gets a value.\n@example ENV:Get(\"MY_VAR\")")
		out = generate.render_example(tags)
		self.assertIn('<p class="ll-arg-label">Example</p>', out)
		self.assertIn('<pre class="ll-example"><code>ENV:Get(&quot;MY_VAR&quot;)</code></pre>', out)

	def test_multi_line_example_keeps_its_lines(self):
		"""Prose tags fold continuations into one line; code must not."""
		_, tags = generate.parse_ldoc_tags(
			"Does a thing.\n@example local a = 1\n if a then\n   print(a)\n end")
		out = generate.render_example(tags)
		self.assertIn("local a = 1\nif a then\n  print(a)\nend", out)

	def test_usage_is_not_an_alias(self):
		"""standards-diff.py rejects @usage as an LDoc tag, so the docs must not
		render something CI refuses to let anyone write."""
		_, tags = generate.parse_ldoc_tags("Gets a value.\n@usage ENV:Get(\"X\")")
		self.assertEqual(generate.render_example(tags), "")

	def test_blank_line_ends_the_example(self):
		desc, tags = generate.parse_ldoc_tags("D.\n@example call()\n\nMore prose.")
		self.assertNotIn("More prose.", generate.render_example(tags))
		self.assertIn("More prose.", desc)

	def test_no_example_renders_nothing(self):
		self.assertEqual(generate.render_example({}), "")

	def test_example_is_escaped(self):
		_, tags = generate.parse_ldoc_tags("D.\n@example f(a < b, '<x>')")
		self.assertNotIn("<x>", generate.render_example(tags))


class TypeLinkTests(unittest.TestCase):
	LINKS = {"Player": "Player.html", "ITEM": "ITEM.html",
		"IMaterial": "https://wiki.facepunch.com/gmod/IMaterial",
		"Vector": "https://wiki.facepunch.com/gmod/Vector"}

	def test_base_game_type_links_to_the_wiki(self):
		self.assertEqual(generate.linkify_type("IMaterial", self.LINKS),
			'<a href="https://wiki.facepunch.com/gmod/IMaterial">IMaterial</a>')

	def test_our_own_type_links_to_our_page(self):
		self.assertEqual(generate.linkify_type("Player", self.LINKS),
			'<a href="Player.html">Player</a>')

	def test_primitives_and_generics_are_left_alone(self):
		for raw in ("string", "boolean|nil", "any", "fun(a: b): c", "T", "K"):
			self.assertNotIn("<a ", generate.linkify_type(raw, self.LINKS), raw)

	def test_punctuation_survives_and_is_escaped(self):
		self.assertEqual(generate.linkify_type("table<string, Player>", self.LINKS),
			'table&lt;string, <a href="Player.html">Player</a>&gt;')

	def test_union_links_each_member(self):
		out = generate.linkify_type("Vector|IMaterial|nil", self.LINKS)
		self.assertEqual(out.count("<a "), 2)
		self.assertIn("|nil", out)

	def test_unknown_capitalised_name_is_not_invented(self):
		self.assertEqual(generate.linkify_type("SomeUndocumentedThing", self.LINKS),
			"SomeUndocumentedThing")

	def test_optional_and_vararg_markers_survive(self):
		self.assertEqual(generate.linkify_type("Player?", self.LINKS),
			'<a href="Player.html">Player</a>?')
		self.assertEqual(generate.linkify_type("Player[]", self.LINKS),
			'<a href="Player.html">Player</a>[]')

	def test_our_page_wins_over_the_wiki_for_the_same_name(self):
		links = generate.build_type_links({"Player": [], "cityrp.ui": []}, {"Player", "IMaterial"})
		self.assertEqual(links["Player"], "Player.html")
		self.assertEqual(links["IMaterial"], "https://wiki.facepunch.com/gmod/IMaterial")

	def test_missing_submodule_yields_no_wiki_links(self):
		self.assertEqual(generate.scan_glua_classes(Path("does-not-exist")), set())


class ModuleKindTests(unittest.TestCase):
	"""Metatables and panels get their own sidebar sections, classified by where
	they are declared rather than by a tag each file has to remember."""

	def _item(self, name, file, module=None, depth=0, is_class=False):
		return {"name": name, "module": module or name, "file": file, "depth": depth,
			"explicit_module": None, "is_class": is_class, "tags": {}, "desc": "", "extends": None}

	def _scan(self, sources):
		with TemporaryDirectory() as tmp:
			root = Path(tmp)
			for rel, body in sources.items():
				path = root / rel
				path.parent.mkdir(parents=True, exist_ok=True)
				path.write_text(body, encoding="utf-8")
			return generate.scan_metatable_names(root, list(sources))

	def test_metatables_come_from_findmetatable_calls(self):
		self.assertEqual(self._scan({
			"core/metatables/sh_player.lua": 'local pMeta = FindMetaTable("Player")\n',
			"core/metatables/sh_vehicle.lua": 'local v = FindMetaTable( "Vehicle" )\n',
			"core/libraries/sh_logging.lua": "local Logger = {}\n",
		}), {"Player", "Vehicle"})

	def test_a_data_class_in_a_metatable_file_is_not_a_metatable(self):
		"""RankData lives in sh_player.lua and describes a rank, not a metatable —
		classifying by folder would sweep it in."""
		names = self._scan({"core/metatables/sh_player.lua":
			'--- @class RankData\nlocal pMeta = FindMetaTable("Player")\n'})
		self.assertEqual(names, {"Player"})

	def test_metatable_class_claims_its_members_without_a_namespace(self):
		"""Entity declares @class and nothing else, and LuaLS attributes that
		declaration to whichever file re-opens it first — so its members used to
		scatter onto an unrelated library page."""
		items = [
			self._item("Entity", "core/libraries/network/sh_store.lua", is_class=True),
			self._item("Entity.GetOwner", "core/libraries/sv_layers.lua", module="cityrp.layers"),
		]
		generate.assign_class_modules(items, {}, {"Entity"})
		self.assertEqual(items[1]["module"], "Entity")

	def test_class_not_extended_as_a_metatable_is_left_alone(self):
		items = [
			self._item("RankData", "core/metatables/sh_player.lua", is_class=True,
				module="cityrp.ranks"),
			self._item("RankData.order", "core/metatables/sh_player.lua", module="cityrp.ranks"),
		]
		generate.assign_class_modules(items, {}, {"Player"})
		self.assertEqual(items[1]["module"], "cityrp.ranks")

	def test_panel_modules_come_wholly_from_a_derma_folder(self):
		by_module = {
			"cityrp.derma.customizationMenu": [self._item("x", "core/derma/cl_customizationMenu.lua")],
			"plugins.clans.ui": [self._item("y", "core/plugins/clans/derma/cl_menu.lua")],
			"cityrp.ui": [self._item("z", "core/libraries/cl_ui.lua")],
		}
		self.assertEqual(generate.panel_modules(by_module, set()),
			{"cityrp.derma.customizationMenu", "plugins.clans.ui"})

	def test_a_library_with_one_panel_helper_is_not_a_panel(self):
		by_module = {"cityrp.ui": [
			self._item("a", "core/libraries/cl_ui.lua"),
			self._item("b", "core/derma/cl_helper.lua"),
		]}
		self.assertEqual(generate.panel_modules(by_module, set()), set())

	def test_sidebar_lists_each_group_once(self):
		by_module = {
			"Player": [self._item("Player", "core/metatables/sh_player.lua", is_class=True)],
			"cityrp.derma.menu": [self._item("m", "core/derma/cl_menu.lua")],
			"cityrp.ui": [self._item("u", "core/libraries/cl_ui.lua")],
		}
		sidebar = generate.render_sidebar(by_module, [], module_kinds={
			"metatables": {"Player"}, "panels": {"cityrp.derma.menu"}})
		self.assertIn("<h2>Metatables</h2>", sidebar)
		self.assertIn("<h2>Panels</h2>", sidebar)
		# Grouped modules must not also appear in the catch-all Modules list.
		self.assertEqual(sidebar.count("modules/Player.html"), 1)
		self.assertEqual(sidebar.count("modules/cityrp.derma.menu.html"), 1)
		self.assertIn("modules/cityrp.ui.html", sidebar)

	def test_groups_are_omitted_when_empty(self):
		by_module = {"cityrp.ui": [self._item("u", "core/libraries/cl_ui.lua")]}
		sidebar = generate.render_sidebar(by_module, [], module_kinds={})
		self.assertNotIn("<h2>Metatables</h2>", sidebar)
		self.assertNotIn("<h2>Panels</h2>", sidebar)
		self.assertIn("<h2>Modules</h2>", sidebar)


@unittest.skipUnless(DOCS_DIR.is_dir(), f"no docs tree at {DOCS_DIR}")
class DocsTreeLinkTests(unittest.TestCase):
	"""Runs the real `docs/` tree through the generator and checks its own links.

	`topics/` mirrors `docs/`, so moving a doc into or between folders changes
	its depth and silently invalidates every relative link into and out of it.
	That is not something review catches reliably — this is."""

	@classmethod
	def setUpClass(cls):
		# Same repo-blob rewriting the real build does, so escaped links are
		# resolved the way they will be on the site.
		topics = generate.load_topics(DOCS_DIR, "https://example.invalid/blob/master")
		cls.pages = generate.topic_pages(topics)
		cls.ids = {page["id"] for page in cls.pages}
		cls.anchors = {page["id"]: set(HEADING_ID_RE.findall(page["html"])) for page in cls.pages}

	def _internal_links(self):
		"""(source page id, href, target page id, anchor) for every link that is
		meant to land on another page of the site."""
		for page in self.pages:
			base = posixpath.dirname(page["id"])
			for href in generate.HREF_RE.findall(page["html"]):
				target, _, anchor = href.partition("#")
				if not target or target.startswith("/") or "://" in target:
					continue
				if not target.endswith(".html"):
					continue
				resolved = posixpath.normpath(posixpath.join(base, target))
				yield page["id"], href, resolved[:-len(".html")], anchor

	def test_every_internal_link_resolves_to_a_page(self):
		broken = [f"{source} -> {href}" for source, href, target, _ in self._internal_links()
			if target not in self.ids]
		self.assertEqual(broken, [], "links to pages that are not generated")

	def test_every_cross_page_anchor_exists(self):
		broken = [f"{source} -> {href}" for source, href, target, anchor in self._internal_links()
			if anchor and target in self.ids and anchor not in self.anchors[target]]
		self.assertEqual(broken, [], "links to headings that do not exist")

	def test_same_page_anchors_exist(self):
		broken = []
		for page in self.pages:
			own = self.anchors[page["id"]]
			for href in generate.HREF_RE.findall(page["html"]):
				if href.startswith("#") and href[1:] not in own:
					broken.append(f"{page['id']} -> {href}")
		self.assertEqual(broken, [], "links to headings that do not exist on their own page")

	def test_no_markdown_link_survives_rewriting(self):
		"""Every relative `.md` link should have become a page link or a repo
		link. One left as `.md` resolved to neither — a typo, or a doc that
		moved — and would 404 on the site."""
		dead = []
		for page in self.pages:
			for href in generate.HREF_RE.findall(page["html"]):
				target = href.partition("#")[0]
				if target.endswith(".md") and "://" not in target and not target.startswith("/"):
					dead.append(f"{page['id']} -> {href}")
		self.assertEqual(dead, [], "markdown links that resolve to nothing")

	def test_no_relative_link_escapes_the_docs_root(self):
		"""Only `docs/` is published, so a relative link above it has no page to
		land on; those are rewritten to the repo browser instead."""
		escaping = []
		for page in self.pages:
			base = posixpath.dirname(page["id"])
			for href in generate.HREF_RE.findall(page["html"]):
				target = href.partition("#")[0]
				if not target or target.startswith("/") or "://" in target:
					continue
				if posixpath.normpath(posixpath.join(base, target)).startswith("../"):
					escaping.append(f"{page['id']} -> {href}")
		self.assertEqual(escaping, [], "relative links pointing outside docs/")


if __name__ == "__main__":
	unittest.main()
