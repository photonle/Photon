---
title: Light Meta (Sprites and Glows)
description: A copyable template for the Meta table that sets how each light looks, with every field and colour explained.
---

# Light Meta (Sprites and Glows)

A `Meta` table is a set of named light styles: which sprite a light draws, how big it is, how far
its glow spreads, and which way it faces. Every position in a lighting table names one of these
styles, so ten identical LEDs share one entry.

The same shape is used in three places:

- A vehicle's own emergency lights: `EMV.Meta` ([Vehicle Emergency Lights](vehicle-emergency-lights.md)).
- An auto component: `COMPONENT.Meta` ([Auto Components](auto-components.md)).
- A vehicle's own headlights, brake lights and indicators: `PI.Meta` ([Vehicle Lights](vehicle-lights.md)).

The template below holds one entry of each common kind. Assign the table to whichever of those
your file uses, and keep the entries you need.

```lua
local Meta = {
	-- A fixed light head, aimed with an axis. The usual choice for new work.
	example_led = {
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90,
		Sprite = "sprites/emv/led_single",
		W = 4,
		H = 4,
		Scale = 1.5,
		WMult = 1,
	},

	-- A fixed light aimed by a yaw offset, as most vehicle lights are.
	example_tail = {
		AngleOffset = 90,
		Sprite = "sprites/emv/crownvic_tail",
		W = 8,
		H = 8,
		Scale = 1,
		WMult = 1.5,
	},

	-- A glow with no visible source, for light spilling from somewhere else.
	example_glow = {
		AngleOffset = 90,
		Sprite = "sprites/emv/blank",
		W = 0,
		H = 0,
		Scale = 3,
	},

	-- A rotating beacon.
	example_rotator = {
		AngleOffset = "R",
		Speed = 4,
		Sprite = "sprites/emv/circular_src",
		W = 6,
		H = 6,
		Scale = 2,
	},
}
```

## Aiming a light

Every light needs a facing, because its glow fades as the viewer moves off-axis. There are two ways
to give one, and each entry uses exactly one of them:

- **Legacy, with `AngleOffset`.** The light faces the yaw of its position's angle plus
  `AngleOffset`. Most vehicle lights use this: `90` for a light on the back of the car, `-90` for
  one on the front, with the position angles written to match. Without `NoLegacy`, `AngleOffset` is
  required: an entry without it errors, and Photon stops drawing that vehicle's lights.
- **Axis, with `NoLegacy = true`.** The light is turned about the vehicle's `DirAxis` by its
  position's roll minus `DirOffset`, then about the vehicle's up axis by its position's yaw. Use
  this for new light heads. `DirOffset` is required whenever `DirAxis` is set.

## Field reference

| Field | Type | Required | What it controls |
| :--- | :--- | :--- | :--- |
| `Sprite` | material path | Yes | The texture drawn for the light's source. `"sprites/emv/blank"` draws no source and keeps the glow. |
| `W` | number | Yes | Width of the source sprite. On an auto component, multiplied by the placement's `Scale`. |
| `H` | number | Yes | Height of the source sprite. On an auto component, multiplied by the placement's `Scale`. |
| `AngleOffset` | number, `"R"` or `"RR"` | Yes, unless `NoLegacy` | A number is added to the position's yaw to get the light's facing. `"R"` makes the light rotate. `"RR"` rotates it and also sways its position, for an oscillating light. |
| `Speed` | number | No | How fast an `"R"` or `"RR"` light rotates. Negative turns the other way. Default 2. |
| `NoLegacy` | boolean | No | Aim with `DirAxis` instead of `AngleOffset`. Without `DirAxis`, the light faces the vehicle's forward. |
| `DirAxis` | `"Up"`, `"Right"` or `"Forward"` | No | The vehicle axis the light is turned about. Only read when `NoLegacy` is set. |
| `DirOffset` | number | With `DirAxis` | Subtracted from the position's roll before turning about `DirAxis`. |
| `Scale` | number | No | Size of the glow, flare and bloom around the light. Default 1. |
| `WMult` | number | No | Widens the middle glow, for wide light heads. Default 1. |
| `SourceOnly` | boolean | No | Draw the source sprite and no glow, for small lights that should not bloom. |
| `Cheap` | boolean | No | Draw the glow with no source sprite and no lens flare. |
| `EmitArray` | `{ Vector, ... }` | No | Draw the glow at each of these offsets from the light instead of at its centre, for a long light head with one source sprite. On an auto component, scaled by the placement's `Scale`. |
| `SubmatID` | number | With `SubmatMaterial` | A submaterial index on the vehicle's model to swap while this light is lit. |
| `SubmatMaterial` | material path | With `SubmatID` | The material shown on `SubmatID` while this light is lit. It is cleared when the light goes out. |

`VisRadius` appears in many older files. It no longer does anything.

## Colours

A light's colour comes from the table that lights it (a section frame, a state, an illumination
mode), not from its meta. These are the colour names Photon defines:

| Name | Colour |
| :--- | :--- |
| `RED` | LED red |
| `BLUE` | LED blue |
| `AMBER` | LED amber |
| `WHITE` | LED white |
| `GREEN` | Green |
| `PURPLE` | Purple |
| `PINK` | Pink |
| `RED_HALOGEN` | Halogen red |
| `BLUE_HALOGEN` | Halogen blue |
| `D_RED` | Dark red, less bright than `RED`, for brake and tail lights |
| `DODGE_RED` | A second dark red |
| `D_AMBER` | Dark amber. It has no dynamic-light colour, so never use it on a position that casts one |
| `S_WHITE` | Soft, incandescent white |
| `C_WHITE` | Cool, halogen white |

An emergency light with a name not in this list draws white and logs a warning. A vehicle light
(`PI.States`) with one is not drawn at all.
