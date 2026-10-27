---
title: Vehicle Emergency Lights (EMV)
description: A copyable template for a vehicle's EMV table, its emergency lights and the auto components it carries, with every field explained.
---

# Vehicle Emergency Lights (EMV)

`EMV` is the table for a vehicle's emergency lights. It holds two kinds of light:

- **The vehicle's own**, built into its model: grille lights, hidden LEDs, flashing headlights. These
  are drawn from the vehicle's own `Meta`, `Positions`, `Sections` and `Patterns`.
- **Auto components** bolted onto it, such as a lightbar. Those carry their own lights and are
  placed through `EMV.Auto`. Writing one is covered in [Auto Components](auto-components.md).

`EMV.Sequences` ties both together into the modes the driver selects.

The template below is a complete vehicle file with two grille lights of its own and one auto
component, the one from the [Auto Components](auto-components.md) template. Save it under
`lua/autorun/` in your addon, change the name, model and positions, and it loads. It uses the
Half-Life 2 buggy so it works on any install.

```lua
AddCSLuaFile()

local name = "Example Photon Response Buggy"

local R = "RED"
local B = "BLUE"

local EMV = {}

-- How each of the vehicle's own lights looks.
EMV.Meta = {
	grille_led = {
		AngleOffset = -90,
		Sprite = "sprites/emv/led_single",
		W = 4,
		H = 4,
		Scale = 1.5,
	},
}

-- Where each of the vehicle's own lights sits on its model.
EMV.Positions = {
	[1] = { Vector( -10, 80, 30 ), Angle( 0, 0, 0 ), "grille_led" },
	[2] = { Vector( 10, 80, 30 ), Angle( 0, 0, 0 ), "grille_led" },
}

-- Frames: which lights are lit together, and in what colour.
EMV.Sections = {
	["grille"] = {
		[1] = { { 1, R } },
		[2] = { { 2, B } },
		[3] = { { 1, R }, { 2, B } },
	},
}

-- Patterns: the order the frames play in. 0 is a dark frame.
EMV.Patterns = {
	["grille"] = {
		["steady"] = { 3 },
		["wigwag"] = { 1, 1, 0, 2, 2, 0 },
		["quad"] = { 1, 0, 1, 0, 1, 0, 1, 0, 2, 0, 2, 0, 2, 0, 2, 0 },
	},
}

-- The modes the driver can select, and what plays in each.
EMV.Sequences = {
	Sequences = {
		{ Name = "CODE 1", Stage = "M1", Components = { ["grille"] = "steady" }, Disconnect = {} },
		{ Name = "CODE 2", Stage = "M2", Components = { ["grille"] = "wigwag" }, Disconnect = {} },
		{ Name = "CODE 3", Stage = "M3", Components = { ["grille"] = "quad" }, Disconnect = {} },
	},
	Traffic = {
		{ Name = "LEFT", Stage = "L", Components = {} },
		{ Name = "DIVERGE", Stage = "D", Components = {} },
		{ Name = "RIGHT", Stage = "R", Components = {} },
	},
}

-- Auto components placed on the vehicle.
EMV.Auto = {
	[1] = {
		ID = "Example Dome Light",
		Scale = 1,
		Pos = Vector( 0, -10, 80 ),
		Ang = Angle( 0, 0, 0 ),
	},
}

list.Set( "Vehicles", name, {
	Name = name,
	Class = "prop_vehicle_jeep",
	Category = "Photon Examples",
	Author = "You",
	Model = "models/buggy.mdl",
	KeyValues = { vehiclescript = "scripts/vehicles/jeep_test.txt" },
	IsEMV = true,
	EMV = EMV,
	HasPhoton = true,
	Photon = "PHOTON_INHERIT",
} )
```

Photon reads the vehicle list once, when the map loads, so a new or edited vehicle file needs a map
change before it shows.

## How the tables connect

A light is drawn when its position appears in a frame that the current pattern is on:

1. **Positions** lists each light by number, and names a **Meta** entry for how it looks.
2. **Sections** groups those numbers into numbered frames, each light with a colour.
3. **Patterns** plays a section's frames in order, one step per tick (20 a second), and loops.
4. **Sequences** picks a pattern for each section, for each mode the driver can select.

So in `CODE 2` above, the `grille` section plays `wigwag`: frame 1 (light 1 red) for two ticks, a
dark tick, frame 2 (light 2 blue) for two ticks, a dark tick, and round again.

Auto components fill in their own sections for each mode, matched by `Stage`. A component's
`Modes.Primary.M2` plays whenever the vehicle is in the sequence whose `Stage` is `M2`, so the
vehicle's `Sequences` list only its own sections.

## Handing the table to Photon

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `Name` | string | Yes | The name Photon stores the lights under. Use the same string as the `list.Set` key. |
| `IsEMV` | boolean | Yes | Marks the vehicle as one with emergency lights. |
| `EMV` | table | Yes | The `EMV` table. |
| `HasPhoton` | boolean | Yes | Marks the vehicle as one Photon manages. |
| `Photon` | table or `"PHOTON_INHERIT"` | Yes | The vehicle's own non-emergency lights. `"PHOTON_INHERIT"` gives it none; a `PI` table gives it headlights, brake lights and indicators, as in [Vehicle Lights](vehicle-lights.md). |

## Field reference

### EMV.Meta

A table of named light styles for the vehicle's own lights. Every field is documented in
[Light Meta](emv-meta.md). Optional when the vehicle has no lights of its own.

### EMV.Positions

Each entry is `{ Vector position, Angle angle, "metaName" }`, numbered from 1 with no gaps. Optional
when the vehicle has no lights of its own.

| Index | Type | What it controls |
| :--- | :--- | :--- |
| 1 | Vector | Where the light sits, relative to the vehicle model's origin. |
| 2 | Angle | Which way the light faces. |
| 3 | string | The `EMV.Meta` entry the light is drawn with. A name with no matching entry draws nothing, silently. |
| 4 | number, optional | Also cast a dynamic light, when the player has dynamic lights on. Must be a number, not `true`. |

### EMV.Sections

`EMV.Sections[sectionName]` is a list of frames, numbered from 1. Each frame is a list of lights lit
together:

| Index | Type | What it controls |
| :--- | :--- | :--- |
| 1 | number | A position number from `EMV.Positions`. |
| 2 | string | The colour, from [the colour list](emv-meta.md#colours). |
| 3 | number, optional | Brightness. Default 1. |

### EMV.Patterns

`EMV.Patterns[sectionName][patternName]` is a list of frame numbers from that section, played in
order and looped. `0`, or any number with no frame, is a dark step. Every section a sequence uses
needs a pattern table of the same name.

### EMV.Sequences

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `Sequences` | list of modes | Yes | The primary light modes, in the order the driver steps through them. |
| `Traffic` | list of modes | No | The traffic advisor modes. Leave it out, or empty, for a vehicle without one. |
| `Illumination` | list of modes | No | Steady lighting modes such as takedown and alley lights. See [Illumination](#illumination). |

Each mode in `Sequences` and `Traffic`:

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `Name` | string | Yes | The label on the HUD. |
| `Stage` | string | Yes | The key auto components match against. Use `M1`, `M2`, `M3` for primary modes and `L`, `D`, `R` for traffic: shipped components are written for those. |
| `Components` | `{ [section] = "pattern" }` | Yes | The pattern each of the vehicle's own sections plays. `{}` when only auto components light up. |
| `Disconnect` | list of numbers | No | `Sequences` only. Positions from the vehicle's `PI` table to turn off while this mode is on, such as headlights that the emergency lights replace. |

Photon fills in an `Alert` mode from the last entry in `Sequences`, and empty `Braking`, `Reverse`
and `Park` modes, so a vehicle never needs to declare those.

### Illumination

An illumination mode holds lights on steady instead of playing patterns, and can cast real light
onto the world:

```lua
EMV.Sequences.Illumination = {
	{
		Name = "TKDN",
		Icon = "takedown",
		Stage = "T",
		Components = { { 1, "WHITE" }, { 2, "WHITE" } },
		Lights = {
			{ Vector( 0, 25, 65 ), Angle( 20, 90, 0 ), "takedown" },
		},
	},
}

EMV.Lamps = {
	["takedown"] = {
		Color = Color( 255, 255, 255, 255 ),
		Texture = "effects/flashlight001",
		Near = 16,
		FOV = 100,
		Distance = 800,
	},
}
```

| Field | Type | What it controls |
| :--- | :--- | :--- |
| `Name` | string | The label on the HUD. |
| `Icon` | string | The HUD icon, such as `"takedown"`, `"alley-left"` or `"alley-right"`. |
| `Stage` | string | The key auto components' `Modes.Illumination` match against: `T` for takedown, `L` and `R` for alley lights, `F` for flood. |
| `Components` | `{ { position, "COLOR", brightness }, ... }` | Lights held on, as a list of lights rather than patterns. An illuminated position overrides any emergency pattern on it. |
| `Lights` | `{ { Vector, Angle, "lampName" }, ... }` | Projected lights cast onto the world, each named after an `EMV.Lamps` entry. |

### EMV.Auto

The list of auto components placed on the vehicle. Each entry needs `ID`, `Pos` and `Ang`, and can
set `Scale`, colours, a phase and more; every field is documented in
[Placing it on a vehicle](auto-components.md#placing-it-on-a-vehicle).

### Beyond lighting

An `EMV` table can carry more than lights: `Siren`, `Props`, `Presets`, `Selections`, `Liveries` and
others. They are not part of the lighting tables and are not covered here.
