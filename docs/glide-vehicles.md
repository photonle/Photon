---
title: Glide Vehicles
description: Using Photon with StyledStrike's Glide vehicle base.
---

# Glide Vehicles

Photon supports [Glide](https://github.com/StyledStrike/gmod-glide) cars with runtime hooks
only. There is no automatic remapping of light positions.

## Local space

Photon `Positions` and EMV prop offsets are authored in **entity local space**.

| Base | Forward axis |
|------|----------------|
| Stock HL2 / `prop_vehicle_jeep` | Typically **+Y** |
| Glide chassis | **+X** (left is +Y) |

Write Glide pack configs in Glide local space. Reusing an HL2/Simfphys Position table on a Glide
chassis without editing the vectors will place lights on the wrong sides.

## Registration

Register Photon/EMV with a **unique** `list.Get("Vehicles")` key (Express uses
`name_steamid`). Do **not** key the entry by the Glide entity class alone — that makes every
spawn of that class look like the Photon pack.

```lua
list.Set("Vehicles", "my_f40_photon", {
	Name = "F40 Photon",
	Class = "glide_f40",           -- Glide SENT class
	Model = "models/.../chassis.mdl", -- ChassisModel
	IsEMV = true,
	EMV = EMV,
	HasPhoton = true,
	Photon = "PHOTON_INHERIT",
	-- KeyValues.vehiclescript can be empty for Glide
})
```

Spawn the Photon version from the **Vehicles** spawn menu (sandbox sets `VehicleName` to the
list key). Spawning the same chassis from Glide's own menu leaves `VehicleName` unset, so Photon
does **not** attach — same idea as keeping a stock jeep separate from its Photon twin.

A Glide chassis resolves its pack only from an explicit identity, checked in this order:

1. `VehicleTable`.
2. `PhotonVehicleName`, a Vehicles key or display Name. Use this when something else owns
   `VehicleName` (CityRP keeps an item id there). If it is set but does not resolve, Photon
   does not attach and does not fall back to `VehicleName`.
3. `VehicleName`, when it is a Vehicles key or display Name.

Class and chassis-model fallbacks stay off for Glide. Express Creator synthesises Class/Model
from the entity when no Vehicles entry exists, and leaves `vehiclescript` empty for Glide.

## Runtime helpers

| Helper | Role |
|--------|------|
| `Photon.IsGlideVehicle` | Detect Glide chassis |
| `Photon.IsPhotonChassis` | Stock vehicle **or** Glide chassis |
| `Photon.GetPlayerVehicle` | Seat → chassis for the driver; passengers get their seat back |
| `Photon.GetVehicleDriver` | Driver / Glide seat 1 |
| `Photon.GetForwardSpeedComponent` | `.x` on Glide, `.y` on HL2 |
| `Photon.UsesNativeVehicleLights` | Skip Photon PI sprites for car lights |

## Seats

Only the driver's seat (Glide seat 1) controls Photon, as on a stock vehicle. Passengers cannot
work the lights, siren or signals, and a passenger getting in or out does not change the
vehicle's running, brake or siren state.

## Brake and reverse

Photon reads brake and reverse state from Glide's own `IsBraking` and `IsReversing`, which follow
Glide's brake input and gear rather than raw keys, so they respect Glide keybinds.

## Native vehicle lights

On Glide chassis, Photon **does not draw** PI sprites for headlights, running lights, brakes,
reverse, or indicators. Those come from Glide. Photon still draws ELS props and emergency
components as usual.

| Photon concept | Glide |
|----------------|-------|
| **H** | Glide's own headlights bind (default **KEY_H**) — **Off → On → Fullbeam → Off**. Photon does **not** also handle H on Glide (that double-cycled and skipped low beam). |
| Blackout (`Photon_Blackout`) | Mirror of `HeadlightState == 0` (including Glide auto-headlights) |
| Preferred beam | Last On (1) or Fullbeam (2) while lights are on |
| Turn signals / hazards | `TurnSignalState` 0–3 (same numbering as Photon) |
| Brakes / reverse | Glide native; Photon still tracks them for ELS brake/reverse sequences |

Do **not** author a second Photon Positions set for headlights / running / brakes / indicators on
Glide packs unless you intentionally want Photon sprites on top of Glide.

### ELS headlight flash (e.g. Stage 3 / 999)

When primary lights are on and the active sequence asks for headlights, Photon pulses Glide's
native beam (preferred ↔ Off). If headlights were Off, flash **wakes** them using the last
preferred beam (or low beam). When the stage ends, that preferred beam is restored.

Opt in with either:

```lua
-- On the primary sequence entry:
{ Name = "STAGE 3", Stage = "M3", Headlights = true, Components = { … } }
-- or GlideHeadlights = true
```

or a Components key whose name contains `"headlight"` (same as stock auto components such as
`auto_fpiu16_headlights`).
