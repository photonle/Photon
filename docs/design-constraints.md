---
title: Design Constraints
description: The standing constraints that decide how Photon is built, and what each one asks of you.
featured: true
---

# Design Constraints

The rules on this page are not style preferences. Each one exists because Photon is shaped by a
constraint that is not obvious from any single file, and code that ignores it tends to look
perfectly reasonable in review and then cost frames, or corrupt state, on a live server.

Each constraint states the rule, the reason it exists, and what it asks of you in practice.

## 1. The render path is built for throughput, so correctness is enforced at the entry points

**The rule.** Validate data where it enters Photon, once, and refuse to store anything that does
not pass. Never add per-frame validation to the render path, and never let unvalidated data reach
a cache.

### Why

The work in the render path multiplies. A server can hold hundreds of Photon vehicles; each vehicle
carries components; each component declares its own light positions. A single
[Whelen Liberty SX](../lua/autorun/photon/library/auto/whelen_liberty_sx_a.lua) declares dozens of
them, across component files that run to several hundred lines. Every one of those
positions can draw a sprite, draw a glow, and queue a dynamic light.

That product is evaluated **every frame**. A check that costs a fraction of a microsecond per
position is free in isolation and is not free when it runs on the whole product, every frame,
on a machine that is also rendering the rest of the map.

So the render path spends its budget on drawing, and buys that by assuming its inputs are already
correct. That assumption is the entry points' job to keep true.

### What the render path looks like

`Photon:RenderQueue` in [`cl_photon_eng.lua`](../lua/autorun/photon/cl_photon_eng.lua) walks a flat
array by index and unpacks each entry positionally into the draw call, 27 slots with no key
lookups, no type checks and no `IsValid`:

```lua
for i=1, count do
    if photonRenderTable[i] != nil then
        local data = photonRenderTable[i]
        renderFunction( data[1], data[2], ..., data[27], debug_mode )
    end
end
```

The same file localises every global it touches (`math.Clamp`, `render.GetLightColor`,
`util.PixelVisible`, `IsValid`, `EyePos`) into upvalues at load, and pools queue entries so that a
steady scene stops allocating altogether; `acquireLightEntry` reuses each entry's table, its
`Color`, and its rotated emit positions in place rather than rebuilding them.

Read that as a statement of intent. Code in this path is written the way it is *on purpose*, and
"tidying" it by reintroducing table lookups, allocations, or defensive checks undoes deliberate
work.

> [!WARNING]
> The one check that does live in the hot path is not a counter-example. `acquireLightEntry`
> tests the entry it is about to reuse for the pooled layout, because `AddLightToQueue` is public
> and an outside caller may have parked a foreign table at that index. That is **pool integrity**,
> protecting Photon's own invariant, not validation of vehicle or component data. Guards in this
> path bail cheaply; they never diagnose.

### What an entry point looks like

Contrast [`emv_sirens.lua`](../lua/autorun/photon/library/emv_sirens.lua). `EMVU.ValidateSiren`
checks every required field and every tone, and returns the first failure *with a reason*:

```lua
if not istable(siren.Set) or #siren.Set == 0 then
    return false, "missing required field 'Set' (must be a non-empty array of tones)"
end
```

`EMVU.AddCustomSiren` then refuses to insert a siren that fails, so `sirenTable`, the cache every
later read trusts, cannot hold a malformed entry. The loader wraps each siren file in
`CompileFile` plus `pcall`, so one broken third-party file is skipped with a named error instead of
taking down EMV init for everything else.

This is the shape to copy:

1. **Check at the boundary**, in the function that accepts the data.
2. **Report what is wrong and whose fault it is.** Name the offending file, component, or field,
   and where practical link the documentation for it. The author reading that error is usually not
   you.
3. **Skip the bad item, keep the rest running.** One malformed addon must never be fatal to Photon
   as a whole.
4. **Do not cache what did not pass.** Everything downstream is entitled to assume the cache is
   clean, because that assumption is the only reason the render path can be as bare as it is.

### The runtime backstop

Validation cannot catch everything, so
[`Photon.RunQuarantined`](../lua/autorun/photon/sh_photon_init.lua) exists for what gets through:
an entity whose Photon code errors is flagged, disabled, and reported once, and can be brought back
with `photon_quarantine_reset` after the data is fixed.

Treat it as the last line, not the plan. Reaching quarantine means a vehicle stopped working; a
load-time rejection means an author got a clear message and everyone else was unaffected.

### In practice

When you add code, ask which side of the line it is on:

| | Entry points (load, spawn, net receive, config parse) | Render path (per frame, per light) |
|---|---|---|
| Validate structure and types | Yes, exhaustively | No |
| Cost tolerance | Generous, this runs once | Counted in nanoseconds |
| On bad data | Reject with a named, actionable error | Assume it cannot happen |
| Allocation | Fine | Avoid; pool and reuse |
| Globals | Fine | Localise into upvalues |

If you find yourself wanting a `nil` check inside a per-light loop, the bug is upstream: something
was allowed into a cache that should have been rejected at the door. Fix it there.

## 2. Reads outnumber writes by orders of magnitude, so derived state is cached and owned

**The rule.** Compute derived values when their inputs change, not when they are drawn. Every cache
carries a known set of inputs and a defined moment it is rebuilt. Caching without owning
invalidation is worse than not caching at all.

### Why

Lighting state changes on human input: a keypress, a menu click, seconds apart. It is *read* by
every position on every component on every vehicle, every frame. Writes scale with player actions;
reads scale as vehicles × components × positions × framerate. The factor is multiplicative rather
than exponential, but it is large enough that work moved from the read side to the write side
effectively stops existing.

Constraint 1 is the precondition for this one. Caching derived values aggressively is only safe
because the inputs were validated at the door, and when a gate leaks the cache does not hold one
bad value, it holds everything derived from it, across every position that referenced it. The two
constraints pull in opposite directions on purpose: the first wants the cache to hold only what
passed, the second wants it to hold as much precomputed work as possible.

### What that looks like

`Photon.Vehicles.States.Headlights`, `.Brakes`, `.Blink_Left` and the rest
([`sh_photon_init.lua`](../lua/autorun/photon/sh_photon_init.lua)) are registries keyed by vehicle
name, populated as vehicle files load and read per frame thereafter. The render queue does the same
thing at frame scope: `acquireLightEntry` keeps each entry's table, its `Color` and its rotated emit
positions and rewrites them in place, so a steady scene converges on doing no allocation at all.

### The half that bites

Constraint 1 rarely reasons about staleness, because validated data is broadly write-once. Derived
data is not. A cached value with no defined invalidation is a bug that has not happened yet, and it
will surface as lighting that is correct until something changes and then quietly is not.

So for anything cached:

- **Name its inputs.** If you cannot list what it derives from, you cannot know when it is stale.
- **Rebuild at a defined moment**, on the write that invalidates it.
- **Do not verify freshness per frame.** A staleness check in the read path is precisely the cost
  this constraint exists to avoid. Push the work to the write, or accept the value as authoritative.
- **Define the key's lifecycle.** A cache keyed by vehicle name, entity or component needs an answer
  for what happens when that key is removed or reloaded.

### Where the gates are

Load, spawn, and net receive. The frame is downstream of all three and gates nothing, which is why
`acquireLightEntry`'s layout check is pool integrity rather than validation. Nothing validates per
frame, by design.

## 3. Photon is a guest in someone else's frame budget

**The rule.** Cost should scale with what is visible and relevant, not with what exists.

> [!NOTE]
> This is the one constraint on this page that describes an intention more than an implementation.
> It is written down because a contributor who assumes a level-of-detail layer exists will design
> against something that is not there, and because new work should not widen the gap.

### Why

Photon does not own the frame. The map, every other addon, every other Photon vehicle in the scene
and the player's hardware all spend from the same budget, and Photon cannot claim a fixed slice of
it. Scene density is not something it controls or can predict: the same vehicle is one car on an
empty map and one of forty at a callout.

### What exists today

- `util.PixelVisible`, via `Photon:CalculatePixVis`, a real gate; work is skipped for what the
  player cannot see.
- The FOV modifier, refreshed once per frame alongside the eye position rather than per light.
- `photon_dynamic_lights`, which defaults to **`0`**. The most expensive per-position feature is off
  until asked for, which is the pattern to copy for anything comparably costly.
- `photon_lens_effects` and `photon_bloom_modifier`, gating and scaling the screen-space pass.

`photon_stand_enabled` and `photon_emerg_enabled` are feature switches rather than quality tiers;
useful, but they do not make Photon cheaper in proportion to load.

### What does not exist

There is no level of detail, no per-scene budget, and no degradation under load. Distance is
computed in [`cl_photon_eng.lua`](../lua/autorun/photon/cl_photon_eng.lua), but it only modulates
the flare:

```lua
local dist = worldPos:Distance( useEyePos )
local distModifier = ( 1 - clamp( ( dist / 512 ), 0, 1) )
viewFlare = viewFlare * distModifier
```

A light far across the map fades visually and still runs the whole pipeline and still occupies a
queue slot. Cost falls off with visibility; it does not fall off with distance, or with how many
vehicles are on screen.

### In practice

New per-position work should come with an answer to "what turns this off". Prefer gating *before* an
entry is queued over making the draw cheap, since the queue slot and the per-frame walk are
themselves part of the cost. And defaulting an expensive feature to off is a legitimate answer, not
an admission of defeat; `photon_dynamic_lights` is the precedent.

## 4. Every piece of state needs a declared owner, a transport, and a cold-start answer

**The rule.** State may have more than one owner, but never an undeclared one. For anything the
player sees, know which side is authoritative, how the value travels, and what a client shows before
it has arrived.

### Why

The realm split is the most consequential fact about a Garry's Mod addon, and it forces three
questions on every piece of state: who decides it, how does it reach everyone else, and what does a
client render before it knows: on connect, on entering PVS, after a reconnect.

Photon answers the third for SimpleNet values with a resync queue
([`sh_simplenet.lua`](../lua/autorun/photon/shared/sh_simplenet.lua)), which requests state for
vehicles as they become known to the client, and with a default on every read:
`GetPhotonNet_Braking(false)`. A networked value with no sensible default is a flicker waiting to
happen.

### Prediction is legitimate, and it is a trap

Some state has to be predicted locally. A driver cannot wait for a round trip to see their own
indicator, so the client computes it and the server's value is the authority behind it. Multiple
owners are normal and often required.

What is not allowed is leaving that arrangement implicit. Where a value is predicted:

1. **Name the authority.** Which side wins.
2. **Bound the divergence.** What may differ, and for how long.
3. **Define reconciliation.** What happens when the authoritative value arrives and disagrees.
4. **Test from a client that is not predicting.** The predictor is structurally the one participant
   who cannot observe a replication failure.

> [!WARNING]
> That fourth point is the recurring shape, not a one-off. Regular lighting was invisible to
> everyone but the driver for a long time because `Photon_IsBraking` and `Photon_IsReversing`
> compute locally when the driver is `LocalPlayer` and only fall back to the networked value for
> other players. The author's own screen looked correct.

The underlying failure there was not that the state had two owners; it was that the predicted path
and the authoritative path sat on *different transports*, the client reading SimpleNet while the
server wrote only its legacy `NW2` var, with nothing reconciling them. That makes the divergence
permanent instead of transient, which is the difference between prediction and a bug.

## 5. Photon executes content it did not write and cannot fix

**The rule.** A bad file takes itself down and nothing else. Behaviour that shipped content already
depends on changes only when it was genuinely wrong, and never quietly.

### Why

The vehicle, component and siren library is third-party Lua, written by people of varying
experience, shipped years ago, running on servers nobody here will ever touch. It cannot be
migrated, patched, or asked to change. Both halves of this rule follow from that.

### Failure stays local

The siren loader compiles each file and calls it under `pcall`, so a broken third-party siren is
skipped with a named error instead of taking EMV init down with it. For what gets past load,
[`Photon.RunQuarantined`](../lua/autorun/photon/sh_photon_init.lua) disables the offending entity,
reports it once, and leaves everything else running until `photon_quarantine_reset`.

The blast radius of a mistake is somebody else's content, which is why isolation is architectural
here rather than a nicety.

### Compatibility, and when to break it

The ratchet applies to behaviour Photon *specified*. Behaviour that was simply wrong is a different
case: content authored against a bug has usually compensated for it, so fixing the bug moves that
content. "Never break" would mean never fixing anything.

The obligation is therefore not to avoid the break but to **narrow it and signpost it**.

**Narrowing** means confining a correctness fix to where equivalence is demonstrable. The
`Matrix:GetAngles()` fix for auto anchors is the model: rather than replacing the lossy round-trip
everywhere, it was scoped to pure-yaw anchors, where yaw being the outermost axis in Source's Euler
convention makes matrix composition and plain addition *provably* identical. Everything outside that
proof was left alone, so the residue is a known break rather than a diffuse one.

**Signposting** is the weaker half today. A content-affecting fix reaches the changelog through the
same `fix:` prefix as any other, so an author gets an entry that reads like routine maintenance with
nothing telling them their vehicle may now point the other way. If a change can move third-party
content, say so where authors will see it, and name what to re-check.
