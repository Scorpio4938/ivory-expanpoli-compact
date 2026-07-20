# Spec: Ivory Siren System Patch for @Expansion Mod - Police

## Problem Statement

@Expansion Mod - Police (17 police vehicles across 13 d3s model families) uses a primitive siren system that:

- Has a **single siren tone** (`Police_Siren`, 5.088s cycle) with a hardcoded `say3D` + `sleep` loop
- Controls everything through scroll-wheel **UserActions** (Code 1/2/3) — no rebindable keyboard shortcuts
- Has **no multi-tone switching** (no Wail/Yelp/Priority/HiLo selection)
- Has **no hold-to-play horn** or **hold-to-play takedown** audio
- Has **no Read Manual** command
- Has **no interior audio fix** — `occludeSoundsWhenIn`/`obstructSoundsWhenIn` are absent from all vehicle configs, meaning external siren sounds are heavily muffled when heard from inside the cabin (same root cause as the Mean patch)

The Ivory Car Pack has a much more capable system — four realistic SS2000 siren tones, CBA-rebindable keybinds, a cancellable horn audio loop, a takedown tone, and a Read Manual reference. The goal is to port this system onto Expanpoli vehicles **without modifying the original Expanpoli or Ivory mod files**.

## Solution

A standalone compatibility patch addon (`expanpoli-patch`) that follows the **same proven architecture** as the `ivory-mean-compact` patch:

1. **Config-level occlusion fix** — adds `occludeSoundsWhenIn = 2.5` and `obstructSoundsWhenIn = 1` to all 13 `d3s_*_base` vehicle classes via the config merge pattern (forward-declare `Car_F`, redefine with matching parent). Propagates to all d3s-derived vehicles including the 17 EM_* police classes. No runtime cost.

2. **CBA `GetIn` handler registration** on all 17 concrete `EM_*` vehicle classes — triggered on first entry (player or AI), not at vehicle creation. Avoids the CBA XEH `init` re-init burst that caused loading screen hangs in the Mean patch. A one-time scan catches editor-placed AI already seated.

3. **CBA keybinds** registered in postInit — mirror Ivory's key mapping exactly (R for siren, F for horn, T for lightbar, 1-4 for tone select, Shift+R for next tone, C for takedown, \\ for manual). Gated by a single `_type find "EM_" >= 0` prefix check.

4. **Ivory audio functions** — same `fn_sirens.sqf` (dual-dummy `#particlesource` + `say3D`), `fn_horn.sqf` (single-dummy hold-to-play), `fn_takedown.sqf` (dual-dummy hold-to-play), `fn_initCar.sqf` (variables + spawn), `fn_manual.sqf` (hint with 8s auto-dismiss). Byte-for-byte identical to the Mean patch.

5. **Lightbar control adapts to Expanpoli's native logic** — instead of Mean's `_vcl animate` pattern, the T keybind execVMs Expanpoli's `CODE2_On.sqf`/`CODE2_Off.sqf` + `Lights_On.sqf`/`Lights_Off.sqf` scripts. Also sets Expanpoli's `code2`/`code3`/`Police_Sound` variables to keep the visual system consistent.

The Expanpoli and Ivory mods are **never modified** — they are only loaded as dependencies.

## User Stories

1. As a player driving an EM Charger, I want to press R to toggle the siren on/off, so that I can activate emergency audio with a single key
2. As a player driving an EM vehicle, I want pressing R (siren on) to also turn on the lightbar automatically, so that lights and siren activate together
3. As a player driving an EM vehicle, I want pressing R (siren off) to turn off only the siren while the lightbar stays on, so that I can run silent
4. As a player driving an EM vehicle, I want pressing T to toggle the lightbar, with turning the lightbar off also killing any active siren
5. As a player driving an EM vehicle, I want to press Shift+R to cycle through 4 siren tones (Wail→Yelp→Priority→HiLo)
6. As a player driving an EM vehicle, I want to press keys 1-4 to directly jump to a specific siren tone
7. As a player driving an EM vehicle, I want to hold F to sound the horn continuously
8. As a player driving an EM vehicle, I want all emergency keybinds to be rebindable in CBA Controls
9. As a player driving an EM vehicle, I want a "Read Manual" scroll-wheel action that shows the control reference
10. As a player using both Ivory and Expanpoli vehicles, I want the systems to not interfere with each other
11. As a player driving an EM Malibu UM, EM Explorer, EM Raptor, or any of the 17 variants, I want the same siren and keybind experience across all EM vehicles
12. As a server administrator, I want to install this patch by placing a single addon folder alongside the existing mods

## Implementation Decisions

### Addon architecture
- Single addon: `ivory-expanpoli-compact/Addons/expanpoli-patch/`
- CfgPatches class: `expanpoli_patch` (tag: `expanpoli-patch`)
- Required addons: `EM_Police_Faction`, `Ivory_Data`, `cba_main`
- Uses CBA CfgFunctions for SQF function compilation and postInit keybind registration
- P: drive paths: `\SCORPIO4938_\ivory-expanpoli-compact\Addons\expanpoli-patch\`

### Vehicle class hierarchy
All 17 EM_* police vehicles follow the same three-level inheritance:

```
Car_F → d3s_*_base → d3s_*_variant → EM_*
```

Example:
```
Car_F → d3s_charger_15_base → d3s_charger_15_CPP → EM_Police_Charger
Car_F → d3s_crown_98_base   → d3s_crown_98_PD    → EM_Police_CrownVic
Car_F → d3s_f86_15_base     → (self) d3s_f86_15_base → EM_Police_BMWX6
```

### Occlusion fix — config merge on d3s_*_base classes
Added to the 13 `d3s_*_base` classes (not the 16 d3s variant classes or 17 EM_* classes):

| # | Base class | Parent |
|---|---|---|
| 1 | `d3s_charger_15_base` | `Car_F` |
| 2 | `d3s_crown_98_base` | `Car_F` |
| 3 | `d3s_civic_17_base` | `Car_F` |
| 4 | `d3s_explorer_13_base` | `Car_F` |
| 5 | `d3s_tahoe_08_base` | `Car_F` |
| 6 | `d3s_f86_15_base` | `Car_F` |
| 7 | `d3s_f90_18_base` | `Car_F` |
| 8 | `d3s_fseries_15_base` | `Car_F` |
| 9 | `d3s_raptor_17_base` | `Car_F` |
| 10 | `d3s_savana_05_base` | `Car_F` |
| 11 | `d3s_taurus_10_base` | `Car_F` |
| 12 | `d3s_malibu_18_base` | `Car_F` |
| 13 | `d3s_insurgent_gtaV_base` | `Car_F` |

Config merge pattern (same as Mean):
```cpp
class Car_F;
class d3s_charger_15_base: Car_F {
    occludeSoundsWhenIn = 2.5;
    obstructSoundsWhenIn = 1;
};
```

Fixing at the `_base` level propagates to all police AND civilian d3s variants — a harmless improvement for non-police vehicles.

### CBA handler — GetIn on 17 concrete EM_* classes
Registered in postInit via `CBA_fnc_addClassEventHandler`:

```
EM_Malibu, EM_Malibu_UM,
EM_Police_Charger, EM_Police_CrownVic, EM_Police_Civic,
EM_Police_Explorer, EM_Police_Explorer_UM,
EM_Police_BMWX6, EM_Police_BMWX6_UM, EM_Police_BMWM5,
EM_Police_Insurgent,
EM_Police_Raptor, EM_Police_Raptor_UM,
EM_Police_Savana, EM_Police_Taurus, EM_Police_Taurus_UM,
EM_Police_F550_SWAT
```

Uses `GetIn` (not `init`) — CBA does NOT re-fire GetIn for existing objects, so zero work during loading. No loading screen hang. A one-time scan catches editor-placed AI.

### Vehicle gate macro
Single prefix check, broader than Mean's 6-prefix approach:
```sqf
#define MEAN_VEHICLE_GATE \
    private _vcl = vehicle player; \
    if (isNull _vcl) exitWith {}; \
    private _type = typeOf _vcl; \
    if (_type find "EM_" < 0) exitWith {};
```

Covers all current and future EM_* vehicles.

### Key bindings (same as Mean patch)

| Key | Action |
|---|---|
| F (hold) | Horn |
| R | Siren on/off |
| Shift+R | Next siren tone (Wail→Yelp→Priority→HiLo→Wail) |
| 1 | Siren: Wail |
| 2 | Siren: Yelp |
| 3 | Siren: Priority |
| 4 | Siren: HiLo |
| T | Lightbar on/off |
| C (hold) | Takedown tone |
| \\ | Read Manual |

### Lightbar control — adapted to Expanpoli's native logic

Expanpoli's scroll-wheel UserActions use execVM scripts for visual lightbar control:

| Action | Variables set | Scripts execVM'd |
|---|---|---|
| Code1 (Off) | `Code2=1, Code3=1, Police_Sound=0` | `CODE2_Off.sqf` + `Lights_Off.sqf` |
| Code2 (Lights) | `code2=0, code3=0, Police_Sound=0` | `CODE2_On.sqf` + `Lights_On.sqf` |
| Code3 (Lights+Siren) | `code2=0, code3=0, Police_Sound=1` | `CODE2_On.sqf` + `Lights_On.sqf` |

Our **T keybind** follows this logic:

| Press | Ivory vars | Expanpoli vars | Scripts |
|---|---|---|---|
| ON | `ani_lightbar = todo` | `code2=0, code3=0, Police_Sound=0` | execVM Code2_On + Lights_On |
| OFF | `ani_lightbar=0, ani_siren=0` | `Code2=1, Code3=1, Police_Sound=0` | execVM Code2_Off + Lights_Off |

Our **R keybind**:

| Press | Ivory vars | Expanpoli vars | Scripts |
|---|---|---|---|
| ON | `ani_lightbar + ani_siren` from todo | `code2=0, code3=0, Police_Sound=0` | execVM Code2_On + Lights_On |
| OFF | `ani_siren = 0` (lightbar stays) | (unchanged) | (none) |

### Siren audio system
- Uses Ivory's `CfgSounds` entries: `ivory_ss2000_wail`, `ivory_ss2000_yelp`, `ivory_ss2000_priority`, `ivory_ss2000_hilo`, `ivory_ss2000_airhorn`
- **Not** using Expanpoli's native `Police_Siren` (single-tone, 5.088s cycle)
- Dual-dummy `#particlesource` + `say3D` pattern (cancellable, no loop-boundary gaps)
- Horn uses single-dummy hold-to-play with spawned inner loop
- Takedown uses dual-dummy hold-to-play (priority tone when siren active and not priority mode, wail otherwise)
- All audio functions are identical to the Mean patch — no code changes needed

### InitCar bridge function
- Sets Ivory-compatible variables: `ani_horn`, `ani_siren`, `ani_siren_todo`, `ani_lightbar`, `ani_lightbar_todo`
- All variables are public broadcast (`setVariable [..., true]`) for MP sync
- Spawns three audio functions: `mean_patch_fnc_horn`, `mean_patch_fnc_sirens`, `mean_patch_fnc_takedown`
- Adds "Read Manual" scroll-wheel action (runtime, not config)
- Called from GetIn handler + one-time scan, not from init

### File structure
```
ivory-expanpoli-compact/
  Addons/
    expanpoli-patch/
      config.cpp                    CfgPatches, CfgVehicles occlusion fix (13 bases), CfgFunctions
      scripts/
        init.sqf                    CBA keybinds + GetIn handler registrations + one-time scan (postInit)
      functions/
        fn_initCar.sqf              Vehicle init (variables + spawn audio + addAction)
        fn_sirens.sqf               Dual-dummy siren loop (4 tones, cancellable)
        fn_horn.sqf                 Hold-to-play horn (single dummy, cancellable)
        fn_takedown.sqf             Hold-to-play takedown (dual-dummy)
        fn_manual.sqf               Read Manual display (hint, 8s auto-dismiss)
```

## Prior Art

Both the Ivory Car Pack and the completed `ivory-mean-compact` patch serve as reference implementations. The Expanpoli patch reuses the identical audio functions from the Mean patch and adapts only the vehicle-specific parts (class names, occlusion targets, lightbar trigger mechanism).

## Out of Scope

- **Helicopter**: `EM_Police_EC635` is listed in `units[]` but is not a ground vehicle and is excluded from this patch
- **Lightbar visuals**: The physical lightbar is handled by Expanpoli's native execVM scripts — our keybinds trigger them, we do not replace them
- **Radar/police equipment**: Unchanged from Expanpoli's native system
- **d3s civilian vehicles**: While the occlusion fix applies to them (harmless side-effect), the Ivory keybinds and audio system only activate on EM_*-prefixed police vehicles
- **Ivory megaphone, GPS, cruise control**: Not ported — same as the Mean patch

## Differences from Mean Patch

| Aspect | Mean | Expanpoli |
|---|---|---|
| Vehicle count | 37 concrete classes | 17 concrete classes |
| Base class count (occlusion) | 6 (CRFT_Car_Base children) | 13 (d3s_*_base classes) |
| Base class parent | CRFT_Car_Base | Car_F |
| Vehicle gate | 6-prefix match | 1-prefix match (`EM_`) |
| CfgPatches dependency | `Police`, `Meanscars` | `EM_Police_Faction` |
| Lightbar trigger | `_vcl animate ["ani_lightbar",...]` | execVM `CODE2_On/Off.sqf` + `Lights_On/Off.sqf` |
| Vanilla siren variable | `ani_sirens` (animation source) | `Police_Sound` (variable) |
| Vanilla lightbar vars | `ani_lightbar` (animation) | `code2`, `code3` (variables) |
