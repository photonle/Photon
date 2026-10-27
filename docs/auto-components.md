---
title: Auto Components (Lightbars and Light Heads)
description: A copyable template for an auto component file, the reference for every field in it, and how a vehicle places one.
---

# Auto Components (Lightbars and Light Heads)

An auto component is a light you can bolt onto any vehicle: a lightbar, a dome light, a grille head.
It carries its own model, its own lights and its own patterns, so a vehicle only has to say where
it goes. Photon loads every file in `lua/autorun/photon/library/auto/`, from Photon itself and from
any addon that ships files under that path.

The template below is a complete component. Save it as a new file in that folder, change the name
and model, and it loads. Every field in it is explained after it.

```lua
AddCSLuaFile()

local name = "Example Dome Light"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/dome_light.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}
COMPONENT.Category = "Exterior"
COMPONENT.NotLegacy = true
COMPONENT.ForwardTranslation = true

-- "_1" and "_2" in Sections take these colours unless the vehicle overrides them.
COMPONENT.DefaultColors = {
	[1] = "RED",
	[2] = "BLUE",
}

-- How each light looks. Positions name one of these.
COMPONENT.Meta = {
	example_dome = {
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90,
		W = 6,
		H = 8,
		Sprite = "sprites/emv/visionslr",
		Scale = 2.75,
		WMult = 1,
	},
}

-- Where each light sits, relative to the component's model.
COMPONENT.Positions = {
	[1] = { Vector( -2, 0, 2.5 ), Angle( 0, -90, 0 ), "example_dome" },
	[2] = { Vector( 2, 0, 2.5 ), Angle( 0, -90, 0 ), "example_dome" },
}

-- Frames: which lights are lit together, and in what colour.
COMPONENT.Sections = {
	["auto_example_dome"] = {
		[1] = { { 1, "_1" } },
		[2] = { { 2, "_2" } },
		[3] = { { 1, "_1" }, { 2, "_2" } },
	},
}

-- Patterns: the order the frames play in. 0 is a dark frame.
COMPONENT.Patterns = {
	["auto_example_dome"] = {
		["steady"] = { 3 },
		["alternate"] = { 1, 1, 0, 2, 2, 0 },
		["flash"] = { 3, 0, 3, 0, 0, 0 },
	},
}

-- Which pattern each section plays in each of the vehicle's modes.
COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_example_dome"] = "steady" },
		M2 = { ["auto_example_dome"] = "alternate" },
		M3 = { ["auto_example_dome"] = "flash" },
	},
	Auxiliary = {},
	Illumination = {},
}

EMVU:AddAutoComponent( COMPONENT, name )
```

## How the tables connect

A light is drawn when its position appears in a frame that the current pattern is on:

1. **Positions** lists every light, by number. Each one names a **Meta** entry for how it looks.
2. **Sections** groups those numbers into frames. Frame 3 of `auto_example_dome` above is
   "light 1 in colour 1, and light 2 in colour 2".
3. **Patterns** plays a section's frames in order, one step per tick (20 a second).
4. **Modes** picks a pattern for each section, for each mode the vehicle's driver can select.

Photon renumbers everything when the component is placed, so the numbers and names here only have to
be unique inside this file. Two copies of the same component on one vehicle do not collide.

## Required fields

`EMVU.ValidateAutoComponent` checks every component once, at load. One that fails is skipped with an
error in the console naming the field, and every vehicle that places it loads without it.

| Field | Required |
| :--- | :--- |
| `Name` | Always. Set for you from the second argument of `EMVU:AddAutoComponent`. |
| `Meta` | Unless `Base` is set. Must be a table. |
| `Sections` | Unless `Base` is set. Must be a table. |
| `Patterns` | Unless `Base` is set. Must be a table. |
| `Positions` | Unless `Base` is set. Must be a table. |
| `Modes` | Unless `Base` is set. Must be a table. |
| `Modes.Primary` | Unless `Base` is set. Must be a table. |

Empty tables pass. The check is that the component will not error, not that it lights anything.

`Model` and `Category` are optional, but when present each must be a non-empty string. `Skin` is
optional, but when present must be a number.

Keep `Modes.Auxiliary` too, even when it is empty. It is not checked at load, but Photon reads it
without a guard on any vehicle with traffic advisor modes, and most have them.

## Field reference

### File-level

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `name` (the second argument to `EMVU:AddAutoComponent`) | string | Yes | The component's ID. Vehicles place it by this name, and it must be unique across every installed addon. |
| `Model` | model path | No | The prop spawned on the vehicle. Optional to the load check, but a component anyone is meant to see needs one. |
| `Skin` | number | No | The prop's skin. Default 0. A vehicle can override it. |
| `Bodygroups` | `{ { group, value }, ... }` | No | Bodygroups set on the prop. The spelling is `Bodygroups`, lower-case `g`: `BodyGroups` on a component is not read. A vehicle can override it, with its own spelling (see [Placing it on a vehicle](#placing-it-on-a-vehicle)). |
| `Category` | string | No | The group the component is listed under in Photon's editor, such as `"Exterior"` or `"Interior"`. |
| `DefaultColors` | `{ [n] = "COLOR" }` | No | The colour each `"_n"` placeholder in `Sections` takes when the vehicle does not set `Colorn`. Without it, no placeholder is replaced, the vehicle's `Colorn` values included, and each `"_n"` light draws white with a console warning. |
| `NotLegacy` | boolean | No, but set it | Use the placement angle and each position's angle as written. Without it, Photon applies the legacy rotation older components were authored against (a 90° yaw turn, with pitch and roll swapped), and positions written for the current format come out pointing the wrong way. |
| `ForwardTranslation` | boolean | No | Reads each position's angle as (−roll, yaw, pitch) before placing it. The template's angles are written with it on; turn it off only together with angles written for that. |
| `Base` | string | No | Inherit every field from another component by name, and override only the ones set here. See [Inheriting with Base](#inheriting-with-base). |

### Meta

`Meta` is a table of named light styles. Its fields are the same as a vehicle's own emergency light
meta and are documented in [Light Meta](emv-meta.md). For auto components, `W`, `H` and `EmitArray`
are multiplied by the vehicle's `Scale` for that placement.

### Positions

Each entry is `{ Vector position, Angle angle, "metaName" }`, numbered from 1 with no gaps.

| Index | Type | What it controls |
| :--- | :--- | :--- |
| 1 | Vector | Where the light sits, relative to the component model's origin. |
| 2 | Angle | Which way the light faces, relative to the model. |
| 3 | string | The `Meta` entry the light is drawn with. A name with no matching entry draws nothing, silently. |
| 4 | number, optional | Also cast a dynamic light, when the player has dynamic lights on. Must be a number, not `true`. |

### Sections

`Sections[sectionName]` is a list of frames, numbered from 1. Each frame is a list of lights lit
together:

| Index | Type | What it controls |
| :--- | :--- | :--- |
| 1 | number | A position number from `Positions`. |
| 2 | string | The colour: a name from [the colour list](emv-meta.md#colours), or `"_n"` to take colour `n` from the vehicle or `DefaultColors`. |
| 3 | number, optional | Brightness. Default 1. |

Name sections with an `auto_` prefix by convention. A section name only has to be unique in this
file.

### Patterns

`Patterns[sectionName][patternName]` is a list of frame numbers from that section, played in order
and looped. `0`, or any number with no frame, is a dark step. A pattern can be any length.

Patterns whose name ends in a phase letter, such as `"flashA"` and `"flashB"`, are picked instead of
`"flash"` when the vehicle sets `Phase = "A"` or `"B"` on a placement. Use them to make two copies of
a component flash out of step. A placement with a `Phase` and no matching pattern draws nothing in
that mode.

### Modes

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `Modes.Primary` | `{ [stage] = { [section] = "pattern" } }` | Yes | Patterns for the vehicle's primary light modes. The stage keys match the `Stage` of the vehicle's `EMV.Sequences.Sequences`, conventionally `M1`, `M2` and `M3`. |
| `Modes.Primary.ALERT` | `{ [section] = "pattern" }` | No | Patterns for the alert sequence. Without it, alert uses `M3`. |
| `Modes.Primary.BRAKE`, `REVERSE`, `PARK` | `{ [section] = "pattern" }` | No | Patterns shown while braking, reversing or parked. Each pattern named must exist, or that section is left out. |
| `Modes.Auxiliary` | `{ [stage] = { [section] = "pattern" } }` | Keep it, even empty | Patterns for the traffic advisor. The stage keys match the vehicle's `EMV.Sequences.Traffic`, conventionally `L`, `D` and `R`. |
| `Modes.Illumination` | `{ [stage] = { { position, "COLOR" }, ... } }` | No | Lights held on steady for an illumination mode such as takedown (`T`). Each entry is a position number and a colour, not a pattern. |

## Placing it on a vehicle

A vehicle places components through its `EMV.Auto` list. The full vehicle file is in
[Vehicle Emergency Lights](vehicle-emergency-lights.md); the part that places this component is:

```lua
EMV.Auto = {
	[1] = {
		ID = "Example Dome Light",
		Scale = 1,
		Pos = Vector( 0, -10, 80 ),
		Ang = Angle( 0, 0, 0 ),
		Color1 = "AMBER",
	},
}
```

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `ID` | string | Yes | The component's `name`. An ID that matches no loaded component is skipped with a console message. |
| `Pos` | Vector | Yes | Where the component's origin sits on the vehicle. |
| `Ang` | Angle | Yes | The component's rotation on the vehicle. |
| `Scale` | number | No | Size multiplier for the prop and its lights. Default 1. |
| `Color1`, `Color2`, ... | string | No | Overrides `DefaultColors[1]`, `[2]`, ... for this placement. |
| `Phase` | string | No | Appended to every `Modes.Primary` pattern name for this placement. See [Patterns](#patterns). |
| `Skin` | number | No | Overrides the component's `Skin`. |
| `BodyGroups` | `{ { group, value }, ... }` | No | Overrides the component's `Bodygroups`. Here the spelling is `BodyGroups`, capital `G`. |
| `SubMaterials` | `{ [index] = "material" }` | No | Submaterials set on the prop. |
| `RenderGroup`, `RenderMode` | number | No | The prop's render group and mode. |

## Inheriting with Base

A component with `Base` copies every top-level field it does not set from the named component, so a
colour variant only has to restate what differs:

```lua
AddCSLuaFile()

local COMPONENT = {}
COMPONENT.Base = "Example Dome Light"
COMPONENT.DefaultColors = {
	[1] = "AMBER",
	[2] = "AMBER",
}

EMVU:AddAutoComponent( COMPONENT, "Example Dome Light Amber" )
```

The copy is shallow: setting `Modes` replaces the whole of the base's `Modes`, not just the keys
you list. A component with `Base` is exempt from the required-field check, since its base supplies
them. If the base never loads, the component is skipped with a warning naming it.
