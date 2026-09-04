---
title: Glide Vehicles
description: Using Photon with StyledStrike's Glide vehicle base.
---

# Glide Vehicles

Photon supports [Glide](https://github.com/StyledStrike/gmod-glide) cars the same way Photon 2
does: runtime hooks only. There is no automatic remapping of light positions and Photon does not
suppress Glide's own headlight, signal, or siren sprites.

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

Photon resolves the Vehicles-list entry from `ent:GetClass()` on Glide entities and from
`GetVehicleClass()` on stock vehicles.

## Built-in Glide lights

Photon leaves Glide lighting alone. If you want Photon-only lighting, clear or disable the
sprites / siren tables on the Glide entity definition itself.
