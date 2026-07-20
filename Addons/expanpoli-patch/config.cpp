// expanpoli-patch config.cpp
// =============================
// Standalone compatibility patch: ports Ivory Car Pack's siren audio, horn,
// takedown, and keybind system onto @Expansion Mod - Police (Expanpoli).
//
// Architecture:
//   Config handles:   CfgPatches dependency chain, CfgVehicles occlusion fix
//                     (config merge pattern on d3s_*_base classes), CfgFunctions
//   Scripts handle:   CBA keybinds + GetIn handler + one-time scan (postInit)
//   Functions handle: siren/horn/takedown audio loops (Ivory-based),
//                     Read Manual display
//
// Differs from mean_patch in:
//   - Occlusion target: d3s_*_base (parent Car_F) vs CRFT_Car_Base children
//   - Lightbar control: Expanpoli execVM scripts instead of animate
//   - Vehicle gate: single "EM_" prefix vs 6-prefix Mean gate
//   - CBA handler: registered on 17 concrete EM_* classes, not base classes
//     (Expanpoli has no shared EM base class)
//
// Ivory approach used:
//   - Variables ani_horn/ani_siren/ani_siren_todo/ani_lightbar/ani_lightbar_todo
//   - #particlesource + say3D for audio output
//   - CBA keybinds for controls
//   - Sound classes (ivory_ss2000_*) defined in Ivory_Data, used unchanged
// =============================

class CfgPatches
{
    class expanpoli_patch
    {
        requiredVersion = 0.1;
        requiredAddons[] = {"EM_Police_Faction", "Ivory_Data", "cba_main"};
        units[] = {};
        weapons[] = {};
    };
};

// ────────────────────────────────────────
// CfgVehicles — occlusion fix (interior siren audibility)
// ────────────────────────────────────────
//
// Same fix as mean_patch: occludeSoundsWhenIn = 2.5 and
// obstructSoundsWhenIn = 1 on the base classes so external
// sounds pass into the cabin properly.
//
// For Expanpoli, the 13 d3s_*_base classes all extend Car_F
// (not CRFT_Car_Base). The config merge pattern differs:
//   forward-declare Car_F, redefine with matching parent.
//
// Fixing at the _base level propagates to all police and
// civilian d3s-derived vehicles.
// ────────────────────────────────────────
class CfgVehicles
{
    class Car_F;

    class d3s_charger_15_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_crown_98_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_civic_17_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_explorer_13_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_tahoe_08_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_f86_15_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_f90_18_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_fseries_15_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_raptor_17_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_savana_05_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_taurus_10_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_malibu_18_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
    class d3s_insurgent_gtaV_base: Car_F {
        occludeSoundsWhenIn = 2.5;
        obstructSoundsWhenIn = 1;
    };
};

class CfgFunctions
{
    class expanpoli_patch
    {
        project = "expanpoli_patch";
        tag = "expanpoli_patch";
        class Init
        {
            class Init
            {
                postInit = 1;
                file = "\SCORPIO4938_\ivory-expanpoli-compact\Addons\expanpoli-patch\scripts\init.sqf";
            };
        };
        class vehicle
        {
            file = "\SCORPIO4938_\ivory-expanpoli-compact\Addons\expanpoli-patch\functions";
            class initCar {};
            class manual {};
            class sirens {};
            class takedown {};
            class horn {};
        };
    };
};
