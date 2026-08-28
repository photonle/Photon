# Photon

## SimpleNet wire format

`Photon.SNet:Map` ([`shared/sh_simplenet.lua`](lua/autorun/photon/shared/sh_simplenet.lua)) assigns each
registered variable an index by call order, and that index — not the name — is what goes over the wire.

**Reorder, insert, and remove entries freely.** Two facts make the ordering disposable, and both are easy
to talk yourself out of:

- **Nothing persists the map.** No file, no cache, no save data. Every boot re-runs the `Map` calls and
  rebuilds the table from source, so there is no stored format to migrate and no previous ordering to stay
  compatible with.
- **Both realms always run the same source.** Clients execute the Lua the server sends them, so a player
  whose own Photon copy is out of date is forced into lockstep with the server's. The two realms cannot
  register different orders.

`NET.Bits` is derived from the entry count and recomputed on every registration, so crossing a
power-of-two boundary rewidens every index field on both realms at once. It needs no action; know it so a
changed bit width does not read as a bug.

Two things that live outside that file and go stale quietly:

- `Photon.SimpleNet.ValueChanged` runs on **both** realms, and they do not fire alike. The server runs it
  from `NET:Set` only when a value actually moves. The client runs it from `ApplyValue` on every receipt,
  so a resync repeats it for values that have not moved, and a full update replays the entire state of
  every vehicle in the PVS. Listeners have to be idempotent.
- [`meta/sh_simplenet.stubs.lua`](lua/autorun/photon/meta/sh_simplenet.stubs.lua) declares the generated
  `Set`/`Get` entity methods for LuaLS by hand. A new `Map` call needs a matching stub pair or the method
  works at runtime and is invisible to tooling and the docs site.
