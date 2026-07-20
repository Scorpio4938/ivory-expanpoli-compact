# CONTEXT.md — Expanpoli Patch

Compatibility patch that ports the Ivory Car Pack siren/horn/keybind system onto @Expansion Mod - Police vehicles.

## Glossary

- **EM_Police_Faction** — Expanpoli's `CfgPatches` class for police vehicles (defines all 17 `EM_*` vehicle classes)
- **EM_*** — Prefix for Expanpoli police vehicle class names (e.g., `EM_Police_Charger`, `EM_Malibu`). All 17 concrete classes start with `EM_`
- **d3s_*_base** — Direct parent of each d3s vehicle family (e.g., `d3s_charger_15_base`). All extend `Car_F`. The EM_* classes inherit indirectly through these
- **Police_Sound** — Expanpoli's native siren state variable (0 = off, 1 = on). Controls a single-tone `say3D` loop. Replaced by Ivory's `ani_siren` for audio control
- **Code2 / Code3** — Expanpoli's lightbar state variables. `code2=0` = lights on, `Code2=1` = lights off (mirrors `Code3`). Controlled by scroll-wheel UserActions
- **Expanpoli lightbar scripts** — `CODE2_On.sqf`, `CODE2_Off.sqf`, `Lights_On.sqf`, `Lights_Off.sqf` — execVM'd by UserActions to toggle visual lightbar
- **Ivory variables** — `ani_siren` (0-4), `ani_siren_todo` (1-4), `ani_lightbar` (0/1+), `ani_lightbar_todo` (1), `ani_horn` (0/1), `ani_takedown` (0/1) — same naming as the Mean patch and Ivory Car Pack

## Architecture

Same approach as the `ivory-mean-compact` patch:

1. **Config** — `CfgPatches` dependencies, `CfgVehicles` occlusion fix on d3s_*_base classes (13 entries, merge pattern with `Car_F`), `CfgFunctions` declaration
2. **Scripts/init.sqf** — PostInit: CBA keybinds + CBA `GetIn` handler registration on all 17 EM_* classes + one-time scan for pre-crewed vehicles
3. **Functions** — `fn_initCar.sqf` (variables + spawn audio + addAction), `fn_sirens.sqf` (Ivory dual-dummy siren), `fn_horn.sqf` (hold-to-play), `fn_takedown.sqf` (hold-to-play), `fn_manual.sqf` (hint help)

## Key Decisions

- **Vehicle gate:** Single prefix check `_type find "EM_" >= 0` — broader than Mean's 6-prefix approach, covers all current and future EM_* vehicles
- **CBA handler:** Registered on 17 concrete EM_* class names (not base classes — Expanpoli has no shared EM base). `GetIn` event, not `init`, to avoid CBA re-init burst
- **Lightbar control:** Follows Expanpoli's native execVM logic — T toggles via `CODE2_On/Off.sqf` + `Lights_On/Off.sqf`, sets Expanpoli's `code2`/`code3`/`Police_Sound` variables alongside Ivory's `ani_lightbar`
- **Siren sounds:** Ivory's `ivory_ss2000_*` tones, not Expanpoli's single `Police_Siren`
- **Occlusion fix:** Added to the d3s_*_base level (13 base classes, all extend `Car_F`). Propagates to all d3s variants including non-police vehicles — harmless improvement

## Dependencies

- `EM_Police_Faction` — Expanpoli police vehicle addon
- `Ivory_Data` — Ivory Car Pack sound configs
- `cba_main` — CBA framework (keybinds, XEH)
