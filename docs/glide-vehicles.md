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

Register Photon/EMV the same way as for any other vehicle:

1. `list.Set("Vehicles", className, { … HasPhoton / IsEMV / Photon / EMV … })` using the **scripted
   entity class** as the list key (Glide cars are not `prop_vehicle_jeep`), and/or
2. Model indexes in Photon's vehicle libraries, keyed to the chassis model Glide sets from
   `ChassisModel`.

Photon resolves Vehicles-list entries via class, `VehicleName`, and chassis model (see
`Photon.LookupVehiclesEntry`). Express Creator synthesises Class/Model from the entity when no
Vehicles entry exists, and leaves `vehiclescript` empty for Glide.

## Runtime helpers

| Helper | Role |
|--------|------|
| `Photon.IsGlideVehicle` | Detect Glide chassis |
| `Photon.IsPhotonChassis` | Stock vehicle **or** Glide chassis |
| `Photon.GetPlayerVehicle` | Seat → chassis for the local/driving player |
| `Photon.GetVehicleDriver` | Driver / Glide seat 1 |
| `Photon.GetForwardSpeedComponent` | `.x` on Glide, `.y` on HL2 |
| `Photon.UsesNativeVehicleLights` | Skip Photon PI sprites for car lights |

## Native vehicle lights

On Glide chassis, Photon **does not draw** PI sprites for headlights, running lights, brakes,
reverse, or indicators. Those come from Glide. Photon still draws ELS props and emergency
components as usual.

| Photon / input | Glide |
|----------------|-------|
| **H** (blackout key) | Cycles `HeadlightState`: **Off → On → Fullbeam → Off** |
| Blackout (`Photon_Blackout`) | `HeadlightState == 0` |
| Preferred beam | Last On (1) or Fullbeam (2) used while not blacked out |
| Turn signals / hazards | `TurnSignalState` 0–3 (same numbering as Photon) |
| Brakes / reverse | Glide native; Photon still tracks them for ELS brake/reverse sequences |

Do **not** author a second Photon Positions set for headlights / running / brakes / indicators on
Glide packs unless you intentionally want Photon sprites on top of Glide.

### ELS headlight flash (e.g. Stage 3 / 999)

When primary lights are on and the active sequence asks for headlights, Photon flashes Glide's
native `HeadlightState` (preferred beam ↔ Off) instead of drawing Photon headlight sprites.

Opt in with either:

```lua
-- On the primary sequence entry:
{ Name = "STAGE 3", Stage = "M3", Headlights = true, Components = { … } }
-- or GlideHeadlights = true
```

or a Components key whose name contains `"headlight"` (same as stock auto components such as
`auto_fpiu16_headlights`).

Blackout (Off) still wins: flashing stops while `HeadlightState` is 0 via **H**.
