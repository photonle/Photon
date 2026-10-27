---
title: Vehicle Lights (Headlights, Brakes and Indicators)
description: A copyable template for a vehicle's PI table, its own non-emergency lights, with every field explained.
---

# Vehicle Lights (Headlights, Brakes and Indicators)

`PI` (Photon Illumination) is the table for a vehicle's own lights: headlights, running lights, brake
lights, reverse lights and indicators. Emergency lights are a separate table, covered in
[Vehicle Emergency Lights](vehicle-emergency-lights.md); a vehicle can have either or both.

The template below is a complete vehicle file. Save it under `lua/autorun/` in your addon, change
the name, model and positions, and it loads. It uses the Half-Life 2 buggy so it works on any
install. Every field is explained after it.

```lua
AddCSLuaFile()

local name = "Example Photon Buggy"

local DR = "D_RED"
local A = "AMBER"
local SW = "S_WHITE"

local PI = {}

-- How each light looks. Positions name one of these.
PI.Meta = {
	headlight = {
		AngleOffset = -90,
		Sprite = "sprites/emv/crownvic_headlight",
		W = 13,
		H = 14,
		Scale = 2,
	},
	tail_light = {
		AngleOffset = 90,
		Sprite = "sprites/emv/crownvic_tail",
		W = 8,
		H = 8,
		Scale = 1,
		WMult = 1.5,
	},
	indicator = {
		AngleOffset = -90,
		Sprite = "sprites/emv/crownvic_marker",
		W = 8,
		H = 8,
		Scale = 2,
	},
}

-- Where each light sits on the vehicle model. The numbers are used by States.
PI.Positions = {
	[1] = { Vector( -25, 75, 30 ), Angle( 0, 0, 0 ), "headlight" },
	[2] = { Vector( 25, 75, 30 ), Angle( 0, 0, 0 ), "headlight" },
	[3] = { Vector( -25, -70, 35 ), Angle( 0, 0, 0 ), "tail_light" },
	[4] = { Vector( 25, -70, 35 ), Angle( 0, 0, 0 ), "tail_light" },
	[5] = { Vector( -30, 70, 32 ), Angle( 0, 0, 0 ), "indicator" },
	[6] = { Vector( 30, 70, 32 ), Angle( 0, 0, 0 ), "indicator" },
}

-- Which lights each state turns on: { position, colour, brightness }.
PI.States = {}
PI.States.Headlights = {
	{ 1, SW }, { 2, SW },
}
PI.States.Running = {
	{ 3, DR, 0.25 }, { 4, DR, 0.25 },
}
PI.States.Brakes = {
	{ 3, DR, 1 }, { 4, DR, 1 },
}
PI.States.Reverse = {}
PI.States.Blink_Left = {
	{ 5, A }, { 3, A },
}
PI.States.Blink_Right = {
	{ 6, A }, { 4, A },
}

list.Set( "Vehicles", name, {
	Name = name,
	Class = "prop_vehicle_jeep",
	Category = "Photon Examples",
	Author = "You",
	Model = "models/buggy.mdl",
	KeyValues = { vehiclescript = "scripts/vehicles/jeep_test.txt" },
	HasPhoton = true,
	Photon = PI,
} )
```

Photon reads the vehicle list once, a second after the map loads, so a new or edited vehicle file
needs a map change before it shows.

## Handing the table to Photon

Photon finds the table through the vehicle's entry in the spawn list:

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `Name` | string | Yes | The name Photon stores the lights under. Use the same string as the `list.Set` key. |
| `HasPhoton` | boolean | Yes | Marks the vehicle as one Photon manages. |
| `Photon` | table | Yes | The `PI` table. Without it, the vehicle spawns with no Photon lights at all. |

The other fields (`Class`, `Category`, `Author`, `Model`, `KeyValues`) are Garry's Mod's own vehicle
list fields, and are not Photon's.

A vehicle with emergency lights and no lights of its own sets `Photon = "PHOTON_INHERIT"` instead,
which gives it an empty `PI`.

## Field reference

### PI.Meta

A table of named light styles, the same shape as emergency light meta. Every field is documented in
[Light Meta](emv-meta.md). Required whenever `PI.Positions` is set: a vehicle with positions and no
meta errors on its first frame.

### PI.Positions

Each entry is `{ Vector position, Angle angle, "metaName" }`, keyed by number.

| Index | Type | What it controls |
| :--- | :--- | :--- |
| 1 | Vector | Where the light sits, relative to the vehicle model's origin. |
| 2 | Angle | Which way the light faces. With `AngleOffset` meta, the yaw is what counts. |
| 3 | string | The `PI.Meta` entry the light is drawn with. A name with no matching entry draws nothing, silently. |

Optional: a vehicle with no positions draws no lights and does not error.

### PI.States

Each state is a list of the lights it turns on, as `{ position, "COLOR", brightness }`:

| Index | Type | What it controls |
| :--- | :--- | :--- |
| 1 | number | A position number from `PI.Positions`. |
| 2 | string | The colour, from [the colour list](emv-meta.md#colours). An unknown name is not drawn. |
| 3 | number, optional | Brightness. Default 1. A running light at `0.25` and a brake light at `1` on the same position is how one bulb shows both. |

These are the only state names Photon reads. Every one is optional; a state left out never lights
anything.

| State | Lit when |
| :--- | :--- |
| `Headlights` | The headlights are on. |
| `Running` | Someone is driving the vehicle and it is not blacked out. |
| `Reverse` | The vehicle is reversing. |
| `Brakes` | The driver is braking. |
| `Blink_Left` | On the blink, while the left indicator is on and the vehicle is running, or the hazards are on. |
| `Blink_Right` | On the blink, while the right indicator is on and the vehicle is running, or the hazards are on. |

They apply in that order, so when two states light the same position, the later one wins: braking
over running, an indicator over braking. Names like `Brake_Lights` or `Parking` are ignored without a
warning. If both blink states are missing or empty, the indicator keys do nothing on that vehicle.

### PI.StateMaterials

Optional. Swaps a submaterial on the vehicle model instead of drawing a sprite, for lenses that
should look lit:

```lua
PI.StateMaterials = {
	["tail_lens"] = {
		Index = 4,
		States = {
			[0] = "models/example/tail_lens_off",
			["on"] = "models/example/tail_lens_on",
		},
	},
}

-- Then, in any state, an entry naming it with a leading underscore:
PI.States.Running = {
	{ 3, DR, 0.25 }, { 4, DR, 0.25 },
	{ "_tail_lens", "on" },
}
```

| Field | Type | What it controls |
| :--- | :--- | :--- |
| `Index` | number | The submaterial index on the vehicle model. |
| `States[0]` | material path, optional | The material shown when no state uses this entry. Without it, the model's own material is restored. |
| `States[name]` | material path | The material shown while a state holds `{ "_key", "name" }`. |

A `"_key"` in a state with no matching `StateMaterials` entry errors, and Photon stops drawing that
vehicle's lights.

### PI.Config

Optional.

| Field | Type | What it controls |
| :--- | :--- | :--- |
| `BlinkRate` | number | The indicator blink interval, in seconds. Default 0.4. |
